 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_tube.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2012/10/28
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
 #    namespace:  rattleCAD::lib_tube
 # ---------------------------------------------------------------------------
 #
 # 
 
 
namespace eval lib_tube {

    variable arcPrecission 5
    
    proc init_centerLine {centerLineDef} {
        
        variable arcPrecission
        
        foreach {S01_length S02_length S03_length \
                 S01_angle S02_angle \
                 S01_radius S02_radius} $centerLineDef break

        set angle_00    0
        set angle_01    [expr $angle_00 + $S01_angle]
        set angle_02    [expr $angle_01 + $S02_angle]
        set segment_01  [expr $S01_radius * $S01_angle * $vectormath::CONST_PI / 180]
        set segment_02  [expr $S02_radius * $S02_angle * $vectormath::CONST_PI / 180]
        set offset_01   [expr abs(0.5 * $segment_01)]
        set offset_02   [expr abs(0.5 * $segment_02)]

        set p_S00       {0 0}
        set p_End       $p_S00
        lappend basePoints  $p_End
        
        set p_S01 [vectormath::addVector $p_End [vectormath::rotateLine {0 0} $S01_length $angle_00]]
        
          # ============================================
          # 1st bent-Segment
        if {$S01_angle == 0} {
            set angle_01    $angle_00
            set segment_01  0
            set offset_01   0
            set p_S01_a     $p_S01
            set p_S01_b     $p_S01   
            set p_S01_ct    $p_S01   
            set p_End       $p_S01
            lappend basePoints $p_End
        } else {
            if {$S01_angle > 0} {
                set p_End  [vectormath::addVector $p_S01  [vectormath::rotateLine {0 0} [expr -1.0 * $offset_01] $angle_00]] 
                set p_S01_ct [vectormath::addVector $p_End  [vectormath::rotateLine {0 0} $S01_radius  90]]
                lappend basePoints $p_End
            } else {
                set p_End  [vectormath::addVector $p_S01  [vectormath::rotateLine {0 0} [expr -1.0 * $offset_01] $angle_00]] 
                set p_S01_ct [vectormath::addVector $p_End  [vectormath::rotateLine {0 0} $S01_radius -90]]
                lappend basePoints $p_End
            }
            set p_S01_a $p_End
            
            set nrSegments  [expr abs(round($segment_01/$arcPrecission))]
            if {$nrSegments < 1} {
                # puts "    -> nrSegments: $nrSegments"
              set nrSegments 1
            }
            set deltaAngle  [expr 1.0*$S01_angle/$nrSegments]
              # puts "  ->  Segments/Angle: $nrSegments $deltaAngle"
            set pStart  $p_End
            set i 0
            while {$i < $nrSegments} {
              set p_End  [vectormath::rotatePoint $p_S01_ct $pStart $deltaAngle]
              lappend basePoints $p_End
                # puts "  -> i/p_End:  $i  $p_End"
              set pStart $p_End
              incr i
            }
            set p_S01_b  $p_End
        }
        
          # ============================================
          # 2nd bent-Segment
        if {$S01_angle == 0} { 
            set p_S02 [vectormath::addVector $p_S01 [vectormath::rotateLine {0 0} $S02_length $angle_01]]
        } else {
            set length_02 [expr $S02_length - $offset_01]
            set p_S02 [vectormath::addVector $p_End [vectormath::rotateLine {0 0} $length_02 $angle_01]]
        }
        
        if {$S02_angle == 0} {
            set angle_02    $angle_01
            set segment_02  0
            set offset_02   0        
            set p_S02_a     $p_S02
            set p_S02_b     $p_S02
            set p_S02_ct    $p_S02
            set p_End       $p_S02
            lappend basePoints $p_End
        } else {
            if {$S02_angle < 0} {
                set p_End  [vectormath::addVector $p_S02 [vectormath::rotateLine {0 0} [expr -1.0 * $offset_02] $angle_01]]   
                set p_S02_ct [vectormath::addVector $p_End [vectormath::rotateLine {0 0} $S02_radius [expr -1.0*(90 - $angle_01)]]]
            } else {
                set p_End  [vectormath::addVector $p_S02 [vectormath::rotateLine {0 0} [expr -1.0 * $offset_02] $angle_01]]   
                set p_S02_ct [vectormath::addVector $p_End [vectormath::rotateLine {0 0} $S02_radius [expr (90 + $angle_01)]]]
            }
            set p_S02_a  $p_End
            
            set nrSegments  [expr abs(round($segment_02/$arcPrecission))]
            if {$nrSegments < 1} {
                # puts "    -> nrSegments: $nrSegments"
              set nrSegments 1
            }
            set deltaAngle  [expr 1.0*$S02_angle/$nrSegments]
              # puts "  ->  Segments/Angle: $nrSegments $deltaAngle"
            set pStart  $p_End
            set i 0
            while {$i < $nrSegments} {
              set p_End  [vectormath::rotatePoint $p_S02_ct $pStart $deltaAngle]
              lappend basePoints $p_End
                # puts "  -> i/p_End:  $i  $p_End"
              set pStart $p_End
              incr i
            }
            set p_S02_b  $p_End
        }
        
        if {$offset_02 == 0} { 
          set p_S03 [vectormath::addVector $p_S02 [vectormath::rotateLine {0 0} $S03_length $angle_02]]
        } else {
          set length_03 [expr $S03_length - $offset_02]
          set p_S03 [vectormath::addVector $p_End [vectormath::rotateLine {0 0} $length_03 $angle_02]]
        }
        lappend basePoints $p_S03
        
        
          # -- define controlLines
        set ctrlPoint_00_b [vectormath::addVector $p_S00 [list  $S01_length 0]]
        
        set ctrlPoint_01_a [vectormath::addVector $p_S01_b [vectormath::rotateLine {0 0} $offset_01 [expr 180 + $angle_01]]]
        set ctrlPoint_01_b [vectormath::addVector $p_S02_a [vectormath::rotateLine {0 0} $offset_02 $angle_01]]
        
        set ctrlPoint_02_a [vectormath::addVector $p_S02_b [vectormath::rotateLine {0 0} $offset_02 [expr 180 + $angle_02]]]
        
        set controlPoints   [list $p_S00 $ctrlPoint_00_b  $ctrlPoint_01_a $ctrlPoint_01_b $ctrlPoint_02_a $p_S03]

        
        return [list $basePoints $controlPoints]
    }


