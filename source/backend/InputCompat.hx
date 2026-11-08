package backend;

class InputCompat
{
	public static var instance:InputCompat = null;
	var actionJustPressed:Dynamic = null;
	var actionJustReleased:Dynamic = null;
	var actionPressed:Dynamic = null;
	var buttonName:String = "";
	var keyFromName:String = "";
	var keyboardJustPressed:String = "";
	var keyboardJustReleased:String = "";
	var keyboardPressed:String = "";
	var mouseJustPressed:Dynamic = null;
	var mouseJustReleased:Dynamic = null;
	var mousePressed:Dynamic = null;
	var mouseX:Dynamic = null;
	var mouseY:Dynamic = null;
	var normalizeActionName:String = "";

	public function new()
	{
		if (instance == null) instance = this;
	}

	public function normalizeKeyName(name:String):String
	{
		if (name == null) return '';
		var k:String = name.toLowerCase().trim();
		return switch (k)
		{
			case 'return': 'enter';
			case 'esc': 'escape';
			case 'spacebar': 'space';
			case 'ctrl': 'control';
			default: k;
		};
	}
}
