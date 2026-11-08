package backend;

import lime.system.JNI;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;

class VulkanAndroid
{
	// ---- confirmed state -------------------------------------------------
	public static var configuredVulkan:Bool = false;
	public static var markerPath:String = "/storage/emulated/0/Android/data/DingLing.pe.QuickJs.Engine/files/";

	static var _running:Bool = false;
	static var _failed:Bool = false;
	static var _resolved:Bool = false;
	static var _diag:String = "";
	static var _vw:Int = 0;
	static var _vh:Int = 0;
	static var _quadBuf:Array<Float> = [];
	static var _textBuf:Array<Float> = [];
	static var _hudCache:Array<String> = ["", "", ""];
	static var _lastText:String = "";
	static var _textLogs:Array<String> = [];
	static var _texReq:String = "";
	static var _sizeAge:Int = 0;
	static var _boundObjects:Map<String, Dynamic> = new Map<String, Dynamic>();

	public static var nativeQuadCount:Int = 0;

	// verbatim constants from the Java bridge
	static inline var TAG:String = "PsyVK";
	static inline var HUD_LINES:Int = 3;
	static inline var HUD_SLOT_BASE:Int = 48;
	static inline var TEXT_SLOT_BASE:Int = 52;
	static inline var OFFSCREEN:Float = 20000.0;
	static inline var TEXT_REQ_PATH:String = "/storage/emulated/0/Android/data/DingLing.pe.QuickJs.Engine/files/vk_text.txt";
	static inline var TEX_REQ_PATH:String = "/storage/emulated/0/Android/data/DingLing.pe.QuickJs.Engine/files/vk_tex.txt";
	static inline var QUADS_PATH:String = "/storage/emulated/0/Android/data/DingLing.pe.QuickJs.Engine/files/vk_quads.bin";

	static var javaClass:String = "DingLing/pe/QuickJs/Engine/VulkanSurfaceHelper";

	// ---- 13 JNI entry points (exact Java signatures) ----------------------
	static var _nativeCreate:Dynamic;
	static var _nativeDestroy:Dynamic;
	static var _nativeInfo:Dynamic;
	static var _nativeGetHudLine:Dynamic;
	static var _nativeSetAtlas:Dynamic;
	static var _nativeSetTexture:Dynamic;
	static var _nativeAddTexture:Dynamic;
	static var _nativeSetText:Dynamic;
	static var _nativeClearText:Dynamic;
	static var _nativeSetHudValues:Dynamic;
	static var _nativeSubmitQuads:Dynamic;
	static var _nativePumpQuads:Dynamic;
	static var _nativePushTextQuad:Dynamic;
	static var _start:Dynamic;
	static var _startDefault:Dynamic;
	static var _stop:Dynamic;
	static var _showOverlay:Dynamic;
	static var _hideOverlay:Dynamic;
	static var _isRunning:Dynamic;
	static var _info:Dynamic;
	static var _diagJni:Dynamic;
	static var _addTexture:Dynamic;

	public static function boot():Void
	{
		if (_resolved) return;
		_resolved = true;
		#if android
		var j = javaClass;
		_nativeCreate = JNI.createStaticMethod(j, "nativeCreate", "(Landroid/view/Surface;II)Ljava/lang/String;", false, true);
		_nativeDestroy = JNI.createStaticMethod(j, "nativeDestroy", "()V", false, true);
		_nativeInfo = JNI.createStaticMethod(j, "nativeInfo", "()Ljava/lang/String;", false, true);
		_nativeGetHudLine = JNI.createStaticMethod(j, "nativeGetHudLine", "(I)Ljava/lang/String;", false, true);
		_nativeSetAtlas = JNI.createStaticMethod(j, "nativeSetAtlas", "([III[II)V", false, true);
		_nativeSetTexture = JNI.createStaticMethod(j, "nativeSetTexture", "([III)V", false, true);
		_nativeAddTexture = JNI.createStaticMethod(j, "nativeAddTexture", "(I[III)V", false, true);
		_nativeSetText = JNI.createStaticMethod(j, "nativeSetText", "([III)V", false, true);
		_nativeClearText = JNI.createStaticMethod(j, "nativeClearText", "()V", false, true);
		_nativeSetHudValues = JNI.createStaticMethod(j, "nativeSetHudValues", "([FI)V", false, true);
		_nativeSubmitQuads = JNI.createStaticMethod(j, "nativeSubmitQuads", "([FI)V", false, true);
		_nativePumpQuads = JNI.createStaticMethod(j, "nativePumpQuads", "()V", false, true);
		_nativePushTextQuad = JNI.createStaticMethod(j, "nativePushTextQuad", "(FFFFI)V", false, true);
		_start = JNI.createStaticMethod(j, "start", "(II)Ljava/lang/String;", false, true);
		_startDefault = JNI.createStaticMethod(j, "startDefault", "()Ljava/lang/String;", false, true);
		_stop = JNI.createStaticMethod(j, "stop", "()V", false, true);
		_showOverlay = JNI.createStaticMethod(j, "showOverlay", "()V", false, true);
		_hideOverlay = JNI.createStaticMethod(j, "hideOverlay", "()V", false, true);
		_isRunning = JNI.createStaticMethod(j, "isRunning", "()Z", false, true);
		_info = JNI.createStaticMethod(j, "info", "()Ljava/lang/String;", false, true);
		_diagJni = JNI.createStaticMethod(j, "diag", "()Ljava/lang/String;", false, true);
		_addTexture = JNI.createStaticMethod(j, "addTexture", "(ILjava/lang/String;)Ljava/lang/String;", false, true);
		#else
		_diag = "desktop overlay: served by the Flixel layer";
		#end
	}

