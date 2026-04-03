#Requires AutoHotkey v2.0

;这个脚本实现CapLocks和Space的Leader快捷键功能。
;
;实现逻辑：
;1.当按下CapLocks或Space时，进入Leader模式。
;2.在释放Leader键的时候，根据在Leader模式下输入的其他键来执行不同的操作。
;3.如果在Leader模式下没有输入其他键，直接发送Leader键的原始功能。
;4.在Leader模式下，按下的其他键会被记录下来，并在释放Leader键时根据记录的键来执行对应的操作。
;5.在Leader模式下，按下的其他键会在小框中提示当前的Leader键和输入的其他键。

;定义Leader键和Leader键的触发状态
Leader1 := "CapsLock"
Leader2 := "Space"
Leader1Active := false
Leader2Active := false
LeaderTimeout := 500 ; Leader模式的超时时间，单位为毫秒
;定义Leader时间内的其他键盘输入
followingKeys := ""

; 首先处理Leader2（Space键）的功能
; Space按键的 按压事件捕捉
$Space::
{
    ;激活Leader2模式
    global Leader2Active
    Leader2Active := true

}
; CapsLock按键的 按压事件捕捉
$CapsLock::
{
    ;激活Leader1模式
    global Leader1Active
    Leader1Active := true
}

; 通用键处理函数，检查Leader2是否激活
KeysHandler(key) {
    global Leader2Active, Leader1Active
    if !Leader2Active && !Leader1Active {
        ; Leader未激活，放行
        Send key
        return
    }
    ; Leader激活，调用处理函数
    LeaderKeyHandler(key)
    ; 小框提示当前Leader键和followingKeys
    if Leader2Active {
        ToolTip "Space: " . followingKeys
    }
    else if Leader1Active {
        ToolTip "CapsLock: " . followingKeys
    }

}

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
$h:: KeysHandler("h")
$i:: KeysHandler("i")
$j:: KeysHandler("j")
$k:: KeysHandler("k")
$l:: KeysHandler("l")
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

; 处理捕捉到的键
LeaderKeyHandler(key) {
    global followingKeys
    ; 如果followingKeys字符串已经包含了这个键，说明是重复按键，不处理
    if InStr(followingKeys, key) {
        return
    }
    ; 将捕捉到的键追加在followingKeys字符串中
    followingKeys .= key
}

; Space释放事件捕捉
$Space Up::
{
    global followingKeys
    global Leader2Active
    if followingKeys != "" {
        do_leader2_logic
    }
    else {
        Send "{Space}"
    }
    followingKeys := "" ; 重置followingKeys字符串
    Leader2Active := false
    ; 关闭小框提示
    ToolTip
}

; CapsLock释放事件捕捉
$CapsLock Up::
{
    global followingKeys
    global Leader1Active
    if followingKeys != "" {
        do_leader1_logic
    }
    else {
        ;Send "{CapsLock}" 没人希望按下CapsLock后又按一次才切换回原来的状态，所以这里不发送CapsLock键了
    }
    followingKeys := "" ; 重置followingKeys字符串
    Leader1Active := false
    ; 关闭小框提示
    ToolTip
}

do_leader2_logic() {
    global followingKeys
    switch (followingKeys) {
        case "f":
            Send "^f"  ; `space-f` 搜文件内容`ctrl-f`
        case "fd":
            Send "^+d"  ; `space-f-d`搜索目录内容 `ctrl-shift-d`
        case "s":
            Send "^s"  ; Ctrl+S 保存
        case "a":
            Send "^a"  ; Ctrl+A 全选
        case "c":
            Send "^c"  ; Ctrl+C 复制
        case "v":
            Send "^v"  ; Ctrl+V 粘贴
        default:
            ; 不匹配，不做任何事
    }
}

do_leader1_logic() {
    global followingKeys
    switch (followingKeys) {
        case "o":
            Send "^o"  ; `caplock-o`打开文件`ctrl-o`
        case "od":
            Send "^+o"  ; `caplock-o-d`打开文件夹`ctrl-shift-o`
        case "fr":
            Send "^+r"  ; `caplock-f-r`设置文件的只读性 `ctrl-shift-r`
        default:
            ; 不匹配，不做任何事
    }
}
