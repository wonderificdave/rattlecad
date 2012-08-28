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

     #-------------------------------------------------------------------------
        #  current Project Values

    namespace export *

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

