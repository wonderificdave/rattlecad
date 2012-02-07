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
		
		# -- APPL_Env(BASE_Dir)  ------
	set BASE_Dir  [file dirname [file normalize $::argv0] ]
 
		# -- redefine on Starkit  -----
		# 		exception for starkit compilation
		#   	 .../rattleCAD.exe
	set APPL_Type       [file tail $BASE_Dir]	
	if {$APPL_Type == {rattleCAD.exe}}	{	
		set BASE_Dir	[file dirname $BASE_Dir]
						}



		# -- Libraries  ---------------
	lappend auto_path           [file join $BASE_Dir lib]
	
	package require   rattleCAD  3.2 
	package require   canvasCAD	 0.11
	package require	  extSummary 0.1


	# -- Version Info  ----------------------
    if {[file exists [file join $APPL_Env(ROOT_Dir) tclkit.inf]]} {
		# puts " customizing strings in executable"
		set fd [open [file join $APPL_Env(ROOT_Dir) tclkit.inf]]
		array set strinfo [read $fd]
		close $fd
	} else {
		array set strinfo {
				ProductVersion	{3.2}
				FileVersion  	{??}
				FileDate		{??. ???. 201?}
		}
	}
	# parray strinfo
	
 	set APPL_Env(RELEASE_Version)	$strinfo(ProductVersion) 	;#{3.2}
	set APPL_Env(RELEASE_Revision)	$strinfo(FileVersion) 		;#{66}
	set APPL_Env(RELEASE_Date)		$strinfo(FileDate)			;#{18. Dec. 2011}
	
 		# -- Application Directories  -----------
	set APPL_Env(BASE_Dir)    	$BASE_Dir
	set APPL_Env(CONFIG_Dir)    [file join    $BASE_Dir etc   ]
	set APPL_Env(IMAGE_Dir)     [file join    $BASE_Dir image ]
	set APPL_Env(ROOT_Dir)      [file dirname $BASE_Dir]
	set APPL_Env(USER_Dir)      [lib_file::check_user_dir user]	
	set APPL_Env(EXPORT_Dir) 	[lib_file::check_user_dir export]


		# -- Version Info Summary  ---------------
 		puts "  ----------------------------------------------"
		puts "  rattleCAD      $APPL_Env(RELEASE_Version).$APPL_Env(RELEASE_Revision)"
		puts "                             $APPL_Env(RELEASE_Date)"
 		puts "  ----------------------------------------------"


		# -- Tcl/Tk Runtime  --------------------
		puts "  Tcl/Tk:    [info patchlevel]"
		puts "  Exec:      [info nameofexecutable]"
 		puts "  ----------------------------------------------"
		puts "    Tk:          [package require Tk]"
		puts "    BWidget:     [package require BWidget]"
		puts "    tdom:        [package require tdom]"
		puts "    rattleCAD:   [package require rattleCAD]"
		puts "    canvasCAD:   [package require canvasCAD]"
		puts "    extSummary:  [package require extSummary]"
 		puts "  ----------------------------------------------"
 		puts "    APPL_Env(ROOT_Dir)   $APPL_Env(ROOT_Dir)"
 		puts "    APPL_Env(BASE_Dir)   $APPL_Env(BASE_Dir)"
		puts "    APPL_Env(CONFIG_Dir) $APPL_Env(CONFIG_Dir)"
		puts "    APPL_Env(IMAGE_Dir)  $APPL_Env(IMAGE_Dir)"
		puts "    APPL_Env(USER_Dir)   $APPL_Env(USER_Dir)"
		puts "    APPL_Env(EXPORT_Dir) $APPL_Env(EXPORT_Dir)"
 		puts "  ----------------------------------------------"
		puts ""

  
  ###########################################################################
  #
  #                 I  -  N  -  I  -  T                       - Configuration
  #
  ###########################################################################


		# -- init Parameters  ----
	set APPL_Env(root_InitDOM)  [ lib_file::openFile_xml 	[file join $APPL_Env(CONFIG_Dir) rattleCAD_init.xml ] ]
		puts "     ... root_InitDOM      [file join $APPL_Env(CONFIG_Dir) rattleCAD_init.xml]"


	initValues
		
		
		# -- load template ----------
		puts "     ... TemplateType      $APPL_Env(TemplateType)"
		puts "     ... TemplateInit      $APPL_Env(TemplateInit)"
		
	
	set APPL_Env(root_ProjectDOM)	[ lib_file::openFile_xml 	$APPL_Env(TemplateInit) ]

	
		# -- status messages --------
	puts "\n     APPL_Env(list_ForkTypes)"
	foreach entry $APPL_Env(list_ForkTypes) {
		puts "        -> $entry"
	}

	puts "\n     APPL_Env(list_BrakeTypes)"
	foreach entry $APPL_Env(list_BrakeTypes) {
		puts "        -> $entry"
	}
	
	puts "\n     APPL_Env(list_BottleCage)"
	foreach entry $APPL_Env(list_BottleCage) {
		puts "        -> $entry"
	}
	
	puts "\n     APPL_Env(list_Rims)"
	foreach entry $APPL_Env(list_Rims) {
		puts "        -> $entry"
	}
	
	puts "\n  APPL_CompLocation"
	foreach index [array names APPL_CompLocation] {
		puts [format "        -> %-42s %s" $index    $APPL_CompLocation($index)]
	} 
	



  ###########################################################################
  #
  #                 S  -  T  -  Y  -  L  -  E 
  #
  ###########################################################################

	# ttk::style configure TCombobox -padding 0
	# ttk::style theme use default
	ttk::style configure TCombobox -padding 0
    # -- set standard font ------------
	option add *font $APPL_Config(GUI_Font)
	
  
  ###########################################################################
  #
  #                 M  -  A  -  I  -  N 
  #
  ###########################################################################

		puts "\n\n ====== M A I N ============================ \n\n"




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


	
		# --- 	create iconBitmap  -----
	wm iconbitmap . [file join $APPL_Env(BASE_Dir) tclkit.ico]  
  
  
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
	frame_geometry::set_base_Parameters $APPL_Env(root_ProjectDOM)


		# --------------------------------------------
		#	set APPL_Config(PROJECT_Name)		
	set APPL_Config(PROJECT_Name)           "Template $APPL_Env(TemplateType)"


		# --------------------------------------------
		#    check startup parameters
	if {$argc == 1} {
		set startupProject  [lindex $argv 0]
		puts "\n"
		puts " ====== startup   F I L E ========================"
		puts "        ... [file normalize $startupProject]\n"
		lib_file::openProject_xml [file tail $startupProject] $startupProject	
	}
	


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

	