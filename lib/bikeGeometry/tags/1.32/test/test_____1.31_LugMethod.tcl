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
    set HeadTubeAngle       291.719 ; #-D1  ;#HeadTubeAngle    68,281 
    set HeadTubeAngle       291.719 ; #-D1  ;#HeadTubeAngle    68,281 
        #
        #
    puts "   ... Geometry HeadTube_Angle .................. [bikeGeometry::get_Scalar Geometry HeadTube_Angle]"
    puts "   ... Geometry TopTube_Angle ................... [bikeGeometry::get_Scalar Geometry TopTube_Angle]"
    puts "   ... Geometry SeatTube_Angle .................. [bikeGeometry::get_Scalar Geometry SeatTube_Angle]"
    puts "   ... Geometry BottomBracket_Depth ............. [bikeGeometry::get_Scalar Geometry BottomBracket_Depth]"
        #
    bikeGeometry::model_lugAngle::init_Angles    
        #
    set newValue [bikeGeometry::set_Scalar Geometry BottomBracket_Angle_ChainStay 63.0]
    puts "       ... $newValue"
    set newValue [bikeGeometry::set_Scalar Geometry BottomBracket_Angle_DownTube  61.0]
    puts "       ... $newValue"
    set newValue [bikeGeometry::set_Scalar Geometry HeadLugBottom_Angle_DownTube  60.0]
    puts "       ... $newValue"
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
     

