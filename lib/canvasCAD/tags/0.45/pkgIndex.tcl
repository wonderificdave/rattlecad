# Tcl package index file, version 1.1
# This file is generated by the "pkg_mkIndex" command
# and sourced either when an application starts up or
# by a "package unknown" script.  It invokes the
# "package ifneeded" command to set up package-related
# information so that packages will be loaded automatically
# in response to "package require" commands.  When this
# script is sourced, the variable $dir must contain the
# full path name of this file's directory.

package ifneeded canvasCAD  0.45 "\
            [list source [file join $dir lib canvasCAD.tcl]]; \
            [list source [file join $dir lib canvasCAD_tdom.tcl]]; \
            [list source [file join $dir lib canvasCAD_stage.tcl]]; \
            [list source [file join $dir lib canvasCAD_binding.tcl]]; \            
            [list source [file join $dir lib canvasCAD_utility.tcl]]; \
            [list source [file join $dir lib canvasCAD_IO.tcl]]; \
            [list source [file join $dir lib canvasCAD_svg_path.tcl]]; \
            [list source [file join $dir lib canvasCAD_print.tcl]]; \
            [list source [file join $dir lib vectorfont.tcl]]; \
            [list source [file join $dir lib dimension.tcl]]; \
   "
