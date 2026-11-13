# PE-QuickJs-Engine 逆向取证报告

对象仓库：<https://github.com/rongtang2026/PE-QuickJs-Engine>
取证时间：2026-11-07

方法：静态分析。把分发版本的 APK 全量解包，与上游 Psych Engine 0.7.3、1.0 和社区反编译源码做文件和内容比对。没有安装运行，没有做动态调试。

本文是跨版本的综合取证，覆盖 r-1.0.0 与 1.1。仓库里另有三份按版本拆开的报告（`1.0/`、`r-1.0.0/`、`1.1/`）、功能矩阵（`COMPARE.md`）、时间线（`TIMELINE.md`）、宣传文案对照（`PRESS.md`）、Java 层还原（`JAVA-LAYER.md`）和源码结构还原（`RECON.md`）。10-26 那版的分析见 `1.0/report.md`。

---

## 0. 结论

| # | 结论 | 置信度 | 主要依据 |
|---|---|---|---|
| 1 | 代码基底是 Psych Engine 1.0，不是 README 写的 0.7.3 | 确定 | `.so` 里 197 条自有源文件路径，与 1.0 交集 130/154，与 0.7.3 只有 96/129；只在 1.0 里有的 34 个文件全在，只在 0.7.3 里有的 0 个 |
| 2 | 素材同样取自 1.0 | 确定 | 873 个资产里 840 个与 1.0 逐字节相同（96.2%），与 0.7.3 只对上 479 个；`weekend1/`、拆分人声、`zh-CN.lang` 都是 1.0 的约定 |
| 3 | 不是重写，是换包名后改造 | 确定 | 删 24 个 1.0 文件、加 67 个；dex 里 `com/shadowmario/psychengine` 的 10 个类原样留着 |
| 4 | Lua 运行时被整块摘掉，只留函数名 | 确定 | `lua_*`、`luaL_*`、LuaJIT 符号都是 0；上游 psychlua 的 452 个函数名留下 437 个（96.7%） |
| 5 | QuickJS 是真的接进去了 | 确定 | `JS_NewRuntime`、`JS_NewContext`、`JS_Eval` 都在，QuickJS 版本串也在 |
| 6 | Vulkan 是旁挂层，主力仍是 OpenGL | 高 | 包里有 `[VulkanAndroid] texture slots are full (47)`；OpenGL 的字符串出现量约为 Vulkan 的 19 倍；作者的 NOTICE 也写了 "OpenGL remains the base renderer" |
| 7 | 包内有完整性校验，改包就关脚本 | 确定 | `DingLing/pe/QuickJs/Engine/Qz7`，`.so` 里有 `This copy of the game was modified or re-signed.` |
| 8 | r-1.0.0 里没有任何 LICENSE 或 NOTICE，违反 Apache-2.0 §4(a) | 确定 | 871 个资产全表检索，协议文件 0 个 |
| 9 | 1.1 补了 LICENSE 和 NOTICE，但是发布之后换了包 | 高 | 1.1 发布于 11-04 23:26，当前资产创建于 11-06 03:55；社区报告分析的是 versionCode 476，现在下载到的是 484 |
| 10 | 仓库没有源码，7 次提交都在改 README | 确定 | GitHub API 提交列表 |

合起来看：把 Psych Engine 1.0 的源码和素材整体搬过来，摘掉 Lua 换成 QuickJS，加一层 Vulkan 旁挂和一批移动端功能，重新编译。对外说基于 0.7.3。第一版分发时没带许可证副本。

---

## 1. 取证对象与材料

### 1.1 分发版本

作者一共发过三个包。上游仓库现在只剩两个 release 可下，10-26 那版已被删除，本仓库 `1.0/` 保留了对它的分析。

| | 1.0（10-26，已删除） | r-1.0.0 | 1.1（debug-test） |
|---|---|---|---|
| 资产文件 | `PsychEngine-debug.apk` | `PEQuickJsEngine-release.apk` | `PEQuickJsEngine-debug-test.apk` |
| 发布 / 资产创建 | 10-26 | 11-01 05:03 / 11-01 05:01 | 11-04 23:26 / 11-06 03:55 |
| 大小 | 401,134,643 字节 | 394,278,505 字节（376.0 MB） | 400,763,276 字节（382.2 MB） |
| SHA-256 | `f3330da8eef04df363199ededc982fcf4bd7d03a7a124f84f30fcb0f8bd8460d` | `6923bfd2473072119c14eb2642ecbfa96ac122c0c220cc7db3199f881daff12e` | `18c7a99b9563540d21bf5cb2e23f8f8b14982399cd79efc5937a9d1d2da42de5` |
| versionName / Code | 0.2.8 | 1.0.0 / 447 | 1.1.0 / 484 |
| package | `com.shadowmario.psychengine` | `DingLing.pe.QuickJs.Engine` | 同 |
| dex | 6 个 | 1 个，315.5 KB，303 个类 | 7 个，合计同样 303 个类 |
| assets | — | 871 个 / 308.2 MB | 873 个 / 308.3 MB |
| LICENSE / NOTICE | 无 | 无 | `assets/LICENSE`（11.1 KB）、`assets/NOTICE`（2.5 KB） |

