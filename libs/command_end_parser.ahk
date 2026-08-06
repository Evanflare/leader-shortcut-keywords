#Requires AutoHotkey v2.0
; ========================================
;  已存在需避让的快捷键列表:
;  [^!p]     切换暂停状态（暂停/恢复线程执行）
;  [^!s]     切换挂起状态（启用/禁用全部热键）
;  [^!r]     重启脚本
;  [^!Esc]   紧急停止（同时暂停线程并挂起热键）
; ========================================
#Include ../leader.ahk
#Include action/jump_matched_point.ahk
#Include action/review_time.ahk
#Include action/record_send.ahk
; 普通释放触发键的处理函数
KeysHandler(key) {
    OutputDebug("进入keysHandler函数，普通释放触发键的处理函数")
    OutputDebug("key down: " . key)
    ; Leader激活，调用处理函数
    LeaderTimeKeyDownHandler(key)
    ; 小框提示当前Leader键和followingKeys
    input_keys_tip_dialog()
}
; 控制键的处理函数，检查Leader是否激活
ControlKeysHandler(keyName) {
    ; 这里的key是类似于ThisHotkey的字符串，比如"$ "，我们需要把前面的"$"去掉，得到"Alt"
    ;keyName := SubStr(keyName, 2) ; 去掉前面的"$"
    ; Leader激活，调用处理函数
    LeaderTimeControlKeyDownHandler(keyName)
    ; 小框提示当前Leader键和followingKeys
    input_keys_tip_dialog()

}

; 处理Leader模式下捕捉到的键与 follwingKeys 的关系
LeaderTimeKeyDownHandler(key) {
    OutputDebug("进入LeaderTimeKeyDownHandler函数")
    OutputDebug("key down: " . key)
    global followingKeys
    ; 这里控制键我们不去重，因为有些组合快捷键是需要同时按下多个控制键的，比如 space-t-t-y
    ; 有些特殊的键需要处理
    switch key {
        case "BackSpace":
            ; followingkeys 删除最后的一个符号
            followingKeys := SubStr(followingKeys, 1, -1)
        default:
            ; 直接追加就行了
            followingKeys .= key
    }
    OutputDebug("退出LeaderTimeKeyDownHandler函数")
}
; 处理Leader模式下捕捉到的控制键与 followingControlKeys 的关系
LeaderTimeControlKeyDownHandler(key) {
    global followingControlKeys
    ; 如果followingControlKeys字符串已经包含了这个键，说明是重复按键，丢弃此次按键
    if InStr(followingControlKeys, key) {
        return
    } else {
        ; 将捕捉到的控制键追加在followingControlKeys字符串中
        followingControlKeys .= key
    }

}

