package mobile;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import flixel.input.FlxInput.FlxInputState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.filters.DropShadowFilter;

/**
	Configurable piano-key strip UI: a row of keys with per-key art, colors,
	labels and input state, laid out along one screen edge. Keys can carry a
	gameplay action (synced into the MobileInput bus) and a keyboard bind, so
	the strip doubles as an on-screen input device. Behavior is driven by a
	Dynamic config through applyConfig().
**/
class PianoKeys
{
	public static var instance:PianoKeys = null;

	// strip layout state
	var left:Float = 0;
	var top:Float = 0;
	var height:Float = 120;
	var gap:Float = 4;
	var margin:Float = 8;
	var alpha:Float = 1;
	var artAlpha:Float = 1;
	var anchor:String = 'bottom-left';
	var enabled:Bool = true;
	var scriptEnabled:Bool = true;
	var visible:Bool = true;

	// art / background state
	var artImage:String = '';
	var artAtlas:String = '';
	var artFrames:Dynamic = null;
	var colorRGB:String = 'FFFFFF';
	var colorAlpha:Float = 0;
	var padAlpha:Float = 0.6;
	var padHeight:Float = 120;

	// runtime
	var keys:Array<PianoKey> = [];
	var group:FlxSpriteGroup = null;
	var backdrop:FlxSprite = null;
	var lastWidth:Float = 0;
	var lastHeight:Float = 0;
	var pressTick:Int = 0;
	var tickCounter:Int = 0;

	/**
		Called when a key goes down (programmatic presses included).
	**/
	public dynamic function onKeyDown(key:String):Void {}

	/**
		Called when a key goes up.
	**/
	public dynamic function onKeyUp(key:String):Void {}

	public function new()
	{
		if (instance == null) instance = this;
	}

	public static function boot():PianoKeys
	{
		if (instance == null) instance = new PianoKeys();
		return instance;
	}

	// ---------------------------------------------------------------- config coercion helpers

	function field(cfg:Dynamic, name:String):Dynamic
	{
		if (cfg == null || name == null) return null;
		return Reflect.field(cfg, name);
	}

	function num(value:Dynamic, ?fallback:Float = 0):Float
	{
		if (value == null) return fallback;
		if (Std.isOfType(value, Int) || Std.isOfType(value, Float)) return value;
		if (Std.isOfType(value, String))
		{
			var parsed:Null<Float> = Std.parseFloat(value);
			if (parsed != null && !Math.isNaN(parsed)) return parsed;
		}
		return fallback;
	}

	function str(value:Dynamic, ?fallback:String = ''):String
	{
		return value == null ? fallback : Std.string(value);
	}

	function bool(value:Dynamic, ?fallback:Bool = false):Bool
	{
		if (value == null) return fallback;
		if (Std.isOfType(value, Bool)) return value;
		if (Std.isOfType(value, String)) return value.toLowerCase() == 'true';
		if (Std.isOfType(value, Int) || Std.isOfType(value, Float)) return value != 0;
		return fallback;
	}

	/**
		Parses '#RGB', '#RRGGBB', '0xRRGGBB[AA]' and 'AARRGGBB' colors (null on failure).
	**/
	public static function parseColor(value:Dynamic):Null<FlxColor>
	{
		return parseHexColor(value);
	}

	public static function parseHexColor(value:Dynamic):Null<FlxColor>
	{
		if (value == null) return null;
		if (Std.isOfType(value, Int) || Std.isOfType(value, Float)) return cast Std.int(value);
		var s:String = Std.string(value).trim();
		if (s.length == 0) return null;
		if (s.charAt(0) == '#') s = s.substr(1);
		if (s.length >= 2 && s.substr(0, 2).toLowerCase() == '0x') s = s.substr(2);
		if (s.length != 6 && s.length != 8) return null;
		var v:Null<Int> = Std.parseInt('0x' + s);
		if (v == null) return null;
		return s.length == 6 ? (0xFF000000 | v) : v;
	}

