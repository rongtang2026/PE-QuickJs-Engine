package mobile;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.input.touch.FlxTouch;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
	Collapsible on-screen key pad: a grid of assignable key slots used as a
	picker for key rebinding. Tapping a slot holds it (holdKey / holdCount),
	freeKey reports the next unheld slot, and the whole pad collapses behind a
	toggle button.
**/
class MobileKeyPad
{
	public static var instance:MobileKeyPad = null;
	public static var PICKER_KEYS:Array<String> = ['A', 'B', 'C', 'D', 'E', 'F'];

	public static inline var KEY_W:Float = 56;
	public static inline var KEY_H:Float = 40;
	public static inline var KEY_GAP:Float = 8;

	var backdrop:FlxSprite = null;
	var toggleBg:TouchButton = null;
	var toggleText:FlxText = null;
	var entries:Array<TouchButton> = [];
	var claimed:Map<Int, Bool> = new Map<Int, Bool>();
	var collapsed:Bool = false;
	var holdCount:Int = 0;
	var padW:Float = 0;
	var padH:Float = 0;
	var freeKey:String = '';
	var holdKey:String = '';
	var group:FlxSpriteGroup = null;

	public function new()
	{
		if (instance == null) instance = this;
	}

	public static function boot():MobileKeyPad
	{
		if (instance == null) instance = new MobileKeyPad();
		return instance;
	}

	/**
		Builds (once) and adds the pad to the given state.
	**/
	public function attach(state:FlxState):MobileKeyPad
	{
		if (group == null) build();
		if (state != null && group != null && !state.members.contains(group))
			state.add(group);
		ensureCamera();
		return this;
	}

	/**
		(Re)builds the key slots from the given key list (PICKER_KEYS when null).
	**/
	public function attachKeyPicker(?keys:Array<String> = null):MobileKeyPad
	{
		if (keys == null) keys = PICKER_KEYS;
		for (entry in entries)
			entry.destroy();
		entries.resize(0);
		if (group == null) build();
		var perRow:Int = 3;
		var rows:Int = Math.ceil(keys.length / perRow);
		padW = perRow * KEY_W + (perRow - 1) * KEY_GAP;
		padH = rows * (KEY_H + KEY_GAP) + KEY_GAP;
		if (backdrop != null)
		{
			backdrop.makeGraphic(Std.int(padW + 12), Std.int(padH + 12), 0x88000000);
			backdrop.setPosition(-6, -6);
		}
		var x:Float = 0;
		var y:Float = 0;
		var col:Int = 0;
		for (tag in keys)
		{
			var btn:TouchButton = makeKey(x, y, tag);
			group.add(btn);
			entries.push(btn);
			col++;
			if (col >= perRow)
			{
				col = 0;
				x = 0;
				y += KEY_H + KEY_GAP;
			}
			else
				x += KEY_W + KEY_GAP;
		}
		setCollapsed(collapsed);
		return this;
	}

	function build():Void
	{
		group = new FlxSpriteGroup();
		backdrop = new FlxSprite();
		group.add(backdrop);

		toggleBg = new TouchButton(0, 0, 'KEYPAD_TOGGLE', 'keys');
		var tbg:FlxSprite = new FlxSprite();
		tbg.makeGraphic(72, Std.int(KEY_H), 0x55000000);
		toggleBg.insert(0, tbg);
		toggleBg.label.setFormat('VCR OSD Mono', 13, FlxColor.WHITE, CENTER);
		toggleBg.label.fieldWidth = 72;
		toggleBg.label.x = 0;
		toggleBg.label.y = (KEY_H - toggleBg.label.height) / 2;
		toggleBg.scrollFactor.set(0, 0);
		group.add(toggleBg);
	}

