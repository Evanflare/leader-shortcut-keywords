#Requires AutoHotkey v2.0

; 这是一个库文件，提供了基于caps a引导控制widnows窗口的功能。

#Include ..\..\leader.ahk
#Include ../action/record_send.ahk

; 子命令模式：控制窗口模式
; 如果handler_id不为空，并且还调用了这个handler那么默认由自己处理(由dispatch确定调用哪一个handler函数)
; 进行前缀匹配 匹配 caps+a leader下的 hjkl
windows_control(keyName) {
    OutputDebug("进入 windows_control, key down :" . keyName)
    ; 当处理函数的id为空的时候，进行前缀匹配
    global handler_id, CapsActive
    ; 如果不是 caps leader 则直接不处理
    if !CapsActive
        return
    if handler_id == "" {
        global followingKeys, followingControlKeys
        current_input_keys := followingControlKeys . followingKeys . keyName
        ; 进行前缀匹配 匹配 a hh jj kk ll
        switch {
            case RegExMatch(current_input_keys, "^a(hh|jj|kk|ll)$"):
                ;匹配成功
                global handler_id := "windows_control"
                global handler_mode := "inner_mode" ; 子命令模式
            default:
                return
        }
    }
    switch keyName {
        case "h":
            record_and_send "^!+h"
        case "j":
            record_and_send "^!+j"
        case "k":
            record_and_send "^!+k"
        case "l":
            record_and_send "^!+l"
        default:
            ; 错误的输入，直接丢弃
            return
    }
    global followingKeys := keyName
    ; 小框提示当前Leader键和followingKeys
    input_keys_tip_dialog()
}
