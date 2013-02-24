  #
  # (c) by Manfred ROSENBERGER
  #          Nestelbach 155/3
  #          8262 Ilz - AUSTRIA
  #
  #
  
  
  package provide rattleCAD  3.1

    # -- AppUtil  ---------------
  namespace import AppUtil::SetConfig \
                   AppUtil::GetConfig \
                   AppUtil::DelConfig \
                   AppUtil::SetDebugLevel \
                   AppUtil::Debug 

                   
    # -- default Parameters  ----
  # source  [file join $APPL_Env(CONFIG_Dir) init_parameters.tcl]   
  
    
    
  ###########################################################################
  #
  #         F  -  U  -  N  -  C  -  T  -  I  -  O  -  N  -  S 
  #
  ###########################################################################


	proc debug_out { msg {args 0} } {
		Debug t $msg $args
	}


	#-------------------------------------------------------------------------
       #  startup intro image
       #
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

			canvas $w.cv	-width  $start_image_w \
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
      
			$w.cv create text  [expr $x+ 85]  [expr $y+155]  -font "Swiss 18"  -text "Version"			      -fill white
			$w.cv create text  [expr $x+155]  [expr $y+155]  -font "Swiss 18"  -text "$APPL_Env(RELEASE_Version)."  -fill white 
			$w.cv create text  [expr $x+195]  [expr $y+156]  -font "Swiss 14"  -text "$APPL_Env(RELEASE_Revision)"  -fill white 
      
				;# --- beautify --- but i dont know the reason, why to center manually
			$w.cv move   all   1 1			
			return $w.cv
		}


		if { $type != "toplevel" } {        
			return [intro_content $w $cv_border]
		}

		toplevel $w  -bd 0

		wm withdraw		   $w  
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


	#-------------------------------------------------------------------------
       #  load settings from etc/config_initValues.xml
       #
	proc initValues {xmlFile} {
		
		set root	[ lib_file::openFile_xml $xmlFile ]
		
			# fill ICON - Array
		foreach child [ [$root selectNodes /values/images] childNodes] {			
			  # puts [ $child asXML ]
			set name	[ $child getAttribute {name} ]
			set source	[ $child getAttribute {src} ]
			  # puts "   $name  $source"
			set lib_gui::iconArray($name) [ image create photo -file $::APPL_Env(IMAGE_Dir)/$source ]
		}
		
			# fill CANVAS - Array
		set node	[ $root selectNodes /values/geometry/canvas ]
			set lib_gui::canvasGeometry(width) 	[ $node getAttribute {width} ]
			set lib_gui::canvasGeometry(height)	[ $node getAttribute {height} ]	
	}

	
	#-------------------------------------------------------------------------
       #  set Window Title
       #
	proc set_window_title { {filename {}} } {
      
      Debug  p
      
      global APPL_Config APPL_Env
      
      set  prj_name  [file tail $filename]

      set  APPL_Config(WINDOW_Title)  "rattleCAD  $APPL_Env(RELEASE_Version).$APPL_Env(RELEASE_Revision) - $prj_name"
      set  APPL_Config(PROJECT_Name)  "$filename"
      Debug  t  "   $filename " 1
      
      wm title . $APPL_Config(WINDOW_Title)
	}






 

