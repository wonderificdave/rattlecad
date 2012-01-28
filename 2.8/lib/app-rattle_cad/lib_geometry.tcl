# -----------------------------------------------------------------------------------
#
#: Functions : namespace      G E O M E T R Y
#

 namespace eval geometry {

   variable  CURRENT_Project
   array set CURRENT_Project {
                    BottomBrckt_Diameter   38.0 
                    }

   variable  CURRENT_Replace
   array set CURRENT_Replace {}

   variable  CURRENT_Mitter
   array set CURRENT_Mitter  {}
   
   variable  OUT_Line
   array set OUT_Line        {}
   
   variable   BottomBrckt_Diameter   38.0       
   


   
   #-------------------------------------------------------------------------
       #  init
       #
   proc init {} {
   
          variable CURRENT_Project 
    
        ::Debug p
        # tk_messageBox -message "geometry::init [array get geometry::CURRENT_Project]"       
        # set CURRENT_Project(BottomBrckt_Diameter)  38.0        
        # tk_messageBox -message "geometry::init [array get geometry::CURRENT_Project]"                
   }

          #-------------------------------------------------------------------------
       #  compute geometry of bicycle
       #
   proc compute_bb_wheel_headtube {{type default}} {
    
            variable CURRENT_Project
            
        ::Debug  p  1
        
        set CURRENT_Project(Wheel_Front_Diameter) \
                   [ expr 2 * $control::CURRENT_Config(Wheel_Front_Tyre_Height) + $control::CURRENT_Config(Wheel_Front_Rim_Diameter) ]
        set CURRENT_Project(Wheel_Rear_Diameter) \
                   [ expr 2 * $control::CURRENT_Config(Wheel_Rear_Tyre_Height) + $control::CURRENT_Config(Wheel_Rear_Rim_Diameter) ]
          # ------------------------------------
        set rw_radius  [expr 0.5 * $CURRENT_Project(Wheel_Rear_Diameter)]
        set bb_height  $control::CURRENT_Config(BottomBracket_Height)
        set bb_depth   $control::CURRENT_Config(BottomBracket_Depth)
        
        if {[string equal $control::GUI_Config(GUI_METH_BBracket) height]} {
               set bb_depth   [expr $rw_radius-$bb_height]
           } else {
               set bb_height  [expr $rw_radius-$bb_depth]
           }
        set control::CURRENT_Config(BottomBracket_Height)  $bb_height 
        set control::CURRENT_Config(BottomBracket_Depth)   $bb_depth  
       
        set CURRENT_Project(CENTER_BottomBracket) \
                   [ list 0 $control::CURRENT_Config(BottomBracket_Height) ]
          
          # ------------------------------------
        set bb_c   $CURRENT_Project(CENTER_BottomBracket)
          # ------------------------------------
        set CURRENT_Project(CENTER_RearWheel) \
                           [ compute_center_rearwheel  [ lindex $bb_c 0 ]   [ lindex $bb_c 1 ] \
						    $control::CURRENT_Config(ChainStay_Length)  $CURRENT_Project(Wheel_Rear_Diameter)  ]
          # ------------------------------------							 
        set CURRENT_Project(CENTER_FrontWheel) \
                           [ compute_center_frontwheel [ lindex $bb_c 0 ]   [ lindex $bb_c 1 ] \
						    $control::CURRENT_Config(Front_Length)      $CURRENT_Project(Wheel_Front_Diameter) ]
          # ------------------------------------							 
        set rw_c   $CURRENT_Project(CENTER_RearWheel)  
        set fw_c   $CURRENT_Project(CENTER_FrontWheel)  
          
        
        if {[string equal $control::GUI_Config(GUI_METH_HTube)  "bar"]} {
                # -- $GUI_Config(GUI_METH_HTube)  "bar" ------							 
                set CURRENT_Project(CENTER_HandleBar) [list $control::CURRENT_Config(HandleBar_Distance) \
                                                              [expr $control::CURRENT_Config(BottomBracket_Height) + \
                                                                    $control::CURRENT_Config(HandleBar_Height)] ]
                set hb_fw_vct        [mathematic::VSub  $CURRENT_Project(CENTER_HandleBar)  $CURRENT_Project(CENTER_FrontWheel)]
                set lng_hb_fw_vct    [expr hypot([lindex $hb_fw_vct 0],[lindex $hb_fw_vct 1]) ]
                set ang_hb_fw_1      [mathematic::grad [expr atan([lindex $hb_fw_vct 0]/[lindex $hb_fw_vct 1])]]
                
                set stem_to_ht_fw    [expr  - $control::CURRENT_Config(Fork_Rake) + $control::CURRENT_Config(Stem_Length)*cos([mathematic::rad $control::CURRENT_Config(Stem_Angle)])]                   
                
                set ang_hb_fw_2      [mathematic::grad [expr sin($stem_to_ht_fw/$lng_hb_fw_vct)]]

                set control::CURRENT_Config(HeadTube_Angle)  [expr 90 + $ang_hb_fw_1 - $ang_hb_fw_2]
                  #tk_messageBox -message " geometry:  \n rake $control::CURRENT_Config(Fork_Rake)\n stem_to_ht_fw $stem_to_ht_fw\n ang_hb_fw_1 $ang_hb_fw_1  \n ang_hb_fw_2  $ang_hb_fw_2  \n HeadTube_Angle  $control::CURRENT_Config(HeadTube_Angle)"
        }

        
          # ------------------------------------							 
        set ht_angle       [expr 180-$control::CURRENT_Config(HeadTube_Angle)]
        set h_rake         [expr {$control::CURRENT_Config(Fork_Rake) / sin([mathematic::rad $control::CURRENT_Config(HeadTube_Angle)])}] 
        set hlp_vct        [list $h_rake 0]
        set CURRENT_Project(CENTER_ForkPoint) \
                           [ mathematic::calc_point_length_arc   $CURRENT_Project(CENTER_FrontWheel)     $control::CURRENT_Config(Fork_Rake)    [expr $ht_angle+90] ]
        set CURRENT_Project(CENTER_ForkBase)  \
                           [ mathematic::calc_point_length_arc   $CURRENT_Project(CENTER_ForkPoint)      $control::CURRENT_Config(Fork_Heigth)  $ht_angle ]
        set CURRENT_Project(CENTER_ForkCut) \
                           [ mathematic::VSub                    $CURRENT_Project(CENTER_FrontWheel)     $hlp_vct ]
            # change -- 2008.05.31
		if {$control::CURRENT_Config(HeadsetBottom_Heigth) == 0} {
		    set CURRENT_Project(CENTER_HeadTube_Bottom)  $CURRENT_Project(CENTER_ForkBase)
		} else {
			set CURRENT_Project(CENTER_HeadTube_Bottom) \
                           [ mathematic::calc_point_length_arc   $CURRENT_Project(CENTER_ForkBase)       $control::CURRENT_Config(HeadsetBottom_Heigth)      $ht_angle  ]
        }
		
          # ------------------------------------							 
        set CURRENT_Project(CENTER_HeadTube_Top) \
                           [ mathematic::calc_point_length_arc   $CURRENT_Project(CENTER_ForkBase)       [expr $control::CURRENT_Config(HeadsetBottom_Heigth) + \
                                                                                                               $control::CURRENT_Config(HeadTube_Length) ]  $ht_angle ]
                           
          
        if {[string equal $control::GUI_Config(GUI_METH_HTube)  "bar"]} {
                # -- $GUI_Config(GUI_METH_HTube)  "bar" ------							 
                  # ------------------------------------
                set CURRENT_Project(CENTER_Stem) \
                               [ mathematic::calc_point_length_arc   $CURRENT_Project(CENTER_HandleBar) \
                                                                     $control::CURRENT_Config(Stem_Length) \
                                                                     [ expr  $ht_angle + $control::CURRENT_Config(Stem_Angle) + 90 ] ]
                   # wegen Rechenungenauigkeit
                   # change -- 2008.05.31
            if {$control::CURRENT_Config(HeadsetBottom_Heigth) > 0} {
				set CURRENT_Project(CENTER_Stem) \
                               [ mathematic::Intersect  $CURRENT_Project(CENTER_Stem)      $CURRENT_Project(CENTER_HandleBar) \
                                                        $CURRENT_Project(CENTER_ForkBase)  $CURRENT_Project(CENTER_HeadTube_Bottom) ]
			}											

                  # ------------------------------------
                set xy         [ mathematic::VSub                    $CURRENT_Project(CENTER_Stem)  $CURRENT_Project(CENTER_HeadTube_Top) ]
                set control::CURRENT_Config(Stem_Heigth)             [ expr hypot([lindex $xy 0],[lindex $xy 1]) ]
        } else {
                # -- $GUI_Config(GUI_METH_HTube)  "angle" ----							 
                set CURRENT_Project(CENTER_Stem)  \
                               [ mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_ForkBase) \
                                                                     [ expr $control::CURRENT_Config(HeadsetBottom_Heigth) + \
                                                                            $control::CURRENT_Config(HeadTube_Length) + \
                                                                            $control::CURRENT_Config(Stem_Heigth) ] \
                                                                     $ht_angle ]
                  # ------------------------------------
                set CURRENT_Project(CENTER_HandleBar) \
                               [ mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_Stem) \
                                                                    $control::CURRENT_Config(Stem_Length) \
                                                                    [ expr  $ht_angle + $control::CURRENT_Config(Stem_Angle) - 90 ] ]
                  # ------------------------------------
                set control::CURRENT_Config(HandleBar_Distance)     [ lindex  $CURRENT_Project(CENTER_HandleBar) 0] 
                set control::CURRENT_Config(HandleBar_Height)       [expr [lindex  $CURRENT_Project(CENTER_HandleBar) 1] - $control::CURRENT_Config(BottomBracket_Height) ]
        } 
        
          # ------------------------------------							 
        set CURRENT_Project(Wheel_Distance \
                           [ expr  abs( [ lindex $rw_c  0 ] ) +  abs( [ lindex $rw_c  0 ] )   ]
   }
   
   
   #-------------------------------------------------------------------------
       #  compute geometry of bicycle
       #
   proc compute_frame_geometry {{parameter schau_amol}} {

            variable CURRENT_Project
            variable CURRENT_Replace
            variable CURRENT_Mitter
        
        ::Debug  p  1

            # tk_messageBox -message "compute_frame_geometry:  start:  CURRENT_Project: \n[array get CURRENT_Project]" 
          # ------------------------------------
          # set tt_bs  [ list   $control::CURRENT_Config(TopTube_Pivot)   $control::CURRENT_Config(TopTube_Heigth) ]
        set ht_a   [ expr 180 - $control::CURRENT_Config(HeadTube_Angle) ]
        set st_a   [ expr 180 - $control::CURRENT_Config(SeatTube_Angle) ]
        set tt_a                $control::CURRENT_Config(TopTube_Angle)
        set ht_vct [ mathematic::VAdd  $CURRENT_Project(CENTER_ForkBase)       [ mathematic::rotate_point  {0 0}  {1000 0}  [ expr 180-$control::CURRENT_Config(HeadTube_Angle)] ] ]
        set st_vct [ mathematic::VAdd  $CURRENT_Project(CENTER_BottomBracket)  [ mathematic::rotate_point  {0 0}  {1000 0}    $st_a] ]
          # ------------------------------------
        set CURRENT_Project(CENTER_HeadTube_Base) \
                           [ mathematic::Intersect  $CURRENT_Project(CENTER_ForkBase)       $ht_vct  {0 0}   {100 0} ]
        set CURRENT_Project(CENTER_SeatTube_Base) \
                           [ mathematic::Intersect  $CURRENT_Project(CENTER_BottomBracket)  $st_vct  {0 0}   {100 0} ]
          # ------------------------------------
        set l_bb_s         [ expr 0.88 * $control::CURRENT_Config(InnerLeg_Length) ]
        set CURRENT_Project(CENTER_Seat_Top) \
                           [ mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_BottomBracket)   $l_bb_s  $st_a  ]
          # ------------------------------------
        set ct_ht_bttm     [ mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_ForkBase)  $control::CURRENT_Config(HeadsetBottom_Heigth)     $ht_a  ]
        set CURRENT_Project(CENTER_HeadTube_Bottom)  $ct_ht_bttm
          # ------------------------------------  
          #  Connection HeadTube DownTube 
        set vt_htd         [ mathematic::rotate_point {0 0}  [list [expr 0.5*$control::CURRENT_Config(HeadTube_Diameter)] 0]  [expr $ht_a+90] ]
        set hp_ht_1        [ mathematic::VAdd  $ct_ht_bttm   $vt_htd ]
        set hp_ht_2        [ mathematic::VAdd  $CURRENT_Project(CENTER_HeadTube_Base)    $vt_htd ]
        set ct_lg_ht_bttm  [ mathematic::calc_point_length_arc  $hp_ht_1  $control::CURRENT_Config(HeadTube_Bottom)  $ht_a ]
        set CURRENT_Project(CENTER_LUG_HeadBottom)  $ct_lg_ht_bttm     
        set hl_dt_ar1      [ mathematic::FindAngle    [list 100  [lindex $CURRENT_Project(CENTER_BottomBracket) 1]]  $CURRENT_Project(CENTER_BottomBracket)  $CURRENT_Project(CENTER_LUG_HeadBottom) ]
        set xy             [ mathematic::VSub         $CURRENT_Project(CENTER_LUG_HeadBottom)  $CURRENT_Project(CENTER_BottomBracket) ]
        set hl_dt_l        [ expr hypot([lindex $xy 0],[lindex $xy 1]) ]
        set hl_dt_ar2      [ expr asin([expr $control::CURRENT_Config(DownTube_Diameter)*0.5/$hl_dt_l])*180 / $::CONST_PI  ]
        set dt_arc         [ expr $hl_dt_ar1+$hl_dt_ar2]
        set hp_1           [ mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_BottomBracket)  $hl_dt_l  $dt_arc  ]
        set CURRENT_Project(CENTER_DownTube_Head) \
                           [ mathematic::Intersect  $CURRENT_Project(CENTER_ForkBase)  $ht_vct  $CURRENT_Project(CENTER_BottomBracket)  $hp_1 ]                           
          # ------------------------------------  
          #  Connection HeadTube TopTube
        set ct_ht_top      [ mathematic::calc_point_length_arc  $ct_ht_bttm  $control::CURRENT_Config(HeadTube_Length)  $ht_a ]
        set CURRENT_Project(CENTER_HeadTube_Top)     $ct_ht_top
        set hp_ht_3        [ mathematic::VAdd                   $ct_ht_top  $vt_htd ]
        set ct_lg_ht_tp    [ mathematic::calc_point_length_arc  $hp_ht_3  $control::CURRENT_Config(HeadTube_Top)  [expr 180+$ht_a] ]
        set CURRENT_Project(CENTER_LUG_HeadTop)      $ct_lg_ht_tp
		set vt_ttd         [ mathematic::calc_point_length_arc  {0 0}  [expr $control::CURRENT_Config(TopTube_Diameter)*0.5]  [expr 90 + $tt_a] ]
        set hp_tt_1        [ mathematic::VSub        $ct_lg_ht_tp           $vt_ttd ]
		set hp_tt_2        [ mathematic::VAdd        $hp_tt_1               [ mathematic::rotate_point  {0 0}  {1000 0}  $tt_a] ]
        set ct_tt_head     [ mathematic::Intersect   $hp_tt_1  $hp_tt_2  $ct_ht_bttm  $ct_ht_top ]                                                      
        set CURRENT_Project(CENTER_TopTube_Head)     $ct_tt_head 
        
          # ------------------------------------  
          #  DIMENSION TopTube SeatTube
        set ct_tt_height   [ mathematic::Intersect  [list $control::CURRENT_Config(TopTube_Pivot) 0] [list $control::CURRENT_Config(TopTube_Pivot) 999]  $hp_tt_1  $hp_tt_2 ]
        set CURRENT_Project(CENTER_TopTube_Pivot)   $ct_tt_height
        set ct_tt_seat     [ mathematic::Intersect  $CURRENT_Project(CENTER_BottomBracket)  $CURRENT_Project(CENTER_SeatTube_Base)  $hp_tt_1  $hp_tt_2 ]
        set CURRENT_Project(CENTER_TopTube_Seat)    $ct_tt_seat
          # ------------------------------------  
          #  Connection TopTube SeatTube
        set vt_std         [ mathematic::rotate_point {0 0}  [list [expr $control::CURRENT_Config(SeatTube_Diameter)*  0.5] 0]  [expr -90 + $st_a] ]
        set hp_st_1        [ mathematic::VAdd       $CURRENT_Project(CENTER_BottomBracket)  $vt_std ]
        set hp_st_2        [ mathematic::VAdd       $CURRENT_Project(CENTER_Seat_Top)       $vt_std ]
        set vt_ttd_sl      [ mathematic::rotate_point {0 0}  [list [expr $control::CURRENT_Config(TopTube_Diameter_SL)*0.5] 0]  [expr  90 + $tt_a] ]
        set hp_tt_3        [ mathematic::VAdd       $ct_tt_seat    $vt_ttd_sl ]
        set hp_tt_4        [ mathematic::VAdd       $ct_tt_head    $vt_ttd_sl ]
        set ct_lg_st_tp    [ mathematic::Intersect  $hp_st_1  $hp_st_2  $hp_tt_3  $hp_tt_4 ] 
		set CURRENT_Project(CENTER_LUG_SeatTop)     $ct_lg_st_tp
        set hp_st_3        [ mathematic::calc_point_length_arc   $ct_lg_st_tp  $control::CURRENT_Config(SeatTube_Lug)  $st_a ]
		set ct_st_top      [ mathematic::VSub       $hp_st_3  $vt_std ]
		set CURRENT_Project(CENTER_SeatTube_Top)    $ct_st_top
                            
          # ------------------------------------
        set CURRENT_Project(CENTER_Standing_Top)     [ list $control::CURRENT_Config(TopTube_Pivot)   $control::CURRENT_Config(InnerLeg_Length)   ]
        # set ct_tt_piv      [ mathematic::Intersect  $hp_st_1  $hp_st_2  $hp_tt_3  $hp_tt_4 ] 
        # set CURRENT_Project(CENTER_TopTube_Pivot)    [ list $control::CURRENT_Config(TopTube_Pivot)   $control::CURRENT_Config(TopTube_Heigth)    ]

        # ------------------------------------
        set CURRENT_Project(CENTER_SeatStay_Top) \
                           [ mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_TopTube_Seat)  -$control::CURRENT_Config(SeatStay_Distance)  $st_a  ]          
          # ------------------------------------  
          #  Front-Wheel Clearence
        set cl_fw_ang      [ mathematic::calc_vect_direction    $CURRENT_Project(CENTER_BottomBracket)  $CURRENT_Project(CENTER_FrontWheel) ]
        set CURRENT_Project(CENTER_Clearence_BottomBracket) \
                           [ mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_BottomBracket)  $control::CURRENT_Config(CrankArm_Length)  $cl_fw_ang  ]
        set CURRENT_Project(CENTER_Clearence_FrontWheel) \
                           [ mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_FrontWheel)     [expr 0.5*$CURRENT_Project(Wheel_Front_Diameter)]  [expr 180 + $cl_fw_ang] ]
          # ------------------------------------  
          #  FrameBuilding Dimension
        set fr_bsl_vct     [ mathematic::VAdd       $CURRENT_Project(CENTER_RearWheel)       [ mathematic::rotate_point  {0 0}  {100 0}  [ expr 90-$control::CURRENT_Config(HeadTube_Angle)] ] ]
        set CURRENT_Project(CENTER_JIG_Headtube) \
                           [ mathematic::Intersect  $CURRENT_Project(CENTER_RearWheel)      $fr_bsl_vct \
                                                    $CURRENT_Project(CENTER_HeadTube_Top)   $CURRENT_Project(CENTER_HeadTube_Base) ] 
        set CURRENT_Project(CENTER_JIG_Seattube) \
                           [ mathematic::Intersect  $CURRENT_Project(CENTER_RearWheel)      $fr_bsl_vct \
                                                    $CURRENT_Project(CENTER_BottomBracket)  $CURRENT_Project(CENTER_SeatTube_Top)  ] 
          # ------------------------------------  
          #  RearBrake Position 
		set fr_sst_ang     [ mathematic::calc_vect_direction \
													$CURRENT_Project(CENTER_RearWheel)		$CURRENT_Project(CENTER_SeatStay_Top)  ]
		set fr_rbp_0 	   [ mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_RearWheel)  [expr 0.5*$control::CURRENT_Config(Wheel_Rear_Rim_Diameter)]  $fr_sst_ang ]
		set rim_radius	   [ expr 0.5*$control::CURRENT_Config(Wheel_Rear_Rim_Diameter) ]
		set sst_dist	   [ expr 0.5*$control::CURRENT_Config(SeatStay_Diameter) + 30 ]
		set fr_dst_0 	   [ expr $rim_radius - sqrt( pow($rim_radius, 2) - pow($sst_dist, 2) ) ]  
		set fr_rbp_1 	   [ mathematic::calc_point_length_arc  $fr_rbp_0  $fr_dst_0  [expr $fr_sst_ang + 180] ]
		set fr_rbp_2 	   [ mathematic::calc_point_length_arc  $fr_rbp_1  45         $fr_sst_ang ]
		set fr_rbp_3 	   [ mathematic::calc_point_length_arc  $fr_rbp_1  $sst_dist  [expr $fr_sst_ang + 90] ]
		set fr_rbp_4 	   [ mathematic::calc_point_length_arc  $fr_rbp_3  45         $fr_sst_ang ]
		
		set CURRENT_Project(CENTER_RearBrake) 		$fr_rbp_2
		set CURRENT_Project(CENTER_RearBrakePad) 	$fr_rbp_3
		set CURRENT_Project(CENTER_RearBrakeAxis) 	$fr_rbp_4
		  # ------------------------------------  
        
        
        set CURRENT_Mitter(TopTube_Head)  [list $control::CURRENT_Config(TopTube_Diameter) \
                                                $control::CURRENT_Config(HeadTube_Diameter) \
                                                [expr 180 - [mathematic::FindAngle  $CURRENT_Project(CENTER_HeadTube_Base)  \
                                                                                    $CURRENT_Project(CENTER_TopTube_Head) \
                                                                                    $CURRENT_Project(CENTER_TopTube_Seat) ] ] \
												0 \
                                          ]
		
        set CURRENT_Mitter(TopTube_Seat)  [list $control::CURRENT_Config(TopTube_Diameter) \
                                                $control::CURRENT_Config(SeatTube_Diameter) \
                                                [expr 180 - [mathematic::FindAngle  $CURRENT_Project(CENTER_BottomBracket)  \
                                                                                    $CURRENT_Project(CENTER_TopTube_Seat) \
                                                                                    $CURRENT_Project(CENTER_TopTube_Head) ] ] \
												0 \
                                          ]
        
        set CURRENT_Mitter(DownTube_Head) [list $control::CURRENT_Config(DownTube_Diameter) \
                                                $control::CURRENT_Config(HeadTube_Diameter) \
                                                [expr 180 - [mathematic::FindAngle  $CURRENT_Project(CENTER_TopTube_Head) \
                                                                                    $CURRENT_Project(CENTER_DownTube_Head) \
                                                                                    $CURRENT_Project(CENTER_BottomBracket) ] ] \
												0 \
                                          ]  
        
        set CURRENT_Mitter(SeatStay_Seat) [list $control::CURRENT_Config(SeatStay_Diameter) \
                                                $control::CURRENT_Config(SeatTube_Diameter) \
                                                [expr       [mathematic::FindAngle  $CURRENT_Project(CENTER_RearWheel) \
                                                                                    $CURRENT_Project(CENTER_SeatStay_Top) \
                                                                                    $CURRENT_Project(CENTER_BottomBracket) ] ] \
												[expr 0.5*($control::CURRENT_Config(SeatTube_Diameter) - $control::CURRENT_Config(SeatStay_Diameter))] \
                                          ]  
        
           # tk_messageBox -message "compute_frame_geometry:  finish:  CURRENT_Project: \n[array get CURRENT_Project]" 
        
        ::Debug  t  "compute_frame_geometry:   end\n\n\n" 1
   }  

   
   #-------------------------------------------------------------------------
       #  compute center of rearwheel
       #
   proc compute_center_rearwheel { tl_x tl_y lcst wd } {

        ::Debug  p  1

        set lcst_y [ expr $wd / 2 - $tl_y ]
        set lcst_x [ expr sqrt( ( pow($lcst,2) - pow($lcst_y,2) ) ) ]

        return "[ expr $tl_x - $lcst_x ]  [ expr $wd / 2 ] "
   }
 

   #-------------------------------------------------------------------------
       #  compute center of frontwheel
       #
   proc compute_center_frontwheel { tl_x tl_y lfrnt wd } {

        ::Debug  p  1

        set lfrnt_y [ expr $wd / 2 - $tl_y ]
        set lfrnt_x [ expr sqrt( ( pow($lfrnt,2) - pow($lfrnt_y,2) ) ) ]

        return "[ expr $tl_x + $lfrnt_x ]  [ expr $wd / 2 ] "
   }


   #-------------------------------------------------------------------------
       #  compute frame geometry in replace component mode
       #
   proc compute_replace_geometry {} {
    
            variable CURRENT_Project
            variable CURRENT_Replace
        
        ::Debug  p  1
           
        array set CURRENT_Replace {}
        array set CURRENT_Replace [array get CURRENT_Project]
        
        #tk_messageBox -message "CENTER_BottomBracket:  $CURRENT_Project(CENTER_BottomBracket)  -> $CURRENT_Replace(CENTER_BottomBracket)"
        
        set fw_c    $CURRENT_Replace(CENTER_FrontWheel)     
        set rw_c    $CURRENT_Replace(CENTER_RearWheel)      
        set ht_a    $control::CURRENT_Config(HeadTube_Angle) 
        set fwd     [ expr 2 * $control::CURRENT_Config(Wheel_Front_Tyre_Height) + $control::CURRENT_Config(Wheel_Front_Rim_Diameter) ] 
        set rwd     [ expr 2 * $control::CURRENT_Config(Wheel_Rear_Tyre_Height)  + $control::CURRENT_Config(Wheel_Rear_Rim_Diameter)  ] 
      
        set fwd_cmp [ expr 2 * $control::CURRENT_Config(Comp_Wheel_Front_Tyre_Height) + $control::CURRENT_Config(Comp_Wheel_Front_Rim_Diameter) ] 
        set rwd_cmp [ expr 2 * $control::CURRENT_Config(Comp_Wheel_Rear_Tyre_Height)  + $control::CURRENT_Config(Comp_Wheel_Rear_Rim_Diameter)  ] 
       
        set fr_cmp  $control::CURRENT_Config(Comp_Fork_Rake) 

        set fw_c_n  [ mathematic::calc_point_length_arc   $CURRENT_Replace(CENTER_ForkBase)     $control::CURRENT_Config(Comp_Fork_Heigth)  -$ht_a ]
        set fw_c_n  [ mathematic::calc_point_length_arc   $fw_c_n  $fr_cmp  [expr  -$ht_a+90] ]
	
	
          # baseline   center rear-wheel  -  center front-wheel based on changed fork
        set rot_fork      [ expr -[mathematic::calc_vect_direction $CURRENT_Replace(CENTER_RearWheel)  $fw_c_n] ]
        set xy            [ mathematic::VSub $CURRENT_Replace(CENTER_RearWheel)  $fw_c_n ]
            foreach {xy_x xy_y} $xy break       
        set dist_wh_fork  [ expr  hypot($xy_x,$xy_y) ]
        ::Debug  t  "  rot_fork $rot_fork  ||  dist_wh_fork $dist_wh_fork " 1
        
        
          # baseline   ground rear-wheel  -  ground front-wheel based on differnt wheel size
        set wh_rad_diff   [ expr 0.5*($rwd_cmp-$fwd_cmp) ]
        set rot_wheel     [ mathematic::grad [ expr asin($wh_rad_diff / $dist_wh_fork) ] ] 
        ::Debug  t  "  wh_rad_diff $wh_rad_diff  ||  rot_wheel $rot_wheel " 1


          # resulting rotation angle 
        set rot_a         [ expr $rot_fork - $rot_wheel ]

          # compute new position of bottom-bracket
        set bb_n    [ mathematic::rotate_point $CURRENT_Replace(CENTER_RearWheel)  $CURRENT_Replace(CENTER_BottomBracket)  $rot_a ] 
          # tk_messageBox -message " last position of bottom-bracket:  $CURRENT_Replace(CENTER_BottomBracket)"
          # tk_messageBox -message " new position of bottom-bracket:  $bb_n"
        set mv_x    [ list [expr - [lindex $bb_n 0] ]  0 ]

        set fw_c_n  [ mathematic::rotate_point $CURRENT_Replace(CENTER_RearWheel)    $fw_c_n  $rot_a ] 
        
        set CURRENT_Replace(CENTER_BottomBracket)   [mathematic::VAdd $bb_n    $mv_x]
        set CURRENT_Replace(CENTER_FrontWheel)      [mathematic::VAdd $fw_c_n  $mv_x]
        set CURRENT_Replace(CENTER_RearWheel)       [mathematic::VAdd $rw_c    $mv_x]
        set CURRENT_Replace(Wheel_Front_Diameter)   $fwd_cmp
        set CURRENT_Replace(Wheel_Rear_Diameter)    $rwd_cmp
        
        foreach id { CENTER_DownTube_Head   
                     CENTER_TopTube_Seat     CENTER_TopTube_Head
                     CENTER_Seat_Top         CENTER_SeatStay_Top
                     CENTER_HeadTube_Bottom  CENTER_HeadTube_Top
                     CENTER_Stem             CENTER_HandleBar     
                     CENTER_ForkBase } {
                     
                     eval [ format "set id_var \$CURRENT_Replace($id)" ]
                     set xy   [ mathematic::rotate_point  $rw_c  $id_var  $rot_a ]  
                     set xy   [ mathematic::VAdd   $xy    $mv_x ]
                     eval [format "set CURRENT_Replace($id)  { $xy }"] 
        }

        if { [ expr $rwd ne $fwd_cmp ] || [ expr $rwd ne $rwd_cmp] } {
             set mv_y [ list  0  [ expr ( $rwd_cmp - $rwd ) / 2 ] ]
             foreach id { CENTER_BottomBracket    CENTER_DownTube_Head
                          CENTER_RearWheel        CENTER_FrontWheel
                          CENTER_TopTube_Seat     CENTER_TopTube_Head     
                          CENTER_Seat_Top         CENTER_SeatStay_Top
                          CENTER_HeadTube_Bottom  CENTER_HeadTube_Top
                          CENTER_Stem             CENTER_HandleBar        
                          CENTER_ForkBase } {
                          eval [ format "set id_var \$CURRENT_Replace($id)" ]
                          set xy   [ mathematic::VAdd  $id_var  $mv_y ] 
                          set $id_var  $xy 
                          
                          eval [format "set CURRENT_Replace($id)  { $xy }"] 
             }
        }
        # tk_messageBox -message "CENTER_BottomBracket:  $CURRENT_Project(CENTER_BottomBracket)  -> $CURRENT_Replace(CENTER_BottomBracket)"


        set CURRENT_Replace(CENTER_TopTube_Heigth) \
                           [mathematic::Intersect $CURRENT_Replace(CENTER_TopTube_Seat)    $CURRENT_Replace(CENTER_TopTube_Head) \
                                                  [list $control::CURRENT_Config(TopTube_Pivot) 0] [list $control::CURRENT_Config(TopTube_Pivot) 100] ]
        
        set CURRENT_Replace(CENTER_HeadTube_Base) \
                           [mathematic::Intersect $CURRENT_Replace(CENTER_HeadTube_Top)  $CURRENT_Replace(CENTER_HeadTube_Bottom) {0 0} {100 0} ]
        
        set CURRENT_Replace(CENTER_SeatTube_Base) \
                           [mathematic::Intersect $CURRENT_Replace(CENTER_TopTube_Seat)  $CURRENT_Replace(CENTER_BottomBracket)   {0 0} {100 0} ]
        
        set cl_fw_ang      [mathematic::calc_vect_direction    $CURRENT_Replace(CENTER_BottomBracket)  $CURRENT_Replace(CENTER_FrontWheel) ]
       
        set CURRENT_Replace(CENTER_Clearence_BottomBracket) \
                           [mathematic::calc_point_length_arc  $CURRENT_Replace(CENTER_BottomBracket)  $control::CURRENT_Config(CrankArm_Length)  $cl_fw_ang  ]
       
        set CURRENT_Replace(CENTER_Clearence_FrontWheel) \
                           [mathematic::calc_point_length_arc  $CURRENT_Replace(CENTER_FrontWheel)     [expr 0.5*$CURRENT_Replace(Wheel_Rear_Diameter)]  [expr 180 + $cl_fw_ang] ]
   
        set hor_hl         [mathematic::VSub  $CURRENT_Replace(CENTER_ForkBase)  {1000 0} ]
        set ht_a           [mathematic::FindAngle  $CURRENT_Replace(CENTER_HeadTube_Base)  $CURRENT_Replace(CENTER_ForkBase)  $hor_hl ]
        
        set CURRENT_Replace(CENTER_Stem)  [mathematic::calc_point_length_arc  $CURRENT_Replace(CENTER_HeadTube_Top)  $control::CURRENT_Config(Comp_Stem_Heigth)  [expr  $ht_a] ]
       
        set CURRENT_Replace(CENTER_HandleBar) \
                           [mathematic::calc_point_length_arc  $CURRENT_Replace(CENTER_Stem)          $control::CURRENT_Config(Comp_Stem_Length)  [expr  $ht_a - 90 + $control::CURRENT_Config(Comp_Stem_Angle)]  ]
        
   }  


   #-------------------------------------------------------------------------
       #  compute frame outlines
       #
   proc compute_frame_outlines {} {        
            
            variable  CURRENT_Project
            variable  CURRENT_Replace
            variable  OUT_Line

            global    DRAFTING

        
        ::Debug  p  1

         # -- rear dropout template --------------
        set DROPOUT(outline)     {   6 24 0 18 -10 10 -13 6 -14 1 \
                                   -13 -4 -10 -11 -10 -18 -13 -22 -14 -24 -14 -27 \
                                   -13 -30 -10 -33 -11 -36 -8 -36 -3 -35 1 -31 \
                                     3 -26 2 -21 0 -14 -5 0 -4 3 0 5 \
                                     4 3 7 -5 13 -8 19 -10
                                 }
        set DROPOUT(inline)      {  19 3 16 4 13 7 12 11 13 14 }
        set DROPOUT(shifter)     {  -6 -26}
        
        set DROPOUT(outline)                      [translate_template_coords  $DROPOUT(outline)  $CURRENT_Project(CENTER_RearWheel)]
        set DROPOUT(inline)                       [translate_template_coords  $DROPOUT(inline)   $CURRENT_Project(CENTER_RearWheel)]
        set CURRENT_Project(CENTER_RearShifter)   [translate_template_coords  $DROPOUT(shifter)  $CURRENT_Project(CENTER_RearWheel)]

                        
        # -- taper position --------------
           set ang_ttube                  [mathematic::calc_vect_direction    $CURRENT_Project(CENTER_TopTube_Seat) \
                                                                                $CURRENT_Project(CENTER_TopTube_Head) ]
        set COORD(TAPER_TopTube_Seat)     [mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_TopTube_Seat)  \
                                                                                 80  $ang_ttube ]
        set COORD(TAPER_TopTube_Head)     [mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_TopTube_Head)  \
                                                                                -80  $ang_ttube ]
        
           set ang_dtube                  [mathematic::calc_vect_direction    $CURRENT_Project(CENTER_BottomBracket) \
                                                                                $CURRENT_Project(CENTER_DownTube_Head) ]
        set COORD(TAPER_DownTube_BB)      [mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_BottomBracket)  \
                                                                                120  $ang_dtube ]
        set COORD(TAPER_DownTube_Head)    [mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_DownTube_Head)  \
                                                                                -80  $ang_dtube ]
        
           set ang_stube                  [mathematic::calc_vect_direction    $CURRENT_Project(CENTER_BottomBracket) \
                                                                                $CURRENT_Project(CENTER_SeatTube_Top) ]
        set COORD(TAPER_SeatTube_BB)      [mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_BottomBracket)  \
                                                                                120  $ang_stube ]
        set COORD(TAPER_SeatTube_Top)     [mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_SeatTube_Top)  \
                                                                               -130  $ang_stube ]
        
          # -- outline ---------------------

        set COORD(TopTube)   [tube_outline_direction \
                                                   $CURRENT_Project(CENTER_TopTube_Head)     \
                                                   $CURRENT_Project(CENTER_TopTube_Seat)     \
                                                   $control::CURRENT_Config(TopTube_Diameter) ]
        set COORD(HeadTube)  [tube_outline_direction \
                                                   $CURRENT_Project(CENTER_HeadTube_Top)     \
                                                   $CURRENT_Project(CENTER_HeadTube_Bottom)  \
                                                   $control::CURRENT_Config(HeadTube_Diameter) ]
        set COORD(SeatTube)  [tube_outline_direction \
                                                   $CURRENT_Project(CENTER_BottomBracket)    \
                                                   $CURRENT_Project(CENTER_SeatTube_Top)     \
                                                   $control::CURRENT_Config(SeatTube_Diameter) ]
        set COORD(DownTube)  [tube_outline_direction \
                                                   $CURRENT_Project(CENTER_BottomBracket)    \
                                                   $CURRENT_Project(CENTER_DownTube_Head)    \
                                                   $control::CURRENT_Config(DownTube_Diameter) ]


        set COORD(TopTube_Taper_Seat)   [tube_outline_direction   \
                                                   $CURRENT_Project(CENTER_TopTube_Seat)    \
                                                   $COORD(TAPER_TopTube_Seat)     \
                                                   $control::CURRENT_Config(TopTube_Diameter_SL) ]

        set COORD(TopTube_Taper_Head)   [tube_outline_direction   \
                                                   $CURRENT_Project(CENTER_TopTube_Head)    \
                                                   $COORD(TAPER_TopTube_Head)     \
                                                   $control::CURRENT_Config(TopTube_Diameter) ]

        set COORD(DownTube_Taper_BB)    [tube_outline_direction   \
                                                   $CURRENT_Project(CENTER_BottomBracket)   \
                                                   $COORD(TAPER_DownTube_BB)      \
                                                   $control::CURRENT_Config(DownTube_BB_Diameter) ]

        set COORD(DownTube_Taper_Head)  [tube_outline_direction   \
                                                   $CURRENT_Project(CENTER_DownTube_Head)   \
                                                   $COORD(TAPER_DownTube_Head)    \
                                                   $control::CURRENT_Config(DownTube_Diameter) ]

        set COORD(SeatTube_Taper_BB)    [tube_outline_direction   \
                                                   $CURRENT_Project(CENTER_BottomBracket)   \
                                                   $COORD(TAPER_SeatTube_BB)      \
                                                   $control::CURRENT_Config(SeatTube_BB_Diameter) ]

        set COORD(SeatTube_Taper_Top)   [tube_outline_direction   \
                                                   $CURRENT_Project(CENTER_SeatTube_Top)    \
                                                   $COORD(TAPER_SeatTube_Top)     \
                                                   $control::CURRENT_Config(SeatTube_Diameter) ]

                                                    
           set ang_s_stay    [mathematic::calc_vect_direction   $CURRENT_Project(CENTER_RearWheel) \
                                                                $CURRENT_Project(CENTER_SeatStay_Top) ] 
           set p_c_s_stay    [mathematic::calc_point_length_arc \
                                                                $CURRENT_Project(CENTER_RearWheel) \
                                                                [expr 35 + $control::CURRENT_Config(SeatStay_TaperLength)] \
                                                                $ang_s_stay ]                                                    
           set p_drop_sst    [mathematic::calc_point_length_arc \
                                                                $CURRENT_Project(CENTER_RearWheel) \
                                                                35 \
                                                                $ang_s_stay ]  
                                                                
        set COORD(SeatStay)     [tube_outline_direction \
                                                    $CURRENT_Project(CENTER_RearWheel) \
                                                    $p_c_s_stay \
                                                    $control::CURRENT_Config(SeatStay_Diameter) ]
        set COORD(SeatStay_DO)  [tube_outline_direction \
                                                    $CURRENT_Project(CENTER_RearWheel) \
                                                    $p_drop_sst \
                                                    $control::CURRENT_Config(SeatStay_Diameter_2) ]
                                                    

           set ang_c_stay    [mathematic::calc_vect_direction   $CURRENT_Project(CENTER_RearWheel) \
                                                                $CURRENT_Project(CENTER_BottomBracket)    ] 
           set p_c_c_stay    [mathematic::calc_point_length_arc \
                                                                $CURRENT_Project(CENTER_RearWheel) \
                                                                [expr 30 + $control::CURRENT_Config(ChainStay_TaperLength)] \
                                                                $ang_c_stay ]                                                    
           set p_drop_cst    [mathematic::calc_point_length_arc \
                                                                $CURRENT_Project(CENTER_RearWheel) \
                                                                30 \
                                                                $ang_c_stay ]  
        set COORD(ChainStay)    [tube_outline_direction \
                                                    $CURRENT_Project(CENTER_BottomBracket) \
                                                    $p_c_c_stay \
                                                    $control::CURRENT_Config(ChainStay_Diameter) ]
        set COORD(ChainStay_DO) [tube_outline_direction \
                                                    $CURRENT_Project(CENTER_RearWheel) \
                                                    $p_drop_cst \
                                                    $control::CURRENT_Config(ChainStay_Diameter_2) ]
                                                    
                                            
              # lib_canvas::draw_circle      $w  [lindex $COORD(TopTube_Taper_Seat)  2]   5  $tag  blue 1
              # lib_canvas::draw_circle      $w  [lindex $COORD(TopTube_Taper_Head)  3]   5  $tag  blue 1

              # lib_canvas::draw_circle      $w  [lindex $COORD(DownTube_Taper_BB)   3]   5  $tag  blue 1
              # lib_canvas::draw_circle      $w  [lindex $COORD(DownTube_Taper_Head) 2]   5  $tag  blue 1

              # lib_canvas::draw_circle      $w  [lindex $COORD(SeatTube_Taper_BB)   2]   5  $tag  blue 1
              # lib_canvas::draw_circle      $w  [lindex $COORD(SeatTube_Taper_Top)  3]   5  $tag  blue 1
                                                    
       
              # lib_canvas::draw_circle      $w  [lindex $COORD(TopTube_Taper_Seat)  3]   5  $tag  red 2
              # lib_canvas::draw_circle      $w  [lindex $COORD(TopTube_Taper_Head)  2]   5  $tag  red 2

              # lib_canvas::draw_circle      $w  [lindex $COORD(DownTube_Taper_BB)   2]   5  $tag  red 2
              # lib_canvas::draw_circle      $w  [lindex $COORD(DownTube_Taper_Head) 3]   5  $tag  red 2

              # lib_canvas::draw_circle      $w  [lindex $COORD(SeatTube_Taper_BB)   3]   5  $tag  red 2
              # lib_canvas::draw_circle      $w  [lindex $COORD(SeatTube_Taper_Top)  2]   5  $tag  red 2

           
           #
           # -- counter_clock_wise -----------------------  
           #
           
           # -- OUT_Line(frame) ----------------------
             #
             # -- downtube -----------------  #  0 -  3
           set      OUT_Line(frame)  [list [lindex $COORD(DownTube_Taper_BB)   1] ]
           lappend  OUT_Line(frame)  [lindex $COORD(DownTube_Taper_BB)   2]
           lappend  OUT_Line(frame)  [lindex $COORD(DownTube_Taper_Head) 3]
           lappend  OUT_Line(frame)  [mathematic::Intersect  \
                                                  [lindex $COORD(HeadTube)            1]  [lindex $COORD(HeadTube)            2]  \
                                                  [lindex $COORD(DownTube_Taper_Head) 0]  [lindex $COORD(DownTube_Taper_Head) 3] ] 
              
             # -- headtube -----------------  #  4 -  7
           lappend  OUT_Line(frame)  [lindex $COORD(HeadTube)             2]
           lappend  OUT_Line(frame)  [lindex $COORD(HeadTube)             3]
           lappend  OUT_Line(frame)  [lindex $COORD(HeadTube)             0]
           lappend  OUT_Line(frame)  [lindex $COORD(HeadTube)             1]

             # -- toptube ------------------  #  8 - 11
           lappend  OUT_Line(frame)  [mathematic::Intersect  \
                                                  [lindex $COORD(HeadTube)            1]  [lindex $COORD(HeadTube)            2]  \
                                                  [lindex $COORD(TopTube_Taper_Head)  1]  [lindex $COORD(TopTube_Taper_Head)  2] ]
           lappend  OUT_Line(frame)  [lindex $COORD(TopTube_Taper_Head)   2]
           lappend  OUT_Line(frame)  [lindex $COORD(TopTube_Taper_Seat)   3]
           lappend  OUT_Line(frame)  [mathematic::Intersect  \
                                                  [lindex $COORD(SeatTube_Taper_Top)  0]  [lindex $COORD(SeatTube_Taper_Top)  3]  \
                                                  [lindex $COORD(TopTube_Taper_Seat)  0]  [lindex $COORD(TopTube_Taper_Seat)  3] ] 
            
             # -- seattube -----------------  # 12 - 14
           lappend  OUT_Line(frame)  [lindex $COORD(SeatTube_Taper_Top)   0] 
           lappend  OUT_Line(frame)  [lindex $COORD(SeatTube_Taper_Top)   1] 
           lappend  OUT_Line(frame)  [mathematic::Intersect  \
                                                  [lindex $COORD(SeatTube_Taper_Top)  1]  [lindex $COORD(SeatTube_Taper_Top)  2]  \
                                                  [lindex $COORD(SeatStay)            0]  [lindex $COORD(SeatStay)            3] ]
 
             # -- seatstay -----------------  # 15 - 18
           lappend  OUT_Line(frame)  [lindex $COORD(SeatStay)            3 ] 
           lappend  OUT_Line(frame)  [lindex $COORD(SeatStay_DO)         3 ] 
           
           lappend  OUT_Line(frame)  [lindex $COORD(SeatStay_DO)         2 ]
           lappend  OUT_Line(frame)  [lindex $COORD(SeatStay)            2 ] 
             
             # -- seattube -----------------  # 19 - 22
           lappend  OUT_Line(frame)  [mathematic::Intersect  \
                                                      [lindex $COORD(SeatTube_Taper_Top)   1]  [lindex $COORD(SeatTube_Taper_Top)   2]  \
                                                      [lindex $COORD(SeatStay)             1]  [lindex $COORD(SeatStay)             2] ] 
           lappend  OUT_Line(frame)  [lindex $COORD(SeatTube_Taper_Top)  2 ]
           lappend  OUT_Line(frame)  [lindex $COORD(SeatTube_Taper_BB)   3 ]
           lappend  OUT_Line(frame)  [mathematic::Intersect  \
                                                      [lindex $COORD(SeatTube_Taper_BB)   0]  [lindex $COORD(SeatTube_Taper_BB)   3]  \
                                                      [lindex $COORD(ChainStay)           1]  [lindex $COORD(ChainStay)           2] ] 
             
             # -- chainstay ----------------  # 23 - 27
           lappend  OUT_Line(frame)  [lindex $COORD(ChainStay)           2 ]
           lappend  OUT_Line(frame)  [lindex $COORD(ChainStay_DO)        3 ]
           lappend  OUT_Line(frame)  [lindex $COORD(ChainStay_DO)        2 ]  
           lappend  OUT_Line(frame)  [lindex $COORD(ChainStay)           3 ] 
           lappend  OUT_Line(frame)  [lindex $COORD(ChainStay)           0 ] 

           
           # -- inline maintubes ---------------------- # 28
           lappend  OUT_Line(frame)  $CURRENT_Project(CENTER_BottomBracket) 

             #
             # -- seattube -----------------  # 29 - 31             
           lappend  OUT_Line(frame)  [mathematic::Intersect  \
                                                  [lindex $COORD(SeatTube_Taper_BB)    1]  [lindex $COORD(SeatTube_Taper_BB)    2]  \
                                                  [lindex $COORD(DownTube_Taper_BB)    0]  [lindex $COORD(DownTube_Taper_BB)    3] ]    
           lappend  OUT_Line(frame)  [lindex $COORD(SeatTube_Taper_BB)   2 ]  
           lappend  OUT_Line(frame)  [lindex $COORD(SeatTube_Taper_Top)  3 ]   

             # -- toptube ------------------  # 32 - 34
           lappend  OUT_Line(frame)  [mathematic::Intersect  \
                                                  [lindex $COORD(SeatTube_Taper_Top)   0]  [lindex $COORD(SeatTube_Taper_Top)   3]  \
                                                  [lindex $COORD(TopTube_Taper_Seat)   1]  [lindex $COORD(TopTube_Taper_Seat)   2] ] 
           lappend  OUT_Line(frame)  [lindex $COORD(TopTube_Taper_Seat)  2 ]
           lappend  OUT_Line(frame)  [lindex $COORD(TopTube_Taper_Head)  3 ]

             # -- headtube -----------------  # 35 - 36
           lappend  OUT_Line(frame)  [mathematic::Intersect  \
                                                  [lindex $COORD(HeadTube)             1]  [lindex $COORD(HeadTube)             2]  \
                                                  [lindex $COORD(TopTube_Taper_Head)   0]  [lindex $COORD(TopTube_Taper_Head)   3] ]
           lappend  OUT_Line(frame)  [mathematic::Intersect \
                                                  [lindex $COORD(HeadTube)             1]  [lindex $COORD(HeadTube)             2]  \
                                                  [lindex $COORD(DownTube_Taper_Head)  1]  [lindex $COORD(DownTube_Taper_Head)  2] ]
        
              # -- downtube -----------------  # 37 - 39
           lappend  OUT_Line(frame)  [lindex $COORD(DownTube_Taper_Head) 2 ]   
           lappend  OUT_Line(frame)  [lindex $COORD(DownTube_Taper_BB)   3 ]   
           
           lappend  OUT_Line(frame)  [mathematic::Intersect  \
                                                  [lindex $COORD(SeatTube_Taper_BB)    1]  [lindex $COORD(SeatTube_Taper_BB)    2]  \
                                                  [lindex $COORD(DownTube_Taper_BB)    0]  [lindex $COORD(DownTube_Taper_BB)    3] ]    

           # -- inline maintubes ---------------------- # 40 - 0
           lappend  OUT_Line(frame)  $CURRENT_Project(CENTER_BottomBracket) 


           # -- OUT_Line(dropout) ----------------------
             #
             # -- rear triangle ------------
           set      OUT_Line(dropout)    [concat $DROPOUT(outline) ]
           lappend  OUT_Line(dropout)    [lindex $COORD(ChainStay_DO)        2 ]
           lappend  OUT_Line(dropout)    [lindex $COORD(ChainStay_DO)        3 ]  
           set      OUT_Line(dropout)    [concat $OUT_Line(dropout) $DROPOUT(inline)] 
           lappend  OUT_Line(dropout)    [lindex $COORD(SeatStay_DO)         2 ]
           lappend  OUT_Line(dropout)    [lindex $COORD(SeatStay_DO)         3 ]
             # tk_messageBox -message " outline:  [llength  $OUT_Line(dropout)]   $OUT_Line(dropout)"         
   }


   #-------------------------------------------------------------------------
       #  tube outline direction
       #
   proc tube_outline_direction {p1 p2 diameter} {
             
        ::Debug  p  1

        set tube_angle   [mathematic::calc_vect_direction $p1 $p2 ]
        set diameter_vct [mathematic::calc_point_length_arc {0 0} [expr 0.5*$diameter] [expr 90+$tube_angle] ]
         
        set p1a          [mathematic::VAdd  $p1  $diameter_vct ]
        set p1b          [mathematic::VSub  $p1  $diameter_vct ]
        set p2a          [mathematic::VAdd  $p2  $diameter_vct ]
        set p2b          [mathematic::VSub  $p2  $diameter_vct ]
         
         # lib_canvas::draw_circle $w $p1a   5  debug  gray  1
         # lib_canvas::draw_circle $w $p1b   5  debug  gray  1
         # lib_canvas::draw_circle $w $p2a   5  debug  gray  1
         # lib_canvas::draw_circle $w $p2b   5  debug  gray  1
         
         # $w create text [lindex $p1a 0] [lindex $p1a 1]  -tags debug  -text 0  
         # $w create text [lindex $p1b 0] [lindex $p1b 1]  -tags debug  -text 1  
         # $w create text [lindex $p2b 0] [lindex $p2b 1]  -tags debug  -text 2  
         # $w create text [lindex $p2a 0] [lindex $p2a 1]  -tags debug  -text 3  

        return [list $p1a $p1b $p2b $p2a]
   }


   #-------------------------------------------------------------------------
       #  tube outline direction
       #
   proc translate_template_coords {templ_list vct } {
             
        ::Debug  p  1

        set      dx  [lindex $vct 0]
        set      dy  [lindex $vct 1]
        
        set output {}
        set i 0
        
        while {$i < [llength $templ_list]} {
            set new_x [expr $dx + [lindex $templ_list $i]]
            set new_y [expr $dy + [lindex $templ_list [expr $i+1]]]
            set i [expr $i + 2]
            set output [lappend output  [list $new_x  $new_y] ]
        }
        
        if {[llength $output] > 1} {
            return $output
        } else {
            return "[lindex $output 0]  [lindex $output 1]"
        }
   }


   #-------------------------------------------------------------------------
       #  draw bicycle wheel
       #
   proc draw_wheels { w data tag lw colour {style centerline} {rim_colour gray}} {
            
          variable CURRENT_Project
          variable CURRENT_Replace
        
        ::Debug  p  1
        
        array set PRJ_DATA  [array get $data]
        #set fwr     [ expr $CURRENT_Project(Wheel_Diameter_Front) / 2 ]
        #set rwr     [ expr $CURRENT_Project(Wheel_Diameter_Rear)  / 2 ]
        
        lib_canvas::draw_circle  $w  $PRJ_DATA(CENTER_RearWheel) \
                                     [expr 0.5*$PRJ_DATA(Wheel_Rear_Diameter)]  \
                                     [list $tag rearwheel] \
                                     $colour \
                                     $lw \
                                     {}
                                     
        lib_canvas::draw_circle  $w  $PRJ_DATA(CENTER_FrontWheel) \
                                     [expr 0.5*$PRJ_DATA(Wheel_Front_Diameter)] \
                                     [list $tag frontwheel] \
                                     $colour \
                                     $lw \
                                     {}
        
        lib_canvas::delete_item  $w  rim_rearwheel 
        lib_canvas::delete_item  $w  rim_frontwheel 
        
        lib_canvas::draw_circle  $w  $PRJ_DATA(CENTER_RearWheel) \
                                     [expr 0.5*$control::CURRENT_Config(Wheel_Rear_Rim_Diameter) + 5]  \
                                     [list $tag rim_rearwheel] \
                                     $rim_colour \
                                     $lw \
                                     {}
        lib_canvas::draw_circle  $w  $PRJ_DATA(CENTER_FrontWheel) \
                                     [expr 0.5*$control::CURRENT_Config(Wheel_Front_Rim_Diameter) + 5] \
                                     [list $tag rim_frontwheel] \
                                     $rim_colour \
                                     $lw \
                                     {}
   }


   #-------------------------------------------------------------------------
       #  draw rims
       #
   proc draw_rims { w data tag lw colour {style centerline} {fill_colour "#101010"}} {
            
        ::Debug  p  1
        
        set Rim_Front_InnerBrake_Radius        [expr 0.5*$control::CURRENT_Config(Wheel_Front_Rim_Diameter)  -5]
        set Rim_Front_Inner_Radius             [expr     $Rim_Front_InnerBrake_Radius                -16]
        set Rim_Rear__InnerBrake_Rear_Radius   [expr 0.5*$control::CURRENT_Config(Wheel_Rear_Rim_Diameter)   -5]
        set Rim_Rear__Inner_Front_Radius       [expr     $Rim_Rear__InnerBrake_Rear_Radius           -16]
        
        if {![string equal $style {centerline}]} {
		    set      colour black
		    set fill_colour white
		}

		lib_canvas::draw_circle $w $geometry::CURRENT_Project(CENTER_FrontWheel) $Rim_Front_InnerBrake_Radius         $tag  $colour $lw $fill_colour
		lib_canvas::draw_circle $w $geometry::CURRENT_Project(CENTER_FrontWheel) $Rim_Front_Inner_Radius              $tag  $colour $lw white 

		lib_canvas::draw_circle $w $geometry::CURRENT_Project(CENTER_RearWheel)  $Rim_Rear__InnerBrake_Rear_Radius    $tag  $colour $lw $fill_colour            
		lib_canvas::draw_circle $w $geometry::CURRENT_Project(CENTER_RearWheel)  $Rim_Rear__Inner_Front_Radius        $tag  $colour $lw white
   }

   
   #-------------------------------------------------------------------------
       #  draw saddle 
       #
   proc draw_saddle { w data tag lw colour {style centerline} {fill_style blnk} } {
            
          variable CURRENT_Project
          variable CURRENT_Replace
          variable OUT_Line

        ::Debug  p  1
        
        array set PRJ_DATA  [array get $data]               
        set xy   $PRJ_DATA(CENTER_Seat_Top)         

        set x  [ lindex $xy 0] 
        set y  [ lindex $xy 1] 
        
        if {[string match $fill_style blank ]} {
            set fill_colour   white  
        } else {
            set fill_colour   $colour  
        }
   
        if {[string equal $style {centerline}]} {
        
             $w create line  [ expr $x  - 120 ]  [ expr $y + 10 ] \
                             [ expr $x  -  30 ]  $y \
                             [ expr $x  + 140 ]  $y \
                             [ expr $x  + 150 ]  [ expr $y -  5 ] \
                             [ expr $x  + 155 ]  [ expr $y -  8 ] \
                 -tags [ list $tag saddle ]   -fill $fill_colour   -width $lw  -smooth true 
                 
           } else {
           
             $w create polygon   -199 20 -191 25 -177 27 -158 28 -140 26 -113 25 -62 25 1 26 17 26 34 25 55 22 68 16 75 \
                              10 75 3 72 1 35 7 17 8 -11 8 -44 6 -76 2 -113 -6 -127 -6 -140 -3 -164 3 -184 10 -195 12 -199 12 \
                             -200 15 -199 20  \
                 -tags [ list $tag saddle ]   -fill $fill_colour  -outline $colour  -width $lw  -smooth false  
            
             $w create polygon   -155 1 -139 -10 -136 -10 -132 -5 -155 1 \
                 -tags [ list $tag saddle ]   -fill white         -outline $colour   -width $lw  -smooth false  
     
             $w create polygon   -136 -9 -127 -16 -120 -19 -113 -20 -57 -17 -41 -14 -29 -8 -8 8 -11 8 -18 8 -33 -3 -43 -9 \
                             -57 -11 -112 -14 -119 -14 -124 -11 -132 -5 -136 -9 \
                 -tags [ list $tag saddle ]   -fill white         -outline $colour   -width $lw  -smooth false  
                 
             $w create polygon   -97 -10 -81 -7 -64 -8 -63 -21 -72 -25 -87 -25 -96 -23 -97 -10 \
                 -tags [ list $tag saddle ]   -fill white         -outline $colour   -width $lw  -smooth false  
            
                # $w create line   -79 24 -75 20 \
                #   -tags [ list $tag saddle ]   -fill $colour   -width $lw  -smooth false 
                #    Line -87 -25 -92 -40
                #    Line -72 -25 -65 -41;
                #  $w create line  -87 -25    0  0  -72 -25 \
                 #     -tags [ list $tag saddle ]   -fill $colour   -width $lw  -smooth false  

             set move_xy [mathematic::VSub  $xy  {-79 24}]
             
             $w move saddle [lindex $move_xy 0] [lindex $move_xy 1]
             
             set OUT_Line(SeatPost_1)   [mathematic::VAdd  $move_xy  {-87 -25}]
             set OUT_Line(SeatPost_2)   [mathematic::VAdd  $move_xy  {-72 -25}]
             
           }     
   }


   #-------------------------------------------------------------------------
       #  draw handlebar 
       #
   proc draw_handlebar { w data tag lw colour {style centerline} {fill_style blank} } {
            
          variable CURRENT_Project
          variable CURRENT_Replace
        
        ::Debug  p  1
        
        if {[string match $fill_style blank ]} {
            set fill_colour   white  
        } else {
            set fill_colour   $colour  
        }

		set HandleBar_Type  $control::CURRENT_Config(HandleBar_Type)

        array set PRJ_DATA  [array get $data]

        set xy   $PRJ_DATA(CENTER_HandleBar)

        set x  [ lindex $xy 0] 
        set y  [ lindex $xy 1] 

       if {[string equal $style {centerline}]} {
        
             switch $HandleBar_Type {
                      drop_bar {   $w create line  $x                   $y \
                                                    [ expr $x  +  67 ]   $y \
                                                    [ expr $x  +  86 ]   [ expr $y  -  13 ] \
                                                    [ expr $x  +  98 ]   [ expr $y  -  41 ] \
                                                    [ expr $x  +  94 ]   [ expr $y  -  66 ] \
                                                    [ expr $x  +  63 ]   [ expr $y  - 100 ] \
                                                    [ expr $x  +  51 ]   [ expr $y  - 124 ] \
                                                    [ expr $x  +  30 ]   [ expr $y  - 143 ] \
                                                    [ expr $x  -  20 ]   [ expr $y  - 159 ] \
                                              -tags [ list $tag handlebar ]   -fill $colour  -width $lw 
                      
                                    $w create line  [ expr $x  +  80 ]   [ expr $y  +  17 ] \
                                                    [ expr $x  + 115 ]   [ expr $y  +  17 ] \
                                                    [ expr $x  + 125 ]   [ expr $y  +  24 ] \
                                                    [ expr $x  + 129 ]   [ expr $y  +  34 ] \
                                                    [ expr $x  + 133 ]   [ expr $y  +  40 ] \
                                                    [ expr $x  + 147 ]   [ expr $y  +  40 ] \
                                                    [ expr $x  + 152 ]   [ expr $y  +  34 ] \
                                                    [ expr $x  + 163 ]   [ expr $y  +   0 ] \
                                                    [ expr $x  + 171 ]   [ expr $y  -  15 ] \
                                                    [ expr $x  + 171 ]   [ expr $y  -  60 ] \
                                                    [ expr $x  + 179 ]   [ expr $y  -  87 ] \
                                                    [ expr $x  + 193 ]   [ expr $y  - 107 ] \
                                             -tags [ list $tag handlebar ]  -fill $colour  -width $lw  -smooth true  
                  
                                    set Radius      13
                                    $w create oval  [ expr $x  - $Radius ]   [ expr $y  - $Radius ] \
                                                    [ expr $x  + $Radius ]   [ expr $y  + $Radius ] \
                                              -tags [ list $tag handlebar ]  -outline $colour

                                    lib_canvas::rotate_item $w  $x $y -10  handlebar
                                    # eval lib_canvas::rotate_item $w  $x $y -10  handlebar
                                }
                      flat_bar {    $w create line  $x                   $y \
                                                    [ expr $x  -  25 ]   $y \
                                                    [ expr $x  +  45 ]   [ expr $y  -  55 ] \
                                              -tags [ list $tag handlebar ]   -fill $colour  -width $lw 
                      
                                    $w create line  [ expr $x  -  25 ]   $y \
                                                    [ expr $x  + 100 ]   [ expr $y  +  50 ] \
                                              -tags [ list $tag handlebar ]  -fill $colour  -width $lw  -smooth true  
                  
                                    set Radius      13
                                    $w create oval  [ expr $x  - $Radius ]   [ expr $y  - $Radius ] \
                                                    [ expr $x  + $Radius ]   [ expr $y  + $Radius ] \
                                              -tags [ list $tag handlebar ]  -outline $colour
                                }
                      time_trial {  $w create line  $x                   $y \
                                                    [ expr $x  +  10 ]   [ expr $y  -  24 ] \
                                                    [ expr $x  +  90 ]   [ expr $y  -  05 ] \
                                                    [ expr $x  + 145 ]   [ expr $y  +  25 ] \
                                                    [ expr $x  + 250 ]   [ expr $y  +  50 ] \
                                              -tags [ list $tag handlebar ]   -fill $colour  -width $lw 
                      
                                    $w create line  [ expr $x  + 255 ]   [ expr $y  +  30 ] \
                                                    [ expr $x  + 265 ]   [ expr $y  +  05 ] \
                                                    [ expr $x  + 215 ]   [ expr $y  -  15 ] \
                                                    [ expr $x  + 155 ]   [ expr $y  -  25 ] \
                                                    [ expr $x  + 135 ]   [ expr $y  -  35 ] \
                                              -tags [ list $tag handlebar ]   -fill $colour  -width $lw 
                      
                                    set Radius      13
                                    $w create oval  [ expr $x  - $Radius ]   [ expr $y  - $Radius ] \
                                                    [ expr $x  + $Radius ]   [ expr $y  + $Radius ] \
                                              -tags [ list $tag handlebar ]  -outline $colour
                               }
                }

                $w dtag handlebar
                
       } else {
       
             switch $HandleBar_Type {
                      drop_bar {      # -- dropbar                                      
                                   $w create polygon   -179 65   -189 60   -192 49   -186 38     -175 35   -134 38   -113 32 \
								                       -92 14    -86 3     -85 -13    -91 -28    -100 -41  -114 -62  -124 -73 \
													   -139 -79  -191 -92  -183 -121  -131 -108  -105 -95  -90 -77 \
													   -74 -54   -62 -37   -58 -20    -58 9      -59 15    -75 40 \
													   -114 66   -133 68 \
                                              -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour


									   # -- ergopower 
									   # ---- brakelever
                                   $w create polygon   -13 80  -5 61   5 38    7 27     8 7     10 -8   14 -25  18 -34 \
								                       24 -40  32 -45  34 -49  32 -51   29 -50  19 -44  13 -37  10 -30 \
													   6 -19   1 8     -2 21   -3 30   -7 39   -23 52  \
													   -28 55  -18 92\
                                              -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour     
						   
									   # ---- gearlever
                                   $w create polygon   -10 39  -5 10  -3 0    -1 -4   1 -21   1 -26    -7 -28  -19 -13 \
								                       -20 -6  -11 6  -10 15  -13 38  -23 45    \
													   -35 42  -40 40 -40 56  -32 54 \
													   -22 48 \
                                              -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour     
											  
									   # ---- brakelever - pivot
                                   $w create polygon   -16 91  -13 82  -17 68  -21 66  -21 64  -21 62 \
								                       -19 60  -16 58  -15 56  -15 53  -16 51  -19 50 \
													   -35 55  -19 89 \
                                              -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour     
			
									   # ---- brakelever - hood
                                   $w create polygon   -114 66 -110 50 -81 24 -58 15 -51 29 -35 38 -34 50 -19 89 -16 91 -19 99 -26 105 \
                                                    -35 104 -40 96 -40 85 -44 77 -51 73 -69 69 -89 67 -112 67 \
                                              -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour     



                                      # -- dropbar center ------------------- 
                                      # Line -179 65 -175 35   ->  -177 50;                                      
                                   set move_xy [mathematic::VSub  $xy  {-177 50}]
             
                                   $w move handlebar [lindex $move_xy 0] [lindex $move_xy 1]
                                   lib_canvas::rotate_item $w  $x $y -11  handlebar
                                     # eval lib_canvas::rotate_item $w  $x $y -11  handlebar
                               }
                               
                      time_trial {    # -- arm-rest 
                                   $w create polygon -203 62 -100 73 -118 88 -118 88 -144 92 -172 89 -198 77  \
                                              -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour
   
                                   $w create polygon -107 9 -131 41 -133 69 -171 65 -169 34 -147 3 -107 9 \
                                              -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour
                                        # -- outer bar
                                   $w create polygon -147 3 -91 12 -88 -10 -144 -19 -147 3 \
                                              -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour
   
                                   $w create polygon -87 -14 -91 15 -42 22 -33 27 14 77 35 58 31 54 30 55 16 48 -15 20 \
                                                  -22 2 -21 2 -35 -5 -87 -14 \
                                              -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour
                                        
                                        # -- brake lever
                                   $w create polygon 52 -42 43 -44 29 -41 27 -36 25 -36 23 -36 21 -37 19 -41 17 -42 14 -42 13 -40 12 -37 4 \
                                                  -22 12 -23 50 -38 52 -42 \
                                              -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour

                                   $w create polygon 30 55 16 48 -15 20 -22 2 -8 -5 0 -21 12 -23 50 -38 52 -42 59 -39 66 -32 65 -23 58 -19 46 \
                                                  -18 39 -14 35 -7 32 11 31 31 32 54 30 55 \
                                              -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour

                                   $w create polygon 21 -52 -2 -61 -12 -62 -32 -63 -47 -64 -64 -68 -73 -71 -79 -77 -85 -85 -88 -86 -90 -85 \
                                                  -89 -81 -83 -72 -76 -67 -69 -64 -58 -60 -31 -55 -18 -53 -9 -52 0 -49 9 -33 12 -37 13 -40 14 -42 \
                                                  17 -42 19 -41 21 -37 23 -36 25 -36 27 -36 29 -41 41 -44 21 -52 \
                                              -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour

                                        # -- inner bar
                                   $w create polygon  21 -52 -2 -61 -12 -62 -32 -63 -47 -64 -64 -68 -73 -71 -79 -77 -85 -85 -88 -86 -90 -85 \
                                                   -89 -81 -83 -72 -76 -67 -69 -64 -58 -60 -31 -55 -18 -53 -9 -52 0 -49 9 -33 12 -37 13 -40 14 -42 \
                                                   17 -42 19 -41 21 -37 23 -36 25 -36 27 -36 29 -41 41 -44 21 -52 \
                                              -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour

                                   $w create polygon   10 73 1 70 -17 69 -31 66 -44 58 -80 34 -125 33 -107 9 -91 12 -91 15 -56 20 -50 24 -34 39 \
                                                    -23 45 -16 45 10 73 \
                                              -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour
  
  
                                   $w create polygon  33 60 99 105 88 125 16 76 33 60 \
                                              -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour
                                              
                                      # -- time_trial center ------------------- 
                                      # Line -150 50 -274 141   ->  -150 50;                                      
                                   set move_xy [mathematic::VSub  $xy  {-150 50}]
             
                                   $w move handlebar [lindex $move_xy 0] [lindex $move_xy 1]
                               }
                               
                      flat_bar {                                 
								     # -- handlebar
								   $w create polygon \
								       -58 -14  -50 -14  -46 -13  -42 -11  -39 -7  -38 -3  -38 3  \
									   -40 8    -43 10   -46 12   -50 13   -58 13   -58 0   \
									   -58 -14  \
								             -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour
											 
									 # -- gearlever down
								   $w create polygon \
                                       -95 -26  -98 -36  -94 -45  -89 -52  -76 -58  -70 -58  -63 -57 \
									   -58 -58  -46 -67  -41 -61  -56 -49  -65 -45  -72 -34  -81 -25 \
									   -90 -24  -95 -26 \
									         -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour
                                   $w create line \
                                       -59 -57  -86 -33 \
                                             -tags [ list $tag handlebar ]  -fill $colour

        
                                     # -- brakelever base
								   $w create polygon \
								       -39 -28  -32 -36  -10 -52   -7 -52    4 -37    3 -34  -20 -17 \
									   -28 -12  -41  -2  -47   6  -52  10  -60  14  -69  13  -66  2 \
									   -68 -10  -74 -17  -64 -18  -53 -18  -39 -28 \
											 -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour
                                     # -- brakelever
								   $w create polygon \
                                       -48 -16  -42  -8  -28 -17  -20 -21   1 -39   6 -43   16 -51 \
									    26 -56   26 -63   21 -70   15 -70   9 -61  -1 -52   -6 -48 \
									   -29 -33  -34 -28  -48 -16 \
											 -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour

									 # -- gearlever base
								   $w create polygon \
                                       -71 -18  -59 -29  -66 -40  -26 -71  -18 -59  -21 -50  -31 -43 \
									   -36 -34  -62 -14  -71 -18 \
											 -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour	
                                   $w create line \
                                       -22 -64  -34 -55  -38 -40  -65 -18 \
                                             -tags [ list $tag handlebar ]  -fill $colour

									 # -- gearlever top
								   $w create polygon \
								       -40 -23  -47 -27  -54 -29  -57 -30  -62 -41  -58 -44  -55 -43  -50 -44 \
									   -43 -44  -38 -39  -34 -35  -33 -30  -35 -24  -40 -23 \
									         -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour
                                   $w create line \
								       -59 -41  -55 -38  -47 -39  -42 -33  -38 -26 \
									         -tags [ list $tag handlebar ]  -fill $colour
									 
									 # -- handlebar rubber
								   $w create polygon \
								       -54  -9  -52  -4  -52  3  -54  9  -57 13  -62  16  -71  18  -77  18  -82  16 \
									   -87  12  -90   7  -91  2  -91 -3  -90 -8  -87 -13  -82 -17  -76 -19  -71 -19 \
									   -62 -17  -57 -14  -54 -9 \
									         -tags [ list $tag handlebar ]  -fill $fill_colour  -outline $colour
                                   $w create line \
								       -74 18  -68 17  -62 14  -57 7  -56 2  -56 -3  -57 -8  -62 -15  -68 -17  -74 -19 \
									         -tags [ list $tag handlebar ]  -fill $colour


											 # -- flat-bar center ------------------- 
                                      # Circle -50 0 6;                                
                                   set move_xy [mathematic::VSub  $xy  {-50 0}]
             
								   $w scale handlebar  -50 0  0.8 0.8
								   $w move  handlebar [lindex $move_xy 0] [lindex $move_xy 1]
                               }								   
								   
					  default  {								   
								   
								   draw_handlebar $w  $data  $tag  $lw  $colour  $type  {schema}
                                    
                                   return                                             
                                   $w create line    \
                                              -tags [ list $tag handlebar ]  -fill $colour
                               }
             }
       }       
   }

   
   #-------------------------------------------------------------------------
       #  draw handlebar 
       #
   proc draw_fork { w data tag lw colour {style centerline} {fill_style blank} } {
            
          variable CURRENT_Project
          variable CURRENT_Replace
		  variable OUT_Line
        
        ::Debug  p  1
        
        if {[string match $fill_style blank ]} {
            set fill_colour   white  
        } else {
            set fill_colour   $colour  
        }

		set Fork_Type  $control::CURRENT_Config(Fork_Type)
		
        array set PRJ_DATA  [array get $data]

        if {[string equal $style {centerline}]} {
			 
				 set xy0   $PRJ_DATA(CENTER_FrontWheel)            
				 set xy1   $PRJ_DATA(CENTER_ForkBase)   
				 $w create line  [ lindex $xy0 0]    [ lindex $xy0 1] \
								 [ lindex $xy1 0]    [ lindex $xy1 1] \
					    -tags [ list $tag fork ]           -fill $colour   -width $lw			  
       } else {      
	             switch $Fork_Type {
	                      rigid {   
									#set ForkBlade_Width 32.0
									#set  CURRENT_Config(ForkBlade_Width)             	$CURRENT_Config(HeadTube_Diameter)
									set ForkCrown_Diameter	[expr $control::CURRENT_Config(HeadTube_Diameter) - 4 ]
									
									set ang_fork    [expr 180.0-$control::CURRENT_Config(HeadTube_Angle) ]
								    set p_t_fork    [mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_ForkBase) \
																					   20 \
																					   [expr 180+$ang_fork] ]  
									set ang_blade   [mathematic::calc_vect_direction    $CURRENT_Project(CENTER_FrontWheel) \
																						$p_t_fork ]	
								    set p_b0_fork   [mathematic::calc_point_length_arc  $p_t_fork \
																					   -14 \
																					   [expr 180+$ang_blade] ]  
								    set p_b1_fork   [mathematic::calc_point_length_arc  $p_t_fork \
																					   -4 \
																					   [expr 180+$ang_blade] ]  
								    set p_b2_fork   [mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_FrontWheel) \
																					   250 \
																					   $ang_blade ]  
									set p_b3_fork   [mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_FrontWheel) \
																					   15 \
																					   $ang_blade ]                                                    

																						
								    set COORD(ForkTop2)  	[tube_outline_direction  \
																		   $p_b0_fork \
																		   $p_b1_fork \
																		   [expr $control::CURRENT_Config(ForkBlade_Width)-6] ]						  
									set COORD(ForkBlade)	[tube_outline_direction  \
																		   $p_b1_fork \
																		   $p_b2_fork \
																		   $control::CURRENT_Config(ForkBlade_Width) ]
								    set COORD(ForkDown) [tube_outline_direction \
																		   $CURRENT_Project(CENTER_FrontWheel) \
																		   $p_b3_fork \
																		   14 ]
									
						            # fork-crown
									set p_t_fork    [mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_ForkBase) \
																					   22 \
																					   [expr 180+$ang_fork] ]  
								    set COORD(ForkCrown)  	[tube_outline_direction  \
																		   $CURRENT_Project(CENTER_ForkBase) \
																		   $p_t_fork \
																		   $ForkCrown_Diameter ]
								    
									set      OUT_Line(fork)  [list [lindex $COORD(ForkCrown)  3] ]
								    lappend  OUT_Line(fork)  [lindex $COORD(ForkCrown)  0]  
								    lappend  OUT_Line(fork)  [lindex $COORD(ForkCrown)  1]  
								    lappend  OUT_Line(fork)  [lindex $COORD(ForkCrown)  2]  
						  			
									set polygon_content {}
                                    set counter 0						  
						            foreach point $OUT_Line(fork) {
						                set polygon_content [concat $polygon_content $point]
						                set counter [expr $counter+1]
						            }
						            
									$w create polygon  $polygon_content \
					     	               -width $lw  -tags [list $tag fork] -fill white -outline black
									
									
						            # fork-blade
								    set      OUT_Line(forkblade)  [list [lindex $COORD(ForkTop2)  1] ]
								    lappend  OUT_Line(forkblade)  [lindex $COORD(ForkTop2)  0]  
								    lappend  OUT_Line(forkblade)  [lindex $COORD(ForkBlade)  0]  
								    lappend  OUT_Line(forkblade)  [lindex $COORD(ForkBlade)  3]  
								    lappend  OUT_Line(forkblade)  [lindex $COORD(ForkDown) 2]  
								    lappend  OUT_Line(forkblade)  [lindex $COORD(ForkDown) 3] 
								    lappend  OUT_Line(forkblade)  [lindex $COORD(ForkBlade)  2]  
								    lappend  OUT_Line(forkblade)  [lindex $COORD(ForkBlade)  1]  
									
						  			set polygon_content {}
                                    set counter 0						  
						            foreach point $OUT_Line(forkblade) {
						                set polygon_content [concat $polygon_content $point]
						                set counter [expr $counter+1]
						            }
						            
									$w create polygon  $polygon_content \
					     	               -width $lw  -tags [list $tag fork] -fill white -outline black
										   
										   
						              # $w  itemconfigure fork -fill {#000000}           
								}
								
	                      composite {   
									set ang_fork    [expr 180.0-$control::CURRENT_Config(HeadTube_Angle) ]
								    set p_t_fork    [mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_ForkBase) \
																					   40 \
																					   [expr 180+$ang_fork] ]                                                    
								    set COORD(ForkTop)  [tube_outline_direction  \
																		   $CURRENT_Project(CENTER_ForkBase) \
																		   $p_t_fork \
																		   $control::CURRENT_Config(ForkCrown_Diameter) ]

									set ang_fork_2  [mathematic::calc_vect_direction    $CURRENT_Project(CENTER_FrontWheel) \
																					    $CURRENT_Project(CENTER_ForkBase) ]
									set p_d_fork    [mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_FrontWheel) \
																					   15 \
																					   $ang_fork_2 ]                                                    
								    set COORD(ForkDown) [tube_outline_direction \
																		   $CURRENT_Project(CENTER_FrontWheel) \
																		   $p_d_fork \
																		   15 ]
																		   
								    set      OUT_Line(fork)  [list [lindex $COORD(ForkTop)  3] ]
								    lappend  OUT_Line(fork)  [lindex $COORD(ForkTop)  0]  
								    lappend  OUT_Line(fork)  [lindex $COORD(ForkTop)  1]  
								    lappend  OUT_Line(fork)  [lindex $COORD(ForkTop)  2]  
								    lappend  OUT_Line(fork)  [lindex $COORD(ForkDown) 3]  
								    lappend  OUT_Line(fork)  [lindex $COORD(ForkDown) 2] 
						  
						            set polygon_content {}
                                    set counter 0						  
						            foreach point $OUT_Line(fork) {
						                set polygon_content [concat $polygon_content $point]
						                set counter [expr $counter+1]
						            }
						            
						            $w create polygon  $polygon_content \
					     	               -width $lw  -tags [list $tag fork] -fill white -outline black
						              # $w  itemconfigure fork -fill {#000000}           
								}
								
	                      suspension { 
									  # -- gabelbrücke verstrebung --------------			 					
									$w create polygon   \
													475 3324 363 3016 189 2725 504 2728 \
											-tags [ list $tag fork basis ]         -fill white         -outline $colour   -width $lw  

											
									  # -- tauchrohr ----------------------------
									$w create polygon   \
													 44 -697 354 -697 354 -3217 44 -3217 \
											-tags [ list $tag fork tauchrohr ]     -fill white         -outline $colour   -width $lw				 


									   # -- fork_head ---------------------------				 
									$w create polygon   \
													-184    0  -184 -225  -131 -239  -38 -406    9 -579  17 -707 \
						                             381 -707   381 -335   244 -201  191 -76   177    0 \
											-tags [ list $tag fork fork_head ]   -fill white         -outline $colour   -width $lw 
									$w create line   \
						                            -127 -158  -21 -274  31 -314  241 -318  30 -355  31 -530 \
											-tags [ list $tag fork fork_head ]	 -fill $colour   -width $lw 
									   # -------------
									set ForkBase    { 0 0}

											
											
									  # -- gabelbrücke --------------------------				 					
								    $w create polygon   \
						                             12  270   12 2494  -23 2562  -28 2589  -29 2757  416 2757 \
						                            460 2864  472 3474  542 3456  661 3388  643 3184  609 3082 \
						                            572 3011  545 2954  531 2765  488 2618  445 2515  408 2420 \
						                            391 2321  389 2128  389 270 \
											-tags [ list $tag fork brücke ]  -fill white         -outline $colour   -width $lw  			 
									$w create line   \
						                             538 3012  539 3207  608 3336 \
											-tags [ list $tag fork brücke ]  -fill $colour    -width $lw 			 
								    $w create line   \
													 28  187    74 147    121 86   142  18  118 -66   93  -99 \
						                             53 -109    53 -12    49   9    43  27   27  46    6   52 \
						                            -11   51   -25  45   -40  34   -46  21  -51   6  -48 -111 \
						                            -94  -99  -130 -48  -145  63  -213 174 \
											-tags [ list $tag fork fork_dropout ]  -fill $colour    -width $lw 
									   # -------------
									set ForkDropout_1    { 389  270}  ;#-2069
									set ForkDropout_2    {  28  180}  ;#-2152
									set ForkDropout_3    {-213  174}  ;#-2165
									set ForkDropout_4    {  12  270}  ;#-2069
						            set ForkWheelCenter  {   0    0}  ;#-2339

									
									  # lib_canvas::draw_circle $w  $ForkDropout_2    100     [ list $tag dropout dropout2 ]      $colour $lw {}
									  # lib_canvas::draw_circle $w  $ForkDropout_3    100     [ list $tag dropout dropout3 ]      $colour $lw {}
									  # lib_canvas::draw_circle $w  $ForkWheelCenter  100     [ list $tag dropout wheelcenter ]   $colour $lw {}
									  # lib_canvas::draw_circle $w  $ForkBase         100     [ list $tag forkbase ]              $colour $lw {}
											
									set ForkRake         [list [expr 10*$control::CURRENT_Config(Fork_Rake)]     0]
									  # tk_messageBox -message "ForkRake: $ForkRake"
									set ForkHeight       [list 0  [expr 10*$control::CURRENT_Config(Fork_Heigth)] ]
									set ForkDropout_1    [mathematic::VSub  $ForkDropout_1  $ForkRake]
									set ForkDropout_4    [mathematic::VSub  $ForkDropout_4  $ForkRake]
									
									
									$w create line    [lindex $ForkDropout_1 0] [lindex $ForkDropout_1 1] \
													  [lindex $ForkDropout_2 0] [lindex $ForkDropout_2 1] \
											-tags [ list $tag fork fork_dropout ]  -fill $colour    -width $lw 
									$w create line    [lindex $ForkDropout_3 0] [lindex $ForkDropout_3 1] \
													  [lindex $ForkDropout_4 0] [lindex $ForkDropout_4 1] \
											-tags [ list $tag fork fork_dropout ]  -fill $colour    -width $lw 
									
									$w move  fork_dropout     [lindex $ForkRake   0]   [lindex $ForkRake   1] 			
									$w move  fork_head        [lindex $ForkHeight 0]   [lindex $ForkHeight 1] 
									$w move  tauchrohr        [lindex $ForkHeight 0]   [lindex $ForkHeight 1] 									
									$w move  fork      [expr -[lindex $ForkRake   0]]  [lindex $ForkRake   1]
									
									$w scale fork      [lindex $ForkWheelCenter    0]   [lindex $ForkWheelCenter 1]    0.1 0.1
									
									set mv_vector [mathematic::VSub  $CURRENT_Project(CENTER_FrontWheel)  $ForkWheelCenter]
									$w move  fork             [lindex $mv_vector  0]   [lindex $mv_vector  1] 
									
									lib_canvas::rotate_item  $w  \
									                          [lindex $CURRENT_Project(CENTER_FrontWheel) 0] \
															  [lindex $CURRENT_Project(CENTER_FrontWheel) 1] \
															  [expr 90 - $control::CURRENT_Config(HeadTube_Angle) ]\
															  fork
						        }
						  
						  default  {   }
	             }
       }       
   }

   
   #-------------------------------------------------------------------------
       #  draw chainwheel
       #
   proc draw_chainwheel { w data tag lw colour } {
            
          variable CURRENT_Project
          variable CURRENT_Replace
        
        ::Debug  p  1
        
        array set PRJ_DATA  [array get $data]
        set xy   $PRJ_DATA(CENTER_BottomBracket)             

        set chainring_small {24 -4 24 -5 25 -7 27 -9 29 -9 30 -10 30 -11 30 -11 29 -12 27 -12 25 -13 23 -14 22 -16 22
                 -17 23 -20 25 -21 26 -22 27 -23 27 -23 27 -24 26 -24 24 -24 22 -25 19 -26 19 -27 18 -29 19 -31
                 20 -33 22 -34 22 -35 22 -36 22 -36 21 -36 19 -36 17 -36 14 -37 13 -38 13 -39 13 -42 14 -44 16
                 -45 16 -46 16 -47 15 -47 14 -47 12 -47 10 -46 8 -47 7 -48 6 -49 6 -51 6 -54 8 -55 8 -56 7 -57 7
                 -57 6 -57 4 -56 2 -55 0 -55 -2 -56 -3 -57 -3 -60 -3 -62 -2 -64 -2 -65 -2 -65 -3 -66 -4 -65 -5
                 -64 -7 -63 -10 -63 -11 -63 -12 -64 -13 -67 -13 -69 -13 -71 -13 -72 -13 -72 -14 -72 -15 -72 -16
                 -70 -18 -69 -20 -68 -22 -69 -23 -70 -24 -72 -25 -74 -25 -76 -25 -77 -25 -77 -26 -77 -27 -77 -28
                 -75 -29 -73 -32 -72 -33 -72 -34 -73 -36 -75 -37 -77 -37 -79 -37 -80 -38 -80 -39 -80 -39 -79 -40
                 -78 -41 -76 -43 -74 -45 -74 -46 -75 -48 -76 -49 -78 -50 -80 -50 -81 -51 -81 -51 -81 -52 -80 -53
                 -78 -53 -76 -55 -74 -57 -74 -58 -74 -60 -75 -62 -77 -62 -79 -63 -80 -64 -80 -64 -80 -65 -79 -65
                 -77 -66 -75 -67 -73 -68 -72 -70 -72 -72 -73 -74 -74 -75 -76 -76 -77 -76 -77 -77 -76 -77 -75 -77
                 -73 -77 -71 -78 -69 -80 -68 -81 -68 -84 -68 -85 -70 -87 -71 -88 -72 -88 -71 -89 -71 -89 -70 -88
                 -68 -88 -66 -89 -63 -90 -62 -91 -62 -94 -62 -96 -63 -97 -64 -99 -65 -99 -64 -99 -64 -99 -63 -99
                 -61 -98 -59 -99 -56 -99 -55 -101 -54 -103 -54 -105 -55 -107 -56 -108 -56 -109 -55 -109 -55 -109
                 -54 -108 -52 -107 -50 -107 -48 -108 -46 -109 -45 -111 -45 -113 -45 -115 -46 -116 -46 -117 -45
                 -117 -45 -117 -44 -115 -42 -114 -40 -114 -38 -114 -36 -115 -35 -117 -34 -120 -34 -122 -35 -123
                 -34 -123 -34 -123 -33 -123 -32 -121 -31 -120 -29 -119 -27 -119 -26 -120 -24 -122 -23 -124 -23
                 -126 -23 -127 -22 -127 -22 -128 -21 -127 -20 -125 -19 -123 -18 -122 -16 -122 -14 -123 -13 -125
                 -11 -127 -10 -129 -10 -130 -9 -130 -9 -130 -8 -129 -8 -127 -7 -125 -6 -124 -4 -124 -2 -124 -1
                 -126 1 -127 2 -129 3 -130 4 -130 4 -130 5 -129 5 -127 6 -125 7 -124 8 -123 10 -123 11 -124 13
                 -126 15 -128 16 -129 17 -129 17 -128 18 -127 18 -125 18 -123 19 -121 20 -121 21 -120 23 -121 25
                 -123 27 -124 28 -125 29 -125 30 -125 30 -124 30 -122 30 -119 30 -117 31 -116 33 -116 34 -116 37
                 -118 38 -119 40 -119 41 -119 41 -119 42 -118 42 -116 41 -114 41 -111 42 -110 43 -110 44 -110 47
                 -111 49 -112 50 -112 52 -112 52 -111 52 -110 52 -108 51 -106 51 -104 51 -103 52 -102 53 -101 56
                 -102 58 -103 60 -103 61 -103 61 -102 62 -101 61 -99 60 -97 59 -95 59 -94 60 -93 61 -92 63 -92
                 66 -93 68 -93 69 -92 69 -92 69 -91 69 -89 67 -87 66 -85 66 -84 66 -82 67 -81 69 -81 72 -81 74
                 -81 75 -81 75 -80 75 -79 74 -78 73 -76 71 -74 71 -73 71 -71 71 -70 74 -69 76 -69 78 -69 79 -68
                 79 -68 79 -67 78 -66 76 -65 75 -63 74 -61 73 -60 74 -58 76 -57 78 -57 80 -56 81 -56 81 -55 81
                 -54 80 -54 78 -53 76 -51 75 -49 74 -48 75 -46 76 -45 78 -44 80 -43 81 -43 81 -42 81 -42 80 -41
                 78 -41 76 -39 74 -37 73 -36 73 -34 74 -32 76 -31 78 -30 79 -30 78 -29 78 -29 77 -29 75 -29 73
                 -27 71 -26 70 -24 70 -22 71 -20 72 -19 74 -18 74 -18 74 -17 74 -17 73 -17 71 -17 69 -16 66 -15
                 65 -14 65 -11 65 -9 66 -8 68 -7 68 -6 68 -6 68 -6 67 -6 65 -7 62 -6 60 -5 59 -4 58 -1 58 1 59 2
                 60 4 60 4 60 4 60 4 59 3 57 3 55 3 52 4 51 5 50 7 50 9 50 11 51 12 51 13 51 13 50 13 49 12 47
                 11 45 11 43 11 41 12 40 15 40 17 40 19 40 20 40 20 40 20 39 20 38 18 37 17 35 17 33 17 31 18 30
                 20 29 22 29 24 29 25 28 25 28 26 27 25 26 23 25 22 24 21 21 21 20 22 19 24 17 26 16 28 16 29 16
                 29 15 29 15 28 14 26 13 25 12 23 10 23 8 13 0 12 17 12 20 10 26 6 33 -1 44 -8 50 -13 54 -17 56
                 -22 57 -25 55 -38 59 -40 63 -44 65 -49 66 -56 65 -64 64 -77 60 -84 56 -89 52 -93 49 -95 45 -95
                 41 -102 30 -106 29 -109 26 -112 21 -113 15 -115 7 -115 -7 -113 -15 -112 -21 -109 -26 -106 -29
                 -102 -30 -94 -41 -95 -45 -93 -49 -89 -53 -84 -56 -76 -60 -64 -65 -55 -65 -49 -66 -44 -65 -40
                 -63 -38 -59 -25 -55 -22 -57 -17 -56 -12 -53 -7 -50 -1 -44 7 -33 10 -25 12 -19 13 -17 13 0 24 -4 
               }
     
     set chainring_big { -47 103 -46 103 -45 104 -44 106 -43 107 -41 110 -40 110 -39 107 -39 105 -38 103 -36 102 -35
                 102 -34 102 -33 102 -31 104 -30 106 -28 108 -27 108 -27 105 -26 103 -26 101 -24 100 -24 99 -23
                 99 -21 100 -19 101 -18 103 -16 105 -15 105 -14 101 -14 99 -14 97 -13 96 -12 95 -11 95 -9 95 -8
                 97 -6 98 -4 100 -3 100 -3 96 -3 94 -3 92 -2 91 -1 90 0 90 1 90 3 91 5 92 8 94 9 94 8 90 8 88 8
                 86 8 84 9 84 10 83 12 83 14 84 15 85 18 86 19 86 18 82 18 81 17 78 18 77 18 76 19 76 21 75 23
                 76 25 77 28 78 29 77 28 74 27 72 26 70 26 68 27 67 28 67 29 66 31 66 33 67 37 68 37 67 36 64 35
                 62 34 60 34 59 34 58 35 57 36 56 39 56 41 57 44 57 45 56 43 53 41 52 40 50 40 48 40 47 41 46 42
                 46 45 45 47 45 50 45 50 45 48 42 47 41 45 39 45 37 45 36 46 35 47 34 49 34 51 34 55 33 55 32 52
                 30 51 29 49 27 49 26 49 25 49 24 51 22 53 22 54 21 58 20 58 19 55 17 54 17 52 15 51 14 51 13 51
                 12 52 10 29 0 28 17 30 19 33 25 32 31 31 37 28 43 22 53 14 62 9 66 4 69 -1 72 -8 71 -14 69 -17
                 66 -25 55 -38 59 -38 73 -39 77 -43 83 -48 87 -54 88 -60 89 -66 88 -78 85 -88 81 -94 77 -99 73
                 -103 69 -104 62 -104 56 -103 52 -95 41 -102 30 -115 34 -120 34 -126 33 -132 29 -134 24 -137 18
                 -138 12 -139 0 -138 -12 -137 -19 -134 -24 -132 -29 -126 -33 -120 -34 -115 -34 -102 -30 -94 -41
                 -102 -52 -104 -56 -104 -62 -103 -69 -99 -74 -94 -77 -88 -81 -77 -85 -66 -88 -59 -89 -53 -88 -48
                 -87 -43 -83 -39 -77 -38 -73 -38 -59 -25 -55 -17 -66 -14 -69 -8 -71 -1 -72 4 -69 9 -66 14 -62 22
                 -53 28 -43 31 -36 32 -31 33 -25 30 -18 29 -16 29 0 52 -11 51 -12 51 -13 52 -14 54 -16 55 -17 58
                 -19 58 -20 55 -21 53 -21 51 -22 50 -23 49 -24 49 -25 50 -26 51 -28 53 -29 55 -31 55 -32 52 -33
                 50 -33 47 -34 46 -35 46 -35 45 -36 46 -38 47 -40 48 -41 51 -44 50 -45 47 -45 45 -45 43 -45 41
                 -46 41 -47 41 -48 41 -49 42 -51 43 -53 45 -56 45 -56 41 -56 39 -56 37 -56 35 -56 35 -57 34 -58
                 34 -60 35 -62 36 -63 38 -66 37 -67 34 -66 32 -66 30 -66 28 -66 27 -67 27 -68 27 -69 27 -71 28
                 -73 29 -76 29 -77 25 -76 24 -75 22 -75 20 -75 19 -76 18 -76 18 -78 18 -80 19 -82 20 -85 19 -86
                 16 -84 14 -83 12 -83 11 -83 10 -83 9 -84 8 -86 8 -88 9 -90 9 -93 9 -94 6 -92 4 -91 2 -90 1 -89
                 0 -90 -1 -90 -2 -92 -2 -94 -2 -96 -2 -100 -3 -100 -6 -98 -7 -96 -9 -95 -10 -95 -11 -95 -12 -96
                 -13 -97 -14 -99 -14 -101 -14 -105 -15 -105 -17 -102 -18 -101 -20 -99 -22 -99 -23 -99 -24 -99
                 -25 -101 -26 -103 -26 -105 -27 -108 -27 -108 -30 -106 -30 -104 -32 -102 -34 -102 -35 -102 -36
                 -102 -37 -103 -38 -105 -38 -107 -39 -110 -40 -110 -42 -107 -43 -105 -44 -104 -46 -103 -47 -103
                 -48 -103 -49 -104 -50 -106 -51 -107 -52 -111 -53 -111 -55 -107 -55 -106 -56 -104 -58 -103 -59
                 -102 -60 -102 -61 -103 -63 -105 -63 -107 -65 -110 -66 -109 -67 -106 -68 -104 -68 -102 -70 -101
                 -71 -101 -72 -101 -73 -101 -75 -103 -76 -104 -78 -107 -79 -107 -80 -103 -80 -101 -80 -99 -81
                 -98 -82 -97 -83 -97 -85 -98 -87 -99 -88 -100 -90 -103 -91 -103 -91 -99 -91 -97 -92 -95 -93 -94
                 -93 -93 -94 -93 -96 -93 -98 -94 -99 -95 -102 -97 -103 -97 -103 -93 -102 -92 -103 -89 -103 -88
                 -104 -87 -105 -87 -107 -87 -109 -88 -110 -89 -113 -90 -114 -90 -113 -86 -113 -85 -113 -82 -113
                 -81 -114 -80 -115 -80 -116 -79 -119 -80 -120 -81 -123 -82 -124 -82 -123 -78 -122 -77 -122 -74
                 -122 -73 -123 -72 -124 -71 -125 -71 -127 -71 -129 -72 -133 -73 -133 -72 -132 -69 -131 -67 -130
                 -65 -130 -64 -131 -63 -132 -62 -133 -61 -135 -61 -137 -62 -141 -63 -141 -62 -139 -59 -138 -57
                 -137 -55 -137 -54 -138 -53 -138 -52 -140 -51 -142 -51 -144 -51 -147 -51 -148 -50 -145 -48 -144
                 -46 -143 -44 -143 -43 -143 -42 -144 -41 -145 -40 -147 -40 -149 -40 -153 -39 -153 -38 -150 -36
                 -149 -35 -148 -33 -147 -31 -147 -30 -148 -29 -149 -28 -151 -28 -153 -28 -157 -27 -157 -26 -154
                 -24 -152 -23 -151 -21 -150 -20 -150 -19 -151 -18 -152 -16 -154 -15 -156 -15 -159 -14 -159 -13
                 -156 -11 -154 -10 -153 -9 -152 -8 -152 -6 -152 -5 -153 -4 -155 -3 -157 -2 -160 -1 -160 0 -157 2
                 -155 2 -153 3 -152 5 -152 6    
                 -152 7 -153 8 -154 10 -156 10 -159 12 -159 13 -156 14 -154 15 -152 16 -151 17 -150 18 -150 19 -151 20 -153 22 -154 23 -157 25 
                 -157 26 -153 27 -151 27 -149 28 -148 29 -148 30 -147 31 -148 32 -149 34 -151 35 -153 38 -153 39 -149 39 -148 39 -145 39 -144 40 
                 -143 41 -143 42 -143 44 -145 46 -146 47 -148 50 -148 51 -144 50 -142 50 -140 50 -139 51 -138 52 -138 53 -138 55 -139 57 -140 58 
                 -142 61 -141 62 -138 61 -136 61 -133 61 -132 61 -131 62 -131 63 -131 65 -131 67 -132 68 -134 72 -133 72 -130 71 -128 71 -126 70 
                 -124 71 -123 71 -123 72 -122 74 -123 76 -124 78 -125 81 -124 82 -121 80 -119 79 -117 79 -115 79 -115 80 -114 80 -113 82 -113 84 
                 -114 86 -115 89 -114 90 -111 88 -109 87 -107 86 -106 86 -105 87 -104 87 -103 89 -103 91 -104 93 -104 97 -103 97 -100 95 -99 94 
                 -97 92 -95 92 -94 93 -93 93 -92 95 -92  97 -92 99 -92 102 -91 103 -89 100 -87 99 -86 97 -84 97 -83 97 -82 98 -81 99 -80 101 
                 -80 103 -80 107 -79 107 -77 104 -76 103 -74 101 -72 100 -71 100 -70 101 -69 102 -68 104 -68 106 -67 109 -66 109 -64 107 -63 105 
                 -62 103 -60 102 -59 102 -58 103 -57 104 -56 106 -55 107 -54 111 -53 111 -52 107 -51 106 -50 104 -48 103 
               }
     
     set crank {-30 29 -29 38 -25 55 -31 58 -38 59 -45 43 -53 30 -56 27 -59 26 -61 26 -66 26 -79 32 -95
                 41 -99 36 -102 30 -89 18 -79 7 -78 3 -77 0 -78 -3 -79 -7 -89 -18 -102 -30 -99 -36 -94 -41 -79
                 -32 -65 -26 -61 -26 -58 -26 -56 -27 -52 -30 -45 -43 -38 -59 -31 -58 -25 -55 -29 -37 -30 -30 -29
                 -28 -28 -26 -24 -22 -18 -20 -12 -19 7 -17 47 -16 79 -15 100 -16 120 -16 123 -16 128 -16 132 -14
                 136 -10 139 -6 140 1 139 7 136 11 132 15 127 17 123 17 119 17 100 16 79 16 47 16 7 17 -12 19
                 -18 20 -24 22 -28 26 -29 28 -30 29
               }
     $w create polygon $chainring_small \
                   -tag [ list $tag chainwheel ]  -outline $colour  -width $lw  -fill white
            
     $w create polygon $chainring_big \
                   -tag [ list $tag chainwheel ]  -outline $colour  -width $lw  -fill white
     $w create polygon $crank \
                  -tag [ list $tag chainwheel ]  -outline $colour  -width $lw  -fill white
     
     lib_canvas::draw_circle $w {-50 0}  7     [ list $tag chainwheel ]  $colour $lw {}
     lib_canvas::draw_circle $w {-50 0}  12    [ list $tag chainwheel ]  $colour $lw {}
     
     lib_canvas::draw_circle $w {125 0}  5     [ list $tag chainwheel ]  $colour $lw {}
     
     set move_xy [mathematic::VSub  $xy  {-50 0}]
     
     $w move chainwheel [lindex $move_xy 0] [lindex $move_xy 1]
          
   }
   
   
   #-------------------------------------------------------------------------
       #  draw frame centerline
       #
   proc draw_frame { w data tag lw colour type {fill_colour white}} {
                   
        ::Debug  p  1
        
        switch $type {
            outline { compute_frame_outlines
                      draw_frame_outlines   $w  $data  $tag  $lw  $colour  $fill_colour} 
            default { draw_frame_centerline $w  $data  $tag  $lw  $colour }
        }
    }              

   
   #-------------------------------------------------------------------------
       #  draw frame centerline
       #
   proc draw_frame_centerline { w data tag lw colour } {
            
          variable CURRENT_Project
          variable CURRENT_Replace
        
        ::Debug  p  1
        
        array set PRJ_DATA  [array get $data]
        
        
          # -- center bottombracket
        set bb_c     $PRJ_DATA(CENTER_BottomBracket)  
        $w create oval  [ expr [ lindex $bb_c  0 ] - 17 ]   [ expr [ lindex $bb_c  1 ] - 17 ] \
                        [ expr [ lindex $bb_c  0 ] + 17 ]   [ expr [ lindex $bb_c  1 ] + 17 ] \
               -tags [ list $tag bottombracket ]  -outline  white 
          
          # -- axis   bottombracket
        $w create line  [ expr [ lindex $bb_c  0 ] - 100 ]  [ lindex $bb_c  1 ]  \
                        [ expr [ lindex $bb_c  0 ] + 100 ]  [ lindex $bb_c  1 ]  \
               -tags [ list $tag axis_bottom_bracket ] -fill gray 

        $w create line  [ lindex $bb_c  0 ]  [ expr [ lindex $bb_c  1 ] - 100 ] \
                        [ lindex $bb_c  0 ]  [ expr [ lindex $bb_c  1 ] + 100 ] \
               -tags [ list $tag axis_bottom_bracket ]  -fill gray  

          # -- chainstay
        set rw_c    $PRJ_DATA(CENTER_RearWheel) 
        $w create line  [ lindex $bb_c  0]   [ lindex $bb_c  1] \
                        [ lindex $rw_c  0]   [ lindex $rw_c  1] \
               -tags [ list $tag chainstay ]      -fill $colour  -width $lw
          
          # -- seattube - saddle
        set st_c    $PRJ_DATA(CENTER_Seat_Top)   
        $w create line  [ lindex $bb_c  0]   [ lindex $bb_c  1] \
                        [ lindex $st_c  0]   [ lindex $st_c  1] \
               -tags [ list $tag seattube_post ]  -fill $colour  -width $lw
          
          # -- seatstay
        set sst_c   $PRJ_DATA(CENTER_SeatStay_Top)   
        $w create line  [ lindex $rw_c   0]  [ lindex $rw_c   1] \
                        [ lindex $sst_c  0]  [ lindex $sst_c  1] \
               -tags [ list $tag seatstay ]       -fill $colour  -width $lw

          # -- toptube
        set tts_c   $PRJ_DATA(CENTER_TopTube_Seat)   
        set tth_c   $PRJ_DATA(CENTER_TopTube_Head)   
        $w create line  [ lindex $tts_c  0]  [ lindex $tts_c  1] \
                        [ lindex $tth_c  0]  [ lindex $tth_c  1] \
               -tags [ list $tag toptube ]        -fill $colour  -width $lw

          # -- downtube
        set hdt_c   $PRJ_DATA(CENTER_DownTube_Head)  
        $w create line  [ lindex $bb_c   0]  [ lindex $bb_c   1] \
                        [ lindex $hdt_c  0]  [ lindex $hdt_c  1] \
               -tags [ list $tag downtube ]       -fill $colour  -width $lw
          
          # -- stem
        set st_c    $PRJ_DATA(CENTER_Stem)       
        set hb_c    $PRJ_DATA(CENTER_HandleBar)  
        $w create line  [ lindex $st_c   0]  [ lindex $st_c    1] \
                        [ lindex $hb_c   0]  [ lindex $hb_c 1] \
               -tags [ list $tag stem ]           -fill $colour  -width $lw
          
          # -- headtube steerer
        set htb_c    $PRJ_DATA(CENTER_HeadTube_Bottom) 
        $w create line  [ lindex $htb_c  0]  [ lindex $htb_c  1] \
                        [ lindex $st_c   0]  [ lindex $st_c        1] \
               -tags [ list $tag steerer ]        -fill $colour  -width $lw                               
        
    }              

   
   #-------------------------------------------------------------------------
       #  draw frame outlines
       #
   proc draw_frame_outlines { w data tag lw colour {fill_colour white} } {        
            
          variable CURRENT_Project
          variable CURRENT_Replace
          variable BottomBrckt_Diameter
          variable OUT_Line
       
        ::Debug  p  1
        
        array set PRJ_DATA  [array get $data]
        
          # array set PRJ_DATA  [array get $data]
        
        ::Debug  p  1
        ::Debug  l  OUT_Line(frame)
        
        set BottomBrckt_Radius     [expr 0.5*  $BottomBrckt_Diameter]                                                                   
            
        set      tag          frame_outlines 
               # edge_width   [dimension::compute_size edge]
        catch [lib_canvas::delete_item      $w  $tag  ]
        
          
          # foreach polygon {frame dropout fork } 
        foreach polygon {frame dropout} {
            set polygon_content {}
            set counter 0
            foreach point $OUT_Line($polygon) {
                set polygon_content [concat $polygon_content $point]
                    # tk_messageBox -message " $counter  $point"
                    # $w create text [concat $point] -text $counter -font {helvetica 9} -tag primar
                  set counter [expr $counter+1]
              }
             
             Debug t "   --> polygon  $polygon"
               # tk_messageBox -message "   --> $polygon  $OUT_Line($polygon)"
               # tk_messageBox -message "   --> $polygon  $polygon_content"
             
            $w create polygon  $polygon_content \
     	               -width $lw  -tags [list $tag $polygon] -fill white -outline black
                       
            if {[string compare $fill_colour {white}]} {
                  # tk_messageBox -message "  $fill_colour"
                switch $polygon {
                    frame      { $w  itemconfigure $polygon -fill $fill_colour}
                    dropout    { $w  itemconfigure $polygon -fill $fill_colour}
                    fork       { $w  itemconfigure $polygon -fill {#000000}}
                }
            }
        }
        
        lib_canvas::draw_circle  $w  $CURRENT_Project(CENTER_FrontWheel)      5  $tag  black  $lw {}
        lib_canvas::draw_circle  $w  $CURRENT_Project(CENTER_RearWheel)       5  $tag  black  $lw {}
         
        lib_canvas::draw_circle  $w  $CURRENT_Project(CENTER_BottomBracket)   $BottomBrckt_Radius  \
                                                                                 $tag  black  $lw  white
                                                                         
               # tk_messageBox -message " $CURRENT_Project(CENTER_FrontWheel)  $CURRENT_Project(CENTER_RearWheel)  $CURRENT_Project(CENTER_RearShifter)"  
        lib_canvas::draw_circle  $w  $CURRENT_Project(CENTER_RearShifter)     4  $tag  black  $lw {}

        $w raise primar all
   }
           

   #-------------------------------------------------------------------------
       #  draw rest
       #
   proc draw_seatpost { w data tag lw colour } {
                       
        set seatpost(0) [list  [lindex  $geometry::OUT_Line(SeatPost_1) 0] [expr [lindex  $geometry::OUT_Line(SeatPost_1) 1] -20 ] ]
          # lib_canvas::draw_circle  $w  $seatpost(0)   10     $tag  $colour $lw {}
          # lib_canvas::draw_circle  $w  $geometry::OUT_Line(SeatPost_1)   10     $tag  $colour $lw {}
        
        set seatpost(2)  [ mathematic::VAdd    $seatpost(0)       [ mathematic::rotate_point  {0 0}  {100 0}  [ expr  90-$control::CURRENT_Config(SeatTube_Angle)] ] ]
          # lib_canvas::draw_circle  $w  $seatpost(1)   10     $tag  $colour $lw {}
        
        set seatpost(4)  [ mathematic::Intersect  $seatpost(0)    $seatpost(2) \
                                                  $geometry::CURRENT_Project(CENTER_BottomBracket)   $geometry::CURRENT_Project(CENTER_Seat_Top) ] 
          # lib_canvas::draw_circle  $w  $seatpost(2)   10     $tag  $colour $lw {}
          # lib_canvas::draw_circle  $w  $geometry::CURRENT_Project(CENTER_SeatTube_Top)   10     $tag  $colour $lw {}
        
        set seatpost(coord) [geometry::tube_outline_direction \
                                                   $geometry::CURRENT_Project(CENTER_SeatTube_Top) \
                                                   $seatpost(4) \
                                                   27.2 ]  
          # lib_canvas::draw_circle  $w  [lindex $seatpost(coord) 3]   10     $tag  $colour $lw {}
        set seatpost(5)  [ mathematic::VAdd  [lindex $seatpost(coord) 3]   [ mathematic::rotate_point  {0 0}  {5 0}  [ expr  180-$control::CURRENT_Config(SeatTube_Angle)] ] ]
          # lib_canvas::draw_circle  $w  $seatpost(5)   10     $tag  $colour $lw {}

                                                   
        $w  create  polygon \
                          [lindex [lindex $seatpost(coord) 0] 0]  [lindex [lindex $seatpost(coord) 0] 1] \
                          [lindex [lindex $seatpost(coord) 1] 0]  [lindex [lindex $seatpost(coord) 1] 1] \
                          [lindex [lindex $seatpost(coord) 2] 0]  [lindex [lindex $seatpost(coord) 2] 1] \
                          [lindex [lindex $seatpost(coord) 3] 0]  [lindex [lindex $seatpost(coord) 3] 1] \
                   -tag $tag  -outline $colour  -width $lw  -fill white
        $w  create  polygon \
                          [lindex $geometry::OUT_Line(SeatPost_2)       0]  [lindex $geometry::OUT_Line(SeatPost_2)       1] \
                          [lindex $geometry::OUT_Line(SeatPost_1)       0]  [lindex $geometry::OUT_Line(SeatPost_1)       1] \
                          [lindex $seatpost(5)                0]  [lindex $seatpost(5)                1] \
                          [lindex [lindex $seatpost(coord) 3] 0]  [lindex [lindex $seatpost(coord) 3] 1] \
                          [lindex [lindex $seatpost(coord) 2] 0]  [lindex [lindex $seatpost(coord) 2] 1] \
                   -tag $tag  -outline $colour  -width $lw  -fill white  
   }


   #-------------------------------------------------------------------------
       #  draw headset and stem
       #
   proc draw_headset_stem { w data tag lw colour } {
            
        set headset_diam       45.0
        set headset_height_tp  18.0
        set stem_diam          32.0
        set stem_height_clamp  32.0
        set shim_diam          35.0
        set shim_top_ht         5.0

        # -- headset ----------------------------
        if { $control::CURRENT_Config(HeadsetBottom_Heigth) > 1 } {
            
              # -- headset - bottom
            set headset_bt_ct       [mathematic::VAdd  $geometry::CURRENT_Project(CENTER_ForkBase)  [mathematic::VSub  $geometry::CURRENT_Project(CENTER_HeadTube_Bottom)  $geometry::CURRENT_Project(CENTER_ForkBase)] 0.5]
            set headset_bt_0(coord) [geometry::tube_outline_direction \
                                                       $headset_bt_ct \
                                                       $geometry::CURRENT_Project(CENTER_HeadTube_Bottom) \
                                                       $control::CURRENT_Config(HeadTube_Diameter) ]  
            set headset_bt_1(coord) [geometry::tube_outline_direction \
                                                       $geometry::CURRENT_Project(CENTER_ForkBase) \
                                                       $headset_bt_ct \
                                                       $headset_diam ]

                                                       
            $w  create  polygon \
                              [lindex [lindex $headset_bt_1(coord) 3] 0]  [lindex [lindex $headset_bt_1(coord) 3] 1] \
                              [lindex [lindex $headset_bt_1(coord) 2] 0]  [lindex [lindex $headset_bt_1(coord) 2] 1] \
                              [lindex [lindex $headset_bt_0(coord) 2] 0]  [lindex [lindex $headset_bt_0(coord) 2] 1] \
                              [lindex [lindex $headset_bt_0(coord) 3] 0]  [lindex [lindex $headset_bt_0(coord) 3] 1] \
                       -tag $tag  -outline $colour  -width $lw  -fill white   
            $w  create  polygon \
                              [lindex [lindex $headset_bt_1(coord) 0] 0]  [lindex [lindex $headset_bt_1(coord) 0] 1] \
                              [lindex [lindex $headset_bt_1(coord) 1] 0]  [lindex [lindex $headset_bt_1(coord) 1] 1] \
                              [lindex [lindex $headset_bt_1(coord) 2] 0]  [lindex [lindex $headset_bt_1(coord) 2] 1] \
                              [lindex [lindex $headset_bt_1(coord) 3] 0]  [lindex [lindex $headset_bt_1(coord) 3] 1] \
                       -tag $tag  -outline $colour  -width $lw  -fill white   
                       
              # -- headset - top
            set headset_tp_ct       [mathematic::VAdd  $geometry::CURRENT_Project(CENTER_HeadTube_Top)  \
                                            [mathematic::rotate_point  {0 0}  {8 0}   [ expr 180-$control::CURRENT_Config(HeadTube_Angle)] ] ]
            set geometry::CURRENT_Project(CENTER_Headset_Top) \
                                    [mathematic::VAdd  $geometry::CURRENT_Project(CENTER_HeadTube_Top)  \
                                            [mathematic::rotate_point  {0 0}  [list $headset_height_tp  0] \
                                                                                      [ expr 180-$control::CURRENT_Config(HeadTube_Angle)] ] ]
            set headset_tp_0(coord) [geometry::tube_outline_direction \
                                                       $geometry::CURRENT_Project(CENTER_HeadTube_Top) \
                                                       $headset_tp_ct \
                                                       $headset_diam ]  
            set headset_tp_1(coord) [geometry::tube_outline_direction \
                                                       $headset_tp_ct \
                                                       $geometry::CURRENT_Project(CENTER_Headset_Top) \
                                                       $shim_diam ]  
            $w  create  polygon \
                              [lindex [lindex $headset_tp_0(coord) 3] 0]  [lindex [lindex $headset_tp_0(coord) 3] 1] \
                              [lindex [lindex $headset_tp_0(coord) 2] 0]  [lindex [lindex $headset_tp_0(coord) 2] 1] \
                              [lindex [lindex $headset_tp_1(coord) 2] 0]  [lindex [lindex $headset_tp_1(coord) 2] 1] \
                              [lindex [lindex $headset_tp_1(coord) 3] 0]  [lindex [lindex $headset_tp_1(coord) 3] 1] \
                       -tag $tag  -outline $colour  -width $lw  -fill white 
            $w  create  polygon \
                              [lindex [lindex $headset_tp_0(coord) 0] 0]  [lindex [lindex $headset_tp_0(coord) 0] 1] \
                              [lindex [lindex $headset_tp_0(coord) 1] 0]  [lindex [lindex $headset_tp_0(coord) 1] 1] \
                              [lindex [lindex $headset_tp_0(coord) 2] 0]  [lindex [lindex $headset_tp_0(coord) 2] 1] \
                              [lindex [lindex $headset_tp_0(coord) 3] 0]  [lindex [lindex $headset_tp_0(coord) 3] 1] \
                       -tag $tag  -outline $colour  -width $lw  -fill white   
                      

        } else {
              # -- headset - top
            set headset_tp_ct       [mathematic::VAdd  $geometry::CURRENT_Project(CENTER_HeadTube_Top)  \
                                            [mathematic::rotate_point  {0 0}  { 2 0}   [ expr 180-$control::CURRENT_Config(HeadTube_Angle)] ] ]
            set geometry::CURRENT_Project(CENTER_Headset_Top) \
                                            [mathematic::VAdd  $headset_tp_ct  \
                                            [mathematic::rotate_point  {0 0}  [list $headset_height_tp 0] \
                                                                                       [ expr 180-$control::CURRENT_Config(HeadTube_Angle)] ] ]
            set headset_tp_0(coord) [geometry::tube_outline_direction \
                                                       $geometry::CURRENT_Project(CENTER_HeadTube_Top) \
                                                       $headset_tp_ct \
                                                       $control::CURRENT_Config(HeadTube_Diameter) ]  
            set headset_tp_1(coord) [geometry::tube_outline_direction \
                                                       $headset_tp_ct \
                                                       $geometry::CURRENT_Project(CENTER_Headset_Top) \
                                                       $shim_diam ]  
            $w  create  polygon \
                              [lindex [lindex $headset_tp_0(coord) 3] 0]  [lindex [lindex $headset_tp_0(coord) 3] 1] \
                              [lindex [lindex $headset_tp_0(coord) 2] 0]  [lindex [lindex $headset_tp_0(coord) 2] 1] \
                              [lindex [lindex $headset_tp_1(coord) 2] 0]  [lindex [lindex $headset_tp_1(coord) 2] 1] \
                              [lindex [lindex $headset_tp_1(coord) 3] 0]  [lindex [lindex $headset_tp_1(coord) 3] 1] \
                       -tag $tag  -outline $colour  -width $lw  -fill white   
            $w  create  polygon \
                              [lindex [lindex $headset_tp_0(coord) 0] 0]  [lindex [lindex $headset_tp_0(coord) 0] 1] \
                              [lindex [lindex $headset_tp_0(coord) 1] 0]  [lindex [lindex $headset_tp_0(coord) 1] 1] \
                              [lindex [lindex $headset_tp_0(coord) 2] 0]  [lindex [lindex $headset_tp_0(coord) 2] 1] \
                              [lindex [lindex $headset_tp_0(coord) 3] 0]  [lindex [lindex $headset_tp_0(coord) 3] 1] \
                       -tag $tag  -outline $colour  -width $lw  -fill white            
        }
        
        
          # -- stem ----------------------------
        set stem(coord)        [geometry::tube_outline_direction \
                                                   $geometry::CURRENT_Project(CENTER_HandleBar) \
                                                   $geometry::CURRENT_Project(CENTER_Stem) \
                                                   $stem_diam ]  
                                                   
          # lib_canvas::draw_circle  $w  $geometry::CURRENT_Project(CENTER_Stem)              10     $tag  green $lw {}                                          
          # return     
          
        set stem_shim(coord)   [geometry::tube_outline_direction \
                                                   $geometry::CURRENT_Project(CENTER_Headset_Top) \
                                                   $geometry::CURRENT_Project(CENTER_Stem) \
                                                   $shim_diam ] 
        set stem_shim(chamfer) [geometry::tube_outline_direction \
                                                   $geometry::CURRENT_Project(CENTER_Headset_Top) \
                                                   $geometry::CURRENT_Project(CENTER_Stem) \
                                                   [expr 7 + $shim_diam]  ]                                           
        set stem(1)  [mathematic::Intersect [lindex $stem(coord)        1] [lindex $stem(coord)        2] \
                                            [lindex $stem_shim(coord)   1] [lindex $stem_shim(coord)   2] ]   
        set stem(2)  [mathematic::calc_point_length_arc  $stem(1)       4  [ expr 180.0-$control::CURRENT_Config(HeadTube_Angle)] ]   
            set hlp  [mathematic::calc_point_length_arc  $stem(2)     100  [ expr 270.0-$control::CURRENT_Config(HeadTube_Angle)] ]
        set stem(3)  [mathematic::Intersect  $stem(2)   $hlp \
                                            [lindex $stem_shim(coord)   0] [lindex $stem_shim(coord)   3] ]
        set stem(6)  [mathematic::Intersect [lindex $stem(coord)        0] [lindex $stem(coord)        3] \
                                            [lindex $stem_shim(coord)   1] [lindex $stem_shim(coord)   2] ]  
        set stem(5)  [mathematic::calc_point_length_arc  $stem(6)       4  [expr -$control::CURRENT_Config(HeadTube_Angle)] ]   
            set hlp  [mathematic::calc_point_length_arc  $stem(5)     100  [expr 270-$control::CURRENT_Config(HeadTube_Angle)] ]
        set stem(4)  [mathematic::Intersect  $stem(5)   $hlp \
                                            [lindex $stem_shim(coord)   0] [lindex $stem_shim(coord)   3] ]
          # -- redefine for chamfer
        set stem(1)  [mathematic::Intersect [lindex $stem(coord)        1] [lindex $stem(coord)        2] \
                                            [lindex $stem_shim(chamfer) 1] [lindex $stem_shim(chamfer) 2] ]   
        set stem(6)  [mathematic::Intersect [lindex $stem(coord)        0] [lindex $stem(coord)        3] \
                                            [lindex $stem_shim(chamfer) 1] [lindex $stem_shim(chamfer) 2] ]   

          # -- clamp 
        set stem(clamp_1)        [geometry::tube_outline_direction \
                                                   $geometry::CURRENT_Project(CENTER_HandleBar) \
                                                   $geometry::CURRENT_Project(CENTER_Stem) \
                                                   [expr 8 + $stem_diam] ]
            set hlp   [mathematic::calc_point_length_arc  $geometry::CURRENT_Project(CENTER_HandleBar)     100  [ expr 180-$control::CURRENT_Config(HeadTube_Angle)+$control::CURRENT_Config(Stem_Angle)] ]    
        set stem(clamp_2)        [geometry::tube_outline_direction \
                                                   $geometry::CURRENT_Project(CENTER_HandleBar) \
                                                   $hlp \
                                                   20 ]
        set stem_clp(1)  [mathematic::Intersect \
                                            [lindex $stem(clamp_1)    1] [lindex $stem(clamp_1)    2] \
                                            [lindex $stem(clamp_2)    3] [lindex $stem(clamp_2)    0] ]  
        set stem_clp(2)  [mathematic::Intersect \
                                            [lindex $stem(clamp_1)    1] [lindex $stem(clamp_1)    2] \
                                            [lindex $stem(clamp_2)    1] [lindex $stem(clamp_2)    2] ]  
        set stem_clp(3)  [mathematic::calc_point_length_arc  $geometry::CURRENT_Project(CENTER_HandleBar)    [expr  45/2]  [ expr 90-$control::CURRENT_Config(HeadTube_Angle)+$control::CURRENT_Config(Stem_Angle)] ]    
        set stem_clp(4)  [mathematic::Intersect \
                                            [lindex $stem(clamp_1)    3] [lindex $stem(clamp_1)    0] \
                                            [lindex $stem(clamp_2)    1] [lindex $stem(clamp_2)    2] ]  
        set stem_clp(5)  [mathematic::Intersect \
                                            [lindex $stem(clamp_1)    3] [lindex $stem(clamp_1)    0] \
                                            [lindex $stem(clamp_2)    3] [lindex $stem(clamp_2)    0] ] 
        set stem_clp(6)  [mathematic::calc_point_length_arc  $geometry::CURRENT_Project(CENTER_HandleBar)    [expr -45]  [ expr 90-$control::CURRENT_Config(HeadTube_Angle)+$control::CURRENT_Config(Stem_Angle)] ]    
                                           
        set stem_clp(7)  [mathematic::Intersect \
                                            $stem_clp(5)                  $stem_clp(6) \
                                            [lindex $stem(coord)      0]  [lindex $stem(coord)      3] ]  
        set stem_clp(8)  [mathematic::Intersect \
                                            $stem_clp(6)                  $stem_clp(1)  \
                                            [lindex $stem(coord)      1]  [lindex $stem(coord)      2] ]  

                                            
          # -- shim on stem --------------------
        set shim_top(1)   [mathematic::line_center  $stem(2) $stem(3) ]
        set shim_top(2)   [mathematic::VAdd  $shim_top(1) \
                                            [mathematic::rotate_point  {0 0}  [list $shim_top_ht  0] \
                                                                          [ expr 180-$control::CURRENT_Config(HeadTube_Angle)] ] ]
        set shim_top(coord) [geometry::tube_outline_direction \
                                                   $shim_top(1) \
                                                   $shim_top(2) \
                                                   $shim_diam ]

                                           

           # lib_canvas::draw_circle  $w  $hlp              10     $tag  green $lw {}
           # lib_canvas::draw_circle  $w  $hlp          10     $tag  red $lw {}
           # lib_canvas::draw_circle  $w  $stem(1)      10     $tag  green $lw {}
           # lib_canvas::draw_circle  $w  $stem_clp(1)  10     $tag  blue $lw {}
           # lib_canvas::draw_circle  $w  $stem_clp(2)  10     $tag  red $lw {}
           # lib_canvas::draw_circle  $w  [lindex $stem(clamp_1)    1]  10     $tag  blue $lw {}
 
        $w  create  polygon \
                          [lindex         $stem(6)             0]  [lindex         $stem(6)             1] \
                          [lindex         $stem_clp(7)         0]  [lindex         $stem_clp(7)         1] \
                          [lindex         $stem_clp(5)         0]  [lindex         $stem_clp(5)         1] \
                          [lindex         $stem_clp(4)         0]  [lindex         $stem_clp(4)         1] \
                          [lindex         $stem_clp(3)         0]  [lindex         $stem_clp(3)         1] \
                          [lindex         $stem_clp(2)         0]  [lindex         $stem_clp(2)         1] \
                          [lindex         $stem_clp(1)         0]  [lindex         $stem_clp(1)         1] \
                          [lindex         $stem_clp(8)         0]  [lindex         $stem_clp(8)         1] \
                          [lindex         $stem(1)             0]  [lindex         $stem(1)             1] \
                          [lindex         $stem(2)             0]  [lindex         $stem(2)             1] \
                          [lindex         $stem(3)             0]  [lindex         $stem(3)             1] \
                          [lindex         $stem(4)             0]  [lindex         $stem(4)             1] \
                          [lindex         $stem(5)             0]  [lindex         $stem(5)             1] \
               -tag $tag  -outline $colour  -width $lw  -fill white

        $w  create  polygon \
                          [lindex [lindex $stem_shim(coord) 0] 0]  [lindex [lindex $stem_shim(coord) 0] 1] \
                          [lindex [lindex $stem_shim(coord) 1] 0]  [lindex [lindex $stem_shim(coord) 1] 1] \
                          [lindex         $stem(5)             0]  [lindex         $stem(5)             1] \
                          [lindex         $stem(4)             0]  [lindex         $stem(4)             1] \
               -tag $tag  -outline $colour  -width $lw  -fill white  
               
        $w  create  polygon \
                          [lindex [lindex $shim_top(coord) 0] 0]  [lindex [lindex $shim_top(coord) 0] 1] \
                          [lindex [lindex $shim_top(coord) 1] 0]  [lindex [lindex $shim_top(coord) 1] 1] \
                          [lindex [lindex $shim_top(coord) 2] 0]  [lindex [lindex $shim_top(coord) 2] 1] \
                          [lindex [lindex $shim_top(coord) 3] 0]  [lindex [lindex $shim_top(coord) 3] 1] \
               -tag $tag  -outline $colour  -width $lw  -fill white  
               
   }


   
 }
  
