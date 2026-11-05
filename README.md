# 我把 PE-QuickJs-Engine 的 APK 拆了

**一个 400MB 的"移动端 FNF 引擎",拆开之后是这样。**

作者说它基于 Psych Engine 0.7.3。拆完发现:**代码底座是 1.0**。
作者说它"兼容模组性更上一层楼"。拆完发现:**Lua 运行时一个符号都没有**。

---

## 一分钟版

| 他说的 | 实际的 |
|---|---|
| 基于 Psych 0.7.3 | 与 1.0 文件集重合 **130/187**,与 0.7.3 只有 96/187;34 个文件只在 1.0 里,**0 个**只在 0.7.3 里 |
| 兼容模组 | `lua_*` / `luaL_*` / LuaJIT 符号 **0 个**;219 个 Lua API 函数名**全都在**,但没有解释器,`.lua` 一行都跑不了 |
| Vulkan 渲染 | 确实有 65 个 `vk*` 函数,但**单 render pass、贴图槽上限 47、投影矩阵写死 1280×720**,OpenGL 仍在底下跑,自己标注 experimental |
| 正式发布 | 最新 `1.1`(11-04)就是 `debuggable=true` 的 debug 包,按他自己"只有 `r-` 才算正式版"的规则不算正式版 |
| 开源 | 仓库 `license: null`,APK 内无 LICENSE/NOTICE,上游是 Apache-2.0 |

---

## 三个数得记住

```
219 / 219     Lua API 函数名,一个不落全保留
   0          Lua 运行时符号
  47          Vulkan 贴图槽硬上限
```

**函数名全抄、引擎换掉**——这是整件事最核心的一句。所有现成 mod 都得改写成 JS,而 API 名字看起来还是原来那套,`makeLuaSprite` 还是 `makeLuaSprite`。

---

## 关于"我怎么知道是 1.0,不是 0.7.3"

版本号字符串是可以改的,所以不看它。看两样改不动的东西:

**① 方法名分布**

拿两版都有的 4 个类,比方法差集,再看包里有没有:

| 类 | 仅 1.0 有 → 包里有 | 仅 0.7.3 有 → 包里有 |
|---|---|---|
| `states.PlayState` | 3 → 1 | 0 → 0 |
| `objects.Character` | 2 → 2 | 1 → **0** |
| `backend.Paths` | 3 → 3 | 6 → **0** |
| `objects.Note` | 1 → 1 | 0 → 0 |
| 合计 | **9 → 7** | **7 → 0** |

`Paths` 里 6 个 0.7.3 时代的 mods 路径方法（`getLibraryPath`、`modsAchievements`、`modsShaderVertex`…）**一个都不在了**,换成 1.0 的 `getFolderPath`、`getMultiAtlas`。

移植是加法,旧方法不会消失。**7 → 0 只有一种解释:底座换了。**

**② 资源**

包里带 `weekend1/` 全套、`Voices-Player` / `Voices-Opponent` 拆分人声、`zh-CN.lang`——全是 1.0 的资产约定,0.7.3 没有这些文件。要"改字符串"改到这个程度,得把 310MB 资源一起改。

---

## 还有一层:他自己加了防改

`Qz7` 这套 Java 探针会查:

- 签名证书的 SHA-256
- 签名者数量
- **debuggable 标志**（`flags & 0x2`）
- APK 条目白名单（根目录只放行 3 个文件,`lib/` 只放行 4 个 `.so`）

命中就提示 `This copy of the game was modified or re-signed.`,脚本功能关掉。

而这份**官方发布的包,`debuggable=true`**,最基础那一条自己就先命中了。

---

## 想自己验

```bash
sha256sum PEQuickJsEngine-debug-test.apk
# 2a24ebb00bb15efcc2d25eebda88d2067a2386554649d9e77cc0de961bf67142

java -jar apktool.jar d -f --no-assets -o out PEQuickJsEngine-debug-test.apk
grep -c "^.method" out/smali_classes5/DingLing/pe/QuickJs/Engine/Qz7.smali

python scan.py lib/arm64-v8a/libApplicationMain.so lua   # 0 条
```

命令、原始数据、反汇编都在 [`evidence/`](evidence/)。

---

## 版本

报告改过五版,每版都在,包括我自己出错的那两版:

| 版本 | 要点 |
|---|---|
| [v1](v1/report.md) | 初版。**错了**:误判"APK 里没资源",且误信 0.7.3 |
| [v2](v2/report.md) | 修正基准为 1.0,补资源与贴图哈希比对 |
| [v3](v3/report.md) | 收窄范围,去掉与主题无关的争议项 |
| [v4](v4/report.md) | 补发布归属、修正 Qz7 机制描述、文档不一致 |
| [v5](v5/report.md) | **当前版**。新增方法级判定,回应"只是移植"的说法 |

改了什么、为什么改,见 [`VERSIONS.md`](VERSIONS.md)。

---

## 边界

- 全部为**静态取证**,没有安装运行,不含任何动态测试结论。
- 只就可复现的技术事实作说明,不对作者个人作评价。
- "文件不存在"类判断基于编译产物中的符号与路径字符串,方法学限制写在每版报告第 1 节。
- 反汇编内容来自上述 APK,其上游为 Apache-2.0,许可证全文见 [`LICENSE-APACHE-2.0.txt`](LICENSE-APACHE-2.0.txt),来源说明见 [`NOTICE.md`](NOTICE.md)。
