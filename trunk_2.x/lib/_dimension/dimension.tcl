#############################################################
#
#  dimension package
#   (c) Manfred ROSENBERGER, 2007/12/13
#
#   Dimension is licensed using the GNU General Public Licence,
#        see http://www.gnu.org/copyleft/gpl.html
#
#      0.2)  2007.12.13  
#                extend dimension line to center of dimension text if there
#                is a dimension-offset 
#      
# 

package provide dimension 0.2

# -----------------------------------------------------------------------------------
#
#: Functions : namespace      D I M E N S I O N
#

package require vectorfont

namespace eval dimension {
          
   variable DIMENSION_Style          vector
   variable DIMENSION_Std_Font       -adobe-times-medium-r-*-*-10-*-*-*-*-*-*-*
   variable DIMENSION_Size           10.0
   variable DIMENSION_Std_Scale      1.0
   variable DIMENSION_Distance       1
   variable DIMENSION_Line           0.5
   
       
       #-------------------------------------------------------------------------
           #  
           #
   proc compute_size { type } {   \
        variable DIMENSION_Size
        variable DIMENSION_Line
        variable DIMENSION_Distance
        
        switch $type {
               line    { return  $DIMENSION_Line }
               font    { return  [expr $DIMENSION_Size / (10*72/25.4)]  
                               # [expr $DIMENSION_Size * $SCREEN_Solution / 30] 
                               # [expr 1.0*$DIMENSION_Size / 10]
                       }
               dist    { return  $DIMENSION_Distance }
               arrow   { return  $DIMENSION_Size }
               default { return }
        }
   }   

        
       #-------------------------------------------------------------------------
           #  
           #
   proc configure { type value} {
        variable DIMENSION_Size
        variable DIMENSION_Style
        variable DIMENSION_Distance
        variable DIMENSION_Line
        variable DIMENSION_Std_Font
        variable DIMENSION_Std_Scale
        
          # tk_messageBox -message "pre  $DIMENSION_Size "
        switch $type {
               style     { set DIMENSION_Style      $value }
               size      { set DIMENSION_Size       $value }
               dist      { set DIMENSION_Distance   $value }
               line      { set DIMENSION_Line       $value }
               stdfscl   { set DIMENSION_Std_Scale  $value } 
               stdfont   { 
                           #set dim_size             [expr round(4*$value*$DIMENSION_Std_Scale)]
                           #set DIMENSION_Std_Font   "Courier $dim_size normal"
                           
                           set dim_size             [expr round($value*$DIMENSION_Std_Scale)]
                           set DIMENSION_Std_Font   "Arial $dim_size normal"
                           
                           # set dim_size             [expr round(4.5*$value*$DIMENSION_Std_Scale)]
                           # set DIMENSION_Std_Font  "-adobe-helvetica-medium--normal--$dim_size"
                           
                           # set DIMENSION_Std_Font  "-adobe-helvetica-medium--normal--"
                           # set DIMENSION_Std_Font  "-adobe-helvetica-medium--normal--$dim_size"
                           # set DIMENSION_Std_Font  "Arial $dim_size normal"
                           # set DIMENSION_Std_Font  "--arial-0-0---0-0-0-0-p-0-iso8859-1" 
                           # set DIMENSION_Std_Font  "-adobe-times-medium-r-*-*-dim_size-*-*-*-*-*-*-*"
                         }
        }
          # tk_messageBox -message " $DIMENSION_Style "
          # tk_messageBox -message "post $DIMENSION_Size "
   }   

        
       #-------------------------------------------------------------------------
           #  
           #
   proc standardfont { w x y text {colour black}} {
        variable DIMENSION_Std_Font
        variable DIMENSION_Size
        
        set dim_size [expr round($DIMENSION_Size)]
        set tag [$w create text $x $y \
	                        -text   "$text" \
	                        -anchor s \
	                        -fill   $colour \
	                        -font   $DIMENSION_Std_Font ]
        return $tag 
   }   

        
       #-------------------------------------------------------------------------
           #  
           #
   proc dim_text_format {value} {
             set dim_text      [eval format "%s" $value]
             set dim_text      [split $dim_text .]
             set dim_text_lft  [lindex $dim_text 0]
             set dim_text_rgt  [lindex $dim_text 1]
             
             if {$dim_text_rgt == 0} {
                   set dim_text  $dim_text_lft
             } else {
                   set dim_text  [format "%s,%s" $dim_text_lft $dim_text_rgt]
             }
             return $dim_text
   }   

        
       #-------------------------------------------------------------------------
           #  
           #
   proc angle { w  pc p1 p2 dim_dist dim_offset geometry_id colour } {
        
        variable  DIMENSION_Style
        variable  DIMENSION_Size
        variable  DIMENSION_Line
        
        set line_width    $DIMENSION_Line
        set font_size     [compute_size font]
        set font_dist     [compute_size dist]
        set arrow_length  [compute_size arrow]
        

        proc draw_arc { w p r geometry_id start extent colour lw } {
            foreach {x y} $p break
            $w create arc   [ expr  $x - $r ]  [ expr  $y - $r ]  \
                            [ expr  $x + $r ]  [ expr  $y + $r ]  \
                   -start   $start    \
                   -extent  $extent   \
                   -style   arc       \
                   -outline $colour   \
                   -width   $lw       \
                   -tags    $geometry_id  
        }
        
        proc flip_vectortext {w tag} {
            set tag_bb      [$w bbox $tag]
       
            set tag_bb_c    [vector_calc::line_center   [list [lindex $tag_bb 0] [lindex $tag_bb 1] ] \
                                                        [list [lindex $tag_bb 2] [lindex $tag_bb 3] ] ]
            set tag_bb_c_y  [lindex $tag_bb_c 1]
       
            $w scale $tag  0 $tag_bb_c_y  1 -1
        }   
        

        # -------------------------------
          # correct direction
        if {$dim_dist < 0} {
             set p0       $p1
             set p1       $p2
             set p2       $p0
             set dim_dist [expr -$dim_dist]
        }
          
        # -------------------------------
          # get direction
        set angle_p1    [vector_calc::direction $pc $p1 ]
        set angle_p2    [vector_calc::direction $pc $p2 ]
        
        if {$angle_p1 <  0} {set angle_p1 [expr 360+$angle_p1]}
        if {$angle_p2 <= 0} {set angle_p2 [expr 360+$angle_p2]}
        
        set angle_p1    [eval format "%0.3f" $angle_p1 ]
        set angle_p2    [eval format "%0.3f" $angle_p2 ]
        
        if {$angle_p1            == $angle_p2} { return }
        if {[expr $angle_p1+360] == $angle_p2} { return }
        

        # -------------------------------
          # angle in between 3 points
        set angle_gap    [ expr $angle_p2 - $angle_p1 ]
        
        
        # -------------------------------
          # dimension line direction
        set angle_text   [ expr $angle_p1+0.5*$angle_gap]
        
        
        # -------------------------------
          # dimensionline and arrows
          #   correct beginning and end  ...
        if {$angle_gap > 0} {
              draw_arc        $w  $pc  $dim_dist  dimension  $angle_p1     $angle_gap            $colour  $line_width
              set angle_dim_p1  [expr $angle_p1  +  90]
              set angle_dim_p2  [expr $angle_p2  -  90]
        } else {
              draw_arc        $w  $pc  $dim_dist  dimension  0             $angle_p2             $colour  $line_width
              if {$angle_p1 < 270} {
                   draw_arc   $w  $pc  $dim_dist  dimension  $angle_p1     [expr 270-$angle_p1]  $colour  $line_width
                   draw_arc   $w  $pc  $dim_dist  dimension  270           90                    $colour  $line_width
              } else {
                   draw_arc   $w  $pc  $dim_dist  dimension  $angle_p1     [expr 360-$angle_p1]  $colour  $line_width
              }
              set angle_dim_p1  [expr $angle_p1  +  90]
              set angle_dim_p2  [expr $angle_p2  -  90]
              set angle_gap     [expr $angle_gap + 360]
              set angle_text    [expr $angle_text+ 180]
              if {$angle_text>360} {set angle_text [expr $angle_text - 360]}
        }
        
        set p_hl_dim_p1  [ vector_calc::rotate_line  $pc  $dim_dist  $angle_p1 ]
        set p_hl_dim_p2  [ vector_calc::rotate_line  $pc  $dim_dist  $angle_p2 ]
      
      
          # debug info
          # set p_text   [vector_calc::VAdd  $p1  {20 20}]
          # $w create text  [lindex $p1 0] [lindex $p1 1]   -text "A  $angle_p1"
          # set p_text   [vector_calc::VAdd  $p2  {20 20}]
          # $w create text  [lindex $p2 0] [lindex $p2 1]   -text "B  $angle_p2 / $angle_gap"

        draw_arrow $w  $p_hl_dim_p1  $angle_dim_p1  $line_width  $arrow_length  dimension  $colour  
        draw_arrow $w  $p_hl_dim_p2  $angle_dim_p2  $line_width  $arrow_length  dimension  $colour  


        # -------------------------------
          # text position
        set v_text      [vector_calc::rotate_line  $pc  [expr $font_dist+$dim_dist]  $angle_text ]
        
          # $w create text  [lindex $v_text 0] [lindex $v_text 1]   -text "$angle_text"
        

        # -------------------------------
          # text definition
        set dim_value    [eval format "%0.1f" $angle_gap]
        
        if {$angle_text <   0} {set angle_text [expr 360 + $angle_text]}
        if {$angle_text < 180} {
              vectorfont::setangle    -90
              set v_text_0    [vector_calc::VAdd  $pc  [list  [expr $dim_dist + $font_dist] 0] ]
        } else {
              vectorfont::setangle    90
              set v_text_0    [vector_calc::VAdd  $pc  [list  [expr $dim_dist - $font_dist] 0] ]
        }
        
        vectorfont::setalign    "s"
        vectorfont::setposition [lindex $v_text_0 0] [lindex $v_text_0 1]
        vectorfont::setcolor    $colour
        vectorfont::setline     $line_width
        vectorfont::setscale    $font_size
                             #  [expr $font_size/8]
        
        set dim_text   [dim_text_format $dim_value]
        
        if {$DIMENSION_Style == "vector"} {
             set dim   [vectorfont::drawtext $w $dim_text]        
             flip_vectortext $w $dim  
        } else {
             set dim   [ standardfont  $w  [lindex $v_text_0 0]  [lindex $v_text_0 1]  $dim_text  $colour]
        }
        
        $w addtag dimension withtag $dim
        $w addtag dim_text  withtag $dim
        
        #  ---------------------------------------------
          #  dimension text offset
        set angle_text [expr $angle_text + $dim_offset]
	
        #  ---------------------------------------------
          #  reposition text
        vectorfont::RotateItem $w $dim [lindex $pc 0] [lindex $pc 1] [expr -$angle_text]

   }   

       
       
