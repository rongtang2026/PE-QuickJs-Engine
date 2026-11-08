
package backend;

class MenuUI
{
	static var objects:Map<String, Dynamic> = new Map<String, Dynamic>();
	static var tags:Map<String, Array<String>> = new Map<String, Array<String>>();
	static var replacements:Map<String, String> = new Map<String, String>();
	static var attachTarget:Map<String, String> = new Map<String, String>();
	static var dragOwner:String = null;
	static var draggingTag:String = null;
	static var inputBlocked:Bool = false;
	static var gestureConsumed:Bool = false;
	static var elementPos:Map<String, Array<Float>> = new Map<String, Array<Float>>();

	public static function register(tag:String, obj:Dynamic):Void
	{
		objects.set(tag, obj);
		var parts:Array<String> = tag.split(":");
		if (parts.length > 1)
		{
			var list:Array<String> = tags.get(parts[0]);
			if (list == null) { list = []; tags.set(parts[0], list); }
			list.push(parts[1]);
		}
	}

	public static function find(tag:String):Dynamic return objects.get(tag);

	public static function remove(tag:String):Void
	{
		objects.remove(tag);
		replacements.remove(tag);
		attachTarget.remove(tag);
		elementPos.remove(tag);
	}

	public static function clear():Void
	{
		objects = new Map<String, Dynamic>();
		tags = new Map<String, Array<String>>();
		replacements = new Map<String, String>();
		attachTarget = new Map<String, String>();
		elementPos = new Map<String, Array<Float>>();
		dragOwner = null;
		draggingTag = null;
		inputBlocked = false;
	}

	public static function attach(tag:String, target:String):Void attachTarget.set(tag, target);
	public static function detach(tag:String):Void attachTarget.remove(tag);
	public static function detachFrom(target:String):Void
	{
		for (k in attachTarget.keys()) if (attachTarget.get(k) == target) attachTarget.remove(k);
	}

	public static function isAttached(tag:String):Bool return attachTarget.exists(tag);
	public static function isHidden(tag:String):Bool { var o = objects.get(tag); return o == null ? true : Reflect.field(o, "visible") == false; }
	public static function shouldShow(tag:String):Bool return !isHidden(tag);

	public static function setVisible(tag:String, v:Bool):Void
	{
		var o = objects.get(tag);
		if (o != null) Reflect.setField(o, "visible", v);
		applyVisible(tag);
	}

	public static function setAlpha(tag:String, a:Float):Void
	{
		var o = objects.get(tag);
		if (o != null) Reflect.setField(o, "alpha", a);
	}

	public static function hideAll(?only:Array<String>):Void
	{
		var keys:Array<String> = only != null ? only : [for (k in objects.keys()) k];
		for (k in keys) setVisible(k, false);
	}

	public static function showAll(?only:Array<String>):Void
	{
		var keys:Array<String> = only != null ? only : [for (k in objects.keys()) k];
		for (k in keys) setVisible(k, true);
	}

	public static function applyVisible(tag:String):Void
	{
		var t:String = attachTarget.get(tag);
		if (t == null) return;
		var o = objects.get(tag);
		if (o != null && objects.exists(t)) Reflect.setField(o, "visible", Reflect.field(objects.get(t), "visible"));
	}

	public static function updateAttachments():Void for (k in attachTarget.keys()) updateAttachment(k);
	public static function updateAttachment(tag:String):Void
	{
		var t:String = attachTarget.get(tag);
		if (t == null || !objects.exists(t)) return;
		var o = objects.get(tag), target = objects.get(t);
		if (o == null) return;
		Reflect.setField(o, "x", Reflect.field(target, "x"));
		Reflect.setField(o, "y", Reflect.field(target, "y"));
	}

	public static function replacementOf(a:String, b:String):Void replacements.set(a, b);
	public static function isReplaced(tag:String):Bool return replacements.exists(tag);
	public static function restoreObject(tag:String):Void replacements.remove(tag);

	public static function setDraggable(tag:String, v:Bool):Void tags.set(tag, v ? ["draggable"] : []);
	public static function isDraggable(tag:String):Bool { var t = tags.get(tag); return t != null && t.indexOf("draggable") >= 0; }
	public static function draggableAt(x:Float, y:Float):String
	{
		for (k in objects.keys()) if (isDraggable(k)) return k;
		return null;
	}
	public static function isDragging():Bool return draggingTag != null;
	public static function isAnyDragging():Bool return dragOwner != null;
	public static function beginDrag(tag:String, x:Float, y:Float):Void { draggingTag = tag; dragOwner = tag; }
	public static function endDrag():Void { draggingTag = null; dragOwner = null; }
	public static function stopDrag():Void endDrag();
	public static function updateDrag(x:Float, y:Float):Void
	{
		if (draggingTag == null) return;
		elementPos.set(draggingTag, [x, y]);
		moveItem(draggingTag, x, y);
	}
	public static function moveItem(tag:String, x:Float, y:Float):Void
	{
		var o = objects.get(tag);
		if (o == null) return;
		Reflect.setField(o, "x", x);
		Reflect.setField(o, "y", y);
	}
	public static function clampTo(x:Float, y:Float, w:Float, h:Float):Array<Float>
	{
		return [Math.max(0, Math.min(x, w)), Math.max(0, Math.min(y, h))];
	}
	public static function elementPosOf(tag:String):Array<Float> return elementPos.get(tag);
	public static function isPadPoint(x:Float, y:Float):Bool return false;
	public static function dispatchGestures(g:Dynamic):Bool return gestureConsumed;
	public static function gestureConsumedBy(v:Bool):Void gestureConsumed = v;
	public static function enforce():Void { inputBlocked = true; }
	public static function update():Void updateAttachments();
	public static function destroy():Void clear();

	public function get(tag:String):Dynamic
	{
		return find(tag);
	}

	public function replace(tag:String, obj:Dynamic):Void
	{
		var old:Dynamic = objects.get(tag);
		if (old != null && FlxG.state != null && Std.isOfType(old, flixel.FlxBasic)) FlxG.state.remove(cast old);
		if (obj == null) { objects.remove(tag); return; }
		register(tag, obj);
		if (FlxG.state != null && Std.isOfType(obj, flixel.FlxBasic))
		{
			var exists:Bool = false;
			for (m in FlxG.state.members) if (m == obj) { exists = true; break; }
			if (!exists) FlxG.state.add(cast obj);
		}
	}

	public function restore(tag:String):Void
	{
		restoreObject(tag);
	}
}