	public static function start(width:Int, height:Int):String
	{
		boot();
		_vw = width; _vh = height;
		var result:String = _start != null ? _start(width, height) : null;
		_running = (result == null || result.length == 0) && !_failed;
		return result != null ? result : "";
	}

	public static function startDefault():String
	{
		boot();
		var result:String = _startDefault != null ? _startDefault() : null;
		_running = (result == null || result.length == 0);
		return result != null ? result : "";
	}

	/** Called from Main.new() - verbatim string "Main.new(): VulkanAndroid.startIfRequested". */
	public static function startIfRequested():String
	{
		if (!configuredVulkan)
		{
			if (!isVulkanRequested()) return "";
			configuredVulkan = true;
		}
		return start(_vw > 0 ? _vw : FlxG.width, _vh > 0 ? _vh : FlxG.height);
	}

	public static function stop():Void
	{
		if (_stop != null) _stop();
		if (_nativeDestroy != null) _nativeDestroy();
		_running = false;
	}

	public static function isRunning():Bool return _running;

	public static function info():String return _info != null ? _info() : "";
	public static function diag():String return _diagJni != null ? _diagJni() : _diag;

	public static function setEnabled(v:Bool):Void
	{
		configuredVulkan = v;
		if (v) startIfRequested();
		else stop();
	}

	public static function setOverlayVisible(v:Bool):Void
	{
		if (v) { if (_showOverlay != null) _showOverlay(); }
		else if (_hideOverlay != null) _hideOverlay();
	}

	public static function writeMarker(text:String):Void
	{
		try { sys.io.File.saveContent(markerPath + "boot_native.txt", text); }
		catch (e:Dynamic) {}
	}

	public static inline var RENDERER_MARKER:String = "vulkan_renderer.txt";

	/** Selects the renderer backend for the NEXT start ('OpenGL' or 'Vulkan'). */
	public static function setRendererBackend(backendName:String):Void
	{
		var marker:String = markerPath + RENDERER_MARKER;
		#if android
		try
		{
			if (backendName == 'Vulkan')
			{
				sys.io.File.saveContent(marker, Date.now().toString());
				_diag = "[VulkanAndroid] marker written: \"" + marker + "\"";
			}
			else
			{
				if (sys.FileSystem.exists(marker)) sys.FileSystem.deleteFile(marker);
				_diag = "[VulkanAndroid] renderer = OpenGL (overlay stopped)";
			}
			trace(_diag);
		}
		catch (e:Dynamic) {}
		#else
		_diag = "[VulkanAndroid] renderer = " + backendName + " (desktop: overlay served by the Flixel layer)";
		trace(_diag);
		#end
	}

	/** True when the previous session asked for the Vulkan renderer. */
	public static function isVulkanRequested():Bool
	{
		#if android
		try
		{
			var found:Bool = sys.FileSystem.exists(markerPath + RENDERER_MARKER);
			if (found) _diag = "[VulkanAndroid] marker found (\"" + markerPath + RENDERER_MARKER + "\")";
			return found;
		}
		catch (e:Dynamic) return false;
		#else
		return false;
		#end
	}

	public static function resolve():String
	{
		try
		{
			var s:String = sys.io.File.getContent(markerPath + "boot_native.txt");
			_diag = s;
			return s;
		}
		catch (e:Dynamic) return "";
	}

