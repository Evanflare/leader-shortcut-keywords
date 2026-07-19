#Requires AutoHotkey v2.0

#Include ../leader.ahk
#Include key_handler_dispatcher.ahk
; 全局监听win键，在win按下后避免启用Leader捕获，避免影响原生 win 快捷键
winKeyState := false
; 定时器在win键松开300ms之后重置winKeyState状态，避免误触发
~$LWin::
{
    global winKeyState
    winKeyState := true

}
~$LWin Up:: {
    global winKeyState
    SetTimer(ResetWinKeyState, -300)
}
ResetWinKeyState() {
    global winKeyState
    winKeyState := false
}
; 全局监听alt键，在alt按下后避免启用Leader捕获，避免影响原生 alt 快捷键
altKeyState := false
; 定时器在win键松开300ms之后重置winKeyState状态，避免误触发
~$LAlt::
{
    global altKeyState
    altKeyState := true

}
~$LAlt Up:: {
    global altKeyState
    ResetAltKeyState()
}

ResetAltKeyState() {
    global altKeyState
    altKeyState := false
}
; 只有在 win与alt 键没有按下的时候才捕捉下面的键
#HotIf !winKeyState && !altKeyState
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
#HotIf ; 结束条件热键的定义

; Space释放事件捕捉
$Space Up::
{
    ; 先判断是否处于wait_input模式，如果是，则不执行释放事件，等待下一次输入
    global handler_mode, handler_id
    ; 如果在wait_input模式，触发非启动键的释放事件，不做任何事情。
    if handler_mode == "wait_input" && handler_id != "space_wait_input" {
        return
    }
    global followingKeys
    if followingKeys != "" {
        space_up_handler
    }
    else {
        if !winKeyState && followingControlKeys == "" && handler_mode == "default" {  ; 如果Win键没有被按下，发送Space键
            Send "{Space}"
        }
    }
    LeaderDestructor() ; 调用析构函数，重置状态和执行命令
    ; TODO: 这里潜藏了bug，如果同时按下两个Leader键，比如先按下Space，再按下CapsLock，然后释放Space，这时候会执行Leader2的命令，但是Leader1的状态没有被重置，导致后续的CapsLock释放会执行两次命令，所以这里我们需要在释放Space的时候重置SpaceActive状态，避免这个问题。
    ; 关闭小框提示
    ToolTip
}

; CapsLock释放事件捕捉
$CapsLock Up::
{
    OutputDebug("进入CapsLock Up处理函数")
    ; 先判断是否处于wait_input模式，如果是，则不执行释放事件，等待下一次输入
    global handler_mode, handler_id
    OutputDebug("handler_mode: " . handler_mode . ", handler_id: " . handler_id)
    ; 如果在wait_input模式，触发非启动键的释放事件，不做任何事情。
    if handler_mode == "wait_input" && handler_id != "capslock_wait_input" {
        OutputDebug("处于wait_input模式，且handler_id不为capslock_wait_input，直接返回")
        return
    }
    OutputDebug("调用caps_lock_up_handler函数")
    caps_lock_up_handler
    OutputDebug("调用LeaderDestructor函数")
    LeaderDestructor() ; 调用析构函数，重置状态和执行命令
    OutputDebug("退出CapsLock Up处理函数")
    ; TODO: 这里潜藏了bug，如果同时按下两个Leader键，比如先按下Space，再按下CapsLock，然后释放CapsLock，这时候会执行Leader1的命令，但是Leader2的状态没有被重置，导致后续的Space释放会执行两次命令，所以这里我们需要在释放CapsLock的时候重置CapsActive状态，避免这个问题。
}

; Leader键释放时触发的析构函数，用于重置状态和执行命令
LeaderDestructor() {
    OutputDebug("进入LeaderDestructor函数")
    global SpaceActive, CapsActive, followingKeys, followingControlKeys, handler_id, handler_mode,
        exit_wait_input_should
    ; 需要特殊判断是否为命令停留模式
    if handler_mode == "wait_input" {
        OutputDebug("进入wait_input分支")
        if exit_wait_input_should {
            OutputDebug("进入exit_wait_input_should分支=true")
            ; 重置状态
            followingControlKeys := "" ; 重置followingControlKeys字符串
            followingKeys := "" ; 重置followingKeys字符串
            handler_id := "default" ; 重置handler_id为default
            SpaceActive := false
            CapsActive := false
            handler_mode := "default"
            exit_wait_input_should := false
            ;重置提示窗
            ToolTip
        } else {
            ; 这次不退出，下次再退出
            exit_wait_input_should := true
        }
    } else {
        OutputDebug("进入非wait_input分支")
        handler_mode := "default"
        ; 重置状态
        followingControlKeys := "" ; 重置followingControlKeys字符串
        followingKeys := "" ; 重置followingKeys字符串
        handler_id := "default" ; 重置handler_id为空
        SpaceActive := false
        CapsActive := false
        ;重置提示窗
        ToolTip
    }
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

;  捕捉Alt键
$LAlt:: ControlKeysHandler("Alt")  ; 捕捉Alt键，传入当前热键作为参数
$RAlt:: ControlKeysHandler("Alt")
; 捕捉Shift键
$LShift:: ControlKeysHandler("Shift")  ; 捕捉Shift键，传入当前热键作为参数
$RShift:: ControlKeysHandler("Shift")

#HotIf  ; 结束条件热键的定义
