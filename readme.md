对于文本剪辑器的通用操作，这里制定一些通用的快捷键。

快捷键风格趋向：全面趋向中文小鹤音形双拼首字母。


## 提前的约定

快捷键使用到了capslock键并取缔了其原有的功能，另外将`Next track`映射到了原来的 capslock。


快捷键的运行需要依赖 Leader 键模式，使用autohotkey脚本，将【空格】【capslock】设置为两个leader键，另外使用【空格】+ Alt 来代替Alt的长快捷键，映射所有的快捷键。leader快捷键映射的是我自行设计的快捷键语言，需要额外在软件中适配，然后才能使用leader快捷键。

capslock 所负责的功能，大致的含义是 外部操作，或者命令的执行。
alt所负责的功能，大致含义是 内部操作。 
空格所负责的功能，大致含义是 编辑器内部操作。

在软件中设置的必须是 【控制键组合】+ 1个【明文键】，因为很多软件不支持2个明文键，或多个。
## 软件的外部操作

或者命令的执行。

- `capslock-o`打开文件`ctrl-o`
- `capslock-o-d`打开文件夹`ctrl-shift-o`
- `capslock-f-r`设置文件的只读性 `ctrl-shift-r`
- `capslock-t` 跳到文件（内部搜索并打开）`ctrl-shfit-alt-t`
- `capslock-c` 关闭当前文件编辑视图 `ctrl-F4`
- `capslock-n` 新键文件  `ctrl-n`
- `capslock-w-t`  `capslock-tty` 系统层面打开终端执行命令run “wt.exe”
- `cpaslock-q` 退出软件 `alt-F4`
- `capslock-h` 浏览器标签页历史向前，`capslock-l` 浏览器标签页历史向后 `alt-左``alt-右`
- `capslock-z-j` 打开最近的文件夹，`ctrl-alt-f11`
- `capslock-r-u-n` 执行运行程序的命令
- `capslock-b-u-g` 执行调试程序的命令
- `capslock命令停留模式：wt` 打开window terminal程序
- `capslock命令停留模式: trans` 打开stranslate的主窗口 `ctrl-alt-t`

## 编辑器内部操作

