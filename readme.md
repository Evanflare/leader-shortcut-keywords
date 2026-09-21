# leader.ahk

## leader.ahk 是什么？

leader.ahk来源于vim编辑器的leader快捷键灵感。leader.ahk想要实现的是在同样环境下，将leader等快捷键方式便捷的应用到任何场景中。

leader.ahk通过space、capslock作为leader引导键，配合Alt、Ctrl、Shift通用快捷键来覆盖绝对部分的快捷键功能需求。另外有command_wait_input模式，提供自定义快捷命令。

## 为什么使用 leader.ahk?

普通的快捷键，通过控制键引导快捷键，并且是触发式，当有匹配的快捷键立即触发。而leader.ahk的主要快捷键通过space、capslock引导, 是释放式的，当引导键释放才进行快捷键匹配。如此避免可快捷键前缀冲突，可用的快捷键极大提升。

leader.ahk还提供了handler机制，能自定义快捷键匹配项。从而实现space-hjkl映射上下左右，就像vim一样的操


    
ledaer.ahk极大丰富了快捷键的形式，使得快捷键可以语义化定制，解决记不住快捷键的问题。

## 如何自定义 快捷

具体请见 [架构介绍](doc/架构介绍.md)。

## 如何使用leader.ahk？

请见 [使用文档](doc/使用文档.md)。
