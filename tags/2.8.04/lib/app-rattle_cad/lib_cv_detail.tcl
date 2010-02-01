# -----------------------------------------------------------------------------------
#
#: Functions : namespace      G E O M E T R Y
#

 namespace eval detail {
 
   variable   DETAIL
   array set  DETAIL     { FORMAT              A1
                           FORMAT_Scale        0.5
                           FORMAT_Settings    {}
                           PAGE_Scale          1.0
                           Border_X           50
                           Border_Y           30
                           FRAME_Centerline   on
                           FRAME_Dimension    on
                           TUBE_Dimension     off
                           JIG_Dimension      off
                         }

   variable   DIMENSION
   array set  DIMENSION  { Size            3
                           Style           standard
                         }
                           # Size            4
                           # Style           vector

   variable  p_out
   variable  p_ifr
     
   array set p_out            {}
   array set p_ifr            {}
                                               

   variable  DRAWING_FORMAT_Settings
   array set DRAWING_FORMAT_Settings   {}

   variable  SCREEN_Solution  [expr 72/25.4]

   
   #-------------------------------------------------------------------------
       #  create drafting
       #
   proc create { w } {
        
            variable DETAIL
            variable bb_position
            variable DIMENSION
            variable SCREEN_Solution
            variable DRAWING_FORMAT_Settings
        

        ::Debug  p  1
        
        
        catch [ lib_canvas::delete_item      $w  all ]
        
          # debug::create
          # draft_settings 
        
        ::Debug  a  DRAWING_FORMAT_Settings  1
        
        vectorfont::setscale  1.0

        set       format_settings          $drafting::DRAWING_FORMAT($DETAIL(FORMAT))
        array set DRAWING_FORMAT_Settings  [ list length       [lindex $format_settings 0] \
                                                  height       [lindex $format_settings 1] \
                                                  font_large   [lindex $format_settings 2] \
                                                  font_medium  [lindex $format_settings 3] \
                                                  font_small   [lindex $format_settings 4] \
                                                  line_large   [expr 0.1*[lindex $format_settings 2] ] \
                                                  line_medium  [expr 0.1*[lindex $format_settings 3] ] \
                                                  line_small   [expr 0.1*[lindex $format_settings 4] ]  
                                           ]

        
        dimension::configure  style   $DIMENSION(Style)
        dimension::configure  size    24
        dimension::configure  dist    5
        dimension::configure  line    1

        
          # control::update_parameter  _complete 
          # geometry::compute_bb_wheel_headtube
          # geometry::compute_frame_geometry
          # geometry::compute_frame_outlines



          # -- centerlines --
        set   tag                            frame_centerlines   
        catch [lib_canvas::delete_item       $w  $tag  ]
       
       
          # -- outlines -----
        geometry::draw_frame                     $w  geometry::CURRENT_Project  $tag  $DRAWING_FORMAT_Settings(line_large)  black  outline
        geometry::draw_fork                      $w  geometry::CURRENT_Project  $tag  $DRAWING_FORMAT_Settings(line_large)  black  outline
          # geometry::draw_frame_outlines        $w  $tag  $DRAWING_FORMAT_Settings(line_large)  black



          # -- centerlines --
        drafting::create_frame_centerlines   $w  $tag  dimension 
        drafting::create_frame_centerlines   $w  $tag  centerline


          # -- dimension ----
        create_detail_dimensions             $w


        lib_canvas::recenter       $w  $DETAIL(FORMAT_Scale)  all  

        lib_canvas::mirror         $w
        
        
        $w itemconfigure dim_text -fill red
        

        resize                     $w  
        
        return

   }
   
   

   #-------------------------------------------------------------------------
       #  reset_scrollbar
       #
   proc resize { w } {
            
            variable DETAIL         
            variable DIMENSION
            variable SCREEN_Solution

        ::Debug  p  1
        
        
          # -- remove previous bbox for scale/move
        lib_canvas::display_bbox    $w  delete 

          # -- unscale canvas
        $w  scale              all   0  0  [expr 1.0/$DETAIL(FORMAT_Scale)]  [expr 1.0/$DETAIL(FORMAT_Scale)]
           
          # -- get new scale
        set DETAIL(FORMAT_Scale)     [lib_canvas::compute_scale  $w  all  $DETAIL(Border_X)  $DETAIL(Border_Y) ]
          
          # -- scale and recenter to canvas
        lib_canvas::recenter    $w   $DETAIL(FORMAT_Scale)   
          
          # -- orient south
        set bbox_all_source_y        [lindex  [$w bbox all]  3 ]
        set bbox_all_target_y        [expr  [winfo height $w] - $DETAIL(Border_Y)]        
        set move_y                   [expr  $bbox_all_target_y - $bbox_all_source_y ]
        $w  move                all  0  $move_y 
        $w  move                all  0  -30 
        
          # -- dimension settings
        dimension::configure  stdfscl  $DETAIL(FORMAT_Scale)
        dimension::configure  stdfont  [expr  $DIMENSION(Size)*$SCREEN_Solution/$DETAIL(FORMAT_Scale)]
        dimension::configure  style    $DIMENSION(Style)
        dimension::configure  size     [expr  $DIMENSION(Size)*$SCREEN_Solution/$DETAIL(FORMAT_Scale)]
        dimension::configure  dist     [expr  1.0*$SCREEN_Solution/$DETAIL(FORMAT_Scale)]
        dimension::configure  line     [expr  0.5*$SCREEN_Solution]
 
          # -- create bbox for zoom/move
            ::Debug  t  "bbox size    [$w bbox all]" 
        lib_canvas::display_bbox       $w  create 
            ::Debug  t  "bbox size    [$w bbox all]" 
        
          # -- reset absolute position of canvas
        $w configure -scrollregion     [list  0  0  [winfo width $w]  [winfo height $w] ]

        return
   }
   
   
   
   #-------------------------------------------------------------------------
       #  detail_scale
       #
   proc detail_scale { {scale {}} } {
            
            variable DETAIL
            
        ::Debug  p  1
        
        
            ::Debug  t " $scale $FRAME(Reposition_Scale) "
        if {$scale == {} } {
            return $DETAIL(FORMAT_Scale)
        } 
        
          #
          # 1st 
          # -- modify scale parameter from extern
        set DETAIL(Reposition_Scale)  [expr $scale*$DETAIL(FORMAT_Scale)]
        
        return
        
   }



   #-------------------------------------------------------------------------
       #  create detail dimensions
       #
   proc create_detail_dimensions { w } {        
            
          variable CURRENT_Project
          global  _CURRENT_Project
          global  _OUT_Line
            
          variable  DRAFTING  
          array set DRAFTING  [array get drafting::DRAFTING]
            
        
        ::Debug  p  1

        set      tag          detail_dimensions   
        set      dim_colour   blue   

        
        
        
        catch [lib_canvas::delete_item      $w  $tag ]
        
          # -- head - tube ---------
        dimension::length  $w  [lindex $geometry::OUT_Line(frame)   6]  [lindex $geometry::OUT_Line(frame)   7]    70    0   $tag  $dim_colour        
        dimension::length  $w  [lindex $geometry::OUT_Line(frame)   7]  [lindex $geometry::OUT_Line(frame)   8]    70  -40   $tag  $dim_colour        
        dimension::length  $w  [lindex $geometry::OUT_Line(frame)   3]  [lindex $geometry::OUT_Line(frame)   4]    70   80   $tag  $dim_colour        
   
          # -- top - tube ----------
        dimension::length  $w  [lindex $geometry::OUT_Line(frame)   9]  [lindex $geometry::OUT_Line(frame)   34]   90  -40   $tag  $dim_colour        
        dimension::length  $w  [lindex $geometry::OUT_Line(frame)  10]  [lindex $geometry::OUT_Line(frame)   33]  -40  -40   $tag  $dim_colour        
  
          # -- down - tube ---------
        dimension::length  $w  [lindex $geometry::OUT_Line(frame)   2]  [lindex $geometry::OUT_Line(frame)   37]   -90   40   $tag  $dim_colour        
        dimension::length  $w  [lindex $geometry::OUT_Line(frame)   1]  [lindex $geometry::OUT_Line(frame)   38]   -20  -70   $tag  $dim_colour        
       
          # -- seat - tube ---------
        dimension::length  $w  [lindex $geometry::OUT_Line(frame)  12]  [lindex $geometry::OUT_Line(frame)  13]    70    0   $tag  $dim_colour        
        dimension::length  $w  [lindex $geometry::OUT_Line(frame)  21]  [lindex $geometry::OUT_Line(frame)  30]    20  -70   $tag  $dim_colour        
        dimension::length  $w  [lindex $geometry::OUT_Line(frame)  11]  [lindex $geometry::OUT_Line(frame)  12]    40   60   $tag  $dim_colour        
 
          # -- seat - stay ---------
        dimension::length  $w  $geometry::CURRENT_Project(CENTER_TopTube_Seat) \
                                                         $geometry::CURRENT_Project(CENTER_SeatStay_Top) 60  -80   $tag  $dim_colour        
        dimension::length  $w  [lindex $geometry::OUT_Line(frame)  15]  [lindex $geometry::OUT_Line(frame)  18]   -40  -40   $tag  $dim_colour        
        dimension::length  $w  [lindex $geometry::OUT_Line(frame)  16]  [lindex $geometry::OUT_Line(frame)  17]   -40  -40   $tag  $dim_colour        
          
           set p_sstay_do  [mathematic::VAdd  [lindex $geometry::OUT_Line(frame)  16]  [mathematic::VSub  [lindex $geometry::OUT_Line(frame)   17]  [lindex $geometry::OUT_Line(frame)  16]] 0.5]
           set p_sstay     [mathematic::VAdd  [lindex $geometry::OUT_Line(frame)  15]  [mathematic::VSub  [lindex $geometry::OUT_Line(frame)   18]  [lindex $geometry::OUT_Line(frame)  15]] 0.5]
        dimension::length  $w  $p_sstay_do               $p_sstay                      -90    0   $tag  $dim_colour        

          # -- chain - stay --------
        dimension::length  $w  [lindex $geometry::OUT_Line(frame)  26]  [lindex $geometry::OUT_Line(frame)  23]   -60  -80   $tag  $dim_colour        
        dimension::length  $w  [lindex $geometry::OUT_Line(frame)  24]  [lindex $geometry::OUT_Line(frame)  25]   -40   80   $tag  $dim_colour        
         
           set p_cstay_do  [mathematic::VAdd  [lindex $geometry::OUT_Line(frame)  25]  [mathematic::VSub  [lindex $geometry::OUT_Line(frame)   24]  [lindex $geometry::OUT_Line(frame)  25]] 0.5]
           set p_cstay     [mathematic::VAdd  [lindex $geometry::OUT_Line(frame)  26]  [mathematic::VSub  [lindex $geometry::OUT_Line(frame)   23]  [lindex $geometry::OUT_Line(frame)  26]] 0.5]
        dimension::length  $w  $p_cstay_do               $p_cstay                       90    0   $tag  $dim_colour        

		
          # -- fork - crown --------
       if {$control::CURRENT_Config(Fork_Type) == {rigid} } {
	   dimension::length  $w  [lindex $geometry::OUT_Line(fork)  1]  [lindex $geometry::OUT_Line(fork)  2]   -20  -80   $tag  $dim_colour        
       }  

   }        



   #-------------------------------------------------------------------------
       #  print_postscript
       #
   proc print_postscript { w } {
            
            variable DRAWING_FORMAT_Settings
        
        ::Debug  p  1
  	     

          # tk_messageBox -message " print_postscript"
        set bbox      [$w bbox detail_frame]
        set bbox_size [lib_canvas::get_rect_info  size  [$w bbox detail_frame] ]
        set bbox_x    [lindex $bbox_size 0]
        set bbox_y    [lindex $bbox_size 1]
        set cv_size   [lib_canvas::size $w]
        
          # debug::create
        ::Debug  t  "bbox         $bbox"       1
        ::Debug  t  "bbox size    $bbox_size"  1
        ::Debug  t  "bbox size x  $bbox_x"     1
        ::Debug  t  "bbox size y  $bbox_y"     1
        ::Debug  t  "cv   size   $cv_size"     1
        
        
        file::get_user_dir
        ::Debug  t  "file::get_user_dir   $file::user_dir"     1

        set w_name          [winfo name $w]
        set printfile_name  [file join $file::user_dir __print_$w_name.ps]
        ::Debug  t  "printfile_name   $printfile_name"     1
        
        $w postscript  -file        $printfile_name \
                       -rotate      1         \
                       -width       $bbox_x   \
                       -height      $bbox_y   \
                       -x           [lindex $bbox 0] \
                       -y           [lindex $bbox 1] \
                       -pagewidth   $DRAWING_FORMAT_Settings(length)m \
                       -pageheight  $DRAWING_FORMAT_Settings(height)m \
                       -pageanchor  sw \
                       -pagex       $DRAWING_FORMAT_Settings(height)m \
                       -pagey       0m
        
        ::start_psview  $printfile_name
   }



     #-------------------------------------------------------------------------
     #
     #  end  namespace eval detail 
     #

 }
  
