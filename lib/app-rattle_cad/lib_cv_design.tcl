# -----------------------------------------------------------------------------------
#
#: Functions : namespace      G E O M E T R Y
#

 namespace eval design {

   variable  FRAME
   array set FRAME    { CANVAS_Name           {}
                        Geometry_Id        first
                        Tag         frame_design  
                        Colour              blue
                        LineWidth              1.0
                        DimensionColour    black
                        Reposition_Scale       1.0
                        Border_X              50
                        Border_Y              30
                        Border_Baseline      105
                        CV_Position           {}
                       }

   variable  DIMENSION
   array set DIMENSION { Size              3          
                         Style             standard
                       }
             # DIMENSION(Size)             3          # standardfontfont
             # DIMENSION(Size)             9          # vectorfont
             # DIMENSION(Style)            vector
             # DIMENSION(Style)            standard
   
   variable  SCREEN_Solution  [expr 72/25.4]

   #-------------------------------------------------------------------------
       #  draw geometry of bicycle and baselines
       #
   proc create { w } {
            
            global   _CURRENT_Project            
            variable FRAME
       
        ::Debug  p
        ::Debug  t "\n --- FRAME_Config_Mode:  $control::FRAME_Config_Mode ---\n"
        
        set FRAME(CANVAS_Name)  $w
        set type                $control::FRAME_Config_Mode
        set display_type        $control::GUI_Config(GUI_FRAME_Display)
          
          # tk_messageBox -message " design:  $display_type" 
        
          # -- restore position of section bottom_bracke - baseline
        catch  [set frame_position   [$w bbox repositionbase] ]
        if {[llength $frame_position] != 0} {
             set FRAME(CV_Position)  [lib_canvas::get_rect_info  center  $frame_position ]
        }


        catch  [lib_canvas::delete_item        $w  all]   
        
          # tk_messageBox -message " design:  $type"
        switch $control::FRAME_Config_Mode {
            frame_design { 
                switch $display_type {
                    centerline {    
                        set FRAME(Colour)            red
                        set FRAME(LineWidth)         3.0 
                        set FRAME(DimensionColour)   blue
                        set FRAME(Tag)               $control::FRAME_Config_Mode
                        draw_baselines               $w  baseline
                        draw_framegeometry           $w  geometry::CURRENT_Project						
                        draw_bicycle_dimension       $w  geometry::CURRENT_Project
                        }
                    outline {    
                        set FRAME(Colour)            black
                        set FRAME(LineWidth)         1.0 
                        set FRAME(DimensionColour)   blue
                        set FRAME(Tag)               $control::FRAME_Config_Mode
                        draw_baselines               $w  baseline
                        draw_framegeometry           $w  geometry::CURRENT_Project  outline 
                        draw_bicycle_dimension       $w  geometry::CURRENT_Project
                        }
                    preview {    
                        set FRAME(Colour)            black
                        set FRAME(LineWidth)         1.0 
                        set FRAME(DimensionColour)   blue
                        set FRAME(Tag)               $control::FRAME_Config_Mode
                        draw_baselines               $w  baseline
                        draw_framegeometry           $w  geometry::CURRENT_Project  preview
                        }
                    }   
                }
              
            replace_component { 
                # tk_messageBox -message "$type"
                set FRAME(Colour)            black
                set FRAME(LineWidth)         1.0 
                set FRAME(Tag)               frame_design
                draw_framegeometry           $w  geometry::CURRENT_Project
                set FRAME(Colour)            blue
                set FRAME(LineWidth)         3.0 
                set FRAME(DimensionColour)   black
                set FRAME(Tag)               $type
                set line_w                   $control::FRAME_Config_Mode 
                draw_baselines               $w  baseline
                draw_framegeometry           $w  geometry::CURRENT_Replace
                draw_bicycle_dimension       $w  geometry::CURRENT_Replace
                }
                        
            wait { 
                # tk_messageBox -message "$type"
                set FRAME(Colour)               red
                set FRAME(LineWidth)            1.0 
                set FRAME(DimensionColour)      darkblue
                set control::FRAME_Config_Mode  frame_design
                set type                        frame_design
                }
                        
            default { 
                tk_messageBox -message "$control::FRAME_Config_Mode  - $type - do hots wos" 
                }
        }

          # -- do position geometry
        lib_canvas::recenter         $w  $FRAME(Reposition_Scale)  all  

        lib_canvas::mirror           $w  
 
        reposition                   $w  repositionbase 
 
        lib_canvas::display_bbox     $w  create
        
   }

   #-------------------------------------------------------------------------
       #  draw frame-geometry
       #
   proc draw_framegeometry { w  prj_data {type centerline}} {
            
           variable FRAME
        
        ::Debug  p  1
                
        array set PRJ_DATA  [array get $prj_data]
        
          # tk_messageBox -message " $prj_data  -> \n[array names $prj_data]\n$PRJ_DATA(CENTER_BottomBracket)"
        

           # lib_canvas::draw_circle      $w  $PRJ_DATA(CENTER_Stem)    5  $FRAME(Tag)  red           1
	       # lib_canvas::draw_circle      $w  $PRJ_DATA(CENTER_SeatTube_Top)    15  $FRAME(Tag)  blue           3
		   # lib_canvas::draw_circle      $w  $PRJ_DATA(CENTER_LUG_SeatTop)     20  $FRAME(Tag)  blue           3
		   # lib_canvas::draw_circle      $w  $PRJ_DATA(CENTER_TopTube_Seat)    15  $FRAME(Tag)  green           3
		   # lib_canvas::draw_circle      $w  $PRJ_DATA(CENTER_TopTube_Head)    15  $FRAME(Tag)  green           3

           # draw_baselines               $w  baseline

        switch $type {
            centerline {
                lib_canvas::draw_circle      $w  $PRJ_DATA(CENTER_ForkPoint)        5  $FRAME(Tag)  gray           1 
                lib_canvas::draw_circle      $w  $PRJ_DATA(CENTER_HeadTube_Top)    10  $FRAME(Tag)  $FRAME(Colour) 1 
                lib_canvas::draw_circle      $w  $PRJ_DATA(CENTER_SeatTube_Top)    10  $FRAME(Tag)  $FRAME(Colour) 1 
                lib_canvas::draw_circle      $w  $PRJ_DATA(CENTER_LUG_HeadBottom)  10  $FRAME(Tag)  gray           1 
                lib_canvas::draw_circle      $w  $PRJ_DATA(CENTER_LUG_HeadTop)     10  $FRAME(Tag)  gray           1 
                lib_canvas::draw_circle      $w  $PRJ_DATA(CENTER_LUG_SeatTop)     10  $FRAME(Tag)  gray           1
                lib_canvas::draw_circle      $w  $PRJ_DATA(CENTER_TopTube_Pivot)   10  $FRAME(Tag)  gray           1
                
                geometry::draw_wheels        $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  centerline
                geometry::draw_frame         $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  centerline
				geometry::draw_fork          $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  centerline
                geometry::draw_saddle        $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  centerline
                geometry::draw_handlebar     $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  centerline
                }
            outline {
                geometry::draw_wheels        $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  outline  black
                geometry::draw_rims          $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  outline  white
                geometry::draw_frame         $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  outline
				geometry::draw_fork          $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  outline
                geometry::draw_saddle        $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  outline  blank
                geometry::draw_seatpost      $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)
                geometry::draw_headset_stem  $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)
                geometry::draw_handlebar     $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  outline  blank 
                geometry::draw_chainwheel    $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  
                }
            preview {
                geometry::draw_wheels        $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  outline  black
                geometry::draw_rims          $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  outline  white
                geometry::draw_frame         $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  outline
				geometry::draw_fork          $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  outline
                geometry::draw_saddle        $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  outline  blank
                geometry::draw_seatpost      $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  
                geometry::draw_headset_stem  $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)
                geometry::draw_handlebar     $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  outline  blank
                geometry::draw_chainwheel    $w  $prj_data  $FRAME(Tag)  $FRAME(LineWidth)  $FRAME(Colour)  
                }
        }
   }
        
        
   #-------------------------------------------------------------------------
       #  fit reposition
       #
   proc reposition { w tag } {
            
            variable FRAME
        
        ::Debug  p  1
        
        if {$FRAME(CV_Position) == {}} return

        set frame_position  [lib_canvas::get_rect_info  center [$w bbox $tag] ]
        set move            [mathematic::VSub  $FRAME(CV_Position)  $frame_position ] 
        
        foreach {x y} $move break
        $w move all  $x $y
        
        return
   }
        

   #-------------------------------------------------------------------------
       #  fit reposition
       #
   proc resize { w } {
            
            variable FRAME         
            variable DIMENSION
            variable SCREEN_Solution

        ::Debug  p  1
        
        
          # -- remove previous bbox for scale/move
        lib_canvas::display_bbox    $w  delete 

          # -- unscale canvas
        $w  scale              all   0  0  [expr 1.0/$FRAME(Reposition_Scale)]  [expr 1.0/$FRAME(Reposition_Scale)]
           
          # -- get new scale
        set FRAME(Reposition_Scale)  [lib_canvas::compute_scale  $w  all  $FRAME(Border_X)  $FRAME(Border_Y) ]
          
          # -- scale and recenter to canvas
        lib_canvas::recenter    $w   $FRAME(Reposition_Scale)  frame_design 
          
          # -- orient south
        set bbox_all_source_y        [lindex  [$w bbox all]  3 ]
        set bbox_all_target_y        [expr  [winfo height $w] - $FRAME(Border_Y)]        
        set move_y                   [expr $bbox_all_target_y - $bbox_all_source_y ]
        $w  move                all  0  $move_y 

          # -- store position of content
        set FRAME(CV_Position)      [lib_canvas::get_rect_info  center [$w bbox repositionbase] ]
        
          # -- dimension settings
        dimension::configure  stdfscl  $FRAME(Reposition_Scale)
        dimension::configure  stdfont  [expr  $DIMENSION(Size)*$SCREEN_Solution/$FRAME(Reposition_Scale)]
        dimension::configure  style    $DIMENSION(Style)
        dimension::configure  size     [expr  $DIMENSION(Size)*$SCREEN_Solution/$FRAME(Reposition_Scale)]
        dimension::configure  dist     [expr  1.0*$SCREEN_Solution/$FRAME(Reposition_Scale)]
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
       #  print_postscript
       #
   proc print_postscript { w } {
          
            variable FRAME 
        
        ::Debug  p  1

  	     
        set page_a4_width   297
        set page_a4_height  210
        
          # tk_messageBox -message " print_postscript"
        set bbox      [$w bbox all]
        set bbox_size [lib_canvas::get_rect_info  size  [$w bbox all] ]
        set bbox_x    [lindex $bbox_size 0]
        set bbox_y    [lindex $bbox_size 1]
        set cv_size   [lib_canvas::size $w]
        
           # debug::create
        ::Debug  t  "bbox         $bbox"       1
        ::Debug  t  "bbox size    $bbox_size"  1
        ::Debug  t  "bbox size x  $bbox_x"     1
        ::Debug  t  "bbox size y  $bbox_y"     1
        ::Debug  t  "cv   size    $cv_size"     1
        
        if {[expr $bbox_x/sqrt(2)] < $bbox_y} {
           set bbox_x [expr $bbox_y*sqrt(2)] 
        }
        
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
                       -pagewidth   [format "%sm" $page_a4_width] \
                       -pageheight  [format "%sm" $page_a4_height] \
                       -pageanchor  sw \
                       -pagex       [format "%sm" $page_a4_height] \
                       -pagey       0m
        
        ::start_psview  $printfile_name
   }


   #-------------------------------------------------------------------------
       #  zoom_setscale
       #
   proc design_scale { {scale {}} } {
            
            variable FRAME
            
        ::Debug  p  1
        
        
            ::Debug  t " $scale $FRAME(Reposition_Scale) "
        if {$scale == {} } {
            return $FRAME(Reposition_Scale)
        } 
        
          #
          # 1st 
          # -- modify scale parameter from extern
        set FRAME(Reposition_Scale)  [expr $scale*$FRAME(Reposition_Scale)]
        
        return
        
   }

   
   #-------------------------------------------------------------------------
       #  draw baselines 
       #
   proc draw_baselines { w tag} {  # requires compute_bb_wheel_headtube first
            
            global   _CURRENT_Project            
            variable DIMENSION
        
        ::Debug  p  1
               
        set xy  ""
        set xy0 ""
        set xy1 ""
        
          # -- remove previous baseline
        catch [$w delete $tag]


          # -- reposition Base
        lib_canvas::draw_circle      $w  {0 0}  50  repositionbase  white

          # -- horizontal/vertical baseline
        set xy0  $geometry::CURRENT_Project(CENTER_RearWheel)     
        set xy1  $geometry::CURRENT_Project(CENTER_FrontWheel) 
        
        $w create line  [ expr [ lindex $xy0  0 ] - [ lindex $xy0  1 ] ]   0 \
                        [ expr [ lindex $xy1  0 ] + [ lindex $xy1  1 ] ]   0 \
               -tags   [list $tag hor_baseline]  \
               -fill   gray \
               -width  0.3

   }

   
   #-------------------------------------------------------------------------
       #  draw bicycle
       #
   proc draw_bicycle_dimension { w  prj_data } {
            
            global   _CURRENT_Project            
            variable FRAME 
        
        ::Debug  p  1
        
        set  dim_colour  $FRAME(DimensionColour)      
        array set PRJ_DATA  [array get $prj_data]

        
          # -- center bottombracket
        set bb_c   $PRJ_DATA(CENTER_BottomBracket) 

          # -- wheels
        set rw_c   $PRJ_DATA(CENTER_RearWheel)    
        set rw_d   $PRJ_DATA(Wheel_Rear_Diameter)    
        set fw_c   $PRJ_DATA(CENTER_FrontWheel)   
          
          # -- seattube - saddle
        set sd_c   $PRJ_DATA(CENTER_Seat_Top)  
        
          # -- seattube - base
        set stb_c  $PRJ_DATA(CENTER_SeatTube_Base)
          
          # -- seatstay
        set sst_c  $PRJ_DATA(CENTER_SeatStay_Top)   

          # -- toptube
        set tts_c  $PRJ_DATA(CENTER_TopTube_Seat)   
        set tth_c  $PRJ_DATA(CENTER_TopTube_Head)   

          # -- headtube
        set htd_c  $PRJ_DATA(CENTER_HeadTube_Bottom)  
        set htt_c  $PRJ_DATA(CENTER_HeadTube_Top) 

          # -- downtube
        set hdt_c  $PRJ_DATA(CENTER_DownTube_Head)  
          
          # -- stem
        set st_c   $PRJ_DATA(CENTER_Stem)       
        set hb_c   $PRJ_DATA(CENTER_HandleBar)   
          
          # -- headtube steerer
        set htb_c  $PRJ_DATA(CENTER_HeadTube_Bottom)  
        
          # -- toptube pivot
        set tt_pc  $PRJ_DATA(CENTER_TopTube_Pivot)  

          # -- frontwheel rake basepoint
        set htb_c  $PRJ_DATA(CENTER_HeadTube_Base)  
        set fb_c   $PRJ_DATA(CENTER_ForkBase)  

          # -- frontwheel clearence
        set clbb_c $PRJ_DATA(CENTER_Clearence_BottomBracket)  
        set clfw_c $PRJ_DATA(CENTER_Clearence_FrontWheel)  

          # -- leg clearence
        set cllg_c   $PRJ_DATA(CENTER_Standing_Top)  


          # ---------------------------------------------
          #
          # -- CENTERLINE -------------------------------
          #

          # -- center bottombracket
        dimension::create_centerline $w  [list [lindex $bb_c  0]   -50]  \
                                         [list [lindex $bb_c  0]    50]   dimension                                         
          # -- headtube axis
        dimension::create_centerline  $w  $htb_c  $fb_c  dimension 

          # -- seattube axis
        dimension::create_centerline  $w  $stb_c  $bb_c  dimension 
 
          #
          # -- crank visualization
        lib_canvas::draw_arc         $w $bb_c   $control::CURRENT_Config(CrankArm_Length)  dimension  -25 75 gray 1
        
          # -- center leg clearence
        dimension::create_centerline $w  [list [expr [lindex $cllg_c  0] - 40 ]   [lindex $cllg_c  1] ]  \
                                         [list [expr [lindex $cllg_c  0] + 40 ]   [lindex $cllg_c  1] ]  dimension 
        
          # -- center inner legs - frame heigth
        dimension::create_centerline $w  [list [expr [lindex $cllg_c  0] - 40 ]   [lindex $tt_pc   1] ]  \
                                         [list [expr [lindex $cllg_c  0] + 40 ]   [lindex $tt_pc   1] ]  dimension
        
        dimension::create_centerline $w  [list [lindex $cllg_c  0]   [expr [lindex $tt_pc   1] - 40] ]  \
                                         [list [lindex $cllg_c  0]   [expr [lindex $cllg_c  1] + 40] ]   dimension

                                         
        
        
        
        
          # ---------------------------------------------
          #
          # -- DIMENSION --------------------------------
          #
        
          # -- bottombracket
        dimension::length  $w  {0 0}   $bb_c     100.0     -50  dimension  darkred      aligned
		                                                                  #darkgray     aligned  
          # -- bottombracket - frontwheel 
            set ab [ list  [ lindex $fw_c 0 ]  0 ]
        dimension::length  $w  $bb_c   $fw_c     130.0     -70  dimension  darkgray     aligned 
        dimension::length  $w  $ab     {0 0}    -100.0       0  dimension  $dim_colour  horizontal 
        dimension::length  $w  $ab     $htb_c    100.0     110  dimension  $dim_colour  horizontal 

          # -- bottombracket - rearwheel 
            set xy [ list  [ lindex $rw_c 0 ]  0 ]
        dimension::length  $w  $rw_c   $bb_c     130.0      0   dimension  darkgray     aligned    
        dimension::length  $w  $rw_c   $bb_c     -50.0   -110   dimension  $dim_colour  vertical
        dimension::length  $w  $xy     {0 0}     100.0      0   dimension  $dim_colour   

          # -- rearwheel - frontwheel 
        dimension::length  $w  $ab     $xy      -170.0      0   dimension  $dim_colour  

          # -- saddle
            set xy [ list  [ lindex $sd_c 0 ]  0 ]
        dimension::length  $w  $xy     $sd_c    -450.0    200   dimension  $dim_colour  vertical 
          # -- saddle - bb horizontal
        dimension::length  $w  $sd_c   $bb_c    -100.0      0   dimension  $dim_colour  horizontal  
          # -- saddle - bb vertical
        dimension::length  $w  $sd_c   $bb_c    -380.0   -150   dimension  $dim_colour  vertical 
        

          # -- tube_length
          # -- seattube
        dimension::length  $w  $bb_c   $tts_c   -160.0      0   dimension  $dim_colour     
          # -- toptube
        dimension::length  $w  $tts_c  $tth_c   -100.0      0   dimension  $dim_colour               
          # -- headtube
        dimension::length  $w  $htd_c  $htt_c    100.0    -40   dimension  darkgray      
        

          # -- radius frontwheel
            set xy [ list  [ lindex $fw_c 0 ]  0 ]
        dimension::length  $w  $xy     $fw_c     100.0    -60    dimension  darkgray     vertical
          # -- radius rearwheel
            set xy [ list  [ lindex $rw_c 0 ]  0 ]
        dimension::length  $w  $xy     $rw_c     100.0    -60    dimension  darkgray     vertical
          # -- diameter rearwheel
            set xy [ list  [ lindex $rw_c 0 ]  0 ]
            set yz [ list  [ lindex $rw_c 0 ]  $rw_d]
        dimension::length  $w  $xy     $yz      -120.0    150    dimension  darkgray     vertical
 

          # -- toptube heigth
            set xy [ list  [lindex $tt_pc 0] 0 ]
        dimension::length  $w  $xy     $tt_pc     70.0    150    dimension  $dim_colour  vertical       
            set xy [ list  0 [lindex $tt_pc 1] ]
        dimension::length  $w  $xy     $tt_pc     70.0   -110    dimension  darkgray     horizontal       
         
          
          # -- frontwheelclearence
        dimension::length  $w  $clbb_c $clfw_c     0.0    120    dimension  $dim_colour  aligned       
          
          # -- headtube
        dimension::angle   $w  $htb_c  {-100 0} $fb_c \
                                                -140.0     -5    dimension  $dim_colour  
          # -- seattube
        dimension::angle   $w  $stb_c  {-100 0} $bb_c \
                                                -140.0      5    dimension  darkred          
												                           #darkgray  
        
        
          # -- handlebar - saddle
            set dim_y_saddle    [ expr [lindex $sd_c 1] - [lindex $hb_c 1] + 100 ] 
        dimension::length  $w  $sd_c   $hb_c    -200.0      0    dimension  $dim_colour  vertical    
        dimension::length  $w  $hb_c   $sd_c    [expr $dim_y_saddle + 70] \
                                                            0    dimension  $dim_colour  horizontal    
           
		  # -- handlebar
            set xy [ list  [ lindex $hb_c 0 ]  0 ]
        dimension::length  $w  $xy     $hb_c     400.0    200   dimension  $dim_colour  vertical 
          # -- handlebar - bb horizontal
        dimension::length  $w  $hb_c   $bb_c    $dim_y_saddle \
                                                            0   dimension  darkred      horizontal 
          # -- handlebar - bb vertical
        dimension::length  $w  $hb_c   $bb_c    -330.0   -150   dimension  darkred      vertical  

		
          # -- headtube-top - bb horizontal
            set dim_y_saddle    [ expr [lindex $sd_c 1] - [lindex $hb_c 1] + 100 ] 
        dimension::length  $w  $htt_c   $bb_c    [expr $dim_y_saddle -20] \
                                                            0   dimension  darkgray      horizontal 
          # -- headtube-top - bb vertical
        dimension::length  $w  $htt_c   $bb_c   -330.0   -120   dimension  darkgray      vertical  

   }   
       
       
  #-------------------------------------------------------------------------
     #
     #  end  namespace eval drawspace
     #

  }
  
