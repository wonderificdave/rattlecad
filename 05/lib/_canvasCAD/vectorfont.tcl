
 ##+##########################################################################
 #
 # package: canvasCAD 	->	vectorfont.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their 
 #       own Licenses.
 # 
 # Copyright (c) Gerhard Reithofer, 2006/12/27
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
 #	namespace:  canvasCAD::vectorfont
 # ---------------------------------------------------------------------------
 #
 # 
 #  176 °   Degree_Sign
 #  177 ±   Plus_Or_Minus_Sign
 #  216 Ø   Diameter_Symbol
 #            

set debug_level 0
proc debug {msg} {
	  if {![info exists ::debug_level]} return
	  if {$::debug_level} {puts "DEBUG: $msg"}
}

############################################################
#
#   init
#

namespace eval vectorfont {
		variable packageHomeDir [file normalize [file join [pwd] [file dirname [info script]]] ]
		variable font_dir [file join $packageHomeDir font]
		variable shape 
		variable glb_shp
		variable glb_dir
		variable fid
		variable error_col "#a00000" ; ### error color is red
		variable glb_state
		variable glb_octant
		variable glb_datalen
		variable texthandle 0

		array set shape {}
		array set glb_dir {
				 0 { 1.0  0.0}
				 1 { 1.0  0.5}
				 2 { 1.0  1.0}
				 3 { 0.5  1.0}
				 4 { 0.0  1.0}
				 5 {-0.5  1.0}
				 6 {-1.0  1.0}
				 7 {-1.0  0.5}
				 8 {-1.0  0.0}
				 9 {-1.0 -0.5}
				10 {-1.0 -1.0}
				11 {-0.5 -1.0}
				12 { 0.0 -1.0}
				13 { 0.5 -1.0}
				14 { 1.0 -1.0}
				15 { 1.0 -0.5}
		}

		array set glb_datalen {
				0 -1 1 -1  2 -1  3  0  4  0  5 -1  6 -1 7  0
				8  1 9  1 10  1 11  4 12  2 13  2 14 -1
		}

		array set glb_octant {
				0   0.0
				1  45.0
				2  90.0
				3 135.0
				4 180.0
				5 225.0
				6 270.0
				7 315.0
		}

		###
		### canvas object rotation function written by Keith Vetter
		###		 see http://wiki.tcl.tk/8595
		### angle direction reversed -ger
		proc RotateItem {w tagOrId Ox Oy angle} {
			set angle [expr {$angle * atan(1) * 4 / -180.0}] ;# Radians
			foreach id [$w find withtag $tagOrId] {     ;# Do each component separately
				set xy {}
				foreach {x y} [$w coords $id] {
							# rotates vector (Ox,Oy)->(x,y) by angle clockwise
						set x [expr {$x - $Ox}]             ;# Shift to origin
						set y [expr {$y - $Oy}]

						set xx [expr {$x * cos($angle) - $y * sin($angle)}] ;# Rotate
						set yy [expr {$x * sin($angle) + $y * cos($angle)}]

						set xx [expr {$xx + $Ox}]           ;# Shift back
						set yy [expr {$yy + $Oy}]
						lappend xy $xx $yy
				}
				$w coords $id $xy
			}
		}

		proc draw_seg { c offs } {
			#  debug "draw_seg $offs"
			variable glb_state 
			variable texthandle 
			variable fid
			variable linewidth

			set ox $glb_state($fid,xcoo)
			set oy $glb_state($fid,ycoo)
			set sf $glb_state($fid,sfact)
			set nx [expr {$ox+[lindex $offs 0]*$sf}]
			set ny [expr {$oy-[lindex $offs 1]*$sf}]
			if $glb_state($fid,drmode) {
					#  debug "draw_seg $offs -> $ox $oy $nx $ny"
					$c create line $ox $oy $nx $ny \
						  -fill $glb_state($fid,color) \
						  -width $linewidth \
						  -tags "vtext$texthandle" 
			}
			set glb_state($fid,xcoo) $nx 
			set glb_state($fid,ycoo) $ny
		}

