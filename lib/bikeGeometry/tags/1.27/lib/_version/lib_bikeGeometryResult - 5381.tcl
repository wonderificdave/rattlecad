 ##+##########################################################################
 #
 # package: bikeGeometry    ->    bikeGeometry.tcl
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
 #    namespace:  bikeGeometry::frame_geometry_custom
 # ---------------------------------------------------------------------------
 #
 #


    #-------------------------------------------------------------------------
       #  handle modification on /root/Result/... values
    proc bikeGeometry::set_resultParameter {_array _name value} {
    
            # variable         _updateValue
        
              # puts ""
              # puts "   -------------------------------"
              # puts "    set_resultParameter"
              # puts "       _array:          $_array"
              # puts "       _name:           $_name"
              # puts "       value:           $value"
        
            # variable Geometry
            # variable Rendering
            # variable Reference
            # variable Result
                #
            # variable BottomBracket
            # variable HandleBar
            # variable Saddle
            # variable SeatPost
            # variable SeatTube
            # variable HeadTube
            # variable TopTube
            # variable RearWheel
            # variable FrontWheel
            # variable Fork
            # variable Stem
            
           
        
            set xpath "$_array/$_name"
              # puts "       xpath:           $xpath"
        
            switch -exact $_name {
        
                {Length/BottomBracket/Height}   {   bikeGeometry::set_Result_BottomBracketHeight    $_array $_name  $value; return  }
                {Angle/HeadTube/TopTube}        {   bikeGeometry::set_Result_HeadTube_TopTubeAngle  $_array $_name  $value; return  }
                {Angle/SeatTube/Direction}      {   bikeGeometry::set_Result_SeatTubeDirection      $_array $_name  $value; return  }
                {Length/SeatTube/VirtualLength} {   bikeGeometry::set_Result_SeatTubeVirtualLength  $_array $_name  $value; return  }
                {Length/HeadTube/ReachLength}   {   bikeGeometry::set_Result_HeadTubeReachLength    $_array $_name  $value; return  }
                {Length/HeadTube/StackHeight}   {   bikeGeometry::set_Result_HeadTubeStackHeight    $_array $_name  $value; return  }
                {Length/TopTube/VirtualLength}  {   bikeGeometry::set_Result_TopTubeVirtualLength   $_array $_name  $value; return  }
                {Length/FrontWheel/horizontal}  {   bikeGeometry::set_Result_FrontWheelhorizontal   $_array $_name  $value; return  }
                {Length/RearWheel/horizontal}   {   bikeGeometry::set_Result_RearWheelhorizontal    $_array $_name  $value; return  }
                {Length/FrontWheel/diagonal}    {   bikeGeometry::set_Result_FrontWheeldiagonal     $_array $_name  $value; return  }
                {Length/Saddle/Offset_HB}       {   bikeGeometry::set_Result_SaddleOffset_HB        $_array $_name  $value; return  }
                {Length/Saddle/Offset_BB_ST}    {   bikeGeometry::set_Result_SaddleOffset_BB_ST     $_array $_name  $value; return  }
                {Length/Saddle/Offset_BB_Nose}  {   bikeGeometry::set_Result_SaddleOffset_BB_Nose   $_array $_name  $value; return  }

                {Length/Saddle/SeatTube_BB}     {   bikeGeometry::set_Result_SaddleSeatTube_BB      $_array $_name  $value; return  }
                {Length/Personal/SaddleNose_HB} {   bikeGeometry::set_Result_PersonalSaddleNose_HB  $_array $_name  $value; return  }
                {Length/RearWheel/Radius}       {   bikeGeometry::set_Result_RearWheelRadius        $_array $_name  $value; return  }
                {Length/RearWheel/TyreShoulder} {   bikeGeometry::set_Result_RearWheelTyreShoulder  $_array $_name  $value; return  }
                {Length/FrontWheel/Radius}      {   bikeGeometry::set_Result_FrontWheelRadius       $_array $_name  $value; return  }
                {Length/Reference/Heigth_SN_HB} {   bikeGeometry::set_Result_ReferenceHeigth_SN_HB  $_array $_name  $value; return  } 
                {Length/Reference/SaddleNose_HB} {  bikeGeometry::set_Result_ReferenceSaddleNose_HB $_array $_name  $value; return  }
                
                {HeadLug_Top_Angle}             {   bikeGeometry::set_Result_HeadTube_TopTubeAngle  $_array $_name  $value; return  }
                  
                default {
                        puts ""
                        puts "          <E>"
                        puts "          <E>   WARNING!"
                        puts "          <E>"
                        puts "          <E>      ... set_resultParameter:  "
                        puts "          <E>               $xpath"
                        puts "          <E>          ... is not registered!"
                        puts "          <E>"
                        puts ""
                        return
                    }
            }
    
    }

    
    proc bikeGeometry::set_Result_BottomBracketHeight   {value} {
                #
                # Length/BottomBracket/Height
                # Geometry(BottomBracket_Height)
                #
            variable Geometry
            variable BottomBracket
                #
            puts "    <1> set_Result_BottomBracketHeight   ... check $Geometry(BottomBracket_Height)  ->  $value"
                #
            set delta                           [expr $value - $Geometry(BottomBracket_Height)]
                #
            set Geometry(BottomBracket_Depth)   [expr $Geometry(BottomBracket_Depth) - $delta ]
                #
            bikeGeometry::update_Project
                #
            puts "    <2> set_Result_BottomBracketHeight   ... check $Geometry(BottomBracket_Height)  ->  $value"
                #
            return $Geometry(BottomBracket_Height)
                #
    }
              
    proc bikeGeometry::set_Result_HeadTube_TopTubeAngle {value} {
                #
                # Angle/HeadTube/TopTube
                # Geometry(HeadLugTop_Angle) 
                #
            variable Geometry    
            variable Result    
            variable HeadTube    
            variable TopTube    
                #
            puts "    <1> set_Result_HeadTube_TopTubeAngle   ... check $Geometry(HeadLugTop_Angle)   ->  $value"
                #
            set HeadTopTube_Angle       $value
                #
            set Geometry(TopTube_Angle) [expr $value - $Geometry(HeadTube_Angle)]
                #
            bikeGeometry::update_Project
                #
            puts "    <2> set_Result_HeadTube_TopTubeAngle   ... check $Geometry(HeadLugTop_Angle)   ->  $value"
                #
            return $Geometry(HeadLugTop_Angle) 
                #
    }
    proc bikeGeometry::set_Result_SeatTubeDirection     {value} {
                #
                # Angle/SeatTube/Direction
                # Geometry(SeatTube_Angle)
                #
            variable Geometry    
            variable Saddle    
            variable SeatPost    
                #
            puts "    <1> set_Result_SeatTubeDirection   ... check $Geometry(SeatTube_Angle)  ->  $value"
                #
            set length_Setback      [expr $SeatPost(Setback) * sin([vectormath::rad $value])]
            set height_Setback      [expr $SeatPost(Setback) * cos([vectormath::rad $value])]
                #
            set ST_height           [expr $Geometry(Saddle_Height) - $Saddle(Height) - $SeatPost(PivotOffset) + $height_Setback]
            set length_SeatTube     [expr $ST_height / tan([vectormath::rad $value])]
                #
            set Geometry(Saddle_Distance)    [expr $length_Setback + $length_SeatTube]
                #
            bikeGeometry::update_Project
                #
            puts "    <2> set_Result_SeatTubeDirection   ... check $Geometry(SeatTube_Angle)  ->  $value"
                #
            return $Geometry(SeatTube_Angle)
                #
    }
    proc bikeGeometry::set_Result_SeatTubeVirtualLength {value} {
                #
                # Length/SeatTube/VirtualLength
                # Geometry(SeatTube_Virtual)
                #
            variable Geometry
            variable HeadTube
            variable HandleBar
                #
            puts "    <1> set_Result_SeatTubeVirtualLength   ... check $Geometry(SeatTube_Virtual)  ->  $value"
                #
            set delta                   [expr $value - $Geometry(SeatTube_Virtual)]
                #
            set offsetSeatTube          [vectormath::rotateLine {0 0} $delta [expr 180 - $Geometry(SeatTube_Angle)]]
            set offsetSeatTube_x        [lindex $offsetSeatTube 0]
                #
            set deltaHeadTube           [expr [lindex $offsetSeatTube 1] / sin($Geometry(HeadTube_Angle) * $vectormath::CONST_PI / 180) ]
            set offsetHeadTube_x        [expr [lindex $offsetSeatTube 1] / tan($Geometry(HeadTube_Angle) * $vectormath::CONST_PI / 180) ]
                #
            set Geometry(HandleBar_Distance)    [expr $Geometry(HandleBar_Distance)    + $offsetHeadTube_x + $offsetSeatTube_x]
                #
            set HeadTube(Length)        [expr $HeadTube(Length)    + $deltaHeadTube]
                #
            bikeGeometry::update_Project
                #
            puts "    <2> set_Result_SeatTubeVirtualLength   ... check $Geometry(SeatTube_Virtual)  ->  $value"
                #
            return $Geometry(SeatTube_Virtual)
                #
    } 
    proc bikeGeometry::set_Result_HeadTubeReachLength   {value} {
                #
                # Length/HeadTube/ReachLengt
                # Geometry(Reach_Length)
                #
            variable Geometry
            variable HandleBar
                #
            puts "    <1> set_Result_HeadTubeReachLength   ... check $Geometry(Reach_Length) ->  $value"
                #
            set delta                           [expr $value - $Geometry(Reach_Length)]
                #
            set Geometry(HandleBar_Distance)    [expr $Geometry(HandleBar_Distance)    + $delta]
                #
            bikeGeometry::update_Project
                #
            puts "    <2> set_Result_HeadTubeReachLength   ... check $Geometry(Reach_Length) ->  $value"
                #
            return $Geometry(Reach_Length)
                #
    }
    proc bikeGeometry::set_Result_HeadTubeStackHeight   {value} {
                #
                # Length/HeadTube/StackHeight
                # Geometry(Stack_Height)
                #
            variable Geometry
            variable HeadTube
            variable HandleBar
                #
            puts "    <1> set_Result_HeadTubeStackHeight   ... check $Geometry(Stack_Height)  ->  $value"
                #
            set delta                   [expr $value - $Geometry(Stack_Height)]
  
            set deltaHeadTube           [expr $delta / sin($Geometry(HeadTube_Angle) * $vectormath::CONST_PI / 180) ]
            set offsetHeadTube_x        [expr $delta / tan($Geometry(HeadTube_Angle) * $vectormath::CONST_PI / 180) ]
                #
            set Geometry(HandleBar_Height)  [expr $Geometry(HandleBar_Height)    + $delta]
                #
            set HeadTube(Length)        [expr $HeadTube(Length) + $deltaHeadTube ]
                #
            bikeGeometry::update_Project
                #
            puts "    <2> set_Result_HeadTubeStackHeight   ... check $Geometry(Stack_Height)  ->  $value"
                #
            return $Geometry(Stack_Height)
                #
    }
    proc bikeGeometry::set_Result_TopTubeVirtualLength  {value} {
                #
                # Length/TopTube/VirtualLength
                # Geometry(TopTube_Virtual)
                #
            variable Geometry
            variable HandleBar
                #
            puts "    <1> set_Result_TopTubeVirtualLength   ... check $Geometry(TopTube_Virtual) ->  $value"
                #
           set delta                            [expr $value - $Geometry(TopTube_Virtual)]
                #
            set Geometry(HandleBar_Distance)    [expr $Geometry(HandleBar_Distance)    + $delta ]
                #
            bikeGeometry::update_Project
                #
            puts "    <2> set_Result_TopTubeVirtualLength   ... check $Geometry(TopTube_Virtual) ->  $value"
                #
            return $Geometry(TopTube_Virtual)
                #
    }
    proc bikeGeometry::set_Result_FrontWheelhorizontal  {value} {
                #
                # Length/FrontWheel/horizontal
                # Geometry(FrontWheel_x)
                #
            variable Geometry
            variable HandleBar
                #
            puts "    <1> set_Result_FrontWheelhorizontal   ... check $Geometry(FrontWheel_x)  ->  $value"
                #
            set delta                           [expr $value - $Geometry(FrontWheel_x)]
                #
            set Geometry(HandleBar_Distance)    [expr $Geometry(HandleBar_Distance)    + $delta ]
                #
            bikeGeometry::update_Project
                #
            puts "    <2> set_Result_FrontWheelhorizontal   ... check $Geometry(FrontWheel_x)  ->  $value"
                #
            return Geometry(FrontWheel_x)
                #
    }
    proc bikeGeometry::set_Result_RearWheelhorizontal   {value} {
                #
                # Length/RearWheel/horizontal
                # Geometry(FrontWheel_x)
                #
            variable Geometry
            variable BottomBracket
            variable RearWheel
                #
            puts "    <1> set_Result_RearWheelhorizontal   ... check $Geometry(FrontWheel_x)  ->  $value"
                #
            set Geometry(ChainStay_Length)  [ expr { sqrt( $value * $value + $Geometry(BottomBracket_Depth) * $Geometry(BottomBracket_Depth) ) } ]
                #
            bikeGeometry::update_Project
                #
            puts "    <2> set_Result_RearWheelhorizontal   ... check $Geometry(FrontWheel_x)  ->  $value"
                #
            return $Geometry(FrontWheel_x)
                #
    }
    proc bikeGeometry::set_Result_FrontWheeldiagonal    {value} {
                #
                # Length/FrontWheel/diagonal
                # Geometry(FrontWheel_xy)
                #
            variable Geometry
            variable Fork
            variable FrontWheel
            variable HandleBar
            variable HeadTube
            variable Stem
                #
            puts "    <1> set_Result_FrontWheeldiagonal   ... check $Geometry(FrontWheel_xy)  ->  $value"
                #
            set vect_01     [ expr $Geometry(Stem_Length) * cos($Geometry(Stem_Angle) * $vectormath::CONST_PI / 180) ]
            set vect_02     [ expr $vect_01 - $Fork(Rake) ]
                #
            set dist_x      [ expr { sqrt( $value * $value - $Geometry(FrontWheel_y) * $Geometry(FrontWheel_y) ) } ]
            set position    [ list $dist_x $Geometry(FrontWheel_y)]
                #
            set help_03     [ vectormath::cathetusPoint   $HandleBar(Position)    $position    $vect_02  close ]
            set vect_HT     [ vectormath::parallel        $help_03                $position    $Fork(Rake) ]
                #
            set help_01     [ lindex $vect_HT 0]
            set help_02     [ lindex $vect_HT 1]
            set help_03     [list -200 [ lindex $help_02 1] ]
                #
            set Geometry(HeadTube_Angle)    [vectormath::angle    $help_01 $help_02 $help_03 ]
                #
            bikeGeometry::update_Project
                #
            puts "    <2> set_Result_FrontWheeldiagonal   ... check $Geometry(FrontWheel_xy)  ->  $value"
                #
            return $Geometry(FrontWheel_xy)
                #
    }
    proc bikeGeometry::set_Result_SaddleOffset_HB       {value} {
                #
                # Length/Saddle/Offset_HB
                # Geometry(Saddle_HB_y)
                #
            variable Geometry
            variable HandleBar
                #
            puts "    <1> set_Result_SaddleOffset_HB   ... check $Geometry(Saddle_HB_y)  ->  $value"
                #
            set delta                       [expr $Geometry(Saddle_HB_y) - $value ]
                #
            set Geometry(HandleBar_Height)  [expr $Geometry(HandleBar_Height)    + $delta ]
                #
            bikeGeometry::update_Project
                #
            puts "    <2> set_Result_SaddleOffset_HB   ... check $Geometry(Saddle_HB_y)  ->  $value"
                #
            return $Geometry(Saddle_HB_y)
                #
    }
    proc bikeGeometry::set_Result_SaddleOffset_BB_ST    {value} {
                #
                # Length/Saddle/Offset_BB_ST
                # Geometry(Saddle_Offset_BB_ST)
                #
            variable Geometry
            variable Saddle
                #
            puts "    <1> set_Result_SaddleOffset_BB_ST   ... check $Geometry(Saddle_Offset_BB_ST)  ->  $value"
                #
            set angle                   [vectormath::dirAngle {0 0} [list $value $Geometry(Saddle_Height)] ]
                #
            bikeGeometry::set_Result_SeatTubeDirection $angle
                #
            puts "    <2> set_Result_SaddleOffset_BB_ST   ... check $Geometry(Saddle_Offset_BB_ST)  ->  $value"
                #
            return $Geometry(Saddle_Offset_BB_ST)
                #
    }
    proc bikeGeometry::set_Result_SaddleOffset_BB_Nose  {value} {
                #
                # Length/Saddle/Offset_BB_Nose
                # Geometry(SaddleNose_BB_x)
                #
            variable Geometry     
            variable Saddle     
                #
            puts "    <1> set_Result_SaddleOffset_BB_Nose   ... check $Geometry(SaddleNose_BB_x)  ->  $value"
                #
            set delta                       [expr -1.0 * ($value - $Geometry(SaddleNose_BB_x)) ]
                #
            set Saddle(Offset_x)            [expr $Saddle(Offset_x) + $delta ]
                #
            bikeGeometry::update_Project
                #
            puts "    <2> set_Result_SaddleOffset_BB_Nose   ... check $Geometry(SaddleNose_BB_x)  ->  $value"
                #
            return $Geometry(SaddleNose_BB_x)
                #
    }
    proc bikeGeometry::set_Result_SaddleSeatTube_BB     {value} {
                #
                # Length/Saddle/SeatTube_BB
                # Geometry(Saddle_BB)
                #
            variable Geometry
            variable Position
            variable Saddle
                #
            puts "    <1> set_Result_SaddleSeatTube_BB   ... check $Geometry(Saddle_BB)  ->  $value"
                # 
            set angle_SeatTube          $Geometry(SeatTube_Angle)
            set pos_SeatTube_old        $Position(SeatTubeSaddle)
            set pos_Saddle_old          $Saddle(Position)
                #
            set pos_SeatTube_x          [expr $value * cos([vectormath::rad $Geometry(SeatTube_Angle)])]
            set pos_SeatTube_y          [expr $value * sin([vectormath::rad $Geometry(SeatTube_Angle)])]
                #
            set delta_Saddle_ST         [expr [lindex $Saddle(Position) 0] - [lindex $Position(SeatTubeSaddle) 0]]
                #
            set pos_Saddle_x            [expr $pos_SeatTube_x - $delta_Saddle_ST]
            set pos_Saddle_y            $pos_SeatTube_y
                #
            set Geometry(Saddle_Distance)  [format "%.3f" $pos_Saddle_x]
            set Geometry(Saddle_Height)    [format "%.3f" $pos_Saddle_y]
                #
            bikeGeometry::update_Project
                #                    
            puts "    <2> set_Result_SaddleSeatTube_BB   ... check $Geometry(Saddle_BB)  ->  $value"
                # 
            return $Geometry(Saddle_BB)
                #
    }
    proc bikeGeometry::set_Result_PersonalSaddleNose_HB {value} {
                #
                # Length/Personal/SaddleNose_HB
                # Geometry(SaddleNose_HB
                #
            variable Geometry
            variable HandleBar      
                #
            puts "    <1> set_Result_SaddleSeatTube_BB   ... check $Geometry(SaddleNose_HB)  ->  $value"
                #
            set delta                           [expr $value - $Geometry(SaddleNose_HB) ]
                #
            set Geometry(HandleBar_Distance)    [expr $Geometry(HandleBar_Distance) + $delta ]
                #
            bikeGeometry::update_Project
                #
            puts "    <2> set_Result_SaddleSeatTube_BB   ... check $Geometry(SaddleNose_HB)  ->  $value"
                #
            return $Geometry(SaddleNose_HB)
                #            
    }
    proc bikeGeometry::set_Result_RearWheelRadius       {value} {
                #
                # ... unused ?
                #
                # Length/RearWheel/Radius
                # RearWheel(TyreHeight)
                #
            variable RearWheel
                #
            puts "    <1> set_Result_RearWheelRadius   ... check $RearWheel(TyreHeight)  ->  $value"
                #
            set RearWheel(TyreHeight)   [ expr $value - 0.5 * $RearWheel(RimDiameter)]
                #
            bikeGeometry::update_Project
                #
            puts "    <2> set_Result_RearWheelRadius   ... check $RearWheel(TyreHeight)  ->  $value"
                #
            return $RearWheel(TyreHeight) 
                #
    }
    proc bikeGeometry::set_Result_RearWheelTyreShoulder {value} {
                #
                # Length/RearWheel/TyreShoulder
                # RearWheel(TyreShoulder)
                #
            variable Geometry
            variable RearWheel
                #
            puts "    <1> set_Result_RearWheelTyreShoulder   ... check $RearWheel(TyreShoulder)  ->  $value"
                #
            set RearWheel(TyreWidthRadius)  [ expr $Geometry(RearWheel_Radius) - abs($value)]
                #
            bikeGeometry::update_Project
                #
            puts "    <2> set_Result_RearWheelTyreShoulder   ... check $RearWheel(TyreShoulder)  ->  $value"
                #
            return $RearWheel(TyreShoulder)
                #
    }
    proc bikeGeometry::set_Result_FrontWheelRadius      {value} {
                #
                # ... unused ?
                #
                # Length/FrontWheel/Radius
                # FrontWheel(TyreHeight)
                #
            variable FrontWheel
                #
            puts "    <1> set_Result_FrontWheelRadius   ... check $FrontWheel(Radius)  ->  $value"
                #
            set FrontWheel(TyreHeight)  [ expr $value - 0.5 * $FrontWheel(RimDiameter)]
                #
            bikeGeometry::update_Project
                #
            puts "    <2> set_Result_FrontWheelRadius   ... check $FrontWheel(TyreHeight)  ->  $value"
                #
            return $FrontWheel(Radius) 
                #
    }
    proc bikeGeometry::set_Result_ReferenceHeigth_SN_HB {value} {
                #
                # Length/Reference/Heigth_SN_HB
                # Reference(SaddleNose_HB_y)
                #
            variable Reference
                #
            puts "    <1> set_Result_ReferenceHeigth_SN_HB   ... check $Reference(SaddleNose_HB_y)  ->  $value"
                #
            set deltaValue                  [expr $value - $Reference(SaddleNose_HB_y)]
                #
            set Reference(HandleBar_Height) [expr $Reference(HandleBar_Height) - $deltaValue]  
                #
            bikeGeometry::update_Project
                #
            puts "    <2> set_Result_ReferenceHeigth_SN_HB   ... check $Reference(SaddleNose_HB_y)  ->  $value"
                #
            return $Reference(SaddleNose_HB_y)
                #
    }
    proc bikeGeometry::set_Result_ReferenceSaddleNose_HB {value} {
                #
                # Length/Reference/SaddleNose_HB
                # Reference(SaddleNose_HB)
                #
            variable Reference 
                #
            puts "    <1> set_Result_ReferenceSaddleNose_HB   ... check $Reference(SaddleNose_HB)  ->  $value "
                # 
            set Reference(HandleBar_Distance)   [ expr {sqrt( $value*$value - $Reference(SaddleNose_HB_y)*$Reference(SaddleNose_HB_y) )} ]
                #
            bikeGeometry::update_Project
                #
            puts "    <2> set_Result_ReferenceSaddleNose_HB   ... check $Reference(SaddleNose_HB)  ->  $value "
                #
            return $Reference(SaddleNose_HB)
                #
    }
  
    
    
    