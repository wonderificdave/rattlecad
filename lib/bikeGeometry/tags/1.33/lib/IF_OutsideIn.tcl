    namespace eval bikeGeometry {
            #
        namespace ensemble create -command ::bikeGeometry::IF_OutsideIn \
                -map {
        
                    set_Component                        set_Component
                    set_Config                           set_Config
                    set_ListValue                        set_ListValue
                    set_Scalar                           set_Scalar_Default
                                                         
                    set_newProject                       set_newProject
                    
                    get_projectDOM                       get_projectDOM
                    get_projectDICT                      get_projectDICT
                                                         
                    import_ProjectSubset                 import_ProjectSubset
                                                         
                    get_Component                        get_Component
                    get_Config                           get_Config
                    get_ListValue                        get_ListValue
                    get_Scalar                           get_Scalar
                                                         
                    get_Polygon                          get_Polygon
                    get_Position                         get_Position
                    get_Direction                        get_Direction
                    get_BoundingBox                      get_BoundingBox
                    get_TubeMiter                        get_TubeMiter
                    get_CenterLine                       get_CenterLine
                                                         
                    get_ComponentDir                     get_ComponentDir 
                    get_ComponentDirectories             get_ComponentDirectories
                    get_ListBoxValues                    get_ListBoxValues 
                                                         
                    get_DebugGeometry                    get_DebugGeometry
                    get_ReynoldsFEAContent               get_ReynoldsFEAContent
                                                         
                    coords_xy_index                      coords_xy_index
                                                        
            }

    }

    proc bikeGeometry::set_Scalar_Default {object key value} {
        puts "              <I> bikeGeometry::set_Scalar ... $object $key -> $value"
            #
            # -- check for existing parameter $object($key)
        if {[catch {array get [namespace current]::$object $key} eID]} {
            puts "\n              <W> bikeGeometry::set_Scalar ... \$key not accepted! ... $key / $value\n"
            return {}
        }
            #
            # -- check for values are mathematical values
        set newValue [bikeGeometry::check_mathValue $value] 
        if {$newValue == {}} {
            puts "\n              <W> bikeGeometry::set_Scalar ... \$value not accepted! ... $value"
            return {}
        }
            #
            # -- catch parameters that does not directly influence the model
        switch -exact $object {
            Geometry {
                    switch -exact $key {
                        {BottomBracket_Height}          {   bikeGeometry::set_Default_BottomBracketHeight    $newValue; return [get_Scalar $object $key] }
                        {FrontWheel_Radius}             {   bikeGeometry::set_Default_FrontWheelRadius       $newValue; return [get_Scalar $object $key] }
                        {FrontWheel_xy}                 {   bikeGeometry::set_Default_FrontWheeldiagonal     $newValue; return [get_Scalar $object $key] }
                        {FrontWheel_x}                  {   bikeGeometry::set_Default_FrontWheelhorizontal   $newValue; return [get_Scalar $object $key] }
                        {HeadLug_Angle_Top}             {   bikeGeometry::set_Default_HeadTube_TopTubeAngle  $newValue; return [get_Scalar $object $key] }
                        {RearWheel_Radius}              {   bikeGeometry::set_Default_RearWheelRadius        $newValue; return [get_Scalar $object $key] }
                        {RearWheel_x}                   {   bikeGeometry::set_Default_RearWheelhorizontal    $newValue; return [get_Scalar $object $key] }
                        {SaddleNose_BB_x}               {   bikeGeometry::set_Default_SaddleOffset_BB_Nose   $newValue; return [get_Scalar $object $key] }
                        {SaddleNose_HB}                 {   bikeGeometry::set_Default_PersonalSaddleNose_HB  $newValue; return [get_Scalar $object $key] }
                        {Saddle_BB}                     {   bikeGeometry::set_Default_SaddleSeatTube_BB      $newValue; return [get_Scalar $object $key] }
                        {Saddle_HB_y}                   {   bikeGeometry::set_Default_SaddleOffset_HB        $newValue; return [get_Scalar $object $key] }
                        {Saddle_Offset_BB_ST}           {   bikeGeometry::set_Default_SaddleOffset_BB_ST     $newValue; return [get_Scalar $object $key] }
                        {SeatTube_Angle}                {   bikeGeometry::set_Default_SeatTubeDirection      $newValue; return [get_Scalar $object $key] }
                        
                        {Reach_Length}                  {   bikeGeometry::set_StackReach_HeadTubeReachLength    $newValue; return [get_Scalar $object $key] }
                        {Stack_Height}                  {   bikeGeometry::set_StackReach_HeadTubeStackHeight    $newValue; return [get_Scalar $object $key] }
                        
                        {SeatTube_Virtual}              {   bikeGeometry::set_Classic_SeatTubeVirtualLength  $newValue; return [get_Scalar $object $key] }
                        {TopTube_Virtual}               {   bikeGeometry::set_Classic_TopTubeVirtualLength   $newValue; return [get_Scalar $object $key] }

                        {BottomBracket_Angle_ChainStay} {   bikeGeometry::model_lugAngle::set_Angle ChainStaySeatTube $newValue; return [get_Scalar $object $key] }                     
                        {BottomBracket_Angle_DownTube}  {   bikeGeometry::model_lugAngle::set_Angle SeatTubeDownTube  $newValue; return [get_Scalar $object $key] }                     
                        {HeadLug_Angle_Bottom}          {   bikeGeometry::model_lugAngle::set_Angle HeadTubeDownTube  $newValue; return [get_Scalar $object $key] }                     
                        
                        default {}
                    }
                }
            RearWheel {
                    switch -exact $key {
                        {TyreShoulder}              {   bikeGeometry::set_Default_RearWheelTyreShoulder  $newValue; return [get_Scalar $object $key] }
                        
                        default {}              
                    }
                }
            Reference {
                    switch -exact $key {
                        {SaddleNose_HB}             {   bikeGeometry::set_Default_ReferenceSaddleNose_HB $newValue; return [get_Scalar $object $key] }
                        {SaddleNose_HB_y}           {   bikeGeometry::set_Default_ReferenceHeigth_SN_HB  $newValue; return [get_Scalar $object $key] }

                        default {}              
                    }
                }
            default {}
        }
            #
            # -- set value to parameter
        array set [namespace current]::$object [list $key $newValue]
        bikeGeometry::update_Geometry
            #
        set scalarValue [bikeGeometry::get_Scalar $object $key ]
        puts "              <I> bikeGeometry::set_Scalar ... $object $key -> $scalarValue"
            #
        return $scalarValue
            #
    }
        #
        #
 
 
    proc bikeGeometry::set_Default_BottomBracketHeight      {value} {
                #
                # Length/BottomBracket/Height
                # Geometry(BottomBracket_Height)
                #
            variable Geometry
            variable BottomBracket
                #
            puts "    <1> set_Default_BottomBracketHeight   ... check $Geometry(BottomBracket_Height)  ->  $value"
                #
            set delta                           [expr $value - $Geometry(BottomBracket_Height)]
                #
            set Geometry(BottomBracket_Depth)   [expr $Geometry(BottomBracket_Depth) - $delta ]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Default_BottomBracketHeight   ... check $Geometry(BottomBracket_Height)  ->  $value"
                #
            return $Geometry(BottomBracket_Height)
                #
    }
              
    proc bikeGeometry::set_Default_HeadTube_TopTubeAngle    {value} {
                #
                # Angle/HeadTube/TopTube
                # Geometry(HeadLug_Angle_Top) 
                #
            variable Geometry    
            variable Result    
            variable HeadTube    
            variable TopTube    
                #
            puts "    <1> set_Default_HeadTube_TopTubeAngle   ... check $Geometry(HeadLug_Angle_Top)   ->  $value"
                #
            set HeadTopTube_Angle       $value
                #
            set Geometry(TopTube_Angle) [expr $value - $Geometry(HeadTube_Angle)]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Default_HeadTube_TopTubeAngle   ... check $Geometry(HeadLug_Angle_Top)   ->  $value"
                #
            return $Geometry(HeadLug_Angle_Top) 
                #
    }
    proc bikeGeometry::set_Default_SeatTubeDirection        {value} {
                #
                # Angle/SeatTube/Direction
                # Geometry(SeatTube_Angle)
                #
            variable Geometry    
            variable Saddle    
            variable SeatPost    
                #
            puts "    <1> set_Default_SeatTubeDirection   ... check $Geometry(SeatTube_Angle)  ->  $value"
                #
            set length_Setback      [expr $SeatPost(Setback) * sin([vectormath::rad $value])]
            set height_Setback      [expr $SeatPost(Setback) * cos([vectormath::rad $value])]
                #
            set ST_height           [expr $Geometry(Saddle_Height) - $Saddle(Height) - $SeatPost(PivotOffset) + $height_Setback]
            set length_SeatTube     [expr $ST_height / tan([vectormath::rad $value])]
                #
            set Geometry(Saddle_Distance)    [expr $length_Setback + $length_SeatTube]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Default_SeatTubeDirection   ... check $Geometry(SeatTube_Angle)  ->  $value"
                #
            return $Geometry(SeatTube_Angle)
                #
    }
    proc bikeGeometry::set_Default_FrontWheelhorizontal     {value} {
                #
                # Length/FrontWheel/horizontal
                # Geometry(FrontWheel_x)
                #
            variable Geometry
            variable HandleBar
                #
            puts "    <1> set_Default_FrontWheelhorizontal   ... check $Geometry(FrontWheel_x)  ->  $value"
                #
            set delta                           [expr $value - $Geometry(FrontWheel_x)]
                #
            set Geometry(HandleBar_Distance)    [expr $Geometry(HandleBar_Distance)    + $delta ]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Default_FrontWheelhorizontal   ... check $Geometry(FrontWheel_x)  ->  $value"
                #
            return Geometry(FrontWheel_x)
                #
    }
    proc bikeGeometry::set_Default_RearWheelhorizontal      {value} {
                #
                # Length/RearWheel/horizontal
                # Geometry(FrontWheel_x)
                #
            variable Geometry
            variable BottomBracket
            variable RearWheel
                #
            puts "    <1> set_Default_RearWheelhorizontal   ... check $Geometry(FrontWheel_x)  ->  $value"
                #
            set Geometry(ChainStay_Length)  [ expr { sqrt( $value * $value + $Geometry(BottomBracket_Depth) * $Geometry(BottomBracket_Depth) ) } ]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Default_RearWheelhorizontal   ... check $Geometry(FrontWheel_x)  ->  $value"
                #
            return $Geometry(FrontWheel_x)
                #
    }
    proc bikeGeometry::set_Default_FrontWheeldiagonal       {value} {
                #
                # Length/FrontWheel/diagonal
                # Geometry(FrontWheel_xy)
                #
            variable Geometry
            variable Position
                #
            variable Fork
            variable FrontWheel
            variable HandleBar
            variable HeadTube
            variable Stem
                #
            puts "    <1> set_Default_FrontWheeldiagonal   ... check $Geometry(FrontWheel_xy)  ->  $value"
                #
            set vect_01     [ expr $Geometry(Stem_Length) * cos($Geometry(Stem_Angle) * $vectormath::CONST_PI / 180) ]
            set vect_02     [ expr $vect_01 - $Geometry(Fork_Rake) ]
                #
            set dist_x      [ expr { sqrt( $value * $value - $Geometry(FrontWheel_y) * $Geometry(FrontWheel_y) ) } ]
            set position    [ list $dist_x $Geometry(FrontWheel_y)]
                #
            set help_03     [ vectormath::cathetusPoint   $Position(HandleBar)    $position    $vect_02  close ]
            set vect_HT     [ vectormath::parallel        $help_03                $position    $Geometry(Fork_Rake) ]
                #
            set help_01     [ lindex $vect_HT 0]
            set help_02     [ lindex $vect_HT 1]
            set help_03     [list -200 [ lindex $help_02 1] ]
                #
            set Geometry(HeadTube_Angle)    [vectormath::angle    $help_01 $help_02 $help_03 ]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Default_FrontWheeldiagonal   ... check $Geometry(FrontWheel_xy)  ->  $value"
                #
            return $Geometry(FrontWheel_xy)
                #
    }
    proc bikeGeometry::set_Default_SaddleOffset_HB          {value} {
                #
                # Length/Saddle/Offset_HB
                # Geometry(Saddle_HB_y)
                #
            variable Geometry
            variable HandleBar
                #
            puts "    <1> set_Default_SaddleOffset_HB   ... check $Geometry(Saddle_HB_y)  ->  $value"
                #
            set delta                       [expr $Geometry(Saddle_HB_y) - $value ]
                #
            set Geometry(HandleBar_Height)  [expr $Geometry(HandleBar_Height)    + $delta ]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Default_SaddleOffset_HB   ... check $Geometry(Saddle_HB_y)  ->  $value"
                #
            return $Geometry(Saddle_HB_y)
                #
    }
    proc bikeGeometry::set_Default_SaddleOffset_BB_ST       {value} {
                #
                # Length/Saddle/Offset_BB_ST
                # Geometry(Saddle_Offset_BB_ST)
                #
            variable Geometry
            variable Saddle
                #
            puts "    <1> set_Default_SaddleOffset_BB_ST   ... check $Geometry(Saddle_Offset_BB_ST)  ->  $value"
                #
            set angle                   [vectormath::dirAngle {0 0} [list $value $Geometry(Saddle_Height)] ]
                #
            bikeGeometry::set_Default_SeatTubeDirection $angle
                #
            puts "    <2> set_Default_SaddleOffset_BB_ST   ... check $Geometry(Saddle_Offset_BB_ST)  ->  $value"
                #
            return $Geometry(Saddle_Offset_BB_ST)
                #
    }
    proc bikeGeometry::set_Default_SaddleOffset_BB_Nose     {value} {
                #
                # Length/Saddle/Offset_BB_Nose
                # Geometry(SaddleNose_BB_x)
                #
            variable Geometry     
            variable Saddle     
                #
            puts "    <1> set_Default_SaddleOffset_BB_Nose   ... check $Geometry(SaddleNose_BB_x)  ->  $value"
                #
            set delta                       [expr -1.0 * ($value - $Geometry(SaddleNose_BB_x)) ]
                #
            set Saddle(Offset_x)            [expr $Saddle(Offset_x) + $delta ]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Default_SaddleOffset_BB_Nose   ... check $Geometry(SaddleNose_BB_x)  ->  $value"
                #
            return $Geometry(SaddleNose_BB_x)
                #
    }
    proc bikeGeometry::set_Default_SaddleSeatTube_BB        {value} {
                #
                # Length/Saddle/SeatTube_BB
                # Geometry(Saddle_BB)
                #
            variable Geometry
            variable Position
            variable Saddle
                #
            puts "    <1> set_Default_SaddleSeatTube_BB   ... check $Geometry(Saddle_BB)  ->  $value"
                # 
            set angle_SeatTube          $Geometry(SeatTube_Angle)
            set pos_SeatTube_old        $Position(SeatTube_Saddle)
            set pos_Saddle_old          $Position(Saddle)
                #
            set pos_SeatTube_x          [expr $value * cos([vectormath::rad $Geometry(SeatTube_Angle)])]
            set pos_SeatTube_y          [expr $value * sin([vectormath::rad $Geometry(SeatTube_Angle)])]
                #
            set delta_Saddle_ST         [expr [lindex $Position(Saddle) 0] - [lindex $Position(SeatTube_Saddle) 0]]
                #
            set pos_Saddle_x            [expr $pos_SeatTube_x - $delta_Saddle_ST]
            set pos_Saddle_y            $pos_SeatTube_y
                #
            set Geometry(Saddle_Distance)  [format "%.3f" $pos_Saddle_x]
            set Geometry(Saddle_Height)    [format "%.3f" $pos_Saddle_y]
                #
            bikeGeometry::update_Geometry
                #                    
            puts "    <2> set_Default_SaddleSeatTube_BB   ... check $Geometry(Saddle_BB)  ->  $value"
                # 
            return $Geometry(Saddle_BB)
                #
    }
    proc bikeGeometry::set_Default_PersonalSaddleNose_HB    {value} {
                #
                # Length/Personal/SaddleNose_HB
                # Geometry(SaddleNose_HB
                #
            variable Geometry
            variable HandleBar      
                #
            puts "    <1> set_Default_SaddleSeatTube_BB   ... check $Geometry(SaddleNose_HB)  ->  $value"
                #
            set delta                           [expr $value - $Geometry(SaddleNose_HB) ]
                #
            set Geometry(HandleBar_Distance)    [expr $Geometry(HandleBar_Distance) + $delta ]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Default_SaddleSeatTube_BB   ... check $Geometry(SaddleNose_HB)  ->  $value"
                #
            return $Geometry(SaddleNose_HB)
                #            
    }
    proc bikeGeometry::set_Default_RearWheelRadius          {value} {
                #
                # ... unused ?
                #
                # Length/RearWheel/Radius
                # Geometry(RearTyre_Height)
                #
            variable Geometry
            variable RearWheel
                #
            puts "    <1> set_Default_RearWheelRadius   ... check $Geometry(RearTyre_Height)  ->  $value"
                #
            set Geometry(RearTyre_Height)   [ expr $value - 0.5 * $Geometry(RearRim_Diameter)]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Default_RearWheelRadius   ... check $Geometry(RearTyre_Height)  ->  $value"
                #
            return $Geometry(RearWheel_Radius) 
                #
    }
    proc bikeGeometry::set_Default_RearWheelTyreShoulder    {value} {
                #
                # Length/RearWheel/TyreShoulder
                # RearWheel(TyreShoulder)
                #
            variable Geometry
            variable RearWheel
                #
            puts "    <1> set_Default_RearWheelTyreShoulder   ... check $RearWheel(TyreShoulder)  ->  $value"
                #
            set RearWheel(TyreWidthRadius)  [ expr $Geometry(RearWheel_Radius) - abs($value)]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Default_RearWheelTyreShoulder   ... check $RearWheel(TyreShoulder)  ->  $value"
                #
            return $RearWheel(TyreShoulder)
                #
    }
    proc bikeGeometry::set_Default_FrontWheelRadius         {value} {
                #
                # ... unused ?
                #
                # Length/FrontWheel/Radius
                # Geometry(FrontTyre_Height)
                #
            variable FrontWheel
            variable Geometry
                #
            puts "    <1> set_Default_FrontWheelRadius   ... check $Geometry(FrontTyre_Height)  ->  $value"
                #
            set Geometry(FrontTyre_Height)  [ expr $value - 0.5 * $Geometry(FrontRim_Diameter)]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Default_FrontWheelRadius   ... check $Geometry(FrontTyre_Height)  ->  $value"
                #
            return $Geometry(FrontWheel_Radius) 
                #
    }
    proc bikeGeometry::set_Default_ReferenceHeigth_SN_HB    {value} {
                #
                # Length/Reference/Heigth_SN_HB
                # Reference(SaddleNose_HB_y)
                #
            variable Reference
                #
            puts "    <1> set_Default_ReferenceHeigth_SN_HB   ... check $Reference(SaddleNose_HB_y)  ->  $value"
                #
            set deltaValue                  [expr $value - $Reference(SaddleNose_HB_y)]
                #
            set Reference(HandleBar_Height) [expr $Reference(HandleBar_Height) - $deltaValue]  
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Default_ReferenceHeigth_SN_HB   ... check $Reference(SaddleNose_HB_y)  ->  $value"
                #
            return $Reference(SaddleNose_HB_y)
                #
    }
    proc bikeGeometry::set_Default_ReferenceSaddleNose_HB   {value} {
                #
                # Length/Reference/SaddleNose_HB
                # Reference(SaddleNose_HB)
                #
            variable Reference 
                #
            puts "    <1> set_Default_ReferenceSaddleNose_HB   ... check $Reference(SaddleNose_HB)  ->  $value "
                # 
            set Reference(HandleBar_Distance)   [ expr {sqrt( $value*$value - $Reference(SaddleNose_HB_y)*$Reference(SaddleNose_HB_y) )} ]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Default_ReferenceSaddleNose_HB   ... check $Reference(SaddleNose_HB)  ->  $value "
                #
            return $Reference(SaddleNose_HB)
                #
    }
  
    
    
       
   
   