package android.os;

class VERSION
{
	var boot:Dynamic = null;


	public static var instance:VERSION = null;

	public static function boot():Void
	{
		instance = new VERSION();
	}

	function applyState():Void
	{
	}
}
