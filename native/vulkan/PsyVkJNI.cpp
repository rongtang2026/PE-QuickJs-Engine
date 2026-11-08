#include "PsyVkRenderer.h"
#include <jni.h>
#include <android/native_window_jni.h>
#include <android/log.h>
#include <vector>

extern "C" {

JNIEXPORT jstring JNICALL
Java_DingLing_pe_QuickJs_Engine_VulkanSurfaceHelper_nativeCreate(
    JNIEnv* env, jclass, jobject surface, jint width, jint height)
{
    ANativeWindow* window = ANativeWindow_fromSurface(env, surface);
    if (!window) return env->NewStringUTF("ANativeWindow_fromSurface returned null");
    std::string err = psyvk_create(window, width, height);
    if (!err.empty()) { ANativeWindow_release(window); return env->NewStringUTF(err.c_str()); }
    return env->NewStringUTF("");
}

JNIEXPORT void JNICALL
Java_DingLing_pe_QuickJs_Engine_VulkanSurfaceHelper_nativeDestroy(JNIEnv*, jclass)
{ psyvk_destroy(); }

JNIEXPORT jstring JNICALL
Java_DingLing_pe_QuickJs_Engine_VulkanSurfaceHelper_nativeInfo(JNIEnv* env, jclass)
{ return env->NewStringUTF(psyvk_info().c_str()); }

JNIEXPORT jstring JNICALL
Java_DingLing_pe_QuickJs_Engine_VulkanSurfaceHelper_nativeGetHudLine(
    JNIEnv* env, jclass, jint id)
{ return env->NewStringUTF(psyvk_hud_line(id).c_str()); }

JNIEXPORT void JNICALL
Java_DingLing_pe_QuickJs_Engine_VulkanSurfaceHelper_nativeSetTexture(
    JNIEnv* env, jclass, jintArray pixels, jint width, jint height)
{
    jsize n = env->GetArrayLength(pixels);
    std::vector<jint> buf(n);
    env->GetIntArrayRegion(pixels, 0, n, buf.data());
    psyvk_set_texture(0, buf.data(), width, height);
}

JNIEXPORT void JNICALL
Java_DingLing_pe_QuickJs_Engine_VulkanSurfaceHelper_nativeAddTexture(
    JNIEnv* env, jclass, jint slot, jintArray pixels, jint width, jint height)
{
    jsize n = env->GetArrayLength(pixels);
    std::vector<jint> buf(n);
    env->GetIntArrayRegion(pixels, 0, n, buf.data());
    psyvk_add_texture(slot, buf.data(), width, height);
}

JNIEXPORT void JNICALL
Java_DingLing_pe_QuickJs_Engine_VulkanSurfaceHelper_nativeSetAtlas(
    JNIEnv* env, jclass, jintArray pixels, jint width, jint height,
    jintArray rects, jint count)
{
    jsize n = env->GetArrayLength(pixels);
    std::vector<jint> buf(n);
    env->GetIntArrayRegion(pixels, 0, n, buf.data());
    jsize rn = env->GetArrayLength(rects);
    std::vector<jint> rbuf(rn);
    env->GetIntArrayRegion(rects, 0, rn, rbuf.data());
    psyvk_set_atlas(buf.data(), width, height, rbuf.data(), count);
}

JNIEXPORT void JNICALL
Java_DingLing_pe_QuickJs_Engine_VulkanSurfaceHelper_nativeSetText(
    JNIEnv* env, jclass, jintArray pixels, jint id, jint color)
{
    jsize n = env->GetArrayLength(pixels);
    std::vector<jint> buf(n);
    env->GetIntArrayRegion(pixels, 0, n, buf.data());
    psyvk_set_text(id, buf.data(), 1, n);
}

JNIEXPORT void JNICALL
Java_DingLing_pe_QuickJs_Engine_VulkanSurfaceHelper_nativeClearText(JNIEnv*, jclass)
{ psyvk_clear_text(); }

JNIEXPORT void JNICALL
Java_DingLing_pe_QuickJs_Engine_VulkanSurfaceHelper_nativeSetHudValues(
    JNIEnv* env, jclass, jfloatArray values, jint count)
{
    jsize n = env->GetArrayLength(values);
    std::vector<jfloat> buf(n);
    env->GetFloatArrayRegion(values, 0, n, buf.data());
    psyvk_set_hud_values(buf.data(), count);
}

JNIEXPORT void JNICALL
Java_DingLing_pe_QuickJs_Engine_VulkanSurfaceHelper_nativeSubmitQuads(
    JNIEnv* env, jclass, jfloatArray quads, jint count)
{
    jsize n = env->GetArrayLength(quads);
    std::vector<jfloat> buf(n);
    env->GetFloatArrayRegion(quads, 0, n, buf.data());
    psyvk_submit_quads(buf.data(), count);
}

JNIEXPORT void JNICALL
Java_DingLing_pe_QuickJs_Engine_VulkanSurfaceHelper_nativePumpQuads(JNIEnv*, jclass)
{ psyvk_pump_quads(); psyvk_draw_frame(); }

JNIEXPORT void JNICALL
Java_DingLing_pe_QuickJs_Engine_VulkanSurfaceHelper_nativePushTextQuad(
    JNIEnv*, jclass, jfloat x, jfloat y, jfloat w, jfloat h, jint slot)
{ psyvk_push_text_quad(x, y, w, h, slot); }

} // extern "C"
