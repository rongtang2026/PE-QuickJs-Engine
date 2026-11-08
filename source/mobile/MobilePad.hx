package mobile;

class MobilePad
{
	public static var instance:MobilePad = null;

	public var buttons:Array<mobile.TouchButton> = [];
	public var padAlpha:Float = 0.6;
	public var enabled:Bool = true;

	public function new()
	{
		if (instance == null) instance = this;
	}

	public function register(btn:mobile.TouchButton):Void
	{
		if (btn != null && buttons.indexOf(btn) < 0) buttons.push(btn);
	}

	public function resetButtons():Void
	{
		for (b in buttons)
		{
			b.pressed = false;
			b.justPressed = false;
			b.justReleased = false;
			b.status = 0;
		}
	}

	public function setEnabled(v:Bool):Void
	{
		enabled = v;
		for (b in buttons) b.visible = v && b.visible;
	}

	public function getPadAlpha():Float
	{
		return padAlpha;
	}

	public function destroy():Void
	{
		buttons = [];
		if (instance == this) instance = null;
	}
}