    proc init_tubeProfile {profileDef args} {

        variable unbentShape
        
        array unset _tubeProfileArray
        set tubeProfile [dict create]
        
        set x 0
        set y 0
        set k 0
        set i 0
        set profLength [llength $profileDef]
        while {$i < $profLength} {
            set xy [lindex $profileDef $i]
            foreach {x0 y0} $xy break
            set x   [expr $x + $x0]
            set y0  [expr 0.5 * $y0]
            
            set j [expr $i + 1]
            if {$j <= $profLength} {
              set xy [lindex $profileDef $j]
              foreach {x1 y1} $xy break
              set y1  [expr 0.5 * $y1]
              set k [expr 1.0 * ($y1 - $y0) / $x1]
            } else {
              set x1 10
              set y1 $y0
              set k  0
            }
            set _tubeProfileArray($x) [list  $y0 $k]
            incr i
        }
        set _tubeProfileArray([expr $x + 1]) [list  $y0 0]
        
        foreach index [lsort -real [array names _tubeProfileArray]] {
            dict append tubeProfile $index $_tubeProfileArray($index)
            # lappend profileIndex $index
            # puts "   -> $index"
        }
       
        return $tubeProfile       
    }


    proc get_tubeProfileOffset {profile position} {
        
        variable unbentShape

        set profileIndex {}
          # puts "dict: $profile"
          # puts "keys: [dict keys $profile]"
        foreach offset [lsort -real [dict keys $profile]] {
            lappend profileIndex $offset
            # puts "   -> $offset"
        } 
          # puts "\$profileIndex  $profileIndex"

        foreach index $profileIndex { 
          if {$position >= [expr 1.0 * $index]} {
            set k {}
            set value [dict get $profile $index]
              # set value $tubeProfile($index)
            set d_profile $index
            foreach {d k}  $value break
          }
        }
        set dx [expr $position - $d_profile]
        set offset [expr $d + $dx*$k]
          # puts ">$offset"
        
        return $offset
          # return [list $position $offset]
    }