		proc draw_arc { c rad sta ext sign } {
			variable glb_state 
			variable fid
			debug "draw_arc $c $rad $sta $ext $sign"
			set cx [expr {cos($sta)*-$rad}]
			set cy [expr {sin($sta)*-$rad}]
			set x1 [expr {$cx-$rad}]
			set x2 [expr {$cx+$rad}]
			set y1 [expr {$cy-$rad}]
			set y2 [expr {$cy+$rad}]
			if {$sign<0} {
				  set st [expr {-45.0*$sta}]
				  set ex [expr {-45.0*$ext}]
			} else {
				  set st [expr {45.0*$sta}]
				  set ex [expr {45.0*$ext}]
			}
			debug "draw arc $c $x1 $y1 $x2 $y2 $st $ex"
			$c create arc $x1 $y1 $x2 $y2 -start  $st -extent $ex \
					 -outline $glb_state($fid,color) 
		}
		
		proc next_byte { args } {
			variable glb_shp
				# debug "next_byte $args <- $glb_shp"

			if [llength $args] {set bytes [lindex $args 0]} {set bytes 0}
			if {$bytes>0} {
					set res [lrange $glb_shp 0 $bytes]
			} else {
					set res [lindex $glb_shp 0]
			}
			set glb_shp [lrange $glb_shp [incr bytes] end]
				# debug "next_byte $args -> $glb_shp"
			return $res
		}

		proc process { canv code } {
			variable glb_dir 
			variable glb_shp
			variable glb_state 
			variable glb_octant

				# debug "process $canv $code"
				# debug "cidx=$cidx code=$code"
			switch -- $code {
				 8 	{
						### single X/Y offset 
						set offset [next_byte 1]
						debug "single_seg $offset"
						draw_seg $canv $offset
					}
				 9 	{
						### multiple X/Y offset 
						set offset [next_byte 1]
						while {[lindex $offset 0]!=0||[lindex $offset 1]!=0} {
							debug "multiple_seg $offset"
							draw_seg $canv $offset
							set offset [next_byte 1]
							debug "offset=$offset"
						}
					}
				10 	{
						### 0A - octant arc
						set quad [next_byte 1]
						debug "octant_arc $quad"
						set rad [lindex $quad 0]
						set tmp [lindex $quad 1]
						set oct [expr {abs($tmp)}]
						set sta [expr { $oct&0x0f    }]
						set ext [expr {($oct&0xf0)>>4}]
						debug "octant arc $canv $rad $sta $ext $tmp"
						draw_arc $canv $rad $sta $ext $tmp
					}
				11 	{
						### 0B - single fractional arc
						set fraction [next_byte 4]
						puts "SINGLE_FRACT_ARC $fraction - not implemented"
					}
				12 	{
						### 0C - single bulge specified arc
						set offset [next_byte 1]
						puts "SINGLE_BULGE_ARC $offset - partially implemented"
							### only linear bulge segments are supported,
							### arcs are flattened (drawn as lines start -> end)
						set bulge [next_byte]
						draw_seg $canv $offset
					}
				13 	{
						### 0D - multiple bulge specified arc
						set offset [next_byte 2]
						puts "MULTILE_BULGE_ARC $offset - partially implemented"
						while {[lindex $offset 0]!=0||[lindex $offset 1]!=0} {
							set bulge [next_byte]
								### only linear bulge segments are supported,
								### arcs are flattened (drawn as lines start -> end)
							draw_seg $canv $offset
							set offset [next_byte 2]
						}
					}
				default {
						set dir [expr { $code&0x0f    }]
						set len [expr {($code&0xf0)>>4}]
						set fx [lindex $glb_dir($dir) 0]
						set fy [lindex $glb_dir($dir) 1]
							#  debug "glb_dir($dir)=$glb_dir($dir)"
						set offset [list [expr {$fx*$len}] [expr {$fy*$len}]]
							#  debug "std_vect $dir $len -> $offset"
						draw_seg $canv $offset
					}
			}
		}

