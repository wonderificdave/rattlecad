
 ##+##########################################################################
 #
 # package: canvasCAD 	->	dimension.tcl
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
 #	namespace:  canvasCAD::dimension
 # ---------------------------------------------------------------------------
 #
 #

 
namespace eval dimension {
          
	
	# --------------------------------------------
			# vectorfont definitions
	vectorfont::load_shape m_iso8.shp
	vectorfont::setscale 1.0
	

	#-------------------------------------------------------------------------
			#  
    proc create_Line { canvasDOMNode p1 p2 colour } {
			
			set w		 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Canvas 	path 		]			
			set stageScale 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Stage	scale 		]			
			set lineWidth  	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Style	linewidth	]
			
			set coords 		[list 	[lindex $p1  0]  [lindex $p1  1] \
									[lindex $p2  0]  [lindex $p2  1]]
			
			set coords  	[ eval canvasCAD::convert_BottomLeft $stageScale $coords ]
			set myItem  	[ eval $w create  line  $coords  \
									-fill   $colour \
									-width  $lineWidth ]
			return $myItem
	}
	

		#-------------------------------------------------------------------------
			#  
    proc create_Arc { canvasDOMNode p r start extent colour } {
				# tk_messageBox -message "  dimension::angle create_Arc  \n p: $p  \n r: $r  \n start: $start  \n extent: $extent  \n colour: $colour  \n lw: $lw  \n tagID: $tagID "			
			set w		 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Canvas 	path 		]			
			set stageScale 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Stage	scale 		]			
			set lineWidth  	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Style	linewidth	]
			
				foreach {x y} $p break
			set coords	    [ list 	[expr $x - $r] [expr $y - $r]  \
									[expr $x + $r] [expr $y + $r]	]
			
			set coords		[ eval canvasCAD::convert_BottomLeft $stageScale $coords ]									
			set myItem		[ $w create arc $coords \
								-start 	 $start  \
								-extent  $extent  \
								-style   {arc}  \
								-outline $colour  \
								-width   $lineWidth ]	
			return $myItem
	}
		
		
		#-------------------------------------------------------------------------
			#  
    proc create_LineEnd { canvasDOMNode p end_angle colour {style inside} } {
       
			set w		 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Canvas 	path 		]			
			set stageScale 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Stage	scale 		]			
			set fontSize 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Style	fontsize 	]
			set lineWidth  	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Style	linewidth	]
			set lineDist 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Style	fontdist	]
			
			# -------------------------------
				# reset item container
			set endListName [format "dimEnd_%s" [llength [$w find withtag all]] ]
				# $w dtag   $endListName all
			
			# -------------------------------
				# create line extension
					# puts "   -> $style    $style"
			if { $style != {inside} } { 
				set end_angle 	[ expr $end_angle + 180 ] 
				set p_outl		[ vectormath::rotateLine  $p  [expr ($fontSize + 2) / $stageScale]  $end_angle ]
				set coords		[ list 	[lindex $p  	0]  [lindex $p  	1] \
										[lindex $p_outl	0]  [lindex $p_outl	1] ]
									
				set coords  	[ eval canvasCAD::convert_BottomLeft $stageScale $coords ]
				set myItem  	[ eval $w create  line  $coords  -fill $colour  -width $lineWidth ]
					$w addtag $endListName withtag $myItem	
			}
								

			# -------------------------------
				# create arrow-end
			set  asl  [ expr $fontSize/[expr $stageScale * cos([expr 15*(4*atan(1))/180])] ]
			set p0   	[ vectormath::rotateLine  $p  [expr 1/$stageScale]  [expr $end_angle + 90  ] ]
			set p1   	[ vectormath::rotateLine  $p  $asl  				[expr $end_angle +  7.5] ]
			set p2   	[ vectormath::rotateLine  $p  $asl  				[expr $end_angle -  7.5] ]
			set p3   	[ vectormath::rotateLine  $p  [expr 1/$stageScale]  [expr $end_angle - 90  ] ]
			
			set coords 		[ list 	[lindex $p0  0]  [lindex $p0  1] \
									[lindex $p   0]  [lindex $p   1] \
									[lindex $p1  0]  [lindex $p1  1] \
									[lindex $p2  0]  [lindex $p2  1] \
									[lindex $p   0]  [lindex $p   1] \
									[lindex $p3  0]  [lindex $p3  1] ]
			
			set coords  [ eval canvasCAD::convert_BottomLeft $stageScale $coords ]
			set myItem  [ eval $w create  line  $coords  -fill $colour  -width  $lineWidth ]
					$w addtag $endListName withtag $myItem	

			return $endListName
	}
	

		#-------------------------------------------------------------------------
			#  	create_Text   $w  $cv_Config  $cv_Dimension  $dimText  $textOrient  $textPosition  $textPosAngle 
			#	create_Text   $w  $cv_Config  $cv_Dimension  $dimText  $textPosition  $textPosAngle $textOrient  
    proc create_Text {canvasDOMNode dimValue format p dimAngle colour } {
		
			set w		 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Canvas 	path 		]			
			set stageUnit 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Stage	unit 		]			
			set stageScale 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Stage   scale 		]			
			set fontSize 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Style  	fontsize 	]
			set fontColour 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Style  	fontcolour	]
			set fontDist	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Style  	fontdist	]
			set font 		[ canvasCAD::getNodeAttribute  $canvasDOMNode	Style  	font		]
			set fontStyle 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Style  	fontstyle	]
			set fontWidth	[ expr $fontSize / 10 ]
			set unitScale	[ canvasCAD::get_unitRefScale $stageUnit ]
			

			# -------------------------------
				# format text
			if { $fontColour != $colour } { set fontColour 	$colour }
			if { $dimValue < 0 } {set dimValue [expr -1*$dimValue]	}
			set text_1	[ format "%.1f%s" $dimValue	$format]
                        set text 	[ string map {. ,} $text_1	]
			
			# -------------------------------
				# geometric definitions			
			set checkAngle $dimAngle
			if {$dimAngle <   0} { set checkAngle [expr $dimAngle + 360] }
			if {$dimAngle > 360} { set checkAngle [expr $dimAngle - 360] }
			
					# puts " checkAngle $checkAngle"
				
				# geometric definitions			
			set fontDist 	[ expr $fontDist / $stageScale ]
			if {$checkAngle > 180} {
					set textOrient 	+90
					set textPos 	[ vectormath::rotateLine   $p $fontDist [expr 180 + $dimAngle] ]
			} elseif { $checkAngle == 0} {
					set textOrient 	+90
					set textPos 	[ vectormath::rotateLine   $p $fontDist [expr 180 + $dimAngle] ]
			} else {
					set textOrient 	-90
					set textPos 	[ vectormath::rotateLine   $p $fontDist $dimAngle ]
			}
			set textPos_bL	[ canvasCAD::convert_BottomLeft $stageScale $textPos ]
				foreach {x y} $textPos_bL break


			# -------------------------------
				# depend on style
			if {$fontStyle == "vector"} {
					vectorfont::setposition  	$x $y
					vectorfont::setalign  		s
					vectorfont::setangle  		[ expr $dimAngle + $textOrient]
					vectorfont::setcolor  		$fontColour
					vectorfont::setline   		$fontWidth
					vectorfont::setscale  		[ expr $fontSize  / (8 * [canvasCAD::get_unitRefScale m] ) ] 
					
					set myItem 	[ vectorfont::drawtext $w $text]
			} else {		
					set font 		[format "%s %s"   $font  [ expr round($fontSize * 10 / 2.8) ] ]
					puts "  -> fontSize: $fontSize"
					set myItem 		[ $w create text  $x $y \
										-text   $text \
										-anchor s \
										-fill   $fontColour \
										-font   $font ]
			}
			
			return $myItem
					
				# set myBase 		[ create_Point  $w  $cv_Config  $cv_Dimension  $p  2  black]
				# set textBase 	[ create_Point  $w  $cv_Config  $cv_Dimension  $textPos  2  blue]
				# $w dtag   {_myVText_} all
				# $w addtag {_myVText_} withtag $myBase 
				# $w addtag {_myVText_} withtag $textBase 
				# $w addtag {_myVText_} withtag $myItem 

				# return {_myVText_}
	}


		#-------------------------------------------------------------------------
			#  
	proc create_Point {canvasDOMNode  p radius colour} {
	   
			set w		 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Canvas 	path 		]			
			set stageScale 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Stage   scale 		]			
			set lineWidth  	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Style  	linewidth	]

			set p_center	[ eval canvasCAD::convert_BottomLeft $stageScale $p ] 
			set radius		[ expr $radius * $stageScale ] 
				foreach {x y} $p_center break
			set coords	    [ list 	[expr $x - $radius] [expr $y - $radius]  \
									[expr $x + $radius] [expr $y + $radius]	]
			
			set myItem		[ $w create oval $coords \
								-fill	$colour \
								-width	0 ]
			return $myItem
	}

	
	# -------------------------------
			# function noramlizeAngle
	proc noramlizeAngle {angle} {
			while { $angle < 0} {
				set angle	[expr $angle + 360]
			}
			while { $angle > 360} {
				set angle	[expr $angle - 360]
			}
			return $angle
	}
	

		#-------------------------------------------------------------------------
           #  
           #
	proc angle { canvasDOMNode  p_Coords  dimRadius {textOffset 0} {colour black}} {
        
					# tk_messageBox -message "  dimension::angle   \n w: $w  \n pc: $pc  \n p1: $p1  \n p2: $p2  \n arcRadius: $arcRadius  \n textOffset: $textOffset  \ntagID: $tagID  \n colour: $colour"
					# return
					#set cv_ObjectName [$canvasDOMNode getAttribute id]
					#set cv_Object 	[ canvasCAD::getValue $cv_ObjectName ]

			set w			[ canvasCAD::getNodeAttribute  $canvasDOMNode  Canvas  path ]
			set fontSize	[ canvasCAD::getNodeAttribute  $canvasDOMNode  Style   fontsize ]			
			set stageScale 	[ canvasCAD::getNodeAttribute  $canvasDOMNode  Stage   scale ]			
			#set w			[ canvasCAD::dict_getValue	$cv_Object	Canvas path		]			
			#set fontSize 	[ canvasCAD::dict_getValue  $cv_Object	Style  fontsize	]
					# set stageScale 	[ canvasCAD::dict_getValue  $cv_Config     scale 		]			
					# set stageUnit 	[ canvasCAD::dict_getValue  $cv_Config     unit 		]			
					# set unitScale	[ canvasCAD::get_unitRefScale $stageUnit ]
		
			set checkLength	[ expr (1 + 2 * $fontSize) / $stageScale]

			set pc    [ list [lindex $p_Coords 0] [lindex $p_Coords 1] ]
			set p1    [ list [lindex $p_Coords 2] [lindex $p_Coords 3] ]
			set p2    [ list [lindex $p_Coords 4] [lindex $p_Coords 5] ]
			
			set Scale [canvasCAD::getNodeAttribute  $canvasDOMNode	Stage	scale ]
			set Unit  [canvasCAD::getNodeAttribute  $canvasDOMNode	Stage	unit  ]
			set Scale [canvasCAD::getNodeAttribute  $canvasDOMNode	Stage	scale ]
			set Unit  [canvasCAD::getNodeAttribute  $canvasDOMNode	Stage	unit  ]

		# -------------------------------
				# ceck $w
			if { $w == {} } {
				error "canvasCAD::dimension::angle -> Error:  could not get \$w" 
			}
			
        # -------------------------------
				# correct in case of {} parameters ... execution through canvasCAD::dimension
			if {$textOffset == {}} { set textOffset 0		}
			if {$colour 	== {}} { set colour 	black	}

        # -------------------------------
				# reset item container
			set tagListName [format "dimGroup_%s" [llength [$w find withtag all]] ]
			$w dtag  $tagListName all

        # -------------------------------
				# correct direction
			set arcRadius $dimRadius
			
        # -------------------------------
				# get direction
			set angle_p1    [ vectormath::dirAngle $pc $p1 ]
			set angle_p2    [ vectormath::dirAngle $pc $p2 ]

			# -------------------------------
				# negativ dimRadius exception
			if { $dimRadius < 0 } {
				set angle_x		$angle_p1
				set angle_p1	$angle_p2
				set angle_p2	[ expr 360 + $angle_x ]
			}
			set gapAngle    [ expr $angle_p2 - $angle_p1 ]
			
			# -------------------------------
				# angle in between 3 points
			set angle_p1 	[ noramlizeAngle $angle_p1 ]
 			set absAngle 	[ noramlizeAngle $gapAngle ]     
			
					# set angle_p1    [ eval format "%0.3f" $angle_p1 ]
					# set angle_p2    [ eval format "%0.3f" $angle_p2 ]
			
			if { [eval format "%0.3f" $angle_p1] == [eval format "%0.3f" $angle_p2] } { return }
			
			set angle_p2    [ expr $angle_p1 + $absAngle ]
					# set angle_p2    [ eval format "%0.3f" $angle_p2 ]
			
					# puts "    ... angle_p1:  		$angle_p1"
					# puts "    ... angle_p2:  		$angle_p2"
					# puts "    ... gapAngle:  		$gapAngle"

		# -------------------------------
				# no text offset if distance less than 2+fontSize -> $checkLength
			if { [expr abs($arcRadius)] < $checkLength } { set textOffset 0 }
			
		# -------------------------------
				# dimension arc and text position angle
				# "create_Arc w cv_Config cv_Dimension p r start extent colour lw"
					# puts "    ... gapAngle:  		$gapAngle"
			set textPosAngle	[ expr $angle_p1 + 0.5*$absAngle - $textOffset ]
			if { $dimRadius < 0 } {
				set textPosAngle	[ expr 180 + $textPosAngle ]
			}
		# -------------------------------
				# text position
			set textPosition	[ vectormath::rotateLine  $pc  $arcRadius  $textPosAngle]

        #  ---------------------------------------------
				# create text
			set myText [ create_Text   $canvasDOMNode  $absAngle  {°}  $textPosition  $textPosAngle  $colour ]
				$w addtag $tagListName withtag $myText
					# set myBase [ create_Point  $w  $cv_Config  $cv_Dimension  $textPosition  5  red]

        # -------------------------------
				# dimension help lines parameters
			set angle_dim_p1	[ expr $angle_p1  +  90 ]
			set angle_dim_p2	[ expr $angle_p2  -  90 ]
			
			set p_hl_p1			[ vectormath::rotateLine  $p1  [expr 2 / $stageScale]  $angle_p1 ]
			set p_hl_p2			[ vectormath::rotateLine  $p2  [expr 2 / $stageScale]  $angle_p2 ]
			if { $dimRadius > 0 } {
				set p_hl_dim_p1 [ vectormath::rotateLine  $pc  $arcRadius  $angle_p1 ]
				set p_hl_dim_p2	[ vectormath::rotateLine  $pc  $arcRadius  $angle_p2 ]
			} else {
				set p_hl_dim_p1	[ vectormath::rotateLine  $pc  $arcRadius  [expr 180 + $angle_p1] ]
				set p_hl_dim_p2	[ vectormath::rotateLine  $pc  $arcRadius  [expr 180 + $angle_p2] ]
			}

				# -------------------------------
				# dimension help lines
					# create_Line { w cv_Config cv_Dimension p1 p2 }
			set check_ln_p1 	[ vectormath::length $pc $p1]
			set check_ln_p2 	[ vectormath::length $pc $p2]
			if {$check_ln_p1 < $arcRadius } {
				set myLine [ create_Line  $canvasDOMNode  $p_hl_p1  $p_hl_dim_p1  $colour ]
					$w addtag $tagListName withtag $myLine
			}
			if {$check_ln_p2 < $arcRadius } {
				set myLine [ create_Line  $canvasDOMNode  $p_hl_p2  $p_hl_dim_p2  $colour ]
					$w addtag $tagListName withtag $myLine 
			}
 
		# -------------------------------
				# dimension arc ends
				# create_LineEnd { w cv_Config cv_Dimension p end_angle }
			set asinParameter	[ expr 1.0 * $checkLength/(2*$arcRadius) ]
			set checkAngle 		180
					# puts "   -> asinParameter  $asinParameter"
			if { [expr abs($asinParameter)] < 1 } {
				set checkAngle 		[ expr 2 * asin($asinParameter) * 180 / $vectormath::CONST_PI ]
			}
			
			if { $absAngle > $checkAngle } {
					set myEnd [ create_LineEnd  $canvasDOMNode  $p_hl_dim_p1  $angle_dim_p1  $colour ]
						$w addtag $tagListName withtag $myEnd
					set myEnd [ create_LineEnd  $canvasDOMNode  $p_hl_dim_p2  $angle_dim_p2  $colour ]
						$w addtag $tagListName withtag $myEnd 
			} else {
					set myEnd [ create_LineEnd  $canvasDOMNode  $p_hl_dim_p1  $angle_dim_p1  $colour  {outside} ]
						$w addtag $tagListName withtag $myEnd
					set myEnd [ create_LineEnd  $canvasDOMNode  $p_hl_dim_p2  $angle_dim_p2  $colour  {outside} ]
						$w addtag $tagListName withtag $myEnd 
			}
			
        # -------------------------------
				# arc extension on offset 
			if { $textOffset != 0 } {
				set extAngle	0
				set offsetAngle	0
				# --- compute extension from fontSize	
				set asinParameter	[ expr 1.0 * $checkLength/$arcRadius ]
				if { $asinParameter < 1 } {
					set asinParameter	[ expr 1.5 * $fontSize/$arcRadius ]
					set extAngle 		[ expr asin($asinParameter) * 180 / $vectormath::CONST_PI ]
				} 
					# puts "    ... gapAngle:  		$gapAngle"
				
				set offsetAngle	  [ expr $angle_p1 + $absAngle/2 - $textOffset ]
				set offsetAngle_1 [ expr $angle_p1 + $absAngle/2 - $textOffset - $extAngle ]
				set offsetAngle_2 [ expr $angle_p2 - $absAngle/2 - $textOffset + $extAngle ]
					# puts "    ... textOffset:   	$textOffset    "
					# puts "    ... angle_p1:   	$angle_p1   $offsetAngle_1 "
					# puts "    ... angle_p2:   	$angle_p2   $offsetAngle_2 "
				if { $textOffset > 0 } {
					if { $offsetAngle_1 < $angle_p1 } { set angle_p1 $offsetAngle_1 }
				} else {
					if { $offsetAngle_2 > $angle_p2 } { set angle_p2 $offsetAngle_2 }
				}

				# --- debug in graphic
					# set myOffSet 	[ vectormath::rotateLine  $pc  $arcRadius  $offsetAngle ]
					# set myP1 		[ vectormath::rotateLine  $pc  $arcRadius  $angle_p1 ]
					# set myP2 		[ vectormath::rotateLine  $pc  $arcRadius  $angle_p2 ]
					# set myBase 		[ create_Point  $w  $cv_Config  $cv_Dimension  $myOffSet  1  orange]
					#	 $w addtag $tagListName withtag $myBase
					# set myBase 		[ create_Point  $w  $cv_Config  $cv_Dimension  $myP1  1  red]
					#	 $w addtag $tagListName withtag $myBase
					# set myBase 		[ create_Point  $w  $cv_Config  $cv_Dimension  $myP2  1  blue]
					#	 $w addtag $tagListName withtag $myBase
				
			}
			
		# -------------------------------
				# dimension arc and text position angle
				# "create_Arc w cv_Config cv_Dimension p r start extent colour lw"
			set arcAngle		[ expr $angle_p2 - $angle_p1 ]
					# puts "    ... arcAngle:   	$arcAngle   "
					# puts "    ... angle_p1:   	$angle_p1   "
					# puts "    ... angle_p2:   	$angle_p2   "
			# set checkValue 		[expr $angle_p2 - $angle_p1 ]
					# puts "    ... checkValue:   	$checkValue   "

			if { [expr $angle_p2 - $angle_p1 ] > 360 } {
						set myArc [ create_Arc  $canvasDOMNode  $pc  $arcRadius  0 359.999  $colour ]
							$w addtag $tagListName withtag $myArc 
			} else {
					
					if { [expr $angle_p1 + $arcAngle] < 360} {
						set myArc [ create_Arc  $canvasDOMNode  $pc  $arcRadius  $angle_p1  $arcAngle  $colour ]
							$w addtag $tagListName withtag $myArc 
					} else {
						set myArc [ create_Arc  $canvasDOMNode  $pc  $arcRadius  $angle_p1  $arcAngle  $colour ]
							$w addtag $tagListName withtag $myArc 
						set myArc [ create_Arc  $canvasDOMNode  $pc  $arcRadius  0			[expr $angle_p1 + $arcAngle - 360 ]  $colour ]
							$w addtag $tagListName withtag $myArc 
					}
			}
			
		#  ---------------------------------------------
				#  sum up and return
					# $w addtag $tagListName withtag $myBase
					# $w addtag $tagListName withtag $myHelp
					# $w addtag $tagListName withtag $myPos
					# $w move {myArc} 30 0

		return $tagListName
	}
	

		#-------------------------------------------------------------------------
           #  
           #
	proc radius { canvasDOMNode  p_Coords  dimDistAngle {textOffset 0} {colour black}} {

					#set cv_ObjectName [$canvasDOMNode getAttribute id]
					#set cv_Object 	[ canvasCAD::getValue $cv_ObjectName ]

        
			set w			[ canvasCAD::getNodeAttribute  $canvasDOMNode	Canvas path		]			
			set fontSize 	[ canvasCAD::getNodeAttribute  $canvasDOMNode	Style  fontsize ]
			set stageScale 	[ canvasCAD::getNodeAttribute  $canvasDOMNode  Stage   scale ]			
					# set stageScale 	[ canvasCAD::dict_getValue  $cv_Config     scale 		]			
			# set stageUnit 	[ canvasCAD::dict_getValue  $cv_Config     unit 		]			
					# set unitScale	[ canvasCAD::get_unitRefScale $stageUnit ]
		
			set checkLength	[ expr (1 + 2 * $fontSize) / $stageScale]

			set p0    [ list [lindex $p_Coords 0] [lindex $p_Coords 1] ]
			set p1    [ list [lindex $p_Coords 2] [lindex $p_Coords 3] ]
			
			#set Scale [ canvasCAD::getNodeAttribute  $canvasDOMNode	Stage	scale ]
			#set Unit  [ canvasCAD::getNodeAttribute  $canvasDOMNode	Stage	unit  ]

		# -------------------------------
				# ceck $w
			if { $w == {} } { 
				error "canvasCAD::dimension::radius -> Error:  could not get \$w" 
			}
			
        # -------------------------------
				# correct in case of {} parameters ... execution through canvasCAD::dimension
			if {$textOffset == {}} { set textOffset 0		}
			if {$colour 	== {}} { set colour 	black	}

        # -------------------------------
				# reset item container
			set tagListName [format "dimGroup_%s" [llength [$w find withtag all]] ]
			$w dtag  $tagListName all

		# -------------------------------
				# set helpline parameters
			set p_hl_dim_p0  	$p0
			set p_hl_dim_p1  	[ vectormath::rotatePoint  	$p0		$p1  $dimDistAngle ]
			set textAngle		[ vectormath::dirAngle 		$p0 	$p_hl_dim_p1] 
			set textPosAngle	[ expr $textAngle - 90 ]
			set dimLength		[ vectormath::length 		$p0 	$p1]

		# -------------------------------
				# text position
			set textPosition	[ vectormath::center  		$p_hl_dim_p0  $p_hl_dim_p1 ]  
			set textPosition	[ vectormath::rotateLine  	$textPosition  [expr $textOffset / $stageScale] $textAngle ]
			
			#  ---------------------------------------------
				# create text
			set myText [ create_Text   $canvasDOMNode  $dimLength  {}  $textPosition  $textPosAngle  $colour ]
				$w addtag $tagListName withtag $myText

			# -------------------------------
				# dimension line ends
			if { $dimLength > $checkLength } {
					set myEnd [ create_LineEnd  $canvasDOMNode  $p_hl_dim_p1  $textAngle  $colour  {outside} ]
						$w addtag $tagListName withtag $myEnd
			} else {
					set myEnd [ create_LineEnd  $canvasDOMNode  $p_hl_dim_p1  $textAngle  $colour ]
						$w addtag $tagListName withtag $myEnd
			}

		# -------------------------------
				# line extension on offset 
			if { $textOffset != 0 } {
				set extLength		[ expr 1.5 * $fontSize / $stageScale]
				set offsetAngle		$textAngle 
				set refLength 		[ expr $dimLength/2 ]
				set lineCenter 		[ vectormath::center 	 $p_hl_dim_p0 $p_hl_dim_p1 ]
				set offsetPoint 	[ vectormath::rotateLine  $lineCenter	[expr  $textOffset / $stageScale]	$offsetAngle ]
				set offsetPoint_0 	[ vectormath::rotateLine  $offsetPoint	$extLength	[expr 180 + $offsetAngle ] ]
				set offsetPoint_1 	[ vectormath::rotateLine  $offsetPoint	$extLength  			$offsetAngle ]
				
				set offsetLength_0	[vectormath::length $lineCenter $offsetPoint_0]
				set offsetLength_1	[vectormath::length $lineCenter $offsetPoint_1]
				
				if { $offsetLength_0 > $offsetLength_1 } {
						if { $offsetLength_0 > $refLength } { 
									# puts " 		$offsetLength_0 > $offsetLength_1"
									# puts "   		$offsetLength_0"
									# puts "   		$refLength"
								set p_hl_dim_p0	$offsetPoint_0 
						} 
				} else {
						if { $offsetLength_1 > $refLength } { 
									# puts " 		$offsetLength_0 < $offsetLength_1"
									# puts "   		$offsetLength_1"
									# puts "   		$refLength"
								set p_hl_dim_p1	$offsetPoint_1 
						} 
				}
				# --- debug in graphic
						# set myOffSet 	[ vectormath::rotateLine  $lineCenter	$textOffset		$offsetAngle ]						 
					if { 0 == 1} {
							set myBase 		[ create_Point  $canvasDOMNode  $textPosition  1  darkgray]
								$w addtag $tagListName withtag $myBase
							set myBase 		[ create_Point  $canvasDOMNode  $offsetPoint  1  orange]
								$w addtag $tagListName withtag $myBase
							set myBase 		[ create_Point  $canvasDOMNode  $p_hl_dim_p0  1  red]
								$w addtag $tagListName withtag $myBase
							set myBase 		[ create_Point  $canvasDOMNode  $p_hl_dim_p1  1  blue]
								$w addtag $tagListName withtag $myBase
							set myBase 		[ create_Point  $canvasDOMNode  $offsetPoint_0  1  gray80]
								$w addtag $tagListName withtag $myBase
							set myBase 		[ create_Point  $canvasDOMNode  $offsetPoint_1  1  gray50]
								$w addtag $tagListName withtag $myBase
					}
			}
			
		# -------------------------------
				# dimension line
			set myLine [ create_Line  $canvasDOMNode  $p_hl_dim_p0  $p_hl_dim_p1  $colour ]
				$w addtag $tagListName withtag $myLine
							
		# -------------------------------
				# helpline arc
			set angle_p1    [ vectormath::dirAngle 	$p0 $p1 ]			
			set arcAngle	[ vectormath::angle 	$p_hl_dim_p1 $p0 $p1 ]
			set angle_p1_h  [ expr $angle_p1 + $arcAngle ]
			set arcRadius	$dimLength		

				# gap to helpline 
			set asinParameter	[ expr 2.0 / ($stageScale * $arcRadius) ]
			set gapAngle 		[ expr asin($asinParameter) * 180 / $vectormath::CONST_PI ]
			
			if { $dimDistAngle > 0 } { 
					set angle_p1 	[ expr $angle_p1 + $gapAngle ]
			} else {
					set angle_p1 	[ expr $angle_p1 - $arcAngle ]
					set arcAngle 	[ expr $arcAngle - $gapAngle ]
			}

			if { [expr $angle_p1_h - $angle_p1 ] > 360 } {
							# puts "    $checkValue "
						set myArc [ create_Arc  $canvasDOMNode  $p0  $arcRadius  0 359.999  $colour ]
							$w addtag $tagListName withtag $myArc 
			} else {
					if { $arcAngle > 0.5 } { # check for clean vizualisation of arc
							if { [expr $angle_p1 + $dimDistAngle] < 360} {
									# puts "    $checkValue  $dimDistAngle"
								set myArc [ create_Arc  $canvasDOMNode  $p0  $arcRadius  $angle_p1  $arcAngle  $colour]
									$w addtag $tagListName withtag $myArc 
							} else {
									# puts "    $checkValue  $dimDistAngle"
								set myArc [ create_Arc  $canvasDOMNode  $p0  $arcRadius  $angle_p1  $arcAngle  $colour]
									$w addtag $tagListName withtag $myArc 
								set myArc [ create_Arc  $canvasDOMNode  $p0  $arcRadius  0  		[expr $angle_p1 + $arcAngle - 360 ]  $colour ]
									$w addtag $tagListName withtag $myArc 
							}
					} else { 
						#puts "   -> break" 
					}
			}

		#  ---------------------------------------------
				#  sum up and return
					# $w addtag $tagListName withtag $myBase
					# $w addtag $tagListName withtag $myHelp
					# $w addtag $tagListName withtag $myPos
					# $w move {myArc} 30 0

		return $tagListName
	}
		#-------------------------------------------------------------------------
           #  
           #
	proc length { canvasDOMNode  p_Coords  dimOrientation dimDistance {textOffset 0} {colour black}} {
        
					#set cv_ObjectName [$canvasDOMNode getAttribute id]
					#set cv_Object 	[ canvasCAD::getValue $cv_ObjectName ]

				
			set w			[ canvasCAD::getNodeAttribute  $canvasDOMNode	Canvas path		]			
			set fontSize 	[ canvasCAD::getNodeAttribute  $canvasDOMNode  	Style  fontsize ]
			set stageScale 	[ canvasCAD::getNodeAttribute  $canvasDOMNode   Stage  scale ]			
					# set stageUnit 	[ canvasCAD::dict_getValue  $cv_Config     unit 		]			
					# set unitScale	[ canvasCAD::get_unitRefScale $stageUnit ]
					
				
		
			set checkLength	[ expr (1 + 2 * $fontSize) / $stageScale]

		# -------------------------------
				# ceck $w
			if { $w == {} } { 
				error "canvasCAD::dimension::length -> Error:  could not get \$w" 
			}
			
		# -------------------------------
				# correct in case of {} parameters ... execution through canvasCAD::dimension
			if {$textOffset == {}} { set textOffset 0		}
			if {$colour 	== {}} { set colour 	black	}
			
			set textOffset [expr $textOffset / $stageScale]

		# -------------------------------
				# reset item container
			set tagListName [format "dimGroup_%s" [llength [$w find withtag all]] ]
			$w dtag  $tagListName all
			
		# -------------------------------
				# set type exceptions
			switch $dimOrientation {
			
				aligned    {
						set p1    		[ list [lindex $p_Coords 0] [lindex $p_Coords 1] ]
						set p2    		[ list [lindex $p_Coords 2] [lindex $p_Coords 3] ]
						set p_start		$p1
						set p_end		$p2
					}   
				horizontal {
						set p1    		[ list [lindex $p_Coords 0] [lindex $p_Coords 1] ]
						set p2    		[ list [lindex $p_Coords 2] [lindex $p_Coords 3] ]
						set p_start		$p1
						set p_end		[ list [lindex $p2 0] [lindex $p1 1] ]
					}                   
				vertical   {
						set p1    		[ list [lindex $p_Coords 0] [lindex $p_Coords 1] ]
						set p2    		[ list [lindex $p_Coords 2] [lindex $p_Coords 3] ]
						set p_start		$p1
						set p_end		[ list [lindex $p1 0] [lindex $p2 1] ]
					}                   					   
				perpendicular    { # dimension line through p0 & p1 perpendicular through p2 , p0 as direction ref
						set p0    		[ list [lindex $p_Coords 0] [lindex $p_Coords 1] ]
						set p1    		[ list [lindex $p_Coords 2] [lindex $p_Coords 3] ]
						set p2    		[ list [lindex $p_Coords 4] [lindex $p_Coords 5] ]
						set p_start		$p1
						set p_isect		[ vectormath::intersectPerp	$p0 $p1 $p2 ]
						set p1_aln_vct	[ vectormath::subVector		$p1 $p_isect ]
						set p_end		[ vectormath::addVector		$p2 $p1_aln_vct ]
                        set perpAngle   [ vectormath::dirAngle_Coincidence $p_start $p_end  0.0001 $p0 ] 
                        set dimPerp     [ vectormath::length 	  $p_start $p_end]
                        set dimDir      [ vectormath::VRotate 	  $p1_aln_vct 90]
					}                  
			}
			
		# -------------------------------
				# set helpline parameters
			set dimDistance     [ expr $dimDistance / $stageScale ]
			set textAngle		[ vectormath::dirAngle    $p_start $p_end]
            if {$dimOrientation == {perpendicular}} {
                set textAngle   $perpAngle
            }
			set textPosAngle	[ expr $textAngle - 90]
			set dimLength		[ vectormath::length 	  $p_start $p_end]
			set p_hl_dim_p1  	[ vectormath::rotateLine  $p_start	$dimDistance  $textPosAngle ]
			set p_hl_dim_p2  	[ vectormath::rotateLine  $p_end	$dimDistance  $textPosAngle ]

		# -------------------------------
				# define start position of helplines, in case of p_hl_dim_p? orientation
			set p_hl_p1  	 	[ vectormath::addVector   $p_start	[ vectormath::unifyVector $p_start 	$p_hl_dim_p1 ] [expr 2/$stageScale] ]
			set p_hl_p2  	 	[ vectormath::addVector   $p2		[ vectormath::unifyVector $p2		$p_hl_dim_p2 ] [expr 2/$stageScale] ]

		# -------------------------------
				# text position
			set textPosition	[ vectormath::center      $p_hl_dim_p1  $p_hl_dim_p2 ]  
			set textPosition	[ vectormath::rotateLine  $textPosition  $textOffset  [expr 180 + $textAngle ] ]
				# set textPosition	[ vectormath::rotateLine  $textPosition  [expr $textOffset/$stageScale]  [expr 180 + $textAngle ] ]
			
		#  ---------------------------------------------
				# create text
			set myText [ create_Text   $canvasDOMNode  $dimLength  {}  $textPosition  $textPosAngle  $colour ]
				$w addtag $tagListName withtag $myText

		# -------------------------------
				# first debug
					# puts "  dimension::length     $p1  $p2  $textAngle  $textPosAngle  $textOffset  $colour "
			
		# -------------------------------
				# dimension help lines
				# create_Line { w cv_Config cv_Dimension p1 p2 }
			set myLine [ create_Line  $canvasDOMNode  $p_hl_p1  $p_hl_dim_p1  $colour ]
				$w addtag $tagListName withtag $myLine
			set myLine [ create_Line  $canvasDOMNode  $p_hl_p2  $p_hl_dim_p2  $colour ]
				$w addtag $tagListName withtag $myLine 
			
		# -------------------------------
				# dimension line ends
			if { $dimLength > $checkLength } {
					set myEnd [ create_LineEnd  $canvasDOMNode  $p_hl_dim_p1  $textAngle  $colour ]
						$w addtag $tagListName withtag $myEnd
					set myEnd [ create_LineEnd  $canvasDOMNode  $p_hl_dim_p2  [expr 180 + $textAngle]  $colour ]
						$w addtag $tagListName withtag $myEnd
			} else {
					set myEnd [ create_LineEnd  $canvasDOMNode  $p_hl_dim_p1  $textAngle  $colour  {outside}  ]
						$w addtag $tagListName withtag $myEnd
					set myEnd [ create_LineEnd  $canvasDOMNode  $p_hl_dim_p2  [expr 180 + $textAngle]  $colour  {outside} ]
						$w addtag $tagListName withtag $myEnd
			}
			
        # -------------------------------
				# line extension on offset 
			if { $textOffset != 0 } {
				set extLength		[ expr 1.5 * $fontSize / $stageScale]
				set offsetAngle		[ expr 180 + $textAngle ] 
				set offsetLength_1 	[ expr $extLength + $textOffset]
				set offsetLength_2 	[ expr $extLength - $textOffset]
				set refLength 		[ expr $dimLength/2 ]
				set lineCenter 		[ vectormath::center 	 $p_hl_dim_p1 $p_hl_dim_p2 ]
					# puts "     -> refLength  		$refLength"
					# puts "     -> offsetLength_1  	$offsetLength_1"
					# puts "     -> offsetLength_2  	$offsetLength_2"

				set offsetPoint 	[ vectormath::rotateLine  $lineCenter	$textOffset		$offsetAngle ]
				set offsetPoint_1 	[ vectormath::rotateLine  $offsetPoint	$extLength		$offsetAngle ]
				set offsetPoint_2 	[ vectormath::rotateLine  $offsetPoint	$extLength		[expr 180 + $offsetAngle] ]
				if { $textOffset > 0 } {
					if { [expr abs($offsetLength_1)] > $refLength } { set p_hl_dim_p1	$offsetPoint_1 }
				} else {
					if { [expr abs($offsetLength_2)] > $refLength } { set p_hl_dim_p2	$offsetPoint_2 }
				}
				# --- debug in graphic
						# set myOffSet 	[ vectormath::rotateLine  $lineCenter	$textOffset		$offsetAngle ]
					# set myBase 		[ create_Point  $w  $cv_Config  $cv_Dimension  $offsetPoint  1  orange]
					# 	$w addtag $tagListName withtag $myBase
					# set myBase 		[ create_Point  $w  $cv_Config  $cv_Dimension  $p_hl_dim_p1  1  red]
					# 	$w addtag $tagListName withtag $myBase
					# set myBase 		[ create_Point  $w  $cv_Config  $cv_Dimension  $p_hl_dim_p2  1  blue]
					# 	$w addtag $tagListName withtag $myBase
			}
						
		# -------------------------------
				# dimension line
			set myLine [ create_Line  $canvasDOMNode  $p_hl_dim_p1  $p_hl_dim_p2  $colour ]
				$w addtag $tagListName withtag $myLine

		#  ---------------------------------------------
				#  sum up and return
			
			# $w addtag $tagListName withtag $myBase
			# $w addtag $tagListName withtag $myHelp
			# $w addtag $tagListName withtag $myPos
			# $w move {myArc} 30 0

		return $tagListName
	}
	
}      
