#!/bin/sh
# test_bikeGoemetry_1.0.tcl \
exec tclsh "$0" ${1+"$@"}



puts "\n\n ====== I N I T ============================ \n\n"

    # -- ::APPL_Config(BASE_Dir)  ------
set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
puts "   -> BASE_Dir:   $BASE_Dir\n"

    # -- Libraries  ---------------
lappend auto_path           [file join $BASE_Dir lib]
lappend auto_path           [file join $BASE_Dir ..]
            
    # puts "  \$auto_path  $auto_path"


    # -- Packages  ---------------
package require   vectormath    0.1
package require   bikeGeometry  0.75
package require   appUtil


    # -- Directories  ------------
set TEST_Dir    [file join $BASE_Dir test]
set SAMPLE_Dir  [file join $TEST_Dir sample]
puts "   -> TEST_Dir:   $TEST_Dir"
puts "   -> SAMPLE_Dir: $SAMPLE_Dir"


     # -- sampleFile  -----------
set sampleFile  [file join $SAMPLE_Dir template_road_3.4.xml]
set sampleFile  [file join $SAMPLE_Dir __debug_3.4.01.74__01__simplon_phasic_56_sramRed.xml]
set sampleFile  [file join $SAMPLE_Dir __test_3.4.01_74.xml]

puts "   -> sampleFile: $sampleFile"


     # -- Content  --------------
puts "\n   -> getContent: $sampleFile:"
    set fp [open $sampleFile]

    fconfigure    $fp -encoding utf-8
    set xml [read $fp]
    close         $fp

set sampleDOC   [dom parse  $xml]
set sampleDOM   [$sampleDOC documentElement]


 ##################################################################

# puts [$sampleDOM asXML]

puts "\n  ... procs bikeGeometry::"
foreach _proc [info procs  bikeGeometry::*] {
       puts "       -> $_proc"
}

puts "\n  ... procs bikeGeometry::project::"
foreach _proc [info procs  project::*] {
       puts "       -> $_proc"
}

puts "\n  ... vars  bikeGeometry::project::"
foreach _var [info vars  project::*] {
       puts "       -> $_var"
}


 ##################################################################

bikeGeometry::set_newProject $sampleDOM

 ##################################################################


proc getValue {key type} {
    set value [::project::getValue $key $type]
    puts "    ... $key $value"
}

puts "\n\n"

#getValue Result/Length/FrontWheel/Radius value
#getValue Component/BottleCage/DownTube/OffsetBB value

# FrameTubes/ChainStay/Profile/cuttingRight  ... renamed during refactoring
# FrameTubes/ChainStay/CenterLine/length_05  ... renamed during refactoring
               

