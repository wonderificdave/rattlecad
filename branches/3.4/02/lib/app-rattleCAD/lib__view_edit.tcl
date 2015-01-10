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
    proc rattleCAD::view::edit::option_ForkType                         {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   list://Config(Fork@SELECT_ForkType)                          }   ;#  list://Config(Fork@SELECT_ForkType)                          }
    proc rattleCAD::view::edit::option_ChainStay                        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   list://Config(ChainStay@SELECT_ChainStay)                    }   ;#  list://Rendering(ChainStay@SELECT_ChainStay)                    }
    proc rattleCAD::view::edit::option_FrontFenderBinary                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   list://Config(FrontFender@SELECT_Binary_OnOff)               }   ;#  list://Rendering(Fender/Front@SELECT_Binary_OnOff)              }    
    proc rattleCAD::view::edit::option_RearFenderBinary                 {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   list://Config(RearFender@SELECT_Binary_OnOff)                }   ;#  list://Rendering(Fender/Rear@SELECT_Binary_OnOff)               }     
    proc rattleCAD::view::edit::option_DownTubeUpperCage                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   list://Config(BottleCage_DownTube@SELECT_BottleCage)         }   ;#  list://Rendering(BottleCage/DownTube@SELECT_BottleCage)         }
    proc rattleCAD::view::edit::option_DownTubeLowerCage                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   list://Config(BottleCage_DownTube_Lower@SELECT_BottleCage)   }   ;#  list://Rendering(BottleCage/DownTube_Lower@SELECT_BottleCage)   }
    proc rattleCAD::view::edit::option_SeatTubCage                      {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   list://Config(BottleCage_SeatTube@SELECT_BottleCage)         }   ;#  list://Rendering(BottleCage/SeatTube@SELECT_BottleCage)         }
    
    
        #
        # -- Result - Values --------------------------
        #
    proc rattleCAD::view::edit::single_Result_BottomBracket_Height      {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/BottomBracket_Height)    }  ;# Result(Length/BottomBracket/Height)       
    proc rattleCAD::view::edit::single_Result_FrontWheel_diagonal       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/FrontWheel_xy)           }  ;# Result(Length/FrontWheel/diagonal)        
    proc rattleCAD::view::edit::single_Result_FrontWheel_horizontal     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/FrontWheel_x)            }  ;# Result(Length/FrontWheel/horizontal)      
    proc rattleCAD::view::edit::single_Result_HeadTube_ReachLength      {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/Reach_Length)            }  ;# Result(Length/HeadTube/ReachLength)       
    proc rattleCAD::view::edit::single_Result_SeatTube_Angle            {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/SeatTube_Angle)          }  ;# Result(Angle/SeatTube/Direction)          
    proc rattleCAD::view::edit::single_Result_HeadTube_TopTubeAngle     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/HeadLug_Angle_Top))      }  ;# Scalar(Result/Angle_HeadTubeTopTube)      
    proc rattleCAD::view::edit::single_Result_RearWheel_horizontal      {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/RearWheel_x)             }  ;# Result(Length/RearWheel/horizontal)       
    proc rattleCAD::view::edit::single_Result_SaddleNose_HB             {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/SaddleNose_HB)           }  ;# Result(Length/Personal/SaddleNose_HB)     
    proc rattleCAD::view::edit::single_Result_Saddle_Offset_BB_Nose     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/SaddleNose_BB_x)         }  ;# Result(Length/Saddle/Offset_BB_Nose)      
    proc rattleCAD::view::edit::single_Result_Saddle_Offset_BB_ST       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/Saddle_Offset_BB_ST)     }  ;# Result(Length/Saddle/Offset_BB_ST)        
    proc rattleCAD::view::edit::single_Result_Saddle_Offset_HB          {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/Saddle_HB_y)             }  ;# Result(Length/Saddle/Offset_HB)           
    proc rattleCAD::view::edit::single_Result_Saddle_SeatTube_BB        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/Saddle_BB)               }  ;# Result(Length/Saddle/SeatTube_BB)         
    proc rattleCAD::view::edit::single_Result_SeatTube_VirtualLength    {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/SeatTube_Virtual)        }  ;# Result(Length/SeatTube/VirtualLength)     
    proc rattleCAD::view::edit::single_Result_StackHeight               {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/Stack_Height)            }  ;# Result(Length/HeadTube/StackHeight)       
    proc rattleCAD::view::edit::single_Result_TopTube_VirtualLength     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/TopTube_Virtual)         }  ;# Result(Length/TopTube/VirtualLength)      
        #                                                                                                                                                                        
    proc rattleCAD::view::edit::single_Result_Reference_Heigth_SN_HB    {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Reference/SaddleNose_HB_y)        }  ;# Result(Length/Reference/Heigth_SN_HB)     
    proc rattleCAD::view::edit::single_Result_Reference_SaddleNose_HB   {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Reference/SaddleNose_HB)          }  ;# Result(Length/Reference/SaddleNose_HB)    
    proc rattleCAD::view::edit::single_Result_RearWheelTyreShoulder     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(RearWheel/TyreShoulder)           }  ;# Result(Length/RearWheel/TyreShoulder)     
        #
    proc rattleCAD::view::edit::single_LugDetermination_HeadLug         {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/HeadLug_Angle_Bottom)          }
    proc rattleCAD::view::edit::single_LugDetermination_ChainStay       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/BottomBracket_Angle_ChainStay) }
    proc rattleCAD::view::edit::single_LugDetermination_DownTube        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/BottomBracket_Angle_DownTube)  }


        #
        # -- others -----------------------------------
        #
    proc rattleCAD::view::edit::single_BottomBracket_CS_Offset_TopView  {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(BottomBracket/OffsetCS_TopView)      ;# Lugs(BottomBracket/ChainStay/Offset_TopView)  }
    proc rattleCAD::view::edit::single_BottomBracket_Depth              {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/BottomBracket_Depth)        ;# Custom(BottomBracket/Depth)                   }
    proc rattleCAD::view::edit::single_BottomBracket_InsideDiameter     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(BottomBracket/InsideDiameter)        ;# Lugs(BottomBracket/Diameter/inside)           }
    proc rattleCAD::view::edit::single_BottomBracket_OutsideDiameter    {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(BottomBracket/OutsideDiameter)       ;# Lugs(BottomBracket/Diameter/outside)          }
    proc rattleCAD::view::edit::single_BottomBracket_Width              {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(BottomBracket/Width)                 ;# Lugs(BottomBracket/Width)                     }
    proc rattleCAD::view::edit::single_ChainStay_DropoutOffset          {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(RearDropout/OffsetCSPerp)            ;# Lugs(RearDropOut/ChainStay/OffsetCSPerp)      }
    proc rattleCAD::view::edit::single_ChainStay_CenterlineLength_01    {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(ChainStay/segmentLength_01)          ;# FrameTubes(ChainStay/CenterLine/length_01)    }
    proc rattleCAD::view::edit::single_ChainStay_CenterlineLength_02    {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(ChainStay/segmentLength_02)          ;# FrameTubes(ChainStay/CenterLine/length_02)    }
    proc rattleCAD::view::edit::single_ChainStay_CenterlineLength_03    {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(ChainStay/segmentLength_03)          ;# FrameTubes(ChainStay/CenterLine/length_03)    }
    proc rattleCAD::view::edit::single_ChainStay_CenterlineLength_04    {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(ChainStay/segmentLength_04)          ;# FrameTubes(ChainStay/CenterLine/length_04)    }
    proc rattleCAD::view::edit::single_ChainStay_ProfileLengthComplete  {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(ChainStay/completeLength)            ;# FrameTubes(ChainStay/Profile/completeLength)  }
    proc rattleCAD::view::edit::single_ChainStay_ProfileLengthCut       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(ChainStay/cuttingLength)             ;# FrameTubes(ChainStay/Profile/cuttingLength)   }
    proc rattleCAD::view::edit::single_ChainStay_ProfileLength_01       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(ChainStay/profile_x01)               ;# FrameTubes(ChainStay/Profile/length_01)       }
    proc rattleCAD::view::edit::single_ChainStay_ProfileLength_02       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(ChainStay/profile_x02)               ;# FrameTubes(ChainStay/Profile/length_02)       }
    proc rattleCAD::view::edit::single_ChainStay_ProfileLength_03       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(ChainStay/profile_x03)               ;# FrameTubes(ChainStay/Profile/length_03)       }
    proc rattleCAD::view::edit::single_ChainStay_ProfileWidth_00        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(ChainStay/profile_y00)               ;# FrameTubes(ChainStay/Profile/width_00)        }
    proc rattleCAD::view::edit::single_ChainStay_ProfileWidth_01        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(ChainStay/profile_y01)               ;# FrameTubes(ChainStay/Profile/width_01)        }
    proc rattleCAD::view::edit::single_ChainStay_ProfileWidth_02        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(ChainStay/profile_y02)               ;# FrameTubes(ChainStay/Profile/width_02)        }
    proc rattleCAD::view::edit::single_ChainStay_ProfileWidth_03        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(ChainStay/WidthBB)                   ;# FrameTubes(ChainStay/WidthBB)                 }
    proc rattleCAD::view::edit::single_CrankSet_ArmWidth                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(CrankSet/ArmWidth)                   ;# Component(CrankSet/ArmWidth)                  }
    proc rattleCAD::view::edit::single_CrankSet_ChainLine               {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(CrankSet/ChainLine)                  ;# Component(CrankSet/ChainLine)                 }
    proc rattleCAD::view::edit::single_CrankSet_Length                  {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(CrankSet/Length)                     ;# Component(CrankSet/Length)                    }
    proc rattleCAD::view::edit::single_CrankSet_PedalEye                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(CrankSet/PedalEye)                   ;# Component(CrankSet/PedalEye)                  }
    proc rattleCAD::view::edit::single_CrankSet_QFactor                 {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(CrankSet/Q-Factor)                   ;# Component(CrankSet/Q-Factor)                  }
    proc rattleCAD::view::edit::single_DownTube_BottomBracketOffset     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(DownTube/OffsetBB)                   ;# Custom(DownTube/OffsetBB)                     }
    proc rattleCAD::view::edit::single_DownTube_CageOffsetBB            {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(BottleCage/DownTube)                 ;# Component(BottleCage/DownTube/OffsetBB)       }
    proc rattleCAD::view::edit::single_DownTube_HeadTubeOffset          {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(DownTube/OffsetHT)                   ;# Custom(DownTube/OffsetHT)                     }
    proc rattleCAD::view::edit::single_DownTube_LowerCageOffsetBB       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(BottleCage/DownTube_Lower)           ;# Component(BottleCage/DownTube_Lower/OffsetBB) }
    proc rattleCAD::view::edit::single_Fork_Height                      {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/Fork_Height)                ;# Component(Fork/Height)                        }
    proc rattleCAD::view::edit::single_Fork_Rake                        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/Fork_Rake)                  ;# Component(Fork/Rake)                          }
    proc rattleCAD::view::edit::single_FrontBrake_LeverLength           {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(FrontBrake/LeverLength)              ;# Component(Brake/Front/LeverLength)            }
    proc rattleCAD::view::edit::single_FrontBrake_Offset                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Fork/BladeBrakeOffset)               ;# Component(Brake/Front/Offset)                 }
    # proc rattleCAD::view::edit::single_FrontBrake_Offset              {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(FrontBrake/Offset)                   ;# Component(Brake/Front/Offset)                 }
    proc rattleCAD::view::edit::single_FrontWheel_RimHeight             {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(FrontWheel/RimHeight)                ;# Component(Wheel/Front/RimHeight)              }
    proc rattleCAD::view::edit::single_HeadSet_BottomHeight             {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(HeadSet/Height_Bottom)               ;# Component(HeadSet/Height/Bottom)              }
    proc rattleCAD::view::edit::single_HeadSet_TopHeight                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(HeadSet/Height_Top)                  ;# Component(HeadSet/Height/Top)                 }
    proc rattleCAD::view::edit::single_HeadTube_Angle                   {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/HeadTube_Angle)             ;# Custom(HeadTube/Angle)                        }
    proc rattleCAD::view::edit::single_HeadTube_Diameter                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(HeadTube/Diameter)                   ;# FrameTubes(HeadTube/Diameter)                 }
    proc rattleCAD::view::edit::single_HeadTube_Length                  {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(HeadTube/Length)                     ;# FrameTubes(HeadTube/Length)                   }
    proc rattleCAD::view::edit::single_Personal_HandleBarDistance       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/HandleBar_Distance)         ;# Personal(HandleBar_Distance)                  }
    proc rattleCAD::view::edit::single_Personal_HandleBarHeight         {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/HandleBar_Height)           ;# Personal(HandleBar_Height)                    }
    proc rattleCAD::view::edit::single_Personal_InnerLegLength          {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/Inseam_Length)              ;# Personal(InnerLeg_Length)                     }
    proc rattleCAD::view::edit::single_Personal_SaddleDistance          {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/Saddle_Distance)            ;# Personal(Saddle_Distance)                     }
    proc rattleCAD::view::edit::single_Personal_SaddleHeight            {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/Saddle_Height)              ;# Personal(Saddle_Height)                       }
    proc rattleCAD::view::edit::single_RearBrake_LeverLength            {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(RearBrake/LeverLength)               ;# Component(Brake/Rear/LeverLength)             }
    proc rattleCAD::view::edit::single_RearBrake_Offset                 {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(RearBrake/Offset)                    ;# Component(Brake/Rear/Offset)                  }
    proc rattleCAD::view::edit::single_RearDropOut_CS_Offset            {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(RearDropout/OffsetCS)                ;# Lugs(RearDropOut/ChainStay/Offset)            }
    proc rattleCAD::view::edit::single_RearDropOut_CS_OffsetTopView     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(RearDropout/OffsetCS_TopView)        ;# Lugs(RearDropOut/ChainStay/Offset_TopView)    }
    proc rattleCAD::view::edit::single_RearHub_DiscOffset               {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(RearMockup/DiscOffset)               ;# Rendering(RearMockup/DiscOffset)              }
    proc rattleCAD::view::edit::single_RearHub_FirstSprocket            {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   text://Scalar(RearWheel/FirstSprocket)      ;# text://Component(Wheel/Rear/FirstSprocket)    }
    proc rattleCAD::view::edit::single_RearHub_Width                    {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(RearWheel/HubWidth)                  ;# Component(Wheel/Rear/HubWidth)                }
    proc rattleCAD::view::edit::single_RearWheel_Distance               {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/ChainStay_Length)           ;# Scalar(Geometry/ChainStay_Length)             }
    proc rattleCAD::view::edit::single_RearWheel_RimHeight              {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(RearWheel/RimHeight)                 ;# Component(Wheel/Rear/RimHeight)               }
    proc rattleCAD::view::edit::single_RearWheel_TyreWidth              {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(RearWheel/TyreWidth)                 ;# Component(Wheel/Rear/TyreWidth)               }
    proc rattleCAD::view::edit::single_RearWheel_TyreWidthRadius        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(RearWheel/TyreWidthRadius)           ;# Component(Wheel/Rear/TyreWidthRadius)         }
    proc rattleCAD::view::edit::single_Reference_HandleBarDistance      {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Reference/HandleBar_Distance)        ;# Reference(HandleBar_Distance)                 }
    proc rattleCAD::view::edit::single_Reference_HandleBarHeight        {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Reference/HandleBar_Height)          ;# Reference(HandleBar_Height)                   }
    proc rattleCAD::view::edit::single_Reference_SaddleNoseDistance     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Reference/SaddleNose_Distance)       ;# Reference(SaddleNose_Distance)                }
    proc rattleCAD::view::edit::single_Reference_SaddleNoseHeight       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Reference/SaddleNose_Height)         ;# Reference(SaddleNose_Height)                  }
    proc rattleCAD::view::edit::single_SaddleHeightComponent            {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Saddle/Height)                       ;# Component(Saddle/Height)                      }
    proc rattleCAD::view::edit::single_SeatPost_Diameter                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(SeatPost/Diameter)                   ;# Component(SeatPost/Diameter)                  }
    proc rattleCAD::view::edit::single_SeatPost_PivotOffset             {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(SeatPost/PivotOffset)                ;# Component(SeatPost/PivotOffset)               }
    proc rattleCAD::view::edit::single_SeatPost_Setback                 {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(SeatPost/Setback)                    ;# Component(SeatPost/Setback)                   }
    proc rattleCAD::view::edit::single_SeatStay_OffsetTT                {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(SeatStay/OffsetTT)                   ;# Custom(SeatStay/OffsetTT)                     }
    proc rattleCAD::view::edit::single_SeatTube_BottomBracketOffset     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(SeatTube/OffsetBB)                   ;# Custom(SeatTube/OffsetBB)                     }
    proc rattleCAD::view::edit::single_SeatTube_CageOffsetBB            {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(BottleCage/SeatTube)                 ;# Component(BottleCage/SeatTube/OffsetBB)       }
    proc rattleCAD::view::edit::single_SeatTube_Extension               {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(SeatTube/Extension)                  ;# Custom(SeatTube/Extension)                    }
    proc rattleCAD::view::edit::single_Stem_Angle                       {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/Stem_Angle)                 ;# Component(Stem/Angle)                         }
    proc rattleCAD::view::edit::single_Stem_Length                      {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/Stem_Length)                ;# Component(Stem/Length)                        }
    proc rattleCAD::view::edit::single_TopTube_Angle                    {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(Geometry/TopTube_Angle)              ;# Custom(TopTube/Angle)                         }
    proc rattleCAD::view::edit::single_TopTube_HeadTubeOffset           {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(TopTube/OffsetHT)                    ;# Custom(TopTube/OffsetHT)                      }
    proc rattleCAD::view::edit::single_TopTube_PivotPosition            {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   Scalar(TopTube/PivotPosition)               ;# Custom(TopTube/PivotPosition)                 }
    
    proc rattleCAD::view::edit::single_LogoFile                         {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   file://Component(Logo)                        }
    proc rattleCAD::view::edit::single_CrankSetFile                     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   file://Component(CrankSet)                    }
    proc rattleCAD::view::edit::single_RearDerailleurFile               {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   file://Component(RearDerailleur)              }
    proc rattleCAD::view::edit::single_SeatTube_BottleCageFile          {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   list://Config(BottleCage_SeatTube@SELECT_BottleCage)    }
    proc rattleCAD::view::edit::single_DownTube_BottleCageFile          {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   list://Config(BottleCage_DownTube@SELECT_BottleCage)     }
    proc rattleCAD::view::edit::single_DownTube_BottleCageFileLower     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   list://Config(BottleCage_DownTube_Lower@SELECT_BottleCage)   }



    proc rattleCAD::view::edit::group_HandleBar_Parameter               {x y cv_Name} {
            rattleCAD::view::createEdit  $x $y $cv_Name  {                
                file://Component(HandleBar)
                       Scalar(HandleBar/PivotAngle)
              } {HandleBar Parameter - 001} 
    } 
    proc rattleCAD::view::edit::group_DerailleurFront_Parameter_17      {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                file://Component(FrontDerailleur)
                       Scalar(FrontDerailleur/Distance)
                       Scalar(FrontDerailleur/Offset)
              } {DerailleurFront Parameter - 002} 
    } 
    proc rattleCAD::view::edit::group_Crankset_Parameter_16             {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                file://Component(CrankSet)
                       Scalar(CrankSet/Length)
                text://ListValue(CrankSetChainRings)
              } {Crankset:  Parameter - 003} 
    } 
    proc rattleCAD::view::edit::group_Chain_Parameter_15                {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                text://ListValue/CrankSetChainRings)
                       Scalar(RearDerailleur/Pulley_x)
                       Scalar(RearDerailleur/Pulley_y)
                       Scalar(RearDerailleur/Pulley_teeth)
              } {Chain Parameter - 004}
    } 
    proc rattleCAD::view::edit::group_RearBrake_Parameter_14            {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                list://Config(RearBrake@SELECT_BrakeType)
                file://Component(RearBrake)
                       Scalar(RearBrake/LeverLength)
                       Scalar(RearBrake/Offset)
              } {RearBrake Parameter - 005} 
    } 
    proc rattleCAD::view::edit::group_FrontBrake_Parameter_13           {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                list://Config(FrontBrake@SELECT_BrakeType)
                file://Component(FrontBrake)
                       Scalar(FrontBrake/LeverLength)
              } {FrontBrake Parameter - 006} 
    } 
    proc rattleCAD::view::edit::group_Saddle_Parameter_12               {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                file://Component(Saddle)
                       Scalar(Saddle/NoseLength)
                       Scalar(Saddle/Offset_x)
                       Scalar(Saddle/Offset_y)
                       Scalar(Geometry/SaddleNose_BB_x)
              } {Saddle Parameter - 007} 
    } 
    proc rattleCAD::view::edit::group_HeadSet_Parameter_10              {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                       Scalar(HeadSet/Height_Top)
                       Scalar(HeadSet/Diameter)
              } {HeadSet Parameter - 008} 
    } 
    proc rattleCAD::view::edit::group_HeadSet_Parameter_09              {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                       Scalar(HeadSet/Height_Bottom)
                       Scalar(HeadSet/Diameter)
              } {HeadSet Parameter - 009} 
    } 
    proc rattleCAD::view::edit::group_FrontFender_Parameter_08          {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                list://Config(RearFender@SELECT_Binary_OnOff)
                       Scalar(RearFender/Radius)
                       Scalar(RearFender/Height)
                       Scalar(RearFender/OffsetAngle)
              } {FrontFender Parameter - 010} 
    } 
    proc rattleCAD::view::edit::group_FrontWheel_Parameter_03           {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                list://Config(FrontFender@SELECT_Binary_OnOff)
                       Scalar(FrontFender/Radius)
                       Scalar(FrontFender/Height)
                       Scalar(FrontFender/OffsetAngleFront)
                       Scalar(FrontFender/OffsetAngle)
              } {FrontWheel Parameter - 011} 
    } 
    proc rattleCAD::view::edit::group_CarrierFront_Parameter_07         {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                file://Component(FrontCarrier)
                       Scalar(FrontCarrier/x)
                       Scalar(FrontCarrier/y)
              } {CarrierFront Parameter - 012} 
    } 
    proc rattleCAD::view::edit::group_CarrierRear_Parameter_11          {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                file://Component(RearCarrier)
                       Scalar(RearCarrier/x)
                       Scalar(RearCarrier/y)
              } {CarrierRear Parameter - 013} 
    } 
    proc rattleCAD::view::edit::group_DownTube_Parameter_06             {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                       Scalar(DownTube/DiameterHT)
                       Scalar(DownTube/DiameterBB)
                       Scalar(DownTube/TaperLength)
              } {DownTube Parameter - 014} 
    } 
    proc rattleCAD::view::edit::group_SeatTube_Parameter_05             {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                       Scalar(SeatStay/SeatTubeMiterDiameter)
                       Scalar(SeatTube/DiameterTT)
                       Scalar(SeatTube/DiameterBB)
                       Scalar(SeatTube/TaperLength)
              } {SeatTube Parameter - 015} 
    } 
    proc rattleCAD::view::edit::group_TopTube_Parameter_04              {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {                
                       Scalar(TopTube/DiameterHT)
                       Scalar(TopTube/DiameterST)
                       Scalar(TopTube/TaperLength)
                       Scalar(Geometry/TopTube_Angle)
              } {TopTube Parameter - 016} 
    } 
    proc rattleCAD::view::edit::group_ChainStay_Parameter_01            {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                       Scalar(ChainStay/DiameterSS)
                       Scalar(ChainStay/Height)
                       Scalar(ChainStay/HeigthBB)
                       Scalar(ChainStay/TaperLength)
                       Scalar(RearDropout/OffsetCSPerp)
                       Scalar(RearDropout/OffsetCS)
              } {ChainStay Parameter - 017} 
    } 
    proc rattleCAD::view::edit::group_SeatStay_Parameter_01             {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                       Scalar(SeatStay/SeatTubeMiterDiameter)
                       Scalar(SeatStay/DiameterST)
                       Scalar(SeatStay/DiameterCS)
                       Scalar(SeatStay/TaperLength)
                       Scalar(SeatStay/OffsetTT)
                       Scalar(RearDropout/OffsetSSPerp)
                       Scalar(RearDropout/OffsetSS)
              } {SeatStay Parameter - 018} 
    } 
    proc rattleCAD::view::edit::group_RearDropout_Parameter_01          {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                file://Component(RearDropout)
                list://Config(RearDropoutOrient@SELECT_DropOutDirection)
                list://Config(RearDropout@SELECT_DropOutPosition)
                       Scalar(RearDropout/RotationOffset)
                       Scalar(RearDropout/Derailleur_x)
                       Scalar(RearDropout/Derailleur_y)
                       Scalar(RearDropout/OffsetSSPerp)
                       Scalar(RearDropout/OffsetSS)
                       Scalar(RearDropout/OffsetCSPerp)
                       Scalar(RearDropout/OffsetCS)
              } {RearDropout Parameter - 019} 
    } 
    proc rattleCAD::view::edit::group_BottomBracket_Diameter_01         {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                       Scalar(BottomBracket/OutsideDiameter)
                       Scalar(BottomBracket/InsideDiameter)
              } {BottomBracket Diameter - 020} 
    } 
    proc rattleCAD::view::edit::group_HeadTube_Parameter_01             {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                       Scalar(HeadTube/Length)
                       Scalar(HeadSet/Height_Bottom)
              } {Head Tube Parameter - 021} 
    } 
    proc rattleCAD::view::edit::group_Saddle_Parameter_01               {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                       Scalar(Geometry/SaddleNose_BB_x)
                       Scalar(Saddle/NoseLength)
                       Scalar(Saddle/Offset_x)
              } {Saddle Parameter - 022} 
    } 
    proc rattleCAD::view::edit::group_FrontWheel_Parameter_01           {x y cv_Name} {
          rattleCAD::view::createEdit  $x $y $cv_Name  {
                list://Scalar(Geometry/FrontRim_Diameter@SELECT_Rim)
                       Scalar(Geometry/FrontTyre_Height)
              } {Front Wheel Parameter - 023} 
    } 
    proc rattleCAD::view::edit::group_FrontWheel_Parameter_02           {x y cv_Name} {
            rattleCAD::view::createEdit  $x $y $cv_Name  { \            
                list://Scalar(Geometry/FrontRim_Diameter@SELECT_Rim)
                       Scalar(Geometry/FrontWheel_Radius)
                } {Front Wheel Parameter - 024} 
    } 
              
              
              
        #     
        # -- Fork - Settings ------------------------------                            
        #     
    proc rattleCAD::view::edit::group_ForkCrown_Parameter               {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name  {
                list://Config(Fork@SELECT_ForkType)
                file://Component(ForkCrown)
                       Scalar(Fork/CrownAngleBrake)
                       Scalar(Fork/CrownOffsetBrake)
                       Scalar(Fork/BladeOffsetCrown)
                       Scalar(Fork/BladeOffsetCrownPerp)
                } {ForkCrown Parameter - 025} 
    } 
    proc rattleCAD::view::edit::group_ForkBlade_Parameter               {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name  {
                list://Config(ForkBlade@SELECT_ForkBladeType)
                       Scalar(Fork/BladeWidth)
                       Scalar(Fork/BladeDiameterDO)
                       Scalar(Fork/BladeTaperLength)
                       Scalar(Fork/BladeBendRadius)
                       Scalar(Fork/BladeEndLength)
               } {ForkBlade Parameter - 026}
    } 
    proc rattleCAD::view::edit::group_ForkDropout_Parameter             {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name {
                file://Component(ForkDropout)
                list://Config(ForkDropout@SELECT_DropOutPosition)
                       Scalar(Fork/BladeOffsetDO)
                       Scalar(Fork/BladeOffsetDOPerp)
                } {ForkDropout Parameter - 027}
    } 
              
        #     
        # -- Lug - Settings -------------------------------                            
        #     
        #     
        # -- Frame Details -- Lug Specification -----------                            
        #     
    proc rattleCAD::view::edit::lugSpec_RearDropout                     {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name {
                       Scalar(Lugs/RearDropOut_Angle)
                       Scalar(Lugs/RearDropOut_Tolerance)
                } {nLug Specification:  RearDropout - 028}                            
    } 
    proc rattleCAD::view::edit::lugSpec_SeatTube_DownTube               {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name {
                       Scalar(Lugs/BottomBracket_DownTube_Angle)
                       Scalar(Lugs/BottomBracket_DownTube_Tolerance)
                } "Lug Specification:  SeatTube/DownTube  - 029"                      
    } 
    proc rattleCAD::view::edit::lugSpec_SeatTube_ChainStay              {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name {
                       Scalar(Lugs/BottomBracket_ChainStay_Angle)
                       Scalar(Lugs/BottomBracket_ChainStay_Tolerance)
                } "Lug Specification:  SeatTube/ChainStay - 030"      
    } 
    proc rattleCAD::view::edit::lugSpec_SeatTube_TopTube                {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name {
                       Scalar(Lugs/SeatLug_TopTube_Angle)
                       Scalar(Lugs/SeatLug_TopTube_Tolerance)
                } "Lug Specification:  SeatTube/TopTube - 031"                       
    } 
    proc rattleCAD::view::edit::lugSpec_SeatTube_SeatStay               {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name {
                       Scalar(Lugs/SeatLug_SeatStay_Angle)
                       Scalar(Lugs/SeatLug_SeatStay_Tolerance)
                       Scalar(SeatStay/SeatTubeMiterDiameter)
                } "Lug Specification:  SeatTube/SeatStay - 032"                      
    } 
    proc rattleCAD::view::edit::lugSpec_HeadTube_TopTube                {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name {
                       Scalar(Lugs/HeadLug_Top_Angle)
                       Scalar(Lugs/HeadLug_Top_Tolerance)
                } "Lug Specification:  HeadTube/TopTube - 033"                       
    } 
    proc rattleCAD::view::edit::lugSpec_HeadTube_DownTube               {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name {
                       Scalar(Lugs/HeadLug_Bottom_Angle)
                       Scalar(Lugs/HeadLug_Bottom_Tolerance)
                } "Lug Specification:  HeadTube/DownTube - 034"                      
    } 
              
              
        #     
        # -- Base Concept ---------------------------------                            
        #     
    proc rattleCAD::view::edit::group_RearWheel_Parameter               {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name {
                list://Scalar(Geometry/RearRim_Diameter@SELECT_Rim)
                       Scalar(Geometry/RearTyre_Height)
                } "Rear Wheel Parameter - 035"                        
    } 
    proc rattleCAD::view::edit::group_FrontGeometry                     {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name {
                       Scalar(Geometry/Stem_Angle)
                       Scalar(Geometry/Stem_Length)
                       Scalar(Geometry/Fork_Height)
                       Scalar(Geometry/Fork_Rake)
                } "Steerer/Fork:  Settings - 036"                     
    } 
    proc rattleCAD::view::edit::group_BottomBracket_DepthHeight         {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name {
                       Scalar(Geometry/BottomBracket_Depth)
                       Scalar(Geometry/BottomBracket_Height)
                } "BottomBracket:  Settings - 037"                    
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
    proc rattleCAD::view::edit::group_RearDerailleur_Mount              {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name {
                file://Component(RearDropout)
                list://Config(RearDropoutOrient@SELECT_DropOutDirection)
                list://Config(RearDropout@SELECT_DropOutPosition)
                       Scalar(RearDropout/RotationOffset)
                       Scalar(RearDropout/Derailleur_x)
                       Scalar(RearDropout/Derailleur_y)
                } "Rear Derailleur Mount - 038"                       
    } 
              
              
        #     
        # -- Rear Mockup ----------------------------------                            
        #     
    proc rattleCAD::view::edit::group_RearDiscBrake                     {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name {
                       Scalar(RearMockup/DiscDiameter)
                       Scalar(RearMockup/DiscWidth)
                       Scalar(RearMockup/DiscClearance)
                } "DiscBrake Details - 039"                           
    } 
    proc rattleCAD::view::edit::group_RearTyre_Parameter                {x y cv_Name} {
            # title { Rear Tyre Parameter} #                            
            rattleCAD::view::createEdit $x $y $cv_Name {
                       Scalar(RearWheel/TyreWidthRadius)
                       Scalar(RearWheel/TyreWidth)
                       Scalar(RearMockup/TyreClearance)
                } " Rear Tyre Parameter - 040"                        
    } 
        #     
        #     
    proc rattleCAD::view::edit::group_ChainStay_Centerline_Bent01       {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name {
                       Scalar(ChainStay/segmentAngle_01)
                       Scalar(ChainStay/segmentRadius_01)
                       Scalar(ChainStay/segmentLength_01)
                       Scalar(ChainStay/segmentLength_02)
                } "ChainStay:  Bent 01 - 041"                         
    } 
    proc rattleCAD::view::edit::group_ChainStay_Centerline_Bent02       {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name {
                       Scalar(ChainStay/segmentAngle_02)
                       Scalar(ChainStay/segmentRadius_02)
                       Scalar(ChainStay/segmentLength_02)
                       Scalar(ChainStay/segmentLength_03)
                } "ChainStay:  Bent 02 - 042"                         
    } 
    proc rattleCAD::view::edit::group_ChainStay_Centerline_Bent03       {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name {
                       Scalar(ChainStay/segmentAngle_03)
                       Scalar(ChainStay/segmentRadius_03)
                       Scalar(ChainStay/segmentLength_03)
                       Scalar(ChainStay/segmentLength_04)
                } "ChainStay:  Bent 03 - 043"                         
    } 
    proc rattleCAD::view::edit::group_ChainStay_Centerline_Bent04       {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name {
                       Scalar(ChainStay/segmentAngle_04)
                       Scalar(ChainStay/segmentRadius_04)
                       Scalar(ChainStay/segmentLength_04)
                } "ChainStay:  Bent 04 - 044"                         
    } 
    proc rattleCAD::view::edit::group_RearHub_Parameter                 {x y cv_Name} {
                # Line 491:                                             
            rattleCAD::view::createEdit $x $y $cv_Name {
                       Scalar(RearWheel/HubWidth)
                text://Scalar(RearWheel/FirstSprocket)
                } "RearHub:  Parameter - 045"                         
    } 
    proc rattleCAD::view::edit::group_Crankset_Parameter                {x y cv_Name} {
                # Line 623:                                             
            rattleCAD::view::createEdit $x $y $cv_Name {
                       Scalar(CrankSet/ChainLine)
                       Scalar(CrankSet/Q-Factor)
                text://ListValue/CrankSetChainRings)
                } "Crankset:  Parameter - 046"                        
    } 
    proc rattleCAD::view::edit::group_ChainStay_Area                    {x y cv_Name} {
                # Line 782:                                             
            rattleCAD::view::createEdit $x $y $cv_Name {
                list://Config(ChainStay@SELECT_ChainStay)
                       Scalar(RearMockup/TyreClearance)
                       Scalar(RearMockup/ChainWheelClearance)
                       Scalar(RearMockup/CrankClearance)
                       Scalar(RearMockup/CassetteClearance)
                } "ChainStay:  Area - 047"
    }
    proc rattleCAD::view::edit::group_Rendering_Parameter               {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name  {
                list://Config(Fork@SELECT_ForkType)
                list://Config(ForkBlade@SELECT_ForkBladeType)
                list://Config(FrontBrake@SELECT_BrakeType)
                list://Config(RearBrake@SELECT_BrakeType)
                list://Config(BottleCage_SeatTube@SELECT_BottleCage)
                list://Config(BottleCage_DownTube@SELECT_BottleCage)
                list://Config(BottleCage_DownTube_Lower@SELECT_BottleCage)
                list://Config(FrontFender@SELECT_Binary_OnOff)
                list://Config(RearFender@SELECT_Binary_OnOff)
                file://Component(FrontCarrier)
                file://Component(RearCarrier)
               } "Rendering: - 099"
    } 

