package backend;

class FpsPanelApi
{
	public static var instance:FpsPanelApi = null;

	public function new()
	{
		if (instance == null) instance = this;
	}

	public function getPanel():Dynamic
	{
		return debug.FPSCounter.instance;
	}

	public function parseColor(str:String):Null<flixel.util.FlxColor>
	{
		if (str == null) return null;
		str = str.trim();
		if (str.charAt(0) == "#") str = str.substr(1);
		if (str.length >= 2 && str.substr(0, 2) == "0x") str = str.substr(2);
		if (str.length != 6 && str.length != 8) return null;
		var v:Null<Int> = Std.parseInt("0x" + str);
		return v == null ? null : (str.length == 6 ? (0xFF000000 | v) : v);
	}

	public function setBackgroundImage(img:String):Void
	{
		try { debug.FPSCounter.instance.setBackgroundImage(img); } catch (e:Dynamic) {}
	}
}
