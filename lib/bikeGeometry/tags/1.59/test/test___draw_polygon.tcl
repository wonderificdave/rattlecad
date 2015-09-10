  package require Tk

  proc polydraw {w} {
    #-- add bindings for drawing/editing polygons to a canvas
    bind $w <Button-1>        {polydraw'mark   %W %x %y}
    bind $w <Double-1>        {polydraw'insert %W}
    bind $w <B1-Motion>       {polydraw'move   %W %x %y}
    bind $w <Shift-B1-Motion> {polydraw'move   %W %x %y 1}
    bind $w <Button-2>        {polydraw'rotate %W  0.1}
    bind $w <Shift-2>         {polydraw'rotate %W -0.1}
    bind $w <Button-3>        {polydraw'delete %W}
    bind $w <Shift-3>         {polydraw'delete %W 1}
    interp alias {} tags$w {} $w itemcget current -tags
  }
  proc polydraw'add {w x y} {
    #-- start or extend a line, turn it into a polygon if closed
    global polydraw
    if {![info exists polydraw(item$w)]} {
        set coords [list [expr {$x-1}] [expr {$y-1}] $x $y]
        set polydraw(item$w) [$w create line $coords -fill red -tag poly0]
    } else {
        set item $polydraw(item$w)
        foreach {x0 y0} [$w coords $item] break
        if {hypot($x-$x0,$y-$y0) < 5} {
            set coo [lrange [$w coords $item] 2 end]
            $w delete $item
            unset polydraw(item$w)
            set new [$w create poly $coo -fill {} -tag poly -outline black]
            polydraw'markNodes $w $new
        } else {
            $w coords $item [concat [$w coords $item] $x $y]
        }
    }
  }
  proc polydraw'delete {w {all 0}} {
    #-- delete a node of, or a whole polygon
    set tags [tags$w]
    if {[regexp {of:([^ ]+)} $tags -> poly]} {
        if {$all} {
            $w delete $poly of:$poly
        } else {
            regexp {at:([^ ]+)} $tags -> pos
            $w coords $poly [lreplace [$w coords $poly] $pos [incr pos]]
            polydraw'markNodes $w $poly
        }
    }
    $w delete poly0 ;# possibly clean up unfinished polygon
    catch {unset ::polydraw(item$w)}
  }
  proc polydraw'insert {w} {
    #-- create a new node halfway to the previous node
    set tags [tags$w]
    if {[has $tags node]} {
        regexp {of:([^ ]+)} $tags -> poly
        regexp {at:([^ ]+)} $tags -> pos
        set coords [$w coords $poly]
        set pos2 [expr {$pos==0? [llength $coords]-2 : $pos-2}]
        foreach {x0 y0} [lrange $coords $pos end] break
        foreach {x1 y1} [lrange $coords $pos2 end] break
        set x [expr {($x0 + $x1) / 2}]
        set y [expr {($y0 + $y1) / 2}]
        $w coords $poly [linsert $coords $pos $x $y]
        polydraw'markNodes $w $poly
    }
  }
  proc polydraw'mark {w x y} {
    #-- extend a line, or prepare a node for moving
    set x [$w canvasx $x]; set y [$w canvasy $y]
    catch {unset ::polydraw(current$w)}
    if {[has [tags$w] node]} {
        set ::polydraw(current$w) [$w find withtag current]
        set ::polydraw(x$w)       $x
        set ::polydraw(y$w)       $y
    } else {
        polydraw'add $w $x $y
    }
  }
  proc polydraw'markNodes {w item} {
    #-- decorate a polygon with square marks at its nodes
    $w delete of:$item
    set pos 0
    foreach {x y} [$w coords $item] {
        set coo [list [expr $x-2] [expr $y-2] [expr $x+2] [expr $y+2]]
        $w create rect $coo -fill blue -tag "node of:$item at:$pos"
        incr pos 2
    }
  }
  proc polydraw'move {w x y {all 0}} {
    #-- move a node of, or a whole polygon
    set x [$w canvasx $x]; set y [$w canvasy $y]
    if {[info exists ::polydraw(current$w)]} {
        set dx [expr {$x - $::polydraw(x$w)}]
        set dy [expr {$y - $::polydraw(y$w)}]
        set ::polydraw(x$w) $x
        set ::polydraw(y$w) $y
        if {!$all} {
            polydraw'redraw $w $dx $dy
            $w move $::polydraw(current$w) $dx $dy
        } elseif [regexp {of:([^ ]+)} [tags$w] -> poly] {
            $w move $poly    $dx $dy
            $w move of:$poly $dx $dy
        }
    }
  }
  proc polydraw'redraw {w dx dy} {
    #-- update a polygon when one node was moved
    set tags [tags$w]
    if [regexp {of:([^ ]+)} $tags -> poly] {
        regexp {at:([^ ]+)} $tags -> from
        set coords [$w coords $poly]
        set to [expr {$from + 1}]
        set x [expr {[lindex $coords $from] + $dx}]
        set y [expr {[lindex $coords $to]   + $dy}]
        $w coords $poly [lreplace $coords $from $to $x $y]
    }
  }
  proc polydraw'rotate {w angle} {
    if [regexp {of:([^ ]+)} [tags$w] -> item] {
        canvas'rotate      $w $item $angle
        polydraw'markNodes $w $item
    }
  }
  #--------------------------------------- more general routines
  proc canvas'center {w item} {
    foreach {x0 y0 x1 y1} [$w bbox $item] break
    list [expr {($x0 + $x1) / 2.}] [expr {($y0 + $y1) / 2.}]
  }
  proc canvas'rotate {w item angle} {
    # This little code took me hours... but the Welch book saved me!
    foreach {xm ym} [canvas'center $w $item] break
    set coords {}
    foreach {x y} [$w coords $item] {
        set rad [expr {hypot($x-$xm, $y-$ym)}]
        set th  [expr {atan2($y-$ym, $x-$xm)}]
        lappend coords [expr {$xm + $rad * cos($th - $angle)}]
        lappend coords [expr {$ym + $rad * sin($th - $angle)}]
    }
    $w coords $item $coords
  }
  proc has {list element} {expr {[lsearch $list $element]>=0}}

