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
namespace eval lugGeometry {
            #
        variable radFactor                  [expr $vectormath::CONST_PI/180]
            #
        variable printDebug                 0
            #
        variable angle_Stem                 ; set angle_Stem                0   ; #-C5
        variable angle_ChainStaySeatTube    ; set angle_ChainStaySeatTube   64  ; #-C6
        variable angle_SeatTubeDownTube     ; set angle_SeatTubeDownTube    60  ; #-C7
        variable angle_DownTubeHeadTube     ; set angle_DownTubeHeadTube    61  ; #-C8
            #
        variable Reach                      ; set Reach                     481 ; #-C13
        variable Stack                      ; set Stack                     635 ; #-C13
        variable StemLength                 ; set StemLength                110 ; #-C14
        variable ChainStayOffset            ; set ChainStayOffset           15  ; #-C15
        variable ChainStay                  ; set ChainStay                 410 ; #-C16
        variable ForkRake                   ; set ForkRake                  45  ; #-C18    
            #               
        variable DownTubeDiameter           ; set DownTubeDiameter          31.8
        variable HeadTubeDiameter           ; set HeadTubeDiameter          36
        variable HeadTubeDownTubeOffset     ; set HeadTubeDownTubeOffset    8.5
        variable HeadSetHeight              ; set HeadSetHeight             13.5
        variable ForkHeight                 ; set ForkHeight                365
            #               
        variable FrontWheelRadius           ; set FrontWheelRadius          326 
        variable RearWheelRadius            ; set RearWheelRadius           336 
            #
}
proc lugGeometry::frame_Lug_Determination {headTubeAngle} {
            #
        variable radFactor         
        variable printDebug        
            #
        variable angle_Stem         
        variable angle_ChainStaySeatTube
        variable angle_SeatTubeDownTube 
        variable angle_DownTubeHeadTube 
            #
        variable Reach             
        variable Stack             
        variable StemLength        
        variable ChainStayOffset   
        variable ChainStay         
        variable ForkHeight        
        variable ForkRake          
            #
        variable DownTubeDiameter       
        variable HeadTubeDiameter       
        variable HeadTubeDownTubeOffset 
        variable HeadSetHeight          
        variable ForkHeight             
            #
        variable FrontWheelRadius  
        variable RearWheelRadius   
            #
            #
        # puts "\n"
        # puts " ==- COMPILE -========================="
            #
        set angle_HeadTube   [expr 360 - $headTubeAngle]
            # -- printDebug ---------------
        if $printDebug {
            puts "\n\n"
            puts "\n -- angle_HeadTube -------------\n"
            puts "      ->  $headTubeAngle"
            puts "      ... $angle_HeadTube"
        }
            #
        set angle_DownTube  [expr $angle_HeadTube - $angle_DownTubeHeadTube] 
        set StemLengthEff   [expr $StemLength * cos($radFactor * $angle_Stem)]    
            #
            # -- printDebug ---------------
        if $printDebug {
            puts "\n -- StemLengthEff --------------\n"
            puts "          ... $StemLengthEff"
        }
            #
        set res_Stem_x      [expr $Reach + $StemLengthEff*cos($radFactor * ($angle_HeadTube - 90))]   
        set res_Stem_y      [expr $Stack + $StemLengthEff*sin($radFactor * ($angle_HeadTube - 90))] 
        set Stem_Position   [list $res_Stem_x $res_Stem_y]
            #
            # -- printDebug ---------------
        if $printDebug {
            puts "\n -- Stem_Position --------------\n"
            puts "                  ... [expr $StemLengthEff*cos($radFactor * ($angle_HeadTube - 90))]"
            puts "                  ... [expr $StemLengthEff*sin($radFactor * ($angle_HeadTube - 90))]"
            puts "                  $res_Stem_x"
            puts "                  $res_Stem_y"
        }
            #
        set dir_HeadTube    [vectormath::rotateLine {0 0} 1 $angle_HeadTube]        
        set dir_DownTube    [vectormath::rotateLine {0 0} 1 $angle_DownTube]        
            #
        set det_Point       [vectormath::intersectPointVector {0 0} $dir_DownTube [list $res_Stem_x $res_Stem_y] $dir_HeadTube]  
        set detPoint_x      [lindex $det_Point 0]
        set detPoint_y      [lindex $det_Point 1]
            #
        set HeadTubeLength  [vectormath::length $Stem_Position $det_Point]
            #
            # -- printDebug ---------------
        if $printDebug {
            puts "\n -- HeadTubeLength -------------\n"
            puts "                  $detPoint_x"
            puts "                  $detPoint_y"
            puts "          ... $HeadTubeLength"
        }
        
            #
            # -- Fork, part along HeadTube ... intersection with Downtube
            # ----------------------------------------------------
            #
        set ForkHeightCompl [expr \
                                $DownTubeDiameter * 0.5 * sin($radFactor *  $angle_DownTubeHeadTube)    \
                            +   ($DownTubeDiameter * 0.5 * cos($radFactor *  $angle_DownTubeHeadTube)    \
                                +   $HeadTubeDiameter * 0.5) / tan($radFactor *  $angle_DownTubeHeadTube)    \
                            +   $HeadTubeDownTubeOffset \
                            +   $HeadSetHeight          \
                            +   $ForkHeight             \
                         ]
            # -- printDebug ---------------
        if $printDebug {
            puts "\n -- ForkHeightCompl ------------\n"
            puts "                  [expr $DownTubeDiameter * 0.5 * sin($radFactor *  $angle_DownTubeHeadTube)]"
            puts "                  [expr ($DownTubeDiameter * 0.5 * cos($radFactor *  $angle_DownTubeHeadTube)    \
                                        +   $HeadTubeDiameter * 0.5) / tan($radFactor *  $angle_DownTubeHeadTube)]"
            puts "                  $HeadTubeDownTubeOffset"
            puts "                  $HeadSetHeight         "
            puts "                  $ForkHeight            "
            puts "          ... $ForkHeightCompl"
        }
        
            #
            # -- FrontWheel
            # ----------------------------------------------------
            #
        set res_FrontWheel_x [expr \
                                $detPoint_x \
                            +   $ForkHeightCompl * cos($radFactor *  $angle_HeadTube)        \
                            +   $ForkRake        * cos($radFactor * ($angle_HeadTube - 270)) \
                        ]
        set res_FrontWheel_y [expr \
                                $detPoint_y \
                            +   $ForkHeightCompl * sin($radFactor *  $angle_HeadTube)        \
                            +   $ForkRake        * sin($radFactor * ($angle_HeadTube - 270)) \
                        ]
            # -- printDebug ---------------
        if $printDebug {
            puts "\n -- FrontWheel -----------------\n"
            puts "                  $detPoint_x"
            puts "                  [expr $ForkHeightCompl * cos($radFactor *  $angle_HeadTube)]"
            puts "                  [expr $ForkRake        * cos($radFactor * ($angle_HeadTube - 270))]"
            puts "          ... $res_FrontWheel_x"
            puts "                  $detPoint_y"
            puts "                  [expr $ForkHeightCompl * sin($radFactor *  $angle_HeadTube)]"
            puts "                  [expr $ForkRake        * sin($radFactor * ($angle_HeadTube - 270))]"
            puts "          ... $res_FrontWheel_y"
        }
            #
            # -- RearWheel
            # ----------------------------------------------------
            #
        set angle_ChainStay [expr $angle_HeadTube - $angle_DownTubeHeadTube - (180 - $angle_ChainStaySeatTube - $angle_SeatTubeDownTube)]
            # puts $angle_ChainStay
        set res_RearWheel_x [expr \
                            +   $ChainStayOffset * cos($radFactor * ($angle_ChainStay - 90))   \
                            +   $ChainStay       * cos($radFactor * ($angle_ChainStay))   \
                        ]
        set res_RearWheel_y [expr \
                                $ChainStayOffset * sin($radFactor * ($angle_ChainStay - 90))   \
                            +   $ChainStay       * sin($radFactor * ($angle_ChainStay))   \
                        ]
            # -- printDebug ---------------
        if $printDebug {
            puts "\n -- RearWheel -----------------\n"
            puts "                  $angle_HeadTube °"
            puts "                  $angle_DownTubeHeadTube °"
            puts "                  $angle_ChainStaySeatTube °"
            puts "                  $angle_SeatTubeDownTube °"
            puts "          ... $angle_ChainStay °"
            puts "                  [expr $ChainStayOffset * cos($radFactor * ($angle_ChainStay - 90))]"
            puts "                  [expr $ChainStay       * cos($radFactor * ($angle_ChainStay))]"
            puts "          ... $res_RearWheel_x"
            puts "                  [expr $ChainStayOffset * sin($radFactor * ($angle_ChainStay - 90))]"
            puts "                  [expr $ChainStay       * sin($radFactor * ($angle_ChainStay))]"
            puts "          ... $res_RearWheel_y"
        }
            #
            # -- check offset
            # ----------------------------------------------------
            #
        set vert_WheelOffset    [expr $RearWheelRadius - $FrontWheelRadius] 
        set res_WheelOffset     [expr $res_RearWheel_y - $res_FrontWheel_y]

            #
        set delta               [expr $res_WheelOffset - $vert_WheelOffset]
            #
            #
            # -- printDebug ---------------
        if $printDebug {
            puts "\n -- delta ---------------------\n"
            puts "                  $vert_WheelOffset ($RearWheelRadius - $FrontWheelRadius)"
            puts "                  $res_WheelOffset (res_RearWheel_y - $res_FrontWheel_y)"
            puts "      ->  [format {%12.8f} $delta]"
            puts "\n\n"
        }
            #
        return $delta   
            #   
}       

