package backend;

class CrashLog
{
	public static var instance:CrashLog = null;
	var appendToFile:String = "";
	var error:Dynamic = null;
	var exception:Dynamic = null;
	var header:Dynamic = null;
	var hookTrace:Dynamic = null;
	var info:Dynamic = null;
	var retryAfterCwdChange:Dynamic = null;
	var safeString:Dynamic = null;
	var shortFile:String = "";
	var stamp:Dynamic = null;
	var step:Dynamic = null;
	var warn:Dynamic = null;

	public function new()
	{
		if (instance == null) instance = this;
	}

	var buffer:Array<String> = null;
	var filePath:String = null;

	function stamp():String
	{
		return Date.now().toString().split(" ").join("_").split(":").join("-");
	}

	public function close():Void
	{
		flush();
		buffer = null;
	}

	public function describeError(err:Dynamic):String
	{
		var out:String = Std.string(err);
		try
		{
			var stack:Array<haxe.StackItem> = haxe.CallStack.exceptionStack();
			if (stack.length > 0) out += "
" + haxe.CallStack.toString(stack);
		}
		catch (e:Dynamic) {}
		return out;
	}

	public function ensureDir(dir:String):Void
	{
		if (dir == null || dir.length < 1 || sys.FileSystem.exists(dir)) return;
		try sys.FileSystem.createDirectory(dir); catch (e:Dynamic) {}
	}

	public function flush():Void
	{
		if (buffer == null || filePath == null) return;
		try sys.io.File.saveContent(filePath, buffer.join("\n") + "\n");
		catch (e:Dynamic) {}
		buffer = [];
	}

	public function init(err:Dynamic):Void
	{
		error = err;
		var dir:String = resolveDir();
		ensureDir(dir);
		filePath = dir + "crash_" + stamp() + ".txt";
		buffer = [];
		write("=== CRASH LOG ===");
		write("Date: " + Date.now().toString());
		write(describeError(err));
		flush();
	}

	public function resolveDir():String
	{
		#if android
		return "/storage/emulated/0/Android/data/DingLing.pe.QuickJs.Engine/files/crash/";
		#else
		return "crash/";
		#end
	}

	public function write(line:String):Void
	{
		if (buffer == null) buffer = [];
		buffer.push(line);
	}
}
