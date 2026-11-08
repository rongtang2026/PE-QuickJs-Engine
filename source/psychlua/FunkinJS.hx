package psychlua;

import backend.QuickJS;
import backend.Conductor;
import backend.MenuUI;
import backend.MenuGestures;
import backend.SongList;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import states.MainMenuState;
import states.CustomMenuState;
import states.FreeplayState;
import states.StoryMenuState;

class FunkinJS
{
	var context:QuickJS;
	var scriptPath:String;
	var closed:Bool = false;
	static public var menuState:flixel.FlxState = null;
	var menuUI:Dynamic = null;
	var menuGestures:MenuGestures = null;
	var scriptsHost:backend.MenuScriptHost = new backend.MenuScriptHost();
	static public var currentMainMenu:Dynamic = null;
	static public var currentFreeplay:Dynamic = null;
	static public var currentStory:Dynamic = null;
	static public var currentPage:Dynamic = null;

	/** Menu states call this once in create() so script APIs can reach them. */
	public static function bind(state:Dynamic):Void
	{
		menuState = Std.isOfType(state, flixel.FlxState) ? cast state : null;
		if (Std.isOfType(state, states.MainMenuState)) currentMainMenu = state;
		else if (Std.isOfType(state, states.FreeplayState)) currentFreeplay = state;
		else if (Std.isOfType(state, states.StoryMenuState)) currentStory = state;
	}
	var defaultWriteFolder:String = "";
	var scriptColorValue:Int = 0xFFFFFFFF;
	var menuVideoPlaying:Bool = false;
	var menuVideoBackground:Bool = false;
	var menuVideoLayer:Bool = false;
	var objects:Map<String, Dynamic> = new Map<String, Dynamic>();
	var callbacks:Map<String, Dynamic> = new Map<String, Dynamic>();
	var aliases:Map<String, String> = new Map<String, String>();
	var wrappers:Map<String, Dynamic> = new Map<String, Dynamic>();
	var logLines:Array<String> = [];
	var arg:Array<Dynamic> = [];
	var mainMenuItem:Dynamic = null;
	var menuColumnArg:String = "center";
	var menuIndexArg:Int = 0;
	var songArg:String = "";
	var weekArg:String = "";
	var tagIndex:Int = 0;
	var sideOption:String = "";
	var targetInstance:Dynamic = null;
	var hostCallbacks:Array<String> = [
		"is", "onBadgeDropped", "onBeatHit", "onClickMe", "onCreate", "onDestroy",
		"onDiscord", "onFreeplayItem", "onFreeplayOpen", "onFreeplaySong",
		"onFreeplaySongChanged", "onMenuItemSelected", "onMenuLongPress",
		"onMenuSwipe", "onMenuTap", "onMyButton", "onPageBack", "onPageClose",
		"onPageHello", "onPageItem", "onPageOpen", "onPageUpdate", "onShowSongs",
		"onStoryItem", "onStoryOpen", "onStoryWeek", "onStoryWeekChanged",
		"onUpdate", "printSongList"
	];

	var menuFont:String = "VCR OSD Mono";

	var shaders:Map<String, Dynamic> = new Map<String, Dynamic>();
	public function new(path:String, ?ctx:QuickJS)
	{
		scriptPath = path;
		context = ctx != null ? ctx : QuickJS.boot();
		setupVariables();
		setupScriptPaths();
		installWrappers();
		registerAll();
		var source:String = readScriptText(path);
		if (source != null) context.eval(source, path);
	}

	public function set(name:String, value:Dynamic):Void context.setGlobal(name, value);
	public function get(name:String):Dynamic return context.getGlobal(name);
	public function hasFunction(name:String):Bool return context.hasFunction(name);

	public function call(name:String, ?args:Array<Dynamic>):Dynamic
	{
		if (args == null) args = [];
		return callInternal(name, args);
	}

	public function callDestroy():Void call("onDestroy");
	public function handleNative(name:String, args:Array<Dynamic>):Dynamic return context.handleNative(name, args);

	public function close():Void
	{
		if (closed) return;
		closed = true;
		callDestroy();
	}


	public function hasCallback(name:String):Bool return hostCallbacks.indexOf(name) >= 0;

	public function fireCallback(name:String, ?args:Array<Dynamic>):Dynamic
	{
		if (!hasCallback(name)) return null;
		return callInternal(name, args == null ? [] : args);
	}

	public function callUpdate():Void fireCallback("onUpdate");
	public function callBeatHit():Void fireCallback("onBeatHit");

	public function noteTweenFunction(tag:String, id:Int, value:Dynamic, duration:Float, ?ease:String):Void {}
	public function oldTweenFunction(vars:String, duration:Float, ?ease:String):Void {}

	public function add(value:Dynamic):Void {}
	public function remove(value:Dynamic):Void {}
	public function clear():Void objects.clear();
	public function update():Void context.runPendingJobs();
	public function destroy():Void close();
	public function setup():Void setupVariables();
	public function toString():String return "FunkinJS(" + scriptPath + ")";
	function registerBackendFunctions():Void
	{
		addFunction("debugPrint", function(args:Array<Dynamic>):Dynamic { return debugPrint(args); });
		addFunction("getSongPosition", function(args:Array<Dynamic>):Dynamic { return Conductor.songPosition; });
		addFunction("getCurrentBeat", function(args:Array<Dynamic>):Dynamic { return Conductor.songPosition / Conductor.stepCrochet; });
		addFunction("getProperty", function(args:Array<Dynamic>):Dynamic { return resolveObject(aStr(args, 0)); });
		addFunction("setProperty", function(args:Array<Dynamic>):Dynamic { var p = aStr(args, 0).split('.'); if (p.length > 1) Reflect.setProperty(resolveObject(p[0]), p[1], args[1]); return null; });
	}

