
package backend;

class MenuScriptHost
{
	var scripts:Map<String, Dynamic> = new Map<String, Dynamic>();
	var callbacks:Map<String, Dynamic> = new Map<String, Dynamic>();
	var checked:Map<String, Bool> = new Map<String, Bool>();

	public function new() {}

	public function add(name:String, script:Dynamic):Void scripts.set(name, script);
	public function remove(name:String):Void { scripts.remove(name); callbacks.remove(name); checked.remove(name); }
	public function clear():Void { scripts = new Map(); callbacks = new Map(); checked = new Map(); }
	public function setCallback(name:String, cb:Dynamic):Void callbacks.set(name, cb);
	public function callbackOf(name:String):Dynamic return callbacks.get(name);
	public function check(name:String):Bool return checked.exists(name) && checked.get(name);
	public function update(?data:Dynamic):Void
	{
		for (k in callbacks.keys())
		{
			var cb:Dynamic = callbacks.get(k);
			if (cb != null) Reflect.callMethod(null, cb, [data]);
		}
	}
}
