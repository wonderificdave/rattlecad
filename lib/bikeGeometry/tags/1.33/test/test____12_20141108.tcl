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
        variable statusValue "OK"

        
        namespace import ::bikeGeometry::get_Value 
        # namespace import ::bikeGeometry::get_Object
        namespace import ::bikeGeometry::get_Scalar
        namespace import ::bikeGeometry::get_Polygon
        namespace import ::bikeGeometry::get_Position
        namespace import ::bikeGeometry::get_Direction
        namespace import ::bikeGeometry::get_Component 
        namespace import ::bikeGeometry::get_Option 
            #
        proc getObject {index objectOld objectNew {centerPoint {0 0}} } {
                # puts " ... getObject $index $objectOld  $objectNew $centerPoint"
                #
            variable statusValue
                #
            if {$objectOld != {}} {
                switch -exact $index { 
                    rendering -
                    value {     set oldProcValue [::bikeGeometry::get_Value   $objectOld value]}
                    component { set oldProcValue [::bikeGeometry::get_Value   $objectOld component]}    
                    default {   set oldProcValue [::bikeGeometry::get_Object  $objectOld $index $centerPoint]}
                }
            } else {
                    set oldProcValue {}
            }
                #
            switch -exact $index {

                polygon {   set returnValue    [get_Polygon   $objectNew $centerPoint]}
                position {  set returnValue    [get_Position  $objectNew $centerPoint]}
                direction { set returnValue    [get_Direction $objectNew]}

                component {
                            if {[llength $objectNew] > 1} {
                                set object      [lindex $objectNew 0]
                                set key         [lindex $objectNew 1]
                                    # puts "    ... $object $key"
                                set returnValue [get_Component $object $key]
                            } else {
                                    # puts "    ... $objectNew"
                                set returnValue [get_Component $objectNew]
                            }
                        }
                        
                value {
                            set object      [lindex $objectNew 0]
                            set key         [lindex $objectNew 1]
                                    # puts "    ... $object $key"
                            set returnValue     [get_Scalar  $object $key]
                        }
                        
                rendering {
                            set returnValue     [get_Option  $objectNew ]
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
            set statusString "        "
                #
            if {$objectOld != {}} {
                if {$oldProcValue != $newProcValue } {
                    set statusString "  failed"
                    set statusValue "failed"
                }


            } else {
                if {$newProcValue == {}} {
                    set statusString "  failed"
                    set statusValue "failed"
                }
            }
                #
            puts "  ---------------------------------"            
            puts "     $statusString   $oldProcValue           <- $objectOld"   
            puts "     $statusString   $newProcValue           <- $objectNew"
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
                                    
	puts "\n -- direction --\n"                                                                                
	
    rattleCAD::model::getObject     direction   DownTube                            DownTube                         
	rattleCAD::model::getObject     direction   HeadTube                            HeadTube                         
	rattleCAD::model::getObject     direction   Steerer                             Steerer                         
	rattleCAD::model::getObject     direction   Lugs/Dropout/Front                  ForkDropout; #Lugs/Dropout/Front               
	rattleCAD::model::getObject     direction   Lugs/ForkCrown                      ForkCrown;   #Lugs/ForkCrown                   
	rattleCAD::model::getObject     direction   SeatStay                            SeatStay                         
	rattleCAD::model::getObject     direction   SeatTube                            SeatTube                         
	rattleCAD::model::getObject     direction   TopTube                             TopTube           
    rattleCAD::model::getObject     direction   ChainStay                           ChainStay
    rattleCAD::model::getObject     direction   RearDropout                         RearDropout        
    # exit
    
    puts "\n -- position --\n"                                                                                
	
    rattleCAD::model::getObject     position    BottomBracketGround                 BottomBracketGround                         $BB_Position

    rattleCAD::model::getObject     position    BrakeFront                          FrontBrakeShoe                              $BB_Position
    rattleCAD::model::getObject     position    {}                                  FrontBrakeHelp                              $BB_Position
    rattleCAD::model::getObject     position    {}                                  FrontBrakeDefinition                        $BB_Position
    rattleCAD::model::getObject     position    {}                                  FrontBrake                                  $BB_Position
    rattleCAD::model::getObject     position    BrakeRear                           RearBrakeShoe                               $BB_Position
    rattleCAD::model::getObject     position    {}                                  RearBrakeHelp                               $BB_Position
    rattleCAD::model::getObject     position    {}                                  RearBrakeDefinition                         $BB_Position
    rattleCAD::model::getObject     position    {}                                  RearBrake                                   $BB_Position
    
    # exit
    
    
    
    rattleCAD::model::getObject     position    CarrierMountFront                   CarrierMountFront                           $BB_Position
	rattleCAD::model::getObject     position    CarrierMountRear                    CarrierMountRear                            $BB_Position
	rattleCAD::model::getObject     position    ChainStay/SeatStay_IS               ChainStay/SeatStay_IS                       $BB_Position
	rattleCAD::model::getObject     position    DerailleurMountFront                DerailleurMountFront                        $BB_Position
	rattleCAD::model::getObject     position    DownTube/BottleCage/Base            DownTube/BottleCage/Base                    $BB_Position
	rattleCAD::model::getObject     position    DownTube/BottleCage/Offset          DownTube/BottleCage/Offset                  $BB_Position
	rattleCAD::model::getObject     position    DownTube/BottleCage_Lower/Base      DownTube/BottleCage_Lower/Base              $BB_Position
	rattleCAD::model::getObject     position    DownTube/BottleCage_Lower/Offset    DownTube/BottleCage_Lower/Offset            $BB_Position
	rattleCAD::model::getObject     position    DownTube/End                        DownTubeEnd                                 $BB_Position
	rattleCAD::model::getObject     position    DownTube/Start                      DownTubeStart                               $BB_Position
	rattleCAD::model::getObject     position    FrontWheel                          FrontWheel                                  $BB_Position
	rattleCAD::model::getObject     position    HandleBar                           HandleBar                                   $BB_Position
	rattleCAD::model::getObject     position    HeadTube/End                        HeadTubeEnd                                 $BB_Position
	rattleCAD::model::getObject     position    HeadTube/Start                      HeadTubeStart                               $BB_Position
	rattleCAD::model::getObject     position    Lugs/Dropout/Rear/Derailleur        RearDerailleur                              $BB_Position
	rattleCAD::model::getObject     position    Lugs/ForkCrown                      ForkCrown                                   $BB_Position
	rattleCAD::model::getObject     position    RearWheel                           RearWheel                                   $BB_Position
	rattleCAD::model::getObject     position    Reference_HB                        Reference_HB                                $BB_Position
	rattleCAD::model::getObject     position    Reference_SN                        Reference_SN                                $BB_Position
	rattleCAD::model::getObject     position    Saddle                              Saddle                                      $BB_Position
	rattleCAD::model::getObject     position    SaddleNose                          SaddleNose                                  $BB_Position
	rattleCAD::model::getObject     position    SaddleProposal                      SaddleProposal                              $BB_Position
	rattleCAD::model::getObject     position    SeatPostPivot                       SeatPostPivot                               $BB_Position
	rattleCAD::model::getObject     position    SeatPostSaddle                      SeatPostSaddle                              $BB_Position
	rattleCAD::model::getObject     position    SeatPostSeatTube                    SeatPostSeatTube                            $BB_Position
	rattleCAD::model::getObject     position    SeatStay/End                        SeatStayEnd                                 $BB_Position
	rattleCAD::model::getObject     position    SeatStay/Start                      SeatStayStart                               $BB_Position
	rattleCAD::model::getObject     position    SeatTube/BottleCage/Base            SeatTube/BottleCage/Base                    $BB_Position
	rattleCAD::model::getObject     position    SeatTube/BottleCage/Offset          SeatTube/BottleCage/Offset                  $BB_Position
	rattleCAD::model::getObject     position    SeatTube/End                        SeatTubeEnd                                 $BB_Position
	rattleCAD::model::getObject     position    SeatTube/Start                      SeatTubeStart                               $BB_Position
	rattleCAD::model::getObject     position    SeatTubeGround                      SeatTubeGround                              $BB_Position
	rattleCAD::model::getObject     position    SeatTubeSaddle                      SeatTubeSaddle                              $BB_Position
	rattleCAD::model::getObject     position    SeatTubeVirtualTopTube              SeatTubeVirtualTopTube                      $BB_Position
	rattleCAD::model::getObject     position    Steerer/End                         SteererEnd                                  $BB_Position
	rattleCAD::model::getObject     position    Steerer/Start                       SteererStart                                $BB_Position
	rattleCAD::model::getObject     position    SteererGround                       SteererGround                               $BB_Position
	rattleCAD::model::getObject     position    TopTube/End                         TopTubeEnd                                  $BB_Position
	rattleCAD::model::getObject     position    TopTube/Start                       TopTubeStart                                $BB_Position   
    rattleCAD::model::getObject     position    ChainStay/RearMockup                ChainStayRearMockup                         [list 0.0 0.0]
    # exit
    
    
    puts "\n -- polygon --\n"                                                                                
	
    rattleCAD::model::getObject     polygon     DownTube                            DownTube                                    $BB_Position
	rattleCAD::model::getObject     polygon     Fender/Front                        Fender/Front                                $FrontHub_Position
	rattleCAD::model::getObject     polygon     Fender/Rear                         Fender/Rear                                 $RearHub_Position
	rattleCAD::model::getObject     polygon     ForkBlade                           ForkBlade                                   $BB_Position
	rattleCAD::model::getObject     polygon     HeadSet/Bottom                      HeadSet/Bottom                              $BB_Position
	rattleCAD::model::getObject     polygon     HeadSet/Top                         HeadSet/Top                                 $BB_Position
	rattleCAD::model::getObject     polygon     HeadTube                            HeadTube                                    $BB_Position
	rattleCAD::model::getObject     polygon     SeatPost                            SeatPost                                    $BB_Position
	rattleCAD::model::getObject     polygon     SeatStay                            SeatStay                                    $BB_Position
	rattleCAD::model::getObject     polygon     SeatTube                            SeatTube                                    $BB_Position
	rattleCAD::model::getObject     polygon     Steerer                             Steerer                                     $BB_Position
	rattleCAD::model::getObject     polygon     Stem                                Stem                                        $BB_Position
	rattleCAD::model::getObject     polygon     TopTube                             TopTube                                     $BB_Position
	rattleCAD::model::getObject     polygon     TubeMiter/DownTube_BB_in            TubeMiter/DownTube_BB_in                    $BB_Position
	rattleCAD::model::getObject     polygon     TubeMiter/DownTube_BB_out           TubeMiter/DownTube_BB_out                   $BB_Position
	rattleCAD::model::getObject     polygon     TubeMiter/DownTube_Head             TubeMiter/DownTube_Head                     $BB_Position
	rattleCAD::model::getObject     polygon     TubeMiter/DownTube_Seat             TubeMiter/DownTube_Seat                     $BB_Position
	rattleCAD::model::getObject     polygon     TubeMiter/Reference                 TubeMiter/Reference                         $BB_Position
	rattleCAD::model::getObject     polygon     TubeMiter/SeatStay_01               TubeMiter/SeatStay_01                       $BB_Position
	rattleCAD::model::getObject     polygon     TubeMiter/SeatStay_02               TubeMiter/SeatStay_02                       $BB_Position
	rattleCAD::model::getObject     polygon     TubeMiter/SeatTube_BB_in            TubeMiter/SeatTube_BB_in                    $BB_Position
	rattleCAD::model::getObject     polygon     TubeMiter/SeatTube_BB_out           TubeMiter/SeatTube_BB_out                   $BB_Position
	rattleCAD::model::getObject     polygon     TubeMiter/SeatTube_Down             TubeMiter/SeatTube_Down                     $BB_Position
	rattleCAD::model::getObject     polygon     TubeMiter/TopTube_Head              TubeMiter/TopTube_Head                      $BB_Position
	rattleCAD::model::getObject     polygon     TubeMiter/TopTube_Seat              TubeMiter/TopTube_Seat                      $BB_Position
 	rattleCAD::model::getObject     polygon     ChainStay                           ChainStay                                   $BB_Position
                                    
    puts "\n -- component --\n"                                                                                
	
    rattleCAD::model::getObject     component   Component/Carrier/Front/File        FrontCarrier      
    rattleCAD::model::getObject     component   Component/Carrier/Rear/File         RearCarrier       
    rattleCAD::model::getObject     component   Component/CrankSet/File             CrankSet          
    rattleCAD::model::getObject     component   Component/Derailleur/Front/File     FrontDerailleur   
    rattleCAD::model::getObject     component   Component/Derailleur/Rear/File      RearDerailleur  
    rattleCAD::model::getObject     component   Component/HandleBar/File            HandleBar       
    rattleCAD::model::getObject     component   Component/Logo/File                 Logo
    rattleCAD::model::getObject     component   Component/Saddle/File               Saddle
    rattleCAD::model::getObject     component   Component/Brake/Front/File          FrontBrake        
    rattleCAD::model::getObject     component   Component/Brake/Rear/File           RearBrake      
    rattleCAD::model::getObject     component   Component/BottleCage/SeatTube/File  {BottleCage FileSeatTube}
    rattleCAD::model::getObject     component   Component/BottleCage/DownTube/File  {BottleCage FileDownTube}
    rattleCAD::model::getObject     component   Component/BottleCage/SeatTube/File  {BottleCage FileDownTube_Lower}
   
    puts "\n -- value --\n"                                                                                
	rattleCAD::model::getObject     value       Component/HandleBar/PivotAngle                          {HandleBar PivotAngle}
    rattleCAD::model::getObject     value       Component/HeadSet/Diameter                              {HeadSet Diameter}
    rattleCAD::model::getObject     value       Component/CrankSet/Length                               {CrankSet Length}
    # exit
    
    rattleCAD::model::getObject     value       Component/CrankSet/ArmWidth                             {CrankSet ArmWidth}
    rattleCAD::model::getObject     value       Component/CrankSet/ChainLine                            {CrankSet ChainLine}
    rattleCAD::model::getObject     value       Component/CrankSet/ChainRings                           {CrankSet ChainRings}
    rattleCAD::model::getObject     value       Component/CrankSet/Length                               {CrankSet Length}
    rattleCAD::model::getObject     value       Component/CrankSet/PedalEye                             {CrankSet PedalEye}
    rattleCAD::model::getObject     value       Component/CrankSet/Q-Factor                             {CrankSet Q-Factor}
    # exit
    
    rattleCAD::model::getObject     value       Component/Derailleur/Rear/Pulley/teeth                  {RearDerailleur Pulley_teeth}  
    rattleCAD::model::getObject     value       Component/Derailleur/Rear/Pulley/x                      {RearDerailleur Pulley_x}
    rattleCAD::model::getObject     value       Component/Derailleur/Rear/Pulley/y                      {RearDerailleur Pulley_y}
    # exit
    
    rattleCAD::model::getObject     value       Component/Fork/Crown/Brake/Angle                        {Fork BrakeAngle}
    rattleCAD::model::getObject     value       Component/Fork/Height                                   {Fork Height}
    rattleCAD::model::getObject     value       Component/Fork/Rake                                     {Fork Rake}
    # exit
    
    rattleCAD::model::getObject     value       Component/Saddle/Length                                 {Saddle Length}
    rattleCAD::model::getObject     value       Component/Saddle/Height                                 {Saddle SaddleHeight}
    rattleCAD::model::getObject     value       Component/Saddle/LengthNose                             {Saddle NoseLength}
    rattleCAD::model::getObject     value       Rendering/Saddle/Offset_X                               {Saddle Offset_X}
    rattleCAD::model::getObject     value       Rendering/Saddle/Offset_Y                               {Saddle Offset_Y}
    rattleCAD::model::getObject     value       Component/Stem/Length                                   {Stem Length}
    rattleCAD::model::getObject     value       Component/Stem/Angle                                    {Stem Angle}
    # exit
    
    rattleCAD::model::getObject     value       Component/Wheel/Front/RimDiameter                       {FrontWheel RimDiameter}
    rattleCAD::model::getObject     value       Component/Wheel/Front/TyreHeight                        {FrontWheel TyreHeight}
    rattleCAD::model::getObject     value       Component/Wheel/Rear/FirstSprocket                      {RearWheel FirstSprocket}
    rattleCAD::model::getObject     value       Component/Wheel/Rear/HubWidth                           {RearWheel HubWidth}
    rattleCAD::model::getObject     value       Component/Wheel/Rear/RimDiameter                        {RearWheel RimDiameter}
    rattleCAD::model::getObject     value       Component/Wheel/Rear/RimDiameter                        {RearWheel RimDiameter} 
    rattleCAD::model::getObject     value       Component/Wheel/Rear/TyreHeight                         {RearWheel TyreHeight}
    rattleCAD::model::getObject     value       Component/Wheel/Rear/TyreWidth                          {RearWheel TyreWidth}
    rattleCAD::model::getObject     value       Component/Wheel/Rear/TyreWidthRadius                    {RearWheel TyreWidthRadius}
    # exit
    
    rattleCAD::model::getObject     value       Custom/BottomBracket/Depth                              {BottomBracket Depth}
    rattleCAD::model::getObject     value       Lugs/BottomBracket/Diameter/outside                     {BottomBracket OutsideDiameter}
    rattleCAD::model::getObject     value       Lugs/BottomBracket/Diameter/inside                      {BottomBracket InsideDiameter}
    rattleCAD::model::getObject     value       Lugs/BottomBracket/Width                                {BottomBracket Width}
    rattleCAD::model::getObject     value       Lugs/BottomBracket/ChainStay/Offset_TopView             {BottomBracket OffsetCS_TopView}
    # exit
    
    
    rattleCAD::model::getObject     value       Custom/HeadTube/Angle                                   {HeadTube Angle}
    rattleCAD::model::getObject     value       Custom/SeatStay/OffsetTT                                {SeatStay OffsetTT}
    rattleCAD::model::getObject     value       Custom/SeatTube/Extension                               {SeatTube Extension}
    rattleCAD::model::getObject     value       Custom/TopTube/Angle                                    {TopTube Angle}
    # exit
    
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/CenterLine/angle_01                {ChainStay segmentAngle_01}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/CenterLine/angle_02                {ChainStay segmentAngle_02}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/CenterLine/angle_03                {ChainStay segmentAngle_03}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/CenterLine/angle_04                {ChainStay segmentAngle_04}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/CenterLine/length_01               {ChainStay segmentLength_01}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/CenterLine/length_02               {ChainStay segmentLength_02}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/CenterLine/length_03               {ChainStay segmentLength_03}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/CenterLine/length_04               {ChainStay segmentLength_04}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/CenterLine/radius_01               {ChainStay segmentRadius_01}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/CenterLine/radius_02               {ChainStay segmentRadius_02}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/CenterLine/radius_03               {ChainStay segmentRadius_03}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/CenterLine/radius_04               {ChainStay segmentRadius_04}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/DiameterSS                         {ChainStay DiameterSS}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/Height                             {ChainStay Height}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/HeightBB                           {ChainStay HeigthBB}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/Profile/completeLength             {ChainStay completeLength}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/Profile/cuttingLength              {ChainStay cuttingLength}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/Profile/length_01                  {ChainStay profile_x01}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/Profile/length_02                  {ChainStay profile_x02}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/Profile/length_03                  {ChainStay profile_x03}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/Profile/width_00                   {ChainStay profile_y00}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/Profile/width_01                   {ChainStay profile_y01}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/Profile/width_02                   {ChainStay profile_y02}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/Profile/width_03                   {ChainStay profile_y03}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/TaperLength                        {ChainStay TaperLength}
    rattleCAD::model::getObject     value       FrameTubes/ChainStay/WidthBB                            {ChainStay WidthBB}    
    # exit
    
    rattleCAD::model::getObject     value       FrameTubes/DownTube/DiameterBB                          {DownTube DiameterBB}
    rattleCAD::model::getObject     value       FrameTubes/DownTube/DiameterHT                          {DownTube DiameterHT}
    rattleCAD::model::getObject     value       FrameTubes/HeadTube/Diameter                            {HeadTube Diameter  }
    rattleCAD::model::getObject     value       FrameTubes/HeadTube/Length                              {HeadTube Length    }
    rattleCAD::model::getObject     value       FrameTubes/SeatStay/DiameterST                          {SeatStay DiameterST}
    rattleCAD::model::getObject     value       FrameTubes/SeatTube/DiameterBB                          {SeatTube DiameterBB}
    rattleCAD::model::getObject     value       FrameTubes/SeatTube/DiameterTT                          {SeatTube DiameterTT}
    rattleCAD::model::getObject     value       FrameTubes/TopTube/DiameterHT                           {TopTube  DiameterHT}
    rattleCAD::model::getObject     value       FrameTubes/TopTube/DiameterST                           {TopTube  DiameterST}  
    # exit
    
    rattleCAD::model::getObject     value       Lugs/RearDropOut/ChainStay/Offset                       {RearDropout OffsetCS}
	rattleCAD::model::getObject     value       Lugs/RearDropOut/ChainStay/OffsetPerp                   {RearDropout OffsetCSPerp}
	rattleCAD::model::getObject     value       Lugs/RearDropOut/ChainStay/Offset_TopView               {RearDropout OffsetCS_TopView}
    rattleCAD::model::getObject     value       Lugs/RearDropOut/Derailleur/y                           {RearDropout Derailleur_y}
    rattleCAD::model::getObject     value       Lugs/RearDropOut/Direction                              {RearDropout Direction}
    rattleCAD::model::getObject     value       Lugs/RearDropOut/File                                   {RearDropout File}
    rattleCAD::model::getObject     value       Lugs/RearDropOut/RotationOffset                         {RearDropout RotationOffset}
    # exit
    
    rattleCAD::model::getObject     value       Lugs/SeatTube/SeatStay/MiterDiameter                    {SeatStay SeatTubeMiterDiameter}
    # exit
    rattleCAD::model::getObject     value       Personal/HandleBar_Distance                             {HandleBar Distance}
    rattleCAD::model::getObject     value       Personal/HandleBar_Height                               {HandleBar Height}
    rattleCAD::model::getObject     value       Personal/Saddle_Distance                                {Saddle Distance}
    rattleCAD::model::getObject     value       Personal/Saddle_Height                                  {Saddle Height}
    # exit

    rattleCAD::model::getObject     value       Rendering/RearMockup/CassetteClearance                  {RearMockup CassetteClearance}
    rattleCAD::model::getObject     value       Rendering/RearMockup/ChainWheelClearance                {RearMockup ChainWheelClearance}
    rattleCAD::model::getObject     value       Rendering/RearMockup/CrankClearance                     {RearMockup CrankClearance}
    rattleCAD::model::getObject     value       Rendering/RearMockup/DiscClearance                      {RearMockup DiscClearance}
    rattleCAD::model::getObject     value       Rendering/RearMockup/DiscDiameter                       {RearMockup DiscDiameter}
    rattleCAD::model::getObject     value       Rendering/RearMockup/DiscOffset                         {RearMockup DiscOffset}
    rattleCAD::model::getObject     value       Rendering/RearMockup/DiscWidth                          {RearMockup DiscWidth}
    rattleCAD::model::getObject     value       Rendering/RearMockup/TyreClearance                      {RearMockup TyreClearance}
    # exit
    
    rattleCAD::model::getObject     value       Result/Length/RearWheel/horizontal                      {Geometry RearWheel_X}
    rattleCAD::model::getObject     value       Result/Length/Saddle/Offset_BB_Nose                     {Geometry SaddleNose_BB_X}
    rattleCAD::model::getObject     value       Result/Length/SeatTube/VirtualLength                    {Geometry SeatTube_VirtualLength}
    rattleCAD::model::getObject     value       Result/Length/TopTube/VirtualLength                     {Geometry TopTube_VirtualLength}
    # exit

    rattleCAD::model::getObject     rendering   Rendering/BottleCage/DownTube                           {BottleCage_DT}
    rattleCAD::model::getObject     rendering   Rendering/BottleCage/DownTube_Lower                     {BottleCage_DT_L}
    rattleCAD::model::getObject     rendering   Rendering/BottleCage/SeatTube                           {BottleCage_ST}
    rattleCAD::model::getObject     rendering   Rendering/Brake/Front                                   {FrontBrake}
    rattleCAD::model::getObject     rendering   Rendering/Brake/Rear                                    {RearBrake}
    rattleCAD::model::getObject     rendering   Rendering/ChainStay                                     {ChainStay}
    rattleCAD::model::getObject     rendering   Rendering/Fork                                          {Fork}
    rattleCAD::model::getObject     rendering   Rendering/ForkBlade                                     {ForkBlade}
    rattleCAD::model::getObject     rendering   Rendering/ForkDropOut                                   {ForkDropout}
    rattleCAD::model::getObject     rendering   Rendering/RearDropOut                                   {RearDropout}
    # exit
    


    puts "\n"
    puts "    ...         $::rattleCAD::model::statusValue"

        
        exit
        
    rattleCAD::model::getObject     value       Result/Tubes/ChainStay/RearMockup/CenterLine            Result/Tubes/ChainStay/RearMockup/CenterLine
    rattleCAD::model::getObject     value       Result/Tubes/ChainStay/RearMockup/CenterLineUnCut       Result/Tubes/ChainStay/RearMockup/CenterLineUnCut
    rattleCAD::model::getObject     value       Result/Tubes/ChainStay/RearMockup/CtrLines              Result/Tubes/ChainStay/RearMockup/CtrLines
    
    # rattleCAD::model::getObject     value       Result/Tubes/ChainStay/RearMockup/Polygon               Result/Tubes/ChainStay/RearMockup/Polygon
    # rattleCAD::model::getObject     value       Custom/WheelPosition/Rear                               {WheelPosition/Rear}
    # set ChainStay(Rendering)            $project::Rendering(ChainStay)
            
    
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
	