	function registerFileFunctions():Void
	{
		addFunction("resolvePath", function(args:Array<Dynamic>):Dynamic { return resolveReadPath(aStr(args, 0)); });
		addFunction("writeFile", function(args:Array<Dynamic>):Dynamic { return writeScriptFile(resolveReadPath(aStr(args, 0)), aStr(args, 1)); });
		addFunction("appendFile", function(args:Array<Dynamic>):Dynamic { var path = resolveReadPath(aStr(args, 0)); var old = readScriptText(path); return writeScriptFile(path, old + aStr(args, 1)); });
		addFunction("readFile", function(args:Array<Dynamic>):Dynamic { return readScriptText(resolveReadPath(aStr(args, 0))); });
		addFunction("fileExists", function(args:Array<Dynamic>):Dynamic { return sys.FileSystem.exists(resolveReadPath(aStr(args, 0))); });
		addFunction("getFileSize", function(args:Array<Dynamic>):Dynamic { var path = resolveReadPath(aStr(args, 0)); return sys.FileSystem.exists(path) ? sys.FileSystem.stat(path).size : -1; });
		addFunction("listFiles", function(args:Array<Dynamic>):Dynamic { return listScriptFiles(resolveReadPath(aStr(args, 0)), aStr(args, 1)); });
		addFunction("getAllSongs", function(args:Array<Dynamic>):Dynamic { return backend.SongList.allSongs(); });
		addFunction("getDifficultyList", function(args:Array<Dynamic>):Dynamic { return ['Easy', 'Normal', 'Hard']; });
		addFunction("getWeekCount", function(args:Array<Dynamic>):Dynamic { return backend.SongList.allWeeks().length; });
	}

	function registerGameFunctions():Void
	{
		addFunction("makeLuaSprite", function(args:Array<Dynamic>):Dynamic { storeMenuObject(aStr(args, 0), new flixel.FlxSprite(aNum(args, 2), aNum(args, 3))); return aStr(args, 0); });
		addFunction("makeGraphic", function(args:Array<Dynamic>):Dynamic { var s = menuSprite(aStr(args, 0)); if (s != null) s.makeGraphic(aInt(args, 1), aInt(args, 2), scriptColor(aStr(args, 3))); return null; });
		addFunction("screenCenter", function(args:Array<Dynamic>):Dynamic { var s = menuSprite(aStr(args, 0)); if (s != null) s.screenCenter(aStr(args, 1) == 'y' ? flixel.util.FlxAxes.Y : flixel.util.FlxAxes.X); return null; });
		addFunction("setObjectCamera", function(args:Array<Dynamic>):Dynamic { var s = menuSprite(aStr(args, 0)); if (s != null) s.cameras = [resolveBuiltinCamera(aStr(args, 1))]; return null; });
		addFunction("addLuaSprite", function(args:Array<Dynamic>):Dynamic { var s = menuSprite(aStr(args, 0)); if (s != null && menuState != null) menuState.add(s); return null; });
		addFunction("startVideo", function(args:Array<Dynamic>):Dynamic { playMenuVideo(aStr(args, 0), false, false); return null; });
		addFunction("exitToTitle", function(args:Array<Dynamic>):Dynamic { if (menuState != null) backend.MusicBeatState.switchState(new states.TitleState()); return null; });
		addFunction("openMenuState", function(args:Array<Dynamic>):Dynamic { if (menuState != null) backend.MusicBeatState.switchState(Type.createInstance(Type.resolveClass(aStr(args, 0)), [])); return null; });
	}

	function registerGameFunctions2():Void
	{
		addFunction("doTweenAlpha", function(args:Array<Dynamic>):Dynamic { var s = menuSprite(aStr(args, 1)); if (s != null) flixel.tweens.FlxTween.tween(s, {alpha: aNum(args, 2)}, aNum(args, 3)); return null; });
		addFunction("menuSelect", function(args:Array<Dynamic>):Dynamic { if (currentMainMenu != null) currentMainMenu.selectMenuItem(aInt(args, 0)); return null; });
		addFunction("getMenuSelected", function(args:Array<Dynamic>):Dynamic { return currentMainMenu != null ? currentMainMenu.getSelectedItem() : 0; });
		addFunction("changeWeek", function(args:Array<Dynamic>):Dynamic { if (currentStory != null) currentStory.selectPageItem(aInt(args, 0)); return null; });
		addFunction("menuRestart", function(args:Array<Dynamic>):Dynamic { if (menuState != null) flixel.FlxG.resetState(); return null; });
	}

	function registerInputFunctions():Void
	{
		addFunction("isMenuPointerDown", function(args:Array<Dynamic>):Dynamic { return menuGestures != null && menuGestures.isDown; });
		addFunction("getMenuSwipeDirection", function(args:Array<Dynamic>):Dynamic { return menuGestures != null ? menuGestures.swipeDirection : ''; });
		addFunction("getMenuGesture", function(args:Array<Dynamic>):Dynamic { return {direction: (menuGestures != null ? menuGestures.swipeDirection : ''), swiped: menuGestures != null && menuGestures.swiped, dragging: menuGestures != null && menuGestures.dragStarted}; });
		addFunction("setMenuGestureConfig", function(args:Array<Dynamic>):Dynamic { if (menuGestures != null) { menuGestures.swipeThreshold = aNum(args, 0); menuGestures.dragThreshold = aNum(args, 1); menuGestures.maxSwipeTime = aNum(args, 2); menuGestures.longPressTime = aNum(args, 3); } return null; });
	}