	/**
		Returns the path when it resolves to a real asset, otherwise an empty string.
	**/
	public function safeImage(path:String):String
	{
		if (path == null || path.length == 0) return '';
		if (openfl.Assets.exists(path, openfl.utils.AssetType.IMAGE)) return path;
		if (sys.FileSystem.exists(path)) return path;
		return '';
	}

	/**
		Loads shared key art: sparrow atlas when one exists next to the path,
		plain image otherwise. Returns true when something loaded.
	**/
	public function loadArt(path:String):Bool
	{
		if (path == null || path.length == 0) return false;
		var frames:Dynamic = Paths.getSparrowAtlas(path);
		if (frames != null && frames.frames != null && Lambda.count(frames.frames) > 0)
		{
			artFrames = frames;
			artAtlas = path;
			artImage = '';
			return true;
		}
		var graphic:Dynamic = Paths.image(path);
		if (graphic != null)
		{
			artFrames = null;
			artAtlas = '';
			artImage = path;
			return true;
		}
		return false;
	}

	/**
		Sets the shared key art and refreshes every key visual.
	**/
	public function setArt(path:String):Bool
	{
		if (!loadArt(path)) return false;
		refreshVisual();
		return true;
	}

	// ---------------------------------------------------------------- creation

	/**
		Creates the strip: optionally applies a config object, builds the
		visuals and returns this instance.
	**/
	public function create(?cfg:Dynamic = null):PianoKeys
	{
		applyConfig(cfg);
		refreshVisual();
		ensureCamera();
		return this;
	}

	/**
		Adds an existing PianoKey to the strip.
	**/
	public function addKey(key:PianoKey):PianoKey
	{
		if (key == null) return null;
		if (!keys.contains(key)) keys.push(key);
		return key;
	}

	/**
		Creates a key (and adds it): tag, optional label and width/height.
	**/
	public function createKey(tag:String, ?label:String = null, ?width:Float = 56, ?keyHeight:Float = 0):PianoKey
	{
		var key:PianoKey = new PianoKey(tag);
		key.label = label == null ? tag : label;
		key.width = width;
		key.keyHeight = keyHeight > 0 ? keyHeight : height;
		addKey(key);
		relayoutKey(tag);
		return key;
	}

	public function removeKey(tag:String):Bool
	{
		var key:PianoKey = findKey(tag);
		if (key == null) return false;
		destroyKeyVisual(key);
		keys.remove(key);
		relayout();
		return true;
	}

	public function clearKeys():Void
	{
		for (key in keys)
			destroyKeyVisual(key);
		keys.resize(0);
		relayout();
	}

	public function destroyKey(tag:String):Bool
	{
		return removeKey(tag);
	}

	/**
		Destroys the whole strip visual (keys list survives; call refreshVisual
		to rebuild it).
	**/
	public function destroyStrip():Void
	{
		for (key in keys)
			destroyKeyVisual(key);
		if (backdrop != null)
		{
			backdrop.destroy();
			backdrop = null;
		}
		if (group != null)
		{
			group.destroy();
			group = null;
		}
	}

	public function destroy():Void
	{
		destroyStrip();
		keys.resize(0);
	}

	// ---------------------------------------------------------------- strip config