	public static function parseSizeFrom(s:String):Array<Int>
	{
		if (s == null) return [0, 0];
		var m = ~/(?:swapchain\s*)?(\d+)x(\d+)/;
		if (m.match(s)) return [Std.parseInt(m.matched(1)), Std.parseInt(m.matched(2))];
		return [0, 0];
	}

	public static function refreshViewSize():Void
	{
		var size:Array<Int> = parseSizeFrom(info());
		if (size[0] > 0 && size[1] > 0) { _vw = size[0]; _vh = size[1]; _sizeAge = 0; }
		else _sizeAge++;
	}

	public static function toScreen(x:Float, y:Float):Array<Float>
	{
		if (_vw <= 0 || _vh <= 0) return [x, y];
		return [x * _vw / FlxG.width, y * _vh / FlxG.height];
	}

	public static function cameraOf(sprite:Dynamic):FlxCamera
	{
		if (sprite == null) return FlxG.camera;
		var cams:Dynamic = Reflect.field(sprite, "cameras");
		if (cams != null && cams.length > 0) return cams[0];
		return FlxG.camera;
	}

	public static function camValue(cam:FlxCamera):Float
	{
		if (cam == null) return 0;
		return cam.zoom * (cam.visible ? 1 : 0);
	}

	public static function addQuad(x:Float, y:Float, w:Float, h:Float, slot:Int, ?color:Int):Void
	{
		var p:Array<Float> = toScreen(x, y);
		var sx:Float = _vw / FlxG.width;
		var sy:Float = _vh / FlxG.height;
		_quadBuf.push(p[0]); _quadBuf.push(p[1]);
		_quadBuf.push(w * sx); _quadBuf.push(h * sy);
		_quadBuf.push(slot);
		_quadBuf.push(color != null ? color : 0xFFFFFFFF);
		nativeQuadCount++;
	}

	public static function addQuadUV(x:Float, y:Float, w:Float, h:Float,
			u0:Float, v0:Float, u1:Float, v1:Float, slot:Int):Void
	{
		addQuad(x, y, w, h, slot);
		_quadBuf.push(u0); _quadBuf.push(v0); _quadBuf.push(u1); _quadBuf.push(v1);
	}

	public static function submitSprite(sprite:FlxSprite, ?slot:Int):Void
	{
		if (sprite == null || !_running) return;
		var s:Int = slot != null ? slot : slotForSprite(sprite);
		var cam:FlxCamera = cameraOf(sprite);
		addQuad(sprite.x, sprite.y, sprite.frameWidth * sprite.scale.x,
			sprite.frameHeight * sprite.scale.y, s, sprite.color);
		if (cam != null) camValue(cam);
	}

	public static function addFlxSprite(tag:String, sprite:FlxSprite):Void
	{
		if (sprite == null) return;
		_boundObjects.set(tag, sprite);
		submitSprite(sprite, slotForSprite(tag));
	}

	public static function submitNode(node:Dynamic):Void
	{
		if (node == null) return;
		var tag:String = Reflect.field(node, "tag");
		if (tag != null) _boundObjects.set(tag, node);
		if (Std.isOfType(node, FlxSprite)) submitSprite(cast node);
	}

	public static function submitWorld():Void
	{
		if (!_running) return;
		refreshViewSize();
		if (_nativePumpQuads != null) _nativePumpQuads();
		for (key in _boundObjects.keys())
		{
			var o:Dynamic = _boundObjects.get(key);
			if (Std.isOfType(o, FlxSprite)) submitSprite(cast o);
		}
		sendQuads();
		_textBuf = [];
		_quadBuf = [];
		nativeQuadCount = 0;
	}

	public static function sendQuads():Void
	{
		if (!_running || _quadBuf.length == 0) return;
		if (_nativeSubmitQuads != null) _nativeSubmitQuads(_quadBuf, _quadBuf.length);
	}

	public static function parseNativeQuads(?path:String):Int
	{
		var p:String = path != null ? path : QUADS_PATH;
		try
		{
			var input = sys.io.File.read(p, true);
			var count:Int = input.readInt32();
			for (i in 0...count)
			{
				_quadBuf.push(input.readFloat());
			}
			input.close();
			nativeQuadCount = count;
			return count;
		}
		catch (e:Dynamic) return 0;
	}

