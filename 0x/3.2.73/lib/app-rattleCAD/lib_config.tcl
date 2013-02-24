 ##+##########################################################################te
 #
 # package: rattleCAD	->	lib_comp_library.tcl
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
 #	namespace:  rattleCAD::lib_comp_library
 # ---------------------------------------------------------------------------
 #
 # 

 namespace eval lib_config {
                            
	variable	cfg_Position 	{}

	variable	rdials_list		{}
	variable	cboxList		{}
				
	variable 	configValue
	  array set configValue 	{}

	variable 	componentList	{}
	variable    compCanvas      {}

				
	#-------------------------------------------------------------------------
       #  create config widget
       #
	proc create {main w {mode {}}} {

			variable cfg_Position
			
				# -----------------
				# main window information
			set root_xy [split  [wm geometry $main] +]
			set root_w 	[winfo width $main]
			set root_x	[lindex $root_xy 1]
			set root_y	[lindex $root_xy 2]
			
			
				# -----------------
				# check if window exists
			if {[winfo exists $w]} {
					# restore if hidden
					# puts "   ... $w allready exists!"
				wm geometry	$w +[expr $root_x+8+$root_w]+[expr $root_y]
				if {$mode == {refresh}} {
					create_Content $main $w
				}
				wm deiconify 	$w
				wm deiconify	$main
				return
			}
					

				# -----------------
				# create a toplevel window to edit the attribute values
				#
			toplevel 	$w
			wm title 	$w "Configuration Panel"
				# create iconBitmap  -----
			wm iconbitmap $w [file join $::APPL_Env(BASE_Dir) tclkit.ico]  
				# puts "    geometry:  [wm geometry .]"
			wm geometry	$w +[expr $root_x+8+$root_w]+[expr $root_y]	

			
				# -----------------
				# create content
			create_Content $main $w
			
				# -----------------
				#
			set cfg_Position [list $root_x $root_y $root_w [expr $root_x+8+$root_w] 0 ]
				
				# -----------------
				#
			bind $w		<Configure> [list [namespace current]::register_relative_position 	$main $w]
			bind $main 	<Configure> [list [namespace current]::reposition_to_main  			$main $w]
					
				# -----------------
				#
			wm deiconify	$main
			
			#$nb_Config select 1
			
	}


	#-------------------------------------------------------------------------
       #  create config Content
       #
	proc create_Content {main w} {

			variable compCanvas
			
				# -----------------
				#   clean berfoe create
			catch {destroy $w.f}
			
				# -----------------
				# reset value list
			array unset [namespace current]::configValue
				# -----------------
				#   initiate all tags and values
			init_configValues

				# -----------------
				#   create notebook
			pack [  frame $w.f ] 
				#
			set nb_Config	[ ttk::notebook $w.f.nb ]
				pack $nb_Config  	-expand no -fill both   
			$nb_Config add [frame $nb_Config.geometry] 	-text "Geometry" 		
			$nb_Config add [frame $nb_Config.mockup] 	-text "Mockup" 
		
				# -----------------
				# add content
			add_Basic 	$nb_Config.geometry
			$nb_Config select $nb_Config.mockup
			add_Detail 	$nb_Config.mockup
			$nb_Config select $nb_Config.geometry
			
				# -----------------
				#
			wm resizable	$w  0 0
				#	wm  withdraw   $w			
			# update
			# $compCanvas refitStage
			
			return
	}


	
	#-------------------------------------------------------------------------
       #  add content 01
       #
	proc add_Basic {w} {
				#
				# add content
				#
			set 	menueFrame	[ frame $w.f_menue	-relief flat -bd 1]
			pack 	$menueFrame \
				-fill both -side left


				# -----------------
				#   build frame
			frame	 		$menueFrame.sf -relief flat -bd 1			
				pack $menueFrame.sf  		-side top  

				
				# -----------------
				#   Concept - Primary
			ttk::labelframe	$menueFrame.sf.lf_01    	-text "Base Concept - Primary Values" 
				pack $menueFrame.sf.lf_01 				-side top  -fill x  -pady 2
					create_config_cDial $menueFrame.sf.lf_01		Personal(HandleBar_Distance)	0.20  orangered
					create_config_cDial $menueFrame.sf.lf_01		Personal(HandleBar_Height)		0.20  orangered
					create_config_cDial $menueFrame.sf.lf_01		Personal(SeatTube_Length)		0.20  orangered
					create_config_cDial $menueFrame.sf.lf_01		Personal(SeatTube_Angle)		0.02  orangered
					create_config_cDial $menueFrame.sf.lf_01		Personal(InnerLeg_Length)		0.20  darkviolet
					create_config_cDial $menueFrame.sf.lf_01		Custom(TopTube/PivotPosition) 	0.20  darkviolet

				# -----------------
				#   Concept
			ttk::labelframe	$menueFrame.sf.lf_02    	-text "Base Concept - Secondary Values" 
				pack $menueFrame.sf.lf_02 				-side top  -fill x  -pady 2
					create_config_cDial $menueFrame.sf.lf_02		Component(Fork/Rake) 			0.20  darkred
					create_config_cDial $menueFrame.sf.lf_02		Component(Fork/Height) 			0.20  darkred
					create_config_cDial $menueFrame.sf.lf_02		Custom(HeadTube/Angle) 			0.02  darkred
					create_config_cDial $menueFrame.sf.lf_02		Component(Stem/Angle)			0.10  darkred
					create_config_cDial $menueFrame.sf.lf_02		Component(Stem/Length) 			0.20  darkred
					create_config_cDial $menueFrame.sf.lf_02		Custom(WheelPosition/Rear) 		0.20  darkred
					create_config_cDial $menueFrame.sf.lf_02		Custom(BottomBracket/Depth) 	0.20  darkred

				# -----------------
				#   Alternatives
			ttk::labelframe	$menueFrame.sf.lf_03    	-text "Base Concept - Alternative Values" 
				pack $menueFrame.sf.lf_03 				-side top  -fill x  -pady 2
					create_config_cDial $menueFrame.sf.lf_03		Temporary(TopTube/VirtualLength) 			0.20  darkblue
					create_config_cDial $menueFrame.sf.lf_03		Temporary(WheelPosition/front/horizontal) 	0.20  darkblue
					create_config_cDial $menueFrame.sf.lf_03		Temporary(WheelPosition/front/diagonal) 	0.20  darkblue
					create_config_cDial $menueFrame.sf.lf_03		Temporary(Saddle/Offset_BB/horizontal) 		0.20  darkblue
					create_config_cDial $menueFrame.sf.lf_03		Temporary(BottomBracket/Height) 			0.20  darkblue

				# -----------------
				#   Wheels
			ttk::labelframe	$menueFrame.sf.lf_04    	-text "Wheels" 
				pack $menueFrame.sf.lf_04 				-side top  -fill x  -pady 2
					
					create_config_cBox	$menueFrame.sf.lf_04 		Component(Wheel/Rear/RimDiameter) 	$::APPL_Env(list_Rims)	
					create_config_cDial $menueFrame.sf.lf_04		Component(Wheel/Rear/TyreHeight) 	0.20 
					create_config_cBox	$menueFrame.sf.lf_04 		Component(Wheel/Front/RimDiameter)  $::APPL_Env(list_Rims)		
					create_config_cDial $menueFrame.sf.lf_04		Component(Wheel/Front/TyreHeight) 	0.20 
					
		
				# -----------------
				#   Tube Details
			ttk::labelframe	$menueFrame.sf.lf_06    	-text "Tube Details" 
				pack $menueFrame.sf.lf_06 				-side top  -fill x  -pady 2
					create_config_cDial $menueFrame.sf.lf_06		FrameTubes(HeadTube/Length) 		0.20  darkred
					create_config_cDial $menueFrame.sf.lf_06		Component(HeadSet/Height/Bottom) 	0.20  darkred
					create_config_cDial $menueFrame.sf.lf_06		Custom(SeatTube/Extension) 			0.20  darkred
					create_config_cDial $menueFrame.sf.lf_06		Custom(SeatStay/OffsetTT)			0.20  darkred
					create_config_cDial $menueFrame.sf.lf_06		Custom(TopTube/Angle)				0.20  darkred
					create_config_cDial $menueFrame.sf.lf_06		Temporary(HeadTube/TopTubeAngle) 	0.02  darkblue
					create_config_cDial $menueFrame.sf.lf_06		Custom(TopTube/OffsetHT) 			0.20  darkred
					create_config_cDial $menueFrame.sf.lf_06		Custom(DownTube/OffsetHT) 			0.20  darkred
					create_config_cDial $menueFrame.sf.lf_06		Custom(DownTube/OffsetBB) 			0.20  darkred

				# -----------------
				#   refresh Values
			#ttk::labelframe	$menueFrame.sf.updateValues    			-text "refresh Values" 
			#	pack $menueFrame.sf.updateValues 					-side top  -fill x  -pady 2
			#pack [frame $menueFrame.sf.updateValues.f_upd] 			-fill x -expand yes -padx 3 -pady 2
			#button 	$menueFrame.sf.updateValues.f_upd.bt_update		-text {refresh}			-width 10	-command [namespace current]::init_configValues
			#	pack $menueFrame.sf.updateValues.f_upd.bt_update 	-side right
			
	}	

	#-------------------------------------------------------------------------
       #  add content 02
       #
	proc add_Detail {w} {
	
			variable APPL_Env
			variable componentList
			variable configValue
			variable compCanvas
				#
				# add content
				#
			set 	menueFrame	[ frame $w.f_menue	-relief flat -bd 1]
			pack 	$menueFrame \
				-fill both -side left -expand yes


				# -----------------
				#   build frame
			frame	 		$menueFrame.sf -relief flat -bd 1			
				pack $menueFrame.sf  		-side top  -fill x 

			
				# -----------------
				#   Components
			ttk::labelframe	$menueFrame.sf.lf_01    	-text "Components" 
				pack $menueFrame.sf.lf_01 				-side top  -fill x -pady 2 
				
				set compList {	Component/HandleBar/File \
								Component/Saddle/File \
								Component/CrankSet/File \
								Component/Brake/Front/File \
								Component/Brake/Rear/File \
								Component/Derailleur/Front/File \
								Component/Derailleur/Rear/File }
					set i 0
				foreach xPath $compList {
						set _array 	[lindex [split $xPath /] 0]
						set _name 	[string range $xPath [string length $_array/] end]
						
						incr i 1
						puts "       ... $xPath  $configValue($xPath)"
						
						set fileFrame [frame $menueFrame.sf.lf_01.f_$i]
						label $fileFrame.lb -text "  [join [lrange [lrange [split $xPath /] 1 end-1] end-1 end] {-}]:"		
						set alternatives [lib_file::get_componentAlternatives  $xPath]
						
						ttk::combobox $fileFrame.cb -textvariable [namespace current]::configValue($xPath) \
													-values $alternatives	-width 30
							pack $fileFrame 	-fill x -expand yes  -pady 2
							pack $fileFrame.cb 	-side right
							pack $fileFrame.lb 	-side left
							
							bind $fileFrame.cb <<ComboboxSelected>> [list [namespace current]::::ListboxEvent %W [format "%s::%s(%s)" project $_array $_name] select]
							bind $fileFrame.cb <ButtonPress> 		[list [namespace current]::::ListboxEvent %W [format "%s::%s(%s)" project $_array $_name] update]			
				}

				# -----------------
				#   Frame Parts
			ttk::labelframe	$menueFrame.sf.lf_04    	-text "Frame Parts" 
				pack $menueFrame.sf.lf_04 				-side top  -fill x -pady 2 
				
				set compList {	Component/Fork/Crown/File \
								Component/Fork/DropOut/File \
								Component/RearDropOut/File }
					set i 0
				foreach xPath $compList {			
						set _array 	[lindex [split $xPath /] 0]
						set _name 	[string range $xPath [string length $_array/] end]

						incr i 1
						puts "       ... $xPath  $configValue($xPath)"
						
						set fileFrame [frame $menueFrame.sf.lf_04.f_$i]
						label $fileFrame.lb -text "  [join [lrange [lrange [split $xPath /] 1 end-1] end-1 end] {-}]:"		
						set alternatives [lib_file::get_componentAlternatives  $xPath]
						ttk::combobox $fileFrame.cb -textvariable [namespace current]::configValue($xPath) \
													-values $alternatives	-width 30
							pack $fileFrame 	-fill x -expand yes  -pady 2
							pack $fileFrame.cb 	-side right
							pack $fileFrame.lb 	-side left
							
							bind $fileFrame.cb <<ComboboxSelected>> [list [namespace current]::::ListboxEvent %W [format "%s::%s(%s)" project $_array $_name] select]
							bind $fileFrame.cb <ButtonPress> 		[list [namespace current]::::ListboxEvent %W [format "%s::%s(%s)" project $_array $_name] update]
						
						
						
						
						# bind $cfgFrame.cb <<ComboboxSelected>> 	[list [namespace current]::check_Value %W $xPath [format "%s::%s(%s)" project $_array $_name]]
						
						
						
						
				}

				# -----------------
				#   Visualization
			ttk::labelframe	$menueFrame.sf.lf_05    	-text "Preview" -height 210 
				pack $menueFrame.sf.lf_05 				-side top  -fill x -pady 2
				#update
				#puts "  [info commands]\n --------------" 
				#puts "  [info commands  ::lib_config]\n --------" 
				#puts "  [info commands  ::lib_config::cv_Library]\n -------" 
				#puts "  [info commands  cv_Library]\n -------" 
				
				if {$compCanvas != {}} {
					# puts "   ... 0 $compCanvas  exists"
					# $compCanvas exists
					$compCanvas destroy
					
					#return
				} else {
					# puts "   ... 1 $compCanvas"			
				}
				
				
				set compCanvas [canvasCAD::newCanvas cv_Library $menueFrame.sf.lf_05.cvCAD "_unused_"  280  210  passive  1.0  0  -bd 2  -bg white  -relief sunken]
					# puts " ---- created $compCanvas"
				

				# -----------------
				#   Options
			ttk::labelframe	$menueFrame.sf.lf_02    	-text "Options" 
				pack $menueFrame.sf.lf_02 				-side top  -fill x -pady 2
						
						# -- Fork Types
					set optionFrame [frame $menueFrame.sf.lf_02.f_01]
					label $optionFrame.lb -text "  Fork Type"		
					ttk::combobox $optionFrame.cb 	-textvariable [format "%s::%s(%s)" project Rendering Fork] \
													-values $::APPL_Env(list_ForkTypes)		-width 30
						pack $optionFrame -fill x -expand yes  -pady 2
						pack $optionFrame.cb -side right
						pack $optionFrame.lb -side left
						
						# -- Brake Type Front
					set optionFrame [frame $menueFrame.sf.lf_02.f_02]
					label $optionFrame.lb -text "  Brake Type Front"		
					ttk::combobox $optionFrame.cb 	-textvariable [format "%s::%s(%s)" project Rendering Brake/Front] \
													-values $::APPL_Env(list_BrakeTypes)	-width 30
						pack $optionFrame -fill x -expand yes  -pady 2
						pack $optionFrame.cb -side right
						pack $optionFrame.lb -side left
						
						# -- Brake Type Rear
					set optionFrame [frame $menueFrame.sf.lf_02.f_03]
					label $optionFrame.lb -text "  Brake Type Rear"		
					ttk::combobox $optionFrame.cb 	-textvariable [format "%s::%s(%s)" project Rendering Brake/Rear] \
													-values $::APPL_Env(list_BrakeTypes)	-width 30
						pack $optionFrame -fill x -expand yes  -pady 2
						pack $optionFrame.cb -side right
						pack $optionFrame.lb -side left
						
						# -- Bottle Cage SeatTube
					set optionFrame [frame $menueFrame.sf.lf_02.f_04]
					label $optionFrame.lb -text "  BottleCage ST"		
					ttk::combobox $optionFrame.cb 	-textvariable [format "%s::%s(%s)" project Rendering BottleCage/SeatTube] \
													-values $::APPL_Env(list_BottleCage)	-width 30
						pack $optionFrame -fill x -expand yes  -pady 2
						pack $optionFrame.cb -side right
						pack $optionFrame.lb -side left
						
						# -- Bottle Cage DownTube
					set optionFrame [frame $menueFrame.sf.lf_02.f_05]
					label $optionFrame.lb -text "  BottleCage DT"		
					ttk::combobox $optionFrame.cb 	-textvariable [format "%s::%s(%s)" project Rendering BottleCage/DownTube] \
													-values $::APPL_Env(list_BottleCage)	-width 30
						pack $optionFrame -fill x -expand yes  -pady 2
						pack $optionFrame.cb -side right
						pack $optionFrame.lb -side left
						
						# -- Bottle Cage DownTube Lower
					set optionFrame [frame $menueFrame.sf.lf_02.f_06]
					label $optionFrame.lb -text "  BottleCage DT L"		
					ttk::combobox $optionFrame.cb 	-textvariable [format "%s::%s(%s)" project Rendering BottleCage/DownTube_Lower] \
													-values $::APPL_Env(list_BottleCage)	-width 30
						pack $optionFrame -fill x -expand yes  -pady 2
						pack $optionFrame.cb -side right
						pack $optionFrame.lb -side left
				
				# -----------------
				#   Update Values
			#ttk::labelframe	$menueFrame.sf.updateValues    					-text "update Values" 
			#	pack $menueFrame.sf.updateValues 							-side top  -fill x  -pady 2
			#		pack [frame $menueFrame.sf.updateValues.f_upd] 			-fill x -expand yes -padx 3 -pady 2
			#		button 	$menueFrame.sf.updateValues.f_upd.bt_update		-text {update}			-width 10	-command [namespace current]::update_Rendering
			#			pack $menueFrame.sf.updateValues.f_upd.bt_update 	-side right
						
	}	


	

	#-------------------------------------------------------------------------
       #  ListboxEvent Event
       #
	proc ListboxEvent {w targetVar mode} {
				# http://www.tek-tips.com/viewthread.cfm?qid=822756&page=42
				# 2010.10.15
			variable compFile
			#puts [$w get]
			set compFile [$w get]
				puts ""
				puts "   -------------------------------"
				puts "    ListboxEvent"
				puts "       compFile:       $compFile"
			[namespace current]::::updateCanvas
			if {$mode == {select}} {
				eval set $targetVar $compFile
			}
	}

	#-------------------------------------------------------------------------
       #  create config_line
       #
	proc updateCanvas {} {
			variable compCanvas
			variable compFile

				puts ""
				puts "   -------------------------------"
				puts "    updateCanvas"
				puts "       compFile:       $compFile"
			
			switch -glob $compFile {
				etc:*  {  set compFile  [file join $::APPL_Env(CONFIG_Dir) components [lindex [split $compFile {:}] 1] ] }
				user:* {  set compFile  [file join $::APPL_Env(USER_Dir)   components [lindex [split $compFile {:}] 1] ] }
				default {}
			}	
				puts "       compFile:       $compFile"

			$compCanvas clean_StageContent
			if {$compFile != {}} {
				set __my_Component__		[ $compCanvas readSVG $compFile {0 0} 0  __Decoration__ ]
				$compCanvas fit2Stage $__my_Component__
				$compCanvas refitStage
			}
	}



	#-------------------------------------------------------------------------
       #  postion config panel to main window
       #
	proc reposition_to_main {main w} {
		
			variable cfg_Position
			
			if {![winfo exists $w]} return
			
			# wm deiconify   $w
			
			set root_xy [split  [wm geometry $main] +]
			set root_w 	[winfo width $main]
			set root_x	[lindex $root_xy 1]
			set root_y	[lindex $root_xy 2]
			
			set update no
			set update no
			
			if {$root_x != [lindex $cfg_Position 0]} {set update yes}
			if {$root_y != [lindex $cfg_Position 1]} {set update yes}
			if {$root_w != [lindex $cfg_Position 2]} {set update resize}
			
			switch $update {
				yes {	
						set dx [lindex $cfg_Position 3]
						set dy [lindex $cfg_Position 4]
						catch {wm geometry	$w +[expr $root_x+$dx]+[expr $root_y+$dy]}	
					}
				resize {
						set d_root [expr $root_w - [lindex $cfg_Position 2]]
						set dx [ expr [lindex $cfg_Position 3] + $d_root ]
						set dy [lindex $cfg_Position 4]
						catch {wm geometry	$w +[expr $root_x+$dx]+[expr $root_y+$dy]}
				}
			}
	}
	
	#-------------------------------------------------------------------------
       #  register_relative_position
       #
	proc register_relative_position {main w} {
		
			variable cfg_Position
			
			set root_xy [split  [wm geometry $main] +]
			set root_w 	[winfo width $main]
			set root_x	[lindex $root_xy 1]
			set root_y	[lindex $root_xy 2]		
				# puts "    main: $main: $root_x  $root_y"
			
			set w_xy [split  [wm geometry $w] +]
				# puts "    w   .... $w_xy"
			set w_x	[lindex $w_xy 1]
			set w_y	[lindex $w_xy 2]
				# puts "    w   ..... $w: $w_x  $w_y"
			set d_x 	[ expr $w_x-$root_x]
			set d_y 	[ expr $w_y-$root_y]
				# puts "    w   ..... $w: $d_x  $d_y"
				# puts "    w   ..... $root_x $root_y $d_x $d_y"			
			set cfg_Position [list $root_x $root_y $root_w $d_x $d_y ]
				# puts "     ... register_relative_position $cfg_Position"
	}
	#-------------------------------------------------------------------------
       #  create config_line
       #
	proc init_configValues {} {		
			
			variable componentList
			
			proc recurseInsert { node parent} {			
					# puts "    ... recurseInsert .. [$node toXPath]"
				variable componentList
				
				set name [$node nodeName]
					# puts "\n    ... recurseInsert .. name: $name"
				switch $name {
					"Project" -
					"#text" -
					"#comment" -
					"cdata" {}
					default {
							#puts "[Tree:newItem .f.w [$node toXPath] -image idir]"
							# puts "    ... recurseInsert .. [$node toXPath]"
							foreach childNode [$node childNodes] {
								set name [$childNode nodeName]
								switch $name {
									"#text" { 		# puts "    ... recurseInsert .. [$node toXPath]" 
												set value 		[$childNode asText]
												set xPath		[$node toXPath]	
												set labelString	[string map "{/} { / }" $xPath ]	
												set xPathString	[string map "{/root/} {}" $xPath ]	
													# puts "   ... $node "
													# puts "     ... $value "
													# puts "     $xPathString  $value"
												if {[llength $value] == 1} {
													if {[llength [split $value ',']] == 1} {
														set [namespace current]::configValue($xPathString) [ frame_geometry::set_projectValue $xPathString $value format]
													}
												}
												if {[file tail $xPath] == {File}} { 
														# puts "   [file tail $xPath]   $xPath"
														# puts "        ... [llength $componentList]"
													lappend componentList $xPathString
														# puts "        ... [llength $componentList]"
														# puts "                $componentList"
												}

												
											}

									default { recurseInsert $childNode $node }
								}
							}
					}
				}
			}
			recurseInsert 	[$::APPL_Env(root_ProjectDOM) selectNodes /root]  {/}

			# parray [namespace current]::configValue
			#foreach file $componentList {
				#puts "    ... $file"
			#}
			return			
	}

	
	#-------------------------------------------------------------------------
       #  create config_line
       #
	proc create_config_cDial {w _arrayName scale {color {}}} {		
			
			variable	rdials_list
			variable	configValue
			set _array [lindex [split $_arrayName (] 0]
			set _name [lindex [split $_arrayName ()] 1]


			set xPath		[format "%s/%s" $_array $_name]
			eval set configValue($xPath)	[format "$%s::%s(%s)" project $_array $_name]	
			set labelString	$_name
				# set node		[$::APPL_Env(root_ProjectDOM) selectNodes $xPath]
				# set childNode	[$node childNodes]
				# set value 		[$childNode asText]
				# set labelString	[string map "{/} { / }" [string map "$labelCut {}" $xPath] ]	
			
			
				# --------------			
					# puts "    .. check ..     $xPath    "
					# puts "    .. check ..     [namespace current]::configValue($xPath)    "
			set rdialCount [llength $rdials_list]
					# puts "      ... $rdialCount"
					# set 		$entryVar $current
					# puts "   ... \$entryVar [list [format "$%s" $entryVar]]"

			set cfgFrame	[frame   [format "%s.fscl_%s" $w $rdialCount]]
			pack    $cfgFrame
			
			if {[string length $labelString] > 29} {
				set labelString "[string range $labelString 0 26] .."
			}
			label   $cfgFrame.lb	-text "   $labelString"      \
							-width 25  \
							-bd 1  -anchor w 

			entry   $cfgFrame.cfg	\
							-textvariable [namespace current]::configValue($xPath) \
							-width  7  \
							-bd 1  -justify right -bg white 
							
			frame	$cfgFrame.f	-relief sunken \
							-bd 2 -padx 2 -pady 0

			rdial::create   $cfgFrame.f.scl	\
							-value		$configValue($xPath) \
							-scale		$scale \
							-step		12 \
							-height		11 \
							-width		60 \
							-orient		horizontal \
							-callback	[list  [namespace current]::updateEntry	  [namespace current]::configValue($xPath)  [format "%s::%s(%s)" project $_array $_name] ]
							

			if {$color != {}} {
				$cfgFrame.lb  configure -fg $color 
				$cfgFrame.cfg configure -fg $color
			}
							
					
								
			lappend rdials_list $cfgFrame.f.scl
				bind $cfgFrame.cfg <Enter> 		[list [namespace current]::enterEntry $cfgFrame.cfg]
				bind $cfgFrame.cfg <Leave> 		[list [namespace current]::leaveEntry $cfgFrame.cfg [format "%s::%s(%s)" project $_array $_name]]
				bind $cfgFrame.cfg <Return> 	[list [namespace current]::leaveEntry $cfgFrame.cfg [format "%s::%s(%s)" project $_array $_name]]
			pack      $cfgFrame.lb  $cfgFrame.cfg  $cfgFrame.f  $cfgFrame.f.scl -side left  -fill x	
			# pack      $cfgFrame.lb  $cfgFrame.cfg  $cfgFrame.f  $cfgFrame.f.scl $cfgFrame.bt   -side left  -fill x	
			pack      configure $cfgFrame.f  -padx 2	
	}	
	proc updateEntry {{entryVar {}}  targetVar {value {0}} {drag_Event {}} } {
			# puts "\n entryVar:    $entryVar"
			# puts "\n target_Var:  $target_Var"
			# puts "\n value:       $value"
			# puts "\n drag_Event:  $drag_Event"
			
			set value [format "%.2f" $value]
			if {$entryVar ne ""} {
					# reformat value
				eval set $entryVar 		$value
			}
			if {$drag_Event == {release}} {
				eval set $targetVar 	$value
			}
 	}
	proc enterEntry {entry} {
			set entryVar [$entry cget -text]
			eval set currentValue 	[expr 1.0 * \$$entryVar]
			set value [format "%.2f" $currentValue]
			set [namespace current]::configValue(entry) $value
	}
	proc leaveEntry {entry targetVar} {
				# puts "[$entry cget -text]"
			set entryVar [$entry cget -text]
			eval set currentValue 	[expr 1.0 * \$$entryVar]
			eval set oldValue	$[namespace current]::configValue(entry)
				# puts "     \$oldValue $oldValue"

			if {$currentValue == $oldValue} {
				return
			}
			
				# puts "   .. super is anders: $currentValue != $oldValue"
			
			set value [format "%.2f" $currentValue]
			if {$entryVar ne ""} {
				eval set $entryVar 	$value	; # reformat value
			}
			eval set $targetVar 	$value
 	}
	
	

	
	#-------------------------------------------------------------------------
       #  create config_line
       #
	proc create_config_cBox {w _arrayName contentList} {		
			

			variable	cboxList
			variable	configValue
			set _array [lindex [split $_arrayName (] 0]
			set _name [lindex [split $_arrayName ()] 1]


			set xPath		[format "%s/%s" $_array $_name]
			eval set configValue($xPath)	[format "$%s::%s(%s)" project $_array $_name]	
			set labelString	$_name
				# set node		[$::APPL_Env(root_ProjectDOM) selectNodes $xPath]
				# set childNode	[$node childNodes]
				# set value 		[$childNode asText]
				# set labelString	[string map "{/} { / }" [string map "$labelCut {}" $xPath] ]	
			
				# --------------			
					# puts "    .. check ..     $xPath    "
					# puts "    .. check ..     [namespace current]::configValue($xPath)    "
			set cboxCount [llength $cboxList]
					# puts "      ... \$cboxCount $cboxCount"
					# puts "      ... $rdialCount"
					# set 		$entryVar $current
					# puts "   ... \$entryVar [list [format "$%s" $entryVar]]"

			set cfgFrame	[frame   [format "%s.fcbx_%s" $w $cboxCount]]
			pack    $cfgFrame -fill x
			
			if {[string length $labelString] > 29} {
				set labelString "[string range $labelString 0 26] .."
			}
			label   $cfgFrame.lb	-text "   $labelString:"      \
							-bd 1  -anchor w 

			ttk::combobox $cfgFrame.cb \
							-textvariable [namespace current]::configValue($xPath) \
							-values $contentList	\
							-width 17 \
							-height 10 \
							-justify right \
							-postcommand [list eval set [namespace current]::oldValue \$[namespace current]::configValue($xPath)]
							
							
			lappend cboxList $cfgFrame.cb
			
				bind $cfgFrame.cb <<ComboboxSelected>> 	[list [namespace current]::check_Value %W $xPath [format "%s::%s(%s)" project $_array $_name]]
				
			pack      $cfgFrame.lb	-side left  	
			pack      $cfgFrame.cb	-side right  -fill x	
	}
	proc check_Value { w xPath targetVar} {
		
		variable configValue
		variable oldValue
		
 		switch $xPath {
				{Component/Wheel/Rear/RimDiameter} -
				{Component/Wheel/Front/RimDiameter} {
						if {[string range $configValue($xPath) 0 3] == "----"} {
								# puts "   ... change value"
							set configValue($xPath) $oldValue
						} else {
								# puts "   ... $configValue($xPath)"
								# puts "      >[split $configValue($xPath) ;]<"
								# puts "      >[lindex [split $configValue($xPath) ;] 0]<"
							set value [string trim [lindex [split $configValue($xPath) ;] 0]]
							set value [format "%.2f" $value]
							set configValue($xPath)  $value
								# puts "   ... $configValue($xPath)"
								# puts "   ... $targetVar"
							eval set $targetVar $value
						}	
					}
		}
	}	
	#-------------------------------------------------------------------------
       #  update Config
       #
	proc registerUpdate {{entryVar ""}  {value {0}} } {
			
					puts "\n"
					puts "  -------------------------------------------"
					puts "   ... entryVar $entryVar"
					puts "   ... value    $value"
				
			if {$value == 0} {
				set textVar 	$entryVar
				# puts "    textVar 	$textVar"
				eval set value	 	[format "%s" $$textVar]
				# puts "    value 	$value"
			}
			
			if {$entryVar ne ""} {
					# reformat value
				set $entryVar [ frame_geometry::set_projectValue _any_ $value format]
			}
			
 	}


	#-------------------------------------------------------------------------
       #  update configured frame
       #
	proc remove__updateConfig {{xPath {}} {cfgEntry {}}} {
	
			variable configValue

					# puts "\n"
					# puts "  -------------------------------------------"
					# puts "   ... xPath    $xPath"
					# puts "   ... cfgEntry $cfgEntry"
					# puts "   ...          $configValue($xPath)"

					# -----------------------------
					# get current Tab
				set cv			[ $lib_gui::noteBook_top select ]	
				set varName		[ lib_gui::notebook_getVarName $cv ]
				if {[string range $varName 0 1] == {::}} { set varName [string range $varName 2 end] }
				
				set refValue			[ [ $::APPL_Env(root_ProjectDOM) selectNodes /root/$xPath ]  asText ]
				set configValue($xPath) [ frame_geometry::set_projectValue $xPath $configValue($xPath) format]				

					# -----------------------------
					#   check if there is a change
				if {$configValue($xPath) == $refValue} {
						# puts "    ... no update necessary!"
					return
				}
				frame_geometry::set_projectValue $xPath $configValue($xPath)			
				
					# -----------------------------
					#   update Geometry
				frame_geometry::updateConfig   	$varName   cv_custom::update	_update_ 	 
				
					# -----------------------------
					#   focus entry
				focus $cfgEntry
 	}


	#-------------------------------------------------------------------------
       #  update_Rendering
       #
	proc update_Rendering {} {
	
		variable componentList
		variable configValue
		
		foreach xPath $componentList {
			frame_geometry::set_projectValue $xPath $configValue($xPath)								
		}
		
		foreach xPath {	Rendering/Fork 
						Rendering/Brake/Front
						Rendering/Brake/Rear
						Rendering/BottleCage/SeatTube 
						Rendering/BottleCage/DownTube 
						Rendering/BottleCage/DownTube_Lower
		} {
			frame_geometry::set_projectValue $xPath $configValue($xPath)								
		}
						
		set cv			[ $lib_gui::noteBook_top select ]	
		set varName		[ lib_gui::notebook_getVarName $cv ]
		if {[string range $varName 0 1] == {::}} { set varName [string range $varName 2 end] }
		
		frame_geometry::updateConfig   	$varName   cv_custom::update	_update_ 	 
				
	}

	
}

