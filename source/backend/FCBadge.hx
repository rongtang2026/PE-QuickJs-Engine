package backend;

class FCBadge
{
	public static var instance:FCBadge = null;
	var comesBefore:Dynamic = null;
	var matches:Dynamic = null;
	var sorted:Dynamic = null;

	public function new()
	{
		if (instance == null) instance = this;
	}
}
