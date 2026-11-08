package options;

class MobileSettingsSubState
{
	public static var instance:MobileSettingsSubState = null;

	public function new()
	{
		if (instance == null) instance = this;
	}
}
