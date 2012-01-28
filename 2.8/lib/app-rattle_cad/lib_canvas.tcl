# -----------------------------------------------------------------------------------
#
#: Functions : namespace      C A N V A S   P r o c e d u r e s
#
#          wiki.tcl.tk     4844
#
#
 namespace eval lib_canvas {
   
   
   variable  ZOOM_Scale       1.0
   variable  CANVAS_Point     
   
   array set CANVAS_Point { x0 0
                            y0 0
                            x1 0
                            y1 0 
                          }
   
   
   #-------------------------------------------------------------------------
       #  create canvas
       #
   proc create { parent w x y {scr_bar yes} } {
        
        ::Debug  p  1

        if { $scr_bar == "yes" } {
              set cv [ canvas $parent.$w   -width $x -height $y  -bg white  -bd 2  -relief sunken \
                                        -xscrollcommand "$parent.shoriz set" \
                                        -yscrollcommand "$parent.svert  set" ]
     
              scrollbar $parent.svert   -orient v -command "$cv yview"
              scrollbar $parent.shoriz  -orient h -command "$cv xview"
      
              grid $cv            -row 0 -column 0 -columnspan 3 -sticky news
              grid $parent.svert  -row 0 -column 3 -columnspan 1 -sticky ns
              grid $parent.shoriz -row 1 -column 0 -columnspan 3 -sticky ew
              grid columnconfigure $parent 0 -weight 1
              grid columnconfigure $parent 1 -weight 1
              grid columnconfigure $parent 2 -weight 1
              grid rowconfigure    $parent 0 -weight 1

        } else {
              canvas $parent.$w   -width  $x  -height $y  -bd 2  -bg white  -relief sunken 
              pack   $parent.$w   -fill both  -expand yes
        }
        
        # bind $parent.$w <Configure> {recenter_canvas $parent.$w }

        return $parent.$w
   }


   #-------------------------------------------------------------------------
       #  create mouse - move zoom bindings
       #
   proc mouse_bindings { w {zoom_cmd {}}} {
        
        ::Debug  p  1

        # Set up event bindings for zoom canvas:
        bind $w <3>               "lib_canvas::setMark    $w %x %y zoom"
        bind $w <B3-Motion>       "lib_canvas::setStroke  $w %x %y"
        bind $w <ButtonRelease-3> "lib_canvas::zoomArea   $w %x %y  $zoom_cmd"

        # Set up event bindings for move canvas:
        bind $w <1>               "lib_canvas::setMark    $w %x %y move"
        bind $w <B1-Motion>       "lib_canvas::setStroke  $w %x %y"
        bind $w <ButtonRelease-1> "lib_canvas::moveCanvas $w %x %y"
	
	#tk_messageBox -message "zoom_cmd $zoom_cmd"

   }

        
   #-------------------------------------------------------------------------
       #  delete item
       #
   proc delete_item {w geometry_id } {
        ::Debug  p  1
          # ::Debug  t "$w delete $geometry_id > 0"
          # ::Debug  t "$w delete $geometry_id > 1" 1
        catch [$w delete $geometry_id] err
   }


   #-------------------------------------------------------------------------
       #  clear canvas
       #
   proc delete_all { } {
        
        ::Debug  p  1

        set w [get_canvas_path current]
        
        variable FRAME_Reposition_BB 
        
        $w delete "all"
        set FRAME_Reposition_BB {}
   }

   
   #-------------------------------------------------------------------------
       #  canvas size
       #
   proc size { w } {
        ::Debug  p  1
        return  [list  [winfo width  $w]  [winfo height $w] ]
   }
   
   
   #-------------------------------------------------------------------------
       #  get rectangle size and center
       #
   proc get_rect_info { type rect } {

        ::Debug  p  1

        foreach {x0 y0 x1 y1} $rect  break
        switch $type {
               size    { return  "[ expr $x1 - $x0 ]  [ expr $y1 - $y0 ] "}
               center  { return  "[ expr ( $x1 - $x0 ) * 0.5 + $x0 ]  [ expr ( $y1 - $y0 ) * 0.5 + $y0 ] " }
               default { return }
        }
   }


   #-------------------------------------------------------------------------
       #  fit compute_scale
       #
   proc compute_scale { w {tag all} {border_x 0} {border_y 0} } {

        ::Debug  p 

        set coords_bbox   [ $w bbox $tag ] 
        if { [ llength $coords_bbox ] == 0 } {
                #tk_messageBox -message "     recenter  bbox: do hots wos"
                return
           }

        set w_size   [mathematic::VAdd  [size  $w]  [list $border_x $border_y] -2]
           ::Debug  t    "size    [size  $w]"
           ::Debug  t    "border  $border_x $border_y"
           ::Debug  t    "w_size  $w_size"
        
        set bb_size  [get_rect_info  size  $coords_bbox]
           ::Debug  t    "tag          $tag"
           ::Debug  t    "coords_bbox  $coords_bbox"
           ::Debug  t    "bb_size      $bb_size"
        
        
        
        set scale_x   [expr 1.0*[lindex $w_size 0]/[lindex $bb_size 0]]
        set scale_y   [expr 1.0*[lindex $w_size 1]/[lindex $bb_size 1]]
           ::Debug  t    "scale_x  $scale_x"
           ::Debug  t    "scale_y  $scale_y"
        
        if {$scale_x < $scale_y } {
            set scale $scale_x
        } else {
            set scale $scale_y
        }
        
           ::Debug  t    "scale  $scale"
        return $scale
        
   }


   #-------------------------------------------------------------------------
       #  recenter and scale canvas
       #
   proc recenter { w scale {tag all} } {
        
        ::Debug  p  1
        
       set bbox   [ $w bbox $tag ] 
       if {[llength $bbox] == 0 } { 
            return 
       } 
        
       set cv_size     [size  $w]
       set cv_center   [get_rect_info  center [list 0 0 [lindex $cv_size 0]  [lindex $cv_size 1] ] ]
           # set cv_center   [get_rect_info  center [list 0 0 [lrange  $cv_size  0 1] ] ]
       set bb_center   [get_rect_info  center $bbox]
       set bb_move     [mathematic::VSub  $cv_center  $bb_center  ] 


            # $w delete debug
            # lib_canvas::draw_circle $w $bb_center   25  debug  red  3


       $w move   all  [lindex $bb_move   0]  [lindex $bb_move   1]
       $w scale  all  [lindex $cv_center 0]  [lindex $cv_center 1]  $scale  $scale
       
       
           #  lib_canvas::draw_circle $w $cv_center   15  debug  blue  3
       
       
        ::Debug   t  "scale   $scale" 1              
   }
        

   #-------------------------------------------------------------------------
       #  create scale-move bbox
       #
   proc display_bbox { w  mode } {
       
        ::Debug  p  1

       delete_item   $w  ___bbox_display
       delete_item   $w  ___bbox_content
       
       if {$mode != "create" } return
       
       set cv_size    [size $w]
       set cv_bbox_0  {1 1}
       set cv_bbox_1  [mathematic::VSub $cv_size {1 1}]
       
       foreach {x0 y0} $cv_bbox_0 break
       foreach {x1 y1} $cv_bbox_1 break
       
       $w  create  rectangle  $x0 $y0 $x1 $y1  -outline white  -tag ___bbox_display  
       
       return
   }


   #-------------------------------------------------------------------------
       #  mirror content of canvas on middle of canvas heigth 
       #
   proc mirror { w {axis x} } {
        ::Debug  p  1
       switch $axis {
            x { $w scale all   0  [ expr [winfo height $w ] * 0.5 ]  1 -1 }
            y { $w scale all   [ expr [winfo width  $w ] * 0.5 ]  0  -1 1 }
       }
   }


   #-------------------------------------------------------------------------
       #  scale canvas
       #
   proc scale { w scale } {

        ::Debug  p  1
   
        $w scale all    [ expr [ winfo width  $w ] *0.5 ]  [ expr [ winfo height $w ] *0.5 ] \
                       $scale  $scale

        ::debug_out "scale canvas: [$w bbox all]" 1
        $w configure -scrollregion [$w bbox all]
   }


   #-------------------------------------------------------------------------
       #  draw circle
       #
   proc draw_circle { w p r {geometry_id debug} {colour black} {lw 1} {fill {bg}} } {
        
        ::Debug  p  1

        foreach {x y} $p break
        
        set fill_colour {}
        if {![string equal $fill {}]} {
            if {[string equal $fill {bg} ]} {
                 set fill_colour [$w cget -bg]
               } else {
                  set fill_colour $fill
               }
        }
        
        $w create oval  [expr  $x - $r]  [expr  $y - $r]  \
                        [expr  $x + $r]  [expr  $y + $r]  \
               -outline $colour \
               -width   $lw     \
               -tags    $geometry_id  \
               -fill    $fill_colour       
   }


   #-------------------------------------------------------------------------
       #  draw arc
       #
   proc draw_arc { w p r {geometry_id debug} {start -10} {extent 100} {colour black} {lw 1}} {
        
        ::Debug  p  1

        foreach {x y} $p break
        $w create arc   [expr  $x - $r]  [expr  $y - $r]  \
                        [expr  $x + $r]  [expr  $y + $r]  \
               -start  $start     \
               -extent $extent    \
               -style  arc        \
               -tags   $geometry_id  -outline $colour  -width $lw
   }


   #-------------------------------------------------------------------------
       #  a copy from wiki.tcl.tk/8595
       #
   proc rotate_item {w Ox Oy angle geometry_id } {

        ::Debug  p  1

        set OVAL_BBox ""
        set angle [expr {$angle * atan(1) * 4 / 180.0}] ;# Radians
       
        foreach id [$w find withtag $geometry_id ] {            ;# Do each component separately
           
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
       #  setMark
       #
       #  Mark the first (x,y) coordinate for moving/zooming.
       #
   proc setMark {c x y type} {
	variable  CANVAS_Point 

        ::Debug  p  1

	set CANVAS_Point(x0) [$c canvasx $x]
	set CANVAS_Point(y0) [$c canvasy $y]
	switch $type {
	    move { $c create line      $x $y $x $y -fill red       -tag _show_selection 
	           $c configure -cursor hand2
	         }
	    zoom { $c create rectangle $x $y $x $y -outline black  -tag _show_selection 
	           $c configure -cursor sizing
	         }
        }
   }


   #-------------------------------------------------------------------------
       #  setStroke
       #
       #  Mark the second (x,y) coordinate for moving/zooming.
       #
    proc setStroke {c x y} {
	variable  CANVAS_Point
	
        ::Debug  p  1

	set CANVAS_Point(x1) [$c canvasx $x]
	set CANVAS_Point(y1) [$c canvasy $y]
	$c coords _show_selection $CANVAS_Point(x0) $CANVAS_Point(y0) $CANVAS_Point(x1) $CANVAS_Point(y1) 
   }


   #-------------------------------------------------------------------------
       #  moveCanvas
       #
       #  move canvas content by selected by setMark and
       #  setStroke.
       #
   proc moveCanvas {c x y} {
	variable  CANVAS_Point

        ::Debug  p  1

	#--------------------------------------------------------
	#  Get the final coordinates.
	#  Remove area selection rectangle
	#--------------------------------------------------------
	set CANVAS_Point(x1) [$c canvasx $x]
	set CANVAS_Point(y1) [$c canvasy $y]
	$c delete _show_selection

	#--------------------------------------------------------
	#  Check for zero-size area
	#--------------------------------------------------------
	if {($CANVAS_Point(x0)==$CANVAS_Point(x1)) || ($CANVAS_Point(y0)==$CANVAS_Point(y1))} {
	    return
	}

	#--------------------------------------------------------
	#  Determine size of move
	#--------------------------------------------------------
	set movexlength [expr $CANVAS_Point(x1)-$CANVAS_Point(x0)]
	set moveylength [expr $CANVAS_Point(y1)-$CANVAS_Point(y0)]
	#--------------------------------------------------------
	#  move
	#--------------------------------------------------------
	$c move all $movexlength $moveylength

	#--------------------------------------------------------
	#  Change the scroll region one last time, to fit the
	#  items on the canvas.
	#--------------------------------------------------------
	$c configure -scrollregion [$c bbox all]
	$c configure -cursor {}
    }


   #-------------------------------------------------------------------------
       #  zoomArea
       #
       #  Zoom in to the area selected by setMark and
       #  setStroke.
       #
   proc zoomArea {c x y {command {}}} {
        variable  ZOOM_Scale 
        variable  CANVAS_Point

        ::Debug  p  1

	#--------------------------------------------------------
	#  Get the final coordinates.
	#  Remove area selection rectangle
	#--------------------------------------------------------
	set CANVAS_Point(x1) [$c canvasx $x]
	set CANVAS_Point(y1) [$c canvasy $y]

	#--------------------------------------------------------
	#  Check for zero-size area
	#--------------------------------------------------------
	if {($CANVAS_Point(x0)==$CANVAS_Point(x1)) || ($CANVAS_Point(y0)==$CANVAS_Point(y1))} {
	    return
	}

	#--------------------------------------------------------
	#  Determine size and center of selected area
	#--------------------------------------------------------
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
	#--------------------------------------------------------
	set winxlength [winfo width  $c]
	set winylength [winfo height $c]

	#--------------------------------------------------------
	#  Calculate scale factors, and choose smaller
	#--------------------------------------------------------
	set xscale [expr {$winxlength/$areaxlength}]
	set yscale [expr {$winylength/$areaylength}]
	if { $xscale > $yscale } {
	    set factor $yscale
	} else {
	    set factor $xscale
	}

	#--------------------------------------------------------
	#  Perform zoom operation
	#  Perform move center area to center canvas
	#--------------------------------------------------------
          # catch [ set bbox_display  [$c bbox ___bbox_display] ]
          # catch [ set bbox_content  [$c bbox ___bbox_content] ]
          #
          # if {[llength $bbox_display ] != 0} {
	  #     #--------------------------------------------------------
	  #     #  Perform get currentfactor
	  #     if {$command != {} } {
	  #        set current_scale [ eval [format "%s"  $command ] ]
	  #     } else {
	  #        set current_scale 1.0
	  #     }
	  #     #--------------------------------------------------------
	  #     #  getborder
          #     set bbox_display_size  [get_rect_info  size  $bbox_display]
          #     set bbox_content_size  [get_rect_info  size  $bbox_content]
          #     set border        [mathematic::VSub  $bbox_display_size  $bbox_content_size]          
          #     set border_x      [expr $current_scale*0.5*[lindex $border 0] ]
          #     set border_y      [expr $current_scale*0.5*[lindex $border 1] ]
	  #     
	  #     tk_messageBox -message " current_scale $current_scale  || $border_x  $border_y"
          # } else {
          #     set border_x      0
          #     set border_y      0
          # }
          #
          
           # set border_x      0
           # set border_y      0

           # lib_canvas::display_bbox       $c  delete 
        
	recenter $c $factor _show_selection
           # lib_canvas::display_bbox       $c  create  $border_x  $border_y 
	$c delete _show_selection

	#--------------------------------------------------------
	#  Perform return currentfactor
	if {$command != {} } {
	    eval [format "%s %f"  $command  $factor]
	}
	#--------------------------------------------------------
	#  Change the scroll region one last time, to fit the
	#  items on the canvas.
	#--------------------------------------------------------
	$c configure -scrollregion [$c bbox all]
	$c configure -cursor {}
    }



    
   #-------------------------------------------------------------------------
       #  move canvase to center of drawspace
       #
   proc recenter_canvas { w } {
        
        ::Debug  p  1

        set maxy [winfo height $w]
        ::Debug  t  "maxy   $maxy" 1
    	 # flip_canvas $w x    
	$w delete info
	$w create text 10 [expr {$maxy-10}] -anchor sw \
	    -text "do schaug amol" \
	    -font {Helvetica 12 bold} -tags info
    	 # flip_canvas $w x    
	   
   }


   #-------------------------------------------------------------------------
       #  get canvas center
       #
   proc __canvas_center { w } {

        ::Debug  p  1

        set cv_size     [size $w]
        set cv_center   [get_rect_info  center [list 0 0 [lindex $cv_size 0]  [lindex $cv_size 1] ] ]
        return $cv_center
        # tk_messageBox -message "     lib_canvas::recenter  cv_size $cv_size || cv_center $cv_center"
   }


 }