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
		# $flatSVG setResultEncoding iso8859-1
	set root [$flatSVG documentElement]
	$root setAttribute version 1.0
	$root setAttribute xmlns "http://www.w3.org/2000/svg"
			#set myNode  [ $flatSVG createElement {loopNode} ]
			#$root appendChild $myNode
			#puts "  ... [ $flatSVG asXML]\n"
			#puts "  ... [ $root asXML]\n"
			#exit			
			#exit
		# --- result SVG ----------

		
	proc Bezier {xy {PRECISION 10}} {
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

	proc createPath {pathString } { 
			# -------------------------------------------------
			# http://www.selfsvg.info/?section=3.5
			# 
			# -------------------------------------------------
				# puts "\n\n === new pathString =====================\n"		

				# puts "\npathString:\n  $pathString\n"
			
			set path_preformated [string map { M {_M}   Z {_Z}   L {_L}   H {_H}   V {_V}   C {_C}   S {_S}   Q {_Q}   T {_T}   A {_A}    
											   m {_m}   z {_Z}   l {_l}   h {_h}   v {_v}   c {_c}   s {_s}   q {_q}   t {_t}   a {_a} }  [string trim $pathString] ]
				# puts "\npath_preformated:\n$path_preformated\n"
			
			set pathList 	[split $path_preformated {_}]
			
				# --- clean pathList from empty entries -------------
				#
			set cleanPathList {}
			foreach segment $pathList {
				if {$segment != {}} {lappend cleanPathList $segment}
			}
					# puts "   ... [llength $pathList]"
					# puts "   ... [llength $cleanPathList]"
			set pathList $cleanPathList	
			
				# --- add startCoord to close attribute Z -----------
				#
			set startCoord [lindex [split [lindex $pathList 0] ] 1]
					# puts "  [llength $pathList] $startCoord"
			set segmentEnd [lindex $pathList end]
					# puts "    $segmentEnd"

			
			
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

							set bezierValues	[ Bezier $segmentValues_abs]
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
											# puts "                ... $x  $y"
								set x [expr $x + $prevCoord(x)]
								set y [expr $y + $prevCoord(y)]
											# puts "                ...   $x  $y"
								set segmentValues_abs 	[ lappend segmentValues_abs $x $y ]
							}
							set prevCoord(x) $x
							set prevCoord(y) $y
							set controlString 	[ concat $controlString	[lrange $segmentValues_abs 2 end] ]
							
								# reset on relative position
											
							set bezierValues	[ Bezier $segmentValues_abs]
							foreach {x y} $segmentValues_abs {
								# puts [format "               control:    %2.4f %2.4f" $x $y]
							}
							foreach {x y} $bezierValues {
								# puts [format "               bezier:     %2.4f %2.4f" $x $y]
							}
								# puts "           ===================="
								# puts "         abs  ... $segmentValues_abs "
								# puts "            bezier     ... $bezierValues"
								# puts "            ===================="
							
							set pathString 		[ concat $pathString 	[lrange $bezierValues 2 end] ]								
						}
					Z	{	set pathString 		[ concat closed closed $pathString ] }	
							
					default {}
				}
					# puts "           ... continue:  $prevCoord(x) $prevCoord(y)"
				
				incr segmentIndex
			}
			
			
			
			
			
				# puts "\npathString:\n$pathString\n"
				# puts "\ncontrolString:\n$controlString\n"
			set pointList {}
			foreach {x y}  [split $pathString { }] {
				set pointList [lappend pointList "$x,$y"]
			}
			
			return $pointList

	}		


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
 
	
	proc simplifySVG {domSVG} {
			
			puts "\n"
			puts "  =============================================="
			puts "   -- simplifySVG"
			puts "  =============================================="
			puts "\n"

			variable flatSVG
				# puts "  ... [ $flatSVG asXML]\n"
			set root [ $flatSVG documentElement ]
				# puts "  ... [ $root asXML]\n"		
				# set myNode  [ $flatSVG createElement {loopNode} ]
				# $root appendChild $myNode		
					# puts "  ... [ $flatSVG asXML]"; exit
				# puts "  ... [ $flatSVG asXML]\n"
				# puts "  ... [ $root asXML]\n"

			
			
				# puts " --- simplifySVG --"
			foreach node [$domSVG childNodes] {
						# puts "   ... $node"
					if {[$node nodeType] != {ELEMENT_NODE}} continue
				
						# -- set defaults
					set objectPoints {}

						# -- get transform attribute
					catch {set transform    [ $node getAttribute transform ] }
					
					set nodeName [$node nodeName]
					switch -exact $nodeName {
							g {
											# puts "\n\n  ... looping"
											# puts "   [$node asXML]"
										simplifySVG $node 
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
							path {
										set pathString 	[ $node getAttribute d ]
										set pathString_preformated [string map { m {_m}  M {_M} } $pathString]
										set pathList   [ split [string trim $pathString_preformated] "_"]
											# puts "  ... [llength $pathList] - $pathList"
										set cleanList {}
										foreach element $pathList {
											if {$element != {} } {
												set cleanList [lappend cleanList [string trim $element] ]
											}
										}
										set pathList $cleanList
										if {[llength $pathList] > 1} {
											# puts "     ... split: [llength $pathList]"
										}
										#foreach pathString $pathList {\
											puts "     ... >$pathString<" \
										}

										foreach pathString $pathList {
												set objectPoints [ createPath $pathString ]	
													# puts "        $nodeName:  $objectPoints"
													# puts "\n   ... [lindex $objectPoints 0] \n"
												if { [lindex $objectPoints 0] == {closed,closed} } {
														set elementType 	polygon
														set objectPoints 	[lrange $objectPoints 1 end]
												} else {
														set elementType 	polyline
												}
												set myNode [ $flatSVG createElement $elementType]
													$myNode setAttribute points 		$objectPoints
													$myNode setAttribute fill			none
													$myNode setAttribute stroke			black
													$myNode setAttribute stroke-width	0.1
												$root appendChild $myNode
										}
										continue
								}
							default { }
					}
					# puts "        $nodeName:  $objectPoints"
				
			}
			
				# puts [$root asXML]
			return $root
	}

	
	proc drawSVG {domSVG canvas} {
			
			puts "\n"
			puts "  =============================================="
			puts "   -- drawSVG"
			puts "  =============================================="
			puts "\n"

			set nodeList 	  [$domSVG childNodes]
				# return
			foreach node $nodeList {
					# puts $node
						# -- set defaults
					set objectPoints {}
					
					set nodeName [$node nodeName]
					switch -exact $nodeName {
							rect {
										set x 		[$node getAttribute x]
										set y 		[$node getAttribute y] 
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
											set objectPoints [lappend objectPoints $x $y ]
										}
											# -- create polygon
											# puts "$canvas create polygon 	$objectPoints -outline black -fill white"
										$canvas create polygon 	$objectPoints -outline black -fill white
								}
							polyline { # polyline class="fil0 str0" points="44.9197,137.492 47.3404,135.703 48.7804,133.101 ...
										set valueList [ $node getAttribute points ]
										foreach {coords} $valueList {
											foreach {x y}  [split $coords ,] break
											set objectPoints [lappend objectPoints $x $y ]
										}
											# -- create polyline
											 puts "$canvas create line $objectPoints -fill black"
										$canvas create line $objectPoints -fill black
								}
							line { # line class="fil0 str0" x1="89.7519" y1="133.41" x2="86.9997" y2= "119.789"
										set objectPoints [list 	[expr [$node getAttribute x1] - $svgPosition(x)] [expr -([$node getAttribute y1] - $svgPosition(y))] \
																[expr [$node getAttribute x2] - $svgPosition(x)] [expr -([$node getAttribute y2] - $svgPosition(y))] ]
											# -- create line
											# puts "$canvas create line $objectPoints -fill black"
										$canvas create line $objectPoints -fill black
									}
							circle { # circle class="fil0 str2" cx="58.4116" cy="120.791" r="5.04665"
										# --- dont display the center_object with id="center_00"
										set cx [$node getAttribute cx]
										set cy [$node getAttribute cy]
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
		pack $canvasFrame  -expand yes -fill both
	set origFrame 	[ frame	$nb_result.nb_original.f    -relief sunken ]
		pack $origFrame    -expand yes -fill both
	set treeFrame 	[ frame	$nb_result.nb_tree.f    	-relief sunken ]
		pack $treeFrame    -expand yes -fill both
	set textFrame 	[ frame	$nb_result.nb_text.f    	-relief sunken ]
		pack $textFrame    -expand yes -fill both

		
		# --- result canvas ---
		#
	set resultCanvas [ canvas $canvasFrame.cv -width 900 -height 800 -relief sunken]
		pack   $resultCanvas -fill both -expand yes -padx 5 -pady 5
 
 
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

	set flatSVG [simplifySVG $root]


	drawSVG $flatSVG $resultCanvas
	recurseInsert $originalTree	$root 		{}
	recurseInsert $resultTree 	$flatSVG 	{}
	$resultText insert end [$flatSVG asXML]
