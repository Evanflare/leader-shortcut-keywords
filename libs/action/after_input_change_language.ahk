#Requires AutoHotkey v2.0

#Include record_send.ahk
#Include ../command_end_parser.ahk

after_input_change_language() {
    ; 首先需要判断现在处于什么输入法
    ; 获取前台窗口
    hwnd := WinGetID("A")
    ; 获取窗口所属线程 ID
    threadID := DllCall("GetWindowThreadProcessId", "Ptr", hwnd, "Ptr", 0, "UInt")
    ; 获取该线程的键盘布局
    hkl := DllCall("GetKeyboardLayout", "UInt", threadID, "Ptr")
    langID := hkl & 0xFFFF
    langCode := Format("{:04x}", langID)
    chinese_language_status := false
    if langCode = "0804"
        chinese_language_status := true
    OutputDebug "中文模式状态值: " . chinese_language_status
    if chinese_language_status {
        ; 中文模式转英文模式，不用进行“弥补”
        global followingKeys := "en"
        space_command_parser()
    } else {
        OutputDebug "弥补性转换中文中..."
        ; 英文模式转中文模式，需要“弥补”
        ; 往前找空格，先复制从当前位置到行首home的文本
        record_and_send "{Shift Down}{Home}{Shift Up}"
        Sleep 10
        record_and_send "^c"
        Sleep 10
        s := A_Clipboard
        not_english_char_index := 0
        if RegExMatch(s, ".*([^A-Za-z])", &match) {
            not_english_char_index := match.Pos[1]
        }
        OutputDebug "搜索最近的非字母字符 index: " . not_english_char_index
        if StrLen(s) = not_english_char_index {
            ; 说明无须转换、翻译直接切换输入法
            ; 切换输入法
            global followingKeys := "cn"
            space_command_parser()
            record_and_send "{Right}"
            return
        } else if not_english_char_index = 0 {
            OutputDebug "未找到非字母字符，将之前输入的内容全部作为重新输入"
            ; 剪切
            record_and_send "^c"
            record_and_send "{Delete}"
            Sleep 50
            ; 切换输入法
            global followingKeys := "cn"
            space_command_parser()
            Sleep 10
            ; 输出剪切内容
            record_and_send A_Clipboard
        } else {
            ; 移动到空格后
            record_and_send "{Escape}"
            Sleep 10
            record_and_send "{Right " . not_english_char_index . "}"
            Sleep 10
            ; 选中从目标位置到之前光标的位置
            record_and_send "{Shift Down}"
            Sleep 10
            Send "{Right " . StrLen(s) - not_english_char_index . "}"
            Sleep 10
            Send "{Shift Up}"
            Sleep 10
            ; 剪切
            record_and_send "^c"
            record_and_send "{Delete}"
            Sleep 50
            ; 切换输入法
            global followingKeys := "cn"
            space_command_parser()
            Sleep 10
            ; 输出剪切内容
            record_and_send A_Clipboard
        }
    }
}