		proc draw_error { canv id } {
				variable error_col
				variable glb_state
				variable fid
				debug "draw_error $canv $id"
				set x1 $glb_state($fid,xcoo)
				set space "$fid,32" ; ### SPACE should exist in all fonts
				compileChar $canv $space
				set x2 $glb_state($fid,xcoo)
				set y1 [expr {$glb_state($fid,ycoo)-$glb_state($fid,sfact)*$glb_state($fid,above)}]
				set y2 [expr {$glb_state($fid,ycoo)+$glb_state($fid,sfact)*$glb_state($fid,below)}]
				$canv create polygon $x1 $y1 $x2 $y1 $x2 $y2 $x1 $y2 -fill "" \
									 -outline $error_col -width 2
		}

		proc compileChar { canv id } {
			variable fid
			variable shape 
			variable glb_shp
			variable glb_state 
			variable glb_datalen 

				# debug "compileChar $inp"
				# debug "cidx=$cidx code=$code"
			if {![info exist shape($id)]} {
			  draw_error $canv $id
			  return
			}

			set glb_shp $shape($id)
			set code [next_byte]
			debug "id=$id X,Y=$glb_state($fid,xcoo),$glb_state($fid,ycoo):$glb_shp"

			while {[llength $glb_shp]} {
				if {$::debug_level} {
					set l [llength $glb_shp]
					set c [lindex [split $id ","] 1]
					if [string is integer $c] {
						if {$c>=32} { 
							set a [format "'%c'" $c] 
						} else { 
							set a "'?'" 
						}
					} else {
						set a "'$c'"
					}
					# debug "id=$id,$a code=$code l=$l, X,Y=$glb_state($fid,xcoo),$glb_state($fid,ycoo):$glb_shp"
				}
				# if {$::debug_level} {parray glb_state}
				
				switch -- $code {
					 0 	{ 
							debug "end_rec"
							### we should NEVER reach an end of seqquence code!!!
							error "Invalid shape file format" "Unexpected code $code" SHPSEQ
						}
					 1 	{
							debug "pen_down"
									### pen down
							if {$::debug_level} {
								  $canv create line [expr $glb_state($fid,xcoo)-1]\
													[expr $glb_state($fid,ycoo)-1]\
													[expr $glb_state($fid,xcoo)+1]\
													[expr $glb_state($fid,ycoo)+1]\
													[expr $glb_state($fid,xcoo)-1]\
													[expr $glb_state($fid,ycoo)+1]\
													[expr $glb_state($fid,xcoo)+1]\
													[expr $glb_state($fid,ycoo)-1]
							}
							set glb_state($fid,drmode) 1
						}
					 2 	{
							debug "pen_up"
								### pen up
							if {$::debug_level} {
									  $canv create line [expr $glb_state($fid,xcoo)-1]\
														[expr $glb_state($fid,ycoo)-1]\
														[expr $glb_state($fid,xcoo)+1]\
														[expr $glb_state($fid,ycoo)+1]\
														[expr $glb_state($fid,xcoo)-1]\
														[expr $glb_state($fid,ycoo)+1]\
														[expr $glb_state($fid,xcoo)+1]\
														[expr $glb_state($fid,ycoo)-1]
							}
							set glb_state($fid,drmode) 0
						}
					 3	{
							set f [next_byte]
							set glb_state($fid,sfact) [expr {$glb_state($fid,sfact)/$f}]
							debug "scale down $f-> $glb_state($fid,sfact)"
						}
					 4  {
							set f [next_byte]
							set glb_state($fid,sfact) [expr {$glb_state($fid,sfact)*$f}]
							debug "scale up $f -> $glb_state($fid,sfact)"
						}
					 5  {
							debug "push $glb_state($fid,xcoo) $glb_state($fid,ycoo)"
							### push position onto stack
							lappend glb_state(stack) $glb_state($fid,xcoo) $glb_state($fid,ycoo)
						}
					 6	{
							### pop position from stack - NO RANGE CHECK!!!
							set glb_state($fid,xcoo) [lindex $glb_state($fid,stack) end-1]
							set glb_state($fid,ycoo) [lindex $glb_state($fid,stack) end  ]
							set glb_state($fid,stack) [lrange $glb_state($fid,stack) 0 end-2]
							debug "pop <- $glb_state($fid,xcoo) $glb_state($fid,ycoo)"
						}
					 7  {
							### draw subshape 
							set shape_id [next_byte]
							set shape_name [lindex [split $id ","] 0]
							debug "DRAW $shape_name,$shape_id"
							compileChar $canv "$shape_name,$shape_id"
						}
					 8 	{
							### single X/Y offset 
							process $canv $code
						}
					 9	{
							### multiple X/Y offset 
							process $canv $code
						}
					10	{
							### 0A - octant arc
							process $canv $code
						}
					11	{
							### 0B - single fractional arc
							process $canv $code
						}
					12	{
							### 0C - single bulge specified arc
							process $canv $code
						}
					13	{
							### 0D - multiple bulge specified arc
							process $canv $code
						}
					14 	{
							### 0E - vertical text flag
							if {!$glb_state($fid,duald)} {
								error "Vertical flag in none dual-orientation font" "Font data error" SHPCOD
							}
							if {$glb_state($fid,draw_vert)} {
								process $canv $id
							} else {
								set code [next_byte]
								if {$code < 15} {
									if {$glb_datalen($code)>=0} {next_byte $glb_datalen($code)}
								} 
							}
						}
					15 	{
							error "Invalid code $code occurred" "Font code error" SHPCOD
						}
					default {
							process $canv $code
					}
				}
				
				set code [next_byte]		
				if {$::debug_level} update
			}
			
			return 0
		}

