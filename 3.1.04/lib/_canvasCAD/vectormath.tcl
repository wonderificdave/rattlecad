#############################################################
#
#  canvasCAD.tcl
#    ->	vectormath.tcl
#
#	canvasCAD is licensed using the GNU General Public Licence,
#        see http://www.gnu.org/copyleft/gpl.html
#   (c) Manfred ROSENBERGER, 2007/12/13
#
#   	vectormath.tcl
#      		a summary from wiki.tcl.tk and new procedures:
#
#      0.2)  2010.02.20  
#				... merge to canvasCAD
#				... standard naming conventions :     [action][input(output)Types]
#
#

  # -----------------------------------------------------------------------------------
  #
  #: Functions : namespace      V E C T O R - C A L C U L A T I O N
  #
  
   namespace eval vectormath {
   
         variable  CONST_PI [ expr 4*atan(1) ]
						#	[ expr {2*asin(1.0)} ]
            

	proc rotatePointList { p_cent p_list angle } {
			set newList {}
			foreach {x y} $p_list {
				set xy [rotatePoint $p_cent [list $x $y] $angle]
				set newList [lappend newList [lindex $xy 0] [lindex $xy 1] ]
			}
			return $newList
	}

	proc rotatePoint { p_cent p_rot angle } { 
			# start at 3 o'clock counterclockwise
			# angle in degree
			variable CONST_PI
			foreach {x y} [ subVector $p_rot $p_cent ]  break
			
			set p0		[ list $x $y ]
			set RADIANT	[ expr $angle * $CONST_PI / 180 ]
			return 		[ addVector [ VRotate  $p0 $RADIANT ] $p_cent ]
	}

	proc rotateLine { p l angle } { 
			# start at 3 o'clock counterclockwise
			# angle in degree
			set  p1  [addVector  $p  [list $l 0]]
			return [rotatePoint  $p  $p1  $angle]
	}

	proc dirAngle { p1 p2 } { 
			# angle from positive x-axis
			# angle in degree
			variable CONST_PI
			set xy [subVector $p2 $p1]
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

	proc intersectPerp { p1 p2 p3 } { 
			# perpendicular intersectPoint from vector(p1,p2) through p3
			set vct_h1	[ subVector [ rotatePoint $p1 $p2 90 ] $p1]
			set p4_1	[ rotatePoint $p1 $p2 90 ]
			set p4		[ addVector   $p3  $vct_h1 ]
			if { [catch {set p_isPerp [intersectPoint $p1 $p2 $p3 $p4]} fid] } {
				# -- check: p3 not on vector(p1,p2)
			   puts stderr "intersectPerp\n   -> $fid"
			   return $p3
			} else {
				return $p_isPerp
			}
			#return		[ intersectPoint $p1 $p2 $p3 $p4 ]
	}

	proc distancePerp { p1 p2 p3 } { 
			# perpendicular distance from vector(p1,p2) through p3 
			set p4		[ intersectPerp $p1 $p2 $p3]
			return 		[ length $p3 $p4 ]
	}

	proc length { p1 p2 } { 
			# distance from  p1  to  p2 
			set vector [ subVector $p2 $p1 ]
			set length [ expr hypot([lindex $vector 0],[lindex $vector 1]) ] 
			return $length
	}

	proc center { p1 p2 } { 
			set v_line      [ subVector $p2 $p1 ]
			set v_line_c    [ list [ expr [lindex $v_line 0] * 0.5 ] [ expr [lindex $v_line 1] * 0.5 ] ]
			return          [ addVector $p1 $v_line_c]
	}

	proc unifyVector { p1 p2 {length {1.0}}} {
			# return vector with length 1 as default
			set vector 		[ addVector $p2 $p1 -1 ] 
			set vctLength 	[ expr hypot([lindex $vector 0],[lindex $vector 1]) ]
			if {$vctLength != 0} {
				set vector		[ addVector  {0 0}  $vector  [expr $length/$vctLength] ]
			} else {
				set vector		[ addVector  {0 0}  $vector ]
			}
			return $vector                     
	}
	
	proc scalePointList { pRef ptList scale} {
			# return vector with length 1 as default
			foreach	{xRef yRef} $pRef break
			set PointList {}
			foreach	{x y} $ptList {
				set px	[ expr ($x - $xRef) * $scale + $xRef ]
				set py	[ expr ($y - $yRef) * $scale + $yRef ]
				set PointList [ lappend PointList $px $py ]
			}
			return $PointList
	}

	proc cathetusPoint { p1 p2 cathetus {position {close}}} { 
			# return third point of rectangular triangle
			#   p3 allways on right side from p1 to p2
			#   position:  [close/opposite] ... given cathetus close to p1 / close to p2
			variable CONST_PI
			set hypothenuse	[ addVector $p1 $p2 -1 ] 
			set hypLength	[ expr hypot([lindex $hypothenuse 0],[lindex $hypothenuse 1]) ]
			set hypAngle	[ dirAngle $p1 $p2 ]
			set cthAngle	[ expr acos($cathetus/$hypLength)*180/$CONST_PI ]
			if {$position == {close}} { # cathetus next to p1
				set cthAngle [ expr $hypAngle - $cthAngle ]
				set p3 [ rotateLine $p1 $cathetus $cthAngle ]
			} else {  # cathetus next to p2
				set cthAngle [ expr 180 + $hypAngle + $cthAngle ]
				set p3 [ rotateLine $p2 $cathetus $cthAngle ]
			}		
			return $p3
	}

	proc parallel { p1 p2 distance {direction {right}}} { 
			# return vector parallel to p1,p2 with distance 
			#   and direction from p1 to p2
			variable CONST_PI
			set vector		[ addVector $p1 $p2 -1 ] 
			set vctAngle	[ dirAngle $p1 $p2 ]
			if {$direction == {right}} { # cathetus next to p1
				set distAngle [ expr $vctAngle - 90 ]
			} else {  # cathetus next to p2
				set distAngle [ expr $vctAngle + 90 ]
			}		
			set p3 [ rotateLine $p1 $distance $distAngle ]
			set p4 [ rotateLine $p2 $distance $distAngle ]
			return [list $p3 $p4]
	}

	

	 ##+##############################################################################
	 #
	 #  summary: found at wiki.tcl.tk 
	 #
	 #
	 
             ##+##########################################################################
             #
             # intersectPoint -- find where two line intersect given two points on each line
             # intersectPointVector -- same but w/ 2 point/vector pairs
             #   we want K,J where p1+K(v1) = p3+J(v3)
             #   convert into and solve matrix equation (a b / c d) ( K / J) = ( e / f )
             #            
	proc intersectPoint {p1 p2 p3 p4} {
			return [intersectPointVector $p1 [subVector $p2 $p1] $p3 [subVector $p4 $p3]]
	} 
	proc intersectPointVector {p1 v1 p3 v3} {
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
			return [addVector $p1 $v1 $k]
	}
	 
             ##+##########################################################################
             #
             # angle -- returns the angle formed by p1,pc,p3
             # use cosinus - satz
             # Angle-Center is   pc
             #
	proc angle {p1 pc p3} {
			variable CONST_PI
			foreach {x1 y1} [subVector $p1 $pc] {x2 y2} [subVector $p3 $pc] break

			set m1 [expr {hypot($x1,$y1)}]
			set m2 [expr {hypot($x2,$y2)}]
				# if {$m1 == 0 || $m2 == 0} { return 0 }      ;# Coincidental points
				# puts "{$m1 == 0 || $m2 == 0}"  
			set dot [expr {$x1 * $x2 + $y1 * $y2}]
			set mp	[expr $m1 * $m2]
			if {$mp == 0 }   { return 0 }
			if {$dot > $mp } { return 0 }
				# if {$dot > $mp } { set dot $mp }
			set theta [expr {acos($dot / $mp)}]
			if {$theta < 1e-5} {set theta 0}
			set theta [ expr $theta * 180 / $CONST_PI ]
			return $theta
	}
	 
             ##+##########################################################################
             #
             # bisectAngle -- returns point on bisector of the angle formed by p1,p2,p3
             #
	proc bisectAngle {p1 p2 p3} {
			foreach {x1 y1} [subVector $p1 $p2] {x2 y2} [subVector $p3 $p2] break

			set s1 [expr {100.0 / hypot($x1, $y1)}]
			set s2 [expr {100.0 / hypot($x2, $y2)}]
			set v1 [addVector $p2 [list $x1 $y1] $s1]        ;# 100*Unit vector from p2 to p1
			set v2 [addVector $p2 [list $x2 $y2] $s2]        ;# 100*Unit vector from p2 to p3
			return [addVector $v1 [subVector $v2 $v1] .5]
	}
             ##+##########################################################################
             #
             # trisectAngle -- returns two points which are on the two lines trisecting
             # the angle created by points p1,p2,p3. We use the cross product to tell
             # us clockwise ordering.
             #
	proc trisectAngle {p1 p2 p3} {
			set cross [VCross [subVector $p2 $p1] [subVector $p2 $p3]]
			if {$cross < 0} {foreach {p1 p3} [list $p3 $p1] break}

			set theta [angle $p1 $p2 $p3]		;# What the angle is
			set theta1 [expr {$theta / 3.0}]	;# 1/3 of that angle
			set theta2 [expr {2 * $theta1}]		;# 2/3 of that angle

			set v  [subVector $p3 $p2]			;# We'll rotate this leg
			set v1 [VRotate $v $theta1]			;# By 1/3
			set v2 [VRotate $v $theta2]			;# By 2/3
			set t1 [addVector $p2 $v1]			;# Trisect point 1
			set t2 [addVector $p2 $v2]			;# Trisect point 2

			if {$cross < 0} {return [list $t2 $t1]}
			return [list $t1 $t2]
	}
             
             ##+##########################################################################
             #
             # HELPER FUNCTIONS:
             #
             
             ##+##########################################################################
             #   addVector -- adds two vectors w/ scaling of 2nd vector
	proc addVector {v1 v2 {scaling 1}} {
			foreach {x1 y1} $v1 {x2 y2} $v2 break
			return [list [expr {$x1 + $scaling*$x2}] [expr {$y1 + $scaling*$y2}]]
	}	 
             ##+##########################################################################
             #   subVector -- subtract two vectors
	proc subVector {v1 v2} { return [addVector $v1 $v2 -1] }
             ##+##########################################################################
             #   converts from grad to rad an viceversa
	proc rad  {arc} {
			variable  CONST_PI
			return [expr {$arc * $CONST_PI / 180}] 
	}
	proc grad {arc} {
			variable  CONST_PI
			return [expr {$arc * 180 / $CONST_PI}]
	}
	
	
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
 

