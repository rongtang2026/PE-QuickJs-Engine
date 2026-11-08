# PE-QuickJs-Engine（社区源码重建分支）

本分支提供 PE-QuickJs-Engine 的完整源码。在此之前，本仓库仅包含一个 README 文件。

## 来源与许可

- 源码来自 [Open-QuickJs-Engine](https://github.com/Lv233-Haxe/Open-QuickJs-Engine)：社区对本引擎发行 APK（取证报告见 [issue #7](https://github.com/rongtang2026/PE-QuickJs-Engine/issues/7)，APK SHA-256 `2a24ebb0…67142`）的逆向还原，按 **Apache-2.0** 开源。
- 上游引擎 [ShadowMario/FNF-PsychEngine](https://github.com/ShadowMario/FNF-PsychEngine) 为 Apache-2.0，归属声明见 [NOTICE](NOTICE)。
- 脚本运行时 [QuickJS](https://bellard.org/quickjs/)（Fabrice Bellard，MIT），预编译库位于 `native/quickjs/`。

## 构建说明

```bash
haxelib install hmm.json
haxelib run lime build android
```

注意：游戏资源（assets）未随本源码分发，需按上游许可自行获取。

## 目录结构

| 路径 | 内容 |
|---|---|
| `source/` | Haxe 源码，含 QuickJS 绑定与自定义 API（`FunkinJS.hx` 等脚本桥接层） |
| `native/quickjs/` | QuickJS 预编译库（Windows x64） |
| `docs/` | 逆向还原过程的对照文档 |

## 说明

本分支不改变源码的公开状态——它此前已按 Apache-2.0 公开于 Open-QuickJs-Engine。本 PR 仅使「仓库描述」与「仓库内容」保持一致。
