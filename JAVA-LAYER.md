# Java 层还原（四个包）

这份只讲 Java 层——`libApplicationMain.so` 里的东西另见 [`RECON.md`](RECON.md)。

对象：`1.0`、`r-1.0.0`、`1.1`（原始资产）、`1.1`（11-06 重传资产）。

---

## 0. 工具

```bash
java -Xmx448m -XX:+UseSerialGC -cp jadx-all.jar jadx.cli.JadxCLI \
     -d out --no-res --no-debug-info <dex 目录>
```

两条必须注意：

1. **限堆**。本机可用内存只有 0.9GB，用默认 `-Xmx2g` 会触发换页，进程被直接终止。
2. **指定 CLI 入口**。`-jar jadx-all.jar <单文件>` 会走 GUI 分支，在 headless 下抛 `HeadlessException`。

结果：四份各 8 秒左右，117–122 个类。

---

## 1. 类清单

| 版本 | `DingLing/pe/QuickJs/Engine` | `com/shadowmario/psychengine` |
|---|---|---|
| `1.0` | — | 4 个：`BuildConfig` `MainActivity` `MemoryInfoHelper` `R` |
| `r-1.0.0` | 6 个：`BuildConfig` `MainActivity` `MemoryInfoHelper` `Qz7` `R` `VulkanSurfaceHelper` | 3 个（旧包名残留）：`MainActivity` `MemoryInfoHelper` `VulkanSurfaceHelper` |
| `1.1` | 同上 6 个 | 同上 3 个 |
| `1.1` 重传 | 同上 6 个 | 同上 3 个 |

`1.0` 的 Java 层只有 4 个类，没有 `Qz7`、没有 `VulkanSurfaceHelper`——与前文"无防改、无 Vulkan"一致。

---

## 2. Qz7：八个探针的完整语义

`1.1` 原始资产里 `Qz7` 有 7 个方法 + 构造器；重传版多一个 `e()`。

| 方法 | 返回 | 实际行为 |
|---|---|---|
| `v()` | `byte[32]` | 取 `signatures[0]`（**只取第一张证书**）做 SHA-256，静态字段 `c` 缓存 |
| `a(int i)` | `int` | 从上面 32 字节取第 `i` 个 4 字节大端整数，`i ∈ 0..7` |
| `b()` | `int` | 签名者数量；API 28+ 走 `SigningInfo`，以下走 `PackageInfo.signatures` |
| `c()` | `int` | `(ApplicationInfo.flags & 2) != 0 ? 1 : 0`，即 **debuggable** |
| `d()` | `int` | 遍历 APK 条目，返回**位掩码**（见下） |
| `e()` | `int` | **仅重传版有**，打包三个状态（见下） |
| `okRoot()` | `bool` | 根目录白名单：`AndroidManifest.xml` / `resources.arsc` / `DebugProbesKt.bin` |
| `okSo()` | `bool` | `lib/` 白名单：`libApplicationMain.so` / `libc++_shared.so` / `liblime.so` / `libvlc.so` |

### `d()` 的位含义

```java
if (name.startsWith("classes") && name.endsWith(".dex")) {
    // 编号解析失败 / 编号 < 2 / 数量与最大编号不符  -> i |= 1
} else if (name.startsWith("lib/")) {
    if (!okSo(name)) i |= 2;
} else if (!res/ !META-INF/ !kotlin/ 且根级 且 !okRoot(name)) {
    i |= 4;
}
```

| 位 | 触发 |
|---|---|
| `& 1` | dex 编号异常（缺 `classes.dex`、编号重复、数量与最大编号不符） |
| `& 2` | `lib/` 下有白名单外的 `.so` |
| `& 4` | 根目录出现白名单外的条目 |

### `e()`：重传版新增，把三个状态压进一个 int

```java
public static int e() {
    ApplicationInfo ai = context.getApplicationInfo();
    int i2 = (ai.flags & 2) != 0 ? 1 : 0;          // bit 0: debuggable
    ...
    int i3 = apkContentsSigners.length;            // 签名数量
    if (i3 > 255) i3 = 255;
    int i4 = i2 | (i3 << 8);                       // bit 8-15: 签名数
    int i5 = ai.splitSourceDirs != null ? ai.splitSourceDirs.length : 0;
    if (i5 > 255) i5 = 255;
    return i4 | (i5 << 16);                        // bit 16-23: 分包数量
}
```

一个 int 里塞了 **debuggable + 签名数 + 分包数**。分包数用来识别 App Bundle 拆分安装（第三方商店常见做法），签名数用来识别多签名重签。

**注意**：它同样把 debuggable 编码进去了。而 `1.0` 与 `1.1` 这两个官方发布包本身就是 `debuggable=true`。

---

## 3. 版本间实际差异

### `1.1` → `1.1` 重传

122 个 Java 文件，**只有 2 个不同**：

| 文件 | 变化 |
|---|---|
| `BuildConfig.java` | `VERSION_CODE` 476 → 484 |
| `Qz7.java` | 新增 `e()` |

其余 120 个逐字节相同。

### `r-1.0.0` → `1.1`

122 个文件全部同名，其中 60 个显示"不同"，但逐个看是**反编译噪点**：

```diff
- } catch (NumberFormatException unused) {
+ } catch (NumberFormatException e) {
```

差异集中在 `com.google.gson`，原因是两版 dex 布局不同（`r-1.0.0` 合并成 1 个 dex，`1.1` 拆成 7 个），jadx 生成的局部变量名随之变化。**源码层面没有改动。**

`VulkanSurfaceHelper` 在两版之间完全相同——说明 `1.1` 新增的 `1280×720` 写死投影不在 Java 层，而在 native。

### `1.0` → `r-1.0.0`

新增 `Qz7`、`VulkanSurfaceHelper` 两个类；包名从 `com.shadowmario.psychengine` 改成 `DingLing.pe.QuickJs.Engine`，但旧包名的类**没有删干净**（`MainActivity`、`MemoryInfoHelper`、`VulkanSurfaceHelper` 各留一份）。

---

## 4. 结论

1. **Java 层很薄**，四个版本加起来核心就是 `MainActivity`（空壳）、`MemoryInfoHelper`、`VulkanSurfaceHelper`（Canvas 文字层）、`Qz7`（校验）。
2. **功能都在 native**。Java 层从 `r-1.0.0` 到 `1.1` 一行没改，但 native 的 `1280×720` 是新加的——两侧证据互相印证。
3. **`Qz7` 的判定依赖签名、dex 编号、so 白名单、分包数**，其中签名只取第一张证书，多签名时其余忽略；这会让"新增一个签名证书"的重签方式绕过检测。
4. **`e()` 把 debuggable 编码成 bit 0**，而官方两个包都是 `debuggable=true`——是否因此触发拦截页，取决于 Haxe 侧如何比较，本报告不下结论。

---

## 5. 限制

- 反编译产物不是原始源码：局部变量名、行号、部分控制流都会被重写。
- `r-1.0.0` 反编译时有 2 个类报错（jadx 日志 `ERROR - finished with errors, count: 2`），未逐一排查，不影响本文结论。
- Haxe 侧（`Qz7r.hx`）是 native 代码，仍无法静态还原比较逻辑。
