
package backend;

class MenuGestures
{
	public static var instance:MenuGestures = null;

	public var startX:Float = 0;
	public var startY:Float = 0;
	public var downTime:Float = 0;
	public var dragThreshold:Float = 12;
	public var longPressTime:Float = 450;
	public var maxSwipeTime:Float = 400;
	public var swipeDistance:Float = 0;
	public var swipeThreshold:Float = 60;
	public var swipeDirection:String = "";
	public var longPressFired:Bool = false;
	public var swiped:Bool = false;
	public var dragStarted:Bool = false;
	public var dragEnded:Bool = false;
	public var longPress:Bool = false;
	public var blockedPoint:Bool = false;
	public var totalDx:Float = 0;
	public var totalDy:Float = 0;
	public var isDown:Bool = false;
	public var lastGesture:String = "";

	var consumed:Bool = false;

	public function new()
	{
		if (instance == null) instance = this;
		reset();
	}

	public function reset():Void
	{
		startX = startY = downTime = swipeDistance = totalDx = totalDy = 0;
		swipeDirection = "";
		longPressFired = swiped = dragStarted = dragEnded = longPress = blockedPoint = isDown = false;
		consumed = false;
		lastGesture = "";
	}

	public function isConsumed():Bool return consumed;

	public function directionOf(dx:Float, dy:Float):String
	{
		if (Math.abs(dx) > Math.abs(dy)) return dx > 0 ? "right" : "left";
		return dy > 0 ? "down" : "up";
	}

	public function dispatch(name:String, ?data:Dynamic):Void
	{
		lastGesture = name;
		if (name == "onMenuSwipe") swiped = true;
		else if (name == "onMenuLongPress") longPress = true;
		else if (name == "onMenuDragStart") dragStarted = true;
		else if (name == "onMenuDragEnd") dragEnded = true;
		consumed = false;
	}

	public function update(elapsed:Float):Void
	{
		if (!isDown || longPressFired) return;
		if (haxe.Timer.stamp() * 1000 - downTime >= longPressTime)
		{
			longPressFired = true;
			longPress = true;
			dispatch("onMenuLongPress");
		}
	}

	public function onMenuTouchDown(x:Float, y:Float):Void
	{
		startX = x; startY = y;
		downTime = haxe.Timer.stamp() * 1000;
		isDown = true;
		totalDx = totalDy = 0;
		longPressFired = swiped = dragStarted = dragEnded = false;
		consumed = false;
	}

	public function onMenuTouchMove(x:Float, y:Float):Void
	{
		totalDx = x - startX;
		totalDy = y - startY;
		if (!dragStarted && Math.abs(totalDx) + Math.abs(totalDy) > dragThreshold)
		{
			dragStarted = true;
			dispatch("onMenuDragStart");
		}
	}

	public function onMenuTouchUp(x:Float, y:Float):Void
	{
		isDown = false;
		if (dragStarted) { dragEnded = true; dispatch("onMenuDragEnd"); }
		swipeDistance = Math.sqrt(totalDx * totalDx + totalDy * totalDy);
		if (!longPressFired && swipeDistance >= swipeThreshold)
		{
			swipeDirection = directionOf(totalDx, totalDy);
			dispatch("onMenuSwipe", swipeDirection);
		}
		else if (!dragStarted && !longPressFired) dispatch("onMenuTap");
	}

	public function onMenuDragStart():Void { dragStarted = true; dispatch("onMenuDragStart"); }
	public function onMenuDragEnd():Void { dragEnded = true; dispatch("onMenuDragEnd"); }
	public function onMenuTap():Void dispatch("onMenuTap");
	public function onMenuLongPress():Void { longPress = true; dispatch("onMenuLongPress"); }
	public function onMenuSwipe(?dir:String):Void { swipeDirection = dir != null ? dir : swipeDirection; dispatch("onMenuSwipe", swipeDirection); }
}
