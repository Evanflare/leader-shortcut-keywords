#Requires AutoHotkey v2.0

; 生成复习间隔日期表的函数
generate_review_schedule() {
    today := A_Now
    originalDate := FormatTime(today, "yyyy-M-d")
    days := [1, 3, 7, 15, 30, 100]

    output := "📋 复习间隔日期表：`n"
    output .= "[原始日期]  ``已复习时间" originalDate "```n"

    current := today   ; 从今天开始累加
    for day in days {
        current := DateAdd(current, day, "days")   ; 基于上一次日期累加
        futureDate := FormatTime(current, "yyyy-M-d")
        dayStr := Format("{:3}", day)
        output .= "[+" dayStr "天]   ``复习时间" futureDate "```n"
    }

    return RTrim(output, "`n")
}
