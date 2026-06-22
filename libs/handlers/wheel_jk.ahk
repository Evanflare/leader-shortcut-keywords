#Requires AutoHotkey v2.0

; 子命令模式： wheel_jk 滚动模式
; 如果handler_id不为空，并且还调用了这个handler那么默认由自己处理(由dispatch确定调用哪一个handler函数)
; 进行前缀匹配 匹配 LAltj LAltk
wheel_jk_handler(keyName) {
    ; 当处理函数的id为空的时候，进行前缀匹配
    global handler_id
    if handler_id == "" {
        global followingKeys, followingControlKeys
        current_input_keys := followingControlKeys . followingKeys . keyName
        ; 进行前缀匹配 匹配 LAltj LAltk
        switch {
            case RegExMatch(current_input_keys, "^(\$LAltjj|\$LAltkk)$"):
                ;匹配成功
                global handler_id := "wheel_jk"
                global handler_mode := "inner_mode" ; 子命令模式
            default:
                return
        }
    }
    switch keyName {
        case "j":
            Send "{WheelDown 5}"
        case "k":
            Send "{WheelUp 5}"
        default:
            ; 错误的输入，直接丢弃
            return
    }
    global followingKeys := keyName
    ; 小框提示当前Leader键和followingKeys
    input_keys_tip_dialog()
}
