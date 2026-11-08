package render;

import backend.ClientPrefs;
import backend.Mods;
import backend.Paths;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import haxe.crypto.Md5;
import openfl.display.BitmapData;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;
import sys.FileSystem;
import sys.io.File;

/**
	Mod shader loader and registry: scans mod folders for `<name>.frag` /
	`<name>.vert` GLSL text files, compiles them into ModShader instances and
	tracks hot reload through content signatures (md5). Also manages camera
	filter attachment for full-screen shader passes.
**/
class ModRender
{
	public static var instance:ModRender = null;

	/**
		Legacy shader folder layouts still scanned after the standard `shaders`
		folder inside every mod directory.
	**/
	public static var LEGACY_FOLDERS:Array<String> = ['data/shaders', 'shaders/frag', 'shaders/vert'];

	public var debug:Bool = false;
	public var fileName:String = "";
	public var cameraName:String = "";
	public var cameraShader:ModShader = null;
	public var collectBoundBitmaps:Map<String, Dynamic> = new Map<String, Dynamic>();

	var folders:Array<String> = [];
	var _fileMap:Map<String, String> = new Map<String, String>();
	var _live:Map<String, ModShader> = new Map<String, ModShader>();
	var _shared:Map<String, ModShader> = new Map<String, ModShader>();
	var _sharedOrder:Array<String> = [];
	var _missing:Map<String, Bool> = new Map<String, Bool>();
	var _signature:Map<String, String> = new Map<String, String>();
	var _rootEntries:Map<String, Array<String>> = new Map<String, Array<String>>();
	var _listable:Array<String> = [];
	var _warnedDisabled:Bool = false;
	var tracked:Array<Dynamic> = [];
	var cameraShaders:Map<FlxCamera, ModShader> = new Map<FlxCamera, ModShader>();

	public function new()
	{
		if (instance == null) instance = this;
	}

	public static function boot():ModRender
	{
		if (instance == null) instance = new ModRender();
		for (mod in Mods.getModDirectories())
			instance.addModFolder(mod);
		instance.addFolder(Paths.mods('shaders'));
		return instance;
	}

	public function normalize(path:String):String
	{
		if (path == null) return null;
		path = StringTools.replace(path, '\\', '/');
		while (path.indexOf('//') != -1)
			path = StringTools.replace(path, '//', '/');
		return path;
	}

	public function realName(fileName:String):String
	{
		if (fileName == null) return null;
		var name:String = fileName;
		var slash:Int = name.lastIndexOf('/');
		if (slash != -1) name = name.substr(slash + 1);
		for (ext in ['.frag', '.vert', '.glsl', '.frag.txt', '.vert.txt'])
		{
			if (name.length > ext.length && name.substr(name.length - ext.length).toLowerCase() == ext)
			{
				name = name.substr(0, name.length - ext.length);
				break;
			}
		}
		return name;
	}

	public function addFolder(path:String):Bool
	{
		if (path == null) return false;
		path = normalize(path);
		if (!FileSystem.exists(path) || !FileSystem.isDirectory(path)) return false;
		if (folders.contains(path)) return false;
		folders.push(path);
		indexFolder(path);
		return true;
	}

	public function addModFolder(modFolder:String):Bool
	{
		if (modFolder == null) return false;
		var ok:Bool = addFolder(Paths.mods(modFolder + '/shaders'));
		for (legacy in LEGACY_FOLDERS)
			addFolder(Paths.mods(modFolder + '/' + legacy));
		return ok;
	}

	public function addFile(path:String):Bool
	{
		if (path == null) return false;
		path = normalize(path);
		if (!FileSystem.exists(path) || FileSystem.isDirectory(path)) return false;
		var ext:String = path.substr(path.lastIndexOf('.')).toLowerCase();
		if (ext != '.frag' && ext != '.vert') return false;
		var name:String = realName(path);
		if (!_fileMap.exists(name))
		{
			_fileMap.set(name, path);
			_listable.pushUnique(name);
		}
		return true;
	}

	function indexFolder(path:String):Void
	{
		for (file in FileSystem.readDirectory(path))
		{
			var lower:String = file.toLowerCase();
			if (lower.endsWith('.frag') || lower.endsWith('.vert'))
				addFile(normalize(path + '/' + file));
		}
	}

