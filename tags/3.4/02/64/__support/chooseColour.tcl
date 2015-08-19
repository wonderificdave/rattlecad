variable colorCode {}

proc doIt {widget text} {
    variable colorCode
    set current_color \
        [tk_chooseColor -title "Choose a background color" -parent .]
        #
    $widget configure -background $current_color
    $text   delete 1.0 end
    $text   insert end $current_color
        #
    set colorCode $current_color
    return $colorCode 
}
button .b -text "Choose a color..." \
        -command "doIt .l .t" \
        -width 25
label  .l -textvariable colorCode \
        -width 25
text   .t -width 25 \
          -height 5
    #
grid .b -row 0 -column 0
grid .l -row 1 -column 0
grid .t -row 2 -column 0