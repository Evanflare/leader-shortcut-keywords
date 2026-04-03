#  快捷键定义

对于文本剪辑器的通用操作，这里制定一些通用的快捷键。

这里有一些约定和概念
## 提前的约定

快捷键使用到了Caplock键并取缔了其原有的功能，另外将`Next track`映射到了原来的 caplock。


快捷键的运行需要依赖 Leader 键模式，使用autohotkey脚本，将【空格】【caplock】设置为两个leader键，另外使用【空格】+ Alt 来代替Alt的长快捷键，映射所有的快捷键。leader快捷键映射的是我自行设计的快捷键语言，需要额外在软件中适配，然后才能使用leader快捷键。

caplock 所负责的功能，大致的含义是 外部操作。
alt所负责的功能，大致含义是 内部操作。 
空格所负责的功能，大致含义是 编辑器内部操作。

在软件中设置的必须是 【控制键组合】+ 1个【明文键】，因为很多软件不支持2个明文键，或多个。
## 软件的外部操作

- `caplock-o`打开文件`ctrl-o`
- `caplock-o-d`打开文件夹`ctrl-shift-o`
- `caplock-f-r`设置文件的只读性 `ctrl-shift-r`

## 编辑器内部操作

- `space-f` 搜文件内容`ctrl-f`
- `space-f-d`搜索目录内容 `ctrl-shift-f`
- `space-s` 保存文件  `ctrl-s`
- `space-a` 选中所有内容  `ctrl-a`
- `space-x` 剪切  `ctrl-x`
- `Space-v`  粘贴 
- `Space-c`  复制  
## 软件的内部操作

alt 如果表示不了的，使用 space-alt 表示。

- `alt-a`打开设置 
	- 这么设置的理由是，alt是菜单展开的控制键，a是首要的字母，那么设置就是alt-a。
- `alt-c`打开命令面板  
	- 理由是alt是菜单的控制键，c是CLI的头字母。
- `space-alt-k-s` 打开快捷键  `ctrl-alt-k`
	- alt是菜单控制，k是键盘，s是快捷的意思。
- 