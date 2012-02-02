#
 # rdial.tcl
 #
 # Contents: a "rotated" dial widget or thumbnail "roller" dial
 # Date: Son May 23, 2010
 #
 # Abstract
 #   A mouse drag-able "dial" widget from the side view - visible
 #   is the knurled area - Shift & Ctrl changes the sensitivity 
 #
 # Copyright (c) Gerhard Reithofer, Tech-EDV 2010-05
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
 # Syntax:
 #   rdial::create w ?-width wid? ?-height hgt?  ?-value floatval?
 #        ?-bg|-background bcol? ?-fg|-foreground fcol? ?-step step?
 #        ?-callback script? ?-scale "degrees"|"radians"|factor?
 #        ?-slow sfact? ?-fast ffact? ?-orient horizontal|vertical?
 #
 # History:
 #  20100526: -scale option added 
 #  20100629: incorrect "rotation direction" in vertical mode repaired
 #  20101112: drag: set opt(value,$w) depending to scale, modify callback
 #
 
 namespace eval rdial {
     variable d2r
     variable canv
     variable sfact
     variable ssize
     variable ovalue
     variable sector 88
     variable callback 
     
     # a few constants to reduce expr
     set d2r [expr {atan(1.0)/45.0}]
     set ssize [expr {sin($sector*$d2r)}]
     
     # widget default values  
     array set def {
         background "#dfdfdf"
         foreground "black"
         callback "" 
		 orient horizontal 
         width 80 height  8
         step  10 value 0.0
         slow 0.1 fast 10
         scale 1.0
     }
     
     proc err_out {err {msg ""}} {
         if {$msg eq ""} {
             set msg "must be -bg, -background, -fg, -foreground, -value, -width,\
                 -height, -callback, -scale, -slow, -fast -orient or -step"
         }
         error "$err: $msg" 
     }
     
     # configure method - write only
     proc configure {w nopt val args} {
         variable d2r
         variable opt
         variable canv
         variable ssize
         variable sfact
         
         if {[llength $args]%2} {
             err_out "invalid syntax" \
                     "must be \"configure opt arg ?opt arg? ...\""
         }
         
         set args [linsert $args 0 $nopt $val]
         foreach {o arg} $args {
             if {[string index $o 0] ne "-"} {
                 err_out "invalid option \"$nopt\""
             }
             switch -- $o {
                 "-bg" {set o "-background"}
                 "-fg" {set o "-foreground"}
                 "-scale" {
                     switch -glob -- $arg {
                         "d*" {set arg 1.0}
                         "r*" {set arg $d2r}
                     }
                     # numeric check
                     set arg [expr {$arg*1.0}]
                 }
                 "-value" {
                   set arg [expr {$arg/$opt(scale,$w)}]
                 }
             }
             set okey [string range $o 1 end]
             if {[info exists opt($okey,$w)]<0} {
                 err_out "unknown option \"$o\""
             }
             # canvas resize isn't part of draw method
             if {$o eq "-width" || $o eq "-height"} {
                 $canv($w) configure $o $arg
             }
             set opt($okey,$w) $arg
             # sfact depends on width
             if {$o eq "-width"} {
                 set sfact($w) [expr {$ssize*2/$opt(width,$w)}]
             }
         }
         
         draw $w $opt(value,$w)
     }
     
     # cget method
     proc cget {w nopt} {
         variable opt
         switch -- $nopt {
             "-bg" {set nopt "-background"}
             "-fg" {set nopt "-foreground"}
         }
         set okey [string range $nopt 1 end]
         if {[info exists opt($okey,$w)]<0 &&
             [string index $nopt 0] ne "-"} {
             err_out "unknown option \"$nopt\""
         }
         if {$nopt eq "-value"} {
           return [expr {$opt($okey,$w)*$opt(scale,$w)}]
         } else  {
           return $opt($okey,$w)      
         }
     }
         
     # draw the thumb wheel view
     proc draw {w val} {
         variable opt
         variable d2r
         variable canv
         variable ssize
         variable sfact
         variable sector
         
         set stp $opt(step,$w)
         set wid $opt(width,$w)
         set hgt $opt(height,$w)
         set dfg $opt(foreground,$w)
         set dbg $opt(background,$w)
         
         $canv($w) delete all
         if {$opt(orient,$w) eq "horizontal"} {
             # every value is mapped to the visible sector
             set mod [expr {$val-$sector*int($val/$sector)}]
             $canv($w) create rectangle 0 0 $wid $hgt -fill $dbg
             # from normalized value to left end
             for {set ri $mod} {$ri>=-$sector} {set ri [expr {$ri-$stp}]} {
                 set offs [expr {($ssize+sin($ri*$d2r))/$sfact($w)}]
                 $canv($w) create line $offs 0 $offs $hgt -fill $dfg
             }
             # from normalized value to right end
             for {set ri [expr {$mod+$stp}]} {$ri<=$sector} {set ri [expr {$ri+$stp}]} {
                 set offs [expr {($ssize+sin($ri*$d2r))/$sfact($w)}]
                 $canv($w) create line $offs 0 $offs $hgt -fill $dfg
             }
         } else {
             # every value is mapped to the visible sector
             set mod [expr {$sector*int($val/$sector)-$val}]
             $canv($w) create rectangle 0 0 $hgt $wid -fill $dbg
             # from normalized value to upper end
             for {set ri $mod} {$ri>=-$sector} {set ri [expr {$ri-$stp}]} {
                 set offs [expr {($ssize+sin($ri*$d2r))/$sfact($w)}]
                 $canv($w) create line 0 $offs $hgt $offs -fill $dfg
             }
             # from normalized value to lower end
             for {set ri [expr {$mod+$stp}]} {$ri<=$sector} {set ri [expr {$ri+$stp}]} {
                 set offs [expr {($ssize+sin($ri*$d2r))/$sfact($w)}]
                 $canv($w) create line 0 $offs $hgt $offs -fill $dfg
             }
         }
         # let's return the widget/canvas  
         set opt(value,$w) $val
     }
     
     proc drag {w coord drag_Event {mode 0}} {
         variable opt
         variable ovalue
		 
		 # puts "   -> drag %k:  $drag_Event"
 
         # calculate new value
         if {$opt(orient,$w) eq "horizontal"} {
             set diff [expr {$coord-$ovalue($w)}]
         } else  {
             set diff [expr {$ovalue($w)-$coord}]
         }
         if {$mode<0} {
             set diff [expr {$diff*$opt(slow,$w)}]
         } elseif {$mode>0} {
             set diff [expr {$diff*$opt(fast,$w)}]
         }
         set opt(value,$w) [expr {$opt(value,$w)+$diff*$opt(scale,$w)}]
             
         # call callback if defined...
         if {$opt(callback,$w) ne ""} {
             {*}$opt(callback,$w) $opt(value,$w) $drag_Event 
         }
             # {*}$opt(callback,$w) [expr {$opt(value,$w)*$opt(scale,$w)}]
 
         # draw knob with new angle
         draw $w $opt(value,$w)
         # store "old" value for diff
         set ovalue($w) $coord
     }
     
     proc create {w args} {
         variable def
         variable d2r
         variable opt
         variable canv
         variable ssize
         variable sfact
         variable sector
         
         set opt_list [array names def]
         # set default values
         foreach {d} $opt_list {
             set opt($d,$w) $def($d) 
         }
         # handle command paramters 
         foreach {tmp arg} $args {
             set o [string range $tmp 1 end]
             switch -- $o {
                 "bg" {set o background}
                 "fg" {set o foreground}
                 "scale" {
                     switch -glob -- $arg {
                         "d*" {set arg 1.0}
                         "r*" {set arg $d2r}
                     }
                     # numeric check
                     set arg [expr {$arg*1.0}]
                 }
             }
             if {[lsearch $opt_list $o]<0 ||
                 [string index $tmp 0] ne "-"} {
                 err_out "bad option \"$o\""
             }
             set opt($o,$w) $arg
         }
         
         # width specific scale constant
         set sfact($w) [expr {$ssize*2/$opt(width,$w)}]
         
         # just for laziness ;)
         set nsc [namespace current]
         set wid $opt(width,$w)
         set hgt $opt(height,$w)
         set bgc $opt(background,$w)
         
         # create canvas and bindings
         if {$opt(orient,$w) eq "horizontal"} {
             set canv($w) [canvas $w -width $wid -height $hgt]
             # standard bindings
             bind $canv($w) <ButtonPress-1> 	[list set ${nsc}::ovalue(%W) %x]
             bind $canv($w) <B1-Motion>       	[list ${nsc}::drag %W %x motion]
             bind $canv($w) <ButtonRelease-1> 	[list ${nsc}::drag %W %x release]
             # fine movement
             bind $canv($w) <Shift-ButtonPress-1> 	[list set ${nsc}::ovalue(%W) %x]
             bind $canv($w) <Shift-B1-Motion>       [list ${nsc}::drag %W %x motion  -1]
             bind $canv($w) <Shift-ButtonRelease-1> [list ${nsc}::drag %W %x release -1]
             # course movement
             bind $canv($w) <Control-ButtonPress-1> 	[list set ${nsc}::ovalue(%W) %x]
             bind $canv($w) <Control-B1-Motion>       	[list ${nsc}::drag %W %x motion  1]
             bind $canv($w) <Control-ButtonRelease-1> 	[list ${nsc}::drag %W %x release 1]
         } else {
             set canv($w) [canvas $w -width $hgt -height $wid]
             # standard bindings
             bind $canv($w) <ButtonPress-1> [list set ${nsc}::ovalue(%W) %y]
             bind $canv($w) <B1-Motion>       [list ${nsc}::drag %W %y motion]
             bind $canv($w) <ButtonRelease-1> [list ${nsc}::drag %W %y release]
             # fine movement
             bind $canv($w) <Shift-ButtonPress-1> [list set ${nsc}::ovalue(%W) %y]
             bind $canv($w) <Shift-B1-Motion>       [list ${nsc}::drag %W %y motion  -1]
             bind $canv($w) <Shift-ButtonRelease-1> [list ${nsc}::drag %W %y release -1]
             # course movement
             bind $canv($w) <Control-ButtonPress-1> [list set ${nsc}::ovalue(%W) %y]
             bind $canv($w) <Control-B1-Motion>       [list ${nsc}::drag %W %y motion  1]
             bind $canv($w) <Control-ButtonRelease-1> [list ${nsc}::drag %W %y release 1]
         }
             
         # draw insides
         draw $w $opt(value,$w)
         return $w
     }
 }
 
 
 
	#-------- test & demo ... disable it for package autoloading -> {0}
 	if {0} {
		if {[info script] eq $argv0} {
			array set disp_value {rs -30.0 rh 120.0 rv 10.0}
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
			pack {*}[winfo children .]
			wm minsize . 220 300
		}
	}	
