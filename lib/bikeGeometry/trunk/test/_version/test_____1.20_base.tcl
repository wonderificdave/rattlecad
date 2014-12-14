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
    #
    #
        #
        #
    set BB_Position         {0 0}
    set FrontHub_Position   {-400 50}
    set RearHub_Position    {600 50}
        #
        #
    # set ::tcl_traceExec 3
        #
    # bikeGeometry::updateProject
    # bikeGeometry::geometry::_updateNamespace    
    # bikeGeometry::geometry::report_Vars
        #
    puts "      ... SteererStart ...... [bikeGeometry::get_Position  SteererStart        {0 0}]"
    puts "      ... SteererEnd ........ [bikeGeometry::get_Position  SteererEnd          {0 0}]"
    puts "      ... Polygon ........... [bikeGeometry::get_Polygon   HeadTube            {0 0}]"
        #
    bikeGeometry::frameTubes::report_Vars       
        #
    # return    
        #
    puts "      ....... BottomBracket_Depth ....... [bikeGeometry::get_Scalar  Geometry BottomBracket_Depth ]"
    puts "      ....... ChainStay_Length .......... [bikeGeometry::get_Scalar  Geometry ChainStay_Length    ]"
    puts "      ....... Fork_Height ............... [bikeGeometry::get_Scalar  Fork Height                  ]"
    puts "      ....... Fork_Rake ................. [bikeGeometry::get_Scalar  Fork Rake                    ]"
    puts "      ....... FrontWheel_Radius ......... [bikeGeometry::get_Scalar  Geometry FrontWheel_Radius   ]"     
    puts "      ....... HandleBar_Distance ........ [bikeGeometry::get_Scalar  Geometry HandleBar_Distance  ]"    
    puts "      ....... HandleBar_Height .......... [bikeGeometry::get_Scalar  Geometry HandleBar_Height    ]"      
    puts "      ....... HeadTube_Angle ............ [bikeGeometry::get_Scalar  Geometry HeadTube_Angle      ]"        
    puts "      ....... Inseam_Distance ........... [bikeGeometry::get_Scalar  Geometry Inseam_Distance     ]"        
    puts "      ....... Inseam_Length ............. [bikeGeometry::get_Scalar  Geometry Inseam_Length       ]"        
    puts "      ....... RearWheel_Radius .......... [bikeGeometry::get_Scalar  Geometry RearWheel_Radius    ]"      
    puts "      ....... Saddle_Distance ........... [bikeGeometry::get_Scalar  Geometry Saddle_Distance     ]"       
    puts "      ....... Saddle_Height ............. [bikeGeometry::get_Scalar  Geometry Saddle_Height       ]"         
    puts "      ....... Saddle_MountHeight ........ [bikeGeometry::get_Scalar  Saddle SaddleHeight          ]"
    puts "      ....... Saddle_MountOffset_x ...... [bikeGeometry::get_Scalar  Saddle Offset_x              ]"
    puts "      ....... Saddle_NoseLength ......... [bikeGeometry::get_Scalar  Saddle NoseLength            ]"
    puts "      ....... SeatPost_PivotOffset ...... [bikeGeometry::get_Scalar  SeatPost PivotOffset         ]"  
    puts "      ....... SeatPost_Setback .......... [bikeGeometry::get_Scalar  SeatPost Setback             ]"       
    puts "      ....... SeatTube_OffsetBB ......... [bikeGeometry::get_Scalar  SeatTube OffsetBB            ]"  
    puts "      ....... Stem_Angle ................ [bikeGeometry::get_Scalar  Geometry Stem_Angle          ]"            
    puts "      ....... Stem_Length ............... [bikeGeometry::get_Scalar  Geometry Stem_Length         ]"           
        #
    # exit
        #
    puts "      ... set_BottomBracket_Depth ....... [bikeGeometry::geometry::set_BottomBracket_Depth]"      
    puts "      ... set_ChainStay_Length .......... [bikeGeometry::geometry::set_ChainStay_Length]"      
    puts "      ... set_Fork_Height ............... [bikeGeometry::geometry::set_Fork_Height]"             
    puts "      ... set_Fork_Rake ................. [bikeGeometry::geometry::set_Fork_Rake]"             
    puts "      ... set_FrontWheel_Radius ......... [bikeGeometry::geometry::set_FrontWheel_Radius]"     
    puts "      ... set_HandleBar_Distance ........ [bikeGeometry::geometry::set_HandleBar_Distance]"    
    puts "      ... set_HandleBar_Height .......... [bikeGeometry::geometry::set_HandleBar_Height]"      
    puts "      ... set_HeadTube_Angle ............ [bikeGeometry::geometry::set_HeadTube_Angle]"        
    puts "      ... set_Inseam_Distance ........... [bikeGeometry::geometry::set_Inseam_Distance]"        
    puts "      ... set_Inseam_Length ............. [bikeGeometry::geometry::set_Inseam_Length]"        
    puts "      ... set_RearWheel_Radius .......... [bikeGeometry::geometry::set_RearWheel_Radius]"      
    puts "      ... set_Saddle_Distance ........... [bikeGeometry::geometry::set_Saddle_Distance]"       
    puts "      ... set_Saddle_Height ............. [bikeGeometry::geometry::set_Saddle_Height]"         
    puts "      ... set_Saddle_MountHeight ........ [bikeGeometry::geometry::set_Saddle_MountHeight]"
    puts "      ... set_Saddle_MountOffset_x ...... [bikeGeometry::geometry::set_Saddle_MountOffset_x]"
    puts "      ... set_Saddle_NoseLength ......... [bikeGeometry::geometry::set_Saddle_NoseLength]"
    puts "      ... set_SeatPost_PivotOffset ...... [bikeGeometry::geometry::set_SeatPost_PivotOffset]"  
    puts "      ... set_SeatPost_Setback .......... [bikeGeometry::geometry::set_SeatPost_Setback]"       
    puts "      ... set_SeatTube_OffsetBB ......... [bikeGeometry::geometry::set_SeatTube_OffsetBB]"  
    puts "      ... set_Stem_Angle ................ [bikeGeometry::geometry::set_Stem_Angle]"            
    puts "      ... set_Stem_Length ............... [bikeGeometry::geometry::set_Stem_Length]"           
        #
    puts ""
        #
    puts "      ... set_SeatTube_Angle ............ [bikeGeometry::geometry::set_SeatTube_Angle         75]"  
    puts "      ... set_SeatTube_Angle ............ [bikeGeometry::geometry::set_SeatTube_Angle]"  
        #
    bikeGeometry::geometry::report_Vars
        #
    puts "      ... set_BottomBracket_Height ...... [bikeGeometry::geometry::set_BottomBracket_Height   250]"  
    puts "      ... set_BottomBracket_Height ...... [bikeGeometry::geometry::set_BottomBracket_Height]"  
        #
    bikeGeometry::geometry::report_Vars
        #
    puts "      ... set_HeadTubeTopTube_Angle ..... [bikeGeometry::geometry::set_HeadTubeTopTube_Angle   80]"  
    puts "      ... set_HeadTubeTopTube_Angle ..... [bikeGeometry::geometry::set_HeadTubeTopTube_Angle]"  
        #
    bikeGeometry::geometry::report_Vars
        #
        #
    
    #puts "      ... set_BottomBracket_Depth .1..... [bikeGeometry::geometry::set_BottomBracket_Depth    55]"
    #puts "      ... set_BottomBracket_Depth .2..... [bikeGeometry::geometry::set_BottomBracket_Depth]"
        #
    puts ""
        #
    #bikeGeometry::geometry::report_Vars
        #
    #puts "      ... set_SeatTube_OffsetBB ......... [bikeGeometry::geometry::set_SeatTube_OffsetBB      5]"  
        #
    #bikeGeometry::geometry::report_Vars
        #
        #
        
