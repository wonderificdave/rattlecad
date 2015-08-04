 ##+##########################################################################
 #
 # package: rattleCAD   ->  model_freeAngle.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2010/11/26
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
 #  namespace:  bikeGeometry::model_freeAngle
 # ---------------------------------------------------------------------------
 #
 # 

 namespace eval bikeGeometry::model_freeAngle {
        #
    namespace export update_ModelGeometry
        #
 }
        #
        # --- update array - Variables
        #
    proc bikeGeometry::model_freeAngle::update_ModelGeometry {} {
            #
        create_GeometryRear
        create_GeometryCenter
        create_GeometryFront
            #
    }
        #
        # --- set basePoints Attributes
        #
    proc bikeGeometry::model_freeAngle::create_GeometryFront {} {
                #
            variable [namespace parent]::Geometry
            variable [namespace parent]::Position
                #
            variable [namespace parent]::HandleBar
            variable [namespace parent]::Steerer
            variable [namespace parent]::Fork
            variable [namespace parent]::FrontWheel
                #
                #
            set Geometry(FrontWheel_Radius) [ expr 0.5 * $Geometry(FrontRim_Diameter) + $Geometry(FrontTyre_Height) ]
                #
            set Geometry(FrontWheel_y)      [ expr $Geometry(BottomBracket_Depth) - $Geometry(RearWheel_Radius) + $Geometry(FrontWheel_Radius) ]                
                #
            set Position(HandleBar)         [ list $Geometry(HandleBar_Distance) $Geometry(HandleBar_Height) ]    
                #
            set vect_01 [ expr $Geometry(Stem_Length) * cos($Geometry(Stem_Angle) * $vectormath::CONST_PI / 180) ]
            set vect_03 [ expr $vect_01 / sin($Geometry(HeadTube_Angle) * $vectormath::CONST_PI / 180) ]
                #
            set Steerer(Handlebar)          [ list  [expr $Geometry(HandleBar_Distance) - $vect_03]  $Geometry(HandleBar_Height) ]
                #
            set help_04 [ vectormath::rotateLine       $Steerer(Handlebar)     100    [expr 180 - $Geometry(HeadTube_Angle)]    ]
            set help_03 [ vectormath::rotateLine       $Position(HandleBar)    100    [expr  90 - $Geometry(HeadTube_Angle) + $Geometry(Stem_Angle)]    ]
                #
            set Position(Steerer_End)       [ vectormath::intersectPoint    $Position(HandleBar)  $help_03 $Steerer(Handlebar) $help_04 ]
                #
            set vect_04 [ vectormath::parallel      $Position(Steerer_End)      $help_04    $Geometry(Fork_Rake) ]
            set help_05 [ lindex $vect_04 0 ]
            set help_06 [ lindex $vect_04 1 ]
                #
            set Position(FrontWheel)        [ vectormath::intersectPoint    $help_05  $help_06 [list 0 $Geometry(FrontWheel_y)] [list 200 $Geometry(FrontWheel_y)] ]
            set Position(FrontDropout)      $Position(FrontWheel)
            set Position(FrontDropout_MockUp)       $Position(FrontWheel)
            set Geometry(FrontWheel_x)      [ lindex $Position(FrontWheel) 0]
            set Geometry(FrontWheel_xy)     [ expr hypot($Geometry(FrontWheel_x),$Geometry(FrontWheel_y)) ]
                #
            set Steerer(FrontWheel)         [ vectormath::rotateLine    $Position(FrontWheel)    $Geometry(Fork_Rake)    [expr 270 - $Geometry(HeadTube_Angle)] ]
            set Position(Steerer_Start)     [ vectormath::addVector     $Steerer(FrontWheel)     [ vectormath::unifyVector  $Steerer(FrontWheel)  $Position(Steerer_End)  $Geometry(Fork_Height) ] ]
               #
            set help_08  [ vectormath::addVector    $Position(BottomBracket_Ground) {200 0}]
                #
            set Position(Steerer_Ground)    [ vectormath::intersectPoint    $Position(Steerer_End) $Position(Steerer_Start)     $Position(BottomBracket_Ground)  $help_08 ]
            set Position(ForkCrown)         $Position(Steerer_Start) 
                #
            return
                #
    }
    proc bikeGeometry::model_freeAngle::create_GeometryRear {} {
                #
            variable [namespace parent]::Geometry
            variable [namespace parent]::Position
                #
            variable [namespace parent]::RearWheel
            variable [namespace parent]::RearDropout
                #
            set Geometry(RearWheel_Radius)  [ expr 0.5 * $Geometry(RearRim_Diameter) + $Geometry(RearTyre_Height) ]
                #
            set Geometry(RearWheel_x)       [ expr sqrt(pow($Geometry(ChainStay_Length),2)  - pow($Geometry(BottomBracket_Depth),2)) ]
                #
            set Position(RearDropout)       [ list [expr -1.0 * $Geometry(RearWheel_x)] $Geometry(BottomBracket_Depth) ]
                #
            set Position(RearWheel)         $Position(RearDropout)
                #
            return
                #
    }   
    proc bikeGeometry::model_freeAngle::create_GeometryCenter {} {
                #
            variable [namespace parent]::Direction
            variable [namespace parent]::Geometry
            variable [namespace parent]::Position
            variable [namespace parent]::Config
                #
            variable [namespace parent]::Result
                #
            variable [namespace parent]::Saddle
            variable [namespace parent]::SeatPost
            variable [namespace parent]::SeatTube
            variable [namespace parent]::BottomBracket
            variable [namespace parent]::TopTube
            variable [namespace parent]::RearWheel
            variable [namespace parent]::LegClearance
                #
                #
            set Position(BottomBracket)         {0 0}
                #
            set Geometry(BottomBracket_Height)  [ expr $Geometry(RearWheel_Radius) - $Geometry(BottomBracket_Depth) ]
            set Position(BottomBracket_Ground)  [ list 0    [expr - $Geometry(RearWheel_Radius) + $Geometry(BottomBracket_Depth) ] ]
                #
                # check-Value-procedure
            if {$Saddle(Height) < 0} {
                   set Saddle(Height) 0
            }
                #
            set Position(Saddle)            [ list [expr -1.0*$Geometry(Saddle_Distance)]  $Geometry(Saddle_Height) ]
            set Position(SaddleNose)        [ vectormath::addVector  $Position(Saddle) [list [expr $Saddle(NoseLength) + $Saddle(Offset_x)] -15] ]
                #
            set SeatPost(Height)            [ expr $Geometry(Saddle_Height) - $Saddle(Height) ]
            set Position(SeatPost_Saddle)   [ list [expr -1.0 * $Geometry(Saddle_Distance)] $SeatPost(Height) ]
            set Position(SeatPost_Pivot)    [ vectormath::addVector $Position(SeatPost_Saddle)  [list 0 $SeatPost(PivotOffset)] -1]
                set hlp_01                  [ vectormath:::cathetusPoint {0 0} $Position(SeatPost_Pivot) [expr $SeatPost(Setback) - $SeatTube(OffsetBB)] {opposite}]
                set vct_01                  [ vectormath:::parallel {0 0} $hlp_01 $SeatTube(OffsetBB)]
            set Position(SeatPost_SeatTube) [ lindex $vct_01 1]
            set Position(SeatTube_Start)    [ lindex $vct_01 0]
            set Geometry(SeatTube_Angle)    [ vectormath::angle $Position(SeatPost_SeatTube) $Position(SeatTube_Start) [list -100 [lindex $Position(SeatTube_Start) 1]]]
            set Direction(SeatTube)         [ vectormath::unifyVector $Position(SeatTube_Start) $Position(SeatPost_SeatTube) ]
                #
                # --- get LegClearance - Position
            set LegClearance(Position)  [ list $TopTube(PivotPosition)  [expr $Geometry(Inseam_Length) - ($Geometry(RearWheel_Radius) - $Geometry(BottomBracket_Depth)) ] ]
                #
                #
            set Position(SaddleProposal)    [ vectormath::rotateLine {0 0}  [ expr 0.88*$Geometry(Inseam_Length) ]  [ expr 180 - $Geometry(SeatTube_Angle) ] ]
                #
            set help_08  [ vectormath::addVector    $Position(BottomBracket_Ground) {200 0}]
                #
            set Position(SeatTube_Ground)   [ vectormath::intersectPoint        $Position(SeatPost_SeatTube) $Position(SeatTube_Start)      $Position(BottomBracket_Ground)  $help_08 ]
                #
            set Position(SeatTube_Saddle)   [ vectormath::intersectPoint [list 0 [lindex $Position(Saddle) 1] ] [list 100 [lindex $Position(Saddle) 1]] $Position(SeatTube_Start) $Position(SeatPost_SeatTube) ]
                #
            set Position(LegClearance)      [list $TopTube(PivotPosition)     [expr $Geometry(Inseam_Length) - ($Geometry(RearWheel_Radius) - $Geometry(BottomBracket_Depth)) ]]
                #
            return
                #
    }
        #
        #
        #
        # --- fill Result Values ------------------
    proc bikeGeometry::model_freeAngle::create_GeometryResult {} {
                #
            variable [namespace parent]::Geometry
            variable [namespace parent]::Position
            variable [namespace parent]::Reference
                #
            variable [namespace parent]::BottomBracket
            variable [namespace parent]::Fork
            variable [namespace parent]::HeadTube
            variable [namespace parent]::TopTube
            variable [namespace parent]::Steerer
            variable [namespace parent]::RearWheel
            variable [namespace parent]::FrontWheel
            variable [namespace parent]::Saddle
            variable [namespace parent]::SeatTube
            variable [namespace parent]::SeatPost
            variable [namespace parent]::HandleBar
            variable [namespace parent]::SeatStay
            variable [namespace parent]::DownTube
            variable [namespace parent]::ChainStay
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
                # --- BottomBracket/Height
                #
            set Geometry(BottomBracket_Height) [ format "%.3f" [lindex $Geometry(BottomBracket_Height) 0] ]
                #
                # --- HeadTube ----------------------------------------
                #
            set position    $Position(HeadTube_End)
                #
                # --- HeadTube/ReachLength
                #
            set value       [lindex $position 0] 
            set Geometry(Reach_Length)  [ format "%.3f" $value ]
                # 
                # --- HeadTube/StackHeight
                #
            set value       [lindex $position 1]
            set Geometry(Stack_Height)  [ format "%.3f" $value ]
                #
                # --- SeatTube ----------------------------------------
                #
            set position    $Position(SeatTube_End)
                #
                # --- SeatTube/Angle ------------------------------
                #
            set angle [ vectormath::angle $Position(SeatPost_SeatTube) $Position(SeatTube_Start) [list -200 [lindex $Position(SeatTube_Start) 1]] ]
            set Geometry(SeatTube_Angle) [ format "%.3f" $angle ]
                #
                # --- SeatTube/TubeLength -------------------------
                #
            set value       [ format "%.3f" [ expr hypot([lindex $position 0],[lindex $position 1]) ] ]
            set Geometry(SeatTube_TubeLength)   $value
                #
                # --- SeatTube/TubeHeight -------------------------
                #
            set value        [ format "%.3f" [lindex $position 1] ]
            set Geometry(SeatTube_TubeHeight)   $value
                #
                # --- VirtualTopTube ----------------------------------
                #
            set Position(SeatTube_VirtualTopTube)   [ vectormath::intersectPoint [list -500 [lindex $Position(HeadTube_End) 1]]  $Position(HeadTube_End)  $Position(SeatTube_Start) $Position(SeatPost_SeatTube) ]
                #
                # --- TopTube/VirtualLength -----------------------
                #
            set value       [expr [lindex $Position(HeadTube_End) 0] - [lindex $Position(SeatTube_VirtualTopTube) 0] ]
            set Geometry(TopTube_Virtual)   [ format "%.3f" $value ]
                #
                # --- SeatTube/VirtualLength ----------------------
                #
            set value       [vectormath::length $Position(SeatTube_VirtualTopTube) {0 0}]
            set Geometry(SeatTube_Virtual)  [ format "%.3f" $value]
                #
                # --- Saddle ------------------------------------------
                #
            set position_Saddle      $Position(Saddle)   
            set position_SaddleNose  $Position(SaddleNose)            
            set position_SeatTube    $Position(SeatTube_Saddle)
            set position_HandleBar   $Position(HandleBar)
            set position_BB          {0 0}
                #
                # --- Saddle/Offset_BB --------------------------------
                #
            set value        [ format "%.3f" [expr -1 * [lindex $position_Saddle 0]] ]
                # puts "                  ... $value"
            set Geometry(Saddle_Offset_BB)  $value
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
            set Geometry(FrontWheel_xy)    [ format "%.3f" $Geometry(FrontWheel_xy) ]
                #
                # --- WheelPosition/front/horizontal ------------------
                #
            set Geometry(FrontWheel_x)      [ format "%.3f" $Geometry(FrontWheel_x) ]
                #
                # --- WheelPosition/rear/horizontal -------------------
                #
            set Geometry(RearWheel_x)       [ format "%.3f" $Geometry(RearWheel_x) ]
                #
                # --- RearWheel/Radius --------------------------------
                #
                # set Geometry(RearWheel_Diameter)    [ format "%.3f" $Geometry(RearWheel_Diameter) ]
                #
                # --- RearWheel/TyreShoulder --------------------------------
                #
            set RearWheel(TyreShoulder)     [ expr $Geometry(RearWheel_Radius) - $RearWheel(TyreWidthRadius) ]
                #
                # --- FrontWheel/Radius -------------------------------
                #
            set BB_Position                 {0 0}
                #
            set ChainSt_SeatSt_IS           $Position(ChainStay_SeatStay_IS)
                #  
            set Geometry(HeadLug_Angle_Top)              [format "%.4f" [ get_resultAngle $Position(TopTube_End)     $Position(Steerer_End)  $Position(TopTube_Start)    ]]  ; # Result(Angle/HeadTube/TopTube)
            set Geometry(HeadLug_Angle_Bottom)           [format "%.4f" [ get_resultAngle $Position(DownTube_End)    $BB_Position            $Position(Steerer_Start)    ]]  ;# Result(Angle/HeadTube/DownTube)      
            set Geometry(SeatLug_Angle_TopTube)         [format "%.4f" [ get_resultAngle $Position(TopTube_Start)   $BB_Position            $Position(TopTube_End)      ]]  ;# Result(Angle/SeatTube/TopTube)       
            set Geometry(SeatLug_Angle_SeatStay)        [format "%.4f" [ get_resultAngle $Position(SeatStay_End)    $ChainSt_SeatSt_IS      $BB_Position                ]]  ;# Result(Angle/SeatTube/SeatStay)      
            set Geometry(BottomBracket_Angle_DownTube)  [format "%.4f" [ get_resultAngle $BB_Position               $Position(DownTube_End) $Position(TopTube_Start)    ]]  ;# Result(Angle/BottomBracket/DownTube) 
            set Geometry(BottomBracket_Angle_ChainStay) [format "%.4f" [ get_resultAngle $BB_Position               $Position(TopTube_Start)  $ChainSt_SeatSt_IS        ]]  ;# Result(Angle/BottomBracket/ChainStay)
            set Geometry(BottomBracket_Angle_SeatStay)  [format "%.4f" [ get_resultAngle $ChainSt_SeatSt_IS         $BB_Position            $Position(SeatStay_End)     ]]  ;# Result(Angle/SeatStay/ChainStay)                 
                #
                # --- Reference Position ------------------------------
                #             
            set BB_Height    [expr  0.5 * $Geometry(RearRim_Diameter) +  $Geometry(RearTyre_Height) -  $Geometry(BottomBracket_Depth)]
            set SN_Distance  [expr -1.0 * $Reference(SaddleNose_Distance)]
            set SN_Height    [expr $Reference(SaddleNose_Height)  - $BB_Height]
            set HB_Distance  [expr $Reference(HandleBar_Distance) + $SN_Distance]
            set HB_Height    [expr $Reference(HandleBar_Height)   - $BB_Height]
                #
            set Position(Reference_HB)      [list $HB_Distance $HB_Height]
            set Position(Reference_SN)      [list $SN_Distance $SN_Height]
                #
            set Reference(HandleBar_BB)     [vectormath::length $Position(Reference_HB) {0 0}]                      ;#Result(Length/Reference/HandleBar_BB) 
            set Reference(HandleBar_FW)     [vectormath::length $Position(Reference_HB) $Position(FrontWheel)]      ;#Result(Length/Reference/HandleBar_FW) 
            set Reference(SaddleNose_BB)    [vectormath::length $Position(Reference_SN) {0 0}]                      ;#Result(Length/Reference/SaddleNose_BB)
            set Reference(SaddleNose_HB)    [vectormath::length $Position(Reference_SN) $Position(Reference_HB)]    ;#Result(Length/Reference/SaddleNose_HB)            
            set Reference(SaddleNose_HB_y)  [expr $SN_Height - $HB_Height]                                          ;#Result(Length/Reference/Heigth_SN_HB)             
                #
            return
                #
    }

