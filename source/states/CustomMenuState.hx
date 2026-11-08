package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

import backend.MenuUI;
import backend.MenuUIItem;
import backend.MenuGestures;
import backend.Paths;
import backend.ClientPrefs;
import psychlua.MenuScripts;

class CustomMenuState extends FlxState
{
	public var page:String = 'main';
	public var pageName:String = '';
	public var titleText:FlxText;
	public var menuBG:FlxSprite;
	public var backgroundImage:String = 'menuBG';
	public var dim:Float = 0;
	public var menuLocked:Bool = false;
	public var itemSpacing:Float = 58;
	public var layoutStartY:Float = 150;
	public var lastAutoY:Float = 0;
	public var hoverIndex:Int = -1;
	public var scrollOffset:Float = 0;
	public var selectedSomethin:Bool = false;
	public var inMenuFamily:Bool = false;

	var items:Array<MenuUIItem> = [];
	var scriptButtons:Array<MenuUIItem> = [];
	var pageStack:Array<String> = [];
	var itemStates:Map<String, String> = new Map();
	var itemCallbacks:Map<String, String> = new Map();
	var itemURLs:Map<String, String> = new Map();
	var itemPages:Map<String, String> = new Map();
	var gestures:MenuGestures = new MenuGestures();
	var scripts:MenuScripts = new MenuScripts();

	public function new(?page:String)
	{
		super();
		if (page != null) this.page = page;
	}

	public static function cleanId(v:String):String
	{
		if (v == null) return 'main';
		var out:String = '';
		for (i in 0...v.length)
		{
			var c:String = v.charAt(i);
			out += (~/[a-zA-Z0-9_\-]/.match(c)) ? c : '_';
		}
		return out.length > 0 ? out : 'main';
	}

	public function createBackground():Void
	{
		menuBG = new FlxSprite(-80).loadGraphic(Paths.image(backgroundImage));
		menuBG.antialiasing = ClientPrefs.data.antialiasing;
		menuBG.scrollFactor.set();
		menuBG.screenCenter();
		add(menuBG);
		MenuUI.register('bg', menuBG);
	}
	public function setBackgroundImage(path:String):Void
	{
		backgroundImage = path;
		if (menuBG != null) { try { menuBG.loadGraphic(Paths.image(path)); } catch (e:Dynamic) {} }
	}
	public function setBackgroundDim(v:Float):Void
	{
		dim = v;
		if (menuBG != null) menuBG.alpha = 1 - v;
	}
	public function createTitle(text:String):Void
	{
		titleText = new FlxText(0, 24, FlxG.width, text, 32);
		titleText.setFormat('VCR OSD Mono', 32, FlxColor.WHITE, CENTER);
		add(titleText);
		MenuUI.register('title', titleText);
	}
	public function setTitle(text:String):Void if (titleText != null) titleText.text = text;

	public function addPageText(id:String, text:String, ?x:Float, ?y:Float, ?size:Int, ?color:String):String
	{
		var t:FlxText = new FlxText(x != null ? x : 0, y != null ? y : lastAutoY, 0, text, size != null ? size : 24);
		t.setFormat(fontPath('vcr'), size != null ? size : 24,
			color != null ? FlxColor.fromString('#' + color) : FlxColor.WHITE);
		add(t);
		withItem(new MenuUIItem(id, t, text));
		lastAutoY += itemSpacing;
		return id;
	}
	public function addPageImage(id:String, image:String, ?x:Float, ?y:Float, ?scale:Float):String
	{
		var s:FlxSprite = new FlxSprite(x != null ? x : 0, y != null ? y : lastAutoY);
		try { s.loadGraphic(Paths.image(image)); } catch (e:Dynamic) {}
		applyImage(s, scale);
		add(s);
		withItem(new MenuUIItem(id, s, image));
		return id;
	}
	public function addPageImageFromFile(id:String, file:String, ?x:Float, ?y:Float, ?scale:Float):String
	{
		return addPageImage(id, file, x, y, scale);
	}
	public function addPageSprite(id:String, sprite:FlxSprite):String
	{
		if (sprite == null) return '';
		add(sprite);
		withItem(new MenuUIItem(id, sprite, id));
		return id;
	}
	public function applyImage(sprite:FlxSprite, ?scale:Float):Void
	{
		if (sprite == null) return;
		if (scale != null && scale > 0) { sprite.scale.set(scale, scale); sprite.updateHitbox(); }
	}
	public function scaleSprite(id:String, sx:Float, sy:Float):Void
	{
		var it:MenuUIItem = MenuUI.find(id);
		if (it != null && it.sprite != null) { it.sprite.scale.set(sx, sy); it.sprite.updateHitbox(); }
	}
	public function fontExists(name:String):Bool return true;
	public function fontPath(name:String):String return 'VCR OSD Mono';