	function registerMenuFunctions():Void
	{
		addFunction("pageOpen", function(args:Array<Dynamic>):Dynamic { if (currentPage != null) currentPage.pushPage(aStr(args, 0)); return null; });
		addFunction("pageBack", function(args:Array<Dynamic>):Dynamic { if (currentPage != null) currentPage.back(); return null; });
		addFunction("pageTitle", function(args:Array<Dynamic>):Dynamic { if (currentPage != null) currentPage.setTitle(aStr(args, 0)); return null; });
		addFunction("pageAddItem", function(args:Array<Dynamic>):Dynamic { if (currentPage != null) currentPage.addPageText(cleanMenuTag(aStr(args, 0)), aStr(args, 1)); return null; });
		addFunction("pageSetState", function(args:Array<Dynamic>):Dynamic { if (currentPage != null) currentPage.setItemState(aStr(args, 0), aStr(args, 1)); return null; });
		addFunction("pageSetCallback", function(args:Array<Dynamic>):Dynamic { if (currentPage != null) currentPage.setItemCallback(aStr(args, 0), aStr(args, 1)); return null; });
		addFunction("pageSetPage", function(args:Array<Dynamic>):Dynamic { if (currentPage != null) currentPage.setItemPage(aStr(args, 0), aStr(args, 1)); return null; });
		addFunction("pageSetBGDim", function(args:Array<Dynamic>):Dynamic { if (currentPage != null) currentPage.setBackgroundDim(aNum(args, 0)); return null; });
		addFunction("pageSetBG", function(args:Array<Dynamic>):Dynamic { if (currentPage != null) currentPage.setBackgroundImage(aStr(args, 0)); return null; });
		addFunction("setMenuItemPage", function(args:Array<Dynamic>):Dynamic { if (currentPage != null) currentPage.setItemPage(aStr(args, 0), aStr(args, 1)); return null; });
		addFunction("setMenuItemState", function(args:Array<Dynamic>):Dynamic { if (currentMainMenu != null) currentMainMenu.setOptionState(aStr(args, 0), aStr(args, 1)); return null; });
		addFunction("setMenuItemColor", function(args:Array<Dynamic>):Dynamic { setMenuItemColorAt(aStr(args, 0), aStr(args, 1)); return null; });
		addFunction("setMenuItemCallback", function(args:Array<Dynamic>):Dynamic { if (currentMainMenu != null) currentMainMenu.setOptionCallback(aStr(args, 0), aStr(args, 1)); return null; });
		addFunction("setMenuItemVisible", function(args:Array<Dynamic>):Dynamic { setMenuTagVisible(aStr(args, 0), aBool(args, 1)); return null; });
		addFunction("setMenuItemEnabled", function(args:Array<Dynamic>):Dynamic { setMenuTagVisible(aStr(args, 0), aBool(args, 1)); return null; });
		addFunction("getMenuItemCount", function(args:Array<Dynamic>):Dynamic { return currentMainMenu != null ? currentMainMenu.getMenuItemCount() : 0; });
		addFunction("getMenuColumn", function(args:Array<Dynamic>):Dynamic { return currentMainMenu != null ? currentMainMenu.columnName() : 'center'; });
		addFunction("setMenuColumn", function(args:Array<Dynamic>):Dynamic { if (currentMainMenu != null) currentMainMenu.setColumnByName(aStr(args, 0)); return null; });
		addFunction("menuLayout", function(args:Array<Dynamic>):Dynamic { if (currentMainMenu != null) currentMainMenu.layoutMenuItems(aNum(args, 0), aNum(args, 1)); return null; });
		addFunction("menuOpenURL", function(args:Array<Dynamic>):Dynamic { flixel.FlxG.openURL(aStr(args, 0)); return null; });
		addFunction("menuUnlock", function(args:Array<Dynamic>):Dynamic { if (currentPage != null) currentPage.unlockPage(); return null; });
		addFunction("menuLock", function(args:Array<Dynamic>):Dynamic { if (currentPage != null) currentPage.lockPage(); return null; });
		addFunction("hideAllMenuObjects", function(args:Array<Dynamic>):Dynamic { setAllMenuVisible(false); return null; });
	}

