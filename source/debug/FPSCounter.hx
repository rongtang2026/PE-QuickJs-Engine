package debug;

import flixel.FlxG;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
class FPSCounter extends TextField
{
	public static var instance:FPSCounter = null;

	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	/**
		The current memory usage (WARNING: this is NOT your total program memory usage, rather it shows the garbage collector memory)
	**/
	public var memoryMegas(get, never):Float;

	/**
		GC data memory in MB (hxcpp MEM_INFO_CURRENT).
	**/
	public var dataMemoryMB(get, never):Float;

	/**
		Total device memory in MB (MemTotal on android/linux, -1 when unknown).
	**/
	public var deviceMemoryMB(get, never):Float;

	/**
		Process memory as a percentage of device memory (-1 when unknown).
	**/
	public var memoryPercent(get, never):Float;

	/**
		Resident process memory in MB (RSS from statm, GC reserved fallback).
	**/
	public var processMemoryMB(get, never):Float;

	@:noCompletion private var times:Array<Float>;

	// fork additions: FPS panel state (default: opaque black base, as on the original build)
	public var panelClickable:Bool = false;
	public var panelCollapsed:Bool = false;
	public var panelBgVisible:Bool = true;
	public var panelBgAlpha:Float = 1.0;
	public var panelBgImageAlpha:Float = 1.0;
	public var panelBgColor:Null<Int> = 0xFF000000;
	public var userTextColor:Null<Int> = null;

