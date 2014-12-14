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
 #
  
    package require tdom
        #
    package provide bikeGeometry 1.10
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
            
            variable myFork          ; array set myFork          {}

            variable DEBUG_Geometry  ; array set DEBUG_Geometry  {}



            #-------------------------------------------------------------------------
                #  update loop and delay; store last value
            variable _updateValue   ; array set _updateValue    {}

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
            namespace export get_Option
            namespace export get_Component
                #
            namespace export get_ComponentDir 
            namespace export get_ComponentDirectories
            namespace export get_ListBoxValues 
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
                
            # --- compute geometry ----------------------
                #
            bikeGeometry::set_base_Parameters
              
                
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

    #-------------------------------------------------------------------------
        #  get Value
    proc bikeGeometry::get_Value {xpath type args} {
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
                        puts "   <W>.... bikeGeometry::get_Value $xpath $type $args"
                        # puts "\n"
                    }
        }
        
                
                
                
            # puts "   [namespace current]"
            # puts "   ... bikeGeometry::get_Value $xpath $type $args"
        return [project::getValue $xpath $type $args]
    }
        #  
    proc bikeGeometry::get_Scalar {object {key {File}}} {
            #
            # parray [namespace current]::$object
        set value  [lindex [array get [namespace current]::$object $key] 1]
        return $value    
            #
            # [array get $object $type] -> e.g. {RimDiameter 622.0} -> lindex 1
            # puts " .... $object/$type  ... $value"

 
        switch -glob $object {
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
                Lugs -
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
       

    #-------------------------------------------------------------------------
        #  get Object
    proc bikeGeometry::get_Object {object index {centerPoint {0 0}} } {
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
				            set returnValue    [bikeGeometry::get_Polygon $object $centerPoint]
                            return $returnValue
                        }

                position {
                            set returnValue    [bikeGeometry::get_Position $object $centerPoint]
                            return $returnValue
                        }

                direction {
                            set returnValue    [bikeGeometry::get_Direction $object]
                            return $returnValue
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
    proc bikeGeometry::get_Polygon {object centerPoint} {
                #
            variable Stem
            variable HeadSet
            variable RearFender
            variable FrontFender
            variable SeatPost
            variable TubeMiter
            variable ChainStay
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
                    historyComment              {branch "Components/$object/Polygon"}
                Stem                        {set polygon $Stem(Polygon)                 ; set branch "Components/Stem/Polygon"}
                HeadSet/Top                 {set polygon $HeadSet(PolygonTop)           ; set branch "Components/HeadSet/Top/Polygon"}
                HeadSet/Bottom              {set polygon $HeadSet(PolygonBottom)        ; set branch "Components/HeadSet/Bottom/Polygon"}
                Fender/Rear                 {set polygon $RearFender(Polygon)           ; set branch "Components/Fender/Rear/Polygon"}
                Fender/Front                {set polygon $FrontFender(Polygon)          ; set branch "Components/Fender/Front/Polygon"}
                SeatPost                    {set polygon $SeatPost(Polygon)             ; set branch "Components/SeatPost/Polygon"}
                    
                    historyComment              {branch "$object/Polygon"}
                TubeMiter/TopTube_Head      {set polygon $TubeMiter(TopTube_Head)       ; set branch "TubeMiter/TopTube_Head/Polygon"}
                TubeMiter/TopTube_Seat      {set polygon $TubeMiter(TopTube_Seat)       ; set branch "TubeMiter/TopTube_Seat/Polygon"}
                TubeMiter/DownTube_Head     {set polygon $TubeMiter(DownTube_Head)      ; set branch "TubeMiter/DownTube_Head/Polygon"}
                TubeMiter/DownTube_Seat     {set polygon $TubeMiter(DownTube_Seat)      ; set branch "TubeMiter/DownTube_Seat/Polygon"}
                TubeMiter/DownTube_BB_out   {set polygon $TubeMiter(DownTube_BB_out)    ; set branch "TubeMiter/DownTube_BB_out/Polygon"}
                TubeMiter/DownTube_BB_in    {set polygon $TubeMiter(DownTube_BB_in)     ; set branch "TubeMiter/DownTube_BB_in/Polygon"}
                TubeMiter/SeatTube_Down     {set polygon $TubeMiter(SeatTube_Down)      ; set branch "TubeMiter/SeatTube_Down/Polygon"}
                TubeMiter/SeatTube_BB_out   {set polygon $TubeMiter(SeatTube_BB_out)    ; set branch "TubeMiter/SeatTube_BB_out/Polygon"}
                TubeMiter/SeatTube_BB_in    {set polygon $TubeMiter(SeatTube_BB_in)     ; set branch "TubeMiter/SeatTube_BB_in/Polygon"}
                TubeMiter/SeatStay_01       {set polygon $TubeMiter(SeatStay_01)        ; set branch "TubeMiter/SeatStay_01/Polygon"}
                TubeMiter/SeatStay_02       {set polygon $TubeMiter(SeatStay_02)        ; set branch "TubeMiter/SeatStay_02/Polygon"}
                TubeMiter/Reference         {set polygon $TubeMiter(Reference)          ; set branch "TubeMiter/Reference/Polygon"}
                    
                    historyComment              {branch "Tubes/$object/Polygon"}
                ChainStay                   {set polygon $ChainStay(Polygon)            ; set branch "Tubes/ChainStay/Polygon"}
                ChainStay/RearMockup        {set polygon $ChainStay(Polygon_RearMockup) ; set branch "Tubes/ChainStay/RearMockup"}
                DownTube                    {set polygon $DownTube(Polygon)             ; set branch "Tubes/DownTube/Polygon"}
                ForkBlade                   {set polygon $ForkBlade(Polygon)            ; set branch "Tubes/ForkBlade/Polygon"}
                HeadTube                    {set polygon $HeadTube(Polygon)             ; set branch "Tubes/HeadTube/Polygon"}
                SeatStay                    {set polygon $SeatStay(Polygon)             ; set branch "Tubes/SeatStay/Polygon"}
                SeatTube                    {set polygon $SeatTube(Polygon)             ; set branch "Tubes/SeatTube/Polygon"}
                Steerer                     {set polygon $Steerer(Polygon)              ; set branch "Tubes/Steerer/Polygon"}
                TopTube                     {set polygon $TopTube(Polygon)              ; set branch "Tubes/TopTube/Polygon"}
 
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
            if {$polygon != {}} {
                 return [ vectormath::addVectorPointList  $centerPoint  $polygon] 
            } else {
                set svgList    [ project::getValue Result($branch)    polygon ]
                foreach xy $svgList {
                    foreach {x y} [split $xy ,] break
                    lappend returnValue $x $y
                }
                return [ vectormath::addVectorPointList  $centerPoint  $returnValue]
            }
    }
        #
    proc bikeGeometry::get_Position {object centerPoint} {
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
                    historyComment              {branch "Position/$object"}
                BottomBracket               {set position {0 0}                         ; set branch "Position/BottomBracket"}
                BottomBracketGround         {set position $BottomBracket(Ground)        ; set branch "Position/BottomBracketGround"}
                BrakeFront -
                FrontBrakeShoe              {set position $FrontBrake(Shoe)             ; set branch "Position/BrakeFront"}                
                FrontBrakeHelp              {set position $FrontBrake(Help)      }
                FrontBrakeDefinition        {set position $FrontBrake(Definition)}
                FrontBrake -
                FrontBrakeMount             {set position $FrontBrake(Mount)     }
                BrakeRear -
                RearBrakeShoe               {set position $RearBrake(Shoe)              ; set branch "Position/BrakeRear"}
                RearBrakeHelp               {set position $RearBrake(Help)       }
                RearBrakeDefinition         {set position $RearBrake(Definition) }
                RearBrake -
                RearBrakeMount              {set position $RearBrake(Mount)      }
                
                
                
                CarrierMountFront           {set position $FrontCarrier(Mount)          ; set branch "Position/CarrierMountFront"}
                CarrierMountRear            {set position $RearCarrier(Mount)           ; set branch "Position/CarrierMountRear"}
                DerailleurMountFront        {set position $FrontDerailleur(Mount)       ; set branch "Position/DerailleurMountFront"}
                FrontWheel                  {set position $FrontWheel(Position)         ; set branch "Position/FrontWheel"}          
                HandleBar                   {set position $HandleBar(Position)          ; set branch "Position/HandleBar"}
                LegClearance                {set position $Geometry(LegClearance)       ; set branch "Position/LegClearance"}
                RearWheel                   {set position $RearWheel(Position)          ; set branch "Position/RearWheel"}
                Reference_HB                {set position $Reference(HandleBar)         ; set branch "Position/Reference_HB"}
                Reference_SN                {set position $Reference(SaddleNose)        ; set branch "Position/Reference_SN"}
                Saddle                      {set position $Saddle(Position)             ; set branch "Position/Saddle"}
                SaddleNose                  {set position $Saddle(Nose)                 ; set branch "Position/SaddleNose"}
                SaddleProposal              {set position $Saddle(Proposal)             ; set branch "Position/SaddleProposal"}
                SeatPostPivot               {set position $SeatPost(PivotPosition)      ; set branch "Position/SeatPostPivot"}
                SeatPostSaddle              {set position $SeatPost(Saddle)             ; set branch "Position/SeatPostSaddle"}
                SeatPostSeatTube            {set position $SeatPost(SeatTube)           ; set branch "Position/SeatPostSeatTube"}
                SeatTubeGround              {set position $SeatTube(Ground)             ; set branch "Position/SeatTubeGround"}
                SeatTubeSaddle              {set position $Geometry(SeatTubeSaddle)     ; set branch "Position/SeatTubeSaddle"}
                SeatTubeVirtualTopTube      {set position $SeatTube(VirtualTopTube)     ; set branch "Position/SeatTubeVirtualTopTube"}
                SteererGround               {set position $Steerer(Ground)              ; set branch "Position/SteererGround"}
                SummarySize                 {set position $Geometry(SummarySize)        ; set branch "Position/SummarySize"}
                
                    historyComment              {branch  "$object"}
                RearDerailleur -
                Lugs/Dropout/Rear/Derailleur {
                                             # set position $Lugs(RearDropout_Derailleur) ; set branch "Lugs/Dropout/Rear/Derailleur"
                                             set position $RearDropout(DerailleurPosition) ; set branch "Lugs/Dropout/Rear/Derailleur" }

                    historyComment              {branch "$object/Position"     Lugs/*}
                RearDropout -
                Lugs/Dropout/Rear           {set position $RearDropout(Position)        ; set branch "Lugs/Dropout/Rear/Position"}
                FrontDropout -
                Lugs/Dropout/Front          {set position $Fork(Dropout)                ; set branch "Lugs/Dropout/Front/Position"}
                ForkCrown -
                Lugs/ForkCrown              {set position $Steerer(Fork)                ; set branch "Lugs/ForkCrown/Position"}

                    historyComment              {branch "Tubes/$object"}
                ChainStay/SeatStay_IS       {set position $ChainStay(SeatStay_IS)       ; set branch "Tubes/ChainStay/SeatStay_IS"}
                DownTube/BottleCage/Base    {set position $DownTube(BottleCage_Base)    ; set branch "Tubes/DownTube/BottleCage/Base"}        
                DownTube/BottleCage_Lower/Base      {set position $DownTube(BottleCage_Lower_Base)  ; set branch "Tubes/DownTube/BottleCage_Lower/Base"}   
                DownTube/BottleCage_Lower/Offset    {set position $DownTube(BottleCage_Lower_Offset); set branch "DownTube/BottleCage_Lower/Offset"}   
                DownTube/BottleCage/Offset  {set position $DownTube(BottleCage_Offset)  ; set branch "Tubes/DownTube/BottleCage/Offset"}
                DownTubeEnd -
                DownTube/End                {set position $DownTube(HeadTube)           ; set branch "Tubes/DownTube/End"}
                DownTubeStart -
                DownTube/Start              {set position $DownTube(BottomBracket)      ; set branch "Tubes/DownTube/Start"}
                HeadTubeEnd -
                HeadTube/End                {set position $HeadTube(Stem)               ; set branch "Tubes/HeadTube/End"}
                HeadTubeStart -
                HeadTube/Start              {set position $HeadTube(Fork)               ; set branch "Tubes/HeadTube/Start"}
                SeatStay/End - 
                SeatStayEnd                 {set position $SeatStay(SeatTube)           ; set branch "Tubes/SeatStay/End"}
                SeatStay/Start -
                SeatStayStart               {set position $SeatStay(RearWheel)          ; set branch "Tubes/SeatStay/Start"}
                SeatTube/BottleCage/Base    {set position $SeatTube(BottleCage_Base)    ; set branch "Tubes/SeatTube/BottleCage/Base"}
                SeatTube/BottleCage/Offset  {set position $SeatTube(BottleCage_Offset)  ; set branch "Tubes/SeatTube/BottleCage/Offset"}
                SeatTube/End -
                SeatTubeEnd                 {set position $SeatTube(TopTube)            ; set branch "Tubes/SeatTube/End"}
                SeatTube/Start -
                SeatTubeStart               {set position $SeatTube(BottomBracket)      ; set branch "Tubes/SeatTube/Start"}
                Steerer/End -
                SteererEnd                  {set position $Steerer(Stem)                ; set branch "Tubes/Steerer/End"}
                Steerer/Start -
                SteererStart                {set position $Steerer(Fork)                ; set branch "Tubes/Steerer/Start"}
                TopTube/End -
                TopTubeEnd                  {set position $TopTube(HeadTube)            ; set branch "Tubes/TopTube/End"}
                TopTube/Start -
                TopTubeStart                {set position $TopTube(SeatTube)            ; set branch "Tubes/TopTube/Start"} 

                ChainStayRearMockup -
                ChainStay/RearMockup        {set position $ChainStay(RearMockupStart)   ; set branch "Tubes/ChainStay/RearMockup/Start"}

                default { puts "   <E> ... bikeGeometry::get_Position \$object $object"
                            # set branch "Tubes/$object"
                        }                        
                        
            }
                #
                # puts "    ... $branch"
                #
            if {$position != {}} {
                return [ vectormath::addVector  $centerPoint  $position] 
            } else {
                set pointValue    [ project::getValue Result($branch)    position ]    ; # puts "    ... $pointValue"
                foreach xy $pointValue {
                    foreach {x y} [split $xy ,] break
                    lappend returnValue $x $y    ; # puts "    ... $returnValue"
                }
                return [ vectormath::addVectorPointList  $centerPoint  $returnValue]
            }
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
            # puts " -> $object $type -> ..." 
                #
                # IMPORTANT: ... set direction {0 0} ... these values are not updated from bikeGeometry !!! 2014 11 01
                #
            switch -glob $object {
                    historyComment              {branch "$object/Direction/polar"   Lugs/*}
                RearDropout         {set direction {0 0}
                                            # set direction $RearDropout(Direction) ; 
                                        set branch Lugs/Dropout/Rear/Direction}
                Lugs/Dropout/Rear   {set direction {0 0}                        
                                        set branch Lugs/Dropout/Rear/Direction
                                            # these value is currently updated by bikeGeometry 2014 11 01 !!! 
                                    }
                ForkDropout -
                Lugs/Dropout/Front  {set direction $Fork(DropoutDirection)  ; set branch Lugs/Dropout/Front/Direction}
                ForkCrown -
                Lugs/ForkCrown      {set direction $Fork(CrownDirection)    ; set branch Lugs/ForkCrown/Direction}       
                
                    historyComment              {branch "Tubes/$object/Direction/polar"}
                ChainStay           {set direction $ChainStay(Direction)    ; set branch "Tubes/ChainStay/Direction/polar"}
                DownTube            {set direction $DownTube(Direction)     ; set branch "Tubes/DownTube/Direction/polar"}
                HeadTube            {set direction $HeadTube(Direction)     ; set branch "Tubes/HeadTube/Direction/polar"}
                SeatStay            {set direction $SeatStay(Direction)     ; set branch "Tubes/SeatStay/Direction/polar"}
                SeatTube            {set direction $SeatTube(Direction)     ; set branch "Tubes/SeatTube/Direction/polar"}
                Steerer             {set direction $Steerer(Direction)      ; set branch "Tubes/Steerer/Direction/polar"}
                TopTube             {set direction $TopTube(Direction)      ; set branch "Tubes/TopTube/Direction/polar"}
                
                
                default { puts "   <E> ... bikeGeometry::get_Direction \$object $object"
                        # set branch "Tubes/$object/Direction/polar"
                    }
            }
                #
            #puts " -> $object $type -> $direction"
                #
            if {$direction == {}} {  
                puts "    <W> ... get_Direction $branch"
                set directionValue    [ project::getValue Result($branch)    direction ]    ; # puts "    ... $directionValue"
                foreach xy $directionValue {
                    foreach {x y} [split $xy ,] break
                    lappend returnValue $x $y   ; # puts "    ... $returnValue"
                }
                return $returnValue

                return -1
            }
            # return $direction    
                #
            switch -exact $type {
                degree  {   return [vectormath::angle {1 0} {0 0} $direction] }
                rad    -
                polar  -
                default {   return $direction}
            }
            
           
                
                
                
                
                
                #
                # puts "    ... $branch"
                #
            if {$direction != {}} {
                 return $direction
            } else {
                set directionValue    [ project::getValue Result($branch)    direction ]    ; # puts "    ... $directionValue"
                foreach xy $directionValue {
                    foreach {x y} [split $xy ,] break
                    lappend returnValue $x $y   ; # puts "    ... $returnValue"
                }
                return $returnValue
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
    proc bikeGeometry::get_Option {object} {
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
    
	#-------------------------------------------------------------------------
        #  return all listBox-values
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

    #-------------------------------------------------------------------------
        #  sets and format Value
    proc bikeGeometry::set_Value {xpath value {mode {update}}} {
     
              # xpath: e.g.:Custom/BottomBracket/Depth
              
            variable         _updateValue
         
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
            if {$mode == {force}} { 
                eval set [format "project::%s(%s)" $_array $_name] $value
                bikeGeometry::set_base_Parameters
                return $value
            }              
                
            # --- exception for Result - Values ---
                #  ... loop over set_resultParameter
                #    if there is a Result to set
                #             
            if {$mode == {update}} {
                # puts "  ... setValue: $xpath"
                switch -glob $_array {
                    {Result} {
                        set newValue [ string map {, .} $value]
                        # puts "\n  ... setValue: ... Result/..."
                        set_resultParameter $_array $_name $newValue
                        return
                    }
                    default {}
                }
            }
            
			# --- all the exceptions done ---
                # on int list values like defined
                # puts "<D> $xpath"
            switch $xpath {
                {Component/Wheel/Rear/RimDiameter} -
                {Component/Wheel/Front/RimDiameter} -
                {Lugs/RearDropOut/Direction} {
                        set newValue    $value
                        project::setValue [format "%s(%s)" $_array $_name] value $newValue
                        bikeGeometry::set_base_Parameters  
                        return $newValue
                    }
         
                {Component/CrankSet/ChainRings} -
                {Component/Wheel/Rear/FirstSprocket} {
                        set newValue [ string map {, .} $value]
                            # puts " <D> $newValue"
                        if {$mode == {update}} {
                            project::setValue [format "%s(%s)" $_array $_name] value $newValue
                        }
                        bikeGeometry::set_base_Parameters  
                        return $newValue
                    }                         
         
                default { }
            }
         
            
            # --- exceptions without any format-checks
            # on int list values like defined
            # puts "<D> $xpath"
        
                # --- set new Value
            set newValue [ string map {, .} $value]
                # --- check Value --- ";" ... like in APPL_RimList
            set newValue [lindex [split $newValue ;] 0]
                # --- check Value --- update
            if {$mode == {update}} {
                set _updateValue($xpath) $newValue
            }
         
             
            # --- update or return on errorID
            set checkValue {mathValue}
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
                if { [catch { set newValue [expr 1.0 * $newValue] } errorID] } {
                    puts "\n$errorID\n"
                    return
                } else {
                    set newValue [format "%.3f" $newValue]
                }
            }
            
			
            # ---------------------------
                #  just return Parameter if required 
                #       ... by mode: format
                #
            if {$mode != {update}} {
                return $newValue
            }
            
    
            # --------------------------------------
                #  at least update Geometry
                #   ... if not left earlier
                #
            project::setValue [format "%s(%s)" $_array $_name] value $newValue
            bikeGeometry::set_base_Parameters			 
			
                # puts "" 
                # puts "    setValue:  $argv\n" 
                # puts "                [format "%s(%s)" $_array $_name] vs $xpath "
            return $newValue
    }

    #-------------------------------------------------------------------------
       #  handle modification on /root/Result/... values
    proc bikeGeometry::set_resultParameter {_array _name value} {
    
            variable         _updateValue
        
              # puts ""
              # puts "   -------------------------------"
              # puts "    set_resultParameter"
              # puts "       _array:          $_array"
              # puts "       _name:           $_name"
              # puts "       value:           $value"
        
            variable Geometry
            variable Rendering
            variable Reference
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
                      set oldValue                $BottomBracket(height)
                      set newValue                [set_Value $xpath  $value format]
                      set _updateValue($xpath)    $newValue
                      set delta                   [expr $newValue - $oldValue]
                        # puts "   ... oldValue:   $oldValue"
                        # puts "   ... newValue:   $newValue"
                        # puts "   ...... delta:   $delta"
              
                        # --- update value
                        #
                      set xpath                   Custom/BottomBracket/Depth
                      set oldValue                $BottomBracket(Depth)
                      set newValue                [expr $oldValue - $delta ]
                      set_Value                   $xpath     $newValue
                      return
                  }
              
                {Angle/HeadTube/TopTube} {
                      # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                      set HeadTopTube_Angle       [set_Value $xpath  $value format]
                      set _updateValue($xpath)    $HeadTopTube_Angle
                        # puts "          \$HeadTopTube_Angle  = $HeadTopTube_Angle"
                  
                        # --- update value
                        #
                        # puts "set_resultParameter   -> Angle/HeadTube/TopTube - check \$HeadTube(Angle) $HeadTube(Angle)"
                      set value                   [expr $HeadTopTube_Angle - $HeadTube(Angle)]
                      set xpath                   Custom/TopTube/Angle
                      set_Value                   $xpath     $value
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
                        # puts "set_resultParameter   -> Length/SeatTube/VirtualLength - check \$SeatTube(VirtualLength) $SeatTube(VirtualLength))"
                        # puts "set_resultParameter   -> Length/SeatTube/VirtualLength - check \$Geometry(SeatTube_Angle) $Geometry(SeatTube_Angle))"
                        # puts "set_resultParameter   -> Length/SeatTube/VirtualLength - check \$HeadTube(Angle) $HeadTube(Angle))"
                      set oldValue                $Geometry(SeatTube_VirtualLength)
                      # set oldValue                $SeatTube(VirtualLength)
                      set newValue                [set_Value $xpath  $value format]
                      set _updateValue($xpath)    $newValue
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
                      set_Value                   $xpath     $newValue
                        #
                      return
                }
              
                {Length/HeadTube/ReachLength} {
                        # puts "set_resultParameter   -> Length/HeadTube/ReachLength - check \$Geometry(ReachLengthResult) $Geometry(ReachLengthResult)"
                        # puts "set_resultParameter   -> Length/HeadTube/ReachLength - check \$HandleBar(Distance) $HandleBar(Distance)"
                      set oldValue                $Geometry(ReachLengthResult)
                      set newValue                [set_Value $xpath  $value format]
                      set _updateValue($xpath)    $newValue
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
                      set newValue                [set_Value $xpath  $value format]
                      set _updateValue($xpath)    $newValue
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
                        # puts "set_resultParameter   -> Length/TopTube/VirtualLength - check \$TopTube(VirtualLength) $TopTube(VirtualLength)"
                      set oldValue                $Geometry(TopTube_VirtualLength)
                      # set oldValue                $TopTube(VirtualLength)
                      set newValue                [set_Value $xpath  $value format]
                      set _updateValue($xpath)    $newValue
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
                      set newValue                [set_Value $xpath  $value format]
                      set _updateValue($xpath)    $newValue
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
                      set newValue                [set_Value $xpath  $value format]
                      set _updateValue($xpath)    $newValue
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
                      set newValue                [set_Value $xpath  $value format]
                      set _updateValue($xpath)    $newValue
                        # puts "                 <D> ... $oldValue $newValue"
              
                        # --- set HandleBar(Angle)
                        #
                      set vect_01     [ expr $Stem(Length) * cos($Stem(Angle) * $vectormath::CONST_PI / 180) ]
                      set vect_02     [ expr $vect_01 - $Fork(Rake) ]
              
                      set FW_Distance_X_tmp  [ expr { sqrt( $newValue * $newValue - $FrontWheel(Distance_Y) * $FrontWheel(Distance_Y) ) } ]
                      set FW_Position_tmp    [ list $FW_Distance_X_tmp $FrontWheel(Distance_Y)]
              
                      set help_03   [ vectormath::cathetusPoint    $HandleBar(Position)    $FW_Position_tmp    $vect_02  close ]
                      set vect_HT   [ vectormath::parallel      $help_03                  $FW_Position_tmp    $Fork(Rake) ]
                        # puts "                 <D> ... $vect_HT"
              
                      set help_01  [ lindex $vect_HT 0]
                      set help_02  [ lindex $vect_HT 1]
                      set help_03  [list -200 [ lindex $help_02 1] ]
              
                      set newValue                [vectormath::angle    $help_01 $help_02 $help_03 ]
                      set xpath                   Custom/HeadTube/Angle
                      set_Value                   $xpath     $newValue
                      return
                  }
              
                {Length/Saddle/Offset_HB} {
                        # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                        # puts "set_resultParameter   -> Length/Saddle/Offset_HB - check \$Geometry(Saddle_HB_y) $Geometry(Saddle_HB_y)"
                      set oldValue                $Geometry(Saddle_HB_y)
                      set newValue                [set_Value $xpath  $value format ]
                      set _updateValue($xpath)    $newValue
              
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
                      set newValue                [set_Value $xpath  $value format ]
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
                      set newValue                [set_Value $xpath  $value format ]
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
                      set newValue                [set_Value $xpath  $value format ]
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
                      set_base_Parameters
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
                      set newValue                [set_Value $xpath  $value format ]
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
                      set newValue                [set_Value [format "%s(%s)" $_array $_name]  $value format ]
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
                      set newValue                [set_Value [format "%s(%s)" $_array $_name]  $value format ]
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
    proc bikeGeometry::coords_get_xy {coordlist index} {
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
    




