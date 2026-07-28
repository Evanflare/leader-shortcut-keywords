#Requires AutoHotkey v2.0

#Include ../leader.ahk
#Include key_handler_dispatcher.ahk
#Include command_end_parser.ahk
#Include action/record_send.ahk
; 全局监听win键，在win按下后避免启用Leader捕获，避免影响原生 win 快捷键
leader_hook_flag := true
; 定时器在win键松开300ms之后重置leader_hook_flag状态，避免误触发
~$LWin::
{
    global leader_hook_flag
    leader_hook_flag := false
}
~$LWin Up:: {
    SetTimer(reset_leader_hook_flag, -500)
}
reset_leader_hook_flag() {
    global leader_hook_flag
    leader_hook_flag := true
}
; 全局监听alt键，在alt按下后避免启用Leader捕获，避免影响原生 alt 快捷键
; 定时器在win键松开300ms之后重置leader_hook_flag状态，避免误触发
~$LAlt::
{
    global leader_hook_flag
    leader_hook_flag := false
}
~$LAlt Up:: {
    reset_leader_hook_flag()
}
; 只有在 win与alt 键没有按下的时候才捕捉下面的键
#HotIf leader_hook_flag
; Space按键的 按压事件捕捉
$Space::
{
    if handler_mode == "wait_input" {
        if handler_id != "space_wait_input" {
            ; 作为普通键入处理
            dispatcher(" ")  ; 发送空格键
        }
    } else {
        ;激活Space模式
        global SpaceActive, CapsActive
        CapsActive := false
        SpaceActive := true
    }
    input_keys_tip_dialog
}
; CapsLock按键的 按压事件捕捉
$CapsLock::
{
    if handler_mode == "wait_input" {
        if handler_id != "capslock_wait_input" {
            ; 作为普通键入处理
            ; capslock 键入视为空格
            dispatcher(" ")  ; 发送空格键
        }
    } else {
        ;激活CapsLock模式
        global SpaceActive, CapsActive
        SpaceActive := false
        CapsActive := true
    }
    input_keys_tip_dialog
}
; Space释放事件捕捉
$Space Up::
{
    leader_release_handler "space"
}

; CapsLock释放事件捕捉
$CapsLock Up::
{
    leader_release_handler "capslock"
}
#HotIf ; 结束条件热键的定义

; leader键释放事件处理
leader_release_handler(leader_name) {
    OutputDebug "进入leader_release_handler函数"
    if leader_name == "space" {
        OutputDebug "进入space up事件捕获分支"
        global followingKeys
        if followingKeys != "" {
            OutputDebug "调用 space_command_parser"
            space_command_parser
        }
        else {
            if followingControlKeys == "" && handler_mode == "default" {  ;送Space键
                record_and_send "{Space}"
            }
        }
        ; TODO: 这里潜藏了bug，如果同时按下两个Leader键，比如先按下Space，再按下CapsLock，然后释放Space，这时候会执行Leader2的命令，但是Leader1的状态没有被重置，导致后续的CapsLock释放会执行两次命令，所以这里我们需要在释放Space的时候重置SpaceActive状态，避免这个问题。
        OutputDebug "退出space up事件捕获分支"
    } else if leader_name == "capslock" {
        OutputDebug("进入CapsLock Up处理分支")
        OutputDebug("调用 capslock_command_parser 函数")
        capslock_command_parser
        OutputDebug("退出CapsLock Up处理分支")
        ; TODO: 这里潜藏了bug，如果同时按下两个Leader键，比如先按下Space，再按下CapsLock，然后释放CapsLock，这时候会执行Leader1的命令，但是Leader2的状态没有被重置，导致后续的Space释放会执行两次命令，所以这里我们需要在释放CapsLock的时候重置CapsActive状态，避免这个问题。
    }
    OutputDebug("调用LeaderDestructor函数")
    LeaderDestructor() ; 调用析构函数，重置状态和执行命令
    OutputDebug "退出 leader_release_handler 函数"
    return
}
; Leader键释放时触发的析构函数，用于重置状态和执行命令
LeaderDestructor() {
    OutputDebug("进入 LeaderDestructor 函数")
    global SpaceActive, CapsActive, followingKeys, followingControlKeys, handler_id, handler_mode,
        exit_wait_input_should
    handler_mode := "default"
    ; 重置状态
    followingControlKeys := "" ; 重置followingControlKeys字符串
    followingKeys := "" ; 重置followingKeys字符串
    handler_id := "" ; 重置handler_id为空
    SpaceActive := false
    CapsActive := false
    ;重置提示窗
    ToolTip
    OutputDebug("退出LeaderDestructor函数")
}
; 只有在Leader模式激活时才捕捉下面的键
#HotIf CapsActive || SpaceActive
; Leader模式下对键盘的0-9键,a-z键的捕捉
; 捕捉0-9键
$0:: dispatcher("0")
$1:: dispatcher("1")
$2:: dispatcher("2")
$3:: dispatcher("3")
$4:: dispatcher("4")
$5:: dispatcher("5")
$6:: dispatcher("6")
$7:: dispatcher("7")
$8:: dispatcher("8")
$9:: dispatcher("9")
; 捕捉a-z键
$a:: dispatcher("a")
$b:: dispatcher("b")
$c:: dispatcher("c")
$d:: dispatcher("d")
$e:: dispatcher("e")
$f:: dispatcher("f")
$g:: dispatcher("g")
$h:: dispatcher("h")  ; hjkl键的特殊处理，调用leaderMoveKeyHandler函数
$i:: dispatcher("i")
$j:: dispatcher("j")   ; hjkl键的特殊处理，调用leaderMoveKeyHandler函数
$k:: dispatcher("k")   ; hjkl键的特殊处理，调用leaderMoveKeyHandler函数
$l:: dispatcher("l")   ; hjkl键的特殊处理，调用leaderMoveKeyHandler函数
$m:: dispatcher("m")
$n:: dispatcher("n")
$o:: dispatcher("o")
$p:: dispatcher("p")
$q:: dispatcher("q")
$r:: dispatcher("r")
$s:: dispatcher("s")
$t:: dispatcher("t")
$u:: dispatcher("u")
$v:: dispatcher("v")
$w:: dispatcher("w")
$x:: dispatcher("x")
$y:: dispatcher("y")
$z:: dispatcher("z")
$BackSpace:: dispatcher("BackSpace")
$`:: dispatcher("``")
;  捕捉Alt键
$LAlt:: ControlKeysHandler("Alt")  ; 捕捉Alt键，传入当前热键作为参数
$RAlt:: ControlKeysHandler("Alt")
; 捕捉Shift键
$LShift:: ControlKeysHandler("Shift")  ; 捕捉Shift键，传入当前热键作为参数
$RShift:: ControlKeysHandler("Shift")

#HotIf  ; 结束条件热键的定义

wait_input_hook_flag := false

#HotIf wait_input_hook_flag
; CapsLock按键 up 事件捕获
$CapsLock Up::
{
    OutputDebug "进入 wait_input 模式下的 capslock up 事件处理"
    OutputDebug "发送 enter"
    ; wait_input模式下，capslock变成“enter”键
    record_and_send "{Enter}"
    OutputDebug "退出 wait_input 模式下的 capslock up 事件处理"
}
#HotIf