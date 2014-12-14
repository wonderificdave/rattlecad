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
    package require   bikeGeometry  1.27
    package require   appUtil

        # -- Directories  ------------
    set TEST_Dir    [file join $BASE_Dir test]
    set SAMPLE_Dir  [file join $TEST_Dir sample]
        # puts "   -> SAMPLE_Dir: $SAMPLE_Dir"
        
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
        #
    variable projectDict
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
            get_CenterLine  {set headerLabel  "CenterLine/$argList"  }
            get_Direction   {set headerLabel  "Direction/$argList"  }
            get_Polygon     {set headerLabel  "Polygon/$argList"    }
            get_Position    {set headerLabel  "Position/$argList"   }
            get_TubeMiter   {set headerLabel  "Position/$argList"   }
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
                set failedQueries($keyString) [list $xPathValue]
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

    parray ::project::Project
    parray ::project::Personal
    parray ::project::Custom
    parray ::project::Reference
    parray ::project::FrameTubes
    parray ::project::Lugs
    parray ::project::Component
    parray ::project::Rendering
    parray ::project::Result

    
    
    