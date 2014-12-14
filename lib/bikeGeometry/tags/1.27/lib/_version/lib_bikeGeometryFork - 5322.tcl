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
    proc bikeGeometry::create_Fork {} {
                #
            variable Geometry
            variable Steerer
            variable Fork
            variable ForkBlade
            variable FrontWheel
                #
            variable Result
                #
                #
            set Fork(Height)            $Geometry(Fork_Height)   
            set Fork(Rake)              $Geometry(Fork_Rake)
            set Fork(DropoutPosition)   $FrontWheel(Position)
            set Fork(CrownDirection)    $Steerer(Direction)
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
                SteelLugged     -
                SteelCustom     {bikeGeometry::create_Fork_SteelCustom}
                SteelLuggedMAX  {bikeGeometry::create_Fork_SteelLuggedMAX}
                Composite       {bikeGeometry::create_Fork_Composite}
                Composite_TUSK  {bikeGeometry::create_Fork_Composite_TUSK}
                Suspension*     {bikeGeometry::create_Fork_Suspension}
                default         {}
            }  
                #
            # tk_messageBox -message $myFork(CrownBrakeOffset)   
                #
                #
            return
                #
    }

        #
        # ---   get Fork_SteelLugged
    proc bikeGeometry::create_Fork_SteelCustom {} {
                #
            variable Geometry
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
            variable customFork
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
                          headTubeAngle   $Geometry(HeadTube_Angle) \
                    ]
            dict append dict_ForkBlade blade \
                    [list type            $Fork(BladeRendering)  \
                          endLength       $Fork(BladeEndLength) \
                          bendRadius      $Fork(BladeBendRadius) \
                    ]
            dict append dict_ForkBlade profile \
                    [list [list 0                       $Fork(BladeDiameterDO)] \
                          [list $Fork(BladeTaperLength) $Fork(BladeWidth)] \
                          [list 200                     $Fork(BladeWidth)] \
                          [list 500                     $Fork(BladeWidth)] \
                    ]
                #
            set retValue [bikeGeometry::tube::create_ForkBlade $dict_ForkBlade]
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
            # set forkBladePos    $ForkBlade(Start)
            # set forkBladePos    [vectormath::addVector $forkBladePos  $dropOutPos]
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
                #
            set ForkBlade(Polygon)                      $outLine
                # set Result(Tubes/ForkBlade/Polygon)         $outLine
            set Result(Tubes/ForkBlade/Start)           $ForkBlade(Start)
                # set Result(Tubes/ForkBlade/Start)           $forkBladePos
            set Result(Tubes/ForkBlade/End)             $forkBladeEnd
            set Result(Tubes/ForkBlade/CenterLine)      [list $centerLine_Format]
                #
                # -- store current Fork-Settings for later use of custom-Fork    
                #
            set customFork(CrownFile)           $Fork(CrownFile)                                     
            set customFork(DropOutFile)         $Fork(DropOutFile)
            set customFork(CrownBrakeOffset)    $Fork(CrownBrakeOffset) 
            set customFork(CrownBrakeAngle)     $Fork(CrownBrakeAngle)
            set customFork(BladeBrakeOffset)    $FrontBrake(Offset)   
            set customFork(ForkBladePolygon)    $ForkBlade(Polygon)   
                #
            puts "\n ... create_Fork_SteelCustom"
            parray customFork   
                #
            return
                #
    }

        #
        # ---   get Fork_SteelLuggedMAX
    proc bikeGeometry::create_Fork_SteelLuggedMAX {} {
                #
            variable Geometry
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
            set crownOffset         [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Crown/Blade/Offset     ]  asText ]
            set crownOffsetPerp     [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Crown/Blade/OffsetPerp ]  asText ]
            set dropOutOffset       [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/DropOut/Offset         ]  asText ]
            set dropOutOffsetPerp   [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/DropOut/OffsetPerp     ]  asText ]
                #
            set bladeBendRadius     [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Blade/BendRadius       ]  asText ]
            set bladeEndLength      [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Blade/EndLength        ]  asText ]
                #
            set bladeWidth          [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Blade/Width            ]  asText ]
            set bladeDiameterDO     [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Blade/DiameterDO       ]  asText ]
            set bladeTaperLength    [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Blade/TaperLength      ]  asText ]
                #
            dict create dict_ForkBlade {}
            dict append dict_ForkBlade env \
                    [list dropOutPosition   $FrontWheel(Position) \
                          forkHeight        $Fork(Height)   \
                          forkRake          $Fork(Rake)     \
                          crownOffset       $crownOffset     \
                          crownPerp         $crownOffsetPerp \
                          dropOutOffset     $dropOutOffset        \
                          dropOutPerp       $dropOutOffsetPerp    \
                          headTubeAngle     $Geometry(HeadTube_Angle) \
                    ]
            dict append dict_ForkBlade blade \
                    [list type              MAX  \
                          endLength         $bladeEndLength \
                          bendRadius        $bladeBendRadius \
                    ]
            dict append dict_ForkBlade profile \
                    [list [list 0                   $bladeDiameterDO] \
                          [list $bladeTaperLength   $bladeWidth] \
                          [list 200                 $bladeWidth] \
                          [list 500                 $bladeWidth] \
                    ]

            set retValue [bikeGeometry::tube::create_ForkBlade $dict_ForkBlade]
            
            set outLine         [lindex $retValue 0]
            set centerLine      [lindex $retValue 1]
            set brakeDefLine    [lindex $retValue 2]
            set dropOutAngle    [lindex $retValue 3]
            set forkBladePos    [lindex $retValue 4]
                #
            set dropOutPos      $FrontWheel(Position) 
                #
            foreach {x y} $centerLine {
                lappend centerLine_Format [format "%s,%s" $x $y]
            }
                #
            set Result(Tubes/ForkBlade/CenterLine)      [list $centerLine_Format]
                #
            set ForkBlade(Start)    [vectormath::addVector $forkBladePos  $dropOutPos];
                #
            set ForkBlade(End)      [split [lindex $centerLine_Format end] ,]
                # puts "  -> \$outLine       $outLine"
                # puts "  -> \$dropOutPos    $dropOutPos"
                # puts "  -> \$dropOutAngle  $dropOutAngle"
                #
            set Fork(BrakeOffsetDef)    $brakeDefLine
            set Fork(DropoutDirection)  [ vectormath::unifyVector $dropOutPos [vectormath::rotateLine $dropOutPos 10 [expr 180 + $dropOutAngle]] 1]
                # 
            set ForkBlade(Polygon)      $outLine
                #
            set Fork(CrownFile)         [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Crown/File            ]  asText ]
            set Fork(DropOutFile)       [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/DropOut/File          ]  asText ]
                #
            set Fork(CrownBrakeOffset)  [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Crown/Brake/Offset    ]  asText ]
            set Fork(CrownBrakeAngle)   [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Crown/Brake/Angle     ]  asText ]
                #
            set Fork(BladeBrakeOffset)  [[ $initDOM selectNodes /root/Fork/SteelLuggedMAX/Brake/Offset          ]  asText ]
                #
            return
                #
    }                  

        #
        # ---   get Fork_Composite
    proc bikeGeometry::create_Fork_Composite {} {
                #
            variable Geometry
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
                #
            set pt_00       $Steerer(Fork)
            set pt_99       $FrontWheel(Position)
            set pt_01       [ vectormath::addVector $pt_00 $HeadTube(Direction) -$Fork(BladeOffsetCrown) ]
            set pt_02       [ lindex [ vectormath::parallel  $pt_00  $pt_01  $Fork(BladeOffsetCrownPerp) left ] 1] ;# centerpoint of Blade in ForkCrown
                #
            set ForkBlade(Polygon)      [ create_compositeFork {}]
                #
            set Fork(CrownFile)         [[ $initDOM selectNodes /root/Fork/Composite/Crown/File         ]  asText ]                           
            set Fork(DropOutFile)       [[ $initDOM selectNodes /root/Fork/Composite/DropOut/File       ]  asText ]
                #
            set Fork(CrownBrakeOffset)  [[ $initDOM selectNodes /root/Fork/Composite/Crown/Brake/Offset ]  asText ]
            set Fork(CrownBrakeAngle)   [[ $initDOM selectNodes /root/Fork/Composite/Crown/Brake/Angle  ]  asText ]
                #
            set Fork(BladeBrakeOffset)  [[ $initDOM selectNodes /root/Fork/Composite/Brake/Offset       ]  asText ]  
                #
            set pt_60  [ vectormath::rotateLine $pt_00  $Fork(CrownBrakeOffset) [expr  90 - $Geometry(HeadTube_Angle)]]
            set pt_61  [ vectormath::rotateLine $pt_60  100.0                   [expr 180 - $Geometry(HeadTube_Angle)]]
                #
            set Fork(BrakeOffsetDef) [bikeGeometry::flatten_nestedList $pt_61 $pt_60 ]
                #
                #
            puts "    \$Fork(BrakeOffsetDef)  $Fork(BrakeOffsetDef)" 
                #
            return
                #
    }             

        #
        # ---   get Fork_Composite_TUSK
    proc bikeGeometry::create_Fork_Composite_TUSK {} {
                #
            variable Geometry
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
                #
            set pt_00       $Steerer(Fork)
            set pt_99       $FrontWheel(Position)
            set pt_01       [ vectormath::addVector $pt_00 $HeadTube(Direction) -$Fork(BladeOffsetCrown) ]
            set pt_02       [ lindex [ vectormath::parallel  $pt_00  $pt_01  $Fork(BladeOffsetCrownPerp) left ] 1] ;# centerpoint of Blade in ForkCrown
                #
                #
            set ForkBlade(Polygon)      [ create_compositeFork TUSK ]
                #
            set Fork(CrownFile)         [[ $initDOM selectNodes /root/Fork/Composite_TUSK/Crown/File         ]  asText ]                           
            set Fork(DropOutFile)       [[ $initDOM selectNodes /root/Fork/Composite_TUSK/DropOut/File       ]  asText ]
                #
            set Fork(CrownBrakeOffset)  [[ $initDOM selectNodes /root/Fork/Composite_TUSK/Crown/Brake/Offset ]  asText ]
            set Fork(CrownBrakeAngle)   [[ $initDOM selectNodes /root/Fork/Composite_TUSK/Crown/Brake/Angle  ]  asText ]
                #
            set Fork(BladeBrakeOffset)  [[ $initDOM selectNodes /root/Fork/Composite_TUSK/Brake/Offset       ]  asText ]  
                #
            set pt_60  [ vectormath::rotateLine $pt_00  $Fork(CrownBrakeOffset) [expr  90 - $Geometry(HeadTube_Angle)]]
            set pt_61  [ vectormath::rotateLine $pt_60  100.0                   [expr 180 - $Geometry(HeadTube_Angle)]]
                #
            set Fork(BrakeOffsetDef)    [bikeGeometry::flatten_nestedList $pt_61 $pt_60 ]
                #
            return
                #
    }

        #
        # ---   get Fork_Suspension
    proc bikeGeometry::create_Fork_Suspension {} {
                #
            variable Geometry
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
                #
            set pt_00       $Steerer(Fork)
            set pt_99       $FrontWheel(Position)
            set pt_01       [ vectormath::addVector $pt_00 $HeadTube(Direction) -$Fork(BladeOffsetCrown) ]
            set pt_02       [ lindex [ vectormath::parallel  $pt_00  $pt_01  $Fork(BladeOffsetCrownPerp) left ] 1] ;# centerpoint of Blade in ForkCrown
                #
                #
            set ForkBlade(Polygon)        {}
                #
            set forkSize  $Fork(Rendering)
                #
            set pt_60  [ vectormath::rotateLine $pt_00  40.0 [expr  90 - $Geometry(HeadTube_Angle)]]
            set pt_61  [ vectormath::rotateLine $pt_60 100.0 [expr 180 - $Geometry(HeadTube_Angle)]]
            set Fork(BrakeOffsetDef)    [bikeGeometry::flatten_nestedList $pt_61 $pt_60 ]
                #
            set Fork(CrownFile)         [[ $initDOM selectNodes /root/Fork/_Suspension/Crown/File   ]   asText ]
            set Fork(DropOutFile)       [[ $initDOM selectNodes /root/Fork/$forkSize/DropOut/File   ]   asText ]                    
                #
            set Fork(CrownBrakeOffset)  [[ $initDOM selectNodes /root/Fork/_Suspension/Crown/Brake/Offset   ]  asText ]
            set Fork(CrownBrakeAngle)   [[ $initDOM selectNodes /root/Fork/_Suspension/Crown/Brake/Angle    ]  asText ]
                #
            set Fork(BladeBrakeOffset)  [[ $initDOM selectNodes /root/Fork/$forkSize/Brake/Offset   ]   asText ]  
                #
            return
                #
    }

        #
        # ---   Fork Blade Polygon for composite Fork
    proc bikeGeometry::create_compositeFork {forkType} {
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
            set ht_direction  $HeadTube(Direction)          
                # <polar>0.00,0.00</polar>
                # set ht_direction            [ bikeGeometry::get_Object        HeadTube         direction ]
                #
            set Fork(BladeWidth)            [ [ $initDOM selectNodes /root/Fork/Composite/Blade/Width            ]  asText ]
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
                #
            set vct_10              [ vectormath::parallel $pt_00 $pt_01 [expr 0.5*$Fork(BladeWidth)] left]
            set vct_19              [ vectormath::parallel $pt_00 $pt_02 [expr 0.5*$Fork(BladeWidth)] ]
                    # puts "   -> pt_00  $pt_00"
                    # puts "   -> vct_10  $vct_10"
                    # puts "   -> vct_19  $vct_19"
                #
            set help_02         [ list 0 [lindex  $FrontWheel(Position) 1] ]
            set do_angle        [ expr 90 - [ vectormath::angle $pt_01 $FrontWheel(Position) $help_02  ] ]
            set vct_05          [ list $Fork(BladeOffsetDO) 0 ]
            set vct_06          [ vectormath::rotatePoint {0 0} $vct_05 [expr 90 + $do_angle] ]
                #
            set pt_03           [ vectormath::addVector $FrontWheel(Position)  $vct_06 ]
                #
            set vct_11          [ vectormath::parallel $pt_01 $pt_03 [expr 0.5*$Fork(BladeDiameterDO)] left]
            set vct_18          [ vectormath::parallel $pt_01 $pt_03 [expr 0.5*$Fork(BladeDiameterDO)] ]            
                #
                                           
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
            set do_angle       [ vectormath::angle $pt_01 $FrontWheel(Position) $help_02  ] 
            set pt_99          [ vectormath::rotatePoint {0 0} {1 0} $do_angle]
            set Fork(DropoutDirection) [ vectormath::unifyVector {0 0} $pt_99 ]
                #
                # tk_messageBox -message "$polygon"
                #
            return $polygon
    }


        
        #
        # --- set Steerer -------------------------
    proc bikeGeometry::create_Steerer {} {
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