	function registerMiscFunctions():Void
	{
		addFunction("addMenuText", function(args:Array<Dynamic>):Dynamic { var t = new flixel.text.FlxText(aNum(args, 2), aNum(args, 3), 0, aStr(args, 1), aInt(args, 4)); storeMenuObject(aStr(args, 0), t); return aStr(args, 0); });
		addFunction("addMenuImage", function(args:Array<Dynamic>):Dynamic { var s = new flixel.FlxSprite(aNum(args, 2), aNum(args, 3)); try { s.loadGraphic(backend.Paths.image(aStr(args, 1))); } catch (e:Dynamic) {} scaleMenuSprite(s, aNum(args, 4)); storeMenuObject(aStr(args, 0), s); return aStr(args, 0); });
		addFunction("addMenuImageFromFile", function(args:Array<Dynamic>):Dynamic { var s = new flixel.FlxSprite(aNum(args, 2), aNum(args, 3)); try { s.loadGraphic(openfl.display.BitmapData.fromFile(aStr(args, 1))); } catch (e:Dynamic) {} scaleMenuSprite(s, aNum(args, 4)); storeMenuObject(aStr(args, 0), s); return aStr(args, 0); });
		addFunction("addMenuButton", function(args:Array<Dynamic>):Dynamic { if (currentPage != null) currentPage.addScriptButton(aStr(args, 0), aStr(args, 1), aNum(args, 2), aNum(args, 3), aStr(args, 4)); return aStr(args, 0); });
		addFunction("addMenuItem", function(args:Array<Dynamic>):Dynamic { if (currentMainMenu != null) currentMainMenu.addMenuItem(aStr(args, 0), aStr(args, 1), null, null, aStr(args, 4), aStr(args, 5)); return aStr(args, 0); });
		addFunction("addMenuItemText", function(args:Array<Dynamic>):Dynamic { if (currentMainMenu != null) currentMainMenu.addMenuItemText(aStr(args, 0), aStr(args, 1), aInt(args, 2), aStr(args, 3), null, null); return aStr(args, 0); });
		addFunction("menuScreenCenter", function(args:Array<Dynamic>):Dynamic { var s = menuSprite(aStr(args, 0)); if (s != null) s.screenCenter(aStr(args, 1) == 'y' ? flixel.util.FlxAxes.Y : flixel.util.FlxAxes.X); return null; });
		addFunction("setMenuBG", function(args:Array<Dynamic>):Dynamic { if (currentPage != null) currentPage.setBackgroundImage(aStr(args, 0)); return null; });
		addFunction("setMenuBGColor", function(args:Array<Dynamic>):Dynamic { if (currentPage != null) currentPage.setBackgroundDim(aNum(args, 0)); return null; });
		addFunction("showMenuObject", function(args:Array<Dynamic>):Dynamic { setMenuTagVisible(aStr(args, 0), true); return null; });
		addFunction("hideMenuObject", function(args:Array<Dynamic>):Dynamic { setMenuTagVisible(aStr(args, 0), false); return null; });
		addFunction("destroyMenuObject", function(args:Array<Dynamic>):Dynamic { dropMenuObject(aStr(args, 0)); return null; });
		addFunction("attachMenuObject", function(args:Array<Dynamic>):Dynamic { backend.MenuUI.attach(aStr(args, 0), aStr(args, 1)); return null; });
		addFunction("detachMenuObject", function(args:Array<Dynamic>):Dynamic { backend.MenuUI.detach(aStr(args, 0)); return null; });
		addFunction("replaceMenuObject", function(args:Array<Dynamic>):Dynamic { return placeReplacement(aStr(args, 0), aStr(args, 1)); });
		addFunction("replaceMenuObjectText", function(args:Array<Dynamic>):Dynamic { return replacementTag(aStr(args, 0)); });
		addFunction("restoreMenuObject", function(args:Array<Dynamic>):Dynamic { backend.MenuUI.restoreObject(restoreMenuTag(aStr(args, 0))); return null; });
		addFunction("restoreMenuObjects", function(args:Array<Dynamic>):Dynamic { backend.MenuUI.clear(); return null; });
		addFunction("getMenuObjects", function(args:Array<Dynamic>):Dynamic { return menuObjectList(); });
		addFunction("setMenuObjectDraggable", function(args:Array<Dynamic>):Dynamic { backend.MenuUI.setDraggable(aStr(args, 0), aBool(args, 1)); return null; });
		addFunction("setMenuObjectCallback", function(args:Array<Dynamic>):Dynamic { if (currentMainMenu != null) currentMainMenu.setOptionCallback(aStr(args, 0), aStr(args, 1)); return null; });
		addFunction("setMenuObjectVisible", function(args:Array<Dynamic>):Dynamic { setMenuTagVisible(aStr(args, 0), aBool(args, 1)); return null; });
		addFunction("setMenuObjectAlpha", function(args:Array<Dynamic>):Dynamic { backend.MenuUI.setAlpha(aStr(args, 0), aNum(args, 1)); return null; });
		addFunction("isMenuObjectAttached", function(args:Array<Dynamic>):Dynamic { return backend.MenuUI.isAttached(aStr(args, 0)); });
		addFunction("getMenuAttachTarget", function(args:Array<Dynamic>):Dynamic { return backend.MenuUI.find(aStr(args, 0)); });
	}

	function registerVideoFunctions():Void
	{
		addFunction("startMenuVideo", function(args:Array<Dynamic>):Dynamic { playMenuVideo(aStr(args, 0), optFlag(args, 1, 'background'), optFlag(args, 1, 'layer')); return null; });
		addFunction("stopMenuVideo", function(args:Array<Dynamic>):Dynamic { stopMenuVideo(); return null; });
		addFunction("isMenuVideoPlaying", function(args:Array<Dynamic>):Dynamic { return menuVideoPlaying; });
		addFunction("isMenuVideoBackground", function(args:Array<Dynamic>):Dynamic { return menuVideoBackground; });
		addFunction("isMenuVideoLayer", function(args:Array<Dynamic>):Dynamic { return menuVideoLayer; });
	}