    proc get_tubeShape {centerLine tubeProfile side} {
      
        variable arcPrecission
        
        set linePosition 0
        set bentProfile {}
        
        set lineOffset  [get_tubeProfileOffset $tubeProfile $linePosition]
        if {$side == {left}} {
          lappend bentProfile [list $linePosition $lineOffset]
        } else {
          lappend bentProfile [list $linePosition [expr -1.0 * $lineOffset]]
        }
        # puts "        ---> $bentProfile"
        
        set xLast {}
        set yLast {}
        foreach p $centerLine {
          foreach {x y} $p break
          if {$xLast == {}} {
            set xLast $x
            set yLast $y
            continue
          }
              # puts "$xLast -> $x  | $yLast -> $y"
            # -- get offset / depending on segments
          set p_SegStart  [list $xLast $yLast]
          set p_SegEnd    [list $x $y]
          set angle       [vectormath::dirAngle $p_SegStart $p_SegEnd]
          set l_segment   [vectormath::length   $p_SegStart $p_SegEnd]
              #puts "\n-----------"
              #puts "     -> start:    $p_SegStart"
              #puts "     -> end:      $p_SegEnd"
              #puts "       -> angle:     $angle"
              #puts "       -> segment:   $l_segment\n"
          
          set nrSegments  [expr abs(round($l_segment/$arcPrecission))]
          if {$nrSegments < 1} {
              # puts "    -> nrSegments: $nrSegments"
            set nrSegments 1
          }
          set l_segment   [expr $l_segment/$nrSegments]
          
          if {$side == {left}} {
            set offsetAngle [expr $angle + 90]
          } else {
            set offsetAngle [expr $angle - 90]
          }
          
          set p_Start $p_SegStart
          set i 0
          while {$i < $nrSegments} {
            set linePosition  [expr $linePosition + $l_segment]
            set lineOffset    [get_tubeProfileOffset $tubeProfile $linePosition]
            set p_End         [vectormath::rotateLine $p_Start $l_segment   $angle]
            set p_Offset      [vectormath::rotateLine $p_End   $lineOffset  $offsetAngle]
              # -- add to bentProfile
            lappend bentProfile $p_Offset
                #puts "        ---> [lindex $bentProfile end]"
                #puts "         ->  + $l_segment = $linePosition / $lineOffset  |  $offsetAngle"
              # -- prepare next loop
            set p_Start $p_End
            incr i
          }
          
            # -- prepare next loop
          set xLast $x
          set yLast $y     
        }
        foreach xy $bentProfile {
          # puts "   -> $xy"
        }
        
        if {$side == {left}} {
          return $bentProfile
        } else {
          return [lreverse $bentProfile]
        }
    }


    proc get_shapeInterSection {shape length} {
        
        set shape_llength [llength $shape]  
        set pLast {0 0}
        set precission 1
        
        set shapeIndex 0
        while {$shapeIndex < $shape_llength} {
            # -- get current point of shape
          set pIdx [lindex $shape $shapeIndex]  
          foreach {x y} $pIdx break
          set xAbs  [expr abs($x)]
          set yAbs  [expr abs($y)]
          set lpIdx    [vectormath::length {0 0} $pIdx]

            # -- get last point of shape
          if {$shapeIndex > 0} {
            set pLast [lindex $shape $shapeIndex-1]
          }

            # -- incr shapeIndex before continue
          incr shapeIndex

            # -- precheck values to optimize loop through shape
          if {$lpIdx < $length} continue
          
          set pNow  $pLast
          set dir   [vectormath::dirAngle $pLast $pIdx] 
          set lEnd  [vectormath::length {0 0} $pIdx]
          
          if {$lpIdx > $length} {
              set lNow [vectormath::length {0 0} $pLast]
              while {$lNow < $length} {
                set pNow [vectormath::rotateLine $pNow $precission $dir]
                set lNow [vectormath::length {0 0} $pNow]
              }
              return $pNow
          }
        }
        
          # -- exception: intersection is out of shape
        set pLast [lindex $shape end-1]
        set pNow  [lindex $shape end]
        set lNow  [vectormath::length {0 0} $pNow]
        set dir   [vectormath::dirAngle $pLast $pNow]

        while {$lNow < $length} {
          set pNow  [vectormath::rotateLine $pNow $precission $dir]
          set lNow  [vectormath::length {0 0} $pNow]
        }
        return $pNow
    }
 
 
 
}