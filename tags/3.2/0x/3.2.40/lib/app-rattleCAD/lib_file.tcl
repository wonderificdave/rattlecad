 ##+##########################################################################
 #
 # package: rattleCAD	->	lib_file.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their 
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
 # ---------------------------------------------------------------------------
 #	namespace:  rattleCAD::lib_file
 # ---------------------------------------------------------------------------
 #
 # 

 namespace eval lib_file {

   
	#-------------------------------------------------------------------------
		#  open File Selection
		#
	proc openFile_Selection {{mode default}} {
        
			  variable CURRENT_Config 
			  variable USER_Dir     
			  variable current_filename
			  variable filetypes
		   
			check_user_dir user

			while {true} {
				set fileName [tk_getOpenFile  -initialdir $USER_Dir  -filetypes  $filetypes ] 
				if {[string length $fileName] == 0} {
					break
				} elseif {[file exists $fileName] && [file readable $fileName]} {
					
					control::openFile $fileName
					control::update_filelist $fileName
					
					set current_filename      $fileName
				  
						puts  "File: $current_filename"  
					return
				} else {
					tk_messageBox -icon error -title "Read ERROR" \
					  -message "File «$fileName» is not readable"
					puts  "File «$fileName» is not readable"  
				}
			}
   
	}


	#-------------------------------------------------------------------------
		#  open File by name
		#
	proc openFile_FileList {} {  
			variable  FILE_List_Widget
			variable  USER_Dir
			variable  current_filename
			
			set fileName [ $FILE_List_Widget get ]
			set fileName [ file join $USER_Dir $fileName]
			
			control::openFile         $fileName
			control::update_filelist  $fileName
			
			set current_filename      $fileName
	}


	#-------------------------------------------------------------------------
		#  open File
		#
	proc openFile {fileName} {
        
			variable CURRENT_Config 
		   
			array unset CURRENT_Config

			control::read_configfile $fileName
			
			control::check_init_values
			control::update_parameter  {force}
			control::switch_canvas     {config}
			
			set current_filename $fileName
			::set_window_title "File: $current_filename ($CURRENT_Config(_rattleCAD_Version))"
			control::toggle_lock_attribute  {new_file}
			config::update_cfg_values
	}
	

	#-------------------------------------------------------------------------
       #  open File by Extension
       #
	proc openFile_byExtension {fileName {altExtension {}}} {
              
			set fileExtension   [file extension $fileName]
	  
			puts "\n"
 			puts  "         openFile_byExtension:  $fileExtension ($altExtension)"
 			puts  "       ---------------------------------------------"
			puts  "               fileName      $fileName" 
			
			if {![file exists $fileName]} {
					puts  "         --<E>----------------------------------------------------" 
					puts  "           <E> File : $fileName" 
					puts  "           <E>      ... does not exist! " 
					puts  "         --<E>----------------------------------------------------"
					return					
			}

				# -- handle on file extension
				# 
			switch $altExtension {
				{.htm} -
				{.html} {	set fileExtension 	$altExtension
							set fileName 		"file:///$fileName" 
						}
				default {}
			}
			
			set fileApplication 	[get_Application $fileExtension]
			if {$fileApplication == {}} {
					puts  "         --<E>----------------------------------------------------" 
					puts  "           <E> File : $fileName" 
					puts  "           <E>      ... could not ge any Application! " 
					puts  "         --<E>----------------------------------------------------"
					return
			}
			puts  "               Filetype $fileExtension opens with:"
			puts  "                        >$fileApplication<\n"
			
			
				# ---------------------
				# replace %1 by fileName
			proc percSubst { cmdString pattern substString } {
					# puts " --------------"
					# puts "        \$cmdString    >$cmdString<"
					# puts "        \$pattern      >$pattern<"
					# puts "        \$substString  >$substString<"
					# puts " --------------"
					# puts " [ string map [ list $pattern $substString ] $cmdString ]"
				set cmdString	[ string map [ list $pattern $substString ] $cmdString ]
				return $cmdString
			}
			
				# ---------------------
				# Substitute the HTML filename into the
				# command for %1
			set commandString [ percSubst $fileApplication %1 $fileName ]
			if {$commandString == $fileApplication} {
				set commandString "$fileApplication  $fileName"
			}
			
				# ---------------------
				# Double up the backslashes for eval (below)
			puts "               ... $commandString "
			
				# ---------------------
				# Double up the backslashes for eval (below)
			regsub -all {\\} $commandString  {\\\\} commandString
			  
				# ---------------------
				# Invoke the command
			eval exec $commandString &
				
				# ---------------------
				# done ...
			puts  ""
			puts  "                    ... done"  
			return			
	}

	
	#-------------------------------------------------------------------------
       #  get Application of File Extension
       #	http://wiki.tcl.tk/557
	   #
	proc get_Application {fileExtension} {
			puts "\n"
 			puts  "         get_Application: $fileExtension"
 			puts  "       ---------------------------------------------"
			puts  "               tcl_version   [info tclversion]" 
			puts  "               tcl_platform  $::tcl_platform(platform)" 
			
			set appCmd {}	;# set as default
			
			switch $::tcl_platform(platform) {
				"windows" {
						package require registry 1.1

						set root HKEY_CLASSES_ROOT

							# Get the application key for HTML files
						set appKey [registry get $root\\$fileExtension ""]
						puts  "               appKey  $appKey" 

							# Get the command for opening HTML files
						if { [catch {     set appCmd [registry get $root\\$appKey\\shell\\open\\command ""]      } errMsg] } {
									puts  "         --<E>----------------------------------------------------" 
									puts  "           <E> File Type: $fileExtension" 
									puts  "           <E> could not find a registered COMMAND for this appKey" 
									puts  "         --<E>----------------------------------------------------"
									return 
						}
						puts  "               appCmd  $appCmd" 
						
				}
			}
			
				# puts  "               appCmd:"
				# puts "                         $appCmd"
			
			return $appCmd	
				
	}


	#-------------------------------------------------------------------------
		#  save File Type: xml
		#
	proc newProject_xml {} {	
				# --- select File
			set types {
					{{Project Files 3.x }       {.xml}  }
				}
				
			set userDir		[check_user_dir user]
			set fileName 	[tk_getSaveFile -initialdir $userDir -initialfile {new_Project.xml} -filetypes $types]
			
			if {$fileName == {}} return
			if {! [string equal [file extension $fileName] {.xml}]} {
				set fileName [format "%s.%s" $fileName xml]
			}
				
				# -- read from domConfig
			set domConfig  [ lib_file::openFile_xml 	[file join $::APPL_Env(CONFIG_Dir) $::APPL_Env(TemplateRoad) ] ]
					
				# --- set xml-File Attributes
			[ $domConfig selectNodes /root/Project/Name/text()  			] 	nodeValue 	[ file tail $fileName ]
			[ $domConfig selectNodes /root/Project/modified/text() 			] 	nodeValue 	[ clock format [clock seconds] -format {%Y.%m.%d %H:%M} ]
			[ $domConfig selectNodes /root/Project/rattleCADVersion/text()  ] 	nodeValue 	"$::APPL_Env(RELEASE_Version).$::APPL_Env(RELEASE_Revision)"

				# -- open File for writing
			set fp [open $fileName w]
			puts $fp [$domConfig  asXML]
			close $fp
				puts "           ... write $fileName "
				puts "		           ... done"
				
				# -- read new File
			set ::APPL_Project	[lib_file::openFile_xml $fileName show]
				#
			frame_geometry::set_base_Parameters $::APPL_Project
				# -- window title --- ::APPL_CONFIG(PROJECT_Name) ----------
			set_window_title $fileName
				#
			lib_gui::notebook_updateCanvas
				#
			lib_gui::open_configPanel  refresh
	
	}
	
	
	#-------------------------------------------------------------------------
		#  save File Type: xml
		#
	proc saveProject_xml { {mode {save}} {type {Road}} } {
      
				# --- select File
			set types {
					{{Project Files 3.x }       {.xml}  }
				}
				

			puts "\n"
			puts "  ====== s a v e  F I L E ========================="


				set userDir		[check_user_dir user]
			set initialFile	[file tail $::APPL_Config(PROJECT_Name)]
				puts "       ... saveProject_xml - mode:            \"$mode\""
				puts "       ... saveProject_xml - userDir:         \"$userDir\""
				puts "       ... saveProject_xml - APPL_Config:     \"$::APPL_Config(PROJECT_Name)\""			
				puts "       ... saveProject_xml - initialFile:     \"$initialFile\""			
			
				# default - values	

			switch -exact $mode {
				{save} 			{ 	set windowTitle		$initialFile
									set requestTemplate	{no}
									switch -exact $initialFile {
										{Template Road} { 	set requestTemplate	{yes} 
															set initialFile		[format "%s%s.xml" $::APPL_Env(USER_InitString) Road]
														}
										{Template MTB}  { 	set requestTemplate	{yes} 
															set initialFile		[format "%s%s.xml" $::APPL_Env(USER_InitString) MTB ]
														}
										default			{}
									}
									if {$requestTemplate == "yes"} {
										set retValue [tk_messageBox -title   "Save Project" -icon question \
																	-message "Save Project as Template?" \
																	-default cancel \
																	-type    yesnocancel]
										puts "\n  $retValue\n"
										
										switch $retValue {
											yes 	{}
											no		{	set mode 		saveAs 
														set initialFile	{new_Project.xml}															
													}
											cancel	{	return }
										}

									}
								}
								
								
				default			{
									switch -exact $initialFile {
										{Template Road} -
										{Template MTB}  {	set mode 		saveAs 
															set initialFile	{new_Project.xml}															
														}
										default			{}
									}
								}
			}
				puts ""			
				puts "       ... saveProject_xml - mode:            \"$mode\""
				puts "       ... saveProject_xml - initialFile:     \"$initialFile\""			

				# -- read from domConfig
			set domConfig $::APPL_Project
			
			switch $mode {
				{save}		{
								set fileName 	[file join $userDir $initialFile]
							}
				{saveAs}	{
								set fileName 	[tk_getSaveFile -initialdir $userDir -initialfile $initialFile -filetypes $types]
									puts "   saveProject_xml - fileName:   		$fileName"
									# -- $fileName is not empty
								if {$fileName == {} } return
									# -- $fileName has extension xml
										# puts " [file extension $fileName] "
								if {! [string equal [file extension $fileName] {.xml}]} {
									set fileName [format "%s.%s" $fileName xml]
									puts "   new $fileName"
								}
								
									# --- set xml-File Attributes
								[ $domConfig selectNodes /root/Project/Name/text()  			] 	nodeValue 	[ file tail $fileName ]
								
									# --- set window Title
								set windowTitle	$fileName								
							}
				default 	{	return}
			}
			
				# -- read from domConfig
			set domConfig $::APPL_Project

				# --- set xml-File Attributes
			[ $domConfig selectNodes /root/Project/modified/text() 			] 	nodeValue 	[ clock format [clock seconds] -format {%Y.%m.%d %H:%M} ]
			[ $domConfig selectNodes /root/Project/rattleCADVersion/text()  ] 	nodeValue 	"$::APPL_Env(RELEASE_Version).$::APPL_Env(RELEASE_Revision)"

				# -- open File for writing
			set fp [open $fileName w]
			puts $fp [$domConfig  asXML]
			close $fp
				puts "           ... write $fileName "
				puts "		           ... done"
				
			
				#
			set ::APPL_Project $domConfig
				#
			frame_geometry::set_base_Parameters $::APPL_Project
				# -- window title --- ::APPL_CONFIG(PROJECT_Name) ----------
			set_window_title $windowTitle
				#
			lib_gui::notebook_updateCanvas
			
			puts "  ====== s a v e  F I L E ========================="
	}


	#-------------------------------------------------------------------------
		#  open File Type: xml
		#	
	proc openProject_xml { {windowTitle {}} {fileName {}} } {		
			puts "\n"
			puts "  ====== o p e n   F I L E ========================"
			puts "         ... fileName:        $fileName"	
			puts "         ... windowTitle:     $windowTitle"
			puts ""
			
			set types {
					{{Project Files 3.x }       {.xml}  }
				}
			set userDir		$::APPL_Env(USER_Dir)
				# set userDir		[check_user_dir user]
				# puts "   openProject_xml - userDir    $userDir"
				# puts "   openProject_xml - types      $types"
			if {$fileName == {}} {
				set fileName 	[tk_getOpenFile -initialdir $userDir -filetypes $types]
			}
			
				# puts "   openProject_xml - fileName:   $fileName"
			if { [file readable $fileName ] } {
					set ::APPL_Project	[lib_file::openFile_xml $fileName show]
						#
					lib_project::check_ProjectVersion {3.1}
						# lib_project::check_ProjectVersion {3.2.20}
					lib_project::check_ProjectVersion {3.2.22}
					lib_project::check_ProjectVersion {3.2.23}
					lib_project::check_ProjectVersion {3.2.28}
					lib_project::check_ProjectVersion {3.2.32}
					lib_project::check_ProjectVersion {3.2.40}
						#
					frame_geometry::set_base_Parameters $::APPL_Project
					
						# -- window title --- ::APPL_CONFIG(PROJECT_Name) ----------
					if {$windowTitle == {}} {
						set_window_title $fileName
					} else {
						set_window_title $windowTitle
					}
						#
					lib_gui::notebook_updateCanvas
			}
				#
			puts "         ... openProject_xml - APPL_Config:		$::APPL_Config(PROJECT_Name)"			
				#
			lib_gui::open_configPanel  refresh
	}


	#-------------------------------------------------------------------------
		#  open Template File Type: xml
		#	
	proc openTemplate_xml {type} {		
			puts "\n"
			puts "  ====== o p e n   T E M P L A T E ================"
			puts "         ... type:    $type"	
			puts ""			
			set template_file	[ getTemplateFile $type ]
			puts "         ... template_file:   $template_file"
			if { [file readable $template_file ] } {
					set ::APPL_Project	[lib_file::openFile_xml $template_file show]
						#
					frame_geometry::set_base_Parameters $::APPL_Project
						# -- window title --- ::APPL_CONFIG(PROJECT_Name) ----------
					set_window_title "Template $type"
						#
					lib_gui::notebook_updateCanvas
			} else {
				tk_messageBox -message "... could not load template: $window_title"
			}
			
				#
			lib_gui::open_configPanel  refresh
	}


	#-------------------------------------------------------------------------
		#  get user project directory
		#	
	proc check_user_dir {userDir} {
 
			set install_Dir $::APPL_Env(BASE_Dir)

				# puts  "install_Dir  $install_Dir"  1
				# puts  "check_Dir    $check_Dir"     1
	   
				# set search_dir [file join [file dirname $install_Dir] user]
			set check_Dir 	[file join [file dirname $install_Dir] $userDir]
				#puts  "dirname      [file dirname $install_Dir]"  1
				#puts  "search_dir   $search_dir"  1
		   
			if {[file exists $check_Dir]} {
				if {[file isdirectory $check_Dir]} {
					set check_Dir $check_Dir
						# puts  "         check_user_dir:  $check_Dir" 
				} else {
					tk_messageBox -title   "Config ERROR" \
								  -icon    error \
								  -message "There is af file \n   ... $check_Dir\n     should be ad directory\n\n  ... please remove file"
					return
				}
			} else {
				file mkdir $check_Dir
			}
			return $check_Dir
	}


	#-------------------------------------------------------------------------
		#  ... 
		#	
	proc openFile_xml {{file {}} {show {}}} {

			set types {
					{{xml }       {.xml}  }
				}
			if {$file == {} } {
				set file [tk_getOpenFile -filetypes $types]
			}
				# -- $fileName is not empty
			if {$file == {} } return
				
			set fp [open $file]
					
			fconfigure    $fp -encoding utf-8
			set xml [read $fp]
			close         $fp
			
			set doc  [dom parse  $xml]
			set root [$doc documentElement]
					
				#
				# -- fill tree
				#
			if {$show != {}} {
				lib_cfg_report::fillTree "$root" root
			}

				#
				# -- return root  document
				#
			return $root		
	}
	

	#-------------------------------------------------------------------------
		#  ... 
		#	
	proc getTemplateFile {type} {
						
			set TemplateRoad 	[file join $::APPL_Env(USER_Dir) [format "%s%s.xml" $::APPL_Env(USER_InitString) Road] ]
			set TemplateMTB 	[file join $::APPL_Env(USER_Dir) [format "%s%s.xml" $::APPL_Env(USER_InitString) MTB ] ]
	
			switch -exact $type {
					{Road} {	if {[file exists $TemplateRoad ]} {
									return $TemplateRoad
								} else {
									return $::APPL_Env(TemplateRoad_default)	
								}
							}
					{MTB} {		if {[file exists $TemplateMTB ]} {
									return $TemplateMTB
								} else {
									return $::APPL_Env(TemplateMTB_default)	
								}
							}
					default	{	return {} 
							}
				}
			
	}


	#-------------------------------------------------------------------------
		# http://stackoverflow.com/questions/429386/tcl-recursively-search-subdirectories-to-source-all-tcl-files
		# 2010.10.15
	proc findFiles { basedir pattern } {
					# Fix the directory name, this ensures the directory name is in the
					# native format for the platform and contains a final directory seperator
			set basedir [string trimright [file join [file normalize $basedir] { }]]
			set fileList {}
					# Look in the current directory for matching files, -type {f r}
					# means ony readable normal files are looked at, -nocomplain stops
					# an error being thrown if the returned list is empty
			foreach fileName [glob -nocomplain -type {f r} -path $basedir $pattern] {
				lappend fileList $fileName
			}
					# Now look for any sub direcories in the current directory
			foreach dirName [glob -nocomplain -type {d  r} -path $basedir *] {
						# Recusively call the routine on the sub directory and append any
						# new files to the results
				set subDirList [findFiles $dirName $pattern]
				if { [llength $subDirList] > 0 } {
					foreach subDirFile $subDirList {
						lappend fileList $subDirFile
					}
				}
			}
			return $fileList
	}	

	
	#-------------------------------------------------------------------------
		# component alternatives
		# 
	proc get_componentAlternatives {xPath} {
	
			set directory	[lindex [array get ::APPL_CompLocation $xPath ] 1 ]
						# puts "     ... directory  $directory"
			if {$directory == {}} {
						# tk_messageBox -message "no directory"
				puts "    -- <E> -------------------------------"
				puts "         ... no directory configured for"
				puts "               $xPath"
				puts "    -- <E> -------------------------------"
				return {}
			}
			
			set userDir 	[ file join $::APPL_Env(USER_Dir)   $directory ]
			set etcDir 		[ file join $::APPL_Env(CONFIG_Dir) $directory ]
						# puts "            user: $userDir"
						# puts "            etc:  $etcDir"
			

			catch {
				foreach file [ glob -directory $userDir  *.svg ] {
						# puts "     ... fileList: $file"
					set fileString [ string map [list $::APPL_Env(USER_Dir)/components/ {user:} ] $file ]
					set listAlternative   [ lappend listAlternative $fileString]
				}
			}
			foreach file [ glob -directory $etcDir  *.svg ] {
						# puts "  ... fileList: $file"
				set fileString [ string map [list $::APPL_Env(CONFIG_Dir)/components/ {etc:} ] $file ]
				set listAlternative   [ lappend listAlternative $fileString]
			}
			
				# ------------------------
				#	 some components are not neccessary at all
			switch -exact $xPath {
					Component/Derailleur/File  {
							set listAlternative [lappend listAlternative {etc:default_blank.svg} ]
					}
			}

			
			return $listAlternative
	
	}

	
}

