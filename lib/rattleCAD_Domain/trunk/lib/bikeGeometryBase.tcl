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
            set Project(Project)        $rc_Domain::project::Project(Name)
            set Project(modified)       $rc_Domain::project::Project(modified)

                #
                # --- get BottomBracket (1)
            set BottomBracket(depth)    $rc_Domain::project::Custom(BottomBracket/Depth)
            set BottomBracket(outside)  $rc_Domain::project::Lugs(BottomBracket/Diameter/outside)
            set BottomBracket(inside)   $rc_Domain::project::Lugs(BottomBracket/Diameter/inside)
            set BottomBracket(width)    $rc_Domain::project::Lugs(BottomBracket/Width)
                # check-Value-procedure
                if {[expr $BottomBracket(outside) -2.0] < $BottomBracket(inside)} {
                        set rc_Domain::project::Lugs(BottomBracket/Diameter/inside) [expr $BottomBracket(outside) -2.0]
                        set BottomBracket(inside)   $rc_Domain::project::Lugs(BottomBracket/Diameter/inside)
                }

                #
                # --- get RearWheel
            set RearWheel(RimDiameter)  $rc_Domain::project::Component(Wheel/Rear/RimDiameter)
            set RearWheel(RimHeight)    $rc_Domain::project::Component(Wheel/Rear/RimHeight)
            set RearWheel(TyreHeight)   $rc_Domain::project::Component(Wheel/Rear/TyreHeight)
            set RearWheel(Radius)       [ expr 0.5*$RearWheel(RimDiameter) + $RearWheel(TyreHeight) ]
            set RearWheel(DistanceBB)   $rc_Domain::project::Custom(WheelPosition/Rear)
            #set RearWheel(Distance_X)  [ expr sqrt(pow($RearWheel(DistanceBB),2)  - pow($rc_Domain::project::Custom(BottomBracket/Depth),2)) ]
            set RearWheel(Distance_X)   [ expr sqrt(pow($RearWheel(DistanceBB),2)  - pow($rc_Domain::project::Custom(BottomBracket/Depth),2)) ]
            set RearWheel(Position)     [ list [expr -1.0 * $RearWheel(Distance_X)] $rc_Domain::project::Custom(BottomBracket/Depth) ]
                # set RearWheel(Distance_X) 450

                #
                # --- get BottomBracket (2)
            set BottomBracket(height)    [ expr $RearWheel(Radius) - $rc_Domain::project::Custom(BottomBracket/Depth) ]
            set BottomBracket(Ground)    [ list 0    [expr - $RearWheel(Radius) + $rc_Domain::project::Custom(BottomBracket/Depth) ] ]

                #
                # --- get FrontWheel
            set FrontWheel(RimDiameter) $rc_Domain::project::Component(Wheel/Front/RimDiameter)
            set FrontWheel(RimHeight)   $rc_Domain::project::Component(Wheel/Front/RimHeight)
            set FrontWheel(TyreHeight)  $rc_Domain::project::Component(Wheel/Front/TyreHeight)
            set FrontWheel(Radius)      [ expr 0.5*$FrontWheel(RimDiameter) + $FrontWheel(TyreHeight) ]
            set FrontWheel(Distance_Y)  [ expr $rc_Domain::project::Custom(BottomBracket/Depth) - $RearWheel(Radius) + $FrontWheel(Radius) ]

                #
                # --- get HandleBarMount - Position
            set HandleBar(Distance)     $rc_Domain::project::Personal(HandleBar_Distance)
            set HandleBar(Height)       $rc_Domain::project::Personal(HandleBar_Height)
            set HandleBar(Position)     [ list $HandleBar(Distance) $HandleBar(Height) ]


                #
                # --- get Fork -----------------------------
            set Fork(Height)                $rc_Domain::project::Component(Fork/Height)
            set Fork(Rake)                  $rc_Domain::project::Component(Fork/Rake)
            set Fork(BladeWith)             $rc_Domain::project::Component(Fork/Blade/Width)
            set Fork(BladeDiameterDO)       $rc_Domain::project::Component(Fork/Blade/DiameterDO)
            set Fork(BladeTaperLength)      $rc_Domain::project::Component(Fork/Blade/TaperLength)
            set Fork(BladeBendRadius)       $rc_Domain::project::Component(Fork/Blade/BendRadius)
            set Fork(BladeEndLength)        $rc_Domain::project::Component(Fork/Blade/EndLength)
            set Fork(BladeOffsetCrown)      $rc_Domain::project::Component(Fork/Crown/Blade/Offset)
            set Fork(BladeOffsetCrownPerp)  $rc_Domain::project::Component(Fork/Crown/Blade/OffsetPerp)
            set Fork(BladeOffsetDO)         $rc_Domain::project::Component(Fork/DropOut/Offset)
            set Fork(BladeOffsetDOPerp)     $rc_Domain::project::Component(Fork/DropOut/OffsetPerp)
            set Fork(BrakeAngle)            $rc_Domain::project::Component(Fork/Crown/Brake/Angle)
            set Fork(BrakeOffset)           $rc_Domain::project::Component(Fork/Crown/Brake/Offset)

                #
                # --- get Stem -----------------------------
            set Stem(Angle)                 $rc_Domain::project::Component(Stem/Angle)
            set Stem(Length)                $rc_Domain::project::Component(Stem/Length)

                #
                # --- get HeadTube -------------------------
            set HeadTube(ForkRake)          $Fork(Rake)
            set HeadTube(ForkHeight)        $Fork(Height)
            set HeadTube(Diameter)          $rc_Domain::project::FrameTubes(HeadTube/Diameter)
            set HeadTube(Length)            $rc_Domain::project::FrameTubes(HeadTube/Length)
            set HeadTube(Angle)             $rc_Domain::project::Custom(HeadTube/Angle)

                #
                # --- get SeatTube -------------------------
            set SeatTube(DiameterBB)        $rc_Domain::project::FrameTubes(SeatTube/DiameterBB)
            set SeatTube(DiameterTT)        $rc_Domain::project::FrameTubes(SeatTube/DiameterTT)
            set SeatTube(TaperLength)       $rc_Domain::project::FrameTubes(SeatTube/TaperLength)
            set SeatTube(Extension)         $rc_Domain::project::Custom(SeatTube/Extension)
            set SeatTube(OffsetBB)          $rc_Domain::project::Custom(SeatTube/OffsetBB)

                #
                # --- get DownTube -------------------------
            set DownTube(DiameterBB)        $rc_Domain::project::FrameTubes(DownTube/DiameterBB)
            set DownTube(DiameterHT)        $rc_Domain::project::FrameTubes(DownTube/DiameterHT)
            set DownTube(TaperLength)       $rc_Domain::project::FrameTubes(DownTube/TaperLength)
            set DownTube(OffsetHT)          $rc_Domain::project::Custom(DownTube/OffsetHT)
            set DownTube(OffsetBB)          $rc_Domain::project::Custom(DownTube/OffsetBB)

                #
                # --- get TopTube --------------------------
            set TopTube(DiameterHT)         $rc_Domain::project::FrameTubes(TopTube/DiameterHT)
            set TopTube(DiameterST)         $rc_Domain::project::FrameTubes(TopTube/DiameterST)
            set TopTube(TaperLength)        $rc_Domain::project::FrameTubes(TopTube/TaperLength)
            set TopTube(PivotPosition)      $rc_Domain::project::Custom(TopTube/PivotPosition)
            set TopTube(OffsetHT)           $rc_Domain::project::Custom(TopTube/OffsetHT)
            set TopTube(Angle)              $rc_Domain::project::Custom(TopTube/Angle)

                #
                # --- get ChainStay ------------------------
            set ChainStay(HeigthBB)         $rc_Domain::project::FrameTubes(ChainStay/HeightBB)
            set ChainStay(DiameterSS)       $rc_Domain::project::FrameTubes(ChainStay/DiameterSS)
            set ChainStay(Height)           $rc_Domain::project::FrameTubes(ChainStay/Height)
            set ChainStay(TaperLength)      $rc_Domain::project::FrameTubes(ChainStay/TaperLength)

                #
                # --- get SeatStay -------------------------
            set SeatStay(DiameterST)        $rc_Domain::project::FrameTubes(SeatStay/DiameterST)
            set SeatStay(DiameterCS)        $rc_Domain::project::FrameTubes(SeatStay/DiameterCS)
            set SeatStay(TaperLength)       $rc_Domain::project::FrameTubes(SeatStay/TaperLength)
            set SeatStay(OffsetTT)          $rc_Domain::project::Custom(SeatStay/OffsetTT)

                #
                # --- get RearDropOut ----------------------
            set RearDrop(Direction)         $rc_Domain::project::Lugs(RearDropOut/Direction)
            set RearDrop(RotationOffset)    $rc_Domain::project::Lugs(RearDropOut/RotationOffset)
            set RearDrop(OffsetCS)          $rc_Domain::project::Lugs(RearDropOut/ChainStay/Offset)
            set RearDrop(OffsetCSPerp)      $rc_Domain::project::Lugs(RearDropOut/ChainStay/OffsetPerp)
            set RearDrop(OffsetSS)          $rc_Domain::project::Lugs(RearDropOut/SeatStay/Offset)
            set RearDrop(OffsetSSPerp)      $rc_Domain::project::Lugs(RearDropOut/SeatStay/OffsetPerp)
            set RearDrop(Derailleur_x)      $rc_Domain::project::Lugs(RearDropOut/Derailleur/x)
            set RearDrop(Derailleur_y)      $rc_Domain::project::Lugs(RearDropOut/Derailleur/y)

                #
                # --- get Saddle ---------------------------
            set Saddle(Distance)        $rc_Domain::project::Personal(Saddle_Distance)
            set Saddle(Height)          $rc_Domain::project::Personal(Saddle_Height)
            set Saddle(Saddle_Height)   $rc_Domain::project::Component(Saddle/Height)
                # check-Value-procedure
                if {$Saddle(Saddle_Height) < 0} {
                       set rc_Domain::project::Component(Saddle/Height) 0
                       set Saddle(Saddle_Height) 0
                }
            set Saddle(Position)        [ list [expr -1.0*$Saddle(Distance)]  $Saddle(Height) ]
            set Saddle(Nose)            [ rc_Domain::vectormath::addVector  $Saddle(Position) [list $rc_Domain::project::Component(Saddle/LengthNose) -15] ]

                #
                # --- get SaddleMount - Position
            set SeatPost(Diameter)      $rc_Domain::project::Component(SeatPost/Diameter)
            set SeatPost(Setback)       $rc_Domain::project::Component(SeatPost/Setback)
            set SeatPost(Height)        [ expr $Saddle(Height) - $Saddle(Saddle_Height) ]
            set SeatPost(Saddle)        [ list [expr -1.0 * $Saddle(Distance)] $SeatPost(Height) ]
                set hlp_01              [ rc_Domain::vectormath:::cathetusPoint {0 0} $SeatPost(Saddle) [expr $SeatPost(Setback) - $SeatTube(OffsetBB)] {opposite}]
                set vct_01              [ rc_Domain::vectormath:::parallel {0 0} $hlp_01 $SeatTube(OffsetBB)]
            set SeatPost(SeatTube)      [ lindex $vct_01 1]
            set SeatTube(BottomBracket) [ lindex $vct_01 0]
            set SeatTube(Angle)         [ rc_Domain::vectormath::angle $SeatPost(SeatTube) $SeatTube(BottomBracket) [list -100 [lindex $SeatTube(BottomBracket) 1]]]
            set SeatTube(Direction)     [ rc_Domain::vectormath::unifyVector $SeatTube(BottomBracket) $SeatPost(SeatTube) ]

                #
                # --- get LegClearance - Position
            set LegClearance(Length)        $rc_Domain::project::Personal(InnerLeg_Length)
            set LegClearance(Position)      [ list $TopTube(PivotPosition)  [expr $LegClearance(Length) - ($RearWheel(Radius) - $rc_Domain::project::Custom(BottomBracket/Depth)) ] ]

                #
                # --- get Saddle ---------------------------
            set Saddle(Proposal)            [ rc_Domain::vectormath::rotateLine {0 0}  [ expr 0.88*$LegClearance(Length) ]  [ expr 180 - $SeatTube(Angle) ] ]

                #
                # --- get HeadSet --------------------------
            set HeadSet(Diameter)           $rc_Domain::project::Component(HeadSet/Diameter)
            set HeadSet(Height_Top)         $rc_Domain::project::Component(HeadSet/Height/Top)
            set HeadSet(Height_Bottom)      $rc_Domain::project::Component(HeadSet/Height/Bottom)
            set HeadSet(ShimDiameter)       36

                #
                # --- get Front/Rear Brake PadLever --------------
            set RearBrake(LeverLength)      $rc_Domain::project::Component(Brake/Rear/LeverLength)
            set RearBrake(Offset)           $rc_Domain::project::Component(Brake/Rear/Offset)
            set FrontBrake(LeverLength)     $rc_Domain::project::Component(Brake/Front/LeverLength)
            set FrontBrake(Offset)          $rc_Domain::project::Component(Brake/Front/Offset)

                #
                # --- get BottleCage Offset ----------------------
            set BottleCage(SeatTube)        $rc_Domain::project::Component(BottleCage/SeatTube/OffsetBB)
            set BottleCage(DownTube)        $rc_Domain::project::Component(BottleCage/DownTube/OffsetBB)
            set BottleCage(DownTube_Lower)  $rc_Domain::project::Component(BottleCage/DownTube_Lower/OffsetBB)

                #
                # --- get FrontDerailleur  ----------------------
            set FrontDerailleur(Distance)   $rc_Domain::project::Component(Derailleur/Front/Distance)
            set FrontDerailleur(Offset)     $rc_Domain::project::Component(Derailleur/Front/Offset)


                #
                # --- set DEBUG_Geometry  ----------------------
            set DEBUG_Geometry(Base)        {0 0}


                #
                #
                # --- set basePoints Attributes
                #
            rc_Domain::project::setValue Result(Position/RearWheel)            position    $RearWheel(Position)
            rc_Domain::project::setValue Result(Position/HandleBar)            position    $HandleBar(Position)
            rc_Domain::project::setValue Result(Position/SeatPostSaddle)       position    $SeatPost(Saddle)
            rc_Domain::project::setValue Result(Position/SeatPostSeatTube)     position    $SeatPost(SeatTube)
            rc_Domain::project::setValue Result(Position/Saddle)               position    $Saddle(Position)
            rc_Domain::project::setValue Result(Position/SaddleProposal)       position    $Saddle(Proposal)
            rc_Domain::project::setValue Result(Position/SaddleNose)           position    $Saddle(Nose)
            rc_Domain::project::setValue Result(Position/LegClearance)         position    $TopTube(PivotPosition)     [expr $LegClearance(Length) - ($RearWheel(Radius) - $rc_Domain::project::Custom(BottomBracket/Depth)) ]
            rc_Domain::project::setValue Result(Position/BottomBracketGround)  position    0     [expr - $RearWheel(Radius) + $rc_Domain::project::Custom(BottomBracket/Depth) ] ;# Point on the Ground perp. to BB
            rc_Domain::project::setValue Result(Position/SeatTubeSaddle)       position    [ rc_Domain::vectormath::intersectPoint [list 0 [lindex $Saddle(Position) 1] ] [list 100 [lindex $Saddle(Position) 1]] $SeatTube(BottomBracket) $SeatPost(SeatTube) ]

            rc_Domain::project::setValue Result(Lugs/Dropout/Rear/Position)    position     [expr -1*$RearWheel(Distance_X)]    $rc_Domain::project::Custom(BottomBracket/Depth)
                # rc_Domain::project::setValue Result(Lugs/Dropout/Rear/Derailleur)  position     [ rc_Domain::vectormath::addVector  $RearWheel(Position)  [list $RearDrop(Derailleur_x) $RearDrop(Derailleur_y)] ]

                # rc_Domain::project::setValue /root/Result/Lugs/Dropout/Front/Position    position     $FrontWheel(Distance_X)    [expr $rc_Domain::project::Custom(BottomBracket/Depth) + ($FrontWheel(Radius) - $RearWheel(Radius))]
                # rc_Domain::project::setValue /root/Result/Position/RearWheel         position    $RearWheel(Position)
                # rc_Domain::project::setValue /root/Result/Position/FrontWheel    position    $FrontWheel(Position)



                #
                #
                # --- set basePoints Attributes
                #
            get_basePoints
            rc_Domain::project::setValue Result(Position/FrontWheel)            position    $FrontWheel(Position)
            rc_Domain::project::setValue Result(Lugs/Dropout/Front/Position)    position    $FrontWheel(Distance_X)    [expr $rc_Domain::project::Custom(BottomBracket/Depth) + ($FrontWheel(Radius) - $RearWheel(Radius))]


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
            return [rc_Domain::project::runTime_2_dom]
            # $projectDOM
     
            
    }


 