		proc pre_process {} {
			upvar next line

			if {![llength $line]} {return 0}

			set line [string trim $line]
			if {![llength $line]} {return 0}

			if {[set spos [string first ";" $line]]>=0} {
				set line [string trim [string range $line 0 [expr $spos-1]]]
				if {![string length $line]} {return 0}
			}

			if {[string length $line]>128} {
				set line [string trim [string range $line 0 127]]
				if {![string length $line]} {return 0}
			}

			foreach char [split $line ""] {
			  
			}

			return 1
		}

		
###########################################################
# 
#  load_shape MUST be called prior to do any output
#
		proc load_shape { shp_file } {
			variable glb_state
			variable shape 
			variable font_dir
			variable fid

			set fid [file tail [file rootname $shp_file]]
			debug "load_shape $shp_file - fid=$fid"
			set i 0
			set f_vct_font [file join $font_dir $shp_file]
			set fd [open $f_vct_font r] 
			
			while {[set cnt [gets $fd next]] >= 0} {
				if {![pre_process]} continue

				debug "line [incr i]:$next:"
				set c1 [string index $next 0]
				if {$c1 eq "*"} {
					set tmp [split [string range $next 1 end] ","]
					set id [lindex $tmp 0]
					if {[info exists shape($fid,$id)]} {
						error "Invalid shape file format" "Shape definitions exists" SHPSEQ 
					}
					set shape($fid,$id) {}
					set shape_len [lindex $tmp 1]
					continue
				} 
			
				foreach byte [string map {( "" ) "" , " "} $next] {
				if {[string index $byte 0] eq "0"||[string range $byte 0 1] eq "-0"} { 
						scan $byte %x byte 
					} else {
						scan $byte %c tmp
							# is it a control character?
						if {$tmp<32} continue
					}
					lappend shape($fid,$id) $byte
				}
				
				set slen [llength $shape($fid,$id)]
				if {$slen>=$shape_len} {
					set ldata [lindex $shape($fid,$id) end]
					if {$ldata eq "0"} {
						set shape($fid,$id) [lrange $shape($fid,$id) 0 end-1]
					} else {
						error "No shape end sequence found" "Data sequence error" SHPEND 
					}
				}
			}
			close $fd

			if {![info exists shape($fid,0)]} {
				error "Missing font record 0" "Font init error" NOFONT 
			}

			set glb_state($fid,xcoo) 0.0
			set glb_state($fid,ycoo) 0.0
			set glb_state($fid,sfact) 1.0
			set glb_state($fid,angle) 0.0
			set glb_state($fid,drmode) 0
			set glb_state($fid,stack) [list]
			set glb_state($fid,draw_vert) 0
			set glb_state($fid,color) black
			set glb_state($fid,align) "sw"

			set glb_state($fid,above) [lindex $shape($fid,0) 0]
			set glb_state($fid,below) [lindex $shape($fid,0) 1]
			set glb_state($fid,duald) [expr {[lindex $shape($fid,0) 2] == 2}]

			return $f_vct_font
			  ;# return $fid
		}

###########################################################
# 
#  Begin text output functions
#
		proc setposition { x y } {
			variable glb_state 
			variable fid 
			set glb_state($fid,xcoo) $x
			set glb_state($fid,ycoo) $y
		}
		proc setangle { ang } {
			variable glb_state 
			variable fid 
			set glb_state($fid,angle) $ang
		}
		proc setscale { factor } {
			variable glb_state
			variable fid 
			set glb_state($fid,sfact) [expr {double($factor)}]
		}
		proc setline { width } {
			variable linewidth
			set linewidth $width
		}
		proc setcolor { color } {
			variable glb_state
			variable fid 
			set glb_state($fid,color) $color
		}
		proc setfont { id } {
			variable shape 
			variable fid
			if {![info exists shape($id,0)]} {
				error "Not existsing font name" "Font set error" NOEXFN 
			}
		set fid $id
		}
		proc setalign { dir } {
			variable glb_state
			variable fid 
			set alist [list "n" "ne" "nw" "s" "se" "sw" "e" "w" "c"]
			if {[lsearch $alist $dir]==-1} {
				error "Invalid alignment code '$dir'" "Alignment error" IALIGN 
			}
			set glb_state($fid,align) $dir
		}
		proc drawtext { canv txt } {
			variable texthandle 
			variable glb_state
			variable fid 
			incr texthandle
			set fact $glb_state($fid,sfact)
			set ox $glb_state($fid,xcoo)
			set oy $glb_state($fid,ycoo)
			set y1 [expr {$fact*$glb_state($fid,above)}]
			set y2 [expr {$fact*$glb_state($fid,below)}]
			foreach ch [split $txt ""] {
				scan $ch %c asc
                switch -exact $asc {
                    {176} {set asc Degree_Sign}
                    {177} {set asc Plus_Or_Minus_Sign}
                    {216} {set asc Diameter_Symbol}
                    default {}
                }             
				debug "compileChar $canv $fid,$asc"
				compileChar $canv "$fid,$asc"
			}
			set hnd "vtext$texthandle"
			set dx [expr {$glb_state($fid,xcoo)-$ox}]
			set dy [expr {abs($y1)+abs($y2)}]
			switch $glb_state($fid,align) {
				"e"		{ $canv move $hnd        -$dx       [expr {$dy/2.0}] }
				"ne"	{ $canv move $hnd        -$dx              $dy       }
				"n"		{ $canv move $hnd [expr {-$dx/2.0}]        $dy       }
				"nw"	{ $canv move $hnd         0.0              $dy       }
				"w"		{ $canv move $hnd         0.0       [expr {$dy/2.0}] }
				"sw"	{                                                    }
				"s"		{ $canv move $hnd [expr {-$dx/2.0}]        0.0       }
				"se"	{ $canv move $hnd        -$dx              0.0       }
				"c"		{ $canv move $hnd [expr {-$dx/2.0}] [expr {$dy/2.0}] }
				default { error "Invalid alignment code" "Internal error" INTER1 }
			}
			if {$glb_state($fid,angle) != 0.0} {
				RotateItem $canv $hnd $ox $oy $glb_state($fid,angle) 
			}
			return $hnd
		}
		proc get_characterList {} {
			variable shape      
            set charList {}
            foreach charIndex [array names shape] {
                set charID  [lindex [split $charIndex ,] 1]
                switch -exact $charID {
                    {Degree_Sign}           {set charID  176}
                    {Plus_Or_Minus_Sign}    {set charID  177}
                    {Diameter_Symbol}       {set charID  216}
                    {}                      continue
                    default {}
                }             
                lappend charList $charID
            }
            return [lsort -integer $charList]
		}
# 
#  End user functions
#
###########################################################
}

