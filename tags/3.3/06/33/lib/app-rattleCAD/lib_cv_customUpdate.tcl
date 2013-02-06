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
 #    namespace:  rattleCAD::cv_custom::update
 # ---------------------------------------------------------------------------
 #
 #



    proc cv_custom::update {cv_Name} {

        variable     bottomCanvasBorder

            puts ""
            puts "   -------------------------------"
            puts "    cv_custom::update"
            puts "       cv_Name:         $cv_Name"


        switch $cv_Name {
            lib_gui::cv_Custom00 {
                        #
                        # -- base geometry
                        #
                    set xy          [ frame_geometry::get_BottomBracket_Position $cv_Name $bottomCanvasBorder bicycle ]
                    $cv_Name        clean_StageContent
                        #
                    update_cv_Parameter                         $cv_Name $xy
                        #
                    frame_visualisation::createBaseline         $cv_Name $xy
                        #
                    createDimension                             $cv_Name $xy    point_seat
                    createDimension                             $cv_Name $xy    cline_frame
                    createDimension                             $cv_Name $xy    point_frame
                    createDimension                             $cv_Name $xy    geometry_bg
                        #
                    frame_visualisation::createFrame_Centerline $cv_Name $xy    {saddle steerer chainstay fork} {seattube} {rearWheel frontWheel baseLine}
                        #
                    createDimension                             $cv_Name $xy    point_personal
                    createDimension                             $cv_Name $xy    point_crank
                    createDimension                             $cv_Name $xy    geometry_fg
                        #
                    update_renderCenterline                     $cv_Name
                        #
                    createWaterMark                             $cv_Name        $::APPL_Config(PROJECT_File)  [frame_geometry::project_attribute modified]
                        #
                }
            lib_gui::cv_Custom10 {
                        #
                        # -- frame - details
                        #
                    set xy          [ frame_geometry::get_BottomBracket_Position $cv_Name $bottomCanvasBorder frame ]
                    $cv_Name        clean_StageContent
                        #
                    update_cv_Parameter                         $cv_Name $xy
                        #
                    createLugRep                                $cv_Name $xy
                        #
                    frame_visualisation::createDecoration       $cv_Name $xy    SeatPost                editable   ;# $updateCommand
                    frame_visualisation::createDecoration       $cv_Name $xy    RearWheel_Rep
                    frame_visualisation::createDecoration       $cv_Name $xy    FrontWheel_Rep
                        #
                    frame_visualisation::createFork_Rep         $cv_Name $xy    editable   ;# $updateCommand
                    frame_visualisation::createFrame_Tubes      $cv_Name $xy    editable   ;# $updateCommand
                        #
                    frame_visualisation::createDecoration       $cv_Name $xy    Logo
                    frame_visualisation::createDecoration       $cv_Name $xy    RearWheel_Pos
                    frame_visualisation::createDecoration       $cv_Name $xy    DerailleurRear_ctr      editable   ;# $updateCommand
                    frame_visualisation::createDecoration       $cv_Name $xy    Saddle                  editable   ;# $updateCommand
                    frame_visualisation::createDecoration       $cv_Name $xy    HeadSet                 editable   ;# $updateCommand
                    frame_visualisation::createDecoration       $cv_Name $xy    BottleCage              editable   ;# $updateCommand
                    frame_visualisation::createDecoration       $cv_Name $xy    Stem
                    frame_visualisation::createDecoration       $cv_Name $xy    LegClearance_Rep
                        #
                    createCenterline                            $cv_Name $xy    Saddle
                        #
                    createDimension                             $cv_Name $xy    point_frame_dimension
                    createDimension                             $cv_Name $xy    cline_brake
                    createDimension                             $cv_Name $xy    frameTubing_bg
                        #
                    createDimensionType                         $cv_Name $xy    RearWheel_Clearance
                    createDimensionType                         $cv_Name $xy    LegClearance
                    createDimensionType                         $cv_Name $xy    DerailleurMount
                    createDimensionType                         $cv_Name $xy    HeadTube_Length         editable   ;# $updateCommand
                    createDimensionType                         $cv_Name $xy    SeatTube_Extension      editable   ;# $updateCommand
                    createDimensionType                         $cv_Name $xy    SeatStay_Offset         editable   ;# $updateCommand
                    createDimensionType                         $cv_Name $xy    HeadTube_OffsetTT       editable   ;# $updateCommand
                    createDimensionType                         $cv_Name $xy    HeadTube_OffsetDT       editable   ;# $updateCommand
                    createDimensionType                         $cv_Name $xy    DownTube_Offset         editable   ;# $updateCommand
                    createDimensionType                         $cv_Name $xy    SeatTube_Offset         editable   ;# $updateCommand
                    createDimensionType                         $cv_Name $xy    TopTube_Angle           editable   ;# $updateCommand
                    createDimensionType                         $cv_Name $xy    HeadSet_Top             editable   ;# $updateCommand
                    createDimensionType                         $cv_Name $xy    HeadSet_Bottom          editable   ;# $updateCommand
                    createDimensionType                         $cv_Name $xy    ForkHeight              editable   ;# $updateCommand
                    createDimensionType                         $cv_Name $xy    Brake_Rear              editable   ;# $updateCommand
                    createDimensionType                         $cv_Name $xy    Brake_Front             editable   ;# $updateCommand
                    createDimensionType                         $cv_Name $xy    TopHeadTube_Angle       editable   ;# $updateCommand
                    createDimensionType                         $cv_Name $xy    BottleCage              editable   ;# $updateCommand
                        #
                        # frame_visualisation::debug_geometry           $cv_Name $xy
                        #
                    update_renderCanvas                         $cv_Name
                        #
                    createWaterMark                             $cv_Name        $::APPL_Config(PROJECT_File)  [frame_geometry::project_attribute modified]
                        #
                    lib_gui::notebook_createButton              $cv_Name        TubingCheckAngles
                        #
                }
            lib_gui::cv_Custom20 {
                        #
                        # -- rear - mockup
                        #
                    set stageScale  [$cv_Name getNodeAttr Stage scale]
                    set stageFormat [$cv_Name getNodeAttr Stage format]
                        #
                    set xy          [ frame_geometry::get_BottomBracket_Position $cv_Name $bottomCanvasBorder frame $stageScale]
                        #
                    $cv_Name        clean_StageContent
                        #
                    update_cv_Parameter                         $cv_Name $xy
                        #
                    createDraftingFrame                         $cv_Name        $stageFormat    [expr 1/$stageScale]    $::APPL_Config(PROJECT_Name)  [frame_geometry::project_attribute modified]
                        #
                    createRearMockup                            $cv_Name
                        #
                    $cv_Name            centerContent           { 0  5}          {__Decoration__  __CenterLine__  __Dimension__  __Frame__  __Tube__  __Lug__  __Component__ }
                        #
                    lib_gui::notebook_createButton              $cv_Name         {changeFormatScale}
                        #
                }
            lib_gui::cv_Custom40 {
                        #
                        # -- frame - drafting
                        #
                    set stageScale  [$cv_Name getNodeAttr Stage scale]
                    set stageFormat [$cv_Name getNodeAttr Stage format]
                        #
                    set xy          [ frame_geometry::get_BottomBracket_Position $cv_Name $bottomCanvasBorder frame $stageScale]
                        #
                    $cv_Name        clean_StageContent
                        #
                    update_cv_Parameter                         $cv_Name $xy
                        #
                    createDraftingFrame                         $cv_Name        $stageFormat    [expr 1/$stageScale]    $::APPL_Config(PROJECT_Name)  [frame_geometry::project_attribute modified]
                        # [clock format [clock seconds] -format {%Y.%m.%d %H:%M}]
                        #
                    frame_visualisation::createDecoration       $cv_Name $xy    RearWheel_Rep
                    frame_visualisation::createDecoration       $cv_Name $xy    FrontWheel_Rep
                        #
                    frame_visualisation::createFork_Rep         $cv_Name $xy
                    frame_visualisation::createFrame_Tubes      $cv_Name $xy
                        #
                    frame_visualisation::createDecoration       $cv_Name $xy    Logo
                    frame_visualisation::createDecoration       $cv_Name $xy    RearWheel_Pos
                    frame_visualisation::createDecoration       $cv_Name $xy    DerailleurRear_ctr
                    frame_visualisation::createDecoration       $cv_Name $xy    BottleCage
                    frame_visualisation::createDecoration       $cv_Name $xy    LegClearance_Rep
                        #
                    createCenterline                            $cv_Name $xy
                        #
                    createDimension                             $cv_Name $xy    cline_brake
                    createDimension                             $cv_Name $xy    frameDrafting_bg
                        #
                    $cv_Name        centerContent               { 0  25}        {__Decoration__  __CenterLine__  __Dimension__  __Frame__}
                        #
                    update_renderCanvas                         $cv_Name
                        #
                    lib_gui::notebook_createButton              $cv_Name        changeFormatScale
                        #
                }
            lib_gui::cv_Custom30 {
                        #
                        # -- dimension summary
                        #
                    set stageFormat [$cv_Name getNodeAttr Stage format]
                    set factor      [ get_FormatFactor $stageFormat ]
                        #
                        #   puts "\n\n"
                        #   puts "   \$stageFormat: $stageFormat"
                        #   puts "   \$factor:      $factor"
                    set xy             [ frame_geometry::get_BottomBracket_Position $cv_Name $bottomCanvasBorder bicycle ]
                        #
                        #   puts "   \$xy:          $xy"
                    foreach {x y} $xy break
                        #   puts "  x: $x"
                        #   puts "  y: $y"
                    set y  [expr $y + (1/$factor)*120]
                    set xy [list $x $y]
                        #   puts "   \$xy:          $xy"
                        #   puts "\n\n"
                    $cv_Name        clean_StageContent
                        #
                    update_cv_Parameter                     $cv_Name $xy
                        #
                    createDimension                         $cv_Name $xy    point_seat
                    createDimension                         $cv_Name $xy    point_center
                        #
                    frame_visualisation::createDecoration   $cv_Name $xy    RearWheel
                    frame_visualisation::createDecoration   $cv_Name $xy    FrontWheel
                    frame_visualisation::createDecoration   $cv_Name $xy    Brake           editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    SeatPost
                        #
                    frame_visualisation::createFork_Rep     $cv_Name $xy    selectable                 ;# $updateCommand
                    frame_visualisation::createFrame_Tubes  $cv_Name $xy
                        #
                    frame_visualisation::createDecoration   $cv_Name $xy    Logo
                    frame_visualisation::createDecoration   $cv_Name $xy    Saddle          editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    HeadSet
                    frame_visualisation::createDecoration   $cv_Name $xy    Stem
                    frame_visualisation::createDecoration   $cv_Name $xy    HandleBar       editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    BottleCage      editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    DerailleurRear  editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    DerailleurFront editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    CrankSet        editable   ;# $updateCommand
                        #
                    createDimension                         $cv_Name $xy    cline_angle
                        #
                    createDimension                         $cv_Name $xy    summary_bg
                        #
                    createDimension                         $cv_Name $xy    summary_fg
                        #
                    frame_visualisation::createBaseline     $cv_Name $xy    black
                        #
                    update_renderCanvas                     $cv_Name
                        #
                    createWaterMark                         $cv_Name        $::APPL_Config(PROJECT_File)  [frame_geometry::project_attribute modified]
                        #
                    lib_gui::notebook_createButton          $cv_Name        changeFormatScale   format
                        #
                }
            lib_gui::cv_Custom50 {
                        #
                        # -- assembly
                        #
                    set xy          [ frame_geometry::get_BottomBracket_Position $cv_Name $bottomCanvasBorder bicycle ]
                        #
                    $cv_Name        clean_StageContent
                        #
                    frame_visualisation::createBaseline     $cv_Name $xy
                        #
                    frame_visualisation::createDecoration   $cv_Name $xy    RearWheel       editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    FrontWheel      editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    Brake           editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    SeatPost
                        #
                    frame_visualisation::createFork_Rep     $cv_Name $xy    selectable                  ;# $updateCommand
                    frame_visualisation::createFrame_Tubes  $cv_Name $xy
                    frame_visualisation::createDecoration   $cv_Name $xy    Logo
                    frame_visualisation::createDecoration   $cv_Name $xy    BottleCage      editable   ;# $updateCommand
                        #
                    frame_visualisation::createDecoration   $cv_Name $xy    Saddle          editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    HeadSet
                    frame_visualisation::createDecoration   $cv_Name $xy    Stem
                    frame_visualisation::createDecoration   $cv_Name $xy    HandleBar       editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    DerailleurRear  editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    DerailleurFront editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    CrankSet        editable   ;# $updateCommand
                        #
                    update_renderCanvas                     $cv_Name
                        #
                    createWaterMark                         $cv_Name        $::APPL_Config(PROJECT_File)  [frame_geometry::project_attribute modified]
                        #
                }
            lib_gui::cv_Custom60 {
                        #
                        # -- tubemiter
                        #
                    $cv_Name        clean_StageContent
                        #
                    frame_visualisation::createTubemiter        $cv_Name { 80 190}  TopTube_Seat
                    frame_visualisation::createTubemiter        $cv_Name {200 190}  TopTube_Head
                    frame_visualisation::createTubemiter        $cv_Name { 80 105}  DownTube_Head
                    frame_visualisation::createTubemiter        $cv_Name {180 105}  SeatStay_02
                    frame_visualisation::createTubemiter        $cv_Name {250 105}  SeatStay_01
                    frame_visualisation::createTubemiter        $cv_Name {220  15}  Reference
                        # [clock format [clock seconds] -format {%Y.%m.%d %H:%M}]
                        #
                    update_renderCanvas                         $cv_Name
                        #
                    createWaterMark                             $cv_Name $::APPL_Config(PROJECT_File)  [frame_geometry::project_attribute modified]
                        #
                }
            lib_gui::cv_Custom70 {
                        #
                        # -- drafting - framejig
                        #
                    set stageScale      [$cv_Name getNodeAttr Stage scale]
                    set stageFormat     [$cv_Name getNodeAttr Stage format]
                        #
                    set xy              [ frame_geometry::get_BottomBracket_Position $cv_Name $bottomCanvasBorder frame $stageScale]
                        #
                    $cv_Name            clean_StageContent
                        #
                    update_cv_Parameter                         $cv_Name $xy
                        #
                    set drawingTitle    "<- $::APPL_Config(FrameJigType) ->    $::APPL_Config(PROJECT_Name)"
                    createDraftingFrame                         $cv_Name        $stageFormat    [expr 1/$stageScale]    "$drawingTitle"  [frame_geometry::project_attribute modified]
                        #
                    createFrameJig                              $cv_Name $xy    $stageScale   $::APPL_Config(FrameJigType)
                        #
                    $cv_Name         centerContent              {0  15}         {__Frame__  __Decoration__  __CenterLine__  __Dimension__}
                        #
                    lib_gui::notebook_createButton              $cv_Name        {changeFormatScale changeFrameJigVariant}
                        #
                }
            lib_gui::cv_Custom99 {
                        #
                        # -- component in ConfigPanel
                        #
                    set xy          [ frame_geometry::get_BottomBracket_Position $cv_Name $bottomCanvasBorder bicycle ]
                        #
                    $cv_Name        clean_StageContent
                        #
                    frame_visualisation::createBaseline     $cv_Name $xy
                        #
                    frame_visualisation::createDecoration   $cv_Name $xy    RearWheel           editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    FrontWheel          editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    Brake               editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    SeatPost
                        #
                    frame_visualisation::createFork_Rep     $cv_Name $xy
                    frame_visualisation::createFrame_Tubes  $cv_Name $xy
                    frame_visualisation::createDecoration   $cv_Name $xy    BottleCage         editable   ;# $updateCommand
                        #
                    frame_visualisation::createDecoration   $cv_Name $xy    Saddle             editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    HeadSet
                    frame_visualisation::createDecoration   $cv_Name $xy    Stem
                    frame_visualisation::createDecoration   $cv_Name $xy    HandleBar          editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    DerailleurRear     editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    DerailleurFront    editable   ;# $updateCommand
                    frame_visualisation::createDecoration   $cv_Name $xy    CrankSet           editable   ;# $updateCommand
                        #
                    createWaterMark                         $cv_Name         $::APPL_Config(PROJECT_File)    [frame_geometry::project_attribute modified]
                        #
                }

        }

        ::update    ; #for sure otherwise confuse location of canvasCad Stage

    }



