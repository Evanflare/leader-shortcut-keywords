#Requires AutoHotkey v2.0
/************************************************************************
 * @description 通用快捷键方案
 * @author 蒙煋Evanflare
 * @date 2026/06/22
 * @version 1.0.0
 ***********************************************************************/

;这个脚本实现CapLocks和Space的LeadTter快捷键功能。
;
;实现逻辑：
;1.当按下CapLocks或Space时，进入Leader模式。
;2.在释放Leader键的时候，根据在Leader模式下输入的其他键来执行不同的操作。
;3.如果在Leader模式下没有输入其他键，直接发送Leader键的原始功能。
;4.在Leader模式下，按下的其他键会被记录下来，并在释放Leader键时根据记录的键来执行对应的操作。
;5.在Leader模式下，按下的其他键会在小框中提示当前的Leader键和输入的其他键。
;定义Leader键和Leader键的触发状态
Leader1 := "CapsLock"
Leader2 := "Space"
SpaceActive := false
CapsActive := false
LeaderTimeout := 500 ; Leader模式的超时时间，单位为毫秒
;存储Leader时间内的其他键盘输入
followingKeys := ""
; 存储Leader时间内的控制键输入，比如Alt键
followingControlKeys := ""
; 当前命令的处理函数id
handler_id := ""
; 当前处理函数的模式
handler_mode := "default"
exit_wait_input_should := false
;  更新提示小窗：显示当前输入的键程
input_keys_tip_dialog() {
    if SpaceActive {
        ToolTip "Space: " . followingControlKeys . followingKeys
    }
    else if CapsActive {
        ToolTip "CapsLock: " . followingControlKeys . followingKeys
    }
}

; 搜索记忆
search_key_words_memory := " "
; 用于保存 InputBox 的窗口句柄
global InputBoxHwnd := 0
#Include ./libs/script_control.ahk
#Include ./libs/key_hook.ahk