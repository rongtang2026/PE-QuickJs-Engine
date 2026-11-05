# PE-QuickJs-Engine 逆向取证报告

**对象**：`PEQuickJsEngine-debug-test.apk`
**大小**：400,750,869 字节
**SHA-256**：`2a24ebb00bb15efcc2d25eebda88d2067a2386554649d9e77cc0de961bf67142`
**上游**：ShadowMario/FNF-PsychEngine，tag `0.7.3`（commit `2dfa277`），Apache-2.0
**日期**：2026-11-05

---

## 0. 结论摘要

| # | 结论 | 置信度 |
|---|---|---|
| 1 | 这是 Psych Engine 0.7.3 的 Haxe 源码分支，**不是重写**。原生符号里保留了 `endBullshit`、`reloadAllShit`、`grpMenuShit` 等原版命名 | 高 |
| 2 | Lua **运行时被整体移除**（`.so` 中 `lua_*`/`luaL_*`/LuaJIT 符号为 0），但 **215 个 Lua API 函数名中有 211 个按原名保留**，改由 QuickJS 执行 | 高 |
| 3 | QuickJS 集成是真实实现（`backend.QuickJS.hx`，`JS_NewRuntime2`/`JS_Eval`/`JS_Call`），非占位 | 高 |
| 4 | 所谓 Vulkan **确实调了 Vulkan API**（65 个 `vk*` 函数），但只是旁挂渲染：OpenGL 仍在底下运行、单 render pass、**贴图槽上限 47**，官方文案自称 "still experimental" | 高 |
| 5 | 包内存在**完整性校验**（`Qz7` 遍历 ZIP 条目算 SHA-256，`Qz7r` 决定 `scriptsAllowed`），失败提示 "This copy of the game was modified or re-signed." | 高 |
| 6 | 与 Apache-2.0 的**许可文本义务不符**：仓库 `license` 字段为 null，APK 内无任何 LICENSE/NOTICE（仅字体自带一份） | 高 |
| 7 | 早期流传的"APK 里没有资源"说法**不成立**：`assets/assets/` 有 310MB、856 个文件，week1–7、weekend1、songs、shared、videos 齐全 | 高 |

> 修正说明：本报告初版曾据一次错误的解包结果（`unzip` 的 `*` 通配符不跨目录层级，导致只解出 2 个文件）判定"assets 为空"。重新完整解包后该结论作废，已在第 3 节更正。方法学教训见第 1 节。

---

## 1. 方法与可复现性

### 环境

```
JDK 17 (Temurin 17.0.13+11)   —— 用于 apktool
apktool 2.11.1                —— 清单/资源/smali
jadx 1.5.1                    —— 未能完成（见下）
python 3.13                   —— 自写 ELF 字符串提取 tools/scan.py
```

### 命令

```bash
# 清单与资源
java -jar apktool.jar d -f -s -o apktool_out PEQuickJsEngine-debug-test.apk

# dex -> smali（jadx 不可用时的替代路径）
java -jar apktool.jar d -f --no-assets -o apktool_full PEQuickJsEngine-debug-test.apk

# native 字符串
python tools/scan.py lib/arm64-v8a/libApplicationMain.so <quickjs|lua|hscript|path|jni|version>
```

### 方法学限制

1. **jadx 未能产出结果**：在本机 Java 26 与 JDK 17 下均以 SIGTERM 结束（加载 303 个类后静默退出），故 Java 层证据取自 apktool 的 smali 反汇编。smali 可读性低于 Java，但足以定位 API 调用与常量。
2. **"文件不存在"属于推断**：第 4 节的源码树对比基于 `.so` 内残留的 `.hx` 路径字符串。Haxe 编译器会为每个参与的类保留源文件名与完整符号，因此缺失基本可信；但若某文件未产生任何字符串（空类、纯类型别名），可能被误判为缺失。涉及关键结论（如 Lua 运行时移除）均已用独立证据交叉验证（`lua_*` C 符号为 0）。
3. 未做动态分析（未安装运行 APK），所有结论为静态取证。

---

## 2. 包体与清单

`apktool_out/AndroidManifest.xml`：