	public function searchFolders():Array<String>
	{
		var out:Array<String> = [];
		for (folder in folders)
			out.pushUnique(folder);

		// global mods first, then the loaded mod, then the shared mods root
		for (mod in Mods.getGlobalMods())
			out.pushUnique(Paths.mods(mod + '/shaders'));
		if (Mods.currentModDirectory != null && Mods.currentModDirectory.length > 0)
			out.pushUnique(Paths.mods(Mods.currentModDirectory + '/shaders'));
		out.pushUnique(Paths.mods('shaders'));

		for (mod in Mods.getModDirectories())
			for (legacy in LEGACY_FOLDERS)
				out.pushUnique(Paths.mods(mod + '/' + legacy));

		var existing:Array<String> = [];
		for (folder in out)
			if (FileSystem.exists(folder) && FileSystem.isDirectory(folder))
				existing.push(folder);
		return existing;
	}

	public function entriesOfRoot(root:String):Array<String>
	{
		if (root == null) return [];
		root = normalize(root);
		if (_rootEntries.exists(root)) return _rootEntries.get(root);
		var entries:Array<String> = [];
		try
		{
			if (FileSystem.exists(root) && FileSystem.isDirectory(root))
				entries = FileSystem.readDirectory(root);
		}
		catch (e:Dynamic)
		{
			trace('[ModRender] WARN: folder ' + root + ' permission locked: ' + e);
			entries = [];
		}
		_rootEntries.set(root, entries);
		return entries;
	}

	public function filesOf(folderName:String):Array<String>
	{
		var out:Array<String> = [];
		for (entry in entriesOfRoot(folderName))
		{
			var lower:String = entry.toLowerCase();
			if (lower.endsWith('.frag') || lower.endsWith('.vert'))
				out.push(normalize(folderName + '/' + entry));
		}
		return out;
	}

	public function findFragPath(shaderName:String):String
	{
		if (shaderName == null) return null;
		if (_fileMap.exists(shaderName) && FileSystem.exists(_fileMap.get(shaderName)))
			return _fileMap.get(shaderName);
		for (folder in searchFolders())
		{
			var p:String = normalize(folder + '/' + shaderName + '.frag');
			if (FileSystem.exists(p)) return p;
		}
		return null;
	}

	public function exists(shaderName:String):Bool
	{
		return findFragPath(shaderName) != null;
	}

	/**
		Reads shader text safely: binary files (null bytes, no BOM check) are
		rejected with a warning instead of producing a broken GLSL compile.
	**/
	public function readText(path:String):String
	{
		if (path == null) return null;
		try
		{
			var content:String = File.getContent(path);
			if (content != null && content.indexOf(String.fromCharCode(0)) != -1)
			{
				trace('[ModRender] WARN: ' + path + ' looks like binary without BOM, skipped');
				return null;
			}
			return content;
		}
		catch (e:Dynamic)
		{
			trace('[ModRender] WARN: cannot read ' + path + ': ' + e);
			return null;
		}
	}

	public function source(shaderName:String):String
	{
		var path:String = findFragPath(shaderName);
		return path == null ? null : readText(path);
	}

	public function signature(shaderName:String):String
	{
		var src:String = source(shaderName);
		return src == null ? null : Md5.encode(src);
	}

	/**
		Loads (and caches) a mod shader. Returns the live instance, or null
		when the file is missing, unreadable or the shader system is turned
		off in the options menu.
	**/
	public function load(shaderName:String, force:Bool = false):ModShader
	{
		if (shaderName == null) return null;
		if (!ClientPrefs.data.shaders)
		{
			if (!_warnedDisabled)
			{
				_warnedDisabled = true;
				trace('[ModRender] WARN: shaders are turned off in options, not loading ' + shaderName);
			}
			return null;
		}
		if (!force && _live.exists(shaderName))
			return _live.get(shaderName);
		if (_missing.exists(shaderName) && !force)
			return null;

		fileName = findFragPath(shaderName);
		if (fileName == null)
		{
			_missing.set(shaderName, true);
			if (debug) trace('[ModRender] no shader source found for ' + shaderName);
			return null;
		}

		var frag:String = readText(fileName);
		if (frag == null)
		{
			_missing.set(shaderName, true);
			return null;
		}
		var vertPath:String = fileName.substr(0, fileName.lastIndexOf('.')) + '.vert';
		var vert:String = FileSystem.exists(vertPath) ? readText(vertPath) : null;
		if (frag.indexOf('main') == -1)
		{
			trace('[ModRender] WARN: ' + shaderName + ' does not compile: no main() in ' + fileName);
			_missing.set(shaderName, true);
			return null;
		}

		var shader:ModShader = new ModShader(shaderName, frag, vert);
		shader.sourcePath = fileName;

		_live.set(shaderName, shader);
		_missing.remove(shaderName);
		_signature.set(shaderName, Md5.encode(frag));
		if (debug) trace('[ModRender] loaded shader ' + shaderName + ' from ' + fileName);

		// shared = loaded from the global shaders folder, usable by every mod
		for (folder in folders)
		{
			if (fileName.indexOf(folder) == 0 && folder == Paths.mods('shaders'))
			{
				_shared.set(shaderName, shader);
				_sharedOrder.pushUnique(shaderName);
				break;
			}
		}
		return shader;
	}

