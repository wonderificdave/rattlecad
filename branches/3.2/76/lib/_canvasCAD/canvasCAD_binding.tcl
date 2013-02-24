
 ##+##########################################################################
 #
 # package: canvasCAD	->	canvasCAD_binding.tcl
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


	variable  	canvasCAD::CANVAS_Point       
	array 	set canvasCAD::CANVAS_Point { \
						x0 0
						y0 0
						x1 0
						y1 0 
					}


	#-------------------------------------------------------------------------
		#  canvas mouse position report
		#
	proc canvasCAD::reportPointerPostion { name x y} {
			set canvasDOMNode	[getNodeRoot [format "/root/instance\[@id='%s'\]" $name] ]									 
			set w			[ canvasCAD::getNodeAttribute  	$canvasDOMNode	Canvas	path  ]			
			set wScale		[ canvasCAD::getNodeAttribute  	$canvasDOMNode	Canvas	scale ]			
			set stageScale 	[ canvasCAD::getNodeAttribute  	$canvasDOMNode	Stage	scale ]			
			set stageUnit 	[ canvasCAD::getNodeAttribute  	$canvasDOMNode	Stage	unit  ]			
			set unitScale	[ get_unitRefScale	$stageUnit	]

			set bottomLeft [ get_BottomLeft $w ]
			foreach {bL_x bL_y} $bottomLeft break
			set stage_x 	[ format "%4.2f" [expr  ( [eval $w canvasx $x] - $bL_x ) /   $unitScale ] ]
			set stage_y 	[ format "%4.2f" [expr  ( [eval $w canvasy $y] - $bL_y ) /  -$unitScale ] ]
			set fmtScale 	[ format "%4.4f" $stageScale ]
			set fmtOrig_x	[ format "%4.2f" [expr $stage_x/($stageScale*$wScale)]]
			set fmtOrig_y	[ format "%4.2f" [expr $stage_y/($stageScale*$wScale)]]
			$w delete __PointerPostion__
			$w create text 0 0 \
				-anchor sw -tags {__PointerPostion__} \
				-text "scale: $fmtScale / $wScale  \[$stageUnit\]  $fmtOrig_x / $fmtOrig_y "
				# text "\[$stageUnit\]  scale: $fmtScale: $stage_x / $stage_y  -  \[ $fmtOrig_x / $fmtOrig_y \]"
				
			reposition_PointerPostionReport $w
	}
	proc canvasCAD::reposition_PointerPostionReport { w } {
			set repCoords	[ $w coords {__PointerPostion__} ]
			if { $repCoords == {} } return
			foreach {x y} $repCoords break
			set move_x		[ expr  0 - $x + 8 ]
			set move_y		[ expr [winfo height $w] - $y - 4 ]
			$w move {__PointerPostion__} $move_x $move_y
	}
		
	
	#-------------------------------------------------------------------------
		#  setMark; mark the first (x,y) coordinate for moving/zooming.
		#
	proc canvasCAD::setMark {w x y type} {
			variable  CANVAS_Point 

			set CANVAS_Point(x0) [$w canvasx $x]
			set CANVAS_Point(y0) [$w canvasy $y]
			switch $type {
				move { $w create line      $x $y $x $y -fill red       -tag {__PointerBBox__} 
					   $w configure -cursor hand2
					 }
				zoom { $w create rectangle $x $y $x $y -outline black  -tag {__PointerBBox__} 
					   $w configure -cursor sizing
					 }
			}
	}
	

	#-------------------------------------------------------------------------
		#  setStroke; mark the second (x,y) coordinate for moving/zooming.
		#
    proc canvasCAD::setStroke {w x y} {
			variable  CANVAS_Point
			
			set CANVAS_Point(x1) [$w canvasx $x]
			set CANVAS_Point(y1) [$w canvasy $y]
			$w coords {__PointerBBox__} $CANVAS_Point(x0) $CANVAS_Point(y0) $CANVAS_Point(x1) $CANVAS_Point(y1) 
	}
	

	#-------------------------------------------------------------------------
       #  moveCanvas; move  content by selected by setMark and setStroke.
       #
	proc canvasCAD::moveContent {w x y cv_ObjectName} {
			variable  CANVAS_Point

				#--------------------------------------------------------
					#  Get the final coordinates.
					#  Remove area selection rectangle
			set CANVAS_Point(x1) [$w canvasx $x]
			set CANVAS_Point(y1) [$w canvasy $y]
			$w delete {__PointerBBox__}

				#--------------------------------------------------------
					#  Check for zero-size area
			if {($CANVAS_Point(x0)==$CANVAS_Point(x1)) || ($CANVAS_Point(y0)==$CANVAS_Point(y1))} {
				return
			}

				#--------------------------------------------------------
					#  Determine size of move
			set movexlength [expr $CANVAS_Point(x1)-$CANVAS_Point(x0)]
			set moveylength [expr $CANVAS_Point(y1)-$CANVAS_Point(y0)]
				
				#--------------------------------------------------------
					#  move
			$w move {__Stage__} $movexlength $moveylength
			$w move {__StageShadow__} $movexlength $moveylength
			$w move {__Content__} $movexlength $moveylength


				#--------------------------------------------------------
					#  Change the scroll region one last time, to fit the
					#  items on the canvas.
			$w configure -cursor {}
					# $w configure -scrollregion [$w bbox all]
			
				#--------------------------------------------------------
					#  update reportPointerPosition
			reportPointerPostion $cv_ObjectName 0 0			
    }
	

	#-------------------------------------------------------------------------
       #  zoomArea
       #
       #  Zoom in to the area selected by setMark and
       #  setStroke.
       #
	proc canvasCAD::zoomArea {w x y cv_ObjectName} {
			variable  CANVAS_Point

			set canvasDOMNode	[getNodeRoot [format "/root/instance\[@id='%s'\]" $cv_ObjectName] ]									 
			set w			[ getNodeAttribute  	$canvasDOMNode	Canvas	path  ]			

				#--------------------------------------------------------
					#  Get the final coordinates.
					#  Remove area selection rectangle
			set CANVAS_Point(x1) [$w canvasx $x]
			set CANVAS_Point(y1) [$w canvasy $y]

				#--------------------------------------------------------
					#  Check for zero-size area
			if {($CANVAS_Point(x0)==$CANVAS_Point(x1)) || ($CANVAS_Point(y0)==$CANVAS_Point(y1))} {
				return
			}

				#--------------------------------------------------------
					#  Determine size and center of selected area
			set areaxlength [expr {abs($CANVAS_Point(x1)-$CANVAS_Point(x0))}]
			set areaylength [expr {abs($CANVAS_Point(y1)-$CANVAS_Point(y0))}]
			set xcenter     [expr {($CANVAS_Point(x0)+$CANVAS_Point(x1))/2.0}]
			set ycenter     [expr {($CANVAS_Point(y0)+$CANVAS_Point(y1))/2.0}]

				#--------------------------------------------------------
					#  Determine size of current window view
					#  Note that canvas scaling always changes the coordinates
					#  into pixel coordinates, so the size of the current
					#  viewport is always the canvas size in pixels.
					#  Since the canvas may have been resized, ask the
					#  window manager for the canvas dimensions.
			set winxlength [winfo width  $w]
			set winylength [winfo height $w]

				#--------------------------------------------------------
					#  Calculate scale factors, and choose smaller
			set xscale [expr {$winxlength/$areaxlength}]
			set yscale [expr {$winylength/$areaylength}]
			if { $xscale > $yscale } {
				set factor $yscale
			} else {
				set factor $xscale
			}

			recenter $w $factor {__PointerBBox__}
				   # lib_canvas::display_bbox       $w  create  $border_x  $border_y 
			$w delete {__PointerBBox__}

				#--------------------------------------------------------
					#  Perform return currentfactor
			puts "    cv_ObjectName:  $cv_ObjectName"
			if {$cv_ObjectName != {} } {
					eval [format "canvasCAD::pointerScale %s %f"  $cv_ObjectName  $factor]
			}
				
				#--------------------------------------------------------
					#  Change the scroll region one last time, to fit the
					#  items on the canvas.
			$w configure -cursor {}
					# $w configure -scrollregion [$w bbox all]
			
				#--------------------------------------------------------
					#  update reportPointerPosition
			reportPointerPostion $cv_ObjectName 0 0			
    }

	proc canvasCAD::pointerScale { cv_ObjectName  {scale {}} } {           
			set canvasDOMNode	[getNodeRoot [format "/root/instance\[@id='%s'\]" $cv_ObjectName] ]									 
			set w			[ getNodeAttribute	$canvasDOMNode	Canvas	path  ]			
			set wScale		[ getNodeAttribute	$canvasDOMNode	Canvas 	scale ]	
			if {$scale == {} } {
				return $wScale
			} 			
				# -- modify scale parameter from extern
			set newScale	[ eval format "%.4f" [ expr	$wScale * $scale ] ]
					# set FRAME(Reposition_Scale)  [expr $scale*$FRAME(Reposition_Scale)]
			
				# puts "    ->   wScale         $wScale"
				# puts "    ->   scale   $scale"
				# puts "    ->   newScale   $newScale"
			set wScale		[ setNodeAttribute	$canvasDOMNode Canvas 	scale  $newScale ]
				# puts "    ->   wScale         $wScale"
			return $wScale
	}

	#-------------------------------------------------------------------------
		#  recenter and scale canvas
		#
	proc canvasCAD::recenter { w scale {tag all} } {
			set bbox   [ $w bbox $tag ] 
			if {[llength $bbox] == 0 } { 
				return 
			} 
			
			set cv_size     [ get_Size  $w ]
			set cv_center   [ get_BBoxInfo  center [list 0 0 [lindex $cv_size 0]  [lindex $cv_size 1] ] ]
			   # set cv_center   [get_BBoxInfo  center [list 0 0 [lrange  $cv_size  0 1] ] ]
			set bb_center   [ get_BBoxInfo  center $bbox ]
			set bb_move     [ vectormath::subVector  $cv_center  $bb_center  ] 

			$w move   all	[lindex $bb_move   0]  [lindex $bb_move   1]
			$w scale  all	[lindex $cv_center 0]  [lindex $cv_center 1]  $scale  $scale   
	}
   
	#-------------------------------------------------------------------------
		#  keep canvas content bound to canvas bottom
		#  a copy from wiki.tcl.tk/9223
		#
	proc canvasCAD::resizeCanvas {w} {
			reposition_PointerPostionReport $w
			
			set w_width  	[ winfo width  $w ]
			set w_height 	[ winfo height $w ]
			set center_x	[ expr $w_width  / 2 ]
			set center_y	[ expr $w_height / 2 ]
			
			set centerCoords [ $w coords {__Stage__} ]
			foreach {x1 y1 x2 y2} $centerCoords break
			set cnt_st_x	[ expr $x1 + ($x2 - $x1)/2 ]	
			set cnt_st_y	[ expr $y1 + ($y2 - $y1)/2 ]

			set move_x [expr $center_x  - $cnt_st_x ]
			set move_y [expr $center_y  - $cnt_st_y ]
			
			$w move {__Stage__} 		$move_x $move_y
			$w move {__StageShadow__} 	$move_x $move_y
			$w move {__Content__} 		$move_x $move_y			
	}



