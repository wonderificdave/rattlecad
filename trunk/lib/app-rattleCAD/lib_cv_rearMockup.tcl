 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_cv_custom.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2010/10/24
 #
 # The author  hereby grant permission to use,  copy, modify, distribute,
 # and  license this  software  and its  documentation  for any  purpose,
 # provided that  existing copyright notices  are retained in  all copies
 # and that  this notice  is included verbatim  in any  distributions. No
 # written agreement, license, or royalty  fee is required for any of the
 # authorized uses.  Modifications to this software may be copyrighted by
 # their authors and need not  follow the licensing terms described here,
 # provided that the new terms are clearly indicated on the first page of
 # each file where they apply.
 #
 # IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
 # FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
 # ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
 # DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
 # POSSIBILITY OF SUCH DAMAGE.
 #
 # THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
 # INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
 # MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
 # NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN "AS  IS" BASIS,
 # AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
 # MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.  
 #
 # ---------------------------------------------------------------------------
 #    namespace:  rattleCAD::cv_custom
 # ---------------------------------------------------------------------------
 #
 # 

    
    variable  rattleCAD::cv_custom::ctrl_Points
    array set rattleCAD::cv_custom::ctrl_Points {}
    
    proc rattleCAD::cv_custom::createRearMockup {cv_Name} {
            
            puts ""
            puts "   -------------------------------"
            puts "     rattleCAD::cv_custom::createLugRep"
            puts "       cv_Name:         $cv_Name"
             
                variable    stageScale

                variable    BottomBracket   
                variable    RearWheel
                
                array set   ChainStay       {}
                array set   Length          {}
                array set   Center          {}
                array set   ClearChainWheel {}             
                array set   ClearCassette   {}             
                
                array set   Colour          {}
                      set   Colour(primary)     darkred
                      set   Colour(secondary)   darkorange
                      set   Colour(third)       orange
                      set   Colour(result)      darkblue
                
            set Length(ChainStay)           [rattleCAD::control::getValue Custom/WheelPosition/Rear]
            set Length(CrankSet)            [rattleCAD::control::getValue Component/CrankSet/Length]
            set Length(PedalMount)          [expr 0.5 * [rattleCAD::control::getValue Component/CrankSet/Q-Factor] ]
            set Length(PedalEye)            [rattleCAD::control::getValue Component/CrankSet/PedalEye]
            set Length(CrankSet_ArmWidth)   [rattleCAD::control::getValue Component/CrankSet/ArmWidth]
            set Length(ChainLine)           [rattleCAD::control::getValue Component/CrankSet/ChainLine]

                 #   puts "     BottomBracket(Position) -> $BottomBracket(Position)"
                 #   puts "     RearWheel(Position)    -> $RearWheel(Position)"
                 #   puts "       -> $Length(ChainStay)"
                    
                 #   puts "     BottomBracket -> [rattleCAD::control::getValue Lugs/BottomBracket/Diameter/outside]"
                 #   puts "     BottomBracket -> [rattleCAD::control::getValue Lugs/BottomBracket/Diameter/inside]"
                 #   puts "     BottomBracket -> [rattleCAD::control::getValue Lugs/BottomBracket/Width]"
                 #   puts "     BottomBracket -> [rattleCAD::control::getValue Lugs/BottomBracket/ChainStay/Offset_TopView]"
                    
                 #   puts "     RimDiameter   -> [rattleCAD::control::getValue Component/Wheel/Rear/RimDiameter]"
                 #   puts "     RimHeight     -> [rattleCAD::control::getValue Component/Wheel/Rear/RimHeight]"
                 #   puts "     TyreHeight    -> [rattleCAD::control::getValue Component/Wheel/Rear/TyreHeight]"
                    
                 #   puts "     HubWidth      -> [rattleCAD::control::getValue Lugs/RearDropOut/HubWidth]"
                    
                 #   puts "     ChainStay     -> [rattleCAD::control::getValue Lugs/RearDropOut/ChainStay/Offset]" 
                 #   puts "     ChainStay     -> [rattleCAD::control::getValue Lugs/RearDropOut/ChainStay/Offset_TopView]" 
                 #   puts "     ChainStay     -> [rattleCAD::control::getValue FrameTubes/ChainStay/Width]" 
            
            #puts "  -> profile_x04   [rattleCAD::control::getValue FrameTubes/ChainStay/Profile/length_04] profile_x04   [rattleCAD::control::getValue FrameTubes/ChainStay/Profile/length_04]"
        
            set Length(00)              [ expr 0.5 * [rattleCAD::control::getValue Lugs/BottomBracket/Diameter/outside] ]
            set Length(01)              [ expr 0.5 * [rattleCAD::control::getValue Lugs/BottomBracket/Diameter/inside] ]
            set Length(02)              [ expr 0.5 * [rattleCAD::control::getValue Lugs/BottomBracket/Width] ]
            set Length(03)              [ expr $Length(02) - [rattleCAD::control::getValue Lugs/BottomBracket/ChainStay/Offset_TopView] ]
            set Length(04)              [ expr 0.5 * [rattleCAD::control::getValue Component/Wheel/Rear/HubWidth] ]
            set Length(05)              [ expr 0.5 * [rattleCAD::control::getValue Component/Wheel/Rear/HubWidth] + [rattleCAD::control::getValue Lugs/RearDropOut/ChainStay/Offset_TopView]]
            set Length(06)              [ expr 0.5 * [rattleCAD::control::getValue Component/Wheel/Rear/RimDiameter] + [rattleCAD::control::getValue Component/Wheel/Rear/TyreHeight] - [rattleCAD::control::getValue Component/Wheel/Rear/TyreWidthRadius]]

            
            set Center(BottomBracket)   {0 0}
            set Center(Dim_BBWidth_01)  [ list $Length(00) [expr -1.0 * $Length(02)] ]
            set Center(Dim_BBWidth_02)  [ list $Length(00) $Length(02) ]
            set Center(Dim_BBDiameter)  [ list [expr -1.0 * $Length(00)] $Length(02) ]
            set Center(Dim_BBDiam_01)   [ list $Length(01) $Length(02) ]
            set Center(Dim_BBDiam_02)   [ list [expr -1.0 * $Length(01)] $Length(02) ]
            set Center(RearHub)         [ list [expr -1 * $Length(ChainStay)] 0 ]
            set Center(Dim_RearHub_01)  [ list [expr -1 * $Length(ChainStay)] $Length(04) ]
            set Center(Dim_RearHub_02)  [ list [expr -1 * $Length(ChainStay)] [expr -1.0 * $Length(04)] ]
            set Center(CL_BB_01)        [ list 0 [expr -1.0 * $Length(04) -15] ]
            set Center(CL_BB_02)        [ list 0 [expr $Length(04) + 15] ]    
            set Center(CL_RearHub_01)   [ list [expr -1 * $Length(ChainStay)] [expr -1.0 * $Length(04) -15] ]
            set Center(CL_RearHub_02)   [ list [expr -1 * $Length(ChainStay)] [expr $Length(04) + 15] ]    
            set Center(DropOut)         [ list [expr -1 * $Length(ChainStay)] $Length(04) ]
            set Center(Tyre)            [ vectormath::addVector $Center(RearHub)    [ list [expr 0.5 * ([rattleCAD::control::getValue Component/Wheel/Rear/RimDiameter] + [rattleCAD::control::getValue Component/Wheel/Rear/TyreHeight])] 0 ] ]
            set Center(Rim)             [ vectormath::addVector $Center(RearHub)    [ list [expr 0.5 *  [rattleCAD::control::getValue Component/Wheel/Rear/RimDiameter]] 0 ] ]
            set Center(TyreWidth)       [ vectormath::addVector $Center(RearHub)    [ list [rattleCAD::control::getValue Component/Wheel/Rear/TyreWidthRadius] 0 ] ]
            set Center(Dim_WheelRadius) [ vectormath::addVector $Center(Tyre)       [ list [expr 0.5 *  [rattleCAD::control::getValue Component/Wheel/Rear/TyreHeight]] 0 ] ]
            set Center(Dim_Tyre_01)     [ vectormath::addVector $Center(TyreWidth)  [ list 0 [expr  0.5 * [rattleCAD::control::getValue Component/Wheel/Rear/TyreWidth]] ] ]
            set Center(Dim_Tyre_02)     [ vectormath::addVector $Center(TyreWidth)  [ list 0 [expr -0.5 * [rattleCAD::control::getValue Component/Wheel/Rear/TyreWidth]] 0 ] ]
            
            
            set Center(ChainStay_DO)    [ vectormath::addVector $Center(RearHub) [ list [rattleCAD::control::getValue Lugs/RearDropOut/ChainStay/Offset]  [ expr $Length(04) + [rattleCAD::control::getValue Lugs/RearDropOut/ChainStay/Offset_TopView]] ] ]
            set ChainStay(00)           [ list [expr -1.0 * $Length(01)] $Length(03) ] 
            set Center(ChainStay_00)    [ vectormath::cathetusPoint $Center(ChainStay_DO) $ChainStay(00) [expr 0.5 * [rattleCAD::control::getValue FrameTubes/ChainStay/WidthBB]] opposite ]
      
                #   puts "   -> Center(Tyre)  $Center(Tyre)"
            
            set ChainStay(91)           [ list [expr -1.0 * $Length(ChainStay)] [expr -1 * $Length(05)] ]   ;# dimension: ChainStay Center DO
            set ChainStay(92)           [ list [expr -1.0 * $Length(ChainStay)] [expr -1 * $Length(04)] ]   ;# dimension: Center DO
            set ChainStay(93)           [ list [expr -1.0 * $Length(01)] [expr -1 * $Length(03)] ]          ;# dimension: ChainStay outside BB
            set ChainStay(94)           [ list $Length(00)               [expr -1 * $Length(02)] ]          ;# dimension: Corner BB
            set ChainStay(95)           [ list [expr -1.0 * ($Length(ChainStay) - [rattleCAD::control::getValue Lugs/RearDropOut/ChainStay/Offset])] [expr -1 * $Length(05)] ]   ;# dimension: Chainstay Center DO
            set ChainStay(96)           [ list [expr -1.0 * ($Length(ChainStay) - [rattleCAD::control::getValue Lugs/RearDropOut/ChainStay/Offset])] [expr  1 * $Length(05)] ]   ;# dimension: Chainstay Center DO
                                        

                # -- create RearHub & CrankArm (position CrankArm on top at the end of procedure
            create_RearHub
            create_CrankArm
            
                # -- ChainStay Area      
            create_ClearArea

                # -- create DropOuts
            create_DropOut
            
                # -- create Tyre
            create_Tyre
            

               # -- create Bottom Bracket - Outer Shell
            set retValues [get_BottomBracket]
            set  BB_OutSide [lindex $retValues 0]
            set  BB_InSide  [lindex $retValues 1]
            $cv_Name create rectangle   $BB_OutSide   -outline blue     -fill $rattleCAD::view::colorSet(chainStay_1)  -width 1.0  -tags __Lug__
                                                                     #  -fill lightgray 

                # -- ChainStay Type
            switch [rattleCAD::control::getValue Rendering/ChainStay] {
                   {straight_}  { set retValues [get_ChainStay straight] }
                   {bent_}      { set retValues [get_ChainStay bent]}
                   {straight}   { set retValues [bikeGeometry::get_ChainStay_RearMockup straight] }
                   {bent}       { set retValues [bikeGeometry::get_ChainStay_RearMockup bent]}
                   
                   {off}        {}
                   default      { puts "\n  <W> ... not defined in createRearMockup: [rattleCAD::control::getValue Rendering/ChainStay]\n"
                                  # return
                                }
            }
            switch [rattleCAD::control::getValue Rendering/ChainStay] {
                   {straight}   -
                   {bent}       { set ChainStay(centerLine) [lindex $retValues 0]
                                  set ChainStay(polygon)    [lindex $retValues 1]
                                  set ChainStay(ctrLines)   [lindex $retValues 2]
                                    # puts "\n --> \$ChainStay(ctrLines) $ChainStay(ctrLines)"
                                  set tube_CS_left    [ $cv_Name create polygon     $ChainStay(polygon)      -fill $rattleCAD::view::colorSet(chainStay) \
                                                                                                             -outline black  -tags __Tube__ ]
                                  set tube_CS_CLine   [ $cv_Name create line        $ChainStay(centerLine)   -fill $rattleCAD::view::colorSet(chainStay_CL) \
                                                                                                             -tags __CenterLine__ ]
                                      set polygon_opposite {}
                                      foreach {x y}  $ChainStay(polygon) {
                                              lappend polygon_opposite $x [expr -1.0 * $y]
                                      }  
                                  set tube_CS_right   [ $cv_Name create polygon     $polygon_opposite        -fill $rattleCAD::view::colorSet(chainStay) \
                                                                                                             -outline black  -tags {__Tube__} ]

                                      #$ext_cvName  create   polygon $outLine    -tags __Tube__         -fill lightgray
                                      #$ext_cvName  create   line    $centerLine -tags __CenterLine__   -fill blue
                                      #$ext_cvName  create   polygon      ...                           -fill gray -outline black  
                                    
                                  rattleCAD::view::gui::object_CursorBinding   $cv_Name    $tube_CS_CLine
                                  rattleCAD::view::gui::object_CursorBinding   $cv_Name    $tube_CS_left
                                  rattleCAD::view::gui::object_CursorBinding   $cv_Name    $tube_CS_right
                                   
                                  $cv_Name bind   $tube_CS_CLine    <Double-ButtonPress-1> \
                                                  [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                              {   list://Rendering(ChainStay@SELECT_ChainStay) } {ChainStay:  CenterLine}]                               
                                  $cv_Name bind   $tube_CS_left    <Double-ButtonPress-1> \
                                                  [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                              {   list://Rendering(ChainStay@SELECT_ChainStay) } {ChainStay:  Type}]
                                  $cv_Name bind   $tube_CS_right   <Double-ButtonPress-1> \
                                                  [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                              {   list://Rendering(ChainStay@SELECT_ChainStay) } {ChainStay:  Type}]
                                }
                   default      { set ChainStay(polygon) {} }
            }

               # -- finisch Bottom Bracket  - Inner Shell
            $cv_Name create rectangle   $BB_InSide   -outline $rattleCAD::view::colorSet(frameTube_OL) \
                                                     -fill $rattleCAD::view::colorSet(chainStay_2) \
                                                     -width 1.0  -tags __Lug__

               # -- create BrakeDisc
            set brakeDisc [create_BrakeDisc]
            rattleCAD::view::gui::object_CursorBinding   $cv_Name    $brakeDisc
            $cv_Name bind   $brakeDisc    <Double-ButtonPress-1> \
                      [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                  {   Rendering(RearMockup/DiscDiameter) \
                                                      Rendering(RearMockup/DiscWidth) \
                                                      Rendering(RearMockup/DiscClearance) } {DiscBrake Details}]

               # -- create control Curves
            create_ControlCurves    

               # -- create tubeProfile Edit
               # -- create centerLine Edit
            switch -exact [rattleCAD::control::getValue Rendering/ChainStay] {
                   {bent} { create_centerLine_Edit   $ChainStay(ctrLines) {0 110}
                            create_tubeProfile_Edit  {0 145}
                          }
                   default {create_tubeProfile_Edit  {0  95}
                          }
            }
   
                # -- centerlines
            $cv_Name create centerline     [ appUtil::flatten_nestedList $Center(CL_BB_01)         $Center(CL_BB_02) ] \
                                                                            -fill gray50       -width 0.25     -tags __CenterLine__
            $cv_Name create centerline     [ appUtil::flatten_nestedList $Center(CL_RearHub_01)    $Center(CL_RearHub_02) ] \
                                                                            -fill gray50       -width 0.25     -tags __CenterLine__         
            $cv_Name create centerline     [ appUtil::flatten_nestedList $Center(BottomBracket) $Center(RearHub)] \
                                                                            -fill gray50       -width 0.25     -tags __CenterLine__
           

                # -- mark positions of dimensions
            $cv_Name create circle      $ChainStay(96)          -radius 2   -outline red         -width 1.0        -tags __CenterLine__
            $cv_Name create circle      $ChainStay(95)          -radius 2   -outline red         -width 1.0        -tags __CenterLine__
            $cv_Name create circle      $ChainStay(93)          -radius 2   -outline red         -width 1.0        -tags __CenterLine__
            $cv_Name create circle      $Center(Dim_RearHub_01) -radius 2   -outline red         -width 1.0        -tags __CenterLine__
            $cv_Name create circle      $Center(Dim_RearHub_02) -radius 2   -outline red         -width 1.0        -tags __CenterLine__
            $cv_Name create circle      $Center(ChainLine)      -radius 1   -outline red         -width 1.0        -tags __CenterLine__
            
            $cv_Name create circle      $Center(BottomBracket)  -radius 3   -outline red         -width 1.0        -tags __CenterLine__
            $cv_Name create circle      $Center(RearHub)        -radius 3   -outline blue        -width 1.0        -tags __CenterLine__

                # -- dimensions
                #

                # -- Wheel radius
            set _dim_Wh_Radius          [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_WheelRadius) $Center(CL_RearHub_01) ] \
                                                                    horizontal      [expr   45 * $stageScale]   [expr -80 * $stageScale]  \
                                                                    gray50 ]
            set _dim_Rim_Radius         [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Rim) $Center(CL_RearHub_01) ] \
                                                                    horizontal      [expr   35 * $stageScale]   [expr   0 * $stageScale]  \
                                                                    gray50 ]
            set _dim_Tyre_Height        [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_WheelRadius) $Center(Rim) ] \
                                                                    horizontal      [expr   35 * $stageScale]   [expr   0 * $stageScale]  \
                                                                    gray50 ]                                                                                                              
            set _dim_Tyre_CapHeight     [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_WheelRadius) $Center(TyreWidth) ] \
                                                                    horizontal      [expr   25 * $stageScale]   [expr  20 * $stageScale]  \
                                                                    gray50 ]                                                                                                              
            set _dim_Sprocket_CL        [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_RearHub_02) $Center(SprocketClearance) ] \
                                                                    horizontal      [expr  -25 * $stageScale]   [expr  -5 * $stageScale]  \
                                                                    gray50 ]
            set _dim_Tyre_CL            [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Tyre) $Center(TyreClearance) ] \
                                                                    vertical        [expr   65 * $stageScale]   [expr  20 * $stageScale]  \
                                                                    gray50 ]
            set _dim_Tyre_Width         [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_Tyre_01) $Center(Dim_Tyre_02) ] \
                                                                    vertical        [expr   35 * $stageScale]   [expr   3 * $stageScale]  \
                                                                    $Colour(primary) ]  
            set _dim_Tyre_Radius        [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(TyreWidth) $Center(CL_RearHub_01) ] \
                                                                    horizontal      [expr   25 * $stageScale]   [expr  50 * $stageScale]  \
                                                                    $Colour(primary) ]   
                   rattleCAD::view::gui::object_CursorBinding     $cv_Name    $_dim_Tyre_Width
                   $cv_Name bind $_dim_Tyre_Width        <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Component(Wheel/Rear/TyreWidth) ]
                   rattleCAD::view::gui::object_CursorBinding     $cv_Name    $_dim_Tyre_Radius       
                   $cv_Name bind $_dim_Tyre_Radius       <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Component(Wheel/Rear/TyreWidthRadius) ]

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         

                # -- ChainStay length
            set _dim_CS_Length             [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(CL_RearHub_01) $Center(CL_BB_01) ] \
                                                                    horizontal        [expr  40 * $stageScale]   [expr 0 * $stageScale]  \
                                                                    $Colour(result) ] 
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $_dim_CS_Length
                    $cv_Name bind $_dim_CS_Length        <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Custom(WheelPosition/Rear) ]

                    
                # -- BottomBracket
            set _dim_BB_Diam_inside     [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_BBDiam_01) $Center(Dim_BBDiam_02) ] \
                                                                    horizontal        [expr  20 * $stageScale]    [expr  35 * $stageScale]  \
                                                                    $Colour(primary) ] 
            set _dim_BB_Diam_outside    [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_BBWidth_02) $Center(Dim_BBDiameter) ] \
                                                                    horizontal        [expr  35 * $stageScale]    [expr  35 * $stageScale]  \
                                                                    $Colour(primary) ] 
            set _dim_BB_Width           [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_BBWidth_01) $Center(Dim_BBWidth_02) ] \
                                                                    vertical        [expr  35 * $stageScale]    [expr -10 * $stageScale]  \
                                                                    $Colour(primary) ] 
            set _dim_CS_BB_Offset       [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $ChainStay(93) $ChainStay(94) ] \
                                                                    vertical        [expr -60 * $stageScale]   [expr  15 * $stageScale]  \
                                                                    $Colour(primary) ] 
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $_dim_BB_Diam_inside       
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $_dim_BB_Diam_outside       
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $_dim_BB_Width       
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $_dim_CS_BB_Offset       
                    $cv_Name bind $_dim_BB_Diam_inside  <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Lugs(BottomBracket/Diameter/inside) ]
                    $cv_Name bind $_dim_BB_Diam_outside <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Lugs(BottomBracket/Diameter/outside) ]
                    $cv_Name bind $_dim_BB_Width        <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Lugs(BottomBracket/Width) ]
                    $cv_Name bind $_dim_CS_BB_Offset    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Lugs(BottomBracket/ChainStay/Offset_TopView) ]

                    
                # -- BrakeDisc
            set _dim_BrakeDisc_Dist_Hub [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(p_brakeDisc_03) $Center(Dim_RearHub_01) ] \
                                                                    vertical        [expr   2 * $stageScale]    [expr  20 * $stageScale]  \
                                                                    $Colour(primary) ] 
            set _dim_BrakeDisc_Dist_DO  [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(p_brakeDisc_01) $Center(Dim_RearHub_01) ] \
                                                                    vertical        [expr  15 * $stageScale]    [expr -20 * $stageScale]  \
                                                                    $Colour(result) ] 
            set _dim_BrakeDisc_Diameter [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(CL_RearHub_02)  $Center(p_brakeDisc_01) ] \
                                                                    horizontal      [expr -10 * $stageScale]    0 \
                                                                    $Colour(result) ] 
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $_dim_BrakeDisc_Dist_Hub       
                    $cv_Name bind $_dim_BrakeDisc_Dist_Hub  <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Rendering(RearMockup/DiscOffset) ]


                # -- RearHub
            set _dim_Hub_Width          [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_RearHub_01) $Center(Dim_RearHub_02) ] \
                                                                    vertical        [expr  40 * $stageScale]    [expr -10 * $stageScale]  \
                                                                    $Colour(primary) ] 
            set _dim_CS_DO_Distance     [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(CL_RearHub_01) $ChainStay(95) ] \
                                                                    horizontal      [expr  25 * $stageScale]    0  \
                                                                    $Colour(primary) ] 
            set _dim_CS_DO_Offset       [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $ChainStay(92) $ChainStay(95) ] \
                                                                    vertical        [expr -45 * $stageScale]    [expr -30 * $stageScale]  \
                                                                    $Colour(primary) ] 
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $_dim_Hub_Width            
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $_dim_CS_DO_Distance
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $_dim_CS_DO_Offset
                    $cv_Name bind $_dim_Hub_Width       <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Component(Wheel/Rear/HubWidth) ]
                    $cv_Name bind $_dim_CS_DO_Distance  <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Lugs(RearDropOut/ChainStay/Offset) ]
                    $cv_Name bind $_dim_CS_DO_Offset    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Lugs(RearDropOut/ChainStay/Offset_TopView) ]
                  
                  
                  #[rattleCAD::control::getValue Lugs/RearDropOut/ChainStay/Offset)                                            
                                                                    
                # -- CrankSet
            set _dim_Crank_Length       [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Q_Factor) $Center(CL_BB_01) ] \
                                                                    horizontal        [expr   20 * $stageScale]    [expr -30 * $stageScale]  \
                                                                    $Colour(primary) ]
            set _dim_PedalEye           [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(PedalEye) $Center(Q_Factor) ] \
                                                                    horizontal        [expr   20 * $stageScale]    [expr  20 * $stageScale]  \
                                                                    $Colour(primary) ]
            set _dim_Crank_Q_Factor     [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_Q_Factor) $Center(PedalEye) ] \
                                                                    vertical        [expr   45 * $stageScale]    [expr  15 * $stageScale]  \
                                                                    $Colour(primary) ]
            set _dim_CrankArmWidth      [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(CrankArm) $Center(PedalEye) ] \
                                                                    vertical        [expr   20 * $stageScale]    [expr -20 * $stageScale]  \
                                                                    $Colour(primary) ]
                                                                    
            set _dim_ChainLine          [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(BottomBracket) $Center(ChainLine) ] \
                                                                    vertical        [expr  -90 * $stageScale]    [expr  0 * $stageScale]  \
                                                                    $Colour(primary) ]
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $_dim_Crank_Length       
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $_dim_PedalEye       
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $_dim_Crank_Q_Factor
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $_dim_CrankArmWidth       
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $_dim_ChainLine
                    $cv_Name bind $_dim_Crank_Length    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Component(CrankSet/Length) ]
                    $cv_Name bind $_dim_PedalEye        <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Component(CrankSet/PedalEye) ]
                    $cv_Name bind $_dim_Crank_Q_Factor  <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Component(CrankSet/Q-Factor) ]
                    $cv_Name bind $_dim_CrankArmWidth   <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Component(CrankSet/ArmWidth) ]
                    $cv_Name bind $_dim_ChainLine       <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Component(CrankSet/ChainLine) ]
           
           
           
                # -- create CrankArm
            #create_CrankArm
            $cv_Name raise {__CrankArm__}
            
            
            return           

    }
    
    proc rattleCAD::cv_custom::create_Tyre {} {
            upvar  1 cv_Name        ext_cvName              
            upvar  1 Length         ext_Length
            upvar  1 Center         ext_Center
            upvar  1 ClearCassette  ext_ClearCassette
    
            # -- tyre Representation 
            set tyre_RadiusHeight $ext_Length(06)
            set tyre_RadiusWidth  [expr 0.5 * [rattleCAD::control::getValue Component/Wheel/Rear/TyreWidth]]
            set tyre_00    [vectormath::addVector $ext_Center(TyreWidth) [list $tyre_RadiusHeight [expr -1.0*$tyre_RadiusWidth] ]]
            set tyre_01    [vectormath::addVector $ext_Center(TyreWidth) [list [expr -1.0*$tyre_RadiusHeight] $tyre_RadiusWidth ]]
            set ovalMatrix   [appUtil::flatten_nestedList  $tyre_00 $tyre_01 ]                     
            
            set pt_01      [vectormath::addVector  $ext_Center(TyreWidth) {-10 0}]
            set pt_02      [vectormath::addVector  $ext_Center(Rim)        {-8  0}]
            set tyre_03    [vectormath::addVector  $ext_Center(TyreWidth)   {0 -1} $tyre_RadiusWidth]
            set tyre_04    [vectormath::addVector  $pt_01                   {0 -1} $tyre_RadiusWidth]
            set tyre_05    [vectormath::addVector  $pt_02                   {0 -1} 9]
            set tyre_06    [vectormath::addVector  $pt_02                   {0  1} 9]
            set tyre_07    [vectormath::addVector  $pt_01                   {0  1} $tyre_RadiusWidth]
            set tyre_08    [vectormath::addVector  $ext_Center(TyreWidth)   {0  1} $tyre_RadiusWidth]
            set polygonMatrix  [appUtil::flatten_nestedList  $tyre_03 $tyre_04  $tyre_05 $tyre_06 $tyre_07 $tyre_08 ]
            
            set tyre_04    [vectormath::addVector  $ext_Center(TyreWidth)   {0 -1} $tyre_RadiusWidth]
            set tyre_05    [vectormath::addVector  $ext_Center(RearHub)     [list 30 [expr -1.0 * $tyre_RadiusWidth] ] ]
            set tyre_06    [vectormath::addVector  $ext_Center(RearHub)     {1 0}  35 ]
            set tyre_07    [vectormath::addVector  $ext_Center(RearHub)     [list -35 $tyre_RadiusWidth] ]
            set tyre_08    [vectormath::addVector  $ext_Center(TyreWidth)   {0 1} $tyre_RadiusWidth]
            set polygonMatrix  [appUtil::flatten_nestedList  $tyre_04  $tyre_05 $tyre_06 $tyre_07 $tyre_08 ]
            
            
                           $ext_cvName create oval      $ovalMatrix      -fill gray     -width 1.0  -tags {__Component__}
            set _tyreObj [ $ext_cvName create polygon   $polygonMatrix   -fill gray     -width 1.0  -tags {__Component__}]
            
                           $ext_cvName create ovalarc   $ovalMatrix      -outline black -width 1.0  -tags {__Component__} \
                                                                         -start 270     -extent 180       -style arc
                           $ext_cvName create line      $polygonMatrix   -fill black    -width 1.0  -tags {__Component__}
            
            rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $_tyreObj
            $ext_cvName    bind $_tyreObj    <Double-ButtonPress-1> [list rattleCAD::view::createEdit  %x %y  $ext_cvName  \
                                                   {Component(Wheel/Rear/TyreWidthRadius) \
                                                    Component(Wheel/Rear/TyreWidth) \
                                                    Rendering(RearMockup/TyreClearance)}  {Rear Tyre Parameter}]
                                                                                                                                                                                                                                                        
    }    
    

    proc rattleCAD::cv_custom::create_RearHub {} {   
            upvar  1 cv_Name        ext_cvName              
            upvar  1 Length         ext_Length
            upvar  1 Center         ext_Center
            upvar  1 ClearCassette  ext_ClearCassette
            
                set length03                [ expr 0.5 *  18]
                set pointList               [ vectormath::addVectorPointList $ext_Center(RearHub) [list [expr -1*$length03] [expr -1*$ext_Length(04)] $length03 $ext_Length(04)] ]
            set hubRep          [ $ext_cvName create rectangle   $pointList            -outline $rattleCAD::view::colorSet(frameTube_OL) \
                                                                                       -width 1.0    -tags __CenterLine__ ]
                     
            
               # -- rear hub representation
            set RearHub(file)   [ rattleCAD::rendering::checkFileString {etc:hub/rattleCAD_rear.svg} ]
            set RearHub(object) [ $ext_cvName readSVG $RearHub(file) $ext_Center(RearHub)  0  __HubRear__ ]
                                  $ext_cvName addtag  __Decoration__ withtag $RearHub(object)
            
            
                # -- create first Sprocket of Cassete
            set sp_position     [ vectormath::addVector  $ext_Center(RearHub) {0 1} [ expr $ext_Length(04) - 3 ] ]
            set sp_object       [ get_ChainWheel [rattleCAD::control::getValue Component/Wheel/Rear/FirstSprocket] 2 $sp_position ]
            set sp_polygon      [ lindex $sp_object 1 ]
            set sp_clearance    [ lindex $sp_object 2 ]
            set sprocketRep     [ $ext_cvName create polygon     $sp_polygon     -fill gray -outline black  -tags __Component__ ]
            
            set ext_ClearCassette(1)    $sp_clearance
            
            rattleCAD::view::gui::object_CursorBinding    $ext_cvName $hubRep
            $ext_cvName bind   $hubRep    <Double-ButtonPress-1> \
                               [list rattleCAD::view::createEdit  %x %y  $ext_cvName  \
                                            {    Component(Wheel/Rear/HubWidth) \
                                                 text://Component(Wheel/Rear/FirstSprocket) }            {RearHub: }]                                                       
            
            rattleCAD::view::gui::object_CursorBinding    $ext_cvName $sprocketRep
            $ext_cvName bind   $sprocketRep    <Double-ButtonPress-1> \
                               [list rattleCAD::view::createEdit  %x %y  $ext_cvName  \
                                            {    text://Component(Wheel/Rear/FirstSprocket) }            {RearHub: first Sprocket}]                                                       
            
            return
    }

    proc rattleCAD::cv_custom::create_DropOut {} {   
            upvar  1 cv_Name    ext_cvName              
            upvar  1 Length     ext_Length
            upvar  1 Center     ext_Center
			
			set offset_DropOut  [rattleCAD::control::getValue  Lugs/RearDropOut/ChainStay/Offset]
            
                set x1                  [ expr [lindex $ext_Center(RearHub) 0] -10 ]
                set x2                  [ expr [lindex $ext_Center(RearHub) 0] +10 ]
                set y1                  $ext_Length(04)
                set y2                  [ expr $ext_Length(04) + 6 ]
                
                set pointList           [ list $x1 $y1 $x2 $y2 ]
            $ext_cvName create rectangle   $pointList            -outline $rattleCAD::view::colorSet(frameTube_OL) \
                                                                 -fill $rattleCAD::view::colorSet(chainStay_1)  \
                                                                 -width 1.0  -tags __Lug__
                set pointList           [ list $x1 [expr -1*$y1] $x2 [expr -1*$y2] ]
            $ext_cvName create rectangle   $pointList            -outline $rattleCAD::view::colorSet(frameTube_OL) \
                                                                 -fill $rattleCAD::view::colorSet(chainStay_1) \
                                                                 -width 1.0  -tags __Lug__
            
                set x1                  [ expr [lindex $ext_Center(RearHub) 0] -14 ]
                set x2                  [ expr [lindex $ext_Center(RearHub) 0] + $offset_DropOut + 10 ]
                set y1                  [ expr $ext_Length(04) + 1 ]
                set y2                  [ expr $ext_Length(04) + 5 ]
                set pointList           [ list $x1 $y1 $x2 $y2 ]
            $ext_cvName create rectangle   $pointList            -outline $rattleCAD::view::colorSet(frameTube_OL) \
                                                                 -fill $rattleCAD::view::colorSet(chainStay) \
                                                                 -width 1.0  -tags __Lug__
                set pointList           [ list $x1 [expr -1*$y1] $x2 [expr -1*$y2] ]
            $ext_cvName create rectangle   $pointList            -outline $rattleCAD::view::colorSet(frameTube_OL) \
                                                                 -fill $rattleCAD::view::colorSet(chainStay) \
                                                                 -width 1.0  -tags __Lug__
    }

    proc rattleCAD::cv_custom::create_BrakeDisc {} {
          upvar  1 cv_Name    ext_cvName              
          upvar  1 Length     ext_Length
          upvar  1 Center     ext_Center
          upvar  1 ChainStay  ext_ChainStay
            # puts "  -> create_BrakeDisc: \$ext_Length"
            # parray  ext_Length
            # puts "  -> create_BrakeDisc: \$ext_Center"
            # parray ext_Center
            # puts "  -> create_BrakeDisc: \$ext_ChainStay"
            # parray ext_ChainStay
          
          set pos_00 [list [expr -1 * $ext_Length(ChainStay)] $ext_Length(04)]
            # puts "  \$pos_00     $pos_00"
          
          set disc_Offset         [rattleCAD::control::getValue Rendering/RearMockup/DiscOffset]
          set disc_Width          [rattleCAD::control::getValue Rendering/RearMockup/DiscWidth]
          set disc_DiameterDisc   [rattleCAD::control::getValue Rendering/RearMockup/DiscDiameter]
          set clearanceRadius     [rattleCAD::control::getValue Rendering/RearMockup/DiscClearance]
          
          set pos_02  [vectormath::rotateLine $pos_00 $disc_Offset -90]
          set pos_01  [vectormath::rotateLine $pos_02 $disc_Width   90]
            # $ext_cvName create circle      $pos_00       -radius 2  -outline red         -width 1.0        -tags __CenterLine__
            # $ext_cvName create circle      $pos_01       -radius 2  -outline red         -width 1.0        -tags __CenterLine__
          
          set p_00    [vectormath::addVector $pos_01 {-37 0}]
          set p_01    [vectormath::addVector $pos_01 [list [expr 0.5 * $disc_DiameterDisc] 0]]
          set vct_00  [vectormath::parallel   $p_00 $p_01 $disc_Width]
          foreach {p_03 p_02}  $vct_00 break
          set pointList [list $p_00 $p_02]
          set p_04    [vectormath::addVector  $p_03 {7 0}]
          set p_05    [vectormath::addVector  $p_04 {0 0.7}]
          
            # puts "    \$pointList: $pointList"
          set pointList [appUtil::flatten_nestedList $p_00 $p_01 $p_02 $p_04 $p_05]
            
            # -- draw brake disc
          set object [$ext_cvName create polygon   $pointList -outline black     -fill gray  -width 1.0  -tags __Component__]
          #set object [$ext_cvName create rectangle   $pointList -outline black     -fill gray  -width 1.0  -tags __Component__]
            # -- draw clearance arc
          $ext_cvName create arc         $p_01      -radius $clearanceRadius -start 310  -extent 190 -style arc -outline red  -tags __CenterLine__

          set ext_Center(p_brakeDisc_01)  $p_01
          set ext_Center(p_brakeDisc_02)  $p_02
          set ext_Center(p_brakeDisc_03)  $p_04

          return $object
    }


    proc rattleCAD::cv_custom::create_CrankArm {} {
            upvar  1 cv_Name            ext_cvName
            upvar  1 stageScale         ext_stageScale
            
            upvar  1 Length             ext_Length
            upvar  1 Center             ext_Center
            upvar  1 ChainStay          ext_ChainStay
            upvar  1 ClearChainWheel    ext_ClearChainWheel
            
            
                # -- help points
            set pt_00       [ list [expr -1.0 * $ext_Length(CrankSet)] [expr -1.0 * $ext_Length(PedalMount) + $ext_Length(CrankSet_ArmWidth) + 10] ]
            set pt_02       [ list [expr -1.0 * $ext_Length(CrankSet)] [expr -1.0 * $ext_Length(PedalMount)] ]
            set pt_01       [ list [expr -1.0 * $ext_Length(CrankSet)] [expr -1.0 * $ext_Length(PedalMount) + $ext_Length(CrankSet_ArmWidth)] ]
            set pt_03       [ list [expr -1.0 * $ext_Length(CrankSet)] [expr -1.0 * ($ext_Length(PedalMount) + 10)] ]
            
                # -- polygon points: pedal mount
            set pt_10       [ vectormath::addVector $pt_01 { 30.0 0} ]
            set pt_11       [ vectormath::addVector $pt_01 [list [expr -1.0 * $ext_Length(PedalEye)] 0] ]
            set pt_12       [ vectormath::addVector $pt_02 [list [expr -1.0 * $ext_Length(PedalEye)] 0] ]
            set pt_13       [ vectormath::addVector $pt_02 { 40.0 0} ]
            
                # -- polygon points: BottomBracket mount
            set pt_25       [ list -35 [expr -1.0 * ($ext_Length(02) + 15) ] ]
            set pt_24       [ list -19 [expr -1.0 * ($ext_Length(02) + 10) ] ]
            set pt_23       [ list -20 [expr -1.0 * ($ext_Length(02) +  5) ] ]
            set pt_22       [ list  20 [expr -1.0 * ($ext_Length(02) +  5) ] ]
            set pt_21       [ list  18 [expr -1.0 * ($ext_Length(02) + 30) ] ]
            set pt_20       [ list -30 [expr -1.0 * ($ext_Length(02) + 30) ] ]
            
                        # $ext_cvName create circle      $pt_00            -radius 2  -outline gray50     -width 1.0            -tags __CenterLine__   
            
                # -- create canvas Object
            set polygon         [ appUtil::flatten_nestedList   $pt_10  $pt_11  $pt_12  $pt_13 \
                                                                $pt_20  $pt_21  $pt_22  $pt_23  $pt_24  $pt_25] 
            
            set componentCrank  [ $ext_cvName create polygon         $polygon    -fill gray -outline black  -tags  {__Component__ __CrankArm__}]
            
            
           rattleCAD::view::gui::object_CursorBinding    $ext_cvName $componentCrank
           $ext_cvName bind   $componentCrank    <Double-ButtonPress-1> \
                               [list rattleCAD::view::createEdit  %x %y  $ext_cvName  \
                                            {   Component(CrankSet/ChainLine) \
                                                Component(CrankSet/Q-Factor) \
                                                text://Component(CrankSet/ChainRings) }            {Crankset:  Parameter}]
                                                
                # -- centerline of pedal axis
            $ext_cvName create centerline     [ appUtil::flatten_nestedList $pt_00 $pt_03 ] \
                                                                             -fill gray50       -width 0.25     -tags {__CenterLine__ __CrankArm__}


                # -- global points
            set ext_Center(Dim_Q_Factor)    [ list [expr -1.0 * $ext_Length(CrankSet)] 0 ]
            set ext_Center(Q_Factor)        $pt_02 
            set ext_Center(CrankArm)        $pt_11 
            set ext_Center(PedalEye)        $pt_12 
            set ext_Center(ChainLine)       [ list 0 [expr -1.0 * $ext_Length(ChainLine) ] ]


                # -- create chainwheels
            set chainLine           [rattleCAD::control::getValue Component/CrankSet/ChainLine]
            set chainWheelDistance  5
            set chainWheelWidth     2
            set list_ChainRings     [lsort [split [rattleCAD::control::getValue Component/CrankSet/ChainRings] -]]
                # puts "  <D> create_CrankArm: [rattleCAD::control::getValue Component/CrankSet/ChainRings)"
                # puts "  <D> create_CrankArm: [llength $list_ChainRings]"
            
            switch [llength $list_ChainRings] {
                3   {   set chainWheelPos   [list 0 [expr $chainLine - $chainWheelDistance]] }
                2   {   set chainWheelPos   [list 0 [expr $chainLine - 0.5 * $chainWheelDistance]] }
                1   {   set chainWheelPos   [list 0 $chainLine] }
                default {
                        set chainWheelPos   [list 0 $chainLine]
                        set list_ChainRings {}
                        tk_messageBox -message "max ChainWheel amount: 3\n      given Arguments: $list_ChainRings"
                    }
            }
            
            set cw_Clearance    {}
            set cw_index        0
            foreach teethCount $list_ChainRings {
                    set cw_object       [ get_ChainWheel $teethCount  $chainWheelWidth  $chainWheelPos ]
                    set cw_clearance    [ lindex $cw_object 0 ]
                    set cw_polygon      [ lindex $cw_object 1 ]
                    $ext_cvName create polygon     $cw_polygon     -fill gray -outline black  -tags {__Component__ __CrankArm__} 
                
                        # -- position of next chainwheel
                    set chainWheelPos   [ vectormath::addVector $chainWheelPos {0 1} $chainWheelDistance ]
                        
                        # -- add position to ext_ClearChainWheel
                    incr cw_index
                    set ext_ClearChainWheel($cw_index)    $cw_clearance
            }
           
            return
    }

    proc rattleCAD::cv_custom::create_ClearArea {} {
            upvar  1 cv_Name    ext_cvName
            upvar  1 stageScale ext_stageScale
            
            upvar  1 Length             ext_Length
            upvar  1 Center             ext_Center
            upvar  1 ChainStay          ext_ChainStay
            upvar  1 ClearChainWheel    ext_ClearChainWheel
            upvar  1 ClearCassette      ext_ClearCassette

                # -- define ClearArea Polygon
                #
            set polygon     {}
                
                # -- Tyre clearance
                    set tyreHeight  $ext_Length(06)
                    set clearRadius [ expr  $tyreHeight + [rattleCAD::control::getValue Rendering/RearMockup/TyreClearance] ]
                    set clearWidth  [ expr  0.5 * [rattleCAD::control::getValue Component/Wheel/Rear/TyreWidth]  + [rattleCAD::control::getValue Rendering/RearMockup/TyreClearance] ]
                    set pt_99       [ vectormath::addVector  $ext_Center(TyreWidth)  {0 -1} $clearRadius ]
                    set pt_98       [ vectormath::addVector  $pt_99  {-70 0} ]
            lappend polygon     $pt_98  $pt_99
                    set angle 0
                    while {$angle <= 90} {
                        set pt_tmp  [ vectormath::rotatePoint  $ext_Center(TyreWidth) $pt_99 $angle]
                        puts "             -> $ext_Center(Tyre)  /  $ext_Center(TyreWidth)"
                        # TyreWidth
                        lappend polygon     $pt_tmp
                        incr angle 10
                    }
                    # --- handling tyreWidth
                    set ratio       [expr $clearWidth / $clearRadius]
                    set newPolygon {}
                    foreach xy $polygon {
                        foreach {x y} $xy break
                        set y [expr $ratio*$y]
                        lappend newPolygon [list $x $y]
                    }
            set polygon $newPolygon
      
               
               
            set ext_Center(TyreClearance)  [ vectormath::addVector  $ext_Center(Tyre)  {0 -1} $clearWidth ]
            
                # -- BB clearance
                    set pt_01       [ list   [lindex $ext_ChainStay(00) 0] 0 ]
            lappend polygon     $pt_01
                    set pt_02       [ vectormath::mirrorPoint {0 0} {1 0} $ext_ChainStay(00) ] 
                        #[ list   [lindex $ext_ChainStay(00) 0] [expr -1 * [lindex $ext_ChainStay(00) 1]] ]     
            lappend polygon     $pt_02
                    
                # -- ChainWheel clearance
                    set name        [ lindex [array names ext_ClearChainWheel] 0 ]        
                    set pt_cw1      $ext_ClearChainWheel($name)
                    set pt_03       [ vectormath::cathetusPoint  $pt_02  $pt_cw1  [rattleCAD::control::getValue Rendering/RearMockup/ChainWheelClearance] opposite ]
            lappend polygon     $pt_03
                    
                # -- # -- second & third ChainWheel
                    set pt_last $pt_cw1
                    foreach name [lrange [array names ext_ClearChainWheel] 1 end] {
                            set pt_tmp  $ext_ClearChainWheel($name)
                            set vct_tmp [ vectormath::parallel $pt_last $pt_tmp [rattleCAD::control::getValue Rendering/RearMockup/ChainWheelClearance] ]
                            lappend polygon     [lindex $vct_tmp 0] [lindex $vct_tmp 1]
                            set pt_last $pt_tmp
                    }
            
                # -- CrankArm clearance
                    set delta       [ expr   [rattleCAD::control::getValue Rendering/RearMockup/CrankClearance] - [rattleCAD::control::getValue Rendering/RearMockup/ChainWheelClearance] ]
                    set pt_ca       [ vectormath::cathetusPoint  $pt_last  $ext_Center(CrankArm)  $delta opposite ]
                    set vct_tmp     [ vectormath::parallel $pt_last $pt_ca  [rattleCAD::control::getValue Rendering/RearMockup/ChainWheelClearance] ]
            lappend polygon     [ lindex $vct_tmp 0 ] [ lindex $vct_tmp 1 ]
                    set clearRadius [rattleCAD::control::getValue Rendering/RearMockup/CrankClearance]
                    set pt_st       [ vectormath::addVector  $ext_Center(CrankArm)  {0 1}  $clearRadius ]
                    set dirAngle    [ expr [vectormath::dirAngle   [lindex $vct_tmp 0] [lindex $vct_tmp 1]] -180 ]
                        # puts "     -> dirAngle $dirAngle"
                    set angle       0
                    while {$angle <= 90} {
                            if {$angle >= $dirAngle} {
                                set pt_tmp  [ vectormath::rotatePoint  $ext_Center(CrankArm) $pt_st $angle]
                                lappend polygon     $pt_tmp
                            }
                            incr angle 10
                    }
                    set pt_04       [ vectormath::addVector [lindex $polygon end] {0 -15} ]
            lappend polygon     $pt_04                  
            
                # -- Casette clearance
                    set pt_sp       [ vectormath::addVector  $ext_ClearCassette(1)  {  1   0}  [rattleCAD::control::getValue Rendering/RearMockup/CassetteClearance] ]
                    
                    set pt_11       [ vectormath::addVector  $pt_sp                 {  0   2} ]
                    set pt_12       [ vectormath::addVector  $pt_11                 { 45  25} ]
                    
                    set pt_08       [ vectormath::addVector  $pt_sp                 {  0  -2} ]
                    set pt_07       [ list [lindex $ext_Center(ChainStay_DO) 0]  [ lindex $pt_08 1] ]
                    # set pt_07     [ vectormath::addVector  $pt_08                 {-20   0} ]
                    set pt_06       [ vectormath::addVector  $pt_07                 {  0 -20} ]
                    set pt_05       [ vectormath::addVector  $pt_06                 { 40   0} ]
            lappend polygon     $pt_05  $pt_06  $pt_07  $pt_08  $pt_11  $pt_12                     
                    set ext_Center(SprocketClearance)        $pt_sp 
            
            
                # -- create chainstay Area
                #
            set             polygon     [ appUtil::flatten_nestedList    $polygon ]
            
            set chainstayArea   [ $ext_cvName create polygon     $polygon     -fill $rattleCAD::view::colorSet(chainStayArea) -outline black  -tags __CenterLine__ ]

            rattleCAD::view::gui::object_CursorBinding    $ext_cvName $chainstayArea
            $ext_cvName bind   $chainstayArea    <Double-ButtonPress-1> \
                               [list rattleCAD::view::createEdit  %x %y  $ext_cvName  \
                                            {   list://Rendering(ChainStay@SELECT_ChainStay) \
                                                Rendering(RearMockup/TyreClearance) \
                                                Rendering(RearMockup/ChainWheelClearance) \
                                                Rendering(RearMockup/CrankClearance) \
                                                Rendering(RearMockup/CassetteClearance) }            {ChainStay:  Area}]                    
             return
    }                   
 
    proc rattleCAD::cv_custom::create_ControlCurves {} {
            upvar  1 cv_Name    ext_cvName
            upvar  1 stageScale ext_stageScale
            
            upvar  1 Length             ext_Length
            upvar  1 Center             ext_Center
            upvar  1 ChainStay          ext_ChainStay
            upvar  1 ClearChainWheel    ext_ClearChainWheel
            upvar  1 ClearCassette      ext_ClearCassette

                
                # -- Tyre Clearance
            # set ratio             [expr [rattleCAD::control::getValue Component/Wheel/Rear/TyreWidth)/[rattleCAD::control::getValue Component/Wheel/Rear/TyreHeight)]
            set radius_y      [expr  0.5 * [rattleCAD::control::getValue Component/Wheel/Rear/TyreWidth]  + [rattleCAD::control::getValue Rendering/RearMockup/TyreClearance] ]
            set radius_x      [expr  $ext_Length(06)                                  + [rattleCAD::control::getValue Rendering/RearMockup/TyreClearance] ]
            set tyre_00       [vectormath::addVector $ext_Center(TyreWidth) [list $radius_x [expr -1.0*$radius_y] ]]
            set tyre_01       [vectormath::addVector $ext_Center(TyreWidth) [list [expr -1.0*$radius_x] $radius_y ]]                     
            set clearMatrix   [appUtil::flatten_nestedList  $tyre_00 $tyre_01 ]
            
            $ext_cvName create ovalarc  $clearMatrix       -start 250  -extent 220 -style arc -outline red  -tags __CenterLine__
            
                # -- ChainWheel Clearance
            set radius  [rattleCAD::control::getValue Rendering/RearMockup/ChainWheelClearance]
            foreach name [array names ext_ClearChainWheel] {
                    # puts "   --> $name  $ext_ClearChainWheel($name)"
                set position    $ext_ClearChainWheel($name)
                $ext_cvName create arc      $position  -radius $radius -start 30  -extent 180 -style arc -outline red  -tags __CenterLine__
            }
            
                # -- CrankArm Clearance
            set radius  [rattleCAD::control::getValue Rendering/RearMockup/CrankClearance]
            set position    $ext_Center(CrankArm)
            $ext_cvName create arc      $position  -radius $radius  -start 30  -extent 180  -style arc  -outline red  -tags __CenterLine__
            
                # -- Casette clearance
            set radius  [rattleCAD::control::getValue Rendering/RearMockup/CassetteClearance]
            set position    $ext_ClearCassette(1)
            $ext_cvName create arc  $position  -radius $radius  -start 280  -extent 80  -style arc  -outline red  -tags __CenterLine__
            $ext_cvName create arc  $position  -radius $radius  -start   0  -extent 80  -style arc  -outline red  -tags __CenterLine__
     
            return
    }

    proc rattleCAD::cv_custom::create_tubeProfile_Edit {offset} {
          upvar  1 cv_Name    ext_cvName 
          upvar  1 stageScale ext_stageScale
          
          upvar  1 Length     ext_Length
          upvar  1 Center     ext_Center
          upvar  1 ChainStay  ext_ChainStay
          
          upvar  1 Colour     ext_Colour
          
            # puts "  -> create_tubeProfile_Edit: \$ext_Length"
            # parray  ext_Length
            # puts "  -> create_tubeProfile_Edit: \$ext_Center"
            # parray ext_Center
            # puts "  -> create_tubeProfile_Edit: \$ext_ChainStay"
            # parray ext_ChainStay
            
        set profile_y00   [rattleCAD::control::getValue FrameTubes/ChainStay/Profile/width_00]
        set profile_x01   [rattleCAD::control::getValue FrameTubes/ChainStay/Profile/length_01]
        set profile_y01   [rattleCAD::control::getValue FrameTubes/ChainStay/Profile/width_01]
        set profile_x02   [rattleCAD::control::getValue FrameTubes/ChainStay/Profile/length_02]
        set profile_y02   [rattleCAD::control::getValue FrameTubes/ChainStay/Profile/width_02]
        set profile_x03   [rattleCAD::control::getValue FrameTubes/ChainStay/Profile/length_03]
        set profile_y03   [rattleCAD::control::getValue FrameTubes/ChainStay/Profile/width_03]   
            
        set length  [expr $profile_x01 + $profile_x02 + $profile_x03]
        set profile_x04   [expr $ext_Length(ChainStay) - $length + 15]
        
        # set p00  [list [expr -1 * $ext_Length(ChainStay)] 0]
        set p0  [vectormath::addVector $ext_Center(ChainStay_DO)  $offset]
        set p1  [vectormath::addVector $p0  [list $profile_x01 0]]
        set p2  [vectormath::addVector $p1  [list $profile_x02 0]]
        set p3  [vectormath::addVector $p2  [list $profile_x03 0]]
        set p4  [vectormath::addVector $p3  [list $profile_x04 0]]
        
          # puts " .. ChainStay - TubeProfile: [appUtil::flatten_nestedList $p0 $p1 $p2 $p3 $p4]"
        
        set p00 [vectormath::addVector $p0  [list 0 [expr  0.5 * $profile_y00]]]
        set p01 [vectormath::addVector $p1  [list 0 [expr  0.5 * $profile_y01]]]
        set p02 [vectormath::addVector $p2  [list 0 [expr  0.5 * $profile_y02]]]
        set p03 [vectormath::addVector $p3  [list 0 [expr  0.5 * $profile_y03]]]
        set p04 [vectormath::addVector $p4  [list 0 [expr  0.5 * $profile_y03]]]
        
        set p14 [vectormath::addVector $p4  [list 0 [expr -0.5 * $profile_y03]]]
        set p13 [vectormath::addVector $p3  [list 0 [expr -0.5 * $profile_y03]]]
        set p12 [vectormath::addVector $p2  [list 0 [expr -0.5 * $profile_y02]]]
        set p11 [vectormath::addVector $p1  [list 0 [expr -0.5 * $profile_y01]]]
        set p10 [vectormath::addVector $p0  [list 0 [expr -0.5 * $profile_y00]]]
        
        set pointList [appUtil::flatten_nestedList $p00 $p01 $p02 $p03 $p04   $p14 $p13 $p12 $p11 $p10]   
        
        $ext_cvName  create   polygon $pointList                                  -fill $rattleCAD::view::colorSet(chainStay) \
                                                                                  -outline $rattleCAD::view::colorSet(frameTube_OL) \
                                                                                  -tags __CenterLine__
                                                                                  
        $ext_cvName  create   centerline    [appUtil::flatten_nestedList $p0 $p4] -fill $rattleCAD::view::colorSet(chainStay_CL) \
                                                                                  -tags __CenterLine__   
        
        set textPosition [vectormath::addVector $p0  [list -70 -2.5]]
        set item  [$ext_cvName create draftText $textPosition -text "ChainStay Profile" -size [expr 5*$ext_stageScale]]
        $ext_cvName    addtag __CenterLine__ withtag  $item
          
          
          # $ext_cvName create circle     $p0       -radius 2  -outline red         -width 1.0        -tags __CenterLine__
          # $ext_cvName create circle     $p1       -radius 2  -outline red         -width 1.0        -tags __CenterLine__
          # $ext_cvName create circle     $p2       -radius 2  -outline red         -width 1.0        -tags __CenterLine__
          # $ext_cvName create circle     $p3       -radius 2  -outline red         -width 1.0        -tags __CenterLine__
        
        $ext_cvName create circle     $p00       -radius 1  -outline red         -width 1.0        -tags __CenterLine__
        $ext_cvName create circle     $p01       -radius 1  -outline red         -width 1.0        -tags __CenterLine__
        $ext_cvName create circle     $p02       -radius 1  -outline red         -width 1.0        -tags __CenterLine__
        $ext_cvName create circle     $p03       -radius 1  -outline red         -width 1.0        -tags __CenterLine__
        $ext_cvName create circle     $p10       -radius 1  -outline red         -width 1.0        -tags __CenterLine__
        $ext_cvName create circle     $p11       -radius 1  -outline red         -width 1.0        -tags __CenterLine__
        $ext_cvName create circle     $p12       -radius 1  -outline red         -width 1.0        -tags __CenterLine__
        $ext_cvName create circle     $p13       -radius 1  -outline red         -width 1.0        -tags __CenterLine__
        
                                                                            
        set _dim_x1          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p0 $p1 ] \
                                                                horizontal    [expr -25 * $ext_stageScale]   0 \
                                                                $ext_Colour(result) ]
        set _dim_x2          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p1 $p2 ] \
                                                                horizontal    [expr -25 * $ext_stageScale]   0 \
                                                                $ext_Colour(result) ]
        set _dim_x3          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p2 $p3 ] \
                                                                horizontal    [expr -25 * $ext_stageScale]   0 \
                                                                $ext_Colour(result) ]

        set _dim_w0          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p00 $p10 ] \
                                                                vertical      [expr  15 * $ext_stageScale]    0 \
                                                                $ext_Colour(result) ]
        set _dim_w1          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p01 $p11 ] \
                                                                vertical      [expr  15 * $ext_stageScale]    0 \
                                                                $ext_Colour(result) ]
        set _dim_w2          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p02 $p12 ] \
                                                                vertical      [expr  15 * $ext_stageScale]    0 \
                                                                $ext_Colour(result) ]
        set _dim_w3          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p03 $p13 ] \
                                                                vertical      [expr -15 * $ext_stageScale]    0 \
                                                                $ext_Colour(result) ]

        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $_dim_x1
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $_dim_x2
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $_dim_x3
        
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $_dim_w0
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $_dim_w1
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $_dim_w2
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $_dim_w3
        
        $ext_cvName bind  $_dim_x1    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $ext_cvName  FrameTubes(ChainStay/Profile/length_01) ]
        $ext_cvName bind  $_dim_x2    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $ext_cvName  FrameTubes(ChainStay/Profile/length_02) ]
        $ext_cvName bind  $_dim_x3    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $ext_cvName  FrameTubes(ChainStay/Profile/length_03) ]
        
        $ext_cvName bind  $_dim_w0    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $ext_cvName  FrameTubes(ChainStay/Profile/width_00) ]
        $ext_cvName bind  $_dim_w1    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $ext_cvName  FrameTubes(ChainStay/Profile/width_01) ]
        $ext_cvName bind  $_dim_w2    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $ext_cvName  FrameTubes(ChainStay/Profile/width_02) ]
        $ext_cvName bind  $_dim_w3    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $ext_cvName  FrameTubes(ChainStay/Profile/width_03) ]
    }

    proc rattleCAD::cv_custom::create_centerLine_Edit {ctrLines offset} {
          variable ctrl_Points
          
          upvar  1 cv_Name    ext_cvName 
          upvar  1 stageScale ext_stageScale
          
          upvar  1 Length     ext_Length
          upvar  1 Center     ext_Center
          upvar  1 ChainStay  ext_ChainStay
          
          upvar  1 Colour     ext_Colour
          
            #puts "  -> create_centerLine_Edit: \$ext_Length"
            #parray  ext_Length
            #puts "  -> create_centerLine_Edit: \$ext_Center"
            #parray ext_Center
            #puts "  -> create_centerLine_Edit: \$ext_ChainStay"
            #parray ext_ChainStay
            

        set offset  [vectormath::addVector $ext_Center(ChainStay_DO)  $offset]
        
        set textPosition [vectormath::addVector $offset  [list -70 -2.5]]
        set item  [$ext_cvName create draftText $textPosition -text "ChainStay CenterLine" -size [expr 5*$ext_stageScale]]
        $ext_cvName    addtag __CenterLine__ withtag  $item


            # -- get control Line - Points
        set i 0
        foreach {x y} $ctrLines {
            set p$i [vectormath::addVector [list $x $y] $offset]
            incr i
            # puts "    -> $i"
        }
          # puts " .. ChainStay - Control Curve: [llength $ctrLines]"
          # puts " .. ChainStay - Control Curve: \n        -> p0: $p0 \n        -> p2: $p2 \n        -> p4: $p4 \n        -> p6: $p6 \n        -> p8: $p8"
          # puts " .. ChainStay - Control Curve: \n        -> p1: $p1 \n        -> p3: $p3 \n        -> p5: $p5 \n        -> p7: $p7 \n        -> p9: $p9"
                                     
        set ctrl_p0 $p0
        set ctrl_p1 [vectormath::intersectPoint $p0 $p1  $p2 $p3 center]
        set ctrl_p2 [vectormath::intersectPoint $p2 $p3  $p4 $p5 center]
        set ctrl_p3 [vectormath::intersectPoint $p4 $p5  $p6 $p7 center]
        set ctrl_p4 [vectormath::intersectPoint $p6 $p7  $p8 $p9 center]
        set ctrl_p5 $p9
        
        set ctrl_Points(0)  $p0  
        set ctrl_Points(1)  [vectormath::intersectPoint $p0 $p1  $p2 $p3 center]  
        set ctrl_Points(2)  [vectormath::intersectPoint $p2 $p3  $p4 $p5 center]  
        set ctrl_Points(3)  [vectormath::intersectPoint $p4 $p5  $p6 $p7 center]  
        set ctrl_Points(4)  [vectormath::intersectPoint $p6 $p7  $p8 $p9 center] 
        set ctrl_Points(5)  $p9 
        set ctrl_Points(6)  [vectormath::addVector $p9 {20 0}]
        
            # [rattleCAD::control::getValue Lugs/BottomBracket/ChainStay/Offset_TopView
            # [ expr 0.5 * [rattleCAD::control::getValue Component/Wheel/Rear/HubWidth) ]
            set offset_dropOut [expr [rattleCAD::control::getValue Lugs/BottomBracket/ChainStay/Offset_TopView] + 0.5 * [rattleCAD::control::getValue Component/Wheel/Rear/HubWidth] ]
        set base_p0 [list [lindex $ctrl_p0 0] [expr [lindex $ctrl_p0 1] - $offset_dropOut]]
        set base_p5 [list [lindex $ctrl_p5 0] [lindex $base_p0 1]]
        # -- draw base line
        set base_Line   [$ext_cvName create centerline [appUtil::flatten_nestedList $base_p0 $base_p5]   -tags __CenterLine__   -fill gray50]
        
        
        
            # -- draw edit areas
        set ctrlArea_01 [$ext_cvName create circle       $ctrl_Points(1)    -radius  8.0  -outline orange    -fill gray   -width 1.0   -tags {__CenterLine__}]
        set ctrlArea_02 [$ext_cvName create circle       $ctrl_Points(2)    -radius  8.0  -outline orange    -fill gray   -width 1.0   -tags {__CenterLine__}]
        set ctrlArea_03 [$ext_cvName create circle       $ctrl_Points(3)    -radius  8.0  -outline orange    -fill gray   -width 1.0   -tags {__CenterLine__}]
        set ctrlArea_04 [$ext_cvName create circle       $ctrl_Points(4)    -radius  8.0  -outline orange    -fill gray   -width 1.0   -tags {__CenterLine__}]
            # set ctrlArea_05 [$ext_cvName create circle       $ctrl_Points(5)    -radius  8.0  -outline orange    -fill gray   -width 1.0   -tags {__CenterLine__}]
        
            # -- draw drag areas
        set ctrlArea_11 [rattleCAD::cv_custom::create_controlField  $ext_cvName  $ctrl_Points(0) $ctrl_Points(1) $ctrl_Points(2)  __dragObject__]                                    
        set ctrlArea_12 [rattleCAD::cv_custom::create_controlField  $ext_cvName  $ctrl_Points(1) $ctrl_Points(2) $ctrl_Points(3)  __dragObject__]                                    
        set ctrlArea_13 [rattleCAD::cv_custom::create_controlField  $ext_cvName  $ctrl_Points(2) $ctrl_Points(3) $ctrl_Points(4)  __dragObject__]                                    
        set ctrlArea_14 [rattleCAD::cv_custom::create_controlField  $ext_cvName  $ctrl_Points(3) $ctrl_Points(4) $ctrl_Points(5)  __dragObject__]                                    
        set ctrlArea_15 [$ext_cvName create circle       $ctrl_Points(5)    -radius  8.0  -outline orange    -fill gray   -width 1.0   -tags {__CenterLine__ __dragObject__}]
            # set ctrlArea_15 [rattleCAD::cv_custom::create_controlField  $ext_cvName  $ctrl_Points(4) $ctrl_Points(5) $ctrl_Points(6)  __dragObject__]                                    
                                                                                                                                                
            # -- draw control Lines
        set _obj_line_01  [$ext_cvName  create   line [appUtil::flatten_nestedList $p0 $p1]   -tags __CenterLine__   -fill orange]
        set _obj_line_02  [$ext_cvName  create   line [appUtil::flatten_nestedList $p2 $p3]   -tags __CenterLine__   -fill orange]
        set _obj_line_03  [$ext_cvName  create   line [appUtil::flatten_nestedList $p4 $p5]   -tags __CenterLine__   -fill orange]
        set _obj_line_04  [$ext_cvName  create   line [appUtil::flatten_nestedList $p6 $p7]   -tags __CenterLine__   -fill orange]
        set _obj_line_05  [$ext_cvName  create   line [appUtil::flatten_nestedList $p8 $p9]   -tags __CenterLine__   -fill orange]

            # -- draw a circle on intersecting vectors
        $ext_cvName create circle     $ctrl_Points(1)    -radius 0.5   -outline orange    -fill lightgray   -width 1.0   -tags {__CenterLine__}
        $ext_cvName create circle     $ctrl_Points(2)    -radius 0.5   -outline orange    -fill lightgray   -width 1.0   -tags {__CenterLine__}
        $ext_cvName create circle     $ctrl_Points(3)    -radius 0.5   -outline orange    -fill lightgray   -width 1.0   -tags {__CenterLine__}
        $ext_cvName create circle     $ctrl_Points(4)    -radius 0.5   -outline orange    -fill lightgray   -width 1.0   -tags {__CenterLine__}
        $ext_cvName create circle     $ctrl_Points(5)    -radius 0.5   -outline orange    -fill lightgray   -width 1.0   -tags {__CenterLine__}
        
                                                                                                        
        
        set _dim_length_01          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p0 $p1 ] \
                                            aligned    [expr -15 * $ext_stageScale]   0 \
                                            $ext_Colour(result) ]
        set _dim_length_02          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p2 $p3 ] \
                                            aligned    [expr -15 * $ext_stageScale]   0 \
                                            $ext_Colour(result) ]
        set _dim_length_03          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p4 $p5 ] \
                                            aligned    [expr -15 * $ext_stageScale]   0 \
                                            $ext_Colour(result) ]
        set _dim_length_04          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p6 $p7 ] \
                                            aligned    [expr -15 * $ext_stageScale]   0 \
                                            $ext_Colour(result) ]
        set _dim_length_05          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p8 $p9 ] \
                                            aligned    [expr -15 * $ext_stageScale]   0 \
                                            $ext_Colour(result) ]
        
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $_dim_length_01
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $_dim_length_02
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $_dim_length_03
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $_dim_length_04
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $_dim_length_05
        
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $_obj_line_01
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $_obj_line_02
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $_obj_line_03
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $_obj_line_04
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $_obj_line_05
        
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $ctrlArea_01
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $ctrlArea_02
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $ctrlArea_03
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $ctrlArea_04
        
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $ctrlArea_11
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $ctrlArea_12
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $ctrlArea_13
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $ctrlArea_14
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $ctrlArea_15
        
        
                                     # -- current_cv     object_ID      update_Command                        reference_Name
        canvasCAD::register_dragObjects   $ext_cvName    $ctrlArea_11   [namespace current]::move_ctrlPoints  1
        canvasCAD::register_dragObjects   $ext_cvName    $ctrlArea_12   [namespace current]::move_ctrlPoints  2
        canvasCAD::register_dragObjects   $ext_cvName    $ctrlArea_13   [namespace current]::move_ctrlPoints  3
        canvasCAD::register_dragObjects   $ext_cvName    $ctrlArea_14   [namespace current]::move_ctrlPoints  4
        canvasCAD::register_dragObjects   $ext_cvName    $ctrlArea_15   [namespace current]::move_ctrlPoints  5
        
        
        $ext_cvName bind  $_dim_length_01    <Double-ButtonPress-1>  \
                        [list rattleCAD::view::createEdit  %x %y  $ext_cvName  \
                                        FrameTubes(ChainStay/CenterLine/length_01)]
        $ext_cvName bind  $_dim_length_02    <Double-ButtonPress-1>  \
                        [list rattleCAD::view::createEdit  %x %y  $ext_cvName  \
                                        FrameTubes(ChainStay/CenterLine/length_02)]
        $ext_cvName bind  $_dim_length_03    <Double-ButtonPress-1>  \
                        [list rattleCAD::view::createEdit  %x %y  $ext_cvName  \
                                        FrameTubes(ChainStay/CenterLine/length_03)]
        $ext_cvName bind  $_dim_length_04    <Double-ButtonPress-1>  \
                        [list rattleCAD::view::createEdit  %x %y  $ext_cvName  \
                                        FrameTubes(ChainStay/CenterLine/length_04)]
        $ext_cvName bind  $_dim_length_05    <Double-ButtonPress-1>  \
                        [list rattleCAD::view::createEdit  %x %y  $ext_cvName  \
                                        FrameTubes(ChainStay/CenterLine/length_05)]

        $ext_cvName bind  $_obj_line_01    <Double-ButtonPress-1>  \
                        [list rattleCAD::view::createEdit  %x %y  $ext_cvName  \
                                        FrameTubes(ChainStay/CenterLine/length_01)]
        $ext_cvName bind  $_obj_line_02    <Double-ButtonPress-1>  \
                        [list rattleCAD::view::createEdit  %x %y  $ext_cvName  \
                                        FrameTubes(ChainStay/CenterLine/length_02)]
        $ext_cvName bind  $_obj_line_03    <Double-ButtonPress-1>  \
                        [list rattleCAD::view::createEdit  %x %y  $ext_cvName  \
                                        FrameTubes(ChainStay/CenterLine/length_03)]
        $ext_cvName bind  $_obj_line_04    <Double-ButtonPress-1>  \
                        [list rattleCAD::view::createEdit  %x %y  $ext_cvName  \
                                        FrameTubes(ChainStay/CenterLine/length_04)]
        $ext_cvName bind  $_obj_line_05    <Double-ButtonPress-1>  \
                        [list rattleCAD::view::createEdit  %x %y  $ext_cvName  \
                                        FrameTubes(ChainStay/CenterLine/length_05)]
                                        
        $ext_cvName bind  $ctrlArea_01    <Double-ButtonPress-1>  \
                        [list rattleCAD::view::createEdit  %x %y  $ext_cvName  \
                                    {   FrameTubes(ChainStay/CenterLine/angle_01) \
                                        FrameTubes(ChainStay/CenterLine/radius_01 \
                                        FrameTubes(ChainStay/CenterLine/length_01 \
                                        FrameTubes(ChainStay/CenterLine/length_02))) }   {ChainStay:  Bent 01}]
        $ext_cvName bind  $ctrlArea_02    <Double-ButtonPress-1>  \
                        [list rattleCAD::view::createEdit  %x %y  $ext_cvName  \
                                    {   FrameTubes(ChainStay/CenterLine/angle_02) \
                                        FrameTubes(ChainStay/CenterLine/radius_02 \
                                        FrameTubes(ChainStay/CenterLine/length_02 \
                                        FrameTubes(ChainStay/CenterLine/length_03))) }   {ChainStay:  Bent 02}]
        $ext_cvName bind  $ctrlArea_03    <Double-ButtonPress-1>  \
                        [list rattleCAD::view::createEdit  %x %y  $ext_cvName  \
                                    {   FrameTubes(ChainStay/CenterLine/angle_03) \
                                        FrameTubes(ChainStay/CenterLine/radius_03 \
                                        FrameTubes(ChainStay/CenterLine/length_03 \
                                        FrameTubes(ChainStay/CenterLine/length_04))) }   {ChainStay:  Bent 03}]                                 
        $ext_cvName bind  $ctrlArea_04    <Double-ButtonPress-1>  \
                        [list rattleCAD::view::createEdit  %x %y  $ext_cvName  \
                                    {   FrameTubes(ChainStay/CenterLine/angle_04) \
                                        FrameTubes(ChainStay/CenterLine/radius_04 \
                                        FrameTubes(ChainStay/CenterLine/length_04 \
                                        FrameTubes(ChainStay/CenterLine/length_05))) }   {ChainStay:  Bent 04}]


                               
    }

    proc rattleCAD::cv_custom::get_ChainWheel {z w position} {                    
            set cw_Diameter_TK  [ expr 12.7 / sin ($vectormath::CONST_PI/$z)  ]
            set cw_Diameter     [ expr $cw_Diameter_TK + 4 ]
            set cw_Width        $w
            
                # puts "   \$cw_Diameter_TK  $cw_Diameter_TK"
            
            set pt_01           [ list [ expr -0.5 * $cw_Diameter    ] [expr  0.5 * ($cw_Width - 0.5)] ]
            set pt_02           [ list [ expr -0.5 * $cw_Diameter_TK ] [expr  0.5 * $cw_Width] ]
            set pt_03           [ list [ expr  0.5 * $cw_Diameter_TK ] [expr  0.5 * $cw_Width] ]
            set pt_04           [ list [ expr  0.5 * $cw_Diameter    ] [expr  0.5 * ($cw_Width - 0.5)] ]
            
            set pt_05           [ list [ expr  0.5 * $cw_Diameter    ] [expr -0.5 * ($cw_Width - 0.5)] ]
            set pt_06           [ list [ expr  0.5 * $cw_Diameter_TK ] [expr -0.5 * $cw_Width] ]
            set pt_07           [ list [ expr -0.5 * $cw_Diameter_TK ] [expr -0.5 * $cw_Width] ]
            set pt_08           [ list [ expr -0.5 * $cw_Diameter    ] [expr -0.5 * ($cw_Width - 0.5)] ]
            
            set position        [ list [lindex $position 0] [expr -1 * [lindex $position 1]] ]
            set pt_Clearance_l  [ vectormath::addVector [ list [ expr -0.5 * $cw_Diameter ] 0]  $position  ]
            set pt_Clearance_r  [ vectormath::addVector [ list [ expr  0.5 * $cw_Diameter ] 0]  $position  ]
            
            set polygon         [ appUtil::flatten_nestedList       [ list  $pt_01  $pt_02  $pt_03  $pt_04  \
                                                                            $pt_05  $pt_06  $pt_07  $pt_08 ] ]
            set polygon         [ vectormath::addVectorPointList    $position $polygon ]                                                            
            return [list $pt_Clearance_l $polygon $pt_Clearance_r]
    }


    proc rattleCAD::cv_custom::get_BottomBracket {} {   
            upvar  1 cv_Name    ext_cvName              
            upvar  1 Length     ext_Length
            upvar  1 Center     ext_Center
            
            set length03            [ expr 0.5 * [rattleCAD::control::getValue Lugs/BottomBracket/Diameter/outside] ]
            set length04            [ expr 0.5 * [rattleCAD::control::getValue Lugs/BottomBracket/Width] ]
            
            set pointList_OutSide   [ list [expr -1*$length03] [expr -1*$length04] $length03 $length04 ]
            set pointList_InSide    [ list [expr -1*$ext_Length(01)] [expr -1*$ext_Length(02)] $ext_Length(01) $ext_Length(02) ]
            
            return [list $pointList_OutSide $pointList_InSide]
    }

    proc rattleCAD::cv_custom::create_controlField {cv_Name xy1 xy xy2 {tag {}}} {
            # upvar  1 cv_Name    ext_cvName
            set CONST_PI $vectormath::CONST_PI
            set r    8.0
            set h1  15
            set h2  20
            set b1  35
            set b2  05
            
                # -- get orientation of controlField
            set baseAngle   [vectormath::dirAngle $xy1 $xy] 
            set xy_orient   [vectormath::offsetOrientation $xy1 $xy $xy2]
            if {$xy_orient == 0} {set xy_orient 1}
            set xy_angle    [expr $xy_orient * (0 + [vectormath::angle    $xy1 $xy $xy2])]
                # puts "      \$baseAngle    $baseAngle"
                # puts "      \$xy_orient    $xy_orient"
                 puts "      \$xy_angle     $xy_angle"
            set orientAngle [expr 180 + $baseAngle + 0.5*$xy_angle]
            
                # -- get trapez-shape of controlField
            set x1   $h1
            set x2   [expr  $h1 + $h2]
            set y11  [expr +0.5 * $b1]
            set y12  [expr -0.5 * $b1]
            set y21  [expr +0.5 * $b2]
            set y22  [expr -0.5 * $b2]
            
                # -- get arc of controlField
            set arcCenter   [vectormath::intersectPoint [list $x1 $y11] [list $x2 $y21]  [list $x1 $y12] [list $x2 $y22] ]
            set arcAngle    [vectormath::angle          [list $x2 $y21] $arcCenter  [list $x2 $y22] ]
            
            set p           [list $x1 $y11]
            set arcPoints   $p
            set segmeents   8
            set i 0
            while {$i < $segmeents} {
                set p [vectormath::rotatePoint $arcCenter $p [expr $arcAngle/$segmeents]]
                lappend arcPoints $p
                incr i
                    # puts "    -> $i"
            }
            
                # -- position of controlField
            set coordList   $arcPoints
            set coordList   [appUtil::flatten_nestedList $coordList $x2 $y22  $x2 $y21]

            set coordList   [vectormath::addVectorPointList  $xy $coordList]
            set coordList   [vectormath::rotatePointList     $xy $coordList $orientAngle]
            set ctrlPolygon [$cv_Name create polygon     $coordList   -outline orange    -fill lightgray   -width 1.0   -tags [list __CenterLine__ $tag]]
            set returnObj   $ctrlPolygon
            
                # -- return controlField
            return $returnObj    
    }

    proc rattleCAD::cv_custom::move_ctrlPoints {id xy} {
            variable ctrl_Points
            puts "\n   -------------------------------"
            puts "    rattleCAD::cv_custom::move_ctrlPoints"
            puts "       id:              $id"
            puts "       xy:              $xy"
            puts "   -------------------------------"
            foreach key [lsort [array names ctrl_Points]] {
                puts "          $key           $ctrl_Points($key)"
            }                      
            puts "   -------------------------------"
            
            foreach {x y} $xy break
            set ctrl_Points($id) [vectormath::addVector $ctrl_Points($id) [list $x [expr -1.0*$y]]]
    
            set S01_length   [vectormath::length   $ctrl_Points(0) $ctrl_Points(1)]
            set S02_length   [vectormath::length   $ctrl_Points(1) $ctrl_Points(2)]
            set S03_length   [vectormath::length   $ctrl_Points(2) $ctrl_Points(3)]
            set S04_length   [vectormath::length   $ctrl_Points(3) $ctrl_Points(4)]
            set S05_length   [vectormath::length   $ctrl_Points(4) $ctrl_Points(5)]
            
            set S01_orient [vectormath::offsetOrientation $ctrl_Points(0) $ctrl_Points(1) $ctrl_Points(2)]
            set S02_orient [vectormath::offsetOrientation $ctrl_Points(1) $ctrl_Points(2) $ctrl_Points(3)]
            set S03_orient [vectormath::offsetOrientation $ctrl_Points(2) $ctrl_Points(3) $ctrl_Points(4)]
            set S04_orient [vectormath::offsetOrientation $ctrl_Points(3) $ctrl_Points(4) $ctrl_Points(5)]
            
            set S01_angle  [expr $S01_orient * (-180 + [vectormath::angle    $ctrl_Points(0) $ctrl_Points(1) $ctrl_Points(2)])]
            set S02_angle  [expr $S02_orient * (-180 + [vectormath::angle    $ctrl_Points(1) $ctrl_Points(2) $ctrl_Points(3)])]
            set S03_angle  [expr $S03_orient * (-180 + [vectormath::angle    $ctrl_Points(2) $ctrl_Points(3) $ctrl_Points(4)])]
            set S04_angle  [expr $S04_orient * (-180 + [vectormath::angle    $ctrl_Points(3) $ctrl_Points(4) $ctrl_Points(5)])]
            
            proc update_ChainStayValue_org {xPath value} {
                set lastValue  [rattleCAD::control::getValue $xPath ]
                  # set lastValue  [bikeGeometry::get_Value $xPath  value]
                set diffValue  [expr abs($lastValue - $value)]
                if {$diffValue > 1} { 
                    puts "            ... update:  $xPath  $lastValue -> $value" 
                    rattleCAD::control::setValue [list $xPath  $value]
                    # bikeGeometry::set_Value $xPath  $value
                } else {
                    puts "            ... ignore:  $xPath  $lastValue -> $value"
                }
            }
            
            proc update_ChainStayValue {xpathValueList} {
                set myList {}
                foreach {xPath value} $xpathValueList { 
                    set lastValue  [rattleCAD::control::getValue $xPath ]
                      # set lastValue  [bikeGeometry::get_Value $xPath  value]
                    set diffValue  [expr abs($lastValue - $value)]
                    if {$diffValue > 1} { 
                        puts "            ... update:  $xPath  $lastValue -> $value" 
                        lappend myList $xPath  $value
                        # rattleCAD::control::setValue [list $xPath  $value]
                        # bikeGeometry::set_Value $xPath  $value
                    } else {
                        puts "            ... ignore:  $xPath  $lastValue -> $value"
                    }
                }
                rattleCAD::control::setValue $myList
            }
            
            
            set xpathValueList {}
            lappend xpathValueList FrameTubes/ChainStay/CenterLine/length_01  $S01_length
            lappend xpathValueList FrameTubes/ChainStay/CenterLine/length_02  $S02_length
            lappend xpathValueList FrameTubes/ChainStay/CenterLine/length_03  $S03_length
            lappend xpathValueList FrameTubes/ChainStay/CenterLine/length_04  $S04_length
            lappend xpathValueList FrameTubes/ChainStay/CenterLine/length_05  $S05_length
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
            lappend xpathValueList FrameTubes/ChainStay/CenterLine/angle_01   $S01_angle
            lappend xpathValueList FrameTubes/ChainStay/CenterLine/angle_02   $S02_angle
            lappend xpathValueList FrameTubes/ChainStay/CenterLine/angle_03   $S03_angle
            lappend xpathValueList FrameTubes/ChainStay/CenterLine/angle_04   $S04_angle
            
            update_ChainStayValue $xpathValueList
            
              # update_ChainStayValue FrameTubes/ChainStay/CenterLine/length_01  $S01_length
              # update_ChainStayValue FrameTubes/ChainStay/CenterLine/length_02  $S02_length
              # update_ChainStayValue FrameTubes/ChainStay/CenterLine/length_03  $S03_length
              # update_ChainStayValue FrameTubes/ChainStay/CenterLine/length_04  $S04_length
              # update_ChainStayValue FrameTubes/ChainStay/CenterLine/length_05  $S05_length
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
              # update_ChainStayValue FrameTubes/ChainStay/CenterLine/angle_01   $S01_angle
              # update_ChainStayValue FrameTubes/ChainStay/CenterLine/angle_02   $S02_angle
              # update_ChainStayValue FrameTubes/ChainStay/CenterLine/angle_03   $S03_angle
              # update_ChainStayValue FrameTubes/ChainStay/CenterLine/angle_04   $S04_angle
            
            puts "\n   -------------------------------"
            puts "       -> S01_length   [rattleCAD::control::getValue FrameTubes/ChainStay/CenterLine/length_01]"
            puts "       -> S02_length   [rattleCAD::control::getValue FrameTubes/ChainStay/CenterLine/length_02]"
            puts "       -> S03_length   [rattleCAD::control::getValue FrameTubes/ChainStay/CenterLine/length_03]"
            puts "       -> S04_length   [rattleCAD::control::getValue FrameTubes/ChainStay/CenterLine/length_04]"
            puts "       -> S05_length   [rattleCAD::control::getValue FrameTubes/ChainStay/CenterLine/length_05]"
            puts "       -> S01_angle    [rattleCAD::control::getValue FrameTubes/ChainStay/CenterLine/angle_01]"
            puts "       -> S02_angle    [rattleCAD::control::getValue FrameTubes/ChainStay/CenterLine/angle_02]"
            puts "       -> S03_angle    [rattleCAD::control::getValue FrameTubes/ChainStay/CenterLine/angle_03]"
            puts "       -> S04_angle    [rattleCAD::control::getValue FrameTubes/ChainStay/CenterLine/angle_04]"
            
              #set cv_Name     [rattleCAD::view::gui::current_canvasCAD]
              #rattleCAD::cv_custom::clean_StageContent   $cv_Name
            rattleCAD::cv_custom::updateView [rattleCAD::view::gui::current_canvasCAD]
            
            return
    }

