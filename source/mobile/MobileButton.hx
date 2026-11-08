package mobile;

class MobileButton
{
	public static var instance:MobileButton = null;

	public var tag:String = '';
	public var pressed:Bool = false;
	public var alive:Bool = true;

	public function new(?tag:String = '')
	{
		instance = this;
		this.tag = tag;
	}

	public function overlaps(px:Float, py:Float, w:Float, h:Float):Bool
	{
		return alive && px >= 0 && py >= 0 && px <= w && py <= h;
	}

	public function reset():Void
	{
		pressed = false;
		alive = true;
	}

	public function destroy():Void
	{
		alive = false;
		if (instance == this) instance = null;
	}
}
