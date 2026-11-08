package mobile;

class MobileKeys
{
	public static var instance:MobileKeys = null;
	var anyJustPressed:Dynamic = null;
	var anyJustReleased:Dynamic = null;
	var anyPressed:Dynamic = null;
	var checkStatus:Dynamic = null;
	var currentTick:Dynamic = null;
	var firstJustPressed:Dynamic = null;
	var firstJustReleased:Dynamic = null;
	var justPressed:Dynamic = null;
	var justReleased:Dynamic = null;
	var press:Dynamic = null;
	var pressed:Dynamic = null;
	var release:Dynamic = null;
	var takeEvent:Dynamic = null;

	public function new()
	{
		if (instance == null) instance = this;
	}

	public function reset():Void
	{
		justPressed = null;
		justReleased = null;
		pressed = null;
		released = null;
		firstJustPressed = false;
		firstJustReleased = false;
	}
}
