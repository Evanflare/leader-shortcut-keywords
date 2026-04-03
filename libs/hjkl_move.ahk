#Requires AutoHotkey v2.0

; 这是一个库文件，提供了基于hjkl键的移动功能。

#Include ..\leaders.ahk

; 判断：如果followingKeys 中的字符等同当前按下的key，则说明是单纯的hjkl移动，否则说明是其他功能，直接调用KeysHandler处理
leaderMoveKeyHandler(key, followingKeys) {
    if followingKeys != key {
        KeysHandler(key) ;如果有其他键被按下，说明不是单纯的hjkl移动，直接返回
    } else {
        switch key {
            case "h":
                Send "{Left}"
            case "j":
                Send "{Down}"
            case "k":
                Send "{Up}"
            case "l":
                Send "{Right}"
        }
    }
}