if 0 {
 #------------------------------------------------ demo and test code...

  if {[file tail [info script]]==[file tail $argv0]} {
    pack [canvas .c] [canvas .d -bg white] -fill both -expand 1
    polydraw .c; polydraw .d             ;# test: are they independent?
    bind . <Escape> {exec wish $argv0 &; exit}         ;# quick restart
    bind . ? {console show}          ;# little (? BIG) debugging helper
  }
}

if 1 {
 #------------------------------------------------ Application2 - Outlining:

  proc help {w} {
  #: Show usage info
    set msg "Help:\n"
    append msg "Left-click : Create point. To close polygon, click on first point.\n"
    append msg "Drag blue marks to edit polygon.\n"
    append msg "Double-click on mark: insert new mark in adjacent line.\n"
    append msg "Shift / Right-click : Delete mark/line/polygon\n"
    append msg "Shift / Middle-click on mark: Rotate polygon\n"
    append msg "F1: Show console\n"
    append msg "F3: Load Picture      \t F4: Delete Picture\n"
    append msg "F5: Show User-polygon \t F6: Delete User-polygon\n"
    $w insert end "$msg\n"
  }

  proc ReadPic {w fn} {
  #: Read imagefile, put image on canvas
    if { $fn == "" } {
        set fn [tk_getOpenFile  -filetypes {{{GIF Files} {*.gif}} {{All Files} {*.*}}}]
        if { $fn == "" } {return}
    }
    set width  [winfo reqwidth  $w]
    set height [winfo reqheight $w]
    set x [expr { $width  / 2 }]
    set y [expr { $height / 2 }]
    catch {image delete $img1}
    set img1 [image create photo -file $fn]
    $w create image $x $y -image $img1 -tag "img"
  }

  proc ShowPoly {w} {
  #: !! Paste user-made polygon here: !!
    $w create poly \
      117.0 206.0 117.0 60.0 264.0 60.0 264.0 206.0 \
     -fill {} -tag user -outline blue
  }
  
  
  




  proc DrawContent {} {
      set cv    .c
      set text  .t_xy
      $cv delete all
      
      set list_xy [$text get 1.0 end]
      set list_xy [string map {\{ {} \} {}} $list_xy] 
      puts "\n ... new"
      puts "   $list_xy"
      $cv create line \
          $list_xy \
          -tag user -fill blue
  }
  
  proc FitAll    {} {
    
            set cv .c
			set w			$cv
            set tagList     all

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
			puts "  -> $cb_x1 $cb_y1  $cb_x2 $cb_y2"
            
			puts "\n  --- Content ---"
            set contentWidth	[expr $cb_x2 - $cb_x1]
			set contentHeight	[expr $cb_y2 - $cb_y1]
			puts "  -> $contentWidth"  
            puts "  -> $contentHeight"
            set contentCenter_x   [expr ($cb_x2 + $cb_x1) / 2]
            set contentCenter_y   [expr ($cb_y2 + $cb_y1) / 2]
            puts "  -> $contentCenter_x"  
            puts "  -> $contentCenter_y"
            
            puts "\n  --- Stage ---"
            set stageWidth  [$w cget -width]
            set stageHeight [$w cget -height]
            puts "  -> $stageWidth"  
            puts "  -> $stageHeight"
            set stageCenter_x   [expr ($stageWidth) / 2]
            set stageCenter_y   [expr ($stageHeight) / 2]
            puts "  -> $stageCenter_x"  
            puts "  -> $stageCenter_y"
            
            puts "\n  --- center ---"
            set move_x  [expr $stageCenter_x - $contentCenter_x]
            set move_y  [expr $stageCenter_y - $contentCenter_y]
            puts "  -> $move_x"  
            puts "  -> $move_y"
            
            $w move all $move_x $move_y
            
            return
            
			foreach {sb_x1 sb_y1  sb_x2 sb_y2} [list  0 0 $stageWidth $stageHeight] break
			set stage_bb   [ list $sb_x1 $sb_y1  $sb_x2 $sb_y2 ]
				# puts "  -> $sb_x1 $sb_y1  $sb_x2 $sb_y2"
			set stage_width		[expr $sb_x2 - $sb_x1]
			set stage_height	[expr $sb_y2 - $sb_y1]
			
            puts "  ... $stage_width"
            puts "  ... $stage_height"
            
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
			
			#centerContent $cv_ObjectName {0 0} $tagList
				 
 } 
  
  
  proc ClearAll {} {
      set cv    .c
      set text  .t_xy
      $cv delete all
      $text delete 1.0 end
  }

  

  #: Main :
  pack [canvas .c    -width 620 -height 620 -bg white] -fill both -expand 1 
  pack [text   .t_xy -width  80 -height   9]
  pack [frame  .f_bt]
  set bt_update [button .f_bt.bt   -text "    update    "  -command { DrawContent }]
  set bt_fit    [button .f_bt.ft   -text "      fit     "  -command { FitAll }]
  set bt_clear  [button .f_bt.cl   -text "     clear    "  -command { ClearAll }]
  pack $bt_update $bt_fit $bt_clear -side left -padx 15
  pack [text   .t    -width  80 -height   9]
  
  polydraw .c
  help     .t

  bind .  <F3> { ReadPic .c "" }
  bind .  <F4> { .c delete img }
  bind .  <F5> { ShowPoly .c }
  bind .  <F6> { .c delete user }

  bind .  <Escape> {exec wish $argv0 &; exit}  ;# quick restart
  bind .  <F1>     {console show}              ;# debugging helper
  puts "Try:"
  puts "puts \[.c find withtag poly]"
  puts "puts \[.c coords \[.c find withtag poly] ]"
  puts "foreach p \[.c find withtag poly] \{puts \"\$p: \[.c coords \$p ]\\n\"\}"

  proc int x  { expr int($x) }
  bind .c <Motion> {wm title . [int [%W canvasx %x]],[int [%W canvasy %y]]}

 #ReadPic  .c "mypic.gif"
 #ShowPoly .c
  focus -force .
}