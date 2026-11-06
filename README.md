# 我把 PE-QuickJs-Engine 的三个发布包都拆了

作者说它基于 Psych Engine 0.7.3。
**从第一个版本起就是 1.0。**

三个包,同一套流程,数字都在这儿。

---

## 三个版本摆一起

| | `1.0`<br>10-26 | `r-1.0.0`<br>11-01 | `1.1`<br>11-04 |
|---|---|---|---|
| 资产名 | `PsychEngine-debug.apk` | `PEQuickJsEngine-release.apk` | `PEQuickJsEngine-debug-test.apk` |
| package | `com.shadowmario.psychengine` | `DingLing.pe.QuickJs.Engine` | 同左 |
| versionName | `0.2.8` | `1.0.0` | `1.1.0` |
| debuggable | ✔ | — | ✔ |
| dex 数 | 6 | 1 | 7 |
| **Lua 运行时** | **有** | 无 | 无 |
| **Vulkan** | **0 个 `vk*`** | 65 个 | 65 个 |
| **防改 `Qz7`** | **无** | 有 | 有 |
| 投影写死 1280×720 | — | 无 | **有** |
| 签名证书 | Android Debug 默认 | 自签 DingLing | 同左 |
| 基底 | 1.0 | 1.0 | 1.0 |

---

## 时间线才是重点

**10 月 26 日 —— 第一版**

包名还是 `com.shadowmario.psychengine`,版本号还是 Psych 默认的 `0.2.8`,连元数据都没改。这一版:

- Lua 运行时**完整存在**,`FunkinLua.hx` 在
- **QuickJS 也已经在了**,`FunkinJS.hx` 同时存在
- **没有 Vulkan**,`vk*` 函数 0 个
- **没有防改**

两套脚本引擎并行——他的路线不是"把 Lua 换成 JS",是"先并存,后来直接砍掉"。

**11 月 1 日 —— 一次性换了四样东西**

改包名、删 Lua、上 Vulkan、上防改,全在这一版。也是这一天,宣传视频发了,简介写着"比原先 PE 兼容模组性更上一层楼"。

**11 月 4 日 —— 回到 debug**

`debuggable=true`,签名是 debug 证书。按他自己 README 的规则("只有 `r-` 前缀才是正式版"),这版不算正式发布。而 `1280×720` 的写死投影,也是这一版才出现的。

---

## 三个数得记住

```
219 / 219     Lua API 函数名,一个不落全保留
   0          Lua 运行时符号（r-1.0.0 起）
  47          Vulkan 贴图槽硬上限
```

**函数名全抄、引擎换掉。**所有现成 mod 都要重写成 JS,而 `makeLuaSprite` 还是叫 `makeLuaSprite`。

---

## 签名与资源

**签名**：`1.0` 用的是 Android SDK 自带的 debug 证书（`CN=Android Debug`，2026-09-23 生成）；`r-1.0.0` 换成自签密钥（`CN=DingLing`，2026-10-31 生成），`1.1` 沿用同一把。

后果很实际：**从 `1.0` 升级到 `r-1.0.0` 必须卸载重装**，签名对不上。而后两个版本可以互相覆盖。

**资源**：

| 对比 | 结果 |
|---|---|
| `1.0` → `r-1.0.0` | 868 个同名文件里 **867 个逐字节相同**，只加了 3 张图（`vulkan_logo`、`opengl_logo`、`warn_icon`） |
| `r-1.0.0` → `1.1` | 871 个文件 **全部逐字节相同，差异 0** |

也就是说，`1.1` 相对上一版**没有动过任何素材**，只改了代码。

---

## 关于"是不是 1.0"

版本号可以改,所以不看版本号。看两样改不动的东西。

**① 方法名分布**（两版都有的 4 个类,比方法差集,再看包里有没有）

