#Requires AutoHotkey v2.0

#Include ../../leader.ahk
; 普通释放触发键的处理函数
KeysHandler(key) {
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
    global followingKeys
    ; 这里控制键我们不去重，因为有些组合快捷键是需要同时按下多个控制键的，比如 space-t-t-y
    ; 所以我们允许重复按下控制键，直接追加就行了
    followingKeys .= key
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
space_hotkey_handler() {
    global followingKeys, followingControlKeys, handler_id
    ; 普通释放触发快捷键的逻辑
    ; 如果有其他处理函数，那么不要再处理
    if handler_id != "" {
        return
    }
    shortcutKeywords := followingControlKeys . followingKeys ; 将控制键和普通键合并成一个字符串，方便后续的switch判断
    switch (shortcutKeywords) {
        case "f":
            Send "^f"  ; `space-f` 搜文件内容`ctrl-f`
        case "th":
            Send "^h"
        case "fd":
            Send "^+f"  ; `space-f-d`搜索目录内容 `ctrl-shift-f`
        case "fh":
            Send "^+a" ; `space-f-h`搜索文件路径 `ctrl-shift-a`
        case "l":
            Send "^l"  ; `space-l` 聚焦到地址栏 `ctrl-l`
        case "m":
            Send "^!m"  ; `space-m` 聚焦中部页面 `ctrl-alt-m`
        case "n":
            Send "^!n"  ; `space-n` 聚焦到非编辑控件 `ctrl-alt-n`
        case "k":
            Send "^+k"  ; `space-k` 跳出括号对 `ctrl-shift-k`
        case "e":
            ;Send "^+e"  ; `space-e` 光标行尾 end `ctrl-shift-e`
            Send "{End}" ; 这里是为了兼容一些不支持`ctrl-shift-e`的应用，比如Windows Terminal，直接发送End键就可以了
        case "b":
            ;Send "^+b"  ; `space-b` 光标行首 begin `ctrl-shift-b`
            Send "{Home}" ; 这里是为了兼容一些不支持`ctrl-shift-b`的应用，比如Windows Terminal，直接发送Home键就可以了
        case "dd":
            Send "^+d"  ; `space-d-d`删除行 `ctrl-shift-d`
        case "lc": ; 清空当前行`space-l-c` 清空当前行
            Send "{End}"
            Send "+{Home}"
            Sleep 50
            Send "{Delete}"
        case "db":
            ; `space-d-b`删除到行首
            Send "+{Home}"
            Sleep 50
            Send "{Delete}"
        case "de":
            ; `space-d-e`删除到行尾
            Send "+{End}"
            Sleep 50
            Send "{Delete}"
        case "cls":
            Send "^+!c"  ; `space-c-l-s`清空终端 `ctrl-shift-alt-c`
        case "x":
            Send "{Delete}"  ; `space-x`删除当前字符 `delete`
        case "gg":
            Send "^{Home}"  ; `space-g-g`跳转到文件开头 `ctrl-home`
        case "Shiftg":
            Send "^{End}"  ; `space-Shift-g`跳转到文件结尾 `ctrl-end`
        case "s":
            Send "^s"  ; Ctrl+S 保存
        case "a":
            Send "^a"  ; Ctrl+A 全选
        case "c":
            Send "^c"  ; Ctrl+C 复制
        case "v":
            Send "^v"  ; Ctrl+V 粘贴
        case "vv":
            Send "^!v" ; 打开ditto剪切板界面
        case "ca":
            Send "^+c" ; 复制到ditto复制缓冲区 A 号
        case "cb":
            Send "^+g" ; 复制到ditto复制缓冲区 B 号
        case "cc":
            Send "^+h" ; 复制到ditto复制缓冲区 C 号
        case "cd":
            Send "^!+i" ; 复制到ditto复制缓冲区 D 号
        case "x":
            Send "^x"  ; Ctrl+X 剪切
        case "gb":
            Send "^+!u"  ; `space-g-b` 跳转go back `ctrl-shift-alt-u`
        case "gf":
            Send "^+!x"  ; `space-g-f` 跳转go forward `ctrl-shift-alt-x`
        case "zx":
            Send "+!x" ; `space-z-x`焦点在组视窗的下一个 `shift-alt-x`
        case "zy":
            Send "+!y" ; `space-z-y`焦点在组视窗的下一个 `shift-alt-y`
        case "zu":
            Send "+!u"  ; `space-z-u`焦点在组视窗的上一个 `shift-alt-u`
        case "zz":
            Send "+!z"  ; `space-z-z`焦点在组视窗的上一个 `shift-alt-z`
        case "z1":
            Send "^+!1"  ; `space-z-1`焦点在组1 `ctrl-shift-alt-1`
        case "z2":
            Send "^+!2"  ; `space-z-2`焦点在组2 `ctrl-shift-alt-2`
        case "z3":
            Send "^+!3"  ; `space-z-3`焦点在组3 `ctrl-shift-alt-3`
        case "z4":
            Send "^+!4"  ; `space-z-4`焦点在组4 `ctrl-shift-alt-4`
        case "Altks":
            Send "^!k"  ; `space-alt-k-s`打开快捷键页面 `ctrl-alt-k`
        case "RAltks":
            Send "^!k"  ; `space-alt-k-s`打开快捷键页面 `ctrl-alt-k`
            ; 下面是视角切换的处理
        case "Altl1":
            Send "^!1"  ; `space-alt-l-1`组视窗有 1列 `ctrl-alt-1`
        case "Altl2":
            Send "^!2"  ;   `space-alt-l-2`组视窗有 2列 `ctrl-alt-2`
        case "Alth2":
            Send "+!2"  ; `space-alt-h-2`组视窗有 2行 `shift-alt-2`
        case "Alth1":
            Send "^!1"  ; `space-alt-h-1`组视窗有 1行 `ctrl-alt-1`
        case "Altwg":
            Send "^!g"  ; `space-alt-w-g`组视窗呈网格 4窗 `ctrl-alt-g`
        case "Altux":
            Send "^!x"  ; `space-alt-u-x`组视窗向下生，并复制当前的文件编辑视图 `ctrl-alt-x`
        case "Altuy":
            Send "^!y"  ; `space-alt-u-y`组视窗向右生，并复制当前的文件编辑视图 `ctrl-alt-y`
        case "Altuz":
            Send "^!z"  ; `space-alt-u-z` `ctrl-alt-z`
        case "Altu":
            Send "^!u"  ; `space-alt-u` `ctrl-alt-u`
        case "Altuj":
            Send "^!j"  ; `space-alt-u-j`视角的意思，内容视角生 同样也是回收视角 `ctrl-alt-j`
        case "Altls":
            Send "^!l"  ; 'space-alt-l-s' 切换黑白模式 `ctrl-alt-l`
        case "Altqp":
            Send "{F11}"
        case "cn":
            Send "^+9" ;`space-c-n`切换中文`space-e-n`切换英文 `ctrl-shift-9` `ctrl-shift-8`
        case "en":
            Send "^+8" ; `space-c-n`切换中文`space-e-n`切换英文 `ctrl-shift-9` `ctrl-shift-8`
        case "o":
            Send "{End}{Enter}"
        case "Shifto":
            Send "{Up}"
            Sleep 100
            Send "{End}{Enter}"
        default:
            switch {
                case RegExMatch(shortcutKeywords, "^(\d+)$", &priceMatch): ; 匹配纯数字格式
                    ; 提取匹配到的数字转换
                    times := Integer(priceMatch[1])
                    if times < 1 {
                        times := 1
                    }
                    JumpToLine(times)
                case RegExMatch(shortcutKeywords, "^(\d+)([hjkl])$", &priceMatch): ; 匹配纯数字格式hjkl结尾
                    ; 提取匹配到的数字转换
                    times := Integer(priceMatch[1])
                    if times < 1 {
                        times := 1
                    }
                    switch priceMatch[2] {
                        case "h":
                            Send "{Left " . times . "}"
                        case "j":
                            Send "{Down " . times . "}"
                        case "k":
                            Send "{Up " . times . "}"
                        case "l":
                            Send "{Right " . times . "}"
                    }

                default:
                    ; 不匹配，小小提示音
                    SoundPlay("*-1")
            }

    }
}

; CapsLock Leader释放时处理 hotkey 映射的函数
caps_lock_hotkey_handler() {
    global followingKeys, followingControlKeys, handler_id
    ; 普通释放触发快捷键的逻辑
    ; 如果有命令处于预备状态，而将输入交给默认处理的话，说明用户输入的命令并非准备的命令。
    if handler_id != "" {
        handler_id := ""
    }
    shortcutKeywords := followingControlKeys . followingKeys ; 将控制键和普通键合并成一个字符串，方便后续的switch判断
    switch (shortcutKeywords) {
        case "o":
            Send "^o"  ; `caplock-o`打开文件`ctrl-o`
        case "od":
            Send "^+o"  ; `caplock-o-d`打开文件夹`ctrl-shift-o`
        case "fr":
            Send "^+r"  ; `caplock-f-r`设置文件的只读性 `ctrl-shift-r`
        case "t":
            Send "^+!t"        ;`caplock-t` 跳到文件（内部搜索并打开）ctrl-shfit-alt-t
        case "c":
            Send "^{F4}"  ; `caplock-c` 关闭当前文件 `ctrl-F4`
        case "n":
            Send "^n"  ; `caplock-n` 新建文件 `ctrl-n`
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
            Send "!{F4}"
        case "h": ; `cpaslock-h` 浏览器标签页历史向前，`capslock-l` 浏览器标签页历史向后 `alt-左``alt-右`
            Send "!{Left}"
        case "l":
            Send "!{Right}"
        case "zj":
            Send "^!{F11}" ; 查看最近打开的文件列表
        default:
            ; 不匹配，小小提示音
            SoundPlay("*-1")
    }
}