	function makeKey(x:Float, y:Float, tag:String):TouchButton
	{
		var btn:TouchButton = new TouchButton(x, y, tag, tag);
		var bg:FlxSprite = new FlxSprite();
		bg.makeGraphic(Std.int(KEY_W), Std.int(KEY_H), 0x55000000);
		btn.insert(0, bg);
		btn.label.setFormat('VCR OSD Mono', 13, FlxColor.WHITE, CENTER);
		btn.label.fieldWidth = Std.int(KEY_W);
		btn.label.x = 0;
		btn.label.y = (KEY_H - btn.label.height) / 2;
		btn.scrollFactor.set(0, 0);
		return btn;
	}

	public function labelOf(tag:String):String
	{
		for (entry in entries)
			if (entry != null && entry.tag == tag) return entry.label.text;
		return tag;
	}

	/**
		First TouchButton under the given touch, null when none.
	**/
	public function findTouch(touch:FlxTouch):TouchButton
	{
		if (touch == null) return null;
		for (entry in entries)
		{
			if (entry == null || !entry.exists) continue;
			if (touch.viewX >= entry.x && touch.viewX <= entry.x + entry.width
				&& touch.viewY >= entry.y && touch.viewY <= entry.y + entry.height)
				return entry;
		}
		return null;
	}

	public function pointIn(px:Float, py:Float):Bool
	{
		if (group == null || collapsed) return false;
		return px >= group.x && px <= group.x + group.width && py >= group.y && py <= group.y + group.height;
	}

	public function containsGlobalPoint(px:Float, py:Float):Bool
	{
		return pointIn(px, py);
	}

	public function releaseAll():Void
	{
		for (entry in entries)
		{
			if (entry == null) continue;
			entry.pressed = false;
			entry.justPressed = false;
			entry.justReleased = false;
			entry.status = 0;
		}
		holdKey = '';
		holdCount = 0;
	}

	public function setCollapsed(?collapsed:Null<Bool> = null):Bool
	{
		this.collapsed = collapsed == null ? !this.collapsed : collapsed;
		for (entry in entries)
			entry.visible = !this.collapsed;
		if (backdrop != null) backdrop.visible = !this.collapsed;
		if (toggleText != null) toggleText.visible = !this.collapsed;
		return this.collapsed;
	}

	public function update():Void
	{
		if (group == null) return;
		if (toggleBg != null && toggleBg.justPressed) setCollapsed();

		holdKey = '';
		holdCount = 0;
		for (entry in entries)
		{
			if (entry != null && entry.pressed)
			{
				if (holdKey == '') holdKey = entry.tag;
				holdCount++;
			}
		}
		freeKey = '';
		for (tag in PICKER_KEYS)
		{
			var held:Bool = false;
			for (entry in entries)
				if (entry != null && entry.tag == tag && entry.pressed) held = true;
			if (!held)
			{
				freeKey = tag;
				break;
			}
		}

		claimed.clear();
		for (touch in FlxG.touches.list)
		{
			if (!touch.pressed) continue;
			if (findTouch(touch) != null || (toggleBg != null && touch.viewX >= toggleBg.x && touch.viewX <= toggleBg.x + toggleBg.width
				&& touch.viewY >= toggleBg.y && touch.viewY <= toggleBg.y + toggleBg.height))
				claimed.set(touch.touchPointID, true);
		}
	}

	/**
		Whether a touch was claimed by the pad (skip it in gameplay input code).
	**/
	public function isClaimed(touch:FlxTouch):Bool
	{
		return touch != null && claimed.exists(touch.touchPointID);
	}

	public function ensureCamera():Void
	{
		if (group == null) return;
		group.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		group.scrollFactor.set(0, 0);
	}

	public function destroyPad():Void
	{
		for (entry in entries)
			entry.destroy();
		entries.resize(0);
		if (toggleBg != null) toggleBg.destroy();
		toggleBg = null;
		if (backdrop != null) backdrop.destroy();
		backdrop = null;
		if (group != null) group.clear();
		group = null;
	}

	public function destroy():Void
	{
		destroyPad();
	}
}