	public function create(shaderName:String):ModShader
	{
		return load(shaderName, true);
	}

	public function get(shaderName:String):ModShader
	{
		return load(shaderName);
	}

	/**
		Reloads every live shader whose source signature changed on disk.
		Returns how many shaders were recompiled.
	**/
	public function refreshIfNeeded():Int
	{
		var recompiled:Int = 0;
		for (name in _live.keys())
		{
			var shader:ModShader = _live.get(name);
			if (shader == null || shader.sourcePath == null) continue;
			if (!FileSystem.exists(shader.sourcePath)) continue;
			var src:String = readText(shader.sourcePath);
			if (src == null) continue;
			var sig:String = Md5.encode(src);
			if (_signature.exists(name) && _signature.get(name) == sig) continue;
			load(name, true);
			recompiled++;
		}
		return recompiled;
	}

	public function clearCache():Int
	{
		var removed:Int = 0;
		for (name in _live.keys())
		{
			_live.get(name).detach(null);
			removed++;
		}
		_live.clear();
		_shared.clear();
		_sharedOrder.resize(0);
		_missing.clear();
		_signature.clear();
		_fileMap.clear();
		_listable.resize(0);
		_rootEntries.clear();
		collectBoundBitmaps.clear();
		return removed;
	}

	public function list():Array<String>
	{
		var out:Array<String> = _listable.copy();
		out.sort(function(a:String, b:String) return a < b ? -1 : (a > b ? 1 : 0));
		return out;
	}

	public function counts():String
	{
		return 'live=' + Lambda.count(_live)
			+ ' shared=' + Lambda.count(_shared)
			+ ' missing=' + Lambda.count(_missing)
			+ ' files=' + Lambda.count(_fileMap)
			+ ' folders=' + folders.length;
	}

	public function modFoldersReport():String
	{
		var report:Array<String> = [];
		for (mod in Mods.getModDirectories())
		{
			var has:Bool = FileSystem.exists(Paths.mods(mod + '/shaders'));
			report.push(mod + (has ? ': shaders' : ''));
		}
		return report.join(', ');
	}

	public function pushUnique(arr:Array<Dynamic>, value:Dynamic):Bool
	{
		if (arr == null || value == null || arr.indexOf(value) != -1) return false;
		arr.push(value);
		return true;
	}

	public function track(target:Dynamic):Bool
	{
		if (target == null) return false;
		if (tracked.indexOf(target) != -1) return false;
		tracked.push(target);
		return true;
	}

	public function isEnabled(shader:ModShader):Bool
	{
		return shader != null && shader.enabled && ClientPrefs.data.shaders;
	}

	public function isShared(shader:ModShader):Bool
	{
		if (shader == null) return false;
		for (name in _shared.keys())
			if (_shared.get(name) == shader) return true;
		return false;
	}

	/**
		Sprites: assigns the shader (by instance or by mod shader name).
	**/
	public function attach(target:Dynamic, ?shaderName:String = null):ModShader
	{
		var shader:ModShader = null;
		if (shaderName != null) shader = get(shaderName);
		else if (Std.isOfType(target, FlxSprite) && Std.isOfType(target.shader, ModShader))
			shader = target.shader;
		if (shader == null || !isEnabled(shader)) return shader;
		shader.attach(target);
		track(target);
		return shader;
	}

	public function detach(target:Dynamic):Bool
	{
		if (target == null || !Std.isOfType(target, FlxSprite)) return false;
		var spr:FlxSprite = target;
		if (Std.isOfType(spr.shader, ModShader))
		{
			cast(spr.shader, ModShader).detach(spr);
			spr.shader = null;
			tracked.remove(target);
			return true;
		}
		return false;
	}

