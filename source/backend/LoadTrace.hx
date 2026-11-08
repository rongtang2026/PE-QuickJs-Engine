package backend;

class LoadTrace
{
	public static var instance:LoadTrace = null;

	public function new()
	{
		if (instance == null) instance = this;
	}

	public function add(line:String):Void
	{
		if (buffer == null) buffer = [];
		buffer.push("[" + Math.round(haxe.Timer.stamp() * 1000) + "] " + line);
	}

	public function begin(tag:String):Void
	{
		buffer = [];
		currentTag = tag == null ? "load" : tag;
		add("=== " + currentTag + " ===");
	}

	public function close():Void
	{
		if (buffer == null) return;
		var dir:String = "logs";
		try
		{
			if (!sys.FileSystem.exists(dir)) sys.FileSystem.createDirectory(dir);
			sys.io.File.saveContent(getPath(), buffer.join("\n") + "\n");
		}
		catch (e:Dynamic) {}
		buffer = null;
	}

	public function getPath():String
	{
		return "logs/" + currentTag + "_" + Date.now().toString().split(" ").join("_").split(":").join("-") + ".log";
	}
}
