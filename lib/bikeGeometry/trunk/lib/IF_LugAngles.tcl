    namespace eval bikeGeometry {
            #
        namespace ensemble create -command ::bikeGeometry::IF_LugAngles \
                -map {
        
                        set_Component                       set_Component
                        set_Config                          set_Config
                        set_ListValue                       set_ListValue
                        set_Scalar                          set_Scalar_LugAngles                                   
                                                            
                        set_newProject                      set_newProject
                        
                        get_projectDOM                      get_projectDOM
                        get_projectDICT                     get_projectDICT
                                                            
                        import_ProjectSubset                import_ProjectSubset
                                                            
                        get_Component                       get_Component
                        get_Config                          get_Config
                        get_ListValue                       get_ListValue
                        get_Scalar                          get_Scalar
                                                            
                        get_Polygon                         get_Polygon
                        get_Position                        get_Position
                        get_Direction                       get_Direction
                        get_BoundingBox                     get_BoundingBox
                        get_TubeMiter                       get_TubeMiter
                        get_CenterLine                      get_CenterLine
                                                            
                        get_ComponentDir                    get_ComponentDir 
                        get_ComponentDirectories            get_ComponentDirectories
                        get_ListBoxValues                   get_ListBoxValues 
                                                            
                        get_DebugGeometry                   get_DebugGeometry
                        
                        validate_ChainStayCenterLine        validate_ChainStayCenterLine
                                                                                                                    
                        coords_xy_index                     coords_xy_index
                                                        
                    }

    }

    proc bikeGeometry::set_Scalar_LugAngles {object key value} {
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
                        {Reach_Length}                  {   return [get_Scalar $object $key] }
                        {RearWheel_Radius}              {   bikeGeometry::set_Default_RearWheelRadius        $newValue; return [get_Scalar $object $key] }
                        {RearWheel_x}                   {   bikeGeometry::set_Default_RearWheelhorizontal    $newValue; return [get_Scalar $object $key] }
                        {SaddleNose_BB_x}               {   bikeGeometry::set_Default_SaddleOffset_BB_Nose   $newValue; return [get_Scalar $object $key] }
                        {SaddleNose_HB}                 {   bikeGeometry::set_Default_PersonalSaddleNose_HB  $newValue; return [get_Scalar $object $key] }
                        {Saddle_BB}                     {   bikeGeometry::set_Default_SaddleSeatTube_BB      $newValue; return [get_Scalar $object $key] }
                        {Saddle_Offset_BB_ST}           {   bikeGeometry::set_Default_SaddleOffset_BB_ST     $newValue; return [get_Scalar $object $key] }
                        {SeatTube_Angle}                {   bikeGeometry::set_Default_SeatTubeDirection      $newValue; return [get_Scalar $object $key] }
                        {Stack_Height}                  {   return [get_Scalar $object $key] }

                        {BottomBracket_Angle_ChainStay} {   bikeGeometry::model_lugAngle::set_Angle ChainStaySeatTube $newValue; return [get_Scalar $object $key] }                     
                        {BottomBracket_Angle_DownTube}  {   bikeGeometry::model_lugAngle::set_Angle SeatTubeDownTube  $newValue; return [get_Scalar $object $key] }                     
                        {HeadLug_Angle_Bottom}          {   bikeGeometry::model_lugAngle::set_Angle HeadTubeDownTube  $newValue; return [get_Scalar $object $key] }                     
                        
                        {HandleBar_Height}              {   bikeGeometry::set_LugAngles_HandleBar_Height     $newValue; return [get_Scalar $object $key] }                     
                        {Saddle_HB_x}                   {   bikeGeometry::set_Default_SaddleOffset_HB_X      $newValue; return [get_Scalar $object $key] }
                        {Saddle_HB_y}                   {   bikeGeometry::set_LugAngles_SaddleOffset_HB_Y    $newValue; return [get_Scalar $object $key] }
                        
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
    
    
    proc bikeGeometry::set_LugAngles_HandleBar_Height         {value} {
                #
                # Length/Saddle/Offset_HB
                # Geometry(Saddle_HB_y)
                #
            variable Geometry
            variable HandleBar
            variable HeadTube
                #
            puts "    <1> set_LugAngles_HandleBar_Height   ... check $Geometry(HandleBar_Height)  ->  $value"
                #
            set store_BottomBracket_ChainStay    $Geometry(BottomBracket_Angle_ChainStay)
            set store_BottomBracket_DownTube     $Geometry(BottomBracket_Angle_DownTube)
            set store_HeadLug_Bottom             $Geometry(HeadLug_Angle_Bottom)
                #
            set Geometry(HandleBar_Height)      $value
                #
            bikeGeometry::model_lugAngle::set_Angle HeadTubeDownTube    $store_HeadLug_Bottom       
                #
            puts "    <2> set_LugAngles_HandleBar_Height   ... check $Geometry(HandleBar_Height)  ->  $value"
                #
            return $Geometry(HandleBar_Height)
                #    
    }
    proc bikeGeometry::set_LugAngles_SaddleOffset_HB_X        {value} {
                #
                # Length/Saddle/Offset_HB
                # Geometry(Saddle_HB_y)
                #
            variable Geometry
            variable HandleBar
            variable HeadTube
                #
            puts "    <1> set_LugAngles_SaddleOffset_HB_X   ... check $Geometry(Saddle_HB_x)  ->  $value"
                #
            set delta_x                     [expr $value - $Geometry(Saddle_HB_y) ]
                #
            set Geometry(HandleBar_Height)  [expr $Geometry(HandleBar_Height) + $delta_x ]
                #
            set_LugAngles_HandleBar_Height    $Geometry(HandleBar_Height)       
                #
            puts "    <2> set_LugAngles_SaddleOffset_HB_X   ... check $Geometry(Saddle_HB_x)  ->  $value"
                #
            return $Geometry(Saddle_HB_x)
                #
    }        
    proc bikeGeometry::set_LugAngles_SaddleOffset_HB_Y        {value} {
                #
                # Length/Saddle/Offset_HB
                # Geometry(Saddle_HB_y)
                #
            variable Geometry
            variable HandleBar
            variable HeadTube
                #
            puts "    <1> set_LugAngles_SaddleOffset_HB_Y   ... check $Geometry(Saddle_HB_y)  ->  $value"
                #
            set delta_y                     [expr $Geometry(Saddle_HB_y) - $value ]
                #
            set Geometry(HandleBar_Height)  [expr $Geometry(HandleBar_Height)   + $delta_y ]
                #
            set_LugAngles_HandleBar_Height    $Geometry(HandleBar_Height)       
                #
            puts "    <2> set_LugAngles_SaddleOffset_HB_Y   ... check $Geometry(Saddle_HB_y)  ->  $value"
                #
            return $Geometry(Saddle_HB_y)
                #
    }    