 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_gui.tcl
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
 #    namespace:  rattleCAD::lib_gui
 # ---------------------------------------------------------------------------
 #
 # 
 
 #
 #
 # procedures are referenced by 
 #     rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $tag       $procName [no full qualified namespade]
 #
 
 namespace eval rattleCAD::view::edit {
 }
 
        #
        # -- Rendering - Options --------------------------
        #
    proc rattleCAD::view::edit::option_ForkType                         {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   list://Rendering(Fork@SELECT_ForkType)                          }
    proc rattleCAD::view::edit::option_ChainStay                        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   list://Rendering(ChainStay@SELECT_ChainStay)                    }
    proc rattleCAD::view::edit::option_FrontFenderBinary                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   list://Rendering(Fender/Front@SELECT_Binary_OnOff)              }    
    proc rattleCAD::view::edit::option_RearFenderBinary                 {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   list://Rendering(Fender/Rear@SELECT_Binary_OnOff)               }     
    proc rattleCAD::view::edit::option_DownTubeUpperCage                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   list://Rendering(BottleCage/DownTube@SELECT_BottleCage)         }
    proc rattleCAD::view::edit::option_DownTubeLowerCage                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   list://Rendering(BottleCage/DownTube_Lower@SELECT_BottleCage)   }
    proc rattleCAD::view::edit::option_SeatTubCage                      {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   list://Rendering(BottleCage/SeatTube@SELECT_BottleCage)         }
    
    
        #
        # -- Result - Values --------------------------
        #
    proc rattleCAD::view::edit::single_Result_BottomBracket_Height      {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Result(Length/BottomBracket/Height)       }
    proc rattleCAD::view::edit::single_Result_FrontWheel_diagonal       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Result(Length/FrontWheel/diagonal)        }
    proc rattleCAD::view::edit::single_Result_FrontWheel_horizontal     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Result(Length/FrontWheel/horizontal)      }
    proc rattleCAD::view::edit::single_Result_HeadTube_ReachLength      {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Result(Length/HeadTube/ReachLength)       }
    proc rattleCAD::view::edit::single_Result_HeadTube_Angle            {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Result(Angle/SeatTube/Direction)          }
    proc rattleCAD::view::edit::single_Result_HeadTube_TopTubeAngle     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Result(Angle/HeadTube/TopTube)            }
    proc rattleCAD::view::edit::single_Result_Reference_Heigth_SN_HB    {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Result(Length/Reference/Heigth_SN_HB)     }
    proc rattleCAD::view::edit::single_Result_RearWheel_horizontal      {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Result(Length/RearWheel/horizontal)       }
    proc rattleCAD::view::edit::single_Result_SaddleNose_HB             {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Result(Length/Personal/SaddleNose_HB)     }
    proc rattleCAD::view::edit::single_Result_Reference_SaddleNose_HB   {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Result(Length/Reference/SaddleNose_HB)    }
    proc rattleCAD::view::edit::single_Result_SaddleOffset_BB_Nose      {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Result(Length/Saddle/Offset_BB_Nose)      }
    proc rattleCAD::view::edit::single_Result_SaddleOffset_BB_ST        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Result(Length/Saddle/Offset_BB_ST)        }
    proc rattleCAD::view::edit::single_Result_SaddleOffset_HB           {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Result(Length/Saddle/Offset_HB)           }
    proc rattleCAD::view::edit::single_Result_Saddle_SeatTube_BB        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Result(Length/Saddle/SeatTube_BB)         }
    proc rattleCAD::view::edit::single_Result_SeatTube_VirtualLength    {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Result(Length/SeatTube/VirtualLength)     }
    proc rattleCAD::view::edit::single_Result_StackHeight               {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Result(Length/HeadTube/StackHeight)       }
    proc rattleCAD::view::edit::single_Result_TopTube_VirtualLength     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Result(Length/TopTube/VirtualLength)      }


        #
        # -- others -----------------------------------
        #
    proc rattleCAD::view::edit::single_BottomBracket_CS_Offset_TopView  {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Lugs(BottomBracket/ChainStay/Offset_TopView)  }
    proc rattleCAD::view::edit::single_BottomBracket_Depth              {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Custom(BottomBracket/Depth)                   }
    proc rattleCAD::view::edit::single_BottomBracket_InsideDiameter     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Lugs(BottomBracket/Diameter/inside)           }
    proc rattleCAD::view::edit::single_BottomBracket_OutsideDiameter    {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Lugs(BottomBracket/Diameter/outside)          }
    proc rattleCAD::view::edit::single_BottomBracket_Width              {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Lugs(BottomBracket/Width)                     }
    proc rattleCAD::view::edit::single_ChainStay_CenterlineLength_01    {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   FrameTubes(ChainStay/CenterLine/length_01)    }
    proc rattleCAD::view::edit::single_ChainStay_CenterlineLength_02    {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   FrameTubes(ChainStay/CenterLine/length_02)    }
    proc rattleCAD::view::edit::single_ChainStay_CenterlineLength_03    {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   FrameTubes(ChainStay/CenterLine/length_03)    }
    proc rattleCAD::view::edit::single_ChainStay_CenterlineLength_04    {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   FrameTubes(ChainStay/CenterLine/length_04)    }
    proc rattleCAD::view::edit::single_ChainStay_ProfileLengthComplete  {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   FrameTubes(ChainStay/Profile/completeLength)  }
    proc rattleCAD::view::edit::single_ChainStay_ProfileLengthCut       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   FrameTubes(ChainStay/Profile/cuttingLength)   }
    proc rattleCAD::view::edit::single_ChainStay_ProfileLength_01       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   FrameTubes(ChainStay/Profile/length_01)       }
    proc rattleCAD::view::edit::single_ChainStay_ProfileLength_02       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   FrameTubes(ChainStay/Profile/length_02)       }
    proc rattleCAD::view::edit::single_ChainStay_ProfileLength_03       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   FrameTubes(ChainStay/Profile/length_03)       }
    proc rattleCAD::view::edit::single_ChainStay_ProfileWidth_00        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   FrameTubes(ChainStay/Profile/width_00)        }
    proc rattleCAD::view::edit::single_ChainStay_ProfileWidth_01        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   FrameTubes(ChainStay/Profile/width_01)        }
    proc rattleCAD::view::edit::single_ChainStay_ProfileWidth_02        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   FrameTubes(ChainStay/Profile/width_02)        }
    proc rattleCAD::view::edit::single_ChainStay_ProfileWidth_03        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   FrameTubes(ChainStay/Profile/width_03)        }
    proc rattleCAD::view::edit::single_CrankSet_ArmWidth                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(CrankSet/ArmWidth)                  }
    proc rattleCAD::view::edit::single_CrankSet_ChainLine               {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(CrankSet/ChainLine)                 }
    proc rattleCAD::view::edit::single_CrankSet_Length                  {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(CrankSet/Length)                    }
    proc rattleCAD::view::edit::single_CrankSet_PedalEye                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(CrankSet/PedalEye)                  }
    proc rattleCAD::view::edit::single_CrankSet_QFactor                 {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(CrankSet/Q-Factor)                  }
    proc rattleCAD::view::edit::single_DownTube_BottomBracketOffset     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Custom(DownTube/OffsetBB)                     }
    proc rattleCAD::view::edit::single_DownTube_CageOffsetBB            {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(BottleCage/DownTube/OffsetBB)       }
    proc rattleCAD::view::edit::single_DownTube_HeadTubeOffset          {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Custom(DownTube/OffsetHT)                     }
    proc rattleCAD::view::edit::single_DownTube_LowerCageOffsetBB       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(BottleCage/DownTube_Lower/OffsetBB) }
    proc rattleCAD::view::edit::single_Fork_Height                      {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(Fork/Height)                        }
    proc rattleCAD::view::edit::single_Fork_Rake                        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(Fork/Rake)                          }
    proc rattleCAD::view::edit::single_FrontBrake_LeverLength           {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(Brake/Front/LeverLength)            }
    proc rattleCAD::view::edit::single_FrontBrake_Offset                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(Brake/Front/Offset)                 }
    proc rattleCAD::view::edit::single_FrontWheel_RimHeight             {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(Wheel/Front/RimHeight)              }
    proc rattleCAD::view::edit::single_HeadSet_BottomHeight             {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(HeadSet/Height/Bottom)              }
    proc rattleCAD::view::edit::single_HeadSet_TopHeight                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(HeadSet/Height/Top)                 }
    proc rattleCAD::view::edit::single_HeadTube_Angle                   {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Custom(HeadTube/Angle)                         }
    proc rattleCAD::view::edit::single_HeadTube_Diameter                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   FrameTubes(HeadTube/Diameter)                  }
    proc rattleCAD::view::edit::single_HeadTube_Length                  {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   FrameTubes(HeadTube/Length)                    }
    proc rattleCAD::view::edit::single_Personal_HandleBarDistance       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Personal(HandleBar_Distance)                   }
    proc rattleCAD::view::edit::single_Personal_HandleBarHeight         {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Personal(HandleBar_Height)                     }
    proc rattleCAD::view::edit::single_Personal_InnerLegLength          {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Personal(InnerLeg_Length)                      }
    proc rattleCAD::view::edit::single_Personal_SaddleDistance          {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Personal(Saddle_Distance)                      }
    proc rattleCAD::view::edit::single_Personal_SaddleHeight            {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Personal(Saddle_Height)                        }
    proc rattleCAD::view::edit::single_RearBrake_LeverLength            {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(Brake/Rear/LeverLength)             }
    proc rattleCAD::view::edit::single_RearBrake_Offset                 {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(Brake/Rear/Offset)                  }
    proc rattleCAD::view::edit::single_RearDropOut_CS_Offset            {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Lugs(RearDropOut/ChainStay/Offset)            }
    proc rattleCAD::view::edit::single_RearDropOut_CS_OffsetTopView     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Lugs(RearDropOut/ChainStay/Offset_TopView)    }
    proc rattleCAD::view::edit::single_RearHub_DiscOffset               {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Rendering(RearMockup/DiscOffset)              }
    proc rattleCAD::view::edit::single_RearHub_FirstSprocket            {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   text://Component(Wheel/Rear/FirstSprocket)    }
    proc rattleCAD::view::edit::single_RearHub_Width                    {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(Wheel/Rear/HubWidth)                }
    proc rattleCAD::view::edit::single_RearWheel_Distance               {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Custom(WheelPosition/Rear)                    }
    proc rattleCAD::view::edit::single_RearWheel_RimHeight              {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(Wheel/Rear/RimHeight)               }
    proc rattleCAD::view::edit::single_RearWheel_TyreWidth              {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(Wheel/Rear/TyreWidth)               }
    proc rattleCAD::view::edit::single_RearWheel_TyreWidthRadius        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(Wheel/Rear/TyreWidthRadius)         }
    proc rattleCAD::view::edit::single_Reference_HandleBarDistance      {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Reference(HandleBar_Distance)                  }
    proc rattleCAD::view::edit::single_Reference_HandleBarHeight        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Reference(HandleBar_Height)                    }
    proc rattleCAD::view::edit::single_Reference_SaddleNoseDistance     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Reference(SaddleNose_Distance)                 }
    proc rattleCAD::view::edit::single_Reference_SaddleNoseHeight       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Reference(SaddleNose_Height)                   }
    proc rattleCAD::view::edit::single_Result_RearWheelTyreShoulder     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Result(Length/RearWheel/TyreShoulder)         }
    proc rattleCAD::view::edit::single_SaddleHeightComponent            {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(Saddle/Height)                      }
    proc rattleCAD::view::edit::single_SeatPost_Diameter                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(SeatPost/Diameter)                   }
    proc rattleCAD::view::edit::single_SeatPost_PivotOffset             {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(SeatPost/PivotOffset)                }
    proc rattleCAD::view::edit::single_SeatPost_Setback                 {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(SeatPost/Setback)                    }
    proc rattleCAD::view::edit::single_SeatStay_OffsetTT                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Custom(SeatStay/OffsetTT)                     }
    proc rattleCAD::view::edit::single_SeatTube_BottomBracketOffset     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Custom(SeatTube/OffsetBB)                     }
    proc rattleCAD::view::edit::single_SeatTube_CageOffsetBB            {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(BottleCage/SeatTube/OffsetBB)       }
    proc rattleCAD::view::edit::single_SeatTube_Extension               {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Custom(SeatTube/Extension)                     }
    proc rattleCAD::view::edit::single_Stem_Angle                       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(Stem/Angle)                          }
    proc rattleCAD::view::edit::single_Stem_Length                      {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Component(Stem/Length)                         }
    proc rattleCAD::view::edit::single_TopTube_Angle                    {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Custom(TopTube/Angle)                         }
    proc rattleCAD::view::edit::single_TopTube_HeadTubeOffset           {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Custom(TopTube/OffsetHT)                       }
    proc rattleCAD::view::edit::single_TopTube_PivotPosition            {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Custom(TopTube/PivotPosition)                  }
    
    proc rattleCAD::view::edit::single_LogoFile                         {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   file://Component(Logo/File)                     }
    proc rattleCAD::view::edit::single_CrankSetFile                     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   file://Component(CrankSet/File)                 }
    proc rattleCAD::view::edit::single_RearDerailleurFile               {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   file://Component(Derailleur/Rear/File)          }
    proc rattleCAD::view::edit::single_SeatTube_BottleCageFile          {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name    list://Rendering(BottleCage/SeatTube@SELECT_BottleCage)    }
    proc rattleCAD::view::edit::single_DownTube_BottleCageFile          {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   list://Rendering(BottleCage/DownTube@SELECT_BottleCage)     }
    proc rattleCAD::view::edit::single_DownTube_BottleCageFileLower     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   list://Rendering(BottleCage/DownTube_Lower@SELECT_BottleCage)   }


















    
    


        #
        # -- Fork - Settings ------------------------------
        #
    proc rattleCAD::view::edit::group_ForkCrownParameter            {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name  { \
                    list://Rendering(Fork@SELECT_ForkType) \
                    file://Component(Fork/Crown/File) \
                    Component(Fork/Crown/Brake/Angle) \
                    Component(Fork/Crown/Brake/Offset) \
                    Component(Fork/Crown/Blade/Offset) \
                    Component(Fork/Crown/Blade/OffsetPerp) \
                }   {ForkCrown Parameter}
    }
    proc rattleCAD::view::edit::group_ForkBladeParameter            {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name  { \
                   list://Rendering(ForkBlade@SELECT_ForkBladeType) \
                   Component(Fork/Blade/Width) \
                   Component(Fork/Blade/DiameterDO) \
                   Component(Fork/Blade/TaperLength) \
                   Component(Fork/Blade/BendRadius) \
                   Component(Fork/Blade/EndLength) \
               }  {ForkBlade Parameter}
    }
    proc rattleCAD::view::edit::group_ForkDropoutParameter          {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    file://Component(Fork/DropOut/File) \
                    list://Rendering(ForkDropOut@SELECT_DropOutPosition) \
                    Component(Fork/DropOut/Offset) \
                    Component(Fork/DropOut/OffsetPerp) \
                }   {ForkDropout Parameter}
    }

        #
        # -- Lug - Settings -------------------------------
        #
        #
        # -- Frame Details -- Lug Specification -----------
        #
    proc rattleCAD::view::edit::lugSpec_RearDropout                 {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Lugs(RearDropOut/Angle/value) \
                    Lugs(RearDropOut/Angle/plus_minus) \
                }   "new - Lug Specification:  RearDropout"
    }
    proc rattleCAD::view::edit::lugSpec_SeatTube_DownTube           {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Lugs(BottomBracket/DownTube/Angle/value) \
                    Lugs(BottomBracket/DownTube/Angle/plus_minus) \
                }   "new - Lug Specification:  SeatTube/DownTube"
    }
    proc rattleCAD::view::edit::lugSpec_SeatTube_ChainStay          {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Lugs(BottomBracket/ChainStay/Angle/value) \
                    Lugs(BottomBracket/ChainStay/Angle/plus_minus) \
                }   "new - Lug Specification:  SeatTube/ChainStay"
    }    
    proc rattleCAD::view::edit::lugSpec_SeatTube_TopTube            {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Lugs(SeatTube/TopTube/Angle/value)   \
                    Lugs(SeatTube/TopTube/Angle/plus_minus) \
                }   "new - Lug Specification:  SeatTube/TopTube"
    }    
    proc rattleCAD::view::edit::lugSpec_SeatTube_SeatStay           {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Lugs(SeatTube/SeatStay/Angle/value) \
                    Lugs(SeatTube/SeatStay/Angle/plus_minus) \
                    Lugs(SeatTube/SeatStay/MiterDiameter) \
                }   "new - Lug Specification:  SeatTube/SeatStay"
    }    
    proc rattleCAD::view::edit::lugSpec_HeadTube_TopTube            {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Lugs(HeadTube/TopTube/Angle/value) \
                    Lugs(HeadTube/TopTube/Angle/plus_minus) \
                }   "new - Lug Specification:  HeadTube/TopTube"
    }   
    proc rattleCAD::view::edit::lugSpec_HeadTube_DownTube           {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Lugs(HeadTube/DownTube/Angle/value) \
                    Lugs(HeadTube/DownTube/Angle/plus_minus) \
                }   "new - Lug Specification:  HeadTube/DownTube"
    } 


        #
        # -- Base Concept ---------------------------------
        #
    proc rattleCAD::view::edit::group_RearWheelParameter            {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    list://Component(Wheel/Rear/RimDiameter@SELECT_Rim) \
                    Result(Length/RearWheel/Radius)  \
                }   "new - Rear Wheel Parameter"
    }
    proc rattleCAD::view::edit::group_FrontGeometry                 {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Component(Stem/Angle) \
                    Component(Stem/Length) \
                    Component(Fork/Height) \
                    Component(Fork/Rake) \
                }   "new - Steerer/Fork:  Settings"
    }
    proc rattleCAD::view::edit::group_BottomBracketDepthHeight      {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Custom(BottomBracket/Depth) \
                    Result(Length/BottomBracket/Height) \
                }   "new - BottomBracket:  Settings"
    }


        #
        # -- TopTube --------------------------------------
        #
        #
        # -- SeatTube -------------------------------------
        #
        #
        # -- DownTube -------------------------------------
        #
        #
        # -- SeatStay -------------------------------------
        #
        
        
        #
        # -- Rear Frame -----------------------------------
        #
    proc rattleCAD::view::edit::group_RearDerailleurMount           {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    file://Lugs(RearDropOut/File)  \
                    list://Lugs(RearDropOut/Direction@SELECT_DropOutDirection)  \
                    list://Rendering(RearDropOut@SELECT_DropOutPosition)    \
                    Lugs(RearDropOut/RotationOffset)    \
                    Lugs(RearDropOut/Derailleur/x) \
                    Lugs(RearDropOut/Derailleur/y) \
                }   "new - Rear Derailleur Mount"
    }
    
    
        #
        # -- Rear Mockup ----------------------------------
        #
    proc rattleCAD::view::edit::group_RearDiscBrake                 {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Rendering(RearMockup/DiscDiameter) \
                    Rendering(RearMockup/DiscWidth) \
                    Rendering(RearMockup/DiscClearance) \
                }   "new - DiscBrake Details"
    }
    proc rattleCAD::view::edit::group_RearTyreParameter             {x y cv_Name} { 
            # title { Rear Tyre Parameter} #
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Component(Wheel/Rear/TyreWidthRadius) \
                    Component(Wheel/Rear/TyreWidth) \
                    Rendering(RearMockup/TyreClearance) \
                }   "new -  Rear Tyre Parameter"
    }        
        #
        #
    proc rattleCAD::view::edit::group_ChainStayCenterline_Bent01    {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    FrameTubes(ChainStay/CenterLine/angle_01) \
                    FrameTubes(ChainStay/CenterLine/radius_01) \
                    FrameTubes(ChainStay/CenterLine/length_01) \
                    FrameTubes(ChainStay/CenterLine/length_02) \
                }   "new - ChainStay:  Bent 01"   
    }
    proc rattleCAD::view::edit::group_ChainStayCenterline_Bent02    {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    FrameTubes(ChainStay/CenterLine/angle_02) \
                    FrameTubes(ChainStay/CenterLine/radius_02) \
                    FrameTubes(ChainStay/CenterLine/length_02) \
                    FrameTubes(ChainStay/CenterLine/length_03) \
                }   "new - ChainStay:  Bent 02"   
    }
    proc rattleCAD::view::edit::group_ChainStayCenterline_Bent03    {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    FrameTubes(ChainStay/CenterLine/angle_03) \
                    FrameTubes(ChainStay/CenterLine/radius_03) \
                    FrameTubes(ChainStay/CenterLine/length_03) \
                    FrameTubes(ChainStay/CenterLine/length_04) \
                }   "new - ChainStay:  Bent 03"   
    }
    proc rattleCAD::view::edit::group_ChainStayCenterline_Bent04    {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    FrameTubes(ChainStay/CenterLine/angle_04) \
                    FrameTubes(ChainStay/CenterLine/radius_04) \
                    FrameTubes(ChainStay/CenterLine/length_04) \
                }   "new - ChainStay:  Bent 04" 
    }
    proc rattleCAD::view::edit::group_RearHubParameter              {x y cv_Name} {
                # Line 491:
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Component(Wheel/Rear/HubWidth) \
                    text://Component(Wheel/Rear/FirstSprocket) \
                }   "new - RearHub:  Parameter"
    }
    proc rattleCAD::view::edit::group_CranksetParameter             {x y cv_Name} {
                # Line 623:
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Component(CrankSet/ChainLine) Component(CrankSet/Q-Factor) \
                    text://Component(CrankSet/ChainRings) \
                }   "new - Crankset:  Parameter"
    }
    proc rattleCAD::view::edit::group_ChainStayArea                 {x y cv_Name} {
                # Line 782:
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    list://Rendering(ChainStay@SELECT_ChainStay) \
                    Rendering(RearMockup/TyreClearance) \
                    Rendering(RearMockup/ChainWheelClearance) \
                    Rendering(RearMockup/CrankClearance) \
                    Rendering(RearMockup/CassetteClearance) \
                }   "new - ChainStay:  Area"
    }                

        
        


    
    
    
    