package mobile;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.ui.FlxButton;
import flixel.FlxSprite;

class Hitbox extends FlxSpriteGroup
{
	var hitboxframes:FlxAtlasFrames;
	var hitbox_hint:FlxSprite;

	public var hitbox:FlxSpriteGroup;
	public var buttonLeft:FlxButton;
	public var buttonDown:FlxButton;
	public var buttonUp:FlxButton;
	public var buttonRight:FlxButton;
	
	public function new()
	{
		super();

		hitbox = new FlxSpriteGroup();
		hitboxframes = Paths.getSparrowAtlas('androidcontrols/hitbox');
		hitbox.add(add(buttonLeft = createhitbox(0, "left")));
		hitbox.add(add(buttonDown = createhitbox(320, "down")));
		hitbox.add(add(buttonUp = createhitbox(640, "up")));
		hitbox.add(add(buttonRight = createhitbox(960, "right")));

		var hitbox_hint:FlxSprite = new FlxSprite(0, 0);
		hitbox_hint.loadGraphic(Paths.image('androidcontrols/hitbox_hint'));
		add(hitbox_hint);
	}

	public function createhitbox(buttonPozitionX:Float, framestring:String) {
        var graphic:FlxGraphic = FlxGraphic.fromFrame(hitboxframes.getByName(framestring));

		var button = new FlxButton(buttonPozitionX, 0);
        button.loadGraphic(graphic);
        button.alpha = 0;
    
        button.onDown.callback = function (){
            FlxTween.num(0, 0.75, 0.075, {ease:FlxEase.circInOut}, function(alpha:Float){ 
            	button.alpha = alpha;
            });
        };

        button.onUp.callback = function (){
            FlxTween.num(0.75, 0, 0.1, {ease:FlxEase.circInOut}, function(alpha:Float){ 
            	button.alpha = alpha;
            });
        }
        
        button.onOut.callback = function (){
            FlxTween.num(button.alpha, 0, 0.2, {ease:FlxEase.circInOut}, function(alpha:Float){ 
            	button.alpha = alpha;
            });
        }

        return button;
	}

	/**
		Creates a transparent touch zone button at an arbitrary rect (same
		fade-in/out behaviour as the four default hitbox buttons). The caller
		adds the returned button to a display group.
	**/
	public function createZone(x:Float, y:Float, width:Float, height:Float, ?tag:String = ''):FlxButton
	{
		var button:FlxButton = new FlxButton(x, y);
		button.makeGraphic(Std.int(Math.max(1, width)), Std.int(Math.max(1, height)), 0x00FFFFFF);
		button.alpha = 0;

		button.onDown.callback = function () {
			FlxTween.num(0, 0.75, 0.075, {ease:FlxEase.circInOut}, function(alpha:Float){
				button.alpha = alpha;
			});
		};

		button.onUp.callback = function () {
			FlxTween.num(0.75, 0, 0.1, {ease:FlxEase.circInOut}, function(alpha:Float){
				button.alpha = alpha;
			});
		}

		button.onOut.callback = function () {
			FlxTween.num(button.alpha, 0, 0.2, {ease:FlxEase.circInOut}, function(alpha:Float){
				button.alpha = alpha;
			});
		}

		return button;
	}

	/**
		Arranges the four hitbox buttons as equal-width vertical strips across
		the screen: left | down | up | right.
	**/
	public function layout():Void
	{
		var zoneW:Float = FlxG.width / 4;
		var zones:Array<FlxButton> = [buttonLeft, buttonDown, buttonUp, buttonRight];
		for (i => zone in zones)
		{
			if (zone == null) continue;
			zone.x = i * zoneW;
			zone.y = 0;
			zone.setGraphicSize(Std.int(zoneW), Std.int(FlxG.height));
			zone.updateHitbox();
		}
		if (hitbox_hint != null)
		{
			hitbox_hint.setGraphicSize(Std.int(FlxG.width), Std.int(FlxG.height));
			hitbox_hint.updateHitbox();
		}
	}

	/**
		Shrinks the hitbox height by a bottom safe-area inset (gesture bars),
		moving the strips up accordingly.
	**/
	public function setBottomInset(inset:Float):Void
	{
		var height:Int = Std.int(Math.max(1, FlxG.height - inset));
		var zones:Array<FlxButton> = [buttonLeft, buttonDown, buttonUp, buttonRight];
		for (zone in zones)
		{
			if (zone == null) continue;
			zone.setGraphicSize(Std.int(zone.width), height);
			zone.updateHitbox();
		}
		if (hitbox_hint != null)
		{
			hitbox_hint.setGraphicSize(Std.int(FlxG.width), height);
			hitbox_hint.updateHitbox();
		}
	}
	override public function destroy():Void
	{
		super.destroy();

		buttonLeft = null;
		buttonDown = null;
		buttonUp = null;
		buttonRight = null;
	}

}
