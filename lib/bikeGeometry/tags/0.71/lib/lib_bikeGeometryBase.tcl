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
            variable Geometry
            variable Reference
            variable Rendering
            
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
            variable RearFender
            variable FrontFender
            variable RearCarrier
            variable FrontCarrier

            variable BottleCage
            variable FrameJig
            variable TubeMiter

            variable DEBUG_Geometry

              # appUtil::get_procHierarchy
              
            set DEBUG_Geometry(Base)        {0 0}


            get_from_project
                #
                #
                # --- set basePoints Attributes
                #
                # get_basePoints ... replaced ... 0.69 ... 2014.10.20
                #
            get_RearWheel
            get_FrontWheel
                #
            get_GeometryRear
            get_GeometryCenter
            get_GeometryFront
            get_BoundingBox
                #
            
                #
                # --- compute tubing geometry
                #
            check_Values
            
                #
            get_ChainStay
            get_ChainStay_RearMockup

                #
            get_HeadTube

                #
            get_DownTube_SeatTube
            
                #
            get_TopTube_SeatTube

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
                # --- compute components
                #
            get_DerailleurMountFront
            
                #
            get_CarrierMountRear

                #
            get_CarrierMountFront

                #
            get_BrakePositionRear

                #
            get_BrakePositionFront

                #
            get_BottleCageMount

                #
            get_FenderRear

                #
            get_FenderFront
            
                #
            get_FrameJig

                #
            get_TubeMiter
            
            
            # ----------------------------------
                # finally update projectDOM
            set_to_project
                #
			project::runTime_2_dom
            
    }


    proc bikeGeometry::get_from_project {} {
            
            variable Project
            variable Geometry
            variable Reference
            variable Rendering

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
            variable RearFender
            variable FrontFender
            variable RearCarrier
            variable FrontCarrier

            variable BottleCage
            variable FrameJig
            variable TubeMiter

              # appUtil::get_procHierarchy


                #
                # --- get BottomBracket (1)
            set BottomBracket(depth)            $project::Custom(BottomBracket/Depth)
            set BottomBracket(outside)          $project::Lugs(BottomBracket/Diameter/outside)
            set BottomBracket(inside)           $project::Lugs(BottomBracket/Diameter/inside)
            set BottomBracket(width)            $project::Lugs(BottomBracket/Width)
            set BottomBracket(OffsetCS_TopView) $project::Lugs(BottomBracket/ChainStay/Offset_TopView)
                # check-Value-procedure
            if {[expr $BottomBracket(outside) -2.0] < $BottomBracket(inside)} {
                set BottomBracket(inside)       [expr $BottomBracket(outside) -2.0]
                set project::Lugs(BottomBracket/Diameter/inside) $BottomBracket(inside)
            }

                #
                # --- get RearWheel
            set RearWheel(RimDiameter)          $project::Component(Wheel/Rear/RimDiameter)
            set RearWheel(RimHeight)            $project::Component(Wheel/Rear/RimHeight)
            set RearWheel(TyreHeight)           $project::Component(Wheel/Rear/TyreHeight)
            set RearWheel(TyreWidthRadius)      $project::Component(Wheel/Rear/TyreWidthRadius)
            set RearWheel(DistanceBB)           $project::Custom(WheelPosition/Rear)
            set RearWheel(HubWidth)             $project::Component(Wheel/Rear/HubWidth)
            

                #
                # --- get FrontWheel
            set FrontWheel(RimDiameter)         $project::Component(Wheel/Front/RimDiameter)
            set FrontWheel(RimHeight)           $project::Component(Wheel/Front/RimHeight)
            set FrontWheel(TyreHeight)          $project::Component(Wheel/Front/TyreHeight)

                #
                # --- get HandleBarMount - Position
            set HandleBar(Distance)             $project::Personal(HandleBar_Distance)
            set HandleBar(Height)               $project::Personal(HandleBar_Height)


                #
                # --- get Fork -----------------------------
            set Fork(Height)                    $project::Component(Fork/Height)
            set Fork(Rake)                      $project::Component(Fork/Rake)
            set Fork(Rendering)                 $project::Rendering(Fork)
            set Fork(BladeRendering)            $project::Rendering(ForkBlade)
            set Fork(BladeWith)                 $project::Component(Fork/Blade/Width)
            set Fork(BladeDiameterDO)           $project::Component(Fork/Blade/DiameterDO)
            set Fork(BladeTaperLength)          $project::Component(Fork/Blade/TaperLength)
            set Fork(BladeBendRadius)           $project::Component(Fork/Blade/BendRadius)
            set Fork(BladeEndLength)            $project::Component(Fork/Blade/EndLength)
            set Fork(BladeOffsetCrown)          $project::Component(Fork/Crown/Blade/Offset)
            set Fork(BladeOffsetCrownPerp)      $project::Component(Fork/Crown/Blade/OffsetPerp)
            set Fork(BrakeAngle)                $project::Component(Fork/Crown/Brake/Angle)
            set Fork(BrakeOffset)               $project::Component(Fork/Crown/Brake/Offset)
            set Fork(CrownFile)                 $project::Component(Fork/Crown/File)                                     
            set Fork(CrownBrakeOffset)          $project::Component(Fork/Crown/Brake/Offset) 
            set Fork(CrownBrakeAngle)           $project::Component(Fork/Crown/Brake/Angle)
            set Fork(BladeOffsetDO)             $project::Component(Fork/DropOut/Offset)
            set Fork(BladeOffsetDOPerp)         $project::Component(Fork/DropOut/OffsetPerp)
            set Fork(DropOutFile)               $project::Component(Fork/DropOut/File)
                        
                #
                # --- get Stem -----------------------------
            set Stem(Angle)                     $project::Component(Stem/Angle)
            set Stem(Length)                    $project::Component(Stem/Length)

                #
                # --- get HeadTube -------------------------
            set HeadTube(ForkRake)              $Fork(Rake)
            set HeadTube(ForkHeight)            $Fork(Height)
            set HeadTube(ForkRake)              $project::Component(Fork/Rake)
            set HeadTube(ForkHeight)            $project::Component(Fork/Height)
            set HeadTube(Diameter)              $project::FrameTubes(HeadTube/Diameter)
            set HeadTube(Length)                $project::FrameTubes(HeadTube/Length)
            set HeadTube(Angle)                 $project::Custom(HeadTube/Angle)

                #
                # --- get SeatTube -------------------------
            set SeatTube(DiameterBB)            $project::FrameTubes(SeatTube/DiameterBB)
            set SeatTube(DiameterTT)            $project::FrameTubes(SeatTube/DiameterTT)
            set SeatTube(TaperLength)           $project::FrameTubes(SeatTube/TaperLength)
            set SeatTube(Extension)             $project::Custom(SeatTube/Extension)
            set SeatTube(OffsetBB)              $project::Custom(SeatTube/OffsetBB)

                #
                # --- get DownTube -------------------------
            set DownTube(DiameterBB)            $project::FrameTubes(DownTube/DiameterBB)
            set DownTube(DiameterHT)            $project::FrameTubes(DownTube/DiameterHT)
            set DownTube(TaperLength)           $project::FrameTubes(DownTube/TaperLength)
            set DownTube(OffsetHT)              $project::Custom(DownTube/OffsetHT)
            set DownTube(OffsetBB)              $project::Custom(DownTube/OffsetBB)

                #
                # --- get TopTube --------------------------
            set TopTube(DiameterHT)             $project::FrameTubes(TopTube/DiameterHT)
            set TopTube(DiameterST)             $project::FrameTubes(TopTube/DiameterST)
            set TopTube(TaperLength)            $project::FrameTubes(TopTube/TaperLength)
            set TopTube(PivotPosition)          $project::Custom(TopTube/PivotPosition)
            set TopTube(OffsetHT)               $project::Custom(TopTube/OffsetHT)
            set TopTube(Angle)                  $project::Custom(TopTube/Angle)

                #
                # --- get ChainStay ------------------------
            set ChainStay(HeigthBB)             $project::FrameTubes(ChainStay/HeightBB)
            set ChainStay(DiameterSS)           $project::FrameTubes(ChainStay/DiameterSS)
            set ChainStay(Height)               $project::FrameTubes(ChainStay/Height)
            set ChainStay(TaperLength)          $project::FrameTubes(ChainStay/TaperLength)
            set ChainStay(WidthBB)              $project::FrameTubes(ChainStay/WidthBB)
            set ChainStay(Rendering)            $project::Rendering(ChainStay)
            set ChainStay(profile_y00)          $project::FrameTubes(ChainStay/Profile/width_00)
            set ChainStay(profile_x01)          $project::FrameTubes(ChainStay/Profile/length_01)
            set ChainStay(profile_y01)          $project::FrameTubes(ChainStay/Profile/width_01)
            set ChainStay(profile_x02)          $project::FrameTubes(ChainStay/Profile/length_02)
            set ChainStay(profile_y02)          $project::FrameTubes(ChainStay/Profile/width_02)
            set ChainStay(profile_x03)          $project::FrameTubes(ChainStay/Profile/length_03)
            set ChainStay(profile_y03)          $project::FrameTubes(ChainStay/Profile/width_03)
            set ChainStay(completeLength)       $project::FrameTubes(ChainStay/Profile/completeLength) 
            set ChainStay(cuttingLength)        $project::FrameTubes(ChainStay/Profile/cuttingLength)            
            set ChainStay(segmentLength_01)     $project::FrameTubes(ChainStay/CenterLine/length_01)      
            set ChainStay(segmentLength_02)     $project::FrameTubes(ChainStay/CenterLine/length_02)      
            set ChainStay(segmentLength_03)     $project::FrameTubes(ChainStay/CenterLine/length_03)      
            set ChainStay(segmentLength_04)     $project::FrameTubes(ChainStay/CenterLine/length_04)  
                          
                          
            set ChainStay(segmentAngle_01)      $project::FrameTubes(ChainStay/CenterLine/angle_01)
            set ChainStay(segmentAngle_02)      $project::FrameTubes(ChainStay/CenterLine/angle_02)
            set ChainStay(segmentAngle_03)      $project::FrameTubes(ChainStay/CenterLine/angle_03)
            set ChainStay(segmentAngle_04)      $project::FrameTubes(ChainStay/CenterLine/angle_04)
            set ChainStay(segmentRadius_01)     $project::FrameTubes(ChainStay/CenterLine/radius_01)
            set ChainStay(segmentRadius_02)     $project::FrameTubes(ChainStay/CenterLine/radius_02)
            set ChainStay(segmentRadius_03)     $project::FrameTubes(ChainStay/CenterLine/radius_03)
            set ChainStay(segmentRadius_04)     $project::FrameTubes(ChainStay/CenterLine/radius_04)
            
                #
                # --- get SeatStay -------------------------
            set SeatStay(DiameterST)            $project::FrameTubes(SeatStay/DiameterST)
            set SeatStay(DiameterCS)            $project::FrameTubes(SeatStay/DiameterCS)
            set SeatStay(TaperLength)           $project::FrameTubes(SeatStay/TaperLength)
            set SeatStay(OffsetTT)              $project::Custom(SeatStay/OffsetTT)

                #
                # --- get RearDropOut ----------------------
            set RearDrop(Direction)             $project::Lugs(RearDropOut/Direction)
            set RearDrop(RotationOffset)        $project::Lugs(RearDropOut/RotationOffset)
            set RearDrop(OffsetCS)              $project::Lugs(RearDropOut/ChainStay/Offset)
            set RearDrop(OffsetCSPerp)          $project::Lugs(RearDropOut/ChainStay/OffsetPerp)
            set RearDrop(OffsetSS)              $project::Lugs(RearDropOut/SeatStay/Offset)
            set RearDrop(OffsetSSPerp)          $project::Lugs(RearDropOut/SeatStay/OffsetPerp)
            set RearDrop(Derailleur_x)          $project::Lugs(RearDropOut/Derailleur/x)
            set RearDrop(Derailleur_y)          $project::Lugs(RearDropOut/Derailleur/y)
            set RearDrop(OffsetCS_TopView)      $project::Lugs(RearDropOut/ChainStay/Offset_TopView)

                #
                # --- get Saddle ---------------------------
            set Saddle(Distance)                $project::Personal(Saddle_Distance)
            set Saddle(Height)                  $project::Personal(Saddle_Height)
            set Saddle(Saddle_Height)           $project::Component(Saddle/Height)
            # 2014 10 27 - H -
            set Saddle(Nose_Length)             $project::Component(Saddle/LengthNose)
                # check-Value-procedure
            if {$Saddle(Saddle_Height) < 0} {
                set Saddle(Saddle_Height) 0
                set project::Component(Saddle/Height) $Saddle(Saddle_Height)
            }
            set Saddle(Position)                [ list [expr -1.0*$Saddle(Distance)]  $Saddle(Height) ]
                # 2014 10 27 - H - 
                # set Saddle(Nose)              [ vectormath::addVector  $Saddle(Position) [list [expr $project::Component(Saddle/LengthNose) + $project::Rendering(Saddle/Offset_X)] -15] ]

                #
                # --- get SaddleMount - Position
            set SeatPost(Diameter)              $project::Component(SeatPost/Diameter)
            set SeatPost(Setback)               $project::Component(SeatPost/Setback)
            set SeatPost(PivotOffset)           $project::Component(SeatPost/PivotOffset)

                #
                # --- get LegClearance - Position
            set LegClearance(Length)            $project::Personal(InnerLeg_Length)

                #
                # --- get Saddle ---------------------------
 
                #
                # --- get HeadSet --------------------------
            set HeadSet(Diameter)               $project::Component(HeadSet/Diameter)
            set HeadSet(Height_Top)             $project::Component(HeadSet/Height/Top)
            set HeadSet(Height_Bottom)          $project::Component(HeadSet/Height/Bottom)
            set HeadSet(ShimDiameter)           36

                #
                # --- get Front/Rear Brake PadLever --------------
            set RearBrake(LeverLength)          $project::Component(Brake/Rear/LeverLength)
            set RearBrake(Offset)               $project::Component(Brake/Rear/Offset)
            set FrontBrake(LeverLength)         $project::Component(Brake/Front/LeverLength)
            set FrontBrake(Offset)              $project::Component(Brake/Front/Offset)

                #
                # --- get BottleCage Offset ----------------------
            set BottleCage(SeatTube)            $project::Component(BottleCage/SeatTube/OffsetBB)
            set BottleCage(DownTube)            $project::Component(BottleCage/DownTube/OffsetBB)
            set BottleCage(DownTube_Lower)      $project::Component(BottleCage/DownTube_Lower/OffsetBB)

                #
                # --- get FrontDerailleur  ----------------------
            set FrontDerailleur(Distance)       $project::Component(Derailleur/Front/Distance)
            set FrontDerailleur(Offset)         $project::Component(Derailleur/Front/Offset)

                #
                # --- get Fender  -------------------------------
            set RearFender(Radius)              $project::Component(Fender/Rear/Radius)
            set RearFender(OffsetAngle)         $project::Component(Fender/Rear/OffsetAngle)
            set RearFender(Height)              $project::Component(Fender/Rear/Height)
            set FrontFender(Radius)             $project::Component(Fender/Front/Radius)
            set FrontFender(OffsetAngleFront)   $project::Component(Fender/Front/OffsetAngleFront)
            set FrontFender(OffsetAngle)        $project::Component(Fender/Front/OffsetAngle)
            set FrontFender(Height)             $project::Component(Fender/Front/Height)
            
                #
                # --- get Carrier  ------------------------------
            set RearCarrier(x)                  $project::Component(Carrier/Rear/x)
            set RearCarrier(y)                  $project::Component(Carrier/Rear/y)
            set FrontCarrier(x)                 $project::Component(Carrier/Front/x)
            set FrontCarrier(y)                 $project::Component(Carrier/Front/y)
            
                #
            set Rendering(SaddleOffset_x)       $project::Rendering(Saddle/Offset_X)    
                
                #
            set Reference(SaddleNose_Distance)  $project::Reference(SaddleNose_Distance)
            set Reference(SaddleNose_Height)    $project::Reference(SaddleNose_Height)
            set Reference(HandleBar_Distance)   $project::Reference(HandleBar_Distance)
            set Reference(HandleBar_Height)     $project::Reference(HandleBar_Height)
            
                #
                # --- set DEBUG_Geometry  ----------------------
            set DEBUG_Geometry(Base)        {0 0}
               
    }


    proc bikeGeometry::set_to_project {} {
            
            variable Project
            variable Geometry 
            variable Rendering

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
            variable RearFender
            variable FrontFender
            variable RearCarrier
            variable FrontCarrier

            variable BottleCage
            variable FrameJig
            variable TubeMiter
    

    
                # -- get_ChainStay    
            #project::setValue Result(Tubes/ChainStay/Direction) direction   $pt_00
            #project::setValue Result(Lugs/Dropout/Rear/Derailleur)  position     [ vectormath::addVector  $RearWheel(Position)  $vct_mount ]
                            
                
                # -- get_GeometryFront
            project::setValue Result(Lugs/Dropout/Front/Position)   position    $Fork(Dropout)
            project::setValue Result(Lugs/ForkCrown/Position)       position    $Steerer(Fork)
            project::setValue Result(Position/FrontWheel)           position    $FrontWheel(Position)
            project::setValue Result(Position/HandleBar)            position    $HandleBar(Position)
            project::setValue Result(Position/SteererGround)        position    $Steerer(Ground)        ;# Point on the Ground in direction of Steerer
            project::setValue Result(Tubes/Steerer/Direction)       direction   $Steerer(Fork)      $Steerer(Stem)
            project::setValue Result(Tubes/Steerer/End)             position    $Steerer(Stem)
            project::setValue Result(Tubes/Steerer/Start)           position    $Steerer(Fork)
    
                # -- get_GeometryRear
            #project::setValue Result(Lugs/Dropout/Rear/Position)    position    [expr -1*$RearWheel(Distance_X)]    $project::Custom(BottomBracket/Depth)
            #project::setValue Result(Position/RearWheel)            position    $RearWheel(Position)    
    
    
    
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
            if {1 == 2} {
                      # 2014 10 27 - H -  
                      #
                      # -- Component(Fender/Rear/Radius) <-> $RearFender(Radius)
                      #       handle values like done in bikeGeometry::get_FenderRear 
                    if {$RearFender(Radius) < $RearWheel(Radius)} {
                        set project::Component(Fender/Rear/Radius) [expr $RearWheel(Radius) + 5.0]
                        set RearFender(Radius)                     $project::Component(Fender/Rear/Radius)
                        puts "\n                     -> <i> \$project::Component(Fender/Rear/Radius) ........... $project::Component(Fender/Rear/Radius)"
                    }

                      # 2014 10 27 - H -  
                      #
                      # -- Component(Fender/Front/Radius) <-> $RearFender(Radius)
                      #       handle values like done in bikeGeometry::get_FenderFront 
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