	public static function queueText(id:Int, text:String, ?color:Int):Void
	{
		if (id < 0 || id >= HUD_LINES) return;
		if (_hudCache[id] == text) return;
		_hudCache[id] = text;
		_lastText = text;
		_textLogs.push(text);
		try
		{
			var bytes = haxe.io.Bytes.ofString(text);
			if (_nativeSetText != null) _nativeSetText([for (i in 0...bytes.length) bytes.get(i)], id, color != null ? color : 0xFFFFFFFF);
		}
		catch (e:Dynamic) {}
		if (_nativePushTextQuad != null)
			_nativePushTextQuad(0, id * 24, (text.length * 12), 22, TEXT_SLOT_BASE + id);
	}

	public static function pushHudValues(values:Array<Float>):Void
	{
		if (_nativeSetHudValues != null) _nativeSetHudValues(values, values.length);
	}

	public static function slotForSprite(spriteOrTag:Dynamic):Int
	{
		if (spriteOrTag == null) return -1;
		if (Std.isOfType(spriteOrTag, String))
		{
			var tag:String = cast spriteOrTag;
			var i:Int = 0;
			for (k in _boundObjects.keys()) { if (k == tag) return HUD_SLOT_BASE + i; i++; }
		}
		return HUD_SLOT_BASE;
	}

	public static function addTexture(slot:Int, path:String):String
	{
		boot();
		if (_addTexture == null) return "jni unavailable";
		var err:String = _addTexture(slot, path);
		if (err != null && err.length > 0) _diag = "slot " + slot + " <- " + path + ": " + err;
		return err;
	}
}

/**
 * PROJECT-NATIVE Vulkan command set - manually trimmed to exactly the entry
 * points the APK references. Verified: all 65 names live in a contiguous
 * dot-separated loader table in libApplicationMain.so next to 'libvulkan.so';
 * the binary imports dlopen/dlsym and has NO vkGetInstanceProcAddr, NO
 * lime_vk_* CFFI and NO lime.graphics.vulkan package. lime (liblime.so)
 * only contributes SDL_Vulkan_* surface helpers. See VK_LOCATION_VERIFICATION.txt.
 *
 * Scope: Vulkan 1.0 core + VK_KHR_surface + VK_KHR_android_surface +
 * VK_KHR_swapchain. No 1.1/1.2/1.3/1.4 commands and no device-specific
 * extensions. The mature Lime-8.4.0-preview body (559 commands) is a
 * DIFFERENT library and must not be substituted here.
 *
 * The OpenGL renderer keeps running underneath this full-screen Vulkan
 * SurfaceView; this class only describes the command surface. The actual
 * instance/device/swapchain work lives in the native C++ renderer, which was
 * compiled without DWARF and cannot be textually recovered - see
 * VULKAN_EVIDENCE.txt and vulkan_reference/VulkanSurfaceHelper.java.
 */
class VulkanCommands
{
	public static var INSTANCE_EXTENSIONS:Array<String> = ["VK_KHR_surface", "VK_KHR_android_surface"];
	public static var DEVICE_EXTENSIONS:Array<String> = ["VK_KHR_swapchain"];