10-26 那一列取自本仓库 `1.0/report.md`，其余数字来自对 r-1.0.0 与 1.1 两个包的实测。

两包签名一致：v1 自签名，没有 v2/v3 签名块。证书 `C=CN, O=DingLing, OU=PE-QuickJs-Engine, CN=DingLing`，有效期 2026-10-31 到 2054-03-18，SHA-256 `cffb9817…566516f02`。同一张证书，可以确认出自同一人。

权限两版相同，8 个：`INTERNET`、`ACCESS_NETWORK_STATE`、`MANAGE_EXTERNAL_STORAGE`、`READ_PHONE_STATE`、`READ/WRITE_EXTERNAL_STORAGE`、`VIBRATE`、`WAKE_LOCK`。单机音游要全盘读写和读取手机状态，是为了在 `/storage/emulated/0/.QJsEngine/` 放 mods。能解释，但权限面比需要的大。

### 1.2 上游基准

| 基准 | 版本 | 提交 | 用途 |
|---|---|---|---|
| ShadowMario/FNF-PsychEngine | tag `0.7.3` | `2dfa277`（2024-01-15） | 作者声称的基底 |
| ShadowMario/FNF-PsychEngine | tag `1.0` | `7addb9c`（2024-10-14） | 实际基底 |
| Lv233-Haxe/Open-QuickJs-Engine | main | 社区反编译还原的源码（Apache-2.0） | 交叉校验 |

上游许可为 Apache-2.0，仓库里只有 `LICENSE`，没有 NOTICE 文件。这一点决定了 Apache-2.0 §4(d) 是否触发，见第 8 节。

### 1.3 方法

文件级。Haxe/hxcpp 的产物会把 `xxx.hx` 源文件路径写进二进制。从 `libApplicationMain.so` 抽字符串，筛出 1100 条 `.hx` 路径，剔掉 flixel、openfl、lime 和各 haxelib 之后剩 197 条自有路径，与上游 `source/` 做集合运算。

类级。直接解析 `classes*.dex`（自己写的 dex 解析器，没用 jadx），另外统计 `.so` 里 `包.类` 形式的字符串，与上游 `.hx` 推出的类名做覆盖比对。

资产级。上游素材一个字节都没下载。取上游 git 树里每个 blob 的 SHA-1，再用 `blob <len>\0` 加内容的算法算 APK 内文件的 git blob 哈希做等值判断。所以“840 个逐字节相同”是等值判定，不是相似度。

局限有三条。没有动态运行验证。`.hx` 路径依赖编译期调试信息，死代码可能被漏掉，因此另外用类名和资产两条线交叉验证，三条线结论一致。Vulkan 的 C++ 内部实现没有反编译。

---

## 2. 版本 A：r-1.0.0

### 2.1 结构

```
PEQuickJsEngine-release.apk  376 MB / 893 条目
├── classes.dex              315.5 KB   303 个类
├── lib/
│   ├── arm64-v8a/  libApplicationMain.so 46.7 MB   libvlc.so 41.2 MB
│   │               liblime.so 10.1 MB             libc++_shared.so 0.5 MB
│   └── armeabi-v7a/ 同四件（略小）
├── assets/                  308.2 MB / 871 文件
│   └── assets/             ← 多一层嵌套，打包配置写错了（rename="assets" 又套了源目录名）
│       ├── shared/  88 MB      songs/ 151 MB     videos/ 27 MB
│       ├── week1…week7, weekend1  ~40 MB
│       └── fonts/ 8.1 MB
├── res/                     资源名是混淆过的（4d.png / B-.png / Ul.png）
└── META-INF/                CERT.SF / CERT.RSA，v1 签名，文件名还是 lime 默认的
```

体积构成：引擎本体加 Haxe 代码 46.7 MB，VLC 41.2 MB，素材 308 MB。libvlc 占了 11%，用于播放 `.mp4` 过场。

### 2.2 dex 层

303 个类里，`com/google/gson/*` 217 个，`org/libsdl/app/*` 46 个，`org/haxe/lime/*` 5 个，`DingLing/pe/QuickJs/Engine/*` 14 个，另有 `com/shadowmario/psychengine/*` 10 个。

这 10 个是上个包名留下的编译残留。`MainActivity`、`MemoryInfoHelper`、`VulkanSurfaceHelper`（含 7 个内部类）在新旧两个包名下各有一套，内容相同。改包名之后没有 clean 就直接打包了。这不影响运行，但说明构建流程是改个名字重新编，不是新起工程。

### 2.3 协议文件

