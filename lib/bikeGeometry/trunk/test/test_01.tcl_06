puts "\n\n ====== I N I T ============================ \n\n"

    # -- ::APPL_Config(BASE_Dir)  ------
    set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
        puts "   -> \$BASE_Dir:   $BASE_Dir\n"

        # -- Libraries  ---------------
    lappend auto_path           [file join $BASE_Dir lib]
    lappend auto_path           [file join $BASE_Dir ..]
        # puts "   -> \$auto_path:  $auto_path"

        # -- Packages  ---------------
    package require   bikeGeometry  1.28
    package require   vectormath    
    package require   appUtil
    
    #
    #
    #
set radFactor               [expr $vectormath::CONST_PI/180]
    #
#   HeadTubeAngle    68,281
set HeadTubeAngle       291.719 ; #-D1  ;#HeadTubeAngle    68,281 
set HeadTubeAngle       291.719 ; #-D1  ;#HeadTubeAngle    68,281 

# -- direction - HeadTube
# ----------------------------------------------------
proc frame_Lug_Determination {headTubeAngle} {
            #
        # return 1    
            #
            
        # puts "\n"
        # puts " ==- COMPILE -========================="
            #
        set radFactor           [expr $vectormath::CONST_PI/180]
            #
            #
        set HeadTubeAngle       [expr 360 - $headTubeAngle]
            #
        #puts "              ... $HeadTubeAngle / $headTubeAngle"    
            #
        set StemAngle           0   ; #-C5
        set ChainStay_SeatTube  64  ; #-C6
        set SeatTube_DownTube   60  ; #-C7
        set DownTube_HeadTube   61  ; #-C8
        set ChainStay_DownTube  [expr $ChainStay_SeatTube + $SeatTube_DownTube] ; #-C9
        set ChainStay_HeadTube  [expr $ChainStay_SeatTube + $SeatTube_DownTube - $DownTube_HeadTube]; #-C10                    
            #
        set Reach               481   ; #-C13
        set Stack               635   ; #-C13
        set StemLength          110   ; #-C14
        set ChainStayOffset     15    ; #-C15
        set ChainStay           410   ; #-C16
        set ForkHeight          450   ; #-C17
        set ForkRake            45    ; #-C18
            #
        set DownTubeAngle   [expr $HeadTubeAngle - $DownTube_HeadTube]  
            #
        set res_Stem_x      [expr $Reach + $StemLength*cos($radFactor * ($HeadTubeAngle - 90 + $StemAngle))]   
        set res_Stem_y      [expr $Stack + $StemLength*sin($radFactor * ($HeadTubeAngle - 90 + $StemAngle))] 
        set Stem_Position   [list $res_Stem_x $res_Stem_y]
            #
        set dist_Stem_BB    [expr sqrt(pow($res_Stem_x,2) + pow($res_Stem_y,2))]
                #
        set dir_HeadTube    [vectormath::rotateLine {0 0} 1 $HeadTubeAngle]        
        set dir_DownTube    [vectormath::rotateLine {0 0} 1 $DownTubeAngle]        
            #
        set det_Point       [vectormath::intersectPointVector {0 0} $dir_DownTube [list $res_Stem_x $res_Stem_y] $dir_HeadTube]  
        set detPoint_x      [lindex $det_Point 0]
        set detPoint_y      [lindex $det_Point 1]
            #
        set HeadTubeLength  [vectormath::length $Stem_Position $det_Point]
                
            #
            # -- FrontWheel
            # ----------------------------------------------------
        set res_FrontWheel_x [expr \
                                $detPoint_x \
                            +   $ForkHeight         * cos($radFactor *  $HeadTubeAngle)        \
                            +   $ForkRake           * cos($radFactor * ($HeadTubeAngle - 270)) \
                        ]
        set res_FrontWheel_y [expr \
                                $detPoint_y \
                            +   $ForkHeight         * sin($radFactor *  $HeadTubeAngle)        \
                            +   $ForkRake           * sin($radFactor * ($HeadTubeAngle - 270)) \
                        ]
            #
            # -- RearWheel
            # ----------------------------------------------------

        set res_RearWheel_x [expr \
                            +   $ChainStayOffset    * cos($radFactor * ($HeadTubeAngle - $DownTube_HeadTube + $ChainStay_DownTube - 270))   \
                            +   $ChainStay          * cos($radFactor * ($HeadTubeAngle - $DownTube_HeadTube + $ChainStay_DownTube - 180))   \
                        ]
        set res_RearWheel_y [expr \
                                $ChainStayOffset    * sin($radFactor * ($HeadTubeAngle - $DownTube_HeadTube + $ChainStay_DownTube - 270))   \
                            +   $ChainStay          * sin($radFactor * ($HeadTubeAngle - $DownTube_HeadTube + $ChainStay_DownTube - 180))   \
                        ]
            #
            # -- check offset
            # ----------------------------------------------------
            #
        set checkOffset [expr $res_RearWheel_y - $res_FrontWheel_y]
            #
        if 0 {
            puts "              ... $HeadTubeAngle / $headTubeAngle"    
            puts "              Stem ............ $res_Stem_x / $res_Stem_y"
            puts "                  dir_HeadTube ...... $dir_HeadTube"
            puts "              ... \$DownTubeAngle   $DownTubeAngle"  
            puts "                  dir_DownTube ...... $dir_DownTube"
            puts "              ... det_Point ... $det_Point"
            puts "              ... $detPoint_x / $detPoint_y     ... $HeadTubeLength\n"
            puts "              FrontWheel ...... $res_FrontWheel_x / $res_FrontWheel_y"
            puts "              RearWheel ....... $res_RearWheel_x / $res_RearWheel_y"  
            puts "        ... $checkOffset"
        }
        if 0 {
            puts "        ... $HeadTubeAngle / $headTubeAngle"    
            puts "              ... det_Point ... $det_Point"
            puts "              FrontWheel ...... $res_FrontWheel_x / $res_FrontWheel_y"
            puts "              RearWheel ....... $res_RearWheel_x / $res_RearWheel_y"  
            puts "        ... $checkOffset"
        }
            #
        return $checkOffset   
            #   
}       

if 0 {
    # frame_Lug_Determination [expr 360 - 291.719]
    puts "           --------"
    frame_Lug_Determination 72.75
    puts "           --------"
    frame_Lug_Determination 72.8
    puts "           --------"
    frame_Lug_Determination 72.85
    puts "           --------"
    exit
}

set lastValue 0
set ht_angle 69.5
set expectedOffset 10
while {$ht_angle < 71.5} {
    # set angle [expr 360 - $ht_angle]
    # puts "  [format {%8.4f} $ht_angle]"
    set value [frame_Lug_Determination $ht_angle]
    if {[expr abs($value-$expectedOffset) / $expectedOffset] < 0.1} {
        puts "  [format {%12.4f  %12.8f} $ht_angle $value]  ... [expr $value - $lastValue] <--- $ht_angle"
    } else {
        puts "  [format {%12.4f  %12.8f} $ht_angle $value]  ... [expr $value - $lastValue]"
    }
    set lastValue $value
    set ht_angle [expr $ht_angle + 0.05]
}
