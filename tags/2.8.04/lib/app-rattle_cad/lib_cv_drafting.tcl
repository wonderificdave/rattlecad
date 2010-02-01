# -----------------------------------------------------------------------------------
#
#: Functions : namespace      G E O M E T R Y
#

 namespace eval drafting {
 
   variable   DRAFTING
   array set  DRAFTING   { FORMAT              A4
                           FORMAT_Scale       0.2
                           FORMAT_Settings    {}
                           PAGE_Scale         1.0
                           FRAME_Centerline   on
                           FRAME_Dimension    on
                           TUBE_Dimension     off
                           JIG_Dimension      off
                         }

   variable   DIMENSION
   array set  DIMENSION  { Size            4
                           Style           vector
                         }
               # DIMENSION(Style)          standard
                                               

   variable  DRAWING_FORMAT
   array set DRAWING_FORMAT   [ list  {A0}  { 1189  841   10.0  7.5  5.0 } \
   				      {A1}  {  841  595    7.0  5.0  3.5 } \
   				      {A2}  {  595  420    7.0  5.0  3.5 } \
   				      {A3}  {  420  297    5.0  3.5  2.5 } \
   				      {A4}  {  297  210    5.0  3.5  2.5 } \
   			      ]
   variable  DRAWING_FORMAT_Settings
   array set DRAWING_FORMAT_Settings   {}

   variable  SCREEN_Solution  [expr 72/25.4]

   
   #-------------------------------------------------------------------------
       #  create drafting
       #
   proc create { w } {
        
          variable DRAFTING
          variable bb_position
          variable DIMENSION
          variable SCREEN_Solution
          variable DRAWING_FORMAT_Settings
          
          global  _CURRENT_Project
            

        ::Debug  p  1
        
        
        catch [ lib_canvas::delete_item      $w  all ]
        
          # debug::create
        draft_settings        $DRAFTING(FORMAT)
        
        ::Debug  a  DRAWING_FORMAT_Settings  1
        
        vectorfont::setscale  1.0

        dimension::configure  style   $DIMENSION(Style)
        dimension::configure  size    [expr $DRAWING_FORMAT_Settings(font_small)/$DRAFTING(FORMAT_Scale)]
        dimension::configure  dist    [expr $SCREEN_Solution * 1.0]
        dimension::configure  line    [expr $DRAWING_FORMAT_Settings(line_small)]

        update
        
        
        control::update_parameter  _complete 
          # geometry::compute_bb_wheel_headtube
          # geometry::compute_frame_geometry
          # geometry::compute_frame_outlines


          # -- outlines -----
        geometry::draw_frame                     $w  geometry::CURRENT_Project  frame_outline  $DRAWING_FORMAT_Settings(line_large)  black  outline
		geometry::draw_fork                      $w  geometry::CURRENT_Project  frame_outline  $DRAWING_FORMAT_Settings(line_large)  black  outline
          # geometry::draw_frame                     $w  frame_outline  $DRAWING_FORMAT_Settings(line_large)  black  outline
          # geometry::draw_frame_outlines          $w  frame_outline  $DRAWING_FORMAT_Settings(line_large)  black


          # -- centerlines --
        set   tag                           frame_centerlines   
        catch [lib_canvas::delete_item      $w  $tag  ]
        if { $DRAFTING(FRAME_Centerline) == "on" } { create_frame_centerlines  $w  $tag  centerline }
        if { $DRAFTING(FRAME_Dimension)  == "on" } { create_frame_centerlines  $w  $tag  dimension }
        if { $DRAFTING(TUBE_Dimension)   == "on" } { create_frame_centerlines  $w  $tag  tube_dimension }
        if { $DRAFTING(JIG_Dimension)    == "on" } { create_frame_centerlines  $w  $tag  jig_dimension }


        # -- dimensions ---
        create_frame_dimensions    $w


        update
        
        lib_canvas::recenter       $w  $DRAFTING(FORMAT_Scale)  all

        drafting_frame             $w  $DRAWING_FORMAT_Settings(length)  $DRAWING_FORMAT_Settings(height) drafting_frame
        
        lib_canvas::recenter       $w  $SCREEN_Solution     all

        lib_canvas::mirror         $w
        
        resize                     $w  drafting_frame

        lib_canvas::recenter       $w  0.92

        drafting_frame_shadow      $w  drafting_frame  drafting_shadow

        drafting_background        $w  drafting_background  lightgray
        
        $w  configure              -bg  lightgray

   }
   
   
   #-------------------------------------------------------------------------
       #  reset_scrollbar
       #
   proc draft_settings {format} {
            
            variable DRAFTING
            variable DRAWING_FORMAT
            variable DRAWING_FORMAT_Settings
        
        ::Debug  p  1

        set format_settings  $DRAWING_FORMAT($format)
          # set format_settings  $DRAWING_FORMAT($DRAFTING(FORMAT))
        
        array set DRAWING_FORMAT_Settings [ list length       [lindex $format_settings 0] \
                                                 height       [lindex $format_settings 1] \
                                                 font_large   [lindex $format_settings 2] \
                                                 font_medium  [lindex $format_settings 3] \
                                                 font_small   [lindex $format_settings 4] \
                                                 line_large   [expr 0.1*[lindex $format_settings 2] ] \
                                                 line_medium  [expr 0.1*[lindex $format_settings 3] ] \
                                                 line_small   [expr 0.1*[lindex $format_settings 4] ]  
                                          ]
   }


   #-------------------------------------------------------------------------
       #  reset_scrollbar
       #
   proc resize { w {tag all}} {
        
        ::Debug  p  1
        
        set scale       [lib_canvas::compute_scale  $w ]
        lib_canvas::recenter        $w  $scale  $tag
        	
        $w configure -scrollregion  [$w bbox all]
        $w configure -scrollregion  {}
   }
   
   
   #-------------------------------------------------------------------------
       #  print_postscript
       #
   proc print_postscript { w } {
            
            variable DRAFTING
            variable DRAWING_FORMAT_Settings
        
        ::Debug  p  1
  	     

          # tk_messageBox -message " print_postscript"
        set bbox      [$w bbox drafting_frame]
        set bbox_size [lib_canvas::get_rect_info  size  [$w bbox drafting_frame] ]
        set bbox_x    [lindex $bbox_size 0]
        set bbox_y    [lindex $bbox_size 1]
        set cv_size   [lib_canvas::size $w]
        
          # debug::create
        ::Debug  t  "bbox         $bbox"       1
        ::Debug  t  "bbox size    $bbox_size"  1
        ::Debug  t  "bbox size x  $bbox_x"     1
        ::Debug  t  "bbox size y  $bbox_y"     1
        ::Debug  t  "cv   size   $cv_size"     1
        
        
        control::get_user_dir
        ::Debug  t  "control::get_user_dir   $control::USER_Dir"     1

        set w_name          [winfo name $w]
        set printfile_name  [file join $control::USER_Dir __print_$w_name.ps]
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
       #  create drafting_frame
       #
   proc drafting_frame { w x y tag} {
        
            variable DRAFTING
            variable SCREEN_Solution
            variable DRAWING_FORMAT_Settings

        ::Debug  p  1
        
        global APPL_Env

        set   b_with 5

        catch [lib_canvas::delete_item   $w  $tag  ]
        
          
          # -- create drafting frame
        
        set cv_center       [lib_canvas::get_rect_info  center  [list 0 0 [winfo width $w] [winfo height $w] ] ]
        foreach {x0 y0} $cv_center break
        
        
        set x1  [expr $x0 - 0.5*$x]
        set y1  [expr $y0 - 0.5*$y]
        set x2  [expr $x0 + 0.5*$x]
        set y2  [expr $y0 + 0.5*$y]
        
         
          # -- create drafting frame
        $w create rectangle   $x1  $y1  $x2  $y2  \
                              -tags    $tag       \
                              -fill    white      \
                              -outline black      \
                              -width 0.1
        
        
        set x1  [expr $x1 + $b_with]
        set y1  [expr $y1 + $b_with]
        set x2  [expr $x2 - $b_with]
        set y2  [expr $y2 - $b_with]

        $w create rectangle   $x1  $y1  $x2  $y2  \
                              -tags     $tag      \
                              -outline  black     \
                              -width    $DRAWING_FORMAT_Settings(line_large)
        
        
          # -- description_box
        set desc_size_x     170
        set desc_inside_x1   15
        set desc_inside_x2   [expr $desc_inside_x1 + 70]
        
        set desc_size_y      20
        set desc_inside_y1   11
        
        set x1  [expr $x2 - $desc_size_x]
        set y1  [expr $y1 - 0]
        set x2  [expr $x2 - 0]
        set y2  [expr $y1 + $desc_size_y]

        $w create rectangle   $x1  $y1  $x2  $y2 \
                              -tags      $tag         \
                              -outline   black     \
                              -width     $DRAWING_FORMAT_Settings(line_large)
                              
        set yi  [expr $y1+$desc_inside_y1]
        $w create line        $x1  $yi  $x2  $yi \
                              -tags      $tag         \
                              -fill      black        \
                              -width     $DRAWING_FORMAT_Settings(line_large)
        
        set xi1  [expr $x1+$desc_inside_x1]        
        $w create line        $xi1  $y1  $xi1 $y2 \
                              -tags      $tag         \
                              -fill      black        \
                              -width     $DRAWING_FORMAT_Settings(line_large)
        
        set xi2  [expr $x1+$desc_inside_x2]        
        $w create line        $xi2  $yi  $xi2  $y2 \
                              -tags      $tag         \
                              -fill      black        \
                              -width     $DRAWING_FORMAT_Settings(line_large)
                              
        
          # -- move to bottom of stacking order
        $w lower $tag all


          # -- fill in into description field
                              
          # ----------------------------
        vectorfont::setcolor    black
        vectorfont::setalign    "nw"
        vectorfont::setangle    0
        vectorfont::setline     0.5
        vectorfont::setscale    [expr 5.0/(10*$SCREEN_Solution)]
            # vectorfont::setline     $DRAWING_FORMAT_Settings(line_large)
            # vectorfont::setscale    [expr $DRAWING_FORMAT_Settings(font_large)/(10*$SCREEN_Solution)]
          
          # -----------------------------
          # | FMT |  |  |
          # -----------------------------
          # |     |     |
          # -----------------------------
        vectorfont::setposition [expr $x1 + 4] [expr $yi+1.5]
        set field_1a   [vectorfont::drawtext $w "$DRAFTING(FORMAT)"]    
        dimension::flip_vectortext $w $field_1a  


          # -----------------------------
          # |  | rattleCAD Version|   |
          # -----------------------------
          # |  |                      |
          # -----------------------------
        vectorfont::setposition [expr $xi1 + 3] [expr $yi+1.5]
        set field_1b   [vectorfont::drawtext $w "rattleCAD  V$APPL_Env(RELEASE_Version).$APPL_Env(RELEASE_Revision)"]    
        dimension::flip_vectortext $w $field_1b  
          
          # -----------------------------
          # |       |  |  |
          # -----------------------------
          # | Scale |     |
          # -----------------------------
        set scale_factor [dimension::dim_text_format [expr 1/$DRAFTING(FORMAT_Scale)] ]
        vectorfont::setposition [expr $x1 + 4] [expr $y1+2.5]
        set field_2a   [vectorfont::drawtext $w "1:$scale_factor"]    
        dimension::flip_vectortext $w $field_2a  
        


        vectorfont::setalign    "ne"
        vectorfont::setline     0.35
        vectorfont::setscale    [expr 3.5/(10*$SCREEN_Solution)]
            # vectorfont::setline     $DRAWING_FORMAT_Settings(line_medium)
            # vectorfont::setscale    [expr $DRAWING_FORMAT_Settings(font_medium)/(10*$SCREEN_Solution)]

          # -----------------------------
          # |     |  | Datum |
          # -----------------------------
          # |  |  |          |
          # -----------------------------
        set date_string [clock format [clock seconds] -format {%Y.%m.%d %H:%M}]
        vectorfont::setposition [expr $x2 - 5] [expr $yi+1.5]
        set field_1c   [vectorfont::drawtext $w "$date_string" ]
        dimension::flip_vectortext $w $field_1c  

          # -----------------------------
          # |  |  |   |
          # -----------------------------
          # |  | File |
          # -----------------------------
        if { [file isfile $control::current_filename] } {
            set filename [file tail $control::current_filename]
        } else {
            set filename "no project ..."
        }
        vectorfont::setposition [expr $x2 - 5] [expr $y1+2.5]
        set field_2b   [vectorfont::drawtext $w "$filename"]    
        dimension::flip_vectortext $w $field_2b  

   }
    

   #-------------------------------------------------------------------------
       #  create drafting_frame_shadow
       #
   proc drafting_frame_shadow { w reference_tag tag} {
        
        ::Debug  p  1

        catch [lib_canvas::delete_item   $w  $tag  ]
        
          
          ;# -- get bbox of reference_tag
        set bbox_ref       [$w bbox $reference_tag]
        foreach {x0 y0 x1 y1} $bbox_ref break
        
       
          ;# -- create drafting frame - shadow
        set x1 [expr $x1 - 1]
        $w create rectangle   $x0  $y0  $x1  $y1    \
                              -tags    $tag         \
                              -fill    black     \
                              -outline black     \
                              -width   0

        $w move  $tag  8 8

        $w lower $tag all

   }
    

   #-------------------------------------------------------------------------
       #  create drafting_background
       #
   proc drafting_background { w tag colour} {
        
        ::Debug  p  1

        catch [lib_canvas::delete_item   $w  $tag  ]
        
        set cv_size    [lib_canvas::size $w]
        #set cv_bbox_0  {1 1}
        #set cv_bbox_1  [mathematic::VSub $cv_size {1 1}]
       
        #foreach {x0 y0} $cv_bbox_0 break
        #foreach {x1 y1} $cv_bbox_1 break
        
        foreach  {x1 y1} $cv_size break
       
        $w  create  rectangle  0  0  $x1  $y1    \
                              -outline  $colour  \
                              -fill     $colour  \
                              -tag      $tag     \
                              -width    0

        $w lower $tag all

   }
    

   #-------------------------------------------------------------------------
       #  create frame centerlines
       #
   proc create_frame_centerlines { w tag type } {
            
            global   _CURRENT_Project            
            variable DRAFTING

        ::Debug  p  1

           # lib_canvas::draw_circle      $w  $CURRENT_Project(TAPER_TopTube_Seat)      50  $tag  orange 5
           # lib_canvas::draw_circle      $w  $CURRENT_Project(TAPER_TopTube_Head)      50  $tag  orange 5
           # lib_canvas::draw_circle      $w  $CURRENT_Project(TAPER_DownTube_BB)       50  $tag  orange 5
           # lib_canvas::draw_circle      $w  $CURRENT_Project(TAPER_DownTube_Head)     50  $tag  orange 5
           # lib_canvas::draw_circle      $w  $CURRENT_Project(TAPER_SeatTube_BB)       50  $tag  orange 5
           # lib_canvas::draw_circle      $w  $CURRENT_Project(TAPER_SeatTube_Top)      50  $tag  orange 5

        switch $type {

            dimension {
                lib_canvas::draw_circle $w $geometry::CURRENT_Project(CENTER_BottomBracket)  5 $tag gray 1 {}
                lib_canvas::draw_circle $w $geometry::CURRENT_Project(CENTER_RearWheel)      5 $tag gray 1 {}
                lib_canvas::draw_circle $w $geometry::CURRENT_Project(CENTER_FrontWheel)     5 $tag gray 1 {}
                lib_canvas::draw_circle $w $geometry::CURRENT_Project(CENTER_ForkPoint)      5 $tag gray 1 {}
                lib_canvas::draw_circle $w $geometry::CURRENT_Project(CENTER_ForkCut)        5 $tag gray 1 {}
        
                lib_canvas::draw_circle $w $geometry::CURRENT_Project(CENTER_HeadTube_Top)   5 $tag gray 1 {}
                lib_canvas::draw_circle $w $geometry::CURRENT_Project(CENTER_SeatTube_Top)   5 $tag gray 1 {}
                lib_canvas::draw_circle $w $geometry::CURRENT_Project(CENTER_LUG_HeadBottom) 5 $tag gray 1 {}
                lib_canvas::draw_circle $w $geometry::CURRENT_Project(CENTER_LUG_HeadTop)    5 $tag gray 1 {}
                lib_canvas::draw_circle $w $geometry::CURRENT_Project(CENTER_LUG_SeatTop)    5 $tag gray 1 {}

                lib_canvas::draw_circle $w $geometry::CURRENT_Project(CENTER_Stem)           5 $tag gray 1 {}
                lib_canvas::draw_circle $w $geometry::CURRENT_Project(CENTER_HandleBar)      5 $tag gray 1 {}
				
                lib_canvas::draw_circle $w $geometry::CURRENT_Project(CENTER_RearBrake)      5 $tag gray 1 {}        
                lib_canvas::draw_circle $w $geometry::CURRENT_Project(CENTER_RearBrakePad)   5 $tag gray 1 {}        
        
                lib_canvas::draw_arc    $w $geometry::CURRENT_Project(CENTER_RearWheel)      [expr 0.5*$geometry::CURRENT_Project(Wheel_Rear_Diameter) ]    $tag -15 110 gray 1
                lib_canvas::draw_arc    $w $geometry::CURRENT_Project(CENTER_RearWheel)      [expr 0.5*$control::CURRENT_Config(Wheel_Rear_Rim_Diameter)]   $tag  25  65 gray 1
                lib_canvas::draw_arc    $w $geometry::CURRENT_Project(CENTER_FrontWheel)     [expr 0.5*$geometry::CURRENT_Project(Wheel_Front_Diameter)]    $tag  90 100 gray 1
                lib_canvas::draw_arc    $w $geometry::CURRENT_Project(CENTER_FrontWheel)     [expr 0.5*$control::CURRENT_Config(Wheel_Front_Rim_Diameter)]  $tag  95  60 gray 1
              }
           
            centerline {
                dimension::create_centerline $w  $geometry::CURRENT_Project(CENTER_BottomBracket)  $geometry::CURRENT_Project(CENTER_RearWheel)        $tag
                dimension::create_centerline $w  $geometry::CURRENT_Project(CENTER_BottomBracket)  $geometry::CURRENT_Project(CENTER_SeatTube_Top)     $tag
                dimension::create_centerline $w  $geometry::CURRENT_Project(CENTER_BottomBracket)  $geometry::CURRENT_Project(CENTER_DownTube_Head)    $tag
        
                dimension::create_centerline $w  $geometry::CURRENT_Project(CENTER_RearWheel)      $geometry::CURRENT_Project(CENTER_SeatStay_Top)     $tag
      
                dimension::create_centerline $w  $geometry::CURRENT_Project(CENTER_Stem)           $geometry::CURRENT_Project(CENTER_ForkPoint)        $tag
                dimension::create_centerline $w  $geometry::CURRENT_Project(CENTER_Stem)           $geometry::CURRENT_Project(CENTER_HandleBar)        $tag
        
                dimension::create_centerline $w  $geometry::CURRENT_Project(CENTER_TopTube_Seat)   $geometry::CURRENT_Project(CENTER_TopTube_Head)     $tag
        
                dimension::create_centerline $w  $geometry::CURRENT_Project(CENTER_FrontWheel)     [mathematic::VSub  $geometry::CURRENT_Project(CENTER_FrontWheel)   {200 0}] \
                                                                                                                     $tag
              }
        
            jig_dimension {
                dimension::create_centerline $w  $geometry::CURRENT_Project(CENTER_RearWheel)      $geometry::CURRENT_Project(CENTER_FrontWheel)       $tag
                dimension::create_centerline $w  $geometry::CURRENT_Project(CENTER_JIG_Headtube)   $geometry::CURRENT_Project(CENTER_ForkCut)          $tag
                dimension::create_centerline $w  [list [expr [lindex $geometry::CURRENT_Project(CENTER_RearWheel) 0] - 80]\
				                                       [lindex $geometry::CURRENT_Project(CENTER_BottomBracket) 1] ] \
				                                                                                   $geometry::CURRENT_Project(CENTER_BottomBracket)    $tag

                lib_canvas::draw_circle      $w  $geometry::CURRENT_Project(CENTER_ForkCut)        5 $tag gray 1 {}
                lib_canvas::draw_circle      $w  $geometry::CURRENT_Project(CENTER_JIG_Headtube)   5 $tag gray 1 {}
                lib_canvas::draw_circle      $w  $geometry::CURRENT_Project(CENTER_JIG_Seattube)   5 $tag gray 1 {}
        
                dimension::create_centerline $w  $geometry::CURRENT_Project(CENTER_RearWheel)      $geometry::CURRENT_Project(CENTER_JIG_Headtube)     $tag
              }
              
            default {}
        }
                                                                                                           
   }
   
   
   #-------------------------------------------------------------------------
       #  create frame dimensions
       #
   proc create_frame_dimensions { w } {        
            
            variable DRAFTING
            
            global _CURRENT_Project
            global _OUT_Line
        
        ::Debug  p  1

        set      tag            frame_dimensions   
        set      dim_colour     blue4   
        set      dim_colour_1   red   
        set      dim_colour_2   blue   
        set      dim_colour_3   darkgray   

        catch [lib_canvas::delete_item      $w  $tag ]
        
        if { $DRAFTING(FRAME_Dimension) == "on" } {
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_BottomBracket)    $geometry::CURRENT_Project(CENTER_FrontWheel)         60.0     0   $tag  $dim_colour  
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_BottomBracket)    $geometry::CURRENT_Project(CENTER_RearWheel)         -60.0     0   $tag  $dim_colour  
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_RearWheel)        $geometry::CURRENT_Project(CENTER_FrontWheel)        190.0     0   $tag  $dim_colour  
        
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_BottomBracket)    $geometry::CURRENT_Project(CENTER_RearWheel)         -90.0     0   $tag  $dim_colour horizontal 
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_BottomBracket)    $geometry::CURRENT_Project(CENTER_FrontWheel)         90.0     0   $tag  $dim_colour horizontal 
            
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_ForkPoint)        $geometry::CURRENT_Project(CENTER_FrontWheel)        110.0    50   $tag  $dim_colour aligned      
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_ForkBase)         $geometry::CURRENT_Project(CENTER_ForkPoint)        -100.0     0   $tag  $dim_colour
            
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_ForkBase)         $geometry::CURRENT_Project(CENTER_HeadTube_Bottom)   100.0   -30   $tag  $dim_colour aligned      
          #return
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_BottomBracket)    $geometry::CURRENT_Project(CENTER_TopTube_Seat)      -90.0     0   $tag  $dim_colour  
          #return
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_SeatTube_Top)     $geometry::CURRENT_Project(CENTER_SeatStay_Top)       60.0   -60   $tag  $dim_colour aligned     
            dimension::length  $w  [lindex $geometry::OUT_Line(frame) 11]              [lindex $geometry::OUT_Line(frame) 12]                60.0     0   $tag  $dim_colour  
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_SeatTube_Top)     $geometry::CURRENT_Project(CENTER_TopTube_Seat)     -110.0     0   $tag  $dim_colour
          #return
            
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_BottomBracket)    $geometry::CURRENT_Project(CENTER_DownTube_Head)      60.0     0   $tag  $dim_colour  
        
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_DownTube_Head)    $geometry::CURRENT_Project(CENTER_TopTube_Head)       60.0     0   $tag  $dim_colour  
            
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_HeadTube_Bottom)  $geometry::CURRENT_Project(CENTER_DownTube_Head)      60.0     0   $tag  $dim_colour  
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_TopTube_Head)     $geometry::CURRENT_Project(CENTER_HeadTube_Top)       60.0     0   $tag  $dim_colour  
          #return
            
            dimension::length  $w  [lindex $geometry::OUT_Line(frame)  3]              [lindex $geometry::OUT_Line(frame)  4]                60.0    40   $tag  $dim_colour aligned      
            dimension::length  $w  [lindex $geometry::OUT_Line(frame)  8]              [lindex $geometry::OUT_Line(frame)  7]               -60.0    40   $tag  $dim_colour aligned       
           
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_TopTube_Seat)     $geometry::CURRENT_Project(CENTER_TopTube_Head)      -80.0     0   $tag  $dim_colour  
            
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_RearWheel)        $geometry::CURRENT_Project(CENTER_BottomBracket)     140.0   -60   $tag  $dim_colour vertical    
            
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_RearWheel)        $geometry::CURRENT_Project(CENTER_SeatStay_Top)     -180.0     0   $tag  $dim_colour  
            
			
			dimension::length  $w  $geometry::CURRENT_Project(CENTER_RearWheel)        $geometry::CURRENT_Project(CENTER_RearBrake)        -120.0     0   $tag  $dim_colour      
			dimension::length  $w  $geometry::CURRENT_Project(CENTER_RearBrakePad)     $geometry::CURRENT_Project(CENTER_RearBrakeAxis)     -30.0     0   $tag  $dim_colour      
			dimension::length  $w  $geometry::CURRENT_Project(CENTER_RearBrakePad)     [lindex $geometry::OUT_Line(frame)  15]               50.0     0   $tag  $dim_colour perpendicular [lindex $geometry::OUT_Line(frame)  14]   
          #return
            
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_ForkBase)         $geometry::CURRENT_Project(CENTER_Stem)              140.0     0   $tag  $dim_colour_2  aligned      
            dimension::length  $w  $geometry::CURRENT_Project(CENTER_HeadTube_Top)     $geometry::CURRENT_Project(CENTER_Stem)              100.0     0   $tag  $dim_colour_2  aligned      
            
            
            


               # -- different wheel-size
          if { [lindex $geometry::CURRENT_Project(CENTER_RearWheel) 1] != [lindex $geometry::CURRENT_Project(CENTER_FrontWheel) 1] } {

            dimension::length  $w  $geometry::CURRENT_Project(CENTER_BottomBracket)    $geometry::CURRENT_Project(CENTER_FrontWheel)        230.0    40   $tag  $dim_colour vertical 
            
          }

          #return
            
            
             # -- headtube
            dimension::angle   $w  $geometry::CURRENT_Project(CENTER_ForkCut)     \
                                   [list 0 [lindex $geometry::CURRENT_Project(CENTER_ForkCut) 1]]  \
                                   $geometry::CURRENT_Project(CENTER_ForkBase)         -120.0    0  $tag  $dim_colour_1  
                                   
             # -- seattube
            dimension::angle   $w  $geometry::CURRENT_Project(CENTER_BottomBracket) \
                                   [list -200 [lindex $geometry::CURRENT_Project(CENTER_BottomBracket) 1]]  \
                                   $geometry::CURRENT_Project(CENTER_SeatTube_Top)     -120.0    0  $tag  $dim_colour_1  
                             
             # -- seattube  - chainstay
            dimension::angle   $w  $geometry::CURRENT_Project(CENTER_BottomBracket) \
                                   $geometry::CURRENT_Project(CENTER_RearWheel)     \
                                   $geometry::CURRENT_Project(CENTER_SeatTube_Top)      -90.0    0  $tag  $dim_colour_1  
                                   
             # -- seattube  - downtube
            dimension::angle   $w  $geometry::CURRENT_Project(CENTER_BottomBracket) \
                                   $geometry::CURRENT_Project(CENTER_DownTube_Head) \
                                   $geometry::CURRENT_Project(CENTER_SeatTube_Top)       90.0    0  $tag  $dim_colour_1  
                                   
             # -- chainstay - seatstay
            dimension::angle   $w  $geometry::CURRENT_Project(CENTER_RearWheel)      \
                                   $geometry::CURRENT_Project(CENTER_BottomBracket)  \
                                   $geometry::CURRENT_Project(CENTER_SeatStay_Top)       90.0    0  $tag  $dim_colour_1  
        }                       


        if { $DRAFTING(FRAME_Dimension) == "on" || $DRAFTING(TUBE_Dimension) == "on"} {
            
             # -- seattube  - toptube
                 dimension::angle   $w  $geometry::CURRENT_Project(CENTER_TopTube_Seat)  \
                                        $geometry::CURRENT_Project(CENTER_TopTube_Head)  \
                                        $geometry::CURRENT_Project(CENTER_BottomBracket)     -90.0    0  $tag  $dim_colour_1  
             # -- downtube  - headtube
                 dimension::angle   $w  $geometry::CURRENT_Project(CENTER_DownTube_Head) \
                                        $geometry::CURRENT_Project(CENTER_BottomBracket) \
                                        $geometry::CURRENT_Project(CENTER_ForkPoint)         160.0   10  $tag  $dim_colour_1  
                                   
             # -- toptube   - headtube
                 dimension::angle   $w  $geometry::CURRENT_Project(CENTER_TopTube_Head)  \
                                        $geometry::CURRENT_Project(CENTER_TopTube_Seat)  \
                                        $geometry::CURRENT_Project(CENTER_HeadTube_Top)     -120.0    0  $tag  $dim_colour_1  

             # -- headtube
                 dimension::length  $w  $geometry::CURRENT_Project(CENTER_HeadTube_Bottom) \
                                        $geometry::CURRENT_Project(CENTER_HeadTube_Top)      100.0    0  $tag  $dim_colour  
             
             # -- seattube
            if { $DRAFTING(FRAME_Dimension) == "on" } {
                 dimension::length  $w  $geometry::CURRENT_Project(CENTER_BottomBracket) \
                                        $geometry::CURRENT_Project(CENTER_SeatTube_Top)     -140.0    0  $tag  $dim_colour  
               } else {
                 dimension::length  $w  $geometry::CURRENT_Project(CENTER_BottomBracket) \
                                        $geometry::CURRENT_Project(CENTER_SeatTube_Top)      -70.0    0  $tag  $dim_colour  
             
               }

             # -- unified frame size           
			     dimension::length  $w  $geometry::CURRENT_Project(CENTER_BottomBracket) \
                                        $geometry::CURRENT_Project(CENTER_HeadTube_Top)      150.0   100   $tag  $dim_colour_3 vertical 
                 dimension::length  $w  $geometry::CURRENT_Project(CENTER_HeadTube_Top)  \
                                        $geometry::CURRENT_Project(CENTER_BottomBracket)    -100.0   -50   $tag  $dim_colour_3 horizontal 
        }                       
            
                               
        if { $DRAFTING(TUBE_Dimension) == "on" } {
                
            if { $DRAFTING(FRAME_Dimension) == "on" } {
                 dimension::length  $w  $geometry::CURRENT_Project(CENTER_BottomBracket)    $geometry::CURRENT_Project(CENTER_LUG_HeadBottom)     70.0     0   $tag  $dim_colour_2  
                 dimension::length  $w  [lindex $geometry::OUT_Line(frame)   8]         [lindex $geometry::OUT_Line(frame)  11]           45.0     0   $tag  $dim_colour_2        
                   # dimension::length  $w  [lindex $geometry::OUT_Line(outline_1)   8]         [lindex $geometry::OUT_Line(outline_1)  11]           45.0     0   $tag  $dim_colour_2        
                   # dimension::length  $w  [lindex $geometry::OUT_Line(inline_1)    4]         [lindex $geometry::OUT_Line(inline_1)    1]           45.0     0   $tag  $dim_colour_2        
               } else {
                 dimension::length  $w  $geometry::CURRENT_Project(CENTER_BottomBracket)    $geometry::CURRENT_Project(CENTER_LUG_HeadBottom)     70.0     0   $tag  $dim_colour  
                 dimension::length  $w  [lindex $geometry::OUT_Line(frame)   8]         [lindex $geometry::OUT_Line(frame)  11]           45.0     0   $tag  $dim_colour        
                   # dimension::length  $w  [lindex $geometry::OUT_Line(outline_1)   8]         [lindex $geometry::OUT_Line(outline_1)  11]           45.0     0   $tag  $dim_colour        
                   # dimension::length  $w  [lindex $geometry::OUT_Line(inline_1)    4]         [lindex $geometry::OUT_Line(inline_1)    1]           45.0     0   $tag  $dim_colour       
               }
        }
            

         # -- framejig - seatstay
        if { $DRAFTING(JIG_Dimension) == "on" } {
            
            if { $DRAFTING(FRAME_Dimension) != "on" } {
                 dimension::length  $w  $geometry::CURRENT_Project(CENTER_BottomBracket)    $geometry::CURRENT_Project(CENTER_RearWheel)         -60.0     0   $tag  $dim_colour_2  
                 dimension::length  $w  $geometry::CURRENT_Project(CENTER_BottomBracket)    $geometry::CURRENT_Project(CENTER_RearWheel)         -90.0     0   $tag  $dim_colour_2   horizontal 
                 dimension::length  $w  $geometry::CURRENT_Project(CENTER_BottomBracket)    $geometry::CURRENT_Project(CENTER_RearWheel)         140.0   -60   $tag  $dim_colour_2   vertical    
                 dimension::length  $w  $geometry::CURRENT_Project(CENTER_RearWheel)        $geometry::CURRENT_Project(CENTER_ForkCut)           190.0     0   $tag  $dim_colour_2 
                 
                 dimension::length  $w  $geometry::CURRENT_Project(CENTER_JIG_Headtube)     $geometry::CURRENT_Project(CENTER_HeadTube_Bottom)   110.0     0   $tag  $dim_colour_2 
                 dimension::length  $w  $geometry::CURRENT_Project(CENTER_ForkCut)          $geometry::CURRENT_Project(CENTER_JIG_Headtube)      110.0     0   $tag  $dim_colour_2 
                 dimension::length  $w  $geometry::CURRENT_Project(CENTER_ForkCut)          $geometry::CURRENT_Project(CENTER_HeadTube_Bottom)   160.0     0   $tag  $dim_colour_2 
                 
                 dimension::angle   $w  $geometry::CURRENT_Project(CENTER_ForkCut)   \
                                        [list 0 [lindex $geometry::CURRENT_Project(CENTER_ForkCut) 1]] \
                                        $geometry::CURRENT_Project(CENTER_ForkBase)                                                             -140.0     0   $tag  $dim_colour_1  
			       # 20081212 - dave bohm
		         dimension::length  $w  $geometry::CURRENT_Project(CENTER_BottomBracket)    $geometry::CURRENT_Project(CENTER_HeadTube_Bottom)    90.0     0   $tag  $dim_colour_2   horizontal  
                 dimension::angle   $w  $geometry::CURRENT_Project(CENTER_BottomBracket) \
                                        [list -200 [lindex $geometry::CURRENT_Project(CENTER_BottomBracket) 1]]  \
                                        $geometry::CURRENT_Project(CENTER_SeatTube_Top)                                                         -140.0    0  $tag  $dim_colour_1  
			} else {
                 dimension::length  $w  $geometry::CURRENT_Project(CENTER_RearWheel)        $geometry::CURRENT_Project(CENTER_ForkCut)           230.0     0   $tag  $dim_colour_2 
                 
                 dimension::length  $w  $geometry::CURRENT_Project(CENTER_JIG_Headtube)     $geometry::CURRENT_Project(CENTER_HeadTube_Bottom)   180.0     0   $tag  $dim_colour_2 
                 dimension::length  $w  $geometry::CURRENT_Project(CENTER_JIG_Headtube)     $geometry::CURRENT_Project(CENTER_ForkCut)          -180.0     0   $tag  $dim_colour_2 
			       # 20081212 - dave bohm
		         dimension::length  $w  $geometry::CURRENT_Project(CENTER_BottomBracket)    $geometry::CURRENT_Project(CENTER_HeadTube_Bottom)    50.0     0   $tag  $dim_colour_2   horizontal  
            }
               
            dimension::length       $w  $geometry::CURRENT_Project(CENTER_RearWheel)        $geometry::CURRENT_Project(CENTER_JIG_Headtube)     -110.0     0   $tag  $dim_colour_2 
            dimension::length       $w  $geometry::CURRENT_Project(CENTER_RearWheel)        $geometry::CURRENT_Project(CENTER_JIG_Seattube)      -60.0     0   $tag  $dim_colour_2 
        
            dimension::length       $w  $geometry::CURRENT_Project(CENTER_JIG_Seattube)     $geometry::CURRENT_Project(CENTER_BottomBracket)     -80.0   -30   $tag  $dim_colour_2   aligned    
            
            dimension::angle        $w  $geometry::CURRENT_Project(CENTER_JIG_Seattube) \
                                        $geometry::CURRENT_Project(CENTER_JIG_Headtube) \
                                        $geometry::CURRENT_Project(CENTER_SeatTube_Top)       90.0    0  $tag  $dim_colour_1  
			  # 20081212 - dave bohm
		    #dimension::length      $w  $geometry::CURRENT_Project(CENTER_BottomBracket)    $geometry::CURRENT_Project(CENTER_HeadTube_Bottom)    90.0     0   $tag  $dim_colour_2   horizontal  
		    dimension::length      $w  $geometry::CURRENT_Project(CENTER_BottomBracket)    $geometry::CURRENT_Project(CENTER_HeadTube_Bottom)   320.0   -50   $tag  $dim_colour_2   vertical  		 
		    set _distance          [ expr [lindex $geometry::CURRENT_Project(CENTER_RearWheel) 0] - [lindex $geometry::CURRENT_Project(CENTER_BottomBracket) 0] ] 
		    dimension::angle       $w  $geometry::CURRENT_Project(CENTER_BottomBracket)   \
								       [list -200 [lindex $geometry::CURRENT_Project(CENTER_BottomBracket) 1]] \
								       $geometry::CURRENT_Project(CENTER_RearWheel)                                            [expr $_distance -60.0]    0   $tag  $dim_colour_1  
        }
        
   }


     #-------------------------------------------------------------------------
     #
     #  end  namespace eval drafting 
     #
          
 }
  
