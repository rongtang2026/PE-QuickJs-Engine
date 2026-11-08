package mobile;

class EditorKeyPads
{
	public static var instance:EditorKeyPads = null;
	var character:Dynamic = null;
	var charting:Dynamic = null;
	var combo:Dynamic = null;
	var dialogue:String = "";
	var dialogueCharacter:String = "";
	var menuCharacter:Dynamic = null;
	var noteSplash:Dynamic = null;
	var stage:Int = 0;
	var week:Dynamic = null;

	public function new()
	{
		if (instance == null) instance = this;
	}
}
