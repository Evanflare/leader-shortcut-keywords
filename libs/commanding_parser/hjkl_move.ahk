#Requires AutoHotkey v2.0

; 这是一个库文件，提供了基于hjkl键的移动功能。

#Include ..\..\leader.ahk
#Include ../action/jump_line_number.ahk
#Include ../action/record_send.ahk

; 子命令模式：hjkl 移动模式
; 如果handler_id不为空，并且还调用了这个handler那么默认由自己处理(由dispatch确定调用哪一个handler函数)
; 进行前缀匹配 匹配 space leader 下的 hh jj kk ll
leaderMoveKeyHandler(keyName) {
    OutputDebug("进入 leaderMoveKeyHandler, key down :" . keyName)
    ; 当处理函数的id为空的时候，进行前缀匹配
    global handler_id
    if handler_id == "" {
        ; 如果不是space leader 则直接不处理
        if !SpaceActive {
            return
        }
        global followingKeys, followingControlKeys
        current_input_keys := followingControlKeys . followingKeys . keyName
        ; 进行前缀匹配 匹配 hh jj kk ll
        switch {
            case RegExMatch(current_input_keys, "^(hh|jj|kk|ll)$"):
                ;匹配成功
                global handler_id := "hjkl"
                global handler_mode := "inner_mode" ; 子命令模式
            default:
                return
        }
    }
    switch keyName {
        case "h":
            record_and_send "{Left}"
        case "j":
            record_and_send "{Down}"
        case "k":
            record_and_send "{Up}"
        case "l":
            record_and_send "{Right}"
        default:
            ; 错误的输入，直接丢弃
            return
    }
    global followingKeys := keyName
    ; 小框提示当前Leader键和followingKeys
    input_keys_tip_dialog()
}