	function registerFreeplayFunctions():Void
	{
		addFunction("freeplayGetSongCount", function(args:Array<Dynamic>):Dynamic { return backend.SongList.allSongs().length; });
		addFunction("freeplayGetSelectedSong", function(args:Array<Dynamic>):Dynamic { return currentFreeplay != null ? currentFreeplay.getSelectedSong() : ''; });
		addFunction("freeplayGetSongName", function(args:Array<Dynamic>):Dynamic { return currentFreeplay != null ? currentFreeplay.getSelectedSong() : ''; });
		addFunction("freeplayPlaySong", function(args:Array<Dynamic>):Dynamic { if (currentFreeplay != null) currentFreeplay.confirmSong(); return null; });
		addFunction("freeplaySetSongPage", function(args:Array<Dynamic>):Dynamic { if (currentFreeplay != null) currentFreeplay.setPageName(aStr(args, 0)); return null; });
		addFunction("freeplaySetSongState", function(args:Array<Dynamic>):Dynamic { if (currentFreeplay != null) currentFreeplay.setStateName(aStr(args, 0)); return null; });
		addFunction("freeplaySetSongCallback", function(args:Array<Dynamic>):Dynamic { if (currentFreeplay != null) currentFreeplay.setCallbackName(aStr(args, 0)); return null; });
		addFunction("freeplaySetSongIcon", function(args:Array<Dynamic>):Dynamic { return replaceMenuImage(aStr(args, 0), aStr(args, 1)); });
		addFunction("freeplaySetSongIconText", function(args:Array<Dynamic>):Dynamic { return replaceMenuText(aStr(args, 0), aStr(args, 1)); });
		addFunction("freeplaySetSongIconVisible", function(args:Array<Dynamic>):Dynamic { setMenuTagVisible(aStr(args, 0), aBool(args, 1)); return null; });
		addFunction("freeplayRestoreSongIcon", function(args:Array<Dynamic>):Dynamic { backend.MenuUI.restoreObject(aStr(args, 0)); return null; });
		addFunction("freeplayIsSongIconReplaced", function(args:Array<Dynamic>):Dynamic { return backend.MenuUI.isReplaced(aStr(args, 0)); });
	}

	function registerStoryFunctions():Void
	{
		addFunction("storyGetWeekCount", function(args:Array<Dynamic>):Dynamic { return backend.SongList.allWeeks().length; });
		addFunction("storyGetSelectedWeekId", function(args:Array<Dynamic>):Dynamic { return currentStory != null ? currentStory.getPageSelectedId() : ''; });
		addFunction("storyGetDifficultyName", function(args:Array<Dynamic>):Dynamic { return currentStory != null ? currentStory.getDifficultyNameAt(aInt(args, 0)) : 'Normal'; });
		addFunction("storySetWeekPage", function(args:Array<Dynamic>):Dynamic { if (currentStory != null) currentStory.setItemPage(aStr(args, 0), aStr(args, 1)); return null; });
		addFunction("storySetWeekCallback", function(args:Array<Dynamic>):Dynamic { if (currentStory != null) currentStory.setItemCallback(aStr(args, 0), aStr(args, 1)); return null; });
		addFunction("storySetWeekState", function(args:Array<Dynamic>):Dynamic { if (currentStory != null) currentStory.setItemState(aStr(args, 0), aStr(args, 1)); return null; });
		addFunction("storySetWeekURL", function(args:Array<Dynamic>):Dynamic { if (currentStory != null) currentStory.setItemURL(aStr(args, 0), aStr(args, 1)); return null; });
		addFunction("storySetWeekIcon", function(args:Array<Dynamic>):Dynamic { return replaceMenuImage(aStr(args, 0), aStr(args, 1)); });
		addFunction("storySetWeekIconText", function(args:Array<Dynamic>):Dynamic { return replaceMenuText(aStr(args, 0), aStr(args, 1)); });
		addFunction("storySetWeekIconVisible", function(args:Array<Dynamic>):Dynamic { setMenuTagVisible(aStr(args, 0), aBool(args, 1)); return null; });
		addFunction("storyRestoreWeekIcon", function(args:Array<Dynamic>):Dynamic { backend.MenuUI.restoreObject(aStr(args, 0)); return null; });
		addFunction("storyIsWeekIconReplaced", function(args:Array<Dynamic>):Dynamic { return backend.MenuUI.isReplaced(aStr(args, 0)); });
	}

	function registerTweenFunctions():Void
	{
		addFunction("doTweenAlpha", function(args:Array<Dynamic>):Dynamic { var s = menuSprite(aStr(args, 1)); if (s != null) flixel.tweens.FlxTween.tween(s, {alpha: aNum(args, 2)}, aNum(args, 3)); return null; });
	}

	function registerSpriteFunctions():Void
	{
		addFunction("makeLuaSprite", function(args:Array<Dynamic>):Dynamic { storeMenuObject(aStr(args, 0), new flixel.FlxSprite(aNum(args, 2), aNum(args, 3))); return aStr(args, 0); });
		addFunction("makeGraphic", function(args:Array<Dynamic>):Dynamic { var s = menuSprite(aStr(args, 0)); if (s != null) s.makeGraphic(aInt(args, 1), aInt(args, 2), scriptColor(aStr(args, 3))); return null; });
		addFunction("screenCenter", function(args:Array<Dynamic>):Dynamic { var s = menuSprite(aStr(args, 0)); if (s != null) s.screenCenter(aStr(args, 1) == 'y' ? flixel.util.FlxAxes.Y : flixel.util.FlxAxes.X); return null; });
		addFunction("setObjectCamera", function(args:Array<Dynamic>):Dynamic { var s = menuSprite(aStr(args, 0)); if (s != null) s.cameras = [resolveBuiltinCamera(aStr(args, 1))]; return null; });
		addFunction("addLuaSprite", function(args:Array<Dynamic>):Dynamic { var s = menuSprite(aStr(args, 0)); if (s != null && menuState != null) menuState.add(s); return null; });
	}

	function registerTextFunctions():Void
	{
		addFunction("addMenuText", function(args:Array<Dynamic>):Dynamic { var t = new flixel.text.FlxText(aNum(args, 2), aNum(args, 3), 0, aStr(args, 1), aInt(args, 4)); storeMenuObject(aStr(args, 0), t); return aStr(args, 0); });
		addFunction("debugPrint", function(args:Array<Dynamic>):Dynamic { return debugPrint(args); });
	}

