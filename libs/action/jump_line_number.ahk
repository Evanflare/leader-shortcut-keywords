#Requires AutoHotkey v2.0
#Include record_send.ahk

JumpToLine(targetLine) {
    ; 1. 获取当前窗口的编辑控件
    ; 注意：如果目标窗口不是记事本，需要修改 'ahk_class Notepad' 部分
    ; 可以先使用 'WinActivate' 激活目标窗口

    ; 3. 尝试使用 Ctrl+G 跳转
    record_and_send "^g"
    Sleep(50) ; 等待跳转对话框打开
    record_and_send targetLine
    record_and_send "{Enter}{End}"
    Sleep(100) ; 等待跳转完成

    ; 4. 验证跳转结果
    try {
        controlHwnd := ControlGetHwnd("vscode", "A") ; 获取当前活动窗口的 Edit1 控件
        currentLine := EditGetCurrentLine(controlHwnd)
        if (currentLine == targetLine) {
            ;MsgBox("Ctrl+G 跳转成功！当前行: " . currentLine)
            ToolTip "成功跳转"
            Sleep(1000)
            ToolTip
            return
        }
    } catch TargetError {
        ; 如果跳转后无法获取行号，也视为跳转失败
        ; 5. 备用方案：如果 Ctrl+G 跳转失败，使用模拟按键
        ;record_and_send "^{Home}"
        ;record_and_send "{Down " . targetLine - 1 . "}"
        ;record_and_send "{End}"
    }
}