对 871 个资产做全表检索（`license|licence|copying|notice|attribut|credit|authors|copyright`），命中的只有三类：`NotoSansSC-LICENSE.txt`（字体自带的 OFL）、上游的若干 `readme.txt`、`menu_credits.png/.xml`（素材图，不是文本声明）。

没有 Apache-2.0 许可证副本，没有 NOTICE，没有版权声明文本。仓库侧同样没有 LICENSE 文件，GitHub API 返回 `license = null`。

---

## 3. 版本 B：1.1（debug-test）

### 3.1 与 r-1.0.0 的差异

| 项 | r-1.0.0 → 1.1 |
|---|---|
| 版本号 | 447 → 484 |
| dex 分包 | 1 个 → 7 个，类集合完全一致，只是拆了 multidex |
| `libApplicationMain.so` | arm64 47.8 → 48.4 MB（+567 KB）；v7a 45.9 → 46.5 MB |
| 新增源文件 | `backend/MathX.hx`、`backend/Physics.hx`、`backend/SecStr.hx` |
| 新增资产 | `assets/LICENSE`、`assets/NOTICE` |
| 资源命名 | 从混淆名（`4d.png`）恢复成 `drawable-*dpi/icon.png` |
| 签名文件 | `CERT.SF/RSA` 改成 `PEQJS.SF/RSA`，证书没变 |
| 权限、包名、原生库清单 | 无变化 |

1.1 相对 1.0.0 的功能增量就是 3 个源文件，其余是打包配置修正和补协议文件。

### 3.2 补的 LICENSE 和 NOTICE

`assets/LICENSE` 是 Apache-2.0 全文，标准文本。

`assets/NOTICE` 是作者自己写的，2.5 KB，内容比较全：声明本项目是 Psych Engine 的非官方修改版，点了 `Copyright (c) Shadow Mario, Riveren and contributors` 和仓库地址；点了 FNF 本体 `Copyright (c) ninjamuffin99 and contributors`；列了修改点，包括 QuickJS 替换 Lua、移动端触控、Vulkan 实验渲染、物理与数学绑定、自定义评分与 FC 徽章、视频与菜单脚本 API、崩溃日志与完整性校验；第三方列了 QuickJS（Bellard/Gordon，MIT）、Chipmunk2D、cglm、stb_perlin、libVLC（LGPL-2.1+，附源码地址）、Haxe/hxcpp、Lime/OpenFL、HaxeFlixel。

这份 NOTICE 本身写得比多数 fork 规范，措辞也没有 README 里那些情绪。问题不在文本质量，在时间线和生效范围，见 3.3 和第 8 节。

### 3.3 包是发布之后换掉的

把三条时间线摆在一起：

| 时间（UTC） | 事件 |
|---|---|
| 11-01 05:01 | r-1.0.0 资产创建，无协议文件 |
| 11-04 23:26 | release 1.1 发布 |
| 11-05 08:05 | issue #7 发报告，分析对象 400,750,869 字节、versionCode 476、`debuggable=true`、包内无 LICENSE |
| 11-06 03:55 | 当前 1.1 资产文件的创建时间：400,763,276 字节、versionCode 484、无 debuggable、含 LICENSE 和 NOTICE |
| 11-06 04:05 | README 提交 `Update README.md`，新增 "License compliance … since v1.1.0" |

同名资产删掉重传之后 `created_at` 会刷新。现有资产的时间戳（11-06 03:55）晚于 release 发布时间（11-04 23:26），说明现在下载到的 1.1 不是 11-04 发布的那份。README 里“自 v1.1.0 起已包含 LICENSE 和 NOTICE”对 11-04 那版不成立。

11-04 的原文件已被删除，拿不到哈希做直接比对，所以这条标“高”而不是“确定”。可验证的硬事实是：r-1.0.0 至今零协议文件，而它才是带 `r-` 前缀的正式版。仓库里 `evidence/metrics/1.1.json` 与 `1.1-reupload.json` 记录了前后两份的清单。

---

## 4. 血统判定

三条独立证据线，结论一致。

### 4.1 文件级

从 `.so` 抽出的 197 条自有 `.hx` 路径，与两个 tag 比对：

| 基准 | 上游文件数 | 交集 | 覆盖率 |
|---|---|---|---|
| Psych 0.7.3 | 129 | 96 | 74.4% |
| Psych 1.0 | 154 | 130 | 84.4% |

覆盖率差距不算决定性，因为 0.7.3 本身就是 1.0 的子集，天然会被覆盖。决定性的是不对称：

- 只在 1.0 里有的文件 34 个，APK 全有。包括 `backend/Language.hx`、`options/LanguageSubState.hx`、`options/VisualsSettingsSubState.hx`、`options/NotesColorSubState.hx`、`states/ErrorState.hx`、`states/stages/PhillyStreets.hx`、`states/stages/PhillyBlazin.hx`、`objects/VideoSprite.hx`，以及 `states/editors/content/*` 8 个。
- 只在 0.7.3 里有的文件，APK 里 0 个。

