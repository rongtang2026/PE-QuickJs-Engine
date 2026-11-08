package backend;

import openfl.utils.Assets;
import haxe.Json;
import backend.Song;
import psychlua.ModchartSprite;

typedef StageFile = {
	var directory:String;
	var defaultZoom:Float;
	@:optional var isPixelStage:Null<Bool>;
	var stageUI:String;

	var boyfriend:Array<Dynamic>;
	var girlfriend:Array<Dynamic>;
	var opponent:Array<Dynamic>;
	var hide_girlfriend:Bool;

	var camera_boyfriend:Array<Float>;
	var camera_opponent:Array<Float>;
	var camera_girlfriend:Array<Float>;
	var camera_speed:Null<Float>;

	@:optional var preload:Dynamic;
	@:optional var objects:Array<Dynamic>;
	@:optional var _editorMeta:Dynamic;
}

enum abstract LoadFilters(Int) from Int from UInt to Int to UInt
{
	var LOW_QUALITY:Int = (1 << 0);
	var HIGH_QUALITY:Int = (1 << 1);

	var STORY_MODE:Int = (1 << 2);
	var FREEPLAY:Int = (1 << 3);
}

class StageData {
	public static var forceNextDirectory:String = null;
	public static var reservedNames:Array<String> = ['gf', 'gfGroup', 'dad', 'dadGroup', 'boyfriend', 'boyfriendGroup']; //blocks these names from being used on stage editor's name input text
	public static function dummy():StageFile
	{
		return {
			directory: "",
			defaultZoom: 0.9,
			stageUI: "normal",

			boyfriend: [770, 100],
			girlfriend: [400, 130],
			opponent: [100, 100],
			hide_girlfriend: false,

			camera_boyfriend: [0, 0],
			camera_opponent: [0, 0],
			camera_girlfriend: [0, 0],
			camera_speed: 1,

			_editorMeta: {
				gf: "gf",
				dad: "dad",
				boyfriend: "bf"
			}
		};
	}

	public static function loadDirectory(SONG:SwagSong) {
		var stage:String = '';
		if(SONG.stage != null)
			stage = SONG.stage;
		else if(Song.loadedSongName != null)
			stage = vanillaSongStage(Paths.formatToSongPath(Song.loadedSongName));
		else
			stage = 'stage';

		var stageFile:StageFile = getStageFile(stage);
		forceNextDirectory = (stageFile != null) ? stageFile.directory : ''; //preventing crashes
	}

	public static function getStageFile(stage:String):StageFile {
		try
		{
			var path:String = Paths.getPath('stages/' + stage + '.json', TEXT, null, true);
			#if MODS_ALLOWED
			if(FileSystem.exists(path))
				return cast tjson.TJSON.parse(File.getContent(path));
			#else
			if(Assets.exists(path))
				return cast tjson.TJSON.parse(Assets.getText(path));
			#end
		}
		return dummy();
	}

	public static function vanillaSongStage(songName):String
	{
		switch (songName)
		{
			case 'spookeez' | 'south' | 'monster':
				return 'spooky';
			case 'pico' | 'blammed' | 'philly' | 'philly-nice':
				return 'philly';
			case 'milf' | 'satin-panties' | 'high':
				return 'limo';
			case 'cocoa' | 'eggnog':
				return 'mall';
			case 'winter-horrorland':
				return 'mallEvil';
			case 'senpai' | 'roses':
				return 'school';
			case 'thorns':
				return 'schoolEvil';
			case 'ugh' | 'guns' | 'stress':
				return 'tank';
		}
		return 'stage';
	}

	public static function addObjectsToState(objectList:Array<Dynamic>, gf:FlxSprite, dad:FlxSprite, boyfriend:FlxSprite, ?group:Dynamic = null, ?ignoreFilters:Bool = false)
	{
		var addedObjects:Map<String, FlxSprite> = [];
		for (num => data in objectList)
		{
			if (addedObjects.exists(data)) continue;

			switch(data.type)
			{
				case 'gf', 'gfGroup':
					if(gf != null)
					{
						gf.ID = num; 
						if (group != null) group.add(gf);
						addedObjects.set('gf', gf);
					}
				case 'dad', 'dadGroup':
					if(dad != null)
					{
						dad.ID = num;
						if (group != null) group.add(dad);
						addedObjects.set('dad', dad);
					}
				case 'boyfriend', 'boyfriendGroup':
					if(boyfriend != null)
					{
						boyfriend.ID = num;
						if (group != null) group.add(boyfriend);
						addedObjects.set('boyfriend', boyfriend);
					}

				case 'square', 'sprite', 'animatedSprite':
					if(!ignoreFilters && !validateVisibility(data.filters)) continue;

					var spr:ModchartSprite = new ModchartSprite(data.x, data.y);
					spr.ID = num;
					if(data.type != 'square')
					{
						if(data.type == 'sprite')
							spr.loadGraphic(Paths.image(data.image));
						else
							spr.frames = Paths.getAtlas(data.image);
						
						if(data.type == 'animatedSprite' && data.animations != null)
						{
							var anims:Array<objects.Character.AnimArray> = cast data.animations;
							for (key => anim in anims)
							{
								if(anim.indices == null || anim.indices.length < 1)
									spr.animation.addByPrefix(anim.anim, anim.name, anim.fps, anim.loop);
								else
									spr.animation.addByIndices(anim.anim, anim.name, anim.indices, '', anim.fps, anim.loop);
	
								if(anim.offsets != null)
									spr.addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
	
								if(spr.animation.curAnim == null || data.firstAnimation == anim.anim)
									spr.playAnim(anim.anim, true);
							}
						}
						for (varName in ['antialiasing', 'flipX', 'flipY'])
						{
							var dat:Dynamic = Reflect.getProperty(data, varName);
							if(dat != null) Reflect.setProperty(spr, varName, dat);
						}
						if(!ClientPrefs.data.antialiasing) spr.antialiasing = false;
					}
					else
					{
						spr.makeGraphic(1, 1, FlxColor.WHITE);
						spr.antialiasing = false;
					}

					if(data.scale != null && (data.scale[0] != 1.0 || data.scale[1] != 1.0))
					{
						spr.scale.set(data.scale[0], data.scale[1]);
						spr.updateHitbox();
					}
					spr.scrollFactor.set(data.scroll[0], data.scroll[1]);
					spr.color = CoolUtil.colorFromString(data.color);
					
					for (varName in ['alpha', 'angle'])
					{
						var dat:Dynamic = Reflect.getProperty(data, varName);
						if(dat != null) Reflect.setProperty(spr, varName, dat);
					}

					if (group != null) group.add(spr);
					addedObjects.set(data.name, spr);

				default:
					var err = '[Stage .JSON file] Unknown sprite type detected: ${data.type}';
					trace(err);
					FlxG.log.error(err);
			}
		}
		return addedObjects;
	}

