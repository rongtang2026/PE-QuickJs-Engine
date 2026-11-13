# PE-QuickJs-Engine `r-1.1` 逆向取证

**发布**：2026-11-12 17:31　**资产**：`PEQuickJsEngine-release-encrypted.apk`
**大小**：516,978,674 字节
**SHA-256**：`696a6041289242211c605206bb8afa2d4da0dcf52f5118cc3d9a182f49d69b63`
**versionCode / Name**：618 / `1.1.0`
**debuggable**：未声明（false）
**上游**：ShadowMario/FNF-PsychEngine（Apache-2.0）

---

## 0. 先说结论

文件名带 `encrypted`，但**没有任何内容被加密**：

| 他做的 | 实际效果 |
|---|---|
| 破坏两个 `.so` 的 CRC | 常规解包工具报错，Android 照常运行 |
| 485MB 条目改为不压缩 | **APK 变大 122MB**，与加密无关 |
| 抹掉 1,099 条 `.hx` 源文件路径 | 挡住了"按源文件比对"这一种方法 |
| 部分类名混淆（`hz57` 等） | 只混淆了自家少数类，核心引擎类名仍在 |
| `res/` 图标改随机名、dex 合并 | 标准资源混淆，无加密作用 |
| 新增运行时反调试 | 唯一有实质作用的部分 |

**没变的**：219 个 Lua API 名全部明文、`states.PlayState` 等核心类名与方法名明文、872/873 个素材文件与上一版逐字节相同、`assets/LICENSE` 与 `NOTICE` 仍在。

---

## 1. 那 122MB 是从哪来的

| | `1.1`（重传） | `r-1.1` |
|---|---|---|
| 条目数 | 901 | 896 |
| 原始大小 | 500 MB | 501 MB |
| 压缩后 | **382 MB** | **493 MB** |
| STORED（不压缩）条目 | 535 个 / 294 MB | 543 个 / **485 MB** |

内容几乎没变，**只是把绝大多数条目从 deflate 改成 store**。体积涨了 111MB，换来的是读取时少一次解压——与安全性无关。

---

## 2. CRC 被改坏

```
可读条目 894 个
坏条目   2 个：lib/arm64-v8a/libApplicationMain.so
              lib/armeabi-v7a/libApplicationMain.so
```

其余条目 CRC 全部正常，说明不是下载损坏，是**打包后动过 so 的字节却没更新 CRC**。

Android 安装与运行都按偏移读，不校验单条目 CRC，所以应用不受影响；但 `unzip`、Python `zipfile`、部分逆向工具会直接报 `BadZipFile` 并拒绝输出。

绕过方式：读本地文件头，按 `header_offset + 30 + nlen + elen` 定位数据段，`compress_type == 0` 时直接读取——本文的所有 so 分析都走这条路。

---

## 3. 源码路径被抹掉

| | `1.1` | `r-1.1` |
|---|---|---|
| `.hx` 路径串 | **1,099 条，全部真实** | **77 条，全部打码** |

打码形如：

```
C:xxxxxxxxxxxxxxxxxxxxxxxxx.hx
C:xxxxxxxxxxxxxxxxxxxxxxxxxxxx.hx
```

连 `backend/`、`psychlua/`、`states/` 这些目录名也一并消失（各 0 条）。

**影响**：以"源文件路径集合"为基准的比对（此前报告的 ∩1.0=130 vs ∩0.7.3=96）在这一版上失效。

**但没挡住**：类名与方法名仍是明文。

```
states.PlayState          217 个方法符号
psychlua.FunkinJS         126 个方法符号
backend.Qz7r              类名仍在
```

用"上游 1.0 的 1361 个方法"去比对，仍命中 **1125 个（82.7%）**，命中率低于 60% 的类还是那 20 个（`Discord`、`FunkinLua`、`HScript`、`WiggleEffect` 等——都是之前就确认删掉的）。

**结论**：结构比对照常成立，只是从"按文件"退回到"按类"。

---

## 4. 类名混淆：只混淆了自家少数类

新增的单字母类：`a.E`、`a.N`、`b.J`、`d.I`、`d.L`、`e.T`、`e.U`……

而 `backend.*` 下的方法符号从 838 条降到 547 条——被混淆的是他自己的模块，不是引擎主体。

最典型的是安全模块：

```
backend.Qz7r.boot      →  只剩 "backend.Qz7r" 与 "Main.new(): Qz7r"
backend.Hardening      →  hz57.boot / hz57.scan / hz57.tick / hz57.fatal / hz57.describe
```

`hz57` 就是 `backend/Hardening.hx` 的混淆名——字符串表里两条并列摆着，等于自报家门。

---

## 5. 新增：运行时反调试

`hz57`（`backend.Hardening`）的检测项全部以字符串形式写在 `.so` 里：

```
[Integrity] native check: 
[Integrity] native check: clean

debugger (TracerPid)                  → /proc/self/status 里的 TracerPid
hooking library mapped                → /proc/self/maps
hooking thread                        → /proc/self/task
code injected from /data/local/tmp    → /data/local/tmp
executable code mapped from /data/local/tmp
root framework (not fatal)            → root 检测，非致命
payload sentinel not decrypted        → 载荷哨兵未解密
```

内部标志位：

```
TRACER  PTRACE  MAPS  INJECT  ROOT  FATAL  THREADS  PAYBLOB
```

这是一套游戏外挂级别的反分析：**调试器、注入、hook 库映射、可疑线程、可疑执行权限路径**都在扫。`ROOT` 标记为 not fatal，其余会置 FATAL。

与 `Qz7`（静态校验）分工不同：`Qz7` 看包，`Hardening` 看运行时。

---

## 6. 没变的部分

| 项 | 结果 |
|---|---|
| Lua API 名 | **219/219 全部明文** |
| `lua_*` / LuaJIT 运行时符号 | 仍为 0 |
| 核心类与方法名 | 明文（PlayState 217、FunkinJS 126） |
| 游戏素材 | 873 个共有文件，**872 个与上一版逐字节相同**，仅 `manifest/default.json` 变化 |
| 许可文件 | `assets/LICENSE`、`assets/NOTICE` 仍在 |
| 新资源 | 只多了一个 `assets/assets/shared/mods_example.zip`（2,761 字节） |
| Java 层 | 122 个类，与上一版一致；`versionCode` 476→484→**618** |

**素材一个都没加密**——这是最直接的反证：如果真做了内容加密，871 个资源文件不可能与上一版哈希全等。

---

## 7. 结论

1. **`encrypted` 是文件名，不是事实。** 没有任何资源、脚本或代码被加密。
2. **做了三件反分析的事**：抹源文件路径、混淆自家类名、破坏 so 的 CRC；外加一套运行时反调试。
3. **核心仍然可读**：API 名、引擎类名、方法名、素材全部原样。
4. **代价是体积**：不压缩让 APK 从 382MB 涨到 493MB。
5. 这一版**关闭了 debuggable**，是三个版本里唯一像发布构建的。

---

## 8. 方法

```bash
# CRC 被破坏，不能直接解压，按偏移读取
python - <<'PY'
i = z.getinfo("lib/arm64-v8a/libApplicationMain.so")
f.seek(i.header_offset + 30 + nlen + elen)
data = f.read(i.compress_size)      # compress_type == 0，即原始字节
PY

# Java 层
java -Xmx448m -XX:+UseSerialGC -cp jadx-all.jar jadx.cli.JadxCLI -d out --no-res --no-debug-info dex_r11
```

**限制**：`.so` 仍无 `.symtab`；`Hardening` 的判定阈值与触发后果在 native 代码里，无法静态还原，只能确认它检查哪些项。
