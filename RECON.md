# 源码结构还原

不靠版本号，不靠字符串猜。这一份是从编译产物里把**类与方法**的结构还原出来，再和上游 1.0 的源码逐类对齐。

---

## 方法

| 步骤 | 做法 |
|---|---|
| 取上游 | `git clone --depth 1 --branch 1.0 --filter=blob:none --sparse`，只检出 `source/`，得 154 个 `.hx` |
| 取本地 | 从 `libApplicationMain.so` 的 `.rodata` 提取全部 `Class.method` 形式符号 |
| 对齐 | 类名取文件路径（`objects/Alphabet.hx` → `objects.Alphabet`），方法名取 `function` 声明 |
| 双向差集 | 上游有、二进制没有 = 删；二进制有、上游没有 = 加 |
| 过滤 | 剔除 `get_*`/`set_*`/`__default_*`——这些是 hxcpp 为 `var x(get,set)` 自动生成的访问器，不是人写的 |
| Java 层 | jadx 1.5.1，参数 `-Xmx448m -XX:+UseSerialGC -cp jadx-all.jar jadx.cli.JadxCLI` |

**为什么可信**：hxcpp 会把每个类的方法表写进二进制的只读段，是编译产物，不是注释或调试信息。要抹掉得 strip 或改符号，普通构建不会做。

---

## 全局

```
参与比对的类      134
方法命中率中位数   100%
命中率 ≥95% 的类   96   （即基本原封不动）
删除方法总数       188
新增方法总数       500
```

也就是说，**这个引擎绝大部分源码是原版**，改动集中在十来个类里。

---

## 改动最大的类

| 文件 | 删除 | 新增 |
|---|---|---|
| `states/PlayState.hx` | 4 | **123** |
| `states/MainMenuState.hx` | 0 | **44** |
| `unused/Snd.hx` | 40 | 0 |
| `states/FreeplayState.hx` | 0 | 29 |
| `debug/FPSCounter.hx` | 0 | 23 |
| `states/StoryMenuState.hx` | 0 | 23 |
| `objects/VideoSprite.hx` | 0 | 22 |
| `states/stages/Template.hx` | 18 | 0 |
| `unused/SndTV.hx` | 18 | 0 |
| `states/editors/StageEditorState.hx` | 16 | 1 |
| `backend/Achievements.hx` | 0 | 15 |
| `states/editors/ChartingState.hx` | 8 | 8 |

### 加在 PlayState 里的 123 个方法（节选）

```
addCustomFCBadge, addCustomRank, addCustomRating, addHealthIconBand
addNoteLane, applyNoteLane, buildDefaultRanks
callOnGameplayScripts, callOnJS
```

对应 `backend/FCBadge.hx`、`backend/ScoreRank.hx`、`backend/Rating.hx`、`backend/NoteLanes.hx` 这几个新文件——**他的"自定义功能"主要堆在 PlayState 上**。

### 加在三个菜单里的（44 + 29 + 23）

```
MainMenuState:     addMenuItem, addMenuItemGraphic, addScriptButton, gestureTapAllowed, confirmSelection …
FreeplayState:     addScriptButton, confirmSong, getSongCharacterAt, _updateSongLastDifficulty …
StoryMenuState:    addScriptButton, confirmWeek, getWeekIdAt, storySetWeekIcon …
```

三个菜单都有 `addScriptButton` 和 `boot` —— 这就是他把菜单改成"可脚本化"的那部分，对应 `backend/MenuUI.hx`、`MenuNav.hx`、`MenuGestures.hx`。

### 删掉的 188 个方法集中在哪

| 位置 | 说明 |
|---|---|
| `unused/Snd.hx`（40）、`unused/SndTV.hx`（18） | 上游本来就放在 `unused/`，不参与构建，属正常清理 |
| `states/stages/Template.hx`（18） | 舞台模板，普通玩家用不到 |
| `states/editors/StageEditorState.hx`（16） | 舞台编辑器被重构，`loadSprite`、`playAnim`、`saveFile` 等被替换 |
| `psychlua/*` 全部 | Lua 体系，前文已述 |
| `shaders/WiggleEffect.hx`（7） | 摆动效果，连带 `OverlayShader`、`BlendModeEffect` 一起移除 |

---

## 自建 API 清单

README 里有一句："你们连自定义 API 都没找到，拿 `strings` 玩玩就写假报告。"

那就列出来。从随包的两份示例脚本（`demo.js`、`menu_demo.js`）里提取被调用的函数名，减去 219 个继承自 Lua 的名字，再确认在二进制里存在：

**104 个**，分七组。

| 分组 | 数量 | 代表 |
|---|---|---|
| 菜单对象 | 48 | `addMenuItem`、`addMenuText`、`addMenuImage`、`setMenuItemState`、`attachMenuObject`、`replaceMenuObject`、`setMenuObjectDraggable` |
| 自定义页面 | 9 | `pageOpen`、`pageAddItem`、`pageSetState`、`pageTitle`、`pageBack` |
| 故事模式 | 12 | `storySetWeekIcon`、`storySetWeekState`、`storyGetWeekCount`、`storySetWeekURL` |
| 自由模式 | 12 | `freeplaySetSongIcon`、`freeplayPlaySong`、`freeplayGetSongCount`、`freeplaySetSongState` |
| 文件 | 7 | `readFile`、`writeFile`、`appendFile`、`listFiles`、`resolvePath` |
| 视频 | 2 | `startMenuVideo`、`stopMenuVideo` |
| 其他 | 14 | `changeWeek`、`exitToTitle`、`getAllSongs`、`getDifficultyList`、`getWeekCount` |

完整名单见 [`../evidence/1.1/custom-api.txt`](../evidence/1.1/custom-api.txt)。

这些确实是他写的，也确实在包里。之前的报告里提到了 `FunkinJS` 的 8 组 `register*` 方法，但没有逐个列名单——这次补齐。

---

## 限制

1. **方法名 ≠ 实现**。这份文档能说明"哪个类被改过、加了什么方法"，不能说明"这个方法怎么写的"。要看实现得反汇编原生代码。
2. **缺失可能是内联**。Haxe 会把短方法内联，符号就不产生了，所以"删除"的 188 个里可能混有少量误判。
3. **Java 层已通过 jadx 反编译**（122 个类）。此前失败的原因是本机可用内存仅 0.9GB，而默认 `-Xmx2g` 直接触发换页被终止；改用 `-Xmx448m` 并把入口指定为 `jadx.cli.JadxCLI` 后 8 秒完成。反编译产物见 `evidence/1.1/java/`。
4. **`.so` 无 `.symtab`**（已 strip），只有 2648 个 `.dynsym` 条目，且不含 Haxe 符号。所以无法按地址反汇编指定方法，只能靠 `.rodata` 的字符串还原结构。
