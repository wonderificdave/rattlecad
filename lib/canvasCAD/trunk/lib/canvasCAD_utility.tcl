
 ##+##########################################################################
 #
 # package: canvasCAD 	->	canvasCAD_utility.tcl
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
		#  get BottomLeft
		#
	proc canvasCAD::get_BottomLeft { w } {
			set StageCoords [$w coords {__Stage__}] 
			foreach {x1 y1 x2 y2} $StageCoords break
			set bottomLeft [list $x1 $y2]
			foreach {x y} $bottomLeft break
				#$w create oval  [expr $x-5] [expr $y-5] [expr $x+5] [expr $y+5] 
				# set myItem [ eval $w create oval  -2m -2m 2m 2m -fill red ]
				# $w move $myItem $x $y
			return [list $x $y]
	}
	
	
	#-------------------------------------------------------------------------
		#  get Size
		#
	proc canvasCAD::get_Size { w } {
			return  [list  [winfo width  $w]  [winfo height $w] ]
   }
	
	
	#-------------------------------------------------------------------------
		#  get StageCenter
		#
	proc canvasCAD::get_StageCenter { w } {
			set StageCoords [$w coords {__Stage__}] 
			foreach {x1 y1 x2 y2} $StageCoords break
			set x [expr ($x1 + $x2)/2]
			set y [expr ($y1 + $y2)/2]
			return [list $x $y]
	}
	
	
	#-------------------------------------------------------------------------
		#  get UnitReferenceScale
		#
	proc canvasCAD::get_unitRefScale { Unit } {
			variable canvasUnitScale
			switch $Unit {
					m	-
					c	-
					i	-
					p	{	return [ getNodeAttributeRoot /root/_package_/UnitScale $Unit ]
							}
				default { 	return 1 }
			}
	}
	
	
	#-------------------------------------------------------------------------
		#  update CoordinatesList
		#
	proc canvasCAD::convert_BottomLeft { Scale args } {
			# flip y-coordinate and add $Unit to each value
			
		set flatList [flatten_nestedList $args] ;# http://wiki.tcl.tk/440
		
		set CoordList {}			
		foreach {x y} $flatList {
			set y [expr - $y]
			lappend CoordList $x
			lappend CoordList $y			
		}
		
		set CoordListUnit {}			
		foreach value $CoordList {
			set value [expr $Scale * $value]
			if {$value != 0} {
				lappend CoordListUnit $value
			} else {
				lappend CoordListUnit $value
			}
		}
		return $CoordListUnit
	}
		
		
	#-------------------------------------------------------------------------
		# see  http://wiki.tcl.tk/440
		#
	proc canvasCAD::flatten_nestedList { args } {
			if {[llength $args] == 0 } { return ""}
			set flatList {}
			foreach e [eval concat $args] {
				foreach ee $e { lappend flatList $ee }
			}
				# tk_messageBox -message "flatten_nestedList:\n    $args  -/- [llength $args] \n $flatList  -/- [llength $flatList]"
			return $flatList
	}
	
		
	#-------------------------------------------------------------------------
		#  get rectangle size and center
		#
	proc canvasCAD::get_BBoxInfo { type rect } {
            foreach {x0 y0 x1 y1} $rect  break
			switch $type {
				   size    { return  "[ expr $x1 - $x0 ]  [ expr $y1 - $y0 ] "}
				   center  { return  "[ expr ( $x1 - $x0 ) * 0.5 + $x0 ]  [ expr ( $y1 - $y0 ) * 0.5 + $y0 ] " }
				   default { return }
			}
	}

	
	#-------------------------------------------------------------------------
		# see  http://wiki.tcl.tk/8595
		#
	proc canvasCAD::rotateItem {w tagOrId Ox Oy angle } {

			set OVAL_BBox ""
			set angle [expr {-1 * $angle * atan(1) * 4 / 180.0}] ;# Radians
		   
			foreach id [$w find withtag $tagOrId ] {            ;# Do each component separately
			   
				set xy {}
				foreach {x y} [$w coords $id] {            ;# rotates vector (Ox,Oy)->(x,y) by angle clockwise 
						  
					 if { [ string equal [ $w type $id ] "oval" ] } {
						   if { [llength $OVAL_BBox ] == 2 } { 
								 
								  set OVAL_BBox      [lappend OVAL_BBox $x $y ]
								  
								  set CENTER_OVAL_X  [ expr ( [ lindex $OVAL_BBox 0 ] + [ lindex $OVAL_BBox 2 ] ) / 2 ]  
								  set CENTER_OVAL_Y  [ expr ( [ lindex $OVAL_BBox 1 ] + [ lindex $OVAL_BBox 3 ] ) / 2 ]  
														
								  set OVAL_BBox_X    [ expr [ lindex $OVAL_BBox 2 ] - [ lindex $OVAL_BBox 0 ] ]
								  set OVAL_BBox_Y    [ expr [ lindex $OVAL_BBox 3 ] - [ lindex $OVAL_BBox 1 ] ]

								  
								  set x              [ expr {$CENTER_OVAL_X - $Ox} ]             ;# Shift to origin
								  set y              [ expr {$CENTER_OVAL_Y - $Oy} ]

								  set xx             [ expr {$x * cos($angle) - $y * sin($angle)} ] ;# Rotate
								  set yy             [ expr {$x * sin($angle) + $y * cos($angle)} ]
								  
								  set xx             [ expr {$xx + $Ox} ]           ;# Shift back
								  set yy             [ expr {$yy + $Oy} ]

								  set OVAL_BBox      ""
															 
								  lappend xy         [ expr $xx - $OVAL_BBox_X / 2 ] [ expr $yy - $OVAL_BBox_Y / 2 ]  \
													 [ expr $xx + $OVAL_BBox_X / 2 ] [ expr $yy + $OVAL_BBox_Y / 2 ] 

							  } else {
								  set OVAL_BBox [list $x $y ]
							  }
						   
						} else {

							   set x  [ expr {$x - $Ox} ]                            ;# Shift to origin
							   set y  [ expr {$y - $Oy} ]

							   set xx [ expr {$x * cos($angle) - $y * sin($angle)} ] ;# Rotate
							   set yy [ expr {$x * sin($angle) + $y * cos($angle)} ]

							   set xx [ expr {$xx + $Ox} ]                           ;# Shift back
							   set yy [ expr {$yy + $Oy} ]
							   
							   lappend xy $xx $yy
						} 
				  }
			   $w coords $id $xy
			}
	}
	
	#-------------------------------------------------------------------------
		#
	proc canvasCAD::getFormatSize {formatKey} {
			# return {1 2}
			# puts "  -> canvasCAD::getFormatSize $formatKey"
			set stageWidth		[getNodeAttributeRoot /root/_package_/DIN_Format/$formatKey width ]
			set stageHeight		[getNodeAttributeRoot /root/_package_/DIN_Format/$formatKey height]
			set stageUnit		[getNodeAttributeRoot /root/_package_/DIN_Format/$formatKey unit ]
			return [ list $stageWidth $stageHeight $stageUnit ]			
	}