proc lugGeometry::find_HT_Angle {border} {
            #
            # puts "   <I> \$border ... $border"
        foreach {startAngle endAngle} $border break
            #
        if {$startAngle != $endAngle} {
            set maxLoops 20
        } else {
            set maxLoops 1
        }
            #
        set rangeAngle  [expr $endAngle - $startAngle]
        set stepAngle   [expr 1.0*$rangeAngle / $maxLoops]
            #
        set lastAngle   $startAngle  
        set chgBorder   0      
        set lastValue   0      
            #
           # puts "   < $startAngle - $endAngle >"
           # puts "       \$rangeAngle ... $rangeAngle"
           # puts "       \$stepAngle .... $stepAngle"
            #
        puts "   ... $startAngle °"
        for {set i 0} {$i <= $maxLoops} {incr i} {
            set ht_angle [expr $startAngle + $i*$stepAngle]
                #puts "           \$ht_angle .... $ht_angle"
            set value [lugGeometry::frame_Lug_Determination $ht_angle]
                # puts "                        ... $value"
            set chgBorder [expr $value/$lastValue]
                # puts "                        ... $chgBorder"
            if {$chgBorder < 0} {
                    # puts "                        ... $lastAngle .... $lastValue"
                    # puts "                        ... $ht_angle .... $value"
                return [list $lastAngle $ht_angle]
            } else {
                set lastAngle $ht_angle
                set lastValue $value
            }
        }
            #
        return $lastAngle     
}
proc set_testCase {testCaseName} {
            #
        switch -exact $testCaseName {
            delta_0 {
                    set lugGeometry::angle_Stem              6
                    set lugGeometry::angle_ChainStaySeatTube 64.43
                    set lugGeometry::angle_SeatTubeDownTube  59.97
                    set lugGeometry::angle_DownTubeHeadTube  60.97

                    set lugGeometry::Reach                   481
                    set lugGeometry::Stack                   635
                    set lugGeometry::StemLength              110
                    set lugGeometry::ChainStayOffset         1.3
                    set lugGeometry::ChainStay               410
                    set lugGeometry::ForkRake                45
                            
                    set lugGeometry::DownTubeDiameter        31.8
                    set lugGeometry::HeadTubeDiameter        36
                    set lugGeometry::HeadTubeDownTubeOffset  8.5
                    set lugGeometry::HeadSetHeight           13.5
                    set lugGeometry::ForkHeight              365

                    set lugGeometry::FrontWheelRadius        336
                    set lugGeometry::RearWheelRadius         336   
            }
            delta_108 {
                    set lugGeometry::angle_Stem              6
                    set lugGeometry::angle_ChainStaySeatTube 64.43
                    set lugGeometry::angle_SeatTubeDownTube  70.46
                    set lugGeometry::angle_DownTubeHeadTube  71.46

                    set lugGeometry::Reach                   481
                    set lugGeometry::Stack                   635
                    set lugGeometry::StemLength              110
                    set lugGeometry::ChainStayOffset         1.3
                    set lugGeometry::ChainStay               410
                    set lugGeometry::ForkRake                45
                            
                    set lugGeometry::DownTubeDiameter        31.8
                    set lugGeometry::HeadTubeDiameter        36
                    set lugGeometry::HeadTubeDownTubeOffset  8.5
                    set lugGeometry::HeadSetHeight           13.5
                    set lugGeometry::ForkHeight              365

                    set lugGeometry::FrontWheelRadius        228
                    set lugGeometry::RearWheelRadius         336   
            }
        }
}
    #
