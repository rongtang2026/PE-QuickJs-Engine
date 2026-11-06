# PE-QuickJs-Engine `1.0` 逆向取证

**发布**：2026-10-26　**资产**：`PsychEngine-debug.apk`
**大小**：401,134,643 字节
**SHA-256**：`f3330da8eef04df363199ededc982fcf4bd7d03a7a124f84f30fcb0f8bd8460d`
**上游**：ShadowMario/FNF-PsychEngine（Apache-2.0）

---

## 0. 这一版是什么

作者发布序列里最早的一个包。三句话概括：

1. **基底已经是 Psych 1.0，不是 0.7.3**
2. **Lua 还在**，而且和 QuickJS **同时存在**
3. **没有 Vulkan，也没有防改**，包名还叫 `com.shadowmario.psychengine`

---

## 1. 清单

| 字段 | 值 |
|---|---|
| package | `com.shadowmario.psychengine`（**上游原包名**） |
| versionName / Code | `0.2.8` / `229` |
| minSdk / targetSdk | 21 / 30 |
| debuggable | `true` |
| dex | 6 个，合计 352,460 字节 |
| 权限 | 8 项，含 `MANAGE_EXTERNAL_STORAGE` |

`versionName` 是 Psych `Project.xml` 里的默认值 `0.2.8`——**连这一项都没改**，包名同样沿用了上游的 `com.shadowmario.psychengine`。也就是说这一版在元数据层面基本就是原版 Psych 的构建。

---

## 2. 基底判定

从 `.so` 提取 193 个项目侧 `.hx` 路径，与两个上游 tag 求交集：

| 基准 | 交集 |
|---|---|
| tag `0.7.3` | 105 |
| tag `1.0` | **139** |

不对称性：

- 只属 1.0、0.7.3 没有的文件：**34 个**，全都在包里
- 只属 0.7.3、1.0 没有的文件：**0 个**

**判定：1.0 基底。**这一版比后面两个更接近原版——`193` 个项目文件里有 `139` 个与 1.0 重合，比例 72%，是三版中最高的。

---

## 3. 脚本层：Lua 与 QuickJS 并存

| 项 | 结果 |
|---|---|
| `psychlua/FunkinLua.hx` | **存在** |
| Lua 运行时符号（`lua_pcall` / `lua_newstate` / `luaL_*`） | **存在** |
| LuaJIT | **存在** |
| `psychlua/FunkinJS.hx` | **存在** |
| `backend/QuickJS.hx` | **存在** |
| `JS_NewRuntime2` / `JS_Eval` / `JS_Call` | **存在** |

这是本报告最值得注意的一条：**QuickJS 不是在删掉 Lua 之后才加的，而是与 Lua 并行存在**。

换句话说，开发路径不是"把 Lua 换成 JS"，而是"先两套并存，后来直接砍掉 Lua"。删 Lua 发生在下一版（`r-1.0.0`），见对应报告。

---

## 4. 渲染层

| 项 | 结果 |
|---|---|
| `backend/VulkanAndroid.hx` | **不存在** |
| `.so` 中 `vk*` 函数 | **0 个** |
| `libvulkan.so` 引用 | 无 |

这一版**完全没有 Vulkan**，只有 lime 的 OpenGL 路径。所谓"Vulkan 渲染"是 `r-1.0.0` 才引入的。

---

## 5. 防改

| 项 | 结果 |
|---|---|
| `Qz7`（Java 探针） | **不存在** |
| `backend/Qz7r.hx` | **不存在** |

这一版没有完整性校验。它也是三版里唯一"打开即用、不设门槛"的。

---

## 6. 资源

868 个文件，308MB。`assets/` 根目录仍是：

```
do NOT readme.txt      4,326 B   原版 FNF 的 readme
modsList.txt           0 B
```

含 `weekend1/` 全套、`Voices-Player` / `Voices-Opponent` 拆分人声（52 个文件）、`zh-CN.lang`、`shared/scripts/demo.js` 与 `menu_demo.js`。

**这三样都是 1.0 的资产约定**，0.7.3 里没有——资源层面同样指向 1.0。

---

## 7. 结论

| # | 结论 |
|---|---|
| 1 | 基底是 1.0（∩1.0=139 / ∩0.7.3=105，只属 0.7.3 的文件 0 个） |
| 2 | Lua 运行时**完整存在**，FunkinLua 与 FunkinJS 并存 |
| 3 | **没有 Vulkan**（`vk*` 函数 0 个） |
| 4 | **没有防改**（无 Qz7） |
| 5 | 包名与版本号沿用上游默认值，未做任何配置 |

这一版的存在本身，构成了对"0.7.3 为底、后来才把 1.0 移植进来"这一说法的反证：**发布序列的第一版就已经是 1.0 了**，那时还没有可供"顺手移植"的后续开发。

---

## 8. 方法

```bash
sha256sum PsychEngine-debug.apk
python tools/analyze.py PsychEngine-debug.apk metrics_1.0.json
```

原始指标见 [`../evidence/metrics/1.0.json`](../evidence/metrics/1.0.json)。

**限制**：静态取证，未安装运行；"文件不存在"基于编译产物中的符号与路径字符串推断，空类或纯类型别名可能漏检。

---

## 9. 第二轮补充取证

### 9.1 签名证书

```
subject : CN=Android Debug, O=Android, C=US
issuer  : CN=Android Debug, O=Android, C=US
notBefore: 2026-09-23
SHA-256 : 59:FC:2C:B1:38:B2:71:D3:C4:46:26:64:FB:F9:48:FD:CE:07:B2:9D:52:15:73:11:AB:CF:A5:82:5A:6E:A5:AD
```

这是 **Android SDK 自带的默认 debug 证书**，不是发布用密钥。配合前文"versionName 仍是 Psych 默认的 0.2.8、包名仍是 `com.shadowmario.psychengine`"，可以判断这一版是开发环境直接导出的 debug 包。

### 9.2 自有 Java 类只有 5 个

```
BuildConfig  MainActivity  MemoryInfoHelper  R  R$drawable
```

没有 `VulkanSurfaceHelper`，没有 `Qz7`——与"无 Vulkan、无防改"在 native 侧的结论一致。

### 9.3 外部目录用的是 `.PsychEngine`

`.so` 内 `/storage/emulated/0/.PsychEngine` 出现 **7 次**，`.QJsEngine` **0 次**。改目录名是下一版的事。

### 9.4 Lua 绑定的完整程度

这一版带完整的 `llua/` Haxe 绑定包：

```
llua/Lua.hx            llua/Convert.hx        llua/LuaCallback.hx
llua/LuaException.hx   llua/LuaStateStorage.hx
```

不是"象征性支持"，是完整接入。这些文件在 `r-1.0.0` 里全部消失。

### 9.5 没有安全提示页

`ILLEGAL PACKAGE MODIFICATION` 那套提示在这一版不存在，与无 `Qz7` 一致。
