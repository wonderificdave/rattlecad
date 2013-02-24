
 ##+##########################################################################
 #
 # package: canvasCAD 	->	canvasCAD_svg.tcl
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
 #	namespace:  canvasCAD
 # ---------------------------------------------------------------------------
 #
 #

 
	#-------------------------------------------------------------------------
		#  read SVG from File
		#
	proc canvasCAD::readSVG {canvasDOMNode file {position {0 0}} {angle {0}} {tagList {}} } {
		
			set fp [open $file]
					
			fconfigure    $fp -encoding utf-8
			set xml [read $fp]
			close         $fp
			
			set doc  [dom parse  $xml]
			set root [$doc documentElement]

				#
				# -- get graphic content nodes
				#
			if {[$root getElementsByTagNameNS [$root namespaceURI]  g ] == {}} {
					set nodeList 	  [$root getElementsByTagNameNS [$root namespaceURI]  * ] 
			} else {
					set geometryNode  [$root 	getElementsByTagNameNS [$root namespaceURI]  g]
					set nodeList 	  [$geometryNode childNodes]
			}
				#
				# -- position
				#
			foreach {pos_x pos_y} $position break
				#
				# -- get center SVG
				#
			set center_Node [$root find id center_00]
			if { $center_Node != {} } {
					set svgPosition(x)	[$center_Node getAttribute cx]
					set svgPosition(y)	[$center_Node getAttribute cy]
			} else {
					puts "     ... no id=\"center_00\""
					set svgPosition(x)	0
					set svgPosition(y)	0
			}
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
			foreach node $nodeList {
					
						# -- handle exceptions
					if {[$node nodeType] != {ELEMENT_NODE}} continue
					if {[$node hasAttribute id]} {
							if {[$node getAttribute id] == {center_00}} continue
					}
				
						# -- set defaults
					set objectPoints {}

						# -- get transform attribute
					set transform {_no_transformation_}
					catch {set transform    [ $node getAttribute transform ] }
					
					case [$node nodeName] {
							rect {
									set x [expr  [$node getAttribute x] - $svgPosition(x) ]
									set y [expr -[$node getAttribute y] + $svgPosition(y) ]
									set width   [$node getAttribute  width ]
									set height  [$node getAttribute  height]
									set x2 [expr $x + $width ]
									set y2 [expr $y - $height]
									set objectPoints [list $x $y $x $y2 $x2 $y2 $x2 $y]
									if {$angle != 0} { 
										set objectPoints [vectormath::rotatePointList {0 0} $objectPoints $angle] 
									}
								}
							polygon {
										set valueList [ $node getAttribute points ]
										foreach {coords} $valueList {
											foreach {x y}  [split $coords ,] break
											set objectPoints [lappend objectPoints $x $y ]
										}
										if {$transform != {_no_transformation_}} {
												set matrix [split [string map {matrix( {} ) {}} $transform] ,]
												set objectPoints [ transform_SVGObject $objectPoints $matrix ]
													# puts "      polygon  -> SVGObject $objectPoints " 
													# puts "      polygon  -> matrix    $matrix" 
										}
										
										set tmpList {}
										foreach {x y} $objectPoints {
											set tmpList [lappend tmpList [expr  $x - $svgPosition(x) ] [expr -$y + $svgPosition(y) ]]	
										}
										set objectPoints $tmpList
										
										if {$angle != 0} { 
											set objectPoints [vectormath::rotatePointList {0 0} $objectPoints $angle] 
										}
								}
							polyline { # polyline class="fil0 str0" points="44.9197,137.492 47.3404,135.703 48.7804,133.101 ...
										set valueList [ $node getAttribute points ]
										foreach {coords} $valueList {
											foreach {x y}  [split $coords ,] break
											set objectPoints [lappend objectPoints $x $y ]
										}
										if {$transform != {_no_transformation_}} {
												set matrix [split [string map {matrix( {} ) {}} $transform] ,]
												set objectPoints [ transform_SVGObject $objectPoints $matrix ]
													# puts "      polygon  -> SVGObject $objectPoints " 
													# puts "      polygon  -> matrix    $matrix" 
										}
										
										set tmpList {}
										foreach {x y} $objectPoints {
											set tmpList [lappend tmpList [expr  $x - $svgPosition(x) ] [expr -$y + $svgPosition(y) ]]	
										}
										set objectPoints $tmpList
										
										if {$angle != 0} { 
											set objectPoints [vectormath::rotatePointList {0 0} $objectPoints $angle] 
										}
								}
							line { # line class="fil0 str0" x1="89.7519" y1="133.41" x2="86.9997" y2= "119.789"
									set objectPoints [list 	[expr [$node getAttribute x1] - $svgPosition(x)] [expr -([$node getAttribute y1] - $svgPosition(y))] \
															[expr [$node getAttribute x2] - $svgPosition(x)] [expr -([$node getAttribute y2] - $svgPosition(y))] ]
									if {$angle != 0} { 
										set objectPoints [vectormath::rotatePointList {0 0} $objectPoints $angle] 
									}
								}
							circle { # circle class="fil0 str2" cx="58.4116" cy="120.791" r="5.04665"
										# --- dont display the center_object with id="center_00"
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
									set objectPoints [list $x1 $y1 $x2 $y2]
								}
							default { }
					}
					
						#
						# -- move the content to its position
						#
					set pos_objectPoints {}
					foreach {x y} $objectPoints {
						set pos_objectPoints [lappend pos_objectPoints [expr $x + $pos_x]]
						set pos_objectPoints [lappend pos_objectPoints [expr $y + $pos_y]]
					}
					
						#
						# -- create object
						#
					case [$node nodeName] {
								rect 		{ $w addtag $svgListName withtag [create polygon 	$canvasDOMNode $pos_objectPoints -outline black -fill white  -tags $tagList]}
								polygon 	{ $w addtag $svgListName withtag [create polygon 	$canvasDOMNode $pos_objectPoints -outline black -fill white  -tags $tagList]}
								polyline 	{ $w addtag $svgListName withtag [create line 		$canvasDOMNode $pos_objectPoints -fill black  -tags $tagList]}
								line 		{ $w addtag $svgListName withtag [create line 		$canvasDOMNode $pos_objectPoints -fill black  -tags $tagList]}
								circle 		{ $w addtag $svgListName withtag [create oval 		$canvasDOMNode $pos_objectPoints -outline black -fill white -tags $tagList]}
								default 	{}
					}
			}

			
				#
				# -- add each to unique $svgListName
				#		
			return $svgListName

	}	
	

	proc transform_SVGObject {valueList matrix} {
	
			set valueList_Return {}
					# puts "    transform_SVGObject: $matrix"
			foreach {a b c d tx ty} $matrix break
					# puts "          $a $b $tx  /  $c $d $ty " 
			foreach {x y} $valueList {
					# puts "       -> $x $y"
				set xt [ expr $a*$x - $b*$y + $tx ]
				set yt [ expr $c*$x - $d*$y - $ty ]
				set valueList_Return [lappend valueList_Return $xt [expr -1*$yt] ]
					# puts "             function   x:  $a*$x - $b*$y + $tx    $xt"
					# puts "             function   y:  $c*$x - $d*$y - $ty    $yt"
			}
			return $valueList_Return
	}


