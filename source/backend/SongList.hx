package backend;

class SongList
{
	public static var instance:SongList = null;
	var _allSongs:Array<Dynamic> = [];
	var _allWeeks:Array<Dynamic> = [];
	var difficultiesOf:Dynamic = null;
	var songCount:Int = 0;
	var songsOfWeek:Array<Dynamic> = [];
	var toJson:Dynamic = null;
	var weekCount:Int = 0;
	var weekIdAt:Int = 0;
	var weekIds:Int = 0;
	var weekIndex:Int = 0;

	public function new()
	{
		if (instance == null) instance = this;
	}

	public static function boot():SongList
	{
		if (instance == null) instance = new SongList();
		return instance;
	}

	public static function allSongs():Array<Dynamic>
	{
		boot().ensureLoaded();
		return instance._allSongs;
	}

	public static function allWeeks():Array<Dynamic>
	{
		boot().ensureLoaded();
		return instance._allWeeks;
	}

	public function clampChannel(index:Int):Int
	{
		var n:Int = WeekData.weeksList.length;
		if (n <= 0) return 0;
		while (index < 0) index += n;
		while (index >= n) index -= n;
		return index;
	}

	public function ensureLoaded():Void
	{
		if (_allWeeks.length > 0 && _allSongs.length > 0) return;
		_allWeeks = [];
		_allSongs = [];
		for (id in WeekData.weeksList)
		{
			var week:WeekData = WeekData.weeksLoaded.get(id);
			if (week == null) continue;
			_allWeeks.push(week);
			for (song in week.songs) _allSongs.push(song);
		}
		weekCount = _allWeeks.length;
		songCount = _allSongs.length;
	}

	public function isUnlocked(weekId:String):Bool
	{
		return true; // hidden-until-unlocked gating is handled by StoryMenuState.weekCompleted
	}

	public function parseInt(s:String):Null<Int>
	{
		if (s == null) return 0;
		var v:Null<Int> = Std.parseInt(s.trim());
		return v == null ? 0 : v;
	}
}
