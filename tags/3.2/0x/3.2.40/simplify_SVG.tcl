#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"


 ##+##########################################################################
 #
 # rattleCAD.tcl
 #
 #   rattleCAD is software of Manfred ROSENBERGER
 #       based on tclTk and BWidgets and their 
 #       own Licenses.
 # 
 #
 # wiki.tcl.tk/3884.tcl
 # add a converter to read SVG-Path and convert path-Elements into polygon & polyline
 #
 # http://www.w3.org/TR/SVG/expanded-toc.html
 #
 # http://www.selfsvg.info/?section=3.5
 #
 #

	package require Tk
	package require tdom
 
		# --- result SVG ----------
	set flatSVG [dom createDocument svg]
	set root [$flatSVG documentElement]
	$root setAttribute version 1.0
	$root setAttribute xmlns "http://www.w3.org/2000/svg"
		# --- result SVG ----------

	set pathSVG 		[dom createDocument path]
	set pathSVG_root	[$pathSVG documentElement]

	set pathDefinition	"M559.842,215.527l0.994,1.722l2.318,1.896l2.529-2.107
						  l5.9,0.211l2.318,0.421l1.688,0.844l3.371,2.951c0,0,1.477,0.21,2.738,0.421c1.268,0.21,2.742-1.053,2.742-1.053l2.107-4.849
						  l2.529-0.633l3.793-0.421l2.529,1.476l2.109-0.633l3.582-1.896l4.006-1.688l4.426-1.054l1.688-4.848l1.266-0.844l2.107-2.318
						  l2.74,0.632l3.371-0.843l1.896-1.897l2.107-0.421c0,0,1.896,0,3.373,0s4.215,4.005,4.215,4.005l2.529,3.161
						  c0,0,3.795,0.421,4.637,0.421c0.844,0,4.217,1.267,4.217,1.267l2.949,3.583l4.428-0.632h4.637l1.896,4.215l2.529,0.421l3.373,0.422
						  h3.793l1.896,5.27l2.949,7.168l2.529-4.638l4.428,0.21l1.477,5.481l-0.424,4.215l4.428-0.422l2.74,2.317l1.896,2.949l1.475,3.162
						  h4.215h4.85l1.055,1.478l1.475,0.842l4.006-0.209l2.529-2.531l0.42,6.535l2.32,2.317l3.582,3.371l-2.949,4.851l-3.162,4.426
						  l-2.318-4.637h-2.107v1.688l-0.211,2.74l-1.686,1.053l1.475,4.637l1.896,4.638l1.266,3.584l2.107,4.637l0.844,4.85l0.211,4.005
						  l1.688,2.95l1.896,2.529l0.211,2.318v3.584l-1.268,4.848l0.635,3.793l3.371,3.584l3.584,2.318l-0.213,4.215l-2.107,3.162
						  l-2.318,4.215l-2.316,3.795l-1.688,3.371l-1.477,0.211l-3.16,2.529l0.422,5.479l1.475,2.107l2.318,2.108v2.529l-1.055,1.053
						  l-3.371,0.845l1.688,2.739v6.111l0.631,5.48l1.896,2.95l2.529,0.422l0.424,2.529l1.895,1.688v5.479h-1.895l-4.43-5.69l-2.105,0.844
						  l-11.594-4.639l-6.322,1.688l-4.428,3.162l-3.584,0.842h-2.105l-2.529-1.475h-2.951l-1.266,3.793l-0.631,1.477l-3.373-1.266
						  l-5.902,2.529v2.739v3.162l-3.371,2.74l-4.848,0.633l-2.74-2.529l-2.107-2.108h-4.006l-10.537,1.477l-8.855,0.842l-4.426-1.686
						  l-8.221,1.475l0.77-0.658l-2.877-1.659l-3.584-2.951l-2.738-1.053l-0.424-1.687l-0.631-4.85v-5.06l-1.266-3.793L601.723,365
						  l-1.264-2.318l-0.633-3.373l0.844-2.737l1.896-3.373l-0.211-3.793l-1.686-2.529l-3.162-4.006l-2.318-3.162l-2.318-3.793
						  l-2.107-2.529l-3.373-1.688l-2.529-2.527l-2.529,0.842l-3.793,1.478l-2.109,0.631h-2.738l-2.318,0.211l-2.949,0.422l-3.162,0.209
						  h-2.318l-2.529,0.844h-1.896l-2.529-0.631h-1.896l-1.896,1.053l-5.27,0.211l-1.898,0.634h-1.686l-2.107,1.475l-2.107,1.896
						  l-2.74,1.476h-2.74l-1.477-0.844l-1.686-4.005l-1.266,0.423l-4.215,0.422l-2.951,0.209l-2.74-0.631l-1.475-2.529l-1.266-2.107
						  l-1.896,0.42l-1.896,0.634h-1.477l-2.738,0.422l-2.529,1.266l-3.371,1.687l-3.373,2.108l-3.162,1.264l-2.529,2.318l-1.475,2.951
						  l-1.475,2.738l-2.951,1.477l-3.371,2.951l-1.266,2.949l-4.639,2.108l-2.318-1.055l-2.949-2.107l-2.74-4.428l-0.633,0.211
						  l2.529-1.053l2.318-2.529l-0.211-3.373l1.688-3.162l1.688-3.373l2.107-2.948l-0.844-5.271l1.055-2.951l4.637-3.159l1.266-1.898
						  l-0.211-2.74l-4.006-1.053l-1.686-1.055l-2.74-5.689l-2.107-4.217l-2.318-3.793l-2.74-5.689l-2.951,0.209l-0.631,2.318
						  l-0.844,1.477l-4.637-1.266l-1.896,1.688l-1.266,1.264l-4.85-2.949l-3.371-2.318l-1.688-0.844l-2.529-8.432l-2.316-5.9
						  l-1.266-4.639l1.475-6.322l0.422-1.266h-0.211l4.217,1.055l4.848,0.631l2.74,0.633l0.631-2.319l0.633-1.896l2.74-1.896l0.633-0.631
						  v-3.373l-0.844-2.318l-2.109-2.529l-2.316-1.896l-1.266-2.32l-0.422-2.74v-2.948v-3.373l0.211-3.793l0.422-1.054l6.955-4.217
						  l4.848-2.74l3.373-2.528l3.795,2.74l1.686,0.422l3.795,0.422l1.053-0.211l1.477,1.475l4.006-1.053h0.42l3.584,3.162l3.584,3.16
						  l0.422,2.108l-0.211,2.74l1.688,0.209l1.266-2.949l3.371-0.422l2.74-0.211l1.475-2.318l2.951-0.633h1.688l2.529,2.951l2.318,1.477
						  l6.533,0.843c0,0,1.896,0,2.74,0c0.842,0,2.949-0.632,2.949-0.632l0.844-2.108l2.74-4.215l1.475-1.267h2.318l3.373-0.209
						  l1.475-2.106l-0.211-2.109l5.271-2.107l2.738-1.055l5.691-2.106l3.793-1.688l3.373-4.005l2.316-2.108"	
						  
						  
	set pathDefinition	"M 445.52492,372.22514 C 445.90652,395.55723 445.21415,418.63757 425.02492,440.56889 L 424.27492,441.41264 L 425.39992,441.41264 L 433.64992,441.53764 C 420.24442,469.42405 411.52244,497.23134 392.24367,525.00639 L 391.55617,526.00639 L 392.74367,525.78764 L 402.93117,523.85014 C 395.71427,542.16045 383.37359,554.28293 369.99367,558.35014 C 366.31107,506.78151 392.04593,461.26308 413.89992,415.88139 C 413.92002,415.83965 413.94233,415.79813 413.96242,415.75639 L 413.14992,415.19389 C 377.36425,455.2074 361.23872,511.6427 355.14992,558.19389 C 343.02146,551.34666 338.97913,542.28079 334.86867,529.94389 L 343.33742,533.50639 L 344.21242,533.88139 L 344.02492,532.94389 C 337.58858,504.32416 347.5814,483.78143 357.27492,456.78764 L 364.24367,461.44389 L 365.05617,462.00639 L 365.02492,461.03764 C 364.47892,439.10645 379.24595,417.08983 398.83742,397.44389 L 401.55617,404.72514 L 401.93117,405.69389 L 402.46242,404.78764 L 408.43117,394.85014 L 408.46242,394.78764 C 418.31429,381.21812 428.72988,376.80082 445.52492,372.22514 z "

			
	proc absolutPath {pathDefinition {position {0 0}} } {
	
		set transform(x) [lindex $position 0]
		set transform(y) [lindex $position 1]
		
		set preformatSplit	[string map { M {_M_}   Z {_Z_}   L {_L_}   H {_H_}   V {_V_}   C {_C_}   S {_S_}   Q {_Q_}   T {_T_}   A {_A_}   \
										  m {_m_}   z {_Z_}   l {_l_}   h {_h_}   v {_v_}   c {_c_}   s {_s_}   q {_q_}   t {_t_}   a {_a_} \
											  {-} {_-}    {,} {_} } \
										[string trim $pathDefinition] ]
		set valueList_tmp		[split $preformatSplit {_ }]		
		
			# puts "$pathDefFormat\n   ______pathDefFormat_____"
			# puts "$pathDefList\n   ______pathDefList_____"
		
		set pathValueList {}
		foreach value $valueList_tmp {
			if {$value == {} } {continue}
			set value [string trim $value]
			set pathValueList [lappend pathValueList $value ]			
		}
			# puts "$pathDefList\n   ______pathDefList_____"
		
		
			# -- internal procedure: return 1 if $value is a control-character in SVG-path element
			#
			proc checkControl {value} {
				set controlChar [string map { M  {__}    Z  {__}    L  {__}    H  {__}    V  {__}    C  {__}    S  {__}    Q  {__}    T  {__}    A  {__}    \
											  m  {__}    z  {__}    l  {__}    h  {__}    v  {__}    c  {__}    s  {__}    q  {__}    t  {__}    a  {__} } \
											 $value ]
				if {$controlChar == {__}} {
					return 1
				} else {
					return 0
				}
			}
		
		
			# -- convert all relative values to absolute values
			#
		array \
			set penPosition	{ {x 0}
							  {y 0} }
		
				# -- loop throug pathValueList
					#
			set pathValueList_abs 	{}
			set listIndex			0
		while {$listIndex < [llength $pathValueList]} { 
				
				# -- get value at Position
					#
			set value [lindex $pathValueList $listIndex]
							
				# -- get next Index
					#
			incr listIndex
				
				# -- check value on 
					#
			if {[checkControl $value]} {
					# puts "    ... $value"
				switch -exact $value {
					M {		# puts "    $value  ... implemented yet"
							set penPosition(x) 		[expr [lindex $pathValueList $listIndex] + $transform(x)]	; incr listIndex 
							set penPosition(y) 		[expr [lindex $pathValueList $listIndex] + $transform(y)]	; incr listIndex
							set pathValueList_abs	[lappend pathValueList_abs $value $penPosition(x) $penPosition(y)]
						}
					m { 	# puts "    $value  ... implemented yet"
							set pathValueList_abs	[lappend pathValueList_abs M]
									# puts "      $listIndex - [lindex $pathValueList $listIndex] "
							foreach {x y} [lrange $pathValueList $listIndex end] {
									# puts "          ... control: [checkControl $x]  ... $x $y  ";  
								if {[checkControl $x]} {break}								
								set penPosition(x) 		[expr $x + $penPosition(x)]	; incr listIndex 
								set penPosition(y) 		[expr $y + $penPosition(y)]	; incr listIndex
								set pathValueList_abs	[lappend pathValueList_abs $penPosition(x) $penPosition(y)]						
							}
						}
					l { 	# puts "    $value  ... implemented yet"
							set pathValueList_abs	[lappend pathValueList_abs L]
									# puts "      $listIndex - [lindex $pathValueList $listIndex] "
							foreach {x y} [lrange $pathValueList $listIndex end] {
									# puts "          ... control: [checkControl $x]  ... $x $y  ";  
								if {[checkControl $x]} {break}								
								set penPosition(x) 		[expr $x + $penPosition(x)]	; incr listIndex 
								set penPosition(y) 		[expr $y + $penPosition(y)]	; incr listIndex
								set pathValueList_abs	[lappend pathValueList_abs $penPosition(x) $penPosition(y)]						
							}
						}
					c {		# puts "    $value  ... implemented yet"
							set pathValueList_abs	[lappend pathValueList_abs C]
							set bezierIndex	0
							foreach {x y} [lrange $pathValueList $listIndex end] {
									# puts "          ... control: [checkControl $x]  ... $x $y  ";  
								if {[checkControl $x]} {break}
								set ctrlPosition(x)		[expr $x + $penPosition(x)]	; incr listIndex
								set ctrlPosition(y)		[expr $y + $penPosition(y)]	; incr listIndex
								set pathValueList_abs	[lappend pathValueList_abs $ctrlPosition(x) $ctrlPosition(y)]
								incr bezierIndex
								if {$bezierIndex > 2} {
									set penPosition(x) 		$ctrlPosition(x) 
									set penPosition(y) 		$ctrlPosition(y)
									set bezierIndex 0
								}
							}
						}
					h {		# puts "    $value  ... implemented yet"
							set pathValueList_abs	[lappend pathValueList_abs L]
							set x 	[lindex $pathValueList $listIndex]
							if {[checkControl $x]} {continue}
							set penPosition(x)		[expr $x + $penPosition(x)]	; incr listIndex
							set pathValueList_abs	[lappend pathValueList_abs $penPosition(x) $penPosition(y)]
						}
					v {		# puts "    $value  ... implemented yet"
							set pathValueList_abs	[lappend pathValueList_abs L]
							set y 	[lindex $pathValueList $listIndex]
							if {[checkControl $y]} {continue}
							set penPosition(y)		[expr $y + $penPosition(y)]	; incr listIndex
							set pathValueList_abs	[lappend pathValueList_abs $penPosition(x) $penPosition(y)]
						}
					L  { 	# puts "    $value  ... implemented yet"
							set pathValueList_abs	[lappend pathValueList_abs L]
									# puts "      $listIndex - [lindex $pathValueList $listIndex] "
							foreach {x y} [lrange $pathValueList $listIndex end] {
									# puts "          ... control: [checkControl $x]  ... $x $y  ";  
								if {[checkControl $x]} {break}								
								set penPosition(x) 		[expr $x  + $transform(x)]	; incr listIndex 
								set penPosition(y) 		[expr $y  + $transform(y)]	; incr listIndex
									# set penPosition(x) 		[expr $x + $penPosition(x)]	; incr listIndex 
									# set penPosition(y) 		[expr $y + $penPosition(y)]	; incr listIndex
								set pathValueList_abs	[lappend pathValueList_abs $penPosition(x) $penPosition(y)]						
								# puts "  [checkControl $x]
							}
						}					
					H {		# puts "    $value  ... implemented yet"
							set pathValueList_abs	[lappend pathValueList_abs L]
							set x 	[lindex $pathValueList $listIndex]
							if {[checkControl $x]} {continue}
							set penPosition(x)		[expr $x  + $transform(x)]	; incr listIndex
								# set ctrlPosition(x)		[expr $x + $penPosition(x)]	; incr listIndex
							set pathValueList_abs	[lappend pathValueList_abs $penPosition(x) $penPosition(y)]
						}
					V {		# puts "    $value  ... implemented yet"
							set pathValueList_abs	[lappend pathValueList_abs L]
							set y 	[lindex $pathValueList $listIndex]
							if {[checkControl $y]} {continue}
							set penPosition(y)		[expr $y  + $transform(y)]	; incr listIndex
								# set penPosition(y)		[expr $y + $penPosition(y)]	; incr listIndex
							set pathValueList_abs	[lappend pathValueList_abs $penPosition(x) $penPosition(y)]
						}
					C {		# puts "    $value  ... implemented yet"
							set pathValueList_abs	[lappend pathValueList_abs C]
									# puts "      $listIndex - [lindex $pathValueList $listIndex] "
							foreach {x y} [lrange $pathValueList $listIndex end] {
									 # puts "          ... control: [checkControl $x]  ... $x $y  ";  
								if {[checkControl $x]} {break}								
								set penPosition(x) 		[expr $x + $transform(x)]	; incr listIndex 
								set penPosition(y) 		[expr $y + $transform(y)]	; incr listIndex
								set pathValueList_abs	[lappend pathValueList_abs $penPosition(x) $penPosition(y)]						
								# puts "  [checkControl $x]
							}
						}					
					S -
					Q -
					T -
					A -
					s -
					q -
					t -
					a {
						# incr listIndex
						puts "    $value  ... not implemented yet  - $listIndex"
					}
					Z -
					z {
							# puts "    $value  ... implemented yet  - $listIndex" 
							set pathValueList_abs	[lappend pathValueList_abs Z]						
					}

					default {
						# incr listIndex
						puts "    $value  ... not registered yet  - $listIndex"
					}	
				}
			
			}
		}
					
		return $pathValueList_abs
	}
		
			# puts "\n$pathDefinition\n   ______pathDefinition_____\n"
			# set pathValueList	[ absolutPath $pathDefinition [list 0 0]]
			# puts "\n$pathValueList\n   ______pathValueList_____\n"
			# set pathValueList	[ absolutPath $pathDefinition [list 30 20]]
			# puts "\n$pathValueList\n   ______pathValueList_____\n"		
			# exit
		


	proc recurseInsert {w node parent} {
			set name [$node nodeName]
			set done 0
			if {$name eq "#text" || $name eq "#cdata"} {
				set text [string map {\n " "} [$node nodeValue]]
			} else {
				set text <$name
				foreach att [getAttributes $node] {
					catch {append text " $att=\"[$node getAttribute $att]\""}
				}
				append text >
				set children [$node childNodes]
				if {[llength $children]==1 && [$children nodeName] eq "#text"} {
					append text [$children nodeValue] </$name>
					set done 1
				}
			}
			$w insert $parent end -id $node -text $text
			if {$parent eq {}} {$w item $node -open 1}
			if !$done {
				foreach child [$node childNodes] {
					recurseInsert $w $child $node
				}
			}
	}

	
	proc getAttributes node {
			if {![catch {$node attributes} res]} {set res}
	}	


	
	proc Bezier {xy {PRECISION 10}} {
				# puts "           -> $xy"
			set PRECISION 8
			set np [expr {[llength $xy] / 2}]
			if {$np < 4} return
			
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



	proc simplifySVG {domSVG {parentTransform {0 0}}} {
			
			puts "\n"
			puts "  =============================================="
			puts "   -- simplifySVG"
			puts "  =============================================="
			puts "\n"

			variable flatSVG
				# puts "  ... [ $flatSVG asXML]\n"
			set root [ $flatSVG documentElement ]
				# puts "  ... [ $root asXML]\n"
			set transform(parent) $parentTransform
			foreach {transform(parent_x) transform(parent_y)} $transform(parent) break;
				# puts "       ... parent:  $transform(parent_x) / $transform(parent_y)\n"
			
			
				# puts " --- simplifySVG --"
			foreach node [$domSVG childNodes] {
						# puts "   ... $node"
					if {[$node nodeType] != {ELEMENT_NODE}} continue
				
						# -- set defaults
					set objectPoints {}


						# -- get transform attribute
					if {[catch {set transform(this)  [ $node getAttribute transform ]} errmsg] } {
						set transform(this_x) 0
						set transform(this_y) 0
					} else {
						set transform(this)  [ lrange [ split [ $node getAttribute transform ] (,) ] 1 2]
						foreach {transform(this_x) transform(this_y)} $transform(this) break
					}
					
						# puts "       ... this:    $transform(this_x) / $transform(this_y)"
					set transform(this_x) [expr $transform(this_x) + $transform(parent_x)] 
					set transform(this_y) [expr $transform(this_y) + $transform(parent_y)] 
						# puts "         ... this:  $transform(this_x) / $transform(this_y)\n"
					
						# -- get nodeName
					set nodeName [$node nodeName]
					
						# puts "  ... $nodeName :"
						# puts "     ... $transform(this_x) / $transform(this_y)"

					
					switch -exact $nodeName {
							g {
											# puts "\n\n  ... looping"
											# puts "   [$node asXML]"
										simplifySVG $node [list $transform(this_x) $transform(this_y)]
								}
							rect {
										set myNode [ $flatSVG createElement $nodeName]
											$myNode setAttribute x				[ $node getAttribute x      ]
											$myNode setAttribute y				[ $node getAttribute y      ]
											$myNode setAttribute width			[ $node getAttribute width  ]
											$myNode setAttribute height			[ $node getAttribute height ]
											$myNode setAttribute fill			none
											$myNode setAttribute stroke			black
											$myNode setAttribute stroke-width	0.1
										$root appendChild $myNode
								}
							polygon {
										set valueList 	[ $node getAttribute points ]
										set myNode 		[ $flatSVG createElement 	$nodeName]
											$myNode setAttribute points	$valueList
											$myNode setAttribute fill			none
											$myNode setAttribute stroke			black
											$myNode setAttribute stroke-width	0.1
										$root appendChild $myNode
								}
							polyline { # polyline class="fil0 str0" points="44.9197,137.492 47.3404,135.703 48.7804,133.101 ...
										set valueList 	[ $node getAttribute points ]
										set myNode 		[ $flatSVG createElement $nodeName]
											$myNode setAttribute points	$valueList
											$myNode setAttribute fill			none
											$myNode setAttribute stroke			black
											$myNode setAttribute stroke-width	0.1
										$root appendChild $myNode
								}
							line { # line class="fil0 str0" x1="89.7519" y1="133.41" x2="86.9997" y2= "119.789"
										set myNode 		[ $flatSVG createElement $nodeName]
											$myNode setAttribute x1		[ $node getAttribute x1 ]
											$myNode setAttribute y1		[ $node getAttribute y1 ]
											$myNode setAttribute x2		[ $node getAttribute x2 ]
											$myNode setAttribute y2		[ $node getAttribute y2 ]
											$myNode setAttribute fill			none
											$myNode setAttribute stroke			black
											$myNode setAttribute stroke-width	0.1
										$root appendChild $myNode
								}
							circle { # circle class="fil0 str2" cx="58.4116" cy="120.791" r="5.04665"
										# --- dont display the center_object with id="center_00"
										set myNode 		[ $flatSVG createElement $nodeName]
											$myNode setAttribute cx		[ $node getAttribute cx ]
											$myNode setAttribute cy		[ $node getAttribute cy ]
											$myNode setAttribute r 		[ $node getAttribute r  ]
											$myNode setAttribute fill			none
											$myNode setAttribute stroke			black
											$myNode setAttribute stroke-width	0.1
										$root appendChild $myNode
								}
							path { # path d="M ......."
										# absolutPath
										set svgPath 	[ absolutPath [ $node getAttribute d ] [ list $transform(this_x) $transform(this_y)] ]
										set splitIndex	[lsearch -exact -all $svgPath {M}]
										set splitIndex	[lappend splitIndex end]
											set i 0
										while {$i < [llength $splitIndex]-1} {
												set indexStart 	[lindex $splitIndex $i]
												set indexEnd 	[lindex $splitIndex $i+1]
												incr i
												
												if {$indexEnd != {end}} {set indexEnd [expr $indexEnd -1 ]}
												set pathSegment [lrange $svgPath $indexStart $indexEnd ]
													# puts "   ... $indexStart / $indexEnd"
													# puts "   ... $i   [lindex $splitIndex $i]"
													# puts "      ... $pathSegment"
												
												
												if { [lindex $pathSegment end] == {Z} } {
														set pathSegment		[string trim [string map {Z { }} $pathSegment] ]
														set elementType 	polygon
												} else {
														set elementType 	polyline
												}
													# puts "\n$pathSegment\n_________pathSegment________"
												set objectPoints [ convertPath2Line $pathSegment ]
													# puts "\n$objectPoints\n_________objectPoints________"

												set myNode [ $flatSVG createElement $elementType]
													$myNode setAttribute points 		$objectPoints
													$myNode setAttribute fill			none
													$myNode setAttribute stroke			black
													$myNode setAttribute stroke-width	0.1
												$root appendChild $myNode
										}
										
										# puts "       ... search for:   [lsearch -exact -all $svgPath {M}]\n"

								}		

							default { }
					}
					# puts "        $nodeName:  $objectPoints"
				
			}
			
				# puts [$root asXML]
			return $root
	}


	proc convertPath2Line {pathDefinition} {
			# -------------------------------------------------
			# http://www.selfsvg.info/?section=3.5
			# 
			# -------------------------------------------------
				# puts "\n\n === new pathString =====================\n"		

				# puts "\npathString:\n  $pathString\n"			
			
				# puts " - > pathDefinition:\n$pathDefinition\n"

			
			set canvasElementType 	line
			set controlString		{}
			set isClosed			{no}

				# puts " ... convertPath2Line :\n$pathString"
			set pathString	[string map { M {_M}   L {_L}   H {_H}   V {_V}   C {_C}   S {_S}   Q {_Q}   T {_T}   A {_A} }   [string trim $pathDefinition] ]
			
			set lineString 		{}
			set segmentList 	[split $pathString {_}]
				# puts "$segmentList\n-------------------------convertPath2Line---"
			set cleanList 		{}
			foreach value $segmentList {
					if {$value == {}} {continue}
					set cleanList [lappend cleanList $value]
			}
			set segmentList $cleanList
				# puts "$segmentList\n-------------------------convertPath2Line---"
			
			
			set prevCoord_x 		55
			set prevCoord_y 		55
			
			set ref_x 0
			set ref_y 0
			
			set loopControl 0
			
			foreach segment $segmentList {
				
					# puts "\n\n_____loop_______________________________________________"
					# puts "\n\n      $ref_x $ref_y\n_____ref_x___ref_y________"
					# puts "\n\n      <$segment>\n_____segment________"

			
					# puts "  ... $segment"
				set segmentDef			[split [string trim $segment]]
				set segmentType 		[lindex $segmentDef 0]
				set segmentCoords 		[lrange $segmentDef 1 end]
					# puts "\n$segmentType - [llength $segmentCoords] - $segmentCoords\n____type__segmentCoords__"
					
				switch -exact $segmentType {
					M 	{ #MoveTo 
							set lineString 		[ concat $lineString 	$segmentCoords ]
							set ref_x 	[ lindex $segmentCoords 0 ]
							set ref_y 	[ lindex $segmentCoords 1 ]
						}
					L 	{ #LineTo - absolute
							set lineString 		[ concat $lineString 	$segmentCoords ] 
							set ref_x 	[ lindex $segmentCoords end-1]
							set ref_y 	[ lindex $segmentCoords end  ]
						} 
					C 	{ # Bezier - absolute
								# puts "\n\n  [llength $segmentCoords] - $segmentCoords\n______segmentCoords____"
							# puts "\n( $ref_x / $ref_y )\n      ____start_position__"
							# puts "\n$segmentType - [llength $segmentCoords] - ( $ref_x / $ref_y ) - $segmentCoords\n      ______type__segmentCoords__"
							
							set segmentValues	{}
							foreach {value} $segmentCoords {
								set segmentValues 	[ lappend segmentValues $value ]						
							}
							
								# exception on to less values
									# 	- just a line to last coordinate
									#								
							if {[llength $segmentValues] < 6 } {\
								set ref_x 	[ lindex $segmentValues end-1]
								set ref_y 	[ lindex $segmentValues end  ]
								set lineString [ concat $lineString $ref_x $ref_y ]
									puts "\n\n      <[llength $segmentValues]> - $segmentValues\n_____Exception________"
								continue
							}
							
								# continue Bezier definition
									# 	- just a line to last coordinate
									#								
							set segmentValues	[ linsert $segmentValues 0 $ref_x $ref_y ]							
								# puts "\n  [llength $segmentValues_abs] - $segmentValues_abs\n______segmentValues_abs____"
							set bezierValues	[ Bezier $segmentValues]
							set ref_x 	[ lindex $bezierValues end-1]
							set ref_y 	[ lindex $bezierValues end  ]
								# puts "           ===================="
								# puts "           $prevCoord -> $prevCoord"
								# puts "                 $bezierString"
								# puts "            ===================="							
							set lineString 		[ concat $lineString 	[lrange $bezierValues 2 end] ]
						}
						
						default {
							puts "\n\n  ... whats on there?  ->  $segmentType \n\n"
						}
				}
				
					# incr loopControl
					# puts "  ... $loopControl"
				
				# puts "\n( $ref_x / $ref_y )\n      ____end_position__"				
				# puts "\n\n      $ref_x $ref_y\n_____ref_x___ref_y________"
			}
			
			foreach {x y}  [split $lineString { }] {
				set pointList [lappend pointList "$x,$y"]
			}
			# puts "-> pointList:\n$pointList\n"
			return $pointList
			
	}

	
	proc drawSVG {domSVG canvas {transform {0 0}}} {
			
			puts "\n"
			puts "  =============================================="
			puts "   -- drawSVG"
			puts "  =============================================="
			puts "\n"

			set nodeList 	  [$domSVG childNodes]
			
			foreach {transform_x transform_y} $transform break;	
			
				# return
			foreach node $nodeList {
						
						# puts [$node asXML]
						
						# -- set defaults
					set objectPoints {}
					
					set nodeName [$node nodeName]
					switch -exact $nodeName {
							rect {
										set x 		[expr [$node getAttribute x] + $transform_x ]
										set y 		[expr [$node getAttribute y] + $transform_y ]
										set width   [$node getAttribute  width ]
										set height  [$node getAttribute  height]
										set x2 [expr $x + $width ]
										set y2 [expr $y - $height]
										set objectPoints [list $x $y $x $y2 $x2 $y2 $x2 $y]
											# -- create rectangle
												# puts "$canvas create polygon 	$objectPoints -outline black -fill white"
										$canvas create polygon 	$objectPoints -outline black -fill white
								}
							polygon {
										set valueList [ $node getAttribute points ]
										foreach {coords} $valueList {
											foreach {x y}  [split $coords ,] break
											set x 	[expr $x + $transform_x ]
											set y 	[expr $y + $transform_y ]
											set objectPoints [lappend objectPoints $x $y ]
										}
											# -- create polygon
												# puts "\n$canvas create polygon 	$objectPoints -outline black -fill white"
										$canvas create polygon 	$objectPoints -outline black -fill {}
								}
							polyline { # polyline class="fil0 str0" points="44.9197,137.492 47.3404,135.703 48.7804,133.101 ...
										set valueList [ $node getAttribute points ]
										foreach {coords} $valueList {
											foreach {x y}  [split $coords ,] break
											set x 	[expr $x + $transform_x ]
											set y 	[expr $y + $transform_y ]
											set objectPoints [lappend objectPoints $x $y ]
										}
											# -- create polyline
												# puts "$canvas create line $objectPoints -fill black"
										$canvas create line $objectPoints -fill black
								}
							line { # line class="fil0 str0" x1="89.7519" y1="133.41" x2="86.9997" y2= "119.789"
										set objectPoints [list 	[expr [$node getAttribute x1] + $transform_x ] [expr -([$node getAttribute y1] + $transform_y )] \
																[expr [$node getAttribute x2] + $transform_x ] [expr -([$node getAttribute y2] + $transform_y )] ]
											# -- create line
												# puts "$canvas create line $objectPoints -fill black"
										$canvas create line $objectPoints -fill black
									}
							circle { # circle class="fil0 str2" cx="58.4116" cy="120.791" r="5.04665"
										# --- dont display the center_object with id="center_00"
										set cx [expr [$node getAttribute cx] + $transform_x ]
										set cy [expr [$node getAttribute cy] + $transform_y ]
										set r  [$node getAttribute  r]
										set x1 [expr $cx - $r]
										set y1 [expr $cy - $r]
										set x2 [expr $cx + $r]
										set y2 [expr $cy + $r]
										set objectPoints [list $x1 $y1 $x2 $y2]
											# -- create circle
												# puts "$canvas create oval $objectPoints -fill black"
										$canvas create oval $objectPoints -fill black
								}
							default {}
					}
				
			}
	
	}
			


		# --- window ----------
		#
	pack [ frame .f -bg yellow] 
		
	set nb_result	[ ttk::notebook .f.nb ]
		pack $nb_result  	-expand yes -fill both   
	$nb_result add [frame $nb_result.nb_canvas]		-text "... Canvas" 		
	$nb_result add [frame $nb_result.nb_original]	-text "... original SVG" 
	$nb_result add [frame $nb_result.nb_tree]		-text "... simplified SVG" 
	$nb_result add [frame $nb_result.nb_text]		-text "... XML as Text" 

	
	set canvasFrame [ frame	$nb_result.nb_canvas.f  	-relief sunken ]
		pack $canvasFrame  -expand yes -fill both -padx 15 -pady 15
	set origFrame 	[ frame	$nb_result.nb_original.f    -relief sunken ]
		pack $origFrame    -expand yes -fill both
	set treeFrame 	[ frame	$nb_result.nb_tree.f    	-relief sunken ]
		pack $treeFrame    -expand yes -fill both
	set textFrame 	[ frame	$nb_result.nb_text.f    	-relief sunken ]
		pack $textFrame    -expand yes -fill both

		
		# --- result canvas ---
		#
	set resultCanvas [ canvas $canvasFrame.cv -width 900 -height 800 -relief sunken -bg white]
		pack   $resultCanvas -fill both -expand yes -padx 0 -pady 0
 
 
		# --- result canvas ---
		#
	set originalTree [ ttk::treeview $origFrame.t 	-yscrollcommand "$origFrame.y set" \
													-xscrollcommand "$origFrame.x set" -height 40 ]
	scrollbar $origFrame.x -ori hori -command  "$origFrame.t xview"
	scrollbar $origFrame.y -ori vert -command  "$origFrame.t yview"
		grid $origFrame.t $origFrame.y    -sticky news
		grid $origFrame.x     		    -sticky news
		grid rowconfig    $origFrame 0 -weight 1
		grid columnconfig $origFrame 0 -weight 1

		
		# --- result treeview ---
		#
	set resultTree [ ttk::treeview $treeFrame.t 	-xscrollcommand "$treeFrame.x set" \
													-yscrollcommand "$treeFrame.y set" -height 40 ]
	scrollbar $treeFrame.x -ori hori -command  "$treeFrame.t xview"
	scrollbar $treeFrame.y -ori vert -command  "$treeFrame.t yview"
		grid $treeFrame.t 	$treeFrame.y  -sticky news
		grid 				$treeFrame.x  -sticky news
		grid rowconfig    	$treeFrame 0  -weight 1
		grid columnconfig 	$treeFrame 0  -weight 1

		
		# --- result textview ---
	set resultText [ text $textFrame.txt -wrap none -xscroll "$textFrame.h set" \
													-yscroll "$textFrame.v set" -height 50 -width 160 ]
	scrollbar $textFrame.v -orient vertical   -command "$textFrame.txt yview"
	scrollbar $textFrame.h -orient horizontal -command "$textFrame.txt xview"
		# Lay them out
		grid $textFrame.txt $textFrame.v -sticky nsew
		grid $textFrame.h        -sticky nsew
		# Tell the text widget to take all the extra room
		grid rowconfigure    $textFrame.txt 0 -weight 1
		grid columnconfigure $textFrame.txt 0 -weight 1 




	
		# --- compute ----------
		#
	if {$argc == 0} {
		set fileName [tk_getOpenFile]
		if {$fileName == {}} {exit}
		set fp [open $fileName]
	} else {
		set fp [open [file join [lindex $argv 0]]]
	}
	fconfigure    $fp -encoding utf-8
	set xml [read $fp]
	close         $fp
 
	dom parse  $xml doc
	$doc documentElement root

	set flatSVG [simplifySVG $root ]


	drawSVG $flatSVG $resultCanvas {15 15}
	recurseInsert $originalTree	$root 		{}
	recurseInsert $resultTree 	$flatSVG 	{}
	$resultText insert end [$flatSVG asXML]
# exit