| 字段 | 值 |
|---|---|
| package | `DingLing.pe.QuickJs.Engine` |
| versionName / Code | `1.1.0` / `476` |
| minSdk / targetSdk | `21` / `30` |
| debuggable | **`true`** |
| 主 Activity | `DingLing.pe.QuickJs.Engine.MainActivity`，继承 `org.haxe.lime.GameActivity` |
| 权限 | `MANAGE_EXTERNAL_STORAGE`、`READ_PHONE_STATE`、`READ/WRITE_EXTERNAL_STORAGE`、`INTERNET` 等 |

清单结构基本是 lime 模板原样输出，连 iOS 专用键 `SDL_ENV.SDL_IOS_ORIENTATIONS` 都保留着。

### 2.1 一个包名，两份类

反汇编出 303 个类，其中：

- `DingLing/pe/QuickJs/Engine/` —— 14 个
- `com/shadowmario/psychengine/` —— **10 个同名类残留**（MainActivity、MemoryInfoHelper、VulkanSurfaceHelper 及其 7 个内部类）

两套 MainActivity 内容完全相同（都是空的 `GameActivity` 子类）。`VulkanSurfaceHelper.smali` 在新包名下 6,249 行、57 个方法、156KB smali；旧包名下另存一份。这是**改包名后未清理旧生成文件**的典型残留，直接给 APK 增加约 170KB 无效字节。

### 2.2 体积构成

| 组件 | 大小 |
|---|---|
| `lib/arm64-v8a/libApplicationMain.so` | 49.6 MB |
| `lib/arm64-v8a/libvlc.so` | 43.2 MB |
| `assets/assets/` | 310 MB |
| 其余（liblime、libc++、dex、res） | ~10 MB |

---

## 3. 资源：不是"没打包"，是"打包了但门口没铺路"

完整解包后 `assets/` 有两层：

```
assets/
├── do NOT readme.txt          4,326 B   原版 FNF 的 readme（含 "i stole this from stamper"）
├── modsList.txt               0 B       空文件
└── assets/                    310 MB    真正的游戏资源
    ├── songs/                 151 MB    （songs 目录，非 charts）
    ├── shared/                 88 MB    characters/data/images/music/scripts/sounds/stages/weeks
    ├── videos/                 27 MB
    ├── week1..week7, weekend1  ~40 MB
    ├── fonts/                 8.1 MB
    └── embed/                  11 KB
```

共 871 个文件（`assets/` 全树），资源是**齐的**：week1–7、weekend1 的图、音、谱都在。

值得注意的只有两点：

1. **多套了一层 `assets/assets/`**。Psych 的 `Project.xml` 把 `assets/` 目录整体打进 APK，于是运行时路径成了 `assets/assets/...`。引擎自己的 `Paths.hx` 若按 `assets/` 前缀拼路径，需要额外适配，否则就是"资源在包里但读不到"这类问题的温床。
2. `assets/modsList.txt` 是 **0 字节**，而引擎的 mod 根目录是 `/storage/emulated/0/.QJsEngine/mods`（见 `.so` 字符串）。也就是说：主游戏资源随包走，**mod 必须用户自己放到外部存储**，目录不存在时行为由 `backend/Mods.hx` 决定——这正是 issue 里作者回复"你只需要创建 mods 文件夹就行了呀"的由来。

**判定**：issue 中"374MB 的 APK 没 Assets"不成立；"游戏跑不起来/进场崩溃"若存在，更可能来自 mod 目录缺失或 `assets/assets` 路径适配，而非资源缺失。具体崩溃点需动态验证，本报告不下结论。

---

## 4. 源码血缘：与上游 0.7.3 的差集

方法：从 `.so` 中提取全部 `.hx` 路径字符串（1,099 条，去重后含库文件），剔除 flixel/openfl/lime/haxe 等依赖，与 GitHub tag `0.7.3` 的 131 个 `.hx` 做差集。

结果：项目侧 169 个文件，**新增 75 个，上游有而此处无 37 个**。

### 4.1 被移除的（关键）

