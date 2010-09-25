# -----------------------------------------------------------------------------------
#
#: Functions : namespace      C O N F I G
#

 namespace eval config {
 
   variable  PARENT_Geometry  
   variable  CONFIG_Window
   variable  CONFIG_Notebook
   variable  CONFIG_Geometry     
   
   variable  Config_Widget
   variable  Replace_Widget
   
   variable  CURRENT_Config 
   variable  CONFIG_InitList          
   variable  Language_Command 
   

  #-------------------------------------------------------------------------
       #  create
       #
   proc create {w} {
      
        variable CONFIG_Window      $w
        variable CONFIG_Notebook
        variable CONFIG_Geometry
        variable PARENT_Geometry
        
        variable CURRENT_Config
        #variable FRAME_Config_Mode
        
      Debug  p
      Debug t "        proc: open_config_window:  toplevel  $CONFIG_Window"  1
                  
      global Language
      
      set PARENT_Geometry  [::get_w_geometry .]
      set parent_geometry  [wm geometry .]
      set parent_size      [split [lindex [split $parent_geometry +] 0] x]
      set parent           [split $parent_geometry +]
      set parent_x         [lindex $parent 1]
      set parent_y         [lindex $parent 2]
      
      set toplevel_x       [expr [lindex $parent_size 0] + $parent_x]
      set toplevel_y       $parent_y
      
      if {[winfo exists $w]} {
          wm deiconify  $w
          wm deiconify  .
             # Debug t "proc: open_config_window:  wm deiconify  $CONFIG_Window"  1
          return
      }
      
      toplevel       $w
      wm  title      $w  $Language(Control_Panel)
      wm  transient  $w  .
      wm  geometry   $w  +[expr 8+$toplevel_x]+$toplevel_y

      set tmp_frame_cfg  $control::FRAME_Config_Mode
      set control::FRAME_Config_Mode  wait
      
      create_content
      update

      set control::FRAME_Config_Mode  $tmp_frame_cfg 
      
      resize  
     
      wm  withdraw   $w
              
      set CONFIG_Geometry [::get_w_geometry $w ]
     
      bind $w <Configure> {
          set    config::CONFIG_Geometry [::get_w_geometry $config::CONFIG_Window ]
      }

      wm deiconify   .
      wm deiconify   $w
      
      return $CONFIG_Notebook
      
  }
  
  
 #-------------------------------------------------------------------------
       #  bind move 
       #
   proc update_cfg_values {} {
        
        variable CURRENT_Config   

        Debug  p  
        
        # tk_messageBox -message "update_cfg_values:  " 
      foreach id [array names CURRENT_Config] {
          set  CURRENT_Config($id) $control::CURRENT_Config($id)
      }
        # array set CURRENT_Config  [array get control::CURRENT_Config]
      
        # tk_messageBox -message "create:\n  ---\n[array size CURRENT_Config]\n[lsort [array names CURRENT_Config]]
        #                         \n  ---\n[array size control::CURRENT_Config]\n[lsort [array names control::CURRENT_Config]]"  
   }   


  #-------------------------------------------------------------------------
       #  bind move 
       #
   proc bind_move {} {

        variable CONFIG_Window   
        variable CONFIG_Notebook
        variable CONFIG_Geometry
        variable PARENT_Geometry

        Debug  p
        
      if {![winfo exists $CONFIG_Window]} return
      
      set NEW_Geometry [::get_w_geometry . ]

      if { $NEW_Geometry != $PARENT_Geometry } {

               # tk_messageBox -message  "update $CONFIG_Geometry   parent: $PARENT_Geometry"
              Debug  t "BASE   $PARENT_Geometry"
              Debug  t "BASE   $NEW_Geometry"
              
              foreach {    x00     y00     x01     y01} $PARENT_Geometry   break
              foreach {new_x00 new_y00 new_x01 new_y01} $NEW_Geometry      break
              foreach {cfg_x00 cfg_y00 cfg_x01 cfg_y01} $CONFIG_Geometry   break
              
              set BASE_TL  [list $x01     $y00]  
              set NEW_TL   [list $new_x01 $new_y00]  
              set CFG_TR   [list $cfg_x00 $cfg_y00]
    	  
              set BASE_move_x  [expr [lindex $NEW_TL 0] - [lindex $BASE_TL 0] ]
              set BASE_move_y  [expr [lindex $NEW_TL 1] - [lindex $BASE_TL 1] ]
    	  
              set CFG__dist_x  [expr [lindex $CFG_TR 0] - [lindex $BASE_TL 0] ]
              set CFG__dist_x  [expr [lindex $CFG_TR 1] - [lindex $BASE_TL 1] ]
    	  
              set CFG__posi_x  [expr [lindex $CFG_TR 0] + $BASE_move_x ] 
              set CFG__posi_y  [expr [lindex $CFG_TR 1] + $BASE_move_y ] 

              wm geometry $CONFIG_Window +$CFG__posi_x+$CFG__posi_y
              
              set PARENT_Geometry  $NEW_Geometry
              set CONFIG_Geometry  [::get_w_geometry $CONFIG_Window ]
      }  
  }


  #-------------------------------------------------------------------------
       #  resiye after change content
       #
   proc resize {} {
      
        variable CONFIG_Window 
        variable CONFIG_Notebook 
      
      Debug  p
      
      if {[winfo exists  $CONFIG_Window]} {
          wm  resizable  $CONFIG_Window  1 1
          $CONFIG_Notebook compute_size
          wm  resizable  $CONFIG_Window  0 0
      }
  }


  #-------------------------------------------------------------------------
       #  create_content
       #
   proc create_content {} {
         
          variable  CONFIG_Window 
          variable  CONFIG_Notebook 
          #variable  FRAME_Config_Mode 
          #variable  FRAME_Geometry_Id 
          variable  Language_Command
          variable  Config_Widget
          variable  Replace_Widget

          global    APPL_Config
        
        ::Debug  p  

          # tk_messageBox -message "   [option get $CONFIG_Window all font]"
        option add   *font  $APPL_Config(GUI_Font) 
          # 
          # tk_messageBox -message "   [option get $CONFIG_Window all font]"

          # global CURRENT_Project
          # set    CURRENT_Project(Parameter_InitList) {}


        set TEMPLATE_Geometry_Id $control::FRAME_Geometry_Id 
        
        set   CONFIG_Notebook    [ NoteBook    $CONFIG_Window.nb]
        pack $CONFIG_Notebook    -expand true -fill both 
        

        ### -- language ---------------
        global Language
                     lappend   Language_Command  "wm  title   $CONFIG_Window  \$Language(Control_Panel)"


        ####################################   
          # -- cfg_config ------------------
          #
        set cfg_config         [ $CONFIG_Notebook insert end config \
                                           -text      $Language(Config)  \
                                           -raisecmd  {control::switch_canvas config} ]
                     lappend   Language_Command  "$CONFIG_Notebook itemconfigure config     -text \$Language(Config)"
           $cfg_config         configure  -padx 0  -pady 0  -bd 0
        
        set cfg_config         [ frame  $cfg_config.content ]
        pack                   $cfg_config         -fill both  -expand yes  -side top

        
          ### -- cfg_config - parameter ----
            #
        create_config_lbframe  $cfg_config.param   Geometry 
          pack                 $cfg_config.param   -fill both   -expand no   -side top
          
        create_config_scale    $cfg_config.param.f_Wheel_Rim_Diameter         Wheel_Rim_Diameter    frame_design   1.0  10 
          add_config_select    $cfg_config.param.f_Wheel_Rim_Diameter         Wheel_Rim_Diameter    frame_design   rim_lbox_value 
        create_config_scale    $cfg_config.param.f_Wheel_Tyre_Height          Wheel_Tyre_Height     frame_design   1.0   5 
        create_config_scale    $cfg_config.param.f_Wheel_Rear_Rim_Diameter    Wheel_Rear_Rim_Diameter    frame_design   1.0  10 
          add_config_select    $cfg_config.param.f_Wheel_Rear_Rim_Diameter    Wheel_Rear_Rim_Diameter    frame_design   rim_lbox_value 
        create_config_scale    $cfg_config.param.f_Wheel_Rear_Tyre_Height     Wheel_Rear_Tyre_Height     frame_design   1.0   5 
        create_config_scale    $cfg_config.param.f_Wheel_Front_Rim_Diameter   Wheel_Front_Rim_Diameter   frame_design   1.0  10 
          add_config_select    $cfg_config.param.f_Wheel_Front_Rim_Diameter   Wheel_Front_Rim_Diameter   frame_design   rim_lbox_value 
        create_config_scale    $cfg_config.param.f_Wheel_Front_Tyre_Height    Wheel_Front_Tyre_Height    frame_design   1.0   5 
        create_config_scale    $cfg_config.param.f_BottomBracket_Height  BottomBracket_Height       frame_design   0.5
        create_config_scale    $cfg_config.param.f_BottomBracket_Depth   BottomBracket_Depth        frame_design   0.5
        create_config_scale    $cfg_config.param.f_ChainStay_Length      ChainStay_Length           frame_design    
        create_config_scale    $cfg_config.param.f_Front_Length          Front_Length               frame_design  
        
        create_config_scale    $cfg_config.param.b0                      blank         ""                        ""                  
        
        create_config_scale    $cfg_config.param.f_HandleBar_Distance    HandleBar_Distance    frame_design    1.0  20
        create_config_scale    $cfg_config.param.f_HandleBar_Height      HandleBar_Height      frame_design    1.0  20
        create_config_scale    $cfg_config.param.f_HeadTube_Length       HeadTube_Length       frame_design    0.5  20
        create_config_scale    $cfg_config.param.f_HeadTube_Angle        HeadTube_Angle        frame_design    0.1  20
        create_config_scale    $cfg_config.param.f_SeatTube_Angle        SeatTube_Angle        frame_design    0.1  20
        
        create_config_scale    $cfg_config.param.b1                      blank         ""                        ""                  
        
         # create_config_scale    $cfg_config.param.f_TopTube_Heigth        TopTube_Heigth        frame_design    1.0  25
        create_config_scale    $cfg_config.param.f_TopTube_Angle         TopTube_Angle         frame_design    0.1  30
        create_config_scale    $cfg_config.param.f_TopTube_Pivot         TopTube_Pivot         frame_design  
        
        create_config_scale    $cfg_config.param.b2                      blank         ""                        ""                  
        
        create_config_scale    $cfg_config.param.f_Fork_Heigth           Fork_Heigth           frame_design  
        create_config_scale    $cfg_config.param.f_Fork_Rake             Fork_Rake             frame_design  
        create_config_scale    $cfg_config.param.f_HeadsetBottom_Heigth  HeadsetBottom_Heigth  frame_design  
        
        create_config_scale    $cfg_config.param.b3                      blank         ""                        ""                  
        
        create_config_scale    $cfg_config.param.f_Stem_Heigth           Stem_Heigth           frame_design  
        create_config_scale    $cfg_config.param.f_Stem_Angle            Stem_Angle            frame_design  
        create_config_scale    $cfg_config.param.f_Stem_Length           Stem_Length           frame_design  
          
          ### -- cfg_config - handlebar ----
          ### -- cfg_config - fork ----
            #
        create_config_lbframe  $cfg_config.display   Display 
          pack                 $cfg_config.display   -fill both     -expand no   -side top
          
        create_config_select   $cfg_config.display.f_HandleBar_Type      HandleBar_Type        frame_design   handlebar_type 
        create_config_select   $cfg_config.display.f_Fork_Type           Fork_Type             frame_design   fork_type 
        
          ### -- cfg_config - personal -----
            #
        create_config_lbframe  $cfg_config.personal   Personal  1  3
        pack                   $cfg_config.personal    -fill both  -expand yes  -side top

        create_config_scale    $cfg_config.personal.f_InnerLeg_Length    InnerLeg_Length       frame_design    1.0  30
        create_config_scale    $cfg_config.personal.f_CrankArm_length    CrankArm_Length       frame_design    0.5   5
       


          
        ####################################   
          # -- cfg_detail ------------------
          #
        set cfg_detail       [ $CONFIG_Notebook insert end detail \
                                           -text      $Language(Detail)  \
                                           -raisecmd  {control::switch_canvas detail} ]
           $cfg_detail        configure  -padx 0  -pady 0  -bd 0
                    lappend   Language_Command  "$CONFIG_Notebook itemconfigure detail     -text \$Language(Detail)"

        set cfg_detail        [ frame  $cfg_detail.content ]
        pack                   $cfg_detail         -fill both  -expand yes  -side top
        
          ### -- cfg_detail - parameter ----
            #
        create_config_lbframe  $cfg_detail.param   Parameter 
          pack                 $cfg_detail.param   -fill both  -expand yes
          
        create_config_scale    $cfg_detail.param.f_HeadTube_Diameter     HeadTube_Diameter     frame_detail  0.1  35
        create_config_scale    $cfg_detail.param.f_HeadTube_Top          HeadTube_Top          frame_detail  
        create_config_scale    $cfg_detail.param.f_HeadTube_Bottom       HeadTube_Bottom       frame_detail  
        
        create_config_scale    $cfg_detail.param.b1                      blank         ""                        ""                 

        create_config_scale    $cfg_detail.param.f_TopTube_Diameter      TopTube_Diameter      frame_detail  0.1  35
        create_config_scale    $cfg_detail.param.f_TopTube_Diameter_SL   TopTube_Diameter_SL   frame_detail  0.1  35

        create_config_scale    $cfg_detail.param.b2                      blank         ""                        ""                 

        create_config_scale    $cfg_detail.param.f_DownTube_Diameter     DownTube_Diameter     frame_detail  0.1  35
        create_config_scale    $cfg_detail.param.f_DownTube_BB_Diameter  DownTube_BB_Diameter  frame_detail  0.1  40

        create_config_scale    $cfg_detail.param.b3                      blank         ""                        ""                 

        create_config_scale    $cfg_detail.param.f_SeatTube_Diameter     SeatTube_Diameter     frame_detail  0.1  35
        create_config_scale    $cfg_detail.param.f_SeatTube_BB_Diameter  SeatTube_BB_Diameter  frame_detail  0.1  40
        create_config_scale    $cfg_detail.param.f_SeatTube_Lug          SeatTube_Lug          frame_detail  1.0  30
        
        create_config_scale    $cfg_detail.param.b4                      blank         ""                        ""                 

        create_config_scale    $cfg_detail.param.f_SeatStay_Distance     SeatStay_Distance     frame_detail  1.0  30
        create_config_scale    $cfg_detail.param.f_SeatStay_Diameter     SeatStay_Diameter     frame_detail  0.1  30
        create_config_scale    $cfg_detail.param.f_SeatStay_Diameter_2   SeatStay_Diameter_2   frame_detail  0.1  30
        create_config_scale    $cfg_detail.param.f_SeatStay_TaperLength  SeatStay_TaperLength  frame_detail  1.0  50
        
        create_config_scale    $cfg_detail.param.b5   blank  ""  ""       						             

        create_config_scale    $cfg_detail.param.f_ChainStay_Diameter    ChainStay_Diameter    frame_detail  0.1  30
        create_config_scale    $cfg_detail.param.f_ChainStay_Diameter_2  ChainStay_Diameter_2  frame_detail  0.1  30
        create_config_scale    $cfg_detail.param.f_ChainStay_TaperLength ChainStay_TaperLength frame_detail  1.0  30
        
        create_config_scale    $cfg_detail.param.b6   blank  ""  ""       						             

        create_config_select   $cfg_detail.param.f_Fork_Type             Fork_Type             frame_detail   fork_type 
        create_config_scale    $cfg_detail.param.f_ForkCrown_Diameter    ForkCrown_Diameter    frame_detail  1.0  20
        create_config_scale    $cfg_detail.param.f_ForkBlade_Width       ForkBlade_Width       frame_detail  1.0  20
        
          # create_config_scale    $cfg_detail.param.b6   blank  ""  ""       						             
          #
          # create_config_scale    $cfg_detail.param.f_BottomBrckt_Diameter  BottomBrckt_Diameter  frame_detail  0.2  30




        ####################################   
          # -- cfg_draft -------------------
          #
        set cfg_draft          [ $CONFIG_Notebook insert end draft \
                                           -text      $Language(Drafting)  \
                                           -raisecmd  {control::switch_canvas drafting} ]
           $cfg_draft          configure  -padx 0  -pady 0  -bd 0
                     lappend   Language_Command  "$CONFIG_Notebook itemconfigure draft      -text \$Language(Drafting)"

        set cfg_draft          [ frame  $cfg_draft.content ]
        pack                   $cfg_draft          -fill both  -expand yes  -side top

                                 frame  $cfg_draft.f1 
        pack                   $cfg_draft.f1       -fill x     -expand no   -side top
        
          ### -- cfg_draft - format - scale
            #
        create_config_lbframe  $cfg_draft.f1.format        Format  1  3
        label                  $cfg_draft.f1.lb          -padx 1  -pady 3   -text " "
        create_config_lbframe  $cfg_draft.f1.scale         Scale   1  3
          pack                 $cfg_draft.f1.format  $cfg_draft.f1.lb  $cfg_draft.f1.scale \
                                                         -fill both  -expand yes  -side left
          pack configure       $cfg_draft.f1.lb          -expand no                                      
     
            # ---- format -------------
        create_config_radiobutton  $cfg_draft.f1.format.a4  action  "DIN A4"    drafting::DRAFTING(FORMAT)       "A4"   "drafting::create  $::draft_widget"
        create_config_radiobutton  $cfg_draft.f1.format.a3  action  "DIN A3"    drafting::DRAFTING(FORMAT)       "A3"   "drafting::create  $::draft_widget"
        create_config_radiobutton  $cfg_draft.f1.format.a2  action  "DIN A2"    drafting::DRAFTING(FORMAT)       "A2"   "drafting::create  $::draft_widget"
        create_config_radiobutton  $cfg_draft.f1.format.a1  action  "DIN A1"    drafting::DRAFTING(FORMAT)       "A1"   "drafting::create  $::draft_widget"
        create_config_radiobutton  $cfg_draft.f1.format.a0  action  "DIN A0"    drafting::DRAFTING(FORMAT)       "A0"   "drafting::create  $::draft_widget"
        
            # ---- scale --------------

        create_config_radiobutton  $cfg_draft.f1.scale.a10  action  "1:1"       drafting::DRAFTING(FORMAT_Scale)  1.0   "drafting::create  $::draft_widget"
        create_config_radiobutton  $cfg_draft.f1.scale.a05  action  "1:2"       drafting::DRAFTING(FORMAT_Scale)  0.5   "drafting::create  $::draft_widget"
        create_config_radiobutton  $cfg_draft.f1.scale.a02  action  "1:5"       drafting::DRAFTING(FORMAT_Scale)  0.2   "drafting::create  $::draft_widget"
        create_config_radiobutton  $cfg_draft.f1.scale.a01  action  "1:10"      drafting::DRAFTING(FORMAT_Scale)  0.1   "drafting::create  $::draft_widget"
        create_config_radiobutton  $cfg_draft.f1.scale.a04  action  "(1:2,5)"   drafting::DRAFTING(FORMAT_Scale)  0.4   "drafting::create  $::draft_widget"
        
          ### -- cfg_draft - dimension -----
            #
        create_config_lbframe  $cfg_draft.dim              Dimension   1  3
          pack                 $cfg_draft.dim  -fill both  -expand no  -side top

        create_config_bin_radiobutton  $cfg_draft.dim.cnt   {Centerline}      {off}  {on}  drafting::DRAFTING(FRAME_Centerline) "drafting::create  $::draft_widget"
        create_config_bin_radiobutton  $cfg_draft.dim.dim   {Dimension}       {off}  {on}  drafting::DRAFTING(FRAME_Dimension)  "drafting::create  $::draft_widget"
        create_config_bin_radiobutton  $cfg_draft.dim.tube  {Tube_Dimension}  {off}  {on}  drafting::DRAFTING(TUBE_Dimension)   "drafting::create  $::draft_widget"
        create_config_bin_radiobutton  $cfg_draft.dim.jig   {Frame_Jig}       {off}  {on}  drafting::DRAFTING(JIG_Dimension)    "drafting::create  $::draft_widget"
        

          ### -- cfg_draft - update --------
            #
        create_config_lbframe  $cfg_draft.update           Update   1  3
          pack                 $cfg_draft.update  -fill both  -expand yes  -side top

        create_config_button   $cfg_draft.update.b1  update_drafting     "update"  "drafting::create  $::draft_widget"




        ####################################   
          # -- cfg_replace -----------------
          #
        set cfg_replace        [ $CONFIG_Notebook insert end replace \
                                           -text      $Language(Replace)  \
                                           -raisecmd  {control::switch_canvas replace} ]
           $cfg_replace        configure  -padx 0  -pady 0  -bd 0
                     lappend   Language_Command  "$CONFIG_Notebook itemconfigure replace    -text \$Language(Replace)"
        
        set cfg_replace        [ frame  $cfg_replace.content ]
        pack                   $cfg_replace          -fill both  -expand yes  -side top

          ### -- cfg_replace - parameter ---
            #
        create_config_lbframe  $cfg_replace.param   Parameter  1  3
        pack                   $cfg_replace.param    -fill x     -expand no   -side top
     
        create_config_scale    $cfg_replace.param.f_Wheel_Rim_Diameter       Comp_Wheel_Rim_Diameter        replace_component  1.0  20
          add_config_select    $cfg_replace.param.f_Wheel_Rim_Diameter       Comp_Wheel_Rim_Diameter        replace_component  rim_lbox_value 
        create_config_scale    $cfg_replace.param.f_Wheel_Tyre_Height        Comp_Wheel_Tyre_Height         replace_component  1.0  20
        create_config_scale    $cfg_replace.param.f_Wheel_Rear_Rim_Diameter  Comp_Wheel_Rear_Rim_Diameter   replace_component  1.0  20
          add_config_select    $cfg_replace.param.f_Wheel_Rear_Rim_Diameter  Comp_Wheel_Rear_Rim_Diameter   replace_component  rim_lbox_value 
        create_config_scale    $cfg_replace.param.f_Wheel_Rear_Tyre_Height   Comp_Wheel_Rear_Tyre_Height    replace_component  1.0  20
        create_config_scale    $cfg_replace.param.f_Wheel_Front_Rim_Diameter Comp_Wheel_Front_Rim_Diameter  replace_component  1.0  20
          add_config_select    $cfg_replace.param.f_Wheel_Front_Rim_Diameter Comp_Wheel_Front_Rim_Diameter  replace_component  rim_lbox_value 
        create_config_scale    $cfg_replace.param.f_Wheel_Front_Tyre_Height  Comp_Wheel_Front_Tyre_Height   replace_component  1.0  20
        
        create_config_scale    $cfg_replace.param.b1                        blank         ""                           ""                 
        
        create_config_scale    $cfg_replace.param.f_Fork_Heigth              Comp_Fork_Heigth         replace_component  1.0  40
        create_config_scale    $cfg_replace.param.f_Fork_Rake                Comp_Fork_Rake   	      replace_component  

        create_config_scale    $cfg_replace.param.b2                        blank         ""                           ""                 
        
        create_config_scale    $cfg_replace.param.f_Stem_Heigth              Comp_Stem_Heigth         replace_component    
        create_config_scale    $cfg_replace.param.f_Stem_Angle               Comp_Stem_Angle          replace_component    
        create_config_scale    $cfg_replace.param.f_Stem_Length              Comp_Stem_Length         replace_component    

          ### -- cfg_replace - replace -------
            #
        create_config_lbframe  $cfg_replace.reset   Reset  1  3
        pack                   $cfg_replace.reset    -fill both  -expand yes  -side top

        create_config_button   $cfg_replace.reset.b1  toggle_config_replace  "toggle"  control::toggle_config_replace
        create_config_button   $cfg_replace.reset.b2  reset_2_frame_cfg      "reset"   control::reset_replace_to_config




        ####################################   
          # -- cfg_option ------------------
          #
        set cfg_option         [ $CONFIG_Notebook insert end option \
                                           -text      {c}  ]
           $cfg_option         configure  -padx 0  -pady 0  -bd 0
        
        set cfg_option         [ frame  $cfg_option.content ]
        pack                   $cfg_option           -fill both  -expand yes  -side top

          ### -- cfg_option - parameter ---
            #
        create_config_lbframe  $cfg_option.cfg   Config   1  3
        pack                   $cfg_option.cfg    -fill x     -expand no   -side top
     
        config::create_config_bin_radiobutton  $cfg_option.cfg.rim   RimLock    lock   unlock   control::GUI_Config(GUI_LOCK_config_Rim)   {}
        config::create_config_bin_radiobutton  $cfg_option.cfg.tyre  TyreLock   lock   unlock   control::GUI_Config(GUI_LOCK_config_Tyre)  {}
        config::create_config_bin_radiobutton  $cfg_option.cfg.bb    BBMeth     height  depth   control::GUI_Config(GUI_METH_BBracket)     {}
        config::create_config_bin_radiobutton  $cfg_option.cfg.ht    HTMeth     angle     bar   control::GUI_Config(GUI_METH_HTube)        {}
      
      
        create_config_lbframe  $cfg_option.rpl   Replace  1  3
        pack                   $cfg_option.rpl    -fill x     -expand no   -side top
           
        config::create_config_bin_radiobutton  $cfg_option.rpl.rim   RimLock    lock   unlock   control::GUI_Config(GUI_LOCK_replace_Rim)  {}
        config::create_config_bin_radiobutton  $cfg_option.rpl.tyre  TyreLock   lock   unlock   control::GUI_Config(GUI_LOCK_replace_Tyre) {}
      

        create_config_lbframe  $cfg_option.cmt   Commit   1  3
        pack                   $cfg_option.cmt    -fill both     -expand yes  -side top

        create_config_button   $cfg_option.cmt.b1  update_cfg_gui     "commit"  { control::toggle_lock_attribute;config::update_cfg_values
                                                                                  # $CONFIG_Notebook raise [ $CONFIG_Notebook page 4] 
                                                                                }


        ####################################   
          # -- update -----------------
        $cfg_config            configure -borderwidth 4 
        $cfg_detail            configure -borderwidth 4 
        $cfg_draft             configure -borderwidth 4 
        $cfg_replace           configure -borderwidth 4 
        $cfg_option            configure -borderwidth 4 

        $CONFIG_Notebook       raise [ $CONFIG_Notebook page 0 ]
        
        set Config_Widget      $cfg_config
        set Replace_Widget     $cfg_replace

        }
   
   
   #-------------------------------------------------------------------------
       #  create_config_lbframe
       #
   proc create_config_lbframe { w text_tag {padx 0} {pady 0} } {
        
        variable Language_Command        
        
        ::Debug  p  1
        
        global Language 
        
        lappend  Language_Command  "$w configure  -text \$Language($text_tag)"
                
        labelframe    $w  -padx $padx  -pady $pady   -text $Language($text_tag)

   } 


   #-------------------------------------------------------------------------
       #  create_config_scale
       #
   proc create_config_scale { w var_name cfg_mode {resolution 1.0} {scale_length 10} } {

          variable CURRENT_Config
          variable CONFIG_VarList
          
          global  _CURRENT_Project
   
          global  Language 

        ::Debug  p  1
        
                
        frame $w
        pack  $w  -fill x
        
        if {[string equal $var_name "blank"]} {
             frame   $w.spc  -height 9  -width 20  
             pack    $w.spc
             return
        }
        
        lappend CONFIG_VarList  $var_name
        
        set     CURRENT_Config($var_name)  0.99


        #eval   [ format "set var_value \$CURRENT_Config($var_name)" ]
        #set    CURRENT_Config($var_name) [expr 1.0*$CURRENT_Config($var_name)]
          # set    CURRENT_Project($var_name) [expr 1.0*$CURRENT_Project($var_name)]

        
        frame          $w.f0   -bd             0
        
          label        $w.f0.lb  \
                               -textvariable   ::Language($var_name) \
                               -width          20 \
                               -bd             1 \
                               -anchor         w 
                               
        frame          $w.fr   -relief         sunken \
                               -bd             1
        
          ArrowButton    $w.fr.left   \
                               -dir            left \
                               -height         17 \
                               -fg             SlateGray \
                               -repeatdelay    1 \
                               -armcommand     "config::scale_update  $w.fr.cfg  $var_name minus $resolution $cfg_mode" 
          entry          $w.fr.cfg    \
                               -textvariable   config::CURRENT_Config($var_name) \
                               -width          7  \
                               -bd             1 \
                               -justify        right \
                               -bg             white 
          ArrowButton    $w.fr.right  \
                               -dir            right \
                               -height         17 \
                               -fg             SlateGray \
                               -repeatdelay    1 \
                               -armcommand     "config::scale_update  $w.fr.cfg  $var_name plus  $resolution $cfg_mode"  
                               
        pack         $w.f0     -side left 
        pack         $w.f0.lb  -side left 
                               
        pack         $w.fr     -side right 
        pack         $w.fr.left  $w.fr.cfg  $w.fr.right \
                               -side left

           
        bind         $w.fr.cfg    <KeyPress-Return> "control::update_parameter   $var_name"
        bind         $w.fr.cfg    <Leave>           "control::update_parameter   $var_name"
          # bind         $w.fr.cfg    <KeyPress-Return> "control::update_parameter   $var_name; control::update_graph"
          # bind         $w.fr.cfg    <Leave>           "control::update_parameter   $var_name; control::update_graph"

   }


   #-------------------------------------------------------------------------
       #  scale update
       #
   proc scale_update {w var_name direction resolution cfg_mode} {
       
         variable CURRENT_Config
         global   CURRENT_Project
       
       ::Debug  p  1
       
       set control::FRAME_Config_Mode $cfg_mode
                
         # set var_name [$w cget -textvariable]
         # global $var_name
         # eval [ format "set CURRENT_Project($var_name) \$$var_name" ]       
       switch $direction {
           plus    { set CURRENT_Config($var_name) [expr $CURRENT_Config($var_name) + $resolution] }
           minus   { set CURRENT_Config($var_name) [expr $CURRENT_Config($var_name) - $resolution] }
       }
       
       set CURRENT_Config($var_name) [expr 1.0 * $CURRENT_Config($var_name)]
       ::Debug  t  " $var_name   " 
       ::Debug  t  " $var_name \n" 
       
         # tk_messageBox -message "scale_update  $var_name"
       control::update_parameter   $var_name
         #control::update_graph       
       
   }
        

   #-------------------------------------------------------------------------
       #  create_config_select
       #
   proc create_config_select { w var_name cfg_mode l_select} {

          variable CURRENT_Config
          variable CONFIG_VarList
          global   Language 
          global   $l_select


        ::Debug  p  1
        
                
        frame $w
        pack  $w  -fill x
        
          # lappend CURRENT_Project(Parameter_InitList) $var_name
          # set CURRENT_Config($var_name) 0
          # lappend CONFIG_Values $var_name
          ::Debug t "    -> $var_name"
        
        #eval   [ format "set var_value \$CURRENT_Config($var_name)" ]
        
          # tk_messageBox -message "create_config_select:  $l_select"
          
        lappend CONFIG_VarList  $var_name  
        set     CURRENT_Config($var_name)  xxx

        frame          $w.f0   -bd             0
        
          label        $w.f0.lb  \
                               -textvariable   ::Language($var_name) \
                               -width          20 \
                               -bd             1 \
                               -anchor         w 
                               
        frame          $w.fr   -relief         sunken \
                               -bd             1
        
          ArrowButton    $w.fr.select  \
                               -dir            bottom \
                               -height         17 \
                               -fg             SlateGray \
                               -armcommand     "config::create_selectbox  $w.fr.select  $l_select  $var_name  $cfg_mode"  
          entry          $w.fr.cfg    \
                               -textvariable   config::CURRENT_Config($var_name) \
                               -width          12  \
                               -bd             1 \
                               -justify        right \
                               -bg             white 
          ArrowButton    $w.fr.right  \
                               -dir            right \
                               -height         17 \
                               -fg             SlateGray \
                               -repeatdelay    1 \
                               -armcommand     ""  
                               
        pack         $w.f0     -side left 
        pack         $w.f0.lb  -side left 
                               
        pack         $w.fr     -side right 
        pack         $w.fr.select  $w.fr.cfg  \
                               -side left

   }


   #-------------------------------------------------------------------------
       #  add config select
       #
   proc add_config_select { w var_name cfg_mode l_select } {

          variable CURRENT_Config
          global   Language  $l_select

        ::Debug  p  1
        
                     #$w        configure  -bg blue  
                     #$w.f0     configure  -bg red
                     $w.f0.lb  configure  -width 15 
        pack         $w        -fill x

        ArrowButton  $w.fr.select  \
                               -dir            bottom \
                               -height         17 \
                               -fg             SlateGray \
                               -armcommand     "config::create_selectbox  $w.fr.select  $l_select  $var_name  $cfg_mode"  
                
        pack         $w.fr.select  \
                               -before  $w.fr.left\
                               -side left 
   }

       proc create_selectbox {parent  values  target_var  cfg_mode} {
  
              global $values 
              variable CURRENT_Config
  
            ::Debug  p  1

            ::Debug  t  "  try to create __select_box"
      
              # tk_messageBox -message "create_config_select:  $values"

            set toplevel_widget  .__select_box
      
            if {[winfo exists $toplevel_widget]} {
                return
            }
      
            toplevel  $toplevel_widget

            frame     $toplevel_widget.f
            pack      $toplevel_widget.f
      
            listbox   $toplevel_widget.f.lbox \
                          -listvariable   $values \
                          -selectmode     single \
                          -relief         sunken \
                          -yscrollcommand "$toplevel_widget.f.svert  set" 
      
            scrollbar $toplevel_widget.f.svert \
                          -orient         v \
                          -command        "$toplevel_widget.f.lbox yview"
      
      
            pack $toplevel_widget.f.lbox $toplevel_widget.f.svert -side left -fill y
      
            bind .                       <Configure>        [list config::bind_parent_move  $toplevel_widget  $parent]
            bind $toplevel_widget.f.lbox <<ListboxSelect>>  [list config::update_close      %W  $target_var   $cfg_mode  $parent]
      
            wm  overrideredirect  $toplevel_widget  1
            bind_parent_move      $toplevel_widget  $parent  
       }

       proc bind_parent_move {toplevel_widget parent} {
            ::Debug  p  1
            if {![winfo exists $toplevel_widget]} return
            set toplevel_x    [winfo rootx $parent]
            set toplevel_y    [expr [winfo rooty $parent]+ [winfo reqheight $parent]]
            wm  geometry      $toplevel_widget +$toplevel_x+$toplevel_y
            wm  deiconify     $toplevel_widget
       }
      
       proc update_close {source_window  target_var  cfg_mode  parent} {
            
              variable CURRENT_Config

            ::Debug  p  1

            puts "   source_window $source_window"
            puts "       index: [$source_window curselection]"
            set  widget_value     [$source_window get [$source_window curselection]]
            puts "       value: $widget_value"
            
            if {[string range $widget_value 0 3] == {----} } {
                    # tk_messageBox -message " seperator:   $widget_value"
                  destroy  [winfo toplevel $source_window]
                  return
            }

            if {[string is wordchar $widget_value]} {
                    # tk_messageBox -message " alpha   $widget_value"
                  set      CURRENT_Config($target_var)     $widget_value
            } else {
                    # tk_messageBox -message " integer   $widget_value"
                  set      target_value    [expr 1.0 * [string trim [lindex [split $widget_value {;}] 1] { }] ]
                  set      CURRENT_Config($target_var)     $target_value
                    # control::lock_check_value  $target_var  
                  ::Debug t     "  $target_var     $target_value"
            }
            
            control::update_parameter   $target_var
              # control::update_graph    
            destroy  [winfo toplevel $source_window]
       }


   #-------------------------------------------------------------------------
       #  create_config_bin_radiobutton
       #
   proc create_config_bin_radiobutton { w lb_text rb_value_1 rb_value_2 rb_var command} {
     
          global Language 

        ::Debug  p  1

        frame $w
        pack  $w      -side top  -fill x
        
        label         $w.lb   \
                          -textvariable  Language($lb_text) \
                          -width 16  -bd 1  -anchor w 
        radiobutton   $w.rb_0 \
                          -textvariable  Language($rb_value_1)  \
                          -variable      $rb_var     \
                          -value         $rb_value_1 \
                          -command       $command
        radiobutton   $w.rb_1 \
                          -textvariable  Language($rb_value_2)  \
                          -variable      $rb_var     \
                          -value         $rb_value_2 \
                          -command       $command
     
        pack  $w.lb  $w.rb_0  $w.rb_1  -side left  -fill x
   }
   

   #-------------------------------------------------------------------------
       #  create_config_button
       #
   proc create_config_button { w comment_tag b_text b_command } {
     
        ::Debug  p  1

        global Language 

        frame $w
        pack  $w      -side top  -fill x
        
        label         $w.lb \
                          -textvariable   Language($comment_tag) \
                          -justify        left \
                          -anchor         w 
                          
        button        $w.bt \
                          -text     "$b_text" \
                          -width    10 \
                          -command  "$b_command" 
                          
        pack  $w.lb       -side left   -fill x  -expand yes -padx 5  
        pack  $w.bt       -side right  -fill x  -padx 5  
   }
   
   
   #-------------------------------------------------------------------------
       #  create_config_radiobutton
       #
   proc create_config_radiobutton { w action rb_text rb_var rb_value command} {
     
        ::Debug  p  1

        frame $w
        pack  $w      -side top  -fill x
        radiobutton   $w.rb \
                          -text     $rb_text  \
                          -variable $rb_var   \
                          -value    $rb_value \
                          -command  $command
     
        pack  $w.rb   -side left  -fill x
   }
           

   #-------------------------------------------------------------------------
       #  update language
       #
   proc update_language { } {
        
        ::Debug  p  1
        
        global Language 
        # set    lang     $Language(current)
        
        foreach cmd_list $config::Language_Command \
          {
             #set w      [lindex $cmd_list 0]
             #set t_type [lindex $cmd_list 1]
             #set t_tag  [lindex $cmd_list 2]
             #set t_text [lindex [lindex $Language($lang)  [lsearch $Language($lang) $t_tag*]]   1] 
             
             #tk_messageBox -message "[format  "%s configure %s {%s}"  $w  $t_type $t_text ]"
             #::Debug  t  "[eval $w cget $t_type] "
             #::Debug  t  "$w configure $t_type $t_text"
             ::Debug  t  "[format  "%s"  $cmd_list ]"
             eval [format  "%s"  $cmd_list ]
             #exit
          }
   } 


}