	public function withItem(item:MenuUIItem):MenuUIItem
	{
		if (item == null) return null;
		items.push(item);
		if (item.sprite != null && !members.contains(item.sprite)) add(item.sprite);
		MenuUI.register(item.tag, item.sprite);
		item.apply();
		return item;
	}
	public function layoutItems(?startY:Float, ?spacing:Float):Void
	{
		if (startY != null) layoutStartY = startY;
		if (spacing != null) itemSpacing = spacing;
		for (i in 0...items.length)
		{
			var it:MenuUIItem = items[i];
			it.y = layoutStartY + i * itemSpacing;
			if (it.x == 0) it.sprite.screenCenter(X);
			it.apply();
		}
	}
	public function refreshItem(id:String):Void
	{
		var it:MenuUIItem = MenuUI.find(id);
		if (it != null) it.apply();
	}
	public function refresh():Void { layoutItems(); scripts.call('onPageUpdate', [pageName]); }

	public function setItemPos(id:String, x:Float, y:Float):Void { var it = find(id); if (it != null) { it.x = x; it.y = y; it.apply(); } }
	public function setItemColor(id:String, color:String):Void { var it = find(id); if (it != null) { it.color = FlxColor.fromString('#' + color); it.apply(); } }
	public function setItemScale(id:String, scale:Float):Void { var it = find(id); if (it != null) scaleSprite(id, scale, scale); }
	public function setItemEnabled(id:String, v:Bool):Void { var it = find(id); if (it != null) { it.enabled = v; it.apply(); } }
	public function setItemVisible(id:String, v:Bool):Void { var it = find(id); if (it != null) { it.visible = v; it.apply(); } }
	public function setItemState(id:String, state:String):Void itemStates.set(id, state);
	public function setItemCallback(id:String, cb:String):Void itemCallbacks.set(id, cb);
	public function setItemURL(id:String, url:String):Void itemURLs.set(id, url);
	public function setItemPage(id:String, pg:String):Void itemPages.set(id, pg);
	public function setItemMap(map:Dynamic):Void {}
	function find(id:String):MenuUIItem return MenuUI.find(id);

	public function pushPage(name:String):Void { pageStack.push(pageName); open(name); }
	public function back():Void
	{
		var prev:String = pageStack.length > 0 ? pageStack.pop() : 'main';
		open(prev);
		scripts.call('onPageBack', [prev]);
	}
	public function open(name:String):Void
	{
		pageName = cleanId(name);
		clearPageItems();
		scripts.exitPage();
		scripts.enterPage(pageName);
		scripts.startPage(pageName);
		scripts.call('onPageOpen', [pageName]);
		setTitle(pageName);
	}
	public function clearPageStack():Void pageStack = [];
	public function getPageName():String return pageName;

	public function getPageItemCount():Int return items.length;
	public function getPageItemId(i:Int):String return i >= 0 && i < items.length ? items[i].id : '';
	public function getPageItemIndex(id:String):Int { for (i in 0...items.length) if (items[i].id == id) return i; return -1; }
	public function getPageSelected():Int return hoverIndex;
	public function getPageSelectedId():String return getPageItemId(hoverIndex);
	public function isSelectable(i:Int):Bool return i >= 0 && i < items.length && items[i].enabled && items[i].visible;
	public function removePageItem(id:String):Void
	{
		for (i in 0...items.length) if (items[i].id == id)
		{
			var it:MenuUIItem = items.splice(i, 1)[0];
			MenuUI.remove(it.tag);
			if (it.sprite != null) remove(it.sprite);
			return;
		}
	}
	public function clearPageItems():Void
	{
		for (it in items) { MenuUI.remove(it.tag); if (it.sprite != null) remove(it.sprite); }
		items = [];
		lastAutoY = layoutStartY;
	}

