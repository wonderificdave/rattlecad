  #
  # (c) by Manfred ROSENBERGER
  #          Nestelbach 155/3
  #          8262 Ilz - AUSTRIA
  #
  #
  
  
  package provide rattle_cad  2.8

    # -- AppUtil  ---------------
  namespace import AppUtil::SetConfig \
                   AppUtil::GetConfig \
                   AppUtil::DelConfig \
                   AppUtil::SetDebugLevel \
                   AppUtil::Debug 

                   
    # -- default Parameters  ----
  source  [file join $APPL_Env(CONFIG_Dir) init_parameters.tcl]   
  
    
    
  ###########################################################################
  #
  #         F  -  U  -  N  -  C  -  T  -  I  -  O  -  N  -  S 
  #
  ###########################################################################


  proc debug_out { msg {args 0} } {
      Debug t $msg $args
  }
  
  
  proc create_intro {w {type toplevel} {cv_border 0} } {

      Debug  p

      global APPL_Env
      
      ::Debug  t "   \$APPL_Env(IMAGE_Dir)  $APPL_Env(IMAGE_Dir)"

      
      proc intro_content {w cv_border} {

          Debug  p
      
          global APPL_Env

          set start_image     [image create  photo  -file $::APPL_Env(IMAGE_Dir)/start_image.gif ]
          set  start_image_w  [image width   $start_image]
          set  start_image_h  [image height  $start_image]
      
          ::Debug  t "   \$start_image  $start_image  $start_image_w  $start_image_h "

          canvas $w.cv   -width  $start_image_w \
                         -height $start_image_h \
                         -bd     $cv_border \
                         -relief sunken \
                         -bg     gray 
                     
          pack   $w.cv   -fill both  -expand yes
      
          $w.cv create image  [expr 0.5*$start_image_w] \
                              [expr 0.5*$start_image_h] \
                         -image $start_image
          
          set x [expr 0.5*$start_image_w]
          set y [expr 0.5*$start_image_h]
      
          $w.cv create text  [expr $x+ 85]  [expr $y+155]  -font "Swiss 18"  -text "Version"                -fill white
          $w.cv create text  [expr $x+155]  [expr $y+155]  -font "Swiss 18"  -text "$APPL_Env(RELEASE_Version)"     -fill white 
          $w.cv create text  [expr $x+200]  [expr $y+156]  -font "Swiss 14"  -text "  $APPL_Env(RELEASE_Revision)"  -fill white 
      
            ;# --- beautify --- but i dont know the reason, why to center manually
          $w.cv move   all   1 1
          
          return $w.cv

      }


      if { $type != "toplevel" } {        
          return [intro_content $w $cv_border]
      }


      toplevel $w  -bd 0

      wm withdraw         $w  
      wm overrideredirect $w 1
      switch $::tcl_platform(platform) {
         "windows" { wm attributes  $w -topmost 1 }
      }

      intro_content $w $cv_border
      
      BWidget::place $w 0 0 center
      wm deiconify $w
      
      bind $w  <ButtonPress> { destroy .intro }

      return
  }


  proc gui_button {button args} {
  
      Debug  p
      Debug  t  "$args" 
      
      global  _CURRENT_Project APPL_Env \
              SWITCH_Page CANVAS_Widget START_Frame \
              DESIGN_Frame  DETAIL_Frame  DRAFTING_Frame  COMPLETE_Frame\
              design_widget detail_widget draft_widget preview_widget CONFIG_Geometry

      set w       [get_canvas_path current] 
      set w_name  [winfo name $w]
      
      Debug  t  "$w / $w_name" 
      
      switch $button {
      

          clean_canvas 
                  { Debug  t  "switch $button"
                    lib_canvas::delete_all 
                  }
      
          print_canvas 
                  { Debug  t  "switch $button"
      
                    switch $w_name {
                        design    { design::print_postscript    $design_widget }  
                        draft     { drafting::print_postscript  $draft_widget }  
                        preview   { preview::print_postscript   $preview_widget }  
                        default  {}
                    }
                  }
  
          iconify_config_window 
                  { Debug  t  "switch $button"
                    if {[winfo exists $APPL_Env(CONFIG_Window)]} {
                       wm  withdraw   $APPL_Env(CONFIG_Window)
                    }
                  }

          switch_language 
                  { Debug  t  "switch $button $args"
      
                    if {[llength $args]} { set lang [lindex $args 0] } else { return }
      
                    update_language $lang
                    # control::update_language
                    return
                  }

          scale_canvas 
                  { Debug  t  "switch $button"
                    
                    set scale 1
                    if {[llength $args]} { set scale [lindex $args 0] }
      
                    switch $w_name {
                       design    { lib_canvas::scale  $w  $scale 
                                   design::design_scale   $scale }
                       detail    { lib_canvas::scale  $w  $scale }
                       draft     { lib_canvas::scale  $w  $scale }
                       preview   { lib_canvas::scale  $w  $scale }
                    }
                  }

          resize_canvas       
                  { Debug  t  "switch $button"
      
                    switch $w_name {
                       design    { design::resize     $design_widget }   
                       detail    { detail::resize     $detail_widget }   
                       draft     { drafting::resize   $draft_widget  }   
                       preview   { preview::resize    $preview_widget  }   
                    }
                  }

          default {
                    tk_messageBox -message "gui_button - $button "
                    Debug  t  "\$button  $button" 
                    Debug  t  "\$args    $args" 
                  }
      }
  
  }
  
  
  
  proc set_window_title { {filename {}} } {
      
      Debug  p
      
      global APPL_Config APPL_Env
      
      set  prj_name  [file tail $filename]

      set  APPL_Config(WINDOW_Title)  "rattleCAD  $APPL_Env(RELEASE_Version).$APPL_Env(RELEASE_Revision) - $prj_name"
      set  APPL_Config(PROJECT_Name)  "$filename"
      Debug  t  "   $filename " 1
      
      wm title . $APPL_Config(WINDOW_Title)
  }
  
  
  
  proc update_language { language } {

      Debug  p
      
      global Language
      
      set language  [string trim [array names Language  [format "____%s" $language] ] {_}]
       
      if { $language == {} } {
           set language english
      }
       
      set Language(____current)  [format "____%s" $language]

      foreach item $Language($Language(____current)) \
        {
          set key_word [lindex $item 0]
          set value    [lindex $item 1]
          set Language($key_word) $value
        }
  }


  
  proc get_canvas_path {{index current}} {
      
      Debug  p
        
      global CANVAS_Widget SWITCH_Page
      set    CANVAS_Widget(current)  $CANVAS_Widget([winfo name $switch_page::switch_page(current)])
        Debug  t  "$CANVAS_Widget(current)" 1
      return $CANVAS_Widget(current)
  }


  
  proc get_w_geometry {window} {

      Debug  p
        
      set geometry [split [wm geometry $window]  +x] 
      set vector [lrange $geometry 2 end]
      lappend vector [expr [lindex $geometry 0]+[lindex $geometry 2] ]  \
		     [expr [lindex $geometry 1]+[lindex $geometry 3] ] 
      return  $vector
  }


  
  proc set_w_geometry {window vector} {

	  foreach     { px00  py00  px01  py01}   $vector  break
	  
	  set size_x  [expr $px01 - $px00]
	  set size_y  [expr $py01 - $py00]
	  
	      # tk_messageBox -message "  -> $cx00     $cy00     $cx01     $cy01  / $px00     $py00     $px01     $py01 "
	      # 200x200+654+54
		 
	      # tk_messageBox -message "  -> [format "%dx%d+%d+%d" $px01  $py01  $px00  $py00] "
	  	  # return
	  wm geometry $window [format "%dx%d+%d+%d" $size_x  $size_y  $px00  $py00]	 
   }
  
  
  
  proc start_psview {ps_file} {
        
      Debug  p
      
      Debug  t  "tcl_version   [info tclversion]" 
      Debug  t  "tcl_platform  $::tcl_platform(platform)" 
      Debug  t  "ps_file       $ps_file" 
                         
      set postsript_ext   [file extension $ps_file]
  
      Debug  t  "postsript_ext $postsript_ext" 

      switch $::tcl_platform(platform) {
         "windows" {
                   package require registry 1.1

                   set reg_fileext [registry keys  {HKEY_CLASSES_ROOT} $postsript_ext]
                     Debug  t  "reg_fileext   $reg_fileext" 
                     
                     # there the file-extension is not defined
                   if {$reg_fileext == {} } {
                       set error_message "File Type: $reg_fileext"
                       set error_message "$error_message \n  could not find a OPEN command for filetype"
                         tk_messageBox -message "$error_message"
                       Debug  t  " <E> File Type: $reg_fileext" 
                       Debug  t  " <E> could not find a OPEN command for filetype" 
                       return
                   }
          
                     # get the filetype 
                   set reg_filetype [registry get HKEY_CLASSES_ROOT\\$reg_fileext {}]
                     Debug  t  "reg_filetype  $reg_filetype" 
                   
                     # Work out where to look for the command
                   set path HKEY_CLASSES_ROOT\\$reg_filetype\\Shell\\Open\\command
                     Debug  t  "path          $path" 
                   
                     # Read the command!
                   set print_app [registry get $path {}]
                      Debug  t  "Filetype $postsript_ext opens with $print_app" 
                     
                     
                     # there is no command defined for the filetype
                   if {$print_app == {} } {
                       set error_message "File Type: $reg_fileext"
                       set error_message "$error_message \n  could not find a OPEN command for filetype"
                         tk_messageBox -message "$error_message"
                       Debug  t  " <E> File Type: $reg_fileext" 
                       Debug  t  " <E> could not find a OPEN command for filetype" 
                       return
                   }
                   
                   
                     # Just the command!
                   set print_app [lindex [split $print_app \"] 1]
                     
                   #   Run the command!
                   Debug  t  "$print_app  $ps_file"                    
                   exec $print_app $ps_file &
                     
                     # finish!
                     Debug  t  "$print_app  $ps_file done"  
                   return
               }
         default {
                   Debug  t  "sorry"  
                   Debug  t  "  there is currently no direct connection "
                   Debug  t  "  to the printer for this platform yet"  
               }
      }
      return
  }

  

  proc font_config_dialog {} {
      global APPL_Config 
      
      Debug  p
      
      if { $APPL_Config(GUI_Font) != "" } { 
          set font [SelectFont .fontdlg -parent . -font $APPL_Config(GUI_Font)] 
      } else {
          set font [SelectFont .fontdlg -parent . ] 
      }
      
      if { $font != "" } {
           set APPL_Config(GUI_Font) $font
           update_font $font
      }

      config::resize
      
      return
  }


  
  proc update_font { font {top {.}}} {
      Debug  p
      
      proc casc_update_font { {top {.}} font {rec {0}} } {
           # http://wiki.tcl.tk/15507
           ::Debug  p 

           set children [winfo children $top]

           foreach child $children {
             ::Debug t "$child / [winfo class $child] "
             if { ! [ catch {$child cget -font} ] } {
                 $child configure -font $font
             }
             casc_update_font $child $font 1
           }
      }
      
      . configure -cursor watch
      
      casc_update_font  $top  $font
      
      . configure -cursor ""
      
      return
  }



  proc create_file_list {} {

       global APPL_Env
	   
	   ::Debug  p  1

       ::Debug  t  "  try to create __file_list"
	   
       set toplevel_widget  $APPL_Env(FILE_List)
      
       if {[winfo exists $toplevel_widget]} {
           return
       }
       
	   toplevel  $toplevel_widget 

       frame     $toplevel_widget.f -bd 2
       pack      $toplevel_widget.f
	   
			  # listbox   $toplevel_widget.f.lbox \
		      #                    -listvariable   control::FILE_List \
		      #                    -selectmode     single \
		      #                    -relief         sunken \
		      #		               -width          50 \
		      #                    -yscrollcommand "$toplevel_widget.f.svert  set" 
		      #
		      # scrollbar $toplevel_widget.f.svert \
		      #                    -orient         v \
		      #                    -command        "$toplevel_widget.f.lbox yview"
      
	        # $toplevel_widget.f.lbox 
	        # $toplevel_widget.f.svert 
	   
	   
	   set control::FILE_List_Widget  [ComboBox  $toplevel_widget.f.cbox \
	                      -values $control::FILE_List \
						  -width  35 \
						  -height  5 \
						  -modifycmd "control::openFile_FileList"]
						  
       pack $toplevel_widget.f.cbox \
			              -side left -fill both
	   
	   wm  minsize    $toplevel_widget   [winfo width  $toplevel_widget]   [winfo height  $toplevel_widget]
	   wm  transient  $toplevel_widget   .
	   wm  resizable  $toplevel_widget   0 1
	   wm  title      $toplevel_widget   "File - List"

	     # $toplevel_widget.f.cbox  setvalue  first 
	   
	   set parent_geometry [ get_w_geometry .]
	   set  parent_x  [expr 15 + [lindex $parent_geometry 0] ]
	   set  parent_y  [expr 95 + [lindex $parent_geometry 1] ]
	   
	   update
	   set  size_x  [ winfo width  $toplevel_widget]
	   set  size_y  [ winfo height $toplevel_widget]

	      # 200x200+654+54
	   wm geometry $toplevel_widget [format "%dx%d+%d+%d" $size_x  $size_y  $parent_x  $parent_y]	 
	    
  }
 



 

