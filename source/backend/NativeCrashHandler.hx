package backend;

class NativeCrashHandler
{
	public static var instance:NativeCrashHandler = null;
	var luaSelfTest:Dynamic = null;
	var luaSelfTestFaultInfo:Dynamic = null;
	var luaSelfTestResult:Dynamic = null;

	public function new()
	{
		if (instance == null) instance = this;
	}

	public function install():Void
	{
		try
		{
			openfl.Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(openfl.events.UncaughtErrorEvent.UNCAUGHT_ERROR, function(e:openfl.events.UncaughtErrorEvent) {
				push("Uncaught error: " + e.error);
				pushNative();
			});
		}
		catch (e:Dynamic) {}
	}

	public function installNative():Void
	{
		// native signal handlers are installed by the C++ side; nothing to do here
	}

	public function push(line:String):Void
	{
		if (line == null) return;
		nativeLines.push(line);
		if (nativeLines.length > 64) nativeLines.shift();
	}

	public function pushNative():Void
	{
		if (nativeLines.length < 1) return;
		try
		{
			var dir:String = #if android "/storage/emulated/0/Android/data/DingLing.pe.QuickJs.Engine/files/" #else "logs/" #end;
			if (!sys.FileSystem.exists(dir)) sys.FileSystem.createDirectory(dir);
			sys.io.File.saveContent(dir + "native_crash.log", nativeLines.join("\n") + "\n");
		}
		catch (e:Dynamic) {}
		nativeLines = [];
	}
}