- `space-f` 搜文件内容`ctrl-f`
- `space-f-d`搜索目录内容 `ctrl-shift-f`
- `space-t-h` 替换内容 `ctrl-h`
- `space-f-f-<words>` 查找下一个 子串 `<words>`
- `space-f-jkjkj` 跳转到`[jk]`j是下一个，k是上一个匹配项任意输入,按下触发
- `space-f-f` 查找下一个空格
- `space-s` 保存文件  `ctrl-s`
- `space-a` 选中所有内容  `ctrl-a`
- `space-k-j-h-l` 光标的上下移动
- `space-z-x` 或者`space-z-y`焦点在组视窗的下(右）一个 shift-alt-x
- `space-z-u` 或者`space-z-z`焦点在组视窗的上（左）一个 shift-alt-u
- `space-z-1` 焦点在组1, 等等等等到4就够。ctrl-shift-alt-1 .... 
- `space-f-h` 聚焦搜索历史页面 `ctrl-shift-a`
- `space-l` 聚焦地址栏 `ctrl-l`
- `space-m` 聚焦中部页面 `ctrl-alt-m`
- `space-n` 聚焦到其他非编辑视图 `ctrl-alt-n`
- `space-k` 跳出括号外 `ctrl-shift-k`
- `ctrl-shift-上下左右` 多光标操作`multiCursorModifier` 也可以使用`ctrl-鼠标点击`更灵活添加光标 
- `space-e` 移动到行尾end line `ctrl-shift-e`
- `space-b` 移动到行首begin line `ctrl-shift-b`
- `space-d-d` 删除当前行 `ctrl-shift-d`
- `space-l-c` 清空当前行 先end然后shift home然后delete
- `space-x` 删除当前光标处的字符 `del`
- `space-d-b` 从当前光标删除到行首 通过shift-home等实现
- `space-d-e` 从当前光标删除到行尾 通过shift-home等实现
- `space-c-l-s` 清屏 `ctrl-shift-l`
- `space-shift-g` 移动到文件尾行 `ctrl-end`
- `space-g-g` 移动到文件首行 `ctrl-home`
- `space-g-b` 跳转go back `ctrl-shift-alt-u`
- `space-g-f` 跳转go forward `ctrl-shift-alt-x`
- `space-<number>-<number>- ... ` 到第几行 over
- `space-^\d+j$` 向下跳转几行 `space-^\d+k$` 向上跳转几行 over
>[!tip] 最好开启相对行号
>显示当前行的行号以及附近行的相对行号，方便跳转
- `space-e-r-r` 转到错误提示处 
- `space-o`在下方创建一空行并移动光标到该行 `end enter`
- `space-shift-o` 在上方创建一空行并移动光标到该行 `up end enter`
- `space-上下左右` 移动鼠标 
- `space-c-n`切换中文`space-e-n`切换英文 `ctrl-shift-9` `ctrl-shift-8` 在语言栏选项中配置

> [!todo]+ go back知识
> VS Code 的go back功能依赖于一个名为"**导航历史栈 (Navigation Stack)**"的队列，它按照“后进先出”的顺序记录你的“有效跳转”[](https://www.php.cn/faq/2190134.html)[](https://ask.csdn.net/questions/8967705)[](https://www.php.cn/faq/2255601.html)。只有通过 `Ctrl+Click`、`F12`、`Ctrl+Shift+O`、`Ctrl+P` 搜索跳转等“语义化导航”触发的位置才会被记录
> 
真正的光标历史跳转，需要安装插件，这里任意选择一款：MetaJump
- `space-c-c` 复制到 copyq 复制缓冲区 c 号`ctrl-shift-h`
- `space-c-a` 复制到 copyq 复制缓冲区 a 号
- `space-c-b` 复制到 copyq 复制缓冲区 b 号
- `space-c-d` 复制到 copyq 复制缓冲区 d 号
- `space-v-v` 打开 copyq 剪切板面板 
- `ctrl-c-c` 将选中的内容交给 stranslate 翻译
### 配合MetaJump的快捷键更改

metajump是metago工具中的一个部分，可以被单独安装。

1）跳转到屏幕中的指定字符位置
亮点是，对屏幕中匹配的字符位置进行高亮编码位置，我们输入对应的位置编码即可定位，实现1次定位的效果。
'Alt+/' 输入字符后渲染匹配结果 输入位置编码 光标跳转

2)
## 软件的内部操作

alt 如果表示不了的，使用 space-alt 表示。

- `alt-a`打开设置 
	- 这么设置的理由是，alt是菜单展开的控制键，a是首要的字母，那么设置就是alt-a。
- `alt-c`打开命令面板  
	- 理由是alt是菜单的控制键，c是CLI的头字母。
- `space-alt-k-s` 打开快捷键  `ctrl-alt-k`
	- alt是菜单控制，k是键盘，s是快捷的意思。
- `alt-i` 打开插件面板界面
	- i就是插件 
- `alt-d` 打开工作区目录界面
	- d 就是目录 
- `alt-r` 打开运行测试界面
	- r就是run 
- `alt-n` 新建窗口
	- n new
- `alt-h` 打开历史窗口
### vscode的视图机制

 vscode 内部的编辑器视窗，看起来是一个有多个标签的视窗。 其实那只是其中一个，他可以有多个。
#### 编辑器主视窗
主视窗就是vscode自身一个windows窗口只能提供一个主视窗。
主视窗内部装载的是组视窗，可以有多个组视窗。下图就是四个组窗口，组窗口的特点就是有多个文件编辑视图的标签组成的窗口。
![[file-20260403204853418.png]]
#### 组视窗

组视窗就是几个文件标签所代表的各自文件的编辑视图所共享展示的视窗。
![[file-20260403204139245.png]]

#### 文件编辑视图

文件编辑视图是每个文件独占的，而不是共享的，组视窗是多个文件编辑视图共享的。文件编辑视图还可以分成多个**内容视角**。
![[file-20260403205205916.png|370]]


---

- `alt-l-1` 组视窗有 1列 space-alt-ctrl-1
- `alt-l-2` 组视窗有 2列 space-alt-ctrl-2。
- `alt-l-1` 组视窗有 1行  
- `alt-h-2` 组视窗有 2行 space-alt-shift-2
- `alt-w-g` 组视窗呈网格 4窗, space-alt-ctrl+g
- `alt-u-x` 组视窗向下生，并复制当前的文件编辑视图(双拼字符首字) `space alt ctrl x`
- `alt-u-y` 组视窗向右生，并复制当前的文件编辑视图 space-alt-ctrl-y
- `alt-u-z` space-alt-ctrl-z
- `alt-u-u` space-alt-ctrl-u
- `alt-u-j` uj是视角的意思，内容视角生 同样也是回收视角。space alt ctrl j

- `alt-1` 切换到当前组视图中的第一个编辑视图。 -2 -3 -4是同样的规则，切换到对应的编辑视图。对应的英文命令就是OpenEditorAtIndex1-2-3-4之类的。
- `ctrl-shift-tab` 打开组视窗中当前编辑视图的左标签视图，`ctrl-tab` 打开组视窗中当前编辑视图的右边标签视图 
- `alt-q` 切换到前面用过的视图lasted used。
- `alt-p` 切换到配置文件
- `alt-z` 左栏的显示与关闭 `alt-y` 右栏的显示与关闭 `alt-x` 下栏的显示与关闭 `alt-u` 上栏的显示与关闭
- `space-alt-l-s` 切换light switch 黑白模式 (powertoys快捷键) `ctrl-alt-l`
- `alt-t` 提示，包括参数提示，函数定义预览悬停提示showHover，错误提示
- `alt-F1` 查看声明 `alt-F2`查看定义
- `space-alt-j或者k` 上下滚动屏幕
- `alt-g` 打开和关闭git侧边栏
- `space-alt-q-p` 全屏 `F11`


## 操作系统的内部操作

操作系统的很多操作我们可以复用软件的内部操作的快捷键配置，只需要将alt换成win键，相关意思只是操作对象是操作系统而已。

例如 alt-c 是打开命令行，而可以设置 win-c 变成打开windows终端。可以使用powertoys这样的windows自家开发的工具来来实现。


## 按键分发器

(除了默认的释放触发快捷键Handler)
所有handler都有自己的模式，默认是default是普通的释放触发快捷键，命令停留模式是wait_input,子命令模式是 inner_mode
所有的handler都有自己的handler_id，handler_id为空的时候，输入会依次交给handler处理。当handler_id不为空的时候，只能交给对应的handler处理。

除了默认handler，任何handler不应该修改任何全局变量，只有当前缀匹配的时候才能独揽大权做出修改。
### 子命令模式

对于按压触发发式命令，需要避免与普通释放触发快捷键有前缀冲突。
对于连续按压连续触发式命令，还要求命令触发后不要退出连续触发模式。

对于有特殊操作的快捷键，例如 `space-j-j-j-k-h-l...` 来自由移动的快捷键，通过`space-alt-j-j-j-k-j-k...`来进行滚轮操作的快捷键。
我们让他们定义一个“前缀模式”，来进入子命令模式。一旦匹配就进入该子命令模式，退出键就是`space` 通过`space`的析构检测到处于子命令模式则退出，而不是send space。


### 命令停留模式

命令停留模式也是一种子命令模式，但是多了可以停留(中途释放leader)。

释放leader不会触发快捷键，而是等到再次触发 space并使用的时候检测到处于命令停留模式，久会退出而不是send space。

当前缀匹配的时候，直接进入命令停留模式，然后可以释放leader，然后输入命令，然后通过enter键来触发命令执行，并清空followKeys，但是不退出模式。

当再次触发space的时候，检测到处于wait_input模式，set exit_wait_input_should = true，然后再释放space即可退出命令停留模式。并重设 exit_wait_input_should = false
### space唯一输出

只有当 handler_id followKeys 为空 exit_wait_input_should 为false的时候才会send space

## 原生快捷键拓展

例如win alt这些拥有大量原生快捷键，我们不去影响，但是原生快捷键没法做到长键程，只能做到接一个非控制键，而我们在这之前就只监听，不捕获，如果发现输入了2个非控制键，那么我们就进行捕获！

只针对单控制键，如果出现多控制键则取消捕获。

## 全局快捷键

| 快捷键              | 功能             | 说明                    |
| ---------------- | -------------- | --------------------- |
| `Ctrl + Alt + P` | 暂停 (`Pause`)   | 暂停当前正在运行的线程（如循环）。     |
| `Ctrl + Alt + S` | 挂起 (`Suspend`) | 禁用/启用所有热键和热字符串。       |
| `Ctrl + Alt + R` | 重启 (`Reload`)  | 重新加载整个脚本，重置所有状态。      |
| `Ctrl + Esc`     | 暂停 + 挂起        | 同时暂停线程并禁用热键，实现“紧急停止”。 |
|                  |                |                       |
## 复习测试时间

📋 复习间隔日期表：
[原始日期]  ` 已复习时间2026-4-4`
已延误，更改时间如下：
[+  1天]   `复习时间2026-4-18`
[+  3天]   `复习时间2026-4-21`
[+  7天]   `复习时间2026-4-28`
[+ 15天]   `复习时间2026-5-13`
[+ 30天]   `复习时间2026-6-12`
[+100天]   `复习时间2026-9-20`

1. 至少要知道vscode的视图机制。
2. 我的快捷操作使用了那些控制键？
3. 我有做键盘按键的基本映射吗？
4. 分为了哪几大类？
5. 我最初就是为了只读操作而被吸引花了两天完成这个东西，一定要知道只读的快捷键。
6. 最厉害的其实是 命令行 alt-c 以及 跳转 capslockk-t
7. 打开文件的快捷键是？
8. 