foreach key { 
        Component/BottleCage/DownTube/OffsetBB
        Component/BottleCage/DownTube_Lower/OffsetBB
        Component/BottleCage/SeatTube/OffsetBB
        Component/Brake/Front/LeverLength
        Component/Brake/Front/Offset
        Component/Brake/Rear/LeverLength
        Component/Brake/Rear/Offset
        Component/Carrier/Front/x
        Component/Carrier/Front/y
        Component/Carrier/Rear/x
        Component/Carrier/Rear/y
        Component/CrankSet/ArmWidth
        Component/CrankSet/ChainLine
        Component/CrankSet/Length
        Component/CrankSet/PedalEye
        Component/CrankSet/Q-Factor
        Component/Derailleur/Front/Distance
        Component/Derailleur/Front/Offset
        Component/Fender/Front/Height
        Component/Fender/Front/OffsetAngle
        Component/Fender/Front/OffsetAngleFront
        Component/Fender/Front/Radius
        Component/Fender/Rear/Height
        Component/Fender/Rear/OffsetAngle
        Component/Fender/Rear/Radius
        Component/Fork/Blade/BendRadius
        Component/Fork/Blade/DiameterDO
        Component/Fork/Blade/EndLength
        Component/Fork/Blade/TaperLength
        Component/Fork/Blade/Width
        Component/Fork/Crown/Blade/Offset
        Component/Fork/Crown/Blade/OffsetPerp
        Component/Fork/Crown/Brake/Angle
        Component/Fork/Crown/Brake/Offset
        Component/Fork/Height
        Component/Fork/Rake
        Component/HandleBar/PivotAngle
        Component/HeadSet/Diameter
        Component/HeadSet/Height/Bottom
        Component/HeadSet/Height/Top
        Component/Saddle/Height
        Component/Saddle/LengthNose
        Component/SeatPost/Diameter
        Component/SeatPost/PivotOffset
        Component/SeatPost/Setback
        Component/Stem/Angle
        Component/Stem/Length
        Component/Wheel/Front/RimHeight
        Component/Wheel/Front/TyreHeight
        Component/Wheel/Rear/HubWidth
        Component/Wheel/Rear/RimHeight
        Component/Wheel/Rear/TyreHeight
        Component/Wheel/Rear/TyreWidth
        Component/Wheel/Rear/TyreWidthRadius
        Component/Derailleur/Rear/Pulley/teeth
        Component/Derailleur/Rear/Pulley/x
        Component/Derailleur/Rear/Pulley/y
        Custom/BottomBracket/Depth
        Custom/DownTube/OffsetBB
        Custom/DownTube/OffsetHT
        Custom/HeadTube/Angle
        Custom/SeatStay/OffsetTT
        Custom/SeatTube/Extension
        Custom/SeatTube/OffsetBB
        Custom/TopTube/Angle
        Custom/TopTube/OffsetHT
        Custom/TopTube/PivotPosition
        Custom/WheelPosition/Rear
        FrameTubes/ChainStay/CenterLine/angle_01
        FrameTubes/ChainStay/CenterLine/angle_02
        FrameTubes/ChainStay/CenterLine/angle_03
        FrameTubes/ChainStay/CenterLine/angle_04
        FrameTubes/ChainStay/CenterLine/length_01
        FrameTubes/ChainStay/CenterLine/length_02
        FrameTubes/ChainStay/CenterLine/length_03
        FrameTubes/ChainStay/CenterLine/length_04
        FrameTubes/ChainStay/CenterLine/radius_01
        FrameTubes/ChainStay/CenterLine/radius_02
        FrameTubes/ChainStay/CenterLine/radius_03
        FrameTubes/ChainStay/CenterLine/radius_04
        FrameTubes/ChainStay/DiameterSS
        FrameTubes/ChainStay/Height
        FrameTubes/ChainStay/HeightBB
        FrameTubes/ChainStay/Profile/completeLength
        FrameTubes/ChainStay/Profile/cuttingLength
        FrameTubes/ChainStay/Profile/length_01
        FrameTubes/ChainStay/Profile/length_02
        FrameTubes/ChainStay/Profile/length_03
        FrameTubes/ChainStay/Profile/width_00
        FrameTubes/ChainStay/Profile/width_01
        FrameTubes/ChainStay/Profile/width_02
        FrameTubes/ChainStay/Profile/width_03
        FrameTubes/ChainStay/TaperLength
        FrameTubes/DownTube/DiameterBB
        FrameTubes/DownTube/DiameterHT
        FrameTubes/DownTube/TaperLength
        FrameTubes/HeadTube/Diameter
        FrameTubes/HeadTube/Length
        FrameTubes/SeatStay/DiameterCS
        FrameTubes/SeatStay/DiameterST
        FrameTubes/SeatStay/TaperLength
        FrameTubes/SeatTube/DiameterBB
        FrameTubes/SeatTube/DiameterTT
        FrameTubes/SeatTube/TaperLength
        FrameTubes/TopTube/DiameterHT
        FrameTubes/TopTube/DiameterST
        FrameTubes/TopTube/TaperLength
        Lugs/BottomBracket/ChainStay/Angle/plus_minus
        Lugs/BottomBracket/ChainStay/Angle/value
        Lugs/BottomBracket/ChainStay/Offset_TopView
        Lugs/BottomBracket/Diameter/inside
        Lugs/BottomBracket/Diameter/outside
        Lugs/BottomBracket/DownTube/Angle/plus_minus
        Lugs/BottomBracket/DownTube/Angle/value
        Lugs/BottomBracket/Width
        Lugs/HeadTube/DownTube/Angle/plus_minus
        Lugs/HeadTube/DownTube/Angle/value
        Lugs/HeadTube/TopTube/Angle/plus_minus
        Lugs/HeadTube/TopTube/Angle/value
        Lugs/RearDropOut/Angle/plus_minus
        Lugs/RearDropOut/Angle/value
        Lugs/RearDropOut/ChainStay/Offset
        Lugs/RearDropOut/ChainStay/OffsetPerp
        Lugs/RearDropOut/ChainStay/Offset_TopView
        Lugs/RearDropOut/Derailleur/x
        Lugs/RearDropOut/Derailleur/y
        Lugs/RearDropOut/RotationOffset
        Lugs/RearDropOut/SeatStay/Offset
        Lugs/RearDropOut/SeatStay/OffsetPerp
        Lugs/SeatTube/SeatStay/Angle/plus_minus
        Lugs/SeatTube/SeatStay/Angle/value
        Lugs/SeatTube/SeatStay/MiterDiameter
        Lugs/SeatTube/TopTube/Angle/plus_minus
        Lugs/SeatTube/TopTube/Angle/value
        Personal/HandleBar_Distance
        Personal/HandleBar_Height
        Personal/InnerLeg_Length
        Personal/Saddle_Distance
        Personal/Saddle_Height
        Reference/HandleBar_Distance
        Reference/HandleBar_Height
        Reference/SaddleNose_Distance
        Reference/SaddleNose_Height
        Rendering/RearMockup/CassetteClearance
        Rendering/RearMockup/ChainWheelClearance
        Rendering/RearMockup/CrankClearance
        Rendering/RearMockup/DiscClearance
        Rendering/RearMockup/DiscDiameter
        Rendering/RearMockup/DiscOffset
        Rendering/RearMockup/DiscWidth
        Rendering/RearMockup/TyreClearance
        Rendering/Saddle/Offset_X
        Rendering/Saddle/Offset_Y
        Result/Angle/HeadTube/TopTube
        Result/Angle/SeatTube/Direction
        Result/Length/BottomBracket/Height
        Result/Length/FrontWheel/Radius
        Result/Length/FrontWheel/diagonal
        Result/Length/FrontWheel/horizontal
        Result/Length/HeadTube/ReachLength
        Result/Length/HeadTube/StackHeight
        Result/Length/Personal/SaddleNose_HB
        Result/Length/RearWheel/Radius
        Result/Length/RearWheel/TyreShoulder
        Result/Length/RearWheel/horizontal
        Result/Length/Reference/Heigth_SN_HB
        Result/Length/Reference/SaddleNose_HB
        Result/Length/Saddle/Offset_BB_Nose
        Result/Length/Saddle/Offset_BB_ST
        Result/Length/Saddle/Offset_HB
        Result/Length/Saddle/SeatTube_BB
        Result/Length/SeatTube/VirtualLength
        Result/Length/TopTube/VirtualLength
        Component/Wheel/Front/RimDiameter
        Component/Wheel/Rear/RimDiameter
        Component/CrankSet/ChainRings
        Component/Wheel/Rear/FirstSprocket
} {
    set value [::project::getValue $key value]
    if {$value == {}} {
        puts " <E> ... $key"
    } else {
        puts "     ... $key $value"
    }
}