| 文件 | 说明 |
|---|---|
| `psychlua/FunkinLua.hx` | **Lua 解释器接入的主体**，删除 |
| `psychlua/CallbackHandler.hx` | Lua 回调分发，删除 |
| `psychlua/ExtraFunctions.hx` | 扩展函数注册表，删除 |
| `psychlua/ReflectionFunctions.hx` | 反射类函数，删除 |
| `psychlua/ShaderFunctions.hx` | 着色器函数，删除 |
| `psychlua/TextFunctions.hx` | 文本函数，删除 |
| `psychlua/DeprecatedFunctions.hx` | 兼容层，删除 |
| `psychlua/FlxAnimateFunctions.hx` | FlxAnimate 绑定，删除 |
| `psychlua/HScript.hx` | 原 HScript 封装（`hscript` 库本体仍在） |
| `backend/Discord.hx` | 移动端无 Discord，合理删除 |
| `import.hx` | 全局 import 文件消失，说明源码结构被改过 |

### 4.2 新增的（75 个，摘录）

- 脚本层：`backend/QuickJS.hx`、`psychlua/FunkinJS.hx`、`backend/ScriptContext.hx`、`backend/MenuScriptHost.hx`
- 渲染层：`backend/VulkanAndroid.hx`、`backend/RenderBackend.hx`、`render/ModRender.hx`、`render/ModShader.hx`、`shaders/ErrorHandledShader.hx`、`substates/VulkanWarningSubState.hx`
- 移动端：`mobile/` 下 14 个（MobileControls、VirtualPad、PianoKeys、MobileTextKeyboard 等）
- 后端杂项：`backend/CrashLog.hx`、`NativeCrashHandler.hx`、`HitchLog.hx`、`LoadTrace.hx`、`FpsPanelApi.hx`、`ScoreRank.hx`、`NoteLanes.hx`、`Physics.hx`、`Language.hx`、`MenuUI.hx`、`MenuNav.hx`、`MenuGestures.hx`、`ApiDocs.hx`

### 4.3 原版痕迹

以下字符串原样存在于 `.so`，是 Psych 源码的直接指纹：

```
substates.GameOverSubstate.endBullshit
states.editors.WeekEditorState.reloadAllShit
grpMenuShit / optionShit / credTextShit / resetShit
objects.NoteSplash / states.stages.objects.TankmenBG
```

`Psych Engine by` / `Psych Engine Team` 的 credits 字符串也还在。

**结论**：这是 0.7.3 的二次开发分支，主体结构沿用，脚本层被替换，渲染层被旁挂。

---

## 5. 脚本层：名字是 Lua 的，引擎是 JS 的

### 5.1 Lua 确实被拔了

```
^lua_[a-z]      0 条
^luaL_[a-z]     0 条
LuaJIT          0 条
lua_newstate    0 条
lua_pcall       0 条
```

`.so` 中不存在任何 Lua C API 符号，也没有 LuaJIT。**Lua 运行时被物理移除**，不是"隐藏开关"或"保留但禁用"。

### 5.2 但 API 名全留着

从上游 `source/psychlua/*.hx` 提取 `add_callback(lua, "name", ...)` / `.set("name", ...)` 注册的函数名，共 **215 个**；在本 APK 的 `.so` 中按原名存在 **211 个（98%）**。缺的 4 个是：

```
getHits / getMisses / getGlobalFromScript / setGlobalFromScript
```

与此同时，`psychlua.FunkinJS` 类暴露 124 个方法，其中注册器按域切分：

```
registerCoreFunctions      registerGameFunctions     registerGameFunctions2
registerInputFunctions     registerMenuFunctions     registerFileFunctions
registerBackendFunctions    registerAnimateFunctions
```

还保留了 `psychlua.FunkinJS.initLuaShader` 这种名字里带 Lua 的方法。

**结论**：所谓"对 Lua 的兼容"，是**函数名兼容**，不是脚本兼容。`.lua` 文件无法直接运行（没有解释器），但把 `makeLuaSprite(...)` 改写成 JS 语法后可以调用同名实现。这也解释了为什么社区反弹最大——老 mod 一行都跑不了，学习成本却不降。

### 5.3 QuickJS 集成是真的

`backend/QuickJS.hx`，方法名完整保留：

```
new / eval / call / hasFunction / setGlobal / getGlobal
runPendingJobs / handleNative / onDispatch / boot
encodeResult / encodeArgs / parseResult / close
```

底层调用 `JS_NewRuntime2`、`JS_Eval`、`JS_Call`、`JS_CallConstructor`、`JS_EvalFunction`。QuickJS 版本串：

```
QuickJS memory usage -- 2026-06-04 version, %d-bit, malloc limit: %ld
```

