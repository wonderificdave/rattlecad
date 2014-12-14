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
    package require   bikeGeometry  1.20
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
    proc compareValues_001 {procName argList {compValue {}} } {
        variable failedQueries
        variable projectDict
            #
        switch -exact $procName {           
            get_Component   {set dictRootName Component}
            get_Config      {set dictRootName Config}
            get_Scalar      {set dictRootName Scalar}
            get_ListValue   {set dictRootName ListValue}
        }
        
        
        switch -exact [llength $argList] {
            1   {   set key_1 [lindex $argList 0]
                    set getterValue [bikeGeometry::$procName $key_1]
                    set dictValue   [appUtil::get_dictValue $projectDict $dictRootName/$key_1]
                    set keyString   "$dictRootName/$key_1"
                }
            2   {   set key_1 [lindex $argList 0]
                    set key_2 [lindex $argList 1]
                    set getterValue [bikeGeometry::$procName $key_1 $key_2 ]
                    set dictValue   [appUtil::get_dictValue $projectDict $dictRootName/$key_1/$key_2]
                    set keyString   "$dictRootName/$key_1/$key_2"
                }
            3   {   set key_1 [lindex $argList 0]
                    set key_2 [lindex $argList 1]
                    set key_3 [lindex $argList 2]
                    set getterValue [bikeGeometry::$procName $key_1 $key_2 $key_3 ]
                    set dictValue   [appUtil::get_dictValue $projectDict $dictRootName/$key_1/$key_2/$key_3]
                    set keyString   "$dictRootName/$key_1/$key_2/$key_3"
               }
        }
        
        puts     "    ... $keyString"
            puts "                       ... $compValue"
        if {$compValue == $getterValue} {
            puts "                       ... $getterValue"
        } else {
            puts "            ... failed ... $getterValue"
            # set keyString "$procName@$keyString@getter"
            set failedQueries($keyString) [list $getterValue]
            #exit
        }
        if {$compValue == $dictValue} {
            puts "                       ... $dictValue"
        } else {
            puts "            ... failed ... $dictValue"
            # set keyString "$procName@$keyString@dictionary"
            set failedQueries($keyString) [list $dictValue]
            #exit
        }
    }
    
    proc compareValues {procName argList compValue {projectXpath {}}} {
        variable failedQueries
        variable projectDict
            #
        switch -exact $procName {           
            get_Component   {set dictRootName Component}
            get_Config      {set dictRootName Config}
            get_Scalar      {set dictRootName Scalar}
            get_ListValue   {set dictRootName ListValue}
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
        set xPathValue  [get_xPathValue $projectXpath]
            #
        puts     "    ... $keyString"
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
            puts "            ... failed ... $dictValue ... $dictPath"
            # set keyString "$procName@$keyString@dictionary"
            set failedQueries($keyString) [list $dictValue]
            #exit
        }
        if {$compValue == $xPathValue} {
            puts "                       ... $xPathValue ... $projectXpath"
        } else {
            puts "            ... failed ... $xPathValue ... $projectXpath"
            # set keyString "$procName@$keyString@dictionary"
            set failedQueries($keyString) [list $xPathValue]
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
    #compareValues    get_Scalar     {BottleCage DownTube        }  checkFailed_01
    #compareValues    get_Component  {HandleBar                  }  checkFailed_02
        #
    reportComparison
        #
    compareValues    get_Component  {CrankSet         }   $::bikeGeometry::Component(CrankSet)                  Component(CrankSet/File)        ;# set _lastValue(Component/CrankSet/File)                                                                              
    compareValues    get_Component  {ForkCrown        }   $::bikeGeometry::Component(ForkCrown)                 Component(Fork/Crown/File)      ;# set _lastValue(Component/Fork/Crown/File)                               
    compareValues    get_Component  {ForkDropout      }   $::bikeGeometry::Component(ForkDropout)               Component(Fork/DropOut/File)    ;# set _lastValue(Component/Fork/DropOut/File)                             
    compareValues    get_Component  {FrontBrake       }   $::bikeGeometry::Component(FrontBrake)                Component(Brake/Front/File)     ;# set _lastValue(Component/Brake/Front/File)                              
    compareValues    get_Component  {FrontCarrier     }   $::bikeGeometry::Component(FrontCarrier)              Component(Carrier/Front/File)   ;# set _lastValue(Component/Carrier/Front/File)                            
    compareValues    get_Component  {FrontDerailleur  }   $::bikeGeometry::Component(FrontDerailleur)           Component(Derailleur/Front/File);# set _lastValue(Component/Derailleur/Front/File)                         
    compareValues    get_Component  {HandleBar        }   $::bikeGeometry::Component(HandleBar)                 Component(HandleBar/File)       ;# set _lastValue(Component/HandleBar/File)                                
    compareValues    get_Component  {Logo             }   $::bikeGeometry::Component(Logo)                      Component(Logo/File)            ;# set _lastValue(Component/Logo/File)                                     
    compareValues    get_Component  {RearBrake        }   $::bikeGeometry::Component(RearBrake)                 Component(Brake/Rear/File)      ;# set _lastValue(Component/Brake/Rear/File)                               
    compareValues    get_Component  {RearCarrier      }   $::bikeGeometry::Component(RearCarrier)               Component(Carrier/Rear/File)    ;# set _lastValue(Component/Carrier/Rear/File)                             
    compareValues    get_Component  {RearDerailleur   }   $::bikeGeometry::Component(RearDerailleur)            Component(Derailleur/Rear/File) ;# set _lastValue(Component/Derailleur/Rear/File)                          
    compareValues    get_Component  {RearDropout      }   $::bikeGeometry::Component(RearDropout)               Lugs(RearDropOut/File)          ;# set _lastValue(Lugs/RearDropOut/File)                                   
    compareValues    get_Component  {Saddle           }   $::bikeGeometry::Component(Saddle)                    Component(Saddle/File)          ;# set _lastValue(Component/Saddle/File)                                   
        # -- new --
    compareValues    get_Component  {BottleCage_DownTube}       $::bikeGeometry::Component(BottleCage_DownTube)         Component(BottleCage/DownTube/File)       ;# set _lastValue(Component/Fork/DropOut/File)                             
    compareValues    get_Component  {BottleCage_DownTube_Lower} $::bikeGeometry::Component(BottleCage_DownTube_Lower)   Component(BottleCage/DownTube_Lower/File) ;# set _lastValue(Component/Fork/DropOut/File)                             
    compareValues    get_Component  {BottleCage_SeatTube}       $::bikeGeometry::Component(BottleCage_SeatTube)         Component(BottleCage/SeatTube/File)       ;# set _lastValue(Component/Fork/DropOut/File)                             
        #
    reportComparison
        #
    compareValues    get_Config     {BottleCage_DownTube}       $::bikeGeometry::Config(BottleCage_DownTube)            Rendering(BottleCage/DownTube)            ;# set _lastValue(Rendering/BottleCage/DownTube)                           
    compareValues    get_Config     {BottleCage_DownTube_Lower} $::bikeGeometry::Config(BottleCage_DownTube_Lower)      Rendering(BottleCage/DownTube_Lower)      ;# set _lastValue(Rendering/BottleCage/DownTube_Lower)                     
    compareValues    get_Config     {BottleCage_SeatTube}       $::bikeGeometry::Config(BottleCage_SeatTube)            Rendering(BottleCage/SeatTube)            ;# set _lastValue(Rendering/BottleCage/SeatTube)                           
    compareValues    get_Config     {ChainStay        }         $::bikeGeometry::Config(ChainStay)                      Rendering(ChainStay)                      ;# set _lastValue(Rendering/ChainStay)                                     
    compareValues    get_Config     {Fork             }         $::bikeGeometry::Config(Fork)                           Rendering(Fork)                           ;# set _lastValue(Rendering/Fork)                                          
    compareValues    get_Config     {ForkBlade        }         $::bikeGeometry::Config(ForkBlade)                      Rendering(ForkBlade)                      ;# set _lastValue(Rendering/ForkBlade)                                     
    compareValues    get_Config     {ForkDropout      }         $::bikeGeometry::Config(ForkDropout)                    Rendering(ForkDropOut)                    ;# set _lastValue(Rendering/ForkDropOut)                                   
    compareValues    get_Config     {FrontBrake       }         $::bikeGeometry::Config(FrontBrake)                     Rendering(Brake/Front)                    ;# set _lastValue(Rendering/Brake/Front)                                   
    compareValues    get_Config     {FrontFender      }         $::bikeGeometry::Config(FrontFender)                    Rendering(Fender/Front)                   ;# set _lastValue(Rendering/Fender/Front)                                  
    compareValues    get_Config     {RearBrake        }         $::bikeGeometry::Config(RearBrake)                      Rendering(Brake/Rear)                     ;# set _lastValue(Rendering/Brake/Rear)                                    
    compareValues    get_Config     {RearDropout      }         $::bikeGeometry::Config(RearDropout)                    Rendering(RearDropOut)                    ;# set _lastValue(Rendering/RearDropOut)                                   
    compareValues    get_Config     {RearDropoutOrient}         $::bikeGeometry::Config(RearDropoutOrient)              Lugs(RearDropOut/Direction)               ;# set _lastValue(Lugs/RearDropOut/Direction)                              
    compareValues    get_Config     {RearFender       }         $::bikeGeometry::Config(RearFender)                     Rendering(Fender/Rear)                    ;# set _lastValue(Rendering/Fender/Rear)                                   
        #
    reportComparison 
        #
    compareValues    get_ListValue  {CrankSetChainRings}  $::bikeGeometry::ListValue(CrankSetChainRings)                Component(CrankSet/ChainRings)  ;# set _lastValue(Component/CrankSet/ChainRings)                           
        #
    reportComparison
        #
    compareValues    get_Scalar     {BottleCage DownTube           }  $::bikeGeometry::BottleCage(DownTube)             Component(BottleCage/DownTube/OffsetBB)         ;# set _lastValue(Component/BottleCage/DownTube/OffsetBB)                  
    compareValues    get_Scalar     {BottleCage DownTube_Lower     }  $::bikeGeometry::BottleCage(DownTube_Lower)       Component(BottleCage/DownTube_Lower/OffsetBB)   ;# set _lastValue(Component/BottleCage/DownTube_Lower/OffsetBB)            
    compareValues    get_Scalar     {BottleCage SeatTube           }  $::bikeGeometry::BottleCage(SeatTube)             Component(BottleCage/SeatTube/OffsetBB)         ;# set _lastValue(Component/BottleCage/SeatTube/OffsetBB)                  
    compareValues    get_Scalar     {BottomBracket InsideDiameter  }  $::bikeGeometry::BottomBracket(InsideDiameter)    Lugs(BottomBracket/Diameter/inside)             ;# set _lastValue(Lugs/BottomBracket/Diameter/inside)                      
    compareValues    get_Scalar     {BottomBracket OffsetCS_TopView}  $::bikeGeometry::BottomBracket(OffsetCS_TopView)  Lugs(BottomBracket/ChainStay/Offset_TopView)    ;# set _lastValue(Lugs/BottomBracket/ChainStay/Offset_TopView)             
    compareValues    get_Scalar     {BottomBracket OutsideDiameter }  $::bikeGeometry::BottomBracket(OutsideDiameter)   Lugs(BottomBracket/Diameter/outside)            ;# set _lastValue(Lugs/BottomBracket/Diameter/outside)                     
    compareValues    get_Scalar     {BottomBracket Width           }  $::bikeGeometry::BottomBracket(Width)             Lugs(BottomBracket/Width)                       ;# set _lastValue(Lugs/BottomBracket/Width)                                
        #
    reportComparison
        #
    compareValues    get_Scalar     {ChainStay DiameterSS      }        $::bikeGeometry::ChainStay(DiameterSS)          FrameTubes(ChainStay/DiameterSS)                ;# set _lastValue(FrameTubes/ChainStay/DiameterSS)                         
    compareValues    get_Scalar     {ChainStay Height          }        $::bikeGeometry::ChainStay(Height)              FrameTubes(ChainStay/Height)                    ;# set _lastValue(FrameTubes/ChainStay/Height)                             
    compareValues    get_Scalar     {ChainStay HeigthBB        }        $::bikeGeometry::ChainStay(HeigthBB)            FrameTubes(ChainStay/HeightBB)                  ;# set _lastValue(FrameTubes/ChainStay/HeightBB)                           
    compareValues    get_Scalar     {ChainStay TaperLength     }        $::bikeGeometry::ChainStay(TaperLength)         FrameTubes(ChainStay/TaperLength)               ;# set _lastValue(FrameTubes/ChainStay/TaperLength)                        
    compareValues    get_Scalar     {ChainStay WidthBB         }        $::bikeGeometry::ChainStay(WidthBB)             FrameTubes(ChainStay/WidthBB)
        #            get_Scalar     {ChainStay profile_y03     }        $::bikeGeometry::ChainStay(profile_y03)         FrameTubes/ChainStay/Profile/width_03)          ;# set _lastValue(FrameTubes/ChainStay/Profile/width_03)                   
    compareValues    get_Scalar     {ChainStay completeLength  }        $::bikeGeometry::ChainStay(completeLength)      FrameTubes(ChainStay/Profile/completeLength)    ;# set _lastValue(FrameTubes/ChainStay/Profile/completeLength)             
    compareValues    get_Scalar     {ChainStay cuttingLeft     }        $::bikeGeometry::ChainStay(cuttingLeft)         FrameTubes(ChainStay/Profile/cuttingLeft)       ;# set _lastValue(FrameTubes/ChainStay/Profile/cuttingLeft)                
    compareValues    get_Scalar     {ChainStay cuttingLength   }        $::bikeGeometry::ChainStay(cuttingLength)       FrameTubes(ChainStay/Profile/cuttingLength)     ;# set _lastValue(FrameTubes/ChainStay/Profile/cuttingLength)              
    compareValues    get_Scalar     {ChainStay profile_x01     }        $::bikeGeometry::ChainStay(profile_x01)         FrameTubes(ChainStay/Profile/length_01)         ;# set _lastValue(FrameTubes/ChainStay/Profile/length_01)                  
    compareValues    get_Scalar     {ChainStay profile_x02     }        $::bikeGeometry::ChainStay(profile_x02)         FrameTubes(ChainStay/Profile/length_02)         ;# set _lastValue(FrameTubes/ChainStay/Profile/length_02)                  
    compareValues    get_Scalar     {ChainStay profile_x03     }        $::bikeGeometry::ChainStay(profile_x03)         FrameTubes(ChainStay/Profile/length_03)         ;# set _lastValue(FrameTubes/ChainStay/Profile/length_03)                  
    compareValues    get_Scalar     {ChainStay profile_y00     }        $::bikeGeometry::ChainStay(profile_y00)         FrameTubes(ChainStay/Profile/width_00)          ;# set _lastValue(FrameTubes/ChainStay/Profile/width_00)                   
    compareValues    get_Scalar     {ChainStay profile_y01     }        $::bikeGeometry::ChainStay(profile_y01)         FrameTubes(ChainStay/Profile/width_01)          ;# set _lastValue(FrameTubes/ChainStay/Profile/width_01)                   
    compareValues    get_Scalar     {ChainStay profile_y02     }        $::bikeGeometry::ChainStay(profile_y02)         FrameTubes(ChainStay/Profile/width_02)          ;# set _lastValue(FrameTubes/ChainStay/Profile/width_02)                   
        #
    reportComparison
        #
    compareValues    get_Scalar     {ChainStay segmentAngle_01 }    $::bikeGeometry::ChainStay(segmentAngle_01)         FrameTubes(ChainStay/CenterLine/angle_01)       ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_01)                
    compareValues    get_Scalar     {ChainStay segmentAngle_02 }    $::bikeGeometry::ChainStay(segmentAngle_02)         FrameTubes(ChainStay/CenterLine/angle_02)       ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_02)                
    compareValues    get_Scalar     {ChainStay segmentAngle_03 }    $::bikeGeometry::ChainStay(segmentAngle_03)         FrameTubes(ChainStay/CenterLine/angle_03)       ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_03)                
    compareValues    get_Scalar     {ChainStay segmentAngle_04 }    $::bikeGeometry::ChainStay(segmentAngle_04)         FrameTubes(ChainStay/CenterLine/angle_04)       ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_04)                
    compareValues    get_Scalar     {ChainStay segmentLength_01}    $::bikeGeometry::ChainStay(segmentLength_01)        FrameTubes(ChainStay/CenterLine/length_01)      ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_01)               
    compareValues    get_Scalar     {ChainStay segmentLength_02}    $::bikeGeometry::ChainStay(segmentLength_02)        FrameTubes(ChainStay/CenterLine/length_02)      ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_02)               
    compareValues    get_Scalar     {ChainStay segmentLength_03}    $::bikeGeometry::ChainStay(segmentLength_03)        FrameTubes(ChainStay/CenterLine/length_03)      ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_03)               
    compareValues    get_Scalar     {ChainStay segmentLength_04}    $::bikeGeometry::ChainStay(segmentLength_04)        FrameTubes(ChainStay/CenterLine/length_04)      ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_04)               
    compareValues    get_Scalar     {ChainStay segmentRadius_01}    $::bikeGeometry::ChainStay(segmentRadius_01)        FrameTubes(ChainStay/CenterLine/radius_01)      ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_01)               
    compareValues    get_Scalar     {ChainStay segmentRadius_02}    $::bikeGeometry::ChainStay(segmentRadius_02)        FrameTubes(ChainStay/CenterLine/radius_02)      ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_02)               
    compareValues    get_Scalar     {ChainStay segmentRadius_03}    $::bikeGeometry::ChainStay(segmentRadius_03)        FrameTubes(ChainStay/CenterLine/radius_03)      ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_03)               
    compareValues    get_Scalar     {ChainStay segmentRadius_04}    $::bikeGeometry::ChainStay(segmentRadius_04)        FrameTubes(ChainStay/CenterLine/radius_04)      ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_04)               
        #
    reportComparison
        #                                                         
    compareValues    get_Scalar     {CrankSet ArmWidth   }          $::bikeGeometry::CrankSet(ArmWidth)                 Component(CrankSet/ArmWidth)       ;# set _lastValue(Component/CrankSet/ArmWidth)                             
    compareValues    get_Scalar     {CrankSet ChainLine  }          $::bikeGeometry::CrankSet(ChainLine)                Component(CrankSet/ChainLine)      ;# set _lastValue(Component/CrankSet/ChainLine)                            
    compareValues    get_Scalar     {CrankSet Length     }          $::bikeGeometry::CrankSet(Length)                   Component(CrankSet/Length)         ;# set _lastValue(Component/CrankSet/Length)                               
    compareValues    get_Scalar     {CrankSet PedalEye   }          $::bikeGeometry::CrankSet(PedalEye)                 Component(CrankSet/PedalEye)       ;# set _lastValue(Component/CrankSet/PedalEye)                             
    compareValues    get_Scalar     {CrankSet Q-Factor   }          $::bikeGeometry::CrankSet(Q-Factor)                 Component(CrankSet/Q-Factor)       ;# set _lastValue(Component/CrankSet/Q-Factor)                             
    compareValues    get_Scalar     {DownTube DiameterBB }          $::bikeGeometry::DownTube(DiameterBB)               FrameTubes(DownTube/DiameterBB)    ;# set _lastValue(FrameTubes/DownTube/DiameterBB)                          
    compareValues    get_Scalar     {DownTube DiameterHT }          $::bikeGeometry::DownTube(DiameterHT)               FrameTubes(DownTube/DiameterHT)    ;# set _lastValue(FrameTubes/DownTube/DiameterHT)                          
    compareValues    get_Scalar     {DownTube OffsetBB   }          $::bikeGeometry::DownTube(OffsetBB)                 Custom(DownTube/OffsetBB)          ;# set _lastValue(Custom/DownTube/OffsetBB)                                
    compareValues    get_Scalar     {DownTube OffsetHT   }          $::bikeGeometry::DownTube(OffsetHT)                 Custom(DownTube/OffsetHT)          ;# set _lastValue(Custom/DownTube/OffsetHT)                                
    compareValues    get_Scalar     {DownTube TaperLength}          $::bikeGeometry::DownTube(TaperLength)              FrameTubes(DownTube/TaperLength)   ;# set _lastValue(FrameTubes/DownTube/TaperLength)                         
        #
    reportComparison
        #
    compareValues    get_Scalar     {Fork BladeBendRadius       }   $::bikeGeometry::Fork(BladeBendRadius)              Component(Fork/Blade/BendRadius)      ;# set _lastValue(Component/Fork/Blade/BendRadius)                         
    compareValues    get_Scalar     {Fork BladeDiameterDO       }   $::bikeGeometry::Fork(BladeDiameterDO)              Component(Fork/Blade/DiameterDO)      ;# set _lastValue(Component/Fork/Blade/DiameterDO)                         
    compareValues    get_Scalar     {Fork BladeEndLength        }   $::bikeGeometry::Fork(BladeEndLength)               Component(Fork/Blade/EndLength)       ;# set _lastValue(Component/Fork/Blade/EndLength)                          
    compareValues    get_Scalar     {Fork BladeOffsetCrown      }   $::bikeGeometry::Fork(BladeOffsetCrown)             Component(Fork/Crown/Blade/Offset)    ;# set _lastValue(Component/Fork/Crown/Blade/Offset)                       
    compareValues    get_Scalar     {Fork BladeOffsetCrownPerp  }   $::bikeGeometry::Fork(BladeOffsetCrownPerp)         Component(Fork/Crown/Blade/OffsetPerp);# set _lastValue(Component/Fork/Crown/Blade/OffsetPerp)                   
    compareValues    get_Scalar     {Fork BladeOffsetDO         }   $::bikeGeometry::Fork(BladeOffsetDO)                Component(Fork/DropOut/Offset)        ;# set _lastValue(Component/Fork/DropOut/Offset)                           
    compareValues    get_Scalar     {Fork BladeOffsetDOPerp     }   $::bikeGeometry::Fork(BladeOffsetDOPerp)            Component(Fork/DropOut/OffsetPerp)    ;# set _lastValue(Component/Fork/DropOut/OffsetPerp)                       
    compareValues    get_Scalar     {Fork BladeTaperLength      }   $::bikeGeometry::Fork(BladeTaperLength)             Component(Fork/Blade/TaperLength)     ;# set _lastValue(Component/Fork/Blade/TaperLength)                        
    compareValues    get_Scalar     {Fork BladeWidth            }   $::bikeGeometry::Fork(BladeWidth)                   Component(Fork/Blade/Width)           ;# set _lastValue(Component/Fork/Blade/Width)                              
    compareValues    get_Scalar     {Fork BrakeAngle            }   $::bikeGeometry::Fork(BrakeAngle)                   Component(Fork/Crown/Brake/Angle)     ;# set _lastValue(Component/Fork/Crown/Brake/Angle)                        
    compareValues    get_Scalar     {Fork BrakeOffset           }   $::bikeGeometry::Fork(BrakeOffset)                  Component(Fork/Crown/Brake/Offset)    ;# set _lastValue(Component/Fork/Crown/Brake/Offset)                       
        #   
    reportComparison
        #
    compareValues    get_Scalar     {FrontBrake LeverLength      }  $::bikeGeometry::FrontBrake(LeverLength)            Component(Brake/Front/LeverLength)       ;# set _lastValue(Component/Brake/Front/LeverLength)                       
    compareValues    get_Scalar     {FrontBrake Offset           }  $::bikeGeometry::FrontBrake(Offset)                 Component(Brake/Front/Offset)            ;# set _lastValue(Component/Brake/Front/Offset)                            
    compareValues    get_Scalar     {FrontCarrier x              }  $::bikeGeometry::FrontCarrier(x)                    Component(Carrier/Front/x)               ;# set _lastValue(Component/Carrier/Front/x)                               
    compareValues    get_Scalar     {FrontCarrier y              }  $::bikeGeometry::FrontCarrier(y)                    Component(Carrier/Front/y)               ;# set _lastValue(Component/Carrier/Front/y)                               
    compareValues    get_Scalar     {FrontDerailleur Distance    }  $::bikeGeometry::FrontDerailleur(Distance)          Component(Derailleur/Front/Distance)     ;# set _lastValue(Component/Derailleur/Front/Distance)                     
    compareValues    get_Scalar     {FrontDerailleur Offset      }  $::bikeGeometry::FrontDerailleur(Offset)            Component(Derailleur/Front/Offset)       ;# set _lastValue(Component/Derailleur/Front/Offset)                       
    compareValues    get_Scalar     {FrontFender Height          }  $::bikeGeometry::FrontFender(Height)                Component(Fender/Front/Height)           ;# set _lastValue(Component/Fender/Front/Height)                           
    compareValues    get_Scalar     {FrontFender OffsetAngle     }  $::bikeGeometry::FrontFender(OffsetAngle)           Component(Fender/Front/OffsetAngle)      ;# set _lastValue(Component/Fender/Front/OffsetAngle)                      
    compareValues    get_Scalar     {FrontFender OffsetAngleFront}  $::bikeGeometry::FrontFender(OffsetAngleFront)      Component(Fender/Front/OffsetAngleFront) ;# set _lastValue(Component/Fender/Front/OffsetAngleFront)                 
    compareValues    get_Scalar     {FrontFender Radius          }  $::bikeGeometry::FrontFender(Radius)                Component(Fender/Front/Radius)           ;# set _lastValue(Component/Fender/Front/Radius)                           
    compareValues    get_Scalar     {FrontWheel RimHeight        }  $::bikeGeometry::FrontWheel(RimHeight)              Component(Wheel/Front/RimHeight)         ;# set _lastValue(Component/Wheel/Front/RimHeight)                         
        #
    reportComparison
        #
    compareValues    get_Scalar     {Geometry BottomBracket_Depth } $::bikeGeometry::Geometry(BottomBracket_Depth)      Custom(BottomBracket/Depth)             ;# set _lastValue(Custom/BottomBracket/Depth)                              
    compareValues    get_Scalar     {Geometry BottomBracket_Height} $::bikeGeometry::Geometry(BottomBracket_Height)     Result(Length/BottomBracket/Height)     ;# set _lastValue(Result/Length/BottomBracket/Height)                      
    compareValues    get_Scalar     {Geometry ChainStay_Length    } $::bikeGeometry::Geometry(ChainStay_Length)         Custom(WheelPosition/Rear)              ;# set _lastValue(Custom/WheelPosition/Rear)                               
    compareValues    get_Scalar     {Geometry Fork_Height         } $::bikeGeometry::Geometry(Fork_Height)              Component(Fork/Height)                  ;# set _lastValue(Component/Fork/Height)                                   
    compareValues    get_Scalar     {Geometry Fork_Rake           } $::bikeGeometry::Geometry(Fork_Rake)                Component(Fork/Rake)                    ;# set _lastValue(Component/Fork/Rake)                                     
    compareValues    get_Scalar     {Geometry FrontRim_Diameter   } $::bikeGeometry::Geometry(FrontRim_Diameter)        Component(Wheel/Front/RimDiameter)      ;# set _lastValue(Component/Wheel/Front/RimDiameter)                       
    compareValues    get_Scalar     {Geometry FrontTyre_Height    } $::bikeGeometry::Geometry(FrontTyre_Height)         Component(Wheel/Front/TyreHeight)       ;# set _lastValue(Component/Wheel/Front/TyreHeight)                        
    compareValues    get_Scalar     {Geometry FrontWheel_Radius   } $::bikeGeometry::Geometry(FrontWheel_Radius)        Result(Length/FrontWheel/Radius)        ;# set _lastValue(Result/Length/FrontWheel/Radius)                         
    compareValues    get_Scalar     {Geometry FrontWheel_x        } $::bikeGeometry::Geometry(FrontWheel_x)             Result(Length/FrontWheel/horizontal)    ;# set _lastValue(Result/Length/FrontWheel/horizontal)                     
    compareValues    get_Scalar     {Geometry FrontWheel_xy       } $::bikeGeometry::Geometry(FrontWheel_xy)            Result(Length/FrontWheel/diagonal)      ;# set _lastValue(Result/Length/FrontWheel/diagonal)                       
    compareValues    get_Scalar     {Geometry HandleBar_Distance  } $::bikeGeometry::Geometry(HandleBar_Distance)       Personal(HandleBar_Distance)            ;# set _lastValue(Personal/HandleBar_Distance)                             
    compareValues    get_Scalar     {Geometry HandleBar_Height    } $::bikeGeometry::Geometry(HandleBar_Height)         Personal(HandleBar_Height)              ;# set _lastValue(Personal/HandleBar_Height)                               
    compareValues    get_Scalar     {Geometry HeadTube_Angle      } $::bikeGeometry::Geometry(HeadTube_Angle)           Custom(HeadTube/Angle)                  ;# set _lastValue(Custom/HeadTube/Angle)                                   
    compareValues    get_Scalar     {Geometry Inseam_Length       } $::bikeGeometry::Geometry(Inseam_Length)            Personal(InnerLeg_Length)               ;# set _lastValue(Personal/InnerLeg_Length)                                
    compareValues    get_Scalar     {Geometry Reach_Length        } $::bikeGeometry::Geometry(Reach_Length)             Result(Length/HeadTube/ReachLength)     ;# set _lastValue(Result/Length/HeadTube/ReachLength)                      
    compareValues    get_Scalar     {Geometry RearRim_Diameter    } $::bikeGeometry::Geometry(RearRim_Diameter)         Component(Wheel/Rear/RimDiameter)       ;# set _lastValue(Component/Wheel/Rear/RimDiameter)                        
    compareValues    get_Scalar     {Geometry RearTyre_Height     } $::bikeGeometry::Geometry(RearTyre_Height)          Component(Wheel/Rear/TyreHeight)        ;# set _lastValue(Component/Wheel/Rear/TyreHeight)                         
    compareValues    get_Scalar     {Geometry RearWheel_Radius    } $::bikeGeometry::Geometry(RearWheel_Radius)         Result(Length/RearWheel/Radius)         ;# set _lastValue(Result/Length/RearWheel/Radius)                          
    compareValues    get_Scalar     {Geometry RearWheel_x         } $::bikeGeometry::Geometry(RearWheel_x)              Result(Length/RearWheel/horizontal)     ;# set _lastValue(Result/Length/RearWheel/horizontal)                      
        #
    reportComparison
        #
    compareValues    get_Scalar     {Geometry SaddleNose_BB_x     } $::bikeGeometry::Geometry(SaddleNose_BB_x)          Result(Length/Saddle/Offset_BB_Nose)    ;# set _lastValue(Result/Length/Saddle/Offset_BB_Nose)                     
    compareValues    get_Scalar     {Geometry SaddleNose_HB       } $::bikeGeometry::Geometry(SaddleNose_HB)            Result(Length/Personal/SaddleNose_HB)   ;# set _lastValue(Result/Length/Personal/SaddleNose_HB)                    
    compareValues    get_Scalar     {Geometry Saddle_BB           } $::bikeGeometry::Geometry(Saddle_BB)                Result(Length/Saddle/SeatTube_BB)       ;# set _lastValue(Result/Length/Saddle/SeatTube_BB)                        
    compareValues    get_Scalar     {Geometry Saddle_Distance     } $::bikeGeometry::Geometry(Saddle_Distance)          Personal(Saddle_Distance)               ;# set _lastValue(Personal/Saddle_Distance)                                
    compareValues    get_Scalar     {Geometry Saddle_HB_y         } $::bikeGeometry::Geometry(Saddle_HB_y)              Result(Length/Saddle/Offset_HB)         ;# set _lastValue(Result/Length/Saddle/Offset_HB)                          
    compareValues    get_Scalar     {Geometry Saddle_Offset_BB_ST } $::bikeGeometry::Geometry(Saddle_Offset_BB_ST)      Result(Length/Saddle/Offset_BB_ST)      ;# set _lastValue(Result/Length/Saddle/Offset_BB_ST)                       
    compareValues    get_Scalar     {Geometry SeatTube_Virtual    } $::bikeGeometry::Geometry(SeatTube_Virtual)         Result(Length/SeatTube/VirtualLength)   ;# set _lastValue(Result/Length/SeatTube/VirtualLength)                    
    compareValues    get_Scalar     {Geometry SeatTube_Angle      } $::bikeGeometry::Geometry(SeatTube_Angle)           Result(Angle/SeatTube/Direction)        ;# set _lastValue(Result/Angle/SeatTube/Direction)                         
    compareValues    get_Scalar     {Geometry Stack_Height        } $::bikeGeometry::Geometry(Stack_Height)             Result(Length/HeadTube/StackHeight)     ;# set _lastValue(Result/Length/HeadTube/StackHeight)                      
    compareValues    get_Scalar     {Geometry Stem_Angle          } $::bikeGeometry::Geometry(Stem_Angle)               Component(Stem/Angle)                   ;# set _lastValue(Component/Stem/Angle)                                    
    compareValues    get_Scalar     {Geometry Stem_Length         } $::bikeGeometry::Geometry(Stem_Length)              Component(Stem/Length)                  ;# set _lastValue(Component/Stem/Length)                                   
    compareValues    get_Scalar     {Geometry TopTube_Virtual     } $::bikeGeometry::Geometry(TopTube_Virtual)          Result(Length/TopTube/VirtualLength)    ;# set _lastValue(Result/Length/TopTube/VirtualLength)                     
    compareValues    get_Scalar     {Geometry TopTube_Angle       } $::bikeGeometry::Geometry(TopTube_Angle)            Custom(TopTube/Angle)                   ;# set _lastValue(Custom/TopTube/Angle)                                    
        #
    reportComparison
        #
    compareValues    get_Scalar     {HandleBar PivotAngle }         $::bikeGeometry::HandleBar(PivotAngle)              Component(HandleBar/PivotAngle)         ;# set _lastValue(Component/HandleBar/PivotAngle)                          
    compareValues    get_Scalar     {HeadSet Diameter     }         $::bikeGeometry::HeadSet(Diameter)                  Component(HeadSet/Diameter)             ;# set _lastValue(Component/HeadSet/Diameter)                              
    compareValues    get_Scalar     {HeadSet Height_Bottom}         $::bikeGeometry::HeadSet(Height_Bottom)             Component(HeadSet/Height/Bottom)        ;# set _lastValue(Component/HeadSet/Height/Bottom)                         
    compareValues    get_Scalar     {HeadSet Height_Top   }         $::bikeGeometry::HeadSet(Height_Top)                Component(HeadSet/Height/Top)           ;# set _lastValue(Component/HeadSet/Height/Top)                            
    compareValues    get_Scalar     {HeadTube Diameter    }         $::bikeGeometry::HeadTube(Diameter)                 FrameTubes(HeadTube/Diameter)           ;# set _lastValue(FrameTubes/HeadTube/Diameter)                            
    compareValues    get_Scalar     {HeadTube Length      }         $::bikeGeometry::HeadTube(Length)                   FrameTubes(HeadTube/Length)             ;# set _lastValue(FrameTubes/HeadTube/Length)                              
        #
    reportComparison 
        #
    compareValues    get_Scalar     {Lugs BottomBracket_ChainStay_Angle    }    $::bikeGeometry::Lugs(BottomBracket_ChainStay_Angle)        Lugs(BottomBracket/ChainStay/Angle/value)       ;# set _lastValue(Lugs/BottomBracket/ChainStay/Angle/value)                
    compareValues    get_Scalar     {Lugs BottomBracket_ChainStay_Tolerance}    $::bikeGeometry::Lugs(BottomBracket_ChainStay_Tolerance)    Lugs(BottomBracket/ChainStay/Angle/plus_minus)  ;# set _lastValue(Lugs/BottomBracket/ChainStay/Angle/plus_minus)           
    compareValues    get_Scalar     {Lugs BottomBracket_DownTube_Angle     }    $::bikeGeometry::Lugs(BottomBracket_DownTube_Angle)         Lugs(BottomBracket/DownTube/Angle/value)        ;# set _lastValue(Lugs/BottomBracket/DownTube/Angle/value)                 
    compareValues    get_Scalar     {Lugs BottomBracket_DownTube_Tolerance }    $::bikeGeometry::Lugs(BottomBracket_DownTube_Tolerance)     Lugs(BottomBracket/DownTube/Angle/plus_minus)   ;# set _lastValue(Lugs/BottomBracket/DownTube/Angle/plus_minus)            
    compareValues    get_Scalar     {Lugs HeadLug_Bottom_Angle             }    $::bikeGeometry::Lugs(HeadLug_Bottom_Angle)                 Lugs(HeadTube/DownTube/Angle/value)             ;# set _lastValue(Lugs/HeadTube/DownTube/Angle/value)                      
    compareValues    get_Scalar     {Lugs HeadLug_Bottom_Tolerance         }    $::bikeGeometry::Lugs(HeadLug_Bottom_Tolerance)             Lugs(HeadTube/DownTube/Angle/plus_minus)        ;# set _lastValue(Lugs/HeadTube/DownTube/Angle/plus_minus)                 
    compareValues    get_Scalar     {Lugs HeadLug_Top_Angle                }    $::bikeGeometry::Lugs(HeadLug_Top_Angle)                    Lugs(HeadTube/TopTube/Angle/value)              ;# set _lastValue(Lugs/HeadTube/TopTube/Angle/value)                       
    compareValues    get_Scalar     {Lugs HeadLug_Top_Tolerance            }    $::bikeGeometry::Lugs(HeadLug_Top_Tolerance)                Lugs(HeadTube/TopTube/Angle/plus_minus)         ;# set _lastValue(Lugs/HeadTube/TopTube/Angle/plus_minus)                  
    compareValues    get_Scalar     {Lugs RearDropOut_Angle                }    $::bikeGeometry::Lugs(RearDropOut_Angle)                    Lugs(RearDropOut/Angle/value)                   ;# set _lastValue(Lugs/RearDropOut/Angle/value)                            
    compareValues    get_Scalar     {Lugs RearDropOut_Tolerance            }    $::bikeGeometry::Lugs(RearDropOut_Tolerance)                Lugs(RearDropOut/Angle/plus_minus)              ;# set _lastValue(Lugs/RearDropOut/Angle/plus_minus)                       
    compareValues    get_Scalar     {Lugs SeatLug_SeatStay_Angle           }    $::bikeGeometry::Lugs(SeatLug_SeatStay_Angle)               Lugs(SeatTube/SeatStay/Angle/value)             ;# set _lastValue(Lugs/SeatTube/SeatStay/Angle/value)                      
    compareValues    get_Scalar     {Lugs SeatLug_SeatStay_Tolerance       }    $::bikeGeometry::Lugs(SeatLug_SeatStay_Tolerance)           Lugs(SeatTube/SeatStay/Angle/plus_minus)        ;# set _lastValue(Lugs/SeatTube/SeatStay/Angle/plus_minus)                 
    compareValues    get_Scalar     {Lugs SeatLug_TopTube_Angle            }    $::bikeGeometry::Lugs(SeatLug_TopTube_Angle)                Lugs(SeatTube/TopTube/Angle/value)              ;# set _lastValue(Lugs/SeatTube/TopTube/Angle/value)                       
    compareValues    get_Scalar     {Lugs SeatLug_TopTube_Tolerance        }    $::bikeGeometry::Lugs(SeatLug_TopTube_Tolerance)            Lugs(SeatTube/TopTube/Angle/plus_minus)         ;# set _lastValue(Lugs/SeatTube/TopTube/Angle/plus_minus)                  
        #
    compareValues    get_Scalar     {Geometry HeadLugTop_Angle             }    $::bikeGeometry::Geometry(HeadLugTop_Angle)                 Result(Angle/HeadTube/TopTube)                  ;# set _lastValue(Result/Angle/HeadTube/TopTube)                           
        #
    reportComparison 
        #
    compareValues    get_Scalar     {RearBrake LeverLength       }    $::bikeGeometry::RearBrake(LeverLength)           Component(Brake/Rear/LeverLength)          ;# set _lastValue(Component/Brake/Rear/LeverLength)                        
    compareValues    get_Scalar     {RearBrake Offset            }    $::bikeGeometry::RearBrake(Offset)                Component(Brake/Rear/Offset)               ;# set _lastValue(Component/Brake/Rear/Offset)                             
    compareValues    get_Scalar     {RearCarrier x               }    $::bikeGeometry::RearCarrier(x)                   Component(Carrier/Rear/x)                  ;# set _lastValue(Component/Carrier/Rear/x)                                
    compareValues    get_Scalar     {RearCarrier y               }    $::bikeGeometry::RearCarrier(y)                   Component(Carrier/Rear/y)                  ;# set _lastValue(Component/Carrier/Rear/y)                                
    compareValues    get_Scalar     {RearDerailleur Pulley_teeth }    $::bikeGeometry::RearDerailleur(Pulley_teeth)     Component(Derailleur/Rear/Pulley/teeth)    ;# set _lastValue(Component/Derailleur/Rear/Pulley/teeth)                  
    compareValues    get_Scalar     {RearDerailleur Pulley_x     }    $::bikeGeometry::RearDerailleur(Pulley_x)         Component(Derailleur/Rear/Pulley/x)        ;# set _lastValue(Component/Derailleur/Rear/Pulley/x)                      
    compareValues    get_Scalar     {RearDerailleur Pulley_y     }    $::bikeGeometry::RearDerailleur(Pulley_y)         Component(Derailleur/Rear/Pulley/y)        ;# set _lastValue(Component/Derailleur/Rear/Pulley/y)                      
    compareValues    get_Scalar     {RearDropout Derailleur_x    }    $::bikeGeometry::RearDropout(Derailleur_x)        Lugs(RearDropOut/Derailleur/x)             ;# set _lastValue(Lugs/RearDropOut/Derailleur/x)                           
    compareValues    get_Scalar     {RearDropout Derailleur_y    }    $::bikeGeometry::RearDropout(Derailleur_y)        Lugs(RearDropOut/Derailleur/y)             ;# set _lastValue(Lugs/RearDropOut/Derailleur/y)                           
    compareValues    get_Scalar     {RearDropout OffsetCS        }    $::bikeGeometry::RearDropout(OffsetCS)            Lugs(RearDropOut/ChainStay/Offset)         ;# set _lastValue(Lugs/RearDropOut/ChainStay/Offset)                       
    compareValues    get_Scalar     {RearDropout OffsetCSPerp    }    $::bikeGeometry::RearDropout(OffsetCSPerp)        Lugs(RearDropOut/ChainStay/OffsetPerp)     ;# set _lastValue(Lugs/RearDropOut/ChainStay/OffsetPerp)                   
    compareValues    get_Scalar     {RearDropout OffsetCS_TopView}    $::bikeGeometry::RearDropout(OffsetCS_TopView)    Lugs(RearDropOut/ChainStay/Offset_TopView) ;# set _lastValue(Lugs/RearDropOut/ChainStay/Offset_TopView)               
    compareValues    get_Scalar     {RearDropout OffsetSS        }    $::bikeGeometry::RearDropout(OffsetSS)            Lugs(RearDropOut/SeatStay/Offset)          ;# set _lastValue(Lugs/RearDropOut/SeatStay/Offset)                        
    compareValues    get_Scalar     {RearDropout OffsetSSPerp    }    $::bikeGeometry::RearDropout(OffsetSSPerp)        Lugs(RearDropOut/SeatStay/OffsetPerp)      ;# set _lastValue(Lugs/RearDropOut/SeatStay/OffsetPerp)                    
    compareValues    get_Scalar     {RearDropout RotationOffset  }    $::bikeGeometry::RearDropout(RotationOffset)      Lugs(RearDropOut/RotationOffset)           ;# set _lastValue(Lugs/RearDropOut/RotationOffset)                         
        #
    reportComparison 
        #
    compareValues    get_Scalar     {RearFender Height             }  $::bikeGeometry::RearFender(Height)               Component(Fender/Rear/Height)              ;# set _lastValue(Component/Fender/Rear/Height)                            
    compareValues    get_Scalar     {RearFender OffsetAngle        }  $::bikeGeometry::RearFender(OffsetAngle)          Component(Fender/Rear/OffsetAngle)         ;# set _lastValue(Component/Fender/Rear/OffsetAngle)                       
    compareValues    get_Scalar     {RearFender Radius             }  $::bikeGeometry::RearFender(Radius)               Component(Fender/Rear/Radius)              ;# set _lastValue(Component/Fender/Rear/Radius)                            
    compareValues    get_Scalar     {RearMockup CassetteClearance  }  $::bikeGeometry::RearMockup(CassetteClearance)    Rendering(RearMockup/CassetteClearance)    ;# set _lastValue(Rendering/RearMockup/CassetteClearance)                  
    compareValues    get_Scalar     {RearMockup ChainWheelClearance}  $::bikeGeometry::RearMockup(ChainWheelClearance)  Rendering(RearMockup/ChainWheelClearance)  ;# set _lastValue(Rendering/RearMockup/ChainWheelClearance)                
    compareValues    get_Scalar     {RearMockup CrankClearance     }  $::bikeGeometry::RearMockup(CrankClearance)       Rendering(RearMockup/CrankClearance)       ;# set _lastValue(Rendering/RearMockup/CrankClearance)                     
    compareValues    get_Scalar     {RearMockup DiscClearance      }  $::bikeGeometry::RearMockup(DiscClearance)        Rendering(RearMockup/DiscClearance)        ;# set _lastValue(Rendering/RearMockup/DiscClearance)                      
    compareValues    get_Scalar     {RearMockup DiscDiameter       }  $::bikeGeometry::RearMockup(DiscDiameter)         Rendering(RearMockup/DiscDiameter)         ;# set _lastValue(Rendering/RearMockup/DiscDiameter)                       
    compareValues    get_Scalar     {RearMockup DiscOffset         }  $::bikeGeometry::RearMockup(DiscOffset)           Rendering(RearMockup/DiscOffset)           ;# set _lastValue(Rendering/RearMockup/DiscOffset)                         
    compareValues    get_Scalar     {RearMockup DiscWidth          }  $::bikeGeometry::RearMockup(DiscWidth)            Rendering(RearMockup/DiscWidth)            ;# set _lastValue(Rendering/RearMockup/DiscWidth)                          
    compareValues    get_Scalar     {RearMockup TyreClearance      }  $::bikeGeometry::RearMockup(TyreClearance)        Rendering(RearMockup/TyreClearance)        ;# set _lastValue(Rendering/RearMockup/TyreClearance)                      
        #
    reportComparison
        #
    compareValues    get_Scalar     {RearWheel FirstSprocket       }  $::bikeGeometry::RearWheel(FirstSprocket)         Component(Wheel/Rear/FirstSprocket)         ;# set _lastValue(Component/Wheel/Rear/FirstSprocket)                      
    compareValues    get_Scalar     {RearWheel HubWidth            }  $::bikeGeometry::RearWheel(HubWidth)              Component(Wheel/Rear/HubWidth)              ;# set _lastValue(Component/Wheel/Rear/HubWidth)                           
    compareValues    get_Scalar     {RearWheel RimHeight           }  $::bikeGeometry::RearWheel(RimHeight)             Component(Wheel/Rear/RimHeight)             ;# set _lastValue(Component/Wheel/Rear/RimHeight)                          
    compareValues    get_Scalar     {RearWheel TyreShoulder        }  $::bikeGeometry::RearWheel(TyreShoulder)          Result(Length/RearWheel/TyreShoulder)       ;# set _lastValue(Result/Length/RearWheel/TyreShoulder)                    
    compareValues    get_Scalar     {RearWheel TyreWidth           }  $::bikeGeometry::RearWheel(TyreWidth)             Component(Wheel/Rear/TyreWidth)             ;# set _lastValue(Component/Wheel/Rear/TyreWidth)                          
    compareValues    get_Scalar     {RearWheel TyreWidthRadius     }  $::bikeGeometry::RearWheel(TyreWidthRadius)       Component(Wheel/Rear/TyreWidthRadius)       ;# set _lastValue(Component/Wheel/Rear/TyreWidthRadius)                    
        #
    reportComparison 
        #
    compareValues    get_Scalar     {Reference HandleBar_Distance  }  $::bikeGeometry::Reference(HandleBar_Distance)    Reference(HandleBar_Distance)               ;# set _lastValue(Reference/HandleBar_Distance)                            
    compareValues    get_Scalar     {Reference HandleBar_Height    }  $::bikeGeometry::Reference(HandleBar_Height)      Reference(HandleBar_Height)                 ;# set _lastValue(Reference/HandleBar_Height)                              
    compareValues    get_Scalar     {Reference SaddleNose_Distance }  $::bikeGeometry::Reference(SaddleNose_Distance)   Reference(SaddleNose_Distance)              ;# set _lastValue(Reference/SaddleNose_Distance)                           
    compareValues    get_Scalar     {Reference SaddleNose_HB       }  $::bikeGeometry::Reference(SaddleNose_HB)         Result(Length/Reference/SaddleNose_HB)      ;# set _lastValue(Result/Length/Reference/SaddleNose_HB)                   
    compareValues    get_Scalar     {Reference SaddleNose_HB_y     }  $::bikeGeometry::Reference(SaddleNose_HB_y)       Result(Length/Reference/Heigth_SN_HB)       ;# set _lastValue(Result/Length/Reference/Heigth_SN_HB)                    
    compareValues    get_Scalar     {Reference SaddleNose_Height   }  $::bikeGeometry::Reference(SaddleNose_Height)     Reference(SaddleNose_Height)                ;# set _lastValue(Reference/SaddleNose_Height)                             
        #
    reportComparison 
        #
    compareValues    get_Scalar     {Saddle Height                 }  $::bikeGeometry::Saddle(Height)                   Component(Saddle/Height)                    ;# set _lastValue(Personal/Saddle_Height)                                  
    compareValues    get_Scalar     {Saddle NoseLength             }  $::bikeGeometry::Saddle(NoseLength)               Component(Saddle/LengthNose)                ;# set _lastValue(Component/Saddle/LengthNose)                             
    compareValues    get_Scalar     {Saddle Offset_x               }  $::bikeGeometry::Saddle(Offset_x)                 Rendering(Saddle/Offset_X)                  ;# set _lastValue(Rendering/Saddle/Offset_X)                               
    compareValues    get_Scalar     {Saddle Offset_y               }  $::bikeGeometry::Saddle(Offset_y)                 Rendering(Saddle/Offset_Y)                  ;# set _lastValue(Rendering/Saddle/Offset_Y)                               
        #                                                                                                               
    reportComparison                                                                                                    
        #                                                                                                               
    compareValues    get_Scalar     {SeatPost Diameter             }  $::bikeGeometry::SeatPost(Diameter)               Component(SeatPost/Diameter)                ;# set _lastValue(Component/SeatPost/Diameter)                             
    compareValues    get_Scalar     {SeatPost PivotOffset          }  $::bikeGeometry::SeatPost(PivotOffset)            Component(SeatPost/PivotOffset)             ;# set _lastValue(Component/SeatPost/PivotOffset)                          
    compareValues    get_Scalar     {SeatPost Setback              }  $::bikeGeometry::SeatPost(Setback)                Component(SeatPost/Setback)                 ;# set _lastValue(Component/SeatPost/Setback)                              
    compareValues    get_Scalar     {SeatStay DiameterCS           }  $::bikeGeometry::SeatStay(DiameterCS)             FrameTubes(SeatStay/DiameterCS)             ;# set _lastValue(FrameTubes/SeatStay/DiameterCS)                          
    compareValues    get_Scalar     {SeatStay DiameterST           }  $::bikeGeometry::SeatStay(DiameterST)             FrameTubes(SeatStay/DiameterST)             ;# set _lastValue(FrameTubes/SeatStay/DiameterST)                          
    compareValues    get_Scalar     {SeatStay OffsetTT             }  $::bikeGeometry::SeatStay(OffsetTT)               Custom(SeatStay/OffsetTT)                   ;# set _lastValue(Custom/SeatStay/OffsetTT)                                
    compareValues    get_Scalar     {SeatStay SeatTubeMiterDiameter}  $::bikeGeometry::SeatStay(SeatTubeMiterDiameter)  Lugs(SeatTube/SeatStay/MiterDiameter)       ;# set _lastValue(Lugs/SeatTube/SeatStay/MiterDiameter)                    
    compareValues    get_Scalar     {SeatStay TaperLength          }  $::bikeGeometry::SeatStay(TaperLength)            FrameTubes(SeatStay/TaperLength)            ;# set _lastValue(FrameTubes/SeatStay/TaperLength)                         
        #                                                                                                               
    reportComparison                                                                                                    
        #                                                                                                               
    compareValues    get_Scalar     {SeatTube DiameterBB           }  $::bikeGeometry::SeatTube(DiameterBB)             FrameTubes(SeatTube/DiameterBB)             ;# set _lastValue(FrameTubes/SeatTube/DiameterBB)                          
    compareValues    get_Scalar     {SeatTube DiameterTT           }  $::bikeGeometry::SeatTube(DiameterTT)             FrameTubes(SeatTube/DiameterTT)             ;# set _lastValue(FrameTubes/SeatTube/DiameterTT)                          
    compareValues    get_Scalar     {SeatTube TaperLength          }  $::bikeGeometry::SeatTube(TaperLength)            FrameTubes(SeatTube/TaperLength)            ;# set _lastValue(FrameTubes/SeatTube/TaperLength)                         
    compareValues    get_Scalar     {SeatTube Extension            }  $::bikeGeometry::SeatTube(Extension)              Custom(SeatTube/Extension)                  ;# set _lastValue(Custom/SeatTube/Extension)                               
    compareValues    get_Scalar     {SeatTube OffsetBB             }  $::bikeGeometry::SeatTube(OffsetBB)               Custom(SeatTube/OffsetBB)                   ;# set _lastValue(Custom/SeatTube/OffsetBB)                                
        #
    reportComparison
        #
    compareValues    get_Scalar     {TopTube DiameterHT            }  $::bikeGeometry::TopTube(DiameterHT)              FrameTubes(TopTube/DiameterHT)              ;# set _lastValue(FrameTubes/TopTube/DiameterHT)                           
    compareValues    get_Scalar     {TopTube DiameterST            }  $::bikeGeometry::TopTube(DiameterST)              FrameTubes(TopTube/DiameterST)                                          
    compareValues    get_Scalar     {TopTube TaperLength           }  $::bikeGeometry::TopTube(TaperLength)             FrameTubes(TopTube/TaperLength)
    compareValues    get_Scalar     {TopTube OffsetHT              }  $::bikeGeometry::TopTube(OffsetHT)                Custom(TopTube/OffsetHT)
    compareValues    get_Scalar     {TopTube PivotPosition         }  $::bikeGeometry::TopTube(PivotPosition)           Custom(TopTube/PivotPosition)               ;# set _lastValue(Custom/TopTube/PivotPosition)
        #
    reportComparison 
        #
    # compareValues    get_Scalar     {BottleCage DownTube_Lower     }  checkFailed_03
    # compareValues    get_Component  {Saddle                        }  checkFailed_04
        #
        
        #
    reportComparison 
        #
    #parray ::bikeGeometry::Geometry
    #parray ::bikeGeometry::Result
    #parray ::bikeGeometry::Reference
    # parray ::bikeGeometry::TopTube
        #
    # puts "  [bikeGeometry::get_Scalar     TopTube TaperLength]"
        #
    reportComparison final
        #
    
        
            # set MathValue(TopTube/DiameterST)                      [bikeGeometry::get_Scalar           TopTube  DiameterST               ]                ;# set _lastValue(FrameTubes/TopTube/DiameterST)                           
            # set MathValue(TopTube/TaperLength)                     [bikeGeometry::get_Scalar           TopTube  TaperLength              ]                ;# set _lastValue(FrameTubes/TopTube/TaperLength)                          
            # set MathValue(TopTube/OffsetHT)                        [bikeGeometry::get_Scalar           TopTube OffsetHT                  ]                ;# set _lastValue(Custom/TopTube/OffsetHT)                                 
        #

    