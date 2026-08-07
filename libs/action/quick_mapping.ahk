#Requires AutoHotkey v2.0

#Include record_send.ahk

global quick_map := Map()

; ---------- 全局配置 ----------
global quick_map := Map()
global quick_map_file := A_ScriptDir "\data\quick_mapping.txt"   ; 存储文件路径

; ---------- 加载持久化数据 ----------
load_quick_map() {
    global quick_map, quick_map_file
    if !FileExist(quick_map_file)
        return
    quick_map := Map()
    loop read, quick_map_file {
        line := RTrim(A_LoopReadLine, "`n`r")
        parts := StrSplit(line, "|")
        if parts.Length >= 2
            quick_map[parts[1]] := parts[2]
    }
}

; ---------- 保存持久化数据 ----------
save_quick_map() {
    global quick_map, quick_map_file
    content := ""
    if !FileExist(quick_map_file) {
        OutputDebug "quick mapping file path: " . quick_map_file
        ; 确保文件所在的目录存在
        SplitPath(quick_map_file, , &dir)
        if dir != ""
            DirCreate(dir)   ; 如果目录已存在，不会报错
        FileAppend(content, quick_map_file)
    }
    for key, val in quick_map
        content .= key "|" val "`n"
    FileDelete(quick_map_file)
    FileAppend(content, quick_map_file)
}

; ---------- 脚本初始化 ----------
load_quick_map()   ; 启动时加载

quick_mapping(cmd) {
    if SubStr(cmd, 1, 2) = "c " {
        OutputDebug("进入quick_mapping函数 c 分支，命令为: " . cmd)
        ; 首先获取当前选中内容
        selected_text := get_selected_text()
        OutputDebug "此时选中的内容 selected text：" . selected_text
        ; 如果没有选中内容，则获取剪切板内容
        if (selected_text = "") {
            selected_text := A_Clipboard
        }
        ; 将选中内容与cmd组合成一个唯一的键
        key := SubStr(cmd, 3)
        quick_map[key] := selected_text
        ; 持久化
        save_quick_map
        OutputDebug("已将选中内容映射到key: " . key . "，内容为: " . selected_text)
    } else if SubStr(cmd, 1, 2) = "p " {
        OutputDebug("进入quick_mapping函数 p 分支，命令为: " . cmd)
        ; 粘贴对应key的内容
        key := SubStr(cmd, 3)  ; 获取key
        if (quick_map.Has(key)) {
            SendText quick_map[key]
        }
    } else if cmd = "map" {
        show_quick_mapping
    } else {
        OutputDebug("quick_mapping函数未匹配到任何分支，命令为: " . cmd)
    }
}

get_selected_text() {
    OutputDebug "进入 get selected text 函数"
    Sleep 500 ; 等待窗口关闭后再复制
    ; 获取当前选中内容
    Send("^c") ; 复制选中内容到剪贴板
    Sleep 500
    return A_Clipboard
}

show_quick_mapping() {
    ; 创建 GUI
    my_gui := Gui()
    my_gui.Title := "📋 快捷映射 (双击复制并粘贴)"
    my_gui.Opt("+AlwaysOnTop +ToolWindow")
    my_gui.SetFont("s10")

    ; 创建 ListView（两列：键、值）
    lb := my_gui.Add("ListView", "w400 r15", ["键", "值"])
    lb.ModifyCol(1, 150)
    lb.ModifyCol(2, 200)

    ; 填充数据
    for key, val in quick_map {
        if IsObject(val)
            valStr := "[" Type(val) "]"
        else
            valStr := val
        lb.Add("", key, valStr)
    }

    ; 双击复制并粘贴
    lb.OnEvent("DoubleClick", (*) => SelectAndPaste(lb, my_gui))

    ; ---------- 按钮区域 ----------
    ; 复制并粘贴按钮
    btnPaste := my_gui.Add("Button", "Default w100", "复制并粘贴")
    btnPaste.OnEvent("Click", (*) => SelectAndPaste(lb, my_gui))

    ; 删除选中项按钮
    btnDelete := my_gui.Add("Button", "w100", "删除选中项")
    btnDelete.OnEvent("Click", (*) => DeleteSelectedItem(lb, my_gui))

    ; 取消按钮
    btnCancel := my_gui.Add("Button", "w100", "取消")
    btnCancel.OnEvent("Click", (*) => my_gui.Destroy())

    ; ESC 键关闭窗口
    my_gui.OnEvent("Escape", (*) => my_gui.Destroy())

    lb.Focus()
    if lb.GetCount() > 0
        Send("{Home}")

    my_gui.Show()
    return

    ; ---------- 内部函数：复制并粘贴 ----------
    SelectAndPaste(lb, my_gui) {
        row := lb.GetNext(0, "Focused")
        if row {
            text := lb.GetText(row, 2)
        } else {
            ToolTip("⚠️ 请先选中要操作的行")
            SetTimer(() => ToolTip(), -1500)
            return
        }
        can_copy_paste := text != ""
        if can_copy_paste {
            OutputDebug("复制粘贴文本: " . text)
            A_Clipboard := text
        }
        my_gui.Destroy()
        if can_copy_paste {
            record_and_send("^v")   ; 粘贴（确保窗口销毁后执行）
        }
    }

    ; ---------- 内部函数：删除选中项 ----------
    DeleteSelectedItem(lb, my_gui) {
        ; 获取当前选中的行（支持单选）
        row := lb.GetNext(0, "Focused")   ; 或使用 "Selected"
        if !row {
            ToolTip("⚠️ 请先选中要删除的行")
            SetTimer(() => ToolTip(), -1500)
            return
        }

        ; 获取第一列文本（键名）
        key := lb.GetText(row, 1)
        if key == "" {
            ToolTip("⚠️ 无法获取键名")
            SetTimer(() => ToolTip(), -1500)
            return
        }

        ; 从字典中删除
        if quick_map.Has(key) {
            quick_map.Delete(key)
            ; 从 ListView 中删除该行
            lb.Delete(row)
            ToolTip("✅ 已删除: " . key)
            SetTimer(() => ToolTip(), -1000)
        } else {
            ToolTip("⚠️ 键不存在于字典中")
            SetTimer(() => ToolTip(), -1000)
        }
    }
}
