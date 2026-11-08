
package backend;

class MenuNav
{
	public var busy:Bool = false;
	public var pendingTime:Float = 0;
	public var state:String = "";

	public function new() reset();

	public function reset():Void { busy = false; pendingTime = 0; state = ""; }
	public function canNavigate():Bool return !busy;
	public function markCurrentLeft():Void state = "left";

	public function update(elapsed:Float):Void
	{
		if (!busy) return;
		pendingTime -= elapsed;
		if (pendingTime <= 0) flush();
	}

	public function flush():Void { busy = false; pendingTime = 0; }

	public function toMenu(name:String):Void { if (canNavigate()) state = "menu:" + name; }
	public function toPage(page:String):Void { if (canNavigate()) state = "page:" + page; }
	public function toState(name:String):Void { if (canNavigate()) state = "state:" + name; }
	public function toURL(url:String):Void { if (canNavigate()) state = "url:" + url; }

	public function start():Void
	{
		reset();
	}
}