; Space Leader释放时处理 hotkey 映射的函数
space_command_parser() {
    OutputDebug "进入 space_command_parser 函数"
    global followingKeys, followingControlKeys, handler_id
    shortcutKeywords := Trim(followingControlKeys . followingKeys) ; 将控制键和普通键合并成一个字符串，方便后续的switch判断
    OutputDebug("shortcutKeywords: " . shortcutKeywords)
    OutputDebug("shortcutKeywords.len = " . StrLen(shortcutKeywords))
    if handler_id != "" {
        OutputDebug("handler_id != '', 说明此次输入已被命令进行解释器解释，这里不再进行解释。")
        return
    }
    ;  先判断是否触发 wait_input 模式
    if shortcutKeywords == "jp" {
        wait_input_init
        space_command_wait_input_jp
        wait_input_destructor
    } else {
        switch (shortcutKeywords) {
            case "f":
                record_and_send "^f"  ; `space-f` 搜文件内容`ctrl-f`
            case "th": ; 替换内容
                record_and_send "^h"
            case "fd":
                record_and_send "^+f"  ; `space-f-d`搜索目录内容 `ctrl-shift-f`
            case "fh":
                record_and_send "^+a" ; `space-f-h`搜索文件路径 `ctrl-shift-a`
            case "ff": ; 查找下一个空格
                ;存储一下搜索记忆
                global search_key_words_memory := "(?<=[^ ])( )(?=[^ ])"
                record_and_send "^f"
                ; 清空搜索框
                Sleep 10
                record_and_send "^a"
                record_and_send "{Delete}"
                record_and_sendText "(?<=[^ ])( )(?=[^ ])"
                Sleep 10
                record_and_send "{Escape 2}"
            case "l":
                record_and_send "^l"  ; `space-l` 聚焦到地址栏 `ctrl-l`
            case "m":
                record_and_send "^!m"  ; `space-m` 聚焦中部页面 `ctrl-alt-m`
            case "n":
                record_and_send "^!n"  ; `space-n` 聚焦到非编辑控件 `ctrl-alt-n`
            case "k":
                record_and_send "^+k"  ; `space-k` 跳出括号对 `ctrl-shift-k`
            case "e":
                record_and_send "^+e"  ; `space-e` 光标行尾 end `ctrl-shift-e`
                record_and_send "{End}" ; 这里是为了兼容一些不支持`ctrl-shift-e`的应用，比如Windows Terminal，直接发送End键就可以了
            case "b":
                record_and_send "^+b"  ; `space-b` 光标行首 begin `ctrl-shift-b`
                record_and_send "{Home}" ; 这里是为了兼容一些不支持`ctrl-shift-b`的应用，比如Windows Terminal，直接发送Home键就可以了
            case "dd":
                ;record_and_send "^+d"  ; `space-d-d`删除行 `ctrl-shift-d`
                ; 使用更通用的删除行实现方式
                record_and_send "{End}"
                record_and_send "+{Home 2}"  ; 选中整行
                Sleep 50
                record_and_send "{Delete 2}"  ; 删除整行
            case "lc": ; 清空当前行`space-l-c` 清空当前行
                record_and_send "{End}"
                record_and_send "+{Home}"
                Sleep 50
                record_and_send "{Delete}"
            case "db":
                ; `space-d-b`删除到行首
                record_and_send "+{Home}"
                Sleep 50
                record_and_send "{Delete}"
            case "de":
                ; `space-d-e`删除到行尾
                record_and_send "+{End}"
                Sleep 50
                record_and_send "{Delete}"
            case "cls":
                record_and_send "^+!c"  ; `space-c-l-s`清空终端 `ctrl-shift-alt-c`
            case "x":
                record_and_send "{Delete}"  ; `space-x`删除当前字符 `delete`
            case "gg":
                record_and_send "^{Home}"  ; `space-g-g`跳转到文件开头 `ctrl-home`
            case "Shiftg":
                record_and_send "^{End}"  ; `space-Shift-g`跳转到文件结尾 `ctrl-end`
            case "s":
                record_and_send "^s"  ; Ctrl+S 保存
            case "a":
                record_and_send "^a"  ; Ctrl+A 全选
            case "c":
                record_and_send "^c"  ; Ctrl+C 复制
            case "v":
                record_and_send "^v"  ; Ctrl+V 粘贴
            case "vv":
                record_and_send "^!v" ; 打开 copyq 剪切板界面
            case "ca":
                record_and_send "^+c" ; 复制到copyq复制缓冲区 A 号
            case "cb":
                record_and_send "^+g" ; 复制到copyq复制缓冲区 B 号
            case "cc":
                record_and_send "^+h" ; 复制到copyq复制缓冲区 C 号
            case "cd":
                record_and_send "^!+i" ; 复制到copyq复制缓冲区 D 号
            case "x":
                record_and_send "^x"  ; Ctrl+X 剪切
            case "gb":
                record_and_send "^+!u"  ; `space-g-b` 跳转go back `ctrl-shift-alt-u`
            case "gf":
                record_and_send "^+!x"  ; `space-g-f` 跳转go forward `ctrl-shift-alt-x`
            case "zx":
                record_and_send "+!x" ; `space-z-x`焦点在组视窗的下一个 `shift-alt-x`
            case "zy":
                record_and_send "+!y" ; `space-z-y`焦点在组视窗的下一个 `shift-alt-y`
            case "zu":
                record_and_send "+!u"  ; `space-z-u`焦点在组视窗的上一个 `shift-alt-u`
            case "zz":
                record_and_send "+!z"  ; `space-z-z`焦点在组视窗的上一个 `shift-alt-z`
            case "z1":
                record_and_send "^+!1"  ; `space-z-1`焦点在组1 `ctrl-shift-alt-1`
            case "z2":
                record_and_send "^+!2"  ; `space-z-2`焦点在组2 `ctrl-shift-alt-2`
            case "z3":
                record_and_send "^+!3"  ; `space-z-3`焦点在组3 `ctrl-shift-alt-3`
            case "z4":
                record_and_send "^+!4"  ; `space-z-4`焦点在组4 `ctrl-shift-alt-4`
            case "Altks":
                record_and_send "^!k"  ; `space-alt-k-s`打开快捷键页面 `ctrl-alt-k`
            case "RAltks":
                record_and_send "^!k"  ; `space-alt-k-s`打开快捷键页面 `ctrl-alt-k`
                ; 下面是视角切换的处理
            case "Altl1":
                record_and_send "^!1"  ; `space-alt-l-1`组视窗有 1列 `ctrl-alt-1`
            case "Altl2":
                record_and_send "^!2"  ;   `space-alt-l-2`组视窗有 2列 `ctrl-alt-2`
            case "Alth2":
                record_and_send "+!2"  ; `space-alt-h-2`组视窗有 2行 `shift-alt-2`
            case "Alth1":
                record_and_send "^!1"  ; `space-alt-h-1`组视窗有 1行 `ctrl-alt-1`
            case "Altwg":
                record_and_send "^!g"  ; `space-alt-w-g`组视窗呈网格 4窗 `ctrl-alt-g`
            case "Altux":
                record_and_send "^!x"  ; `space-alt-u-x`组视窗向下生，并复制当前的文件编辑视图 `ctrl-alt-x`
            case "Altuy":
                record_and_send "^!y"  ; `space-alt-u-y`组视窗向右生，并复制当前的文件编辑视图 `ctrl-alt-y`
            case "Altuz":
                record_and_send "^!z"  ; `space-alt-u-z` `ctrl-alt-z`
            case "Altu":
                record_and_send "^!u"  ; `space-alt-u` `ctrl-alt-u`
            case "Altuj":
                record_and_send "^!j"  ; `space-alt-u-j`视角的意思，内容视角生 同样也是回收视角 `ctrl-alt-j`
            case "Altls":
                record_and_send "^!l"  ; 'space-alt-l-s' 切换黑白模式 `ctrl-alt-l`
            case "Altqp":
                record_and_send "{F11}"
            case "cn":
                record_and_send "^+9" ;`space-c-n`切换中文`space-e-n`切换英文 `ctrl-shift-9` `ctrl-shift-8`
            case "en":
                record_and_send "^+8" ; `space-c-n`切换中文`space-e-n`切换英文 `ctrl-shift-9` `ctrl-shift-8`
            case "o":
                record_and_send "{End}{Enter}"
            case "Shifto":
                record_and_send "{Up}"
                Sleep 50
                record_and_send "{End}{Enter}"
            default:
                switch {
                    case RegExMatch(shortcutKeywords, "^(\d+)$", &groupMatch): ; 匹配纯数字格式
                        ; 提取匹配到的数字转换
                        times := Integer(groupMatch[1])
                        if times < 1 {
                            times := 1
                        }
                        JumpToLine(times)
                    case RegExMatch(shortcutKeywords, "^(\d+)([hjkl])$", &groupMatch): ; 匹配纯数字格式hjkl结尾
                        ; 提取匹配到的数字转换
                        times := Integer(groupMatch[1])
                        if times < 1 {
                            times := 1
                        }
                        switch groupMatch[2] {
                            case "h":
                                record_and_send "{Left " . times . "}"
                            case "j":
                                record_and_send "{Down " . times . "}"
                            case "k":
                                record_and_send "{Up " . times . "}"
                            case "l":
                                record_and_send "{Right " . times . "}"
                        }

                    case RegExMatch(shortcutKeywords, "^ff(.+)$", &groupMatch): ; 匹配 space-f-f-<words>
                        ; 先存储记忆,因为vscode经常出现ctrl-f直接将当前光标所在字符串作为新的搜索关键词覆盖之前的关键词，所以我们需要自行存储搜索历史
                        global search_key_words_memory := groupMatch[1]
                        record_and_send "^f"
                        ; 清空之前的输入
                        ; `space-d-b`删除到行首
                        record_and_send "^{a}"
                        Sleep 50
                        record_and_send "{Delete}"
                        Sleep 50
                        record_and_send groupMatch[1]
                        record_and_send "{Escape}"
                        Sleep 50
                        record_and_send "{Escape}"
                    default:
                        ; 不匹配，小小提示音
                        SoundPlay("*-1")
                }
        }
    }
}
; space jp 引导的wait_input命令
space_command_wait_input_jp() {
    OutputDebug "进入 space_command_wait_input_jp 函数"
    ; 设置小巧的窗口，位置居中，提示精简
    input := InputBox("输入参数：", "space jp命令", "W200 H60")

    ; 判断用户是否取消或关闭
    if input.Result = "Cancel"
        return
    ; 获取输入内容
    userInput := input.Value
    jump_point_action(userInput)
}