	var panelBg:Sprite = null;
	var panelBgImageData:BitmapData = null;
	var sampledDataMB:Float = -1;
	var sampledDeviceMB:Float = -1;
	var sampledProcessMB:Float = -1;
	var sampledSharedMB:Float = -1;
	var sampleTimeout:Float = 0.0;
	var initX:Float = 10;
	var initY:Float = 10;
	var initFontSize:Int = 14;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 14, color);
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		times = [];
		initX = x;
		initY = y;
		boot();
	}

	public function boot():Void
	{
		instance = this;
		if (ProcessMemory.instance == null)
			new ProcessMemory();
		sampleMemory();
	}

	var deltaTimeout:Float = 0.0;

	// Event Handlers
	private override function __enterFrame(deltaTime:Float):Void
	{
		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();

		sampleTimeout += deltaTime;
		if (sampleTimeout >= 1000)
		{
			sampleTimeout = 0.0;
			sampleMemory();
		}

		// prevents the overlay from updating every frame, why would you need to anyways @crowplexus
		if (deltaTimeout < 50) {
			deltaTimeout += deltaTime;
			return;
		}

		currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;
		updateText();
		deltaTimeout = 0.0;
	}

	public dynamic function updateText():Void { // so people can override it in hscript
		var rss:Float = sampledProcessMB >= 0 ? sampledProcessMB : 0;
		var deviceGB:String = sampledDeviceMB > 0 ? fmt1(sampledDeviceMB / 1024) : 'N/A';
		var vmr:Float = sampledSharedMB >= 0 ? sampledSharedMB : 0;

		text = 'MEM: ${fmt1(rss)} MB / $deviceGB GB'
		+ '\nRAM: ${fmt1(memoryMegas / 1048576)} MB'
		+ '\nRSS: ${fmt1(rss)} MB'
		+ '\nVmR: ${fmt1(vmr)} MB'
		+ '\nFPS: $currentFPS'
		+ '\n' + osLine();

		if (userTextColor != null)
			textColor = userTextColor;
		else
		{
			textColor = 0xFFFFFFFF;
			if (currentFPS < FlxG.drawFramerate * 0.5)
				textColor = 0xFFFF0000;
		}

		if (panelCollapsed) text = 'FPS: $currentFPS';
		if (panelBgVisible) layoutBackground();
	}

	static function fmt1(v:Float):String
		return Std.string(Math.round(v * 10) / 10);

	// the original panel reads the OS line from the platform ("OS: Android --" is
	// the .so fallback literal for when the fields are unavailable)
	static function osLine():String
	{
		#if android
		var release:String = '';
		var model:String = '';
		var sdk:String = '';
		try release = Std.string(lime.system.JNI.createStaticField('android/os/Build$VERSION', 'RELEASE', 'Ljava/lang/String;').get());
		catch (e:Dynamic) release = '';
		try model = Std.string(lime.system.JNI.createStaticField('android/os/Build', 'MODEL', 'Ljava/lang/String;').get());
		catch (e:Dynamic) model = '';
		try sdk = Std.string(lime.system.JNI.createStaticField('android/os/Build$VERSION', 'SDK_INT', 'I').get());
		catch (e:Dynamic) sdk = '';
		return 'OS: Android ' + (release.length > 0 ? release : '--') + ' (API ' + (sdk.length > 0 ? sdk : '--') + ')' + (model.length > 0 ? ' ' + model : '');
		#elseif windows
		return 'OS: Windows';
		#else
		return 'OS: ' + Sys.systemName();
		#end
	}

	inline function get_memoryMegas():Float
		return cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);

	public function applyFontFormat(?fmt:TextFormat = null):TextFormat
	{
		if (fmt == null) return defaultTextFormat;
		defaultTextFormat = fmt;
		setTextFormat(fmt);
		layoutBackground();
		return fmt;
	}

	public function currentTextColor(?color:Null<Int> = null):Int
	{
		if (color != null) return setTextColor(color);
		return textColor;
	}

	public function formatDataMemory(?bytes:Float = null):String
	{
		if (sampledDataMB < 0) sampleMemory();
		return formatBytes(bytes == null ? sampledDataMB * 1048576 : bytes);
	}

	public function formatMegas(?bytes:Float = null):String
	{
		return formatBytes(bytes == null ? memoryMegas : bytes);
	}

	public function formatMemory(?bytes:Float = null):String
	{
		return formatBytes(bytes == null ? System.totalMemory : bytes);
	}

	public function formatResident(?bytes:Float = null):String
	{
		if (sampledProcessMB < 0) sampleMemory();
		return formatBytes(bytes == null ? sampledProcessMB * 1048576 : bytes);
	}

	static function formatBytes(bytes:Float):String
	{
		if (bytes < 0 || Math.isNaN(bytes)) return 'N/A';
		return (Math.round(bytes / 1048576 * 10) / 10) + ' MB';
	}

	public function getSystemInfo():String
	{
		if (sampledProcessMB < 0 || sampledDeviceMB < 0) sampleMemory();
		var deviceText:String = sampledDeviceMB < 0 ? 'N/A' : (Math.round(sampledDeviceMB * 10) / 10) + ' MB';
		var lines:Array<String> = [
			'FPS: $currentFPS',
			'Memory: ${formatMegas()}',
			'Data: ${formatDataMemory()}',
			'Resident: ${formatResident()}',
			'Process: ${formatMemory()}',
			'Device: $deviceText'
		];
		return lines.join('\n');
	}

	function get_dataMemoryMB():Float
	{
		if (sampledDataMB < 0) sampleMemory();
		return sampledDataMB;
	}

	function get_deviceMemoryMB():Float
	{
		if (sampledDeviceMB < 0) sampleMemory();
		return sampledDeviceMB;
	}

	function get_memoryPercent():Float
	{
		if (sampledDeviceMB <= 0 || sampledProcessMB < 0)
		{
			sampleMemory();
			if (sampledDeviceMB <= 0 || sampledProcessMB < 0) return -1;
		}
		return Math.round(sampledProcessMB / sampledDeviceMB * 1000) / 10;
	}

	function get_processMemoryMB():Float
	{
		if (sampledProcessMB < 0) sampleMemory();
		return sampledProcessMB;
	}

	public function layoutBackground():Void
	{
		if (!panelBgVisible)
		{
			if (panelBg != null) panelBg.visible = false;
			return;
		}
		if (panelBg == null)
		{
			panelBg = new Sprite();
			panelBg.mouseChildren = false;
			panelBg.addEventListener(MouseEvent.MOUSE_DOWN, function(_) onPanelClick());
		}
		if (parent != null && panelBg.parent == null)
			parent.addChildAt(panelBg, parent.getChildIndex(this));
		panelBg.visible = parent != null;
		panelBg.x = this.x - 4;
		panelBg.y = this.y - 4;
		panelBg.graphics.clear();
		var w:Float = width + 8;
		var h:Float = height + 8;
		if (panelBgImageData != null)
		{
			panelBg.graphics.beginBitmapFill(panelBgImageData);
			panelBg.graphics.drawRect(0, 0, w, h);
			panelBg.graphics.endFill();
		}
		else if (panelBgColor != null)
		{
			panelBg.graphics.beginFill(panelBgColor & 0xFFFFFF, panelBgAlpha);
			panelBg.graphics.drawRect(0, 0, w, h);
			panelBg.graphics.endFill();
		}
	}

	public function onPanelClick():Bool
	{
		if (!panelClickable) return panelCollapsed;
		return toggleCollapsed();
	}

	public function opaqueColor(?color:Null<Int> = null):Null<Int>
	{
		var c:Null<Int> = color == null ? panelBgColor : color;
		if (c == null) return null;
		return (c & 0xFFFFFF) | 0xFF000000;
	}

	public function refreshBackgroundVisibility():Void
	{
		if (panelBg != null) panelBg.visible = panelBgVisible && parent != null;
		layoutBackground();
		trace('PANEL refresh=${panelBg != null ? panelBg.visible : false}');
	}

	public function resetPanel():Void
	{
		x = initX;
		y = initY;
		panelCollapsed = false;
		panelClickable = false;
		panelBgVisible = false;
		panelBgAlpha = 0.5;
		panelBgImageAlpha = 1.0;
		panelBgColor = null;
		panelBgImageData = null;
		userTextColor = null;
		scaleX = scaleY = 1;
		var fmt:TextFormat = defaultTextFormat.clone();
		fmt.size = initFontSize;
		defaultTextFormat = fmt;
		setTextFormat(fmt);
		layoutBackground();
	}

	public function sampleMemory():Float
	{
		if (ProcessMemory.instance == null)
			new ProcessMemory();
		var pm:ProcessMemory = ProcessMemory.instance;

		#if cpp
		sampledDataMB = cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_CURRENT) / 1048576;
		#end

		var rss:Float = pm.readStatmMB();
		if (rss >= 0)
			sampledProcessMB = rss;
		#if cpp
		else
			sampledProcessMB = cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_RESERVED) / 1048576;
		#end

		var shared:Float = pm.readStatmSharedMB();
		if (shared >= 0)
			sampledSharedMB = shared;
		#if cpp
		else
			sampledSharedMB = cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_CURRENT) / 1048576;
		#end

		#if (android || linux)
		var total:Null<Float> = pm.readProcValue('MemTotal:');
		if (total != null) sampledDeviceMB = total;
		#end
		return sampledProcessMB;
	}

	public function setBackgroundColor(?color:Null<Int> = null):Null<Int>
	{
		if (color != null)
		{
			panelBgColor = opaqueColor(color);
			panelBgVisible = true;
			panelClickable = true;
		}
		else
			panelBgColor = null;
		layoutBackground();
		return panelBgColor;
	}

	public function setBackgroundImage(?image:String = null):BitmapData
	{
		panelBgImageData = null;
		if (image != null)
		{
			try
			{
				if (openfl.Assets.exists(image, openfl.utils.AssetType.IMAGE))
					panelBgImageData = openfl.Assets.getBitmapData(image, false);
				else
					panelBgImageData = BitmapData.fromFile(image);
			}
			catch (e:Dynamic) { panelBgImageData = null; }
		}
		if (panelBgImageData != null)
		{
			panelBgVisible = true;
			panelClickable = true;
		}
		layoutBackground();
		return panelBgImageData;
	}

	public function setBackgroundVisible(?visible:Null<Bool> = null):Bool
	{
		panelBgVisible = visible == null ? !panelBgVisible : visible;
		if (panelBgVisible) panelClickable = true;
		layoutBackground();
		refreshBackgroundVisibility();
		return panelBgVisible;
	}

	public function setCollapsed(?collapsed:Null<Bool> = null):Bool
	{
		panelCollapsed = collapsed == null ? !panelCollapsed : collapsed;
		updateText();
		return panelCollapsed;
	}

	public function setFontSize(?size:Null<Int> = null):Int
	{
		if (size == null)
			return defaultTextFormat.size == null ? initFontSize : Std.int(defaultTextFormat.size);
		var fmt:TextFormat = defaultTextFormat.clone();
		fmt.size = size;
		defaultTextFormat = fmt;
		setTextFormat(fmt);
		layoutBackground();
		return size;
	}

	public function setTextColor(?color:Null<Int> = null):Int
	{
		if (color == null)
		{
			userTextColor = null;
			return textColor;
		}
		userTextColor = color;
		textColor = color;
		return textColor;
	}

	public function toggleCollapsed():Bool
	{
		return setCollapsed(!panelCollapsed);
	}

	public function updateScale(?scale:Null<Float> = null):Float
	{
		if (scale == null) return scaleX;
		scaleX = scaleY = scale;
		layoutBackground();
		return scale;
	}
}
