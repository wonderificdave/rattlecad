puts "\n\n ====== I N I T ============================ \n\n"

    # -- ::APPL_Config(BASE_Dir)  ------
    set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
        puts "   -> \$BASE_Dir:   $BASE_Dir\n"

        # -- Libraries  ---------------
    lappend auto_path           [file join $BASE_Dir lib]
    lappend auto_path           [file join $BASE_Dir ..]
        # puts "   -> \$auto_path:  $auto_path"

        # -- Packages  ---------------
    package require   bikeGeometry  1.33
    package require   vectormath    
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
    set sampleFile  [file join $SAMPLE_Dir ktm_ultra_force_27.xml]
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

    puts "   <-> $bikeGeometry::Geometry(Fork_Rake)"
        #
    parray bikeGeometry::Fork
    puts "   <-> $bikeGeometry::Fork(Rake)"
        
    puts "here I am!"    

    
    return    
        
            set max_length     $bikeGeometry::ChainStay(completeLength)
            set S01_length     $bikeGeometry::ChainStay(segmentLength_01)       
            set S02_length     $bikeGeometry::ChainStay(segmentLength_02)       
            set S03_length     $bikeGeometry::ChainStay(segmentLength_03)       
            set S04_length     $bikeGeometry::ChainStay(segmentLength_04)       
            set tmp_length     [expr $S01_length + $S02_length + $S03_length + $S04_length]
            set S05_length     [expr $max_length - $tmp_length]
        
        
        puts ""
        puts "     \$max_length $max_length"
        puts "     \$S01_length $S01_length"
        puts "     \$S02_length $S02_length"
        puts "     \$S03_length $S03_length"
        puts "     \$S04_length $S04_length"
        puts "     \$tmp_length $tmp_length"
        puts "     \$S05_length $S05_length"
        
        
        
            set S01_angle      $bikeGeometry::ChainStay(segmentAngle_01) 
            set S02_angle      $bikeGeometry::ChainStay(segmentAngle_02) 
            set S03_angle      $bikeGeometry::ChainStay(segmentAngle_03) 
            set S04_angle      $bikeGeometry::ChainStay(segmentAngle_04) 
            set S01_radius     $bikeGeometry::ChainStay(segmentRadius_01)
            set S02_radius     $bikeGeometry::ChainStay(segmentRadius_02)
            set S03_radius     $bikeGeometry::ChainStay(segmentRadius_03)
            set S04_radius     $bikeGeometry::ChainStay(segmentRadius_04)        
        
        puts ""
        puts "     \$S01_angle $S01_angle"
        puts "     \$S02_angle $S02_angle"
        puts "     \$S03_angle $S03_angle"
        puts "     \$S04_angle $S04_angle"
        puts ""
        puts "     \$S01_radius $S01_radius"
        puts "     \$S02_radius $S02_radius"
        puts "     \$S03_radius $S03_radius"
        puts "     \$S04_radius $S04_radius"
        
        set dict_ChainStay [dict create     segment_01  $S01_length \
                                            segment_02  $S02_length \
                                            segment_03  $S03_length \
                                            segment_04  $S04_length \
                                            segment_05  $S05_length \
                                            angle_01    $S01_angle \
                                            angle_02    $S02_angle \
                                            angle_03    $S03_angle \
                                            angle_04    $S04_angle \
                                            radius_01   $S01_radius \
                                            radius_02   $S02_radius \
                                            radius_03   $S03_radius \
                                            radius_04   $S04_radius \
                            ]
            #
        # appUtil::pdict $dict_ChainStay 
            #
        if [bikeGeometry::validate_ChainStayCenterLine $dict_ChainStay] {
            puts "  ... well done!"
        } else {
            puts "  ... sorry, failed!"
        }
            #
        exit
        
        
        
        #
        #   HeadTubeAngle    68,281
    #set HeadTubeAngle       291.719 ; #-D1  ;#HeadTubeAngle    68,281 
    set a 002
    switch $a {
        001 {       # chainstay orientation
                set HeadTubeAngle       67.3262
                set CS_Orientation      ChainStay
            }
        002 -
        default {   # horizontal orientation
                set HeadTubeAngle       67.7305
                set CS_Orientation      horizontal
            }
    }
    
    # set HeadTubeAngle       67.3262 ;# chainstay orientation
    #set HeadTubeAngle       67.7305 ;# horizontal orientation
    
    
    
    # set HeadTubeAngle       [expr 360 - $HeadTubeAngle] 
        #
        #
    # puts "   ... Geometry HeadTube_Angle .................. [bikeGeometry::get_Scalar Geometry HeadTube_Angle]"
    # puts "   ... Geometry TopTube_Angle ................... [bikeGeometry::get_Scalar Geometry TopTube_Angle]"
    # puts "   ... Geometry SeatTube_Angle .................. [bikeGeometry::get_Scalar Geometry SeatTube_Angle]"
    # puts "   ... Geometry BottomBracket_Depth ............. [bikeGeometry::get_Scalar Geometry BottomBracket_Depth]"
    # set newValue [bikeGeometry::IF_LugAngles    set_Scalar Geometry HeadTube_Angle                67.3262]
    set newValue [bikeGeometry::IF_LugAngles    set_Scalar Geometry ChainStay_Length               420.0]
    set newValue [bikeGeometry::IF_LugAngles    set_Scalar Geometry FrontWheel_Radius              286.0]
    set newValue [bikeGeometry::IF_LugAngles    set_Scalar RearDropout OffsetCSPerp                 25.0]
    set newValue [bikeGeometry::IF_LugAngles    set_Scalar RearDropout RotationOffset                3.0]
    set newValue [bikeGeometry::IF_LugAngles    set_Config RearDropoutOrient             $CS_Orientation]
    
        #
    puts "\n"
    puts "          Geometry HeadTube_Angle        [bikeGeometry::get_Scalar Geometry HeadTube_Angle    ]"
    puts ""
    puts "          Geometry ChainStay_Length      [bikeGeometry::get_Scalar Geometry ChainStay_Length  ]"
    puts "          Geometry HandleBar_Distance    [bikeGeometry::get_Scalar Geometry HandleBar_Distance]"
    puts "          Geometry HandleBar_Height      [bikeGeometry::get_Scalar Geometry HandleBar_Height  ]"
    puts "          Geometry Stem_Length           [bikeGeometry::get_Scalar Geometry Stem_Length       ]"
    puts "          RearDropout OffsetCS           [bikeGeometry::get_Scalar RearDropout OffsetCS       ]"
    puts "          RearDropout OffsetCSPerp       [bikeGeometry::get_Scalar RearDropout OffsetCSPerp   ]"
    puts "          RearDropout OffsetCSPerp       [bikeGeometry::get_Scalar RearDropout RotationOffset ]"
    puts ""
    puts "          Geometry RearWheel_Radius      [bikeGeometry::get_Scalar Geometry RearWheel_Radius  ]"
    puts "          Geometry RearWheel_Radius      [bikeGeometry::get_Scalar Geometry FrontWheel_Radius ]"
    puts "\n"
    # exit
        #
    # bikeGeometry::model_lugAngle::init_Values    
        #
        #
    set  bikeGeometry::model_lugAngle::angle_SeatTubeChainStay    65.0
    set  bikeGeometry::model_lugAngle::angle_SeatTubeDownTube     64.0
    set  bikeGeometry::model_lugAngle::angle_HeadTubeDownTube     71.0
        #
    puts "\n"
    puts "     ... HeadTubeAngle     $HeadTubeAngle"
    puts "\n"
        #
    bikeGeometry::model_lugAngle::_lug_Determination $HeadTubeAngle
    
        #
        
    bikeGeometry::model_lugAngle::get_HeadTubeAngle {140 20}   
    
    exit
    
    set newValue [bikeGeometry::IF_LugAngles    set_Scalar Geometry BottomBracket_Angle_ChainStay 65.0]
    puts "       ... $newValue"
    set newValue [bikeGeometry::IF_LugAngles    set_Scalar Geometry BottomBracket_Angle_DownTube  64.0]
    puts "       ... $newValue"
    set newValue [bikeGeometry::IF_LugAngles    set_Scalar Geometry HeadLugBottom_Angle_DownTube  71.0]
    puts "       ... $newValue"
    set newValue [bikeGeometry::IF_LugAngles    set_Scalar Geometry ChainStay_Length             420.0]
    puts "       ... $newValue"
        #
    return
        #
    bikeGeometry::model_lugAngle::update_ModelGeometry
        #
    puts ""
    puts "   ... Geometry BottomBracket_Angle_ChainStay ... [bikeGeometry::get_Scalar Geometry BottomBracket_Angle_ChainStay]"
    puts "   ... Geometry BottomBracket_Angle_DownTube .... [bikeGeometry::get_Scalar Geometry BottomBracket_Angle_DownTube]"
    puts "   ... Geometry HeadLugBottom_Angle_DownTube .... [bikeGeometry::get_Scalar Geometry HeadLugBottom_Angle_DownTube]"
    puts ""
    puts "   ... Geometry HeadTube_Angle .................. [bikeGeometry::get_Scalar Geometry HeadTube_Angle]"
    puts "   ... Geometry TopTube_Angle ................... [bikeGeometry::get_Scalar Geometry TopTube_Angle]"
    puts "   ... Geometry SeatTube_Angle .................. [bikeGeometry::get_Scalar Geometry SeatTube_Angle]"
    puts "   ... Geometry BottomBracket_Depth ............. [bikeGeometry::get_Scalar Geometry BottomBracket_Depth]"
     

