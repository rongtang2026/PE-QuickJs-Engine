package psychlua;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import backend.Language;
import backend.LoadTrace;
import backend.MathApi;
import backend.MenuNav;
import backend.PhysicsApi;
import backend.QuickJS;
import backend.Song;
import backend.WeekData;

import haxe.Json;

import states.CustomMenuState;
import states.FreeplayState;
import states.MainMenuState;
import states.StoryMenuState;
import states.TitleState;

import sys.FileSystem;
import sys.io.File;

class FunkinJS
{
	public static var scriptsHost:Array<FunkinJS> = [];
	public static var apiNames:Array<String> = [];
	static var booted:Bool = false;

	public var scriptFile:String;
	public var scriptName:String;
	public var pageScript:Bool = false;
	public var host:Dynamic = null;

	var qjs:QuickJS;
	var alive:Bool = true;
	var objects:Map<String, FlxBasic> = new Map();
	var objectPaths:Map<String, String> = new Map();
	var snapshotData:Dynamic = null;
	var modSettingsData:Dynamic = null;
	var scriptDirectory:String = '';
	var modRoot:String = '';

	public function new(scriptFile:String, ?host:Dynamic = null)
	{
		this.scriptFile = scriptFile;
		this.host = host;
		scriptName = haxe.io.Path.withoutDirectory(scriptFile);
		pageScript = scriptFile.indexOf('/menu/') >= 0;

		boot();
		qjs = new QuickJS();
		qjs.onDispatch(dispatch);

		for (name in apiNames)
			qjs.registerNative(name, name);

		setupVariables();

		final code:String = readScriptText(scriptFile);
		if (code != null)
		{
			final result = qjs.eval(code, scriptFile);
			final err = qjs.lastError();
			if (err != null && err.length > 0) scriptError(err);
			qjs.clearError();
		}

		refreshSnapshot();
		scriptsHost.push(this);
	}

	public static function boot():Void
	{
		if (booted) return;
		booted = true;
		buildApiNames();
	}

	static function buildApiNames():Void
	{
		apiNames = [
			'debugPrint', 'jsTrace', 'writeLog', 'scriptError',
			'setProperty', 'getShader', 'initLuaShader',
			'makeSprite', 'makeAnimatedSprite', 'addSprite', 'removeSprite', 'addAnimation',
			'addAnimationByPrefix', 'addAnimationByIndices', 'playAnim', 'screenCenter', 'setGraphicSize',
			'scaleObject', 'setScrollFactor', 'setObjectCamera', 'applySpriteShader', 'applyCameraShader',
			'makeText', 'addText', 'setTextString', 'setTextSize', 'setTextWidth', 'setTextColor',
			'setTextFont', 'setTextAlignment', 'setTextBorder',
			'playSound', 'playMusic', 'stopSound', 'pauseSound', 'resumeSound', 'setSoundVolume',
			'doTweenX', 'doTweenY', 'doTweenAlpha', 'doTweenAngle', 'doTweenZoom', 'doTweenColor', 'cancelTween',
			'runTimer', 'call', 'callTweenHook',
			'addMenuText', 'addMenuImage', 'addMenuImageFromFile', 'addMenuButton',
			'addMenuItemText', 'addMenuItem', 'setMenuItemState', 'setMenuItemPage', 'setMenuItemCallback',
			'setMenuItemURL', 'setMenuItemColor', 'setMenuItemVisible', 'setMenuItemEnabled',
			'hideMenuObject', 'showMenuObject', 'destroyMenuObject', 'restoreMenuObjects', 'hideAllMenuObjects',
			'menuLayout', 'menuSelect', 'setMenuColumn', 'menuScreenCenter', 'setMenuBG', 'setMenuBGColor',
			'setMenuObjectVisible', 'setMenuObjectAlpha', 'setMenuObjectCallback', 'setMenuObjectDraggable',
			'setMenuGestureConfig', 'attachMenuObject', 'detachMenuObject',
			'openMenuState', 'exitToTitle', 'menuRestart', 'menuOpenURL', 'menuLock', 'menuUnlock',
			'pageOpen', 'pageBack', 'pageTitle', 'pageSetBG', 'pageSetBGDim', 'pageAddItem',
			'pageSetState', 'pageSetPage', 'pageSetCallback', 'pageSetURL', 'pageRemoveItem', 'pageClearItems',
			'startMenuVideo', 'stopMenuVideo', 'freeplayPlaySong', 'storySetWeekState', 'freeplaySetSongState',
			'addCustomRank', 'removeRank', 'clearCustomRanks', 'resetRanks', 'setRankAccuracy',
			'setRatingWindow', 'setRatingScore', 'setRatingMod', 'setRatingImage', 'setRatingHits',
			'setRatingNoteSplash', 'addCustomRating', 'removeCustomRating', 'clearCustomRatings', 'resetRatings',
			'setRatingPercent', 'setRatingName', 'setRatingFC', 'addCustomFCBadge', 'removeCustomFCBadge',
			'clearCustomFCBadges', 'setFCBadgeRequirement', 'clearFCBadgeRequirements', 'setFCBadgeMaxMisses',
			'setFCBadgeMinAccuracy', 'setFCBadgePriority', 'refreshFCBadge', 'setNoteKeyCount', 'setNoteLaneCount',
			'addNoteLane', 'removeNoteLane', 'setNoteLaneEnabled', 'setNoteLaneAlpha', 'setNoteLaneOffset',
			'refreshLaneLayout', 'resetNoteLanes', 'setupNoteLanes', 'addHealthIconBand', 'setHealthIconFrames',
			'clearHealthIconFrames', 'cameraShake', 'cameraFlash', 'cameraFade',
			'freeplayGetSongName', 'freeplayGetSongCharacter', 'freeplayGetSongColor', 'freeplayGetSelected',
			'freeplaySelectSong', 'freeplayConfirmSong', 'freeplayIsPlayingPreview', 'freeplayGetDifficulty',
			'freeplaySetDifficulty', 'freeplaySetTouchMode', 'storyGetWeekCount', 'storyGetWeekId',
			'storyGetWeekName', 'storyGetWeekSongs', 'storyGetSelectedWeek', 'storyIsWeekLocked',
			'storySetWeekState', 'storySetWeekCallback', 'storySetWeekPage', 'storySetWeekURL',
			'createPianoKeys', 'removePianoKeys', 'addPianoKey', 'removePianoKey', 'clearPianoKeys',
			'setPianoKeysAnchor', 'setPianoKeysHeight', 'setPianoKeysGap', 'setPianoKeysMargin',
			'setPianoKeysPosition', 'setPianoKeysArt', 'setPianoKeysAlpha', 'setPianoKeysVisible',
			'setPianoKeysEnabled', 'setPianoKeyLabel', 'setPianoKeyColor', 'setPianoKeyTextColor',
			'setPianoKeyTextSize', 'setPianoKeyImage', 'setPianoKeyAction', 'setPianoKeyKey',
			'setPianoKeyWeight', 'setPianoKeyWidth', 'setPianoKeyHeight', 'setPianoKeyOffset',
			'setPianoKeyEnabled',
			'videoFillScreen', 'videoFitScreen', 'setVideoSize', 'setVideoScale', 'setVideoPos',
			'setVideoAutoLayout', 'setVideoAlpha', 'pauseVideo', 'resumeVideo',
			'addLoadingText', 'addLoadingImage', 'hideLoadingObject', 'showLoadingObject',
			'moveLoadingObject', 'setLoadingText', 'setLoadingBackgroundColor',
			'setHealth', 'addHealth', 'setHealthOverflow', 'setHealthMax', 'setHealthMin', 'setHealthBounds',
			'setHealthDisplayMax', 'setHealthPercent', 'setDeathHealth', 'setHealthClamp', 'setHealthLock',
			'setInvincible', 'setHealthRegen', 'setHealthDrain', 'setHealthGain', 'setHealthLoss',
			'setSustainHealth', 'setSustainHealthMult',
			'setMenuTextString', 'setMenuTextColor', 'setMenuObjectPos', 'setMenuObjectScale', 'setMenuObjectAngle',
			'removeMenuObject', 'showAllMenuObjects', 'setMenuBGVisible', 'setMenuMagentaAlpha', 'refreshMenu',
			'setMenuItemPos', 'setMenuItemScale', 'setMenuItemAlpha', 'setMenuItemImage', 'addMenuItemFromFile',
			'setMenuButtonCallback', 'removeMenuButton', 'removeMenuItem',
			'setMenuOptionState', 'setMenuOptionCallback', 'setMenuOptionPage',
			'pageSetPos', 'pageSetScale', 'pageSetColor', 'pageSetVisible', 'pageSetEnabled',
			'pageSelect', 'pageActivate', 'pageLock', 'pageAddImageItem', 'pageAddImageItemFromFile', 'pageLayout',
			'storySelectWeek', 'storyConfirmWeek',
			'hideWeek', 'showWeek', 'clearHiddenWeeks', 'refreshWeeks',
			'createExtraStrumGroup', 'removeExtraStrumGroup', 'clearExtraStrumGroups',
			'setExtraStrumPos', 'setExtraStrumScale', 'setExtraStrumSpacing', 'setExtraStrumAlpha',
			'setExtraStrumVisible', 'setExtraStrumCamera', 'setExtraStrumSkin', 'setExtraStrumJudge',
			'setExtraStrumAction', 'setExtraStrumActive', 'spawnExtraNote', 'setExtraStrumFollow',
			'setHealthBarVisible', 'setHealthBarAlpha', 'setHealthBarPosition', 'setHealthBarMode',
			'setHealthBarStretchFactor', 'setHealthBarMaxWidth', 'setHealthBarShiftPixelsPerHp',
			'setHealthBarShiftMax', 'setHealthBarModeSmooth', 'setHealthBarColors',
			'setFPSPanelVisible', 'setFPSPanelAlpha', 'setFPSPanelPosition', 'setFPSPanelCollapsed',
			'toggleFPSPanel', 'setFPSPanelClickable', 'setFPSPanelTextColor', 'setFPSPanelFontSize',
			'setFPSPanelBackgroundVisible', 'setFPSPanelBackgroundColor', 'setFPSPanelBackgroundAlpha',
			'setFPSPanelBackgroundImage', 'setFPSPanelBackgroundImageAlpha', 'resetFPSPanel',
			'replaceMenuObject', 'replaceMenuObjectText', 'restoreMenuObject', 'attachMenuObject',
			'detachMenuObject', 'setMenuObjectDraggable', 'setMenuGestureConfig', 'stopMenuDrag',
			'menuPlaySound', 'setMenuCameraZoom', 'setMenuCameraAngle', 'setMenuCameraShake', 'resetMenuCamera',
			'freeplaySetSongIcon', 'freeplaySetSongIconText', 'freeplaySetSongIconVisible', 'freeplayRestoreSongIcon',
			'storySetWeekIcon', 'storySetWeekIconText', 'storySetWeekIconVisible', 'storyRestoreWeekIcon',
			'addJSScript', 'addScript', 'removeJSScript', 'removeScript', 'callScript', 'setVar', 'setOnScripts',
			'callOnScripts', 'loadSong', 'refreshRank', 'regenerateApiDocs',
			'setAchievementScore', 'addAchievementScore', 'unlockAchievement',
			'setMenuSideState', 'setMenuSideCallback', 'setMenuSidePage', 'setMenuSideVisible',
			'setMenuSidePos', 'setMenuSideColor', 'setMenuSideImage',
			'initLuaShader', 'setSpriteShader', 'setSpriteShaderShared', 'removeSpriteShader',
			'setCameraShader', 'removeCameraShader', 'setShaderBool', 'setShaderBoolArray',
			'setShaderInt', 'setShaderIntArray', 'setShaderFloat', 'setShaderFloatArray',
			'setShaderSampler2D', 'setShaderColor', 'setShaderVec2', 'setShaderVec3', 'setShaderVec4',
			'setShaderTime', 'setShaderTimeScale', 'setShaderAutoTime', 'clearModShaders',
			'close', 'setDebugMode', 'hideVanillaWeeks', 'showVanillaWeeks', 'setVanillaWeeksHidden',
			'freeplaySetSongPage', 'freeplaySetSongURL',
			'getFPS', 'getProcessMemory', 'getDataMemory', 'getDeviceMemory', 'getMemoryPercent',
			'makeLuaSprite', 'makeLuaText', 'addLuaSprite', 'removeLuaSprite', 'addLuaText',
			'getProperty', 'getMenuItemCount', 'getMenuSelected', 'getMenuColumn', 'getPageItemCount',
			'getPageSelected', 'getPageSelectedId', 'getPageName', 'getPageItemId', 'getPageItemIndex',
			'getAllSongs', 'getWeekCount', 'getDifficultyList', 'getDifficultyName',
			'storyGetSelectedWeekId', 'storyGetDifficultyName', 'storyGetDifficulty',
			'freeplayGetSongCount', 'freeplayGetSelectedSong',
			'isMenuVideoPlaying', 'isMenuVideoBackground', 'isMenuVideoLayer', 'isMenuPointerDown', 'getMenuSwipeDirection',
			'getRankNames', 'getRankAccuracy', 'getRankAt', 'getRank',
			'getRatingNames', 'getRatingWindow', 'getRatingScore', 'getRatingMod', 'getRatingImage', 'getRatingHits',
			'getRatingNoteSplash', 'getFCBadgeNames', 'getFCBadgeMaxMisses', 'getFCBadgeMinAccuracy', 'getFCBadgePriority',
			'getFCBadgeMinHits', 'getFCBadgeMaxHits',
			'getNoteKeyCount', 'getNoteLaneCount', 'isNoteLaneEnabled', 'getNoteLaneAlpha', 'getNoteLaneOffset',
			'getHealthIconFrame', 'getHealthIconFrames', 'getHealthIconFrameCount',
			'getMenuItem', 'getMenuItemEnabled', 'getMenuItemVisible', 'getMenuItemId', 'getMenuItemIndex',
			'getMenuItemX', 'getMenuItemY', 'getMenuItemWidth', 'getMenuItemHeight',
			'getMenuObjects', 'getMenuObjectCount', 'getMenuLocked', 'hasMenuObject', 'isMenuObjectVisible',
			'pianoKeysExist', 'getPianoKeyCount', 'getPianoKeysAnchor', 'getPianoKeysHeight', 'getPianoKeysGap',
			'getPianoKeysMargin', 'getPianoKeysAlpha', 'getPianoKeysVisible', 'getPianoKeysEnabled', 'getPianoKeysX',
			'getPianoKeysY', 'getPianoKeyLabel', 'getPianoKeyX', 'getPianoKeyY', 'getPianoKeyWidth', 'getPianoKeyHeight',
			'isPianoKeyPressed', 'isPianoKeyJustPressed', 'isPianoKeyJustReleased', 'getPianoKeyHoldTime',
			'getVideoAlpha', 'getVideoLayout', 'isVideoPlaying', 'getVideoName', 'getLastFinishedVideo', 'isVideoFinished',
			'getHealth', 'getHealthMax', 'getHealthMin', 'getHealthDisplayMax', 'getHealthPercent', 'getHealthOverflow',
			'getHealthClamp', 'isHealthLocked', 'isInvincible', 'getDeathHealth', 'getHealthRegen', 'getHealthDrain',
			'getHealthGain', 'getHealthLoss', 'getSustainHealth', 'getSustainHealthMult',
			'pageIsOpen', 'getPageLocked', 'getAllSongNames', 'getAllWeeks', 'getSongCount', 'getSongName',
			'getSongWeek', 'getWeekId', 'getWeekSongs', 'isWeekUnlocked', 'getSongDifficulties', 'getDifficultyCount',
			'freeplayGetDifficultyName', 'freeplayGetTouchMode', 'getHiddenWeeks', 'isWeekHidden',
			'getExtraStrumGroups', 'hasExtraStrum', 'getExtraStrumPos', 'getExtraStrumActive', 'getHealthBarMode',
			'getFPSPanelVisible', 'getFPSPanelAlpha', 'getFPSPanelX', 'getFPSPanelY', 'getFPSPanelCollapsed',
			'getFPSPanelClickable', 'getFPSPanelTextColor', 'getFPSPanelFontSize', 'getFPSPanelBackgroundVisible',
			'getFPSPanelBackgroundColor', 'getFPSPanelBackgroundImage', 'getFPSPanelBackgroundImageAlpha',
			'getMenuReplacement', 'isMenuObjectReplaced', 'isMenuObjectAttached', 'getMenuAttachTarget',
			'isMenuObjectDraggable', 'isMenuObjectDragging', 'getMenuDragTag', 'getMenuGesture',
			'freeplayIsSongIconReplaced', 'storyIsWeekIconReplaced', 'getMenuSideOption',
			'getRunningScripts', 'isRunning', 'getVar', 'getAchievementScore', 'isAchievementUnlocked',
			'achievementExists', 'getModSetting',
			'getShaderBool', 'getShaderInt', 'getShaderFloat', 'getShaderBoolArray', 'getShaderIntArray',
			'getShaderFloatArray', 'shaderExists', 'getShaderNames', 'getShaderDebug', 'getShaderFolders',
			'isVanillaWeeksHidden', 'getTranslationPhrase', 'getFileTranslation',
			'getScriptDirectory', 'getModDirectory', 'resolvePath', 'fileExists', 'checkFileExists',
			'readFile', 'getTextFromFile', 'getFileSize', 'listFiles', 'directoryFileList',
			'writeFile', 'saveFile', 'appendFile', 'deleteFile', 'createDirectory', 'deleteDirectory',
			'mVec3Add', 'mVec3Sub', 'mVec3Scale', 'mVec3Cross', 'mVec3Lerp', 'mVec3Dot', 'mVec3Len', 'mVec3Norm',
			'mMat4New', 'mMat4Free', 'mMat4Identity', 'mMat4Set', 'mMat4Copy', 'mMat4Get', 'mMat4Mul',
			'mMat4Translate', 'mMat4Scale', 'mMat4Rotate', 'mMat4Perspective', 'mMat4Ortho', 'mMat4LookAt', 'mMat4MulV3',
			'fbm2',
			'physWorldCreate', 'physWorldFree', 'physWorldSetGravity', 'physWorldSetIterations', 'physStep',
			'physBodyCount', 'physAddCircle', 'physAddBox', 'physAddBody', 'physAddPoly', 'physAddTriangle',
			'physAddHexagon', 'physAddRegular', 'physAddStar', 'physAddCapsule', 'physAddEllipse', 'physAddTrapezoid',
			'physAddRightTriangle', 'physAddDiamond', 'physAddCross', 'physShapeNames', 'physAddShapeCircle',
			'physAddShapeBox', 'physAddShapePoly', 'physShapeCount', 'physClearShapes', 'physRemove', 'physSetPos',
			'physSetAngle', 'physSetVelocity', 'physSetAngularVelocity', 'physSetFriction', 'physSetElasticity',
			'physApplyImpulse', 'physApplyForce', 'physGetTransform', 'physReadAll', 'physLastError',
			'physSetCircleRadius', 'physSetBoxSize', 'physSetMass', 'physSetScale', 'physSetAutoSquash',
			'physGetImpact', 'physClearImpact', 'physSetBodyType', 'physSetDensity', 'physSetGravityScale',
			'physSetLinearDamping', 'physSetVelocityLimit', 'physSetSleeping', 'physSetSensor', 'physSetFilter',
			'physQueryPoint'
		];
	}

	public function isAlive():Bool
		return alive && qjs != null && qjs.isAlive();

	public function hasFunction(name:String):Bool
	{
		if (!isAlive()) return false;
		try
			return qjs.hasFunction(name)
		catch (e:Dynamic)
			return false;
	}

	public function call(name:String, ?args:Array<Dynamic>):Dynamic
	{
		if (!isAlive()) return null;
		try
		{
			final value = qjs.call(name, args == null ? [] : args);
			handleNative();
			return value;
		}
		catch (e:Dynamic)
		{
			scriptError('' + e);
			return null;
		}
	}

	public function handleNative():Bool
	{
		if (!isAlive()) return false;
		return qjs.handleNative();
	}

	public function close():Void
	{
		if (!alive) return;
		alive = false;
		scriptsHost.remove(this);
		try
			qjs.close()
		catch (e:Dynamic) {}
		qjs = null;
		objects = new Map();
	}

	public static function findScript(path:String):FunkinJS
	{
		for (script in scriptsHost)
			if (script.scriptFile == path) return script;
		return null;
	}

	public static function findRunningScript(name:String):FunkinJS
	{
		for (script in scriptsHost)
			if (script.scriptName == name) return script;
		return null;
	}

	public function readScriptText(path:String):String
	{
		try
			if (FileSystem.exists(path)) return File.getContent(path)
		catch (e:Dynamic) {}
		return null;
	}

	public function writeScriptFile(path:String, content:String):Bool
	{
		try
		{
			createFoldersFor(path);
			File.saveContent(path, content);
			return true;
		}
		catch (e:Dynamic)
			return false;
	}

	static function createFoldersFor(path:String):Void
	{
		final folder = haxe.io.Path.directory(path);
		if (folder != null && folder.length > 0 && !FileSystem.exists(folder))
			FileSystem.createDirectory(folder);
	}

	public function scriptError(message:String):Void
	{
		LoadTrace.warn('JS [$scriptName] ' + message);
	}

	public function debugPrint(message:Dynamic):Void
	{
		Sys.println('[$scriptName] ' + message);
	}

