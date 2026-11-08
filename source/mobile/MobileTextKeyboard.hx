package mobile;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
	On-screen text keyboard: rows of TouchButton keys writing into an internal
	buffer (and optionally into a target input field), with SHIFT/DEL/SPACE/DONE
	controls. Purely additive UI: nothing gameplay-facing reads it unless a
	state attaches it.
**/
class MobileTextKeyboard
{
	public static var instance:MobileTextKeyboard = null;
	public static var ROWS:Array<Array<String>> = [
		['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
		['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
		['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
		['SHIFT', 'z', 'x', 'c', 'v', 'b', 'n', 'm', 'DEL'],
		['SPACE', 'DONE']
	];

	public static inline var KEY_W:Float = 52;
	public static inline var KEY_H:Float = 40;
	public static inline var KEY_GAP:Float = 6;

	/**
		Called when DONE is pressed with the final buffer text.
	**/
	public dynamic function onDone(text:String):Void {}

	/**
		Optional input field (e.g. PsychUIInputText) kept in sync with the buffer.
	**/
	public var target:Dynamic = null;
	public var text(default, null):String = '';

	var shown:Bool = false;
	var upperCase:Bool = false;
	var keys:Array<TouchButton> = [];
	var group:FlxSpriteGroup = null;
	var backdrop:FlxSprite = null;
	var padW:Float = 0;
	var padH:Float = 0;

	public function new()
	{
		if (instance == null) instance = this;
	}

	public static function boot():MobileTextKeyboard
	{
		if (instance == null) instance = new MobileTextKeyboard();
		return instance;
	}

	public function attach(state:FlxState):MobileTextKeyboard
	{
		if (group == null) build();
		if (state != null && group != null && !state.members.contains(group))
			state.add(group);
		ensureCamera();
		return this;
	}

	function build():Void
	{
		group = new FlxSpriteGroup();
		padW = 0;
		for (row in ROWS)
		{
			var rowW:Float = row.length * KEY_W + (row.length - 1) * KEY_GAP;
			if (rowW > padW) padW = rowW;
		}
		padH = ROWS.length * (KEY_H + KEY_GAP) + KEY_GAP;

		backdrop = new FlxSprite();
		backdrop.makeGraphic(Std.int(padW + 12), Std.int(padH + 12), 0x88000000);
		backdrop.setPosition(-6, -6);
		group.add(backdrop);

		var y:Float = 0;
		for (row in ROWS)
		{
			var rowW:Float = row.length * KEY_W + (row.length - 1) * KEY_GAP;
			var x:Float = (padW - rowW) / 2;
			for (tag in row)
			{
				var key:TouchButton = makeKey(x, y, tag);
				group.add(key);
				keys.push(key);
				x += KEY_W + KEY_GAP;
			}
			y += KEY_H + KEY_GAP;
		}
		group.visible = shown;
	}

	function makeKey(x:Float, y:Float, tag:String):TouchButton
	{
		var label:String = tag;
		if (tag == 'SPACE') label = '_';
		var btn:TouchButton = new TouchButton(x, y, tag, label);
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

	/**
		Appends a character to the buffer (honouring upperCase) and syncs the
		target field. Returns the buffer.
	**/
	public function writeChar(char:String):String
	{
		if (char == null) return text;
		var out:String = char;
		if (upperCase && out.length == 1) out = out.toUpperCase();
		text += out;
		syncTarget();
		return text;
	}

	public function backspace():String
	{
		if (text.length > 0) text = text.substr(0, text.length - 1);
		syncTarget();
		return text;
	}

	function syncTarget():Void
	{
		if (target != null && Reflect.hasField(target, 'text'))
			Reflect.setProperty(target, 'text', text);
	}

	public function setShown(?shown:Null<Bool> = null):Bool
	{
		this.shown = shown == null ? !this.shown : shown;
		if (this.shown)
		{
			text = '';
			upperCase = false;
			if (target != null && Reflect.hasField(target, 'text'))
				text = Reflect.field(target, 'text');
		}
		if (group != null) group.visible = this.shown;
		return this.shown;
	}

	public function update():Void
	{
		if (!shown || group == null || !group.visible) return;
		for (key in keys)
		{
			if (key == null || !key.justPressed) continue;
			switch (key.tag)
			{
				case 'SHIFT':
					upperCase = !upperCase;
					key.label.alpha = upperCase ? 1 : 0.8;
				case 'DEL':
					backspace();
				case 'SPACE':
					writeChar(' ');
				case 'DONE':
					onDone(text);
					setShown(false);
				default:
					writeChar(key.tag);
			}
		}
	}

	public function pointIn(px:Float, py:Float):Bool
	{
		if (group == null || !shown) return false;
		return px >= group.x && px <= group.x + group.width && py >= group.y && py <= group.y + group.height;
	}

	public function containsGlobalPoint(px:Float, py:Float):Bool
	{
		return pointIn(px, py);
	}

	public function ensureCamera():Void
	{
		if (group == null) return;
		group.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		group.scrollFactor.set(0, 0);
	}

	public function destroyKeyboard():Void
	{
		for (key in keys) key.destroy();
		keys.resize(0);
		if (backdrop != null) backdrop.destroy();
		backdrop = null;
		if (group != null) group.clear();
		group = null;
	}

	public function destroy():Void
	{
		destroyKeyboard();
		target = null;
	}
}
