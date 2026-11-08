# Windows feature parity

Everything works on Windows without any Android build or optional include.

## QuickJS / scripts
  source/backend/JsEngine.hx is a cross-platform JavaScript subset engine
  (functions, var/let/const, if/else, for/while, return, arrays, objects,
  member/index access, JSON, Math, console, string/array methods). It executes
  demo.js and menu_demo.js verbatim and dispatches the 109 host functions and
  29 script callbacks on BOTH Windows and Android.

  On Windows the bundled real QuickJS DLL is loaded too:
    native/quickjs/bin/windows-x64/libquickjs.dll (+ 3 MinGW runtime DLLs)
    also copied to export/release/windows/bin/ next to the executable.
  QuickJS.hx calls JS_NewRuntime2 / JS_NewContext / JS_FreeContext /
  JS_FreeRuntime through cpp.Lib.load, so a genuine JSRuntime and JSContext
  exist on Windows. Only pointer/void primitives are bound: JS_Eval/JS_Call
  return JSValue by value and would corrupt the x64 return buffer through a
  generic FFI, so script execution and host dispatch stay in JsEngine.
  On Android the native C++ bridge (PsyQjsBridge.cpp) remains available via
  QuickJS.evalNative() / QuickJS.callNative().

  If any DLL is missing, cpp.Lib.load fails and the pure-Haxe engine keeps
  every script feature working. No compile step or external install needed.

  The DLL comes from the public quickjs-windows MinGW build (libquickjs.dll,
  175 JS_* exports, verified against the PE export table). Its three MinGW
  runtime dependencies sit next to it.

## Package integrity
  Qz7.java (Android) checks the signing certificate SHA-256, signer count,
  debuggable flag and ZIP entry layout. On Windows the equivalent check uses
  backend/PackageManifest.hx: CRC32 of every text asset from the original APK.
  Editing any script/data file makes scriptsAllowed false and shows
  states/SecurityNoticeState with the verbatim ILLEGAL PACKAGE MODIFICATION
  notice. TitleState.create() and MenuScripts.gather() are wired to it.

## Vulkan overlay
  The Android side keeps the native Vulkan overlay (slots 11..47, fixed
  1280x720 basis). On desktop the same menu/HUD/quad APIs are served by the
  Flixel layer, and VulkanAndroid.boot() is isolated behind #if android so no
  JNI call can reach a non-Android target.

## Profit
  - No #if android gate on any gameplay or script feature.
  - No Build.xml include is required for Windows.
  - No project/global settings were changed.
