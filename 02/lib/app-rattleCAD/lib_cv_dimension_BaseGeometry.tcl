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
            set colourPersonal     $DraftingColour(personal)  
            set colourPersonal_2   $DraftingColour(personal_2)  
                #
            set distY_SN_LC         [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
                #
                # ---
                #
            set _dim_HB_XPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                                                horizontal  [expr (150 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                                                $colourPersonal ]
            set _dim_HB_YPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                                                vertical    [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
                                                $colourPersonal ]
            set _dim_SD_XPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Saddle(Position)        $BottomBracket(Position)  ] \
                                                horizontal    [expr -150 * $stageScale]    0 \
                                                $colourPersonal ]
            set _dim_SD_YPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Saddle(Position) ] \
                                                vertical    [expr -580 * $stageScale]  [expr -130 * $stageScale]  \
                                                $colourPersonal ]
                #
                # ---
                #
            set _dim_LC_Position_x  [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $LegClearance(Position)  $BottomBracket(Position) ] \
                                                horizontal  [expr  $distY_SN_LC * $stageScale]   0  \
                                                $colourPersonal_2 ]
            set _dim_LC_Position_y  [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $LegClearance(Position)  $Position(BaseCenter) ] \
                                                vertical    [expr  -50 * $stageScale]   [expr   160 * $stageScale]  \
                                                $colourPersonal_2 ]
                #
                # ---
                #
            if {$active == {active}} {
                        
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HB_XPosition      single_Personal_HandleBarDistance
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HB_YPosition      single_Personal_HandleBarHeight
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SD_XPosition      single_Personal_SaddleDistance
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SD_YPosition      single_Personal_SaddleHeight
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_LC_Position_x     single_TopTube_PivotPosition
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_LC_Position_y     single_Personal_InnerLegLength
                    
                    foreach cv_Item [list $_dim_HB_XPosition $_dim_HB_YPosition $_dim_SD_XPosition $_dim_SD_YPosition] {
                         foreach cv_item [$cv_Name gettags $cv_Item] {
                            # set width [expr 1.0 * [$cv_Name itemcget $cv_item -width]]
                            # $cv_Name itemconfigure $cv_item -width 2.0
                                            
                            if 0 {
                                puts "\n\n .... realy?"
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
                    }
            }            
    
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
            set colourPrimary    $DraftingColour(primary)  
                #
            set help_01            [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
            set help_02            [ vectormath::addVector   $Steerer(Stem) [ vectormath::unifyVector $Steerer(Stem) $help_01 [expr  50 * $stageScale] ] ]
            set help_03            [ vectormath::addVector   $SeatPost(PivotPosition) {-10 0} ]
            set help_fk            [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
                #
                # --- primary - dimensions
                #
            set _dim_BB_Depth       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position)  $RearWheel(Position) ] \
                                                vertical    [expr  -280 * $stageScale]   [expr -90 * $stageScale]  \
                                                $colourPrimary ]
            set _dim_CS_Length      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Position)      $BottomBracket(Position)] \
                                                aligned     [expr   100 * $stageScale]   0 \
                                                $colourPrimary ]
            set _dim_HT_Angle       [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList  $Steerer(Ground)  $Steerer(Fork)  $Position(BaseCenter) ] \
                                                150   0  \
                                                $colourPrimary ]
            set _dim_RW_Radius      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Position)      $RearWheel(Ground) ] \
                                                vertical    [expr   130 * $stageScale]    0 \
                                                $colourPrimary ]
            set _dim_FW_Radius      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $FrontWheel(Position)     $FrontWheel(Ground) ] \
                                                vertical    [expr  -150 * $stageScale]    0 \
                                                $colourPrimary ]
            set _dim_Stem_Length    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)      $Steerer(Stem) ] \
                                                aligned     [expr    80 * $stageScale]    0 \
                                                $colourPrimary ]
            set _dim_SP_SetBack     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SeatTube(BBracket) $SeatPost(SeatTube) $SeatPost(PivotPosition) ] \
                                                perpendicular    [expr  -40 * $stageScale]  [expr  50 * $stageScale]  \
                                                $colourPrimary ]


            set _dim_Fork_Rake      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Steerer(Stem)  $help_fk $FrontWheel(Position) ] \
                                                perpendicular [expr  100 * $stageScale]    [expr  -80 * $stageScale] \
                                                $colourPrimary ]
            set _dim_SD_Height      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SeatPost(Saddle) $Saddle(Position)  ] \
                                                aligned       [expr  (-500 - $Length(Length_BB_Seat)) * $stageScale ]    [expr  -80 * $stageScale] \
                                                $colourPrimary ]
            set _dim_SP_PivotOffset [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $help_03 $SeatPost(PivotPosition) $SeatPost(Saddle)  ] \
                                                perpendicular [expr  (-420 - $Length(Length_BB_Seat)) * $stageScale ]    [expr   0 * $stageScale]  \
                                                $colourPrimary ]                      
            


            if {$Stem(Angle) > 0} {
                set _dim_Stem_Angle [ $cv_Name dimension  angle        [ appUtil::flatten_nestedList  $Steerer(Stem)  $help_02 $HandleBar(Position) ] \
                                                [expr $Stem(Length) +  80]   0  \
                                                $colourPrimary ]
            } else {
                set _dim_Stem_Angle [ $cv_Name dimension  angle        [ appUtil::flatten_nestedList  $Steerer(Stem)  $HandleBar(Position)  $help_02 ] \
                                                [expr $Stem(Length) +  80]   0  \
                                                $colourPrimary ]
            }

            if {$Fork(Rake) != 0} {
                set _dim_Fork_Height    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $help_fk $FrontWheel(Position) $Steerer(Fork)  ] \
                                                perpendicular [expr  (100 - $Fork(Rake)) * $stageScale]    [expr  -10 * $stageScale] \
                                                $colourPrimary ]
            } else {
                set _dim_Fork_Height    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $FrontWheel(Position) $Steerer(Fork)  ] \
                                                aligned          [expr  100  * $stageScale]    [expr  -10 * $stageScale] \
                                                $colourPrimary ]
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
                                                $colourPrimary ]
                                                
                                                
            if {$active == {active}} {
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_RW_Radius         group_RearWheel_Parameter
                    
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SD_Height         single_SaddleHeightComponent
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SP_SetBack        single_SeatPost_Setback
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SP_PivotOffset    single_SeatPost_PivotOffset

                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_BB_Depth          single_BottomBracket_Depth
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_CS_Length         single_RearWheel_Distance
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HT_Angle          single_HeadTube_Angle
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Stem_Length       single_Stem_Length
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Stem_Angle        single_Stem_Angle
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Fork_Rake         single_Fork_Rake
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Fork_Height       single_Fork_Height
                    
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_FW_Radius         group_FrontWheel_Parameter_01
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_ST_Offset         single_SeatTube_BottomBracketOffset
                                                
            }                                    
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
            set colourSecondary    $DraftingColour(secondary)  
                #            
                #
                # --- 
                #
            set distY_SN_LC         [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
                #
                # ---
                #
            set _dim_SN_Position_x  [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $BottomBracket(Position) ] \
                                                horizontal  [expr  $distY_SN_LC * $stageScale]   0  \
                                                $colourSecondary ]
            set _dim_HT_Length      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Steerer(Fork)  $HeadTube(Stem) ] \
                                                aligned        [expr   100 * $stageScale]   0 \
                                                $colourSecondary ]
            set _dim_CR_Length      [ $cv_Name dimension  radius            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Position(help_91)] \
                                                -20            [expr  130 * $stageScale] \
                                                $colourSecondary ]
                #
                # ---
                #
            if {$active == {active}} {
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SN_Position_x     group_Saddle_Parameter_01
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HT_Length         group_HeadTube_Parameter_01
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_CR_Length         single_CrankSet_Length
            }
    
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
            set dimColour       $DraftingColour(result)  
                #
            set help_00            [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
            set help_01            [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
                #
                #
                # --- result - level - dimensions
                #
            set _dim_SD_HB_Height   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $Saddle(Position) ] \
                                                vertical    [expr  310 * $stageScale]   [expr -100 * $stageScale]  \
                                                $dimColour ]
            set _dim_FW_Distance    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $FrontWheel(Position)] \
                                                aligned     [expr  100 * $stageScale]   [expr  -30 * $stageScale] \
                                                $dimColour ]
            set _dim_FW_DistanceX   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(BaseCenter)    $FrontWheel(Ground) ] \
                                                horizontal  [expr   70 * $stageScale]   0 \
                                                $dimColour ]
            set _dim_BB_Height      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Position(BaseCenter)] \
                                                vertical    [expr  150 * $stageScale]   [expr   -20 * $stageScale]  \
                                                $dimColour ]
            set _dim_ST_Angle       [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList  $SeatTube(Ground)        $SeatPost(SeatTube) $help_00 ] \
                                                150   0  \
                                                $dimColour ]
            set _dim_CS_LengthX     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Ground)       $Position(BaseCenter) ] \
                                                horizontal  [expr   70 * $stageScale]   0 \
                                                $dimColour ]
            set _dim_SN_HandleBar   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $HandleBar(Position)] \
                                                horizontal      [expr  -80 * $stageScale]    0 \
                                                $dimColour ]
                #
            #set _dim_HB_YPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                                                vertical    [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
                                                $colourPersonal ]
                #
            # set _dim_ST_Length    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SeatTube(Saddle)        $BottomBracket(Position) ] \
                                                horizontal  [expr  -80 * $stageScale]   [expr    0 * $stageScale]  \
                                                $dimColour ]
            # set _dim_SD_ST_Length [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $SeatTube(Saddle) ] \
                                                aligned        [expr  -80 * $stageScale]    [expr -170 * $stageScale]  \
                                                $dimColour ]
            # set _dim_TT_Virtual   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $TopTube(SeatVirtual)    $HeadTube(Stem)] \
                                                aligned     [expr  150 * $stageScale]   [expr  -80 * $stageScale] \
                                                $dimColour ]
            # set _dim_ST_Virtual   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $TopTube(SeatVirtual) ] \
                                                aligned     [expr   80 * $stageScale]   [expr   90 * $stageScale] \
                                                $dimColour ]
                #
                # ---
                #
            set _dim_HT_Reach_X     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HeadTube(Stem)          $BottomBracket(Position) ] \
                                                horizontal  [expr  -80 * $stageScale]    0 \
                                                $dimColour ]
            set _dim_HT_Stack_Y     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HeadTube(Stem)          $BottomBracket(Position) ] \
                                                vertical    [expr   80 * $stageScale]    [expr  120 * $stageScale]  \
                                                $dimColour ]

            if {$active == {active}} {
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_ST_Angle           single_Result_SeatTube_Angle
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_BB_Height          single_Result_BottomBracket_Height
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SD_HB_Height       single_Result_Saddle_Offset_HB
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_FW_Distance        single_Result_FrontWheel_diagonal
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_FW_DistanceX       single_Result_FrontWheel_horizontal
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HT_Reach_X         single_Result_HeadTube_ReachLength
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HT_Stack_Y         single_Result_StackHeight
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_CS_LengthX         single_Result_RearWheel_horizontal
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SN_HandleBar      single_Result_SaddleNose_HB
                    
                    #rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_ST_Length          single_Result_Saddle_Offset_BB_ST
                    #rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SD_ST_Length       single_Result_Saddle_SeatTube_BB
                    #rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_TT_Virtual         single_Result_TopTube_VirtualLength
                    #rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_ST_Virtual         single_Result_SeatTube_VirtualLength
            }

    }
    proc rattleCAD::cv_custom::createDimension_Geometry_hybrid_background       {cv_Name BB_Position} {
                #
            variable    stageScale
                #
            variable    BottomBracket
            variable    FrontWheel
            variable    HandleBar
            variable    LegClearance
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
            set colourBackground     $DraftingColour(background)  
                #
                # ----
                #
            set help_01                 [ list [lindex $BottomBracket(Position) 0] [lindex $LegClearance(Position) 1] ]
                #
                # ----
                #
            set _dim_SD_Height          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(BaseCenter)  $Saddle(Position) ] \
                                                vertical    [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
                                                $colourBackground ]
            set _dim_HB_Height          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)   $Position(BaseCenter) ] \
                                                vertical    [expr -380 * $stageScale]  [expr  230 * $stageScale]  \
                                                $colourBackground ]
            set _dim_SD_HB_Length       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Saddle(Position)      $HandleBar(Position) ] \
                                                horizontal  [expr  -210 * $stageScale]    0 \
                                                $colourBackground ]
                #
                # ----
                #
            set _dim_Wh_Distance        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Ground)     $FrontWheel(Ground) ] \
                                                horizontal  [expr  130 * $stageScale]    0 \
                                                $colourBackground ]
            set _dim_FW_Lag             [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $FrontWheel(Ground)    $Steerer(Ground) ] \
                                                horizontal  [expr   70 * $stageScale]   [expr  -70 * $stageScale] \
                                                $colourBackground ]
                #
                # ----
                #
            set _dim_BT_Clearance       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(help_91)     $Position(help_92) ] \
                                                aligned        0   [expr -150 * $stageScale]  \
                                                $colourBackground ]
                #
                # ----
                #
            set _dim_ST_Length          [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(help_93)     $Saddle(Position) ] \
                                                aligned        [expr -160 * $stageScale]    [expr -230 * $stageScale]  \
                                                $colourBackground ]
                #
                # ----
                #
            # set _dim_SP_Height        [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SeatPost(Saddle)      $BottomBracket(Position)  ] \
                                                vertical    [expr (500 + $Length(Length_BB_Seat)) * $stageScale ]    [expr  150 * $stageScale] \
                                                $colourBackground ]
                              
    } 


    proc rattleCAD::cv_custom::createDimension_Geometry_stackreach_personal     {cv_Name BB_Position {active inactive}} {
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
            set colourPersonal     $DraftingColour(personal)  
            set colourPersonal_2   $DraftingColour(personal_2)  
                #
                # ---
                #
            set help_00     [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
            set help_01     [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
            set help_02     [ vectormath::addVector   $Steerer(Stem) [ vectormath::unifyVector $Steerer(Stem) $help_01 [expr  50 * $stageScale] ] ]
            set help_03     [ vectormath::addVector   $SeatPost(PivotPosition) {-10 0} ]
            set help_fk     [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
                #
            set pt_base     [ vectormath::intersectPoint  $DownTube(Steerer) $DownTube(BBracket) $SeatTube(BBracket) $SeatTube(TopTube) ]
                #
            set distY_SN_LC [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
                #
                # --- personal - dimensions
                #
            set _dim_SD_ST_Length   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $SeatTube(Saddle) ] \
                                                aligned        [expr  -80 * $stageScale]    [expr -170 * $stageScale]  \
                                                $colourPersonal ]
            set _dim_LC_Position_x  [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $LegClearance(Position)  $BottomBracket(Position) ] \
                                                horizontal  [expr  $distY_SN_LC * $stageScale]   0  \
                                                $colourPersonal_2 ]
            set _dim_LC_Position_y  [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $LegClearance(Position)  $Position(BaseCenter) ] \
                                                vertical    [expr  -50 * $stageScale]   [expr   160 * $stageScale]  \
                                                $colourPersonal_2 ]
                                                
            #set _dim_HB_XPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                                                horizontal  [expr (150 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                                                $colourPersonal ]
            #set _dim_HB_YPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                                                vertical    [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
                                                $colourPersonal ]

            # set _dim_HB_YPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                                                vertical    [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
                                                $colourPersonal ]

                                                
            if {$active == {active}} {
                    
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HB_XPosition      single_Personal_HandleBarDistance
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HB_YPosition      single_Personal_HandleBarHeight
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SD_ST_Length       single_Result_Saddle_SeatTube_BB
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_LC_Position_x     single_TopTube_PivotPosition
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_LC_Position_y     single_Personal_InnerLegLength
                    
            }            

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
            set colourPrimary       $DraftingColour(primary)  
                #
            set help_00             [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
            set help_01             [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
            set help_02             [ vectormath::addVector   $Steerer(Stem) [ vectormath::unifyVector $Steerer(Stem) $help_01 [expr  50 * $stageScale] ] ]
            set help_fk             [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
                #
                # ---
                #
            set _dim_HT_Reach_X     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HeadTube(Stem)          $BottomBracket(Position) ] \
                                                horizontal  [expr  -80 * $stageScale]    0 \
                                                $colourPrimary ]
            set _dim_HT_Stack_Y     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HeadTube(Stem)          $BottomBracket(Position) ] \
                                                vertical    [expr   80 * $stageScale]    [expr  120 * $stageScale]  \
                                                $colourPrimary ]
                                                
                                                
            set _dim_BB_Depth       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position)  $RearWheel(Position) ] \
                                                vertical    [expr  -280 * $stageScale]   [expr -90 * $stageScale]  \
                                                $colourPrimary ]
            set _dim_CS_Length      [ $cv_Name dimension  length        [ appUtil::flatten_nestedList  $RearWheel(Position)      $BottomBracket(Position)] \
                                                aligned     [expr   100 * $stageScale]   0 \
                                                $colourPrimary ]
            set _dim_RW_Radius      [ $cv_Name dimension  length        [ appUtil::flatten_nestedList  $RearWheel(Position)      $RearWheel(Ground) ] \
                                                vertical    [expr   130 * $stageScale]    0 \
                                                $colourPrimary ]
            set _dim_FW_Radius      [ $cv_Name dimension  length        [ appUtil::flatten_nestedList  $FrontWheel(Position)     $FrontWheel(Ground) ] \
                                                vertical    [expr  -150 * $stageScale]    0 \
                                                $colourPrimary ]
            set _dim_Fork_Rake      [ $cv_Name dimension  length        [ appUtil::flatten_nestedList  $Steerer(Stem)  $help_fk $FrontWheel(Position) ] \
                                                perpendicular [expr  100 * $stageScale]    [expr  -80 * $stageScale] \
                                                $colourPrimary ]
            
            
            set _dim_HT_Angle           [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList  $Steerer(Ground)  $Steerer(Fork)  $Position(BaseCenter) ] \
                                                150   0  \
                                                $colourPrimary ]
            set _dim_ST_Angle           [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList  $SeatTube(Ground)        $SeatPost(SeatTube) $help_00 ] \
                                                150   0  \
                                                $colourPrimary ]


            if {$Fork(Rake) != 0} {
                set _dim_Fork_Height    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $help_fk $FrontWheel(Position) $Steerer(Fork)  ] \
                                                perpendicular [expr  (100 - $Fork(Rake)) * $stageScale]    [expr  -10 * $stageScale] \
                                                $colourPrimary ]
            } else {
                set _dim_Fork_Height    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $FrontWheel(Position) $Steerer(Fork)  ] \
                                                aligned          [expr  100  * $stageScale]    [expr  -10 * $stageScale] \
                                                $colourPrimary ]
            }
            
            
                                                            
                #
                # ---
                #
            if {$active == {active}} {
            
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HT_Reach_X        single_Result_HeadTube_ReachLength
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HT_Stack_Y        single_Result_StackHeight
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_BB_Depth          single_BottomBracket_Depth
                    
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SD_Height         single_SaddleHeightComponent
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SP_SetBack        single_SeatPost_Setback
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SP_PivotOffset    single_SeatPost_PivotOffset

                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_BB_Depth          single_BottomBracket_Depth
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_CS_Length         single_RearWheel_Distance
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HT_Angle          single_HeadTube_Angle
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_ST_Angle          single_Result_SeatTube_Angle
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Fork_Rake         single_Fork_Rake
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Fork_Height       single_Fork_Height
                    
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_FW_Radius         group_FrontWheel_Parameter_01
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_RW_Radius         group_RearWheel_Parameter

                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_ST_Offset         single_SeatTube_BottomBracketOffset
                                        
            }           
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
            set colourSecondary    $DraftingColour(secondary)  
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
            set _dim_SN_Position_x  [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $BottomBracket(Position) ] \
                                                horizontal  [expr  $distY_SN_LC * $stageScale]   0  \
                                                $colourSecondary ]
            set _dim_HT_Length      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Steerer(Fork)  $HeadTube(Stem) ] \
                                                aligned        [expr   100 * $stageScale]   0 \
                                                $colourSecondary ]
            set _dim_CR_Length      [ $cv_Name dimension  radius            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Position(help_91)] \
                                                -20            [expr  130 * $stageScale] \
                                                $colourSecondary ]
                                                
                                                
            set _dim_SD_Height      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SeatPost(Saddle) $Saddle(Position)  ] \
                                                aligned       [expr  (-500 - $Length(Length_BB_Seat)) * $stageScale ]    [expr  -80 * $stageScale] \
                                                $colourSecondary ]
            set _dim_SP_PivotOffset [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $help_03 $SeatPost(PivotPosition) $SeatPost(Saddle)  ] \
                                                perpendicular [expr  (-420 - $Length(Length_BB_Seat)) * $stageScale ]    [expr   0 * $stageScale]  \
                                                $colourSecondary ]                      
            set _dim_SP_SetBack     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SeatTube(BBracket) $SeatPost(SeatTube) $SeatPost(PivotPosition) ] \
                                                perpendicular    [expr  -40 * $stageScale]  [expr  50 * $stageScale]  \
                                                $colourSecondary ]

                                                
            set _dim_Stem_Length    [ $cv_Name dimension  length        [ appUtil::flatten_nestedList  $HandleBar(Position)      $Steerer(Stem) ] \
                                                aligned     [expr    80 * $stageScale]    0 \
                                                $colourSecondary ]                             
            if {$Stem(Angle) > 0} {
                set _dim_Stem_Angle [ $cv_Name dimension  angle        [ appUtil::flatten_nestedList  $Steerer(Stem)  $help_02 $HandleBar(Position) ] \
                                                [expr $Stem(Length) +  80]   0  \
                                                $colourSecondary ]
            } else {
                set _dim_Stem_Angle [ $cv_Name dimension  angle        [ appUtil::flatten_nestedList  $Steerer(Stem)  $HandleBar(Position)  $help_02 ] \
                                                [expr $Stem(Length) +  80]   0  \
                                                $colourSecondary ]
            }


                #
                # ---
                #
            if {$active == {active}} {
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SN_Position_x     group_Saddle_Parameter_01
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HT_Length         group_HeadTube_Parameter_01
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_CR_Length         single_CrankSet_Length
                        #
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SD_Height         single_SaddleHeightComponent
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SP_SetBack        single_SeatPost_Setback
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SP_PivotOffset    single_SeatPost_PivotOffset
                        #
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Stem_Angle        single_Stem_Angle
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Stem_Length       single_Stem_Length
            }
    
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_stackreach_result       {cv_Name BB_Position {active inactive}} {
                #
            variable    stageScale
                #
            variable    BottomBracket
            variable    RearWheel
                #
            variable    Position
                #
            variable    DraftingColour
                #
            set dimColour       $DraftingColour(result)  
                #
            set help_00            [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
            set help_01            [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
                #
                #
                # --- result - level - dimensions
                #
            set _dim_BB_Height      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Position(BaseCenter)] \
                                                vertical    [expr  150 * $stageScale]   [expr   -20 * $stageScale]  \
                                                $dimColour ]
                #
                # ---
                #            
            # set _dim_SD_HB_Height   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $Saddle(Position) ] \
                                                vertical    [expr  310 * $stageScale]   [expr -100 * $stageScale]  \
                                                $dimColour ]
            # set _dim_FW_Distance    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $FrontWheel(Position)] \
                                                aligned     [expr  100 * $stageScale]   [expr  -30 * $stageScale] \
                                                $dimColour ]
            # set _dim_FW_DistanceX   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(BaseCenter)    $FrontWheel(Ground) ] \
                                                horizontal  [expr   70 * $stageScale]   0 \
                                                $dimColour ]
            # set _dim_ST_Angle       [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList  $SeatTube(Ground)        $SeatPost(SeatTube) $help_00 ] \
                                                150   0  \
                                                $dimColour ]
            # set _dim_CS_LengthX     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Ground)       $Position(BaseCenter) ] \
                                                horizontal  [expr   70 * $stageScale]   0 \
                                                $dimColour ]
            # set _dim_SN_HandleBar   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $HandleBar(Position)] \
                                                horizontal      [expr  -80 * $stageScale]    0 \
                                                $dimColour ]
                #
                # ---
                #
            # set _dim_HT_Reach_X     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HeadTube(Stem)          $BottomBracket(Position) ] \
                                                horizontal  [expr  -80 * $stageScale]    0 \
                                                $dimColour ]
            # set _dim_HT_Stack_Y     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HeadTube(Stem)          $BottomBracket(Position) ] \
                                                vertical    [expr   80 * $stageScale]    [expr  120 * $stageScale]  \
                                                $dimColour ]

            if {$active == {active}} {
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_BB_Height          single_Result_BottomBracket_Height
                    
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_ST_Angle           single_Result_HeadTube_Angle
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_FW_DistanceX       single_Result_FrontWheel_horizontal
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_CS_LengthX         single_Result_RearWheel_horizontal
                    
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_FW_Distance        single_Result_FrontWheel_diagonal
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SD_HB_Height       single_Result_Saddle_Offset_HB
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HT_Reach_X         single_Result_HeadTube_ReachLength
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HT_Stack_Y         single_Result_StackHeight
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SN_HandleBar       single_Result_SaddleNose_HB
                      
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_ST_Length          single_Result_Saddle_Offset_BB_ST
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SD_ST_Length       single_Result_Saddle_SeatTube_BB
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_TT_Virtual         single_Result_TopTube_VirtualLength
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_ST_Virtual         single_Result_SeatTube_VirtualLength
            }

    } 
    proc rattleCAD::cv_custom::createDimension_Geometry_stackreach_background   {cv_Name BB_Position} {
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
            set colourBackground    $DraftingColour(background)  
                #

                #
            set help_00             [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
            set help_01             [ list [lindex $BottomBracket(Position) 0] [lindex $LegClearance(Position) 1] ]
                #
                # ---
                #
            set _dim_SD_Height      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(BaseCenter)  $Saddle(Position) ] \
                                            vertical    [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
                                            $colourBackground ]
            set _dim_HB_Height      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)   $Position(BaseCenter) ] \
                                            vertical    [expr -380 * $stageScale]  [expr  230 * $stageScale]  \
                                            $colourBackground ]
            set _dim_SD_HB_Length   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Saddle(Position)      $HandleBar(Position) ] \
                                            horizontal  [expr  -210 * $stageScale]    0 \
                                            $colourBackground ]

            set _dim_Wh_Distance    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Ground)     $FrontWheel(Ground) ] \
                                            horizontal  [expr  130 * $stageScale]    0 \
                                            $colourBackground ]
            set _dim_FW_Lag         [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $FrontWheel(Ground)    $Steerer(Ground) ] \
                                            horizontal  [expr   70 * $stageScale]   [expr  -70 * $stageScale] \
                                            gray20 ]

            set _dim_BT_Clearance   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(help_91)     $Position(help_92) ] \
                                            aligned     0   [expr -150 * $stageScale]  \
                                            $colourBackground ]

            set _dim_ST_Length      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(help_93)     $Saddle(Position) ] \
                                            aligned         [expr -160 * $stageScale]    [expr -230 * $stageScale]  \
                                            $colourBackground ]
                                                
                                            
            set _dim_HB_XPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                                            horizontal  [expr (150 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                                            $colourBackground ]
            set _dim_HB_YPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                                            vertical    [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
                                            $colourBackground ]
            set _dim_SD_XPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Saddle(Position)        $BottomBracket(Position)  ] \
                                            horizontal  [expr -150 * $stageScale]    0 \
                                            $colourBackground ]
            set _dim_SD_YPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Saddle(Position) ] \
                                            vertical    [expr -580 * $stageScale]  [expr -130 * $stageScale]  \
                                            $colourBackground ]           

                                            
            set _dim_FW_Distance    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position)  $FrontWheel(Position)] \
                                            aligned     [expr  100 * $stageScale]   [expr  -30 * $stageScale] \
                                            $colourBackground ] 

                                            
            set _dim_HT_Angle       [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList  $Steerer(Ground)         $Steerer(Fork)  $Position(BaseCenter) ] \
                                            150   0  \
                                            $colourBackground ]
            set _dim_ST_Angle       [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList  $SeatTube(Ground)        $SeatPost(SeatTube) $help_00 ] \
                                            150   0  \
                                            $colourBackground ]    

                                            
            set _dim_BB_Depth       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position)  $RearWheel(Position) ] \
                                            vertical    [expr  -280 * $stageScale]   [expr -90 * $stageScale]  \
                                            $colourBackground ]
            set _dim_BB_Height      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position)    $Position(BaseCenter)] \
                                            vertical    [expr   150 * $stageScale]   [expr   -20 * $stageScale]  \
                                            $colourBackground ]

                                            
            set _dim_CS_LengthX     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Ground)     $Position(BaseCenter) ] \
                                            horizontal  [expr    70 * $stageScale]   0 \
                                            $colourBackground ]    
            set _dim_FW_LengthX     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(BaseCenter)  $FrontWheel(Ground) ] \
                                            horizontal  [expr    70 * $stageScale]   0 \
                                            $colourBackground ]    

                                            
            set _dim_SN_HandleBar   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $HandleBar(Position)] \
                                            horizontal      [expr  -80 * $stageScale]    0 \
                                            $colourBackground ]
            
            
            set _dim_SD_HB_Height   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)   $Saddle(Position) ] \
                                            vertical    [expr  310 * $stageScale]   [expr -100 * $stageScale]  \
                                            $colourBackground ]
                                           
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
            set colourPersonal      $DraftingColour(personal)  
            set colourPersonal_2    $DraftingColour(personal_2)  
                #
                # ---
                #
            set help_00     [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
            set help_01     [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
            set help_02     [ vectormath::addVector   $Steerer(Stem) [ vectormath::unifyVector $Steerer(Stem) $help_01 [expr  50 * $stageScale] ] ]
            set help_03     [ vectormath::addVector   $SeatPost(PivotPosition) {-10 0} ]
            set help_fk     [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
                #
            set pt_base     [ vectormath::intersectPoint  $DownTube(Steerer) $DownTube(BBracket) $SeatTube(BBracket) $SeatTube(TopTube) ]
                #
            set distY_SN_LC [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
                #
                # --- personal - dimensions
                #
            set _dim_SD_ST_Length   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $SeatTube(Saddle) ] \
                                                aligned        [expr  -80 * $stageScale]    [expr -170 * $stageScale]  \
                                                $colourPersonal ]
            set _dim_LC_Position_x  [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $LegClearance(Position)  $BottomBracket(Position) ] \
                                                horizontal  [expr  $distY_SN_LC * $stageScale]   0  \
                                                $colourPersonal_2 ]
            set _dim_LC_Position_y  [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $LegClearance(Position)  $Position(BaseCenter) ] \
                                                vertical    [expr  -50 * $stageScale]   [expr   160 * $stageScale]  \
                                                $colourPersonal_2 ]
                                                
            #set _dim_HB_XPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                                                horizontal  [expr (150 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                                                $colourPersonal ]
            #set _dim_HB_YPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                                                vertical    [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
                                                $colourPersonal ]

            # set _dim_HB_YPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                                                vertical    [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
                                                $colourPersonal ]

                                                
            if {$active == {active}} {
                    
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HB_XPosition      single_Personal_HandleBarDistance
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HB_YPosition      single_Personal_HandleBarHeight
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SD_ST_Length       single_Result_Saddle_SeatTube_BB
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_LC_Position_x     single_TopTube_PivotPosition
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_LC_Position_y     single_Personal_InnerLegLength
                    
            }            

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
            set colourPrimary       $DraftingColour(primary)  
                #
            set help_00             [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
            set help_01             [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
            set help_fk             [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
                #
                #
                # --- primary - dimensions
                #
            set _dim_TT_Virtual   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $TopTube(SeatVirtual)    $HeadTube(Stem)] \
                                                aligned     [expr   80 * $stageScale]   [expr  -80 * $stageScale] \
                                                $colourPrimary ]
            set _dim_ST_Virtual   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $TopTube(SeatVirtual) ] \
                                                aligned     [expr   80 * $stageScale]   [expr   90 * $stageScale] \
                                                $colourPrimary ]
           

            set _dim_BB_Depth       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position)  $RearWheel(Position) ] \
                                                vertical    [expr  -280 * $stageScale]   [expr -90 * $stageScale]  \
                                                $colourPrimary ]
            set _dim_CS_Length      [ $cv_Name dimension  length        [ appUtil::flatten_nestedList  $RearWheel(Position)      $BottomBracket(Position)] \
                                                aligned     [expr   100 * $stageScale]   0 \
                                                $colourPrimary ]
            set _dim_RW_Radius      [ $cv_Name dimension  length        [ appUtil::flatten_nestedList  $RearWheel(Position)      $RearWheel(Ground) ] \
                                                vertical    [expr   130 * $stageScale]    0 \
                                                $colourPrimary ]
            set _dim_FW_Radius      [ $cv_Name dimension  length        [ appUtil::flatten_nestedList  $FrontWheel(Position)     $FrontWheel(Ground) ] \
                                                vertical    [expr  -150 * $stageScale]    0 \
                                                $colourPrimary ]
            set _dim_Fork_Rake      [ $cv_Name dimension  length        [ appUtil::flatten_nestedList  $Steerer(Stem)  $help_fk $FrontWheel(Position) ] \
                                                perpendicular [expr  100 * $stageScale]    [expr  -80 * $stageScale] \
                                                $colourPrimary ]
            
            
            # set _dim_Stem_Length    [ $cv_Name dimension  length        [ appUtil::flatten_nestedList  $HandleBar(Position)      $Steerer(Stem) ] \
                                                aligned     [expr    80 * $stageScale]    0 \
                                                $colourPrimary ]   
                                                
            
            set _dim_HT_Angle       [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList  $Steerer(Ground)  $Steerer(Fork)  $Position(BaseCenter) ] \
                                                150   0  \
                                                $colourPrimary ]
            set _dim_ST_Angle       [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList  $SeatTube(Ground)        $SeatPost(SeatTube) $help_00 ] \
                                                150   0  \
                                                $colourPrimary ]
                                                
                                                
            if {$Fork(Rake) != 0} {
                set _dim_Fork_Height    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $help_fk $FrontWheel(Position) $Steerer(Fork)  ] \
                                                perpendicular [expr  (100 - $Fork(Rake)) * $stageScale]    [expr  -10 * $stageScale] \
                                                $colourPrimary ]
            } else {
                set _dim_Fork_Height    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList            $FrontWheel(Position) $Steerer(Fork)  ] \
                                                aligned          [expr  100  * $stageScale]    [expr  -10 * $stageScale] \
                                                $colourPrimary ]
            }    
            
            
            if {$active == {active}} {                    
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_TT_Virtual         single_Result_TopTube_VirtualLength
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_ST_Virtual         single_Result_SeatTube_VirtualLength
                    
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SD_Height         single_SaddleHeightComponent
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SP_SetBack        single_SeatPost_Setback
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SP_PivotOffset    single_SeatPost_PivotOffset
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Stem_Length       single_Stem_Length
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Stem_Angle        single_Stem_Angle
                    
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_BB_Depth          single_BottomBracket_Depth
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_CS_Length         single_RearWheel_Distance
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_ST_Angle          single_Result_SeatTube_Angle
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HT_Angle          single_HeadTube_Angle
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Fork_Rake         single_Fork_Rake
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Fork_Height       single_Fork_Height
                    
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_FW_Radius         group_FrontWheel_Parameter_01
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_RW_Radius         group_RearWheel_Parameter
            }    

    }
    proc rattleCAD::cv_custom::createDimension_Geometry_classic_secondary       {cv_Name BB_Position {active inactive}} {
                #
            createDimension_Geometry_stackreach_secondary   $cv_Name $BB_Position $active
                #
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_classic_result          {cv_Name BB_Position {active inactive}} {
                #
            variable    stageScale
                #
            variable    BottomBracket
            variable    HeadTube
            variable    RearWheel
            variable    Steerer
                #
            variable    Position
                #
            variable    DraftingColour
                #
            set dimColour   $DraftingColour(result)  
                #
                # --- 
                #
                # ---------------------
            set _dim_BB_Height      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Position(BaseCenter)] \
                                                vertical    [expr  150 * $stageScale]   [expr   -20 * $stageScale]  \
                                                $dimColour ]      
                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_BB_Height     single_Result_BottomBracket_Height
                # ---------------------
            set _dim_CS_LengthX     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Ground)       $Position(BaseCenter) ] \
                                                horizontal  [expr   70 * $stageScale]   0 \
                                                $dimColour ]
                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_CS_LengthX    single_Result_RearWheel_horizontal    
                # ---------------------
            set _dim_HT_Length      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Steerer(Fork)  $HeadTube(Stem) ] \
                                                aligned        [expr   100 * $stageScale]   0 \
                                                $dimColour ]
                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HT_Length         group_HeadTube_Parameter_01
                # ---------------------
                #
            return
                #
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_classic_background      {cv_Name BB_Position} {
            rattleCAD::cv_custom::createDimension_Geometry_lugs_background         $cv_Name $BB_Position                            
    }    
    
    
    proc rattleCAD::cv_custom::createDimension_Geometry_lugs_personal           {cv_Name BB_Position {active inactive}} {
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
            set colourPersonal      $DraftingColour(personal)  
            set colourPersonal_2    $DraftingColour(personal_2)  
                #
                # ---
                #
            set help_00     [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
            set help_01     [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
            set help_02     [ vectormath::addVector   $Steerer(Stem) [ vectormath::unifyVector $Steerer(Stem) $help_01 [expr  50 * $stageScale] ] ]
            set help_03     [ vectormath::addVector   $SeatPost(PivotPosition) {-10 0} ]
            set help_fk     [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
                #
            set pt_base     [ vectormath::intersectPoint  $DownTube(Steerer) $DownTube(BBracket) $SeatTube(BBracket) $SeatTube(TopTube) ]
                #
            set distY_SN_LC [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
                #
                # --- personal - dimensions
                #
            set _dim_HB_XPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                                                horizontal  [expr (150 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                                                $colourPersonal ]
            set _dim_HB_YPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                                                vertical    [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
                                                $colourPersonal ]

            set _dim_SD_ST_Length   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $SeatTube(Saddle) ] \
                                                aligned        [expr  -80 * $stageScale]    [expr -170 * $stageScale]  \
                                                $colourPersonal ]

            set _dim_LC_Position_x  [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $LegClearance(Position)  $BottomBracket(Position) ] \
                                                horizontal  [expr  $distY_SN_LC * $stageScale]   0  \
                                                $colourPersonal_2 ]
            set _dim_LC_Position_y  [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $LegClearance(Position)  $Position(BaseCenter) ] \
                                                vertical    [expr  -50 * $stageScale]   [expr   160 * $stageScale]  \
                                                $colourPersonal_2 ]
                                                
            if {$active == {active}} {
                    
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HB_XPosition      single_Personal_HandleBarDistance
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HB_YPosition      single_Personal_HandleBarHeight
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SD_ST_Length       single_Result_Saddle_SeatTube_BB
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_LC_Position_x     single_TopTube_PivotPosition
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_LC_Position_y     single_Personal_InnerLegLength
                    
            }            

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
            set colourPrimary       $DraftingColour(primary)  
                #
                # ---
                #
            set help_00     [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
            set help_01     [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
            set help_02     [ vectormath::addVector   $Steerer(Stem) [ vectormath::unifyVector $Steerer(Stem) $help_01 [expr  50 * $stageScale] ] ]
            set help_03     [ vectormath::addVector   $SeatPost(PivotPosition) {-10 0} ]
            set help_fk     [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
                #
            set pt_base     [ vectormath::intersectPoint  $DownTube(Steerer) $DownTube(BBracket) $SeatTube(BBracket) $SeatTube(TopTube) ]
                #
            set distY_SN_LC [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]    
                #
                # ---
                #
            set _dim_Head_Down_Angle    [ $cv_Name dimension  angle         [ appUtil::flatten_nestedList [list $DownTube(Steerer) $DownTube(BBracket) $Steerer(Ground)] ] \
                                                250   0 \
                                                $colourPrimary ]
            set _dim_Down_Seat_Angle    [ $cv_Name dimension  angle         [ appUtil::flatten_nestedList [list $pt_base  $DownTube(Steerer) $TopTube(SeatTube) ] ] \
                                                250   0 \
                                                $colourPrimary ]
            set _dim_ST_CS_Angle        [ $cv_Name dimension  angle         [ appUtil::flatten_nestedList [list $pt_base $TopTube(SeatTube) $Position(IS_ChainSt_SeatSt)] ] \
                                                250   0 \
                                                $colourPrimary ]
                                                
            set _dim_CS_Length          [ $cv_Name dimension  length        [ appUtil::flatten_nestedList  $RearWheel(Position)      $BottomBracket(Position)] \
                                                aligned     [expr   100 * $stageScale]   0 \
                                                $colourPrimary ]
            set _dim_RW_Radius          [ $cv_Name dimension  length        [ appUtil::flatten_nestedList  $RearWheel(Position)      $RearWheel(Ground) ] \
                                                vertical    [expr   130 * $stageScale]    0 \
                                                $colourPrimary ]
            set _dim_FW_Radius          [ $cv_Name dimension  length        [ appUtil::flatten_nestedList  $FrontWheel(Position)     $FrontWheel(Ground) ] \
                                                vertical    [expr  -150 * $stageScale]    0 \
                                                $colourPrimary ]
            set _dim_Stem_Length        [ $cv_Name dimension  length        [ appUtil::flatten_nestedList  $HandleBar(Position)      $Steerer(Stem) ] \
                                                aligned     [expr    80 * $stageScale]    0 \
                                                $colourPrimary ]
            
            set _dim_Fork_Rake          [ $cv_Name dimension  length        [ appUtil::flatten_nestedList  $Steerer(Stem)  $help_fk $FrontWheel(Position) ] \
                                                perpendicular [expr  100 * $stageScale]    [expr  -80 * $stageScale] \
                                                $colourPrimary ]
            
            set _dim_CS_Dropout         [ $cv_Name dimension  length        [ appUtil::flatten_nestedList  $BottomBracket(Position) $RearWheel(Position) $ChainStay(Dropout)] \
                                                perpendicular [expr   80 * $stageScale]    [expr   60 * $stageScale] \
                                                $colourPrimary ]
         

            if {$Stem(Angle) > 0} {
                set _dim_Stem_Angle     [ $cv_Name dimension  angle        [ appUtil::flatten_nestedList  $Steerer(Stem)  $help_02 $HandleBar(Position) ] \
                                                [expr $Stem(Length) +  80]   0  \
                                                $colourPrimary) ]
            } else {
                set _dim_Stem_Angle     [ $cv_Name dimension  angle        [ appUtil::flatten_nestedList  $Steerer(Stem)  $HandleBar(Position)  $help_02 ] \
                                                [expr $Stem(Length) +  80]   0  \
                                                $colourPrimary ]
            }

            if {$Fork(Rake) != 0} {
                set _dim_Fork_Height    [ $cv_Name dimension  length        [ appUtil::flatten_nestedList            $help_fk $FrontWheel(Position) $Steerer(Fork)  ] \
                                                perpendicular [expr  (100 - $Fork(Rake)) * $stageScale]    [expr  -10 * $stageScale] \
                                                $colourPrimary ]
            } else {
                set _dim_Fork_Height    [ $cv_Name dimension  length        [ appUtil::flatten_nestedList            $FrontWheel(Position) $Steerer(Fork)  ] \
                                                aligned          [expr  100  * $stageScale]    [expr  -10 * $stageScale] \
                                                $colourPrimary ]
            }


            if {$SeatTube(OffsetBB) > 0} {
                set dim_distance    [expr  90 * $stageScale]
                set dim_offset      [expr  50 * $stageScale]
            } else {
                set dim_distance    [expr -90 * $stageScale]
                set dim_offset      [expr -50 * $stageScale]
            }
            # set _dim_ST_Offset          [ $cv_Name dimension  length        [ appUtil::flatten_nestedList [list $SeatPost(SeatTube) $SeatTube(BBracket) $BB_Position] ] \
                                                perpendicular    $dim_distance $dim_offset \
                                                $colourPrimary ]
                #
                # ---
                #
            if {$active == {active}} {
   
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Head_Down_Angle   single_LugDetermination_HeadLug  
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Down_Seat_Angle   single_LugDetermination_DownTube  
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_ST_CS_Angle       single_LugDetermination_ChainStay 
                    
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_CS_Dropout        single_ChainStay_DropoutOffset
 
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_RW_Radius         group_RearWheel_Parameter

                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_CS_Length         single_RearWheel_Distance
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Stem_Length       single_Stem_Length
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Stem_Angle        single_Stem_Angle
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Fork_Rake         single_Fork_Rake
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Fork_Height       single_Fork_Height
                    
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_FW_Radius         group_FrontWheel_Parameter_01
                    # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_ST_Offset         single_SeatTube_BottomBracketOffset
            }    
 
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_lugs_secondary          {cv_Name BB_Position {active inactive}} {
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
            set colourSecondary     $DraftingColour(secondary)  
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
            set _dim_SN_Position_x  [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $BottomBracket(Position) ] \
                                                horizontal  [expr  $distY_SN_LC * $stageScale]   0  \
                                                $colourSecondary ]
            set _dim_HT_Length      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Steerer(Fork)  $HeadTube(Stem) ] \
                                                aligned        [expr   100 * $stageScale]   0 \
                                                $colourSecondary ]
            set _dim_CR_Length      [ $cv_Name dimension  radius            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Position(help_91)] \
                                                -20            [expr  130 * $stageScale] \
                                                $colourSecondary ]
                                                
                                                
            set _dim_SD_Height      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SeatPost(Saddle) $Saddle(Position)  ] \
                                                aligned       [expr  (-500 - $Length(Length_BB_Seat)) * $stageScale ]    [expr  -80 * $stageScale] \
                                                $colourSecondary ]
            set _dim_SP_PivotOffset [ $cv_Name dimension  length            [ appUtil::flatten_nestedList   $help_03 $SeatPost(PivotPosition) $SeatPost(Saddle)  ] \
                                                perpendicular [expr  (-420 - $Length(Length_BB_Seat)) * $stageScale ]    [expr   0 * $stageScale]  \
                                                $colourSecondary ]                      
            set _dim_SP_SetBack     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SeatTube(BBracket) $SeatPost(SeatTube) $SeatPost(PivotPosition) ] \
                                                perpendicular    [expr  -40 * $stageScale]  [expr  50 * $stageScale]  \
                                                $colourSecondary ]
                                              

                #
                # ---
                #
            if {$active == {active}} {
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SN_Position_x     group_Saddle_Parameter_01
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_HT_Length         group_HeadTube_Parameter_01
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_CR_Length         single_CrankSet_Length
                        #
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SD_Height         single_SaddleHeightComponent
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SP_SetBack        single_SeatPost_Setback
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SP_PivotOffset    single_SeatPost_PivotOffset
           }
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_lugs_result             {cv_Name BB_Position {active inactive}} {
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
            set dimColour        $DraftingColour(result)  
                #
                # ---
                #
            set help_00     [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
            set help_01     [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
            set help_02     [ vectormath::addVector   $Steerer(Stem) [ vectormath::unifyVector $Steerer(Stem) $help_01 [expr  50 * $stageScale] ] ]
            set help_03     [ vectormath::addVector   $SeatPost(PivotPosition) {-10 0} ]
            set help_fk     [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
                #
            set pt_base     [ vectormath::intersectPoint  $DownTube(Steerer) $DownTube(BBracket) $SeatTube(BBracket) $SeatTube(TopTube) ]
                #
            set distY_SN_LC [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
                #
                # --- result - level - dimensions
                #
                
                
            return
            
            
            
            #set _dim_SD_HB_Height   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)   $Saddle(Position) ] \
                                                vertical    [expr  380 * $stageScale]   [expr -100 * $stageScale]  \
                                                $dimColour ]
            #set _dim_FW_DistanceX   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(BaseCenter)  $FrontWheel(Ground) ] \
                                                horizontal  [expr   70 * $stageScale]   0 \
                                                $dimColour ]
            #set _dim_CS_LengthX     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Ground)     $Position(BaseCenter) ] \
                                                horizontal  [expr   70 * $stageScale]   0 \
                                                $dimColour ]

            if {$active == {active}} {
                    #rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_SD_HB_Height       single_Result_Saddle_Offset_HB
                    #rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_FW_DistanceX       single_Result_FrontWheel_horizontal
                    #rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_CS_LengthX         single_Result_RearWheel_horizontal
            }
    }
    proc rattleCAD::cv_custom::createDimension_Geometry_lugs_background         {cv_Name BB_Position} {
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
            set colourBackground    $DraftingColour(background)  
                #

                #
            set help_00             [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
            set help_01             [ list [lindex $BottomBracket(Position) 0] [lindex $LegClearance(Position) 1] ]
                #
                # ---
                #
            set _dim_SD_Height      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(BaseCenter)  $Saddle(Position) ] \
                                            vertical    [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
                                            $colourBackground ]
            set _dim_HB_Height      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)   $Position(BaseCenter) ] \
                                            vertical    [expr -380 * $stageScale]  [expr  230 * $stageScale]  \
                                            $colourBackground ]
            set _dim_SD_HB_Length   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Saddle(Position)      $HandleBar(Position) ] \
                                            horizontal  [expr  -210 * $stageScale]    0 \
                                            $colourBackground ]

            set _dim_Wh_Distance    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Ground)     $FrontWheel(Ground) ] \
                                            horizontal  [expr  130 * $stageScale]    0 \
                                            $colourBackground ]
            set _dim_FW_Lag         [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $FrontWheel(Ground)    $Steerer(Ground) ] \
                                            horizontal  [expr   70 * $stageScale]   [expr  -70 * $stageScale] \
                                            gray20 ]

            set _dim_BT_Clearance   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(help_91)     $Position(help_92) ] \
                                            aligned     0   [expr -150 * $stageScale]  \
                                            $colourBackground ]

            set _dim_ST_Length      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(help_93)     $Saddle(Position) ] \
                                            aligned         [expr -160 * $stageScale]    [expr -230 * $stageScale]  \
                                            $colourBackground ]
                                                
                                            
            set _dim_HB_XPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                                            horizontal  [expr (150 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                                            $colourBackground ]
            set _dim_HB_YPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)     $BottomBracket(Position) ] \
                                            vertical    [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
                                            $colourBackground ]
            set _dim_SD_XPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Saddle(Position)        $BottomBracket(Position)  ] \
                                            horizontal  [expr -150 * $stageScale]    0 \
                                            $colourBackground ]
            set _dim_SD_YPosition   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position) $Saddle(Position) ] \
                                            vertical    [expr -580 * $stageScale]  [expr -130 * $stageScale]  \
                                            $colourBackground ]           

                                            
            set _dim_FW_Distance    [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position)  $FrontWheel(Position)] \
                                            aligned     [expr  100 * $stageScale]   [expr  -30 * $stageScale] \
                                            $colourBackground ] 

                                            
            set _dim_HT_Angle       [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList  $Steerer(Ground)         $Steerer(Fork)  $Position(BaseCenter) ] \
                                            150   0  \
                                            $colourBackground ]
            set _dim_ST_Angle       [ $cv_Name dimension  angle             [ appUtil::flatten_nestedList  $SeatTube(Ground)        $SeatPost(SeatTube) $help_00 ] \
                                            150   0  \
                                            $colourBackground ]    

                                            
            set _dim_BB_Depth       [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position)  $RearWheel(Position) ] \
                                            vertical    [expr  -280 * $stageScale]   [expr -90 * $stageScale]  \
                                            $colourBackground ]
            set _dim_BB_Height      [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $BottomBracket(Position)    $Position(BaseCenter)] \
                                            vertical    [expr   150 * $stageScale]   [expr   -20 * $stageScale]  \
                                            $colourBackground ]

                                            
            set _dim_CS_LengthX     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $RearWheel(Ground)     $Position(BaseCenter) ] \
                                            horizontal  [expr    70 * $stageScale]   0 \
                                            $colourBackground ]    
            set _dim_FW_LengthX     [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $Position(BaseCenter)  $FrontWheel(Ground) ] \
                                            horizontal  [expr    70 * $stageScale]   0 \
                                            $colourBackground ]    

                                            
            set _dim_SN_HandleBar   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $SaddleNose(Position)    $HandleBar(Position)] \
                                            horizontal      [expr  -80 * $stageScale]    0 \
                                            $colourBackground ]
            
            
            set _dim_SD_HB_Height   [ $cv_Name dimension  length            [ appUtil::flatten_nestedList  $HandleBar(Position)   $Saddle(Position) ] \
                                            vertical    [expr  310 * $stageScale]   [expr -100 * $stageScale]  \
                                            $colourBackground ]
                                           
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