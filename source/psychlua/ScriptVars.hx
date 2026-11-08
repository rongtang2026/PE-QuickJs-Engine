package psychlua;

using StringTools;

class ScriptVars
{
	public static var instance:ScriptVars = null;
	var vars:Map<String, Dynamic> = new Map<String, Dynamic>();

	public function new()
	{
		if (instance == null) instance = this;
	}

	public static function boot():Void
	{
		if (instance == null) instance = new ScriptVars();
	}

	public function key(name:String):String
	{
		return name == null ? '' : name.trim();
	}

	public function exists(name:String):Bool
	{
		return vars.exists(key(name));
	}

	public function get(name:String):Dynamic
	{
		return vars.get(key(name));
	}

	public function set(name:String, value:Dynamic):Void
	{
		vars.set(key(name), value);
	}

	public function remove(name:String):Void
	{
		vars.remove(key(name));
	}
}
