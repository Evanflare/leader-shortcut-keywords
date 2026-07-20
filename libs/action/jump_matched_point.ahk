#Requires AutoHotkey v2.0

jump_point_action(user_input) {
    OutputDebug "进入 jump_point_action 函数"
    OutputDebug "user_input :" . user_input
    ; 假设 user_input 是你要处理的字符串
    if InStr(user_input, '``') {
        OutputDebug "用户输入包含``号"
        ; 检查是否包含反引号（单引号内直接写）
        ; 找到第一个反引号的位置（从1开始）
        pos := InStr(user_input, '``')
        ; 分割成前后两部分
        part1 := SubStr(user_input, 1, pos - 1)   ; 反引号之前的部分
        part2 := SubStr(user_input, pos + 1)      ; 反引号之后的部分（包括后面所有字符）
        ; 此时 part1 和 part2 即为分割结果
        OutputDebug("前半段: " part1 "`n后半段: " part2)
        ; 先定位到指定位置
        find_string := part1 . part2
        OutputDebug "定位到：" . find_string
        Send "^f"
        Sleep 50
        SendText find_string
        Send("{Escape}")
        Sleep 50
        Send "{Escape}"
        ; 移动到`所在代表的位置
        OutputDebug "并向左移动" . StrLen(part2)
        Send("{Left " StrLen(part2) "}")
    }
    else {
        OutputDebug "用户输入不包含``号"
        OutputDebug "定位到：" . user_input
        Send "^f"
        Sleep 50
        SendText user_input
        Send("{Escape}")
        Sleep 50
        Send "{Escape}"
    }
    OutputDebug "退出 jump_point_action 函数"
}
