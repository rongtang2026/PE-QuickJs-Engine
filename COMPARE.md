# 与 Psych Engine 原版的对比

对照对象：`ShadowMario/FNF-PsychEngine` tag `1.0`（Apache-2.0）
被对照对象：PE-QuickJs-Engine 三个发布版（`1.0` / `r-1.0.0` / `1.1`）

---

## 一句话

原版是**跨平台 + LuaJIT 脚本**的 PC 引擎；这个分支把平台砍到只剩 Android、把脚本层从 Lua 换成 QuickJS、在渲染上外挂了一层实验性 Vulkan，其余部分基本沿用。

---

## 1. 工程配置

上游 `Project.xml` 原文：

```xml
<app title="Friday Night Funkin': Psych Engine" file="PsychEngine"
     packageName="com.shadowmario.psychengine" package="com.shadowmario.psychengine"
     main="Main" version="0.2.8" company="ShadowMario" />
<window width="1280" height="720" fps="60" background="#000000" hardware="true" vsync="false" />
<window if="mobile" orientation="landscape" fullscreen="true" width="0" height="0" resizable="false"/>
```

对比：

| 项 | 原版 | PE-QuickJs `1.0` | PE-QuickJs `r-1.0.0` / `1.1` |
|---|---|---|---|
| title | Friday Night Funkin': Psych Engine | 未改 | 改为 PE-QuickJs-Engine |
| package | `com.shadowmario.psychengine` | **未改** | `DingLing.pe.QuickJs.Engine` |
| version | `0.2.8` | **未改** | `1.0.0` / `1.1.0` |
| company | ShadowMario | 未改 | — |
| 移动端窗口 | `width="0" height="0"`（跟随屏幕原生分辨率） | 沿用 | 沿用，但 Vulkan 投影写死 `1280×720` |

注意最后一行：原版移动端明确用 `0×0` 让窗口取设备原生分辨率；本引擎的 Vulkan 路径在 `mMat4Ortho(m, 0, 1280, 0, 720)` 里把投影固定成了 1280×720，再拉伸到屏幕。这是**偏离上游配置**的一处。

---

## 2. 功能矩阵

| 能力 | 原版 1.0 | PE-QuickJs |
|---|---|---|
| 目标平台 | Windows / Linux / macOS / Android / HTML5 | **仅 Android** |
| 脚本语言 | Lua（LuaJIT） | **QuickJS（无 JIT）** |
| 脚本 API | 219 个 Lua 函数 | 219 个**同名** JS 函数 |
| API 调用方式 | 直接栈调用 | `JSON.stringify` → 字符串分发 → native |
| `.lua` 脚本 | 直接运行 | **不能运行** |
| HScript | `psychlua/HScript.hx` 内置 | 移除（`hscript` 库仍在，无绑定） |
| Discord RPC | 有 | 移除 |
| 移动端触控 | 无 | **14 个 `mobile/*` 类** |
| 渲染 | OpenGL（lime） | OpenGL + **Vulkan 覆盖层（实验）** |
| 防篡改 | 无 | **`Qz7` + 全屏拦截页** |
| 崩溃日志 | `crash/` | 保留并扩展（`HitchLog`、`LoadTrace`、`NativeCrashHandler`） |
| i18n | `backend/Language.hx` | 保留 + `zh-CN.lang` |
| 编辑器 | 角色/谱面/舞台/对话等 | 保留 |
| 许可文件 | Apache-2.0 全文 + 版权头 | **仓库 `license: null`，APK 内无文本** |

---

## 3. 代码层：加了什么、删了什么

以 `1.1` 的 187 个项目侧 `.hx` 文件对照上游 1.0 的 154 个：

### 删掉的（24）

| 分类 | 文件 | 后果 |
|---|---|---|
| Lua 运行时 | `psychlua/FunkinLua.hx`、`CallbackHandler.hx`、`ExtraFunctions.hx`、`ReflectionFunctions.hx`、`ShaderFunctions.hx`、`TextFunctions.hx`、`DeprecatedFunctions.hx`、`FlxAnimateFunctions.hx` | 整套 Lua 脚本体系消失 |
| HScript | `psychlua/HScript.hx` | 原版的内置 HScript 绑定没了 |
| FlxAnimate | `flxanimate/PsychFlxAnimate.hx` | 该集成移除 |
| 桌面功能 | `backend/Discord.hx` | 富媒体状态移除（移动端无意义，属合理裁剪） |
| 着色器 | `shaders/WiggleEffect.hx`、`OverlayShader.hx`、`BlendModeEffect.hx` | 三个效果失效（`ColorSwap`、`RGBPalette`、`RainShader` 保留） |
| 其他 | `import.hx`、`states/OutdatedState.hx`、`states/stages/Template.hx`、`unused/*`（7 个） | 版本提示、模板、废弃代码 |

