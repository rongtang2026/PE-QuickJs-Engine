# NOTICE

## 本仓库的内容来源

本仓库是对 `PEQuickJsEngine-debug-test.apk`（作者 rongtang2026）的**静态逆向分析记录**，用于技术评论与合规性讨论。仓库内所有反汇编产物、字符串提取结果、文件清单均来自该 APK。

## 上游作品归属

该 APK 声明基于 **Friday Night Funkin': Psych Engine 0.7.3**；经文件集比对，其源码与资源分布更接近 tag `1.0`（见 v5 报告第 4 节）。两个 tag 均以同一许可发布，本仓库据此引用。

- 项目：https://github.com/ShadowMario/FNF-PsychEngine
- 涉及版本：tag `0.7.3`（commit `2dfa277`）与 tag `1.0`
- 许可：Apache License 2.0
- 版权：ShadowMario 及 Psych Engine 贡献者

`evidence/smali/` 下的反汇编内容、`evidence/upstream/` 下的上游源文件，作为上述作品的衍生/引用内容，遵循同一许可分发。本仓库在此附带许可证全文：见 [`LICENSE-APACHE-2.0.txt`](LICENSE-APACHE-2.0.txt)。

Friday Night Funkin' 本体与游戏素材版权归 ninjamuffin99、PhantomArcade、kawaisprite、evilsk8r 及各自作者所有。

## 分析结论的边界

本仓库只陈述可复现的静态证据，不对作者个人作评价。涉及"某文件不存在"的判断基于编译产物中的符号与路径字符串推断，方法学限制见 v5 报告第 1 节。

## 与本案无关的第三方

`libvlc.so` 来自 VideoLAN（LGPL-2.1+），未在本仓库分发。