	/**
		Cameras: wraps the shader into a ShaderFilter pushed onto the camera's
		filter list (full-screen pass).
	**/
	public function attachCamera(camera:FlxCamera, shader:ModShader):Bool
	{
		if (camera == null || shader == null || !isEnabled(shader)) return false;
		if (!hasFilter(camera))
		{
			var filter:BitmapFilter = new ShaderFilter(shader);
			if (camera.filters == null) camera.filters = [filter];
			else camera.filters = camera.filters.concat([filter]);
		}
		cameraShaders.set(camera, shader);
		cameraShader = shader;
		cameraName = 'camera' + FlxG.cameras.list.indexOf(camera);
		track(camera);
		return true;
	}

	public function detachCamera(camera:FlxCamera):Bool
	{
		if (camera == null) return false;
		var had:Bool = cameraShaders.exists(camera);
		if (had)
		{
			var shader:ModShader = cameraShaders.get(camera);
			if (camera.filters != null)
			{
				var kept:Array<BitmapFilter> = [];
				for (filter in camera.filters)
				{
					var sf:ShaderFilter = Std.isOfType(filter, ShaderFilter) ? cast filter : null;
					if (sf != null && sf.shader == shader) continue;
					kept.push(filter);
				}
				camera.filters = kept;
			}
			cameraShaders.remove(camera);
			tracked.remove(camera);
			if (cameraShader == shader) cameraShader = null;
		}
		return had;
	}

	public function hasFilter(camera:FlxCamera):Bool
	{
		return camera != null && cameraShaders.exists(camera);
	}

	public function isCameraShader(shader:ModShader):Bool
	{
		if (shader == null) return false;
		for (cam in cameraShaders.keys())
			if (cameraShaders.get(cam) == shader) return true;
		return false;
	}

	public function removeFilter(camera:FlxCamera):Bool
	{
		return detachCamera(camera);
	}

	/**
		Applies a shader to a camera looked up by its display name
		("camera0", "camera1", ... following FlxG.cameras.list order).
	**/
	public function applyFilter(cameraName:String, shaderName:String):Bool
	{
		if (cameraName == null || shaderName == null) return false;
		if (!StringTools.startsWith(cameraName, 'camera')) return false;
		var index:Null<Int> = Std.parseInt(cameraName.substr(6));
		if (index == null || index < 0 || index >= FlxG.cameras.list.length) return false;
		return attachCamera(FlxG.cameras.list[index], get(shaderName));
	}

	/**
		Drops tracked cameras that left the game (destroyed or removed from
		FlxG.cameras) so the map does not hold dead references.
	**/
	public function pruneCameras():Int
	{
		var removed:Int = 0;
		var dead:Array<FlxCamera> = [];
		for (cam in cameraShaders.keys())
		{
			if (cam == null || !cam.exists || FlxG.cameras.list.indexOf(cam) == -1)
				dead.push(cam);
		}
		for (cam in dead)
		{
			cameraShaders.remove(cam);
			tracked.remove(cam);
			removed++;
		}
		return removed;
	}

	/**
		Collects bitmap textures from a folder into collectBoundBitmaps so mod
		shaders can sample them through setTexture().
	**/
	public function collectFrom(folderName:String):Int
	{
		var collected:Int = 0;
		for (entry in entriesOfRoot(folderName))
		{
			if (!entry.toLowerCase().endsWith('.png')) continue;
			var name:String = realName(entry);
			if (collectBoundBitmaps.exists(name)) continue;
			try
			{
				var bmp:BitmapData = BitmapData.fromFile(normalize(folderName + '/' + entry));
				if (bmp != null)
				{
					collectBoundBitmaps.set(name, bmp);
					collected++;
				}
			}
			catch (e:Dynamic) {}
		}
		return collected;
	}

	/**
		Per-frame hook: hot reload check + time uniforms on every live shader.
		Returns the number of live shaders updated.
	**/
	public function update(elapsed:Float = 0):Int
	{
		refreshIfNeeded();
		var updated:Int = 0;
		for (shader in _live)
		{
			if (!isEnabled(shader)) continue;
			shader.update(elapsed);
			updated++;
		}
		pruneCameras();
		return updated;
	}

	/**
		Runs string-level checks on the shader pipeline (header injection,
		uniform parsing) without needing a GL context. Returns true on success.
	**/
	public function selfTest():Bool
	{
		var probe:ModShader = new ModShader('selfTest', null, null);
		var ok:Bool = probe.setFragmentSource('uniform float time;\nvoid main(void)\n{\n\tgl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);\n}') != null
			&& probe.headerWasInjected
			&& probe.hasUniform('time')
			&& probe.hasUniform('openfl_TextureSize');
		trace('[ModRender] selfTest ' + (ok ? 'passed' : 'FAILED') + ' (' + counts() + ')');
		return ok;
	}
}
