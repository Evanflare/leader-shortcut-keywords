#Requires AutoHotkey v2.0

;这个脚本实现CapLocks和Space的Leader快捷键功能。
;
;实现逻辑：
;1.当按下CapLocks或Space时，进入Leader模式。
;2.在释放Leader键的时候，根据在Leader模式下输入的其他键来执行不同的操作。
;3.如果在Leader模式下没有输入其他键，直接发送Leader键的原始功能。
;4.在Leader模式下，按下的其他键会被记录下来，并在释放Leader键时根据记录的键来执行对应的操作。
;5.在Leader模式下，按下的其他键会在小框中提示当前的Leader键和输入的其他键。

#Include libs\hjkl_move.ahk ; 包含hjkl_move.ahk文件，提供基于hjkl键的移动功能

;定义Leader键和Leader键的触发状态
Leader1 := "CapsLock"
Leader2 := "Space"
Leader1Active := false
Leader2Active := false
LeaderTimeout := 500 ; Leader模式的超时时间，单位为毫秒
;存储Leader时间内的其他键盘输入
followingKeys := ""
followingControlKeys := "" ; 存储Leader时间内的控制键输入，比如Alt键

; 首先处理Leader2（Space键）的功能
; Space按键的 按压事件捕捉
$Space::
{
    ;激活Leader2模式
    global Leader2Active
    Leader2Active := true
    followingKeys := "" ; 重置followingKeys字符串
    ToolTip "Space: " ; 显示小框提示，初始状态只显示Leader键
}
; CapsLock按键的 按压事件捕捉
$CapsLock::
{
    ;激活Leader1模式
    global Leader1Active
    Leader1Active := true
    followingKeys := "" ; 重置followingKeys字符串
    ToolTip "CapsLock: " ; 显示小框提示，初始状态只显示Leader键
}

; 通用键处理函数，检查Leader是否激活
KeysHandler(key) {
    global Leader2Active, Leader1Active
    ; Leader激活，调用处理函数
    LeaderTimeKeyDownHandler(key)
    ; 小框提示当前Leader键和followingKeys
    if Leader2Active {
        ToolTip "Space: " . followingControlKeys . followingKeys
    }
    else if Leader1Active {
        ToolTip "CapsLock: " . followingControlKeys . followingKeys
    }

}
; 控制键的处理函数，检查Leader是否激活
ControlKeysHandler(key) {
    global Leader2Active, Leader1Active
    ; 这里的key是类似于ThisHotkey的字符串，比如"$LAlt"，我们需要把前面的"$"去掉，得到"LAlt"
    key := SubStr(key, 2) ; 去掉前面的"$"
    ; Leader激活，调用处理函数
    LeaderTimeControlKeyDownHandler(key)
    ; 小框提示当前Leader键和followingKeys
    if Leader2Active {
        ToolTip "Space: " . followingControlKeys . followingKeys
    }
    else if Leader1Active {
        ToolTip "CapsLock: " . followingControlKeys . followingKeys
    }

}

#HotIf Leader2Active || Leader1Active  ; 只有在Leader模式激活时才捕捉下面的键
; Leader模式下对键盘的0-9键,a-z键的捕捉
; 捕捉0-9键
$0:: KeysHandler("0")
$1:: KeysHandler("1")
$2:: KeysHandler("2")
$3:: KeysHandler("3")
$4:: KeysHandler("4")
$5:: KeysHandler("5")
$6:: KeysHandler("6")
$7:: KeysHandler("7")
$8:: KeysHandler("8")
$9:: KeysHandler("9")
; 捕捉a-z键
$a:: KeysHandler("a")
$b:: KeysHandler("b")
$c:: KeysHandler("c")
$d:: KeysHandler("d")
$e:: KeysHandler("e")
$f:: KeysHandler("f")
$g:: KeysHandler("g")
$h:: leaderMoveKeyHandler("h", followingKeys)  ; hjkl键的特殊处理，调用leaderMoveKeyHandler函数
$i:: KeysHandler("i")
$j:: leaderMoveKeyHandler("j", followingKeys)   ; hjkl键的特殊处理，调用leaderMoveKeyHandler函数
$k:: leaderMoveKeyHandler("k", followingKeys)   ; hjkl键的特殊处理，调用leaderMoveKeyHandler函数
$l:: leaderMoveKeyHandler("l", followingKeys)   ; hjkl键的特殊处理，调用leaderMoveKeyHandler函数
$m:: KeysHandler("m")
$n:: KeysHandler("n")
$o:: KeysHandler("o")
$p:: KeysHandler("p")
$q:: KeysHandler("q")
$r:: KeysHandler("r")
$s:: KeysHandler("s")
$t:: KeysHandler("t")
$u:: KeysHandler("u")
$v:: KeysHandler("v")
$w:: KeysHandler("w")
$x:: KeysHandler("x")
$y:: KeysHandler("y")
$z:: KeysHandler("z")