	function registerReflectionFunctions():Void
	{
		addFunction("getProperty", function(args:Array<Dynamic>):Dynamic { return resolveObject(aStr(args, 0)); });
		addFunction("setProperty", function(args:Array<Dynamic>):Dynamic { var p = aStr(args, 0).split('.'); if (p.length > 1) Reflect.setProperty(resolveObject(p[0]), p[1], args[1]); return null; });
	}

	function registerScriptFunctions():Void
	{
		addFunction("addHScript", function(args:Array<Dynamic>):Dynamic { scriptsHost.add(aStr(args, 0), null); return null; });
		addFunction("removeHScript", function(args:Array<Dynamic>):Dynamic { scriptsHost.remove(aStr(args, 0)); return null; });
	}

	function registerSoundFunctions():Void
	{
		addFunction("playSound", function(args:Array<Dynamic>):Dynamic { flixel.FlxG.sound.play(backend.Paths.sound(aStr(args, 0)), optNum(args, 1, 1)); return null; });
		addFunction("stopSound", function(args:Array<Dynamic>):Dynamic { flixel.FlxG.sound.music.stop(); return null; });
	}

	function registerAnimateFunctions():Void
	{
		addFunction("makeAnimatedLuaSprite", function(args:Array<Dynamic>):Dynamic {
			var s = new flixel.FlxSprite(aNum(args, 2), aNum(args, 3));
			try
			{
				s.frames = backend.Paths.getAtlas(aStr(args, 1));
				s.antialiasing = backend.ClientPrefs.data.antialiasing;
			}
			catch (e:Dynamic) {}
			storeMenuObject(aStr(args, 0), s);
			return aStr(args, 0);
		});
		addFunction("addAnimationByPrefix", function(args:Array<Dynamic>):Dynamic {
			var s = menuSprite(aStr(args, 0));
			if (s == null || s.frames == null) return null;
			var animName:String = aStr(args, 1);
			var fps:Int = (args.length > 3 && args[3] != null) ? aInt(args, 3) : 24;
			var loop:Bool = (args.length > 4) ? aBool(args, 4) : true;
			if (!s.animation.exists(animName)) s.animation.addByPrefix(animName, aStr(args, 2), fps, loop);
			return animName;
		});
		addFunction("objectPlayAnimation", function(args:Array<Dynamic>):Dynamic {
			var s = menuSprite(aStr(args, 0));
			if (s != null && args.length > 1 && args[1] != null) s.animation.play(aStr(args, 1));
			return null;
		});
	}

	function registerPianoKeyFunctions():Void
	{
		addFunction("pianoKeyCount", function(args:Array<Dynamic>):Dynamic { return 0; });
		addFunction("pianoKeyPressed", function(args:Array<Dynamic>):Dynamic { return false; });
	}

	function registerCoreFunctions():Void
	{
		addFunction("debugPrint", function(args:Array<Dynamic>):Dynamic { return debugPrint(args); });
		addFunction("jsTrace", function(args:Array<Dynamic>):Dynamic { return jsTrace(args); });
		addFunction("writeLog", function(args:Array<Dynamic>):Dynamic { writeScriptFile(defaultWriteFolder + '/js.log', aStr(args, 0)); return null; });
	}


	function registerAll():Void
	{

		registerBackendFunctions();
		registerFileFunctions();
		registerGameFunctions();
		registerGameFunctions2();
		registerInputFunctions();
		registerMenuFunctions();
		registerMiscFunctions();
		registerVideoFunctions();
		registerFreeplayFunctions();
		registerStoryFunctions();
		registerTweenFunctions();
		registerSpriteFunctions();
		registerTextFunctions();
		registerReflectionFunctions();
		registerScriptFunctions();
		registerSoundFunctions();
		registerAnimateFunctions();
		registerPianoKeyFunctions();
		registerCoreFunctions();
	}

	function addFunction(name:String, fn:Dynamic):Void
	{
		callbacks.set(name, fn);
		context.setGlobal(name, fn);
	}

	function addLocalCallback(name:String, fn:Dynamic):Void callbacks.set(name, fn);
	function wrapperFor(name:String):Dynamic return wrappers.get(name);
	function bindSave(name:String, value:Dynamic):Void context.setGlobal(name, value);

	function callAlias(name:String, args:Array<Dynamic>):Dynamic
	{
		var target:String = aliases.get(name);
		return target != null ? callInternal(target, args) : null;
	}

	function callInternal(name:String, args:Array<Dynamic>):Dynamic
	{
		var fn:Dynamic = callbacks.get(name);
		arg = args;
		applyMenuArgs(args);
		if (fn != null) return Reflect.callMethod(null, fn, [args]);
		return context.call(name, args);
	}

	function callTweenHook(tag:String, vars:Dynamic):Void call("onTweenCompleted", [tag, vars]);

	function aStr(args:Array<Dynamic>, i:Int):String
	{
		if (args == null || i >= args.length || args[i] == null) return "";
		return Std.string(args[i]);
	}

	function aInt(args:Array<Dynamic>, i:Int):Int
	{
		var v:Null<Int> = Std.parseInt(aStr(args, i));
		return v == null ? 0 : v;
	}

	function aNum(args:Array<Dynamic>, i:Int):Float
	{
		var v:Float = Std.parseFloat(aStr(args, i));
		return Math.isNaN(v) ? 0 : v;
	}

	function aBool(args:Array<Dynamic>, i:Int):Bool
	{
		if (args == null || i >= args.length) return false;
		return args[i] == true || args[i] == 1 || aStr(args, i) == "true";
	}

