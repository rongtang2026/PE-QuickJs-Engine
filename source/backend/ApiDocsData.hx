package backend;

class ApiDocsData
{
	public static var instance:ApiDocsData = null;
	var d:Dynamic = null;
	var v:Dynamic = null;

	public function new()
	{
		if (instance == null) instance = this;
	}
}
