 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_frame_geometry_custom.tcl
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
 #    namespace:  rattleCAD::frame_geometry_custom
 # ---------------------------------------------------------------------------
 #
 #


        #
        # --- set ChainStay ------------------------
    proc bikeGeometry::get_ChainStay {} {
            variable RearDrop
            variable ChainStay
            variable RearWheel
                #
            set ChainStay(HeigthBB)         $project::FrameTubes(ChainStay/HeightBB)
            set ChainStay(DiameterSS)       $project::FrameTubes(ChainStay/DiameterSS)
            set ChainStay(Height)           $project::FrameTubes(ChainStay/Height)
            set ChainStay(TaperLength)      $project::FrameTubes(ChainStay/TaperLength)
            set ChainStay(WidthBB)          $project::FrameTubes(ChainStay/WidthBB)
                #
                #
            set vct_angle   [ vectormath::dirAngle      $RearWheel(Position)  {0 0}]
            set vct_xy      [ list $RearDrop(OffsetCS) [expr -1.0 * $RearDrop(OffsetCSPerp)]]
            set vct_xyAngle [ vectormath::dirAngle {0 0} $vct_xy]
            switch -exact  $RearDrop(Direction) {
                ChainStay  -
                Chainstay  { 
                            set do_angle         [expr $vct_angle - $RearDrop(RotationOffset)]
                        }
                horizontal { 
                            set do_angle         [expr 360 - $RearDrop(RotationOffset)]
                       }
                default    {}
            }    
            
                # set do_angle    [ expr $vct_angle - $RearDrop(RotationOffset)]
            set vct_CS      [ vectormath::rotatePoint   {0 0}  $vct_xy  $do_angle]
            set pt_00       [ vectormath::addVector     $RearWheel(Position)  $vct_CS]
                #
            set ChainStay(Direction)            [ vectormath::unifyVector $pt_00 {0 0}]
                #
            project::setValue Result(Tubes/ChainStay/Direction) direction   $ChainStay(Direction)
                #
            project::setValue Result(Tubes/ChainStay/CenterLine)  value [list [format "%s,%s %s,%s" [lindex $pt_00 0] [lindex $pt_00 1] \
                                                                                                    0                 0 ] ]



                # -- position of Rear Derailleur Mount
            set vct_xy      [ list [expr -1 * $RearDrop(Derailleur_x)]  [expr -1 * $RearDrop(Derailleur_y)]]
            set vct_mount   [ vectormath::rotatePoint   {0 0}  $vct_xy  $do_angle]
            set pt_mount    [ vectormath::addVector     $RearWheel(Position)  $vct_mount]
                #
            project::setValue Result(Lugs/Dropout/Rear/Derailleur)  position     $pt_mount


                        # -- exception if Tube is shorter than taper length
                    set tube_length         [ vectormath::length {0 0} $pt_00 ]
                        if { [expr $tube_length - $ChainStay(TaperLength) -110] < 0 } {
                            # puts "            ... exception:  ChainStay TaperLength ... $tube_length / $ChainStay(TaperLength)"
                            set taper_length    [ expr $tube_length -110 ]
                            # puts "                         -> $taper_length"
                        } else {
                            set taper_length    $ChainStay(TaperLength)
                        }

                    set pt_01       [ vectormath::addVector         $pt_00  $ChainStay(Direction)  $taper_length ]
                    set pt_02       [ vectormath::addVector         $pt_00  $ChainStay(Direction)  [expr $taper_length + 40] ]
                    set pt_03       [ vectormath::addVector         $pt_00  $ChainStay(Direction)  [expr $taper_length + 85] ]

                    set ChainStay(RearWheel)            $pt_00
                    set ChainStay(BottomBracket)        {0 0}
            project::setValue Result(Tubes/ChainStay/Start)         position    $ChainStay(RearWheel)
            project::setValue Result(Tubes/ChainStay/End)           position    {0 0}

                    set vct_01      [ vectormath::parallel          $pt_00 $pt_01 [expr 0.5*$ChainStay(DiameterSS)] ]
                    set vct_02      [ vectormath::parallel          $pt_01 $pt_02 [expr 0.5*$ChainStay(Height)]    ]
                    set vct_03      [ vectormath::parallel          $pt_03 $ChainStay(BottomBracket) [expr 0.5*$ChainStay(HeigthBB)] ]
                    set vct_04      [ vectormath::parallel          $pt_03 $ChainStay(BottomBracket) [expr 0.5*$ChainStay(HeigthBB)] left]
                    set vct_05      [ vectormath::parallel          $pt_01 $pt_02 [expr 0.5*$ChainStay(Height)]     left]
                    set vct_06      [ vectormath::parallel          $pt_00 $pt_01 [expr 0.5*$ChainStay(DiameterSS)] left]

                    set polygon     [format "%s %s %s %s %s %s %s %s %s %s" \
                                            [lindex $vct_01 0] [lindex $vct_02 0] [lindex $vct_02 1] [lindex $vct_03 0] [lindex $vct_03 1] \
                                            [lindex $vct_04 1] [lindex $vct_04 0] [lindex $vct_05 1] [lindex $vct_05 0] [lindex $vct_06 0] ]
            project::setValue Result(Tubes/ChainStay)   polygon     $polygon
            
              # --- side View
            set l_00  0
            set l_01  [vectormath::length $pt_00 $pt_01]
            set l_02  [vectormath::length $pt_00 $pt_02]
            set l_03  [vectormath::length $pt_00 $pt_03]
            set l_04  [vectormath::length $pt_00 {0 0}]
            project::setValue Result(Tubes/ChainStay/Profile/xz) value  [list [format "%s,%s %s,%s %s,%s %s,%s %s,%s" \
                                                                                $l_00 [expr 0.5*$ChainStay(DiameterSS)] \
                                                                                $l_01 [expr 0.5*$ChainStay(Height)] \
                                                                                $l_02 [expr 0.5*$ChainStay(Height)] \
                                                                                $l_03 [expr 0.5*$ChainStay(HeigthBB)] \
                                                                                $l_04 [expr 0.5*$ChainStay(HeigthBB)]
                                                                              ]
                                                                        ]

    }

        
        #
        # --- set ChainStay for Rear Mockup --------
    proc bikeGeometry::get_ChainStay_RearMockup {} {
            variable BottomBracket
            variable RearWheel
            variable RearDrop
            variable ChainStay
            
            set type $project::Rendering(ChainStay)
            
            set Length(01)              [ expr 0.5 * $BottomBracket(inside) ]
            set Length(02)              [ expr 0.5 * $BottomBracket(width) ]
            set Length(03)              [ expr $Length(02) - $BottomBracket(OffsetCS_TopView) ]
            set Length(04)              [ expr 0.5 * $RearWheel(HubWidth) ]
            set Length(05)              [ expr 0.5 * $RearWheel(HubWidth) + $RearDrop(OffsetCS_TopView)]
              # puts "  -> \$Length(01)           $Length(01)"
              # puts "  -> \$Length(02)           $Length(02)"
              # puts "  -> \$Length(03)           $Length(03)"
              # puts "  -> \$Length(04)           $Length(04)"
              # puts "  -> \$Length(05)           $Length(05)"                                                               
              
            set Center(RearHub)         [ list [expr -1 * $RearWheel(DistanceBB)] 0 ]
            set Center(ChainStay_DO)    [ vectormath::addVector $Center(RearHub) [ list $RearDrop(OffsetCS)  [ expr $Length(04) + $RearDrop(OffsetCS_TopView)] ] ]
            set Center(00)              [ list [expr -1.0 * $Length(01)] $Length(03) ] 
            set Center(ChainStay_00)    [ vectormath::cathetusPoint $Center(ChainStay_DO) $Center(00) [expr 0.5 * $ChainStay(WidthBB)] opposite ]
              # puts "  -> \$Center(ChainStay_DO) $Center(ChainStay_DO)"
                        
            set p_CS_BB [list [expr -1.0 * $Length(01)] $Length(03)]                   
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
            set tubeProfile [bikeGeometry::tube::init_tubeProfile $profileDef]                                    
                # puts "  -> \$tubeProfile $tubeProfile"
      
      
                # -- tube centerline
            set S01_length     $project::FrameTubes(ChainStay/CenterLine/length_01)
            set S02_length     $project::FrameTubes(ChainStay/CenterLine/length_02)
            set S03_length     $project::FrameTubes(ChainStay/CenterLine/length_03)
            set S04_length     $project::FrameTubes(ChainStay/CenterLine/length_04)
            set tmp_length     [expr $S01_length + $S02_length + $S03_length + $S04_length]
            set max_length     $project::FrameTubes(ChainStay/Profile/completeLength)
            set S05_length     [expr $max_length - $tmp_length]
                #
                
            switch -exact $type {
              {straight} {
                    set S01_angle        0
                    set S02_angle        0
                    set S03_angle        0
                    set S04_angle        0
                    set S01_radius     320
                    set S02_radius     320
                    set S03_radius     320
                    set S04_radius     320
                    set cuttingLength  $project::FrameTubes(ChainStay/Profile/cuttingLength)
                  }
              default {
                      # -- bent                                                
                    set S01_angle      $project::FrameTubes(ChainStay/CenterLine/angle_01)
                    set S02_angle      $project::FrameTubes(ChainStay/CenterLine/angle_02)
                    set S03_angle      $project::FrameTubes(ChainStay/CenterLine/angle_03)
                    set S04_angle      $project::FrameTubes(ChainStay/CenterLine/angle_04)
                    set S01_radius     $project::FrameTubes(ChainStay/CenterLine/radius_01)
                    set S02_radius     $project::FrameTubes(ChainStay/CenterLine/radius_02)
                    set S03_radius     $project::FrameTubes(ChainStay/CenterLine/radius_03)
                    set S04_radius     $project::FrameTubes(ChainStay/CenterLine/radius_04)
                    set cuttingLength  $project::FrameTubes(ChainStay/Profile/cuttingLength)
                }
            }
              # --- check angle: S04_angle
                # puts "\n --checkAngles--------"
                # puts "     -> \$S04_length $S04_length"
                # puts "     -> \$S04_angle  $S04_angle"
                # puts "     -> \$S05_length $S05_length"
                # puts " ----------"
              # -- check S04_angle / S05_length
            if {$S05_length < 0} {
                set my_S04_angle  0
                set my_S05_length 5
            } else {
                set my_S04_angle  $S04_angle
                set my_S05_length $S05_length
            }
              # -- check cuttingLength
            if {$cuttingLength > $max_length} {
                set my_cuttingLength $max_length
            } else {
                set my_cuttingLength $cuttingLength
            }
              #
            set centerLineDef [list \
                        $S01_length $S02_length $S03_length $S04_length $my_S05_length \
                        $S01_angle  $S02_angle  $S03_angle  $my_S04_angle \
                        $S01_radius $S02_radius $S03_radius $S04_radius \
                        $my_cuttingLength]

                #
                # --- why -- set orient_select  left

                                    
                # -- get smooth centerLine
            set retValues        [bikeGeometry::tube::init_centerLine $centerLineDef] 
            set centerLineUnCut  [lindex $retValues 0]
            set ctrLines         [lindex $retValues 1]
            set centerLine       [lindex $retValues 2]
                 # puts "  -> \$centerLine $centerLine"
                 # puts "  -> \$centerLine [llength $centerLine]"
                 # exit
                # -- get shape of tube
            set outLineOrient    [bikeGeometry::tube::get_tubeShape    $centerLineUnCut  $tubeProfile left  ]
            set outLineLeft      [bikeGeometry::tube::get_tubeShape    $centerLine       $tubeProfile left  ]
            set outLineRight     [bikeGeometry::tube::get_tubeShape    $centerLine       $tubeProfile right ]
            set outLine          [appUtil::flatten_nestedList          $outLineLeft      $outLineRight]
                # -- move outline to centerLine
            set vct              [lindex $centerLine 0]
            set vct              [list [lindex $vct 0] [expr -1.0*[lindex $vct 1]]]
            set outLine          [vectormath::addVectorPointList       $vct $outLine]
                # puts "\n    -> \$outLineLeft   $outLineLeft"
                # puts "\n    -> \$outLineRight  $outLineRight"
                # puts "\n    -> \$outLine       $outLine "
            
            
                # get orientation of tube
            set length           [vectormath::length   $Center(ChainStay_DO) $p_CS_BB]
            set angle            [vectormath::dirAngle $Center(ChainStay_DO) $p_CS_BB]
                  # puts "  -> \$length $length"
                  # puts "  -> \$angle $angle"
            set pointIS          [bikeGeometry::tube::get_shapeInterSection $outLineOrient $length]       
            set angleIS          [vectormath::dirAngle {0 0} $pointIS]
            set angleRotation    [expr $angle - $angleIS]
                  # puts "  -> \$point_IS $point_IS"
                  # puts "  -> \$angleIS $angleIS"
                  # puts "  -> \$angleRotation $angleRotation"
                # -- prepare $outLine for exprot 
            set outLine          [vectormath::rotatePointList {0 0} $outLine $angleRotation]    
                # set outLine       [vectormath::addVectorPointList $Center(ChainStay_DO) $outLine]
                # $ext_cvName  create   polygon $outLine    -tags __Tube__  -fill lightgray
               
                # -- prepare $centerLineUnCut for export 
            set centerLineUnCut  [appUtil::flatten_nestedList $centerLineUnCut]
            set centerLineUnCut  [vectormath::rotatePointList {0 0} $centerLineUnCut $angleRotation]    
                # set centerLine    [vectormath::addVectorPointList $Center(ChainStay_DO) $centerLineUnCut]
                
                # -- prepare $centerLine for export 
            set centerLine       [appUtil::flatten_nestedList $centerLine]
            set centerLine       [vectormath::rotatePointList {0 0} $centerLine $angleRotation]    
                #set centerLine [vectormath::addVectorPointList $Center(ChainStay_DO) $centerLine]
                # $ext_cvName  create   line    $centerLine -tags __CenterLine__  -fill blue
             
                # -- prepare $ctrLines for export 
            set ctrLines         [appUtil::flatten_nestedList $ctrLines]
            set ctrLines         [vectormath::rotatePointList {0 0} $ctrLines $angleRotation]    
            
                  
            
                # -- format Values
            proc format_XcommaY {xyList} {
                set commaList {}
                foreach {x y} $xyList { append commaList "$x,$y "}
                return $commaList
            }
                # -- store Values
            project::setValue Result(Tubes/ChainStay/RearMockup/Start)            value  [list [lindex $Center(ChainStay_DO) 0],[lindex $Center(ChainStay_DO) 1]]
            project::setValue Result(Tubes/ChainStay/RearMockup)                polygon  $outLine
            project::setValue Result(Tubes/ChainStay/RearMockup/CtrLines)         value  [list [format_XcommaY $ctrLines]]
            project::setValue Result(Tubes/ChainStay/RearMockup/CenterLine)       value  [list [format_XcommaY $centerLine]]
            project::setValue Result(Tubes/ChainStay/RearMockup/CenterLineUnCut)  value  [list [format_XcommaY $centerLineUnCut]]
                # puts "\n===================\n -> \$outLine $outLine\n"

            
                # --- top View
            set l_00  0
            set l_01  [expr $l_00 + $profile_x01]
            set l_02  [expr $l_01 + $profile_x02]
            set l_03  [expr $l_02 + $profile_x03]
            set l_04  [expr $l_03 + 250]
            project::setValue Result(Tubes/ChainStay/Profile/xy) value  [list [format "%s,%s %s,%s %s,%s %s,%s" \
                                                                                $l_00 [expr 0.5 * $profile_y00] \
                                                                                $l_01 [expr 0.5 * $profile_y01] \
                                                                                $l_02 [expr 0.5 * $profile_y02] \
                                                                                $l_03 [expr 0.5 * $profile_y03] \
                                                                                $l_04 [expr 0.5 * $profile_y03] \
                                                                              ]
                                                                        ]
            
            
                # --- return values
            return
                # return [list $centerLine $outLine $ctrLines $centerLine ]
            
    }

        
        #
        # --- set HeadTube -------------------------
    proc bikeGeometry::get_HeadTube {} {
                #
            variable HeadTube
            variable HeadSet
            variable Steerer
                #
            set HeadTube(ForkRake)          $project::Component(Fork/Rake)
            set HeadTube(ForkHeight)        $project::Component(Fork/Height)
            set HeadTube(Diameter)          $project::FrameTubes(HeadTube/Diameter)
            set HeadTube(Length)            $project::FrameTubes(HeadTube/Length)
            set HeadTube(Angle)             $project::Custom(HeadTube/Angle)
            set HeadSet(Height_Bottom)      $project::Component(HeadSet/Height/Bottom)
                #
            set HeadTube(Direction)         [ vectormath::unifyVector     $Steerer(Fork)        $Steerer(Stem) ]
            set Steerer(Direction)          $HeadTube(Direction)
                #
            project::setValue Result(Tubes/Steerer/Direction)   direction   $HeadTube(Direction)
            project::setValue Result(Tubes/HeadTube/Direction)  direction   $HeadTube(Direction)
                #
            set HeadTube(Fork)              [ vectormath::addVector     $Steerer(Fork)  $HeadTube(Direction)    $HeadSet(Height_Bottom) ]
            set HeadTube(Stem)              [ vectormath::addVector     $HeadTube(Fork) $HeadTube(Direction)    $HeadTube(Length) ]
                #
            project::setValue Result(Tubes/HeadTube/Start)      position    $HeadTube(Fork)
            project::setValue Result(Tubes/HeadTube/End)        position    $HeadTube(Stem)
                #
            project::setValue Result(Tubes/HeadTube/CenterLine) value [list [format "%s,%s %s,%s" [lindex $HeadTube(Fork) 0] [lindex $HeadTube(Fork) 1] \
                                                                                                  [lindex $HeadTube(Stem) 0] [lindex $HeadTube(Stem) 1] ] ]
                #
                #
            set vct_01      [ vectormath::parallel          $HeadTube(Fork) $HeadTube(Stem) [expr 0.5*$HeadTube(Diameter)] ]
            set vct_ht      [ vectormath::parallel          $HeadTube(Stem) $HeadTube(Fork) [expr 0.5*$HeadTube(Diameter)] ]

            set polygon     [format "%s %s %s %s" \
                                    [lindex $vct_01 0] [lindex $vct_01 1] \
                                    [lindex $vct_ht 0] [lindex $vct_ht 1] ]
                #                           
            project::setValue Result(Tubes/HeadTube)            polygon     $polygon
                # --- side View
            project::setValue Result(Tubes/HeadTube/Profile/xz) value   [list [format "%s,%s %s,%s" 0 [expr 0.5*$HeadTube(Diameter)]  $HeadTube(Length) [expr 0.5*$HeadTube(Diameter)]]]
                # --- top View
            project::setValue Result(Tubes/HeadTube/Profile/xy) value   [list [format "%s,%s %s,%s" 0 [expr 0.5*$HeadTube(Diameter)]  $HeadTube(Length) [expr 0.5*$HeadTube(Diameter)]]]
                #
    }


        #
        # --- set TopTube -------------------------
    proc bikeGeometry::get_TopTube_SeatTube {} {
            variable TopTube
            variable HeadTube
            variable SeatTube
            variable DownTube
            variable SeatPost
            variable Steerer
                #
            set SeatTube(DiameterBB)        $project::FrameTubes(SeatTube/DiameterBB)
            set SeatTube(DiameterTT)        $project::FrameTubes(SeatTube/DiameterTT)
            set SeatTube(TaperLength)       $project::FrameTubes(SeatTube/TaperLength)
            set SeatTube(Extension)         $project::Custom(SeatTube/Extension)
                #
            set TopTube(DiameterHT)         $project::FrameTubes(TopTube/DiameterHT)
            set TopTube(DiameterST)         $project::FrameTubes(TopTube/DiameterST)
            set TopTube(TaperLength)        $project::FrameTubes(TopTube/TaperLength)
            set TopTube(OffsetHT)           $project::Custom(TopTube/OffsetHT)
            set TopTube(Angle)              $project::Custom(TopTube/Angle)
                #

            set vct_st      [ vectormath::parallel          $SeatTube(DownTube) $SeatPost(SeatTube) [expr 0.5*$SeatTube(DiameterTT)] ]
                    # set vct_st    [ vectormath::parallel          $SeatTube(BottomBracket) $SeatPost(SeatTube) [expr 0.5*$SeatTube(DiameterTT)] ]

            project::setValue Result(Tubes/SeatTube/Direction)    direction     $SeatTube(Direction)     ;# direction vector of SeatTube

                    set vct_ht      [ vectormath::parallel          $HeadTube(Stem) $HeadTube(Fork) [expr 0.5*$HeadTube(Diameter)] ]
                    set pt_00       [lindex $vct_ht 0]
                    set pt_01       [ vectormath::addVector         $pt_00 $HeadTube(Direction) [expr -1 * $TopTube(OffsetHT)] ]    ;# top intersection TopTube/HeadTube

                    set TopTube(Direction)            [ vectormath::rotatePoint {0 0} {-1 0} $TopTube(Angle) ]    ;# direction vector of TopTube
            project::setValue Result(Tubes/TopTube/Direction)    direction     [ vectormath::rotatePoint {0 0} {-1 0} $TopTube(Angle) ]    ;# direction vector of TopTube

                    set pt_02       [ vectormath::intersectPoint    $pt_01 [vectormath::addVector $pt_01  $TopTube(Direction)]  {0 0} $SeatPost(SeatTube) ]    ;# top intersection TopTube/HeadTube
                    set vct_00      [ vectormath::parallel          $pt_01 $pt_02 [expr 0.5 * $TopTube(DiameterHT)] left]    ;# TopTube centerline Vector
                    set pt_10       [ vectormath::intersectPoint    [lindex $vct_00 0] [lindex $vct_00 1]  $Steerer(Fork) $Steerer(Stem)  ]
                    set length      [ vectormath::length            $pt_10 [lindex $vct_00 1] ]
                    set pt_11       [ vectormath::addVector         $pt_10  $TopTube(Direction)  [expr 0.5*($length - $TopTube(TaperLength)) ] ]
                    set pt_12       [ vectormath::addVector         $pt_11  $TopTube(Direction)  $TopTube(TaperLength) ]
                    set pt_13       [ vectormath::intersectPoint    [lindex $vct_00 0] [lindex $vct_00 1]  {0 0} $SeatPost(SeatTube) ]
                    set vct_10      [ vectormath::parallel          $pt_10 $pt_11 [expr 0.5*$TopTube(DiameterHT)] right ]
                    set vct_11      [ vectormath::parallel          $pt_10 $pt_11 [expr 0.5*$TopTube(DiameterHT)] left  ]
                    set vct_21      [ vectormath::parallel          $pt_12 $pt_13 [expr 0.5*$TopTube(DiameterST)] right ]
                    set vct_22      [ vectormath::parallel          $pt_12 $pt_13 [expr 0.5*$TopTube(DiameterST)] left  ]
                    set pt_04       [ vectormath::intersectPoint    [lindex $vct_ht 0] [lindex $vct_ht 1]  [lindex $vct_11 0] [lindex $vct_11 1] ]
                    set pt_st       [ vectormath::intersectPoint    [lindex $vct_st 0] [lindex $vct_st 1]  [lindex $vct_21 0] [lindex $vct_21 1] ]
                    set pt_22       [ vectormath::intersectPoint    [lindex $vct_st 0] [lindex $vct_st 1]  [lindex $vct_22 0] [lindex $vct_22 1] ]

                set TopTube(HeadTube)            $pt_10
                set TopTube(SeatTube)            [ vectormath::intersectPoint [lindex $vct_00 0] [lindex $vct_00 1] $SeatTube(BottomBracket) $SeatPost(SeatTube) ]
            project::setValue Result(Tubes/TopTube/Start)          position     $TopTube(SeatTube)
            project::setValue Result(Tubes/TopTube/End)            position     $TopTube(HeadTube)
                        #
            project::setValue Result(Tubes/TopTube/CenterLine)  value [list [format "%s,%s %s,%s" [lindex $TopTube(SeatTube) 0] [lindex $TopTube(SeatTube) 1] \
                                                                                                  [lindex $TopTube(HeadTube) 0] [lindex $TopTube(HeadTube) 1] ] ]
                        #
                    set is_tt_ht    [ tube_intersection    $TopTube(DiameterHT) $TopTube(Direction)  $HeadTube(Diameter)    $HeadTube(Direction)  $TopTube(HeadTube) right]
                    set is_tt_st    [ tube_intersection    $TopTube(DiameterST) $TopTube(Direction)  $SeatTube(DiameterTT)  $SeatTube(Direction)  $TopTube(SeatTube) left ]

                    set polygon     [ project::flatten_nestedList $is_tt_ht]
                    set polygon     [ lappend polygon [lindex $vct_10 1] [lindex $vct_21 0]]
                    set polygon     [ lappend polygon [project::flatten_nestedList $is_tt_st]]
                    set polygon     [ lappend polygon [lindex $vct_22 0] [lindex $vct_11 1]]
            project::setValue Result(Tubes/TopTube)                 polygon     [project::flatten_nestedList $polygon]
            
                        # 
                    set pt_00       [ vectormath::intersectPerp     $SeatTube(BottomBracket) $SeatPost(SeatTube)   $pt_st ]
                    set pt_01       [ vectormath::addVector         $pt_00   $SeatTube(Direction)  $SeatTube(Extension) ]
                set SeatTube(TopTube)        $pt_01
            project::setValue Result(Tubes/SeatTube/End)        position    $SeatTube(TopTube)
            project::setValue Result(Tubes/SeatTube/CenterLine) value [list [format "%s,%s %s,%s" [lindex $SeatTube(BottomBracket) 0] [lindex $SeatTube(BottomBracket) 1] \
                                                                                                  [lindex $SeatTube(TopTube)       0] [lindex $SeatTube(TopTube)       1] ] ]
                
                # --- get length
                    set l_00  0
                    set l_01  [expr $l_00 + [ vectormath::length $pt_10 $pt_11 ]]
                    set l_02  [expr $l_01 + [ vectormath::length $pt_11 $pt_12 ]]
                    set l_03  [expr $l_02 + [ vectormath::length $pt_12 $pt_13 ]]
                # --- side View
            project::setValue Result(Tubes/TopTube/Profile/xz) value   \
                                        [list [format "%s,%s %s,%s %s,%s %s,%s" \
                                                $l_00  [expr 0.5*$TopTube(DiameterHT)] \
                                                $l_01  [expr 0.5*$TopTube(DiameterHT)] \
                                                $l_02  [expr 0.5*$TopTube(DiameterST)] \
                                                $l_03  [expr 0.5*$TopTube(DiameterST)] \
                                            ]
                                        ]
              # --- top View
            project::setValue Result(Tubes/TopTube/Profile/xy) value [list [project::getValue Result(Tubes/TopTube/Profile/xz) value]]
              #


                        #
                    # set SeatTube(Direction)        [ vectormath::unifyVector $SeatTube(DownTube) $SeatPost(SeatTube) ]
                        #
            # 0.65 -- project::setValue Result(Tubes/SeatTube/Start)        position    $pt_is
                        #
                    set pt_01       $SeatTube(TopTube)
                    
                    set length      [ vectormath::length            $SeatTube(BottomBracket) $pt_01 ]
                    set pt_10       $SeatTube(BottomBracket)
                    set pt_11       [ vectormath::addVector         $pt_10  $SeatTube(Direction)  [expr 0.5*($length - $SeatTube(TaperLength)) ] ]
                    set pt_12       [ vectormath::addVector         $pt_11  $SeatTube(Direction)  $SeatTube(TaperLength) ]
                    set pt_13       $pt_01
                    set vct_10      [ vectormath::parallel          $pt_10 $pt_11 [expr 0.5*$SeatTube(DiameterBB)] right ]
                    set vct_11      [ vectormath::parallel          $pt_10 $pt_11 [expr 0.5*$SeatTube(DiameterBB)] left  ]
                    set vct_21      [ vectormath::parallel          $pt_12 $pt_13 [expr 0.5*$SeatTube(DiameterTT)] right ]
                    set vct_22      [ vectormath::parallel          $pt_12 $pt_13 [expr 0.5*$SeatTube(DiameterTT)] left  ]
                        #
            project::setValue Result(Tubes/SeatTube/Start)      position    $SeatTube(BottomBracket)
                        
                        #
                    set is_st_dt    [ tube_intersection    $SeatTube(DiameterBB) $SeatTube(Direction)  $DownTube(DiameterBB)  $DownTube(Direction)  $SeatTube(DownTube) right ]
                        #
                    set polygon     [ list  [lindex $vct_10 1]  [lindex $vct_21 0] \
                                            [lindex $vct_21 1]  [lindex $vct_22 1] \
                                            [lindex $vct_22 0]  [lindex $vct_11 1] ]
                    lappend polygon $is_st_dt
                        #
            project::setValue Result(Tubes/SeatTube)                polygon     [project::flatten_nestedList $polygon]            
                        #
                        
                        # --- get length
            set l_00  0
            set l_01  [expr $l_00 + [ vectormath::length $pt_10 $pt_11 ]]
            set l_02  [expr $l_01 + [ vectormath::length $pt_11 $pt_12 ]]
            set l_03  [expr $l_02 + [ vectormath::length $pt_12 $pt_13 ]]
                        # --- side View
            project::setValue Result(Tubes/SeatTube/Profile/xz) value   \
                                        [list [format "%s,%s %s,%s %s,%s %s,%s" \
                                                $l_00  [expr 0.5*$SeatTube(DiameterBB)] \
                                                $l_01  [expr 0.5*$SeatTube(DiameterBB)] \
                                                $l_02  [expr 0.5*$SeatTube(DiameterTT)] \
                                                $l_03  [expr 0.5*$SeatTube(DiameterTT)] \
                                            ]
                                        ]
                        # --- top View
            project::setValue Result(Tubes/SeatTube/Profile/xy) value [list [project::getValue Result(Tubes/SeatTube/Profile/xz) value]]
                        #
         
    }


        #
        # --- set DownTube SeatTube ------------------------
    proc bikeGeometry::get_DownTube_SeatTube {} {
                #
            variable HeadTube
            variable DownTube
            variable SeatTube
            variable SeatPost
            variable Steerer
                #
            set DownTube(DiameterBB)        $project::FrameTubes(DownTube/DiameterBB)
            set DownTube(DiameterHT)        $project::FrameTubes(DownTube/DiameterHT)
            set DownTube(TaperLength)       $project::FrameTubes(DownTube/TaperLength)
            set DownTube(OffsetHT)          $project::Custom(DownTube/OffsetHT)
            set DownTube(OffsetBB)          $project::Custom(DownTube/OffsetBB)           
                #          
                    #
                set vct_ht      [ vectormath::parallel          $HeadTube(Stem) $HeadTube(Fork) [expr 0.5*$HeadTube(Diameter)] ]
                set pt_00       [split [ project::getValue      Result(Tubes/HeadTube/Polygon)    polygon 3 ] , ]
                set pt_01       [ vectormath::addVector         $pt_00 $HeadTube(Direction) $DownTube(OffsetHT) ]                            ;# bottom intersection DownTube/HeadTube
                set pt_02       [ vectormath::cathetusPoint     {0 0}  $pt_01 [expr 0.5 * $DownTube(DiameterHT) - $DownTube(OffsetBB) ]]    ;# DownTube lower Vector
                set vct_cl      [ vectormath::parallel          $pt_02 $pt_01 [expr 0.5 * $DownTube(DiameterHT)] left]                        ;# DownTube centerline Vector
                set pt_is       [ vectormath::intersectPoint    [lindex $vct_cl 0] [lindex $vct_cl 1]  $SeatTube(BottomBracket)    $SeatPost(SeatTube) ]
                    #
                set SeatTube(DownTube)          $pt_is
                    #
                set DownTube(Direction)     [ vectormath::unifyVector       [lindex $vct_cl 0] [lindex $vct_cl 1] ]
                set DownTube(HeadTube)      [ vectormath::intersectPoint    [lindex $vct_cl 0] [lindex $vct_cl 1]  $Steerer(Fork)     $Steerer(Stem) ]
                set DownTube(BottomBracket) [lindex $vct_cl 0]
                    #
            project::setValue Result(Tubes/DownTube/Direction)  direction   $DownTube(Direction)
            project::setValue Result(Tubes/DownTube/Start)      position    $DownTube(BottomBracket)
            project::setValue Result(Tubes/DownTube/End)        position    $DownTube(HeadTube)
                        #
            project::setValue Result(Tubes/DownTube/CenterLine) value [list [format "%s,%s %s,%s" [lindex $DownTube(BottomBracket) 0] [lindex $DownTube(BottomBracket) 1] \
                                                                                              [lindex $DownTube(HeadTube)      0] [lindex $DownTube(HeadTube)      1] ] ]
                    #
                set vct_02      [ vectormath::parallel          [lindex $vct_cl 0] [lindex $vct_cl 1] $DownTube(DiameterHT) left]   ;# DownTube upper Vector HT
                set pt_04       [ vectormath::intersectPoint    [lindex $vct_02 0] [lindex $vct_02 1] \
                                                                [lindex $vct_ht 0] [lindex $vct_ht 1] ] ;# top intersection DownTube/HeadTube
                set length      [ vectormath::length            [lindex $vct_02 0] $pt_04 ]
                set pt_10       [ lindex $vct_cl 0]             ;# BB-Position
                set pt_11       [ vectormath::addVector         $pt_10 $DownTube(Direction) [expr 0.5*($length - $DownTube(TaperLength) )] ]
                set pt_12       [ vectormath::addVector         $pt_11 $DownTube(Direction) $DownTube(TaperLength) ]
                set pt_13       [ lindex $vct_cl 1]             ;# HT-Position
                set vct_10      [ vectormath::parallel          $pt_10 $pt_11 [expr 0.5*$DownTube(DiameterBB)] right ]
                set vct_11      [ vectormath::parallel          $pt_10 $pt_11 [expr 0.5*$DownTube(DiameterBB)] left  ]
                set vct_21      [ vectormath::parallel          $pt_12 $pt_13 [expr 0.5*$DownTube(DiameterHT)] right ]
                set vct_22      [ vectormath::parallel          $pt_12 $pt_13 [expr 0.5*$DownTube(DiameterHT)] left  ]
                    #
                set pt_ht       [ vectormath::intersectPoint    [lindex $vct_cl 0] [lindex $vct_cl 1]  $HeadTube(Stem) $HeadTube(Fork) ]
                    #
                set dir         [ vectormath::addVector {0 0} $DownTube(Direction) -1]
                    #
                set is_dt_ht    [ tube_intersection $DownTube(DiameterHT) $dir  $HeadTube(Diameter)     $HeadTube(Direction)  $DownTube(HeadTube) ]
                    #
                set polygon     [ list            [lindex $vct_10 1] [lindex $vct_21 0]]
                lappend polygon [ project::flatten_nestedList $is_dt_ht]
                lappend polygon [ lindex $vct_22 0] [lindex $vct_11 1]
                lappend polygon [ lindex $vct_11 0] [ lindex $vct_10 0]
                    #
            project::setValue Result(Tubes/DownTube)            polygon     [project::flatten_nestedList $polygon]
                    #
                    
                    # --- get length
                set l_00  0
                set l_01  [expr $l_00 + [ vectormath::length $pt_10 $pt_11 ]]
                set l_02  [expr $l_01 + [ vectormath::length $pt_11 $pt_12 ]]
                set l_03  [expr $l_02 + [ vectormath::length $pt_12 $pt_ht ]]
                    #
                
                # --- side View
            project::setValue Result(Tubes/DownTube/Profile/xz) value   \
                                        [list [format "%s,%s %s,%s %s,%s %s,%s" \
                                                $l_00  [expr 0.5*$DownTube(DiameterBB)] \
                                                $l_01  [expr 0.5*$DownTube(DiameterBB)] \
                                                $l_02  [expr 0.5*$DownTube(DiameterHT)] \
                                                $l_03  [expr 0.5*$DownTube(DiameterHT)] \
                                            ]
                                        ]
                # --- top View
            project::setValue Result(Tubes/DownTube/Profile/xy) value [list [project::getValue Result(Tubes/DownTube/Profile/xz) value]]
                #
                #
            return
                #
    }


        #
        # --- set SeatStay ------------------------
    proc bikeGeometry::get_SeatStay {} {
                #
            variable SeatStay
            variable ChainStay
            variable TopTube
            variable SeatTube
            variable RearWheel
            variable RearDrop
                #
            set SeatStay(DiameterST)        $project::FrameTubes(SeatStay/DiameterST)
            set SeatStay(DiameterCS)        $project::FrameTubes(SeatStay/DiameterCS)
            set SeatStay(TaperLength)       $project::FrameTubes(SeatStay/TaperLength)
            set SeatStay(OffsetTT)          $project::Custom(SeatStay/OffsetTT) 
                #

                    set pt_00       [ vectormath::addVector     $TopTube(SeatTube)  $SeatTube(Direction)  $SeatStay(OffsetTT) ] ; # intersection seatstay / seattube
                    set pt_01       [ lindex [ vectormath::parallel     $RearWheel(Position)  $pt_00   $RearDrop(OffsetSSPerp) ] 0 ]
                        #
                    set SeatStay(Direction)     [ vectormath::unifyVector $pt_01 $pt_00 ]
            project::setValue Result(Tubes/SeatStay/Direction)  direction   $SeatStay(Direction)    ;# direction vector of SeatStay
                        #
                    set pt_10       [ vectormath::addVector     $pt_01  $SeatStay(Direction)  $RearDrop(OffsetSS) ]
                        #
                        # -- exception if Tube is shorter than taper length
                        set tube_length          [ vectormath::length $pt_10 $pt_00 ]
                        if { [expr $tube_length - $SeatStay(TaperLength) -50] < 0 } {
                            # puts "            ... exception:  SeatStay  TaperLength ... $tube_length / $SeatStay(TaperLength)"
                            set taper_length    [ expr $tube_length -50 ]
                            # puts "                         -> $taper_length"
                        } else {
                            set taper_length    $SeatStay(TaperLength)
                        }
                        #
                    set pt_11       [ vectormath::addVector        $pt_10  $SeatStay(Direction)  $taper_length ]
                    set pt_12       $pt_00
                    set vct_10      [ vectormath::parallel $pt_10 $pt_11 [expr 0.5*$SeatStay(DiameterCS)] ]
                    set vct_11      [ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$SeatStay(DiameterST)] ]
                    set vct_12      [ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$SeatStay(DiameterST)] left]
                    set vct_13      [ vectormath::parallel $pt_10 $pt_11 [expr 0.5*$SeatStay(DiameterCS)] left]
                        #
                set SeatStay(SeatTube)      $pt_00
                set SeatStay(RearWheel)     $pt_10
            project::setValue Result(Tubes/SeatStay/Start)      position    $SeatStay(RearWheel)
            project::setValue Result(Tubes/SeatStay/End)        position    $SeatStay(SeatTube)
                        #
            project::setValue Result(Tubes/SeatStay/CenterLine) value [list [format "%s,%s %s,%s" [lindex $SeatStay(RearWheel) 0] [lindex $SeatStay(RearWheel) 1] \
                                                                                                  [lindex $SeatStay(SeatTube)  0] [lindex $SeatStay(SeatTube)  1] ] ]
                        #
                    set dir         [ vectormath::addVector {0 0} $SeatStay(Direction) -1]
                    set offset      [ expr 0.5 * ($SeatTube(DiameterTT) - $SeatStay(DiameterST)) ]
                    set is_ss_st    [ tube_intersection $SeatStay(DiameterST) $dir  $SeatTube(DiameterTT)      $SeatTube(Direction)  $SeatStay(SeatTube)  right $offset]
                        #
                set SeatStay(debug)             $is_ss_st
                        #
                    set polygon     [ project::flatten_nestedList  $is_ss_st ]
                    set polygon     [ lappend polygon [lindex $vct_12 0] [lindex $vct_13 0] \
                                                      [lindex $vct_10 0] [lindex $vct_11 0] ]
            project::setValue Result(Tubes/SeatStay)          polygon     [project::flatten_nestedList $polygon]
                        #
                                    
                        # --- get length
            set l_00  0
            set l_01  [expr $l_00 + [ vectormath::length $pt_10 $pt_11 ]]
            set l_02  [expr $l_01 + [ vectormath::length $pt_11 $pt_12 ]]
                        # --- side View
            project::setValue Result(Tubes/SeatStay/Profile/xz) value   \
                                        [list [format "%s,%s %s,%s %s,%s" \
                                                $l_00  [expr 0.5*$SeatStay(DiameterCS)] \
                                                $l_01  [expr 0.5*$SeatStay(DiameterST)] \
                                                $l_02  [expr 0.5*$SeatStay(DiameterST)] \
                                            ]
                                        ]
                        # --- top View
            project::setValue Result(Tubes/SeatStay/Profile/xy) value [list [project::getValue Result(Tubes/SeatStay/Profile/xz) value]]
                        #

                        #
                        # --- set SeatStay / ChainStay - Intersection
                    set ChainStay(SeatStay_IS)      [ vectormath::intersectPoint $SeatStay(SeatTube) $SeatStay(RearWheel) $ChainStay(BottomBracket) $ChainStay(RearWheel) ];# intersection of ChainStay and SeatStay centerlines
            project::setValue Result(Tubes/ChainStay/SeatStay_IS)   position    $ChainStay(SeatStay_IS) ;# Point on the Ground perp. to BB
                        #
    }


        #
        # --- set TubeMiter -----------------
    proc bikeGeometry::get_TubeMiter {} {
            variable HeadTube
            variable SeatTube
            variable SeatStay
            variable TopTube
            variable DownTube
            variable TubeMiter
            variable BottomBracket

                    set dir         [ vectormath::scalePointList {0 0} [ bikeGeometry::get_Object HeadTube direction ] -1.0 ]
                        # puts " .. \$dir $dir"
                                              # tube_miter  { diameter              direction              diameter_isect           direction_isect         isectionPoint         {side {right}} {offset {0}}  {startAngle {0}}}
            set TubeMiter(TopTube_Head)       [ tube_miter    $TopTube(DiameterHT)  $TopTube(Direction)    $HeadTube(Diameter)      $HeadTube(Direction)    $TopTube(HeadTube)  ]
            set TubeMiter(TopTube_Seat)       [ tube_miter    $TopTube(DiameterST)  $TopTube(Direction)    $SeatTube(DiameterTT)    $dir                    $TopTube(SeatTube)  ]
            
            set TubeMiter(DownTube_Head)      [ tube_miter    $DownTube(DiameterHT) $DownTube(Direction)   $HeadTube(Diameter)      $HeadTube(Direction)    $DownTube(HeadTube)      right    0    0  opposite]
            set TubeMiter(DownTube_Seat)      [ tube_miter    $DownTube(DiameterBB) $DownTube(Direction)   $SeatTube(DiameterBB)    $SeatTube(Direction)    $SeatTube(DownTube)      ]
            set TubeMiter(DownTube_BB_out)    [ tube_miter    $DownTube(DiameterBB) {1 0}                  $BottomBracket(outside)  {0 1}                   {0 0}                    right    0   90  opposite]
            set TubeMiter(DownTube_BB_in)     [ tube_miter    $DownTube(DiameterBB) {1 0}                  $BottomBracket(inside)   {0 1}                   {0 0}                    right    0   90  opposite]
            
            set TubeMiter(SeatTube_Down)      [ tube_miter    $SeatTube(DiameterBB) $SeatTube(Direction)   $DownTube(DiameterBB)    $DownTube(Direction)    $SeatTube(DownTube)      ]
            set TubeMiter(SeatTube_BB_out)    [ tube_miter    $SeatTube(DiameterBB) {1 0}                  $BottomBracket(outside)  {0 1}                   {0 0}                    right    0   90  opposite]
            set TubeMiter(SeatTube_BB_in)     [ tube_miter    $SeatTube(DiameterBB) {1 0}                  $BottomBracket(inside)   {0 1}                   {0 0}                    right    0   90  opposite]
                    
                    set offset      [ expr 0.5 * ($SeatTube(DiameterTT) - $SeatStay(DiameterST)) ]
                    set dir         [ vectormath::scalePointList {0 0} [ bikeGeometry::get_Object SeatStay direction ] -1.0 ]
                        # puts " .. \$dir $dir"
            set TubeMiter(SeatStay_01)        [ tube_miter    $SeatStay(DiameterST) $dir  $SeatTube(DiameterTT)      $SeatTube(Direction)  $SeatStay(SeatTube)  right -$offset]
            set TubeMiter(SeatStay_02)        [ tube_miter    $SeatStay(DiameterST) $dir  $SeatTube(DiameterTT)      $SeatTube(Direction)  $SeatStay(SeatTube)  right +$offset]
            set TubeMiter(Reference)             { -50 0  50 0  50 10  -50 10 }

            project::setValue Result(TubeMiter/TopTube_Head)        polygon     [ project::flatten_nestedList $TubeMiter(TopTube_Head)  ]
            project::setValue Result(TubeMiter/TopTube_Seat)        polygon     [ project::flatten_nestedList $TubeMiter(TopTube_Seat)  ]
            
            project::setValue Result(TubeMiter/DownTube_Head)       polygon     [ project::flatten_nestedList $TubeMiter(DownTube_Head) ]
            project::setValue Result(TubeMiter/DownTube_Seat)       polygon     [ project::flatten_nestedList $TubeMiter(DownTube_Seat) ]
            project::setValue Result(TubeMiter/DownTube_BB_out)     polygon     [ project::flatten_nestedList $TubeMiter(DownTube_BB_out) ]
            project::setValue Result(TubeMiter/DownTube_BB_in)      polygon     [ project::flatten_nestedList $TubeMiter(DownTube_BB_in)  ]
            
            project::setValue Result(TubeMiter/SeatTube_Down)       polygon     [ project::flatten_nestedList $TubeMiter(SeatTube_Down) ]
            project::setValue Result(TubeMiter/SeatTube_BB_out)     polygon     [ project::flatten_nestedList $TubeMiter(SeatTube_BB_out) ]
            project::setValue Result(TubeMiter/SeatTube_BB_in)      polygon     [ project::flatten_nestedList $TubeMiter(SeatTube_BB_in)  ]
            
            project::setValue Result(TubeMiter/SeatStay_01)         polygon     [ project::flatten_nestedList $TubeMiter(SeatStay_01)   ]
            project::setValue Result(TubeMiter/SeatStay_02)         polygon     [ project::flatten_nestedList $TubeMiter(SeatStay_02)   ]
            
            project::setValue Result(TubeMiter/Reference)           polygon     [ project::flatten_nestedList $TubeMiter(Reference)     ]
    }



    #-------------------------------------------------------------------------
        #  create TubeIntersection
        #
        #         \     \ direction_isect
        #   -------\     \     \
        #     direction   \     \
        #     - - - - - - -o- -  \
        #                   \ isectionPoint
        #   -----------\     \     \
        #   diameter    \     \     \
        #                \     \     \ diameter_isect
        #
    proc bikeGeometry::tube_intersection { diameter direction diameter_isect direction_isect isectionPoint {side {right}} {offset {0}} } {

            set direction_angle     [vectormath::angle {0 1}    {0 0}    $direction ]
            set intersection_angle     [vectormath::angle $direction {0 0} $direction_isect]
                # puts [format "   %2.f %2.f" $direction_angle $intersection_angle]
            set coordList {}
            set radius          [expr 0.5*$diameter]
            set radius_isect    [expr 0.5*$diameter_isect]
            foreach angle {90 60 30 10 0 -10 -30 -60 -90} {
                set rad_Angle   [vectormath::rad $angle]
                set r1_x        [expr $radius*cos([vectormath::rad [expr 90+$angle]]) ]
                set r1_y        [expr $radius*sin([expr 1.0*(90-$angle)*$vectormath::CONST_PI/180]) + $offset]
                if {[expr abs($radius_isect)] >= [expr abs($r1_y)]} {
                    set cut_perp    [expr sqrt(pow($radius_isect,2) - pow($r1_y,2)) ]
                } else {
                    set cut_perp     0
                }
                set cut_angle   [expr $cut_perp / sin([vectormath::rad $intersection_angle]) ]
                set cut_angOff  [expr $r1_x / tan([vectormath::rad $intersection_angle]) ]
                set cut_eff     [expr $cut_angle + $cut_angOff ]
                set xy  [list $r1_x $cut_eff]
                if {$side != {right}}  {set xy  [vectormath::rotatePoint {0 0} $xy  180]}
                set xy  [vectormath::rotatePoint {0 0} $xy $direction_angle]
                set xy  [vectormath::addVectorPointList $isectionPoint $xy]
                set coordList [lappend coordList [lindex $xy 0] [lindex $xy 1]]
            }

            return $coordList
    }


    #-------------------------------------------------------------------------
        #  create TubeMiter
        #
        #         \     \ direction_isect
        #   -------\     \     \
        #     direction   \     \
        #     - - - - - - -o- -  \
        #                   \ isectionPoint
        #   -----------\     \     \
        #   diameter    \     \     \
        #                \     \     \ diameter_isect
        #
    proc bikeGeometry::tube_miter { diameter direction diameter_isect direction_isect isectionPoint {side {right}} {offset {0}}  {startAngle {0}}  {opposite {no}}} {

              # puts " intersection_angle     \[vectormath::angle $direction {0 0} $direction_isect\]"
            set intersection_angle     [vectormath::angle $direction {0 0} $direction_isect]

                # puts ""
                # puts "   -------------------------------"
                # puts "    tube_miter"
                # puts "       diameter:        $diameter    "
                # puts "       direction:       $direction    "
                # puts "       diameter:        $diameter    "
                # puts "       diameter_isect:  $diameter_isect    "
                # puts "       direction_isect: $direction_isect    "
                # puts "       isectionPoint:   $isectionPoint    "
                # puts "       side:            $side"
                # puts "       offset:          $offset"
                # puts "       opposite:        $opposite"
                # puts "       -> intersection_angle   $intersection_angle"
                # puts [format " -> tube_miter \n   %2.f %2.f" $direction_angle $intersection_angle]

            if {$opposite != {no} } {
                    set intersection_angle    [expr 180 - $intersection_angle]
                        # puts "       -> intersection_angle $intersection_angle"
            }

            set radius          [expr 0.5*$diameter]
            set radius_isect    [expr 0.5*$diameter_isect]
            set angle         -180
                # set angle         [expr -180 - $startAngle]
            set loops       36
            set perimeter   [expr $radius * [vectormath::rad 360] ]
            set coordList   {}
                # while {$angle <= [expr 180 - $startAngle]}
                # puts " -> $diameter $direction $diameter_isect $direction_isect $isectionPoint"
            while {$angle <= 180} {
                      # puts "  -> \$angle $angle"
                    set rad_Angle   [vectormath::rad [expr $angle -$startAngle]]
                    set x [expr $diameter*[vectormath::rad 180]*$angle/360 ]

                    set h [expr $offset + $radius*sin($rad_Angle)]
                    set b [expr $diameter*0.5*cos($rad_Angle)]

                    if {[expr abs($radius_isect)] >= [expr abs($h)]} {
                        set l [expr sqrt(pow($radius_isect,2) - pow($h,2))]
                    } else {
                        set l 0
                    }
                    set v [expr $b/tan([vectormath::rad $intersection_angle])]

                        # puts [format "%.2f  -  %+.2f / %+.2f  -  %+.2f / %+.2f"   $angle  $h  $b  $l  $v ]
                    set y $h
                    set y [expr $l+$v]
                    set xy [list $x $y]
                    if {$side == {right}}  {set xy    [vectormath::rotatePoint {0 0} $xy  180]}
                    lappend coordList [lindex $xy 0] [lindex $xy 1]
                    set angle       [expr $angle + 360 / $loops]
            }
            lappend coordList [expr -0.5*$perimeter]  -70 
            lappend coordList [expr  0.5*$perimeter]  -70
            return $coordList
    }

 

    
    
 



 