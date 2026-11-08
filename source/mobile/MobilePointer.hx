package mobile;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.input.touch.FlxTouch;

/**
	Unified pointer abstraction: merges the desktop mouse (FlxG.mouse) and
	mobile touches (FlxG.touches) into one pointer state. A second simultaneous
	finger acts as the right mouse button (tracked through rightTouchId), and
	optional UI objects (blocksPointer) can suppress press states while the
	pointer overlaps them.
**/
class MobilePointer
{
	public static var instance:MobilePointer = null;

	public var x(get, never):Float;
	public var y(get, never):Float;
	public var screenX(get, never):Float;
	public var screenY(get, never):Float;
	public var deltaScreenX(get, never):Float;
	public var deltaScreenY(get, never):Float;
	public var justMoved(get, never):Bool;
	public var justPressed(get, never):Bool;
	public var justPressedRight(get, never):Bool;
	public var justReleased(get, never):Bool;
	public var pressed(get, never):Bool;
	public var pressedRight(get, never):Bool;
	public var released(get, never):Bool;
	public var releasedRight(get, never):Bool;
	public var touchActive(get, never):Bool;
	public var visible(get, set):Bool;
	public var wheel(get, never):Int;

	var curX:Float = 0;
	var curY:Float = 0;
	var curScreenX:Float = 0;
	var curScreenY:Float = 0;
	var lastScreenX:Float = 0;
	var lastScreenY:Float = 0;
	var curDeltaX:Float = 0;
	var curDeltaY:Float = 0;
	var curTouch:FlxTouch = null;
	var rightTouchId:Int = -1;
	var curMoved:Bool = false;
	var curPressed:Bool = false;
	var curJustPressed:Bool = false;
	var curJustReleased:Bool = false;
	var curPressedRight:Bool = false;
	var curJustPressedRight:Bool = false;
	var curJustReleasedRight:Bool = false;
	var stateTick:Int = 0;
	var lastTouchTick:Int = -1;
	var idle:Int = 0;
	var blocked:Bool = false;

	/**
		UI object (virtual pad, keyboard...) that suppresses pointer press
		states while the pointer overlaps it.
	**/
	var blocksPointer:Dynamic = null;

	/**
		Object the pointer currently overlaps (updated during refresh()).
	**/
	var overlaps:Dynamic = null;

	public function new()
	{
		if (instance == null) instance = this;
	}

	public static function boot():MobilePointer
	{
		if (instance == null) instance = new MobilePointer();
		return instance;
	}

	/**
		Registers a UI object that blocks pointer input while overlapped.
		Pass null to clear.
	**/
	public function blockWith(object:Dynamic = null):Void
	{
		blocksPointer = object;
	}