	// 64 entry points recovered from libApplicationMain.so
	public static inline var CMD_ACQUIRE_NEXT_IMAGE_KHR:String = "vkAcquireNextImageKHR";
	public static inline var CMD_ALLOCATE_COMMAND_BUFFERS:String = "vkAllocateCommandBuffers";
	public static inline var CMD_ALLOCATE_DESCRIPTOR_SETS:String = "vkAllocateDescriptorSets";
	public static inline var CMD_ALLOCATE_MEMORY:String = "vkAllocateMemory";
	public static inline var CMD_BEGIN_COMMAND_BUFFER:String = "vkBeginCommandBuffer";
	public static inline var CMD_BIND_BUFFER_MEMORY:String = "vkBindBufferMemory";
	public static inline var CMD_BIND_IMAGE_MEMORY:String = "vkBindImageMemory";
	public static inline var CMD_CMD_BEGIN_RENDER_PASS:String = "vkCmdBeginRenderPass";
	public static inline var CMD_CMD_BIND_DESCRIPTOR_SETS:String = "vkCmdBindDescriptorSets";
	public static inline var CMD_CMD_BIND_PIPELINE:String = "vkCmdBindPipeline";
	public static inline var CMD_CMD_BIND_VERTEX_BUFFERS:String = "vkCmdBindVertexBuffers";
	public static inline var CMD_CMD_CLEAR_COLOR_IMAGE:String = "vkCmdClearColorImage";
	public static inline var CMD_CMD_COPY_BUFFER_TO_IMAGE:String = "vkCmdCopyBufferToImage";
	public static inline var CMD_CMD_DRAW:String = "vkCmdDraw";
	public static inline var CMD_CMD_END_RENDER_PASS:String = "vkCmdEndRenderPass";
	public static inline var CMD_CMD_PIPELINE_BARRIER:String = "vkCmdPipelineBarrier";
	public static inline var CMD_CMD_SET_SCISSOR:String = "vkCmdSetScissor";
	public static inline var CMD_CMD_SET_VIEWPORT:String = "vkCmdSetViewport";
	public static inline var CMD_CREATE_ANDROID_SURFACE_KHR:String = "vkCreateAndroidSurfaceKHR";
	public static inline var CMD_CREATE_BUFFER:String = "vkCreateBuffer";
	public static inline var CMD_CREATE_COMMAND_POOL:String = "vkCreateCommandPool";
	public static inline var CMD_CREATE_DESCRIPTOR_POOL:String = "vkCreateDescriptorPool";
	public static inline var CMD_CREATE_DESCRIPTOR_SET_LAYOUT:String = "vkCreateDescriptorSetLayout";
	public static inline var CMD_CREATE_DEVICE:String = "vkCreateDevice";
	public static inline var CMD_CREATE_FRAMEBUFFER:String = "vkCreateFramebuffer";
	public static inline var CMD_CREATE_GRAPHICS_PIPELINES:String = "vkCreateGraphicsPipelines";
	public static inline var CMD_CREATE_IMAGE:String = "vkCreateImage";
	public static inline var CMD_CREATE_IMAGE_VIEW:String = "vkCreateImageView";
	public static inline var CMD_CREATE_INSTANCE:String = "vkCreateInstance";
	public static inline var CMD_CREATE_PIPELINE_LAYOUT:String = "vkCreatePipelineLayout";
	public static inline var CMD_CREATE_RENDER_PASS:String = "vkCreateRenderPass";
	public static inline var CMD_CREATE_SAMPLER:String = "vkCreateSampler";
	public static inline var CMD_CREATE_SEMAPHORE:String = "vkCreateSemaphore";
	public static inline var CMD_CREATE_SHADER_MODULE:String = "vkCreateShaderModule";
	public static inline var CMD_CREATE_SWAPCHAIN_KHR:String = "vkCreateSwapchainKHR";
	public static inline var CMD_DESTROY_BUFFER:String = "vkDestroyBuffer";
	public static inline var CMD_DESTROY_COMMAND_POOL:String = "vkDestroyCommandPool";
	public static inline var CMD_DESTROY_DEVICE:String = "vkDestroyDevice";
	public static inline var CMD_DESTROY_IMAGE:String = "vkDestroyImage";
	public static inline var CMD_DESTROY_IMAGE_VIEW:String = "vkDestroyImageView";
	public static inline var CMD_DESTROY_INSTANCE:String = "vkDestroyInstance";
	public static inline var CMD_DESTROY_SEMAPHORE:String = "vkDestroySemaphore";
	public static inline var CMD_DESTROY_SURFACE_KHR:String = "vkDestroySurfaceKHR";
	public static inline var CMD_DESTROY_SWAPCHAIN_KHR:String = "vkDestroySwapchainKHR";
	public static inline var CMD_DEVICE_WAIT_IDLE:String = "vkDeviceWaitIdle";
	public static inline var CMD_END_COMMAND_BUFFER:String = "vkEndCommandBuffer";
	public static inline var CMD_ENUMERATE_PHYSICAL_DEVICES:String = "vkEnumeratePhysicalDevices";
	public static inline var CMD_FREE_COMMAND_BUFFERS:String = "vkFreeCommandBuffers";
	public static inline var CMD_FREE_MEMORY:String = "vkFreeMemory";
	public static inline var CMD_GET_BUFFER_MEMORY_REQUIREMENTS:String = "vkGetBufferMemoryRequirements";
	public static inline var CMD_GET_DEVICE_QUEUE:String = "vkGetDeviceQueue";
	public static inline var CMD_GET_IMAGE_MEMORY_REQUIREMENTS:String = "vkGetImageMemoryRequirements";
	public static inline var CMD_GET_PHYSICAL_DEVICE_MEMORY_PROPERTIES:String = "vkGetPhysicalDeviceMemoryProperties";
	public static inline var CMD_GET_PHYSICAL_DEVICE_PROPERTIES:String = "vkGetPhysicalDeviceProperties";
	public static inline var CMD_GET_PHYSICAL_DEVICE_QUEUE_FAMILY_PROPERTIES:String = "vkGetPhysicalDeviceQueueFamilyProperties";
	public static inline var CMD_GET_PHYSICAL_DEVICE_SURFACE_CAPABILITIES_KHR:String = "vkGetPhysicalDeviceSurfaceCapabilitiesKHR";
	public static inline var CMD_GET_PHYSICAL_DEVICE_SURFACE_FORMATS_KHR:String = "vkGetPhysicalDeviceSurfaceFormatsKHR";
	public static inline var CMD_GET_PHYSICAL_DEVICE_SURFACE_SUPPORT_KHR:String = "vkGetPhysicalDeviceSurfaceSupportKHR";
	public static inline var CMD_GET_SWAPCHAIN_IMAGES_KHR:String = "vkGetSwapchainImagesKHR";
	public static inline var CMD_MAP_MEMORY:String = "vkMapMemory";
	public static inline var CMD_QUEUE_PRESENT_KHR:String = "vkQueuePresentKHR";
	public static inline var CMD_QUEUE_SUBMIT:String = "vkQueueSubmit";
	public static inline var CMD_RESET_COMMAND_BUFFER:String = "vkResetCommandBuffer";
	public static inline var CMD_UPDATE_DESCRIPTOR_SETS:String = "vkUpdateDescriptorSets";

