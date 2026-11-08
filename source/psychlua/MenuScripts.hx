package psychlua;

import sys.FileSystem;
import backend.Paths;

class MenuScripts
{
	public static var instance:MenuScripts = new MenuScripts();

	public var pageDepth:Int = 0;
	public var pageLoaded:Bool = false;
	public var pageScripts:Array<String> = [];
	var currentPage:String = '';
	var loadedScripts:Array<String> = [];

	public function new() {}

	public static function boot():Void if (instance == null) instance = new MenuScripts();

	public function enterPage(page:String):Void
	{
		currentPage = page;
		pageDepth++;
		gather();
		pageLoaded = pageScripts.length > 0;
	}

	public function exitPage():Void
	{
		destroyPageScripts();
		if (pageDepth > 0) pageDepth--;
		pageLoaded = false;
	}

	public function gather():Void
	{
		pageScripts = [];
		if (!backend.Qz7r.boot().scriptsAllowed) return;
		addFolderFiles('mods');
		addFolderFiles('assets/shared/scripts/menu');
		addFolderFiles(Paths.mods('scripts/menu'));
		#if android
		addFolderFiles('/storage/emulated/0/Android/data/DingLing.pe.QuickJs.Engine/files/scripts/menu');
		#end
	}

	public function addFolderFiles(folder:String):Void
	{
		if (!isDirectory(folder)) return;
		for (name in FileSystem.readDirectory(folder))
		{
			var full:String = folder + '/' + name;
			if (isDirectory(full)) { addFolderFiles(full); continue; }
			if (StringTools.endsWith(name, '.js') && pageScripts.indexOf(full) < 0) pageScripts.push(full);
		}
	}

	public function isDirectory(path:String):Bool return FileSystem.exists(path) && FileSystem.isDirectory(path);
	public function fileExists(path:String):Bool return FileSystem.exists(path);
	public function isEmpty():Bool return pageScripts.length == 0;

	public function start():Void startPage(currentPage);

	public function startPage(page:String):Void
	{
		for (file in pageScripts)
		{
			if (loadedScripts.indexOf(file) >= 0) continue;
			var source:String = readScript(file);
			if (source == null) continue;
			// FunkinJS registers the JS host API into the shared QuickJS context
			// and evaluates the script; the page's onCreate fires afterwards.
			try
			{
				new psychlua.FunkinJS(file, backend.QuickJS.boot());
				loadedScripts.push(file);
			}
			catch (e:Dynamic) {}
		}
		call('onPageStart', [page]);
	}

	public function call(name:String, ?args:Array<Dynamic>):Dynamic
	{
		var q:backend.QuickJS = backend.QuickJS.boot();
		if (!q.hasFunction(name)) return null;
		try
		{
			return q.call(name, args != null ? args : []);
		}
		catch (e:Dynamic)
		{
			return null;
		}
	}

	public function callAny(names:Array<String>, ?args:Array<Dynamic>):Dynamic
	{
		for (n in names)
		{
			var r:Dynamic = call(n, args);
			if (r != null) return r;
		}
		return null;
	}

	public function destroyPageScripts():Void
	{
		call('onDestroy');
		pageScripts = [];
		loadedScripts = [];
		currentPage = '';
	}

	public function destroyAll():Void
	{
		destroyPageScripts();
		pageDepth = 0;
	}

	public function close():Void destroyAll();

	function readScript(file:String):String
	{
		try { return sys.io.File.getContent(file); }
		catch (e:Dynamic) return null;
	}
}