set_testCase delta_108
set_testCase delta_0
    #
puts "   ======================================================="
puts "      lugGeometry::angle_Stem               $lugGeometry::angle_Stem             "
puts "      lugGeometry::angle_ChainStaySeatTube  $lugGeometry::angle_ChainStaySeatTube"
puts "      lugGeometry::angle_SeatTubeDownTube   $lugGeometry::angle_SeatTubeDownTube "
puts "      lugGeometry::angle_DownTubeHeadTube   $lugGeometry::angle_DownTubeHeadTube "
puts "      "
puts "      lugGeometry::Reach                    $lugGeometry::Reach                  "
puts "      lugGeometry::Stack                    $lugGeometry::Stack                  "
puts "      lugGeometry::StemLength               $lugGeometry::StemLength             "
puts "      lugGeometry::ChainStayOffset          $lugGeometry::ChainStayOffset        "
puts "      lugGeometry::ChainStay                $lugGeometry::ChainStay              "
puts "      lugGeometry::ForkRake                 $lugGeometry::ForkRake               "
puts "      "
puts "      lugGeometry::DownTubeDiameter         $lugGeometry::DownTubeDiameter       "
puts "      lugGeometry::HeadTubeDiameter         $lugGeometry::HeadTubeDiameter       "
puts "      lugGeometry::HeadTubeDownTubeOffset   $lugGeometry::HeadTubeDownTubeOffset "
puts "      lugGeometry::HeadSetHeight            $lugGeometry::HeadSetHeight          "
puts "      lugGeometry::ForkHeight               $lugGeometry::ForkHeight             "
puts "      " 
puts "      lugGeometry::FrontWheelRadius         $lugGeometry::FrontWheelRadius       "
puts "      lugGeometry::RearWheelRadius          $lugGeometry::RearWheelRadius        "
puts "   -------------------------------------------------------"
puts ""
    #
