#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"


##+##########################################################################
#
# rattle_cad.tcl
# by Manfred ROSENBERGER
#
#   (c) Manfred ROSENBERGER 2008/07/02
#
#   rattle_cad is software of Manfred ROSENBERGER
#       based on tclTk and BWidgets and their 
#       own Licenses.
# 
#
# 

  
  variable  APPL_Env
  variable  APPL_Config

  array set APPL_Env { 
                       RELEASE_Version    {2.8}  
                       RELEASE_Revision   {04}  
                       RELEASE_Date       {31. Jan. 2010}  
                       BASE_Dir           {}
                       ROOT_Dir           {}
                       CONFIG_Dir         {}
                       IMAGE_Dir          {}
                       VECTOR_Font        {}
                       USER_Dir           {}
                       USER_Init          {}
                       CONFIG_Window      {.cfg}
                       CONFIG_Notebook    {}
                       FILE_List          {.fl}
                       TUBEMITER_Window   {.tm}
                     }

  array set APPL_Config { 
                       GUI_Font               {Arial 8}
                       VECTOR_Font            {}
                       Language               {english}
					   Window_Position        {30 30 400 400} 
                       WINDOW_Title           "rattleCAD  $APPL_Env(RELEASE_Version).$APPL_Env(RELEASE_Revision) - template"
                       PROJECT_Name           "template"
					   FILE_List              {}
                     }
                     

  

  set APPL_Env(BASE_Dir)  [file dirname [file normalize $::argv0] ]
  
    # exception for starkit compilation
    #    .../rattle_cad.exe
  set APPL_Type           [file tail $APPL_Env(BASE_Dir)]
  switch $APPL_Type {
       rattle_cad.exe { set APPL_Env(CONFIG_Dir)    [file join    $APPL_Env(BASE_Dir) etc   ]
                        set APPL_Env(IMAGE_Dir)     [file join    $APPL_Env(BASE_Dir) image ]
                        set APPL_Env(BASE_Dir)      [file dirname $APPL_Env(BASE_Dir)       ] 
                      }
       default        { set APPL_Env(CONFIG_Dir)    [file join    $APPL_Env(BASE_Dir) etc   ]
                        set APPL_Env(IMAGE_Dir)     [file join    $APPL_Env(BASE_Dir) image ]
                      }
    }
  
  set APPL_Env(ROOT_Dir)      [file dirname $APPL_Env(BASE_Dir)       ]

    puts "  \$APPL_Env(BASE_Dir)      $APPL_Env(BASE_Dir)"
    puts "  \$APPL_Env(CONFIG_Dir)    $APPL_Env(CONFIG_Dir)"
    puts "  \$APPL_Env(IMAGE_Dir)     $APPL_Env(IMAGE_Dir)"
    puts "  ------------- "



  lappend auto_path           [file join $APPL_Env(BASE_Dir) lib]
  
  package require   Tk
  package require   BWidget 
    
  package require   dimension
  package require   switchpage
  package require   AppUtil
  package require   rattle_cad  
  

    # -- vectorfont -------------
  set APPL_Env(VECTOR_Font)  [vectorfont::load_shape m_iso8.shp]
  vectorfont::setscale 1.0
    
    puts "  $APPL_Env(VECTOR_Font)  "


    # -- AppUtil  ---------------
  SetDebugLevel 20

  

  ###########################################################################
  #
  #                 M  -  A  -  I  -  N 
  #
  ###########################################################################


    # -- CONST_PI ---------------
  set CONST_PI            $mathematic::CONST_PI

    # -- RIM - listbox content --------
  set  rim_definition_file         [file join $APPL_Env(CONFIG_Dir) rim_diameter.csv]
    set fd [open $rim_definition_file r]
    while {![eof $fd]} \
       {  set line [gets $fd]
          lappend rim_lbox_value $line
       }
    close $fd

    # -- HANDLEBAR - listbox content --
  set  handlebar_definition_file   [file join $APPL_Env(CONFIG_Dir) handlebar_type.csv]
    set fd [open $handlebar_definition_file r]
    while {![eof $fd]} \
       {  set line [gets $fd]
          lappend handlebar_type $line
       }
    close $fd

    # -- FORK - listbox content --
  set  fork_definition_file   [file join $APPL_Env(CONFIG_Dir) fork_type.csv]
    set fd [open $fork_definition_file r]
    while {![eof $fd]} \
       {  set line [gets $fd]
          lappend fork_type $line
       }
    close $fd


    # -- initialize road/offroad - templates 
    # -- initialize user - settings 
  control::get_user_dir
  control::user_settings
  
  
    # -- Language  --------------
  update_language  $APPL_Config(Language)

    # -- set standard font ------
  option add *font $APPL_Config(GUI_Font)
  

  ###########################################################################
  #
  #                 I  -  N  -  T  -  R  -  O
  #
  ###########################################################################


  create_intro  .intro  
  
  
  
    
  ###########################################################################
  #
  #                 W  -  I  -  N  -  D  -  O  -  W
  #
  ###########################################################################


    # ================================
  set menu_bar {
        "&File"   all file 0 {
            {command "&Open"                  {File_Open}     "Open Configuration"    {Ctrl o} -command { control::openFile_Selection } }
            {command "&Recent Files"          {File_Recent}   "Open recent Config"    {Ctrl r} -command { create_file_list }            }
            {command "&Save"                  {File_Save}     "Save Configuration"    {Ctrl s} -command { control::saveFile }           }
            {separator}
            {command "Save as Template"       {File_Template} "Save as Template"      {}       -command { control::write_user_template } }
            {command "&Print"                 {File_Print}    "Print current Graphic" {Ctrl p} -command { gui_button print_canvas }     }
            {command "Create/&Update Config"  {File_Update}   "Update Config Panel"   {Ctrl u} -command { config::create $APPL_Env(CONFIG_Window); control::toggle_lock_attribute; config::update_cfg_values } }
            {separator}
            {command "&Debug Window"          {File_Debug}    "Open Debug Window"     {Ctrl d} -command { AppUtil::debug_create {RattleCAD Debug} } }
            {separator}
            {command "&Intro-Image"           {File_Intro}    "Show Intro Window"     {Ctrl i} -command { create_intro .intro}          }
            {separator}
            {command "clear config"           {CFG_Clear}     "cleanup config"        {}       -command { destroy  $APPL_Env(CONFIG_Notebook) }          }
            {command "fill config"            {CFG_Fill}      "fill config"           {}       -command { set       APPL_Env(CONFIG_Notebook) \
                                                                                                                       [config::create_config $APPL_Env(CONFIG_Window)] } }
            {separator}
            {command "E&xit"                  {File_Exit}     "Exit rattle_CAD"       {Ctrl x} -command { exit }                        }

        }
        "Settings"  all settings 0 {
            {command "Font "                  {Sett_Font}     "select Font"           {Ctrl f} -command { font_config_dialog }          }
            {cascad  "Language"               {Sett_Language} "manage language"          0 {
                   {radiobutton "English"     {Sett_English}  "select English"           {}    -command { gui_button switch_language english   } }
                   {radiobutton "Deutsch"     {Sett_Deutsch}  "wähle  Deutsch"           {}    -command { gui_button switch_language deutsch   } }
                   {radiobutton "... native"  {Sett_native}   "wähle  steirisch"         {}    -command { gui_button switch_language steirisch } }
            }}
            {cascad  "Settings storage"       {Sett_Template} "manage default settings"  0 {
                   {command "save"            {Sett_Save}     "save default Settings"    {}    -command { control::user_settings write }         }
                   {command "reset"           {Sett_Reset}    "reset default Settings"   {}    -command { control::user_settings reset }         }
            }}
            {command "Options"                {Options}       "Options"                  {}    -command { $APPL_Env(CONFIG_Notebook) raise [ $APPL_Env(CONFIG_Notebook) page 4] }           }
        }
        "Info"   all info 0 {
            {command "Info"                   {}              "Version-Information"      {}    -command { version_info::create  .v_info} }
        }
  }

  set   mainframe [MainFrame .mainframe  -menu $menu_bar ]
  pack $mainframe  -fill both  -expand yes  -side top 

  set  indicator  [$mainframe addindicator -textvariable "::APPL_Config(PROJECT_Name)"  -anchor w]
    # tk_messageBox -message "\$indicator  $mainframe\n\$menu_bar   $indicator"
  $indicator  configure -relief flat

    # tk_messageBox -message "\$indicator  $mainframe\n\$menu_bar   $indicator"
    # tk_messageBox -message "\$mainframe  $mainframe\n\$menu_bar   $menu_bar"

  set frame    [$mainframe getframe]

  
    #
    #
    #
    # ================================================================
    #
    #
    #

  set tb_frame [ frame $frame.f1  -relief sunken        -bd 2  ]
  set cv_frame [ frame $frame.f2  -width $CANVAS_MIN_X  -height $CANVAS_MIN_Y ]

  pack  $tb_frame  \
          -padx 3  -pady 3  -expand no   -fill x
  pack  $cv_frame  \
          -padx 0  -pady 0  -expand yes  -fill both
        
    # ================================
  set   SWITCH_Page  [ switch_page::create    $cv_frame sw_p 0 ]
  pack configure $SWITCH_Page  -padx 1 -pady 1
  
    # ================================
  set DESIGN_Frame   [ switch_page::add    $SWITCH_Page    f_design   ]
  set DETAIL_Frame   [ switch_page::add    $SWITCH_Page    f_detail   ]
  set DRAFTING_Frame [ switch_page::add    $SWITCH_Page    f_draft    ]
  
  
    # ================================
  set DESIGN_Frame_GRAPHIC    [ frame      $DESIGN_Frame.dsg    -padx 0 -pady 0 ]
  set DETAIL_Frame_GRAPHIC    [ frame      $DETAIL_Frame.dsg    -padx 0 -pady 0 ]
  set DRAFTING_Frame_GRAPHIC  [ frame      $DRAFTING_Frame.dsg  -padx 0 -pady 0 ]

  
    # ================================
  pack $DESIGN_Frame_GRAPHIC    -side left   -fill both  -expand yes
  pack $DETAIL_Frame_GRAPHIC    -side left   -fill both  -expand yes
  pack $DRAFTING_Frame_GRAPHIC  -side left   -fill both  -expand yes
  

    # ================================
  set design_widget         [ lib_canvas::create    $DESIGN_Frame_GRAPHIC     design     $CANVAS_MIN_X   $CANVAS_MIN_Y  no_scrollbar ]
  set detail_widget         [ lib_canvas::create    $DETAIL_Frame_GRAPHIC     detail     $CANVAS_MIN_X   $CANVAS_MIN_Y  no_scrollbar ]
  set draft_widget          [ lib_canvas::create    $DRAFTING_Frame_GRAPHIC   draft      $CANVAS_MIN_X   $CANVAS_MIN_Y ]
  
  set CANVAS_Widget(f_design)    $design_widget
  set CANVAS_Widget(f_detail)    $detail_widget
  set CANVAS_Widget(f_draft)     $draft_widget
    


    #
    #
    #
    # ================================================================
    #
    #
    #
    
  Button   $tb_frame.open     -image  $img_open     -command { control::openFile_Selection } \
                                             -helptext "open ..."
  Button   $tb_frame.save     -image  $img_save     -command { control::saveFile } \
                                             -helptext "save ..."
  Button   $tb_frame.clear    -image  $img_clear    -command { gui_button  clean_canvas} \
                                             -helptext "clear ..."
  Button   $tb_frame.print    -image  $img_print    -command { gui_button  print_canvas } \
                                             -helptext "print ..."
											 
  Button   $tb_frame.set_rd   -image  $img_reset_r  -command { control::template_to_design  Road    } \
                                             -helptext "load example road"
  Button   $tb_frame.set_mb   -image  $img_reset_o  -command { control::template_to_design  OffRoad } \
                                             -helptext "load example offroad"
  
  Button   $tb_frame.render   -image  $img_design   -command { control::switch_frame_display} \
                                             -helptext "Centerline/Outline/Preview ..."

  Button   $tb_frame.miter    -text   "tube-miter"  -command { tubemiter::start_tubemiter $APPL_Env(TUBEMITER_Window)} \
                                             -helptext "tube miter"
  Button   $tb_frame.scale_p  -image  $img_scale_p  -command { gui_button  scale_canvas  1.50 } \
                                             -helptext "scale plus"
  Button   $tb_frame.scale_m  -image  $img_scale_m  -command { gui_button  scale_canvas  0.67 } \
                                             -helptext "scale minus"
  Button   $tb_frame.resize   -image  $img_resize   -command { gui_button  resize_canvas } \
                                             -helptext "resize"
  
  Button  $tb_frame.exit     -image  $img_exit     -command { exit }
  
  label   $tb_frame.sp0      -text   " "
  label   $tb_frame.sp1      -text   " "
  label   $tb_frame.sp2      -text   " "
  label   $tb_frame.sp3      -text   " "
  label   $tb_frame.sp4      -text   " "
  label   $tb_frame.sp5      -text   " "
  
  
  pack    $tb_frame.open     $tb_frame.save     $tb_frame.clear    $tb_frame.print    $tb_frame.sp0  \
          $tb_frame.set_rd   $tb_frame.set_mb   $tb_frame.sp2  \
          $tb_frame.render   $tb_frame.sp3  \
        -side left -fill y
          # $tb_frame.recent   
          
  pack    $tb_frame.exit   $tb_frame.sp4  \
          $tb_frame.resize $tb_frame.scale_p $tb_frame.scale_m  $tb_frame.sp5  \
          $tb_frame.miter  \
        -side right 
    
    #
    #
    #
    # ================================================================
    #
    #      define size of Window
    #
    
  update
  switch_page::resize     $SWITCH_Page
  update
  
  wm minsize . [winfo width  .]   [winfo height  .]
 
    # -- show design-canvas -------
  set_w_geometry . $APPL_Config(Window_Position)
      # update  
      # tk_messageBox -message "schau amol ! "
  

    #
    #
    #
    # ================================================================
    #
    #      bindings
    #
    
  
    # -- show design-canvas -------
  switch_page::showframe   $::DESIGN_Frame
 
    # -- fill design-canvas with template -------------
  control::init
  control::check_init_values
  control::update_parameter  {force}
  control::switch_canvas     {config}
  

    # -- window title -------------
  set_window_title template


    # -- create config-window -----
  set APPL_Env(CONFIG_Notebook)  [config::create  $APPL_Env(CONFIG_Window)]


    # -- update config-values -----
  control::toggle_lock_attribute new_file 
  control::format_project_values
  config::update_cfg_values 


    # -- bindings ---------------
  bind . <Configure>   config::bind_move
  bind $APPL_Env(CONFIG_Window)    <Control-r>   { gui_button  reposit_config }
  bind $APPL_Env(CONFIG_Window)    <Alt-s>       { gui_button  switch_language steirisch }
  
  lib_canvas::mouse_bindings   $design_widget  design::design_scale
  lib_canvas::mouse_bindings   $detail_widget  
  lib_canvas::mouse_bindings   $draft_widget

  
    # -- create recent files combobox---
  create_file_list 
  
  
    # -- destroy intro - image ----
  after  300 destroy .intro
