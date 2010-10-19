# Tcl package index file, version 1.1
# This file is generated by the "pkg_mkIndex" command
# and sourced either when an application starts up or
# by a "package unknown" script.  It invokes the
# "package ifneeded" command to set up package-related
# information so that packages will be loaded automatically
# in response to "package require" commands.  When this
# script is sourced, the variable $dir must contain the
# full path name of this file's directory.

package ifneeded   rattleCAD  3.1 "\
        package require    AppUtil     0.8; \
        [list source  [file join $dir rattleCAD.tcl]]; \
        [list source  [file join $dir lib_file.tcl]]; \
        [list source  [file join $dir lib_gui.tcl]]; \
        [list source  [file join $dir lib_cfg_report.tcl]]; \
        [list source  [file join $dir lib_comp_library.tcl]]; \
        [list source  [file join $dir lib_frame_geometry_custom.tcl]]; \
		[list source  [file join $dir lib_frame_geometry_reference.tcl]]; \		
        [list source  [file join $dir lib_frame_visualisation.tcl]]; \		
        [list source  [file join $dir lib_cv_custom_00.tcl]]; \		
        [list source  [file join $dir lib_version_info.tcl]]; \
   "

 # .. unused since 3.1.00
 # [list source  [file join $dir lib_control.tcl]]; 
 # [list source  [file join $dir lib_frame_ref_geometry.tcl]]; \		
