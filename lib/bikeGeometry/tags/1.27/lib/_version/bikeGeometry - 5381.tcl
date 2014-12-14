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
 #           add bikeGeometry::update_Project to setter
 #
 # 1.xx refactor
 #          split project completely from bikeGeometry
 #          update   get_from_project
 #              and  set_to_project
 #
  
    package require tdom
        #
    package provide bikeGeometry 1.21
        #
    package require vectormath
        #
    namespace eval bikeGeometry {
        
            # --------------------------------------------
                # Export as global command
            variable packageHomeDir [file normalize [file join [pwd] [file dirname [info script]]] ]
            
            
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
            namespace export get_Value
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
            namespace export get_Object
            namespace export get_Polygon
            namespace export get_Position
            namespace export get_Direction
            namespace export get_BoundingBox
            namespace export get_TubeMiter
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
            namespace export set_Value
            namespace export set_resultParameter
                #
            # puts " Hallo!  ... [info command [namespace current]::*]" 
    }

    #-------------------------------------------------------------------------
        #  new Implementation
        #
        #  ... loads a new project given by a XML-Project as rootNode
        #
    proc bikeGeometry::_updateProjectNS {} {
            #
        bikeGeometry::geometry::_updateNamespace
            #
        bikeGeometry::frameTubes::headTube
            #
    }
        
        
    #-------------------------------------------------------------------------
        #  load newProject
        #
        #  ... loads a new project given by a XML-Project as rootNode
        #
    proc bikeGeometry::set_newProject {_projectDOM} {

            # --- report Fork Settings ------------------
                #                  
            set _forkDOM   [$project::initDOM selectNode Fork/_bikeGeometry_default_]  
            if {$_forkDOM != {}} {
                puts ""
                puts "        -- <W> ----------------------------------------------------"
                puts "           <W> bikeGeometry:"
                puts "           <W>       ...  using default Fork Settings"
                puts "           <W>         see -> \$bikeGeometry::initDOM /root/Fork"
                puts "           <W>"
                puts "" 
            }      
    
                     
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
            get_from_project
            
            
            # --- compute geometry ----------------------
                #
            bikeGeometry::update_Project
              
                
            # --- do required post updates --------------
                #
            foreach key [dict keys $postUpdate] {
                      # puts " -> $key"
                    set valueDict   [dict get $postUpdate $key]
                    foreach valueKey [dict keys $valueDict] {
                        puts "\n      -------------------------------"
                        set newValue [dict get $valueDict $valueKey]
                        puts "          postUpdate:   $key - $valueKey -> $newValue"
                        bikeGeometry::set_Value $key/$valueKey $newValue update
                    }
                        # project::pdict $valueDict
            }
            project::runTime_2_dom
    }

    #-------------------------------------------------------------------------
       #  import a subset of a project	
	proc bikeGeometry::import_ProjectSubset {nodeRoot} {
			project::import_ProjectSubset $nodeRoot
	}

    #-------------------------------------------------------------------------
        #  get current projectDOM as DOM Object
    proc bikeGeometry::get_projectDOM {} {
            return $project::projectDOM
    }

    #-------------------------------------------------------------------------
        #  get current projectDOM as Dictionary
    proc bikeGeometry::get_projectDICT {} {
            #   return $project::projectDICT
        set returnDict [dict create Component {}]
            #
            #
            #
        dict set returnDict Component   CrankSet                            $::bikeGeometry::Component(CrankSet)                            ;#[bikeGeometry::get_Component        CrankSet                          ]                ;# set _lastValue(Component/CrankSet/File)                                 
        dict set returnDict Component   ForkCrown                           $::bikeGeometry::Component(ForkCrown)                           ;#[bikeGeometry::get_Component        Fork CrownFile                    ]                ;# set _lastValue(Component/Fork/Crown/File)                               
        dict set returnDict Component   ForkDropout                         $::bikeGeometry::Component(ForkDropout)                         ;#[bikeGeometry::get_Component        Fork DropOutFile                  ]                ;# set _lastValue(Component/Fork/DropOut/File)                             
        dict set returnDict Component   FrontBrake                          $::bikeGeometry::Component(FrontBrake)                          ;#[bikeGeometry::get_Component        FrontBrake                        ]                ;# set _lastValue(Component/Brake/Front/File)                              
        dict set returnDict Component   FrontCarrier                        $::bikeGeometry::Component(FrontCarrier)                        ;#[bikeGeometry::get_Component        FrontCarrier                      ]                ;# set _lastValue(Component/Carrier/Front/File)                            
        dict set returnDict Component   FrontDerailleur                     $::bikeGeometry::Component(FrontDerailleur)                     ;#[bikeGeometry::get_Component        FrontDerailleur                   ]                ;# set _lastValue(Component/Derailleur/Front/File)                         
        dict set returnDict Component   HandleBar                           $::bikeGeometry::Component(HandleBar)                           ;#[bikeGeometry::get_Component        HandleBar                         ]                ;# set _lastValue(Component/HandleBar/File)                                
        dict set returnDict Component   Logo                                $::bikeGeometry::Component(Logo)                                ;#[bikeGeometry::get_Component        Logo                              ]                ;# set _lastValue(Component/Logo/File)                                     
        dict set returnDict Component   RearBrake                           $::bikeGeometry::Component(RearBrake)                           ;#[bikeGeometry::get_Component        RearBrake                         ]                ;# set _lastValue(Component/Brake/Rear/File)                               
        dict set returnDict Component   RearCarrier                         $::bikeGeometry::Component(RearCarrier)                         ;#[bikeGeometry::get_Component        RearCarrier                       ]                ;# set _lastValue(Component/Carrier/Rear/File)                             
        dict set returnDict Component   RearDerailleur                      $::bikeGeometry::Component(RearDerailleur)                      ;#[bikeGeometry::get_Component        RearDerailleur                    ]                ;# set _lastValue(Component/Derailleur/Rear/File)                          
        dict set returnDict Component   RearDropout                         $::bikeGeometry::Component(RearDropout)                         ;#[bikeGeometry::get_Component        RearDropout File                  ]                ;# set _lastValue(Lugs/RearDropOut/File)                                   
        dict set returnDict Component   RearHub                             $::bikeGeometry::Component(RearHub)
        dict set returnDict Component   Saddle                              $::bikeGeometry::Component(Saddle)                              ;#[bikeGeometry::get_Component        Saddle                            ]                ;# set _lastValue(Component/Saddle/File)                                   
        dict set returnDict Component   BottleCage_DownTube                 $::bikeGeometry::Component(BottleCage_DownTube)                                
        dict set returnDict Component   BottleCage_DownTube_Lower           $::bikeGeometry::Component(BottleCage_DownTube_Lower)                          
        dict set returnDict Component   BottleCage_SeatTube                 $::bikeGeometry::Component(BottleCage_SeatTube)                                
            #                           
        dict set returnDict Config      BottleCage_DownTube                 $::bikeGeometry::Config(BottleCage_DownTube)                    ;#[bikeGeometry::get_Config           BottleCage_DT                     ]                ;# set _lastValue(Rendering/BottleCage/DownTube)                           
        dict set returnDict Config      BottleCage_DownTube_Lower           $::bikeGeometry::Config(BottleCage_DownTube_Lower)              ;#[bikeGeometry::get_Config           BottleCage_DT_L                   ]                ;# set _lastValue(Rendering/BottleCage/DownTube_Lower)                     
        dict set returnDict Config      BottleCage_SeatTube                 $::bikeGeometry::Config(BottleCage_SeatTube)                    ;#[bikeGeometry::get_Config           BottleCage_ST                     ]                ;# set _lastValue(Rendering/BottleCage/SeatTube)                           
        dict set returnDict Config      ChainStay                           $::bikeGeometry::Config(ChainStay)                              ;#[bikeGeometry::get_Config           ChainStay                         ]                ;# set _lastValue(Rendering/ChainStay)                                     
        dict set returnDict Config      Fork                                $::bikeGeometry::Config(Fork)                                   ;#[bikeGeometry::get_Config           Fork                              ]                ;# set _lastValue(Rendering/Fork)                                          
        dict set returnDict Config      ForkBlade                           $::bikeGeometry::Config(ForkBlade)                              ;#[bikeGeometry::get_Config           ForkBlade                         ]                ;# set _lastValue(Rendering/ForkBlade)                                     
        dict set returnDict Config      ForkDropout                         $::bikeGeometry::Config(ForkDropout)                            ;#[bikeGeometry::get_Config           ForkDropout                       ]                ;# set _lastValue(Rendering/ForkDropOut)                                   
        dict set returnDict Config      FrontBrake                          $::bikeGeometry::Config(FrontBrake)                             ;#[bikeGeometry::get_Config           FrontBrake                        ]                ;# set _lastValue(Rendering/Brake/Front)                                   
        dict set returnDict Config      FrontFender                         $::bikeGeometry::Config(FrontFender)                            ;#[bikeGeometry::get_Config           FrontFender                       ]                ;# set _lastValue(Rendering/Fender/Front)                                  
        dict set returnDict Config      RearBrake                           $::bikeGeometry::Config(RearBrake)                              ;#[bikeGeometry::get_Config           RearBrake                         ]                ;# set _lastValue(Rendering/Brake/Rear)                                    
        dict set returnDict Config      RearDropout                         $::bikeGeometry::Config(RearDropout)                            ;#[bikeGeometry::get_Config           RearDropout                       ]                ;# set _lastValue(Rendering/RearDropOut)                                   
        dict set returnDict Config      RearDropoutOrient                   $::bikeGeometry::Config(RearDropoutOrient)                      ;#[bikeGeometry::get_Config           RearDropoutOrient                 ]                ;# set _lastValue(Lugs/RearDropOut/Direction)                              
        dict set returnDict Config      RearFender                          $::bikeGeometry::Config(RearFender)                             ;#[bikeGeometry::get_Config           RearFender                        ]                ;# set _lastValue(Rendering/Fender/Rear)                                   
            #                           
        dict set returnDict ListValue   CrankSetChainRings                  $::bikeGeometry::ListValue(CrankSetChainRings)                  ;#[bikeGeometry::get_Scalar           CrankSet ChainRings               ]                ;# set _lastValue(Component/CrankSet/ChainRings)                           
            #           
        dict set returnDict Scalar      BottleCage DownTube                 $::bikeGeometry::BottleCage(DownTube)                           ;#[bikeGeometry::get_Scalar           BottleCage DownTube               ]                ;# set _lastValue(Component/BottleCage/DownTube/OffsetBB)                  
        dict set returnDict Scalar      BottleCage DownTube_Lower           $::bikeGeometry::BottleCage(DownTube_Lower)                     ;#[bikeGeometry::get_Scalar           BottleCage DownTube_Lower         ]                ;# set _lastValue(Component/BottleCage/DownTube_Lower/OffsetBB)            
        dict set returnDict Scalar      BottleCage SeatTube                 $::bikeGeometry::BottleCage(SeatTube)                           ;#[bikeGeometry::get_Scalar           BottleCage SeatTube               ]                ;# set _lastValue(Component/BottleCage/SeatTube/OffsetBB)                  
        dict set returnDict Scalar      BottomBracket InsideDiameter        $::bikeGeometry::BottomBracket(InsideDiameter)                  ;#[bikeGeometry::get_Scalar           BottomBracket InsideDiameter      ]                ;# set _lastValue(Lugs/BottomBracket/Diameter/inside)                      
        dict set returnDict Scalar      BottomBracket OffsetCS_TopView      $::bikeGeometry::BottomBracket(OffsetCS_TopView)                ;#[bikeGeometry::get_Scalar           BottomBracket OffsetCS_TopView    ]                ;# set _lastValue(Lugs/BottomBracket/ChainStay/Offset_TopView)             
        dict set returnDict Scalar      BottomBracket OutsideDiameter       $::bikeGeometry::BottomBracket(OutsideDiameter)                 ;#[bikeGeometry::get_Scalar           BottomBracket OutsideDiameter     ]                ;# set _lastValue(Lugs/BottomBracket/Diameter/outside)                     
        dict set returnDict Scalar      BottomBracket Width                 $::bikeGeometry::BottomBracket(Width)                           ;#[bikeGeometry::get_Scalar           BottomBracket Width               ]                ;# set _lastValue(Lugs/BottomBracket/Width)                                
            #            
        dict set returnDict Scalar      ChainStay DiameterSS                $::bikeGeometry::ChainStay(DiameterSS)                          ;#[bikeGeometry::get_Scalar           ChainStay DiameterSS              ]                ;# set _lastValue(FrameTubes/ChainStay/DiameterSS)                         
        dict set returnDict Scalar      ChainStay Height                    $::bikeGeometry::ChainStay(Height)                              ;#[bikeGeometry::get_Scalar           ChainStay Height                  ]                ;# set _lastValue(FrameTubes/ChainStay/Height)                             
        dict set returnDict Scalar      ChainStay HeigthBB                  $::bikeGeometry::ChainStay(HeigthBB)                            ;#[bikeGeometry::get_Scalar           ChainStay HeigthBB                ]                ;# set _lastValue(FrameTubes/ChainStay/HeightBB)                           
        dict set returnDict Scalar      ChainStay TaperLength               $::bikeGeometry::ChainStay(TaperLength)                         ;#[bikeGeometry::get_Scalar           ChainStay TaperLength             ]                ;# set _lastValue(FrameTubes/ChainStay/TaperLength)                        
        dict set returnDict Scalar      ChainStay WidthBB                   $::bikeGeometry::ChainStay(WidthBB)                             ;#[bikeGeometry::get_Scalar           ChainStay WidthBB                 ]                ;# set _lastValue(FrameTubes/ChainStay/TaperLength)                        
        dict set returnDict Scalar      ChainStay completeLength            $::bikeGeometry::ChainStay(completeLength)                      ;#[bikeGeometry::get_Scalar           ChainStay completeLength          ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/completeLength)             
        dict set returnDict Scalar      ChainStay cuttingLeft               $::bikeGeometry::ChainStay(cuttingLeft)                         ;#[bikeGeometry::get_Scalar           ChainStay cuttingLeft             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/cuttingLeft)                
        dict set returnDict Scalar      ChainStay cuttingLength             $::bikeGeometry::ChainStay(cuttingLength)                       ;#[bikeGeometry::get_Scalar           ChainStay cuttingLength           ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/cuttingLength)              
        dict set returnDict Scalar      ChainStay profile_x01               $::bikeGeometry::ChainStay(profile_x01)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_x01             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/length_01)                  
        dict set returnDict Scalar      ChainStay profile_x02               $::bikeGeometry::ChainStay(profile_x02)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_x02             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/length_02)                  
        dict set returnDict Scalar      ChainStay profile_x03               $::bikeGeometry::ChainStay(profile_x03)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_x03             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/length_03)                  
        dict set returnDict Scalar      ChainStay profile_y00               $::bikeGeometry::ChainStay(profile_y00)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_y00             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/width_00)                   
        dict set returnDict Scalar      ChainStay profile_y01               $::bikeGeometry::ChainStay(profile_y01)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_y01             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/width_01)                   
        dict set returnDict Scalar      ChainStay profile_y02               $::bikeGeometry::ChainStay(profile_y02)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_y02             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/width_02)                   
        dict set returnDict Scalar      ChainStay segmentAngle_01           $::bikeGeometry::ChainStay(segmentAngle_01)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_01         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_01)                
        dict set returnDict Scalar      ChainStay segmentAngle_02           $::bikeGeometry::ChainStay(segmentAngle_02)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_02         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_02)                
        dict set returnDict Scalar      ChainStay segmentAngle_03           $::bikeGeometry::ChainStay(segmentAngle_03)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_03         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_03)                
        dict set returnDict Scalar      ChainStay segmentAngle_04           $::bikeGeometry::ChainStay(segmentAngle_04)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_04         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_04)                
        dict set returnDict Scalar      ChainStay segmentLength_01          $::bikeGeometry::ChainStay(segmentLength_01)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_01        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_01)               
        dict set returnDict Scalar      ChainStay segmentLength_02          $::bikeGeometry::ChainStay(segmentLength_02)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_02        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_02)               
        dict set returnDict Scalar      ChainStay segmentLength_03          $::bikeGeometry::ChainStay(segmentLength_03)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_03        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_03)               
        dict set returnDict Scalar      ChainStay segmentLength_04          $::bikeGeometry::ChainStay(segmentLength_04)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_04        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_04)               
        dict set returnDict Scalar      ChainStay segmentRadius_01          $::bikeGeometry::ChainStay(segmentRadius_01)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_01        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_01)               
        dict set returnDict Scalar      ChainStay segmentRadius_02          $::bikeGeometry::ChainStay(segmentRadius_02)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_02        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_02)               
        dict set returnDict Scalar      ChainStay segmentRadius_03          $::bikeGeometry::ChainStay(segmentRadius_03)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_03        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_03)               
        dict set returnDict Scalar      ChainStay segmentRadius_04          $::bikeGeometry::ChainStay(segmentRadius_04)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_04        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_04)               
            #            
        dict set returnDict Scalar      CrankSet ArmWidth                   $::bikeGeometry::CrankSet(ArmWidth)                             ;#[bikeGeometry::get_Scalar           CrankSet ArmWidth                 ]                ;# set _lastValue(Component/CrankSet/ArmWidth)                             
        dict set returnDict Scalar      CrankSet ChainLine                  $::bikeGeometry::CrankSet(ChainLine)                            ;#[bikeGeometry::get_Scalar           CrankSet ChainLine                ]                ;# set _lastValue(Component/CrankSet/ChainLine)                            
        dict set returnDict Scalar      CrankSet Length                     $::bikeGeometry::CrankSet(Length)                               ;#[bikeGeometry::get_Scalar           CrankSet Length                   ]                ;# set _lastValue(Component/CrankSet/Length)                               
        dict set returnDict Scalar      CrankSet PedalEye                   $::bikeGeometry::CrankSet(PedalEye)                             ;#[bikeGeometry::get_Scalar           CrankSet PedalEye                 ]                ;# set _lastValue(Component/CrankSet/PedalEye)                             
        dict set returnDict Scalar      CrankSet Q-Factor                   $::bikeGeometry::CrankSet(Q-Factor)                             ;#[bikeGeometry::get_Scalar           CrankSet Q-Factor                 ]                ;# set _lastValue(Component/CrankSet/Q-Factor)                             
        dict set returnDict Scalar      DownTube DiameterBB                 $::bikeGeometry::DownTube(DiameterBB)                           ;#[bikeGeometry::get_Scalar           DownTube DiameterBB               ]                ;# set _lastValue(FrameTubes/DownTube/DiameterBB)                          
        dict set returnDict Scalar      DownTube DiameterHT                 $::bikeGeometry::DownTube(DiameterHT)                           ;#[bikeGeometry::get_Scalar           DownTube DiameterHT               ]                ;# set _lastValue(FrameTubes/DownTube/DiameterHT)                          
        dict set returnDict Scalar      DownTube OffsetBB                   $::bikeGeometry::DownTube(OffsetBB)                             ;#[bikeGeometry::get_Scalar           DownTube OffsetBB                 ]                ;# set _lastValue(Custom/DownTube/OffsetBB)                                
        dict set returnDict Scalar      DownTube OffsetHT                   $::bikeGeometry::DownTube(OffsetHT)                             ;#[bikeGeometry::get_Scalar           DownTube OffsetHT                 ]                ;# set _lastValue(Custom/DownTube/OffsetHT)                                
        dict set returnDict Scalar      DownTube TaperLength                $::bikeGeometry::DownTube(TaperLength)                          ;#[bikeGeometry::get_Scalar           DownTube TaperLength              ]                ;# set _lastValue(FrameTubes/DownTube/TaperLength)                         
            #            
        dict set returnDict Scalar      Fork BladeBendRadius                $::bikeGeometry::Fork(BladeBendRadius)                          ;#[bikeGeometry::get_Scalar           Fork BladeBendRadius              ]                ;# set _lastValue(Component/Fork/Blade/BendRadius)                         
        dict set returnDict Scalar      Fork BladeDiameterDO                $::bikeGeometry::Fork(BladeDiameterDO)                          ;#[bikeGeometry::get_Scalar           Fork BladeDiameterDO              ]                ;# set _lastValue(Component/Fork/Blade/DiameterDO)                         
        dict set returnDict Scalar      Fork BladeEndLength                 $::bikeGeometry::Fork(BladeEndLength)                           ;#[bikeGeometry::get_Scalar           Fork BladeEndLength               ]                ;# set _lastValue(Component/Fork/Blade/EndLength)                          
        dict set returnDict Scalar      Fork BladeOffsetCrown               $::bikeGeometry::Fork(BladeOffsetCrown)                         ;#[bikeGeometry::get_Scalar           Fork BladeOffsetCrown             ]                ;# set _lastValue(Component/Fork/Crown/Blade/Offset)                       
        dict set returnDict Scalar      Fork BladeOffsetCrownPerp           $::bikeGeometry::Fork(BladeOffsetCrownPerp)                     ;#[bikeGeometry::get_Scalar           Fork BladeOffsetCrownPerp         ]                ;# set _lastValue(Component/Fork/Crown/Blade/OffsetPerp)                   
        dict set returnDict Scalar      Fork BladeOffsetDO                  $::bikeGeometry::Fork(BladeOffsetDO)                            ;#[bikeGeometry::get_Scalar           Fork BladeOffsetDO                ]                ;# set _lastValue(Component/Fork/DropOut/Offset)                           
        dict set returnDict Scalar      Fork BladeOffsetDOPerp              $::bikeGeometry::Fork(BladeOffsetDOPerp)                        ;#[bikeGeometry::get_Scalar           Fork BladeOffsetDOPerp            ]                ;# set _lastValue(Component/Fork/DropOut/OffsetPerp)                       
        dict set returnDict Scalar      Fork BladeTaperLength               $::bikeGeometry::Fork(BladeTaperLength)                         ;#[bikeGeometry::get_Scalar           Fork BladeTaperLength             ]                ;# set _lastValue(Component/Fork/Blade/TaperLength)                        
        dict set returnDict Scalar      Fork BladeWidth                     $::bikeGeometry::Fork(BladeWidth)                               ;#[bikeGeometry::get_Scalar           Fork BladeWidth                   ]                ;# set _lastValue(Component/Fork/Blade/Width)                              
        dict set returnDict Scalar      Fork BrakeAngle                     $::bikeGeometry::Fork(BrakeAngle)                               ;#[bikeGeometry::get_Scalar           Fork BrakeAngle                   ]                ;# set _lastValue(Component/Fork/Crown/Brake/Angle)                        
        dict set returnDict Scalar      Fork BrakeOffset                    $::bikeGeometry::Fork(BrakeOffset)                              ;#[bikeGeometry::get_Scalar           Fork BrakeOffset                  ]                ;# set _lastValue(Component/Fork/Crown/Brake/Offset)                       
        dict set returnDict Scalar      Fork Height                         $::bikeGeometry::Fork(Height)                                   ;#[bikeGeometry::get_Scalar           Fork Height                       ]                ;# set _lastValue(Component/Fork/Height)                                   
        dict set returnDict Scalar      Fork Rake                           $::bikeGeometry::Fork(Rake)                                     ;#[bikeGeometry::get_Scalar           Fork Rake                         ]                ;# set _lastValue(Component/Fork/Rake)                                     
            #            
        dict set returnDict Scalar      FrontBrake LeverLength              $::bikeGeometry::FrontBrake(LeverLength)                        ;#[bikeGeometry::get_Scalar           FrontBrake LeverLength            ]                ;# set _lastValue(Component/Brake/Front/LeverLength)                       
        dict set returnDict Scalar      FrontBrake Offset                   $::bikeGeometry::FrontBrake(Offset)                             ;#[bikeGeometry::get_Scalar           FrontBrake Offset                 ]                ;# set _lastValue(Component/Brake/Front/Offset)                            
        dict set returnDict Scalar      FrontCarrier x                      $::bikeGeometry::FrontCarrier(x)                                ;#[bikeGeometry::get_Scalar           FrontCarrier x                    ]                ;# set _lastValue(Component/Carrier/Front/x)                               
        dict set returnDict Scalar      FrontCarrier y                      $::bikeGeometry::FrontCarrier(y)                                ;#[bikeGeometry::get_Scalar           FrontCarrier y                    ]                ;# set _lastValue(Component/Carrier/Front/y)                               
        dict set returnDict Scalar      FrontDerailleur Distance            $::bikeGeometry::FrontDerailleur(Distance)                      ;#[bikeGeometry::get_Scalar           FrontDerailleur Distance          ]                ;# set _lastValue(Component/Derailleur/Front/Distance)                     
        dict set returnDict Scalar      FrontDerailleur Offset              $::bikeGeometry::FrontDerailleur(Offset)                        ;#[bikeGeometry::get_Scalar           FrontDerailleur Offset            ]                ;# set _lastValue(Component/Derailleur/Front/Offset)                       
        dict set returnDict Scalar      FrontFender Height                  $::bikeGeometry::FrontFender(Height)                            ;#[bikeGeometry::get_Scalar           FrontFender Height                ]                ;# set _lastValue(Component/Fender/Front/Height)                           
        dict set returnDict Scalar      FrontFender OffsetAngle             $::bikeGeometry::FrontFender(OffsetAngle)                       ;#[bikeGeometry::get_Scalar           FrontFender OffsetAngle           ]                ;# set _lastValue(Component/Fender/Front/OffsetAngle)                      
        dict set returnDict Scalar      FrontFender OffsetAngleFront        $::bikeGeometry::FrontFender(OffsetAngleFront)                  ;#[bikeGeometry::get_Scalar           FrontFender OffsetAngleFront      ]                ;# set _lastValue(Component/Fender/Front/OffsetAngleFront)                 
        dict set returnDict Scalar      FrontFender Radius                  $::bikeGeometry::FrontFender(Radius)                            ;#[bikeGeometry::get_Scalar           FrontFender Radius                ]                ;# set _lastValue(Component/Fender/Front/Radius)                           
        dict set returnDict Scalar      FrontWheel RimDiameter              $::bikeGeometry::FrontWheel(RimDiameter)                        ;#[bikeGeometry::get_Scalar           FrontWheel RimDiameter            ]                ;# set _lastValue(Component/Wheel/Front/RimDiameter)                       
        dict set returnDict Scalar      FrontWheel RimHeight                $::bikeGeometry::FrontWheel(RimHeight)                          ;#[bikeGeometry::get_Scalar           FrontWheel RimHeight              ]                ;# set _lastValue(Component/Wheel/Front/RimHeight)                         
        dict set returnDict Scalar      FrontWheel TyreHeight               $::bikeGeometry::FrontWheel(TyreHeight)                         ;#[bikeGeometry::get_Scalar           FrontWheel TyreHeight             ]                ;# set _lastValue(Component/Wheel/Front/TyreHeight)                        
            #            
        dict set returnDict Scalar      Geometry BottomBracket_Depth        $::bikeGeometry::Geometry(BottomBracket_Depth)                  ;#[bikeGeometry::get_Scalar           Geometry BottomBracket_Depth      ]                ;# set _lastValue(Custom/BottomBracket/Depth)                              
        dict set returnDict Scalar      Geometry BottomBracket_Height       $::bikeGeometry::Geometry(BottomBracket_Height)                 ;#[bikeGeometry::get_Scalar           Geometry BottomBracket_Height     ]                ;# set _lastValue(Result/Length/BottomBracket/Height)                      
        dict set returnDict Scalar      Geometry ChainStay_Length           $::bikeGeometry::Geometry(ChainStay_Length)                     ;#[bikeGeometry::get_Scalar           Geometry ChainStay_Length         ]                ;# set _lastValue(Custom/WheelPosition/Rear)                               
        dict set returnDict Scalar      Geometry FrontWheel_Radius          $::bikeGeometry::Geometry(FrontWheel_Radius)                    ;#[bikeGeometry::get_Scalar           Geometry FrontWheel_Radius        ]                ;# set _lastValue(Result/Length/FrontWheel/Radius)                         
        dict set returnDict Scalar      Geometry FrontWheel_x               $::bikeGeometry::Geometry(FrontWheel_x)                         ;#[bikeGeometry::get_Scalar           Geometry FrontWheel_x             ]                ;# set _lastValue(Result/Length/FrontWheel/horizontal)                     
        dict set returnDict Scalar      Geometry FrontWheel_xy              $::bikeGeometry::Geometry(FrontWheel_xy)                        ;#[bikeGeometry::get_Scalar           Geometry FrontWheel_xy            ]                ;# set _lastValue(Result/Length/FrontWheel/diagonal)                       
        dict set returnDict Scalar      Geometry HandleBar_Distance         $::bikeGeometry::Geometry(HandleBar_Distance)                   ;#[bikeGeometry::get_Scalar           Geometry HandleBar_Distance       ]                ;# set _lastValue(Personal/HandleBar_Distance)                             
        dict set returnDict Scalar      Geometry HandleBar_Height           $::bikeGeometry::Geometry(HandleBar_Height)                     ;#[bikeGeometry::get_Scalar           Geometry HandleBar_Height         ]                ;# set _lastValue(Personal/HandleBar_Height)                               
        dict set returnDict Scalar      Geometry HeadTube_Angle             $::bikeGeometry::Geometry(HeadTube_Angle)                       ;#[bikeGeometry::get_Scalar           Geometry HeadTube_Angle           ]                ;# set _lastValue(Custom/HeadTube/Angle)                                   
        dict set returnDict Scalar      Geometry Inseam_Length              $::bikeGeometry::Geometry(Inseam_Length)                        ;#[bikeGeometry::get_Scalar           Geometry Inseam_Length            ]                ;# set _lastValue(Personal/InnerLeg_Length)                                
        dict set returnDict Scalar      Geometry Reach_Length               $::bikeGeometry::Geometry(Reach_Length)                         ;#[bikeGeometry::get_Scalar           Geometry ReachLengthResult        ]                ;# set _lastValue(Result/Length/HeadTube/ReachLength)                      
        dict set returnDict Scalar      Geometry RearWheel_Radius           $::bikeGeometry::Geometry(RearWheel_Radius)                     ;#[bikeGeometry::get_Scalar           Geometry RearWheel_Radius         ]                ;# set _lastValue(Result/Length/RearWheel/Radius)                          
        dict set returnDict Scalar      Geometry RearWheel_x                $::bikeGeometry::Geometry(RearWheel_x)                          ;#[bikeGeometry::get_Scalar           Geometry RearWheel_x              ]                ;# set _lastValue(Result/Length/RearWheel/horizontal)                      
        dict set returnDict Scalar      Geometry SaddleNose_BB_x            $::bikeGeometry::Geometry(SaddleNose_BB_x)                      ;#[bikeGeometry::get_Scalar           Geometry SaddleNose_BB_x          ]                ;# set _lastValue(Result/Length/Saddle/Offset_BB_Nose)                     
        dict set returnDict Scalar      Geometry SaddleNose_HB              $::bikeGeometry::Geometry(SaddleNose_HB)                        ;#[bikeGeometry::get_Scalar           Geometry SaddleNose_HB            ]                ;# set _lastValue(Result/Length/Personal/SaddleNose_HB)                    
        dict set returnDict Scalar      Geometry Saddle_BB                  $::bikeGeometry::Geometry(Saddle_BB)                            ;#[bikeGeometry::get_Scalar           Geometry Saddle_BB                ]                ;# set _lastValue(Result/Length/Saddle/SeatTube_BB)                        
        dict set returnDict Scalar      Geometry Saddle_Distance            $::bikeGeometry::Geometry(Saddle_Distance)                      ;#[bikeGeometry::get_Scalar           Geometry Saddle_Distance          ]                ;# set _lastValue(Personal/Saddle_Distance)                                
        dict set returnDict Scalar      Geometry Saddle_HB_y                $::bikeGeometry::Geometry(Saddle_HB_y)                          ;#[bikeGeometry::get_Scalar           Geometry Saddle_HB_y              ]                ;# set _lastValue(Result/Length/Saddle/Offset_HB)                          
        dict set returnDict Scalar      Geometry Saddle_Offset_BB_ST        $::bikeGeometry::Geometry(Saddle_Offset_BB_ST)                  ;#[bikeGeometry::get_Scalar           Geometry Saddle_Offset_BB_ST      ]                ;# set _lastValue(Result/Length/Saddle/Offset_BB_ST)                       
        dict set returnDict Scalar      Geometry SeatTube_Virtual           $::bikeGeometry::Geometry(SeatTube_Virtual)                     ;#[bikeGeometry::get_Scalar           Geometry SeatTubeVirtual          ]                ;# set _lastValue(Result/Length/SeatTube/VirtualLength)                    
        dict set returnDict Scalar      Geometry Stack_Height               $::bikeGeometry::Geometry(Stack_Height)                         ;#[bikeGeometry::get_Scalar           Geometry StackHeightResult        ]                ;# set _lastValue(Result/Length/HeadTube/StackHeight)                      
        dict set returnDict Scalar      Geometry Stem_Angle                 $::bikeGeometry::Geometry(Stem_Angle)                           ;#[bikeGeometry::get_Scalar           Geometry Stem_Angle               ]                ;# set _lastValue(Component/Stem/Angle)                                    
        dict set returnDict Scalar      Geometry Stem_Length                $::bikeGeometry::Geometry(Stem_Length)                          ;#[bikeGeometry::get_Scalar           Geometry Stem_Length              ]                ;# set _lastValue(Component/Stem/Length)                                   
        dict set returnDict Scalar      Geometry TopTube_Virtual            $::bikeGeometry::Geometry(TopTube_Virtual)                      ;#[bikeGeometry::get_Scalar           Geometry TopTubeVirtual           ]                ;# set _lastValue(Result/Length/TopTube/VirtualLength)                     
        dict set returnDict Scalar      Geometry TopTube_Angle              $::bikeGeometry::Geometry(TopTube_Angle)                        ;#[bikeGeometry::get_Scalar           Geometry TopTube_Angle            ]                ;# set _lastValue(Custom/TopTube/Angle)                                    
        dict set returnDict Scalar      Geometry SeatTube_Angle             $::bikeGeometry::Geometry(SeatTube_Angle)                       ;#[bikeGeometry::get_Scalar           SeatTube Angle                    ]                ;# set _lastValue(Result/Angle/SeatTube/Direction)                         
            #            
        dict set returnDict Scalar      Geometry HeadLugTop_Angle           $::bikeGeometry::Geometry(HeadLugTop_Angle)                     ;#[bikeGeometry::get_Scalar           Result Angle_HeadTubeTopTube      ]                ;# set _lastValue(Result/Angle/HeadTube/TopTube)                           
            #
        dict set returnDict Scalar      HandleBar PivotAngle                $::bikeGeometry::HandleBar(PivotAngle)                          ;#[bikeGeometry::get_Scalar           HandleBar PivotAngle              ]                ;# set _lastValue(Component/HandleBar/PivotAngle)                          
        dict set returnDict Scalar      HeadSet Diameter                    $::bikeGeometry::HeadSet(Diameter)                              ;#[bikeGeometry::get_Scalar           HeadSet Diameter                  ]                ;# set _lastValue(Component/HeadSet/Diameter)                              
        dict set returnDict Scalar      HeadSet Height_Bottom               $::bikeGeometry::HeadSet(Height_Bottom)                         ;#[bikeGeometry::get_Scalar           HeadSet Height_Bottom             ]                ;# set _lastValue(Component/HeadSet/Height/Bottom)                         
        dict set returnDict Scalar      HeadSet Height_Top                  $::bikeGeometry::HeadSet(Height_Top)                            ;#[bikeGeometry::get_Scalar           HeadSet Height_Top                ]                ;# set _lastValue(Component/HeadSet/Height/Top)                            
        dict set returnDict Scalar      HeadTube Diameter                   $::bikeGeometry::HeadTube(Diameter)                             ;#[bikeGeometry::get_Scalar           HeadTube Diameter                 ]                ;# set _lastValue(FrameTubes/HeadTube/Diameter)                            
        dict set returnDict Scalar      HeadTube Length                     $::bikeGeometry::HeadTube(Length)                               ;#[bikeGeometry::get_Scalar           HeadTube Length                   ]                ;# set _lastValue(FrameTubes/HeadTube/Length)                              
            #            
        dict set returnDict Scalar      Lugs BottomBracket_ChainStay_Angle      $::bikeGeometry::Lugs(BottomBracket_ChainStay_Angle)        ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_ChainStay_Angle        ]        ;# set _lastValue(Lugs/BottomBracket/ChainStay/Angle/value)                
        dict set returnDict Scalar      Lugs BottomBracket_ChainStay_Tolerance  $::bikeGeometry::Lugs(BottomBracket_ChainStay_Tolerance)    ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_ChainStay_Tolerance    ]        ;# set _lastValue(Lugs/BottomBracket/ChainStay/Angle/plus_minus)           
        dict set returnDict Scalar      Lugs BottomBracket_DownTube_Angle       $::bikeGeometry::Lugs(BottomBracket_DownTube_Angle)         ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_DownTube_Angle         ]        ;# set _lastValue(Lugs/BottomBracket/DownTube/Angle/value)                 
        dict set returnDict Scalar      Lugs BottomBracket_DownTube_Tolerance   $::bikeGeometry::Lugs(BottomBracket_DownTube_Tolerance)     ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_DownTube_Tolerance     ]        ;# set _lastValue(Lugs/BottomBracket/DownTube/Angle/plus_minus)            
        dict set returnDict Scalar      Lugs HeadLug_Bottom_Angle               $::bikeGeometry::Lugs(HeadLug_Bottom_Angle)                 ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Bottom_Angle         ]                ;# set _lastValue(Lugs/HeadTube/DownTube/Angle/value)                      
        dict set returnDict Scalar      Lugs HeadLug_Bottom_Tolerance           $::bikeGeometry::Lugs(HeadLug_Bottom_Tolerance)             ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Bottom_Tolerance     ]                ;# set _lastValue(Lugs/HeadTube/DownTube/Angle/plus_minus)                 
        dict set returnDict Scalar      Lugs HeadLug_Top_Angle                  $::bikeGeometry::Lugs(HeadLug_Top_Angle)                    ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Top_Angle            ]                ;# set _lastValue(Lugs/HeadTube/TopTube/Angle/value)                       
        dict set returnDict Scalar      Lugs HeadLug_Top_Tolerance              $::bikeGeometry::Lugs(HeadLug_Top_Tolerance)                ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Top_Tolerance        ]                ;# set _lastValue(Lugs/HeadTube/TopTube/Angle/plus_minus)                  
        dict set returnDict Scalar      Lugs RearDropOut_Angle                  $::bikeGeometry::Lugs(RearDropOut_Angle)                    ;#[bikeGeometry::get_Scalar           Lugs RearDropOut_Angle            ]                ;# set _lastValue(Lugs/RearDropOut/Angle/value)                            
        dict set returnDict Scalar      Lugs RearDropOut_Tolerance              $::bikeGeometry::Lugs(RearDropOut_Tolerance)                ;#[bikeGeometry::get_Scalar           Lugs RearDropOut_Tolerance        ]                ;# set _lastValue(Lugs/RearDropOut/Angle/plus_minus)                       
        dict set returnDict Scalar      Lugs SeatLug_SeatStay_Angle             $::bikeGeometry::Lugs(SeatLug_SeatStay_Angle)               ;#[bikeGeometry::get_Scalar           Lugs SeatLug_SeatStay_Angle       ]                ;# set _lastValue(Lugs/SeatTube/SeatStay/Angle/value)                      
        dict set returnDict Scalar      Lugs SeatLug_SeatStay_Tolerance         $::bikeGeometry::Lugs(SeatLug_SeatStay_Tolerance)           ;#[bikeGeometry::get_Scalar           Lugs SeatLug_SeatStay_Tolerance   ]                ;# set _lastValue(Lugs/SeatTube/SeatStay/Angle/plus_minus)                 
        dict set returnDict Scalar      Lugs SeatLug_TopTube_Angle              $::bikeGeometry::Lugs(SeatLug_TopTube_Angle)                ;#[bikeGeometry::get_Scalar           Lugs SeatLug_TopTube_Angle        ]                ;# set _lastValue(Lugs/SeatTube/TopTube/Angle/value)                       
        dict set returnDict Scalar      Lugs SeatLug_TopTube_Tolerance          $::bikeGeometry::Lugs(SeatLug_TopTube_Tolerance)            ;#[bikeGeometry::get_Scalar           Lugs SeatLug_TopTube_Tolerance    ]                ;# set _lastValue(Lugs/SeatTube/TopTube/Angle/plus_minus)                  
            #            
        dict set returnDict Scalar      RearBrake   LeverLength                 $::bikeGeometry::RearBrake(LeverLength)                     ;#[bikeGeometry::get_Scalar           RearBrake LeverLength             ]                ;# set _lastValue(Component/Brake/Rear/LeverLength)                        
        dict set returnDict Scalar      RearBrake   Offset                      $::bikeGeometry::RearBrake(Offset)                          ;#[bikeGeometry::get_Scalar           RearBrake Offset                  ]                ;# set _lastValue(Component/Brake/Rear/Offset)                             
        dict set returnDict Scalar      RearCarrier x                           $::bikeGeometry::RearCarrier(x)                             ;#[bikeGeometry::get_Scalar           RearCarrier x                     ]                ;# set _lastValue(Component/Carrier/Rear/x)                                
        dict set returnDict Scalar      RearCarrier y                           $::bikeGeometry::RearCarrier(y)                             ;#[bikeGeometry::get_Scalar           RearCarrier y                     ]                ;# set _lastValue(Component/Carrier/Rear/y)                                
        dict set returnDict Scalar      RearDerailleur Pulley_teeth             $::bikeGeometry::RearDerailleur(Pulley_teeth)               ;#[bikeGeometry::get_Scalar           RearDerailleur Pulley_teeth       ]                ;# set _lastValue(Component/Derailleur/Rear/Pulley/teeth)                  
        dict set returnDict Scalar      RearDerailleur Pulley_x                 $::bikeGeometry::RearDerailleur(Pulley_x)                   ;#[bikeGeometry::get_Scalar           RearDerailleur Pulley_x           ]                ;# set _lastValue(Component/Derailleur/Rear/Pulley/x)                      
        dict set returnDict Scalar      RearDerailleur Pulley_y                 $::bikeGeometry::RearDerailleur(Pulley_y)                   ;#[bikeGeometry::get_Scalar           RearDerailleur Pulley_y           ]                ;# set _lastValue(Component/Derailleur/Rear/Pulley/y)                      
            #            
        dict set returnDict Scalar      RearDropout Derailleur_x                $::bikeGeometry::RearDropout(Derailleur_x)                  ;#[bikeGeometry::get_Scalar           RearDropout Derailleur_x          ]                ;# set _lastValue(Lugs/RearDropOut/Derailleur/x)                           
        dict set returnDict Scalar      RearDropout Derailleur_y                $::bikeGeometry::RearDropout(Derailleur_y)                  ;#[bikeGeometry::get_Scalar           RearDropout Derailleur_y          ]                ;# set _lastValue(Lugs/RearDropOut/Derailleur/y)                           
        dict set returnDict Scalar      RearDropout OffsetCS                    $::bikeGeometry::RearDropout(OffsetCS)                      ;#[bikeGeometry::get_Scalar           RearDropout OffsetCS              ]                ;# set _lastValue(Lugs/RearDropOut/ChainStay/Offset)                       
        dict set returnDict Scalar      RearDropout OffsetCSPerp                $::bikeGeometry::RearDropout(OffsetCSPerp)                  ;#[bikeGeometry::get_Scalar           RearDropout OffsetCSPerp          ]                ;# set _lastValue(Lugs/RearDropOut/ChainStay/OffsetPerp)                   
        dict set returnDict Scalar      RearDropout OffsetCS_TopView            $::bikeGeometry::RearDropout(OffsetCS_TopView)              ;#[bikeGeometry::get_Scalar           RearDropout OffsetCS_TopView      ]                ;# set _lastValue(Lugs/RearDropOut/ChainStay/Offset_TopView)               
        dict set returnDict Scalar      RearDropout OffsetSS                    $::bikeGeometry::RearDropout(OffsetSS)                      ;#[bikeGeometry::get_Scalar           RearDropout OffsetSS              ]                ;# set _lastValue(Lugs/RearDropOut/SeatStay/Offset)                        
        dict set returnDict Scalar      RearDropout OffsetSSPerp                $::bikeGeometry::RearDropout(OffsetSSPerp)                  ;#[bikeGeometry::get_Scalar           RearDropout OffsetSSPerp          ]                ;# set _lastValue(Lugs/RearDropOut/SeatStay/OffsetPerp)                    
        dict set returnDict Scalar      RearDropout RotationOffset              $::bikeGeometry::RearDropout(RotationOffset)                ;#[bikeGeometry::get_Scalar           RearDropout RotationOffset        ]                ;# set _lastValue(Lugs/RearDropOut/RotationOffset)                         
            #            
        dict set returnDict Scalar      RearFender  Height                      $::bikeGeometry::RearFender(Height)                         ;#[bikeGeometry::get_Scalar           RearFender Height                 ]                ;# set _lastValue(Component/Fender/Rear/Height)                            
        dict set returnDict Scalar      RearFender  OffsetAngle                 $::bikeGeometry::RearFender(OffsetAngle)                    ;#[bikeGeometry::get_Scalar           RearFender OffsetAngle            ]                ;# set _lastValue(Component/Fender/Rear/OffsetAngle)                       
        dict set returnDict Scalar      RearFender  Radius                      $::bikeGeometry::RearFender(Radius)                         ;#[bikeGeometry::get_Scalar           RearFender Radius                 ]                ;# set _lastValue(Component/Fender/Rear/Radius)                            
        dict set returnDict Scalar      RearMockup  CassetteClearance           $::bikeGeometry::RearMockup(CassetteClearance)              ;#[bikeGeometry::get_Scalar           RearMockup CassetteClearance      ]                ;# set _lastValue(Rendering/RearMockup/CassetteClearance)                  
        dict set returnDict Scalar      RearMockup  ChainWheelClearance         $::bikeGeometry::RearMockup(ChainWheelClearance)            ;#[bikeGeometry::get_Scalar           RearMockup ChainWheelClearance    ]                ;# set _lastValue(Rendering/RearMockup/ChainWheelClearance)                
        dict set returnDict Scalar      RearMockup  CrankClearance              $::bikeGeometry::RearMockup(CrankClearance)                 ;#[bikeGeometry::get_Scalar           RearMockup CrankClearance         ]                ;# set _lastValue(Rendering/RearMockup/CrankClearance)                     
        dict set returnDict Scalar      RearMockup  DiscClearance               $::bikeGeometry::RearMockup(DiscClearance)                  ;#[bikeGeometry::get_Scalar           RearMockup DiscClearance          ]                ;# set _lastValue(Rendering/RearMockup/DiscClearance)                      
        dict set returnDict Scalar      RearMockup  DiscDiameter                $::bikeGeometry::RearMockup(DiscDiameter)                   ;#[bikeGeometry::get_Scalar           RearMockup DiscDiameter           ]                ;# set _lastValue(Rendering/RearMockup/DiscDiameter)                       
        dict set returnDict Scalar      RearMockup  DiscOffset                  $::bikeGeometry::RearMockup(DiscOffset)                     ;#[bikeGeometry::get_Scalar           RearMockup DiscOffset             ]                ;# set _lastValue(Rendering/RearMockup/DiscOffset)                         
        dict set returnDict Scalar      RearMockup  DiscWidth                   $::bikeGeometry::RearMockup(DiscWidth)                      ;#[bikeGeometry::get_Scalar           RearMockup DiscWidth              ]                ;# set _lastValue(Rendering/RearMockup/DiscWidth)                          
        dict set returnDict Scalar      RearMockup  TyreClearance               $::bikeGeometry::RearMockup(TyreClearance)                  ;#[bikeGeometry::get_Scalar           RearMockup TyreClearance          ]                ;# set _lastValue(Rendering/RearMockup/TyreClearance)                      
            #            
        dict set returnDict Scalar      RearWheel   FirstSprocket               $::bikeGeometry::RearWheel(FirstSprocket)                   ;#[bikeGeometry::get_Scalar           RearWheel FirstSprocket           ]                ;# set _lastValue(Component/Wheel/Rear/FirstSprocket)                      
        dict set returnDict Scalar      RearWheel   HubWidth                    $::bikeGeometry::RearWheel(HubWidth)                        ;#[bikeGeometry::get_Scalar           RearWheel HubWidth                ]                ;# set _lastValue(Component/Wheel/Rear/HubWidth)                           
        dict set returnDict Scalar      RearWheel   RimDiameter                 $::bikeGeometry::RearWheel(RimDiameter)                     ;#[bikeGeometry::get_Scalar           RearWheel RimDiameter             ]                ;# set _lastValue(Component/Wheel/Rear/RimDiameter)                        
        dict set returnDict Scalar      RearWheel   RimHeight                   $::bikeGeometry::RearWheel(RimHeight)                       ;#[bikeGeometry::get_Scalar           RearWheel RimHeight               ]                ;# set _lastValue(Component/Wheel/Rear/RimHeight)                          
        dict set returnDict Scalar      RearWheel   TyreHeight                  $::bikeGeometry::RearWheel(TyreHeight)                      ;#[bikeGeometry::get_Scalar           RearWheel TyreHeight              ]                ;# set _lastValue(Component/Wheel/Rear/TyreHeight)                         
        dict set returnDict Scalar      RearWheel   TyreShoulder                $::bikeGeometry::RearWheel(TyreShoulder)                    ;#[bikeGeometry::get_Scalar           RearWheel TyreShoulder            ]                ;# set _lastValue(Result/Length/RearWheel/TyreShoulder)                    
        dict set returnDict Scalar      RearWheel   TyreWidth                   $::bikeGeometry::RearWheel(TyreWidth)                       ;#[bikeGeometry::get_Scalar           RearWheel TyreWidth               ]                ;# set _lastValue(Component/Wheel/Rear/TyreWidth)                          
        dict set returnDict Scalar      RearWheel   TyreWidthRadius             $::bikeGeometry::RearWheel(TyreWidthRadius)                 ;#[bikeGeometry::get_Scalar           RearWheel TyreWidthRadius         ]                ;# set _lastValue(Component/Wheel/Rear/TyreWidthRadius)                    
            #            
        dict set returnDict Scalar      Reference   HandleBar_Distance          $::bikeGeometry::Reference(HandleBar_Distance)              ;#[bikeGeometry::get_Scalar           Reference HandleBar_Distance      ]                ;# set _lastValue(Reference/HandleBar_Distance)                            
        dict set returnDict Scalar      Reference   HandleBar_Height            $::bikeGeometry::Reference(HandleBar_Height)                ;#[bikeGeometry::get_Scalar           Reference HandleBar_Height        ]                ;# set _lastValue(Reference/HandleBar_Height)                              
        dict set returnDict Scalar      Reference   SaddleNose_Distance         $::bikeGeometry::Reference(SaddleNose_Distance)             ;#[bikeGeometry::get_Scalar           Reference SaddleNose_Distance     ]                ;# set _lastValue(Reference/SaddleNose_Distance)                           
        dict set returnDict Scalar      Reference   SaddleNose_HB               $::bikeGeometry::Reference(SaddleNose_HB)                   ;#[bikeGeometry::get_Scalar           Reference SaddleNose_HB           ]                ;# set _lastValue(Result/Length/Reference/SaddleNose_HB)                   
        dict set returnDict Scalar      Reference   SaddleNose_HB_y             $::bikeGeometry::Reference(SaddleNose_HB_y)                 ;#[bikeGeometry::get_Scalar           Reference SaddleNose_HB_y         ]                ;# set _lastValue(Result/Length/Reference/Heigth_SN_HB)                    
        dict set returnDict Scalar      Reference   SaddleNose_Height           $::bikeGeometry::Reference(SaddleNose_Height)               ;#[bikeGeometry::get_Scalar           Reference SaddleNose_Height       ]                ;# set _lastValue(Reference/SaddleNose_Height)                             
            #            
        dict set returnDict Scalar      Saddle      Height                      $::bikeGeometry::Saddle(Height)                             ;#[bikeGeometry::get_Scalar           Saddle Height                     ]                ;# set _lastValue(Personal/Saddle_Height)                                  
        dict set returnDict Scalar      Saddle      NoseLength                  $::bikeGeometry::Saddle(NoseLength)                         ;#[bikeGeometry::get_Scalar           Saddle NoseLength                 ]                ;# set _lastValue(Component/Saddle/LengthNose)     
        dict set returnDict Scalar      Saddle      Offset_x                    $::bikeGeometry::Saddle(Offset_x)                           ;#[bikeGeometry::get_Scalar           Saddle Offset_x                   ]                ;# set _lastValue(Rendering/Saddle/Offset_X)                               
        dict set returnDict Scalar      Saddle      Offset_y                    $::bikeGeometry::Saddle(Offset_y)                           ;#[bikeGeometry::get_Scalar           Saddle Offset_y                   ]                ;# set _lastValue(Rendering/Saddle/Offset_Y)                                                     
            #            
        dict set returnDict Scalar      SeatPost    Diameter                    $::bikeGeometry::SeatPost(Diameter)                         ;#[bikeGeometry::get_Scalar           SeatPost Diameter                 ]                ;# set _lastValue(Component/SeatPost/Diameter)                             
        dict set returnDict Scalar      SeatPost    PivotOffset                 $::bikeGeometry::SeatPost(PivotOffset)                      ;#[bikeGeometry::get_Scalar           SeatPost PivotOffset              ]                ;# set _lastValue(Component/SeatPost/PivotOffset)                          
        dict set returnDict Scalar      SeatPost    Setback                     $::bikeGeometry::SeatPost(Setback)                          ;#[bikeGeometry::get_Scalar           SeatPost Setback                  ]                ;# set _lastValue(Component/SeatPost/Setback)                              
        dict set returnDict Scalar      SeatStay    DiameterCS                  $::bikeGeometry::SeatStay(DiameterCS)                       ;#[bikeGeometry::get_Scalar           SeatStay DiameterCS               ]                ;# set _lastValue(FrameTubes/SeatStay/DiameterCS)                          
        dict set returnDict Scalar      SeatStay    DiameterST                  $::bikeGeometry::SeatStay(DiameterST)                       ;#[bikeGeometry::get_Scalar           SeatStay DiameterST               ]                ;# set _lastValue(FrameTubes/SeatStay/DiameterST)                          
        dict set returnDict Scalar      SeatStay    OffsetTT                    $::bikeGeometry::SeatStay(OffsetTT)                         ;#[bikeGeometry::get_Scalar           SeatStay OffsetTT                 ]                ;# set _lastValue(Custom/SeatStay/OffsetTT)                                
        dict set returnDict Scalar      SeatStay    SeatTubeMiterDiameter       $::bikeGeometry::SeatStay(SeatTubeMiterDiameter)            ;#[bikeGeometry::get_Scalar           SeatStay SeatTubeMiterDiameter    ]                ;# set _lastValue(Lugs/SeatTube/SeatStay/MiterDiameter)                    
        dict set returnDict Scalar      SeatStay    TaperLength                 $::bikeGeometry::SeatStay(TaperLength)                      ;#[bikeGeometry::get_Scalar           SeatStay TaperLength              ]                ;# set _lastValue(FrameTubes/SeatStay/TaperLength)                         
            #            
        dict set returnDict Scalar      SeatTube    DiameterBB                  $::bikeGeometry::SeatTube(DiameterBB)                       ;#[bikeGeometry::get_Scalar           SeatTube DiameterBB               ]                ;# set _lastValue(FrameTubes/SeatTube/DiameterBB)                          
        dict set returnDict Scalar      SeatTube    DiameterTT                  $::bikeGeometry::SeatTube(DiameterTT)                       ;#[bikeGeometry::get_Scalar           SeatTube DiameterTT               ]                ;# set _lastValue(FrameTubes/SeatTube/DiameterTT)                          
        dict set returnDict Scalar      SeatTube    Extension                   $::bikeGeometry::SeatTube(Extension)                        ;#[bikeGeometry::get_Scalar           SeatTube Extension                ]                ;# set _lastValue(Custom/SeatTube/Extension)                               
        dict set returnDict Scalar      SeatTube    OffsetBB                    $::bikeGeometry::SeatTube(OffsetBB)                         ;#[bikeGeometry::get_Scalar           SeatTube OffsetBB                 ]                ;# set _lastValue(Custom/SeatTube/OffsetBB)                                
        dict set returnDict Scalar      SeatTube    TaperLength                 $::bikeGeometry::SeatTube(TaperLength)                      ;#[bikeGeometry::get_Scalar           SeatTube TaperLength              ]                ;# set _lastValue(FrameTubes/SeatTube/TaperLength)                         
            #            
        dict set returnDict Scalar      TopTube     DiameterHT                  $::bikeGeometry::TopTube(DiameterHT)                        ;#[bikeGeometry::get_Scalar           TopTube  DiameterHT               ]                ;# set _lastValue(FrameTubes/TopTube/DiameterHT)                           
        dict set returnDict Scalar      TopTube     DiameterST                  $::bikeGeometry::TopTube(DiameterST)                        ;#[bikeGeometry::get_Scalar           TopTube DiameterST                ]                ;# set _lastValue(Custom/TopTube/PivotPosition)                                        
        dict set returnDict Scalar      TopTube     OffsetHT                    $::bikeGeometry::TopTube(OffsetHT)                          ;#[bikeGeometry::get_Scalar           TopTube OffsetHT                  ] 
        dict set returnDict Scalar      TopTube     PivotPosition               $::bikeGeometry::TopTube(PivotPosition)                     ;#[bikeGeometry::get_Scalar           TopTube PivotPosition             ] 
            #
        return $returnDict
            #
        project::pdict $returnDict  4
        #return
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
                dict set returnDict $dictPath ${value}    
                    #
            }
        }
            #
        puts "  --- "
            #
            #
            #
        project::pdict $returnDict  4
            #
        return $returnDict
            #
        
    }

        #
        #-------------------------------------------------------------------------
        #  get Value
        #  -- bikeGeometry::get_Object {object index {centerPoint {0 0}} }
    proc bikeGeometry::get_Value_expired {xpath type args} {
                #
        set object $xpath
            #
            # puts "   [namespace current]"
        # puts "   ... bikeGeometry::get_Value $xpath $type $args"
        return [project::getValue $xpath $type $args]

        switch -glob $object {
                RearWheel -
                FrontWheel  - 
                BottomBracket - 
                ChainStay - 
                DownTube - 
                Fork - 
                FrontBrake - 
                FrontCarrier - 
                FrontDerailleur - 
                FrontWheel - 
                Geometry - 
                HandleBar - 
                HeadTube - 
                Lugs - 
                RearBrake - 
                RearCarrier - 
                RearDerailleur - 
                RearWheel - 
                Saddle - 
                SeatPost - 
                SeatStay - 
                SeatTube - 
                Steerer - 
                TopTube - 
                Rendering - 
                Reference
                    {
                        set value  [lindex [array get [namespace current]::$object $type] 1]
                            # [array get $object $type] -> e.g. {RimDiameter 622.0} -> lindex 1
                            # puts " .... $object/$type  ... $value"
                        return $value
                    }
                default {
                        # puts "\n"
                        puts "   <W>.... bikeGeometry::get_Value_expired $xpath $type $args"
                        # puts "\n"
                    }
        }
        
                
                
                
            # puts "   [namespace current]"
            # puts "   ... bikeGeometry::get_Value $xpath $type $args"
        return [project::getValue $xpath $type $args]
    }
        #  
        #-------------------------------------------------------------------------
        #  get Object
        #  -- bikeGeometry::get_Object {object index {centerPoint {0 0}} }
    proc bikeGeometry::get_Object_expired {object index {centerPoint {0 0}} } {
                # puts "   ... $object"
                # {lindex {-1}}

                # -- for debug purpose
            if {$object == {DEBUG_Geometry}} {
                    set returnValue    {}
                    set pointValue $index
                    foreach xy $pointValue {
                        foreach {x y} [split $xy ,] break
                        lappend returnValue $x $y  ; # puts "    ... $returnValue"
                    }
                    return [ vectormath::addVectorPointList  $centerPoint $returnValue ]
            }


                # -- default purpose
            switch -exact $index {

                polygon {    
                                #
                            switch -exact $object {
                                Stem                        {set branch "Components/Stem/Polygon"}
                                HeadSet/Top                 {set branch "Components/HeadSet/Top/Polygon"}
                                HeadSet/Bottom              {set branch "Components/HeadSet/Bottom/Polygon"}
                                Fender/Rear                 {set branch "Components/Fender/Rear/Polygon"}
                                Fender/Front                {set branch "Components/Fender/Front/Polygon"}
                                SeatPost                    {set branch "Components/SeatPost/Polygon"}
                                    
                                TubeMiter/TopTube_Head      {set branch "TubeMiter/TopTube_Head/Polygon"}
                                TubeMiter/TopTube_Seat      {set branch "TubeMiter/TopTube_Seat/Polygon"}
                                TubeMiter/DownTube_Head     {set branch "TubeMiter/DownTube_Head/Polygon"}
                                TubeMiter/DownTube_Seat     {set branch "TubeMiter/DownTube_Seat/Polygon"}
                                TubeMiter/DownTube_BB_out   {set branch "TubeMiter/DownTube_BB_out/Polygon"}
                                TubeMiter/DownTube_BB_in    {set branch "TubeMiter/DownTube_BB_in/Polygon"}
                                TubeMiter/SeatTube_Down     {set branch "TubeMiter/SeatTube_Down/Polygon"}
                                TubeMiter/SeatTube_BB_out   {set branch "TubeMiter/SeatTube_BB_out/Polygon"}
                                TubeMiter/SeatTube_BB_in    {set branch "TubeMiter/SeatTube_BB_in/Polygon"}
                                TubeMiter/SeatStay_01       {set branch "TubeMiter/SeatStay_01/Polygon"}
                                TubeMiter/SeatStay_02       {set branch "TubeMiter/SeatStay_02/Polygon"}
                                TubeMiter/Reference         {set branch "TubeMiter/Reference/Polygon"}
                                    
                                ChainStay                   {set branch "Tubes/ChainStay/Polygon"}
                                ChainStayRearMockup         {set branch "Tubes/ChainStay/RearMockup"}
                                DownTube                    {set branch "Tubes/DownTube/Polygon"}
                                ForkBlade                   {set branch "Tubes/ForkBlade/Polygon"}
                                HeadTube                    {set branch "Tubes/HeadTube/Polygon"}
                                SeatStay                    {set branch "Tubes/SeatStay/Polygon"}
                                SeatTube                    {set branch "Tubes/SeatTube/Polygon"}
                                Steerer                     {set branch "Tubes/Steerer/Polygon"}
                                TopTube                     {set branch "Tubes/TopTube/Polygon"}
                                
                                default { 
                                        set branch  {}
                                        puts "\n   <E> ... bikeGeometry::get_Object_expired polygon: \$object $object"
                                        #tk_messageBox -message "bikeGeometry::get_Polygon $object"
                                        #set branch "Tubes/$object/Polygon"
                                        #puts "    ... $object ... $branch"
                                        #exit
                                    }
                            }
                                #
                                # puts "    ... $branch"
                                #
                            if {$branch == {}} {return -1}
                                #
                            set svgList    [ project::getValue Result($branch)    polygon ]
                            foreach xy $svgList {
                                foreach {x y} [split $xy ,] break
                                lappend returnValue $x $y
                            }
                            set returnValue [ vectormath::addVectorPointList  $centerPoint  $returnValue]
				            
                                # set returnValue    [bikeGeometry::get_Polygon $object $centerPoint]
                            return $returnValue
                        }

                position {
                                #
                            switch -exact $object {
                                BottomBracket                       {set branch "Position/BottomBracket"}
                                BottomBracketGround                 {set branch "Position/BottomBracketGround"}
                                BrakeFront                          {set branch "Position/BrakeFront"}                
                                BrakeRear                           {set branch "Position/BrakeRear"}
                                
                                CarrierMountFront                   {set branch "Position/CarrierMountFront"}
                                CarrierMountRear                    {set branch "Position/CarrierMountRear"}
                                DerailleurMountFront                {set branch "Position/DerailleurMountFront"}
                                FrontWheel                          {set branch "Position/FrontWheel"}          
                                HandleBar                           {set branch "Position/HandleBar"}
                                LegClearance                        {set branch "Position/LegClearance"}
                                RearWheel                           {set branch "Position/RearWheel"}
                                Reference_HB                        {set branch "Position/Reference_HB"}
                                Reference_SN                        {set branch "Position/Reference_SN"}
                                Saddle                              {set branch "Position/Saddle"}
                                SaddleNose                          {set branch "Position/SaddleNose"}
                                SaddleProposal                      {set branch "Position/SaddleProposal"}
                                SeatPostPivot                       {set branch "Position/SeatPostPivot"}
                                SeatPostSaddle                      {set branch "Position/SeatPostSaddle"}
                                SeatPostSeatTube                    {set branch "Position/SeatPostSeatTube"}
                                SeatTubeGround                      {set branch "Position/SeatTubeGround"}
                                SeatTubeSaddle                      {set branch "Position/SeatTubeSaddle"}
                                SeatTubeVirtualTopTube              {set branch "Position/SeatTubeVirtualTopTube"}
                                SteererGround                       {set branch "Position/SteererGround"}
                                SummarySize                         {set branch "Position/SummarySize"}
                                
                                Lugs/Dropout/Rear/Derailleur        {set branch "Lugs/Dropout/Rear/Derailleur" }
                                Lugs/Dropout/Rear                   {set branch "Lugs/Dropout/Rear/Position"}
                                Lugs/Dropout/Front                  {set branch "Lugs/Dropout/Front/Position"}
                                Lugs/ForkCrown                      {set branch "Lugs/ForkCrown/Position"}
        
                                ChainStay/SeatStay_IS               {set branch "Tubes/ChainStay/SeatStay_IS"}
                                DownTube/BottleCage/Base            {set branch "Tubes/DownTube/BottleCage/Base"}        
                                DownTube/BottleCage_Lower/Base      {set branch "Tubes/DownTube/BottleCage_Lower/Base"}   
                                DownTube/BottleCage_Lower/Offset    {set branch "Tubes/DownTube/BottleCage_Lower/Offset"}   
                                DownTube/BottleCage/Offset          {set branch "Tubes/DownTube/BottleCage/Offset"}
                                DownTube/End                        {set branch "Tubes/DownTube/End"}
                                DownTube/Start                      {set branch "Tubes/DownTube/Start"}
                                HeadTube/End                        {set branch "Tubes/HeadTube/End"}
                                HeadTube/Start                      {set branch "Tubes/HeadTube/Start"}
                                SeatStay/End                        {set branch "Tubes/SeatStay/End"}
                                SeatStay/Start                      {set branch "Tubes/SeatStay/Start"}
                                SeatTube/BottleCage/Base            {set branch "Tubes/SeatTube/BottleCage/Base"}
                                SeatTube/BottleCage/Offset          {set branch "Tubes/SeatTube/BottleCage/Offset"}
                                SeatTube/End                        {set branch "Tubes/SeatTube/End"}
                                SeatTube/Start                      {set branch "Tubes/SeatTube/Start"}
                                Steerer/End                         {set branch "Tubes/Steerer/End"}
                                Steerer/Start                       {set branch "Tubes/Steerer/Start"}
                                TopTube/End                         {set branch "Tubes/TopTube/End"}
                                TopTube/Start                       {set branch "Tubes/TopTube/Start"} 
        
                                ChainStay/RearMockup                {set branch "Tubes/ChainStay/RearMockup/Start"}

                                default { 
                                            set branch  {}
                                            puts "\n   <E> ... bikeGeometry::get_Object_expired position: \$object $object"
                                            # set branch "Tubes/$object"
                                        }                        
                                        
                            }
                                #
                                # puts "    ... $branch"
                                #
                            if {$branch == {}} {return -1}
                            set pointValue    [ project::getValue Result($branch)    position ]    ; # puts "    ... $pointValue"
                            foreach xy $pointValue {
                                foreach {x y} [split $xy ,] break
                                lappend returnValue $x $y    ; # puts "    ... $returnValue"
                            }
                            set returnValue [ vectormath::addVectorPointList  $centerPoint  $returnValue]
                                #                       
                            return $returnValue
                        }

                direction {
                                #
                            switch -glob $object {
                                Lugs/Dropout/Rear   {set branch "Lugs/Dropout/Rear/Direction"}
                                Lugs/Dropout/Front  {set branch "Lugs/Dropout/Front/Direction"}
                                Lugs/ForkCrown      {set branch "Lugs/ForkCrown/Direction"}       
                                ChainStay           {set branch "Tubes/ChainStay/Direction/polar"}
                                DownTube            {set branch "Tubes/DownTube/Direction/polar"}
                                HeadTube            {set branch "Tubes/HeadTube/Direction/polar"}
                                SeatStay            {set branch "Tubes/SeatStay/Direction/polar"}
                                SeatTube            {set branch "Tubes/SeatTube/Direction/polar"}
                                Steerer             {set branch "Tubes/Steerer/Direction/polar"}
                                TopTube             {set branch "Tubes/TopTube/Direction/polar"}
                                
                                default { 
                                        set branch {}
                                        puts "\n   <E> ... bikeGeometry::get_Object_expired direction: \$object $object"
                                        # set branch "Tubes/$object/Direction/polar"
                                    }
                            }
                                #
                            #puts " -> $object $type -> $direction"
                                #
                            set directionValue    [ project::getValue Result($branch)    direction ]    ; # puts "    ... $directionValue"
                            foreach xy $directionValue {
                                foreach {x y} [split $xy ,] break
                                lappend returnValue $x $y   ; # puts "    ... $returnValue"
                            }
                                #
                            return $returnValue
                                #
                        }

                component {
                            set returnValue    [bikeGeometry::get_Component $object]
                            return $returnValue
                        }

                default    {             
                              # puts "   ... object_values $object $index"
                            #eval set returnValue $[format "frameCoords::%s(%s)" $object $index]
                            #return [ coords_addVector  $returnValue  $centerPoint]
                        }
            }
    }
    
        #
        #
    proc bikeGeometry::get_Scalar {object key} {
            # puts "   <I> bikeGeometry::get_Scalar ... $object $key"
        set value  [lindex [array get [namespace current]::$object $key] 1]
        return $value    
    }
    proc bikeGeometry::set_Scalar {object key value} {
        set newValue [bikeGeometry::check_mathValue $value] 
        if {$newValue == {}} {
            return {}
        }
        switch -exact $object {
            Geometry_old {
                    switch -exact $key {
                        {Length/BottomBracket/Height}       {   bikeGeometry::set_Result_BottomBracketHeight    $object $key  $newValue; return  }
                        {Angle/HeadTube/TopTube}            {   bikeGeometry::set_Result_HeadTube_TopTubeAngle  $object $key  $newValue; return  }
                        {Angle/SeatTube/Direction}          {   bikeGeometry::set_Result_SeatTubeDirection      $object $key  $newValue; return  }
                        {Length/SeatTube/VirtualLength}     {   bikeGeometry::set_Result_SeatTubeVirtualLength  $object $key  $newValue; return  }
                        {Length/HeadTube/ReachLength}       {   bikeGeometry::set_Result_HeadTubeReachLength    $object $key  $newValue; return  }
                        {Length/HeadTube/StackHeight}       {   bikeGeometry::set_Result_HeadTubeStackHeight    $object $key  $newValue; return  }
                        {Length/TopTube/VirtualLength}      {   bikeGeometry::set_Result_TopTubeVirtualLength   $object $key  $newValue; return  }
                        {Length/FrontWheel/horizontal}      {   bikeGeometry::set_Result_FrontWheelhorizontal   $object $key  $newValue; return  }
                        {Length/RearWheel/horizontal}       {   bikeGeometry::set_Result_RearWheelhorizontal    $object $key  $newValue; return  }
                        {Length/FrontWheel/diagonal}        {   bikeGeometry::set_Result_FrontWheeldiagonal     $object $key  $newValue; return  }
                        {Length/Saddle/Offset_HB}           {   bikeGeometry::set_Result_SaddleOffset_HB        $object $key  $newValue; return  }
                        {Length/Saddle/Offset_BB_ST}        {   bikeGeometry::set_Result_SaddleOffset_BB_ST     $object $key  $newValue; return  }
                        {Length/Saddle/Offset_BB_Nose}      {   bikeGeometry::set_Result_SaddleOffset_BB_Nose   $object $key  $newValue; return  }
    
                        {Length/Saddle/SeatTube_BB}         {   bikeGeometry::set_Result_SaddleSeatTube_BB      $object $key  $newValue; return  }
                        {Length/Personal/SaddleNose_HB}     {   bikeGeometry::set_Result_PersonalSaddleNose_HB  $object $key  $newValue; return  }
                        {Length/RearWheel/Radius}           {   bikeGeometry::set_Result_RearWheelRadius        $object $key  $newValue; return  }
                        {Length/RearWheel/TyreShoulder}     {   bikeGeometry::set_Result_RearWheelTyreShoulder  $object $key  $newValue; return  }
                        {Length/FrontWheel/Radius}          {   bikeGeometry::set_Result_FrontWheelRadius       $object $key  $newValue; return  }
                        {Length/Reference/Heigth_SN_HB}     {   bikeGeometry::set_Result_ReferenceHeigth_SN_HB  $object $key  $newValue; return  } 
                        {Length/Reference/SaddleNose_HB}    {   bikeGeometry::set_Result_ReferenceSaddleNose_HB $object $key  $newValue; return  }
                                                
                        default {}
                    }
                }
            Geometry {
                    switch -exact $key {
                        {BottomBracket_Height}      {   bikeGeometry::set_Result_BottomBracketHeight    $newValue; return [get_Scalar $object $key] }
                        {FrontWhee_Radius}          {   bikeGeometry::set_Result_FrontWheelRadius       $newValue; return [get_Scalar $object $key] }
                        {FrontWheel_xy}             {   bikeGeometry::set_Result_FrontWheeldiagonal     $newValue; return [get_Scalar $object $key] }
                        {FrontWheel_x}              {   bikeGeometry::set_Result_FrontWheelhorizontal   $newValue; return [get_Scalar $object $key] }
                        {HeadLugTop_Angle}          {   bikeGeometry::set_Result_HeadTube_TopTubeAngle  $newValue; return [get_Scalar $object $key] }
                        {Reach_Length}              {   bikeGeometry::set_Result_HeadTubeReachLength    $newValue; return [get_Scalar $object $key] }
                        {RearWheel_Radius}          {   bikeGeometry::set_Result_RearWheelRadius        $newValue; return [get_Scalar $object $key] }
                        {RearWheel_x}               {   bikeGeometry::set_Result_RearWheelhorizontal    $newValue; return [get_Scalar $object $key] }
                        {SaddleNose_BB_x}           {   bikeGeometry::set_Result_SaddleOffset_BB_Nose   $newValue; return [get_Scalar $object $key] }
                        {SaddleNose_HB}             {   bikeGeometry::set_Result_PersonalSaddleNose_HB  $newValue; return [get_Scalar $object $key] }
                        {Saddle_BB}                 {   bikeGeometry::set_Result_SaddleSeatTube_BB      $newValue; return [get_Scalar $object $key] }
                        {Saddle_HB_y}               {   bikeGeometry::set_Result_SaddleOffset_HB        $newValue; return [get_Scalar $object $key] }
                        {Saddle_Offset_BB_ST}       {   bikeGeometry::set_Result_SaddleOffset_BB_ST     $newValue; return [get_Scalar $object $key] }
                        {SeatTube_Angle}            {   bikeGeometry::set_Result_SeatTubeDirection      $newValue; return [get_Scalar $object $key] }
                        {SeatTube_Virtual}          {   bikeGeometry::set_Result_SeatTubeVirtualLength  $newValue; return [get_Scalar $object $key] }
                        {Stack_Height}              {   bikeGeometry::set_Result_HeadTubeStackHeight    $newValue; return [get_Scalar $object $key] }
                        {TopTube_Virtual}           {   bikeGeometry::set_Result_TopTubeVirtualLength   $newValue; return [get_Scalar $object $key] }
                        
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
        array set [namespace current]::$object [list $key $newValue]
        bikeGeometry::update_Project
        set returnValue [bikeGeometry::get_Scalar $object $key ]
        return $returnValue
    }
        #
    proc bikeGeometry::get_ListValue {key} { 
        set value  [lindex [array get [namespace current]::ListValue $key] 1]
        return $value    
    }    
    proc bikeGeometry::set_ListValue {key value} { 
        set [namespace current]::ListValue($key) $value
        bikeGeometry::update_Project
        set value  [lindex [array get [namespace current]::ListValue $key] 1]
        return $value    
    }    
        #
    proc bikeGeometry::get_Component {key} {
        set compFile    [lindex [array get [namespace current]::Component $key] 1]
        return $compFile
    } 
    proc bikeGeometry::set_Component {key value} {
        set [namespace current]::Component($key) $value
        bikeGeometry::update_Project
        set compFile    [bikeGeometry::get_Component $key]
        return $compFile
    }
        #
    proc bikeGeometry::get_Config {key} {
        set configValue  [lindex [array get [namespace current]::Config $key] 1]
        return $configValue
    }  
    proc bikeGeometry::set_Config {key value} {
        set [namespace current]::Config($key) $value
        bikeGeometry::update_Project
        set configValue [bikeGeometry::get_Config $key]
        return $configValue
    }  
        #
        #
    proc bikeGeometry::get_Polygon {object {centerPoint {0 0}}} {
                #
            variable Stem
            variable HeadSet
            variable RearFender
            variable FrontFender
            variable SeatPost
            variable TubeMiter
            variable ChainStay
            variable DownTube
            variable ForkBlade
            variable HeadTube
            variable SeatStay
            variable SeatTube
            variable Steerer
            variable TopTube
            variable DEBUG_Geometry
                #
            set returnValue {}
            set polygon     {}
                #
            switch -exact $object {
                
                Stem                        {set polygon $Stem(Polygon)             }
                HeadSetTop                  {set polygon $HeadSet(PolygonTop)       }
                HeadSetBottom               {set polygon $HeadSet(PolygonBottom)    }
                RearFender                  {set polygon $RearFender(Polygon)       }
                FrontFender                 {set polygon $FrontFender(Polygon)      }
                SeatPost                    {set polygon $SeatPost(Polygon)         }
                                                                    
                ChainStay                   {set polygon $ChainStay(Polygon)        }
                ChainStayRearMockup         {set polygon $ChainStay(Polygon_RearMockup) }
                DownTube                    {set polygon $DownTube(Polygon)         }
                ForkBlade                   {set polygon $ForkBlade(Polygon)        }
                HeadTube                    {set polygon $HeadTube(Polygon)         }
                SeatStay                    {set polygon $SeatStay(Polygon)         }
                SeatTube                    {set polygon $SeatTube(Polygon)         }
                Steerer                     {set polygon $Steerer(Polygon)          }
                TopTube                     {set polygon $TopTube(Polygon)          }
 
                default { puts "   <E> ... bikeGeometry::get_Polygon \$object $object"
                        #tk_messageBox -message "bikeGeometry::get_Polygon $object"
                        #set branch "Tubes/$object/Polygon"
                        #puts "    ... $object ... $branch"
                        #exit
                    }
            }
                #
                # puts "    ... $branch"
                #
            return [ vectormath::addVectorPointList  $centerPoint  $polygon]
                #

    }
        #
    proc bikeGeometry::get_Position {object {centerPoint {0 0}}} {
                #
            variable Position
            variable BottomBracket
            variable ChainStay
            variable DownTube
            variable Fork
            variable FrontBrake
            variable FrontCarrier
            variable FrontDerailleur
            variable FrontWheel
            variable Geometry
            variable HandleBar
            variable HeadTube
            variable Lugs
            variable RearBrake
            variable RearCarrier
            variable RearDropout
            variable RearWheel
            variable Saddle
            variable SeatPost
            variable SeatStay
            variable SeatTube
            variable Steerer
            variable TopTube
                #
            variable DEBUG_Geometry
                #
            variable Reference
                #
            set returnValue {}
            set position    {}
                #
            switch -glob $object {
                
                BottomBracket                       {set position {0 0}                     }
                BottomBracketGround                 {set position $Position(BottomBracket_Ground)}
                BrakeFront -            
                FrontBrakeShoe                      {set position $FrontBrake(Shoe)         }                
                FrontBrakeHelp                      {set position $FrontBrake(Help)         }
                FrontBrakeDefinition                {set position $FrontBrake(Definition)   }
                FrontBrake -            
                FrontBrakeMount                     {set position $FrontBrake(Mount)        }
                BrakeRear -         
                RearBrakeShoe                       {set position $RearBrake(Shoe)          }
                RearBrakeHelp                       {set position $RearBrake(Help)          }
                RearBrakeDefinition                 {set position $RearBrake(Definition)    }
                RearBrake -         
                RearBrakeMount                      {set position $RearBrake(Mount)         }
                 
                CarrierMountFront                   {set position $FrontCarrier(Mount)      }
                CarrierMountRear                    {set position $RearCarrier(Mount)       }
                DerailleurMountFront                {set position $FrontDerailleur(Mount)   }
                FrontWheel                          {set position $Fork(DropoutPosition)    }          
                HandleBar                           {set position $HandleBar(Position)      }
                LegClearance                        {set position $Position((LegClearance)  }
                RearWheel                           {set position $RearWheel(Position)      }
                Reference_HB                        {set position $Reference(HandleBar)     }
                Reference_SN                        {set position $Reference(SaddleNose)    }
                Saddle                              {set position $Saddle(Position)         }
                SaddleNose                          {set position $Saddle(Nose)             }
                SaddleProposal                      {set position $Saddle(Proposal)         }
                SeatPostPivot                       {set position $SeatPost(PivotPosition)  }
                SeatPostSaddle                      {set position $SeatPost(Saddle)         }
                SeatPostSeatTube                    {set position $SeatPost(SeatTube)       }
                SeatTubeGround                      {set position $SeatTube(Ground)         }
                SeatTubeSaddle                      {set position $Position(SeatTubeSaddle) }
                SeatTubeVirtualTopTube              {set position $SeatTube(VirtualTopTube) }
                SteererGround                       {set position $Steerer(Ground)          }
                SummarySize                         {set position $Geometry(SummarySize)    }
                        
                RearDerailleur                      {set position $RearDropout(DerailleurPosition)      }
        
                RearDropout                         {set position $RearDropout(Position)                }
                FrontDropout                        {set position $Fork(DropoutPosition)                }
                ForkCrown                           {set position $Steerer(Fork)                        }
                                                                                                        
                ChainStay_SeatStay_IS               {set position $ChainStay(SeatStay_IS)               }
                DownTube_BottleCageBase             {set position $DownTube(BottleCage_Base)            }        
                DownTube_BottleCageOffset           {set position $DownTube(BottleCage_Offset)          }
                DownTube_Lower_BottleCageBase       {set position $DownTube(BottleCage_Lower_Base)      }   
                DownTube_Lower_BottleCageOffset     {set position $DownTube(BottleCage_Lower_Offset)    }   
                DownTubeEnd                         {set position $DownTube(HeadTube)                   }
                DownTubeStart                       {set position $DownTube(BottomBracket)              }
                HeadTubeEnd                         {set position $HeadTube(Stem)                       }
                HeadTubeStart                       {set position $HeadTube(Fork)                       }
                SeatStayEnd                         {set position $SeatStay(SeatTube)                   }
                SeatStayStart                       {set position $SeatStay(RearWheel)                  }
                SeatTube_BottleCageBase             {set position $SeatTube(BottleCage_Base)            }
                SeatTube_BottleCageOffset           {set position $SeatTube(BottleCage_Offset)          }
                SeatTubeEnd                         {set position $SeatTube(TopTube)                    }
                SeatTubeStart                       {set position $SeatTube(BottomBracket)              }
                SteererEnd                          {set position $Steerer(Stem)                        }
                SteererStart                        {set position $Steerer(Fork)                        }
                TopTubeEnd                          {set position $TopTube(HeadTube)                    }
                TopTubeStart                        {set position $TopTube(SeatTube)                    } 
                                                                                                        
                ChainStayRearMockup                 {set position $ChainStay(RearMockupStart)           }

                default { puts "   <E> ... bikeGeometry::get_Position \$object $object"
                            # set branch "Tubes/$object"
                        }                        
                        
            }
                #
                # puts "    ... $branch"
                #
            return [ vectormath::addVector  $centerPoint  $position] 
                #
    }
        #
    proc bikeGeometry::get_Direction {object {type {polar}}} {
                #
            variable Fork
            variable ChainStay
            variable DownTube
            variable HeadTube
            variable SeatStay
            variable SeatTube
            variable Steerer
            variable TopTube
            variable RearDropout
                #
            set returnValue {}
            set direction   {}
                #
            set branch      {}
            # puts " -> $object $type -> ..." 
                #
                # IMPORTANT: ... set direction {0 0} ... these values are not updated from bikeGeometry !!! 2014 11 01
                #
            switch -glob $object {
                RearDropout         {set direction $RearDropout(Direction)  }
                ForkDropout         {set direction $Fork(DropoutDirection)  }
                ForkCrown           {set direction $Fork(CrownDirection)    }       
                
                ChainStay           {set direction $ChainStay(Direction)    }
                DownTube            {set direction $DownTube(Direction)     }
                HeadTube            {set direction $HeadTube(Direction)     }
                SeatStay            {set direction $SeatStay(Direction)     }
                SeatTube            {set direction $SeatTube(Direction)     }
                Steerer             {set direction $Steerer(Direction)      }
                TopTube             {set direction $TopTube(Direction)      }
                
                
                default { puts "   <E> ... bikeGeometry::get_Direction \$object $object"
                        # set branch "Tubes/$object/Direction/polar"
                    }
            }
                #
            #puts " -> $object $type -> $direction"
                #
            if {$direction == {}} {  
                puts "    <W> ... get_Direction $branch"
                return -1
            }
                #
            switch -exact $type {
                degree  {   return [vectormath::angle {1 0} {0 0} $direction] }
                rad    -
                polar  -
                default {   return $direction}
            }
    }
        #
    proc bikeGeometry::get_BoundingBox {object} {
                #
            set boundingBox {}
                #
                # puts " .. $object\n"
                #
            switch -glob $object {
                Complete   {set boundingBox $Geometry(SummarySize)}
                default    {
                            set boundingBox  [lindex [array get [namespace current]::BoundingBox $object] 1]
                        }
            }
                
                # [array get $object $key] -> e.g. {RimDiameter 622.0} -> lindex 1
                # parray [namespace current]::Rendering
                # puts " .... $object/$key  ... $componentFile"
            return $boundingBox
    }
        #
    proc bikeGeometry::get_TubeMiter {object} {
                #
            variable TubeMiter
                #
            set returnValue {}
            set polygon     {}
                #
            switch -exact $object {
                TopTube_Head      {set polygon $TubeMiter(TopTube_Head)     }
                TopTube_Seat      {set polygon $TubeMiter(TopTube_Seat)     }
                DownTube_Head     {set polygon $TubeMiter(DownTube_Head)    }
                DownTube_Seat     {set polygon $TubeMiter(DownTube_Seat)    }
                DownTube_BB_out   {set polygon $TubeMiter(DownTube_BB_out)  }
                DownTube_BB_in    {set polygon $TubeMiter(DownTube_BB_in)   }
                SeatTube_Down     {set polygon $TubeMiter(SeatTube_Down)    }
                SeatTube_BB_out   {set polygon $TubeMiter(SeatTube_BB_out)  }
                SeatTube_BB_in    {set polygon $TubeMiter(SeatTube_BB_in)   }
                SeatStay_01       {set polygon $TubeMiter(SeatStay_01)      }
                SeatStay_02       {set polygon $TubeMiter(SeatStay_02)      }
                Reference         {set polygon $TubeMiter(Reference)        }
    
                default { 
                        puts "\n   <E> ... bikeGeometry::get_TubeMiter \$object $object"
                        #tk_messageBox -message "bikeGeometry::get_Polygon $object"
                        #set branch "Tubes/$object/Polygon"
                        #puts "    ... $object ... $branch"
                        #exit
                    }
            }
                #
                # puts "    ... $branch"
                #

            return $polygon
                # return [ vectormath::addVectorPointList  $centerPoint  $polygon] 

    }
        
        #
    proc bikeGeometry::get_CenterLine {object {key {}}} {
                # 
            set returnString {}
                #
                # puts " .. $object\n"
                #
            switch -glob $object {
                RearMockup {
                        switch -exact $key {
                            CenterLine -
                            default {
                                    set returnString  [lindex [array get [namespace current]::$object $key] 1]
                                }
                        }
                    }
                default    {
                            set returnString  [lindex [array get [namespace current]::$object $key] 1]
                    }
            }
                
                # [array get $object $key] -> e.g. {RimDiameter 622.0} -> lindex 1
                # parray [namespace current]::Rendering
                # puts " .... $object/$key  ... $componentFile"
            return $returnString
    }
        #
        #
    proc bikeGeometry::get_ComponentDir {} {
            #
        variable packageHomeDir
            #
        set componentDir [file join $packageHomeDir  .. etc  components]
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
    proc bikeGeometry::get_ReynoldsFEAContent {} {
        return [::bikeGeometry::lib_reynoldsFEA::get_Content]    
    }
    
    #-------------------------------------------------------------------------
        #  sets and format Value
        #
    proc bikeGeometry::set_Value {xpath value {mode {update}}} {
     
            puts "  <I> bikeGeometry::set_Value $xpath $value $mode"             
            # xpath: e.g.:Custom/BottomBracket/Depth
              
              # puts ""
              # puts "   -------------------------------"
              # puts "    set_Value"
              # puts "       xpath:           $xpath"
              # puts "       value:           $value"
              # puts "       mode:            $mode"
         
            foreach {_array _name path} [project::unifyKey $xpath] break
                # puts "     ... $_array  $_name"
         
         
            # --- handle xpath values ---
                # puts "  ... mode: $mode"
                
                # --- exception on mode == force ---
                # 
            switch -exact $mode {
                {format} { 
                            # -- currently check why ... 20141126
                        # tk_messageBox -message "bikeGeometry::set_Value - format - $xpath $value"
                    }
                {force} { 
                            # -- currently check why ... 20141126
                        # tk_messageBox -message "bikeGeometry::set_Value - force - $xpath $value"
                        eval set [format "project::%s(%s)" $_array $_name] $value
                        bikeGeometry::update_Project
                        return $value
                    }
                default {}
            }
                # --- exception for Result - Values ---
                #   ... loop over set_resultParameter
                #    if there is a Result to set
                #             
                #   puts "  ... setValue: $xpath"
            switch -glob $_array {
                {Result} {
                        set newValue [check_mathValue $value]
                            # set newValue [ string map {, .} $value]
                            # puts "\n  ... setValue: ... Result/..."
                        set_resultParameter $_array $_name $newValue
                        return $newValue
                    }
                {Rendering} {
                        # tk_messageBox -message "bikeGeometry::set_Value Rendering $xpath $value"
                    }
                default {}
            }
            
                # --- all the exceptions done ---
                #   on int list values like defined
                #   puts "<D> $xpath"
            switch -exact $xpath {
                {Component/Wheel/Rear/RimDiameter} -
                {Component/Wheel/Front/RimDiameter} -
                {Lugs/RearDropOut/Direction} -
                {Component/CrankSet/ChainRings} -
                {Component/Wheel/Rear/FirstSprocket} {
                            # set newValue [ string map {, .} $value]
                        set newValue [check_mathValue $value]    
                            # puts " <D> $newValue"
                        project::setValue [format "%s(%s)" $_array $_name] value $newValue
                        bikeGeometry::get_from_project
                        bikeGeometry::update_Project  
                        return $newValue
                    }
                default {}
            }
                #
                # --- update or return on errorID
            set checkValue {mathValue}
            set newValue    $value
                #
            if {[file dirname $xpath] == {Rendering}} {
                set checkValue {}
                    # puts "               ... [file dirname $xpath] "
            }
            if {[file tail $xpath]    == {File}     } {
                set checkValue {}
                    # puts "               ... [file tail    $xpath] "
            }
            if {[lindex [split $xpath /] 0] == {Rendering}} {
                set checkValue {}
                  # puts "   ... Rendering: $xpath "
            }
                #
                # --- update or return on errorID
            if {$checkValue == {mathValue} } {
                set newValue [check_mathValue $value]
                if {$newValue == {}} {
                    return {}
                }
            }

    
            # --------------------------------------
                #  at least update Geometry
                #   ... if not left earlier
                #
            # puts "    <I> bikeGeometry::set_Value  ... $newValue"
                #
            project::setValue [format "%s(%s)" $_array $_name] value $newValue
            bikeGeometry::get_from_project
			bikeGeometry::update_Project
                # puts "" 
                # puts "    setValue:  $argv\n" 
                # puts "                [format "%s(%s)" $_array $_name] vs $xpath "
            parray ::bikeGeometry::Config
                #
            return $newValue
    }

    #-------------------------------------------------------------------------
       #  check mathValue
    proc bikeGeometry::check_mathValue {value} {
                #
            puts "    <1> bikeGeometry::check_mathValue $value"    
                # --- set new Value
            set newValue [ string map {, .} $value]
                # --- check Value --- ";" ... like in APPL_RimList
            if {[llength [split $newValue  ]] > 1} return {}
            if {[llength [split $newValue ;]] > 1} return {}
                #
            if { [catch { set newValue [expr 1.0 * $newValue] } errorID] } {
                puts "\n    <E> bikeGeometry::check_mathValue"
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
            puts "    <2> bikeGeometry::check_mathValue $value  ->  $newValue"    
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


