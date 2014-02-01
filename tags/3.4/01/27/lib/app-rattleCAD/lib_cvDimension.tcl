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


    proc rattleCAD::cv_custom::createDimension {cv_Name BB_Position type {active {on}}} {

            variable    stageScale

            variable    Rendering
            variable    Reference

            variable    BottomBracket
            variable    DownTube
            variable    Fork
            variable    FrameJig
            variable    FrontBrake
            variable    FrontWheel
            variable    HandleBar
            variable    HeadTube
            variable    HeadSet
            variable    LegClearance
            variable    RearBrake
            variable    RearDrop
            variable    RearWheel
            variable    Saddle
            variable    SaddleNose
            variable    SeatPost
            variable    SeatStay
            variable    SeatTube
            variable    Steerer
            variable    Stem
            variable    TopTube

            variable    Position
            variable    Length
            variable    Angle
            variable    Vector


                # --- create dimension -------------------
            switch $type {
                point_center {
                            $cv_Name create circle        $Position(BaseCenter)     -radius 10  -outline gray50     -width 1.0  -tags __CenterLine__
                        }
                point_personal {
                            $cv_Name create circle        $BottomBracket(Position)  -radius 20  -outline darkred    -width 1.0  -tags {__CenterLine__  __CenterPoint__  personalBB}
                            $cv_Name create circle        $HandleBar(Position)      -radius 10  -outline darkred    -width 1.0  -tags {__CenterLine__  __CenterPoint__  personalHB}
                            $cv_Name create circle        $Saddle(Position)         -radius 10  -outline darkred    -width 1.0  -tags {__CenterLine__  __CenterPoint__  personalSaddle}
                            $cv_Name create circle        $SeatTube(Saddle)         -radius  5  -outline darkblue   -width 2.0  -tags {__CenterLine__  __CenterPoint__  personalSeat}
                            $cv_Name create circle        $SeatPost(PivotPosition)  -radius  2  -outline darkblue   -width 2.0  -tags {__CenterLine__  __CenterPoint__  personalSeatPost}
                       }
                point_crank {
                            $cv_Name create circle        $Position(help_91)        -radius  4  -outline gray50     -width 1.0  -tags __CenterLine__
                            $cv_Name create circle        $Position(help_93)        -radius  4  -outline gray50     -width 1.0  -tags __CenterLine__
                        }
                point_reference {
                            $cv_Name create circle        $Reference(HandleBar)     -radius  2  -outline orange     -width 1.0  -tags __CenterLine__
                            $cv_Name create circle        $Reference(SaddleNose)    -radius  2  -outline orange     -width 1.0  -tags __CenterLine__
                        }
                point_seat {
                            $cv_Name create circle        $LegClearance(Position)   -radius  4  -outline darkred    -width 1.0  -tags __CenterLine__
                            $cv_Name create circle        $SaddleNose(Position)     -radius  8  -outline darkred    -width 1.0  -tags __CenterLine__
                            $cv_Name create circle        $Saddle(Proposal)         -radius  4  -outline darkmagenta    -width 2.0  -tags __CenterLine__
                            $cv_Name create circle        $SeatTube(Saddle)         -radius  5  -outline gray       -width 1.0  -tags __CenterLine__
                        }
                point_frame {
                            $cv_Name create circle        $Steerer(Fork)            -radius 10  -outline gray       -width 1.0  -tags {__CenterLine__  __CenterPoint__  steererFork}
                            $cv_Name create circle        $HeadTube(Stem)           -radius 10  -outline gray       -width 1.0  -tags {__CenterLine__  __CenterPoint__  headtubeStem}
                            $cv_Name create circle        $TopTube(Steerer)         -radius  4  -outline gray       -width 1.0  -tags {__CenterLine__  __CenterPoint__  toptubeSteerer}
                            $cv_Name create circle        $TopTube(SeatVirtual)     -radius  4  -outline gray       -width 1.0  -tags {__CenterLine__  __CenterPoint__  toptubeSeatVirtual}
                        }
                point_frame_dimension {
                            $cv_Name create circle        $HeadTube(Stem)           -radius  4  -outline gray       -width 1.0  -tags __CenterLine__
                        }
                cline_frame {
                            $cv_Name create centerline        [ appUtil::flatten_nestedList $HeadTube(Stem) $TopTube(SeatVirtual) ] \
                                                                                    -fill darkorange    -width 2.0  -tags __CenterLine__


                         }
                cline_angle {
                            $cv_Name create circle        $HeadTube(Stem)           -radius  4  -outline blue       -width 1.0            -tags __CenterLine__
                            $cv_Name create circle        $HandleBar(Position)      -radius  4  -outline darkblue   -width 1.0            -tags __CenterLine__
                            $cv_Name create circle        $Saddle(Position)         -radius  4  -outline gray50     -width 1.0            -tags __CenterLine__

                            $cv_Name create centerline  [ appUtil::flatten_nestedList $Steerer(Stem) $Steerer(Ground) ] \
                                                                                    -fill gray50        -width 0.25     -tags __CenterLine__
                            $cv_Name create centerline  [ appUtil::flatten_nestedList $SeatTube(Saddle) $SeatTube(Ground) ] \
                                                                                    -fill gray50        -width 0.25     -tags __CenterLine__
                        }
                cline_brake {
                            if {$Rendering(BrakeRear) != {off}} {
                                switch $Rendering(BrakeRear) {
                                    Rim {
                                        $cv_Name create circle        $RearBrake(Shoe)    -radius  4  -outline gray50        -width 0.35        -tags __CenterLine__
                                        $cv_Name create circle        $RearBrake(Mount)   -radius  4  -outline gray50        -width 0.35        -tags __CenterLine__
                                        $cv_Name create centerline  [ appUtil::flatten_nestedList $RearBrake(Definition) $RearBrake(Shoe) $RearBrake(Help) $RearBrake(Mount)] \
                                                                                    -fill gray50        -width 0.25     -tags __CenterLine__
                                    }
                                }
                            }
                            if {$Rendering(BrakeFront) != {off}} {
                                switch $Rendering(BrakeFront) {
                                    Rim {
                                        $cv_Name create circle        $FrontBrake(Shoe)   -radius  4  -outline gray50        -width 0.35        -tags __CenterLine__
                                        $cv_Name create circle        $FrontBrake(Mount)  -radius  4  -outline gray50        -width 0.35        -tags __CenterLine__
                                        $cv_Name create centerline  [ appUtil::flatten_nestedList $FrontBrake(Definition) $FrontBrake(Shoe) $FrontBrake(Help) $FrontBrake(Mount)] \
                                                                                    -fill gray50        -width 0.25     -tags __CenterLine__
                                        }
                                }
                            }
                        }
                cline_framejig {
                                set help_fk             [ vectormath::intersectPoint                $Steerer(Fork)        $Steerer(Stem)   $FrontWheel(Position) $RearWheel(Position) ]

                            $cv_Name create circle        $HeadTube(Fork)       -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
                            $cv_Name create circle        $FrameJig(HeadTube)   -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
                            $cv_Name create circle        $FrameJig(SeatTube)   -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
                            $cv_Name create circle        $help_fk              -radius  4  -outline gray50    -width 0.35     -tags __CenterLine__
                            $cv_Name create centerline  [ appUtil::flatten_nestedList $FrameJig(HeadTube) $RearWheel(Position)] \
                                                                                    -fill darkred   -width 0.25     -tags __CenterLine__
                            $cv_Name create centerline  [ appUtil::flatten_nestedList $RearWheel(Position) $help_fk] \
                                                                                    -fill darkred   -width 0.25     -tags __CenterLine__
                        }

                geometry_bg {
                            set help_01                 [ list [lindex $BottomBracket(Position) 0] [lindex $LegClearance(Position) 1] ]

                            set _dim_SD_Height          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(BaseCenter)  $Saddle(Position) ] \
                                                                vertical    [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
                                                                gray50 ]
                            set _dim_SP_Height          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SeatPost(Saddle)      $BottomBracket(Position)  ] \
                                                                vertical    [expr (500 + $Length(Length_BB_Seat)) * $stageScale ]    [expr  150 * $stageScale] \
                                                                gray50 ]
                            set _dim_HB_Height          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)   $Position(BaseCenter) ] \
                                                                vertical    [expr -380 * $stageScale]  [expr  230 * $stageScale]  \
                                                                gray50 ]
                            set _dim_SD_HB_Length       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Saddle(Position)      $HandleBar(Position) ] \
                                                                horizontal    [expr  -210 * $stageScale]    0 \
                                                                gray50 ]


                            set _dim_Wh_Distance        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Ground)     $FrontWheel(Ground) ] \
                                                                horizontal  [expr  130 * $stageScale]    0 \
                                                                gray50 ]
                            set _dim_FW_Lag             [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $FrontWheel(Ground)    $Steerer(Ground) ] \
                                                                horizontal  [expr   70 * $stageScale]   [expr  -70 * $stageScale] \
                                                                gray20 ]

                            set _dim_BT_Clearance       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(help_91)     $Position(help_92) ] \
                                                                aligned        0   [expr -150 * $stageScale]  \
                                                                gray50 ]

                            #set _dim_ST_Length          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $SeatTube(Saddle) ] \
                                                                aligned        [expr  -80 * $stageScale]    [expr -170 * $stageScale]  \
                                                                gray50 ]
                            set _dim_ST_Length          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(help_93)       $Saddle(Position) ] \
                                                                aligned        [expr -160 * $stageScale]    [expr -230 * $stageScale]  \
                                                                gray50 ]
                }
                    # -----------------------
                geometry_fg {

                            set help_00            [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
                            set help_01            [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
                            set help_02            [ vectormath::addVector   $Steerer(Stem) [ vectormath::unifyVector $Steerer(Stem) $help_01 [expr  50 * $stageScale] ] ]
                            set help_03            [ vectormath::addVector   $SeatPost(PivotPosition) {-10 0} ]
                            set help_fk            [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]

                                # colourtable: http://www.ironspider.ca/format_text/fontcolor.htm
                                        # set colour(primary)        red
                                        # set colour(secondary)    darkorange
                                        # set colour(third)        darkblue
                                        # set colour(result)        darkred

                            set colour(primary)        darkorange
                            set colour(secondary)    darkred
                            set colour(third)        darkmagenta
                            set colour(result)        darkblue

                                        # set colour(primary)        darkorange
                                        # set colour(primary)        darkorchid
                                        # set colour(primary)        red
                                        # set colour(primary)        blue
                                        # set colour(secondary)        darkred
                                        # set colour(secondary)        darkorange
                                        # set colour(third)            firebrick
                                        # set colour(result)        firebrick
                                        # set colour(result)        darkorange
                                        # set colour(result)        blue




                                # --- result - level - dimensions
                                #
                            set _dim_SD_HB_Height   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)   $Saddle(Position) ] \
                                                                vertical    [expr  380 * $stageScale]   [expr -100 * $stageScale]  \
                                                                $colour(result) ]
                            set _dim_SD_ST_Length   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $SeatTube(Saddle) ] \
                                                                aligned        [expr  -80 * $stageScale]    [expr -170 * $stageScale]  \
                                                                $colour(result) ]
                            set _dim_FW_Distance    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position)  $FrontWheel(Position)] \
                                                                aligned     [expr  100 * $stageScale]   [expr  -30 * $stageScale] \
                                                                $colour(result) ]
                            set _dim_FW_DistanceX   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(BaseCenter)  $FrontWheel(Ground) ] \
                                                                horizontal  [expr   70 * $stageScale]   0 \
                                                                $colour(result) ]
                            set _dim_BB_Height      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position)    $Position(BaseCenter)] \
                                                                vertical    [expr  150 * $stageScale]   [expr   -20 * $stageScale]  \
                                                                $colour(result) ]
                            set _dim_ST_Length      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SeatTube(Saddle)      $BottomBracket(Position) ] \
                                                                horizontal  [expr  -80 * $stageScale]   [expr    0 * $stageScale]  \
                                                                darkblue ]
                            set _dim_ST_Angle       [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList  $SeatTube(Ground)      $SeatPost(SeatTube) $help_00 ] \
                                                                150   0  \
                                                                $colour(result) ]
                            set _dim_CS_LengthX     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Ground)     $Position(BaseCenter) ] \
                                                                horizontal  [expr   70 * $stageScale]   0 \
                                                                $colour(result) ]
                            set _dim_TT_Virtual     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $TopTube(SeatVirtual)  $HeadTube(Stem)] \
                                                                aligned     [expr  150 * $stageScale]   [expr  -80 * $stageScale] \
                                                                $colour(result) ]
                            # set _dim_TT_Virtual     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $TopTube(SeatVirtual)  $TopTube(Steerer)] \
                                                                aligned     [expr   80 * $stageScale]   [expr  -80 * $stageScale] \
                                                                $colour(result) ]
                            set _dim_ST_Virtual     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $BottomBracket(Position) $TopTube(SeatVirtual) ] \
                                                                aligned     [expr   80 * $stageScale]   [expr   90 * $stageScale] \
                                                                $colour(result) ]

                            set _dim_HT_Reach_X     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $HeadTube(Stem)       $BottomBracket(Position) ] \
                                                                horizontal  [expr  -80 * $stageScale]    0 \
                                                                $colour(result) ]
                            set _dim_HT_Stack_Y     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $HeadTube(Stem)       $BottomBracket(Position) ] \
                                                                vertical    [expr   80 * $stageScale]    [expr  120 * $stageScale]  \
                                                                $colour(result) ]






                                # --- third - level - dimensions
                                #
                            set distY_SN_LC         [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
                                #
                            set _dim_LC_Position_x  [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $LegClearance(Position)  $BottomBracket(Position) ] \
                                                                horizontal  [expr  $distY_SN_LC * $stageScale]   0  \
                                                                $colour(third) ]
                            set _dim_LC_Position_y  [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $LegClearance(Position)  $Position(BaseCenter) ] \
                                                                vertical    [expr  -50 * $stageScale]   [expr   160 * $stageScale]  \
                                                                $colour(third) ]
                            set _dim_SN_Position_x  [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $BottomBracket(Position) ] \
                                                                horizontal  [expr  $distY_SN_LC * $stageScale]   0  \
                                                                $colour(third) ]
                            set _dim_CR_Length      [ $cv_Name dimension  radius            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Position(help_91)] \
                                                                -20            [expr  130 * $stageScale] \
                                                                $colour(third) ]
                            set _dim_SN_HandleBar   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $HandleBar(Position)] \
                                                                horizontal      [expr  -80 * $stageScale]    0 \
                                                                $colour(third) ]


                                # --- secondary - level - dimensions
                                #
                            set _dim_BB_Depth       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position)  $RearWheel(Position) ] \
                                                                vertical    [expr  -260 * $stageScale]   [expr -90 * $stageScale]  \
                                                                $colour(secondary) ]
                            set _dim_CS_Length      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Position)      $BottomBracket(Position)] \
                                                                aligned     [expr   100 * $stageScale]   0 \
                                                                $colour(secondary) ]
                            set _dim_HT_Angle       [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList  $Steerer(Ground)  $Steerer(Fork)  $Position(BaseCenter) ] \
                                                                150   0  \
                                                                $colour(secondary) ]
                            set _dim_RW_Radius      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Position)      $RearWheel(Ground) ] \
                                                                vertical    [expr   130 * $stageScale]    0 \
                                                                $colour(secondary) ]
                            set _dim_FW_Radius      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $FrontWheel(Position)     $FrontWheel(Ground) ] \
                                                                vertical    [expr  -150 * $stageScale]    0 \
                                                                $colour(secondary) ]
                            set _dim_Stem_Length    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)      $Steerer(Stem) ] \
                                                                aligned     [expr    80 * $stageScale]    0 \
                                                                $colour(secondary) ]
                            set _dim_HT_Length      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Steerer(Fork)  $HeadTube(Stem) ] \
                                                                aligned        [expr   100 * $stageScale]   0 \
                                                                $colour(secondary) ]
                            set _dim_SP_SetBack     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SeatTube(BBracket) $SeatPost(SeatTube) $SeatPost(PivotPosition) ] \
                                                                perpendicular    [expr  -40 * $stageScale]  [expr  50 * $stageScale]  \
                                                                $colour(secondary) ]


                            set _dim_Fork_Rake      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Steerer(Stem)  $help_fk $FrontWheel(Position) ] \
                                                                perpendicular [expr  100 * $stageScale]    [expr  -80 * $stageScale] \
                                                                $colour(secondary) ]
                            set _dim_SD_Height      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SeatPost(Saddle) $Saddle(Position)  ] \
                                                                aligned       [expr  (-500 - $Length(Length_BB_Seat)) * $stageScale ]    [expr  -80 * $stageScale] \
                                                                $colour(secondary) ]
                            set _dim_SP_PivotOffset [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $help_03 $SeatPost(PivotPosition) $SeatPost(Saddle)  ] \
                                                                perpendicular [expr  (-420 - $Length(Length_BB_Seat)) * $stageScale ]    [expr   0 * $stageScale]  \
                                                                $colour(secondary) ]                      
                            


                            if {$Stem(Angle) > 0} {
                                set _dim_Stem_Angle [ $cv_Name dimension  angle        [ appUtil::flatten_nestedList  $Steerer(Stem)  $help_02 $HandleBar(Position) ] \
                                                                [expr $Stem(Length) +  80]   0  \
                                                                $colour(secondary) ]
                            } else {
                                set _dim_Stem_Angle [ $cv_Name dimension  angle        [ appUtil::flatten_nestedList  $Steerer(Stem)  $HandleBar(Position)  $help_02 ] \
                                                                [expr $Stem(Length) +  80]   0  \
                                                                $colour(secondary) ]
                            }

                            if {$Fork(Rake) != 0} {
                                set _dim_Fork_Height    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $help_fk $FrontWheel(Position) $Steerer(Fork)  ] \
                                                                perpendicular [expr  (100 - $Fork(Rake)) * $stageScale]    [expr  -10 * $stageScale] \
                                                                $colour(secondary) ]
                            } else {
                                set _dim_Fork_Height    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $FrontWheel(Position) $Steerer(Fork)  ] \
                                                                aligned          [expr  100  * $stageScale]    [expr  -10 * $stageScale] \
                                                                $colour(secondary) ]
                            }


                            if {$SeatTube(OffsetBB) > 0} {
                                set dim_distance    [expr  90 * $stageScale]
                                set dim_offset      [expr  50 * $stageScale]
                            } else {
                                set dim_distance    [expr -90 * $stageScale]
                                set dim_offset      [expr -50 * $stageScale]
                            }
                            set _dim_ST_Offset                [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $SeatPost(SeatTube) $SeatTube(BBracket) $BB_Position] ] \
                                                                perpendicular    $dim_distance $dim_offset \
                                                                $colour(secondary) ]



                                # --- primary - level - dimensions
                                #
                            set _dim_HB_XPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                                                                horizontal  [expr (150 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                                                                $colour(primary) ]
                            set _dim_HB_YPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                                                                vertical    [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
                                                                $colour(primary) ]
                            set _dim_SD_XPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Saddle(Position)        $BottomBracket(Position)  ] \
                                                                horizontal    [expr -150 * $stageScale]    0 \
                                                                $colour(primary) ]
                            set _dim_SD_YPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Saddle(Position) ] \
                                                                vertical    [expr -580 * $stageScale]  [expr -130 * $stageScale]  \
                                                                $colour(primary) ]


                            if {$active == {on}} {
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_HB_XPosition
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_HB_YPosition
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_SD_XPosition
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_SD_YPosition
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_SN_HandleBar
                                    
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_SD_Height
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_SP_SetBack
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_SP_PivotOffset
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_HT_Length
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_LC_Position_x
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_LC_Position_y
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_SN_Position_x
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_ST_Angle
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_ST_Length
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_ST_Offset
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_BB_Depth
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_CS_Length
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_HT_Angle
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_Stem_Length
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_Stem_Angle
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_Fork_Rake
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_Fork_Height
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_RW_Radius
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_FW_Radius
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_CR_Length
                                    
                                    foreach cv_Item [list $_dim_HB_XPosition $_dim_HB_YPosition $_dim_SD_XPosition $_dim_SD_YPosition] {
                                         foreach cv_item [$cv_Name gettags $cv_Item] {
                                            switch -regexp $cv_item {
                                                    vtext* {
                                                            #$cv_Name itemconfigure $cv_item -fill darkred
                                                            set width [expr 3.0 * [$cv_Name itemcget $cv_item -width]]
                                                            $cv_Name itemconfigure $cv_item -width $width
                                                            set bbox [$cv_Name coords $cv_item]
                                                                # puts "  -> $bbox  - $cv_Name"
                                                                # puts "  -> $stageScale"
                                                            set wScale      [ eval $cv_Name getNodeAttr Canvas scale ]
                                                            set stageScale  [ eval $cv_Name getNodeAttr Stage  scale ]
                                                                # puts "  -> $wScale / $stageScale"

                                                            #set wScale        [ $cv_Name    getNodeAttribute    Canvas        scale ]
                                                            #set stageScale        [ $cv_Name    getNodeAttribute    Stage    scale ]
                                                            #set wScale        [ getNodeAttribute    $canvasDOMNode    Canvas        scale ]
                                                            #set stageScale        [ getNodeAttribute    $canvasDOMNode    Stage    scale ]


                                                            #set bbox [canvasCAD::convert_BottomLeft [expr $wScale/$stageScale] $bbox]
                                                                # puts "  -> $bbox  - $cv_Name"

                                                            #puts "cv: [canvasCAD::__boundingBox  $cv_Name  $cv_item]"
                                                            foreach {x y} $bbox {
                                                                set x [expr $x * $wScale]
                                                                set y [expr -1.0 * $y * $wScale]
                                                                # $cv_Name create circle [list $x $y]    -radius  17  -outline darkred        -width 10        -tags __CenterLine__
                                                            }

                                                            foreach {x1 y1 x2 y2} $bbox {
                                                                #puts "$x1"
                                                                #set x1 [expr $x1/$stageScale]
                                                                #set y1 [expr -1.0*$y1/$stageScale]
                                                                #set x2 [expr $x2/$stageScale]
                                                                #set y2 [expr -1.0*$y2/$stageScale]
                                                            }
                                                            #$cv_Name create rectangle [list $x1 $y1 $x2 $y2] -width 3
                                                         }
                                                    default {}
                                            }
                                        }
                                    }


                                    $cv_Name bind $_dim_HB_XPosition    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Personal(HandleBar_Distance) ]
                                    $cv_Name bind $_dim_HB_YPosition    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Personal(HandleBar_Height) ]
                                    $cv_Name bind $_dim_SD_XPosition    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Personal(Saddle_Distance) ]
                                    $cv_Name bind $_dim_SD_YPosition    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Personal(Saddle_Height) ]
                                    $cv_Name bind $_dim_SN_HandleBar    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Result(Length/Personal/SaddleNose_HB) ]
                                    
                                    $cv_Name bind $_dim_SD_Height       <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Component(Saddle/Height) ]
                                    $cv_Name bind $_dim_SP_SetBack      <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Component(SeatPost/Setback) ]
                                    $cv_Name bind $_dim_SP_PivotOffset  <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Component(SeatPost/PivotOffset) ]
                                    $cv_Name bind $_dim_HT_Length       <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  {FrameTubes(HeadTube/Length) Component(HeadSet/Height/Bottom)} {Head Tube Parameter} ]
                                    $cv_Name bind $_dim_LC_Position_x   <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Custom(TopTube/PivotPosition) ]
                                    $cv_Name bind $_dim_LC_Position_y   <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Personal(InnerLeg_Length) ]
                                    $cv_Name bind $_dim_SN_Position_x   <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  {Result(Length/Saddle/Offset_BB_Nose) Component(Saddle/LengthNose) Rendering(Saddle/Offset_X)} {Saddle Parameter}]                                 
                                    $cv_Name bind $_dim_BB_Depth        <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Custom(BottomBracket/Depth) ]
                                    $cv_Name bind $_dim_CS_Length       <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Custom(WheelPosition/Rear) ]
                                    $cv_Name bind $_dim_HT_Angle        <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Custom(HeadTube/Angle) ]
                                    $cv_Name bind $_dim_Stem_Length     <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Component(Stem/Length) ]
                                    $cv_Name bind $_dim_Stem_Angle      <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Component(Stem/Angle) ]
                                    $cv_Name bind $_dim_Fork_Rake       <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Component(Fork/Rake) ]
                                    $cv_Name bind $_dim_Fork_Height     <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Component(Fork/Height) ]
                                    $cv_Name bind $_dim_RW_Radius       <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  {list://Component(Wheel/Rear/RimDiameter@SELECT_Rim) Component(Wheel/Rear/TyreHeight)} {Rear Wheel Parameter} ]
                                    $cv_Name bind $_dim_FW_Radius       <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  {list://Component(Wheel/Front/RimDiameter@SELECT_Rim) Component(Wheel/Front/TyreHeight)} {Front Wheel Parameter} ]
                                    $cv_Name bind $_dim_CR_Length       <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Component(CrankSet/Length) ]

                                    $cv_Name bind $_dim_ST_Angle        <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Result(Angle/SeatTube/Direction) ]
                                    $cv_Name bind $_dim_ST_Length       <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Result(Length/Saddle/Offset_BB_ST) ]
                                    $cv_Name bind $_dim_ST_Offset       <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Custom(SeatTube/OffsetBB) ]

                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_SD_HB_Height
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_SD_ST_Length
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_FW_Distance
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_FW_DistanceX
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_BB_Height
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_TT_Virtual
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_ST_Virtual
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_HT_Reach_X
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_HT_Stack_Y
                                    rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_CS_LengthX

                                    $cv_Name bind $_dim_SD_HB_Height    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Result(Length/Saddle/Offset_HB) ]
                                    $cv_Name bind $_dim_SD_ST_Length    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Result(Length/Saddle/SeatTube_BB) ]
                                    $cv_Name bind $_dim_FW_Distance     <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Result(Length/FrontWheel/diagonal) ]
                                    $cv_Name bind $_dim_FW_DistanceX    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Result(Length/FrontWheel/horizontal) ]
                                    $cv_Name bind $_dim_BB_Height       <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Result(Length/BottomBracket/Height) ]
                                    $cv_Name bind $_dim_TT_Virtual      <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Result(Length/TopTube/VirtualLength) ]
                                    $cv_Name bind $_dim_ST_Virtual      <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Result(Length/SeatTube/VirtualLength) ]
                                    $cv_Name bind $_dim_HT_Reach_X      <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Result(Length/HeadTube/ReachLength) ]
                                    $cv_Name bind $_dim_HT_Stack_Y      <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Result(Length/HeadTube/StackHeight) ]
                                    $cv_Name bind $_dim_CS_LengthX      <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Result(Length/RearWheel/horizontal) ]

                                        #
                                        # ... proc fill_resultValues ...
                                        # ... proc set_spec_Parameters ...
                            }
                }
                    # -----------------------
                frameTubing_bg {

                            #$cv_Name create circle  [lindex $HeadTube(vct_Top) 0]    -radius 15  -outline red    -width 1        -tags __CenterLine__
                            #$cv_Name create circle  [lindex $HeadTube(vct_Top) 1]        -radius 15  -outline blue   -width 1        -tags __CenterLine__
                            #$cv_Name create circle  [lindex $HeadTube(vct_Bottom) 0]    -radius 15  -outline green  -width 1        -tags __CenterLine__
                            #$cv_Name create circle  [lindex $HeadTube(vct_Bottom) 1]        -radius 15  -outline orange -width 1        -tags __CenterLine__

                            #$cv_Name create circle  [lindex $SeatTube(vct_Top) 0]        -radius 15  -outline red    -width 1        -tags __CenterLine__
                            #$cv_Name create circle  [lindex $SeatTube(vct_Top) 1]            -radius 15  -outline blue   -width 1        -tags __CenterLine__
                            
                            # puts "  $HeadSet(vct_Top)"
                            ##$cv_Name create circle  [lindex $HeadSet(vct_Top) 0]            -radius 12  -outline blue   -width 1        -tags __CenterLine__
                            #$cv_Name create circle  [lindex $HeadSet(vct_Top) 1]            -radius 15  -outline blue   -width 1        -tags __CenterLine__
                            #$cv_Name create circle  $Steerer(Stem)            -radius 10  -outline blue   -width 1        -tags __CenterLine__




                                # -- Dimensions ------------------------
                                #
                            set _dim_ST_Length_01       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $SeatTube(vct_Top)    $SeatTube(BBracket) ] \
                                                                perpendicular   [expr  -100 * $stageScale]  0 \
                                                                gray50 ]
                            set _dim_ST_Length_02       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $SeatTube(BBracket)   $TopTube(SeatTube) ] \
                                                                aligned         [expr   75 * $stageScale]   [expr  -100 * $stageScale] \
                                                                gray50 ]
                            set _dim_HT_Reach_X         [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $HeadTube(Stem)       $BottomBracket(Position) ] \
                                                                horizontal      [expr -110 * $stageScale]   0 \
                                                                gray50 ]
                            set _dim_HT_Stack_Y         [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $HeadTube(Stem)       $BottomBracket(Position) ] \
                                                                vertical        [expr  110 * $stageScale]   [expr  120 * $stageScale]  \
                                                                gray50 ]

                            set _dim_HS_Stem            [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $HeadSet(vct_Top)     $Steerer(Stem)] \
                                                                perpendicular   [expr   50 * $stageScale]   [expr -70 * $stageScale] \
                                                                gray50 ]
                                                                # $HeadSet(Diameter)
                            
                            set _dim_RearBrake          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $RearWheel(Position)  $RearBrake(Mount) ] \
                                                                aligned         [expr  -85 * $stageScale]   0  \
                                                                gray50 ]

                            set _dim_Head_Down_Angle    [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList [list $DownTube(Steerer) $DownTube(BBracket) $Steerer(Ground)] ] \
                                                                180   0 \
                                                                gray50 ]
                            set _dim_Seat_Top_Angle     [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList [list $TopTube(SeatTube) $SeatTube(BBracket) $TopTube(Steerer)] ] \
                                                                110  10 \
                                                                gray50 ]
                                            set pt_base [ vectormath::intersectPoint  $DownTube(Steerer) $DownTube(BBracket) $SeatTube(BBracket) $SeatTube(TopTube) ]
                            set _dim_Down_Seat_Angle    [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList [list $pt_base  $DownTube(Steerer) $TopTube(SeatTube) ] ] \
                                                                110   0 \
                                                                gray50 ]
                            set _dim_Seat_SS_Angle      [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList [list $SeatStay(SeatTube) $Position(IS_ChainSt_SeatSt) $SeatTube(BBracket) ] ] \
                                                                110   0 \
                                                                gray50 ]
                                            set pt_base [ vectormath::intersectPoint  $SeatTube(BBracket) $TopTube(SeatTube)  $BottomBracket(Position) $Position(IS_ChainSt_SeatSt) ]
                            set _dim_ST_CS_Angle        [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList [list $pt_base $TopTube(SeatTube) $Position(IS_ChainSt_SeatSt)] ] \
                                                                110   0 \
                                                                gray50 ]
                            set _dim_Dropout_Angle  [ $cv_Name dimension  angle                 [ appUtil::flatten_nestedList [list $Position(IS_ChainSt_SeatSt) $BottomBracket(Position) $SeatStay(SeatTube) ] ] \
                                                                110   0 \
                                                                gray50 ]

                                            set pt_01   [ vectormath::addVector    $BottomBracket(Position) {-180 0} ]
                                            set pt_base [ vectormath::intersectPoint  $SeatTube(BBracket) $TopTube(SeatTube)  $BottomBracket(Position) $pt_01 ]
                                $cv_Name create centerline [ appUtil::flatten_nestedList $BottomBracket(Position)  $pt_01    ] -fill gray60 -tags __CenterLine__
                            set _dim_SeatTube_Angle     [ $cv_Name dimension  angle            [ appUtil::flatten_nestedList [list $pt_base $SeatTube(TopTube) $pt_01] ] \
                                                                150   0 \
                                                                gray50 ]

                                            set pt_01   [ vectormath::intersectPoint    $Steerer(Stem)  $Steerer(Fork)        $FrontWheel(Position) [vectormath::addVector    $FrontWheel(Position) {-10 0}] ]
                                            set pt_02   [ vectormath::addVector    $pt_01 {-1 0} 120 ]
                                $cv_Name create centerline [ appUtil::flatten_nestedList  $FrontWheel(Position)  $pt_02    ] -fill gray60 -tags __CenterLine__
                           set _dim_HeadTube_Angle      [ $cv_Name dimension  angle            [ appUtil::flatten_nestedList [list $pt_01 $Steerer(Stem) $pt_02] ] \
                                                                110   0 \
                                                                gray50 ]
                        }
                    # -----------------------
                summary_bg {

                            set help_01                 [ list [lindex $BottomBracket(Position) 0] [lindex $LegClearance(Position) 1] ]

                            set _dim_SD_Height          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(BaseCenter)  $Saddle(Position) ] \
                                                                vertical    [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
                                                                gray50 ]
                            set _dim_HB_Height          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position) $Position(BaseCenter) ] \
                                                                vertical    [expr -350 * $stageScale]  [expr  230 * $stageScale]  \
                                                                gray50 ]
                            set _dim_SD_HB_Height       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position) $Saddle(Position) ] \
                                                                vertical    [expr  350 * $stageScale]  [expr -100 * $stageScale]  \
                                                                gray50 ]
                        }
                    # -----------------------
                summary_fg {

                            set help_00                [ vectormath::addVector $SeatTube(Ground) {-200 0} ]
                            set help_rw                [ vectormath::rotateLine $RearWheel(Position)        $RearWheel(Radius)        230 ]
                            set help_fw                [ vectormath::rotateLine $FrontWheel(Position)       $FrontWheel(Radius)       -50 ]
                            set help_fk                [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
                            set distY_SN_LC            [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
                            
                             

                            set _dim_ST_Length          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $SeatTube(Saddle) ] \
                                                                                    aligned     [expr -150 * $stageScale]   [expr -210 * $stageScale]  \
                                                                                    darkblue ]

                            set _dim_BB_Height          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position)    $Position(BaseCenter)] \
                                                                                    vertical    [expr  200 * $stageScale]   [expr    30 * $stageScale]  \
                                                                                    darkred ]

                            set _dim_BB_Depth           [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $RearWheel(Position) $BottomBracket(Position) ] \
                                                                                    vertical    [expr 100 * $stageScale]   [expr 80 * $stageScale] \
                                                                                    gray50 ]
                            set _dim_RW_Radius          [ $cv_Name dimension  radius   [ appUtil::flatten_nestedList  $RearWheel(Position)  $help_rw] \
                                                                                    0        [expr  30 * $stageScale] \
                                                                                    gray50 ]
                            set _dim_FW_Radius          [ $cv_Name dimension  radius   [ appUtil::flatten_nestedList  $FrontWheel(Position) $help_fw] \
                                                                                    0        [expr  30 * $stageScale] \
                                                                                    gray50 ]
                            set _dim_Fork_Rake          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Steerer(Stem)  $help_fk $FrontWheel(Position) ] \
                                                                                    perpendicular [expr 30 * $stageScale]    [expr   80 * $stageScale] \
                                                                                    gray50 ]
                            set _dim_CS_LengthX         [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Ground)  $Position(BaseCenter) ] \
                                                                                    horizontal  [expr   70 * $stageScale]   0 \
                                                                                    gray50 ]
                            set _dim_FW_DistanceX       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(BaseCenter)  $FrontWheel(Ground) ] \
                                                                                    horizontal  [expr   70 * $stageScale]   0 \
                                                                                    gray50 ]
                            set _dim_Wh_Distance        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Ground)  $FrontWheel(Ground) ] \
                                                                                    horizontal  [expr  130 * $stageScale]    0 \
                                                                                    gray50 ]
                            set _dim_FW_Lag             [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $FrontWheel(Ground)  $Steerer(Ground) ] \
                                                                                    horizontal  [expr   70 * $stageScale]   [expr  -70 * $stageScale] \
                                                                                    gray50 ]
                            set _dim_FW_Distance        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position)  $FrontWheel(Position)] \
                                                                                    aligned     [expr  150 * $stageScale]   [expr  -90 * $stageScale] \
                                                                                    gray50 ]
                            set _dim_CS_Length          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Position)  $BottomBracket(Position)] \
                                                                                    aligned     [expr  180 * $stageScale]   [expr   80 * $stageScale] \
                                                                                    gray50 ]
                            set _dim_SD_Nose_Dist       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $BottomBracket(Position) ] \
                                                                                    horizontal  [expr   $distY_SN_LC * $stageScale]   0  \
                                                                                    gray50 ]
                            set _dim_SN_HandleBar       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $HandleBar(Position)] \
                                                                                    horizontal  [expr -120 * $stageScale]    0 \
                                                                                    gray50 ]                                                        
                                                                                    


                            set _dim_HT_Angle           [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList  $Steerer(Ground)         $Steerer(Fork)  $Position(BaseCenter) ] \
                                                                120   0  \
                                                                darkred ]
                            set _dim_ST_Angle           [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList  $SeatTube(Ground)        $SeatTube(Saddle) $help_00 ] \
                                                                120   0  \
                                                                darkred ]

                            set _dim_ST_XPosition       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SeatTube(Saddle)        $BottomBracket(Position) ] \
                                                                horizontal    [expr -120 * $stageScale]    0 \
                                                                darkblue ]
                            set _dim_HT_Reach           [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HeadTube(Stem)          $BottomBracket(Position) ] \
                                                                horizontal  [expr  (120 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                                                                darkblue ]

                            set _dim_SD_XPosition       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Saddle(Position)        $BottomBracket(Position) ] \
                                                                horizontal    [expr  -180 * $stageScale]    0 \
                                                                darkred ]
                            set _dim_HB_XPosition       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                                                                horizontal  [expr   (180 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                                                                darkred ]

                            set _dim_SD_YPosition       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Saddle(Position) ] \
                                                                vertical    [expr -580 * $stageScale]  [expr -130 * $stageScale]  \
                                                                darkred ]
                            set _dim_HB_YPosition       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                                                                vertical    [expr -270 * $stageScale]    [expr  180 * $stageScale]  \
                                                                darkred ]
                            set _dim_HT_Stack           [ $cv_Name dimension  length            [ appUtil::flatten_nestedList        $HeadTube(Stem)    $BottomBracket(Position) ] \
                                                                vertical    [expr -280 * $stageScale]    [expr  170 * $stageScale]  \
                                                                darkblue ]
                            
                            set _dim_LC_Position_x      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $LegClearance(Position)  $BottomBracket(Position) ] \
                                                                horizontal  [expr   $distY_SN_LC * $stageScale]   0  \
                                                                darkblue ]
                            set _dim_LC_Position_y      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $LegClearance(Position)  $Position(BaseCenter) ] \
                                                                vertical    [expr -130 * $stageScale]   [expr   250 * $stageScale]  \
                                                                darkblue ]

                            proc dim_LegClearance {cv_Name BB_Position stageScale} {
                                set pt_01               [ vectormath::addVector        $bikeGeometry::LegClearance(Position)        $BB_Position  ]
                                set TopTube(polygon)    [ bikeGeometry::get_Object TopTube polygon        $BB_Position  ]
                                set pt_09               [ bikeGeometry::coords_get_xy $TopTube(polygon)  9 ]
                                set pt_10               [ bikeGeometry::coords_get_xy $TopTube(polygon) 10 ]
                                set pt_is               [ vectormath::intersectPerp $pt_09 $pt_10 $pt_01 ]
                                set dimension           [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $pt_01 $pt_is] ] \
                                                                aligned    [expr -60 * $stageScale]  [expr 50 * $stageScale] \
                                                                darkred ]
                            }
                            dim_LegClearance  $cv_Name $BottomBracket(Position) $stageScale

                            proc dim_RearWheel_Clearance {cv_Name BB_Position WheelRadius stageScale} {
                                        set pt_03                [ bikeGeometry::get_Object        RearWheel   position    $BB_Position  ]
                                        set SeatTube(polygon)    [ bikeGeometry::get_Object        SeatTube    polygon     $BB_Position  ]
                                        set pt_06                [ bikeGeometry::coords_get_xy $SeatTube(polygon) 5 ]
                                        set pt_07                [ bikeGeometry::coords_get_xy $SeatTube(polygon) 6 ]
                                        set pt_is                [ vectormath::intersectPerp $pt_06 $pt_07 $pt_03 ]
                                        set pt_rw                [ vectormath::addVector $pt_03 [ vectormath::unifyVector  $pt_03  $pt_is  $WheelRadius ] ]
                                        set dimension            [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $pt_rw $pt_is] ] \
                                                                                                aligned    [expr -70 * $stageScale]  [expr 115 * $stageScale] \
                                                                                                gray50 ]
                                    }
                            dim_RearWheel_Clearance  $cv_Name $BottomBracket(Position) $RearWheel(Radius) $stageScale
                            
                        }
                    # -----------------------
                frameDrafting_bg {

                            #$cv_Name create circle  [lindex $HeadTube(vct_Top) 0]    -radius 15  -outline red    -width 1        -tags __CenterLine__
                            #$cv_Name create circle  [lindex $HeadTube(vct_Top) 1]        -radius 15  -outline blue   -width 1        -tags __CenterLine__
                            #$cv_Name create circle  [lindex $HeadTube(vct_Bottom) 0]    -radius 15  -outline green  -width 1        -tags __CenterLine__
                            #$cv_Name create circle  [lindex $HeadTube(vct_Bottom) 1]        -radius 15  -outline orange -width 1        -tags __CenterLine__

                            #$cv_Name create circle  [lindex $SeatTube(vct_Top) 0]        -radius 15  -outline red    -width 1        -tags __CenterLine__
                            #$cv_Name create circle  [lindex $SeatTube(vct_Top) 1]            -radius 15  -outline blue   -width 1        -tags __CenterLine__
                            #             rattleCAD::gui::cv_Custom40 setPrecision 2 force


                                set DownTube(polygon)   [ bikeGeometry::get_Object DownTube polygon        $BB_Position  ]

                                set help_fk             [ vectormath::addVector         $Steerer(Fork)                  [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
                                set help_rw_rim         [ vectormath::rotateLine        $RearWheel(Position)            [expr 0.5 * $RearWheel(RimDiameter) ] 70 ]
                                set help_tt_c1          [ vectormath::rotateLine        $RearWheel(Position)            [expr 0.5 * $RearWheel(RimDiameter) ] 70 ]
                                set help_st_dt          [ bikeGeometry::coords_get_xy $SeatTube(polygon) end]
                                # set help_st_dt          [ bikeGeometry::coords_get_xy $DownTube(polygon) 15 ]
                                # set pt_49                    [ bikeGeometry::coords_get_xy $DownTube(polygon) 15 ]

                                # -- Dimensions ------------------------
                                #
                            set _dim_CS_Length          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $RearWheel(Position)  $BottomBracket(Position)] \
                                                                                        aligned     [expr   70 * $stageScale]   [expr   80 * $stageScale] \
                                                                                        darkblue ]
                            set _dim_CS_LengthX         [ $cv_Name dimension  length            [ appUtil::flatten_nestedList        $BottomBracket(Position)  $RearWheel(Position) ] \
                                                                                        horizontal  [expr -110 * $stageScale]   0 \
                                                                                        gray30 ]
                            set _dim_BB_Depth           [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $RearWheel(Position)  $BottomBracket(Position)] \
                                                                                        vertical    [expr  -160 * $stageScale]   [expr   80 * $stageScale] \
                                                                                        gray30 ]
                            set _dim_FW_Distance        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $BottomBracket(Position)  $FrontWheel(Position)] \
                                                                                        aligned     [expr   70 * $stageScale]   [expr  -90 * $stageScale] \
                                                                                        gray30 ]
                            set _dim_FW_DistanceX       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $BottomBracket(Position)  $FrontWheel(Position) ] \
                                                                                        horizontal  [expr  110 * $stageScale]   0 \
                                                                                        gray30 ]
                            set _dim_Wh_Distance        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $RearWheel(Position)  $FrontWheel(Position) ] \
                                                                                        horizontal  [expr  (150 + $BottomBracket(depth)) * $stageScale]    0 \
                                                                                        gray30 ]
                            set _dim_ST_Length_01       [ $cv_Name dimension  length    [ appUtil::flatten_nestedList   [lindex $SeatTube(vct_Top) 1]  [lindex $SeatTube(vct_Top) 0]  $SeatTube(BBracket) ] \
                                                                                        perpendicular     [expr   145 * $stageScale]    0 \
                                                                                        darkblue ]
                            set _dim_ST_Length_02       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $SeatTube(BBracket)  $TopTube(SeatTube) ] \
                                                                                        aligned            [expr  -120 * $stageScale]    0 \
                                                                                        gray30 ]
                            set _dim_TT_Length          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $TopTube(SeatTube) $TopTube(Steerer) ] \
                                                                                        aligned            [expr  -180 * $stageScale]    0 \
                                                                                        darkblue ]
                            set _dim_DT_Length          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $BottomBracket(Position)  $DownTube(Steerer) ] \
                                                                                        aligned            [expr   120 * $stageScale]    0 \
                                                                                        darkblue ]
                            set _dim_SS_Length          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $RearWheel(Position)  $SeatStay(SeatTube) ] \
                                                                                        aligned            [expr  -160 * $stageScale]    0 \
                                                                                        darkblue ]
                            set _dim_SS_ST_Offset       [ $cv_Name dimension  length    [ appUtil::flatten_nestedList   [lindex $SeatTube(vct_Top) 1]  [lindex $SeatTube(vct_Top) 0]  $SeatStay(SeatTube) ] \
                                                                                        perpendicular     [expr   45 * $stageScale]    [expr   65 * $stageScale] \
                                                                                        darkblue ]
                            if { $RearDrop(OffsetSSPerp) != 0 } {
                                    set _dim_SS_DO_Offset    \
                                                        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $SeatStay(SeatTube) $Position(IS_ChainSt_SeatSt) $RearWheel(Position)] \
                                                                                        perpendicular [expr -75 * $stageScale]    [expr  -35 * $stageScale] \
                                                                                        gray30 ]
                                }
                            if { $RearDrop(OffsetCSPerp) != 0 } {
                                    set _dim_CS_DO_Offset    \
                                                        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $BottomBracket(Position) $Position(IS_ChainSt_SeatSt) $RearWheel(Position)] \
                                                                                        perpendicular [expr -95 * $stageScale]    [expr   35 * $stageScale] \
                                                                                        gray30 ]
                                }
                            set _dim_TT_Offset          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $HeadTube(vct_Top)  $TopTube(Steerer)  ] \
                                                                                        perpendicular            [expr    (-70 + 0.5 * $HeadTube(Diameter)) * $stageScale]    [expr  -35 * $stageScale] \
                                                                                        darkblue ]
                            set _dim_DT_Offset          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $HeadTube(vct_Bottom)  $DownTube(Steerer) ] \
                                                                                        perpendicular            [expr    (70 - 0.5 * $HeadTube(Diameter))* $stageScale]    [expr    0 * $stageScale] \
                                                                                        darkblue ]

                                # -- HT Stack & Reach ------------------
                                #
                            set _dim_HT_Reach_X         [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $HeadTube(Stem)  $BottomBracket(Position) ] \
                                                                                        horizontal  [expr  -90 * $stageScale ]    0 \
                                                                                        gray50 ]
                            set _dim_HT_Stack_Y         [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $HeadTube(Stem)        $BottomBracket(Position) ] \
                                                                                        vertical    [expr  110 * $stageScale]    [expr  120 * $stageScale]  \
                                                                                        gray50 ]

                                # -- Fork Details ----------------------
                                #
                            set _dim_Fork_Rake          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $Steerer(Stem)  $help_fk $FrontWheel(Position) ] \
                                                                                        perpendicular [expr  50 * $stageScale]    [expr  -80 * $stageScale] \
                                                                                        gray30 ]

                            set _dim_Fork_Height        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $Steerer(vct_Bottom) $FrontWheel(Position)  ] \
                                                                                        perpendicular        [expr  (-150 + 0.5 * $Steerer(Diameter))  * $stageScale]    [expr  80 * $stageScale] \
                                                                                        gray30 ]


                                # -- Steerer Details ----------------------
                                set pt_01                    [ bikeGeometry::get_Object            Steerer/Start    position    $BB_Position  ]
                                set pt_02                    [ bikeGeometry::get_Object            Steerer/End        position    $BB_Position  ]
                                    # puts "       -> _dim_STR_Length"
                            set _dim_STR_Length         [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $Steerer(vct_Bottom)  $Steerer(End) ] \
                                                                                        perpendicular            [expr    (190 - 0.5 * $Steerer(Diameter)) * $stageScale]    [expr   5 * $stageScale] \
                                                                                        gray30 ]


                                # -- Centerline Angles -----------------
                                #
                            set _dim_Head_Top_Angle     [ $cv_Name dimension  angle            [ appUtil::flatten_nestedList [list $TopTube(Steerer) $Steerer(Stem) $TopTube(SeatTube)] ] \
                                                                                        130   0 \
                                                                                        darkred ]
                            set _dim_Head_Down_Angle    [ $cv_Name dimension  angle            [ appUtil::flatten_nestedList [list $DownTube(Steerer) $DownTube(BBracket) $Steerer(Ground)] ] \
                                                                                        170 -10 \
                                                                                        darkred ]
                            set _dim_Seat_Top_Angle     [ $cv_Name dimension  angle            [ appUtil::flatten_nestedList [list $TopTube(SeatTube) $SeatTube(BBracket) $TopTube(Steerer)] ] \
                                                                                        150   0 \
                                                                                        darkred ]
                            
                            
                                            set pt_base [ vectormath::intersectPoint  $DownTube(Steerer) $DownTube(BBracket) $SeatTube(BBracket) $SeatTube(TopTube) ]
                            set _dim_Down_Seat_Angle    [ $cv_Name dimension  angle            [ appUtil::flatten_nestedList [list $pt_base $DownTube(Steerer) $TopTube(SeatTube) ] ] \
                                                                                         90   0 \
                                                                                        darkred ]
                                                                                        
                                                                                        
                                                                                        
                                            set pt_base [ vectormath::intersectPoint  $SeatTube(BBracket) $TopTube(SeatTube)  $BottomBracket(Position) $Position(IS_ChainSt_SeatSt) ]
                            set _dim_ST_CS_Angle        [ $cv_Name dimension  angle            [ appUtil::flatten_nestedList [list $pt_base $TopTube(SeatTube) $Position(IS_ChainSt_SeatSt)] ] \
                                                                                         90   0 \
                                                                                        darkred ]
                            set _dim_SS_CS_Angle        [ $cv_Name dimension  angle            [ appUtil::flatten_nestedList [list $Position(IS_ChainSt_SeatSt) $BottomBracket(Position) $SeatStay(SeatTube)] ] \
                                                                                         90   0 \
                                                                                        darkred ]
                                            set pt_01   [ vectormath::addVector    $BottomBracket(Position) {-1000 0} ]
                                            set pt_base [ vectormath::intersectPoint  $SeatTube(BBracket) $TopTube(SeatTube)  $BottomBracket(Position) $pt_01 ]
                            set _dim_SeatTube_Angle     [ $cv_Name dimension  angle            [ appUtil::flatten_nestedList [list $pt_base $SeatTube(TopTube) $pt_01] ] \
                                                                                        130   0 \
                                                                                        darkred ]
                                            set pt_01   [ vectormath::intersectPoint    $Steerer(Stem)  $Steerer(Fork)        $FrontWheel(Position) [vectormath::addVector    $FrontWheel(Position) {-10 0}] ]
                                            set pt_02   [ vectormath::addVector    $pt_01 {-1 0} 100 ]
                                $cv_Name create centerline [ appUtil::flatten_nestedList  $FrontWheel(Position)  $pt_02    ] -fill gray60 -tags __CenterLine__
                           set _dim_HeadTube_Angle      [ $cv_Name dimension  angle            [ appUtil::flatten_nestedList [list $pt_01 $Steerer(Stem) $pt_02] ] \
                                                                                         90   0 \
                                                                                        darkred ]



                                # -- Rear Brake Mount ------------------
                            if {$Rendering(BrakeRear) != {off}} {
                                switch $Rendering(BrakeRear) {
                                    Rim {
                                                set SeatStay(polygon)       [ bikeGeometry::get_Object            SeatStay polygon $BB_Position  ]
                                                set pt_01                   [ bikeGeometry::coords_get_xy        $SeatStay(polygon)  8 ]
                                                set pt_02                   [ bikeGeometry::coords_get_xy        $SeatStay(polygon)  9 ]
                                                set pt_03                   [ vectormath::addVector    $bikeGeometry::RearBrake(Shoe)    $BB_Position  ]
                                                set pt_04                   [ vectormath::addVector    $bikeGeometry::RearBrake(Help)    $BB_Position  ]
                                                set pt_10                   [ vectormath::intersectPerp            $pt_01 $pt_02 $pt_04  ]
                                            set _dim_Brake_Offset_01    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $pt_10 $pt_04 ] \
                                                                                                        aligned            [expr   40 * $stageScale]    [expr  55 * $stageScale] \
                                                                                                        gray30 ]
                                            set _dim_Brake_Offset_02    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $pt_03  $pt_04 ] \
                                                                                                        aligned            [expr   -50 * $stageScale]    [expr   65 * $stageScale] \
                                                                                                        gray30 ]
                                            set _dim_Brake_Distance     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $RearWheel(Position)  $RearBrake(Mount) ] \
                                                                                                        aligned            [expr  -120 * $stageScale]    0 \
                                                                                                        gray30 ]
                                        }
                                }
                            }



                                # -- Bottle Cage Mount ------------------
                            if {$Rendering(BottleCage_ST) != {off}} {
                                            set st_direction            [ bikeGeometry::get_Object SeatTube        direction ]
                                            set pt_01                   [ bikeGeometry::get_Object    SeatTube/BottleCage/Offset   position    $BB_Position]
                                            set pt_02                   [ bikeGeometry::get_Object    SeatTube/BottleCage/Base     position    $BB_Position]
                                            set pt_03                   [ vectormath::addVector    $pt_02    $st_direction    [expr -1.0 * $bikeGeometry::BottleCage(SeatTube)] ]
                                            set pt_04                  [ vectormath::intersectPerp         $pt_01 $pt_02 $BB_Position ]
                                            #set pt_04                   $BB_Position
                                              # set pt_04                   [ bikeGeometry::coords_get_xy $SeatTube(polygon)  0 ]

                                            set dimension        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $pt_01  $pt_02 ] \
                                                                                                    aligned        [expr  90 * $stageScale]    [expr    0 * $stageScale] \
                                                                                                    gray50 ]
                                            set dimension        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $pt_02  $pt_03 ] \
                                                                                                    aligned        [expr  90 * $stageScale]    [expr -115 * $stageScale] \
                                                                                                    gray50 ]
                                            set dimension        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $help_st_dt        $pt_02 ] \
                                                                                                    aligned        [expr  35 * $stageScale]    [expr -105 * $stageScale] \
                                                                                                    gray50 ]
                                            set dimension        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $pt_04     $help_st_dt ] \
                                                                                                    aligned        [expr  35 * $stageScale]    [expr   50 * $stageScale] \
                                                                                                    gray50 ]
                            } else {
                                            set pt_04                    [ bikeGeometry::coords_get_xy $SeatTube(polygon)  0 ]
                                            set dimension        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $pt_04  $DownTube(BBracket) $help_st_dt ] \
                                                                                                    perpendicular   [expr  50 * $stageScale]    [expr   50 * $stageScale] \
                                                                                                    gray50 ]
                            }

                            if {$Rendering(BottleCage_DT) != {off}} {
                                            set dt_direction            [ bikeGeometry::get_Object     DownTube        direction ]
                                            set pt_01                   [ bikeGeometry::get_Object     DownTube/BottleCage/Offset    position    $BB_Position ]
                                            set pt_02                   [ bikeGeometry::get_Object     DownTube/BottleCage/Base    position    $BB_Position ]
                                            set pt_03                   [ vectormath::addVector    $pt_02    $dt_direction    [expr -1.0 * $bikeGeometry::BottleCage(DownTube)] ]
                                            set pt_04h                  [ vectormath::intersectPerp         $DownTube(BBracket) $DownTube(Steerer) $help_st_dt ]
                                            set vct_04h                 [ vectormath::subVector             $help_st_dt $pt_04h ]
                                            set pt_04                   [ vectormath::addVector             $DownTube(BBracket) $vct_04h ]

                                            if { $Rendering(BottleCage_DT_L) != {off}} { set addDist 40 } else { set addDist 0}

                                            set dimension        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $pt_01  $pt_02 ] \
                                                                                                    aligned        [expr -1.0 * (180 + $addDist) * $stageScale]    0 \
                                                                                                    gray50 ]
                                            set dimension        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $pt_02  $pt_03 ] \
                                                                                                    aligned        [expr -1.0 * (180 + $addDist) * $stageScale]    [expr   15 * $stageScale] \
                                                                                                    gray50 ]
                                            set dimension        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $help_st_dt        $pt_02 ] \
                                                                                                    aligned        [expr -1.0 * (35 + $addDist) * $stageScale]        [expr -115 * $stageScale] \
                                                                                                    gray50 ]
                                            set dimension        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $pt_04     $help_st_dt ] \
                                                                                                    aligned        [expr -1.0 * (35 + $addDist) * $stageScale]    [expr   50 * $stageScale] \
                                                                                                    gray50 ]
                            } else {
                                            set pt_04h                  [ vectormath::intersectPerp     $DownTube(BBracket) $DownTube(Steerer) $help_st_dt ]
                                            set vct_04h                 [ vectormath::subVector         $help_st_dt $pt_04h ]
                                            set pt_04                   [ vectormath::addVector            $DownTube(BBracket) $vct_04h ]

                                            if { $Rendering(BottleCage_DT_L) != {off}} { set addDist 40 } else { set addDist 0}

                                            set dimension        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $pt_04  $DownTube(BBracket) $help_st_dt ] \
                                                                                                    perpendicular   [expr -1.0 * (50 + $addDist) * $stageScale]    [expr   50 * $stageScale] \
                                                                                                    gray50 ]
                            }

                            if {$Rendering(BottleCage_DT_L) != {off}} {
                                            set dt_direction            [ bikeGeometry::get_Object DownTube        direction ]
                                            set pt_01                   [ bikeGeometry::get_Object    DownTube/BottleCage_Lower/Offset    position    $BB_Position ]
                                            set pt_02                   [ bikeGeometry::get_Object    DownTube/BottleCage_Lower/Base        position    $BB_Position ]
                                            set pt_03                   [ vectormath::addVector    $pt_02    $dt_direction    [expr -1.0 * $bikeGeometry::BottleCage(DownTube_Lower) ] ]

                                            set dimension       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $pt_01  $pt_02 ] \
                                                                                                    aligned        [expr -145 * $stageScale]    0 \
                                                                                                    gray50 ]
                                            set dimension       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $pt_02  $pt_03 ] \
                                                                                                    aligned        [expr -145 * $stageScale]    [expr  15 * $stageScale] \
                                                                                                    darkblue ]
                            }



                                # -- Cutting Length --------------------
                                #
                                # --- modify dimension precision from 1 to 2
                           # reset be 3.4.00.34
                           #rattleCAD::gui::cv_Custom40 setPrecision 2
                                # 
                                set TopTube(polygon)    [ bikeGeometry::get_Object TopTube polygon $BB_Position  ]
                                set pt_01               [ bikeGeometry::coords_get_xy $TopTube(polygon)  8 ]
                                set pt_02               [ bikeGeometry::coords_get_xy $TopTube(polygon) 11 ]
                                set pt_03               [ bikeGeometry::coords_get_xy $TopTube(polygon)  3 ]
                            set _dim_TopTube_CutLength  [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $pt_01 $pt_02] ] \
                                                                                        aligned    [expr 110 * $stageScale] [expr 10 * $stageScale] \
                                                                                        darkviolet ]
                                set DownTube(polygon)   [ bikeGeometry::get_Object DownTube polygon $BB_Position  ]
                                set pt_04               [ bikeGeometry::coords_get_xy $DownTube(polygon)  2 ]
                            set _dim_DownTube_CutLength [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $BB_Position $pt_04] ] \
                                                                                        aligned    [expr  70 * $stageScale] [expr 10 * $stageScale] \
                                                                                        darkviolet ]
                                set SeatTube(polygon)   [ bikeGeometry::get_Object SeatTube polygon $BB_Position  ]
                                set pt_05               [ bikeGeometry::coords_get_xy $SeatTube(polygon)  2 ]
                            set _dim_SeatTube_CutLength [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $help_st_dt $pt_05] ] \
                                                                                        aligned    [expr   90 * $stageScale] [expr 10 * $stageScale] \
                                                                                        darkviolet ]
                                                                                        rattleCAD::gui::cv_Custom40 setPrecision 2
                                #  --- reset dimension precision to default
                            # reset be 3.4.00.34
                            # rattleCAD::gui::cv_Custom40 setPrecision reset
                                                                                                                                                                                


                                # -- Tubing Details --------------------
                                #
                                set HeadTube(polygon)   [ bikeGeometry::get_Object HeadTube polygon $BB_Position  ]
                                set pt_01               [ bikeGeometry::coords_get_xy $HeadTube(polygon) 0 ]
                                set pt_02               [ bikeGeometry::coords_get_xy $HeadTube(polygon) 1 ]
                            set _dim_HeadTube_Length    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $pt_01 $pt_02] ] \
                                                                                        aligned    [expr 90 * $stageScale]   0 \
                                                                                        darkblue ]

                                set HeadTube(polygon)   [ bikeGeometry::get_Object HeadTube polygon $BB_Position  ]
                                set pt_01               [ bikeGeometry::coords_get_xy $HeadTube(polygon) 2 ]
                                set TopTube(polygon)    [ bikeGeometry::get_Object TopTube polygon $BB_Position  ]
                                set pt_02               [ bikeGeometry::coords_get_xy $TopTube(polygon) 8 ]
                            set _dim_HeadTube_OffsetTT  [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $pt_01 $pt_02] ] \
                                                                                        aligned    [expr 50 * $stageScale] [expr 50 * $stageScale] \
                                                                                        gray30 ]

                                set HeadTube(polygon)   [ bikeGeometry::get_Object HeadTube polygon $BB_Position  ]
                                set pt_01               [ bikeGeometry::coords_get_xy $HeadTube(polygon) 3 ]
                                set DownTube(polygon)   [ bikeGeometry::get_Object DownTube polygon $BB_Position  ]
                                set pt_02               [ bikeGeometry::coords_get_xy $DownTube(polygon) 2 ]
                            set _dim_HeadTube_OffsetDT  [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $pt_01 $pt_02] ] \
                                                                                        aligned    [expr -50 * $stageScale] [expr 50 * $stageScale] \
                                                                                        gray30 ]

                                set TopTube(polygon)    [ bikeGeometry::get_Object TopTube polygon $BB_Position  ]
                                set pt_01               [ bikeGeometry::coords_get_xy $TopTube(polygon) 11 ]
                                set SeatTube(polygon)   [ bikeGeometry::get_Object SeatTube polygon $BB_Position  ]
                                set pt_02               [ bikeGeometry::coords_get_xy $SeatTube(polygon) 2 ]
                            set _dim_SeatTube_Extension [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $pt_01 $pt_02] ] \
                                                                                        aligned    [expr 65 * $stageScale] [expr -50 * $stageScale] \
                                                                                        gray30 ]

                                set pt_01               [ bikeGeometry::get_Object TopTube/Start    position $BB_Position  ]
                                set pt_02               [ bikeGeometry::get_Object SeatStay/End    position $BB_Position  ]
                                if { [lindex $pt_02 1] < [lindex $pt_01 1] } {
                                        set dim_coords  [ appUtil::flatten_nestedList [list $pt_01 $pt_02] ]
                                } else {
                                        set dim_coords  [ appUtil::flatten_nestedList [list $pt_02 $pt_01] ]
                                }
                            set _dim_SeatStay_Offset    [ $cv_Name dimension  length            $dim_coords  \
                                                                                        aligned    [expr -60 * $stageScale]   [expr -50 * $stageScale] \
                                                                                        gray30 ]

                            if { $DownTube(OffsetBB) != 0 } {
                                    set pt_01           [ bikeGeometry::get_Object    DownTube/End    position        $BB_Position  ]
                                    set pt_02           [ bikeGeometry::get_Object    DownTube/Start    position        $BB_Position  ]
                                    set pt_03           $BB_Position
                                    if { [lindex $pt_02 1] >= [lindex $pt_03 1] } {
                                            set dim_distance    [expr -70 * $stageScale]
                                            set dim_offset      [expr -50 * $stageScale]
                                    } else {
                                            set dim_distance    [expr  70 * $stageScale]
                                            set dim_offset      [expr  50 * $stageScale]
                                    }
                                set _dim_DownTube_Offset        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $pt_01 $pt_02 $pt_03] ] \
                                                                                            {perpendicular}    $dim_distance $dim_offset \
                                                                                            darkred ]
                            }
                            if { $SeatTube(OffsetBB) != 0 } {
                                    set pt_01                [ bikeGeometry::get_Object    SeatTube/End    position        $BB_Position  ]
                                    set pt_02                [ bikeGeometry::get_Object    SeatTube/Start    position        $BB_Position  ]
                                    set pt_03               $BB_Position
                                    if { [lindex $pt_02 1] >= [lindex $pt_03 1] } {
                                            set dim_distance    [expr -70 * $stageScale]
                                            set dim_offset      [expr -50 * $stageScale]
                                    } else {
                                            set dim_distance    [expr  70 * $stageScale]
                                            set dim_offset      [expr  50 * $stageScale]
                                    }
                                set _dim_SeatTube_Offset        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $pt_01 $pt_02 $pt_03] ] \
                                                                                            {perpendicular}    $dim_distance $dim_offset \
                                                                                            darkred ]
                            }

                                set pt_01               [ bikeGeometry::get_Object            TopTube/End        position        $BB_Position  ]
                                set pt_hlp              [ bikeGeometry::get_Object            TopTube/Start    position        $BB_Position  ]
                                set pt_cnt              [ vectormath::center        $pt_01  $pt_hlp]
                                set pt_02               [ list [expr [lindex $pt_cnt 0] + 2] [lindex $pt_cnt 1]  ]
                            set _dim_TopTube_Angle      [ $cv_Name dimension  angle            [ appUtil::flatten_nestedList [list $pt_cnt $pt_02 $pt_01] ] \
                                                                                        100   -30 \
                                                                                        darkred ]

                                set pt_01               [ bikeGeometry::get_Object            HeadTube/Start    position    $BB_Position  ]
                                set pt_02               [ bikeGeometry::get_Object            Steerer/Start    position    $BB_Position  ]
                                    # puts "       -> _dim_HeadSet_Bottom"
                            set _dim_HeadSet_Bottom     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList $Steerer(vct_Bottom) [lindex $HeadTube(vct_Bottom) 1] ] \
                                                                                        perpendicular    [expr (150 - 0.5 * $Steerer(Diameter)) * $stageScale]   [expr -50 * $stageScale] \
                                                                                        gray30 ]

                                set RimDiameter         [rattleCAD::control::getValue Component/Wheel/Rear/RimDiameter]
                                set TyreHeight          [rattleCAD::control::getValue Component/Wheel/Rear/TyreHeight]
                                set WheelRadius         [ expr 0.5 * $RimDiameter + $TyreHeight ]
                                set pt_03               [ bikeGeometry::get_Object        RearWheel    position  $BB_Position  ]
                                set SeatTube(polygon)   [ bikeGeometry::get_Object        SeatTube     polygon   $BB_Position  ]
                                set pt_06               [ bikeGeometry::coords_get_xy $SeatTube(polygon) 5 ]
                                set pt_07               [ bikeGeometry::coords_get_xy $SeatTube(polygon) 6 ]
                                set pt_is               [ vectormath::intersectPerp $pt_06 $pt_07 $pt_03 ]
                                set pt_rw               [ vectormath::addVector $pt_03 [ vectormath::unifyVector  $pt_03  $pt_is  $WheelRadius ] ]
                            set _dim_RearWheel_Clear    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $pt_rw $pt_is] ] \
                                                                                        aligned    [expr -100 * $stageScale]  [expr -80 * $stageScale] \
                                                                                        gray50 ]


                                set pt_01               [ vectormath::addVector        $bikeGeometry::LegClearance(Position)        $BB_Position  ]
                                set TopTube(polygon)    [ bikeGeometry::get_Object TopTube polygon        $BB_Position  ]
                                set pt_09               [ bikeGeometry::coords_get_xy $TopTube(polygon)  9 ]
                                set pt_10               [ bikeGeometry::coords_get_xy $TopTube(polygon) 10 ]
                                set pt_is               [ vectormath::intersectPerp $pt_09 $pt_10 $pt_01 ]
                            set _dim_LegClearance       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $pt_01 $pt_is] ] \
                                                                                        aligned    [expr -30 * $stageScale]  [expr 50 * $stageScale] \
                                                                                        gray50 ]


                        }
                    # -----------------------
                reference_bg {

                              set help_00            [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
                              set length_00          [ expr [lindex $Reference(SaddleNose) 1] - [lindex $Reference(HandleBar) 1]]
                              
                              # -- Dimensions ------------------------
                              #  
                            set _dim_BB_Depth           [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Position)   $BottomBracket(Position) ] \
                                                                vertical    [expr -100 * $stageScale]  [expr 80 * $stageScale] \
                                                                gray50 ]

                            set _dim_HB_XPosition       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Reference(HandleBar)  $BottomBracket(Position) ] \
                                                                horizontal  [expr (80 + $length_00) * $stageScale ]    0 \
                                                                gray50 ]

                            
                            set _dim_HB_FW              [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $FrontWheel(Position)    $Reference(HandleBar) ] \
                                                                aligned     [expr  100 * $stageScale]  [expr  -90 * $stageScale]  \
                                                                gray50 ] 
                            set _dim_HB_BB              [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Reference(HandleBar) $BottomBracket(Position) ] \
                                                                aligned     [expr  100 * $stageScale]  [expr    0 * $stageScale]  \
                                                                gray50 ] 
                            set _dim_SD_BB              [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Reference(SaddleNose)    $BottomBracket(Position) ] \
                                                                aligned     [expr -100 * $stageScale]  [expr 200 * $stageScale]  \
                                                                gray50 ] 
                                
                            
                            
                            set _dim_Wh_Distance        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Ground)  $FrontWheel(Ground) ] \
                                                                horizontal  [expr  130 * $stageScale]    0 \
                                                                gray50 ]           
                            set _dim_FW_DistanceX       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(BaseCenter)  $FrontWheel(Ground) ] \
                                                                horizontal  [expr   70 * $stageScale]   0 \
                                                                gray50 ]
                            set _dim_RW_DistanceX       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Ground)  $Position(BaseCenter)  ] \
                                                                horizontal  [expr   70 * $stageScale]   0 \
                                                                gray50 ]
                                                
                            # set _dim_HT_Angle           [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList  $Steerer(Ground)  $Steerer(Fork)  $Position(BaseCenter) ] \
                                                                150   0  \
                                                                gray50 ]
                            # set _dim_ST_Angle          [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList   $SeatTube(Ground)    $SeatPost(SeatTube) $help_00 ] \
                                                                150   0  \
                                                                gray50 ]

                            set _dim_SD_03              [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Reference(SaddleNose)    $RearWheel(Position) ] \
                                                                aligned     [expr   70 * $stageScale]  [expr  130 * $stageScale]  \
                                                                gray50 ]                                                                        
                            set _dim_HB_03              [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Position) $Reference(HandleBar) ] \
                                                                aligned     [expr   70 * $stageScale]  [expr -230 * $stageScale]  \
                                                                gray50 ]                                                                        

                        }
                    # -----------------------
                reference_fg {                                                  
                            
                            set _dim_BB_Height          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position)    $Position(BaseCenter)] \
                                                                vertical    [expr -150 * $stageScale]  [expr  -80 * $stageScale]  \
                                                                orange ]
                            set _dim_FW_Radius          [ $cv_Name dimension  length   [ appUtil::flatten_nestedList  $FrontWheel(Position)  $FrontWheel(Ground) ] \
                                                                vertical    [expr -150 * $stageScale]  [expr   30 * $stageScale] \
                                                                orange ]
                            set _dim_RW_Radius          [ $cv_Name dimension  length   [ appUtil::flatten_nestedList  $RearWheel(Position)   $RearWheel(Ground)  ] \
                                                                vertical    [expr 150 * $stageScale]   [expr   30 * $stageScale] \
                                                                orange ]
                                                                
                            set _dim_Rear_Length        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Position) $BottomBracket(Position) ] \
                                                                aligned     [expr  180 * $stageScale]  [expr   80 * $stageScale]  \
                                                                orange ]                                                                        
                            set _dim_Front_Length       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $FrontWheel(Position) ] \
                                                                aligned     [expr  150 * $stageScale]  [expr -150 * $stageScale]  \
                                                                orange ] 
                            
                            
                            set _dim_SD_HB              [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Reference(SaddleNose)    $Reference(HandleBar) ] \
                                                                aligned     [expr -250 * $stageScale]  [expr   0 * $stageScale]  \
                                                                darkblue ] 
                            set _dim_SD_HB_Height       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Reference(HandleBar) $Reference(SaddleNose) ] \
                                                                vertical    [expr  380 * $stageScale]  [expr -100 * $stageScale]  \
                                                                darkblue ]
                            
                            
                                                                
                                                                
                            set _dim_SD_Distance        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Reference(SaddleNose) $BottomBracket(Position) ] \
                                                                horizontal  [expr -80 * $stageScale] [expr  80 * $stageScale] \
                                                                darkorange ]
                            set _dim_SD_HB_Length       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Reference(SaddleNose) $Reference(HandleBar) ] \
                                                                horizontal  [expr -150 * $stageScale ]    0 \
                                                                darkorange ]
                            set _dim_SD_Height          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(BaseCenter)  $Reference(SaddleNose) ] \
                                                                vertical    [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
                                                                darkorange ]
                            set _dim_HB_Height          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Reference(HandleBar) $Position(BaseCenter) ] \
                                                                vertical    [expr -380 * $stageScale]  [expr  230 * $stageScale]  \
                                                                darkorange ]
                                                                                                                                                                                                  
                                                                
                                                                
                            
                            rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_BB_Height
                            rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_FW_Radius
                            rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_RW_Radius
                            rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_Rear_Length
                            rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_Front_Length
                            
                            rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_SD_HB
                            rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_SD_HB_Height
                            
                            rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_SD_Distance
                            rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_SD_HB_Length
                            rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_SD_Height
                            rattleCAD::gui::object_CursorBinding        $cv_Name    $_dim_HB_Height
                            
                            
                            
                                # Result(Length/FrontWheel/diagonal)
                                # Result(Length/BottomBracket/Height)
                                # Custom(WheelPosition/Rear)
                                # Rear Wheel Parameter:
                                #   list://Component(Wheel/Rear/RimDiameter@SELECT_Rim)
                                #          Component(Wheel/Rear/TyreHeight) 
                                # Front Wheel Parameter:
                                #   list://Component(Wheel/Front/RimDiameter@SELECT_Rim)
                                #          Component(Wheel/Front/TyreHeight)
                            $cv_Name bind $_dim_BB_Height       <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Result(Length/BottomBracket/Height) ]
                            $cv_Name bind $_dim_RW_Radius       <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  {list://Component(Wheel/Rear/RimDiameter@SELECT_Rim)  Result(Length/RearWheel/Radius)  } {Rear Wheel Parameter} ]
                            $cv_Name bind $_dim_FW_Radius       <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  {list://Component(Wheel/Front/RimDiameter@SELECT_Rim) Result(Length/FrontWheel/Radius) } {Front Wheel Parameter} ]
                            $cv_Name bind $_dim_Rear_Length     <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Custom(WheelPosition/Rear) ]
                            $cv_Name bind $_dim_Front_Length    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Result(Length/FrontWheel/diagonal) ]
                            
                            $cv_Name bind $_dim_SD_HB           <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Result(Length/Reference/SaddleNose_HB)]
                            $cv_Name bind $_dim_SD_HB_Height    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Result(Length/Reference/Heigth_SN_HB)]
                            
                            $cv_Name bind $_dim_SD_Distance     <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Reference(SaddleNose_Distance) ]
                            $cv_Name bind $_dim_SD_HB_Length    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Reference(HandleBar_Distance) ]
                            $cv_Name bind $_dim_SD_Height       <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Reference(SaddleNose_Height) ]
                            $cv_Name bind $_dim_HB_Height       <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  Reference(HandleBar_Height) ]
                            
                            
                            #Result(Length/Control/HandleBar_FW)                            
                            #Result(Length/Control/HandleBar_BB)
                            #Result(Length/Control/SeatPost_HB)                            
                            #Result(Length/Control/SeatPost_BB)

                            
                            
                                                                     
                        }
                    # -----------------------
                frameJig_bg_rattleCAD {

                              set help_fk         [ vectormath::intersectPoint    $Steerer(Fork)  $Steerer(Stem)   $FrontWheel(Position) $RearWheel(Position) ]

                                # -- Dimensions ------------------------
                                #
                            set _dim_Jig_length     [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $RearWheel(Position)    $FrameJig(HeadTube)] \
                                                                aligned     [expr  -110 * $stageScale]   0 \
                                                                darkblue ]

                            set _dim_CS_Length      [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $RearWheel(Position)    $BottomBracket(Position)] \
                                                                aligned     [expr    80 * $stageScale]   0 \
                                                                gray30 ]
                            set _dim_CS_LengthHor   [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $BottomBracket(Position)    $RearWheel(Position)  ] \
                                                                horizontal  [expr  -100 * $stageScale]   0 \
                                                                gray30 ]
                            set _dim_BB_Depth       [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $BottomBracket(Position)    $RearWheel(Position) ] \
                                                                vertical    [expr -180 * $stageScale]   [expr -70 * $stageScale]  \
                                                                gray30 ]
                            set _dim_HT_Dist_x      [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $BottomBracket(Position)    $HeadTube(Fork)] \
                                                                horizontal  [expr   100 * $stageScale]   0 \
                                                                gray30 ]
                            set _dim_HT_Dist_y      [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $BottomBracket(Position)    $HeadTube(Fork)] \
                                                                vertical    [expr   320 * $stageScale]   0 \
                                                                gray30 ]
                            set _dim_WH_Distance    [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $RearWheel(Position)    $help_fk] \
                                                                aligned     [expr   220 * $stageScale]   0 \
                                                                gray30 ]
                            
                            set _dim_HT_Offset      [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $FrameJig(HeadTube)         $HeadTube(Fork)] \
                                                                aligned     [expr   100 * $stageScale]   [expr  -100 * $stageScale] \
                                                                darkred ]
                            set _dim_CS_LengthJig   [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $RearWheel(Position)    $FrameJig(SeatTube)] \
                                                                aligned     [expr   -60 * $stageScale]   0 \
                                                                darkred ]
                            set _dim_MN_LengthJig   [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $FrameJig(SeatTube)     $FrameJig(HeadTube)] \
                                                                aligned     [expr   -60 * $stageScale]   0 \
                                                                darkred ]
                            set _dim_BB_DepthJIg    [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $BottomBracket(Position)    $FrameJig(SeatTube)] \
                                                                aligned     [expr    60 * $stageScale]   0 \
                                                                darkred ]
                            set _dim_ST_Angle       [ $cv_Name dimension  angle [ appUtil::flatten_nestedList  $FrameJig(SeatTube)   $RearWheel(Position)   $BottomBracket(Position) ] \
                                                                90   0  \
                                                                darkred ]
                                # -- Fork Details ----------------------
                                #
                            set _dim_HT_Fork        [ $cv_Name dimension  length  [ appUtil::flatten_nestedList  $FrameJig(HeadTube)    $help_fk] \
                                                                aligned     [expr  -100 * $stageScale]   0 \
                                                                darkblue ]
                            set _dim_Fork_Height    [ $cv_Name dimension  length  [ appUtil::flatten_nestedList            $help_fk $HeadTube(Fork)  ] \
                                                                aligned        [expr   150 * $stageScale]   0 \
                                                                gray30 ]
                        }
                    # -----------------------
                frameJig_bg_selberbruzzler {

                              set help_fk         [ vectormath::intersectPoint    $Steerer(Fork)  $Steerer(Stem)   $FrontWheel(Position) $RearWheel(Position) ]

                                # -- Dimensions ------------------------
                                #
                            set _dim_Jig_length     [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $RearWheel(Position)    $FrameJig(HeadTube)] \
                                                                aligned     [expr  -110 * $stageScale]   0 \
                                                                darkblue ]

                            set _dim_CS_Length      [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $RearWheel(Position)    $BottomBracket(Position)] \
                                                                aligned     [expr    80 * $stageScale]   0 \
                                                                gray30 ]
                            set _dim_CS_LengthHor   [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $BottomBracket(Position)    $RearWheel(Position)  ] \
                                                                horizontal  [expr  -100 * $stageScale]   0 \
                                                                gray30 ]
                            set _dim_BB_Depth       [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $BottomBracket(Position)    $RearWheel(Position) ] \
                                                                vertical    [expr -180 * $stageScale]   [expr -70 * $stageScale]  \
                                                                gray30 ]
                            set _dim_HT_Dist_x      [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $BottomBracket(Position)    $HeadTube(Fork)] \
                                                                horizontal  [expr   100 * $stageScale]   0 \
                                                                gray30 ]
                            set _dim_HT_Dist_y      [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $BottomBracket(Position)    $HeadTube(Fork)] \
                                                                vertical    [expr   320 * $stageScale]   0 \
                                                                gray30 ]
                            set _dim_WH_Distance    [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $RearWheel(Position)    $help_fk] \
                                                                aligned     [expr   220 * $stageScale]   0 \
                                                                gray30 ]
                            
                            set _dim_HT_Offset      [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $FrameJig(HeadTube)         $HeadTube(Fork)] \
                                                                aligned     [expr   100 * $stageScale]   [expr  -100 * $stageScale] \
                                                                darkred ]
                            set _dim_CS_LengthJig   [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $RearWheel(Position)    $FrameJig(SeatTube)] \
                                                                aligned     [expr   -60 * $stageScale]   0 \
                                                                darkred ]
                            set _dim_MN_LengthJig   [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $FrameJig(SeatTube)     $FrameJig(HeadTube)] \
                                                                aligned     [expr   -60 * $stageScale]   0 \
                                                                darkred ]
                            set _dim_BB_DepthJIg    [ $cv_Name dimension  length  [ appUtil::flatten_nestedList   $BottomBracket(Position)    $FrameJig(SeatTube)] \
                                                                aligned     [expr    60 * $stageScale]   0 \
                                                                darkred ]
                            set _dim_ST_Angle       [ $cv_Name dimension  angle [ appUtil::flatten_nestedList  $FrameJig(SeatTube)   $RearWheel(Position)   $BottomBracket(Position) ] \
                                                                90   0  \
                                                                darkred ]
                                # -- Fork Details ----------------------
                                #
                            set _dim_HT_Fork        [ $cv_Name dimension  length  [ appUtil::flatten_nestedList  $FrameJig(HeadTube)    $help_fk] \
                                                                aligned     [expr  -100 * $stageScale]   0 \
                                                                darkblue ]
                            set _dim_Fork_Height    [ $cv_Name dimension  length  [ appUtil::flatten_nestedList            $help_fk $HeadTube(Fork)  ] \
                                                                aligned        [expr   150 * $stageScale]   0 \
                                                                gray30 ]
                        }
                    # -----------------------
                default {
                        }
            }
    }


    proc rattleCAD::cv_custom::createDimensionType {cv_Name BB_Position type {updateCommand {}}} {

            variable    stageScale

            variable    Rendering

            variable    BottomBracket
            variable    DownTube
            variable    Fork
            variable    FrameJig
            variable    FrontBrake
            variable    FrontWheel
            variable    HandleBar
            variable    HeadSet
            variable    HeadTube
            variable    LegClearance
            variable    RearBrake
            variable    RearDrop
            variable    RearWheel
            variable    Saddle
            variable    SeatStay
            variable    SeatTube
            variable    Steerer
            variable    Stem
            variable    TopTube

            variable    Position
            variable    Length
            variable    Vector


            switch $type {
                HeadTube_Length {
                            set dimension       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [lindex $HeadTube(vct_Top) 1] [lindex $HeadTube(vct_Bottom) 1] ] \
                                                                                    aligned    [expr  (-110 + 0.5 * $HeadTube(Diameter)) * $stageScale]   0 \
                                                                                    darkred ]
                            if {$updateCommand != {}} { $cv_Name    bind    $dimension    <Double-ButtonPress-1>  \
                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                    {FrameTubes(HeadTube/Length)    \
                                                                                    }    {HeadTube Length}]
                                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension
                                    }
                            }
                HeadTube_OffsetTT {
                            set pt_01           [ bikeGeometry::coords_get_xy $HeadTube(polygon) 2 ]
                            set pt_02           [ bikeGeometry::coords_get_xy $TopTube(polygon) 8 ]
                            set dimension       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $pt_01 $pt_02] ] \
                                                                                    aligned    [expr 70 * $stageScale] [expr 50 * $stageScale] \
                                                                                    darkred ]
                            if {$updateCommand != {}} { $cv_Name    bind    $dimension    <Double-ButtonPress-1>  \
                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                    {Custom(TopTube/OffsetHT)    \
                                                                                    }    {HeadTube TopTube Offset}]
                                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension
                                    }
                            }
                HeadTube_OffsetDT {
                            set pt_01           [ bikeGeometry::coords_get_xy $HeadTube(polygon) 3 ]
                            set pt_02           [ bikeGeometry::coords_get_xy $DownTube(polygon) 2 ]
                            set dimension       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $pt_01 $pt_02] ] \
                                                                                    aligned    [expr -70 * $stageScale] [expr 50 * $stageScale] \
                                                                                    darkred ]
                            if {$updateCommand != {}} { $cv_Name    bind    $dimension    <Double-ButtonPress-1>  \
                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                        {Custom(DownTube/OffsetHT) \
                                                                                        }    {HeadTube DownTube Offset}]
                                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension
                                    }
                            }
                SeatTube_Extension {
                            set pt_01           [ bikeGeometry::coords_get_xy $TopTube(polygon) 11 ]
                            set pt_02           [ bikeGeometry::coords_get_xy $SeatTube(polygon) 2 ]
                            set dimension       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $pt_01 $pt_02] ] \
                                                                                    aligned    [expr 50 * $stageScale] [expr -50 * $stageScale] \
                                                                                    darkred ]
                            if {$updateCommand != {}} { $cv_Name    bind    $dimension    <Double-ButtonPress-1>  \
                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                        {    Custom(SeatTube/Extension) \
                                                                                        }    {SeatTube Extension}]
                                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension
                                    }
                            }
                SeatStay_Offset {
                            set pt_01           $TopTube(SeatTube)
                            set pt_02           $SeatStay(End)
                            if { [lindex $pt_02 1] < [lindex $pt_01 1] } {
                                    set dim_coords  [ appUtil::flatten_nestedList [list $pt_01 $pt_02] ]
                            } else {
                                    set dim_coords  [ appUtil::flatten_nestedList [list $pt_02 $pt_01] ]
                            }
                            set dimension       [ $cv_Name dimension  length            $dim_coords  \
                                                                                    aligned    [expr 70 * $stageScale]   [expr 50 * $stageScale] \
                                                                                    darkred ]
                            if {$updateCommand != {}} { $cv_Name    bind    $dimension    <Double-ButtonPress-1>  \
                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                        {    Custom(SeatStay/OffsetTT) \
                                                                                        }    {SeatStay Offset TopTube}]
                                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension
                                    }
                            }
                DownTube_Offset {
                            set pt_01           $DownTube(BBracket)
                            set pt_02           $DownTube(Steerer)
                            set pt_03           $BB_Position
                            if { $DownTube(OffsetBB) >= 0 } {
                                    set dim_distance    [expr  70 * $stageScale]
                                    set dim_offset      [expr  35 * $stageScale]
                            } else {
                                    set dim_distance    [expr -70 * $stageScale]
                                    set dim_offset      [expr -35 * $stageScale]
                            }
                            set dimension       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $pt_02 $pt_01 $pt_03] ] \
                                                                                    {perpendicular}    $dim_distance $dim_offset \
                                                                                    darkred ]
                            if {$updateCommand != {}} { $cv_Name    bind    $dimension    <Double-ButtonPress-1>  \
                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                        {    Custom(DownTube/OffsetBB) \
                                                                                        }    {DownTube Offset BottomBracket}]
                                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension
                                    }
                            }
                SeatTube_Offset {
                            set pt_01           $SeatTube(BBracket)
                            set pt_02           $TopTube(SeatTube)
                            set pt_03           $BB_Position
                            if { $SeatTube(OffsetBB) > 0 } {
                                    set dim_distance    [expr -70 * $stageScale]
                                    set dim_offset      [expr  35 * $stageScale]
                            } else {
                                    set dim_distance    [expr  70 * $stageScale]
                                    set dim_offset      [expr -35 * $stageScale]
                            }
                            set dimension       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $pt_02 $pt_01 $pt_03] ] \
                                                                                    {perpendicular}    $dim_distance $dim_offset \
                                                                                    darkred ]
                            if {$updateCommand != {}} { $cv_Name    bind    $dimension    <Double-ButtonPress-1>  \
                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                        {    Custom(SeatTube/OffsetBB) \
                                                                                        }    {SeatTube Offset BottomBracket}]
                                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension
                                    }
                            }
                TopTube_Angle {
                            set pt_01           $TopTube(Steerer)
                            set pt_hlp          $TopTube(SeatTube)
                            set pt_cnt          [ vectormath::center        $pt_01  $pt_hlp]
                            set pt_02           [ list [expr [lindex $pt_cnt 0] + 2] [lindex $pt_cnt 1]  ]

                            if {[lindex $pt_01 1] > [lindex $pt_hlp 1]} {
                                    set dimension   [ $cv_Name dimension  angle            [ appUtil::flatten_nestedList [list $pt_cnt $pt_02 $pt_01] ] \
                                                                                    100   -30 \
                                                                                    darkred ]
                            } else {
                                    set dimension   [ $cv_Name dimension  angle            [ appUtil::flatten_nestedList [list $pt_cnt $pt_01 $pt_02] ] \
                                                                                    100   -30 \
                                                                                    darkred ]
                            }
                            if {$updateCommand != {}} { $cv_Name    bind    $dimension    <Double-ButtonPress-1>  \
                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                        {    Custom(TopTube/Angle) \
                                                                                        }    {TopTube Angle}]
                                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension
                                    }
                        }
                TopHeadTube_Angle {
                            set dimension       [ $cv_Name dimension  angle            [ appUtil::flatten_nestedList [list $TopTube(Steerer) $Steerer(Stem) $TopTube(SeatTube)] ] \
                                                                                    150   0 \
                                                                                    darkblue ]
                            if {$updateCommand != {}} { $cv_Name    bind    $dimension    <Double-ButtonPress-1>  \
                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                        {    Result(Angle/HeadTube/TopTube) \
                                                                                        }    {HeadTube TopTube Angle}]
                                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension
                                    }
                        }
                ForkHeight {
                            set dimension       [ $cv_Name dimension  length    [ appUtil::flatten_nestedList            $Steerer(vct_Bottom) $FrontWheel(Position) ] \
                                                                                    perpendicular [expr  (-110 + 0.5 * $HeadSet(Diameter)) * $stageScale]    [expr  -80 * $stageScale] \
                                                                                    darkred ]
                            if {$updateCommand != {}} { $cv_Name    bind    $dimension    <Double-ButtonPress-1>  \
                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                        {    Component(Fork/Height) \
                                                                                        }    {Fork Height}]
                                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension
                                    }
                        }
                HeadSet_Top {
                            set dimension       [ $cv_Name dimension  length    [ appUtil::flatten_nestedList $HeadSet(vct_Top)  [lindex $HeadTube(vct_Top) 1]] \
                                                                                    perpendicular    [expr  (-150 + 0.5 * $HeadTube(Diameter)) * $stageScale]   [expr -50 * $stageScale] \
                                                                                    darkred ]
                            if {$updateCommand != {}} { $cv_Name    bind    $dimension    <Double-ButtonPress-1>  \
                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                        {    Component(HeadSet/Height/Top) \
                                                                                        }    {HeadSet Top Height}]
                                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension
                                    }
                        }
                HeadSet_Bottom {
                            set dimension       [ $cv_Name dimension  length    [ appUtil::flatten_nestedList $HeadSet(vct_Bottom)  [lindex $HeadTube(vct_Bottom) 1]] \
                                                                                    perpendicular    [expr  (150 - 0.5 * $HeadSet(Diameter)) * $stageScale]   [expr 50 * $stageScale] \
                                                                                    darkred ]
                            if {$updateCommand != {}} { $cv_Name    bind    $dimension    <Double-ButtonPress-1>  \
                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                        {    Component(HeadSet/Height/Bottom) \
                                                                                        }    {HeadSet Bottom Height}]
                                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension
                                    }
                        }
                Brake_Rear {
                            if {$Rendering(BrakeRear) != {off}} {
                                switch $Rendering(BrakeRear) {
                                    Rim {
                                                set pt_03       [ vectormath::addVector    $bikeGeometry::RearBrake(Shoe)        $BB_Position ]
                                                set pt_04       [ vectormath::addVector    $bikeGeometry::RearBrake(Help)        $BB_Position ]
                                                set pt_05       [ vectormath::addVector    $bikeGeometry::RearBrake(Definition)  $BB_Position ]
                                                set pt_06       [ vectormath::addVector    $bikeGeometry::RearBrake(Mount)       $BB_Position ]
                                            set dimension_01    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $pt_04  $pt_06] \
                                                                                                    aligned            [expr   -40 * $stageScale]    [expr  40 * $stageScale] \
                                                                                                    darkred ]    ;# Component(Brake/Rear/Offset)
                                            set dimension_02    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $pt_05  $pt_06 ] \
                                                                                                    aligned            [expr    60 * $stageScale]    [expr -50 * $stageScale] \
                                                                                                    darkred ]    ;# Component(Brake/Rear/LeverLength)
                                            if {$updateCommand != {}} { $cv_Name    bind    $dimension_01    <Double-ButtonPress-1>  \
                                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                                        {    Component(Brake/Rear/Offset) \
                                                                                                        }    {Rear Brake Offset}]
                                                                        $cv_Name    bind    $dimension_02    <Double-ButtonPress-1>  \
                                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                                        {    Component(Brake/Rear/LeverLength) \
                                                                                                        }    {Rear Brake LeverLength}]
                                                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension_01
                                                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension_02
                                                    }
                                        }
                                }
                            }
                        }
                Brake_Front {
                            if {$Rendering(BrakeFront) != {off}} {
                                switch $Rendering(BrakeFront) {
                                    Rim {
                                                set pt_03       [ vectormath::addVector    $bikeGeometry::FrontBrake(Shoe)       $BB_Position ]
                                                set pt_04       [ vectormath::addVector    $bikeGeometry::FrontBrake(Help)       $BB_Position ]
                                                set pt_05       [ vectormath::addVector    $bikeGeometry::FrontBrake(Definition) $BB_Position ]
                                                set pt_06       [ vectormath::addVector    $bikeGeometry::FrontBrake(Mount)      $BB_Position ]

                                            set dimension_00    [ $cv_Name dimension  length    [ appUtil::flatten_nestedList             $HeadSet(vct_Bottom) $pt_06 ] \
                                                                                                    perpendicular [expr -40 * $stageScale]  [expr   40 * $stageScale] \
                                                                                                    gray50 ]        ;# distance Brake Mount Hole
                                            set dimension_01    [ $cv_Name dimension  length    [ appUtil::flatten_nestedList            $pt_03  $pt_05 ] \
                                                                                                    aligned            [expr  -50 * $stageScale]    [expr  -70 * $stageScale] \
                                                                                                    darkred ]    ;# Component(Brake/Rear/Offset)
                                            set dimension_02    [ $cv_Name dimension  length    [ appUtil::flatten_nestedList            $pt_03  $pt_04 ] \
                                                                                                    aligned            [expr   20 * $stageScale]    [expr   40 * $stageScale] \
                                                                                                    darkred ]    ;# Component(Brake/Rear/LeverLength)


                                            if {$updateCommand != {}} { $cv_Name    bind    $dimension_01    <Double-ButtonPress-1>  \
                                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                                        {    Component(Brake/Front/Offset) \
                                                                                                        }    {Front Brake Offset}]
                                                                        $cv_Name    bind    $dimension_02    <Double-ButtonPress-1>  \
                                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                                        {    Component(Brake/Front/LeverLength) \
                                                                                                        }    {Front Brake LeverLength}]
                                                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension_01
                                                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension_02
                                                    }
                                        }
                                }
                            }
                        }
                BottleCage {
                                set dt_direction    [ bikeGeometry::get_Object DownTube direction ]
                                set st_direction    [ bikeGeometry::get_Object SeatTube direction ]

                            if {$Rendering(BottleCage_ST) != {off}} {
                                            set pt_01           [ bikeGeometry::get_Object    SeatTube/BottleCage/Offset   position    $BB_Position]
                                            set pt_02           [ bikeGeometry::get_Object    SeatTube/BottleCage/Base     position    $BB_Position]
                                            set pt_03           [ vectormath::addVector    $pt_02    $st_direction    [expr -1.0 * $bikeGeometry::BottleCage(SeatTube)] ]

                                            set dimension       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $pt_01  $pt_02 ] \
                                                                                                    aligned        [expr  70 * $stageScale]    [expr    0 * $stageScale] \
                                                                                                    gray50 ]
                                            set dimension       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $pt_02  $pt_03 ] \
                                                                                                    aligned        [expr  70 * $stageScale]    [expr  -15 * $stageScale] \
                                                                                                    darkblue ]
                                            if {$updateCommand != {}} { $cv_Name    bind    $dimension    <Double-ButtonPress-1>  \
                                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                                        {    Component(BottleCage/SeatTube/OffsetBB) \
                                                                                                        }    {BottleCage SeatTube Offset}]
                                                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension
                                                    }
                                                    
                                            # $cv_Name create circle $pt_01    -radius 15  -outline red    -width 1        -tags __CenterLine__
                                            # $cv_Name create circle $pt_02    -radius 15  -outline red    -width 1        -tags __CenterLine__
                                            # $cv_Name create circle $pt_03    -radius 15  -outline red    -width 1        -tags __CenterLine__
                            }

                            if {$Rendering(BottleCage_DT) != {off}} {
                                            set pt_01           [ bikeGeometry::get_Object    DownTube/BottleCage/Offset   position    $BB_Position]
                                            set pt_02           [ bikeGeometry::get_Object    DownTube/BottleCage/Base     position    $BB_Position]
                                            set pt_03           [ vectormath::addVector    $pt_02    $dt_direction    [expr -1.0 * $bikeGeometry::BottleCage(DownTube)] ]

                                            if { $Rendering(BottleCage_DT_L) != {off}} { set addDist 50 } else { set addDist 0}

                                            set dimension        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $pt_01  $pt_02 ] \
                                                                                                    aligned        [expr -1.0 * (90 + $addDist) * $stageScale]    0 \
                                                                                                    gray50 ]
                                            set dimension        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $pt_02  $pt_03 ] \
                                                                                                    aligned        [expr -1.0 * (90 + $addDist) * $stageScale]    [expr  15 * $stageScale] \
                                                                                                    darkblue ]
                                            if {$updateCommand != {}} {    $cv_Name    bind    $dimension    <Double-ButtonPress-1>  \
                                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                                        {    Component(BottleCage/DownTube/OffsetBB) \
                                                                                                        }    {BottleCage DownTube Offset}]
                                                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension
                                                    }
                            }
                            if {$Rendering(BottleCage_DT_L) != {off}} {
                                            set pt_01           [ bikeGeometry::get_Object    DownTube/BottleCage_Lower/Offset position    $BB_Position ]
                                            set pt_02           [ bikeGeometry::get_Object    DownTube/BottleCage_Lower/Base   position    $BB_Position ]
                                            set pt_03           [ vectormath::addVector    $pt_02    $dt_direction    [expr -1.0 * $bikeGeometry::BottleCage(DownTube_Lower) ] ]

                                            set dimension       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $pt_01  $pt_02 ] \
                                                                                                    aligned        [expr -60 * $stageScale]    0 \
                                                                                                    gray50 ]
                                            set dimension       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $pt_02  $pt_03 ] \
                                                                                                    aligned        [expr -60 * $stageScale]    [expr  15 * $stageScale] \
                                                                                                    darkblue ]
                                            if {$updateCommand != {}} {    $cv_Name    bind    $dimension    <Double-ButtonPress-1>  \
                                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                                        {    Component(BottleCage/DownTube_Lower/OffsetBB) \
                                                                                                        }    {BottleCage DownTube Lower Offset}]
                                                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension
                                                    }
                            }
                        }
                DerailleurMount {
                            set pt_01     [ bikeGeometry::get_Object     RearWheel    position    $BB_Position  ]
							set pt_02     [ bikeGeometry::get_Object     Lugs/Dropout/Rear/Derailleur  position  $BB_Position]
                            set pt_03     [ vectormath::rotatePoint      $pt_01  $BB_Position 90]
								#
							set offset_y       [ rattleCAD::control::getValue Lugs/RearDropOut/Derailleur/y]
							set offsetAngle    [ rattleCAD::control::getValue Lugs/RearDropOut/RotationOffset]
							set chainStayAngle [ vectormath::dirAngle   $pt_01  $BB_Position]
							    #
							set direction   [ rattleCAD::control::getValue Lugs/RearDropOut/Direction]
							switch -exact $direction {
							    ChainStay  -
								Chainstay  { set offsetAngle [ expr $offsetAngle - $chainStayAngle ] }
                                horizontal -
								default    {}
							}
							    #
							set pt_04       [ vectormath::rotateLine       $pt_01  $offset_y [expr 270 - $offsetAngle ] ]
							    # $cv_Name create circle $pt_04    -radius 5  -outline red    -width 1        -tags __CenterLine__
							    #
                                #puts "\n ----------"
                                #puts "   \$pt_01  $pt_01"
                                #puts "   \$pt_02  $pt_02"
                                #puts "   \$pt_04  $pt_04"
                                #puts " ----------\n"
							    #	
							set radius          [ vectormath::length $pt_01 $pt_02]
							    #
							set arc_Derailleur  [ $cv_Name create arc   $pt_01  -radius $radius -start -135  -extent 70 -style arc -outline gray60  -tags __CenterLine__]
                                #
						    set dimension_01    [ $cv_Name dimension  length    [ appUtil::flatten_nestedList   $pt_04 $pt_01 $pt_02 ] \
                                                                                    perpendicular [expr  -80 * $stageScale]    [expr  -30 * $stageScale] \
                                                                                    gray50 ] 	
							set dimension_02    [ $cv_Name dimension  length    [ appUtil::flatten_nestedList   $pt_04 $pt_02 $pt_01 ] \
                                                                                    perpendicular [expr  -60 * $stageScale]    [expr   40 * $stageScale] \
                                                                                    gray50 ]

							set dimension_03    [ $cv_Name dimension  length    [ appUtil::flatten_nestedList   $pt_01   $pt_02 ] \
                                                                                    aligned       [expr   40 * $stageScale]    [expr   50 * $stageScale] \
                                                                                    gray50 ]
							set dimension_04    [ $cv_Name dimension  length    [ appUtil::flatten_nestedList   $pt_03 $pt_01 $pt_02 ] \
                                                                                    perpendicular [expr -110 * $stageScale]    [expr   30 * $stageScale] \
                                                                                    gray50 ]
																					
							    #																								
                            if {$updateCommand != {}} { 
                                                $cv_Name    bind    $dimension_01    <Double-ButtonPress-1>  \
                                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                {   file://Lugs(RearDropOut/File)  \
																				    list://Lugs(RearDropOut/Direction@SELECT_DropOutDirection)  \
                                                                                    list://Rendering(RearDropOut@SELECT_DropOutPosition)    \
                                                                                    Lugs(RearDropOut/RotationOffset)    \
                                                                                    Lugs(RearDropOut/Derailleur/x) \
																				    Lugs(RearDropOut/Derailleur/y) \
                                                                                }  {RearDropOut Derailleur}]
                                                $cv_Name    bind    $dimension_02    <Double-ButtonPress-1>  \
                                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                {   file://Lugs(RearDropOut/File)  \
																				    list://Lugs(RearDropOut/Direction@SELECT_DropOutDirection)  \
                                                                                    list://Rendering(RearDropOut@SELECT_DropOutPosition)    \
                                                                                    Lugs(RearDropOut/RotationOffset)    \
                                                                                    Lugs(RearDropOut/Derailleur/x) \
																				    Lugs(RearDropOut/Derailleur/y) \
                                                                                }  {RearDropOut Derailleur}]
                                                rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension_01
                                                rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension_02
                            }
                            
                            #            project::setValue Result(Lugs/Dropout/Rear/Derailleur)    position ]     [expr -1*$RearWheel(Distance_X)]    [rattleCAD::control::getValue Custom/BottomBracket/Depth]
                            # project::setValue Result(Lugs/Dropout/Rear/Derailleur)  position     [ vectormath::addVector  $RearWheel(Position)  [list $RearDrop(Derailleur_x) $RearDrop(Derailleur_y)] ]

                            
                            
                        }
                RearWheel_Clearance {
                            set RimDiameter         [rattleCAD::control::getValue Component/Wheel/Rear/RimDiameter]
                            set TyreHeight          [rattleCAD::control::getValue Component/Wheel/Rear/TyreHeight]
                            set WheelRadius         [ expr 0.5 * $RimDiameter + $TyreHeight ]
                            set pt_03               [ bikeGeometry::get_Object        RearWheel    position    $BB_Position  ]
                            set pt_06               [ bikeGeometry::coords_get_xy $SeatTube(polygon) 5 ]
                            set pt_07               [ bikeGeometry::coords_get_xy $SeatTube(polygon) 6 ]
                            set pt_is               [ vectormath::intersectPerp $pt_06 $pt_07 $pt_03 ]
                            set pt_rw               [ vectormath::addVector $pt_03 [ vectormath::unifyVector  $pt_03  $pt_is  $WheelRadius ] ]
                            set dimension           [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $pt_rw $pt_is] ] \
                                                                                    aligned    [expr -90 * $stageScale]  [expr 50 * $stageScale] \
                                                                                    gray50 ]
                        }
                LegClearance {
                            set pt_01                    [ vectormath::addVector        $bikeGeometry::LegClearance(Position)        $BB_Position ]
                            set pt_09                    [ bikeGeometry::coords_get_xy $TopTube(polygon)  9 ]
                            set pt_10                    [ bikeGeometry::coords_get_xy $TopTube(polygon) 10 ]
                            set pt_is                    [ vectormath::intersectPerp $pt_09 $pt_10 $pt_01 ]
                            set dimension            [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $pt_01 $pt_is] ] \
                                                                                    aligned    [expr -30 * $stageScale]  [expr 50 * $stageScale] \
                                                                                    gray50 ]
                        }
                check_this {
                            set pt_01                    [ bikeGeometry::coords_get_xy $TopTube(polygon) 11 ]
                            set pt_01a                   [ bikeGeometry::coords_get_xy $TopTube(polygon) 11 ]
                            set pt_02                    [ bikeGeometry::coords_get_xy $SeatTube(polygon) 3 ]
                            $cv_Name create circle  $pt_01        -radius 20  -outline red
                            $cv_Name create circle  $pt_02        -radius 20  -outline blue
                            set dimension           [ $cv_Name dimension  length            [ appUtil::flatten_nestedList [list $pt_01 $pt_02] ] \
                                                                                    aligned    [expr 50 * $stageScale]   [expr 50 * $stageScale] \
                                                                                    darkblue ]
                            if {$updateCommand != {}} {
                                        $cv_Name bind                    $dimension  \
                                                <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                    {    Custom(SeatStay/OffsetTT)        \
                                                                                    }    {SeatStay OffsetTopTube}]
                                        rattleCAD::gui::object_CursorBinding        $cv_Name    $dimension
                                    }
                        }
                default {}
            }

    }