	public function applyConfig(cfg:Dynamic):Bool
	{
		if (cfg == null) return false;
		if (field(cfg, 'left') != null) left = num(field(cfg, 'left'), left);
		if (field(cfg, 'top') != null) top = num(field(cfg, 'top'), top);
		if (field(cfg, 'height') != null) height = num(field(cfg, 'height'), height);
		if (field(cfg, 'gap') != null) gap = num(field(cfg, 'gap'), gap);
		if (field(cfg, 'margin') != null) margin = num(field(cfg, 'margin'), margin);
		if (field(cfg, 'alpha') != null) alpha = num(field(cfg, 'alpha'), alpha);
		if (field(cfg, 'anchor') != null) anchor = str(field(cfg, 'anchor'), anchor);
		if (field(cfg, 'visible') != null) visible = bool(field(cfg, 'visible'), visible);
		if (field(cfg, 'enabled') != null) enabled = bool(field(cfg, 'enabled'), enabled);
		applyBg(field(cfg, 'bgColor'), field(cfg, 'bgAlpha'));

		var keyList:Dynamic = field(cfg, 'keys');
		if (Std.isOfType(keyList, Array))
		{
			clearKeys();
			for (keyCfg in cast(keyList, Array<Dynamic>))
			{
				var tag:String = str(field(keyCfg, 'tag'));
				if (tag.length == 0) continue;
				createKey(tag, str(field(keyCfg, 'label'), tag));
				applyKeyConfig(tag, keyCfg);
			}
		}
		relayout();
		refreshVisual();
		return true;
	}

	/**
		Per-key config object: {label, color, textColor, textSize, weight,
		width, height, image, action, key, offset:[x,y], enabled}.
	**/
	public function applyKeyConfig(tag:String, cfg:Dynamic):Bool
	{
		var key:PianoKey = findKey(tag);
		if (key == null || cfg == null) return false;
		if (field(cfg, 'label') != null) key.label = str(field(cfg, 'label'), key.label);
		if (field(cfg, 'color') != null) key.color = parseColor(field(cfg, 'color'));
		if (field(cfg, 'textColor') != null) key.textColor = parseColor(field(cfg, 'textColor'));
		if (field(cfg, 'textSize') != null) key.textSize = num(field(cfg, 'textSize'), key.textSize);
		if (field(cfg, 'weight') != null) key.weight = num(field(cfg, 'weight'), key.weight);
		if (field(cfg, 'width') != null) key.width = num(field(cfg, 'width'), key.width);
		if (field(cfg, 'height') != null) key.keyHeight = num(field(cfg, 'height'), key.keyHeight);
		if (field(cfg, 'image') != null) key.image = str(field(cfg, 'image'), key.image);
		if (field(cfg, 'action') != null) key.action = str(field(cfg, 'action'), key.action);
		if (field(cfg, 'key') != null) key.bindKey = FlxKey.fromString(str(field(cfg, 'key')));
		if (field(cfg, 'enabled') != null) key.enabled = bool(field(cfg, 'enabled'), key.enabled);
		var offset:Dynamic = field(cfg, 'offset');
		if (Std.isOfType(offset, Array) && cast(offset, Array<Dynamic>).length >= 2)
		{
			key.offsetX = num(offset[0], key.offsetX);
			key.offsetY = num(offset[1], key.offsetY);
		}
		refreshKeyVisual(key);
		return true;
	}

	/**
		Per-key art override (falls back to the shared strip art).
	**/
	public function applyKeyArt(tag:String, path:String):Bool
	{
		var key:PianoKey = findKey(tag);
		if (key == null) return false;
		key.image = safeImage(path);
		refreshKeyVisual(key);
		return true;
	}

	/**
		Backdrop color/alpha behind the keys (useful when the strip floats
		over gameplay).
	**/
	public function applyBg(?rgb:Dynamic = null, ?bgAlpha:Dynamic = null):Bool
	{
		if (rgb != null)
		{
			var parsed:Null<FlxColor> = parseColor(rgb);
			if (parsed != null) colorRGB = Std.string(parsed.rgb);
		}
		if (bgAlpha != null) colorAlpha = num(bgAlpha, colorAlpha);
		refreshVisual();
		return true;
	}

	// ---------------------------------------------------------------- layout

	public function setStripPosition(x:Float, y:Float):Void
	{
		left = x;
		top = y;
		relayout();
	}

	public function setAnchor(value:String):Void
	{
		anchor = value == null ? anchor : value;
		relayout();
	}

	public function getAnchor():String
	{
		return anchor;
	}

	public function setHeight(value:Float):Void
	{
		height = value > 0 ? value : height;
		relayout();
	}

	public function getHeight():Float
	{
		return height;
	}

