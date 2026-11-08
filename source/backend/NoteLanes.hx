package backend;

class NoteLanes
{
	public static var instance:NoteLanes = null;
	var actionForKey:String = "";
	var actionsFor:Dynamic = null;
	var activeCount:Int = 0;
	var directionFor:String = "";
	var laneAt:Dynamic = null;
	var newLane:Dynamic = null;
	var resizeLanes:Int = 0;

	public function new()
	{
		if (instance == null) instance = this;
	}

	public function clampKeys(keys:Int):Int
	{
		if (keys < 1) return 4;
		if (keys > 18) return 18;
		return keys;
	}

	public function createLanes(count:Int):Int
	{
		return clampKeys(count);
	}
}
