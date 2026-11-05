# PE-QuickJs-Engine 逆向取证报告

**对象**：`PEQuickJsEngine-debug-test.apk`
**大小**：400,750,869 字节
**SHA-256**：`2a24ebb00bb15efcc2d25eebda88d2067a2386554649d9e77cc0de961bf67142`
**作者声明**：基于 Psych Engine **0.7.3**
**实际基底**：Psych Engine **1.0**（见第 4 节）
**上游**：ShadowMario/FNF-PsychEngine（Apache-2.0）
**日期**：2026-11-05（第二版）

---

## 0. 结论摘要

| # | 结论 | 置信度 |
|---|---|---|
| 1 | **代码基底是 1.0，不是 README 声称的 0.7.3**。文件集与 1.0 交集 130/187，与 0.7.3 仅 96/187；34 个文件只存在于 1.0，**0 个**只存在于 0.7.3 | 高 |
| 2 | 这是 Psych 的 Haxe 源码分支，**不是重写**。`endBullshit`、`reloadAllShit`、`grpMenuShit` 等原版命名原样保留 | 高 |
| 3 | Lua **运行时被整体移除**（`lua_*`/`luaL_*`/LuaJIT 符号 0），但 1.0 的 **219 个 Lua API 函数名全部按原名保留（219/219）**，改由 QuickJS 执行 | 高 |
| 4 | QuickJS 集成是真实实现（`backend.QuickJS.hx`，`JS_NewRuntime2`/`JS_Eval`/`JS_Call`），非占位 | 高 |
| 5 | Vulkan 确实调了 Vulkan API（65 个 `vk*` 函数），但是**旁挂渲染**：OpenGL 仍在底下运行、单 render pass、贴图槽上限 47、投影矩阵写死 **1280×720** | 高 |
| 6 | 包内存在**完整性校验**（`Qz7` 按 ZIP 条目算 SHA-256，`Qz7r` 控制 `scriptsAllowed`），改包即触发 "This copy of the game was modified or re-signed." | 高 |
| 7 | 与 Apache-2.0 §4 的许可文本义务不符：仓库 `license` 为 null，APK 内无 LICENSE/NOTICE | 高 |
| 8 | 资源包同样来自 1.0：含 `weekend1/` 全套、`Voices-Player/Player-Opponent` 拆分人声、`zh-CN.lang`，与 README 声明的 0.7.3 不符 | 高 |

> 本报告只就下列可复现的技术事实作说明，不涉及其他社区讨论中的具体指控。

---

## 1. 方法与可复现性

### 环境与命令

```
JDK 17 (Temurin 17.0.13+11)、apktool 2.11.1、python 3.13
jadx 1.5.1 —— 本机不可用，改用 apktool smali
```

```bash
java -jar apktool.jar d -f -s -o apktool_out PEQuickJsEngine-debug-test.apk
java -jar apktool.jar d -f --no-assets -o apktool_full PEQuickJsEngine-debug-test.apk
python scan.py lib/arm64-v8a/libApplicationMain.so <quickjs|lua|path|jni|version>
```

### 方法学限制

1. **未做动态分析**（未安装运行）。全部为静态取证。
2. **“文件不存在”是推断**：依据 `.so` 内残留的 `.hx` 路径字符串。Haxe 为每个参与的类保留源文件名与符号，但空类或纯类型别名可能被漏掉。关键结论（Lua 运行时移除、基底版本）均有独立证据交叉验证。
3. **基准版本取 1.0**。版本判断依据第 4 节的文件集交集；若基准选错，差集数字会整体偏移，因此本节同时给出两个 tag 的对照。
4. jadx 在本机 Java 26 与 JDK 17 下均加载 303 个类后静默退出，Java 层证据取自 smali 反汇编。

---

## 2. 包体与清单

| 字段 | 值 |
|---|---|
| package | `DingLing.pe.QuickJs.Engine` |
| versionName / Code | `1.1.0` / `476` |
| minSdk / targetSdk | `21` / `30` |
| debuggable | **`true`** |
| 主 Activity | `DingLing.pe.QuickJs.Engine.MainActivity`，继承 `org.haxe.lime.GameActivity` |
| 高敏权限 | `MANAGE_EXTERNAL_STORAGE`、`READ_PHONE_STATE`、`READ/WRITE_EXTERNAL_STORAGE` |

清单基本是 lime 模板原样输出，连 iOS 专用键 `SDL_ENV.SDL_IOS_ORIENTATIONS` 都保留。

### 2.1 一个包名，两份类