; CapsLock Leader释放时处理 hotkey 映射的函数
capslock_command_parser() {
    OutputDebug("进入 capslock_command_parser 函数")
    global followingKeys, followingControlKeys, handler_id
    shortcutKeywords := Trim(followingControlKeys . followingKeys) ; 将控制键和普通键合并成一个字符串，方便后续的switch判断
    OutputDebug("shortcutKeywords: " . shortcutKeywords)
    OutputDebug("shortcutKeywords.len = " . StrLen(shortcutKeywords))
    if handler_id != "" {
        OutputDebug("handler_id != '', 说明此次输入已被命令进行解释器解释，这里不再进行解释。")
        return
    }
    ; “”空followkeys前缀，进入capslock的wait_input模式
    if shortcutKeywords == "" {
        ; 开启wait_input模式
        OutputDebug("调用 capslock 引导的 wait_input 模式函数 capslock_command_wait_input")
        wait_input_init
        capslock_command_wait_input shortcutKeywords
        wait_input_destructor
    } else {
        OutputDebug("调用 capslock 普通热键映射命令解释函数 capslock_command_hot_key")
        capslock_command_hot_key(shortcutKeywords)
    }

    OutputDebug("退出caps_lock_up_handler")
}
; capslock引导的普通映射命令
capslock_command_hot_key(shortcutKeywords) {
    switch (shortcutKeywords) {
        case "o":
            record_and_send "^o"  ; `caplock-o`打开文件`ctrl-o`
        case "od":
            record_and_send "^+o"  ; `caplock-o-d`打开文件夹`ctrl-shift-o`
        case "fr":
            record_and_send "^+r"  ; `caplock-f-r`设置文件的只读性 `ctrl-shift-r`
        case "t":
            record_and_send "^+!t"        ;`caplock-t` 跳到文件（内部搜索并打开）ctrl-shfit-alt-t
        case "c":
            record_and_send "^{F4}"  ; `caplock-c` 关闭当前文件 `ctrl-F4`
        case "n":
            record_and_send "^n"  ; `caplock-n` 新建文件 `ctrl-n`
        case "tty":
            ; `space-t-t-y`打开终端 `space-t-t`是打开终端的前缀，y是terminal的第二个字母
            ; 1. 启动并获取 PID（官方推荐精准匹配方式）
            Run "wt.exe --window new", , , &pid

            ; 2. 等待窗口出现（官方必用步骤）
            hwnd := WinWait("ahk_pid " pid, , 2)
            if (!hwnd)
                return

            ; 3. 官方激活（内部已含重试与 Alt 解锁）
            WinActivate(hwnd)

            ; 4. 确保窗口可见（防止被最小化/隐藏）
            WinRestore(hwnd)
            WinShow(hwnd)
        case "wt":
            ; 打开终端的命令是%LocalAppData%\Microsoft\WindowsApps\wt.exe，所以我们直接运行这个命令就可以了
            ; `space-t-t-y`打开终端 `space-t-t`是打开终端的前缀，l是terminal的第一个字母
            ; 1. 启动并获取 PID（官方推荐精准匹配方式）
            Run "wt.exe --window new", , , &pid

            ; 2. 等待窗口出现（官方必用步骤）
            hwnd := WinWait("ahk_pid " pid, , 2)
            if (!hwnd)
                return

            ; 3. 官方激活（内部已含重试与 Alt 解锁）
            WinActivate(hwnd)

            ; 4. 确保窗口可见（防止被最小化/隐藏）
            WinRestore(hwnd)
            WinShow(hwnd)
            ; 下面是 Space+Alt 组合键的处理
        case "q":
            record_and_send "!{F4}"
        case "h": ; `cpaslock-h` 浏览器标签页历史向前，`capslock-l` 浏览器标签页历史向后 `alt-左``alt-右`
            record_and_send "!{Left}"
        case "l":
            record_and_send "!{Right}"
        case "zj":
            record_and_send "^!{F11}" ; 查看最近打开的文件列表
        case "fy":
            ; 打开translate界面
            record_and_send "^!t"
        default:
            ; 不匹配，小小提示音
            SoundPlay("*-1")
    }
}
; capslock引导的wait_input命令
capslock_command_wait_input(shortcutKeywords) {
    OutputDebug "进入 capslock_command_wait_input 函数"
    ; 设置小巧的窗口，位置居中，提示精简
    input := InputBox("输入命令：", "capslock命令", "W200 H60")

    ; 判断用户是否取消或关闭
    if input.Result = "Cancel"
        return
    ; 获取输入内容
    userInput := input.Value

    switch userInput {
        case "":
            ; 打开powertoys命令面板中的窗口切换器
            record_and_send "#{F12}"
        case "wt":
            Run "wt.exe --window new", , , &pid
            ; 2. 等待窗口出现（官方必用步骤）
            hwnd := WinWait("ahk_pid " pid, , 2)
            if (hwnd) {
                ; 3. 官方激活（内部已含重试与 Alt 解锁）
                WinActivate(hwnd)

                ; 4. 确保窗口可见（防止被最小化/隐藏）
                WinRestore(hwnd)
                WinShow(hwnd)
            }
        case "fy":
            ; 打开translate界面
            record_and_send "^!t"
        case "copyq":
            ; 打开 copyq 界面
            record_and_send "^!v" ; 打开 copyq 界面
        case "win l s":
            ; powertoys的light switch
            record_and_send "#{F5}"
        case "restart":
            record_and_send "^!r"
        case "pause":
            record_and_send "^!p"
        case "time":
            record_and_sendText FormatTime(A_Now, "yyyy-MM-dd HH:mm")
        case "review time":
            schedule := generate_review_schedule()
            A_Clipboard := schedule
        case "history":
            show_history
        default:
            ; 不匹配，交给热键映射
            capslock_command_hot_key userInput
    }
}

wait_input_init() {
    OutputDebug "进入 wait_input_init "
    global leader_hook_flag, CapsActive, SpaceActive, handler_mode, wait_input_hook_flag
    leader_hook_flag := false
    CapsActive := false
    SpaceActive := false
    handler_mode := "wait_input"
    wait_input_hook_flag := true
    ToolTip
    OutputDebug "退出 wait_input_init "
}

wait_input_destructor() {
    OutputDebug "进入 wait_input_destructor "
    global leader_hook_flag, CapsActive, SpaceActive, wait_input_hook_flag
    leader_hook_flag := true
    CapsActive := false
    SpaceActive := false
    handler_mode := "default"
    wait_input_hook_flag := false
    ToolTip
    OutputDebug "退出 wait_input_destructor "
}
