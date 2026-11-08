package backend;

class HitchLog
{
	public static var instance:HitchLog = null;
	var nextFrame:Dynamic = null;

	public function new()
	{
		if (instance == null) instance = this;
	}

	public function begin():Void
	{
		frameStart = haxe.Timer.stamp();
	}

	public function report(thresholdMs:Float):Void
	{
		var now:Float = haxe.Timer.stamp();
		var ms:Float = (now - frameStart) * 1000;
		if (ms > thresholdMs)
		{
			trace("[HitchLog] frame took " + round2(ms) + "ms (threshold " + thresholdMs + ")");
			hitches++;
			if (hitches >= 10)
			{
				trace("[HitchLog] " + hitches + " hitches recorded this session");
				hitches = 0;
			}
		}
		frameStart = now;
	}

	public function round2(f:Float):Float
	{
		return Math.round(f * 100) / 100;
	}

	public function track(tag:String):Void
	{
		var now:Float = haxe.Timer.stamp();
		var last:Float = marks.exists(tag) ? marks.get(tag) : now;
		marks.set(tag, now);
		var ms:Float = (now - last) * 1000;
		if (ms > 100) trace("[HitchLog] " + tag + " gap: " + round2(ms) + "ms");
	}
}