	public static function validateVisibility(filters:LoadFilters)
	{
		if((filters & STORY_MODE) == STORY_MODE)
			if(!PlayState.isStoryMode) return false;
		else if((filters & FREEPLAY) == FREEPLAY)
			if(PlayState.isStoryMode) return false;

		return ((ClientPrefs.data.lowQuality && (filters & LOW_QUALITY) == LOW_QUALITY) ||
			(!ClientPrefs.data.lowQuality && (filters & HIGH_QUALITY) == HIGH_QUALITY));
	}

	public function addObject(data:Dynamic, ?group:Dynamic = null):FlxSprite
	{
		if (data == null || data.name == null) return null;
		var map:Map<String, FlxSprite> = cast StageData.addObjectsToState([data], null, null, null, group, true);
		return map == null ? null : map.get(data.name);
	}

	/**
		Reads a camera offset array [x, y] from stage object data (0 when absent).
	**/
	public function cameraOffset(data:Dynamic, ?which:Int = 0):Float
	{
		if (data == null) return 0;
		var offset:Dynamic = Reflect.field(data, 'cameraOffset');
		if (offset == null) return 0;
		return number(offset[which]);
	}

	public function isNumber(value:Dynamic):Bool
	{
		return Std.isOfType(value, Int) || Std.isOfType(value, Float);
	}

	/**
		Wraps Paths.getAtlas with a null-safe fallback (logs and returns null
		when the image is missing instead of crashing the stage load).
	**/
	public function loadAtlas(image:String):Dynamic
	{
		if (image == null) return null;
		var frames:Dynamic = Paths.getAtlas(image);
		if (frames == null) warn('missing atlas image ' + image);
		return frames;
	}

	public function loadGraphic(image:String):Dynamic
	{
		if (image == null) return null;
		var graphic:Dynamic = Paths.image(image);
		if (graphic == null) warn('missing graphic ' + image);
		return graphic;
	}

	/**
		Safely reads a number from Dynamic data: numbers pass through, numeric
		strings are parsed, everything else falls back.
	**/
	public function number(value:Dynamic, ?fallback:Float = 0):Float
	{
		if (isNumber(value)) return value;
		if (Std.isOfType(value, String))
		{
			var parsed:Null<Float> = Std.parseFloat(value);
			if (parsed != null && !Math.isNaN(parsed)) return parsed;
		}
		return fallback;
	}

	/**
		Reads the object name from stage object data (empty string when absent).
	**/
	public function objectName(data:Dynamic):String
	{
		if (data == null) return '';
		var name:Dynamic = Reflect.field(data, 'name');
		return name == null ? '' : Std.string(name);
	}

	/**
		Builds a magenta placeholder sprite for missing stage objects.
	**/
	public function placeholder(?x:Float = 0, ?y:Float = 0, ?width:Float = 100, ?height:Float = 100):FlxSprite
	{
		var spr:FlxSprite = new FlxSprite(x, y);
		spr.makeGraphic(Std.int(Math.max(1, width)), Std.int(Math.max(1, height)), 0xFFFF00FF);
		spr.antialiasing = false;
		return spr;
	}

	/**
		Reads the object position array [x, y] from stage object data
		(falls back to the x/y fields, 0 when neither exists).
	**/
	public function position(data:Dynamic, ?index:Int = 0):Float
	{
		if (data == null) return 0;
		var pos:Dynamic = Reflect.field(data, 'position');
		if (pos != null && pos.length > index) return number(pos[index]);
		var field:String = index == 0 ? 'x' : 'y';
		return number(Reflect.field(data, field));
	}

	/**
		Repairs a stage .json text: validates it and strips trailing commas
		(the most common hand-edit error), mirroring WeekData.repairWeekFile.
		Returns the repaired text, or the original when nothing works.
	**/
	public function repairStageFile(content:String):String
	{
		if (content == null) return content;
		try
		{
			haxe.Json.parse(content);
			return content; // already valid
		}
		catch (e:Dynamic) {}
		var fixed:String = new EReg(",\\s*([}\\]])", "g").replace(content, '$1');
		try
		{
			haxe.Json.parse(fixed);
			return fixed;
		}
		catch (e:Dynamic) {}
		return content;
	}

	public function warn(message:Dynamic):Void
	{
		trace('[StageData] ' + message);
		FlxG.log.warn('[StageData] ' + message);
	}
}
