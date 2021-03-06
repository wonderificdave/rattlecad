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
 #    namespace:  rattleCAD::rattleCAD::cv_custom::updateView
 # ---------------------------------------------------------------------------
 #
 #



    proc rattleCAD::cv_custom::updateView {cv_Name {updatePosition {keep}}} {

        variable     bottomCanvasBorder

            puts ""
            puts "   -------------------------------"
            puts "    rattleCAD::cv_custom::updateView"
            puts "       cv_Name:         $cv_Name"


        switch $cv_Name {
            rattleCAD::view::gui::cv_Custom02 {
                        #
                        # -- get reference
                        #
                        #
                    set xy          [rattleCAD::cv_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder $updatePosition bicycle ]
                    $cv_Name        clean_StageContent
                        #
                    update_cv_Parameter               $cv_Name $xy
                        #
                    rattleCAD::rendering::createBaseline     $cv_Name $xy
                        #
                    createDimension                   $cv_Name $xy    point_seat
                    createDimension                   $cv_Name $xy    point_frame
                        #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    RearWheel
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    FrontWheel
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Brake           editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    SeatPost
                      #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Chain           editable   ;# $updateCommand
                      #
                    rattleCAD::rendering::createFork         $cv_Name $xy    selectable                 ;# $updateCommand
                    rattleCAD::rendering::createFrame_Tubes  $cv_Name $xy
                      #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Logo            editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Saddle          editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    HeadSet
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Stem
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    HandleBar       editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    BottleCage      editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    DerailleurRear  editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    DerailleurFront editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    CrankSet        editable   ;# $updateCommand
                        #
                        # rattleCAD::rendering::createFrame_Centerline $cv_Name $xy    {} {} {baseLine}
                        #
                    rattleCAD::rendering::create_copyReference $cv_Name $xy  
                        #
                    createDimension                   $cv_Name $xy    reference_bg
                    createDimension                   $cv_Name $xy    reference_fg
                    createDimension                   $cv_Name $xy    point_reference
                        #
                    update_renderCanvas               $cv_Name
                        #
                    createWaterMark                   $cv_Name        [rattleCAD::control::getSession projectFile]  [rattleCAD::control::getSession dateModified]
                        #                      
                }
            rattleCAD::view::gui::cv_Custom00 {
                        #
                        # -- base geometry
                        #
					set xy          [rattleCAD::cv_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder $updatePosition bicycle ]
					$cv_Name        clean_StageContent
                        #
                    update_cv_Parameter               $cv_Name $xy
                        #
                    rattleCAD::rendering::createBaseline     $cv_Name $xy
                        #
                    createDimension                   $cv_Name $xy    point_seat
                    createDimension                   $cv_Name $xy    cline_frame
                    createDimension                   $cv_Name $xy    point_frame
                    createDimension                   $cv_Name $xy    geometry_bg
                        #
                    rattleCAD::rendering::createFrame_Centerline $cv_Name $xy    {saddle steerer chainstay fork} {seattube} {rearWheel frontWheel baseLine}
                        #
                    createDimension                   $cv_Name $xy    point_personal
                    createDimension                   $cv_Name $xy    point_crank
                    createDimension                   $cv_Name $xy    geometry_fg
                    createDimension                   $cv_Name $xy    point_reference
                        #
                    update_renderCenterline           $cv_Name
                        #
                    createWaterMark                   $cv_Name        [rattleCAD::control::getSession projectFile]   [rattleCAD::control::getSession dateModified]
                        #
                }
            rattleCAD::view::gui::cv_Custom10 {
                        #
                        # -- frame - details
                        #
                    set xy          [rattleCAD::cv_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder $updatePosition frame ]
                    $cv_Name        clean_StageContent
                        #
                    update_cv_Parameter                         $cv_Name $xy
                        #
                    createLugRep                                $cv_Name $xy
                        #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    SeatPost                editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    RearWheel_Rep
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    FrontWheel_Rep
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Fender_Rep              editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    CarrierRear             editable   ;# $updateCommand
                        #
                    rattleCAD::rendering::createFork         $cv_Name $xy    editable   ;# $updateCommand
                    rattleCAD::rendering::createFrame_Tubes  $cv_Name $xy    editable   ;# $updateCommand
                        #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Logo                    editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    RearWheel_Pos
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    DerailleurRear_ctr      editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Saddle                  editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    HeadSet                 editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    BottleCage              editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Stem
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    LegClearance_Rep
                        #
                    createCenterline                  $cv_Name $xy    Saddle
                        #
                    createDimension                   $cv_Name $xy    point_frame_dimension
                    createDimension                   $cv_Name $xy    cline_brake
                    createDimension                   $cv_Name $xy    frameTubing_bg
                        #
                    createDimensionType               $cv_Name $xy    RearWheel_Clearance
                    createDimensionType               $cv_Name $xy    LegClearance
                    createDimensionType               $cv_Name $xy    DerailleurMount         editable   ;# $updateCommand
                    createDimensionType               $cv_Name $xy    HeadTube_Length         editable   ;# $updateCommand
                    createDimensionType               $cv_Name $xy    SeatTube_Extension      editable   ;# $updateCommand
                    createDimensionType               $cv_Name $xy    SeatStay_Offset         editable   ;# $updateCommand
                    createDimensionType               $cv_Name $xy    HeadTube_OffsetTT       editable   ;# $updateCommand
                    createDimensionType               $cv_Name $xy    HeadTube_OffsetDT       editable   ;# $updateCommand
                    createDimensionType               $cv_Name $xy    DownTube_Offset         editable   ;# $updateCommand
                    createDimensionType               $cv_Name $xy    SeatTube_Offset         editable   ;# $updateCommand
                    createDimensionType               $cv_Name $xy    TopTube_Angle           editable   ;# $updateCommand
                    createDimensionType               $cv_Name $xy    HeadSet_Top             editable   ;# $updateCommand
                    createDimensionType               $cv_Name $xy    HeadSet_Bottom          editable   ;# $updateCommand
                    createDimensionType               $cv_Name $xy    ForkHeight              editable   ;# $updateCommand
                    createDimensionType               $cv_Name $xy    Brake_Rear              editable   ;# $updateCommand
                    createDimensionType               $cv_Name $xy    Brake_Front             editable   ;# $updateCommand
                    createDimensionType               $cv_Name $xy    TopHeadTube_Angle       editable   ;# $updateCommand
                    createDimensionType               $cv_Name $xy    BottleCage              editable   ;# $updateCommand
                        #
                        # rattleCAD::rendering::debug_geometry   $cv_Name $xy
                        #
                    update_renderCanvas               $cv_Name        wheat
                        #
                    createWaterMark                   $cv_Name        [rattleCAD::control::getSession projectFile]  [rattleCAD::control::getSession dateModified]
                        #
                    rattleCAD::view::gui::notebook_createButton    $cv_Name        TubingCheckAngles
                        #
                }
            rattleCAD::view::gui::cv_Custom20 {
                        #
                        # -- rear - mockup
                        #
                    set stageScale  [$cv_Name getNodeAttr Stage scale]
                    set stageFormat [$cv_Name getNodeAttr Stage format]
                        #
                    set xy          [rattleCAD::cv_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder $updatePosition frame $stageScale]
                        #
                    $cv_Name        clean_StageContent
                        #
                    update_cv_Parameter               $cv_Name $xy
                        #
                    createDraftingFrame               $cv_Name        $stageFormat    [expr 1/$stageScale]    [rattleCAD::control::getSession  projectName]  [rattleCAD::control::getSession dateModified]
                        #
                    createRearMockup                  $cv_Name
                        #
                    $cv_Name         centerContent    { 0  5}          {__Decoration__  __CenterLine__  __Dimension__  __Frame__  __Tube__  __Lug__  __Component__ }
                        #
                    update_renderCanvas               $cv_Name
                        #    
                    rattleCAD::view::gui::notebook_createButton    $cv_Name         {changeFormatScale}
                        #
                }
                rattleCAD::view::gui::cv_Custom30 {
                        #
                        # -- dimension summary
                        #
                    set stageFormat [$cv_Name getNodeAttr Stage format]
                    set factor      [ get_FormatFactor $stageFormat ]
                        #
                        #   puts "\n\n"
                        #   puts "   \$stageFormat: $stageFormat"
                        #   puts "   \$factor:      $factor"
                    set xy             [rattleCAD::cv_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder $updatePosition bicycle ]
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
                    update_cv_Parameter               $cv_Name $xy
                        #
                    createDimension                   $cv_Name $xy    point_seat
                    createDimension                   $cv_Name $xy    point_center
                        #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    RearWheel
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    FrontWheel
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Fender          editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Brake           editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    SeatPost
                      #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Chain           editable   ;# $updateCommand
                      #
                    rattleCAD::rendering::createFork         $cv_Name $xy    selectable                 ;# $updateCommand
                    rattleCAD::rendering::createFrame_Tubes  $cv_Name $xy
                      #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Logo            editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Saddle          editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    HeadSet
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Stem
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    HandleBar       editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    BottleCage      editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    DerailleurRear  editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    DerailleurFront editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    CrankSet        editable   ;# $updateCommand
                        #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    CarrierRear     editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    CarrierFront    editable   ;# $updateCommand
                        #
                    createDimension                   $cv_Name $xy    cline_angle
                        #
                    createDimension                   $cv_Name $xy    summary_bg
                        #
                    createDimension                   $cv_Name $xy    summary_fg
                        #
                    rattleCAD::rendering::createBaseline     $cv_Name $xy    black
                        #
                    update_renderCanvas               $cv_Name        wheat   gray98  gray93  gray93
                        #
                    createWaterMark                   $cv_Name        [rattleCAD::control::getSession projectFile]  [rattleCAD::control::getSession dateModified]
                        #
                    rattleCAD::view::gui::notebook_createButton    $cv_Name        changeFormatScale   format
                        #
                }
			rattleCAD::view::gui::cv_Custom40 {
                        #
                        # -- frame - drafting
                        #
                    set stageScale  [$cv_Name getNodeAttr Stage scale]
                    set stageFormat [$cv_Name getNodeAttr Stage format]
                        #
                    set xy          [rattleCAD::cv_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder $updatePosition frame $stageScale]
                        #
                    $cv_Name        clean_StageContent
                        #
                    update_cv_Parameter               $cv_Name $xy
                        #
                    createDraftingFrame               $cv_Name        $stageFormat    [expr 1/$stageScale]    [rattleCAD::control::getSession  projectName]  [rattleCAD::control::getSession dateModified]
                        # [clock format [clock seconds] -format {%Y.%m.%d %H:%M}]
                        #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    RearWheel_Rep
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    FrontWheel_Rep
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Fender_Rep
                        #
                    rattleCAD::rendering::createFork         $cv_Name $xy
                    rattleCAD::rendering::createFrame_Tubes  $cv_Name $xy
                        #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Logo            editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    RearWheel_Pos
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    DerailleurRear_ctr
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    BottleCage
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    LegClearance_Rep
                        #
                    createCenterline                  $cv_Name $xy
                        #
                    createDimension                   $cv_Name $xy    cline_brake
                    createDimension                   $cv_Name $xy    frameDrafting_bg
                        #
                    $cv_Name        centerContent     { 0  25}        {__Decoration__  __CenterLine__  __Dimension__  __Frame__}
                        #
                    update_renderCanvas               $cv_Name         wheat
                        #
                    rattleCAD::view::gui::notebook_createButton    $cv_Name        changeFormatScale
                        #
                }
            rattleCAD::view::gui::cv_Custom50 {
                        #
                        # -- mockup
                        #
                    set xy          [rattleCAD::cv_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder $updatePosition bicycle ]
                        #
                    $cv_Name        clean_StageContent
                        #
                    rattleCAD::rendering::createBaseline     $cv_Name $xy
                        #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    RearWheel       editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    FrontWheel      editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Fender          editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Brake           editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    SeatPost
                        #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Chain           editable   ;# $updateCommand
                        #
                    rattleCAD::rendering::createFork         $cv_Name $xy    selectable                  ;# $updateCommand
                    rattleCAD::rendering::createFrame_Tubes  $cv_Name $xy
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Logo            editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    BottleCage      editable   ;# $updateCommand
                        #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Chain           editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Saddle          editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    HeadSet
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Stem
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    HandleBar       editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    DerailleurRear  editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    DerailleurFront editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    CrankSet        editable   ;# $updateCommand
                        #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    CarrierRear     editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    CarrierFront    editable   ;# $updateCommand
                        #
                    update_renderCanvas               $cv_Name
                        #
                    createWaterMark                   $cv_Name        [rattleCAD::control::getSession projectFile]  [rattleCAD::control::getSession dateModified]
                        #
                    update_renderCanvas               $cv_Name        wheat   gray98  gray93  gray93
                        #
                    rattleCAD::view::gui::notebook_createButton    $cv_Name        changeRendering
                        #   
                }
            rattleCAD::view::gui::cv_Custom60 {
                        #
                        # -- tubemiter
                        #
                    $cv_Name        clean_StageContent
                        #
                    rattleCAD::rendering::createTubemiter    $cv_Name { 80 250}  TopTube_Head
                    rattleCAD::rendering::createTubemiter    $cv_Name { 80 145}  TopTube_Seat   rotate
                        #
                    rattleCAD::rendering::createTubemiter    $cv_Name {200 250}  DownTube_Head
                    rattleCAD::rendering::createTubemiter    $cv_Name {200 145}  DownTube_Seat  rotate
                        #
                    rattleCAD::rendering::createTubemiter    $cv_Name {330 145}  SeatTube_Down  rotate
                        #
                    rattleCAD::rendering::createTubemiter    $cv_Name {300 250}  SeatStay_02
                    rattleCAD::rendering::createTubemiter    $cv_Name {360 250}  SeatStay_01
                        #
                    rattleCAD::rendering::createTubemiter    $cv_Name {325  45}  Reference
                        # [clock format [clock seconds] -format {%Y.%m.%d %H:%M}]
                        #
                    update_renderCanvas               $cv_Name
                        #
                    createWaterMark                   $cv_Name [rattleCAD::control::getSession projectFile]  [rattleCAD::control::getSession dateModified]
                        #
                }
            rattleCAD::view::gui::cv_Custom70 {
                        #
                        # -- drafting - framejig
                        #
                    set stageScale      [$cv_Name getNodeAttr Stage scale]
                    set stageFormat     [$cv_Name getNodeAttr Stage format]
                        #
                    set xy              [rattleCAD::cv_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder $updatePosition frame $stageScale]
                        #
                    $cv_Name            clean_StageContent
                        #
                    update_cv_Parameter               $cv_Name $xy
                        #
                    set drawingTitle    "<- $::APPL_Config(FrameJigType) ->    [rattleCAD::control::getSession  projectName]"
                    createDraftingFrame               $cv_Name        $stageFormat    [expr 1/$stageScale]    "$drawingTitle"  [rattleCAD::control::getSession dateModified]
                        # createDraftingFrame         $cv_Name        $stageFormat    [expr 1/$stageScale]    "$drawingTitle"  [bikeGeometry::project_attribute modified]
                        #
                    createFrameJig                    $cv_Name $xy    $stageScale   $::APPL_Config(FrameJigType)
                        #
                    $cv_Name         centerContent    {0  15}         {__Frame__  __Decoration__  __CenterLine__  __Dimension__}
                        #
                    update_renderCanvas               $cv_Name        wheat
                        #
                    rattleCAD::view::gui::notebook_createButton    $cv_Name        {changeFormatScale changeFrameJigVariant}
                        #
                }
            rattleCAD::view::gui::cv_Custom99 {
                        #
                        # -- component in ConfigPanel
                        #
                    set xy          [rattleCAD::cv_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder $updatePosition bicycle ]
                        #
                    $cv_Name        clean_StageContent
                        #
                    rattleCAD::rendering::createBaseline     $cv_Name $xy
                        #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    RearWheel           editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    FrontWheel          editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Brake               editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    SeatPost
                        #
                    rattleCAD::rendering::createFork         $cv_Name $xy
                    rattleCAD::rendering::createFrame_Tubes  $cv_Name $xy
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    BottleCage         editable   ;# $updateCommand
                        #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Saddle             editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    HeadSet
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    Stem
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    HandleBar          editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    DerailleurRear     editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    DerailleurFront    editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    CrankSet           editable   ;# $updateCommand
                        #
                    createWaterMark                          $cv_Name        [rattleCAD::control::getSession projectFile]   [rattleCAD::control::getSession dateModified]
                        #
                }

        }

        ::update    ; #for sure otherwise confuse location of canvasCad Stage
        # puts "  .... $xy"
        
    }


