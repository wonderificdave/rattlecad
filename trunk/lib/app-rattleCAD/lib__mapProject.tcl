 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_frame_geometryUpdate.tcl
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
 #    namespace:  rattleCAD::frame_geometry
 # ---------------------------------------------------------------------------
 #
 #

  # ----- project --------------------------
      #
  namespace eval project {
 
      package require appUtil 0.9
    
      variable Custom;      array set Custom {}
      variable FrameTubes;  array set FrameTubes {}
      variable Lugs;        array set Lugs {}
      variable Personal;    array set Personal {}
      variable Component;   array set Component {}
      variable Project;     array set Project {}
      variable Rendering;   array set Rendering {}
      variable Result;      array set Result {}
      
      trace add     variable ::rc_Domain::project::Custom        write [namespace current]::updateConfig
      trace add     variable ::rc_Domain::project::FrameTubes    write [namespace current]::updateConfig
      trace add     variable ::rc_Domain::project::Lugs          write [namespace current]::updateConfig
      trace add     variable ::rc_Domain::project::Personal      write [namespace current]::updateConfig
      trace add     variable ::rc_Domain::project::Component     write [namespace current]::updateConfig
      trace add     variable ::rc_Domain::project::Project       write [namespace current]::updateConfig
      trace add     variable ::rc_Domain::project::Rendering     write [namespace current]::updateConfig
      trace add     variable ::rc_Domain::project::Result        write [namespace current]::updateConfig
      
      
      
      proc updateConfig {varname key operation} {
              #
          puts "    $varname $key $operation"
              #
          variable Custom
          variable FrameTubes
          variable Lugs
          variable Personal
          variable Component
          variable Project
          variable Rendering
          variable Result
              #
          set arrayName [lindex [split $varname :] end]
          eval [format "set keyValue $%s(%s)" $varname $key]
              #
          puts "\n\n"
          puts "   --<trace>--------------------------"
          puts "    project::updateConfig"
          puts "       varname:         $varname -> $arrayName"
          puts "       key:             $key"
          puts "       keyValue:        $keyValue"
          puts "       operation:       $operation"
              #
          if {$key != ""} {
              eval [format "set %s(%s) \"%s\"" $arrayName $key  $keyValue]
          }
              #
          return
      } 
          
      proc getValue {key type {args {}}} {
          if {$args == {}} {
              return [rc_Domain::get_Value $key $type]
          } else {
              return [rc_Domain::get_Value $key $type $args]
          }
      }
  } 
  
  
  
  # ----- bikeGeometry ---------------------
      #    
  namespace eval bikeGeometry {
      
      variable RearWheel;           array set RearWheel {}
      variable FrontWheel;          array set FrontWheel {}
      variable BottleCage;          array set BottleCage {}
      variable BottomBracket;       array set BottomBracket {}
      variable ChainStay;           array set ChainStay {}
      variable DEBUG_Geometry;      array set DEBUG_Geometry {} 
      variable DownTube;            array set DownTube {} 
      variable Fork;                array set Fork {} 
      variable FrameJig;            array set FrameJig {} 
      variable FrontBrake;          array set FrontBrake {} 
      variable FrontDerailleur;     array set FrontDerailleur {} 
      variable FrontWheel;          array set FrontWheel {} 
      variable HandleBar;           array set HandleBar {} 
      variable HeadSet;             array set HeadSet {} 
      variable HeadTube;            array set HeadTube {} 
      variable LegClearance;        array set LegClearance {} 
      variable Project;             array set Project {} 
      variable RearBrake;           array set RearBrake {} 
      variable RearDrop;            array set RearDrop {} 
      variable RearWheel;           array set RearWheel {} 
      variable Saddle;              array set Saddle {} 
      variable SeatPost;            array set SeatPost {} 
      variable SeatStay;            array set SeatStay {} 
      variable SeatTube;            array set SeatTube {} 
      variable Steerer;             array set Steerer {} 
      variable Stem;                array set Stem {} 
      variable TopTube;             array set TopTube {} 
      variable TubeMiter;           array set TubeMiter {} 
      variable myFork;              array set myFork {} 
      
      
      trace add     variable ::rc_Domain::bikeGeometry::BottleCage        write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::BottomBracket     write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::ChainStay         write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::DEBUG_Geometry    write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::DownTube          write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::Fork              write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::FrameJig          write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::FrontBrake        write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::FrontDerailleur   write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::FrontWheel        write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::HandleBar         write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::HeadSet           write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::HeadTube          write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::LegClearance      write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::Project           write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::RearBrake         write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::RearDrop          write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::RearWheel         write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::Saddle            write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::SeatPost          write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::SeatStay          write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::SeatTube          write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::Steerer           write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::Stem              write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::TopTube           write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::TubeMiter         write [namespace current]::updateConfig                
      trace add     variable ::rc_Domain::bikeGeometry::myFork            write [namespace current]::updateConfig        
      
      
      proc updateConfig {varname key operation} {
              #
          puts "    $varname $key $operation"
              #
          variable RearWheel
          variable FrontWheel
          variable FrontWheel
          
          variable $varname
              #     
          set arrayName [lindex [split $varname :] end]
          eval [format "set keyValue \$::rc_Domain::bikeGeometry::%s(%s)" $varname $key]
              # return
              #
          puts "\n\n"
          puts "   --<trace>--------------------------"
          puts "    bikeGeometry::updateConfig"
          puts "       varname:         $varname -> $arrayName"
          puts "       key:             $key"
          puts "       keyValue:        $keyValue"
          puts "       operation:       $operation"
              #
          switch -exact $key {
              Position {
                      set listValue [list $keyValue]
                      puts "[format "set %s(%s) %s" $arrayName $key  $listValue]"
                      eval [format "set %s(%s) %s" $arrayName $key  $listValue]
                  }
              {}  {}  
              default {
                      puts "[format "set %s(%s) %s" $arrayName $key  $keyValue]"
                      eval [format "set %s(%s) \"%s\"" $arrayName $key  $keyValue]
              }
          }
          puts "        -> [namespace current]"
          return

      } 
      
      proc get_Object {object index {centerPoint {0 0}}} {
              return [rc_Domain::get_Object $object $index $centerPoint]
      }
      
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
      
      proc project_attribute {attribute } {
              variable Project
              return $Project($attribute)
      }
      
      proc getValue {key type {args {}}} {
          if {$args == {}} {
              return [rc_Domain::get_Value $key $type]
          } else {
              return [rc_Domain::get_Value $key $type $args]
          }
      }
      
      

  }
