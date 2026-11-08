package objects;

import flixel.addons.display.FlxPieDial;

#if hxvlc
import hxvlc.flixel.FlxVideoSprite;
#end

class VideoSprite extends FlxSpriteGroup {
	#if VIDEOS_ALLOWED
	public var finishCallback:Void->Void = null;
	public var onSkip:Void->Void = null;

	final _timeToSkip:Float = 1;
	public var holdingTime:Float = 0;
	public var videoSprite:FlxVideoSprite;
	public var skipSprite:FlxPieDial;
	public var cover:FlxSprite;
	public var canSkip(default, set):Bool = false;

	private var videoName:String;

	public var waiting:Bool = false;
	public var didPlay:Bool = false;

	public function new(videoName:String, isWaiting:Bool, canSkip:Bool = false, shouldLoop:Dynamic = false) {
		super();

		this.videoName = videoName;
		scrollFactor.set();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		waiting = isWaiting;
		if(!waiting)
		{
			cover = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
			cover.scale.set(FlxG.width + 100, FlxG.height + 100);
			cover.screenCenter();
			cover.scrollFactor.set();
			add(cover);
		}

		// initialize sprites
		videoSprite = new FlxVideoSprite();
		videoSprite.antialiasing = ClientPrefs.data.antialiasing;
		add(videoSprite);
		if(canSkip) this.canSkip = true;

		// callbacks
		if(!shouldLoop)
		{
			videoSprite.bitmap.onEndReached.add(function() {
				if(alreadyDestroyed) return;
	
				trace('Video destroyed');
				if(cover != null)
				{
					remove(cover);
					cover.destroy();
				}
		
				PlayState.instance.remove(this);
				destroy();
				alreadyDestroyed = true;
			});
		}

		videoSprite.bitmap.onFormatSetup.add(function()
		{
			/*
			#if hxvlc
			var wd:Int = vidBmpWidth();
			var hg:Int = vidBmpHeight();
			trace('Video Resolution: ${wd}x${hg}');
			videoSprite.scale.set(FlxG.width / wd, FlxG.height / hg);
			#end
			*/
			videoSprite.setGraphicSize(FlxG.width);
			videoSprite.updateHitbox();
			videoSprite.screenCenter();
		});

		// start video and adjust resolution to screen size
		videoSprite.load(videoName, shouldLoop ? ['input-repeat=65545'] : null);
	}

	var alreadyDestroyed:Bool = false;
	override function destroy()
	{
		if(alreadyDestroyed)
		{
			super.destroy();
			return;
		}

		trace('Video destroyed');
		if(cover != null)
		{
			remove(cover);
			cover.destroy();
		}

		if(finishCallback != null)
			finishCallback();
		onSkip = null;

		PlayState.instance.remove(this);
		super.destroy();
	}

	override function update(elapsed:Float)
	{
		if(canSkip)
		{
			if(Controls.instance.pressed('accept'))
			{
				holdingTime = Math.max(0, Math.min(_timeToSkip, holdingTime + elapsed));
			}
			else if (holdingTime > 0)
			{
				holdingTime = Math.max(0, FlxMath.lerp(holdingTime, -0.1, FlxMath.bound(elapsed * 3, 0, 1)));
			}
			updateSkipAlpha();

			if(holdingTime >= _timeToSkip)
			{
				if(onSkip != null) onSkip();
				finishCallback = null;
				videoSprite.bitmap.onEndReached.dispatch();
				PlayState.instance.remove(this);
				trace('Skipped video');
				return;
			}
		}
		super.update(elapsed);
	}

	function set_canSkip(newValue:Bool)
	{
		canSkip = newValue;
		if(canSkip)
		{
			if(skipSprite == null)
			{
				skipSprite = new FlxPieDial(0, 0, 40, FlxColor.WHITE, 40, true, 24);
				skipSprite.replaceColor(FlxColor.BLACK, FlxColor.TRANSPARENT);
				skipSprite.x = FlxG.width - (skipSprite.width + 80);
				skipSprite.y = FlxG.height - (skipSprite.height + 72);
				skipSprite.amount = 0;
				add(skipSprite);
			}
		}
		else if(skipSprite != null)
		{
			remove(skipSprite);
			skipSprite.destroy();
			skipSprite = null;
		}
		return canSkip;
	}

	function updateSkipAlpha()
	{
		if(skipSprite == null) return;

		skipSprite.amount = Math.min(1, Math.max(0, (holdingTime / _timeToSkip) * 1.025));
		skipSprite.alpha = FlxMath.remapToRange(skipSprite.amount, 0.025, 1, 0, 1);
	}

	public function resume() videoSprite?.resume();
	public function pause() videoSprite?.pause();
	#end

	public var muteMusic(default, set):Bool = false;
	var autoLayout:String = 'fill';

	function set_muteMusic(v:Bool):Bool
	{
		muteMusic = v;
		if (v) muteMenuMusic(); else unmuteMenuMusic();
		return v;
	}

	/** Lay the video out at an explicit rect (x, y, w, h). */
	public function applyCustomLayout(x:Float, y:Float, w:Float, h:Float):Void
	{
		autoLayout = 'custom';
		setVideoPosition(x, y);
		setVideoSize(w, h);
	}