错误路径也有处理：`QuickJS: cannot create JavaScript runtime`。

---

## 6. Vulkan：真调了 API，但是旁挂的

### 6.1 实现深度

`libApplicationMain.so` 中出现 **65 个不同的 `vk*` 函数**，覆盖 instance/device 创建、swapchain、render pass、pipeline、descriptor、command buffer、image 上传、present 全链路：

```
vkCreateInstance / vkCreateDevice / vkCreateAndroidSurfaceKHR
vkCreateSwapchainKHR / vkAcquireNextImageKHR / vkQueuePresentKHR
vkCreateRenderPass / vkCreateGraphicsPipelines / vkCmdDraw
vkCmdCopyBufferToImage / vkUpdateDescriptorSets / vkQueueSubmit
```

但这套实现有明显边界：

- **没有深度附件、没有 MSAA、没有多 render pass**，`vkCmdBeginRenderPass` 只有一对
- 贴图槽**硬上限 47**，日志原文：
  `[VulkanAndroid] texture slots are full (47), further sprites will not be drawn`
- 引擎自己的说明文案：
  `Applied on the next start. OpenGL keeps running underneath until the Vulkan path fully replaces it, so switch back if anything looks wrong.`
  → Vulkan 是**覆盖层**，OpenGL 仍在跑，尚未替换渲染后端
- 切换前有独立警告页 `substates/VulkanWarningSubState`，文案 `The Vulkan renderer is still experimental.` / `Switch to Vulkan anyway?`

### 6.2 Java 侧的 "VulkanSurfaceHelper" 其实是 Canvas 文字层

该类 6,249 行 smali、57 个方法，但**不含任何 OpenGL/EGL/Vulkan API 调用**（`android/opengl`、`javax/microedition/khronos`、`libvulkan` 命中数均为 0）。它的实际工作是：

```
Canvas.drawText ×4        Paint.setTextSize / setColor / setShadowLayer
Typeface.DEFAULT_BOLD     Bitmap.createBitmap / setPixel / getPixels / recycle
```

即：管理一个 `SurfaceView`，把游戏 Surface 交给 native，同时用 Canvas 画 HUD 文字与诊断信息。native 侧通过 `nativePushTextQuad`、`nativeSetHudValues`、`nativeGetHudLine` 与之通信。

**判定**：issue 中"Vulkan 后端完整度不达 3%"是夸张修辞；实际是一个**可运行的最小 2D Vulkan 渲染器 + OpenGL 兜底**，能画场景、角色、音符、HUD，但受 47 贴图槽与单 pass 限制，离"替换渲染后端"还有距离。它是作者自己实现的部分，与 lime 的 Vulkan 代码无直接证据关联（`liblime.so` 另有一套 `vkCreateAndroidSurfaceKHR` 相关串，属于 lime 自身）。

---

## 7. 完整性校验：闭源之外还有防改

`DingLing/pe/QuickJs/Engine/Qz7`（18.5KB smali）做了三件事：

1. `b()/c()/d()` —— 取 `PackageInfo`、读签名（`GET_SIGNATURES`）
2. 遍历 ZIP 条目（`classes*.dex`、`assets/`、`lib/`、`res/`、`META-INF/`、`AndroidManifest.xml`、`resources.arsc`，白名单含 `DebugProbesKt.bin`），用 **SHA-256** 逐项摘要，与内嵌的 32 字节表比对（`v()[B`、`a(I)I` 按下标取 4 字节大端）
3. `okRoot(String)` / `okSo(String)` —— 检查 root 痕迹与 `libApplicationMain.so`、`liblime.so`、`libvlc.so`、`libc++_shared.so` 是否存在

对应 Haxe 侧 `backend/Qz7r.hx`（字段 `k/_f/_v/_w/_c/_m/_z`，方法 `boot`，属性 `scriptsAllowed`）。失败文案：

```
This copy of the game was modified or re-signed.
```

**含义**：改包名、去 dex、换 so、重签名都会命中；命中后 `scriptsAllowed` 为 false，脚本功能被关。对一个"闭源发布"的项目来说，这是把"不开源"落到执行层的手段。注意当前包 `debuggable=true` 且是 debug 签名，说明该 APK 本身是测试构建，不是 `r-` 正式版。

---

## 8. 协议合规性

### 8.1 事实