| 类 | 仅 1.0 有 → 包里有 | 仅 0.7.3 有 → 包里有 |
|---|---|---|
| `states.PlayState` | 3 → 1 | 0 → 0 |
| `objects.Character` | 2 → 2 | 1 → **0** |
| `backend.Paths` | 3 → 3 | 6 → **0** |
| `objects.Note` | 1 → 1 | 0 → 0 |
| 合计 | **9 → 7** | **7 → 0** |

`Paths` 里 6 个 0.7.3 时代的 mods 路径方法（`getLibraryPath`、`modsAchievements`、`modsShaderVertex`…）一个都不在了,换成 1.0 的 `getFolderPath`、`getMultiAtlas`。

移植是加法,旧方法不会消失。**7 → 0 只有一种解释:底座换了。**

**② 资源**

三个包都带 `weekend1/` 全套、`Voices-Player`/`Voices-Opponent` 拆分人声、`zh-CN.lang`——全是 1.0 的资产约定,0.7.3 没这些文件。要"改字符串"改到这个程度,得把 308MB 资源一起改。

**③ 时间点**

最早那版（10-26）就已经是 1.0 了。那时还没有后续开发,也就没有"顺手把 1.0 移植进来"的空间。

---

## 防改

`Qz7` 四类探针:

- 签名证书的 SHA-256
- 签名者数量
- **debuggable 标志**（`flags & 0x2`）
- APK 条目白名单（根目录 3 项,`lib/` 4 项）

命中后不是弹个提示框，是**全屏拦截页**：

```
ILLEGAL PACKAGE MODIFICATION

This copy of the game was modified or re-signed.
To keep your device and your saves safe, all mods and scripts
have been disabled in this session.
Download the official build and install it again.

[ CONTINUE WITHOUT MODS ]
```

继续进去，本局所有 mod 与脚本被禁用。

把 `debuggable` 也算作可疑信号——而 `1.0` 和 `1.1` 两个发布包本身就是 `debuggable=true`。

另一处结构性问题在脚本层：每个 JS API 都由包装器生成，调用时先 `JSON.stringify(args)` 再过字符串分发到 native。QuickJS 本身没有 JIT。这套链路在逐帧调用的场景下开销是结构性的——但没做基准测试，只记录设计，不下性能结论。

---

## 自己验

```bash
# 三个包都能从 Releases 下到,校验值见各版本报告开头
python tools/analyze.py <apk> out.json
```

`analyze.py` 输出:清单字段、dex 数与字节、assets 标记（weekend1 / 拆分人声 / zh-CN）、`.so` 内的 Lua 与 QuickJS 符号、`vk*` 函数数、`.hx` 路径集与两个上游 tag 的交集。

原始指标在 [`evidence/metrics/`](evidence/metrics/),1.1 的详证（smali、字符串、资源清单）在 [`evidence/`](evidence/)。

---

## 版本报告

| 版本 | 报告 | 一句话 |
|---|---|---|
| `1.0` | [md](1.0/report.md) · [html](1.0/report.html) | 1.0 基底,Lua 与 QuickJS 并存,无 Vulkan 无防改,包名与版本号都是上游默认值,Android Debug 签名 |
| `r-1.0.0` | [md](r-1.0.0/report.md) · [html](r-1.0.0/report.html) | 删 Lua（含整个 `llua/` 绑定）、上 Vulkan、上防改、改包名,同一天;资源只加 3 张图 |
| `1.1` | [md](1.1/report.md) · [html](1.1/report.html) | 回到 debug 构建,`1280×720` 写死投影首次出现;资源与上一版 871 个文件逐字节相同 |

---

## 边界

- 全部为**静态取证**,没有安装运行,不含动态测试结论。
- 只陈述可复现的技术事实,不评价作者个人。
- "文件不存在"类判断基于编译产物中的符号与路径字符串,限制写在每份报告的方法一节。
- 反汇编内容来自上述三个 APK,其上游为 Apache-2.0,许可证见 [`LICENSE-APACHE-2.0.txt`](LICENSE-APACHE-2.0.txt),来源说明见 [`NOTICE.md`](NOTICE.md)。
