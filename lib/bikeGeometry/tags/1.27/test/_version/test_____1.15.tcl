#!/bin/sh
# test_bikeGoemetry_1.0.tcl \
exec tclsh "$0" ${1+"$@"}



puts "\n\n ====== I N I T ============================ \n\n"

    # -- ::APPL_Config(BASE_Dir)  ------
set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
    puts "   -> \$BASE_Dir:   $BASE_Dir\n"

    # -- Libraries  ---------------
lappend auto_path           [file join $BASE_Dir lib]
lappend auto_path           [file join $BASE_Dir ..]
    # puts "   -> \$auto_path:  $auto_path"

    # -- Packages  ---------------
package require   bikeGeometry  1.15
package require   appUtil

    # -- Directories  ------------
set TEST_Dir    [file join $BASE_Dir test]
set SAMPLE_Dir  [file join $TEST_Dir sample]
    # puts "   -> SAMPLE_Dir: $SAMPLE_Dir"
    
    # -- FAILED - Queries --------
variable failedQueries; array set failedQueries {}

    # -- sampleFile  -----------
set sampleFile  [file join $SAMPLE_Dir template_road_3.4.xml]
set sampleFile  [file join $SAMPLE_Dir __debug_3.4.01.74__01__simplon_phasic_56_sramRed.xml]
set sampleFile  [file join $SAMPLE_Dir __test_3.4.01_74.xml]
    # puts "   -> sampleFile: $sampleFile"

     # -- Content  --------------
puts "\n   -> getContent: $sampleFile:"
set fp [open $sampleFile]
fconfigure    $fp -encoding utf-8
set xml [read $fp]
close         $fp
set sampleDOC   [dom parse  $xml]
set sampleDOM   [$sampleDOC documentElement]
    #
bikeGeometry::set_newProject $sampleDOM
    #
    #
namespace eval rattleCAD {
    namespace eval model {
            #
        variable statusValue "OK"
        variable modelDICT
            #

        namespace import ::bikeGeometry::get_Value_expired
        namespace import ::bikeGeometry::get_Scalar
        namespace import ::bikeGeometry::get_Polygon
        namespace import ::bikeGeometry::get_Position
        namespace import ::bikeGeometry::get_Direction
        namespace import ::bikeGeometry::get_Component
        namespace import ::bikeGeometry::get_Config
        namespace import ::bikeGeometry::get_BoundingBox
        namespace import ::bikeGeometry::get_CenterLine
            #
        set modelDICT   [::bikeGeometry::get_projectDICT]
            #
    }
}
    #
    #
    proc compareValue {oldCommand oldXPath oldType  newCommand  newKey {centerPoint {0 0}} } {
            #
            #
        variable failedQueries
            #
        set oldValue {}
        set newValue {}
        if {$oldXPath != {}} {
            switch -exact $oldCommand {
                get_Value {
                        switch -exact $oldType {
                                todo  {         set oldValue [::bikeGeometry::get_Value_expired     $oldXPath value]        }
                                rendering  {    set oldValue [::bikeGeometry::get_Value_expired     $oldXPath value]        }
                                value {         set oldValue [::bikeGeometry::get_Value_expired     $oldXPath value]        }
                                component {     set oldValue [::bikeGeometry::get_Value_expired     $oldXPath component]    }
                                bounding {      set oldValue [::bikeGeometry::get_Value_expired     $oldXPath value]        }
                                position  {     set oldValue [::bikeGeometry::get_Object_expired    $oldXPath position  $centerPoint]}
                                direction {     set oldValue [::bikeGeometry::get_Object_expired    $oldXPath direction $centerPoint]}
                                default {       set oldValue [::bikeGeometry::get_Object_expired    $oldXPath $oldType  $centerPoint]}
                        }
                        switch -exact $oldType {
                            todo  {}
                            rendering  {}
                            value {         # puts "  -- value"    
                                                switch -exact $oldXPath {
                                                    Component/CrankSet/ChainRings  {}
                                                    default {
                                                        if {![catch {expr 1.0 * $oldValue} eID ]} {
                                                                set oldValue [format "%.3f" $oldValue] 
                                                        }
                                                    }
                                                }
                                            }
                            component {}
                            bounding {          set oldValue [split $oldValue ,]}
                            position  -
                            direction {         # puts "  -- position / direction"
                                                foreach {x y} $oldValue break
                                                set x [format "%.3f" $x]
                                                set y [format "%.3f" $y]
                                                set oldValue "$x $y"
                                            }
                            default {}
                        }
                    }
                get_Object {
                                set oldValue [::bikeGeometry::get_Object  $oldXPath $oldType $centerPoint]
                    }
                get_Dict {
                                set oldValue [appUtil::get_dictValue $rattleCAD::model::modelDICT $oldXPath]
                                switch -exact $oldXPath {
                                    Component/CrankSet/ChainRings  {}
                                    default {
                                        if {![catch {expr 1.0 * $oldValue} eID ]} {
                                                set oldValue [format "%.3f" $oldValue] 
                                        }
                                    }
                                }
                    }
                default {}
            }


        }
        # puts "   .... old $oldValue"


        if {[llength $newKey] > 1} {
            set object      [lindex $newKey 0]
            set key         [lindex $newKey 1]
                # puts "    ... $object $key"
            switch -exact $newCommand {
                get_Scalar {        set newValue [::bikeGeometry::get_Scalar        $object $key] }
                get_Direction {     set newValue [::bikeGeometry::get_Direction     $object $key] }
                get_Component {     set newValue [::bikeGeometry::get_Component     $object $key] }
                default {}
            }
                #
            set newValue [::bikeGeometry::$newCommand $object $key]
                #
        } else {
            set object     $newKey
                # puts "    ... $newKey"
                # puts "    ... $newCommand"
            switch -exact $newCommand {
                get_Scalar {        set newValue [::bikeGeometry::get_Scalar        $object] }
                get_Direction {     set newValue [::bikeGeometry::get_Direction     $object] }
                get_Component {     set newValue [::bikeGeometry::get_Component     $object] }
                get_Config {        set newValue [::bikeGeometry::get_Config        $object] }
                get_BoundingBox {   set newValue [::bikeGeometry::get_BoundingBox   $object] }
                get_TubeMiter {     set newValue [::bikeGeometry::get_TubeMiter     $object] }
                get_Polygon {       set newValue [::bikeGeometry::get_Polygon       $object $centerPoint] }
                get_Position {      set newValue [::bikeGeometry::get_Position      $object $centerPoint] }
                default {}
            }
        }   
        switch -exact $newCommand {
            get_Scalar {    set compString "$object/$key"
                            switch -exact $compString {
                                    CrankSet/ChainRings  {}
                                    default {
                                        # puts " -> $compString <- $newValue"
                                        if {![catch {expr 1.0 * $newValue} eID ]} {
                                                set newValue [format "%.3f" $newValue] 
                                        }
                                    }
                                }
                    }
            get_Direction -
            get_Position {      foreach {x y} $newValue break
                                set x [format "%.3f" $x]
                                set y [format "%.3f" $y]
                                set newValue "$x $y"
                    }
            default {}
        }             

        # puts "   .... new $newValue"
        #
        # puts " ----------------------------------------"

        set statusString "        "
            #
        if {$oldXPath != {}} {
            if {$oldValue != $newValue } {
                set statusString "  failed"
                set rattleCAD::model::statusValue "failed"
                set failedQueries($oldXPath) [list $oldCommand $newCommand $newKey]
            }
        } else {
            if {$newValue == {}} {
                set statusString "  failed"
                set rattleCAD::model::statusValue "failed"
                set failedQueries($oldXPath) [list $oldCommand $newCommand $newKey]
            }
        }
            #
        puts "  ---------------------------------"
        puts "     $statusString   $oldValue           <- $oldXPath"
        puts "     $statusString   $newValue           <- $newKey"
            #

    }

    #
    #
