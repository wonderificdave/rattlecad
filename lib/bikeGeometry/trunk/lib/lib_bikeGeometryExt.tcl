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
        #
        # --- set basePoints Attributes
        #
    proc bikeGeometry::get_basePoints_remove {} {
            variable Saddle
            variable SeatPost
            variable SeatTube
            variable HandleBar
            variable HeadTube
            variable Steerer
            variable Stem
            variable Fork
            variable RearWheel
            variable FrontWheel
            variable BottomBracket

                        # puts "   ..     \$HeadTube(Angle)    $HeadTube(Angle)"

                    set vect_01 [ expr $Stem(Length) * cos($Stem(Angle) * $vectormath::CONST_PI / 180) ]
                    set vect_03 [ expr $vect_01 / sin($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]

                    set Steerer(Handlebar)      [ list  [expr [lindex $HandleBar(Position) 0] - $vect_03]  [lindex $HandleBar(Position) 1] ]

                    set help_04 [ vectormath::rotateLine       $Steerer(Handlebar)     100    [expr 180 - $HeadTube(Angle)]    ]
                    set help_03 [ vectormath::rotateLine       $HandleBar(Position)    100    [expr  90 - $HeadTube(Angle) + $Stem(Angle)]    ]

                    set Steerer(Stem)           [ vectormath::intersectPoint    $HandleBar(Position)  $help_03 $Steerer(Handlebar) $help_04 ]

                    set vect_04 [ vectormath::parallel         $Steerer(Stem)      $help_04    $Fork(Rake) ]
                    set help_05 [ lindex $vect_04 0 ]
                    set help_06 [ lindex $vect_04 1 ]

                    set FrontWheel(Position)    [ vectormath::intersectPoint    $help_05  $help_06 [list 0 $FrontWheel(Distance_Y)] [list 200 $FrontWheel(Distance_Y)] ]
                    set FrontWheel(Distance_X)  [ lindex $FrontWheel(Position) 0]
                    set FrontWheel(DistanceBB)  [ expr hypot($FrontWheel(Distance_X),$FrontWheel(Distance_X)) ]

                    set Steerer(FrontWheel)     [ vectormath::rotateLine    $FrontWheel(Position)    $Fork(Rake)    [expr 270 - $HeadTube(Angle)] ]
                    set Steerer(Fork)           [ vectormath::addVector            $Steerer(FrontWheel)     [ vectormath::unifyVector  $Steerer(FrontWheel)  $Steerer(Stem)  $Fork(Height) ] ]

            project::setValue Result(Tubes/Steerer/Start)       position    $Steerer(Fork)
            project::setValue Result(Tubes/Steerer/End)         position    $Steerer(Stem)
            project::setValue Result(Lugs/ForkCrown/Position)   position    $Steerer(Fork)
            project::setValue Result(Tubes/Steerer/Direction)   direction   $Steerer(Fork)   $Steerer(Stem)
            project::setValue Result(Tubes/Steerer/Direction)   direction   $Steerer(Fork)   $Steerer(Stem)

                set help_08  [ vectormath::addVector    $BottomBracket(Ground) {200 0}]

                set Steerer(Ground)     [ vectormath::intersectPoint        $Steerer(Stem) $Steerer(Fork)      $BottomBracket(Ground)  $help_08 ]
                set SeatTube(Ground)    [ vectormath::intersectPoint        $SeatPost(SeatTube) $SeatTube(BottomBracket)      $BottomBracket(Ground)  $help_08 ]
            project::setValue Result(Position/SteererGround)    position    $Steerer(Ground)        ;# Point on the Ground in direction of Steerer
            project::setValue Result(Position/SeatTubeGround)   position    $SeatTube(Ground)       ;# Point on the Ground in direction of SeatTube
            project::setValue Result(Tubes/SeatTube/Direction)  direction   $SeatTube(Ground)  $SeatPost(SeatTube)

                #
                # --- set summary Length of Frame, Saddle and Stem
                set summaryLength [ expr $RearWheel(Distance_X) + $FrontWheel(Distance_X)]
                set summaryHeight [ expr $project::Custom(BottomBracket/Depth) + 40 + [lindex $SeatPost(SeatTube) 1] ]
            project::setValue Result(Position/SummarySize)      position    $summaryLength   $summaryHeight

    }
    
    
    proc bikeGeometry::get_GeometryFront {} {
                    #
            variable HandleBar
            variable HeadTube
            variable Steerer
            variable Stem
            variable Fork
            variable FrontWheel
            variable RearWheel
            variable BottomBracket
                #
            # puts "   ..     \$HeadTube(Angle)    $HeadTube(Angle)"
                #
            set Fork(Height)            $project::Component(Fork/Height)
            set Fork(Rake)              $project::Component(Fork/Rake)
            set Stem(Angle)             $project::Component(Stem/Angle)
            set Stem(Length)            $project::Component(Stem/Length)
            set HandleBar(Distance)     $project::Personal(HandleBar_Distance)    
            set HandleBar(Height)       $project::Personal(HandleBar_Height)
            set BottomBracket(depth)    $project::Custom(BottomBracket/Depth)
            set HeadTube(Angle)         $project::Custom(HeadTube/Angle)
                #
                #
            set HandleBar(Position)     [ list $HandleBar(Distance) $HandleBar(Height) ]    
                #
            set vect_01 [ expr $Stem(Length) * cos($Stem(Angle) * $vectormath::CONST_PI / 180) ]
            set vect_03 [ expr $vect_01 / sin($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]
                #
            set Steerer(Handlebar)      [ list  [expr [lindex $HandleBar(Position) 0] - $vect_03]  [lindex $HandleBar(Position) 1] ]
                #
            set help_04 [ vectormath::rotateLine       $Steerer(Handlebar)     100    [expr 180 - $HeadTube(Angle)]    ]
            set help_03 [ vectormath::rotateLine       $HandleBar(Position)    100    [expr  90 - $HeadTube(Angle) + $Stem(Angle)]    ]
                #
            set Steerer(Stem)           [ vectormath::intersectPoint    $HandleBar(Position)  $help_03 $Steerer(Handlebar) $help_04 ]
                #
            set vect_04 [ vectormath::parallel         $Steerer(Stem)      $help_04    $Fork(Rake) ]
            set help_05 [ lindex $vect_04 0 ]
            set help_06 [ lindex $vect_04 1 ]
                #
            set FrontWheel(Position)    [ vectormath::intersectPoint    $help_05  $help_06 [list 0 $FrontWheel(Distance_Y)] [list 200 $FrontWheel(Distance_Y)] ]
            set FrontWheel(Distance_X)  [ lindex $FrontWheel(Position) 0]
            set FrontWheel(DistanceBB)  [ expr hypot($FrontWheel(Distance_X),$FrontWheel(Distance_X)) ]
                #
            set Steerer(FrontWheel)     [ vectormath::rotateLine    $FrontWheel(Position)    $Fork(Rake)    [expr 270 - $HeadTube(Angle)] ]
            set Steerer(Fork)           [ vectormath::addVector            $Steerer(FrontWheel)     [ vectormath::unifyVector  $Steerer(FrontWheel)  $Steerer(Stem)  $Fork(Height) ] ]
               #
            set help_08  [ vectormath::addVector    $BottomBracket(Ground) {200 0}]
                #
            set Steerer(Ground)         [ vectormath::intersectPoint        $Steerer(Stem) $Steerer(Fork)      $BottomBracket(Ground)  $help_08 ]
                #
            project::setValue Result(Lugs/Dropout/Front/Position)   position    $FrontWheel(Distance_X)    [expr $project::Custom(BottomBracket/Depth) + ($FrontWheel(Radius) - $RearWheel(Radius))]
            project::setValue Result(Lugs/ForkCrown/Position)       position    $Steerer(Fork)
            project::setValue Result(Position/FrontWheel)           position    $FrontWheel(Position)
            project::setValue Result(Position/HandleBar)            position    $HandleBar(Position)
            project::setValue Result(Position/SteererGround)        position    $Steerer(Ground)        ;# Point on the Ground in direction of Steerer
            project::setValue Result(Tubes/Steerer/Direction)       direction   $Steerer(Fork)      $Steerer(Stem)
            project::setValue Result(Tubes/Steerer/End)             position    $Steerer(Stem)
            project::setValue Result(Tubes/Steerer/Start)           position    $Steerer(Fork)
                #
            return
                #
    }
    proc bikeGeometry::get_GeometryRear {} {
                #
            variable RearWheel
            variable BottomBracket
                #
            set RearWheel(Position)        [ list [expr -1.0 * $RearWheel(Distance_X)] $project::Custom(BottomBracket/Depth) ]
                #
            project::setValue Result(Lugs/Dropout/Rear/Position)    position    [expr -1*$RearWheel(Distance_X)]    $project::Custom(BottomBracket/Depth)
            project::setValue Result(Position/RearWheel)            position    $RearWheel(Position)
                #
            return
                #
    }   
    proc bikeGeometry::get_GeometryCenter {} {
                #
            variable Saddle
            variable SeatPost
            variable SeatTube
            variable BottomBracket
            variable TopTube
            variable RearWheel
            variable LegClearance
                #
            set Saddle(Distance)        $project::Personal(Saddle_Distance)
            set Saddle(Height)          $project::Personal(Saddle_Height)
            set Saddle(Saddle_Height)   $project::Component(Saddle/Height)
            set SeatTube(OffsetBB)      $project::Custom(SeatTube/OffsetBB)
                #
            set BottomBracket(height)   [ expr $RearWheel(Radius) - $project::Custom(BottomBracket/Depth) ]
            set BottomBracket(Ground)   [ list 0    [expr - $RearWheel(Radius) + $project::Custom(BottomBracket/Depth) ] ]
                #
                # check-Value-procedure
            if {$Saddle(Saddle_Height) < 0} {
                   set project::Component(Saddle/Height) 0
                   set Saddle(Saddle_Height) 0
            }
                #
            set Saddle(Position)        [ list [expr -1.0*$Saddle(Distance)]  $Saddle(Height) ]
            set Saddle(Nose)            [ vectormath::addVector  $Saddle(Position) [list [expr $project::Component(Saddle/LengthNose) + $project::Rendering(Saddle/Offset_X)] -15] ]
                #
            set SeatPost(Setback)       $project::Component(SeatPost/Setback)
            set SeatPost(PivotOffset)   $project::Component(SeatPost/PivotOffset)
                # 
            set SeatPost(Height)        [ expr $Saddle(Height) - $Saddle(Saddle_Height) ]
            set SeatPost(Saddle)        [ list [expr -1.0 * $Saddle(Distance)] $SeatPost(Height) ]
            set SeatPost(PivotPosition) [ vectormath::addVector $SeatPost(Saddle)  [list 0 $SeatPost(PivotOffset)] -1]
                set hlp_01              [ vectormath:::cathetusPoint {0 0} $SeatPost(PivotPosition) [expr $SeatPost(Setback) - $SeatTube(OffsetBB)] {opposite}]
                # set hlp_01              [ vectormath:::cathetusPoint {0 0} $SeatPost(Saddle) [expr $SeatPost(Setback) - $SeatTube(OffsetBB)] {opposite}]
                set vct_01              [ vectormath:::parallel {0 0} $hlp_01 $SeatTube(OffsetBB)]
            set SeatPost(SeatTube)      [ lindex $vct_01 1]
            set SeatTube(BottomBracket) [ lindex $vct_01 0]
            set SeatTube(Angle)         [ vectormath::angle $SeatPost(SeatTube) $SeatTube(BottomBracket) [list -100 [lindex $SeatTube(BottomBracket) 1]]]
            set SeatTube(Direction)     [ vectormath::unifyVector $SeatTube(BottomBracket) $SeatPost(SeatTube) ]
                #
            set TopTube(PivotPosition)  $project::Custom(TopTube/PivotPosition)
                #
                # --- get LegClearance - Position
            set LegClearance(Length)    $project::Personal(InnerLeg_Length)
            set LegClearance(Position)  [ list $TopTube(PivotPosition)  [expr $LegClearance(Length) - ($RearWheel(Radius) - $project::Custom(BottomBracket/Depth)) ] ]
                #
                #
            set Saddle(Proposal)        [ vectormath::rotateLine {0 0}  [ expr 0.88*$LegClearance(Length) ]  [ expr 180 - $SeatTube(Angle) ] ]
                #
            set help_08  [ vectormath::addVector    $BottomBracket(Ground) {200 0}]
                #
            set SeatTube(Ground)    [ vectormath::intersectPoint        $SeatPost(SeatTube) $SeatTube(BottomBracket)      $BottomBracket(Ground)  $help_08 ]
                #
            project::setValue Result(Position/BottomBracketGround)  position    0     [expr - $RearWheel(Radius) + $project::Custom(BottomBracket/Depth) ] ;# Point on the Ground perp. to BB
            project::setValue Result(Position/LegClearance)         position    $TopTube(PivotPosition)     [expr $LegClearance(Length) - ($RearWheel(Radius) - $project::Custom(BottomBracket/Depth)) ]
            project::setValue Result(Position/Saddle)               position    $Saddle(Position)
            project::setValue Result(Position/SaddleNose)           position    $Saddle(Nose)
            project::setValue Result(Position/SaddleProposal)       position    $Saddle(Proposal)
            project::setValue Result(Position/SeatPostPivot)        position    $SeatPost(PivotPosition)
            project::setValue Result(Position/SeatPostSaddle)       position    $SeatPost(Saddle)
            project::setValue Result(Position/SeatPostSeatTube)     position    $SeatPost(SeatTube)
            project::setValue Result(Position/SeatTubeGround)       position    $SeatTube(Ground)       ;# Point on the Ground in direction of SeatTube
            project::setValue Result(Position/SeatTubeSaddle)       position    [ vectormath::intersectPoint [list 0 [lindex $Saddle(Position) 1] ] [list 100 [lindex $Saddle(Position) 1]] $SeatTube(BottomBracket) $SeatPost(SeatTube) ]
            project::setValue Result(Tubes/SeatTube/Direction)      direction   $SeatTube(Ground)  $SeatPost(SeatTube)                
                #
            return
                #
    }
    
    
    proc bikeGeometry::get_BoundingBox {} {
            variable SeatPost
            variable SeatTube
            variable FrontWheel
            variable RearWheel
            variable BottomBracket
                # --- set summary Length of Frame, Saddle and Stem
            set summaryLength [ expr $RearWheel(Distance_X) + $FrontWheel(Distance_X)]
            set summaryHeight [ expr $project::Custom(BottomBracket/Depth) + 40 + [lindex $SeatPost(SeatTube) 1] ]
                #
            project::setValue Result(Position/SummarySize)      position    $summaryLength   $summaryHeight
                #
            return    
                #
    }
    
    
        #
        #
        # --- set basePoints Attributes
        #
    proc bikeGeometry::get_Reference {} {

            variable FrontWheel
            variable BottomBracket
            variable Reference
            variable Result
            
            #Custom(BottomBracket/Depth)
            #Component(Wheel/Rear/RimDiameter@SELECT_Rim)
            #Component(Wheel/Rear/TyreHeight)
            
            # set BB_Height    $project::Result(Length/BottomBracket/Height)
            set BB_Height    [expr  0.5 * $project::Component(Wheel/Rear/RimDiameter) +  $project::Component(Wheel/Rear/TyreHeight) -  $project::Custom(BottomBracket/Depth)]
            
            set SN_Distance  [expr -1.0 * $project::Reference(SaddleNose_Distance)]
            set SN_Height    [expr $project::Reference(SaddleNose_Height)  - $BB_Height]
            
            set HB_Distance  [expr $project::Reference(HandleBar_Distance) + $SN_Distance]
            set HB_Height    [expr $project::Reference(HandleBar_Height)   - $BB_Height]
             
            set Reference(HandleBar)    [list $HB_Distance $HB_Height]
            project::setValue Result(Position/Reference_HB)      position    $Reference(HandleBar)
            
            
            set Reference(SaddleNose)   [list $SN_Distance $SN_Height]
            project::setValue Result(Position/Reference_SN)      position    $Reference(SaddleNose)
         
    }    
        #
        #
        # --- check Values before compute details
        #
    proc bikeGeometry::check_Values {} {
            variable Saddle
            variable SeatPost
            variable SeatTube
            variable HandleBar
            variable HeadTube
            variable Steerer
            variable Stem
            variable Fork
            variable RearWheel
            variable FrontWheel
            variable RearFender
            variable FrontFender
            variable BottomBracket
              #
              # -- Component(Wheel/Rear/TyreWidthRadius) <-> RearWheel(TyreWidthRadius)   
              # -- handle values like done in bikeGeometry::set_base_Parameters 
            if {$RearWheel(TyreWidthRadius) > $RearWheel(Radius)} {
                set project::Component(Wheel/Rear/TyreWidthRadius) [expr $RearWheel(Radius) - 5.0]
                set RearWheel(TyreWidthRadius)                     $project::Component(Wheel/Rear/TyreWidthRadius)
                puts "\n                     -> <i> \$project::Component(Wheel/Rear/TyreWidthRadius) ... $project::Component(Wheel/Rear/TyreWidthRadius)"
            }
              #
              # -- Component(Fender/Rear/Radius) <-> $RearFender(Radius)
              #       handle values like done in bikeGeometry::set_base_Parameters 
            if {1 == 2} {
                    if {$RearFender(Radius) < $RearWheel(Radius)} {
                        set project::Component(Fender/Rear/Radius) [expr $RearWheel(Radius) + 5.0]
                        set RearFender(Radius)                     $project::Component(Fender/Rear/Radius)
                        puts "\n                     -> <i> \$project::Component(Fender/Rear/Radius) ........... $project::Component(Fender/Rear/Radius)"
                    }

                      #
                      # -- Component(Fender/Front/Radius) <-> $RearFender(Radius)
                      #       handle values like done in bikeGeometry::set_base_Parameters 
                    if {$FrontFender(Radius) < $FrontWheel(Radius)} {
                        set project::Component(Fender/Front/Radius) [expr $FrontWheel(Radius) + 5.0]
                        set FrontFender(Radius)                     $project::Component(Fender/Front/Radius)
                        puts "\n                     -> <i> \$project::Component(Fender/Front/Radius) .......... $project::Component(Fender/Front/Radius)"
                    }
            }
              #
            puts ""
              #
    }      


        #
        # --- set FrontWheel -----------------------
    proc bikeGeometry::get_FrontWheel {} {
            #
        variable FrontWheel
        variable RearWheel
            #
        set FrontWheel(RimDiameter) $project::Component(Wheel/Front/RimDiameter)    
        set FrontWheel(RimHeight)   $project::Component(Wheel/Front/RimHeight)    
        set FrontWheel(TyreHeight)  $project::Component(Wheel/Front/TyreHeight)    
        set FrontWheel(Radius)      [ expr 0.5*$FrontWheel(RimDiameter) + $FrontWheel(TyreHeight) ]    
        set FrontWheel(Distance_Y)  [ expr $project::Custom(BottomBracket/Depth) - $RearWheel(Radius) + $FrontWheel(Radius) ]
            #
        return    
            #
    }


        #
        # --- set RearWheel ------------------------
    proc bikeGeometry::get_RearWheel {} {
            #
        variable RearWheel
            #
        set RearWheel(RimDiameter)     $project::Component(Wheel/Rear/RimDiameter)
        set RearWheel(RimHeight)       $project::Component(Wheel/Rear/RimHeight)
        set RearWheel(TyreHeight)      $project::Component(Wheel/Rear/TyreHeight)
        set RearWheel(Radius)          [ expr 0.5*$RearWheel(RimDiameter) + $RearWheel(TyreHeight) ]
        set RearWheel(TyreWidthRadius) $project::Component(Wheel/Rear/TyreWidthRadius)
        set RearWheel(DistanceBB)      $project::Custom(WheelPosition/Rear)
        set RearWheel(Distance_X)      [ expr sqrt(pow($RearWheel(DistanceBB),2)  - pow($project::Custom(BottomBracket/Depth),2)) ]
        set RearWheel(HubWidth)        $project::Component(Wheel/Rear/HubWidth)
            #
        return    
            #
    }


        #
        # --- set Stem ----------------------------
    proc bikeGeometry::get_Stem {} {
            variable HeadTube
            variable HandleBar
            variable HeadSet
            variable Steerer
            variable Stem

                    set pt_00       $HandleBar(Position)
                    set pt_01       $Steerer(Stem)
                    set pt_02       $HeadSet(Stem)

                    # -- ceck coincidence
                    set checkStem           [ vectormath::checkPointCoincidence $pt_00 $pt_01]
                    if {$checkStem == 0} {
                        # puts "   ... no Stem required"
                        project::setValue Result(Components/Stem)   polygon     {}
                        return
                    }

                    set Stem(Direction)     [ vectormath::unifyVector $pt_01 $pt_00 ]
                    set angle                           [ vectormath::angle {1 0}    {0 0}    $Stem(Direction) ]
                    set clamp_SVGPolygon    "-18.8336,-17.9999 -15.7635,-18.3921 -13.3549,-19.887 -11.1307,-22.1168 -10.0644,-24.1389 -9.7316,-24.4732 -9.8958,-23.3099 -10.3089,-21.9026 -11.1479,-19.9125 -12.0719,-17.777 -15.3406,-11.3784 -16.1873,-10.0012 -17.4384,-9.0427 -18.8336,-8.3572 -17.4384,-9.0427 -16.1873,-10.0012 -15.3406,-11.3784 -12.0719,-17.777 -11.1479,-19.9125 -10.3089,-21.9026 -9.8958,-23.3099 -9.7316,-24.4732 -9.4316,-24.7774 -8.6838,-24.9999 -0.8,-24.9999 -0.8,-15.8802 0.8,-15.8802 0.8,-24.9998 5.6669,-24.9998 6.3699,-24.8858 6.9818,-24.5172 7.4284,-24.07 13.0499,-18.7437 13.049,-23.6727 12.6125,-24.0796 12.5936,-20.4963 12.6125,-24.0796 7.4284,-24.07 13.2207,-18.5818 15.8552,-15.7422 17.8482,-13.2995 19.8206,-9.913 20.8437,-7.292 21.5329,-4.4455 21.8005,-2.0944 21.9,0.0001 21.8005,2.0946 21.5329,4.4457 20.8437,7.2922 19.8206,9.9132 17.8482,13.2997 15.8552,15.7424 13.2207,18.582 7.4284,24.0702 12.6125,24.0798 12.5936,20.4965 12.6125,24.0798 13.049,23.6729 13.0499,18.7439 7.4284,24.0702 6.9818,24.5174 6.3699,24.886 5.6669,25 0.8,25 0.8,15.8804 4.18,15.3448 7.4163,14.0676 10.1772,12.2159 12.523,9.7973 14.299,6.9605 15.506,3.5323 15.9,0.0001 15.506,-3.5321 14.299,-6.9603 12.523,-9.7971 10.1772,-12.2157 7.4163,-14.0674 4.18,-15.3446 0.8,-15.8802 -0.8,-15.8802 -3.4694,-15.544 -6.2265,-14.634 -9.2433,-12.9378 -11.6453,-10.8246 -13.5388,-8.3403 -14.8801,-5.6139 -15.6719,-2.6977 -15.9,0.0001 -15.6719,2.6979 -14.8801,5.6141 -13.5388,8.3405 -11.6453,10.8248 -9.2433,12.938 -6.2265,14.6342 -3.4694,15.5442 -0.8,15.8804 0.8,15.8804 -0.8,15.8804 -0.8,25.0001 -8.6838,25.0001 -9.3776,24.6754 -9.7467,23.9553 -9.8958,23.3101 -10.3089,21.9028 -11.1479,19.9127 -12.0719,17.7772 -15.3406,11.3786 -16.1873,10.0014 -17.4384,9.0429 -18.8336,8.3574 -17.4384,9.0429 -16.1873,10.0014 -15.3406,11.3786 -12.0719,17.7772 -11.1479,19.9127 -10.3089,21.9028 -9.8958,23.3101 -9.7467,23.9553 -11.1307,22.117 -13.3549,19.8872 -15.7635,18.3923 -18.8336,18.0001 "
                    set clamp_SVGPolygon    "-20.2619,-17 -16.6918,-17.4561 -13.8908,-19.1945 -11.3044,-21.7874 -10.0644,-24.1389 -9.7316,-24.4732 -9.8958,-23.3099 -10.3089,-21.9026 -11.1479,-19.9125 -12.0719,-17.777 -15.3406,-11.3784 -16.1873,-10.0012 -17.4384,-9.0427 -18.8336,-8.3572 -17.4384,-9.0427 -16.1873,-10.0012 -15.3406,-11.3784 -12.0719,-17.777 -11.1479,-19.9125 -10.3089,-21.9026 -9.8958,-23.3099 -9.7316,-24.4732 -9.4316,-24.7774 -8.6838,-24.9999 -0.8,-24.9999 -0.8,-15.8802 0.8,-15.8802 0.8,-24.9998 5.6669,-24.9998 6.3699,-24.8858 6.9818,-24.5172 7.4284,-24.07 13.0499,-18.7437 13.049,-23.6727 12.6125,-24.0796 12.5936,-20.4963 12.6125,-24.0796 7.4284,-24.07 13.2207,-18.5818 15.8552,-15.7422 17.8482,-13.2995 19.8206,-9.913 20.8437,-7.292 21.5329,-4.4455 21.8005,-2.0944 21.9,0.0001 21.8005,2.0946 21.5329,4.4457 20.8437,7.2922 19.8206,9.9132 17.8482,13.2997 15.8552,15.7424 13.2207,18.582 7.4284,24.0702 12.6125,24.0798 12.5936,20.4965 12.6125,24.0798 13.049,23.6729 13.0499,18.7439 7.4284,24.0702 6.9818,24.5174 6.3699,24.886 5.6669,25 0.8,25 0.8,15.8804 4.18,15.3448 7.4163,14.0676 10.1772,12.2159 12.523,9.7973 14.299,6.9605 15.506,3.5323 15.9,0.0001 15.506,-3.5321 14.299,-6.9603 12.523,-9.7971 10.1772,-12.2157 7.4163,-14.0674 4.18,-15.3446 0.8,-15.8802 -0.8,-15.8802 -3.4694,-15.544 -6.2265,-14.634 -9.2433,-12.9378 -11.6453,-10.8246 -13.5388,-8.3403 -14.8801,-5.6139 -15.6719,-2.6977 -15.9,0.0001 -15.6719,2.6979 -14.8801,5.6141 -13.5388,8.3405 -11.6453,10.8248 -9.2433,12.938 -6.2265,14.6342 -3.4694,15.5442 -0.8,15.8804 0.8,15.8804 -0.8,15.8804 -0.8,25.0001 -8.6838,25.0001 -9.3776,24.6754 -9.7467,23.9553 -9.8958,23.3101 -10.3089,21.9028 -11.1479,19.9127 -12.0719,17.7772 -15.3406,11.3786 -16.1873,10.0014 -17.4384,9.0429 -18.8336,8.3574 -17.4384,9.0429 -16.1873,10.0014 -15.3406,11.3786 -12.0719,17.7772 -11.1479,19.9127 -10.3089,21.9028 -9.8958,23.3101 -9.7467,23.9553 -11.1307,22.117 -13.8952,19.3455 -16.8889,17.4875 -20.7048,17 "

                        set polygon         [ string map {"," " "}  $clamp_SVGPolygon ]
                        set polygon         [ coords_flip_y $polygon]
                        set polygon         [ vectormath::addVectorPointList [list $HandleBar(Distance) $HandleBar(Height)] $polygon]
                        set polygon         [ vectormath::rotatePointList $HandleBar(Position) $polygon $angle ]

                    set polygonLength   [ llength $polygon  ]
                    set pt_099          [ list [lindex $polygon 0] [lindex $polygon 1] ]
                    set pt_000          [ list [lindex $polygon $polygonLength-2] [lindex $polygon $polygonLength-1] ]
                    set stemWidth       [ vectormath::length $pt_099 $pt_000 ]
                    set stemDiameter    34
                    set vct_099         [ vectormath::parallel $pt_01 $pt_00 [expr 0.5 * $stemWidth        ] left]
                    set vct_000         [ vectormath::parallel $pt_01 $pt_00 [expr 0.5 * $stemWidth        ] ]
                    set vct_010         [ vectormath::parallel $pt_02 $pt_01 [expr 0.5 * $stemDiameter    + 4 ] ]
                    set pt_095          [ vectormath::intersectPoint [lindex $vct_099 0] [lindex $vct_099 1]  [lindex $vct_010 0] [lindex $vct_010 1] ]
                    set pt_50           [ vectormath::intersectPerp $pt_01 $pt_02 $pt_095 ]
                    set pt_51           [ vectormath::addVector $pt_50  [ vectormath::unifyVector {0 0} $HeadTube(Direction) 2] ]
                    set pt_005          [ vectormath::intersectPoint [lindex $vct_000 0] [lindex $vct_000 1]  [lindex $vct_010 0] [lindex $vct_010 1] ]
                    set pt_12           [ vectormath::intersectPerp $pt_01 $pt_02 $pt_005 ]
                    set pt_11           [ vectormath::addVector $pt_12 [ vectormath::unifyVector {0 0} $HeadTube(Direction) -2] ]
                    set vct_020         [ vectormath::parallel $pt_11 $pt_51 [expr 0.5 * $stemDiameter ] ]
                    set vct_021         [ vectormath::parallel $pt_11 $pt_51 [expr 0.5 * $stemDiameter ] left ]
                    set vct_030         [ vectormath::parallel $HeadSet(Stem) $pt_51 [expr 0.5 * $HeadSet(ShimDiameter) ] ];# ShimDiameter from HeadSet definition above
                    set vct_031         [ vectormath::parallel $HeadSet(Stem) $pt_51 [expr 0.5 * $HeadSet(ShimDiameter) ] left ]
                    set vct_040         [ vectormath::parallel [lindex  $vct_021 1] [lindex  $vct_020 1] 5  left]

                    set polygon         [ lappend polygon   $pt_005 \
                                                            [lindex  $vct_020 0] [lindex  $vct_021 0] [lindex  $vct_020 0] \
                                                            [lindex  $vct_030 0] [lindex  $vct_031 0] [lindex  $vct_021 0] \
                                                            [lindex  $vct_021 1] [lindex  $vct_020 1] [lindex  $vct_021 1] \
                                                            [lindex  $vct_040 0] [lindex  $vct_040 1] [lindex  $vct_020 1] \
                                                            $pt_095 ]
            project::setValue Result(Components/Stem)   polygon     [project::flatten_nestedList $polygon]
    }


        #
        # --- fill Result Values ------------------
    proc bikeGeometry::fill_resultValues {} {
            variable BottomBracket
            variable HeadTube
            variable TopTube
            variable Steerer
            variable RearWheel
            variable FrontWheel
            variable Saddle
            variable SeatTube
            variable SeatPost
            variable HandleBar
            variable Reference
            
                    #
                    # template of <Result>  .. </Result> is defined in
                    # 
                    #   /etc/initTemplate.xml
                    # 

                    # puts ""
                    # puts "       ... fill_resultValues"
                    # puts "      -------------------------------"
                    # puts "           "
                    
         


                # --- BottomBracket
                #
            set position    $BottomBracket(height)

                    # --- BottomBracket/Height
                    #
                set value      [ format "%.3f" [lindex $position 0] ]
                    # puts "                  ... $value"
                project::setValue Result(Length/BottomBracket/Height) value $value


                # --- HeadTube ----------------------------------------
                #
            set position    $HeadTube(Stem)

                    # --- HeadTube/ReachLength
                    #
                    # puts "                ... [ bikeGeometry::get_Object     HeadTube Stem           {0 0} ]"
                set value       [ format "%.3f" [lindex $position 0] ]
                    # puts "                  ... $value"
                project::setValue Result(Length/HeadTube/ReachLength) value $value

                    # --- HeadTube/StackHeight
                    #
                    # puts "                ... [ bikeGeometry::get_Object     HeadTube Stem           {0 0} ]"
                set value       [ format "%.3f" [lindex $position 1] ]
                    # puts "                  ... $value"
                project::setValue Result(Length/HeadTube/StackHeight) value $value



                # --- SeatTube ----------------------------------------
                    #
            set position    [ bikeGeometry::get_Object     SeatTube/End    position    {0 0} ]

                    # --- SeatTube/Angle ------------------------------
                    #
            set angle [ vectormath::angle $SeatPost(SeatTube) $SeatTube(BottomBracket) [list -200 [lindex $SeatTube(BottomBracket) 1]] ]
            set angle [ format "%.3f" $angle ]
            project::setValue Result(Angle/SeatTube/Direction) value $angle

                    # --- SeatTube/TubeLength -------------------------
                    #
                    # puts "                   ... [ bikeGeometry::get_Object        SeatTube TopTube    {0 0} ]"
                set value       [ format "%.3f" [ expr hypot([lindex $position 0],[lindex $position 1]) ] ]
                project::setValue Result(Length/SeatTube/TubeLength) value $value

                    # --- SeatTube/TubeHeight -------------------------
                    #
                    # puts "                   ... [ bikeGeometry::get_Object        SeatTube TopTube    {0 0} ]"
                set value        [ format "%.3f" [lindex $position 1] ]
                project::setValue Result(Length/SeatTube/TubeHeight) value $value
                    


                # --- VirtualTopTube ----------------------------------
                #
            set SeatTube(VirtualTopTube)    [ vectormath::intersectPoint [list -500 [lindex $HeadTube(Stem) 1]]  $HeadTube(Stem)  $SeatTube(BottomBracket) $SeatPost(SeatTube) ]
            project::setValue Result(Position/SeatTubeVirtualTopTube)    position    $SeatTube(VirtualTopTube)        ;# Point on the SeatTube of virtual TopTube

                    # --- TopTube/VirtualLength -----------------------
                    #
                    # puts "                  ... $value"
                set value       [ format "%.3f" [expr [lindex $HeadTube(Stem) 0] - [lindex $SeatTube(VirtualTopTube) 0] ] ]
                project::setValue Result(Length/TopTube/VirtualLength) value $value

                    # --- SeatTube/VirtualLength ----------------------
                    #
                    # puts "                  ... $value"
                set value       [ format "%.3f" [vectormath::length $SeatTube(VirtualTopTube) {0 0}] ]
                project::setValue Result(Length/SeatTube/VirtualLength) value $value


                # --- Saddle ------------------------------------------
                #
            set position_Saddle      $Saddle(Position)   
            set position_SaddleNose  $Saddle(Nose)            
            set position_SeatTube    [ split [ project::getValue Result(Position/SeatTubeSaddle)    position] ,]
            set position_HandleBar   $HandleBar(Position)
            set position_BB          {0 0}
                  # puts "   fill_resultValues  \$position_Saddle      $position_Saddle"
                  # puts "   fill_resultValues  \$position_SaddleNose  $position_SaddleNose"
                  # puts "   fill_resultValues  \$position_SeatTube    $position_SeatTube"
                  # puts "   \$position_HandleBar   $position_HandleBar"
                  # puts "   \$position_BB          $position_BB"
                
            
                    # --- Saddle/Offset_BB --------------------------------
                    #
                set value        [ format "%.3f" [expr -1 * [lindex $position_Saddle 0]] ]
                    # puts "                  ... $value"
                # project::setValue Result(Length/Saddle/Offset_BB) value $value
                #                  Result(Length/Saddle/Offset_BB)


                # --- Saddle/Offset_BB_ST -----------------------------
                #
                set value       [ format "%.3f" [expr -1 * [lindex $position_SeatTube 0]] ]
                    # puts "                  ... $value"
                project::setValue Result(Length/Saddle/Offset_BB_ST) value $value


                    # --- Saddle/Offset_HB --------------------------------
                    #
                set value       [ format "%.3f" [expr [lindex $position_Saddle 1] - [lindex $position_HandleBar 1]] ]
                    # puts "                  ... $value"
                project::setValue Result(Length/Saddle/Offset_HB) value $value

                
                    # --- Personal/SeatTube_BB ------------------------
                    #               
                  # puts "   \$position_SeatTube  $position_SeatTube"
                  # puts "   \$position_BB  $position_BB"
                set value       [ vectormath::length $position_SeatTube $position_BB]
                set value       [ format "%.3f" $value ]
                project::setValue Result(Length/Saddle/SeatTube_BB) value $value   

                
                    # --- Personal/Offset_BB_Nose -------------------------
                    #
                set value       [ format "%.3f" [expr -1.0 * [lindex $position_SaddleNose 0]] ]
                    # puts "                  ... $value"
                project::setValue Result(Length/Saddle/Offset_BB_Nose) value $value
                set value       [ expr  [lindex $position_HandleBar 0] + [expr -1.0 * [lindex $position_SaddleNose 0]] ]
                set value       [ format "%.3f" $value ]
                project::setValue Result(Length/Personal/SaddleNose_HB) value $value

                

                # --- WheelPosition/front/diagonal --------------------
                #
            set position    $FrontWheel(Position)
                    # puts "                ... $frameCoords::FrontWheel"
                set value       [ format "%.3f" [expr { hypot( [lindex $position 0], [lindex $position 1] ) }] ]
                    # puts "                  ... $value"
                project::setValue Result(Length/FrontWheel/diagonal) value $value


                # --- WheelPosition/front/horizontal ------------------
                #
            set position    $FrontWheel(Position)
                    # puts "                ... $frameCoords::FrontWheel"
                set value       [ format "%.3f" [lindex $position 0] ]
                    # puts "                  ... $value"
                project::setValue Result(Length/FrontWheel/horizontal) value $value


                # --- WheelPosition/rear/horizontal -------------------
                #
            set position    $RearWheel(Position)
                    # puts "                ... $frameCoords::RearWheel"
                set value       [ format "%.3f" [expr -1 * [lindex $position 0]] ]
                    # puts "                  ... $value"
                project::setValue Result(Length/RearWheel/horizontal) value $value


                # --- RearWheel/Radius --------------------------------
                #
            set rimDiameter     [ project::getValue Component(Wheel/Rear/RimDiameter) value ]
            set tyreHeight      [ project::getValue Component(Wheel/Rear/TyreHeight)  value ]
            set value           [ expr 0.5 * $rimDiameter + $tyreHeight ]                
                  # puts "                  ... $value"
                project::setValue Result(Length/RearWheel/Radius   value $value
                project::setValue Result(Length/RearWheel/Diameter value [expr 2.0 * $value]
              
                # --- RearWheel/TyreShoulder --------------------------------
                #
            set wheelRadius     [ project::getValue Result(Length/RearWheel/Radius         value ]
            set tyreWidthRadius [ project::getValue Component(Wheel/Rear/TyreWidthRadius)  value ]
            set value           [ expr $wheelRadius - $tyreWidthRadius ]                
                  # puts "                  ... $value"
                project::setValue Result(Length/RearWheel/TyreShoulder) value $value
              
                # --- FrontWheel/Radius -------------------------------
                #
            set rimDiameter   [ project::getValue Component(Wheel/Front/RimDiameter) value ]
            set tyreHeight    [ project::getValue Component(Wheel/Front/TyreHeight)  value ]
            set value         [ expr 0.5 * $rimDiameter + $tyreHeight ]                
                  # puts "                  ... $value"
                project::setValue Result(Length/FrontWheel/Radius value $value
                project::setValue Result(Length/FrontWheel/Diameter value [expr 2.0 * $value]
              
                


            set BB_Position             {0 0}
            set SeatStay(SeatTube)      [ bikeGeometry::get_Object     SeatStay/End            position ]
            set TopTube(SeatTube)       [ bikeGeometry::get_Object     TopTube/Start           position ]
            set TopTube(Steerer)        [ bikeGeometry::get_Object     TopTube/End             position ]
            set Steerer(Stem)           [ bikeGeometry::get_Object     Steerer/End             position ]
            set Steerer(Fork)           [ bikeGeometry::get_Object     Steerer/Start           position ]
            set DownTube(Steerer)       [ bikeGeometry::get_Object     DownTube/End            position ]
            set DownTube(BBracket)      [ bikeGeometry::get_Object     DownTube/Start          position ]
            set ChainSt_SeatSt_IS       [ bikeGeometry::get_Object     ChainStay/SeatStay_IS   position ]

            project::setValue Result(Angle/HeadTube/TopTube)        value    [ get_resultAngle $TopTube(Steerer)      $Steerer(Stem)      $TopTube(SeatTube)  ]
            project::setValue Result(Angle/HeadTube/DownTube)       value    [ get_resultAngle $DownTube(Steerer)     $BB_Position        $Steerer(Fork)      ]
            project::setValue Result(Angle/SeatTube/TopTube)        value    [ get_resultAngle $TopTube(SeatTube)     $BB_Position        $TopTube(Steerer)   ]
            project::setValue Result(Angle/SeatTube/SeatStay)       value    [ get_resultAngle $SeatStay(SeatTube)    $ChainSt_SeatSt_IS  $BB_Position        ]
            project::setValue Result(Angle/BottomBracket/DownTube)  value    [ get_resultAngle $BB_Position           $DownTube(Steerer)  $TopTube(SeatTube)  ]
            project::setValue Result(Angle/BottomBracket/ChainStay) value    [ get_resultAngle $BB_Position           $TopTube(SeatTube)  $ChainSt_SeatSt_IS  ]
            project::setValue Result(Angle/SeatStay/ChainStay)      value    [ get_resultAngle $ChainSt_SeatSt_IS     $BB_Position        $SeatStay(SeatTube) ]                
                
                
                
                # --- Reference Position ------------------------------
                #             
            set BB_Height    [expr  0.5 * $project::Component(Wheel/Rear/RimDiameter) +  $project::Component(Wheel/Rear/TyreHeight) -  $project::Custom(BottomBracket/Depth)]
            set SN_Distance  [expr -1.0 * $project::Reference(SaddleNose_Distance)]
            set SN_Height    [expr $project::Reference(SaddleNose_Height)  - $BB_Height]
            set HB_Distance  [expr $project::Reference(HandleBar_Distance) + $SN_Distance]
            set HB_Height    [expr $project::Reference(HandleBar_Height)   - $BB_Height]
             
            set Reference(HandleBar)    [list $HB_Distance $HB_Height]
            set Reference(SaddleNose)   [list $SN_Distance $SN_Height]
            project::setValue Result(Position/Reference_HB)      position    $Reference(HandleBar)   
            project::setValue Result(Position/Reference_SN)      position    $Reference(SaddleNose)
            
            project::setValue Result(Length/Reference/HandleBar_FW)  value   [vectormath::length $Reference(HandleBar) $FrontWheel(Position)]
            project::setValue Result(Length/Reference/HandleBar_BB)  value   [vectormath::length $Reference(HandleBar) {0 0}]
            project::setValue Result(Length/Reference/SaddleNose_HB) value   [vectormath::length $Reference(SaddleNose) $Reference(HandleBar)]
            project::setValue Result(Length/Reference/SaddleNose_BB) value   [vectormath::length $Reference(SaddleNose) {0 0}]
            project::setValue Result(Length/Reference/Heigth_SN_HB)  value   [expr $SN_Height - $HB_Height]      

              # puts "   ->  $project::Result(Position/Reference_HB)"
              # puts "   ->  $project::Result(Position/Reference_SN)"
              # puts "     ->  $project::Result(Length/Reference/HandleBar_FW)"           
              # puts "     ->  $project::Result(Length/Reference/HandleBar_BB)"           
              # puts "     ->  $project::Result(Length/Reference/SaddleNose_HB)"           
              # puts "     ->  $project::Result(Length/Reference/SaddleNose_BB)"           
              # puts "     ->  $project::Result(Length/Reference/Heigth_SN_HB)"           

    }


        #
        # --- set DerailleurMountFront ------------
    proc bikeGeometry::get_DerailleurMountFront {} {
            variable SeatTube
            variable FrontDerailleur

                set FrontDerailleur(Mount)  [ vectormath::rotatePoint   {0 0} [ list $FrontDerailleur(Distance) [expr -1.0*$FrontDerailleur(Offset)] ] [expr 180 - $SeatTube(Angle)] ]

            project::setValue Result(Position/DerailleurMountFront) position    $FrontDerailleur(Mount)
            # puts "    ... \$FrontDerailleur(Mount) $FrontDerailleur(Mount)"
    }


        #
        # --- set CarrierMountFront ---------------
    proc bikeGeometry::get_CarrierMountFront {} {
            variable FrontWheel
            variable FrontCarrier

                set FrontCarrier(Mount)    [ list [expr [lindex $FrontWheel(Position) 0] - $FrontCarrier(x)]  [expr [lindex $FrontWheel(Position) 1] + $FrontCarrier(y)]]

            project::setValue Result(Position/CarrierMountFront) position    $FrontCarrier(Mount)
            # puts "    ... \$FrontDerailleur(Mount) $FrontDerailleur(Mount)"
    }


        #
        # --- set CarrierMountRear ----------------
    proc bikeGeometry::get_CarrierMountRear {} {
            variable RearWheel
            variable FrontCarrier
            variable RearCarrier
            
                set RearCarrier(Mount)    [ list [expr [lindex $RearWheel(Position) 0] - $RearCarrier(x)]     [expr [lindex $RearWheel(Position) 1] + $RearCarrier(y)]]

            project::setValue Result(Position/CarrierMountRear) position    $RearCarrier(Mount)
            # puts "    ... \$FrontDerailleur(Mount) $FrontDerailleur(Mount)"
    }



        #
        # --- set BrakePosition - Rear -------------
    proc bikeGeometry::get_BrakePositionRear {} {
            variable RearBrake
            variable RearWheel
            variable SeatStay

            set RimBrakeRadius  [ expr 0.5 * $RearWheel(RimDiameter) ]

            set pt_00           $RearWheel(Position)
            set pt_01           [split [ project::getValue Result(Tubes/SeatStay/Start)      position ] , ]
            set pt_02           [split [ project::getValue Result(Tubes/SeatStay/End)        position ] , ]
            set pt_03           [split [ project::getValue Result(Tubes/SeatStay/Polygon)    polygon 8 ] , ]
            set pt_04           [split [ project::getValue Result(Tubes/SeatStay/Polygon)    polygon 9 ] , ]
            set pt_05           [ vectormath::intersectPerp    $pt_04 $pt_03 $pt_00 ]    ;# point on SeatStay through RearWheel
            set vct_01          [ vectormath::parallel $pt_03 $pt_05 $RearBrake(Offset) ]
            set pt_06           [ lindex $vct_01 1 ]
            set dist_00         [ vectormath::length $pt_00 $pt_06 ]
            set dist_00_Ortho   [ expr sqrt(pow($RimBrakeRadius,2)  - pow($dist_00,2)) ]

            set pt_10           [ vectormath::addVector    $pt_06 [ vectormath::unifyVector {0 0} $SeatStay(Direction) $dist_00_Ortho] ]
            set pt_12           [ vectormath::addVector    $pt_06 [ vectormath::unifyVector {0 0} $SeatStay(Direction) [expr $RearBrake(LeverLength) + $dist_00_Ortho] ] ]
            set pt_13           [ vectormath::intersectPerp $pt_03 $pt_04 $pt_10 ]
            set pt_14           [ vectormath::intersectPerp    $pt_03 $pt_04 $pt_12 ]
                # set pt_14     [ vectormath::intersectPerp    $pt_01 $pt_02 $pt_12 ]


            set RearBrake(Shoe)         $pt_10
            set RearBrake(Help)         $pt_12
            set RearBrake(Definition)   $pt_13
            set RearBrake(Mount)        $pt_14

            project::setValue Result(Position/BrakeRear)    position    $RearBrake(Shoe)
                #
                # - TODO -- remove above line -------
                #
            project::setValue Result(Position/Brake/Rear/Shoe)          position    $RearBrake(Shoe)
            project::setValue Result(Position/Brake/Rear/Help)          position    $RearBrake(Help)
            project::setValue Result(Position/Brake/Rear/Definition)    position    $RearBrake(Definition)
            project::setValue Result(Position/Brake/Rear/Mount)         position    $RearBrake(Mount)
               
             
                                    
                variable DEBUG_Geometry
                # set DEBUG_Geometry(pt_21) "[lindex $pt_01 0],[lindex $pt_01 1]"
                # set DEBUG_Geometry(pt_22) "[lindex $pt_02 0],[lindex $pt_02 1]"
                # set DEBUG_Geometry(pt_23) "[lindex $pt_03 0],[lindex $pt_03 1]"
                set DEBUG_Geometry(pt_13) "[lindex $pt_13 0],[lindex $pt_13 1]"
                set DEBUG_Geometry(pt_14) "[lindex $pt_14 0],[lindex $pt_14 1]"
    }


        #
        # --- set BrakePosition - Front ------------
    proc bikeGeometry::get_BrakePositionFront {} {

            variable HeadTube
            variable Steerer
            variable FrontBrake
            variable FrontWheel
            variable Fork
            variable myFork

            # -- ceck Parameter
            if {$FrontBrake(LeverLength) < 10} {
                set FrontBrake(LeverLength) 10.0
            }

            set RimBrakeRadius    [ expr 0.5 * $FrontWheel(RimDiameter) ]

            set pt_00           $FrontWheel(Position)
            set pt_01           [split [ project::getValue Result(Tubes/Steerer/Start)  position ] , ]
            set pt_02           [split [ project::getValue Result(Tubes/Steerer/End)    position ] , ]
            
            #set pt_03           [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    1] , ]
            #set pt_04           [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    0] , ]
            #puts "  -> \$pt_03  $pt_03"
            #puts "  -> \$pt_04  $pt_04"                    
            
              # puts "   -> \$Fork(BrakeOffsetDef) $Fork(BrakeOffsetDef)"
            set pt_04           [lrange $Fork(BrakeOffsetDef) 0 1]
            set pt_03           [lrange $Fork(BrakeOffsetDef) 2 3]

              # puts "  -> \$pt_03  $pt_03"
              # puts "  -> \$pt_04  $pt_04"
            
            set pt_05           [ vectormath::intersectPerp    $pt_04 $pt_03 $pt_00 ]    ;# point on Forkblade perpendicular through FrontWheel
              # puts "  -> \$pt_05  $pt_05"
            set vct_01          [ vectormath::parallel $pt_03 $pt_05 $myFork(BladeBrakeOffset) left]
            set pt_06           [ lindex $vct_01 1 ]

            set dist_00         [ vectormath::length $pt_00 $pt_06 ]
              # puts "expr sqrt(pow($RimBrakeRadius,2)  - pow($dist_00,2))"
            
            set dist_00_Ortho   [ expr sqrt(pow($RimBrakeRadius,2)  - pow($dist_00,2)) ]

            set pt_10           [ vectormath::addVector    $pt_06 [ vectormath::unifyVector $pt_03 $pt_04 $dist_00_Ortho] ]            ;# FrontBrake(Shoe)
            set pt_11           [ vectormath::addVector    $pt_10 [ vectormath::unifyVector {0 0} $HeadTube(Direction) $FrontBrake(LeverLength)] ]
            set pt_12           [ vectormath::rotatePoint    $pt_10    $pt_11    $myFork(CrownBrakeAngle) ]                                        ;# FrontBrake(Help)
            set pt_13           [ vectormath::intersectPerp $pt_04 $pt_03 $pt_10 ]


            set vct_02          [ vectormath::parallel $pt_01 $pt_02 $myFork(CrownBrakeOffset)]
            set pt_15           [ vectormath::rotatePoint    $pt_12    $pt_10    -90 ]
            set pt_16           [ vectormath::intersectPoint  [lindex $vct_02 0] [lindex $vct_02 1] $pt_12 $pt_15 ]

            set FrontBrake(Shoe)        $pt_10
            set FrontBrake(Help)        $pt_12
            set FrontBrake(Definition)  $pt_13
            set FrontBrake(Mount)       $pt_16

            project::setValue Result(Position/BrakeFront)   position    $FrontBrake(Shoe)
                #
                # - TODO -- remove above line -------
                #
            project::setValue Result(Position/Brake/Front/Shoe)          position   $FrontBrake(Shoe)
            project::setValue Result(Position/Brake/Front/Help)          position   $FrontBrake(Help)
            project::setValue Result(Position/Brake/Front/Definition)    position   $FrontBrake(Definition)
            project::setValue Result(Position/Brake/Front/Mount)         position   $FrontBrake(Mount)


                    # set pt_18         [split [ project::getValue Result(Tubes/ForkBlade/Start)     position] , ]
                    # set pt_19         [split [ project::getValue Result(Tubes/ForkBlade/End)       position] , ]
                    # set pt_05         [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    1] , ]
                    # set pt_06         [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    2] , ]
                    # set pt_11         [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    3] , ]
                    # set pt_12         [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    4] , ]
                    # set pt_13         [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    5] , ]
                    # set pt_14         [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    6] , ]
                    # set pt_15         $FrontBrake(Mount)
                    # set pt_18         [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    0] , ]
                    # set pt_19         [split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon    5] , ]



                    variable DEBUG_Geometry
                    #set DEBUG_Geometry(pt_00) "[lindex $pt_00 0],[lindex $pt_00 1]"
                    set DEBUG_Geometry(pt_03) "[lindex $pt_03 0],[lindex $pt_03 1]"
                    set DEBUG_Geometry(pt_04) "[lindex $pt_04 0],[lindex $pt_04 1]"
                    set DEBUG_Geometry(pt_14) "[lindex $pt_15 0],[lindex $pt_15 1]"

                    #set DEBUG_Geometry(pt_11) "[lindex $pt_11 0],[lindex $pt_11 1]"
                    #set DEBUG_Geometry(pt_12) "[lindex $pt_12 0],[lindex $pt_12 1]"
                    #set DEBUG_Geometry(pt_13) "[lindex $pt_13 0],[lindex $pt_13 1]"
                    #set DEBUG_Geometry(pt_14) "[lindex $pt_14 0],[lindex $pt_14 1]"
                    #set DEBUG_Geometry(pt_15) "[lindex $pt_15 0],[lindex $pt_15 1]"

                    # set DEBUG_Geometry(pt_03) "[lindex $pt_03 0],[lindex $pt_03 1]"
                    # set DEBUG_Geometry(pt_04) "[lindex $pt_04 0],[lindex $pt_04 1]"
                    # set DEBUG_Geometry(pt_05) "[lindex $pt_05 0],[lindex $pt_05 1]"
                    # set DEBUG_Geometry(pt_06) "[lindex $pt_06 0],[lindex $pt_06 1]"
                    #set DEBUG_Geometry(pt_18) "[lindex $pt_18 0],[lindex $pt_18 1]"
                    #set DEBUG_Geometry(pt_19) "[lindex $pt_19 0],[lindex $pt_19 1]"

    }


        #
        # --- set BottleCageMount ------------------
    proc bikeGeometry::get_BottleCageMount {} {
            variable BottleCage
            variable SeatTube
            variable DownTube

                    set pt_00   [ vectormath::addVector $SeatTube(BottomBracket)    $SeatTube(Direction)     $BottleCage(SeatTube)                ]
                    set vct_01  [ vectormath::parallel  $SeatTube(Direction)    $pt_00                     [expr  0.5 * $SeatTube(DiameterBB)] ]
                    set SeatTube(BottleCage_Base)            [ lindex $vct_01 1 ]
                    set SeatTube(BottleCage_Offset)          [ vectormath::addVector        $SeatTube(BottleCage_Base)            $SeatTube(Direction) 64.0 ]
            project::setValue Result(Tubes/SeatTube/BottleCage/Base)            position    $SeatTube(BottleCage_Base)
            project::setValue Result(Tubes/SeatTube/BottleCage/Offset)          position    $SeatTube(BottleCage_Offset)

                    set pt_00   [ vectormath::addVector $DownTube(BottomBracket)    $DownTube(Direction)     $BottleCage(DownTube)                ]
                    set vct_01  [ vectormath::parallel  $DownTube(BottomBracket)    $pt_00                     [expr -0.5 * $DownTube(DiameterBB)] ]
                    set DownTube(BottleCage_Base)            [ lindex $vct_01 1 ]
                    set DownTube(BottleCage_Offset)          [ vectormath::addVector        $DownTube(BottleCage_Base)            $DownTube(Direction) 64.0 ]
            project::setValue Result(Tubes/DownTube/BottleCage/Base)            position    $DownTube(BottleCage_Base)
            project::setValue Result(Tubes/DownTube/BottleCage/Offset)          position    $DownTube(BottleCage_Offset)

                    set pt_00   [ vectormath::addVector $DownTube(BottomBracket)    $DownTube(Direction)     $BottleCage(DownTube_Lower)            ]
                    set vct_01  [ vectormath::parallel  $DownTube(BottomBracket)    $pt_00                     [expr  0.5 * $DownTube(DiameterBB)] ]
                    set DownTube(BottleCage_Lower_Base)     [ lindex $vct_01 1 ]
                    set DownTube(BottleCage_Lower_Base)     [ lindex $vct_01 1 ]
                    set DownTube(BottleCage_Lower_Offset)   [ vectormath::addVector        $DownTube(BottleCage_Lower_Base)    $DownTube(Direction) 64.0 ]
            project::setValue Result(Tubes/DownTube/BottleCage_Lower/Base)      position    $DownTube(BottleCage_Lower_Base)
            project::setValue Result(Tubes/DownTube/BottleCage_Lower/Offset)    position    $DownTube(BottleCage_Lower_Offset)
    }


        #
        # --- set FrameJig ------------------------
    proc bikeGeometry::get_FrameJig {} {
            variable FrameJig
            variable RearWheel
            variable Steerer
            variable SeatPost

                    set pt_00           $RearWheel(Position)
                    set pt_01           $Steerer(Stem)
                    set pt_02           $Steerer(Fork)
                    set pt_03           $SeatPost(SeatTube)
                    set pt_04           {0 0}
                    set pt_10           [ vectormath::intersectPerp     $pt_01 $pt_02 $pt_00 ]
                    set pt_11           [ vectormath::intersectPoint    $pt_00 $pt_10 $pt_03 $pt_04 ]
            set FrameJig(HeadTube)  $pt_10
            set FrameJig(SeatTube)  $pt_11
    }


 
        #
        # --- Result Angles  ----------------------------------
    proc bikeGeometry::get_resultAngle {position point_1 point_2 } {
        set angle_p1    [ vectormath::dirAngle $position $point_1 ]
        set angle_p2    [ vectormath::dirAngle $position $point_2 ]
        set angle_ext   [expr $angle_p2 - $angle_p1]
            # puts "     angle_p1  -> $angle_p1"
            # puts "     angle_p2  -> $angle_p2"
            # puts "     angle_ext -> $angle_ext"
        if {$angle_ext < 0 } {set angle_ext [expr $angle_ext +360]}
        return $angle_ext
    }
    
    
 



 