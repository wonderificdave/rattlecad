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
    proc rattleCAD::view::edit::option_ChainStay {x y cv_Name} {        
            rattleCAD::view::createEdit  $x $y $cv_Name     list://Rendering(ChainStay@SELECT_ChainStay)
    }
    proc rattleCAD::view::edit::option_FrontFenderBinary {x y cv_Name} { 
                # title { FrontWheel Parameter } #
            rattleCAD::view::createEdit  $x $y $cv_Name     list://Rendering(Fender/Front@SELECT_Binary_OnOff)
    }    
    proc rattleCAD::view::edit::option_RearFenderBinary {x y cv_Name} { 
                # title { FrontWheel Parameter } #
            rattleCAD::view::createEdit  $x $y $cv_Name     list://Rendering(Fender/Rear@SELECT_Binary_OnOff) 
    }    
    proc rattleCAD::view::edit::option_DownTubeUpperCage {x y cv_Name} {
                # title {  BottleCage DownTube-Upper Parameter } #
            rattleCAD::view::createEdit  $x $y $cv_Name     list://Rendering(BottleCage/DownTube@SELECT_BottleCage) 
    }
    proc rattleCAD::view::edit::option_DownTubeLowerCage {x y cv_Name} { 
                # title {  BottleCage DownTube-Lower Parameter } #
            rattleCAD::view::createEdit  $x $y $cv_Name     list://Rendering(BottleCage/DownTube_Lower@SELECT_BottleCage)
    }
    proc rattleCAD::view::edit::option_SeatTubCage {x y cv_Name} { 
                # title {  BottleCage SeatTube Parameter } #
            rattleCAD::view::createEdit  $x $y $cv_Name     list://Rendering(BottleCage/SeatTube@SELECT_BottleCage) 
    }


        #
        # -- Fork - Settings ------------------------------
        #
    proc rattleCAD::view::edit::option_ForkType {x y cv_Name} { 
                # title { ForkCrown Parameter } #
            rattleCAD::view::createEdit  $x $y $cv_Name \
                    list://Rendering(Fork@SELECT_ForkType)
    }
    proc rattleCAD::view::edit::group_ForkCrownParameter {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name  { \
                    list://Rendering(Fork@SELECT_ForkType) \
                    file://Component(Fork/Crown/File) \
                    Component(Fork/Crown/Brake/Angle) \
                    Component(Fork/Crown/Brake/Offset) \
                    Component(Fork/Crown/Blade/Offset) \
                    Component(Fork/Crown/Blade/OffsetPerp) \
                }   {ForkCrown Parameter}
    }
    proc rattleCAD::view::edit::group_ForkBladeParameter {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name  { \
                   list://Rendering(ForkBlade@SELECT_ForkBladeType) \
                   Component(Fork/Blade/Width) \
                   Component(Fork/Blade/DiameterDO) \
                   Component(Fork/Blade/TaperLength) \
                   Component(Fork/Blade/BendRadius) \
                   Component(Fork/Blade/EndLength) \
               }  {ForkBlade Parameter}
    }
    proc rattleCAD::view::edit::group_ForkDropoutParameter {x y cv_Name} {
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
        # -- Base Concept ---------------------------------
        #
    proc rattleCAD::view::edit::single_BottomBracketHeight {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name      Result(Length/BottomBracket/Height) 
    }
    
   proc rattleCAD::view::edit::group_RearWheelParameter {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    list://Component(Wheel/Rear/RimDiameter@SELECT_Rim) \
                    Result(Length/RearWheel/Radius)  \
                }   "new - Rear Wheel Parameter"
    }
    
        
        #
        # -- TopTube --------------------------------------
        #
    proc rattleCAD::view::edit::single_TopTube_Angle {x y cv_Name} {
                #Line 1456:        {TopTube Angle}]                                             
            rattleCAD::view::createEdit $x $y $cv_Name      Custom(TopTube/Angle)             
    }  
        
        
        #
        # -- SeatTube -------------------------------------
        #
    proc rattleCAD::view::edit::single_SeatTube_CageOffsetBB {x y cv_Name} {
                # {BottleCage DownTube Lower Offset}  
            rattleCAD::view::createEdit $x $y $cv_Name      Component(BottleCage/SeatTube/OffsetBB)   
    }
    
        
        #
        # -- DownTube -------------------------------------
        #
    proc rattleCAD::view::edit::single_DownTube_CageOffsetBB {x y cv_Name} {
                # {BottleCage DownTube Lower Offset}  
            rattleCAD::view::createEdit $x $y $cv_Name      Component(BottleCage/DownTube/OffsetBB)   
    }
    proc rattleCAD::view::edit::single_DownTube_LowerCageOffsetBB {x y cv_Name} {
                # {BottleCage DownTube Lower Offset}  
            rattleCAD::view::createEdit $x $y $cv_Name      Component(BottleCage/DownTube_Lower/OffsetBB)   
    }

            
        #
        # -- SeatStay -------------------------------------
        #
    proc rattleCAD::view::edit::single_SeatStayOffsetTT {x y cv_Name} {
                # {SeatStay OffsetTopTube}
            rattleCAD::view::createEdit $x $y $cv_Name      Custom(SeatStay/OffsetTT)
    }
        
        #
        # -- Rear Frame -----------------------------------
        #
     proc rattleCAD::view::edit::group_RearDerailleurMount {x y cv_Name} {
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
        # -- Component Brake ------------------------------
        #
    proc rattleCAD::view::edit::single_FrontBrake_Offset {x y cv_Name} {
                # {Front Brake Offset}
            rattleCAD::view::createEdit $x $y $cv_Name      Component(Brake/Front/Offset) 
    }
    proc rattleCAD::view::edit::single_FrontBrake_LeverLength {x y cv_Name} {
                # {Front Brake LeverLength}
            rattleCAD::view::createEdit $x $y $cv_Name      Component(Brake/Front/LeverLength) 
    }
   proc rattleCAD::view::edit::single_RearBrake_Offset {x y cv_Name} {
                # {Rear Brake Offset}
            rattleCAD::view::createEdit $x $y $cv_Name      Component(Brake/Rear/Offset) 
    }
    proc rattleCAD::view::edit::single_RearBrake_LeverLength {x y cv_Name} {
                # {Rear Brake LeverLength}
            rattleCAD::view::createEdit $x $y $cv_Name      Component(Brake/Rear/LeverLength) 
    }
    

    proc rattleCAD::view::edit::single_DownTube_BottomBracketOffset {x y cv_Name} {
                #Line 1417:        {DownTube Offset BottomBracket}]                             
            rattleCAD::view::createEdit $x $y $cv_Name      Custom(DownTube/OffsetBB) 
    }  
    proc rattleCAD::view::edit::single_SeatTube_BottomBracketOffset {x y cv_Name} {
                #Line 1436:        {SeatTube Offset BottomBracket}]                             
            rattleCAD::view::createEdit $x $y $cv_Name      Custom(SeatTube/OffsetBB) 
    }  
    proc rattleCAD::view::edit::single_HeadTubeTopTubeAngle {x y cv_Name} {
                #Line 1465:        {HeadTube TopTube Angle}]                                    
            rattleCAD::view::createEdit $x $y $cv_Name      Result(Angle/HeadTube/TopTube)        
    }  
    proc rattleCAD::view::edit::single_ForkHeight {x y cv_Name} {
                #Line 1474:        {Fork Height}]                                               
            rattleCAD::view::createEdit $x $y $cv_Name      Component(Fork/Height)                 
    }  
    proc rattleCAD::view::edit::single_HeadSetTopHeight {x y cv_Name} {
                #Line 1483:        {HeadSet Top Height}]                                        
            rattleCAD::view::createEdit $x $y $cv_Name      Component(HeadSet/Height/Top)             
    }  
    proc rattleCAD::view::edit::single_HeadSetBottomHeight {x y cv_Name} {
                #Line 1492:        {HeadSet Bottom Height}]                                     
            rattleCAD::view::createEdit $x $y $cv_Name      Component(HeadSet/Height/Bottom)        
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

    proc rattleCAD::view::edit::single_ChainStayProfile_LengthComplete {x y cv_Name} { 
            rattleCAD::view::createEdit $x $y $cv_Name      FrameTubes(ChainStay/Profile/completeLength)
    }
    proc rattleCAD::view::edit::single_ChainStayProfile_LengthCut {x y cv_Name} { 
            rattleCAD::view::createEdit $x $y $cv_Name      FrameTubes(ChainStay/Profile/cuttingLength)
    }
        #
    proc rattleCAD::view::edit::single_ChainStayProfile_Length01 {x y cv_Name} { 
            rattleCAD::view::createEdit $x $y $cv_Name      FrameTubes(ChainStay/Profile/length_01)
    }
    proc rattleCAD::view::edit::single_ChainStayProfile_Length02 {x y cv_Name} { 
            rattleCAD::view::createEdit $x $y $cv_Name      FrameTubes(ChainStay/Profile/length_02)
    }
    proc rattleCAD::view::edit::single_ChainStayProfile_Length03 {x y cv_Name} { 
            rattleCAD::view::createEdit $x $y $cv_Name      FrameTubes(ChainStay/Profile/length_03)
    }
        #
    proc rattleCAD::view::edit::single_ChainStayProfile_Width00 {x y cv_Name} { 
            rattleCAD::view::createEdit $x $y $cv_Name      FrameTubes(ChainStay/Profile/width_00)
    }
    proc rattleCAD::view::edit::single_ChainStayProfile_Width01 {x y cv_Name} { 
            rattleCAD::view::createEdit $x $y $cv_Name      FrameTubes(ChainStay/Profile/width_01)
    }
    proc rattleCAD::view::edit::single_ChainStayProfile_Width02 {x y cv_Name} { 
            rattleCAD::view::createEdit $x $y $cv_Name      FrameTubes(ChainStay/Profile/width_02)
    }
    proc rattleCAD::view::edit::single_ChainStayProfile_Width03 {x y cv_Name} { 
            rattleCAD::view::createEdit $x $y $cv_Name      FrameTubes(ChainStay/Profile/width_03)
    }
        #
    proc rattleCAD::view::edit::single_ChainStayCenterline_Length01 {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name      FrameTubes(ChainStay/CenterLine/length_01)
    }
    proc rattleCAD::view::edit::single_ChainStayCenterline_Length02 {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name      FrameTubes(ChainStay/CenterLine/length_02)
    }
    proc rattleCAD::view::edit::single_ChainStayCenterline_Length03 {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name      FrameTubes(ChainStay/CenterLine/length_03)
    }
    proc rattleCAD::view::edit::single_ChainStayCenterline_Length04 {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name      FrameTubes(ChainStay/CenterLine/length_04)
    }
        #
    proc rattleCAD::view::edit::group_ChainStayCenterline_Bent01 {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    FrameTubes(ChainStay/CenterLine/angle_01) \
                    FrameTubes(ChainStay/CenterLine/radius_01) \
                    FrameTubes(ChainStay/CenterLine/length_01) \
                    FrameTubes(ChainStay/CenterLine/length_02) \
                }   "new - ChainStay:  Bent 01"   
    }
    proc rattleCAD::view::edit::group_ChainStayCenterline_Bent02 {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    FrameTubes(ChainStay/CenterLine/angle_02) \
                    FrameTubes(ChainStay/CenterLine/radius_02) \
                    FrameTubes(ChainStay/CenterLine/length_02) \
                    FrameTubes(ChainStay/CenterLine/length_03) \
                }   "new - ChainStay:  Bent 02"   
    }
    proc rattleCAD::view::edit::group_ChainStayCenterline_Bent03 {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    FrameTubes(ChainStay/CenterLine/angle_03) \
                    FrameTubes(ChainStay/CenterLine/radius_03) \
                    FrameTubes(ChainStay/CenterLine/length_03) \
                    FrameTubes(ChainStay/CenterLine/length_04) \
                }   "new - ChainStay:  Bent 03"   
    }
    proc rattleCAD::view::edit::group_ChainStayCenterline_Bent04 {x y cv_Name} {
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    FrameTubes(ChainStay/CenterLine/angle_04) \
                    FrameTubes(ChainStay/CenterLine/radius_04) \
                    FrameTubes(ChainStay/CenterLine/length_04) \
                }   "new - ChainStay:  Bent 04" 
    }
    proc rattleCAD::view::edit::group_RearHubParameter {x y cv_Name} {
                # Line 491:
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Component(Wheel/Rear/HubWidth) \
                    text://Component(Wheel/Rear/FirstSprocket) \
                }   "new - RearHub:  Parameter"
    }
    proc rattleCAD::view::edit::single_RearHubFirstSprocket {x y cv_Name} {
                # Line 494: "new - RearHub:  First Sprocket"
            rattleCAD::view::createEdit $x $y $cv_Name      text://Component(Wheel/Rear/FirstSprocket) 
    }                    
    proc rattleCAD::view::edit::group_CranksetParameter {x y cv_Name} {
                # Line 623:
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    Component(CrankSet/ChainLine) Component(CrankSet/Q-Factor) \
                    text://Component(CrankSet/ChainRings) \
                }   "new - Crankset:  Parameter"
    }
    proc rattleCAD::view::edit::group_ChainStayArea {x y cv_Name} {
                # Line 782:
            rattleCAD::view::createEdit $x $y $cv_Name { \
                    list://Rendering(ChainStay@SELECT_ChainStay) \
                    Rendering(RearMockup/TyreClearance) \
                    Rendering(RearMockup/ChainWheelClearance) \
                    Rendering(RearMockup/CrankClearance) \
                    Rendering(RearMockup/CassetteClearance) \
                }   "new - ChainStay:  Area"
    }                
    proc rattleCAD::view::edit::single_Result_RearWheelTyreShoulder {x y cv_Name} {
                # Line 312:    $_dim_Tyre_CapHeight       single_Result_RearWheelTyreShoulder             
            rattleCAD::view::createEdit $x $y $cv_Name      Result(Length/RearWheel/TyreShoulder) 
    }
    proc rattleCAD::view::edit::single_RearWheelTyreWidth {x y cv_Name} {
                # Line 313:    $_dim_Tyre_Width           single_RearWheelTyreWidth                       
            rattleCAD::view::createEdit $x $y $cv_Name      Component(Wheel/Rear/TyreWidth) 
    }
    proc rattleCAD::view::edit::single_RearWheelTyreWidthRadius {x y cv_Name} {
                # Line 314:    $_dim_Tyre_Radius          single_RearWheelTyreWidthRadius                 
            rattleCAD::view::createEdit $x $y $cv_Name      Component(Wheel/Rear/TyreWidthRadius) 
    }
    proc rattleCAD::view::edit::single_RearWheelDistance {x y cv_Name} {
                # Line 322:    $_dim_CS_Length            single_RearWheelDistance                        
            rattleCAD::view::createEdit $x $y $cv_Name      Custom(WheelPosition/Rear) 
    }
    proc rattleCAD::view::edit::single_BottomBracketInsideDiameter {x y cv_Name} {
                # Line 342:    $_dim_BB_Diam_inside       single_BottomBracketInsideDiameter              
            rattleCAD::view::createEdit $x $y $cv_Name      Lugs(BottomBracket/Diameter/inside) 
    }
    proc rattleCAD::view::edit::single_BottomBracketOutsideDiameter {x y cv_Name} {
                # Line 343:    $_dim_BB_Diam_outside      single_BottomBracketOutsideDiameter             
            rattleCAD::view::createEdit $x $y $cv_Name      Lugs(BottomBracket/Diameter/outside) 
    }
    proc rattleCAD::view::edit::single_BottomBracketWidth {x y cv_Name} {
                # Line 344:    $_dim_BB_Width             single_BottomBracketWidth                       
            rattleCAD::view::createEdit $x $y $cv_Name      Lugs(BottomBracket/Width) 
    }
    proc rattleCAD::view::edit::single_BottomBracketChainStayOffset_TopView {x y cv_Name} {
                # Line 345:    $_dim_CS_BB_Offset         single_BottomBracketChainStayOffset_TopView     
            rattleCAD::view::createEdit $x $y $cv_Name      Lugs(BottomBracket/ChainStay/Offset_TopView) 
    }
    proc rattleCAD::view::edit::single_RearHubDiscOffset {x y cv_Name} {
                # Line 359:    $_dim_BrakeDisc_Dist_Hub   single_RearHubDiscOffset                        
            rattleCAD::view::createEdit $x $y $cv_Name      Rendering(RearMockup/DiscOffset) 
    }
    proc rattleCAD::view::edit::single_RearHubWidth {x y cv_Name} {
                # Line 375:    $_dim_Hub_Width            single_RearHubWidth                             
            rattleCAD::view::createEdit $x $y $cv_Name      Component(Wheel/Rear/HubWidth) 
    }
    proc rattleCAD::view::edit::single_RearDropOutChainStayOffset {x y cv_Name} {
                # Line 376:    $_dim_CS_DO_Distance       single_RearDropOutChainStayOffset               
            rattleCAD::view::createEdit $x $y $cv_Name      Lugs(RearDropOut/ChainStay/Offset) 
    }
    proc rattleCAD::view::edit::single_RearDropOutChainStayOffset_TopView {x y cv_Name} {
                # Line 377:    $_dim_CS_DO_Offset         single_RearDropOutChainStayOffset_TopView       
            rattleCAD::view::createEdit $x $y $cv_Name      Lugs(RearDropOut/ChainStay/Offset_TopView) 
    }
    proc rattleCAD::view::edit::single_CrankSetLength {x y cv_Name} {
                # Line 402:    $_dim_Crank_Length         single_CrankSetLength                           
            rattleCAD::view::createEdit $x $y $cv_Name      Component(CrankSet/Length) 
    }
    proc rattleCAD::view::edit::single_CrankSetPedalEye {x y cv_Name} {
                # Line 403:    $_dim_PedalEye             single_CrankSetPedalEye                         
            rattleCAD::view::createEdit $x $y $cv_Name      Component(CrankSet/PedalEye) 
    }
    proc rattleCAD::view::edit::single_CrankSetQFactor {x y cv_Name} {
                # Line 404:    $_dim_Crank_Q_Factor       single_CrankSetQFactor                          
            rattleCAD::view::createEdit $x $y $cv_Name      Component(CrankSet/Q-Factor) 
    }
    proc rattleCAD::view::edit::single_CrankSetArmWidth {x y cv_Name} {
                # Line 405:    $_dim_CrankArmWidth        single_CrankSetArmWidth                         
            rattleCAD::view::createEdit $x $y $cv_Name      Component(CrankSet/ArmWidth) 
    }
    proc rattleCAD::view::edit::single_CrankSetChainLine {x y cv_Name} {
                # Line 406:    $_dim_ChainLine            single_CrankSetChainLine                        
            rattleCAD::view::createEdit $x $y $cv_Name      Component(CrankSet/ChainLine)      
    }

        
        


    
    
    
    