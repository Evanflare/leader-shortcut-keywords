#Requires AutoHotkey v2.0

; ===================== 历史记录模块 =====================
global MaxHistory := 50
global History := []

; ---------- 添加历史 ----------
add_to_history(item) {
    global History, MaxHistory
    if (item == "")
        return
    History.Push(item)
    while History.Length > MaxHistory
        History.RemoveAt(1)
}

; ---------- 构建并显示历史窗口（独立函数，无分支） ----------
show_history() {
    ; 此函数内没有条件分支，gui 必然被赋值
    my_gui := Gui()
    my_gui.Title := "📋 历史记录 (最大50项,双击复制并粘贴)"
    my_gui.Opt("+AlwaysOnTop +ToolWindow")
    my_gui.SetFont("s10")

    ; 列表框
    lb := my_gui.Add("ListBox", "w400 r15", History)
    lb.OnEvent("DoubleClick", (*) => SelectAndPaste(lb, my_gui))

    ; 按钮
    okBtn := my_gui.Add("Button", "Default w80", "复制并粘贴")
    okBtn.OnEvent("Click", (*) => SelectAndPaste(lb, my_gui))
    cancelBtn := my_gui.Add("Button", "w80", "取消")
    cancelBtn.OnEvent("Click", (*) => my_gui.Destroy())

    ; esc关闭窗口
    my_gui.OnEvent("Escape", (*) => my_gui.Destroy())   ; 按下 Esc 关闭窗口

    ; 选中最终一项
    if (History.Length > 0) {
        lb.Choose(History.Length)  ; 默认选中最后一项
    }

    my_gui.Show()
    return

    ; 内部函数：选择并粘贴
    SelectAndPaste(lb, my_gui) {
        can_copy_paste := lb.Text != ""
        if can_copy_paste {
            OutputDebug("复制粘贴文本: " . lb.Text)
            A_Clipboard := lb.Text
        }
        my_gui.Destroy()
        if can_copy_paste {
            record_and_send("^v")  ; 粘贴必须要窗口销毁之后
        }
    }
}
; ---------- 记录并发送 ----------
record_and_send(param) {
    add_to_history(FormatTime(A_Now, "HH:mm") . ": " . param)
    Send(param)
}

; ---------- 记录并发送 ----------
record_and_sendText(param) {
    add_to_history(FormatTime(A_Now, "HH:mm") . ": " . param)
    SendText(param)
}
