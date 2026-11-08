package render;

import flixel.FlxSprite;
import flixel.graphics.tile.FlxGraphicsShader;
import flixel.util.FlxColor;
import lime.graphics.opengl.GLProgram;
import openfl.display.BitmapData;

/**
	Runtime-compiled GLSL shader for mods.
	Mod sources are plain fragment/vertex text files that may use the standard
	`#pragma header` / `#pragma body` markers; the markers are resolved here at
	runtime (openfl only resolves them at compile time through ShaderMacro), and
	missing headers can be injected automatically before the GL program is built.
	Uniforms are written through the openfl ShaderParameter tables, so values set
	before the first GL init are kept in `store` and flushed once parameters exist.
**/
class ModShader extends FlxGraphicsShader
{
	public static var instance:ModShader = null;

	/**
		openfl fragment declarations injected ahead of the flixel block
		(mirrors openfl.display.DisplayObjectShader's @:glFragmentHeader,
		which the compile-time macro merges in but the runtime path does not).
	**/
	public static var OPENFL_FRAGMENT_HEADER:String = "
		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;

		uniform bool openfl_HasColorTransform;
		uniform sampler2D openfl_Texture;
		uniform vec2 openfl_TextureSize;
	";

	/**
		Flixel fragment declarations injected in place of `#pragma header`
		(mirrors flixel.graphics.tile.FlxGraphicsShader's @:glFragmentHeader).
	**/
	public static var HEADER_DECLARATIONS:String = "
		uniform bool hasTransform;
		uniform bool hasColorTransform;

		vec4 flixel_texture2D(sampler2D bitmap, vec2 coord)
		{
			vec4 color = texture2D(bitmap, coord);
			if (!hasTransform)
			{
				return color;
			}

			if (color.a == 0.0)
			{
				return vec4(0.0, 0.0, 0.0, 0.0);
			}

			if (!hasColorTransform)
			{
				return color * openfl_Alphav;
			}

			color = vec4(color.rgb / color.a, color.a);

			mat4 colorMultiplier = mat4(0);
			colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
			colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
			colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
			colorMultiplier[3][3] = openfl_ColorMultiplierv.w;

			color = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);

