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
        #
        # --- set basePoints Attributes
        #
    proc bikeGeometry::get_basePoints {} {
            variable Saddle
            variable SeatPost
            variable SeatTube
            variable HandleBar
            variable HeadTube
            variable Steerer
            variable Stem
            variable Fork
            variable RearWheel
            variable FrontWheel
            variable BottomBracket

                        # puts "   ..     \$HeadTube(Angle)    $HeadTube(Angle)"

                    set vect_01 [ expr $Stem(Length) * cos($Stem(Angle) * $vectormath::CONST_PI / 180) ]
                    set vect_03 [ expr $vect_01 / sin($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]

                    set Steerer(Handlebar)      [ list  [expr [lindex $HandleBar(Position) 0] - $vect_03]  [lindex $HandleBar(Position) 1] ]

                    set help_04 [ vectormath::rotateLine       $Steerer(Handlebar)     100    [expr 180 - $HeadTube(Angle)]    ]
                    set help_03 [ vectormath::rotateLine       $HandleBar(Position)    100    [expr  90 - $HeadTube(Angle) + $Stem(Angle)]    ]

                    set Steerer(Stem)           [ vectormath::intersectPoint    $HandleBar(Position)  $help_03 $Steerer(Handlebar) $help_04 ]

                    set vect_04 [ vectormath::parallel         $Steerer(Stem)      $help_04    $Fork(Rake) ]
                    set help_05 [ lindex $vect_04 0 ]
                    set help_06 [ lindex $vect_04 1 ]

                    set FrontWheel(Position)    [ vectormath::intersectPoint    $help_05  $help_06 [list 0 $FrontWheel(Distance_Y)] [list 200 $FrontWheel(Distance_Y)] ]
                    set FrontWheel(Distance_X)  [ lindex $FrontWheel(Position) 0]
                    set FrontWheel(DistanceBB)  [ expr hypot($FrontWheel(Distance_X),$FrontWheel(Distance_X)) ]

                    set Steerer(FrontWheel)     [ vectormath::rotateLine    $FrontWheel(Position)    $Fork(Rake)    [expr 270 - $HeadTube(Angle)] ]
                    set Steerer(Fork)           [ vectormath::addVector            $Steerer(FrontWheel)     [ vectormath::unifyVector  $Steerer(FrontWheel)  $Steerer(Stem)  $Fork(Height) ] ]

            project::setValue Result(Tubes/Steerer/Start)       position    $Steerer(Fork)
            project::setValue Result(Tubes/Steerer/End)         position    $Steerer(Stem)
            project::setValue Result(Lugs/ForkCrown/Position)   position    $Steerer(Fork)
            project::setValue Result(Tubes/Steerer/Direction)   direction   $Steerer(Fork)   $Steerer(Stem)
            project::setValue Result(Tubes/Steerer/Direction)   direction   $Steerer(Fork)   $Steerer(Stem)

                set help_08  [ vectormath::addVector    $BottomBracket(Ground) {200 0}]

                set Steerer(Ground)     [ vectormath::intersectPoint        $Steerer(Stem) $Steerer(Fork)      $BottomBracket(Ground)  $help_08 ]
                set SeatTube(Ground)    [ vectormath::intersectPoint        $SeatPost(SeatTube) $SeatTube(BottomBracket)      $BottomBracket(Ground)  $help_08 ]
            project::setValue Result(Position/SteererGround)    position    $Steerer(Ground)        ;# Point on the Ground in direction of Steerer
            project::setValue Result(Position/SeatTubeGround)   position    $SeatTube(Ground)       ;# Point on the Ground in direction of SeatTube
            project::setValue Result(Tubes/SeatTube/Direction)  direction   $SeatTube(Ground)  $SeatPost(SeatTube)

                #
                # --- set summary Length of Frame, Saddle and Stem
                set summaryLength [ expr $RearWheel(Distance_X) + $FrontWheel(Distance_X)]
                set summaryHeight [ expr $project::Custom(BottomBracket/Depth) + 40 + [lindex $SeatPost(SeatTube) 1] ]
            project::setValue Result(Position/SummarySize)      position    $summaryLength   $summaryHeight

    }
    
    
        #
        #
        # --- set basePoints Attributes
        #
    proc bikeGeometry::get_Reference {} {

            variable FrontWheel
            variable BottomBracket
            variable Reference
            
            set angle_current           [vectormath::angle {10 0} {0 0} $FrontWheel(Position)]
         
              # -- Reference HandleBar
            set side_a                  $project::Reference(HandleBar_FW)
            set side_b                  $project::Reference(HandleBar_BB) 
            set side_c                  [vectormath::length {0 0} $FrontWheel(Position)]
            set angle                   [vectormath::angle_Triangle $side_a $side_b $side_c]
            
            set angle_current           [expr $angle_current + $angle]
            set Reference(HandleBar)    [vectormath::rotateLine {0 0} $project::Reference(HandleBar_BB)  $angle_current]
              
            project::setValue Result(Position/Reference_HB)       position    $Reference(HandleBar)
            
            
            # -- Reference SaddleNose
            set side_a                  $project::Reference(SaddleNose_HB)
            set side_b                  $project::Reference(SaddleNose_BB) 
            set side_c                  $project::Reference(HandleBar_BB) 
            set angle                   [vectormath::angle_Triangle $side_a $side_b $side_c]
            
            set angle_current           [expr $angle_current + $angle]
            set Reference(SaddleNose)   [vectormath::rotateLine {0 0} $project::Reference(SaddleNose_BB)  $angle_current]
              
            project::setValue Result(Position/Reference_SN)      position    $Reference(SaddleNose)
         
    }    


        #
        # --- set ChainStay ------------------------
    proc bikeGeometry::get_ChainStay {} {
            variable RearDrop
            variable ChainStay
            variable RearWheel

                    set vct_angle   [ vectormath::dirAngle      $RearWheel(Position)  {0 0}]
                    set vct_xy      [ list $RearDrop(OffsetCS) [expr -1.0 * $RearDrop(OffsetCSPerp)]]
                    set do_angle    [ expr $vct_angle - $RearDrop(RotationOffset)]
                    set vct_CS      [ vectormath::rotatePoint   {0 0}  $vct_xy  $do_angle]
                    set pt_00       [ vectormath::addVector     $RearWheel(Position)  $vct_CS]

                    set ChainStay(Direction)            [ vectormath::unifyVector {0 0} $pt_00 ]
            project::setValue Result(Tubes/ChainStay/Direction) direction   $pt_00

            
                        # -- position of Rear Derailleur Mount
                    set vct_xy      [ list [expr -1 * $RearDrop(Derailleur_x)]  [expr -1 * $RearDrop(Derailleur_y)]]
                    set vct_mount   [ vectormath::rotatePoint   {0 0}  $vct_xy  $do_angle]
                    set pt_mount    [ vectormath::addVector     $RearWheel(Position)  $vct_mount]
            project::setValue Result(Lugs/Dropout/Rear/Derailleur)  position     [ vectormath::addVector  $RearWheel(Position)  $vct_mount ]
            # project::setValue Result(Lugs/Dropout/Rear/Derailleur)  position     [ vectormath::addVector  $RearWheel(Position)  [list $RearDrop(Derailleur_x) $RearDrop(Derailleur_y)] ]

            
            
                        # -- exception if Tube is shorter than taper length
                    set tube_length         [ vectormath::length {0 0} $pt_00 ]
                        if { [expr $tube_length - $ChainStay(TaperLength) -110] < 0 } {
                            puts "            ... exception:  ChainStay TaperLength ... $tube_length / $ChainStay(TaperLength)"
                            set taper_length    [ expr $tube_length -110 ]
                            puts "                         -> $taper_length"
                        } else {
                            set taper_length    $ChainStay(TaperLength)
                        }

                    set pt_01       [ vectormath::addVector         $pt_00  $ChainStay(Direction)  -$taper_length ]
                    set pt_02       [ vectormath::addVector         {0 0}   $ChainStay(Direction)  70 ]
                    set pt_03       [ vectormath::addVector         {0 0}   $ChainStay(Direction)  30 ]

                    set ChainStay(RearWheel)            $pt_00
                    set ChainStay(BottomBracket)        {0 0}
            project::setValue Result(Tubes/ChainStay/Start)         position    {0 0}
            project::setValue Result(Tubes/ChainStay/End)           position    $ChainStay(RearWheel)

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
    }

        
        #
        # --- set ChainStay for Rear Mockup --------
    proc bikeGeometry::get_ChainStay_RearMockup {{type {bent}}} {
          variable BottomBracket
          variable RearWheel
          variable RearDrop
          variable ChainStay
          
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
          switch -exact $type {
            {straight} {
                  set S01_length   $project::FrameTubes(ChainStay/CenterLine/length_01)
                  set S02_length   $project::FrameTubes(ChainStay/CenterLine/length_02)
                  set S03_length   $project::FrameTubes(ChainStay/CenterLine/length_03)
                  set S04_length   $project::FrameTubes(ChainStay/CenterLine/length_04)
                  set S05_length   $project::FrameTubes(ChainStay/CenterLine/length_05)
                  set S01_angle      0
                  set S02_angle      0
                  set S03_angle      0
                  set S04_angle      0
                  set S01_radius   320
                  set S02_radius   320
                  set S03_radius   320
                  set S04_radius   320
                  # set bikeGeometry::tube::arcPrecission 50
                }
            default {
                    # -- bent                                                
                  set S01_length   $project::FrameTubes(ChainStay/CenterLine/length_01)
                  set S02_length   $project::FrameTubes(ChainStay/CenterLine/length_02)
                  set S03_length   $project::FrameTubes(ChainStay/CenterLine/length_03)
                  set S04_length   $project::FrameTubes(ChainStay/CenterLine/length_04)
                  set S05_length   $project::FrameTubes(ChainStay/CenterLine/length_05)
                  set S01_angle    $project::FrameTubes(ChainStay/CenterLine/angle_01)
                  set S02_angle    $project::FrameTubes(ChainStay/CenterLine/angle_02)
                  set S03_angle    $project::FrameTubes(ChainStay/CenterLine/angle_03)
                  set S04_angle    $project::FrameTubes(ChainStay/CenterLine/angle_04)
                  set S01_radius   $project::FrameTubes(ChainStay/CenterLine/radius_01)
                  set S02_radius   $project::FrameTubes(ChainStay/CenterLine/radius_02)
                  set S03_radius   $project::FrameTubes(ChainStay/CenterLine/radius_03)
                  set S04_radius   $project::FrameTubes(ChainStay/CenterLine/radius_04)
                  # set bikeGeometry::tube::arcPrecission 5
                }
          }
          
          set orient_select  left
          set centerLineDef [list $S01_length $S02_length $S03_length $S04_length $S05_length \
                                  $S01_angle  $S02_angle  $S03_angle  $S04_angle \
                                  $S01_radius $S02_radius $S03_radius $S04_radius]
                                  
              # -- get smooth centerLine
          set retValues     [bikeGeometry::tube::init_centerLine $centerLineDef] 
          set centerLine    [lindex $retValues 0]
          set ctrLines      [lindex $retValues 1]
               # puts "  -> \$centerLine $centerLine"
               # puts "  -> \$centerLine [llength $centerLine]"
               # exit
              # -- get shape of tube
          set outLineLeft   [bikeGeometry::tube::get_tubeShape    $centerLine $tubeProfile left  ]
          set outLineRight  [bikeGeometry::tube::get_tubeShape    $centerLine $tubeProfile right ]
          set outLine       [appUtil::flatten_nestedList $outLineLeft $outLineRight]
              # puts "\n    -> \$outLineLeft   $outLineLeft"
              # puts "\n    -> \$outLineRight  $outLineRight"
              # puts "\n    -> \$outLine       $outLine "
          
          
              # get orientation of tube
          set length    [vectormath::length   $Center(ChainStay_DO) $p_CS_BB]
          set angle     [vectormath::dirAngle $Center(ChainStay_DO) $p_CS_BB]
                # puts "  -> \$length $length"
                # puts "  -> \$angle $angle"
          set point_IS  [bikeGeometry::tube::get_shapeInterSection $outLineLeft $length]       
          set angleIS   [vectormath::dirAngle {0 0} $point_IS]
          set angleRotation [expr $angle - $angleIS]
                # puts "  -> \$point_IS $point_IS"
                # puts "  -> \$angleIS $angleIS"
                # puts "  -> \$angleRotation $angleRotation"
              # -- prepare $outLine for exprot 
          set outLine     [vectormath::rotatePointList {0 0} $outLine $angleRotation]    
          set outLine     [vectormath::addVectorPointList $Center(ChainStay_DO) $outLine]
                # $ext_cvName  create   polygon $outLine    -tags __Tube__  -fill lightgray
             
              # -- prepare $centerLine for export 
          set centerLine  [appUtil::flatten_nestedList $centerLine]
          set centerLine  [vectormath::rotatePointList {0 0} $centerLine $angleRotation]    
          set centerLine  [vectormath::addVectorPointList $Center(ChainStay_DO) $centerLine]
              # $ext_cvName  create   line    $centerLine -tags __CenterLine__  -fill blue
           
              # -- prepare $ctrLines for export 
          set ctrLines    [appUtil::flatten_nestedList $ctrLines]
          set ctrLines    [vectormath::rotatePointList {0 0} $ctrLines $angleRotation]    
  
              # $ext_cvName  create   line    $centerLine -tags __CenterLine__  -fill blue
          
          return [list $centerLine $outLine $ctrLines]
    }

        
        #
        # --- set HeadTube -------------------------
    proc bikeGeometry::get_HeadTube {} {
            variable HeadTube
            variable HeadSet
            variable Steerer

                    set HeadTube(Direction)         [ vectormath::unifyVector     $Steerer(Fork)        $Steerer(Stem) ]
                    set Steerer(Direction)          $HeadTube(Direction)

            project::setValue Result(Tubes/Steerer/Direction)   direction   $HeadTube(Direction)
            project::setValue Result(Tubes/HeadTube/Direction)  direction   $HeadTube(Direction)

                    set HeadTube(Fork)              [ vectormath::addVector     $Steerer(Fork)  $HeadTube(Direction)    $HeadSet(Height_Bottom) ]
                    set HeadTube(Stem)              [ vectormath::addVector     $HeadTube(Fork) $HeadTube(Direction)    $HeadTube(Length) ]
            project::setValue Result(Tubes/HeadTube/Start)      position    $HeadTube(Fork)
            project::setValue Result(Tubes/HeadTube/End)        position    $HeadTube(Stem)

                    set vct_01      [ vectormath::parallel          $HeadTube(Fork) $HeadTube(Stem) [expr 0.5*$HeadTube(Diameter)] ]
                    set vct_ht      [ vectormath::parallel          $HeadTube(Stem) $HeadTube(Fork) [expr 0.5*$HeadTube(Diameter)] ]

                    set polygon     [format "%s %s %s %s" \
                                            [lindex $vct_01 0] [lindex $vct_01 1] \
                                            [lindex $vct_ht 0] [lindex $vct_ht 1] ]
            project::setValue Result(Tubes/HeadTube)            polygon     $polygon
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

                    set vct_st      [ vectormath::parallel          $SeatTube(BottomBracket) $SeatPost(SeatTube) [expr 0.5*$SeatTube(DiameterTT)] ]

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
    }


        #
        # --- set DownTube SeatTube ------------------------
    proc bikeGeometry::get_DownTube_SeatTube {} {
            variable HeadTube
            variable DownTube
            variable SeatTube
            variable SeatPost
            variable Steerer

                    set vct_ht      [ vectormath::parallel          $HeadTube(Stem) $HeadTube(Fork) [expr 0.5*$HeadTube(Diameter)] ]
                    set pt_00       [split [ project::getValue      Result(Tubes/HeadTube/Polygon)    polygon 3 ] , ]
                    set pt_01       [ vectormath::addVector         $pt_00 $HeadTube(Direction) $DownTube(OffsetHT) ]                            ;# bottom intersection DownTube/HeadTube
                    set pt_02       [ vectormath::cathetusPoint     {0 0}  $pt_01 [expr 0.5 * $DownTube(DiameterHT) - $DownTube(OffsetBB) ]]    ;# DownTube lower Vector
                    set vct_cl      [ vectormath::parallel          $pt_02 $pt_01 [expr 0.5 * $DownTube(DiameterHT)] left]                        ;# DownTube centerline Vector
                    set pt_is       [ vectormath::intersectPoint    [lindex $vct_cl 0] [lindex $vct_cl 1]  $SeatTube(BottomBracket)    $SeatPost(SeatTube) ]

                    set SeatTube(DownTube)          $pt_is

                    set DownTube(Direction)     [ vectormath::unifyVector       [lindex $vct_cl 0] [lindex $vct_cl 1] ]
                    set DownTube(HeadTube)      [ vectormath::intersectPoint    [lindex $vct_cl 0] [lindex $vct_cl 1]  $Steerer(Fork)     $Steerer(Stem) ]
                    set DownTube(BottomBracket) [lindex $vct_cl 0]

            project::setValue Result(Tubes/DownTube/Direction)  direction   $DownTube(Direction)
            project::setValue Result(Tubes/DownTube/Start)      position    $DownTube(BottomBracket)
            project::setValue Result(Tubes/DownTube/End)        position    $DownTube(HeadTube)

                    set SeatTube(Direction)        [ vectormath::unifyVector $SeatTube(DownTube) $SeatPost(SeatTube) ]
            project::setValue Result(Tubes/SeatTube/Start)        position    $pt_is

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

                    set dir         [ vectormath::addVector {0 0} $DownTube(Direction) -1]

                    set is_dt_ht    [ tube_intersection $DownTube(DiameterHT) $dir  $HeadTube(Diameter)     $HeadTube(Direction)  $DownTube(HeadTube) ]

                    set polygon     [ list            [lindex $vct_10 1] [lindex $vct_21 0]]
                    lappend polygon [ project::flatten_nestedList $is_dt_ht]
                    lappend polygon [ lindex $vct_22 0] [lindex $vct_11 1]
                    lappend polygon [ lindex $vct_11 0] [ lindex $vct_10 0]

            project::setValue Result(Tubes/DownTube)            polygon     [project::flatten_nestedList $polygon]
            
            
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

            project::setValue Result(Tubes/SeatTube/Start)      position    $SeatTube(BottomBracket)
            project::setValue Result(Tubes/SeatTube/End)        position    $SeatTube(TopTube)
                    
                    set is_st_dt    [ tube_intersection    $SeatTube(DiameterBB) $SeatTube(Direction)  $DownTube(DiameterBB)  $DownTube(Direction)  $SeatTube(DownTube) right ]


                    set polygon     [ list  [lindex $vct_10 1]  [lindex $vct_21 0] \
                                            [lindex $vct_21 1]  [lindex $vct_22 1] \
                                            [lindex $vct_22 0]  [lindex $vct_11 1] ]
                    lappend polygon $is_st_dt

            project::setValue Result(Tubes/SeatTube)                polygon     [project::flatten_nestedList $polygon]
    }


        #
        # --- set SeatStay ------------------------
    proc bikeGeometry::get_SeatStay {} {
            variable SeatStay
            variable ChainStay
            variable TopTube
            variable SeatTube
            variable RearWheel
            variable RearDrop

                    set pt_00       [ vectormath::addVector     $TopTube(SeatTube)  $SeatTube(Direction)  $SeatStay(OffsetTT) ] ; # intersection seatstay / seattube
                    set pt_01       [ lindex [ vectormath::parallel     $RearWheel(Position)  $pt_00   $RearDrop(OffsetSSPerp) ] 0 ]

                    set SeatStay(Direction)     [ vectormath::unifyVector $pt_01 $pt_00 ]
            project::setValue Result(Tubes/SeatStay/Direction)  direction   $SeatStay(Direction)    ;# direction vector of SeatStay

                    set pt_10       [ vectormath::addVector     $pt_01  $SeatStay(Direction)  $RearDrop(OffsetSS) ]

                        # -- exception if Tube is shorter than taper length
                        set tube_length          [ vectormath::length $pt_10 $pt_00 ]
                            if { [expr $tube_length - $SeatStay(TaperLength) -50] < 0 } {
                                puts "            ... exception:  SeatStay  TaperLength ... $tube_length / $SeatStay(TaperLength)"
                                set taper_length    [ expr $tube_length -50 ]
                                puts "                         -> $taper_length"
                            } else {
                                set taper_length    $SeatStay(TaperLength)
                            }

                    set pt_11       [ vectormath::addVector        $pt_10  $SeatStay(Direction)  $taper_length ]
                    set pt_12       $pt_00
                    set vct_10      [ vectormath::parallel $pt_10 $pt_11 [expr 0.5*$SeatStay(DiameterCS)] ]
                    set vct_11      [ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$SeatStay(DiameterST)] ]
                    set vct_12      [ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$SeatStay(DiameterST)] left]
                    set vct_13      [ vectormath::parallel $pt_10 $pt_11 [expr 0.5*$SeatStay(DiameterCS)] left]

                set SeatStay(SeatTube)      $pt_00
                set SeatStay(RearWheel)     $pt_10
            project::setValue Result(Tubes/SeatStay/Start)      position    $SeatStay(RearWheel)
            project::setValue Result(Tubes/SeatStay/End)        position    $SeatStay(SeatTube)

                    set dir         [ vectormath::addVector {0 0} $SeatStay(Direction) -1]
                    set offset      [ expr 0.5 * ($SeatTube(DiameterTT) - $SeatStay(DiameterST)) ]
                    set is_ss_st    [ tube_intersection $SeatStay(DiameterST) $dir  $SeatTube(DiameterTT)      $SeatTube(Direction)  $SeatStay(SeatTube)  right $offset]

                set SeatStay(debug)             $is_ss_st

                    set polygon     [ project::flatten_nestedList  $is_ss_st ]
                    set polygon     [ lappend polygon [lindex $vct_12 0] [lindex $vct_13 0] \
                                                      [lindex $vct_10 0] [lindex $vct_11 0] ]
            project::setValue Result(Tubes/SeatStay)          polygon     [project::flatten_nestedList $polygon]

                #
                # --- set SeatStay / ChainStay - Intersection
                    set ChainStay(SeatStay_IS)      [ vectormath::intersectPoint $SeatStay(SeatTube) $SeatStay(RearWheel) $ChainStay(BottomBracket) $ChainStay(RearWheel) ];# intersection of ChainStay and SeatStay centerlines
            project::setValue Result(Tubes/ChainStay/SeatStay_IS)   position    $ChainStay(SeatStay_IS) ;# Point on the Ground perp. to BB
    }


        #
        # --- set ForkBlade -----------------------
    proc bikeGeometry::get_Fork {} {
            variable Fork
            variable ForkBlade
            variable Steerer
            variable HeadTube
            variable FrontWheel
            variable FrontBrake
                    
            variable myFork
            
            set domInit $project::initDOM
                # set     domInit $::APPL_Config(root_InitDOM)
            
                    set pt_00       $Steerer(Fork)
                    set pt_99       $FrontWheel(Position)
                    set pt_01       [ vectormath::addVector $pt_00 $HeadTube(Direction) -$Fork(BladeOffsetCrown) ]
                    set pt_02       [ lindex [ vectormath::parallel  $pt_00  $pt_01  $Fork(BladeOffsetCrownPerp) left ] 1] ;# centerpoint of Blade in ForkCrown

                    
            switch -glob $project::Rendering(Fork) {
                        SteelLugged {
                                    #puts "SteelLugged"
                                    #puts "$project::Rendering(ForkBlade)"
                                    #puts "$Fork(Rendering)"
                                    
                                    variable myFork
                                    
                                    dict create dict_ForkBlade {}
                                    dict append dict_ForkBlade env \
                                            [list dropOutPosition $FrontWheel(Position) \
                                                  forkHeight      $Fork(Height)   \
                                                  forkRake        $Fork(Rake)     \
                                                  crownOffset     $Fork(BladeOffsetCrown)     \
                                                  crownPerp       $Fork(BladeOffsetCrownPerp) \
                                                  dropOutOffset   $Fork(BladeOffsetDO)        \
                                                  dropOutPerp     $Fork(BladeOffsetDOPerp)    \
                                                  headTubeAngle   $HeadTube(Angle) \
                                            ]
                                    dict append dict_ForkBlade blade \
                                            [list type            $project::Rendering(ForkBlade)  \
                                                  endLength       $Fork(BladeEndLength) \
                                                  bendRadius      $Fork(BladeBendRadius) \
                                            ]
                                    dict append dict_ForkBlade profile \
                                            [list [list 0                       $Fork(BladeDiameterDO)] \
                                                  [list $Fork(BladeTaperLength) $Fork(BladeWith)] \
                                                  [list 200                     $Fork(BladeWith)] \
                                                  [list 500                     $Fork(BladeWith)] \
                                            ]
        
                                    set retValue [bikeGeometry::tube::get_ForkBlade $dict_ForkBlade]
                                    
                                    set outLine         [lindex $retValue 0]
                                    set centerLine      [lindex $retValue 1]
                                    set brakeDefLine    [lindex $retValue 2]
                                    set dropOutAngle    [lindex $retValue 3]
                                    
                                    set dropOutPos      $FrontWheel(Position) 
                                    
                                      # puts "  -> \$outLine       $outLine"
                                      # puts "  -> \$dropOutPos    $dropOutPos"
                                      # puts "  -> \$dropOutAngle  $dropOutAngle"
                                    
                                    set Fork(BrakeOffsetDef)      $brakeDefLine
                                    set Fork(DropoutDirection)    [ vectormath::unifyVector $dropOutPos [vectormath::rotateLine $dropOutPos 10 [expr 180 + $dropOutAngle]] 1]
                                      # puts "  -> \$Fork(DropoutDirection)  $Fork(DropoutDirection)"
                                                
                                                
                                                project::setValue Result(Tubes/ForkBlade)                 polygon     $outLine
                                                project::setValue Result(Lugs/Dropout/Front/Direction)    direction   $Fork(DropoutDirection)   
            
                                                set myFork(CrownFile)         $project::Component(Fork/Crown/File)                                     
                                                set myFork(DropOutFile)       $project::Component(Fork/DropOut/File)
                                                
                                                set myFork(CrownBrakeOffset)  $project::Component(Fork/Crown/Brake/Offset) 
                                                set myFork(CrownBrakeAngle)   $project::Component(Fork/Crown/Brake/Angle)
         
                                                set myFork(BladeBrakeOffset)  $FrontBrake(Offset)
                                            }
                                    
                            SteelLuggedMAX  {
                                        set myFork(CrownOffset)       [[ $domInit selectNodes /root/Fork/SteelLuggedMAX/Crown/Blade/Offset     ]  asText ]
                                        set myFork(CrownOffsetPerp)   [[ $domInit selectNodes /root/Fork/SteelLuggedMAX/Crown/Blade/OffsetPerp ]  asText ]

                                        set myFork(BladeWith)         [[ $domInit selectNodes /root/Fork/SteelLuggedMAX/Blade/Width            ]  asText ]
                                        set myFork(BladeDiameterDO)   [[ $domInit selectNodes /root/Fork/SteelLuggedMAX/Blade/DiameterDO       ]  asText ]
                                        set myFork(BladeTaperLength)  [[ $domInit selectNodes /root/Fork/SteelLuggedMAX/Blade/TaperLength      ]  asText ]
                                        set myFork(BladeBendRadius)   [[ $domInit selectNodes /root/Fork/SteelLuggedMAX/Blade/BendRadius       ]  asText ]
                                        set myFork(BladeEndLength)    [[ $domInit selectNodes /root/Fork/SteelLuggedMAX/Blade/EndLength        ]  asText ]
                                        
                                        set myFork(DropOutOffset)     [[ $domInit selectNodes /root/Fork/SteelLuggedMAX/DropOut/Offset         ]  asText ]
                                        set myFork(DropOutOffsetPerp) [[ $domInit selectNodes /root/Fork/SteelLuggedMAX/DropOut/OffsetPerp     ]  asText ]
                                        
  
                                        dict create dict_ForkBlade {}
                                        dict append dict_ForkBlade env \
                                                [list dropOutPosition   $FrontWheel(Position) \
                                                      forkHeight        $Fork(Height)   \
                                                      forkRake          $Fork(Rake)     \
                                                      crownOffset       $myFork(CrownOffset)     \
                                                      crownPerp         $myFork(CrownOffsetPerp) \
                                                      dropOutOffset     $myFork(DropOutOffset)        \
                                                      dropOutPerp       $myFork(DropOutOffsetPerp)    \
                                                      headTubeAngle     $HeadTube(Angle) \
                                                ]
                                        dict append dict_ForkBlade blade \
                                                [list type              MAX  \
                                                      endLength         $myFork(BladeEndLength) \
                                                      bendRadius        $myFork(BladeBendRadius) \
                                                ]
                                        dict append dict_ForkBlade profile \
                                                [list [list 0                         $myFork(BladeDiameterDO)] \
                                                      [list $myFork(BladeTaperLength) $myFork(BladeWith)] \
                                                      [list 200                       $myFork(BladeWith)] \
                                                      [list 500                       $myFork(BladeWith)] \
                                                ]
            
                                        set retValue [bikeGeometry::tube::get_ForkBlade $dict_ForkBlade]
                                        
                                        set outLine         [lindex $retValue 0]
                                        set centerLine      [lindex $retValue 1]
                                        set brakeDefLine    [lindex $retValue 2]
                                        set dropOutAngle    [lindex $retValue 3]
                                        
                                        set dropOutPos      $FrontWheel(Position) 
                                        
                                          # puts "  -> \$outLine       $outLine"
                              # puts "  -> \$dropOutPos    $dropOutPos"
                              # puts "  -> \$dropOutAngle  $dropOutAngle"
                            
                            set Fork(BrakeOffsetDef)      $brakeDefLine
                            set Fork(DropoutDirection)    [ vectormath::unifyVector $dropOutPos [vectormath::rotateLine $dropOutPos 10 [expr 180 + $dropOutAngle]] 1]
                              # puts "  -> \$Fork(DropoutDirection)  $Fork(DropoutDirection)"
                                        
                                        project::setValue Result(Tubes/ForkBlade)                 polygon     $outLine
                                        project::setValue Result(Lugs/Dropout/Front/Direction)    direction   $Fork(DropoutDirection)
                                        
                                        set myFork(CrownFile)         [[ $domInit selectNodes /root/Fork/SteelLuggedMAX/Crown/File             ]  asText ]
                                        set myFork(DropOutFile)       [[ $domInit selectNodes /root/Fork/SteelLuggedMAX/DropOut/File           ]  asText ]
                                        
                                        set myFork(CrownBrakeOffset)  [[ $domInit selectNodes /root/Fork/SteelLuggedMAX/Crown/Brake/Offset     ]  asText ]
                                        set myFork(CrownBrakeAngle)   [[ $domInit selectNodes /root/Fork/SteelLuggedMAX/Crown/Brake/Angle      ]  asText ]

                                        set myFork(BladeBrakeOffset)  [[ $domInit selectNodes /root/Fork/SteelLuggedMAX/Brake/Offset]  asText ]                                        
 
                                    }                            
                            Composite  {
                                        project::setValue Result(Tubes/ForkBlade)       polygon     [ set_compositeFork {}]
                                        
                                        set pt_60  [ vectormath::rotateLine $pt_00  20.5 [expr  90 - $HeadTube(Angle)]]
                                        set pt_61  [ vectormath::rotateLine $pt_60 100.0 [expr 180 - $HeadTube(Angle)]]
                                        set Fork(BrakeOffsetDef) [project::flatten_nestedList $pt_61 $pt_60 ]
                                        
                                        set myFork(CrownFile)         [[ $domInit selectNodes /root/Fork/Composite/Crown/File         ]  asText ]                           
                                        set myFork(DropOutFile)       [[ $domInit selectNodes /root/Fork/Composite/DropOut/File       ]  asText ]
                                        
                                        set myFork(CrownBrakeOffset)  [[ $domInit selectNodes /root/Fork/Composite/Crown/Brake/Offset ]  asText ]
                                        set myFork(CrownBrakeAngle)   [[ $domInit selectNodes /root/Fork/Composite/Crown/Brake/Angle  ]  asText ]
                                        
                                        set myFork(BladeBrakeOffset)  [[ $domInit selectNodes /root/Fork/Composite/Brake/Offset       ]  asText ]  
                                   }
						    Composite_TUSK  {
                                        project::setValue Result(Tubes/ForkBlade)       polygon     [ set_compositeFork TUSK]
                                        
                                        set pt_60  [ vectormath::rotateLine $pt_00  20.5 [expr  90 - $HeadTube(Angle)]]
                                        set pt_61  [ vectormath::rotateLine $pt_60 100.0 [expr 180 - $HeadTube(Angle)]]
                                        set Fork(BrakeOffsetDef) [project::flatten_nestedList $pt_61 $pt_60 ]
                                        
                                        set myFork(CrownFile)         [[ $domInit selectNodes /root/Fork/Composite_TUSK/Crown/File         ]  asText ]                           
                                        set myFork(DropOutFile)       [[ $domInit selectNodes /root/Fork/Composite_TUSK/DropOut/File       ]  asText ]
                                        
                                        set myFork(CrownBrakeOffset)  [[ $domInit selectNodes /root/Fork/Composite_TUSK/Crown/Brake/Offset ]  asText ]
                                        set myFork(CrownBrakeAngle)   [[ $domInit selectNodes /root/Fork/Composite_TUSK/Crown/Brake/Angle  ]  asText ]
                                        
                                        set myFork(BladeBrakeOffset)  [[ $domInit selectNodes /root/Fork/Composite_TUSK/Brake/Offset       ]  asText ]  
                                   }

                            Suspension* {
                                        project::setValue Result(Tubes/ForkBlade)       polygon     [ set_suspensionFork ]
                                        
                                        set forkSize  $project::Rendering(Fork)
                                        
                                        set pt_60  [ vectormath::rotateLine $pt_00  40.0 [expr  90 - $HeadTube(Angle)]]
                                        set pt_61  [ vectormath::rotateLine $pt_60 100.0 [expr 180 - $HeadTube(Angle)]]
                                        set Fork(BrakeOffsetDef) [project::flatten_nestedList $pt_61 $pt_60 ]

                                        set myFork(CrownFile)         [[ $domInit selectNodes /root/Fork/_Suspension/Crown/File ] asText ]
                                        set myFork(DropOutFile)       [[ $domInit selectNodes /root/Fork/$forkSize/DropOut/File ] asText ]                    
                                        
                                        set myFork(CrownBrakeOffset)  [[ $domInit selectNodes /root/Fork/_Suspension/Crown/Brake/Offset     ]  asText ]
                                        set myFork(CrownBrakeAngle)   [[ $domInit selectNodes /root/Fork/_Suspension/Crown/Brake/Angle      ]  asText ]
                                        
                                        set myFork(BladeBrakeOffset)  [[ $domInit selectNodes /root/Fork/$forkSize/Brake/Offset]  asText ]  
                                    }
                    }



                        #
                # --- set Fork Dropout --------------------

                #
                # --- set Fork Crown ----------------------
            set Fork(CrownDirection)    $Steerer(Direction)
            project::setValue Result(Lugs/ForkCrown/Direction)        direction    $Fork(CrownDirection)
    }


        #
        # --- set Steerer -------------------------
    proc bikeGeometry::get_Steerer {} {
            variable HeadTube
            variable Steerer

            project::setValue Result(Tubes/Steerer/End)        position     $Steerer(Stem)

                    if {$HeadTube(Diameter) > 35 } {
                        set SteererDiameter 28.6
                    } else {
                        set SteererDiameter 25.4
                    }
                    set hlp_01      [ vectormath::addVector         $Steerer(Stem) [ vectormath::unifyVector $Steerer(Fork)  $Steerer(Stem) 10 ] ]
                    set vct_01      [ vectormath::parallel          $Steerer(Fork)  $hlp_01         [expr 0.5 * $SteererDiameter] ]
                    set vct_ht      [ vectormath::parallel          $hlp_01         $Steerer(Fork)  [expr 0.5 * $SteererDiameter] ]
                    set polygon     [format "%s %s %s %s" \
                                            [lindex $vct_01 0] [lindex $vct_01 1] \
                                            [lindex $vct_ht 0] [lindex $vct_ht 1] ]
            # puts $polygon
            project::setValue Result(Tubes/Steerer)            polygon     $polygon
    }


        #
        # --- set SeatPost ------------------------
    proc bikeGeometry::get_SeatPost {} {
            variable Saddle
            variable SeatPost
            variable TopTube
            variable SeatTube

                    set pt_00       $SeatPost(SeatTube)
                    set pt_99       {0 0}

                    set pt_01       $SeatPost(Saddle)

                    set vct_01      [ vectormath::parallel  $pt_01 [ vectormath::addVector $pt_01 {100 0}] 35 ]
                    set vct_05      [ vectormath::parallel  $pt_01 [ vectormath::addVector $pt_01 {100 0}] 20 ]
                    set vct_06      [ vectormath::parallel  $pt_01 [ vectormath::addVector $pt_01 {100 0}] 30 ]
                    set pt_02       [ vectormath::intersectPoint [lindex $vct_01 0] [lindex $vct_01 1]  {0 0} $SeatPost(SeatTube) ]

                    set pt_10       $pt_01
                    set pt_11       $pt_02
                    set pt_12       $TopTube(SeatTube)
                    set pt_20       [ vectormath::addVector $SeatPost(SeatTube) [ vectormath::unifyVector $SeatPost(SeatTube) {0 0} 75.0 ] ]
                    set vct_10      [ vectormath::parallel  $pt_12 $pt_20 [expr 0.5 * $SeatPost(Diameter)] ]
                    set vct_11      [ vectormath::parallel  $pt_12 $pt_20 [expr 0.5 * $SeatPost(Diameter)] left]
                    set vct_15      [ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * $SeatPost(Diameter) -5] left]
                    # puts " -> SeatPost"
                    set polyline    "13.5989,-1.3182 13.4789,-2.5115 13.1643,-5.6659 12.5937,-9.0769 11.7884,-12.7185 10.9667,-15.7283 10.1936,-18.175 9.5246,-20.0034 8.5409,-22.3099 7.2154,-24.9485 5.5208,-27.773 3.43,-30.6374 1.5276,-32.7944 -0.3539,-34.7937 -2.347,-36.636 -4.3817,-38.2747 -6.707,-39.8938 -8.7112,-41.1006 -11.212,-42.3902 -13.5496,-43.4003 -16.29,-44.3671 -18.7682,-45.0546 -21.3969,-45.5995 -24.5756,-46.0134 -28.0195,-46.1561 -31.8065,-45.983 -34.8534,-45.5653 -37.9101,-44.8966 -40.1926,-44.227 -42.3258,-43.4623 -43.5886,-42.6367 -44.1867,-42.1325 -44.3757,-41.3807 -43.9618,-39.6722 -43.681,-38.9927 -43.2884,-38.7329 -42.7931,-38.5496 -42.283,-38.5839 -41.8194,-38.7683 -41.1634,-39.1064 -39.6321,-39.8205 -37.8997,-40.5087 -35.5587,-41.2516 -33.218,-41.7936 -30.7338,-42.162 -28.6077,-42.315 -25.9892,-42.3033 -23.1653,-42.042 -20.4089,-41.5287 -17.7059,-40.7334 -15.0552,-39.7382 -12.2211,-38.3082 -9.8302,-36.7916 -7.7268,-35.1785 -5.9291,-33.5486 -4.295,-31.8174 -2.9598,-30.1792 -1.5385,-28.1425 -0.794,-25.3638 -1.1078,-22.226 -0.794,-25.3638 -1.5385,-28.1425 -2.9598,-30.1792 -4.295,-31.8174 -5.9291,-33.5486 -7.7268,-35.1785 -9.8302,-36.7916 -12.2211,-38.3082 -15.0552,-39.7382 -17.7059,-40.7334 -20.4089,-41.5287 -23.1653,-42.042 -25.9892,-42.3033 -28.6077,-42.315 -30.7338,-42.162 -33.218,-41.7936 -35.5587,-41.2516 -37.8997,-40.5087 -39.6321,-39.8205 -41.1634,-39.1064 -41.8194,-38.7683 -42.283,-38.5839 -42.7931,-38.5496 -43.2884,-38.7329 -43.681,-38.9927 -43.4595,-38.4572 -43.1745,-38.0921 -42.8444,-37.8607 -42.3437,-37.6034 -41.6384,-37.325 -40.8501,-37.0395 -40.0765,-36.7304 -39.303,-36.3718 -38.5153,-35.9378 -37.6988,-35.4023 -34.0397,-32.9438 -30.1695,-30.1224 -26.3083,-26.7006 -21.7663,-21.7594 -18.0718,-16.7489 -16.5658,-14.4083 -15.8413,-12.8905 -15.1253,-11.0864 -14.6535,-9.7442 -14.1928,-8.2413 -13.8083,-6.6772 -13.5652,-5.1515 -13.5287,-3.7637 -13.601,1.3182"
                    set polyline    "12.6235,-1.2235 12.6243,-1.4196 12.5121,-2.331 12.2201,-5.2588 11.6905,-8.4246 10.9431,-11.8045 10.1805,-14.598 9.4629,-16.8689 8.842,-18.5659 7.929,-20.7067 6.6987,-23.1557 5.1259,-25.7772 3.1854,-28.4358 1.4197,-30.4377 -0.3266,-32.2934 -2.1765,-34.0033 -4.065,-35.5242 -6.2232,-37.027 -8.0833,-38.147 -10.4044,-39.344 -12.574,-40.2815 -15.1175,-41.1788 -17.4176,-41.8169 -19.8574,-42.3226 -22.8077,-42.7068 -26.0041,-42.8392 -29.519,-42.6786 -32.3469,-42.2909 -35.184,-41.6703 -37.3024,-41.0488 -39.2823,-40.339 -40.4544,-39.5728 -41.0095,-39.1048 -41.1849,-38.407 -40.8008,-36.8213 -40.5401,-36.1906 -40.3753,-36.0544 -40.1758,-35.9495 -39.946,-35.8356 -39.716,-35.7794 -39.4541,-35.7718 -39.2426,-35.8112 -39.0317,-35.8909 -38.8123,-35.9823 -38.2035,-36.2962 -36.7822,-36.9589 -35.1743,-37.5977 -33.0015,-38.2872 -30.829,-38.7902 -28.5234,-39.1322 -26.55,-39.2742 -24.1197,-39.2633 -21.4987,-39.0208 -18.9404,-38.5444 -16.4317,-37.8062 -13.9714,-36.8825 -11.341,-35.5553 -9.1219,-34.1477 -7.1697,-32.6505 -5.5012,-31.1377 -3.9845,-29.531 -2.7452,-28.0105 -1.4261,-26.1201 -0.7351,-23.5411 -1.0263,-20.6288 -0.7351,-23.5411 -1.4261,-26.1201 -2.7452,-28.0105 -3.9845,-29.531 -5.5012,-31.1377 -7.1697,-32.6505 -9.1219,-34.1477 -11.341,-35.5553 -13.9714,-36.8825 -16.4317,-37.8062 -18.9404,-38.5444 -21.4987,-39.0208 -24.1197,-39.2633 -26.55,-39.2742 -28.5234,-39.1322 -30.829,-38.7902 -33.0015,-38.2872 -35.1743,-37.5977 -36.7822,-36.9589 -38.2035,-36.2962 -38.8123,-35.9823 -39.0317,-35.8909 -39.2426,-35.8112 -39.4541,-35.7718 -39.716,-35.7794 -39.946,-35.8356 -40.1758,-35.9495 -40.3876,-36.0645 -40.5401,-36.1906 -40.3346,-35.6936 -40.07,-35.3547 -39.7637,-35.14 -39.2989,-34.9012 -38.6443,-34.6428 -37.9127,-34.3778 -37.1947,-34.0909 -36.4768,-33.7581 -35.7457,-33.3553 -34.9878,-32.8582 -31.5917,-30.5764 -27.9996,-27.9578 -24.4159,-24.7819 -20.2003,-20.1957 -16.7713,-15.5453 -15.3735,-13.3729 -14.7011,-11.9642 -14.0365,-10.2897 -13.5986,-9.044 -13.171,-7.6491 -12.8142,-6.1974 -12.5885,-4.7813 -12.5546,-3.4932 -12.6218,1.2235" 
                    
                    
                    
                    set headGeom  {}
                    foreach {xy}   $polyline {
                        foreach {x y} [split $xy ,] break;
                        lappend headGeom $x [expr -1.0 * $y]
                    }
                        # puts $headGeom
                    set vct_30      [ vectormath::unifyVector $SeatPost(SeatTube) {0 0} 48.5 ]
                    set vct_31      [ vectormath::unifyVector {0 0} $SeatTube(Direction) $SeatPost(PivotOffset) ]
                      # set vct_31      [ vectormath::unifyVector {0 0} $SeatTube(Direction) $SeatPost(PivotOffset) ]
                    set vct_32      [ vectormath::addVector $vct_30 $vct_31]
                    set pt_30       [ vectormath::addVector $SeatPost(SeatTube) $vct_32 ]
                      # set pt_30       [ vectormath::addVector $SeatPost(SeatTube) [ vectormath::unifyVector $SeatPost(SeatTube) {0 0} 52.5 ] ]

                    set headGeom    [ vectormath::addVectorPointList  $pt_30  [ vectormath::rotatePointList {0 0} $headGeom [expr 90 - $SeatTube(Angle)] ] ]
                        # puts $headGeom
                    set head_P1     [ lrange $headGeom 0 1 ]
                    set head_P2     [ lrange $headGeom end-1 end ]

                    lappend          polygon     [lindex $vct_10 0]  [lindex $vct_10 1]
                    lappend          polygon     $headGeom
                    lappend          polygon     [lindex $vct_11 1]  [lindex $vct_11 0]

            project::setValue Result(Components/SeatPost)    polygon     [project::flatten_nestedList $polygon]
    }


        #
        # --- set HeadSet -------------------------
    proc bikeGeometry::get_HeadSet {} {
            variable HeadTube
            variable HeadSet
            variable Steerer

                    set pt_10       $HeadTube(Fork)
                    set pt_12       $Steerer(Fork)
                    set pt_11       [ vectormath::addVector $pt_12 $HeadTube(Direction) [expr 0.5 * $HeadSet(Height_Bottom)]]
                if {$HeadSet(Height_Bottom) > 8} {
                    set vct_10      [ vectormath::parallel  $pt_10 $pt_11 [expr 0.5 * $HeadTube(Diameter)] ]
                    set vct_11      [ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * $HeadSet(Diameter) ] ]
                    set vct_12      [ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * $HeadSet(Diameter) ] left]
                    set vct_13      [ vectormath::parallel  $pt_10 $pt_11 [expr 0.5 * $HeadTube(Diameter)] left]
                    set polygon     [list   [lindex $vct_10 0]  [lindex $vct_11 0] \
                                            [lindex $vct_12 0]  [lindex $vct_11 0] \
                                            [lindex $vct_11 1] \
                                            [lindex $vct_12 1]  [lindex $vct_12 0] [lindex $vct_13 0] ]
                } else {
                    if {$HeadSet(Height_Bottom) < 0.1} {
                        set polygon     [list 0 0 0 0]
                    } else {
                        set SteererDM   28.6 ;# believe that there is no not integrated Headset with this size
                        set vct_11      [ vectormath::parallel  $pt_10 $pt_12 [expr 0.5 * $SteererDM ] ]
                        set vct_12      [ vectormath::parallel  $pt_10 $pt_12 [expr 0.5 * $SteererDM ] left]
                        set polygon     [list   [lindex $vct_11 0]  [lindex $vct_11 1] \
                                                [lindex $vct_12 1]  [lindex $vct_12 0] ]
                    }
                }

            project::setValue Result(Components/HeadSet/Bottom)    polygon     [project::flatten_nestedList $polygon]

                    if {$HeadSet(Height_Top) < 2} {    set HeadSet(Height_Top) 2}
                    if {$HeadSet(Height_Top) > 8} {
                            set majorDM     $HeadSet(Diameter)
                            set height_00    [expr 0.5 * $HeadSet(Height_Top)]
                    } else {
                            set majorDM     $HeadTube(Diameter)
                            set height_00    1
                    }
                    set pt_12       $HeadTube(Stem)
                    set pt_11       [ vectormath::addVector $pt_12 $HeadTube(Direction) $height_00]
                    set pt_10       [ vectormath::addVector $pt_11 $HeadTube(Direction) [expr $HeadSet(Height_Top) - $height_00]]
                        # puts "\n\n"
                        # puts "   pt_10:  $pt_10"
                        # puts "   pt_11:  $pt_11"
                        # puts "   pt_12:  $pt_12"
                        # puts "\n\n"

            set HeadSet(Stem)               $pt_10
                    set vct_10      [ vectormath::parallel  $pt_10 $pt_11 [expr 0.5 * $HeadSet(ShimDiameter)] ]
                    set vct_11      [ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * $majorDM ] ]
                    set vct_12      [ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * $majorDM ] left]
                    set vct_13      [ vectormath::parallel  $pt_10 $pt_11 [expr 0.5 * $HeadSet(ShimDiameter)] left]
                    set polygon     [list   [lindex $vct_10 0]  [lindex $vct_11 0] \
                                            [lindex $vct_12 0]  [lindex $vct_11 0] \
                                            [lindex $vct_11 1] \
                                            [lindex $vct_12 1]  [lindex $vct_12 0] [lindex $vct_13 0] ]

            project::setValue Result(Components/HeadSet/Top)    polygon     [project::flatten_nestedList $polygon]
    }


        #
        # --- set Stem ----------------------------
    proc bikeGeometry::get_Stem {} {
            variable HeadTube
            variable HandleBar
            variable HeadSet
            variable Steerer
            variable Stem

                    set pt_00       $HandleBar(Position)
                    set pt_01       $Steerer(Stem)
                    set pt_02       $HeadSet(Stem)

                    # -- ceck coincidence
                    set checkStem           [ vectormath::checkPointCoincidence $pt_00 $pt_01]
                    if {$checkStem == 0} {
                        # puts "   ... no Stem required"
                        project::setValue Result(Components/Stem)   polygon     {}
                        return
                    }

                    set Stem(Direction)     [ vectormath::unifyVector $pt_01 $pt_00 ]
                    set angle                           [ vectormath::angle {1 0}    {0 0}    $Stem(Direction) ]
                    set clamp_SVGPolygon    "-18.8336,-17.9999 -15.7635,-18.3921 -13.3549,-19.887 -11.1307,-22.1168 -10.0644,-24.1389 -9.7316,-24.4732 -9.8958,-23.3099 -10.3089,-21.9026 -11.1479,-19.9125 -12.0719,-17.777 -15.3406,-11.3784 -16.1873,-10.0012 -17.4384,-9.0427 -18.8336,-8.3572 -17.4384,-9.0427 -16.1873,-10.0012 -15.3406,-11.3784 -12.0719,-17.777 -11.1479,-19.9125 -10.3089,-21.9026 -9.8958,-23.3099 -9.7316,-24.4732 -9.4316,-24.7774 -8.6838,-24.9999 -0.8,-24.9999 -0.8,-15.8802 0.8,-15.8802 0.8,-24.9998 5.6669,-24.9998 6.3699,-24.8858 6.9818,-24.5172 7.4284,-24.07 13.0499,-18.7437 13.049,-23.6727 12.6125,-24.0796 12.5936,-20.4963 12.6125,-24.0796 7.4284,-24.07 13.2207,-18.5818 15.8552,-15.7422 17.8482,-13.2995 19.8206,-9.913 20.8437,-7.292 21.5329,-4.4455 21.8005,-2.0944 21.9,0.0001 21.8005,2.0946 21.5329,4.4457 20.8437,7.2922 19.8206,9.9132 17.8482,13.2997 15.8552,15.7424 13.2207,18.582 7.4284,24.0702 12.6125,24.0798 12.5936,20.4965 12.6125,24.0798 13.049,23.6729 13.0499,18.7439 7.4284,24.0702 6.9818,24.5174 6.3699,24.886 5.6669,25 0.8,25 0.8,15.8804 4.18,15.3448 7.4163,14.0676 10.1772,12.2159 12.523,9.7973 14.299,6.9605 15.506,3.5323 15.9,0.0001 15.506,-3.5321 14.299,-6.9603 12.523,-9.7971 10.1772,-12.2157 7.4163,-14.0674 4.18,-15.3446 0.8,-15.8802 -0.8,-15.8802 -3.4694,-15.544 -6.2265,-14.634 -9.2433,-12.9378 -11.6453,-10.8246 -13.5388,-8.3403 -14.8801,-5.6139 -15.6719,-2.6977 -15.9,0.0001 -15.6719,2.6979 -14.8801,5.6141 -13.5388,8.3405 -11.6453,10.8248 -9.2433,12.938 -6.2265,14.6342 -3.4694,15.5442 -0.8,15.8804 0.8,15.8804 -0.8,15.8804 -0.8,25.0001 -8.6838,25.0001 -9.3776,24.6754 -9.7467,23.9553 -9.8958,23.3101 -10.3089,21.9028 -11.1479,19.9127 -12.0719,17.7772 -15.3406,11.3786 -16.1873,10.0014 -17.4384,9.0429 -18.8336,8.3574 -17.4384,9.0429 -16.1873,10.0014 -15.3406,11.3786 -12.0719,17.7772 -11.1479,19.9127 -10.3089,21.9028 -9.8958,23.3101 -9.7467,23.9553 -11.1307,22.117 -13.3549,19.8872 -15.7635,18.3923 -18.8336,18.0001 "
                    set clamp_SVGPolygon    "-20.2619,-17 -16.6918,-17.4561 -13.8908,-19.1945 -11.3044,-21.7874 -10.0644,-24.1389 -9.7316,-24.4732 -9.8958,-23.3099 -10.3089,-21.9026 -11.1479,-19.9125 -12.0719,-17.777 -15.3406,-11.3784 -16.1873,-10.0012 -17.4384,-9.0427 -18.8336,-8.3572 -17.4384,-9.0427 -16.1873,-10.0012 -15.3406,-11.3784 -12.0719,-17.777 -11.1479,-19.9125 -10.3089,-21.9026 -9.8958,-23.3099 -9.7316,-24.4732 -9.4316,-24.7774 -8.6838,-24.9999 -0.8,-24.9999 -0.8,-15.8802 0.8,-15.8802 0.8,-24.9998 5.6669,-24.9998 6.3699,-24.8858 6.9818,-24.5172 7.4284,-24.07 13.0499,-18.7437 13.049,-23.6727 12.6125,-24.0796 12.5936,-20.4963 12.6125,-24.0796 7.4284,-24.07 13.2207,-18.5818 15.8552,-15.7422 17.8482,-13.2995 19.8206,-9.913 20.8437,-7.292 21.5329,-4.4455 21.8005,-2.0944 21.9,0.0001 21.8005,2.0946 21.5329,4.4457 20.8437,7.2922 19.8206,9.9132 17.8482,13.2997 15.8552,15.7424 13.2207,18.582 7.4284,24.0702 12.6125,24.0798 12.5936,20.4965 12.6125,24.0798 13.049,23.6729 13.0499,18.7439 7.4284,24.0702 6.9818,24.5174 6.3699,24.886 5.6669,25 0.8,25 0.8,15.8804 4.18,15.3448 7.4163,14.0676 10.1772,12.2159 12.523,9.7973 14.299,6.9605 15.506,3.5323 15.9,0.0001 15.506,-3.5321 14.299,-6.9603 12.523,-9.7971 10.1772,-12.2157 7.4163,-14.0674 4.18,-15.3446 0.8,-15.8802 -0.8,-15.8802 -3.4694,-15.544 -6.2265,-14.634 -9.2433,-12.9378 -11.6453,-10.8246 -13.5388,-8.3403 -14.8801,-5.6139 -15.6719,-2.6977 -15.9,0.0001 -15.6719,2.6979 -14.8801,5.6141 -13.5388,8.3405 -11.6453,10.8248 -9.2433,12.938 -6.2265,14.6342 -3.4694,15.5442 -0.8,15.8804 0.8,15.8804 -0.8,15.8804 -0.8,25.0001 -8.6838,25.0001 -9.3776,24.6754 -9.7467,23.9553 -9.8958,23.3101 -10.3089,21.9028 -11.1479,19.9127 -12.0719,17.7772 -15.3406,11.3786 -16.1873,10.0014 -17.4384,9.0429 -18.8336,8.3574 -17.4384,9.0429 -16.1873,10.0014 -15.3406,11.3786 -12.0719,17.7772 -11.1479,19.9127 -10.3089,21.9028 -9.8958,23.3101 -9.7467,23.9553 -11.1307,22.117 -13.8952,19.3455 -16.8889,17.4875 -20.7048,17 "

                        set polygon         [ string map {"," " "}  $clamp_SVGPolygon ]
                        set polygon         [ coords_flip_y $polygon]
                        set polygon         [ vectormath::addVectorPointList [list $HandleBar(Distance) $HandleBar(Height)] $polygon]
                        set polygon         [ vectormath::rotatePointList $HandleBar(Position) $polygon $angle ]

                    set polygonLength   [ llength $polygon  ]
                    set pt_099          [ list [lindex $polygon 0] [lindex $polygon 1] ]
                    set pt_000          [ list [lindex $polygon $polygonLength-2] [lindex $polygon $polygonLength-1] ]
                    set stemWidth       [ vectormath::length $pt_099 $pt_000 ]
                    set stemDiameter    34
                    set vct_099         [ vectormath::parallel $pt_01 $pt_00 [expr 0.5 * $stemWidth        ] left]
                    set vct_000         [ vectormath::parallel $pt_01 $pt_00 [expr 0.5 * $stemWidth        ] ]
                    set vct_010         [ vectormath::parallel $pt_02 $pt_01 [expr 0.5 * $stemDiameter    + 4 ] ]
                    set pt_095          [ vectormath::intersectPoint [lindex $vct_099 0] [lindex $vct_099 1]  [lindex $vct_010 0] [lindex $vct_010 1] ]
                    set pt_50           [ vectormath::intersectPerp $pt_01 $pt_02 $pt_095 ]
                    set pt_51           [ vectormath::addVector $pt_50  [ vectormath::unifyVector {0 0} $HeadTube(Direction) 2] ]
                    set pt_005          [ vectormath::intersectPoint [lindex $vct_000 0] [lindex $vct_000 1]  [lindex $vct_010 0] [lindex $vct_010 1] ]
                    set pt_12           [ vectormath::intersectPerp $pt_01 $pt_02 $pt_005 ]
                    set pt_11           [ vectormath::addVector $pt_12 [ vectormath::unifyVector {0 0} $HeadTube(Direction) -2] ]
                    set vct_020         [ vectormath::parallel $pt_11 $pt_51 [expr 0.5 * $stemDiameter ] ]
                    set vct_021         [ vectormath::parallel $pt_11 $pt_51 [expr 0.5 * $stemDiameter ] left ]
                    set vct_030         [ vectormath::parallel $HeadSet(Stem) $pt_51 [expr 0.5 * $HeadSet(ShimDiameter) ] ];# ShimDiameter from HeadSet definition above
                    set vct_031         [ vectormath::parallel $HeadSet(Stem) $pt_51 [expr 0.5 * $HeadSet(ShimDiameter) ] left ]
                    set vct_040         [ vectormath::parallel [lindex  $vct_021 1] [lindex  $vct_020 1] 5  left]

                    set polygon         [ lappend polygon   $pt_005 \
                                                            [lindex  $vct_020 0] [lindex  $vct_021 0] [lindex  $vct_020 0] \
                                                            [lindex  $vct_030 0] [lindex  $vct_031 0] [lindex  $vct_021 0] \
                                                            [lindex  $vct_021 1] [lindex  $vct_020 1] [lindex  $vct_021 1] \
                                                            [lindex  $vct_040 0] [lindex  $vct_040 1] [lindex  $vct_020 1] \
                                                            $pt_095 ]
            project::setValue Result(Components/Stem)   polygon     [project::flatten_nestedList $polygon]
    }


        #
        # --- fill Result Values ------------------
    proc bikeGeometry::fill_resultValues {} {
            variable BottomBracket
            variable HeadTube
            variable TopTube
            variable Steerer
            variable RearWheel
            variable FrontWheel
            variable Saddle
            variable SeatTube
            variable SeatPost
            variable HandleBar
            
                    #
                    # template of <Result>  .. </Result> is defined in
                    # 
                    #   /etc/initTemplate.xml
                    # 

                    # puts ""
                    # puts "       ... fill_resultValues"
                    # puts "      -------------------------------"
                    # puts "           "
                    
         


                # --- BottomBracket
                #
            set position    $BottomBracket(height)

                    # --- BottomBracket/Height
                    #
                set value      [ format "%.3f" [lindex $position 0] ]
                    # puts "                  ... $value"
                project::setValue Result(Length/BottomBracket/Height) value $value


                # --- HeadTube ----------------------------------------
                #
            set position    $HeadTube(Stem)

                    # --- HeadTube/ReachLength
                    #
                    # puts "                ... [ bikeGeometry::get_Object     HeadTube Stem           {0 0} ]"
                set value       [ format "%.3f" [lindex $position 0] ]
                    # puts "                  ... $value"
                project::setValue Result(Length/HeadTube/ReachLength) value $value

                    # --- HeadTube/StackHeight
                    #
                    # puts "                ... [ bikeGeometry::get_Object     HeadTube Stem           {0 0} ]"
                set value       [ format "%.3f" [lindex $position 1] ]
                    # puts "                  ... $value"
                project::setValue Result(Length/HeadTube/StackHeight) value $value



                # --- SeatTube ----------------------------------------
                    #
            set position    [ bikeGeometry::get_Object     SeatTube/End    position    {0 0} ]

                    # --- SeatTube/Angle ------------------------------
                    #
            set angle [ vectormath::angle $SeatPost(SeatTube) $SeatTube(BottomBracket) [list -200 [lindex $SeatTube(BottomBracket) 1]] ]
            set angle [ format "%.3f" $angle ]
            project::setValue Result(Angle/SeatTube/Direction) value $angle

                    # --- SeatTube/TubeLength -------------------------
                    #
                    # puts "                   ... [ bikeGeometry::get_Object        SeatTube TopTube    {0 0} ]"
                set value       [ format "%.3f" [ expr hypot([lindex $position 0],[lindex $position 1]) ] ]
                project::setValue Result(Length/SeatTube/TubeLength) value $value

                    # --- SeatTube/TubeHeight -------------------------
                    #
                    # puts "                   ... [ bikeGeometry::get_Object        SeatTube TopTube    {0 0} ]"
                set value        [ format "%.3f" [lindex $position 1] ]
                project::setValue Result(Length/SeatTube/TubeHeight) value $value
                    


                # --- VirtualTopTube ----------------------------------
                #
            set SeatTube(VirtualTopTube)    [ vectormath::intersectPoint [list -500 [lindex $HeadTube(Stem) 1]]  $HeadTube(Stem)  $SeatTube(BottomBracket) $SeatPost(SeatTube) ]
            #set SeatTube(VirtualTopTube)    [ vectormath::intersectPoint [list -500 [lindex $TopTube(HeadTube) 1]]  $TopTube(HeadTube)  $SeatTube(BottomBracket) $SeatPost(SeatTube) ]
            project::setValue Result(Position/SeatTubeVirtualTopTube)    position    $SeatTube(VirtualTopTube)        ;# Point on the SeatTube of virtual TopTube

                    # --- TopTube/VirtualLength -----------------------
                    #
                    # puts "                  ... $value"
                set value       [ format "%.3f" [expr [lindex $HeadTube(Stem) 0] - [lindex $SeatTube(VirtualTopTube) 0] ] ]
                project::setValue Result(Length/TopTube/VirtualLength) value $value

                    # --- SeatTube/VirtualLength ----------------------
                    #
                    # puts "                  ... $value"
                set value       [ format "%.3f" [vectormath::length $SeatTube(VirtualTopTube) {0 0}] ]
                project::setValue Result(Length/SeatTube/VirtualLength) value $value


                # --- Saddle ------------------------------------------
                #
            set position_Saddle      $Saddle(Position)   
            set position_SaddleNose  $Saddle(Nose)            
            set position_SeatTube    [ split [ project::getValue Result(Position/SeatTubeSaddle)    position] ,]
            set position_HandleBar   $HandleBar(Position)
            set position_BB          {0 0}
                  # puts "   fill_resultValues  \$position_Saddle      $position_Saddle"
                  # puts "   fill_resultValues  \$position_SaddleNose  $position_SaddleNose"
                  # puts "   fill_resultValues  \$position_SeatTube    $position_SeatTube"
                  # puts "   \$position_HandleBar   $position_HandleBar"
                  # puts "   \$position_BB          $position_BB"
                
            
                    # --- Saddle/Offset_BB --------------------------------
                    #
                set value        [ format "%.3f" [expr -1 * [lindex $position_Saddle 0]] ]
                    # puts "                  ... $value"
                # project::setValue Result(Length/Saddle/Offset_BB) value $value
                #                  Result(Length/Saddle/Offset_BB)


                # --- Saddle/Offset_BB_ST -----------------------------
                #
                set value       [ format "%.3f" [expr -1 * [lindex $position_SeatTube 0]] ]
                    # puts "                  ... $value"
                project::setValue Result(Length/Saddle/Offset_BB_ST) value $value


                    # --- Saddle/Offset_HB --------------------------------
                    #
                set value       [ format "%.3f" [expr [lindex $position_Saddle 1] - [lindex $position_HandleBar 1]] ]
                    # puts "                  ... $value"
                project::setValue Result(Length/Saddle/Offset_HB) value $value

                
                    # --- Personal/SeatTube_BB ------------------------
                    #               
                  # puts "   \$position_SeatTube  $position_SeatTube"
                  # puts "   \$position_BB  $position_BB"
                set value       [ vectormath::length $position_SeatTube $position_BB]
                set value       [ format "%.3f" $value ]
                project::setValue Result(Length/Saddle/SeatTube_BB) value $value   

                
                    # --- Personal/Offset_BB_Nose -------------------------
                    #
                set value       [ format "%.3f" [expr -1.0 * [lindex $position_SaddleNose 0]] ]
                    # puts "                  ... $value"
                project::setValue Result(Length/Saddle/Offset_BB_Nose) value $value
                set value       [ expr  [lindex $position_HandleBar 0] + [expr -1.0 * [lindex $position_SaddleNose 0]] ]
                set value       [ format "%.3f" $value ]
                project::setValue Result(Length/Personal/SaddleNose_HB) value $value

                

                # --- WheelPosition/front/diagonal --------------------
                #
            set position    $FrontWheel(Position)
                    # puts "                ... $frameCoords::FrontWheel"
                set value       [ format "%.3f" [expr { hypot( [lindex $position 0], [lindex $position 1] ) }] ]
                    # puts "                  ... $value"
                project::setValue Result(Length/FrontWheel/diagonal) value $value


                # --- WheelPosition/front/horizontal ------------------
                #
            set position    $FrontWheel(Position)
                    # puts "                ... $frameCoords::FrontWheel"
                set value       [ format "%.3f" [lindex $position 0] ]
                    # puts "                  ... $value"
                project::setValue Result(Length/FrontWheel/horizontal) value $value


                # --- WheelPosition/rear/horizontal -------------------
                #
            set position    $RearWheel(Position)
                    # puts "                ... $frameCoords::RearWheel"
                set value       [ format "%.3f" [expr -1 * [lindex $position 0]] ]
                    # puts "                  ... $value"
                project::setValue Result(Length/RearWheel/horizontal) value $value


                # --- RearWheel/Radius --------------------------------
                #
            set rimDiameter   [ project::getValue Component(Wheel/Rear/RimDiameter) value ]
            set tyreHeight    [ project::getValue Component(Wheel/Rear/TyreHeight)  value ]
            set value         [ expr 0.5 * $rimDiameter + $tyreHeight ]                
                     puts "                  ... $value"
                project::setValue Result(Length/RearWheel/Radius value $value
              
                # --- FrontWheel/Radius -------------------------------
                #
            set rimDiameter   [ project::getValue Component(Wheel/Front/RimDiameter) value ]
            set tyreHeight    [ project::getValue Component(Wheel/Front/TyreHeight)  value ]
            set value         [ expr 0.5 * $rimDiameter + $tyreHeight ]                
                     puts "                  ... $value"
                project::setValue Result(Length/FrontWheel/Radius value $value
                    
            

            set BB_Position             {0 0}
            set SeatStay(SeatTube)      [ bikeGeometry::get_Object     SeatStay/End            position ]
            set TopTube(SeatTube)       [ bikeGeometry::get_Object     TopTube/Start           position ]
            set TopTube(Steerer)        [ bikeGeometry::get_Object     TopTube/End             position ]
            set Steerer(Stem)           [ bikeGeometry::get_Object     Steerer/End             position ]
            set Steerer(Fork)           [ bikeGeometry::get_Object     Steerer/Start           position ]
            set DownTube(Steerer)       [ bikeGeometry::get_Object     DownTube/End            position ]
            set DownTube(BBracket)      [ bikeGeometry::get_Object     DownTube/Start          position ]
            set ChainSt_SeatSt_IS       [ bikeGeometry::get_Object     ChainStay/SeatStay_IS   position ]

            project::setValue Result(Angle/HeadTube/TopTube)        value    [ get_resultAngle $TopTube(Steerer)      $Steerer(Stem)      $TopTube(SeatTube)  ]
            project::setValue Result(Angle/HeadTube/DownTube)       value    [ get_resultAngle $DownTube(Steerer)     $BB_Position        $Steerer(Fork)      ]
            project::setValue Result(Angle/SeatTube/TopTube)        value    [ get_resultAngle $TopTube(SeatTube)     $BB_Position        $TopTube(Steerer)   ]
            project::setValue Result(Angle/SeatTube/SeatStay)       value    [ get_resultAngle $SeatStay(SeatTube)    $ChainSt_SeatSt_IS  $BB_Position        ]
            project::setValue Result(Angle/BottomBracket/DownTube)  value    [ get_resultAngle $BB_Position           $DownTube(Steerer)  $TopTube(SeatTube)  ]
            project::setValue Result(Angle/BottomBracket/ChainStay) value    [ get_resultAngle $BB_Position           $TopTube(SeatTube)  $ChainSt_SeatSt_IS  ]
            project::setValue Result(Angle/SeatStay/ChainStay)      value    [ get_resultAngle $ChainSt_SeatSt_IS     $BB_Position        $SeatStay(SeatTube) ]
    }


        #
        # --- set FrontDerailleurMount ------------
    proc bikeGeometry::get_DerailleurMountFront {} {
            variable SeatTube
            variable FrontDerailleur

                set FrontDerailleur(Mount)  [ vectormath::rotatePoint   {0 0} [ list $FrontDerailleur(Distance) [expr -1.0*$FrontDerailleur(Offset)] ] [expr 180 - $SeatTube(Angle)] ]

            project::setValue Result(Position/DerailleurMountFront) position    $FrontDerailleur(Mount)
            # puts "    ... \$FrontDerailleur(Mount) $FrontDerailleur(Mount)"
    }



        #
        # --- set BrakePosition - Rear -------------
    proc bikeGeometry::get_BrakePositionRear {} {
            variable RearBrake
            variable RearWheel
            variable SeatStay

            set RimBrakeRadius  [ expr 0.5 * $RearWheel(RimDiameter) ]

            set pt_00           $RearWheel(Position)
            set pt_01           [split [ project::getValue Result(Tubes/SeatStay/Start)      position ] , ]
            set pt_02           [split [ project::getValue Result(Tubes/SeatStay/End)        position ] , ]
            set pt_03           [split [ project::getValue Result(Tubes/SeatStay/Polygon)    polygon 8 ] , ]
            set pt_04           [split [ project::getValue Result(Tubes/SeatStay/Polygon)    polygon 9 ] , ]
            set pt_05           [ vectormath::intersectPerp    $pt_04 $pt_03 $pt_00 ]    ;# point on SeatStay through RearWheel
            set vct_01          [ vectormath::parallel $pt_03 $pt_05 $RearBrake(Offset) ]
            set pt_06           [ lindex $vct_01 1 ]
            set dist_00         [ vectormath::length $pt_00 $pt_06 ]
            set dist_00_Ortho   [ expr sqrt(pow($RimBrakeRadius,2)  - pow($dist_00,2)) ]

            set pt_10           [ vectormath::addVector    $pt_06 [ vectormath::unifyVector {0 0} $SeatStay(Direction) $dist_00_Ortho] ]
            set pt_12           [ vectormath::addVector    $pt_06 [ vectormath::unifyVector {0 0} $SeatStay(Direction) [expr $RearBrake(LeverLength) + $dist_00_Ortho] ] ]
            set pt_13           [ vectormath::intersectPerp $pt_03 $pt_04 $pt_10 ]
            set pt_14           [ vectormath::intersectPerp    $pt_03 $pt_04 $pt_12 ]
                # set pt_14     [ vectormath::intersectPerp    $pt_01 $pt_02 $pt_12 ]


            set RearBrake(Shoe)         $pt_10
            set RearBrake(Help)         $pt_12
            set RearBrake(Definition)   $pt_13
            set RearBrake(Mount)        $pt_14

            project::setValue Result(Position/BrakeRear)    position    $RearBrake(Shoe)
                #
                # - TODO -- remove above line -------
                #
            project::setValue Result(Position/Brake/Rear/Shoe)          position    $RearBrake(Shoe)
            project::setValue Result(Position/Brake/Rear/Help)          position    $RearBrake(Help)
            project::setValue Result(Position/Brake/Rear/Definition)    position    $RearBrake(Definition)
            project::setValue Result(Position/Brake/Rear/Mount)         position    $RearBrake(Mount)
               
             
                                    
                variable DEBUG_Geometry
                # set DEBUG_Geometry(pt_21) "[lindex $pt_01 0],[lindex $pt_01 1]"
                # set DEBUG_Geometry(pt_22) "[lindex $pt_02 0],[lindex $pt_02 1]"
                # set DEBUG_Geometry(pt_23) "[lindex $pt_03 0],[lindex $pt_03 1]"
                set DEBUG_Geometry(pt_13) "[lindex $pt_13 0],[lindex $pt_13 1]"
                set DEBUG_Geometry(pt_14) "[lindex $pt_14 0],[lindex $pt_14 1]"
    }


        #
        # --- set BrakePosition - Front ------------
    proc bikeGeometry::get_BrakePositionFront {} {

            variable HeadTube
            variable Steerer
            variable FrontBrake
            variable FrontWheel
            variable Fork
            variable myFork

            # -- ceck Parameter
            if {$FrontBrake(LeverLength) < 10} {
                set FrontBrake(LeverLength) 10.0
            }

            set RimBrakeRadius    [ expr 0.5 * $FrontWheel(RimDiameter) ]

            set pt_00           $FrontWheel(Position)
            set pt_01           [split [ project::getValue Result(Tubes/Steerer/Start)  position ] , ]
            set pt_02           [split [ project::getValue Result(Tubes/Steerer/End)    position ] , ]
            
            #set pt_03           [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    1] , ]
            #set pt_04           [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    0] , ]
            #puts "  -> \$pt_03  $pt_03"
            #puts "  -> \$pt_04  $pt_04"                    
            
              # puts "   -> \$Fork(BrakeOffsetDef) $Fork(BrakeOffsetDef)"
            set pt_04           [lrange $Fork(BrakeOffsetDef) 0 1]
            set pt_03           [lrange $Fork(BrakeOffsetDef) 2 3]

              # puts "  -> \$pt_03  $pt_03"
              # puts "  -> \$pt_04  $pt_04"
            
            set pt_05           [ vectormath::intersectPerp    $pt_04 $pt_03 $pt_00 ]    ;# point on Forkblade perpendicular through FrontWheel
              # puts "  -> \$pt_05  $pt_05"
            set vct_01          [ vectormath::parallel $pt_03 $pt_05 $myFork(BladeBrakeOffset) left]
            set pt_06           [ lindex $vct_01 1 ]

            set dist_00         [ vectormath::length $pt_00 $pt_06 ]
              # puts "expr sqrt(pow($RimBrakeRadius,2)  - pow($dist_00,2))"
            
            set dist_00_Ortho   [ expr sqrt(pow($RimBrakeRadius,2)  - pow($dist_00,2)) ]

            set pt_10           [ vectormath::addVector    $pt_06 [ vectormath::unifyVector $pt_03 $pt_04 $dist_00_Ortho] ]            ;# FrontBrake(Shoe)
            set pt_11           [ vectormath::addVector    $pt_10 [ vectormath::unifyVector {0 0} $HeadTube(Direction) $FrontBrake(LeverLength)] ]
            set pt_12           [ vectormath::rotatePoint    $pt_10    $pt_11    $myFork(CrownBrakeAngle) ]                                        ;# FrontBrake(Help)
            set pt_13           [ vectormath::intersectPerp $pt_04 $pt_03 $pt_10 ]


            set vct_02          [ vectormath::parallel $pt_01 $pt_02 $myFork(CrownBrakeOffset)]
            set pt_15           [ vectormath::rotatePoint    $pt_12    $pt_10    -90 ]
            set pt_16           [ vectormath::intersectPoint  [lindex $vct_02 0] [lindex $vct_02 1] $pt_12 $pt_15 ]

            set FrontBrake(Shoe)        $pt_10
            set FrontBrake(Help)        $pt_12
            set FrontBrake(Definition)  $pt_13
            set FrontBrake(Mount)       $pt_16

            project::setValue Result(Position/BrakeFront)   position    $FrontBrake(Shoe)
                #
                # - TODO -- remove above line -------
                #
            project::setValue Result(Position/Brake/Front/Shoe)          position   $FrontBrake(Shoe)
            project::setValue Result(Position/Brake/Front/Help)          position   $FrontBrake(Help)
            project::setValue Result(Position/Brake/Front/Definition)    position   $FrontBrake(Definition)
            project::setValue Result(Position/Brake/Front/Mount)         position   $FrontBrake(Mount)


                    # set pt_18         [split [ project::getValue Result(Tubes/ForkBlade/Start)     position] , ]
                    # set pt_19         [split [ project::getValue Result(Tubes/ForkBlade/End)       position] , ]
                    # set pt_05         [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    1] , ]
                    # set pt_06         [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    2] , ]
                    # set pt_11         [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    3] , ]
                    # set pt_12         [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    4] , ]
                    # set pt_13         [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    5] , ]
                    # set pt_14         [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    6] , ]
                    # set pt_15         $FrontBrake(Mount)
                    # set pt_18         [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    0] , ]
                    # set pt_19         [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    5] , ]



                    variable DEBUG_Geometry
                    #set DEBUG_Geometry(pt_00) "[lindex $pt_00 0],[lindex $pt_00 1]"
                    set DEBUG_Geometry(pt_03) "[lindex $pt_03 0],[lindex $pt_03 1]"
                    set DEBUG_Geometry(pt_04) "[lindex $pt_04 0],[lindex $pt_04 1]"
                    set DEBUG_Geometry(pt_14) "[lindex $pt_15 0],[lindex $pt_15 1]"

                    #set DEBUG_Geometry(pt_11) "[lindex $pt_11 0],[lindex $pt_11 1]"
                    #set DEBUG_Geometry(pt_12) "[lindex $pt_12 0],[lindex $pt_12 1]"
                    #set DEBUG_Geometry(pt_13) "[lindex $pt_13 0],[lindex $pt_13 1]"
                    #set DEBUG_Geometry(pt_14) "[lindex $pt_14 0],[lindex $pt_14 1]"
                    #set DEBUG_Geometry(pt_15) "[lindex $pt_15 0],[lindex $pt_15 1]"

                    # set DEBUG_Geometry(pt_03) "[lindex $pt_03 0],[lindex $pt_03 1]"
                    # set DEBUG_Geometry(pt_04) "[lindex $pt_04 0],[lindex $pt_04 1]"
                    # set DEBUG_Geometry(pt_05) "[lindex $pt_05 0],[lindex $pt_05 1]"
                    # set DEBUG_Geometry(pt_06) "[lindex $pt_06 0],[lindex $pt_06 1]"
                    #set DEBUG_Geometry(pt_18) "[lindex $pt_18 0],[lindex $pt_18 1]"
                    #set DEBUG_Geometry(pt_19) "[lindex $pt_19 0],[lindex $pt_19 1]"

    }


        #
        # --- set BottleCageMount ------------------
    proc bikeGeometry::get_BottleCageMount {} {
            variable BottleCage
            variable SeatTube
            variable DownTube

                    set pt_00   [ vectormath::addVector $SeatTube(BottomBracket)    $SeatTube(Direction)     $BottleCage(SeatTube)                ]
                    set vct_01  [ vectormath::parallel  $SeatTube(Direction)    $pt_00                     [expr  0.5 * $SeatTube(DiameterBB)] ]
                    set SeatTube(BottleCage_Base)            [ lindex $vct_01 1 ]
                    set SeatTube(BottleCage_Offset)          [ vectormath::addVector        $SeatTube(BottleCage_Base)            $SeatTube(Direction) 64.0 ]
            project::setValue Result(Tubes/SeatTube/BottleCage/Base)            position    $SeatTube(BottleCage_Base)
            project::setValue Result(Tubes/SeatTube/BottleCage/Offset)          position    $SeatTube(BottleCage_Offset)

                    set pt_00   [ vectormath::addVector $DownTube(BottomBracket)    $DownTube(Direction)     $BottleCage(DownTube)                ]
                    set vct_01  [ vectormath::parallel  $DownTube(BottomBracket)    $pt_00                     [expr -0.5 * $DownTube(DiameterBB)] ]
                    set DownTube(BottleCage_Base)            [ lindex $vct_01 1 ]
                    set DownTube(BottleCage_Offset)          [ vectormath::addVector        $DownTube(BottleCage_Base)            $DownTube(Direction) 64.0 ]
            project::setValue Result(Tubes/DownTube/BottleCage/Base)            position    $DownTube(BottleCage_Base)
            project::setValue Result(Tubes/DownTube/BottleCage/Offset)          position    $DownTube(BottleCage_Offset)

                    set pt_00   [ vectormath::addVector $DownTube(BottomBracket)    $DownTube(Direction)     $BottleCage(DownTube_Lower)            ]
                    set vct_01  [ vectormath::parallel  $DownTube(BottomBracket)    $pt_00                     [expr  0.5 * $DownTube(DiameterBB)] ]
                    set DownTube(BottleCage_Lower_Base)     [ lindex $vct_01 1 ]
                    set DownTube(BottleCage_Lower_Base)     [ lindex $vct_01 1 ]
                    set DownTube(BottleCage_Lower_Offset)   [ vectormath::addVector        $DownTube(BottleCage_Lower_Base)    $DownTube(Direction) 64.0 ]
            project::setValue Result(Tubes/DownTube/BottleCage_Lower/Base)      position    $DownTube(BottleCage_Lower_Base)
            project::setValue Result(Tubes/DownTube/BottleCage_Lower/Offset)    position    $DownTube(BottleCage_Lower_Offset)
    }


        #
        # --- set FrameJig ------------------------
    proc bikeGeometry::get_FrameJig {} {
            variable FrameJig
            variable RearWheel
            variable Steerer
            variable SeatPost

                    set pt_00           $RearWheel(Position)
                    set pt_01           $Steerer(Stem)
                    set pt_02           $Steerer(Fork)
                    set pt_03           $SeatPost(SeatTube)
                    set pt_04           {0 0}
                    set pt_10           [ vectormath::intersectPerp        $pt_01 $pt_02 $pt_00 ]
                    set pt_11           [ vectormath::intersectPoint    $pt_00 $pt_10 $pt_03 $pt_04 ]
            set FrameJig(HeadTube)  $pt_10
            set FrameJig(SeatTube)  $pt_11
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
        #  Fork Blade Polygon for composite Fork
    proc bikeGeometry::set_columbusMAXFork {} {
    
            variable FrontWheel
            variable Fork

            set domInit $project::initDOM
                # set domInit $::APPL_Config(root_InitDOM)
                
            set FrontWheel(position)    [ bikeGeometry::get_Object        FrontWheel        position    {0 0}]
            set Steerer_Fork(position)  [ bikeGeometry::get_Object        Steerer/Start    position    {0 0}]
            set ht_direction            [ bikeGeometry::get_Object        HeadTube        direction ]

            set Fork(BladeWith)             [ [ $domInit selectNodes /root/Fork/SteelLuggedMAX/Blade/Width            ]  asText ]
            set Fork(BladeDiameterDO)       [ [ $domInit selectNodes /root/Fork/SteelLuggedMAX/Blade/DiameterDO       ]  asText ]
            set Fork(BladeBendRadius)       [ [ $domInit selectNodes /root/Fork/SteelLuggedMAX/Blade/BendRadius       ]  asText ]
            set Fork(BladeEndLength)        [ [ $domInit selectNodes /root/Fork/SteelLuggedMAX/Blade/EndLength        ]  asText ]
            set Fork(BladeOffsetCrown)      [ [ $domInit selectNodes /root/Fork/SteelLuggedMAX/Crown/Blade/Offset     ]  asText ]
            set Fork(BladeOffsetCrownPerp)  [ [ $domInit selectNodes /root/Fork/SteelLuggedMAX/Crown/Blade/OffsetPerp ]  asText ]
            set Fork(BladeOffsetDO)         [ [ $domInit selectNodes /root/Fork/SteelLuggedMAX/DropOut/Offset         ]  asText ]
    


            dict create dict_ForkBlade {}
            dict append dict_ForkBlade env \
                    [list dropOutPosition $FrontWheel(Position) \
                          forkHeight      $Fork(Height)   \
                          forkRake        $Fork(Rake)     \
                          crownOffset     $Fork(BladeOffsetCrown)     \
                          crownPerp       $Fork(BladeOffsetCrownPerp) \
                          dropOutOffset   $Fork(BladeOffsetDO)        \
                          dropOutPerp     $Fork(BladeOffsetDOPerp)    \
                          headTubeAngle   $HeadTube(Angle) \
                    ]
            dict append dict_ForkBlade blade \
                    [list type            $project::Rendering(ForkBlade)  \
                          endLength       $Fork(BladeEndLength) \
                          bendRadius      $Fork(BladeBendRadius) \
                    ]
            dict append dict_ForkBlade profile \
                    [list [list 0                       $Fork(BladeDiameterDO)] \
                          [list $Fork(BladeTaperLength) $Fork(BladeWith)] \
                          [list 200                     $Fork(BladeWith)] \
                          [list 500                     $Fork(BladeWith)] \
                    ]

            set retValue [bikeGeometry::tube::get_ForkBlade $dict_ForkBlade]
            
            set outLine         [lindex $retValue 0]
            set centerLine      [lindex $retValue 1]
            set brakeDefLine    [lindex $retValue 2]
            set dropOutAngle    [lindex $retValue 3]
            
            set dropOutPos      $FrontWheel(Position) 
                                        
              # puts "  -> \$outLine       $outLine"
              # puts "  -> \$dropOutPos    $dropOutPos"
              # puts "  -> \$dropOutAngle  $dropOutAngle"
            
            set Fork(BrakeOffsetDef)      $brakeDefLine
            set Fork(DropoutDirection)    [ vectormath::unifyVector $dropOutPos [vectormath::rotateLine $dropOutPos 10 [expr 180 + $dropOutAngle]] 1]
              # puts "  -> \$Fork(DropoutDirection)  $Fork(DropoutDirection)"
            
            
            project::setValue Result(Tubes/ForkBlade)                 polygon     $outLine
            project::setValue Result(Lugs/Dropout/Front/Direction)    direction   $Fork(DropoutDirection)                                        
 
   
            set do_direction    [ vectormath::unifyVector $FrontWheel(position) $pt_03 ]
            project::setValue Result(Lugs/Dropout/Front/Direction)    direction    $do_direction

            return $polygon    
    
    
    
    


                        set domInit $project::initDOM
                            # set domInit $::APPL_Config(root_InitDOM)
                        
                        set FrontWheel(position)    [ bikeGeometry::get_Object        FrontWheel        position    {0 0}]
                        set Steerer_Fork(position)  [ bikeGeometry::get_Object        Steerer/Start    position    {0 0}]
                        set ht_direction            [ bikeGeometry::get_Object        HeadTube        direction ]

                        set Fork(BladeWith)             [ [ $domInit selectNodes /root/Fork/Composite/Blade/Width            ]  asText ]
                        set Fork(BladeDiameterDO)       [ [ $domInit selectNodes /root/Fork/Composite/Blade/DiameterDO    ]  asText ]
                        set Fork(BladeOffsetCrown)      [ [ $domInit selectNodes /root/Fork/Composite/Crown/Blade/Offset        ]  asText ]
                        set Fork(BladeOffsetCrownPerp)  [ [ $domInit selectNodes /root/Fork/Composite/Crown/Blade/OffsetPerp    ]  asText ]
                        set Fork(BladeOffsetDO)         [ [ $domInit selectNodes /root/Fork/Composite/DropOut/Offset        ]  asText ]

                        set ht_angle            [ vectormath::angle {0 1} {0 0} $ht_direction ]
                        set pt_00               [list $Fork(BladeOffsetCrownPerp) [expr -1.0*$Fork(BladeOffsetCrown)] ]
                        set pt_01               [ vectormath::addVector $pt_00 {0  -5} ]
                        set pt_02               [ vectormath::addVector $pt_00 {0 -15} ]

                        set pt_00               [ vectormath::addVector $Steerer_Fork(position) [ vectormath::rotatePoint {0 0} $pt_00 $ht_angle ]]
                        set pt_01               [ vectormath::addVector $Steerer_Fork(position) [ vectormath::rotatePoint {0 0} $pt_01 $ht_angle ]]
                        set pt_02               [ vectormath::addVector $Steerer_Fork(position) [ vectormath::rotatePoint {0 0} $pt_02 $ht_angle ]]
                                # puts "     ... \$ht_angle  $ht_angle"
                                # puts "   -> pt_00  $pt_00"
                                # puts "   -> pt_01  $pt_01"

                        set vct_10                [ vectormath::parallel $pt_00 $pt_01 [expr 0.5*$Fork(BladeWith)] left]
                        set vct_19                [ vectormath::parallel $pt_00 $pt_02 [expr 0.5*$Fork(BladeWith)] ]
                                # puts "   -> pt_00  $pt_00"
                                # puts "   -> vct_10  $vct_10"
                                # puts "   -> vct_19  $vct_19"

                            set help_02                    [ list 0 [lindex  $FrontWheel(position) 1] ]
                            set do_angle                [ expr 90 - [ vectormath::angle $pt_01 $FrontWheel(position) $help_02  ] ]
                            set vct_05                    [ list $Fork(BladeOffsetDO) 0 ]
                            set vct_06                    [ vectormath::rotatePoint {0 0} $vct_05 [expr 90 + $do_angle] ]
                        set pt_03               [ vectormath::addVector $FrontWheel(position)  $vct_06 ]

                            set vct_11          [ vectormath::parallel $pt_01 $pt_03 [expr 0.5*$Fork(BladeDiameterDO)] left]
                            set vct_18          [ vectormath::parallel $pt_01 $pt_03 [expr 0.5*$Fork(BladeDiameterDO)] ]

                        set polygon         [format "%s %s %s %s %s %s" \
                                                [lindex $vct_10 0] [lindex $vct_10 1] \
                                                [lindex $vct_11 1] [lindex $vct_18 1] \
                                                [lindex $vct_19 1] [lindex $vct_19 0] ]

                        set do_direction    [ vectormath::unifyVector $FrontWheel(position) $pt_03 ]
                        project::setValue Result(Lugs/Dropout/Front/Direction)    direction    $do_direction

                        return $polygon
    }


    #-------------------------------------------------------------------------
        #  Fork Blade Polygon for composite Fork
    proc bikeGeometry::set_compositeFork {forkType} {

            set domInit $project::initDOM
                # set domInit $::APPL_Config(root_InitDOM)
                
            set FrontWheel(position)    [ bikeGeometry::get_Object        FrontWheel       position    {0 0}]
            set Steerer_Fork(position)  [ bikeGeometry::get_Object        Steerer/Start    position    {0 0}]
            set ht_direction            [ bikeGeometry::get_Object        HeadTube         direction ]

            set Fork(BladeWith)             [ [ $domInit selectNodes /root/Fork/Composite/Blade/Width            ]  asText ]
            set Fork(BladeDiameterDO)       [ [ $domInit selectNodes /root/Fork/Composite/Blade/DiameterDO       ]  asText ]
            set Fork(BladeOffsetCrown)      [ [ $domInit selectNodes /root/Fork/Composite/Crown/Blade/Offset     ]  asText ]
            set Fork(BladeOffsetCrownPerp)  [ [ $domInit selectNodes /root/Fork/Composite/Crown/Blade/OffsetPerp ]  asText ]
            set Fork(BladeOffsetDO)         [ [ $domInit selectNodes /root/Fork/Composite/DropOut/Offset         ]  asText ]

            set ht_angle            [ vectormath::angle {0 1} {0 0} $ht_direction ]
            set pt_00               [list $Fork(BladeOffsetCrownPerp) [expr -1.0*$Fork(BladeOffsetCrown)] ]
            set pt_01               [ vectormath::addVector $pt_00 {0  -5} ]
            set pt_02               [ vectormath::addVector $pt_00 {0 -15} ]

            set pt_00               [ vectormath::addVector $Steerer_Fork(position) [ vectormath::rotatePoint {0 0} $pt_00 $ht_angle ]]
            set pt_01               [ vectormath::addVector $Steerer_Fork(position) [ vectormath::rotatePoint {0 0} $pt_01 $ht_angle ]]
            set pt_02               [ vectormath::addVector $Steerer_Fork(position) [ vectormath::rotatePoint {0 0} $pt_02 $ht_angle ]]
                    # puts "     ... \$ht_angle  $ht_angle"
                    # puts "   -> pt_00  $pt_00"
                    # puts "   -> pt_01  $pt_01"

            set vct_10              [ vectormath::parallel $pt_00 $pt_01 [expr 0.5*$Fork(BladeWith)] left]
            set vct_19              [ vectormath::parallel $pt_00 $pt_02 [expr 0.5*$Fork(BladeWith)] ]
                    # puts "   -> pt_00  $pt_00"
                    # puts "   -> vct_10  $vct_10"
                    # puts "   -> vct_19  $vct_19"

                set help_02         [ list 0 [lindex  $FrontWheel(position) 1] ]
                set do_angle        [ expr 90 - [ vectormath::angle $pt_01 $FrontWheel(position) $help_02  ] ]
                set vct_05          [ list $Fork(BladeOffsetDO) 0 ]
                set vct_06          [ vectormath::rotatePoint {0 0} $vct_05 [expr 90 + $do_angle] ]
            set pt_03               [ vectormath::addVector $FrontWheel(position)  $vct_06 ]

                set vct_11          [ vectormath::parallel $pt_01 $pt_03 [expr 0.5*$Fork(BladeDiameterDO)] left]
                set vct_18          [ vectormath::parallel $pt_01 $pt_03 [expr 0.5*$Fork(BladeDiameterDO)] ]            

                                           
            if {$forkType == {TUSK}} {
				set polygon         [list -15.4096  -80.6711 \
										   22.8479  -37.0065 ]                              
				set polygon         [vectormath::rotatePointList    {0 0} $polygon  $ht_angle]                                 
				set polygon         [vectormath::addVectorPointList $Steerer_Fork(position) $polygon  ]                                 
				lappend polygon         [lindex [lindex $vct_11 1] 0] [lindex [lindex $vct_11 1] 1] 
				lappend polygon         [lindex [lindex $vct_18 1] 0] [lindex [lindex $vct_18 1] 1] 
            } else {
				set polygon         [format "%s %s %s %s %s %s" \
										[lindex $vct_10 0] [lindex $vct_10 1] \
										[lindex $vct_11 1] [lindex $vct_18 1] \
										[lindex $vct_19 1] [lindex $vct_19 0] ]
			}
			
            set do_direction    [ vectormath::unifyVector $FrontWheel(position) $pt_03 ]
            project::setValue Result(Lugs/Dropout/Front/Direction)    direction    $do_direction

                # tk_messageBox -message "$polygon"
              
            return $polygon
    }


    #-------------------------------------------------------------------------
        #  Fork Blade Polygon for suspension Fork
    proc bikeGeometry::set_suspensionFork {} {

            set domInit $project::initDOM
                # set domInit $::APPL_Config(root_InitDOM)
            set FrontWheel(position)    [ bikeGeometry::get_Object        FrontWheel        position    {0 0}]
            set Steerer_Fork(position)  [ bikeGeometry::get_Object        Steerer/Start    position    {0 0}]
            set ht_direction            [ bikeGeometry::get_Object        HeadTube        direction ]

            set Fork(LegOffsetCrown)        [ [ $domInit selectNodes /root/Fork/_Suspension/Leg/Offset      ]  asText ]
            set Fork(LegOffsetCrownPerp)    [ [ $domInit selectNodes /root/Fork/_Suspension/Leg/OffsetPerp  ]  asText ]
            set Fork(LegDiameter)           [ [ $domInit selectNodes /root/Fork/_Suspension/Leg/Diameter    ]  asText ]

            set ht_angle            [ vectormath::angle {0 1} {0 0} $ht_direction ]

            set pt_00               [list $Fork(LegOffsetCrownPerp) [expr -1.0*$Fork(LegOffsetCrown)] ]
            set pt_01               [ vectormath::addVector $pt_00 {0 -90} ]

            set pt_00               [ vectormath::addVector $Steerer_Fork(position) [ vectormath::rotatePoint {0 0} $pt_00 $ht_angle ]]
            set pt_01               [ vectormath::addVector $Steerer_Fork(position) [ vectormath::rotatePoint {0 0} $pt_01 $ht_angle ]]
                    # puts "     ... \$ht_angle  $ht_angle"
                    # puts "   -> pt_00  $pt_00"
                    # puts "   -> pt_01  $pt_01"

            set vct_10              [ vectormath::parallel $pt_00 $pt_01 [expr 0.5*$Fork(LegDiameter)] left]
            set vct_19              [ vectormath::parallel $pt_00 $pt_01 [expr 0.5*$Fork(LegDiameter)] ]
                    # puts "   -> pt_00  $pt_00"
                    # puts "   -> vct_10  $vct_10"
                    # puts "   -> vct_19  $vct_19"

            set polygon         [format "%s %s %s %s" \
                                    [lindex $vct_10 0] [lindex $vct_10 1] \
                                    [lindex $vct_19 1] [lindex $vct_19 0] ]

            set do_direction    [ vectormath::unifyVector $pt_01 $pt_00 ]
            project::setValue Result(Lugs/Dropout/Front/Direction)    direction    $do_direction

            return $polygon
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

 
 
    # --- Result Angles  ----------------------------------
        #
    proc bikeGeometry::get_resultAngle {position point_1 point_2 } {
        set angle_p1    [ vectormath::dirAngle $position $point_1 ]
        set angle_p2    [ vectormath::dirAngle $position $point_2 ]
        set angle_ext   [expr $angle_p2 - $angle_p1]
            # puts "     angle_p1  -> $angle_p1"
            # puts "     angle_p2  -> $angle_p2"
            # puts "     angle_ext -> $angle_ext"
        if {$angle_ext < 0 } {set angle_ext [expr $angle_ext +360]}
        return $angle_ext
    }
    
    
 
 
 