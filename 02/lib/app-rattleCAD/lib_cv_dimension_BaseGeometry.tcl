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
  
    
    proc rattleCAD::cv_custom::createDimension_Geometry_hybrid_personal         {cv_Name BB_Position {active inactive}} {
                #
            variable    stageScale
                #
            variable    Rendering
            variable    Reference
                #
            variable    BottomBracket
            variable    HandleBar
            variable    LegClearance
            variable    Saddle
            variable    SaddleNose
                #
            variable    Position
            variable    Length
                #
            variable    DraftingColour
                #
            set dimColour       $DraftingColour(personal)  
            set dimColour_2     $DraftingColour(personal_2)  
                #
            set distY_SN_LC         [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
                #
                # ---
                #
                
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension    length      \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                            horizontal  \
                            [expr (150 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                            $dimColour ] \
                    single_Personal_HandleBarDistance
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension    length \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                            vertical    \
                            [expr -310 * $stageScale]    [expr  180 * $stageScale] \
                            $dimColour ] \
                    single_Personal_HandleBarHeight
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension    \
                            length      \
                            [ appUtil::flatten_nestedList  $Saddle(Position)        $BottomBracket(Position)  ] \
                            horizontal    [expr -150 * $stageScale]    0 \
                            $dimColour ] \
                    single_Personal_SaddleDistance
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension    length      \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Saddle(Position) ] \
                            vertical    \
                            [expr -580 * $stageScale]  [expr -130 * $stageScale]  \
                            $dimColour ] \
                    single_Personal_SaddleHeight
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension    length      \
                            [ appUtil::flatten_nestedList  $LegClearance(Position)  $BottomBracket(Position) ] \
                            horizontal  \
                            [expr  $distY_SN_LC * $stageScale]   0  \
                            $dimColour_2 ] \
                    single_TopTube_PivotPosition
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension    length      \
                            [ appUtil::flatten_nestedList  $LegClearance(Position)  $Position(BaseCenter) ] \
                            vertical    \
                            [expr  -50 * $stageScale]   [expr   160 * $stageScale]  \
                            $dimColour_2 ] \
                    single_Personal_InnerLegLength

                #   
            return
                #
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_hybrid_primary          {cv_Name BB_Position {active inactive}} {
                #
            variable    stageScale
                #
            variable    Rendering
            variable    Reference
                #
            variable    BottomBracket
            variable    Fork
            variable    FrontWheel
            variable    HandleBar
            variable    RearWheel
            variable    Saddle
            variable    SeatPost
            variable    SeatTube
            variable    Steerer
            variable    Stem
                #
            variable    Position
            variable    Length
 
                #
            variable    DraftingColour
                #
            set dimColour   $DraftingColour(primary)  
                #
            set help_01            [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
            set help_02            [ vectormath::addVector   $Steerer(Stem) [ vectormath::unifyVector $Steerer(Stem) $help_01 [expr  50 * $stageScale] ] ]
            set help_03            [ vectormath::addVector   $SeatPost(PivotPosition) {-10 0} ]
            set help_fk            [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
                #
                # --- primary - dimensions
                #               
                
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension    length      \
                            [ appUtil::flatten_nestedList  $RearWheel(Position)      $RearWheel(Ground) ] \
                            vertical    \
                            [expr   130 * $stageScale]    0 \
                            $dimColour ]    \
                    group_RearWheel_Parameter
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension    length      \
                            [ appUtil::flatten_nestedList  $SeatPost(Saddle) $Saddle(Position)  ] \
                            aligned     \
                            [expr  (-500 - $Length(Length_BB_Seat)) * $stageScale ]    [expr  -80 * $stageScale] \
                            $dimColour ]    \
                    single_SaddleHeightComponent
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension    length      \
                            [ appUtil::flatten_nestedList  $SeatTube(BBracket) $SeatPost(SeatTube) $SeatPost(PivotPosition) ] \
                            perpendicular   \
                            [expr  -40 * $stageScale]  [expr  50 * $stageScale]  \
                            $dimColour ]    \
                    single_SeatPost_Setback
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension    length      \
                            [ appUtil::flatten_nestedList   $help_03 $SeatPost(PivotPosition) $SeatPost(Saddle)  ] \
                            perpendicular   \
                            [expr  (-420 - $Length(Length_BB_Seat)) * $stageScale ]    [expr   0 * $stageScale]  \
                            $dimColour ]    \
                    single_SeatPost_PivotOffset
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension    length      \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position)  $RearWheel(Position) ] \
                            vertical    \
                            [expr  -280 * $stageScale]   [expr -90 * $stageScale]  \
                            $dimColour ]    \
                    single_BottomBracket_Depth
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension    length      \
                            [ appUtil::flatten_nestedList  $RearWheel(Position)      $BottomBracket(Position)] \
                            aligned     \
                            [expr   100 * $stageScale]   0 \
                            $dimColour ]    \
                    single_RearWheel_Distance
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension    angle       \
                            [ appUtil::flatten_nestedList  $Steerer(Ground)  $Steerer(Fork)  $Position(BaseCenter) ] \
                            150   0  \
                            $dimColour ]    \
                    single_HeadTube_Angle
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension   length      \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)      $Steerer(Stem) ] \
                            aligned \
                            [expr    80 * $stageScale]  0 \
                            $dimColour ]    \
                    single_Stem_Length
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension    length      \
                            [ appUtil::flatten_nestedList  $FrontWheel(Position)     $FrontWheel(Ground) ] \
                            vertical    \
                            [expr  -150 * $stageScale]    0 \
                            $dimColour ]    \
                    group_FrontWheel_Parameter_01
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension    length      \
                            [ appUtil::flatten_nestedList  $Steerer(Stem)  $help_fk $FrontWheel(Position) ] \
                            perpendicular   \
                            [expr  100 * $stageScale]    [expr  -80 * $stageScale] \
                            $dimColour ]    \
                    single_Fork_Rake
                        #
                        #
            if {$Stem(Angle) > 0} {
                set coordList [ appUtil::flatten_nestedList  $Steerer(Stem)  $help_02 $HandleBar(Position) ]
            } else {
                set coordList [ appUtil::flatten_nestedList  $Steerer(Stem)  $HandleBar(Position)  $help_02 ]
            }
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  angle \
                            $coordList \
                            [expr $Stem(Length) +  80]   0  \
                            $dimColour ] \
                    single_Stem_Angle

                        #
                        #
            if {$Fork(Rake) != 0} {
                set coordList   [ appUtil::flatten_nestedList   $help_fk $FrontWheel(Position) $Steerer(Fork)  ]
            } else {
                set coordList   [ appUtil::flatten_nestedList   $FrontWheel(Position) $Steerer(Fork)  ]
            }
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            $coordList \
                            perpendicular [expr  (100 - $Fork(Rake)) * $stageScale]    [expr  -10 * $stageScale] \
                            $dimColour ]    \
                    single_Fork_Height
                       #
                       #                       
            if {$SeatTube(OffsetBB) > 0} {
                set dim_distance    [expr  90 * $stageScale]
                set dim_offset      [expr  50 * $stageScale]
            } else {
                set dim_distance    [expr -90 * $stageScale]
                set dim_offset      [expr -50 * $stageScale]
            }
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList [list $SeatPost(SeatTube) $SeatTube(BBracket) $BB_Position] ] \
                            perpendicular   \
                            $dim_distance $dim_offset \
                            $dimColour ]    \
                    single_SeatTube_BottomBracketOffset
                         #

                #
            return
                #
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_hybrid_secondary        {cv_Name BB_Position {active inactive}} {
                #
            variable    stageScale
                #
            variable    BottomBracket
            variable    HandleBar
            variable    HeadTube
            variable    LegClearance
            variable    SaddleNose                
            variable    Steerer                
                #
            variable    Position
                #
            variable    DraftingColour
                #
            set dimColour   $DraftingColour(secondary)  
                #            
                #
                # --- 
                #
            set distY_SN_LC         [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
                #
                # ---
                #
                
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension    length  \
                            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $BottomBracket(Position) ] \
                            horizontal  \
                            [expr  $distY_SN_LC * $stageScale]   0  \
                            $dimColour ]  \
                    group_Saddle_Parameter_01
                        #
            # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension    length  \
                            [ appUtil::flatten_nestedList  $Steerer(Fork)  $HeadTube(Stem) ] \
                            aligned \
                            [expr   100 * $stageScale]   0 \
                            $dimColour ]  \
                    group_HeadTube_Parameter_01
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension    radius  \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Position(help_91)] \
                            -20 [expr  130 * $stageScale] \
                            $dimColour ]  \
                    single_CrankSet_Length
                    
                #
            return
                #    
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_hybrid_result           {cv_Name BB_Position {active inactive}} {
                #
            variable    stageScale
                #
            variable    BottomBracket
            variable    FrontWheel
            variable    HandleBar
            variable    HeadTube
            variable    RearWheel
            variable    Saddle
            variable    SaddleNose
            variable    SeatPost
            variable    SeatTube
            variable    Steerer
            variable    TopTube
                #
            variable    Position
                #
            variable    DraftingColour
                #
            set dimColour   $DraftingColour(result)  
                #
            set help_00            [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
            set help_01            [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
                #
                #
                # --- result - level - dimensions
                #
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Saddle(Position)      $HandleBar(Position) ] \
                            horizontal  \
                            [expr  -210 * $stageScale]    0 \
                            $dimColour ]    \
                    single_Result_Saddle_Offset_HB_X
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)     $Saddle(Position) ] \
                            vertical    [expr  310 * $stageScale]   [expr -100 * $stageScale]  \
                            $dimColour ]    \
                    single_Result_Saddle_Offset_HB_Y
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position) $FrontWheel(Position)] \
                            aligned     [expr  100 * $stageScale]   [expr  -30 * $stageScale] \
                            $dimColour ]    \
                    single_Result_FrontWheel_diagonal
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Position(BaseCenter)    $FrontWheel(Ground) ] \
                            horizontal  [expr   70 * $stageScale]   0 \
                            $dimColour ]    \
                    single_Result_FrontWheel_horizontal
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Position(BaseCenter)] \
                            vertical    [expr  150 * $stageScale]   [expr   -20 * $stageScale]  \
                            $dimColour ]    \
                    single_Result_BottomBracket_Height
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  angle \
                            [ appUtil::flatten_nestedList  $SeatTube(Ground)        $SeatPost(SeatTube) $help_00 ] \
                            150   0  \
                            $dimColour ]    \
                    single_Result_SeatTube_Angle
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $RearWheel(Ground)       $Position(BaseCenter) ] \
                            horizontal  [expr   70 * $stageScale]   0 \
                            $dimColour ]    \
                    single_Result_RearWheel_horizontal
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $HandleBar(Position)] \
                            horizontal      [expr  -80 * $stageScale]    0 \
                            $dimColour ]    \
                    single_Result_SaddleNose_HB
                        #
            # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HeadTube(Stem)          $BottomBracket(Position) ] \
                            horizontal  \
                            [expr  -80 * $stageScale]    0 \
                            $dimColour ]    \
                    single_Result_HeadTube_ReachLength
                        #
            # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HeadTube(Stem)          $BottomBracket(Position) ] \
                            vertical    \
                            [expr   80 * $stageScale]    [expr  120 * $stageScale]  \
                            $dimColour ]    \
                    single_Result_StackHeight

                #
            return
                #
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_hybrid_summary          {cv_Name BB_Position} {
                #
            variable    stageScale
                #
            variable    BottomBracket
            variable    FrontWheel
            variable    HandleBar
            variable    RearWheel
            variable    Saddle
            variable    SeatPost
            variable    Steerer
                #
            variable    Position
            variable    Length
                #
            variable    DraftingColour
                #
            set dimColour   $DraftingColour(background)  
                #
                # ----
                #
            set _dim_SD_Height  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Position(BaseCenter)  $Saddle(Position) ] \
                            vertical    \
                            [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
                            $dimColour ]
                            
            set _dim_HB_Height  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)   $Position(BaseCenter) ] \
                            vertical    \
                            [expr -380 * $stageScale]  [expr  230 * $stageScale]  \
                            $dimColour ]
                            
            # set _dim_SD_HB_Length   \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Saddle(Position)      $HandleBar(Position) ] \
                            horizontal  \
                            [expr  -210 * $stageScale]    0 \
                            $dimColour ]

            set _dim_Wh_Distance    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $RearWheel(Ground)     $FrontWheel(Ground) ] \
                            horizontal  \
                            [expr  130 * $stageScale]    0 \
                            $dimColour ]
            set _dim_FW_Lag \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $FrontWheel(Ground)    $Steerer(Ground) ] \
                            horizontal  \
                            [expr   70 * $stageScale]   [expr  -70 * $stageScale] \
                            $dimColour ]

            set _dim_BT_Clearance   \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Position(help_91)     $Position(help_92) ] \
                            aligned \
                            0   [expr -150 * $stageScale]  \
                            $dimColour ]

            set _dim_ST_Length  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Position(help_93)     $Saddle(Position) ] \
                            aligned \
                            [expr -160 * $stageScale]    [expr -230 * $stageScale]  \
                            $dimColour ]
                            
            # set _dim_SP_Height    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $SeatPost(Saddle)      $BottomBracket(Position)  ] \
                            vertical    \
                            [expr (500 + $Length(Length_BB_Seat)) * $stageScale ]    [expr  150 * $stageScale] \
                            $dimColour ]

                #
            return
                #
    }


    proc rattleCAD::cv_custom::createDimension_Geometry_stackreach_personal     {cv_Name BB_Position {active inactive}} {
                #
            variable    stageScale
                #
            variable    BottomBracket
            variable    HandleBar
            variable    LegClearance
            variable    Saddle
            variable    SaddleNose
            variable    SeatTube
            variable    Steerer
                #
            variable    Position 
                #
            variable    DraftingColour
                #
            set dimColour     $DraftingColour(personal)  
            set dimColour_2   $DraftingColour(personal_2)  
                #
                # ---
                #
            set distY_SN_LC [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
                #
                # --- personal - dimensions
                #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position) $SeatTube(Saddle) ] \
                            aligned \
                            [expr  -80 * $stageScale]    [expr -170 * $stageScale]  \
                            $dimColour ]    \
                    single_Result_Saddle_SeatTube_BB
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $LegClearance(Position)  $BottomBracket(Position) ] \
                            horizontal  \
                            [expr  $distY_SN_LC * $stageScale]   0  \
                            $dimColour_2 ]  \
                    single_TopTube_PivotPosition
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $LegClearance(Position)  $Position(BaseCenter) ] \
                            vertical    \
                            [expr  -50 * $stageScale]   [expr   160 * $stageScale]  \
                            $dimColour_2 ]  \
                    single_Personal_InnerLegLength            
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)     $Saddle(Position) ] \
                            vertical    [expr  310 * $stageScale]   [expr -100 * $stageScale]  \
                            $dimColour ]    \
                    single_Result_Saddle_Offset_HB_Y
                        #

                #
            return
                #
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_stackreach_primary      {cv_Name BB_Position {active inactive}} {
                #
            variable    stageScale
                #
            variable    BottomBracket
            variable    Fork
            variable    FrontWheel
            variable    HandleBar
            variable    HeadTube
            variable    RearWheel
            variable    Saddle
            variable    SaddleNose
            variable    SeatPost
            variable    SeatTube
            variable    Steerer
            variable    Stem
            variable    TopTube
                #
            variable    Position
                #
            variable    DraftingColour
                #
            set dimColour       $DraftingColour(primary)  
                #
            set help_00             [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
            set help_01             [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
            set help_02             [ vectormath::addVector   $Steerer(Stem) [ vectormath::unifyVector $Steerer(Stem) $help_01 [expr  50 * $stageScale] ] ]
            set help_fk             [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
                #
                # ---
                #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HeadTube(Stem)          $BottomBracket(Position) ] \
                            horizontal  \
                            [expr  -80 * $stageScale]    0 \
                            $dimColour ]    \
                    single_Result_HeadTube_ReachLength
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HeadTube(Stem)          $BottomBracket(Position) ] \
                            vertical    \
                            [expr   80 * $stageScale]    [expr  120 * $stageScale]  \
                            $dimColour ]    \
                    single_Result_StackHeight
                        #                   
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position)  $RearWheel(Position) ] \
                            vertical    \
                            [expr  -280 * $stageScale]   [expr -90 * $stageScale]  \
                            $dimColour ]    \
                    single_BottomBracket_Depth
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $RearWheel(Position)      $BottomBracket(Position)] \
                            aligned \
                            [expr   100 * $stageScale]   0 \
                            $dimColour ]    \
                    single_RearWheel_Distance
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $RearWheel(Position)      $RearWheel(Ground) ] \
                            vertical    \
                            [expr   130 * $stageScale]    0 \
                            $dimColour ]    \
                    group_RearWheel_Parameter
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $FrontWheel(Position)     $FrontWheel(Ground) ] \
                            vertical    \
                            [expr  -150 * $stageScale]    0 \
                            $dimColour ]    \
                    group_FrontWheel_Parameter_01
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Steerer(Stem)  $help_fk $FrontWheel(Position) ] \
                            perpendicular   \
                            [expr  100 * $stageScale]    [expr  -80 * $stageScale] \
                            $dimColour ]    \
                    single_Fork_Rake
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  angle \
                            [ appUtil::flatten_nestedList  $Steerer(Ground)  $Steerer(Fork)  $Position(BaseCenter) ] \
                            150   0  \
                            $dimColour ]    \
                    single_HeadTube_Angle
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  angle \
                            [ appUtil::flatten_nestedList  $SeatTube(Ground)        $SeatPost(SeatTube) $help_00 ] \
                            150   0  \
                            $dimColour ]    \
                    single_Result_SeatTube_Angle
                        #
                    
                #
            return
                #
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_stackreach_secondary    {cv_Name BB_Position {active inactive}} {
                #
            variable    stageScale
                #
            variable    BottomBracket
            variable    HandleBar
            variable    HeadTube
            variable    LegClearance
            variable    Saddle
            variable    SaddleNose                
            variable    SeatPost
            variable    SeatTube
            variable    Stem                
            variable    Steerer                
                #
            variable    Position
            variable    Length
                #
            variable    DraftingColour
                #
            set dimColour    $DraftingColour(secondary)  
                #            
                #
                # --- 
                #
            set distY_SN_LC         [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
            set help_01             [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
            set help_02             [ vectormath::addVector   $Steerer(Stem) [ vectormath::unifyVector $Steerer(Stem) $help_01 [expr  50 * $stageScale] ] ]
            set help_03             [ vectormath::addVector   $SeatPost(PivotPosition) {-10 0} ]
                #
                # ---
                #
            
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $BottomBracket(Position) ] \
                            horizontal  \
                            [expr  $distY_SN_LC * $stageScale]   0  \
                            $dimColour ]    \
                    group_Saddle_Parameter_01
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  radius    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Position(help_91)] \
                            -20            [expr  130 * $stageScale] \
                            $dimColour ]    \
                    single_CrankSet_Length
                        #      
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $SeatPost(Saddle) $Saddle(Position)  ] \
                            aligned \
                            [expr  (-500 - $Length(Length_BB_Seat)) * $stageScale ]    [expr  -80 * $stageScale] \
                            $dimColour ]    \
                    single_SaddleHeightComponent
                        #            
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList   $help_03 $SeatPost(PivotPosition) $SeatPost(Saddle)  ] \
                            perpendicular   \
                            [expr  (-420 - $Length(Length_BB_Seat)) * $stageScale ]    [expr   0 * $stageScale]  \
                            $dimColour ]    \
                    single_SeatPost_PivotOffset
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $SeatTube(BBracket) $SeatPost(SeatTube) $SeatPost(PivotPosition) ] \
                            perpendicular   \
                            [expr  -40 * $stageScale]  [expr  50 * $stageScale]  \
                            $dimColour ]    \
                    single_SeatPost_Setback
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)      $Steerer(Stem) ] \
                            aligned     [expr    80 * $stageScale]    0 \
                            $dimColour ]    \
                    single_Stem_Length                            
                        #
            if {$Stem(Angle) > 0} {
                set coordList [ appUtil::flatten_nestedList  $Steerer(Stem)  $help_02 $HandleBar(Position) ]
            } else {
                set coordList [ appUtil::flatten_nestedList  $Steerer(Stem)  $HandleBar(Position)  $help_02 ]
            }
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  angle \
                            $coordList \
                            [expr $Stem(Length) +  80]   0  \
                            $dimColour ] \
                    single_Stem_Angle
            
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Steerer(Fork)   $HeadTube(Stem) ] \
                            aligned \
                            [expr  100 * $stageScale]   0 \
                            $dimColour ]    \
                    single_Result_HeadTube_Length   
                        #                    

            
            
                #
            return
                #
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_stackreach_result       {cv_Name BB_Position {active inactive}} {
                #
            variable    stageScale
                #
            variable    BottomBracket
            variable    HandleBar
            variable    FrontWheel
            variable    HeadTube
            variable    Saddle
            variable    Steerer
                #
            variable    Position
                #
            variable    DraftingColour
                #
            set dimColour       $DraftingColour(result)  
                #
                #
                # --- result - level - dimensions
                #
                
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Position(BaseCenter)] \
                            vertical    \
                            [expr  150 * $stageScale]   [expr   -20 * $stageScale]  \
                            $dimColour ]    \
                    single_Result_BottomBracket_Height
                #
            # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Steerer(Fork)  $HeadTube(Stem) ] \
                            aligned \
                            [expr   100 * $stageScale]   0 \
                            $dimColour ]    \
                    group_HeadTube_Parameter_01
                #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position) $FrontWheel(Position)] \
                            aligned     [expr  100 * $stageScale]   [expr  -30 * $stageScale] \
                            $dimColour ]    \
                    single_Result_FrontWheel_diagonal
                #

                # 
            return
                #
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_stackreach_summary      {cv_Name BB_Position} {
                # geometry_bg
                #
            variable    stageScale
                #
            variable    BottomBracket
            variable    FrontWheel
            variable    HandleBar
            variable    HeadTube
            variable    RearWheel
            variable    Saddle
            variable    SaddleNose
            variable    SeatPost
            variable    SeatTube
            variable    Steerer
            variable    Fork
                #
            variable    Position
            variable    Length
                #
            variable    DraftingColour
                #
            set dimColour    $DraftingColour(background)  
                #

                #
            set help_00             [ vectormath::addVector         $SeatTube(Ground)   {-200 0} ]
            set help_01             [ vectormath::addVector         $HeadTube(Stem)     {1 0} ]
            set help_02             [ vectormath::intersectPoint    $SeatTube(BBracket) $SeatTube(Saddle)   $HeadTube(Stem) $help_01]



            set help_fk             [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
                #
                # ---
                #
            $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Position(BaseCenter)  $Saddle(Position) ] \
                            vertical    \
                            [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
                            $dimColour
                            
            $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)   $Position(BaseCenter) ] \
                            vertical    \
                            [expr -380 * $stageScale]  [expr  230 * $stageScale]  \
                            $dimColour
                            
            $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Saddle(Position)      $HandleBar(Position) ] \
                            horizontal  \
                            [expr  -210 * $stageScale]    0 \
                            $dimColour

            $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $RearWheel(Ground)     $FrontWheel(Ground) ] \
                            horizontal  \
                            [expr  130 * $stageScale]    0 \
                            $dimColour
                            
            $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $FrontWheel(Ground)    $Steerer(Ground) ] \
                            horizontal  \
                            [expr   70 * $stageScale]   [expr  -70 * $stageScale] \
                            $dimColour

            $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Position(help_91)     $Position(help_92) ] \
                            aligned \
                            0   [expr -150 * $stageScale]  \
                            $dimColour 

            $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Position(help_93)     $Saddle(Position) ] \
                            aligned \
                            [expr -160 * $stageScale]    [expr -230 * $stageScale]  \
                            $dimColour 
                                                        
            $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                            horizontal  \
                            [expr (150 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                            $dimColour
                                    
            $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                            vertical    \
                            [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
                            $dimColour
                                    
            $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Saddle(Position)        $BottomBracket(Position)  ] \
                            horizontal  \
                            [expr -150 * $stageScale]    0 \
                            $dimColour
                                    
            $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Saddle(Position) ] \
                            vertical    \
                            [expr -580 * $stageScale]  [expr -130 * $stageScale]  \
                            $dimColour        
        
            $cv_Name dimension  angle \
                            [ appUtil::flatten_nestedList  $Steerer(Ground)         $Steerer(Fork)  $Position(BaseCenter) ] \
                            150   0  \
                            $dimColour
                            
            $cv_Name dimension  angle \
                            [ appUtil::flatten_nestedList  $SeatTube(Ground)        $SeatPost(SeatTube) $help_00 ] \
                            150   0  \
                            $dimColour    
                                            
            $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position)  $RearWheel(Position) ] \
                            vertical    \
                            [expr  -280 * $stageScale]   [expr -90 * $stageScale]  \
                            $dimColour
                                           
            $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $RearWheel(Ground)     $Position(BaseCenter) ] \
                            horizontal  \
                            [expr    70 * $stageScale]   0 \
                            $dimColour
                            
            $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Position(BaseCenter)  $FrontWheel(Ground) ] \
                            horizontal  \
                            [expr    70 * $stageScale]   0 \
                            $dimColour
     
            $cv_Name dimension  length    \
                        [ appUtil::flatten_nestedList  $SaddleNose(Position)    $HandleBar(Position)] \
                        horizontal  \
                        [expr  -80 * $stageScale]    0 \
                        $dimColour
            
            $cv_Name dimension  length    \
                        [ appUtil::flatten_nestedList  $HandleBar(Position)   $Saddle(Position) ] \
                        vertical    \
                        [expr  310 * $stageScale]   [expr -100 * $stageScale]  \
                        $dimColour            
                            
                            
            $cv_Name create circle      $help_02    -radius 4.0     -outline $dimColour     -width 1.0  -tags {__CenterLine__    seattube_virtual}
                        #
            $cv_Name dimension  length    \
                        [ appUtil::flatten_nestedList  $help_02         $HeadTube(Stem) ] \
                        horizontal  \
                        [expr  130 * $stageScale]   [expr  50 * $stageScale] \
                        $dimColour

            if {$Fork(Rake) != 0} {
                set coordList   [ appUtil::flatten_nestedList   $help_fk $FrontWheel(Position) $Steerer(Fork)  ]
            } else {
                set coordList   [ appUtil::flatten_nestedList   $FrontWheel(Position) $Steerer(Fork)  ]
            }
                        #
            $cv_Name dimension  length  \
                        $coordList  \
                        perpendicular [expr  (100 - $Fork(Rake)) * $stageScale]    [expr  -10 * $stageScale] \
                        $dimColour 
                            

                #
            return
                #
    }


    proc rattleCAD::cv_custom::createDimension_Geometry_classic_personal        {cv_Name BB_Position {active inactive}} {
                #
            variable    stageScale
                #
            variable    Rendering
            variable    Reference
                #
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
                #
            variable    Position
            variable    Length
            variable    Angle
            variable    Vector  
                #
            variable    DraftingColour
                #
            set dimColour      $DraftingColour(personal)  
            set dimColour_2    $DraftingColour(personal_2)  
                #
                # ---
                #
            set distY_SN_LC [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
                #
                # --- personal - dimensions
                #
                
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position) $SeatTube(Saddle) ] \
                            aligned \
                            [expr  -80 * $stageScale]    [expr -170 * $stageScale]  \
                            $dimColour ]    \
                    single_Result_Saddle_SeatTube_BB
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $LegClearance(Position)  $BottomBracket(Position) ] \
                            horizontal  \
                            [expr  $distY_SN_LC * $stageScale]   0  \
                            $dimColour_2 ]  \
                    single_TopTube_PivotPosition
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $LegClearance(Position)  $Position(BaseCenter) ] \
                            vertical    \
                            [expr  -50 * $stageScale]   [expr   160 * $stageScale]  \
                            $dimColour_2 ] \
                    single_Personal_InnerLegLength
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)     $Saddle(Position) ] \
                            vertical    [expr  310 * $stageScale]   [expr -100 * $stageScale]  \
                            $dimColour ]    \
                    single_Result_Saddle_Offset_HB_Y
                         
                #
            return
                #
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_classic_primary         {cv_Name BB_Position {active inactive}} {
                #
            variable    stageScale
                #
            variable    BottomBracket
            variable    Fork
            variable    FrontWheel
            variable    HandleBar
            variable    HeadTube
            variable    RearWheel
            variable    Saddle
            variable    SaddleNose
            variable    SeatPost
            variable    SeatTube
            variable    Steerer
            variable    TopTube
                #
            variable    Position
                #
            variable    DraftingColour
                #
            set dimColour       $DraftingColour(primary)  
                #
            set help_00             [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
            set help_01             [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
            set help_fk             [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
                #
                # --- primary - dimensions
                #
                
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $TopTube(SeatVirtual)    $TopTube(HeadVirtual)] \
                            aligned \
                            [expr   80 * $stageScale]   [expr  -80 * $stageScale] \
                            $dimColour ]    \
                    single_Result_TopTube_VirtualLength
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position) $TopTube(SeatVirtual) ] \
                            aligned \
                            [expr   80 * $stageScale]   [expr   90 * $stageScale] \
                            $dimColour ]    \
                    single_Result_SeatTube_VirtualLength
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position)  $RearWheel(Position) ] \
                            vertical    \
                            [expr  -280 * $stageScale]   [expr -90 * $stageScale]  \
                            $dimColour ]    \
                    single_BottomBracket_Depth
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $RearWheel(Position)      $BottomBracket(Position)] \
                            aligned \
                            [expr   100 * $stageScale]   0 \
                            $dimColour ]    \
                    single_RearWheel_Distance
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $RearWheel(Position)      $RearWheel(Ground) ] \
                            vertical    \
                            [expr   130 * $stageScale]    0 \
                            $dimColour ]    \
                    group_RearWheel_Parameter
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $FrontWheel(Position)     $FrontWheel(Ground) ] \
                            vertical    \
                            [expr  -150 * $stageScale]    0 \
                            $dimColour ]    \
                    group_FrontWheel_Parameter_01
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Steerer(Stem)  $help_fk $FrontWheel(Position) ] \
                            perpendicular [expr  100 * $stageScale]    [expr  -80 * $stageScale] \
                            $dimColour ]    \
                    single_Fork_Rake
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  angle \
                            [ appUtil::flatten_nestedList  $Steerer(Ground)  $Steerer(Fork)  $Position(BaseCenter) ] \
                            150   0  \
                            $dimColour ]    \
                    single_HeadTube_Angle
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  angle \
                            [ appUtil::flatten_nestedList  $SeatTube(Ground)        $SeatPost(SeatTube) $help_00 ] \
                            150   0  \
                            $dimColour ]    \
                    single_Result_SeatTube_Angle
                        #
                
                        #                        
            if {$Fork(Rake) != 0} {
                set coordList   [ appUtil::flatten_nestedList   $help_fk $FrontWheel(Position) $Steerer(Fork)  ]
            } else {
                set coordList   [ appUtil::flatten_nestedList   $FrontWheel(Position) $Steerer(Fork)  ]
            }
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            $coordList \
                            perpendicular [expr  (100 - $Fork(Rake)) * $stageScale]    [expr  -10 * $stageScale] \
                            $dimColour ]    \
                    single_Fork_Height 
                    
            
                #
            return
                #
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_classic_secondary       {cv_Name BB_Position {active inactive}} {
                #
            variable    stageScale
                #
            variable    BottomBracket
            variable    HandleBar
            variable    HeadTube
            variable    LegClearance
            variable    Saddle
            variable    SaddleNose                
            variable    SeatPost
            variable    SeatTube
            variable    Stem                
            variable    Steerer                
                #
            variable    Position
            variable    Length
                #
            variable    DraftingColour
                #
            set dimColour    $DraftingColour(secondary)  
                #            
                #
                # --- 
                #
            set distY_SN_LC         [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
            set help_01             [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
            set help_02             [ vectormath::addVector   $Steerer(Stem) [ vectormath::unifyVector $Steerer(Stem) $help_01 [expr  50 * $stageScale] ] ]
            set help_03             [ vectormath::addVector   $SeatPost(PivotPosition) {-10 0} ]
                #
                # ---
                #
            
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $BottomBracket(Position) ] \
                            horizontal  \
                            [expr  $distY_SN_LC * $stageScale]   0  \
                            $dimColour ]    \
                    group_Saddle_Parameter_01
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  radius    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Position(help_91)] \
                            -20            [expr  130 * $stageScale] \
                            $dimColour ]    \
                    single_CrankSet_Length
                        #      
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $SeatPost(Saddle) $Saddle(Position)  ] \
                            aligned \
                            [expr  (-500 - $Length(Length_BB_Seat)) * $stageScale ]    [expr  -80 * $stageScale] \
                            $dimColour ]    \
                    single_SaddleHeightComponent
                        #            
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList   $help_03 $SeatPost(PivotPosition) $SeatPost(Saddle)  ] \
                            perpendicular   \
                            [expr  (-420 - $Length(Length_BB_Seat)) * $stageScale ]    [expr   0 * $stageScale]  \
                            $dimColour ]    \
                    single_SeatPost_PivotOffset
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $SeatTube(BBracket) $SeatPost(SeatTube) $SeatPost(PivotPosition) ] \
                            perpendicular   \
                            [expr  -40 * $stageScale]  [expr  50 * $stageScale]  \
                            $dimColour ]    \
                    single_SeatPost_Setback
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)      $Steerer(Stem) ] \
                            aligned     [expr    80 * $stageScale]    0 \
                            $dimColour ]    \
                    single_Stem_Length                            
                        #
            if {$Stem(Angle) > 0} {
                set coordList [ appUtil::flatten_nestedList  $Steerer(Stem)  $help_02 $HandleBar(Position) ]
            } else {
                set coordList [ appUtil::flatten_nestedList  $Steerer(Stem)  $HandleBar(Position)  $help_02 ]
            }
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  angle \
                            $coordList \
                            [expr $Stem(Length) +  80]   0  \
                            $dimColour ] \
                    single_Stem_Angle
            
                #
            return
                #
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_classic_result          {cv_Name BB_Position {active inactive}} {
                #
            variable    stageScale
                #
            variable    BottomBracket
            variable    FrontWheel
            variable    HandleBar
            variable    HeadTube
            variable    RearWheel
            variable    Saddle
            variable    Steerer
            variable    TopTube
                #
            variable    Position
                #
            variable    DraftingColour
                #
            set dimColour   $DraftingColour(result)  
                #
                # --- 
                #
                
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Position(BaseCenter)] \
                            vertical    [expr  150 * $stageScale]   [expr   -20 * $stageScale]  \
                            $dimColour ]    \
                    single_Result_BottomBracket_Height
                #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $RearWheel(Ground)       $Position(BaseCenter) ] \
                            horizontal  [expr   70 * $stageScale]   0 \
                            $dimColour ]    \
                    single_Result_RearWheel_horizontal
                                                
                #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Steerer(Fork)  $TopTube(HeadVirtual) ] \
                            aligned \
                            [expr   100 * $stageScale]   0 \
                            $dimColour ]    \
                    single_Result_HeadTube_VirtualLength
                #
            # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Steerer(Fork)  $HeadTube(Stem) ] \
                            aligned \
                            [expr   100 * $stageScale]   0 \
                            $dimColour ]    \
                    group_HeadTube_Parameter_01
                #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position) $FrontWheel(Position)] \
                            aligned     [expr  100 * $stageScale]   [expr  -30 * $stageScale] \
                            $dimColour ]    \
                    single_Result_FrontWheel_diagonal
                #

                 
                #
            return
                #
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_classic_summary         {cv_Name BB_Position} {
                # geometry_bg
                #
            variable    stageScale
                #
            variable    BottomBracket
            variable    FrontWheel
            variable    HandleBar
            variable    HeadTube
            variable    LegClearance
            variable    RearWheel
            variable    Saddle
            variable    SaddleNose
            variable    SeatPost
            variable    SeatTube
            variable    Steerer
                #
            variable    Position
            variable    Length
                #
            variable    DraftingColour
                #
            set dimColour    $DraftingColour(background)  
                #

                #
            set help_00             [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
            set help_01             [ list [lindex $BottomBracket(Position) 0] [lindex $LegClearance(Position) 1] ]
                #
                # ---
                #
            set _dim_SD_Height  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Position(BaseCenter)  $Saddle(Position) ] \
                            vertical    \
                            [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
                            $dimColour ]
                            
            set _dim_HB_Height  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)   $Position(BaseCenter) ] \
                            vertical    \
                            [expr -380 * $stageScale]  [expr  230 * $stageScale]  \
                            $dimColour ]
                            
            set _dim_SD_HB_Length  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Saddle(Position)      $HandleBar(Position) ] \
                            horizontal  \
                            [expr  -210 * $stageScale]    0 \
                            $dimColour ]

            set _dim_Wh_Distance  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $RearWheel(Ground)     $FrontWheel(Ground) ] \
                            horizontal  \
                            [expr  130 * $stageScale]    0 \
                            $dimColour ]
                            
            set _dim_FW_Lag  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $FrontWheel(Ground)    $Steerer(Ground) ] \
                            horizontal  \
                            [expr   70 * $stageScale]   [expr  -70 * $stageScale] \
                            gray20 ]

            set _dim_BT_Clearance  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Position(help_91)     $Position(help_92) ] \
                            aligned \
                            0   [expr -150 * $stageScale]  \
                            $dimColour ]

            set _dim_ST_Length  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Position(help_93)     $Saddle(Position) ] \
                            aligned \
                            [expr -160 * $stageScale]    [expr -230 * $stageScale]  \
                            $dimColour ]
       
            set _dim_HB_XPosition  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                            horizontal  \
                            [expr (150 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                            $dimColour ]
                            
            set _dim_HB_YPosition  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                            vertical    \
                            [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
                            $dimColour ]
                            
            set _dim_SD_XPositionv  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Saddle(Position)        $BottomBracket(Position)  ] \
                            horizontal  \
                            [expr -150 * $stageScale]    0 \
                            $dimColour ]
                            
            set _dim_SD_YPosition  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Saddle(Position) ] \
                            vertical    \
                            [expr -580 * $stageScale]  [expr -130 * $stageScale]  \
                            $dimColour ]           
                                            
            # set _dim_FW_Distance  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position)  $FrontWheel(Position)] \
                            aligned \
                            [expr  100 * $stageScale]   [expr  -30 * $stageScale] \
                            $dimColour ]
                                            
            set _dim_HT_Angle  \
                    [ $cv_Name dimension  angle \
                            [ appUtil::flatten_nestedList  $Steerer(Ground)         $Steerer(Fork)  $Position(BaseCenter) ] \
                            150   0  \
                            $dimColour ]
                            
            set _dim_ST_Angle  \
                    [ $cv_Name dimension  angle \
                            [ appUtil::flatten_nestedList  $SeatTube(Ground)        $SeatPost(SeatTube) $help_00 ] \
                            150   0  \
                            $dimColour ]    
                                            
            set _dim_BB_Depth  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position)  $RearWheel(Position) ] \
                            vertical    \
                            [expr  -280 * $stageScale]   [expr -90 * $stageScale]  \
                            $dimColour ]
                                            
   
            set _dim_FW_LengthX  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Position(BaseCenter)  $FrontWheel(Ground) ] \
                            horizontal  \
                            [expr    70 * $stageScale]   0 \
                            $dimColour ]    
                  
            set _dim_SN_HandleBar  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $HandleBar(Position)] \
                            horizontal  \
                            [expr  -80 * $stageScale]    0 \
                            $dimColour ]
            
            # set _dim_SD_HB_Height  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)   $Saddle(Position) ] \
                            vertical    \
                            [expr  310 * $stageScale]   [expr -100 * $stageScale]  \
                            $dimColour ]
                #
            return
                #
    } 


    proc rattleCAD::cv_custom::createDimension_Geometry_lugs_personal           {cv_Name BB_Position {active inactive}} {
                #
            variable    stageScale
                #
            variable    Rendering
            variable    Reference
                #
            variable    BottomBracket
            variable    HandleBar
            variable    LegClearance
            variable    Saddle
            variable    SaddleNose
            variable    SeatTube
                #
            variable    Position
            variable    Length
                #
            variable    DraftingColour
                #
            set dimColour      $DraftingColour(personal)  
            set dimColour_2    $DraftingColour(personal_2)  
                #
                # ---
                #
            set distY_SN_LC [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
                #
                # --- personal - dimensions
                #
                
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                            horizontal  [expr (150 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                            $dimColour ]    \
                    single_Personal_HandleBarDistance
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                            vertical    [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
                            $dimColour ]    \
                    single_Personal_HandleBarHeight
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position) $SeatTube(Saddle) ] \
                            aligned        [expr  -80 * $stageScale]    [expr -170 * $stageScale]  \
                            $dimColour ]    \
                    single_Result_Saddle_SeatTube_BB
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $LegClearance(Position)  $BottomBracket(Position) ] \
                            horizontal  [expr  $distY_SN_LC * $stageScale]   0  \
                            $dimColour_2 ]  \
                    single_TopTube_PivotPosition
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $LegClearance(Position)  $Position(BaseCenter) ] \
                            vertical    [expr  -50 * $stageScale]   [expr   160 * $stageScale]  \
                            $dimColour_2 ]  \
                    single_Personal_InnerLegLength
                                                
                #
            return
                #
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_lugs_primary            {cv_Name BB_Position {active inactive}} {
                #
            variable    stageScale
                #
            variable    Rendering
            variable    Reference
                #
            variable    BottomBracket
            variable    DownTube
            variable    ChainStay
            variable    Fork
            variable    FrontWheel
            variable    HandleBar
            variable    RearWheel
            variable    SeatTube
            variable    Steerer
            variable    Stem
            variable    TopTube
                #
            variable    Position
                #
            variable    DraftingColour
                #
            set dimColour       $DraftingColour(primary)  
                #
                # ---
                #
            set help_01     [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
            set help_02     [ vectormath::addVector   $Steerer(Stem) [ vectormath::unifyVector $Steerer(Stem) $help_01 [expr  50 * $stageScale] ] ]
            set help_fk     [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
                #
            set pt_base     [ vectormath::intersectPoint  $DownTube(Steerer) $DownTube(BBracket) $SeatTube(BBracket) $SeatTube(TopTube) ]
                #
                # ---
                #
                
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  angle \
                            [ appUtil::flatten_nestedList [list $DownTube(Steerer) $DownTube(BBracket) $Steerer(Ground)] ] \
                            250   0 \
                            $dimColour ]    \
                    single_LugDetermination_HeadLug
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  angle \
                            [ appUtil::flatten_nestedList [list $pt_base  $DownTube(Steerer) $TopTube(SeatTube) ] ] \
                            250   0 \
                            $dimColour ]    \
                    single_LugDetermination_DownTube
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  angle \
                            [ appUtil::flatten_nestedList [list $pt_base $TopTube(SeatTube) $Position(IS_ChainSt_SeatSt)] ] \
                            250   0 \
                            $dimColour ]    \
                    single_LugDetermination_ChainStay
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $RearWheel(Position)      $BottomBracket(Position)] \
                            aligned \
                            [expr   100 * $stageScale]   0 \
                            $dimColour ]    \
                    single_RearWheel_Distance
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $RearWheel(Position)      $RearWheel(Ground) ] \
                            vertical    \
                            [expr   130 * $stageScale]    0 \
                            $dimColour ]    \
                    group_RearWheel_Parameter
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $FrontWheel(Position)     $FrontWheel(Ground) ] \
                            vertical    \
                            [expr  -150 * $stageScale]    0 \
                            $dimColour ] \
                    group_FrontWheel_Parameter_01
                        #      
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)      $Steerer(Stem) ] \
                            aligned     \
                            [expr    80 * $stageScale]    0 \
                            $dimColour ]    \
                    single_Stem_Length
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Steerer(Stem)  $help_fk $FrontWheel(Position) ] \
                            perpendicular   \
                            [expr  100 * $stageScale]    [expr  -80 * $stageScale] \
                            $dimColour ]    \
                    single_Fork_Rake
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position) $RearWheel(Position) $ChainStay(Dropout)] \
                            perpendicular   \
                            [expr   80 * $stageScale]    [expr   60 * $stageScale] \
                            $dimColour ]    \
                    group_RearDropout_Parameter_02
                        #
                        #  
            if {$Stem(Angle) > 0} {
                set coordList [ appUtil::flatten_nestedList  $Steerer(Stem)  $help_02 $HandleBar(Position) ]
            } else {
                set coordList [ appUtil::flatten_nestedList  $Steerer(Stem)  $HandleBar(Position)  $help_02 ]
            }
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  angle \
                            $coordList \
                            [expr $Stem(Length) +  80]   0  \
                            $dimColour ] \
                    single_Stem_Angle
                        #
                        #
            if {$Fork(Rake) != 0} {
                set coordList   [ appUtil::flatten_nestedList   $help_fk $FrontWheel(Position) $Steerer(Fork)  ]
            } else {
                set coordList   [ appUtil::flatten_nestedList   $FrontWheel(Position) $Steerer(Fork)  ]
            }
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            $coordList \
                            perpendicular [expr  (100 - $Fork(Rake)) * $stageScale]    [expr  -10 * $stageScale] \
                            $dimColour ]    \
                    single_Fork_Height
                        #
                        #
            if {$SeatTube(OffsetBB) > 0} {
                set dim_distance    [expr  90 * $stageScale]
                set dim_offset      [expr  50 * $stageScale]
            } else {
                set dim_distance    [expr -90 * $stageScale]
                set dim_offset      [expr -50 * $stageScale]
            }
            # set _dim_ST_Offset          [ $cv_Name dimension  length        [ appUtil::flatten_nestedList [list $SeatPost(SeatTube) $SeatTube(BBracket) $BB_Position] ] \
                                                perpendicular    $dim_distance $dim_offset \
                                                $dimColour ]

                #
            return
                #
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_lugs_secondary          {cv_Name BB_Position {active inactive}} {
                #
            variable    stageScale
                #
            variable    BottomBracket
            variable    HeadTube
            variable    LegClearance
            variable    Saddle
            variable    SaddleNose                
            variable    SeatPost
            variable    SeatTube
            variable    Stem                
            variable    Steerer                
                #
            variable    Position
            variable    Length
                #
            variable    DraftingColour
                #
            set dimColour     $DraftingColour(secondary)  
                #            
                #
                # --- 
                #
            set distY_SN_LC         [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
            set help_03             [ vectormath::addVector   $SeatPost(PivotPosition) {-10 0} ]
                #
                # ---
                #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $BottomBracket(Position) ] \
                            horizontal  \
                            [expr  $distY_SN_LC * $stageScale]   0  \
                            $dimColour ]    \
                    group_Saddle_Parameter_01
                        #
            # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Steerer(Fork)  $HeadTube(Stem) ] \
                            aligned \
                            [expr   100 * $stageScale]   0 \
                            $dimColour ]    \
                    group_HeadTube_Parameter_01
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  radius    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Position(help_91)] \
                            -20            [expr  130 * $stageScale] \
                            $dimColour ]    \
                    single_CrankSet_Length
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $SeatPost(Saddle) $Saddle(Position)  ] \
                            aligned \
                            [expr  (-500 - $Length(Length_BB_Seat)) * $stageScale ]    [expr  -80 * $stageScale] \
                            $dimColour ]    \
                    single_SaddleHeightComponent
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList   $help_03 $SeatPost(PivotPosition) $SeatPost(Saddle)  ] \
                            perpendicular   \
                            [expr  (-420 - $Length(Length_BB_Seat)) * $stageScale ]    [expr   0 * $stageScale]  \
                            $dimColour ]    \
                    single_SeatPost_PivotOffset
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $SeatTube(BBracket) $SeatPost(SeatTube) $SeatPost(PivotPosition) ] \
                            perpendicular   \
                            [expr  -40 * $stageScale]  [expr  50 * $stageScale]  \
                            $dimColour ]    \
                    single_SeatPost_Setback
                                              
                #
            return
                #
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_lugs_result             {cv_Name BB_Position {active inactive}} {
                #
            variable    stageScale
                #
            variable    DownTube
            variable    HandleBar
            variable    Saddle
            variable    SaddleNose
            variable    SeatTube
                #
            variable    Position
            variable    Length
                #
            variable    DraftingColour
                #
            set dimColour    $DraftingColour(result)  
                #            
            set pt_base     [ vectormath::intersectPoint  $DownTube(Steerer) $DownTube(BBracket) $SeatTube(BBracket) $SeatTube(TopTube) ]
                #
                # ---
                #
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Saddle(Position)      $HandleBar(Position) ] \
                            horizontal  \
                            [expr  -210 * $stageScale]    0 \
                            $dimColour ]    \
                    single_Result_Saddle_Offset_HB_X
                        #                
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)     $Saddle(Position) ] \
                            vertical    [expr  310 * $stageScale]   [expr -100 * $stageScale]  \
                            $dimColour ]    \
                    single_Result_Saddle_Offset_HB_Y
                        #
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $HandleBar(Position)] \
                            horizontal      [expr  -80 * $stageScale]    0 \
                            $dimColour ]    \
                    single_Result_SaddleNose_HB            
                        #
            #rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  angle \
                            [ appUtil::flatten_nestedList [list $pt_base $DownTube(Steerer) $Position(IS_ChainSt_SeatSt)] ] \
                            310   [expr 100 * $stageScale] \
                            $dimColour ]    \
                    single_LugDetermination_ChainStay
                        #
            #rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    \
                    [ $cv_Name dimension  angle \
                            [ appUtil::flatten_nestedList [list $DownTube(Steerer) $DownTube(BBracket) $Steerer(Ground)] ] \
                            250   0 \
                            $dimColour ]    \
                    single_LugDetermination_HeadLug
                        #
                #      
            return
                #
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_lugs_summary            {cv_Name BB_Position} {
                # geometry_bg
                #
            variable    stageScale
                #
            variable    BottomBracket
            variable    DownTube
            variable    FrontWheel
            variable    HandleBar
            variable    HeadTube
            variable    LegClearance
            variable    RearWheel
            variable    Saddle
            variable    SaddleNose
            variable    SeatPost
            variable    SeatTube
            variable    Steerer
                #
            variable    Position
            variable    Length
                #
            variable    DraftingColour
                #
            set dimColour    $DraftingColour(background)  
                #

                #
            set help_00             [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
            set help_01             [ list [lindex $BottomBracket(Position) 0] [lindex $LegClearance(Position) 1] ]
                #
            set pt_base     [ vectormath::intersectPoint  $DownTube(Steerer) $DownTube(BBracket) $SeatTube(BBracket) $SeatTube(TopTube) ]
                #
                # ---
                #
            set _dim_BB_Angle \
                    [ $cv_Name dimension  angle \
                            [ appUtil::flatten_nestedList [list $pt_base $DownTube(Steerer) $Position(IS_ChainSt_SeatSt)] ] \
                            310   [expr 100 * $stageScale] \
                            $dimColour ] 
                    
            set _dim_SD_Height  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Position(BaseCenter)  $Saddle(Position) ] \
                            vertical    \
                            [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
                            $dimColour ]
                            
            set _dim_HB_Height  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)   $Position(BaseCenter) ] \
                            vertical    \
                            [expr -380 * $stageScale]  [expr  230 * $stageScale]  \
                            $dimColour ]
                            
            set _dim_SD_HB_Length  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Saddle(Position)      $HandleBar(Position) ] \
                            horizontal  \
                            [expr  -210 * $stageScale]    0 \
                            $dimColour ]

            set _dim_Wh_Distance  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $RearWheel(Ground)     $FrontWheel(Ground) ] \
                            horizontal  \
                            [expr  130 * $stageScale]    0 \
                            $dimColour ]
                            
            set _dim_FW_Lag  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $FrontWheel(Ground)    $Steerer(Ground) ] \
                            horizontal  \
                            [expr   70 * $stageScale]   [expr  -70 * $stageScale] \
                            gray20 ]

            set _dim_BT_Clearance  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Position(help_91)     $Position(help_92) ] \
                            aligned \
                            0   [expr -150 * $stageScale]  \
                            $dimColour ]

            set _dim_ST_Length  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Position(help_93)     $Saddle(Position) ] \
                            aligned \
                            [expr -160 * $stageScale]    [expr -230 * $stageScale]  \
                            $dimColour ]
       
            set _dim_HB_XPosition  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                            horizontal  \
                            [expr (150 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                            $dimColour ]
                            
            set _dim_HB_YPosition  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                            vertical    \
                            [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
                            $dimColour ]
                            
            set _dim_SD_XPositionv  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Saddle(Position)        $BottomBracket(Position)  ] \
                            horizontal  \
                            [expr -150 * $stageScale]    0 \
                            $dimColour ]
                            
            set _dim_SD_YPosition  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Saddle(Position) ] \
                            vertical    \
                            [expr -580 * $stageScale]  [expr -130 * $stageScale]  \
                            $dimColour ]           
                                            
            set _dim_FW_Distance  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position)  $FrontWheel(Position)] \
                            aligned \
                            [expr  100 * $stageScale]   [expr  -30 * $stageScale] \
                            $dimColour ]
                                            
            set _dim_HT_Angle  \
                    [ $cv_Name dimension  angle \
                            [ appUtil::flatten_nestedList  $Steerer(Ground)         $Steerer(Fork)  $Position(BaseCenter) ] \
                            150   0  \
                            $dimColour ]
                            
            set _dim_ST_Angle  \
                    [ $cv_Name dimension  angle \
                            [ appUtil::flatten_nestedList  $SeatTube(Ground)        $SeatPost(SeatTube) $help_00 ] \
                            150   0  \
                            $dimColour ]    
                                            
            set _dim_BB_Depth  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position)  $RearWheel(Position) ] \
                            vertical    \
                            [expr  -280 * $stageScale]   [expr -90 * $stageScale]  \
                            $dimColour ]
                                            
            set _dim_BB_Height  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $BottomBracket(Position)    $Position(BaseCenter)] \
                            vertical    \
                            [expr   150 * $stageScale]   [expr   -20 * $stageScale]  \
                            $dimColour ]
                  
            set _dim_CS_LengthX  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $RearWheel(Ground)     $Position(BaseCenter) ] \
                            horizontal  \
                            [expr    70 * $stageScale]   0 \
                            $dimColour ]    
            set _dim_FW_LengthX  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $Position(BaseCenter)  $FrontWheel(Ground) ] \
                            horizontal  \
                            [expr    70 * $stageScale]   0 \
                            $dimColour ]    
                  
            # set _dim_SN_HandleBar  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $HandleBar(Position)] \
                            horizontal  \
                            [expr  -80 * $stageScale]    0 \
                            $dimColour ]
            
            # set _dim_SD_HB_Height  \
                    [ $cv_Name dimension  length    \
                            [ appUtil::flatten_nestedList  $HandleBar(Position)   $Saddle(Position) ] \
                            vertical    \
                            [expr  310 * $stageScale]   [expr -100 * $stageScale]  \
                            $dimColour ]
                #
            return
                #
    }

    proc _sumup {} {
            
                
                set _dim_SD_YPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Saddle(Position) ] \
                                                vertical    [expr -580 * $stageScale]  [expr -130 * $stageScale]  \
                                                $colour(primary) ]
                set _dim_SD_XPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Saddle(Position)        $BottomBracket(Position)  ] \
                                                horizontal    [expr -150 * $stageScale]    0 \
                                                $colour(primary) ]
                set _dim_HT_Angle       [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList  $Steerer(Ground)  $Steerer(Fork)  $Position(BaseCenter) ] \
                                                150   0  \
                                                $colour(primary) ]
                set _dim_ST_Angle       [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList  $SeatTube(Ground)      $SeatPost(SeatTube) $help_00 ] \
                                                150   0  \
                                                $colour(primary) ]
                
                
                
                
                set _dim_BB_Height      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position)    $Position(BaseCenter)] \
                                                vertical    [expr  150 * $stageScale]   [expr   -20 * $stageScale]  \
                                                $colour(result) ]
                set _dim_FW_Distance    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position)  $FrontWheel(Position)] \
                                                aligned     [expr  100 * $stageScale]   [expr  -30 * $stageScale] \
                                                $colour(result) ]
                set _dim_ST_Length      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SeatTube(Saddle)      $BottomBracket(Position) ] \
                                                horizontal  [expr  -80 * $stageScale]   [expr    0 * $stageScale]  \
                                                darkblue ]
                set _dim_HT_Reach_X     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $HeadTube(Stem)       $BottomBracket(Position) ] \
                                                horizontal  [expr  -80 * $stageScale]    0 \
                                                $colour(result) ]
                set _dim_HT_Stack_Y     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $HeadTube(Stem)       $BottomBracket(Position) ] \
                                                vertical    [expr   80 * $stageScale]    [expr  120 * $stageScale]  \
                                                $colour(result) ]


                # set _dim_SN_HandleBar   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $HandleBar(Position)] \
                                                horizontal      [expr  -80 * $stageScale]    0 \
                                                $colour(third) ]

            
            
            
            
            set _dim_TT_Virtual     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $TopTube(SeatVirtual)  $HeadTube(Stem)] \
                                                aligned     [expr  150 * $stageScale]   [expr  -80 * $stageScale] \
                                                $colour(result) ]
            set _dim_ST_Virtual     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $BottomBracket(Position) $TopTube(SeatVirtual) ] \
                                                aligned     [expr   80 * $stageScale]   [expr  -90 * $stageScale] \
                                                $colour(result) ]
                                                
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_TT_Virtual         single_Result_TopTube_VirtualLength
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_ST_Virtual         single_Result_SeatTube_VirtualLength

    
    }