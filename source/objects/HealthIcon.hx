package objects;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isPlayer:Bool = false;
	private var char:String = '';

	private var iconOffsets:Array<Float> = [0, 0];
	public var autoAdjustOffset:Bool = true;
	public function new(char:String = 'face', isPlayer:Bool = false, ?allowGPU:Bool = true)
	{
		super();
		this.isPlayer = isPlayer;
		changeIcon(char, allowGPU);
		scrollFactor.set();
	}

	public function changeIcon(char:String, ?allowGPU:Bool = true) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			
			var graphic = Paths.image(name, allowGPU);
			var iSize:Float = Math.round(graphic.width / graphic.height);
			loadGraphic(graphic, true, Math.floor(graphic.width / iSize), Math.floor(graphic.height));
			iconOffsets[0] = (width - 150) / iSize;
			iconOffsets[1] = (height - 150) / iSize;
			updateHitbox();

			animation.add(char, [for(i in 0...frames.frames.length) i], 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			if(char.endsWith('-pixel'))
				antialiasing = false;
			else
				antialiasing = ClientPrefs.data.antialiasing;
		}
	}

	public function getCharacter():String {
		return char;
	}

	public function clampFrame(index:Int):Int
	{
		var total:Int = frames != null ? frames.frames.length : 1;
		if (index < 0) index = 0;
		if (index > total - 1) index = total - 1;
		return index;
	}

	public function pickFrame(health:Float, ?total:Int = -1):Int
	{
		if (total < 0) total = frames != null ? frames.frames.length : 1;
		if (total <= 1) return 0;
		var pct:Float = FlxMath.bound(health, 0, 100) / 100;
		return clampFrame(Math.round((total - 1) * (1 - pct)));
	}

	public var frameBands(default, set):Array<Float> = [];

	function set_frameBands(bands:Array<Float>):Array<Float>
	{
		return frameBands = bands;
	}

	public function setFrameBands(bands:Array<Float>):Void
	{
		frameBands = bands;
	}

	public function updateHealth(health:Float):Void
	{
		if (frames == null) return;
		animation.frameIndex = pickFrame(health);
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y - 30);
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		if(autoAdjustOffset)
		{
			offset.x = iconOffsets[0];
			offset.y = iconOffsets[1];
		}
	}

}
