#!/bin/sh
# test_bikeGoemetry_1.0.tcl \
exec tclsh "$0" ${1+"$@"}



puts "\n\n ====== I N I T ============================ \n\n"

    # -- ::APPL_Config(BASE_Dir)  ------
    set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
        puts "   -> \$BASE_Dir:   $BASE_Dir\n"

        # -- Libraries  ---------------
    lappend auto_path           [file join $BASE_Dir lib]
    lappend auto_path           [file join $BASE_Dir ..]
        # puts "   -> \$auto_path:  $auto_path"

        # -- Packages  ---------------
    package require   bikeGeometry  1.28
    package require   appUtil

        # -- Directories  ------------
    set TEST_Dir    [file join $BASE_Dir test]
    set SAMPLE_Dir  [file join $TEST_Dir sample]
        # puts "   -> SAMPLE_Dir: $SAMPLE_Dir"
    
        # -- Dictionary  ------------
    variable projectDict
        
        # -- FAILED - Queries --------
    variable failedQueries; array set failedQueries {}

        # -- sampleFile  -----------
    set sampleFile  [file join $SAMPLE_Dir template_road_3.4.xml]
    set sampleFile  [file join $SAMPLE_Dir __debug_3.4.01.74__01__simplon_phasic_56_sramRed.xml]
    set sampleFile  [file join $SAMPLE_Dir __test_3.4.01_74.xml]
    set sampleFile  [file join $SAMPLE_Dir __test_3.4.01_74_b.xml]
        # puts "   -> sampleFile: $sampleFile"

         # -- Content  --------------
    puts "\n   -> getContent: $sampleFile:"
    set fp [open $sampleFile]
    fconfigure    $fp -encoding utf-8
    set xml [read $fp]
    close         $fp
    set sampleDOC   [dom parse  $xml]
    set sampleDOM   [$sampleDOC documentElement]
        #
    bikeGeometry::set_newProject $sampleDOM
        #
    bikeGeometry::set_to_project
        #
    set projectDict [bikeGeometry::get_projectDICT]
        #
        #
        #
    proc compareValues {procName argList compValue {projectXpath {_noXPath_}}} {
        variable failedQueries
        variable projectDict
            #
        switch -exact $procName {           
            get_Component   {set dictRootName Component }
            get_Config      {set dictRootName Config    }
            get_Scalar      {set dictRootName Scalar    }
            get_ListValue   {set dictRootName ListValue }
            get_BoundingBox -
            get_CenterLine  -
            get_Direction   -
            get_Polygon     -
            get_Position    -
            get_TubeMiter   {set dictRootName _noDict_  }
        }
        
        
        switch -exact [llength $argList] {
            1   {   set key_1 [lindex $argList 0]
                    set dictPath    $dictRootName/$key_1
                    set getterValue [bikeGeometry::$procName $key_1]
                    set dictValue   [appUtil::get_dictValue $projectDict $dictPath]
                    set keyString   "$dictRootName/$key_1"
                }
            2   {   set key_1 [lindex $argList 0]
                    set key_2 [lindex $argList 1]
                    set dictPath    $dictRootName/$key_1/$key_2
                    set getterValue [bikeGeometry::$procName $key_1 $key_2 ]
                    set dictValue   [appUtil::get_dictValue $projectDict $dictPath]
                    set keyString   "$dictRootName/$key_1/$key_2"
                }
            3   {   set key_1 [lindex $argList 0]
                    set key_2 [lindex $argList 1]
                    set key_3 [lindex $argList 2]
                    set dictPath    $dictRootName/$key_1/$key_2/$key_3
                    set getterValue [bikeGeometry::$procName $key_1 $key_2 $key_3 ]
                    set dictValue   [appUtil::get_dictValue $projectDict $dictPath]
                    set keyString   "$dictRootName/$key_1/$key_2/$key_3"
               }
        }
        
        
            #
        if {$dictRootName == {_noDict_}} {
            set dictValue {_noDict_}
        }
            #
        switch -exact $projectXpath {
            {_noXPath_} {   set xpathValue "_noXPath_"  }
            default     {   set xpathValue [get_xPathValue $projectXpath]   }
        }
            #
        switch -exact $procName {           
            get_BoundingBox {set headerLabel  "BoundingBox/$argList"}
            get_CenterLine  {set headerLabel  "CenterLine/$argList" }
            get_Direction   {set headerLabel  "Direction/$argList"  }
            get_Polygon     {set headerLabel  "Polygon/$argList"    }
            get_Position    {set headerLabel  "Position/$argList"   }
            get_TubeMiter   {set headerLabel  "TubeMiter/$argList"  }
            default         {set headerLabel  $keyString  }
        }
            #
        switch -exact $procName {           
            get_Position    {
                                foreach {x_comp     y_comp}     $compValue      break
                                foreach {x_getter   y_getter}   $getterValue    break
                                if {$x_comp == $x_getter && $y_comp == $y_getter} {
                                    set compValue $getterValue
                                }
                            }
            get_TubeMiter_  {
                                foreach {x_comp     y_comp}     $compValue      break
                                foreach {x_getter   y_getter}   $getterValue    break
                                if {[format {%.5f} $x_comp] == [format {%.5f} $x_getter] && [format {%.5f} $y_comp] == [format {%.5f} $y_getter]} {
                                    set compValue $getterValue
                                }
                            }
                
                            
            default         {}
        }
            #
        set compValue   [string range $compValue    0 80]
        set getterValue [string range $getterValue  0 80]
        set dictValue   [string range $dictValue    0 80]
        set xpathValue  [string range $xpathValue   0 80]
        
            #
        puts     "    ... $headerLabel"
        puts     "                       ... $compValue"
        if {$compValue == $getterValue} {
            puts "                       ... $getterValue"
        } else {
            puts "            ... failed ... $getterValue"
            # set keyString "$procName@$keyString@getter"
            set failedQueries($keyString) [list $getterValue]
            #exit
        }
        if {$compValue == $dictValue} {
            puts "                       ... $dictValue ... $dictPath"
        } else {
            if {$dictValue == {_noDict_}} {
                puts "                       ... $dictValue"
            } else {
                puts "            ... failed ... $dictValue ... $dictPath"
                # set keyString "$procName@$keyString@dictionary"
                set failedQueries($keyString) [list $dictValue]
            }
            #exit
        }
        if {$compValue == $xpathValue} {
            puts "                       ... $xpathValue ... $projectXpath"
        } else {
            if {$xpathValue == {_noXPath_}} {
                puts "                       ... $xpathValue"
            } else {
                puts "            ... failed ... $xpathValue ... $projectXpath"
                # set keyString "$procName@$keyString@dictionary"
                set failedQueries($keyString) [list $xpathValue]
            }
            #exit
        }
    }
    
    proc get_xPathValue {xPath} {
        foreach {_array _name path} [unifyKey $xPath] break
        set returnValue {}
        catch {set returnValue [lindex [array get ::project::$_array $_name] 1]}
        return $returnValue
    }
    
    proc unifyKey {key} {
        
        set isArray [string first "(" $key 0]
        if {$isArray > 1} {
              # puts "          <D> -> got Array  $key <- ($isArray)"
            set arrayName   [lindex [split $key (]  0]
            set keyName     [lindex [split $key ()] 1]
            set xPath       [format "%s/%s" $arrayName $keyName]
              # puts "          <D> -> got Array  $arrayName $keyName"
            return [list $arrayName $keyName $xPath]
        } else {
            set values      [split $key /]
            set slashIndex  [string first {/} $key 1]
              # puts "          <D> -> got xPath  $key <- ($isArray) <- $slashIndex"
            set arrayName   [string range $key 0 $slashIndex-1]
            set keyName     [string range $key $slashIndex+1 end]       
            set xPath       [format "%s/%s" $arrayName $keyName]
              # puts "          <D> -> got xPath  $arrayName $keyName"
            return [list $arrayName $keyName $xPath]
        }
        #
    }
    
    proc reportComparison {{mode {}}} {
            #
        variable failedQueries
            #
        if {$mode == {}} {
            puts "    -----------------------------------------"
        } else {
            puts "\n"
            puts "-- reportComparison ---------------------------------"
            if {[array size failedQueries] > 0} {
                parray failedQueries
            } else {
                puts "\n      ... seems to be OK!\n"
            }
            puts "-- reportComparison ---------------------------------"
            puts "\n"
            exit
        }
    }
        #
        #
    set BB_Position         {0 0}
    set FrontHub_Position   {-400 50}
    set RearHub_Position    {600 50}
        #
        #
        
        #
    puts "\n"
        #
        #
        #
    
    compareValues    get_Scalar         {Geometry RearWheel_Radius}                 $::bikeGeometry::Geometry(RearWheel_Radius)                     Result(Length/RearWheel/Radius)                     ;# set _lastValue(Result/Length/RearWheel/Radius)                          
    compareValues    get_Scalar         {Geometry RearWheel_x}                      $::bikeGeometry::Geometry(RearWheel_x)                          Result(Length/RearWheel/horizontal)                 ;# set _lastValue(Result/Length/RearWheel/horizontal)                      
    
    compareValues    get_Scalar         {Geometry ChainStay_Length}                 $::bikeGeometry::Geometry(ChainStay_Length)                     Custom(WheelPosition/Rear)                          ;# set _lastValue(Custom/WheelPosition/Rear)                               
    compareValues    get_Scalar         {Lugs BottomBracket_ChainStay_Angle}        $::bikeGeometry::Lugs(BottomBracket_ChainStay_Angle)            Lugs(BottomBracket/ChainStay/Angle/value)           ;# set _lastValue(Lugs/BottomBracket/ChainStay/Angle/value)                
    compareValues    get_Scalar         {Lugs BottomBracket_DownTube_Angle}         $::bikeGeometry::Lugs(BottomBracket_DownTube_Angle)             Lugs(BottomBracket/DownTube/Angle/value)            ;# set _lastValue(Lugs/BottomBracket/DownTube/Angle/value)                 
    compareValues    get_Scalar         {Lugs HeadLug_Bottom_Angle}                 $::bikeGeometry::Lugs(HeadLug_Bottom_Angle)                     Lugs(HeadTube/DownTube/Angle/value)                 ;# set _lastValue(Lugs/HeadTube/DownTube/Angle/value)                      
    
    compareValues    get_Scalar         {DownTube DiameterHT}                       $::bikeGeometry::DownTube(DiameterHT)                           FrameTubes(DownTube/DiameterHT)                     ;# set _lastValue(FrameTubes/DownTube/DiameterHT)                          
      
    compareValues    get_Scalar         {DownTube OffsetHT}                         $::bikeGeometry::DownTube(OffsetHT)                             Custom(DownTube/OffsetHT)                           ;# set _lastValue(Custom/DownTube/OffsetHT)                                
    compareValues    get_Scalar         {Geometry Fork_Height}                      $::bikeGeometry::Geometry(Fork_Height)                          Component(Fork/Height)                              ;# set _lastValue(Component/Fork/Height)                                   
    compareValues    get_Scalar         {HeadTube Diameter}                         $::bikeGeometry::HeadTube(Diameter)                             FrameTubes(HeadTube/Diameter)                       ;# set _lastValue(FrameTubes/HeadTube/Diameter)                            
    compareValues    get_Scalar         {Geometry Fork_Rake}                        $::bikeGeometry::Geometry(Fork_Rake)                            Component(Fork/Rake)                                ;# set _lastValue(Component/Fork/Rake)                                     
        
    compareValues    get_Scalar         {Geometry FrontWheel_Radius}                $::bikeGeometry::Geometry(FrontWheel_Radius)                    Result(Length/FrontWheel/Radius)                    ;# set _lastValue(Result/Length/FrontWheel/Radius)                         
    
        
    compareValues    get_Scalar         {Geometry FrontWheel_x}                     $::bikeGeometry::Geometry(FrontWheel_x)                         Result(Length/FrontWheel/horizontal)                ;# set _lastValue(Result/Length/FrontWheel/horizontal)                     
    compareValues    get_Scalar         {Geometry FrontWheel_Radius}                $::bikeGeometry::Geometry(FrontWheel_Radius)                    Result(Length/FrontWheel/Radius)                    ;# set _lastValue(Result/Length/FrontWheel/Radius)                         
        
        #
    puts "\n -------------------------------"
    puts " ... update Model\n"
    ::bikeGeometry::set_Scalar Geometry FrontRim_Diameter [expr $::bikeGeometry::Geometry(FrontRim_Diameter) -40] 
    ::bikeGeometry::set_Scalar Geometry FrontWheel_x      [expr 990 - $::bikeGeometry::Geometry(RearWheel_x)]     
        #
    bikeGeometry::set_to_project
        #
    puts " -------------------------------"
    compareValues    get_Scalar         {Geometry FrontWheel_Radius}                $::bikeGeometry::Geometry(FrontWheel_Radius)                    
    compareValues    get_Scalar         {Geometry FrontWheel_x}                     $::bikeGeometry::Geometry(FrontWheel_x)                         
        #
    puts "\n ... update Model ... done"
    puts " -------------------------------\n"
    





        
        
        
        
        # -- relative to DownTube
        #
    puts "\n --- ChainStay ---"
        #
    set length_ChainStay        $::bikeGeometry::Geometry(ChainStay_Length)
    set angle_ChainStayDownTube [expr $::bikeGeometry::Lugs(BottomBracket_ChainStay_Angle) + $::bikeGeometry::Lugs(BottomBracket_DownTube_Angle) - 90]
        #
    set perp_ChainStay          [expr $length_ChainStay * cos($angle_ChainStayDownTube * $vectormath::CONST_PI / 180 )]     
    set long_ChainStay          [expr $length_ChainStay * sin($angle_ChainStayDownTube * $vectormath::CONST_PI / 180 )]
        #
    puts "   ... \$length_ChainStay         $length_ChainStay"
    puts "   ... \$angle_ChainStayDownTube  $angle_ChainStayDownTube"
    puts "   ---------------------------------------------------"
    puts "   ... \$perp_ChainStay           $perp_ChainStay"
    puts "   ... \$long_ChainStay           $long_ChainStay"
    puts "   ---------------------------------------------------"
        #
        #
    puts "\n --- DownTube ---"
        #
    set radius_DownTube         [expr 0.5 * $::bikeGeometry::DownTube(DiameterHT)]
        #
    set perp_DownTube           $radius_DownTube     
    set long_DownTube           0
        #
    puts "   ... \$radius_DownTube          $radius_DownTube"
    puts "   ---------------------------------------------------"
    puts "   ... \$perp_DownTube            $perp_DownTube"
    puts "   ... \$long_DownTube            $long_DownTube"
    puts "   ---------------------------------------------------"
        #
        #
    puts "\n --- Fork --- "
        #
    set length_ForkHeight       [expr $::bikeGeometry::Geometry(Fork_Height) + $::bikeGeometry::DownTube(OffsetHT)]
    set angle_ForkHeight        [expr $::bikeGeometry::Lugs(HeadLug_Bottom_Angle) -90]
        #
    set perp_ForkHeight         [expr $length_ForkHeight * cos($angle_ForkHeight * $vectormath::CONST_PI / 180 )]    
    set long_ForkHeight         [expr $length_ForkHeight * sin($angle_ForkHeight * $vectormath::CONST_PI / 180 )]    
        #
    puts "   ... \$length_ForkHeight        $length_ForkHeight"
    puts "   ... \$angle_ForkHeight         $angle_ForkHeight"
    puts "   ---------------------------------------------------"
    puts "   ... \$perp_ForkHeight          $perp_ForkHeight"
    puts "   ... \$long_ForkHeight          $long_ForkHeight"
    puts "   ---------------------------------------------------"
        #
    set length_ForkRake         [expr $::bikeGeometry::Geometry(Fork_Rake)   + 0.5 * $::bikeGeometry::HeadTube(Diameter)]
    set angle_ForkRake          $::bikeGeometry::Lugs(HeadLug_Bottom_Angle)
        #
    set perp_ForkRake           [expr $length_ForkRake * cos($angle_ForkRake * $vectormath::CONST_PI / 180 )]    
    set long_ForkRake           [expr $length_ForkRake * sin($angle_ForkRake * $vectormath::CONST_PI / 180 )]    
        #
    puts "   ... \$length_ForkRake          $length_ForkRake "
    puts "   ... \$angle_ForkRake           $angle_ForkRake  "
    puts "   ---------------------------------------------------"
    puts "   ... \$perp_ForkRake            $perp_ForkRake"
    puts "   ... \$long_ForkRake            $long_ForkRake"
    puts "   ---------------------------------------------------"
        #
        #
    set perp_Summary            [expr $perp_ChainStay + $perp_DownTube + $perp_ForkHeight + $perp_ForkRake]
    set long_Summary            [expr $long_ChainStay + $long_DownTube + $long_ForkHeight + $long_ForkRake]
        #
    puts ""
    puts "\n\n === Summary === "
    puts "   ... \$perp_Summary             $perp_Summary"
    puts "   ... \$long_Summary             $long_Summary"
    puts "\n"
        #
        #
        #
    puts "\n --- WheelBase --- "
        #
    set x_WheelBase             [expr $::bikeGeometry::Geometry(FrontWheel_x) + $::bikeGeometry::Geometry(RearWheel_x)]
    set y_WheelBase             [expr $::bikeGeometry::Geometry(FrontWheel_Radius) - $::bikeGeometry::Geometry(RearWheel_Radius)]
    set length_WheelBase        [expr sqrt($y_WheelBase*$y_WheelBase + $x_WheelBase*$x_WheelBase)]
    set angle_WheelBase         [expr 180 * atan($y_WheelBase/$x_WheelBase) / $vectormath::CONST_PI]
        #
    puts "   ... \$x_WheelBase              $x_WheelBase "
    puts "   ... \$y_WheelBase              $y_WheelBase "
    puts "   ---------------------------------------------------"
    puts "   ... \$length_WheelBase         $length_WheelBase "
    puts "   ... \$angle_WheelBase          $angle_WheelBase "
    puts "   ---------------------------------------------------"
        #
        #
    puts "\n --- ChainStay --- "
        #
    set angle_DownTube         [expr 180 * asin($perp_Summary / $length_WheelBase) / $vectormath::CONST_PI]   
    set angle_ChainStay        [expr $angle_DownTube + $angle_ChainStayDownTube -90 + $angle_WheelBase]   
        #
    puts "   ---------------------------------------------------"
    puts "   ... \$angle_DownTube           $angle_DownTube "
    puts "   ... \$angle_ChainStay          $angle_ChainStay "
    puts "   ---------------------------------------------------"

        #
    reportComparison final    
    
    
    