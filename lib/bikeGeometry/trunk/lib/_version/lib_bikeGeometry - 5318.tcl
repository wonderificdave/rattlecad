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
    proc bikeGeometry::update_Parameter {} {
            
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
                # --- set basePoints Attributes
                #
                # get_basePoints ... replaced ... 0.69 ... 2014.10.20
                #
            create_GeometryRear
            create_GeometryCenter
            create_GeometryFront
                #
            create_RearDropout
            create_RearWheel
            create_FrontWheel
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
            set_to_project
                #
			project::runTime_2_dom
            
    }

    proc bikeGeometry::trace_ForkConfig {} {
            #
        variable customFork
            #
        variable Fork
            #
            # puts "   -> lastConfig ... $customFork(lastConfig)"
            # puts "                 ... $Fork(Rendering)"
            #
            # tk_messageBox -message "<01> ... switch from  $customFork(lastConfig) -> \n $Fork(Rendering)"
            #
            # set lastFile $Fork(CrownFile)
            #
        switch -exact $Fork(Rendering) {
            SteelLugged -
            SteelCustom {
                    if {$customFork(lastConfig) != $Fork(Rendering)} {               
                            # ... noe SteelCustom, last time anything else
                            # ... therefore restore Fork() from customFork()
                            # ... initialy customFork() is empty
                        # tk_messageBox -message "<02> ... switch from  $customFork(lastConfig) -> \n $Fork(Rendering)"
                            #
                            # -- check that  customFork()  has values 
                            #     ... if not fill customFork()  initially with current values
                        if {[array get customFork CrownFile] == {}} {
                                # tk_messageBox -message "... initial SteelCustom Status"
                            catch { set customFork(CrownFile)         $Fork(CrownFile)          }                                  
                            catch { set customFork(DropOutFile)       $Fork(DropOutFile)        }
                            catch { set customFork(CrownBrakeOffset)  $Fork(CrownBrakeOffset)   }
                            catch { set customFork(CrownBrakeAngle)   $Fork(CrownBrakeAngle)    }
                            catch { set customFork(BladeBrakeOffset)  $FrontBrake(Offset)       } 
                        } 
                                #
                        set lastFile $customFork(CrownFile)      
                            #
                            # -- update  Fork()  from  customFork()
                            #
                        catch { set Fork(CrownFile)         $customFork(CrownFile)          }
                        catch { set Fork(DropOutFile)       $customFork(DropOutFile)        }
                        catch { set Fork(CrownBrakeOffset)  $customFork(CrownBrakeOffset)   }
                        catch { set Fork(CrownBrakeAngle)   $customFork(CrownBrakeAngle)    }
                        catch { set Fork(BladeBrakeOffset)  $customFrontBrake(Offset)       }
                            #
                    }
                }
            default {}
        }
            #
        set customFork(lastConfig) $Fork(Rendering)
            #
        # tk_messageBox -message "<03> ... switch from  $customFork(lastConfig) -> \n $Fork(Rendering)\n old: $lastFile \n new: $Fork(CrownFile)"   
            #
            #
        #parray customFork
        #parray Fork
            #
        return
            #
    }
    
    proc bikeGeometry::get_from_project {} {
            
            variable Project
            variable Geometry
            variable Reference
            variable Rendering
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
                # --- get BottomBracket (1)
            set Geometry(BottomBracket_Depth)   $project::Custom(BottomBracket/Depth)
            set BottomBracket(OutsideDiameter)  $project::Lugs(BottomBracket/Diameter/outside)
            set BottomBracket(InsideDiameter)   $project::Lugs(BottomBracket/Diameter/inside)
            set BottomBracket(Width)            $project::Lugs(BottomBracket/Width)
            set BottomBracket(OffsetCS_TopView) $project::Lugs(BottomBracket/ChainStay/Offset_TopView)
                # check-Value-procedure
            if {[expr $BottomBracket(OutsideDiameter) -2.0] < $BottomBracket(InsideDiameter)} {
                set BottomBracket(InsideDiameter)       [expr $BottomBracket(OutsideDiameter) -2.0]
                set project::Lugs(BottomBracket/Diameter/inside) $BottomBracket(InsideDiameter)
            }

                #
                # --- get RearWheel
            set Geometry(RearRim_Diameter)      $project::Component(Wheel/Rear/RimDiameter)
            set Geometry(RearTyre_Height)       $project::Component(Wheel/Rear/TyreHeight)
            set Geometry(ChainStay_Length)      $project::Custom(WheelPosition/Rear)
            set RearWheel(RimHeight)            $project::Component(Wheel/Rear/RimHeight)
            set RearWheel(TyreWidth)            $project::Component(Wheel/Rear/TyreWidth)
            set RearWheel(TyreWidthRadius)      $project::Component(Wheel/Rear/TyreWidthRadius)
            set RearWheel(HubWidth)             $project::Component(Wheel/Rear/HubWidth)
            set RearWheel(FirstSprocket)        $project::Component(Wheel/Rear/FirstSprocket)
            

                #
                # --- get FrontWheel
            set Geometry(FrontRim_Diameter)     $project::Component(Wheel/Front/RimDiameter)
            set Geometry(FrontTyre_Height)      $project::Component(Wheel/Front/TyreHeight)
            set FrontWheel(RimHeight)           $project::Component(Wheel/Front/RimHeight)
            
                #
                # --- get HandleBarMount - Position
            set Geometry(HandleBar_Distance)    $project::Personal(HandleBar_Distance)
            set Geometry(HandleBar_Height)      $project::Personal(HandleBar_Height)
            set HandleBar(PivotAngle)           $project::Component(HandleBar/PivotAngle)
            set HandleBar(File)                 $project::Component(HandleBar/File)

                #
                # --- get Fork -----------------------------
            set Geometry(Fork_Height)           $project::Component(Fork/Height)
            set Geometry(Fork_Rake)             $project::Component(Fork/Rake)
            set Fork(Rendering)                 $project::Rendering(Fork)
            set Fork(BladeRendering)            $project::Rendering(ForkBlade)
            set Fork(BladeWidth)                $project::Component(Fork/Blade/Width)
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
            set Geometry(Stem_Angle)            $project::Component(Stem/Angle)
            set Geometry(Stem_Length)           $project::Component(Stem/Length)

                #
                # --- get HeadTube -------------------------
            # set HeadTube(ForkRake)              $Fork(Rake)
            # set HeadTube(ForkHeight)            $Fork(Height)
            # set HeadTube(ForkRake)              $project::Component(Fork/Rake)
            # set HeadTube(ForkHeight)            $project::Component(Fork/Height)
            set HeadTube(Diameter)              $project::FrameTubes(HeadTube/Diameter)
            set HeadTube(Length)                $project::FrameTubes(HeadTube/Length)
            set Geometry(HeadTube_Angle)        $project::Custom(HeadTube/Angle)

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
            set Geometry(TopTube_Angle)         $project::Custom(TopTube/Angle)

                #
                # --- get ChainStay ------------------------
            set ChainStay(HeigthBB)             $project::FrameTubes(ChainStay/HeightBB)
            set ChainStay(DiameterSS)           $project::FrameTubes(ChainStay/DiameterSS)
            set ChainStay(Height)               $project::FrameTubes(ChainStay/Height)
            set ChainStay(TaperLength)          $project::FrameTubes(ChainStay/TaperLength)
            set ChainStay(WidthBB)              $project::FrameTubes(ChainStay/WidthBB)
            set ChainStay(profile_y00)          $project::FrameTubes(ChainStay/Profile/width_00)
            set ChainStay(profile_x01)          $project::FrameTubes(ChainStay/Profile/length_01)
            set ChainStay(profile_y01)          $project::FrameTubes(ChainStay/Profile/width_01)
            set ChainStay(profile_x02)          $project::FrameTubes(ChainStay/Profile/length_02)
            set ChainStay(profile_y02)          $project::FrameTubes(ChainStay/Profile/width_02)
            set ChainStay(profile_x03)          $project::FrameTubes(ChainStay/Profile/length_03)
            set ChainStay(profile_y03)          $project::FrameTubes(ChainStay/Profile/width_03)
            set ChainStay(completeLength)       $project::FrameTubes(ChainStay/Profile/completeLength) 
            set ChainStay(cuttingLength)        $project::FrameTubes(ChainStay/Profile/cuttingLength) 
            set ChainStay(cuttingLeft)          $project::FrameTubes(ChainStay/Profile/cuttingLeft)
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
            set SeatStay(SeatTubeMiterDiameter) $project::Lugs(SeatTube/SeatStay/MiterDiameter)

                #
                # --- get RearDropout ----------------------
            # set RearDropout(Direction)        $project::Lugs(RearDropOut/Direction)
            set RearDropout(RotationOffset)     $project::Lugs(RearDropOut/RotationOffset)
            set RearDropout(OffsetCS)           $project::Lugs(RearDropOut/ChainStay/Offset)
            set RearDropout(OffsetCSPerp)       $project::Lugs(RearDropOut/ChainStay/OffsetPerp)
            set RearDropout(OffsetSS)           $project::Lugs(RearDropOut/SeatStay/Offset)
            set RearDropout(OffsetSSPerp)       $project::Lugs(RearDropOut/SeatStay/OffsetPerp)
            set RearDropout(Derailleur_x)       $project::Lugs(RearDropOut/Derailleur/x)
            set RearDropout(Derailleur_y)       $project::Lugs(RearDropOut/Derailleur/y)
            set RearDropout(OffsetCS_TopView)   $project::Lugs(RearDropOut/ChainStay/Offset_TopView)
            set RearDropout(File)               $project::Lugs(RearDropOut/File)
            

                #
                # --- get Lugs -----------------------------
            set Lugs(BottomBracket_ChainStay_Angle)         $project::Lugs(BottomBracket/ChainStay/Angle/value) 
            set Lugs(BottomBracket_ChainStay_Tolerance)     $project::Lugs(BottomBracket/ChainStay/Angle/plus_minus) 
            set Lugs(BottomBracket_DownTube_Angle)          $project::Lugs(BottomBracket/DownTube/Angle/value) 
            set Lugs(BottomBracket_DownTube_Tolerance)      $project::Lugs(BottomBracket/DownTube/Angle/plus_minus) 
            set Lugs(HeadLug_Bottom_Angle)                  $project::Lugs(HeadTube/DownTube/Angle/value) 
            set Lugs(HeadLug_Bottom_Tolerance)              $project::Lugs(HeadTube/DownTube/Angle/plus_minus) 
            set Lugs(HeadLug_Top_Angle)                     $project::Lugs(HeadTube/TopTube/Angle/value) 
            set Lugs(HeadLug_Top_Tolerance)                 $project::Lugs(HeadTube/TopTube/Angle/plus_minus) 
            set Lugs(RearDropOut_Angle)                     $project::Lugs(RearDropOut/Angle/value) 
            set Lugs(RearDropOut_Tolerance)                 $project::Lugs(RearDropOut/Angle/plus_minus) 
            set Lugs(SeatLug_SeatStay_Angle)                $project::Lugs(SeatTube/SeatStay/Angle/value) 
            set Lugs(SeatLug_SeatStay_Tolerance)            $project::Lugs(SeatTube/SeatStay/Angle/plus_minus) 
            set Lugs(SeatLug_TopTube_Angle)                 $project::Lugs(SeatTube/TopTube/Angle/value) 
            set Lugs(SeatLug_TopTube_Tolerance)             $project::Lugs(SeatTube/TopTube/Angle/plus_minus) 
           
                
                #
                # --- get Saddle ---------------------------
            set Geometry(Saddle_Distance)       $project::Personal(Saddle_Distance)
            set Geometry(Saddle_Height)         $project::Personal(Saddle_Height)
            set Saddle(SaddleHeight)            $project::Component(Saddle/Height)
            set Saddle(Length)                  $project::Component(Saddle/Length)
            set Saddle(NoseLength)              $project::Component(Saddle/LengthNose)
            set Saddle(File)                    $project::Component(Saddle/File) 
            set Saddle(Offset_x)                $project::Rendering(Saddle/Offset_X) 
            set Saddle(Offset_y)                $project::Rendering(Saddle/Offset_Y)
                # check-Value-procedure
            if {$Saddle(SaddleHeight) < 0} {
                set Saddle(SaddleHeight)  0
            }

                #
                # --- get SaddleMount - Position
            set SeatPost(Diameter)              $project::Component(SeatPost/Diameter)
            set SeatPost(Setback)               $project::Component(SeatPost/Setback)
            set SeatPost(PivotOffset)           $project::Component(SeatPost/PivotOffset)

                #
                # --- get LegClearance - Position
            set Geometry(Inseam_Length)         $project::Personal(InnerLeg_Length)

                #
                # --- get HeadSet --------------------------
            set HeadSet(Diameter)               $project::Component(HeadSet/Diameter)
            set HeadSet(Height_Top)             $project::Component(HeadSet/Height/Top)
            set HeadSet(Height_Bottom)          $project::Component(HeadSet/Height/Bottom)
            set HeadSet(ShimDiameter)           36

                #
                # --- get Front/Rear Brake PadLever --------------
            set FrontBrake(LeverLength)         $project::Component(Brake/Front/LeverLength)
            set FrontBrake(Offset)              $project::Component(Brake/Front/Offset)
            set FrontBrake(File)                $project::Component(Brake/Front/File)
            set RearBrake(LeverLength)          $project::Component(Brake/Rear/LeverLength)
            set RearBrake(Offset)               $project::Component(Brake/Rear/Offset)
            set RearBrake(File)                 $project::Component(Brake/Rear/File)

                #
                # --- get BottleCage -----------------------------
            set BottleCage(SeatTube)            $project::Component(BottleCage/SeatTube/OffsetBB)
            set BottleCage(DownTube)            $project::Component(BottleCage/DownTube/OffsetBB)
            set BottleCage(DownTube_Lower)      $project::Component(BottleCage/DownTube_Lower/OffsetBB)
            set BottleCage(FileSeatTube)        $project::Component(BottleCage/SeatTube/File)
            set BottleCage(FileDownTube)        $project::Component(BottleCage/DownTube/File)
            set BottleCage(FileDownTube_Lower)  $project::Component(BottleCage/DownTube_Lower/File)
            
                # --- get CrankSet  -----------------------------
            set CrankSet(ArmWidth)              $project::Component(CrankSet/ArmWidth)
            set CrankSet(ChainLine)             $project::Component(CrankSet/ChainLine)
            set CrankSet(ChainRings)            $project::Component(CrankSet/ChainRings)
            set CrankSet(Length)                $project::Component(CrankSet/Length)
            set CrankSet(PedalEye)              $project::Component(CrankSet/PedalEye)
            set CrankSet(Q-Factor)              $project::Component(CrankSet/Q-Factor)
            set CrankSet(File)                  $project::Component(CrankSet/File)
            
                #
                # --- get FrontDerailleur  ----------------------
            set FrontDerailleur(Distance)       $project::Component(Derailleur/Front/Distance)
            set FrontDerailleur(Offset)         $project::Component(Derailleur/Front/Offset)
            set FrontDerailleur(File)           $project::Component(Derailleur/Front/File)


                #
                # --- get RearDerailleur  -----------------------
            set RearDerailleur(Pulley_teeth)    $project::Component(Derailleur/Rear/Pulley/teeth)  
            set RearDerailleur(Pulley_x)        $project::Component(Derailleur/Rear/Pulley/x)      
            set RearDerailleur(Pulley_y)        $project::Component(Derailleur/Rear/Pulley/y)
            set RearDerailleur(File)            $project::Component(Derailleur/Rear/File)
            

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
            set FrontCarrier(x)                 $project::Component(Carrier/Front/x)
            set FrontCarrier(y)                 $project::Component(Carrier/Front/y)
            set FrontCarrier(File)              $project::Component(Carrier/Front/File)
            set RearCarrier(x)                  $project::Component(Carrier/Rear/x)
            set RearCarrier(y)                  $project::Component(Carrier/Rear/y)
            set RearCarrier(File)               $project::Component(Carrier/Rear/File)
            
                #
                # --- get Rendering  ----------------------------
            set Rendering(FrontBrake)           $project::Rendering(Brake/Front)    
            set Rendering(RearBrake)            $project::Rendering(Brake/Rear)    
            set Rendering(BottleCage_ST)        $project::Rendering(BottleCage/SeatTube)
            set Rendering(BottleCage_DT)        $project::Rendering(BottleCage/DownTube)
            set Rendering(BottleCage_DT_L)      $project::Rendering(BottleCage/DownTube_Lower)
            set Rendering(FrontFender)          $project::Rendering(Fender/Front)
            set Rendering(RearFender)           $project::Rendering(Fender/Rear)
            set Rendering(ChainStay)            $project::Rendering(ChainStay)
            set Rendering(Fork)                 $project::Rendering(Fork)
            set Rendering(ForkBlade)            $project::Rendering(ForkBlade)
            set Rendering(ForkDropout)          $project::Rendering(ForkDropOut)
            set Rendering(RearDropout)          $project::Rendering(RearDropOut)
            set Rendering(RearDropoutOrient)    $project::Lugs(RearDropOut/Direction) ; # prev. RearDropOut/Direction
                        
                #
            set RearMockup(CassetteClearance)   $project::Rendering(RearMockup/CassetteClearance)
            set RearMockup(ChainWheelClearance) $project::Rendering(RearMockup/ChainWheelClearance)
            set RearMockup(CrankClearance)      $project::Rendering(RearMockup/CrankClearance)
            set RearMockup(DiscClearance)       $project::Rendering(RearMockup/DiscClearance)
            set RearMockup(DiscDiameter)        $project::Rendering(RearMockup/DiscDiameter)
            set RearMockup(DiscOffset)          $project::Rendering(RearMockup/DiscOffset)
            set RearMockup(DiscWidth)           $project::Rendering(RearMockup/DiscWidth)
            set RearMockup(TyreClearance)       $project::Rendering(RearMockup/TyreClearance)
            
            
                #
                # --- get others  -------------------------------
            set Logo(File)                      $project::Component(Logo/File)                    
            set RearHub(File)                   {hub/rattleCAD_rear.svg}
            # set RearHub(File)                 $project::Component(Hub/File)      


                #
                # --- get Reference  ----------------------------
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
            variable Reference

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
            variable RearDropout
            variable Lugs

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
            variable BoundingBox
            
            variable Result
    

    
                # -- Custom Values
            
            project::setValue Custom(WheelPosition/Rear)                            value       $Geometry(ChainStay_Length)
                
                
                # -- Result Values
            
            project::setValue Result(Angle/BottomBracket/ChainStay)                 value       $Result(Angle_BottomBracketChainStay)
            project::setValue Result(Angle/BottomBracket/DownTube)                  value       $Result(Angle_BottomBracketDownTube)
            project::setValue Result(Angle/HeadTube/DownTube)                       value       $Result(Angle_HeadTubeDownTube)
            project::setValue Result(Angle/HeadTube/TopTube)                        value       $Result(Angle_HeadTubeTopTube)
            project::setValue Result(Angle/SeatStay/ChainStay)                      value       $Result(Angle_SeatStayChainStay)
            project::setValue Result(Angle/SeatTube/Direction)                      value       $Geometry(SeatTube_Angle)
            project::setValue Result(Angle/SeatTube/SeatStay)                       value       $Result(Angle_SeatTubeSeatStay)
            project::setValue Result(Angle/SeatTube/TopTube)                        value       $Result(Angle_SeatTubeTopTube)
            # project::setValue Result(Angle/BottomBracket/ChainStay)                 value       $Result(Angle/BottomBracket/ChainStay)
            # project::setValue Result(Angle/BottomBracket/DownTube)                  value       $Result(Angle/BottomBracket/DownTube)
            # project::setValue Result(Angle/HeadTube/DownTube)                       value       $Result(Angle/HeadTube/DownTube)
            # project::setValue Result(Angle/HeadTube/TopTube)                        value       $Result(Angle_HeadTubeTopTube)
            # project::setValue Result(Angle/SeatStay/ChainStay)                      value       $Result(Angle/SeatStay/ChainStay)
            # project::setValue Result(Angle/SeatTube/Direction)                      value       $Result(Angle/SeatTube/Direction)
            # project::setValue Result(Angle/SeatTube/SeatStay)                       value       $Result(Angle/SeatTube/SeatStay)
            # project::setValue Result(Angle/SeatTube/TopTube)                        value       $Result(Angle/SeatTube/TopTube)
            
            
            project::setValue Result(Length/BottomBracket/Height)                   value       $Geometry(BottomBracket_Height)
            # project::setValue Result(Length/BottomBracket/Height)                   value       $Result(Length/BottomBracket/Height)
            project::setValue Result(Length/FrontWheel/Diameter)                    value       $FrontWheel(Diameter)
            # project::setValue Result(Length/FrontWheel/Diameter)                    value       $Result(Length/FrontWheel/Diameter)
            project::setValue Result(Length/FrontWheel/Radius)                      value       $Geometry(FrontWheel_Radius)
            # project::setValue Result(Length/FrontWheel/Radius)                      value       $Result(Length/FrontWheel/Radius)
            project::setValue Result(Length/FrontWheel/diagonal)                    value       $Geometry(FrontWheel_xy)
            # project::setValue Result(Length/FrontWheel/diagonal)                    value       $Result(Length/FrontWheel/diagonal)
            project::setValue Result(Length/FrontWheel/horizontal)                  value       $Geometry(FrontWheel_x)
            # project::setValue Result(Length/FrontWheel/horizontal)                  value       $Result(Length/FrontWheel/horizontal)
            project::setValue Result(Length/HeadTube/ReachLength)                   value       $Geometry(ReachLengthResult)
            # project::setValue Result(Length/HeadTube/ReachLength)                   value       $Result(Length/HeadTube/ReachLength)
            project::setValue Result(Length/HeadTube/StackHeight)                   value       $Geometry(StackHeightResult)
            # project::setValue Result(Length/HeadTube/StackHeight)                   value       $Result(Length/HeadTube/StackHeight)
            project::setValue Result(Length/Personal/SaddleNose_HB)                 value       $Geometry(SaddleNose_HB)
            # project::setValue Result(Length/Personal/SaddleNose_HB)                 value       $Result(Length/Personal/SaddleNose_HB)
            project::setValue Result(Length/RearWheel/Diameter)                     value       $RearWheel(Diameter)                                  
            # project::setValue Result(Length/RearWheel/Diameter)                     value       $Result(Length/RearWheel/Diameter)                                  
            project::setValue Result(Length/RearWheel/Radius)                       value       $Geometry(RearWheel_Radius)                                    
            # project::setValue Result(Length/RearWheel/Radius)                       value       $Result(Length/RearWheel/Radius)                                    
            project::setValue Result(Length/RearWheel/TyreShoulder)                 value       $RearWheel(TyreShoulder)                             
            # project::setValue Result(Length/RearWheel/TyreShoulder)                 value       $Result(Length/RearWheel/TyreShoulder)                             
            project::setValue Result(Length/RearWheel/horizontal)                   value       $Geometry(RearWheel_x)      ;#$Result(Length/RearWheel/horizontal) 
            project::setValue Result(Length/Reference/HandleBar_BB)                 value       $Reference(HandleBar_BB)    ;#Result(Length/Reference/HandleBar_BB) 
            project::setValue Result(Length/Reference/HandleBar_FW)                 value       $Reference(HandleBar_FW)    ;#Result(Length/Reference/HandleBar_FW) 
            project::setValue Result(Length/Reference/Heigth_SN_HB)                 value       $Reference(SaddleNose_HB_y) ;#Result(Length/Reference/Heigth_SN_HB)
            project::setValue Result(Length/Reference/SaddleNose_BB)                value       $Reference(SaddleNose_BB)   ;#Result(Length/Reference/SaddleNose_BB)
            project::setValue Result(Length/Reference/SaddleNose_HB)                value       $Reference(SaddleNose_HB)   ;#Result(Length/Reference/SaddleNose_HB)
            
            project::setValue Result(Length/Saddle/Offset_BB)                       value       $Result(Length/Saddle/Offset_BB)                                   
            project::setValue Result(Length/Saddle/Offset_BB_Nose)                  value       $Geometry(SaddleNose_BB_x)                              
            # project::setValue Result(Length/Saddle/Offset_BB_Nose)                  value       $Result(Length/Saddle/Offset_BB_Nose)                              
            project::setValue Result(Length/Saddle/Offset_BB_ST)                    value       $Geometry(Saddle_Offset_BB_ST)                                
            # project::setValue Result(Length/Saddle/Offset_BB_ST)                    value       $Result(Length/Saddle/Offset_BB_ST)                                
            project::setValue Result(Length/Saddle/Offset_HB)                       value       $Geometry(Saddle_HB_y)                                   
            # project::setValue Result(Length/Saddle/Offset_HB)                       value       $Result(Length/Saddle/Offset_HB)                                   
            project::setValue Result(Length/Saddle/SeatTube_BB)                     value       $Geometry(Saddle_BB)                                 
            # project::setValue Result(Length/Saddle/SeatTube_BB)                     value       $Result(Length/Saddle/SeatTube_BB)                                 
            project::setValue Result(Length/SeatTube/TubeHeight)                    value       $Result(Length/SeatTube/TubeHeight)                                
            project::setValue Result(Length/SeatTube/TubeLength)                    value       $Result(Length/SeatTube/TubeLength)                                
            project::setValue Result(Length/SeatTube/VirtualLength)                 value       $Geometry(SeatTubeVirtual)                            
            # project::setValue Result(Length/SeatTube/VirtualLength)                 value       $Result(Length/SeatTube/VirtualLength)                             
            project::setValue Result(Length/TopTube/VirtualLength)                  value       $Geometry(TopTubeVirtual)                              
            # project::setValue Result(Length/TopTube/VirtualLength)                  value       $Geometry(TopTubeVirtual)                              
            # project::setValue Result(Length/TopTube/VirtualLength)                  value       $Result(Length/TopTube/VirtualLength)                              
            project::setValue Result(Tubes/ChainStay/CenterLine)                    value       $ChainStay(CenterLine)                                
            # project::setValue Result(Tubes/ChainStay/CenterLine)                    value       $Result(Tubes/ChainStay/CenterLine)                                
            project::setValue Result(Tubes/ChainStay/Profile/xy)                    value       $ChainStay(Polygon_zx)                                 
            # project::setValue Result(Tubes/ChainStay/Profile/xz)                    value       $Result(Tubes/ChainStay/Profile/xz)                                 
            project::setValue Result(Tubes/ChainStay/RearMockup/CenterLine)         value       [list $RearMockup(CenterLine)]                    
            project::setValue Result(Tubes/ChainStay/RearMockup/CenterLineUnCut)    value       [list $RearMockup(CenterLineUnCut)]               
            project::setValue Result(Tubes/ChainStay/RearMockup/CtrLines)           value       [list $RearMockup(CtrLines)]               
            # project::setValue Result(Tubes/ChainStay/RearMockup/CenterLine)         value       $Result(Tubes/ChainStay/RearMockup/CenterLine)                     
            # project::setValue Result(Tubes/ChainStay/RearMockup/CenterLineUnCut)    value       $Result(Tubes/ChainStay/RearMockup/CenterLineUnCut)                
            # project::setValue Result(Tubes/ChainStay/RearMockup/CtrLines)           value       $Result(Tubes/ChainStay/RearMockup/CtrLines)                       
            project::setValue Result(Tubes/ChainStay/RearMockup/Start)              value       $Result(Tubes/ChainStay/RearMockup/Start)                          
            project::setValue Result(Tubes/DownTube/CenterLine)                     value       $Result(Tubes/DownTube/CenterLine)                                                
            project::setValue Result(Tubes/DownTube/Profile/xy)                     value       $Result(Tubes/DownTube/Profile/xy)                                   
            project::setValue Result(Tubes/DownTube/Profile/xz)                     value       $Result(Tubes/DownTube/Profile/xz)                                   
            project::setValue Result(Tubes/ForkBlade/CenterLine)                    value       $Result(Tubes/ForkBlade/CenterLine)                                
            project::setValue Result(Tubes/HeadTube/CenterLine)                     value       $Result(Tubes/HeadTube/CenterLine)                                   
            project::setValue Result(Tubes/HeadTube/Profile/xy)                     value       $Result(Tubes/HeadTube/Profile/xy)                                   
            project::setValue Result(Tubes/HeadTube/Profile/xz)                     value       $Result(Tubes/HeadTube/Profile/xz)                                   
            project::setValue Result(Tubes/SeatStay/CenterLine)                     value       $Result(Tubes/SeatStay/CenterLine)                                   
            project::setValue Result(Tubes/SeatStay/Profile/xy)                     value       $Result(Tubes/SeatStay/Profile/xy)                                   
            project::setValue Result(Tubes/SeatStay/Profile/xz)                     value       $Result(Tubes/SeatStay/Profile/xz)                                   
            project::setValue Result(Tubes/SeatTube/CenterLine)                     value       $Result(Tubes/SeatTube/CenterLine)                                   
            project::setValue Result(Tubes/SeatTube/Profile/xy)                     value       $Result(Tubes/SeatTube/Profile/xy)
            project::setValue Result(Tubes/SeatTube/Profile/xz)                     value       $Result(Tubes/SeatTube/Profile/xz)
            project::setValue Result(Tubes/Steerer/CenterLine)                      value       $Steerer(CenterLine)
            # project::setValue Result(Tubes/Steerer/CenterLine)                      value       $Result(Tubes/Steerer/CenterLine)
            project::setValue Result(Tubes/TopTube/CenterLine)                      value       $Result(Tubes/TopTube/CenterLine)                                    
            project::setValue Result(Tubes/TopTube/Profile/xy)                      value       $Result(Tubes/TopTube/Profile/xy)                                     
            project::setValue Result(Tubes/TopTube/Profile/xz)                      value       $Result(Tubes/TopTube/Profile/xz)                                     
                #
                #
            project::setValue Result(Lugs/Dropout/Front/Direction)                  direction   $Fork(DropoutDirection)                              
            # project::setValue Result(Lugs/Dropout/Front/Direction)                  direction   $Result(Lugs/Dropout/Front/Direction)                              
            project::setValue Result(Lugs/Dropout/Rear/Direction)                   direction   $RearDropout(Direction)                              
            project::setValue Result(Lugs/ForkCrown/Direction)                      direction   $Fork(CrownDirection)                                  
            # project::setValue Result(Lugs/ForkCrown/Direction)                      direction   $Result(Lugs/ForkCrown/Direction)                                  
            project::setValue Result(Tubes/ChainStay/Direction)                     direction   $ChainStay(Direction)                                 
            # project::setValue Result(Tubes/ChainStay/Direction)                     direction   $Result(Tubes/ChainStay/Direction)                                 
            project::setValue Result(Tubes/DownTube/Direction)                      direction   $DownTube(Direction)                                     
            # project::setValue Result(Tubes/DownTube/Direction)                      direction   $Result(Tubes/DownTube/Direction)                                     
            project::setValue Result(Tubes/HeadTube/Direction)                      direction   $HeadTube(Direction)                                     
            # project::setValue Result(Tubes/HeadTube/Direction)                      direction   $Result(Tubes/HeadTube/Direction)                                     
            project::setValue Result(Tubes/SeatStay/Direction)                      direction   $SeatStay(Direction)                                     
            # project::setValue Result(Tubes/SeatStay/Direction)                      direction   $Result(Tubes/SeatStay/Direction)                                     
            project::setValue Result(Tubes/SeatTube/Direction)                      direction   $SeatTube(Direction)                                  
            # project::setValue Result(Tubes/SeatTube/Direction)                      direction   $Result(Tubes/SeatTube/Direction)                                  
            project::setValue Result(Tubes/Steerer/Direction)                       direction   $HeadTube(Direction)
            # project::setValue Result(Tubes/Steerer/Direction)                       direction   $Result(Tubes/Steerer/Direction)
            project::setValue Result(Tubes/TopTube/Direction)                       direction   $TopTube(Direction)                                     
            # project::setValue Result(Tubes/TopTube/Direction)                       direction   $Result(Tubes/TopTube/Direction)                                     
                #
                #
            project::setValue Result(Components/Fender/Front/Polygon)               polygon     $FrontFender(Polygon)
            # project::setValue Result(Components/Fender/Front/Polygon)               polygon     $Result(Components/Fender/Front/Polygon)
            project::setValue Result(Components/Fender/Rear/Polygon)                polygon     $RearFender(Polygon)
            # project::setValue Result(Components/Fender/Rear/Polygon)                polygon     $Result(Components/Fender/Rear/Polygon)
            project::setValue Result(Components/HeadSet/Bottom/Polygon)             polygon     $HeadSet(PolygonBottom)
            # project::setValue Result(Components/HeadSet/Bottom/Polygon)             polygon     $Result(Components/HeadSet/Bottom/Polygon)
            project::setValue Result(Components/HeadSet/Top/Polygon)                polygon     $HeadSet(PolygonTop)
            # project::setValue Result(Components/HeadSet/Top/Polygon)                polygon     $Result(Components/HeadSet/Top/Polygon)
            project::setValue Result(Components/SeatPost/Polygon)                   polygon     $SeatPost(Polygon)
            # project::setValue Result(Components/SeatPost/Polygon)                   polygon     $Result(Components/SeatPost/Polygon)
            project::setValue Result(Components/Stem/Polygon)                       polygon     $Stem(Polygon)
            # project::setValue Result(Components/Stem/Polygon)                       polygon     $Result(Components/Stem/Polygon)
            project::setValue Result(TubeMiter/DownTube_BB_in/Polygon)              polygon     $TubeMiter(DownTube_BB_in)                                  
            # project::setValue Result(TubeMiter/DownTube_BB_in/Polygon)              polygon     $Result(TubeMiter/DownTube_BB_in/Polygon)                                  
            project::setValue Result(TubeMiter/DownTube_BB_out/Polygon)             polygon     $TubeMiter(DownTube_BB_out)                                 
            # project::setValue Result(TubeMiter/DownTube_BB_out/Polygon)             polygon     $Result(TubeMiter/DownTube_BB_out/Polygon)                                 
            project::setValue Result(TubeMiter/DownTube_Head/Polygon)               polygon     $TubeMiter(DownTube_Head)                                   
            # project::setValue Result(TubeMiter/DownTube_Head/Polygon)               polygon     $Result(TubeMiter/DownTube_Head/Polygon)                                   
            project::setValue Result(TubeMiter/DownTube_Seat/Polygon)               polygon     $TubeMiter(DownTube_Seat)                                   
            # project::setValue Result(TubeMiter/DownTube_Seat/Polygon)               polygon     $Result(TubeMiter/DownTube_Seat/Polygon)                                   
            project::setValue Result(TubeMiter/Reference/Polygon)                   polygon     $TubeMiter(Reference)                                       
            # project::setValue Result(TubeMiter/Reference/Polygon)                   polygon     $Result(TubeMiter/Reference/Polygon)                                       
            project::setValue Result(TubeMiter/SeatStay_01/Polygon)                 polygon     $TubeMiter(SeatStay_01)                                     
            # project::setValue Result(TubeMiter/SeatStay_01/Polygon)                 polygon     $Result(TubeMiter/SeatStay_01/Polygon)                                     
            project::setValue Result(TubeMiter/SeatStay_02/Polygon)                 polygon     $TubeMiter(SeatStay_02)             
            # project::setValue Result(TubeMiter/SeatStay_02/Polygon)                 polygon     $Result(TubeMiter/SeatStay_02/Polygon)                                     
            project::setValue Result(TubeMiter/SeatTube_BB_in/Polygon)              polygon     $TubeMiter(SeatTube_BB_in)                                  
            # project::setValue Result(TubeMiter/SeatTube_BB_in/Polygon)              polygon     $Result(TubeMiter/SeatTube_BB_in/Polygon)                                  
            project::setValue Result(TubeMiter/SeatTube_BB_out/Polygon)             polygon     $TubeMiter(SeatTube_BB_out)                                
            # project::setValue Result(TubeMiter/SeatTube_BB_out/Polygon)             polygon     $Result(TubeMiter/SeatTube_BB_out/Polygon)                                 
            project::setValue Result(TubeMiter/SeatTube_Down/Polygon)               polygon     $TubeMiter(SeatTube_Down)                                   
            # project::setValue Result(TubeMiter/SeatTube_Down/Polygon)               polygon     $Result(TubeMiter/SeatTube_Down/Polygon)                                   
            project::setValue Result(TubeMiter/TopTube_Head/Polygon)                polygon     $TubeMiter(TopTube_Head)                                    
            # project::setValue Result(TubeMiter/TopTube_Head/Polygon)                polygon     $Result(TubeMiter/TopTube_Head/Polygon)                                    
            project::setValue Result(TubeMiter/TopTube_Seat/Polygon)                polygon     $TubeMiter(TopTube_Seat)                                    
            # project::setValue Result(TubeMiter/TopTube_Seat/Polygon)                polygon     $Result(TubeMiter/TopTube_Seat/Polygon)                                    
            project::setValue Result(Tubes/ChainStay/Polygon)                       polygon     $ChainStay(Polygon)                                                    
            # project::setValue Result(Tubes/ChainStay/Polygon)                       polygon     $Result(Tubes/ChainStay/Polygon)                                                    
            project::setValue Result(Tubes/ChainStay/RearMockup/Polygon)            polygon     $ChainStay(Polygon_RearMockup)                                
            # project::setValue Result(Tubes/ChainStay/RearMockup/Polygon)            polygon     $Result(Tubes/ChainStay/RearMockup/Polygon)                                
            project::setValue Result(Tubes/DownTube/Polygon)                        polygon     $DownTube(Polygon)                                             
            # project::setValue Result(Tubes/DownTube/Polygon)                        polygon     $Result(Tubes/DownTube/Polygon)                                             
            project::setValue Result(Tubes/ForkBlade/Polygon)                       polygon     $ForkBlade(Polygon)                                           
            # project::setValue Result(Tubes/ForkBlade/Polygon)                       polygon     $Result(Tubes/ForkBlade/Polygon)                                                
            project::setValue Result(Tubes/HeadTube/Polygon)                        polygon     $HeadTube(Polygon)                                             
            # project::setValue Result(Tubes/HeadTube/Polygon)                        polygon     $Result(Tubes/HeadTube/Polygon)                                             
            project::setValue Result(Tubes/SeatStay/Polygon)                        polygon     $SeatStay(Polygon)                                               
            # project::setValue Result(Tubes/SeatStay/Polygon)                        polygon     $Result(Tubes/SeatStay/Polygon)                                               
            project::setValue Result(Tubes/SeatTube/Polygon)                        polygon     $SeatTube(Polygon)
            # project::setValue Result(Tubes/SeatTube/Polygon)                        polygon     $Result(Tubes/SeatTube/Polygon)
            project::setValue Result(Tubes/Steerer/Polygon)                         polygon     $Steerer(Polygon)
            # project::setValue Result(Tubes/Steerer/Polygon)                         polygon     $Result(Tubes/Steerer/Polygon)                                               
            project::setValue Result(Tubes/TopTube/Polygon)                         polygon     $TopTube(Polygon)                                             
            # project::setValue Result(Tubes/TopTube/Polygon)                         polygon     $Result(Tubes/TopTube/Polygon)                                             
                #
                #
            project::setValue Result(Lugs/Dropout/Front/Position)                   position    $Fork(DropoutPosition)
            project::setValue Result(Lugs/Dropout/Rear/Derailleur)                  position    $RearDropout(DerailleurPosition)                              
            # project::setValue Result(Lugs/Dropout/Rear/Derailleur)                  position    $Lugs(RearDropout_Derailleur)                              
            # project::setValue Result(Lugs/Dropout/Rear/Derailleur)                  position    $Result(Lugs/Dropout/Rear/Derailleur)                              
            project::setValue Result(Lugs/Dropout/Rear/Position)                    position    $RearDropout(Position)                                
            # project::setValue Result(Lugs/Dropout/Rear/Position)                    position    $Result(Lugs/Dropout/Rear/Position)                                
            project::setValue Result(Lugs/ForkCrown/Position)                       position    $Steerer(Fork)
            project::setValue Result(Position/BottomBracketGround)                  position    $Geometry(BottomBracket_Ground)                              
            # project::setValue Result(Position/BottomBracketGround)                  position    $Result(Position/BottomBracketGround)                              
            project::setValue Result(Position/Brake/Front/Definition)               position    $FrontBrake(Definition)                           
            project::setValue Result(Position/Brake/Front/Help)                     position    $FrontBrake(Help)                                 
            project::setValue Result(Position/Brake/Front/Mount)                    position    $FrontBrake(Mount)                                
            project::setValue Result(Position/Brake/Front/Shoe)                     position    $FrontBrake(Shoe)                                 
            # project::setValue Result(Position/Brake/Front/Definition)               position    $Result(Position/Brake/Front/Definition)                           
            # project::setValue Result(Position/Brake/Front/Help)                     position    $Result(Position/Brake/Front/Help)                                 
            # project::setValue Result(Position/Brake/Front/Mount)                    position    $Result(Position/Brake/Front/Mount)                                
            # project::setValue Result(Position/Brake/Front/Shoe)                     position    $Result(Position/Brake/Front/Shoe)                                 
            project::setValue Result(Position/Brake/Rear/Definition)                position    $RearBrake(Definition)                            
            project::setValue Result(Position/Brake/Rear/Help)                      position    $RearBrake(Help)                                  
            project::setValue Result(Position/Brake/Rear/Mount)                     position    $RearBrake(Mount)                                 
            project::setValue Result(Position/Brake/Rear/Shoe)                      position    $RearBrake(Shoe)                                  
            # project::setValue Result(Position/Brake/Rear/Definition)                position    $Result(Position/Brake/Rear/Definition)                            
            # project::setValue Result(Position/Brake/Rear/Help)                      position    $Result(Position/Brake/Rear/Help)                                  
            # project::setValue Result(Position/Brake/Rear/Mount)                     position    $Result(Position/Brake/Rear/Mount)                                 
            # project::setValue Result(Position/Brake/Rear/Shoe)                      position    $Result(Position/Brake/Rear/Shoe)                                  
            project::setValue Result(Position/BrakeFront)                           position    $FrontBrake(Shoe)                                            
            # project::setValue Result(Position/BrakeFront)                           position    $Result(Position/BrakeFront)                                            
            project::setValue Result(Position/BrakeRear)                            position    $RearBrake(Shoe)                                               
            # project::setValue Result(Position/BrakeRear)                            position    $Result(Position/BrakeRear)                                               
            project::setValue Result(Position/CarrierMountFront)                    position    $FrontCarrier(Mount)                                
            # project::setValue Result(Position/CarrierMountFront)                    position    $Result(Position/CarrierMountFront)                                
            project::setValue Result(Position/CarrierMountRear)                     position    $RearCarrier(Mount)                                
            # project::setValue Result(Position/CarrierMountRear)                     position    $Result(Position/CarrierMountRear)                                 
            project::setValue Result(Position/DerailleurMountFront)                 position    $FrontDerailleur(Mount)                             
            # project::setValue Result(Position/DerailleurMountFront)                 position    $Result(Position/DerailleurMountFront)                             
            project::setValue Result(Position/FrontWheel)                           position    $FrontWheel(Position)
            project::setValue Result(Position/HandleBar)                            position    $HandleBar(Position)
            project::setValue Result(Position/LegClearance)                         position    $Geometry(LegClearance)                                     
            # project::setValue Result(Position/LegClearance)                         position    $Result(Position/LegClearance)                                     
            project::setValue Result(Position/RearWheel)                            position    $RearWheel(Position)                                        
            # project::setValue Result(Position/RearWheel)                            position    $Result(Position/RearWheel)                                        
            project::setValue Result(Position/Reference_HB)                         position    $Reference(HandleBar)                                       
            project::setValue Result(Position/Reference_SN)                         position    $Reference(SaddleNose)                                       
            # project::setValue Result(Position/Reference_HB)                         position    $Result(Position/Reference_HB)                                       
            # project::setValue Result(Position/Reference_SN)                         position    $Result(Position/Reference_SN)                                       
            project::setValue Result(Position/Saddle)                               position    $Saddle(Position)                                           
            project::setValue Result(Position/SaddleNose)                           position    $Saddle(Nose)                                       
            project::setValue Result(Position/SaddleProposal)                       position    $Saddle(Proposal)                                   
            # project::setValue Result(Position/Saddle)                               position    $Result(Position/Saddle)                                           
            # project::setValue Result(Position/SaddleNose)                           position    $Result(Position/SaddleNose)                                       
            # project::setValue Result(Position/SaddleProposal)                       position    $Result(Position/SaddleProposal)                                   
            project::setValue Result(Position/SeatPostPivot)                        position    $SeatPost(PivotPosition)                                    
            project::setValue Result(Position/SeatPostSaddle)                       position    $SeatPost(Saddle)                                   
            project::setValue Result(Position/SeatPostSeatTube)                     position    $SeatPost(SeatTube)                                 
            # project::setValue Result(Position/SeatPostPivot)                        position    $Result(Position/SeatPostPivot)                                    
            # project::setValue Result(Position/SeatPostSaddle)                       position    $Result(Position/SeatPostSaddle)                                   
            # project::setValue Result(Position/SeatPostSeatTube)                     position    $Result(Position/SeatPostSeatTube)                                 
            project::setValue Result(Position/SeatTubeGround)                       position    $SeatTube(Ground)                                   
            project::setValue Result(Position/SeatTubeSaddle)                       position    $Geometry(SeatTubeSaddle)                                   
            # project::setValue Result(Position/SeatTubeGround)                       position    $Result(Position/SeatTubeGround)                                   
            # project::setValue Result(Position/SeatTubeSaddle)                       position    $Result(Position/SeatTubeSaddle)                                   
            project::setValue Result(Position/SeatTubeVirtualTopTube)               position    $SeatTube(VirtualTopTube)                           
            # project::setValue Result(Position/SeatTubeVirtualTopTube)               position    $Result(Position/SeatTubeVirtualTopTube)                           
            project::setValue Result(Position/SteererGround)                        position    $Steerer(Ground)      
            project::setValue Result(Tubes/ChainStay/End)                           position    $ChainStay(BottomBracket)                                       
            # project::setValue Result(Tubes/ChainStay/End)                           position    $Result(Tubes/ChainStay/End)                                       
            project::setValue Result(Tubes/ChainStay/SeatStay_IS)                   position    $ChainStay(SeatStay_IS)                               
            # project::setValue Result(Tubes/ChainStay/SeatStay_IS)                   position    $Result(Tubes/ChainStay/SeatStay_IS)                               
            project::setValue Result(Tubes/ChainStay/Start)                         position    $ChainStay(RearWheel)                                     
            # project::setValue Result(Tubes/ChainStay/Start)                         position    $Result(Tubes/ChainStay/Start)                                     
            project::setValue Result(Tubes/DownTube/BottleCage/Base)                position    $DownTube(BottleCage_Base)                            
            project::setValue Result(Tubes/DownTube/BottleCage/Offset)              position    $DownTube(BottleCage_Offset)                          
            project::setValue Result(Tubes/DownTube/BottleCage_Lower/Base)          position    $DownTube(BottleCage_Lower_Base)                      
            project::setValue Result(Tubes/DownTube/BottleCage_Lower/Offset)        position    $DownTube(BottleCage_Lower_Offset)                    
            # project::setValue Result(Tubes/DownTube/BottleCage/Base)                position    $Result(Tubes/DownTube/BottleCage/Base)                            
            # project::setValue Result(Tubes/DownTube/BottleCage/Offset)              position    $Result(Tubes/DownTube/BottleCage/Offset)                          
            # project::setValue Result(Tubes/DownTube/BottleCage_Lower/Base)          position    $Result(Tubes/DownTube/BottleCage_Lower/Base)                      
            # project::setValue Result(Tubes/DownTube/BottleCage_Lower/Offset)        position    $Result(Tubes/DownTube/BottleCage_Lower/Offset)                    
            project::setValue Result(Tubes/DownTube/End)                            position    $DownTube(HeadTube)                                           
            # project::setValue Result(Tubes/DownTube/End)                            position    $Result(Tubes/DownTube/End)                                           
            project::setValue Result(Tubes/DownTube/Start)                          position    $DownTube(BottomBracket)                                         
            # project::setValue Result(Tubes/DownTube/Start)                          position    $Result(Tubes/DownTube/Start)                                         
            project::setValue Result(Tubes/HeadTube/End)                            position    $HeadTube(Stem)                                           
            # project::setValue Result(Tubes/HeadTube/End)                            position    $Result(Tubes/HeadTube/End)                                           
            project::setValue Result(Tubes/HeadTube/Start)                          position    $HeadTube(Fork)                                         
            # project::setValue Result(Tubes/HeadTube/Start)                          position    $Result(Tubes/HeadTube/Start)                                         
            project::setValue Result(Tubes/SeatStay/End)                            position    $SeatStay(SeatTube)                                           
            # project::setValue Result(Tubes/SeatStay/End)                            position    $Result(Tubes/SeatStay/End)                                           
            project::setValue Result(Tubes/SeatStay/Start)                          position    $SeatStay(RearWheel)                                         
            # project::setValue Result(Tubes/SeatStay/Start)                          position    $Result(Tubes/SeatStay/Start)                                         
            project::setValue Result(Tubes/SeatTube/BottleCage/Base)                position    $SeatTube(BottleCage_Base)                     
            project::setValue Result(Tubes/SeatTube/BottleCage/Offset)              position    $SeatTube(BottleCage_Offset)                   
            # project::setValue Result(Tubes/SeatTube/BottleCage/Base)                position    $Result(Tubes/SeatTube/BottleCage/Base)                     
            # project::setValue Result(Tubes/SeatTube/BottleCage/Offset)              position    $Result(Tubes/SeatTube/BottleCage/Offset)                   
            project::setValue Result(Tubes/SeatTube/End)                            position    $SeatTube(TopTube)
            # project::setValue Result(Tubes/SeatTube/End)                            position    $Result(Tubes/SeatTube/End)
            project::setValue Result(Tubes/SeatTube/Start)                          position    $SeatTube(BottomBracket)
            # project::setValue Result(Tubes/SeatTube/Start)                          position    $Result(Tubes/SeatTube/Start)
            project::setValue Result(Tubes/Steerer/End)                             position    $Steerer(Stem)
            project::setValue Result(Tubes/Steerer/Start)                           position    $Steerer(Fork)
            project::setValue Result(Tubes/TopTube/End)                             position    $TopTube(HeadTube)                                         
            # project::setValue Result(Tubes/TopTube/End)                             position    $Result(Tubes/TopTube/End)                                         
            project::setValue Result(Tubes/TopTube/Start)                           position    $TopTube(SeatTube)
            # project::setValue Result(Tubes/TopTube/Start)                           position    $Result(Tubes/TopTube/Start)
                #
            project::setValue Result(Tubes/ForkBlade/End)                           position    $ForkBlade(End)                                       
            # project::setValue Result(Tubes/ForkBlade/End)                           value       $Result(Tubes/ForkBlade/End)                                       
            project::setValue Result(Tubes/ForkBlade/Start)                         position    $ForkBlade(Start)                                     
            # project::setValue Result(Tubes/ForkBlade/Start)                         value       $Result(Tubes/ForkBlade/Start)                                     
                #
                #
            project::setValue Result(Position/SummarySize)                          position    $BoundingBox(SummarySize)                                         
            # project::setValue Result(Position/SummarySize)                          position    $Result(Position/SummarySize)                                         
                #
                #
                # --- get Rendering  ----------------------------
            project::setValue Rendering(Saddle/Offset_X)                            value       $Saddle(Offset_x)   
            project::setValue Rendering(Saddle/Offset_Y)                            value       $Saddle(Offset_y)   
            project::setValue Rendering(Brake/Front)                                value       $Rendering(FrontBrake)       
            project::setValue Rendering(Brake/Rear)                                 value       $Rendering(RearBrake)        
            project::setValue Rendering(BottleCage/SeatTube)                        value       $Rendering(BottleCage_ST)    
            project::setValue Rendering(BottleCage/DownTube)                        value       $Rendering(BottleCage_DT)    
            project::setValue Rendering(BottleCage/DownTube_Lower)                  value       $Rendering(BottleCage_DT_L)  
            project::setValue Rendering(Fender/Front)                               value       $Rendering(FrontFender)      
            project::setValue Rendering(Fender/Rear)                                value       $Rendering(RearFender)      
            project::setValue Rendering(Fork)                                       value       $Rendering(Fork)         
            project::setValue Rendering(ForkBlade)                                  value       $Rendering(ForkBlade)    
            project::setValue Rendering(ForkDropOut)                                value       $Rendering(ForkDropout)  
            project::setValue Rendering(RearDropOut)                                value       $Rendering(RearDropout) 
                #
            project::setValue Rendering(RearMockup/CassetteClearance)               value       $RearMockup(CassetteClearance)           
            project::setValue Rendering(RearMockup/ChainWheelClearance)             value       $RearMockup(ChainWheelClearance)           
            project::setValue Rendering(RearMockup/CrankClearance)                  value       $RearMockup(CrankClearance)           
            project::setValue Rendering(RearMockup/DiscClearance)                   value       $RearMockup(DiscClearance)           
            project::setValue Rendering(RearMockup/DiscDiameter)                    value       $RearMockup(DiscDiameter)           
            project::setValue Rendering(RearMockup/DiscOffset)                      value       $RearMockup(DiscOffset)           
            project::setValue Rendering(RearMockup/DiscWidth)                       value       $RearMockup(DiscWidth)           
            project::setValue Rendering(RearMockup/TyreClearance)                   value       $RearMockup(TyreClearance) 
                #
                #
                #
            project::setValue Lugs(RearDropOut/Direction)                           value       $Rendering(RearDropoutOrient)
            project::setValue Component(HandleBar/PivotAngle)                       value       $HandleBar(PivotAngle)
            project::setValue Component(Fork/Crown/File)                            value       $Fork(CrownFile)
            project::setValue Component(Fork/DropOut/File)                          value       $Fork(DropOutFile)

                #
                #
            return    
                #
        
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
