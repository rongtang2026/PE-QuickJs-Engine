# PE-QuickJs-Engine `r-1.0.0` 逆向取证

**发布**：2026-11-01　**资产**：`PEQuickJsEngine-release.apk`
**大小**：394,278,505 字节
**SHA-256**：`6923bfd2473072119c14eb2642ecbfa96ac122c0c220cc7db3199f881daff12e`
**上游**：ShadowMario/FNF-PsychEngine（Apache-2.0）

---

## 0. 这一版是什么

作者唯一一个带 `r-` 前缀的发布，按他自己 README 的定义，这才是"正式版"。它也是三版里**改动最剧烈**的一版：

| 对比上一版 `1.0` | 变化 |
|---|---|
| 包名 | `com.shadowmario.psychengine` → `DingLing.pe.QuickJs.Engine` |
| 版本号 | `0.2.8` → `1.0.0` |
| Lua 运行时 | **有 → 无** |
| Vulkan | **无 → 有**（65 个 `vk*` 函数） |
| 防改 `Qz7` | **无 → 有** |
| debuggable | `true` → 关闭 |
| dex | 6 个 → **1 个** |

---

## 1. 清单

| 字段 | 值 |
|---|---|
| package | `DingLing.pe.QuickJs.Engine` |
| versionName / Code | `1.0.0` / `447` |
| minSdk / targetSdk | 21 / 30 |
| debuggable | **未声明**（即 false） |
| dex | **1 个**，323,092 字节 |
| 权限 | 8 项，含 `MANAGE_EXTERNAL_STORAGE` |

dex 从 6 个合并成 1 个，`debuggable` 关闭——这一版确实是按"发布"标准构建的，与前后两个 debug 包不同。

---

## 2. 基底判定

从 `.so` 提取 185 个项目侧 `.hx` 路径：

| 基准 | 交集 |
|---|---|
| tag `0.7.3` | 96 |
| tag `1.0` | **130** |

- 只属 1.0 的文件：**34 个**，全在
- 只属 0.7.3 的文件：**0 个**

**判定：1.0 基底**，与 `1.1` 完全一致。

---

## 3. 脚本层：Lua 在这一版被删掉

| 项 | `1.0` | `r-1.0.0` |
|---|---|---|
| `psychlua/FunkinLua.hx` | 有 | **无** |
| Lua 运行时符号 | 有 | **0 个** |
| LuaJIT | 有 | **无** |
| `psychlua/FunkinJS.hx` | 有 | 有 |
| 219 个 Lua API 函数名 | — | **全部保留** |

Lua 运行时、LuaJIT、`FunkinLua.hx` 三者同时消失，而 Lua 的函数名一个不少——这是 `FunkinJS` 把注册表整体接管的直接结果。

**时间点值得记一笔**：删掉 Lua 发生在 11-01，而宣传视频也是 11-01 发的，视频简介写的是"比原先 PE 兼容模组性更上一层楼"。

---

## 4. 渲染层：Vulkan 首次出现

| 项 | 结果 |
|---|---|
| `backend/VulkanAndroid.hx` | **有** |
| `.so` 中 `vk*` 函数 | **65 个** |
| 投影矩阵 `1280, 0, 720` | **无** |

Vulkan 是这一版引入的。但**投影矩阵固定 1280×720 的写死值在这一版还没有**——那是 `1.1` 才出现的，见对应报告。

Vulkan 的边界（单 render pass、贴图槽上限 47、OpenGL 兜底、自称 experimental）在两版中一致。

---

## 5. 防改：Qz7 在这一版上线

| 项 | `1.0` | `r-1.0.0` |
|---|---|---|
| `Qz7`（Java 探针） | 无 | **有** |
| `backend/Qz7r.hx` | 无 | **有** |

四类探针：签名证书 SHA-256、签名者数量、debuggable 标志、APK 条目白名单（根目录 3 项、`lib/` 4 项）。

命中提示 `This copy of the game was modified or re-signed.`，脚本功能关闭。

**注意**：把 `debuggable` 也算作可疑信号，说明作者清楚 debug 构建不是发行形态——而前后两个版本本身就是 `debuggable=true`。

---

## 6. 资源

871 个文件，308MB，与 `1.1` 一致：

```
weekend1/ 全套 · Voices-Player/Voices-Opponent（52 个）· zh-CN.lang · shared/scripts/{demo,menu_demo}.js
```

