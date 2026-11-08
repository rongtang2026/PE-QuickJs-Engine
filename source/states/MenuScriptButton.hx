package states;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MenuScriptButton
{
	public static var instance:MenuScriptButton = null;

	public var text:FlxText = null;
	public var callbackName:String = null;

	public function new(?callbackName:String = null)
	{
		instance = this;
		this.callbackName = callbackName;
		applyState();
	}

	function applyState():Void
	{
		if (FlxG.state == null) return;
		text = new FlxText(FlxG.width - 120, FlxG.height - 28, 110, 'Scripts', 16);
		text.setFormat('VCR OSD Mono', 16, FlxColor.WHITE, flixel.text.FlxTextAlign.RIGHT);
		FlxG.state.add(text);
	}

	public function update():Void
	{
		if (text != null && FlxG.mouse.overlaps(text) && FlxG.mouse.justPressed && callbackName != null)
			psychlua.MenuScripts.boot().call(callbackName);
	}
}