set BB_Position         {0 0}
set FrontHub_Position   {-400 50}
set RearHub_Position    {600 50}
    #
                
	
  # compareValue        get_Value   Component/HandleBar/PivotAngle                      value                           get_Scalar          {HandleBar PivotAngle}
  # compareValue        get_Value   DownTube                                            direction                       get_Direction       DownTube     
  # compareValue        get_Value   Component/Carrier/Front/File                        component                       get_Component       FrontCarrier
  # compareValue        get_Value   Lugs/RearDropOut/Direction                          value                           get_Config          RearDropoutOrient
  # compareValue        get_Value   Result/Position/SummarySize                         bounding                        get_BoundingBox     SummarySize
  # compareValue        get_Value   DownTube                                            polygon                         get_Polygon         DownTube                                    $BB_Position
  # compareValue        get_Value   BrakeFront                                          position                        get_Position        FrontBrakeShoe                              $BB_Position
  # # exit      
        
            
    compareValue        get_Value   DownTube                                            direction                       get_Direction       DownTube
	compareValue        get_Value   HeadTube                                            direction                       get_Direction       HeadTube
	compareValue        get_Value   Steerer                                             direction                       get_Direction       Steerer
	compareValue        get_Value   Lugs/Dropout/Front                                  direction                       get_Direction       ForkDropout
	compareValue        get_Value   Lugs/ForkCrown                                      direction                       get_Direction       ForkCrown
	compareValue        get_Value   SeatStay                                            direction                       get_Direction       SeatStay
	compareValue        get_Value   SeatTube                                            direction                       get_Direction       SeatTube
	compareValue        get_Value   TopTube                                             direction                       get_Direction       TopTube
    compareValue        get_Value   ChainStay                                           direction                       get_Direction       ChainStay
    compareValue        get_Value   Lugs/Dropout/Rear                                   direction                       get_Direction       RearDropout
    # exit          
                
            
    compareValue        get_Value   BottomBracketGround                                 position                        get_Position        BottomBracketGround                         $BB_Position
    compareValue        get_Value   BrakeFront                                          position                        get_Position        FrontBrakeShoe                              $BB_Position
    compareValue        get_Value   {}                                                  position                        get_Position        FrontBrakeHelp                              $BB_Position
    compareValue        get_Value   {}                                                  position                        get_Position        FrontBrakeDefinition                        $BB_Position
    compareValue        get_Value   {}                                                  position                        get_Position        FrontBrake                                  $BB_Position
    compareValue        get_Value   BrakeRear                                           position                        get_Position        RearBrakeShoe                               $BB_Position
    compareValue        get_Value   {}                                                  position                        get_Position        RearBrakeHelp                               $BB_Position
    compareValue        get_Value   {}                                                  position                        get_Position        RearBrakeDefinition                         $BB_Position
    compareValue        get_Value   {}                                                  position                        get_Position        RearBrake                                   $BB_Position
    compareValue        get_Value   {}                                                  position                        get_Position        LegClearance                                $BB_Position
    # exit      
    compareValue        get_Value   CarrierMountFront                                   position                        get_Position        CarrierMountFront                           $BB_Position
    compareValue        get_Value   CarrierMountRear                                    position                        get_Position        CarrierMountRear                            $BB_Position
    compareValue        get_Value   ChainStay/SeatStay_IS                               position                        get_Position        ChainStay_SeatStay_IS                       $BB_Position
    compareValue        get_Value   DerailleurMountFront                                position                        get_Position        DerailleurMountFront                        $BB_Position
    compareValue        get_Value   DownTube/BottleCage/Base                            position                        get_Position        DownTube_BottleCageBase                     $BB_Position
    compareValue        get_Value   DownTube/BottleCage/Offset                          position                        get_Position        DownTube_BottleCageOffset                   $BB_Position
    compareValue        get_Value   DownTube/BottleCage_Lower/Base                      position                        get_Position        DownTube_Lower_BottleCageBase               $BB_Position
    compareValue        get_Value   DownTube/BottleCage_Lower/Offset                    position                        get_Position        DownTube_Lower_BottleCageOffset             $BB_Position
    compareValue        get_Value   DownTube/End                                        position                        get_Position        DownTubeEnd                                 $BB_Position
    compareValue        get_Value   DownTube/Start                                      position                        get_Position        DownTubeStart                               $BB_Position
    compareValue        get_Value   FrontWheel                                          position                        get_Position        FrontWheel                                  $BB_Position
    compareValue        get_Value   HandleBar                                           position                        get_Position        HandleBar                                   $BB_Position
    compareValue        get_Value   HeadTube/End                                        position                        get_Position        HeadTubeEnd                                 $BB_Position
    compareValue        get_Value   HeadTube/Start                                      position                        get_Position        HeadTubeStart                               $BB_Position
    compareValue        get_Value   Lugs/Dropout/Rear/Derailleur                        position                        get_Position        RearDerailleur                              $BB_Position
    compareValue        get_Value   Lugs/ForkCrown                                      position                        get_Position        ForkCrown                                   $BB_Position
    compareValue        get_Value   RearWheel                                           position                        get_Position        RearWheel                                   $BB_Position
    compareValue        get_Value   Reference_HB                                        position                        get_Position        Reference_HB                                $BB_Position
    compareValue        get_Value   Reference_SN                                        position                        get_Position        Reference_SN                                $BB_Position
    compareValue        get_Value   Saddle                                              position                        get_Position        Saddle                                      $BB_Position
    compareValue        get_Value   SaddleNose                                          position                        get_Position        SaddleNose                                  $BB_Position
    compareValue        get_Value   SaddleProposal                                      position                        get_Position        SaddleProposal                              $BB_Position
    compareValue        get_Value   SeatPostPivot                                       position                        get_Position        SeatPostPivot                               $BB_Position
    compareValue        get_Value   SeatPostSaddle                                      position                        get_Position        SeatPostSaddle                              $BB_Position
    compareValue        get_Value   SeatPostSeatTube                                    position                        get_Position        SeatPostSeatTube                            $BB_Position
    compareValue        get_Value   SeatStay/End                                        position                        get_Position        SeatStayEnd                                 $BB_Position
    compareValue        get_Value   SeatStay/Start                                      position                        get_Position        SeatStayStart                               $BB_Position
    compareValue        get_Value   SeatTube/BottleCage/Base                            position                        get_Position        SeatTube_BottleCageBase                     $BB_Position
    compareValue        get_Value   SeatTube/BottleCage/Offset                          position                        get_Position        SeatTube_BottleCageOffset                   $BB_Position
    compareValue        get_Value   SeatTube/End                                        position                        get_Position        SeatTubeEnd                                 $BB_Position
    compareValue        get_Value   SeatTube/Start                                      position                        get_Position        SeatTubeStart                               $BB_Position
    compareValue        get_Value   SeatTubeGround                                      position                        get_Position        SeatTubeGround                              $BB_Position
    compareValue        get_Value   SeatTubeSaddle                                      position                        get_Position        SeatTubeSaddle                              $BB_Position
    compareValue        get_Value   SeatTubeVirtualTopTube                              position                        get_Position        SeatTubeVirtualTopTube                      $BB_Position
    compareValue        get_Value   Steerer/End                                         position                        get_Position        SteererEnd                                  $BB_Position
    compareValue        get_Value   Steerer/Start                                       position                        get_Position        SteererStart                                $BB_Position
    compareValue        get_Value   SteererGround                                       position                        get_Position        SteererGround                               $BB_Position
    compareValue        get_Value   TopTube/End                                         position                        get_Position        TopTubeEnd                                  $BB_Position
    compareValue        get_Value   TopTube/Start                                       position                        get_Position        TopTubeStart                                $BB_Position
    compareValue        get_Value   ChainStay/RearMockup                                position                        get_Position        ChainStayRearMockup                         [list 0.0 0.0]
    # exit
    
    compareValue        get_Value   DownTube                                            polygon                         get_Polygon         DownTube                                    $BB_Position
    compareValue        get_Value   Fender/Front                                        polygon                         get_Polygon         FrontFender                                 $FrontHub_Position
    compareValue        get_Value   Fender/Rear                                         polygon                         get_Polygon         RearFender                                  $RearHub_Position
    compareValue        get_Value   ForkBlade                                           polygon                         get_Polygon         ForkBlade                                   $BB_Position
    compareValue        get_Value   HeadSet/Bottom                                      polygon                         get_Polygon         HeadSetBottom                               $BB_Position
    compareValue        get_Value   HeadSet/Top                                         polygon                         get_Polygon         HeadSetTop                                  $BB_Position
    compareValue        get_Value   HeadTube                                            polygon                         get_Polygon         HeadTube                                    $BB_Position
    compareValue        get_Value   SeatPost                                            polygon                         get_Polygon         SeatPost                                    $BB_Position
    compareValue        get_Value   SeatStay                                            polygon                         get_Polygon         SeatStay                                    $BB_Position
    compareValue        get_Value   SeatTube                                            polygon                         get_Polygon         SeatTube                                    $BB_Position
    compareValue        get_Value   Steerer                                             polygon                         get_Polygon         Steerer                                     $BB_Position
    compareValue        get_Value   Stem                                                polygon                         get_Polygon         Stem                                        $BB_Position
    compareValue        get_Value   TopTube                                             polygon                         get_Polygon         TopTube                                     $BB_Position
    compareValue        get_Value   ChainStay                                           polygon                         get_Polygon         ChainStay                                   $BB_Position
    compareValue        get_Value   {}                                                  polygon                         get_Polygon         ChainStayRearMockup                         {0 0}
    # exit
    
    compareValue        get_Value   TubeMiter/DownTube_BB_in                            polygon                         get_TubeMiter       DownTube_BB_in   
    compareValue        get_Value   TubeMiter/DownTube_BB_out                           polygon                         get_TubeMiter       DownTube_BB_out            
    compareValue        get_Value   TubeMiter/DownTube_Head                             polygon                         get_TubeMiter       DownTube_Head              
    compareValue        get_Value   TubeMiter/DownTube_Seat                             polygon                         get_TubeMiter       DownTube_Seat              
    compareValue        get_Value   TubeMiter/Reference                                 polygon                         get_TubeMiter       Reference                  
    compareValue        get_Value   TubeMiter/SeatStay_01                               polygon                         get_TubeMiter       SeatStay_01                
    compareValue        get_Value   TubeMiter/SeatStay_02                               polygon                         get_TubeMiter       SeatStay_02                
    compareValue        get_Value   TubeMiter/SeatTube_BB_in                            polygon                         get_TubeMiter       SeatTube_BB_in             
    compareValue        get_Value   TubeMiter/SeatTube_BB_out                           polygon                         get_TubeMiter       SeatTube_BB_out            
    compareValue        get_Value   TubeMiter/SeatTube_Down                             polygon                         get_TubeMiter       SeatTube_Down              
    compareValue        get_Value   TubeMiter/TopTube_Head                              polygon                         get_TubeMiter       TopTube_Head               
    compareValue        get_Value   TubeMiter/TopTube_Seat                              polygon                         get_TubeMiter       TopTube_Seat     
            
    compareValue        get_Value   Result/Position/SummarySize                         bounding                        get_BoundingBox     {SummarySize}
    # exit

    compareValue        get_Value   Rendering/BottleCage/DownTube                       rendering                       get_Config          {BottleCage_DT}
    compareValue        get_Value   Rendering/BottleCage/DownTube_Lower                 rendering                       get_Config          {BottleCage_DT_L}
    compareValue        get_Value   Rendering/BottleCage/SeatTube                       rendering                       get_Config          {BottleCage_ST}
    compareValue        get_Value   Rendering/Brake/Front                               rendering                       get_Config          {FrontBrake}
    compareValue        get_Value   Rendering/Brake/Rear                                rendering                       get_Config          {RearBrake}
    compareValue        get_Value   Rendering/ChainStay                                 rendering                       get_Config          {ChainStay}
    compareValue        get_Value   Rendering/Fender/Front                              rendering                       get_Config          {FrontFender}
    compareValue        get_Value   Rendering/Fender/Rear                               rendering                       get_Config          {RearFender}
    compareValue        get_Value   Rendering/Fork                                      rendering                       get_Config          {Fork}
    compareValue        get_Value   Rendering/ForkBlade                                 rendering                       get_Config          {ForkBlade}
    compareValue        get_Value   Rendering/ForkDropOut                               rendering                       get_Config          {ForkDropout}
    compareValue        get_Value   Rendering/RearDropOut                               rendering                       get_Config          {RearDropout}
    compareValue        get_Value   Lugs/RearDropOut/Direction                          rendering                       get_Config          {RearDropoutOrient}
    # exit

    compareValue        get_Value   Component/Carrier/Front/File                        component                       get_Component       FrontCarrier
    compareValue        get_Value   Component/Carrier/Rear/File                         component                       get_Component       RearCarrier
    compareValue        get_Value   Component/CrankSet/File                             component                       get_Component       CrankSet
    compareValue        get_Value   Component/Derailleur/Front/File                     component                       get_Component       FrontDerailleur
    compareValue        get_Value   Component/Derailleur/Rear/File                      component                       get_Component       RearDerailleur
    compareValue        get_Value   Component/HandleBar/File                            component                       get_Component       HandleBar
    compareValue        get_Value   Component/Logo/File                                 component                       get_Component       Logo
    compareValue        get_Value   Component/Saddle/File                               component                       get_Component       Saddle
    compareValue        get_Value   Component/Brake/Front/File                          component                       get_Component       FrontBrake
    compareValue        get_Value   Component/Brake/Rear/File                           component                       get_Component       RearBrake
    compareValue        get_Value   Component/BottleCage/SeatTube/File                  component                       get_Component       {BottleCage FileSeatTube}
    compareValue        get_Value   Component/BottleCage/DownTube/File                  component                       get_Component       {BottleCage FileDownTube}
    compareValue        get_Value   Component/BottleCage/SeatTube/File                  component                       get_Component       {BottleCage FileDownTube_Lower}
    compareValue        get_Value   Component/Fork/Crown/File                           component                       get_Component       {Fork CrownFile}
    compareValue        get_Value   Component/Fork/DropOut/File                         component                       get_Component       {Fork DropOutFile}
    compareValue        get_Value   Lugs/RearDropOut/File                               component                       get_Component       {RearDropout File}
    # exit

    compareValue        get_Value   Component/HandleBar/PivotAngle                      value                           get_Scalar          {HandleBar PivotAngle}
    compareValue        get_Value   Component/HeadSet/Diameter                          value                           get_Scalar          {HeadSet Diameter}
    compareValue        get_Value   Component/CrankSet/Length                           value                           get_Scalar          {CrankSet Length}
    compareValue        get_Value   Component/BottleCage/SeatTube/OffsetBB              value                           get_Scalar          {BottleCage SeatTube}
    compareValue        get_Value   Component/BottleCage/DownTube/OffsetBB              value                           get_Scalar          {BottleCage DownTube}
    compareValue        get_Value   Component/BottleCage/DownTube_Lower/OffsetBB        value                           get_Scalar          {BottleCage DownTube_Lower}
                                                            
    compareValue        get_Value   Component/CrankSet/ArmWidth                         value                           get_Scalar          {CrankSet ArmWidth}
    compareValue        get_Value   Component/CrankSet/ChainLine                        value                           get_Scalar          {CrankSet ChainLine}
    compareValue        get_Value   Component/CrankSet/ChainRings                       value                           get_Scalar          {CrankSet ChainRings}
    compareValue        get_Value   Component/CrankSet/Length                           value                           get_Scalar          {CrankSet Length}
    compareValue        get_Value   Component/CrankSet/PedalEye                         value                           get_Scalar          {CrankSet PedalEye}
    compareValue        get_Value   Component/CrankSet/Q-Factor                         value                           get_Scalar          {CrankSet Q-Factor}
                                                            
    compareValue        get_Value   Component/Derailleur/Rear/Pulley/teeth              value                           get_Scalar          {RearDerailleur Pulley_teeth}
    compareValue        get_Value   Component/Derailleur/Rear/Pulley/x                  value                           get_Scalar          {RearDerailleur Pulley_x}
    compareValue        get_Value   Component/Derailleur/Rear/Pulley/y                  value                           get_Scalar          {RearDerailleur Pulley_y}
                                                            
    compareValue        get_Value   Component/Fork/Crown/Brake/Angle                    value                           get_Scalar          {Fork BrakeAngle}
    compareValue        get_Value   Component/Fork/Height                               value                           get_Scalar          {Fork Height}
    compareValue        get_Value   Component/Fork/Rake                                 value                           get_Scalar          {Fork Rake}
                                                            
    compareValue        get_Value   Component/Saddle/Length                             value                           get_Scalar          {Saddle Length}
    compareValue        get_Value   Component/Saddle/Height                             value                           get_Scalar          {Saddle SaddleHeight}
    compareValue        get_Value   Component/Saddle/LengthNose                         value                           get_Scalar          {Saddle NoseLength}
    compareValue        get_Value   Rendering/Saddle/Offset_X                           value                           get_Scalar          {Saddle Offset_X}
    compareValue        get_Value   Rendering/Saddle/Offset_Y                           value                           get_Scalar          {Saddle Offset_Y}
    compareValue        get_Value   Component/Stem/Length                               value                           get_Scalar          {Stem Length}
    compareValue        get_Value   Component/Stem/Angle                                value                           get_Scalar          {Stem Angle}
                                                            
    compareValue        get_Value   Component/Wheel/Front/RimDiameter                   value                           get_Scalar          {FrontWheel RimDiameter}
    compareValue        get_Value   Component/Wheel/Front/TyreHeight                    value                           get_Scalar          {FrontWheel TyreHeight}
    compareValue        get_Value   Component/Wheel/Rear/FirstSprocket                  value                           get_Scalar          {RearWheel FirstSprocket}
    compareValue        get_Value   Component/Wheel/Rear/HubWidth                       value                           get_Scalar          {RearWheel HubWidth}
    compareValue        get_Value   Component/Wheel/Rear/RimDiameter                    value                           get_Scalar          {RearWheel RimDiameter}
    compareValue        get_Value   Component/Wheel/Rear/RimDiameter                    value                           get_Scalar          {RearWheel RimDiameter}
    compareValue        get_Value   Component/Wheel/Rear/TyreHeight                     value                           get_Scalar          {RearWheel TyreHeight}
    compareValue        get_Value   Component/Wheel/Rear/TyreWidth                      value                           get_Scalar          {RearWheel TyreWidth}
    compareValue        get_Value   Component/Wheel/Rear/TyreWidthRadius                value                           get_Scalar          {RearWheel TyreWidthRadius}
    compareValue        get_Value   Custom/WheelPosition/Rear                           value                           get_Scalar          {RearWheel DistanceBB}
                                                            
    compareValue        get_Value   Custom/BottomBracket/Depth                          value                           get_Scalar          {BottomBracket Depth}
    compareValue        get_Value   Lugs/BottomBracket/Diameter/outside                 value                           get_Scalar          {BottomBracket OutsideDiameter}
    compareValue        get_Value   Lugs/BottomBracket/Diameter/inside                  value                           get_Scalar          {BottomBracket InsideDiameter}
    compareValue        get_Value   Lugs/BottomBracket/Width                            value                           get_Scalar          {BottomBracket Width}
    compareValue        get_Value   Lugs/BottomBracket/ChainStay/Offset_TopView         value                           get_Scalar          {BottomBracket OffsetCS_TopView}
                                                        
    compareValue        get_Value   Custom/HeadTube/Angle                               value                           get_Scalar          {HeadTube Angle}
    compareValue        get_Value   Custom/SeatStay/OffsetTT                            value                           get_Scalar          {SeatStay OffsetTT}
    compareValue        get_Value   Custom/SeatTube/Extension                           value                           get_Scalar          {SeatTube Extension}
    compareValue        get_Value   Custom/TopTube/Angle                                value                           get_Scalar          {TopTube Angle}
                                                    
    compareValue        get_Value   FrameTubes/ChainStay/CenterLine/angle_01            value                           get_Scalar          {ChainStay segmentAngle_01}
    compareValue        get_Value   FrameTubes/ChainStay/CenterLine/angle_02            value                           get_Scalar          {ChainStay segmentAngle_02}
    compareValue        get_Value   FrameTubes/ChainStay/CenterLine/angle_03            value                           get_Scalar          {ChainStay segmentAngle_03}
    compareValue        get_Value   FrameTubes/ChainStay/CenterLine/angle_04            value                           get_Scalar          {ChainStay segmentAngle_04}
    compareValue        get_Value   FrameTubes/ChainStay/CenterLine/length_01           value                           get_Scalar          {ChainStay segmentLength_01}
    compareValue        get_Value   FrameTubes/ChainStay/CenterLine/length_02           value                           get_Scalar          {ChainStay segmentLength_02}
    compareValue        get_Value   FrameTubes/ChainStay/CenterLine/length_03           value                           get_Scalar          {ChainStay segmentLength_03}
    compareValue        get_Value   FrameTubes/ChainStay/CenterLine/length_04           value                           get_Scalar          {ChainStay segmentLength_04}
    compareValue        get_Value   FrameTubes/ChainStay/CenterLine/radius_01           value                           get_Scalar          {ChainStay segmentRadius_01}
    compareValue        get_Value   FrameTubes/ChainStay/CenterLine/radius_02           value                           get_Scalar          {ChainStay segmentRadius_02}
    compareValue        get_Value   FrameTubes/ChainStay/CenterLine/radius_03           value                           get_Scalar          {ChainStay segmentRadius_03}
    compareValue        get_Value   FrameTubes/ChainStay/CenterLine/radius_04           value                           get_Scalar          {ChainStay segmentRadius_04}
    compareValue        get_Value   FrameTubes/ChainStay/DiameterSS                     value                           get_Scalar          {ChainStay DiameterSS}
    compareValue        get_Value   FrameTubes/ChainStay/Height                         value                           get_Scalar          {ChainStay Height}
    compareValue        get_Value   FrameTubes/ChainStay/HeightBB                       value                           get_Scalar          {ChainStay HeigthBB}
    compareValue        get_Value   FrameTubes/ChainStay/Profile/completeLength         value                           get_Scalar          {ChainStay completeLength}
    compareValue        get_Value   FrameTubes/ChainStay/Profile/cuttingLength          value                           get_Scalar          {ChainStay cuttingLength}
    compareValue        get_Value   FrameTubes/ChainStay/Profile/cuttingLeft            value                           get_Scalar          {ChainStay cuttingLeft}
                                                            
    compareValue        get_Value   FrameTubes/ChainStay/Profile/length_01              value                           get_Scalar          {ChainStay profile_x01}
    compareValue        get_Value   FrameTubes/ChainStay/Profile/length_02              value                           get_Scalar          {ChainStay profile_x02}
    compareValue        get_Value   FrameTubes/ChainStay/Profile/length_03              value                           get_Scalar          {ChainStay profile_x03}
    compareValue        get_Value   FrameTubes/ChainStay/Profile/width_00               value                           get_Scalar          {ChainStay profile_y00}
    compareValue        get_Value   FrameTubes/ChainStay/Profile/width_01               value                           get_Scalar          {ChainStay profile_y01}
    compareValue        get_Value   FrameTubes/ChainStay/Profile/width_02               value                           get_Scalar          {ChainStay profile_y02}
    compareValue        get_Value   FrameTubes/ChainStay/Profile/width_03               value                           get_Scalar          {ChainStay profile_y03}
    compareValue        get_Value   FrameTubes/ChainStay/TaperLength                    value                           get_Scalar          {ChainStay TaperLength}
    compareValue        get_Value   FrameTubes/ChainStay/WidthBB                        value                           get_Scalar          {ChainStay WidthBB}
                                                            
    compareValue        get_Value   FrameTubes/DownTube/DiameterBB                      value                           get_Scalar          {DownTube DiameterBB}
    compareValue        get_Value   FrameTubes/DownTube/DiameterHT                      value                           get_Scalar          {DownTube DiameterHT}
    compareValue        get_Value   FrameTubes/HeadTube/Diameter                        value                           get_Scalar          {HeadTube Diameter  }
    compareValue        get_Value   FrameTubes/HeadTube/Length                          value                           get_Scalar          {HeadTube Length    }
    compareValue        get_Value   FrameTubes/SeatStay/DiameterST                      value                           get_Scalar          {SeatStay DiameterST}
    compareValue        get_Value   FrameTubes/SeatTube/DiameterBB                      value                           get_Scalar          {SeatTube DiameterBB}
    compareValue        get_Value   FrameTubes/SeatTube/DiameterTT                      value                           get_Scalar          {SeatTube DiameterTT}
    compareValue        get_Value   FrameTubes/TopTube/DiameterHT                       value                           get_Scalar          {TopTube  DiameterHT}
    compareValue        get_Value   FrameTubes/TopTube/DiameterST                       value                           get_Scalar          {TopTube  DiameterST}
                                                            
    compareValue        get_Value   Lugs/RearDropOut/ChainStay/Offset                   value                           get_Scalar          {RearDropout OffsetCS}
	compareValue        get_Value   Lugs/RearDropOut/ChainStay/OffsetPerp               value                           get_Scalar          {RearDropout OffsetCSPerp}
	compareValue        get_Value   Lugs/RearDropOut/ChainStay/Offset_TopView           value                           get_Scalar          {RearDropout OffsetCS_TopView}
    compareValue        get_Value   Lugs/RearDropOut/Derailleur/y                       value                           get_Scalar          {RearDropout Derailleur_y}
    compareValue        get_Value   Lugs/RearDropOut/RotationOffset                     value                           get_Scalar          {RearDropout RotationOffset}
                                                    
    compareValue        get_Value   Lugs/SeatTube/SeatStay/MiterDiameter                value                           get_Scalar          {SeatStay SeatTubeMiterDiameter}
                                                            
    compareValue        get_Value   Personal/HandleBar_Distance                         value                           get_Scalar          {HandleBar Distance}
    compareValue        get_Value   Personal/HandleBar_Height                           value                           get_Scalar          {HandleBar Height}
    compareValue        get_Value   Personal/Saddle_Distance                            value                           get_Scalar          {Saddle Distance}
    compareValue        get_Value   Personal/Saddle_Height                              value                           get_Scalar          {Saddle Height}
    compareValue        get_Value   Personal/InnerLeg_Length                            value                           get_Scalar          {LegClearance Length}
    # exit                                                        
    compareValue        get_Value   Rendering/RearMockup/CassetteClearance              value                           get_Scalar          {RearMockup CassetteClearance}
    compareValue        get_Value   Rendering/RearMockup/ChainWheelClearance            value                           get_Scalar          {RearMockup ChainWheelClearance}
    compareValue        get_Value   Rendering/RearMockup/CrankClearance                 value                           get_Scalar          {RearMockup CrankClearance}
    compareValue        get_Value   Rendering/RearMockup/DiscClearance                  value                           get_Scalar          {RearMockup DiscClearance}
    compareValue        get_Value   Rendering/RearMockup/DiscDiameter                   value                           get_Scalar          {RearMockup DiscDiameter}
    compareValue        get_Value   Rendering/RearMockup/DiscOffset                     value                           get_Scalar          {RearMockup DiscOffset}
    compareValue        get_Value   Rendering/RearMockup/DiscWidth                      value                           get_Scalar          {RearMockup DiscWidth}
    compareValue        get_Value   Rendering/RearMockup/TyreClearance                  value                           get_Scalar          {RearMockup TyreClearance}
                                                
    compareValue        get_Value   Result/Length/RearWheel/horizontal                  value                           get_Scalar          {Geometry RearWheel_X}
    compareValue        get_Value   Result/Length/Saddle/Offset_BB_Nose                 value                           get_Scalar          {Geometry SaddleNose_BB_X}
    compareValue        get_Value   Result/Length/SeatTube/VirtualLength                value                           get_Scalar          {Geometry SeatTubeVirtual}
    compareValue        get_Value   Result/Length/TopTube/VirtualLength                 value                           get_Scalar          {Geometry TopTubeVirtual}
            
    compareValue        get_Value   {}                                                  todo                            get_Scalar          {RearMockup CenterLine}                                             ;# Result/Tubes/ChainStay/RearMockup/CenterLine
    compareValue        get_Value   {}                                                  todo                            get_Scalar          {RearMockup CenterLineUnCut}                                        ;# Result/Tubes/ChainStay/RearMockup/CenterLineUnCut
    compareValue        get_Value   {}                                                  todo                            get_Scalar          {RearMockup CtrLines}                                               ;# Result/Tubes/ChainStay/RearMockup/CtrLines


    compareValue        get_Value   Lugs/BottomBracket/ChainStay/Angle/plus_minus       value                           get_Scalar          {Lugs BottomBracket_ChainStay_Tolerance}
    compareValue        get_Value   Lugs/BottomBracket/ChainStay/Angle/value            value                           get_Scalar          {Lugs BottomBracket_ChainStay_Angle}
    compareValue        get_Value   Lugs/BottomBracket/DownTube/Angle/plus_minus        value                           get_Scalar          {Lugs BottomBracket_DownTube_Tolerance}
    compareValue        get_Value   Lugs/BottomBracket/DownTube/Angle/value             value                           get_Scalar          {Lugs BottomBracket_DownTube_Angle}
    compareValue        get_Value   Lugs/HeadTube/DownTube/Angle/plus_minus             value                           get_Scalar          {Lugs HeadLug_Bottom_Tolerance}
    compareValue        get_Value   Lugs/HeadTube/DownTube/Angle/value                  value                           get_Scalar          {Lugs HeadLug_Bottom_Angle}
    compareValue        get_Value   Lugs/HeadTube/TopTube/Angle/plus_minus              value                           get_Scalar          {Lugs HeadLug_Top_Tolerance}
    compareValue        get_Value   Lugs/HeadTube/TopTube/Angle/value                   value                           get_Scalar          {Lugs HeadLug_Top_Angle}
    compareValue        get_Value   Lugs/RearDropOut/Angle/plus_minus                   value                           get_Scalar          {Lugs RearDropOut_Tolerance}
    compareValue        get_Value   Lugs/RearDropOut/Angle/value                        value                           get_Scalar          {Lugs RearDropOut_Angle}
    compareValue        get_Value   Lugs/SeatTube/SeatStay/Angle/plus_minus             value                           get_Scalar          {Lugs SeatLug_SeatStay_Tolerance}
    compareValue        get_Value   Lugs/SeatTube/SeatStay/Angle/value                  value                           get_Scalar          {Lugs SeatLug_SeatStay_Angle}
    compareValue        get_Value   Lugs/SeatTube/TopTube/Angle/plus_minus              value                           get_Scalar          {Lugs SeatLug_TopTube_Tolerance}
    compareValue        get_Value   Lugs/SeatTube/TopTube/Angle/value                   value                           get_Scalar          {Lugs SeatLug_TopTube_Angle}
    # exit


    compareValue        get_Value   Personal/InnerLeg_Length                            value                           get_Scalar         {LegClearance Length}
    compareValue        get_Value   Result/Angle/HeadTube/TopTube                       value                           get_Scalar         {Result Angle_HeadTubeTopTube}
    compareValue        get_Value   Component/HeadSet/Height/Bottom                     value                           get_Scalar         {HeadSet Height_Bottom}
    # exit
    compareValue        get_Value   Component/SeatPost/Setback                          value                           get_Scalar         {SeatPost Setback}
    compareValue        get_Value   Custom/DownTube/OffsetBB                            value                           get_Scalar         {DownTube OffsetBB}
    # exit
    compareValue        get_Value   Custom/DownTube/OffsetHT                            value                           get_Scalar         {DownTube OffsetHT}
    compareValue        get_Value   Custom/TopTube/OffsetHT                             value                           get_Scalar         {TopTube OffsetHT}
    # exit
    compareValue        get_Value   Custom/TopTube/PivotPosition                        value                           get_Scalar         {TopTube PivotPosition}
    compareValue        get_Value   Result/Length/BottomBracket/Height                  value                           get_Scalar         {BottomBracket Height}
    # exit
    compareValue        get_Value   Result/Length/FrontWheel/diagonal                   value                           get_Scalar         {Geometry FrontWheel_xy}
    compareValue        get_Value   Result/Length/FrontWheel/horizontal                 value                           get_Scalar         {Geometry FrontWheel_x}
    compareValue        get_Value   Result/Length/Saddle/SeatTube_BB                    value                           get_Scalar         {Geometry Saddle_BB}










    compareValue        get_Dict    Component/BottleCage/DownTube/File                  {}                              get_Component       {BottleCage FileDownTube}
    compareValue        get_Dict    Component/BottleCage/SeatTube/File                  {}                              get_Component       {BottleCage FileDownTube_Lower}
    compareValue        get_Dict    Component/BottleCage/SeatTube/File                  {}                              get_Component       {BottleCage FileSeatTube}
    compareValue        get_Dict    Component/Brake/Front/File                          {}                              get_Component       FrontBrake
    compareValue        get_Dict    Component/Brake/Rear/File                           {}                              get_Component       RearBrake
    compareValue        get_Dict    Component/Carrier/Front/File                        {}                              get_Component       FrontCarrier
    compareValue        get_Dict    Component/Carrier/Rear/File                         {}                              get_Component       RearCarrier
    compareValue        get_Dict    Component/CrankSet/File                             {}                              get_Component       CrankSet
    compareValue        get_Dict    Component/Derailleur/Front/File                     {}                              get_Component       FrontDerailleur
    compareValue        get_Dict    Component/Derailleur/Rear/File                      {}                              get_Component       RearDerailleur
    compareValue        get_Dict    Component/Fork/Crown/File                           {}                              get_Component       {Fork CrownFile}
    compareValue        get_Dict    Component/Fork/DropOut/File                         {}                              get_Component       {Fork DropOutFile}
    compareValue        get_Dict    Component/HandleBar/File                            {}                              get_Component       HandleBar
    compareValue        get_Dict    Component/Logo/File                                 {}                              get_Component       Logo
    compareValue        get_Dict    Component/Saddle/File                               {}                              get_Component       Saddle
    compareValue        get_Dict    Lugs/RearDropOut/File                               {}                              get_Component       {RearDropout File}
    
    
    # exit  
    compareValue        get_Dict    Lugs/RearDropOut/Direction                          {}                              get_Config          {RearDropoutOrient}
    compareValue        get_Dict    Rendering/BottleCage/DownTube                       {}                              get_Config          {BottleCage_DT}
    compareValue        get_Dict    Rendering/BottleCage/DownTube_Lower                 {}                              get_Config          {BottleCage_DT_L}
    compareValue        get_Dict    Rendering/BottleCage/SeatTube                       {}                              get_Config          {BottleCage_ST}
    compareValue        get_Dict    Rendering/Brake/Front                               {}                              get_Config          {FrontBrake}
    compareValue        get_Dict    Rendering/Brake/Rear                                {}                              get_Config          {RearBrake}
    compareValue        get_Dict    Rendering/ChainStay                                 {}                              get_Config          {ChainStay}
    compareValue        get_Dict    Rendering/Fender/Front                              {}                              get_Config          {FrontFender}
    compareValue        get_Dict    Rendering/Fender/Front                              {}                              get_Config          {FrontFender}
    compareValue        get_Dict    Rendering/Fender/Rear                               {}                              get_Config          {FrontFender}
    compareValue        get_Dict    Rendering/Fender/Rear                               {}                              get_Config          {RearFender}
    compareValue        get_Dict    Rendering/Fork                                      {}                              get_Config          {Fork}
    compareValue        get_Dict    Rendering/ForkBlade                                 {}                              get_Config          {ForkBlade}
    compareValue        get_Dict    Rendering/ForkDropOut                               {}                              get_Config          {ForkDropout}
    compareValue        get_Dict    Rendering/RearDropOut                               {}                              get_Config          {RearDropout}
    # exit  
    
    compareValue        get_Dict    Component/BottleCage/DownTube/OffsetBB              {}                              get_Scalar          {BottleCage DownTube}
    compareValue        get_Dict    Component/BottleCage/DownTube_Lower/OffsetBB        {}                              get_Scalar          {BottleCage DownTube_Lower}
    compareValue        get_Dict    Component/BottleCage/SeatTube/OffsetBB              {}                              get_Scalar          {BottleCage SeatTube}
    # exit  
    compareValue        get_Dict    Component/Brake/Front/LeverLength                   {}                              get_Scalar          {FrontBrake LeverLength}
    compareValue        get_Dict    Component/Brake/Front/Offset                        {}                              get_Scalar          {FrontBrake Offset}
    compareValue        get_Dict    Component/Brake/Rear/LeverLength                    {}                              get_Scalar          {RearBrake LeverLength}
    compareValue        get_Dict    Component/Brake/Rear/Offset                         {}                              get_Scalar          {RearBrake Offset}
    compareValue        get_Dict    Component/Carrier/Front/x                           {}                              get_Scalar          {FrontCarrier x}
    compareValue        get_Dict    Component/Carrier/Front/y                           {}                              get_Scalar          {FrontCarrier y}
    compareValue        get_Dict    Component/Carrier/Rear/x                            {}                              get_Scalar          {RearCarrier x}
    compareValue        get_Dict    Component/Carrier/Rear/y                            {}                              get_Scalar          {RearCarrier y}
    # exit  
    compareValue        get_Dict    Component/CrankSet/ArmWidth                         {}                              get_Scalar          {CrankSet ArmWidth}
    compareValue        get_Dict    Component/CrankSet/ChainLine                        {}                              get_Scalar          {CrankSet ChainLine}
    compareValue        get_Dict    Component/CrankSet/ChainRings                       {}                              get_Scalar          {CrankSet ChainRings}
    compareValue        get_Dict    Component/CrankSet/Length                           {}                              get_Scalar          {CrankSet Length}
    compareValue        get_Dict    Component/CrankSet/PedalEye                         {}                              get_Scalar          {CrankSet PedalEye}
    compareValue        get_Dict    Component/CrankSet/Q-Factor                         {}                              get_Scalar          {CrankSet Q-Factor}
    compareValue        get_Dict    Component/Derailleur/Front/Distance                 {}                              get_Scalar          {FrontDerailleur Distance}
    compareValue        get_Dict    Component/Derailleur/Front/Offset                   {}                              get_Scalar          {FrontDerailleur Offset}
    # exit  
    compareValue        get_Dict    Component/Derailleur/Rear/Pulley/teeth              {}                              get_Scalar          {RearDerailleur Pulley_teeth}
    compareValue        get_Dict    Component/Derailleur/Rear/Pulley/x                  {}                              get_Scalar          {RearDerailleur Pulley_x}
    compareValue        get_Dict    Component/Derailleur/Rear/Pulley/y                  {}                              get_Scalar          {RearDerailleur Pulley_y}
    compareValue        get_Dict    Component/Fender/Front/Height                       {}                              get_Scalar          {FrontFender Height}
    compareValue        get_Dict    Component/Fender/Front/OffsetAngle                  {}                              get_Scalar          {FrontFender OffsetAngle}
    compareValue        get_Dict    Component/Fender/Front/OffsetAngleFront             {}                              get_Scalar          {FrontFender OffsetAngleFront}
    compareValue        get_Dict    Component/Fender/Front/Radius                       {}                              get_Scalar          {FrontFender Radius}
    compareValue        get_Dict    Component/Fender/Rear/Height                        {}                              get_Scalar          {RearFender Height}
    compareValue        get_Dict    Component/Fender/Rear/OffsetAngle                   {}                              get_Scalar          {RearFender OffsetAngle}
    compareValue        get_Dict    Component/Fender/Rear/Radius                        {}                              get_Scalar          {RearFender Radius}
    # exit  
    compareValue        get_Dict    Component/Fork/Blade/BendRadius                     {}                              get_Scalar          {Fork BladeBendRadius}
    compareValue        get_Dict    Component/Fork/Blade/DiameterDO                     {}                              get_Scalar          {Fork BladeDiameterDO}
    compareValue        get_Dict    Component/Fork/Blade/EndLength                      {}                              get_Scalar          {Fork BladeEndLength}
    compareValue        get_Dict    Component/Fork/Blade/TaperLength                    {}                              get_Scalar          {Fork BladeTaperLength}
    compareValue        get_Dict    Component/Fork/Blade/Width                          {}                              get_Scalar          {Fork BladeWidth}
    compareValue        get_Dict    Component/Fork/Crown/Blade/Offset                   {}                              get_Scalar          {Fork BladeOffsetCrown}
    compareValue        get_Dict    Component/Fork/Crown/Blade/OffsetPerp               {}                              get_Scalar          {Fork BladeOffsetCrownPerp}
    compareValue        get_Dict    Component/Fork/Crown/Brake/Angle                    {}                              get_Scalar          {Fork BrakeAngle}
    compareValue        get_Dict    Component/Fork/Crown/Brake/Offset                   {}                              get_Scalar          {Fork BrakeOffset}
    compareValue        get_Dict    Component/Fork/DropOut/Offset                       {}                              get_Scalar          {Fork BladeOffsetDO}
    compareValue        get_Dict    Component/Fork/DropOut/OffsetPerp                   {}                              get_Scalar          {Fork BladeOffsetDOPerp}
    compareValue        get_Dict    Component/Fork/Height                               {}                              get_Scalar          {Fork Height}
    compareValue        get_Dict    Component/Fork/Rake                                 {}                              get_Scalar          {Fork Rake}
    compareValue        get_Dict    Component/HandleBar/PivotAngle                      {}                              get_Scalar          {HandleBar PivotAngle}
    compareValue        get_Dict    Component/HeadSet/Diameter                          {}                              get_Scalar          {HeadSet Diameter}
    compareValue        get_Dict    Component/HeadSet/Height/Bottom                     {}                              get_Scalar          {HeadSet Height_Bottom}
    compareValue        get_Dict    Component/HeadSet/Height/Top                        {}                              get_Scalar          {HeadSet Height_Top}
    compareValue        get_Dict    Component/Saddle/Height                             {}                              get_Scalar          {Saddle SaddleHeight}
    compareValue        get_Dict    Component/Saddle/Length                             {}                              get_Scalar          {Saddle Length}
    compareValue        get_Dict    Component/Saddle/LengthNose                         {}                              get_Scalar          {Saddle NoseLength}
    compareValue        get_Dict    Component/SeatPost/Diameter                         {}                              get_Scalar          {SeatPost Diameter}
    compareValue        get_Dict    Component/SeatPost/PivotOffset                      {}                              get_Scalar          {SeatPost PivotOffset}
    # exit  
    
    compareValue        get_Dict    Component/SeatPost/Setback                          {}                              get_Scalar          {SeatPost Setback}
    compareValue        get_Dict    Component/Stem/Angle                                {}                              get_Scalar          {Stem Angle}
    compareValue        get_Dict    Component/Stem/Length                               {}                              get_Scalar          {Stem Length}
    compareValue        get_Dict    Component/Wheel/Front/RimDiameter                   {}                              get_Scalar          {FrontWheel RimDiameter}
    compareValue        get_Dict    Component/Wheel/Front/RimHeight                     {}                              get_Scalar          {FrontWheel RimHeight}
    compareValue        get_Dict    Component/Wheel/Front/TyreHeight                    {}                              get_Scalar          {FrontWheel TyreHeight}
    compareValue        get_Dict    Component/Wheel/Rear/FirstSprocket                  {}                              get_Scalar          {RearWheel FirstSprocket}
    compareValue        get_Dict    Component/Wheel/Rear/HubWidth                       {}                              get_Scalar          {RearWheel HubWidth}
    compareValue        get_Dict    Component/Wheel/Rear/RimDiameter                    {}                              get_Scalar          {RearWheel RimDiameter}
    compareValue        get_Dict    Component/Wheel/Rear/RimHeight                      {}                              get_Scalar          {RearWheel RimHeight}
    compareValue        get_Dict    Component/Wheel/Rear/TyreHeight                     {}                              get_Scalar          {RearWheel TyreHeight}
    # exit  
    compareValue        get_Dict    Component/Wheel/Rear/TyreWidth                      {}                              get_Scalar          {RearWheel TyreWidth}
    compareValue        get_Dict    Component/Wheel/Rear/TyreWidthRadius                {}                              get_Scalar          {RearWheel TyreWidthRadius}
    compareValue        get_Dict    Custom/BottomBracket/Depth                          {}                              get_Scalar          {BottomBracket Depth}
    compareValue        get_Dict    Custom/DownTube/OffsetBB                            {}                              get_Scalar          {DownTube OffsetBB}
    compareValue        get_Dict    Custom/DownTube/OffsetHT                            {}                              get_Scalar          {DownTube OffsetHT}
    compareValue        get_Dict    Custom/HeadTube/Angle                               {}                              get_Scalar          {HeadTube Angle}
    compareValue        get_Dict    Custom/SeatStay/OffsetTT                            {}                              get_Scalar          {SeatStay OffsetTT}
    compareValue        get_Dict    Custom/SeatTube/Extension                           {}                              get_Scalar          {SeatTube Extension}
    compareValue        get_Dict    Custom/SeatTube/OffsetBB                            {}                              get_Scalar          {SeatTube OffsetBB}
    # exit  
    compareValue        get_Dict    Custom/TopTube/Angle                                {}                              get_Scalar          {TopTube Angle}
    compareValue        get_Dict    Custom/TopTube/OffsetHT                             {}                              get_Scalar          {TopTube OffsetHT}
    compareValue        get_Dict    Custom/TopTube/PivotPosition                        {}                              get_Scalar          {TopTube PivotPosition}
    compareValue        get_Dict    Custom/WheelPosition/Rear                           {}                              get_Scalar          {RearWheel DistanceBB}
    compareValue        get_Dict    FrameTubes/ChainStay/CenterLine/angle_01            {}                              get_Scalar          {ChainStay segmentAngle_01}
    compareValue        get_Dict    FrameTubes/ChainStay/CenterLine/angle_02            {}                              get_Scalar          {ChainStay segmentAngle_02}
    compareValue        get_Dict    FrameTubes/ChainStay/CenterLine/angle_03            {}                              get_Scalar          {ChainStay segmentAngle_03}
    compareValue        get_Dict    FrameTubes/ChainStay/CenterLine/angle_04            {}                              get_Scalar          {ChainStay segmentAngle_04}
    compareValue        get_Dict    FrameTubes/ChainStay/CenterLine/length_01           {}                              get_Scalar          {ChainStay segmentLength_01}
    compareValue        get_Dict    FrameTubes/ChainStay/CenterLine/length_02           {}                              get_Scalar          {ChainStay segmentLength_02}
    compareValue        get_Dict    FrameTubes/ChainStay/CenterLine/length_03           {}                              get_Scalar          {ChainStay segmentLength_03}
    compareValue        get_Dict    FrameTubes/ChainStay/CenterLine/length_04           {}                              get_Scalar          {ChainStay segmentLength_04}
    compareValue        get_Dict    FrameTubes/ChainStay/CenterLine/radius_01           {}                              get_Scalar          {ChainStay segmentRadius_01}
    compareValue        get_Dict    FrameTubes/ChainStay/CenterLine/radius_02           {}                              get_Scalar          {ChainStay segmentRadius_02}
    compareValue        get_Dict    FrameTubes/ChainStay/CenterLine/radius_03           {}                              get_Scalar          {ChainStay segmentRadius_03}
    compareValue        get_Dict    FrameTubes/ChainStay/CenterLine/radius_04           {}                              get_Scalar          {ChainStay segmentRadius_04}
    compareValue        get_Dict    FrameTubes/ChainStay/DiameterSS                     {}                              get_Scalar          {ChainStay DiameterSS}
    compareValue        get_Dict    FrameTubes/ChainStay/Height                         {}                              get_Scalar          {ChainStay Height}
    compareValue        get_Dict    FrameTubes/ChainStay/HeightBB                       {}                              get_Scalar          {ChainStay HeigthBB}
    compareValue        get_Dict    FrameTubes/ChainStay/Profile/completeLength         {}                              get_Scalar          {ChainStay completeLength}
    compareValue        get_Dict    FrameTubes/ChainStay/Profile/cuttingLeft            {}                              get_Scalar          {ChainStay cuttingLeft}
    compareValue        get_Dict    FrameTubes/ChainStay/Profile/cuttingLength          {}                              get_Scalar          {ChainStay cuttingLength}
    compareValue        get_Dict    FrameTubes/ChainStay/Profile/length_01              {}                              get_Scalar          {ChainStay profile_x01}
    compareValue        get_Dict    FrameTubes/ChainStay/Profile/length_02              {}                              get_Scalar          {ChainStay profile_x02}
    compareValue        get_Dict    FrameTubes/ChainStay/Profile/length_03              {}                              get_Scalar          {ChainStay profile_x03}
    compareValue        get_Dict    FrameTubes/ChainStay/Profile/width_00               {}                              get_Scalar          {ChainStay profile_y00}
    compareValue        get_Dict    FrameTubes/ChainStay/Profile/width_01               {}                              get_Scalar          {ChainStay profile_y01}
    compareValue        get_Dict    FrameTubes/ChainStay/Profile/width_02               {}                              get_Scalar          {ChainStay profile_y02}
    compareValue        get_Dict    FrameTubes/ChainStay/Profile/width_03               {}                              get_Scalar          {ChainStay profile_y03}
    compareValue        get_Dict    FrameTubes/ChainStay/TaperLength                    {}                              get_Scalar          {ChainStay TaperLength}
    compareValue        get_Dict    FrameTubes/ChainStay/WidthBB                        {}                              get_Scalar          {ChainStay WidthBB}
    compareValue        get_Dict    FrameTubes/DownTube/DiameterBB                      {}                              get_Scalar          {DownTube DiameterBB}
    compareValue        get_Dict    FrameTubes/DownTube/DiameterHT                      {}                              get_Scalar          {DownTube DiameterHT}
    compareValue        get_Dict    FrameTubes/DownTube/TaperLength                     {}                              get_Scalar          {DownTube TaperLength}
    compareValue        get_Dict    FrameTubes/HeadTube/Diameter                        {}                              get_Scalar          {HeadTube Diameter  }
    compareValue        get_Dict    FrameTubes/HeadTube/Length                          {}                              get_Scalar          {HeadTube Length    }
    compareValue        get_Dict    FrameTubes/SeatStay/DiameterCS                      {}                              get_Scalar          {SeatStay DiameterCS}
    compareValue        get_Dict    FrameTubes/SeatStay/DiameterST                      {}                              get_Scalar          {SeatStay DiameterST}
    compareValue        get_Dict    FrameTubes/SeatStay/TaperLength                     {}                              get_Scalar          {SeatStay TaperLength}
    compareValue        get_Dict    FrameTubes/SeatTube/DiameterBB                      {}                              get_Scalar          {SeatTube DiameterBB}
    compareValue        get_Dict    FrameTubes/SeatTube/DiameterTT                      {}                              get_Scalar          {SeatTube DiameterTT}
    compareValue        get_Dict    FrameTubes/SeatTube/TaperLength                     {}                              get_Scalar          {SeatTube TaperLength}
    compareValue        get_Dict    FrameTubes/TopTube/DiameterHT                       {}                              get_Scalar          {TopTube  DiameterHT}
    compareValue        get_Dict    FrameTubes/TopTube/DiameterST                       {}                              get_Scalar          {TopTube  DiameterST}
    compareValue        get_Dict    FrameTubes/TopTube/TaperLength                      {}                              get_Scalar          {TopTube  TaperLength}
    # exit  
    compareValue        get_Dict    Lugs/BottomBracket/ChainStay/Angle/plus_minus       {}                              get_Scalar          {Lugs BottomBracket_ChainStay_Tolerance}
    compareValue        get_Dict    Lugs/BottomBracket/ChainStay/Angle/value            {}                              get_Scalar          {Lugs BottomBracket_ChainStay_Angle}
    compareValue        get_Dict    Lugs/BottomBracket/ChainStay/Offset_TopView         {}                              get_Scalar          {BottomBracket OffsetCS_TopView}
    compareValue        get_Dict    Lugs/BottomBracket/Diameter/inside                  {}                              get_Scalar          {BottomBracket InsideDiameter}
    compareValue        get_Dict    Lugs/BottomBracket/Diameter/outside                 {}                              get_Scalar          {BottomBracket OutsideDiameter}
    compareValue        get_Dict    Lugs/BottomBracket/DownTube/Angle/plus_minus        {}                              get_Scalar          {Lugs BottomBracket_DownTube_Tolerance}
    compareValue        get_Dict    Lugs/BottomBracket/DownTube/Angle/value             {}                              get_Scalar          {Lugs BottomBracket_DownTube_Angle}
    compareValue        get_Dict    Lugs/BottomBracket/Width                            {}                              get_Scalar          {BottomBracket Width}
    compareValue        get_Dict    Lugs/HeadTube/DownTube/Angle/plus_minus             {}                              get_Scalar          {Lugs HeadLug_Bottom_Tolerance}
    compareValue        get_Dict    Lugs/HeadTube/DownTube/Angle/value                  {}                              get_Scalar          {Lugs HeadLug_Bottom_Angle}
    compareValue        get_Dict    Lugs/HeadTube/TopTube/Angle/plus_minus              {}                              get_Scalar          {Lugs HeadLug_Top_Tolerance}
    compareValue        get_Dict    Lugs/HeadTube/TopTube/Angle/value                   {}                              get_Scalar          {Lugs HeadLug_Top_Angle}
    compareValue        get_Dict    Lugs/RearDropOut/Angle/plus_minus                   {}                              get_Scalar          {Lugs RearDropOut_Tolerance}
    compareValue        get_Dict    Lugs/RearDropOut/Angle/value                        {}                              get_Scalar          {Lugs RearDropOut_Angle}
    compareValue        get_Dict    Lugs/RearDropOut/ChainStay/Offset                   {}                              get_Scalar          {RearDropout OffsetCS}
    compareValue        get_Dict    Lugs/RearDropOut/ChainStay/OffsetPerp               {}                              get_Scalar          {RearDropout OffsetCSPerp}
    compareValue        get_Dict    Lugs/RearDropOut/ChainStay/Offset_TopView           {}                              get_Scalar          {RearDropout OffsetCS_TopView}
    compareValue        get_Dict    Lugs/RearDropOut/Derailleur/x                       {}                              get_Scalar          {RearDropout Derailleur_x}
    compareValue        get_Dict    Lugs/RearDropOut/Derailleur/y                       {}                              get_Scalar          {RearDropout Derailleur_y}
    compareValue        get_Dict    Lugs/RearDropOut/Direction                          {}                              get_Config          {RearDropoutOrient}
    compareValue        get_Dict    Lugs/RearDropOut/RotationOffset                     {}                              get_Scalar          {RearDropout RotationOffset}
    compareValue        get_Dict    Lugs/RearDropOut/SeatStay/Offset                    {}                              get_Scalar          {RearDropout OffsetSS}
    compareValue        get_Dict    Lugs/RearDropOut/SeatStay/OffsetPerp                {}                              get_Scalar          {RearDropout OffsetSSPerp}
    compareValue        get_Dict    Lugs/SeatTube/SeatStay/Angle/plus_minus             {}                              get_Scalar          {Lugs SeatLug_SeatStay_Tolerance}
    compareValue        get_Dict    Lugs/SeatTube/SeatStay/Angle/value                  {}                              get_Scalar          {Lugs SeatLug_SeatStay_Angle}
    compareValue        get_Dict    Lugs/SeatTube/SeatStay/MiterDiameter                {}                              get_Scalar          {SeatStay SeatTubeMiterDiameter}
    compareValue        get_Dict    Lugs/SeatTube/TopTube/Angle/plus_minus              {}                              get_Scalar          {Lugs SeatLug_TopTube_Tolerance}
    compareValue        get_Dict    Lugs/SeatTube/TopTube/Angle/value                   {}                              get_Scalar          {Lugs SeatLug_TopTube_Angle}
    compareValue        get_Dict    Personal/HandleBar_Distance                         {}                              get_Scalar          {HandleBar Distance}
    compareValue        get_Dict    Personal/HandleBar_Height                           {}                              get_Scalar          {HandleBar Height}
    compareValue        get_Dict    Personal/InnerLeg_Length                            {}                              get_Scalar          {LegClearance Length}
    compareValue        get_Dict    Personal/Saddle_Distance                            {}                              get_Scalar          {Saddle Distance}
    compareValue        get_Dict    Personal/Saddle_Height                              {}                              get_Scalar          {Saddle Height}
    compareValue        get_Dict    Reference/HandleBar_Distance                        {}                              get_Scalar          {Reference HandleBar_Distance }
    compareValue        get_Dict    Reference/HandleBar_Height                          {}                              get_Scalar          {Reference HandleBar_Height   }
    compareValue        get_Dict    Reference/SaddleNose_Distance                       {}                              get_Scalar          {Reference SaddleNose_Distance}
    compareValue        get_Dict    Reference/SaddleNose_Height                         {}                              get_Scalar          {Reference SaddleNose_Height  }
    # exit  
    
    compareValue        get_Dict    Rendering/RearMockup/CassetteClearance              {}                              get_Scalar          {RearMockup CassetteClearance}
    compareValue        get_Dict    Rendering/RearMockup/ChainWheelClearance            {}                              get_Scalar          {RearMockup ChainWheelClearance}
    compareValue        get_Dict    Rendering/RearMockup/CrankClearance                 {}                              get_Scalar          {RearMockup CrankClearance}
    compareValue        get_Dict    Rendering/RearMockup/DiscClearance                  {}                              get_Scalar          {RearMockup DiscClearance}
    compareValue        get_Dict    Rendering/RearMockup/DiscDiameter                   {}                              get_Scalar          {RearMockup DiscDiameter}
    compareValue        get_Dict    Rendering/RearMockup/DiscOffset                     {}                              get_Scalar          {RearMockup DiscOffset}
    compareValue        get_Dict    Rendering/RearMockup/DiscWidth                      {}                              get_Scalar          {RearMockup DiscWidth}
    compareValue        get_Dict    Rendering/RearMockup/TyreClearance                  {}                              get_Scalar          {RearMockup TyreClearance}
    compareValue        get_Dict    Rendering/Saddle/Offset_X                           {}                              get_Scalar          {Saddle Offset_X}
    compareValue        get_Dict    Rendering/Saddle/Offset_Y                           {}                              get_Scalar          {Saddle Offset_Y}
    # exit  
    compareValue        get_Dict    Result/Angle/BottomBracket/ChainStay                {}                              get_Scalar          {Result Angle_BottomBracketChainStay}
    compareValue        get_Dict    Result/Angle/BottomBracket/DownTube                 {}                              get_Scalar          {Result Angle_BottomBracketDownTube}
    compareValue        get_Dict    Result/Angle/HeadTube/DownTube                      {}                              get_Scalar          {Result Angle_HeadTubeDownTube}
    compareValue        get_Dict    Result/Angle/HeadTube/TopTube                       {}                              get_Scalar          {Result Angle_HeadTubeTopTube}
    compareValue        get_Dict    Result/Angle/SeatStay/ChainStay                     {}                              get_Scalar          {Result Angle_SeatStayChainStay}
    compareValue        get_Dict    Result/Angle/SeatTube/Direction                     {}                              get_Scalar          {SeatTube Angle}
    compareValue        get_Dict    Result/Angle/SeatTube/SeatStay                      {}                              get_Scalar          {Result Angle_SeatTubeSeatStay}
    compareValue        get_Dict    Result/Angle/SeatTube/TopTube                       {}                              get_Scalar          {Result Angle_SeatTubeTopTube}
    # exit
    compareValue        get_Dict    Result/Length/BottomBracket/Height                  {}                              get_Scalar          {BottomBracket Height}
    compareValue        get_Dict    Result/Length/FrontWheel/Radius                     {}                              get_Scalar          {FrontWheel Radius}
    compareValue        get_Dict    Result/Length/FrontWheel/diagonal                   {}                              get_Scalar          {Geometry FrontWheel_xy}
    compareValue        get_Dict    Result/Length/FrontWheel/horizontal                 {}                              get_Scalar          {Geometry FrontWheel_x}
    compareValue        get_Dict    Result/Length/HeadTube/ReachLength                  {}                              get_Scalar          {Geometry ReachLengthResult}
    compareValue        get_Dict    Result/Length/HeadTube/StackHeight                  {}                              get_Scalar          {Geometry StackHeightResult}
    compareValue        get_Dict    Result/Length/Personal/SaddleNose_HB                {}                              get_Scalar          {Geometry SaddleNose_HB}
    compareValue        get_Dict    Result/Length/RearWheel/Radius                      {}                              get_Scalar          {RearWheel Radius}
    compareValue        get_Dict    Result/Length/RearWheel/TyreShoulder                {}                              get_Scalar          {RearWheel TyreShoulder }
    compareValue        get_Dict    Result/Length/RearWheel/horizontal                  {}                              get_Scalar          {Geometry RearWheel_X}
    compareValue        get_Dict    Result/Length/Saddle/Offset_BB_Nose                 {}                              get_Scalar          {Geometry SaddleNose_BB_X}
    compareValue        get_Dict    Result/Length/Saddle/Offset_BB_ST                   {}                              get_Scalar          {Geometry Saddle_Offset_BB_ST}
    compareValue        get_Dict    Result/Length/Saddle/Offset_HB                      {}                              get_Scalar          {Geometry Saddle_HB_y}
    compareValue        get_Dict    Result/Length/Saddle/SeatTube_BB                    {}                              get_Scalar          {Geometry Saddle_BB}
    compareValue        get_Dict    Result/Length/SeatTube/VirtualLength                {}                              get_Scalar          {Geometry SeatTubeVirtual}
    compareValue        get_Dict    Result/Length/TopTube/VirtualLength                 {}                              get_Scalar          {Geometry TopTubeVirtual}
    
    
    compareValue        get_Dict    Result/Length/Reference/Heigth_SN_HB                {}                              get_Scalar          {Reference SaddleNose_HB_y}
    compareValue        get_Dict    Result/Length/Reference/SaddleNose_HB               {}                              get_Scalar          {Reference SaddleNose_HB}
    


    puts "\n"
    puts "    ...         $::rattleCAD::model::statusValue"

    parray failedQueries



    # exit

