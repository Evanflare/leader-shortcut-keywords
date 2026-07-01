#Requires AutoHotkey v2.0

; ========================================
;  脚本控制中心：暂停 · 挂起 · 重启
; ========================================

; ---------- 托盘菜单 ----------
; 添加自定义菜单项到托盘图标
A_TrayMenu.Delete()  ; 清空默认菜单（可选）
A_TrayMenu.Add("暂停脚本 (Ctrl+Alt+P)", TogglePause)
A_TrayMenu.Add("挂起热键 (Ctrl+Alt+S)", ToggleSuspend)
A_TrayMenu.Add("重启脚本 (Ctrl+Alt+R)", ReloadScript)
A_TrayMenu.Add()  ; 分隔线
A_TrayMenu.Add("退出", ExitApp)
A_TrayMenu.Default := "暂停脚本 (Ctrl+Alt+P)"  ; 双击托盘执行暂停切换

; ---------- 快捷键 ----------
; 注意：使用 #SuspendExempt 保护关键热键，使其在挂起时仍有效

; 1. 切换暂停状态 (Ctrl+Alt+P)
#SuspendExempt
^!p:: {
    Pause(-1)      ; -1 表示切换（暂停 ↔ 恢复）
    ShowStatus("暂停状态: " . (A_IsPaused ? "已暂停" : "运行中"))
}
#SuspendExempt False

; 2. 切换挂起状态 (Ctrl+Alt+S)
#SuspendExempt
^!s:: {
    Suspend()      ; 切换挂起
    ShowStatus("热键状态: " . (A_IsSuspended ? "已挂起" : "已启用"))
}
#SuspendExempt False

; 3. 重启脚本 (Ctrl+Alt+R)
#SuspendExempt
^!r:: {
    ShowStatus("正在重启脚本...")
    Sleep(200)
    Reload()
}
#SuspendExempt False

; 4. 紧急停止：同时暂停 + 挂起 (Ctrl+Esc)
#SuspendExempt
^Esc:: {
    Suspend()      ; 切换挂起
    Pause(-1)      ; 切换暂停
    ShowStatus("紧急停止: " . (A_IsPaused ? "已暂停" : "已运行") . " | " . (A_IsSuspended ? "热键已挂起" : "热键已启用"))
}
#SuspendExempt False

; ---------- 辅助函数 ----------
; 显示临时状态提示（2秒后自动消失）
ShowStatus(message) {
    ToolTip(message)
    SetTimer(() => ToolTip(), -2000)  ; 2秒后清除
}

; ---------- 托盘菜单回调函数 ----------
TogglePause(*) {
    Pause(-1)
    ShowStatus("暂停状态: " . (A_IsPaused ? "已暂停" : "运行中"))
}
ToggleSuspend(*) {
    Suspend()
    ShowStatus("热键状态: " . (A_IsSuspended ? "已挂起" : "已启用"))
}
ReloadScript(*) {
    ShowStatus("正在重启脚本...")
    Sleep(200)
    Reload()
}
ExitApp(*) {
    ExitApp()
}