;  捕捉Alt键
$LAlt:: ControlKeysHandler(THisHotkey)  ; 捕捉左Alt键，传入当前热键作为参数
$RAlt:: ControlKeysHandler(THisHotkey)

#HotIf  ; 结束条件热键的定义

; 全模式监听win键，解决win+Space切换输入法误发Space的问题
winKeyState := false
; 定时器在win键松开300ms之后重置winKeyState状态，避免误触发
~$LWin::
{
    global winKeyState
    winKeyState := true
    SetTimer ResetWinKeyState, -300
}

ResetWinKeyState() {
    global winKeyState
    winKeyState := false
}

; 处理Leader模式下捕捉到的键
LeaderTimeKeyDownHandler(key) {
    global followingKeys
    ; 如果followingKeys字符串已经包含了这个键，说明是重复按键，不处理
    ;    if InStr(followingKeys, key) {
    ;        return
    ;    } else {
    ;        ; 将捕捉到的键追加在followingKeys字符串中
    ;        followingKeys .= key
    ;    }
    ; 这里控制键我们不去重，因为有些组合快捷键是需要同时按下多个控制键的，比如 space-t-t-y，所以我们允许重复按下控制键，直接追加就行了
    followingKeys .= key
}
LeaderTimeControlKeyDownHandler(key) {
    global followingControlKeys
    ; 如果followingControlKeys字符串已经包含了这个键，说明是重复按键，不处理
    if InStr(followingControlKeys, key) {
        return
    } else {
        ; 将捕捉到的控制键追加在followingControlKeys字符串中
        followingControlKeys .= key
    }

}

; Space释放事件捕捉
$Space Up::
{
    global followingKeys, followingControlKeys, Leader2Active
    if followingKeys != "" {
        do_leader2_logic
    }
    else {
        if !winKeyState {  ; 如果Win键没有被按下，发送Space键
            Send "{Space}"
        }
    }
    followingKeys := "" ; 重置followingKeys字符串
    followingControlKeys := "" ; 重置followingControlKeys字符串
    Leader2Active := false
    ; 关闭小框提示
    ToolTip
}

; CapsLock释放事件捕捉
$CapsLock Up::
{
    global followingKeys, followingControlKeys, Leader1Active
    if followingKeys != "" {
        do_leader1_logic
    }
    else {
        ;Send "{CapsLock}" 没人希望按下CapsLock后又按一次才切换回原来的状态，所以这里不发送CapsLock键了
    }
    followingKeys := "" ; 重置followingKeys字符串
    followingControlKeys := "" ; 重置followingControlKeys字符串
    Leader1Active := false
    ; 关闭小框提示
    ToolTip
}

