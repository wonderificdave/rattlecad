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
    proc bikeGeometry::create_ChainStay {} {
                #
            variable CenterLine
            variable Direction
            variable Position
            variable Polygon
            variable Lugs
            variable Config
                #
            variable RearDropout
            variable ChainStay
            variable RearWheel
                #
            variable Result
                #
            set vct_angle   [ vectormath::dirAngle      $Position(RearWheel)  {0 0}]
            set vct_xy      [ list $RearDropout(OffsetCS) [expr -1.0 * $RearDropout(OffsetCSPerp)]]
                # set vct_xyAngle [ vectormath::dirAngle {0 0} $vct_xy]
                # puts "   get_ChainStay: ... \$Config(RearDropoutOrient) $Config(RearDropoutOrient)"
            switch -exact  $Config(RearDropoutOrient) {
                ChainStay  -
                Chainstay  { set do_angle         [expr $vct_angle - $RearDropout(RotationOffset)]}
                horizontal { set do_angle         [expr 360 - $RearDropout(RotationOffset)]
                       }
                default    {exit}
            }
                # 
            set Direction(RearDropout)  [ vectormath::rotatePoint   {0 0} {1 0} $do_angle]
                #
                # set do_angle    [ expr $vct_angle - $RearDropout(RotationOffset)]
            set vct_CS      [ vectormath::rotatePoint   {0 0}  $vct_xy  $do_angle]
            set pt_00       [ vectormath::addVector     $Position(RearWheel)  $vct_CS]
                #
            set Direction(ChainStay)    [ vectormath::unifyVector $pt_00 {0 0}]
                #
            set CenterLine(ChainStay)   [list [format "%s,%s %s,%s" [lindex $pt_00 0] [lindex $pt_00 1]  0 0 ] ]


                # -- position of Rear Derailleur Mount
            set vct_xy      [ list [expr -1 * $RearDropout(Derailleur_x)]  [expr -1 * $RearDropout(Derailleur_y)]]
            set vct_mount   [ vectormath::rotatePoint   {0 0}  $vct_xy  $do_angle]
            set pt_mount    [ vectormath::addVector     $Position(RearWheel)  $vct_mount]
            set Position(RearDerailleur)    $pt_mount


                        # -- exception if Tube is shorter than taper length
                    set tube_length         [ vectormath::length {0 0} $pt_00 ]
                        if { [expr $tube_length - $ChainStay(TaperLength) -110] < 0 } {
                            # puts "            ... exception:  ChainStay TaperLength ... $tube_length / $ChainStay(TaperLength)"
                            set taper_length    [ expr $tube_length -110 ]
                            # puts "                         -> $taper_length"
                        } else {
                            set taper_length    $ChainStay(TaperLength)
                        }

                    set pt_01       [ vectormath::addVector         $pt_00  $Direction(ChainStay)  $taper_length ]
                    set pt_02       [ vectormath::addVector         $pt_00  $Direction(ChainStay)  [expr $taper_length + 40] ]
                    set pt_03       [ vectormath::addVector         $pt_00  $Direction(ChainStay)  [expr $taper_length + 85] ]

                    set Position(ChainStay_RearWheel)               $pt_00
                    set Position(ChainStay_BottomBracket)           {0 0}
                    
                    set vct_01      [ vectormath::parallel          $pt_00 $pt_01 [expr 0.5*$ChainStay(DiameterSS)] ]
                    set vct_02      [ vectormath::parallel          $pt_01 $pt_02 [expr 0.5*$ChainStay(Height)]    ]
                    set vct_03      [ vectormath::parallel          $pt_03 $Position(ChainStay_BottomBracket) [expr 0.5*$ChainStay(HeigthBB)] ]
                    set vct_04      [ vectormath::parallel          $pt_03 $Position(ChainStay_BottomBracket) [expr 0.5*$ChainStay(HeigthBB)] left]
                    set vct_05      [ vectormath::parallel          $pt_01 $pt_02 [expr 0.5*$ChainStay(Height)]     left]
                    set vct_06      [ vectormath::parallel          $pt_00 $pt_01 [expr 0.5*$ChainStay(DiameterSS)] left]

                    set polygon     [format "%s %s %s %s %s %s %s %s %s %s" \
                                            [lindex $vct_01 0] [lindex $vct_02 0] [lindex $vct_02 1] [lindex $vct_03 0] [lindex $vct_03 1] \
                                            [lindex $vct_04 1] [lindex $vct_04 0] [lindex $vct_05 1] [lindex $vct_05 0] [lindex $vct_06 0] ]
            set Polygon(ChainStay)        $polygon
            
              # --- side View
            set l_00  0
            set l_01  [vectormath::length $pt_00 $pt_01]
            set l_02  [vectormath::length $pt_00 $pt_02]
            set l_03  [vectormath::length $pt_00 $pt_03]
            set l_04  [vectormath::length $pt_00 {0 0}]
            set Polygon(ChainStay_xz)   [list [format "%s,%s %s,%s %s,%s %s,%s %s,%s" \
                                                                                $l_00 [expr 0.5*$ChainStay(DiameterSS)] \
                                                                                $l_01 [expr 0.5*$ChainStay(Height)] \
                                                                                $l_02 [expr 0.5*$ChainStay(Height)] \
                                                                                $l_03 [expr 0.5*$ChainStay(HeigthBB)] \
                                                                                $l_04 [expr 0.5*$ChainStay(HeigthBB)] \
                                                                              ]
                                                                        ]

    }

        
        #
        # --- set ChainStay for Rear Mockup --------
    proc bikeGeometry::create_ChainStay_RearMockup {} {
                #
            variable Geometry
            variable Polygon
            variable Position
            variable CenterLine
                #
            variable BottomBracket
            variable RearWheel
            variable RearDropout
            variable ChainStay
            variable RearMockup
            variable Config
                #
            variable Result
                #
            set type $Config(ChainStay) 
                #
            set Length(01)              [ expr 0.5 * $BottomBracket(InsideDiameter) ]
            set Length(02)              [ expr 0.5 * $BottomBracket(Width) ]
            set Length(03)              [ expr $Length(02) - $BottomBracket(OffsetCS_TopView) ]
            set Length(04)              [ expr 0.5 * $RearWheel(HubWidth) ]
            set Length(05)              [ expr 0.5 * $RearWheel(HubWidth) + $RearDropout(OffsetCS_TopView)]
                # puts "  -> \$Length(01)           $Length(01)"
                # puts "  -> \$Length(02)           $Length(02)"
                # puts "  -> \$Length(03)           $Length(03)"
                # puts "  -> \$Length(04)           $Length(04)"
                # puts "  -> \$Length(05)           $Length(05)"                                                               
                #
            set Center(RearHub)         [ list [expr -1 * $Geometry(ChainStay_Length)] 0 ]
            set Center(ChainStay_DO)    [ vectormath::addVector $Center(RearHub) [ list $RearDropout(OffsetCS)  [ expr $Length(04) + $RearDropout(OffsetCS_TopView)] ] ]
            set Center(00)              [ list [expr -1.0 * $Length(01)] $Length(03) ] 
            set Center(ChainStay_00)    [ vectormath::cathetusPoint $Center(ChainStay_DO) $Center(00) [expr 0.5 * $ChainStay(WidthBB)] opposite ]
                # puts "  -> \$Center(ChainStay_DO) $Center(ChainStay_DO)"
                        
            set p_CS_BB [list [expr -1.0 * $Length(01)] $Length(03)]                   
                # puts "   \$p_CS_BB                   $p_CS_BB"
      
      
                # -- tube profile
            set profile_y00   $ChainStay(profile_y00)
            set profile_x01   $ChainStay(profile_x01)
            set profile_y01   $ChainStay(profile_y01)
            set profile_x02   $ChainStay(profile_x02)
            set profile_y02   $ChainStay(profile_y02)
            set profile_x03   $ChainStay(profile_x03)
            set profile_y03   $ChainStay(WidthBB)
                #
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
            set max_length     $ChainStay(completeLength)
            set S01_length     $ChainStay(segmentLength_01)       
            set S02_length     $ChainStay(segmentLength_02)       
            set S03_length     $ChainStay(segmentLength_03)       
            set S04_length     $ChainStay(segmentLength_04)       
            set tmp_length     [expr $S01_length + $S02_length + $S03_length + $S04_length]
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
                    set cuttingLength  $ChainStay(cuttingLength)
                  }
              default {
                      # -- bent                                                
                    set S01_angle      $ChainStay(segmentAngle_01) 
                    set S02_angle      $ChainStay(segmentAngle_02) 
                    set S03_angle      $ChainStay(segmentAngle_03) 
                    set S04_angle      $ChainStay(segmentAngle_04) 
                    set S01_radius     $ChainStay(segmentRadius_01)
                    set S02_radius     $ChainStay(segmentRadius_02)
                    set S03_radius     $ChainStay(segmentRadius_03)
                    set S04_radius     $ChainStay(segmentRadius_04)
                    set cuttingLength  $ChainStay(cuttingLength)
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
            set outLineOrient    [bikeGeometry::tube::create_tubeShape  $centerLineUnCut  $tubeProfile left  ]
            set outLineLeft      [bikeGeometry::tube::create_tubeShape  $centerLine       $tubeProfile left  ]
            set outLineRight     [bikeGeometry::tube::create_tubeShape  $centerLine       $tubeProfile right ]
            set outLine          [bikeGeometry::flatten_nestedList      $outLineLeft      $outLineRight]
            # set outLine          [appUtil::flatten_nestedList          $outLineLeft      $outLineRight]
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
                
                # -- prepare $centerLineUnCut for export 
            set centerLineUnCut  [bikeGeometry::flatten_nestedList $centerLineUnCut]
            set centerLineUnCut  [vectormath::rotatePointList {0 0} $centerLineUnCut $angleRotation]    
                
                # -- prepare $centerLine for export 
            set centerLine       [bikeGeometry::flatten_nestedList $centerLine]
            set centerLine       [vectormath::rotatePointList {0 0} $centerLine $angleRotation]    
             
                # -- prepare $ctrLines for export 
            set ctrLines         [bikeGeometry::flatten_nestedList $ctrLines]
            set ctrLines         [vectormath::rotatePointList {0 0} $ctrLines $angleRotation]    
            
                  
            
                # -- format Values
            proc format_XcommaY {xyList} {
                set commaList {}
                foreach {x y} $xyList { append commaList "$x,$y "}
                return $commaList
            }
                # -- store Values
            set Position(ChainStay_RearMockup)          $Center(ChainStay_DO)
            set Polygon(ChainStay_RearMockup)           $outLine
                # 
            set CenterLine(RearMockup_CtrLines) [format_XcommaY $ctrLines]
            set CenterLine(RearMockup)          [format_XcommaY $centerLine]
            set CenterLine(RearMockup_UnCut)    [format_XcommaY $centerLineUnCut]
                # 
                # puts "\n===================\n -> \$outLine $outLine\n"
                #
                # --- top View
            set l_00  0
            set l_01  [expr $l_00 + $profile_x01]
            set l_02  [expr $l_01 + $profile_x02]
            set l_03  [expr $l_02 + $profile_x03]
            set l_04  [expr $l_03 + 250]
            set Polygon(ChainStay_xy)   [list [format "%s,%s %s,%s %s,%s %s,%s" \
                                                                                $l_00 [expr 0.5 * $profile_y00] \
                                                                                $l_01 [expr 0.5 * $profile_y01] \
                                                                                $l_02 [expr 0.5 * $profile_y02] \
                                                                                $l_03 [expr 0.5 * $profile_y03] \
                                                                                $l_04 [expr 0.5 * $profile_y03] \
                                                                              ]
                                                                        ]
                # --- return values
            return
                # 
            
    }

        
        #
        # --- set HeadTube -------------------------
    proc bikeGeometry::create_HeadTube {} {
                #
            variable CenterLine
            variable Direction
                #
            variable Position
            variable Polygon
            variable HeadTube
            variable HeadSet
            variable Steerer
                #
            variable Geometry
            variable Result
                #
            set Direction(HeadTube)         [ vectormath::unifyVector     $Position(Steerer_Start)        $Position(Steerer_End) ]
            set Direction(Steerer)          $Direction(HeadTube)
                #
            set Position(HeadTube_Start)    [ vectormath::addVector     $Position(Steerer_Start)  $Direction(HeadTube)    $HeadSet(Height_Bottom) ]
            set Position(HeadTube_End)      [ vectormath::addVector     $Position(HeadTube_Start) $Direction(HeadTube)    $HeadTube(Length) ]
                #
            set CenterLine(HeadTube)        [list [format "%s,%s %s,%s" [lindex $Position(HeadTube_Start) 0] [lindex $Position(HeadTube_Start) 1] \
                                                                        [lindex $Position(HeadTube_End)   0] [lindex $Position(HeadTube_End)   1] ] ]
                #
                #
            set vct_01      [ vectormath::parallel          $Position(HeadTube_Start) $Position(HeadTube_End) [expr 0.5*$HeadTube(Diameter)] ]
            set vct_ht      [ vectormath::parallel          $Position(HeadTube_End) $Position(HeadTube_Start) [expr 0.5*$HeadTube(Diameter)] ]

            set polygon     [format "%s %s %s %s" \
                                    [lindex $vct_01 0] [lindex $vct_01 1] \
                                    [lindex $vct_ht 0] [lindex $vct_ht 1] ]
                #                           
            set Polygon(HeadTube)       $polygon
            # set Result(Tubes/HeadTube/Polygon)      $polygon
                # --- side View
            set Polygon(HeadTube_xz)   [list [format "%s,%s %s,%s" 0 [expr 0.5*$HeadTube(Diameter)]  $HeadTube(Length) [expr 0.5*$HeadTube(Diameter)]]]
                # set Result(Tubes/HeadTube/Profile/xz)   [list [format "%s,%s %s,%s" 0 [expr 0.5*$HeadTube(Diameter)]  $HeadTube(Length) [expr 0.5*$HeadTube(Diameter)]]]
                # --- top View
            set Polygon(HeadTube_xy)   [list [format "%s,%s %s,%s" 0 [expr 0.5*$HeadTube(Diameter)]  $HeadTube(Length) [expr 0.5*$HeadTube(Diameter)]]]
                # set Result(Tubes/HeadTube/Profile/xy)   [list [format "%s,%s %s,%s" 0 [expr 0.5*$HeadTube(Diameter)]  $HeadTube(Length) [expr 0.5*$HeadTube(Diameter)]]]
                #
    }


        #
        # --- set TopTube -------------------------
    proc bikeGeometry::create_TopTube_SeatTube {} {
                #
            variable CenterLine
            variable Direction
            variable Geometry
            variable Polygon
            variable Position
                #
            variable TopTube
            variable HeadTube
            variable SeatTube
            variable DownTube
            variable SeatPost
            variable Steerer
                #
            variable Result
                #

            set vct_st      [ vectormath::parallel          $SeatTube(DownTube) $Position(SeatPost_SeatTube) [expr 0.5*$SeatTube(DiameterTT)] ]
            
                    set vct_ht      [ vectormath::parallel          $Position(HeadTube_End) $Position(HeadTube_Start) [expr 0.5*$HeadTube(Diameter)] ]
                    set pt_00       [lindex $vct_ht 0]
                    set pt_01       [ vectormath::addVector         $pt_00 $Direction(HeadTube) [expr -1 * $TopTube(OffsetHT)] ]    ;# top intersection TopTube/HeadTube

            set Direction(TopTube)            [ vectormath::rotatePoint {0 0} {-1 0} $Geometry(TopTube_Angle) ]    ;# direction vector of TopTube
            
                    set pt_02       [ vectormath::intersectPoint    $pt_01 [vectormath::addVector $pt_01  $Direction(TopTube)]  {0 0} $Position(SeatPost_SeatTube) ]    ;# top intersection TopTube/HeadTube
                    set vct_00      [ vectormath::parallel          $pt_01 $pt_02 [expr 0.5 * $TopTube(DiameterHT)] left]    ;# TopTube centerline Vector
                    set pt_10       [ vectormath::intersectPoint    [lindex $vct_00 0] [lindex $vct_00 1]  $Position(Steerer_Start) $Position(Steerer_End)  ]
                    set length      [ vectormath::length            $pt_10 [lindex $vct_00 1] ]
                    set pt_11       [ vectormath::addVector         $pt_10  $Direction(TopTube)  [expr 0.5*($length - $TopTube(TaperLength)) ] ]
                    set pt_12       [ vectormath::addVector         $pt_11  $Direction(TopTube)  $TopTube(TaperLength) ]
                    set pt_13       [ vectormath::intersectPoint    [lindex $vct_00 0] [lindex $vct_00 1]  {0 0} $Position(SeatPost_SeatTube) ]
                    set vct_10      [ vectormath::parallel          $pt_10 $pt_11 [expr 0.5*$TopTube(DiameterHT)] right ]
                    set vct_11      [ vectormath::parallel          $pt_10 $pt_11 [expr 0.5*$TopTube(DiameterHT)] left  ]
                    set vct_21      [ vectormath::parallel          $pt_12 $pt_13 [expr 0.5*$TopTube(DiameterST)] right ]
                    set vct_22      [ vectormath::parallel          $pt_12 $pt_13 [expr 0.5*$TopTube(DiameterST)] left  ]
                    set pt_04       [ vectormath::intersectPoint    [lindex $vct_ht 0] [lindex $vct_ht 1]  [lindex $vct_11 0] [lindex $vct_11 1] ]
                    set pt_st       [ vectormath::intersectPoint    [lindex $vct_st 0] [lindex $vct_st 1]  [lindex $vct_21 0] [lindex $vct_21 1] ]
                    set pt_22       [ vectormath::intersectPoint    [lindex $vct_st 0] [lindex $vct_st 1]  [lindex $vct_22 0] [lindex $vct_22 1] ]

            set Position(TopTube_End)   $pt_10
            set Position(TopTube_Start) [ vectormath::intersectPoint [lindex $vct_00 0] [lindex $vct_00 1] $Position(SeatTube_Start) $Position(SeatPost_SeatTube) ]
                        #
            set CenterLine(TopTube)     [list [format "%s,%s %s,%s" [lindex $Position(TopTube_Start) 0] [lindex $Position(TopTube_Start) 1] \
                                                                                                  [lindex $Position(TopTube_End) 0] [lindex $Position(TopTube_End) 1] ] ]
                        #
                    set is_tt_ht    [ tube_intersection    $TopTube(DiameterHT) $Direction(TopTube)  $HeadTube(Diameter)    $Direction(HeadTube)  $Position(TopTube_End) right]
                    set is_tt_st    [ tube_intersection    $TopTube(DiameterST) $Direction(TopTube)  $SeatTube(DiameterTT)  $Direction(SeatTube)  $Position(TopTube_Start) left ]
                        #
                    set polygon     [ bikeGeometry::flatten_nestedList $is_tt_ht]
                    set polygon     [ lappend polygon [lindex $vct_10 1] [lindex $vct_21 0]]
                    set polygon     [ lappend polygon [bikeGeometry::flatten_nestedList $is_tt_st]]
                    set polygon     [ lappend polygon [lindex $vct_22 0] [lindex $vct_11 1]]
            set Polygon(TopTube)    [ bikeGeometry::flatten_nestedList $polygon]
            
                        # 
                    set pt_00       [ vectormath::intersectPerp     $Position(SeatTube_Start) $Position(SeatPost_SeatTube)   $pt_st ]
                    set pt_01       [ vectormath::addVector         $pt_00   $Direction(SeatTube)  $SeatTube(Extension) ]
            set Position(SeatTube_End)  $pt_01
            set CenterLine(SeatTube)    [list [format "%s,%s %s,%s" [lindex $Position(SeatTube_Start) 0] [lindex $Position(SeatTube_Start) 1] \
                                                                    [lindex $Position(SeatTube_End)   0] [lindex $Position(SeatTube_End)   1] ] ]
                
                # --- get length
                    set l_00  0
                    set l_01  [expr $l_00 + [ vectormath::length $pt_10 $pt_11 ]]
                    set l_02  [expr $l_01 + [ vectormath::length $pt_11 $pt_12 ]]
                    set l_03  [expr $l_02 + [ vectormath::length $pt_12 $pt_13 ]]
                # --- side View
            set Polygon(TopTube_xz)    \
                                        [list [format "%s,%s %s,%s %s,%s %s,%s" \
                                                $l_00  [expr 0.5*$TopTube(DiameterHT)] \
                                                $l_01  [expr 0.5*$TopTube(DiameterHT)] \
                                                $l_02  [expr 0.5*$TopTube(DiameterST)] \
                                                $l_03  [expr 0.5*$TopTube(DiameterST)] \
                                            ] \
                                        ]
              # --- top View
            set Polygon(TopTube_xy)  $Polygon(TopTube_xz)
              #
            # set Result(Tubes/TopTube/Profile/xz)    \
                                        [list [format "%s,%s %s,%s %s,%s %s,%s" \
                                                $l_00  [expr 0.5*$TopTube(DiameterHT)] \
                                                $l_01  [expr 0.5*$TopTube(DiameterHT)] \
                                                $l_02  [expr 0.5*$TopTube(DiameterST)] \
                                                $l_03  [expr 0.5*$TopTube(DiameterST)] \
                                            ] \
                                        ]
              # --- top View
            # set Result(Tubes/TopTube/Profile/xy)  $Result(Tubes/TopTube/Profile/xz)
              #
                        #
                    set pt_01       $Position(SeatTube_End)
                    
                    set length      [ vectormath::length            $Position(SeatTube_Start) $pt_01 ]
                    set pt_10       $Position(SeatTube_Start)
                    set pt_11       [ vectormath::addVector         $pt_10  $Direction(SeatTube)  [expr 0.5*($length - $SeatTube(TaperLength)) ] ]
                    set pt_12       [ vectormath::addVector         $pt_11  $Direction(SeatTube)  $SeatTube(TaperLength) ]
                    set pt_13       $pt_01
                    set vct_10      [ vectormath::parallel          $pt_10 $pt_11 [expr 0.5*$SeatTube(DiameterBB)] right ]
                    set vct_11      [ vectormath::parallel          $pt_10 $pt_11 [expr 0.5*$SeatTube(DiameterBB)] left  ]
                    set vct_21      [ vectormath::parallel          $pt_12 $pt_13 [expr 0.5*$SeatTube(DiameterTT)] right ]
                    set vct_22      [ vectormath::parallel          $pt_12 $pt_13 [expr 0.5*$SeatTube(DiameterTT)] left  ]
                        #
                        
                        #
                    set is_st_dt    [ tube_intersection    $SeatTube(DiameterBB) $Direction(SeatTube)  $DownTube(DiameterBB)  $Direction(DownTube)  $SeatTube(DownTube) right ]
                        #
                    set polygon     [ list  [lindex $vct_10 1]  [lindex $vct_21 0] \
                                            [lindex $vct_21 1]  [lindex $vct_22 1] \
                                            [lindex $vct_22 0]  [lindex $vct_11 1] ]
                    lappend polygon $is_st_dt
                        #
            set Polygon(SeatTube)   [bikeGeometry::flatten_nestedList $polygon]            
                        #
                        
                        # --- get length
                    set l_00  0
                    set l_01  [expr $l_00 + [ vectormath::length $pt_10 $pt_11 ]]
                    set l_02  [expr $l_01 + [ vectormath::length $pt_11 $pt_12 ]]
                    set l_03  [expr $l_02 + [ vectormath::length $pt_12 $pt_13 ]]
                        # --- side View
            set Polygon(SeatTube_xz)    \
                                        [list [format "%s,%s %s,%s %s,%s %s,%s" \
                                                $l_00  [expr 0.5*$SeatTube(DiameterBB)] \
                                                $l_01  [expr 0.5*$SeatTube(DiameterBB)] \
                                                $l_02  [expr 0.5*$SeatTube(DiameterTT)] \
                                                $l_03  [expr 0.5*$SeatTube(DiameterTT)] \
                                            ]
                                        ]
            set Polygon(SeatTube_xy)  $Polygon(SeatTube_xz)
            
            # set Result(Tubes/SeatTube/Profile/xz)    \
                                        [list [format "%s,%s %s,%s %s,%s %s,%s" \
                                                $l_00  [expr 0.5*$SeatTube(DiameterBB)] \
                                                $l_01  [expr 0.5*$SeatTube(DiameterBB)] \
                                                $l_02  [expr 0.5*$SeatTube(DiameterTT)] \
                                                $l_03  [expr 0.5*$SeatTube(DiameterTT)] \
                                            ] \
                                        ]
                        # --- top View
            # set Result(Tubes/SeatTube/Profile/xy)  $Result(Tubes/SeatTube/Profile/xz)
                        #
         
    }


        #
        # --- set DownTube SeatTube ------------------------
    proc bikeGeometry::create_DownTube_SeatTube {} {
                #
            variable CenterLine
            variable Direction
            variable Polygon
            variable Position
                #
            variable HeadTube
            variable DownTube
            variable SeatTube
            variable SeatPost
            variable Steerer
                #
            variable Result
                        #
                    set vct_ht      [ vectormath::parallel          $Position(HeadTube_End) $Position(HeadTube_Start) [expr 0.5*$HeadTube(Diameter)] ]
                        # exit
                    set pt_00       [ lrange $Polygon(HeadTube)   6 7 ]
                    set pt_01       [ vectormath::addVector         $pt_00 $Direction(HeadTube) $DownTube(OffsetHT) ]                            ;# bottom intersection DownTube/HeadTube
                    set pt_02       [ vectormath::cathetusPoint     {0 0}  $pt_01 [expr 0.5 * $DownTube(DiameterHT) - $DownTube(OffsetBB) ]]    ;# DownTube lower Vector
                    set vct_cl      [ vectormath::parallel          $pt_02 $pt_01 [expr 0.5 * $DownTube(DiameterHT)] left]                        ;# DownTube centerline Vector
                    set pt_is       [ vectormath::intersectPoint    [lindex $vct_cl 0] [lindex $vct_cl 1]  $Position(SeatTube_Start)    $Position(SeatPost_SeatTube) ]
                        #
            set SeatTube(DownTube)          $pt_is
                        #
            set Direction(DownTube)         [ vectormath::unifyVector       [lindex $vct_cl 0] [lindex $vct_cl 1] ]
            set Position(DownTube_End)      [ vectormath::intersectPoint    [lindex $vct_cl 0] [lindex $vct_cl 1]  $Position(Steerer_Start)     $Position(Steerer_End) ]
            set Position(DownTube_Start)    [lindex $vct_cl 0]
                        #
            set CenterLine(DownTube)        [list [format "%s,%s %s,%s" [lindex $Position(DownTube_Start)   0] [lindex $Position(DownTube_Start)    1] \
                                                                        [lindex $Position(DownTube_End)     0] [lindex $Position(DownTube_End)      1] ] ]
                        #
                    set vct_02      [ vectormath::parallel          [lindex $vct_cl 0] [lindex $vct_cl 1] $DownTube(DiameterHT) left]   ;# DownTube upper Vector HT
                    set pt_04       [ vectormath::intersectPoint    [lindex $vct_02 0] [lindex $vct_02 1] \
                                                                    [lindex $vct_ht 0] [lindex $vct_ht 1] ] ;# top intersection DownTube/HeadTube
                    set length      [ vectormath::length            [lindex $vct_02 0] $pt_04 ]
                    set pt_10       [ lindex $vct_cl 0]             ;# BB-Position
                    set pt_11       [ vectormath::addVector         $pt_10 $Direction(DownTube) [expr 0.5*($length - $DownTube(TaperLength) )] ]
                    set pt_12       [ vectormath::addVector         $pt_11 $Direction(DownTube) $DownTube(TaperLength) ]
                    set pt_13       [ lindex $vct_cl 1]             ;# HT-Position
                    set vct_10      [ vectormath::parallel          $pt_10 $pt_11 [expr 0.5*$DownTube(DiameterBB)] right ]
                    set vct_11      [ vectormath::parallel          $pt_10 $pt_11 [expr 0.5*$DownTube(DiameterBB)] left  ]
                    set vct_21      [ vectormath::parallel          $pt_12 $pt_13 [expr 0.5*$DownTube(DiameterHT)] right ]
                    set vct_22      [ vectormath::parallel          $pt_12 $pt_13 [expr 0.5*$DownTube(DiameterHT)] left  ]
                        #
                    set pt_ht       [ vectormath::intersectPoint    [lindex $vct_cl 0] [lindex $vct_cl 1]  $Position(HeadTube_End) $Position(HeadTube_Start) ]
                        #
                    set dir         [ vectormath::addVector {0 0} $Direction(DownTube) -1]
                        #
                    set is_dt_ht    [ tube_intersection $DownTube(DiameterHT) $dir  $HeadTube(Diameter)     $Direction(HeadTube)  $Position(DownTube_End) ]
                        #
                    set polygon     [ list            [lindex $vct_10 1] [lindex $vct_21 0]]
                    lappend polygon [ bikeGeometry::flatten_nestedList $is_dt_ht]
                    lappend polygon [ lindex $vct_22 0] [lindex $vct_11 1]
                    lappend polygon [ lindex $vct_11 0] [ lindex $vct_10 0]
                        #
            set Polygon(DownTube)       [bikeGeometry::flatten_nestedList $polygon]
                        #
                        
                    # --- get length
                    set l_00  0
                    set l_01  [expr $l_00 + [ vectormath::length $pt_10 $pt_11 ]]
                    set l_02  [expr $l_01 + [ vectormath::length $pt_11 $pt_12 ]]
                    set l_03  [expr $l_02 + [ vectormath::length $pt_12 $pt_ht ]]
                        #
                    
                    # --- side View
            set Polygon(DownTube_xz)    \
                                        [list [format "%s,%s %s,%s %s,%s %s,%s" \
                                                $l_00  [expr 0.5*$DownTube(DiameterBB)] \
                                                $l_01  [expr 0.5*$DownTube(DiameterBB)] \
                                                $l_02  [expr 0.5*$DownTube(DiameterHT)] \
                                                $l_03  [expr 0.5*$DownTube(DiameterHT)] \
                                            ] \
                                        ]
            set Polygon(DownTube_xy)   $Polygon(DownTube_xz)
            # set Result(Tubes/DownTube/Profile/xz)    \
                                        [list [format "%s,%s %s,%s %s,%s %s,%s" \
                                                $l_00  [expr 0.5*$DownTube(DiameterBB)] \
                                                $l_01  [expr 0.5*$DownTube(DiameterBB)] \
                                                $l_02  [expr 0.5*$DownTube(DiameterHT)] \
                                                $l_03  [expr 0.5*$DownTube(DiameterHT)] \
                                            ] \
                                        ]
                    # --- top View
            # set Result(Tubes/DownTube/Profile/xy)   $Result(Tubes/DownTube/Profile/xz)
                #
                #
            return
                #
    }


        #
        # --- set SeatStay ------------------------
    proc bikeGeometry::create_SeatStay {} {
                #
            variable CenterLine
            variable Direction
            variable Polygon
            variable Position
                #
            variable SeatStay
            variable ChainStay
            variable TopTube
            variable SeatTube
            variable RearWheel
            variable RearDropout
                #
            variable Result
                #
                
                    set pt_00       [ vectormath::addVector     $Position(TopTube_Start)  $Direction(SeatTube)  $SeatStay(OffsetTT) ] ; # intersection seatstay / seattube
                    set pt_01       [ lindex [ vectormath::parallel     $Position(RearWheel)  $pt_00   $RearDropout(OffsetSSPerp) ] 0 ]
                        #
            set Direction(SeatStay) [ vectormath::unifyVector $pt_01 $pt_00 ]
                        #
                    set pt_10       [ vectormath::addVector     $pt_01  $Direction(SeatStay)  $RearDropout(OffsetSS) ]
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
                    set pt_11       [ vectormath::addVector        $pt_10  $Direction(SeatStay)  $taper_length ]
                    set pt_12       $pt_00
                    set vct_10      [ vectormath::parallel $pt_10 $pt_11 [expr 0.5*$SeatStay(DiameterCS)] ]
                    set vct_11      [ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$SeatStay(DiameterST)] ]
                    set vct_12      [ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$SeatStay(DiameterST)] left]
                    set vct_13      [ vectormath::parallel $pt_10 $pt_11 [expr 0.5*$SeatStay(DiameterCS)] left]
                        #
            set Position(SeatStay_End)      $pt_00
            set Position(SeatStay_Start)    $pt_10
                        #
            set CenterLine(SeatStay)    [list [format "%s,%s %s,%s" [lindex $Position(SeatStay_Start) 0] [lindex $Position(SeatStay_Start) 1] \
                                                                    [lindex $Position(SeatStay_End)   0] [lindex $Position(SeatStay_End)   1] ] ]
                        #
                    set dir         [ vectormath::addVector {0 0} $Direction(SeatStay) -1]
                    set offset      [ expr 0.5 * ($SeatTube(DiameterTT) - $SeatStay(DiameterST)) ]
                    set is_ss_st    [ tube_intersection $SeatStay(DiameterST) $dir  $SeatTube(DiameterTT)      $Direction(SeatTube)  $Position(SeatStay_End)  right $offset]
                        #
                set SeatStay(debug)             $is_ss_st
                        #
                    set polygon     [ bikeGeometry::flatten_nestedList  $is_ss_st ]
                    set polygon     [ lappend polygon [lindex $vct_12 0] [lindex $vct_13 0] \
                                                      [lindex $vct_10 0] [lindex $vct_11 0] ]
            set Polygon(SeatStay)   [ bikeGeometry::flatten_nestedList $polygon]
                        #
                                    
                        # --- get length
            set l_00  0
            set l_01  [expr $l_00 + [ vectormath::length $pt_10 $pt_11 ]]
            set l_02  [expr $l_01 + [ vectormath::length $pt_11 $pt_12 ]]
                        # --- side View
            set Polygon(SeatStay_xz)    \
                                        [list [format "%s,%s %s,%s %s,%s" \
                                                $l_00  [expr 0.5*$SeatStay(DiameterCS)] \
                                                $l_01  [expr 0.5*$SeatStay(DiameterST)] \
                                                $l_02  [expr 0.5*$SeatStay(DiameterST)] \
                                            ] \
                                        ]
            set Polygon(SeatStay_xy)   $Polygon(SeatStay_xz)
            
            # set Result(Tubes/SeatStay/Profile/xz)    \
                                        [list [format "%s,%s %s,%s %s,%s" \
                                                $l_00  [expr 0.5*$SeatStay(DiameterCS)] \
                                                $l_01  [expr 0.5*$SeatStay(DiameterST)] \
                                                $l_02  [expr 0.5*$SeatStay(DiameterST)] \
                                            ] \
                                        ]
                        # --- top View
            # set Result(Tubes/SeatStay/Profile/xy)   $Result(Tubes/SeatStay/Profile/xz)
                        #

                        #
                        # --- set SeatStay / ChainStay - Intersection
            set Position(ChainStay_SeatStay_IS)     [ vectormath::intersectPoint $Position(SeatStay_End) $Position(SeatStay_Start) $Position(ChainStay_BottomBracket) $Position(ChainStay_RearWheel) ];# intersection of ChainStay and SeatStay centerlines
                        #
    }


        #
        # --- set TubeMiter -----------------
    proc bikeGeometry::create_TubeMiter {} {
                #
            variable Direction
                #
            variable HeadTube
            variable SeatTube
            variable SeatStay
            variable TopTube
            variable DownTube
            variable TubeMiter
            variable BottomBracket
                #
            variable Result
                #

                set dir $Direction(HeadTube)
                        #
            set TubeMiter(TopTube_Head)       [ tube_miter    $TopTube(DiameterHT)  $Direction(TopTube)    $HeadTube(Diameter)      $Direction(HeadTube)    ]
            set TubeMiter(TopTube_Seat)       [ tube_miter    $TopTube(DiameterST)  $Direction(TopTube)    $SeatTube(DiameterTT)    $Direction(HeadTube)    ]
                #                                                                                                                                            
            set TubeMiter(DownTube_Head)      [ tube_miter    $DownTube(DiameterHT) $Direction(DownTube)   $HeadTube(Diameter)      $Direction(HeadTube)    right    0    0  opposite]
            set TubeMiter(DownTube_Seat)      [ tube_miter    $DownTube(DiameterBB) $Direction(DownTube)   $SeatTube(DiameterBB)    $Direction(SeatTube)    ]
            set TubeMiter(DownTube_BB_out)    [ tube_miter    $DownTube(DiameterBB) {1 0}                  $BottomBracket(OutsideDiameter)      {0 1}       right    $DownTube(OffsetBB)   -90  opposite]
            set TubeMiter(DownTube_BB_in)     [ tube_miter    $DownTube(DiameterBB) {1 0}                  $BottomBracket(InsideDiameter)       {0 1}       right    $DownTube(OffsetBB)   -90  opposite]
                #
            set TubeMiter(SeatTube_Down)      [ tube_miter    $SeatTube(DiameterBB) $Direction(SeatTube)   $DownTube(DiameterBB)    $Direction(DownTube)    ]
            set TubeMiter(SeatTube_BB_out)    [ tube_miter    $SeatTube(DiameterBB) {1 0}                  $BottomBracket(OutsideDiameter)      {0 1}       right    $SeatTube(OffsetBB)   -90  opposite]
            set TubeMiter(SeatTube_BB_in)     [ tube_miter    $SeatTube(DiameterBB) {1 0}                  $BottomBracket(InsideDiameter)       {0 1}       right    $SeatTube(OffsetBB)   -90  opposite]
                        #
                set offset      [ expr 0.5 * ($SeatTube(DiameterTT) - $SeatStay(DiameterST)) ]
                set dir         [ vectormath::scalePointList {0 0} $Direction(SeatStay) -1.0 ]
                        #
                #
            set TubeMiter(SeatStay_01)        [ tube_miter    $SeatStay(DiameterST) $dir                   $SeatTube(DiameterTT)    $Direction(SeatTube)    right   -$offset]
            set TubeMiter(SeatStay_02)        [ tube_miter    $SeatStay(DiameterST) $dir                   $SeatTube(DiameterTT)    $Direction(SeatTube)    right   +$offset]
            set TubeMiter(Reference)          { -50 0  50 0  50 10  -50 10 }
                #
                #
            set TubeMiter(TopTube_Head)       [ bikeGeometry::flatten_nestedList $TubeMiter(TopTube_Head)  ]
            set TubeMiter(TopTube_Seat)       [ bikeGeometry::flatten_nestedList $TubeMiter(TopTube_Seat)  ]
                #
            set TubeMiter(DownTube_Head)      [ bikeGeometry::flatten_nestedList $TubeMiter(DownTube_Head) ]
            set TubeMiter(DownTube_Seat)      [ bikeGeometry::flatten_nestedList $TubeMiter(DownTube_Seat) ]
            set TubeMiter(DownTube_BB_out)    [ bikeGeometry::flatten_nestedList $TubeMiter(DownTube_BB_out) ]
            set TubeMiter(DownTube_BB_in)     [ bikeGeometry::flatten_nestedList $TubeMiter(DownTube_BB_in)  ]
                #
            set TubeMiter(SeatTube_Down)      [ bikeGeometry::flatten_nestedList $TubeMiter(SeatTube_Down) ]
            set TubeMiter(SeatTube_BB_out)    [ bikeGeometry::flatten_nestedList $TubeMiter(SeatTube_BB_out) ]
            set TubeMiter(SeatTube_BB_in)     [ bikeGeometry::flatten_nestedList $TubeMiter(SeatTube_BB_in)  ]
                #
            set TubeMiter(SeatStay_01)        [ bikeGeometry::flatten_nestedList $TubeMiter(SeatStay_01)   ]
            set TubeMiter(SeatStay_02)        [ bikeGeometry::flatten_nestedList $TubeMiter(SeatStay_02)   ]
                #
            set TubeMiter(Reference)          [ bikeGeometry::flatten_nestedList $TubeMiter(Reference)     ]
                #
                #
            return
                #
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
        #                   \     \
        #   -----------\     \     \
        #   diameter    \     \     \
        #                \     \     \ diameter_isect
        #
    proc bikeGeometry::tube_miter { diameter direction diameter_isect direction_isect {side {right}} {offset {0}}  {startAngle {0}}  {opposite {no}}} {

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
                # puts "       -> intersection_angle   $intersection_angle"
                # puts "            ... [expr tan([vectormath::rad $intersection_angle])]"
                        #
            while {$angle <= 180} {
                        # puts "  -> \$angle $angle"
                    set rad_Angle   [vectormath::rad [expr $angle -$startAngle]]
                    set pp [expr $diameter*$vectormath::CONST_PI*$angle/360 ];  # -- position on perimeter
                        #
                    set h [expr $offset + $radius*sin($rad_Angle)];             # -- y-value on circle 
                    set b [expr $radius*cos($rad_Angle)];                       # -- x-value on circle
                        #
                    if {[expr abs($radius_isect)] >= [expr abs($h)]} {
                        set y  [expr sqrt(pow($radius_isect,2) - pow($h,2))] ;   # -- point on miter-curve based on perimeter position
                    } else {
                        set y  0                                             ;   # -- undefined for situations where point on circle does not cut sectioning tube
                    }
                        #
                    if {[expr abs($intersection_angle)] != 90.0} {
                        set v1 [expr $b/tan([vectormath::rad $intersection_angle])]; # -- tube - component of offset
                        set v2 [expr $y/sin([vectormath::rad $intersection_angle])]; # -- intersecting tube component of offset
                        set y  [expr $v1 + $v2]
                    }
                        #
                    set xy [list $pp $y]
                    if {$side == {right}}  {set xy    [vectormath::rotatePoint {0 0} $xy  180]}
                    lappend coordList [lindex $xy 0] [lindex $xy 1]
                    set angle       [expr $angle + 360 / $loops]
            }
            lappend coordList [expr -0.5*$perimeter]  -70 
            lappend coordList [expr  0.5*$perimeter]  -70
                #
            return $coordList
                #
    }

 

    
    
 



 