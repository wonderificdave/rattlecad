##+##########################################################################
#
# test_angular_dimension.tcl
# by Manfred ROSENBERGER
#
#   (c) Manfred ROSENBERGER 2007/07/12
#
#   rattle_cad is licensed using the GNU General Public Licence,
#        see http://www.gnu.org/copyleft/gpl.html
# 
 
# -----------------------------------------------------------------------------------
#
#: Functions : namespace      C A N V A S   P r o c e d u r e s
#
#          wiki.tcl.tk     4844
#
#
 namespace eval tubemiter {

  package require Tk
  package require BWidget

  variable  SCREEN_Solution  [expr 72/25.4]
  
  
  
  ##+######################
  #
  #   defaults
  
  
  variable  CURRENT_Config
  array set CURRENT_Config {
               minor_diameter   28.6
               major_diameter   31.8
               cut_angle        73.0
               offset           5.0
			   # minor_diameter   14
               # major_diameter   28.6
               # cut_angle        30.0
               # offset            5.0
 
               description      {... template}
            }
            
  variable board                 {}


  
  
   #-------------------------------------------------------------------------
       # 
       #
   proc compute_mitter_point {d_minor d_cut cut_angle offset angle} {
        
        ::Debug  p  1
		
		

        set x [expr $d_minor*[mathematic::const_pi]*(180+$angle)/360]
     
        set h [expr $offset + $d_minor*0.5*sin($angle*[mathematic::const_pi]/180)]
        set b [expr $d_minor*0.5*cos($angle*[mathematic::const_pi]/180)]
     
        set l [expr sqrt(pow(0.5*$d_cut,2) - pow($h,2))]
        # set l [expr sqrt(pow(0.5*$d_cut,2) - pow(($h-$offset),2))]
        set v [expr $b/tan($cut_angle*[mathematic::const_pi]/180)]
     
        puts [format "%.2f  -  %+.2f / %+.2f  -  %+.2f / %+.2f"   $angle  $h  $b  $l  $v ]
        # puts "    $angle    ...  $fmt_h / $fmt_b  -  $fmt_l / $fmt_v"
     
        set y $h
        set y [expr -$l-$v]
     
        return [list $x $y]
        
   }


   #-------------------------------------------------------------------------
       #  print_postscript
       #
   proc print_postscript { w } {
          
            variable  CURRENT_Config
            variable  board 
        
        # global APPL_Env

        set page_a4_width   297
        set page_a4_height  210
        
          # tk_messageBox -message " print_postscript"
        set bbox      [$w bbox all]
        set bbox_size [lib_canvas::get_rect_info  size  [$w bbox all] ]
        set bbox_x    [lindex $bbox_size 0]
        set bbox_y    [lindex $bbox_size 1]
        set cv_size   [list  [winfo width  $w]  [winfo height $w]]
        
           # debug::create
          # ::Debug  t  "bbox         $bbox"       1
          # ::Debug  t  "bbox size    $bbox_size"  1
          # ::Debug  t  "bbox size x  $bbox_x"     1
          # ::Debug  t  "bbox size y  $bbox_y"     1
          # ::Debug  t  "cv   size    $cv_size"     1
        
        if {[expr $bbox_x/sqrt(2)] < $bbox_y} {
           set bbox_x [expr $bbox_y*sqrt(2)] 
        }
        
          # file::get_user_dir
        
        set user_dir {D:\TEMP}
        set user_dir $control::USER_Dir
          # ::Debug  t  "file::get_user_dir   $file::user_dir"     1

		set w_name          [winfo name $w]
        set w_name          [format "%.1f_%.1f_%.1f" $CURRENT_Config(minor_diameter) $CURRENT_Config(major_diameter) $CURRENT_Config(cut_angle)]
        set printfile_name  [file join  $user_dir  __print_$w_name.ps]
		
        tk_messageBox -message "   -> $printfile_name"
		
          # ::Debug  t  "printfile_name   $printfile_name"     1
        
        $w postscript  -file        $printfile_name \
                       -rotate      1         \
                       -width       $bbox_x   \
                       -height      $bbox_y   \
                       -x           [lindex $bbox 0] \
                       -y           [lindex $bbox 1] \
                       -pagewidth   [format "%sm" $page_a4_width] \
                       -pageheight  [format "%sm" $page_a4_height] \
                       -pageanchor  sw \
                       -pagex       [format "%sm" $page_a4_height] \
                       -pagey       0m
        
        ::start_psview  $printfile_name
   }


  
  
  #-------------------------------------------------------------------------
      # 
      #
   proc create_config_scale { w lb_text entry_var start end {resolution 1.0} } {

            variable CURRENT_Config 
        
          # eval [format "set entry_var_value  \$CURRENT_Config(%s)" $entry_var]
          # tk_messageBox -message [format "   %s  (%s)" $entry_var $entry_var_value]  
          # tk_messageBox -message "create_config_scale: $CURRENT_Config($entry_var)"
        
        frame $w
        pack  $w  -fill x   -padx 5
        
        # global $entry_var
        
        
        frame          $w.f0   -bd             3
        
          label        $w.f0.lb  \
                               -text           $lb_text \
                               -width          14 \
                               -bd             1 \
                               -anchor         w 
                               
        frame          $w.fr   -relief         sunken \
                               -bd             1
        
          ArrowButton    $w.fr.left   \
                               -dir            left \
                               -height         17 \
                               -fg             SlateGray \
                               -repeatdelay    1 \
                               -armcommand     "tubemiter::config_scale_update  $w.fr.cfg minus $resolution" 
          entry          $w.fr.cfg    \
                               -textvariable   tubemiter::CURRENT_Config($entry_var)\
                               -width          7  \
                               -bd             1 \
                               -justify        right \
                               -bg             white 
          ArrowButton    $w.fr.right  \
                               -dir            right \
                               -height         17 \
                               -fg             SlateGray \
                               -repeatdelay    1 \
                               -armcommand     "tubemiter::config_scale_update  $w.fr.cfg plus  $resolution"  
                               
        pack         $w.f0     -side left
        pack         $w.f0.lb  -side left 
                               
        pack         $w.fr     -side right 
        pack         $w.fr.left  $w.fr.cfg  $w.fr.right \
                               -side left

           
        bind         $w.fr.cfg    <KeyPress-Return> "tubemiter::update_board  $entry_var"
        bind         $w.fr.cfg    <Leave>           "tubemiter::update_board  $entry_var"
                       
       
   }


   #-------------------------------------------------------------------------
      # 
      #
   proc config_scale_update  {w  direction  resolution} {
       
        variable  CURRENT_Config
       
        set var_name [$w cget -textvariable]
        eval [ format "set scale_value \$$var_name" ]       
        switch $direction {
           plus  { set scale_value [expr $scale_value + $resolution] }
           minus { set scale_value [expr $scale_value - $resolution] }
        }
       
        set $var_name [expr 1.0 * $scale_value]
        set var_name [string range $var_name  [expr 1+[string first (  $var_name] ]   [expr -1+[string last ) $var_name] ] ]
          # tk_messageBox -message " $var_name  $scale_value"
        
        set CURRENT_Config(description)  {... manual setting}
        
        tubemiter::update_board  $var_name
   }


   #-------------------------------------------------------------------------
      # 
      #
   proc create_config_bin_radiobutton { w lb_text rb_var value command} {
     
          #global Language 

        ::Debug  p  1

        frame $w
        pack  $w      -side top  -fill x
        
        label         $w.lb   \
                          -text      $lb_text \
                          -width     16  -bd 1  -anchor w 
                          
        radiobutton   $w.rb_0 \
                          -variable  $rb_var  \
                          -value     $value   \
                          -command   $command

        pack  $w.lb  $w.rb_0  -side left  -fill x
   }


   #-------------------------------------------------------------------------
      # 
      #
   proc select_joint  {name description} {
       
            variable  CURRENT_Config  
            
          # tk_messageBox -message "$name  $CURRENT_Mitter($name)"
        
        set CURRENT_Config(minor_diameter)  [format "%.1f" [lindex $geometry::CURRENT_Mitter($name) 0] ]
        set CURRENT_Config(major_diameter)  [format "%.1f" [lindex $geometry::CURRENT_Mitter($name) 1] ]
        set CURRENT_Config(cut_angle)       [format "%.1f" [lindex $geometry::CURRENT_Mitter($name) 2] ]
        set CURRENT_Config(offset)          [format "%.1f" [lindex $geometry::CURRENT_Mitter($name) 3] ]
        
        set CURRENT_Config(description)  "rattleCAD: $description"
            
        tubemiter::update_board
            
   }


   #-------------------------------------------------------------------------
      # 
      #
   proc toggle_angle {} {
       
        variable  CURRENT_Config
       
        set CURRENT_Config(cut_angle)    [expr 180.0 - $CURRENT_Config(cut_angle)] 
        set CURRENT_Config(description)  {... manual setting}
        
        tubemiter::update_board  cut_angle
   }


   #-------------------------------------------------------------------------
      # 
      #
   proc toggle_offset {} {
       
        variable  CURRENT_Config
       
        set CURRENT_Config(offset)    [expr -1 * $CURRENT_Config(offset)] 
        set CURRENT_Config(description)  {... manual setting}
        
        tubemiter::update_board  offset
   }


   #-------------------------------------------------------------------------
      # 
      #
   proc convert_angle_degree_minute {angle} {
       
		set angle_degree  [expr int($angle)]
		set angle_degree_ [expr $angle - $angle_degree]
		
		if {$angle_degree_ == 0} {
			return "$angle_degree° 0'"
		} else {
		    set angle_minute [expr int(60*$angle_degree_ ) ]
			return "$angle_degree° $angle_minute'"		
		}
   }


   #-------------------------------------------------------------------------
       # 
       #
   proc update_board {{var_name {cut_angle}}} {
     
            variable  SCREEN_Solution 
            variable  CURRENT_Config
            variable  board 
            
        if {$CURRENT_Config(minor_diameter) > $CURRENT_Config(major_diameter)} {
            set CURRENT_Config(major_diameter) $CURRENT_Config(minor_diameter)
        }

        set offset_max [expr abs( 0.5 * $CURRENT_Config(major_diameter) - 0.5 * $CURRENT_Config(minor_diameter))]
		if { [expr abs($CURRENT_Config(offset))] > $offset_max } {
			if {$CURRENT_Config(offset) < 0} { 
			    set CURRENT_Config(offset) [expr -$offset_max]
		    } else {
			    set CURRENT_Config(offset) $offset_max
			}
		}

		
        
        set CURRENT_Config($var_name)  [expr 1.0*$CURRENT_Config($var_name)]
         # tk_messageBox -message " $var_name  "

        catch [$board delete all]

        bind $board <Motion> {
              $tubemiter::board delete status_line
              $tubemiter::board create text 30 [expr [winfo height $tubemiter::board] - 30 ] \
	                 -anchor sw -tags status_line \
	                 -text "[$tubemiter::board canvasx %x] / [$tubemiter::board canvasy %y] "
        }
     
        set board_center [mathematic::VAdd {0 0}  [list [ winfo width $tubemiter::board ]  [ winfo height $tubemiter::board ] ] 0.5 ]
     
          # lib_canvas::draw_circle $board $board_center 2  center black
          # lib_canvas::draw_circle $board $board_center 5  center red

        set perimeter [expr $CURRENT_Config(minor_diameter)*[mathematic::const_pi]]
     
        set x_start   12
        set x_end     [expr $x_start + $perimeter]
     
        set y_start   98
        set y_end     [expr $y_start + 100]
     
        set p_start   [list  $x_start  30 ]
        set p_end     [list  $x_end    30 ]
     
        set base_proj_0  [list $x_start $y_start] 
        set base_proj_1  [list $x_end   $y_start]
        set base_proj_2  [list $x_end   $y_end  ]
        set base_proj_3  [list $x_start $y_end  ]
     
     
     
          # -- draw rectangle:  $perimeter x 100 
        $board create line [lindex $base_proj_0 0]  [lindex $base_proj_0 1] \
                           [lindex $base_proj_1 0]  [lindex $base_proj_1 1] \
                           [lindex $base_proj_2 0]  [lindex $base_proj_2 1] \
                           [lindex $base_proj_3 0]  [lindex $base_proj_3 1] \
                           [lindex $base_proj_0 0]  [lindex $base_proj_0 1] \
                      -tags base_projection \
                      -fill black  
       

          # -- helplines 5 over border
        set ext         5
        set ext_x_start [expr -$ext + $x_start ]
        set ext_y_start [expr -$ext + $y_start ]
        set ext_x_end   [expr  $ext + $x_end   ]
        set ext_y_end   [expr  $ext + $y_end   ]

        $board create line $ext_x_start  [expr $y_start+50] \
                           $ext_x_end    [expr $y_start+50] \
                      -tags diameter \
                      -fill red  
     
        $board create line [expr $x_start+0.5*$perimeter]  $ext_y_start \
                           [expr $x_start+0.5*$perimeter]  $ext_y_end   \
                      -tags diameter \
                      -fill red  
                   
        $board create line [expr $x_start+0.25*$perimeter]  $ext_y_start \
                           [expr $x_start+0.25*$perimeter]  $ext_y_end   \
                      -tags diameter \
                      -fill blue  
                   
        $board create line [expr $x_start+0.75*$perimeter]  $ext_y_start \
                           [expr $x_start+0.75*$perimeter]  $ext_y_end   \
                      -tags diameter \
                      -fill blue  
                   
        
		set angle_degree_1 [tubemiter::convert_angle_degree_minute           $CURRENT_Config(cut_angle)  ]
		set angle_degree_2 [tubemiter::convert_angle_degree_minute [expr 180-$CURRENT_Config(cut_angle)] ]
		
		set canvas_text              " $CURRENT_Config(description)\n"
        set canvas_text  "$canvas_text -------------------------------------\n"
        set canvas_text  "$canvas_text   this diameter:    $CURRENT_Config(minor_diameter)\n"
        set canvas_text  "$canvas_text   this perimeter:   $perimeter \n"
        set canvas_text  "$canvas_text   cutting diameter: $CURRENT_Config(major_diameter)\n"
        set canvas_text  "$canvas_text   angle:            $CURRENT_Config(cut_angle) / [expr 180-$CURRENT_Config(cut_angle)]\n"
        set canvas_text  "$canvas_text   angle:            $angle_degree_1 / $angle_degree_2 \n"
        set canvas_text  "$canvas_text   offset:           $CURRENT_Config(offset) "
        
        $board create text [expr ($x_start + 1)] [expr ($y_start + 45)] \
                      -anchor nw -tags config_line \
                      -font "Courier 10" \
                      -text $canvas_text

     
     
        set angle -180
        set point_last [mathematic::VAdd $base_proj_3 [compute_mitter_point  $CURRENT_Config(minor_diameter)  $CURRENT_Config(major_diameter) $CURRENT_Config(cut_angle)  $CURRENT_Config(offset)  $angle] ]
     
        while {$angle<=180} {
            set point  [mathematic::VAdd $base_proj_3 [compute_mitter_point  $CURRENT_Config(minor_diameter)  $CURRENT_Config(major_diameter) $CURRENT_Config(cut_angle)  $CURRENT_Config(offset)  $angle] ]
              # puts "  ... angle is $angle   -  $point"
            $board create line [lindex $point_last 0]      [lindex $point_last 1] \
                               [lindex $point      0]      [lindex $point      1] \
                          -tags mitter_line   -fill red  
            set point_last  $point          
            incr angle 10
        }
        
          # puts "-------------------"
          # puts "-     $perimeter"
          # puts "-------------------\n"
     
        $board create line    5      5 \
                            292      5 \
                            292    205 \
                              5    205 \
                              5      5 \
                      -tags sheet_border \
                      -fill gray  
     
        $board create line    0      0 \
                            297      0 \
                            297    210 \
                              0    210 \
                              0      0 \
                      -tags sheet_border \
                      -fill white  

       
        $board scale all   0  0  1 -1   
        $board move  all   0  210   
        
        $board scale all   0 0  4 4               
     
  }
 
 
  
  #-------------------------------------------------------------------------
      # 
      #   G U I

  proc start_tubemiter  {w} {
  
           variable  board 
           variable  CURRENT_Config
       
           global _CURRENT_Mitter
  
       ::Debug  p  1
           
       if {[winfo exists $w]} {
          wm deiconify  $w
          wm deiconify  .
             Debug t "proc: start_tubemiter:  wm deiconify  $w"  1
          return
       }
       
       
       ::Debug  t  "\n"
       ::Debug  t  "  ---  \$CURRENT_Mitter  ---"
       ::Debug  a  geometry::CURRENT_Mitter
       ::Debug  t  "  ---  \$CURRENT_Mitter  ---"
       ::Debug  t  "\n"
       
       set CURRENT_Config(TopTube_Seat)   {}
       set CURRENT_Config(TopTube_Head)   {}
       set CURRENT_Config(DownTube_Head)  {}
       #minor_diameter
       #major_diameter
       #cut_angle
       
       
       # -- GUI --------------------------
       
       toplevel       $w
       wm  title      $w  {rattleCAD - tubemiter}
       wm  transient  $w  .
       
       
       frame $w.f0   -bg white
       pack  $w.f0   -fill both  -expand yes
       

       set    f_cfg  [frame      $w.f0.fcfg                 ]
       set    f_cv   [labelframe $w.f0.fcv   -text "board"  ]
       pack  $f_cfg  -fill x     -expand no   -side top
       pack  $f_cv   -fill both  -expand yes  -side bottom 
         
       
         # -- config ----------------
         #
       
           # ------ select ----------------
           #
       labelframe  $f_cfg.select         -text "select"
       frame       $f_cfg.select.d 
       pack        $f_cfg.select   -fill both  -expand yes  -side left
       pack        $f_cfg.select.d -side left 
       
       create_config_bin_radiobutton  $f_cfg.select.d.tt_seat  "TopTube - Seat"    FrameJoint  tt_seat  {tubemiter::select_joint  TopTube_Seat  "TopTube - Seat" }
       create_config_bin_radiobutton  $f_cfg.select.d.tt_head  "TopTube - Head"    FrameJoint  tt_head  {tubemiter::select_joint  TopTube_Head  "TopTube - Head" }
       create_config_bin_radiobutton  $f_cfg.select.d.dt_head  "DownTube - Head"   FrameJoint  dt_head  {tubemiter::select_joint  DownTube_Head "DownTube - Head"}
       create_config_bin_radiobutton  $f_cfg.select.d.sst_top  "SeatStay - Seat"   FrameJoint  sst_top  {tubemiter::select_joint  SeatStay_Seat "SeatStay - Seat"}


           # ------ values ----------------
           #
       labelframe  $f_cfg.values         -text "values"
       frame       $f_cfg.values.d 
       frame       $f_cfg.values.a 
       pack        $f_cfg.values   -fill both  -expand yes  -side left
       pack        $f_cfg.values.d -side left 
       pack        $f_cfg.values.a -fill y     -side right 
       
       create_config_scale  $f_cfg.values.d.minor_diameter   "minor diameter:"    minor_diameter        0   60.0  0.1
       create_config_scale  $f_cfg.values.d.major_diameter   "major diameter:"    major_diameter        0   60.0  0.1
       create_config_scale  $f_cfg.values.d.cut_angle        "cut angle:"         cut_angle          10.0  170.0  0.1
       create_config_scale  $f_cfg.values.d.offset           "offset:"            offset             10.0    0.0  0.1
  
       button $f_cfg.values.a.toggle  \
                        -text     {adjacent angle}  \
                        -width    15 \
                        -command  "tubemiter::toggle_angle"
       button $f_cfg.values.a.toggle2  \
                        -text     {adjacent offset}  \
                        -width    15 \
                        -command  "tubemiter::toggle_offset"
       pack   $f_cfg.values.a.toggle2 \
	          $f_cfg.values.a.toggle  \
                        -side bottom  \
                        -fill  x   \
                        -padx  5   \
                        -pady  1
       
       
           # ------ command ---------------
           #
       labelframe  $f_cfg.command        -text "command"
       pack        $f_cfg.command  -fill y     -side right 
  
       
       
       button $f_cfg.command.print  \
                        -text     print  \
                        -width    10 \
                        -command  "tubemiter::print_postscript $f_cv.cv"
       button $f_cfg.command.close  \
                        -text     close  \
                        -width    10 \
                        -command  "destroy $w"
  
       pack   $f_cfg.command.close  \
              $f_cfg.command.print  \
                        -side bottom  \
                        -fill  x   \
                        -padx 15   \
                        -pady  1
  
       
         # -- canvas ----------------
         #

       set   board   [ canvas $f_cv.cv   -width  500  -height 420  -bd 2  -bg white  -relief sunken ]
       pack  $board  -fill both  -expand yes

       update
  
       wm minsize $w [winfo width  $w]   [winfo height  $w]
  
       update_board  minor_diameter
       
       # wm  resizable  $w  0 0
       } 
 
 
 }