	function aArr(args:Array<Dynamic>, i:Int):Array<Dynamic>
	{
		if (args == null || i >= args.length || !Std.isOfType(args[i], Array)) return [];
		return cast args[i];
	}

	function toIntArray(a:Array<Dynamic>):Array<Int> return [for (v in a) Std.int(v)];
	function toFloatArray(a:Array<Dynamic>):Array<Float> return [for (v in a) Std.parseFloat(Std.string(v))];
	function toBoolArray(a:Array<Dynamic>):Array<Bool> return [for (v in a) v == true];

	function optNum(args:Array<Dynamic>, i:Int, fallback:Float):Float
	{
		return (args == null || i >= args.length) ? fallback : aNum(args, i);
	}

	function optFlag(args:Array<Dynamic>, i:Int, key:String):Bool
	{
		if (args == null || i >= args.length || args[i] == null) return false;
		return Reflect.field(args[i], key) == true;
	}

	function setupVariables():Void
	{
		context.setGlobal("scriptDirectory", folderOfPath(scriptPath));
		context.setGlobal("modRoot", modsRootFor(scriptPath));
		context.setGlobal("defaultWriteFolder", defaultWriteFolder);
		context.setGlobal("menuFont", menuFont);
	}

	function setupScriptPaths():Void
	{
		defaultWriteFolder = modsRootFor(scriptPath) + "/saves";
		createFoldersFor(defaultWriteFolder);
	}

	function installWrappers():Void
	{
		aliases.set("print", "debugPrint");
		aliases.set("trace", "jsTrace");
		aliases.set("log", "writeLog");
	}

	function folderOfPath(path:String):String
	{
		if (path == null) return "";
		var p:String = path.replace("\\", "/");
		var i:Int = p.lastIndexOf("/");
		return i >= 0 ? p.substr(0, i) : "";
	}

	function parentFolderOf(path:String):String return folderOfPath(folderOfPath(path));

	function modsRootFor(path:String):String
	{
		var f:String = folderOfPath(path);
		return f.indexOf("/scripts") >= 0 ? f.substr(0, f.indexOf("/scripts")) : f;
	}

	function collapseFilePath(path:String):String
	{
		if (path == null) return "";
		return path.replace("\\", "/").replace("/./", "/");
	}

	function isAbsoluteFilePath(path:String):Bool
	{
		return path != null && (path.indexOf("/") == 0 || path.charAt(1) == ":");
	}

	function resolveReadPath(path:String):String
	{
		if (path == null) return defaultWriteFolder;
		if (isAbsoluteFilePath(path)) return collapseFilePath(path);
		if (path.indexOf("./") == 0) return folderOfPath(scriptPath) + "/" + path.substr(2);
		return modsRootFor(scriptPath) + "/" + path;
	}

	function resolvePath(path:String):String return resolveReadPath(path);
	function resolveModFolder(path:String):String return modsRootFor(path);
	function pathExists(path:String):Bool return sys.FileSystem.exists(path);

	function createFoldersFor(path:String):Void
	{
		if (path == null || path == "" || sys.FileSystem.exists(path)) return;
		try { sys.FileSystem.createDirectory(path); } catch (e:Dynamic) {}
	}

	function readScriptText(path:String):String
	{
		try { return sys.io.File.getContent(path); } catch (e:Dynamic) return null;
	}

	function writeScriptFile(path:String, data:String):Bool
	{
		try { createFoldersFor(folderOfPath(path)); sys.io.File.saveContent(path, data); return true; }
		catch (e:Dynamic) return false;
	}

	function listScriptFiles(folder:String, ?filter:String):Array<String>
	{
		var out:Array<String> = [];
		if (!sys.FileSystem.exists(folder)) return out;
		for (name in sys.FileSystem.readDirectory(folder))
			if (filter == null || filter == "" || name.indexOf(filter) >= 0) out.push(name);
		return out;
	}

	function findScript(name:String):String
	{
		var p:String = resolveReadPath(name);
		return sys.FileSystem.exists(p) ? p : null;
	}

	function findRunningScript(name:String):Dynamic return callbacks.get(name);

	function scriptError(text:String):Void
	{
		logLines.push("ERROR: " + text);
		trace("[JS] " + text);
	}

	function writeLog(text:String):Void logLines.push(text);

	function debugPrint(args:Array<Dynamic>):Dynamic
	{
		trace("[JS] " + aStr(args, 0));
		return null;
	}

	function jsTrace(args:Array<Dynamic>):Dynamic
	{
		trace("[JS] " + aStr(args, 0));
		return null;
	}

	function readBitmapData(path:String):Dynamic
	{
		var target:String = resolveReadPath(path);
		if (!sys.FileSystem.exists(target)) return null;
		try { return sys.io.File.getBytes(target); }
		catch (e:Dynamic) return null;
	}

	function stopMenuVideo():Void stopMenuVideoImpl();

	function applyMenuArgs(args:Array<Dynamic>):Void
	{
		menuColumnArg = aStr(args, 0);
		menuIndexArg = aInt(args, 0);
		songArg = aStr(args, 0);
		weekArg = aStr(args, 0);
		tagIndex = menuObjectList().indexOf(cleanMenuTag(aStr(args, 0)));
		sideOption = aStr(args, 1);
		targetInstance = resolveObject(aStr(args, 0));
		mainMenuItem = currentMainMenu != null ? Reflect.field(currentMainMenu, "items") : null;
	}

