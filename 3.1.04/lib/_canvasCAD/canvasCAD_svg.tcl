# ============================================
#
#	canvasCAD_utility
#
# ============================================
 
	#-------------------------------------------------------------------------
		#  read SVG from File
		#
	proc canvasCAD::readSVG {canvasDOMNode file {position {0 0}} {angle {0}} } {
		
			set fp [open $file]
					
			fconfigure    $fp -encoding utf-8
			set xml [read $fp]
			close         $fp
			
			set doc  [dom parse  $xml]
			set root [$doc documentElement]

				#
				# -- get graphic
				#
			set geometryNode  [$root 	getElementsByTagNameNS [$root namespaceURI]  g]
					# puts "\n----------\n[$geometryNode asXML]"				
				#
				# -- position
				#
			foreach {pos_x pos_y} $position break	
				#
				# -- get center SVG
				#
			set center_Node [$root find id center_00 $geometryNode]
			set svgPosition(x)	[$center_Node getAttribute cx]
			set svgPosition(y)	[$center_Node getAttribute cy]
			set svgPosition(xy)	[list $svgPosition(x) $svgPosition(y)]
				#
				# -- define item container
				#
			set w		 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Canvas 	path ]
			set svgListName [format "svg_%s" [llength [$w find withtag all]] ]
			set $svgListName {}
				#
				# -- parse children
				#
			foreach node [$geometryNode childNodes] {
					set objectValues {}
					
					case [$node nodeName] {
							rect {
									set x [expr  [$node getAttribute x] - $svgPosition(x) + $pos_x]
									set y [expr -[$node getAttribute y] + $svgPosition(y) + $pos_y]
									set width   [$node getAttribute  width ]
									set height  [$node getAttribute  height]
									set x2 [expr $x + $width ]
									set y2 [expr $y - $height]
									set objectValues [list $x $y $x $y2 $x2 $y2 $x2 $y]
									if {$angle != 0} { 
										set objectValues [vectormath::rotatePointList {0 0} $objectValues $angle] 
									}
								}
							polygon {
									set valueList [ $node getAttribute points ]
									foreach {coords} $valueList {
										foreach {x y}  [split $coords ,] break
										set objectValues [lappend objectValues [expr  $x - $svgPosition(x) ]]
										set objectValues [lappend objectValues [expr -$y + $svgPosition(y) ]]	
									}	
									if {$angle != 0} { 
										set objectValues [vectormath::rotatePointList {0 0} $objectValues $angle] 
									}
								}
							polyline { # polyline class="fil0 str0" points="44.9197,137.492 47.3404,135.703 48.7804,133.101 ...
									set valueList [ $node getAttribute points ]
									foreach {coords} $valueList {
										foreach {x y}  [split $coords ,] break
										set objectValues [lappend objectValues [expr  $x - $svgPosition(x) ]]
										set objectValues [lappend objectValues [expr -$y + $svgPosition(y) ]]	
									}	
									if {$angle != 0} { 
										set objectValues [vectormath::rotatePointList {0 0} $objectValues $angle] 
									}
								}
							line { # line class="fil0 str0" x1="89.7519" y1="133.41" x2="86.9997" y2= "119.789"
									set objectValues [list 	[expr [$node getAttribute x1] - $svgPosition(x)] [expr -([$node getAttribute y1] - $svgPosition(y))] \
															[expr [$node getAttribute x2] - $svgPosition(x)] [expr -([$node getAttribute y2] - $svgPosition(y))] ]
									if {$angle != 0} { 
										set objectValues [vectormath::rotatePointList {0 0} $objectValues $angle] 
									}
								}
							circle { # circle class="fil0 str2" cx="58.4116" cy="120.791" r="5.04665"
										# --- dont display the center_object with id="center_00"
									if { [$node hasAttribute id]} {
											if {[$node getAttribute id] == {center_00}} continue
									}
									if {![$node hasAttribute cx]} continue
									set cx [expr   [$node getAttribute cx] - $svgPosition(x) ]
									set cy [expr -([$node getAttribute cy] - $svgPosition(y))]
									if {$angle != 0} { 
										set c_xy [vectormath::rotatePointList {0 0} [list $cx $cy] $angle] 
										foreach {cx cy} $c_xy break
									}
									set r  [$node getAttribute  r]
									set x1 [expr $cx - $r]
									set y1 [expr $cy - $r]
									set x2 [expr $cx + $r]
									set y2 [expr $cy + $r]
									set objectValues [list $x1 $y1 $x2 $y2]
								}
							default {}
					}
						#
						# -- rotate content if required
						#
					if {$angle != 0} { 
						# set objectValues [vectormath::rotatePointList {0 0} $objectValues $angle] 
					}
					
						#
						# -- move the content to its position
						#
					set pos_objectValues {}
					foreach {x y} $objectValues {
						set pos_objectValues [lappend pos_objectValues [expr $x + $pos_x]]
						set pos_objectValues [lappend pos_objectValues [expr $y + $pos_y]]
					}
					
						#
						# -- create object
						#
					case [$node nodeName] {
								rect 		{ $w addtag $svgListName withtag [create polygon 	$canvasDOMNode $pos_objectValues -outline black -fill white]}
								polygon 	{ $w addtag $svgListName withtag [create polygon 	$canvasDOMNode $pos_objectValues -outline black -fill white]}
								polyline 	{ $w addtag $svgListName withtag [create line 		$canvasDOMNode $pos_objectValues -fill black]}
								line 		{ $w addtag $svgListName withtag [create line 		$canvasDOMNode $pos_objectValues -fill black]}
								circle 		{ $w addtag $svgListName withtag [create oval 		$canvasDOMNode $pos_objectValues -outline black -fill white]}
								default 	{}
					}
			}

			
				#
				# -- add each to unique $svgListName
				#		
			return $svgListName

	}	

