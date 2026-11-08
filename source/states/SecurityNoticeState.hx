package states;

import backend.Paths;
import backend.Qz7r;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class SecurityNoticeState extends FlxState
{
	public static var instance:SecurityNoticeState = null;

	public static inline var TITLE:String = "ILLEGAL PACKAGE MODIFICATION";
	public static inline var BODY:String =
		"This copy of the game was modified or re-signed.\n" +
		"To keep your device and your saves safe, all mods and scripts\n" +
		"have been disabled in this session.\n\n" +
		"Download the official build and install it again.";
	public static inline var CONTINUE_LABEL:String = "CONTINUE WITHOUT MODS";
	public static inline var EXIT_LABEL:String = "EXIT";
	public static inline var YELLOW:Int = 0xFFFFFF00;
	public static inline var RED:Int = 0xFFFF0000;
	public static inline var ORANGE:Int = 0xFFFFA500;
	public static inline var GRAY:Int = 0xFFAAAAAA;

	var icon:FlxSprite = null;
	var continueText:FlxText = null;
	var exitText:FlxText = null;
	var blockInput:Bool = false;
	var overText:String = "";
	var quitGame:Dynamic = null;
	var continueGame:Dynamic = null;

	public function new()
	{
		super();
		if (instance == null) instance = this;
	}

	public static function boot():SecurityNoticeState
	{
		if (instance == null) instance = new SecurityNoticeState();
		return instance;
	}

	public static function show():Void
	{
		if (Qz7r.instance != null && Qz7r.instance.scriptsAllowed) return;
		FlxG.switchState(new SecurityNoticeState());
	}

	override public function create():Void
	{
		super.create();
		blockInput = true;
		// grainy dark-maroon background (sampled from the original: base 0x2D1427
		// with per-pixel darkening toward 0x12080D)
		bgColor = 0xFF2D1427;
		var bgNoise:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF2D1427, true);
		var bmp:openfl.display.BitmapData = bgNoise.pixels;
		for (py in 0...bmp.height)
			for (px in 0...bmp.width)
			{
				var dR:Int = FlxG.random.int(0, 27);
				var dG:Int = FlxG.random.int(0, 12);
				var dB:Int = FlxG.random.int(0, 26);
				if (dR + dG + dB > 0)
					bmp.setPixel32(px, py, 0xFF000000 | ((45 - dR) << 16) | ((20 - dG) << 8) | (39 - dB));
			}
		bgNoise.pixels = bmp;
		bgNoise.scrollFactor.set();
		add(bgNoise);

		icon = new FlxSprite(0, 0);
		icon.loadGraphic(Paths.image('warn_icon'));
		if (icon.width > 1)
		{
			icon.scale.set(0.5, 0.5); // extracted: the original scales the icon to half its native size
			icon.updateHitbox();
			icon.antialiasing = true;
		}
		icon.screenCenter(X);
		icon.y = 96; // extracted constant from the original arm64 build
		add(icon);

		var title:FlxText = new FlxText(0, 0, FlxG.width, TITLE, 26);
		title.y = icon.y + icon.height + 26; // chained below the icon (gap 26, from disassembly)
		title.alignment = CENTER;
		title.color = 0xFFFF5555; // extracted from the original arm64 build
		title.font = Paths.font("vcr.ttf");
		add(title);

		var body:FlxText = new FlxText(20, 0, FlxG.width - 40, BODY, 20);
		body.y = title.y + title.height + 22; // chained below the title (gap 22)
		body.alignment = CENTER;
		body.color = 0xFFFFFFFF;
		body.font = Paths.font("vcr.ttf");
		add(body);

		continueText = new FlxText(0, 0, FlxG.width, CONTINUE_LABEL, 24);
		continueText.y = body.y + body.height + 46; // chained below the body (gap 46)
		continueText.alignment = CENTER;
		continueText.color = 0xFFFFC733; // extracted from the original arm64 build
		continueText.font = Paths.font("vcr.ttf");
		add(continueText);

		exitText = new FlxText(0, 0, FlxG.width, EXIT_LABEL, 22);
		exitText.y = continueText.y + continueText.height + 46; // chained below CONTINUE (gap 46)
		exitText.alignment = CENTER;
		exitText.color = 0xFFAAAAAA; // extracted from the original arm64 build
		exitText.font = Paths.font("vcr.ttf");
		add(exitText);

		continueGame = onContinue;
		quitGame = onQuit;
		blockInput = false;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (blockInput) return;
		overText = "";
		if (FlxG.mouse.overlaps(continueText, FlxG.camera))
		{
			overText = CONTINUE_LABEL;
			continueText.color = YELLOW;
		}
		else
			continueText.color = 0xFFFFC733;
		if (FlxG.mouse.overlaps(exitText, FlxG.camera))
		{
			overText = EXIT_LABEL;
			exitText.color = RED;
		}
		else
			exitText.color = 0xFFAAAAAA;
		if (!FlxG.mouse.justPressed) return;
		if (overText == CONTINUE_LABEL) onContinue();
		else if (overText == EXIT_LABEL) onQuit();
	}

	function onContinue():Void
	{
		if (Qz7r.instance != null)
		{
			Qz7r.instance.scriptsAllowed = false;
			Qz7r.instance.dismiss();
		}
		TitleState.initialized = false; // the security roundtrip must not consume the intro
		FlxG.switchState(new TitleState());
	}

	function onQuit():Void
	{
		#if sys
		Sys.exit(0);
		#end
	}

	override public function destroy():Void
	{
		FlxG.camera.bgColor = FlxColor.BLACK; // do not leak the maroon bg into the next state
		super.destroy();
	}
}
