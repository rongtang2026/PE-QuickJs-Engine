package android.os;

class VERSION_CODES
{
	var boot:Dynamic = null;


	public static var instance:VERSION_CODES = null;

	public static function boot():Void
	{
		instance = new VERSION_CODES();
	}

	function applyState():Void
	{
	}
}
