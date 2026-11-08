package mobile;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;

class VirtualPad extends FlxSpriteGroup
{
	public static var instance:VirtualPad = null;

	public var buttons:flixel.group.FlxGroup.FlxTypedGroup<mobile.TouchButton> = new flixel.group.FlxGroup.FlxTypedGroup<mobile.TouchButton>();
	public var dpadMode:Int = 0;
	public var actionMode:Int = 0;

	public static inline var MODE_NONE:Int = 0;
	public static inline var MODE_RIGHT_FULL:Int = 1;
	public static inline var MODE_LEFT_FULL:Int = 2;
	public static inline var MODE_BOTH:Int = 3;

	public static inline var ACTION_NONE:Int = 0;
	public static inline var ACTION_A:Int = 1;
	public static inline var ACTION_A_B:Int = 2;
	public static inline var ACTION_A_B_C:Int = 3;

	public function new(dpadMode:Int = 0, actionMode:Int = 0)
	{
		super();
		instance = this;
		this.dpadMode = dpadMode;
		this.actionMode = actionMode;
		if (dpadMode != MODE_NONE) createDPad(dpadMode);
		if (actionMode != ACTION_NONE) createActionButtons(actionMode);
	}

	public function createButton(x:Float, y:Float, tag:String, ?labelText:String = null):mobile.TouchButton
	{
		var btn:mobile.TouchButton = new mobile.TouchButton(x, y, tag, labelText);
		// flixel's built-in android control textures (same art FlxVirtualPad uses)
		var frame = flixel.system.FlxAssets.getVirtualInputFrames().getByName(tag);
		if (frame != null)
		{
			var art:flixel.FlxSprite = new flixel.FlxSprite(0, 0);
			art.frames = flixel.graphics.frames.FlxTileFrames.fromFrame(frame, flixel.math.FlxPoint.get(44, 45));
			art.animation.addByIndices('idle', '', [0], '', 0, false);
			art.animation.addByIndices('press', '', [2], '', 0, false);
			art.animation.play('idle');
			art.scale.set(2, 2);
			art.updateHitbox();
			art.scrollFactor.set();
			btn.insert(0, art);
			btn.artSprite = art;
			btn.label.visible = false;
			btn.scrollFactor.set();
		}
		buttons.add(btn);
		add(btn);
		return btn;
	}

	function createDPad(mode:Int):Void
	{
		var padX:Float = (mode == MODE_LEFT_FULL || mode == MODE_BOTH) ? 20 : FlxG.width - 280;
		var baseY:Float = FlxG.height - 280;
		createButton(padX + 130, baseY, 'up');
		createButton(padX + 130, baseY + 140, 'down');
		createButton(padX, baseY + 70, 'left');
		createButton(padX + 260, baseY + 70, 'right');
	}

	function createActionButtons(mode:Int):Void
	{
		var ax:Float = FlxG.width - 130;
		createButton(ax, FlxG.height - 150, 'a');
		if (mode >= ACTION_A_B) createButton(ax - 140, FlxG.height - 150, 'b');
		if (mode >= ACTION_A_B_C) createButton(ax - 70, FlxG.height - 290, 'c');
	}

	/** Frame atlas used by custom pad skins. */
	public function getTileFrames(path:String):Dynamic
	{
		return flixel.FlxG.state != null ? path : path;
	}

	/** Frame atlas for the input visualization layer. */
	public function getVirtualInputFrames(path:String):Dynamic
	{
		return getTileFrames(path);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		buttons.update(elapsed);
	}

	override public function destroy():Void
	{
		if (instance == this) instance = null;
		super.destroy();
	}
}
