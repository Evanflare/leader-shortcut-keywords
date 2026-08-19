#Requires AutoHotkey v2.0

#Include ../action/record_send.ahk
; 子命令模式： focus_aswd_move 视窗焦点移动模式
; 如果handler_id不为空，并且还调用了这个handler那么默认由自己处理(由dispatch确定调用哪一个handler函数)
; 进行前缀匹配 匹配 LAlt[asdw]{2}
focus_aswd_move(keyName) {
    ; 当处理函数的id为空的时候，进行前缀匹配
    global handler_id
    if handler_id == "" {
        global followingKeys, followingControlKeys
        current_input_keys := followingControlKeys . followingKeys . keyName
        ; 进行前缀匹配 匹配
        switch {
            case RegExMatch(current_input_keys, "^Alt[asdw]{2}$"):
                ;匹配成功
                global handler_id := "focus_aswd_move"
                global handler_mode := "inner_mode" ; 子命令模式
            default:
                return
        }
    }
    switch keyName {
        case "a":
            record_and_send "+!z"
        case "s":
            record_and_send "^+x"
        case "w":
            record_and_send "+!u"
        case "d":
            record_and_send "+!y"
        default:
            ; 错误的输入，直接丢弃
            return
    }
    global followingKeys := keyName
    ; 小框提示当前Leader键和followingKeys
    input_keys_tip_dialog()
}
