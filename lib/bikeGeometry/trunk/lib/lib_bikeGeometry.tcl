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
    proc bikeGeometry::update_Geometry {} {
            
                #
                # ... new structure of bikeGeometry 1.20 ...
                #
                #
            variable Project
            variable Geometry
            variable Reference
            variable Config
            
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
            variable RearDropout

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
            variable RearMockup

            variable DEBUG_Geometry

              # appUtil::get_procHierarchy
              
            set DEBUG_Geometry(Base)        {0 0}
            set DEBUG_Geometry(Position)    {0 0}


                #
                # ... moved to bikeGeometry::set_newProject  ... 20141126
            # get_from_project   
                #
                
                #
            # namespace import [namespace current]::model_freeAngle::update_ModeGeometry                
                #
            # puts "   [namespace current]"
            
            foreach procedure [lsort [info procs [namespace current]::*]] {
               #  puts "   ... $procedure"
            }
            [namespace current]::model_freeAngle::update_ModelGeometry
                #
                
                
                #
                # --- set basePoints Attributes
                #
                # get_basePoints ... replaced ... 0.69 ... 2014.10.20
                #
            # create_GeometryRear
            # create_GeometryCenter
            # create_GeometryFront
                #
                # create_RearDropout
                # create_RearWheel
                # create_FrontWheel
                #
            create_SummarySize
                #
           
            trace_ForkConfig   
                
                #
                # --- compute tubing geometry
                #
            check_Values
            
                #
            create_ChainStay
            create_ChainStay_RearMockup

                #
            create_HeadTube

                #
            create_DownTube_SeatTube
            
                #
            create_TopTube_SeatTube

                #
            create_SeatStay

                #
            create_Fork

                #
            create_Steerer

                #
            create_SeatPost

                #
            create_HeadSet

                #
            create_Stem
            
                #
            fill_resultValues
            
                #
                # --- compute components
                #
            create_DerailleurMountFront
            
                #
            create_CarrierMountRear

                #
            create_CarrierMountFront

                #
            create_BrakePositionRear

                #
            create_BrakePositionFront

                #
            create_BottleCageMount

                #
            create_RearFender

                #
            create_FrontFender
            
                #
            create_FrameJig

                #
            create_TubeMiter
            
            
            # ----------------------------------
                # finally update projectDOM
                # removed 20150129 ... is allready part of  bikeGeometry::get_projectDOM
            # set_to_project
                #
			# project::runTime_2_dom
            
    }

    proc bikeGeometry::trace_ForkConfig {} {
            #
        variable customFork
            #
        variable Component
        variable Config
        variable Fork
            #
            # puts "   -> lastConfig ... $customFork(lastConfig)"
            # puts "                 ... $Config(Fork)"
            #
            # tk_messageBox -message "<01> ... switch from  $customFork(lastConfig) -> \n $Config(Fork)"
            #
            # set lastFile $Fork(CrownFile)
            #
        switch -exact $Config(Fork) {
            SteelLugged -
            SteelCustom {
                    if {$customFork(lastConfig) != $Config(Fork)} {               
                            # ... no SteelCustom, last time anything else
                            # ... therefore restore Fork() from customFork()
                            # ... initialy customFork() is empty
                        # tk_messageBox -message "<02> ... trace_ForkConfig -> SteelCustom ... changed"
                        # tk_messageBox -message "<02> ... switch from  $customFork(lastConfig) -> \n $Config(Fork)"
                            #
                            # -- check that  customFork()  has values 
                            #     ... if not fill customFork()  initially with current values
                        if {[array get customFork CrownFile] == {}} {
                            # tk_messageBox -message "<02> ... trace_ForkConfig -> SteelCustom ... virgin"
                            bikeGeometry::create_Fork_SteelCustom_Template
                        } 
                            #
                        set Fork(BladeBendRadius)       $customFork(BladeBendRadius)     
                        set Fork(BladeDiameterDO)       $customFork(BladeDiameterDO)     
                        set Fork(BladeEndLength)        $customFork(BladeEndLength)      
                        set Fork(BladeOffsetCrown)      $customFork(BladeOffsetCrown)    
                        set Fork(BladeOffsetCrownPerp)  $customFork(BladeOffsetCrownPerp)
                        set Fork(BladeOffsetDO)         $customFork(BladeOffsetDO)       
                        set Fork(BladeOffsetDOPerp)     $customFork(BladeOffsetDOPerp)   
                        set Fork(BladeTaperLength)      $customFork(BladeTaperLength)    
                        set Fork(BladeWidth)            $customFork(BladeWidth)          
                        set Fork(CrownAngleBrake)       $customFork(CrownAngleBrake)     
                        set Fork(CrownOffsetBrake)      $customFork(CrownOffsetBrake)    
                            #                        
                            # set FrontBrake(Offset)          $customFork(BladeBrakeOffset)
                        set Fork(BladeBrakeOffset)      $customFork(BladeBrakeOffset)                        
                            #
                        set Component(ForkCrown)        $customFork(CrownFile)                                      
                        set Component(ForkDropout)      $customFork(DropOutFile)         
     
                    } else {
                    
                    }
                }
            default {}
        }
            #
        set customFork(lastConfig) $Config(Fork)
            #
        # tk_messageBox -message "<03> ... switch from  $customFork(lastConfig) -> \n $Config(Fork)\n old: $lastFile \n new: $Fork(CrownFile)"   
            #
            #
        # parray customFork
        # parray Fork
            #
        return
            #
    }
    
    proc bikeGeometry::get_from_project {} {
            
            variable Project
            variable Geometry
            variable Reference
            variable Component
            variable Config
            variable ListValue
            variable Result

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
            variable Lugs

            variable Fork
            variable HeadSet
            variable Stem
            variable RearDropout

            variable CrankSet
            variable FrontBrake
            variable FrontCarrier
            variable FrontDerailleur
            variable FrontFender
            variable RearBrake
            variable RearCarrier
            variable RearDerailleur
            variable RearFender
            variable BottleCage
            variable Logo
            
            variable FrameJig
            variable TubeMiter
            variable RearMockup
            variable Visualisation

              # appUtil::get_procHierarchy 

                #
                # --- get Component   ----------------------
            set Component(BottleCage_DownTube)          $project::Component(BottleCage/DownTube/File)
            set Component(BottleCage_DownTube_Lower)    $project::Component(BottleCage/DownTube_Lower/File)
            set Component(BottleCage_SeatTube)          $project::Component(BottleCage/SeatTube/File)
            set Component(CrankSet)                     $project::Component(CrankSet/File)
            set Component(ForkCrown)                    $project::Component(Fork/Crown/File)                                     
            set Component(ForkDropout)                  $project::Component(Fork/DropOut/File)
            set Component(FrontBrake)                   $project::Component(Brake/Front/File)
            set Component(FrontCarrier)                 $project::Component(Carrier/Front/File)
            set Component(FrontDerailleur)              $project::Component(Derailleur/Front/File)
            set Component(HandleBar)                    $project::Component(HandleBar/File)
            set Component(Logo)                         $project::Component(Logo/File)                    
            set Component(RearBrake)                    $project::Component(Brake/Rear/File)
            set Component(RearCarrier)                  $project::Component(Carrier/Rear/File)
            set Component(RearDerailleur)               $project::Component(Derailleur/Rear/File)
            set Component(RearDropout)                  $project::Lugs(RearDropOut/File)
            set Component(RearHub)                      {hub/rattleCAD_rear.svg}
            set Component(Saddle)                       $project::Component(Saddle/File)                 
            
                #
                # --- get Rendering  -----------------------
            set Config(FrontBrake)                      $project::Rendering(Brake/Front)    
            set Config(RearBrake)                       $project::Rendering(Brake/Rear)    
            set Config(BottleCage_SeatTube)             $project::Rendering(BottleCage/SeatTube)
            set Config(BottleCage_DownTube)             $project::Rendering(BottleCage/DownTube)
            set Config(BottleCage_DownTube_Lower)       $project::Rendering(BottleCage/DownTube_Lower)    
            set Config(FrontFender)                     $project::Rendering(Fender/Front)
            set Config(RearFender)                      $project::Rendering(Fender/Rear)
            set Config(ChainStay)                       $project::Rendering(ChainStay)
            set Config(Fork)                            $project::Rendering(Fork)
            set Config(ForkBlade)                       $project::Rendering(ForkBlade)
            set Config(ForkDropout)                     $project::Rendering(ForkDropOut)
            set Config(RearDropout)                     $project::Rendering(RearDropOut)
            set Config(RearDropoutOrient)               $project::Lugs(RearDropOut/Direction) ; # prev. RearDropOut/Direction
 
                #
                # --- get ListValue  -----------------------
            set ListValue(CrankSetChainRings)           $project::Component(CrankSet/ChainRings)
            
                #
                # --- get Geometry  ------------------------
            set Geometry(BottomBracket_Depth)           $project::Custom(BottomBracket/Depth)
            set Geometry(ChainStay_Length)              $project::Custom(WheelPosition/Rear)
            set Geometry(Fork_Height)                   $project::Component(Fork/Height)
            set Geometry(Fork_Rake)                     $project::Component(Fork/Rake)
            set Geometry(FrontRim_Diameter)             $project::Component(Wheel/Front/RimDiameter)
            set Geometry(FrontTyre_Height)              $project::Component(Wheel/Front/TyreHeight)
            set Geometry(HandleBar_Distance)            $project::Personal(HandleBar_Distance)
            set Geometry(HandleBar_Height)              $project::Personal(HandleBar_Height)
            set Geometry(HeadTube_Angle)                $project::Custom(HeadTube/Angle)
            set Geometry(Inseam_Length)                 $project::Personal(InnerLeg_Length)
            set Geometry(RearRim_Diameter)              $project::Component(Wheel/Rear/RimDiameter)
            set Geometry(RearTyre_Height)               $project::Component(Wheel/Rear/TyreHeight)
            set Geometry(Saddle_Distance)               $project::Personal(Saddle_Distance)
            set Geometry(Saddle_Height)                 $project::Personal(Saddle_Height)
            set Geometry(Stem_Angle)                    $project::Component(Stem/Angle)
            set Geometry(Stem_Length)                   $project::Component(Stem/Length)
            set Geometry(TopTube_Angle)                 $project::Custom(TopTube/Angle)
            set Geometry(SeatTube_Virtual)              $project::Custom(SeatTube/LengthVirtual)
                    
                #       
                # --- get RearMockup  ----------------------
            set RearMockup(CassetteClearance)           $project::Rendering(RearMockup/CassetteClearance)
            set RearMockup(ChainWheelClearance)         $project::Rendering(RearMockup/ChainWheelClearance)
            set RearMockup(CrankClearance)              $project::Rendering(RearMockup/CrankClearance)
            set RearMockup(DiscClearance)               $project::Rendering(RearMockup/DiscClearance)
            set RearMockup(DiscDiameter)                $project::Rendering(RearMockup/DiscDiameter)
            set RearMockup(DiscOffset)                  $project::Rendering(RearMockup/DiscOffset)
            set RearMockup(DiscWidth)                   $project::Rendering(RearMockup/DiscWidth)
            set RearMockup(TyreClearance)               $project::Rendering(RearMockup/TyreClearance)
        
                #       
                # --- get Reference  -----------------------
            set Reference(SaddleNose_Distance)          $project::Reference(SaddleNose_Distance)
            set Reference(SaddleNose_Height)            $project::Reference(SaddleNose_Height)
            set Reference(HandleBar_Distance)           $project::Reference(HandleBar_Distance)
            set Reference(HandleBar_Height)             $project::Reference(HandleBar_Height)
                    
                    
                #       
                # --- get BottomBracket (1) ----------------
            set BottomBracket(OutsideDiameter)          $project::Lugs(BottomBracket/Diameter/outside)
            set BottomBracket(InsideDiameter)           $project::Lugs(BottomBracket/Diameter/inside)
            set BottomBracket(Width)                    $project::Lugs(BottomBracket/Width)
            set BottomBracket(OffsetCS_TopView)         $project::Lugs(BottomBracket/ChainStay/Offset_TopView)

                #
                # --- get RearWheel ------------------------
            set RearWheel(RimHeight)                    $project::Component(Wheel/Rear/RimHeight)
            set RearWheel(TyreWidth)                    $project::Component(Wheel/Rear/TyreWidth)
            set RearWheel(TyreWidthRadius)              $project::Component(Wheel/Rear/TyreWidthRadius)
            set RearWheel(HubWidth)                     $project::Component(Wheel/Rear/HubWidth)
            set RearWheel(FirstSprocket)                $project::Component(Wheel/Rear/FirstSprocket)
                    
        
                #       
                # --- get FrontWheel -----------------------       
            set FrontWheel(RimHeight)                   $project::Component(Wheel/Front/RimHeight)
            
                #
                # --- get HandleBarMount - Position
            set HandleBar(PivotAngle)                   $project::Component(HandleBar/PivotAngle)
                    
                #       
                # --- get Fork -----------------------------
            set Fork(BladeWidth)                        $project::Component(Fork/Blade/Width)
            set Fork(BladeDiameterDO)                   $project::Component(Fork/Blade/DiameterDO)
            set Fork(BladeTaperLength)                  $project::Component(Fork/Blade/TaperLength)
            set Fork(BladeBendRadius)                   $project::Component(Fork/Blade/BendRadius)
            set Fork(BladeEndLength)                    $project::Component(Fork/Blade/EndLength)
            set Fork(BladeOffsetCrown)                  $project::Component(Fork/Crown/Blade/Offset)
            set Fork(BladeOffsetCrownPerp)              $project::Component(Fork/Crown/Blade/OffsetPerp)
            set Fork(BrakeAngle)                        $project::Component(Fork/Crown/Brake/Angle)
            set Fork(CrownOffsetBrake)                  $project::Component(Fork/Crown/Brake/Offset) 
            set Fork(CrownAngleBrake)                   $project::Component(Fork/Crown/Brake/Angle)
            set Fork(BladeOffsetDO)                     $project::Component(Fork/DropOut/Offset)
            set Fork(BladeOffsetDOPerp)                 $project::Component(Fork/DropOut/OffsetPerp)
                                
                #       
                # --- get Stem -----------------------------
        
                #       
                # --- get HeadTube -------------------------
            set HeadTube(Diameter)                      $project::FrameTubes(HeadTube/Diameter)
            set HeadTube(Length)                        $project::FrameTubes(HeadTube/Length)
        
                #       
                # --- get SeatTube -------------------------
            set SeatTube(DiameterBB)                    $project::FrameTubes(SeatTube/DiameterBB)
            set SeatTube(DiameterTT)                    $project::FrameTubes(SeatTube/DiameterTT)
            set SeatTube(TaperLength)                   $project::FrameTubes(SeatTube/TaperLength)
            set SeatTube(Extension)                     $project::Custom(SeatTube/Extension)
            set SeatTube(OffsetBB)                      $project::Custom(SeatTube/OffsetBB)

                #
                # --- get DownTube -------------------------
            set DownTube(DiameterBB)                    $project::FrameTubes(DownTube/DiameterBB)
            set DownTube(DiameterHT)                    $project::FrameTubes(DownTube/DiameterHT)
            set DownTube(TaperLength)                   $project::FrameTubes(DownTube/TaperLength)
            set DownTube(OffsetHT)                      $project::Custom(DownTube/OffsetHT)
            set DownTube(OffsetBB)                      $project::Custom(DownTube/OffsetBB)
        
                #       
                # --- get TopTube --------------------------
            set TopTube(DiameterHT)                     $project::FrameTubes(TopTube/DiameterHT)
            set TopTube(DiameterST)                     $project::FrameTubes(TopTube/DiameterST)
            set TopTube(TaperLength)                    $project::FrameTubes(TopTube/TaperLength)
            set TopTube(PivotPosition)                  $project::Custom(TopTube/PivotPosition)
            set TopTube(OffsetHT)                       $project::Custom(TopTube/OffsetHT)
        
                #       
                # --- get ChainStay ------------------------
            set ChainStay(HeightBB)                     $project::FrameTubes(ChainStay/HeightBB)
            set ChainStay(DiameterSS)                   $project::FrameTubes(ChainStay/DiameterSS)
            set ChainStay(Height)                       $project::FrameTubes(ChainStay/Height)
            set ChainStay(TaperLength)                  $project::FrameTubes(ChainStay/TaperLength)
            set ChainStay(WidthBB)                      $project::FrameTubes(ChainStay/WidthBB)
            set ChainStay(profile_y00)                  $project::FrameTubes(ChainStay/Profile/width_00)
            set ChainStay(profile_x01)                  $project::FrameTubes(ChainStay/Profile/length_01)
            set ChainStay(profile_y01)                  $project::FrameTubes(ChainStay/Profile/width_01)
            set ChainStay(profile_x02)                  $project::FrameTubes(ChainStay/Profile/length_02)
            set ChainStay(profile_y02)                  $project::FrameTubes(ChainStay/Profile/width_02)
            set ChainStay(profile_x03)                  $project::FrameTubes(ChainStay/Profile/length_03)
            set ChainStay(completeLength)               $project::FrameTubes(ChainStay/Profile/completeLength) 
            set ChainStay(cuttingLength)                $project::FrameTubes(ChainStay/Profile/cuttingLength) 
            set ChainStay(cuttingLeft)                  $project::FrameTubes(ChainStay/Profile/cuttingLeft)
            set ChainStay(segmentLength_01)             $project::FrameTubes(ChainStay/CenterLine/length_01)      
            set ChainStay(segmentLength_02)             $project::FrameTubes(ChainStay/CenterLine/length_02)      
            set ChainStay(segmentLength_03)             $project::FrameTubes(ChainStay/CenterLine/length_03)      
            set ChainStay(segmentLength_04)             $project::FrameTubes(ChainStay/CenterLine/length_04)       
            set ChainStay(segmentAngle_01)              $project::FrameTubes(ChainStay/CenterLine/angle_01)
            set ChainStay(segmentAngle_02)              $project::FrameTubes(ChainStay/CenterLine/angle_02)
            set ChainStay(segmentAngle_03)              $project::FrameTubes(ChainStay/CenterLine/angle_03)
            set ChainStay(segmentAngle_04)              $project::FrameTubes(ChainStay/CenterLine/angle_04)
            set ChainStay(segmentRadius_01)             $project::FrameTubes(ChainStay/CenterLine/radius_01)
            set ChainStay(segmentRadius_02)             $project::FrameTubes(ChainStay/CenterLine/radius_02)
            set ChainStay(segmentRadius_03)             $project::FrameTubes(ChainStay/CenterLine/radius_03)
            set ChainStay(segmentRadius_04)             $project::FrameTubes(ChainStay/CenterLine/radius_04)
                    
                #       
                # --- get SeatStay -------------------------
            set SeatStay(DiameterST)                    $project::FrameTubes(SeatStay/DiameterST)
            set SeatStay(DiameterCS)                    $project::FrameTubes(SeatStay/DiameterCS)
            set SeatStay(TaperLength)                   $project::FrameTubes(SeatStay/TaperLength)
            set SeatStay(OffsetTT)                      $project::Custom(SeatStay/OffsetTT)
            set SeatStay(SeatTubeMiterDiameter)         $project::Lugs(SeatTube/SeatStay/MiterDiameter)
        
                #       
                # --- get RearDropout ----------------------
            set RearDropout(RotationOffset)             $project::Lugs(RearDropOut/RotationOffset)
            set RearDropout(OffsetCS)                   $project::Lugs(RearDropOut/ChainStay/Offset)
            set RearDropout(OffsetCSPerp)               $project::Lugs(RearDropOut/ChainStay/OffsetPerp)
            set RearDropout(OffsetSS)                   $project::Lugs(RearDropOut/SeatStay/Offset)
            set RearDropout(OffsetSSPerp)               $project::Lugs(RearDropOut/SeatStay/OffsetPerp)
            set RearDropout(Derailleur_x)               $project::Lugs(RearDropOut/Derailleur/x)
            set RearDropout(Derailleur_y)               $project::Lugs(RearDropOut/Derailleur/y)
            set RearDropout(OffsetCS_TopView)           $project::Lugs(RearDropOut/ChainStay/Offset_TopView)
            

                #
                # --- get Lugs -----------------------------
            set Lugs(BottomBracket_ChainStay_Angle)     $project::Lugs(BottomBracket/ChainStay/Angle/value) 
            set Lugs(BottomBracket_ChainStay_Tolerance) $project::Lugs(BottomBracket/ChainStay/Angle/plus_minus) 
            set Lugs(BottomBracket_DownTube_Angle)      $project::Lugs(BottomBracket/DownTube/Angle/value) 
            set Lugs(BottomBracket_DownTube_Tolerance)  $project::Lugs(BottomBracket/DownTube/Angle/plus_minus) 
            set Lugs(HeadLug_Bottom_Angle)              $project::Lugs(HeadTube/DownTube/Angle/value) 
            set Lugs(HeadLug_Bottom_Tolerance)          $project::Lugs(HeadTube/DownTube/Angle/plus_minus) 
            set Lugs(HeadLug_Top_Angle)                 $project::Lugs(HeadTube/TopTube/Angle/value) 
            set Lugs(HeadLug_Top_Tolerance)             $project::Lugs(HeadTube/TopTube/Angle/plus_minus) 
            set Lugs(RearDropOut_Angle)                 $project::Lugs(RearDropOut/Angle/value) 
            set Lugs(RearDropOut_Tolerance)             $project::Lugs(RearDropOut/Angle/plus_minus) 
            set Lugs(SeatLug_SeatStay_Angle)            $project::Lugs(SeatTube/SeatStay/Angle/value) 
            set Lugs(SeatLug_SeatStay_Tolerance)        $project::Lugs(SeatTube/SeatStay/Angle/plus_minus) 
            set Lugs(SeatLug_TopTube_Angle)             $project::Lugs(SeatTube/TopTube/Angle/value) 
            set Lugs(SeatLug_TopTube_Tolerance)         $project::Lugs(SeatTube/TopTube/Angle/plus_minus) 
           
                
                #
                # --- get Saddle ---------------------------
            set Saddle(Height)                          $project::Component(Saddle/Height)
            set Saddle(Length)                          $project::Component(Saddle/Length)
            set Saddle(NoseLength)                      $project::Component(Saddle/LengthNose)
            set Saddle(Offset_x)                        $project::Rendering(Saddle/Offset_X) 
            set Saddle(Offset_y)                        $project::Rendering(Saddle/Offset_Y)

                #
                # --- get SaddleMount - Position ----------------
            set SeatPost(Diameter)                      $project::Component(SeatPost/Diameter)
            set SeatPost(Setback)                       $project::Component(SeatPost/Setback)
            set SeatPost(PivotOffset)                   $project::Component(SeatPost/PivotOffset)
        
                #       
                # --- get HeadSet -------------------------------
            set HeadSet(Diameter)                       $project::Component(HeadSet/Diameter)
            set HeadSet(Height_Top)                     $project::Component(HeadSet/Height/Top)
            set HeadSet(Height_Bottom)                  $project::Component(HeadSet/Height/Bottom)
            set HeadSet(ShimDiameter)                   36
        
                #       
                # --- get Front/Rear Brake PadLever -------------
            set FrontBrake(LeverLength)                 $project::Component(Brake/Front/LeverLength)
            set FrontBrake(Offset)                      $project::Component(Brake/Front/Offset)
            set RearBrake(LeverLength)                  $project::Component(Brake/Rear/LeverLength)
            set RearBrake(Offset)                       $project::Component(Brake/Rear/Offset)
        
                #       
                # --- get BottleCage ----------------------------
            set BottleCage(SeatTube)                    $project::Component(BottleCage/SeatTube/OffsetBB)
            set BottleCage(DownTube)                    $project::Component(BottleCage/DownTube/OffsetBB)
            set BottleCage(DownTube_Lower)              $project::Component(BottleCage/DownTube_Lower/OffsetBB)
                    
                # --- get CrankSet  -----------------------------
            set CrankSet(ArmWidth)                      $project::Component(CrankSet/ArmWidth)
            set CrankSet(ChainLine)                     $project::Component(CrankSet/ChainLine)
            set CrankSet(Length)                        $project::Component(CrankSet/Length)
            set CrankSet(PedalEye)                      $project::Component(CrankSet/PedalEye)
            set CrankSet(Q-Factor)                      $project::Component(CrankSet/Q-Factor)
                    
                #       
                # --- get FrontDerailleur  ----------------------
            set FrontDerailleur(Distance)               $project::Component(Derailleur/Front/Distance)
            set FrontDerailleur(Offset)                 $project::Component(Derailleur/Front/Offset)
        
                #       
                # --- get RearDerailleur  -----------------------
            set RearDerailleur(Pulley_teeth)            $project::Component(Derailleur/Rear/Pulley/teeth)  
            set RearDerailleur(Pulley_x)                $project::Component(Derailleur/Rear/Pulley/x)      
            set RearDerailleur(Pulley_y)                $project::Component(Derailleur/Rear/Pulley/y)

                #
                # --- get Fender  -------------------------------
            set RearFender(Radius)                      $project::Component(Fender/Rear/Radius)
            set RearFender(OffsetAngle)                 $project::Component(Fender/Rear/OffsetAngle)
            set RearFender(Height)                      $project::Component(Fender/Rear/Height)
            set FrontFender(Radius)                     $project::Component(Fender/Front/Radius)
            set FrontFender(OffsetAngleFront)           $project::Component(Fender/Front/OffsetAngleFront)
            set FrontFender(OffsetAngle)                $project::Component(Fender/Front/OffsetAngle)
            set FrontFender(Height)                     $project::Component(Fender/Front/Height)
            
                #
                # --- get Carrier  ------------------------------
            set FrontCarrier(x)                         $project::Component(Carrier/Front/x)
            set FrontCarrier(y)                         $project::Component(Carrier/Front/y)
            set RearCarrier(x)                          $project::Component(Carrier/Rear/x)
            set RearCarrier(y)                          $project::Component(Carrier/Rear/y)
                         
                #
                # --- set DEBUG_Geometry  ----------------------
            set DEBUG_Geometry(Base)        {0 0}
            
                #
                #
                # --- check values  ----------------------------
            if {[expr $BottomBracket(OutsideDiameter) -2.0] < $BottomBracket(InsideDiameter)} {
                set BottomBracket(InsideDiameter)       [expr $BottomBracket(OutsideDiameter) -2.0]
                set project::Lugs(BottomBracket/Diameter/inside) $BottomBracket(InsideDiameter)
            }
            if {$Saddle(Height) < 0} {
                set Saddle(Height)  0
            }            
               
    }


    proc bikeGeometry::set_to_project {} {
                #
            variable BottleCage
            variable BottomBracket
            variable BoundingBox
            variable CenterLine
            variable ChainStay
            variable Component
            variable Config
            variable CrankSet
            variable Direction
            variable DownTube
            variable Fork
            variable FrontBrake
            variable FrontCarrier
            variable FrontDerailleur
            variable FrontFender
            variable FrontWheel
            variable Geometry
            variable HandleBar
            variable HeadSet
            variable HeadTube
            variable ListValue
            variable Lugs
            variable Polygon
            variable Position
            variable RearBrake
            variable RearCarrier
            variable RearDerailleur
            variable RearDropout
            variable RearFender
            variable RearMockup
            variable RearWheel
            variable Reference
            variable Result
            variable Saddle
            variable SeatPost
            variable SeatStay
            variable SeatTube
            variable TopTube
            variable TubeMiter          
                
                #
            project::setValue Component(BottleCage/DownTube/File)                   value       $Component(BottleCage_DownTube)           
            project::setValue Component(BottleCage/DownTube_Lower/File)             value       $Component(BottleCage_DownTube_Lower)     
            project::setValue Component(BottleCage/SeatTube/File)                   value       $Component(BottleCage_SeatTube)           
            project::setValue Component(CrankSet/File)                              value       $Component(CrankSet)                      
            project::setValue Component(Fork/Crown/File)                            value       $Component(ForkCrown)                     
            project::setValue Component(Fork/DropOut/File)                          value       $Component(ForkDropout)                   
            project::setValue Component(Brake/Front/File)                           value       $Component(FrontBrake)                    
            project::setValue Component(Carrier/Front/File)                         value       $Component(FrontCarrier)                  
            project::setValue Component(Derailleur/Front/File)                      value       $Component(FrontDerailleur)               
            project::setValue Component(HandleBar/File)                             value       $Component(HandleBar)                     
            project::setValue Component(Logo/File)                                  value       $Component(Logo)                          
            project::setValue Component(Brake/Rear/File)                            value       $Component(RearBrake)                     
            project::setValue Component(Carrier/Rear/File)                          value       $Component(RearCarrier)                   
            project::setValue Component(Derailleur/Rear/File)                       value       $Component(RearDerailleur)                
            project::setValue Lugs(RearDropOut/File)                                value       $Component(RearDropout)                                                                               
            project::setValue Component(Saddle/File)                                value       $Component(Saddle)                        
                                                                                    
                #                                                                   
                # --- get Rendering  -------------------                            
            project::setValue Rendering(Brake/Front)                                value       $Config(FrontBrake)                       
            project::setValue Rendering(Brake/Rear)                                 value       $Config(RearBrake)                        
            project::setValue Rendering(BottleCage/SeatTube)                        value       $Config(BottleCage_SeatTube)              
            project::setValue Rendering(BottleCage/DownTube)                        value       $Config(BottleCage_DownTube)              
            project::setValue Rendering(BottleCage/DownTube_Lower)                  value       $Config(BottleCage_DownTube_Lower)        
            project::setValue Rendering(Fender/Front)                               value       $Config(FrontFender)                      
            project::setValue Rendering(Fender/Rear)                                value       $Config(RearFender)                       
            project::setValue Rendering(ChainStay)                                  value       $Config(ChainStay)                        
            project::setValue Rendering(Fork)                                       value       $Config(Fork)                             
            project::setValue Rendering(ForkBlade)                                  value       $Config(ForkBlade)                        
            project::setValue Rendering(ForkDropOut)                                value       $Config(ForkDropout)                      
            project::setValue Rendering(RearDropOut)                                value       $Config(RearDropout)                      
            project::setValue Lugs(RearDropOut/Direction)                           value       $Config(RearDropoutOrient)                
                                                                                    
                #                                                                   
                # --- get ListValue  -------------------                            
            project::setValue Component(CrankSet/ChainRings)                        value       $ListValue(CrankSetChainRings)            
                                                                                    
                #                                                                   
                # --- get Geometry  --------------------                            
            project::setValue Custom(BottomBracket/Depth)                           value       $Geometry(BottomBracket_Depth)            
            project::setValue Custom(WheelPosition/Rear)                            value       $Geometry(ChainStay_Length)               
            project::setValue Component(Fork/Height)                                value       $Geometry(Fork_Height)                    
            project::setValue Component(Fork/Rake)                                  value       $Geometry(Fork_Rake)                      
            project::setValue Component(Wheel/Front/RimDiameter)                    value       $Geometry(FrontRim_Diameter)              
            project::setValue Component(Wheel/Front/TyreHeight)                     value       $Geometry(FrontTyre_Height)               
            project::setValue Personal(HandleBar_Distance)                          value       $Geometry(HandleBar_Distance)             
            project::setValue Personal(HandleBar_Height)                            value       $Geometry(HandleBar_Height)               
            project::setValue Custom(HeadTube/Angle)                                value       $Geometry(HeadTube_Angle)                 
            project::setValue Personal(InnerLeg_Length)                             value       $Geometry(Inseam_Length)                  
            project::setValue Component(Wheel/Rear/RimDiameter)                     value       $Geometry(RearRim_Diameter)               
            project::setValue Component(Wheel/Rear/TyreHeight)                      value       $Geometry(RearTyre_Height)                
            project::setValue Personal(Saddle_Distance)                             value       $Geometry(Saddle_Distance)                
            project::setValue Personal(Saddle_Height)                               value       $Geometry(Saddle_Height)                  
            project::setValue Component(Stem/Angle)                                 value       $Geometry(Stem_Angle)                     
            project::setValue Component(Stem/Length)                                value       $Geometry(Stem_Length)                    
            project::setValue Custom(TopTube/Angle)                                 value       $Geometry(TopTube_Angle)                  
            project::setValue Custom(SeatTube/LengthVirtual)                        value       $Geometry(SeatTube_Virtual)                         
                                                                                    
                #                                                                   
                # --- get RearMockup  ------------------                            
            project::setValue Rendering(RearMockup/CassetteClearance)               value       $RearMockup(CassetteClearance)            
            project::setValue Rendering(RearMockup/ChainWheelClearance)             value       $RearMockup(ChainWheelClearance)          
            project::setValue Rendering(RearMockup/CrankClearance)                  value       $RearMockup(CrankClearance)               
            project::setValue Rendering(RearMockup/DiscClearance)                   value       $RearMockup(DiscClearance)                
            project::setValue Rendering(RearMockup/DiscDiameter)                    value       $RearMockup(DiscDiameter)                 
            project::setValue Rendering(RearMockup/DiscOffset)                      value       $RearMockup(DiscOffset)                   
            project::setValue Rendering(RearMockup/DiscWidth)                       value       $RearMockup(DiscWidth)                    
            project::setValue Rendering(RearMockup/TyreClearance)                   value       $RearMockup(TyreClearance)                
                                                                                    
                #                                                                   
                # --- get Reference  -------------------                            
            project::setValue Reference(SaddleNose_Distance)                        value       $Reference(SaddleNose_Distance)           
            project::setValue Reference(SaddleNose_Height)                          value       $Reference(SaddleNose_Height)             
            project::setValue Reference(HandleBar_Distance)                         value       $Reference(HandleBar_Distance)            
            project::setValue Reference(HandleBar_Height)                           value       $Reference(HandleBar_Height)              
                                                                                    
                                                                                    
                #                                                                   
                # --- get BottomBracket (1)                                         
            project::setValue Lugs(BottomBracket/Diameter/outside)                  value       $BottomBracket(OutsideDiameter)           
            project::setValue Lugs(BottomBracket/Diameter/inside)                   value       $BottomBracket(InsideDiameter)            
            project::setValue Lugs(BottomBracket/Width)                             value       $BottomBracket(Width)                     
            project::setValue Lugs(BottomBracket/ChainStay/Offset_TopView)          value       $BottomBracket(OffsetCS_TopView)          
                                                                                    
                                                                                    
                #                                                                   
                # --- get RearWheel                                                 
            project::setValue Component(Wheel/Rear/RimHeight)                       value       $RearWheel(RimHeight)                     
            project::setValue Component(Wheel/Rear/TyreWidth)                       value       $RearWheel(TyreWidth)                     
            project::setValue Component(Wheel/Rear/TyreWidthRadius)                 value       $RearWheel(TyreWidthRadius)               
            project::setValue Component(Wheel/Rear/HubWidth)                        value       $RearWheel(HubWidth)                      
            project::setValue Component(Wheel/Rear/FirstSprocket)                   value       $RearWheel(FirstSprocket)                 
                                                                                    
                                                                                    
                #                                                                   
                # --- get FrontWheel                                                
            project::setValue Component(Wheel/Front/RimHeight)                      value       $FrontWheel(RimHeight)                    
                                                                                    
                #                                                                   
                # --- get HandleBarMount - Position                                 
            project::setValue Component(HandleBar/PivotAngle)                       value       $HandleBar(PivotAngle)                    
                                                                                    
                #                                                                   
                # --- get Fork -------------------------                            
            project::setValue Component(Fork/Blade/Width)                           value       $Fork(BladeWidth)                         
            project::setValue Component(Fork/Blade/DiameterDO)                      value       $Fork(BladeDiameterDO)                    
            project::setValue Component(Fork/Blade/TaperLength)                     value       $Fork(BladeTaperLength)                   
            project::setValue Component(Fork/Blade/BendRadius)                      value       $Fork(BladeBendRadius)                    
            project::setValue Component(Fork/Blade/EndLength)                       value       $Fork(BladeEndLength)                     
            project::setValue Component(Fork/Crown/Blade/Offset)                    value       $Fork(BladeOffsetCrown)                   
            project::setValue Component(Fork/Crown/Blade/OffsetPerp)                value       $Fork(BladeOffsetCrownPerp)               
            project::setValue Component(Fork/Crown/Brake/Angle)                     value       $Fork(BrakeAngle)                         
            project::setValue Component(Fork/Crown/Brake/Offset)                    value       $Fork(CrownOffsetBrake)                   
            project::setValue Component(Fork/Crown/Brake/Angle)                     value       $Fork(CrownAngleBrake)                    
            project::setValue Component(Fork/DropOut/Offset)                        value       $Fork(BladeOffsetDO)                      
            project::setValue Component(Fork/DropOut/OffsetPerp)                    value       $Fork(BladeOffsetDOPerp)                  
                                                                                    
                #                                                                   
                # --- get Stem -------------------------                            
                                                                                    
                #                                                                   
                # --- get HeadTube ---------------------                            
            project::setValue FrameTubes(HeadTube/Diameter)                         value       $HeadTube(Diameter)                       
            project::setValue FrameTubes(HeadTube/Length)                           value       $HeadTube(Length)                         
                                                                                    
                #                                                                   
                # --- get SeatTube ---------------------                            
            project::setValue FrameTubes(SeatTube/DiameterBB)                       value       $SeatTube(DiameterBB)                     
            project::setValue FrameTubes(SeatTube/DiameterTT)                       value       $SeatTube(DiameterTT)                     
            project::setValue FrameTubes(SeatTube/TaperLength)                      value       $SeatTube(TaperLength)                    
            project::setValue Custom(SeatTube/Extension)                            value       $SeatTube(Extension)                      
            project::setValue Custom(SeatTube/OffsetBB)                             value       $SeatTube(OffsetBB)                       
                                                                                    
                #                                                                   
                # --- get DownTube ---------------------                            
            project::setValue FrameTubes(DownTube/DiameterBB)                       value       $DownTube(DiameterBB)                     
            project::setValue FrameTubes(DownTube/DiameterHT)                       value       $DownTube(DiameterHT)                     
            project::setValue FrameTubes(DownTube/TaperLength)                      value       $DownTube(TaperLength)                    
            project::setValue Custom(DownTube/OffsetHT)                             value       $DownTube(OffsetHT)                       
            project::setValue Custom(DownTube/OffsetBB)                             value       $DownTube(OffsetBB)                       
                                                                                    
                #                                                                   
                # --- get TopTube ----------------------                            
            project::setValue FrameTubes(TopTube/DiameterHT)                        value       $TopTube(DiameterHT)                      
            project::setValue FrameTubes(TopTube/DiameterST)                        value       $TopTube(DiameterST)                      
            project::setValue FrameTubes(TopTube/TaperLength)                       value       $TopTube(TaperLength)                     
            project::setValue Custom(TopTube/PivotPosition)                         value       $TopTube(PivotPosition)                   
            project::setValue Custom(TopTube/OffsetHT)                              value       $TopTube(OffsetHT)                        
                                                                                    
                #                                                                   
                # --- get ChainStay --------------------                            
            project::setValue FrameTubes(ChainStay/HeightBB)                        value       $ChainStay(HeightBB)                      
            project::setValue FrameTubes(ChainStay/DiameterSS)                      value       $ChainStay(DiameterSS)                    
            project::setValue FrameTubes(ChainStay/Height)                          value       $ChainStay(Height)                        
            project::setValue FrameTubes(ChainStay/TaperLength)                     value       $ChainStay(TaperLength)                   
            project::setValue FrameTubes(ChainStay/WidthBB)                         value       $ChainStay(WidthBB)                       
            project::setValue FrameTubes(ChainStay/Profile/width_00)                value       $ChainStay(profile_y00)                   
            project::setValue FrameTubes(ChainStay/Profile/length_01)               value       $ChainStay(profile_x01)                   
            project::setValue FrameTubes(ChainStay/Profile/width_01)                value       $ChainStay(profile_y01)                   
            project::setValue FrameTubes(ChainStay/Profile/length_02)               value       $ChainStay(profile_x02)                   
            project::setValue FrameTubes(ChainStay/Profile/width_02)                value       $ChainStay(profile_y02)                   
            project::setValue FrameTubes(ChainStay/Profile/length_03)               value       $ChainStay(profile_x03)                   
            project::setValue FrameTubes(ChainStay/Profile/completeLength)          value       $ChainStay(completeLength)                
            project::setValue FrameTubes(ChainStay/Profile/cuttingLength)           value       $ChainStay(cuttingLength)                 
            project::setValue FrameTubes(ChainStay/Profile/cuttingLeft)             value       $ChainStay(cuttingLeft)                   
            project::setValue FrameTubes(ChainStay/CenterLine/length_01)            value       $ChainStay(segmentLength_01)              
            project::setValue FrameTubes(ChainStay/CenterLine/length_02)            value       $ChainStay(segmentLength_02)              
            project::setValue FrameTubes(ChainStay/CenterLine/length_03)            value       $ChainStay(segmentLength_03)              
            project::setValue FrameTubes(ChainStay/CenterLine/length_04)            value       $ChainStay(segmentLength_04)              
            project::setValue FrameTubes(ChainStay/CenterLine/angle_01)             value       $ChainStay(segmentAngle_01)               
            project::setValue FrameTubes(ChainStay/CenterLine/angle_02)             value       $ChainStay(segmentAngle_02)               
            project::setValue FrameTubes(ChainStay/CenterLine/angle_03)             value       $ChainStay(segmentAngle_03)               
            project::setValue FrameTubes(ChainStay/CenterLine/angle_04)             value       $ChainStay(segmentAngle_04)               
            project::setValue FrameTubes(ChainStay/CenterLine/radius_01)            value       $ChainStay(segmentRadius_01)              
            project::setValue FrameTubes(ChainStay/CenterLine/radius_02)            value       $ChainStay(segmentRadius_02)              
            project::setValue FrameTubes(ChainStay/CenterLine/radius_03)            value       $ChainStay(segmentRadius_03)              
            project::setValue FrameTubes(ChainStay/CenterLine/radius_04)            value       $ChainStay(segmentRadius_04)              
                                                                                    
                #                                                                   
                # --- get SeatStay ---------------------                            
            project::setValue FrameTubes(SeatStay/DiameterST)                       value       $SeatStay(DiameterST)                     
            project::setValue FrameTubes(SeatStay/DiameterCS)                       value       $SeatStay(DiameterCS)                     
            project::setValue FrameTubes(SeatStay/TaperLength)                      value       $SeatStay(TaperLength)                    
            project::setValue Custom(SeatStay/OffsetTT)                             value       $SeatStay(OffsetTT)                       
            project::setValue Lugs(SeatTube/SeatStay/MiterDiameter)                 value       $SeatStay(SeatTubeMiterDiameter)          
                                                                                    
                #                                                                   
                # --- get RearDropout ------------------                            
            project::setValue Lugs(RearDropOut/RotationOffset)                      value       $RearDropout(RotationOffset)              
            project::setValue Lugs(RearDropOut/ChainStay/Offset)                    value       $RearDropout(OffsetCS)                    
            project::setValue Lugs(RearDropOut/ChainStay/OffsetPerp)                value       $RearDropout(OffsetCSPerp)                
            project::setValue Lugs(RearDropOut/SeatStay/Offset)                     value       $RearDropout(OffsetSS)                    
            project::setValue Lugs(RearDropOut/SeatStay/OffsetPerp)                 value       $RearDropout(OffsetSSPerp)                
            project::setValue Lugs(RearDropOut/Derailleur/x)                        value       $RearDropout(Derailleur_x)                
            project::setValue Lugs(RearDropOut/Derailleur/y)                        value       $RearDropout(Derailleur_y)                
            project::setValue Lugs(RearDropOut/ChainStay/Offset_TopView)            value       $RearDropout(OffsetCS_TopView)            
                                                                                    
                                                                                    
                #                                                                   
                # --- get Lugs -------------------------                            
            project::setValue Lugs(BottomBracket/ChainStay/Angle/value)             value       $Lugs(BottomBracket_ChainStay_Angle)      
            project::setValue Lugs(BottomBracket/ChainStay/Angle/plus_minus)        value       $Lugs(BottomBracket_ChainStay_Tolerance)  
            project::setValue Lugs(BottomBracket/DownTube/Angle/value)              value       $Lugs(BottomBracket_DownTube_Angle)       
            project::setValue Lugs(BottomBracket/DownTube/Angle/plus_minus)         value       $Lugs(BottomBracket_DownTube_Tolerance)   
            project::setValue Lugs(HeadTube/DownTube/Angle/value)                   value       $Lugs(HeadLug_Bottom_Angle)               
            project::setValue Lugs(HeadTube/DownTube/Angle/plus_minus)              value       $Lugs(HeadLug_Bottom_Tolerance)           
            project::setValue Lugs(HeadTube/TopTube/Angle/value)                    value       $Lugs(HeadLug_Top_Angle)                  
            project::setValue Lugs(HeadTube/TopTube/Angle/plus_minus)               value       $Lugs(HeadLug_Top_Tolerance)              
            project::setValue Lugs(RearDropOut/Angle/value)                         value       $Lugs(RearDropOut_Angle)                  
            project::setValue Lugs(RearDropOut/Angle/plus_minus)                    value       $Lugs(RearDropOut_Tolerance)              
            project::setValue Lugs(SeatTube/SeatStay/Angle/value)                   value       $Lugs(SeatLug_SeatStay_Angle)             
            project::setValue Lugs(SeatTube/SeatStay/Angle/plus_minus)              value       $Lugs(SeatLug_SeatStay_Tolerance)         
            project::setValue Lugs(SeatTube/TopTube/Angle/value)                    value       $Lugs(SeatLug_TopTube_Angle)              
            project::setValue Lugs(SeatTube/TopTube/Angle/plus_minus)               value       $Lugs(SeatLug_TopTube_Tolerance)          
                                                                                    
                                                                                    
                #                                                                   
                # --- get Saddle -----------------------                            
            project::setValue Component(Saddle/Height)                              value       $Saddle(Height)                           
            project::setValue Component(Saddle/Length)                              value       $Saddle(Length)                           
            project::setValue Component(Saddle/LengthNose)                          value       $Saddle(NoseLength)                       
            project::setValue Rendering(Saddle/Offset_X)                            value       $Saddle(Offset_x)                         
            project::setValue Rendering(Saddle/Offset_Y)                            value       $Saddle(Offset_y)                         
                                                                                    
                                                                
                #                                                                   
                # --- get SaddleMount - Position                                    
            project::setValue Component(SeatPost/Diameter)                          value       $SeatPost(Diameter)                       
            project::setValue Component(SeatPost/Setback)                           value       $SeatPost(Setback)                        
            project::setValue Component(SeatPost/PivotOffset)                       value       $SeatPost(PivotOffset)                    
                                                                                    
                #                                                                   
                # --- get HeadSet ----------------------                            
            project::setValue Component(HeadSet/Diameter)                           value       $HeadSet(Diameter)                        
            project::setValue Component(HeadSet/Height/Top)                         value       $HeadSet(Height_Top)                      
            project::setValue Component(HeadSet/Height/Bottom)                      value       $HeadSet(Height_Bottom)                                                    
                                                                                    
                #                                                                   
                # --- get Front/Rear Brake PadLever ----                            
            project::setValue Component(Brake/Front/LeverLength)                    value       $FrontBrake(LeverLength)                  
            project::setValue Component(Brake/Front/Offset)                         value       $FrontBrake(Offset)                       
            project::setValue Component(Brake/Rear/LeverLength)                     value       $RearBrake(LeverLength)                   
            project::setValue Component(Brake/Rear/Offset)                          value       $RearBrake(Offset)                        
                                                                                    
                #                                                                   
                # --- get BottleCage -------------------                            
            project::setValue Component(BottleCage/SeatTube/OffsetBB)               value       $BottleCage(SeatTube)                     
            project::setValue Component(BottleCage/DownTube/OffsetBB)               value       $BottleCage(DownTube)                     
            project::setValue Component(BottleCage/DownTube_Lower/OffsetBB)         value       $BottleCage(DownTube_Lower)               
                                                                                    
                # --- get CrankSet  --------------------                            
            project::setValue Component(CrankSet/ArmWidth)                          value       $CrankSet(ArmWidth)                       
            project::setValue Component(CrankSet/ChainLine)                         value       $CrankSet(ChainLine)                      
            project::setValue Component(CrankSet/Length)                            value       $CrankSet(Length)                         
            project::setValue Component(CrankSet/PedalEye)                          value       $CrankSet(PedalEye)                       
            project::setValue Component(CrankSet/Q-Factor)                          value       $CrankSet(Q-Factor)                       
                                                                                    
                #                                                                   
                # --- get FrontDerailleur  -------------                            
            project::setValue Component(Derailleur/Front/Distance)                  value       $FrontDerailleur(Distance)                
            project::setValue Component(Derailleur/Front/Offset)                    value       $FrontDerailleur(Offset)                  
                                                                                    
                #                                                                   
                # --- get RearDerailleur  --------------                            
            project::setValue Component(Derailleur/Rear/Pulley/teeth)               value       $RearDerailleur(Pulley_teeth)             
            project::setValue Component(Derailleur/Rear/Pulley/x)                   value       $RearDerailleur(Pulley_x)                 
            project::setValue Component(Derailleur/Rear/Pulley/y)                   value       $RearDerailleur(Pulley_y)                 
                                                                                    
                #                                                                   
                # --- get Fender  ----------------------                            
            project::setValue Component(Fender/Rear/Radius)                         value       $RearFender(Radius)                       
            project::setValue Component(Fender/Rear/OffsetAngle)                    value       $RearFender(OffsetAngle)                  
            project::setValue Component(Fender/Rear/Height)                         value       $RearFender(Height)                       
            project::setValue Component(Fender/Front/Radius)                        value       $FrontFender(Radius)                      
            project::setValue Component(Fender/Front/OffsetAngleFront)              value       $FrontFender(OffsetAngleFront)            
            project::setValue Component(Fender/Front/OffsetAngle)                   value       $FrontFender(OffsetAngle)                 
            project::setValue Component(Fender/Front/Height)                        value       $FrontFender(Height)                      
                                                                                    
                #                                                                   
                # --- get Carrier  ---------------------                            
            project::setValue Component(Carrier/Front/x)                            value       $FrontCarrier(x)                          
            project::setValue Component(Carrier/Front/y)                            value       $FrontCarrier(y)                          
            project::setValue Component(Carrier/Rear/x)                             value       $RearCarrier(x)                           
            project::setValue Component(Carrier/Rear/y)                             value       $RearCarrier(y)     

                #                                                                   
                # --- get Result  ----------------------                            
            project::setValue Component(Fork/Crown/File)                            value       $Component(ForkCrown)
            project::setValue Component(Fork/DropOut/File)                          value       $Component(ForkDropout)
            project::setValue Component(HandleBar/PivotAngle)                       value       $HandleBar(PivotAngle)
            project::setValue Rendering(RearMockup/CassetteClearance)               value       $RearMockup(CassetteClearance)           
            project::setValue Rendering(RearMockup/ChainWheelClearance)             value       $RearMockup(ChainWheelClearance)           
            project::setValue Rendering(RearMockup/CrankClearance)                  value       $RearMockup(CrankClearance)           
            project::setValue Rendering(RearMockup/DiscClearance)                   value       $RearMockup(DiscClearance)           
            project::setValue Rendering(RearMockup/DiscDiameter)                    value       $RearMockup(DiscDiameter)           
            project::setValue Rendering(RearMockup/DiscOffset)                      value       $RearMockup(DiscOffset)           
            project::setValue Rendering(RearMockup/DiscWidth)                       value       $RearMockup(DiscWidth)           
            project::setValue Rendering(RearMockup/TyreClearance)                   value       $RearMockup(TyreClearance) 
            project::setValue Rendering(Saddle/Offset_X)                            value       $Saddle(Offset_x)   
            project::setValue Rendering(Saddle/Offset_Y)                            value       $Saddle(Offset_y)   
            project::setValue Result(Angle/BottomBracket/ChainStay)                 value       $Geometry(BottomBracket_Angle_ChainStay)
            project::setValue Result(Angle/BottomBracket/DownTube)                  value       $Geometry(BottomBracket_Angle_DownTube)
            project::setValue Result(Angle/HeadTube/DownTube)                       value       $Geometry(HeadLug_Angle_Bottom)
            project::setValue Result(Angle/HeadTube/TopTube)                        value       $Geometry(HeadLug_Angle_Top) 
            project::setValue Result(Angle/SeatStay/ChainStay)                      value       $Geometry(SeatLug_Angle_SeatStay)
            project::setValue Result(Angle/SeatTube/Direction)                      value       $Geometry(SeatTube_Angle)
            project::setValue Result(Angle/SeatTube/SeatStay)                       value       $Geometry(SeatLug_Angle_SeatStay)
            project::setValue Result(Angle/SeatTube/TopTube)                        value       $Geometry(SeatLug_Angle_TopTube)
            project::setValue Result(Components/Fender/Front/Polygon)               polygon     $Polygon(FrontFender)
            project::setValue Result(Components/Fender/Rear/Polygon)                polygon     $Polygon(RearFender)
            project::setValue Result(Components/HeadSet/Bottom/Polygon)             polygon     $Polygon(HeadSetBottom)
            project::setValue Result(Components/HeadSet/Top/Polygon)                polygon     $Polygon(HeadSetTop)
            project::setValue Result(Components/SeatPost/Polygon)                   polygon     $Polygon(SeatPost)
            project::setValue Result(Components/Stem/Polygon)                       polygon     $Polygon(Stem)
            project::setValue Result(Length/BottomBracket/Height)                   value       $Geometry(BottomBracket_Height)
            project::setValue Result(Length/FrontWheel/Diameter)                    value       [expr 2.0 * $Geometry(FrontWheel_Radius)]
            project::setValue Result(Length/FrontWheel/Radius)                      value       $Geometry(FrontWheel_Radius)
            project::setValue Result(Length/FrontWheel/diagonal)                    value       $Geometry(FrontWheel_xy)
            project::setValue Result(Length/FrontWheel/horizontal)                  value       $Geometry(FrontWheel_x)
            project::setValue Result(Length/HeadTube/ReachLength)                   value       $Geometry(Reach_Length)
            project::setValue Result(Length/HeadTube/StackHeight)                   value       $Geometry(Stack_Height)
            project::setValue Result(Length/Personal/SaddleNose_HB)                 value       $Geometry(SaddleNose_HB)
            project::setValue Result(Length/RearWheel/Diameter)                     value       [expr 2.0 * $Geometry(RearWheel_Radius)]                                  
            project::setValue Result(Length/RearWheel/Radius)                       value       $Geometry(RearWheel_Radius)                                    
            project::setValue Result(Length/RearWheel/TyreShoulder)                 value       $RearWheel(TyreShoulder)                             
            project::setValue Result(Length/RearWheel/horizontal)                   value       $Geometry(RearWheel_x)      ;#$Result(Length/RearWheel/horizontal) 
            project::setValue Result(Length/Reference/HandleBar_BB)                 value       $Reference(HandleBar_BB)    ;#Result(Length/Reference/HandleBar_BB) 
            project::setValue Result(Length/Reference/HandleBar_FW)                 value       $Reference(HandleBar_FW)    ;#Result(Length/Reference/HandleBar_FW) 
            project::setValue Result(Length/Reference/Heigth_SN_HB)                 value       $Reference(SaddleNose_HB_y) ;#Result(Length/Reference/Heigth_SN_HB)
            project::setValue Result(Length/Reference/SaddleNose_BB)                value       $Reference(SaddleNose_BB)   ;#Result(Length/Reference/SaddleNose_BB)
            project::setValue Result(Length/Reference/SaddleNose_HB)                value       $Reference(SaddleNose_HB)   ;#Result(Length/Reference/SaddleNose_HB)
            project::setValue Result(Length/Saddle/Offset_BB)                       value       $Geometry(Saddle_Offset_BB)                                   
            project::setValue Result(Length/Saddle/Offset_BB_Nose)                  value       $Geometry(SaddleNose_BB_x)                              
            project::setValue Result(Length/Saddle/Offset_BB_ST)                    value       $Geometry(Saddle_Offset_BB_ST)                                
            project::setValue Result(Length/Saddle/Offset_HB)                       value       $Geometry(Saddle_HB_y)                                   
            project::setValue Result(Length/Saddle/SeatTube_BB)                     value       $Geometry(Saddle_BB)                                 
            project::setValue Result(Length/SeatTube/TubeHeight)                    value       $Geometry(SeatTube_TubeHeight)                                
            project::setValue Result(Length/SeatTube/TubeLength)                    value       $Geometry(SeatTube_TubeLength)                                
            project::setValue Result(Length/SeatTube/VirtualLength)                 value       $Geometry(SeatTube_Virtual)                            
            project::setValue Result(Length/TopTube/VirtualLength)                  value       $Geometry(TopTube_Virtual)                              
            project::setValue Result(Lugs/Dropout/Front/Direction)                  direction   $Direction(ForkDropout)                              
            project::setValue Result(Lugs/Dropout/Front/Position)                   position    $Position(FrontWheel)
            project::setValue Result(Lugs/Dropout/Rear/Derailleur)                  position    $Position(RearDerailleur)                              
            project::setValue Result(Lugs/Dropout/Rear/Direction)                   direction   $Direction(RearDropout)                              
            project::setValue Result(Lugs/Dropout/Rear/Position)                    position    $Position(RearDropout)                                
            project::setValue Result(Lugs/ForkCrown/Direction)                      direction   $Direction(ForkCrown)                                  
            project::setValue Result(Lugs/ForkCrown/Position)                       position    $Position(Steerer_Start)
            project::setValue Result(Position/BottomBracketGround)                  position    $Position(BottomBracket_Ground)                              
            project::setValue Result(Position/Brake/Front/Definition)               position    $Position(FrontBrake_Definition)                           
            project::setValue Result(Position/Brake/Front/Help)                     position    $Position(FrontBrake_Help)                                 
            project::setValue Result(Position/Brake/Front/Mount)                    position    $Position(FrontBrake_Mount)                                
            project::setValue Result(Position/Brake/Front/Shoe)                     position    $Position(FrontBrake_Shoe)                                 
            project::setValue Result(Position/Brake/Rear/Definition)                position    $Position(RearBrake_Definition)                            
            project::setValue Result(Position/Brake/Rear/Help)                      position    $Position(RearBrake_Help)                                  
            project::setValue Result(Position/Brake/Rear/Mount)                     position    $Position(RearBrake_Mount)                                 
            project::setValue Result(Position/Brake/Rear/Shoe)                      position    $Position(RearBrake_Shoe)                                  
            project::setValue Result(Position/BrakeFront)                           position    $Position(FrontBrake_Shoe)                                            
            project::setValue Result(Position/BrakeRear)                            position    $Position(RearBrake_Shoe)                                               
            project::setValue Result(Position/CarrierMountFront)                    position    $Position(CarrierMount_Front)                                
            project::setValue Result(Position/CarrierMountRear)                     position    $Position(CarrierMount_Rear)                                
            project::setValue Result(Position/DerailleurMountFront)                 position    $Position(DerailleurMount_Front)                             
            project::setValue Result(Position/FrontWheel)                           position    $Position(FrontWheel)
            project::setValue Result(Position/HandleBar)                            position    $Position(HandleBar)
            project::setValue Result(Position/LegClearance)                         position    $Position(LegClearance)                                     
            project::setValue Result(Position/RearWheel)                            position    $Position(RearWheel)                                        
            project::setValue Result(Position/Reference_HB)                         position    $Position(Reference_HB)                                       
            project::setValue Result(Position/Reference_SN)                         position    $Position(Reference_SN)                                       
            project::setValue Result(Position/Saddle)                               position    $Position(Saddle)                                           
            project::setValue Result(Position/SaddleNose)                           position    $Position(SaddleNose)                                       
            project::setValue Result(Position/SaddleProposal)                       position    $Position(SaddleProposal)                                   
            project::setValue Result(Position/SeatPostPivot)                        position    $Position(SeatPost_Pivot)                                    
            project::setValue Result(Position/SeatPostSaddle)                       position    $Position(SeatPost_Saddle)                                   
            project::setValue Result(Position/SeatPostSeatTube)                     position    $Position(SeatPost_SeatTube)                                 
            project::setValue Result(Position/SeatTubeGround)                       position    $Position(SeatTube_Ground)                                   
            project::setValue Result(Position/SeatTubeSaddle)                       position    $Position(SeatTube_Saddle)                                   
            project::setValue Result(Position/SeatTubeVirtualTopTube)               position    $Position(SeatTube_VirtualTopTube)                           
            project::setValue Result(Position/SteererGround)                        position    $Position(Steerer_Ground)      
            project::setValue Result(Position/SummarySize)                          position    $BoundingBox(SummarySize)                                         
            project::setValue Result(TubeMiter/DownTube_BB_in/Polygon)              polygon     $TubeMiter(DownTube_BB_in)                                  
            project::setValue Result(TubeMiter/DownTube_BB_out/Polygon)             polygon     $TubeMiter(DownTube_BB_out)                                 
            project::setValue Result(TubeMiter/DownTube_Head/Polygon)               polygon     $TubeMiter(DownTube_Head)                                   
            project::setValue Result(TubeMiter/DownTube_Seat/Polygon)               polygon     $TubeMiter(DownTube_Seat)                                   
            project::setValue Result(TubeMiter/Reference/Polygon)                   polygon     $TubeMiter(Reference)                                       
            project::setValue Result(TubeMiter/SeatStay_01/Polygon)                 polygon     $TubeMiter(SeatStay_01)                                     
            project::setValue Result(TubeMiter/SeatStay_02/Polygon)                 polygon     $TubeMiter(SeatStay_02)             
            project::setValue Result(TubeMiter/SeatTube_BB_in/Polygon)              polygon     $TubeMiter(SeatTube_BB_in)                                  
            project::setValue Result(TubeMiter/SeatTube_BB_out/Polygon)             polygon     $TubeMiter(SeatTube_BB_out)                                
            project::setValue Result(TubeMiter/SeatTube_Down/Polygon)               polygon     $TubeMiter(SeatTube_Down)                                   
            project::setValue Result(TubeMiter/TopTube_Head/Polygon)                polygon     $TubeMiter(TopTube_Head)                                    
            project::setValue Result(TubeMiter/TopTube_Seat/Polygon)                polygon     $TubeMiter(TopTube_Seat)                                    
            project::setValue Result(Tubes/ChainStay/CenterLine)                    value       $CenterLine(ChainStay)                                
            project::setValue Result(Tubes/ChainStay/Direction)                     direction   $Direction(ChainStay)                                 
            project::setValue Result(Tubes/ChainStay/End)                           position    $Position(ChainStay_BottomBracket)                                       
            project::setValue Result(Tubes/ChainStay/Polygon)                       polygon     $Polygon(ChainStay)                                                    
            project::setValue Result(Tubes/ChainStay/Profile/xz)                    value       $Polygon(ChainStay_xz)                                 
            project::setValue Result(Tubes/ChainStay/Profile/xy)                    value       $Polygon(ChainStay_xy)                                 
            project::setValue Result(Tubes/ChainStay/RearMockup/CenterLine)         value       [list $CenterLine(RearMockup)]                    
            project::setValue Result(Tubes/ChainStay/RearMockup/CenterLineUnCut)    value       [list $CenterLine(RearMockup_UnCut)]               
            project::setValue Result(Tubes/ChainStay/RearMockup/CtrLines)           value       [list $CenterLine(RearMockup_CtrLines)]               
            project::setValue Result(Tubes/ChainStay/RearMockup/Polygon)            polygon     $Polygon(ChainStay_RearMockup)                                
            project::setValue Result(Tubes/ChainStay/RearMockup/Start)              position    $Position(ChainStay_RearMockup)                        
            project::setValue Result(Tubes/ChainStay/SeatStay_IS)                   position    $Position(ChainStay_SeatStay_IS)                               
            project::setValue Result(Tubes/ChainStay/Start)                         position    $Position(ChainStay_RearWheel)                                     
            project::setValue Result(Tubes/DownTube/BottleCage/Base)                position    $Position(DownTube_BottleCageBase)                            
            project::setValue Result(Tubes/DownTube/BottleCage/Offset)              position    $Position(DownTube_BottleCageOffset)                          
            project::setValue Result(Tubes/DownTube/BottleCage_Lower/Base)          position    $Position(DownTube_Lower_BottleCageBase)                      
            project::setValue Result(Tubes/DownTube/BottleCage_Lower/Offset)        position    $Position(DownTube_Lower_BottleCageOffset)                    
            project::setValue Result(Tubes/DownTube/CenterLine)                     value       $CenterLine(DownTube)                                                
            project::setValue Result(Tubes/DownTube/Direction)                      direction   $Direction(DownTube)                                     
            project::setValue Result(Tubes/DownTube/End)                            position    $Position(DownTube_End)                                           
            project::setValue Result(Tubes/DownTube/Polygon)                        polygon     $Polygon(DownTube)                                             
            project::setValue Result(Tubes/DownTube/Profile/xy)                     value       $Polygon(DownTube_xy)   ;# Result(Tubes/DownTube/Profile/xy)                                   
            project::setValue Result(Tubes/DownTube/Profile/xz)                     value       $Polygon(DownTube_xz)   ;#$Result(Tubes/DownTube/Profile/xz)                                   
            project::setValue Result(Tubes/DownTube/Start)                          position    $Position(DownTube_Start)                                         
            project::setValue Result(Tubes/ForkBlade/CenterLine)                    value       $CenterLine(ForkBlade)                                
            project::setValue Result(Tubes/ForkBlade/End)                           position    $Position(ForkBlade_End)                                       
            project::setValue Result(Tubes/ForkBlade/Polygon)                       polygon     $Polygon(ForkBlade) 
            project::setValue Result(Tubes/ForkBlade/Start)                         position    $Position(ForkBlade_Start)                                     
            project::setValue Result(Tubes/HeadTube/CenterLine)                     value       $CenterLine(HeadTube)                                   
            project::setValue Result(Tubes/HeadTube/Direction)                      direction   $Direction(HeadTube)                                     
            project::setValue Result(Tubes/HeadTube/End)                            position    $Position(HeadTube_End)                                           
            project::setValue Result(Tubes/HeadTube/Polygon)                        polygon     $Polygon(HeadTube)                                             
            project::setValue Result(Tubes/HeadTube/Profile/xy)                     value       $Polygon(HeadTube_xy)                                   
            project::setValue Result(Tubes/HeadTube/Profile/xz)                     value       $Polygon(HeadTube_xz)                                   
            project::setValue Result(Tubes/HeadTube/Start)                          position    $Position(HeadTube_Start)                                         
            project::setValue Result(Tubes/SeatStay/CenterLine)                     value       $CenterLine(SeatStay)                                   
            project::setValue Result(Tubes/SeatStay/Direction)                      direction   $Direction(SeatStay)                                     
            project::setValue Result(Tubes/SeatStay/End)                            position    $Position(SeatStay_End)                                           
            project::setValue Result(Tubes/SeatStay/Polygon)                        polygon     $Polygon(SeatStay)                                               
            project::setValue Result(Tubes/SeatStay/Profile/xy)                     value       $Polygon(SeatStay_xy)
            project::setValue Result(Tubes/SeatStay/Profile/xz)                     value       $Polygon(SeatStay_xz)
            project::setValue Result(Tubes/SeatStay/Start)                          position    $Position(SeatStay_Start)                                         
            project::setValue Result(Tubes/SeatTube/BottleCage/Base)                position    $Position(SeatTube_BottleCageBase)                     
            project::setValue Result(Tubes/SeatTube/BottleCage/Offset)              position    $Position(SeatTube_BottleCageOffset)                   
            project::setValue Result(Tubes/SeatTube/CenterLine)                     value       $CenterLine(SeatTube)                                   
            project::setValue Result(Tubes/SeatTube/Direction)                      direction   $Direction(SeatTube)                                  
            project::setValue Result(Tubes/SeatTube/End)                            position    $Position(SeatTube_End)
            project::setValue Result(Tubes/SeatTube/EndVirtual)                     position    $Position(SeatTube_VirtualTopTube)                                           
            project::setValue Result(Tubes/SeatTube/Polygon)                        polygon     $Polygon(SeatTube)
            project::setValue Result(Tubes/SeatTube/Profile/xy)                     value       $Polygon(SeatTube_xy)
            project::setValue Result(Tubes/SeatTube/Profile/xz)                     value       $Polygon(SeatTube_xz)
            project::setValue Result(Tubes/SeatTube/Start)                          position    $Position(SeatTube_Start)
            project::setValue Result(Tubes/Steerer/CenterLine)                      value       $CenterLine(Steerer)
            project::setValue Result(Tubes/Steerer/Direction)                       direction   $Direction(HeadTube)
            project::setValue Result(Tubes/Steerer/End)                             position    $Position(Steerer_End)
            project::setValue Result(Tubes/Steerer/Polygon)                         polygon     $Polygon(Steerer)
            project::setValue Result(Tubes/Steerer/Start)                           position    $Position(Steerer_Start)
            project::setValue Result(Tubes/TopTube/CenterLine)                      value       $CenterLine(TopTube)                                    
            project::setValue Result(Tubes/TopTube/Direction)                       direction   $Direction(TopTube)                                     
            project::setValue Result(Tubes/TopTube/End)                             position    $Position(TopTube_End)                                         
            project::setValue Result(Tubes/TopTube/Polygon)                         polygon     $Polygon(TopTube)                                             
            project::setValue Result(Tubes/TopTube/Profile/xy)                      value       $Polygon(TopTube_xy)                                     
            project::setValue Result(Tubes/TopTube/Profile/xz)                      value       $Polygon(TopTube_xz)                                     
            project::setValue Result(Tubes/TopTube/Start)                           position    $Position(TopTube_Start)    
    }

        #
        #
        # --- check Values before compute details
        #
    proc bikeGeometry::check_Values {} {
            variable Geometry
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
            if {$RearWheel(TyreWidthRadius) > $Geometry(RearWheel_Radius)} {
                set project::Component(Wheel/Rear/TyreWidthRadius) [expr $Geometry(RearWheel_Radius) - 5.0]
                set RearWheel(TyreWidthRadius)                     $project::Component(Wheel/Rear/TyreWidthRadius)
                puts "\n                     -> <i> \$project::Component(Wheel/Rear/TyreWidthRadius) ... $project::Component(Wheel/Rear/TyreWidthRadius)"
            }
                #
                #
            if {1 == 2} {
                      #
                      # -- Component(Fender/Rear/Radius) <-> $RearFender(Radius)
                      #       handle values like done in bikeGeometry::get_FenderRear 
                    if {$RearFender(Radius) < $Geometry(RearWheel_Radius)} {
                        set RearFender(Radius)                     [expr $Geometry(RearWheel_Radius) + 5.0]
                        project::setValue Component(Fender/Rear/Radius) value $RearFender(Radius)
                        puts "\n                     -> <i> \$RearFender(Radius) ........... $RearFender(Radius)"
                    }  


                      #
                      # -- Component(Fender/Front/Radius) <-> $RearFender(Radius)
                      #       handle values like done in bikeGeometry::get_FenderFront 
                    if {$FrontFender(Radius) < $Geometry(FrontWheel_Radius)} {
                        set FrontFender(Radius)                     [expr $Geometry(FrontWheel_Radius) + 5.0]
                        project::setValue Component(Fender/Front/Radius) value $FrontFender(Radius)
                        puts "\n                     -> <i> \$FrontFender(Radius) .......... $FrontFender(Radius)"
                    }
            }
              #
            puts ""
              #
    }      