从 0.7.3 出发手改，不可能把 1.0 才有的 34 个文件全部写出来，同时把 0.7.3 独有的文件一个不留地删干净。

### 4.2 类级

用 `.so` 里 277 个引擎自有类名比对：

| 基准 | 上游类数 | 命中 | 覆盖率 |
|---|---|---|---|
| Psych 0.7.3 | 117 | 96 | 82.1% |
| Psych 1.0 | 145 | 131 | 90.3% |
| 社区反编译源码 | 183 | 169 | 92.3% |

0.7.3 独有、1.0 已移除的 7 个类，即 `backend.Section`、`options.NotesSubState`、`options.VisualsUISubState`、`states.editors.EditorPlayState`、`states.editors.NoteSplashDebugState`、`substates.GameplayChangersSubstate`、`substates.Prompt`，在 APK 里 0 命中。全部消失，正是 1.0 的形态。

### 4.3 资产级

873 个资产按 git blob SHA-1 逐一比对：

| 基准 | 逐字节相同 |
|---|---|
| Psych 1.0 | 840（96.2%） |
| Psych 0.7.3 | 479（54.9%） |

版本特征同样指向 1.0。目录是 `weekend1/`，Weekend 1 是 1.0 新增的章节，0.7.3 用的是 `week_assets/`。人声是 `Voices-Player.ogg` 与 `Voices-Opponent.ogg` 的拆分版，属 1.0 约定，0.7.3 是单个 `Voices.ogg`。`assets/shared/data/zh-CN.lang` 和 `pt-BR.lang` 走 1.0 的 i18n 体系。

README 第一段写的 "based on the original Psych Engine 0.7.3" 与产物不符。这是事实层面的错误陈述，和许可义务是两件事，但影响可信度。

---

## 5. 代码层改动

### 5.1 从 1.0 删掉的 24 个文件

| 文件 | 说明 |
|---|---|
| `psychlua/FunkinLua.hx` | Lua 接入主体 |
| `psychlua/CallbackHandler.hx` | Lua 回调分发 |
| `psychlua/ExtraFunctions.hx`、`ReflectionFunctions.hx`、`TextFunctions.hx`、`ShaderFunctions.hx`、`DeprecatedFunctions.hx`、`FlxAnimateFunctions.hx` | 各类 API 注册表 |
| `psychlua/HScript.hx` | HScript 封装 |
| `flxanimate/PsychFlxAnimate.hx` | FlxAnimate 集成 |
| `backend/Discord.hx` | 移动端不需要 |
| `shaders/BlendModeEffect.hx`、`OverlayShader.hx`、`WiggleEffect.hx` | 三个着色器效果 |
| `states/OutdatedState.hx` | 版本过旧提示页，移动端无更新检查 |
| `states/stages/Template.hx` | 舞台模板 |
| `import.hx` 和 `unused/*` 7 个 | 全局导入与废弃代码 |

这 24 个删除项里有 9 个与脚本运行时直接相关。不是砍功能，是整块换掉脚本引擎的必然结果。

### 5.2 新增的 67 个文件

其中 7 个属于 haxelib `funkin.vis`（音频频谱库），3 个是 hxcpp 自动生成（`ApplicationMain.hx` 等），真正自写约 57 个。

- 脚本层 3 个：`psychlua/FunkinJS.hx`、`psychlua/MenuScripts.hx`、`psychlua/ScriptVars.hx`
- JS 运行时 2 个：`backend/QuickJS.hx`、`backend/ScriptContext.hx`
- 渲染 5 个：`backend/VulkanAndroid.hx`、`backend/RenderBackend.hx`、`render/ModRender.hx`、`render/ModShader.hx`、`shaders/ErrorHandledShader.hx`
- 移动端 15 个：`mobile/` 下 14 个（VirtualPad、PianoKeys、MobileKeyPad、MobileTextKeyboard、Hitbox、TouchButton 等）加 `options/MobileSettingsSubState.hx`
- Android 桥 4 个：`android/Permissions.hx`、`android/Settings.hx`、`android/content/Context.hx`、`android/os/Build.hx`
- 后端杂项 25 个：`ApiDocs`、`ApiDocsData`、`CrashLog`、`NativeCrashHandler`、`HitchLog`、`LoadTrace`、`FpsPanelApi`、`ScoreRank`、`NoteLanes`、`FCBadge`、`Physics`、`MathX`、`SecStr`、`Qz7r`、`MenuUI`、`MenuNav`、`MenuGestures`、`MenuScriptHost`、`InputCompat`、`SongList`、`VideoAudio`、`debug/ProcessMemory` 等
- 界面与状态 4 个：`states/CustomMenuState.hx`、`states/SecurityNoticeState.hx`、`substates/VulkanWarningSubState.hx`，以及 `backend/ui/*` 的改名版本

这部分有真东西。`ApiDocs` 加 `ApiDocsData` 说明他确实整理了自定义 API 文档，`Physics` 和 `MathX` 接了原生库，移动端控制是一整套。作者自称“盲目做自定义 API”，在这点上不算吹。