反汇编出 303 个类：新包名 `DingLing/pe/QuickJs/Engine/` 14 个，旧包名 `com/shadowmario/psychengine/` **10 个同名类残留**（MainActivity、MemoryInfoHelper、VulkanSurfaceHelper 及 7 个内部类）。两套 MainActivity 内容完全相同，都是空的 `GameActivity` 子类。改包名后未清理旧生成文件，白占约 170KB。

### 2.2 体积构成

| 组件 | 大小 |
|---|---|
| `lib/arm64-v8a/libApplicationMain.so` | 49.6 MB |
| `lib/arm64-v8a/libvlc.so` | 43.2 MB |
| `assets/assets/` | 310 MB |
| 其余（liblime、libc++、dex、res） | ~10 MB |

---

## 3. 资源构成

```
assets/
├── do NOT readme.txt          4,326 B   原版 FNF 的 readme
├── modsList.txt               0 B       空文件
└── assets/                    310 MB    游戏资源
    ├── songs/                 151 MB
    ├── shared/                 88 MB
    ├── videos/                 27 MB
    ├── week1..week7, weekend1  ~40 MB
    ├── fonts/                 8.1 MB
    └── embed/                 11 KB
```

与上游 1.0 的资产清单（把 `assets/base_game/` 映射回 `assets/`）对比：

| 项 | 数量 |
|---|---|
| 上游 1.0 资产 | 1,050 |
| APK 资产 | 871 |

APK 独有的 34 项里，除 haxelib 的 flixel/flxanimate 资源外，是他自己加的 `vulkan_logo.png`、`opengl_logo.png`、`warn_icon.png`、`hitbox/`、`shared/scripts/demo.js`、`menu_demo.js` 等。

这里的关键不是数量差，而是**资源包的语言版本特征**：拆分人声、`zh-CN.lang`、`weekend1/` 全部是 1.0 的约定（详见第 4 节）。

---

## 4. 基底版本：声明 0.7.3，实为 1.0

用 `.so` 内 187 个有效 `.hx` 路径（剔除 flixel/openfl/lime 等第三方库）分别与两个上游 tag 做交集：

| 基准 | 上游文件数 | 交集 | 占项目 |
|---|---|---|---|
| tag `0.7.3` | 129 | 96 | 51.3% |
| tag `1.0` | 154 | **130** | **69.5%** |

更决定性的是不对称性：

- **34 个文件只存在于 1.0、0.7.3 里没有，而他全都有**：
  `backend/Language.hx`、`options/LanguageSubState.hx`、`options/VisualsSettingsSubState.hx`、`options/NotesColorSubState.hx`、`states/ErrorState.hx`、`states/stages/PhillyStreets.hx`、`states/stages/PhillyBlazin.hx`、`states/stages/objects/ABotSpeaker.hx`、`states/editors/content/*`（8 个）、`objects/VideoSprite.hx` 等
- **0 个文件只存在于 0.7.3、1.0 里没有**

资源侧独立印证：APK 含 `assets/weekend1/` 全套（Weekend 1 是 1.0 内容）、`Voices-Player.ogg` / `Voices-Opponent.ogg` 拆分人声（1.0 约定，0.7.3 是单个 `Voices.ogg`）、`assets/shared/data/zh-CN.lang`（1.0 的 i18n）。

**结论**：README 里 “based on the original Psych Engine 0.7.3” 与实际产物不符。

### 4.1 以 1.0 为基准的源码差集

项目 187 个文件，上游 1.0 的 154 个 → **新增 57，缺失 24**。

**他删掉的（24）**

| 文件 | 说明 |
|---|---|
| `psychlua/FunkinLua.hx` | Lua 解释器接入主体 |
| `psychlua/CallbackHandler.hx` | Lua 回调分发 |
| `psychlua/ExtraFunctions.hx` | 扩展函数注册表 |
| `psychlua/ReflectionFunctions.hx` | 反射类函数 |
| `psychlua/ShaderFunctions.hx` | 着色器函数 |
| `psychlua/TextFunctions.hx` | 文本函数 |
| `psychlua/DeprecatedFunctions.hx` | 兼容层 |
| `psychlua/FlxAnimateFunctions.hx` | FlxAnimate 绑定 |
| `psychlua/HScript.hx` | HScript 封装（库本体仍在） |
| `flxanimate/PsychFlxAnimate.hx` | FlxAnimate 集成 |
| `backend/Discord.hx` | 移动端无 Discord |
| `shaders/BlendModeEffect.hx`、`OverlayShader.hx`、`WiggleEffect.hx` | 三个着色器效果 |
| `states/OutdatedState.hx`、`states/stages/Template.hx`、`unused/*`（7 个）、`import.hx` | 版本提示页、模板、废弃代码 |

**他新增的（57，摘录）**