	public function setGap(value:Float):Void
	{
		gap = value;
		relayout();
	}

	public function getGap():Float
	{
		return gap;
	}

	public function setMargin(value:Float):Void
	{
		margin = value;
		relayout();
	}

	public function getMargin():Float
	{
		return margin;
	}

	public function getX():Float
	{
		return left;
	}

	public function getY():Float
	{
		return top;
	}

	public function setStripEnabled(value:Bool):Void
	{
		enabled = value;
		for (key in keys)
		{
			key.enabled = value;
			if (key.sprite != null) key.sprite.monitorInputs = value;
		}
	}

	public function getEnabled():Bool
	{
		return enabled;
	}

	public function setVisible(value:Bool):Void
	{
		visible = value;
		if (group != null) group.visible = value;
	}

	public function getVisible():Bool
	{
		return visible;
	}

	public function setAlpha(value:Float):Void
	{
		alpha = value;
		if (group != null) group.alpha = value;
	}

	public function getAlpha():Float
	{
		return alpha;
	}

	public function stripExists():Bool
	{
		return group != null && group.exists;
	}

	/**
		Recomputes every key position from left/top/margin/gap and the anchor.
	**/
	public function relayout():Void
	{
		var anchoredRight:Bool = anchor.indexOf('right') != -1;
		var anchoredTop:Bool = anchor.indexOf('top') != -1;
		var stripTop:Float = anchoredTop ? top : FlxG.height - height - top;

		var x:Float = anchoredRight ? FlxG.width - margin : left + margin;
		for (key in keys)
		{
			key.keyHeight = key.keyHeight > 0 ? key.keyHeight : height;
			key.y = stripTop + (height - key.keyHeight) / 2;
			if (anchoredRight)
			{
				key.x = x - key.width;
				x -= key.width + gap;
			}
			else
			{
				key.x = x;
				x += key.width + gap;
			}
		}
		lastWidth = FlxG.width;
		lastHeight = FlxG.height;
		refreshVisual();
	}

	/**
		Repositions a single key (keys after it shift along the strip).
	**/
	public function relayoutKey(tag:String):Bool
	{
		var key:PianoKey = findKey(tag);
		if (key == null) return false;
		relayout();
		return true;
	}

	/**
		Places an icon sprite on a key (centered), tracking its position.
	**/
	public function placeIcon(tag:String, icon:FlxSprite):Bool
	{
		var key:PianoKey = findKey(tag);
		if (key == null || icon == null) return false;
		key.icon = icon;
		if (group != null && icon.parent != group) group.add(icon);
		centerIcon(key);
		return true;
	}

	function centerIcon(key:PianoKey):Void
	{
		if (key.icon == null) return;
		key.icon.x = key.x + (key.width - key.icon.width) / 2 + key.offsetX;
		key.icon.y = key.y + (key.keyHeight - key.icon.height) / 2 + key.offsetY;
		if (group != null && !group.members.contains(key.icon)) group.add(key.icon);
	}

	// ---------------------------------------------------------------- visuals

	/**
		Rebuilds the strip visuals for every key (and the backdrop).
	**/
	public function refreshVisual():Void
	{
		if (group == null)
		{
			group = new FlxSpriteGroup();
			FlxG.state.add(group);
			group.visible = visible;
			group.alpha = alpha;
		}
		if (backdrop == null)
		{
			backdrop = new FlxSprite();
			group.insert(0, backdrop);
		}
		var minKeyX:Float = FlxG.width;
		var maxKeyX:Float = 0;
		for (key in keys)
		{
			refreshKeyVisual(key);
			if (key.x < minKeyX) minKeyX = key.x;
			if (key.x + key.width > maxKeyX) maxKeyX = key.x + key.width;
		}
		if (keys.length == 0 || colorAlpha <= 0)
		{
			backdrop.visible = false;
		}
		else
		{
			var bg:Null<FlxColor> = parseHexColor(colorRGB);
			backdrop.makeGraphic(Std.int(Math.max(1, maxKeyX - minKeyX)), Std.int(Math.max(1, height)),
				bg == null ? FlxColor.BLACK : bg);
			backdrop.alpha = colorAlpha;
			backdrop.setPosition(minKeyX, top);
			backdrop.visible = true;
		}
	}

