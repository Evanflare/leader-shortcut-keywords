#Requires AutoHotkey v2.0

#Include ../action/record_send.ahk
#Include ../key_handler_dispatcher.ahk
; capslock 子命令模式： mouse_control 视窗焦点移动模式
; 如果handler_id不为空，并且还调用了这个handler那么默认由自己处理(由dispatch确定调用哪一个handler函数)
; 进行前缀匹配 匹配 LAlt[asdw]
global mouse_control_mode := false

#HotIf mouse_control_mode
$k Up:: dispatcher("kup")
$j Up:: dispatcher("jup")
#HotIf

; ---------- 启动鼠标控制模式 ----------
StartMouseControl() {
    global mouse_control_mode
    if mouse_control_mode
        return   ; 避免重复启动
    mouse_control_mode := true
    ; 启动定时器，每 20ms 检查一次按键
    SetTimer(MouseControlLoop, 20)
    ToolTip("鼠标控制模式已开启")
    SetTimer(() => ToolTip(), -1000)
}

; ---------- 退出鼠标控制模式 ----------
ExitMouseControl() {
    OutputDebug "进入 退出鼠标控制方法..."

    mouse_control_mode := false

    OutputDebug "执行 删除定时器..."
    SetTimer(MouseControlLoop, 0)   ; 关闭定时器

    ; 确保所有鼠标按键已释放（避免卡键）
    ; Send("{LButton up}")
    ; Send("{RButton up}")
    ToolTip("鼠标控制模式已退出")
    SetTimer(() => ToolTip(), -1000)
}

; ---------- 定时器循环：持续检查按键 ----------
MouseControlLoop() {
    static current_speed := 20  ; 当前速度，会动态变化
    static speed_step := 5       ; 每次加速增量
    static max_speed := 50       ; 最大速度
    static base_speed := 5      ; 基础速度（无方向键按下时）

    ; 检查是否有任何方向键被按住
    anyDir := GetKeyState("a", "P") || GetKeyState("d", "P") || GetKeyState("w", "P") || GetKeyState("s", "P")

    if anyDir {
        ; 有方向键按下：加速（但不超过最大值）
        current_speed := Min(current_speed + speed_step, max_speed)
    } else {
        ; 没有方向键按下：重置为基础速度
        current_speed := base_speed
    }

    ; 计算位移（使用当前速度）
    dx := 0, dy := 0
    if GetKeyState("a", "P")
        dx -= current_speed
    if GetKeyState("d", "P")
        dx += current_speed
    if GetKeyState("w", "P")
        dy -= current_speed
    if GetKeyState("s", "P")
        dy += current_speed

    if (dx != 0 || dy != 0)
        MouseMove(dx, dy, 0, "R")   ; 相对移动，瞬间

}

; ---------- 原有匹配逻辑（简化版） ----------
mouse_control(keyName) {
    global handler_id, CapsActive, followingKeys, followingControlKeys
    if !CapsActive
        return
    if handler_id == "" {
        current_input_keys := followingControlKeys . followingKeys . keyName
        OutputDebug("进行 mouse control 前缀匹配，当前输入：" . current_input_keys)
        if RegExMatch(current_input_keys, "^Alt[asdw]$") {
            OutputDebug("进入 mouse control 模式")
            handler_id := "mouse_control"
            handler_mode := "inner_mode"
            StartMouseControl()   ; 启动模式 + 定时器
            return
        }
        return
    }
    switch keyName {
        case "j":
            record_and_send "{LButton down}"
        case "k":
            record_and_send "{RButton down}"
        case "jup":
            record_and_send "{LButton up}"
        case "kup":
            record_and_send "{RButton up}"

    }

}
