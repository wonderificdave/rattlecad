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
 package provide bikeGeometry 0.27

 namespace eval bikeGeometry {

            # --------------------------------------------
                # initial package definition
            package require tdom

        
            # --------------------------------------------
                # Export as global command
            variable packageHomeDir [file normalize [file join [pwd] [file dirname [info script]]] ]
            
            
            #-------------------------------------------------------------------------
                #  definitions of template parameter
            variable initDOM
            variable projectDOM
        
        
            #-------------------------------------------------------------------------
                #  current Project Values
                # variable BaseCenter        ; array set BaseCenter        {}
            variable Project        ; array set Project         {}

            variable RearWheel      ; array set RearWheel       {}
            variable FrontWheel     ; array set FrontWheel      {}
            variable BottomBracket  ; array set BottomBracket   {}
            variable Saddle         ; array set Saddle          {}
            variable SeatPost       ; array set SeatPost        {}
            variable HandleBar      ; array set HandleBar       {}
            variable LegClearance   ; array set LegClearance    {}

            variable HeadTube       ; array set HeadTube        {}
            variable SeatTube       ; array set SeatTube        {}
            variable DownTube       ; array set DownTube        {}
            variable TopTube        ; array set TopTube         {}
            variable ChainStay      ; array set ChainStay       {}
            variable SeatStay       ; array set SeatStay        {}
            variable Steerer        ; array set Steerer         {}
            variable ForkBlade      ; array set ForkBlade       {}

            variable Fork           ; array set Fork            {}
            variable Stem           ; array set Stem            {}
            variable HeadSet        ; array set HeadSet         {}
            variable RearDrop       ; array set RearDrop        {}

            variable BottleCage     ; array set BottleCage      {}
            variable FrameJig       ; array set FrameJig        {}
            variable TubeMiter      ; array set TubeMiter       {}
            
            variable myFork         ; array set myFork          {}

            variable DEBUG_Geometry ; array set DEBUG_Geometry    {}



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
        #  load newProject
        #
        #  ... loads a new project given by a XML-Project as rootNode
        #
    proc set_newProject {_projectDOM} {

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
            return [project::runTime_2_dom]
    }
    #-------------------------------------------------------------------------
        #  get current projectDOM as XML
    proc get_projectXML {} {
            return [project::runTime_2_dom]
    }
    
    #-------------------------------------------------------------------------
        #  get current projectDOM as XML
    proc get_projectDICT {} {
            return [project::runTime_2_dict]
    }

    
    #-------------------------------------------------------------------------
        #  init Fork Configuration
        #  ... 
        #
    proc set_forkConfig {_forkDOM} {
            project::add_forkSetting $_forkDOM
    }
    #-------------------------------------------------------------------------
        #  get Value
    proc get_Value {xpath type args} {
        return [project::getValue $xpath $type $args]
    }
    #-------------------------------------------------------------------------
        #  return all geometry-values to create specified tube in absolute position
    proc get_Object {object index {centerPoint {0 0}} } {
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

                polygon    {    set returnValue    {}
                            switch -exact $object {
                                Stem             -
                                HeadSet/Top     -
                                HeadSet/Bottom     -
                                SeatPost     {
                                                set branch "Components/$object/Polygon"
                                            }

                                TubeMiter/TopTube_Head -
                                TubeMiter/TopTube_Seat -
                                TubeMiter/DownTube_Head -
                                TubeMiter/SeatStay_01    -
                                TubeMiter/SeatStay_02    -
                                TubeMiter/Reference {
                                                set branch "$object/Polygon"    ; # puts " ... $branch"
                                            }

                                default     {
                                                set branch "Tubes/$object/Polygon"
                                            }
                            }
                                # puts "    ... $branch"
                            set svgList    [ project::getValue Result($branch)    polygon ]
                            foreach xy $svgList {
                                foreach {x y} [split $xy ,] break
                                lappend returnValue $x $y
                            }
                            return [ vectormath::addVectorPointList  $centerPoint  $returnValue]
                        }

                position {
                            set returnValue    {}
                            switch -glob $object {
                                BottomBracket -
                                FrontWheel -
                                RearWheel -
                                Saddle -
                                SeatPostSaddle -
                                SeatPostSeatTube -
                                SaddleProposal -
                                HandleBar -
                                LegClearance -
                                BottomBracketGround -
                                SteererGround -
                                SeatTubeGround -
                                SeatTubeVirtualTopTube -
                                SeatTubeSaddle -
                                BrakeFront -
                                BrakeRear -
                                DerailleurMountFront -
                                SummarySize {
                                            set branch "Position/$object"
                                        }
                                
                                Lugs/Dropout/Rear/Derailleur {
                                            set branch "$object"
                                        }

                                Lugs/* {
                                            set branch "$object/Position"    ; # puts " ... $branch"
                                        }


                                default {
                                            # puts "   ... \$object $object"
                                            set branch "Tubes/$object"
                                        }
                            }

                            set pointValue    [ project::getValue Result($branch)    position ]    ; # puts "    ... $pointValue"

                            foreach xy $pointValue {
                                foreach {x y} [split $xy ,] break
                                lappend returnValue $x $y    ; # puts "    ... $returnValue"
                            }
                            return [ vectormath::addVectorPointList  $centerPoint  $returnValue]
                        }

                direction {
                            set returnValue    {}
                                # puts " ... $object"
                            switch -glob $object {
                                    Lugs/* {
                                            set branch "$object/Direction/polar"    ; # puts " ... $branch"
                                        }

                                    default {
                                            set branch "Tubes/$object/Direction/polar"
                                        }
                            }

                            set directionValue    [ project::getValue Result($branch)    direction ]    ; # puts "    ... $directionValue"
                            foreach xy $directionValue {
                                foreach {x y} [split $xy ,] break
                                lappend returnValue $x $y   ; # puts "    ... $returnValue"
                            }
                            return $returnValue
                        }

                default    {             puts "   ... object_values $object $index"
                            #eval set returnValue $[format "frameCoords::%s(%s)" $object $index]
                            #return [ coords_addVector  $returnValue  $centerPoint]
                        }
            }
    }
    #-------------------------------------------------------------------------
        #  sets and format Value
    proc set_projectValue_renamed {xpath value {mode {update}}} {}
    #-------------------------------------------------------------------------
        #  sets and format Value
    proc set_Value {xpath value {mode {update}}} {
     
               # xpath: e.g.:Custom/BottomBracket/Depth
               
             variable         _updateValue
         
             #puts ""
             #puts "   -------------------------------"
             #puts "    setValue"
             #puts "       xpath:           $xpath"
             #puts "       value:           $value"
             #puts "       mode:            $mode"
         
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
                 puts "   ... Rendering: $xpath "
                 puts "        ... $value [file tail $xpath]"
             }
         
             puts "               ... checkValue: $checkValue "
         
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
    proc set_resultParameter {_array _name value} {
    
            variable         _updateValue
        
            puts ""
            puts "   -------------------------------"
            puts "    set_resultParameter"
            puts "       _array:          $_array"
            puts "       _name:           $_name"
            puts "       value:           $value"
        
            variable BottomBracket
            variable HandleBar
            variable Saddle
            variable SeatPost
            variable SeatTube
            variable HeadTube
            variable FrontWheel
            variable Fork
            variable Stem
        
        
            set xpath "$_array/$_name"
            puts "       xpath:           $xpath"
        
            switch -glob $_name {
        
                {Length/BottomBracket/Height}    {
                      # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                      set oldValue                $project::Result(Length/BottomBracket/Height)
                      # 3.2.76 set oldValue       $project::Temporary(BottomBracket/Height)
                      set newValue                [set_Value $xpath  $value format]
                      set _updateValue($xpath)    $newValue
                      set delta                   [expr $newValue - $oldValue]
                        # puts "   ... oldValue:   $oldValue"
                        # puts "   ... newValue:   $newValue"
                        # puts "   ...... delta:   $delta"
              
                        # --- update value
                        #
                      set xpath                   Custom/BottomBracket/Depth
                      set oldValue                $project::Custom(BottomBracket/Depth)
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
                      set HeadTube_Angle          $project::Custom(HeadTube/Angle)
                      set value                   [expr $HeadTopTube_Angle - $HeadTube_Angle]
                      set xpath                   Custom/TopTube/Angle
                      set_Value                   $xpath     $value
                      return
                  }
              
                {Angle/SeatTube/Direction} {
                          # puts "\n"
                          # puts "  ... Angle/SeatTube/Direction comes here: $value"
                          # puts ""
                      set oldValue        $project::Result(Angle/SeatTube/Direction)
                      set SP_Setback      [project::getValue Component(SeatPost/Setback)   value]
                      set length_Setback  [expr $SP_Setback * sin([vectormath::rad $value])]
                      set height_Setback  [expr $SP_Setback * cos([vectormath::rad $value])]
                        # puts "    -> value $value"
                        # puts "    -> oldValue $oldValue"
                        # puts "    -> SP_Setback $SP_Setback"
                        # puts "    -> length_Setback $length_Setback"
                        # puts "    -> height_Setback $height_Setback"
                      set ST_height       [expr [project::getValue Personal(Saddle_Height)   value] - [project::getValue Component(Saddle/Height)   value] + $height_Setback]
                      set length_SeatTube [expr $ST_height / tan([vectormath::rad $value])]
                        # puts "    -> ST_height $ST_height"
                        # puts "    -> length_SeatTube $length_SeatTube"
                  
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
                      set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                      set newValue                [set_Value $xpath  $value format]
                      set _updateValue($xpath)    $newValue
                      set delta                   [expr $newValue - $oldValue]
              
                      set offsetSeatTube          [vectormath::rotateLine {0 0} $delta [expr 180 - $project::Result(Angle/SeatTube/Direction)]]
                      set offsetSeatTube_x        [lindex $offsetSeatTube 0]
                        # puts "   -> $offsetSeatTube"
                  
                        # HeadTube Offset - horizontal
                        #
                      set deltaHeadTube           [expr [lindex $offsetSeatTube 1] / sin($project::Custom(HeadTube/Angle) * $vectormath::CONST_PI / 180) ]
                      set offsetHeadTube_x        [expr [lindex $offsetSeatTube 1] / tan($project::Custom(HeadTube/Angle) * $vectormath::CONST_PI / 180) ]
              
                        # HeadTube Offset - horizontal & length
                        #
                        # project::remove_tracing ; #because of setting more then one parameter at once
                        #
                      set xpath                   Personal/HandleBar_Distance
                      set newValue                [expr $HandleBar(Distance)    + $offsetHeadTube_x + $offsetSeatTube_x]
                      set_Value                   $xpath     $newValue
                        #
                      set xpath                   FrameTubes/HeadTube/Length
                      set newValue                [expr $HeadTube(Length)    + $deltaHeadTube]
                      set_Value                   $xpath     $newValue
                        #
                        # project::add_tracing
                      set_Value                   $xpath     $newValue
                        #
                      return
                }
              
                {Length/HeadTube/ReachLength} {
                      set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                      set newValue                [set_Value $xpath  $value format]
                      set _updateValue($xpath)    $newValue
                      set delta                   [expr $newValue - $oldValue]
              
                      set xpath                   Personal/HandleBar_Distance
                      set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                      set newValue                [expr $HandleBar(Distance)    + $delta]
                      set_Value                   $xpath     $newValue
                      return
                }
              
                {Length/HeadTube/StackHeight} {
                      set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                      set newValue                [set_Value $xpath  $value format]
                      set _updateValue($xpath)    $newValue
                      set delta                   [expr $newValue - $oldValue]
              
                      set deltaHeadTube           [expr $delta / sin($project::Custom(HeadTube/Angle) * $vectormath::CONST_PI / 180) ]
                      set offsetHeadTube_x        [expr $delta / tan($project::Custom(HeadTube/Angle) * $vectormath::CONST_PI / 180) ]
              
                        # puts "==================="
                        # puts "    delta             $delta"
                        # puts "    deltaHeadTube     $deltaHeadTube"
                        # puts "    offsetHeadTube_x  $offsetHeadTube_x"
                  
                        #
                        # project::remove_tracing ; #because of setting two parameters at once
                        #
                      set xpath                   Personal/HandleBar_Height
                      set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                      set newValue                [expr $HandleBar(Height)    + $delta]
                      set_Value                   $xpath      $newValue
                        #
                        # project::add_tracing
                        #
                      set xpath                   FrameTubes/HeadTube/Length
                      set oldValue                $project::FrameTubes(HeadTube/Length)
                      set newValue                [expr $project::FrameTubes(HeadTube/Length) + $deltaHeadTube ]
                      set_Value                   $xpath     $newValue
                    #
                      return
                }
              
                {Length/TopTube/VirtualLength}            -
                {Length/FrontWheel/horizontal} {
                      # puts "  -> Length/TopTube/VirtualLength"
                      # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                      set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                      # set oldValue              [ [ $domProject selectNodes $xpath  ]    asText ]
                      set newValue                [set_Value $xpath  $value format]
                      set _updateValue($xpath)    $newValue
                      set delta                   [expr $newValue - $oldValue]
              
                    # --- set HandleBar(Distance)
                    #
                      set newValue                [ expr $HandleBar(Distance)    + $delta ]
                      set xpath                   Personal/HandleBar_Distance
                      set_Value $xpath     $newValue
                      return
                  }
              
                {Length/RearWheel/horizontal} {
                          # puts "  -> Length/TopTube/VirtualLength"
                          # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                          #set oldValue               [project::getValue [format "%s(%s)" $_array $_name] value]
                          # set oldValue              [ [ $domProject selectNodes $xpath  ]    asText ]
                      set newValue                [set_Value $xpath  $value format]
                      set _updateValue($xpath)    $newValue
                          #set delta                  [expr $newValue - $oldValue]
                      set bbDepth                 $project::Custom(BottomBracket/Depth)
              
                    # --- set HandleBar(Distance)
                    #
                      set newValue                [ expr { sqrt( $newValue * $newValue + $bbDepth * $bbDepth ) } ]
                      set xpath                   Custom/WheelPosition/Rear
                      set_Value                   $xpath     $newValue
                      return
                  }
              
                {Length/FrontWheel/diagonal}    {
                        # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                      set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                        # set oldValue              [ [ $domProject selectNodes $xpath  ]    asText ]
                      set newValue                [set_Value $xpath  $value format]
                      set _updateValue($xpath)    $newValue
                        # puts "                 <D> ... $oldValue $newValue"
              
                    # --- set HandleBar(Angle)
                    #
                      set vect_01     [ expr $Stem(Length) * cos($Stem(Angle) * $vectormath::CONST_PI / 180) ]
                      set vect_02     [ expr $vect_01 - $Fork(Rake) ]
              
                      set FrontWheel(Distance_X_tmp)  [ expr { sqrt( $newValue * $newValue - $FrontWheel(Distance_Y) * $FrontWheel(Distance_Y) ) } ]
                      set FrontWheel(Position_tmp)    [ list $FrontWheel(Distance_X_tmp) $FrontWheel(Distance_Y)]
              
                      set help_03   [ vectormath::cathetusPoint    $HandleBar(Position)    $FrontWheel(Position_tmp)    $vect_02  close ]
                      set vect_HT   [ vectormath::parallel      $help_03                  $FrontWheel(Position_tmp)    $Fork(Rake) ]
                        # puts "                 <D> ... $vect_HT"
              
                      set help_01  [ lindex $vect_HT 0]
                      set help_02  [ lindex $vect_HT 1]
                      set help_03  [list -200 [ lindex $help_02 1] ]
              
                      set newValue                [vectormath::angle    $help_01 $help_02 $help_03 ]
                      set xpath                   Custom/HeadTube/Angle
                      set_Value                   $xpath     $newValue
                      return
                  }
              
                {Length/Saddle/Offset_HB}    {
                        # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                      set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value ]
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
              
                {Length/Saddle/Offset_BB_ST}    {
                        # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                      set newValue                [set_Value $xpath  $value format ]
                      set height                  [project::getValue [format "%s(%s)" Personal Saddle_Height] value ]
                      set angle                   [vectormath::dirAngle {0 0} [list $newValue $height] ]
              
                      set_resultParameter Result Angle/SeatTube/Direction $angle
              
                        # puts "   $newValue / $height -> $angle"
                      return
                  }
              
                {Length/Saddle/Offset_BB_Nose}    {
                        # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                      set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value ]
                      set newValue                [set_Value $xpath  $value format ]
                      set delta                   [expr -1.0 * ($newValue - $oldValue) ]
              
                        # --- set HandleBar(Distance)
                        #
                      set newValue                [expr $project::Component(Saddle/LengthNose) + $delta ]
                      set xpath                   Component/Saddle/LengthNose
                      set_Value                   $xpath     $newValue
                      return
                  }
                  
                {Length/Control/HandleBar_FW}  {
                      set side_a                  $value
                      set side_b                  $project::Result(Length/Control/HandleBar_BB)
                      set side_c                  $project::Result(Length/FrontWheel/diagonal)

                      set angle                   [vectormath::angle_Triangle $side_a $side_b $side_c]
                      set newPos                  [vectormath::rotatePoint {0 0} $FrontWheel(Position) $angle]
                      set newPos                  [vectormath::unifyVectorPointList [list {0 0} $newPos] ]
                      set newPos                  [vectormath::unifyVectorPointList [list {0 0} $newPos] $side_b]

                      foreach {x y} $newPos break
                      set xpath                   Personal/HandleBar_Distance)
                      set_Value                   $xpath     [format "%.3f" $x]
                      set xpath                   Personal/HandleBar_Height)
                      set_Value                   $xpath     [format "%.3f" $y]
                                                              
                      set_resultParameter         Result     Length/FrontWheel/diagonal   $side_c

                      return
                  }
                  
                {Length/Control/HandleBar_BB}  {
                      set side_a                  $project::Result(Length/Control/HandleBar_FW)
                      set side_b                  $value
                      set side_c                  $project::Result(Length/FrontWheel/diagonal)

                      set angle                   [vectormath::angle_Triangle $side_a $side_b $side_c]
                      set newPos                  [vectormath::rotatePoint {0 0} $FrontWheel(Position) $angle]
                      set newPos                  [vectormath::unifyVectorPointList [list {0 0} $newPos] ]
                      set newPos                  [vectormath::unifyVectorPointList [list {0 0} $newPos] $side_b]

                      foreach {x y} $newPos break
                      set xpath                   Personal/HandleBar_Distance)
                      set_Value                   $xpath     [format "%.3f" $x]
                      set xpath                   Personal/HandleBar_Height)
                      set_Value                   $xpath     [format "%.3f" $y]
                                                              
                      set_resultParameter         Result     Length/FrontWheel/diagonal   $side_c

                      return
                  }
              
                {Length/Control/SeatPost_HB}  {
                      set side_a                  $value
                      set side_b                  $project::Result(Length/Control/SeatPost_BB)
                      set side_c                  $project::Result(Length/Control/HandleBar_BB)
                      
                      set angle                   [vectormath::angle_Triangle $side_a $side_b $side_c]
                      set newPos                  [vectormath::rotatePoint {0 0} $HandleBar(Position) $angle]
                      set newPos                  [vectormath::unifyVectorPointList [list {0 0} $newPos] ]
                      set newPos                  [vectormath::unifyVectorPointList [list {0 0} $newPos] $side_b]

                      foreach {x y} $newPos break
                      set project::Personal(Saddle_Distance)   [format "%.3f" [expr -1.0 *$x] ]
                      set_base_Parameters
                      set xpath                   Personal/Saddle_Height
                      set_Value                   $xpath     [format "%.3f" [expr $y + $project::Component(Saddle/Height)] ]

                      return 
                  }
                  
                {Length/Control/SeatPost_BB}  {
                      set side_a                  $project::Result(Length/Control/SeatPost_HB)
                      set side_b                  $value
                      set side_c                  $project::Result(Length/Control/HandleBar_BB)
                      
                      set angle                   [vectormath::angle_Triangle $side_a $side_b $side_c]
                      set newPos                  [vectormath::rotatePoint {0 0} $HandleBar(Position) $angle]
                      set newPos                  [vectormath::unifyVectorPointList [list {0 0} $newPos] ]
                      set newPos                  [vectormath::unifyVectorPointList [list {0 0} $newPos] $side_b]

                      foreach {x y} $newPos break
                      set project::Personal(Saddle_Distance)   [format "%.3f" [expr -1.0 *$x] ]
                      set_base_Parameters
                      set xpath                   Personal/Saddle_Height
                      set_Value                   $xpath     [format "%.3f" [expr $y + $project::Component(Saddle/Height)] ]

                      return
                  }
                {Length/RearWheel/Radius}     {
                      set rimDiameter   [ project::getValue Component(Wheel/Rear/RimDiameter)  value ]
                      set tyreHeight    [ project::getValue Component(Wheel/Rear/TyreHeight)   value ]
                      set newValue      [ expr $value - 0.5 * $rimDiameter]
                      set xpath         Component(Wheel/Rear/TyreHeight
                      set_Value         $xpath     $newValue  
                  }
                {Length/FrontWheel/Radius}    {
                      set rimDiameter   [ project::getValue Component(Wheel/Front/RimDiameter) value ]
                      set tyreHeight    [ project::getValue Component(Wheel/Front/TyreHeight)  value ]
                      set newValue      [ expr $value - 0.5 * $rimDiameter]
                      set xpath         Component(Wheel/Front/TyreHeight
                      set_Value         $xpath     $newValue                
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
    proc trace_Project {varname key operation} {
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
    proc coords_flip_y {coordlist} {
            set returnList {}
            foreach {x y} $coordlist {
                set new_y [expr -$y]
                set returnList [lappend returnList $x $new_y]
            }
            return $returnList
    }

    #-------------------------------------------------------------------------
        #  get xy in a flat list of coordinates, start with    0, 1, 2, 3, ...
    proc coords_get_xy {coordlist index} {
            if {$index == {end}} {
                set index_y [expr [llength $coordlist] -1]
                set index_x [expr [llength $coordlist] -2]
            } else {
                set index_x [ expr 2 * $index ]
                set index_y [ expr $index_x + 1 ]
                if {$index_y > [llength $coordlist]} { return {0 0} }
            }
            return [list [lindex $coordlist $index_x] [lindex $coordlist $index_y] ]
    }
    
    #-------------------------------------------------------------------------
        #  return project attributes
    proc project_attribute {attribute } {
            variable Project
            return $Project($attribute)
    }

 }