	function setupVariables():Void
	{
		final dir:String = haxe.io.Path.directory(scriptFile);
		scriptDirectory = dir;
		modRoot = haxe.io.Path.directory(dir);
		qjs.setGlobal('scriptName', scriptName);
		qjs.setGlobal('scriptFile', scriptFile);
		qjs.setGlobal('scriptDirectory', scriptDirectory);
		qjs.setGlobal('modRoot', modRoot);
		qjs.setGlobal('currentModDirectory', Mods.currentModDirectory);
		qjs.setGlobal('version', '1.1');

		final settings:Dynamic = {};
		try
		{
			final settingsPath:String = haxe.io.Path.directory(dir) + '/data/settings.json';
			if (FileSystem.exists(settingsPath))
			{
				final parsed:Dynamic = haxe.Json.parse(File.getContent(settingsPath));
				if (Std.isOfType(parsed, Array))
				{
					for (entry in cast(parsed, Array<Dynamic>))
					{
						if (entry == null || entry.save == null) continue;
						if (entry.value != null) Reflect.setField(settings, Std.string(entry.save), entry.value);
						else if (entry.keyboard != null || entry.gamepad != null)
							Reflect.setField(settings, Std.string(entry.save), {keyboard: entry.keyboard, gamepad: entry.gamepad});
					}
				}
			}
		}
		catch (e:Dynamic) {}
		modSettingsData = settings;
		qjs.setGlobal('modSettings', settings);
		bindSave();
	}

	function bindSave():Void
	{
		if (FlxG.save != null && FlxG.save.data != null)
		{
			try
				qjs.setGlobal('save', FlxG.save.data)
			catch (e:Dynamic) {}
		}
	}

	public function refreshSnapshot():Void
	{
		if (!isAlive()) return;
		final ui = menuUI();

		var itemList:Array<Dynamic> = [];
		if (ui != null)
		{
			for (item in ui.items)
			{
				var entry:Dynamic = {id: item.id, label: item.label, enabled: item.enabled, visible: item.visible, x: 0, y: 0, width: 0, height: 0};
				if (item.sprite != null)
				{
					Reflect.setField(entry, 'x', item.sprite.x);
					Reflect.setField(entry, 'y', item.sprite.y);
					Reflect.setField(entry, 'width', item.sprite.width);
					Reflect.setField(entry, 'height', item.sprite.height);
				}
				itemList.push(entry);
			}
		}

		final songs:Array<Dynamic> = [];
		try
		{
			final entries = backend.SongList.allSongs();
			for (entry in entries)
				songs.push({
					song: entry.song, week: entry.week, weekIndex: entry.weekIndex, weekName: entry.weekName,
					background: entry.background, character: entry.character, color: entry.color,
					difficulties: entry.difficulties, unlocked: entry.unlocked
				});
		}
		catch (e:Dynamic) {}

		final weekIds:Array<String> = backend.SongList.allWeeks();

		var storyWeek:String = null;
		var storyDiff:String = null;
		var freeplayCount:Int = 0;
		var freeplaySelected:String = null;
		var freeplayDifficulty:String = null;
		var freeplayTouchMode:String = null;
		final freeplaySongs:Array<String> = [];

		if (Std.isOfType(FlxG.state, StoryMenuState))
		{
			try
			{
				final index:Int = Reflect.getProperty(FlxG.state, 'curWeek');
				if (index >= 0 && index < weekIds.length) storyWeek = weekIds[index];
				storyDiff = Difficulty.getString(Std.int(Reflect.getProperty(FlxG.state, 'curDifficulty')), false);
			}
			catch (e:Dynamic) {}
		}
		if (Std.isOfType(FlxG.state, FreeplayState))
		{
			try
			{
				@:privateAccess
				{
					final state:FreeplayState = cast FlxG.state;
					freeplayCount = state.songs.length;
					final songSelected:Int = FreeplayState.curSelected;
					if (songSelected >= 0 && songSelected < state.songs.length) freeplaySelected = state.songs[songSelected].songName;
					freeplayDifficulty = state.getDifficultyNameAt(state.getDifficultyIndex());
					freeplayTouchMode = state.getTouchMode();
					for (song in state.songs) freeplaySongs.push(song.songName);
				}
			}
			catch (e:Dynamic) {}
		}

		final props:Dynamic = {};
		for (tag in objects.keys())
		{
			final obj = objects.get(tag);
			if (Std.isOfType(obj, FlxSprite))
			{
				final spr:FlxSprite = cast obj;
				Reflect.setField(props, tag + '.x', spr.x);
				Reflect.setField(props, tag + '.y', spr.y);
				Reflect.setField(props, tag + '.alpha', spr.alpha);
				Reflect.setField(props, tag + '.angle', spr.angle);
				Reflect.setField(props, tag + '.visible', spr.visible);
				Reflect.setField(props, tag + '.scale.x', spr.scale.x);
				Reflect.setField(props, tag + '.scale.y', spr.scale.y);
			}
		}

		var menuCount:Int = ui == null ? 0 : ui.items.length;
		var menuSelected:Int = ui == null ? 0 : ui.selected;
		var menuSelectedId:String = ui == null ? null : ui.getPageSelectedId();
		var menuColumn:String = ui == null ? 'center' : ui.column;
		var menuPage:String = ui == null ? null : ui.currentPage;
		var menuLocked:Bool = ui == null ? false : ui.pageLocked;
		var menuSideLeft:String = null;
		var menuSideRight:String = null;

		if (ui == null && Std.isOfType(FlxG.state, MainMenuState))
		{
			final state:MainMenuState = cast FlxG.state;
			@:privateAccess
			{
				menuCount = state.optionShit.length;
				menuSelected = MainMenuState.curSelected;
				menuColumn = Std.string(MainMenuState.curColumn).toLowerCase();
			}
			itemList = [];
			@:privateAccess
			for (i in 0...state.optionShit.length)
			{
				final id = state.optionShit[i];
				var entry:Dynamic = {id: id, label: id, enabled: true, visible: i < state.menuItems.length && state.menuItems.members[i].visible, x: 0, y: 0, width: 0, height: 0};
				if (i < state.menuItems.length)
				{
					final spr = state.menuItems.members[i];
					Reflect.setField(entry, 'x', spr.x);
					Reflect.setField(entry, 'y', spr.y);
					Reflect.setField(entry, 'width', spr.width);
					Reflect.setField(entry, 'height', spr.height);
					Reflect.setField(entry, 'enabled', state.getMenuItemEnabledAt(i));
				}
				itemList.push(entry);
			}
			if (menuSelected >= 0 && menuSelected < itemList.length) menuSelectedId = itemList[menuSelected].id;
			@:privateAccess menuLocked = state.selectedSomethin;
			menuSideLeft = state.getSideOptionName('left');
			menuSideRight = state.getSideOptionName('right');
		}

		final game:PlayState = PlayState.instance;

		final rankNames:Array<String> = game == null ? [] : game.getRankNames();
		final rankList:Array<Dynamic> = [];
		for (name in rankNames)
			rankList.push({name: name, accuracy: game.getRankAccuracy(name)});

		final ratingNames:Array<String> = game == null ? [] : game.getRatingNames();
		final ratingWindow:Dynamic = {};
		final ratingScore:Dynamic = {};
		final ratingMod:Dynamic = {};
		final ratingImage:Dynamic = {};
		final ratingHits:Dynamic = {};
		final ratingSplash:Dynamic = {};
		for (name in ratingNames)
		{
			Reflect.setField(ratingWindow, name, game.getRatingWindow(name));
			Reflect.setField(ratingScore, name, game.getRatingScore(name));
			Reflect.setField(ratingMod, name, game.getRatingMod(name));
			Reflect.setField(ratingImage, name, game.getRatingImage(name));
			Reflect.setField(ratingHits, name, game.getRatingHits(name));
			Reflect.setField(ratingSplash, name, game.getRatingNoteSplash(name));
		}

		final badgeNames:Array<String> = game == null ? [] : game.getFCBadgeNames();
		final badgeMaxMisses:Dynamic = {};
		final badgeMinAccuracy:Dynamic = {};
		final badgePriority:Dynamic = {};
		final badgeMinHits:Dynamic = {};
		final badgeMaxHits:Dynamic = {};
		for (name in badgeNames)
		{
			Reflect.setField(badgeMaxMisses, name, game.getFCBadgeMaxMisses(name));
			Reflect.setField(badgeMinAccuracy, name, game.getFCBadgeMinAccuracy(name));
			Reflect.setField(badgePriority, name, game.getFCBadgePriority(name));
			var minHits:Dynamic = {};
			var maxHits:Dynamic = {};
			for (rating in ratingNames)
			{
				Reflect.setField(minHits, rating, game.getFCBadgeMinHits(name, rating));
				Reflect.setField(maxHits, rating, game.getFCBadgeMaxHits(name, rating));
			}
			Reflect.setField(badgeMinHits, name, minHits);
			Reflect.setField(badgeMaxHits, name, maxHits);
		}

		final laneKeys:Int = game == null ? 4 : game.getNoteKeyCount();
		final lanePlayer:Int = game == null ? 1 : game.getNoteLaneCount(true);
		final laneOpponent:Int = game == null ? 1 : game.getNoteLaneCount(false);
		final laneEnabled:Array<Bool> = game == null ? [] : game.laneEnabled;
		final laneAlpha:Array<Float> = game == null ? [] : game.laneAlpha;
		final laneOffset:Array<Float> = game == null ? [] : game.laneOffset;

		final iconBands:Int = game == null ? 0 : game.getHealthIconBands();
		final iconFrame:Int = game == null ? 0 : game.getHealthIconFrame();
		final iconCount:Int = game == null ? 0 : game.getHealthIconFrameCount();

		final menuObjects:Array<Dynamic> = [];
		for (tag in MenuScripts.objects.keys())
		{
			final obj = MenuScripts.objects.get(tag);
			if (obj == null) continue;
			var info:Dynamic = {tag: tag, visible: obj.visible, alpha: 1, angle: 0, x: 0, y: 0, width: 0, height: 0};
			if (Std.isOfType(obj, FlxSprite))
			{
				final spr:FlxSprite = cast obj;
				Reflect.setField(info, 'alpha', spr.alpha);
				Reflect.setField(info, 'angle', spr.angle);
				Reflect.setField(info, 'x', spr.x);
				Reflect.setField(info, 'y', spr.y);
				Reflect.setField(info, 'width', spr.width);
				Reflect.setField(info, 'height', spr.height);
			}
			menuObjects.push(info);
		}

		final replacementMap:Dynamic = {};
		for (tag in menuReplacements.keys())
		{
			final entry:Dynamic = menuReplacements.get(tag);
			if (entry != null) Reflect.setField(replacementMap, tag, entry.tag);
		}
		final attachMap:Dynamic = {};
		for (tag in menuAttachments.keys())
		{
			final entry:Dynamic = menuAttachments.get(tag);
			if (entry != null) Reflect.setField(attachMap, tag, {target: entry.target, ox: entry.ox, oy: entry.oy});
		}
		final draggableMap:Dynamic = {};
		for (tag in menuDraggables.keys()) Reflect.setField(draggableMap, tag, true);

		final freeplayIconReplaced:Array<Int> = [];
		final storyIconReplaced:Array<Int> = [];
		for (key in iconOverlays.keys())
		{
			final parts:Array<String> = key.split(':');
			final indexValue:Null<Int> = Std.parseInt(parts.length > 1 ? parts[1] : '');
			if (indexValue == null) continue;
			if (parts[0] == 'freeplay') freeplayIconReplaced.push(indexValue);
			else if (parts[0] == 'story') storyIconReplaced.push(indexValue);
		}

		final scriptNames:Array<String> = [];
		for (script in scriptsHost) scriptNames.push(script.scriptName);

		final sharedVars:Dynamic = {};
		for (key in MusicBeatState.getVariables().keys())
		{
			final value:Dynamic = MusicBeatState.getVariables().get(key);
			if (value == null || Std.isOfType(value, Bool) || Std.isOfType(value, Int) || Std.isOfType(value, Float) || Std.isOfType(value, String))
				Reflect.setField(sharedVars, key, value);
		}

		final achievementNames:Array<String> = [];
		final achievementUnlocked:Array<String> = [];
		final achievementScores:Dynamic = {};
		#if ACHIEVEMENTS_ALLOWED
		for (name in Achievements.achievements.keys())
		{
			achievementNames.push(name);
			Reflect.setField(achievementScores, name, Achievements.getScore(name));
		}
		for (name in Achievements.achievementsUnlocked) achievementUnlocked.push(name);
		#end

		final shaderMap:Dynamic = {};
		shaderClock += Math.max(0, Math.min(0.1, backend.FrameClock.rawDelta));
		for (obj in shaderAuto.keys())
		{
			final autoEntry:Dynamic = shaderAuto.get(obj);
			final shader = runtimeShaderFor(obj);
			if (shader != null && autoEntry != null)
				shader.setFloat(autoEntry.prop, shaderClock * autoEntry.scale);
		}
		for (obj in shaderUniforms.keys())
		{
			final values:Map<String, Dynamic> = shaderUniforms.get(obj);
			final entry:Dynamic = {};
			for (prop in values.keys()) Reflect.setField(entry, prop, values.get(prop));
			Reflect.setField(shaderMap, obj, entry);
		}
		final shaderNameMap:Dynamic = {};
		for (obj in shaderNames.keys()) Reflect.setField(shaderNameMap, obj, shaderNames.get(obj));
		final loadedShaders:Array<String> = [];
		if (game != null) for (name in game.runtimeShaders.keys()) loadedShaders.push(name);
		final shaderFolders:Array<String> = [];
		#if MODS_ALLOWED
		for (directory in Mods.getModDirectories())
			if (FileSystem.exists(directory + 'shaders')) shaderFolders.push(directory + 'shaders');
		#end

		final phraseMap:Dynamic = {};
		#if TRANSLATIONS_ALLOWED
		@:privateAccess
		for (key in Language.phrases.keys()) Reflect.setField(phraseMap, key, Language.phrases.get(key));
		#end

		final videoInfo:Dynamic = {
			playing: backend.VideoAudio.playing(),
			background: false,
			layer: false,
			alpha: game == null ? 0 : game.getVideoAlpha(),
			layout: game == null ? 'none' : game.getVideoLayout(),
			playingVideo: game != null && game.isVideoPlaying(),
			name: game == null ? null : game.getVideoName(),
			last: game == null ? null : game.getLastFinishedVideo(),
			finished: game != null && game.isVideoFinished()
		};

		final extraNames:Array<String> = [];
		final extraData:Dynamic = {};
		if (game != null)
		{
			for (id in game.extraStrumGroups.keys())
			{
				extraNames.push(id);
				final info:Dynamic = game.getExtraStrumPos(id);
				if (info != null) Reflect.setField(extraData, id, info);
			}
		}

		final panel = backend.FpsPanelApi.getPanel();
		final perf:Dynamic = {
			fps: panel.getShownFPS(),
			processMemory: backend.FpsPanelApi.getProcessMemoryMB(),
			dataMemory: backend.FpsPanelApi.getDataMemoryMB(),
			deviceMemory: backend.FpsPanelApi.getDeviceMemoryMB(),
			memoryPercent: backend.FpsPanelApi.getMemoryPercent(),
			visible: panel.visible,
			alpha: panel.alpha,
			x: panel.x,
			y: panel.y,
			collapsed: panel.collapsed,
			clickable: panel.clickable,
			textColor: panel.customTextColor,
			fontSize: panel.getFontSize(),
			backgroundVisible: panel.backgroundVisible,
			backgroundColor: panel.bgColorValue,
			backgroundImage: panel.backgroundImagePath,
			backgroundImageAlpha: panel.backgroundImageAlpha
		};

		final snapshot:Dynamic = {
			menu: {
				count: menuCount,
				selected: menuSelected,
				selectedId: menuSelectedId,
				column: menuColumn,
				page: menuPage,
				locked: menuLocked,
				sideLeft: menuSideLeft,
				sideRight: menuSideRight,
				items: itemList,
				objects: menuObjects,
				objectCount: menuObjects.length,
				replacements: replacementMap,
				attachments: attachMap,
				draggables: draggableMap,
				dragging: dragTag,
				gesture: {
					down: gestureState.down,
					x: gestureState.x,
					y: gestureState.y,
					dx: gestureState.dx,
					dy: gestureState.dy,
					swipe: gestureState.swipe
				}
			},
			songs: songs,
			weeks: weekIds,
			weeksHidden: WeekData.hiddenWeekNames(),
			difficulties: Difficulty.list,
			story: {week: storyWeek, difficulty: storyDiff, iconReplaced: storyIconReplaced},
			freeplay: {count: freeplayCount, selected: freeplaySelected, songs: freeplaySongs, difficulty: freeplayDifficulty, touchMode: freeplayTouchMode, iconReplaced: freeplayIconReplaced},
			props: props,
			ranks: {names: rankNames, list: rankList, current: game == null ? null : game.getRank()},
			ratings: {names: ratingNames, window: ratingWindow, score: ratingScore, mod: ratingMod, image: ratingImage, hits: ratingHits, splash: ratingSplash},
			fcBadges: {names: badgeNames, maxMisses: badgeMaxMisses, minAccuracy: badgeMinAccuracy, priority: badgePriority, minHits: badgeMinHits, maxHits: badgeMaxHits},
			lanes: {keys: laneKeys, player: lanePlayer, opponent: laneOpponent, enabled: laneEnabled, alpha: laneAlpha, offset: laneOffset},
			icons: {bands: iconBands, frame: iconFrame, count: iconCount},
			health: {
				value: game == null ? 0 : game.getHealth(),
				max: game == null ? 2 : game.getHealthMax(),
				min: game == null ? 0 : game.getHealthMin(),
				displayMax: game == null ? 2 : game.getHealthDisplayMax(),
				percent: game == null ? 0 : game.getHealthPercent(),
				overflow: game != null && game.getHealthOverflow(),
				clamp: game == null ? true : game.getHealthClamp(),
				locked: game != null && game.isHealthLocked(),
				invincible: game != null && game.isInvincible(),
				death: game == null ? 0 : game.getDeathHealth(),
				regen: game == null ? 0 : game.getHealthRegen(),
				drain: game == null ? 0 : game.getHealthDrain(),
				gain: game == null ? 1 : game.getHealthGain(),
				loss: game == null ? 1 : game.getHealthLoss(),
				sustain: game == null ? true : game.getSustainHealth(),
				sustainMult: game == null ? 1 : game.getSustainHealthMult()
			},
			piano: pianoSnapshot(),
			video: videoInfo,
			extraStrums: {names: extraNames, data: extraData, active: game == null ? null : game.extraStrumActive},
			game: {healthBarMode: game == null ? 1 : game.healthBarMode},
			perf: perf,
			scripts: scriptNames,
			vars: sharedVars,
			achievements: {names: achievementNames, unlocked: achievementUnlocked, scores: achievementScores},
			shaders: shaderMap,
			shaderNames: shaderNameMap,
			shadersLoaded: loadedShaders,
			shaderFolders: shaderFolders,
			phrases: phraseMap,
			vanillaWeeksHidden: vanillaWeeksHidden,
			gestures: {down: FlxG.mouse.pressed, swipe: ''}
		};
		snapshotData = snapshot;
		qjs.setGlobal('__pe', snapshot);
	}

	static var pianoConfig:Dynamic = null;
	static var pianoKeys:Array<Dynamic> = [];
	static var pianoGroup:FlxSpriteGroup = null;
	static var pianoScript:FunkinJS = null;
	static var pianoAlpha:Float = 1;
	static var pianoVisible:Bool = true;
	static var pianoEnabled:Bool = true;
	static var pianoAnchor:String = 'bottom';
	static var pianoHeight:Float = 110;
	static var pianoGap:Float = 6;
	static var pianoMargin:Float = 14;
	static var pianoX:Float = 0;
	static var pianoY:Float = 0;

	static function fieldNum(obj:Dynamic, name:String, def:Float):Float
	{
		if (obj == null) return def;
		final value:Dynamic = Reflect.field(obj, name);
		if (value == null) return def;
		if (Std.isOfType(value, String)) return Std.parseFloat(cast value);
		return cast(value, Float);
	}

	static function fieldStr(obj:Dynamic, name:String, def:String):String
	{
		if (obj == null) return def;
		final value:Dynamic = Reflect.field(obj, name);
		return value == null ? def : Std.string(value);
	}

	static function fieldBool(obj:Dynamic, name:String, def:Bool):Bool
	{
		if (obj == null) return def;
		final value:Dynamic = Reflect.field(obj, name);
		if (value == null) return def;
		if (Std.isOfType(value, Bool)) return cast value;
		return Std.string(value) == 'true';
	}

	static function newPianoKey(cfg:Dynamic):Dynamic
	{
		return {
			label: fieldStr(cfg, 'label', ''),
			key: fieldStr(cfg, 'key', ''),
			action: fieldStr(cfg, 'action', ''),
			image: fieldStr(cfg, 'image', ''),
			colour: fieldStr(cfg, 'color', '000000'),
			pressedColour: fieldStr(cfg, 'pressedColor', '00FF88'),
			textColour: fieldStr(cfg, 'textColor', 'FFFFFF'),
			textSize: fieldNum(cfg, 'textSize', 18),
			weight: fieldNum(cfg, 'weight', 1),
			width: fieldNum(cfg, 'width', 0),
			height: fieldNum(cfg, 'height', 0),
			offset: fieldNum(cfg, 'offset', 0),
			enabled: fieldBool(cfg, 'enabled', true),
			pressed: false,
			justPressed: false,
			justReleased: false,
			holdTime: 0,
			x: 0,
			y: 0,
			renderWidth: 0,
			renderHeight: 0,
			bg: null,
			labelSprite: null
		};
	}

