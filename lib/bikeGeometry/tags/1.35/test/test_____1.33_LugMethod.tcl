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
     