	/** Re-apply the current auto layout once the video format is known. */
	public function applyFormat():Void
	{
		#if hxvlc
		if (videoSprite == null || videoSprite.bitmap == null) return;
		switch (autoLayout)
		{
			case 'fit': fitScreen();
			case 'custom': /* keep explicit rect */
			default: fillScreen();
		}
		#end
	}

	/** Scale the video up to cover the whole screen, keeping aspect ratio. */
	public function fillScreen():Void
	{
		#if hxvlc
		if (videoSprite == null || videoSprite.bitmap == null) return;
		var wd:Int = vidBmpWidth();
		var hg:Int = vidBmpHeight();
		if (wd <= 0 || hg <= 0) return;
		var s:Float = Math.max(FlxG.width / wd, FlxG.height / hg);
		videoSprite.scale.set(s, s);
		videoSprite.updateHitbox();
		videoSprite.screenCenter();
		#end
	}

	/** Scale the video to fit inside the screen, keeping aspect ratio. */
	public function fitScreen():Void
	{
		#if hxvlc
		if (videoSprite == null || videoSprite.bitmap == null) return;
		var wd:Int = vidBmpWidth();
		var hg:Int = vidBmpHeight();
		if (wd <= 0 || hg <= 0) return;
		var s:Float = Math.min(FlxG.width / wd, FlxG.height / hg);
		videoSprite.scale.set(s, s);
		videoSprite.updateHitbox();
		videoSprite.screenCenter();
		#end
	}

	/** Force the video to end now, running the normal finish path. */
	public function finishVideo():Void
	{
		if (alreadyDestroyed) return;
		#if hxvlc
		if (videoSprite != null) videoSprite.stop();
		#end
		destroy();
		alreadyDestroyed = true;
	}

	public function getVideoHeight():Int
	{
		#if hxvlc
		if (videoSprite != null && videoSprite.bitmap != null) return vidBmpHeight();
		#end
		return 0;
	}

	public function getVideoWidth():Int
	{
		#if hxvlc
		if (videoSprite != null && videoSprite.bitmap != null) return vidBmpWidth();
		#end
		return 0;
	}

	public function getVideoX():Float
	{
		#if hxvlc
		if (videoSprite != null) return videoSprite.x;
		#end
		return 0;
	}

	public function getVideoY():Float
	{
		#if hxvlc
		if (videoSprite != null) return videoSprite.y;
		#end
		return 0;
	}

	public function get_musicMuted():Bool
	{
		return muteMusic;
	}

	/** Re-insert this video at the bottom of the parent's render order. */
	public function moveCameraBelow():Void
	{
		if (FlxG.state == null) return;
		if (FlxG.state.members.indexOf(this) > 0)
		{
			FlxG.state.remove(this);
			FlxG.state.insert(0, this);
		}
	}

	public function muteMenuMusic():Void
	{
		if (FlxG.sound.music != null) FlxG.sound.music.volume = 0;
	}

	public function onFormatSetup():Void
	{
		applyFormat();
	}

	public function onVideoEnded():Void
	{
		finishVideo();
	}

	public function play():Void
	{
		#if hxvlc
		if (videoSprite != null) videoSprite.resume();
		#end
		didPlay = true;
	}

	public function setAutoLayout(mode:String):Void
	{
		if (mode == null) return;
		autoLayout = mode.toLowerCase().trim();
		applyFormat();
	}

	public function setRate(rate:Float):Void
	{
		#if hxvlc
		try { if (videoSprite != null && videoSprite.bitmap != null) videoSprite.bitmap.rate = rate; }
		catch (e:Dynamic) {}
		#end
	}

	public function setVideoPosition(x:Float, y:Float):Void
	{
		#if hxvlc
		if (videoSprite != null) videoSprite.setPosition(x, y);
		#end
	}

	public function setVideoScale(sx:Float, ?sy:Float):Void
	{
		#if hxvlc
		if (videoSprite != null) videoSprite.scale.set(sx, sy != null ? sy : sx);
		#end
	}

	public function setVideoSize(w:Float, h:Float):Void
	{
		#if hxvlc
		if (videoSprite == null) return;
		videoSprite.scale.set(w / videoSprite.frameWidth, h / videoSprite.frameHeight);
		videoSprite.updateHitbox();
		#end
	}

	/** Re-insert this video at the top of the parent's render order. */
	public function topCamera():Void
	{
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		if (FlxG.state == null) return;
		if (FlxG.state.members.indexOf(this) >= 0 && FlxG.state.members.indexOf(this) < FlxG.state.members.length - 1)
		{
			FlxG.state.remove(this);
			FlxG.state.add(this);
		}
	}

	public function unmuteMenuMusic():Void
	{
		if (FlxG.sound.music != null && !PlayState.isStoryMode) FlxG.sound.music.volume = 1;
	}

	// hxvlc 2.0.1: video dimensions live on the video's BitmapData once the format is set up
	function vidBmpWidth():Int
	{
		var bmp = videoSprite.bitmap.bitmapData;
		return bmp != null ? bmp.width : 0;
	}

	function vidBmpHeight():Int
	{
		var bmp = videoSprite.bitmap.bitmapData;
		return bmp != null ? bmp.height : 0;
	}
}
