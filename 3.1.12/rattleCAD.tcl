#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"


##+##########################################################################
#
# rattleCAD.tcl
# by Manfred ROSENBERGER
#
#   (c) Manfred ROSENBERGER 2008/07/02
#
#   rattleCAD is software of Manfred ROSENBERGER
#       based on tclTk and BWidgets and their 
#       own Licenses.
# 
#
# 

	set 	  APPL_Update		0
 
	variable  APPL_Env
	variable  APPL_Config
	variable  APPL_Project
	
	array set APPL_Env { 
						RELEASE_Version    {3.1}  
						RELEASE_Revision   {12}  
						RELEASE_Date       {17. Okt. 2010}  
						BASE_Dir           {}
						ROOT_Dir           {}
						CONFIG_Dir         {}
						IMAGE_Dir          {}
						VECTOR_Font        {}
						USER_Dir           {}
						USER_Init          {}
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
		#    .../rattleCAD.exe
	set APPL_Type           [file tail $APPL_Env(BASE_Dir)]
	switch $APPL_Type {
		rattleCAD.exe	{	set APPL_Env(CONFIG_Dir)    [file join    $APPL_Env(BASE_Dir) etc   ]
							set APPL_Env(IMAGE_Dir)     [file join    $APPL_Env(BASE_Dir) image ]
							set APPL_Env(BASE_Dir)      [file dirname $APPL_Env(BASE_Dir)       ] 
						}
		default			{ 	set APPL_Env(CONFIG_Dir)    [file join    $APPL_Env(BASE_Dir) etc   ]
							set APPL_Env(IMAGE_Dir)     [file join    $APPL_Env(BASE_Dir) image ]
						}
	}
  
	set APPL_Env(ROOT_Dir)      [file dirname $APPL_Env(BASE_Dir)       ]

		puts "  \$APPL_Env(BASE_Dir)      $APPL_Env(BASE_Dir)"
		puts "  \$APPL_Env(CONFIG_Dir)    $APPL_Env(CONFIG_Dir)"
		puts "  \$APPL_Env(IMAGE_Dir)     $APPL_Env(IMAGE_Dir)"
		puts "  ------------- "



	lappend auto_path           [file join $APPL_Env(BASE_Dir) lib]
	
	package require   Tk		8.5
	package require   BWidget 	    
	package require   rattleCAD 3.1 
	package require   AppUtil	0.8
	package require   canvasCAD	0.6
    
		puts "  -> $APPL_Env(VECTOR_Font)  "

 
 


	# -- AppUtil  ---------------
	SetDebugLevel 20

    # -- default Parameters  ----
		set XML "<root> empty </root>"
		set emptyDOM  [dom parse $XML]
	set APPL_Project [$emptyDOM documentElement]
  

  ###########################################################################
  #
  #                 M  -  A  -  I  -  N 
  #
  ###########################################################################


    # -- default Parameters  ----
	initValues			$APPL_Env(CONFIG_Dir)/config_initValues.xml
	set APPL_Project  [ lib_file::openFile_xml 	$APPL_Env(CONFIG_Dir)/template_project_20100924.xml ]

	
	
	# -- CONST_PI ---------------
		# set CONST_PI            $mathematic::CONST_PI

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
  set APPL_Env(USER_Dir) [lib_file::check_user_dir]
  # control::user_settings $APPL_Env(USER_Dir)
  
  
    # -- Language  --------------------
  # update_language  $APPL_Config(Language)

    # -- set standard font ------------
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


 		# --- 	create Mainframe  -----
	set	mainframe	[ lib_gui::create_MainFrame ]
		pack $mainframe  -fill both  -expand yes  -side top 
	set	indicator	[$mainframe addindicator -textvariable "::APPL_Config(PROJECT_Name)"  -anchor w]
		$indicator  configure -relief flat
	set frame		[$mainframe getframe]


		# --- 	Button-bar frame  --------
	set bb_frame [ frame $frame.f1  -relief sunken        -bd 1  ]
		pack  $bb_frame  -padx 0  -pady 3  -expand no   -fill x
	lib_gui::create_ButtonBar $bb_frame 

	
		# --- 	notebook frame  -------
	set nb_frame [ frame $frame.f2  -relief sunken        -bd 1  ]
		pack  $nb_frame  -padx 0  -pady 0  -expand yes  -fill both
        
		# --- 	notebook  -------------
    lib_gui::create_Notebook $nb_frame

	
	
		# --------------------------------------------
		#	create reference base Parameters
	frame_geometry_reference::set_base_Parameters $APPL_Project
		# --------------------------------------------
		#	create custom base Parameters
	frame_geometry_custom::set_base_Parameters $APPL_Project
		# --------------------------------------------
		#	set APPL_Config(PROJECT_Name)		
	set APPL_Config(PROJECT_Name)	template


 		# --------------------------------------------
		#    finalize
   
	update 
	wm minsize . [winfo width  .]   [winfo height  .]
 
		# -- window title -------------
	set_window_title 				template

		# -- destroy intro - image ----
	after  300 destroy .intro