	/**
		(Re)builds one key's TouchButton visual from its config.
	**/
	public function refreshKeyVisual(key:PianoKey):Void
	{
		if (group == null) group = new FlxSpriteGroup();
		if (key.sprite == null)
		{
			key.sprite = new TouchButton(key.x, key.y, key.tag, key.label);
			group.add(key.sprite);
		}
		var sprite:TouchButton = key.sprite;
		sprite.setPosition(key.x, key.y);
		var m0:Dynamic = sprite.members.length > 0 ? sprite.members[0] : null;
		var bg:FlxSprite = (m0 != null && Std.isOfType(m0, FlxSprite) && !Std.isOfType(m0, FlxText)) ? cast m0 : null;
		if (bg == null)
		{
			bg = new FlxSprite();
			sprite.insert(0, bg);
		}
		bg.makeGraphic(Std.int(Math.max(1, key.width)), Std.int(Math.max(1, key.keyHeight)),
			key.color == null ? 0x66FFFFFF : key.color);
		bg.alpha = artAlpha;

		sprite.label.setFormat('VCR OSD Mono', Std.int(key.textSize),
			key.textColor == null ? FlxColor.WHITE : key.textColor, CENTER);
		sprite.label.fieldWidth = Std.int(key.width);
		sprite.label.x = 0;
		sprite.label.y = (key.keyHeight - sprite.label.height) / 2;
		sprite.label.borderSize = key.weight;
		sprite.label.borderStyle = key.weight > 0 ? OUTLINE_FAST : NONE;
		sprite.label.borderColor = 0xFF000000;
		sprite.label.text = key.label;
		sprite.monitorInputs = key.enabled;
		sprite.alpha = key.enabled ? 1 : 0.4;
		sprite.visible = visible;
		centerIcon(key);
	}

	function destroyKeyVisual(key:PianoKey):Void
	{
		if (key.sprite != null)
		{
			key.sprite.destroy();
			key.sprite = null;
		}
		if (key.icon != null)
		{
			key.icon.destroy();
			key.icon = null;
		}
	}

	/**
		Press depth feedback: label drop shadow strengthens while held.
	**/
	function pressVisual(key:PianoKey, pressed:Bool):Void
	{
		if (key.sprite == null) return;
		var shadow:DropShadowFilter = cast(key.sprite.label.filters != null && key.sprite.label.filters.length > 0
			? key.sprite.label.filters[0] : null, DropShadowFilter);
		if (shadow == null)
		{
			shadow = new DropShadowFilter(3, 90, 0x80000000, 4);
			key.sprite.label.filters = [shadow];
		}
		shadow.strength = pressed ? 0.9 : 0;
	}

	// ---------------------------------------------------------------- input

	/**
		Internal frame counter used for hold timing.
	**/
	public function ticks():Int
	{
		return tickCounter;
	}

	/**
		Input dispatch: merges TouchButton touch/mouse state with keyboard
		binds, fires onKeyDown/onKeyUp and syncs gameplay actions.
	**/
	public function dispatch():Void
	{
		for (key in keys)
		{
			var was:Bool = key.pressed;
			var inputDown:Bool = key.enabled && enabled && key.sprite != null && key.sprite.pressed;
			if (!inputDown && key.enabled && enabled && key.bindKey != FlxKey.NONE)
				inputDown = FlxG.keys.checkStatus(key.bindKey, FlxInputState.JUST_PRESSED)
					|| FlxG.keys.checkStatus(key.bindKey, FlxInputState.PRESSED);
			key.pressed = inputDown;
			key.justPressed = inputDown && !was;
			key.justReleased = !inputDown && was;

			if (key.justPressed)
			{
				pressTick = tickCounter;
				key.holdTime = 0;
				onKeyDown(key.tag);
				pressVisual(key, true);
			}
			if (key.pressed) key.holdTime += FlxG.elapsed;
			if (key.justReleased)
			{
				onKeyUp(key.tag);
				pressVisual(key, false);
			}
		}
		syncGameplayPad();
	}

