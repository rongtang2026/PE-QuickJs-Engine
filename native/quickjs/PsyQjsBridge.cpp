#include "PsyQjsBridge.h"
#include "quickjs_api.h"
#include <dlfcn.h>
#include <cstring>
#include <cstdlib>
#include <vector>
#include <string>

namespace {
template <typename T> T sym(const char* name)
{
    return reinterpret_cast<T>(dlsym(RTLD_DEFAULT, name));
}
typedef JSRuntime* (*new_runtime_fn)(const void*, void*);
typedef void       (*free_runtime_fn)(JSRuntime*);
typedef JSContext* (*new_context_fn)(JSRuntime*);
typedef void       (*free_context_fn)(JSContext*);
typedef JSValue    (*eval_fn)(JSContext*, const char*, size_t, const char*, int);
typedef JSValue    (*call_fn)(JSContext*, JSValueConst, JSValueConst, int, JSValueConst*);
typedef JSValue    (*get_global_fn)(JSContext*);
typedef JSValue    (*get_prop_fn)(JSContext*, JSValueConst, const char*);
typedef JSValue    (*get_index_fn)(JSContext*, JSValueConst, uint32_t);
typedef JSValue    (*parse_json_fn)(JSContext*, const char*, size_t, const char*);
typedef int        (*to_int32_fn)(JSContext*, int32_t*, JSValueConst);
typedef int        (*pending_job_fn)(JSRuntime*, JSContext**);

std::string lastError;

int ready()
{
    return sym<new_runtime_fn>("JS_NewRuntime2") != nullptr &&
           sym<new_context_fn>("JS_NewContext") != nullptr &&
           sym<eval_fn>("JS_Eval") != nullptr &&
           sym<call_fn>("JS_Call") != nullptr ? 1 : 0;
}
}

extern "C" {

int psyqjs_available(void) { return ready(); }

const char* psyqjs_last_error(void) { return lastError.c_str(); }

void* psyqjs_new_runtime(void)
{
    auto fn = sym<new_runtime_fn>("JS_NewRuntime2");
    if (!fn) { lastError = "JS_NewRuntime2 missing"; return nullptr; }
    return fn(nullptr, nullptr);
}

void* psyqjs_new_context(void* runtime)
{
    auto fn = sym<new_context_fn>("JS_NewContext");
    if (!fn) fn = sym<new_context_fn>("JS_NewContextRaw");
    if (!fn || !runtime) { lastError = "JS_NewContext missing"; return nullptr; }
    return fn(static_cast<JSRuntime*>(runtime));
}

void psyqjs_free_context(void* context)
{
    auto fn = sym<free_context_fn>("JS_FreeContext");
    if (fn && context) fn(static_cast<JSContext*>(context));
}

void psyqjs_free_runtime(void* runtime)
{
    auto fn = sym<free_runtime_fn>("JS_FreeRuntime");
    if (fn && runtime) fn(static_cast<JSRuntime*>(runtime));
}

int psyqjs_eval(void* context, const char* code, const char* filename)
{
    auto fn = sym<eval_fn>("JS_Eval");
    if (!fn || !context || !code) { lastError = "JS_Eval unavailable"; return 0; }
    JSValue ret = fn(static_cast<JSContext*>(context), code, strlen(code),
                     filename ? filename : "<eval>", JS_EVAL_TYPE_GLOBAL);
    (void)ret;
    return 1;
}

int psyqjs_call(void* context, const char* name, const char* json_args)
{
    auto getGlobal = sym<get_global_fn>("JS_GetGlobalObject");
    auto getProp   = sym<get_prop_fn>("JS_GetPropertyStr");
    auto getIndex  = sym<get_index_fn>("JS_GetPropertyUint32");
    auto parseJson = sym<parse_json_fn>("JS_ParseJSON");
    auto toInt32   = sym<to_int32_fn>("JS_ToInt32");
    auto call      = sym<call_fn>("JS_Call");
    if (!getGlobal || !getProp || !call || !context || !name)
    { lastError = "JS_Call path unavailable"; return 0; }

    JSContext* ctx = static_cast<JSContext*>(context);
    JSValue global = getGlobal(ctx);
    JSValue func = getProp(ctx, global, name);

    std::vector<JSValue> argv;
    if (parseJson && getIndex && toInt32 && json_args)
    {
        JSValue arr = parseJson(ctx, json_args, strlen(json_args), "<args>");
        JSValue lenVal = getProp(ctx, arr, "length");
        int32_t count = 0;
        toInt32(ctx, &count, lenVal);
        if (count > 0 && count < 64)
        {
            argv.resize(count);
            for (int32_t i = 0; i < count; ++i) argv[i] = getIndex(ctx, arr, (uint32_t)i);
        }
    }
    JSValue ret = call(ctx, func, global, (int)argv.size(),
                       argv.empty() ? nullptr : argv.data());
    (void)ret;
    return 1;
}

int psyqjs_execute_pending_job(void* runtime)
{
    auto fn = sym<pending_job_fn>("JS_ExecutePendingJob");
    if (!fn || !runtime) return 0;
    JSContext* ctx = nullptr;
    return fn(static_cast<JSRuntime*>(runtime), &ctx);
}

}
