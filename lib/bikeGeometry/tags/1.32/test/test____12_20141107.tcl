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
package require   bikeGeometry  1.08

    # -- Directories  ------------
set TEST_Dir    [file join $BASE_Dir test]
set SAMPLE_Dir  [file join $TEST_Dir sample]
    # puts "   -> SAMPLE_Dir: $SAMPLE_Dir"

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
        namespace import ::bikeGeometry::get_Value 
        namespace import ::bikeGeometry::get_Object
        namespace import ::bikeGeometry::get_Polygon
        namespace import ::bikeGeometry::get_Position
        namespace import ::bikeGeometry::get_Direction
        namespace import ::bikeGeometry::get_Component 
            #
        proc getObject {objectOld index objectNew {centerPoint {0 0}} } {
                #puts " ... getObject $object $index $centerPoint"
                #
            set oldProcValue [get_Object $objectOld $index $centerPoint]
                #
            switch -exact $index {

                polygon {    
				            set returnValue    [bikeGeometry::get_Polygon   $objectNew $centerPoint]
                        }

                position {
                            set returnValue    [bikeGeometry::get_Position  $objectNew $centerPoint]
                        }

                direction {
                            set returnValue    [bikeGeometry::get_Direction $objectNew]
                        }

                component {
                            if {[llength $objectNew] > 1} {
                                set object      [lindex $objectNew 0]
                                set key         [lindex $objectNew 1]
                                puts "    ... $object $key"
                                set returnValue [bikeGeometry::get_Component $object $key]
                            } else {
                                puts "    ... $objectNew"
                                set returnValue     [bikeGeometry::get_Component $objectNew]
                            }
                        }

                default    {             
                              # puts "   ... object_values $object $index"
                            #eval set returnValue $[format "frameCoords::%s(%s)" $object $index]
                            #return [ coords_addVector  $returnValue  $centerPoint]
                        }
            }
                #
            set newProcValue $returnValue
                #
            puts "  ---------------------------------"            
            puts "   $objectOld   $oldProcValue"            
            puts "   $objectOld   $newProcValue    $objectNew"
                #
        }
    }    
}
    #
    #
proc compareValue {object index {centerPoint {0 0}}} {
    set oldProcValue [bikeGeometry::get_Object $object $index $centerPoint]
}
    #
    #