	public function addScriptButton(id:String, image:String, x:Float, y:Float, ?cb:String):String
	{
		var s:FlxSprite;
		if (image != null)
		{
			s = new FlxSprite(x, y);
			try { s.loadGraphic(Paths.image(image)); } catch (e:Dynamic) {}
		}
		else
			s = new PsychUIButton(Std.int(x), Std.int(y), 'Scripts', null, 110, 24);
		add(s);
		var b:MenuUIItem = new MenuUIItem(id, s, id);
		b.callbackName = cb;
		scriptButtons.push(b);
		MenuUI.register(id, s);
		return id;
	}
	public function removeScriptButton(id:String):Void
	{
		for (i in 0...scriptButtons.length) if (scriptButtons[i].id == id)
		{
			var b:MenuUIItem = scriptButtons.splice(i, 1)[0];
			MenuUI.remove(b.tag);
			if (b.sprite != null) remove(b.sprite);
			return;
		}
	}
	public function setScriptButtonCallback(id:String, cb:String):Void { for (b in scriptButtons) if (b.id == id) b.callbackName = cb; }
	public function clickScriptButton(id:String):Void
	{
		for (b in scriptButtons) if (b.id == id && b.callbackName != null) { scripts.call(b.callbackName); return; }
	}
	public function updateScriptButtons():Void for (b in scriptButtons) b.apply();

	public function selectPageItem(i:Int):Void { hoverIndex = i; for (k in 0...items.length) items[k].alpha = (k == i) ? 1 : 0.65; for (it in items) it.apply(); }
	public function changeItem(delta:Int = 0):Void
	{
		if (items.length == 0) return;
		var n:Int = hoverIndex + delta;
		while (n < 0) n += items.length;
		while (n >= items.length) n -= items.length;
		selectPageItem(n);
	}
	public function tapItem(id:String):Void
	{
		var idx:Int = getPageItemIndex(id);
		if (idx < 0 || !isSelectable(idx)) return;
		selectPageItem(idx);
		activateItem(id);
	}
	public function activateItem(id:String):Void
	{
		if (menuLocked) return;
		var cb:String = itemCallbacks.get(id);
		if (cb != null) { lockPage(); scripts.call(cb); unlockAfterCallback(); return; }
		var pg:String = itemPages.get(id);
		if (pg != null) { pushPage(pg); return; }
		var url:String = itemURLs.get(id);
		if (url != null) { FlxG.openURL(url); return; }
		var st:String = itemStates.get(id);
		if (st != null && st.length > 0) { markMenuLeft(); MainMenuState.curSelected = 0; }
	}
	public function lockPage():Void menuLocked = true;
	public function unlockPage():Void menuLocked = false;
	public function unlockAfterCallback():Void menuLocked = false;
	public function markMenuLeft():Void {}
	public function mouseInput():Void
	{
		gestures.update(FlxG.elapsed);
		if (FlxG.mouse.justPressed) gestures.onMenuTouchDown(FlxG.mouse.x, FlxG.mouse.y);
		if (FlxG.mouse.justReleased)
		{
			gestures.onMenuTouchUp(FlxG.mouse.x, FlxG.mouse.y);
			if (!gestures.swiped && !gestures.dragStarted)
			{
				for (b in scriptButtons) if (b.hitTest(FlxG.mouse.x, FlxG.mouse.y)) { clickScriptButton(b.id); return; }
				for (it in items) if (it.hitTest(FlxG.mouse.x, FlxG.mouse.y)) { tapItem(it.id); return; }
			}
		}
	}
	public function applyScroll():Void
	{
		for (it in items) { it.y += scrollOffset; it.apply(); }
	}

	override function create():Void
	{
		super.create();
		MenuUI.clear();
		pageName = cleanId(page);
		createBackground();
		createTitle(pageName);
		scripts.enterPage(pageName);
		scripts.startPage(pageName);
		scripts.call('onPageOpen', [pageName]);
		scripts.call('onCreate');
	}

	override function update(elapsed:Float):Void
	{
		mouseInput();
		MenuUI.update();
		scripts.call('onUpdate');
		if (FlxG.keys.justPressed.UP) changeItem(-1);
		if (FlxG.keys.justPressed.DOWN) changeItem(1);
		if (FlxG.keys.justPressed.ENTER && hoverIndex >= 0) tapItem(getPageItemId(hoverIndex));
		if (FlxG.keys.justPressed.ESCAPE) back();
		super.update(elapsed);
	}
	override function destroy():Void
	{
		scripts.call('onPageClose', [pageName]);
		scripts.destroyAll();
		MenuUI.clear();
		super.destroy();
	}
}
