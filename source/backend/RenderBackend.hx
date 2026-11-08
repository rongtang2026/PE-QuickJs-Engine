package backend;

class RenderBackend
{
	public static var instance:RenderBackend = new RenderBackend();

	public var active:String = "opengl";
	public var vulkanAvailable:Bool = false;
	public var supportsRenderScale:Bool = true;
	public var renderScale:Float = 1;
	public var shadersEnabled:Bool = true;
	public var scale:Float = 1;

	var trackedAssets:Array<String> = [];
	var excludedAssets:Array<String> = [];

	public function new() {}

	public static function fromGL():RenderBackend
	{
		instance.active = "opengl";
		return instance;
	}

	public static function fromRenderContext(ctx:Dynamic):RenderBackend
	{
		instance.active = (ctx != null && Std.string(ctx).indexOf("vulkan") >= 0) ? "vulkan" : "opengl";
		return instance;
	}

	public static function fromString(name:String):RenderBackend
	{
		instance.active = (name != null && name.toLowerCase() == "vulkan") ? "vulkan" : "opengl";
		return instance;
	}

	/** Switch on the next start; OpenGL keeps running underneath. */
	public static function setVulkan(enabled:Bool):Void
	{
		instance.vulkanAvailable = enabled;
		ClientPrefs.data.rendererBackend = enabled ? 'Vulkan' : 'OpenGL';
		VulkanAndroid.setRendererBackend(enabled ? 'Vulkan' : 'OpenGL');
	}

	public function applyRenderScale(v:Float):Void
	{
		if (!supportsRenderScale) return;
		renderScale = Math.max(0.25, Math.min(v, 2));
		scale = renderScale;
	}

	public function describe():String
	{
		return active + (vulkanAvailable ? "+vulkan-overlay" : "") +
			", scale=" + scale + ", shaders=" + (shadersEnabled ? "on" : "off");
	}

	public function trackLocal(path:String):Void
	{
		if (path != null && trackedAssets.indexOf(path) < 0) trackedAssets.push(path);
	}

	public function excludeAsset(path:String):Void
	{
		if (path != null && excludedAssets.indexOf(path) < 0) excludedAssets.push(path);
	}

	public function clearUnusedMemory():Void
	{
		trackedAssets = [];
	}

	public static function boot():Void
	{
		VulkanAndroid.boot();
	}
}
