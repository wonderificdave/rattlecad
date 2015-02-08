    namespace eval bikeGeometry {
            #
        namespace ensemble create -command ::bikeGeometry::IF_Classic \
                -map {
        
                        set_Component                        set_Component
                        set_Config                           set_Config
                        set_ListValue                        set_ListValue
                        set_Scalar                           set_Scalar_Classic
                                                             
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
                        get_openSCADContent                  get_openSCADContent
                        
                        coords_xy_index                      coords_xy_index
                                                        
                    }

    }

    proc bikeGeometry::set_Scalar_Classic {object key value} {
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
                        {BottomBracket_Height}          {   bikeGeometry::set_Default_BottomBracketHeight   $newValue; return [get_Scalar $object $key] }
                        {FrontWhee_Radius}              {   bikeGeometry::set_Default_FrontWheelRadius      $newValue; return [get_Scalar $object $key] }
                        {HeadLug_Angle_Top}             {   bikeGeometry::set_Default_HeadTube_TopTubeAngle $newValue; return [get_Scalar $object $key] }
                        {RearWheel_Radius}              {   bikeGeometry::set_Default_RearWheelRadius       $newValue; return [get_Scalar $object $key] }
                        {RearWheel_x}                   {   bikeGeometry::set_Default_RearWheelhorizontal   $newValue; return [get_Scalar $object $key] }
                        {SaddleNose_BB_x}               {   bikeGeometry::set_Default_SaddleOffset_BB_Nose  $newValue; return [get_Scalar $object $key] }
                        {SaddleNose_HB}                 {   bikeGeometry::set_Default_PersonalSaddleNose_HB $newValue; return [get_Scalar $object $key] }
                        {Saddle_BB}                     {   bikeGeometry::set_Default_SaddleSeatTube_BB     $newValue; return [get_Scalar $object $key] }
                            
                        {Saddle_Offset_BB_ST}           {   return [get_Scalar $object $key] }  
                        {FrontWheel_x}                  {   return [get_Scalar $object $key] }  
                            
                        {Reach_Length}                  {   return [get_Scalar $object $key] }  
                        {Stack_Height}                  {   return [get_Scalar $object $key] }  
                            
                        {Saddle_HB_y}                   {   bikeGeometry::set_StackReach_SaddleOffset_HB    $newValue; return [get_Scalar $object $key] }
                        {FrontWheel_xy}                 {   bikeGeometry::set_StackReach_FrontWheeldiagonal $newValue; return [get_Scalar $object $key] }
                         
                        {SeatTube_Angle}                {   bikeGeometry::set_Classic_SeatTubeDirection     $newValue; return [get_Scalar $object $key] }
                        {HeadTube_Virtual}              {   bikeGeometry::set_Classic_HeadTubeVirtualLength $newValue; return [get_Scalar $object $key] }
                        {SeatTube_Virtual}              {   bikeGeometry::set_Classic_SeatTubeVirtualLength $newValue; return [get_Scalar $object $key] }
                        {TopTube_Virtual}               {   bikeGeometry::set_Classic_TopTubeVirtualLength  $newValue; return [get_Scalar $object $key] }
                        
                        default {}
                    }
                }
            RearWheel {
                    switch -exact $key {
                        {TyreShoulder}              {   bikeGeometry::set_Default_RearWheelTyreShoulder  $newValue; return [get_Scalar $object $key] }
                        
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
    proc bikeGeometry::set_Classic_SeatTubeVirtualLength    {value} {
                #
            variable Geometry
            variable HeadTube
                #
            puts "    <1> set_Classic_SeatTubeVirtualLength   ... check $Geometry(SeatTube_Virtual)  ->  $value"
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
            set Geometry(SeatTube_Virtual) $value
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Classic_SeatTubeVirtualLength   ... check $Geometry(SeatTube_Virtual)  ->  $value"
                #
            return $Geometry(SeatTube_Virtual)
                #
    } 
    proc bikeGeometry::set_Classic_TopTubeVirtualLength     {value} {
                #
            variable Geometry
                #
            puts "    <1> set_Classic_TopTubeVirtualLength   ... check $Geometry(TopTube_Virtual) ->  $value"
                #
            set delta                           [expr $value - $Geometry(TopTube_Virtual)]
                #
            puts "  \$Geometry(HandleBar_Distance) $Geometry(HandleBar_Distance)"
            puts "       \$delta $delta"
            set Geometry(HandleBar_Distance)    [expr $Geometry(HandleBar_Distance)    + $delta ]
            puts "  \$Geometry(HandleBar_Distance) $Geometry(HandleBar_Distance)"
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Classic_TopTubeVirtualLength   ... check $Geometry(TopTube_Virtual) ->  $value"
                #
            return $Geometry(TopTube_Virtual)
                #
    }
    proc bikeGeometry::set_Classic_HeadTubeVirtualLength    {value} {
                #
            variable Geometry
                #
            puts "    <1> set_Classic_TopTubeVirtualLength   ... check $Geometry(HeadTube_Virtual) ->  $value"
                #
            set delta_ht                        [expr $value - $Geometry(HeadTube_Virtual)]
                #
            set delta_y                         [expr $delta_ht * sin($Geometry(HeadTube_Angle) * $vectormath::CONST_PI / 180) ]
                #
            set delta_st                        [expr $delta_y  / sin($Geometry(SeatTube_Angle) * $vectormath::CONST_PI / 180) ]
                #
            set Geometry(SeatTube_Virtual)      [expr $Geometry(SeatTube_Virtual) + $delta_st]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Classic_TopTubeVirtualLength   ... check $Geometry(HeadTube_Virtual) ->  $value"
                #
            return $Geometry(HeadTube_Virtual)
                #    
    }
    proc bikeGeometry::set_Classic_SeatTubeDirection        {value} {
                #
            variable Geometry
                #
            puts "    <1> set_Classic_SeatTubeDirection   ... check $Geometry(SeatTube_Angle) ->  $value"
                #
            set topTubeVirtual                  $Geometry(TopTube_Virtual)
                #
            set_Default_SeatTubeDirection       $value
                #
            set_Classic_TopTubeVirtualLength    $topTubeVirtual
                #
            puts "    <2> set_Classic_SeatTubeDirection   ... check $Geometry(SeatTube_Angle) ->  $value"
                #
            return $Geometry(SeatTube_Angle)
                #    
    }
    
    