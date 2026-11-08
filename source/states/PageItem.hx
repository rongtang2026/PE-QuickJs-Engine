package states;

class PageItem
{
	public var id:String = '';
	public var label:String = '';
	public var state:String = null;
	public var callbackName:String = null;
	public var enabled:Bool = true;
	public var visible:Bool = true;

	public function new(id:String = '', ?label:String = null)
	{
		this.id = id;
		this.label = (label != null && label.length > 0) ? label : id;
	}
}
