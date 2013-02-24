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
	proc openFile_byExtension {fileName {altExtension {.htm}}} {
              
			set fileExtension   [file extension $fileName]
	  
			puts "\n"
 			puts  "         openFile_byExtension:  $fileExtension"
 			puts  "       ---------------------------------------------"
			puts  "               fileName      $fileName" 
			
			if {![file exists $fileName]} {
					puts  "         --<E>----------------------------------------------------" 
					puts  "           <E> File : $fileName" 
					puts  "           <E>      ... does not exist! " 
					puts  "         --<E>----------------------------------------------------"
					return					
			}

			set openApplication [get_Application $fileExtension]
			if {$openApplication == {}} {
					set fileExtension	$altExtension
					set openApplication [get_Application $fileExtension]			
			}
			if {$openApplication == {}} {
					puts  "         --<E>----------------------------------------------------" 
					puts  "           <E> File : $fileName" 
					puts  "           <E>      ... could not ge any Application! " 
					puts  "         --<E>----------------------------------------------------"
			}
			puts  "               Filetype $fileExtension opens with $openApplication"
			
					   
				# Just the command!
			set Application [lindex [split $openApplication \"] 1]
			if {$fileExtension == {.htm}} {
				set fileName "file:///$fileName"
			}
			 
				# Run the command!
			puts  ""
			puts  "               $Application"
			puts  "                      $fileName"
			
			exec $Application $fileName &
			 
				# finish!
			puts  ""
			puts  "                    ... done"  
			return			
	}

	
	#-------------------------------------------------------------------------
       #  get File Extension
       #
	proc get_Application {fileExtension} {
			puts "\n"
 			puts  "         get_Application: $fileExtension"
 			puts  "       ---------------------------------------------"
			puts  "               tcl_version   [info tclversion]" 
			puts  "               tcl_platform  $::tcl_platform(platform)" 
			
			switch $::tcl_platform(platform) {
				"windows" {
						package require registry 1.1

						set reg_fileext [registry keys  {HKEY_CLASSES_ROOT} $fileExtension]
						puts  "               ... $reg_fileext  ... reg_fileext" 
					 
							# there the file-extension is not defined
						if {$reg_fileext == {} } {
									# 		set 	error_message "File Type: $reg_fileext"
									#		append 	error_message "\n  could not find a OPEN command for filetype"
									# tk_messageBox -message "$error_message"
								puts  "         --<E>----------------------------------------------------" 
								puts  "           <E> File Type: $reg_fileext" 
								puts  "           <E> could not find a REGISTRY for filetype" 
								puts  "         --<E>----------------------------------------------------" 
								return
						}

							# get the filetype 
						if { [catch { set reg_filetype [registry get HKEY_CLASSES_ROOT\\$reg_fileext {}] } errMsg] } {
								#		set 	error_message "File Type: $reg_fileext\n"
								#		append 	error_message "could not find a registerd File Type"
								# tk_messageBox -message "$error_message"
								puts  "         --<E>----------------------------------------------------" 
								puts  "           <E> File Type: $reg_fileext" 
								puts  "           <E> could not find a registerd File Type " 
								puts  "           <E> $errMsg" 
								puts  "         --<E>----------------------------------------------------" 
								return 
						}
								# set reg_filetype [registry get HKEY_CLASSES_ROOT\\$reg_fileext {}]
						puts  "               reg_filetype  $reg_filetype" 
				   
							# Work out where to look for the command
						if { [catch { set path HKEY_CLASSES_ROOT\\$reg_filetype\\Shell\\Open\\command } errMsg] } {
								#		set 	error_message "File Type: $reg_fileext\n"
								#		append 	error_message "could not find a registerd APPLICATION for $reg_filetype"
								# tk_messageBox -message "$error_message"
								puts  "         --<E>----------------------------------------------------" 
								puts  "           <E> File Type: $reg_fileext" 
								puts  "           <E> could not find a registerd APPLICATION for $reg_filetype" 
								puts  "           <E> $errMsg" 
								puts  "         --<E>----------------------------------------------------" 
								return 
						}
							# set path HKEY_CLASSES_ROOT\\$reg_filetype\\Shell\\Open\\command
						puts  "               path          $path" 

							# Read the command!
						if { [catch { set extApplication [registry get $path {}] } errMsg] } {
								#		set 	error_message "File Type: $reg_fileext\n"
								#		append 	error_message "could not find a registerd APPLICATION for $reg_filetype"
								# tk_messageBox -message "$error_message"
								puts  "         --<E>----------------------------------------------------" 
								puts  "           <E> File Type: $reg_fileext" 
								puts  "           <E> could not find a registerd APPLICATION for $reg_filetype" 
								puts  "           <E> $errMsg" 
								puts  "         --<E>----------------------------------------------------" 
								return 
						}
				}
			}
			
			puts  "               extApplication:"
			puts "                         $extApplication"
			
			return $extApplication					
	}

	
	#-------------------------------------------------------------------------
		#  save File Type: xml
		#
	proc saveProject_xml {{mode {save}}} {
      
				# --- select File
			set types {
					{{Project Files 3.x }       {.xml}  }
				}
				
			set userDir		[check_user_dir user]
			set initialFile	[file tail $::APPL_Config(PROJECT_Name)]
				puts "   saveProject_xml - userDir:    		$userDir"
				puts "   saveProject_xml - APPL_Config:		$::APPL_Config(PROJECT_Name)"			
				puts "   saveProject_xml - initialFile:		$initialFile"			
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
			
			
			switch $mode {
				{save}		{}
				{saveAs}	{
								if {[file exists $fileName]} {
									tk_messageBox -message "File: $fileName  allready exists" -icon error
									return
								}
							}
				default 	{	return}
			}
			
				# -- read from domConfig
			set domConfig $::APPL_Project

				# --- set xml-File Attributes
			[ $domConfig selectNodes /root/Project/Name/text()  			] 	nodeValue 	[ file tail $fileName ]
			[ $domConfig selectNodes /root/Project/modified/text() 			] 	nodeValue 	[ clock format [clock seconds] -format {%Y.%m.%d %H:%M} ]
			[ $domConfig selectNodes /root/Project/rattleCADVersion/text()  ] 	nodeValue 	"$::APPL_Env(RELEASE_Version).$::APPL_Env(RELEASE_Revision)"

				# -- open File for writing
			set fp [open $fileName w]
			puts $fp [$::APPL_Project  asXML]
			close $fp
				puts "           ... write $fileName "
				puts "		           ... done"
				
				#
			frame_geometry_custom::set_base_Parameters $::APPL_Project
				# -- window title --- ::APPL_CONFIG(PROJECT_Name) ----------
			set_window_title $fileName
				#
			lib_gui::notebook_updateCanvas
	}


	#-------------------------------------------------------------------------
		#  open File Type: xml
		#	
	proc openProject_xml {} {		
			set types {
					{{Project Files 3.x }       {.xml}  }
				}
			set userDir		[check_user_dir user]
				# puts "   openProject_xml - userDir    $userDir"
				# puts "   openProject_xml - types      $types"
			set fileName 	[tk_getOpenFile -initialdir $userDir -filetypes $types]		  
				# puts "   openProject_xml - fileName:   $fileName"
			if { [file readable $fileName ] } {
					set ::APPL_Project	[lib_file::openFile_xml $fileName show]
						#
					check_FileVersion {3.1}
						#
					frame_geometry_custom::set_base_Parameters $::APPL_Project
						# -- window title --- ::APPL_CONFIG(PROJECT_Name) ----------
					set_window_title $fileName
						#
					lib_gui::notebook_updateCanvas
			}
				puts "   openProject_xml - APPL_Config:		$::APPL_Config(PROJECT_Name)"			
	}


	#-------------------------------------------------------------------------
		#  open Template File Type: xml
		#	
	proc openTemplate_xml {window_title template_file } {		
			puts "   openTemplate_xml:	window_title   $template_file"	
			if { [file readable $template_file ] } {
					set ::APPL_Project	[lib_file::openFile_xml $template_file show]
						#
					frame_geometry_custom::set_base_Parameters $::APPL_Project
						# -- window title --- ::APPL_CONFIG(PROJECT_Name) ----------
					set_window_title $window_title
						#
					lib_gui::notebook_updateCanvas
			} else {
				tk_messageBox -message "... could not load template: $window_title"
			}
	}


	#-------------------------------------------------------------------------
		#  check File Version 3.1 -> 3.2
		#	
	proc check_FileVersion {Version} {
			puts " ... check_FileVersion:  $Version"
			case $Version {
				{3.1} {	set node {}

								# --- /root/Personal/SeatTube_Length
							set node [$::APPL_Project selectNode /root/Personal/SeatTube_Length]
							if {$node == {}} {
								puts "        ...  $Version   ... update File ... /root/Personal/SeatTube_Length"
								set LegLength [expr 0.88 * [[$::APPL_Project selectNode /root/Personal/InnerLeg_Length] asText ] ]
								set node [$::APPL_Project selectNode /root/Personal]
								$node appendXML "<SeatTube_Length>$LegLength</SeatTube_Length>"
							}
							
								# --- /root/Result
							set node [$::APPL_Project selectNode /root/Result]
							if {$node == {}} {
								puts "        ...  $Version   ... update File ... /root/Temporary"
								set node [$::APPL_Project selectNode /root]
								$node appendXML "<Result>
													<HeadTube>
														<ReachLength>0.00</ReachLength>
														<StackHeight>0.00</StackHeight>
														<Angle>0.00</Angle>
													</HeadTube>
													<SeatTube>
														<TubeLength>0.00</TubeLength>
														<TubeHeight>0.00</TubeHeight>
													</SeatTube>
													<Saddle>
														<Offset_BB>
															<horizontal>0.00</horizontal>
														</Offset_BB>
													</Saddle>
													<WheelPosition>
														<front>
															<horizontal>0.00</horizontal>
														</front>
														<rear>
															<horizontal>0.00</horizontal>
														</rear>
													</WheelPosition>
												</Result>"
							}
							
								# --- /root/Rendering
							set node [$::APPL_Project selectNode /root/Rendering]
							if {$node == {}} {
								puts "        ...  $Version   ... update File ... /root/Rendering"
								set node [$::APPL_Project selectNode /root]
								$node appendXML "<Rendering>
													<Fork>SteelLugged</Fork>
													<Brakes>Road</Brakes>
												</Rendering>"
							}	
							
						}
				{ab-xy} {	set node {}
							set node [$::APPL_Project selectNode /root/Project/rattleCADVersion/text()]
							puts " ... [$node nodeValue] .."
							puts " ... [$node asText] .."
							$node nodeValue [format "%s.%s" $::APPL_Env(RELEASE_Version) $::APPL_Env(RELEASE_Revision)] 
							return
						}

				default {}
			}
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
					puts  "         check_user_dir:  $check_Dir" 
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
	
	
	
}

