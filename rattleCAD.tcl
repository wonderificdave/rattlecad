#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"


 ##+##########################################################################
 #
 # rattleCAD.tcl
 #
 #   rattleCAD is software of Manfred ROSENBERGER
 #       based on tclTk and BWidgets and their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2010/10/24
 #
 # The author  hereby grant permission to use,  copy, modify, distribute,
 # and  license this  software  and its  documentation  for any  purpose,
 # provided that  existing copyright notices  are retained in  all copies
 # and that  this notice  is included verbatim  in any  distributions. No
 # written agreement, license, or royalty  fee is required for any of the
 # authorized uses.  Modifications to this software may be copyrighted by
 # their authors and need not  follow the licensing terms described here,
 # provided that the new terms are clearly indicated on the first page of
 # each file where they apply.
 #
 # IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
 # FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
 # ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
 # DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
 # POSSIBILITY OF SUCH DAMAGE.
 #
 # THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
 # INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
 # MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
 # NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN "AS  IS" BASIS,
 # AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
 # MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 #
 

  ###########################################################################
  #
  #                 I  -  N  -  I  -  T                        -  Application
  #
  ###########################################################################

		puts "\n\n ====== I N I T ============================ \n\n"
		
		
		# -- Varirables  --------------
	set 	  APPL_Update		0 
	set		  APPL_Project		{}
	set		  APPL_Init			{}
	set		  APPL_ForkTypes	{}
	set		  APPL_BrakeTypes	{}
	set		  APPL_Binary_OnOff	{}
	set		  APPL_RimList		{}
	array set APPL_CompLocation {}
	
	
	variable  APPL_Env
	variable  APPL_Config

	array set APPL_Env { 
						RELEASE_Version		{3.2}  
						RELEASE_Revision	{54}  
						RELEASE_Date		{19. Aug. 2011}
						BASE_Dir			{}
						ROOT_Dir			{}
						CONFIG_Dir			{}
						IMAGE_Dir			{}
						USER_Dir			{}
						EXPORT_Dir			{}
						USER_InitString		{_init_Template}
                     }	
					 
					 
		# -- APPL_Env(BASE_Dir)  ------
	set APPL_Env(BASE_Dir)  [file dirname [file normalize $::argv0] ]
 
 
		# -- redefine on Starkit  -----
		# 		exception for starkit compilation
		#   	 .../rattleCAD.exe
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

	
		# -- APPL_Env(ROOT_Dir)  ------
	set APPL_Env(ROOT_Dir)      [file dirname $APPL_Env(BASE_Dir)       ]

		puts "  \$APPL_Env(BASE_Dir)      $APPL_Env(BASE_Dir)"
		puts "  \$APPL_Env(CONFIG_Dir)    $APPL_Env(CONFIG_Dir)"
		puts "  \$APPL_Env(IMAGE_Dir)     $APPL_Env(IMAGE_Dir)"
		puts ""

		# -- Libraries  ---------------
	lappend auto_path           [file join $APPL_Env(BASE_Dir) lib]
	
	package require   Tk		 8.5
	package require   BWidget 	    
	package require   rattleCAD  3.2 
	package require   canvasCAD	 0.8
	package require	  extSummary 0.1

    	
		# -- default Parameters  ------
		set XML "<root> empty </root>"
		set emptyDOM  [dom parse $XML]
	set APPL_Project [$emptyDOM documentElement]
  

  ###########################################################################
  #
  #                 I  -  N  -  I  -  T                       - Configuration
  #
  ###########################################################################


		# -- APPL_Env(USER_Dir)  ------
	set APPL_Env(USER_Dir)      [lib_file::check_user_dir user]	

		puts "  \$APPL_Env(USER_Dir)      $APPL_Env(USER_Dir)"
		puts ""


		# -- default Parameters  ----
	set APPL_Init  [ lib_file::openFile_xml 	[file join $APPL_Env(CONFIG_Dir) rattleCAD_init.xml ] ]
		puts "     ... APPL_Init         [file join $APPL_Env(CONFIG_Dir) rattleCAD_init.xml]"
	
	initValues
		
		
		# -- load template ----------
		puts ""
		puts "     ... APPL_Env(TemplateType)      $APPL_Env(TemplateType)"
		puts "     ... APPL_Env(TemplateInit)      $APPL_Env(TemplateInit)"
		
	set APPL_Project  [ lib_file::openFile_xml 	$APPL_Env(TemplateInit) ]

	
		# -- status messages --------
	puts "\n  APPL_ForkTypes"
	foreach entry $APPL_ForkTypes {
		puts "        -> $entry"
	}

	puts "\n  APPL_BrakeTypes"
	foreach entry $APPL_BrakeTypes {
		puts "        -> $entry"
	}
	
	puts "\n  APPL_BottleCage"
	foreach entry $APPL_BottleCage {
		puts "        -> $entry"
	}
	
	

	puts "\n  APPL_RimList"
	foreach entry $APPL_RimList {
		puts "        -> $entry"
	}
	
	puts "\n  APPL_CompLocation"
	foreach index [array names APPL_CompLocation] {
		puts [format "        -> %-25s %s" $index    $APPL_CompLocation($index)]
	} 
	
	array set APPL_Config { 
						GUI_Font			{Arial 8}
						VECTOR_Font			{}
						Language			{english}
						PROJECT_Name		{}
						WINDOW_Title		{}
						FILE_List			{}
                     }



  ###########################################################################
  #
  #                 S  -  T  -  Y  -  L  -  E 
  #
  ###########################################################################

	# ttk::style configure TCombobox -padding 0
	# ttk::style theme use default
	ttk::style configure TCombobox -padding 0
	
  
  ###########################################################################
  #
  #                 M  -  A  -  I  -  N 
  #
  ###########################################################################

		puts "\n\n ====== M A I N ============================ \n\n"



    # -- initialize user - settings 
  set APPL_Env(USER_Dir) 	[lib_file::check_user_dir user]
  set APPL_Env(EXPORT_Dir) 	[lib_file::check_user_dir export]

 
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
		#	create custom base Parameters
	frame_geometry::set_base_Parameters $APPL_Project
	
		# --------------------------------------------
		#	set APPL_Config(PROJECT_Name)		
	set APPL_Config(PROJECT_Name)           "Template $APPL_Env(TemplateType)"


 		# --------------------------------------------
		#    finalize
   
	update 
	wm minsize . [winfo width  .]   [winfo height  .]
 
		# -- open config panel -----------------------
	# lib_config::create . .cfg	

		# -- window title ----------------------------
	set_window_title 				$APPL_Config(PROJECT_Name)

	
  ###########################################################################
  #
  #                 R  -  U  -  N  -  T  -  I  -  M  -  E 
  #
  ###########################################################################

		puts "\n\n ====== R U N T I M E ============================ \n\n"
		
		
		# -- destroy intro - image ----
	after  200 destroy .intro

		# -- keep on top --------------
	wm deiconify .
	