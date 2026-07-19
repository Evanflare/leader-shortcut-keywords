#Requires AutoHotkey v2.0
;//! ; 如果ready_command_id 为空，则将键交给所有处理函数处理
;//! ; (注册顺序非常重要，先进行处理handler的往往会占据ready_command_id导致后续处理函数不再处理)
;//! ; 如果ready_comand_id 不为空，则将键交给匹配的处理函数处理
;//! ; 如果没有匹配的处理函数，交给普通释放触发快捷键处理函数处理

; ---------- 全局状态 ----------
#Include ../leader.ahk
global handlers := Map()             ; 存储所有处理函数，键为命令ID（字符串），值为函数对象
; ---------- 注册处理函数 ----------
#Include handlers\key_handler.ahk
#Include handlers\hjkl_move.ahk
#Include handlers\wheel_jk.ahk
#Include handlers\search_jk.ahk
; 注意注册顺序：先注册的会优先获得处理权（当 ready_command_id 为空时）
; 最好在handler目录排查冲突的快捷键，避免发生冲突
handlers["hjkl"] := leaderMoveKeyHandler
handlers["wheel_jk"] := wheel_jk_handler
handlers["search_jk"] := search_jk
handlers["space_wait_input"] := DefaultHandler
handlers["capslock_wait_input"] := DefaultHandler
handlers["default"] := DefaultHandler
; 可以继续添加……
; 默认处理函数（当所有 handler 都不ready时）
DefaultHandler(keyName) {
    KeysHandler(keyName)
}
; ---------- 分发器 ----------
dispatcher(keyName) {
    OutputDebug("进入dispatcher函数, key down: " . keyName)
    global handler_id, handlers
    OutputDebug("handler_id: " . handler_id)
    ; 1. 如果 handler_id 为空，则让所有 handler 依次尝试处理
    if (handler_id == "") {
        for id, handler in handlers {
            ; 调用处理函数
            if (handler_id == "") {
                ; 如果handler_id仍然等于空,继续依次处理
                handler(keyName)
            } else {
                break
            }
        }
        ; 当handler_id始终为空，交给默认处理
        if (handler_id == "") {
            DefaultHandler(keyName)
        }
    }
    ; 2. 如果 handler_id 不为空，则只调用对应的 handler
    else {
        if (handlers.Has(handler_id)) {
            handler := handlers[handler_id]
            OutputDebug("调用到handler_id对应的处理函数")
            handler(keyName)   ; 调用匹配的处理函数（通常不需要返回值）
        } else {
            OutputDebug("warning: handler_id对应的处理函数不存在，可能是注册顺序问题或未注册")
            OutputDebug("handler_id: " . handler_id)
            ; 如果 ID 不存在（理论上不会发生），清理状态并降级
            handler_id := ""
            dispatcher(keyName)   ; 递归调用，重新走空 ID 逻辑
        }
    }
}
