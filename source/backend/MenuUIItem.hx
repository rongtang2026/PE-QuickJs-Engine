package backend;

import flixel.FlxSprite;

class MenuUIItem
{
	public var tag:String;
	public var sprite:FlxSprite;
	public var id:String;
	public var label:String;
	public var callbackName:String;
	public var state:String;
	public var page:String;
	public var url:String;
	public var color:Int = 0xFFFFFFFF;
	public var alpha:Float = 1;
	public var enabled:Bool = true;
	public var visible:Bool = true;
	public var x:Float = 0;
	public var y:Float = 0;

	public function new(tag:String, sprite:FlxSprite, ?label:String)
	{
		this.tag = tag;
		this.id = tag;
		this.sprite = sprite;
		this.label = label != null ? label : tag;
		if (sprite != null)
		{
			this.x = sprite.x;
			this.y = sprite.y;
		}
	}

	public function hitTest(px:Float, py:Float):Bool
	{
		if (sprite == null || !visible || !enabled) return false;
		return px >= sprite.x && px <= sprite.x + sprite.width
			&& py >= sprite.y && py <= sprite.y + sprite.height;
	}

	public function apply():Void
	{
		if (sprite == null) return;
		sprite.visible = visible;
		sprite.alpha = enabled ? alpha : alpha * 0.45;
		sprite.color = color;
		sprite.x = x;
		sprite.y = y;
	}
}
