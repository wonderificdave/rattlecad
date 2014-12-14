    proc rattleCAD::rendering::createDecoration_HandleBar {cv_Name BB_Position type {updateCommand {}}} {
                # --- create Handlebar -------------
            set HandleBar(position)     [ rattleCAD::model::get_Position     HandleBar   $BB_Position]
            set HandleBar(file)         [checkFileString [rattleCAD::model::get_Component   HandleBar]]
            set HandleBar(pivotAngle)   [rattleCAD::model::get_Scalar HandleBar PivotAngle]
                # puts "  \$HandleBar(position)    $HandleBar(position)  " 
                # puts "  \$HandleBar(file)        $HandleBar(file)    "
                # puts "  \$HandleBar(pivotAngle)  $HandleBar(pivotAngle) "     
            set HandleBar(object)       [ $cv_Name readSVG $HandleBar(file) $HandleBar(position) $HandleBar(pivotAngle)  __HandleBar__ ]
                                          $cv_Name addtag  __Decoration__ withtag $HandleBar(object)
            if {$updateCommand != {}}   { 
                $cv_Name bind    $HandleBar(object)    <Double-ButtonPress-1> \
                                                [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   file://Component(HandleBar/File)    Component(HandleBar/PivotAngle) }   {HandleBar Parameter}   ]
                rattleCAD::view::gui::object_CursorBinding     $cv_Name    $HandleBar(object)
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_DerailleurRear {cv_Name BB_Position type {updateCommand {}}} {
                # --- create RearDerailleur --------
            set Derailleur(position)    [ rattleCAD::model::get_Position     Lugs/Dropout/Rear/Derailleur        $BB_Position]
            set Derailleur(file)        [ checkFileString [rattleCAD::model::get_Component  RearDerailleur ] ]
            set Derailleur(object)      [ $cv_Name readSVG $Derailleur(file) $Derailleur(position)  0  __DerailleurRear__ ]
                                        $cv_Name addtag  __Decoration__ withtag $Derailleur(object)
            if {$updateCommand != {}} { 
                $cv_Name bind    $Derailleur(object)    <Double-ButtonPress-1> \
                                                [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   file://Component(Derailleur/Rear/File)  }   {DerailleurRear Parameter}  ]
                rattleCAD::view::gui::object_CursorBinding     $cv_Name    $Derailleur(object)
            }
    }
    proc rattleCAD::rendering::createDecoration_DerailleurRear_ctr {cv_Name BB_Position type {updateCommand {}}} {
                # --- create RearDerailleur --------
            set Derailleur(position)   [ rattleCAD::model::get_Position     Lugs/Dropout/Rear/Derailleur          $BB_Position]
            foreach {x y} $Derailleur(position) break
            set x1    [expr $x + 15];        set x2    [expr $x - 15];     set y1    [expr $y + 15];     set y2    [expr $y - 15]
            $cv_Name create line  [list $x1 $y $x2 $y]   -fill gray60  -tags __Decoration__
            $cv_Name create line  [list $x $y1 $x $y2]   -fill gray60  -tags __Decoration__
                #
    }
    proc rattleCAD::rendering::createDecoration_DerailleurFront {cv_Name BB_Position type {updateCommand {}}} {
                # --- create FrontDerailleur --------
            set Derailleur(position)    [ rattleCAD::model::get_Position     DerailleurMountFront    $BB_Position]
            set angle                   [ vectormath::angle {0 1} {0 0} [ rattleCAD::model::get_Direction SeatTube ] ]
            set Derailleur(file)        [ checkFileString [rattleCAD::model::get_Component  FrontDerailleur] ]
            set Derailleur(object)      [ $cv_Name readSVG $Derailleur(file) $Derailleur(position)  $angle  __DerailleurFront__ ]
                                          $cv_Name addtag  __Decoration__ withtag $Derailleur(object)
            if {$updateCommand != {}}   { 
                $cv_Name bind    $Derailleur(object)    <Double-ButtonPress-1> \
                                                [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   file://Component(Derailleur/Front/File) Component(Derailleur/Front/Distance)    Component(Derailleur/Front/Offset)  }  {DerailleurFront Parameter} ]
                rattleCAD::view::gui::object_CursorBinding     $cv_Name    $Derailleur(object)
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_CrankSet {cv_Name BB_Position type {updateCommand {}}} {
                # --- create Crankset --------------
            set CrankSet(position)        $BB_Position
            set CrankSet(file)            [ checkFileString [rattleCAD::model::get_Component    CrankSet] ]
            set compString [file tail $CrankSet(file)]
            if {[file tail $CrankSet(file)] == {custom.svg}} {
                set CrankSet(object)        [ createCrank_Custom  $cv_Name  $CrankSet(position) ]
                                              $cv_Name addtag  __Decoration__ withtag $CrankSet(object)
                if {$updateCommand != {}}   { 
                    $cv_Name bind    $CrankSet(object)    <Double-ButtonPress-1> \
                                                        [list rattleCAD::view::createEdit  %x %y  $cv_Name{   file://Component(CrankSet/File)   Component(CrankSet/Length)  text://Component(CrankSet/ChainRings)   }   {Crankset:  Parameter}]
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $CrankSet(object)
                }
            } else {
                set CrankSet(object)        [ $cv_Name readSVG $CrankSet(file) $CrankSet(position)  0  __CrankSet__ ]
                                              $cv_Name addtag  __Decoration__ withtag $CrankSet(object)
                if {$updateCommand != {}}     { 
                    $cv_Name bind    $CrankSet(object)    <Double-ButtonPress-1> \
                                                        [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   file://Component(CrankSet/File) }   {CrankSet Parameter} ]
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $CrankSet(object)
                }
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_Chain {cv_Name BB_Position type {updateCommand {}}} {
                # --- create Chain -------------
            set Chain(object)           [ createChain  $cv_Name  $BB_Position]
                                      $cv_Name addtag  __Decoration__ withtag $Chain(object)
            if {$updateCommand != {}}   { 
                $cv_Name bind    $Chain(object)    <Double-ButtonPress-1> \
                                                [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   text://Component(CrankSet/ChainRings)   Component/Derailleur/Rear/Pulley/x   Component/Derailleur/Rear/Pulley/y   Component/Derailleur/Rear/Pulley/teeth }   {Chain Parameter} ]
                rattleCAD::view::gui::object_CursorBinding     $cv_Name    $Chain(object)
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_SeatPost {cv_Name BB_Position type {updateCommand {}}} {
                # --- create SeatPost ------------------
            set SeatPost(polygon)         [ rattleCAD::model::get_Polygon   SeatPost    $BB_Position ]
            set SeatPost(object)          [ $cv_Name create polygon $SeatPost(polygon) -fill white  -outline black  -tags __Decoration__ ]
            if {$updateCommand != {}}     { 
                    $cv_Name bind    $SeatPost(object)   <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  { Component(SeatPost/Diameter) }   {SeatPost Parameter} ]
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $SeatPost(object)
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_Brake {cv_Name BB_Position type {updateCommand {}}} {
                # --- get Rendering Style
			set Rendering(BrakeFront)       [rattleCAD::model::get_Option FrontBrake]
			set Rendering(BrakeRear)        [rattleCAD::model::get_Option RearBrake]
                # --- create RearBrake -----------------
            if {$Rendering(BrakeRear) != {off}} {
                  # puts "          ... \$Rendering(BrakeRear) $Rendering(BrakeRear)"
                switch $Rendering(BrakeRear) {
                    Rim {
                            set ss_direction            [ rattleCAD::model::get_Direction SeatStay ]
                            set ss_angle                [ expr - [ vectormath::angle {0 1} {0 0} $ss_direction ] ]
                            set RearBrake(position)     [ rattleCAD::model::get_Position        BrakeRear   $BB_Position]
                            set RearBrake(file)         [ checkFileString [ rattleCAD::model::get_Component RearBrake] ]
                            set RearBrake(object)       [ $cv_Name readSVG $RearBrake(file) $RearBrake(position) $ss_angle  __RearBrake__ ]
                                                          $cv_Name addtag  __Decoration__ withtag $RearBrake(object)
                            if {$updateCommand != {}}   { 
                                $cv_Name bind    $RearBrake(object)    <Double-ButtonPress-1> \
                                                                [list rattleCAD::view::createEdit  %x %y  $cv_Name  {  list://Rendering(Brake/Rear@SELECT_BrakeType)    file://Component(Brake/Rear/File)   Component(Brake/Rear/LeverLength)   Component(Brake/Rear/Offset)    }  {RearBrake Parameter} ]
                                rattleCAD::view::gui::object_CursorBinding     $cv_Name    $RearBrake(object)
                            }
                        }
                    default {}
                }
            }

                # --- create FrontBrake ----------------
            if {$Rendering(BrakeFront) != {off}} {
                  # puts "          ... \$Rendering(BrakeFront) $Rendering(BrakeFront)"
                switch $Rendering(BrakeFront) {
                    Rim {
                            set ht_direction    [ rattleCAD::model::get_Direction   HeadTube ]
                            set ht_angle        [ expr [ vectormath::angle {0 1} {0 0} $ht_direction ] ]
                            set fb_angle        [ rattleCAD::model::get_Scalar Fork BrakeAngle]
                            set fb_angle        [ expr $ht_angle + $fb_angle ]
                            set FrontBrake(position)    [ rattleCAD::model::get_Position    BrakeFront      $BB_Position ]
                            set FrontBrake(file)        [ checkFileString [rattleCAD::model::get_Component  FrontBrake] ]
                            set FrontBrake(object)      [ $cv_Name readSVG $FrontBrake(file) $FrontBrake(position) $fb_angle  __FrontBrake__ ]
                                                          $cv_Name addtag  __Decoration__ withtag $FrontBrake(object)
                            if {$updateCommand != {}}   { 
                                $cv_Name bind    $FrontBrake(object)    <Double-ButtonPress-1> \
                                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   list://Rendering(Brake/Front@SELECT_BrakeType)  file://Component(Brake/Front/File)  Component(Brake/Front/LeverLength)  Component(Brake/Front/Offset) }   {FrontBrake Parameter} ]
                                rattleCAD::view::gui::object_CursorBinding     $cv_Name    $FrontBrake(object)
                            }
                        }
                    default {}
                }
            }
    }
    proc rattleCAD::rendering::createDecoration_BottleCage {cv_Name BB_Position type {updateCommand {}}} {
                # 
            set Rendering(BottleCage_DT)    [rattleCAD::model::get_Option BottleCage_DT]
            set Rendering(BottleCage_DT_L)  [rattleCAD::model::get_Option BottleCage_DT_L]
            set Rendering(BottleCage_ST)    [rattleCAD::model::get_Option BottleCage_ST]
                # --- create BottleCage ----------------
            if {$Rendering(BottleCage_ST) != {off}} {
                    # puts "   ... \$Rendering(BottleCage_ST) $Rendering(BottleCage_ST)"
                switch $Rendering(BottleCage_ST) {
                    BrazeOn { set BottleCage(file)      [ file join $::APPL_Config(COMPONENT_Dir) bottle_cage/left/brazeOn.svg ] }
                    Cage    { set BottleCage(file)      [ file join $::APPL_Config(COMPONENT_Dir) bottle_cage/left/bottleCage.svg ] }
                    Bottle  { set BottleCage(file)      [ file join $::APPL_Config(COMPONENT_Dir) bottle_cage/left/bottle_Large.svg ] }
                }
                    # puts "   ... $Rendering(BottleCage_ST): BottleCage(file)  $BottleCage(file)"
                set st_direction    [ rattleCAD::model::get_Direction SeatTube ]
                set st_angle        [ expr 180 + [ vectormath::dirAngle {0 0} $st_direction ] ]
                set bc_position     [ rattleCAD::model::get_Position     SeatTube/BottleCage/Base    $BB_Position]
                
                set BottleCage(object)      [ $cv_Name readSVG $BottleCage(file) $bc_position $st_angle  __BottleCage_ST__ ]
                                              $cv_Name addtag  __Decoration__ withtag $BottleCage(object)
                if {$updateCommand != {}}   { 
                    $cv_Name bind    $BottleCage(object)    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   list://Rendering(BottleCage/SeatTube@SELECT_BottleCage) }   {BottleCage SeatTube Parameter} ]
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $BottleCage(object)
                }
            }

            if {$Rendering(BottleCage_DT) != {off}} {
                    # puts "   ... \$Rendering(BottleCage_DT) $Rendering(BottleCage_DT)"
                switch $Rendering(BottleCage_DT) {
                    BrazeOn { set BottleCage(file)      [ file join $::APPL_Config(COMPONENT_Dir) bottle_cage/right/brazeOn.svg ] }
                    Cage    { set BottleCage(file)      [ file join $::APPL_Config(COMPONENT_Dir) bottle_cage/right/bottleCage.svg ] }
                    Bottle  { set BottleCage(file)      [ file join $::APPL_Config(COMPONENT_Dir) bottle_cage/right/bottle_Large.svg ] }
                    default {
                              set BottleCage(file) {}
                              puts "\n      <W> \$Rendering(BottleCage_DT) $Rendering(BottleCage_DT)"
                            }
                }
                    # puts "   ... $Rendering(BottleCage_ST): BottleCage(file)  $BottleCage(file)"
                set dt_direction    [ rattleCAD::model::get_Direction DownTube ]
                set dt_angle        [ vectormath::dirAngle {0 0} $dt_direction ]
                set bc_position     [ rattleCAD::model::get_Position         DownTube/BottleCage/Base    $BB_Position]
                    #
                set BottleCage(object)      [ $cv_Name readSVG $BottleCage(file) $bc_position $dt_angle  __BottleCage_DT__ ]
                                              $cv_Name addtag  __Decoration__ withtag $BottleCage(object)
                if {$updateCommand != {}}   { 
                    $cv_Name bind $BottleCage(object)    <Double-ButtonPress-1> \
                                                        [list rattleCAD::view::createEdit  %x %y  $cv_Name  { list://Rendering(BottleCage/DownTube@SELECT_BottleCage) }   {BottleCage DownTube-Upper Parameter} ]
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $BottleCage(object)
                }
            }

            if {$Rendering(BottleCage_DT_L) != {off}} {
                    # puts "   ... \$Rendering(BottleCage_DT_L) $Rendering(BottleCage_DT_L)"
                switch $Rendering(BottleCage_DT_L) {
                    BrazeOn { set BottleCage(file)      [ file join $::APPL_Config(COMPONENT_Dir) bottle_cage/left/brazeOn.svg ] }
                    Cage    { set BottleCage(file)      [ file join $::APPL_Config(COMPONENT_Dir) bottle_cage/left/bottleCage.svg ] }
                    Bottle  { set BottleCage(file)      [ file join $::APPL_Config(COMPONENT_Dir) bottle_cage/left/bottle_Large.svg ] }
                }
                    # puts "   ... $Rendering(BottleCage_ST): BottleCage(file)  $BottleCage(file)"
                set dt_direction    [ rattleCAD::model::get_Direction   DownTube ]
                set dt_angle        [ expr 180 + [ vectormath::dirAngle {0 0} $dt_direction ] ]
                set bc_position     [ rattleCAD::model::get_Position     DownTube/BottleCage_Lower/Base    $BB_Position]
                
                set BottleCage(object)      [ $cv_Name readSVG $BottleCage(file) $bc_position $dt_angle  __BottleCage_DT_L__ ]
                                              $cv_Name addtag  __Decoration__ withtag $BottleCage(object)
                if {$updateCommand != {}}   { 
                    $cv_Name bind    $BottleCage(object)    <Double-ButtonPress-1> \
                                                        [list rattleCAD::view::createEdit  %x %y  $cv_Name  { list://Rendering(BottleCage/DownTube_Lower@SELECT_BottleCage) }   {BottleCage DownTube-Lower Parameter} ]
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $BottleCage(object)
                }
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_Saddle {cv_Name BB_Position type {updateCommand {}}} {
                # --- create Saddle --------------------
            set Saddle(position)        [ rattleCAD::model::get_Position     Saddle        $BB_Position ]
            set Saddle(file)            [ checkFileString [rattleCAD::model::get_Component  Saddle] ]
            set SaddlePosition          [ vectormath::addVector $Saddle(position) [list [rattleCAD::model::get_Scalar Saddle Offset_X] [rattleCAD::model::get_Scalar Saddle Offset_Y] ] ]
            set Saddle(object)          [ $cv_Name readSVG $Saddle(file) $SaddlePosition   0  __Saddle__ ]
                                          $cv_Name addtag  __Decoration__ withtag $Saddle(object)
            if {$updateCommand != {}}   { 
                $cv_Name bind $Saddle(object)    <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   file://Component(Saddle/File)  Component(Saddle/LengthNose)    Rendering(Saddle/Offset_X)    Rendering(Saddle/Offset_Y)    Result(Length/Saddle/Offset_BB_Nose) }   {Saddle Parameter} ]
                rattleCAD::view::gui::object_CursorBinding     $cv_Name    $Saddle(object)
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_HeadSet {cv_Name BB_Position type {updateCommand {}}} {
                # --- create HeadSet --------------------
            set HeadSet(polygon)        [ rattleCAD::model::get_Polygon     HeadSet/Top         $BB_Position  ]
            set HeadSet(object)         [ $cv_Name create polygon $HeadSet(polygon) -fill white -outline black  -tags __Decoration__ ]
            if {$updateCommand != {}}   { 
                $cv_Name bind $HeadSet(object)    <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   Component(HeadSet/Height/Top)  Component(HeadSet/Diameter) }  {HeadSet Parameter} ]
                rattleCAD::view::gui::object_CursorBinding     $cv_Name    $HeadSet(object)
            }
                #
            set HeadSet(polygon)        [ rattleCAD::model::get_Polygon     HeadSet/Bottom      $BB_Position ]
            set HeadSet(object)         [ $cv_Name create polygon $HeadSet(polygon) -fill white -outline black  -tags __Decoration__ ]
            if {$updateCommand != {}}   { 
                $cv_Name bind $HeadSet(object)    <Double-ButtonPress-1> \
                                                [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   Component(HeadSet/Height/Bottom)   Component(HeadSet/Diameter) }  {HeadSet Parameter} ]
                rattleCAD::view::gui::object_CursorBinding     $cv_Name    $HeadSet(object)
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_Stem {cv_Name BB_Position type {updateCommand {}}} {
                # --- create SeatPost ------------------
            set Stem(polygon)           [ rattleCAD::model::get_Polygon     Stem                $BB_Position  ]
            set Stem(object)            [ $cv_Name create polygon $Stem(polygon) -fill white  -outline black  -tags __Decoration__ ]
                #
    }
    proc rattleCAD::rendering::createDecoration_Logo {cv_Name BB_Position type {updateCommand {}}} {
                # --- create Logo --------------------
            set DownTube(Steerer)       [ rattleCAD::model::get_Position           DownTube/End        $BB_Position ]
            set DownTube(BBracket)      [ rattleCAD::model::get_Position           DownTube/Start      $BB_Position ]

            set Logo(Angle)             [ rattleCAD::model::get_Direction DownTube degree]
            set Logo(Direction)         [ rattleCAD::model::get_Direction DownTube ]
            set Logo(position)          [ vectormath::addVector [ vectormath::center $DownTube(BBracket) $DownTube(Steerer) ] $Logo(Direction) -90]
            set Logo(file)              [ checkFileString [rattleCAD::model::get_Component  Logo] ]
            set Logo(object)            [ $cv_Name readSVG $Logo(file) $Logo(position)    $Logo(Angle)  __Logo__ ]
                                          $cv_Name addtag  __Decoration__ withtag $Logo(object)
            if {$updateCommand != {}}   { 
                $cv_Name bind $Logo(object)     <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  { file://Component(Logo/File) }   {Logo Parameter} ]
                rattleCAD::view::gui::object_CursorBinding     $cv_Name    $Logo(object)
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_Fender {cv_Name BB_Position type {updateCommand {}}} {
                #
            set Rendering(Fender_Front)     [rattleCAD::model::get_Option FrontFender]
            set Rendering(Fender_Rear)      [rattleCAD::model::get_Option RearFender]                
                # --- create Fender ------------------
            if {$Rendering(Fender_Rear) != {off}} { # --- create RearWheel Fender ----------
                set Hub(position)         [ rattleCAD::model::get_Position      RearWheel       $BB_Position ]
                set RearFender(polygon)   [ rattleCAD::model::get_Polygon       Fender/Rear     $Hub(position)]
                set RearFender(object)    [ $cv_Name create polygon $RearFender(polygon) -fill white  -outline black  -tags __Fender__ ]
                                            $cv_Name addtag  __Decoration__ withtag $RearFender(object)
                
                if {$updateCommand != {}} {
                    $cv_Name bind $RearFender(object) <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  { list://Rendering(Fender/Rear@SELECT_Binary_OnOff) Component(Fender/Rear/Radius)   Component(Fender/Rear/Height)   Component(Fender/Rear/OffsetAngle)  }     {FrontFender Parameter} ]
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $RearFender(object)
                }
            }
        
            if {$Rendering(Fender_Front) != {off}} { # --- create FrontWheel Fender ----------
                set Hub(position)         [ rattleCAD::model::get_Position      FrontWheel      $BB_Position]
                set FrontFender(polygon)  [ rattleCAD::model::get_Polygon       Fender/Front    $Hub(position)]
                set FrontFender(object)   [ $cv_Name create polygon $FrontFender(polygon) -fill white  -outline black  -tags __Fender__ ]
                                            $cv_Name addtag  __Decoration__ withtag $FrontFender(object)
                
                if {$updateCommand != {}} { 
                    $cv_Name bind    $FrontFender(object)    <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  { list://Rendering(Fender/Front@SELECT_Binary_OnOff)    Component(Fender/Front/Radius)  Component(Fender/Front/Height)  Component(Fender/Front/OffsetAngleFront)    Component(Fender/Front/OffsetAngle)}   {FrontWheel Parameter} ]
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $FrontFender(object)
                }
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_Fender_Rep {cv_Name BB_Position type {updateCommand {}}} {
                #
            set Rendering(Fender_Front)     [rattleCAD::model::get_Option FrontFender]
            set Rendering(Fender_Rear)      [rattleCAD::model::get_Option RearFender]
                # --- create Fender Representaton ----
            if {$Rendering(Fender_Rear) != {off}} { # --- create RearWheel Fender ----------
                set Hub(position)     [rattleCAD::model::get_Position       RearWheel        $BB_Position]
                set RimDiameter       [rattleCAD::model::get_Scalar         RearWheel RimDiameter]
                set TyreHeight        [rattleCAD::model::get_Scalar         RearWheel TyreHeight]
                set FenderRadius      [expr 0.5 * $RimDiameter + $TyreHeight + 10]
                set AngleStart        [expr -360 - [rattleCAD::model::get_Direction ChainStay degree]]
                set AngleFender       [expr   90 - $AngleStart ]
                set my_Fender         [$cv_Name create arc   $Hub(position)  -radius $FenderRadius -start $AngleStart  -extent $AngleFender -style arc -outline gray40  -tags __Decoration__]
                if {$updateCommand != {}} {
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $my_Fender  option_RearFenderBinary
                    # $cv_Name bind    $my_Fender    <Double-ButtonPress-1> [list rattleCAD::view::createEdit  %x %y  $cv_Name  { list://Rendering(Fender/Front@SELECT_Binary_OnOff) }  {FrontWheel Parameter} ]
                    # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $my_Fender
                }
            }
                #
            if {$Rendering(Fender_Front) != {off}} { # --- create FrontWheel Fender ----------
                set Hub(position)         [rattleCAD::model::get_Position             FrontWheel    $BB_Position]
                set RimDiameter           [rattleCAD::model::get_Scalar FrontWheel RimDiameter]
                set TyreHeight            [rattleCAD::model::get_Scalar FrontWheel TyreHeight]
                set FenderRadius          [expr 0.5 * $RimDiameter + $TyreHeight + 10]
                set AngleStart            100
                set AngleFender            95
                set my_Fender             [$cv_Name create arc   $Hub(position)  -radius $FenderRadius -start $AngleStart  -extent $AngleFender -style arc -outline gray40  -tags __Decoration__]
                if {$updateCommand != {}} {$cv_Name bind    $my_Fender    <Double-ButtonPress-1> \
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $my_Fender  option_FrontFenderBinary
                    # [list rattleCAD::view::createEdit  %x %y  $cv_Name  { list://Rendering(Fender/Front@SELECT_Binary_OnOff)   }   {FrontWheel Parameter}                                                                     ]
                    # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $my_Fender
                }
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_CarrierFront {cv_Name BB_Position type {updateCommand {}}} {
                # --- create CarrierFront --------
            set CarrierFront(position)  [rattleCAD::model::get_Position       CarrierMountFront    $BB_Position]
            set CarrierFront(file)      [ checkFileString [rattleCAD::model::get_Component  FrontCarrier] ]
            set CarrierFront(object)    [ $cv_Name readSVG $CarrierFront(file) $CarrierFront(position)  0  __CarrierFront__ ]
                                          $cv_Name addtag  __Decoration__ withtag $CarrierFront(object)
            if {$updateCommand != {}}   { 
                    $cv_Name bind    $CarrierFront(object)    <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   file://Component(Carrier/Front/File)    Component(Carrier/Front/x)  Component(Carrier/Front/y)  }  {CarrierFront Parameter} ]
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $CarrierFront(object)
            }
                #
    }  
    proc rattleCAD::rendering::createDecoration_CarrierRear {cv_Name BB_Position type {updateCommand {}}} {
                # --- create CarrierRear --------
            set CarrierRear(position)   [ rattleCAD::model::get_Position       CarrierMountRear    $BB_Position]
            set CarrierRear(file)       [ checkFileString [rattleCAD::model::get_Component  RearCarrier] ]
            set CarrierRear(object)     [ $cv_Name readSVG $CarrierRear(file) $CarrierRear(position)  0  __CarrierRear__ ]
                                          $cv_Name addtag  __Decoration__ withtag $CarrierRear(object)
            if {$updateCommand != {}}   { 
                    $cv_Name bind    $CarrierRear(object)    <Double-ButtonPress-1> \
                                                [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   file://Component(Carrier/Rear/File) Component(Carrier/Rear/x)   Component(Carrier/Rear/y)   }  {CarrierRear Parameter}  ]
                    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $CarrierRear(object)
            }
                #
    }  
    proc rattleCAD::rendering::createDecoration_RearWheel {cv_Name BB_Position type {updateCommand {}}} {
                # --- create RearWheel -----------------
            set Hub(position)       [ rattleCAD::model::get_Position             RearWheel        $BB_Position]
            set RimDiameter             [ rattleCAD::model::get_Scalar RearWheel RimDiameter ]
            set RimHeight               [ rattleCAD::model::get_Scalar RearWheel RimHeight   ]
            set TyreHeight              [ rattleCAD::model::get_Scalar RearWheel TyreHeight  ]
                                            $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter + $TyreHeight]     -tags {__Decoration__ __Tyre__}     -fill white
                                            $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter + 5]               -tags {__Decoration__ __Rim_01__}   -fill white
            set my_Rim                  [   $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter - 4]               -tags {__Decoration__ __Rim_02__}   -fill white ]
                                            $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter - $RimHeight + 5]  -tags {__Decoration__ __Rim_03__}   -fill white
                                            $cv_Name create circle  $Hub(position)  -radius 45                                          -tags {__Decoration__ __Hub__}      -fill white
                                        $cv_Name create circle  $Hub(position)  -radius 23                                          -tags {__Decoration__}              -fill white
            if {$updateCommand != {}}   { 
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $my_Rim     single_RearWheel_RimHeight
                    # $cv_Name bind $my_Rim <Double-ButtonPress-1> [list rattleCAD::view::createEdit  %x %y  $cv_Name  { Component(Wheel/Rear/RimHeight) }     {RearWheel Parameter} ]
                    # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $my_Rim
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_FrontWheel {cv_Name BB_Position type {updateCommand {}}} {
                # --- create FrontWheel ----------------
            set Hub(position)       [ rattleCAD::model::get_Position            FrontWheel  $BB_Position ]
            set RimDiameter         [ rattleCAD::model::get_Scalar              FrontWheel  RimDiameter ]
            set RimHeight           [ rattleCAD::model::get_Scalar              FrontWheel  RimHeight ]
            set TyreHeight          [ rattleCAD::model::get_Scalar              FrontWheel  TyreHeight ]
                                            $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter + $TyreHeight]     -tags {__Decoration__ __Tyre__}     -fill white
                                            $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter + 5]               -tags {__Decoration__ __Rim_01__}   -fill white
            set my_Rim                  [   $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter - 4]               -tags {__Decoration__ __Rim_02__}   -fill white ]
                                            $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter - $RimHeight + 5]  -tags {__Decoration__ __Rim_03__}   -fill white
                                            $cv_Name create circle  $Hub(position)  -radius 20                                          -tags {__Decoration__ __Hub__}      -fill white
                                            $cv_Name create circle  $Hub(position)  -radius 4.5                                         -tags {__Decoration__}              -fill white
            if {$updateCommand != {}}   { 
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $my_Rim     single_FrontWheel_RimHeight    
                    # $cv_Name bind    $my_Rim    <Double-ButtonPress-1>     [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   Component(Wheel/Front/RimHeight) }     {FrontWheel Parameter}]
                    # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $my_Rim
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_RearWheel_Rep    {cv_Name BB_Position type {updateCommand {}}} {
                #
            set Hub(position)       [ rattleCAD::model::get_Position    RearWheel   $BB_Position ]
            set RimDiameter         [ rattleCAD::model::get_Scalar      RearWheel   RimDiameter ]
            set RimHeight           [ rattleCAD::model::get_Scalar      RearWheel   RimHeight ]
            set TyreHeight          [ rattleCAD::model::get_Scalar      RearWheel   TyreHeight ]
            set my_Wheel            [ $cv_Name create arc   $Hub(position)  -radius [expr 0.5 * $RimDiameter + $TyreHeight] -start -20  -extent 105 -style arc -outline gray60  -tags __Decoration__]
            set my_Wheel            [ $cv_Name create arc   $Hub(position)  -radius [expr 0.5 * $RimDiameter ]              -start -25  -extent 100 -style arc -outline gray60  -tags __Decoration__  -width 0.35]
                #
    }
    proc rattleCAD::rendering::createDecoration_FrontWheel_Rep    {cv_Name BB_Position type {updateCommand {}}} {
                #
            set Hub(position)       [ rattleCAD::model::get_Position    FrontWheel  $BB_Position ]
            set RimDiameter         [ rattleCAD::model::get_Scalar      FrontWheel  RimDiameter]
            set RimHeight           [ rattleCAD::model::get_Scalar      FrontWheel  RimHeight]
            set TyreHeight          [ rattleCAD::model::get_Scalar      FrontWheel  TyreHeight]
            set my_Wheel            [ $cv_Name create arc   $Hub(position)  -radius [expr 0.5 * $RimDiameter + $TyreHeight] -start  95  -extent  85 -style arc -outline gray60 -tags __Decoration__]
            set my_Wheel            [ $cv_Name create arc   $Hub(position)  -radius [expr 0.5 * $RimDiameter ]              -start  90  -extent  80 -style arc -outline gray60  -tags __Decoration__  -width 0.35  ]
    }
    proc rattleCAD::rendering::createDecoration_RearWheel_Pos {cv_Name BB_Position type {updateCommand {}}} {
                # 
            set Hub(position)       [ rattleCAD::model::get_Position             RearWheel  $BB_Position ]
            foreach {x y} $Hub(position) break
            set x1    [expr $x + 15];        set x2    [expr $x - 15];     set y1    [expr $y + 15];     set y2    [expr $y - 15]
            $cv_Name create line  [list $x1 $y $x2 $y]   -fill darkred  -tags __Decoration__
            $cv_Name create line  [list $x $y1 $x $y2]   -fill darkred  -tags __Decoration__
                #
    }
    proc rattleCAD::rendering::createDecoration_LegClearance_Rep {cv_Name BB_Position type {updateCommand {}}} {
                #
            set LegClearance(position)  [ rattleCAD::model::get_Position    LegClearance  $BB_Position ]
            $cv_Name create circle      $LegClearance(position)  -radius 5  -outline grey60 -tags __Decoration__
                #
    }

