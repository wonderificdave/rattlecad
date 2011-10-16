
 ##+##########################################################################
 #
 # canvasCAD.tcl
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
 #                    rotate_item:
 #                            kvetter@DELETETHIS.alltel.net
 #                            http://wiki.tcl.tk/8595
 #                    zoom:
 #                            masse-navette.glfs@wanadoo.fr
 #                            http://wiki.tcl.tk/4844
 #                    vector algorythms:
 #                            kvetter@DELETETHIS.alltel.net
 #                            http://wiki.tcl.tk/8447
 # ---------------------------------------------------------------------------							
 #								
 #															


package provide canvasCAD 0.9
package require tdom

  # -----------------------------------------------------------------------------------
  #
  #: Functions : namespace      c a n v a s C A D
  #
  
	namespace eval canvasCAD {

			# --------------------------------------------
					# Export as global command
			namespace  export newCanvas 

			# --------------------------------------------
					# Export as global command
			variable packageHomeDir [file normalize [file join [pwd] [file dirname [info script]]] ]
				set fp [open [file join $packageHomeDir canvasCAD.xml] ]
				fconfigure    $fp -encoding utf-8
			set __packageXML [read $fp]
				close         $fp
			
			set __packageDoc  [dom parse $__packageXML]
			set __packageRoot [$__packageDoc documentElement]



		
			# -------------------------------------------- 
				# initial exported creation procedure
				#   cv_width cv_height st_width st_height
		proc newCanvas {name w title cv_width cv_height stageFormat stageScale stageBorder args} {
					# stageFormat:
					#     A0, A1, A2, ...   
					#     passive
				variable __packageRoot

					# puts "        ... $name"
					# puts "        ... $w"
					# puts "        ... $title"
				
			# ------- qualify the name ----------------------------------- 
				if {![string match "::*" $name]} {
					# append :: if not global namespace.
					set ns [uplevel 1 namespace current]
					if {"::" != $ns} {
						append ns "::"
					}					
					set name "$ns$name"
				}

			# ------- Check the name ------------------------------------- 
				if {"" != [info command $name]} {
					return -code error  "command name \"$name\" already exists"
				}

			# ------- Save data to  __packageRoot   --------------------
				set node [$__packageRoot selectNodes /root]
					# -- new instance node
				$node appendXML "<instance id='$name'/>"
				set searchString [format "/root/instance\[@id='%s']" $name]
				set node [$__packageRoot selectNodes $searchString ]
				
					# -- copy children from template
				set templateObject [$__packageRoot selectNodes /root/_package_/Object_Template]
				foreach childNode [$templateObject childNodes] {
					$node appendChild [$childNode cloneNode -deep]
				}				

					# -- get stage width/height
				switch -glob $stageFormat {
					passive	{set DINFormat A4}
					default	{set DINFormat $stageFormat}
				}
				foreach {st_width st_height st_unit } 	[canvasCAD::getFormatSize $DINFormat] break
						puts "   -> $st_width $st_height $st_unit"
									
					# -- insert base values
				set canvasDOMNode	[getNodeRoot [format "/root/instance\[@id='%s'\]" $name] ]
				setNodeAttribute  $canvasDOMNode  Stage  title	$title
				setNodeAttribute  $canvasDOMNode  Stage  width	$st_width
				setNodeAttribute  $canvasDOMNode  Stage  height	$st_height
				setNodeAttribute  $canvasDOMNode  Stage  unit	$st_unit 
				setNodeAttribute  $canvasDOMNode  Stage  scale	$stageScale 					
				setNodeAttribute  $canvasDOMNode  Stage  format	$stageFormat 					
			
			# ------- Create the object ----------------------------------
				proc $name {method args} [format { canvasCAD::ObjectMethods %s $method $args } $name]
				proc _name {method args} [format {
					if {[catch {canvasCAD::ObjectMethods %s $method $args}  result]} {
						#set errMsg "$method:  $result"
						#return -code error $errMsg
						#set errMsg "$method:  $result"
						return -code error $result
					} else {
						return $result
					}
				} $name]
				
			# ------- Create the canvas ----------------------------------
			    set   cv   [ eval canvas $w [flatten_nestedList $args]  -width $cv_width -height $cv_height  -bg gray] 
				pack  $cv   -expand yes  -fill both  		

					# -- exception for canvas that are not DIN Formats
				if {$stageFormat == {passive}} {
					setNodeAttribute  $canvasDOMNode  Stage  width  [$cv cget -width]
					setNodeAttribute  $canvasDOMNode  Stage  height	[$cv cget -height]
				}



					# -- register canvas path
				setNodeAttribute  $canvasDOMNode  Canvas  path		$cv			
				setNodeAttribute  $canvasDOMNode  Canvas  iborder	$stageBorder			


				update	
				
				switch -glob $stageFormat {
					passive	{ 	__create_Stage  $canvasDOMNode	passive 
								# update
							}					
					default	{
								__create_Stage  $canvasDOMNode	sheet					
								# update
								bind $cv <Motion> 		[ list canvasCAD::reportPointerPostion $name %x %y ]
								bind $cv <Configure> 	[ namespace code [list resizeCanvas $w] ]
									# Set up event bindings for move canvas:
								bind $cv <1>						"canvasCAD::setMark		$cv %x %y  move"
								bind $cv <B1-Motion>				"canvasCAD::setStroke	$cv %x %y"
								bind $cv <ButtonRelease-1>			"canvasCAD::moveContent	$cv %x %y  $name; $cv configure -cursor arrow"
								bind $cv <3>						"canvasCAD::setMark		$cv %x %y  zoom"
								bind $cv <B3-Motion>				"canvasCAD::setStroke	$cv %x %y"
								bind $cv <ButtonRelease-3>			"canvasCAD::zoomArea	$cv %x %y  $name; $cv configure -cursor arrow"
							}
				}
				
					# bind . <F5> 				"canvasCAD::refitToCanvas_F3   $cv"
					# bind $cv.scrolled 	<Configure> [namespace code [list resize $w]]
					# reportDictionary			
				
			# ------- return the namspaces name -------------------------- 
				return $name
		}
		


		# --------------------------------------------
			# 	operation handler
			# 	each operation has to be registered
		proc ObjectMethods {name method argList} {
				# puts " ObjectMethods  $name  $method  $argList"
			switch -exact -- $method {
					# ------------------------			
				create { 			set canvasDOMNode	[getNodeRoot [format "/root/instance\[@id='%s'\]" $name] ]
									set type 			[lindex $argList 0]
									set CoordList		[lindex $argList 1]
									set argList			[lrange $argList 2 end]
									return [ create 	$type $canvasDOMNode $CoordList $argList ]
									# return [ create 	$type $cv_Object $CoordList $argList ]
								}
					# ------------------------			
				dimension { 		set canvasDOMNode	[getNodeRoot [format "/root/instance\[@id='%s'\]" $name] ]
									set type 			[lindex $argList 0]
									set CoordList		[lindex $argList 1]
									set argList			[lrange $argList 2 end]
									return [ dimension 	$type $canvasDOMNode $CoordList $argList ]
								}
					# ------------------------			
				scaleToCenter {		set scale 			[lindex $argList 0]
									return [ scaleToCenter 	$name $scale ] 
								}
					# ------------------------			
				refitStage {		return [ refitStage 	$name ]
								}
				fit2Stage {			set tagList		[lindex $argList 0]
									return [ fit2Stage 		$name $tagList] 
								}
					# ------------------------			
				centerContent {		set offSet		[lindex $argList 0]
									set tagList		[lindex $argList 1]
									return [ centerContent 	$name $offSet $tagList] 
								}		
					# ------------------------			
				repositionToCanvasCenter { return [ repositionToCanvasCenter $name ] 
								}
					# ------------------------		
						__rotateItem { 		# has to be fixed with for relativ position
											set canvasDOMNode	[getNodeRoot [format "/root/instance\[@id='%s'\]" $name] ]
											set cv 				[getNodeAttribute $canvasDOMNode Canvas path]
											set objectTag 		[lindex $argList 0]
											set rotationPoint	[lindex $argList 1]
											set rotationAngle	[lindex $argList 2]
											puts "rotateItem $cv  $objectTag  [lindex $rotationPoint 0] [lindex $rotationPoint 1]  $rotationAngle" 
											puts "[$cv gettags $objectTag]"
											rotateItem $cv  $objectTag  [lindex $rotationPoint 0] [lindex $rotationPoint 1]  $rotationAngle
										}
					# ------------------------		
				setNodeAttr {		set canvasDOMNode	[getNodeRoot [format "/root/instance\[@id='%s'\]" $name] ]
									return [ setNodeAttribute $canvasDOMNode [lindex $argList 0] [lindex $argList 1] [lindex $argList 2] ]
								}
				getNodeAttr { 		set canvasDOMNode	[getNodeRoot [format "/root/instance\[@id='%s'\]" $name] ]
										# puts "[$canvasDOMNode asXML]"
									return [ getNodeAttribute $canvasDOMNode [lindex $argList 0] [lindex $argList 1] ]
								}
				getNode { 			set canvasDOMNode	[getNodeRoot [format "/root/instance\[@id='%s'\]" $name] ]
									return [ getNode $canvasDOMNode [lindex $argList 0] ]
								}
					# ------------------------		
				getFormatSize {		set formatKey 		[lindex $argList 0]
									return [getFormatSize $formatKey]									
								}
				formatCanvas {		set format 			[lindex $argList 0]
									set scale 			[lindex $argList 1]
									return [ formatCanvas 	$name $format $scale ] 
								}							
					# ------------------------		
				reportXML { 		eval "$method" $name $argList
								}
				reportXMLRoot { 	eval "$method" 
								}
					# ------------------------			
				readSVG {			set canvasDOMNode	[getNodeRoot [format "/root/instance\[@id='%s'\]" $name] ]
									switch [llength $argList] {
										2 {	return [ readSVG $canvasDOMNode [lindex $argList 0] [lindex $argList 1] ] }
										3 {	return [ readSVG $canvasDOMNode [lindex $argList 0] [lindex $argList 1] [lindex $argList 2] ] }
										4 { return [ readSVG $canvasDOMNode [lindex $argList 0] [lindex $argList 1] [lindex $argList 2] [lindex $argList 3] ] }
									}
								}
				exportSVG {			set canvasDOMNode	[getNodeRoot [format "/root/instance\[@id='%s'\]" $name] ]
									exportSVG $canvasDOMNode [lindex $argList 0]
								}
					# ------------------------			
				print {				set printFile 		[lindex $argList 0]
									printPostScript $name $printFile }
					# ------------------------			
				clean_StageContent {set canvasDOMNode	[getNodeRoot [format "/root/instance\[@id='%s'\]" $name] ]
									set cv 				[getNodeAttribute $canvasDOMNode Canvas path]
									clean_StageContent $cv }
					# ------------------------			
				default { 			set canvasDOMNode	[getNodeRoot [format "/root/instance\[@id='%s'\]" $name] ]
									set cv 				[getNodeAttribute $canvasDOMNode Canvas path]
									eval $cv $method $argList
									# return -code error  "\"$name $method\" is not defined" 
								}
			}
		}

			
		

		#-------------------------------------------------------------------------
			#  get canvasCAD Instances
			#
		proc get_cvList {{searchString {}}} {
			reportXML $__packageRoot
			puts "[reportXML $__packageRoot]"
		}
		
			#
		#-------------------------------------------------------------------------
			#  create SketchStage
			#
		proc __create_Stage { canvasDOMNode {type {sheet}}} {
					# stageFormat:
					#     sheet 	(A0. A1, A2, ... )
					#     passive		
						
				# -- get the Objects tdom attributes
				#	
			set w			[ getNodeAttribute  $canvasDOMNode  Canvas  path ]
			set Unit		[ getNodeAttribute	$canvasDOMNode  Stage   unit ]
			update 
			
				# -- cleanup the canvas
				#
			catch [$w delete  {__Stage__}       ]
			catch [$w delete  {__StageShadow__} ]
								
				# -- size in points
				#
			set w_width  [winfo width  $w]
			set w_height [winfo height $w]
			
				# -- get values from config variable
				#
			set x  		[ getNodeAttribute  $canvasDOMNode  	Stage	width  ]
			set y  		[ getNodeAttribute  $canvasDOMNode  	Stage	height ]
				
			
				# -- create reference squares in the canvas center
				#		100m
				#		4i
				# -- mm ----
			$w create rectangle   0  0  100m  100m  	-tags {__StageReference_mm__}  	-fill gray  -outline gray  -width 0			
					set coords	[ $w coords __StageReference_mm__ ] 
					set scale 	[ expr [lindex $coords 2]/100]
					setNodeAttributeRoot /root/_package_/UnitScale m $scale
				catch [ $w delete {__StageReference_mm__} ]
						# puts "       ->  mm : 0  0  10m  10m  / $coords / $scale"
				# -- cm ----
			$w create rectangle   0  0  10c  10c    	-tags {__StageReference_cm__} 	-fill gray  -outline gray  -width   0			
					set coords	[ $w coords __StageReference_cm__ ] 
					set scale 	[ expr [lindex $coords 2]/10]
					setNodeAttributeRoot /root/_package_/UnitScale c $scale
				catch [ $w delete {__StageReference_cm__} ] 
						# puts "       ->   c : 0  0  1c  1c  / $coords"
				# -- inch --
			$w create rectangle   0  0  1i  1i  	-tags {__StageReference_inch__}	-fill gray  -outline gray  -width   0			
					set coords	[ $w coords __StageReference_inch__ ] 
					set scale 	[ lindex $coords 2]
					setNodeAttributeRoot /root/_package_/UnitScale i $scale
				catch [ $w delete {__StageReference_inch__} ] 
						# puts "       ->   i : 0  0  1i  1i  / $coords"
				# -- p -----
			$w create rectangle   0  0  10p  10p  	-tags {__StageReference_p__}  	-fill gray  -outline gray  -width   0			
					set coords	[ $w coords __StageReference_p__ ] 
					set scale 	[ expr [lindex $coords 2]/10]
					setNodeAttributeRoot /root/_package_/UnitScale p $scale
				catch [ $w delete {__StageReference_p__} ] 
						# puts "       ->   p : 0  0  10p  10p  / $coords"
				# -- std -----
			$w create rectangle   0  0  10  10  	-tags {__StageReference_std__}  -fill gray  -outline gray  -width   0			
					set coords	[ $w coords __StageReference_std__ ] 
					set scale 	[ expr [lindex $coords 2]/10]
					setNodeAttributeRoot /root/_package_/UnitScale std $scale
				catch [ $w delete {__StageReference_std__} ] 
						# puts "       -> std : 0  0  10  10  / $coords"
						

			switch $type {
			
				sheet {
							# -- create Stage
							#		
						$w create rectangle   0  0  $x$Unit  $y$Unit    \
											  -tags    {__StageShadow__}  \
											  -fill    gray10   \
											  -outline gray10    \
											  -width   0
						$w create rectangle   0  0  $x$Unit  $y$Unit    \
											  -tags    {__Stage__}  \
											  -fill    white    \
											  -outline white    \
											  -width   0

							# -- compute Canvas Scale
							#		
						set cvBorder	[getNodeAttribute	$canvasDOMNode  Canvas iborder ]
						set stageCoords	[ $w coords  {__Stage__} ]
						foreach {x1 y1 x2 y2} $stageCoords break
						
						set stage_x		[ expr $x2 - $x1]
						set stage_y		[ expr $y2 - $y1]
						set w_width_st	[ expr $w_width  - 2*$cvBorder ]
						set w_height_st	[ expr $w_height - 2*$cvBorder ]
						set scale_x		[ format "%.4f" [ expr $w_width_st  / $stage_x ] ]
						set scale_y		[ format "%.4f" [ expr $w_height_st / $stage_y ] ]
						if { $scale_x < $scale_y } { 
								set cvScale $scale_x 
						} else {
								set cvScale $scale_y 
						}
						
							# -- debug
							#
						puts "         $w:  $scale_x  - $scale_y :  $cvScale"
						
							# -- set Scale Attribute
							#
						setNodeAttribute	$canvasDOMNode  Canvas scale $cvScale
							
							# -- scale stage
							#
						$w scale {__StageShadow__} 	0 0 $cvScale $cvScale
						$w scale {__Stage__} 		0 0 $cvScale $cvScale
						
							# -- move stage to center
							#
						set stageCoords	[ $w coords  {__Stage__} ]
						foreach {x1 y1 x2 y2} $stageCoords break
						set move_x [expr ($w_width  - $x2) / 2 ]
						set move_y [expr ($w_height - $y2) / 2 ]

						$w move  {__Stage__}       			$move_x  $move_y
						$w move  {__StageShadow__} 			$move_x  $move_y

						$w move  {__StageShadow__}  6 5
						$w raise {__StageShadow__}  all
						$w raise {__Stage__}        all

					}
					
				passive {
						$w create rectangle   0  0  $x$Unit  $y$Unit    \
											  -tags    {__Stage__}  \
											  -fill    white    \
											  -outline white    \
											  -width   0
											  
							# -- compute Canvas Scale
							#		
						set stageCoords	[ $w coords  {__Stage__} ]
						foreach {x1 y1 x2 y2} $stageCoords break
						
						set stage_x		[ expr $x2 - $x1]
						set stage_y		[ expr $y2 - $y1]
						set scale_x		[ format "%.4f" [ expr $w_width  / $stage_x ] ]
						set scale_y		[ format "%.4f" [ expr $w_height / $stage_y ] ]
						if { $scale_x < $scale_y } { 
								set cvScale $scale_x 
						} else {
								set cvScale $scale_y 
						}
						
							# -- debug
							#
						puts "         $w:  $scale_x  - $scale_y :  $cvScale"
						
							# -- set Scale Attribute
							#
						setNodeAttribute	$canvasDOMNode  Canvas scale $cvScale
							
							# -- scale stage
							#
						$w scale {__Stage__} 		0 0 $cvScale $cvScale
						
							# -- move stage to center
							#
						set stageCoords	[ $w coords  {__Stage__} ]
						foreach {x1 y1 x2 y2} $stageCoords break
						set move_x [expr ($w_width  - $x2) / 2 ]
						set move_y [expr ($w_height - $y2) / 2 ]

						$w move  {__Stage__}       			$move_x  $move_y
					}
					
				default {}
			}
				
												
		}
		
		
		#-------------------------------------------------------------------------
			#  create line, polygon, rectangle, oval, arc, circle
			#
		proc create {type canvasDOMNode CoordList args} {

			# reportXMLRoot

			# tk_messageBox -message "create:  \n    $w  $type \n    $cv_Config\n    $CoordList \n    $args "			
			set w			[ getNodeAttribute	$canvasDOMNode	Canvas 	path  ]			
			set wScale		[ getNodeAttribute	$canvasDOMNode	Canvas 	scale ]			
			set stageScale 	[ getNodeAttribute	$canvasDOMNode	Stage	scale ]			
			set stageUnit 	[ getNodeAttribute	$canvasDOMNode	Stage	unit  ]			
			set font 		[ getNodeAttribute	$canvasDOMNode	Style  	font  ]
			set unitScale	[ get_unitRefScale 	$stageUnit    ]

			set moveVector  [ get_BottomLeft $w ]
			
			set fontSize		5
			#puts "  create: $new_args"
										
			# ------ ceck $w ----------------
			if { $w == {} } {
				error "canvasCAD::create -> Error:  could not get \$w" 
			}
			
			# ------ search for: -tags ------
			
			# -------------------------------
			switch -exact -- $type {
				line -	
				centerline {set CoordList   [ eval convert_BottomLeft [expr $wScale*$stageScale] $CoordList] }	
				polygon	-
				rectangle -
				oval	{ 	set CoordList   [ eval convert_BottomLeft [expr $wScale*$stageScale] $CoordList] }		
				arc -
				circle	{	
							set new_args 	[ flatten_nestedList $args ]
							set args		{}
							for {set x 0} {$x<[llength $new_args]} {incr x} {
								if {[string equal [lindex $new_args $x] {-radius} ]} {
									# tk_messageBox -message "createCircle {-radius} found:  [lindex $new_args $x] [lindex $new_args $x+1]"
									set Radius [lindex $new_args $x+1]
									incr x
								} else {
									lappend args [lindex $new_args $x]
									# tk_messageBox -message "createCircle {-radius} not found:  [lindex $args $x]"
								}
								if {[string equal [lindex $new_args $x] {-tags} ]} {
									set tagList	[ flatten_nestedList [lindex $new_args $x+1] ]
									lappend args [list $tagList ]
									incr x
								}								
							}
								# tk_messageBox -message "createCircle Radius $Radius \n   $args"
							foreach {x y} $CoordList break
							set CoordList   [ list [expr $x-$Radius] [expr $y+$Radius] [expr $x+$Radius] [expr $y-$Radius] ]
							set CoordList   [ eval convert_BottomLeft [expr $wScale*$stageScale] $CoordList]
						}
				text 	{
							set new_args 	[ flatten_nestedList $args ]
							set args		{}
							for {set x 0} {$x<[llength $new_args]} {incr x} {
								switch [lindex $new_args $x] {
									{-size}		{	set fontSize [lindex $new_args $x+1] ; incr x }
									{-text}		{ 	set myText 	 [lindex $new_args $x+1] ; incr x }
									default 	{ 	set args [lappend args [lindex $new_args $x] ] }									
								}
							}
							set fontSize	[ expr round($fontSize * 10 * $stageScale / 2.8) ]
								# set fontSize	[ expr round($fontSize * 10 / 2.8) ]
							set CoordList   [ eval convert_BottomLeft [expr $wScale*$stageScale] $CoordList]
						}
				vectortext {	
							vectorfont::setalign    "sw"		;# standard text alignment
							vectorfont::setangle    0			;# standard orientation
							vectorfont::setcolor    black		;# standard colour
							vectorfont::setline     1			;# standard line width
							vectorfont::setscale    [expr  $stageScale / (8 * $unitScale) ]	 ;# standard font size
								
							set new_args 	[ flatten_nestedList $args ]
							set args		{}
							for {set x 0} {$x<[llength $new_args]} {incr x} {
								switch [lindex $new_args $x] {
									{-text}		{ 	set myText [lindex $new_args $x+1] ; incr x }
									{-anchor}	{   vectorfont::setalign  [lindex $new_args $x+1] ; incr x }
									{-angle}	{   vectorfont::setangle  [lindex $new_args $x+1] ; incr x }
									{-fill}		{   vectorfont::setcolor  [lindex $new_args $x+1] ; incr x }
									{-width}	{   vectorfont::setline   [lindex $new_args $x+1] ; incr x }
									{-size}		{   set fontSize  		  [lindex $new_args $x+1] ; incr x }
									default 	{ 	set args [lappend args [lindex $new_args $x] ] }									
								}								
							}
								# vectorfont: 8mm -> std :   8 * [get_unitRefScale m]
								#   mm  -> 
							vectorfont::setscale  [expr ($fontSize * $stageScale) / (8 * [get_unitRefScale m] ) ] 
								# vectorfont::setscale  [expr ($fontSize * $stageScale) / (8 * $unitScale) ] 
							set CoordList   [ eval convert_BottomLeft [expr $wScale*$stageScale] $CoordList]
									# vectorfont does not support canvas Units m, c, i, p 
						}
				draftText {	
							vectorfont::setalign    "sw"		;# standard text alignment
							vectorfont::setangle    0			;# standard orientation
							vectorfont::setcolor    black		;# standard colour
							vectorfont::setline     1			;# standard line width
							vectorfont::setscale    [expr  $stageScale / (8 * $unitScale) ]	 ;# standard font size
								
							set new_args 	[ flatten_nestedList $args ]
							set args		{}
							for {set x 0} {$x<[llength $new_args]} {incr x} {
								switch [lindex $new_args $x] {
									{-text}		{ 	set myText [lindex $new_args $x+1] ; incr x }
									{-anchor}	{   vectorfont::setalign  [lindex $new_args $x+1] ; incr x }
									{-angle}	{   vectorfont::setangle  [lindex $new_args $x+1] ; incr x }
									{-fill}		{   vectorfont::setcolor  [lindex $new_args $x+1] ; incr x }
									{-size}		{   set fontSize  		  [expr [lindex $new_args $x+1] * $wScale ]
													vectorfont::setline   [expr  $fontSize / (10 * $wScale * $stageScale * $unitScale)]
																									incr x }
									default 	{ 	set args [lappend args [lindex $new_args $x] ] }									
								}								
							}
								# vectorfont: 8mm -> std :   8 * [get_unitRefScale m]
								#   mm  -> 
							vectorfont::setscale  [expr $fontSize  / (8 * [get_unitRefScale m] ) ] 
								# vectorfont::setscale  [expr ($fontSize * $stageScale) / (8 * $unitScale) ] 
							set CoordList   [ eval convert_BottomLeft [expr $wScale*$stageScale] $CoordList]
									# vectorfont does not support canvas Units m, c, i, p 
						}
				draftLine {	
							set CoordList   [ eval convert_BottomLeft [expr $wScale*$stageScale] $CoordList]
							set new_args 	[ flatten_nestedList $args ]
							set args		{}
							for {set x 0} {$x<[llength $new_args]} {incr x} {
								switch [lindex $new_args $x] {
									{-width}	{   set lineWidth	[expr [lindex $new_args $x+1] / ($wScale * $stageScale * $unitScale) ]
													set args [lappend args {-width} $lineWidth]   ; incr x }
									default 	{ 	set args [lappend args [lindex $new_args $x] ] }									
								}								
							}
						}

				default {}
			}
			
			switch  -exact -- $type {
				centerline	{ set myItem 	[ centerLine $canvasDOMNode $CoordList  [flatten_nestedList $args] ] }
				draftLine	-
				line		{ set myItem	[ eval $w create line  		$CoordList  [flatten_nestedList $args] ] }
				oval -
				circle 		{ set myItem	[ eval $w create oval  		$CoordList  [flatten_nestedList $args] ] }
				arc			{ set myItem	[ eval $w create arc		$CoordList  [flatten_nestedList $args] ] }
				rectangle	{ set myItem 	[ eval $w create rectangle  $CoordList  [flatten_nestedList $args] ] }
				polygon		{ set myItem 	[ eval $w create polygon  	$CoordList  [flatten_nestedList $args] ] }
				text		{ 	
								set font 	[ format "%s %s"   $font  	$fontSize ]
								set myItem 	[ eval $w create text  		$CoordList 	-anchor se \
																					-text 	\"$myText\"  \
																					-font 	\"$font\"  \
																					[flatten_nestedList $args] ] 
							}			
				draftText -
				vectortext	{ 
								set UnitScale [ get_unitRefScale $stageUnit ]
								set pos_x [expr [lindex $CoordList 0]]
								set pos_y [expr [lindex $CoordList 1]]								
								vectorfont::setposition  $pos_x $pos_y
							  set myItem 	[vectorfont::drawtext $w $myText]
							}
				button {
							button $w.button -text "Click button 3 to drag"
							$w create window 50 35 \
							-window .c.button -anchor w -tags {$w.button}
							}

				default		{}
			}

			$w scale $myItem  0 0  $unitScale $unitScale
			$w move  $myItem [ lindex $moveVector 0 ] [ lindex $moveVector 1 ]	
			$w addtag {__Content__} withtag $myItem
			return $myItem
		}
		
		
		#-------------------------------------------------------------------------
			#  create Dimension   length, angle
			#
		proc dimension {type canvasDOMNode CoordList args} {
				#tk_messageBox -message "canvasCAD::dimension $CoordList $args"
			set w			[ getNodeAttribute	$canvasDOMNode	Canvas path	]			
			set wScale		[ getNodeAttribute	$canvasDOMNode	Canvas 	scale ]			
			set stageScale  [ getNodeAttribute	$canvasDOMNode	Stage	scale ] 
			set stageUnit   [ getNodeAttribute	$canvasDOMNode	Stage	unit  ]
			set unitScale	[ get_unitRefScale 	$stageUnit    ]
			set moveVector  [ get_BottomLeft 	$w ]
			set CoordList 	[ flatten_nestedList $CoordList ]
			set args 		[ flatten_nestedList $args ]
			
				#	set cv_ObjectName [$canvasDOMNode getAttribute id]
				#	set cv_Object 	[ getValue $cv_ObjectName ]
			#set w			[ dict_getValue		$cv_Object	Canvas path	]			
			#set wScale		[ dict_getValue  	$cv_Object	Canvas 	scale ]			
			#set stageScale  [ dict_getValue 	$cv_Object	Stage	scale ] 
			#set stageUnit   [ dict_getValue 	$cv_Object	Stage	unit  ]
			#set unitScale	[ get_unitRefScale 	$stageUnit    ]
			#set moveVector  [ get_BottomLeft 	$w ]
			#set CoordList 	[ flatten_nestedList $CoordList ]
			#set args 		[ flatten_nestedList $args ]
			
			# ------ ceck $w ----------------
			if { $w == {} } {
				error "canvasCAD::create -> Error:  could not get \$w" 
			}
			
			# -------------------------------
			switch $type {
				angle 	{   foreach {dist offset colour} $args break
							set myItem [ dimension::angle    $canvasDOMNode  $CoordList  $dist  $offset  $colour ]
								# $cv_Name dimension  angle [ canvasCAD::flatten_nestedList  	$Steerer_Stem  $help_02 $HandleBar ] \
								#							[expr $StemLength + 80]   0  \
								#							darkred ]
							}
				radius	{	foreach {dist offset colour} $args break
							set myItem [ dimension::radius   $canvasDOMNode  $CoordList  $dist  $offset  $colour ]		
								# $cv_Name dimension  radius   [list $p_start $p_end] \
								#							$dim_dist  $dim_offset   \
								#							$font_colour ] 							
							}		
				length	{	foreach {orient dist offset colour} $args break
							set myItem [ dimension::length   $canvasDOMNode  $CoordList  $orient  $dist  $offset  $colour ]		
								# $cv_Name dimension  length  	[ canvasCAD::flatten_nestedList [list $pt_01 $pt_02] ] \
								#							{aligned}    [expr -70 * $stageScale] [expr 50 * $stageScale] \
								#							darkblue ]
							}		
				default		{}
			}

			set dimScale [expr $wScale*$unitScale]
			$w scale $myItem  0 0  $dimScale $dimScale
			# $w move $myItem 50 10	
			$w move $myItem [ lindex $moveVector 0 ] [ lindex $moveVector 1 ]	
			$w addtag {__Content__} withtag $myItem
			$w addtag {__Dimension__} withtag $myItem
			return $myItem
		}

		#-------------------------------------------------------------------------
			#  
		proc centerLine {canvasDOMNode CoordList args} {
				# centerline	{ set myItem 	[ create_Line 	$canvasDOMNode 	$type   $CoordList  [flatten_nestedList $args] ] }
			set w		 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Canvas 	path 		]			
			set stageScale 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Stage	scale 		]			
			set lineWidth  	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Style  	linewidth	]
			
			#set dash_01		[ expr 15 / $stageScale ]
			#set dash_02		[ expr  1 / $stageScale ]
			set dash_01		25
			set dash_02		 3
			
			set myItem  	[ eval $w create  line  $CoordList  \
								-dash	\{$dash_01 $dash_02 $dash_02 $dash_02 \} \
								-width  $lineWidth \
								[flatten_nestedList $args] ]
			return $myItem
		}

		
		
	} ;# end of namespace


	# --------------------------------------------
		# import dog to namespacd ::
	namespace import canvasCAD::newCanvas	
	
