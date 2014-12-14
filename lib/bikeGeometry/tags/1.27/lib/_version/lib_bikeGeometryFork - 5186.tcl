 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_frame_geometry_custom.tcl
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
 #    namespace:  rattleCAD::frame_geometry_custom
 # ---------------------------------------------------------------------------
 #
 #

 
        #
        # --- set ForkBlade -----------------------
    
        #
        # ---   get Fork ... handle types
    proc bikeGeometry::get_Fork {} {
                #
            variable Fork
            variable ForkBlade
            variable Steerer
            variable HeadTube
            variable FrontWheel
            variable FrontBrake
                #
            variable myFork
                #
            variable Result
                #
                #
            set Result(Tubes/ForkBlade/CenterLine) {}    
            set ForkBlade(Start)       {0 0}    
            set ForkBlade(End)         {0 0}    
                #
                #
            # puts $Fork(Rendering)
            # exit
                #
            switch -glob $Fork(Rendering) {
                SteelLugged     {bikeGeometry::get_Fork_SteelLugged}
                SteelLuggedMAX  {bikeGeometry::get_Fork_SteelLuggedMAX}
                Composite       {bikeGeometry::get_Fork_Composite}
                Composite_TUSK  {bikeGeometry::get_Fork_Composite_TUSK}
                Suspension*     {bikeGeometry::get_Fork_Suspension}
                default         {}
            }  
                #
            # tk_messageBox -message $myFork(CrownBrakeOffset)   
                #
                # --- set Fork Crown ----------------------
            set Fork(CrownDirection)                $Steerer(Direction)
                # set Result(Lugs/ForkCrown/Direction)    $Fork(CrownDirection)
            return
                #

    }

        #
        # ---   get Fork_SteelLugged
    proc bikeGeometry::get_Fork_SteelLugged {} {
                #
            variable Fork
            variable ForkBlade
            variable Steerer
            variable HeadTube
            variable FrontWheel
            variable FrontBrake
                #
            variable Result
                #
            variable myFork
                #
            
                #
            set Result(Tubes/ForkBlade/CenterLine) {}
                #
            set pt_00       $Steerer(Fork)
            set pt_99       $FrontWheel(Position)
            set pt_01       [ vectormath::addVector $pt_00 $HeadTube(Direction) -$Fork(BladeOffsetCrown) ]
            set pt_02       [ lindex [ vectormath::parallel  $pt_00  $pt_01  $Fork(BladeOffsetCrownPerp) left ] 1] ;# centerpoint of Blade in ForkCrown
                #
                # puts "SteelLugged"
                # puts "$project::Rendering(ForkBlade)"
                # puts "$Fork(Rendering)"
                #
            dict create dict_ForkBlade {}
            dict append dict_ForkBlade env \
                    [list dropOutPosition $FrontWheel(Position) \
                          forkHeight      $Fork(Height)   \
                          forkRake        $Fork(Rake)     \
                          crownOffset     $Fork(BladeOffsetCrown)     \
                          crownPerp       $Fork(BladeOffsetCrownPerp) \
                          dropOutOffset   $Fork(BladeOffsetDO)        \
                          dropOutPerp     $Fork(BladeOffsetDOPerp)    \
                          headTubeAngle   $HeadTube(Angle) \
                    ]
            dict append dict_ForkBlade blade \
                    [list type            $Fork(BladeRendering)  \
                          endLength       $Fork(BladeEndLength) \
                          bendRadius      $Fork(BladeBendRadius) \
                    ]
            dict append dict_ForkBlade profile \
                    [list [list 0                       $Fork(BladeDiameterDO)] \
                          [list $Fork(BladeTaperLength) $Fork(BladeWith)] \
                          [list 200                     $Fork(BladeWith)] \
                          [list 500                     $Fork(BladeWith)] \
                    ]
                #
            set retValue [bikeGeometry::tube::get_ForkBlade $dict_ForkBlade]
                #
            set outLine         [lindex $retValue 0]
            set centerLine      [lindex $retValue 1]
            set brakeDefLine    [lindex $retValue 2]
            set dropOutAngle    [lindex $retValue 3]
            set forkBladePos    [lindex $retValue 4]
                #
            set dropOutPos      $FrontWheel(Position) 
                #
            set ForkBlade(Start)    [vectormath::addVector $forkBladePos  $dropOutPos];
            set forkBladePos    $ForkBlade(Start)
            # set forkBladePos    [vectormath::addVector $forkBladePos  $dropOutPos]
            set forkBladePos    [format "%s,%s"  [lindex $forkBladePos 0] [lindex $forkBladePos 1]]
                #
            foreach {x y} $centerLine {
                lappend centerLine_Format [format "%s,%s" $x $y]
            }
                #
            set ForkBlade(End)      [split [lindex $centerLine_Format end] ,]
            set forkBladeEnd        [lindex $centerLine_Format end]
            # set forkBladeEnd    [lindex $centerLine_Format end]
                #
                # puts "  -> \$outLine       $outLine"
                # puts "  -> \$dropOutPos    $dropOutPos"
                # puts "  -> \$dropOutAngle  $dropOutAngle"
                #
            set Fork(BrakeOffsetDef)      $brakeDefLine
            set Fork(DropoutDirection)    [ vectormath::unifyVector $dropOutPos [vectormath::rotateLine $dropOutPos 10 [expr 180 + $dropOutAngle]] 1]
                # puts "  -> \$Fork(DropoutDirection)  $Fork(DropoutDirection)"
                #
                #
            set ForkBlade(Polygon)                      $outLine
            # set Result(Tubes/ForkBlade/Polygon)         $outLine
            set Result(Tubes/ForkBlade/Start)           $forkBladePos
            set Result(Tubes/ForkBlade/End)             $forkBladeEnd
            set Result(Tubes/ForkBlade/CenterLine)      [list $centerLine_Format]
            # set Result(Lugs/Dropout/Front/Direction)    $Fork(DropoutDirection)   
                #
            set myFork(CrownFile)         $Fork(CrownFile)                                     
            set myFork(DropOutFile)       $Fork(DropOutFile)
                #
            set myFork(CrownBrakeOffset)  $Fork(CrownBrakeOffset) 
            set myFork(CrownBrakeAngle)   $Fork(CrownBrakeAngle)
                #
            set myFork(BladeBrakeOffset)  $FrontBrake(Offset)   
                #
                #
            return
                #
    }

        #
        # ---   get Fork_SteelLuggedMAX
    proc bikeGeometry::get_Fork_SteelLuggedMAX {} {
                #
            variable Fork
            variable ForkBlade
            variable Steerer
            variable HeadTube
            variable FrontWheel
            variable FrontBrake
                #
            variable Result
                #
            variable initDOM
                #
            variable myFork
                #
                #            
            set pt_00       $Steerer(Fork)
            set pt_99       $FrontWheel(Position)
            set pt_01       [ vectormath::addVector $pt_00 $HeadTube(Direction) -$Fork(BladeOffsetCrown) ]
            set pt_02       [ lindex [ vectormath::parallel  $pt_00  $pt_01  $Fork(BladeOffsetCrownPerp) left ] 1] ;# centerpoint of Blade in ForkCrown
                #
            set myFork(CrownOffset)       [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Crown/Blade/Offset     ]  asText ]
            set myFork(CrownOffsetPerp)   [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Crown/Blade/OffsetPerp ]  asText ]

            set myFork(BladeWith)         [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Blade/Width            ]  asText ]
            set myFork(BladeDiameterDO)   [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Blade/DiameterDO       ]  asText ]
            set myFork(BladeTaperLength)  [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Blade/TaperLength      ]  asText ]
            set myFork(BladeBendRadius)   [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Blade/BendRadius       ]  asText ]
            set myFork(BladeEndLength)    [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Blade/EndLength        ]  asText ]
            
            set myFork(DropOutOffset)     [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/DropOut/Offset         ]  asText ]
            set myFork(DropOutOffsetPerp) [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/DropOut/OffsetPerp     ]  asText ]
            

            dict create dict_ForkBlade {}
            dict append dict_ForkBlade env \
                    [list dropOutPosition   $FrontWheel(Position) \
                          forkHeight        $Fork(Height)   \
                          forkRake          $Fork(Rake)     \
                          crownOffset       $myFork(CrownOffset)     \
                          crownPerp         $myFork(CrownOffsetPerp) \
                          dropOutOffset     $myFork(DropOutOffset)        \
                          dropOutPerp       $myFork(DropOutOffsetPerp)    \
                          headTubeAngle     $HeadTube(Angle) \
                    ]
            dict append dict_ForkBlade blade \
                    [list type              MAX  \
                          endLength         $myFork(BladeEndLength) \
                          bendRadius        $myFork(BladeBendRadius) \
                    ]
            dict append dict_ForkBlade profile \
                    [list [list 0                         $myFork(BladeDiameterDO)] \
                          [list $myFork(BladeTaperLength) $myFork(BladeWith)] \
                          [list 200                       $myFork(BladeWith)] \
                          [list 500                       $myFork(BladeWith)] \
                    ]

            set retValue [bikeGeometry::tube::get_ForkBlade $dict_ForkBlade]
            
            set outLine         [lindex $retValue 0]
            set centerLine      [lindex $retValue 1]
            set brakeDefLine    [lindex $retValue 2]
            set dropOutAngle    [lindex $retValue 3]
            set forkBladePos    [lindex $retValue 4]
                #
            set dropOutPos      $FrontWheel(Position) 
                #
            set ForkBlade(Start)    [vectormath::addVector $forkBladePos  $dropOutPos];
            #set forkBladePos    [vectormath::addVector $forkBladePos  $dropOutPos]
            set forkBladePos    [format "%s,%s"  [lindex $ForkBlade(Start) 0] [lindex $ForkBlade(Start) 1]]
            # set forkBladePos    [format "%s,%s"  [lindex $ForkBlade(Start) 0] [lindex $ForkBlade(Start) 1]]
            # set forkBladePos    [format "%s,%s"  [lindex $forkBladePos 0] [lindex $forkBladePos 1]]
                #
            foreach {x y} $centerLine {
                lappend centerLine_Format [format "%s,%s" $x $y]
            }
                #
            set ForkBlade(End)      [split [lindex $centerLine_Format end] ,]
            set forkBladeEnd        [lindex $centerLine_Format end]
            # set forkBladeEnd    [lindex $centerLine_Format end]
                #
                # puts "  -> \$outLine       $outLine"
                # puts "  -> \$dropOutPos    $dropOutPos"
                # puts "  -> \$dropOutAngle  $dropOutAngle"
                #
            set Fork(BrakeOffsetDef)      $brakeDefLine
            set Fork(DropoutDirection)    [ vectormath::unifyVector $dropOutPos [vectormath::rotateLine $dropOutPos 10 [expr 180 + $dropOutAngle]] 1]
              # puts "  -> \$Fork(DropoutDirection)  $Fork(DropoutDirection)"
                #
            set ForkBlade(Polygon)         $outLine
            # set Result(Tubes/ForkBlade/Polygon)         $outLine
            # set Result(Tubes/ForkBlade/Start)           [list $ForkBlade(Start)]
            # set Result(Tubes/ForkBlade/Start)           $forkBladePos
            # set Result(Tubes/ForkBlade/End)             [list $ForkBlade(End)]
            # set Result(Tubes/ForkBlade/End)             $forkBladeEnd
            set Result(Tubes/ForkBlade/CenterLine)      [list $centerLine_Format]
            # set Result(Lugs/Dropout/Front/Direction)    $Fork(DropoutDirection)
                #
            set myFork(CrownFile)         [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Crown/File             ]  asText ]
            set myFork(DropOutFile)       [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/DropOut/File           ]  asText ]
                #
            set myFork(CrownBrakeOffset)  [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Crown/Brake/Offset     ]  asText ]
            set myFork(CrownBrakeAngle)   [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Crown/Brake/Angle      ]  asText ]
                #
            set myFork(BladeBrakeOffset)  [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Brake/Offset]  asText ]
                #
                #
            return
                #
    }                  

        #
        # ---   get Fork_Composite
    proc bikeGeometry::get_Fork_Composite {} {
                #
            variable Fork
            variable ForkBlade
            variable Steerer
            variable HeadTube
            variable FrontWheel
            variable FrontBrake
                #
            variable Result
                #
            variable initDOM       
                #
            variable myFork
                #
                #
            # set domInit $project::initDOM
                # set     domInit $::APPL_Config(root_InitDOM)
                #
            set pt_00       $Steerer(Fork)
            set pt_99       $FrontWheel(Position)
            set pt_01       [ vectormath::addVector $pt_00 $HeadTube(Direction) -$Fork(BladeOffsetCrown) ]
            set pt_02       [ lindex [ vectormath::parallel  $pt_00  $pt_01  $Fork(BladeOffsetCrownPerp) left ] 1] ;# centerpoint of Blade in ForkCrown
                #
            set ForkBlade(Polygon)      [ set_compositeFork {}]
            # set Result(Tubes/ForkBlade/Polygon)            [ set_compositeFork {}]
                #
            set myFork(CrownFile)         [[ $initDOM selectNodes /root/Fork/Composite/Crown/File         ]  asText ]                           
            set myFork(DropOutFile)       [[ $initDOM selectNodes /root/Fork/Composite/DropOut/File       ]  asText ]
                #
            set myFork(CrownBrakeOffset)  [[ $initDOM selectNodes /root/Fork/Composite/Crown/Brake/Offset ]  asText ]
            set myFork(CrownBrakeAngle)   [[ $initDOM selectNodes /root/Fork/Composite/Crown/Brake/Angle  ]  asText ]
                #
            set myFork(BladeBrakeOffset)  [[ $initDOM selectNodes /root/Fork/Composite/Brake/Offset       ]  asText ]  
                #
            set pt_60  [ vectormath::rotateLine $pt_00  $myFork(CrownBrakeOffset)  [expr  90 - $HeadTube(Angle)]]
            set pt_61  [ vectormath::rotateLine $pt_60  100.0                      [expr 180 - $HeadTube(Angle)]]
            set Fork(BrakeOffsetDef) [bikeGeometry::flatten_nestedList $pt_61 $pt_60 ]
                #
                #
            puts "    \$Fork(BrakeOffsetDef)  $Fork(BrakeOffsetDef)" 
            # exit
            # set Fork(BrakeOffsetDef)      {500 300 600 329} 
                #
            return
                #
    }             

        #
        # ---   get Fork_Composite_TUSK
    proc bikeGeometry::get_Fork_Composite_TUSK {} {
                #
            variable Fork
            variable ForkBlade
            variable Steerer
            variable HeadTube
            variable FrontWheel
            variable FrontBrake
                #
            variable Result
                #
            variable initDOM
                #
            variable myFork
                #
            set pt_00       $Steerer(Fork)
            set pt_99       $FrontWheel(Position)
            set pt_01       [ vectormath::addVector $pt_00 $HeadTube(Direction) -$Fork(BladeOffsetCrown) ]
            set pt_02       [ lindex [ vectormath::parallel  $pt_00  $pt_01  $Fork(BladeOffsetCrownPerp) left ] 1] ;# centerpoint of Blade in ForkCrown
                #
                #
            set ForkBlade(Polygon)      [ set_compositeFork TUSK ]
            # set Result(Tubes/ForkBlade/Polygon)            [ set_compositeFork TUSK ]
                #
            set myFork(CrownFile)         [[ $initDOM selectNodes /root/Fork/Composite_TUSK/Crown/File         ]  asText ]                           
            set myFork(DropOutFile)       [[ $initDOM selectNodes /root/Fork/Composite_TUSK/DropOut/File       ]  asText ]
                #
            set myFork(CrownBrakeOffset)  [[ $initDOM selectNodes /root/Fork/Composite_TUSK/Crown/Brake/Offset ]  asText ]
            set myFork(CrownBrakeAngle)   [[ $initDOM selectNodes /root/Fork/Composite_TUSK/Crown/Brake/Angle  ]  asText ]
                #
            set myFork(BladeBrakeOffset)  [[ $initDOM selectNodes /root/Fork/Composite_TUSK/Brake/Offset       ]  asText ]  
                #
            set pt_60  [ vectormath::rotateLine $pt_00  $myFork(CrownBrakeOffset)  [expr  90 - $HeadTube(Angle)]]
            set pt_61  [ vectormath::rotateLine $pt_60  100.0                      [expr 180 - $HeadTube(Angle)]]
            set Fork(BrakeOffsetDef) [bikeGeometry::flatten_nestedList $pt_61 $pt_60 ]
                #
                #
            return
                #
    }

        #
        # ---   get Fork_Suspension
    proc bikeGeometry::get_Fork_Suspension {} {
                #
            variable Fork
            variable ForkBlade
            variable Steerer
            variable HeadTube
            variable FrontWheel
            variable FrontBrake
                #
            variable Result
                #
            variable initDOM
                #
            variable myFork
                #
                #
            # set domInit $project::initDOM
                # set     domInit $::APPL_Config(root_InitDOM)
                #
            set pt_00       $Steerer(Fork)
            set pt_99       $FrontWheel(Position)
            set pt_01       [ vectormath::addVector $pt_00 $HeadTube(Direction) -$Fork(BladeOffsetCrown) ]
            set pt_02       [ lindex [ vectormath::parallel  $pt_00  $pt_01  $Fork(BladeOffsetCrownPerp) left ] 1] ;# centerpoint of Blade in ForkCrown
                #
                #
            set ForkBlade(Polygon)        {}
            # set Result(Tubes/ForkBlade/Polygon)     {}
            # set Result(Tubes/ForkBlade)       polygon     [ set_suspensionFork ]
                #
            set forkSize  $Fork(Rendering)
                #
            set pt_60  [ vectormath::rotateLine $pt_00  40.0 [expr  90 - $HeadTube(Angle)]]
            set pt_61  [ vectormath::rotateLine $pt_60 100.0 [expr 180 - $HeadTube(Angle)]]
            set Fork(BrakeOffsetDef) [bikeGeometry::flatten_nestedList $pt_61 $pt_60 ]
            # set Fork(BrakeOffsetDef) [project::flatten_nestedList $pt_61 $pt_60 ]
                #
            set myFork(CrownFile)         [[ $initDOM selectNodes /root/Fork/_Suspension/Crown/File ] asText ]
            set myFork(DropOutFile)       [[ $initDOM selectNodes /root/Fork/$forkSize/DropOut/File ] asText ]                    
                #
            set myFork(CrownBrakeOffset)  [[ $initDOM selectNodes /root/Fork/_Suspension/Crown/Brake/Offset     ]  asText ]
            set myFork(CrownBrakeAngle)   [[ $initDOM selectNodes /root/Fork/_Suspension/Crown/Brake/Angle      ]  asText ]
                #
            set myFork(BladeBrakeOffset)  [[ $initDOM selectNodes /root/Fork/$forkSize/Brake/Offset]  asText ]  
                #
                #
            return
                #
    }

        #
        # ---   Fork Blade Polygon for composite Fork
    proc bikeGeometry::set_compositeFork {forkType} {
                #
            variable Fork
            variable ForkBlade
            variable Steerer
            variable HeadTube
            variable FrontWheel
            variable FrontBrake
                #
            variable Result
                #
            variable initDOM
                #
            variable myFork
                 #
            set ht_direction  $HeadTube(Direction)          
                # <polar>0.00,0.00</polar>
                # set ht_direction            [ bikeGeometry::get_Object        HeadTube         direction ]
                #

            set Fork(BladeWith)             [ [ $initDOM selectNodes /root/Fork/Composite/Blade/Width            ]  asText ]
            set Fork(BladeDiameterDO)       [ [ $initDOM selectNodes /root/Fork/Composite/Blade/DiameterDO       ]  asText ]
            set Fork(BladeOffsetCrown)      [ [ $initDOM selectNodes /root/Fork/Composite/Crown/Blade/Offset     ]  asText ]
            set Fork(BladeOffsetCrownPerp)  [ [ $initDOM selectNodes /root/Fork/Composite/Crown/Blade/OffsetPerp ]  asText ]
            set Fork(BladeOffsetDO)         [ [ $initDOM selectNodes /root/Fork/Composite/DropOut/Offset         ]  asText ]

            set ht_angle            [ vectormath::angle {0 1} {0 0} $ht_direction ]
            set pt_00               [list $Fork(BladeOffsetCrownPerp) [expr -1.0*$Fork(BladeOffsetCrown)] ]
            set pt_01               [ vectormath::addVector $pt_00 {0  -5} ]
            set pt_02               [ vectormath::addVector $pt_00 {0 -15} ]

            set pt_00               [ vectormath::addVector $Steerer(Fork) [ vectormath::rotatePoint {0 0} $pt_00 $ht_angle ]]
            set pt_01               [ vectormath::addVector $Steerer(Fork) [ vectormath::rotatePoint {0 0} $pt_01 $ht_angle ]]
            set pt_02               [ vectormath::addVector $Steerer(Fork) [ vectormath::rotatePoint {0 0} $pt_02 $ht_angle ]]
                    # puts "     ... \$ht_angle  $ht_angle"
                    # puts "   -> pt_00  $pt_00"
                    # puts "   -> pt_01  $pt_01"

            set vct_10              [ vectormath::parallel $pt_00 $pt_01 [expr 0.5*$Fork(BladeWith)] left]
            set vct_19              [ vectormath::parallel $pt_00 $pt_02 [expr 0.5*$Fork(BladeWith)] ]
                    # puts "   -> pt_00  $pt_00"
                    # puts "   -> vct_10  $vct_10"
                    # puts "   -> vct_19  $vct_19"

                set help_02         [ list 0 [lindex  $FrontWheel(Position) 1] ]
                set do_angle        [ expr 90 - [ vectormath::angle $pt_01 $FrontWheel(Position) $help_02  ] ]
                set vct_05          [ list $Fork(BladeOffsetDO) 0 ]
                set vct_06          [ vectormath::rotatePoint {0 0} $vct_05 [expr 90 + $do_angle] ]
            set pt_03               [ vectormath::addVector $FrontWheel(Position)  $vct_06 ]

                set vct_11          [ vectormath::parallel $pt_01 $pt_03 [expr 0.5*$Fork(BladeDiameterDO)] left]
                set vct_18          [ vectormath::parallel $pt_01 $pt_03 [expr 0.5*$Fork(BladeDiameterDO)] ]            

                                           
            if {$forkType == {TUSK}} {
				set polygon         [list -15.4096  -80.6711 \
										   22.8479  -37.0065 ]                              
				set polygon         [vectormath::rotatePointList    {0 0} $polygon  $ht_angle]                                 
				set polygon         [vectormath::addVectorPointList $Steerer(Fork) $polygon  ]                                 
				lappend polygon         [lindex [lindex $vct_11 1] 0] [lindex [lindex $vct_11 1] 1] 
				lappend polygon         [lindex [lindex $vct_18 1] 0] [lindex [lindex $vct_18 1] 1] 
            } else {
				set polygon         [format "%s %s %s %s %s %s" \
										[lindex $vct_10 0] [lindex $vct_10 1] \
										[lindex $vct_11 1] [lindex $vct_18 1] \
										[lindex $vct_19 1] [lindex $vct_19 0] ]
			}
                #
            set Fork(DropoutDirection) [ vectormath::unifyVector $FrontWheel(Position) $pt_03 ]
            # set do_direction    [ vectormath::unifyVector $FrontWheel(Position) $pt_03 ]
            # set Result(Lugs/Dropout/Front/Direction)      $do_direction
                #
                # tk_messageBox -message "$polygon"
                #
            return $polygon
    }


        
        #
        # --- set Steerer -------------------------
    proc bikeGeometry::get_Steerer {} {
            variable HeadTube
            variable Steerer
                #
            variable Result
                #
            set Steerer(CenterLine)  [list [format "%s,%s %s,%s" [lindex $Steerer(Fork) 0] [lindex $Steerer(Fork) 1] \
                                                                                                  [lindex $Steerer(Stem) 0] [lindex $Steerer(Stem) 1] ] ]
            # set Result(Tubes/Steerer/CenterLine)  [list [format "%s,%s %s,%s" [lindex $Steerer(Fork) 0] [lindex $Steerer(Fork) 1] \
                                                                                                  [lindex $Steerer(Stem) 0] [lindex $Steerer(Stem) 1] ] ]
            

                    if {$HeadTube(Diameter) > 35 } {
                        set SteererDiameter 28.6
                    } else {
                        set SteererDiameter 25.4
                    }
                    set hlp_01      [ vectormath::addVector         $Steerer(Stem) [ vectormath::unifyVector $Steerer(Fork)  $Steerer(Stem) 10 ] ]
                    set vct_01      [ vectormath::parallel          $Steerer(Fork)  $hlp_01         [expr 0.5 * $SteererDiameter] ]
                    set vct_ht      [ vectormath::parallel          $hlp_01         $Steerer(Fork)  [expr 0.5 * $SteererDiameter] ]
                    set polygon     [format "%s %s %s %s" \
                                            [lindex $vct_01 0] [lindex $vct_01 1] \
                                            [lindex $vct_ht 0] [lindex $vct_ht 1] ]
              # puts $polygon
            set Steerer(Polygon)    $polygon
            # set Result(Tubes/Steerer/Polygon)     $polygon
    }