- 脚本层：`backend/QuickJS.hx`、`psychlua/FunkinJS.hx`、`backend/ScriptContext.hx`、`backend/MenuScriptHost.hx`
- 渲染层：`backend/VulkanAndroid.hx`、`backend/RenderBackend.hx`、`render/ModRender.hx`、`render/ModShader.hx`、`shaders/ErrorHandledShader.hx`、`substates/VulkanWarningSubState.hx`
- 移动端：`mobile/` 下 14 个（MobileControls、VirtualPad、PianoKeys、MobileTextKeyboard 等）+ `options/MobileSettingsSubState.hx`
- Android 桥：`android/Permissions.hx`、`android/Settings.hx`、`android/content/Context.hx`、`android/os/Build.hx`
- 后端杂项：`CrashLog`、`NativeCrashHandler`、`HitchLog`、`LoadTrace`、`FpsPanelApi`、`ScoreRank`、`NoteLanes`、`Physics`、`MenuUI`、`MenuNav`、`MenuGestures`、`ApiDocs`、`Qz7r`、`states/CustomMenuState.hx`、`states/SecurityNoticeState.hx`

---

## 5. 脚本层：名字是 Lua 的，引擎是 JS 的

### 5.1 Lua 运行时确实不存在

```
^lua_[a-z]      0 条
^luaL_[a-z]     0 条
LuaJIT          0 条
lua_newstate    0 条
lua_pcall       0 条
```

### 5.2 但 1.0 的 API 名一个不少

从上游 1.0 的 `source/psychlua/*.hx` 提取 `add_callback(lua, "name", ...)` / `.set("name", ...)` 注册的函数名，共 **219 个**；在 APK 的 `.so` 中按原名存在 **219 个（100%）**。

`psychlua.FunkinJS` 暴露 124 个方法，注册器按域切分：

```
registerCoreFunctions      registerGameFunctions     registerGameFunctions2
registerInputFunctions     registerMenuFunctions     registerFileFunctions
registerBackendFunctions    registerAnimateFunctions
```

连 `psychlua.FunkinJS.initLuaShader` 这种名字里带 Lua 的方法都保留着。

**结论**：所谓“Lua 兼容”是**函数名兼容**，不是脚本兼容。219 个函数名齐全，却没有一行动能执行 `.lua` 文件——把 `makeLuaSprite(...)` 改写成 JS 语法后才能调用同名实现。

### 5.3 QuickJS 集成是真的

```
backend.QuickJS.hx:
  new / eval / call / hasFunction / setGlobal / getGlobal
  runPendingJobs / handleNative / onDispatch / boot
  encodeResult / encodeArgs / parseResult / close
底层: JS_NewRuntime2 / JS_Eval / JS_Call / JS_CallConstructor / JS_EvalFunction
版本串: QuickJS memory usage -- 2026-06-04 version, %d-bit, malloc limit: %ld
```

---

## 6. Vulkan：真实现了，但只是旁挂，且分辨率写死

### 6.1 实现深度

`libApplicationMain.so` 中出现 **65 个不同的 `vk*` 函数**，覆盖 instance/device、swapchain、render pass、pipeline、descriptor、command buffer、image 上传、present 全链路。

边界同样明确：

- **单 render pass**（`vkCmdBeginRenderPass` 只有一对），无深度附件、无 MSAA
- 贴图槽**硬上限 47**：`[VulkanAndroid] texture slots are full (47), further sprites will not be drawn`
- 他自己写的说明：`OpenGL keeps running underneath until the Vulkan path fully replaces it, so switch back if anything looks wrong.` → 覆盖层，不是替换
- 切换前弹 `substates/VulkanWarningSubState`，文案 `The Vulkan renderer is still experimental.`
- **投影矩阵写死 1280×720**：`mMat4Ortho(m, 0, 1280, 0, 720)` → Vulkan 路径把画面渲染在 1280×720，再拉伸到设备分辨率

### 6.2 Java 侧的 “VulkanSurfaceHelper” 是 Canvas 文字层

6,249 行 smali、57 个方法，**不含任何 OpenGL/EGL/Vulkan API 调用**（`android/opengl`、`javax/microedition/khronos`、`libvulkan` 命中均为 0）。实际调用是：

```
Canvas.drawText ×4     Paint.setTextSize / setColor / setShadowLayer
Typeface.DEFAULT_BOLD  Bitmap.createBitmap / setPixel / getPixels / recycle
```

它管理一个 `SurfaceView`，把 Surface 交给 native，同时用 Canvas 画 HUD 文字；native 通过 `nativePushTextQuad`、`nativeSetHudValues`、`nativeGetHudLine` 与之通信。

### 6.3 关于“糊”和“崩”