### 加上的（约 54，另有 3 个是 lime 生成文件）

| 分类 | 代表文件 |
|---|---|
| 脚本层 | `backend/QuickJS.hx`、`psychlua/FunkinJS.hx`、`ScriptContext.hx`、`MenuScriptHost.hx` |
| 渲染层 | `backend/VulkanAndroid.hx`、`RenderBackend.hx`、`render/ModRender.hx`、`ModShader.hx`、`VulkanWarningSubState.hx` |
| 移动端 | `mobile/` 全套 14 个（MobileControls、VirtualPad、PianoKeys、MobileTextKeyboard…） |
| Android 桥 | `android/Permissions.hx`、`Settings.hx`、`content/Context.hx`、`os/Build.hx` |
| 菜单重写 | `MenuUI.hx`、`MenuNav.hx`、`MenuGestures.hx`、`states/CustomMenuState.hx` |
| 防篡改 | `backend/Qz7r.hx`、`states/SecurityNoticeState.hx` |
| 诊断 | `CrashLog.hx`、`HitchLog.hx`、`LoadTrace.hx`、`NativeCrashHandler.hx`、`FpsPanelApi.hx`、`ProcessMemory.hx` |

### 份额

```
原版 1.0 项目文件     154
本引擎（1.1）         187
其中与 1.0 重名       130
只在 1.0 有            24
只在本地有             57（含 3 个非项目文件）
```

---

## 4. 脚本层：同一个 API，两种语言

这是差异最实质的地方。

| | 原版 | PE-QuickJs |
|---|---|---|
| 引擎 | LuaJIT | QuickJS（2026-06-04 版本，无 JIT） |
| API 名 | 219 个 | 219 个，**100% 同名** |
| 源码形式 | `.lua` | `.js` |
| 老 mod | 直接可用 | **全部需要重写** |
| 单次调用成本 | 栈调用 | `JSON.stringify(args)` + 字符串分发 + native 解析 |

引擎注入的桥接脚本（`.so` 偏移 `0x25ce7b2` 原文）：

```js
g.__psych_native = function(name) {
  var args = Array.prototype.slice.call(arguments, 1);
  return __psych_dispatch(name, JSON.stringify(args));
};
```

每个 API 由包装器生成：`globalThis.<name> = (...args) => __psych_native("<name>", ...args);`

**结论**：API 名词表被完整继承，执行方式完全不同。原版 mod 生态的存量脚本一律失效——这一点与原版不存在"兼容"关系。

---

## 5. 资源

| 对比 | 结果 |
|---|---|
| `1.0` 资源 vs 上游 1.0 资源 | 同源；差异主要是上游从 `.mp3`/`.ogg` 双份中只保留 `.ogg`，以及未打包 `exclude/`、`secrets/` 等不加载目录 |
| `r-1.0.0` vs `1.1` | **871 个文件 SHA-256 全部相同，差异 0** |

也就是说，三个版本之间，游戏素材基本原封不动；`r-1.0.0` 只加了 3 张图（`vulkan_logo`、`opengl_logo`、`warn_icon`）。

---

## 6. 许可与元数据

| 项 | 原版 | 本引擎 |
|---|---|---|
| LICENSE 文件 | 有（Apache-2.0 全文） | 无 |
| 源码版权头 | 有 | 无（Haxe 编译后也不保留） |
| 仓库协议字段 | Apache-2.0 | `null` |
| APK 内许可文本 | — | 无（仅字体自带 Noto 协议） |
| NOTICE | 有则附带 | 未附带 |

Apache-2.0 允许闭源分发衍生作品，所以"不开源"本身不违约。缺的是 §4：许可证副本、修改声明、版权归属。

---

## 7. 结论

**相对原版，它多出来的**：Android 触控体系、Vulkan 实验渲染、防篡改、崩溃与卡顿诊断、菜单手势层。

**少掉的**：跨平台、Lua 脚本、HScript 绑定、Discord RPC、三个着色器效果、许可文本。

**换掉的**：脚本运行时（LuaJIT → QuickJS）、包名与版本号、资源目录（`.PsychEngine` → `.QJsEngine`）。

一句话总结：**它把 PC 引擎压缩成 Android 分支，代价是脚本生态清零；额外加的东西里，只有移动端控件是原版没有且确实需要的。**

---

## 复现

```bash
python evidence/analyze.py <apk> out.json          # 单包指标
curl -s "https://api.github.com/repos/ShadowMario/FNF-PsychEngine/git/trees/1.0?recursive=1"
```

上游文件集与本地差集见 [`evidence/cross-version/hx_by_ver.json`](evidence/cross-version/hx_by_ver.json)。