### 5.3 脚本层

运行时符号检索结果：`^lua_` 0 条，`^luaL_` 0 条，`LuaJIT` 0 条。原始字符串转储见 `evidence/native/strings-lua.txt`。

但 API 名字还在。从上游 `psychlua/*.hx` 提取的 452 个函数名标识符，在 `.so` 里原名出现 437 个，占 96.7%。缺的 15 个恰好是 HScript 与平台相关的：`runHaxeCode`、`runHaxeFunction`、`addHaxeLibrary`、`createCallback`、`createGlobalCallback`、`removeVar`、`parentLua`、`linux`、`windows_x86`、`browser` 等。

这里的口径和分版报告不同：`1.0/`、`r-1.0.0/`、`1.1/` 用的是 `add_callback` 与 `set` 注册名口径（219 个，219/219），本文用的是 psychlua 全量字符串标识符口径（452 个，437 个）。范围不同，结论一致：函数名保留，运行时不在。

准确的表述是：函数名层面兼容，脚本不兼容。原来调用 `makeLuaSprite(...)` 的 `.lua` 文件一行都跑不了，得手工改写成 JS 语法去调同名函数。APK 的 `assets/` 里有 `shared/scripts/demo.js` 和 `menu_demo.js` 两个 JS 示例，有空的 `modsList.txt`，有上游的 `do NOT readme.txt`，只有示例，没有迁移工具。

对社区的实际后果就是 issue #13 说的那句：不兼容原版 PE 的 mod，这个引擎的存量内容为零。

### 5.4 QuickJS

`backend/QuickJS.hx` 对应的底层符号齐全：`JS_NewRuntime`、`JS_NewContext`、`JS_Eval`、`JS_Call`。版本串是 `QuickJS memory usage -- 2026-06-04 version`，属 QuickJS 的 fork 构建日期。

用“套壳”形容 QuickJS 不准确，JS 运行时是真接进去了。假的是“兼容 Lua 脚本”这个暗示。

### 5.5 Vulkan

渲染路径仍是 OpenGL。字符串统计里 `OpenGL` 出现 2183 次，`Vulkan` 113 次。

硬边界写在包里的文案上：`[VulkanAndroid] texture slots are full (47), further sprites will not be drawn`，贴图槽上限 47，超了直接不画。作者在 NOTICE 里写的是 "an experimental Vulkan rendering overlay (OpenGL remains the base renderer)"，切换前还弹 `VulkanWarningSubState`。

社区报告 #7 补充了三条：单 render pass、无深度和 MSAA、投影矩阵按 1280×720 硬编码。最后这条我没复现，只作社区结论引用；`findings/vulkan-surface-helper.txt` 记录的是 Java 侧 SurfaceView 的行为。

“给低端机加 Vulkan 优化”这个卖点，对着 47 个贴图槽和固定 1280×720 投影，很难自圆其说。但它确实是个能跑起来的实验性后端，不是纯装饰。

### 5.6 完整性校验

dex 里有 `DingLing/pe/QuickJs/Engine/Qz7`，`.so` 里有文案 `This copy of the game was modified or re-signed.`，`findings/qz7-integrity-check.txt` 有逐条摘要比对的记录。

社区报告 #7 的逆向结果是：遍历 ZIP 条目（dex、assets、lib、res、META-INF、manifest、arsc）逐项算 SHA-256，与内嵌的 32 字节表比对；另查 root 痕迹；失败则关闭脚本功能。

闭源加防篡改本身不违法，Apache-2.0 允许。但把它和禁止改包绑在一起，和 Apache-2.0 授予的修改权冲突。可以在自己发的包里校验自己，不能用技术手段限制接收者依许可享有的权利。

---

## 6. 改造深度

| 维度 | 判断 |
|---|---|
| 架构 | 未重写。`states/`、`objects/`、`backend/`、`psychlua/` 的目录结构、类名、调用关系沿用 1.0 |
| 改造量 | 以 1.0 的 154 个文件计：保留 130（84.4%）、删除 24（15.6%）、新增 57（相当于原文件的 37%）。新增基本都是旁挂模块，主干（PlayState、Character、Note、Conductor、StrumNote）原样保留 |
| 原版痕迹 | `.so` 里仍有 `Psych Engine by`、`Psych Engine Team`、`Psych Engine Discord`，以及 `https://raw.githubusercontent.com/ShadowMario/FNF-PsychEngine/main/gitVersion.txt` |
| 结论 | 基于 Psych Engine 1.0 的深度魔改分支。README 的 "pure mobile reconstruction" 属于夸大 |

---

## 7. README 宣称核对