	/**
		Composites mouse + touch state for this frame. Call once per frame
		before reading the pointer properties.
	**/
	public function refresh():Void
	{
		stateTick++;
		lastScreenX = curScreenX;
		lastScreenY = curScreenY;

		var mouse = FlxG.mouse;
		var touches:Array<FlxTouch> = FlxG.touches.list;

		// primary touch: first active touch this frame
		var primary:FlxTouch = null;
		for (touch in touches)
		{
			if (touch.pressed || touch.justPressed || touch.justReleased)
			{
				primary = touch;
				break;
			}
		}
		curTouch = primary;
		lastTouchTick = primary != null ? stateTick : lastTouchTick;
		var touchDriven:Bool = primary != null;

		if (touchDriven)
		{
			var touchScreen:FlxPoint = primary.getScreenPosition();
			curScreenX = touchScreen.x;
			curScreenY = touchScreen.y;
			touchScreen.put();
			var world:FlxPoint = primary.getWorldPosition();
			curX = world.x;
			curY = world.y;
			world.put();

			curPressed = primary.pressed;
			curJustPressed = primary.justPressed;
			curJustReleased = primary.justReleased;
			curMoved = curScreenX != lastScreenX || curScreenY != lastScreenY;

			// second distinct finger acts as the right mouse button
			var right:FlxTouch = null;
			for (touch in touches)
			{
				if (touch != primary && touch.pressed)
				{
					right = touch;
					break;
				}
			}
			if (right != null) rightTouchId = right.touchPointID;
			curPressedRight = right != null && right.pressed;
			curJustPressedRight = right != null && right.justPressed;
			curJustReleasedRight = right != null && right.justReleased;
			if (right == null && rightTouchId != -1)
				rightTouchId = -1;
		}
		else
		{
			curScreenX = mouse.screenX;
			curScreenY = mouse.screenY;
			curX = mouse.x;
			curY = mouse.y;
			curPressed = mouse.pressed;
			curJustPressed = mouse.justPressed;
			curJustReleased = mouse.justReleased;
			curMoved = mouse.justMoved;
			curPressedRight = mouse.pressedRight;
			curJustPressedRight = mouse.justPressedRight;
			curJustReleasedRight = mouse.justReleasedRight;
		}

		curDeltaX = curScreenX - lastScreenX;
		curDeltaY = curScreenY - lastScreenY;

		// blocking check: active UI object under the pointer suppresses presses
		blocked = false;
		overlaps = null;
		if (blocksPointer != null && Std.isOfType(blocksPointer, FlxObject))
		{
			var blocker:FlxObject = blocksPointer;
			if (blocker.exists && blocker.overlapsPoint(FlxPoint.get(curX, curY)))
			{
				blocked = true;
				overlaps = blocker;
			}
		}

		var active:Bool = curPressed || curJustPressed || curJustReleased || curMoved || curPressedRight;
		idle = active ? 0 : idle + 1;
	}

	function get_x():Float
	{
		return curX;
	}

	function get_y():Float
	{
		return curY;
	}

	function get_screenX():Float
	{
		return curScreenX;
	}

	function get_screenY():Float
	{
		return curScreenY;
	}

	function get_deltaScreenX():Float
	{
		return curDeltaX;
	}

	function get_deltaScreenY():Float
	{
		return curDeltaY;
	}

	function get_justMoved():Bool
	{
		return !blocked && curMoved;
	}

	function get_justPressed():Bool
	{
		return !blocked && curJustPressed;
	}

	function get_justPressedRight():Bool
	{
		return !blocked && curJustPressedRight;
	}

	function get_justReleased():Bool
	{
		return !blocked && curJustReleased;
	}

	function get_pressed():Bool
	{
		return !blocked && curPressed;
	}

	function get_pressedRight():Bool
	{
		return !blocked && curPressedRight;
	}

	function get_released():Bool
	{
		return !blocked && !curPressed;
	}

	function get_releasedRight():Bool
	{
		return !blocked && !curPressedRight;
	}

	function get_touchActive():Bool
	{
		return lastTouchTick == stateTick && stateTick > 0;
	}

	function get_visible():Bool
	{
		return FlxG.mouse.visible;
	}

	function set_visible(value:Bool):Bool
	{
		FlxG.mouse.visible = value;
		return value;
	}

	function get_wheel():Int
	{
		return FlxG.mouse.wheel;
	}

	/**
		Pointer position in the given camera's view space
		(world position relative to the camera view origin), main camera when null.
	**/
	public function getPositionInCameraView(?camera:FlxCamera = null):FlxPoint
	{
		if (camera == null) camera = FlxG.camera;
		return FlxPoint.get(curX - camera.viewX, curY - camera.viewY);
	}

	/**
		Pointer position in screen space for the given camera, main camera when null.
	**/
	public function getScreenPosition(?camera:FlxCamera = null):FlxPoint
	{
		if (camera == null) camera = FlxG.camera;
		if (curTouch != null)
		{
			var touchPoint:FlxPoint = curTouch.getScreenPosition(camera);
			var out:FlxPoint = FlxPoint.get(touchPoint.x, touchPoint.y);
			touchPoint.put();
			return out;
		}
		return FlxPoint.get(curScreenX, curScreenY);
	}

	/**
		Whether the pointer (in world space) overlaps the given object.
	**/
	public function overlapsObject(object:FlxObject):Bool
	{
		if (object == null) return false;
		return object.overlapsPoint(FlxPoint.get(curX, curY));
	}
}
