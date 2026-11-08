# PE-QuickJs-Engine

一个引擎。有代码的那种。🤚

- 本仓库的全部源码来自 [Open-QuickJs-Engine](https://github.com/Lv233-Haxe/Open-QuickJs-Engine)（Apache-2.0）—— 社区对本引擎发行 APK 的逆向还原，取证报告见 [issue #7](https://github.com/rongtang2026/PE-QuickJs-Engine/issues/7)
- 上游 [ShadowMario/FNF-PsychEngine](https://github.com/ShadowMario/FNF-PsychEngine)（Apache-2.0），归属声明见 [NOTICE](NOTICE)
- 脚本运行时 [QuickJS](https://bellard.org/quickjs/)（Fabrice Bellard，MIT）

## 构建

```bash
haxelib install hmm.json
haxelib run lime build android
```

游戏资源未随源码分发，按上游许可自行获取。

## 目录

| 路径 | 内容 |
|---|---|
| `source/` | 226 个 Haxe 源文件：QuickJS 绑定、自定义 API、`FunkinJS.hx` 等脚本桥接层 |
| `native/` | QuickJS 与 Vulkan 原生层 |
| `docs/original-readme.md` | 原 README（3454 字节散文版），历史文物，温柔保存 |

> 本仓库曾连续 13 天没有任何代码。这个 PR 结束了那个时代。
