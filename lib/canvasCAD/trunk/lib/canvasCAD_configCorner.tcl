
 ##+##########################################################################
 #
 # package: canvasCAD 	->	canvasCAD_configCorner.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2014/02/15
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
 #	namespace:  canvasCAD
 # ---------------------------------------------------------------------------
 #
 #

    namespace eval canvasCAD::configCorner {
    
        variable cornerIndex 0 
        variable cfgRegistry;  array set cfgRegistry {}
        variable styleArray;   array set styleArray {}
        
        
        proc register {canvasDOMNode cmd} {
            variable cfgRegistry
            set w       [ canvasCAD::getNodeAttribute  $canvasDOMNode  Canvas   path ]
            set cfgRegistry($canvasDOMNode) ${cmd}
            set cfgRegistry($w)             ${cmd}
            [namespace current]::update $w
        }
        
        proc update   {w} {
            variable cfgRegistry
            variable styleArray
            
              # puts "canvasCAD::configCorner::update $w"
              
              # -- just for fun
            if {[catch {set cfgRegistry($w)} fid]} {
                puts "  -> $fid"
                return
            } else {
                set cmd [set cfgRegistry($w)]
                # puts "    $cmd"
            }

              
              # -- delete existing __configCorner__
            catch {$w delete __configCorner__}
            
              # -- get svg-template
            set svg_Dir  [file join [set [namespace parent]::packageHomeDir] svg]
            set svg_File [file join $svg_Dir cfg_Corner.svg]
              # puts "    $w"
              # puts "    $svg_Dir"
              # puts "    $svg_File"
            set fp [open $svg_File]
            fconfigure    $fp -encoding utf-8
            set xml [read $fp]
            close         $fp
              #
            set doc  [dom parse  $xml]
            set root [$doc documentElement]
              # puts "  ->\n[$root asXML]" 

              # -- get style  
            set styleNode   [$root getElementsByTagName style]
            [namespace current]::setStyleArray $styleNode
              #
            
              # puts "\n -----\n"
              
              # get polygons
            foreach polygon [$root getElementsByTagName polygon] {
                  # puts "   -> [$polygon asXML]"
                set points  [$polygon getAttribute points]
                  # puts "         -> $points"
                set pointList {}
                foreach {xy} $points {
                    foreach {x y} [split $xy ,] break
                    lappend pointList $x $y
                }
                  # puts "          -> $pointList"
                
                set styleList  [$polygon getAttribute class]
                  # puts "         -> $styleList"             
                set cv_Item [$w create polygon $pointList -tags [list __configCorner__]]
                
                [namespace current]::formatPolygon $w $cv_Item $styleList
            }
            
            
              # -- bind cursor configurations
            set cursor {hand2}
            $w bind __configCorner__    <Enter> [list $w configure -cursor $cursor]
            $w bind __configCorner__    <Leave> [list $w configure -cursor {}]
              #
        }
        
        proc deleteCorner {w} {
            catch {$w delete __configCorner__}
        }


        proc execute {w} {
              # puts "\n   -> execute: "
            variable cfgRegistry
            
            if {[catch {set cfgRegistry($w)} fid]} {
                puts "  -> $fid"
                return
            } else {
                set cmd [set cfgRegistry($w)]
            }
              
              # puts "    $cmd"
              # puts "\n\n     -> execute: $w -> $cmd\n\n"
              
            set command [lindex $cmd 0]
            set values  [lrange $cmd 1 end]
            eval ${command} {*}$values
        }
        
        proc setStyleArray {styleNode} {
            variable styleArray
            
            set styleText   [$styleNode text]
              # puts "  -> [$styleNode asXML]"
              # puts "  -> $styleText"
            foreach {name styleset} $styleText {
                  # puts "            -> $name -> $styleset"
                set name [string trim $name .]
                set styleArray($name) $styleset
            }
            # parray styleArray            
        }
        
        proc formatPolygon {w item styleList} {
            variable styleArray
              # puts "     -> formatPolygon: $item"
              # puts "     -> formatPolygon: $styleList"
            
            foreach name $styleList {
                puts "          -> $name"
                set styleList [split [set styleArray($name)] \;]
                  # puts "              -> $styleList"
                foreach style $styleList {
                      # puts "              -> -> $style  -> [split $style :]"
                    foreach {styleName value} [split $style :] break
                      # puts "                  -> $styleName  - $value"
                    switch -exact $styleName {
                        stroke {       $w itemconfigure $item -outline $value}
                        stroke-width { $w itemconfigure $item -width   $value}
                        fill {         $w itemconfigure $item -fill    $value}
                        default {}
                    }                    
                }
            }
        }
    }
