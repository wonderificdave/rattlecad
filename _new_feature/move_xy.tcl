


set input { 28 -2152    74 -2192  121 -2253   142 -2321   118 -2405 
							  93 -2438    53 -2448   53 -2351    49 -2330    43 -2312 
							  27 -2293     6 -2287  -11 -2288   -25 -2294   -40 -2305 
						     -46 -2318   -51 -2333  -48 -2450   -94 -2438  -130 -2387 
						    -145 -2276  -213 -2165}
     
set tr {0 2339}
set dx [expr [lindex $tr 0]]
set dy [expr [lindex $tr 1]]

     
#puts $input
#puts [llength $input]

set i  0
set k  0
set output {}
while {$i < [llength $input]} {
      # puts "   $i   - [lindex $input $i] --  [expr $dx + [lindex $input $i]]"
    set new_x [expr $dx + [lindex $input $i]]
    set i [expr $i + 1]
    
      # puts "   $i   - [lindex $input $i] --  [expr $dy + [lindex $input $i]]"
    set new_y [expr $dy + [lindex $input $i]]
    set i [expr $i + 1]
    
    if {$k < 5 } {
        set output [concat $output  $new_x  $new_y ]
        set k [expr $k + 1]
    } else {
        puts "[concat $output $new_x  $new_y] \\"
        set output {}
        set k 0
    }

} 

if {$k > 0 } {
    puts "[concat $output] \\  rest"
}




