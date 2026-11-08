package backend;

class VideoAudio
{
	public static var instance:VideoAudio = null;
	var mute:Dynamic = null;
	var unmute:Dynamic = null;

	public function new()
	{
		if (instance == null) instance = this;
	}

	public function reset():Void
	{
		if (FlxG.sound.music != null) FlxG.sound.music.volume = 1;
	}
}
