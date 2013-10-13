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


        

    #-------------------------------------------------------------------------
        #  compute all values of the project 
        #
        #    <T> ... should be renamed to compute_Project
        #
    proc bikeGeometry::set_base_Parameters {} {
            
            variable Project

            variable BottomBracket
            variable RearWheel
            variable FrontWheel
            variable HandleBar
            variable Saddle
            variable SeatPost
            variable LegClearance

            variable HeadTube
            variable SeatTube
            variable DownTube
            variable TopTube
            variable ChainStay
            variable SeatStay
            variable Steerer
            variable ForkBlade

            variable Fork
            variable HeadSet
            variable Stem
            variable RearDrop

            variable RearBrake
            variable FrontBrake
            variable FrontDerailleur

            variable BottleCage
            variable FrameJig
            variable TubeMiter

            variable DEBUG_Geometry

              # appUtil::get_procHierarchy

                #
                # --- increase global update timestamp
                #
                #  ... this should migrate to anywhere else
                #
                # set ::APPL_Config(canvasCAD_Update)    [ clock milliseconds ]


                #
                # --- set Project attributes
            set Project(Project)        $project::Project(Name)
            set Project(modified)       $project::Project(modified)

                #
                # --- get BottomBracket (1)
            set BottomBracket(depth)    $project::Custom(BottomBracket/Depth)
            set BottomBracket(outside)  $project::Lugs(BottomBracket/Diameter/outside)
            set BottomBracket(inside)   $project::Lugs(BottomBracket/Diameter/inside)
            set BottomBracket(width)    $project::Lugs(BottomBracket/Width)
                # check-Value-procedure
                if {[expr $BottomBracket(outside) -2.0] < $BottomBracket(inside)} {
                        set project::Lugs(BottomBracket/Diameter/inside) [expr $BottomBracket(outside) -2.0]
                        set BottomBracket(inside)   $project::Lugs(BottomBracket/Diameter/inside)
                }
            set BottomBracket(OffsetCS_TopView)    $project::Lugs(BottomBracket/ChainStay/Offset_TopView)

                #
                # --- get RearWheel
            set RearWheel(RimDiameter)  $project::Component(Wheel/Rear/RimDiameter)
            set RearWheel(RimHeight)    $project::Component(Wheel/Rear/RimHeight)
            set RearWheel(TyreHeight)   $project::Component(Wheel/Rear/TyreHeight)
            set RearWheel(Radius)       [ expr 0.5*$RearWheel(RimDiameter) + $RearWheel(TyreHeight) ]
            set RearWheel(DistanceBB)   $project::Custom(WheelPosition/Rear)
            #set RearWheel(Distance_X)  [ expr sqrt(pow($RearWheel(DistanceBB),2)  - pow($project::Custom(BottomBracket/Depth),2)) ]
            set RearWheel(Distance_X)   [ expr sqrt(pow($RearWheel(DistanceBB),2)  - pow($project::Custom(BottomBracket/Depth),2)) ]
            set RearWheel(Position)     [ list [expr -1.0 * $RearWheel(Distance_X)] $project::Custom(BottomBracket/Depth) ]
            set RearWheel(HubWidth)     $project::Component(Wheel/Rear/HubWidth)
                # set RearWheel(Distance_X) 450

                #
                # --- get BottomBracket (2)
            set BottomBracket(height)    [ expr $RearWheel(Radius) - $project::Custom(BottomBracket/Depth) ]
            set BottomBracket(Ground)    [ list 0    [expr - $RearWheel(Radius) + $project::Custom(BottomBracket/Depth) ] ]

                #
                # --- get FrontWheel
            set FrontWheel(RimDiameter) $project::Component(Wheel/Front/RimDiameter)
            set FrontWheel(RimHeight)   $project::Component(Wheel/Front/RimHeight)
            set FrontWheel(TyreHeight)  $project::Component(Wheel/Front/TyreHeight)
            set FrontWheel(Radius)      [ expr 0.5*$FrontWheel(RimDiameter) + $FrontWheel(TyreHeight) ]
            set FrontWheel(Distance_Y)  [ expr $project::Custom(BottomBracket/Depth) - $RearWheel(Radius) + $FrontWheel(Radius) ]

                #
                # --- get HandleBarMount - Position
            set HandleBar(Distance)     $project::Personal(HandleBar_Distance)
            set HandleBar(Height)       $project::Personal(HandleBar_Height)
            set HandleBar(Position)     [ list $HandleBar(Distance) $HandleBar(Height) ]


                #
                # --- get Fork -----------------------------
            set Fork(Height)                $project::Component(Fork/Height)
            set Fork(Rake)                  $project::Component(Fork/Rake)
            set Fork(BladeWith)             $project::Component(Fork/Blade/Width)
            set Fork(BladeDiameterDO)       $project::Component(Fork/Blade/DiameterDO)
            set Fork(BladeTaperLength)      $project::Component(Fork/Blade/TaperLength)
            set Fork(BladeBendRadius)       $project::Component(Fork/Blade/BendRadius)
            set Fork(BladeEndLength)        $project::Component(Fork/Blade/EndLength)
            set Fork(BladeOffsetCrown)      $project::Component(Fork/Crown/Blade/Offset)
            set Fork(BladeOffsetCrownPerp)  $project::Component(Fork/Crown/Blade/OffsetPerp)
            set Fork(BladeOffsetDO)         $project::Component(Fork/DropOut/Offset)
            set Fork(BladeOffsetDOPerp)     $project::Component(Fork/DropOut/OffsetPerp)
            set Fork(BrakeAngle)            $project::Component(Fork/Crown/Brake/Angle)
            set Fork(BrakeOffset)           $project::Component(Fork/Crown/Brake/Offset)

                #
                # --- get Stem -----------------------------
            set Stem(Angle)                 $project::Component(Stem/Angle)
            set Stem(Length)                $project::Component(Stem/Length)

                #
                # --- get HeadTube -------------------------
            set HeadTube(ForkRake)          $Fork(Rake)
            set HeadTube(ForkHeight)        $Fork(Height)
            set HeadTube(Diameter)          $project::FrameTubes(HeadTube/Diameter)
            set HeadTube(Length)            $project::FrameTubes(HeadTube/Length)
            set HeadTube(Angle)             $project::Custom(HeadTube/Angle)

                #
                # --- get SeatTube -------------------------
            set SeatTube(DiameterBB)        $project::FrameTubes(SeatTube/DiameterBB)
            set SeatTube(DiameterTT)        $project::FrameTubes(SeatTube/DiameterTT)
            set SeatTube(TaperLength)       $project::FrameTubes(SeatTube/TaperLength)
            set SeatTube(Extension)         $project::Custom(SeatTube/Extension)
            set SeatTube(OffsetBB)          $project::Custom(SeatTube/OffsetBB)

                #
                # --- get DownTube -------------------------
            set DownTube(DiameterBB)        $project::FrameTubes(DownTube/DiameterBB)
            set DownTube(DiameterHT)        $project::FrameTubes(DownTube/DiameterHT)
            set DownTube(TaperLength)       $project::FrameTubes(DownTube/TaperLength)
            set DownTube(OffsetHT)          $project::Custom(DownTube/OffsetHT)
            set DownTube(OffsetBB)          $project::Custom(DownTube/OffsetBB)

                #
                # --- get TopTube --------------------------
            set TopTube(DiameterHT)         $project::FrameTubes(TopTube/DiameterHT)
            set TopTube(DiameterST)         $project::FrameTubes(TopTube/DiameterST)
            set TopTube(TaperLength)        $project::FrameTubes(TopTube/TaperLength)
            set TopTube(PivotPosition)      $project::Custom(TopTube/PivotPosition)
            set TopTube(OffsetHT)           $project::Custom(TopTube/OffsetHT)
            set TopTube(Angle)              $project::Custom(TopTube/Angle)

                #
                # --- get ChainStay ------------------------
            set ChainStay(HeigthBB)         $project::FrameTubes(ChainStay/HeightBB)
            set ChainStay(DiameterSS)       $project::FrameTubes(ChainStay/DiameterSS)
            set ChainStay(Height)           $project::FrameTubes(ChainStay/Height)
            set ChainStay(TaperLength)      $project::FrameTubes(ChainStay/TaperLength)
            set ChainStay(WidthBB)          $project::FrameTubes(ChainStay/WidthBB)
            
                #
                # --- get SeatStay -------------------------
            set SeatStay(DiameterST)        $project::FrameTubes(SeatStay/DiameterST)
            set SeatStay(DiameterCS)        $project::FrameTubes(SeatStay/DiameterCS)
            set SeatStay(TaperLength)       $project::FrameTubes(SeatStay/TaperLength)
            set SeatStay(OffsetTT)          $project::Custom(SeatStay/OffsetTT)

                #
                # --- get RearDropOut ----------------------
            set RearDrop(Direction)         $project::Lugs(RearDropOut/Direction)
            set RearDrop(RotationOffset)    $project::Lugs(RearDropOut/RotationOffset)
            set RearDrop(OffsetCS)          $project::Lugs(RearDropOut/ChainStay/Offset)
            set RearDrop(OffsetCSPerp)      $project::Lugs(RearDropOut/ChainStay/OffsetPerp)
            set RearDrop(OffsetSS)          $project::Lugs(RearDropOut/SeatStay/Offset)
            set RearDrop(OffsetSSPerp)      $project::Lugs(RearDropOut/SeatStay/OffsetPerp)
            set RearDrop(Derailleur_x)      $project::Lugs(RearDropOut/Derailleur/x)
            set RearDrop(Derailleur_y)      $project::Lugs(RearDropOut/Derailleur/y)
            set RearDrop(OffsetCS_TopView)  $project::Lugs(RearDropOut/ChainStay/Offset_TopView)

                #
                # --- get Saddle ---------------------------
            set Saddle(Distance)        $project::Personal(Saddle_Distance)
            set Saddle(Height)          $project::Personal(Saddle_Height)
            set Saddle(Saddle_Height)   $project::Component(Saddle/Height)
                # check-Value-procedure
                if {$Saddle(Saddle_Height) < 0} {
                       set project::Component(Saddle/Height) 0
                       set Saddle(Saddle_Height) 0
                }
            set Saddle(Position)        [ list [expr -1.0*$Saddle(Distance)]  $Saddle(Height) ]
            set Saddle(Nose)            [ vectormath::addVector  $Saddle(Position) [list [expr $project::Component(Saddle/LengthNose) + $project::Rendering(Saddle/Offset_X)] -15] ]

                #
                # --- get SaddleMount - Position
            set SeatPost(Diameter)      $project::Component(SeatPost/Diameter)
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
                # --- get LegClearance - Position
            set LegClearance(Length)        $project::Personal(InnerLeg_Length)
            set LegClearance(Position)      [ list $TopTube(PivotPosition)  [expr $LegClearance(Length) - ($RearWheel(Radius) - $project::Custom(BottomBracket/Depth)) ] ]

                #
                # --- get Saddle ---------------------------
            set Saddle(Proposal)            [ vectormath::rotateLine {0 0}  [ expr 0.88*$LegClearance(Length) ]  [ expr 180 - $SeatTube(Angle) ] ]

                #
                # --- get HeadSet --------------------------
            set HeadSet(Diameter)           $project::Component(HeadSet/Diameter)
            set HeadSet(Height_Top)         $project::Component(HeadSet/Height/Top)
            set HeadSet(Height_Bottom)      $project::Component(HeadSet/Height/Bottom)
            set HeadSet(ShimDiameter)       36

                #
                # --- get Front/Rear Brake PadLever --------------
            set RearBrake(LeverLength)      $project::Component(Brake/Rear/LeverLength)
            set RearBrake(Offset)           $project::Component(Brake/Rear/Offset)
            set FrontBrake(LeverLength)     $project::Component(Brake/Front/LeverLength)
            set FrontBrake(Offset)          $project::Component(Brake/Front/Offset)

                #
                # --- get BottleCage Offset ----------------------
            set BottleCage(SeatTube)        $project::Component(BottleCage/SeatTube/OffsetBB)
            set BottleCage(DownTube)        $project::Component(BottleCage/DownTube/OffsetBB)
            set BottleCage(DownTube_Lower)  $project::Component(BottleCage/DownTube_Lower/OffsetBB)

                #
                # --- get FrontDerailleur  ----------------------
            set FrontDerailleur(Distance)   $project::Component(Derailleur/Front/Distance)
            set FrontDerailleur(Offset)     $project::Component(Derailleur/Front/Offset)


                #
                # --- set DEBUG_Geometry  ----------------------
            set DEBUG_Geometry(Base)        {0 0}


                #
                #
                # --- set basePoints Attributes
                #
            project::setValue Result(Position/RearWheel)            position    $RearWheel(Position)
            project::setValue Result(Position/HandleBar)            position    $HandleBar(Position)
            project::setValue Result(Position/SeatPostSaddle)       position    $SeatPost(Saddle)
            project::setValue Result(Position/SeatPostSeatTube)     position    $SeatPost(SeatTube)
            project::setValue Result(Position/SeatPostPivot)        position    $SeatPost(PivotPosition)
            project::setValue Result(Position/Saddle)               position    $Saddle(Position)
            project::setValue Result(Position/SaddleProposal)       position    $Saddle(Proposal)
            project::setValue Result(Position/SaddleNose)           position    $Saddle(Nose)
            project::setValue Result(Position/LegClearance)         position    $TopTube(PivotPosition)     [expr $LegClearance(Length) - ($RearWheel(Radius) - $project::Custom(BottomBracket/Depth)) ]
            project::setValue Result(Position/BottomBracketGround)  position    0     [expr - $RearWheel(Radius) + $project::Custom(BottomBracket/Depth) ] ;# Point on the Ground perp. to BB
            project::setValue Result(Position/SeatTubeSaddle)       position    [ vectormath::intersectPoint [list 0 [lindex $Saddle(Position) 1] ] [list 100 [lindex $Saddle(Position) 1]] $SeatTube(BottomBracket) $SeatPost(SeatTube) ]

            project::setValue Result(Lugs/Dropout/Rear/Position)    position     [expr -1*$RearWheel(Distance_X)]    $project::Custom(BottomBracket/Depth)
               
                # project::setValue Result(Lugs/Dropout/Rear/Derailleur)        position     [ vectormath::addVector  $RearWheel(Position)  [list $RearDrop(Derailleur_x) $RearDrop(Derailleur_y)] ]
                # project::setValue /root/Result/Lugs/Dropout/Front/Position    position     $FrontWheel(Distance_X)    [expr $project::Custom(BottomBracket/Depth) + ($FrontWheel(Radius) - $RearWheel(Radius))]
                # project::setValue /root/Result/Position/RearWheel             position    $RearWheel(Position)
                # project::setValue /root/Result/Position/FrontWheel            position    $FrontWheel(Position)



                #
                #
                # --- set basePoints Attributes
                #
            get_basePoints
            project::setValue Result(Position/FrontWheel)            position    $FrontWheel(Position)
            project::setValue Result(Lugs/Dropout/Front/Position)    position    $FrontWheel(Distance_X)    [expr $project::Custom(BottomBracket/Depth) + ($FrontWheel(Radius) - $RearWheel(Radius))]


            #
            # --- compute tubing geometry
            #

                #
            get_ChainStay

                #
            get_HeadTube

                #
            get_TopTube_SeatTube

                #
            get_DownTube_SeatTube

                #
            get_SeatStay

                #
            get_Fork

                #
            get_Steerer

                #
            get_SeatPost

                #
            get_HeadSet

                #
            get_Stem
            
                #
            fill_resultValues
            
                #
            get_DerailleurMountFront

                #
            get_BrakePositionRear

                #
            get_BrakePositionFront

                #
            get_BottleCageMount

                #
            get_FrameJig

                #
            get_TubeMiter
            
            
            # ----------------------------------
                # finally update projectDOM
            return [project::runTime_2_dom]
            # $projectDOM
     
            
    }


 