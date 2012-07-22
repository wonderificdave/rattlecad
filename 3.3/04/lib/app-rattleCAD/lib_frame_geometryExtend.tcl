 ##+##########################################################################
 #
 # package: rattleCAD   ->  lib_frame_geometry.tcl
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
 #  namespace:  rattleCAD::frame_geometry
 # ---------------------------------------------------------------------------
 #
 #


 namespace eval frame_geometry_extend {
        # package require tdom

            #-------------------------------------------------------------------------
                #  current Project Values

            #-------------------------------------------------------------------------
                #  store createEdit-widgets position
            variable _drag
                    array set _drag {}
            #-------------------------------------------------------------------------


    namespace export *



     #-------------------------------------------------------------------------
        #  add vector to list of coordinates
     proc coords_addVector {coordlist vector} {
            set returnList {}
            set vector_x [lindex $vector 0]
            set vector_y [lindex $vector 1]
            foreach {x y} $coordlist {
                set new_x [expr $x + $vector_x]
                set new_y [expr $y + $vector_y]
                set returnList [lappend returnList $new_x $new_y]
            }
                # puts " .... frame_geometry::coords_addVector"
            return $returnList
    }

     #-------------------------------------------------------------------------
        #  close ProjectEdit Widget
    proc closeEdit {cv cvEdit} {
            $cv delete $cvEdit
            destroy $cvEdit
            catch [ destroy .__select_box ]
    }

     #-------------------------------------------------------------------------
        #  binding: dragStart
    proc dragStart {x y} {
            variable _drag
            set [namespace current]::_drag(lastx) $x
            set [namespace current]::_drag(lasty) $y
            puts "$x $y"
    }

     #-------------------------------------------------------------------------
        #  binding: drag
    proc drag {x y cv id} {
            variable _drag
            set dx [expr {$x - $_drag(lastx)}]
            set dy [expr {$y - $_drag(lasty)}]
            set cv_width  [ winfo width  $cv ]
            set cv_height [ winfo height $cv ]
            set id_bbox   [ $cv bbox $id ]
            if {[lindex $id_bbox 0] < 4} {set dx  1}
            if {[lindex $id_bbox 1] < 4} {set dy  1}
            if {[lindex $id_bbox 2] > [expr $cv_width  -4]} {set dx -1}
            if {[lindex $id_bbox 3] > [expr $cv_height -4]} {set dy -1}

            $cv move $id $dx $dy
            set _drag(lastx) $x
            set _drag(lasty) $y
    }

     #-------------------------------------------------------------------------
        #  create createSelectBox

    proc bind_parent_move {toplevel_widget parent} {
            if {![winfo exists $toplevel_widget]} return
            set toplevel_x    [winfo rootx $parent]
            set toplevel_y    [expr [winfo rooty $parent]+ [winfo reqheight $parent]]
            wm  geometry      $toplevel_widget +$toplevel_x+$toplevel_y
            wm  deiconify     $toplevel_widget
    }

     #-------------------------------------------------------------------------
        #  return project attributes
    proc project_attribute {attribute } {
            variable Project
            return $Project($attribute)
    }

     #-------------------------------------------------------------------------
        #  add vector to list of coordinates
     proc coords_flip_y {coordlist} {
            set returnList {}
            foreach {x y} $coordlist {
                set new_y [expr -$y]
                set returnList [lappend returnList $x $new_y]
            }
            return $returnList
    }

     #-------------------------------------------------------------------------
        #  get xy in a flat list of coordinates, start with    0, 1, 2, 3, ...
     proc coords_get_xy {coordlist index} {
            if {$index == {end}} {
                set index_y [expr [llength $coordlist] -1]
                set index_x [expr [llength $coordlist] -2]
            } else {
                set index_x [ expr 2 * $index ]
                set index_y [ expr $index_x + 1 ]
                if {$index_y > [llength $coordlist]} { return {0 0} }
            }
            return [list [lindex $coordlist $index_x] [lindex $coordlist $index_y] ]
    }

 }

