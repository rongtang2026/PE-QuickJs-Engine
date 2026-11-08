package mobile;

import flixel.FlxG;
import flixel.FlxState;

/**
	System back handler: polls the back key (ESCAPE, which lime maps from the
	Android BACK button), debounces taps through a pending-release window and
	fires the owner callback only while its state is the active one.
**/
class MobileBackButton
{
	public static var instance:MobileBackButton = null;
	public static inline var RELEASE_DELAY:Float = 0.05;

	public dynamic function onBack():Void {}

	var owner:FlxState = null;
	var shown:Bool = false;
	var pendingRelease:Bool = false;
	var pendingReleaseAt:Float = 0;
	var currentTick:Float = 0;
	var pollEnabled:Bool = true;

	public function new()
	{
		if (instance == null) instance = this;
	}

	public static function boot():MobileBackButton
	{
		if (instance == null) instance = new MobileBackButton();
		return instance;
	}

	public function attach(state:FlxState, ?callback:Void->Void = null):MobileBackButton
	{
		owner = state;
		if (callback != null) onBack = callback;
		setShown(true);
		return this;
	}

	public function destroy():Void
	{
		owner = null;
		onBack = function() {};
		setShown(false);
	}

	public function destroyFor(state:FlxState):Bool
	{
		if (state == null || owner != state) return false;
		destroy();
		return true;
	}

	public function isOwnerActive(?state:FlxState = null):Bool
	{
		var target:FlxState = state != null ? state : owner;
		return target != null && FlxG.state == target;
	}

	public function setShown(?shown:Null<Bool> = null):Bool
	{
		this.shown = shown == null ? !this.shown : shown;
		return this.shown;
	}

	/**
		True this frame if the system back key was pressed (ESCAPE on desktop,
		Android BACK on device).
	**/
	public function pollSystemBack():Bool
	{
		return FlxG.keys.justPressed.ESCAPE;
	}

	/**
		Registers a back tap; the callback fires once the debounce window in
		RELEASE_DELAY elapses (via tick()).
	**/
	public function tap():Bool
	{
		pendingRelease = true;
		pendingReleaseAt = currentTick + RELEASE_DELAY;
		return true;
	}

	/**
		Fires the back callback if the owner state is still active.
		Returns false when there is no active owner.
	**/
	public function fire():Bool
	{
		if (!isOwnerActive())
		{
			pendingRelease = false;
			return false;
		}
		onBack();
		pendingRelease = false;
		return true;
	}

	public function flushPending():Bool
	{
		if (!pendingRelease) return false;
		return fire();
	}

	public function tick(delta:Float = 0):Void
	{
		currentTick += delta;
		if (pendingRelease && currentTick >= pendingReleaseAt) flushPending();
	}

	/**
		Full per-frame pass: tick + poll the system back key.
	**/
	public function tickAll(delta:Float = 0):Void
	{
		tick(delta);
		if (pollEnabled && pollSystemBack())
		{
			tap();
			flushPending();
		}
	}

	/**
		Hit test for the layer template: the back action is system-driven and
		has no on-screen hotspot, so this always returns false.
	**/
	public function containsGlobalPoint(px:Float, py:Float):Bool
	{
		return false;
	}

	/**
		Layer template hook: nothing to bind to a camera (no visuals).
	**/
	public function ensureCamera():Void {}
}
