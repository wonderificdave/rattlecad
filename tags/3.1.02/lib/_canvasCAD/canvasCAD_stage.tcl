# ============================================
#
#	canvasCAD_stage
#
# ============================================

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
	proc canvasCAD::refitToCanvas  {cv_ObjectName} {
			set canvasDOMNode	[ getNodeRoot [format "/root/instance\[@id='%s'\]" $cv_ObjectName] ]							 
			set w				[ getNodeAttribute	$canvasDOMNode	Canvas	path ]			
			set wScale			[ getNodeAttribute	$canvasDOMNode	Canvas	scale ]			
			set Unit			[ getNodeAttribute	$canvasDOMNode	Stage	unit ]

				# -- size in points
				#
			set w_width  [winfo width  $w]
			set w_height [winfo height $w]
			
				
			puts "  refitToCanvas:    wScale $wScale" 	
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
		