	public function update():Void
	{
		tickCounter++;
		dispatch();
	}

	/**
		Programmatic press (fires onKeyDown like a real press).
	**/
	public function pressKey(tag:String):Bool
	{
		var key:PianoKey = findKey(tag);
		if (key == null || key.pressed) return false;
		key.pressed = true;
		key.justPressed = true;
		pressTick = tickCounter;
		key.holdTime = 0;
		onKeyDown(tag);
		pressVisual(key, true);
		return true;
	}

	public function releaseKey(tag:String):Bool
	{
		var key:PianoKey = findKey(tag);
		if (key == null || !key.pressed) return false;
		key.pressed = false;
		key.justReleased = true;
		onKeyUp(tag);
		pressVisual(key, false);
		return true;
	}

	public function releaseAllKeys():Void
	{
		for (key in keys)
		{
			if (key.pressed) onKeyUp(key.tag);
			key.pressed = false;
			key.justPressed = false;
			key.justReleased = false;
			pressVisual(key, false);
		}
	}

	/**
		Feeds every key's bound gameplay action into the MobileInput bus.
	**/
	public function syncGameplayPad():Void
	{
		if (mobile.MobileInput.instance == null) return;
		for (key in keys)
		{
			if (key.action.length == 0) continue;
			mobile.MobileInput.instance.injectAction(key.action, key.pressed, key.justPressed, key.justReleased);
		}
	}

	// ---------------------------------------------------------------- key queries

	function findKey(tag:String):PianoKey
	{
		if (tag == null) return null;
		for (key in keys)
			if (key.tag == tag) return key;
		return null;
	}

	public function setKeyLabel(tag:String, label:String):Bool
	{
		var key:PianoKey = findKey(tag);
		if (key == null) return false;
		key.label = label == null ? key.tag : label;
		refreshKeyVisual(key);
		return true;
	}

	public function getKeyLabel(tag:String):String
	{
		var key:PianoKey = findKey(tag);
		return key == null ? '' : key.label;
	}

	public function setKeyColor(tag:String, color:Dynamic):Bool
	{
		var key:PianoKey = findKey(tag);
		if (key == null) return false;
		key.color = parseColor(color);
		refreshKeyVisual(key);
		return true;
	}

	public function setKeyTextColor(tag:String, color:Dynamic):Bool
	{
		var key:PianoKey = findKey(tag);
		if (key == null) return false;
		key.textColor = parseColor(color);
		refreshKeyVisual(key);
		return true;
	}

	public function setKeyTextSize(tag:String, size:Float):Bool
	{
		var key:PianoKey = findKey(tag);
		if (key == null) return false;
		key.textSize = size;
		refreshKeyVisual(key);
		return true;
	}

	public function setKeyWeight(tag:String, weight:Float):Bool
	{
		var key:PianoKey = findKey(tag);
		if (key == null) return false;
		key.weight = weight;
		refreshKeyVisual(key);
		return true;
	}

	public function setKeyImage(tag:String, path:String):Bool
	{
		return applyKeyArt(tag, path);
	}

	public function setKeyAction(tag:String, action:String):Bool
	{
		var key:PianoKey = findKey(tag);
		if (key == null) return false;
		key.action = action == null ? '' : action;
		return true;
	}

	/**
		Binds a keyboard key (FlxKey name string, e.g. 'A' or 'SPACE') to a
		piano key for desktop input.
	**/
	public function setKeyKey(tag:String, keyName:String):Bool
	{
		var key:PianoKey = findKey(tag);
		if (key == null) return false;
		key.bindKey = keyName == null ? FlxKey.NONE : FlxKey.fromString(keyName);
		return true;
	}

