package android.os;

class Build
{
	public static var instance:Build = null;

	public function new()
	{
		if (instance == null) instance = this;
	}

	public function getRadioVersion():String
	{
		#if android
		try
		{
			var getRadio = JNICache.createStaticMethod('android/os/Build', 'getRadioVersion', '()Ljava/lang/String;');
			return Std.string(getRadio());
		}
		catch (e:Dynamic) return '';
		#else
		return '';
		#end
	}
}
