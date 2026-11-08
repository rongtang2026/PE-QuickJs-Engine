package backend;

class MenuAttachment
{
	public static var instance:MenuAttachment = null;

	public var tag:String = '';
	public var target:String = '';
	public var offsetX:Float = 0;
	public var offsetY:Float = 0;

	public function new(?tag:String = '', ?target:String = '', offsetX:Float = 0, offsetY:Float = 0)
	{
		instance = this;
		this.tag = tag;
		this.target = target;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		backend.MenuUI.attach(tag, target);
	}
}
