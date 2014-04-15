 ##+##########################################################################
 #
 # package: rattleCAD   ->  lib_bikeRendering.tcl
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
 #  namespace:  rattleCAD::rendering
 # ---------------------------------------------------------------------------
 #
 #

 namespace eval rattleCAD::rendering {


    # --- check existance of File --- regarding on user/etc
    proc checkFileString {fileString} {
        switch -glob $fileString {
                user:*  {   set svgFile [file join $::APPL_Config(USER_Dir)/components   [lindex [split $fileString :] 1] ]}
                etc:*   {   set svgFile [file join $::APPL_Config(CONFIG_Dir)/components [lindex [split $fileString :] 1] ]}
                default {   set svgFile [file join $::APPL_Config(CONFIG_Dir)/components $fileString ]}
            }
			
            #
		  # puts "            ... rattleCAD::rendering::checkFileString: $fileString"
		  # puts "                        ... $svgFile"
		    #
        if {![file exists $svgFile]} {
                    # puts "           ... does not exist, therfore .."
                set svgFile [file join $::APPL_Config(CONFIG_Dir)/components default_exception.svg]
        }
            # puts "            ... createDecoration::checkFileString $svgFile"
        return $svgFile
    }


    proc createBaseline {cv_Name BB_Position {colour {gray}}} {

                # --- get distance to Ground
              # set BB_Ground(position) [ vectormath::addVector $bikeGeometry::BottomBracket(Ground)  $BB_Position ]
              # puts "   -> \$BB_Ground(position) $BB_Ground(position)"
		      # puts "   -> rattleCAD::control::getValue BottomBracket/Ground   -> [rattleCAD::control::getValue BottomBracket/Ground]"
		    set BB_Ground(position) [ vectormath::addVector [rattleCAD::control::getValue Runtime/BottomBracket/Ground]  $BB_Position ]
              # puts "   -> \$BB_Ground(position) $BB_Ground(position)"
			  # exit
		    
            set RimDiameter_Front       $bikeGeometry::FrontWheel(RimDiameter)
            set RimDiameter_Rear        $bikeGeometry::RearWheel(RimDiameter)

            set FrontWheel(position)    [ bikeGeometry::get_Object     FrontWheel  position    $BB_Position]
            set RearWheel(position)     [ bikeGeometry::get_Object     RearWheel   position    $BB_Position  ]
                # puts "   ... \$RearWheel(position)  $RearWheel(position)"


                # --- get RearWheel
            foreach {x y} $RearWheel(position) break
            set Rear(xy)                [ list [expr $x - 0.8 * 0.5 * $RimDiameter_Rear ] [lindex $BB_Ground(position) 1] ]

                # --- get FrontWheel
            foreach {x y} $FrontWheel(position) break
            set Front(xy)                [ list [expr $x + 0.8 * 0.5 * $RimDiameter_Front ] [lindex $BB_Ground(position) 1] ]


                # --- create line
            $cv_Name create line    [ list  [ lindex $Rear(xy)   0 ] [ lindex $Rear(xy)   1 ] [ lindex $Front(xy)   0 ] [ lindex $Front(xy)   1 ] ]  -fill $colour -tags {__CenterLine__ baseLine}
            $cv_Name create circle  $BB_Position  -radius 10  -outline $colour
    }


    proc createDecoration {cv_Name BB_Position type {updateCommand {}}} {

                # --- get stageScale
            set stageScale     [ $cv_Name  getNodeAttr  Stage    scale ]

                # --- get Rendering Style
                # set Rendering(BrakeFront)       [rattleCAD::control::getValue Rendering/Brake/Front]
                # puts "    -> $Rendering(BrakeFront)"
			set Rendering(BrakeFront)       [rattleCAD::control::getValue Rendering/Brake/Front]
                # puts "    -> $Rendering(BrakeFront)"
			    # puts "\n\n\n---------------------------"
			set Rendering(BrakeRear)        [rattleCAD::control::getValue Rendering/Brake/Rear]
            set Rendering(BottleCage_ST)    [rattleCAD::control::getValue Rendering/BottleCage/SeatTube]
            set Rendering(BottleCage_DT)    [rattleCAD::control::getValue Rendering/BottleCage/DownTube]
            set Rendering(BottleCage_DT_L)  [rattleCAD::control::getValue Rendering/BottleCage/DownTube_Lower]


            switch $type {
                    HandleBar {
                                # --- create Handlebar -------------
                            set HandleBar(position)     [ bikeGeometry::get_Object  HandleBar  position    $BB_Position]
                            set HandleBar(file)         [ checkFileString [rattleCAD::control::getValue Component/HandleBar/File]]
                            set HandleBar(pivotAngle)   [rattleCAD::control::getValue Component/HandleBar/PivotAngle]
                            set HandleBar(object)       [ $cv_Name readSVG $HandleBar(file) $HandleBar(position) $HandleBar(pivotAngle)  __HandleBar__ ]
                                                          $cv_Name addtag  __Decoration__ withtag $HandleBar(object)
                            if {$updateCommand != {}}   { $cv_Name bind    $HandleBar(object)    <Double-ButtonPress-1> \
                                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name \
                                                                                    {   file://Component(HandleBar/File) \
                                                                                        Component(HandleBar/PivotAngle) \
                                                                                    }   {HandleBar Parameter} \
                                                                    ]
                                                          rattleCAD::view::gui::object_CursorBinding     $cv_Name    $HandleBar(object)
                                    }
                            }
                    DerailleurRear {
                                # --- create RearDerailleur --------
                            set Derailleur(position)    [ bikeGeometry::get_Object  Lugs/Dropout/Rear/Derailleur  position        $BB_Position]
                            set Derailleur(file)        [ checkFileString [rattleCAD::control::getValue Component/Derailleur/Rear/File] ]
                            set Derailleur(object)      [ $cv_Name readSVG $Derailleur(file) $Derailleur(position)  0  __DerailleurRear__ ]
                                                        $cv_Name addtag  __Decoration__ withtag $Derailleur(object)
                            if {$updateCommand != {}} { $cv_Name bind    $Derailleur(object)    <Double-ButtonPress-1> \
                                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                    {   file://Component(Derailleur/Rear/File)    \
                                                                                    }   {DerailleurRear Parameter} \
                                                                    ]
                                                          rattleCAD::view::gui::object_CursorBinding     $cv_Name    $Derailleur(object)
                                    }
                            }
                    DerailleurRear_ctr {
                                # --- create RearDerailleur --------
                            set Derailleur(position)    [ bikeGeometry::get_Object  Lugs/Dropout/Rear/Derailleur  position          $BB_Position]
                            foreach {x y} $Derailleur(position) break
                            set x1    [expr $x + 15];        set x2    [expr $x - 15];     set y1    [expr $y + 15];     set y2    [expr $y - 15]
                            $cv_Name create line  [list $x1 $y $x2 $y]   -fill gray60  -tags __Decoration__
                            $cv_Name create line  [list $x $y1 $x $y2]   -fill gray60  -tags __Decoration__
                            }
                    DerailleurFront {
                                # --- create FrontDerailleur --------
                            set Derailleur(position)    [ bikeGeometry::get_Object  DerailleurMountFront  position    $BB_Position]
                            set angle                   [ vectormath::angle {0 1} {0 0} [ bikeGeometry::get_Object SeatTube direction ] ]
                            set Derailleur(file)        [ checkFileString [rattleCAD::control::getValue Component/Derailleur/Front/File] ]
                            set Derailleur(object)      [ $cv_Name readSVG $Derailleur(file) $Derailleur(position)  $angle  __DerailleurFront__ ]
                                                          $cv_Name addtag  __Decoration__ withtag $Derailleur(object)
                            if {$updateCommand != {}}   { $cv_Name bind    $Derailleur(object)    <Double-ButtonPress-1> \
                                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                    {   file://Component(Derailleur/Front/File)    \
                                                                                        Component(Derailleur/Front/Distance) \
                                                                                        Component(Derailleur/Front/Offset) \
                                                                                    }  {DerailleurFront Parameter} \
                                                                    ]
                                                          rattleCAD::view::gui::object_CursorBinding     $cv_Name    $Derailleur(object)
                                    }
                            }
                    CrankSet {
                                # --- create Crankset --------------
                            set CrankSet(position)        $BB_Position
                            set CrankSet(file)            [ checkFileString [rattleCAD::control::getValue Component/CrankSet/File] ]
                                # puts "\n  -> \$CrankSet(position) $CrankSet(position)\n"
                                # puts "\n  -> \$CrankSet(file) $CrankSet(file)\n"
                            set compString [file tail $CrankSet(file)]
                            if {[file tail $CrankSet(file)] == {custom.svg}} {
                                    set CrankSet(object)        [ createCrank_Custom  $cv_Name  $CrankSet(position) ]
                                                                  $cv_Name addtag  __Decoration__ withtag $CrankSet(object)
                                    if {$updateCommand != {}}   { $cv_Name bind    $CrankSet(object)    <Double-ButtonPress-1> \
                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                            {   file://Component(CrankSet/File) \
                                                                                                Component(CrankSet/Length) \
                                                                                                text://Component(CrankSet/ChainRings)
                                                                                            }   {Crankset:  Parameter}
                                                                            ]
                                                                  rattleCAD::view::gui::object_CursorBinding     $cv_Name    $CrankSet(object)
                                        }
                                } else {
                                    set CrankSet(object)        [ $cv_Name readSVG $CrankSet(file) $CrankSet(position)  0  __CrankSet__ ]
                                                                  $cv_Name addtag  __Decoration__ withtag $CrankSet(object)
                                    if {$updateCommand != {}}     { $cv_Name bind    $CrankSet(object)    <Double-ButtonPress-1> \
                                                                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                            {   file://Component(CrankSet/File) \
                                                                                            }   {CrankSet Parameter} \
                                                                            ]
                                                                  rattleCAD::view::gui::object_CursorBinding     $cv_Name    $CrankSet(object)
                                        }
                                }
                            }
                    Chain {
                                # --- create Chain -------------
                            set Chain(object)           [ createChain  $cv_Name  $BB_Position]
                                                          $cv_Name addtag  __Decoration__ withtag $Chain(object)
                            if {$updateCommand != {}}   { $cv_Name bind    $Chain(object)    <Double-ButtonPress-1> \
                                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name \
                                                                                    {   text://Component(CrankSet/ChainRings) \
                                                                                        Component/Derailleur/Rear/Pulley/x \
                                                                                        Component/Derailleur/Rear/Pulley/y \
                                                                                        Component/Derailleur/Rear/Pulley/teeth \
                                                                                    }   {Chain Parameter} \
                                                                    ]
                                                          rattleCAD::view::gui::object_CursorBinding     $cv_Name    $Chain(object)
                                    }
                            }

                    
                    SeatPost {
                                # --- create SeatPost ------------------
                            set SeatPost(polygon)         [ bikeGeometry::get_Object SeatPost polygon $BB_Position ]
                            set SeatPost(object)          [ $cv_Name create polygon $SeatPost(polygon) -fill white  -outline black  -tags __Decoration__ ]
                            if {$updateCommand != {}}     { $cv_Name bind    $SeatPost(object)   <Double-ButtonPress-1> \
                                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                    {   Component(SeatPost/Diameter)    \
                                                                                    }   {SeatPost Parameter} \
                                                                    ]
                                                          rattleCAD::view::gui::object_CursorBinding     $cv_Name    $SeatPost(object)
                                    }
                            }

                    Brake {
                                # --- create RearBrake -----------------
                                if {$Rendering(BrakeRear) != {off}} {
                                      # puts "          ... \$Rendering(BrakeRear) $Rendering(BrakeRear)"
                                    switch $Rendering(BrakeRear) {
                                        Rim {
                                            set ss_direction    [ bikeGeometry::get_Object SeatStay direction ]
                                            set ss_angle        [ expr - [ vectormath::angle {0 1} {0 0} $ss_direction ] ]
                                            set RearBrake(position) [ bikeGeometry::get_Object  BrakeRear  position    $BB_Position]
                                            set RearBrake(file)         [ checkFileString [rattleCAD::control::getValue Component/Brake/Rear/File] ]
                                            set RearBrake(object)       [ $cv_Name readSVG $RearBrake(file) $RearBrake(position) $ss_angle  __RearBrake__ ]
                                                                          $cv_Name addtag  __Decoration__ withtag $RearBrake(object)
                                            if {$updateCommand != {}}   { $cv_Name bind    $RearBrake(object)    <Double-ButtonPress-1> \
                                                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                                    {  list://Rendering(Brake/Rear@SELECT_BrakeType) \
                                                                                                        file://Component(Brake/Rear/File)    \
                                                                                                        Component(Brake/Rear/LeverLength)    \
                                                                                                        Component(Brake/Rear/Offset)    \
                                                                                                    }  {RearBrake Parameter} \
                                                                                    ]
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
                                            set ht_direction    [ bikeGeometry::get_Object HeadTube direction ]
                                            set ht_angle        [ expr [ vectormath::angle {0 1} {0 0} $ht_direction ] ]
                                            set fb_angle        [rattleCAD::control::getValue Component/Fork/Crown/Brake/Angle]
                                            set fb_angle        [ expr $ht_angle + $fb_angle ]
                                            set FrontBrake(position)    [ bikeGeometry::get_Object  BrakeFront  position    $BB_Position]
                                            set FrontBrake(file)        [ checkFileString [rattleCAD::control::getValue Component/Brake/Front/File] ]
                                            set FrontBrake(object)      [ $cv_Name readSVG $FrontBrake(file) $FrontBrake(position) $fb_angle  __FrontBrake__ ]
                                                                          $cv_Name addtag  __Decoration__ withtag $FrontBrake(object)
                                            if {$updateCommand != {}}   { $cv_Name bind    $FrontBrake(object)    <Double-ButtonPress-1> \
                                                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                                    {   list://Rendering(Brake/Front@SELECT_BrakeType) \
                                                                                                        file://Component(Brake/Front/File)    \
                                                                                                        Component(Brake/Front/LeverLength)    \
                                                                                                        Component(Brake/Front/Offset)    \
                                                                                                    }   {FrontBrake Parameter} \
                                                                                    ]
                                                                          rattleCAD::view::gui::object_CursorBinding     $cv_Name    $FrontBrake(object)
                                                    }
                                            }
                                        default {}
                                    }
                                }
                            }

                    BottleCage {
                                # --- create FrontBrake ----------------
                                if {$Rendering(BottleCage_ST) != {off}} {
                                                # puts "   ... \$Rendering(BottleCage_ST) $Rendering(BottleCage_ST)"
                                            switch $Rendering(BottleCage_ST) {
                                                BrazeOn { set BottleCage(file)      [ file join $::APPL_Config(CONFIG_Dir) components/bottle_cage/left/brazeOn.svg ] }
                                                Cage    { set BottleCage(file)      [ file join $::APPL_Config(CONFIG_Dir) components/bottle_cage/left/bottleCage.svg ] }
                                                Bottle  { set BottleCage(file)      [ file join $::APPL_Config(CONFIG_Dir) components/bottle_cage/left/bottle_Large.svg ] }
                                            }
                                                # puts "   ... $Rendering(BottleCage_ST): BottleCage(file)  $BottleCage(file)"
                                            set st_direction    [ bikeGeometry::get_Object SeatTube direction ]
                                            set st_angle        [ expr 180 + [ vectormath::dirAngle {0 0} $st_direction ] ]
                                            set bc_position     [ bikeGeometry::get_Object    SeatTube/BottleCage/Base    position    $BB_Position]

                                                # set BottleCage(file)        [ checkFileString [rattleCAD::control::getValue Component/BottleCage/SeatTube/File ]  asText ] ]
                                            set BottleCage(object)      [ $cv_Name readSVG $BottleCage(file) $bc_position $st_angle  __BottleCage_ST__ ]
                                                                          $cv_Name addtag  __Decoration__ withtag $BottleCage(object)
                                            if {$updateCommand != {}}   { $cv_Name bind    $BottleCage(object)    <Double-ButtonPress-1> \
                                                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                                    {   list://Rendering(BottleCage/SeatTube@SELECT_BottleCage) \
                                                                                                    }   {BottleCage SeatTube Parameter} \
                                                                                    ]
                                                                          rattleCAD::view::gui::object_CursorBinding     $cv_Name    $BottleCage(object)
                                            }
                                }

                                if {$Rendering(BottleCage_DT) != {off}} {
                                                # puts "   ... \$Rendering(BottleCage_DT) $Rendering(BottleCage_DT)"
                                            switch $Rendering(BottleCage_DT) {
                                                BrazeOn { set BottleCage(file)      [ file join $::APPL_Config(CONFIG_Dir) components/bottle_cage/right/brazeOn.svg ] }
                                                Cage    { set BottleCage(file)      [ file join $::APPL_Config(CONFIG_Dir) components/bottle_cage/right/bottleCage.svg ] }
                                                Bottle  { set BottleCage(file)      [ file join $::APPL_Config(CONFIG_Dir) components/bottle_cage/right/bottle_Large.svg ] }
                                            }
                                                # puts "   ... $Rendering(BottleCage_ST): BottleCage(file)  $BottleCage(file)"
                                            set dt_direction    [ bikeGeometry::get_Object DownTube direction ]
                                            set dt_angle        [ vectormath::dirAngle {0 0} $dt_direction ]
                                            set bc_position     [ bikeGeometry::get_Object    DownTube/BottleCage/Base    position    $BB_Position]

                                            set BottleCage(object)      [ $cv_Name readSVG $BottleCage(file) $bc_position $dt_angle  __BottleCage_DT__ ]
                                                                          $cv_Name addtag  __Decoration__ withtag $BottleCage(object)
                                            if {$updateCommand != {}}   { $cv_Name bind $BottleCage(object)    <Double-ButtonPress-1> \
                                                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                                    {   list://Rendering(BottleCage/DownTube@SELECT_BottleCage) \
                                                                                                    }   {BottleCage DownTube-Upper Parameter} \
                                                                                    ]
                                                                          rattleCAD::view::gui::object_CursorBinding     $cv_Name    $BottleCage(object)
                                            }
                                }

                                if {$Rendering(BottleCage_DT_L) != {off}} {
                                                # puts "   ... \$Rendering(BottleCage_DT_L) $Rendering(BottleCage_DT_L)"
                                            switch $Rendering(BottleCage_DT_L) {
                                                BrazeOn { set BottleCage(file)      [ file join $::APPL_Config(CONFIG_Dir) components/bottle_cage/left/brazeOn.svg ] }
                                                Cage    { set BottleCage(file)      [ file join $::APPL_Config(CONFIG_Dir) components/bottle_cage/left/bottleCage.svg ] }
                                                Bottle  { set BottleCage(file)      [ file join $::APPL_Config(CONFIG_Dir) components/bottle_cage/left/bottle_Large.svg ] }
                                            }
                                                # puts "   ... $Rendering(BottleCage_ST): BottleCage(file)  $BottleCage(file)"
                                            set dt_direction    [ bikeGeometry::get_Object DownTube direction ]
                                            set dt_angle        [ expr 180 + [ vectormath::dirAngle {0 0} $dt_direction ] ]
                                            set bc_position     [ bikeGeometry::get_Object    DownTube/BottleCage_Lower/Base    position    $BB_Position]

                                            set BottleCage(object)      [ $cv_Name readSVG $BottleCage(file) $bc_position $dt_angle  __BottleCage_DT_L__ ]
                                                                          $cv_Name addtag  __Decoration__ withtag $BottleCage(object)
                                            if {$updateCommand != {}}   { $cv_Name bind    $BottleCage(object)    <Double-ButtonPress-1> \
                                                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                                    {   list://Rendering(BottleCage/DownTube_Lower@SELECT_BottleCage) \
                                                                                                    }   {BottleCage DownTube-Lower Parameter} \
                                                                                    ]
                                                                          rattleCAD::view::gui::object_CursorBinding     $cv_Name    $BottleCage(object)
                                            }
                                }

                            }
                    Saddle {
                                # --- create Saddle --------------------
                            set Saddle(position)        [ bikeGeometry::get_Object        Saddle  position        $BB_Position ]
                            set Saddle(file)            [ checkFileString [rattleCAD::control::getValue Component/Saddle/File] ]
                            set SaddlePosition          [ vectormath::addVector $Saddle(position) [list [rattleCAD::control::getValue Rendering/Saddle/Offset_X] [rattleCAD::control::getValue Rendering/Saddle/Offset_Y] ] ]
                            set Saddle(object)          [ $cv_Name readSVG $Saddle(file) $SaddlePosition   0  __Saddle__ ]
                                                          $cv_Name addtag  __Decoration__ withtag $Saddle(object)
                            if {$updateCommand != {}}   { $cv_Name bind $Saddle(object)    <Double-ButtonPress-1> \
                                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                    {   file://Component(Saddle/File) \
                                                                                        Component(Saddle/LengthNose) \
                                                                                        Rendering(Saddle/Offset_X) \
                                                                                        Rendering(Saddle/Offset_Y) \
                                                                                        Result(Length/Saddle/Offset_BB_Nose) \
                                                                                    }   {Saddle Parameter} \
                                                                    ]
                                                          rattleCAD::view::gui::object_CursorBinding     $cv_Name    $Saddle(object)
                                    }
                            }
                    HeadSet {
                                # --- create HeadSet --------------------
                            set HeadSet(polygon)        [ bikeGeometry::get_Object HeadSet/Top polygon $BB_Position  ]
                            set HeadSet(object)         [ $cv_Name create polygon $HeadSet(polygon) -fill white -outline black  -tags __Decoration__ ]
                            if {$updateCommand != {}}   { $cv_Name bind $HeadSet(object)    <Double-ButtonPress-1> \
                                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                    {   Component(HeadSet/Height/Top) \
                                                                                        Component(HeadSet/Diameter) \
                                                                                    }  {HeadSet Parameter} \
                                                                    ]
                                                          rattleCAD::view::gui::object_CursorBinding     $cv_Name    $HeadSet(object)
                                    }
                            set HeadSet(polygon)        [ bikeGeometry::get_Object HeadSet/Bottom polygon $BB_Position ]
                            set HeadSet(object)         [ $cv_Name create polygon $HeadSet(polygon) -fill white -outline black  -tags __Decoration__ ]
                            if {$updateCommand != {}}   { $cv_Name bind $HeadSet(object)    <Double-ButtonPress-1> \
                                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                    {   Component(HeadSet/Height/Bottom)\
                                                                                        Component(HeadSet/Diameter)        \
                                                                                    }  {HeadSet Parameter} \
                                                                    ]
                                                          rattleCAD::view::gui::object_CursorBinding     $cv_Name    $HeadSet(object)
                                    }
                            }
                    Stem {
                                # --- create SeatPost ------------------
                            set Stem(polygon)           [ bikeGeometry::get_Object Stem polygon $BB_Position  ]
                            set Stem(object)            [ $cv_Name create polygon $Stem(polygon) -fill white  -outline black  -tags __Decoration__ ]
                            }
                    Logo {
                                # --- create Logo --------------------
                            set DownTube(Steerer)       [ bikeGeometry::get_Object      DownTube/End    position        $BB_Position ]
                            set DownTube(BBracket)      [ bikeGeometry::get_Object      DownTube/Start  position        $BB_Position ]
                            
							set Logo(Angle)               [rattleCAD::control::getValue Result/Tubes/DownTube/Direction/degree]
                            set Logo(Direction)         [ split [rattleCAD::control::getValue Result/Tubes/DownTube/Direction/polar] ,]
							    # puts "  -> \$Logo(Angle)      $Logo(Angle) "
                                # puts "  -> \$Logo(Direction)  $Logo(Direction) "
                            set Logo(position)          [ vectormath::addVector [ vectormath::center $DownTube(BBracket) $DownTube(Steerer) ] $Logo(Direction) -90]
                            set Logo(file)              [ checkFileString [rattleCAD::control::getValue Component/Logo/File] ]
                            set Logo(object)            [ $cv_Name readSVG $Logo(file) $Logo(position)    $Logo(Angle)  __Logo__ ]
                                                          $cv_Name addtag  __Decoration__ withtag $Logo(object)
                            if {$updateCommand != {}}   { $cv_Name bind $Logo(object)     <Double-ButtonPress-1> \
                                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                    {   file://Component(Logo/File)    \
                                                                                    }   {Logo Parameter} \
                                                                    ]
                                                          rattleCAD::view::gui::object_CursorBinding     $cv_Name    $Logo(object)
                                    }
                    }
                    RearWheel {     # --- create RearWheel -----------------
                            set Hub(position)       [ bikeGeometry::get_Object        RearWheel  position        $BB_Position ]
                            set RimDiameter             $bikeGeometry::RearWheel(RimDiameter)
                            set RimHeight               $bikeGeometry::RearWheel(RimHeight)
                            set TyreHeight              $bikeGeometry::RearWheel(TyreHeight)
                                                            $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter + $TyreHeight]     -tags {__Decoration__ __Tyre__}     -fill white
                                                            $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter + 5]               -tags {__Decoration__ __Rim_01__}   -fill white
                            set my_Rim                  [   $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter - 4]               -tags {__Decoration__ __Rim_02__}   -fill white ]
                                                            $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter - $RimHeight + 5]  -tags {__Decoration__ __Rim_03__}   -fill white
                                                            $cv_Name create circle  $Hub(position)  -radius 45                                          -tags {__Decoration__ __Hub__}      -fill white
                                                            $cv_Name create circle  $Hub(position)  -radius 23                                          -tags {__Decoration__}              -fill white
                            if {$updateCommand != {}}   { $cv_Name bind $my_Rim <Double-ButtonPress-1> \
                                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                    {     Component(Wheel/Rear/RimHeight)        \
                                                                                    }     {RearWheel Parameter} \
                                                                    ]
                                                          rattleCAD::view::gui::object_CursorBinding     $cv_Name    $my_Rim
                                    }
                            }
                    FrontWheel {    # --- create FrontWheel ----------------
                            set Hub(position)       [ bikeGeometry::get_Object        FrontWheel  position    $BB_Position ]
                            set RimDiameter             $bikeGeometry::FrontWheel(RimDiameter)
                            set RimHeight               $bikeGeometry::FrontWheel(RimHeight)
                            set TyreHeight              $bikeGeometry::FrontWheel(TyreHeight)
                                                            $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter + $TyreHeight]     -tags {__Decoration__ __Tyre__}     -fill white
                                                            $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter + 5]               -tags {__Decoration__ __Rim_01__}   -fill white
                            set my_Rim                  [   $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter - 4]               -tags {__Decoration__ __Rim_02__}   -fill white ]
                                                            $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter - $RimHeight + 5]  -tags {__Decoration__ __Rim_03__}   -fill white
                                                            $cv_Name create circle  $Hub(position)  -radius 20                                          -tags {__Decoration__ __Hub__}      -fill white
                                                            $cv_Name create circle  $Hub(position)  -radius 4.5                                         -tags {__Decoration__}              -fill white
                            if {$updateCommand != {}}   { $cv_Name bind    $my_Rim    <Double-ButtonPress-1> \
                                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                                    {     Component(Wheel/Front/RimHeight)        \
                                                                                    }     {FrontWheel Parameter} \
                                                                    ]
                                                          rattleCAD::view::gui::object_CursorBinding     $cv_Name    $my_Rim
                                    }
                            }
                    RearWheel_Rep    {
                            set Hub(position)       [ bikeGeometry::get_Object        RearWheel  position        $BB_Position ]
                            set RimDiameter             $bikeGeometry::RearWheel(RimDiameter)
                            set RimHeight               $bikeGeometry::RearWheel(RimHeight)
                            set TyreHeight              $bikeGeometry::RearWheel(TyreHeight)
                            set my_Wheel                [ $cv_Name create arc   $Hub(position)  -radius [expr 0.5 * $RimDiameter + $TyreHeight] -start -20  -extent 105 -style arc -outline gray60  -tags __Decoration__]
                            set my_Wheel                [ $cv_Name create arc   $Hub(position)  -radius [expr 0.5 * $RimDiameter ]              -start -25  -extent 100 -style arc -outline gray60  -tags __Decoration__  -width 0.35]
                            }
                    FrontWheel_Rep    {
                            set Hub(position)       [ bikeGeometry::get_Object        FrontWheel  position    $BB_Position ]
                            set RimDiameter             $bikeGeometry::FrontWheel(RimDiameter)
                            set RimHeight               $bikeGeometry::FrontWheel(RimHeight)
                            set TyreHeight              $bikeGeometry::FrontWheel(TyreHeight)
                            set my_Wheel                [ $cv_Name create arc   $Hub(position)  -radius [expr 0.5 * $RimDiameter + $TyreHeight] -start  95  -extent  85 -style arc -outline gray60 -tags __Decoration__]
                            set my_Wheel                [ $cv_Name create arc   $Hub(position)  -radius [expr 0.5 * $RimDiameter ]              -start  90  -extent  80 -style arc -outline gray60  -tags __Decoration__  -width 0.35  ]
                            }
                    RearWheel_Pos {
                                # --- create RearDerailleur --------
                            set Hub(position)       [ bikeGeometry::get_Object        RearWheel  position        $BB_Position ]
                            foreach {x y} $Hub(position) break
                            set x1    [expr $x + 15];        set x2    [expr $x - 15];     set y1    [expr $y + 15];     set y2    [expr $y - 15]
                            $cv_Name create line  [list $x1 $y $x2 $y]   -fill darkred  -tags __Decoration__
                            $cv_Name create line  [list $x $y1 $x $y2]   -fill darkred  -tags __Decoration__
                            }
                    LegClearance_Rep {
                            set LegClearance(position)  [ vectormath::addVector $bikeGeometry::LegClearance(Position)  $BB_Position ]
                            $cv_Name create circle      $LegClearance(position)  -radius 5  -outline grey60 -tags __Decoration__
                            }

                    default    {
                            #set Stem(debug)        [ bikeGeometry::get_Object Stem debug $BB_Position  ]
                            #set Stem(object)       [ $cv_Name create line $Stem(debug) -fill red]
                            #$cv_Name create circle     $RearWheel(coords)  -radius 30  -outline red    -width 1.0
                            #$cv_Name create circle     [ list  $FrontWheel(x) $FrontWheel(y) ]  -radius 30  -outline red    -width 1.0
                            #$cv_Name create circle     [ list  $RearWheel(x)  $RearWheel(y)  ]  -radius [ expr $RearWheel(Radius)  ]  -outline red    -width 1.0
                            #$cv_Name create circle     [ list  $FrontWheel(x) $FrontWheel(y) ]  -radius [ expr $FrontWheel(Radius) ]  -outline red    -width 1.0
                            }
            }
    }


    proc debug_geometry {cv_Name BB_Position} {
            #variable DEBUG_Geometry
            puts ""
            puts "   -------------------------------"
            puts "    debug_geometry"

            foreach position [array names bikeGeometry::DEBUG_Geometry] {
                        # puts "       name:            $position    $bikeGeometry::DEBUG_Geometry($position)"
                    set myPosition            [ bikeGeometry::get_Object        DEBUG_Geometry            $bikeGeometry::DEBUG_Geometry($position)    $BB_Position ]
                    puts "         ... $position  $bikeGeometry::DEBUG_Geometry($position)"
                    puts "                    + ($BB_Position)"
                    puts "             -> $myPosition"
                    $cv_Name create circle     $myPosition   -radius 5  -outline orange  -tags {__CenterLine__} -width 2.0
            }
    }


    proc createFrame_Tubes {cv_Name BB_Position {updateCommand {}}} {

        set domInit     $::APPL_Config(root_InitDOM)

            # --- get stageScale
        set stageScale     [ $cv_Name  getNodeAttr  Stage    scale ]

            # --- set tubeColour
            # set tubeColour "gray90"
        set tubeColour         "white"


            # --- create HeadTube --------------------
        set HeadTube(polygon)       [ bikeGeometry::get_Object HeadTube polygon $BB_Position  ]
        set HeadTube(object)        [ $cv_Name create polygon $HeadTube(polygon) -fill $tubeColour -outline black  -tags __HeadTube__]
                                      $cv_Name addtag  __Frame__ withtag $HeadTube(object)
        if {$updateCommand != {}}   { $cv_Name bind    $HeadTube(object)   <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                    {   FrameTubes(HeadTube/Diameter)    \
                                                                    }  {HeadTube Parameter}
                                                    ]
                                      rattleCAD::view::gui::object_CursorBinding    $cv_Name    $HeadTube(object)
                }

            # --- create DownTube --------------------
        set DownTube(polygon)       [ bikeGeometry::get_Object DownTube polygon $BB_Position  ]
        set DownTube(object)        [ $cv_Name create polygon $DownTube(polygon) -fill $tubeColour -outline black  -tags __DownTube__]
                                      $cv_Name addtag  __Frame__ withtag $DownTube(object)
        if {$updateCommand != {}}   { $cv_Name bind    $DownTube(object)    <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                    {   FrameTubes(DownTube/DiameterHT)  \
                                                                        FrameTubes(DownTube/DiameterBB)  \
                                                                        FrameTubes(DownTube/TaperLength) \
                                                                    }  {DownTube Parameter}
                                                    ]
                                      rattleCAD::view::gui::object_CursorBinding    $cv_Name    $DownTube(object)
                }

            # --- create SeatTube --------------------
        set SeatTube(polygon)       [ bikeGeometry::get_Object SeatTube polygon $BB_Position  ]
        set SeatTube(object)        [ $cv_Name create polygon $SeatTube(polygon) -fill $tubeColour -outline black  -tags __SeatTube__]
                                      $cv_Name addtag  __Frame__ withtag $SeatTube(object)
        if {$updateCommand != {}}   { $cv_Name bind    $SeatTube(object)   <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                    {   Lugs(SeatTube/SeatStay/MiterDiameter) \
                                                                        FrameTubes(SeatTube/DiameterTT)   \
                                                                        FrameTubes(SeatTube/DiameterBB)   \
                                                                        FrameTubes(SeatTube/TaperLength)  \
                                                                    }  {SeatTube Parameter}
                                                    ]
                                      rattleCAD::view::gui::object_CursorBinding    $cv_Name    $SeatTube(object)
                }

            # --- create TopTube ---------------------
        set TopTube(polygon)        [ bikeGeometry::get_Object TopTube polygon $BB_Position  ]
        set TopTube(object)         [ $cv_Name create polygon $TopTube(polygon) -fill $tubeColour -outline black  -tags __TopTube__]
                                      $cv_Name addtag  __Frame__ withtag $TopTube(object)
        if {$updateCommand != {}}   { $cv_Name bind    $TopTube(object)    <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                    {   FrameTubes(TopTube/DiameterHT)   \
                                                                        FrameTubes(TopTube/DiameterST)   \
                                                                        FrameTubes(TopTube/TaperLength)  \
                                                                        Custom(TopTube/Angle)        \
                                                                    }  {TopTube Parameter}
                                                    ]
                                      rattleCAD::view::gui::object_CursorBinding    $cv_Name    $TopTube(object)
                }

            # --- create Rear Dropout ----------------
        set RearWheel(position)     [ bikeGeometry::get_Object        RearWheel    position    $BB_Position]
        set RearDropout(file)       [ checkFileString [rattleCAD::control::getValue Lugs/RearDropOut/File] ]
        set RearDropout(Rotation)   $bikeGeometry::RearDrop(RotationOffset)
        set RearDropout(Direction)  $bikeGeometry::RearDrop(Direction) 
        set Rendering(RearDropOut)  [rattleCAD::control::getValue Rendering/RearDropOut]
            switch -exact $RearDropout(Direction) {
                ChainStay  -              
                Chainstay  { set do_angle [expr 180 - $RearDropout(Rotation) + [rattleCAD::control::getValue Result/Tubes/ChainStay/Direction/degree]]}              
                horizontal { set do_angle [expr 360 - $RearDropout(Rotation) ]}              
                default    { set do_angle   0}
            }
            # --- Rear Dropout behind Chain- and SeatStay 
        if {$Rendering(RearDropOut) != {front}} {
            set RearDropout(object) [ $cv_Name readSVG [file join $::APPL_Config(CONFIG_Dir)/components $RearDropout(file)] $RearWheel(position)  $do_angle  __RearDropout__]
        }


            # --- create ChainStay -------------------
        set ChainStay(polygon)      [ bikeGeometry::get_Object ChainStay polygon $BB_Position  ]
        set ChainStay(object)       [ $cv_Name create polygon $ChainStay(polygon) -fill $tubeColour -outline black  -tags __ChainStay__]
                                      $cv_Name addtag  __Frame__ withtag $ChainStay(object)
        if {$updateCommand != {}}   { $cv_Name bind    $ChainStay(object)    <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                    {   FrameTubes(ChainStay/DiameterSS)      \
                                                                        FrameTubes(ChainStay/Height)    \
                                                                        FrameTubes(ChainStay/HeightBB)  \
                                                                        FrameTubes(ChainStay/TaperLength)   \
                                                                        Lugs(RearDropOut/ChainStay/OffsetPerp)  \
                                                                        Lugs(RearDropOut/ChainStay/Offset)  \
                                                                    }  {ChainStay Parameter}
                                                    ]
                                      rattleCAD::view::gui::object_CursorBinding    $cv_Name    $ChainStay(object)
                }

            # --- create SeatStay --------------------
        set SeatStay(polygon)       [ bikeGeometry::get_Object SeatStay polygon $BB_Position  ]
        set SeatStay(object)        [ $cv_Name create polygon $SeatStay(polygon) -fill $tubeColour -outline black  -tags __SeatStay__]
                                      $cv_Name addtag  __Frame__ withtag $SeatStay(object)
        if {$updateCommand != {}}   { $cv_Name bind    $SeatStay(object)    <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                    {   Lugs(SeatTube/SeatStay/MiterDiameter) \
                                                                        FrameTubes(SeatStay/DiameterST)   \
                                                                        FrameTubes(SeatStay/DiameterCS)   \
                                                                        FrameTubes(SeatStay/TaperLength)  \
                                                                        Custom(SeatStay/OffsetTT)   \
                                                                        Lugs(RearDropOut/SeatStay/OffsetPerp)   \
                                                                        Lugs(RearDropOut/SeatStay/Offset)   \
                                                                    }  {SeatStay Parameter}
                                                    ]
                                      rattleCAD::view::gui::object_CursorBinding    $cv_Name    $SeatStay(object)
                }
                
            # --- Rear Dropout in front of Chain- and SeatStay 
        if {$Rendering(RearDropOut) == {front}} {
            set RearDropout(object) [ $cv_Name readSVG [file join $::APPL_Config(CONFIG_Dir)/components $RearDropout(file)] $RearWheel(position)  $do_angle  __RearDropout__]
        }
            # --- handle Rear Dropout - properties ---
                                      $cv_Name addtag  __Frame__ withtag $RearDropout(object)
        if {$updateCommand != {}}   { $cv_Name bind     $RearDropout(object)    <Double-ButtonPress-1> \
                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                {   file://Lugs(RearDropOut/File)            \
                                                    list://Lugs(RearDropOut/Direction@SELECT_DropOutDirection)  \
                                                    list://Rendering(RearDropOut@SELECT_DropOutPosition)    \
                                                    Lugs(RearDropOut/RotationOffset)    \
                                                    Lugs(RearDropOut/Derailleur/x)  \
                                                    Lugs(RearDropOut/Derailleur/y)  \
                                                    Lugs(RearDropOut/SeatStay/OffsetPerp)  \
                                                    Lugs(RearDropOut/SeatStay/Offset)   \
                                                    Lugs(RearDropOut/ChainStay/OffsetPerp)  \
                                                    Lugs(RearDropOut/ChainStay/Offset)  \
                                                }  {RearDropout Parameter} \
                                    ]
                  rattleCAD::view::gui::object_CursorBinding     $cv_Name    $RearDropout(object)
                }                
                
                
                

            # --- create BottomBracket ---------------
        set BottomBracket(outerDiameter)    [rattleCAD::control::getValue Lugs/BottomBracket/Diameter/outside]
        set BottomBracket(innerDiameter)    [rattleCAD::control::getValue Lugs/BottomBracket/Diameter/inside]
        set BottomBracket(object_1)         [ $cv_Name create circle  $BB_Position  -radius [expr 0.5 * $BottomBracket(outerDiameter)]    -fill $tubeColour    -tags {__Frame__  __BottomBracket__  outside} ]
        set BottomBracket(object_2)         [ $cv_Name create circle  $BB_Position  -radius [expr 0.5 * $BottomBracket(innerDiameter)]    -fill $tubeColour    -tags {__Frame__  __BottomBracket__  inside} ]
        set BottomBracket(object)   __BottomBracket__
        $cv_Name addtag $BottomBracket(object) withtag $BottomBracket(object_1)
        $cv_Name addtag $BottomBracket(object) withtag $BottomBracket(object_2)
        if {$updateCommand != {}}   { $cv_Name bind    __BottomBracket__    <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                    {   Lugs(BottomBracket/Diameter/outside)   \
                                                                        Lugs(BottomBracket/Diameter/inside))   \
                                                                    }  {BottomBracket Diameter}
                                                    ]
                                      rattleCAD::view::gui::object_CursorBinding     $cv_Name    $BottomBracket(object)
                }
    }

    proc createCrank_Custom {cv_Name BB_Position} {
        variable crankLength    [rattleCAD::control::getValue Component/CrankSet/Length]
        variable teethCount     [lindex [lsort [split [rattleCAD::control::getValue Component/CrankSet/ChainRings] -]] end]
        variable decoRadius     80

                puts ""
                puts "   -------------------------------"
                puts "   createCrank_Custom"
                puts "       crankLength:    $crankLength"
                puts "       teethCount:     $teethCount"

        proc get_polygonChainWheel {BB_Position} {
                variable teethCount
                variable decoRadius

                    # -----------------------------
                    #   initValues
                set toothWith           12.7
                set toothWithAngle      [expr 2*$vectormath::CONST_PI/$teethCount]
                set chainWheelRadius    [expr 0.5*$toothWith/sin([expr 0.5*$toothWithAngle])]
                set decoRadius          [expr $chainWheelRadius - 8]

                    # -----------------------------
                    #   toothProfile
                    set pt_00 {2 5}                                     ; foreach {x0 y0} $pt_00 break
                    set pt_01 [vectormath::rotateLine {0 0} 3.8 100]    ; foreach {x1 y1} $pt_01 break
                    set pt_02 [vectormath::rotateLine {0 0} 3.8 125]    ; foreach {x2 y2} $pt_02 break
                    set pt_03 [vectormath::rotateLine {0 0} 3.8 150]    ; foreach {x3 y3} $pt_03 break
                    set pt_04 [vectormath::rotateLine {0 0} 3.8 170]    ; foreach {x4 y4} $pt_04 break
                set toothProfile [list $x0 -$y0    $x1 -$y1    $x2 -$y2    $x3 -$y3    $x4 -$y4    $x4 $y4    $x3 $y3    $x2 $y2    $x1 $y1    $x0 $y0]

                    # -----------------------------
                    #    chainwheel profile outside
                set index 0 ;# start her for symetriy purpose
                set outsideProfile {}
                while { $index < $teethCount } {
                    set currentAngle [expr $index * [vectormath::grad $toothWithAngle]]
                    set pos [vectormath::rotateLine {0 0} $chainWheelRadius $currentAngle ]

                    set tmpList_01 {}
                    foreach {x y} $toothProfile {
                        set pt_xy [list $x $y]
                        set pt_xy [vectormath::rotatePoint {0 0} $pt_xy $currentAngle]
                        set pt_xy [vectormath::addVector $pos $pt_xy]
                        set tmpList_01 [lappend tmpList_01 [appUtil::flatten_nestedList $pt_xy] ]
                    }
                    set outsideProfile [lappend teethProfile [appUtil::flatten_nestedList $tmpList_01]]
                    incr index
                }
                set chainWheelProfile [appUtil::flatten_nestedList $outsideProfile]
                set chainWheelProfile [vectormath::addVectorPointList $BB_Position $chainWheelProfile]
                return $chainWheelProfile
        }
        proc get_polygonCrankArm {BB_Position} {
                variable crankLength

                    # -----------------------------
                    #   initValues
                set index 0
                set crankArmProfile {{10 -19} {0 -19}}
                    # -----------------------------
                set point [lindex $crankArmProfile 1]
                set angle 270
                    # -----------------------------
                while {$angle > 90} {
                    incr angle -5
                    set point [vectormath::rotatePoint {0 0} $point -5]
                    lappend crankArmProfile $point
                }
                    # -----------------------------
                lappend crankArmProfile {10 19}
                lappend crankArmProfile [list [expr $crankLength -30] 14] [list $crankLength 14]
                    # -----------------------------
                set point [lindex $crankArmProfile end]
                set angle 90
                while {$angle > -90} {
                    incr angle -5
                    set point [vectormath::rotatePoint [list $crankLength 0] $point -5]
                        # puts "         -> \$angle $angle  -- \$point $point"
                    lappend crankArmProfile $point
                }
                    # -----------------------------
                lappend crankArmProfile [list [expr $crankLength -30] -14]
                set crankArmProfile [appUtil::flatten_nestedList $crankArmProfile]
                set crankArmProfile [vectormath::addVectorPointList $BB_Position $crankArmProfile]
                return $crankArmProfile
        }

        set polygonChainWheel   [get_polygonChainWheel  $BB_Position]
        set polygonCrankArm     [get_polygonCrankArm    $BB_Position]
        set positon_00          $BB_Position
        set positon_01          [vectormath::addVector $BB_Position [list $crankLength 0]]

        set chainWheel          [$cv_Name create polygon     $polygonChainWheel         -tags {__Decoration__ __Crankset__ __ChainWheel__}      -fill white  -outline black]
        set chainWheelRing      [$cv_Name create circle     $positon_00                 -tags {__Decoration__ __Crankset__ __ChainWheelRing__}  -fill white  -outline black  -radius  $decoRadius ]
        set crankArm            [$cv_Name create polygon     $polygonCrankArm           -tags {__Decoration__ __Crankset__ __CrankArm__}        -fill white  -outline black]
        set pedalMount          [$cv_Name create circle     $positon_01                 -tags {__Decoration__ __Crankset__ __PedalMount__}      -fill white  -outline black  -radius  6 ]
        set crankAxle           [$cv_Name create circle     $positon_00                 -tags {__Decoration__ __Crankset__ __PedalMount__}      -fill white  -outline black  -radius 10 ]

        set tagName myTags
        $cv_Name addtag $tagName withtag $chainWheel
        $cv_Name addtag $tagName withtag $chainWheelRing
        $cv_Name addtag $tagName withtag $crankArm
        return $tagName
    }

    proc createFork {cv_Name BB_Position {updateCommand {}} } {

        set domInit     $::APPL_Config(root_InitDOM)

            # --- get stageScale
        set stageScale  [ $cv_Name  getNodeAttr  Stage  scale ]

            # --- set tubeColour
            # set tubeColour "gray90"
        set tubeColour      "white"

            # --- get Rendering Style
        set Rendering(Fork)         [rattleCAD::control::getValue Rendering/Fork]
        set Rendering(ForkBlade)    [rattleCAD::control::getValue Rendering/ForkBlade]
        set Rendering(ForkDropOut)  [rattleCAD::control::getValue Rendering/ForkDropOut]
        
                # tk_messageBox -message "Rendering(ForkDropOut): $Rendering(ForkDropOut)"
        # puts "\n\n  ... Rendering(Fork)         [rattleCAD::control::getValue Rendering/Fork) \n\n"

            # --- create Steerer ---------------------
        set Steerer(polygon)        [ bikeGeometry::get_Object     Steerer     polygon        $BB_Position  ]
        set Steerer(object)         [ $cv_Name create polygon $Steerer(polygon) -fill white -outline black -tags __Frame__ ]



        set RearWheel(position)     [ bikeGeometry::get_Object        RearWheel    position    $BB_Position]

            # --- create Fork Representation ----------------
          # puts "          ... \$Rendering(Fork)    $Rendering(Fork)"
        switch -glob $Rendering(Fork) {
            SteelLugged {
                        set ForkBlade(polygon)      [ bikeGeometry::get_Object ForkBlade polygon $BB_Position  ]
                        set ForkCrown(file)         [ checkFileString $bikeGeometry::myFork(CrownFile) ]
                        set ForkDropout(file)       [ checkFileString $bikeGeometry::myFork(DropOutFile) ]
                        set ForkDropout(position)   [ bikeGeometry::get_Object     FrontWheel  position    $BB_Position ]
                        set do_direction            [ bikeGeometry::get_Object     Lugs/Dropout/Front     direction ]
                        set do_angle                [ expr -90 + [ vectormath::angle $do_direction {0 0} {-1 0} ] ]
                        }
            SteelLuggedMAX {
                        set ForkBlade(polygon)      [ bikeGeometry::get_Object ForkBlade polygon $BB_Position  ]
                        set ForkCrown(file)         [ checkFileString $bikeGeometry::myFork(CrownFile) ]
                        set ForkDropout(file)       [ checkFileString $bikeGeometry::myFork(DropOutFile) ]
                        set ForkDropout(position)   [ bikeGeometry::get_Object     FrontWheel  position    $BB_Position ]
                        set do_direction            [ bikeGeometry::get_Object     Lugs/Dropout/Front     direction ]
                        set do_angle                [ expr -90 + [ vectormath::angle $do_direction {0 0} {-1 0} ] ]
                        }
            Composite*    {
                        set ForkBlade(polygon)      [ bikeGeometry::get_Object ForkBlade polygon $BB_Position  ]
                        set ForkCrown(file)         [ checkFileString $bikeGeometry::myFork(CrownFile) ]
                        set ForkDropout(file)       [ checkFileString $bikeGeometry::myFork(DropOutFile) ]
                        set ForkDropout(position)   [ bikeGeometry::get_Object     FrontWheel  position    $BB_Position ]
                        set Steerer_Fork(position)  [ bikeGeometry::get_Object     Lugs/ForkCrown        position    $BB_Position]
                        set ht_direction            [ bikeGeometry::get_Object     HeadTube direction ]
                        set ht_angle                [ vectormath::angle {0 1} {0 0} $ht_direction ]
                        set vct_01                  [ vectormath::rotatePoint {0 0} {4 70} $ht_angle ]
                        set help_01                 [ vectormath::subVector $Steerer_Fork(position) $vct_01 ]
                        set help_02                 [ list 0 [lindex  $ForkDropout(position) 1] ]
                        set do_angle                [ expr 90 - [ vectormath::angle $help_01 $ForkDropout(position) $help_02  ] ]
                        }
            Suspension* {
                            #puts "\n------------------\n                now Rendering   ... $Rendering(Fork)\n------------------\n"
                            set forkSize [lindex [split $Rendering(Fork) {_}] 1 ]
                            if {$forkSize == {} } { set forkSize "26" }
                            puts "             ... \$forkSize  $forkSize"
                        set ForkBlade(polygon)      [ bikeGeometry::get_Object ForkBlade polygon $BB_Position  ]
                        set ForkCrown(file)         [ checkFileString $bikeGeometry::myFork(CrownFile) ]
                        set ForkDropout(file)       [ checkFileString $bikeGeometry::myFork(DropOutFile) ]
                        set Suspension_ForkRake     [[ $domInit     selectNodes /root/Fork/Suspension_$forkSize/Geometry/Rake ]  asText ]
                        set Project_ForkRake        [rattleCAD::control::getValue Component/Fork/Rake]
                        set do_direction            [ bikeGeometry::get_Object     HeadTube    direction ]
                        set do_angle                [ vectormath::angle {0 1} {0 0} $do_direction ]
                        set offset                  [ expr $Project_ForkRake-$Suspension_ForkRake]
                        set vct_move                [ vectormath::rotatePoint {0 0} [list 0 $offset] [expr 90 + $do_angle] ]
                        set ForkDropout(position)   [ vectormath::addVector [ bikeGeometry::get_Object        FrontWheel  position    $BB_Position ] $vct_move]
                        }
            default {}
        }
          # puts "          ... \$ForkBlade(polygon) [string range $ForkBlade(polygon) 0 50] ..."
          # puts "          ... \$ForkCrown(file)    $ForkCrown(file)"
          # puts "          ... \$ForkDropout(file)  $ForkDropout(file)"

            # --- create Fork Dropout ---------------
        if {$Rendering(ForkDropOut) == {behind}} {
            set ForkDropout(object)     [ $cv_Name readSVG [file join $::APPL_Config(CONFIG_Dir)/components $ForkDropout(file)] $ForkDropout(position) $do_angle  __ForkDropout__]
            $cv_Name addtag  __Frame__ withtag $ForkDropout(object)
        }

            # --- create Fork Blade -----------------
        set ForkBlade(object)       [ $cv_Name create polygon $ForkBlade(polygon) -fill $tubeColour  -outline black -tags __ForkBlade__]
                                      $cv_Name addtag  __Frame__ withtag $ForkBlade(object)

        switch -exact $updateCommand {
            editable {

                      switch -glob $Rendering(Fork) {
                          SteelLugged {
                                    $cv_Name bind $ForkBlade(object)  <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                    {   list://Rendering(ForkBlade@SELECT_ForkBladeType) \
                                                                        Component(Fork/Blade/Width)            \
                                                                        Component(Fork/Blade/DiameterDO)    \
                                                                        Component(Fork/Blade/TaperLength)    \
                                                                        Component(Fork/Blade/BendRadius)    \
                                                                        Component(Fork/Blade/EndLength)    \
                                                                    }  {ForkBlade Parameter} \
                                                    ]
                                      rattleCAD::view::gui::object_CursorBinding     $cv_Name    $ForkBlade(object)
                          }
                          default {}
                      }
                }
            selectable {            $cv_Name bind $ForkBlade(object)  <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                    {   list://Rendering(Fork@SELECT_ForkType) \
                                                                    }  {ForkType Select} \
                                                    ]
                                      rattleCAD::view::gui::object_CursorBinding     $cv_Name    $ForkBlade(object)
                }            default {}
        }                                                   


            # --- create ForkCrown -------------------
                set ht_direction    [ bikeGeometry::get_Object     Lugs/ForkCrown direction ]
                set ht_angle        [expr [ vectormath::dirAngle         {0 0}     $ht_direction ] -90 ]
        set ForkCrown(position)     [ bikeGeometry::get_Object        Lugs/ForkCrown        position    $BB_Position ]
        set ForkCrown(object)       [ $cv_Name readSVG [file join $::APPL_Config(CONFIG_Dir)/components $ForkCrown(file)] $ForkCrown(position) $ht_angle __ForkCrown__ ]
                                      $cv_Name addtag  __Frame__ withtag $ForkCrown(object)
        switch -exact $updateCommand {
            editable {              
                       switch $Rendering(Fork) {
                            SteelLugged {            
                                    $cv_Name bind $ForkCrown(object)  <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                    {   list://Rendering(Fork@SELECT_ForkType) \
                                                                        file://Component(Fork/Crown/File)    \
                                                                        Component(Fork/Crown/Brake/Angle)     \
                                                                        Component(Fork/Crown/Brake/Offset)     \
                                                                        Component(Fork/Crown/Blade/Offset)     \
                                                                        Component(Fork/Crown/Blade/OffsetPerp) \
                                                                    }  {ForkCrown Parameter} \
                                                    ]
                                  }
                            default {            
                                    $cv_Name bind $ForkCrown(object)  <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                    {   list://Rendering(Fork@SELECT_ForkType) \
                                                                    }  {ForkCrown Parameter} \
                                                    ]
                                  }
                        }
                        rattleCAD::view::gui::object_CursorBinding     $cv_Name    $ForkCrown(object)
                        
                }      
            selectable {            $cv_Name bind $ForkCrown(object)  <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                    {   list://Rendering(Fork@SELECT_ForkType) \
                                                                    }  {ForkType Select} \
                                                    ]
                                      rattleCAD::view::gui::object_CursorBinding     $cv_Name    $ForkCrown(object)
                }
            default {}
        }

            # --- create Fork Dropout ---------------
        if {$Rendering(ForkDropOut) == {front}} {
            set ForkDropout(object)     [ $cv_Name readSVG [file join $::APPL_Config(CONFIG_Dir)/components $ForkDropout(file)] $ForkDropout(position) $do_angle  __ForkDropout__]
            $cv_Name addtag  __Frame__ withtag $ForkDropout(object)
        }
        # --- set Fork Dropout Edit -----------------
        switch -exact $updateCommand {
            editable { if {$Rendering(Fork) == {SteelLugged}} {           
                                      $cv_Name bind $ForkDropout(object)  <Double-ButtonPress-1> \
                                                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                                                    {   file://Component(Fork/DropOut/File)    \
                                                                        list://Rendering(ForkDropOut@SELECT_DropOutPosition)
                                                                        Component(Fork/DropOut/Offset)     \
                                                                        Component(Fork/DropOut/OffsetPerp) \
                                                                    }  {ForkDropout Parameter} \
                                                    ]
                                      rattleCAD::view::gui::object_CursorBinding     $cv_Name    $ForkDropout(object)
                       }
                }
            default {}
        }

            # --- check bindings and remove ----------
        switch $Rendering(Fork) {
            Composite        -
            Suspension       -
            Suspension_26    -
            Suspension_28    -
            Suspension_29   {}
            default         {}
        }

        $cv_Name create circle  $ForkDropout(position)    -radius 4.5    -fill white    -tags __Frame__


    }

    proc createChain {cv_Name BB_Position} {
        set crankWheelTeethCount     [lindex [lsort [split [rattleCAD::control::getValue Component/CrankSet/ChainRings] -]] end]
        set casetteTeethCount        15
        set toothWith                12.7
        
              # puts ""
              # puts "   -------------------------------"
              # puts "    createChain"
              # puts "       teethCount:     $crankWheelTeethCount / $casetteTeethCount"   
                
        set Hub(position)           [ bikeGeometry::get_Object        RearWheel                     position        $BB_Position ]
        set Derailleur(position)    [ bikeGeometry::get_Object        Lugs/Dropout/Rear/Derailleur  position          $BB_Position]
        
        set Pulley(x)               [ bikeGeometry::get_Value         Component/Derailleur/Rear/Pulley/x      value ]
        set Pulley(y)               [ bikeGeometry::get_Value         Component/Derailleur/Rear/Pulley/y      value ]
        set Pulley(teeth)           [ bikeGeometry::get_Value         Component/Derailleur/Rear/Pulley/teeth  value ]
        set Pulley(position)        [ vectormath::addVector $Derailleur(position) [list $Pulley(x) [expr -1.0*$Pulley(y)]] ]
               # puts "       Pulley:         $Pulley(x) / $Pulley(y)  $Pulley(teeth)"   
                
        
            # -----------------------------
            #   initValues
        set crankWheelRadius    [expr $toothWith/(2*sin([expr $vectormath::CONST_PI/$crankWheelTeethCount]))]
        set casetteWheelRadius  [expr $toothWith/(2*sin([expr $vectormath::CONST_PI/$casetteTeethCount]))]
        if {$Pulley(teeth) > 3} { 
            set pulleyRadius    [expr $toothWith/(2*sin([expr $vectormath::CONST_PI/$Pulley(teeth)]))]
        } else {
            set pulleyRadius    [expr $toothWith/(2*sin([expr $vectormath::CONST_PI/2]))]
        }
                        
            # -----------------------------
            #   upper Section 
        set deltaRadius         [expr $crankWheelRadius - $casetteWheelRadius]   
        set p_ch_02 [vectormath::cathetusPoint $BB_Position $Hub(position) $deltaRadius close]
          # $cv_Name create circle  $p_ch_02          -radius 150  -outline red     -tags {__debug__}  -width 1
        set ang_02  [vectormath::dirAngle   $BB_Position $p_ch_02]
        set p_01    [vectormath::rotateLine $Hub(position) $casetteWheelRadius $ang_02]
        set p_03    [vectormath::rotateLine $BB_Position   $crankWheelRadius $ang_02]
          # $cv_Name create circle  $p_ch_02          -radius 150  -outline red     -tags {__debug__}  -width 1
          # $cv_Name create circle  $p_03             -radius  50  -outline red     -tags {__debug__}  -width 1
        set p_03    [vectormath::subVector $p_03 [vectormath::unifyVector $p_01 $p_03 40]]
          # $cv_Name create circle  $p_03             -radius  30  -outline red     -tags {__debug__}  -width 1
        set p_02    [vectormath::center $p_01 $p_03]
        
        set polyline_00 {}
        set p_cas   $p_01
        set ang_cas [expr 360/$casetteTeethCount]
        set i       [expr round(0.5 * $casetteTeethCount - 2)]
        while {$i > 0} {
              # puts "   $i"
            set i [expr $i - 1]
            set p_cas [vectormath::rotatePoint $Hub(position) $p_cas $ang_cas]
            lappend polyline_00 $p_cas
        }
        set polyline_00 [lreverse $polyline_00]
        set polyline_01         [appUtil::flatten_nestedList $polyline_00 $p_01 $p_02]     
        set polyline_02         [appUtil::flatten_nestedList $p_02 $p_03]   
        
        
            # -----------------------------
            #   lower Section 
          # $cv_Name create circle  $Pulley(position)      -radius 20  -outline red     -tags {__debug__}  -width 1  
        set deltaRadius         [expr $crankWheelRadius - $pulleyRadius]   
        set p_ch_03 [vectormath::cathetusPoint $Pulley(position) $BB_Position $deltaRadius opposite]
          # $cv_Name create circle  $p_ch_03       -radius  80  -outline red     -tags {__debug__}  -width 1
        set ang_03  [vectormath::dirAngle   $BB_Position $p_ch_03]   
        set p_05    [vectormath::rotateLine $BB_Position   $crankWheelRadius $ang_03]
          # $cv_Name create circle  $p_05          -radius  20  -outline red     -tags {__debug__}  -width 1
        set p_06    [vectormath::rotateLine $Pulley(position) $pulleyRadius  $ang_03]

        set polyline_03         [appUtil::flatten_nestedList $p_05 $p_06]     
        
        
            # -----------------------------
            #   create representation
        set chainObject_01      [$cv_Name create line    $polyline_01       -tags {__Decoration__ __Chain__ __Chain_Section_01__}    -fill gray70  -width 2.0 ]
        set chainObject_02      [$cv_Name create line    $polyline_02       -tags {__Decoration__ __Chain__ __Chain_Section_02__}    -fill gray70  -width 2.0 ]
        set chainObject_03      [$cv_Name create line    $polyline_03       -tags {__Decoration__ __Chain__ __Chain_Section_03__}    -fill gray70  -width 2.0 ]
    
        set tagName myTags
        $cv_Name addtag $tagName withtag $chainObject_01
        $cv_Name addtag $tagName withtag $chainObject_02
        $cv_Name addtag $tagName withtag $chainObject_03
        
        catch {$cv_Name lower $chainObject_01  {__Frame__}    }
        catch {$cv_Name lower $chainObject_02  {__DerailleurFront__} }
        catch {$cv_Name lower $chainObject_03  {__CrankSet__ __DerailleurRear__} }
        #catch {$cv_Name lower $chainObject_03  {} }
        return $tagName
    }
    
   
    proc createFrame_Centerline {cv_Name BB_Position {highlightList_1 {}} {highlightList_2 {}} {backgroundList {}} {excludeList {}} } {
    
    
                # --- get stageScale
            set stageScale     [ $cv_Name  getNodeAttr  Stage    scale ]
    
    
                # --- get defining Values ----------
            set CrankSetLength            [rattleCAD::control::getValue Component/CrankSet/Length]
                # --- get defining Point coords ----------
            set BottomBracket       $BB_Position
            set RearWheel           [ bikeGeometry::get_Object     RearWheel               position    $BB_Position ]
            set FrontWheel          [ bikeGeometry::get_Object     FrontWheel              position    $BB_Position ]
            set Saddle              [ bikeGeometry::get_Object     Saddle                  position    $BB_Position ]
            set Saddle_Proposal     [ bikeGeometry::get_Object     SaddleProposal          position    $BB_Position ]
            set SeatPost_Saddle     [ bikeGeometry::get_Object     SeatPostSaddle          position    $BB_Position ]
            set SeatPost_SeatTube   [ bikeGeometry::get_Object     SeatPostSeatTube        position    $BB_Position ]
            set SeatPost_Pivot      [ bikeGeometry::get_Object     SeatPostPivot           position    $BB_Position ]
            set SeatTube_Ground     [ bikeGeometry::get_Object     SeatTubeGround          position    $BB_Position ]
            set SeatTube_BBracket   [ bikeGeometry::get_Object     SeatTube/Start          position    $BB_Position ]
            set SeatStay_SeatTube   [ bikeGeometry::get_Object     SeatStay/End            position    $BB_Position ]
            set SeatStay_RearWheel  [ bikeGeometry::get_Object     SeatStay/Start          position    $BB_Position ]
            set TopTube_SeatTube    [ bikeGeometry::get_Object     TopTube/Start           position    $BB_Position ]
            set TopTube_Steerer     [ bikeGeometry::get_Object     TopTube/End             position    $BB_Position ]
            set HeadTube_Stem       [ bikeGeometry::get_Object     HeadTube/End            position    $BB_Position ]
            set Steerer_Stem        [ bikeGeometry::get_Object     Steerer/End             position    $BB_Position ]
            set Steerer_Fork        [ bikeGeometry::get_Object     Steerer/Start           position    $BB_Position ]
            set DownTube_Steerer    [ bikeGeometry::get_Object     DownTube/End            position    $BB_Position ]
            set HandleBar           [ bikeGeometry::get_Object     HandleBar               position    $BB_Position ]
            set BaseCenter          [ bikeGeometry::get_Object     BottomBracketGround     position    $BB_Position ]
            set Steerer_Ground      [ bikeGeometry::get_Object     SteererGround           position    $BB_Position ]
            set LegClearance        [ vectormath::addVector     $bikeGeometry::LegClearance(Position)  $BB_Position ]
    
            set Saddle_PropRadius   [ vectormath::length                $Saddle_Proposal   $BB_Position]
            set SeatTube_Angle      [ vectormath::angle                 $SeatPost_SeatTube $BB_Position [list -500 [lindex $BB_Position 1] ] ]
            set SeatPost_Radius     [ vectormath::length                $SeatPost_Saddle   $SeatPost_Pivot] 
            
    
    
                # set debug_01      [ bikeGeometry::get_Object ForkBlade polygon $BB_Position  ]
                # set debug_01        [ bikeGeometry::get_Object        Lugs/ForkCrown      position    $BB_Position ]
                # set debug_01      [ bikeGeometry::get_Object      Result/Position/SeatPost_Saddle position    $BB_Position ]
                # $cv_Name create circle  $debug_01  -radius 20  -fill white  -tags __Frame__ -outline darkred
    
    
            set RimDiameter_Front   [rattleCAD::control::getValue Component/Wheel/Front/RimDiameter]
            set TyreHeight_Front    [rattleCAD::control::getValue Component/Wheel/Front/TyreHeight]
            set RimDiameter_Rear    [rattleCAD::control::getValue Component/Wheel/Rear/RimDiameter]
            set TyreHeight_Rear     [rattleCAD::control::getValue Component/Wheel/Rear/TyreHeight]
    
    
                # ------ rearwheel representation
            $cv_Name create circle     $RearWheel   -radius [ expr 0.5*$RimDiameter_Rear + $TyreHeight_Rear ]    -outline gray60 -width 1.0    -tags {__CenterLine__    rearWheel}
                # ------ frontwheel representation
            $cv_Name create circle     $FrontWheel  -radius [ expr 0.5*$RimDiameter_Front + $TyreHeight_Front ]  -outline gray60 -width 1.0    -tags {__CenterLine__    frontWheel}
    
    
                # ------ headtube extension to ground
            $cv_Name create centerline [ appUtil::flatten_nestedList  $Steerer_Fork       $Steerer_Ground   ]    -fill gray60                 -tags __CenterLine__
                # ------ seattube extension to ground
            $cv_Name create centerline [ appUtil::flatten_nestedList  $SeatTube_BBracket  $SeatTube_Ground  ]    -fill gray60                 -tags {__CenterLine__    seattube_center}
    
    
                # ------ chainstay
            $cv_Name create line     [ appUtil::flatten_nestedList  $RearWheel            $BottomBracket    ]    -fill gray60  -width 1.0      -tags {__CenterLine__    chainstay}
                # ------ seattube
            $cv_Name create line     [ appUtil::flatten_nestedList  $SeatPost_Saddle $SeatPost_SeatTube    $SeatTube_BBracket]    -fill gray60  -width 1.0      -tags {__CenterLine__    seattube}
                # ------ seatstay
            $cv_Name create line     [ appUtil::flatten_nestedList  $SeatStay_SeatTube    $RearWheel        ]    -fill gray60  -width 1.0      -tags {__CenterLine__    seatstay}
                # ------ toptube
            $cv_Name create line     [ appUtil::flatten_nestedList  $TopTube_SeatTube     $TopTube_Steerer  ]    -fill gray60  -width 1.0      -tags {__CenterLine__    toptube}
                # ------ steerer / stem
            $cv_Name create line     [ appUtil::flatten_nestedList  $HandleBar  $Steerer_Stem  $Steerer_Fork]    -fill gray60  -width 1.0      -tags {__CenterLine__    steerer}
                # ------ downtube
            $cv_Name create line     [ appUtil::flatten_nestedList  $DownTube_Steerer     $BB_Position      ]    -fill gray60  -width 1.0      -tags {__CenterLine__    downtube}
                # ------ fork
            $cv_Name create line     [ appUtil::flatten_nestedList  $Steerer_Fork         $FrontWheel       ]    -fill gray60  -width 1.0      -tags {__CenterLine__    fork}
    
                # ------ seatpost
            $cv_Name create line     [ appUtil::flatten_nestedList  $Saddle $SeatPost_Saddle ] -fill gray60  -width 0.5      -tags {__CenterLine__    saddlemount}
    
                # ------ seattube
                # $cv_Name create line  [ appUtil::flatten_nestedList  $Saddle  $SeatPost_SeatTube   $BottomBracket     ]  \
                # ------ seatpost
                # $cv_Name create line  [ appUtil::flatten_nestedList  $Saddle $SeatPost_Saddle  $SeatPost_SeatTube ] -fill gray60  -width 1.0      -tags {__CenterLine__    saddlemount}
    
    
                # ------ crankset representation
            $cv_Name create arc     $BottomBracket  -radius $CrankSetLength      -start -95  -extent 170  -style arc  -outline gray \
                                                                                                                               -width 1.0      -tags {__CenterLine__    crankset}
                # ------ saddle proposal
            $cv_Name create arc     $BottomBracket  -radius $Saddle_PropRadius   -start [expr 177 - $SeatTube_Angle]   -extent 6   -style arc  -outline darkmagenta \
                                                                                                                               -width 1.0      -tags {__CenterLine__    saddleproposal}
                # ------ seatpost pivot
            $cv_Name create arc     $SeatPost_Pivot -radius $SeatPost_Radius     -start  55   -extent 70   -style arc  -outline darkmagenta \
                                                                                                                               -width 1.0      -tags {__CenterLine__    saddlepivot}
    
                # ------ saddle representation
                    set saddle_polygon {}
                    set x_04   [ expr [rattleCAD::control::getValue Component/Saddle/LengthNose] + [rattleCAD::control::getValue Rendering/Saddle/Offset_X] ]
                    set x_03   [ expr $x_04 - 20 ]
                    set x_02   [ expr $x_04 - 30 ]
                    set x_01   [ expr $x_04 - [rattleCAD::control::getValue Component/Saddle/Length]]
                    foreach xy [ list [list $x_01 4] {0 0} [list $x_02 -1] [list $x_03 -5] [list $x_04 -12] ] {
                        set saddle_polygon [ lappend saddle_polygon [vectormath::addVector $Saddle $xy ] ]
                    }
            $cv_Name create line  $saddle_polygon        -fill gray60  -width 1.0      -tags {__CenterLine__    saddle}

    
                # puts "  $highlightList "
                # --- highlightList
                    # set highlight(colour) firebrick
                    # set highlight(colour) darkorchid
                    # set highlight(colour) darkred
                    # set highlight(colour) firebrick
                    # set highlight(colour) blue
    
    
                set highlight(colour) red
                set highlight(width)  2.0
                    # --- create position points
                $cv_Name create circle  $BottomBracket      -radius 20  -outline $highlight(colour)     -tags {__CenterLine__  bottombracket}  \
                                                                                                                                -width $highlight(width)
                $cv_Name create circle  $HandleBar          -radius 15  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
                $cv_Name create circle  $Saddle             -radius 15  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
                $cv_Name create circle  $FrontWheel         -radius 15  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
                $cv_Name create circle  $RearWheel          -radius 15  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
                $cv_Name create circle  $BaseCenter         -radius 15  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
                $cv_Name create circle  $SeatPost_Saddle    -radius 10  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
                $cv_Name create circle  $HeadTube_Stem      -radius 10  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
                    # $cv_Name create circle    $SeatPost_SeatTube  -radius 15  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
                    # $cv_Name create circle    $LegClearance   -radius 10  -outline $highlight(colour)
    
    
    
                set highlight(colour) red
                set highlight(width)  3.0
                    # ------------------------
            foreach item $highlightList_1 {
                catch {$cv_Name itemconfigure $item  -fill      $highlight(colour) -width $highlight(width) } error
                catch {$cv_Name itemconfigure $item  -outline   $highlight(colour) -width $highlight(width) } error
            }
    
                set highlight(colour) darkorange
                    # ------------------------
            foreach item $highlightList_2 {
                catch {$cv_Name itemconfigure $item  -fill      $highlight(colour) -width $highlight(width) } error
                catch {$cv_Name itemconfigure $item  -outline   $highlight(colour) -width $highlight(width) } error
            }
    
            foreach item $backgroundList {
                catch {$cv_Name itemconfigure $item  -width $highlight(width) } error
                catch {$cv_Name itemconfigure $item  -width $highlight(width) } error
            }
    
            puts "  $excludeList "
                # --- highlightList
            foreach item $excludeList {
                catch {$cv_Name delete $item } error
            }
            
                    # --- bindings -----------
            foreach item {steerer fork bottombracket} {
                rattleCAD::view::gui::object_CursorBinding     $cv_Name    $item 
            }
            
            $cv_Name bind  steerer        <Double-ButtonPress-1>  \
                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                {   Component(Stem/Angle)  \
                                    Component(Stem/Length) \
                                    Component(Fork/Height) \
                                    Component(Fork/Rake) }                {Steerer/Fork:  Settings}]
    
            $cv_Name bind  fork           <Double-ButtonPress-1>  \
                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                {   Component(Stem/Angle)  \
                                    Component(Stem/Length) \
                                    Component(Fork/Height) \
                                    Component(Fork/Rake) }                {Steerer/Fork:  Settings}]
    
            $cv_Name bind  bottombracket  <Double-ButtonPress-1>  \
                    [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                {   Custom(BottomBracket/Depth) \
                                    Result(Length/BottomBracket/Height) } {BottomBracket:  Settings}]
       
        }


    proc createTubemiter {cv_Name xy type {rotation {no}}} {


            ## -- read from domProject
                    set     minorAngle          2
                    set     majorAngle          50
                    set     polygon_out         {}
                    set     polygon_in          {}
                    set     diameter_addText    {}
                                                            

        switch $type {
            TopTube_Head {
                    set Miter(header)       "TopTube / HeadTube"
                    set     polygon       [ bikeGeometry::get_Object TubeMiter/TopTube_Head        polygon    {0 0}  ]
                    set     minorDiameter       [rattleCAD::control::getValue FrameTubes(TopTube/DiameterHT]
                    set     minorDirection      [ bikeGeometry::get_Object TopTube     direction ]
                    set     majorDiameter       [rattleCAD::control::getValue FrameTubes/HeadTube/Diameter]
                    set     majorDirection      [ bikeGeometry::get_Object HeadTube     direction ]
                    set     offSet              0
                }
            TopTube_Seat {
                    set Miter(header)       "TopTube / SeatTube"
                    set     polygon             [ bikeGeometry::get_Object TubeMiter/TopTube_Seat        polygon    {0 0} ]
                    set     majorDiameter       [rattleCAD::control::getValue FrameTubes/SeatTube/DiameterTT]
                    set     majorDirection      [ bikeGeometry::get_Object SeatTube     direction ]
                    set     minorDiameter       [rattleCAD::control::getValue FrameTubes/TopTube/DiameterST]
                    set     minorDirection      [ bikeGeometry::get_Object TopTube     direction ]
                    set     offSet              0
                }
            DownTube_Head {
                    set Miter(header)       "DownTube / HeadTube"
                    set     polygon             [ bikeGeometry::get_Object TubeMiter/DownTube_Head    polygon        {0 0}  ]
                    set     majorDiameter       [rattleCAD::control::getValue FrameTubes/HeadTube/Diameter]
                    set     majorDirection      [ bikeGeometry::get_Object HeadTube     direction ]
                    set     minorDiameter       [rattleCAD::control::getValue FrameTubes/DownTube/DiameterHT]
                    set     minorDirection      [ bikeGeometry::get_Object DownTube     direction ]
                    set     majorDirection      [ vectormath::unifyVector {0 0} $majorDirection -1 ]
                    set     offSet              0
                }
            DownTube_Seat {
                    set Miter(header)       "DownTube / SeatTube"
                    set     polygon             [ bikeGeometry::get_Object TubeMiter/DownTube_Seat     polygon       {0 0}  ]
                    set     polygon_out         [ bikeGeometry::get_Object TubeMiter/DownTube_BB_out   polygon       {0 0}  ]
                    set     polygon_in          [ bikeGeometry::get_Object TubeMiter/DownTube_BB_in    polygon       {0 0}  ]
                    set     majorDiameter       [rattleCAD::control::getValue FrameTubes/DownTube/DiameterBB]
                    set     majorDirection      [ bikeGeometry::get_Object DownTube     direction ]
                    set     minorDiameter       [rattleCAD::control::getValue FrameTubes/SeatTube/DiameterBB]
                    set     minorDirection      [ bikeGeometry::get_Object SeatTube     direction ]
                    set     majorDirection      [ vectormath::unifyVector {0 0} $majorDirection -1 ]
                    set     offSet              0
                    set     diameter_addText    "([rattleCAD::control::getValue Lugs/BottomBracket/Diameter/outside]/[rattleCAD::control::getValue Lugs/BottomBracket/Diameter/inside])"
                }
            SeatTube_Down {
                    set Miter(header)       "SeatTube / DownTube"
                    set     polygon             [ bikeGeometry::get_Object TubeMiter/SeatTube_Down     polygon       {0 0}  ]
                    set     polygon_out         [ bikeGeometry::get_Object TubeMiter/SeatTube_BB_out   polygon       {0 0}  ]
                    set     polygon_in          [ bikeGeometry::get_Object TubeMiter/SeatTube_BB_in    polygon       {0 0}  ]
                    set     majorDiameter       [rattleCAD::control::getValue FrameTubes/SeatTube/DiameterBB]
                    set     majorDirection      [ bikeGeometry::get_Object DownTube     direction ]
                    set     minorDiameter       [rattleCAD::control::getValue FrameTubes/DownTube/DiameterBB]
                    set     minorDirection      [ bikeGeometry::get_Object SeatTube     direction ]
                    set     majorDirection      [ vectormath::unifyVector {0 0} $majorDirection -1 ]
                    set     offSet              0
                    set     diameter_addText    "([rattleCAD::control::getValue Lugs/BottomBracket/Diameter/outside]/[rattleCAD::control::getValue Lugs/BottomBracket/Diameter/inside])"
                }
            SeatStay_01 {
                    set Miter(header)       "SeatStay / SeatTube"
                    set     polygon             [ bikeGeometry::get_Object TubeMiter/SeatStay_01        polygon      {0 0}  ]
                    set     majorDiameter       [rattleCAD::control::getValue Lugs/SeatTube/SeatStay/MiterDiameter]
                    set     majorDirection      [ bikeGeometry::get_Object SeatTube     direction ]
                    set     minorDiameter       [rattleCAD::control::getValue FrameTubes/SeatStay/DiameterST]
                    set     minorDirection      [ bikeGeometry::get_Object SeatStay     direction ]
                    set     majorDirection      [ vectormath::unifyVector {0 0} $majorDirection -1 ]
                    set     offSet              [ format "%.3f" [ expr 0.5 * ($majorDiameter - $majorDirection) ] ]
                }
            SeatStay_02 {
                    set Miter(header)       "SeatStay / SeatTube"
                    set     polygon             [ bikeGeometry::get_Object TubeMiter/SeatStay_02        polygon      {0 0}  ]
                    set     majorDiameter       [rattleCAD::control::getValue Lugs/SeatTube/SeatStay/MiterDiameter]
                    set     majorDirection      [ bikeGeometry::get_Object SeatTube     direction ]
                    set     minorDiameter       [rattleCAD::control::getValue FrameTubes/SeatStay/DiameterST]
                    set     minorDirection      [ bikeGeometry::get_Object SeatStay     direction ]
                    set     majorDirection      [ vectormath::unifyVector {0 0} $majorDirection -1 ]
                    set     offSet              [ format "%.3f" [ expr 0.5 * ($majorDiameter - $majorDirection) ] ]
                }
            Reference {
                    set Miter(header)       "Reference"
                    set       polygon           [ bikeGeometry::get_Object TubeMiter/Reference          polygon     {0 0}  ]
                }
            default {return}
        }

        
          # puts "  -> \$polygon     $polygon"
          # puts "  -> \$polygon_in  $polygon_in"
          # puts "  -> \$polygon_out $polygon_out"
        
        
        catch {set polygon_out [lrange $polygon_out 0 end-2]}
        catch {set polygon_in  [lrange $polygon_in  0 end-2]}
        
        if {$rotation == {no}} {
            set Miter(polygon)      [ vectormath::addVectorPointList $xy  $polygon]
            set Miter(polygon_out)  [ vectormath::addVectorPointList $xy  $polygon_out]
            set Miter(polygon_in)   [ vectormath::addVectorPointList $xy  $polygon_in]
        } else {                        
            set       polygon       [ vectormath::rotatePointList {0 -35} $polygon    180]
            set       polygon_out   [ vectormath::rotatePointList {0 -35} $polygon_out 180]
            set       polygon_in    [ vectormath::rotatePointList {0 -35} $polygon_in  180]
            set Miter(polygon)      [ vectormath::addVectorPointList $xy  $polygon]
            set Miter(polygon_out)  [ vectormath::addVectorPointList $xy  $polygon_out]
            set Miter(polygon_in)   [ vectormath::addVectorPointList $xy  $polygon_in]
        }

                # --- mitter polygon
                #
        $cv_Name create polygon $Miter(polygon)     -fill white -outline black
        catch {$cv_Name create line    $Miter(polygon_in)  -fill black}
        catch {$cv_Name create line    $Miter(polygon_out) -fill black}
        
                # --- polygon reference lines
                #
        switch $type {

            Reference {
                            # --- defining values
                            #
                        set Miter(text_01)     "Reference: 100.00 x 10.00 "
                        set textPos     [vectormath::addVector $xy {10 3}]
                    $cv_Name create draftText $textPos  -text $Miter(text_01) -size 2.5
                    }
            default {                   
                            # --- defining values
                            #
                        set Miter(text_01)     "diameter: $majorDiameter / $minorDiameter $diameter_addText"
                        set     minorAngle          [ vectormath::angle {0 1} {0 0} $minorDirection   ]
                        set     majorAngle          [ vectormath::angle {0 1} {0 0} $majorDirection   ]                         
                        set     angle               [ expr abs($majorAngle - $minorAngle) ]
                            if {$angle > 90} {set angle [expr 180 - $angle]}
                        set     angle [ format "%.3f" $angle ]
                        set     angleComplement     [ format "%.3f" [ expr 180 - $angle ] ]
                        set Miter(text_02)     "angle:  $angle / $angleComplement"
                        set Miter(text_03)     "offset: $offSet"
                        
                        set pt_01   [ vectormath::addVector $xy {0  5} ]
                        set pt_02   [ vectormath::addVector $xy {0 -75} ]

                        if {$rotation == {no}} {                
                                set pt_03   [ bikeGeometry::coords_get_xy $Miter(polygon) end ]
                                set pt_03   [ vectormath::addVector $pt_03 {+5  20} ]
                                set pt_04   [ bikeGeometry::coords_get_xy $Miter(polygon) end-1]
                                set pt_04   [ vectormath::addVector $pt_04 {-5  20} ]
                                set pt_05   [ vectormath::addVector $pt_03 { 0  50} ]
                                set pt_06   [ vectormath::addVector $pt_04 { 0  50} ]
                                set pt_11   [ vectormath::addVector $xy    {-20 -48}]
                                set pt_12   [ vectormath::addVector $xy    {-20 -55}]
                                set pt_13   [ vectormath::addVector $xy    {-20 -60}]
                                set pt_14   [ vectormath::addVector $xy    {-20 -65}]                                
                       } else {    
                                set pt_03   [ bikeGeometry::coords_get_xy $Miter(polygon) end ]
                                set pt_03   [ vectormath::addVector $pt_03 {-5 -20} ]
                                set pt_04   [ bikeGeometry::coords_get_xy $Miter(polygon) end-1]
                                set pt_04   [ vectormath::addVector $pt_04 {+5 -20} ]
                                set pt_05   [ vectormath::addVector $pt_03 { 0 -50} ]
                                set pt_06   [ vectormath::addVector $pt_04 { 0 -50} ] 
                                set pt_11   [ vectormath::addVector $xy    {-20 -25}]
                                set pt_12   [ vectormath::addVector $xy    {-20 -18}]
                                set pt_13   [ vectormath::addVector $xy    {-20 -13}]
                                set pt_14   [ vectormath::addVector $xy    {-20  -8}]                         }
                    
                    $cv_Name create centerline     [ appUtil::flatten_nestedList $pt_01 $pt_02 ]  -fill red  -width 0.25
                    $cv_Name create line         [ appUtil::flatten_nestedList $pt_03 $pt_04 ]  -fill blue -width 0.25
                    $cv_Name create centerline     [ appUtil::flatten_nestedList $pt_05 $pt_06 ]  -fill red  -width 0.25
                    
                    $cv_Name create draftText $pt_11  -text $Miter(header)  -size 3.5
                    $cv_Name create draftText $pt_12  -text $Miter(text_01) -size 2.5
                    $cv_Name create draftText $pt_13  -text $Miter(text_02) -size 2.5
                    $cv_Name create draftText $pt_14  -text $Miter(text_03) -size 2.5
                }
        }

    }
    
    proc create_copyReference {cv_Name BB_Position} {
                
                # --- get stageScale
            set stageScale     [ $cv_Name  getNodeAttr  Stage    scale ]

                # --- get defining Point coords ----------
            set BottomBracket         $BB_Position
            set RearWheel             [ bikeGeometry::get_Object     RearWheel           position    $BB_Position ]
            set FrontWheel            [ bikeGeometry::get_Object     FrontWheel          position    $BB_Position ]
            set SeatPost_Saddle       [ bikeGeometry::get_Object     SeatPostSaddle      position    $BB_Position ]
            set HandleBar             [ bikeGeometry::get_Object     HandleBar           position    $BB_Position ]
            set SeatTube_Ground       [ bikeGeometry::get_Object     SeatTubeGround      position    $BB_Position ]
            set Steerer_Ground        [ bikeGeometry::get_Object     SteererGround       position    $BB_Position ]
            set Reference_HB          [ bikeGeometry::get_Object     Reference_HB        position    $BB_Position ]
            set Reference_SN          [ bikeGeometry::get_Object     Reference_SN        position    $BB_Position ]
           
                # ------ centerlines
                # linetype
                #    centerline
                #    line
                # colour
                #    darkviolet
                #    red
                #    darkorange
                #    orange
                #
                
            set line(colour) gray50
            set line(width) 0.5
                # -----------------------------------                          
            $cv_Name create centerline  [ appUtil::flatten_nestedList  $BottomBracket     $SeatTube_Ground   ]    -fill $line(colour)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}
            $cv_Name create centerline  [ appUtil::flatten_nestedList  $Steerer_Ground    $FrontWheel        ]    -fill $line(colour)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}
                                    
            
            
            set line(colour) orange
            set line(width) 1.0
                # -----------------------------------                          
            $cv_Name create centerline  [ appUtil::flatten_nestedList  $BottomBracket     $Reference_HB      ]    -fill $line(colour)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}
                # ------ front triangle
            $cv_Name create centerline  [ appUtil::flatten_nestedList  $BottomBracket     $FrontWheel        ]    -fill $line(colour)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}
            $cv_Name create centerline  [ appUtil::flatten_nestedList  $FrontWheel        $Reference_HB      ]    -fill $line(colour)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}
                # ------ seat triangle
            $cv_Name create centerline  [ appUtil::flatten_nestedList  $BottomBracket     $Reference_SN      ]    -fill $line(colour)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}
            $cv_Name create centerline  [ appUtil::flatten_nestedList  $Reference_SN      $Reference_HB      ]    -fill $line(colour)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}
                # ------ rear triangle
            $cv_Name create centerline  [ appUtil::flatten_nestedList  $RearWheel         $BottomBracket     ]    -fill $line(colour)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}                             
                # ------ diagonal
            # $cv_Name create centerline  [ appUtil::flatten_nestedList  $RearWheel         $Reference_SN      ]    -fill $line(colour)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}
            # $cv_Name create centerline  [ appUtil::flatten_nestedList  $RearWheel         $Reference_HB      ]    -fill $line(colour)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}                             
            
                # ------ position 
            set position(colour)  darkred
            set position(width)       2.0
            set position(radius)      7.0
                # -----------------------------------                                                     
            $cv_Name create circle  $Reference_HB       -radius $position(radius)  -outline $position(colour)     -tags {__CenterLine__}  -width $position(width)
            $cv_Name create circle  $Reference_SN       -radius $position(radius)  -outline $position(colour)     -tags {__CenterLine__}  -width $position(width)
            $cv_Name create circle  $BottomBracket      -radius $position(radius)  -outline $position(colour)     -tags {__CenterLine__}  -width $position(width)
            $cv_Name create circle  $RearWheel          -radius $position(radius)  -outline $position(colour)     -tags {__CenterLine__}  -width $position(width)
            $cv_Name create circle  $FrontWheel         -radius $position(radius)  -outline $position(colour)     -tags {__CenterLine__}  -width $position(width)
    
            
     }


    
    
    

  }


