// 从 libApplicationMain.so 偏移 0x25ce7b2 提取的 JS 预置脚本原文
__psych_dispatch(function(g) {
  g.__psych_invoke = function(fn, argsJson) {
    var args = argsJson ? JSON.parse(argsJson) : [];
    return fn.apply(undefined, args);
  };
  g.__psych_native = function(name) {
    var args = Array.prototype.slice.call(arguments, 1);
    return __psych_dispatch(name, JSON.stringify(args));
  };
})(globalThis);

// 每个 API 的包装器模板（同文件内）:
// globalThis.<name> = (...args) => __psych_native("<name>", ...args);