			if (color.a > 0.0)
			{
				return vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
			}
			return vec4(0.0, 0.0, 0.0, 0.0);
		}
	";

	/**
		openfl display-object declarations injected in place of a vertex
		`#pragma header` (mirrors openfl.display.DisplayObjectShader).
	**/
	public static var OPENFL_VERTEX_HEADER:String = "
		attribute float openfl_Alpha;
		attribute vec4 openfl_ColorMultiplier;
		attribute vec4 openfl_ColorOffset;
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;

		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;

		uniform mat4 openfl_Matrix;
		uniform bool openfl_HasColorTransform;
		uniform vec2 openfl_TextureSize;
	";

	/**
		Flixel vertex extras: the attributes flixel's draw pipeline binds on
		every draw call, on top of the openfl header.
	**/
	public static var FLIXEL_VERTEX_HEADER:String = "
		attribute float alpha;
		attribute vec4 colorMultiplier;
		attribute vec4 colorOffset;
		uniform bool hasColorTransform;
	";

	public static var FLIXEL_VERTEX_BODY:String = "
		openfl_Alphav = openfl_Alpha * alpha;

		if (hasColorTransform)
		{
			openfl_ColorOffsetv = colorOffset / 255.0;
			openfl_ColorMultiplierv = colorMultiplier;
		}
	";

	public static var SAMPLER_PATTERN:EReg = ~/uniform\s+sampler2D\s+([A-Za-z0-9_]+)/;
	static var UNIFORM_PATTERN:EReg = ~/uniform\s+([A-Za-z0-9]+)\s+([A-Za-z0-9_]+)/;

	public var shaderName:String = 'ModShader';
	public var sourcePath:String = null;
	public var enabled:Bool = true;
	public var autoTime:Bool = false;
	public var autoInjectHeader:Bool = true;
	public var compileError:String = null;
	public var headerWasInjected:Bool = false;

	var attached:Dynamic = null;
	var _pending:Map<String, Dynamic> = new Map<String, Dynamic>();
	var _pendingColors:Map<String, FlxColor> = new Map<String, FlxColor>();
	var _pendingAlphas:Map<String, Float> = new Map<String, Float>();
	var _pendingTime:Null<Float> = null;
	var _timeParam:String = null;
	var boundBitmaps:Map<String, BitmapData> = new Map<String, BitmapData>();
	var uniform:Map<String, Dynamic> = new Map<String, Dynamic>();
	var store:Map<String, Dynamic> = new Map<String, Dynamic>();
	var components:Array<String> = [];
	var timeValue:Float = 0;

	static var TIME_NAMES:Array<String> = ['uTime', 'iTime', 'time', 'u_time', 'shadertime'];

	public function new(?shaderName:String = null, ?fragmentSource:String = null, ?vertexSource:String = null)
	{
		super();
		if (shaderName != null) this.shaderName = shaderName;
		if (instance == null) instance = this;
		if (fragmentSource != null) setFragmentSource(fragmentSource);
		if (vertexSource != null) setVertexSource(vertexSource);
	}

	public static function boot():ModShader
	{
		if (instance == null) instance = new ModShader();
		return instance;
	}

	public function setFragmentSource(source:String):String
	{
		source = prepareFragment(source);
		glFragmentSource = source;
		parseComponents();
		return source;
	}

	public function setVertexSource(source:String):String
	{
		source = prepareVertex(source);
		glVertexSource = source;
		parseComponents();
		return source;
	}

	public function hasHeaderPragma(source:String):Bool
	{
		return source != null && (source.indexOf('#pragma header') != -1 || source.indexOf('#pragma body') != -1);
	}

	public static function needsHeader(source:String):Bool
	{
		return source != null && source.indexOf('#pragma header') == -1;
	}

	public static function stripVersion(source:String):String
	{
		if (source == null) return source;
		while (true)
		{
			var idx:Int = source.indexOf('#version');
			if (idx == -1) break;
			var end:Int = source.indexOf('\n', idx);
			if (end == -1) end = source.length;
			source = source.substr(0, idx) + source.substr(end + 1);
		}
		return source;
	}

	/**
		Removes pragma-looking text inside block comments so the markers inside
		commented-out code are not treated as real pragmas.
	**/
	public static function stripPragmasInComments(source:String):String
	{
		if (source == null) return source;
		var out:String = source;
		var search:Int = 0;
		while (true)
		{
			var start:Int = out.indexOf('/*', search);
			if (start == -1) break;
			var end:Int = out.indexOf('*/', start + 2);
			var block:String = end == -1 ? out.substr(start + 2) : out.substr(start + 2, end - start - 2);
			var cleaned:String = StringTools.replace(block, '#pragma', '// pragma');
			if (cleaned != block)
			{
				out = out.substr(0, start + 2) + cleaned + (end == -1 ? '' : out.substr(end));
				search = start + 2 + cleaned.length;
			}
			else
				search = (end == -1 ? out.length : end + 2);
		}
		return out;
	}

	public function prepareFragment(source:String):String
	{
		if (source == null) return null;
		source = stripVersion(source);
		source = stripPragmasInComments(source);
		headerWasInjected = false;
		if (source.indexOf('#pragma header') != -1)
		{
			source = StringTools.replace(source, '#pragma header', OPENFL_FRAGMENT_HEADER + HEADER_DECLARATIONS);
			headerWasInjected = true;
		}
		else if (autoInjectHeader && needsHeader(source))
		{
			source = OPENFL_FRAGMENT_HEADER + HEADER_DECLARATIONS + '\n' + source;
			headerWasInjected = true;
			trace('[ModShader] WARN: ' + shaderName + ' had no #pragma header - added automatically');
		}
		source = StringTools.replace(source, '#pragma body', '');
		return source;
	}

	public function prepareVertex(source:String):String
	{
		if (source == null) return null;
		source = stripVersion(source);
		source = stripPragmasInComments(source);
		if (source.indexOf('#pragma header') != -1)
			source = StringTools.replace(source, '#pragma header', OPENFL_VERTEX_HEADER + FLIXEL_VERTEX_HEADER);
		else if (autoInjectHeader && needsHeader(source))
			source = OPENFL_VERTEX_HEADER + FLIXEL_VERTEX_HEADER + '\n' + source;
		source = StringTools.replace(source, '#pragma body', FLIXEL_VERTEX_BODY);
		return source;
	}

	function parseComponents():Void
	{
		components = [];
		for (src in [glVertexSource, glFragmentSource])
		{
			if (src == null) continue;
			var pos:Int = 0;
			while (UNIFORM_PATTERN.matchSub(src, pos))
			{
				var name:String = UNIFORM_PATTERN.matched(2);
				if (!Lambda.has(components, name)) components.push(name);
				pos = UNIFORM_PATTERN.matchedPos().pos + UNIFORM_PATTERN.matchedPos().len;
			}
		}
	}

	public function hasUniform(name:String):Bool
	{
		if (name == null) return false;
		if (Reflect.hasField(data, name)) return true;
		return Lambda.has(components, name);
	}

	public function hasValue(name:String):Bool
	{
		if (store.exists(name)) return true;
		var arr:Array<Dynamic> = readUniform(name);
		return arr != null && arr.length > 0 && arr[0] != null;
	}

	function readUniform(name:String):Array<Dynamic>
	{
		var p:Dynamic = Reflect.field(data, name);
		if (p == null) return null;
		try
		{
			return p.value;
		}
		catch (e:Dynamic) { return null; }
	}

	function paramOf(name:String):Dynamic
	{
		if (name == null) return null;
		if (uniform.exists(name)) return uniform.get(name);
		var p:Dynamic = Reflect.field(data, name);
		if (p != null) uniform.set(name, p);
		return p;
	}

	function applyUniform(name:String, value:Dynamic):Bool
	{
		if (name == null || value == null) return false;
		store.set(name, value);
		var p:Dynamic = paramOf(name);
		if (p == null) return false;
		try
		{
			if (Std.isOfType(value, BitmapData)) p.input = value;
			else p.value = value;
			return true;
		}
		catch (e:Dynamic)
		{
			reportError(shaderName, e);
			return false;
		}
	}

	public function setBool(name:String, value:Bool):Bool
	{
		return applyUniform(name, [value]);
	}

	public function setBoolArray(name:String, value:Array<Bool>):Bool
	{
		return applyUniform(name, value);
	}

	public function setFloat(name:String, value:Float):Bool
	{
		return applyUniform(name, [value]);
	}

	public function setFloatArray(name:String, value:Array<Float>):Bool
	{
		return applyUniform(name, value);
	}

	public function setInt(name:String, value:Int):Bool
	{
		return applyUniform(name, [value]);
	}

	public function setIntArray(name:String, value:Array<Int>):Bool
	{
		return applyUniform(name, value);
	}

	public function setBoolIfExists(name:String, value:Bool):Bool
	{
		if (!hasUniform(name)) return false;
		return setBool(name, value);
	}

	public function setFloatIfExists(name:String, value:Float):Bool
	{
		if (!hasUniform(name)) return false;
		return setFloat(name, value);
	}

	public function setIntIfExists(name:String, value:Int):Bool
	{
		if (!hasUniform(name)) return false;
		return setInt(name, value);
	}

	public function setColor(name:String, color:FlxColor):Bool
	{
		_pendingColors.set(name, color);
		_pendingAlphas.set(name, color.alphaFloat);
		return applyUniform(name, [color.redFloat, color.greenFloat, color.blueFloat, color.alphaFloat]);
	}

	public function setVec2(name:String, x:Float, y:Float):Bool
	{
		return applyUniform(name, [x, y]);
	}

	public function setVec3(name:String, x:Float, y:Float, z:Float):Bool
	{
		return applyUniform(name, [x, y, z]);
	}

	public function setVec4(name:String, x:Float, y:Float, z:Float, w:Float):Bool
	{
		return applyUniform(name, [x, y, z, w]);
	}

	public function setTexture(name:String, bitmap:BitmapData):Bool
	{
		if (bitmap != null) boundBitmaps.set(name, bitmap);
		else boundBitmaps.remove(name);
		return applyUniform(name, bitmap);
	}

	function findTimeParam():String
	{
		if (_timeParam != null && hasUniform(_timeParam)) return _timeParam;
		for (name in TIME_NAMES)
		{
			if (hasUniform(name))
			{
				_timeParam = name;
				return name;
			}
		}
		return null;
	}

	public function setTime(value:Float):Bool
	{
		var name:String = findTimeParam();
		if (name == null) return false;
		timeValue = value;
		return setFloat(name, value);
	}

	/**
		Defers a time write until the next flush()/update() (write, not apply).
	**/
	public function writeTime(value:Float):Float
	{
		_pendingTime = value;
		return value;
	}

	/**
		Defers a color write until the next flush()/update().
	**/
	public function writeColor(name:String, color:FlxColor):FlxColor
	{
		_pendingColors.set(name, color);
		_pendingAlphas.set(name, color.alphaFloat);
		return color;
	}

	public function getBool(name:String):Null<Bool>
	{
		var arr:Array<Dynamic> = readUniform(name);
		if (arr == null || arr.length == 0)
		{
			trace('[ModShader] Missing field ' + name + ' in shader ' + shaderName);
			return null;
		}
		return arr[0] == true;
	}

	public function getBoolArray(name:String):Array<Bool>
	{
		var arr:Array<Dynamic> = readUniform(name);
		if (arr == null || arr.length == 0)
		{
			trace('[ModShader] Missing field ' + name + ' in shader ' + shaderName);
			return null;
		}
		var out:Array<Bool> = [];
		for (v in arr) out.push(v == true);
		return out;
	}

	public function getFloat(name:String):Null<Float>
	{
		var arr:Array<Dynamic> = readUniform(name);
		if (arr == null || arr.length == 0)
		{
			trace('[ModShader] Missing field ' + name + ' in shader ' + shaderName);
			return null;
		}
		return arr[0];
	}

	public function getFloatArray(name:String):Array<Float>
	{
		var arr:Array<Dynamic> = readUniform(name);
		if (arr == null || arr.length == 0)
		{
			trace('[ModShader] Missing field ' + name + ' in shader ' + shaderName);
			return null;
		}
		var out:Array<Float> = [];
		for (v in arr) out.push(v);
		return out;
	}

	public function getInt(name:String):Null<Int>
	{
		var f:Null<Float> = getFloat(name);
		return f == null ? null : Std.int(f);
	}

	public function getIntArray(name:String):Array<Int>
	{
		var arr:Array<Float> = getFloatArray(name);
		if (arr == null) return null;
		var out:Array<Int> = [];
		for (v in arr) out.push(Std.int(v));
		return out;
	}

	/**
		Pushes every stored uniform value into the GL parameter tables.
		Returns how many parameters were actually written.
	**/
	public function flush():Int
	{
		applyPending();
		var applied:Int = 0;
		for (name in store.keys())
		{
			var p:Dynamic = paramOf(name);
			if (p == null) continue;
			var value:Dynamic = store.get(name);
			if (value == null) continue;
			try
			{
				if (Std.isOfType(value, BitmapData)) p.input = value;
				else p.value = value;
				applied++;
			}
			catch (e:Dynamic) {}
		}
		return applied;
	}

	function applyPending():Void
	{
		if (_pendingTime != null)
		{
			setTime(_pendingTime);
			_pendingTime = null;
		}
		for (name in _pendingColors.keys())
		{
			var color:FlxColor = _pendingColors.get(name);
			applyUniform(name, [color.redFloat, color.greenFloat, color.blueFloat, _pendingAlphas.exists(name) ? _pendingAlphas.get(name) : color.alphaFloat]);
		}
		_pendingColors.clear();
		_pendingAlphas.clear();
	}

	/**
		Per-frame hook: advances the time uniform when autoTime is on and
		applies deferred writes.
	**/
	public function update(elapsed:Float = 0):Void
	{
		if (autoTime)
		{
			timeValue += elapsed;
			setTime(timeValue);
		}
		if (_pendingTime != null || _pendingColors.keys().hasNext()) flush();
	}

	/**
		Drops cached parameter references that no longer exist in `data`
		(after a recompile) and stored values for uniforms that vanished
		from the source. Returns how many entries were removed.
	**/
	public function purgeDeadPrograms():Int
	{
		var removed:Int = 0;
		var dead:Array<String> = [];
		for (name in uniform.keys())
		{
			if (paramOf(name) == null) dead.push(name);
		}
		for (name in dead)
		{
			uniform.remove(name);
			removed++;
		}
		var deadStore:Array<String> = [];
		for (name in store.keys())
		{
			if (!hasUniform(name)) deadStore.push(name);
		}
		for (name in deadStore)
		{
			store.remove(name);
			removed++;
		}
		return removed;
	}

	public function attach(target:Dynamic):ModShader
	{
		if (target == null) return this;
		if (Std.isOfType(target, FlxSprite))
		{
			var spr:FlxSprite = target;
			spr.shader = this;
			attached = spr;
		}
		return this;
	}

	public function detach(target:Dynamic):ModShader
	{
		if (target != null && Std.isOfType(target, FlxSprite))
		{
			var spr:FlxSprite = target;
			if (spr.shader == this) spr.shader = null;
		}
		if (attached == target || target == null) attached = null;
		return this;
	}

	public function reportError(shaderName:String, err:Dynamic):Void
	{
		lastError = Std.string(err);
		compileError = lastError;
		trace('[ModShader] error in ' + shaderName + ': ' + lastError);
	}

	var lastError:String = null;

	@:noCompletion private override function __createGLProgram(vertexSource:String, fragmentSource:String):GLProgram
	{
		if (vertexSource == null || vertexSource.length == 0)
			vertexSource = OPENFL_VERTEX_HEADER + FLIXEL_VERTEX_HEADER
				+ '\nvoid main(void)\n{\n\tgl_Position = openfl_Matrix * openfl_Position;\n}';
		if (fragmentSource == null || fragmentSource.length == 0)
			fragmentSource = OPENFL_FRAGMENT_HEADER
				+ '\nvoid main(void)\n{\n\tgl_FragColor = texture2D(openfl_Texture, openfl_TextureCoordv);\n}';
		return super.__createGLProgram(vertexSource, fragmentSource);
	}

	@:noCompletion private override function __initGL():Void
	{
		super.__initGL();
		// parameter tables may have been rebuilt from the new sources:
		purgeDeadPrograms();
		flush();
	}

	public override function toString():String
	{
		return '[ModShader ' + shaderName
			+ (compileError != null ? ' compileError=' + compileError : ' uniforms=' + components.length)
			+ (sourcePath != null ? ' source=' + sourcePath : '')
			+ ']';
	}
}
