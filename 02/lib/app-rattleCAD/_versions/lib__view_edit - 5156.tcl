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
    proc rattleCAD::view::edit::optionChainStay {x y cv_Name} {        
            rattleCAD::view::createEdit  $x $y $cv_Name { \
                    list://Rendering(ChainStay@SELECT_ChainStay) \
                 } {ChainStay:  Type}
    }
        
        

        
        
        
        #
        # -- Base Concept ---------------------------------
        #
    proc rattleCAD::view::edit::bottomBracketHeight {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name \
                    Result(Length/BottomBracket/Height) 
    }
    proc rattleCAD::view::edit::rearWheelParameter {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    list://Component(Wheel/Rear/RimDiameter@SELECT_Rim) \
                    Result(Length/RearWheel/Radius)  \
                }   "new - Rear Wheel Parameter"
    }
    
        #
        # -- Frame Details --------------------------------
        #
    proc rattleCAD::view::edit::rearDerailleurMount {x y cv_Name} {
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
        # -- Frame Details -- Lug Specification -----------
        #
    proc rattleCAD::view::edit::lugSpec_RearDropout {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Lugs(RearDropOut/Angle/value) \
                    Lugs(RearDropOut/Angle/plus_minus) \
                }   "new - Lug Specification:  RearDropout"
    }
    proc rattleCAD::view::edit::lugSpec_SeatTube_DownTube {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Lugs(BottomBracket/DownTube/Angle/value) \
                    Lugs(BottomBracket/DownTube/Angle/plus_minus) \
                }   "new - Lug Specification:  SeatTube/DownTube"
    }
    proc rattleCAD::view::edit::lugSpec_SeatTube_ChainStay {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Lugs(BottomBracket/ChainStay/Angle/value) \
                    Lugs(BottomBracket/ChainStay/Angle/plus_minus) \
                }   "new - Lug Specification:  SeatTube/ChainStay"
    }    
    proc rattleCAD::view::edit::lugSpec_SeatTube_TopTube {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Lugs(SeatTube/TopTube/Angle/value)   \
                    Lugs(SeatTube/TopTube/Angle/plus_minus) \
                }   "new - Lug Specification:  SeatTube/TopTube"
    }    
    proc rattleCAD::view::edit::lugSpec_SeatTube_SeatStay {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Lugs(SeatTube/SeatStay/Angle/value) \
                    Lugs(SeatTube/SeatStay/Angle/plus_minus) \
                    Lugs(SeatTube/SeatStay/MiterDiameter) \
                }   "new - Lug Specification:  SeatTube/SeatStay"
    }    
    proc rattleCAD::view::edit::lugSpec_HeadTube_TopTube {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Lugs(HeadTube/TopTube/Angle/value) \
                    Lugs(HeadTube/TopTube/Angle/plus_minus) \
                }   "new - Lug Specification:  HeadTube/TopTube"
    }   
    proc rattleCAD::view::edit::lugSpec_HeadTube_DownTube {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Lugs(HeadTube/DownTube/Angle/value) \
                    Lugs(HeadTube/DownTube/Angle/plus_minus) \
                }   "new - Lug Specification:  HeadTube/DownTube"
    }


        #
        # -- Rear Mockup ----------------------------------
        #
    proc rattleCAD::view::edit::rearDiscBrake {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Rendering(RearMockup/DiscDiameter) \
                    Rendering(RearMockup/DiscWidth) \
                    Rendering(RearMockup/DiscClearance) \
                }   "new - DiscBrake Details"
    }
    proc rattleCAD::view::edit::rearTyreParameter {x y cv_Name} { 
            # title { Rear Tyre Parameter} #
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Component(Wheel/Rear/TyreWidthRadius) \
                    Component(Wheel/Rear/TyreWidth) \
                    Rendering(RearMockup/TyreClearance) \
                }   "new -  Rear Tyre Parameter"
    }        
        
        
    proc rattleCAD::view::edit::chainStayProfile_LengthComplete {x y cv_Name} { 
            rattleCAD::view::createEdit $x $y $cv_Name \
                    FrameTubes(ChainStay/Profile/completeLength)
    }
    proc rattleCAD::view::edit::chainStayProfile_LengthCut {x y cv_Name} { 
            rattleCAD::view::createEdit $x $y $cv_Name \
                    FrameTubes(ChainStay/Profile/cuttingLength)
    }
        #
    proc rattleCAD::view::edit::chainStayProfile_Length01 {x y cv_Name} { 
            rattleCAD::view::createEdit $x $y $cv_Name \
                    FrameTubes(ChainStay/Profile/length_01)
    }
    proc rattleCAD::view::edit::chainStayProfile_Length02 {x y cv_Name} { 
            rattleCAD::view::createEdit $x $y $cv_Name \
                    FrameTubes(ChainStay/Profile/length_02)
    }
    proc rattleCAD::view::edit::chainStayProfile_Length03 {x y cv_Name} { 
            rattleCAD::view::createEdit $x $y $cv_Name \
                    FrameTubes(ChainStay/Profile/length_03)
    }
        #
    proc rattleCAD::view::edit::chainStayProfile_Width00 {x y cv_Name} { 
            rattleCAD::view::createEdit $x $y $cv_Name \
                    FrameTubes(ChainStay/Profile/width_00)
    }
    proc rattleCAD::view::edit::chainStayProfile_Width01 {x y cv_Name} { 
            rattleCAD::view::createEdit $x $y $cv_Name \
                    FrameTubes(ChainStay/Profile/width_01)
    }
    proc rattleCAD::view::edit::chainStayProfile_Width02 {x y cv_Name} { 
            rattleCAD::view::createEdit $x $y $cv_Name \
                    FrameTubes(ChainStay/Profile/width_02)
    }
    proc rattleCAD::view::edit::chainStayProfile_Width03 {x y cv_Name} { 
            rattleCAD::view::createEdit $x $y $cv_Name \
                    FrameTubes(ChainStay/Profile/width_03)
    }
        #
    proc rattleCAD::view::edit::chainStayCenterline_Length01 {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name \
                    FrameTubes(ChainStay/CenterLine/length_01)
    }
    proc rattleCAD::view::edit::chainStayCenterline_Length02 {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name \
                    FrameTubes(ChainStay/CenterLine/length_02)
    }
    proc rattleCAD::view::edit::chainStayCenterline_Length03 {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name \
                    FrameTubes(ChainStay/CenterLine/length_03)
    }
    proc rattleCAD::view::edit::chainStayCenterline_Length04 {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name \
                    FrameTubes(ChainStay/CenterLine/length_04)
    }
        #
    proc rattleCAD::view::edit::chainStayCenterline_Bent01 {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    FrameTubes(ChainStay/CenterLine/angle_01) \
                    FrameTubes(ChainStay/CenterLine/radius_01) \
                    FrameTubes(ChainStay/CenterLine/length_01) \
                    FrameTubes(ChainStay/CenterLine/length_02) \
                }   "new - ChainStay:  Bent 01"   
    }
    proc rattleCAD::view::edit::chainStayCenterline_Bent02 {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    FrameTubes(ChainStay/CenterLine/angle_02) \
                    FrameTubes(ChainStay/CenterLine/radius_02) \
                    FrameTubes(ChainStay/CenterLine/length_02) \
                    FrameTubes(ChainStay/CenterLine/length_03) \
                }   "new - ChainStay:  Bent 02"   
    }
    proc rattleCAD::view::edit::chainStayCenterline_Bent03 {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    FrameTubes(ChainStay/CenterLine/angle_03) \
                    FrameTubes(ChainStay/CenterLine/radius_03) \
                    FrameTubes(ChainStay/CenterLine/length_03) \
                    FrameTubes(ChainStay/CenterLine/length_04) \
                }   "new - ChainStay:  Bent 03"   
    }
    proc rattleCAD::view::edit::chainStayCenterline_Bent04 {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    FrameTubes(ChainStay/CenterLine/angle_04) \
                    FrameTubes(ChainStay/CenterLine/radius_04) \
                    FrameTubes(ChainStay/CenterLine/length_04) \
                }   "new - ChainStay:  Bent 04" 
    }
        
        
        
        
        
        
        
        
        


    
    
    
    