| README 原文 | 判定 | 依据 |
|---|---|---|
| "heavily modified, pure mobile reconstruction based on the original Psych Engine 0.7.3" | 不实，版本错了 | 文件 34/0 不对称、类覆盖 90.3% 对 82.1%、资产 840 对 479 |
| "highly optimized mobile engine" | 无法证实 | 没有任何基准数据；唯一的性能证据是“社区成员 Sky 说不太卡” |
| "QuickJS, OpenGL shaders, and custom APIs" | 基本成立 | QuickJS 真实集成；shader 有 5 个新增文件；自定义 API 有 ApiDocs 等 57 个新文件 |
| "I have the utmost respect for the original authors" | 与行为不符 | 首版分发零协议文件；issue #2 回复“用不惯就用别的引擎去 别搁这瞎逼逼” |
| "this project is 100% built with AI" | 作者自述，与其他证据吻合 | 仓库 7 次提交全在改 README，无一行源码 |
| "License compliance (LICENSE & NOTICE) has been included in the APK since v1.1.0" | 时间线不成立 | 11-04 发布的 1.1 被社区抓到无 LICENSE；现资产在 11-06 03:55 重建后才带 |
| "The source code is private and closed-source" | 合法但不完整 | Apache-2.0 允许闭源，但 §4 的四项义务没有全部履行，见第 8 节 |
| "If you don't like it, don't use it" | 与许可无关 | Apache-2.0 的授权不以“喜不喜欢”为条件 |

---

## 8. 协议合规核对（Apache-2.0 §4）

前提写清楚：Apache-2.0 允许闭源分发衍生作品，也允许收费、改名、不公开源码。违反的不是闭源，是 §4 的随附义务。

| 条款 | 要求 | r-1.0.0 | 1.1（当前资产） |
|---|---|---|---|
| §4(a) | 向接收者提供许可证副本 | 违反，无 LICENSE | 满足，`assets/LICENSE` 是全文 |
| §4(b) | 修改过的文件须带显著修改声明 | 违反，无任何声明 | 部分满足，NOTICE 列了修改点，但没有按文件标注 |
| §4(c) | 保留原作品的版权、专利、商标、归属声明 | 违反，无版权文本，只剩二进制里的 `Psych Engine by` 字样 | 部分满足，NOTICE 补了 Shadow Mario、Riveren、ninjamuffin99 的署名 |
| §4(d) | 原作品含 NOTICE 时须附带 | 不适用 | 不适用，上游 Psych 仓库没有 NOTICE 文件 |
| 仓库层面 | — | `license = null`，至今无 LICENSE | 同 |

结论分两版说。r-1.0.0 闭源合法，不带许可证副本与归属声明分发不合法。1.1 补上了 §4(a) 和 §4(c) 的主要缺口，合规性明显改善，但仍有两处瑕疵：许可证和 NOTICE 埋在 APK 的 `assets/` 里，App 内没有可达入口，credits 界面用的是上游原图，不是文本声明；随包分发的 41 MB `libvlc.so` 属 LGPL-2.1+，NOTICE 只给了官网和源码地址，没有按 LGPL 要求提供对应源码或书面要约。

无论哪一版，“声明基于 0.7.3 实为 1.0”都属于对来源的失实陈述，与许可义务无关，但影响可信度。

---

## 9. issue 交叉核对

仓库 12 个 issue，1 个已关闭，全部是批评性质。逐条看哪些能落到证据上。

| issue | 主张 | 取证结论 |
|---|---|---|
| #1（已关闭） | 无内容 | — |
| #2 | 分辨率糊、按钮贴图老旧；作者回复“用不惯就用别的引擎去”“别搁这瞎逼逼” | 态度部分有记录，评论原文在案；“糊”未复现，静态无法验证渲染分辨率 |
| #4 | 不敢开源是因为 99.99% vibe coding；删掉 `.lua`/`.hx` 后缀就算移除 Lua 和 HScript | 前半吻合，7 次提交全在改 README、无源码；后半措辞不精确，不是删后缀，是整块移除运行时但保留函数名，见 5.3 |
| #5 | 只有 Android 构建 | 成立，两个 release 均为 APK，无 Windows/macOS 构建 |
| #6 | 作者破防锁讨论；贴出 deepseek 分享链接 | 锁讨论是事实，issue 标题即系统提示；deepseek 链接未核，在评论内 |
| #7 | 完整取证报告：基底 1.0、Lua 名称保留、Vulkan 旁挂、Qz7 校验、无 LICENSE | 核心结论我独立复现，数字一致（96/129、130/154、34/0、840/873）；其分析对象是 versionCode 476，现包已换成 484 |
| #8 | “Psych 1.0 换皮加 QuickJS 套壳，219 个 Lua 函数名一个不少但运行时删干净” | 成立。我用更宽的口径得 437/452（96.7%）；“套壳”一词对 QuickJS 不准确，真集成了 |
| #9 | 从 1.0 改口成 0.7.3 是荒谬 | 事实成立，产物是 1.0，声明是 0.7.3 |
| #10 | 大文档、标题党、拿 hxcpp 内存探测当卖点 | 文档部分成立，ApiDocs 和 ApiDocsData 确实存在；标题党属社区语境，不评价 |
| #11 | LICENSE 0 份、§4(a) 违反、STATUS UNFIXED | 对 r-1.0.0 完全成立；对当前 1.1 已不成立，但修复是事后替换的 |
| #12 | 圈内第 2 个被反编译爆源码的引擎 | 陈述性，成立，Open-QuickJs-Engine 已还原 183/197 文件 |
| #13 | 把 Lua 换成 JS 导致不兼容存量 mod，引擎失去意义 | 技术事实成立，见 5.3；价值判断不评价 |

