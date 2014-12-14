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
 #          update set_Value and set_ResultParameter
 #          rename bikeGeometry::set_base_Parameters  ->  bikeGeometry::update_Parameter
 #          move   bikeGeometry::get_from_project     ->  bikeGeometry::set_newProject 
 #          remove array _updateValue()
 #          remove set_Value from proc set_ResultParameter 
 #
 #          split project completely from bikeGeometry
 #          update   get_from_project
 #              and  set_to_project
 #
  
    package require tdom
        #
    package provide bikeGeometry 1.15
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
        
            #-------------------------------------------------------------------------
                #  current Project Values
            variable Project         ; array set Project         {}
            variable Geometry        ; array set Geometry        {}
            variable Reference       ; array set Reference       {}
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
            namespace export get_Scalar 
            namespace export get_Object
            namespace export get_Polygon
            namespace export get_Position
            namespace export get_Direction
            namespace export get_Config
            namespace export get_Component
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
            bikeGeometry::update_Parameter
              
                
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
            return $project::projectDICT
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
    proc bikeGeometry::get_Scalar {object {key {}}} {
            #
        if {$object == {}} {
                return {-1}
                error "\n     <E>          ... empty \$object\n"
        }
        if {$object == {Result_}} {
            puts "   .... [namespace current]::$object"
            parray [namespace current]::$object
        }
        set value  [lindex [array get [namespace current]::$object $key] 1]
        return $value    
            #
            # [array get $object $type] -> e.g. {RimDiameter 622.0} -> lindex 1
            # puts " .... $object/$type  ... $value"

 
                switch -glob $object {
                        Lugs {
                                puts "  ---"
                                set value  [lindex [array get [namespace current]::$object $key] 1]
                                    # [array get $object $type] -> e.g. {RimDiameter 622.0} -> lindex 1
                                    puts " .... $object/$type  ... $value"
                                return $value
                            }
                        BottomBracket -
                        ChainStay -
                        CrankSet -
                        DownTube -
                        Fork -
                        FrontBrake -
                        FrontCarrier -
                        FrontDerailleur -
                        FrontWheel  -
                        FrontWheel -
                        Geometry -
                        HandleBar -
                        HeadTube -
                        HeadSet -
                        RearBrake -
                        RearCarrier -
                        RearDerailleur -
                        RearDropout -
                        RearWheel -
                        RearWheel -
                        Rendering -
                        Saddle -
                        SeatPost -
                        SeatStay -
                        SeatTube -
                        Steerer -
                        Stem -
                        TopTube -
                        Reference
                            {
                                set value  [lindex [array get [namespace current]::$object $key] 1]
                                    # [array get $object $type] -> e.g. {RimDiameter 622.0} -> lindex 1
                                    # puts " .... $object/$type  ... $value"
                                return $value
                            }
                        RearMockup {
                                parray [namespace current]::$object
                                set value  [lindex [array get [namespace current]::$object $key] 1]
                                    # [array get $object $type] -> e.g. {RimDiameter 622.0} -> lindex 1
                                    # puts " .... $object/$type  ... $value"
                                return $value
                        }
                        
                        default {
                                puts "\n"
                                puts "   <W>.... bikeGeometry::get_Scalar  $object $key"
                                # puts "\n"
                            }
                }
    }
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
            variable BottomBracket
            variable ChainStay
            variable DownTube
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
                BottomBracketGround                 {set position $BottomBracket(Ground)    }
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
                FrontWheel                          {set position $FrontWheel(Position)     }          
                HandleBar                           {set position $HandleBar(Position)      }
                LegClearance                        {set position $Geometry(LegClearance)   }
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
                SeatTubeSaddle                      {set position $Geometry(SeatTubeSaddle) }
                SeatTubeVirtualTopTube              {set position $SeatTube(VirtualTopTube) }
                SteererGround                       {set position $Steerer(Ground)          }
                SummarySize                         {set position $Geometry(SummarySize)    }
                        
                RearDerailleur                      {set position $RearDropout(DerailleurPosition)      }
        
                RearDropout                         {set position $RearDropout(Position)                }
                FrontDropout                        {set position $Fork(Dropout)                        }
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
    proc bikeGeometry::get_Component {object {key {File}}} {
                #
            set componentFile {}
                #
                # puts " .. $object\n"
                #
            switch -glob $object {
                CrankSet -
                FrontBrake -
                FrontCarrier -
                FrontDerailleur -
                HandleBar -
                Hub -
                Logo -
                RearBrake -
                RearCarrier -
                RearDerailleur -
                RearDropout -
                Saddle {
                        set componentFile  [lindex [array get [namespace current]::$object {File}] 1]
                            # [array get $object $key] -> e.g. {RimDiameter 622.0} -> lindex 1
                            # puts " .... $object/$key  ... $componentFile"
                        return $componentFile
                    }                
                BottleCage -
                Fork {
                            # Fork(CrownFile)  
                            # Fork(DropOutFile)
                            # Brake(FileFront)                     
                            # Brake(FileRear)                      
                            # BottleCage(FileSeatTube)             
                            # BottleCage(FileDownTube)             
                            # BottleCage(FileDownTube_Lower)                        
                        set componentFile  [lindex [array get [namespace current]::$object $key] 1]
                            # [array get $object $key] -> e.g. {RimDiameter 622.0} -> lindex 1
                            # puts " .... $object/$key  ... $value"
                        return $componentFile
                    }
                default {
                        puts "\n"
                        puts "        <W> .... bikeGeometry::get_Component $object $key"
                        puts "\n"
                        return {}
                    }                
            }
                #
            return
                #
    }
        #
    proc bikeGeometry::get_Config {object} {
                #
            set optionValue {}
                #
                # puts " .. $object\n"
                #
            set optionValue  [lindex [array get [namespace current]::Rendering $object] 1]
                # [array get $object $key] -> e.g. {RimDiameter 622.0} -> lindex 1
                # parray [namespace current]::Rendering
                # puts " .... $object/$key  ... $componentFile"
            return $optionValue
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
    proc bikeGeometry::set_Value {xpath value {mode {update}}} {
     
              # xpath: e.g.:Custom/BottomBracket/Depth
              
            # variable         _updateValue
         
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
                {force} { 
                            # -- currently check why ... 20141126
                        tk_messageBox -message "bikeGeometry::set_Value - format - $xpath $value"
                    }
                {force} { 
                            # -- currently check why ... 20141126
                        tk_messageBox -message "bikeGeometry::set_Value - force - $xpath $value"
                        eval set [format "project::%s(%s)" $_array $_name] $value
                        bikeGeometry::update_Parameter
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
                        bikeGeometry::update_Parameter  
                        return $newValue
                    }
                default {}
            }
         
            
            # --- exceptions without any format-checks
            # on int list values like defined
            # puts "<D> $xpath"
        
                # --- set new Value
            #set newValue [ string map {, .} $value]
                # --- check Value --- ";" ... like in APPL_RimList
            #set newValue [lindex [split $newValue ;] 0]
                # --- check Value --- update
            if {$mode == {update}} {
                # set _updateValue($xpath) $newValue
            }
         
                #
                # --- update or return on errorID
            set checkValue {mathValue}
                #
            if {[file dirname $xpath] == {Rendering}} {
                    # puts "               ... [file dirname $xpath] "
                set checkValue {}
            }
            if {[file tail $xpath]    == {File}     } {
                    # puts "               ... [file tail    $xpath] "
                set checkValue {}
            }
         
            if {[lindex [split $xpath /] 0] == {Rendering}} {
                set checkValue {}
                  # puts "   ... Rendering: $xpath "
                  # puts "        ... $value [file tail $xpath]"
            }
         
                # puts "               ... checkValue: $checkValue "
            
			
                # --- update or return on errorID
            if {$checkValue == {mathValue} } {
                set newValue [check_mathValue $value]
                if {$newValue == {}} {
                    return {}
                }
                    #
                if {1 == 2} {
                    if { [catch { set newValue [expr 1.0 * $newValue] } errorID] } {
                        puts "\n    <E> bikeGeometry::set_Value"
                        foreach line [split ${errorID} \n] {
                            puts "           $line"
                        }
                        puts ""
                        return {}
                    } else {
                        set newValue [format "%.3f" $newValue]
                    }
                }
            }
            
			
            # ---------------------------
                #  just return Parameter if required 
                #       ... by mode: format
                #
            if {$mode == {format}} {
                # return $newValue
            }
            
    
            # --------------------------------------
                #  at least update Geometry
                #   ... if not left earlier
                #
            project::setValue [format "%s(%s)" $_array $_name] value $newValue
            bikeGeometry::update_Parameter			 
			
                # puts "" 
                # puts "    setValue:  $argv\n" 
                # puts "                [format "%s(%s)" $_array $_name] vs $xpath "
            return $newValue
    }

    #-------------------------------------------------------------------------
       #  handle modification on /root/Result/... values
    proc bikeGeometry::set_resultParameter_remove {_array _name value} {
    
            # variable         _updateValue
        
              # puts ""
              # puts "   -------------------------------"
              # puts "    set_resultParameter"
              # puts "       _array:          $_array"
              # puts "       _name:           $_name"
              # puts "       value:           $value"
        
            variable Geometry
            variable Rendering
            variable Reference
            variable Result
                #
            variable BottomBracket
            variable HandleBar
            variable Saddle
            variable SeatPost
            variable SeatTube
            variable HeadTube
            variable TopTube
            variable RearWheel
            variable FrontWheel
            variable Fork
            variable Stem
            
           
        
            set xpath "$_array/$_name"
              # puts "       xpath:           $xpath"
        
            switch -exact $_name {
        
                {Length/BottomBracket/Height} {
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            # puts "set_resultParameter   -> Length/BottomBracket/Height - check \$BottomBracket(height) $BottomBracket(height)"
                            # puts "set_resultParameter   -> Length/BottomBracket/Height - check \$BottomBracket(depth) $BottomBracket(depth)"
                        set oldValue                $BottomBracket(Height)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format]
                            # set _updateValue($xpath)    $newValue
                        set delta                   [expr $newValue - $oldValue]
                            # puts "   ... oldValue:   $oldValue"
                            # puts "   ... newValue:   $newValue"
                            # puts "   ...... delta:   $delta"
                            
                            # --- update value
                            #
                        set xpath                   Custom/BottomBracket/Depth
                        set oldValue                $BottomBracket(Depth)
                        set BottomBracket(Depth)    [expr $oldValue - $delta ]
                        set_Value                   $xpath     $BottomBracket(Depth)
                            # 2014-11-19
                            # set newValue                [expr $oldValue - $delta ]
                            # set_Value                   $xpath     $newValue
                        return
                    }
              
                {Angle/HeadTube/TopTube} {
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                        set newValue [check_mathValue $value]
                        if {$newValue == {}} return {}
                            #
                            # set HeadTopTube_Angle       [set_Value $xpath  $value format]
                        set HeadTopTube_Angle       $newValue
                            # set _updateValue($xpath)    $HeadTopTube_Angle
                            # puts "          \$HeadTopTube_Angle  = $HeadTopTube_Angle"
                  
                            # --- update value
                            #
                        set TopTube(Angle)          [expr $HeadTopTube_Angle - $HeadTube(Angle)]
                        set xpath                   Custom/TopTube/Angle
                        set_Value                   $xpath     $TopTube(Angle)
                            # 2014-11-19
                            # set value                   [expr $HeadTopTube_Angle - $HeadTube(Angle)]
                            # set xpath                   Custom/TopTube/Angle
                            # set_Value                   $xpath     $value
                        return
                    }
              
                {Angle/SeatTube/Direction} {
                            # puts "\n"
                            # puts "  ... Angle/SeatTube/Direction comes here: $value"
                            # puts ""
                            # puts "set_resultParameter   -> Angle/SeatTube/Direction - check \$Geometry(SeatTube_Angle) $Geometry(SeatTube_Angle)"
                            # puts "set_resultParameter   -> Angle/SeatTube/Direction - check \$Saddle(Height) $Saddle(Height)"
                            # puts "set_resultParameter   -> Angle/SeatTube/Direction - check \$Saddle(SaddleHeight)  $Saddle(SaddleHeight) "
                            # puts "set_resultParameter   -> Angle/SeatTube/Direction - check \$SeatPost(Setback) $SeatPost(Setback)"
                            # puts "set_resultParameter   -> Angle/SeatTube/Direction - check \$SeatPost(PivotOffset) $SeatPost(PivotOffset)"
                        set oldValue        $Geometry(SeatTube_Angle)
                        set PS_SD_Heigth    $Saddle(Height)
                        set SD_Heigth       $Saddle(SaddleHeight) 
                        set SP_Setback      $SeatPost(Setback)
                        set SP_PivotOffset  $SeatPost(PivotOffset)
                            #
                        set length_Setback  [expr $SP_Setback * sin([vectormath::rad $value])]
                        set height_Setback  [expr $SP_Setback * cos([vectormath::rad $value])]
                            # puts "    -> value $value"
                            # puts "    -> oldValue $oldValue"
                            # puts "    -> SP_Setback $SP_Setback"
                            # puts "    -> length_Setback $length_Setback"
                            # puts "    -> height_Setback $height_Setback"
                        set ST_height       [expr $PS_SD_Heigth - $SD_Heigth - $SP_PivotOffset + $height_Setback]
                        set length_SeatTube [expr $ST_height / tan([vectormath::rad $value])]
                            # puts "    -> ST_height $ST_height"
                            # puts "    -> length_SeatTube $length_SeatTube"
                            #
                            
                            # --- update value
                            #
                        set value [expr $length_Setback + $length_SeatTube]
                        set xpath                   Personal/Saddle_Distance
                        set_Value                   $xpath     $value
                        return
                   }
              
                {Length/SeatTube/VirtualLength} {
                            # puts "  -> Length/SeatTube/VirtualLength"
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
              
                            # SeatTube Offset
                            #
                            # puts "set_resultParameter   -> Length/SeatTube/VirtualLength - check \$Geometry(SeatTubeVirtual) $Geometry(SeatTubeVirtual))"
                            # puts "set_resultParameter   -> Length/SeatTube/VirtualLength - check \$Geometry(SeatTube_Angle) $Geometry(SeatTube_Angle))"
                            # puts "set_resultParameter   -> Length/SeatTube/VirtualLength - check \$HeadTube(Angle) $HeadTube(Angle))"
                        set oldValue                $Geometry(SeatTubeVirtual)
                            # set oldValue                $Geometry(SeatTubeVirtual)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format]
                            # set _updateValue($xpath)    $newValue
                        set delta                   [expr $newValue - $oldValue]
                
                        set offsetSeatTube          [vectormath::rotateLine {0 0} $delta [expr 180 - $Geometry(SeatTube_Angle)]]
                        set offsetSeatTube_x        [lindex $offsetSeatTube 0]
                            # puts "   -> $offsetSeatTube"
                    
                            # HeadTube Offset - horizontal
                            #
                        set deltaHeadTube           [expr [lindex $offsetSeatTube 1] / sin($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]
                        set offsetHeadTube_x        [expr [lindex $offsetSeatTube 1] / tan($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]
              
                            # HeadTube Offset - horizontal & length
                            #
                        set xpath                   Personal/HandleBar_Distance
                        set newValue                [expr $HandleBar(Distance)    + $offsetHeadTube_x + $offsetSeatTube_x]
                        set_Value                   $xpath     $newValue
                            #
                        set xpath                   FrameTubes/HeadTube/Length
                        set newValue                [expr $HeadTube(Length)    + $deltaHeadTube]
                        set_Value                   $xpath     $newValue
                            #
                        # set_Value                   $xpath     $newValue
                            #
                        return
                }
              
                {Length/HeadTube/ReachLength} {
                            # puts "set_resultParameter   -> Length/HeadTube/ReachLength - check \$Geometry(ReachLengthResult) $Geometry(ReachLengthResult)"
                            # puts "set_resultParameter   -> Length/HeadTube/ReachLength - check \$HandleBar(Distance) $HandleBar(Distance)"
                        set oldValue                $Geometry(ReachLengthResult)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format]
                            # set _updateValue($xpath)    $newValue
                        set delta                   [expr $newValue - $oldValue]
                            #
                        set xpath                   Personal/HandleBar_Distance
                        set oldValue                $HandleBar(Distance)
                        set newValue                [expr $HandleBar(Distance)    + $delta]
                        set_Value                   $xpath     $newValue
                        return
                }
              
                {Length/HeadTube/StackHeight} {
                            # puts "set_resultParameter   -> Length/HeadTube/StackHeight - check \$Geometry(StackHeightResult) $Geometry(StackHeightResult)"
                            # puts "set_resultParameter   -> Length/HeadTube/StackHeight - check \$HeadTube(Angle)   $HeadTube(Angle)"
                            # puts "set_resultParameter   -> Length/HeadTube/StackHeight - check \$HandleBar(Height) $HandleBar(Height)"
                        set oldValue                $Geometry(StackHeightResult)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format]
                            # set _updateValue($xpath)    $newValue
                        set delta                   [expr $newValue - $oldValue]
              
                        set deltaHeadTube           [expr $delta / sin($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]
                        set offsetHeadTube_x        [expr $delta / tan($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]
              
                            # puts "==================="
                            # puts "    delta             $delta"
                            # puts "    deltaHeadTube     $deltaHeadTube"
                            # puts "    offsetHeadTube_x  $offsetHeadTube_x"
                      
                            #
                            # project::remove_tracing ; #because of setting two parameters at once
                            #
                        set xpath                   Personal/HandleBar_Height
                        set oldValue                $HandleBar(Height)
                        set newValue                [expr $HandleBar(Height)    + $delta]
                        set_Value                   $xpath      $newValue
                            #
                            # project::add_tracing
                            #
                        set xpath                   FrameTubes/HeadTube/Length
                        set oldValue                $HeadTube(Length)
                        set newValue                [expr $HeadTube(Length) + $deltaHeadTube ]
                        set_Value                   $xpath     $newValue
                            #
                        return
                }
              
                {Length/TopTube/VirtualLength} {
                            # puts "  -> Length/TopTube/VirtualLength"
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            # puts "set_resultParameter   -> Length/TopTube/VirtualLength - check \$Geometry(TopTubeVirtual) $Geometry(TopTubeVirtual)"
                        set oldValue                $Geometry(TopTubeVirtual)
                            # set oldValue                $Geometry(TopTubeVirtual)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format]
                            # set _updateValue($xpath)    $newValue
                        set delta                   [expr $newValue - $oldValue]
                      
                            # --- set HandleBar(Distance)
                            #
                        set newValue                [ expr $HandleBar(Distance)    + $delta ]
                        set xpath                   Personal/HandleBar_Distance
                        set_Value $xpath            $newValue
                        return
                  }
              
                {Length/FrontWheel/horizontal} {
                            # puts "  -> Length/TopTube/VirtualLength"
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            # puts "set_resultParameter   -> Length/FrontWheel/horizontal - check \$Geometry(FrontWheel_x) $Geometry(FrontWheel_x)"
                        set oldValue                $Geometry(FrontWheel_x)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format]
                            # set _updateValue($xpath)    $newValue
                        set delta                   [expr $newValue - $oldValue]
                      
                            # --- set HandleBar(Distance)
                            #
                        set newValue                [ expr $HandleBar(Distance)    + $delta ]
                        set xpath                   Personal/HandleBar_Distance
                        set_Value $xpath            $newValue
                        return
                  }
              
                {Length/RearWheel/horizontal} {
                            # puts "  -> Length/TopTube/VirtualLength"
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            # puts "set_resultParameter   -> Length/FrontWheel/horizontal - check \$Geometry(RearWheel_X) $Geometry(RearWheel_X)"
                            # puts "set_resultParameter   -> Length/FrontWheel/horizontal - check \$BottomBracket(depth)  $BottomBracket(depth)"
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format]
                            # set _updateValue($xpath)    $newValue
                        set bbDepth                 $BottomBracket(Depth)
                      
                            # --- set HandleBar(Distance)
                            #
                        set newValue                [ expr { sqrt( $newValue * $newValue + $bbDepth * $bbDepth ) } ]
                        set Geometry(RearWheel_X)   $newValue
                        set xpath                   Custom/WheelPosition/Rear
                        set_Value                   $xpath     $Geometry(RearWheel_X)
                        return
                  }
              
                {Length/FrontWheel/diagonal} {
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            # puts "set_resultParameter   -> Length/FrontWheel/diagonal - check \$Geometry(FrontWheel_xy) $Geometry(FrontWheel_xy)"
                        set oldValue                $Geometry(FrontWheel_xy)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format]
                            # set _updateValue($xpath)    $newValue
                            # puts "                 <D> ... $oldValue $newValue"
              
                            # --- set HandleBar(Angle)
                            #
                        set vect_01     [ expr $Stem(Length) * cos($Stem(Angle) * $vectormath::CONST_PI / 180) ]
                        set vect_02     [ expr $vect_01 - $Fork(Rake) ]
                            #
                        set FW_Distance_X_tmp  [ expr { sqrt( $newValue * $newValue - $FrontWheel(Distance_Y) * $FrontWheel(Distance_Y) ) } ]
                        set FW_Position_tmp    [ list $FW_Distance_X_tmp $FrontWheel(Distance_Y)]
                            #
                        set help_03   [ vectormath::cathetusPoint    $HandleBar(Position)    $FW_Position_tmp    $vect_02  close ]
                        set vect_HT   [ vectormath::parallel      $help_03                  $FW_Position_tmp    $Fork(Rake) ]
                            # puts "                 <D> ... $vect_HT"
                            #
                        set help_01  [ lindex $vect_HT 0]
                        set help_02  [ lindex $vect_HT 1]
                        set help_03  [list -200 [ lindex $help_02 1] ]
                            #
                        set newValue                [vectormath::angle    $help_01 $help_02 $help_03 ]
                        set xpath                   Custom/HeadTube/Angle
                        set_Value                   $xpath     $newValue
                        return
                  }
              
                {Length/Saddle/Offset_HB} {
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            # puts "set_resultParameter   -> Length/Saddle/Offset_HB - check \$Geometry(Saddle_HB_y) $Geometry(Saddle_HB_y)"
                        set oldValue                $Geometry(Saddle_HB_y)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format ]
                            # set _updateValue($xpath)    $newValue
                
                        set delta                   [expr $oldValue - $newValue ]
                            # puts "          $newValue - $oldValue = $delta"
                
                            # --- set HandleBar(Distance)
                            #
                        set newValue                [expr $HandleBar(Height)    + $delta ]
                        set xpath                   Personal/HandleBar_Height
                        set_Value                   $xpath     $newValue
                        return
                  }
              
                {Length/Saddle/Offset_BB_ST} {
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format ]
                            # puts "set_resultParameter   -> Length/Saddle/Offset_BB_ST - check \$Saddle(SaddleHeight)  $Saddle(SaddleHeight) "
                        set height                  $Saddle(Height)
                        set angle                   [vectormath::dirAngle {0 0} [list $newValue $height] ]
                        set_resultParameter Result Angle/SeatTube/Direction $angle
                            # puts "   $newValue / $height -> $angle"
                        return
                  }
              
                {Length/Saddle/Offset_BB_Nose} {
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            # puts "set_resultParameter   -> Length/Saddle/Offset_BB_Nose - check \$Geometry(SaddleNose_BB_X) $Geometry(SaddleNose_BB_X)"
                        set oldValue                $Geometry(SaddleNose_BB_X)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format ]
                        set delta                   [expr -1.0 * ($newValue - $oldValue) ]
                
                            
                            # --- set Component(Saddle/LengthNose)
                            #
                            # puts "set_resultParameter   -> Length/Saddle/Offset_BB_Nose - check \$Rendering(SaddleOffset_X) $Rendering(SaddleOffset_X)"
                        set newValue                [expr $Saddle(Offset_X) + $delta ]
                        set Saddle(Offset_X)        $newValue
                        set xpath                   Rendering/Saddle/Offset_X
                        set_Value                   $xpath     $Saddle(Offset_X)                        
                            #
                        return
                  }

                {Length/Saddle/SeatTube_BB} {
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format ]
                        set oldValue                $Geometry(Saddle_BB)
                        set angle_SeatTube          $Geometry(SeatTube_Angle)
                        set pos_SeatTube_old        $Geometry(SeatTubeSaddle)
                        set pos_Saddle_old          $Saddle(Position)
                            #
                        set pos_SeatTube_x          [expr $newValue * cos([vectormath::rad $angle_SeatTube])]
                        set pos_SeatTube_y          [expr $newValue * sin([vectormath::rad $angle_SeatTube])]
                            #
                        set delta_Saddle_ST         [expr [lindex $pos_Saddle_old 0] - [lindex $pos_SeatTube_old 0]]
                            #
                        set pos_Saddle_x            [expr $pos_SeatTube_x - $delta_Saddle_ST]
                        set pos_Saddle_y            $pos_SeatTube_y
                        
                        # puts "  -> \$pos_SeatTube_old     $pos_SeatTube_old"
                        # puts "  -> \$pos_Saddle_old       $pos_Saddle_old"
                        # puts "  -> \$delta_Saddle_ST      $delta_Saddle_ST"
                        # puts "  -> \$pos_Saddle_x     $pos_Saddle_x"
                        # puts "  -> \$pos_Saddle_y     $pos_Saddle_y"
    
                        set Saddle(Distance)  [format "%.3f" $pos_Saddle_x]
                        set Saddle(Height)    [format "%.3f" $pos_Saddle_y]
                        set xpath                   Personal/Saddle_Distance
                        set_Value                   $xpath     $Saddle(Distance) 
                            #
                        bikeGeometry::update_Parameter
                            #                    
                        set xpath                   Personal/Saddle_Height
                        set_Value                   $xpath     $Saddle(Height)
                            #
                        return                      
                  }
                
                {Length/Personal/SaddleNose_HB}  {
                            # puts "set_resultParameter   -> Length/Personal/SaddleNose_HB - check \$Geometry(SaddleNose_HB)  $Geometry(SaddleNose_HB)"
                            # puts "set_resultParameter   -> Length/Personal/SaddleNose_HB - check \$HandleBar(Distance)  $HandleBar(Distance)"
                        set oldValue                $Geometry(SaddleNose_HB)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format ]
                        set delta                   [expr ($newValue - $oldValue) ]
                            
                            # --- set Personal(HandleBar_Distance)
                            #
                        set newValue                [expr $HandleBar(Distance) + $delta ]
                        set xpath                   Personal/HandleBar_Distance
                        set_Value                   $xpath     $newValue
                            #
                        return 
                  }
                  
                {Length/RearWheel/Radius} {
                            # puts "set_resultParameter   -> Length/RearWheel/Radius - check \$RearWheel(RimDiameter)  $RearWheel(RimDiameter)"
                            # puts "set_resultParameter   -> Length/RearWheel/Radius - check \$RearWheel(TyreHeight)   $RearWheel(TyreHeight)"
                        set rimDiameter       $RearWheel(RimDiameter)
                        set tyreHeight        $RearWheel(TyreHeight)
                        set newValue          [ expr $value - 0.5 * $rimDiameter]
                        set xpath             Component/Wheel/Rear/TyreHeight
                        set_Value             $xpath     $newValue
                            #
                        return                      
                  }
                {Length/RearWheel/TyreShoulder} {
                            # puts "set_resultParameter   -> Length/RearWheel/TyreShoulder - check \$RearWheel(Radius)  $RearWheel(Radius)"
                        set wheelRadius   $RearWheel(Radius)
                        set xpath         Component/Wheel/Rear/TyreWidthRadius
                        set newValue      [ expr $wheelRadius - abs($value)]
                        set_Value         $xpath     $newValue
                            #
                        return                      
                  }
                {Length/FrontWheel/Radius} {
                            # puts "set_resultParameter   -> Length/FrontWheel/Radius - check \$FrontWheel(RimDiameter)  $FrontWheel(RimDiameter)"
                            # puts "set_resultParameter   -> Length/FrontWheel/Radius - check \$FrontWheel(TyreHeight)   $FrontWheel(TyreHeight)"
                        set rimDiameter   $FrontWheel(RimDiameter)
                        set tyreHeight    $FrontWheel(TyreHeight)
                        set newValue      [ expr $value - 0.5 * $rimDiameter]
                        set xpath         Component/Wheel/Front/TyreHeight
                        set_Value         $xpath     $newValue
                            #
                        return                      
                  }
                  
                {Length/Reference/Heigth_SN_HB} {
                            # puts "   -> $_name"
                            # puts "set_resultParameter   -> Length/Reference/Heigth_SN_HB - check \$Reference(SaddleNose_HB_y)   $Reference(SaddleNose_HB_y)"
                            # puts "set_resultParameter   -> Length/Reference/Heigth_SN_HB - check \$Reference(HandleBar_Height)  $Reference(HandleBar_Height)"
                            # puts "set_resultParameter   -> Length/Reference/Heigth_SN_HB - check \$Reference(HandleBar_Height)  $Reference(HandleBar_Height)"
                        set oldValue                $Reference(SaddleNose_HB_y)
                        set newValue                $value
                            # set newValue                [set_Value [format "%s(%s)" $_array $_name]  $value format ]
                        set deltaValue              [expr $newValue - $oldValue]
                        set xpath                   Reference/HandleBar_Height
                        set HandleBar_Height        $Reference(HandleBar_Height)                              
                        set HandleBar_Height        [expr $HandleBar_Height - $deltaValue]  
                        set_Value         $xpath    $HandleBar_Height
                            #
                        return
                  } 
 
                {Length/Reference/SaddleNose_HB} {
                            # puts "set_resultParameter   -> Length/Reference/SaddleNose_HB - check \$Reference(SaddleNose_HB_y)  $Reference(SaddleNose_HB_y)"
                        set SaddleHeight            $Reference(SaddleNose_HB_y)
                        set newValue                $value
                            # set newValue                [set_Value [format "%s(%s)" $_array $_name]  $value format ]
                        set Distance_HB             [ expr { sqrt( $newValue * $newValue - $SaddleHeight * $SaddleHeight ) } ]
                        set xpath                   Reference/HandleBar_Distance
                        set_Value         $xpath    $Distance_HB
                            #
                        return
                  }
                  
      

                default {
                        puts "\n"
                        puts "     WARNING!"
                        puts "\n"
                        puts "        ... set_resultParameter:  "
                        puts "                 $xpath"
                        puts "            ... is not registered!"
                        puts "\n"
                        return
                  }
            }
    
    }
    #-------------------------------------------------------------------------
       #  check mathValue
    proc bikeGeometry::check_mathValue {value} {
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
    