set BB_Position         {0 0}
set FrontHub_Position   {-400 50}
set RearHub_Position    {600 50}
    #
    
	rattleCAD::model::getObject    DownTube                         direction   DownTube                         
	rattleCAD::model::getObject    HeadTube                         direction   HeadTube                         
	rattleCAD::model::getObject    Lugs/Dropout/Front               direction   Lugs/Dropout/Front               
	rattleCAD::model::getObject    Lugs/ForkCrown                   direction   Lugs/ForkCrown                   
	rattleCAD::model::getObject    SeatStay                         direction   SeatStay                         
	rattleCAD::model::getObject    SeatTube                         direction   SeatTube                         
	rattleCAD::model::getObject    TopTube                          direction   TopTube                          
                                                                                
	rattleCAD::model::getObject    BottomBracketGround              position    BottomBracketGround                         $BB_Position
	rattleCAD::model::getObject    BrakeFront                       position    BrakeFront                                  $BB_Position
	rattleCAD::model::getObject    BrakeRear                        position    BrakeRear                                   $BB_Position
	rattleCAD::model::getObject    CarrierMountFront                position    CarrierMountFront                           $BB_Position
	rattleCAD::model::getObject    CarrierMountRear                 position    CarrierMountRear                            $BB_Position
	rattleCAD::model::getObject    ChainStay/SeatStay_IS            position    ChainStay/SeatStay_IS                       $BB_Position
	rattleCAD::model::getObject    DerailleurMountFront             position    DerailleurMountFront                        $BB_Position
	rattleCAD::model::getObject    DownTube/BottleCage/Base         position    DownTube/BottleCage/Base                    $BB_Position
	rattleCAD::model::getObject    DownTube/BottleCage/Offset       position    DownTube/BottleCage/Offset                  $BB_Position
	rattleCAD::model::getObject    DownTube/BottleCage_Lower/Base   position    DownTube/BottleCage_Lower/Base              $BB_Position
	rattleCAD::model::getObject    DownTube/BottleCage_Lower/Offset position    DownTube/BottleCage_Lower/Offset            $BB_Position
	rattleCAD::model::getObject    DownTube/End                     position    DownTube/End                                $BB_Position
	rattleCAD::model::getObject    DownTube/Start                   position    DownTube/Start                              $BB_Position
	rattleCAD::model::getObject    FrontWheel                       position    FrontWheel                                  $BB_Position
	rattleCAD::model::getObject    HandleBar                        position    HandleBar                                   $BB_Position
	rattleCAD::model::getObject    HeadTube/End                     position    HeadTube/End                                $BB_Position
	rattleCAD::model::getObject    HeadTube/Start                   position    HeadTube/Start                              $BB_Position
	rattleCAD::model::getObject    Lugs/Dropout/Rear/Derailleur     position    Lugs/Dropout/Rear/Derailleur                $BB_Position
	rattleCAD::model::getObject    Lugs/ForkCrown                   position    Lugs/ForkCrown                              $BB_Position
	rattleCAD::model::getObject    RearWheel                        position    RearWheel                                   $BB_Position
	rattleCAD::model::getObject    Reference_HB                     position    Reference_HB                                $BB_Position
	rattleCAD::model::getObject    Reference_SN                     position    Reference_SN                                $BB_Position
	rattleCAD::model::getObject    Saddle                           position    Saddle                                      $BB_Position
	rattleCAD::model::getObject    SaddleProposal                   position    SaddleProposal                              $BB_Position
	rattleCAD::model::getObject    SeatPostPivot                    position    SeatPostPivot                               $BB_Position
	rattleCAD::model::getObject    SeatPostSaddle                   position    SeatPostSaddle                              $BB_Position
	rattleCAD::model::getObject    SeatPostSeatTube                 position    SeatPostSeatTube                            $BB_Position
	rattleCAD::model::getObject    SeatStay/End                     position    SeatStay/End                                $BB_Position
	rattleCAD::model::getObject    SeatStay/Start                   position    SeatStay/Start                              $BB_Position
	rattleCAD::model::getObject    SeatTube/BottleCage/Base         position    SeatTube/BottleCage/Base                    $BB_Position
	rattleCAD::model::getObject    SeatTube/BottleCage/Offset       position    SeatTube/BottleCage/Offset                  $BB_Position
	rattleCAD::model::getObject    SeatTube/End                     position    SeatTube/End                                $BB_Position
	rattleCAD::model::getObject    SeatTube/Start                   position    SeatTube/Start                              $BB_Position
	rattleCAD::model::getObject    SeatTubeGround                   position    SeatTubeGround                              $BB_Position
	rattleCAD::model::getObject    SeatTubeSaddle                   position    SeatTubeSaddle                              $BB_Position
	rattleCAD::model::getObject    SeatTubeVirtualTopTube           position    SeatTubeVirtualTopTube                      $BB_Position
	rattleCAD::model::getObject    Steerer/End                      position    Steerer/End                                 $BB_Position
	rattleCAD::model::getObject    Steerer/Start                    position    Steerer/Start                               $BB_Position
	rattleCAD::model::getObject    SteererGround                    position    SteererGround                               $BB_Position
	rattleCAD::model::getObject    TopTube/End                      position    TopTube/End                                 $BB_Position
	rattleCAD::model::getObject    TopTube/Start                    position    TopTube/Start                               $BB_Position                                                                   
                                                                                                                
                                                                                                                
                                                                                                                
	rattleCAD::model::getObject    DownTube                         polygon     DownTube                                    $BB_Position
	rattleCAD::model::getObject    Fender/Front                     polygon     Fender/Front                                $FrontHub_Position
	rattleCAD::model::getObject    Fender/Rear                      polygon     Fender/Rear                                 $RearHub_Position
	rattleCAD::model::getObject    ForkBlade                        polygon     ForkBlade                                   $BB_Position
	rattleCAD::model::getObject    HeadSet/Bottom                   polygon     HeadSet/Bottom                              $BB_Position
	rattleCAD::model::getObject    HeadSet/Top                      polygon     HeadSet/Top                                 $BB_Position
	rattleCAD::model::getObject    HeadTube                         polygon     HeadTube                                    $BB_Position
	rattleCAD::model::getObject    SeatPost                         polygon     SeatPost                                    $BB_Position
	rattleCAD::model::getObject    SeatStay                         polygon     SeatStay                                    $BB_Position
	rattleCAD::model::getObject    SeatTube                         polygon     SeatTube                                    $BB_Position
	rattleCAD::model::getObject    Steerer                          polygon     Steerer                                     $BB_Position
	rattleCAD::model::getObject    Stem                             polygon     Stem                                        $BB_Position
	rattleCAD::model::getObject    TopTube                          polygon     TopTube                                     $BB_Position
	rattleCAD::model::getObject    TubeMiter/DownTube_BB_in         polygon     TubeMiter/DownTube_BB_in                    $BB_Position
	rattleCAD::model::getObject    TubeMiter/DownTube_BB_out        polygon     TubeMiter/DownTube_BB_out                   $BB_Position
	rattleCAD::model::getObject    TubeMiter/DownTube_Head          polygon     TubeMiter/DownTube_Head                     $BB_Position
	rattleCAD::model::getObject    TubeMiter/DownTube_Seat          polygon     TubeMiter/DownTube_Seat                     $BB_Position
	rattleCAD::model::getObject    TubeMiter/Reference              polygon     TubeMiter/Reference                         $BB_Position
	rattleCAD::model::getObject    TubeMiter/SeatStay_01            polygon     TubeMiter/SeatStay_01                       $BB_Position
	rattleCAD::model::getObject    TubeMiter/SeatStay_02            polygon     TubeMiter/SeatStay_02                       $BB_Position
	rattleCAD::model::getObject    TubeMiter/SeatTube_BB_in         polygon     TubeMiter/SeatTube_BB_in                    $BB_Position
	rattleCAD::model::getObject    TubeMiter/SeatTube_BB_out        polygon     TubeMiter/SeatTube_BB_out                   $BB_Position
	rattleCAD::model::getObject    TubeMiter/SeatTube_Down          polygon     TubeMiter/SeatTube_Down                     $BB_Position
	rattleCAD::model::getObject    TubeMiter/TopTube_Head           polygon     TubeMiter/TopTube_Head                      $BB_Position
	rattleCAD::model::getObject    TubeMiter/TopTube_Seat           polygon     TubeMiter/TopTube_Seat                      $BB_Position
 	rattleCAD::model::getObject    ChainStay                        polygon     ChainStay                                   $BB_Position
    
    
    rattleCAD::model::getObject    Component/Carrier/Front/File         component    FrontCarrier      
    rattleCAD::model::getObject    Component/Carrier/Rear/File          component    RearCarrier       
    rattleCAD::model::getObject    Component/CrankSet/File              component    CrankSet          
    rattleCAD::model::getObject    Component/Derailleur/Front/File      component    FrontDerailleur   
    rattleCAD::model::getObject    Component/Derailleur/Rear/File       component    RearDerailleur  
    rattleCAD::model::getObject    Component/HandleBar/File             component    HandleBar       
    rattleCAD::model::getObject    Component/Logo/File]                 component    Logo
    rattleCAD::model::getObject    Component/Saddle/File                component    Saddle
    rattleCAD::model::getObject    Component/Brake/Front/File           component    FrontBrake        
    rattleCAD::model::getObject    Component/Brake/Rear/File            component    RearBrake      
    rattleCAD::model::getObject    Component/BottleCage/SeatTube/File   component    {BottleCage FileSeatTube}
    rattleCAD::model::getObject    Component/BottleCage/SeatTube/File   component    {BottleCage FileDownTube}
    rattleCAD::model::getObject    Component/BottleCage/SeatTube/File   component    {BottleCage FileDownTube_Lower}
   


    if {1 == 2} {
            CrankSet -
            FrontCarrier -
            FrontDerailleur -
            HandleBar -
            Hub -
            Logo -
            RearCarrier -
            RearDerailleur -
            RearDrop -
            Saddle {
                    set componentFile  [lindex [array get [namespace current]::$object {File}] 1]
                        # [array get $object $key] -> e.g. {RimDiameter 622.0} -> lindex 1
                        # puts " .... $object/$key  ... $value"
                    return $componentFile
                }                
            BottleCage -
            Brake -
            Fork 
    }
    
    # rattleCAD::model::getObject    Result/Position/SeatPost_Saddle  position  $BB_Position
	

