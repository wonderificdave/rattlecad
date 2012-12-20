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

    
    proc cv_custom::createRearMockup {cv_Name} {
            
            puts ""
            puts "   -------------------------------"
            puts "     createLugRep"
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
                
            set Length(ChainStay)           $project::Custom(WheelPosition/Rear)
            set Length(CrankSet)            $project::Component(CrankSet/Length)
            set Length(PedalMount)          [expr 0.5 * $project::Component(CrankSet/Q-Factor) ]
            set Length(PedalEye)            $project::Component(CrankSet/PedalEye)
            set Length(CrankSet_ArmWidth)   $project::Component(CrankSet/ArmWidth)
            set Length(ChainLine)           $project::Component(CrankSet/ChainLine)

                 #   puts "     BottomBracket(Position) -> $BottomBracket(Position)"
                 #   puts "     RearWheel(Position)    -> $RearWheel(Position)"
                 #   puts "       -> $Length(ChainStay)"
                    
                 #   puts "     BottomBracket -> $project::Lugs(BottomBracket/Diameter/outside)"
                 #   puts "     BottomBracket -> $project::Lugs(BottomBracket/Diameter/inside)"
                 #   puts "     BottomBracket -> $project::Lugs(BottomBracket/Width)"
                 #   puts "     BottomBracket -> $project::Lugs(BottomBracket/ChainStay/Offset_TopView)"
                    
                 #   puts "     RimDiameter   -> $project::Component(Wheel/Rear/RimDiameter)"
                 #   puts "     RimHeight     -> $project::Component(Wheel/Rear/RimHeight)"
                 #   puts "     TyreHeight    -> $project::Component(Wheel/Rear/TyreHeight)"
                    
                 #   puts "     HubWidth      -> $project::Lugs(RearDropOut/HubWidth)"
                    
                 #   puts "     ChainStay     -> $project::Lugs(RearDropOut/ChainStay/Offset)" 
                 #   puts "     ChainStay     -> $project::Lugs(RearDropOut/ChainStay/Offset_TopView)" 
                 #   puts "     ChainStay     -> $project::FrameTubes(ChainStay/Width)" 
            
            
            set Length(00)              [ expr 0.5 * $project::Lugs(BottomBracket/Diameter/outside) ]
            set Length(01)              [ expr 0.5 * $project::Lugs(BottomBracket/Diameter/inside) ]
            set Length(02)              [ expr 0.5 * $project::Lugs(BottomBracket/Width) ]
            set Length(03)              [ expr $Length(02) - $project::Lugs(BottomBracket/ChainStay/Offset_TopView) ]
            set Length(04)              [ expr 0.5 * $project::Component(Wheel/Rear/HubWidth) ]
            set Length(05)              [ expr 0.5 * $project::Component(Wheel/Rear/HubWidth) + $project::Lugs(RearDropOut/ChainStay/Offset_TopView)]

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
            set Center(Tyre)            [ vectormath::addVector $Center(RearHub) [ list [expr 0.5 * ($project::Component(Wheel/Rear/RimDiameter) + $project::Component(Wheel/Rear/TyreHeight))] 0 ] ]
            set Center(Dim_WheelRadius) [ vectormath::addVector $Center(Tyre)    [ list [expr 0.5 * $project::Component(Wheel/Rear/TyreHeight)] 0 ] ]
            set Center(Dim_Tyre_01)     [ vectormath::addVector $Center(Tyre)    [ list 0 [expr  0.5 * $project::Component(Wheel/Rear/TyreHeight)] ] ]
            set Center(Dim_Tyre_02)     [ vectormath::addVector $Center(Tyre)    [ list 0 [expr -0.5 * $project::Component(Wheel/Rear/TyreHeight)] 0 ] ]
            
            
            set Center(ChainStay_DO)    [ vectormath::addVector $Center(RearHub) [ list $project::Lugs(RearDropOut/ChainStay/Offset)  [ expr $Length(04) + $project::Lugs(RearDropOut/ChainStay/Offset_TopView)] ] ]
            set ChainStay(00)           [ list [expr -1.0 * $Length(01)] $Length(03) ] 
            set Center(ChainStay_00)    [ vectormath::cathetusPoint $Center(ChainStay_DO) $ChainStay(00) [expr 0.5 * $project::FrameTubes(ChainStay/WidthBB)] opposite ]
             
                #   puts "   -> Center(Tyre)  $Center(Tyre)"
            
            set ChainStay(91)           [ list [expr -1.0 * $Length(ChainStay)] [expr -1 * $Length(05)] ]   ;# dimension: Chainstay Center DO
            set ChainStay(92)           [ list [expr -1.0 * $Length(ChainStay)] [expr -1 * $Length(04)] ]   ;# dimension: Center DO
            set ChainStay(93)           [ list [expr -1.0 * $Length(01)] [expr -1 * $Length(03)] ]          ;# dimension: Chainstay outside BB
            set ChainStay(94)           [ list $Length(00)               [expr -1 * $Length(02)] ]          ;# dimension: Corner BB
            set ChainStay(95)           [ list [expr -1.0 * ($Length(ChainStay) - $project::Lugs(RearDropOut/ChainStay/Offset))] [expr -1 * $Length(05)] ]   ;# dimension: Chainstay Center DO
                        
                    

            proc create_BottomBracket {} {   
                    upvar  1 cv_Name    ext_cvName              
                    upvar  1 Length     ext_Length
                    upvar  1 Center     ext_Center
                    
                        set length03            [ expr 0.5 * $project::Lugs(BottomBracket/Diameter/outside) ]
                        set length04            [ expr 0.5 * $project::Lugs(BottomBracket/Width) ]
                        set pointList           [ list [expr -1*$length03] [expr -1*$length04] $length03 $length04 ]
                    $ext_cvName create rectangle   $pointList      -outline blue     -fill white  -width 1.0  -tags __Lug__
                    
                        set pointList           [ list [expr -1*$ext_Length(01)] [expr -1*$ext_Length(02)] $ext_Length(01) $ext_Length(02) ]
                    $ext_cvName create rectangle   $pointList      -outline blue     -fill white  -width 1.0  -tags __Lug__
                    return
            }      
            proc create_RearHub {} {   
                    upvar  1 cv_Name        ext_cvName              
                    upvar  1 Length         ext_Length
                    upvar  1 Center         ext_Center
                    upvar  1 ClearCassette  ext_ClearCassette
                    
                        set length03                [ expr 0.5 *  18]
                        set pointList               [ vectormath::addVectorPointList $ext_Center(RearHub) [list [expr -1*$length03] [expr -1*$ext_Length(04)] $length03 $ext_Length(04)] ]
                    set hubRep          [ $ext_cvName create rectangle   $pointList            -outline blue     -width 1.0    -tags __CenterLine__ ]
                    
                        # -- create first Sprocket of Cassete
                    set sp_position     [ vectormath::addVector  $ext_Center(RearHub) {0 1} [ expr $ext_Length(04) - 3 ] ]
                    set sp_object       [ get_ChainWheel $project::Component(Wheel/Rear/FirstSprocket) 2 $sp_position ]
                    set sp_polygon      [ lindex $sp_object 1 ]
                    set sp_clearance    [ lindex $sp_object 2 ]
                    set sprocketRep     [ $ext_cvName create polygon     $sp_polygon     -fill gray -outline black  -tags __Component__ ]
                    
                    set ext_ClearCassette(1)    $sp_clearance
                    
                    lib_gui::object_CursorBinding    $ext_cvName $hubRep
                    $ext_cvName bind   $hubRep    <Double-ButtonPress-1> \
                                       [list frame_geometry::createEdit  %x %y  $ext_cvName  \
                                                    {    Component(Wheel/Rear/HubWidth) \
                                                        text://Component(Wheel/Rear/FirstSprocket) }            {RearHub: }]                                                       
                    
                    lib_gui::object_CursorBinding    $ext_cvName $sprocketRep
                    $ext_cvName bind   $sprocketRep    <Double-ButtonPress-1> \
                                       [list frame_geometry::createEdit  %x %y  $ext_cvName  \
                                                    {    text://Component(Wheel/Rear/FirstSprocket) }            {RearHub: first Sprocket}]                                                       
                    
                    return
            }
            proc create_DropOut {} {   
                    upvar  1 cv_Name    ext_cvName              
                    upvar  1 Length     ext_Length
                    upvar  1 Center     ext_Center
                    
                        set x1                  [ expr [lindex $ext_Center(RearHub) 0] -10 ]
                        set x2                  [ expr [lindex $ext_Center(RearHub) 0] +10 ]
                        set y1                  $ext_Length(04)
                        set y2                  [ expr $ext_Length(04) + 6 ]
                        
                        set pointList           [ list $x1 $y1 $x2 $y2 ]
                    $ext_cvName create rectangle   $pointList            -outline blue     -fill white  -width 1.0  -tags __Lug__
                        set pointList           [ list $x1 [expr -1*$y1] $x2 [expr -1*$y2] ]
                    $ext_cvName create rectangle   $pointList            -outline blue     -fill white  -width 1.0  -tags __Lug__
                    
                        set x1                  [ expr [lindex $ext_Center(RearHub) 0] -14 ]
                        set x2                  [ expr [lindex $ext_Center(RearHub) 0] +40 ]
                        set y1                  [ expr $ext_Length(04) + 1 ]
                        set y2                  [ expr $ext_Length(04) + 5 ]
                        set pointList           [ list $x1 $y1 $x2 $y2 ]
                    $ext_cvName create rectangle   $pointList            -outline blue     -fill white  -width 1.0  -tags __Lug__
                        set pointList           [ list $x1 [expr -1*$y1] $x2 [expr -1*$y2] ]
                    $ext_cvName create rectangle   $pointList            -outline blue     -fill white  -width 1.0  -tags __Lug__
            }
            proc create_BrakeDisc {} {
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
                  
                  set disc_Offset         $project::Rendering(RearMockup/DiscOffset)
                  set disc_Width          $project::Rendering(RearMockup/DiscWidth)
                  set disc_DiameterDisc   $project::Rendering(RearMockup/DiscDiameter)
                  set clearanceRadius     $project::Rendering(RearMockup/DiscClearance)
                  
                  set pos_02  [vectormath::rotateLine $pos_00 $disc_Offset -90]
                  set pos_01  [vectormath::rotateLine $pos_02 $disc_Width   90]
                    # $ext_cvName create circle      $pos_00       -radius 2  -outline red         -width 1.0        -tags __CenterLine__
                    # $ext_cvName create circle      $pos_01       -radius 2  -outline red         -width 1.0        -tags __CenterLine__
                  
                  set p_00    [vectormath::rotateLine $pos_01 30 180]
                  set p_01    [vectormath::rotateLine $pos_01 [expr 0.5 * $disc_DiameterDisc] 0]
                  set vct_00  [vectormath::parallel   $p_00 $p_01 $disc_Width]
                  foreach {p_03 p_02}  $vct_00 break
                  set pointList [list $p_00 $p_02]
                    # puts "    \$pointList: $pointList"
                    
                    # -- draw brake disc
                  set object [$ext_cvName create rectangle   $pointList -outline black     -fill gray  -width 1.0  -tags __Component__]
                    # -- draw clearance arc
                  $ext_cvName create arc         $p_01      -radius $clearanceRadius -start 310  -extent 190 -style arc -outline red  -tags __CenterLine__

                  set ext_Center(p_brakeDisc_01)  $p_01
                  set ext_Center(p_brakeDisc_02)  $p_02

                  return $object
            }
           
            proc get_ChainStay {{type {bent}}} {   
                  upvar  1 cv_Name    ext_cvName
                  upvar  1 stageScale ext_stageScale
                  
                  upvar  1 Length     ext_Length
                  upvar  1 Center     ext_Center
                  upvar  1 ChainStay  ext_ChainStay
                  
                  upvar  1 Colour     ext_Colour
                    
                    
                    # puts "  -> get_ChainStay $type: \$ext_Length"
                    # parray  ext_Length
                    # puts "  -> get_ChainStay $type: \$ext_Center"
                    # parray ext_Center
                    # puts "  -> get_ChainStay $type: \$ext_ChainStay"
                    # parray ext_ChainStay

                    # puts "   \$ext_Center(ChainStay_DO)  $ext_Center(ChainStay_DO)"
                    # puts "   \$ext_Length(03)            $ext_Length(03)"
                    # puts "   \$ext_Length(01)            $ext_Length(01)"
                       
                set p_CS_BB [list [expr -1.0 * $ext_Length(01)] $ext_Length(03)]                   
                    # puts "   \$p_CS_BB                   $p_CS_BB"
 

                    # -- tube profile
                set profile_y00   $project::FrameTubes(ChainStay/Profile/width_00)
                set profile_x01   $project::FrameTubes(ChainStay/Profile/length_01)
                set profile_y01   $project::FrameTubes(ChainStay/Profile/width_01)
                set profile_x02   $project::FrameTubes(ChainStay/Profile/length_02)
                set profile_y02   $project::FrameTubes(ChainStay/Profile/width_02)
                set profile_x03   $project::FrameTubes(ChainStay/Profile/length_03)
                set profile_y03   $project::FrameTubes(ChainStay/Profile/width_03)


                set profileDef {}
                  lappend profileDef [list 0            $profile_y00]
                  lappend profileDef [list $profile_x01 $profile_y01]
                  lappend profileDef [list $profile_x02 $profile_y02]
                  lappend profileDef [list $profile_x03 $profile_y03]        
                    # puts "  -> \$profileDef $profileDef"
                
                    # -- set profile of straight, unbent tubeprofile
                set tubeProfile [lib_tube::init_tubeProfile $profileDef]                                    
                    # puts "  -> \$tubeProfile $tubeProfile"


                    # -- tube centerline
                switch -exact $type {
                  {straight} {
                        set S01_length   $project::FrameTubes(ChainStay/CenterLine/length_01)
                        set S02_length   $project::FrameTubes(ChainStay/CenterLine/length_02)
                        set S03_length   $project::FrameTubes(ChainStay/CenterLine/length_03)
                        set S01_angle      0
                        set S02_angle      0
                        set S01_radius   320
                        set S02_radius   320
                        set lib_tube::arcPrecission 50
                      }
                  default {
                          # -- bent                                                
                        set S01_length   $project::FrameTubes(ChainStay/CenterLine/length_01)
                        set S02_length   $project::FrameTubes(ChainStay/CenterLine/length_02)
                        set S03_length   $project::FrameTubes(ChainStay/CenterLine/length_03)
                        set S01_angle    $project::FrameTubes(ChainStay/CenterLine/angle_01)
                        set S02_angle    $project::FrameTubes(ChainStay/CenterLine/angle_02)
                        set S01_radius   $project::FrameTubes(ChainStay/CenterLine/radius_01)
                        set S02_radius   $project::FrameTubes(ChainStay/CenterLine/radius_02)
                        set lib_tube::arcPrecission 5
                      }
                }
                
                set orient_select  left
                set centerLineDef [list $S01_length $S02_length $S03_length \
                                        $S01_angle  $S02_angle \
                                        $S01_radius $S02_radius]
                                        
                    # -- get smooth centerLine
                set centerLine            [lib_tube::init_centerLine $centerLineDef] 
                    # puts "  -> \$centerLine $centerLine"
                    # -- get shape of tube
                set outLineLeft   [lib_tube::get_tubeShape    $centerLine $tubeProfile left  ]
                set outLineRight  [lib_tube::get_tubeShape    $centerLine $tubeProfile right ]
                set outLine       [canvasCAD::flatten_nestedList $outLineLeft $outLineRight]
                    # puts "\n    -> \$outLineLeft   $outLineLeft"
                    # puts "\n    -> \$outLineRight  $outLineRight"
                    # puts "\n    -> \$outLine       $outLine "
                
                
                    # get orientation of tube
                set length    [vectormath::length   $ext_Center(ChainStay_DO) $p_CS_BB]
                set angle     [vectormath::dirAngle $ext_Center(ChainStay_DO) $p_CS_BB]
                      # puts "  -> \$length $length"
                      # puts "  -> \$angle $angle"
                set point_IS  [lib_tube::get_shapeInterSection $outLineLeft $length]       
                set angleIS   [vectormath::dirAngle {0 0} $point_IS]
                set angleRotation [expr $angle - $angleIS]
                      # puts "  -> \$point_IS $point_IS"
                      # puts "  -> \$angleIS $angleIS"
                      # puts "  -> \$angleRotation $angleRotation"
                    # -- prepare $outLine for exprot 
                set outLine     [vectormath::rotatePointList {0 0} $outLine $angleRotation]    
                set outLine     [vectormath::addVectorPointList $ext_Center(ChainStay_DO) $outLine]
                      # $ext_cvName  create   polygon $outLine    -tags __Tube__  -fill lightgray
                   
                # -- prepare $centerLine for exprot 
                set centerLine  [canvasCAD::flatten_nestedList $centerLine]
                set centerLine  [vectormath::rotatePointList {0 0} $centerLine $angleRotation]    
                set centerLine  [vectormath::addVectorPointList $ext_Center(ChainStay_DO) $centerLine]
                    # $ext_cvName  create   line    $centerLine -tags __CenterLine__  -fill blue
                
                return [list $centerLine $outLine]
            }
            proc get_ChainWheel {z w position} {                    
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
                    
                    set polygon         [ project::flatten_nestedList       [ list  $pt_01  $pt_02  $pt_03  $pt_04  \
                                                                                    $pt_05  $pt_06  $pt_07  $pt_08 ] ]
                    set polygon         [ vectormath::addVectorPointList    $position $polygon ]                                                            
                    return [list $pt_Clearance_l $polygon $pt_Clearance_r]
            }
            proc create_CrankArm {} {
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
                    set polygon         [ project::flatten_nestedList   $pt_10  $pt_11  $pt_12  $pt_13 \
                                                                        $pt_20  $pt_21  $pt_22  $pt_23  $pt_24  $pt_25] 
                    
                    set componentCrank  [ $ext_cvName create polygon         $polygon    -fill gray -outline black  -tags  __Component__ ]
                    
                    
                   lib_gui::object_CursorBinding    $ext_cvName $componentCrank
                   $ext_cvName bind   $componentCrank    <Double-ButtonPress-1> \
                                       [list frame_geometry::createEdit  %x %y  $ext_cvName  \
                                                    {   Component(CrankSet/ChainLine) \
                                                        Component(CrankSet/Q-Factor) \
                                                        text://Component(CrankSet/ChainRings) }            {Crankset:  Parameter}]
                                                        
                        # -- centerline of pedal axis
                    $ext_cvName create centerline     [ project::flatten_nestedList $pt_00 $pt_03 ] \
                                                                                     -fill gray50       -width 0.25     -tags __CenterLine__


                        # -- global points
                    set ext_Center(Dim_Q_Factor)    [ list [expr -1.0 * $ext_Length(CrankSet)] 0 ]
                    set ext_Center(Q_Factor)        $pt_02 
                    set ext_Center(CrankArm)        $pt_11 
                    set ext_Center(PedalEye)        $pt_12 
                    set ext_Center(ChainLine)       [ list 0 [expr -1.0 * $ext_Length(ChainLine) ] ]


                        # -- create chainwheels
                    set chainLine           $project::Component(CrankSet/ChainLine)
                    set chainWheelDistance  5
                    set chainWheelWidth     2
                    set list_ChainRings     [lsort [split $project::Component(CrankSet/ChainRings) -]]
                        # puts "  <D> create_CrankArm: $project::Component(CrankSet/ChainRings)"
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
                            $ext_cvName create polygon     $cw_polygon     -fill gray -outline black  -tags __Component__ 
                        
                                # -- position of next chainwheel
                            set chainWheelPos   [ vectormath::addVector $chainWheelPos {0 1} $chainWheelDistance ]
                                
                                # -- add position to ext_ClearChainWheel
                            incr cw_index
                            set ext_ClearChainWheel($cw_index)    $cw_clearance
                    }
                   
                    return
            }
            proc create_ClearArea {} {
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
                            set clearRadius [ expr  0.5 * $project::Component(Wheel/Rear/TyreHeight) + $project::Rendering(RearMockup/TyreClearance) ]
                            set pt_99       [ vectormath::addVector  $ext_Center(Tyre)  {0 -1} $clearRadius ]
                            set pt_98       [ vectormath::addVector  $pt_99  {-70 0} ]
                    lappend polygon     $pt_98  $pt_99
                            set angle 0
                            while {$angle <= 90} {
                                    set pt_tmp  [ vectormath::rotatePoint  $ext_Center(Tyre) $pt_99 $angle]
                                    lappend polygon     $pt_tmp
                                    incr angle 10
                            }
                    set ext_Center(TyreClearance)        $pt_98 
         
                    
                        # -- BB clearance
                            set pt_01       [ list   [lindex $ext_ChainStay(00) 0] 0 ]
                    lappend polygon     $pt_01
                            set pt_02       [ vectormath::mirrorPoint {0 0} {1 0} $ext_ChainStay(00) ] 
                                #[ list   [lindex $ext_ChainStay(00) 0] [expr -1 * [lindex $ext_ChainStay(00) 1]] ]     
                    lappend polygon     $pt_02
                            
                        # -- ChainWheel clearance
                            set name        [ lindex [array names ext_ClearChainWheel] 0 ]        
                            set pt_cw1      $ext_ClearChainWheel($name)
                            set pt_03       [ vectormath::cathetusPoint  $pt_02  $pt_cw1  $project::Rendering(RearMockup/ChainWheelClearance) opposite ]
                    lappend polygon     $pt_03
                            
                        # -- # -- second & third ChainWheel
                            set pt_last $pt_cw1
                            foreach name [lrange [array names ext_ClearChainWheel] 1 end] {
                                    set pt_tmp  $ext_ClearChainWheel($name)
                                    set vct_tmp [ vectormath::parallel $pt_last $pt_tmp $project::Rendering(RearMockup/ChainWheelClearance) ]
                                    lappend polygon     [lindex $vct_tmp 0] [lindex $vct_tmp 1]
                                    set pt_last $pt_tmp
                            }
                    
                        # -- CrankArm clearance
                            set delta       [ expr   $project::Rendering(RearMockup/CrankClearance) - $project::Rendering(RearMockup/ChainWheelClearance) ]
                            set pt_ca       [ vectormath::cathetusPoint  $pt_last  $ext_Center(CrankArm)  $delta opposite ]
                            set vct_tmp     [ vectormath::parallel $pt_last $pt_ca  $project::Rendering(RearMockup/ChainWheelClearance) ]
                    lappend polygon     [ lindex $vct_tmp 0 ] [ lindex $vct_tmp 1 ]
                            set clearRadius $project::Rendering(RearMockup/CrankClearance)
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
                            set pt_sp       [ vectormath::addVector  $ext_ClearCassette(1)  {  1   0}  $project::Rendering(RearMockup/CassetteClearance) ]
                            
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
                    set             polygon     [ project::flatten_nestedList    $polygon ]
                    
                    set chainstayArea   [ $ext_cvName create polygon     $polygon     -fill lightgray -outline black  -tags __CenterLine__ ]

                    lib_gui::object_CursorBinding    $ext_cvName $chainstayArea
                    $ext_cvName bind   $chainstayArea    <Double-ButtonPress-1> \
                                       [list frame_geometry::createEdit  %x %y  $ext_cvName  \
                                                    {   list://Rendering(ChainStay@SELECT_ChainStay) \
                                                        Rendering(RearMockup/TyreClearance) \
                                                        Rendering(RearMockup/ChainWheelClearance) \
                                                        Rendering(RearMockup/CrankClearance) \
                                                        Rendering(RearMockup/CassetteClearance) }            {ChainStay:  Area}]                    
                     return
            }                   
                    
                    
            proc create_ControlCurves {} {
                    upvar  1 cv_Name    ext_cvName
                    upvar  1 stageScale ext_stageScale
                    
                    upvar  1 Length             ext_Length
                    upvar  1 Center             ext_Center
                    upvar  1 ChainStay          ext_ChainStay
                    upvar  1 ClearChainWheel    ext_ClearChainWheel
                    upvar  1 ClearCassette      ext_ClearCassette

                        
                        # -- Tyre Clearance
                    set radius  [ expr  0.5 * $project::Component(Wheel/Rear/TyreHeight) + $project::Rendering(RearMockup/TyreClearance) ]
                      $ext_cvName create arc      $ext_Center(Tyre)  -radius $radius -start 250  -extent 110 -style arc -outline red  -tags __CenterLine__

                        # -- ChainWheel Clearance
                    set radius  $project::Rendering(RearMockup/ChainWheelClearance)
                    foreach name [array names ext_ClearChainWheel] {
                            # puts "   --> $name  $ext_ClearChainWheel($name)"
                        set position    $ext_ClearChainWheel($name)
                        $ext_cvName create arc      $position  -radius $radius -start 30  -extent 180 -style arc -outline red  -tags __CenterLine__
                    }
                    
                        # -- CrankArm Clearance
                    set radius  $project::Rendering(RearMockup/CrankClearance)
                    set position    $ext_Center(CrankArm)
                    $ext_cvName create arc      $position  -radius $radius  -start 30  -extent 180  -style arc  -outline red  -tags __CenterLine__
                    
                        # -- Casette clearance
                    set radius  $project::Rendering(RearMockup/CassetteClearance)
                    set position    $ext_ClearCassette(1)
                    $ext_cvName create arc  $position  -radius $radius  -start 280  -extent 80  -style arc  -outline red  -tags __CenterLine__
                    $ext_cvName create arc  $position  -radius $radius  -start   0  -extent 80  -style arc  -outline red  -tags __CenterLine__
             
                    return
            }
            
            

            
  
                # -- create CrankArm & RearHub
            create_CrankArm
            create_RearHub
            
                # -- ChainStay Area      
            create_ClearArea

                # -- create DropOuts
            create_DropOut

               # -- create BottomBracket
            create_BottomBracket
            

                # -- ChainStay Type
            switch $project::Rendering(ChainStay) {
                   {straight}   { set retValues [get_ChainStay straight] }
                   {bent}     { set retValues [get_ChainStay bent]}
                   {off}        {}
                   default      { puts "\n  <W> ... not defined in createRearMockup: $project::Rendering(ChainStay)\n"
                                  # return
                                }
            }
            switch $project::Rendering(ChainStay) {
                   {straight}   -
                   {bent}     { set ChainStay(centerLine) [lindex $retValues 0]
                                  set ChainStay(polygon)    [lindex $retValues 1]
                                  set tube_CS_left    [ $cv_Name create polygon     $ChainStay(polygon)      -fill gray   -outline black  -tags __Tube__ ]
                                  set tube_CS_CLine   [ $cv_Name create line        $ChainStay(centerLine)   -fill orange                 -tags __CenterLine__ ]
                                      set polygon_opposite {}
                                      foreach {x y}  $ChainStay(polygon) {
                                              lappend polygon_opposite $x [expr -1.0 * $y]
                                      }  
                                  set tube_CS_right   [ $cv_Name create polygon     $polygon_opposite     -fill gray -outline black  -tags __Tube__ ]

                                      #$ext_cvName  create   polygon $outLine    -tags __Tube__         -fill lightgray
                                      #$ext_cvName  create   line    $centerLine -tags __CenterLine__   -fill blue
                                    
                                  lib_gui::object_CursorBinding   $cv_Name    $tube_CS_CLine
                                  lib_gui::object_CursorBinding   $cv_Name    $tube_CS_right
                                  lib_gui::object_CursorBinding   $cv_Name    $tube_CS_left
                                   
                                  $cv_Name bind   $tube_CS_CLine    <Double-ButtonPress-1> \
                                                  [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                              {   list://Rendering(ChainStay@SELECT_ChainStay)    \
                                                                  FrameTubes(ChainStay/CenterLine/length_01) \
                                                                  FrameTubes(ChainStay/CenterLine/length_02) \
                                                                  FrameTubes(ChainStay/CenterLine/length_03) \
                                                                  FrameTubes(ChainStay/CenterLine/angle_01) \
                                                                  FrameTubes(ChainStay/CenterLine/angle_02) \
                                                                  FrameTubes(ChainStay/CenterLine/radius_01) \
                                                                  FrameTubes(ChainStay/CenterLine/radius_02) } {Chainstay:  CenterLine}]
                                                                  
                                  $cv_Name bind   $tube_CS_left   <Double-ButtonPress-1> \
                                                  [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                              {   FrameTubes(ChainStay/Profile/width_00)  \
                                                                  FrameTubes(ChainStay/Profile/length_01) \
                                                                  FrameTubes(ChainStay/Profile/width_01)  \
                                                                  FrameTubes(ChainStay/Profile/length_02) \
                                                                  FrameTubes(ChainStay/Profile/width_02)  \
                                                                  FrameTubes(ChainStay/Profile/length_03) \
                                                                  FrameTubes(ChainStay/Profile/width_03)  }  {Chainstay:  Profile}]
                                 $cv_Name bind   $tube_CS_right   <Double-ButtonPress-1> \
                                                  [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                              {   FrameTubes(ChainStay/Profile/width_00)  \
                                                                  FrameTubes(ChainStay/Profile/length_01) \
                                                                  FrameTubes(ChainStay/Profile/width_01)  \
                                                                  FrameTubes(ChainStay/Profile/length_02) \
                                                                  FrameTubes(ChainStay/Profile/width_02)  \
                                                                  FrameTubes(ChainStay/Profile/length_03) \
                                                                  FrameTubes(ChainStay/Profile/width_03)  }  {Chainstay:  Profile}]

                                }
                   default      { set ChainStay(polygon) {} }
            }


               # -- create BrakeDisc
            set brakeDisc [create_BrakeDisc]
            lib_gui::object_CursorBinding   $cv_Name    $brakeDisc
            $cv_Name bind   $brakeDisc    <Double-ButtonPress-1> \
                      [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                  {   Rendering(RearMockup/DiscDiameter) \
                                                      Rendering(RearMockup/DiscWidth) \
                                                      Rendering(RearMockup/DiscClearance) } {DiscBrake Details}]

               # -- create control Curves
            create_ControlCurves            
   
                # -- centerlines
            $cv_Name create centerline     [ project::flatten_nestedList $Center(CL_BB_01)         $Center(CL_BB_02) ] \
                                                                            -fill gray50       -width 0.25     -tags __CenterLine__
            $cv_Name create centerline     [ project::flatten_nestedList $Center(CL_RearHub_01)    $Center(CL_RearHub_02) ] \
                                                                            -fill gray50       -width 0.25     -tags __CenterLine__         
            $cv_Name create centerline     [ project::flatten_nestedList $Center(BottomBracket) $Center(RearHub)] \
                                                                            -fill gray50       -width 0.25     -tags __CenterLine__
           

                # -- specific dimensions for s-bent ChainStays 
            switch $project::Rendering(ChainStay) {
                   {s-bent2} { 
                            $cv_Name create centerline     [ project::flatten_nestedList $Center(ChainStay_DO)  $Center(DIM_Base_DO)  $Center(DIM_Base_00)  $Center(DIM_Base_BB)  $Center(ChainStay_BB) ] \
                                                                                               -fill gray50         -width 0.25     -tags __CenterLine__
                            $cv_Name create centerline     [ project::flatten_nestedList $Center(ChainStay_DO)  $Center(DIM_Base_00)  $Center(ChainStay_BB) ] \
                                                                                               -fill gray50         -width 0.25     -tags __CenterLine__
                            $cv_Name create circle      $Center(ChainStay_DO)       -radius 2  -outline red         -width 1.0        -tags __CenterLine__
                            $cv_Name create circle      $Center(DIM_Base_00)        -radius 2  -outline red         -width 1.0        -tags __CenterLine__
                            $cv_Name create circle      $Center(DIM_Base_00_Ref)    -radius 2  -outline gray50         -width 1.0        -tags __CenterLine__
                            $cv_Name create circle      $Center(DIM_Base_DO)        -radius 2  -outline red         -width 1.0        -tags __CenterLine__
                            $cv_Name create circle      $Center(DIM_Base_DO_Ref)    -radius 2  -outline gray50         -width 1.0        -tags __CenterLine__
                            $cv_Name create circle      $Center(DIM_Base_BB)        -radius 2  -outline red         -width 1.0        -tags __CenterLine__
                            $cv_Name create circle      $Center(DIM_Base_BB_Ref)    -radius 2  -outline gray50         -width 1.0        -tags __CenterLine__
                            $cv_Name create circle      $Center(ChainStay_BB)       -radius 2  -outline red         -width 1.0        -tags __CenterLine__
                            
                            
                            set _dim_00_Offset      [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(ChainStay_DO) $Center(DIM_Base_00_Ref) ] \
                                                                            aligned        [expr -65 * $stageScale]    [expr   0 * $stageScale]  \
                                                                            $Colour(third) ]
                            set _dim_00_OffsetPerp  [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(DIM_Base_00_Ref) $Center(DIM_Base_00) ] \
                                                                            aligned        [expr -20 * $stageScale]    [expr -30 * $stageScale]  \
                                                                            $Colour(third) ]
                                                                            
                            set _dim_DO_Offset      [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(DIM_Base_00) $Center(DIM_Base_DO_Ref) ] \
                                                                            aligned        [expr  50 * $stageScale]    [expr   0 * $stageScale]  \
                                                                            $Colour(third) ]
                            set _dim_DO_OffsetPerp  [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(DIM_Base_DO_Ref) $Center(DIM_Base_DO) ] \
                                                                            aligned        [expr  20 * $stageScale]    [expr  30 * $stageScale]  \
                                                                            $Colour(third) ]
                                                                            
                            set _dim_BB_Offset      [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(DIM_Base_00) $Center(DIM_Base_BB_Ref) ] \
                                                                            aligned        [expr -50 * $stageScale]    [expr   0 * $stageScale]  \
                                                                            $Colour(third) ]
                            set _dim_BB_OffsetPerp  [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(DIM_Base_BB_Ref) $Center(DIM_Base_BB) ] \
                                                                            aligned        [expr -20 * $stageScale]    [expr  30 * $stageScale]  \
                                                                            $Colour(third) ]
                                                                            
                            lib_gui::object_CursorBinding     $cv_Name    $_dim_00_Offset
                            lib_gui::object_CursorBinding     $cv_Name    $_dim_00_OffsetPerp
                            lib_gui::object_CursorBinding     $cv_Name    $_dim_DO_Offset
                            lib_gui::object_CursorBinding     $cv_Name    $_dim_DO_OffsetPerp
                            lib_gui::object_CursorBinding     $cv_Name    $_dim_BB_Offset
                            lib_gui::object_CursorBinding     $cv_Name    $_dim_BB_OffsetPerp
                            
                            $cv_Name bind $_dim_00_Offset            <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  FrameTubes(ChainStay/Bent/Base_00/Offset) ]
                            $cv_Name bind $_dim_00_OffsetPerp        <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  FrameTubes(ChainStay/Bent/Base_00/OffsetPerp) ]
                            $cv_Name bind $_dim_DO_Offset            <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  FrameTubes(ChainStay/Bent/Base_DO/Offset) ]
                            $cv_Name bind $_dim_DO_OffsetPerp        <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  FrameTubes(ChainStay/Bent/Base_DO/OffsetPerp) ]
                            $cv_Name bind $_dim_BB_Offset            <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  FrameTubes(ChainStay/Bent/Base_BB/Offset) ]
                            $cv_Name bind $_dim_BB_OffsetPerp        <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  FrameTubes(ChainStay/Bent/Base_BB/OffsetPerp) ]
                            
                            }
                    default {}
            }


                # -- mark positions of dimensions
            $cv_Name create circle      $ChainStay(95)          -radius 2   -outline red         -width 1.0        -tags __CenterLine__
            $cv_Name create circle      $ChainStay(93)          -radius 2   -outline red         -width 1.0        -tags __CenterLine__
            $cv_Name create circle      $Center(Dim_RearHub_01) -radius 2   -outline red         -width 1.0        -tags __CenterLine__
            $cv_Name create circle      $Center(Dim_RearHub_02) -radius 2   -outline red         -width 1.0        -tags __CenterLine__
            $cv_Name create circle      $Center(ChainLine)      -radius 1   -outline red         -width 1.0        -tags __CenterLine__
            
            $cv_Name create circle      $Center(BottomBracket)  -radius 3   -outline red         -width 1.0        -tags __CenterLine__
            $cv_Name create circle      $Center(RearHub)        -radius 3   -outline blue        -width 1.0        -tags __CenterLine__


                # -- tyre Representation 
            $cv_Name create circle      $Center(Tyre)           -radius [expr 0.5 * $project::Component(Wheel/Rear/TyreHeight)] \
                                                                            -outline blue        -width 1.0        -tags {__Component__}

                # -- dimensions
                #

                # -- Wheel radius
            set _dim_Wh_Radius          [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(CL_RearHub_01) $Center(Dim_WheelRadius) ] \
                                                                    horizontal        [expr   45 * $stageScale]   [expr  0 * $stageScale]  \
                                                                    gray50 ]
            set _dim_Tyre_Width         [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(Dim_Tyre_01) $Center(Dim_Tyre_02) ] \
                                                                    vertical        [expr   30 * $stageScale]   [expr  0 * $stageScale]  \
                                                                    gray50 ]
            set _dim_Sprocket_CL        [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(Dim_RearHub_02) $Center(SprocketClearance) ] \
                                                                    horizontal        [expr  -35 * $stageScale]   [expr -5 * $stageScale]  \
                                                                    gray50 ]
            set _dim_Tyre_CL            [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(Tyre) $Center(TyreClearance) ] \
                                                                    vertical        [expr   65 * $stageScale]   [expr 20 * $stageScale]  \
                                                                    gray50 ]
                                                                                                                                   

                # -- dimensions & bindings
                #

                # -- ChainStay length
            set _dim_CS_Length             [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(CL_RearHub_02) $Center(CL_BB_02) ] \
                                                                    horizontal        [expr  -30 * $stageScale]   [expr 0 * $stageScale]  \
                                                                    $Colour(result) ] 
                    lib_gui::object_CursorBinding     $cv_Name    $_dim_CS_Length
                    $cv_Name bind $_dim_CS_Length        <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Custom(WheelPosition/Rear) ]

                    
                # -- BottomBracket
            set _dim_BB_Diam_inside     [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(Dim_BBDiam_01) $Center(Dim_BBDiam_02) ] \
                                                                    horizontal        [expr  20 * $stageScale]    [expr  35 * $stageScale]  \
                                                                    $Colour(primary) ] 
            set _dim_BB_Diam_outside    [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(Dim_BBWidth_02) $Center(Dim_BBDiameter) ] \
                                                                    horizontal        [expr  35 * $stageScale]    [expr  35 * $stageScale]  \
                                                                    $Colour(primary) ] 
            set _dim_BB_Width           [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(Dim_BBWidth_01) $Center(Dim_BBWidth_02) ] \
                                                                    vertical        [expr  35 * $stageScale]    [expr -10 * $stageScale]  \
                                                                    $Colour(primary) ] 
            set _dim_CS_BB_Offset       [ $cv_Name dimension  length      [ project::flatten_nestedList   $ChainStay(93) $ChainStay(94) ] \
                                                                    vertical        [expr -60 * $stageScale]   [expr  15 * $stageScale]  \
                                                                    $Colour(primary) ] 
                    lib_gui::object_CursorBinding     $cv_Name    $_dim_BB_Diam_inside       
                    lib_gui::object_CursorBinding     $cv_Name    $_dim_BB_Diam_outside       
                    lib_gui::object_CursorBinding     $cv_Name    $_dim_BB_Width       
                    lib_gui::object_CursorBinding     $cv_Name    $_dim_CS_BB_Offset       
                    $cv_Name bind $_dim_BB_Diam_inside  <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Lugs(BottomBracket/Diameter/inside) ]
                    $cv_Name bind $_dim_BB_Diam_outside <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Lugs(BottomBracket/Diameter/outside) ]
                    $cv_Name bind $_dim_BB_Width        <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Lugs(BottomBracket/Width) ]
                    $cv_Name bind $_dim_CS_BB_Offset    <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Lugs(BottomBracket/ChainStay/Offset_TopView) ]

                    
                # -- BrakeDisc
            set _dim_BrakeDisc_Dist_Hub [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(p_brakeDisc_02) $Center(Dim_RearHub_01) ] \
                                                                    vertical        [expr  28 * $stageScale]    [expr  20 * $stageScale]  \
                                                                    $Colour(primary) ] 
            set _dim_BrakeDisc_Dist_DO  [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(p_brakeDisc_01) $Center(Dim_RearHub_01) ] \
                                                                    vertical        [expr  15 * $stageScale]    [expr -20 * $stageScale]  \
                                                                    $Colour(result) ] 
            set _dim_BrakeDisc_Diameter [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(CL_RearHub_02)  $Center(p_brakeDisc_01) ] \
                                                                    horizontal      [expr -15 * $stageScale]    0 \
                                                                    $Colour(result) ] 
                    lib_gui::object_CursorBinding     $cv_Name    $_dim_BrakeDisc_Dist_Hub       
                    $cv_Name bind $_dim_BrakeDisc_Dist_Hub  <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Rendering(RearMockup/DiscOffset) ]


                # -- RearHub
            set _dim_Hub_Width          [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(Dim_RearHub_01) $Center(Dim_RearHub_02) ] \
                                                                    vertical        [expr  35 * $stageScale]    [expr -10 * $stageScale]  \
                                                                    $Colour(primary) ] 
            set _dim_CS_DO_Distance     [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(Dim_RearHub_02) $ChainStay(95) ] \
                                                                    horizontal      [expr  35 * $stageScale]    0  \
                                                                    $Colour(primary) ] 
            set _dim_CS_DO_Offset       [ $cv_Name dimension  length      [ project::flatten_nestedList   $ChainStay(92) $ChainStay(95) ] \
                                                                    vertical        [expr -55 * $stageScale]    [expr -30 * $stageScale]  \
                                                                    $Colour(primary) ] 
                    lib_gui::object_CursorBinding     $cv_Name    $_dim_Hub_Width            
                    lib_gui::object_CursorBinding     $cv_Name    $_dim_CS_DO_Distance
                    lib_gui::object_CursorBinding     $cv_Name    $_dim_CS_DO_Offset
                    $cv_Name bind $_dim_Hub_Width       <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Component(Wheel/Rear/HubWidth) ]
                    $cv_Name bind $_dim_CS_DO_Distance  <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Lugs(RearDropOut/ChainStay/Offset) ]
                    $cv_Name bind $_dim_CS_DO_Offset    <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Lugs(RearDropOut/ChainStay/Offset_TopView) ]
                  
                  
                  #$project::Lugs(RearDropOut/ChainStay/Offset)                                            
                                                                    
                # -- CrankSet
            set _dim_Crank_Length       [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(Q_Factor) $Center(CL_BB_01) ] \
                                                                    horizontal        [expr   35 * $stageScale]    [expr -30 * $stageScale]  \
                                                                    $Colour(primary) ]
            set _dim_PedalEye           [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(PedalEye) $Center(Q_Factor) ] \
                                                                    horizontal        [expr   35 * $stageScale]    [expr  20 * $stageScale]  \
                                                                    $Colour(primary) ]
            set _dim_Crank_Q_Factor     [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(Dim_Q_Factor) $Center(PedalEye) ] \
                                                                    vertical        [expr   55 * $stageScale]    [expr  15 * $stageScale]  \
                                                                    $Colour(primary) ]
            set _dim_CrankArmWidth      [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(CrankArm) $Center(PedalEye) ] \
                                                                    vertical        [expr   20 * $stageScale]    [expr -20 * $stageScale]  \
                                                                    $Colour(primary) ]
                                                                    
            set _dim_ChainLine          [ $cv_Name dimension  length      [ project::flatten_nestedList   $Center(BottomBracket) $Center(ChainLine) ] \
                                                                    vertical        [expr  -90 * $stageScale]    [expr  0 * $stageScale]  \
                                                                    $Colour(primary) ]
                    lib_gui::object_CursorBinding     $cv_Name    $_dim_Crank_Length       
                    lib_gui::object_CursorBinding     $cv_Name    $_dim_PedalEye       
                    lib_gui::object_CursorBinding     $cv_Name    $_dim_Crank_Q_Factor
                    lib_gui::object_CursorBinding     $cv_Name    $_dim_CrankArmWidth       
                    lib_gui::object_CursorBinding     $cv_Name    $_dim_ChainLine
                    $cv_Name bind $_dim_Crank_Length    <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Component(CrankSet/Length) ]
                    $cv_Name bind $_dim_PedalEye        <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Component(CrankSet/PedalEye) ]
                    $cv_Name bind $_dim_Crank_Q_Factor  <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Component(CrankSet/Q-Factor) ]
                    $cv_Name bind $_dim_CrankArmWidth   <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Component(CrankSet/ArmWidth) ]
                    $cv_Name bind $_dim_ChainLine       <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Component(CrankSet/ChainLine) ]
           
            return           

    }
    
    