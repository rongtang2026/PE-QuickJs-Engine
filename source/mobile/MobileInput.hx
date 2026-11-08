package mobile;

import flixel.FlxG;
import flixel.input.touch.FlxTouch;

/**
	Touch input bus: aggregates every registered pad (MobilePad / VirtualPad)
	into per-action press maps keyed by the button tags, tracks which touches
	were claimed by pad buttons so gameplay code can skip them, and releases
	everything when the window loses focus.
**/
class MobileInput
{
	public static var instance:MobileInput = null;

	var pads:Array<MobilePad> = [];
	var pressedActions:Map<String, Bool> = new Map<String, Bool>();
	var justPressedActions:Map<String, Bool> = new Map<String, Bool>();
	var justReleasedActions:Map<String, Bool> = new Map<String, Bool>();
	var claimedTouches:Map<Int, Bool> = new Map<Int, Bool>();
	var staleTouches:Bool = false;
	var lastTick:Int = 0;
	var focusHooked:Bool = false;

	public function new()
	{
		if (instance == null) instance = this;
	}

	public static function boot():MobileInput
	{
		if (instance == null) instance = new MobileInput();
		instance.hookFocus();
		return instance;
	}

	/**
		Releases every button when the window loses focus, so no button stays
		stuck pressed while the game is in the background.
	**/
	public function hookFocus():Void
	{
		if (focusHooked) return;
		focusHooked = true;
		FlxG.signals.focusLost.add(function() resetAll());
	}

	public function addPad(pad:MobilePad):MobilePad
	{
		if (pad == null) return null;
		if (!pads.contains(pad)) pads.push(pad);
		staleTouches = true;
		return pad;
	}

	public function removePad(pad:MobilePad):MobilePad
	{
		if (pad == null) return null;
		pads.remove(pad);
		staleTouches = true;
		return pad;
	}

	public function hasActivePads():Bool
	{
		for (pad in pads)
			if (pad != null && pad.enabled && pad.buttons.length > 0) return true;
		return false;
	}

	public function isButtonDown(action:String):Bool
	{
		if (action == null) return false;
		if (pressedActions.exists(action) && pressedActions.get(action)) return true;
		for (pad in pads)
		{
			if (pad == null || !pad.enabled) continue;
			for (btn in pad.buttons)
				if (btn.tag == action && btn.pressed) return true;
		}
		return false;
	}

	/**
		Alias of isButtonDown kept for API symmetry with the just* queries.
	**/
	public function pressed(action:String):Bool
	{
		return isButtonDown(action);
	}

	public function justPressed(action:String):Bool
	{
		return action != null && justPressedActions.exists(action) && justPressedActions.get(action);
	}

	public function justReleased(action:String):Bool
	{
		return action != null && justReleasedActions.exists(action) && justReleasedActions.get(action);
	}

	public function touchIsDown():Bool
	{
		for (touch in FlxG.touches.list)
			if (touch.pressed) return true;
		return false;
	}

	public function getTouch(?index:Int = 0):FlxTouch
	{
		if (index == 0) return FlxG.touches.getFirst();
		var list:Array<FlxTouch> = FlxG.touches.list;
		return (index >= 0 && index < list.length) ? list[index] : null;
	}

	public function clearActions():Void
	{
		pressedActions.clear();
		justPressedActions.clear();
		justReleasedActions.clear();
	}

	public function resetAll():Void
	{
		clearActions();
		claimedTouches.clear();
		for (pad in pads)
			if (pad != null) pad.resetButtons();
	}

	/**
		Marks the claimed-touch cache as outdated (after pads changed); the next
		ensureUpdated() recomputes it.
	**/
	public function markTouchesStale():Void
	{
		staleTouches = true;
	}

	/**
		Recomputes the claimed-touch cache when it was marked stale.
	**/
	public function ensureUpdated():Void
	{
		if (!staleTouches) return;
		staleTouches = false;
		claimedTouches.clear();
		refreshClaimedTouches();
	}

	function refreshClaimedTouches():Void
	{
		for (touch in FlxG.touches.list)
		{
			if (!touch.pressed) continue;
			for (pad in pads)
			{
				if (pad == null || !pad.enabled) continue;
				for (btn in pad.buttons)
				{
					if (btn == null || !btn.exists) continue;
					if (touch.x >= btn.x && touch.x <= btn.x + btn.width
						&& touch.y >= btn.y && touch.y <= btn.y + btn.height)
					{
						claimedTouches.set(touch.touchPointID, true);
						break;
					}
				}
			}
		}
	}

	/**
		Whether a touch was claimed by a pad button this frame (skip it in
		gameplay input code).
	**/
	public function isClaimed(touch:FlxTouch):Bool
	{
		return touch != null && claimedTouches.exists(touch.touchPointID);
	}

	/**
		Feeds an external input source (e.g. PianoKeys) directly into the
		action maps, so gameplay code queries it like any pad button.
	**/
	public function injectAction(action:String, isPressed:Bool, isJustPressed:Bool, isJustReleased:Bool):Void
	{
		if (action == null || action.length == 0) return;
		if (isPressed) pressedActions.set(action, true);
		if (isJustPressed) justPressedActions.set(action, true);
		if (isJustReleased) justReleasedActions.set(action, true);
	}

	/**
		Per-frame aggregation: rebuilds the action maps from every pad.
	**/
	public function update():Void
	{
		ensureUpdated();
		clearActions();
		for (pad in pads)
		{
			if (pad == null || !pad.enabled) continue;
			for (btn in pad.buttons)
			{
				if (btn == null || btn.tag.length == 0) continue;
				if (btn.pressed) pressedActions.set(btn.tag, true);
				if (btn.justPressed) justPressedActions.set(btn.tag, true);
				if (btn.justReleased) justReleasedActions.set(btn.tag, true);
			}
		}
		lastTick++;
	}
}