全部是 1.0 的资产约定。

---

## 7. 结论

| # | 结论 |
|---|---|
| 1 | 基底仍是 1.0（∩1.0=130 / ∩0.7.3=96，只属 0.7.3 的文件 0 个） |
| 2 | **Lua 运行时在这一版被整体删除**，LuaJIT 与 `FunkinLua.hx` 同时消失 |
| 3 | 219 个 Lua API 函数名全部保留，由 `FunkinJS` 接管 |
| 4 | **Vulkan 与 Qz7 均在这一版首次出现** |
| 5 | 是三个包里唯一关闭 debuggable、且把 dex 合并成 1 个的构建 |

这一版是理解整个时间线的关键：**"删 Lua"和"上 Vulkan"是同一批动作**，都发生在 11-01 前后，而不是项目一开始的方向。

---

## 8. 方法

```bash
sha256sum PEQuickJsEngine-release.apk
python tools/analyze.py PEQuickJsEngine-release.apk metrics_r-1.0.0.json
```

原始指标见 [`../evidence/metrics/r-1.0.0.json`](../evidence/metrics/r-1.0.0.json)。

**限制**：静态取证，未安装运行；"文件不存在"基于编译产物符号推断。

---

## 9. 第二轮补充取证

### 9.1 首次改用自签名证书

```
subject : C=CN, O=DingLing, OU=PE-QuickJs-Engine, CN=DingLing
notBefore: 2026-10-31
SHA-256 : CF:FB:98:17:23:11:27:4A:7A:B6:27:09:78:EE:C0:44:F1:CE:9A:B5:89:09:E5:B9:C5:54:BC:69:56:51:6F:02
```

上一版用的是 Android Debug 默认证书，这一版换成了自签密钥（生成于发布前 1 天）。`1.1` 用的是同一把钥匙，指纹完全相同。

**用户侧后果**：从 `1.0` 升级到本版，签名不一致，必须卸载重装，存档与应用数据一并丢失。

### 9.2 自有 Java 类从 5 个涨到 24 个

新增 `Qz7`、`VulkanSurfaceHelper` 及 7 个内部类。同时**旧包名 `com.shadowmario.psychengine` 下的 10 个类没有清理**，同一份实现打了两遍。

### 9.3 源码层的一次性替换

`1.0 → r-1.0.0` 之间：

**移除 17 个文件**

```
llua/Lua.hx  llua/Convert.hx  llua/LuaCallback.hx  llua/LuaException.hx  llua/LuaStateStorage.hx
psychlua/FunkinLua.hx  psychlua/CallbackHandler.hx  psychlua/LuaCallbacks.hx
psychlua/ExtraFunctions.hx  psychlua/DeprecatedFunctions.hx  psychlua/ReflectionFunctions.hx
psychlua/ShaderFunctions.hx  psychlua/TextFunctions.hx  psychlua/FlxAnimateFunctions.hx
psychlua/OverlayFunctions.hx  psychlua/HScript.hx  android/os/Environment.hx
```

**新增 9 个**

```
backend/VulkanAndroid.hx  backend/RenderBackend.hx  backend/Qz7r.hx
backend/ScriptContext.hx  backend/FpsPanelApi.hx
substates/VulkanWarningSubState.hx  states/SecurityNoticeState.hx
psychlua/ScriptVars.hx  mobile/PianoKeys.hx
```

删 Lua 绑定、加 Vulkan、加防改、加安全提示页，是同一批提交。

### 9.4 资源只动了 3 个文件

`1.0 → r-1.0.0`，868 个同名资源里 **867 个逐字节相同**，唯一变化是 `assets/manifest/default.json`（资源索引，随构建变化）。新增的只有：

```
shared/images/opengl_logo.png
shared/images/vulkan_logo.png
shared/images/warn_icon.png
```

也就是说，这一版**没有替换任何游戏素材**，只加了切换渲染器和警告页要用的图标。

### 9.5 安全提示页的原文

```
ILLEGAL PACKAGE MODIFICATION

This copy of the game was modified or re-signed.
To keep your device and your saves safe, all mods and scripts
have been disabled in this session.
Download the official build and install it again.

[ CONTINUE WITHOUT MODS ]
```

这是全屏拦截页，不是一句日志。触发后本局所有 mod 与脚本被禁用。