社区指控里，技术类主张基本都有据：基底版本、Lua 移除、Vulkan 完成度、许可缺失。情绪化措辞和人身攻击占了大半篇幅，但没有找到凭空捏造技术事实的条目。反过来，作者 README 里的两处关键陈述都与事实不符，一处是 0.7.3，一处是 since v1.1.0 含协议文件。

---

## 10. 社区反编译项目

| 项 | 数据 |
|---|---|
| 许可 | Apache-2.0，有 LICENSE |
| 规模 | `source/` 226 个 `.hx`，另有 `native/` 22、`docs/` 8、`not-compiled/` 4 |
| 对 APK 的还原覆盖 | 197 个自有文件中覆盖 183（92.9%） |
| 对新增文件的还原 | 真实新增 60 个（67 减 7 个 haxelib `funkin.vis`），还原 53；未覆盖的 14 个是 8 个 `funkin.vis`、3 个 hxcpp 自动生成、`backend/SecStr.hx`（1.1 才加，反编译基于 1.0.0）、`scripts/extra.hx` |
| 类名交叉验证 | 反编译源码 183 个类，在 APK `.so` 命中 169（92.3%） |
| 未覆盖部分 | `backend/SecStr.hx`（1.1 才加，反编译基于 1.0.0）、部分 flxanimate 适配 |
| 可编译性 | 未验证。README 自述“不保证所有功能可用”，需要 Haxe 4.3.7 加一批 haxelib |

这次人工反编译的还原质量相当高：92.9% 的文件覆盖、类名级零冲突、目录结构和命名保持原样，作者还主动给项目加了 Apache-2.0 许可。它反过来成了最强的一份证据。正因为有它，才能证明 APK 里那 57 个新增文件是真实存在的自写代码，而不是空壳。

---

## 11. 结论

基底版本与声明不符。产物是 Psych Engine 1.0，依据是文件 34/0 的不对称、类覆盖 90.3%、资产 840 个逐字节相同。README 写的 0.7.3 不成立，而且不是记错，因为 0.7.3 独有的文件、类、素材一个都没留下。

“纯移动端重建”的说法夸大。主干代码、素材、i18n、人声拆分全部沿用 1.0，改动集中在脚本引擎替换、渲染旁挂、移动端交互三块，共 57 个新增文件。按深度魔改分支描述更准确。

Lua 换成 QuickJS 是真换，兼容是假的。运行时符号归零，452 个 API 名留下 437 个。存量 `.lua` 模组全部失效，需要手工改写。这是本项目最实质的产品缺陷，也是社区不满的起因。

首版分发违反 Apache-2.0 §4(a)(b)(c)。r-1.0.0 零许可证副本、零署名声明，而且它至今是带 `r-` 的正式版。1.1 事后补了 LICENSE 和 NOTICE，文本质量还过得去，但补的动作发生在批评爆发之后，方式是替换 release 资产，另外还留着 LGPL libvlc 与协议文件无 UI 入口两处瑕疵。

工程能力不能一笔抹掉。QuickJS 集成、原生物理绑定、移动端控制体系、API 文档、完整性校验都是实打实的工作量，Vulkan 是实验性旁挂但不是骗局。

问题集中在诚信与许可，不在技术含量。版本来源失实、协议义务缺失、事后替换资产、对质疑者的人身攻击，这四条构成了这次争议的实质，也是这份报告能落到证据上的部分。

---

## 12. 附录

### 12.1 本仓库结构

```
README.md                    本文，跨版本综合取证
1.0/  r-1.0.0/  1.1/  r-1.1/  四个发布版各自的分版报告（report.md + report.html）
COMPARE.md                   功能矩阵、代码差集、工程配置
TIMELINE.md                  发布与改动时间线
PRESS.md                     宣传文案与实测对照
JAVA-LAYER.md                303 个 dex 类的 Java 层还原
RECON.md                     类与方法级源码结构还原
NOTICE.md                    本仓库内容的来源与许可
LICENSE-APACHE-2.0.txt       Apache-2.0 全文
findings/                    单项结论的证据摘录
    docs-mismatch.txt        文档与产物的出入
    duplicate-packages.txt   新旧包名并存的 10 个类
    qz7-integrity-check.txt  完整性校验的比对逻辑
    vulkan-surface-helper.txt  Java 侧 SurfaceView 的行为
evidence/                    原始数据
    metrics/                 每个版本的清单快照（1.0 / r-1.0.0 / 1.1 / 1.1 重传后）
    cross-version/           资产哈希表、类名差集、各版 .hx 路径集合
    native/                  原生库字符串转储（quickjs / lua / hscript / 路径 / JNI）
    data/                    与上游 1.0 的差集、Lua API 名单
    smali/                   反汇编的 dex 类
    upstream/ upstream10/    上游 0.7.3 与 1.0 的 psychlua 原文
```

