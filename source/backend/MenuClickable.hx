package backend;

class MenuClickable
{
	public static var instance:MenuClickable = null;

	public var callbackName:String = null;
	public var enabled:Bool = true;

	public function new(?callbackName:String = null)
	{
		instance = this;
		this.callbackName = callbackName;
	}
}