issue 原文的时序是“切换到 Vulkan 后进 Weekend1，崩溃”。可对应的静态事实有两条：Vulkan 路径固定 1280×720 再拉伸（糊），以及贴图槽上限 47（Weekend1 的 PhillyStreets 场景素材数量明显超过该值，超限后直接跳过绘制）。**但崩溃本身未做动态复现，不作为结论。**

---

## 7. 完整性校验：闭源之外还有防改

`DingLing/pe/QuickJs/Engine/Qz7`（18.5KB smali）：

1. `b()/c()/d()` 取 `PackageInfo`、读签名（`GET_SIGNATURES`）
2. 遍历 ZIP 条目（`classes*.dex`、`assets/`、`lib/`、`res/`、`META-INF/`、`AndroidManifest.xml`、`resources.arsc`），用 SHA-256 逐项摘要，与内嵌 32 字节表比对（`v()[B`、`a(I)I` 按下标取 4 字节大端）
3. `okRoot(String)` / `okSo(String)` 检查 root 痕迹与 so 存在性

对应 Haxe 侧 `backend/Qz7r.hx`（`boot`、`scriptsAllowed`）。失败文案：

```
This copy of the game was modified or re-signed.
```

含义：改包名、去 dex、换 so、重签名都会命中，命中后脚本功能被关。当前包 `debuggable=true` 且为 debug 签名，是测试构建而非 `r-` 正式版。

---

## 8. 协议合规性

| 项 | 状态 |
|---|---|
| 上游 Psych Engine | Apache License 2.0（GitHub API `license.spdx_id = Apache-2.0`） |
| 本项目仓库 | `license: null`，README 明示“我不想走老一辈的老路” |
| APK 内许可文件 | 全量检索 `license|notice|copying`，仅 `NotoSansSC-LICENSE.txt` |
| 归属声明 | `Psych Engine by` 等字符串留在 `.so`，但无版权声明文本、无许可证副本、无 NOTICE |
| 第三方 | `libvlc.so`（LGPL-2.1+）随包分发，无许可证与源码获取说明 |

Apache-2.0 **允许**闭源分发衍生作品，所以“闭源”本身不违约。争议在第 4 条：

- **§4(a)** 向接收者提供许可证副本 —— 未提供
- **§4(b)** 修改过的文件须保留显著修改声明 —— 无
- **§4(c)** 保留原有版权、专利、商标、归属声明 —— 源码版权头随编译消失，仅剩非正式 credits
- **§4(d)** 原作品含 NOTICE 时须附带 —— 未附带

**准确表述**：闭源合法，不带许可证副本与归属声明分发不合法。

附带一条：README 声明基于 0.7.3，实际基于 1.0，这属于对来源的失实陈述——与许可义务是两件事，但同样影响可信度。

---

## 9. 与社区批评的逐条核对

| 批评 | 判定 | 依据 |
|---|---|---|
| 删掉 Lua 却“兼容” Lua | **成立** | 运行时符号 0；219 个 API 名 100% 保留 |
| 引擎是 Psych 换皮 | **成立** | 原版命名、credits、130/187 文件重合 |
| Vulkan 完整度低 | **成立（有具体边界）** | 65 个 vk 函数但单 pass、47 槽、OpenGL 兜底、投影固定 720P、自称 experimental |
| 声明 0.7.3 | **不实** | 与 1.0 交集 130，与 0.7.3 仅 96；34 个 1.0 独有文件 |
| 锁 720P | **部分成立** | Vulkan 投影矩阵写死 1280×720；OpenGL 路径未取证 |
| 进场崩溃 | **未验证** | 需动态复现；47 槽上限是可对应的事实，非结论 |
| 作者回复态度恶劣 | **有记录** | issue #2：“用不惯就用别的引擎去 别搁这瞎逼逼” |
| 作者回复疑似 AI 生成 | **间接证据** | issue #6 回复结尾附 `chat.deepseek.com/share/…` |


## 10. 仓库结构

```
.
├── README.md                      本报告
├── NOTICE.md                      反汇编内容的来源与许可
├── LICENSE-APACHE-2.0.txt         Apache-2.0 全文
├── report/report.html             排版版
├── findings/                      关键发现摘录
├── evidence/
│   ├── AndroidManifest.xml
│   ├── smali/                     303 个类的反汇编
│   ├── native/                    QuickJS/Lua/路径/JNI 字符串、65 个 vk* 全表、1099 条 .hx 路径
│   ├── data/                      vs_1.0_diff.json、assets_diff_10.json、Lua API 名单
│   ├── upstream/ upstream10/      上游 0.7.3 与 1.0 的 psychlua 原文
│   └── assets/assets-file-list.txt
```

未入库：APK（400MB）、`.so`（100MB）、`assets/assets/`（310MB），超出 GitHub 单文件限制。校验值见文首。