本文的 840/873、130/154、96/129 等数字，可用 `evidence/cross-version/asset_hashes.json`、`hx_by_ver.json`、`class-diff.json` 复算。

### 12.2 方法说明

三个维度各用一套独立口径，互不依赖：

| 维度 | 取数 | 判等方式 |
|---|---|---|
| 源文件 | 从 `.so` 抽 `xxx.hx` 路径，剔除第三方库 | 与上游 `source/` 做集合交集 |
| 类名 | 解析 dex 类表，加 `.so` 里 `包.类` 字符串 | 与 `.hx` 推出的 `包.类` 比对 |
| 资产 | APK 内逐文件算 git blob 哈希 | 与上游 `git ls-tree` 的 blob SHA-1 比对 |

资产这一路不需要下载上游素材，省掉几百 MB 传输，且判定是等值而不是相似度。

### 12.3 未验证、留待动态分析的点

- Vulkan 路径的 1280×720 固定投影。社区报告结论，静态未复现。
- 贴图槽超过 47 后的具体视觉表现。
- Weekend1 进场崩溃的成因。
- `Qz7` 校验失败后的实际行为，是否只关脚本，有没有其它降级。
- 1.1 替换前那份 400,750,869 字节的原包（sha `2a24ebb0…`）已不在 release 上，但本仓库取证时留存了副本，`1.1/report.md` 的全部数据基于该包。

## 13. 补记：r-1.1（2026-11-12）

11-12 17:31 发布 `r-1.1`，资产名 `PEQuickJsEngine-release-encrypted.apk`，516,978,674 字节，sha `696a6041…`，versionCode 618，`debuggable` 未声明。

文件名写着 encrypted，但**没有任何内容被加密**。

| 他做的 | 实际效果 |
|---|---|
| 破坏两个 `libApplicationMain.so` 的 CRC | 894 个条目里只有这 2 个坏；Android 不校验条目 CRC，照常运行，常规解包工具直接报 `BadZipFile` |
| 把 485MB 条目改为不压缩（STORED） | 压缩后体积 382MB → 493MB，**+122MB 由此而来**，与加密无关 |
| 抹掉 1,099 条 `.hx` 源文件路径 | 新包里只剩 77 条，且全部是 `C:xxxx…hx`；按文件路径做比对的旧方法失效 |
| 类名混淆 | `backend.Hardening` → `hz57`（两条字符串并列，等于自报家门）；另有一批 `a.E`/`b.J` 单字母类 |
| `res/` 图标改随机名、dex 合并 7→1 | 标准资源混淆，无加密作用 |

**没有变的**（也是"未加密"的直接反证）：

- 219 个 Lua API 名全部明文
- `states.PlayState` 217 个方法符号、`psychlua.FunkinJS` 126 个，全部可读
- 873 个共有素材里 **872 个与上一版逐字节相同**，只有 `manifest/default.json` 变化
- `assets/LICENSE`、`assets/NOTICE` 仍在
- Java 层 122 个类与上一版一致

### 13.1 新增的运行时反调试

这一版真正的新东西是 `backend.Hardening`（混淆名 `hz57`），检测项以字符串形式写在 `.so` 里：

```
[Integrity] build check failed / build ok
[Integrity] native check / native check: clean
[Integrity] runtime check failed: rt =
[Integrity] certificate unavailable, check skipped

debugger (TracerPid)                     /proc/self/status
hooking library mapped                   /proc/self/maps
hooking thread                           /proc/self/task
code injected from /data/local/tmp
executable code mapped from /data/local/tmp
root framework (not fatal)
payload sentinel not decrypted
```

内部标志：`TRACER` `PTRACE` `MAPS` `INJECT` `ROOT` `FATAL` `THREADS` `PAYBLOB`。

与 `Qz7` 分工不同：`Qz7` 看包（签名、dex 编号、so 白名单），`Hardening` 看运行时（调试器、注入、hook、可疑线程）。`ROOT` 标为非致命。

### 13.2 判定

"加密"这个说法不成立。实际做的是**反分析**：抹路径、混淆少量类名、破坏 CRC、加运行时检测。核心可读性没有变化——API 名、引擎类名、方法名、素材全部原样。

完整分析见 [`r-1.1/report.md`](r-1.1/report.md)。

---

本报告只陈述可复现的静态事实，不含对个人的评价。结论都标了证据来源与置信度，未验证的项已单独列出。
