package backend;

class ApiDocs
{
	public static var instance:ApiDocs = null;
	var buildGettingStarted:Dynamic = null;
	var buildHealthGuide:Int = 0;
	var buildIndex:Int = 0;
	var buildJudgementGuide:Int = 0;
	var buildLanesGuide:Int = 0;
	var buildMenuGuide:Int = 0;
	var buildMobileGuide:Int = 0;
	var buildPage:Int = 0;
	var buildRankGuide:Int = 0;
	var buildStoryGuide:Int = 0;
	var buildVariables:Dynamic = null;
	var exampleFor:Dynamic = null;
	var generate:Dynamic = null;
	var sortedKeys:String = "";

	public function new()
	{
		if (instance == null) instance = this;
	}

	public function ensureFolder(dir:String):Void
	{
		if (dir == null || dir.length < 1 || sys.FileSystem.exists(dir)) return;
		try sys.FileSystem.createDirectory(dir); catch (e:Dynamic) {}
	}

	public function writeCallback(file:String, name:String, args:String):Void
	{
		writeIfChanged(file, "\n### " + name + "\n\n```js\n" + name + "(" + args + ")\n```\n");
	}

	public function writeFunction(file:String, name:String, args:String, description:String):Void
	{
		writeIfChanged(file, "\n### " + name + "\n\n" + description + "\n\n```js\n" + name + "(" + args + ")\n```\n");
	}

	public function writeIfChanged(file:String, content:String):Void
	{
		if (file == null || content == null) return;
		try
		{
			ensureFolder(new sys.io.Path(file).dir);
			if (sys.FileSystem.exists(file) && sys.io.File.getContent(file) == content) return;
			sys.io.File.saveContent(file, content);
		}
		catch (e:Dynamic) {}
	}
}
