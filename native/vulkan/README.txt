# Project-native Vulkan renderer (native/vulkan/)

Reconstructed C++ renderer for the APK's overlay path. It is intentionally kept
OUTSIDE the Haxe classpath so the existing Windows build is unaffected.

Files
  PsyVkCommands.h   65 APK vk* strings preserved verbatim in PSYVK_RAW_TABLE;
                    64 real commands declared as PFN_* and resolved with
                    dlopen("libvulkan.so") + dlsym. No vkGetInstanceProcAddr.
  PsyVkRenderer.h   renderer state, quad vertex layout, 96 texture slots.
  PsyVkRenderer.cpp instance -> physical device / queue family ->
                    ANativeWindow surface (ANativeWindow_fromSurface) -> device
                    -> swapchain -> image views -> render pass -> descriptor /
                    pipeline -> framebuffers -> command buffers -> vertex
                    buffer -> semaphores -> acquire / draw / present.
  PsyVkJNI.cpp      13 JNI exports matching the decompiled Java declarations.
  shaders/          equivalent quad GLSL, compiled .spv and compile.bat.
  Build.xml         optional hxcpp include fragment (Android only).
  ACCURACY_CHECK.txt  measured precision counters.

Integration (opt-in, Android only)
  1. Add to Project.xml:
       <include path="native/vulkan/Build.xml" if="android" />
  2. Place psyvk_quad.vert.spv and psyvk_quad.frag.spv into
     /sdcard/Android/data/<package>/files/ (or adjust the shader path).
  3. The OpenGL renderer keeps running; this renderer draws a full-screen
     overlay only. It is started from the Java Surface helper.

Verification status: see ACCURACY_CHECK.txt and ../../FINAL_COMPARISON_AUDIT.txt.
No compiler or build command was run during reconstruction.
