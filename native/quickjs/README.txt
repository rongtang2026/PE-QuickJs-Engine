# QuickJS C API bridge (Android only)

Why this exists
  libApplicationMain.so exports 198 JS_* QuickJS C API symbols in .dynsym
  (JS_NewRuntime2, JS_NewContextRaw, JS_Eval, JS_Call, JS_GetGlobalObject,
  JS_GetPropertyStr, JS_ExecutePendingJob, ...). The Haxe module
  source/backend/QuickJS.hx binds them through cpp.Lib.load on Android.

Why a C++ bridge instead of direct Haxe calls
  JS_Eval / JS_Call return JSValue by value (16-byte struct or uint64_t
  depending on the QuickJS build). Calling them through a generic FFI with an
  opaque return type would corrupt the arm64 return buffer. The bridge uses
  the real prototypes from quickjs_api.h (transcribed from quickjs-ng quickjs.h)
  and exposes only pointer / int / string results to Haxe.

Integration (opt-in, Android only)
  Add to Project.xml:
      <include path="native/quickjs/Build.xml" if="android" />
  The QuickJS symbols must be linked into libApplicationMain.so (as in the
  original APK). If they are absent, psyqjs_available() returns 0 and
  QuickJS.hx falls back to its pure-Haxe host dispatcher, so the game still
  runs. JSValue layout follows the 64-bit NAN_BOXING default; set
  PSYQJS_NAN_BOXING=0 in Build.xml if your QuickJS build uses the struct layout.

Windows is unaffected: every native bind in QuickJS.hx is behind #if android,
and this Build.xml is never included on desktop.
