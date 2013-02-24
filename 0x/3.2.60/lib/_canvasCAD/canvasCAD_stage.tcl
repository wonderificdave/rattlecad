
 ##+##########################################################################
 #
 # package: canvasCAD	->	canvasCAD_stage.tcl
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
		#  clean StageContent
		#
	proc canvasCAD::clean_StageContent { w } {
			catch [ $w delete {__Content__} ]			
	}	
	#-------------------------------------------------------------------------
		#  a copy from wiki.tcl.tk/8595
		#
	proc canvasCAD::scaleToCenter {cv_ObjectName newScale} {

			set canvasDOMNode	[ getNodeRoot [format "/root/instance\[@id='%s'\]" $cv_ObjectName] ]							 
			set w			[ getNodeAttribute	$canvasDOMNode	Canvas	path  ]			
			set wScale		[ getNodeAttribute	$canvasDOMNode	Canvas	scale ]			
			
				# -- ceck $w -------------
				# 
			if { $w == {} } {
				error "canvasCAD::scaleToCenter -> Error:  could not get \$w" 
			}
			
			set myScale 	[ expr 1.0*$newScale / $wScale]
				# puts "   ->    newScale:  $newScale"
				# puts "   ->    wScale:    $wScale"
				# puts "   ->  myScale:     $myScale"
			
				# -- scale content -------------
				# 
			set w_width  [winfo width  $w]
			set w_height [winfo height $w]
			
			if { $myScale > 0 } {
					setNodeAttribute	$canvasDOMNode 	Canvas  scale  $newScale
					
					$w 	scale 	{__Content__} 	[expr $w_width/2]  [expr $w_height/2]  $myScale  $myScale
					$w 	scale 	{__Stage__} 	[expr $w_width/2]  [expr $w_height/2]  $myScale  $myScale
					
						# -- handle shadow -------------
						#
					set stageCoords		[ $w coords  {__Stage__} ]
					$w 	delete 	{__StageShadow__}
					$w 	create rectangle   $stageCoords    \
										  -tags    {__StageShadow__}  \
										  -fill    black    \
										  -outline black    \
										  -width   0
					$w 	move 	{__StageShadow__}  6 5					  
					$w 	lower 	{__StageShadow__}  all
			
						# -- handle pointer position -----
						#
					reportPointerPostion $cv_ObjectName 0 0			
					
					update
					return $newScale
			}
			return $wScale
	}
	

	#-------------------------------------------------------------------------
		#  reposition content to Center
		#
	proc canvasCAD::repositionToCanvasCenter  {cv_ObjectName} {
			set canvasDOMNode	[ getNodeRoot [format "/root/instance\[@id='%s'\]" $cv_ObjectName] ]							 
			set w				[ getNodeAttribute	$canvasDOMNode	Canvas	path  ]	
			set wScale			[ getNodeAttribute	$canvasDOMNode	Canvas	scale ]			
			
			set stageCenter	[ get_StageCenter $w ]
			set wCenter_x  	[ expr [ winfo width  $w ] / 2 ]
			set wCenter_y 	[ expr [ winfo height $w ] / 2 ]
			
			set moveVector	[ vectormath::subVector [list $wCenter_x $wCenter_y] $stageCenter ]
			
			$w move {__Stage__} 		[lindex $moveVector 0] [lindex $moveVector 1]
			$w move {__StageShadow__} 	[lindex $moveVector 0] [lindex $moveVector 1]
			$w move {__Content__} 		[lindex $moveVector 0] [lindex $moveVector 1]
			
				# -- handle pointer position -----
				#
			reportPointerPostion $cv_ObjectName 0 0	
			
				# -- handle pointer position -----
				#
			return $wScale
			
	
	}
	

	#-------------------------------------------------------------------------
		#  refit content to Center
		#
	proc canvasCAD::refitStage  {cv_ObjectName} {
				# renamed from refitToCanvas; 20111014
			set canvasDOMNode	[ getNodeRoot [format "/root/instance\[@id='%s'\]" $cv_ObjectName] ]							 
			set w				[ getNodeAttribute	$canvasDOMNode	Canvas	path ]			
			set wScale			[ getNodeAttribute	$canvasDOMNode	Canvas	scale ]			
			set Unit			[ getNodeAttribute	$canvasDOMNode	Stage	unit ]

				# -- size in points
				#
			set w_width  [winfo width  $w]
			set w_height [winfo height $w]
			
				
			puts "  refitStage:    wScale $wScale" 	
				# -- get values from config variable
				#
			set x  		[ getNodeAttribute	$canvasDOMNode	Stage	width  ]
			set y  		[ getNodeAttribute	$canvasDOMNode	Stage	height ]

				# -- generate stage reference
				#		
			$w create rectangle   0  0  $x$Unit  $y$Unit    \
								  -tags    {__StageCheck__}  \
								  -fill    white    \
								  -outline white    \
								  -width   0
			set checkCoords	[ $w coords  {__StageCheck__} ]
			$w  delete {__StageCheck__}
			foreach {x1 y1 x2 y2} $checkCoords break
			set checkLength	[ expr $x2 -$x1 ]
								  				
				# -- get refit Scale
				#		
			set stageCoords	[ $w coords  {__Stage__} ]
			foreach {x1 y1 x2 y2} $stageCoords break
			set stageLength	[ expr $x2 -$x1 ]
			set refitScale 	[ expr 1.0 * $checkLength / $stageLength ]
			puts "   checkLength  $checkLength"
			puts "   stageLength  $stageLength"
			puts "   refitScale   $refitScale"
			
				# -- compute Canvas Scale
				#		
			foreach {x1 y1 x2 y2} $checkCoords break
			set cvBorder	[ getNodeAttribute	$canvasDOMNode	Canvas	iborder  ]
			set stage_x		[ expr $x2 - $x1]
			set stage_y		[ expr $y2 - $y1]
			set w_width_st	[ expr $w_width  - 2*$cvBorder ]
			set w_height_st	[ expr $w_height - 2*$cvBorder ]
			set scale_x		[ format "%.2f" [ expr $w_width_st  / $stage_x ] ]
			set scale_y		[ format "%.2f" [ expr $w_height_st / $stage_y ] ]
			if { $scale_x < $scale_y } { 
					set cvScale $scale_x 
			} else {
					set cvScale $scale_y 
			}
			
			puts "   $scale_x  - $scale_y :  $cvScale"
			
			
				# -- update object dictionary
				#		
			setNodeAttribute	$canvasDOMNode  Canvas scale $cvScale

				# -- scale stage by ($refitScale * $$cvScale)
				#
			set scale [ expr $cvScale * $refitScale ]
			$w scale {__StageShadow__} 	0 0 $scale $scale
			$w scale {__Stage__} 		0 0 $scale $scale
			$w scale {__Content__} 		0 0 $scale $scale


				# -- reposition to center
				#
			set stageCoords		[ $w coords  {__Stage__} ]
			set stageCenter 	[ get_BBoxInfo center $stageCoords ]
			set wCenter 		[ get_BBoxInfo center [list 0 0 $w_width $w_height] ]
			set moveVector		[ vectormath::subVector $wCenter $stageCenter ]

			$w move  {__Stage__} 	[lindex $moveVector 0] [lindex $moveVector 1]
			$w move  {__Content__} 	[lindex $moveVector 0] [lindex $moveVector 1]
			set stageCoords		[ $w coords  {__Stage__} ]
			set shadowCoords	[ $w coords  {__StageShadow__} ]
			
			set shadow_x        [ expr [lindex $stageCoords 0] - [lindex $shadowCoords 0] + 6]
			set shadow_y        [ expr [lindex $stageCoords 1] - [lindex $shadowCoords 1] + 5]


			$w move  {__StageShadow__} 	$shadow_x $shadow_y
				
			return $cvScale
	
	}
	

	#-------------------------------------------------------------------------
		#  center Content
		#
	proc canvasCAD::centerContent  {cv_ObjectName v_offSet tagList} {
			set canvasDOMNode	[ getNodeRoot [format "/root/instance\[@id='%s'\]" $cv_ObjectName] ]							 
			set w				[ getNodeAttribute	$canvasDOMNode	Canvas	path ]			

				# -- check offset
				#
			set offSet	[list [lindex $v_offSet 0] [expr -1 * [lindex $v_offSet 1] ] ]
				# -- centerStage
				#
			set coords			[ $w coords {__Stage__} ] 
			foreach {x1 y1 x2 y2}  $coords break
			set centerStage		[ list [expr $x1 + 0.5 * ($x2 - $x1)] [expr $y1 + 0.5 * ($y2 - $y1)] ]
			
				# -- centerContent
				#
			set bb_x1 99999; set bb_x2 -99999; set bb_y1 99999; set bb_y2 -99999
			set tagList_ {__Dimension__ __Frame__ __CenterLine__}
			set tagList_ {}
			foreach tagID $tagList_ {
					set contentIDs	[$w find withtag $tagID]
									# puts "  contentIDs  -> $contentIDs"
					foreach id $contentIDs {
							foreach	{x1 y1 x2 y2} [$w bbox $id] {
									# puts "    ... $id   [$w gettags $id]"
									# puts "              $x1 $y1 $x2 $y2"					
								if {$x1 < $bb_x1} {set bb_x1 $x1}
								if {$x2 > $bb_x2} {set bb_x2 $x2}
								if {$y1 < $bb_y1} {set bb_y1 $y1}
								if {$y2 > $bb_y2} {set bb_y2 $y2}
							}
					}
				#puts  " --> bbox   $bb_x1 / $bb_y1 / $bb_x2 / $bb_y2 "
			}
				#puts  " --> bbox   $bb_x1 / $bb_y1 / $bb_x2 / $bb_y2 "
				
			foreach tagID $tagList {
					set coords [ $w bbox $tagID ]
					foreach	{x1 y1 x2 y2} $coords {
							# puts "    ... $id   [$w gettags $id]"
							# puts "              $x1 $y1 $x2 $y2"					
						if {$x1 < $bb_x1} {set bb_x1 $x1}
						if {$x2 > $bb_x2} {set bb_x2 $x2}
						if {$y1 < $bb_y1} {set bb_y1 $y1}
						if {$y2 > $bb_y2} {set bb_y2 $y2}
					}
				#puts  " --> bbox  $tagID:    $bb_x1 / $bb_y1 / $bb_x2 / $bb_y2 "
			}
				#puts  " --> bbox   $bb_x1 / $bb_y1 / $bb_x2 / $bb_y2 "
				
			set centerContent	[ list [expr $bb_x1 + 0.5 * ($bb_x2 - $bb_x1)] [expr $bb_y1 + 0.5 * ($bb_y2 - $bb_y1)] ]
				
				# -- move Vector
				#
			set xy				[ vectormath::subVector $centerStage $centerContent ]
				# puts  " --> recenter Vector:  $xy "
				# puts  " --> offSet Vector:    $offSet "

			foreach tagID $tagList {
					$w move $tagID [lindex $xy 0] 		[lindex $xy 1]
					$w move $tagID [lindex $offSet 0] 	[lindex $offSet 1]
			}
			
			foreach tagID __Frame__ {
					set contentIDs	[$w find withtag $tagID]
									# puts "  contentIDs  -> $contentIDs"
					foreach id $contentIDs {
							#$w itemconfigure $id -coulor green
					}
			}
			#$w move {__Dimension__} 	[lindex $xy 0] [lindex $xy 1] 			
			#$w move {__Frame__} 		[lindex $xy 0] [lindex $xy 1]
			#$w move {__CenterLine__} 	[lindex $xy 0] [lindex $xy 1]
	 			
	}	
		#-------------------------------------------------------------------------
		#  item BoundingBox
		#
	proc canvasCAD::fit2Stage    {cv_ObjectName tagList} {
			set canvasDOMNode	[ getNodeRoot [format "/root/instance\[@id='%s'\]" $cv_ObjectName] ]							 
			set w				[ getNodeAttribute	$canvasDOMNode	Canvas	path ]			

				# puts "  -> \$tagList: $tagList"
			foreach {cb_x1 cb_y1  cb_x2 cb_y2} [$w bbox [lindex $tagList 0]] break
			if {![info exists cb_x1]} {
				puts "      -> no content!"
				return
			}
				# puts "  -> $cb_x1 $cb_y1  $cb_x2 $cb_y2"
						
			
				# -- check BoundingBox
				#
			foreach tagID $tagList {
					# puts "  -> [$w bbox $tagID]"
					foreach {x1 y1 x2 y2} [$w bbox $tagID] {
							if {$x1 < $cb_x1} {set cb_x1 $x1}
							if {$y1 < $cb_y1} {set cb_y1 $y1}
							if {$x2 > $cb_x2} {set cb_x2 $x2}
							if {$y2 > $cb_y2} {set cb_y2 $y2}
					}
			}
			set content_bb [ list $cb_x1 $cb_y1  $cb_x2 $cb_y2 ]
				# puts "  -> $cb_x1 $cb_y1  $cb_x2 $cb_y2"
			set content_width	[expr $cb_x2 - $cb_x1]
			set content_height	[expr $cb_y2 - $cb_y1]
			
			foreach {sb_x1 sb_y1  sb_x2 sb_y2} [ $w coords {__Stage__} ] break
			set stage_bb   [ list $sb_x1 $sb_y1  $sb_x2 $sb_y2 ]
				# puts "  -> $sb_x1 $sb_y1  $sb_x2 $sb_y2"
			set stage_width		[expr $sb_x2 - $sb_x1]
			set stage_height	[expr $sb_y2 - $sb_y1]
			
			set scale_x			[expr 0.9 * $stage_width / $content_width]
			set scale_y			[expr 0.9 * $stage_height / $content_height]
			if {$scale_x < $scale_y} {
				set scale $scale_x
			} else {
				set scale $scale_y
			}

			foreach tagID $tagList {
				$w scale $tagID 0 0 $scale $scale
			}
			
			centerContent $cv_ObjectName {0 0} $tagList
				 
	}
		#-------------------------------------------------------------------------
		#  item BoundingBox
		#
	proc canvasCAD::__boundingBox    {cv_ObjectName tagList} {
			set canvasDOMNode	[ getNodeRoot [format "/root/instance\[@id='%s'\]" $cv_ObjectName] ]							 
			set w				[ getNodeAttribute	$canvasDOMNode	Canvas	path ]			

				# -- check BoundingBox
				#
			foreach tagID $tagList {
					set tagID_coords [$w coords $tagID]
					puts "   -> [llength $tagID_coords]"
					puts "------"
					if {[llength $tagID_coords] > 4} {
						puts "\n\$tagID_coords"
						puts "$tagID_coords"
						foreach {x y} $tagID_coords break
									set bb_x1 $x
									set bb_x2 $x
									set bb_y1 $y
									set bb_y2 $y								
						foreach {x y} $tagID_coords {
									if {$x < $bb_x1} {set bb_x1 $x}
									if {$y < $bb_y1} {set bb_y1 $y}
									if {$x > $bb_x2} {set bb_x2 $x}
									if {$y > $bb_y2} {set bb_y2 $y}
						}
						puts "  -> $bb_x1 $bb_y1  $bb_x2 $bb_y2"
						return [list $bb_x1 $bb_y1  $bb_x2 $bb_y2] 
					} else {
						return $tagID_coords
					}
			}
			 
	}
	#-------------------------------------------------------------------------
		#  format Canvas DIN_Format, Stage Scale
		#
	proc canvasCAD::formatCanvas  {cv_ObjectName st_format st_Scale} {
			set canvasDOMNode	[ getNodeRoot [format "/root/instance\[@id='%s'\]" $cv_ObjectName] ]							 
			set w				[ getNodeAttribute	$canvasDOMNode	Canvas	path ]			
			#set wScale			[ getNodeAttribute	$canvasDOMNode	Canvas	scale ]			
			#set Unit			[ getNodeAttribute	$canvasDOMNode	Stage	unit ]


			foreach {stageWidth stageHeight stageUnit} 	[getFormatSize $st_format] break



			puts "   $canvasDOMNode -> [ getNodeAttribute	$canvasDOMNode	Stage  width   ] / [ getNodeAttribute	$canvasDOMNode	Stage  height   ]"
			set oldWidth	[ getNodeAttribute	$canvasDOMNode		Stage  width   ]
			set oldHeight	[ getNodeAttribute	$canvasDOMNode		Stage  height  ]
						
			setNodeAttribute		$canvasDOMNode		Stage  width   		$stageWidth
			setNodeAttribute		$canvasDOMNode		Stage  height  		$stageHeight
			setNodeAttribute		$canvasDOMNode		Stage  format  		$st_format
			setNodeAttribute		$canvasDOMNode		Stage  scale   		$st_Scale
						
			set fontSize	[getNodeAttributeRoot /root/_package_/DIN_Format/$st_format f2]
			setNodeAttribute		$canvasDOMNode		Style  linewidth	[expr 0.1* $fontSize]	
			setNodeAttribute		$canvasDOMNode		Style  fontsize		$fontSize
						
			puts "   $canvasDOMNode -> [ getNodeAttribute	$canvasDOMNode	Stage  width   ] / [ getNodeAttribute	$canvasDOMNode	Stage  height   ]"
						
			set coords	[ $w coords {__StageShadow__} ] 
			set coords	[ $w coords {__Stage__} ] 
			puts "\n   -> $coords\n"
			foreach {x1 y1 x2 y2}  $coords break
			set width 	[expr $x2 - $x1]
			set formatScale [expr 1.0 * $stageWidth / $oldWidth]
			puts "       ->   $stageWidth / $oldWidth  => $formatScale"
		
			$w 	scale  {__Stage__}  		$x1 $y1 $formatScale $formatScale
			$w 	scale  {__StageShadow__}  	$x1 $y1 $formatScale $formatScale

			return $canvasDOMNode

	}
		

