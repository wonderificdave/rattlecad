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
       
        ::Debug  p  1
        
        check_user_dir

        while {true} {
       	    set fileName [tk_getOpenFile  -initialdir $USER_Dir  -filetypes  $filetypes ] 
       	    if {[string length $fileName] == 0} {
       	        break
       	    } elseif {[file exists $fileName] && [file readable $fileName]} {
       	        
                control::openFile $fileName
				control::update_filelist $fileName
				
				set current_filename      $fileName
              
                    ::Debug  t  "File: $current_filename"  1
       	        return
       	    } else {
       	        tk_messageBox -icon error -title "Read ERROR" \
       		      -message "File «$fileName» is not readable"
                    ::Debug  t  "File «$fileName» is not readable"  1
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

		  
		    # tk_messageBox -message " -> $fileName"	    
	}


	#-------------------------------------------------------------------------
		#  open File
		#
	proc openFile {fileName} {
        
          variable CURRENT_Config 
       
        ::Debug  p  1
        
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
		#  save File Type: xml
		#
	proc saveProject_xml {{mode {save}}} {
      
	    ::Debug  p  1

			# --- select File
		set types {
				{{Project Files 3.x }       {.xml}  }
			}
	   	set userDir		[check_user_dir]
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
	   	set userDir		[check_user_dir]
			# puts "   openProject_xml - userDir    $userDir"
			# puts "   openProject_xml - types      $types"
		set fileName 	[tk_getOpenFile -initialdir $userDir -filetypes $types]		  
			# puts "   openProject_xml - fileName:   $fileName"
		if { [file readable $fileName ] } {
				set ::APPL_Project	[lib_file::openFile_xml $fileName show]
					#
				check_FileVersion {31-32}
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
			{31-32} {	set node {}
						set node [$::APPL_Project selectNode /root/Rendering]
						if {$node == {}} {
							puts "        ...  $Version   ... update File ..."
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
	proc check_user_dir {} {
			::Debug  p  1
 
		set   install_dir        $::APPL_Env(BASE_Dir)
		set   USER_Dir           [file join $install_dir user]
       
			::Debug  t  "install_dir  $install_dir"  1
			::Debug  t  "USER_Dir     $USER_Dir"     1
   
        set search_dir [file join [file dirname $install_dir] user]
			::Debug  t  "dirname      [file dirname $install_dir]"  1
			::Debug  t  "search_dir   $search_dir"  1
       
        if {[file exists $search_dir]} {
            if {[file isdirectory $search_dir]} {
                set USER_Dir $search_dir
                ::Debug  t  "search_dir   $search_dir" 
            } else {
                tk_messageBox -title   "Config ERROR" \
                              -icon    error \
                              -message "There is af file \n   ... $search_dir\n     should be ad directory\n\n  ... please remove file"
                return
            }
        } else {
            file mkdir $search_dir
        }
        return $USER_Dir
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

