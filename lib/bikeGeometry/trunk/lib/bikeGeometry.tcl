 ##+##########################################################################
 #
 # package: bikeGeometry    ->    bikeGeometry.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2010/10/24
 #
 # The author  hereby grant permission to use,  copy, modify, distribute,
 # and  license this  software  and its  documentation  for any  purpose,
 # provided that  existing copyright notices  are retained in  all copies
 # and that  this notice  is included verbatim  in any  distributions. No
 # written agreement, license, or royalty  fee is required for any of the
 # authorized uses.  Modifications to this software may be copyrighted by
 # their authors and need not  follow the licensing terms described here,
 # provided that the new terms are clearly indicated on the first page of
 # each file where they apply.
 #
 # IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
 # FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
 # ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
 # DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
 # POSSIBILITY OF SUCH DAMAGE.
 #
 # THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
 # INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
 # MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
 # NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN "AS  IS" BASIS,
 # AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
 # MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 #
 # ---------------------------------------------------------------------------
 #    namespace:  bikeGeometry::frame_geometry_custom
 # ---------------------------------------------------------------------------
 #
 #

 # 0.18 http://sourceforge.net/p/rattlecad/tickets/2/
 # 
 # 0.59 add Rendering/Fender
 # 0.60 add Rendering/Carrier
 # 0.61 add reynoldsFEA ... export csv for Reynolds' FEA Solver
 # 0.62 add tubeDiameter ... to reynoldsFEA
 # 0.63 extend /Result/Tube with TubeProfile-Definition
 #        switch Result(Tubes/ChainStay/Direction) 
 # 0.64 unique definitions of shapes and positions with ","
 # 0.65 debug bikeGeometry::get_FenderRear 
 #        because of modified ChainStay-direction in 0.64
 # 0.66 fill Result/Length/...Wheel/Diameter bikeGeometry::fill_resultValues 
 # 0.67 fill Result/Tubes/ForkBlade/... bikeGeometry::get_Fork / get_ForkBlade
 # 0.68 debug seatpost-rendering
 # 0.69 refactor replace get_basePoints by 
 #          get_RearWheel, get_FrontWheel, get_GeometryRear
 #          get_GeometryCenter, get_GeometryFront, get_BoundingBox
 # 0.70 search an error in tubemiter, do some optimisation
 # 0.71 cleanup bikeGeometry from $project::... references
 # 0.72 cleanup from refactoring comments in 0.71
 # 0.73 references to the namespace "project::" summarized in get_from_project and set_to_project
 # 0.74 define procedures with full qualified names
 #          split procedure bikeGeometry::get_Object into 
 #                       get_Position, get_Polygon & get_Direction
 # 0.75 transfer fork-config from rattleCAD to bikeGeometry 
 #          remove bikeGeometry::set_forkConfig
 #          remove project::add_forkSetting
 #          debug  bikeGeometry::get_Fork
 # 1.05 ...
 # 1.06 move components from rattleCAD package to bikeGeometry package
 #          add proc bikeGeometry::get_ComponentDir
 # 1.07 get listBoxValues from bikeGeometry
 #          add proc bikeGeometry::get_ComponentDirectories
 #          add proc bikeGeometry::get_ListBoxValues
 # 1.08 namespace export 
 #          bikeGeometry::get_Component
 #          bikeGeometry::get_ComponentDir
 #          bikeGeometry::get_ComponentDirectories
 #          bikeGeometry::get_ListBoxValues
 # 1.09 namespace export 
 #          bikeGeometry::get_Option ... Rendering() values
 #          bikeGeometry::get_Scalar ... atomic values
 # 1.10 add Rendering(RearDropoutOrient) 
 #          as $project::Lugs(RearDropOut/Direction) 
 #              prev. RearDropOut(Direction)
 #      add RearDropout(Direction) 
 #          in bikeGeometry::get_ChainStay
 # 1.11 rename get_Option  to get_Config 
 #          add get_TubeMiter
 # 1.12 rename get_* procedure in lib_bikeGeometry_Ext.tcl
 #          fork handling implement: bikeGeometry::trace_ForkConfig
 # 1.13 remove and rename procedures 
 #          bikeGeometry::get_Value       ->  bikeGeometry::get_Value_expired
 #          bikeGeometry::get_Object      ->  bikeGeometry::get_Object_expired
 #          bikeGeometry::get_toRefactor  ->  bikeGeometry::get_CenterLine
 # 1.14 refactor
 #          insert bikeGeometry::check_mathValue
 #          rename Result(Angle/...)
 # 1.15 refactor
 #          update set_Value and set_ResultParameter  ->  lib_bikeGeometryResult.tcl
 #          rename bikeGeometry::set_base_Parameters  ->  bikeGeometry::update_Parameter
 #          move   bikeGeometry::get_from_project     ->  bikeGeometry::set_newProject 
 #          remove array _updateValue()
 #          remove set_Value from proc set_ResultParameter 
 # 1.16 refactor
 #          rename lib_bikeGeometryBase.tcl           ->  lib_bikeGeometry.tcl
 #          sumup in array Geometry()
 #          name alle x/y dimensions with ..._x and ..._y
 # 1.20 refactor
 #          insert namespace bikeGeometry::geometry  by lib_geometry.tcl
 #          ... remove FrameTubes(ChainStay/Profile/width_03) 
 #              for    FrameTubes(ChainStay/WidthBB) 
 #          update  bikeGeometry::get_projectDOM
 #              ... contains all variables for update
 # 1.21 refactor
 #           add bikeGeometry::update_Geometry to setter
 #           update array - Structure, getter, setter, get_ProjectDict
 # 1.22 refactor
 #          debug customFork ... in virgin state
 # 1.23 debug bikeGeometry::set_Result_...
 #          Geometry(RearRim_Diameter)
 #          Geometry(RearTyre_Height)
 # 1.24 refactor
 #          update array Position() for get_Position {...}
 # 1.25 refactor
 #          update array Direction() for get_Direction {...}
 # 1.26 refactor
 #          cleanup arrays
 # 1.27 debug
 #          Position(SeatTubeSaddle) ... Position(SeatTube_Saddle)
 #          update set_to_project
 # 1.28 cleanup 
 #          remove _version directory
 #          create namespace bikeGeometry::model_FreeAngle
 #          create namespace bikeGeometry::model_LugAngle
 # 1.29 debug 
 #          bikeGeometry::create_TubeMiter 
 #              handle offset of DownTube and SeatTubeOffset to BottomBracket
 #      refactor   
 #          get_from_project and set_to_project
 #          bikeGeometry::model_freeAngle in lib_model_freeAngle.tcl
 # 1.30 debug 
 #          bikeGeometry::create_TubeMiter 
 #              reverse offset of DownTube and SeatTubeOffset to BottomBracket
 # 1.31 refactor
 #          rename [namespace current]::model_freeAngle::update_ModeGeometry
 #              to [namespace current]::model_freeAngle::update_ModelGeometry
 #      implement
 #          model_lugAngle
 # 1.32 implement Interfaces 
 #          IF_Default, IF_LugAngles, IF_Classic, IF_StackReach 
 #              ... using namespace ensemble create   ... -map
 #          set SeatTube/OffsetBB and DownTube/OffsetBB  to  <0>
 #              in case of  [namespace current]::model_freeAngle::update_ModeGeometry
 #          new subdirectories for 
 #              namespace bikeGeometry::project
 #              namespace bikeGeometry::geometry3D
 # 1.33 implement 
 #          $::bikeGeometry::Geometry(SeatTube_Virtual) 
 #      debug
 #          FrameConfigMode: IF_LugAngles
 #          project::update_Project 3.4.02 -> virtualLength
 # 1.34 implement 
 #          remove geometry3D completly
 # 1.35 implement 
 #          remove reynoldsFEA completly
 #          remove reynoldsFEA completly
 #      refactor
 #          rename HeigthBB to HeightBB
 # 1.36 - 20150208
 #      debug 
 #          default setting in bikeGeometry::create_Fork: 
 #              set Direction(ForkDropout)  $Direction(Steerer)
 #      refactor
 #          cleanup bikeGeometry::update_Geometry
 #              remove bikeGeometry::set_to_project and project::runTime_2_dom
 #          bikeGeometry::create_ChainStay_RearMockup
 #              bikeGeometry::tube::cut_centerLine
 #      new ... to be continued for better usability in ChainStay Mockup
 #          bikeGeometry::tube::init_checkCenterLine
 # 1.37 - 20150209
 #      debug 
 #          bikeGeometry::create_Fork_SteelLuggedMAX -> $Position(ForkBlade_End)
 #              bikeGeometry::tube::cut_centerLine_inside
 #
 # 1.38 - 20150214
 #      feature 
 #          bikeGeometry::validate_ChainStayCenterLine
 #
 # 1.39 - 20150219
 #      cleanup 
 #          remove bikeGeometry::tube::init_checkCenterLine
 #
 # 1.40 - 20150221
 #      feature 
 #          add Scalar: CrankSet(ChainRingOffset)
 #          add proc bikeGeometry::create_CrankArm
 #
 # 1.41 - 20150223
 #      refactor 
 #          update proc bikeGeometry::create_CrankArm 
 #
 # 1.42 - 20150310
 #      refactor 
 #          update proc bikeGeometry::create_CrankArm 
 #
 # 1.43 - 20150311
 #      refactor 
 #          update proc bikeGeometry::create_CrankArm 
 #
 # 1.44 - 20150329
 #      feature:
 #          new dropout: paragon_DR0040_58
 #      refactor 
 #          lib_tube.tcl ... handle tubemiter 
 #          new procedure: get_TubeMiterDICT
 #      debug 
 #          seatstay mitter based on $::bikeGeometry::SeatStay(SeatTubeMiterDiameter)
 #      remove 
 #          lib_reynoldsFEA.tcl
 #
 # 1.45 - 20150404
 #      feature: 
 #          ... update Interfaces for BaseGeometry
 #          ... add bikeGeometry::Geometry(Saddle_HB_x)
 #
 # 1.46 - 20150421
 #      debug: 
 #          ... fork visualisation
 #              bikeGeometry::tube::create_tubeShape
 #              bikeGeometry::tube::create_ForkBlade
 #              
 # 1.47 - 20150425
 #      debug:
 #          ... bikeGeometry::get_ComponentDir
 #              ... normalize directory
 #
 # 1.48 - 20150501
 #      debug:
 #          ... bikeGeometry::create_ChainStay_RearMockup
 #              ... handle shorter completLength then resulting length of chainstay
 #
 # 1.49 - 20150503
 #      debug:
 #          ... bikeGeometry::tube::create_tubeShape
 #
 #
 # 1.xx refactor
 #          split project completely from bikeGeometry
 #
 #
  
    package require tdom
        #
    package provide bikeGeometry 1.49
        #
    package require vectormath
        #
    namespace eval bikeGeometry {
        
            # --------------------------------------------
                # Export as global command
            variable packageHomeDir [file normalize [file join [pwd] [file dirname [info script]]] ]
                #

            
            #-------------------------------------------------------------------------
                #  definitions of template parameter
            variable initDOM    $project::initDOM
            variable projectDOM
            variable returnDict; set returnDict [dict create rattleCAD {}]
                #
        
        
            #-------------------------------------------------------------------------
                #  current Project Values
            variable Project         ; array set Project         {}
            variable Geometry        ; array set Geometry        {}
            variable Reference       ; array set Reference       {}
            variable Component       ; array set Component       {}
            variable Config          ; array set Config          {}
            variable ListValue       ; array set ListValue       {}
            variable Result          ; array set Result          {}
            
            variable BottleCage      ; array set BottleCage      {}
            variable BottomBracket   ; array set BottomBracket   {}
            variable Fork            ; array set Fork            {}
            variable FrontDerailleur ; array set FrontDerailleur {}
            variable FrontWheel      ; array set FrontWheel      {}
            variable HandleBar       ; array set HandleBar       {}
            variable HeadSet         ; array set HeadSet         {}
            variable RearDerailleur  ; array set RearDerailleur  {}
            variable RearDropout     ; array set RearDropout     {}
            variable RearWheel       ; array set RearWheel       {}
            variable Saddle          ; array set Saddle          {}
            variable SeatPost        ; array set SeatPost        {}
            variable Stem            ; array set Stem            {}
            
            variable LegClearance    ; array set LegClearance    {}
            
            variable HeadTube        ; array set HeadTube        {}
            variable SeatTube        ; array set SeatTube        {}
            variable DownTube        ; array set DownTube        {}
            variable TopTube         ; array set TopTube         {}
            variable ChainStay       ; array set ChainStay       {}
            variable SeatStay        ; array set SeatStay        {}
            variable Steerer         ; array set Steerer         {}
            variable ForkBlade       ; array set ForkBlade       {}
            variable Lugs            ; array set Lugs            {}
            
            
            variable TubeMiter       ; array set TubeMiter       {}
            variable FrameJig        ; array set FrameJig        {}
            variable RearMockup      ; array set RearMockup      {}
            variable BoundingBox     ; array set BoundingBox     {}
            
            
            variable myFork          ; array set myFork          {}

            variable DEBUG_Geometry  ; array set DEBUG_Geometry  {}



            #-------------------------------------------------------------------------
                #  update loop and delay; store last value
            variable customFork      ; array set customFork { lastConfig    {} }
            
            #-------------------------------------------------------------------------
                #  update loop and delay; store last value
            # variable _updateValue   ; array set _updateValue    {}

            #-------------------------------------------------------------------------
                #  store createEdit-widgets position
            variable _drag

            #-------------------------------------------------------------------------
                #  dataprovider of create_selectbox
            variable _listBoxValues
            
            #-------------------------------------------------------------------------
                #  export procedures
            namespace export set_newProject
            namespace export get_projectDOM
            namespace export get_projectDICT
                #
            namespace export import_ProjectSubset
                #
            namespace export get_Component
            namespace export get_Config
            namespace export get_ListValue
            namespace export get_Scalar
                #
            namespace export set_Component
            namespace export set_Config
            namespace export set_ListValue
            namespace export set_Scalar
                #
            namespace export get_Polygon
            namespace export get_Position
            namespace export get_Direction
            namespace export get_BoundingBox
            namespace export get_TubeMiter
            namespace export get_TubeMiterDICT
            namespace export get_CenterLine
                #
            namespace export get_ComponentDir 
            namespace export get_ComponentDirectories
            namespace export get_ListBoxValues 
                #
            namespace export get_DebugGeometry
            namespace export get_ReynoldsFEAContent
                #
            namespace export coords_xy_index
                #
            # namespace export get_Value
            # namespace export get_Object
            # namespace export set_Value
            # namespace export set_resultParameter
                #
            # puts " Hallo!  ... [info command [namespace current]::*]" 
                #    
    }
        
        
        #
    #-------------------------------------------------------------------------
        #  load newProject
        #
        #  ... loads a new project given by a XML-Project as rootNode
        #
    proc bikeGeometry::set_newProject {_projectDOM} {

                     
            # --- set the Geometry DOM Object -----------
                #
            set project::projectDOM $_projectDOM
              
                
            # --- update the project to current level ---
                #  ... and get the required post updates
                #
            set postUpdate [project::update_Project]
        
        
            # --- make the current DOM Object alive ----
                #
            project::dom_2_runTime
        
                  # 
                  # puts "     -- 004 --------"
                  # puts [$project::projectDOM asXML]
                  # #exit
                
            # --- get all values from ::project ----
                #
            bikeGeometry::get_from_project
            
            
            # --- compute geometry ----------------------
                #
            bikeGeometry::update_Geometry
              
                
            # --- do required post updates --------------
                #
            foreach key [dict keys $postUpdate] {
                      # puts " -> $key"
                    set valueDict   [dict get $postUpdate $key]
                    foreach valueKey [dict keys $valueDict] {
                        puts "\n      -------------------------------"
                        set newValue [dict get $valueDict $valueKey]
                        puts "          postUpdate:   $key - $valueKey -> $newValue"
                        set keyString "$key/$valueKey"
                            # ... check this:
                            #bikeGeometry::set_Value $key/$valueKey $newValue update                        
                        switch -exact $keyString {
                            Result/Angle/SeatTube/Direction     {  bikeGeometry::set_Scalar Geometry SeatTube_Angle $newValue }
                        }
                    }
                        # project::pdict $valueDict
            }
            # project::runTime_2_dom
    }

    #-------------------------------------------------------------------------
       #  import a subset of a project	
    proc bikeGeometry::import_ProjectSubset {nodeRoot} {
			project::import_ProjectSubset $nodeRoot
	}

    #-------------------------------------------------------------------------
        #  get current projectDOM as DOM Object
    proc bikeGeometry::get_projectDOM {} {
            bikeGeometry::set_to_project
            set projectDOM_3401 [project::runTime_2_dom]
            return $projectDOM_3401
            # return $project::projectDOM
    }

    #-------------------------------------------------------------------------
        #  get current projectDOM as Dictionary
    proc bikeGeometry::get_projectDICT {} {
            #   return $project::projectDICT
        set projDict   [dict create Component {}  Config {}  ListValue {}  Scalar {} ]
            #
            #
            #
        dict set projDict   Component   CrankSet                            $::bikeGeometry::Component(CrankSet)                            ;#[bikeGeometry::get_Component        CrankSet                          ]                ;# set _lastValue(Component/CrankSet/File)                                 
        dict set projDict   Component   ForkCrown                           $::bikeGeometry::Component(ForkCrown)                           ;#[bikeGeometry::get_Component        Fork CrownFile                    ]                ;# set _lastValue(Component/Fork/Crown/File)                               
        dict set projDict   Component   ForkDropout                         $::bikeGeometry::Component(ForkDropout)                         ;#[bikeGeometry::get_Component        Fork DropOutFile                  ]                ;# set _lastValue(Component/Fork/DropOut/File)                             
        dict set projDict   Component   FrontBrake                          $::bikeGeometry::Component(FrontBrake)                          ;#[bikeGeometry::get_Component        FrontBrake                        ]                ;# set _lastValue(Component/Brake/Front/File)                              
        dict set projDict   Component   FrontCarrier                        $::bikeGeometry::Component(FrontCarrier)                        ;#[bikeGeometry::get_Component        FrontCarrier                      ]                ;# set _lastValue(Component/Carrier/Front/File)                            
        dict set projDict   Component   FrontDerailleur                     $::bikeGeometry::Component(FrontDerailleur)                     ;#[bikeGeometry::get_Component        FrontDerailleur                   ]                ;# set _lastValue(Component/Derailleur/Front/File)                         
        dict set projDict   Component   HandleBar                           $::bikeGeometry::Component(HandleBar)                           ;#[bikeGeometry::get_Component        HandleBar                         ]                ;# set _lastValue(Component/HandleBar/File)                                
        dict set projDict   Component   Logo                                $::bikeGeometry::Component(Logo)                                ;#[bikeGeometry::get_Component        Logo                              ]                ;# set _lastValue(Component/Logo/File)                                     
        dict set projDict   Component   RearBrake                           $::bikeGeometry::Component(RearBrake)                           ;#[bikeGeometry::get_Component        RearBrake                         ]                ;# set _lastValue(Component/Brake/Rear/File)                               
        dict set projDict   Component   RearCarrier                         $::bikeGeometry::Component(RearCarrier)                         ;#[bikeGeometry::get_Component        RearCarrier                       ]                ;# set _lastValue(Component/Carrier/Rear/File)                             
        dict set projDict   Component   RearDerailleur                      $::bikeGeometry::Component(RearDerailleur)                      ;#[bikeGeometry::get_Component        RearDerailleur                    ]                ;# set _lastValue(Component/Derailleur/Rear/File)                          
        dict set projDict   Component   RearDropout                         $::bikeGeometry::Component(RearDropout)                         ;#[bikeGeometry::get_Component        RearDropout File                  ]                ;# set _lastValue(Lugs/RearDropOut/File)                                   
        dict set projDict   Component   RearHub                             $::bikeGeometry::Component(RearHub)
        dict set projDict   Component   Saddle                              $::bikeGeometry::Component(Saddle)                              ;#[bikeGeometry::get_Component        Saddle                            ]                ;# set _lastValue(Component/Saddle/File)                                   
        dict set projDict   Component   BottleCage_DownTube                 $::bikeGeometry::Component(BottleCage_DownTube)                                
        dict set projDict   Component   BottleCage_DownTube_Lower           $::bikeGeometry::Component(BottleCage_DownTube_Lower)                          
        dict set projDict   Component   BottleCage_SeatTube                 $::bikeGeometry::Component(BottleCage_SeatTube)                                
            #                           
        dict set projDict   Config      BottleCage_DownTube                 $::bikeGeometry::Config(BottleCage_DownTube)                    ;#[bikeGeometry::get_Config           BottleCage_DT                     ]                ;# set _lastValue(Rendering/BottleCage/DownTube)                           
        dict set projDict   Config      BottleCage_DownTube_Lower           $::bikeGeometry::Config(BottleCage_DownTube_Lower)              ;#[bikeGeometry::get_Config           BottleCage_DT_L                   ]                ;# set _lastValue(Rendering/BottleCage/DownTube_Lower)                     
        dict set projDict   Config      BottleCage_SeatTube                 $::bikeGeometry::Config(BottleCage_SeatTube)                    ;#[bikeGeometry::get_Config           BottleCage_ST                     ]                ;# set _lastValue(Rendering/BottleCage/SeatTube)                           
        dict set projDict   Config      ChainStay                           $::bikeGeometry::Config(ChainStay)                              ;#[bikeGeometry::get_Config           ChainStay                         ]                ;# set _lastValue(Rendering/ChainStay)                                     
        dict set projDict   Config      Fork                                $::bikeGeometry::Config(Fork)                                   ;#[bikeGeometry::get_Config           Fork                              ]                ;# set _lastValue(Rendering/Fork)                                          
        dict set projDict   Config      ForkBlade                           $::bikeGeometry::Config(ForkBlade)                              ;#[bikeGeometry::get_Config           ForkBlade                         ]                ;# set _lastValue(Rendering/ForkBlade)                                     
        dict set projDict   Config      ForkDropout                         $::bikeGeometry::Config(ForkDropout)                            ;#[bikeGeometry::get_Config           ForkDropout                       ]                ;# set _lastValue(Rendering/ForkDropOut)                                   
        dict set projDict   Config      FrontBrake                          $::bikeGeometry::Config(FrontBrake)                             ;#[bikeGeometry::get_Config           FrontBrake                        ]                ;# set _lastValue(Rendering/Brake/Front)                                   
        dict set projDict   Config      FrontFender                         $::bikeGeometry::Config(FrontFender)                            ;#[bikeGeometry::get_Config           FrontFender                       ]                ;# set _lastValue(Rendering/Fender/Front)                                  
        dict set projDict   Config      RearBrake                           $::bikeGeometry::Config(RearBrake)                              ;#[bikeGeometry::get_Config           RearBrake                         ]                ;# set _lastValue(Rendering/Brake/Rear)                                    
        dict set projDict   Config      RearDropout                         $::bikeGeometry::Config(RearDropout)                            ;#[bikeGeometry::get_Config           RearDropout                       ]                ;# set _lastValue(Rendering/RearDropOut)                                   
        dict set projDict   Config      RearDropoutOrient                   $::bikeGeometry::Config(RearDropoutOrient)                      ;#[bikeGeometry::get_Config           RearDropoutOrient                 ]                ;# set _lastValue(Lugs/RearDropOut/Direction)                              
        dict set projDict   Config      RearFender                          $::bikeGeometry::Config(RearFender)                             ;#[bikeGeometry::get_Config           RearFender                        ]                ;# set _lastValue(Rendering/Fender/Rear)                                   
            #                           
        dict set projDict   ListValue   CrankSetChainRings                  $::bikeGeometry::ListValue(CrankSetChainRings)                  ;#[bikeGeometry::get_Scalar           CrankSet ChainRings               ]                ;# set _lastValue(Component/CrankSet/ChainRings)                           
            #           
        dict set projDict   Scalar      BottleCage DownTube                 $::bikeGeometry::BottleCage(DownTube)                           ;#[bikeGeometry::get_Scalar           BottleCage DownTube               ]                ;# set _lastValue(Component/BottleCage/DownTube/OffsetBB)                  
        dict set projDict   Scalar      BottleCage DownTube_Lower           $::bikeGeometry::BottleCage(DownTube_Lower)                     ;#[bikeGeometry::get_Scalar           BottleCage DownTube_Lower         ]                ;# set _lastValue(Component/BottleCage/DownTube_Lower/OffsetBB)            
        dict set projDict   Scalar      BottleCage SeatTube                 $::bikeGeometry::BottleCage(SeatTube)                           ;#[bikeGeometry::get_Scalar           BottleCage SeatTube               ]                ;# set _lastValue(Component/BottleCage/SeatTube/OffsetBB)                  
        dict set projDict   Scalar      BottomBracket InsideDiameter        $::bikeGeometry::BottomBracket(InsideDiameter)                  ;#[bikeGeometry::get_Scalar           BottomBracket InsideDiameter      ]                ;# set _lastValue(Lugs/BottomBracket/Diameter/inside)                      
        dict set projDict   Scalar      BottomBracket OffsetCS_TopView      $::bikeGeometry::BottomBracket(OffsetCS_TopView)                ;#[bikeGeometry::get_Scalar           BottomBracket OffsetCS_TopView    ]                ;# set _lastValue(Lugs/BottomBracket/ChainStay/Offset_TopView)             
        dict set projDict   Scalar      BottomBracket OutsideDiameter       $::bikeGeometry::BottomBracket(OutsideDiameter)                 ;#[bikeGeometry::get_Scalar           BottomBracket OutsideDiameter     ]                ;# set _lastValue(Lugs/BottomBracket/Diameter/outside)                     
        dict set projDict   Scalar      BottomBracket Width                 $::bikeGeometry::BottomBracket(Width)                           ;#[bikeGeometry::get_Scalar           BottomBracket Width               ]                ;# set _lastValue(Lugs/BottomBracket/Width)                                
            #            
        dict set projDict   Scalar      ChainStay DiameterSS                $::bikeGeometry::ChainStay(DiameterSS)                          ;#[bikeGeometry::get_Scalar           ChainStay DiameterSS              ]                ;# set _lastValue(FrameTubes/ChainStay/DiameterSS)                         
        dict set projDict   Scalar      ChainStay Height                    $::bikeGeometry::ChainStay(Height)                              ;#[bikeGeometry::get_Scalar           ChainStay Height                  ]                ;# set _lastValue(FrameTubes/ChainStay/Height)                             
        dict set projDict   Scalar      ChainStay HeightBB                  $::bikeGeometry::ChainStay(HeightBB)                            ;#[bikeGeometry::get_Scalar           ChainStay HeigthBB                ]                ;# set _lastValue(FrameTubes/ChainStay/HeightBB)                           
        dict set projDict   Scalar      ChainStay TaperLength               $::bikeGeometry::ChainStay(TaperLength)                         ;#[bikeGeometry::get_Scalar           ChainStay TaperLength             ]                ;# set _lastValue(FrameTubes/ChainStay/TaperLength)                        
        dict set projDict   Scalar      ChainStay WidthBB                   $::bikeGeometry::ChainStay(WidthBB)                             ;#[bikeGeometry::get_Scalar           ChainStay WidthBB                 ]                ;# set _lastValue(FrameTubes/ChainStay/TaperLength)                        
        dict set projDict   Scalar      ChainStay completeLength            $::bikeGeometry::ChainStay(completeLength)                      ;#[bikeGeometry::get_Scalar           ChainStay completeLength          ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/completeLength)             
        dict set projDict   Scalar      ChainStay cuttingLeft               $::bikeGeometry::ChainStay(cuttingLeft)                         ;#[bikeGeometry::get_Scalar           ChainStay cuttingLeft             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/cuttingLeft)                
        dict set projDict   Scalar      ChainStay cuttingLength             $::bikeGeometry::ChainStay(cuttingLength)                       ;#[bikeGeometry::get_Scalar           ChainStay cuttingLength           ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/cuttingLength)              
        dict set projDict   Scalar      ChainStay profile_x01               $::bikeGeometry::ChainStay(profile_x01)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_x01             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/length_01)                  
        dict set projDict   Scalar      ChainStay profile_x02               $::bikeGeometry::ChainStay(profile_x02)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_x02             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/length_02)                  
        dict set projDict   Scalar      ChainStay profile_x03               $::bikeGeometry::ChainStay(profile_x03)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_x03             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/length_03)                  
        dict set projDict   Scalar      ChainStay profile_y00               $::bikeGeometry::ChainStay(profile_y00)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_y00             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/width_00)                   
        dict set projDict   Scalar      ChainStay profile_y01               $::bikeGeometry::ChainStay(profile_y01)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_y01             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/width_01)                   
        dict set projDict   Scalar      ChainStay profile_y02               $::bikeGeometry::ChainStay(profile_y02)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_y02             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/width_02)                   
        dict set projDict   Scalar      ChainStay segmentAngle_01           $::bikeGeometry::ChainStay(segmentAngle_01)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_01         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_01)                
        dict set projDict   Scalar      ChainStay segmentAngle_02           $::bikeGeometry::ChainStay(segmentAngle_02)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_02         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_02)                
        dict set projDict   Scalar      ChainStay segmentAngle_03           $::bikeGeometry::ChainStay(segmentAngle_03)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_03         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_03)                
        dict set projDict   Scalar      ChainStay segmentAngle_04           $::bikeGeometry::ChainStay(segmentAngle_04)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_04         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_04)                
        dict set projDict   Scalar      ChainStay segmentLength_01          $::bikeGeometry::ChainStay(segmentLength_01)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_01        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_01)               
        dict set projDict   Scalar      ChainStay segmentLength_02          $::bikeGeometry::ChainStay(segmentLength_02)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_02        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_02)               
        dict set projDict   Scalar      ChainStay segmentLength_03          $::bikeGeometry::ChainStay(segmentLength_03)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_03        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_03)               
        dict set projDict   Scalar      ChainStay segmentLength_04          $::bikeGeometry::ChainStay(segmentLength_04)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_04        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_04)               
        dict set projDict   Scalar      ChainStay segmentRadius_01          $::bikeGeometry::ChainStay(segmentRadius_01)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_01        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_01)               
        dict set projDict   Scalar      ChainStay segmentRadius_02          $::bikeGeometry::ChainStay(segmentRadius_02)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_02        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_02)               
        dict set projDict   Scalar      ChainStay segmentRadius_03          $::bikeGeometry::ChainStay(segmentRadius_03)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_03        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_03)               
        dict set projDict   Scalar      ChainStay segmentRadius_04          $::bikeGeometry::ChainStay(segmentRadius_04)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_04        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_04)               
            #            
        dict set projDict   Scalar      CrankSet ArmWidth                   $::bikeGeometry::CrankSet(ArmWidth)                             ;#[bikeGeometry::get_Scalar           CrankSet ArmWidth                 ]                ;# set _lastValue(Component/CrankSet/ArmWidth)                             
        dict set projDict   Scalar      CrankSet ChainLine                  $::bikeGeometry::CrankSet(ChainLine)                            ;#[bikeGeometry::get_Scalar           CrankSet ChainLine                ]                ;# set _lastValue(Component/CrankSet/ChainLine)                            
        dict set projDict   Scalar      CrankSet ChainRingOffset            $::bikeGeometry::CrankSet(ChainRingOffset)                                     
        dict set projDict   Scalar      CrankSet Length                     $::bikeGeometry::CrankSet(Length)                               ;#[bikeGeometry::get_Scalar           CrankSet Length                   ]                ;# set _lastValue(Component/CrankSet/Length)                               
        dict set projDict   Scalar      CrankSet PedalEye                   $::bikeGeometry::CrankSet(PedalEye)                             ;#[bikeGeometry::get_Scalar           CrankSet PedalEye                 ]                ;# set _lastValue(Component/CrankSet/PedalEye)                             
        dict set projDict   Scalar      CrankSet Q-Factor                   $::bikeGeometry::CrankSet(Q-Factor)                             ;#[bikeGeometry::get_Scalar           CrankSet Q-Factor                 ]                ;# set _lastValue(Component/CrankSet/Q-Factor)                             
            #
        dict set projDict   Scalar      DownTube DiameterBB                 $::bikeGeometry::DownTube(DiameterBB)                           ;#[bikeGeometry::get_Scalar           DownTube DiameterBB               ]                ;# set _lastValue(FrameTubes/DownTube/DiameterBB)                          
        dict set projDict   Scalar      DownTube DiameterHT                 $::bikeGeometry::DownTube(DiameterHT)                           ;#[bikeGeometry::get_Scalar           DownTube DiameterHT               ]                ;# set _lastValue(FrameTubes/DownTube/DiameterHT)                          
        dict set projDict   Scalar      DownTube OffsetBB                   $::bikeGeometry::DownTube(OffsetBB)                             ;#[bikeGeometry::get_Scalar           DownTube OffsetBB                 ]                ;# set _lastValue(Custom/DownTube/OffsetBB)                                
        dict set projDict   Scalar      DownTube OffsetHT                   $::bikeGeometry::DownTube(OffsetHT)                             ;#[bikeGeometry::get_Scalar           DownTube OffsetHT                 ]                ;# set _lastValue(Custom/DownTube/OffsetHT)                                
        dict set projDict   Scalar      DownTube TaperLength                $::bikeGeometry::DownTube(TaperLength)                          ;#[bikeGeometry::get_Scalar           DownTube TaperLength              ]                ;# set _lastValue(FrameTubes/DownTube/TaperLength)                         
            #            
        dict set projDict   Scalar      Fork BladeBendRadius                $::bikeGeometry::Fork(BladeBendRadius)                          ;#[bikeGeometry::get_Scalar           Fork BladeBendRadius              ]                ;# set _lastValue(Component/Fork/Blade/BendRadius)                         
        dict set projDict   Scalar      Fork BladeDiameterDO                $::bikeGeometry::Fork(BladeDiameterDO)                          ;#[bikeGeometry::get_Scalar           Fork BladeDiameterDO              ]                ;# set _lastValue(Component/Fork/Blade/DiameterDO)                         
        dict set projDict   Scalar      Fork BladeEndLength                 $::bikeGeometry::Fork(BladeEndLength)                           ;#[bikeGeometry::get_Scalar           Fork BladeEndLength               ]                ;# set _lastValue(Component/Fork/Blade/EndLength)                          
        dict set projDict   Scalar      Fork BladeOffsetCrown               $::bikeGeometry::Fork(BladeOffsetCrown)                         ;#[bikeGeometry::get_Scalar           Fork BladeOffsetCrown             ]                ;# set _lastValue(Component/Fork/Crown/Blade/Offset)                       
        dict set projDict   Scalar      Fork BladeOffsetCrownPerp           $::bikeGeometry::Fork(BladeOffsetCrownPerp)                     ;#[bikeGeometry::get_Scalar           Fork BladeOffsetCrownPerp         ]                ;# set _lastValue(Component/Fork/Crown/Blade/OffsetPerp)                   
        dict set projDict   Scalar      Fork BladeOffsetDO                  $::bikeGeometry::Fork(BladeOffsetDO)                            ;#[bikeGeometry::get_Scalar           Fork BladeOffsetDO                ]                ;# set _lastValue(Component/Fork/DropOut/Offset)                           
        dict set projDict   Scalar      Fork BladeOffsetDOPerp              $::bikeGeometry::Fork(BladeOffsetDOPerp)                        ;#[bikeGeometry::get_Scalar           Fork BladeOffsetDOPerp            ]                ;# set _lastValue(Component/Fork/DropOut/OffsetPerp)                       
        dict set projDict   Scalar      Fork BladeTaperLength               $::bikeGeometry::Fork(BladeTaperLength)                         ;#[bikeGeometry::get_Scalar           Fork BladeTaperLength             ]                ;# set _lastValue(Component/Fork/Blade/TaperLength)                        
        dict set projDict   Scalar      Fork BladeWidth                     $::bikeGeometry::Fork(BladeWidth)                               ;#[bikeGeometry::get_Scalar           Fork BladeWidth                   ]                ;# set _lastValue(Component/Fork/Blade/Width)                              
        dict set projDict   Scalar      Fork CrownAngleBrake                $::bikeGeometry::Fork(CrownAngleBrake)                          ;#[bikeGeometry::get_Scalar           Fork BrakeAngle                   ]                ;# set _lastValue(Component/Fork/Crown/Brake/Angle)                        
        dict set projDict   Scalar      Fork CrownOffsetBrake               $::bikeGeometry::Fork(CrownOffsetBrake)                         ;#[bikeGeometry::get_Scalar           Fork BrakeOffset                  ]                ;# set _lastValue(Component/Fork/Crown/Brake/Offset)                       
            # dict set projDict   Scalar      Fork BrakeAngle               $::bikeGeometry::Fork(BrakeAngle)                               ;#[bikeGeometry::get_Scalar           Fork BrakeAngle                   ]                ;# set _lastValue(Component/Fork/Crown/Brake/Angle)                        
            # dict set projDict   Scalar      Fork BrakeOffset              $::bikeGeometry::Fork(BrakeOffset)                              ;#[bikeGeometry::get_Scalar           Fork BrakeOffset                  ]                ;# set _lastValue(Component/Fork/Crown/Brake/Offset)                       
        dict set projDict   Scalar      Fork BladeBrakeOffset               $::bikeGeometry::Fork(BladeBrakeOffset)                         ;
            #            
        dict set projDict   Scalar      FrontBrake LeverLength              $::bikeGeometry::FrontBrake(LeverLength)                        ;#[bikeGeometry::get_Scalar           FrontBrake LeverLength            ]                ;# set _lastValue(Component/Brake/Front/LeverLength)                       
        dict set projDict   Scalar      FrontBrake Offset                   $::bikeGeometry::FrontBrake(Offset)                             ;#[bikeGeometry::get_Scalar           FrontBrake Offset                 ]                ;# set _lastValue(Component/Brake/Front/Offset)                            
        dict set projDict   Scalar      FrontCarrier x                      $::bikeGeometry::FrontCarrier(x)                                ;#[bikeGeometry::get_Scalar           FrontCarrier x                    ]                ;# set _lastValue(Component/Carrier/Front/x)                               
        dict set projDict   Scalar      FrontCarrier y                      $::bikeGeometry::FrontCarrier(y)                                ;#[bikeGeometry::get_Scalar           FrontCarrier y                    ]                ;# set _lastValue(Component/Carrier/Front/y)                               
        dict set projDict   Scalar      FrontDerailleur Distance            $::bikeGeometry::FrontDerailleur(Distance)                      ;#[bikeGeometry::get_Scalar           FrontDerailleur Distance          ]                ;# set _lastValue(Component/Derailleur/Front/Distance)                     
        dict set projDict   Scalar      FrontDerailleur Offset              $::bikeGeometry::FrontDerailleur(Offset)                        ;#[bikeGeometry::get_Scalar           FrontDerailleur Offset            ]                ;# set _lastValue(Component/Derailleur/Front/Offset)                       
        dict set projDict   Scalar      FrontFender Height                  $::bikeGeometry::FrontFender(Height)                            ;#[bikeGeometry::get_Scalar           FrontFender Height                ]                ;# set _lastValue(Component/Fender/Front/Height)                           
        dict set projDict   Scalar      FrontFender OffsetAngle             $::bikeGeometry::FrontFender(OffsetAngle)                       ;#[bikeGeometry::get_Scalar           FrontFender OffsetAngle           ]                ;# set _lastValue(Component/Fender/Front/OffsetAngle)                      
        dict set projDict   Scalar      FrontFender OffsetAngleFront        $::bikeGeometry::FrontFender(OffsetAngleFront)                  ;#[bikeGeometry::get_Scalar           FrontFender OffsetAngleFront      ]                ;# set _lastValue(Component/Fender/Front/OffsetAngleFront)                 
        dict set projDict   Scalar      FrontFender Radius                  $::bikeGeometry::FrontFender(Radius)                            ;#[bikeGeometry::get_Scalar           FrontFender Radius                ]                ;# set _lastValue(Component/Fender/Front/Radius)                           
        dict set projDict   Scalar      FrontWheel RimHeight                $::bikeGeometry::FrontWheel(RimHeight)                          ;#[bikeGeometry::get_Scalar           FrontWheel RimHeight              ]                ;# set _lastValue(Component/Wheel/Front/RimHeight)                         
            #            
        dict set projDict   Scalar      Geometry BottomBracket_Depth        $::bikeGeometry::Geometry(BottomBracket_Depth)                  ;#[bikeGeometry::get_Scalar           Geometry BottomBracket_Depth      ]                ;# set _lastValue(Custom/BottomBracket/Depth)                              
        dict set projDict   Scalar      Geometry BottomBracket_Height       $::bikeGeometry::Geometry(BottomBracket_Height)                 ;#[bikeGeometry::get_Scalar           Geometry BottomBracket_Height     ]                ;# set _lastValue(Result/Length/BottomBracket/Height)                      
        dict set projDict   Scalar      Geometry ChainStay_Length           $::bikeGeometry::Geometry(ChainStay_Length)                     ;#[bikeGeometry::get_Scalar           Geometry ChainStay_Length         ]                ;# set _lastValue(Custom/WheelPosition/Rear)                               
        dict set projDict   Scalar      Geometry FrontRim_Diameter          $::bikeGeometry::Geometry(FrontRim_Diameter)                    ;#[bikeGeometry::get_Scalar           FrontWheel RimDiameter            ]                ;# set _lastValue(Component/Wheel/Front/RimDiameter)                       
        dict set projDict   Scalar      Geometry FrontTyre_Height           $::bikeGeometry::Geometry(FrontTyre_Height)                     ;#[bikeGeometry::get_Scalar           FrontWheel TyreHeight             ]                ;# set _lastValue(Component/Wheel/Front/TyreHeight)                        
        dict set projDict   Scalar      Geometry FrontWheel_Radius          $::bikeGeometry::Geometry(FrontWheel_Radius)                    ;#[bikeGeometry::get_Scalar           Geometry FrontWheel_Radius        ]                ;# set _lastValue(Result/Length/FrontWheel/Radius)                         
        dict set projDict   Scalar      Geometry FrontWheel_x               $::bikeGeometry::Geometry(FrontWheel_x)                         ;#[bikeGeometry::get_Scalar           Geometry FrontWheel_x             ]                ;# set _lastValue(Result/Length/FrontWheel/horizontal)                     
        dict set projDict   Scalar      Geometry FrontWheel_xy              $::bikeGeometry::Geometry(FrontWheel_xy)                        ;#[bikeGeometry::get_Scalar           Geometry FrontWheel_xy            ]                ;# set _lastValue(Result/Length/FrontWheel/diagonal)                       
        dict set projDict   Scalar      Geometry HandleBar_Distance         $::bikeGeometry::Geometry(HandleBar_Distance)                   ;#[bikeGeometry::get_Scalar           Geometry HandleBar_Distance       ]                ;# set _lastValue(Personal/HandleBar_Distance)                             
        dict set projDict   Scalar      Geometry HandleBar_Height           $::bikeGeometry::Geometry(HandleBar_Height)                     ;#[bikeGeometry::get_Scalar           Geometry HandleBar_Height         ]                ;# set _lastValue(Personal/HandleBar_Height)                               
        dict set projDict   Scalar      Geometry HeadTube_Angle             $::bikeGeometry::Geometry(HeadTube_Angle)                       ;#[bikeGeometry::get_Scalar           Geometry HeadTube_Angle           ]                ;# set _lastValue(Custom/HeadTube/Angle)                                   
        dict set projDict   Scalar      Geometry Inseam_Length              $::bikeGeometry::Geometry(Inseam_Length)                        ;#[bikeGeometry::get_Scalar           Geometry Inseam_Length            ]                ;# set _lastValue(Personal/InnerLeg_Length)                                
        dict set projDict   Scalar      Geometry Reach_Length               $::bikeGeometry::Geometry(Reach_Length)                         ;#[bikeGeometry::get_Scalar           Geometry ReachLengthResult        ]                ;# set _lastValue(Result/Length/HeadTube/ReachLength)                      
        dict set projDict   Scalar      Geometry RearRim_Diameter           $::bikeGeometry::Geometry(RearRim_Diameter)                     ;#[bikeGeometry::get_Scalar           RearWheel RimDiameter             ]                ;# set _lastValue(Component/Wheel/Rear/RimDiameter)                        
        dict set projDict   Scalar      Geometry RearTyre_Height            $::bikeGeometry::Geometry(RearTyre_Height)                      ;#[bikeGeometry::get_Scalar           RearWheel TyreHeight              ]                ;# set _lastValue(Component/Wheel/Rear/TyreHeight)                         
        dict set projDict   Scalar      Geometry RearWheel_Radius           $::bikeGeometry::Geometry(RearWheel_Radius)                     ;#[bikeGeometry::get_Scalar           Geometry RearWheel_Radius         ]                ;# set _lastValue(Result/Length/RearWheel/Radius)                          
        dict set projDict   Scalar      Geometry RearWheel_x                $::bikeGeometry::Geometry(RearWheel_x)                          ;#[bikeGeometry::get_Scalar           Geometry RearWheel_x              ]                ;# set _lastValue(Result/Length/RearWheel/horizontal)                      
        dict set projDict   Scalar      Geometry SaddleNose_BB_x            $::bikeGeometry::Geometry(SaddleNose_BB_x)                      ;#[bikeGeometry::get_Scalar           Geometry SaddleNose_BB_x          ]                ;# set _lastValue(Result/Length/Saddle/Offset_BB_Nose)                     
        dict set projDict   Scalar      Geometry SaddleNose_HB              $::bikeGeometry::Geometry(SaddleNose_HB)                        ;#[bikeGeometry::get_Scalar           Geometry SaddleNose_HB            ]                ;# set _lastValue(Result/Length/Personal/SaddleNose_HB)                    
        dict set projDict   Scalar      Geometry Saddle_BB                  $::bikeGeometry::Geometry(Saddle_BB)                            ;#[bikeGeometry::get_Scalar           Geometry Saddle_BB                ]                ;# set _lastValue(Result/Length/Saddle/SeatTube_BB)                        
        dict set projDict   Scalar      Geometry Saddle_Distance            $::bikeGeometry::Geometry(Saddle_Distance)                      ;#[bikeGeometry::get_Scalar           Geometry Saddle_Distance          ]                ;# set _lastValue(Personal/Saddle_Distance)                                
        dict set projDict   Scalar      Geometry Saddle_HB_x                $::bikeGeometry::Geometry(Saddle_HB_x)                                       
        dict set projDict   Scalar      Geometry Saddle_HB_y                $::bikeGeometry::Geometry(Saddle_HB_y)                          ;#[bikeGeometry::get_Scalar           Geometry Saddle_HB_y              ]                ;# set _lastValue(Result/Length/Saddle/Offset_HB)                          
        dict set projDict   Scalar      Geometry Saddle_Height              $::bikeGeometry::Geometry(Saddle_Height)                        ;#[bikeGeometry::get_Scalar           Geometry Saddle_Height            ]                ;# set _lastValue(Result/Length/Saddle/Offset_HB)                          
        dict set projDict   Scalar      Geometry Saddle_Offset_BB_ST        $::bikeGeometry::Geometry(Saddle_Offset_BB_ST)                  ;#[bikeGeometry::get_Scalar           Geometry Saddle_Offset_BB_ST      ]                ;# set _lastValue(Result/Length/Saddle/Offset_BB_ST)                       
        dict set projDict   Scalar      Geometry SeatTube_Virtual           $::bikeGeometry::Geometry(SeatTube_Virtual)                     ;#[bikeGeometry::get_Scalar           Geometry SeatTubeVirtual          ]                ;# set _lastValue(Result/Length/SeatTube/VirtualLength)                    
        dict set projDict   Scalar      Geometry Stack_Height               $::bikeGeometry::Geometry(Stack_Height)                         ;#[bikeGeometry::get_Scalar           Geometry StackHeightResult        ]                ;# set _lastValue(Result/Length/HeadTube/StackHeight)                      
        dict set projDict   Scalar      Geometry Stem_Angle                 $::bikeGeometry::Geometry(Stem_Angle)                           ;#[bikeGeometry::get_Scalar           Geometry Stem_Angle               ]                ;# set _lastValue(Component/Stem/Angle)                                    
        dict set projDict   Scalar      Geometry Stem_Length                $::bikeGeometry::Geometry(Stem_Length)                          ;#[bikeGeometry::get_Scalar           Geometry Stem_Length              ]                ;# set _lastValue(Component/Stem/Length)                                   
        dict set projDict   Scalar      Geometry TopTube_Virtual            $::bikeGeometry::Geometry(TopTube_Virtual)                      ;#[bikeGeometry::get_Scalar           Geometry TopTubeVirtual           ]                ;# set _lastValue(Result/Length/TopTube/VirtualLength)                     
        dict set projDict   Scalar      Geometry TopTube_Angle              $::bikeGeometry::Geometry(TopTube_Angle)                        ;#[bikeGeometry::get_Scalar           Geometry TopTube_Angle            ]                ;# set _lastValue(Custom/TopTube/Angle)                                    
        dict set projDict   Scalar      Geometry SeatTube_Angle             $::bikeGeometry::Geometry(SeatTube_Angle)                       ;#[bikeGeometry::get_Scalar           SeatTube Angle                    ]                ;# set _lastValue(Result/Angle/SeatTube/Direction)                         
        dict set projDict   Scalar      Geometry Fork_Height                $::bikeGeometry::Geometry(Fork_Height)                          ;#[bikeGeometry::get_Scalar           Fork Height                       ]                ;# set _lastValue(Component/Fork/Height)                                   
        dict set projDict   Scalar      Geometry Fork_Rake                  $::bikeGeometry::Geometry(Fork_Rake)                            ;#[bikeGeometry::get_Scalar           Fork Rake                         ]                ;# set _lastValue(Component/Fork/Rake)                                     
            # 
        dict set projDict   Scalar      Geometry BottomBracket_Angle_ChainStay  $::bikeGeometry::Geometry(BottomBracket_Angle_ChainStay)                                
        dict set projDict   Scalar      Geometry BottomBracket_Angle_DownTube   $::bikeGeometry::Geometry(BottomBracket_Angle_DownTube)                                
        dict set projDict   Scalar      Geometry HeadLug_Angle_Bottom           $::bikeGeometry::Geometry(HeadLug_Angle_Bottom)                                
            #
        dict set projDict   Scalar      Geometry HeadLug_Angle_Top          $::bikeGeometry::Geometry(HeadLug_Angle_Top)                    ;#[bikeGeometry::get_Scalar           Result Angle_HeadTubeTopTube      ]                ;# set _lastValue(Result/Angle/HeadTube/TopTube)                           
        dict set projDict   Scalar      Geometry HeadTube_Virtual           $::bikeGeometry::Geometry(HeadTube_Virtual)                     ;#[bikeGeometry::get_Scalar           HeadTube Length_Virtual           ]                ;# set _lastValue(FrameTubes/HeadTube/Length)                              
            #
        dict set projDict   Scalar      HandleBar PivotAngle                $::bikeGeometry::HandleBar(PivotAngle)                          ;#[bikeGeometry::get_Scalar           HandleBar PivotAngle              ]                ;# set _lastValue(Component/HandleBar/PivotAngle)                          
        dict set projDict   Scalar      HeadSet Diameter                    $::bikeGeometry::HeadSet(Diameter)                              ;#[bikeGeometry::get_Scalar           HeadSet Diameter                  ]                ;# set _lastValue(Component/HeadSet/Diameter)                              
        dict set projDict   Scalar      HeadSet Height_Bottom               $::bikeGeometry::HeadSet(Height_Bottom)                         ;#[bikeGeometry::get_Scalar           HeadSet Height_Bottom             ]                ;# set _lastValue(Component/HeadSet/Height/Bottom)                         
        dict set projDict   Scalar      HeadSet Height_Top                  $::bikeGeometry::HeadSet(Height_Top)                            ;#[bikeGeometry::get_Scalar           HeadSet Height_Top                ]                ;# set _lastValue(Component/HeadSet/Height/Top)                            
        dict set projDict   Scalar      HeadTube Diameter                   $::bikeGeometry::HeadTube(Diameter)                             ;#[bikeGeometry::get_Scalar           HeadTube Diameter                 ]                ;# set _lastValue(FrameTubes/HeadTube/Diameter)                            
        dict set projDict   Scalar      HeadTube Length                     $::bikeGeometry::HeadTube(Length)                               ;#[bikeGeometry::get_Scalar           HeadTube Length                   ]                ;# set _lastValue(FrameTubes/HeadTube/Length)                              
            #            
        dict set projDict   Scalar      Lugs BottomBracket_ChainStay_Angle      $::bikeGeometry::Lugs(BottomBracket_ChainStay_Angle)        ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_ChainStay_Angle        ]        ;# set _lastValue(Lugs/BottomBracket/ChainStay/Angle/value)                
        dict set projDict   Scalar      Lugs BottomBracket_ChainStay_Tolerance  $::bikeGeometry::Lugs(BottomBracket_ChainStay_Tolerance)    ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_ChainStay_Tolerance    ]        ;# set _lastValue(Lugs/BottomBracket/ChainStay/Angle/plus_minus)           
        dict set projDict   Scalar      Lugs BottomBracket_DownTube_Angle       $::bikeGeometry::Lugs(BottomBracket_DownTube_Angle)         ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_DownTube_Angle         ]        ;# set _lastValue(Lugs/BottomBracket/DownTube/Angle/value)                 
        dict set projDict   Scalar      Lugs BottomBracket_DownTube_Tolerance   $::bikeGeometry::Lugs(BottomBracket_DownTube_Tolerance)     ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_DownTube_Tolerance     ]        ;# set _lastValue(Lugs/BottomBracket/DownTube/Angle/plus_minus)            
        dict set projDict   Scalar      Lugs HeadLug_Bottom_Angle               $::bikeGeometry::Lugs(HeadLug_Bottom_Angle)                 ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Bottom_Angle         ]                ;# set _lastValue(Lugs/HeadTube/DownTube/Angle/value)                      
        dict set projDict   Scalar      Lugs HeadLug_Bottom_Tolerance           $::bikeGeometry::Lugs(HeadLug_Bottom_Tolerance)             ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Bottom_Tolerance     ]                ;# set _lastValue(Lugs/HeadTube/DownTube/Angle/plus_minus)                 
        dict set projDict   Scalar      Lugs HeadLug_Top_Angle                  $::bikeGeometry::Lugs(HeadLug_Top_Angle)                    ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Top_Angle            ]                ;# set _lastValue(Lugs/HeadTube/TopTube/Angle/value)                       
        dict set projDict   Scalar      Lugs HeadLug_Top_Tolerance              $::bikeGeometry::Lugs(HeadLug_Top_Tolerance)                ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Top_Tolerance        ]                ;# set _lastValue(Lugs/HeadTube/TopTube/Angle/plus_minus)                  
        dict set projDict   Scalar      Lugs RearDropOut_Angle                  $::bikeGeometry::Lugs(RearDropOut_Angle)                    ;#[bikeGeometry::get_Scalar           Lugs RearDropOut_Angle            ]                ;# set _lastValue(Lugs/RearDropOut/Angle/value)                            
        dict set projDict   Scalar      Lugs RearDropOut_Tolerance              $::bikeGeometry::Lugs(RearDropOut_Tolerance)                ;#[bikeGeometry::get_Scalar           Lugs RearDropOut_Tolerance        ]                ;# set _lastValue(Lugs/RearDropOut/Angle/plus_minus)                       
        dict set projDict   Scalar      Lugs SeatLug_SeatStay_Angle             $::bikeGeometry::Lugs(SeatLug_SeatStay_Angle)               ;#[bikeGeometry::get_Scalar           Lugs SeatLug_SeatStay_Angle       ]                ;# set _lastValue(Lugs/SeatTube/SeatStay/Angle/value)                      
        dict set projDict   Scalar      Lugs SeatLug_SeatStay_Tolerance         $::bikeGeometry::Lugs(SeatLug_SeatStay_Tolerance)           ;#[bikeGeometry::get_Scalar           Lugs SeatLug_SeatStay_Tolerance   ]                ;# set _lastValue(Lugs/SeatTube/SeatStay/Angle/plus_minus)                 
        dict set projDict   Scalar      Lugs SeatLug_TopTube_Angle              $::bikeGeometry::Lugs(SeatLug_TopTube_Angle)                ;#[bikeGeometry::get_Scalar           Lugs SeatLug_TopTube_Angle        ]                ;# set _lastValue(Lugs/SeatTube/TopTube/Angle/value)                       
        dict set projDict   Scalar      Lugs SeatLug_TopTube_Tolerance          $::bikeGeometry::Lugs(SeatLug_TopTube_Tolerance)            ;#[bikeGeometry::get_Scalar           Lugs SeatLug_TopTube_Tolerance    ]                ;# set _lastValue(Lugs/SeatTube/TopTube/Angle/plus_minus)                  
            #            
        dict set projDict   Scalar      RearBrake   LeverLength                 $::bikeGeometry::RearBrake(LeverLength)                     ;#[bikeGeometry::get_Scalar           RearBrake LeverLength             ]                ;# set _lastValue(Component/Brake/Rear/LeverLength)                        
        dict set projDict   Scalar      RearBrake   Offset                      $::bikeGeometry::RearBrake(Offset)                          ;#[bikeGeometry::get_Scalar           RearBrake Offset                  ]                ;# set _lastValue(Component/Brake/Rear/Offset)                             
        dict set projDict   Scalar      RearCarrier x                           $::bikeGeometry::RearCarrier(x)                             ;#[bikeGeometry::get_Scalar           RearCarrier x                     ]                ;# set _lastValue(Component/Carrier/Rear/x)                                
        dict set projDict   Scalar      RearCarrier y                           $::bikeGeometry::RearCarrier(y)                             ;#[bikeGeometry::get_Scalar           RearCarrier y                     ]                ;# set _lastValue(Component/Carrier/Rear/y)                                
        dict set projDict   Scalar      RearDerailleur Pulley_teeth             $::bikeGeometry::RearDerailleur(Pulley_teeth)               ;#[bikeGeometry::get_Scalar           RearDerailleur Pulley_teeth       ]                ;# set _lastValue(Component/Derailleur/Rear/Pulley/teeth)                  
        dict set projDict   Scalar      RearDerailleur Pulley_x                 $::bikeGeometry::RearDerailleur(Pulley_x)                   ;#[bikeGeometry::get_Scalar           RearDerailleur Pulley_x           ]                ;# set _lastValue(Component/Derailleur/Rear/Pulley/x)                      
        dict set projDict   Scalar      RearDerailleur Pulley_y                 $::bikeGeometry::RearDerailleur(Pulley_y)                   ;#[bikeGeometry::get_Scalar           RearDerailleur Pulley_y           ]                ;# set _lastValue(Component/Derailleur/Rear/Pulley/y)                      
            #            
        dict set projDict   Scalar      RearDropout Derailleur_x                $::bikeGeometry::RearDropout(Derailleur_x)                  ;#[bikeGeometry::get_Scalar           RearDropout Derailleur_x          ]                ;# set _lastValue(Lugs/RearDropOut/Derailleur/x)                           
        dict set projDict   Scalar      RearDropout Derailleur_y                $::bikeGeometry::RearDropout(Derailleur_y)                  ;#[bikeGeometry::get_Scalar           RearDropout Derailleur_y          ]                ;# set _lastValue(Lugs/RearDropOut/Derailleur/y)                           
        dict set projDict   Scalar      RearDropout OffsetCS                    $::bikeGeometry::RearDropout(OffsetCS)                      ;#[bikeGeometry::get_Scalar           RearDropout OffsetCS              ]                ;# set _lastValue(Lugs/RearDropOut/ChainStay/Offset)                       
        dict set projDict   Scalar      RearDropout OffsetCSPerp                $::bikeGeometry::RearDropout(OffsetCSPerp)                  ;#[bikeGeometry::get_Scalar           RearDropout OffsetCSPerp          ]                ;# set _lastValue(Lugs/RearDropOut/ChainStay/OffsetPerp)                   
        dict set projDict   Scalar      RearDropout OffsetCS_TopView            $::bikeGeometry::RearDropout(OffsetCS_TopView)              ;#[bikeGeometry::get_Scalar           RearDropout OffsetCS_TopView      ]                ;# set _lastValue(Lugs/RearDropOut/ChainStay/Offset_TopView)               
        dict set projDict   Scalar      RearDropout OffsetSS                    $::bikeGeometry::RearDropout(OffsetSS)                      ;#[bikeGeometry::get_Scalar           RearDropout OffsetSS              ]                ;# set _lastValue(Lugs/RearDropOut/SeatStay/Offset)                        
        dict set projDict   Scalar      RearDropout OffsetSSPerp                $::bikeGeometry::RearDropout(OffsetSSPerp)                  ;#[bikeGeometry::get_Scalar           RearDropout OffsetSSPerp          ]                ;# set _lastValue(Lugs/RearDropOut/SeatStay/OffsetPerp)                    
        dict set projDict   Scalar      RearDropout RotationOffset              $::bikeGeometry::RearDropout(RotationOffset)                ;#[bikeGeometry::get_Scalar           RearDropout RotationOffset        ]                ;# set _lastValue(Lugs/RearDropOut/RotationOffset)                         
            #            
        dict set projDict   Scalar      RearFender  Height                      $::bikeGeometry::RearFender(Height)                         ;#[bikeGeometry::get_Scalar           RearFender Height                 ]                ;# set _lastValue(Component/Fender/Rear/Height)                            
        dict set projDict   Scalar      RearFender  OffsetAngle                 $::bikeGeometry::RearFender(OffsetAngle)                    ;#[bikeGeometry::get_Scalar           RearFender OffsetAngle            ]                ;# set _lastValue(Component/Fender/Rear/OffsetAngle)                       
        dict set projDict   Scalar      RearFender  Radius                      $::bikeGeometry::RearFender(Radius)                         ;#[bikeGeometry::get_Scalar           RearFender Radius                 ]                ;# set _lastValue(Component/Fender/Rear/Radius)                            
        dict set projDict   Scalar      RearMockup  CassetteClearance           $::bikeGeometry::RearMockup(CassetteClearance)              ;#[bikeGeometry::get_Scalar           RearMockup CassetteClearance      ]                ;# set _lastValue(Rendering/RearMockup/CassetteClearance)                  
        dict set projDict   Scalar      RearMockup  ChainWheelClearance         $::bikeGeometry::RearMockup(ChainWheelClearance)            ;#[bikeGeometry::get_Scalar           RearMockup ChainWheelClearance    ]                ;# set _lastValue(Rendering/RearMockup/ChainWheelClearance)                
        dict set projDict   Scalar      RearMockup  CrankClearance              $::bikeGeometry::RearMockup(CrankClearance)                 ;#[bikeGeometry::get_Scalar           RearMockup CrankClearance         ]                ;# set _lastValue(Rendering/RearMockup/CrankClearance)                     
        dict set projDict   Scalar      RearMockup  DiscClearance               $::bikeGeometry::RearMockup(DiscClearance)                  ;#[bikeGeometry::get_Scalar           RearMockup DiscClearance          ]                ;# set _lastValue(Rendering/RearMockup/DiscClearance)                      
        dict set projDict   Scalar      RearMockup  DiscDiameter                $::bikeGeometry::RearMockup(DiscDiameter)                   ;#[bikeGeometry::get_Scalar           RearMockup DiscDiameter           ]                ;# set _lastValue(Rendering/RearMockup/DiscDiameter)                       
        dict set projDict   Scalar      RearMockup  DiscOffset                  $::bikeGeometry::RearMockup(DiscOffset)                     ;#[bikeGeometry::get_Scalar           RearMockup DiscOffset             ]                ;# set _lastValue(Rendering/RearMockup/DiscOffset)                         
        dict set projDict   Scalar      RearMockup  DiscWidth                   $::bikeGeometry::RearMockup(DiscWidth)                      ;#[bikeGeometry::get_Scalar           RearMockup DiscWidth              ]                ;# set _lastValue(Rendering/RearMockup/DiscWidth)                          
        dict set projDict   Scalar      RearMockup  TyreClearance               $::bikeGeometry::RearMockup(TyreClearance)                  ;#[bikeGeometry::get_Scalar           RearMockup TyreClearance          ]                ;# set _lastValue(Rendering/RearMockup/TyreClearance)                      
            #            
        dict set projDict   Scalar      RearWheel   FirstSprocket               $::bikeGeometry::RearWheel(FirstSprocket)                   ;#[bikeGeometry::get_Scalar           RearWheel FirstSprocket           ]                ;# set _lastValue(Component/Wheel/Rear/FirstSprocket)                      
        dict set projDict   Scalar      RearWheel   HubWidth                    $::bikeGeometry::RearWheel(HubWidth)                        ;#[bikeGeometry::get_Scalar           RearWheel HubWidth                ]                ;# set _lastValue(Component/Wheel/Rear/HubWidth)                           
        dict set projDict   Scalar      RearWheel   RimHeight                   $::bikeGeometry::RearWheel(RimHeight)                       ;#[bikeGeometry::get_Scalar           RearWheel RimHeight               ]                ;# set _lastValue(Component/Wheel/Rear/RimHeight)                          
        dict set projDict   Scalar      RearWheel   TyreShoulder                $::bikeGeometry::RearWheel(TyreShoulder)                    ;#[bikeGeometry::get_Scalar           RearWheel TyreShoulder            ]                ;# set _lastValue(Result/Length/RearWheel/TyreShoulder)                    
        dict set projDict   Scalar      RearWheel   TyreWidth                   $::bikeGeometry::RearWheel(TyreWidth)                       ;#[bikeGeometry::get_Scalar           RearWheel TyreWidth               ]                ;# set _lastValue(Component/Wheel/Rear/TyreWidth)                          
        dict set projDict   Scalar      RearWheel   TyreWidthRadius             $::bikeGeometry::RearWheel(TyreWidthRadius)                 ;#[bikeGeometry::get_Scalar           RearWheel TyreWidthRadius         ]                ;# set _lastValue(Component/Wheel/Rear/TyreWidthRadius)                    
            #            
        dict set projDict   Scalar      Reference   HandleBar_Distance          $::bikeGeometry::Reference(HandleBar_Distance)              ;#[bikeGeometry::get_Scalar           Reference HandleBar_Distance      ]                ;# set _lastValue(Reference/HandleBar_Distance)                            
        dict set projDict   Scalar      Reference   HandleBar_Height            $::bikeGeometry::Reference(HandleBar_Height)                ;#[bikeGeometry::get_Scalar           Reference HandleBar_Height        ]                ;# set _lastValue(Reference/HandleBar_Height)                              
        dict set projDict   Scalar      Reference   SaddleNose_Distance         $::bikeGeometry::Reference(SaddleNose_Distance)             ;#[bikeGeometry::get_Scalar           Reference SaddleNose_Distance     ]                ;# set _lastValue(Reference/SaddleNose_Distance)                           
        dict set projDict   Scalar      Reference   SaddleNose_HB               $::bikeGeometry::Reference(SaddleNose_HB)                   ;#[bikeGeometry::get_Scalar           Reference SaddleNose_HB           ]                ;# set _lastValue(Result/Length/Reference/SaddleNose_HB)                   
        dict set projDict   Scalar      Reference   SaddleNose_HB_y             $::bikeGeometry::Reference(SaddleNose_HB_y)                 ;#[bikeGeometry::get_Scalar           Reference SaddleNose_HB_y         ]                ;# set _lastValue(Result/Length/Reference/Heigth_SN_HB)                    
        dict set projDict   Scalar      Reference   SaddleNose_Height           $::bikeGeometry::Reference(SaddleNose_Height)               ;#[bikeGeometry::get_Scalar           Reference SaddleNose_Height       ]                ;# set _lastValue(Reference/SaddleNose_Height)                             
            #            
        dict set projDict   Scalar      Saddle      Height                      $::bikeGeometry::Saddle(Height)                             ;#[bikeGeometry::get_Scalar           Saddle Height                     ]                ;# set _lastValue(Personal/Saddle_Height)                                  
        dict set projDict   Scalar      Saddle      NoseLength                  $::bikeGeometry::Saddle(NoseLength)                         ;#[bikeGeometry::get_Scalar           Saddle NoseLength                 ]                ;# set _lastValue(Component/Saddle/LengthNose)     
        dict set projDict   Scalar      Saddle      Offset_x                    $::bikeGeometry::Saddle(Offset_x)                           ;#[bikeGeometry::get_Scalar           Saddle Offset_x                   ]                ;# set _lastValue(Rendering/Saddle/Offset_X)                               
        dict set projDict   Scalar      Saddle      Offset_y                    $::bikeGeometry::Saddle(Offset_y)                           ;#[bikeGeometry::get_Scalar           Saddle Offset_y                   ]                ;# set _lastValue(Rendering/Saddle/Offset_Y)                                                     
            #            
        dict set projDict   Scalar      SeatPost    Diameter                    $::bikeGeometry::SeatPost(Diameter)                         ;#[bikeGeometry::get_Scalar           SeatPost Diameter                 ]                ;# set _lastValue(Component/SeatPost/Diameter)                             
        dict set projDict   Scalar      SeatPost    PivotOffset                 $::bikeGeometry::SeatPost(PivotOffset)                      ;#[bikeGeometry::get_Scalar           SeatPost PivotOffset              ]                ;# set _lastValue(Component/SeatPost/PivotOffset)                          
        dict set projDict   Scalar      SeatPost    Setback                     $::bikeGeometry::SeatPost(Setback)                          ;#[bikeGeometry::get_Scalar           SeatPost Setback                  ]                ;# set _lastValue(Component/SeatPost/Setback)                              
        dict set projDict   Scalar      SeatStay    DiameterCS                  $::bikeGeometry::SeatStay(DiameterCS)                       ;#[bikeGeometry::get_Scalar           SeatStay DiameterCS               ]                ;# set _lastValue(FrameTubes/SeatStay/DiameterCS)                          
        dict set projDict   Scalar      SeatStay    DiameterST                  $::bikeGeometry::SeatStay(DiameterST)                       ;#[bikeGeometry::get_Scalar           SeatStay DiameterST               ]                ;# set _lastValue(FrameTubes/SeatStay/DiameterST)                          
        dict set projDict   Scalar      SeatStay    OffsetTT                    $::bikeGeometry::SeatStay(OffsetTT)                         ;#[bikeGeometry::get_Scalar           SeatStay OffsetTT                 ]                ;# set _lastValue(Custom/SeatStay/OffsetTT)                                
        dict set projDict   Scalar      SeatStay    SeatTubeMiterDiameter       $::bikeGeometry::SeatStay(SeatTubeMiterDiameter)            ;#[bikeGeometry::get_Scalar           SeatStay SeatTubeMiterDiameter    ]                ;# set _lastValue(Lugs/SeatTube/SeatStay/MiterDiameter)                    
        dict set projDict   Scalar      SeatStay    TaperLength                 $::bikeGeometry::SeatStay(TaperLength)                      ;#[bikeGeometry::get_Scalar           SeatStay TaperLength              ]                ;# set _lastValue(FrameTubes/SeatStay/TaperLength)                         
            #            
        dict set projDict   Scalar      SeatTube    DiameterBB                  $::bikeGeometry::SeatTube(DiameterBB)                       ;#[bikeGeometry::get_Scalar           SeatTube DiameterBB               ]                ;# set _lastValue(FrameTubes/SeatTube/DiameterBB)                          
        dict set projDict   Scalar      SeatTube    DiameterTT                  $::bikeGeometry::SeatTube(DiameterTT)                       ;#[bikeGeometry::get_Scalar           SeatTube DiameterTT               ]                ;# set _lastValue(FrameTubes/SeatTube/DiameterTT)                          
        dict set projDict   Scalar      SeatTube    Extension                   $::bikeGeometry::SeatTube(Extension)                        ;#[bikeGeometry::get_Scalar           SeatTube Extension                ]                ;# set _lastValue(Custom/SeatTube/Extension)                               
        dict set projDict   Scalar      SeatTube    OffsetBB                    $::bikeGeometry::SeatTube(OffsetBB)                         ;#[bikeGeometry::get_Scalar           SeatTube OffsetBB                 ]                ;# set _lastValue(Custom/SeatTube/OffsetBB)                                
        dict set projDict   Scalar      SeatTube    TaperLength                 $::bikeGeometry::SeatTube(TaperLength)                      ;#[bikeGeometry::get_Scalar           SeatTube TaperLength              ]                ;# set _lastValue(FrameTubes/SeatTube/TaperLength) 
            #            
        dict set projDict   Scalar      TopTube     DiameterHT                  $::bikeGeometry::TopTube(DiameterHT)                        ;#[bikeGeometry::get_Scalar           TopTube  DiameterHT               ]                ;# set _lastValue(FrameTubes/TopTube/DiameterHT)                           
        dict set projDict   Scalar      TopTube     DiameterST                  $::bikeGeometry::TopTube(DiameterST)                        ;#[bikeGeometry::get_Scalar           TopTube DiameterST                ]                ;# set _lastValue(Custom/TopTube/PivotPosition)                                        
        dict set projDict   Scalar      TopTube     OffsetHT                    $::bikeGeometry::TopTube(OffsetHT)                          ;#[bikeGeometry::get_Scalar           TopTube TaperLength               ] 
        dict set projDict   Scalar      TopTube     PivotPosition               $::bikeGeometry::TopTube(PivotPosition)                     ;#[bikeGeometry::get_Scalar           TopTube OffsetHT                  ] 
        dict set projDict   Scalar      TopTube     TaperLength                 $::bikeGeometry::TopTube(TaperLength)                       ;#[bikeGeometry::get_Scalar           TopTube PivotPosition             ]             
            #
        return $projDict   
            #
            #
            #
        project::pdict $projDict  4
            #
            # return
            #
            # puts "\n"
            # parray Component
            # puts ""
            # parray Config
            # puts ""
            # parray ListValue
            # puts ""
            # parray MathValue
            #
            #
        foreach arrayNameComplete {Component Config ListValue MathValue} {
                # puts "      -> $arrayNameComplete"
            foreach key [lsort [array names $arrayNameComplete]] {
                    # -> get value
                set value       [lindex [array get $arrayNameComplete $key] 1]
                set arrayName   [lindex [split $arrayNameComplete ::] end]
                set dictPath    [split [string trim $arrayName/$key "/"] /]
                    # puts "       -> $dictPath"
                dict set projDict $dictPath ${value}    
                    #
            }
        }
            #
        puts "  --- "
            #
            #
            #
        project::pdict $projDict  4
            #
        return $projDict
            #
        
    }

        #
        #
    proc bikeGeometry::set_Scalar {object key value} {
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
        if 0 {
                switch -exact $object {
                    Geometry {
                            switch -exact $key {
                                {BottomBracket_Height}          {   bikeGeometry::set_Default_BottomBracketHeight    $newValue; return [get_Scalar $object $key] }
                                {FrontWheel_Radius}             {   bikeGeometry::set_Default_FrontWheelRadius       $newValue; return [get_Scalar $object $key] }
                                {FrontWheel_xy}                 {   bikeGeometry::set_Default_FrontWheeldiagonal     $newValue; return [get_Scalar $object $key] }
                                {FrontWheel_x}                  {   bikeGeometry::set_Default_FrontWheelhorizontal   $newValue; return [get_Scalar $object $key] }
                                {HeadLug_Angle_Top}             {   bikeGeometry::set_Default_HeadTube_TopTubeAngle  $newValue; return [get_Scalar $object $key] }
                                {RearWheel_Radius}              {   bikeGeometry::set_Default_RearWheelRadius        $newValue; return [get_Scalar $object $key] }
                                {RearWheel_x}                   {   bikeGeometry::set_Default_RearWheelhorizontal    $newValue; return [get_Scalar $object $key] }
                                {SaddleNose_BB_x}               {   bikeGeometry::set_Default_SaddleOffset_BB_Nose   $newValue; return [get_Scalar $object $key] }
                                {SaddleNose_HB}                 {   bikeGeometry::set_Default_PersonalSaddleNose_HB  $newValue; return [get_Scalar $object $key] }
                                {Saddle_BB}                     {   bikeGeometry::set_Default_SaddleSeatTube_BB      $newValue; return [get_Scalar $object $key] }
                                {Saddle_HB_x}                   {   bikeGeometry::set_Default_SaddleOffset_HB_X      $newValue; return [get_Scalar $object $key] }
                                {Saddle_HB_y}                   {   bikeGeometry::set_Default_SaddleOffset_HB_Y      $newValue; return [get_Scalar $object $key] }
                                {Saddle_Offset_BB_ST}           {   bikeGeometry::set_Default_SaddleOffset_BB_ST     $newValue; return [get_Scalar $object $key] }
                                {SeatTube_Angle}                {   bikeGeometry::set_Default_SeatTubeDirection      $newValue; return [get_Scalar $object $key] }
                                
                                {Reach_Length}                  {   bikeGeometry::set_StackReach_HeadTubeReachLength    $newValue; return [get_Scalar $object $key] }
                                {Stack_Height}                  {   bikeGeometry::set_StackReach_HeadTubeStackHeight    $newValue; return [get_Scalar $object $key] }
                                
                                {SeatTube_Virtual}              {   bikeGeometry::set_Classic__SeatTubeVirtualLength    $newValue; return [get_Scalar $object $key] }
                                {TopTube_Virtual}               {   bikeGeometry::set_Classic_TopTubeVirtualLength      $newValue; return [get_Scalar $object $key] }

                                {BottomBracket_Angle_ChainStay} {   bikeGeometry::model_lugAngle::set_Angle ChainStaySeatTube $newValue; return [get_Scalar $object $key] }                     
                                {BottomBracket_Angle_DownTube}  {   bikeGeometry::model_lugAngle::set_Angle SeatTubeDownTube  $newValue; return [get_Scalar $object $key] }                     
                                {HeadLug_Angle_Bottom}          {   bikeGeometry::model_lugAngle::set_Angle HeadTubeDownTube  $newValue; return [get_Scalar $object $key] }                     
                                
                                default {}
                            }
                        }
                    RearWheel {
                            switch -exact $key {
                                {TyreShoulder}              {   bikeGeometry::set_Result_RearWheelTyreShoulder  $newValue; return [get_Scalar $object $key] }
                                
                                default {}              
                            }
                        }
                    Reference {
                            switch -exact $key {
                                {SaddleNose_HB}             {   bikeGeometry::set_Result_ReferenceSaddleNose_HB $newValue; return [get_Scalar $object $key] }
                                {SaddleNose_HB_y}           {   bikeGeometry::set_Result_ReferenceHeigth_SN_HB  $newValue; return [get_Scalar $object $key] }

                                default {}              
                            }
                        }
                    default {}
                }
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
    proc bikeGeometry::set_ListValue {key value} { 
            # -- check for existing parameter $Config($key)
        if {[catch {array get [namespace current]::set_ListValue $key} eID]} {
            puts "\n              <W> bikeGeometry::set_ListValue ... \$key not accepted! ... $key / $value\n"
            return {}
        }
            # -- set value to parameter
        set [namespace current]::ListValue($key) $value
        bikeGeometry::update_Geometry
            #
        set listValue  [lindex [array get [namespace current]::ListValue $key] 1]
        puts "              <I> bikeGeometry::set_ListValue ... $key -> $listValue"
            #
        return $listValue    
    }    
        #
    proc bikeGeometry::set_Component {key value} {
            # -- check for existing parameter $Config($key)
        if {[catch {array get [namespace current]::Config $key} eID]} {
            puts "\n              <W> bikeGeometry::set_Component ... \$key not accepted! ... $key / $value\n"
            return {}
        }
            # -- set value to parameter
        set [namespace current]::Component($key) $value
        bikeGeometry::update_Geometry
            #
        set componentValue  [bikeGeometry::get_Component $key]
        puts "              <I> bikeGeometry::set_Component ... $key -> $componentValue"
            #
        return $componentValue
            #
    }
        #
    proc bikeGeometry::set_Config {key value} {
            # -- check for existing parameter $Config($key)
        if {[catch {array get [namespace current]::Config $key} eID]} {
            puts "\n              <W> bikeGeometry::set_Config ... \$key not accepted! ... $key / $value\n"
            return {}
        }
            # -- set value to parameter
        set [namespace current]::Config($key) $value
        bikeGeometry::update_Geometry
            #
        set configValue [bikeGeometry::get_Config $key]
        puts "              <I> bikeGeometry::set_Config ... $key -> $configValue"
            #
        return $configValue
            #
    }  
        #
        #
    proc bikeGeometry::get_Scalar {object key} {
        set scalarValue [lindex [array get [namespace current]::$object $key] 1]
        return $scalarValue    
    }
        #
    proc bikeGeometry::get_ListValue {key} { 
        set listValue   [lindex [array get [namespace current]::ListValue $key] 1]
        return $listValue    
    }    
        #
    proc bikeGeometry::get_Component {key} {
        set compFile    [lindex [array get [namespace current]::Component $key] 1]
        return $compFile
    } 
        #
    proc bikeGeometry::get_Config {key} {
        set configValue [lindex [array get [namespace current]::Config $key] 1]
        return $configValue
    }  
        #
        #
    proc bikeGeometry::get_Polygon {key {centerPoint {0 0}}} {
        set polygon     [lindex [array get [namespace current]::Polygon $key] 1]
        return [ vectormath::addVectorPointList  $centerPoint  $polygon]
    }
        #
    proc bikeGeometry::get_Position {key {centerPoint {0 0}}} {
        set position     [lindex [array get [namespace current]::Position $key] 1]
        return [ vectormath::addVector  $centerPoint  $position]                        
    }
        #
    proc bikeGeometry::get_Direction {key {type {polar}}} {
        set direction     [lindex [array get [namespace current]::Direction $key] 1]
            #
        switch -exact $type {
            degree  {   return [vectormath::angle {1 0} {0 0} $direction] }
            rad    -
            polar  -
            default {   return $direction}
        }
    }
        #
    proc bikeGeometry::get_BoundingBox {key} {
        set boundingBox [lindex [array get [namespace current]::BoundingBox $key] 1]
        return $boundingBox
    }
        #
    proc bikeGeometry::get_CenterLine {key} {
        set centerLine  [lindex [array get [namespace current]::CenterLine $key] 1]
        return $centerLine
    }
        #
    proc bikeGeometry::get_TubeMiter {key} {
        set tubeMiter   [lindex [array get [namespace current]::TubeMiter $key] 1]
        return $tubeMiter
    }
        #
    proc bikeGeometry::get_TubeMiterDICT {} {
            #
        variable Direction
            #
        variable HeadTube
        variable SeatTube
        variable SeatStay
        variable TopTube
        variable DownTube
        variable TubeMiter
        variable BottomBracket
            #
        variable Result
            #
        
        set miterDict   [dict create    TopTube_Seat    {} \
                                        TopTube_Head    {} \
                                        DownTube_Head   {} \
                                        DownTube_Seat   {} \
                                        SeatTube_Down   {} \
                                        SeatStay_01     {} \
                                        SeatStay_02     {} \
                                        Reference       {} \
        ]

            #
        set key             TopTube_Seat
        set minorDiameter   $::bikeGeometry::TopTube(DiameterHT)                        
        set minorPerimeter  [expr $minorDiameter * $vectormath::CONST_PI]                        
            #
        dict set miterDict  $key    minorName         TopTube                          
        dict set miterDict  $key    minorDiameter     $minorDiameter                             
        dict set miterDict  $key    minorDirection    [get_Direction TopTube    degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         SeatTube                         
        dict set miterDict  $key    majorDiameter     $SeatTube(DiameterTT) 
        dict set miterDict  $key    majorDirection    [get_Direction SeatTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" 0]
        dict set miterDict  $key    polygon_01        [lindex [array get [namespace current]::TubeMiter $key] 1]  
            
            #
        set key             TopTube_Head
        set minorDiameter   $::bikeGeometry::TopTube(DiameterHT)                        
        set minorPerimeter  [expr $minorDiameter * $vectormath::CONST_PI]                        
            #
        dict set miterDict  $key    minorName         TopTube                          
        dict set miterDict  $key    minorDiameter     $minorDiameter                             
        dict set miterDict  $key    minorDirection    [get_Direction TopTube    degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         HeadTube                          
        dict set miterDict  $key    majorDiameter     $HeadTube(Diameter) 
        dict set miterDict  $key    majorDirection    [get_Direction HeadTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" 0]
        dict set miterDict  $key    polygon_01        [lindex [array get [namespace current]::TubeMiter $key] 1]  
            
            #
        set key     DownTube_Head
        set minorDiameter   $::bikeGeometry::DownTube(DiameterHT)                       
        set minorPerimeter  [expr $minorDiameter * $vectormath::CONST_PI]                        
            #
        dict set miterDict  $key    minorName         DownTube                         
        dict set miterDict  $key    minorDiameter     $minorDiameter                             
        dict set miterDict  $key    minorDirection    [get_Direction DownTube   degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         HeadTube                     
        dict set miterDict  $key    majorDiameter     $HeadTube(Diameter) 
        dict set miterDict  $key    majorDirection    [get_Direction HeadTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" 0]
        dict set miterDict  $key    polygon_01        [lindex [array get [namespace current]::TubeMiter $key] 1]  
                                    
            #
        set key     DownTube_Seat
        set minorDiameter   $::bikeGeometry::DownTube(DiameterBB)                        
        set minorPerimeter  [expr $minorDiameter * $vectormath::CONST_PI]                        
            #
        dict set miterDict  $key    minorName         DownTube                         
        dict set miterDict  $key    minorDiameter     $minorDiameter                             
        dict set miterDict  $key    minorDirection    [get_Direction DownTube   degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         SeatTube                     
        dict set miterDict  $key    majorDiameter     $SeatTube(DiameterBB) 
        dict set miterDict  $key    majorDirection    [get_Direction SeatTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" 0]
        dict set miterDict  $key    polygon_01        [lindex [array get [namespace current]::TubeMiter $key] 1]  
        dict set miterDict  $key    polygon_02        [lrange [lindex [array get [namespace current]::TubeMiter DownTube_BB_in]  1] 0 end-4] 
        dict set miterDict  $key    polygon_03        [lrange [lindex [array get [namespace current]::TubeMiter DownTube_BB_out] 1] 0 end-4] 
        dict set miterDict  $key    diameter_02       $BottomBracket(InsideDiameter)   
        dict set miterDict  $key    diameter_03       $BottomBracket(OutsideDiameter)   
        
            #
        set key             SeatTube_Down
        set minorDiameter   $::bikeGeometry::SeatTube(DiameterBB)                        
        set minorPerimeter  [expr $minorDiameter * $vectormath::CONST_PI]                        
            #
        dict set miterDict  $key    minorName         SeatTube                         
        dict set miterDict  $key    minorDiameter     $minorDiameter                            
        dict set miterDict  $key    minorDirection    [get_Direction SeatTube   degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         DownTube                     
        dict set miterDict  $key    majorDiameter     $DownTube(DiameterBB) 
        dict set miterDict  $key    majorDirection    [get_Direction DownTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" 0]
        dict set miterDict  $key    polygon_01        [lindex [array get [namespace current]::TubeMiter $key] 1]  
        dict set miterDict  $key    polygon_02        [lrange [lindex [array get [namespace current]::TubeMiter SeatTube_BB_in]  1] 0 end-4]  
        dict set miterDict  $key    polygon_03        [lrange [lindex [array get [namespace current]::TubeMiter SeatTube_BB_out] 1] 0 end-4]
        dict set miterDict  $key    diameter_02       $BottomBracket(InsideDiameter)   
        dict set miterDict  $key    diameter_03       $BottomBracket(OutsideDiameter)   
        
            #
        set key             SeatStay_01
        set minorDiameter   $::bikeGeometry::SeatStay(DiameterST)                        
        set minorPerimeter  [expr $minorDiameter * $vectormath::CONST_PI]                        
        set offset          [expr 0.5 * ($::bikeGeometry::SeatStay(SeatTubeMiterDiameter) - $::bikeGeometry::SeatStay(DiameterST))]
            #
            #
        dict set miterDict  $key    minorName         SeatStay                         
        dict set miterDict  $key    minorDiameter     $minorDiameter                             
        dict set miterDict  $key    minorDirection    [get_Direction SeatStay   degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         SeatTube(Lug)                     
        dict set miterDict  $key    majorDiameter     $::bikeGeometry::SeatStay(SeatTubeMiterDiameter) 
        dict set miterDict  $key    majorDirection    [get_Direction SeatTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" $offset]
        dict set miterDict  $key    polygon_01        [lindex [array get [namespace current]::TubeMiter $key] 1]  
        
            #
        set key     SeatStay_02
            #
        dict set miterDict  $key    minorName         SeatStay                         
        dict set miterDict  $key    minorDiameter     $minorDiameter                             
        dict set miterDict  $key    minorDirection    [get_Direction SeatStay   degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         SeatTube(Lug)                     
        dict set miterDict  $key    majorDiameter     $::bikeGeometry::SeatStay(SeatTubeMiterDiameter) 
        dict set miterDict  $key    majorDirection    [get_Direction SeatTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" $offset]
        dict set miterDict  $key    polygon_01        [lindex [array get [namespace current]::TubeMiter $key] 1]  
        
            #
        set key     Reference
            #
        dict set miterDict  $key    minorName         ReferenceWidth                         
        dict set miterDict  $key    majorName         ReferenceHeight                     
        dict set miterDict  $key    minorDiameter     0                             
        dict set miterDict  $key    minorDirection    0                        
        dict set miterDict  $key    minorPerimeter    100.00                        
        dict set miterDict  $key    majorDiameter     0 
        dict set miterDict  $key    majorDirection    1
        dict set miterDict  $key    offset            0.00                        
        dict set miterDict  $key    polygon_01        [lindex [array get [namespace current]::TubeMiter $key] 1]  
            
            #
            #           
        return $miterDict            
            #
    } 
        #
        #
        #
        #
    proc bikeGeometry::get_ComponentDir {} {
            #
        variable packageHomeDir
            #
        set componentDir [file normalize [file join $packageHomeDir  .. etc  components]]
            #
        return $componentDir
            #
    }
        #
    proc bikeGeometry::get_ComponentDirectories {} {
            #
        variable initDOM
            #
        set dirList {} 
            #
        set locationNode    [$initDOM selectNodes /root/Options/ComponentLocation]
            #
        foreach childNode [$locationNode childNodes ] {
            if {[$childNode nodeType] == {ELEMENT_NODE}} {
                set keyString  [$childNode getAttribute key {}]
                set dirString  [$childNode getAttribute dir {}]
                lappend dirList [list $keyString $dirString]
            }
        }            
            #
        return $dirList
            #
    }
    
        #
    proc bikeGeometry::get_ListBoxValues {} {    
            #
        variable initDOM
            #
        dict create dict_ListBoxValues {} 
            # variable valueRegistry
            # array set valueRegistry      {}
            #
        set optionNode    [$initDOM selectNodes /root/Options]
        foreach childNode [$optionNode childNodes ] {
            if {[$childNode nodeType] == {ELEMENT_NODE}} {
                    # puts "    init_ListBoxValues -> $childNode"
                set childNode_Name [$childNode nodeName]
                    # puts "    init_ListBoxValues -> $childNode_Name"
                    #
                    # set valueRegistry($childNode_Name) {}
                set nodeList {}
                    #
                foreach child_childNode [$childNode childNodes ] {
                    if {[$child_childNode nodeType] == {ELEMENT_NODE}} {
                          # puts "    ->$childNode_Name<"
                        switch -exact -- $childNode_Name {
                            {Rim} {
                                      # puts "    init_ListBoxValues (Rim) ->   $childNode_Name -> [$child_childNode nodeName]"
                                    set value_01 [$child_childNode getAttribute inch     {}]
                                    set value_02 [$child_childNode getAttribute metric   {}]
                                    set value_03 [$child_childNode getAttribute standard {}]
                                    if {$value_01 == {}} {
                                        set value {-----------------}
                                    } else {
                                        set value [format "%s ; %s %s" $value_02 $value_01 $value_03]
                                          # puts "   -> $value   <-> $value_02 $value_01 $value_03"
                                    }
                                        # lappend valueRegistry($childNode_Name)  $value
                                    lappend nodeList                        $value
                                }
                            {ComponentLocation} {}
                            default {
                                        # puts "    init_ListBoxValues (default) -> $childNode_Name -> [$child_childNode nodeName]"
                                    if {[string index [$child_childNode nodeName] 0 ] == {_}} continue
                                        # lappend valueRegistry($childNode_Name)  [$child_childNode nodeName]
                                    lappend nodeList                        [$child_childNode nodeName]
                                }
                        }
                    }
                }
                dict append dict_ListBoxValues $childNode_Name $nodeList
                
            }
        }
            #
            # puts "---"  
            #
        set forkNode    [$initDOM selectNodes /root/Fork]
        set childNode_Name   [$forkNode nodeName]
            # set valueRegistry($childNode_Name) {}
        set nodeList {}
        foreach child_childNode [$forkNode childNodes ] {
            if {[$childNode nodeType] == {ELEMENT_NODE}} {            
                            # puts "    init_ListBoxValues -> $childNode_Name -> [$child_childNode nodeName]"
                        if {[string index [$child_childNode nodeName] 0 ] == {_}} continue
                            # lappend valueRegistry($childNode_Name)  [$child_childNode nodeName]
                        lappend nodeList                        [$child_childNode nodeName]
            }
        }
        dict append dict_ListBoxValues $childNode_Name $nodeList        
            #
          
            # 
            # exit          
            # parray valueRegistry
            # project::pdict $dict_ListBoxValues
            # exit
            #
        return $dict_ListBoxValues
            #
    }    
        #
        #
    proc bikeGeometry::get_DebugGeometry {} {
        # http://stackoverflow.com/questions/9676651/converting-a-list-to-an-array
        set dict_Geometry [array get ::bikeGeometry::DEBUG_Geometry]
        return $dict_Geometry
    }
        #
    proc bikeGeometry::get_openSCADContent_removed {} {
        # set scadDict [bikeGeometry::geometry3D::get_scadContent]
        # return $scadDict
    }
        #
    #-------------------------------------------------------------------------
       #  check mathValue
    proc bikeGeometry::check_mathValue {value} {
                #
            puts "                  <1> bikeGeometry::check_mathValue $value"    
                # --- set new Value
            set newValue [ string map {, .} $value]
                # --- check Value --- ";" ... like in APPL_RimList
            if {[llength [split $newValue  ]] > 1} return {}
            if {[llength [split $newValue ;]] > 1} return {}
                #
            if { [catch { set newValue [expr 1.0 * $newValue] } errorID] } {
                puts "\n                <E> bikeGeometry::check_mathValue"
                foreach line [split ${errorID} \n] {
                    puts "           $line"
                }
                puts ""
                return {}
            }
                #
                #
            set newValue [format "%.3f" $newValue]
                #
            puts "                  <2> bikeGeometry::check_mathValue $value  ->  $newValue"
                #
            return $newValue
                #
    }
    #-------------------------------------------------------------------------
       #  trace/update Project
    proc bikeGeometry::trace_Project {varname key operation} {
            if {$key != ""} {
        	    set varname ${varname}($key)
        	}
            upvar $varname var
                # value is 889 (operation w)
                # value is 889 (operation r)
            puts "trace_Prototype: (operation: $operation) $varname is $var "
    }
    #-------------------------------------------------------------------------
        #  add vector to list of coordinates
    proc bikeGeometry::coords_flip_y {coordlist} {
            set returnList {}
            foreach {x y} $coordlist {
                set new_y [expr -$y]
                set returnList [lappend returnList $x $new_y]
            }
            return $returnList
    }

    #-------------------------------------------------------------------------
        #  get xy in a flat list of coordinates, start with    0, 1, 2, 3, ...
    proc bikeGeometry::coords_xy_index {coordlist index} {
            switch $index {
                {end} {
                      set index_y [expr [llength $coordlist] -1]
                      set index_x [expr [llength $coordlist] -2]
                    } 
                {end-1} {
                      set index_y [expr [llength $coordlist] -3]
                      set index_x [expr [llength $coordlist] -4]
                    }
                default {
                      set index_x [ expr 2 * $index ]
                      set index_y [ expr $index_x + 1 ]
                      if {$index_y > [llength $coordlist]} { return {0 0} }
                    }
            }
            return [list [lindex $coordlist $index_x] [lindex $coordlist $index_y] ]
    }
    
    #-------------------------------------------------------------------------
        # see  http://wiki.tcl.tk/440
        #
    proc bikeGeometry::flatten_nestedList { args } {
            if {[llength $args] == 0 } { return ""}
            set flatList {}
            foreach e [eval concat $args] {
                foreach ee $e { lappend flatList $ee }
            }
                # tk_messageBox -message "flatten_nestedList:\n    $args  -/- [llength $args] \n $flatList  -/- [llength $flatList]"
            return $flatList
    }
    #-------------------------------------------------------------------------
        #
    proc bikeGeometry::set_dictValue {dictPath dictValue args} {
            variable returnDict
                #
            puts "  ... set_dictValue"
            puts "      ... $dictPath  "
            #set command [format "dict set $returnDict %s \{%s\}"   $dictPath ${dictValue}]
			# set command [format "dict set projectDICT %s \{%s\}"   $dictPath ${dictValue}]
			    # puts "            ........ set value: $command"
			#{*}$command
            
            dict set returnDict $dictPath ${dictValue}
			    # dict set projectDICT Runtime ChainStay CenterLine angle_01 {-8.000}
			# return $dictionary
    }
    #-------------------------------------------------------------------------
        #
    proc bikeGeometry::get_dictValue {dictPath dictKey} {
            variable returnDict
              #
            set value "___undefined___"
           
            if { [catch {set value [dict get $returnDict {*}$dictPath $dictKey]} fid]} {
                puts "  <E> ... $fid"
                # exit
            } 
            return $value
    }


