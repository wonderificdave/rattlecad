
    proc bikeGeometry::validate_ChainStayCenterLine {dict_ChainStay} {
                #
            #appUtil::pdict $dict_ChainStay
                #
            array set segment {}
            array set angle {}
            array set radius {}
            array set reqLength {}
                #
            set segment(1)  [dict get $dict_ChainStay segment_01]
            set segment(2)  [dict get $dict_ChainStay segment_02]
            set segment(3)  [dict get $dict_ChainStay segment_03]
            set segment(4)  [dict get $dict_ChainStay segment_04]
            set segment(5)  [dict get $dict_ChainStay segment_05]
            set angle(1)    [dict get $dict_ChainStay angle_01  ]
            set angle(2)    [dict get $dict_ChainStay angle_02  ]
            set angle(3)    [dict get $dict_ChainStay angle_03  ]
            set angle(4)    [dict get $dict_ChainStay angle_04  ]
            set radius(1)   [dict get $dict_ChainStay radius_01 ]
            set radius(2)   [dict get $dict_ChainStay radius_02 ]
            set radius(3)   [dict get $dict_ChainStay radius_03 ]
            set radius(4)   [dict get $dict_ChainStay radius_04 ]
                #
            # puts ""
            # puts "   \$segment(1) $segment(1)"
            # puts "   \$segment(2) $segment(2)"
            # puts "   \$segment(3) $segment(3)"
            # puts "   \$segment(4) $segment(4)"
            # puts "   \$segment(5) $segment(5)"
            # puts "   \$angle(1)   $angle(1)  "
            # puts "   \$angle(2)   $angle(2)  "
            # puts "   \$angle(3)   $angle(3)  "
            # puts "   \$angle(4)   $angle(4)  "
            # puts "   \$radius(1)  $radius(1) "
            # puts "   \$radius(2)  $radius(2) "
            # puts "   \$radius(3)  $radius(3) "
            # puts "   \$radius(4)  $radius(4) "
            # puts ""
                #
            set i 1
            set angle(0)  0
            set radius(0) 0
            set angle(5)  0
            set radius(5) 0
            while {$i <= 5} {
                set prevRadius  [lindex [array get radius [expr $i - 1]] 1]
                set prevAngle   [lindex [array get angle  [expr $i - 1]] 1]
                set thisRadius  $radius($i)
                set thisAngle   $angle($i)
                    # puts "   ... $prevRadius"
                    # puts "   ... $prevAngle"
                    # puts "   ... $thisRadius"
                    # puts "   ... $thisAngle"
                set prevLeg [expr abs($prevRadius * sin(0.5 * $prevAngle * $vectormath::CONST_PI / 180))]
                set thisLeg [expr abs($thisRadius * sin(0.5 * $thisAngle * $vectormath::CONST_PI / 180))]
                set reqLength($i) [expr $prevLeg + $thisLeg]
                puts "      $prevLeg"
                puts "              ang: $thisAngle"
                puts "          $thisLeg"
                puts "            =>  $reqLength($i)]"
                puts "              ??  $segment($i)"
                if {$reqLength($i) <= $segment($i)} {
                    # puts "    ... OK!   $reqLength($i) <= $segment($i)"
                } else {
                    puts ""
                    puts "          <E>"
                    puts "          <E> bikeGeometry::validate_ChainStay_CenterLine: Failed "
                    puts "          <E>"
                    puts "          <E>     ... $i ... thisRadius"
                    puts "          <E>     ... $i ... thisAngle"
                    puts "          <E>     ... $i ... $reqLength($i) <= $segment($i)"
                    puts "          <E>"
                    puts ""
                    return 0
                }
                incr i
            }
                #
            puts ""
            puts "          <I>"
            puts "          <I> bikeGeometry::validate_ChainStay_CenterLine: OK "
            puts "          <I>"
            puts ""
                #
            return 1

    }

