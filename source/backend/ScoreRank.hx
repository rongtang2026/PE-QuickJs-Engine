package backend;

class ScoreRank
{
	public static var instance:ScoreRank = null;
	var comesBefore:Dynamic = null;

	public function new()
	{
		if (instance == null) instance = this;
	}

	public function find(score:Float):String
	{
		return getFor(score);
	}

	public function getFor(acc:Float):String
	{
		if (acc >= 100) return 'P';
		if (acc >= 90) return 'S';
		if (acc >= 80) return 'A';
		if (acc >= 70) return 'B';
		if (acc >= 60) return 'C';
		if (acc >= 50) return 'D';
		return 'F';
	}
}
