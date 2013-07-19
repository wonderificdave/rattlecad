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
 #  namespace:  rattleCAD::bikeRendering
 # ---------------------------------------------------------------------------
 #
 #

 namespace eval bikeRendering {


    proc createBaseline {cv_Name BB_Position {colour {gray}}} {

                # --- get distance to Ground
            set BB_Ground(position) [ vectormath::addVector $bikeGeometry::BottomBracket(Ground)  $BB_Position ]

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
            set Rendering(BrakeFront)       $project::Rendering(Brake/Front)
            set Rendering(BrakeRear)        $project::Rendering(Brake/Rear)
            set Rendering(BottleCage_ST)    $project::Rendering(BottleCage/SeatTube)
            set Rendering(BottleCage_DT)    $project::Rendering(BottleCage/DownTube)
            set Rendering(BottleCage_DT_L)  $project::Rendering(BottleCage/DownTube_Lower)




            # --- check existance of File --- regarding on user/etc
            proc checkFileString {fileString} {
                switch -glob $fileString {
                        user:*  {   set svgFile [file join $::APPL_Config(USER_Dir)/components   [lindex [split $fileString :] 1] ]}
                        etc:*   {   set svgFile [file join $::APPL_Config(CONFIG_Dir)/components [lindex [split $fileString :] 1] ]}
                        default {   set svgFile [file join $::APPL_Config(CONFIG_Dir)/components $fileString ]}
                    }
                    # puts "            ... createDecoration::checkFileString $svgFile"
                if {![file exists $svgFile]} {
                            # puts "           ... does not exist, therfore .."
                        set svgFile [file join $::APPL_Config(CONFIG_Dir)/components default_exception.svg]
                }
                    # puts "            ... createDecoration::checkFileString $svgFile"
                return $svgFile
            }


            switch $type {
                    HandleBar {
                                # --- create Handlebar -------------
                            set HandleBar(position)     [ bikeGeometry::get_Object  HandleBar  position    $BB_Position]
                            set HandleBar(file)         [ checkFileString $project::Component(HandleBar/File)]
                            set HandleBar(object)       [ $cv_Name readSVG $HandleBar(file) $HandleBar(position) -5  __HandleBar__ ]
                                                          $cv_Name addtag  __Decoration__ withtag $HandleBar(object)
                            if {$updateCommand != {}}   { $cv_Name bind    $HandleBar(object)    <Double-ButtonPress-1> \
                                                                    [list projectUpdate::createEdit  %x %y  $cv_Name \
                                                                                    {   file://Component(HandleBar/File) \
                                                                                    }   {HandleBar Parameter} \
                                                                    ]
                                                          lib_gui::object_CursorBinding     $cv_Name    $HandleBar(object)
                                    }
                            }
                    DerailleurRear {
                                # --- create RearDerailleur --------
                            set Derailleur(position)    [ bikeGeometry::get_Object  Lugs/Dropout/Rear/Derailleur  position        $BB_Position]
                            set Derailleur(file)        [ checkFileString $project::Component(Derailleur/Rear/File) ]
                            set Derailleur(object)      [ $cv_Name readSVG $Derailleur(file) $Derailleur(position)  0  __DerailleurRear__ ]
                                                        $cv_Name addtag  __Decoration__ withtag $Derailleur(object)
                            if {$updateCommand != {}} { $cv_Name bind    $Derailleur(object)    <Double-ButtonPress-1> \
                                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                                    {   file://Component(Derailleur/Rear/File)    \
                                                                                    }   {DerailleurRear Parameter} \
                                                                    ]
                                                          lib_gui::object_CursorBinding     $cv_Name    $Derailleur(object)
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
                            set Derailleur(file)        [ checkFileString $project::Component(Derailleur/Front/File) ]
                            set Derailleur(object)      [ $cv_Name readSVG $Derailleur(file) $Derailleur(position)  $angle  __DerailleurFront__ ]
                                                          $cv_Name addtag  __Decoration__ withtag $Derailleur(object)
                            if {$updateCommand != {}}   { $cv_Name bind    $Derailleur(object)    <Double-ButtonPress-1> \
                                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                                    {   file://Component(Derailleur/Front/File)    \
                                                                                        Component(Derailleur/Front/Distance) \
                                                                                        Component(Derailleur/Front/Offset) \
                                                                                    }  {DerailleurFront Parameter} \
                                                                    ]
                                                          lib_gui::object_CursorBinding     $cv_Name    $Derailleur(object)
                                    }
                            }
                    CrankSet {
                                # --- create Crankset --------------
                            set CrankSet(position)        $BB_Position
                            set CrankSet(file)            [ checkFileString $project::Component(CrankSet/File) ]
                                # puts "\n  -> \$CrankSet(position) $CrankSet(position)\n"
                                # puts "\n  -> \$CrankSet(file) $CrankSet(file)\n"
                            set compString [file tail $CrankSet(file)]
                            if {[file tail $CrankSet(file)] == {custom.svg}} {
                                    set CrankSet(object)        [ create_customCrank  $cv_Name  $CrankSet(position) ]
                                                                  $cv_Name addtag  __Decoration__ withtag $CrankSet(object)
                                    if {$updateCommand != {}}   { $cv_Name bind    $CrankSet(object)    <Double-ButtonPress-1> \
                                                                            [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                                            {   file://Component(CrankSet/File) \
                                                                                                Component(CrankSet/Length) \
                                                                                                text://Component(CrankSet/ChainRings)
                                                                                            }   {Crankset:  Parameter}
                                                                            ]
                                                                  lib_gui::object_CursorBinding     $cv_Name    $CrankSet(object)
                                        }
                                } else {
                                    set CrankSet(object)        [ $cv_Name readSVG $CrankSet(file) $CrankSet(position)  0  __CrankSet__ ]
                                                                  $cv_Name addtag  __Decoration__ withtag $CrankSet(object)
                                    if {$updateCommand != {}}     { $cv_Name bind    $CrankSet(object)    <Double-ButtonPress-1> \
                                                                            [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                                            {   file://Component(CrankSet/File) \
                                                                                            }   {CrankSet Parameter} \
                                                                            ]
                                                                  lib_gui::object_CursorBinding     $cv_Name    $CrankSet(object)
                                        }
                                }
                            }
                    SeatPost {
                                # --- create SeatPost ------------------
                            set SeatPost(polygon)         [ bikeGeometry::get_Object SeatPost polygon $BB_Position ]
                            set SeatPost(object)        [ $cv_Name create polygon $SeatPost(polygon) -fill white  -outline black  -tags __Decoration__ ]
                            if {$updateCommand != {}}     { $cv_Name bind    $SeatPost(object)   <Double-ButtonPress-1> \
                                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                                    {   Component(SeatPost/Diameter)    \
                                                                                    }   {SeatPost Parameter} \
                                                                    ]
                                                          lib_gui::object_CursorBinding     $cv_Name    $SeatPost(object)
                                    }
                            }

                    Brake {
                                # --- create RearBrake -----------------
                                if {$Rendering(BrakeRear) != {off}} {
                                    puts "          ... \$Rendering(BrakeRear) $Rendering(BrakeRear)"
                                    switch $Rendering(BrakeRear) {
                                        Rim {
                                            set ss_direction    [ bikeGeometry::get_Object SeatStay direction ]
                                            set ss_angle        [ expr - [ vectormath::angle {0 1} {0 0} $ss_direction ] ]
                                            set RearBrake(position) [ bikeGeometry::get_Object  BrakeRear  position    $BB_Position]
                                            set RearBrake(file)         [ checkFileString $project::Component(Brake/Rear/File) ]
                                            set RearBrake(object)       [ $cv_Name readSVG $RearBrake(file) $RearBrake(position) $ss_angle  __RearBrake__ ]
                                                                          $cv_Name addtag  __Decoration__ withtag $RearBrake(object)
                                            if {$updateCommand != {}}   { $cv_Name bind    $RearBrake(object)    <Double-ButtonPress-1> \
                                                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                                                    {  list://Rendering(Brake/Rear@SELECT_BrakeType) \
                                                                                                        file://Component(Brake/Rear/File)    \
                                                                                                        Component(Brake/Rear/LeverLength)    \
                                                                                                        Component(Brake/Rear/Offset)    \
                                                                                                    }  {RearBrake Parameter} \
                                                                                    ]
                                                                          lib_gui::object_CursorBinding     $cv_Name    $RearBrake(object)
                                                    }
                                                }
                                        default {}
                                    }
                                }

                                # --- create FrontBrake ----------------
                                if {$Rendering(BrakeFront) != {off}} {
                                    puts "          ... \$Rendering(BrakeFront) $Rendering(BrakeFront)"
                                    switch $Rendering(BrakeFront) {
                                        Rim {
                                            set ht_direction    [ bikeGeometry::get_Object HeadTube direction ]
                                            set ht_angle        [ expr [ vectormath::angle {0 1} {0 0} $ht_direction ] ]
                                            set fb_angle        $project::Component(Fork/Crown/Brake/Angle)
                                            set fb_angle        [ expr $ht_angle + $fb_angle ]
                                            set FrontBrake(position)    [ bikeGeometry::get_Object  BrakeFront  position    $BB_Position]
                                            set FrontBrake(file)        [ checkFileString $project::Component(Brake/Front/File) ]
                                            set FrontBrake(object)      [ $cv_Name readSVG $FrontBrake(file) $FrontBrake(position) $fb_angle  __FrontBrake__ ]
                                                                          $cv_Name addtag  __Decoration__ withtag $FrontBrake(object)
                                            if {$updateCommand != {}}   { $cv_Name bind    $FrontBrake(object)    <Double-ButtonPress-1> \
                                                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                                                    {   list://Rendering(Brake/Front@SELECT_BrakeType) \
                                                                                                        file://Component(Brake/Front/File)    \
                                                                                                        Component(Brake/Front/LeverLength)    \
                                                                                                        Component(Brake/Front/Offset)    \
                                                                                                    }   {FrontBrake Parameter} \
                                                                                    ]
                                                                          lib_gui::object_CursorBinding     $cv_Name    $FrontBrake(object)
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

                                                # set BottleCage(file)        [ checkFileString $project::Component(BottleCage/SeatTube/File ]  asText ] ]
                                            set BottleCage(object)      [ $cv_Name readSVG $BottleCage(file) $bc_position $st_angle  __BottleCage_ST__ ]
                                                                          $cv_Name addtag  __Decoration__ withtag $BottleCage(object)
                                            if {$updateCommand != {}}   { $cv_Name bind    $BottleCage(object)    <Double-ButtonPress-1> \
                                                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                                                    {   list://Rendering(BottleCage/SeatTube@SELECT_BottleCage) \
                                                                                                    }   {BottleCage SeatTube Parameter} \
                                                                                    ]
                                                                          lib_gui::object_CursorBinding     $cv_Name    $BottleCage(object)
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
                                                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                                                    {   list://Rendering(BottleCage/DownTube@SELECT_BottleCage) \
                                                                                                    }   {BottleCage DownTube-Upper Parameter} \
                                                                                    ]
                                                                          lib_gui::object_CursorBinding     $cv_Name    $BottleCage(object)
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
                                                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                                                    {   list://Rendering(BottleCage/DownTube_Lower@SELECT_BottleCage) \
                                                                                                    }   {BottleCage DownTube-Lower Parameter} \
                                                                                    ]
                                                                          lib_gui::object_CursorBinding     $cv_Name    $BottleCage(object)
                                            }
                                }

                            }
                    Saddle {
                                # --- create Saddle --------------------
                            set Saddle(position)        [ bikeGeometry::get_Object        Saddle  position        $BB_Position ]
                            set Saddle(file)            [ checkFileString $project::Component(Saddle/File) ]
                            set Saddle(object)          [ $cv_Name readSVG $Saddle(file) $Saddle(position)   0  __Saddle__ ]
                                                          $cv_Name addtag  __Decoration__ withtag $Saddle(object)
                            if {$updateCommand != {}}   { $cv_Name bind $Saddle(object)    <Double-ButtonPress-1> \
                                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                                    {   file://Component(Saddle/File) \
                                                                                        Component(Saddle/LengthNose) \
                                                                                    }   {Saddle Parameter} \
                                                                    ]
                                                          lib_gui::object_CursorBinding     $cv_Name    $Saddle(object)
                                    }
                            }
                    HeadSet {
                                # --- create HeadSet --------------------
                            set HeadSet(polygon)        [ bikeGeometry::get_Object HeadSet/Top polygon $BB_Position  ]
                            set HeadSet(object)         [ $cv_Name create polygon $HeadSet(polygon) -fill white -outline black  -tags __Decoration__ ]
                            if {$updateCommand != {}}   { $cv_Name bind $HeadSet(object)    <Double-ButtonPress-1> \
                                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                                    {   Component(HeadSet/Height/Top) \
                                                                                        Component(HeadSet/Diameter) \
                                                                                    }  {HeadSet Parameter} \
                                                                    ]
                                                          lib_gui::object_CursorBinding     $cv_Name    $HeadSet(object)
                                    }
                            set HeadSet(polygon)        [ bikeGeometry::get_Object HeadSet/Bottom polygon $BB_Position ]
                            set HeadSet(object)         [ $cv_Name create polygon $HeadSet(polygon) -fill white -outline black  -tags __Decoration__ ]
                            if {$updateCommand != {}}   { $cv_Name bind $HeadSet(object)    <Double-ButtonPress-1> \
                                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                                    {   Component(HeadSet/Height/Bottom)\
                                                                                        Component(HeadSet/Diameter)        \
                                                                                    }  {HeadSet Parameter} \
                                                                    ]
                                                          lib_gui::object_CursorBinding     $cv_Name    $HeadSet(object)
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
                            set Logo(Angle)               $project::Result(Tubes/DownTube/Direction/degree)
                            set Logo(Direction)         [ split $project::Result(Tubes/DownTube/Direction/polar) ,]
                                # puts "  -> \$Logo(Direction)  $Logo(Direction) "
                            set Logo(position)          [ vectormath::addVector [ vectormath::center $DownTube(BBracket) $DownTube(Steerer) ] $Logo(Direction) -90]
                            set Logo(file)              [ checkFileString $project::Component(Logo/File) ]
                            set Logo(object)            [ $cv_Name readSVG $Logo(file) $Logo(position)    $Logo(Angle)  __Logo__ ]
                                                          $cv_Name addtag  __Decoration__ withtag $Logo(object)
                            if {$updateCommand != {}}   { $cv_Name bind $Logo(object)     <Double-ButtonPress-1> \
                                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                                    {   file://Component(Logo/File)    \
                                                                                    }   {Logo Parameter} \
                                                                    ]
                                                          lib_gui::object_CursorBinding     $cv_Name    $Logo(object)
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
                                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                                    {     Component(Wheel/Rear/RimHeight)        \
                                                                                    }     {RearWheel Parameter} \
                                                                    ]
                                                          lib_gui::object_CursorBinding     $cv_Name    $my_Rim
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
                                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                                    {     Component(Wheel/Front/RimHeight)        \
                                                                                    }     {FrontWheel Parameter} \
                                                                    ]
                                                          lib_gui::object_CursorBinding     $cv_Name    $my_Rim
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

            # --- check existance of File --- regarding on user/etc
        proc checkFileString {fileString} {
            switch -glob $fileString {
                    user:*  {   set svgFile [file join $::APPL_Config(USER_Dir)/components   [lindex [split $fileString :] 1] ]}
                    etc:*   {   set svgFile [file join $::APPL_Config(CONFIG_Dir)/components [lindex [split $fileString :] 1] ]}
                    default {   set svgFile [file join $::APPL_Config(CONFIG_Dir)/components $fileString ]}
                }
                # puts "            ... createDecoration::checkFileString $svgFile"
            if {![file exists $svgFile]} {
                        # puts "           ... does not exist, therfore .."
                    set svgFile [file join $::APPL_Config(CONFIG_Dir)/components default_exception.svg]
            }
                # puts "            ... createDecoration::checkFileString $svgFile"
            return $svgFile
        }



            # --- create HeadTube --------------------
        set HeadTube(polygon)       [ bikeGeometry::get_Object HeadTube polygon $BB_Position  ]
        set HeadTube(object)        [ $cv_Name create polygon $HeadTube(polygon) -fill $tubeColour -outline black  -tags __HeadTube__]
                                      $cv_Name addtag  __Frame__ withtag $HeadTube(object)
        if {$updateCommand != {}}   { $cv_Name bind    $HeadTube(object)   <Double-ButtonPress-1> \
                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                    {   FrameTubes(HeadTube/Diameter)    \
                                                                    }  {HeadTube Parameter}
                                                    ]
                                      lib_gui::object_CursorBinding    $cv_Name    $HeadTube(object)
                }

            # --- create DownTube --------------------
        set DownTube(polygon)       [ bikeGeometry::get_Object DownTube polygon $BB_Position  ]
        set DownTube(object)        [ $cv_Name create polygon $DownTube(polygon) -fill $tubeColour -outline black  -tags __DownTube__]
                                      $cv_Name addtag  __Frame__ withtag $DownTube(object)
        if {$updateCommand != {}}   { $cv_Name bind    $DownTube(object)    <Double-ButtonPress-1> \
                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                    {   FrameTubes(DownTube/DiameterHT)  \
                                                                        FrameTubes(DownTube/DiameterBB)  \
                                                                        FrameTubes(DownTube/TaperLength) \
                                                                    }  {DownTube Parameter}
                                                    ]
                                      lib_gui::object_CursorBinding    $cv_Name    $DownTube(object)
                }

            # --- create SeatTube --------------------
        set SeatTube(polygon)       [ bikeGeometry::get_Object SeatTube polygon $BB_Position  ]
        set SeatTube(object)        [ $cv_Name create polygon $SeatTube(polygon) -fill $tubeColour -outline black  -tags __SeatTube__]
                                      $cv_Name addtag  __Frame__ withtag $SeatTube(object)
        if {$updateCommand != {}}   { $cv_Name bind    $SeatTube(object)   <Double-ButtonPress-1> \
                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                    {   Lugs(SeatTube/SeatStay/MiterDiameter) \
                                                                        FrameTubes(SeatTube/DiameterTT)   \
                                                                        FrameTubes(SeatTube/DiameterBB)   \
                                                                        FrameTubes(SeatTube/TaperLength)  \
                                                                    }  {SeatTube Parameter}
                                                    ]
                                      lib_gui::object_CursorBinding    $cv_Name    $SeatTube(object)
                }

            # --- create TopTube ---------------------
        set TopTube(polygon)        [ bikeGeometry::get_Object TopTube polygon $BB_Position  ]
        set TopTube(object)         [ $cv_Name create polygon $TopTube(polygon) -fill $tubeColour -outline black  -tags __TopTube__]
                                      $cv_Name addtag  __Frame__ withtag $TopTube(object)
        if {$updateCommand != {}}   { $cv_Name bind    $TopTube(object)    <Double-ButtonPress-1> \
                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                    {   FrameTubes(TopTube/DiameterHT)   \
                                                                        FrameTubes(TopTube/DiameterST)   \
                                                                        FrameTubes(TopTube/TaperLength)  \
                                                                        Custom(TopTube/Angle)        \
                                                                    }  {TopTube Parameter}
                                                    ]
                                      lib_gui::object_CursorBinding    $cv_Name    $TopTube(object)
                }

            # --- create Rear Dropout ----------------
        set RearWheel(position)     [ bikeGeometry::get_Object        RearWheel    position    $BB_Position]
        set RearDropout(file)       [ checkFileString $project::Lugs(RearDropOut/File) ]
        set RearDropout(Rotation)   $bikeGeometry::RearDrop(RotationOffset)
        set RearDropout(Direction)  $bikeGeometry::RearDrop(Direction) 
        set Rendering(RearDropOut)  $project::Rendering(RearDropOut)
            switch -exact $RearDropout(Direction) {
                Chainstay { set do_angle [expr 180 - $RearDropout(Rotation) + $project::Result(Tubes/ChainStay/Direction/degree)]}              
                default   { set do_angle   0}
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
                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                    {   FrameTubes(ChainStay/DiameterSS)      \
                                                                        FrameTubes(ChainStay/Height)    \
                                                                        FrameTubes(ChainStay/HeightBB)  \
                                                                        FrameTubes(ChainStay/TaperLength)   \
                                                                        Lugs(RearDropOut/ChainStay/OffsetPerp)  \
                                                                        Lugs(RearDropOut/ChainStay/Offset)  \
                                                                    }  {Chainstay Parameter}
                                                    ]
                                      lib_gui::object_CursorBinding    $cv_Name    $ChainStay(object)
                }

            # --- create SeatStay --------------------
        set SeatStay(polygon)       [ bikeGeometry::get_Object SeatStay polygon $BB_Position  ]
        set SeatStay(object)        [ $cv_Name create polygon $SeatStay(polygon) -fill $tubeColour -outline black  -tags __SeatStay__]
                                      $cv_Name addtag  __Frame__ withtag $SeatStay(object)
        if {$updateCommand != {}}   { $cv_Name bind    $SeatStay(object)    <Double-ButtonPress-1> \
                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                    {   Lugs(SeatTube/SeatStay/MiterDiameter) \
                                                                        FrameTubes(SeatStay/DiameterST)   \
                                                                        FrameTubes(SeatStay/DiameterCS)   \
                                                                        FrameTubes(SeatStay/TaperLength)  \
                                                                        Custom(SeatStay/OffsetTT)   \
                                                                        Lugs(RearDropOut/SeatStay/OffsetPerp)   \
                                                                        Lugs(RearDropOut/SeatStay/Offset)   \
                                                                    }  {SeatStay Parameter}
                                                    ]
                                      lib_gui::object_CursorBinding    $cv_Name    $SeatStay(object)
                }
                
            # --- Rear Dropout in front of Chain- and SeatStay 
        if {$Rendering(RearDropOut) == {front}} {
            set RearDropout(object) [ $cv_Name readSVG [file join $::APPL_Config(CONFIG_Dir)/components $RearDropout(file)] $RearWheel(position)  $do_angle  __RearDropout__]
        }
            # --- handle Rear Dropout - properties ---
                                      $cv_Name addtag  __Frame__ withtag $RearDropout(object)
                            if {$updateCommand != {}}   { $cv_Name bind     $RearDropout(object)    <Double-ButtonPress-1> \
                                                        [list projectUpdate::createEdit  %x %y  $cv_Name  \
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
                                      lib_gui::object_CursorBinding     $cv_Name    $RearDropout(object)
                }                
                
                
                

            # --- create BottomBracket ---------------
        set BottomBracket(outerDiameter)    $project::Lugs(BottomBracket/Diameter/outside)
        set BottomBracket(innerDiameter)    $project::Lugs(BottomBracket/Diameter/inside)
        set BottomBracket(object_1)         [ $cv_Name create circle  $BB_Position  -radius [expr 0.5 * $BottomBracket(outerDiameter)]    -fill $tubeColour    -tags {__Frame__  __BottomBracket__  outside} ]
        set BottomBracket(object_2)         [ $cv_Name create circle  $BB_Position  -radius [expr 0.5 * $BottomBracket(innerDiameter)]    -fill $tubeColour    -tags {__Frame__  __BottomBracket__  inside} ]
        set BottomBracket(object)   __BottomBracket__
        $cv_Name addtag $BottomBracket(object) withtag $BottomBracket(object_1)
        $cv_Name addtag $BottomBracket(object) withtag $BottomBracket(object_2)
        if {$updateCommand != {}}   { $cv_Name bind    __BottomBracket__    <Double-ButtonPress-1> \
                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                    {   Lugs(BottomBracket/Diameter/outside)   \
                                                                        Lugs(BottomBracket/Diameter/inside))   \
                                                                    }  {BottomBracket Diameter}
                                                    ]
                                      lib_gui::object_CursorBinding     $cv_Name    $BottomBracket(object)
                }
    }

    proc create_customCrank {cv_Name BB_Position} {
        variable crankLength    $project::Component(CrankSet/Length)
        variable teethCount     [lindex [lsort [split $project::Component(CrankSet/ChainRings) -]] end]
        variable decoRadius     80

                puts ""
                puts "   -------------------------------"
                puts "   create_customCrank"
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

        set chainWheel          [$cv_Name create polygon     $polygonChainWheel            -tags {__Decoration__ __Crankset__ __ChainWheel__}      -fill white  -outline black]
        set chainWheelRing      [$cv_Name create circle     $positon_00                 -tags {__Decoration__ __Crankset__ __ChainWheelRing__}  -fill white  -outline black  -radius  $decoRadius ]
        set crankArm            [$cv_Name create polygon     $polygonCrankArm            -tags {__Decoration__ __Crankset__ __CrankArm__}        -fill white  -outline black]
        set pedalMount          [$cv_Name create circle     $positon_01                 -tags {__Decoration__ __Crankset__ __PedalMount__}      -fill white  -outline black  -radius  6 ]
        set crankAxle           [$cv_Name create circle     $positon_00                 -tags {__Decoration__ __Crankset__ __PedalMount__}      -fill white  -outline black  -radius 10 ]

        set tagName myTags
        $cv_Name addtag $tagName withtag $chainWheel
        $cv_Name addtag $tagName withtag $chainWheelRing
        $cv_Name addtag $tagName withtag $crankArm
        return $tagName
    }

    proc createFork_Rep {cv_Name BB_Position {updateCommand {}} } {

        set domInit     $::APPL_Config(root_InitDOM)

            # --- get stageScale
        set stageScale  [ $cv_Name  getNodeAttr  Stage  scale ]

            # --- set tubeColour
            # set tubeColour "gray90"
        set tubeColour      "white"

            # --- get Rendering Style
        set Rendering(Fork)         $project::Rendering(Fork)
        set Rendering(ForkBlade)    $project::Rendering(ForkBlade)
        set Rendering(ForkDropOut)  $project::Rendering(ForkDropOut)
        
                # tk_messageBox -message "Rendering(ForkDropOut): $Rendering(ForkDropOut)"

            # --- check existance of File --- regarding on user/etc
        proc checkFileString {fileString} {
            switch -glob $fileString {
                    user:*  {   set svgFile [file join $::APPL_Config(USER_Dir)/components   [lindex [split $fileString :] 1] ]}
                    etc:*   {   set svgFile [file join $::APPL_Config(CONFIG_Dir)/components [lindex [split $fileString :] 1] ]}
                    default {   set svgFile [file join $::APPL_Config(CONFIG_Dir)/components $fileString ]}
                }
                # puts "            ... createDecoration::checkFileString $svgFile"
            if {![file exists $svgFile]} {
                        # puts "           ... does not exist, therfore .."
                    set svgFile [file join $::APPL_Config(CONFIG_Dir)/components default_exception.svg]
            }
                # puts "            ... createDecoration::checkFileString $svgFile"
            return $svgFile
        }


            # --- create Steerer ---------------------
        set Steerer(polygon)        [ bikeGeometry::get_Object     Steerer     polygon        $BB_Position  ]
        set Steerer(object)         [ $cv_Name create polygon $Steerer(polygon) -fill white -outline black -tags __Frame__ ]



        set RearWheel(position)     [ bikeGeometry::get_Object        RearWheel    position    $BB_Position]

            # --- create Fork Representation ----------------
        puts "          ... \$Rendering(Fork) $Rendering(Fork)"
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
            Composite     {
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
                        set Project_ForkRake        $project::Component(Fork/Rake)
                        set do_direction            [ bikeGeometry::get_Object     HeadTube    direction ]
                        set do_angle                [ vectormath::angle {0 1} {0 0} $do_direction ]
                        set offset                  [ expr $Project_ForkRake-$Suspension_ForkRake]
                        set vct_move                [ vectormath::rotatePoint {0 0} [list 0 $offset] [expr 90 + $do_angle] ]
                        set ForkDropout(position)   [ vectormath::addVector [ bikeGeometry::get_Object        FrontWheel  position    $BB_Position ] $vct_move]
                        }
            default {}
        }

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
                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                    {   list://Rendering(ForkBlade@SELECT_ForkBladeType) \
                                                                        Component(Fork/Blade/Width)            \
                                                                        Component(Fork/Blade/DiameterDO)    \
                                                                        Component(Fork/Blade/TaperLength)    \
                                                                        Component(Fork/Blade/BendRadius)    \
                                                                        Component(Fork/Blade/EndLength)    \
                                                                    }  {ForkBlade Parameter} \
                                                    ]
                                      lib_gui::object_CursorBinding     $cv_Name    $ForkBlade(object)
                          }
                          default {}
                      }
                }
            selectable {            $cv_Name bind $ForkBlade(object)  <Double-ButtonPress-1> \
                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                    {   list://Rendering(Fork@SELECT_ForkType) \
                                                                    }  {ForkType Select} \
                                                    ]
                                      lib_gui::object_CursorBinding     $cv_Name    $ForkBlade(object)
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
                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
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
                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                    {   list://Rendering(Fork@SELECT_ForkType) \
                                                                    }  {ForkCrown Parameter} \
                                                    ]
                                  }
                        }
                        lib_gui::object_CursorBinding     $cv_Name    $ForkCrown(object)
                        
                }      
            selectable {            $cv_Name bind $ForkCrown(object)  <Double-ButtonPress-1> \
                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                    {   list://Rendering(Fork@SELECT_ForkType) \
                                                                    }  {ForkType Select} \
                                                    ]
                                      lib_gui::object_CursorBinding     $cv_Name    $ForkCrown(object)
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
                                                    [list projectUpdate::createEdit  %x %y  $cv_Name  \
                                                                    {   file://Component(Fork/DropOut/File)    \
                                                                        list://Rendering(ForkDropOut@SELECT_DropOutPosition)
                                                                        Component(Fork/DropOut/Offset)     \
                                                                        Component(Fork/DropOut/OffsetPerp) \
                                                                    }  {ForkDropout Parameter} \
                                                    ]
                                      lib_gui::object_CursorBinding     $cv_Name    $ForkDropout(object)
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


    proc createFrame_Centerline {cv_Name BB_Position {highlightList_1 {}} {highlightList_2 {}} {backgroundList {}} {excludeList {}} } {


            # --- get stageScale
        set stageScale     [ $cv_Name  getNodeAttr  Stage    scale ]


            # --- get defining Values ----------
        set CrankSetLength            $project::Component(CrankSet/Length)
            # --- get defining Point coords ----------
        set BottomBracket       $BB_Position
        set RearWheel           [ bikeGeometry::get_Object     RearWheel               position    $BB_Position ]
        set FrontWheel          [ bikeGeometry::get_Object     FrontWheel              position    $BB_Position ]
        set Saddle              [ bikeGeometry::get_Object     Saddle                  position    $BB_Position ]
        set Saddle_Proposal     [ bikeGeometry::get_Object     SaddleProposal          position    $BB_Position ]
        set SeatPost_Saddle     [ bikeGeometry::get_Object     SeatPostSaddle          position    $BB_Position ]
        set SeatPost_SeatTube   [ bikeGeometry::get_Object     SeatPostSeatTube        position    $BB_Position ]
        set SeatTube_Ground     [ bikeGeometry::get_Object     SeatTubeGround          position    $BB_Position ]
        set SeatTube_BBracket   [ bikeGeometry::get_Object     SeatTube/Start          position    $BB_Position ]
        set SeatStay_SeatTube   [ bikeGeometry::get_Object     SeatStay/End            position    $BB_Position ]
        set SeatStay_RearWheel  [ bikeGeometry::get_Object     SeatStay/Start          position    $BB_Position ]
        set TopTube_SeatTube    [ bikeGeometry::get_Object     TopTube/Start           position    $BB_Position ]
        set TopTube_Steerer     [ bikeGeometry::get_Object     TopTube/End             position    $BB_Position ]
        set Steerer_Stem        [ bikeGeometry::get_Object     Steerer/End             position    $BB_Position ]
        set Steerer_Fork        [ bikeGeometry::get_Object     Steerer/Start           position    $BB_Position ]
        set DownTube_Steerer    [ bikeGeometry::get_Object     DownTube/End            position    $BB_Position ]
        set HandleBar           [ bikeGeometry::get_Object     HandleBar               position    $BB_Position ]
        set BaseCenter          [ bikeGeometry::get_Object     BottomBracketGround     position    $BB_Position ]
        set Steerer_Ground      [ bikeGeometry::get_Object     SteererGround           position    $BB_Position ]
        set LegClearance        [ vectormath::addVector     $bikeGeometry::LegClearance(Position)     $BB_Position ]

        set Saddle_PropRadius   [ vectormath::length                $Saddle_Proposal $BB_Position]
        set SeatTube_Angle      [ vectormath::angle                 $SeatPost_SeatTube $BB_Position [list -500 [lindex $BB_Position 1] ] ]


            # set debug_01      [ bikeGeometry::get_Object ForkBlade polygon $BB_Position  ]
            # set debug_01        [ bikeGeometry::get_Object        Lugs/ForkCrown      position    $BB_Position ]
            # set debug_01      [ bikeGeometry::get_Object      Result/Position/SeatPost_Saddle position    $BB_Position ]
            # $cv_Name create circle  $debug_01  -radius 20  -fill white  -tags __Frame__ -outline darkred


        set RimDiameter_Front   $project::Component(Wheel/Front/RimDiameter)
        set TyreHeight_Front    $project::Component(Wheel/Front/TyreHeight)
        set RimDiameter_Rear    $project::Component(Wheel/Rear/RimDiameter)
        set TyreHeight_Rear     $project::Component(Wheel/Rear/TyreHeight)


            # ------ rearwheel representation
        $cv_Name create circle     $RearWheel   -radius [ expr 0.5*$RimDiameter_Rear + $TyreHeight_Rear ]      -outline gray60 -width 1.0    -tags {__CenterLine__    rearWheel}
            # ------ frontwheel representation
        $cv_Name create circle     $FrontWheel  -radius [ expr 0.5*$RimDiameter_Front + $TyreHeight_Front ]      -outline gray60    -width 1.0    -tags {__CenterLine__    frontWheel}


            # ------ headtube extension to ground
        $cv_Name create centerline [ appUtil::flatten_nestedList  $Steerer_Fork   $Steerer_Ground  ]          -fill gray60                 -tags __CenterLine__
            # ------ seattube extension to ground
        $cv_Name create centerline [ appUtil::flatten_nestedList  $SeatTube_BBracket  $SeatTube_Ground ]    -fill gray60                 -tags {__CenterLine__    seattube_center}


            # ------ chainstay
        $cv_Name create line     [ appUtil::flatten_nestedList  $RearWheel             $BottomBracket     ]      -fill gray60  -width 1.0      -tags {__CenterLine__    chainstay}
            # ------ seattube
        $cv_Name create line     [ appUtil::flatten_nestedList  $SeatPost_SeatTube   $SeatTube_BBracket ]    -fill gray60  -width 1.0      -tags {__CenterLine__    seattube}
            # ------ seatstay
        $cv_Name create line     [ appUtil::flatten_nestedList  $SeatStay_SeatTube   $RearWheel         ]      -fill gray60  -width 1.0      -tags {__CenterLine__     seatstay}
            # ------ toptube
        $cv_Name create line     [ appUtil::flatten_nestedList  $TopTube_SeatTube    $TopTube_Steerer ]      -fill gray60  -width 1.0      -tags {__CenterLine__    toptube}
            # ------ steerer / stem
        $cv_Name create line     [ appUtil::flatten_nestedList  $HandleBar  $Steerer_Stem  $Steerer_Fork]    -fill gray60  -width 1.0      -tags {__CenterLine__    steerer}
            # ------ downtube
        $cv_Name create line     [ appUtil::flatten_nestedList  $DownTube_Steerer     $BB_Position    ]          -fill gray60  -width 1.0      -tags {__CenterLine__    downtube}
            # ------ fork
        $cv_Name create line     [ appUtil::flatten_nestedList  $Steerer_Fork         $FrontWheel        ]          -fill gray60  -width 1.0      -tags {__CenterLine__    fork}

            # ------ seatpost
        $cv_Name create line     [ appUtil::flatten_nestedList  $Saddle $SeatPost_Saddle $SeatPost_SeatTube] -fill gray60  -width 0.5      -tags {__CenterLine__    saddlemount}

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

            # ------ saddle representation
                set saddle_polygon {}
                set x_04   $project::Component(Saddle/LengthNose)
                set x_03   [ expr $x_04 - 20 ]
                set x_02   [ expr $x_04 - 30 ]
                set x_01   [ expr $project::Component(Saddle/LengthNose) - $project::Component(Saddle/Length) ]
                foreach xy [ list [list $x_01 4] {0 0} [list $x_02 -1] [list $x_03 -5] [list $x_04 -12] ] {
                    set saddle_polygon [ lappend saddle_polygon [vectormath::addVector $Saddle $xy ] ]
                }
        $cv_Name create line  $saddle_polygon                                                               -fill gray60  -width 1.0      -tags {__CenterLine__    saddle}
        # $cv_Name create circle  $SeatPost_Saddle    -radius 20    -fill white    -tags __Frame__ -outline darkred


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
            $cv_Name create circle  $BottomBracket      -radius 20  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
            $cv_Name create circle  $HandleBar          -radius 15  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
            $cv_Name create circle  $Saddle             -radius 15  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
            $cv_Name create circle  $FrontWheel         -radius 15  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
            $cv_Name create circle  $RearWheel          -radius 15  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
            $cv_Name create circle  $BaseCenter         -radius 15  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
            $cv_Name create circle  $SeatPost_Saddle    -radius 10  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
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
    }


    proc createTubemiter {cv_Name xy type} {


            ## -- read from domProject
                    set     minorAngle          2
                    set     majorAngle          50

        switch $type {
            TopTube_Seat {
                    set Mitter(polygon)     [ bikeGeometry::get_Object TubeMiter/TopTube_Seat        polygon    $xy ]
                    set Mitter(header)      "TopTube / SeatTube"
                    set     minorDiameter       $project::FrameTubes(TopTube/DiameterST)
                    set     minorDirection      [ bikeGeometry::get_Object TopTube     direction ]
                    set     majorDiameter       $project::FrameTubes(SeatTube/DiameterTT)
                    set     majorDirection      [ bikeGeometry::get_Object SeatTube     direction ]
                    set     offSet              0
                }
            TopTube_Head {
                    set Mitter(polygon)     [ bikeGeometry::get_Object TubeMiter/TopTube_Head        polygon    $xy  ]
                    set Mitter(header)      "TopTube / HeadTube"
                    set     minorDiameter       $project::FrameTubes(TopTube/DiameterHT)
                    set     minorDirection      [ bikeGeometry::get_Object TopTube     direction ]
                    set     majorDiameter       $project::FrameTubes(HeadTube/Diameter)
                    set     majorDirection      [ bikeGeometry::get_Object HeadTube     direction ]
                    set     offSet              0
                }
            DownTube_Head {
                    set Mitter(polygon)     [ bikeGeometry::get_Object TubeMiter/DownTube_Head    polygon        $xy  ]
                    set Mitter(header)      "DownTube / HeadTube"
                    set     minorDiameter       $project::FrameTubes(DownTube/DiameterHT)
                    set     minorDirection      [ bikeGeometry::get_Object DownTube     direction ]
                    set     majorDiameter       $project::FrameTubes(HeadTube/Diameter)
                    set     majorDirection      [ bikeGeometry::get_Object HeadTube     direction ]
                    set     majorDirection      [ vectormath::unifyVector {0 0} $majorDirection -1 ]
                    set     offSet              0
                }
            SeatStay_01 {
                    set Mitter(polygon)     [ bikeGeometry::get_Object TubeMiter/SeatStay_01        polygon        $xy  ]
                    set Mitter(header)      "SeatStay / SeatTube"
                    set     minorDiameter       $project::FrameTubes(SeatStay/DiameterST)
                    set     minorDirection      [ bikeGeometry::get_Object SeatStay     direction ]
                    set     majorDiameter       $project::Lugs(SeatTube/SeatStay/MiterDiameter)
                    set     majorDirection      [ bikeGeometry::get_Object SeatTube     direction ]
                    set     majorDirection      [ vectormath::unifyVector {0 0} $majorDirection -1 ]
                    set     offSet              [ format "%.3f" [ expr 0.5 * ($majorDiameter - $majorDirection) ] ]
                }
            SeatStay_02 {
                    set Mitter(polygon)     [ bikeGeometry::get_Object TubeMiter/SeatStay_02        polygon        $xy  ]
                    set Mitter(header)      "SeatStay / SeatTube"
                    set     minorDiameter       $project::FrameTubes(SeatStay/DiameterST)
                    set     minorDirection      [ bikeGeometry::get_Object SeatStay     direction ]
                    set     majorDiameter       $project::Lugs(SeatTube/SeatStay/MiterDiameter)
                    set     majorDirection      [ bikeGeometry::get_Object SeatTube     direction ]
                    set     majorDirection      [ vectormath::unifyVector {0 0} $majorDirection -1 ]
                    set     offSet              [ format "%.3f" [ expr 0.5 * ($majorDiameter - $majorDirection) ] ]
                }
            Reference {
                    set Mitter(polygon)     [ bikeGeometry::get_Object TubeMiter/Reference     polygon     $xy  ]
                    set Mitter(header)      "Reference"
                }
            default {return}
        }

                # --- mitter polygon
                #
        $cv_Name create polygon $Mitter(polygon) -fill white -outline black

                # --- polygon reference lines
                #
        switch $type {

            Reference {
                            # --- defining values
                            #
                        set Mitter(text_01)     "Reference: 100.00 x 10.00 "
                        set textPos     [vectormath::addVector $xy {10 3}]
                    $cv_Name create draftText $textPos  -text $Mitter(text_01) -size 2.5
                    }
            default {
                        set pt_01   [ vectormath::addVector $xy {0   5} ]
                        set pt_02   [ vectormath::addVector $xy {0 -75} ]
                    $cv_Name create centerline     [ appUtil::flatten_nestedList $pt_01 $pt_02 ]  -fill red  -width 0.25
                        set pt_03   [ bikeGeometry::coords_get_xy $Mitter(polygon) 0 ]
                        set pt_03   [ vectormath::addVector $pt_03 {+5  20} ]
                        set pt_04   [bikeGeometry::coords_get_xy $Mitter(polygon) end]
                        set pt_04   [ vectormath::addVector $pt_04 {-5  20} ]
                    $cv_Name create line         [ appUtil::flatten_nestedList $pt_03 $pt_04 ]  -fill blue -width 0.25
                        set pt_05   [ vectormath::addVector $pt_03 { 0  50} ]
                        set pt_06   [ vectormath::addVector $pt_04 { 0  50} ]
                    $cv_Name create centerline     [ appUtil::flatten_nestedList $pt_05 $pt_06 ]  -fill red  -width 0.25

                            # --- defining values
                            #
                        set Mitter(text_01)     "diameter: $minorDiameter / $majorDiameter"
                                set     minorAngle          [ vectormath::angle {0 1} {0 0} $minorDirection   ]
                                set     majorAngle          [ vectormath::angle {0 1} {0 0} $majorDirection   ]
                                set     angle               [ expr abs($majorAngle - $minorAngle) ]
                                    if {$angle > 90} {set angle [expr 180 - $angle]}
                                set     angle [ format "%.3f" $angle ]
                                set     angleComplement     [ format "%.3f" [ expr 180 - $angle ] ]
                        set Mitter(text_02)     "angle:  $angle / $angleComplement"
                        set Mitter(text_03)     "offset: $offSet"

                        set textPos     [vectormath::addVector $xy {-20 -48}]
                    $cv_Name create draftText $textPos  -text $Mitter(header) -size 3.5
                        set textPos     [vectormath::addVector $xy {-10 -55}]
                    $cv_Name create draftText $textPos  -text $Mitter(text_01) -size 2.5
                        set textPos     [vectormath::addVector $xy {-10 -60}]
                    $cv_Name create draftText $textPos  -text $Mitter(text_02) -size 2.5
                        set textPos     [vectormath::addVector $xy {-10 -65}]
                    $cv_Name create draftText $textPos  -text $Mitter(text_03) -size 2.5
                }
        }

    }

  }


