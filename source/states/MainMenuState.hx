package states;

import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import states.editors.MasterEditorMenu;
import options.OptionsState;
import backend.MenuUIItem;
import backend.MenuGestures;
import backend.MenuUI;
import psychlua.MenuScripts;
import psychlua.FunkinJS;

enum MainMenuColumn {
	LEFT;
	CENTER;
	RIGHT;
}

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '1.0'; // This is also used for Discord RPC
	public static var curSelected:Int = 0;
	public static var curColumn:MainMenuColumn = CENTER;

	var allowMouse:Bool = true; //Turn this off to block mouse movement in menus
	var timeNotMoving:Float = 0;
	var selectedSomethin:Bool = false;

	var menuItems:flixel.group.FlxGroup.FlxTypedGroup<FlxSprite>;
	var leftItem:FlxSprite;
	var rightItem:FlxSprite;

	//Centered/Text options
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'credits'
	];

	var leftOption:String = 'achievements';
	var rightOption:String = 'options';

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var bg:FlxSprite;

	// script-facing additions (FunkinJS menu API)
	var scriptButtons:Array<MenuUIItem> = [];
	var gestures:MenuGestures = new MenuGestures();
	var scripts:MenuScripts = new MenuScripts();

	override function create()
	{
		MenuUI.clear();

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = 0.25;
		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);
		MenuUI.register('bg', bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);
		MenuUI.register('magenta', magenta);

		menuItems = new flixel.group.FlxGroup.FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (num => option in optionShit)
		{
			var item:FlxSprite = createMenuItem(option, 0, (num * 140) + 90);
			item.y += (4 - optionShit.length) * 70; // Offsets for when you have anything other than 4 items
			item.screenCenter(X);
			MenuUI.register('menu_' + option, item);
			MenuUI.register(option, item);
		}
		if (leftOption != null)
			leftItem = createMenuItem(leftOption, 60, 490);
		if (rightOption != null)
		{
			rightItem = createMenuItem(rightOption, FlxG.width - 60, 490);
			rightItem.x -= rightItem.width;
		}
		if (leftItem != null) MenuUI.register('side_' + leftOption, leftItem);
		if (rightItem != null) MenuUI.register('side_' + rightOption, rightItem);

		var psychVer:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		psychVer.scrollFactor.set();
		psychVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(psychVer);
		MenuUI.register('gameVersion', psychVer);
		var fnfVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + lime.app.Application.current.meta.get('version'), 12);
		fnfVer.scrollFactor.set();
		fnfVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(fnfVer);
		MenuUI.register('fnfVersion', fnfVer);
		FunkinJS.bind(this);
		changeItem();
		scripts.enterPage('main');
		scripts.startPage('main');
		scripts.call('onCreate');
		gestures.reset();

		super.create();
		FlxG.camera.follow(camFollow, null, 0.15);
	}

	function createMenuItem(name:String, x:Float, y:Float):FlxSprite
	{
		var menuItem:FlxSprite = new FlxSprite(x, y);
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_$name');
		menuItem.animation.addByPrefix('idle', '$name idle', 24, true);
		menuItem.animation.addByPrefix('selected', '$name selected', 24, true);
		menuItem.animation.play('idle');
		menuItem.updateHitbox();

		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		menuItem.scrollFactor.set();
		menuItems.add(menuItem);
		return menuItem;
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume = Math.min(FlxG.sound.music.volume + 0.5 * elapsed, 0.8);

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			var allowMouse:Bool = allowMouse;
			if (allowMouse && ((FlxG.mouse.deltaScreenX != 0 && FlxG.mouse.deltaScreenY != 0) || FlxG.mouse.justPressed)) //FlxG.mouse.deltaScreenX/Y checks is more accurate than FlxG.mouse.justMoved
			{
				allowMouse = false;
				FlxG.mouse.visible = true;
				timeNotMoving = 0;

				var selectedItem:FlxSprite;
				switch(curColumn)
				{
					case CENTER:
						selectedItem = menuItems.members[curSelected];
					case LEFT:
						selectedItem = leftItem;
					case RIGHT:
						selectedItem = rightItem;
				}

				if(leftItem != null && FlxG.mouse.overlaps(leftItem))
				{
					allowMouse = true;
					if(selectedItem != leftItem)
					{
						curColumn = LEFT;
						changeItem();
					}
				}
				else if(rightItem != null && FlxG.mouse.overlaps(rightItem))
				{
					allowMouse = true;
					if(selectedItem != rightItem)
					{
						curColumn = RIGHT;
						changeItem();
					}
				}
				else
				{
					var dist:Float = -1;
					var distItem:Int = -1;
					for (i in 0...optionShit.length)
					{
						var memb:FlxSprite = menuItems.members[i];
						if(FlxG.mouse.overlaps(memb))
						{
							var distance:Float = Math.sqrt(Math.pow(memb.getGraphicMidpoint().x - FlxG.mouse.screenX, 2) + Math.pow(memb.getGraphicMidpoint().y - FlxG.mouse.screenY, 2));
							if (dist < 0 || distance < dist)
							{
								dist = distance;
								distItem = i;
								allowMouse = true;
							}
						}
					}

					if(distItem != -1 && selectedItem != menuItems.members[distItem])
					{
						curColumn = CENTER;
						curSelected = distItem;
						changeItem();
					}
				}
			}
			else
			{
				timeNotMoving += elapsed;
				if(timeNotMoving > 2) FlxG.mouse.visible = false;
			}

			switch(curColumn)
			{
				case CENTER:
					if(controls.UI_LEFT_P && leftOption != null)
					{
						curColumn = LEFT;
						changeItem();
					}
					else if(controls.UI_RIGHT_P && rightOption != null)
					{
						curColumn = RIGHT;
						changeItem();
					}

				case LEFT:
					if(controls.UI_RIGHT_P)
					{
						curColumn = CENTER;
						changeItem();
					}

				case RIGHT:
					if(controls.UI_LEFT_P)
					{
						curColumn = CENTER;
						changeItem();
					}
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT || (FlxG.mouse.justPressed && allowMouse))
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxG.mouse.visible = false;

				if (ClientPrefs.data.flashing)
					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				var item:FlxSprite;
				var option:String;
				switch(curColumn)
				{
					case CENTER:
						option = optionShit[curSelected];
						item = menuItems.members[curSelected];

					case LEFT:
						option = leftOption;
						item = leftItem;

					case RIGHT:
						option = rightOption;
						item = rightItem;
				}

				FlxFlicker.flicker(item, 1, 0.06, false, false, function(flick:FlxFlicker)
				{
					switch (option)
					{
						case 'story_mode':
							MusicBeatState.switchState(new StoryMenuState());
						case 'freeplay':
							MusicBeatState.switchState(new FreeplayState());

						case 'achievements':
							MusicBeatState.switchState(new AchievementsMenuState());
						case 'credits':
							MusicBeatState.switchState(new CreditsState());
						case 'options':
							MusicBeatState.switchState(new OptionsState());
							OptionsState.onPlayState = false;
							if (PlayState.SONG != null)
							{
								PlayState.SONG.arrowSkin = null;
								PlayState.SONG.splashSkin = null;
								PlayState.stageUI = 'normal';
							}
					}
				});

				for (memb in menuItems)
				{
					if(memb == item)
						continue;

					FlxTween.tween(memb, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
				}
			}
			#if desktop
			if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end

			// script buttons (click path)
			if (FlxG.mouse.justPressed)
			{
				for (b in scriptButtons)
				{
					if (b.hitTest(FlxG.mouse.x, FlxG.mouse.y))
					{
						if (b.callbackName != null) scripts.call(b.callbackName);
						break;
					}
				}
			}
		}

		scripts.call('onUpdate');
		gestures.update(elapsed);

		super.update(elapsed);
	}

	function changeItem(change:Int = 0)
	{
		if(change != 0) curColumn = CENTER;
		curSelected = FlxMath.wrap(curSelected + change, 0, optionShit.length - 1);
		FlxG.sound.play(Paths.sound('scrollMenu'));

		for (item in menuItems)
		{
			item.animation.play('idle');
			item.centerOffsets();
		}

		var selectedItem:FlxSprite;
		switch(curColumn)
		{
			case CENTER:
				selectedItem = menuItems.members[curSelected];
			case LEFT:
				selectedItem = leftItem;
			case RIGHT:
				selectedItem = rightItem;
		}
		selectedItem.animation.play('selected');
		selectedItem.centerOffsets();
		camFollow.y = selectedItem.getGraphicMidpoint().y;
	}

	// ------------------------------------------------------------------ script API

	public function selectMenuItem(index:Int):Void
	{
		curSelected = index;
		curColumn = CENTER;
		changeItem();
	}

	public function getMenuItemCount():Int
	{
		return optionShit.length;
	}

	public function addMenuItem(id:String, image:String, ?x:Float = null, ?y:Float = null, ?prefix:String = null, ?state:String = null):String
	{
		var sprite:FlxSprite = makeMenuItemSprite(image);
		if (x != null) sprite.x = x;
		if (y != null) sprite.y = y;
		add(sprite);
		MenuUI.register(id, sprite);
		return id;
	}

	public function addMenuItemGraphic(id:String, ?graphic:Dynamic = null, ?x:Float = null, ?y:Float = null):String
	{
		return addMenuItem(id, id, x, y);
	}

	public function addMenuItemSprite(id:String, sprite:FlxSprite, ?state:String = null):String
	{
		if (sprite == null) return '';
		add(sprite);
		MenuUI.register(id, sprite);
		return id;
	}

	public function addMenuItemText(id:String, text:String, ?size:Int = null, ?color:String = null, ?x:Float = null, ?y:Float = null):String
	{
		var t:FlxText = new FlxText(x != null ? x : 0, y != null ? y : 0, 0, text, size != null ? size : 20);
		t.setFormat(Paths.font("vcr.ttf"), size != null ? size : 20,
			color != null ? flixel.util.FlxColor.fromString('#' + color) : FlxColor.WHITE);
		add(t);
		MenuUI.register(id, t);
		return id;
	}

	function makeMenuItemSprite(image:String):FlxSprite
	{
		var s:FlxSprite = new FlxSprite();
		if (image != null)
		{
			try
			{
				s.frames = Paths.getAtlas('mainmenu/menu_' + image);
				s.animation.addByPrefix('idle', image + ' idle', 24, true);
				s.animation.addByPrefix('selected', image + ' selected', 24, true);
				s.animation.play('idle');
				s.antialiasing = ClientPrefs.data.antialiasing;
			}
			catch (e:Dynamic) {}
		}
		return s;
	}

	public function setBackgroundImage(path:String):Void
	{
		if (bg != null) try { bg.loadGraphic(Paths.image(path)); } catch (e:Dynamic) {}
	}

	public function addScriptButton(id:String, image:String, x:Float, y:Float, ?cb:String, ?scale:Float):String
	{
		var sprite:FlxSprite;
		if (image != null)
		{
			sprite = new FlxSprite(x, y);
			try { sprite.loadGraphic(Paths.image(image)); } catch (e:Dynamic) {}
			if (scale != null) sprite.scale.set(scale, scale);
		}
		else
		{
			// same button style as the Psych 1.0 chart editor (PsychUIButton)
			sprite = new PsychUIButton(Std.int(x), Std.int(y), 'Scripts', null, 110, 24);
		}
		add(sprite);
		var b = new MenuUIItem(id, sprite, id);
		b.callbackName = cb;
		scriptButtons.push(b);
		MenuUI.register(id, sprite);
		return id;
	}

	public function removeScriptButton(id:String):Void
	{
		for (i in 0...scriptButtons.length)
			if (scriptButtons[i].id == id)
			{
				var b = scriptButtons.splice(i, 1)[0];
				MenuUI.remove(b.tag);
				if (b.sprite != null) remove(b.sprite);
				return;
			}
	}

	public function setScriptButtonCallback(id:String, cb:String):Void
	{
		for (b in scriptButtons) if (b.id == id) b.callbackName = cb;
	}

	public function updateScriptButtons():Void
	{
		for (b in scriptButtons) b.apply();
	}
}
