# -----------------------------------------------------------------------------------
#
#: Functions : namespace      G U I 
#

 namespace eval lib_gui {
     
	variable 	canvasGeometry
	array	set canvasGeometry {}
	variable 	notebookCanvas 
	array	set notebookCanvas {}
	variable 	iconArray 
	array	set iconArray {}
	
	variable 	canvasUpdate
	array	set canvasUpdate {}
	
	variable	gui_NoteBook


							
	#-------------------------------------------------------------------------
       #  create MainFrame with Menue  
       #
	proc create_MainFrame {} {		
			
			set mainframe_Menue {
				"&File"   all file 0 {
						{command "&Open Project XML"      {File_Open_Project}  	"Open Project-XML File" {Ctrl o} -command { lib_file::openProject_xml } 	}
						{command "&Save"                  {File_Save}     		"Save Configuration"    {Ctrl s} -command { lib_file::saveProject_xml }		}
						{separator}
						{command "&Print"                 {File_Print}    		"Print current Graphic" {Ctrl p} -command { lib_gui::notebook_printCanvas $APPL_Env(USER_Dir) }	}
						{separator}
						{command "&Intro-Image"           {File_Intro}    		"Show Intro Window"     {Ctrl i} -command { create_intro .intro}          	}
						{separator}
						{command "E&xit"                  {File_Exit}     		"Exit rattle_CAD"       {Ctrl x} -command { exit }                        	}
				}
				"Info"   all info 0 {
						{command "Info"                   {}              		"Version-Information"      {}    -command { version_info::create  .v_info} 	}
				}
			}
		
		return [MainFrame .mainframe  -menu $mainframe_Menue ]
	}


	#-------------------------------------------------------------------------
		#  create MainFrame with Menue  
		#
	proc create_ButtonBar {tb_frame } {	
		variable iconArray
	
		Button	$tb_frame.open     -image  $iconArray(open)		-helptext "open ..."		-command { lib_file::openProject_xml }  
		Button	$tb_frame.save     -image  $iconArray(save)		-helptext "save ..."		-command { lib_file::saveProject_xml } 
		Button	$tb_frame.print    -image  $iconArray(print)	-helptext "print ..."		-command { lib_gui::notebook_printCanvas $APPL_Env(USER_Dir) }  		
													 
		Button	$tb_frame.set_rd   -image  $iconArray(reset_r)	-helptext "load example road"				-command { control::template_to_design  Road    }  
		Button	$tb_frame.set_mb   -image  $iconArray(reset_o)	-helptext "load example offroad"			-command { control::template_to_design  OffRoad }  
		  
		Button	$tb_frame.clear    -image  $iconArray(clear)	-helptext "clear ..."    	-command { lib_gui::notebook_cleanCanvas} 
		Button	$tb_frame.render   -image  $iconArray(design)	-helptext "update ..."		-command { lib_gui::notebook_updateCanvas force}  

		Button	$tb_frame.scale_p  -image  $iconArray(scale_p)	-helptext "scale plus"		-command { lib_gui::notebook_scaleCanvas  1.50 }  
		Button	$tb_frame.scale_m  -image  $iconArray(scale_m)	-helptext "scale minus"		-command { lib_gui::notebook_scaleCanvas  0.67 }  
		Button	$tb_frame.resize   -image  $iconArray(resize)	-helptext "resize"			-command { lib_gui::notebook_refitCanvas }  
		
		Button	$tb_frame.ref2pers -text   {Reference Geometry}	-helptext "export reference to personal geometry" \
																							-command { frame_geometry_reference::export_parameter_2_geometry_custom  $::APPL_Project ; lib_gui::fill_canvasCAD cv_Custom01}  
		  
		Button	$tb_frame.exit     -image  $iconArray(exit)     -command { exit }
		  
		label   $tb_frame.sp0      -text   " "
		label   $tb_frame.sp1      -text   " "
		label   $tb_frame.sp2      -text   " "
		label   $tb_frame.sp3      -text   " "
		label   $tb_frame.sp4      -text   " "
		label   $tb_frame.sp5      -text   " "
		label   $tb_frame.sp6      -text   " "
		  
		  
			# pack    $tb_frame.open     $tb_frame.save     $tb_frame.clear    $tb_frame.print    $tb_frame.sp0  \
			#		$tb_frame.set_rd   $tb_frame.set_mb   $tb_frame.sp2  \
			#		$tb_frame.render   $tb_frame.sp3  \
			#
		pack    $tb_frame.open     $tb_frame.save    $tb_frame.print     $tb_frame.sp0  \
				$tb_frame.clear    $tb_frame.render   $tb_frame.sp3  \
				$tb_frame.ref2pers   $tb_frame.sp4  \
			-side left -fill y
				   
		pack    $tb_frame.exit   $tb_frame.sp6  \
				$tb_frame.resize $tb_frame.scale_p $tb_frame.scale_m  $tb_frame.sp5  \
			-side right 
	}


	#-------------------------------------------------------------------------
		#  register notebookCanvas in notebook - Tabs   
		#
	proc create_Notebook {frame} {
		variable canvasGeometry
		variable canvasUpdate
		variable gui_NoteBook
		
			# --- 	initialize canvasUpdate
		set canvasUpdate(recompute)	0
		
			# --- 	create ttk::notebook
		set gui_NoteBook 	[ ttk::notebook $frame.nb -width $canvasGeometry(width)	-height $canvasGeometry(height) ]
			pack $gui_NoteBook -expand yes  -fill both  
		
			# --- 	create and register any canvasCAD - canvas in lib_gui::notebookCanvas
		lib_gui::create_canvasCAD  $gui_NoteBook  cv_Custom99  "Reference"   		297 210 m  0.2 -bd 2  -bg white  -relief sunken
		lib_gui::create_canvasCAD  $gui_NoteBook  cv_Custom00  "Personal "   		297 210 m  0.2 -bd 2  -bg white  -relief sunken
		lib_gui::create_canvasCAD  $gui_NoteBook  cv_Custom01  "Details"			297 210 m  0.2 -bd 2  -bg white  -relief sunken
		lib_gui::create_canvasCAD  $gui_NoteBook  cv_Custom02  "Frame"   			297 210 m  0.2 -bd 2  -bg white  -relief sunken
		lib_gui::create_canvasCAD  $gui_NoteBook  cv_Custom03  "Assembly"   		297 210 m  0.2 -bd 2  -bg white  -relief sunken
		lib_gui::create_canvasCAD  $gui_NoteBook  cv_Custom04  "Dimensions"   		297 210 m  0.2 -bd 2  -bg white  -relief sunken
		lib_gui::create_canvasCAD  $gui_NoteBook  cv_Custom05  "Drafting - Frame"	297 210 m  0.2 -bd 2  -bg white  -relief sunken
		lib_gui::create_canvasCAD  $gui_NoteBook  cv_Custom06  "Drafting - Jig"		297 210 m  0.2 -bd 2  -bg white  -relief sunken
		lib_gui::create_canvasCAD  $gui_NoteBook  cv_Custom07  "Tube Mitter"		297 210 m  1.0 -bd 2  -bg white  -relief sunken
		
		$gui_NoteBook add [frame $gui_NoteBook.cfg_report] 	-text "Config-Report" 
			# $gui_NoteBook add [frame $gui_NoteBook.txt_report] 	-text "Text-Report" 
	
			# --- 	fill with Report Widgets
		lib_cfg_report::createReport $gui_NoteBook.cfg_report
			# lib_txt_report::createReport $gui_NoteBook.txt_report

			# --- 	bind event to update Tab on selection
		bind $gui_NoteBook <<NotebookTabChanged>> {lib_gui::notebook_updateCanvas}
		
			# --- 	select an update following Tab
		$gui_NoteBook select $gui_NoteBook.cv_Custom04
		
			# --- 	return
		return $gui_NoteBook
	
	}


	#-------------------------------------------------------------------------
		#  register notebookCanvas in notebook - Tabs   
		#
	proc create_canvasCAD {notebook varname title args} {
		variable canvasGeometry
		variable notebookCanvas
		
		set notebookCanvas($varname)   $notebook.$varname.cvCAD

			# --- 	add frame containing canvasCAD
		$notebook add [ frame $notebook.$varname ] -text $title 
		
			# --- 	add canvasCAD to frame and select notebook tab before to update 
			#          the tabs geometry
		$notebook select $notebook.$varname  
 		eval canvasCAD::newCanvas $varname  $notebookCanvas($varname)  $canvasGeometry(width) $canvasGeometry(height) $args 
		# set ::$varname	[eval canvasCAD::newCanvas $varname  $notebookCanvas($varname)  $args ]
	}


	#-------------------------------------------------------------------------
       #  update canvasCAD in current notebook-Tab  
       #
	proc notebook_updateCanvas {{mode {}}} {
		variable gui_NoteBook
		variable canvasUpdate
				
		set currentTab 				[$gui_NoteBook select]
		set varName    				[notebook_getVarName $currentTab]
		set varName    				[lindex [split $varName {::}] end]
		
		if { [catch { set lastUpdate $canvasUpdate($varName) } msg] } {
			set canvasUpdate($varName) [ expr $::APPL_Update -1 ]
		}
			# puts "\n    canvasUpdate($varName):  $canvasUpdate($varName)    vs.  $::APPL_Update\n"
		if { $mode == {} } {
				if { $canvasUpdate($varName) < $::APPL_Update } {
					puts "\n       ... notebook_updateCanvas ... update $varName\n"
					fill_canvasCAD $varName
					set canvasUpdate($varName) [ clock milliseconds ]
				} else {
					# puts "\n       ... notebook_updateCanvas ... update $varName not required\n"
				}
		} else {
					puts "\n       ... notebook_updateCanvas ... update $varName .. force\n"
					fill_canvasCAD $varName
		}
	}

	
	#-------------------------------------------------------------------------
		#  fill cv_Custom01   
		#
	proc fill_canvasCAD {varName} {
		variable gui_NoteBook
		switch -exact -- $varName {
			cv_Custom99 -
			cv_Custom00 -
			cv_Custom01 -
			cv_Custom02 -
			cv_Custom03 -
			cv_Custom04 -
			cv_Custom05 -
			cv_Custom06 -
			cv_Custom07 {
					$gui_NoteBook select $gui_NoteBook.$varName
					cv_custom_00::update 	lib_gui::$varName 
				}
		}
	}

	
	#-------------------------------------------------------------------------
       #  get notebook window    
       #
	proc notebook_getWidget {varName} {
		variable notebookCanvas
		
		foreach index [array names notebookCanvas] {
			if {$index == $varName} {
				  # puts "$index $notebookCanvas($index) "
				return $notebookCanvas($index)
			}
		}
	}

	
	#-------------------------------------------------------------------------
       #  get notebook window    
       #
	proc notebook_getVarName {widgetName} {
		variable notebookCanvas
		
		set widgetName $widgetName.cvCAD
		foreach varName [array names notebookCanvas] {
			   # puts "          -> $varName $notebookCanvas($varName) "
			if {$notebookCanvas($varName) == $widgetName} {
				return [namespace current]::$varName
			}
		}
	}

	
	#-------------------------------------------------------------------------
       #  refit notebookCanvas in current notebook-Tab  
       #
	proc notebook_refitCanvas {} {
		variable gui_NoteBook

		set currentTab [$gui_NoteBook select]
		set varName    [notebook_getVarName $currentTab]
			# puts "   varName: $varName"
		if { $varName == {} } {
				puts "   notebook_refitCanvas::varName: $varName"
				return
		}
		  # tk_messageBox -message "currentTab: $currentTab   /  varName  $varName"
		$varName refitToCanvas
	}

	
	#-------------------------------------------------------------------------
       #  scale canvasCAD in current notebook-Tab  
       #
	proc notebook_scaleCanvas {value} {
		variable gui_NoteBook

		set currentTab [$gui_NoteBook select]
		set varName    [notebook_getVarName $currentTab]
			# puts "   varName: $varName"
		if { $varName == {} } {
				puts "   notebook_scaleCanvas::varName: $varName"
				return
		}
		set curScale  [ eval $varName getNodeAttr Canvas scale ]
		set newScale  [ format "%.2f" [ expr $value * $curScale * 1.0 ] ]
		  # puts "   $curScale"
		  # tk_messageBox -message "curScale: $curScale  /  newScale  $newScale "
		$varName scaleToCenter $newScale
	}

	
	#-------------------------------------------------------------------------
       #  print canvasCAD from current notebook-Tab  
       #
	proc notebook_printCanvas {printDir} {
		variable gui_NoteBook
		
			## -- read from domConfig
		set domConfig $::APPL_Project

			# --- get currentTab
		set currentTab 	[ $gui_NoteBook select ]
		set cv_Name    	[ notebook_getVarName $currentTab]
		if { $cv_Name == {} } {
				puts "   notebook_printCanvas::cv_Name: $cv_Name"
				return
		}

			# --- get stageScale
		set stageScale 	[ $cv_Name  getNodeAttr  Stage	scale ]	
		set scaleFactor	[ expr round([ expr 1 / $stageScale ]) ]

			# --- set timeStamp
		set timeString 	[ format "printed: %s" [ clock format [clock seconds] -format {%Y.%m.%d %H:%M} ] ]
		set textPos		[ vectormath::scalePointList {0 0} {10 7} $scaleFactor ]
		set timeStamp	[ $cv_Name create draftText $textPos  -text $timeString -size 2.5 -anchor sw ]
			# --- print
		$cv_Name print $printDir
			# --- delete timeStamp
		catch [ $cv_Name delete $timeStamp ]
			# --- keep for any reason
				# puts " \$cv_Name $cv_Name"
				# puts " \$_tmpInfo_ $_tmpInfo_"
	}

	
	#-------------------------------------------------------------------------
       #  clean canvasCAD in current notebook-Tab  
       #
	proc notebook_cleanCanvas {} {
		variable gui_NoteBook

		set currentTab [$gui_NoteBook select]
		set varName    [notebook_getVarName $currentTab]
		if { $varName == {} } {
				puts "   notebook_cleanCanvas::varName: $varName"
				return
		}
		$varName clean_StageContent
	}

}

