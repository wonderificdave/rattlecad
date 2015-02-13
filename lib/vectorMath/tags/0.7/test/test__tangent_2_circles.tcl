puts "\n\n ====== I N I T ============================ \n\n"

    # -- ::APPL_Config(BASE_Dir)  ------
    set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
        puts "   -> \$BASE_Dir:   $BASE_Dir\n"

        # -- Libraries  ---------------
    lappend auto_path           [file join $BASE_Dir lib]
    lappend auto_path           [file join $BASE_Dir ..]
        # puts "   -> \$auto_path:  $auto_path"

        # -- Packages  ---------------
    package require   Tk    
    package require   vectormath    
    package require   appUtil
    
    proc updateCanvas {args} {
    
        variable radius_1
        variable radius_2
        variable type
        variable side
        
        .c delete "all"
        
        set p1 {220 380}
        set p2 {380 220}
        set r1  $radius_1
        set r2  $radius_2
        puts "     \$p1 \$r1 ....   $p1    $r1"
        puts "     \$p2 \$r2 ....   $p2    $r2"
        foreach {x1 y1} $p1 break
        foreach {x2 y2} $p2 break
            #
        .c create line   $x1 $y1 $x2 $y2 -fill red -width 2
        .c create oval   [expr $x1 - 2]   [expr $y1 - 2]   [expr $x1 + 2]   [expr $y1 + 2]   -outline blue -width 2
        .c create oval   [expr $x1 - $r1] [expr $y1 - $r1] [expr $x1 + $r1] [expr $y1 + $r1] -outline blue -width 2
        .c create oval   [expr $x2 - $r2] [expr $y2 - $r2] [expr $x2 + $r2] [expr $y2 + $r2] -outline blue -width 2
        
            # outside right
        if {[catch {set vctTngt [vectormath::tangent_2_circles $p1 $p2 $r1 $r2 $type $side]} errMsg]} {
            puts " -- <E> -----------------"
            puts "ErrorMsg:  $errMsg"
            #puts "ErrorCode: $errorCode"
            #puts "ErrorInfo:\n$errorInfo\n"
            puts " -- <E> -----------------"
            return
        }
        set p01 [lindex $vctTngt 0]
        set p02 [lindex $vctTngt 1]
        puts "------"
        puts "     \$p1 \$p01 ....   $p1    $p01"
        puts "     \$p2 \$p02 ....   $p2    $p02"
        foreach {x1 y1} $p01 break
        foreach {x2 y2} $p02 break
        .c create line   $x1 $y1 $x2 $y2 -fill green -width 1
        .c create oval   [expr $x1 - 2] [expr $y1 - 2] [expr $x1 + 2] [expr $y1 + 2] -outline red -width 2
            #

    }

    
    variable radius_1 90
    variable radius_2 50
    variable type     outside
    variable side     right
    
    canvas .c -background white -width 600 -height 600
    pack   .c -fill both
    pack [scale  .scale_r1 -label "radius 1" -orient horizontal -variable radius_1 -length 100 -from 0 -to 150 -tickinterval 50 -command "updateCanvas"] -fill both
    pack [scale  .scale_r2 -label "radius 2" -orient horizontal -variable radius_2 -length 100 -from 0 -to 140 -tickinterval 50 -command "updateCanvas"] -fill both
    pack [radiobutton .type_out -text outside -variable type -value outside]
    pack [radiobutton .type_in  -text inside  -variable type -value inside]
    pack [radiobutton .side_right -text right -variable side -value right]
    pack [radiobutton .side_left  -text left  -variable side -value left]
    pack [button .b -text update -command "updateCanvas"]
    
    
    updateCanvas