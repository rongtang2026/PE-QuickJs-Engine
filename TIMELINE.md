# 时间线

记录发布、报告、以及**工件本身被替换**的时间点。时间统一为 UTC+8。

| 时间 | 事件 |
|---|---|
| 10-26 20:06 | 发布 `1.0`（`PsychEngine-debug.apk`，sha `f3330da8…`） |
| 11-01 05:03 | 发布 `r-1.0.0`（`PEQuickJsEngine-release.apk`，sha `6923bfd2…`） |
| 11-01 | B 站宣传视频发布（BV1Lvxx6vE8n），简介称"兼容模组性更上一层楼" |
| 11-04 23:26 | 发布 `1.1`（`PEQuickJsEngine-debug-test.apk`，sha `2a24ebb0…`，versionCode 476） |
| 11-05 08:05 | issue #7：本报告提交 |
| 11-05 10:01 | issue #8 "vibe coding engine" |
| 11-05 12:11 | issue #9 |
| 11-05 15:09 | issue #10 |
| **11-06 11:56** | **`1.1` 的 release 资产被替换**：sha `18c7a99b…`，versionCode 476 → **484** |
| 11-06 | 仓库 README 大改：新增"致逆向大师与伸手党"一节，承认"100% 是 AI 做的"，并称"自 v1.1.0 起 APK 内已包含 LICENSE 与 NOTICE" |

---

## 11-06 的资产替换

同一个 release tag `1.1`、同一个文件名 `PEQuickJsEngine-debug-test.apk`，内容被换掉了：

| | 原资产 | 现资产 |
|---|---|---|
| 大小 | 400,750,869 | 400,763,276 |
| SHA-256 | `2a24ebb00bb15efc…` | `18c7a99b9563540d…` |
| versionCode | 476 | **484** |
| versionName | 1.1.0 | 1.1.0（未变） |

### 改了什么

**新增 2 个文件**

```
assets/LICENSE   11,324 B   Apache License 2.0 全文
assets/NOTICE     2,592 B   含 Shadow Mario / Riveren / ninjamuffin99 归属
```

**新增 1 个源文件**

```
backend/SecStr.hx   （旧包里不存在；方法：boot / h / hexVal）
```

**Java 层改动 2 个类**

| 类 | 变化 |
|---|---|
| `BuildConfig` | versionCode 476 → 484 |
| `Qz7` | 新增方法 `e()I`（229 行），检查 `ApplicationInfo.splitSourceDirs` 与签名，即**分包 APK 检测** |

**其余 899 个条目里，除清单、签名文件、`assets/manifest/default.json`、`classes5.dex` 外未变。**

### 没变的部分

```
基底              仍为 1.0（∩1.0=130，仅属 0.7.3 的文件 0 个）
Lua 运行时        仍为 0 个符号
Lua API 名        仍为 219/219 全部可见
Vulkan            仍为 65 个 vk* 函数
1280×720 写死     仍在
Qz7               仍在，并新增分包检测
```

`backend/SecStr.hx` 看起来是字符串编码工具（`hexVal` 之类），但 **219 个 API 名依然以明文存在于 `.so`**，说明它还没有被大规模投入使用。作者在 11-05 说过"下个版本把防逆向的活儿也干了"，这一版对应的是分包检测与这个工具类。

---

## 关于"自 v1.1.0 起已包含 LICENSE 与 NOTICE"

按现有资产看，这句话成立：现在的 `1.1` 里确实有 `assets/LICENSE` 和 `assets/NOTICE`。

但时间顺序是：

1. `1.1` 于 11-04 23:26 发布，当时的资产（sha `2a24ebb0…`）**不含任何许可文件**——本报告第 8 节就是基于那个包写的。
2. 11-05 报告指出这一点。
3. 11-06 11:56，同一 tag 下的资产被替换，补上了 LICENSE 与 NOTICE。

也就是说，**合规是后补的，不是发行时就有的**。这本身是好事——报告指出的问题被修了——但"自 v1.1.0 起"这个时间表述与事实相反：v1.1.0 首次发布时不具备，是 11-06 的重新构建才具备。

---

## 仍未改变的声明

改版后的 README 开头依然写着：

> This engine is a heavily modified, pure mobile reconstruction based on the original Psych Engine 0.7.3.

三个发布包的实测结果都是 1.0 基底（11-06 的重构建也一样）。这一句从 10-26 到现在没有变过。

---

## 11-12 的 `r-1.1`

| | `1.1`（11-06 重传） | `r-1.1`（11-12） |
|---|---|---|
| 大小 | 400,763,276 | 516,978,674 |
| SHA-256 | `18c7a99b…` | `696a6041…` |
| versionCode | 484 | **618** |
| debuggable | true | **false** |
| dex | 7 | **1** |
| `.hx` 路径串 | 1,099 条真实 | **77 条，全部打码** |
| `libApplicationMain.so` CRC | 正常 | **被改坏**（两架构各一） |
| 压缩后体积 | 382 MB | 493 MB（485MB 改为不压缩） |
| 素材 | 871 | 873 个里 872 个与上版逐字节相同 |
| 新增 | — | `backend.Hardening`（混淆名 `hz57`）、`mods_example.zip`、`res/` 重命名 |

反调试检测项：`TracerPid`、`hooking library mapped`、`hooking thread`、`code injected from /data/local/tmp`、`root framework (not fatal)`、`payload sentinel not decrypted`。

README 同期改动：开头版本声明被改成 "based on the original Psych Engine . You 1.0.4"（句子本身残缺），并新增一段称本仓库"可能是假仓库、可能藏病毒"。
