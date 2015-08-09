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
 }

    # --- check existance of File --- regarding on user/etc
    proc rattleCAD::rendering::checkFileString {fileString} {
        switch -glob $fileString {
            user:*  {   set svgFile [file join $::APPL_Config(USER_Dir)/components   [lindex [split $fileString :] 1] ]}
            etc:*   {   set svgFile [file join $::APPL_Config(COMPONENT_Dir)         [lindex [split $fileString :] 1] ]}
            default {   set svgFile [file join $::APPL_Config(COMPONENT_Dir)         $fileString ]}
        }
			
            #
		  # puts "            ... rattleCAD::rendering::checkFileString: $fileString"
		  # puts "                        ... $svgFile"
		    #
        if {![file exists $svgFile]} {
                # puts "           ... does not exist, therfore .."
            set svgFile [file join $::APPL_Config(COMPONENT_Dir) default_exception.svg]
        }
            # puts "            ... createDecoration::checkFileString $svgFile"
        return $svgFile
    }


    proc rattleCAD::rendering::createBaseline {cv_Name BB_Position {colour {gray}}} {

                # --- get distance to Ground
            set BB_Ground(position)     [ rattleCAD::model::get_Position    BottomBracket_Ground    $BB_Position]
                # puts "   -> \$BB_Ground(position) $BB_Ground(position)"
                # exit
		    
            set RimDiameter_Front       [ rattleCAD::model::get_Scalar      Geometry FrontRim_Diameter]
            set RimDiameter_Rear        [ rattleCAD::model::get_Scalar      Geometry RearRim_Diameter]
                #   puts "  -> \$RimDiameter_Front $RimDiameter_Front"
                #   puts "  -> \$RimDiameter_Rear  $RimDiameter_Rear"


            set FrontWheel(position)    [ rattleCAD::model::get_Position    FrontWheel      $BB_Position]
            set RearWheel(position)     [ rattleCAD::model::get_Position    RearWheel       $BB_Position]
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


    proc rattleCAD::rendering::createDecoration {cv_Name BB_Position type {updateCommand {}}} {
                #
            switch $type {
                    HandleBar           { createDecoration_HandleBar            $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    DerailleurRear      { createDecoration_DerailleurRear       $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    DerailleurRear_ctr  { createDecoration_DerailleurRear_ctr   $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    DerailleurFront     { createDecoration_DerailleurFront      $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    CrankSet            { createDecoration_CrankSet             $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    Cassette            { createDecoration_Cassette             $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    Chain               { createDecoration_Chain                $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    SeatPost            { createDecoration_SeatPost             $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    Brake               { createDecoration_Brake                $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    BottleCage          { createDecoration_BottleCage           $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    Saddle              { createDecoration_Saddle               $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    HeadSet             { createDecoration_HeadSet              $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    Stem                { createDecoration_Stem                 $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    Logo                { createDecoration_Logo                 $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    Fender              { createDecoration_Fender               $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    Fender_Rep          { createDecoration_Fender_Rep           $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    CarrierFront        { createDecoration_CarrierFront         $cv_Name    $BB_Position    $type   $updateCommand;     return }  
                    CarrierRear         { createDecoration_CarrierRear          $cv_Name    $BB_Position    $type   $updateCommand;     return }  
                    RearWheel           { createDecoration_RearWheel            $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    FrontWheel          { createDecoration_FrontWheel           $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    RearWheel_Rep       { createDecoration_RearWheel_Rep        $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    FrontWheel_Rep      { createDecoration_FrontWheel_Rep       $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    RearWheel_Pos       { createDecoration_RearWheel_Pos        $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    LegClearance_Rep    { createDecoration_LegClearance_Rep     $cv_Name    $BB_Position    $type   $updateCommand;     return }
                    default             {}
            }
                #
    } 

    
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
                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $HandleBar(object)      group_HandleBar_Parameter
                    # $cv_Name bind    $HandleBar(object)    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   file://Component(HandleBar/File)    Component(HandleBar/PivotAngle) }   {HandleBar Parameter}   ]
                    # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $HandleBar(object)
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_DerailleurRear {cv_Name BB_Position type {updateCommand {}}} {
                # --- create RearDerailleur --------
            set Derailleur(position)    [ rattleCAD::model::get_Position     RearDerailleur        $BB_Position]
            set Derailleur(file)        [ checkFileString [rattleCAD::model::get_Component  RearDerailleur ] ]
            set Derailleur(object)      [ $cv_Name readSVG $Derailleur(file) $Derailleur(position)  0  __DerailleurRear__ ]
                                        $cv_Name addtag  __Decoration__ withtag $Derailleur(object)
            if {$updateCommand != {}} { 
                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $Derailleur(object)     single_RearDerailleurFile
                    # $cv_Name bind    $Derailleur(object)    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   file://Component(Derailleur/Rear/File)  }   {DerailleurRear Parameter}  ]
                    # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $Derailleur(object)
            }
    }
    proc rattleCAD::rendering::createDecoration_DerailleurRear_ctr {cv_Name BB_Position type {updateCommand {}}} {
                # --- create RearDerailleur --------
            set Derailleur(position)   [ rattleCAD::model::get_Position     RearDerailleur          $BB_Position]
            foreach {x y} $Derailleur(position) break
            set x1    [expr $x + 15];        set x2    [expr $x - 15];     set y1    [expr $y + 15];     set y2    [expr $y - 15]
            $cv_Name create line  [list $x1 $y $x2 $y]   -fill gray60  -tags __Decoration__
            $cv_Name create line  [list $x $y1 $x $y2]   -fill gray60  -tags __Decoration__
                #
    }
    proc rattleCAD::rendering::createDecoration_DerailleurFront {cv_Name BB_Position type {updateCommand {}}} {
                # --- create FrontDerailleur --------
            set Derailleur(position)    [ rattleCAD::model::get_Position    DerailleurMount_Front   $BB_Position]
            set angle                   [ vectormath::angle {0 1} {0 0} [ rattleCAD::model::get_Direction SeatTube ] ]
            set Derailleur(file)        [ checkFileString [rattleCAD::model::get_Component  FrontDerailleur] ]
            set Derailleur(object)      [ $cv_Name readSVG $Derailleur(file) $Derailleur(position)  $angle  __DerailleurFront__ ]
                                          $cv_Name addtag  __Decoration__ withtag $Derailleur(object)
            if {$updateCommand != {}}   { 
                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $Derailleur(object)     group_DerailleurFront_Parameter_17
                    # $cv_Name bind    $Derailleur(object)    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   file://Component(Derailleur/Front/File) Component(Derailleur/Front/Distance)    Component(Derailleur/Front/Offset)  }  {DerailleurFront Parameter} ]
                    # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $Derailleur(object)
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
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $CrankSet(object)      group_Crankset_Parameter_16
                        # $cv_Name bind    $CrankSet(object)    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name{   file://Component(CrankSet/File)   Component(CrankSet/Length)  text://Component(CrankSet/ChainRings)   }   {Crankset:  Parameter}]
                        # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $CrankSet(object)
                }
            } else {
                set CrankSet(object)        [ $cv_Name readSVG $CrankSet(file) $CrankSet(position)  0  __CrankSet__ ]
                                              $cv_Name addtag  __Decoration__ withtag $CrankSet(object)
                if {$updateCommand != {}}     { 
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $CrankSet(object)      single_CrankSetFile
                        # $cv_Name bind    $CrankSet(object)    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   file://Component(CrankSet/File) }   {CrankSet Parameter} ]
                        # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $CrankSet(object)
                }
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_Cassette {cv_Name BB_Position type {updateCommand {}}} {
                # --- create Cassette ----------
            set cassette_OuterTeethCount    28    
            set cassette_InnerTeethCount    [rattleCAD::model::get_Scalar RearWheel FirstSprocket]    
                # 
            set cassette_OuterDiameter  [ expr $cassette_OuterTeethCount * 12.7 / $vectormath::CONST_PI ]
            set cassette_InnerDiameter  [ expr $cassette_InnerTeethCount * 12.7 / $vectormath::CONST_PI ]
            set Hub(position)           [ rattleCAD::model::get_Position    RearWheel   $BB_Position]
                #
            $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $cassette_OuterDiameter]     -tags {__Decoration__ __Cassette__}     -fill white
            $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $cassette_InnerDiameter]     -tags {__Decoration__ __Cassette__}     -fill white
            if {$updateCommand != {}}   { 
                # rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $Chain(object)  group_Chain_Parameter_15
                    # $cv_Name bind    $Chain(object)    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   text://Component(CrankSet/ChainRings)   Component/Derailleur/Rear/Pulley/x   Component/Derailleur/Rear/Pulley/y   Component/Derailleur/Rear/Pulley/teeth }   {Chain Parameter} ]
                    # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $Chain(object)
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_Chain {cv_Name BB_Position type {updateCommand {}}} {
                # --- create Chain -------------
            set Chain(object)           [ createChain  $cv_Name  $BB_Position]
            $cv_Name addtag  __Decoration__ withtag $Chain(object)
            if {$updateCommand != {}}   { 
                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $Chain(object)  group_Chain_Parameter_15
                    # $cv_Name bind    $Chain(object)    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   text://Component(CrankSet/ChainRings)   Component/Derailleur/Rear/Pulley/x   Component/Derailleur/Rear/Pulley/y   Component/Derailleur/Rear/Pulley/teeth }   {Chain Parameter} ]
                    # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $Chain(object)
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_SeatPost {cv_Name BB_Position type {updateCommand {}}} {
                # --- create SeatPost ------------------
            set SeatPost(polygon)         [ rattleCAD::model::get_Polygon   SeatPost    $BB_Position ]
            set SeatPost(object)          [ $cv_Name create polygon $SeatPost(polygon) -fill white  -outline black  -tags __Decoration__ ]
            if {$updateCommand != {}}     { 
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $SeatPost(object)      single_SeatPost_Diameter
                        # $cv_Name bind    $SeatPost(object)   <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  { Component(SeatPost/Diameter) }   {SeatPost Parameter} ]
                        # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $SeatPost(object)
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_Brake {cv_Name BB_Position type {updateCommand {}}} {
                # --- get Rendering Style
			set Config(BrakeFront)       [rattleCAD::model::get_Config FrontBrake]
			set Config(BrakeRear)        [rattleCAD::model::get_Config RearBrake]
                # --- create RearBrake -----------------
            if {$Config(BrakeRear) != {off}} {
                  # puts "          ... \$Config(BrakeRear) $Config(BrakeRear)"
                switch $Config(BrakeRear) {
                    Rim {
                            set ss_direction            [ rattleCAD::model::get_Direction SeatStay ]
                            set ss_angle                [ expr - [ vectormath::angle {0 1} {0 0} $ss_direction ] ]
                            set RearBrake(position)     [ rattleCAD::model::get_Position    RearBrake_Shoe   $BB_Position]
                            set RearBrake(file)         [ checkFileString [ rattleCAD::model::get_Component RearBrake] ]
                            set RearBrake(object)       [ $cv_Name readSVG $RearBrake(file) $RearBrake(position) $ss_angle  __RearBrake__ ]
                                                          $cv_Name addtag  __Decoration__ withtag $RearBrake(object)
                            if {$updateCommand != {}}   { 
                                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $RearBrake(object)      group_RearBrake_Parameter_14
                                    # $cv_Name bind    $RearBrake(object)    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  {  list://Rendering(Brake/Rear@SELECT_BrakeType)    file://Component(Brake/Rear/File)   Component(Brake/Rear/LeverLength)   Component(Brake/Rear/Offset)    }  {RearBrake Parameter} ]
                                    # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $RearBrake(object)
                            }
                        }
                    Disc {
                            set disc_Diameter           [ rattleCAD::model::get_Scalar      RearMockup  DiscDiameter] 
                            set Hub(position)           [ rattleCAD::model::get_Position    RearWheel   $BB_Position]
                            $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $disc_Diameter]     -tags {__Decoration__ __RearBrake__}     -fill white
                        }
                    default {}
                }
            }

                # --- create FrontBrake ----------------
            if {$Config(BrakeFront) != {off}} {
                  # puts "          ... \$Rendering(BrakeFront) $Rendering(BrakeFront)"
                switch $Config(BrakeFront) {
                    Rim {
                            set ht_direction    [ rattleCAD::model::get_Direction   HeadTube ]
                            set ht_angle        [ expr [ vectormath::angle {0 1} {0 0} $ht_direction ] ]
                            set fb_angle        [ rattleCAD::model::get_Scalar Fork CrownAngleBrake]
                            set fb_angle        [ expr $ht_angle + $fb_angle ]
                            set FrontBrake(position)    [ rattleCAD::model::get_Position    FrontBrake_Shoe  $BB_Position ]
                            set FrontBrake(file)        [ checkFileString [rattleCAD::model::get_Component  FrontBrake] ]
                            set FrontBrake(object)      [ $cv_Name readSVG $FrontBrake(file) $FrontBrake(position) $fb_angle  __FrontBrake__ ]
                                                          $cv_Name addtag  __Decoration__ withtag $FrontBrake(object)
                            if {$updateCommand != {}}   { 
                                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $FrontBrake(object)     group_FrontBrake_Parameter_13
                                    # $cv_Name bind    $FrontBrake(object)    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   list://Rendering(Brake/Front@SELECT_BrakeType)  file://Component(Brake/Front/File)  Component(Brake/Front/LeverLength)  Component(Brake/Front/Offset) }   {FrontBrake Parameter} ]
                                    # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $FrontBrake(object)
                            }
                        }
                    Disc {
                            set disc_Diameter           [ expr 20 + [ rattleCAD::model::get_Scalar      RearMockup  DiscDiameter] ]
                            set Hub(position)           [ rattleCAD::model::get_Position    FrontWheel  $BB_Position]
                            $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $disc_Diameter]     -tags {__Decoration__ __FrontBrake__}    -fill white
                            $cv_Name create circle  $Hub(position)  -radius 25                                          -tags {__Decoration__ __Hub__}      -fill white
                        }
                    default {}
                }
            }
    }
    proc rattleCAD::rendering::createDecoration_BottleCage {cv_Name BB_Position type {updateCommand {}}} {
                # 
            set Config(BottleCage_DT)    [rattleCAD::model::get_Config BottleCage_DownTube]
            set Config(BottleCage_DT_L)  [rattleCAD::model::get_Config BottleCage_DownTube_Lower]
            set Config(BottleCage_ST)    [rattleCAD::model::get_Config BottleCage_SeatTube]
                #

                # --- create BottleCage ----------------
            if {$Config(BottleCage_ST) != {off}} {
                    # puts "   ... \$Rendering(BottleCage_ST) $Rendering(BottleCage_ST)"
                switch $Config(BottleCage_ST) {
                    BrazeOn { set BottleCage(file)      [ file join $::APPL_Config(COMPONENT_Dir) bottle_cage/left/brazeOn.svg ] }
                    Cage    { set BottleCage(file)      [ file join $::APPL_Config(COMPONENT_Dir) bottle_cage/left/bottleCage.svg ] }
                    Bottle  { set BottleCage(file)      [ file join $::APPL_Config(COMPONENT_Dir) bottle_cage/left/bottle_Large.svg ] }
                    default {
                              set BottleCage(file) {}
                              puts "\n      <W> \$Config(BottleCage_ST) $Config(BottleCage_ST)"
                            }
                }
                    # puts "   ... $Rendering(BottleCage_ST): BottleCage(file)  $BottleCage(file)"
                set st_direction    [ rattleCAD::model::get_Direction SeatTube ]
                set st_angle        [ expr 180 + [ vectormath::dirAngle {0 0} $st_direction ] ]
                set bc_position     [ rattleCAD::model::get_Position    SeatTube_BottleCageBase     $BB_Position]
                
                set BottleCage(object)      [ $cv_Name readSVG $BottleCage(file) $bc_position $st_angle  __BottleCage_ST__ ]
                                              $cv_Name addtag  __Decoration__ withtag $BottleCage(object)
                if {$updateCommand != {}}   { 
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $BottleCage(object)     single_SeatTube_BottleCageFile
                        # $cv_Name bind    $BottleCage(object)    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   list://Rendering(BottleCage/SeatTube@SELECT_BottleCage) }   {BottleCage SeatTube Parameter} ]
                        # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $BottleCage(object)
                }
            }

            if {$Config(BottleCage_DT) != {off}} {
                    # puts "   ... \$Rendering(BottleCage_DT) $Rendering(BottleCage_DT)"
                switch $Config(BottleCage_DT) {
                    BrazeOn { set BottleCage(file)      [ file join $::APPL_Config(COMPONENT_Dir) bottle_cage/right/brazeOn.svg ] }
                    Cage    { set BottleCage(file)      [ file join $::APPL_Config(COMPONENT_Dir) bottle_cage/right/bottleCage.svg ] }
                    Bottle  { set BottleCage(file)      [ file join $::APPL_Config(COMPONENT_Dir) bottle_cage/right/bottle_Large.svg ] }
                    default {
                              set BottleCage(file) {}
                              puts "\n      <W> \$Config(BottleCage_DT) $Config(BottleCage_DT)"
                            }
                }
                    # puts "   ... $Rendering(BottleCage_ST): BottleCage(file)  $BottleCage(file)"
                set dt_direction    [ rattleCAD::model::get_Direction DownTube ]
                set dt_angle        [ vectormath::dirAngle {0 0} $dt_direction ]
                set bc_position     [ rattleCAD::model::get_Position    DownTube_BottleCageBase     $BB_Position]
                    #
                set BottleCage(object)      [ $cv_Name readSVG $BottleCage(file) $bc_position $dt_angle  __BottleCage_DT__ ]
                                              $cv_Name addtag  __Decoration__ withtag $BottleCage(object)
                if {$updateCommand != {}}   { 
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $BottleCage(object)     single_DownTube_BottleCageFile
                        # $cv_Name bind $BottleCage(object)    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  { list://Config(BottleCage/DownTube@SELECT_BottleCage) }   {BottleCage DownTube-Upper Parameter} ]
                        # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $BottleCage(object)
                }
            }

            if {$Config(BottleCage_DT_L) != {off}} {
                    # puts "   ... \$Rendering(BottleCage_DT_L) $Rendering(BottleCage_DT_L)"
                switch $Config(BottleCage_DT_L) {
                    BrazeOn { set BottleCage(file)      [ file join $::APPL_Config(COMPONENT_Dir) bottle_cage/left/brazeOn.svg ] }
                    Cage    { set BottleCage(file)      [ file join $::APPL_Config(COMPONENT_Dir) bottle_cage/left/bottleCage.svg ] }
                    Bottle  { set BottleCage(file)      [ file join $::APPL_Config(COMPONENT_Dir) bottle_cage/left/bottle_Large.svg ] }
                    default {
                              set BottleCage(file) {}
                              puts "\n      <W> \$Config(BottleCage_DT_L) $Config(BottleCage_DT_L)"
                            }
                }
                    # puts "   ... $Rendering(BottleCage_ST): BottleCage(file)  $BottleCage(file)"
                set dt_direction    [ rattleCAD::model::get_Direction   DownTube ]
                set dt_angle        [ expr 180 + [ vectormath::dirAngle {0 0} $dt_direction ] ]
                set bc_position     [ rattleCAD::model::get_Position    DownTube_Lower_BottleCageBase   $BB_Position]
                
                set BottleCage(object)      [ $cv_Name readSVG $BottleCage(file) $bc_position $dt_angle  __BottleCage_DT_L__ ]
                                              $cv_Name addtag  __Decoration__ withtag $BottleCage(object)
                if {$updateCommand != {}}   { 
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $BottleCage(object)     single_DownTube_BottleCageFileLower
                        # $cv_Name bind    $BottleCage(object)    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  { list://Rendering(BottleCage/DownTube_Lower@SELECT_BottleCage) }   {BottleCage DownTube-Lower Parameter} ]
                        # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $BottleCage(object)
                }                     
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_Saddle {cv_Name BB_Position type {updateCommand {}}} {
                # --- create Saddle --------------------
            set Saddle(position)        [ rattleCAD::model::get_Position     Saddle        $BB_Position ]
            set Saddle(file)            [ checkFileString [rattleCAD::model::get_Component  Saddle] ]
            set SaddlePosition          [ vectormath::addVector $Saddle(position) [list [rattleCAD::model::get_Scalar Saddle Offset_x] [rattleCAD::model::get_Scalar Saddle Offset_y] ] ]
            set Saddle(object)          [ $cv_Name readSVG $Saddle(file) $SaddlePosition   0  __Saddle__ ]
                                          $cv_Name addtag  __Decoration__ withtag $Saddle(object)
            if {$updateCommand != {}}   { 
                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $Saddle(object)     group_Saddle_Parameter_12
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_HeadSet {cv_Name BB_Position type {updateCommand {}}} {
                # --- create HeadSet --------------------
            set HeadSet(polygon)        [ rattleCAD::model::get_Polygon     HeadSetTop          $BB_Position  ]
            set HeadSet(object)         [ $cv_Name create polygon $HeadSet(polygon) -fill white -outline black  -tags __Decoration__ ]
            if {$updateCommand != {}}   { 
                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $HeadSet(object)      group_HeadSet_Parameter_10
            }
                #
            set HeadSet(polygon)        [ rattleCAD::model::get_Polygon     HeadSetBottom       $BB_Position ]
            set HeadSet(object)         [ $cv_Name create polygon $HeadSet(polygon) -fill white -outline black  -tags __Decoration__ ]
            if {$updateCommand != {}}   { 
                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $HeadSet(object)    group_HeadSet_Parameter_09
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
            set DownTube(Steerer)       [ rattleCAD::model::get_Position    DownTube_End        $BB_Position ]
            set DownTube(BBracket)      [ rattleCAD::model::get_Position    DownTube_Start      $BB_Position ]

            set Logo(Angle)             [ rattleCAD::model::get_Direction DownTube degree]
            set Logo(Direction)         [ rattleCAD::model::get_Direction DownTube ]
            set Logo(position)          [ vectormath::addVector [ vectormath::center $DownTube(BBracket) $DownTube(Steerer) ] $Logo(Direction) -90]
            set Logo(file)              [ checkFileString [rattleCAD::model::get_Component  Logo] ]
            set Logo(object)            [ $cv_Name readSVG $Logo(file) $Logo(position)    $Logo(Angle)  __Logo__ ]
                                          $cv_Name addtag  __Decoration__ withtag $Logo(object)
            if {$updateCommand != {}}   { 
                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $Logo(object)       single_LogoFile
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_Fender {cv_Name BB_Position type {updateCommand {}}} {
                #
            set Config(Fender_Front)     [rattleCAD::model::get_Config FrontFender]
            set Config(Fender_Rear)      [rattleCAD::model::get_Config RearFender]                
                # --- create Fender ------------------
            if {$Config(Fender_Rear) != {off}} { # --- create RearWheel Fender ----------
                set Hub(position)         [ rattleCAD::model::get_Position      RearWheel       $BB_Position ]
                set RearFender(polygon)   [ rattleCAD::model::get_Polygon       RearFender      $Hub(position)]
                set RearFender(object)    [ $cv_Name create polygon $RearFender(polygon) -fill white  -outline black  -tags __Fender__ ]
                                            $cv_Name addtag  __Decoration__ withtag $RearFender(object)
                
                if {$updateCommand != {}} {
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $RearFender(object)      group_FrontFender_Parameter_08
                }
            }
        
            if {$Config(Fender_Front) != {off}} { # --- create FrontWheel Fender ----------
                set Hub(position)         [ rattleCAD::model::get_Position      FrontWheel      $BB_Position]
                set FrontFender(polygon)  [ rattleCAD::model::get_Polygon       FrontFender     $Hub(position)]
                set FrontFender(object)   [ $cv_Name create polygon $FrontFender(polygon) -fill white  -outline black  -tags __Fender__ ]
                                            $cv_Name addtag  __Decoration__ withtag $FrontFender(object)
                
                if {$updateCommand != {}} { 
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $FrontFender(object)    group_FrontWheel_Parameter_03
                }
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_Fender_Rep {cv_Name BB_Position type {updateCommand {}}} {
                #
            set Config(Fender_Front)     [rattleCAD::model::get_Config FrontFender]
            set Config(Fender_Rear)      [rattleCAD::model::get_Config RearFender]
                # --- create Fender Representaton ----
            if {$Config(Fender_Rear) != {off}} { # --- create RearWheel Fender ----------
                set Hub(position)     [rattleCAD::model::get_Position       RearWheel   $BB_Position]
                set RimDiameter       [rattleCAD::model::get_Scalar Geometry RearRim_Diameter]
                set TyreHeight        [rattleCAD::model::get_Scalar Geometry RearTyre_Height]
                set FenderRadius      [expr 0.5 * $RimDiameter + $TyreHeight + 10]
                set AngleStart        [expr -360 - [rattleCAD::model::get_Direction ChainStay degree]]
                set AngleFender       [expr   90 - $AngleStart ]
                set my_Fender         [$cv_Name create arc   $Hub(position)  -radius $FenderRadius -start $AngleStart  -extent $AngleFender -style arc -outline gray40  -tags __Decoration__]
                if {$updateCommand != {}} {
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $my_Fender  option_RearFenderBinary
                }
            }
                #
            if {$Config(Fender_Front) != {off}} { # --- create FrontWheel Fender ----------
                set Hub(position)         [rattleCAD::model::get_Position   FrontWheel  $BB_Position]
                set RimDiameter           [rattleCAD::model::get_Scalar Geometry FrontRim_Diameter]
                set TyreHeight            [rattleCAD::model::get_Scalar Geometry FrontTyre_Height]
                set FenderRadius          [expr 0.5 * $RimDiameter + $TyreHeight + 10]
                set AngleStart            100
                set AngleFender            95
                set my_Fender             [$cv_Name create arc   $Hub(position)  -radius $FenderRadius -start $AngleStart  -extent $AngleFender -style arc -outline gray40  -tags __Decoration__]
                if {$updateCommand != {}} {
                    rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $my_Fender  option_FrontFenderBinary
                }
            }
                #
    }
    proc rattleCAD::rendering::createDecoration_CarrierFront {cv_Name BB_Position type {updateCommand {}}} {
                # --- create CarrierFront --------
            set CarrierFront(position)  [rattleCAD::model::get_Position     CarrierMount_Front  $BB_Position]
            set CarrierFront(file)      [ checkFileString [rattleCAD::model::get_Component  FrontCarrier] ]
            set CarrierFront(object)    [ $cv_Name readSVG $CarrierFront(file) $CarrierFront(position)  0  __CarrierFront__ ]
                                          $cv_Name addtag  __Decoration__ withtag $CarrierFront(object)
            if {$updateCommand != {}}   { 
                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $CarrierFront(object)   group_CarrierFront_Parameter_07
                    # $cv_Name bind    $CarrierFront(object)    <Double-ButtonPress-1> [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   file://Component(Carrier/Front/File)    Component(Carrier/Front/x)  Component(Carrier/Front/y)  }  {CarrierFront Parameter} ]
                    # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $CarrierFront(object)
            }
                #
    }  
    proc rattleCAD::rendering::createDecoration_CarrierRear {cv_Name BB_Position type {updateCommand {}}} {
                # --- create CarrierRear --------
            set CarrierRear(position)   [ rattleCAD::model::get_Position    CarrierMount_Rear    $BB_Position]
            set CarrierRear(file)       [ checkFileString [rattleCAD::model::get_Component  RearCarrier] ]
            set CarrierRear(object)     [ $cv_Name readSVG $CarrierRear(file) $CarrierRear(position)  0  __CarrierRear__ ]
                                          $cv_Name addtag  __Decoration__ withtag $CarrierRear(object)
            if {$updateCommand != {}}   { 
                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $CarrierRear(object)      group_CarrierRear_Parameter_11
                    # $cv_Name bind    $CarrierRear(object)    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  {   file://Component(Carrier/Rear/File) Component(Carrier/Rear/x)   Component(Carrier/Rear/y)   }  {CarrierRear Parameter}  ]
                    # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $CarrierRear(object)
            }
            
                #
    }  
    proc rattleCAD::rendering::createDecoration_RearWheel {cv_Name BB_Position type {updateCommand {}}} {
                # --- create RearWheel -----------------
            set Hub(position)           [ rattleCAD::model::get_Position             RearWheel        $BB_Position]
            set RimHeight               [ rattleCAD::model::get_Scalar RearWheel RimHeight   ]
            set RimDiameter             [ rattleCAD::model::get_Scalar Geometry RearRim_Diameter ]
            set TyreHeight              [ rattleCAD::model::get_Scalar Geometry RearTyre_Height ]
                                            $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter + $TyreHeight]     -tags {__Decoration__ __Tyre__}     -fill white
                                            $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter + 5]               -tags {__Decoration__ __Rim_01__}   -fill white
            set my_Rim                  [   $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter - 4]               -tags {__Decoration__ __Rim_02__}   -fill white ]
                                            $cv_Name create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter - $RimHeight + 5]  -tags {__Decoration__ __Rim_03__}   -fill white
                                          # $cv_Name create circle  $Hub(position)  -radius 45                                          -tags {__Decoration__ __Cassette__} -fill white
                                            $cv_Name create circle  $Hub(position)  -radius 23                                          -tags {__Decoration__ __Hub__}      -fill white
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
            set RimHeight           [ rattleCAD::model::get_Scalar FrontWheel RimHeight ]
            set RimDiameter         [ rattleCAD::model::get_Scalar Geometry FrontRim_Diameter ]
            set TyreHeight          [ rattleCAD::model::get_Scalar Geometry FrontTyre_Height ]
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
    proc rattleCAD::rendering::createDecoration_RearWheel_Rep {cv_Name BB_Position type {updateCommand {}}} {
                #
            set Hub(position)       [ rattleCAD::model::get_Position    RearWheel   $BB_Position ]
            set RimHeight           [ rattleCAD::model::get_Scalar RearWheel RimHeight ]
            set RimDiameter         [ rattleCAD::model::get_Scalar Geometry RearRim_Diameter ]
            set TyreHeight          [ rattleCAD::model::get_Scalar Geometry RearTyre_Height ]
            set my_Wheel            [ $cv_Name create arc   $Hub(position)  -radius [expr 0.5 * $RimDiameter + $TyreHeight] -start -20  -extent 105 -style arc -outline gray60  -tags __Decoration__]
            set my_Wheel            [ $cv_Name create arc   $Hub(position)  -radius [expr 0.5 * $RimDiameter ]              -start -25  -extent 100 -style arc -outline gray60  -tags __Decoration__  -width 0.35]
                #
    }
    proc rattleCAD::rendering::createDecoration_FrontWheel_Rep {cv_Name BB_Position type {updateCommand {}}} {
                #
            set Hub(position)       [ rattleCAD::model::get_Position    FrontWheel  $BB_Position ]
            set RimHeight           [ rattleCAD::model::get_Scalar      FrontWheel  RimHeight]
            set RimDiameter         [ rattleCAD::model::get_Scalar Geometry FrontRim_Diameter]
            set TyreHeight          [ rattleCAD::model::get_Scalar Geometry FrontTyre_Height]
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
       

    proc rattleCAD::rendering::debug_geometry {cv_Name BB_Position} {
            puts ""
            puts "   -------------------------------"
            puts "    debug_geometry"
            puts "           ... please reimplement !"
            puts ""
                # tk_messageBox -message "debug_geometry"
            
            set debug_Geometry  [rattleCAD::model::get_DebugGeometry]
            foreach key [dict keys $debug_Geometry] {
                puts "[format "         %20s ... %s"  $key [dict get $debug_Geometry $key] ]"
            }
            return 

            # foreach position [array names bikeGeometry::DEBUG_Geometry] 
                    # puts "       name:            $position    $bikeGeometry__DEBUG_Geometry($position)"
                # set myPosition            [ rattleCAD__model__getObject        DEBUG_Geometry            $bikeGeometry__DEBUG_Geometry($position)    $BB_Position ]
                # puts "         ... $position  $bikeGeometry__DEBUG_Geometry($position)"
                # puts "                    + ($BB_Position)"
                # puts "             -> $myPosition"
                # $cv_Name create circle     $myPosition   -radius 5  -outline orange  -tags {__CenterLine__} -width 2.0
            # 
    }


    proc rattleCAD::rendering::createFrame_Tubes {cv_Name BB_Position {updateCommand {}}} {

        set domInit     $::APPL_Config(root_InitDOM)

            # --- get stageScale
        set stageScale     [ $cv_Name  getNodeAttr  Stage    scale ]

            # --- set tubeColour
            # set tubeColour "gray90"
        set tubeColour         "white"


            # --- create HeadTube --------------------
        set HeadTube(polygon)       [ rattleCAD::model::get_Polygon     HeadTube            $BB_Position  ]
        set HeadTube(object)        [ $cv_Name create polygon $HeadTube(polygon) -fill $tubeColour -outline black  -tags __HeadTube__]
                                      $cv_Name addtag  __Frame__ withtag $HeadTube(object)
        if {$updateCommand != {}}   { 
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $HeadTube(object)   single_HeadTube_Diameter
                # $cv_Name bind    $HeadTube(object)   <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  { FrameTubes(HeadTube/Diameter) }  {HeadTube Parameter} ]
                # rattleCAD::view::gui::object_CursorBinding    $cv_Name    $HeadTube(object)
        }

            # --- create DownTube --------------------
        set DownTube(polygon)       [ rattleCAD::model::get_Polygon     DownTube            $BB_Position  ]
        set DownTube(object)        [ $cv_Name create polygon $DownTube(polygon) -fill $tubeColour -outline black  -tags __DownTube__]
                                      $cv_Name addtag  __Frame__ withtag $DownTube(object)
        if {$updateCommand != {}}   { 
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $DownTube(object)   group_DownTube_Parameter_06
                # $cv_Name bind    $DownTube(object)    <Double-ButtonPress-1> [list rattleCAD::view::createEdit  %x %y  $cv_Name  { FrameTubes(DownTube/DiameterHT) FrameTubes(DownTube/DiameterBB) FrameTubes(DownTube/TaperLength)    }  {DownTube Parameter} ]
                # rattleCAD::view::gui::object_CursorBinding    $cv_Name    $DownTube(object)
        }

            # --- create SeatTube --------------------
        set SeatTube(polygon)       [ rattleCAD::model::get_Polygon     SeatTube            $BB_Position  ]
        set SeatTube(object)        [ $cv_Name create polygon $SeatTube(polygon) -fill $tubeColour -outline black  -tags __SeatTube__]
                                      $cv_Name addtag  __Frame__ withtag $SeatTube(object)
        if {$updateCommand != {}}   { 
                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $SeatTube(object)   group_SeatTube_Parameter_05
                    # $cv_Name bind    $SeatTube(object)   <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  { Lugs(SeatTube/SeatStay/MiterDiameter)  FrameTubes(SeatTube/DiameterTT) FrameTubes(SeatTube/DiameterBB) FrameTubes(SeatTube/TaperLength)    }  {SeatTube Parameter} ]
                    # rattleCAD::view::gui::object_CursorBinding    $cv_Name    $SeatTube(object)
            }

            # --- create TopTube ---------------------
        set TopTube(polygon)        [ rattleCAD::model::get_Polygon     TopTube             $BB_Position  ]
        set TopTube(object)         [ $cv_Name create polygon $TopTube(polygon) -fill $tubeColour -outline black  -tags __TopTube__]
                                      $cv_Name addtag  __Frame__ withtag $TopTube(object)
        if {$updateCommand != {}}   { 
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $TopTube(object)    group_TopTube_Parameter_04
                # $cv_Name bind    $TopTube(object)    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  { FrameTubes(TopTube/DiameterHT) FrameTubes(TopTube/DiameterST)  FrameTubes(TopTube/TaperLength) Custom(TopTube/Angle)   }  {TopTube Parameter} ]
                # rattleCAD::view::gui::object_CursorBinding    $cv_Name    $TopTube(object)
        }

            # --- create Rear Dropout ----------------
        set RearWheel(position)     [ rattleCAD::model::get_Position    RearWheel           $BB_Position]
        set RearDropout(file)       [ checkFileString [rattleCAD::model::get_Component RearDropout] ]
        set RearDropout(angle)      [ rattleCAD::model::get_Direction   RearDropout degree]
        set Config(RearDropOut)     [ rattleCAD::model::get_Config      RearDropout ]
            #
        set RearDropout(angle)      [ expr 360 - $RearDropout(angle) ] 
            # puts " <H>  \$RearDropout(angle)   $RearDropout(angle)"  
        
            # --- Rear Dropout behind Chain- and SeatStay 
        if {$Config(RearDropOut) != {front}} {
            set RearDropout(object) [ $cv_Name readSVG [file join $::APPL_Config(COMPONENT_Dir) $RearDropout(file)] $RearWheel(position)  $RearDropout(angle)  __RearDropout__]
        }


            # --- create ChainStay -------------------
        set ChainStay(polygon)      [ rattleCAD::model::get_Polygon     ChainStay           $BB_Position  ]
        set ChainStay(object)       [ $cv_Name create polygon $ChainStay(polygon) -fill $tubeColour -outline black  -tags __ChainStay__]
                                      $cv_Name addtag  __Frame__ withtag $ChainStay(object)
        if {$updateCommand != {}}   { 
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $ChainStay(object)      group_ChainStay_Parameter_01
                # $cv_Name bind    $ChainStay(object)    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $cv_Name  { FrameTubes(ChainStay/DiameterSS)  FrameTubes(ChainStay/Height)    FrameTubes(ChainStay/HeightBB)  FrameTubes(ChainStay/TaperLength)   Lugs(RearDropOut/ChainStay/OffsetPerp)  Lugs(RearDropOut/ChainStay/Offset)  }  {ChainStay Parameter}]
                # rattleCAD::view::gui::object_CursorBinding    $cv_Name    $ChainStay(object)
        }

            # --- create SeatStay --------------------
        set SeatStay(polygon)       [ rattleCAD::model::get_Polygon     SeatStay            $BB_Position  ]
        set SeatStay(object)        [ $cv_Name create polygon $SeatStay(polygon) -fill $tubeColour -outline black  -tags __SeatStay__]
                                      $cv_Name addtag  __Frame__ withtag $SeatStay(object)
        if {$updateCommand != {}}   { 
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $SeatStay(object)   group_SeatStay_Parameter_01
                # $cv_Name bind    $SeatStay(object)    <Double-ButtonPress-1>    [list rattleCAD::view::createEdit  %x %y  $cv_Name  { Lugs(SeatTube/SeatStay/MiterDiameter) FrameTubes(SeatStay/DiameterST) FrameTubes(SeatStay/DiameterCS) FrameTubes(SeatStay/TaperLength)    Custom(SeatStay/OffsetTT)   Lugs(RearDropOut/SeatStay/OffsetPerp)   Lugs(RearDropOut/SeatStay/Offset)   }  {SeatStay Parameter}]
                # rattleCAD::view::gui::object_CursorBinding    $cv_Name    $SeatStay(object)
        }
            # --- Rear Dropout in front of Chain- and SeatStay 
        if {$Config(RearDropOut) == {front}} {
            set RearDropout(object) [ $cv_Name readSVG [file join $::APPL_Config(COMPONENT_Dir) $RearDropout(file)] $RearWheel(position)  $RearDropout(angle)  __RearDropout__]
        }
            # --- handle Rear Dropout - properties ---
        $cv_Name addtag  __Frame__ withtag $RearDropout(object)
        if {$updateCommand != {}}   { 
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $RearDropout(object)    group_RearDropout_Parameter_01
                # $cv_Name bind     $RearDropout(object)    <Double-ButtonPress-1> [list rattleCAD::view::createEdit  %x %y  $cv_Name  { file://Lugs(RearDropOut/File)   list://Lugs(RearDropOut/Direction@SELECT_DropOutDirection)    list://Rendering(RearDropOut@SELECT_DropOutPosition)    Lugs(RearDropOut/RotationOffset)    Lugs(RearDropOut/Derailleur/x)  Lugs(RearDropOut/Derailleur/y)  Lugs(RearDropOut/SeatStay/OffsetPerp)   Lugs(RearDropOut/SeatStay/Offset)   Lugs(RearDropOut/ChainStay/OffsetPerp)  Lugs(RearDropOut/ChainStay/Offset)                               }  {RearDropout Parameter}]
                # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $RearDropout(object)
        }
                
                
                

            # --- create BottomBracket ---------------
        set BottomBracket(outerDiameter)    [rattleCAD::model::get_Scalar BottomBracket OutsideDiameter]
        set BottomBracket(innerDiameter)    [rattleCAD::model::get_Scalar BottomBracket InsideDiameter]
        set BottomBracket(object_1)         [ $cv_Name create circle  $BB_Position  -radius [expr 0.5 * $BottomBracket(outerDiameter)]    -fill $tubeColour    -tags {__Frame__  __BottomBracket__  outside} ]
        set BottomBracket(object_2)         [ $cv_Name create circle  $BB_Position  -radius [expr 0.5 * $BottomBracket(innerDiameter)]    -fill $tubeColour    -tags {__Frame__  __BottomBracket__  inside} ]
        set BottomBracket(object)   __BottomBracket__
        $cv_Name addtag $BottomBracket(object) withtag $BottomBracket(object_1)
        $cv_Name addtag $BottomBracket(object) withtag $BottomBracket(object_2)
        if {$updateCommand != {}}   { 
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    __BottomBracket__      group_BottomBracket_Diameter_01
                # $cv_Name bind    __BottomBracket__    <Double-ButtonPress-1> [list rattleCAD::view::createEdit  %x %y  $cv_Name  { Lugs(BottomBracket/Diameter/outside)  Lugs(BottomBracket/Diameter/inside))    }  {BottomBracket Diameter} ]
                # rattleCAD::view::gui::object_CursorBinding     $cv_Name    $BottomBracket(object)
         }
         
    }


    proc rattleCAD::rendering::createCrank_Custom {cv_Name BB_Position} {
        variable crankLength    [rattleCAD::model::get_Scalar CrankSet Length]
        variable teethCount     [lindex [lsort [split [rattleCAD::model::get_ListValue CrankSetChainRings] -]] end]
        variable decoRadius     80

                puts ""
                puts "   -------------------------------"
                puts "   createCrank_Custom"
                puts "       crankLength:    $crankLength"
                puts "       teethCount:     $teethCount"

        set polygonChainWheel   [_get_polygonChainWheel  $BB_Position]
        set polygonCrankArm     [_get_polygonCrankArm    $BB_Position]
        set positon_00          $BB_Position
        set positon_01          [vectormath::addVector $BB_Position [list $crankLength 0]]

        set chainWheel          [$cv_Name create polygon    $polygonChainWheel  -tags {__Decoration__ __Crankset__ __ChainWheel__}      -fill white  -outline black]
        set chainWheelRing      [$cv_Name create circle     $positon_00         -tags {__Decoration__ __Crankset__ __ChainWheelRing__}  -fill white  -outline black  -radius  $decoRadius ]
        set crankArm            [$cv_Name create polygon    $polygonCrankArm    -tags {__Decoration__ __Crankset__ __CrankArm__}        -fill white  -outline black]
        set pedalMount          [$cv_Name create circle     $positon_01         -tags {__Decoration__ __Crankset__ __PedalMount__}      -fill white  -outline black  -radius  6 ]
        set crankAxle           [$cv_Name create circle     $positon_00         -tags {__Decoration__ __Crankset__ __PedalMount__}      -fill white  -outline black  -radius 10 ]

        set tagName myTags
        $cv_Name addtag $tagName withtag $chainWheel
        $cv_Name addtag $tagName withtag $chainWheelRing
        $cv_Name addtag $tagName withtag $crankArm
        return $tagName
    } 


    proc rattleCAD::rendering::_get_polygonChainWheel {BB_Position} {
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
    proc rattleCAD::rendering::_get_polygonCrankArm {BB_Position} {
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


    proc rattleCAD::rendering::createFork {cv_Name BB_Position {updateCommand {}} } {

        set domInit     $::APPL_Config(root_InitDOM)

            # --- get stageScale
        set stageScale  [ $cv_Name  getNodeAttr  Stage  scale ]

            # --- set tubeColour
            # set tubeColour "gray90"
        set tubeColour      "white"

            # --- get Rendering Style
        set Config(Fork)         [ rattleCAD::model::get_Config Fork]
        set Config(ForkBlade)    [ rattleCAD::model::get_Config ForkBlade]
        set Config(ForkDropOut)  [ rattleCAD::model::get_Config ForkDropout]
        
            # tk_messageBox -message "Rendering(ForkDropOut): $Rendering(ForkDropOut)"
 
            # --- create Steerer ---------------------
        set Steerer(polygon)        [ rattleCAD::model::get_Polygon     Steerer         $BB_Position  ]
        set Steerer(object)         [ $cv_Name create polygon $Steerer(polygon) -fill white -outline black -tags __Frame__ ]
            #
        set RearWheel(position)     [ rattleCAD::model::get_Position    RearWheel       $BB_Position]
            #
        set ht_direction            [ rattleCAD::model::get_Direction   ForkCrown ]
        set ht_angle                [ rattleCAD::model::get_Direction   ForkCrown   degree]
            #

            # --- create Fork Representation ----------------
            # puts "          ... \$Rendering(Fork)    $Rendering(Fork)"
            #
        set ForkBlade(polygon)      [ rattleCAD::model::get_Polygon     ForkBlade       $BB_Position ]
        set ForkCrown(file)         [ checkFileString [rattleCAD::model::get_Component  ForkCrown]   ]
        set ForkDropout(file)       [ checkFileString [rattleCAD::model::get_Component  ForkDropout] ]
        set do_direction            [ rattleCAD::model::get_Direction   ForkDropout ]
        set do_angle                [ expr -90 + [ vectormath::angle $do_direction {0 0} {-1 0} ] ]
        set ForkDropout(position)   [ rattleCAD::model::get_Position    FrontWheel      $BB_Position ]
            #
        switch -glob $Config(Fork) {
                Suspension* {
                            # puts "\n------------------\n                now Rendering   ... $Rendering(Fork)\n------------------\n"
                        set do_direction            [ rattleCAD::model::get_Direction   HeadTube ]
                        set do_angle                [ vectormath::angle {0 1} {0 0} $do_direction ]
                        set ForkDropout(position)   [ rattleCAD::model::get_Position    FrontDropout_MockUp    $BB_Position ] 
                            #
                            # puts "  <-2-> $ForkDropout(position)"
                            # set ForkDropout(position)   [ rattleCAD::model::get_Position    FrontWheel    $BB_Position ]   
                    }
                Suspension___remove {
                            #puts "\n------------------\n                now Rendering   ... $Rendering(Fork)\n------------------\n"
                        set forkSize [lindex [split $Config(Fork) {_}] 1 ]
                        if {$forkSize == {} } { set forkSize "26" }
                        puts "             ... \$forkSize  $forkSize"
                            #
                        set do_direction            [ rattleCAD::model::get_Direction   HeadTube ]
                        set do_angle                [ vectormath::angle {0 1} {0 0} $do_direction ]
                            #
                        set Geometry_ForkRake       [ rattleCAD::model::get_Scalar Geometry Fork_Rake]
                        set SuspensionFork_Rake     [ rattleCAD::model::get_Scalar Fork Rake]
                            # puts "\n <-> \$SuspensionFork_Rake $SuspensionFork_Rake\n"
                        set offset                  [ expr $Geometry_ForkRake - $SuspensionFork_Rake]
                        set offset_x                [ expr -1.0 * $offset/sin([vectormath::rad [expr 180 - $ht_angle]]) ]
                            # puts "   -> \$offset_x $offset_x"
                        set vct_move [list $offset_x 0]
                            #
                        set ForkDropout(position)   [ vectormath::addVector [ rattleCAD::model::get_Position    FrontWheel    $BB_Position ] $vct_move]
                            #
                    }
                default {}
        }
        
            # puts "          ... \$ForkBlade(polygon) [string range $ForkBlade(polygon) 0 50] ..."
            # puts "          ... \$ForkCrown(file)    $ForkCrown(file)"
            # puts "          ... \$ForkDropout(file)  $ForkDropout(file)"

            # --- create Fork Dropout ---------------
        if {$Config(ForkDropOut) == {behind}} {
            set ForkDropout(object)     [ $cv_Name readSVG [file join $::APPL_Config(COMPONENT_Dir) $ForkDropout(file)] $ForkDropout(position) $do_angle  __ForkDropout__]
            $cv_Name addtag  __Frame__ withtag $ForkDropout(object)
        }

            # --- create Fork Blade -----------------
        set ForkBlade(object)       [ $cv_Name create polygon $ForkBlade(polygon) -fill $tubeColour  -outline black -tags __ForkBlade__]
                                      $cv_Name addtag  __Frame__ withtag $ForkBlade(object)

        switch -exact $updateCommand {
            editable {
                    switch -glob $Config(Fork) {
                        SteelLugged -
                        SteelCustom {
                            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $ForkBlade(object)  group_ForkBlade_Parameter
                        }
                        default {}
                    }
                }
            selectable {            
                            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $ForkBlade(object)  option_ForkType
                }   
            default {}
        }                                                   


            # --- create ForkCrown -------------------
        set renderAngle     [ expr $ht_angle -90 ]
            #
        set ForkCrown(position)     [ rattleCAD::model::get_Position    ForkCrown  $BB_Position ]
        set ForkCrown(object)       [ $cv_Name readSVG [file join $::APPL_Config(COMPONENT_Dir) $ForkCrown(file)] $ForkCrown(position) $renderAngle __ForkCrown__ ]
                                      $cv_Name addtag  __Frame__ withtag $ForkCrown(object)
                #
        switch -exact $updateCommand {
            editable {              
                    switch $Config(Fork) {
                        SteelLugged -
                        SteelCustom {            
                            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $ForkCrown(object)  group_ForkCrown_Parameter
                            }
                        default {            
                            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $ForkCrown(object)  option_ForkType
                            }
                    }
                }      
            selectable {            
                            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $ForkCrown(object)  option_ForkType
                }
            default {}
        }

            # --- create Fork Dropout ---------------
        if {$Config(ForkDropOut) == {front}} {
            set ForkDropout(object)     [ $cv_Name readSVG [file join $::APPL_Config(COMPONENT_Dir) $ForkDropout(file)] $ForkDropout(position) $do_angle  __ForkDropout__]
            $cv_Name addtag  __Frame__ withtag $ForkDropout(object)
        }
            # --- set Fork Dropout Edit -----------------
        switch -exact $updateCommand {
            editable { 
                    switch $Config(Fork) {
                        SteelLugged -
                        SteelCustom { 
                            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $ForkDropout(object)  group_ForkDropout_Parameter
                        }
                        default {}
                    }
                }
            default {}
        }

            # --- check bindings and remove ----------
        switch $Config(Fork) {
            Composite        -
            Suspension       -
            Suspension_26    -
            Suspension_28    -
            Suspension_29   {}
            default         {}
        }
            #
        $cv_Name create circle  $ForkDropout(position)    -radius 4.5    -fill white    -tags __Frame__
            #
        return
            #
    }


    proc rattleCAD::rendering::createChain {cv_Name BB_Position} {
        set crankWheelTeethCount     [lindex [lsort [split [rattleCAD::model::get_ListValue CrankSetChainRings] -]] end]
        set casetteTeethCount        15
        set toothWith                12.7
        
              # puts ""
              # puts "   -------------------------------"
              # puts "    createChain"
              # puts "       teethCount:     $crankWheelTeethCount / $casetteTeethCount"   
                
        set Hub(position)           [ rattleCAD::model::get_Position    RearWheel           $BB_Position ]
        set Derailleur(position)    [ rattleCAD::model::get_Position    RearDerailleur      $BB_Position]
        
        set Pulley(x)               [ rattleCAD::model::get_Scalar      RearDerailleur Pulley_x      ]
        set Pulley(y)               [ rattleCAD::model::get_Scalar      RearDerailleur Pulley_y      ]
        set Pulley(teeth)           [ rattleCAD::model::get_Scalar      RearDerailleur Pulley_teeth  ]
        
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


    proc rattleCAD::rendering::createFrame_Centerline {cv_Name BB_Position} {
    
    
                # --- get stageScale
            set stageScale     [ $cv_Name  getNodeAttr  Stage    scale ]
    
    
                # --- get defining Values ----------
            set CrankSetLength      [ rattleCAD::model::get_Scalar CrankSet Length]
                # --- get defining Point coords ----------
            set BottomBracket       $BB_Position
            set RearWheel           [ rattleCAD::model::get_Position        RearWheel               $BB_Position ]
            set FrontWheel          [ rattleCAD::model::get_Position        FrontWheel              $BB_Position ]
            set Saddle              [ rattleCAD::model::get_Position        Saddle                  $BB_Position ]
            set Saddle_Proposal     [ rattleCAD::model::get_Position        SaddleProposal          $BB_Position ]
            set SeatPost_Saddle     [ rattleCAD::model::get_Position        SeatPost_Saddle         $BB_Position ]
            set SeatPost_SeatTube   [ rattleCAD::model::get_Position        SeatPost_SeatTube       $BB_Position ]
            set SeatPost_Pivot      [ rattleCAD::model::get_Position        SeatPost_Pivot          $BB_Position ]
            set SeatTube_Ground     [ rattleCAD::model::get_Position        SeatTube_Ground         $BB_Position ]
            set SeatTube_BBracket   [ rattleCAD::model::get_Position        SeatTube_Start          $BB_Position ]
            set SeatStay_SeatTube   [ rattleCAD::model::get_Position        SeatStay_End            $BB_Position ]
            set SeatStay_RearWheel  [ rattleCAD::model::get_Position        SeatStay_Start          $BB_Position ]
            set TopTube_SeatTube    [ rattleCAD::model::get_Position        TopTube_Start           $BB_Position ]
            set TopTube_SeatVirtual [ rattleCAD::model::get_Position        SeatTube_VirtualTopTube $BB_Position ]
            set TopTube_Steerer     [ rattleCAD::model::get_Position        TopTube_End             $BB_Position ]
            set HeadTube_Stem       [ rattleCAD::model::get_Position        HeadTube_End            $BB_Position ]
            set TopTube_HeadVirtual [ rattleCAD::model::get_Position        HeadTube_VirtualTopTube $BB_Position ]
            set Steerer_Stem        [ rattleCAD::model::get_Position        Steerer_End             $BB_Position ]
            set Steerer_Fork        [ rattleCAD::model::get_Position        Steerer_Start           $BB_Position ]
            set DownTube_Steerer    [ rattleCAD::model::get_Position        DownTube_End            $BB_Position ]
            set HandleBar           [ rattleCAD::model::get_Position        HandleBar               $BB_Position ]
            set BaseCenter          [ rattleCAD::model::get_Position        BottomBracket_Ground    $BB_Position ]
            set Steerer_Ground      [ rattleCAD::model::get_Position        Steerer_Ground          $BB_Position ]
                #
            set ChainStay_Dropout   [ rattleCAD::model::get_Position        ChainStay_RearWheel     $BB_Position ]
                #
            set Saddle_PropRadius   [ vectormath::length    $Saddle_Proposal   $BB_Position]
            set SeatTube_Angle      [ vectormath::angle     $SeatPost_SeatTube $BB_Position [list -500 [lindex $BB_Position 1] ] ]
            set SeatPost_Radius     [ vectormath::length    $SeatPost_Saddle   $SeatPost_Pivot] 
                #
            set RimDiameter_Front   [rattleCAD::model::get_Scalar Geometry FrontRim_Diameter]
            set TyreHeight_Front    [rattleCAD::model::get_Scalar Geometry FrontTyre_Height]
            set RimDiameter_Rear    [rattleCAD::model::get_Scalar Geometry RearRim_Diameter]
            set TyreHeight_Rear     [rattleCAD::model::get_Scalar Geometry RearTyre_Height]
                #

                #
            set highlightList_1 {} 
            set highlightList_2 {} 
            set highlightList_3 {baseLine frontWheel rearWheel}
            set backgroundList  {}
            set excludeList     {}
                #
            switch -exact $rattleCAD::view::gui::frame_configMethod {
                {OutsideIn} {
                            set highlightList_1 {chainstay fork saddle seattube steerer stem } 
                            set highlightList_2 {} 
                        }
                {StackReach} {
                            set highlightList_1 {chainstay fork saddle seattube steerer} 
                            set highlightList_2 {seatpost stem} 
                        }
                {Classic} {
                            set highlightList_1 {chainstay fork saddle steerer virtualtoptube} 
                            set highlightList_2 {seatpost stem} 
                        }
                {Lugs} {
                            set highlightList_1 {chainstay downtube fork saddle seattube steerer stem} 
                            set highlightList_2 {seatpost}
                                #
                            $cv_Name create line    [ appUtil::flatten_nestedList  $RearWheel    $ChainStay_Dropout  $BottomBracket ]       -fill gray60  -width 1.0      -tags {__CenterLine__    chainstaydropout}
                            $cv_Name create circle  $ChainStay_Dropout                                                       -radius 7   -outline gray60  -width 1.0      -tags {__CenterLine__    chainstaydropout}  
                        }
                default {}
            }     
                #
                
    
                # ------ rearwheel representation
            $cv_Name create circle     $RearWheel   -radius [ expr 0.5*$RimDiameter_Rear + $TyreHeight_Rear ]    -outline gray60 -width 1.0    -tags {__CenterLine__    rearWheel}
                # ------ frontwheel representation
            $cv_Name create circle     $FrontWheel  -radius [ expr 0.5*$RimDiameter_Front + $TyreHeight_Front ]  -outline gray60 -width 1.0    -tags {__CenterLine__    frontWheel}
    
    
                # ------ headtube extension to ground
            $cv_Name create centerline [ appUtil::flatten_nestedList  $Steerer_Fork       $Steerer_Ground   ]    -fill gray60                  -tags __CenterLine__
                # ------ seattube extension to ground
            $cv_Name create centerline [ appUtil::flatten_nestedList  $SeatTube_BBracket  $SeatTube_Ground  ]    -fill gray60                  -tags {__CenterLine__    seattube_center}
                
    
                # ------ chainstay
            $cv_Name create line     [ appUtil::flatten_nestedList  $RearWheel            $BottomBracket    ]    -fill gray60  -width 1.0      -tags {__CenterLine__    chainstay}
                # ------ seatpost
            $cv_Name create line     [ appUtil::flatten_nestedList  $SeatStay_SeatTube    $RearWheel        ]    -fill gray60  -width 1.0      -tags {__CenterLine__    seatstay}
                # ------ toptube
            $cv_Name create line     [ appUtil::flatten_nestedList  $TopTube_SeatTube     $TopTube_Steerer  ]    -fill gray60  -width 1.0      -tags {__CenterLine__    toptube}
                # ------ downtube
            $cv_Name create line     [ appUtil::flatten_nestedList  $DownTube_Steerer     $BB_Position      ]    -fill gray60  -width 1.0      -tags {__CenterLine__    downtube}
                # ------ fork
            $cv_Name create line     [ appUtil::flatten_nestedList  $Steerer_Fork         $FrontWheel       ]    -fill gray60  -width 1.0      -tags {__CenterLine__    fork}
    
                
                # ------ saddlemount
            $cv_Name create line     [ appUtil::flatten_nestedList  $Saddle $SeatPost_Saddle ] -fill gray60  -width 0.5      -tags {__CenterLine__    saddlemount}
    
    
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
                    set x_04   [ expr [rattleCAD::model::get_Scalar Saddle  NoseLength] + [rattleCAD::model::get_Scalar Saddle Offset_x] ]
                    set x_03   [ expr $x_04 - 20 ]
                    set x_02   [ expr $x_04 - 30 ]
                    set x_01   [ expr $x_04 - [rattleCAD::model::get_Scalar Saddle Length]]
                    foreach xy [ list [list $x_01 4] {0 0} [list $x_02 -1] [list $x_03 -5] [list $x_04 -12] ] {
                        set saddle_polygon [ lappend saddle_polygon [vectormath::addVector $Saddle $xy ] ]
                    }
            $cv_Name create line  $saddle_polygon        -fill gray60  -width 1.0      -tags {__CenterLine__    saddle}

    
                # ------ virtual top- and seattube 
            switch -exact $rattleCAD::view::gui::frame_configMethod {
                {OutsideIn} {
                                # ------ stem
                            $cv_Name create line    [ appUtil::flatten_nestedList  $HandleBar $Steerer_Stem $HeadTube_Stem ]                -fill gray60  -width 1.0      -tags {__CenterLine__    stem}
                                # ------ steerer
                            $cv_Name create line    [ appUtil::flatten_nestedList  $HeadTube_Stem    $Steerer_Fork]                         -fill gray60  -width 1.0      -tags {__CenterLine__    steerer}
                                # ------ seattube
                            $cv_Name create line    [ appUtil::flatten_nestedList  $SeatPost_Saddle  $SeatPost_SeatTube $SeatTube_BBracket] -fill gray60  -width 1.0      -tags {__CenterLine__    seattube}
                        }
                {StackReach} {
                                # ------ stem
                            $cv_Name create line    [ appUtil::flatten_nestedList  $HandleBar $Steerer_Stem $HeadTube_Stem ]                -fill gray60  -width 1.0      -tags {__CenterLine__    stem}
                                # ------ steerer
                            $cv_Name create line    [ appUtil::flatten_nestedList  $HeadTube_Stem    $Steerer_Fork]                         -fill gray60  -width 1.0      -tags {__CenterLine__    steerer}
                                # ------ seatpost
                            $cv_Name create line    [ appUtil::flatten_nestedList  $SeatPost_Saddle  $SeatPost_SeatTube $TopTube_SeatTube]  -fill gray60  -width 1.0      -tags {__CenterLine__    seatpost}
                                # ------ seattube
                            $cv_Name create line    [ appUtil::flatten_nestedList  $TopTube_SeatVirtual $SeatTube_BBracket]                 -fill gray60  -width 1.0      -tags {__CenterLine__    seattube}
                        }
                {Lugs} {
                                # ------ stem
                            $cv_Name create line    [ appUtil::flatten_nestedList  $HandleBar $Steerer_Stem $TopTube_HeadVirtual ]          -fill gray60  -width 1.0      -tags {__CenterLine__    stem}
                                # ------ steerer
                            $cv_Name create line    [ appUtil::flatten_nestedList  $TopTube_HeadVirtual    $Steerer_Fork]                   -fill gray60  -width 1.0      -tags {__CenterLine__    steerer}
                                # ------ seatpost
                            $cv_Name create line    [ appUtil::flatten_nestedList  $SeatPost_Saddle  $SeatPost_SeatTube $TopTube_SeatTube]  -fill gray60  -width 1.0      -tags {__CenterLine__    seatpost}
                                # ------ seattube
                            $cv_Name create line    [ appUtil::flatten_nestedList  $TopTube_SeatVirtual $SeatTube_BBracket]                 -fill gray60  -width 1.0      -tags {__CenterLine__    seattube}
                        }
                {Classic} {
                                # ------ stem
                            $cv_Name create line    [ appUtil::flatten_nestedList  $HandleBar $Steerer_Stem $TopTube_HeadVirtual ]          -fill gray60  -width 1.0      -tags {__CenterLine__    stem}
                                # ------ steerer
                            $cv_Name create line    [ appUtil::flatten_nestedList  $TopTube_HeadVirtual $Steerer_Fork]                           -fill gray60  -width 1.0  -tags {__CenterLine__    steerer}
                                # ------ seatpost
                            $cv_Name create line    [ appUtil::flatten_nestedList  $SeatPost_Saddle  $SeatPost_SeatTube $TopTube_SeatVirtual]    -fill gray60  -width 1.0  -tags {__CenterLine__    seatpost}
                                # ------ virtualtoptube
                            $cv_Name create line    [ appUtil::flatten_nestedList  $TopTube_HeadVirtual $TopTube_SeatVirtual $SeatTube_BBracket] -fill gray60  -width 1.0  -tags {__CenterLine__    virtualtoptube}
                        }       
                default {}
            }     
                #
                # puts "  $highlightList "
                # --- highlightList
                    # set highlight(colour) firebrick
                    # set highlight(colour) darkorchid
                    # set highlight(colour) darkred
                    # set highlight(colour) firebrick
                    # set highlight(colour) blue
                set highlight(colour) red
                set highlight(width)  2.0
                    #
                # --- create position points
            $cv_Name create circle  $BottomBracket          -radius 20  -outline $highlight(colour)     -tags {__CenterLine__  bottombracket}  \
                                                                                                                                -width $highlight(width)
            $cv_Name create circle  $HandleBar              -radius 15  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
            $cv_Name create circle  $Saddle                 -radius 15  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
            $cv_Name create circle  $FrontWheel             -radius 15  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
            $cv_Name create circle  $RearWheel              -radius 15  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
            $cv_Name create circle  $BaseCenter             -radius 15  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
            $cv_Name create circle  $SeatPost_Saddle        -radius 10  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
                #
            switch -exact $rattleCAD::view::gui::frame_configMethod {
                {StackReach} {  $cv_Name create circle  $HeadTube_Stem          -radius 10  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)    }
                {Classic}    {  $cv_Name create circle  $TopTube_HeadVirtual    -radius 10  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)    }       
                default { }
            }


            # $cv_Name create circle    $SeatPost_SeatTube  -radius 15  -outline $highlight(colour)     -tags {__CenterLine__}  -width $highlight(width)
                # $cv_Name create circle    $LegClearance   -radius 10  -outline $highlight(colour)
  
                    #
                    #
                    #
                    #
                set highlight(colour) red
                set highlight(width)  3.0
                    # ------------------------
            foreach item $highlightList_1 {
                catch {$cv_Name itemconfigure $item  -fill      $highlight(colour) -width $highlight(width) } error
                catch {$cv_Name itemconfigure $item  -outline   $highlight(colour) -width $highlight(width) } error
            }
    
                set highlight(colour) darkorange
                set highlight(colour) orange
                set highlight(colour) goldenrod
                set highlight(colour) gray70
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
            #foreach item {steerer fork bottombracket} {}
            #    rattleCAD::view::gui::object_CursorBinding     $cv_Name    $item 
            #{}
            
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    stem            group_FrontGeometry
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    steerer         group_FrontGeometry
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    fork            group_FrontGeometry
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    bottombracket   group_BottomBracket_DepthHeight
       
        }


    proc rattleCAD::rendering::create_copyReference {cv_Name BB_Position} {
                
                # --- get stageScale
            set stageScale     [ $cv_Name  getNodeAttr  Stage    scale ]

                # --- get defining Point coords ----------
            set BottomBracket         $BB_Position
            set RearWheel             [ rattleCAD::model::get_Position      RearWheel               $BB_Position ]
            set FrontWheel            [ rattleCAD::model::get_Position      FrontWheel              $BB_Position ]
            set SeatPost_Saddle       [ rattleCAD::model::get_Position      SeatPostSaddle          $BB_Position ]
            set HandleBar             [ rattleCAD::model::get_Position      HandleBar               $BB_Position ]
            set SeatTube_Ground       [ rattleCAD::model::get_Position      SeatTubeGround          $BB_Position ]
            set Steerer_Ground        [ rattleCAD::model::get_Position      SteererGround           $BB_Position ]
            set Reference_HB          [ rattleCAD::model::get_Position      Reference_HB            $BB_Position ]
            set Reference_SN          [ rattleCAD::model::get_Position      Reference_SN            $BB_Position ]
           
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


    
    
    