	public function setKeyWidth(tag:String, width:Float):Bool
	{
		var key:PianoKey = findKey(tag);
		if (key == null) return false;
		key.width = width;
		relayout();
		return true;
	}

	public function setKeyHeight(tag:String, keyHeight:Float):Bool
	{
		var key:PianoKey = findKey(tag);
		if (key == null) return false;
		key.keyHeight = keyHeight;
		relayout();
		return true;
	}

	public function setKeyOffset(tag:String, ox:Float, oy:Float):Bool
	{
		var key:PianoKey = findKey(tag);
		if (key == null) return false;
		key.offsetX = ox;
		key.offsetY = oy;
		centerIcon(key);
		return true;
	}

	public function setKeyEnabled(tag:String, value:Bool):Bool
	{
		var key:PianoKey = findKey(tag);
		if (key == null) return false;
		key.enabled = value;
		refreshKeyVisual(key);
		return true;
	}

	public function getKeyX(tag:String):Float
	{
		var key:PianoKey = findKey(tag);
		return key == null ? 0 : key.x;
	}

	public function getKeyY(tag:String):Float
	{
		var key:PianoKey = findKey(tag);
		return key == null ? 0 : key.y;
	}

	public function getKeyWidth(tag:String):Float
	{
		var key:PianoKey = findKey(tag);
		return key == null ? 0 : key.width;
	}

	public function getKeyHeight(tag:String):Float
	{
		var key:PianoKey = findKey(tag);
		return key == null ? 0 : key.keyHeight;
	}

	public function getKeyPressed(tag:String):Bool
	{
		var key:PianoKey = findKey(tag);
		return key != null && key.pressed;
	}

	public function getKeyJustPressed(tag:String):Bool
	{
		var key:PianoKey = findKey(tag);
		return key != null && key.justPressed;
	}

	public function getKeyJustReleased(tag:String):Bool
	{
		var key:PianoKey = findKey(tag);
		return key != null && key.justReleased;
	}

	/**
		Seconds the key has been held (0 when up).
	**/
	public function getKeyHoldTime(tag:String):Float
	{
		var key:PianoKey = findKey(tag);
		return key == null ? 0 : key.holdTime;
	}

	/**
		Tag of the key at the strip index, empty string when out of range.
	**/
	public function keyAt(index:Int):String
	{
		return (index >= 0 && index < keys.length) ? keys[index].tag : '';
	}

	/**
		Tag list snapshot.
	**/
	public function asList():Array<String>
	{
		var out:Array<String> = [];
		for (key in keys)
			out.push(key.tag);
		return out;
	}

	public function count():Int
	{
		return keys.length;
	}

	/**
		First key tag not currently pressed (for assignment flows), empty when all held.
	**/
	public function freeKey():String
	{
		for (key in keys)
			if (!key.pressed) return key.tag;
		return '';
	}

	public function ensureCamera():Void
	{
		if (group == null) return;
		group.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		group.scrollFactor.set(0, 0);
	}
}

/**
	One piano key: config, live input state and its TouchButton visual.
**/
class PianoKey
{
	public var tag:String = '';
	public var label:String = '';
	public var x:Float = 0;
	public var y:Float = 0;
	public var width:Float = 56;
	public var keyHeight:Float = 120;
	public var color:Null<FlxColor> = 0x66FFFFFF;
	public var textColor:Null<FlxColor> = FlxColor.WHITE;
	public var textSize:Float = 14;
	public var weight:Float = 0;
	public var image:String = '';
	public var action:String = '';
	public var bindKey:FlxKey = FlxKey.NONE;
	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	public var enabled:Bool = true;

	public var pressed:Bool = false;
	public var justPressed:Bool = false;
	public var justReleased:Bool = false;
	public var holdTime:Float = 0;

	public var sprite:TouchButton = null;
	public var icon:FlxSprite = null;

	public function new(tag:String)
	{
		this.tag = tag;
		this.label = tag;
	}
}
