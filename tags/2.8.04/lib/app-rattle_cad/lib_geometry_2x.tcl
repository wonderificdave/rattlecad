# -----------------------------------------------------------------------------------
#
#: Functions : namespace      G E O M E T R Y
#

 namespace eval geometry_2x {

   variable  CURRENT_Project
   array set CURRENT_Project {}


   #-------------------------------------------------------------------------
       #  extend_value_to_current
       #
   proc extend_value_to_22 {} {
   
          variable CURRENT_Project
          
        ::Debug  p  1

          # tk_messageBox -message "extend_value_to_22:   "
        set xy [ mathematic::VSub         $CURRENT_Project(CENTER_HeadTube_Top)  $CURRENT_Project(CENTER_HeadTube_Bottom) ]
        set control::CURRENT_Config(HeadTube_Length)  \
               [ expr hypot([lindex $xy 0],[lindex $xy 1]) ]
          # tk_messageBox -message "  $CURRENT_Project(CENTER_HandleBar)" 
        set xy         [ mathematic::VSub                $CURRENT_Project(CENTER_Stem)  $CURRENT_Project(CENTER_HeadTube_Top) ]
        set control::CURRENT_Config(Stem_Heigth)         [ expr hypot([lindex $xy 0],[lindex $xy 1]) ]
        set control::CURRENT_Config(HandleBar_Distance)  [lindex $CURRENT_Project(CENTER_HandleBar) 0] 
        set control::CURRENT_Config(HandleBar_Height)    [expr [lindex $CURRENT_Project(CENTER_HandleBar) 1] - $control::CURRENT_Config(BottomBracket_Height)]
   }

   
   #-------------------------------------------------------------------------
       #  compute geometry of bicycle
       #
   proc compute_bb_wheel_fork {} {
    
            variable CURRENT_Project
              # global CURRENT_Project CURRENT_Config  
        
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
          # ------------------------------------							 
        set arc            [expr 180-$control::CURRENT_Config(HeadTube_Angle)]
        set h_rake         [expr {$control::CURRENT_Config(Fork_Rake) / sin([mathematic::rad $control::CURRENT_Config(HeadTube_Angle)])}] 
        set hlp_vct        [list $h_rake 0]
        set CURRENT_Project(CENTER_ForkPoint) \
                           [ mathematic::calc_point_length_arc   $CURRENT_Project(CENTER_FrontWheel)     $control::CURRENT_Config(Fork_Rake)    [expr $arc+90] ]
        set CURRENT_Project(CENTER_ForkBase)  \
                           [ mathematic::calc_point_length_arc   $CURRENT_Project(CENTER_ForkPoint)      $control::CURRENT_Config(Fork_Heigth)  $arc ]
        set CURRENT_Project(CENTER_ForkCut) \
                           [ mathematic::VSub                    $CURRENT_Project(CENTER_FrontWheel)      $hlp_vct ]
                           
          # ------------------------------------							 
        set CURRENT_Project(Wheel_Distance \
                           [ expr  abs( [ lindex $rw_c  0 ] ) +  abs( [ lindex $rw_c  0 ] )   ]
   }

     
   #-------------------------------------------------------------------------
       #  compute geometry of bicycle
       #
   proc compute_frame_geometry {} {

            variable CURRENT_Project
              # global CURRENT_Project  CURRENT_Mitter
        
        ::Debug  p  1

          # ------------------------------------
        set tt_bs  [ list  $control::CURRENT_Config(TopTube_Pivot)   $control::CURRENT_Config(TopTube_Heigth) ]
        set st_a   [ expr  180 - $control::CURRENT_Config(SeatTube_Angle) ]
        set st_vct [ mathematic::VAdd  $CURRENT_Project(CENTER_BottomBracket)  [ mathematic::rotate_point  {0 0}  {1 0}    $st_a] ]
        set tt_vct [ mathematic::VAdd  $tt_bs                   [ mathematic::rotate_point  {0 0}  {100 0}  $control::CURRENT_Config(TopTube_Angle)] ]
        set ht_vct [ mathematic::VAdd  $CURRENT_Project(CENTER_ForkBase)       [ mathematic::rotate_point  {0 0}  {100 0}  [ expr 180-$control::CURRENT_Config(HeadTube_Angle)] ] ]
          # ------------------------------------
        set CURRENT_Project(CENTER_Standing_Top)     [ list $control::CURRENT_Config(TopTube_Pivot)   $control::CURRENT_Config(InnerLeg_Length)   ]
        set CURRENT_Project(CENTER_TopTube_Pivot)    [ list $control::CURRENT_Config(TopTube_Pivot)   $control::CURRENT_Config(TopTube_Heigth)    ]
          # ------------------------------------
        set CURRENT_Project(CENTER_HeadTube_Base) \
                           [ mathematic::Intersect  $CURRENT_Project(CENTER_ForkBase)       $ht_vct  {0 0}   {100 0} ]
        set CURRENT_Project(CENTER_SeatTube_Base) \
                           [ mathematic::Intersect  $CURRENT_Project(CENTER_BottomBracket)  $st_vct  {0 0}   {100 0} ]
          # ------------------------------------
        set CURRENT_Project(CENTER_TopTube_Seat) \
                           [ mathematic::Intersect  $CURRENT_Project(CENTER_BottomBracket)  $st_vct  $tt_bs  $tt_vct ]
          # ------------------------------------
        set l_bb_s         [ expr 0.88 * $control::CURRENT_Config(InnerLeg_Length) ]
        set CURRENT_Project(CENTER_Seat_Top) \
                           [ mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_BottomBracket)   $l_bb_s  $st_a  ]
          # ------------------------------------
        set ht_a   [ expr 180 - $control::CURRENT_Config(HeadTube_Angle) ]
        set ht_vct [ mathematic::VAdd $CURRENT_Project(CENTER_ForkBase) [ mathematic::rotate_point {0 0}  {1 0}  $ht_a]    ]
          # ------------------------------------
        set CURRENT_Project(CENTER_TopTube_Head) \
                           [ mathematic::Intersect  $CURRENT_Project(CENTER_ForkBase)  $ht_vct  $tt_bs  $tt_vct ]
          # ------------------------------------
        set CURRENT_Project(CENTER_HeadTube_Bottom) \
                           [ mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_ForkBase)  $control::CURRENT_Config(HeadsetBottom_Heigth)     $ht_a  ]
          # ------------------------------------  
          #  Connection DownTube HeadTube
        set vt_htd         [ mathematic::rotate_point {0 0}  [list [expr 0.5*$control::CURRENT_Config(HeadTube_Diameter)] 0]  [expr $ht_a+90] ]
        set hp_ht_1        [ mathematic::VAdd  $CURRENT_Project(CENTER_HeadTube_Bottom)  $vt_htd ]
        set hp_ht_2        [ mathematic::VAdd  $CURRENT_Project(CENTER_HeadTube_Base)    $vt_htd ]
        set CURRENT_Project(CENTER_LUG_HeadBottom) \
                           [ mathematic::calc_point_length_arc  $hp_ht_1  $control::CURRENT_Config(HeadTube_Bottom)  $ht_a ]
        set hl_dt_ar1      [ mathematic::FindAngle    [list 100  [lindex $CURRENT_Project(CENTER_BottomBracket) 1]]  $CURRENT_Project(CENTER_BottomBracket)  $CURRENT_Project(CENTER_LUG_HeadBottom) ]
        set xy             [ mathematic::VSub         $CURRENT_Project(CENTER_LUG_HeadBottom)  $CURRENT_Project(CENTER_BottomBracket) ]
        set hl_dt_l        [ expr hypot([lindex $xy 0],[lindex $xy 1]) ]
        set hl_dt_ar2      [ expr asin([expr $control::CURRENT_Config(DownTube_Diameter)*0.5/$hl_dt_l])*180 / $::CONST_PI  ]
        set dt_arc         [ expr $hl_dt_ar1+$hl_dt_ar2]
        set hp_1        [ mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_BottomBracket)  $hl_dt_l  $dt_arc  ]
        set CURRENT_Project(CENTER_DownTube_Head) \
                           [ mathematic::Intersect  $CURRENT_Project(CENTER_ForkBase)  $ht_vct  $CURRENT_Project(CENTER_BottomBracket)  $hp_1 ]
          # ------------------------------------  
          #  Connection TopTube HeadTube
        set vt_ttd         [ mathematic::calc_point_length_arc  {0 0}  [expr $control::CURRENT_Config(TopTube_Diameter)*0.5]  [expr 90 + $control::CURRENT_Config(TopTube_Angle)] ]
        set hp_tt_1        [ mathematic::VAdd   $CURRENT_Project(CENTER_TopTube_Head)  $vt_ttd ]
        set hp_tt_2        [ mathematic::VAdd   $tt_bs                  $vt_ttd ]
        set CURRENT_Project(CENTER_LUG_HeadTop) \
                           [ mathematic::Intersect  $hp_ht_1  $hp_ht_2  $hp_tt_1  $hp_tt_2 ] 
        set hp_1           [ mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_LUG_HeadTop)  $control::CURRENT_Config(HeadTube_Top)  $ht_a ]
        set CURRENT_Project(CENTER_HeadTube_Top) \
                           [ mathematic::VSub  $hp_1  $vt_htd ]
          # ------------------------------------  
          #  Connection TopTube SeatTube
        set vt_std         [ mathematic::rotate_point {0 0}  [list [expr $control::CURRENT_Config(SeatTube_Diameter)*0.5] 0]  [expr $st_a-90] ]
        set hp_st_1        [ mathematic::VAdd   $CURRENT_Project(CENTER_BottomBracket)  $vt_std ]
        set hp_st_2        [ mathematic::VAdd   $CURRENT_Project(CENTER_TopTube_Seat)   $vt_std ]
        set CURRENT_Project(CENTER_LUG_SeatTop) \
                           [ mathematic::Intersect  $hp_st_1  $hp_st_2  $hp_tt_1  $hp_tt_2 ]
        set p1             [ mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_LUG_SeatTop)  $control::CURRENT_Config(SeatTube_Lug)  $st_a ]
        set CURRENT_Project(CENTER_SeatTube_Top) \
                           [ mathematic::VSub  $p1  $vt_std ] 
          # ------------------------------------
        set CURRENT_Project(CENTER_SeatStay_Top) \
                           [ mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_TopTube_Seat)  -$control::CURRENT_Config(SeatStay_Distance)  $st_a  ]          
          # ------------------------------------  
        set CURRENT_Project(CENTER_Stem)  [ mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_HeadTube_Top)  $control::CURRENT_Config(Stem_Heigth)  $ht_a  ]
          # ------------------------------------
        set CURRENT_Project(CENTER_HandleBar) \
                           [ mathematic::calc_point_length_arc  $CURRENT_Project(CENTER_Stem)          $control::CURRENT_Config(Stem_Length)  [ expr  $ht_a + $control::CURRENT_Config(Stem_Angle) - 90 ]  ]
        set CURRENT_Project(CENTER_TopTube_Heigth) \
                           [ list $control::CURRENT_Config(TopTube_Pivot)  $control::CURRENT_Config(TopTube_Heigth) ]
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
		
		set CURRENT_Project(CENTER_RearBrake) 		$fr_rbp_2
		set CURRENT_Project(CENTER_RearBrakePad) 	$fr_rbp_3
		  # ------------------------------------  
        
        
        set CURRENT_Mitter(TopTube_Head)  [list $control::CURRENT_Config(TopTube_Diameter) \
                                                $control::CURRENT_Config(HeadTube_Diameter) \
                                                [expr 180 - [mathematic::FindAngle  $hp_ht_1  \
                                                                                    $CURRENT_Project(CENTER_LUG_HeadTop) \
                                                                                    $hp_tt_2 ] ] \
												0 \
                                          ]
       
        set CURRENT_Mitter(TopTube_Seat)  [list $control::CURRENT_Config(TopTube_Diameter) \
                                                $control::CURRENT_Config(SeatTube_Diameter) \
                                                [expr 180 - [mathematic::FindAngle  $hp_st_1  \
                                                                                    $CURRENT_Project(CENTER_LUG_SeatTop) \
                                                                                    $hp_tt_2 ] ] \
												0 \
                                          ]
        
        set CURRENT_Mitter(SeatStay_Seat) [list $control::CURRENT_Config(SeatStay_Diameter) \
                                                $control::CURRENT_Config(SeatTube_Diameter) \
                                                [expr       [mathematic::FindAngle  $CURRENT_Project(CENTER_RearWheel) \
                                                                                    $CURRENT_Project(CENTER_SeatStay_Top) \
                                                                                    $CURRENT_Project(CENTER_BottomBracket) ] ] \
												[expr 0.5*($control::CURRENT_Config(SeatTube_Diameter) - $control::CURRENT_Config(SeatStay_Diameter))] \
                                          ]  
        
        
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
   
   
   
 }
  
