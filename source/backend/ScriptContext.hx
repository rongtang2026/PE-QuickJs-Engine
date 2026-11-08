package backend;

class ScriptContext
{
	public static var instance:ScriptContext = null;
	var current:Dynamic = null;
	var stack:Array<Dynamic> = [];

	public function new()
	{
		if (instance == null) instance = this;
	}

	public function pop():Dynamic
	{
		return stack.length > 0 ? stack.pop() : null;
	}

	public function push(ctx:Dynamic):Void
	{
		if (ctx != null) stack.push(ctx);
	}

	public function reset():Void
	{
		stack.resize(0);
	}
}
