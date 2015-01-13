    namespace eval bikeGeometry {
            #
        namespace ensemble create -command ::bikeGeometry::IF_StackReach \
                -map {
        
                    set_Component                        set_Component
                    set_Config                           set_Config
                    set_ListValue                        set_ListValue
                    set_Scalar                           set_Scalar_StackReach
                                                         
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

    proc bikeGeometry::set_Scalar_StackReach {object key value} {
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
                        {FrontWheel_x}                  {   bikeGeometry::set_Default_FrontWheelhorizontal   $newValue; return [get_Scalar $object $key] }
                        {HeadLug_Angle_Top}             {   bikeGeometry::set_Default_HeadTube_TopTubeAngle  $newValue; return [get_Scalar $object $key] }
                        {RearWheel_Radius}              {   bikeGeometry::set_Default_RearWheelRadius        $newValue; return [get_Scalar $object $key] }
                        {RearWheel_x}                   {   bikeGeometry::set_Default_RearWheelhorizontal    $newValue; return [get_Scalar $object $key] }
                        {SaddleNose_BB_x}               {   bikeGeometry::set_Default_SaddleOffset_BB_Nose   $newValue; return [get_Scalar $object $key] }
                        {SaddleNose_HB}                 {   bikeGeometry::set_Default_PersonalSaddleNose_HB  $newValue; return [get_Scalar $object $key] }
                        {Saddle_BB}                     {   bikeGeometry::set_Default_SaddleSeatTube_BB      $newValue; return [get_Scalar $object $key] }
                        {Saddle_Offset_BB_ST}           {   bikeGeometry::set_Default_SaddleOffset_BB_ST     $newValue; return [get_Scalar $object $key] }
                        {SeatTube_Angle}                {   bikeGeometry::set_Default_SeatTubeDirection      $newValue; return [get_Scalar $object $key] }
                        
                        {HeadTube_Angle}                {   bikeGeometry::set_StackReach_HeadTubeDirection   $newValue; return [get_Scalar $object $key] }
                        {Reach_Length}                  {   bikeGeometry::set_StackReach_HeadTubeReachLength $newValue; return [get_Scalar $object $key] }
                        {Stack_Height}                  {   bikeGeometry::set_StackReach_HeadTubeStackHeight $newValue; return [get_Scalar $object $key] }
                        {FrontWheel_xy}                 {   bikeGeometry::set_StackReach_FrontWheeldiagonal  $newValue; return [get_Scalar $object $key] }
                        {Saddle_HB_y}                   {   bikeGeometry::set_StackReach_SaddleOffset_HB     $newValue; return [get_Scalar $object $key] }
                        
                        {SeatTube_Virtual}              {   return [get_Scalar $object $key] }
                        {TopTube_Virtual}               {   return [get_Scalar $object $key] }
                        
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
    proc bikeGeometry::set_StackReach_HeadTubeReachLength      {value} {
                #
                # Length/HeadTube/ReachLengt
                # Geometry(Reach_Length)
                #
            variable Geometry
            variable HandleBar
                #
            puts "    <1> set_StackReach_HeadTubeReachLength   ... check $Geometry(Reach_Length) ->  $value"
                #
            set delta                           [expr $value - $Geometry(Reach_Length)]
                #
            set Geometry(HandleBar_Distance)    [expr $Geometry(HandleBar_Distance)    + $delta]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_StackReach_HeadTubeReachLength   ... check $Geometry(Reach_Length) ->  $value"
                #
            return $Geometry(Reach_Length)
                #
    }
    proc bikeGeometry::set_StackReach_HeadTubeStackHeight      {value} {
                #
                # Length/HeadTube/StackHeight
                # Geometry(Stack_Height)
                #
            variable Geometry
            variable HeadTube
            variable HandleBar
                #
            puts "    <1> set_StackReach_HeadTubeStackHeight   ... check $Geometry(Stack_Height)  ->  $value"
                #
            set delta                   [expr $value - $Geometry(Stack_Height)]
  
            set deltaHeadTube           [expr $delta / sin($Geometry(HeadTube_Angle) * $vectormath::CONST_PI / 180) ]
            set offsetHeadTube_x        [expr $delta / tan($Geometry(HeadTube_Angle) * $vectormath::CONST_PI / 180) ]
                #
            set Geometry(HandleBar_Height)  [expr $Geometry(HandleBar_Height)    + $delta]
                #
            set HeadTube(Length)        [expr $HeadTube(Length) + $deltaHeadTube ]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_StackReach_HeadTubeStackHeight   ... check $Geometry(Stack_Height)  ->  $value"
                #
            return $Geometry(Stack_Height)
                #
    }
    proc bikeGeometry::set_StackReach_HeadTubeDirection        {value} {
                #
                # ... unused ?
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
            puts "    <1> set_StackReach_HeadTubeDirection   ... check $Geometry(FrontWheel_xy)  ->  $value"
                #
            set store_HeadTubeLength    $HeadTube(Length)
                #
            set store_ReachLength       $Geometry(Reach_Length)
            set store_StackHeight       $Geometry(Stack_Height)
            set store_HandleBarOffset   $Geometry(Saddle_HB_y)
                #
            set_Scalar Geometry  HeadTube_Angle $value
                #
            set_StackReach_HeadTubeStackHeight  $store_StackHeight 
            set_StackReach_HeadTubeReachLength  $store_ReachLength
                #
            set_StackReach_SaddleOffset_HB      $store_HandleBarOffset
                #
            # set_Scalar     HeadTube Length      $store_HeadTubeLength    
                #
            puts "    <2> set_StackReach_HeadTubeDirection   ... check $Geometry(FrontWheel_xy)  ->  $value"
                #
            return $Geometry(FrontWheel_xy)
    }
    proc bikeGeometry::set_StackReach_FrontWheeldiagonal       {value} {
                #
                # ... unused ?
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
            puts "    <1> set_StackReach_FrontWheeldiagonal   ... check $Geometry(FrontWheel_xy)  ->  $value"
                #
            set store_HeadTubeLength    $HeadTube(Length)
                #
            set store_ReachLength       $Geometry(Reach_Length)
            set store_StackHeight       $Geometry(Stack_Height)
            set store_HandleBarOffset   $Geometry(Saddle_HB_y)
                #
            set dist_x      [ expr { sqrt( $value * $value - $Geometry(FrontWheel_y) * $Geometry(FrontWheel_y) ) } ]
            set position    [ list $dist_x $Geometry(FrontWheel_y)]
                #
            set p_ct        [ vectormath::cathetusPoint   $Position(HeadTube_End)   $position   $Geometry(Fork_Rake) opposite]
            set p_01        $Position(HeadTube_End)
            set p_02        [list -100 [lindex $p_ct 1]]
                #
            set Geometry(HeadTube_Angle)    [vectormath::angle    $p_01 $p_ct $p_02 ]
                #
            bikeGeometry::update_Geometry
                #
            set_StackReach_HeadTubeStackHeight  $store_StackHeight 
            set_StackReach_HeadTubeReachLength  $store_ReachLength
                #
            set_StackReach_SaddleOffset_HB      $store_HandleBarOffset
                #
            # set_Scalar     HeadTube Length      $store_HeadTubeLength    
                #
            puts "    <2> set_StackReach_FrontWheeldiagonal   ... check $Geometry(FrontWheel_xy)  ->  $value"
                #
            return $Geometry(FrontWheel_xy)
    }
    proc bikeGeometry::set_StackReach_SaddleOffset_HB          {value} {
                #
                # Length/Saddle/Offset_HB
                # Geometry(Saddle_HB_y)
                #
            variable Geometry
            variable HandleBar
            variable HeadTube
                #
            puts "    <1> set_StackReach_SaddleOffset_HB   ... check $Geometry(Saddle_HB_y)  ->  $value"
                #
            set delta_y                     [expr $Geometry(Saddle_HB_y) - $value ]
            set delta_x                     [expr $delta_y / tan($Geometry(HeadTube_Angle) * $vectormath::CONST_PI / 180) ]
                #
            set Geometry(HandleBar_Height)      [expr $Geometry(HandleBar_Height)   + $delta_y ]
            set Geometry(HandleBar_Distance)    [expr $Geometry(HandleBar_Distance) - $delta_x ]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_StackReach_SaddleOffset_HB   ... check $Geometry(Saddle_HB_y)  ->  $value"
                #
            return $Geometry(Saddle_HB_y)
                #
    }
