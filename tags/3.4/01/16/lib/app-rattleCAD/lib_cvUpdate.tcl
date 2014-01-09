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



    proc rattleCAD::cv_custom::updateView {cv_Name {keepPosition {reset}}} {

        variable     bottomCanvasBorder

            puts ""
            puts "   -------------------------------"
            puts "    rattleCAD::cv_custom::updateView"
            puts "       cv_Name:         $cv_Name"


        switch $cv_Name {
            rattleCAD::gui::cv_Custom02 {
                        #
                        # -- get reference
                        #
                        #
                    set xy          [rattleCAD::cv_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder $keepPosition bicycle ]
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
                    createWaterMark                   $cv_Name        $::APPL_Config(PROJECT_File)  [bikeGeometry::project_attribute modified]
                        #                      
                }
            rattleCAD::gui::cv_Custom00 {
                        #
                        # -- base geometry
                        #
                    set xy          [rattleCAD::cv_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder $keepPosition bicycle ]
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
                    createWaterMark                   $cv_Name        $::APPL_Config(PROJECT_File)  [bikeGeometry::project_attribute modified]
                        #
                }
            rattleCAD::gui::cv_Custom10 {
                        #
                        # -- frame - details
                        #
                    set xy          [rattleCAD::cv_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder $keepPosition frame ]
                    $cv_Name        clean_StageContent
                        #
                    update_cv_Parameter                         $cv_Name $xy
                        #
                    createLugRep                                $cv_Name $xy
                        #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    SeatPost                editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    RearWheel_Rep
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    FrontWheel_Rep
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
                    createDimensionType               $cv_Name $xy    DerailleurMount
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
                    update_renderCanvas               $cv_Name
                        #
                    createWaterMark                   $cv_Name        $::APPL_Config(PROJECT_File)  [bikeGeometry::project_attribute modified]
                        #
                    rattleCAD::gui::notebook_createButton    $cv_Name        TubingCheckAngles
                        #
                }
            rattleCAD::gui::cv_Custom20 {
                        #
                        # -- rear - mockup
                        #
                    set stageScale  [$cv_Name getNodeAttr Stage scale]
                    set stageFormat [$cv_Name getNodeAttr Stage format]
                        #
                    set xy          [rattleCAD::cv_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder $keepPosition frame $stageScale]
                        #
                    $cv_Name        clean_StageContent
                        #
                    update_cv_Parameter               $cv_Name $xy
                        #
                    createDraftingFrame               $cv_Name        $stageFormat    [expr 1/$stageScale]    $::APPL_Config(PROJECT_Name)  [bikeGeometry::project_attribute modified]
                        #
                    createRearMockup                  $cv_Name
                        #
                    $cv_Name         centerContent    { 0  5}          {__Decoration__  __CenterLine__  __Dimension__  __Frame__  __Tube__  __Lug__  __Component__ }
                        #
                    update_renderCanvas               $cv_Name
                        #    
                    rattleCAD::gui::notebook_createButton    $cv_Name         {changeFormatScale}
                        #
                }
                rattleCAD::gui::cv_Custom30 {
                        #
                        # -- dimension summary
                        #
                    set stageFormat [$cv_Name getNodeAttr Stage format]
                    set factor      [ get_FormatFactor $stageFormat ]
                        #
                        #   puts "\n\n"
                        #   puts "   \$stageFormat: $stageFormat"
                        #   puts "   \$factor:      $factor"
                    set xy             [rattleCAD::cv_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder $keepPosition bicycle ]
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
                    createDimension                   $cv_Name $xy    cline_angle
                        #
                    createDimension                   $cv_Name $xy    summary_bg
                        #
                    createDimension                   $cv_Name $xy    summary_fg
                        #
                    rattleCAD::rendering::createBaseline     $cv_Name $xy    black
                        #
                    update_renderCanvas               $cv_Name
                        #
                    createWaterMark                   $cv_Name        $::APPL_Config(PROJECT_File)  [bikeGeometry::project_attribute modified]
                        #
                    rattleCAD::gui::notebook_createButton    $cv_Name        changeFormatScale   format
                        #
                }
			rattleCAD::gui::cv_Custom40 {
                        #
                        # -- frame - drafting
                        #
                    set stageScale  [$cv_Name getNodeAttr Stage scale]
                    set stageFormat [$cv_Name getNodeAttr Stage format]
                        #
                    set xy          [rattleCAD::cv_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder $keepPosition frame $stageScale]
                        #
                    $cv_Name        clean_StageContent
                        #
                    update_cv_Parameter               $cv_Name $xy
                        #
                    createDraftingFrame               $cv_Name        $stageFormat    [expr 1/$stageScale]    $::APPL_Config(PROJECT_Name)  [bikeGeometry::project_attribute modified]
                        # [clock format [clock seconds] -format {%Y.%m.%d %H:%M}]
                        #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    RearWheel_Rep
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    FrontWheel_Rep
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
                    update_renderCanvas               $cv_Name
                        #
                    rattleCAD::gui::notebook_createButton    $cv_Name        changeFormatScale
                        #
                }
            rattleCAD::gui::cv_Custom50 {
                        #
                        # -- assembly
                        #
                    set xy          [rattleCAD::cv_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder $keepPosition bicycle ]
                        #
                    $cv_Name        clean_StageContent
                        #
                    rattleCAD::rendering::createBaseline     $cv_Name $xy
                        #
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    RearWheel       editable   ;# $updateCommand
                    rattleCAD::rendering::createDecoration   $cv_Name $xy    FrontWheel      editable   ;# $updateCommand
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
                    update_renderCanvas               $cv_Name
                        #
                    createWaterMark                   $cv_Name        $::APPL_Config(PROJECT_File)  [bikeGeometry::project_attribute modified]
                        #
                }
            rattleCAD::gui::cv_Custom60 {
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
                    createWaterMark                   $cv_Name $::APPL_Config(PROJECT_File)  [bikeGeometry::project_attribute modified]
                        #
                }
            rattleCAD::gui::cv_Custom70 {
                        #
                        # -- drafting - framejig
                        #
                    set stageScale      [$cv_Name getNodeAttr Stage scale]
                    set stageFormat     [$cv_Name getNodeAttr Stage format]
                        #
                    set xy              [rattleCAD::cv_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder $keepPosition frame $stageScale]
                        #
                    $cv_Name            clean_StageContent
                        #
                    update_cv_Parameter               $cv_Name $xy
                        #
                    set drawingTitle    "<- $::APPL_Config(FrameJigType) ->    $::APPL_Config(PROJECT_Name)"
                    createDraftingFrame               $cv_Name        $stageFormat    [expr 1/$stageScale]    "$drawingTitle"  [bikeGeometry::project_attribute modified]
                        #
                    createFrameJig                    $cv_Name $xy    $stageScale   $::APPL_Config(FrameJigType)
                        #
                    $cv_Name         centerContent    {0  15}         {__Frame__  __Decoration__  __CenterLine__  __Dimension__}
                        #
                    rattleCAD::gui::notebook_createButton    $cv_Name        {changeFormatScale changeFrameJigVariant}
                        #
                }
            rattleCAD::gui::cv_Custom99 {
                        #
                        # -- component in ConfigPanel
                        #
                    set xy          [rattleCAD::cv_custom::get_BottomBracket_Position $cv_Name $bottomCanvasBorder $keepPosition bicycle ]
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
                    createWaterMark                         $cv_Name         $::APPL_Config(PROJECT_File)    [bikeGeometry::project_attribute modified]
                        #
                }

        }

        ::update    ; #for sure otherwise confuse location of canvasCad Stage
        # puts "  .... $xy"
        
    }



     #-------------------------------------------------------------------------
	     #  return BottomBracket coords
    proc rattleCAD::cv_custom::get_BottomBracket_Position {cv_Name bottomCanvasBorder {keepPosition {reset}} {option {bicycle}} {stageScale {}}} {
	    
	    variable  Position
	    
	    array set Stage          {}
	    array set FrontWheel     {}
	    array set RearWheel      {}
	    array set BottomBracket  {}
	    
        set FrontWheel(Position)      [project::getValue Result(Position/FrontWheel)         position]
        set FrontWheel(RimDiameter)   [project::getValue Component(Wheel/Front/RimDiameter)  value]
        set FrontWheel(TyreHeight)    [project::getValue Component(Wheel/Front/TyreHeight)   value]
        set FrontWheel(Radius)        [expr 0.5 * $FrontWheel(RimDiameter) + $FrontWheel(TyreHeight)] 
                    
        set RearWheel(Position)       [project::getValue Result(Position/RearWheel)          position]
        set RearWheel(RimDiameter)    [project::getValue Component(Wheel/Rear/RimDiameter)   value]
        set RearWheel(TyreHeight)     [project::getValue Component(Wheel/Front/TyreHeight)   value]
        set RearWheel(Radius)         [expr 0.5 * $RearWheel(RimDiameter) + $RearWheel(TyreHeight)] 
        set RearWheel(Distance_X)     [project::getValue Result(Length/RearWheel/horizontal) value]
        
        set BottomBracketDepth        [project::getValue Custom(BottomBracket/Depth)         value]
        set BottomBracketHeight       [expr $RearWheel(Radius) - $BottomBracketDepth]
        set FrameSize          [split [project::getValue Result(Position/SummarySize)        position] ,]
        set SummaryLength             [lindex $FrameSize 0]
        
        
        if {$keepPosition != {reset}} {
                # puts "       <I> ... "
                # puts "       <I> ...    $bottomCanvasBorder"
                # puts "       <I> ... last value:$Position($cv_Name)"
            set Stage(scale_curr)   [ eval $cv_Name getNodeAttr Stage  scale ]
            set lastPos_x              [lindex $Position($cv_Name) 0]
            set lastPos_y              [lindex $Position($cv_Name) 1]
            set lastPosition  [list $lastPos_x $lastPos_y ]
            
            set lastHeight             [lindex $Position($cv_Name) 2]
                # puts "       <I> .......... lastHeight: $lastHeight"
                set newHeight              [expr $RearWheel(Radius) - $BottomBracketDepth ]
                # puts "       <I> ........... newHeight:  $newHeight"
            set diffHeight             [expr $lastHeight - $newHeight] 
                # puts "       <I> .......... diffHeight: $diffHeight"
                     
            set newPosition [list $lastPos_x [expr $lastPos_y - $diffHeight] ]
                # puts "       <I> ........ newPosition:  $newPosition"
            return $newPosition
        }	    

	      
          # puts "     ... \$FrontWheel(Position)     $FrontWheel(Position)"
	      # puts "     ... \$FrontWheel(RimDiameter)  $FrontWheel(RimDiameter)"
	      # puts "     ... \$FrontWheel(TyreHeight)   $FrontWheel(TyreHeight)"
	      # puts "     ... \$FrontWheel(Radius)       $FrontWheel(Radius)"
	      # puts ""
	      # puts "     ... \$RearWheel(Position)      $RearWheel(Position)"
	      # puts "     ... \$RearWheel(RimDiameter)   $RearWheel(RimDiameter)"
	      # puts "     ... \$RearWheel(TyreHeight)    $RearWheel(TyreHeight)"
	      # puts "     ... \$RearWheel(Radius)        $RearWheel(Radius)"
	      # puts "     ... \$RearWheel(Distance_X)    $RearWheel(Distance_X)"
	      # puts ""
	      # puts "     ... \$BottomBracketDepth       $BottomBracketDepth"
	      # puts "     ... \$FrameSize                $FrameSize"

	    set SummaryLength        [ lindex $FrameSize 0 ]
	    if {$option == {bicycle}} {
            set SummaryLength    [ expr $SummaryLength + 2 * $RearWheel(Radius) ]
    	}

        #
        # --- debug
        # puts "----------------------------------------"
        # puts "   get_BottomBracket_Position:"
        # puts "        \$cv_Name               $cv_Name "
        # puts "        \$bottomCanvasBorder    $bottomCanvasBorder "
        # puts "        \$option                $option"
        # puts "        \$stageScale            $stageScale"


        #
        # --- get canvasCAD-Stage information
	    set Stage(width)        [ eval $cv_Name getNodeAttr Stage  width  ]
	    set Stage(scale_curr)   [ eval $cv_Name getNodeAttr Stage  scale ]
	    if {$stageScale != {}} {
		    set Stage(scale)        $stageScale
	    } else {
		    set Stage(scale)        [ expr 0.75 * $Stage(width) / $SummaryLength ]
	    }
	    set Stage(scale_fmt)    [ format "%.4f" $Stage(scale) ]
            # puts ""
            # puts "        \$SummaryLength         $SummaryLength"
            # puts "        \$Stage(scale_fmt)      $Stage(scale_fmt)"


        #
        # --- reset canvasCAD - scale to fit the content
	    $cv_Name    setNodeAttr Stage   scale   $Stage(scale_fmt)

        #
        # ---  get unscaled width of Stage
	    set Stage(unscaled)     [ expr ($Stage(width))/$Stage(scale_fmt) ]
            # puts "        \$Stage(unscaled)       $Stage(unscaled)"

        #
        # ---  get border outside content to Stage
	    set border              [ expr  0.5 *( $Stage(unscaled) - $SummaryLength ) ]
            # puts "        \$border                $border"

        #
        # ---  get left/right/bottom border outside content to Stage
	    set cvBorder            [ expr $bottomCanvasBorder/$Stage(scale_fmt) ]
            # puts "        \$cvBorder              $cvBorder"

        #
        # ---  get baseLine Coordinates
	    if {$option == {bicycle}} {
            set BtmBracket_x        [ expr $border + $RearWheel(Radius) + $RearWheel(Distance_X) ]
            set BtmBracket_y        [ expr $cvBorder + $BottomBracketHeight ]
                # puts "\n -> get_BottomBracket_Position:  $cvBorder + $RearWheel(Radius) - $project::Custom(BottomBracket/Depth) "
                # puts "\n -> get_BottomBracket_Position:  $BtmBracket_x $BtmBracket_y \n"
	    } else {
            # puts "        \$option                $option"
            set BtmBracket_x        [ expr $border + $RearWheel(Distance_X) ]
            set BtmBracket_y        $cvBorder
                # set BtmBracket_y      [ expr $bottomCanvasBorder + 50 ]
                # puts "\n -> get_BottomBracket_Position:  $cvBorder "
                # puts "\n -> get_BottomBracket_Position:  $BtmBracket_x $BtmBracket_y \n"
	    }

            # puts "       $BtmBracket_x $BtmBracket_y"
        set Position($cv_Name) [list $BtmBracket_x $BtmBracket_y $BottomBracketHeight]
	    return [lrange $Position($cv_Name) 0 1]
    }

