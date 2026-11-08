package substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import backend.RenderBackend;

class VulkanWarningSubState extends flixel.FlxSubState
{
	public static inline var TITLE:String = "EXPERIMENTAL RENDERER";
	public static inline var BODY:String =
		"The Vulkan renderer is still experimental.
" +
		"Sprites can go missing, frames can go black
" +
		"and some drivers may crash.
" +
		"It also needs a full restart to take effect.
" +
		"OpenGL stays the recommended option.";
	public static inline var QUESTION:String = "Switch to Vulkan anyway?";
	public static inline var YES_LABEL:String = "YES";
	public static inline var NO_LABEL:String = "NO";

	public var title:Alphabet;
	public var body:FlxText;
	public var yesText:Alphabet;
	public var noText:Alphabet;
	public var onYes:Void->Void;

	var yesSelected:Bool = true;

	public function updateOptions():Void
	{
		RenderBackend.setVulkan(true);
		close();
	}

	override function create():Void
	{
		super.create();
		onYes = updateOptions;

		var dim:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xB0000000);
		dim.scrollFactor.set();
		add(dim);

		title = new Alphabet(0, Std.int(FlxG.height * 0.26), TITLE, true);
		title.screenCenter(X);
		title.y = FlxG.height * 0.26;
		for (letter in title.letters)
			letter.color = FlxColor.ORANGE;
		add(title);

		body = new FlxText(40, Std.int(FlxG.height * 0.38), FlxG.width - 80, BODY, 18);
		body.setFormat("VCR OSD Mono", 18, FlxColor.WHITE, CENTER);
		add(body);

		var question:FlxText = new FlxText(0, Std.int(FlxG.height * 0.59), FlxG.width, QUESTION, 20);
		question.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, CENTER);
		add(question);

		// fixed per-letter colors extracted from the original arm64 build:
		// YES = 0xFFFF5555, NO = 0xFF55FF88
		yesText = new Alphabet(0, Std.int(FlxG.height * 0.68), YES_LABEL, true);
		yesText.screenCenter(X);
		yesText.x -= FlxG.width * 0.17;
		yesText.y = FlxG.height * 0.68;
		for (letter in yesText.letters) letter.color = 0xFFFF5555;
		add(yesText);

		noText = new Alphabet(0, Std.int(FlxG.height * 0.68), NO_LABEL, true);
		noText.screenCenter(X);
		noText.x += FlxG.width * 0.17;
		noText.y = FlxG.height * 0.68;
		for (letter in noText.letters) letter.color = 0xFF55FF88;
		add(noText);
	}

	function updateSelection():Void
	{
		yesText.alpha = yesSelected ? 1 : 0.35;
		noText.alpha = yesSelected ? 0.35 : 1;
	}

	function tapChoice():Void
	{
		if (FlxG.mouse.overlaps(yesText, camera) && FlxG.mouse.justPressed) choose(true);
		else if (FlxG.mouse.overlaps(noText, camera) && FlxG.mouse.justPressed) choose(false);
	}

	function choose(yes:Bool):Void
	{
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		yesSelected = yes;
		updateSelection();
		if (yes) onYes();
		else { RenderBackend.setVulkan(false); close(); }
	}

	override function update(elapsed:Float):Void
	{
		tapChoice();
		if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN)
		{
			yesSelected = !yesSelected;
			updateSelection();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
		}
		if (FlxG.keys.justPressed.ENTER) choose(yesSelected);
		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'), 0.7);
			RenderBackend.setVulkan(false);
			close();
		}
		super.update(elapsed);
	}
}