do_leader2_logic() {
    global followingKeys, followingControlKeys
    shortcutKeywords := followingControlKeys . followingKeys ; 将控制键和普通键合并成一个字符串，方便后续的switch判断
    switch (shortcutKeywords) {
        case "f":
            Send "^f"  ; `space-f` 搜文件内容`ctrl-f`
        case "fd":
            Send "^+f"  ; `space-f-d`搜索目录内容 `ctrl-shift-f`
        case "fh":
            Send "^+a" ; `space-f-h`搜索文件路径 `ctrl-shift-a`
        case "l":
            Send "^l"  ; `space-l` 聚焦到地址栏 `ctrl-l`
        case "m":
            Send "^!m"  ; `space-m` 聚焦中部页面 `ctrl-alt-m`
        case "s":
            Send "^s"  ; Ctrl+S 保存
        case "a":
            Send "^a"  ; Ctrl+A 全选
        case "c":
            Send "^c"  ; Ctrl+C 复制
        case "v":
            Send "^v"  ; Ctrl+V 粘贴
        case "x":
            Send "^x"  ; Ctrl+X 剪切
        case "ju":
            Send "^+!u"  ; `space-j-u`焦点的上个和下个 `ctrl-shift-alt-u`
        case "jx":
            Send "^+!x"  ; `space-j-x`焦点的上个和下个 `ctrl-shift-alt-x`
        case "zx":
            Send "+!x" ; `space-z-x`焦点在组视窗的下一个 `shift-alt-x`
        case "zy":
            Send "+!y" ; `space-z-y`焦点在组视窗的下一个 `shift-alt-y`
        case "zu":
            Send "+!u"  ; `space-z-u`焦点在组视窗的上一个 `shift-alt-u`
        case "zz":
            Send "+!z"  ; `space-z-z`焦点在组视窗的上一个 `shift-alt-z`
        case "z1":
            Send "^+!1"  ; `space-z-1`焦点在组1 `ctrl-shift-alt-1`
        case "z2":
            Send "^+!2"  ; `space-z-2`焦点在组2 `ctrl-shift-alt-2`
        case "z3":
            Send "^+!3"  ; `space-z-3`焦点在组3 `ctrl-shift-alt-3`
        case "z4":
            Send "^+!4"  ; `space-z-4`焦点在组4 `ctrl-shift-alt-4`
        case "tty":
            Run "wt.exe"  ; `space-t-t-y`打开终端 `space-t-t`是打开终端的前缀，y是terminal的第二个字母
        case "wt":
            ; 打开终端的命令是%LocalAppData%\Microsoft\WindowsApps\wt.exe，所以我们直接运行这个命令就可以了
            Run "wt.exe"  ; `space-t-t-y`打开终端 `space-t-t`是打开终端的前缀，l是terminal的第一个字母

            ; 下面是 Space+Alt 组合键的处理
        case "LAltks":
            Send "^!k"  ; `space-alt-k`打开快捷键页面 `ctrl-alt-k`
        case "RAltks":
            Send "^!k"  ; `space-alt-k`打开快捷键页面 `ctrl-alt-k`
            ; 下面是视角切换的处理
        case "LAltl1":
            Send "^!1"  ; `space-alt-l-1`组视窗有 1列 `ctrl-alt-1`
        case "LAltl2":
            Send "^!2"  ;   `space-alt-l-2`组视窗有 2列 `ctrl-alt-2`
        case "LAlth2":
            Send "+!2"  ; `space-alt-h-2`组视窗有 2行 `shift-alt-2`
        case "LAlth1":
            Send "^!1"  ; `space-alt-h-1`组视窗有 1行 `ctrl-alt-1`
        case "LAltwg":
            Send "^!g"  ; `space-alt-w-g`组视窗呈网格 4窗 `ctrl-alt-g`
        case "LAltux":
            Send "^!x"  ; `space-alt-u-x`组视窗向下生，并复制当前的文件编辑视图 `ctrl-alt-x`
        case "LAltuy":
            Send "^!y"  ; `space-alt-u-y`组视窗向右生，并复制当前的文件编辑视图 `ctrl-alt-y`
        case "LAltuz":
            Send "^!z"  ; `space-alt-u-z` `ctrl-alt-z`
        case "LAltu":
            Send "^!u"  ; `space-alt-u` `ctrl-alt-u`
        case "LAltuj":
            Send "^!j"  ; `space-alt-u-j`视角的意思，内容视角生 同样也是回收视角 `ctrl-alt-j`
        default:
            ; 不匹配，小小提示音
            SoundPlay("*-1")
    }
}

do_leader1_logic() {
    global followingKeys, followingControlKeys
    shortcutKeywords := followingControlKeys . followingKeys ; 将控制键和普通键合并成一个字符串，方便后续的switch判断
    switch (shortcutKeywords) {
        case "o":
            Send "^o"  ; `caplock-o`打开文件`ctrl-o`
        case "od":
            Send "^+o"  ; `caplock-o-d`打开文件夹`ctrl-shift-o`
        case "fr":
            Send "^+r"  ; `caplock-f-r`设置文件的只读性 `ctrl-shift-r`
        case "t":
            Send "^+!t"        ;`caplock-t` 跳到文件（内部搜索并打开）ctrl-shfit-alt-t
        case "c":
            Send "^{F4}"  ; `caplock-c` 关闭当前文件 `ctrl-F4`
        case "n":
            Send "^n"  ; `caplock-n` 新建文件 `ctrl-n`
        default:
            ; 不匹配，小小提示音
            SoundPlay("*-1")
    }
}
