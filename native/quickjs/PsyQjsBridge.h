#pragma once
#ifdef __cplusplus
extern "C" {
#endif
void*       psyqjs_new_runtime(void);
void*       psyqjs_new_context(void* runtime);
void        psyqjs_free_context(void* context);
void        psyqjs_free_runtime(void* runtime);
int         psyqjs_eval(void* context, const char* code, const char* filename);
int         psyqjs_call(void* context, const char* name, const char* json_args);
int         psyqjs_execute_pending_job(void* runtime);
int         psyqjs_available(void);
const char* psyqjs_last_error(void);
#ifdef __cplusplus
}
#endif
