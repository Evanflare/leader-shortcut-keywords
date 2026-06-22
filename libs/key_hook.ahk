#Requires AutoHotkey v2.0

#Include ../leader.ahk

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
    ;激活Space模式
    global CapsActive, SpaceActive
    CapsActive := false
    SpaceActive := true
    followingKeys := "" ; 重置followingKeys字符串
    ToolTip "Space: " ; 显示小框提示，初始状态只显示Leader键
}
; CapsLock按键的 按压事件捕捉
$CapsLock::
{
    ;激活CapsLock模式
    global SpaceActive, CapsActive
    SpaceActive := false
    CapsActive := true
    followingKeys := "" ; 重置followingKeys字符串
    ToolTip "CapsLock: " ; 显示小框提示，初始状态只显示Leader键
}
#HotIf ; 结束条件热键的定义

; Space释放事件捕捉
$Space Up::
{
    global followingKeys
    if followingKeys != "" {
        space_hotkey_handler
    }
    else {
        if !winKeyState {  ; 如果Win键没有被按下，发送Space键
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
    global followingKeys
    if followingKeys != "" {
        caps_lock_hotkey_handler
    }
    else {
        ;Send "{CapsLock}" 没人希望按下CapsLock后又按一次才切换回原来的状态，所以这里不发送CapsLock键了
    }
    LeaderDestructor() ; 调用析构函数，重置状态和执行命令
    ; TODO: 这里潜藏了bug，如果同时按下两个Leader键，比如先按下Space，再按下CapsLock，然后释放CapsLock，这时候会执行Leader1的命令，但是Leader2的状态没有被重置，导致后续的Space释放会执行两次命令，所以这里我们需要在释放CapsLock的时候重置CapsActive状态，避免这个问题。
    ; 关闭小框提示
    ToolTip
}

; 只有在Leader模式激活时才捕捉下面的键
#HotIf CapsActive || SpaceActive
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
$h:: leaderMoveKeyHandler("h")  ; hjkl键的特殊处理，调用leaderMoveKeyHandler函数
$i:: KeysHandler("i")
$j:: leaderMoveKeyHandler("j")   ; hjkl键的特殊处理，调用leaderMoveKeyHandler函数
$k:: leaderMoveKeyHandler("k")   ; hjkl键的特殊处理，调用leaderMoveKeyHandler函数
$l:: leaderMoveKeyHandler("l")   ; hjkl键的特殊处理，调用leaderMoveKeyHandler函数
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
$LAlt:: ControlKeysHandler(THisHotkey)  ; 捕捉Alt键，传入当前热键作为参数
$RAlt:: ControlKeysHandler(THisHotkey)
; 捕捉Shift键
$LShift:: ControlKeysHandler(THisHotkey)  ; 捕捉Shift键，传入当前热键作为参数
$RShift:: ControlKeysHandler(THisHotkey)

#HotIf  ; 结束条件热键的定义
