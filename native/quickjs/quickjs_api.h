#pragma once
#include <stdint.h>
#include <stddef.h>

/* Minimal QuickJS C API declarations transcribed from quickjs-ng/quickjs
   quickjs.h. libApplicationMain.so exports these JS_* names in .dynsym;
   DWARF is stripped, so handles stay opaque. PSYQJS_NAN_BOXING selects the
   JSValue layout documented by the upstream header (64-bit default). */
#ifndef PSYQJS_NAN_BOXING
#define PSYQJS_NAN_BOXING 1
#endif

extern "C" {
typedef struct JSRuntime JSRuntime;
typedef struct JSContext JSContext;

#if PSYQJS_NAN_BOXING
typedef uint64_t JSValue;
#else
typedef union JSValueUnion {
    uint64_t uint64;
    double float64;
    void* ptr;
    int32_t short_big_int;
} JSValueUnion;
typedef struct JSValue {
    JSValueUnion u;
    int64_t tag;
} JSValue;
#endif
typedef JSValue JSValueConst;
#define JS_EVAL_TYPE_GLOBAL 0

JSRuntime* JS_NewRuntime2(const void* mf, void* opaque);
void       JS_FreeRuntime(JSRuntime* rt);
JSContext* JS_NewContextRaw(JSRuntime* rt);
JSContext* JS_NewContext(JSRuntime* rt);
void       JS_FreeContext(JSContext* ctx);
JSValue    JS_Eval(JSContext* ctx, const char* input, size_t input_len,
                   const char* filename, int eval_flags);
JSValue    JS_Call(JSContext* ctx, JSValueConst func_obj, JSValueConst this_obj,
                   int argc, JSValueConst* argv);
JSValue    JS_GetGlobalObject(JSContext* ctx);
JSValue    JS_GetPropertyStr(JSContext* ctx, JSValueConst this_obj, const char* prop);
JSValue    JS_GetPropertyUint32(JSContext* ctx, JSValueConst this_obj, uint32_t idx);
JSValue    JS_ParseJSON(JSContext* ctx, const char* buf, size_t buf_len, const char* filename);
int        JS_ToInt32(JSContext* ctx, int32_t* pres, JSValueConst val);
JSValue    JS_GetException(JSContext* ctx);
int        JS_ExecutePendingJob(JSRuntime* rt, JSContext** pctx);
bool       JS_IsFunction(JSContext* ctx, JSValueConst val);
}
