package require Tk

catch {console show}

proc drag.canvas.item {canWin item newX newY} {
    set xDiff [expr {$newX - $::x}]
    set yDiff [expr {$newY - $::y}]

    set ::x $newX
    set ::y $newY

    puts "  ... $item $xDiff -> $newX"
    puts "  ... $item $yDiff -> $newY"
    $canWin move $item $xDiff $yDiff
}

pack [canvas .c] -expand 1 -fill both
button .b1 -text "Test Button 1"
button .b2 -text "Test Button 2"
set id1 [.c create window 100 100 -window .b1]
set id2 [.c create window 100 130 -window .b2]

bind .b1 <3> {
    set ::x %X
    set ::y %Y
}
bind .b1 <B3-Motion> [list drag.canvas.item .c $id1 %X %Y]

bind .b2 <3> {
    set ::x %X
    set ::y %Y
}
bind .b2 <B3-Motion> [list drag.canvas.item .c $id2 %X %Y]