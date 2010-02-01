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
 


  set WINDOW_Title      "test angular dimension"

  
  set APPL_ROOT_Dir [file dirname [lindex $argv0]]
  
  package require Tk
  package require BWidget

  lappend auto_path "$APPL_ROOT_Dir/_dimension"
  lappend auto_path "$APPL_ROOT_Dir/_vectorfont"
  package require dimension

  
  vectorfont::load_shape m_iso8.shp
  vectorfont::setscale 1.0
  
  set  SCREEN_Solution  [expr 72/25.4]
  
  
  
  ##+######################
  #
  #   defaults
  
  
  set start_angle          0
  set start_length       130
  set end_angle           90
  set end_length         110
  set dim_size             5
  set dim_dist           100
  set dim_offset           0
  set dim_type_select    aligned
  set dim_font_select    vector
  set std_fnt_scl          1
  
  
  ##+######################
  #
  #   procedures
  
  
  proc update_board {{value 0}} {
     global SCREEN_Solution \
            board start_angle start_length end_angle end_length dim_size \
            dim_dist dim_offset dim_font_select dim_type_select std_fnt_scl
     
     dimension::configure  style     $dim_font_select
     dimension::configure  dist      [expr $SCREEN_Solution*1.0]
     dimension::configure  size      [expr $SCREEN_Solution*$dim_size]
     dimension::configure  stdfont   [expr $SCREEN_Solution*$dim_size]
     dimension::configure  stdfscl   $std_fnt_scl

     catch [$board delete all]

     bind $board <Motion> {
        $board delete status_line
	$board create text 30 [expr [winfo height $board] - 30 ] \
	       -anchor sw -tags status_line \
	       -text "%x , %y  / [$board canvasx %x] , [$board canvasy %y] "
     }
     

     set board_center [vector_calc::VAdd {0 0}  [list [ winfo width $board ]  [ winfo height $board ] ] 0.5 ]
     
     dimension::draw_circle $board $board_center 2  center black
     dimension::draw_circle $board $board_center 5  center red

     set p_start [vector_calc::rotate_line  $board_center  $start_length  $start_angle]
     set p_end   [vector_calc::rotate_line  $board_center  $end_length    $end_angle]
     
     $board create line [lindex $p_start 0]      [lindex $p_start 1] \
                        [lindex $board_center 0] [lindex $board_center 1] \
                        -tags dimension   -fill red  
     $board create line [lindex $board_center 0] [lindex $board_center 1] \
                        [lindex $p_end 0]        [lindex $p_end 1] \
                        -tags dimension   -fill blue  
     
     
     
     switch $dim_type_select {
           aligned    { dimension::length  $board  \
                            $p_start  $p_end  $dim_dist  $dim_offset\
                            dimension black \
                            $dim_type_select
                      }
           horizontal { dimension::length  $board  \
                            $p_start  $p_end  $dim_dist  $dim_offset\
                            dimension black \
                            $dim_type_select
                      }
           vertical   { dimension::length  $board  \
                            $p_start  $p_end  $dim_dist  $dim_offset\
                            dimension black \
                            $dim_type_select
                      }
           perpendicular_red   { # perpendicular to red line: $p_start - $board_denter
						dimension::length  $board  \
                            $p_end  $p_start  $dim_dist  $dim_offset\
                            dimension black \
                            perpendicular $board_center
                      }
           perpendicular_blue   { # perpendicular to blue line: $board_denter - $p_end
						dimension::length  $board  \
                            $p_start  $p_end  $dim_dist  $dim_offset\
                            dimension black \
                            perpendicular $board_center
                      }
           angle      { dimension::angle   $board  \
                            $board_center  $p_start  $p_end  $dim_dist  $dim_offset \
                            dimension black   
                      }
     }
     
     
     $board scale all   0  [ expr [winfo height $board ] * 0.5 ]  1 -1                   
  }
  
  
 proc create_config_line {w lb_text entry_var start end} {
	     
     frame   $w
     pack    $w
 
     global $entry_var

     label     $w.lb     -text $lb_text            -width 20  -bd 1  -anchor w 
     entry     $w.cfg    -textvariable $entry_var  -width 10  -bd 1  -justify right -bg white 
	 
     scale     $w.scl     -width        12 \
                          -length       120 \
                          -bd           1  \
                          -sliderlength 15 \
                          -showvalue    0  \
                          -orient       horizontal \
                          -command      "update_board" \
                          -variable     $entry_var \
                          -from         $start \
                          -to           $end 
                          #-resolution   0.25

     pack      $w.lb  $w.cfg $w.scl    -side left  -fill x
		    
  }
  
  
  
  ##+######################
  #
  #   G U I

  
  frame .f0 
  set f_cv  [labelframe .f0.fcv   -text "board"  ]
  set f_cfg [labelframe .f0.fcfg  -text "config" ]

  pack  .f0      -expand yes -fill both
  pack  $f_cv  $f_cfg     -side left -expand yes -fill both
  pack  configure $f_cfg  -fill y
  
  set   board      [ canvas $f_cv.cv   -width  600  -height 500  -bd 2  -bg white  -relief sunken ]
  pack  $board   -expand yes  -fill both  

  
  
  labelframe  $f_cfg.select         -text "dimension type"
  labelframe  $f_cfg.values         -text "values"
  pack        $f_cfg.select \
              $f_cfg.values         -fill x -side top 
  
  
  
  create_config_line $f_cfg.values.start_angle   "start angle  (red):"    start_angle     0  360
  create_config_line $f_cfg.values.start_length  "start length (red):"    start_length   50  150

  create_config_line $f_cfg.values.end_angle     "end angle    (blue):"   end_angle       0  360
  create_config_line $f_cfg.values.end_length    "end length   (blue): "  end_length     50  150


  create_config_line $f_cfg.values.dim_size      "dimension size:"        dim_size        0   10
  create_config_line $f_cfg.values.dim_dist      "dimension distance:"    dim_dist     -250  250
  create_config_line $f_cfg.values.dim_offset    "dimension offset:"      dim_offset   -250  250
  
  create_config_line $f_cfg.values.std_fnt_scl   "standard font scale:"   std_fnt_scl     0    2   
  $f_cfg.values.std_fnt_scl.scl                   configure   -resolution 0.1



  
  labelframe  $f_cfg.select.length  -text length
  labelframe  $f_cfg.select.angle   -text angle
  labelframe  $f_cfg.select.font    -text font

  pack        $f_cfg.select.length \
              $f_cfg.select.angle  \
              $f_cfg.select.font   -fill x -side top 

  radiobutton        $f_cfg.select.length.aligned \
                            -text      "aligned   " \
                            -variable  "dim_type_select" \
                            -value     "aligned" \
                            -command   "update_board"
                            
  radiobutton        $f_cfg.select.length.horizontal \
                            -text      "horizontal" \
                            -variable  "dim_type_select" \
                            -value     "horizontal" \
                            -command   "update_board"
                            
  radiobutton        $f_cfg.select.length.vertical \
                            -text      "vertical  " \
                            -variable  "dim_type_select" \
                            -value     "vertical" \
                            -command   "update_board"
                            
  radiobutton        $f_cfg.select.length.perp_red \
                            -text      "perp. to red line " \
                            -variable  "dim_type_select" \
                            -value     "perpendicular_red" \
                            -command   "update_board"
                            
  radiobutton        $f_cfg.select.length.perp_blue \
                            -text      "perp. to blue line  " \
                            -variable  "dim_type_select" \
                            -value     "perpendicular_blue" \
                            -command   "update_board"
                            
  radiobutton        $f_cfg.select.angle.angle  \
                            -text      "angle" \
                            -variable  "dim_type_select" \
                            -value     "angle" \
                            -command   "update_board" \
                            -justify   left
  
  radiobutton        $f_cfg.select.font.vector  \
                            -text      "vector" \
                            -variable  "dim_font_select" \
                            -value     "vector" \
                            -command   "update_board" \
                            -justify   left
  
  radiobutton        $f_cfg.select.font.standard  \
                            -text      "standard" \
                            -variable  "dim_font_select" \
                            -value     "standard" \
                            -command   "update_board" \
                            -justify   left
  
  pack  $f_cfg.select.length.aligned \
        $f_cfg.select.length.horizontal \
        $f_cfg.select.length.vertical \
        $f_cfg.select.length.perp_red \
        $f_cfg.select.length.perp_blue \
        $f_cfg.select.angle.angle \
        $f_cfg.select.font.vector \
        $f_cfg.select.font.standard \
     -side top  
  
 
  
  
  ####+### E N D

  update
  wm minsize . [winfo width  .]   [winfo height  .]
   
 
 