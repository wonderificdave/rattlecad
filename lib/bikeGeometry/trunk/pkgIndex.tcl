# Tcl package index file, version 1.1
# This file is generated by the "pkg_mkIndex" command
# and sourced either when an application starts up or
# by a "package unknown" script.  It invokes the
# "package ifneeded" command to set up package-related
# information so that packages will be loaded automatically
# in response to "package require" commands.  When this
# script is sourced, the variable $dir must contain the
# full path name of this file's directory.

package ifneeded bikeGeometry  0.56 "\
            [list source [file join $dir lib project.tcl]]; \
            [list source [file join $dir lib lib_projectUpdate.tcl]]; \
            [list source [file join $dir lib bikeGeometry.tcl]]; \
            [list source [file join $dir lib lib_bikeGeometryBase.tcl]]; \
            [list source [file join $dir lib lib_bikeGeometryExt.tcl]]; \
            [list source [file join $dir lib lib_tube.tcl]]; \
        "
#             [list source [file join $dir lib fruit.tcl]]; 