	function menuObject(tag:String):Dynamic return objects.get(cleanMenuTag(tag));
	function menuSprite(tag:String):FlxSprite
	{
		var o:Dynamic = objects.get(cleanMenuTag(tag));
		return Std.isOfType(o, FlxSprite) ? cast o : null;
	}
	function textByTag(tag:String):FlxText
	{
		var o:Dynamic = objects.get(cleanMenuTag(tag));
		return Std.isOfType(o, FlxText) ? cast o : null;
	}
	function soundByTag(tag:String):Dynamic return objects.get(cleanMenuTag(tag));
	function spritesOf():Array<Dynamic> return [for (k in objects.keys()) objects.get(k)];
	function groupMembers(group:Dynamic):Array<Dynamic> return group != null ? [for (m in cast(group, Array<Dynamic>)) m] : [];
	function menuObjectList():Array<String> return [for (k in objects.keys()) k];
	function menuObjectInfo(tag:String):Dynamic
	{
		var o:Dynamic = objects.get(cleanMenuTag(tag));
		return o == null ? null : { tag: tag, x: Reflect.field(o, "x"), y: Reflect.field(o, "y"), alpha: Reflect.field(o, "alpha") };
	}
	function cleanMenuTag(tag:String):String return tag == null ? "" : StringTools.trim(tag);
	function restoreMenuTag(tag:String):String return cleanMenuTag(tag);

	function storeMenuObject(tag:String, obj:Dynamic):Void
	{
		var key:String = cleanMenuTag(tag);
		objects.set(key, obj);
		MenuUI.register(key, obj);
		if (obj != null && Std.isOfType(obj, FlxSprite) && menuState != null)
		{
			var exists:Bool = false;
			for (m in menuState.members) if (m == obj) { exists = true; break; }
			if (!exists) menuState.add(cast obj);
		}
	}

	function dropMenuObject(tag:String):Void
	{
		var key:String = cleanMenuTag(tag);
		var obj:Dynamic = objects.get(key);
		if (obj != null && Std.isOfType(obj, FlxSprite) && menuState != null) menuState.remove(cast obj);
		objects.remove(key);
		MenuUI.remove(key);
	}

	function setMenuTagVisible(tag:String, v:Bool):Void MenuUI.setVisible(cleanMenuTag(tag), v);
	function setAllMenuVisible(v:Bool):Void { if (v) MenuUI.showAll(); else MenuUI.hideAll(); }
	function makeMenuObjectClickable(tag:String, cb:String):Void callbacks.set(cleanMenuTag(tag), cb);

	function scriptColor(value:String):Int
	{
		if (value == null) return 0xFFFFFFFF;
		var hex:String = StringTools.replace(value, "#", "");
		return Std.parseInt("0x" + hex);
	}

	function resolveObject(path:String):Dynamic
	{
		if (path == null) return null;
		var parts:Array<String> = path.split(".");
		var obj:Dynamic = objects.get(cleanMenuTag(parts[0]));
		if (obj == null) obj = Reflect.field(PlayState.instance, parts[0]);
		if (obj != null && parts.length > 1) obj = Reflect.field(obj, parts[1]);
		return obj;
	}

	function resolveObjectPath(path:String):String return resolveReadPath(path);
	function resolveClass(name:String):Dynamic return Type.resolveClass(name);
	function resolveBuiltinCamera(name:String):flixel.FlxCamera
	{
		return switch (name)
		{
			case "hud": flixel.FlxG.camera;
			case "game": flixel.FlxG.camera;
			default: flixel.FlxG.camera;
		};
	}

	function cameraOfPath(name:String):flixel.FlxCamera return resolveBuiltinCamera(name);
	function getShader(name:String):Dynamic return shaders.get(name);
	function initLuaShader(name:String):Void shaders.set(name, null);
	function applyCameraShader(cam:flixel.FlxCamera, name:String):Void {}
	function applySpriteShader(sprite:FlxSprite, name:String):Void {}
	function applyItemImage(tag:String, image:String):Void {}
	function legacySpriteShader(sprite:FlxSprite):Dynamic return null;

	function setMenuItemColorAt(tag:String, color:String):Void
	{
		var o:Dynamic = objects.get(cleanMenuTag(tag));
		if (o != null) Reflect.setField(o, "color", scriptColor(color));
	}

	function replacementTag(tag:String):String return cleanMenuTag(tag) + "_custom";

	function placeReplacement(tag:String, image:String):String
	{
		var key:String = cleanMenuTag(tag);
		MenuUI.replacementOf(key, replacementTag(key));
		return replacementTag(key);
	}

	function replaceMenuImage(tag:String, image:String):String return placeReplacement(tag, image);
	function replaceMenuText(tag:String, text:String):String
	{
		var t:FlxText = textByTag(tag);
		if (t != null) t.text = text;
		return replacementTag(tag);
	}

	function scaleMenuSprite(sprite:FlxSprite, scale:Float):Void
	{
		if (sprite == null || scale <= 0) return;
		sprite.scale.set(scale, scale);
		sprite.updateHitbox();
	}

	function playMenuVideo(name:String, background:Bool, layer:Bool):Void
	{
		menuVideoPlaying = true;
		menuVideoBackground = background;
		menuVideoLayer = layer;
	}

	function stopMenuVideoImpl():Void
	{
		menuVideoPlaying = false;
		menuVideoBackground = false;
		menuVideoLayer = false;
	}

	function placeMenuVideoLayer(state:flixel.FlxBasic, target:flixel.FlxBasic):Void
	{
		if (state == null || target == null) return;
		if (Std.isOfType(state, flixel.FlxState))
		{
			var st:flixel.FlxState = cast state;
			st.remove(target, true);
			st.add(target);
		}
	}

}
