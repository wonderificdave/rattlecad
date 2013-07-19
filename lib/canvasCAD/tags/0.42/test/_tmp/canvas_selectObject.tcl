 # starts a selection rectangle
 #
 proc CanvasSelectStart {win x y} {
    global Canvas
    # create a rectangle at the origin:
    $win create rectangle $x $y $x $y -width 1 -tags selRect
    # remember origin:
    set Canvas(selX) $x
    set Canvas(selY) $y
 }

 # expands an existing selection rectangle
 #
 proc CanvasSelectExpand {win x y} {
    global Canvas
    # set the opposite corner of the selection rectangle
    # to the current cursor location:
    $win coords selRect $Canvas(selX) $Canvas(selY) $x $y
 }

 # finishes an existing selection rectangle
 # and does something with all items inside the selection
 #
 proc CanvasSelectEnd {win x y} {
    global Canvas
    # adjust selection rectangle to the current position:
    CanvasSelectExpand $win $x $y
    # find id of selection rectangle:
    set id [$win find withtag selRect]
    # and give it a gray outline:
    $win itemconfigure selRect -outline gray
    # now delete the tag for the next selections:
    $win dtag selRect
    # get the ids off all overlapping items:
    # (we could also get all 'enclosed' items or do other things here)
    set selection [$win find overlapping $Canvas(selX) $Canvas(selY) $x $y]
    # finally do something with all these items:
    # (Here, I just give them a red filling, if they are not the
    #  selection rectangle and if they know about -fill at all ...)
    foreach item $selection {
       set type [$win type $item]
       if {$item != $id && $type != "bitmap" && \
                           $type != "image" && \
                           $type != "window"} {
          $win itemconfigure $item -fill red
       }
    }
 }

 # build a simple canvas ...
 canvas .c -background white
 pack .c

 # ... and bind the procedures to the corresponding mouse actions:
 # - Pressing the left mouse button start a selection
 # - Dragging the mouse with mouse button pressed expands the selection
 # - Releasing the mouse button finishes the selection
 #
 bind .c <ButtonPress-1>   {CanvasSelectStart  %W %x %y}
 bind .c <B1-Motion>       {CanvasSelectExpand %W %x %y}
 bind .c <ButtonRelease-1> {CanvasSelectEnd    %W %x %y}