| 项 | 状态 |
|---|---|
| 上游 Psych Engine | Apache License 2.0（GitHub API `license.spdx_id = Apache-2.0`） |
| 本项目仓库 | `license: null`，README 明示"我不想走老一辈的老路" |
| APK 内许可文件 | 全量检索 `license|notice|copying`，仅 `assets/assets/fonts/NotoSansSC-LICENSE.txt` |
| 归属声明 | `Psych Engine by` / `Psych Engine Team` 字符串保留在 `.so`，但无版权声明文本、无许可证副本、无 NOTICE |
| 第三方 | `libvlc.so`（VLC，LGPL-2.1+）静态随包分发，无许可证与源码获取方式说明 |

### 8.2 Apache-2.0 的具体义务

Apache-2.0 **允许**闭源分发衍生作品，所以"闭源"本身不违约。争议点在第 4 条：

- **§4(a)**：向接收者提供本许可证副本 —— 未提供
- **§4(b)**：修改过的文件须保留显著修改声明 —— 无
- **§4(c)**：保留作品中原有的所有版权、专利、商标、归属声明 —— 源码层面的版权头随 Haxe 编译消失，二进制中仅剩非正式 credits 字符串
- **§4(d)**：若原作品含 NOTICE 文件，衍生分发须在显著位置附带其内容 —— Psych 仓库含 NOTICE 相关内容时同样未附带

因此准确的表述是：**闭源合法，但不带许可证副本与归属声明分发不合法**。这一点举证成本低、不易反驳，比"抄代码"之类的指控稳。

`libvlc` 的 LGPL-2.1 另有要求：动态链接、允许替换库、提供许可证与源码获取途径。当前 APK 将 `libvlc.so` 作为独立 `.so` 打包（非静态链接进 `libApplicationMain.so`），理论上可通过替换 so 满足重链接要求，但许可证文本与书面声明仍然缺失。

---

## 9. 与社区批评的逐条核对

| 批评（issue #2/#6） | 是否成立 | 依据 |
|---|---|---|
| 删掉 Lua 却"兼容" Lua | **成立** | Lua 运行时符号为 0；215 个 API 名保留 211 个 |
| 引擎实际是 Psych 换皮 | **成立** | 原版命名 `endBullshit` 等、credits 字符串、文件树重合 |
| Vulkan 完整度极低 | **部分成立** | 65 个 vk 函数、47 贴图槽上限、OpenGL 兜底、自称 experimental |
| APK 里没有 Assets，要自己放 | **不成立** | `assets/assets/` 310MB / 856 文件齐全；需要自建的是 `mods/` |
| 锁 720P 分辨率 | **未验证** | 本次未做动态测试，不置评 |
| 按钮贴图是远古版本 | **未验证** | 属素材层面，与逆向证据无关 |
| 作者回复态度恶劣 | **成立（有记录）** | issue #2 回复"用不惯就用别的引擎去 别搁这瞎逼逼" |
| 作者回复疑似 AI 生成 | **有间接证据** | issue #6 回复结尾附带 `chat.deepseek.com/share/...` 链接 |

---

## 10. 附录

### 产物位置

```
D:/FNF/job/_re/
├── tools/            jadx 1.5.1 / apktool 2.11.1 / JDK17 / scan.py
├── raw/              7 个 dex + 二进制清单 + resources.arsc
├── full/             完整解包（含 assets 310MB）
├── apktool_out/      清单与资源（-s 模式）
├── apktool_full/     smali 反汇编（303 个类）
├── native/           arm64-v8a 四个 so
├── upstream/         上游 psychlua/*.hx（0.7.3）
├── hx_paths.json     .so 内提取的 1099 条 .hx 路径
├── added_files.json  新增 75 个源文件
├── lua_present.txt   211 个按原名保留的 Lua API
└── lua_missing.txt   缺失的 4 个
```

### 复现要点

- `unzip` 的 `*` 通配符**不跨目录层级**，提取 `assets/*` 只会得到根目录两个文件；须整包解或逐个前缀匹配。这是本报告初版误判的直接原因。
- jadx 在本机不可用（Java 26/17 均在加载类后异常退出），apktool 的 smali 输出是可靠替代。
- 判断"Haxe 编译产物里某类是否存在"，看 `.so` 中的 `.hx` 路径与符号串即可，Haxe 不剥离这些信息。
