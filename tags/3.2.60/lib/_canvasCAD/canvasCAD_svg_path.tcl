 
 ##+##########################################################################
 #
 # package: canvasCAD 	->	canvasCAD_svg.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2010/10/24

 ## Cubic Tension Splines: TensionSpline.tcl

 ###############################################################################################
 ## Greg Blair 2003-09-29								     ##
 ## I took Keith Vetters Cubic Spline code and added TC and TCB tension, cardinal,	    ##
 ## Catmull Rom splines as well as linear and cosine interpolation			    ##
 ## using C code I found at:								  ##
 ##											   ##
 ## http://astronomy.swin.edu.au/~pbourke/analysis/interpolation/ and			 ##
 ## http://www.cubic.org/~submissive/sourcerer/hermite.htm				    ##
 ##											   ##
 ## I hand converted the c code to TCL, and extended Keith's test GUI for the new curve types ##
 ##											   ##
 ## I have include the comments from the websites as documentation to the methods implemented ##
 ###############################################################################################

 ##Keith Vetter 2003-03-07 - one feature often noted as missing from tk the ability of the canvas to do cubic splines.

 ##Here is a routine PolyLine::CubicSpline that takes a list of (x,y) values of control points and returns a
 ## list points on the cubic spline curve that's suitable to be used by: canvas create line [PolyLine::CubicSplint $xy] ...

 ##+##########################################################################
 #
 # CubicSpline -- routines to generate the coordinates of a cubic spline
 # given a list of control points. Also included is demo/test harness
 # by Keith Vetter
 #
 # Revisions:
 # KPV Mar 07, 2003 - initial revision
 #
 

	proc path2Line {pathString position} { 
		  
		set path_preformated [string map { M {_M}   L {_L}   H {_H}   V {_V}   C {_C}   S {_S}   Q {_Q}   T {_T}   A {_A}    
										   m {_m}   l {_l}   h {_h}   v {_v}   c {_c}   s {_s}   q {_q}   t {_t}   a {_a} }  [string trim $pathString] ]
		set pathList 	[split $path_preformated {_}]
		
			# --- clean pathList from empty entries -------------
			#
		set cleanPathList {}
		foreach segment $pathList {
			if {$segment != {}} {lappend cleanPathList $segment}
		}

		set pathList $cleanPathList	
		
			# --- add startCoord to close attribute Z -----------
			#
		set startCoord [lindex [split [lindex $pathList 0] ] 1]
				# puts "  [llength $pathList] $startCoord"
		set segmentEnd [lindex $pathList end]
				# puts "    $segmentEnd"
		if {$segmentEnd == {Z}} {
			set pathList [lrange $pathList 0 end-1]
			set pathList [lappend pathList "Z $startCoord"]
		}
		
			# --- set default --------------------------------
			#		
		set canvasElementType 	line
		set pathString 			{}		
		set controlString		{}
		set segmentIndex 		0

		
			# loop through $pathList
			#
		while {$segmentIndex < [llength $pathList] } {
			set segmentValues_abs 	{}
			set segment				[string trim [lindex $pathList $segmentIndex] ]
			set segmentType 		[string index $segment 0 ]
			set segmentValueString	[string trim [string map {, { }} [string range $segment 1 end ]]]
			set segmentValues		[split $segmentValueString]
				# puts "\n        $segmentIndex: $segmentType:  $segmentValueString"

			switch -exact $segmentType {
				M 	{ #moveTo 
							# puts "   ... $segmentValues"
						set pathString 		[ concat $pathString 	$segmentValues ]
						set controlString 	[ concat $controlString $segmentValues ]
						set prevCoord(x) 	[ lindex $segmentValues end-1]
						set prevCoord(y) 	[ lindex $segmentValues end  ]
					}
				L 	{ #LineTo - absolute
						set pathString 		[ concat $pathString 	$segmentValues ] 
						set controlString 	[ concat $controlString $segmentValues ] 
						set prevCoord(x) 	[ lindex $segmentValues end-1]
						set prevCoord(y) 	[ lindex $segmentValues end  ]
					} 
				l 	{ #LineTo - relative
								# puts "   ... $segmentValues"
								# puts "   ... [llength $segmentValues]  >$segmentValues<"
						foreach {x y} $segmentValues {
								# puts "        ... $x $y"
							set x [expr $x + $prevCoord(x)]
							set y [expr $y + $prevCoord(y)]
							set segmentValues_abs 	[ lappend segmentValues_abs $x $y ]
						}
							# reset on relative position
						set prevCoord(x) $x
						set prevCoord(y) $y
						
						set pathString 			[ concat $pathString 	$segmentValues_abs ] 
						set controlString 		[ concat $controlString $segmentValues_abs ] 
					} 
				C 	{ # Bezier - absolute
						set segmentValues_abs	[ lappend segmentValues_abs $prevCoord(x) $prevCoord(y) ]
						foreach {value} $segmentValues {
							set segmentValues_abs 	[ lappend segmentValues_abs $value ]						
						}
						set controlString 	[ concat $controlString	[lrange $segmentValues_abs 2 end] ] 

						set bezierValues	[ Polyline_Bezier $segmentValues_abs]
						set prevCoord(x) 	[ lindex $bezierValues end-1]
						set prevCoord(y) 	[ lindex $bezierValues end  ]
							# puts "           ===================="
							# puts "           $prevCoord -> $prevCoord"
							# puts "                 $bezierString"
							# puts "            ===================="							
						set pathString 		[ concat $pathString 	[lrange $bezierValues 2 end] ]								
					}
				c 	{ # Bezier - relative
								# puts "   ... [llength $segmentValues]  >$segmentValues<"
						set segmentValues_abs	[ lappend segmentValues_abs $prevCoord(x) $prevCoord(y) ]
						foreach {x y} $segmentValues {
										puts "                ... $x  $y"
							set x [expr $x + $prevCoord(x)]
							set y [expr $y + $prevCoord(y)]
										puts "                ...   $x  $y"
							set segmentValues_abs 	[ lappend segmentValues_abs $x $y ]
						}
						set prevCoord(x) $x
						set prevCoord(y) $y
						set controlString 	[ concat $controlString	[lrange $segmentValues_abs 2 end] ]
						
							# reset on relative position
										
						set bezierValues	[ Polyline_Bezier $segmentValues_abs]
						foreach {x y} $segmentValues_abs {
							puts [format "               control:    %2.4f %2.4f" $x $y]
						}
						foreach {x y} $bezierValues {
							puts [format "               bezier:     %2.4f %2.4f" $x $y]
						}
							# puts "           ===================="
							# puts "         abs  ... $segmentValues_abs "
							# puts "            bezier     ... $bezierValues"
							# puts "            ===================="
						
						set pathString 		[ concat $pathString 	[lrange $bezierValues 2 end] ]								
					}
						
				default {}
			}
			# puts "           ... continue:  $prevCoord(x) $prevCoord(y)"
			
			incr segmentIndex
		}

			# puts "\npathString:\n$pathString\n"
			# puts "\ncontrolString:\n$controlString\n"
		set pathList {}
		foreach {a b} $position break;
		foreach {x y} [split $pathString { }] {
			set pathList [lappend pathList [expr ($x-$a)] [expr -($y-$b)]]
		}		
		
		return $pathList	

	}		



	proc Polyline_Bezier {xy {PRECISION 10}} {

			# puts "           -> $xy"
		set PRECISION 8
		set np [expr {[llength $xy] / 2}]
		if {$np < 4} return

		set idx 0
		foreach {x y} $xy {
		set X($idx) $x
		set Y($idx) $y
		incr idx
		}

		set xy {}

		set idx 0
		while {[expr {$idx+4}] <= $np} {
			set a [list $X($idx) $Y($idx)]; incr idx
			set b [list $X($idx) $Y($idx)]; incr idx
			set c [list $X($idx) $Y($idx)]; incr idx
			set d [list $X($idx) $Y($idx)];# incr idx   ;# use last pt as 1st pt of next segment
			for {set j 0} {$j <= $PRECISION} {incr j} {
				set mu [expr {double($j) / double($PRECISION)}]
				set pt [BezierSpline $a $b $c $d $mu]
				lappend xy [lindex $pt 0] [lindex $pt 1]
			}
		}
			# puts "             -> $xy"
		return $xy
	}

	proc BezierSpline {a b c d mu} {
			# --------------------------------------------------------
			# http://www.cubic.org/~submissive/sourcerer/bezier.htm
			# evaluate a point on a bezier-curve. mu goes from 0 to 1.0
			# --------------------------------------------------------

		set  ab   [Lerp $a    $b    $mu]
		set  bc   [Lerp $b    $c    $mu]
		set  cd   [Lerp $c    $d    $mu]
		set  abbc [Lerp $ab   $bc   $mu]
		set  bccd [Lerp $bc   $cd   $mu]
		return    [Lerp $abbc $bccd $mu]
	}

	proc Lerp {a b mu} {
			# -------------------------------------------------
			# http://www.cubic.org/~submissive/sourcerer/bezier.htm
			# simple linear interpolation between two points
			# -------------------------------------------------
		set ax [lindex $a 0]
		set ay [lindex $a 1]
		set bx [lindex $b 0]
		set by [lindex $b 1]
		return [list [expr {$ax + ($bx-$ax)*$mu}] [expr {$ay + ($by-$ay)*$mu}] ]
	}