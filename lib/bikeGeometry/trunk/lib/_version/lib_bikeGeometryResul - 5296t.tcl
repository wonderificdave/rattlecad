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
                  
                default {
                        puts "\n"
                        puts "     WARNING!"
                        puts "\n"
                        puts "        ... set_resultParameter:  "
                        puts "                 $xpath"
                        puts "            ... is not registered!"
                        puts "\n"
                        return
                  }
            }
    
    }

    
    proc bikeGeometry::set_Result_BottomBracketHeight   {_array _name value} {
                #
                # Length/BottomBracket/Height
                # BottomBracket(Height)
                #
            variable BottomBracket
                #
            puts "    <1> set_Result_BottomBracketHeight   ... check $BottomBracket(Height)  ->  $value"
                #
            set delta                   [expr $value - $BottomBracket(Height)]
                #
            set BottomBracket(Depth)    [expr $BottomBracket(Depth) - $delta ]
                #
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_BottomBracketHeight   ... check $BottomBracket(Height)  ->  $value"
                #
            return $BottomBracket(Height)
                #
    }
              
    proc bikeGeometry::set_Result_HeadTube_TopTubeAngle {_array _name value} {
                #
                # Angle/HeadTube/TopTube
                # Result(Angle_HeadTubeTopTube)
                #
            variable Result    
            variable HeadTube    
            variable TopTube    
                #
            puts "    <1> set_Result_HeadTube_TopTubeAngle   ... check $Result(Angle_HeadTubeTopTube)  ->  $value"
                #
            set HeadTopTube_Angle       $value
                #
            set TopTube(Angle)          [expr $value - $HeadTube(Angle)]
                #
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_HeadTube_TopTubeAngle   ... check $Result(Angle_HeadTubeTopTube)  ->  $value"
                #
            return $Result(Angle_HeadTubeTopTube)
                #
    }
    proc bikeGeometry::set_Result_SeatTubeDirection     {_array _name value} {
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
            set ST_height           [expr $Saddle(Height) - $Saddle(SaddleHeight) - $SeatPost(PivotOffset) + $height_Setback]
            set length_SeatTube     [expr $ST_height / tan([vectormath::rad $value])]
                #
            set Saddle(Distance)    [expr $length_Setback + $length_SeatTube]
                #
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_SeatTubeDirection   ... check $Geometry(SeatTube_Angle)  ->  $value"
                #
            return $Geometry(SeatTube_Angle)
                #
    }
    proc bikeGeometry::set_Result_SeatTubeVirtualLength {_array _name value} {
                #
                # Length/SeatTube/VirtualLength
                # Geometry(SeatTubeVirtual)
                #
            variable Geometry
            variable HeadTube
            variable HandleBar
                #
            puts "    <1> set_Result_SeatTubeVirtualLength   ... check $Geometry(StackHeightResult)  ->  $value"
                #
            set delta                   [expr $value - $Geometry(SeatTubeVirtual)]
                #
            set offsetSeatTube          [vectormath::rotateLine {0 0} $delta [expr 180 - $Geometry(SeatTube_Angle)]]
            set offsetSeatTube_x        [lindex $offsetSeatTube 0]
                #
            set deltaHeadTube           [expr [lindex $offsetSeatTube 1] / sin($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]
            set offsetHeadTube_x        [expr [lindex $offsetSeatTube 1] / tan($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]
                #
            set HandleBar(Distance)     [expr $HandleBar(Distance)    + $offsetHeadTube_x + $offsetSeatTube_x]
                #
            set HeadTube(Length)        [expr $HeadTube(Length)    + $deltaHeadTube]
                #
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_SeatTubeVirtualLength   ... check $Geometry(StackHeightResult)  ->  $value"
                #
            return $Geometry(SeatTubeVirtual)
                #
    } 
    proc bikeGeometry::set_Result_HeadTubeReachLength   {_array _name value} {
                #
                # Length/HeadTube/ReachLengt
                # Geometry(ReachLengthResult)
                #
            variable Geometry
            variable HandleBar
                #
            puts "    <1> set_Result_HeadTubeReachLength   ... check $Geometry(ReachLengthResult)  ->  $value"
                #
            set delta                   [expr $value - $Geometry(ReachLengthResult)]
                #
            set HandleBar(Distance)     [expr $HandleBar(Distance)    + $delta]
                #
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_HeadTubeReachLength   ... check $Geometry(ReachLengthResult)  ->  $value"
                #
            return $Geometry(ReachLengthResult)
                #
    }
    proc bikeGeometry::set_Result_HeadTubeStackHeight   {_array _name value} {
                #
                # Length/HeadTube/StackHeight
                # Geometry(StackHeightResult)
                #
            variable Geometry
            variable HeadTube
            variable HandleBar
                #
            puts "    <1> set_Result_HeadTubeStackHeight   ... check $Geometry(StackHeightResult)  ->  $value"
                #
            set delta                   [expr $value - $Geometry(StackHeightResult)]
  
            set deltaHeadTube           [expr $delta / sin($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]
            set offsetHeadTube_x        [expr $delta / tan($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]
                #
            set HandleBar(Height)       [expr $HandleBar(Height)    + $delta]
                #
            set HeadTube(Length)        [expr $HeadTube(Length) + $deltaHeadTube ]
                #
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_HeadTubeStackHeight   ... check $Geometry(StackHeightResult)  ->  $value"
                #
            return $Geometry(StackHeightResult)
                #
    }
    proc bikeGeometry::set_Result_TopTubeVirtualLength  {_array _name value} {
                #
                # Length/TopTube/VirtualLength
                # Geometry(TopTubeVirtual)
                #
            variable Geometry
            variable HandleBar
                #
            puts "    <1> set_Result_TopTubeVirtualLength   ... check $Geometry(FrontWheel_x)  ->  $value"
                #
           set delta                   [expr $value - $Geometry(TopTubeVirtual)]
                #
            set HandleBar(Distance)     [ expr $HandleBar(Distance)    + $delta ]
                #
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_TopTubeVirtualLength   ... check $Geometry(FrontWheel_x)  ->  $value"
                #
            return $Geometry(TopTubeVirtual)
                #
    }
    proc bikeGeometry::set_Result_FrontWheelhorizontal  {_array _name value} {
                #
                # Length/FrontWheel/horizontal
                # Geometry(FrontWheel_x)
                #
            variable Geometry
            variable HandleBar
                #
            puts "    <1> set_Result_FrontWheelhorizontal   ... check $Geometry(FrontWheel_x)  ->  $value"
                #
            set delta                   [expr $value - $Geometry(FrontWheel_x)]
                #
            set HandleBar(Distance)     [ expr $HandleBar(Distance)    + $delta ]
                #
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_FrontWheelhorizontal   ... check $Geometry(FrontWheel_x)  ->  $value"
                #
            return Geometry(FrontWheel_x)
                #
    }
    proc bikeGeometry::set_Result_RearWheelhorizontal   {_array _name value} {
                #
                # Length/RearWheel/horizontal
                # Geometry(RearWheel_X)
                #
            variable Geometry
            variable BottomBracket
            variable RearWheel
                #
            puts "    <1> set_Result_RearWheelhorizontal   ... check $Geometry(RearWheel_X)  ->  $value"
                #
            set RearWheel(DistanceBB)   [ expr { sqrt( $value * $value + $BottomBracket(Depth) * $BottomBracket(Depth) ) } ]
                #
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_RearWheelhorizontal   ... check $Geometry(RearWheel_X)  ->  $value"
                #
            return $Geometry(RearWheel_X)
                #
    }
    proc bikeGeometry::set_Result_FrontWheeldiagonal    {_array _name value} {
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
            set vect_01     [ expr $Stem(Length) * cos($Stem(Angle) * $vectormath::CONST_PI / 180) ]
            set vect_02     [ expr $vect_01 - $Fork(Rake) ]
                #
            set FW_Distance_X_tmp  [ expr { sqrt( $value * $value - $FrontWheel(Distance_Y) * $FrontWheel(Distance_Y) ) } ]
            set FW_Position_tmp    [ list $FW_Distance_X_tmp $FrontWheel(Distance_Y)]
                #
            set help_03   [ vectormath::cathetusPoint   $HandleBar(Position)    $FW_Position_tmp    $vect_02  close ]
            set vect_HT   [ vectormath::parallel        $help_03                $FW_Position_tmp    $Fork(Rake) ]
                #
            set help_01  [ lindex $vect_HT 0]
            set help_02  [ lindex $vect_HT 1]
            set help_03  [list -200 [ lindex $help_02 1] ]
                #
            set HeadTube(Angle)         [vectormath::angle    $help_01 $help_02 $help_03 ]
                #
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_FrontWheeldiagonal   ... check $Geometry(FrontWheel_xy)  ->  $value"
                #
            return $Geometry(FrontWheel_xy)
                #
    }
    proc bikeGeometry::set_Result_SaddleOffset_HB       {_array _name value} {
                #
                # Length/Saddle/Offset_HB
                # Geometry(Saddle_HB_y)
                #
            variable Geometry
            variable HandleBar
                #
            puts "    <1> set_Result_SaddleOffset_HB   ... check $Geometry(Saddle_HB_y)  ->  $value"
                #
            set delta                   [expr $Geometry(Saddle_HB_y) - $value ]
                #
            set HandleBar(Height)       [expr $HandleBar(Height)    + $delta ]
                #
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_SaddleOffset_HB   ... check $Geometry(Saddle_HB_y)  ->  $value"
                #
            return $Geometry(Saddle_HB_y)
                #
    }
    proc bikeGeometry::set_Result_SaddleOffset_BB_ST    {_array _name value} {
                #
                # Length/Saddle/Offset_BB_ST
                # Geometry(Saddle_Offset_BB_ST)
                #
            variable Geometry
            variable Saddle
                #
            puts "    <1> set_Result_SaddleOffset_BB_ST   ... check $Geometry(SaddleNose_BB_X)  ->  $value"
                #
            set angle                   [vectormath::dirAngle {0 0} [list $value $Saddle(Height)] ]
                #
            bikeGeometry::set_Result_SeatTubeDirection Result Angle/SeatTube/Direction $angle
                #
            puts "    <2> set_Result_SaddleOffset_BB_ST   ... check $Geometry(SaddleNose_BB_X)  ->  $value"
                #
            return $Geometry(Saddle_Offset_BB_ST)
                #
    }
    proc bikeGeometry::set_Result_SaddleOffset_BB_Nose  {_array _name value} {
                #
                # Length/Saddle/Offset_BB_Nose
                # Geometry(SaddleNose_BB_X)
                #
            variable Geometry     
            variable Saddle     
                #
            puts "    <1> set_Result_SaddleOffset_BB_Nose   ... check $Geometry(SaddleNose_BB_X)  ->  $value"
                #
            set delta                       [expr -1.0 * ($value - $Geometry(SaddleNose_BB_X)) ]
                #
            set Saddle(Offset_X)            [expr $Saddle(Offset_X) + $delta ]
                #
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_SaddleOffset_BB_Nose   ... check $Geometry(SaddleNose_BB_X)  ->  $value"
                #
            return $Geometry(SaddleNose_BB_X)
                #
    }
    proc bikeGeometry::set_Result_SaddleSeatTube_BB     {_array _name value} {
                #
                # Length/Saddle/SeatTube_BB
                # Geometry(Saddle_BB)
                #
            variable Geometry
            variable Saddle
                #
            puts "    <1> set_Result_SaddleSeatTube_BB   ... check $Geometry(Saddle_BB)  ->  $value"
                # 
            set angle_SeatTube          $Geometry(SeatTube_Angle)
            set pos_SeatTube_old        $Geometry(SeatTubeSaddle)
            set pos_Saddle_old          $Saddle(Position)
                #
            set pos_SeatTube_x          [expr $value * cos([vectormath::rad $Geometry(SeatTube_Angle)])]
            set pos_SeatTube_y          [expr $value * sin([vectormath::rad $Geometry(SeatTube_Angle)])]
                #
            set delta_Saddle_ST         [expr [lindex $Saddle(Position) 0] - [lindex $Geometry(SeatTubeSaddle) 0]]
                #
            set pos_Saddle_x            [expr $pos_SeatTube_x - $delta_Saddle_ST]
            set pos_Saddle_y            $pos_SeatTube_y
                #
            set Saddle(Distance)  [format "%.3f" $pos_Saddle_x]
            set Saddle(Height)    [format "%.3f" $pos_Saddle_y]
                #
            bikeGeometry::update_Parameter
                #                    
            puts "    <2> set_Result_SaddleSeatTube_BB   ... check $Geometry(Saddle_BB)  ->  $value"
                # 
            return $Geometry(Saddle_BB)
                #
    }
    proc bikeGeometry::set_Result_PersonalSaddleNose_HB {_array _name value} {
                #
                # Length/Personal/SaddleNose_HB
                # Geometry(SaddleNose_HB
                #
            variable Geometry
            variable HandleBar      
                #
            puts "    <1> set_Result_SaddleSeatTube_BB   ... check $Geometry(SaddleNose_HB)  ->  $value"
                #
            set delta                   [expr $value - $Geometry(SaddleNose_HB) ]
                #
            set HandleBar(Distance)     [expr $HandleBar(Distance) + $delta ]
                #
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_SaddleSeatTube_BB   ... check $Geometry(SaddleNose_HB)  ->  $value"
                #
            return $Geometry(SaddleNose_HB)
                #            
    }
    proc bikeGeometry::set_Result_RearWheelRadius       {_array _name value} {
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
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_RearWheelRadius   ... check $RearWheel(TyreHeight)  ->  $value"
                #
            return $RearWheel(TyreHeight) 
                #
    }
    proc bikeGeometry::set_Result_RearWheelTyreShoulder {_array _name value} {
                #
                # Length/RearWheel/TyreShoulder
                # RearWheel(TyreShoulder)
                #
            variable RearWheel
                #
            puts "    <1> set_Result_RearWheelTyreShoulder   ... check $RearWheel(TyreShoulder)  ->  $value"
                #
            set RearWheel(TyreWidthRadius)  [ expr $RearWheel(Radius) - abs($value)]
                #
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_RearWheelTyreShoulder   ... check $RearWheel(TyreShoulder)  ->  $value"
                #
            return $RearWheel(TyreShoulder)
                #
    }
    proc bikeGeometry::set_Result_FrontWheelRadius      {_array _name value} {
                #
                # ... unused ?
                #
                # Length/FrontWheel/Radius
                # FrontWheel(TyreHeight)
                #
            variable FrontWheel
                #
            puts "    <1> set_Result_FrontWheelRadius   ... check $FrontWheel(TyreHeight)  ->  $value"
                #
            set FrontWheel(TyreHeight)  [ expr $value - 0.5 * $FrontWheel(RimDiameter)]
                #
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_FrontWheelRadius   ... check $FrontWheel(TyreHeight)  ->  $value"
                #
            return $FrontWheel(TyreHeight) 
                #
    }
    proc bikeGeometry::set_Result_ReferenceHeigth_SN_HB {_array _name value} {
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
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_ReferenceHeigth_SN_HB   ... check $Reference(SaddleNose_HB_y)  ->  $value"
                #
            return $Reference(SaddleNose_HB_y)
                #
    }
    proc bikeGeometry::set_Result_ReferenceSaddleNose_HB {_array _name value} {
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
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_ReferenceSaddleNose_HB   ... check $Reference(SaddleNose_HB)  ->  $value "
                #
            return $Reference(SaddleNose_HB)
                #
    }
  
    
    
    