	function createPianoKeys(cfg:Dynamic):Void
	{
		pianoAnchor = fieldStr(cfg, 'anchor', 'bottom');
		pianoHeight = fieldNum(cfg, 'height', 110);
		pianoGap = fieldNum(cfg, 'gap', 6);
		pianoMargin = fieldNum(cfg, 'margin', 14);
		pianoAlpha = fieldNum(cfg, 'alpha', 1);
		pianoVisible = fieldBool(cfg, 'visible', true);
		pianoEnabled = fieldBool(cfg, 'enabled', true);
		pianoX = fieldNum(cfg, 'x', 0);
		pianoY = fieldNum(cfg, 'y', 0);
		pianoConfig = cfg;
		pianoScript = this;

		final count:Int = Std.int(fieldNum(cfg, 'count', 4));
		pianoKeys = [];
		for (i in 0...count)
			pianoKeys.push(newPianoKey(cfg));
		rebuildPianoKeys();
	}

	function addPianoKey(cfg:Dynamic):Int
	{
		pianoKeys.push(newPianoKey(cfg));
		if (pianoConfig != null)
		{
			pianoScript = this;
			rebuildPianoKeys();
		}
		return pianoKeys.length - 1;
	}

	function removePianoKey(index:Int):Void
	{
		if (index < 0 || index >= pianoKeys.length) return;
		pianoKeys.splice(index, 1);
		rebuildPianoKeys();
	}

	function clearPianoKeys():Void
	{
		pianoKeys = [];
		rebuildPianoKeys();
	}

	function removePianoKeys():Void
	{
		pianoKeys = [];
		pianoConfig = null;
		pianoScript = null;
		if (pianoGroup != null)
		{
			pianoGroup.destroy();
			pianoGroup = null;
		}
	}

	function rebuildPianoKeys():Void
	{
		if (pianoGroup != null)
		{
			pianoGroup.destroy();
			pianoGroup = null;
		}
		final state:PlayState = PlayState.instance;
		if (state == null || pianoConfig == null || pianoKeys.length < 1) return;

		pianoGroup = new FlxSpriteGroup();
		pianoGroup.scrollFactor.set();
		if (state.camHUD != null) pianoGroup.cameras = [state.camHUD];
		pianoGroup.x = pianoX;
		pianoGroup.y = pianoY;
		state.add(pianoGroup);

		var totalWeight:Float = 0;
		for (key in pianoKeys)
		{
			var weight:Float = key.weight;
			if (weight <= 0) weight = 1;
			totalWeight += weight;
		}
		if (totalWeight <= 0) totalWeight = pianoKeys.length;

		final totalWidth:Float = FlxG.width - pianoMargin * 2;
		final usableWidth:Float = totalWidth - pianoGap * (pianoKeys.length - 1);
		var cursor:Float = pianoMargin;
		for (key in pianoKeys)
		{
			var weight:Float = key.weight;
			if (weight <= 0) weight = 1;
			var width:Float = key.width > 0 ? key.width : usableWidth * (weight / totalWeight);
			var height:Float = key.height > 0 ? key.height : pianoHeight;
			var y:Float = pianoAnchor == 'top' ? pianoMargin : FlxG.height - height - pianoMargin;
			y += key.offset;

			var bg:FlxSprite = new FlxSprite(cursor, y).makeGraphic(1, 1, backend.CoolUtil.colorFromString(key.colour));
			bg.scale.set(width, height);
			bg.updateHitbox();
			bg.scrollFactor.set();
			bg.alpha = pianoAlpha;
			pianoGroup.add(bg);

			var label:FlxText = new FlxText(cursor, y + height / 2 - key.textSize / 2 - 2, width, key.label, Std.int(key.textSize));
			label.setFormat(Paths.font('NotoSansSC-Regular.otf'), Std.int(key.textSize), backend.CoolUtil.colorFromString(key.textColour), CENTER);
			label.scrollFactor.set();
			label.alpha = pianoAlpha;
			pianoGroup.add(label);

			Reflect.setField(key, 'bg', bg);
			Reflect.setField(key, 'labelSprite', label);
			Reflect.setField(key, 'x', cursor);
			Reflect.setField(key, 'y', y);
			Reflect.setField(key, 'renderWidth', width);
			Reflect.setField(key, 'renderHeight', height);
			cursor += width + pianoGap;
		}
		pianoGroup.visible = pianoVisible;
	}

	public static function updatePianoKeys(elapsed:Float):Void
	{
		if (pianoConfig == null || !pianoVisible || !pianoEnabled) return;
		for (index in 0...pianoKeys.length)
		{
			final key:Dynamic = pianoKeys[index];
			if (key == null || !key.enabled || key.key == null || key.key.length < 1)
			{
				if (key != null)
				{
					Reflect.setField(key, 'pressed', false);
					Reflect.setField(key, 'justPressed', false);
					Reflect.setField(key, 'justReleased', false);
				}
				continue;
			}
			final code:flixel.input.keyboard.FlxKey = flixel.input.keyboard.FlxKey.fromString(key.key.toUpperCase());
			var down:Bool = false;
			var justDown:Bool = false;
			var justUp:Bool = false;
			try
			{
				down = FlxG.keys.checkStatus(code, flixel.input.FlxInput.FlxInputState.PRESSED);
				justDown = FlxG.keys.checkStatus(code, flixel.input.FlxInput.FlxInputState.JUST_PRESSED);
				justUp = FlxG.keys.checkStatus(code, flixel.input.FlxInput.FlxInputState.JUST_RELEASED);
			}
			catch (e:Dynamic) {}

			var hold:Float = key.holdTime;
			hold = down ? hold + elapsed : 0;
			Reflect.setField(key, 'pressed', down);
			Reflect.setField(key, 'justPressed', justDown);
			Reflect.setField(key, 'justReleased', justUp);
			Reflect.setField(key, 'holdTime', hold);

			final bg:Dynamic = key.bg;
			if (bg != null)
				bg.color = backend.CoolUtil.colorFromString(down ? key.pressedColour : key.colour);

			if (justDown && key.action != null && key.action.length > 0 && pianoScript != null && pianoScript.isAlive())
				pianoScript.call(key.action, [index]);
		}
	}

	public static function pianoSnapshot():Dynamic
	{
		final keys:Array<Dynamic> = [];
		for (key in pianoKeys)
		{
			keys.push({
				label: key.label,
				key: key.key,
				enabled: key.enabled,
				pressed: key.pressed,
				justPressed: key.justPressed,
				justReleased: key.justReleased,
				holdTime: key.holdTime,
				x: key.x,
				y: key.y,
				width: key.renderWidth,
				height: key.renderHeight
			});
		}
		return {
			exists: pianoConfig != null,
			anchor: pianoAnchor,
			height: pianoHeight,
			gap: pianoGap,
			margin: pianoMargin,
			alpha: pianoAlpha,
			visible: pianoVisible,
			enabled: pianoEnabled,
			x: pianoX,
			y: pianoY,
			keys: keys
		};
	}

	function setPianoKeyField(index:Int, field:String, value:Dynamic):Void
	{
		if (index < 0 || index >= pianoKeys.length) return;
		Reflect.setField(pianoKeys[index], field, value);
		rebuildPianoKeys();
	}

	function pianoSet(field:String, value:Dynamic):Void
	{
		switch (field)
		{
			case 'anchor': pianoAnchor = Std.string(value);
			case 'height': pianoHeight = cast value;
			case 'gap': pianoGap = cast value;
			case 'margin': pianoMargin = cast value;
			case 'alpha': pianoAlpha = cast value;
			case 'visible': pianoVisible = value == true;
			case 'enabled': pianoEnabled = value == true;
		}
		rebuildPianoKeys();
	}

	function menuUI():CustomMenuState
	{
		if (Std.isOfType(host, CustomMenuState)) return cast host;
		return CustomMenuState.instance;
	}

	function mainMenu():MainMenuState
	{
		if (Std.isOfType(host, MainMenuState)) return cast host;
		if (Std.isOfType(FlxG.state, MainMenuState)) return cast FlxG.state;
		return null;
	}

	function aStr(args:Array<Dynamic>, index:Int, ?def:String = ''):String
	{
		if (args == null || index >= args.length || args[index] == null) return def;
		return Std.string(args[index]);
	}

	function aNum(args:Array<Dynamic>, index:Int, ?def:Float = 0):Float
	{
		if (args == null || index >= args.length || args[index] == null) return def;
		final value:Dynamic = args[index];
		if (Std.isOfType(value, String))
		{
			final parsed = Std.parseFloat(cast value);
			return Math.isNaN(parsed) ? def : parsed;
		}
		return cast(value, Float);
	}

	function aInt(args:Array<Dynamic>, index:Int, ?def:Int = 0):Int
		return Std.int(aNum(args, index, def));

	function aBool(args:Array<Dynamic>, index:Int, ?def:Bool = false):Bool
	{
		if (args == null || index >= args.length || args[index] == null) return def;
		final value:Dynamic = args[index];
		if (Std.isOfType(value, Bool)) return cast value;
		if (Std.isOfType(value, String)) return Std.string(value) == 'true';
		return aNum(args, index, def ? 1 : 0) != 0;
	}

	function optFlag(args:Array<Dynamic>, index:Int):Null<Bool>
	{
		if (args == null || index >= args.length || args[index] == null) return null;
		return aBool(args, index);
	}

	function optNum(args:Array<Dynamic>, index:Int):Null<Float>
	{
		if (args == null || index >= args.length || args[index] == null) return null;
		return aNum(args, index);
	}

	function resolveClass(name:String):Dynamic
	{
		if (name == null) return null;
		return Type.resolveClass(name);
	}

	function resolveObjectPath(path:String):Dynamic
	{
		if (path == null) return null;
		if (objectPaths.exists(path))
		{
			final tag = objectPaths.get(path);
			if (objects.exists(tag)) return objects.get(tag);
		}
		if (objects.exists(path)) return objects.get(path);

		final menuObj = MenuScripts.menuObject(path);
		if (menuObj != null) return menuObj;

		final dot = path.indexOf('.');
		if (dot > 0)
		{
			final head = path.substr(0, dot);
			final base:Dynamic = objects.exists(head) ? objects.get(head) : MenuScripts.menuObject(head);
			if (base != null)
			{
				var current:Dynamic = base;
				for (part in path.substr(dot + 1).split('.'))
				{
					if (current == null) return null;
					current = Reflect.field(current, part);
				}
				return current;
			}
		}

		final instance:Dynamic = PlayState.instance;
		if (instance != null)
		{
			final parts = path.split('.');
			var current:Dynamic = instance;
			for (part in parts)
			{
				if (current == null) return null;
				current = Reflect.field(current, part);
			}
			if (current != null) return current;
		}
		return null;
	}

	function storeObject(tag:String, obj:FlxBasic, ?path:String = null):FlxBasic
	{
		objects.set(tag, obj);
		MenuScripts.registerObject(tag, obj);
		if (path != null) objectPaths.set(path, tag);
		return obj;
	}

	function storeMenuObject(tag:String, obj:FlxBasic):FlxBasic
	{
		return storeObject(tag, obj);
	}

	function makeSprite(tag:String, image:String, x:Float, y:Float):Void
	{
		final sprite = new FlxSprite(x, y);
		if (image != null && image.length > 0) sprite.loadGraphic(Paths.image(image));
		storeMenuObject(tag, sprite);
	}

	function makeText(tag:String, text:String, x:Float, y:Float, ?size:Int = 24):Void
	{
		final label = new FlxText(x, y, 0, text, size);
		label.setFormat(Paths.font('NotoSansSC-Regular.otf'), size, FlxColor.WHITE, LEFT);
		storeMenuObject(tag, label);
	}

	function addSprite(tag:String):Void
	{
		final obj = objects.get(tag);
		if (obj == null) return;
		FlxG.state.add(obj);
	}

	function setProperty(path:String, value:Dynamic):Void
	{
		if (path == null) return;
		final dot = path.lastIndexOf('.');
		final basePath:String = dot > 0 ? path.substr(0, dot) : null;
		final prop:String = dot > 0 ? path.substr(dot + 1) : path;
		final target:Dynamic = basePath == null ? null : resolveObjectPath(basePath);
		if (target != null && prop != null && prop.length > 0)
		{
			try
				Reflect.setProperty(target, prop, value)
			catch (e:Dynamic) {}
			return;
		}
		if (basePath == null) setMenuTagVisible(prop, value == true);
	}

	function doTween(tag:String, prop:String, value:Float, duration:Float, ?ease:String = 'linear'):Void
	{
		final obj = resolveObjectPath(tag);
		if (obj == null) return;
		switch (prop)
		{
			case 'x':
				FlxTween.tween(obj, {x: value}, duration, {ease: easeOf(ease)});
			case 'y':
				FlxTween.tween(obj, {y: value}, duration, {ease: easeOf(ease)});
			case 'alpha':
				FlxTween.tween(obj, {alpha: value}, duration, {ease: easeOf(ease)});
			case 'angle':
				FlxTween.tween(obj, {angle: value}, duration, {ease: easeOf(ease)});
			case 'zoom':
				if (Std.isOfType(obj, FlxCamera)) FlxTween.tween(obj, {zoom: value}, duration, {ease: easeOf(ease)});
		}
	}

	function easeOf(name:String):Float->Float
	{
		return switch (name)
		{
			case 'sineIn': FlxEase.sineIn;
			case 'sineOut': FlxEase.sineOut;
			case 'sineInOut', 'sineInHalf': FlxEase.sineInOut;
			case 'quadIn': FlxEase.quadIn;
			case 'quadOut': FlxEase.quadOut;
			case 'quadInOut': FlxEase.quadInOut;
			case 'cubeIn': FlxEase.cubeIn;
			case 'cubeOut': FlxEase.cubeOut;
			case 'cubeInOut': FlxEase.cubeInOut;
			case 'backOut': FlxEase.backOut;
			case 'backIn': FlxEase.backIn;
			case 'elasticOut': FlxEase.elasticOut;
			case 'bounceOut': FlxEase.bounceOut;
			default: FlxEase.linear;
		};
	}

	function snap(path:String):Dynamic
	{
		if (snapshotData == null) return null;
		var current:Dynamic = snapshotData;
		for (part in path.split('.'))
		{
			if (current == null) return null;
			current = Reflect.field(current, part);
		}
		return current;
	}

	function snapField(path:String, name:String):Dynamic
	{
		final holder:Dynamic = snap(path);
		if (holder == null || name == null) return null;
		return Reflect.field(holder, name);
	}

	function snapList(path:String):Array<Dynamic>
	{
		final value:Dynamic = snap(path);
		if (!Std.isOfType(value, Array)) return [];
		return cast(value, Array<Dynamic>);
	}

	function snapItem(path:String, index:Int):Dynamic
	{
		final list:Array<Dynamic> = snapList(path);
		if (index < 0 || index >= list.length) return null;
		return list[index];
	}

	function snapIndexOf(list:Array<Dynamic>, value:Dynamic):Int
	{
		if (list == null) return -1;
		for (i in 0...list.length)
			if (looseEquals(list[i], value)) return i;
		return -1;
	}

	function aIndex(args:Array<Dynamic>):Int
		return args != null && args.length > 0 ? aInt(args, 0) : -1;

	static function looseEquals(a:Dynamic, b:Dynamic):Bool
		return Std.string(a) == Std.string(b);

	static function isTrue(value:Dynamic):Bool
	{
		if (!Std.isOfType(value, Bool)) return false;
		return cast(value, Bool);
	}

	function phraseOf(key:String):String
	{
		if (key == null) return null;
		#if TRANSLATIONS_ALLOWED
		@:privateAccess
		final value:String = Language.phrases.get(key);
		return value;
		#else
		return null;
		#end
	}

	function resolvePathValue(path:Dynamic):String
	{
		if (path == null) return null;
		var p:String = Std.string(path).split('\\').join('/');
		if (p.length > 0 && p.charAt(0) == '/') return p;
		final first:String = p.charAt(0);
		final isLetter:Bool = (first >= 'A' && first <= 'Z') || (first >= 'a' && first <= 'z');
		if (p.length >= 3 && isLetter && p.charAt(1) == ':' && p.charAt(2) == '/') return p;
		if (p.length >= 2 && p.substr(0, 2) == './') return scriptDirectory + '/' + p.substr(2);
		return modRoot + '/' + p;
	}

	function fsExists(path:Dynamic):Bool
		return QuickJS.fsExistsPath(resolvePathValue(path));

	function fsRead(path:Dynamic):String
		return QuickJS.fsReadText(resolvePathValue(path));

	function fsSize(path:Dynamic):Float
		return QuickJS.fsFileSize(resolvePathValue(path));

	function fsList(path:Dynamic, ext:Dynamic):Array<Dynamic>
		return QuickJS.fsListPaths(resolvePathValue(path), ext == null ? '' : Std.string(ext));

	function fsWrite(path:Dynamic, content:Dynamic):Bool
		return QuickJS.fsWriteText(resolvePathValue(path), Std.string(content));

	function fsAppend(path:Dynamic, content:Dynamic):Bool
		return QuickJS.fsAppendText(resolvePathValue(path), Std.string(content));

	function fsDelete(path:Dynamic):Bool
		return QuickJS.fsDeletePath(resolvePathValue(path));

	function fsMkdir(path:Dynamic):Bool
		return QuickJS.fsMkdirPath(resolvePathValue(path));

	function fsRmdir(path:Dynamic):Bool
		return QuickJS.fsRmdirPath(resolvePathValue(path));