       #-------------------------------------------------------------------------
           #  
           #
  proc length { w p01 p02 dim_dist dim_offset geometry_id colour {orient aligned} {p_orient _unset}} {
	
        variable  DIMENSION_Style
        variable  DIMENSION_Size
        variable  DIMENSION_Line
        
        set line_width    $DIMENSION_Line
        set font_size     [compute_size font]
        set font_dist     [compute_size dist]
        set arrow_length  [compute_size arrow]
      
        set switch_direction 95

        set hl_dist     $font_dist
        set txt_dist    $font_dist
            # tk_messageBox -message " 01 - $p01 / $p02"
		# set p01_orient	$p01


        
        proc dimline_inside_points { p1 p2 p_dim } {
            set return_value 0 
                           # inside
            set p_1   [expr $p1    + abs($p1) + abs($p2) + abs($p_dim)]
            set p_2   [expr $p2    + abs($p1) + abs($p2) + abs($p_dim)]
            set p_dim [expr $p_dim + abs($p1) + abs($p2) + abs($p_dim)]
	    
            if { $p1 < $p2 } {
              set p__1 $p_1
              set p__2 $p_2
            } else {
              set p__1 $p_2
              set p__2 $p_1
            }

            if { $p_dim < $p__1 } { set return_value 1 }
            if { $p_dim > $p__2 } { set return_value 1 }

            return $return_value   
        }
        
        
        set p_start     $p01  
        set p_end       $p02  

           # tk_messageBox -message " 01 - $p01 / $p02"

        set p01_txt     [vector_calc::VSub $p01 {30 30}]
        set p02_txt     [vector_calc::VAdd $p02 {30 30}]
        
        
        
        set xy          [vector_calc::VSub         $p_start $p_end]
        set dim_dir     [vector_calc::direction    $p_start $p_end]
       
        switch $orient {
        
            horizontal {
                   set  dimline_dir  0
                   if { $dim_dir > 90 } { 
                        if { $dim_dir < 270 } { 
                             set dimline_dir 180
                           }
                   } 
                   set xy   [list [lindex $xy 0] 0]
                    # tk_messageBox -message "horizontal  $dim_dir / $dimline_dir / $xy"
                }                   
            vertical   {
                   if { $dim_dir < 180 } { 
                        set dimline_dir 90 
                   } else {
                        set dimline_dir 270 
                   }
                   set xy   [list 0 [lindex $xy 1] ]
                    # tk_messageBox -message "vertical  $dim_dir / $dimline_dir / $xy"
                }                   
                   
            aligned    {
                set dimline_dir $dim_dir
                    # tk_messageBox -message "aligned  $dim_dir / $dimline_dir / $xy"
                }   

            perpendicular    { # dimension line from p_start perpendicular to p_end/p02_orient
				if { $p_orient == "_unset" } { 
						set dimline_dir $dim_dir 
				   } else {
						set p_intsct  [ vector_calc::perp_distance    $p_start $p_end $p_orient ]
						  # draw_circle $w $p_end 2  center green						
						set xy        [ vector_calc::VSub             $p_start $p_intsct ]
				        set dimline_dir   [ expr [vector_calc::direction  $p_end $p_orient] -90 ]
						set helpline_dir  [ expr $dimline_dir + 90]						
				   }
				}   
                
        }

        set helpline_dir [ expr $dimline_dir - 90]
        
        foreach {x y} $xy break       
        set dim_value   [ expr  hypot($x,$y) ]	
        set dim_value   [ eval format "%0.1f" $dim_value ]
        if {$dim_value == 0} { return }

        set dim_vct     [vector_calc::rotate_line  {0 0} $dim_dist  $helpline_dir]
        set p_dim_start [vector_calc::VAdd  $p_start     $dim_vct]
        set p_dim_end   [vector_calc::VSub  $p_dim_start $xy     ]

        foreach {x1 y1} $p_dim_start  \
                {x2 y2} $p_dim_end   break
                
        #  ---------------------------------------------
           #  dimension line
        $w create line  $x1 $y1 $x2 $y2  -tags dimension   -fill $colour  -width $line_width

        #  ---------------------------------------------
           #  dimension line
        set helpline_vct   [vector_calc::VSub    $p_dim_start $p_start ]
        foreach {x y} $helpline_vct   break
        set helpline_l     [expr {hypot($x,$y)}]
        if { $helpline_l != 0 } {
               set helpline_move  [vector_calc::VAdd  {0 0}  $helpline_vct  [expr $hl_dist/$helpline_l] ]
               set helpline_start [vector_calc::VAdd  $p_start     $helpline_move]
               set helpline_end   [vector_calc::VAdd  $p_dim_start $helpline_move]
               foreach {x1 y1} $helpline_start  \
                       {x2 y2} $helpline_end   break
               $w create line  $x1 $y1 $x2 $y2  -tags dimension   -fill $colour  -width $line_width
        }
	
        set helpline_vct   [vector_calc::VSub    $p_dim_end   $p_end   ]
        foreach {x y} $helpline_vct   break
        set helpline_l     [expr {hypot($x,$y)}]
        if { $helpline_l != 0 } {
               set helpline_move  [vector_calc::VAdd  {0 0}  $helpline_vct  [expr $hl_dist/$helpline_l] ]
               set helpline_start [vector_calc::VAdd  $p_end     $helpline_move]
               set helpline_end   [vector_calc::VAdd  $p_dim_end $helpline_move]
               foreach {x1 y1} $helpline_start  \
                       {x2 y2} $helpline_end   break
               $w create line  $x1 $y1 $x2 $y2  -tags dimension   -fill $colour  -width $line_width
        }
               
        #  ---------------------------------------------
           #  dimension line center
        set dim_line_center [ vector_calc::line_center $p_dim_start $p_dim_end] 
           #draw_circle $w $dim_line_center 2  dimension

        #  ---------------------------------------------
           #  dimension arrow
        set arrow_angle     [ vector_calc::direction   $dim_line_center  $p_dim_start ]   
        if { $dim_value < [expr 2.5*$arrow_length] } {
              set arrow_angle   [expr 180+$arrow_angle]
              set dim_vct        [vector_calc::rotate_line  {0 0}  [expr 1.5*$arrow_length]  $arrow_angle]
              set p_arrow_start  [vector_calc::VSub  $p_dim_start  $dim_vct]
              set p_arrow_end    [vector_calc::VAdd  $p_dim_end    $dim_vct]
              foreach {x1 y1} $p_dim_start   {x3 y3} $p_dim_end   \
                      {x2 y2} $p_arrow_start {x4 y4} $p_arrow_end        break
        
              $w create line  $x1 $y1 $x2 $y2  -tags dimension   -fill $colour  -width $line_width
              $w create line  $x3 $y3 $x4 $y4  -tags dimension   -fill $colour  -width $line_width
           }
        draw_arrow $w  $p_dim_start  [expr 180+$arrow_angle]   $line_width  $arrow_length  dimension  $colour  
        draw_arrow $w  $p_dim_end    $arrow_angle              $line_width  $arrow_length  dimension  $colour  

       
       
       #  ---------------------------------------------
           #  dimension text
        set new_vct_dir [vector_calc::vect_orient_dir_lr  $p_dim_start  $p_dim_end  $switch_direction]
        set p01         [list [lindex $new_vct_dir 0] [lindex $new_vct_dir 1] ]
        set p02         [list [lindex $new_vct_dir 2] [lindex $new_vct_dir 3] ]
        set xy          [vector_calc::VSub $p02 $p01]
        set angle       [vector_calc::direction  $p01  $p02]
        set angle     [ eval format "%0.1f" $angle ]
	
        set angle [expr $angle + 180 ] 

           #draw_arrow $w  $dim_line_center  $angle  $line_width  $arrow_length  dimension  orange  

           #$w create text  [lindex $p01_txt 0] [lindex $p01_txt 1]   -text "A"
           #$w create text  [lindex $p02_txt 0] [lindex $p02_txt 1]   -text "B"
           #set p_text      [vector_calc::VAdd $dim_line_center {40 20}] 
           #$w create text  [lindex $p_text 0]  [lindex $p_text 1]   -fill orange  -text "$angle"
       
        set text_center  [ vector_calc::rotate_line  $dim_line_center  $font_dist  [expr $angle-90] ]
              
        vectorfont::setposition [lindex $text_center 0] [lindex $text_center 1]
        vectorfont::setcolor    $colour
        vectorfont::setangle    [expr 180 + $angle]
        vectorfont::setalign    "s"
        vectorfont::setline     $line_width
        vectorfont::setscale    $font_size
                            #   [expr $font_size/8]
        
        set dim_text   [dim_text_format $dim_value]
        
        if {$DIMENSION_Style == "vector"} {
             set dim [vectorfont::drawtext $w $dim_text]
             $w scale $dim  [lindex $text_center 0] [lindex $text_center 1]  1 -1
        } else {
             set dim   [ standardfont  $w  [lindex $text_center 0]  [lindex $text_center 1]  $dim_text  $colour]
        }
        $w addtag dimension withtag $dim 
        $w addtag dim_text  withtag $dim
        
        
       #  ---------------------------------------------
           #  dimension text offset
        if {$dim_offset != 0.0} {
              set offset_vct   [vector_calc::VSub    $p_dim_start  $dim_line_center]
              foreach {x y} $offset_vct   break
              set offset_vct_l     [expr {hypot($x,$y)}]
              if { $offset_vct_l != 0 } {
                     set offset_move  [vector_calc::VAdd   {0 0}  $offset_vct  [expr $dim_offset/$offset_vct_l] ]
                     set offset_move  [vector_calc::VSub   {0 0}  $offset_move ]
                       # -- text ----------
                     $w move $dim [lindex $offset_move 0]  [lindex $offset_move 1]  
                       # -- line ----------
                     set p_dim_ext [vector_calc::VAdd $dim_line_center $offset_move]
                     foreach {x1 y1} $dim_line_center   break  
                     foreach {x2 y2} $p_dim_ext  break  
                     $w create line  $x1 $y1 $x2 $y2  -tags dimension   -fill $colour  -width $line_width
              }
        }
        return

   }   

       
       #-------------------------------------------------------------------------
           #  
           #
   proc create_centerline {w p1 p2 tag} {
   
        set line_width    [compute_size line]
        
          # tk_messageBox -message "   $tag"
        $w create line    [ lindex $p1  0 ]  [ lindex $p1  1 ]  \
	                  [ lindex $p2  0 ]  [ lindex $p2  1 ]  \
	          -dash       {15 1 1 1} \
	          -tags       [list $tag] \
	          -fill       gray \
	          -width      $line_width
       }   