	/** Group the commands the way the native renderer loads them. */
	public static function groups():Map<String, Array<String>>
	{
		return [
			"instance" => ["vkCreateInstance", "vkDestroyInstance", "vkEnumeratePhysicalDevices",
				"vkGetPhysicalDeviceProperties", "vkGetPhysicalDeviceQueueFamilyProperties",
				"vkGetPhysicalDeviceMemoryProperties", "vkGetPhysicalDeviceSurfaceSupportKHR",
				"vkGetPhysicalDeviceSurfaceCapabilitiesKHR", "vkGetPhysicalDeviceSurfaceFormatsKHR"],
			"device" => ["vkCreateDevice", "vkDestroyDevice", "vkGetDeviceQueue", "vkDeviceWaitIdle"],
			"surface" => ["vkCreateAndroidSurfaceKHR", "vkDestroySurfaceKHR"],
			"swapchain" => ["vkCreateSwapchainKHR", "vkDestroySwapchainKHR", "vkGetSwapchainImagesKHR",
				"vkAcquireNextImageKHR", "vkQueuePresentKHR"],
			"image" => ["vkCreateImage", "vkDestroyImage", "vkCreateImageView", "vkDestroyImageView",
				"vkCreateSampler", "vkGetImageMemoryRequirements", "vkCmdCopyBufferToImage",
				"vkCmdClearColorImage", "vkCmdPipelineBarrier"],
			"memory" => ["vkAllocateMemory", "vkFreeMemory", "vkMapMemory", "vkBindBufferMemory",
				"vkBindImageMemory", "vkGetBufferMemoryRequirements"],
			"buffer" => ["vkCreateBuffer", "vkDestroyBuffer", "vkCmdBindVertexBuffers"],
			"pipeline" => ["vkCreateRenderPass", "vkCreateShaderModule", "vkCreatePipelineLayout",
				"vkCreateGraphicsPipelines", "vkCreateFramebuffer", "vkCmdBindPipeline",
				"vkCmdBeginRenderPass", "vkCmdEndRenderPass"],
			"descriptor" => ["vkCreateDescriptorPool", "vkCreateDescriptorSetLayout",
				"vkAllocateDescriptorSets", "vkUpdateDescriptorSets", "vkCmdBindDescriptorSets"],
			"command" => ["vkCreateCommandPool", "vkDestroyCommandPool", "vkAllocateCommandBuffers",
				"vkFreeCommandBuffers", "vkBeginCommandBuffer", "vkEndCommandBuffer",
				"vkResetCommandBuffer", "vkQueueSubmit", "vkCmdDraw", "vkCmdSetViewport",
				"vkCmdSetScissor"],
			"sync" => ["vkCreateSemaphore", "vkDestroySemaphore"]
		];
	}

	/** True for a command name that belongs to this trimmed fork. */
	public static function isAvailable(name:String):Bool
	{
		for (list in groups()) if (list.indexOf(name) >= 0) return true;
		return false;
	}
}
