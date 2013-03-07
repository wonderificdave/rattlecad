##+##########################################################################
#
# test_canvas_CAD.tcl
# by Manfred ROSENBERGER
#
#   (c) Manfred ROSENBERGER 2010/02/06
#
#   canvas_CAD is licensed using the GNU General Public Licence,
#        see http://www.gnu.org/copyleft/gpl.html
# 
 


	set WINDOW_Title      "extSummary, rdial"

	  
	set APPL_ROOT_Dir [file dirname [file dirname [lindex $argv0]]]
	puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"
	lappend auto_path "$APPL_ROOT_Dir"
	  
	package require		Tk
	package require		extSummary 0.1

 
 
 
 
 
 
	#-------- test & demo ... disable it for package autoloading -> {0}
	if {1} {
		if {[info script] eq $argv0} {
			array set disp_value {rs -30.0 rh 120.0 rv 10.0}
			set ra 15
			proc rndcol {} {
				set col "#"
				for {set i 0} {$i<3} {incr i} {
					append col [format "%02x" [expr {int(rand()*230)+10}]]
				}
				return $col
			}
			proc set_rand_col {} {
				rdial::configure .rs -fg [rndcol] -bg [rndcol]
			}
			proc show_value {which v} {
				set val [rdial::cget .$which -value]
				set ::disp_value($which) [format "%.1f" $val]
				switch -- $which {
					"rh" {
						if {abs($val)<30} return
						rdial::configure .rs -width [expr {abs($val)}]
					}
					"rv" {
						if {abs($val)<5}  return
						rdial::configure .rs -height [expr {abs($val)}]
					}
					"rs" {
						if {!(int($val)%10)} set_rand_col
					}
				}
			}
			label .lb -text "Use mouse button with Shift &\nControl for dragging the dials"   
			label .lv -textvariable disp_value(rv)
			rdial::create .rv -callback {show_value rv} -value $disp_value(rv)\
					-width 200 -step 5 -bg blue -fg white
			label .lh -textvariable disp_value(rh)
			rdial::create .rh -callback {show_value rh} -value $disp_value(rh)\
					-width $disp_value(rh) -height 20 -fg blue -bg yellow -orient vertical 
			label .ls -textvariable disp_value(rs)
			rdial::create .rs -callback {show_value rs} -value $disp_value(rs)\
					-width $disp_value(rh) -height $disp_value(rv) 
			
			label .la -textvariable ra
			rdial::create .ra -value $ra\
					-width 50 -height 10 
					
			pack {*}[winfo children .]
			wm minsize . 220 300
		}
	}		
			
			
			
			

