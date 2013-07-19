package require Tk

catch {console show}

proc drag.canvas.item {canWin item newX newY} {
    set xDiff [expr {$newX - $::x}]
    set yDiff [expr {$newY - $::y}]

    set ::x $newX
    set ::y $newY

    puts $xDiff
    puts $yDiff
    $canWin move $item $xDiff $yDiff
}

pack [canvas .c] -expand 1 -fill both
button .b -text "Test Button"
set id [.c create window 100 100 -window .b]

bind .b <3> {
    set ::x %X
    set ::y %Y
}
bind .b <B3-Motion> [list drag.canvas.item .c $id %X %Y]