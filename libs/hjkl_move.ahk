#Requires AutoHotkey v2.0

; 这是一个库文件，提供了基于hjkl键的移动功能。

#Include ..\leader.ahk

; 当命令状态为空的时候，输入hjkl键进入hjkl命令状态
; 如果命令状态为hjkl，那么此时输入hjkl任意键直接移动
leaderMoveKeyHandler(key) {
    global ready_command_id
    ; 检测当前是否有命令预备, 没有则当前命令进入预备
    if ready_command_id == "" {
        global followingKeys
        if followingKeys != key {
            ; 只允许空键程,进入hjkl命令预备
            ; 否则认为是普通输入
            KeysHandler(key)
        } else {
            ; 进入hjkl命令预备
            ready_command_id := "hjkl"
        }
    } else if ready_command_id == "hjkl" {
        ;现在正处于命令预备状态，可以认识是当前命令的键入
        global followingKeys
        followingKeys := key
        switch key {
            case "h":
                Send "{Left}"
            case "j":
                Send "{Down}"
            case "k":
                Send "{Up}"
            case "l":
                Send "{Right}"
            default:
                ;此处不可能到达
                MsgBox("不可能到达此处逻辑，请检查错误。")
                ; ;如果按下的不是hjkl键，退出命令预备状态
                ; ready_command_id := ""
                ; KeysHandler(key)
        }
        ; 小框提示当前Leader键和followingKeys
        input_keys_tip_dialog()

    } else {
        ; 说明当前有别的命令处于预备状态，将键入交给对应的处理函数
        ; hanlderMap(ready_command_id).run()
    }

}