	public function dispatch(tag:String, args:Array<Dynamic>):Dynamic
	{
		try
		{
			switch (tag)
			{
				case 'getFPS':
					return backend.FpsPanelApi.getPanel().getShownFPS();
				case 'getProcessMemory':
					return backend.FpsPanelApi.getProcessMemoryMB();
				case 'getDataMemory':
					return backend.FpsPanelApi.getDataMemoryMB();
				case 'getDeviceMemory':
					return backend.FpsPanelApi.getDeviceMemoryMB();
				case 'getMemoryPercent':
					return backend.FpsPanelApi.getMemoryPercent();

				case 'getScriptDirectory':
					return scriptDirectory;

				case 'getModDirectory':
					return Mods.currentModDirectory;

				case 'resolvePath':
					return resolvePathValue(args.length > 0 ? args[0] : null);

				case 'fileExists', 'checkFileExists':
					return fsExists(args.length > 0 ? args[0] : null);

				case 'readFile', 'getTextFromFile':
					return fsRead(args.length > 0 ? args[0] : null);

				case 'getFileSize':
					return fsSize(args.length > 0 ? args[0] : null);

				case 'listFiles':
					return fsList(args.length > 0 ? args[0] : null, args.length > 1 ? args[1] : null);

				case 'directoryFileList':
					return fsList(args.length > 0 ? args[0] : null, '');

				case 'writeFile', 'saveFile':
					return fsWrite(args.length > 0 ? args[0] : null, args.length > 1 ? args[1] : null);

				case 'appendFile':
					return fsAppend(args.length > 0 ? args[0] : null, args.length > 1 ? args[1] : null);

				case 'deleteFile':
					return fsDelete(args.length > 0 ? args[0] : null);

				case 'createDirectory':
					return fsMkdir(args.length > 0 ? args[0] : null);

				case 'deleteDirectory':
					return fsRmdir(args.length > 0 ? args[0] : null);

				case 'makeLuaSprite':
					makeSprite(aStr(args, 0), aStr(args, 1), aNum(args, 2), aNum(args, 3));

				case 'makeLuaText':
					makeText(aStr(args, 0), aStr(args, 1), aNum(args, 2), aNum(args, 3), aInt(args, 4, 24));

				case 'addLuaSprite', 'addLuaText':
					addSprite(aStr(args, 0));

				case 'getProperty':
					final propValue:Dynamic = snapField('props', aStr(args, 0));
					return propValue == null ? 0 : propValue;

				case 'getMenuItemCount', 'getPageItemCount':
					return snap('menu.count');

				case 'getMenuSelected', 'getPageSelected':
					return snap('menu.selected');

				case 'getMenuColumn':
					return snap('menu.column');

				case 'getPageSelectedId':
					return snap('menu.selectedId');

				case 'getPageName':
					return snap('menu.page');

				case 'getPageItemId':
					final pageItem:Dynamic = snapItem('menu.items', aIndex(args));
					return pageItem == null ? null : Reflect.field(pageItem, 'id');

				case 'getPageItemIndex', 'getMenuItemIndex':
					final wantedId:Dynamic = args.length > 0 ? args[0] : null;
					final menuItems:Array<Dynamic> = snapList('menu.items');
					for (i in 0...menuItems.length)
						if (looseEquals(Reflect.field(menuItems[i], 'id'), wantedId)) return i;
					return -1;

				case 'getAllSongs':
					return Json.stringify(snap('songs'));

				case 'getWeekCount', 'storyGetWeekCount':
					return snapList('weeks').length;

				case 'getDifficultyList':
					return Json.stringify(snap('difficulties'));

				case 'getDifficultyName':
					final difficultyNames:Array<Dynamic> = snapList('difficulties');
					final difficultyIndex:Int = aIndex(args);
					return difficultyIndex >= 0 && difficultyIndex < difficultyNames.length ? difficultyNames[difficultyIndex] : null;

				case 'storyGetSelectedWeekId':
					return snap('story.week');

				case 'storyGetDifficultyName', 'storyGetDifficulty':
					return snap('story.difficulty');

				case 'freeplayGetSongCount':
					return snap('freeplay.count');

				case 'freeplayGetSelectedSong':
					return snap('freeplay.selected');

				case 'freeplayGetSongName':
					final freeplaySongs:Array<Dynamic> = snapList('freeplay.songs');
					final freeplayIndex:Int = aIndex(args);
					return freeplayIndex >= 0 && freeplayIndex < freeplaySongs.length ? freeplaySongs[freeplayIndex] : null;

				case 'freeplayGetSelected':
					if (!Std.isOfType(FlxG.state, FreeplayState)) return null;
					@:privateAccess return cast(FlxG.state, FreeplayState).getSelectedSong();
				case 'freeplayGetSongCharacter':
					if (!Std.isOfType(FlxG.state, FreeplayState)) return null;
					@:privateAccess return cast(FlxG.state, FreeplayState).getSongCharacterAt(cast(FlxG.state, FreeplayState).resolveSongIndex(args.length > 0 ? args[0] : 0));
				case 'freeplayGetSongColor':
					if (!Std.isOfType(FlxG.state, FreeplayState)) return null;
					@:privateAccess return cast(FlxG.state, FreeplayState).getSongColorAt(cast(FlxG.state, FreeplayState).resolveSongIndex(args.length > 0 ? args[0] : 0));
				case 'freeplayGetDifficulty':
					if (!Std.isOfType(FlxG.state, FreeplayState)) return null;
					@:privateAccess return cast(FlxG.state, FreeplayState).getDifficultyNameAt(cast(FlxG.state, FreeplayState).resolveSongIndex(args.length > 0 ? args[0] : 0));
				case 'freeplayIsPlayingPreview':
					if (!Std.isOfType(FlxG.state, FreeplayState)) return false;
					return cast(FlxG.state, FreeplayState).isPreviewPlaying();

				case 'storyGetWeekId':
					if (!Std.isOfType(FlxG.state, StoryMenuState)) return null;
					return cast(FlxG.state, StoryMenuState).getSelectedWeekId();
				case 'storyGetWeekName':
					if (!Std.isOfType(FlxG.state, StoryMenuState)) return null;
					final storyState:StoryMenuState = cast FlxG.state;
					final storyIndex:Int = args.length > 0 ? storyState.resolveWeekIndex(args[0]) : storyState.getSelectedWeekIndex();
					return storyState.getWeekNameAt(storyIndex);
				case 'storyGetWeekSongs':
					if (!Std.isOfType(FlxG.state, StoryMenuState)) return null;
					final storyState2:StoryMenuState = cast FlxG.state;
					final storyIndex2:Int = args.length > 0 ? storyState2.resolveWeekIndex(args[0]) : storyState2.getSelectedWeekIndex();
					return storyState2.getWeekSongsAt(storyIndex2);
				case 'storyGetSelectedWeek':
					if (!Std.isOfType(FlxG.state, StoryMenuState)) return null;
					return cast(FlxG.state, StoryMenuState).getSelectedWeekIndex();
				case 'storyIsWeekLocked':
					if (!Std.isOfType(FlxG.state, StoryMenuState)) return false;
					final storyState3:StoryMenuState = cast FlxG.state;
					final storyIndex3:Int = args.length > 0 ? storyState3.resolveWeekIndex(args[0]) : storyState3.getSelectedWeekIndex();
					return storyState3.isWeekLockedAt(storyIndex3);

				case 'setObjectCamera':
					final objectForCamera:Dynamic = resolveObjectPath(aStr(args, 0));
					final targetCamera:FlxCamera = cameraByName(aStr(args, 1, 'game'));
					if (Std.isOfType(objectForCamera, FlxSprite) && targetCamera != null)
						cast(objectForCamera, FlxSprite).cameras = [targetCamera];
				case 'applySpriteShader':
					final shaderGame = PlayState.instance;
					final shaderTarget:Dynamic = resolveObjectPath(aStr(args, 0));
					if (shaderGame != null && Std.isOfType(shaderTarget, FlxSprite))
					{
						final shader = shaderGame.createRuntimeShader(aStr(args, 1));
						if (shader != null) cast(shaderTarget, FlxSprite).shader = shader;
					}
				case 'applyCameraShader':
					final shaderGame2 = PlayState.instance;
					final shaderCamera = cameraByName(aStr(args, 0));
					if (shaderGame2 != null && shaderCamera != null)
					{
						final shader = shaderGame2.createRuntimeShader(aStr(args, 1));
						if (shader != null) shaderCamera.setFilters([new openfl.filters.ShaderFilter(shader)]);
					}

				case 'isMenuVideoPlaying':
					return snap('video.playing');

				case 'isMenuVideoBackground':
					return snap('video.background');

				case 'isMenuVideoLayer':
					return snap('video.layer');

				case 'isMenuPointerDown':
					return snap('gestures.down');

				case 'getMenuSwipeDirection':
					return snap('gestures.swipe');

				case 'getRankNames':
					return Json.stringify(snap('ranks.names'));

				case 'getRankAccuracy':
					final rankName:Dynamic = args.length > 0 ? args[0] : null;
					for (entry in snapList('ranks.list'))
						if (looseEquals(Reflect.field(entry, 'name'), rankName)) return Reflect.field(entry, 'accuracy');
					return 0;

				case 'getRankAt':
					final rankPercent:Float = args.length > 0 ? aNum(args, 0) : Math.NEGATIVE_INFINITY;
					final rankList:Array<Dynamic> = snapList('ranks.list');
					for (entry in rankList)
						if (rankPercent >= aNum([Reflect.field(entry, 'accuracy')], 0)) return Reflect.field(entry, 'name');
					return rankList.length > 0 ? Reflect.field(rankList[rankList.length - 1], 'name') : null;

				case 'getRank':
					return snap('ranks.current');

				case 'getRatingNames':
					return Json.stringify(snap('ratings.names'));

				case 'getRatingWindow':
					final ratingWindow:Dynamic = snapField('ratings.window', aStr(args, 0));
					return ratingWindow == null ? 0 : ratingWindow;

				case 'getRatingScore':
					final ratingScore:Dynamic = snapField('ratings.score', aStr(args, 0));
					return ratingScore == null ? 0 : ratingScore;

				case 'getRatingMod':
					final ratingMod:Dynamic = snapField('ratings.mod', aStr(args, 0));
					return ratingMod == null ? 0 : ratingMod;

				case 'getRatingImage':
					return snapField('ratings.image', aStr(args, 0));

				case 'getRatingHits':
					final ratingHits:Dynamic = snapField('ratings.hits', aStr(args, 0));
					return ratingHits == null ? 0 : ratingHits;

				case 'getRatingNoteSplash':
					return isTrue(snapField('ratings.splash', aStr(args, 0)));

				case 'getFCBadgeNames':
					return Json.stringify(snap('fcBadges.names'));

				case 'getFCBadgeMaxMisses':
					final badgeMaxMisses:Dynamic = snapField('fcBadges.maxMisses', aStr(args, 0));
					return badgeMaxMisses == null ? 0 : badgeMaxMisses;

				case 'getFCBadgeMinAccuracy':
					final badgeMinAccuracy:Dynamic = snapField('fcBadges.minAccuracy', aStr(args, 0));
					return badgeMinAccuracy == null ? 0 : badgeMinAccuracy;

				case 'getFCBadgePriority':
					final badgePriority:Dynamic = snapField('fcBadges.priority', aStr(args, 0));
					return badgePriority == null ? 0 : badgePriority;

				case 'getFCBadgeMinHits':
					final minHitsHolder:Dynamic = snapField('fcBadges.minHits', aStr(args, 0));
					final minHitsValue:Dynamic = minHitsHolder == null ? null : Reflect.field(minHitsHolder, aStr(args, 1));
					return minHitsValue == null ? 0 : minHitsValue;

				case 'getFCBadgeMaxHits':
					final maxHitsHolder:Dynamic = snapField('fcBadges.maxHits', aStr(args, 0));
					final maxHitsValue:Dynamic = maxHitsHolder == null ? null : Reflect.field(maxHitsHolder, aStr(args, 1));
					return maxHitsValue == null ? 0 : maxHitsValue;

				case 'getNoteKeyCount':
					return snap('lanes.keys');

				case 'getNoteLaneCount':
					var laneOpponent:Bool = false;
					if (args.length > 0 && Std.isOfType(args[0], Bool)) laneOpponent = !isTrue(args[0]);
					return laneOpponent ? snap('lanes.opponent') : snap('lanes.player');

				case 'isNoteLaneEnabled':
					final laneIndex:Int = aIndex(args);
					final laneEnabled:Array<Dynamic> = snapList('lanes.enabled');
					if (laneIndex >= 0 && laneIndex < laneEnabled.length && Std.isOfType(laneEnabled[laneIndex], Bool)
						&& !isTrue(laneEnabled[laneIndex])) return false;
					return true;

				case 'getNoteLaneAlpha':
					final laneAlphaIndex:Int = aIndex(args);
					final laneAlpha:Array<Dynamic> = snapList('lanes.alpha');
					return laneAlphaIndex >= 0 && laneAlphaIndex < laneAlpha.length ? laneAlpha[laneAlphaIndex] : 1;

				case 'getNoteLaneOffset':
					final laneOffsetIndex:Int = aIndex(args);
					final laneOffset:Array<Dynamic> = snapList('lanes.offset');
					return laneOffsetIndex >= 0 && laneOffsetIndex < laneOffset.length ? laneOffset[laneOffsetIndex] : 0;

				case 'getHealthIconFrame':
					return snap('icons.frame');

				case 'getHealthIconFrames':
					return snap('icons.bands');

				case 'getHealthIconFrameCount':
					return snap('icons.count');

				case 'getMenuItem':
					final menuItemEntry:Dynamic = snapItem('menu.items', aIndex(args));
					return menuItemEntry == null ? null : Json.stringify(menuItemEntry);

				case 'getMenuItemEnabled':
					final enabledItemEntry:Dynamic = snapItem('menu.items', aIndex(args));
					return enabledItemEntry == null ? false : Reflect.field(enabledItemEntry, 'enabled');

				case 'getMenuItemVisible':
					final visibleItemEntry:Dynamic = snapItem('menu.items', aIndex(args));
					return visibleItemEntry == null ? false : Reflect.field(visibleItemEntry, 'visible');

				case 'getMenuItemId':
					final idItemEntry:Dynamic = snapItem('menu.items', aIndex(args));
					return idItemEntry == null ? null : Reflect.field(idItemEntry, 'id');

				case 'getMenuItemX':
					final xItemEntry:Dynamic = snapItem('menu.items', aIndex(args));
					return xItemEntry == null ? 0 : Reflect.field(xItemEntry, 'x');

				case 'getMenuItemY':
					final yItemEntry:Dynamic = snapItem('menu.items', aIndex(args));
					return yItemEntry == null ? 0 : Reflect.field(yItemEntry, 'y');

				case 'getMenuItemWidth':
					final widthItemEntry:Dynamic = snapItem('menu.items', aIndex(args));
					return widthItemEntry == null ? 0 : Reflect.field(widthItemEntry, 'width');

				case 'getMenuItemHeight':
					final heightItemEntry:Dynamic = snapItem('menu.items', aIndex(args));
					return heightItemEntry == null ? 0 : Reflect.field(heightItemEntry, 'height');

				case 'getMenuObjects':
					return Json.stringify(snap('menu.objects'));

				case 'getMenuObjectCount':
					return snap('menu.objectCount');

				case 'getMenuLocked':
					return isTrue(snap('menu.locked'));

				case 'hasMenuObject':
					for (obj in snapList('menu.objects'))
						if (looseEquals(Reflect.field(obj, 'tag'), aStr(args, 0))) return true;
					return false;

				case 'isMenuObjectVisible':
					for (obj in snapList('menu.objects'))
						if (looseEquals(Reflect.field(obj, 'tag'), aStr(args, 0))) return Reflect.field(obj, 'visible');
					return false;

				case 'pianoKeysExist':
					return snap('piano.exists');

				case 'getPianoKeyCount':
					return snapList('piano.keys').length;

				case 'getPianoKeysAnchor':
					return snap('piano.anchor');

				case 'getPianoKeysHeight':
					return snap('piano.height');

				case 'getPianoKeysGap':
					return snap('piano.gap');

				case 'getPianoKeysMargin':
					return snap('piano.margin');

				case 'getPianoKeysAlpha':
					return snap('piano.alpha');

				case 'getPianoKeysVisible':
					return snap('piano.visible');

				case 'getPianoKeysEnabled':
					return snap('piano.enabled');

				case 'getPianoKeysX':
					return snap('piano.x');

				case 'getPianoKeysY':
					return snap('piano.y');

				case 'getPianoKeyLabel':
					final labelPianoKey:Dynamic = snapItem('piano.keys', aIndex(args));
					return labelPianoKey == null ? null : Reflect.field(labelPianoKey, 'label');

				case 'getPianoKeyX':
					final xPianoKey:Dynamic = snapItem('piano.keys', aIndex(args));
					return xPianoKey == null ? 0 : Reflect.field(xPianoKey, 'x');

				case 'getPianoKeyY':
					final yPianoKey:Dynamic = snapItem('piano.keys', aIndex(args));
					return yPianoKey == null ? 0 : Reflect.field(yPianoKey, 'y');

				case 'getPianoKeyWidth':
					final widthPianoKey:Dynamic = snapItem('piano.keys', aIndex(args));
					return widthPianoKey == null ? 0 : Reflect.field(widthPianoKey, 'width');

				case 'getPianoKeyHeight':
					final heightPianoKey:Dynamic = snapItem('piano.keys', aIndex(args));
					return heightPianoKey == null ? 0 : Reflect.field(heightPianoKey, 'height');

				case 'isPianoKeyPressed':
					final pressedPianoKey:Dynamic = snapItem('piano.keys', aIndex(args));
					return pressedPianoKey == null ? false : Reflect.field(pressedPianoKey, 'pressed');

				case 'isPianoKeyJustPressed':
					final justPressedPianoKey:Dynamic = snapItem('piano.keys', aIndex(args));
					return justPressedPianoKey == null ? false : Reflect.field(justPressedPianoKey, 'justPressed');

				case 'isPianoKeyJustReleased':
					final justReleasedPianoKey:Dynamic = snapItem('piano.keys', aIndex(args));
					return justReleasedPianoKey == null ? false : Reflect.field(justReleasedPianoKey, 'justReleased');

				case 'getPianoKeyHoldTime':
					final holdPianoKey:Dynamic = snapItem('piano.keys', aIndex(args));
					return holdPianoKey == null ? 0 : Reflect.field(holdPianoKey, 'holdTime');

				case 'getVideoAlpha':
					return snap('video.alpha');

				case 'getVideoLayout':
					return snap('video.layout');

				case 'isVideoPlaying':
					return snap('video.playingVideo');

				case 'getVideoName':
					return snap('video.name');

				case 'getLastFinishedVideo':
					return snap('video.last');

				case 'isVideoFinished':
					return snap('video.finished');

				case 'getHealth':
					return snap('health.value');

				case 'getHealthMax':
					return snap('health.max');

				case 'getHealthMin':
					return snap('health.min');

				case 'getHealthDisplayMax':
					return snap('health.displayMax');

				case 'getHealthPercent':
					return snap('health.percent');

				case 'getHealthOverflow':
					return snap('health.overflow');

				case 'getHealthClamp':
					return snap('health.clamp');

				case 'isHealthLocked':
					return snap('health.locked');

				case 'isInvincible':
					return snap('health.invincible');

				case 'getDeathHealth':
					return snap('health.death');

				case 'getHealthRegen':
					return snap('health.regen');

				case 'getHealthDrain':
					return snap('health.drain');

				case 'getHealthGain':
					return snap('health.gain');

				case 'getHealthLoss':
					return snap('health.loss');

				case 'getSustainHealth':
					return snap('health.sustain');

				case 'getSustainHealthMult':
					return snap('health.sustainMult');

				case 'pageIsOpen':
					return snap('menu.page') != null;

				case 'getPageLocked':
					return isTrue(snap('menu.locked'));

				case 'getAllSongNames':
					final allSongNames:Array<Dynamic> = [];
					for (song in snapList('songs')) allSongNames.push(Reflect.field(song, 'song'));
					return Json.stringify(allSongNames);

				case 'getAllWeeks':
					return Json.stringify(snap('weeks'));

				case 'getSongCount':
					return snapList('songs').length;

				case 'getSongName':
					final songNameEntry:Dynamic = snapItem('songs', aIndex(args));
					return songNameEntry == null ? null : Reflect.field(songNameEntry, 'song');

				case 'getSongWeek':
					final songWeekEntry:Dynamic = snapItem('songs', aIndex(args));
					return songWeekEntry == null ? null : Reflect.field(songWeekEntry, 'week');

				case 'getWeekId':
					final weekIdList:Array<Dynamic> = snapList('weeks');
					final weekIdIndex:Int = aIndex(args);
					return weekIdIndex >= 0 && weekIdIndex < weekIdList.length ? weekIdList[weekIdIndex] : null;

				case 'getWeekSongs':
					final weekSongNames:Array<Dynamic> = [];
					final wantedWeek:Dynamic = args.length > 0 ? args[0] : null;
					for (song in snapList('songs'))
						if (looseEquals(Reflect.field(song, 'week'), wantedWeek)) weekSongNames.push(Reflect.field(song, 'song'));
					return Json.stringify(weekSongNames);

				case 'isWeekUnlocked':
					final unlockedWeek:Dynamic = args.length > 0 ? args[0] : null;
					for (song in snapList('songs'))
						if (looseEquals(Reflect.field(song, 'week'), unlockedWeek)) return isTrue(Reflect.field(song, 'unlocked'));
					return false;

				case 'getSongDifficulties':
					final songDifficultyEntry:Dynamic = snapItem('songs', aIndex(args));
					return songDifficultyEntry == null ? '[]' : Json.stringify(Reflect.field(songDifficultyEntry, 'difficulties'));

				case 'getDifficultyCount':
					return snapList('difficulties').length;

				case 'freeplayGetDifficultyName':
					return snap('freeplay.difficulty');

				case 'freeplayGetTouchMode':
					return snap('freeplay.touchMode');

				case 'getHiddenWeeks':
					return Json.stringify(snap('weeksHidden'));

				case 'isWeekHidden':
					return snapIndexOf(snapList('weeksHidden'), args.length > 0 ? args[0] : null) >= 0;

				case 'getExtraStrumGroups':
					return Json.stringify(snap('extraStrums.names'));

				case 'hasExtraStrum':
					return snapIndexOf(snapList('extraStrums.names'), args.length > 0 ? args[0] : null) >= 0;

				case 'getExtraStrumPos':
					final extraStrumPos:Dynamic = snapField('extraStrums.data', aStr(args, 0));
					return extraStrumPos == null ? 'null' : Json.stringify(extraStrumPos);

				case 'getExtraStrumActive':
					return snap('extraStrums.active');

				case 'getHealthBarMode':
					return snap('game.healthBarMode');

				case 'getFPSPanelVisible':
					return snap('perf.visible');

				case 'getFPSPanelAlpha':
					return snap('perf.alpha');

				case 'getFPSPanelX':
					return snap('perf.x');

				case 'getFPSPanelY':
					return snap('perf.y');

				case 'getFPSPanelCollapsed':
					return snap('perf.collapsed');

				case 'getFPSPanelClickable':
					return snap('perf.clickable');

				case 'getFPSPanelTextColor':
					return snap('perf.textColor');

				case 'getFPSPanelFontSize':
					return snap('perf.fontSize');

				case 'getFPSPanelBackgroundVisible':
					return snap('perf.backgroundVisible');

				case 'getFPSPanelBackgroundColor':
					return snap('perf.backgroundColor');

				case 'getFPSPanelBackgroundImage':
					return snap('perf.backgroundImage');

				case 'getFPSPanelBackgroundImageAlpha':
					return snap('perf.backgroundImageAlpha');

				case 'getMenuReplacement':
					return snapField('menu.replacements', aStr(args, 0));

				case 'isMenuObjectReplaced':
					return snapField('menu.replacements', aStr(args, 0)) != null;

				case 'isMenuObjectAttached':
					return snapField('menu.attachments', aStr(args, 0)) != null;

				case 'getMenuAttachTarget':
					final attachEntry:Dynamic = snapField('menu.attachments', aStr(args, 0));
					return attachEntry == null ? null : Reflect.field(attachEntry, 'target');

				case 'isMenuObjectDraggable':
					return isTrue(snapField('menu.draggables', aStr(args, 0)));

				case 'isMenuObjectDragging':
					return snap('menu.dragging') != null;

				case 'getMenuDragTag':
					return snap('menu.dragging');

				case 'getMenuGesture':
					return Json.stringify(snap('menu.gesture'));

				case 'freeplayIsSongIconReplaced':
					return snapIndexOf(snapList('freeplay.iconReplaced'), args.length > 0 ? args[0] : null) >= 0;

				case 'storyIsWeekIconReplaced':
					return snapIndexOf(snapList('story.iconReplaced'), args.length > 0 ? args[0] : null) >= 0;

				case 'getMenuSideOption':
					return aStr(args, 0) == 'left' ? snap('menu.sideLeft') : snap('menu.sideRight');

				case 'getRunningScripts':
					return Json.stringify(snap('scripts'));

				case 'isRunning':
					return snapIndexOf(snapList('scripts'), aStr(args, 0)) >= 0;

				case 'getVar':
					return snapField('vars', aStr(args, 0));

				case 'getAchievementScore':
					final achievementScore:Dynamic = snapField('achievements.scores', aStr(args, 0));
					return achievementScore == null ? 0 : achievementScore;

				case 'isAchievementUnlocked':
					return snapIndexOf(snapList('achievements.unlocked'), aStr(args, 0)) >= 0;

				case 'achievementExists':
					return snapIndexOf(snapList('achievements.names'), aStr(args, 0)) >= 0;

				case 'getModSetting':
					final settingsTag:Dynamic = args.length > 0 ? args[0] : null;
					if (settingsTag == null || modSettingsData == null) return null;
					return Reflect.field(modSettingsData, Std.string(settingsTag));

				case 'getShader':
					final shaderName:String = shaderNames.get(aStr(args, 0));
					return shaderName;

				case 'getShaderBool':
					final shader = runtimeShaderFor(aStr(args, 0));
					return shader == null ? false : shader.getBool(aStr(args, 1));

				case 'getShaderInt':
					final shader = runtimeShaderFor(aStr(args, 0));
					return shader == null ? 0 : shader.getInt(aStr(args, 1));

				case 'getShaderFloat':
					final shader = runtimeShaderFor(aStr(args, 0));
					return shader == null ? 0 : shader.getFloat(aStr(args, 1));

				case 'getShaderBoolArray':
					final shader = runtimeShaderFor(aStr(args, 0));
					return shader == null ? [] : shader.getBoolArray(aStr(args, 1));

				case 'getShaderIntArray':
					final shader = runtimeShaderFor(aStr(args, 0));
					return shader == null ? [] : shader.getIntArray(aStr(args, 1));

				case 'getShaderFloatArray':
					final shader = runtimeShaderFor(aStr(args, 0));
					return shader == null ? [] : shader.getFloatArray(aStr(args, 1));

				case 'shaderExists':
					return snapIndexOf(snapList('shadersLoaded'), aStr(args, 0)) >= 0;

				case 'getShaderNames':
					return Json.stringify(snap('shadersLoaded'));

				case 'getShaderDebug':
					return Json.stringify(shaders.ErrorHandledShader.lastErrors);

				case 'getShaderFolders':
					return Json.stringify(snap('shaderFolders'));

				case 'isVanillaWeeksHidden':
					return isTrue(snap('vanillaWeeksHidden'));

				case 'getTranslationPhrase':
					final phraseKey:Dynamic = args.length > 0 ? args[0] : null;
					if (phraseKey == null) return args.length > 1 ? args[1] : null;
					var phraseKeyText:String = Std.string(phraseKey).split(' ').join('_');
					phraseKeyText = ~/[~&\\;:<>#.,"%?!]/g.replace(phraseKeyText, '');
					phraseKeyText = StringTools.trim(phraseKeyText.toLowerCase());
					var phraseValue:Dynamic = phraseOf(phraseKeyText);
					if (phraseValue == null) phraseValue = args.length > 1 ? args[1] : phraseKey;
					if (phraseValue == null) phraseValue = phraseKey;
					final phraseValues:Dynamic = args.length > 2 ? args[2] : null;
					if (phraseValues != null && Std.isOfType(phraseValues, Array))
					{
						final valueList:Array<Dynamic> = cast phraseValues;
						var phraseText:String = Std.string(phraseValue);
						for (i in 0...valueList.length)
							phraseText = phraseText.split('{${i + 1}}').join(Std.string(valueList[i]));
						phraseValue = phraseText;
					}
					return phraseValue;

				case 'getFileTranslation':
					final fileKey:Dynamic = args.length > 0 ? args[0] : null;
					if (fileKey == null) return fileKey;
					final fileKeyText:String = StringTools.trim(Std.string(fileKey).toLowerCase());
					final translatedText:String = phraseOf(fileKeyText);
					return translatedText == null ? fileKey : translatedText;

				case 'debugPrint', 'jsTrace', 'writeLog':
					debugPrint(aStr(args, 0));

				case 'scriptError':
					scriptError(aStr(args, 0));

				case 'setProperty':
					setProperty(aStr(args, 0), args.length > 1 ? args[1] : null);

				case 'makeSprite':
					makeSprite(aStr(args, 0), aStr(args, 1), aNum(args, 2), aNum(args, 3));

				case 'makeAnimatedSprite':
					makeSprite(aStr(args, 0), aStr(args, 1), aNum(args, 2), aNum(args, 3));

				case 'makeText':
					makeText(aStr(args, 0), aStr(args, 1), aNum(args, 2), aNum(args, 3), aInt(args, 4, 24));

				case 'addSprite', 'addText':
					addSprite(aStr(args, 0));

				case 'removeSprite', 'removeLuaSprite':
					final tagName = aStr(args, 0);
					final obj = objects.get(tagName);
					if (obj != null)
					{
						FlxG.state.remove(obj, true);
						obj.destroy();
						objects.remove(tagName);
					}

				case 'addAnimation':
					final spr = resolveObjectPath(aStr(args, 0));
					if (Std.isOfType(spr, FlxSprite))
					{
						final frames = Paths.getSparrowAtlas(aStr(args, 1));
						if (frames != null) cast(spr, FlxSprite).frames = frames;
						cast(spr, FlxSprite).animation.addByPrefix(aStr(args, 2), aStr(args, 3), aInt(args, 4, 24), aBool(args, 5, false));
					}

				case 'addAnimationByPrefix':
					final spr2 = resolveObjectPath(aStr(args, 0));
					if (Std.isOfType(spr2, FlxSprite))
						cast(spr2, FlxSprite).animation.addByPrefix(aStr(args, 1), aStr(args, 2), aInt(args, 3, 24), aBool(args, 4, false));

				case 'addAnimationByIndices':
					final spr3 = resolveObjectPath(aStr(args, 0));
					if (Std.isOfType(spr3, FlxSprite))
					{
						final indices:Array<Int> = [];
						final raw = args[4];
						if (Std.isOfType(raw, String))
							for (part in Std.string(raw).split(','))
								indices.push(Std.parseInt(StringTools.trim(part)));
						else if (Std.isOfType(raw, Array))
							for (value in cast(raw, Array<Dynamic>)) indices.push(Std.int(aNum([value], 0)));
						cast(spr3, FlxSprite).animation.addByIndices(aStr(args, 1), aStr(args, 2), indices, '', aInt(args, 3, 24), aBool(args, 5, false));
					}

				case 'playAnim':
					final spr4 = resolveObjectPath(aStr(args, 0));
					if (Std.isOfType(spr4, FlxSprite))
						cast(spr4, FlxSprite).animation.play(aStr(args, 1), aBool(args, 2, false));

				case 'screenCenter':
					final spr5 = resolveObjectPath(aStr(args, 0));
					if (Std.isOfType(spr5, FlxSprite))
					{
						final axis = aStr(args, 1, '');
						if (axis == 'x') cast(spr5, FlxSprite).screenCenter(X);
						else if (axis == 'y') cast(spr5, FlxSprite).screenCenter(Y);
						else cast(spr5, FlxSprite).screenCenter();
					}

				case 'setGraphicSize':
					final spr6 = resolveObjectPath(aStr(args, 0));
					if (Std.isOfType(spr6, FlxSprite))
					{
						cast(spr6, FlxSprite).setGraphicSize(aInt(args, 1), aInt(args, 2, 0));
						cast(spr6, FlxSprite).updateHitbox();
					}

				case 'scaleObject':
					final spr7 = resolveObjectPath(aStr(args, 0));
					if (Std.isOfType(spr7, FlxSprite))
					{
						final scaleX = aNum(args, 1, 1);
						final scaleY = optNum(args, 2);
						cast(spr7, FlxSprite).scale.set(scaleX, scaleY == null ? scaleX : scaleY);
						cast(spr7, FlxSprite).updateHitbox();
					}

				case 'setScrollFactor':
					final spr8 = resolveObjectPath(aStr(args, 0));
					if (Std.isOfType(spr8, FlxSprite))
						cast(spr8, FlxSprite).scrollFactor.set(aNum(args, 1, 1), aNum(args, 2, aNum(args, 1, 1)));

				case 'setTextString':
					final txt = resolveObjectPath(aStr(args, 0));
					if (Std.isOfType(txt, FlxText)) cast(txt, FlxText).text = aStr(args, 1);

				case 'setTextSize':
					final txt2 = resolveObjectPath(aStr(args, 0));
					if (Std.isOfType(txt2, FlxText)) cast(txt2, FlxText).size = aInt(args, 1, 24);

				case 'setTextWidth':
					final txt3 = resolveObjectPath(aStr(args, 0));
					if (Std.isOfType(txt3, FlxText)) cast(txt3, FlxText).fieldWidth = aNum(args, 1, 0);

				case 'setTextColor':
					final txt4 = resolveObjectPath(aStr(args, 0));
					if (Std.isOfType(txt4, FlxText)) cast(txt4, FlxText).color = backend.FpsPanelApi.parseColor(aStr(args, 1, 'FFFFFF'));

				case 'setTextFont':
					final txt5 = resolveObjectPath(aStr(args, 0));
					if (Std.isOfType(txt5, FlxText)) cast(txt5, FlxText).font = Paths.font(aStr(args, 1));

				case 'setTextAlignment':
					final txt6 = resolveObjectPath(aStr(args, 0));
					if (Std.isOfType(txt6, FlxText))
						cast(txt6, FlxText).alignment = switch (aStr(args, 1))
						{
							case 'center': CENTER;
							case 'right': RIGHT;
							default: LEFT;
						};

				case 'setTextBorder':
					final txt7 = resolveObjectPath(aStr(args, 0));
					if (Std.isOfType(txt7, FlxText))
					{
						final text = cast(txt7, FlxText);
						text.borderStyle = FlxTextBorderStyle.OUTLINE;
						text.borderSize = aNum(args, 1, 1);
						text.borderColor = backend.FpsPanelApi.parseColor(aStr(args, 2, '000000'));
					}

				case 'playSound':
					FlxG.sound.play(Paths.sound(aStr(args, 0)), aNum(args, 1, 1));

				case 'playMusic':
					FlxG.sound.playMusic(Paths.music(aStr(args, 0)), aNum(args, 1, 1), aBool(args, 2, true));

				case 'stopSound':
					if (FlxG.sound.music != null) FlxG.sound.music.stop();

				case 'pauseSound':
					if (FlxG.sound.music != null) FlxG.sound.music.pause();

				case 'resumeSound':
					if (FlxG.sound.music != null) FlxG.sound.music.play();

				case 'setSoundVolume':
					if (FlxG.sound.music != null) FlxG.sound.music.volume = aNum(args, 0, 1);

				case 'doTweenX':
					doTween(aStr(args, 0), 'x', aNum(args, 1), aNum(args, 2, 1), aStr(args, 3, 'linear'));

				case 'doTweenY':
					doTween(aStr(args, 0), 'y', aNum(args, 1), aNum(args, 2, 1), aStr(args, 3, 'linear'));

				case 'doTweenAlpha':
					doTween(aStr(args, 0), 'alpha', aNum(args, 1), aNum(args, 2, 1), aStr(args, 3, 'linear'));

				case 'doTweenAngle':
					doTween(aStr(args, 0), 'angle', aNum(args, 1), aNum(args, 2, 1), aStr(args, 3, 'linear'));

				case 'doTweenZoom':
					doTween(aStr(args, 0), 'zoom', aNum(args, 1), aNum(args, 2, 1), aStr(args, 3, 'linear'));

				case 'doTweenColor':
					final obj = resolveObjectPath(aStr(args, 0));
					if (Std.isOfType(obj, FlxSprite))
						FlxTween.color(cast(obj, FlxSprite), aNum(args, 2, 1), cast(obj, FlxSprite).color, backend.FpsPanelApi.parseColor(aStr(args, 1, 'FFFFFF')));

				case 'cancelTween':
					final obj2 = resolveObjectPath(aStr(args, 0));
					if (obj2 != null) FlxTween.cancelTweensOf(obj2);

				case 'runTimer':
					final name = aStr(args, 0);
					final seconds = aNum(args, 1, 1);
					final loops = aInt(args, 2, 1);
					new FlxTimer().start(seconds, function(timer:FlxTimer)
					{
						call(name, [timer.loopsLeft]);
					}, loops);

				case 'call':
					final fn = aStr(args, 0);
					if (hasFunction(fn)) call(fn, []);

				case 'callTweenHook':
					final fn2 = aStr(args, 0);
					if (hasFunction(fn2)) call(fn2, []);

				case 'addMenuText':
					final ui = menuUI();
					if (ui != null) ui.addPageText(aStr(args, 0), aStr(args, 1), aNum(args, 2), aNum(args, 3), aInt(args, 4, 28), aStr(args, 5, 'FFFFFF'), aStr(args, 6, ''), aStr(args, 7, null));
					else
					{
						makeText(aStr(args, 0), aStr(args, 1), aNum(args, 2), aNum(args, 3), aInt(args, 4, 28));
						addSprite(aStr(args, 0));
					}

				case 'addMenuImage':
					final ui2 = menuUI();
					if (ui2 != null) ui2.addPageImage(aStr(args, 0), aStr(args, 1), aNum(args, 2), aNum(args, 3), aNum(args, 4, 1), aStr(args, 5, null));
					else
					{
						final id = aStr(args, 0);
						makeSprite(id, aStr(args, 1), aNum(args, 2), aNum(args, 3));
						final spr = objects.get(id);
						if (Std.isOfType(spr, FlxSprite))
						{
							final scale = aNum(args, 4, 1);
							cast(spr, FlxSprite).scale.set(scale, scale);
							cast(spr, FlxSprite).updateHitbox();
						}
						addSprite(id);
					}

				case 'addMenuImageFromFile':
					final ui3 = menuUI();
					if (ui3 != null) ui3.addPageImageFromFile(aStr(args, 0), aStr(args, 1), aNum(args, 2), aNum(args, 3), aNum(args, 4, 1), aStr(args, 5, null));

				case 'addMenuButton':
					final ui4 = menuUI();
					if (ui4 != null) ui4.addScriptButton(aStr(args, 0), aStr(args, 1), aNum(args, 2), aNum(args, 3), aNum(args, 4, 1), aStr(args, 5, null));
					else if (mainMenu() != null) mainMenu().addScriptButton(aStr(args, 0), aStr(args, 1), aNum(args, 2), aNum(args, 3), aNum(args, 4, 1), aStr(args, 5, null));

				case 'addMenuItemText':
					final ui5 = menuUI();
					if (ui5 != null) ui5.addPageItem(aStr(args, 0), aStr(args, 1));
					else if (mainMenu() != null)
					{
						final main = mainMenu();
						final id = aStr(args, 0);
						final text = new FlxText(0, 0, FlxG.width, aStr(args, 1), aInt(args, 2, 36));
						text.setFormat(Paths.font('NotoSansSC-Regular.otf'), aInt(args, 2, 36), backend.FpsPanelApi.parseColor(aStr(args, 3, 'FFFFFF')), CENTER);
						text.scrollFactor.set();
						main.addMenuItemSprite(id, text);
						main.layoutMenuItems();
						main.refreshMenu();
					}

				case 'addMenuItem':
					final ui6 = menuUI();
					if (ui6 != null)
					{
						final id = aStr(args, 0);
						final image = aStr(args, 1);
						final item = ui6.addPageImage(id, 'mainmenu/menu_' + image, aNum(args, 2), aNum(args, 3), 1, null);
						if (args.length > 5) item.state = aStr(args, 5, null);
					}
					else if (mainMenu() != null)
					{
						mainMenu().addMenuItem(aStr(args, 0), aStr(args, 1), optNum(args, 2), optNum(args, 3), aStr(args, 4, null), aStr(args, 5, null));
						mainMenu().layoutMenuItems();
					}

				case 'setMenuItemState', 'pageSetState', 'storySetWeekState', 'freeplaySetSongState':
					final ui7 = menuUI();
					if (ui7 != null) ui7.setItemState(aStr(args, 0), aStr(args, 1));
					else if (mainMenu() != null) mainMenu().setOptionState(aStr(args, 0), aStr(args, 1));

				case 'setMenuItemPage', 'pageSetPage':
					final ui8 = menuUI();
					if (ui8 != null) ui8.setItemPage(aStr(args, 0), aStr(args, 1));
					else if (mainMenu() != null) mainMenu().setOptionPage(aStr(args, 0), aStr(args, 1));

				case 'setMenuItemCallback', 'pageSetCallback':
					final ui9 = menuUI();
					if (ui9 != null) ui9.setItemCallback(aStr(args, 0), aStr(args, 1));
					else if (mainMenu() != null) mainMenu().setOptionCallback(aStr(args, 0), aStr(args, 1));

				case 'setMenuItemURL', 'pageSetURL':
					final ui10 = menuUI();
					if (ui10 != null) ui10.setItemURL(aStr(args, 0), aStr(args, 1));
					else if (mainMenu() != null) mainMenu().setOptionURL(aStr(args, 0), aStr(args, 1));

				case 'setMenuItemColor':
					final ui11 = menuUI();
					if (ui11 != null) ui11.setItemColor(aStr(args, 0), aStr(args, 1));
					else if (mainMenu() != null) mainMenu().setMenuItemColorAt(mainMenu().getMenuItemIndex(aStr(args, 0)), aStr(args, 1));

				case 'setMenuItemVisible':
					final ui12 = menuUI();
					if (ui12 != null) ui12.setItemVisible(aStr(args, 0), aBool(args, 1, true));
					else if (mainMenu() != null) mainMenu().setMenuItemVisibleAt(mainMenu().getMenuItemIndex(aStr(args, 0)), aBool(args, 1, true));

				case 'setMenuItemEnabled':
					final ui13 = menuUI();
					if (ui13 != null) ui13.setItemEnabled(aStr(args, 0), aBool(args, 1, true));
					else if (mainMenu() != null) mainMenu().setMenuItemEnabledAt(mainMenu().getMenuItemIndex(aStr(args, 0)), aBool(args, 1, true));

				case 'hideMenuObject':
					setMenuTagVisible(aStr(args, 0), false);

				case 'showMenuObject', 'restoreMenuObjects':
					if (tag == 'restoreMenuObjects')
					{
						for (key in MenuScripts.objects.keys()) MenuScripts.objects.get(key).visible = true;
					}
					else setMenuTagVisible(aStr(args, 0), true);

				case 'destroyMenuObject':
					dropMenuObject(aStr(args, 0));

				case 'hideAllMenuObjects':
					for (key in MenuScripts.objects.keys()) MenuScripts.objects.get(key).visible = false;

				case 'setMenuObjectVisible':
					setMenuTagVisible(aStr(args, 0), aBool(args, 1, true));

				case 'setMenuObjectAlpha':
					final obj3 = MenuScripts.menuObject(aStr(args, 0));
					if (obj3 != null && Std.isOfType(obj3, FlxSprite)) cast(obj3, FlxSprite).alpha = aNum(args, 1, 1);

				case 'setMenuObjectCallback':
					final ui14 = menuUI();
					if (ui14 != null) ui14.setItemCallback(aStr(args, 0), aStr(args, 1));
					else if (mainMenu() != null) mainMenu().setOptionCallback(aStr(args, 0), aStr(args, 1));

				case 'menuLayout':
					final ui15 = menuUI();
					if (ui15 != null)
					{
						ui15.startY = aNum(args, 0, 260);
						ui15.spacing = aNum(args, 1, 120);
						ui15.refresh();
					}
					else if (mainMenu() != null)
					{
						mainMenu().layoutMenuItems();
						mainMenu().refreshMenu();
					}

				case 'menuSelect':
					final ui16 = menuUI();
					if (ui16 != null) ui16.selectPageItem(args.length > 0 ? args[0] : null);
					else if (mainMenu() != null) mainMenu().selectMenuItem(args.length > 0 ? args[0] : null);

				case 'setMenuColumn':
					final ui17 = menuUI();
					if (ui17 != null) ui17.column = aStr(args, 0, 'center');
					else if (mainMenu() != null) mainMenu().setColumnByName(aStr(args, 0, 'center'));

				case 'menuScreenCenter':
					final ui18 = menuUI();
					if (ui18 != null)
					{
						final obj4 = ui18.getItem(aStr(args, 0));
						if (obj4 != null && obj4.sprite != null)
						{
							if (aStr(args, 1, '') == 'y') obj4.sprite.screenCenter(Y);
							else obj4.sprite.screenCenter(X);
						}
					}

				case 'setMenuBG':
					final ui19 = menuUI();
					if (ui19 != null) ui19.setBackgroundImage(aStr(args, 0));
					else if (mainMenu() != null) mainMenu().setBackgroundImage(aStr(args, 0));
					else
					{
						final bgObj = MenuScripts.menuObject('bg');
						if (bgObj != null && Std.isOfType(bgObj, FlxSprite))
						{
							final graphic = Paths.image(aStr(args, 0));
							if (graphic != null) cast(bgObj, FlxSprite).loadGraphic(graphic);
						}
					}

				case 'setMenuBGColor':
					final bgObj2 = MenuScripts.menuObject('bg');
					if (bgObj2 != null && Std.isOfType(bgObj2, FlxSprite))
						cast(bgObj2, FlxSprite).color = backend.FpsPanelApi.parseColor(aStr(args, 0, 'FFFFFF'));

				case 'openMenuState':
					MenuNav.open(aStr(args, 0));

				case 'exitToTitle':
					MusicBeatState.switchState(new TitleState());

				case 'menuRestart':
					MusicBeatState.switchState(new CustomMenuState());

				case 'menuOpenURL':
					final url = aStr(args, 0);
					#if windows
					Sys.command('cmd', ['/c', 'start', '', url]);
					#elseif mac
					Sys.command('open', [url]);
					#elseif linux
					Sys.command('xdg-open', [url]);
					#end

				case 'menuLock':
					final ui20 = menuUI();
					if (ui20 != null) ui20.lockPage();
					else if (mainMenu() != null) mainMenu().markMenuLeft();

				case 'menuUnlock':
					final ui21 = menuUI();
					if (ui21 != null) ui21.unlockPage();
					else if (mainMenu() != null) mainMenu().unlockMenu();

				case 'pageOpen':
					final ui22 = menuUI();
					if (ui22 != null) ui22.pushPage(aStr(args, 0));

				case 'pageBack':
					final ui23 = menuUI();
					if (ui23 != null) ui23.back();

				case 'pageTitle':
					final ui24 = menuUI();
					if (ui24 != null) ui24.setTitle(aStr(args, 0));

				case 'pageSetBG':
					final ui25 = menuUI();
					if (ui25 != null) ui25.setBackgroundImage(aStr(args, 0));

				case 'pageSetBGDim':
					final ui26 = menuUI();
					if (ui26 != null) ui26.setBackgroundDim(aNum(args, 0, 0.5));

				case 'pageAddItem':
					final ui27 = menuUI();
					if (ui27 != null)
					{
						final id = aStr(args, 0);
						final label = aStr(args, 1);
						ui27.addPageItem(id, label);
					}

				case 'pageRemoveItem':
					final ui28 = menuUI();
					if (ui28 != null) ui28.removePageItem(aStr(args, 0));

				case 'pageClearItems':
					final ui29 = menuUI();
					if (ui29 != null) ui29.clearPageItems();

				case 'startMenuVideo':
					backend.VideoAudio.play(aStr(args, 0), aBool(args, 1, false));

				case 'stopMenuVideo':
					backend.VideoAudio.reset();

				case 'freeplayPlaySong':
					final song = aStr(args, 0);
					if (song != null && song.length > 0)
					{
						try
						{
							Song.loadFromJson(Paths.formatToSongPath(song), Paths.formatToSongPath(song));
							PlayState.isStoryMode = false;
							PlayState.storyDifficulty = 1;
							LoadingState.prepareToSong();
							LoadingState.loadAndSwitchState(new PlayState());
						}
						catch (e:Dynamic)
							scriptError('' + e);
					}

				case 'addCustomRank', 'removeRank', 'clearCustomRanks', 'resetRanks', 'setRankAccuracy',
					'setRatingWindow', 'setRatingScore', 'setRatingMod', 'setRatingImage', 'setRatingHits',
					'setRatingNoteSplash', 'addCustomRating', 'removeCustomRating', 'clearCustomRatings', 'resetRatings',
					'setRatingPercent', 'setRatingName', 'setRatingFC', 'addCustomFCBadge', 'removeCustomFCBadge',
					'clearCustomFCBadges', 'setFCBadgeRequirement', 'clearFCBadgeRequirements', 'setFCBadgeMaxMisses',
					'setFCBadgeMinAccuracy', 'setFCBadgePriority', 'refreshFCBadge', 'setNoteKeyCount', 'setNoteLaneCount',
					'addNoteLane', 'removeNoteLane', 'setNoteLaneEnabled', 'setNoteLaneAlpha', 'setNoteLaneOffset',
					'refreshLaneLayout', 'resetNoteLanes', 'setupNoteLanes', 'addHealthIconBand', 'setHealthIconFrames',
					'clearHealthIconFrames', 'cameraShake', 'cameraFlash', 'cameraFade':
					final game:PlayState = PlayState.instance;
					if (game == null) return null;
					switch (tag)
					{
						case 'addCustomRank': game.addCustomRank(aStr(args, 0), aNum(args, 1));
						case 'removeRank': game.removeRank(aStr(args, 0));
						case 'clearCustomRanks': game.clearCustomRanks();
						case 'resetRanks': game.resetRanks();
						case 'setRankAccuracy': game.setRankAccuracy(aStr(args, 0), aNum(args, 1));
						case 'setRatingWindow': game.setRatingWindow(aStr(args, 0), aNum(args, 1));
						case 'setRatingScore': game.setRatingScore(aStr(args, 0), aInt(args, 1));
						case 'setRatingMod': game.setRatingMod(aStr(args, 0), aNum(args, 1));
						case 'setRatingImage': game.setRatingImage(aStr(args, 0), aStr(args, 1));
						case 'setRatingHits': game.setRatingHits(aStr(args, 0), aInt(args, 1));
						case 'setRatingNoteSplash': game.setRatingNoteSplash(aStr(args, 0), aBool(args, 1, true));
						case 'addCustomRating': game.addCustomRating(aStr(args, 0), aNum(args, 1), aInt(args, 2), aNum(args, 3), aStr(args, 4), aBool(args, 5, false));
						case 'removeCustomRating': game.removeCustomRating(aStr(args, 0));
						case 'clearCustomRatings': game.clearCustomRatings();
						case 'resetRatings': game.resetRatings();
						case 'setRatingPercent': game.setRatingPercent(aNum(args, 0));
						case 'setRatingName': game.setRatingName(aStr(args, 0));
						case 'setRatingFC': game.setRatingFC(aStr(args, 0));
						case 'addCustomFCBadge': game.addCustomFCBadge(aStr(args, 0), aInt(args, 1), aInt(args, 2, -1), aNum(args, 3, -1));
						case 'removeCustomFCBadge': game.removeCustomFCBadge(aStr(args, 0));
						case 'clearCustomFCBadges': game.clearCustomFCBadges();
						case 'setFCBadgeRequirement': game.setFCBadgeRequirement(aStr(args, 0), aStr(args, 1), aInt(args, 2), aInt(args, 3));
						case 'clearFCBadgeRequirements': game.clearFCBadgeRequirements();
						case 'setFCBadgeMaxMisses': game.setFCBadgeMaxMisses(aStr(args, 0), aInt(args, 1));
						case 'setFCBadgeMinAccuracy': game.setFCBadgeMinAccuracy(aStr(args, 0), aNum(args, 1));
						case 'setFCBadgePriority': game.setFCBadgePriority(aStr(args, 0), aInt(args, 1));
						case 'refreshFCBadge': game.refreshFCBadge();
						case 'setNoteKeyCount': game.setNoteKeyCount(aInt(args, 0, 4));
						case 'setNoteLaneCount': game.setNoteLaneCount(aInt(args, 0, 1), aBool(args, 1, true));
						case 'addNoteLane': game.addNoteLane(aBool(args, 0, true));
						case 'removeNoteLane': game.removeNoteLane(aInt(args, 0), aBool(args, 1, true));
						case 'setNoteLaneEnabled': game.setNoteLaneEnabled(aInt(args, 0), aBool(args, 1, true));
						case 'setNoteLaneAlpha': game.setNoteLaneAlpha(aInt(args, 0), aNum(args, 1, 1));
						case 'setNoteLaneOffset': game.setNoteLaneOffset(aInt(args, 0), aNum(args, 1, 0));
						case 'refreshLaneLayout': game.refreshLaneLayout();
						case 'resetNoteLanes': game.resetNoteLanes();
						case 'setupNoteLanes': game.setupNoteLanes();
						case 'addHealthIconBand': game.addHealthIconBand(aInt(args, 0), aInt(args, 1));
						case 'setHealthIconFrames':
							final frames:Array<Int> = [];
							if (Std.isOfType(args[0], Array))
								for (value in cast(args[0], Array<Dynamic>)) frames.push(Std.int(aNum([value], 0)));
							game.setHealthIconFrames(frames);
						case 'clearHealthIconFrames': game.clearHealthIconFrames();
						case 'cameraShake': FlxG.camera.shake(aNum(args, 0, 0.05), aNum(args, 1, 0.5));
						case 'cameraFlash': FlxG.camera.flash(backend.FpsPanelApi.parseColor(aStr(args, 0, 'FFFFFF')), aNum(args, 1, 1));
						case 'cameraFade': FlxG.camera.fade(backend.FpsPanelApi.parseColor(aStr(args, 0, '000000')), aNum(args, 1, 1), aBool(args, 2, false));
					}

				case 'createPianoKeys':
					createPianoKeys(args.length > 0 ? args[0] : null);

				case 'removePianoKeys':
					removePianoKeys();

				case 'addPianoKey':
					addPianoKey(args.length > 0 ? args[0] : null);

				case 'removePianoKey':
					removePianoKey(aInt(args, 0));

				case 'clearPianoKeys':
					clearPianoKeys();

				case 'setPianoKeysAnchor':
					pianoSet('anchor', aStr(args, 0, 'bottom'));

				case 'setPianoKeysHeight':
					pianoSet('height', aNum(args, 0, 110));

				case 'setPianoKeysGap':
					pianoSet('gap', aNum(args, 0, 6));

				case 'setPianoKeysMargin':
					pianoSet('margin', aNum(args, 0, 14));

				case 'setPianoKeysPosition':
					pianoX = aNum(args, 0, 0);
					pianoY = aNum(args, 1, 0);
					if (pianoGroup != null)
					{
						pianoGroup.x = pianoX;
						pianoGroup.y = pianoY;
					}

				case 'setPianoKeysArt':
					if (pianoConfig != null)
					{
						Reflect.setField(pianoConfig, 'art', aStr(args, 0, ''));
						Reflect.setField(pianoConfig, 'artKeys', args.length > 1 ? args[1] : null);
					}

				case 'setPianoKeysAlpha':
					pianoSet('alpha', aNum(args, 0, 1));

				case 'setPianoKeysVisible':
					pianoSet('visible', aBool(args, 0, true));

				case 'setPianoKeysEnabled':
					pianoSet('enabled', aBool(args, 0, true));

				case 'setPianoKeyLabel':
					setPianoKeyField(aInt(args, 0), 'label', aStr(args, 1));
				case 'setPianoKeyColor':
					setPianoKeyField(aInt(args, 0), 'colour', aStr(args, 1, '000000'));
					setPianoKeyField(aInt(args, 0), 'pressedColour', aStr(args, 2, '00FF88'));
				case 'setPianoKeyTextColor':
					setPianoKeyField(aInt(args, 0), 'textColour', aStr(args, 1, 'FFFFFF'));
				case 'setPianoKeyTextSize':
					setPianoKeyField(aInt(args, 0), 'textSize', aNum(args, 1, 18));
				case 'setPianoKeyImage':
					setPianoKeyField(aInt(args, 0), 'image', aStr(args, 1));
				case 'setPianoKeyAction':
					setPianoKeyField(aInt(args, 0), 'action', aStr(args, 1));
				case 'setPianoKeyKey':
					setPianoKeyField(aInt(args, 0), 'key', aStr(args, 1));
				case 'setPianoKeyWeight':
					setPianoKeyField(aInt(args, 0), 'weight', aNum(args, 1, 1));
				case 'setPianoKeyWidth':
					setPianoKeyField(aInt(args, 0), 'width', aNum(args, 1, 0));
				case 'setPianoKeyHeight':
					setPianoKeyField(aInt(args, 0), 'height', aNum(args, 1, 0));
				case 'setPianoKeyOffset':
					setPianoKeyField(aInt(args, 0), 'offset', aNum(args, 1, 0));
				case 'setPianoKeyEnabled':
					setPianoKeyField(aInt(args, 0), 'enabled', aBool(args, 1, true));

				case 'videoFillScreen':
					if (PlayState.instance != null) PlayState.instance.videoFillScreen();
				case 'videoFitScreen':
					if (PlayState.instance != null) PlayState.instance.videoFitScreen();
				case 'setVideoSize':
					if (PlayState.instance != null) PlayState.instance.setVideoSize(aNum(args, 0), aNum(args, 1));
				case 'setVideoScale':
					if (PlayState.instance != null) PlayState.instance.setVideoScale(aNum(args, 0, 1));
				case 'setVideoPos':
					if (PlayState.instance != null) PlayState.instance.setVideoPos(aNum(args, 0), aNum(args, 1));
				case 'setVideoAutoLayout':
					if (PlayState.instance != null) PlayState.instance.setVideoAutoLayout(aBool(args, 0, true), aStr(args, 1, null));
				case 'setVideoAlpha':
					if (PlayState.instance != null) PlayState.instance.setVideoAlpha(aNum(args, 0, 1));
				case 'pauseVideo':
					if (PlayState.instance != null) PlayState.instance.pauseVideo();
				case 'resumeVideo':
					if (PlayState.instance != null) PlayState.instance.resumeVideo();

				case 'addLoadingText':
					LoadingState.addLoadingText(aStr(args, 0), aStr(args, 1), aNum(args, 2), aNum(args, 3), aInt(args, 4, 24));
				case 'addLoadingImage':
					LoadingState.addLoadingImage(aStr(args, 0), aStr(args, 1), aNum(args, 2), aNum(args, 3), aNum(args, 4, 1));
				case 'hideLoadingObject':
					LoadingState.setLoadingVisible(false);
				case 'showLoadingObject':
					LoadingState.setLoadingVisible(true);
				case 'moveLoadingObject':
					LoadingState.moveLoadingObject(aStr(args, 0), aNum(args, 1), aNum(args, 2));
				case 'setLoadingText':
					LoadingState.setLoadingTextValue(aStr(args, 0));
				case 'setLoadingBackgroundColor':
					LoadingState.setLoadingBackgroundColor(aStr(args, 0, '000000'));

				case 'setHealth':
					if (PlayState.instance != null) PlayState.instance.setHealth(aNum(args, 0, 1));
				case 'addHealth':
					if (PlayState.instance != null) PlayState.instance.addHealth(aNum(args, 0, 0));
				case 'setHealthOverflow':
					if (PlayState.instance != null) PlayState.instance.setHealthOverflow(aBool(args, 0, false));
				case 'setHealthMax':
					if (PlayState.instance != null) PlayState.instance.setHealthMax(aNum(args, 0, 2));
				case 'setHealthMin':
					if (PlayState.instance != null) PlayState.instance.setHealthMin(aNum(args, 0, 0));
				case 'setHealthBounds':
					if (PlayState.instance != null) PlayState.instance.setHealthBounds(aNum(args, 0, 0), aNum(args, 1, 2));
				case 'setHealthDisplayMax':
					if (PlayState.instance != null) PlayState.instance.setHealthDisplayMax(aNum(args, 0, 2));
				case 'setHealthPercent':
					if (PlayState.instance != null) PlayState.instance.setHealthPercent(aNum(args, 0, 50));
				case 'setDeathHealth':
					if (PlayState.instance != null) PlayState.instance.setDeathHealth(aNum(args, 0, 0));
				case 'setHealthClamp':
					if (PlayState.instance != null) PlayState.instance.setHealthClamp(aBool(args, 0, true));
				case 'setHealthLock':
					if (PlayState.instance != null) PlayState.instance.setHealthLock(aBool(args, 0, false));
				case 'setInvincible':
					if (PlayState.instance != null) PlayState.instance.setInvincible(aBool(args, 0, false));
				case 'setHealthRegen':
					if (PlayState.instance != null) PlayState.instance.setHealthRegen(aNum(args, 0, 0));
				case 'setHealthDrain':
					if (PlayState.instance != null) PlayState.instance.setHealthDrain(aNum(args, 0, 0));
				case 'setHealthGain':
					if (PlayState.instance != null) PlayState.instance.setHealthGain(aNum(args, 0, 1));
				case 'setHealthLoss':
					if (PlayState.instance != null) PlayState.instance.setHealthLoss(aNum(args, 0, 1));
				case 'setSustainHealth':
					if (PlayState.instance != null) PlayState.instance.setSustainHealth(aBool(args, 0, true));
				case 'setSustainHealthMult':
					if (PlayState.instance != null) PlayState.instance.setSustainHealthMult(aNum(args, 0, 1));

				case 'freeplayGetSongCharacter', 'freeplayGetSongColor', 'freeplayGetSelected',
					'freeplaySelectSong', 'freeplayConfirmSong', 'freeplayIsPlayingPreview', 'freeplayGetDifficulty',
					'freeplaySetDifficulty', 'freeplaySetTouchMode':
					if (!Std.isOfType(FlxG.state, FreeplayState)) return null;
					final fp:FreeplayState = cast FlxG.state;
					switch (tag)
					{
						case 'freeplaySelectSong': fp.selectSongByIndex(fp.resolveSongIndex(args.length > 0 ? args[0] : 0));
						case 'freeplayConfirmSong': fp.confirmSong();
						case 'freeplaySetDifficulty': fp.setDifficultyValue(aInt(args, 0));
						case 'freeplaySetTouchMode': fp.setTouchMode(aStr(args, 0, 'default'));
						default:
					}

				case 'storyGetWeekId', 'storyGetWeekName', 'storyGetWeekSongs',
					'storyGetSelectedWeek', 'storyIsWeekLocked', 'storySetWeekState', 'storySetWeekCallback',
					'storySetWeekPage', 'storySetWeekURL':
					if (!Std.isOfType(FlxG.state, StoryMenuState)) return null;
					final sm:StoryMenuState = cast FlxG.state;
					switch (tag)
					{
						case 'storySetWeekState': sm.setWeekAction(aStr(args, 0), aStr(args, 1));
						case 'storySetWeekCallback': sm.setWeekCallback(aStr(args, 0), aStr(args, 1));
						case 'storySetWeekPage': sm.setWeekPage(aStr(args, 0), aStr(args, 1));
						case 'storySetWeekURL': sm.setWeekURL(aStr(args, 0), aStr(args, 1));
						default:
					}

				default:
					if (PhysicsApi.handles(tag)) return PhysicsApi.call(tag, args);
					if (MathApi.handles(tag)) return MathApi.call(tag, args);
					if (!dispatchMenuExtra(tag, args))
						debugPrint('unhandled API: ' + tag);
			}
		}
		catch (e:Dynamic)
		{
			scriptError('' + e);
		}
		return null;
	}

	function dispatchMenuExtra(tag:String, args:Array<Dynamic>):Bool
	{
		final ui = menuUI();
		final main = mainMenu();
		switch (tag)
		{
			case 'setMenuTextString':
				final textObj = MenuScripts.menuObject(aStr(args, 0));
				if (Std.isOfType(textObj, FlxText)) cast(textObj, FlxText).text = aStr(args, 1, '');

			case 'setMenuTextColor':
				final textObj2 = MenuScripts.menuObject(aStr(args, 0));
				if (Std.isOfType(textObj2, FlxText))
					cast(textObj2, FlxText).color = backend.FpsPanelApi.parseColor(aStr(args, 1, 'FFFFFF'));

			case 'setMenuObjectPos':
				final posObj = MenuScripts.menuObject(aStr(args, 0));
				if (Std.isOfType(posObj, FlxSprite)) cast(posObj, FlxSprite).setPosition(aNum(args, 1), aNum(args, 2));

			case 'setMenuObjectScale':
				final scaleObj = MenuScripts.menuObject(aStr(args, 0));
				if (Std.isOfType(scaleObj, FlxSprite))
				{
					final sprite:FlxSprite = cast scaleObj;
					final scale = aNum(args, 1, 1);
					sprite.scale.set(scale, scale);
					sprite.updateHitbox();
				}

			case 'setMenuObjectAngle':
				final angleObj = MenuScripts.menuObject(aStr(args, 0));
				if (Std.isOfType(angleObj, FlxSprite)) cast(angleObj, FlxSprite).angle = aNum(args, 1);

			case 'removeMenuObject':
				dropMenuObject(aStr(args, 0));

			case 'showAllMenuObjects':
				for (key in MenuScripts.objects.keys()) MenuScripts.objects.get(key).visible = true;

			case 'setMenuBGVisible':
				final bg = MenuScripts.menuObject('bg');
				if (bg != null) bg.visible = aBool(args, 0, true);

			case 'setMenuMagentaAlpha':
				final magenta = MenuScripts.menuObject('magenta');
				if (Std.isOfType(magenta, FlxSprite)) cast(magenta, FlxSprite).alpha = aNum(args, 0, 1);

			case 'refreshMenu':
				if (ui != null) ui.refresh();
				else if (main != null)
				{
					main.layoutMenuItems();
					main.refreshMenu();
					main.updateScriptButtons();
				}

			case 'setMenuItemPos':
				final id = aStr(args, 0);
				final x = aNum(args, 1);
				final y = aNum(args, 2);
				if (ui != null) ui.setItemPos(id, x, y);
				else if (main != null)
				{
					final sprite = main.getMenuItem(main.getMenuItemIndex(id));
					if (sprite != null) sprite.setPosition(x, y);
				}

			case 'setMenuItemScale':
				final id2 = aStr(args, 0);
				final scale2 = aNum(args, 1, 1);
				if (ui != null) ui.setItemScale(id2, scale2);
				else if (main != null)
				{
					final sprite = main.getMenuItem(main.getMenuItemIndex(id2));
					if (sprite != null)
					{
						sprite.scale.set(scale2, scale2);
						sprite.updateHitbox();
					}
				}

			case 'setMenuItemAlpha':
				final id3 = aStr(args, 0);
				final alpha = aNum(args, 1, 1);
				if (ui != null)
				{
					final item = ui.getItem(id3);
					if (item != null && item.sprite != null) item.sprite.alpha = alpha;
				}
				else if (main != null)
				{
					final sprite = main.getMenuItem(main.getMenuItemIndex(id3));
					if (sprite != null) sprite.alpha = alpha;
				}

			case 'setMenuItemImage':
				final id4 = aStr(args, 0);
				final image = aStr(args, 1);
				if (ui != null)
				{
					final item = ui.getItem(id4);
					if (item != null && item.sprite != null) ui.applyImage(item.sprite, image);
				}
				else if (main != null)
				{
					final sprite = main.getMenuItem(main.getMenuItemIndex(id4));
					final graphic = Paths.image(image);
					if (sprite != null && graphic != null) sprite.loadGraphic(graphic);
				}

			case 'addMenuItemFromFile':
				if (ui != null) ui.addPageImageFromFile(aStr(args, 0), aStr(args, 1), aNum(args, 2), aNum(args, 3), aNum(args, 4, 1), aStr(args, 5, null));

			case 'setMenuButtonCallback':
				if (ui != null) ui.setScriptButtonCallback(aStr(args, 0), aStr(args, 1));
				else if (main != null) main.setScriptButtonCallback(aStr(args, 0), aStr(args, 1));

			case 'removeMenuButton':
				if (ui != null) ui.removeScriptButton(aStr(args, 0));
				else if (main != null) main.removeScriptButton(aStr(args, 0));

			case 'removeMenuItem':
				final id5 = aStr(args, 0);
				if (ui != null) ui.removePageItem(id5);
				else if (main != null)
				{
					final index = main.getMenuItemIndex(id5);
					if (index >= 0) main.removeMenuItemAt(index);
				}

			case 'setMenuOptionState', 'setMenuOptionCallback', 'setMenuOptionPage':
				if (main == null) return true;
				switch (tag)
				{
					case 'setMenuOptionState': main.setOptionState(aStr(args, 0), aStr(args, 1));
					case 'setMenuOptionCallback': main.setOptionCallback(aStr(args, 0), aStr(args, 1));
					case 'setMenuOptionPage': main.setOptionPage(aStr(args, 0), aStr(args, 1));
				}

			case 'pageSetPos':
				if (ui != null) ui.setItemPos(aStr(args, 0), aNum(args, 1), aNum(args, 2));
			case 'pageSetScale':
				if (ui != null) ui.setItemScale(aStr(args, 0), aNum(args, 1, 1));
			case 'pageSetColor':
				if (ui != null) ui.setItemColor(aStr(args, 0), aStr(args, 1));
			case 'pageSetVisible':
				if (ui != null) ui.setItemVisible(aStr(args, 0), aBool(args, 1, true));
			case 'pageSetEnabled':
				if (ui != null) ui.setItemEnabled(aStr(args, 0), aBool(args, 1, true));
			case 'pageSelect':
				if (ui != null) ui.selectPageItem(args.length > 0 ? args[0] : null);
			case 'pageActivate':
				if (ui != null) ui.activateItem(aInt(args, 0, -1));
			case 'pageLock':
				if (ui != null)
				{
					if (aBool(args, 0, true)) ui.lockPage();
					else ui.unlockPage();
				}
			case 'pageAddImageItem':
				if (ui != null) ui.addPageImage(aStr(args, 0), aStr(args, 1), aNum(args, 2), aNum(args, 3), aNum(args, 4, 1), aStr(args, 5, null));
			case 'pageAddImageItemFromFile':
				if (ui != null) ui.addPageImageFromFile(aStr(args, 0), aStr(args, 1), aNum(args, 2), aNum(args, 3), aNum(args, 4, 1), aStr(args, 5, null));
			case 'pageLayout':
				if (ui != null)
				{
					ui.startY = aNum(args, 0, 260);
					ui.spacing = aNum(args, 1, 120);
					ui.refresh();
				}

			case 'storySelectWeek':
				if (Std.isOfType(FlxG.state, StoryMenuState)) cast(FlxG.state, StoryMenuState).selectWeek(args.length > 0 ? args[0] : null);
			case 'storyConfirmWeek':
				if (Std.isOfType(FlxG.state, StoryMenuState)) cast(FlxG.state, StoryMenuState).confirmWeek();

			case 'hideWeek':
				WeekData.setWeekHidden(aStr(args, 0), true);
				WeekData.applyWeekVisibility();
			case 'showWeek':
				WeekData.setWeekHidden(aStr(args, 0), false);
				WeekData.applyWeekVisibility();
			case 'clearHiddenWeeks':
				WeekData.clearWeekHiding();
			case 'refreshWeeks':
				WeekData.reloadWeekFiles(PlayState.isStoryMode);
				WeekData.applyWeekVisibility();

			case 'createExtraStrumGroup':
				if (PlayState.instance != null) PlayState.instance.createExtraStrumGroup(aStr(args, 0), aStr(args, 1, ''), aStr(args, 2, 'game'));
			case 'removeExtraStrumGroup':
				if (PlayState.instance != null) PlayState.instance.removeExtraStrumGroup(aStr(args, 0));
			case 'clearExtraStrumGroups':
				if (PlayState.instance != null) PlayState.instance.clearExtraStrumGroups();
			case 'setExtraStrumPos':
				if (PlayState.instance != null) PlayState.instance.setExtraStrumPos(aStr(args, 0), aNum(args, 1), aNum(args, 2));
			case 'setExtraStrumScale':
				if (PlayState.instance != null) PlayState.instance.setExtraStrumScale(aStr(args, 0), aNum(args, 1, 1));
			case 'setExtraStrumSpacing':
				if (PlayState.instance != null) PlayState.instance.setExtraStrumSpacing(aStr(args, 0), aNum(args, 1, 1));
			case 'setExtraStrumAlpha':
				if (PlayState.instance != null) PlayState.instance.setExtraStrumAlpha(aStr(args, 0), aNum(args, 1, 1));
			case 'setExtraStrumVisible':
				if (PlayState.instance != null) PlayState.instance.setExtraStrumVisible(aStr(args, 0), aBool(args, 1, true));
			case 'setExtraStrumCamera':
				if (PlayState.instance != null) PlayState.instance.setExtraStrumCamera(aStr(args, 0), aStr(args, 1, 'game'));
			case 'setExtraStrumSkin':
				if (PlayState.instance != null) PlayState.instance.setExtraStrumSkin(aStr(args, 0), aStr(args, 1, ''));
			case 'setExtraStrumJudge':
				if (PlayState.instance != null) PlayState.instance.setExtraStrumJudge(aStr(args, 0), aBool(args, 1, false));
			case 'setExtraStrumAction':
				if (PlayState.instance != null) PlayState.instance.setExtraStrumAction(aStr(args, 0), aInt(args, 1), aStr(args, 2, ''));
			case 'setExtraStrumActive':
				if (PlayState.instance != null) PlayState.instance.setExtraStrumActive(aStr(args, 0, ''));
			case 'spawnExtraNote':
				if (PlayState.instance != null) PlayState.instance.spawnExtraNote(aStr(args, 0), aInt(args, 1), aNum(args, 2));
			case 'setExtraStrumFollow':
				if (PlayState.instance != null) PlayState.instance.setExtraStrumFollow(aStr(args, 0), aStr(args, 1, ''), aNum(args, 2), aNum(args, 3));

			case 'setHealthBarVisible':
				if (PlayState.instance != null) PlayState.instance.setHealthBarVisible(aBool(args, 0, true));
			case 'setHealthBarAlpha':
				if (PlayState.instance != null) PlayState.instance.setHealthBarAlpha(aNum(args, 0, 1));
			case 'setHealthBarPosition':
				if (PlayState.instance != null) PlayState.instance.setHealthBarPosition(aNum(args, 0), aNum(args, 1));
			case 'setHealthBarMode':
				if (PlayState.instance != null) PlayState.instance.setHealthBarMode(aInt(args, 0, 1));
			case 'setHealthBarStretchFactor':
				if (PlayState.instance != null) PlayState.instance.setHealthBarStretchFactor(aNum(args, 0, 1));
			case 'setHealthBarMaxWidth':
				if (PlayState.instance != null) PlayState.instance.setHealthBarMaxWidth(aNum(args, 0, 0));
			case 'setHealthBarShiftPixelsPerHp':
				if (PlayState.instance != null) PlayState.instance.setHealthBarShiftPixelsPerHp(aNum(args, 0, 220));
			case 'setHealthBarShiftMax':
				if (PlayState.instance != null) PlayState.instance.setHealthBarShiftMax(aNum(args, 0, 220));
			case 'setHealthBarModeSmooth':
				if (PlayState.instance != null) PlayState.instance.setHealthBarModeSmooth(aBool(args, 0, true));
			case 'setHealthBarColors':
				if (PlayState.instance != null) PlayState.instance.setHealthBarColors(aStr(args, 0, 'FFFFFF'), aStr(args, 1, 'FF0000'));

			case 'setFPSPanelVisible':
				backend.FpsPanelApi.getPanel().setVisible(aBool(args, 0, true));
			case 'setFPSPanelAlpha':
				backend.FpsPanelApi.getPanel().setAlpha(aNum(args, 0, 1));
			case 'setFPSPanelPosition':
				backend.FpsPanelApi.getPanel().setPosition(aNum(args, 0, 6), aNum(args, 1, 4));
			case 'setFPSPanelCollapsed':
				backend.FpsPanelApi.getPanel().setCollapsed(aBool(args, 0, false));
			case 'toggleFPSPanel':
				backend.FpsPanelApi.getPanel().toggleCollapsed();
			case 'setFPSPanelClickable':
				backend.FpsPanelApi.getPanel().clickable = aBool(args, 0, true);
			case 'setFPSPanelTextColor':
				final rawColor:Dynamic = args.length > 0 ? args[0] : null;
				var colorValue:Int = -1;
				if (Std.isOfType(rawColor, String))
				{
					final colorText:String = Std.string(rawColor);
					if (colorText.length > 0) colorValue = backend.FpsPanelApi.parseColor(colorText);
				}
				else if (rawColor != null) colorValue = Std.int(aNum(args, 0, -1));
				backend.FpsPanelApi.getPanel().setTextColor(colorValue);
			case 'setFPSPanelFontSize':
				backend.FpsPanelApi.getPanel().setFontSize(aInt(args, 0, 12));
			case 'setFPSPanelBackgroundVisible':
				backend.FpsPanelApi.getPanel().backgroundVisible = aBool(args, 0, true);
				backend.FpsPanelApi.getPanel().background = aBool(args, 0, true);
			case 'setFPSPanelBackgroundColor':
				final bgColorText:String = aStr(args, 0, '');
				if (bgColorText.length == 0)
				{
					backend.FpsPanelApi.getPanel().backgroundVisible = false;
					backend.FpsPanelApi.getPanel().background = false;
				}
				else
				{
					backend.FpsPanelApi.getPanel().backgroundVisible = true;
					backend.FpsPanelApi.getPanel().setBackgroundColor(backend.FpsPanelApi.parseColor(bgColorText));
				}
			case 'setFPSPanelBackgroundAlpha':
				backend.FpsPanelApi.getPanel().setBackgroundAlpha(aNum(args, 0, 1));
			case 'setFPSPanelBackgroundImage':
				final imagePath:String = aStr(args, 0, '');
				if (imagePath.length == 0)
					backend.FpsPanelApi.getPanel().clearBackgroundImage();
				else
				{
					final imageData = Paths.image(imagePath);
					if (imageData != null)
					{
						backend.FpsPanelApi.getPanel().setBackground(imageData.bitmap);
						backend.FpsPanelApi.getPanel().backgroundImagePath = imagePath;
						backend.FpsPanelApi.getPanel().backgroundVisible = true;
					}
				}
			case 'setFPSPanelBackgroundImageAlpha':
				backend.FpsPanelApi.getPanel().setBackgroundImageAlpha(aNum(args, 0, 0.55));
			case 'resetFPSPanel':
				backend.FpsPanelApi.getPanel().resetPanel();

			case 'replaceMenuObject':
				replaceMenuObject(aStr(args, 0), aStr(args, 1), aNum(args, 2), aNum(args, 3), aNum(args, 4, 1));
			case 'replaceMenuObjectText':
				replaceMenuObjectText(aStr(args, 0), aStr(args, 1), aInt(args, 2, 32), aStr(args, 3, 'FFFFFF'));
			case 'restoreMenuObject':
				restoreMenuObject(aStr(args, 0));
			case 'attachMenuObject':
				attachMenuObject(aStr(args, 0), aStr(args, 1), aNum(args, 2), aNum(args, 3), aBool(args, 4, true));
			case 'detachMenuObject':
				detachMenuObject(aStr(args, 0));
			case 'setMenuObjectDraggable':
				setMenuObjectDraggable(aStr(args, 0), aBool(args, 1, true), aStr(args, 2, ''), aNum(args, 3), aNum(args, 4), aNum(args, 5), aNum(args, 6));
			case 'setMenuGestureConfig':
				setMenuGestureConfig(aNum(args, 0, 40), aNum(args, 1, 8), aNum(args, 2, 0.9), aNum(args, 3, 0.55));
			case 'stopMenuDrag':
				stopMenuDrag();
			case 'menuPlaySound':
				FlxG.sound.play(Paths.sound(aStr(args, 0)));
			case 'setMenuCameraZoom':
				FlxG.camera.zoom = aNum(args, 0, 1);
			case 'setMenuCameraAngle':
				FlxG.camera.angle = aNum(args, 0, 0);
			case 'setMenuCameraShake':
				FlxG.camera.shake(aNum(args, 0, 0.05), aNum(args, 1, 0.5));
			case 'resetMenuCamera':
				FlxG.camera.zoom = 1;
				FlxG.camera.angle = 0;

			case 'freeplaySetSongIcon':
				freeplaySetSongIcon(aInt(args, 0), aStr(args, 1), aNum(args, 2, 1), aNum(args, 3), aNum(args, 4));
			case 'freeplaySetSongIconText':
				freeplaySetSongIconText(aInt(args, 0), aStr(args, 1), aInt(args, 2, 28), aStr(args, 3, 'FFFFFF'));
			case 'freeplaySetSongIconVisible':
				freeplaySetSongIconVisible(aInt(args, 0), aBool(args, 1, true));
			case 'freeplayRestoreSongIcon':
				freeplayRestoreSongIcon(aInt(args, 0));
			case 'storySetWeekIcon':
				storySetWeekIcon(aInt(args, 0), aStr(args, 1), aNum(args, 2, 1), aNum(args, 3), aNum(args, 4));
			case 'storySetWeekIconText':
				storySetWeekIconText(aInt(args, 0), aStr(args, 1), aInt(args, 2, 40), aStr(args, 3, 'FFFFFF'));
			case 'storySetWeekIconVisible':
				storySetWeekIconVisible(aInt(args, 0), aBool(args, 1, true));
			case 'storyRestoreWeekIcon':
				storyRestoreWeekIcon(aInt(args, 0));

			case 'addJSScript', 'addScript':
				addJSScriptAt(aStr(args, 0));
			case 'removeJSScript', 'removeScript':
				removeJSScriptNamed(aStr(args, 0));
			case 'callScript':
				final scriptArgs:Array<Dynamic> = Std.isOfType(args.length > 2 ? args[2] : null, Array) ? cast args[2] : [];
				callScriptFunction(aStr(args, 0), aStr(args, 1), scriptArgs);
			case 'setVar', 'setOnScripts':
				setSharedVar(aStr(args, 0), args.length > 1 ? args[1] : null);
			case 'callOnScripts':
				final onArgs:Array<Dynamic> = Std.isOfType(args.length > 1 ? args[1] : null, Array) ? cast args[1] : [];
				callOnAllScripts(aStr(args, 0), onArgs);
			case 'loadSong':
				loadSongByName(aStr(args, 0), aInt(args, 1, 1));
			case 'refreshRank':
				if (PlayState.instance != null) PlayState.instance.refreshRank();
			case 'regenerateApiDocs':
				regenerateApiDocsFile(aStr(args, 0, ''));
			case 'setAchievementScore':
				#if ACHIEVEMENTS_ALLOWED
				Achievements.setScore(aStr(args, 0), aNum(args, 1));
				#else
				debugPrint('achievements are disabled');
				#end
			case 'addAchievementScore':
				#if ACHIEVEMENTS_ALLOWED
				Achievements.addScore(aStr(args, 0), aNum(args, 1, 1));
				#else
				debugPrint('achievements are disabled');
				#end
			case 'unlockAchievement':
				#if ACHIEVEMENTS_ALLOWED
				Achievements.unlock(aStr(args, 0));
				#else
				debugPrint('achievements are disabled');
				#end

			case 'setMenuSideState':
				if (main != null) main.setSideState(aStr(args, 0, 'left'), aStr(args, 1, ''));
			case 'setMenuSideCallback':
				if (main != null) main.setSideCallback(aStr(args, 0, 'left'), aStr(args, 1, ''));
			case 'setMenuSidePage':
				if (main != null) main.setSidePage(aStr(args, 0, 'left'), aStr(args, 1, ''));
			case 'setMenuSideVisible':
				if (main != null) main.setSideVisible(aStr(args, 0, 'left'), aBool(args, 1, true));
			case 'setMenuSidePos':
				if (main != null) main.setSidePos(aStr(args, 0, 'left'), aNum(args, 1), aNum(args, 2));
			case 'setMenuSideColor':
				if (main != null) main.setSideColor(aStr(args, 0, 'left'), aStr(args, 1, 'FFFFFF'));
			case 'setMenuSideImage':
				if (main != null) main.setSideImage(aStr(args, 0, 'left'), aStr(args, 1, ''));

			case 'initLuaShader':
				if (PlayState.instance != null) PlayState.instance.initLuaShader(aStr(args, 0));
			case 'setSpriteShader', 'setSpriteShaderShared':
				final game = PlayState.instance;
				final target:Dynamic = resolveObjectPath(aStr(args, 0));
				if (game != null && Std.isOfType(target, FlxSprite))
				{
					final shaderName:String = aStr(args, 1);
					final shader = game.createRuntimeShader(shaderName);
					if (shader != null)
					{
						cast(target, FlxSprite).shader = shader;
						shaderNames.set(aStr(args, 0), shaderName);
					}
				}
			case 'removeSpriteShader':
				final target = resolveObjectPath(aStr(args, 0));
				if (Std.isOfType(target, FlxSprite))
				{
					cast(target, FlxSprite).shader = null;
					shaderNames.remove(aStr(args, 0));
				}
			case 'setCameraShader':
				final game = PlayState.instance;
				final camera = cameraByName(aStr(args, 0));
				if (game != null && camera != null)
				{
					final shader = game.createRuntimeShader(aStr(args, 1));
					if (shader != null) camera.setFilters([new openfl.filters.ShaderFilter(shader)]);
				}
			case 'removeCameraShader':
				final camera = cameraByName(aStr(args, 0));
				if (camera != null) camera.setFilters([]);
			case 'setShaderBool':
				final shader = runtimeShaderFor(aStr(args, 0));
				if (shader != null) shader.setBool(aStr(args, 1), aBool(args, 2, false));
				mirrorShader(aStr(args, 0), aStr(args, 1), aBool(args, 2, false));
			case 'setShaderBoolArray':
				final values:Array<Dynamic> = Std.isOfType(args.length > 2 ? args[2] : null, Array) ? cast args[2] : [];
				final shader = runtimeShaderFor(aStr(args, 0));
				if (shader != null) shader.setBoolArray(aStr(args, 1), values);
				mirrorShader(aStr(args, 0), aStr(args, 1), values);
			case 'setShaderInt':
				final shader = runtimeShaderFor(aStr(args, 0));
				if (shader != null) shader.setInt(aStr(args, 1), aInt(args, 2));
				mirrorShader(aStr(args, 0), aStr(args, 1), aInt(args, 2));
			case 'setShaderIntArray':
				final values:Array<Dynamic> = Std.isOfType(args.length > 2 ? args[2] : null, Array) ? cast args[2] : [];
				final shader = runtimeShaderFor(aStr(args, 0));
				if (shader != null) shader.setIntArray(aStr(args, 1), values);
				mirrorShader(aStr(args, 0), aStr(args, 1), values);
			case 'setShaderFloat':
				final shader = runtimeShaderFor(aStr(args, 0));
				if (shader != null) shader.setFloat(aStr(args, 1), aNum(args, 2));
				mirrorShader(aStr(args, 0), aStr(args, 1), aNum(args, 2));
			case 'setShaderFloatArray':
				final values:Array<Dynamic> = Std.isOfType(args.length > 2 ? args[2] : null, Array) ? cast args[2] : [];
				setShaderValueArray(aStr(args, 0), aStr(args, 1), values);
			case 'setShaderSampler2D':
				final shader = runtimeShaderFor(aStr(args, 0));
				final graphic = Paths.image(aStr(args, 2));
				if (shader != null && graphic != null) shader.setSampler2D(aStr(args, 1), graphic.bitmap);
			case 'setShaderColor':
				setShaderValueArray(aStr(args, 0), aStr(args, 1), [aNum(args, 2), aNum(args, 3), aNum(args, 4), aNum(args, 5, 1)]);
			case 'setShaderVec2':
				setShaderValueArray(aStr(args, 0), aStr(args, 1), [aNum(args, 2), aNum(args, 3)]);
			case 'setShaderVec3':
				setShaderValueArray(aStr(args, 0), aStr(args, 1), [aNum(args, 2), aNum(args, 3), aNum(args, 4)]);
			case 'setShaderVec4':
				setShaderValueArray(aStr(args, 0), aStr(args, 1), [aNum(args, 2), aNum(args, 3), aNum(args, 4), aNum(args, 5)]);
			case 'setShaderTime':
				final shader = runtimeShaderFor(aStr(args, 0));
				if (shader != null) shader.setFloat(aStr(args, 1), aNum(args, 2));
				mirrorShader(aStr(args, 0), aStr(args, 1), aNum(args, 2));
			case 'setShaderTimeScale':
				final autoEntry:Dynamic = shaderAuto.get(aStr(args, 0));
				if (autoEntry != null) autoEntry.scale = aNum(args, 2, 1);
				mirrorShader(aStr(args, 0), aStr(args, 1), aNum(args, 2, 1));
			case 'setShaderAutoTime':
				shaderAuto.set(aStr(args, 0), {prop: aStr(args, 1), scale: 1.0});
				mirrorShader(aStr(args, 0), aStr(args, 1), aBool(args, 2, true));
			case 'clearModShaders':
				if (PlayState.instance != null) PlayState.instance.runtimeShaders.clear();
				shaderUniforms = new Map<String, Map<String, Dynamic>>();
				shaderNames = new Map<String, String>();
			case 'close':
				close();
			case 'setDebugMode':
				debugMode = aBool(args, 0, false);
			case 'hideVanillaWeeks', 'showVanillaWeeks', 'setVanillaWeeksHidden':
				final hidden:Bool = tag == 'hideVanillaWeeks' ? true : (tag == 'showVanillaWeeks' ? false : aBool(args, 0, true));
				setVanillaWeeksHidden(hidden);
			case 'freeplaySetSongPage':
				if (Std.isOfType(FlxG.state, FreeplayState)) cast(FlxG.state, FreeplayState).setSongPage(aStr(args, 0), aStr(args, 1, ''));
			case 'freeplaySetSongURL':
				if (Std.isOfType(FlxG.state, FreeplayState)) cast(FlxG.state, FreeplayState).setSongURL(aStr(args, 0), aStr(args, 1, ''));

			default:
				return false;
		}
		return true;
	}

	public function addJSScriptAt(path:String):Bool
	{
		if (path == null || !FileSystem.exists(path)) return false;
		try
		{
			new FunkinJS(path, host);
			return true;
		}
		catch (e:Dynamic)
		{
			scriptError('addJSScript: ' + e);
			return false;
		}
	}

	public function removeJSScriptNamed(name:String):Void
	{
		final running:Array<FunkinJS> = scriptsHost.copy();
		for (script in running)
			if (script.scriptFile == name || script.scriptName == name) script.close();
	}

	public function callScriptFunction(file:String, func:String, args:Array<Dynamic>):Void
	{
		var script:FunkinJS = findScript(file);
		if (script == null) script = findRunningScript(file);
		if (script == null || !script.hasFunction(func)) return;
		script.call(func, args == null ? [] : args);
	}

	public function setSharedVar(name:String, value:Dynamic):Void
	{
		if (name == null || name.length == 0) return;
		MusicBeatState.getVariables().set(name, value);
	}

	public function callOnAllScripts(func:String, args:Array<Dynamic>):Void
	{
		if (func == null || func.length == 0) return;
		final running:Array<FunkinJS> = scriptsHost.copy();
		for (script in running)
			if (script.isAlive() && script.hasFunction(func)) script.call(func, args == null ? [] : args);
	}

	public function loadSongByName(name:String, difficulty:Int):Void
	{
		if (name == null || name.length == 0) return;
		try
		{
			final songKey:String = Paths.formatToSongPath(name);
			Song.loadFromJson(songKey, songKey);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = difficulty;
			LoadingState.prepareToSong();
			LoadingState.loadAndSwitchState(new PlayState());
		}
		catch (e:Dynamic)
			scriptError('loadSong: ' + e);
	}

	public function regenerateApiDocsFile(path:String):Int
	{
		try
		{
			final target:String = (path == null || path.length == 0) ? 'api_docs.json' : path;
			createFoldersFor(target);
			File.saveContent(target, backend.ApiDocs.docs());
			return 1;
		}
		catch (e:Dynamic)
		{
			scriptError('regenerateApiDocs: ' + e);
			return 0;
		}
	}

	static var menuReplacements:Map<String, Dynamic> = new Map<String, Dynamic>();
	static var menuAttachments:Map<String, Dynamic> = new Map<String, Dynamic>();
	static var menuDraggables:Map<String, Dynamic> = new Map<String, Dynamic>();
	static var dragTag:String = null;
	static var dragStartX:Float = 0;
	static var dragStartY:Float = 0;
	static var dragDX:Float = 0;
	static var dragDY:Float = 0;
	static var gestureConfig:Dynamic = {swipePx: 40.0, dragPx: 8.0, maxSwipe: 0.9, longPress: 0.55};
	static var gestureState:Dynamic = {down: false, x: 0.0, y: 0.0, dx: 0.0, dy: 0.0, swipe: ''};
	static var gestureDownTime:Float = 0;
	static var gestureLongFired:Bool = false;
	static var iconOverlays:Map<String, Dynamic> = new Map<String, Dynamic>();
	static var shaderUniforms:Map<String, Map<String, Dynamic>> = new Map<String, Map<String, Dynamic>>();
	static var shaderNames:Map<String, String> = new Map<String, String>();
	static var shaderAuto:Map<String, Dynamic> = new Map<String, Dynamic>();
	static var shaderClock:Float = 0;
	static var vanillaWeeksHidden:Bool = false;
	static var debugMode:Bool = false;

	function setVanillaWeeksHidden(hidden:Bool):Void
	{
		vanillaWeeksHidden = hidden;
		final weeks:Array<String> = WeekData.weeksList.copy();
		for (week in weeks)
		{
			final path:String = Paths.getSharedPath('weeks/' + week + '.json');
			if (FileSystem.exists(path)) WeekData.setWeekHidden(week, hidden);
		}
		WeekData.applyWeekVisibility();
	}

	function mirrorShader(obj:String, prop:String, value:Dynamic):Void
	{
		var values:Map<String, Dynamic> = shaderUniforms.get(obj);
		if (values == null)
		{
			values = new Map<String, Dynamic>();
			shaderUniforms.set(obj, values);
		}
		values.set(prop, value);
	}

	function runtimeShaderFor(objPath:String):Dynamic
	{
		final target:Dynamic = resolveObjectPath(objPath);
		if (Std.isOfType(target, FlxSprite))
		{
			final shader:Dynamic = cast(target, FlxSprite).shader;
			if (Std.isOfType(shader, flixel.addons.display.FlxRuntimeShader)) return shader;
		}
		return null;
	}

	function cameraByName(name:String):FlxCamera
	{
		if (PlayState.instance == null) return null;
		switch ((name == null ? 'game' : name).toLowerCase())
		{
			case 'hud', 'camhud': return PlayState.instance.camHUD;
			case 'other', 'camother': return PlayState.instance.camOther;
			default: return PlayState.instance.camGame;
		}
	}

	function setShaderValueArray(obj:String, prop:String, values:Array<Dynamic>):Void
	{
		final shader = runtimeShaderFor(obj);
		final floats:Array<Float> = [];
		for (value in values) floats.push(cast(value, Float));
		if (shader != null) shader.setFloatArray(prop, floats);
		mirrorShader(obj, prop, floats);
	}

	function freeplayIconBase(index:Int):Dynamic
	{
		if (!Std.isOfType(FlxG.state, FreeplayState)) return null;
		@:privateAccess
		{
			final fp:FreeplayState = cast FlxG.state;
			return (index >= 0 && index < fp.iconArray.length) ? fp.iconArray[index] : null;
		}
	}

	function storyIconBase(slot:Int):Dynamic
	{
		if (!Std.isOfType(FlxG.state, StoryMenuState)) return null;
		@:privateAccess
		{
			final sm:StoryMenuState = cast FlxG.state;
			return (slot >= 0 && slot < sm.grpWeekCharacters.length) ? sm.grpWeekCharacters.members[slot] : null;
		}
	}

	function makeIconOverlay(key:String, base:Dynamic, ox:Float, oy:Float, ?sprite:FlxSprite):Void
	{
		if (base == null || sprite == null) return;
		final old:Dynamic = iconOverlays.get(key);
		if (old != null)
		{
			final oldSprite:FlxSprite = old.sprite;
			if (oldSprite != null)
			{
				FlxG.state.remove(oldSprite, true);
				oldSprite.destroy();
			}
			if (old.base != null) old.base.visible = true;
		}
		sprite.x = base.x + ox;
		sprite.y = base.y + oy;
		sprite.cameras = base.cameras;
		sprite.scrollFactor.copyFrom(base.scrollFactor);
		sprite.antialiasing = ClientPrefs.data.antialiasing;
		FlxG.state.add(sprite);
		base.visible = false;
		iconOverlays.set(key, {base: base, sprite: sprite, ox: ox, oy: oy, visible: true});
	}

	public function freeplaySetSongIcon(index:Int, image:String, scale:Float, x:Float, y:Float):Void
	{
		final base:Dynamic = freeplayIconBase(index);
		final graphic = Paths.image(image);
		if (base == null || graphic == null) return;
		final sprite:FlxSprite = new FlxSprite();
		sprite.loadGraphic(graphic);
		sprite.scale.set(scale <= 0 ? 1 : scale, scale <= 0 ? 1 : scale);
		sprite.updateHitbox();
		makeIconOverlay('freeplay:' + index, base, x, y, sprite);
	}

	public function freeplaySetSongIconText(index:Int, text:String, size:Int, color:String):Void
	{
		final base:Dynamic = freeplayIconBase(index);
		if (base == null) return;
		final label:FlxText = new FlxText(0, 0, 0, text == null ? '' : text, size <= 0 ? 28 : size);
		label.setFormat(Paths.font('NotoSansSC-Regular.otf'), size <= 0 ? 28 : size, backend.FpsPanelApi.parseColor(color == null ? 'FFFFFF' : color), LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		makeIconOverlay('freeplay:' + index, base, 0, 0, label);
	}

	public function freeplaySetSongIconVisible(index:Int, visible:Bool):Void
	{
		final entry:Dynamic = iconOverlays.get('freeplay:' + index);
		if (entry == null) return;
		entry.visible = visible;
		if (entry.sprite != null) entry.sprite.visible = visible;
		if (entry.base != null) entry.base.visible = visible;
	}

	public function freeplayRestoreSongIcon(index:Int):Void
	{
		restoreIconOverlay('freeplay:' + index);
	}

	public function storySetWeekIcon(slot:Int, image:String, scale:Float, x:Float, y:Float):Void
	{
		final base:Dynamic = storyIconBase(slot);
		final graphic = Paths.image(image);
		if (base == null || graphic == null) return;
		final sprite:FlxSprite = new FlxSprite();
		sprite.loadGraphic(graphic);
		sprite.scale.set(scale <= 0 ? 1 : scale, scale <= 0 ? 1 : scale);
		sprite.updateHitbox();
		makeIconOverlay('story:' + slot, base, x, y, sprite);
	}

	public function storySetWeekIconText(slot:Int, text:String, size:Int, color:String):Void
	{
		final base:Dynamic = storyIconBase(slot);
		if (base == null) return;
		final label:FlxText = new FlxText(0, 0, 0, text == null ? '' : text, size <= 0 ? 40 : size);
		label.setFormat(Paths.font('NotoSansSC-Regular.otf'), size <= 0 ? 40 : size, backend.FpsPanelApi.parseColor(color == null ? 'FFFFFF' : color), LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		makeIconOverlay('story:' + slot, base, 0, 0, label);
	}

	public function storySetWeekIconVisible(slot:Int, visible:Bool):Void
	{
		final entry:Dynamic = iconOverlays.get('story:' + slot);
		if (entry == null) return;
		entry.visible = visible;
		if (entry.sprite != null) entry.sprite.visible = visible;
		if (entry.base != null) entry.base.visible = visible;
	}

	public function storyRestoreWeekIcon(slot:Int):Void
	{
		restoreIconOverlay('story:' + slot);
	}

	function restoreIconOverlay(key:String):Void
	{
		final entry:Dynamic = iconOverlays.get(key);
		if (entry == null) return;
		iconOverlays.remove(key);
		if (entry.sprite != null)
		{
			FlxG.state.remove(entry.sprite, true);
			entry.sprite.destroy();
		}
		if (entry.base != null) entry.base.visible = true;
	}

	public function replaceMenuObject(tag:String, image:String, ox:Float, oy:Float, scale:Float):Void
	{
		final base:Dynamic = MenuScripts.menuObject(tag);
		if (base == null || image == null || image.length == 0) return;
		final graphic = Paths.image(image);
		if (graphic == null) return;

		final sprite:FlxSprite = new FlxSprite(base.x + ox, base.y + oy);
		sprite.loadGraphic(graphic);
		sprite.antialiasing = ClientPrefs.data.antialiasing;
		sprite.scale.set(scale, scale);
		sprite.updateHitbox();
		sprite.x = base.x + ox;
		sprite.y = base.y + oy;
		if (Std.isOfType(base, FlxSprite))
		{
			sprite.cameras = cast(base, FlxSprite).cameras;
			sprite.scrollFactor.copyFrom(cast(base, FlxSprite).scrollFactor);
		}
		FlxG.state.add(sprite);
		MenuScripts.registerObject(tag + '_custom', sprite);
		base.visible = false;
		menuReplacements.set(tag, {tag: tag + '_custom', sprite: sprite, ox: ox, oy: oy, source: tag});
	}

	public function replaceMenuObjectText(tag:String, text:String, size:Int, color:String):Void
	{
		final base:Dynamic = MenuScripts.menuObject(tag);
		if (base == null) return;

		final label:FlxText = new FlxText(base.x, base.y, 0, text == null ? '' : text, size <= 0 ? 32 : size);
		label.setFormat(Paths.font('NotoSansSC-Regular.otf'), size <= 0 ? 32 : size, backend.FpsPanelApi.parseColor(color == null ? 'FFFFFF' : color), LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		label.scrollFactor.set();
		if (Std.isOfType(base, FlxSprite)) label.cameras = cast(base, FlxSprite).cameras;
		FlxG.state.add(label);
		MenuScripts.registerObject(tag + '_custom', label);
		base.visible = false;
		menuReplacements.set(tag, {tag: tag + '_custom', sprite: label, ox: 0.0, oy: 0.0, source: tag});
	}

	public function restoreMenuObject(tag:String):Void
	{
		final entry:Dynamic = menuReplacements.get(tag);
		if (entry == null) return;
		menuReplacements.remove(tag);
		final sprite:FlxSprite = entry.sprite;
		if (sprite != null)
		{
			MenuScripts.objects.remove(entry.tag);
			FlxG.state.remove(sprite, true);
			sprite.destroy();
		}
		final base:FlxBasic = MenuScripts.menuObject(entry.source);
		if (base != null) base.visible = true;
	}

	public function attachMenuObject(tag:String, target:String, ox:Float, oy:Float, followVisible:Bool):Void
	{
		menuAttachments.set(tag, {target: target, ox: ox, oy: oy, followVisible: followVisible});
	}

	public function detachMenuObject(tag:String):Void
	{
		menuAttachments.remove(tag);
	}

	public function setMenuObjectDraggable(tag:String, enabled:Bool, callback:String, minX:Float, minY:Float, maxX:Float, maxY:Float):Void
	{
		if (enabled)
			menuDraggables.set(tag, {callback: callback, minX: minX, minY: minY, maxX: maxX, maxY: maxY});
		else
		{
			menuDraggables.remove(tag);
			if (dragTag == tag) dragTag = null;
		}
	}

	public function setMenuGestureConfig(swipePx:Float, dragPx:Float, maxSwipe:Float, longPress:Float):Void
	{
		gestureConfig.swipePx = swipePx;
		gestureConfig.dragPx = dragPx;
		gestureConfig.maxSwipe = maxSwipe;
		gestureConfig.longPress = longPress;
	}

	public function stopMenuDrag():Void
	{
		dragTag = null;
		dragDX = 0;
		dragDY = 0;
	}

	static function findDraggableAt(x:Float, y:Float):String
	{
		var found:String = null;
		for (tag in menuDraggables.keys())
		{
			final obj:FlxBasic = MenuScripts.menuObject(tag);
			if (!Std.isOfType(obj, FlxSprite)) continue;
			final sprite:FlxSprite = cast obj;
			if (!sprite.visible || !sprite.exists) continue;
			if (x >= sprite.x && x <= sprite.x + sprite.width && y >= sprite.y && y <= sprite.y + sprite.height)
				found = tag;
		}
		return found;
	}

	public static function updateMenuExtras(elapsed:Float):Void
	{
		for (tag in menuReplacements.keys())
		{
			final entry:Dynamic = menuReplacements.get(tag);
			final sprite:FlxSprite = entry.sprite;
			if (sprite == null || !sprite.exists)
			{
				menuReplacements.remove(tag);
				continue;
			}
			final base:Dynamic = MenuScripts.menuObject(entry.source);
			if (base == null) continue;
			sprite.x = base.x + entry.ox;
			sprite.y = base.y + entry.oy;
			sprite.visible = base.visible;
		}

		for (tag in menuAttachments.keys())
		{
			final entry:Dynamic = menuAttachments.get(tag);
			final obj:Dynamic = MenuScripts.menuObject(tag);
			final target:Dynamic = MenuScripts.menuObject(entry.target);
			if (obj == null || target == null) continue;
			obj.x = target.x + entry.ox;
			obj.y = target.y + entry.oy;
			if (entry.followVisible) obj.visible = target.visible;
		}

		for (key in iconOverlays.keys())
		{
			final entry:Dynamic = iconOverlays.get(key);
			final sprite:FlxSprite = entry.sprite;
			if (sprite == null || !sprite.exists)
			{
				iconOverlays.remove(key);
				continue;
			}
			final base:Dynamic = entry.base;
			if (base == null) continue;
			sprite.x = base.x + entry.ox;
			sprite.y = base.y + entry.oy;
			sprite.visible = entry.visible;
		}

		final mouse = FlxG.mouse;
		if (mouse == null) return;

		if (mouse.justPressed)
		{
			gestureState.down = true;
			gestureState.x = mouse.x;
			gestureState.y = mouse.y;
			gestureState.dx = 0;
			gestureState.dy = 0;
			gestureState.swipe = '';
			gestureDownTime = 0;
			gestureLongFired = false;
			dragTag = findDraggableAt(mouse.x, mouse.y);
			if (dragTag != null)
			{
				final obj:Dynamic = MenuScripts.menuObject(dragTag);
				if (obj != null)
				{
					dragStartX = obj.x;
					dragStartY = obj.y;
				}
				dragDX = 0;
				dragDY = 0;
			}
		}

		if (gestureState.down)
		{
			gestureDownTime += elapsed;
			gestureState.dx = mouse.x - gestureState.x;
			gestureState.dy = mouse.y - gestureState.y;

			if (dragTag != null)
			{
				final obj:Dynamic = MenuScripts.menuObject(dragTag);
				final info:Dynamic = menuDraggables.get(dragTag);
				if (obj != null && info != null)
				{
					dragDX = gestureState.dx;
					dragDY = gestureState.dy;
					var nx:Float = dragStartX + dragDX;
					var ny:Float = dragStartY + dragDY;
					if (info.maxX > info.minX) nx = FlxMath.bound(nx, info.minX, info.maxX);
					if (info.maxY > info.minY) ny = FlxMath.bound(ny, info.minY, info.maxY);
					obj.x = nx;
					obj.y = ny;
				}
			}
			else if (!gestureLongFired && gestureDownTime >= gestureConfig.longPress
				&& Math.abs(gestureState.dx) < gestureConfig.dragPx && Math.abs(gestureState.dy) < gestureConfig.dragPx)
			{
				gestureLongFired = true;
				MenuScripts.call('onMenuLongPress', [gestureState.x, gestureState.y]);
			}
		}

		if (mouse.justReleased && gestureState.down)
		{
			gestureState.down = false;
			if (dragTag != null)
			{
				final info:Dynamic = menuDraggables.get(dragTag);
				final obj:Dynamic = MenuScripts.menuObject(dragTag);
				final cb:String = info == null ? null : info.callback;
				final tx:Float = obj == null ? 0 : obj.x;
				final ty:Float = obj == null ? 0 : obj.y;
				final movedDX:Float = dragDX;
				final movedDY:Float = dragDY;
				final movedTag:String = dragTag;
				dragTag = null;
				if (cb != null && cb.length > 0) MenuScripts.call(cb, [movedTag, tx, ty, movedDX, movedDY]);
			}
			else if (!gestureLongFired)
			{
				final dist:Float = Math.sqrt(gestureState.dx * gestureState.dx + gestureState.dy * gestureState.dy);
				if (dist >= gestureConfig.swipePx)
				{
					var dir:String = '';
					if (Math.abs(gestureState.dx) >= Math.abs(gestureState.dy))
						dir = gestureState.dx >= 0 ? 'right' : 'left';
					else
						dir = gestureState.dy >= 0 ? 'down' : 'up';
					gestureState.swipe = dir;
					MenuScripts.call('onMenuSwipe', [dir, gestureState.x, gestureState.y, gestureState.dx, gestureState.dy]);
				}
				else
					MenuScripts.call('onMenuTap', [gestureState.x, gestureState.y]);
			}
		}
	}

	function setMenuTagVisible(tag:String, visible:Bool):Void
	{
		final obj = MenuScripts.menuObject(tag);
		if (obj != null && Std.isOfType(obj, FlxSprite))
			cast(obj, FlxSprite).visible = visible;
	}

	function dropMenuObject(tag:String):Void
	{
		final obj = MenuScripts.menuObject(tag);
		if (obj == null) return;
		MenuScripts.objects.remove(tag);
		if (obj != null)
		{
			FlxG.state.remove(obj, true);
			obj.destroy();
		}
	}
}
