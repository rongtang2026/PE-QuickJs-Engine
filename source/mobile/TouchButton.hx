package mobile;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class TouchButton extends FlxSpriteGroup
{
	public static var instance:TouchButton = null;

	public var label:FlxText;
	public var tag:String = '';
	public var status:Int = 0; // 0 = unpressed, 1 = pressed
	public var pressed:Bool = false;
	public var justPressed:Bool = false;
	public var justReleased:Bool = false;
	public var monitorInputs:Bool = true;
	public var artSprite:FlxSprite = null;

	public function new(x:Float = 0, y:Float = 0, ?tag:String = '', ?labelText:String = null)
	{
		super(x, y);
		instance = this;
		this.tag = tag;
		label = new FlxText(0, 0, 120, labelText != null ? labelText : tag, 16);
		label.setFormat('VCR OSD Mono', 16, FlxColor.WHITE, CENTER);
		label.alpha = 0.8;
		add(label);
		ensureCamera();
	}

	public function ensureCamera():Void
	{
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		scrollFactor.set(0, 0);
	}

	function pointInBounds(px:Float, py:Float):Bool
	{
		return px >= x && px <= x + width && py >= y && py <= y + height;
	}

	public function handleTouches():Void
	{
		var prev:Bool = pressed;
		var hit:Bool = false;

		if (FlxG.mouse.overlaps(this, camera)) hit = FlxG.mouse.pressed;

		#if android
		for (touch in FlxG.touches.list)
		{
			if (touch.pressed && pointInBounds(touch.viewX, touch.viewY)) { hit = true; break; }
		}
		#end

		pressed = hit;
		justPressed = pressed && !prev;
		justReleased = !pressed && prev;
		status = pressed ? 1 : 0;
		label.alpha = pressed ? 1 : 0.8;
		if (artSprite != null && artSprite.animation != null && artSprite.animation.numFrames > 2)
			artSprite.animation.frameIndex = pressed ? 2 : 0;
	}

	public function justPressedHitTest(px:Float, py:Float):Bool
	{
		return pointInBounds(px, py);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (monitorInputs) handleTouches();
	}

	override public function destroy():Void
	{
		if (instance == this) instance = null;
		super.destroy();
	}
}