       #-------------------------------------------------------------------------
           #  
           #
   proc draw_arrow { w p arc lw al {geometry_id debug} {colour black} } {
        
        foreach {x y} $p break
        
        set  asl  [expr $al/[expr cos([expr 15*(4*atan(1))/180])]]
        
          # tk_messageBox -message "asl   $asl"
        set  p1   [vector_calc::rotate_line  $p  $asl  [expr $arc+7.5]]
        set  p2   [vector_calc::rotate_line  $p  $asl  [expr $arc-7.5]]
        
        $w create line   [lindex $p   0]  [lindex $p   1] \
                         [lindex $p1  0]  [lindex $p1  1] \
                         [lindex $p2  0]  [lindex $p2  1] \
                         [lindex $p   0]  [lindex $p   1] \
                     -tags   $geometry_id  \
                     -fill   $colour       \
	             -width  $lw
        
       }   


       #-------------------------------------------------------------------------
           #  
           #
   proc draw_circle { w p r {geometry_id debug} {colour black} {lw 1}} {
        foreach {x y} $p break
        
        $w create oval  [ expr  $x - $r ]  [ expr  $y - $r ]  \
                        [ expr  $x + $r ]  [ expr  $y + $r ]  \
               -tags [ list $geometry_id]  -outline $colour
       }   

 }
  
