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
package require   bikeGeometry  1.22
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
    bikeGeometry::update_Project
    # bikeGeometry::geometry::_updateNamespace    
    # bikeGeometry::geometry::report_Vars
        #
    puts "      ... SteererStart ...... [bikeGeometry::get_Position  SteererStart        {0 0}]"
    puts "      ... SteererEnd ........ [bikeGeometry::get_Position  SteererEnd          {0 0}]"
    puts "      ... Polygon ........... [bikeGeometry::get_Polygon   HeadTube            {0 0}]"
        #
    
    puts "\n"
    
    
    puts "      BottomBracket                               ... [bikeGeometry::get_Position BottomBracket                     ]"
    puts "      BottomBracketGround                         ... [bikeGeometry::get_Position BottomBracketGround               ]"
    puts "      BrakeFront                                  ... [bikeGeometry::get_Position BrakeFront                        ]"
    puts "      FrontBrakeShoe                              ... [bikeGeometry::get_Position FrontBrakeShoe                    ]"
    puts "      FrontBrakeHelp                              ... [bikeGeometry::get_Position FrontBrakeHelp                    ]"
    puts "      FrontBrakeDefinition                        ... [bikeGeometry::get_Position FrontBrakeDefinition              ]"
    puts "      FrontBrake                                  ... [bikeGeometry::get_Position FrontBrake                        ]"
    puts "      FrontBrakeMount                             ... [bikeGeometry::get_Position FrontBrakeMount                   ]"
    puts "      BrakeRear                                   ... [bikeGeometry::get_Position BrakeRear                         ]"
    puts "      RearBrakeShoe                               ... [bikeGeometry::get_Position RearBrakeShoe                     ]"
    puts "      RearBrakeHelp                               ... [bikeGeometry::get_Position RearBrakeHelp                     ]"
    puts "      RearBrakeDefinition                         ... [bikeGeometry::get_Position RearBrakeDefinition               ]"
    puts "      RearBrake                                   ... [bikeGeometry::get_Position RearBrake                         ]"
    puts "      RearBrakeMount                              ... [bikeGeometry::get_Position RearBrakeMount                    ]"
    puts ""
    puts "      CarrierMountFront                           ... [bikeGeometry::get_Position CarrierMountFront                 ]"
    puts "      CarrierMountRear                            ... [bikeGeometry::get_Position CarrierMountRear                  ]"
    puts "      DerailleurMountFront                        ... [bikeGeometry::get_Position DerailleurMountFront              ]"
    puts "      FrontWheel                                  ... [bikeGeometry::get_Position FrontWheel                        ]"
    puts "      HandleBar                                   ... [bikeGeometry::get_Position HandleBar                         ]"
    puts "      LegClearance                                ... [bikeGeometry::get_Position LegClearance                      ]"
    puts "      RearWheel                                   ... [bikeGeometry::get_Position RearWheel                         ]"
    puts "      Reference_HB                                ... [bikeGeometry::get_Position Reference_HB                      ]"
    puts "      Reference_SN                                ... [bikeGeometry::get_Position Reference_SN                      ]"
    puts "      Saddle                                      ... [bikeGeometry::get_Position Saddle                            ]"
    puts "      SaddleNose                                  ... [bikeGeometry::get_Position SaddleNose                        ]"
    puts "      SaddleProposal                              ... [bikeGeometry::get_Position SaddleProposal                    ]"
    puts "      SeatPostPivot                               ... [bikeGeometry::get_Position SeatPostPivot                     ]"
    puts "      SeatPostSaddle                              ... [bikeGeometry::get_Position SeatPostSaddle                    ]"
    puts "      SeatPostSeatTube                            ... [bikeGeometry::get_Position SeatPostSeatTube                  ]"
    puts "      SeatTubeGround                              ... [bikeGeometry::get_Position SeatTubeGround                    ]"
    puts "      SeatTubeSaddle                              ... [bikeGeometry::get_Position SeatTubeSaddle                    ]"
    puts "      SeatTubeVirtualTopTube                      ... [bikeGeometry::get_Position SeatTubeVirtualTopTube            ]"
    puts "      SteererGround                               ... [bikeGeometry::get_Position SteererGround                     ]"
    puts ""
    puts "      RearDerailleur                              ... [bikeGeometry::get_Position RearDerailleur                    ]"
    puts ""
    puts "      RearDropout                                 ... [bikeGeometry::get_Position RearDropout                       ]"
    puts "      FrontDropout                                ... [bikeGeometry::get_Position FrontDropout                      ]"
    puts "      ForkCrown                                   ... [bikeGeometry::get_Position ForkCrown                         ]"
    puts ""
    puts "      ChainStay_SeatStay_IS                       ... [bikeGeometry::get_Position ChainStay_SeatStay_IS             ]"
    puts "      DownTube_BottleCageBase                     ... [bikeGeometry::get_Position DownTube_BottleCageBase           ]"
    puts "      DownTube_BottleCageOffset                   ... [bikeGeometry::get_Position DownTube_BottleCageOffset         ]"
    puts "      DownTube_Lower_BottleCageBase               ... [bikeGeometry::get_Position DownTube_Lower_BottleCageBase     ]"
    puts "      DownTube_Lower_BottleCageOffset             ... [bikeGeometry::get_Position DownTube_Lower_BottleCageOffset   ]"
    puts "      DownTubeEnd                                 ... [bikeGeometry::get_Position DownTubeEnd                       ]"
    puts "      DownTubeStart                               ... [bikeGeometry::get_Position DownTubeStart                     ]"
    puts "      HeadTubeEnd                                 ... [bikeGeometry::get_Position HeadTubeEnd                       ]"
    puts "      HeadTubeStart                               ... [bikeGeometry::get_Position HeadTubeStart                     ]"
    puts "      SeatStayEnd                                 ... [bikeGeometry::get_Position SeatStayEnd                       ]"
    puts "      SeatStayStart                               ... [bikeGeometry::get_Position SeatStayStart                     ]"
    puts "      SeatTube_BottleCageBase                     ... [bikeGeometry::get_Position SeatTube_BottleCageBase           ]"
    puts "      SeatTube_BottleCageOffset                   ... [bikeGeometry::get_Position SeatTube_BottleCageOffset         ]"
    puts "      SeatTubeEnd                                 ... [bikeGeometry::get_Position SeatTubeEnd                       ]"
    puts "      SeatTubeStart                               ... [bikeGeometry::get_Position SeatTubeStart                     ]"
    puts "      SteererEnd                                  ... [bikeGeometry::get_Position SteererEnd                        ]"
    puts "      SteererStart                                ... [bikeGeometry::get_Position SteererStart                      ]"
    puts "      TopTubeEnd                                  ... [bikeGeometry::get_Position TopTubeEnd                        ]"
    puts "      TopTubeStart                                ... [bikeGeometry::get_Position TopTubeStart                      ]"
    puts ""
    puts "      ChainStayRearMockup                         ... [bikeGeometry::get_Position ChainStayRearMockup               ]"
    
    # puts "      SummarySize                                 ... [bikeGeometry::get_Position SummarySize                       ]"
    
    puts "\n"    
    puts "      RearWheel                                   ... [bikeGeometry::get_Position RearWheel                         ]"
    puts "      FrontDropout                                ... [bikeGeometry::get_Position FrontDropout                      ]"
    puts "      FrontWheel                                  ... [bikeGeometry::get_Position FrontWheel                        ]"
    
    set forkConfig [bikeGeometry::set_Config Fork Suspension_26]
    puts "\n"
    puts $forkConfig
    puts "\n"    
    puts "      RearWheel                                   ... [bikeGeometry::get_Position RearWheel                         ]"
    puts "      FrontDropout                                ... [bikeGeometry::get_Position FrontDropout                      ]"
    puts "      FrontWheel                                  ... [bikeGeometry::get_Position FrontWheel                        ]"
    
