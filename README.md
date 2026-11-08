# PE-QuickJs-Engine

一个引擎。有代码的那种。🤚

## Credits

- **逆向还原与源码整理：[@Lv233-Haxe](https://github.com/Lv233-Haxe) 及 [Open-QuickJs-Engine](https://github.com/Lv233-Haxe/Open-QuickJs-Engine) 全体贡献者**（Apache-2.0）—— 本仓库全部源码来自该项目对本引擎发行 APK 的还原，取证报告见 [issue #7](https://github.com/rongtang2026/PE-QuickJs-Engine/issues/7)
- 本分支由 [mohong2](https://github.com/mohong2) 搬运提交 PR，仅做文档补充，不主张任何还原署名
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
