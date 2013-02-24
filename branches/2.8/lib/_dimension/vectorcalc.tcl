#############################################################
#
#  dimension vector_calc
#
#   Dimension is licensed using the GNU General Public Licence,
#        see http://www.gnu.org/copyleft/gpl.html
#
#      vector_calc is a summary of own procedures:
#         point_length_arc
#         direction
#         rotate_point
#         move_point
#         
#      and a summary from wiki.tcl.tk
# 

package provide dimension 0.2

  # -----------------------------------------------------------------------------------
  #
  #: Functions : namespace      V E C T O R - C A L C U L A T I O N
  #
  
   namespace eval vector_calc {
   
         variable  CONST_PI  [ expr 4*atan(1) ]
            


	 proc rotate_point { p_cent p_rot angle } { # start at 3 o'clock counterclockwise
	    variable CONST_PI
	    foreach {x y} [ VSub $p_rot $p_cent ]  break
	    
	    set p0        [ list $x $y ]
	    set RADIANT   [ expr $angle * $CONST_PI / 180 ]
	    return [ VAdd [ VRotate  $p0 $RADIANT ] $p_cent ]
	  }

	 proc rotate_line { p l angle } { # start at 3 o'clock counterclockwise
	    set  p1  [VAdd  $p  [list $l 0]]
	    return [rotate_point  $p  $p1  $angle]
	  }

	 proc direction { p1 p2 } { # angle from positive x-axis
	    variable CONST_PI
	    set xy [VSub $p2 $p1]
	    set p1 {0 0}
	    foreach {x y} $xy  break
	       # debug::print "    $x  $y"
	    if { $x == 0 } { 
	         if {$y > 0 } {
	              return  90 
	         } else {
	              return -90
	         }
	    }
	    set angle  [expr atan(1.0*$y/$x)*180/$CONST_PI]
	    if { $x <  0 } { 
	         return [ expr $angle+180] 
	       } {
	         return $angle
	       }
	  }

	 proc perp_distance { p1 p2 p3 } { # distance from p1 perpendicular to vector:p2,p3  
		set v_perp [ VSub $p2 [ rotate_point $p2 $p3 90 ] ]
		set p4     [ VAdd $p1 $v_perp ]
		return     [ Intersect $p1 $p4 $p2 $p3 ]
	  }

	 proc line_center { p1 p2 } { 
	    set v_line      [ VSub $p2 $p1 ]
	    set v_line_c    [ list [ expr [lindex $v_line 0] * 0.5 ] [ expr [lindex $v_line 1] * 0.5 ] ]
	    return          [ VAdd $p1 $v_line_c]
	  }

	 proc vect_orient_dir_lr { p1 p2 switch_direction} { # angle from positive x-axis
            
	    set angle  [direction $p1 $p2]
            
	    #tk_messageBox -message " -> $angle"
            
	    set switch_dir keep
	    if { $angle > $switch_direction             } { set switch_dir change }
	    if { $angle < [expr $switch_direction -180] } { set switch_dir change }
            
            
            
	    if { $switch_dir == "change" } {
	         set vector  [list [lindex $p2 0] [lindex $p2 1] [lindex $p1 0] [lindex $p1 1] ]
                 #update 
                 # $::canvas scale all 0 [expr 0.5 * [winfo height .]] 1 -1
	         #tk_messageBox -message "flip direction -> $angle"
                 # $::canvas scale all 0 [expr 0.5 * [winfo height .]] 1 -1
	    } else {
	         set vector  [list [lindex $p1 0] [lindex $p1 1] [lindex $p2 0] [lindex $p2 1] ]
                 #update 
                 # $::canvas scale all 0 [expr 0.5 * [winfo height .]] 1 -1
	         #tk_messageBox -message "keep direction -> $angle"
                 # $::canvas scale all 0 [expr 0.5 * [winfo height .]] 1 -1
	    }
	    
	    return $vector                     
	  }



	 ##+##############################################################################
	 #
	 #  summary of wiki.tcl.tk 
	 #
	 #
	 
             ##+##########################################################################
             #
             # Intersect -- find where two line intersect given two points on each line
             # IntersectV -- same but w/ 2 point/vector pairs
             #   we want K,J where p1+K(v1) = p3+J(v3)
             #   convert into and solve matrix equation (a b / c d) ( K / J) = ( e / f )
             #
             
	 proc Intersect {p1 p2 p3 p4} {
	    return [IntersectV $p1 [VSub $p2 $p1] $p3 [VSub $p4 $p3]]
	 }
	 
	 proc IntersectV {p1 v1 p3 v3} {
	    foreach {x1 y1} $p1 {vx1 vy1} $v1 {x3 y3} $p3 {vx3 vy3} $v3 break

	    set a $vx1
	    set b [expr {-1 * $vx3}]
	    set c $vy1
	    set d [expr {-1 * $vy3}]
	    set e [expr {$x3 - $x1}]
	    set f [expr {$y3 - $y1}]

	    set det [expr {double($a*$d - $b*$c)}]
	    if {$det == 0} {error "Determinant is 0"}

	    set k [expr {($d*$e - $b*$f) / $det}]
	    return [VAdd $p1 $v1 $k]
	 }
	 
             ##+##########################################################################
             #
             # FindAngle -- returns the angle formed by p1,p2,p3
             # use cosinus - satz
             # Angle-Center is   p2
             #
	 proc FindAngle {p1 p2 p3} {
	    variable CONST_PI
	    foreach {x1 y1} [VSub $p1 $p2] {x2 y2} [VSub $p3 $p2] break

	    set m1 [expr {hypot($x1,$y1)}]
	    set m2 [expr {hypot($x2,$y2)}]
	    if {$m1 == 0 || $m2 == 0} { return 0 }      ;# Coincidental points
	    set dot [expr {$x1 * $x2 + $y1 * $y2}]

	    set theta [expr {acos($dot / ( $m1 * $m2))}]
	    if {$theta < 1e-5} {set theta 0}
	    set theta [ expr $theta * 180 / $CONST_PI ]
	    return $theta
	 }
	 
             ##+##########################################################################
             #
             # BisectAngle -- returns point on bisector of the angle formed by p1,p2,p3
             #
	 proc BisectAngle {p1 p2 p3} {
	    foreach {x1 y1} [VSub $p1 $p2] {x2 y2} [VSub $p3 $p2] break

	    set s1 [expr {100.0 / hypot($x1, $y1)}]
	    set s2 [expr {100.0 / hypot($x2, $y2)}]
	    set v1 [VAdd $p2 [list $x1 $y1] $s1]        ;# 100*Unit vector from p2 to p1
	    set v2 [VAdd $p2 [list $x2 $y2] $s2]        ;# 100*Unit vector from p2 to p3
	    return [VAdd $v1 [VSub $v2 $v1] .5]
	 }
             
             ##+##########################################################################
             #
             # TrisectAngle -- returns two points which are on the two lines trisecting
             # the angle created by points p1,p2,p3. We use the cross product to tell
             # us clockwise ordering.
             #
	 proc TrisectAngle {p1 p2 p3} {
	    set cross [VCross [VSub $p2 $p1] [VSub $p2 $p3]]
	    if {$cross < 0} {foreach {p1 p3} [list $p3 $p1] break}

	    set theta [FindAngle $p1 $p2 $p3]           ;# What the angle is
	    set theta1 [expr {$theta / 3.0}]            ;# 1/3 of that angle
	    set theta2 [expr {2 * $theta1}]             ;# 2/3 of that angle

	    set v [VSub $p3 $p2]                        ;# We'll rotate this leg
	    set v1 [VRotate $v $theta1]                 ;# By 1/3
	    set v2 [VRotate $v $theta2]                 ;# By 2/3
	    set t1 [VAdd $p2 $v1]                       ;# Trisect point 1
	    set t2 [VAdd $p2 $v2]                       ;# Trisect point 2

	    if {$cross < 0} {return [list $t2 $t1]}
	    return [list $t1 $t2]
	 }
             
             ##+##########################################################################
             #
             # HELPER FUNCTIONS:
             #
             
             ##+##########################################################################
             #   VAdd -- adds two vectors w/ scaling of 2nd vector
	 proc VAdd {v1 v2 {scaling 1}} {
	    foreach {x1 y1} $v1 {x2 y2} $v2 break
	    return [list [expr {$x1 + $scaling*$x2}] [expr {$y1 + $scaling*$y2}]]
	 }
	 
             ##+##########################################################################
             #   VSub -- subtract two vectors
	 proc VSub {v1 v2} { return [VAdd $v1 $v2 -1] }

             ##+##########################################################################
             #   VCross -- returns the cross product for 2D vectors (z=0)
	 proc VCross {v1 v2} {
	    foreach {x1 y1} $v1 {x2 y2} $v2 break
	    return [expr {($x1*$y2) - ($y1*$x2)}]
	 }

             ##+##########################################################################
             #   VRotate -- rotates vector counter-clockwise
	 proc VRotate {v beta} {
	    foreach {x y} $v break
	    set xx [expr {$x * cos($beta) - $y * sin($beta)}]
	    set yy [expr {$x * sin($beta) + $y * cos($beta)}]
	    return [list $xx $yy]
	 }
  }  
 

