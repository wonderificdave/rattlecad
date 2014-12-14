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
    proc bikeGeometry::create_GeometryFront {} {
                    #
            variable Geometry
            variable HandleBar
            variable HeadTube
            variable Steerer
            variable Stem
            variable Fork
            variable FrontWheel
            variable RearWheel
            variable BottomBracket
                #
            # puts "   ..     \$Geometry(HeadTube_Angle)    $Geometry(HeadTube_Angle)"
                #
                # set Fork(Height)            $project::Component(Fork/Height)
                # set Fork(Rake)              $project::Component(Fork/Rake)
                # set Stem(Angle)             $project::Component(Stem/Angle)
                # set Stem(Length)            $project::Component(Stem/Length)
                # set HandleBar(Distance)     $project::Personal(HandleBar_Distance)    
                # set HandleBar(Height)       $project::Personal(HandleBar_Height)
                # set Geometry(BottomBracket_Depth)    $project::Custom(BottomBracket/Depth)
                # set Geometry(HeadTube_Angle)         $project::Custom(HeadTube/Angle)
                #
                #
            set HandleBar(Position)     [ list $HandleBar(Distance) $HandleBar(Height) ]    
                #
            set vect_01 [ expr $Stem(Length) * cos($Stem(Angle) * $vectormath::CONST_PI / 180) ]
            set vect_03 [ expr $vect_01 / sin($Geometry(HeadTube_Angle) * $vectormath::CONST_PI / 180) ]
                #
            set Steerer(Handlebar)      [ list  [expr [lindex $HandleBar(Position) 0] - $vect_03]  [lindex $HandleBar(Position) 1] ]
                #
            set help_04 [ vectormath::rotateLine       $Steerer(Handlebar)     100    [expr 180 - $Geometry(HeadTube_Angle)]    ]
            set help_03 [ vectormath::rotateLine       $HandleBar(Position)    100    [expr  90 - $Geometry(HeadTube_Angle) + $Stem(Angle)]    ]
                #
            set Steerer(Stem)           [ vectormath::intersectPoint    $HandleBar(Position)  $help_03 $Steerer(Handlebar) $help_04 ]
                #
            set vect_04 [ vectormath::parallel         $Steerer(Stem)      $help_04    $Fork(Rake) ]
            set help_05 [ lindex $vect_04 0 ]
            set help_06 [ lindex $vect_04 1 ]
                #
            set FrontWheel(Position)    [ vectormath::intersectPoint    $help_05  $help_06 [list 0 $FrontWheel(Distance_y)] [list 200 $FrontWheel(Distance_y)] ]
            set FrontWheel(Distance_x)  [ lindex $FrontWheel(Position) 0]
            set FrontWheel(DistanceBB)  [ expr hypot($FrontWheel(Distance_x),$FrontWheel(Distance_x)) ]
                #
            set Steerer(FrontWheel)     [ vectormath::rotateLine    $FrontWheel(Position)    $Fork(Rake)    [expr 270 - $Geometry(HeadTube_Angle)] ]
            set Steerer(Fork)           [ vectormath::addVector     $Steerer(FrontWheel)     [ vectormath::unifyVector  $Steerer(FrontWheel)  $Steerer(Stem)  $Fork(Height) ] ]
               #
            set help_08  [ vectormath::addVector    $BottomBracket(Ground) {200 0}]
                #
            set Steerer(Ground)         [ vectormath::intersectPoint        $Steerer(Stem) $Steerer(Fork)      $BottomBracket(Ground)  $help_08 ]
                #
            set Fork(Dropout)           [list $FrontWheel(Distance_x)    [expr $Geometry(BottomBracket_Depth) + ($Geometry(FrontWheel_Radius) - $Geometry(RearWheel_Radius))]]
                #
            return
                #
    }
    proc bikeGeometry::create_GeometryRear {} {
                #
            variable Geometry
            variable RearWheel
            # variable BottomBracket
            variable RearDropout
                #
            variable Result
                #
            set RearWheel(Position)     [ list [expr -1.0 * $RearWheel(Distance_x)] $Geometry(BottomBracket_Depth) ]
                #
            set RearDropout(Position)   [ list [expr -1.0 * $RearWheel(Distance_x)] $Geometry(BottomBracket_Depth) ]
                #
            return
                #
    }   
    proc bikeGeometry::create_GeometryCenter {} {
                #
            variable Geometry
            variable Rendering
                #
            variable Result
                #
            variable Saddle
            variable SeatPost
            variable SeatTube
            variable BottomBracket
            variable TopTube
            variable RearWheel
            variable LegClearance
                #
            set Geometry(BottomBracket_Height)  [ expr $Geometry(RearWheel_Radius) - $Geometry(BottomBracket_Depth) ]
            set BottomBracket(Ground)           [ list 0    [expr - $Geometry(RearWheel_Radius) + $Geometry(BottomBracket_Depth) ] ]
                #
                # check-Value-procedure
            if {$Saddle(SaddleHeight) < 0} {
                   # set project::Component(Saddle/Height) 0
                   set Saddle(SaddleHeight) 0
                   # project::setValue Component(Saddle/Height) $Saddle(Saddle_Height)
            }
                #
            set Saddle(Position)        [ list [expr -1.0*$Saddle(Distance)]  $Saddle(Height) ]
            set Saddle(Nose)            [ vectormath::addVector  $Saddle(Position) [list [expr $Saddle(NoseLength) + $Saddle(Offset_x)] -15] ]
                #
            set SeatPost(Height)        [ expr $Saddle(Height) - $Saddle(SaddleHeight) ]
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
                # --- get LegClearance - Position
            set LegClearance(Position)  [ list $TopTube(PivotPosition)  [expr $LegClearance(Length) - ($Geometry(RearWheel_Radius) - $Geometry(BottomBracket_Depth)) ] ]
                #
                #
            set Saddle(Proposal)        [ vectormath::rotateLine {0 0}  [ expr 0.88*$LegClearance(Length) ]  [ expr 180 - $SeatTube(Angle) ] ]
                #
            set help_08  [ vectormath::addVector    $BottomBracket(Ground) {200 0}]
                #
            set SeatTube(Ground)    [ vectormath::intersectPoint        $SeatPost(SeatTube) $SeatTube(BottomBracket)      $BottomBracket(Ground)  $help_08 ]
                #
            set Geometry(SeatTubeSaddle)    [ vectormath::intersectPoint [list 0 [lindex $Saddle(Position) 1] ] [list 100 [lindex $Saddle(Position) 1]] $SeatTube(BottomBracket) $SeatPost(SeatTube) ]
                #
            # set Result(Position/BottomBracketGround)     $BottomBracket(Ground)
            # set Result(Position/BottomBracketGround)     [list 0     [expr - $Geometry(RearWheel_Radius) + $Geometry(BottomBracket_Depth) ]] ;# Point on the Ground perp. to BB
            set Geometry(LegClearance)      [list $TopTube(PivotPosition)     [expr $LegClearance(Length) - ($Geometry(RearWheel_Radius) - $Geometry(BottomBracket_Depth)) ]]
            # set Result(Position/LegClearance)            $Geometry(LegClearance)
            # set Result(Position/LegClearance)            [list $TopTube(PivotPosition)     [expr $LegClearance(Length) - ($RearWheel(Radius) - $Geometry(BottomBracket_Depth)) ]]
            # set Result(Position/Saddle)                  $Saddle(Position)
            # set Result(Position/SaddleNose)              $Saddle(Nose)
            # set Result(Position/SaddleProposal)          $Saddle(Proposal)
            # set Result(Position/SeatPostPivot)           $SeatPost(PivotPosition)
            # set Result(Position/SeatPostSaddle)          $SeatPost(Saddle)
            # set Result(Position/SeatPostSeatTube)        $SeatPost(SeatTube)
            # set Result(Position/SeatTubeGround)          $SeatTube(Ground)       ;# Point on the Ground in direction of SeatTube
            # set Result(Position/SeatTubeSaddle)          $Geometry(SeatTubeSaddle)
            # set SeatTube(Direction)         [list $SeatTube(Ground)  $SeatPost(SeatTube)]                
            # set Result(Tubes/SeatTube/Direction)         $SeatTube(Direction)                
            # set Result(Tubes/SeatTube/Direction)         [list $SeatTube(Ground)  $SeatPost(SeatTube)]                
                #
            return
                #
    }


    proc bikeGeometry::create_SummarySize {} {
            variable SeatPost
            variable SeatTube
            variable FrontWheel
            variable RearWheel
            variable BottomBracket
                #
            variable Geometry
            variable Result
            variable BoundingBox
                #
                # --- set summary Length of Frame, Saddle and Stem
            set summaryLength [format "%.6f" [ expr $RearWheel(Distance_x) + $FrontWheel(Distance_x)]]
            set summaryHeight [format "%.6f" [ expr $Geometry(BottomBracket_Depth) + 40 + [lindex $SeatPost(SeatTube) 1] ]]
                #
            set BoundingBox(SummarySize)       [list $summaryLength   $summaryHeight]
                #
            return    
                #
    }
    
    
        #
        #
        # --- set basePoints Attributes
        #
    proc bikeGeometry::create_Reference {} {
            variable FrontWheel
            variable BottomBracket
            variable Reference
                #
            # variable Result
                #
            set BB_Height    [expr  0.5 * $RearWheel(RimDiameter) +  $RearWheel(TyreHeight) -  $Geometry(BottomBracket_Depth)]
                #
            set SN_Distance  [expr -1.0 * $Reference(SaddleNose_Distance)]
            set SN_Height    [expr $Reference(SaddleNose_Height)  - $BB_Height]
                #
            set HB_Distance  [expr $Reference(HandleBar_Distance) + $SN_Distance]
            set HB_Height    [expr $Reference(HandleBar_Height)   - $BB_Height]
                #
            set Reference(HandleBar)    [list $HB_Distance $HB_Height]
            # set Result(Position/Reference_HB)          $Reference(HandleBar)
                #
            set Reference(SaddleNose)   [list $SN_Distance $SN_Height]
            # set Result(Position/Reference_SN)          $Reference(SaddleNose)
                #
    }    


        #
        # --- set FrontWheel -----------------------
    proc bikeGeometry::create_FrontWheel {} {
            #
        variable Geometry
        variable FrontWheel
        variable RearWheel
        # variable BottomBracket
            #
        set Geometry(FrontWheel_Radius) [ expr 0.5*$FrontWheel(RimDiameter) + $FrontWheel(TyreHeight) ]    
        set FrontWheel(Distance_y)  [ expr $Geometry(BottomBracket_Depth) - $Geometry(RearWheel_Radius) + $Geometry(FrontWheel_Radius) ]
            #
        return    
            #
    }


        #
        # --- set RearWheel ------------------------
    proc bikeGeometry::create_RearWheel {} {
            #
        variable Geometry
        variable RearWheel
        # variable BottomBracket
            #
        set Geometry(RearWheel_Radius)  [ expr 0.5*$RearWheel(RimDiameter) + $RearWheel(TyreHeight) ]
        set RearWheel(Distance_x)       [ expr sqrt(pow($RearWheel(DistanceBB),2)  - pow($Geometry(BottomBracket_Depth),2)) ]
            #
        return    
            #
    }


        #
        # --- fill Result Values ------------------
    proc bikeGeometry::fill_resultValues {} {
                #
            variable Geometry
            variable Reference
                #
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
            variable SeatStay
            variable DownTube
                #
            variable Result
                #

                
                #
                # template of <Result>  .. </Result> is defined in
                # 
                #   /etc/initTemplate.xml
                # 

                # puts ""
                # puts "       ... fill_resultValues"
                # puts "      -------------------------------"
                # puts ""
                

                #
                # --- BottomBracket
                #
            # set position    $Geometry(BottomBracket_Height)
                #
                # --- BottomBracket/Height
                #
            set Geometry(BottomBracket_Height) [ format "%.3f" [lindex $Geometry(BottomBracket_Height) 0] ]
                #
                # --- HeadTube ----------------------------------------
                #
            set position    $HeadTube(Stem)
                #
                # --- HeadTube/ReachLength
                #
            set value       [lindex $position 0] 
            set Geometry(ReachLengthResult) [ format "%.3f" $value ]
                # 
                # --- HeadTube/StackHeight
                #
            set value       [lindex $position 1]
            set Geometry(StackHeightResult) [ format "%.3f" $value ]
                #
                # --- SeatTube ----------------------------------------
                #
                # set position    [ bikeGeometry::get_Object_expired     SeatTube/End    position    {0 0} ]
                # puts "  -> $position"
            set position    $SeatTube(TopTube)
                # puts "  -> $position"
                #
                # --- SeatTube/Angle ------------------------------
                #
            set angle [ vectormath::angle $SeatPost(SeatTube) $SeatTube(BottomBracket) [list -200 [lindex $SeatTube(BottomBracket) 1]] ]
            set Geometry(SeatTube_Angle) [ format "%.3f" $angle ]
                #
                # --- SeatTube/TubeLength -------------------------
                #
            set value       [ format "%.3f" [ expr hypot([lindex $position 0],[lindex $position 1]) ] ]
            set Result(Length/SeatTube/TubeLength)  $value
                #
                # --- SeatTube/TubeHeight -------------------------
                #
            set value        [ format "%.3f" [lindex $position 1] ]
            set Result(Length/SeatTube/TubeHeight)  $value
                #
                # --- VirtualTopTube ----------------------------------
                #
            set SeatTube(VirtualTopTube)    [ vectormath::intersectPoint [list -500 [lindex $HeadTube(Stem) 1]]  $HeadTube(Stem)  $SeatTube(BottomBracket) $SeatPost(SeatTube) ]
                #
                # --- TopTube/VirtualLength -----------------------
                #
            set value       [expr [lindex $HeadTube(Stem) 0] - [lindex $SeatTube(VirtualTopTube) 0] ]
            set Geometry(TopTubeVirtual)       [ format "%.3f" $value ]
                #
                # --- SeatTube/VirtualLength ----------------------
                #
            set value       [vectormath::length $SeatTube(VirtualTopTube) {0 0}]
            set Geometry(SeatTubeVirtual) [ format "%.3f" $value]
                #
                # --- Saddle ------------------------------------------
                #
            set position_Saddle      $Saddle(Position)   
            set position_SaddleNose  $Saddle(Nose)            
            set position_SeatTube    $Geometry(SeatTubeSaddle)
            set position_HandleBar   $HandleBar(Position)
            set position_BB          {0 0}
                #
                # --- Saddle/Offset_BB --------------------------------
                #
            set value        [ format "%.3f" [expr -1 * [lindex $position_Saddle 0]] ]
                # puts "                  ... $value"
            set Result(Length/Saddle/Offset_BB) $value
                #
                # --- Saddle/Offset_BB_ST -----------------------------
                #
            set value       [ format "%.3f" [expr -1 * [lindex $position_SeatTube 0]] ]
            set Geometry(Saddle_Offset_BB_ST)  $value
                # 
                # --- Saddle/Offset_HB --------------------------------
                #
            set value       [expr [lindex $position_Saddle 1] - [lindex $position_HandleBar 1]]
            set Geometry(Saddle_HB_y) [ format "%.3f" $value ]
                #
                # --- Personal/SeatTube_BB ------------------------
                #               
            set value       [ vectormath::length $position_SeatTube $position_BB]
            set Geometry(Saddle_BB) [ format "%.3f" $value ]
                #
                # --- Personal/Offset_BB_Nose -------------------------
                #
            set value       [expr -1.0 * [lindex $position_SaddleNose 0]]
            set Geometry(SaddleNose_BB_x) [ format "%.3f" $value ]
            set value       [ expr  [lindex $position_HandleBar 0] + [expr -1.0 * [lindex $position_SaddleNose 0]] ]
            set Geometry(SaddleNose_HB) [ format "%.3f" $value ]
                #
                # --- WheelPosition/front/diagonal --------------------
                #
            set position    $FrontWheel(Position)
            set value       [expr { hypot( [lindex $position 0], [lindex $position 1] ) }]
            set Geometry(FrontWheel_xy)       [ format "%.3f" $value ]
                #
                # --- WheelPosition/front/horizontal ------------------
                #
            set position    $FrontWheel(Position)
            set value       [lindex $position 0]
            set Geometry(FrontWheel_x)       [ format "%.3f" $value ]
                #
                # --- WheelPosition/rear/horizontal -------------------
                #
            set position    $RearWheel(Position)
            set value       [expr -1 * [lindex $position 0]]
            set Geometry(RearWheel_x)       [ format "%.3f" $value ]
                #
                # --- RearWheel/Radius --------------------------------
                #
            set Geometry(RearWheel_Radius)  [ expr 0.5 * $RearWheel(RimDiameter) + $RearWheel(TyreHeight)]
            set RearWheel(Diameter)         [ expr 2.0 * $Geometry(RearWheel_Radius)]
                #
                # --- RearWheel/TyreShoulder --------------------------------
                #
            set RearWheel(TyreShoulder)     [ expr $Geometry(RearWheel_Radius) - $RearWheel(TyreWidthRadius) ]
                #
                # --- FrontWheel/Radius -------------------------------
                #
            set Geometry(FrontWheel_Radius) [ expr 0.5 * $FrontWheel(RimDiameter) + $FrontWheel(TyreHeight) ]
            set FrontWheel(Diameter)        [ expr 2.0 * $Geometry(FrontWheel_Radius)]
                #
            set BB_Position             {0 0}
                #
            set ChainSt_SeatSt_IS       [ bikeGeometry::get_Object_expired     ChainStay/SeatStay_IS   position ]
                #  
            set Result(Angle_HeadTubeTopTube)             [format "%.4f" [ get_resultAngle $TopTube(HeadTube)     $Steerer(Stem)      $TopTube(SeatTube)  ]]  ; # Result(Angle/HeadTube/TopTube)
            set Result(Angle_HeadTubeDownTube)            [format "%.4f" [ get_resultAngle $DownTube(HeadTube)    $BB_Position        $Steerer(Fork)      ]]  ;# Result(Angle/HeadTube/DownTube)      
            set Result(Angle_SeatTubeTopTube)             [format "%.4f" [ get_resultAngle $TopTube(SeatTube)     $BB_Position        $TopTube(HeadTube)  ]]  ;# Result(Angle/SeatTube/TopTube)       
            set Result(Angle_SeatTubeSeatStay)            [format "%.4f" [ get_resultAngle $SeatStay(SeatTube)    $ChainSt_SeatSt_IS  $BB_Position        ]]  ;# Result(Angle/SeatTube/SeatStay)      
            set Result(Angle_BottomBracketDownTube)       [format "%.4f" [ get_resultAngle $BB_Position           $DownTube(HeadTube) $TopTube(SeatTube)  ]]  ;# Result(Angle/BottomBracket/DownTube) 
            set Result(Angle_BottomBracketChainStay)      [format "%.4f" [ get_resultAngle $BB_Position           $TopTube(SeatTube)  $ChainSt_SeatSt_IS  ]]  ;# Result(Angle/BottomBracket/ChainStay)
            set Result(Angle_SeatStayChainStay)           [format "%.4f" [ get_resultAngle $ChainSt_SeatSt_IS     $BB_Position        $SeatStay(SeatTube) ]]  ;# Result(Angle/SeatStay/ChainStay)                 
                #
                # --- Reference Position ------------------------------
                #             
            set BB_Height    [expr  0.5 * $RearWheel(RimDiameter) +  $RearWheel(TyreHeight) -  $Geometry(BottomBracket_Depth)]
            set SN_Distance  [expr -1.0 * $Reference(SaddleNose_Distance)]
            set SN_Height    [expr $Reference(SaddleNose_Height)  - $BB_Height]
            set HB_Distance  [expr $Reference(HandleBar_Distance) + $SN_Distance]
            set HB_Height    [expr $Reference(HandleBar_Height)   - $BB_Height]
                #
            set Reference(HandleBar)        [list $HB_Distance $HB_Height]
            set Reference(SaddleNose)       [list $SN_Distance $SN_Height]
                #
            set Reference(HandleBar_BB)     [vectormath::length $Reference(HandleBar) {0 0}]                   ;#Result(Length/Reference/HandleBar_BB) 
            set Reference(HandleBar_FW)     [vectormath::length $Reference(HandleBar) $FrontWheel(Position)]   ;#Result(Length/Reference/HandleBar_FW) 
            set Reference(SaddleNose_BB)    [vectormath::length $Reference(SaddleNose) {0 0}]                  ;#Result(Length/Reference/SaddleNose_BB)
            set Reference(SaddleNose_HB)    [vectormath::length $Reference(SaddleNose) $Reference(HandleBar)]  ;#Result(Length/Reference/SaddleNose_HB)            
            set Reference(SaddleNose_HB_y)  [expr $SN_Height - $HB_Height]                                     ;#Result(Length/Reference/Heigth_SN_HB)             
                #
            return
                #
    }


        #
        # --- set DerailleurMountFront ------------
    proc bikeGeometry::create_DerailleurMountFront {} {
            variable SeatTube
            variable FrontDerailleur
                #
            variable Result
                #
            set FrontDerailleur(Mount)  [ vectormath::rotatePoint   {0 0} [ list $FrontDerailleur(Distance) [expr -1.0*$FrontDerailleur(Offset)] ] [expr 180 - $SeatTube(Angle)] ]
                #
            return
                #
    }


        #
        # --- set CarrierMountFront ---------------
    proc bikeGeometry::create_CarrierMountFront {} {
                #
            variable FrontWheel
            variable FrontCarrier
                #
            variable Result
                #
            set FrontCarrier(Mount)    [ list [expr [lindex $FrontWheel(Position) 0] - $FrontCarrier(x)]  [expr [lindex $FrontWheel(Position) 1] + $FrontCarrier(y)]]
                #
            return
                #
    }


        #
        # --- set CarrierMountRear ----------------
    proc bikeGeometry::create_CarrierMountRear {} {
                #
            variable RearWheel
            variable FrontCarrier
            variable RearCarrier
                #
            variable Result
                #
            set RearCarrier(Mount)    [ list [expr [lindex $RearWheel(Position) 0] - $RearCarrier(x)]     [expr [lindex $RearWheel(Position) 1] + $RearCarrier(y)]]
                #
            return
                #
    }



        #
        # --- set BrakePosition - Rear -------------
    proc bikeGeometry::create_BrakePositionRear {} {
                #
            variable RearBrake
            variable RearWheel
            variable SeatStay
                #
            variable Result
                #
            set RimBrakeRadius  [ expr 0.5 * $RearWheel(RimDiameter) ]
                #
            set pt_00           $RearWheel(Position)
            set pt_01           $SeatStay(RearWheel)
            set pt_02           $SeatStay(SeatTube)
            set pt_03           [lrange $SeatStay(Polygon)    16 17 ]
            set pt_04           [lrange $SeatStay(Polygon)    18 19 ]
            set pt_05           [ vectormath::intersectPerp    $pt_04 $pt_03 $pt_00 ]    ;# point on SeatStay through RearWheel
            set vct_01          [ vectormath::parallel $pt_03 $pt_05 $RearBrake(Offset) ]
            set pt_06           [ lindex $vct_01 1 ]
            set dist_00         [ vectormath::length $pt_00 $pt_06 ]
            set dist_00_Ortho   [ expr sqrt(pow($RimBrakeRadius,2)  - pow($dist_00,2)) ]
                #
            set pt_10           [ vectormath::addVector    $pt_06 [ vectormath::unifyVector {0 0} $SeatStay(Direction) $dist_00_Ortho] ]
            set pt_12           [ vectormath::addVector    $pt_06 [ vectormath::unifyVector {0 0} $SeatStay(Direction) [expr $RearBrake(LeverLength) + $dist_00_Ortho] ] ]
            set pt_13           [ vectormath::intersectPerp $pt_03 $pt_04 $pt_10 ]
            set pt_14           [ vectormath::intersectPerp    $pt_03 $pt_04 $pt_12 ]
                # 
            set RearBrake(Shoe)         $pt_10
            set RearBrake(Help)         $pt_12
            set RearBrake(Definition)   $pt_13
            set RearBrake(Mount)        $pt_14
                #
                #                   
            variable DEBUG_Geometry
                # set DEBUG_Geometry(pt_21) "[lindex $pt_01 0],[lindex $pt_01 1]"
                # set DEBUG_Geometry(pt_22) "[lindex $pt_02 0],[lindex $pt_02 1]"
                # set DEBUG_Geometry(pt_23) "[lindex $pt_03 0],[lindex $pt_03 1]"
            set DEBUG_Geometry(pt_13) "[lindex $pt_13 0],[lindex $pt_13 1]"
            set DEBUG_Geometry(pt_14) "[lindex $pt_14 0],[lindex $pt_14 1]"
                #
            return
                #
    }


        #
        # --- set BrakePosition - Front ------------
    proc bikeGeometry::create_BrakePositionFront {} {
                #
            variable HeadTube
            variable Steerer
            variable FrontBrake
            variable FrontWheel
            variable Fork
                #
            variable Result
                #
                # -- ceck Parameter
            if {$FrontBrake(LeverLength) < 10} {
                set FrontBrake(LeverLength) 10.0
            }

            set RimBrakeRadius    [ expr 0.5 * $FrontWheel(RimDiameter) ]

            set pt_00           $FrontWheel(Position)
                #
                # puts "   -> \$Fork(BrakeOffsetDef) $Fork(BrakeOffsetDef)"
            set pt_04           [lrange $Fork(BrakeOffsetDef) 0 1]
            set pt_03           [lrange $Fork(BrakeOffsetDef) 2 3]
                #
                # puts "  -> \$pt_03  $pt_03"
                # puts "  -> \$pt_04  $pt_04"
                #
            set pt_05           [ vectormath::intersectPerp    $pt_04 $pt_03 $pt_00 ]    ;# point on Forkblade perpendicular through FrontWheel
                # puts "  -> \$pt_05  $pt_05"
            set vct_01          [ vectormath::parallel $pt_03 $pt_05 $Fork(BladeBrakeOffset) left]
                # set vct_01          [ vectormath::parallel $pt_03 $pt_05 $myFork(BladeBrakeOffset) left]
            set pt_06           [ lindex $vct_01 1 ]
                #
            set dist_00         [ vectormath::length $pt_00 $pt_06 ]
                # puts "expr sqrt(pow($RimBrakeRadius,2)  - pow($dist_00,2))"
                #
            set dist_00_Ortho   [ expr sqrt(pow($RimBrakeRadius,2)  - pow($dist_00,2)) ]
                #
            set pt_10           [ vectormath::addVector    $pt_06 [ vectormath::unifyVector $pt_03 $pt_04 $dist_00_Ortho] ]            ;# FrontBrake(Shoe)
            set pt_11           [ vectormath::addVector    $pt_10 [ vectormath::unifyVector {0 0} $HeadTube(Direction) $FrontBrake(LeverLength)] ]
            set pt_12           [ vectormath::rotatePoint    $pt_10    $pt_11    $Fork(CrownBrakeAngle) ]                                        ;# FrontBrake(Help)
            set pt_13           [ vectormath::intersectPerp $pt_04 $pt_03 $pt_10 ]
                #
            set vct_02          [ vectormath::parallel $Steerer(Fork) $Steerer(Stem) $Fork(CrownBrakeOffset)]
                #puts "  ... $vct_02"
                #puts "  ... $vct_02"
            set pt_15           [ vectormath::rotatePoint    $pt_12    $pt_10    -90 ]
            set pt_16           [ vectormath::intersectPoint  [lindex $vct_02 0] [lindex $vct_02 1] $pt_12 $pt_15 ]
                #
            set FrontBrake(Shoe)        $pt_10
            set FrontBrake(Help)        $pt_12
            set FrontBrake(Definition)  $pt_13
            set FrontBrake(Mount)       $pt_16
                #
                #
            variable DEBUG_Geometry
                #
            set DEBUG_Geometry(pt_03) "[lindex $pt_03 0],[lindex $pt_03 1]"
            set DEBUG_Geometry(pt_04) "[lindex $pt_04 0],[lindex $pt_04 1]"
            set DEBUG_Geometry(pt_14) "[lindex $pt_15 0],[lindex $pt_15 1]"
                #
                # set DEBUG_Geometry(pt_11) "[lindex $pt_11 0],[lindex $pt_11 1]"
                # set DEBUG_Geometry(pt_12) "[lindex $pt_12 0],[lindex $pt_12 1]"
                # set DEBUG_Geometry(pt_13) "[lindex $pt_13 0],[lindex $pt_13 1]"
                # set DEBUG_Geometry(pt_14) "[lindex $pt_14 0],[lindex $pt_14 1]"
                # set DEBUG_Geometry(pt_15) "[lindex $pt_15 0],[lindex $pt_15 1]"
                #
                # set DEBUG_Geometry(pt_03) "[lindex $pt_03 0],[lindex $pt_03 1]"
                # set DEBUG_Geometry(pt_04) "[lindex $pt_04 0],[lindex $pt_04 1]"
                # set DEBUG_Geometry(pt_05) "[lindex $pt_05 0],[lindex $pt_05 1]"
                # set DEBUG_Geometry(pt_06) "[lindex $pt_06 0],[lindex $pt_06 1]"
                # set DEBUG_Geometry(pt_18) "[lindex $pt_18 0],[lindex $pt_18 1]"
                # set DEBUG_Geometry(pt_19) "[lindex $pt_19 0],[lindex $pt_19 1]"
                #
            return
                #
    }


        #
        # --- set BottleCageMount ------------------
    proc bikeGeometry::create_BottleCageMount {} {
                #
            variable BottleCage
            variable SeatTube
            variable DownTube
                #
            variable Result
                #
            set pt_00   [ vectormath::addVector $SeatTube(BottomBracket)    $SeatTube(Direction)     $BottleCage(SeatTube)                ]
            set vct_01  [ vectormath::parallel  $SeatTube(Direction)    $pt_00                     [expr  0.5 * $SeatTube(DiameterBB)] ]
            set SeatTube(BottleCage_Base)            [ lindex $vct_01 1 ]
            set SeatTube(BottleCage_Offset)          [ vectormath::addVector        $SeatTube(BottleCage_Base)            $SeatTube(Direction) 64.0 ]
                #
            set pt_00   [ vectormath::addVector $DownTube(BottomBracket)    $DownTube(Direction)     $BottleCage(DownTube)                ]
            set vct_01  [ vectormath::parallel  $DownTube(BottomBracket)    $pt_00                     [expr -0.5 * $DownTube(DiameterBB)] ]
            set DownTube(BottleCage_Base)            [ lindex $vct_01 1 ]
            set DownTube(BottleCage_Offset)          [ vectormath::addVector        $DownTube(BottleCage_Base)            $DownTube(Direction) 64.0 ]
                #
            set pt_00   [ vectormath::addVector $DownTube(BottomBracket)    $DownTube(Direction)     $BottleCage(DownTube_Lower)            ]
            set vct_01  [ vectormath::parallel  $DownTube(BottomBracket)    $pt_00                     [expr  0.5 * $DownTube(DiameterBB)] ]
            set DownTube(BottleCage_Lower_Base)     [ lindex $vct_01 1 ]
            set DownTube(BottleCage_Lower_Base)     [ lindex $vct_01 1 ]
            set DownTube(BottleCage_Lower_Offset)   [ vectormath::addVector        $DownTube(BottleCage_Lower_Base)    $DownTube(Direction) 64.0 ]
                #
            return
                #
    }


        #
        # --- set FrameJig ------------------------
    proc bikeGeometry::create_FrameJig {} {
                #
            variable FrameJig
            variable RearWheel
            variable Steerer
            variable SeatPost
                #
            set pt_00           $RearWheel(Position)
            set pt_01           $Steerer(Stem)
            set pt_02           $Steerer(Fork)
            set pt_03           $SeatPost(SeatTube)
            set pt_04           {0 0}
            set pt_10           [ vectormath::intersectPerp     $pt_01 $pt_02 $pt_00 ]
            set pt_11           [ vectormath::intersectPoint    $pt_00 $pt_10 $pt_03 $pt_04 ]
                #
            set FrameJig(HeadTube)  $pt_10
            set FrameJig(SeatTube)  $pt_11
                #
            return
                #
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