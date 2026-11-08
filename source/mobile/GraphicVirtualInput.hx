package mobile;

class GraphicVirtualInput
{
	public static var instance:GraphicVirtualInput = null;
	public static var loaded:Bool = false;

	public function new()
	{
		if (instance == null) instance = this;
	}

	public static function boot():Void
	{
		if (loaded) return;
		loaded = true;
		instance = new GraphicVirtualInput();
		// preload the touch-control graphics so the first pad build doesn't hitch
		for (img in ['androidcontrols/virtualpad', 'androidcontrols/hitbox', 'androidcontrols/hitbox_hint'])
		{
			try { backend.Paths.image(img); } catch (e:Dynamic) {}
		}
	}
}
