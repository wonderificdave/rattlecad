
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
 #	2010.11.04	exportSVG:  based on http://wiki.tcl.tk/4534

 
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
							path { # the complex all inclusive object in svg
									set valueList  [ $node getAttribute d ]
									set partialPath	[split [string trim $valueList] "zZ"]
										# [string map {Z {_Z}} {z {_z}} $valueList]
									foreach path $partialPath {		
										set objectPoints [ path2Line $valueList [list $svgPosition(x) $svgPosition(y)] ]										
											# puts "\n path-valueList:  $objectPoints"											
										if {$angle != 0} { 
											set objectPoints [vectormath::rotatePointList {0 0} $objectPoints $angle] 
										}
										set pos_objectPoints {}
										foreach {x y} $objectPoints {
											set pos_objectPoints [lappend pos_objectPoints [expr $x + $pos_x]]
											set pos_objectPoints [lappend pos_objectPoints [expr $y + $pos_y]]
										}									
										$w addtag $svgListName withtag [create line 		$canvasDOMNode $pos_objectPoints -fill black  -tags $tagList]
									}
									set nodeName {}
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
	

	#-------------------------------------------------------------------------
		#  export Stage-Content to a SVG File
		#
	proc canvasCAD::exportSVG {canvasDOMNode svgFile} {
		
			set cv			[ canvasCAD::getNodeAttribute  $canvasDOMNode	Canvas 	path ]
			set wScale		[ getNodeAttribute	$canvasDOMNode	Canvas 	scale ]			
			set stageScale 	[ getNodeAttribute	$canvasDOMNode	Stage	scale ]			
			set stageUnit 	[ getNodeAttribute	$canvasDOMNode	Stage	unit  ]			
			set font 		[ getNodeAttribute	$canvasDOMNode	Style  	font  ]
			set unitScale	[ get_unitRefScale 	$stageUnit    ]
			
			set stageFormat	[ getNodeAttribute	$canvasDOMNode	Stage	format ]	 
			set stageWidth	[ getNodeAttribute	$canvasDOMNode	Stage	width  ]	 
			set stageHeight	[ getNodeAttribute	$canvasDOMNode	Stage	height ]	 
			
			set scalePixel	[ getNodeAttributeRoot /root/_package_/UnitScale p ]
			set scaleInch	[ getNodeAttributeRoot /root/_package_/UnitScale i ]
			set scaleMetric	[ getNodeAttributeRoot /root/_package_/UnitScale m ]
			

					# -------------------------
					#	get SVG-Units and scale 
			case $stageUnit {
						m	{ 	set svgUnit	"mm"; }
						c	{ 	set svgUnit	"cm"}
						i	{ 	set svgUnit	"in"}
						p	{ 	set svgUnit	"px"}
			}

					# -------------------------
					#	get canvs scaling and reposition
			set cv_ViewBox		[ $cv coords __Stage__ ]
			set cv_View_x0		[ lindex $cv_ViewBox 0 ]
			set cv_View_y0		[ lindex $cv_ViewBox 1 ]
			set cv_ViewWidth	[ expr [ lindex $cv_ViewBox 2 ] - $cv_View_x0 ]
			set cv_ViewHeight	[ expr [ lindex $cv_ViewBox 0 ] - $cv_View_y0 ]
			
			set svgScale	[ expr  $unitScale * $wScale ]
					
					# -------------------------
					#	debug info
			puts "        --------------------------------------------"
			puts "           \$stageFormat $stageFormat  "
			puts "                   \$stageUnit      $stageUnit"
			puts "                   \$svgUnit        $svgUnit  "
			puts "                   \$unitScale      [ format "%.5f"  $unitScale ]"
			puts "                   \$stageWidth     $stageWidth  "
			puts "                   \$stageHeight    $stageHeight "
			puts "        --------------------------------------------"
			puts "               \$wScale         [ format "%.5f  %.5f"  $wScale        [ expr 1.0/$wScale] ]"
			puts "               \$stageScale     [ format "%.5f  %.5f"  $stageScale    [ expr 1.0/$stageScale] ]"
			puts "        --------------------------------------------"
			puts "               \$cv_ViewBox      $cv_ViewBox"
			puts "                   \$cv_View_x0      $cv_View_x0"
			puts "                   \$cv_View_y0      $cv_View_y0"
			puts "                   \$cv_ViewWidth    $cv_ViewWidth"
			puts "                   \$cv_ViewHeight   $cv_ViewHeight"
			puts "        --------------------------------------------"
			puts "               \$svgScale       ( $unitScale * $wScale )"
			puts "               \$svgScale       [ format "%.5f "  $svgScale ]"
			puts "        --------------------------------------------"
			
					
					# -------------------------
					#	create bounding boxes
			$cv create rectangle   [$cv coords __Stage__]   \
								  -tags    {__SheetFormat__ __Content__}  \
								  -outline black    \
								  -width   0.01
					
					# -------------------------
					#	get svgViewBox
			set svgViewBox		[ list  $cv_View_x0 $cv_View_y0 [expr $svgScale * $stageWidth]  [expr $svgScale * $stageHeight] ]
					
					
					# -------------------------
					#	create bounding boxes
			set 	svgContent	"<svg xmlns=\"http://www.w3.org/2000/svg\" \n"
			append 	svgContent	"         width=\"$stageWidth$svgUnit\" \n"
			append 	svgContent	"         height=\"$stageHeight$svgUnit\"\n"
			append 	svgContent	"         viewBox=\"$svgViewBox\"\n"
			append 	svgContent	"     >\n"
			
			append	svgContent	"<g  id=\"__root__\">\n\n"

						
			# ========================================================================
					# -------------------------
					#	for each item
					#
					#					
			foreach cvItem 	[$cv find withtag {__Content__}] {
			
					set cv_Type 		[$cv type $cvItem]
					set svgCoords	{}
					set svgAtts 	{}
					
					
						# --- get attributes
					catch {set lineColour 	[format_xColor [$cv itemcget $cvItem -outline]]}	{set lineColour 	gray50}
					catch {set lineWidth	[$cv itemcget $cvItem -width]}						{set lineWidth 		0.1}
					catch {set lineDash 	[$cv itemcget $cvItem -dash]}						{set lineDash 		{}}
					catch {set itemFill 	[format_xColor [$cv itemcget $cvItem -fill]]}		{set itemFill 		gray50}
					
						# --- preformat attribues
					set lineDash	[string map {{ } {,}} $lineDash]
					
						# --- get coords
					foreach {x0 y0 x1 y1} \
						[string map {".0 " " "} "[$cv coords $cvItem] "] break
						
						# --- get coords
					set cvPoints {}
					foreach {x y} [$cv coords $cvItem] {
						lappend cvPoints [list $x $y]
					}
				

					# -------------------------
					#	handle types			
					switch -exact $cv_Type {
							arc {
									set svgType path
										set cx 		[expr {($x0+$x1)/2}]
										set cy 		[expr {($y0+$y1)/2}]
										set rx 		[expr {($x1-$x0)/2}]
										set ry 		[expr {($y1-$y0)/2}]
									append svgAtts 	[format_itemAttribute cx $cx]
									append svgAtts 	[format_itemAttribute cy $cy]
									append svgAtts 	[format_itemAttribute rx $rx]
									append svgAtts 	[format_itemAttribute ry $ry]
									append svgAtts 	[format_itemAttribute fill $itemFill "#000000"]
									append svgAtts 	[format_itemAttribute stroke $lineColour none]
									append svgAtts 	[format_itemAttribute stroke-width $lineWidth 0.1]
										set start	[$cv itemcget $cvItem -start]
										set extent	[$cv itemcget $cvItem -extent]
										set p_start	[vectormath::rotateLine [list $cx $cy] $rx -1.0*$start]  
										set p_end	[vectormath::rotateLine [list $cx $cy] $rx [expr -1.0*($start + $extent)]]  
                                    if {[$cv itemcget $cvItem -style] == {pieslice}} {
                                        # pieslice segment of a circle results in a closed figure through the center point
                                        set d		"M [lindex $p_start 0],[lindex $p_start 1]  A [expr {($x1-$x0)/2}],[expr {($y1-$y0)/2}] 0 0 0 [lindex $p_end 0] [lindex $p_end 1] L $cx,$cy z"                                    
                                        puts "  -> arcStyle:  pieslice"
                                    } else {
                                        set d		"M [lindex $p_start 0],[lindex $p_start 1]  A [expr {($x1-$x0)/2}],[expr {($y1-$y0)/2}] 0 0 0 [lindex $p_end 0] [lindex $p_end 1]"                                    
                                    }
                                    append svgAtts		[format_itemAttribute d $d]								
											# Bogen l‰uft gegen den Uhrzeigersinn
											# rx, ry
											# x-axis-rotation   drehung der Ellipse
											# large-arc-flag	den groﬂen(1) Bogen
											# sweep-flag
											# x, y						
											#    * the arc starts at the current point
											#    * the arc ends at point (x, y)
											#    * the ellipse has the two radii (rx, ry)
											#    * the x-axis of the ellipse is rotated by x-axis-rotation relative to the x-axis of the current coordinate system	
							}            
							line -
							polyline {
									set    svgType 		polyline
									append svgCoords	[format_itemAttribute points [join $cvPoints ", "]]
									append svgAtts 		[format_itemAttribute fill   "none"    "none"]
									append svgAtts 		[format_itemAttribute stroke $itemFill "#000000"]
									append svgAtts 		[format_itemAttribute stroke-width $lineWidth 0.1]
									append svgAtts 		[format_itemAttribute stroke-dasharray $lineDash {15,1,1,1}]
							}
							polygon {
									set    svgType 		polygon
									append svgCoords 	[format_itemAttribute points [join $cvPoints ", "]]
									append svgAtts 		[format_itemAttribute fill $itemFill "#000000"]
									append svgAtts 		[format_itemAttribute stroke $lineColour "none"]
									append svgAtts 		[format_itemAttribute stroke-width $lineWidth 0.1]
							}
							oval {
									set    svgType 		ellipse
									append svgAtts 		[format_itemAttribute cx [expr {($x0+$x1)/2}]]
									append svgAtts 		[format_itemAttribute cy [expr {($y0+$y1)/2}]]
									append svgAtts 		[format_itemAttribute rx [expr {($x1-$x0)/2}]]
									append svgAtts 		[format_itemAttribute ry [expr {($y1-$y0)/2}]]
									append svgAtts 		[format_itemAttribute fill $itemFill "#000000"]
									append svgAtts 		[format_itemAttribute stroke $lineColour none]
									append svgAtts 		[format_itemAttribute stroke-width $lineWidth 0.1]
							}
							rectangle {
									set    svgType 		rect
									append svgAtts 		[format_itemAttribute x $x0]
									append svgAtts 		[format_itemAttribute y $y0]
									append svgAtts 		[format_itemAttribute width  [expr {$x1-$x0}]]
									append svgAtts 		[format_itemAttribute height [expr {$y1-$y0}]]
									append svgAtts 		[format_itemAttribute fill $itemFill "#000000"]
									append svgAtts 		[format_itemAttribute stroke $lineColour none]
									append svgAtts 		[format_itemAttribute stroke-width $lineWidth 0.1]
							}
							text {
									set    svgType 		text
									append svgAtts 		[format_itemAttribute x $x0]
									append svgAtts 		[format_itemAttribute y $y0]
									append svgAtts 		[format_itemAttribute fill $itemFill "#000000"]
									set text [$c itemcget $item -text]
							}
							default {
									# error "type $type not(yet) dumpable to SVG"
									puts "type $cv_Type not(yet) dumpable to SVG"
							}
					}
					
						# -------------------------
						#	canvas item attributes
					append svgContent     		"    <!-- $cv_Type:-->\n"
					append svgContent     		"        <!--    cvPoints:    $cvPoints   -->\n"
					append svgContent     		"        <!--    svgCoords:   $svgCoords   -->\n"
							# foreach attribute [$cv itemconfigure $cvItem] ;#{
							# 		append svgContent 	"        <!--    $attribute   -->\n"
							# }
					
						# -------------------------
						#	SVG item, depending on cv_Type
						# 		$style
					append svgContent "  <$svgType \n      $svgAtts\n      $svgCoords"				
					if {$cv_Type=="text"} {
						append svgContent ">$text</$svgType>\n"
					} else {
						append svgContent " />\n"
					}
			}
			
				# -- close svg-Tag
				#
			append svgContent "</g>\n"
			append svgContent "</svg>"
		

				# -- cleanup canvas
				#
			$cv delete -tags {__SheetFormat__}  

				#
				# -- fill export svgFile
				#
			set 		fp [open $svgFile w]					
			fconfigure  $fp -encoding utf-8
			puts 		$fp $svgContent
			close       $fp
			
				#
				# -- fill export svgFile
				#
			if {[file exists $svgFile]} {
				return $svgFile
			} else {
				return {_noFile_}
			}
			
	}			

	#-----------------------------------------
		#	helper procedures ....
		#
		#
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

	proc format_itemAttribute {name value {default {}}} {
			if {$value != $default} {return " $name=\"$value\""}
			return " $name=\"$default\""

	}

	proc format_styleAttribute {style name value {default -}} {
			# variable canvasCAD::styleAttribute
			set style [string range $style 0 end-1]
			if {$value != $default} {return "$style;$name:$value\""}
	}

	proc format_xColor {rgb} {
			if {$rgb == ""} {return none}
			foreach {r g b} [winfo rgb . $rgb] break
			return [format "#%02x%02x%02x" [expr {$r/256}] [expr {$g/256}] [expr {$b/256}] ]
	}
	
 	
	
	
	
				
