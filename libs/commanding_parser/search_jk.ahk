#Requires AutoHotkey v2.0

#Include ../../leader.ahk
#Include ../action/record_send.ahk
; 子命令模式： space-f-jkjljk....
; 如果handler_id不为空，并且还调用了这个handler那么默认由自己处理(由dispatch确定调用哪一个handler函数)
; 进行前缀匹配 匹配 f[jk]
search_jk(keyName) {
    ; 当处理函数的id为空的时候，进行前缀匹配
    global handler_id
    if handler_id == "" {
        global followingKeys, followingControlKeys
        current_input_keys := followingControlKeys . followingKeys . keyName
        ; 进行前缀匹配 匹配 "f[jk]"
        switch {
            case RegExMatch(current_input_keys, "^f([jk])$", &groupMatch): ; 匹配 space-f-j或者space-f-k
                ;匹配成功
                global handler_id := "search_jk"
                global handler_mode := "inner_mode" ; 子停留模式
            default:
                return
        }
    }
    global search_key_words_memory
    switch keyName {
        case "j":
            ; vscode经常出现按ctrl-f就将往当前光标所在字符串作为新的搜索关键词，我们需要还原之前的搜索关键词
            record_and_send "^f"
            ; 清空之前的输入
            record_and_send "^{a}"
            record_and_send "{Delete}"
            Sleep 10
            record_and_sendText search_key_words_memory
            OutputDebug "搜索下一个正则匹配项：" . search_key_words_memory
            Sleep 10
            record_and_send "{Escape}"
            Sleep 10
            record_and_send "{Escape}"
        case "k":
            ; vscode经常出现按ctrl-f就将往当前光标所在字符串作为新的搜索关键词，我们需要还原之前的搜索关键词
            record_and_send "^f"
            ; 清空之前的输入
            record_and_send "^{a}"
            record_and_send "{Delete}"
            Sleep 10
            record_and_sendText search_key_words_memory
            OutputDebug "搜索上一个正则匹配项：" . search_key_words_memory
            Sleep 10
            ; 然后连续向上2次
            record_and_send "{Shift down}"
            record_and_send "{Enter 2}"
            record_and_send "{Shift up}"
            record_and_send "{Escape}"
            Sleep 10
            record_and_send "{Escape}"
    }
    ; 小框提示当前Leader键和followingKeys
    input_keys_tip_dialog()
}