for {set l 1} {$l <= 9} {incr l} {}
    #
set lugGeometry::printDebug 0
    #
for {set l 6} {$l <= 6} {incr l} {
        set startTime [clock microseconds ]
        set border {140 20}
        for {set i 0} {$i <= $l} {incr i} {
            set border [lugGeometry::find_HT_Angle $border]
        }
        set endTime [clock microseconds ]
        foreach {a b} $border break
        set HeadTubeAngle [format {%.8f} [expr ($a + $b)/2]]
        puts ""
        puts "    ... $l ... $HeadTubeAngle ... [expr $endTime - $startTime] microseconds     .... $border"
        # puts  $lugGeometry::angle_ChainStaySeatTube
        # puts  $lugGeometry::angle_SeatTubeDownTube 
        # puts  $lugGeometry::angle_DownTubeHeadTube 
        set SeatTubeAngle [expr $HeadTubeAngle - $lugGeometry::angle_SeatTubeDownTube + $lugGeometry::angle_DownTubeHeadTube]
        puts "    ... $l ... $SeatTubeAngle"

}




    #
# exit    
    #
puts ""
    #
# exit    
    #
set lugGeometry::printDebug 1
lugGeometry::find_HT_Angle [list $HeadTubeAngle $HeadTubeAngle]
    #
exit    
    #
puts "\n\n\n\n\n ==========================\n"
lugGeometry::find_HT_Angle [list 72.504 72.504]
