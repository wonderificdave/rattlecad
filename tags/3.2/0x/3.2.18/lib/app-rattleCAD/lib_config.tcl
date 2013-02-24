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
			$nb_Config add [frame $nb_Config.basic] 	-text "Geometry" 		
			$nb_Config add [frame $nb_Config.detail] 	-text "Components" 
		
				# -----------------
				# add content
			add_Basic 	$nb_Config.basic
			add_Detail 	$nb_Config.detail
			
				# -----------------
				#
			wm resizable	$w  0 0
				#	wm  withdraw   $w			
			
			return
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
				#   Geometry
			ttk::labelframe	$menueFrame.sf.lf_01    	-text "Geometry" 
				pack $menueFrame.sf.lf_01 				-side top  -fill x  -pady 2
					create_config_cDial $menueFrame.sf.lf_01		{Custom/WheelPosition/Rear} 		{Custom/}		0.20 [namespace current]::registerUpdate darkred
					create_config_cDial $menueFrame.sf.lf_01		{Custom/WheelPosition/Front} 		{Custom/}		0.20 [namespace current]::registerUpdate darkred
					create_config_cDial $menueFrame.sf.lf_01		{Custom/BottomBracket/Depth} 		{Custom/}		0.20 [namespace current]::registerUpdate darkred
				
				# -----------------
				#   Wheels
			ttk::labelframe	$menueFrame.sf.lf_02    	-text "Wheels" 
				pack $menueFrame.sf.lf_02 				-side top  -fill x  -pady 2
					
					create_config_cBox	$menueFrame.sf.lf_02 		{Component/Wheel/Rear/RimDiameter} 	{Component/} 		 [namespace current]::registerUpdate $::APPL_RimList		
					create_config_cDial $menueFrame.sf.lf_02		{Component/Wheel/Rear/TyreHeight} 	{Component/}	0.20 [namespace current]::registerUpdate
					create_config_cBox	$menueFrame.sf.lf_02 		{Component/Wheel/Front/RimDiameter} {Component/} 		 [namespace current]::registerUpdate $::APPL_RimList		
					create_config_cDial $menueFrame.sf.lf_02		{Component/Wheel/Front/TyreHeight} 	{Component/}	0.20 [namespace current]::registerUpdate
		
				# -----------------
				#   Front
			ttk::labelframe	$menueFrame.sf.lf_03    	-text "Front" 
				pack $menueFrame.sf.lf_03 				-side top  -fill x  -pady 2
					create_config_cDial $menueFrame.sf.lf_03		{Personal/HandleBar_Height}			{Personal/}  	0.20 [namespace current]::registerUpdate darkred
					create_config_cDial $menueFrame.sf.lf_03		{Personal/HandleBar_Distance}		{Personal/}  	0.20 [namespace current]::registerUpdate darkred
					create_config_cDial $menueFrame.sf.lf_03		{Component/Fork/Height} 			{Component/}	0.20 [namespace current]::registerUpdate
					create_config_cDial $menueFrame.sf.lf_03		{Component/Fork/Rake} 				{Component/}	0.20 [namespace current]::registerUpdate
					create_config_cDial $menueFrame.sf.lf_03		{FrameTubes/HeadTube/Length} 		{FrameTubes/}	0.20 [namespace current]::registerUpdate
					create_config_cDial $menueFrame.sf.lf_03		{Component/HeadSet/Height/Bottom} 	{Component/}	0.20 [namespace current]::registerUpdate
					create_config_cDial $menueFrame.sf.lf_03		{Component/Stem/Angle} 				{Component/}	0.10 [namespace current]::registerUpdate
					create_config_cDial $menueFrame.sf.lf_03		{Component/Stem/Length} 			{Component/}	0.20 [namespace current]::registerUpdate
		
				# -----------------
				#   Saddle
			ttk::labelframe	$menueFrame.sf.lf_04    	-text "Saddle" 
				pack $menueFrame.sf.lf_04 				-side top  -fill x  -pady 2
					create_config_cDial $menueFrame.sf.lf_04		{Personal/SeatTube_Angle} 			{Personal/}  	0.02 [namespace current]::registerUpdate darkred
					create_config_cDial $menueFrame.sf.lf_04		{Personal/SeatTube_Length} 			{Personal/}  	0.20 [namespace current]::registerUpdate darkred
					create_config_cDial $menueFrame.sf.lf_04		{Custom/SeatTube/Extension} 		{Custom/}		0.20 [namespace current]::registerUpdate
					create_config_cDial $menueFrame.sf.lf_04		{Custom/SeatStay/OffsetTT} 			{Custom/}		0.20 [namespace current]::registerUpdate
					create_config_cDial $menueFrame.sf.lf_04		{Custom/TopTube/Angle} 				{Custom/}		0.20 [namespace current]::registerUpdate
					create_config_cDial $menueFrame.sf.lf_04		{Custom/TopTube/PivotPosition} 		{Custom/}		0.20 [namespace current]::registerUpdate
				
				# -----------------
				#   Result
			ttk::labelframe	$menueFrame.sf.lf_05    	-text "Alternative" 
				pack $menueFrame.sf.lf_05 				-side top  -fill x -pady 2 
					create_config_cDial $menueFrame.sf.lf_05		{Result/WheelPosition/front/horizontal} {Result/}	0.20 [namespace current]::registerUpdate darkred
					create_config_cDial $menueFrame.sf.lf_05		{Result/HeadTube/Angle} 				{Result/}	0.02 [namespace current]::registerUpdate darkred
					create_config_cDial $menueFrame.sf.lf_05		{Result/Saddle/Offset_BB/horizontal} 	{Result/}	0.20 [namespace current]::registerUpdate darkred
				
				# -----------------
				#   Geometry
			ttk::labelframe	$menueFrame.sf.lf_06    	-text "Tubes" 
				pack $menueFrame.sf.lf_06 				-side top  -fill x -pady 2
					create_config_cDial $menueFrame.sf.lf_06		{Custom/DownTube/OffsetHT} 				{Custom/}	0.20 [namespace current]::registerUpdate
					create_config_cDial $menueFrame.sf.lf_06		{Custom/DownTube/OffsetBB} 				{Custom/}	0.20 [namespace current]::registerUpdate
					create_config_cDial $menueFrame.sf.lf_06		{Custom/TopTube/OffsetHT} 				{Custom/}	0.20 [namespace current]::registerUpdate

				# -----------------
				#   refresh Values
			ttk::labelframe	$menueFrame.sf.updateValues    			-text "refresh Values" 
				pack $menueFrame.sf.updateValues 					-side top  -fill x  -pady 2
			pack [frame $menueFrame.sf.updateValues.f_upd] 			-fill x -expand yes -padx 3 -pady 2
			button 	$menueFrame.sf.updateValues.f_upd.bt_update		-text {refresh}			-width 10	-command [namespace current]::init_configValues
				pack $menueFrame.sf.updateValues.f_upd.bt_update 	-side right
			
	}	

	#-------------------------------------------------------------------------
       #  add content 02
       #
	proc add_Detail {w} {
	
			variable componentList
			variable configValue
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
								Component/Derailleur/File }
					set i 0
				foreach xPath $compList {
					incr i 1
					puts "    ... $xPath  $configValue($xPath)"
					
					set fileFrame [frame $menueFrame.sf.lf_01.f_$i]
					label $fileFrame.lb -text "  [join [lrange [lrange [split $xPath /] 1 end-1] end-1 end] {-}]:"		
					set alternatives [lib_file::get_componentAlternatives  $xPath]
					ttk::combobox $fileFrame.cb -textvariable [namespace current]::configValue($xPath) \
												-values $alternatives	-width 30
						pack $fileFrame 	-fill x -expand yes  -pady 2
						pack $fileFrame.cb 	-side right
						pack $fileFrame.lb 	-side left
				}

				# -----------------
				#   Options
			ttk::labelframe	$menueFrame.sf.lf_02    	-text "Options" 
				pack $menueFrame.sf.lf_02 				-side top  -fill x -pady 2
						
						# -- Fork Types
					set optionFrame [frame $menueFrame.sf.lf_02.f_01]
					label $optionFrame.lb -text "  Fork Types"		
					ttk::combobox $optionFrame.cb 	-textvariable [namespace current]::configValue(Rendering/Fork) \
													-values $::APPL_ForkTypes		-width 30
						pack $optionFrame -fill x -expand yes  -pady 2
						pack $optionFrame.cb -side right
						pack $optionFrame.lb -side left
						
						# -- Brake Types
					set optionFrame [frame $menueFrame.sf.lf_02.f_02]
					label $optionFrame.lb -text "  Brake Types"		
					ttk::combobox $optionFrame.cb 	-textvariable [namespace current]::configValue(Rendering/Brakes) \
													-values $::APPL_BrakeTypes	-width 30
						pack $optionFrame -fill x -expand yes  -pady 2
						pack $optionFrame.cb -side right
						pack $optionFrame.lb -side left
				
				# -----------------
				#   Frame Parts
			ttk::labelframe	$menueFrame.sf.lf_03    	-text "Frame Parts" 
				pack $menueFrame.sf.lf_03 				-side top  -fill x -pady 2 
				
				set compList {	Component/Fork/Crown/File \
								Component/Fork/DropOut/File \
								Component/RearDropOut/File }
					set i 0
				foreach xPath $compList {
					incr i 1
					puts "    ... $xPath  $configValue($xPath)"
					
					set fileFrame [frame $menueFrame.sf.lf_03.f_$i]
					label $fileFrame.lb -text "  [join [lrange [lrange [split $xPath /] 1 end-1] end-1 end] {-}]:"		
					set alternatives [lib_file::get_componentAlternatives  $xPath]
					ttk::combobox $fileFrame.cb -textvariable [namespace current]::configValue($xPath) \
												-values $alternatives	-width 30
						pack $fileFrame 	-fill x -expand yes  -pady 2
						pack $fileFrame.cb 	-side right
						pack $fileFrame.lb 	-side left
				}

				# -----------------
				#   Update Values
			ttk::labelframe	$menueFrame.sf.updateValues    					-text "update Values" 
				pack $menueFrame.sf.updateValues 							-side top  -fill x  -pady 2
					pack [frame $menueFrame.sf.updateValues.f_upd] 			-fill x -expand yes -padx 3 -pady 2
					button 	$menueFrame.sf.updateValues.f_upd.bt_update		-text {update}			-width 10	-command [namespace current]::update_Rendering
						pack $menueFrame.sf.updateValues.f_upd.bt_update 	-side right
						
								
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
												#set [namespace current]::configValue($xPathString) $value
												set [namespace current]::configValue($xPathString) [ frame_geometry_custom::set_projectValue $xPathString $value format]
												
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
			recurseInsert [$::APPL_Project selectNodes /root]  {/}

			# parray [namespace current]::configValue
			#foreach file $componentList {
				#puts "    ... $file"
			#}
			return			
	}

	
	#-------------------------------------------------------------------------
       #  create config_line
       #
	proc create_config_cDial {w xPath labelCut scale command {color {}}} {		
			
			variable	rdials_list
			variable	configValue

			set node		[$::APPL_Project selectNodes $xPath]
			set childNode	[$node childNodes]
			set value 		[$childNode asText]
			set labelString	[string map "{/} { / }" [string map "$labelCut {}" $xPath] ]	
			
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
							-callback	[list   	  $command	[namespace current]::configValue($xPath) ]
							
			button 	$cfgFrame.bt -image $lib_gui::iconArray(confirm)
					$cfgFrame.bt configure -command \
								[list [namespace current]::updateConfig $xPath $cfgFrame.cfg]

			if {$color != {}} {
				$cfgFrame.lb  configure -fg $color 
				$cfgFrame.cfg configure -fg $color
			}
							
					
								
			lappend rdials_list $cfgFrame.f.scl
				bind $cfgFrame.cfg <Leave> 		[list [namespace current]::updateConfig $xPath $cfgFrame.cfg]
				bind $cfgFrame.cfg <Return> 	[list [namespace current]::updateConfig $xPath $cfgFrame.cfg]
			pack      $cfgFrame.lb  $cfgFrame.cfg  $cfgFrame.f  $cfgFrame.f.scl $cfgFrame.bt   -side left  -fill x	
			pack      configure $cfgFrame.f  -padx 2	
	}	

	
	#-------------------------------------------------------------------------
       #  create config_line
       #
	proc create_config_cBox {w xPath labelCut command contentList} {		
			

			variable	cboxList
			variable	configValue

			set node		[$::APPL_Project selectNodes $xPath]
			set childNode	[$node childNodes]
			set value 		[$childNode asText]
			set labelString	[string map "{/} { / }" [string map "$labelCut {}" $xPath] ]	
			
				# --------------			
					# puts "    .. check ..     $xPath    "
					# puts "    .. check ..     [namespace current]::configValue($xPath)    "
			set cboxCount [llength $cboxList]
					# puts "      ... $rdialCount"
					# set 		$entryVar $current
					# puts "   ... \$entryVar [list [format "$%s" $entryVar]]"

			set cfgFrame	[frame   [format "%s.fscl_%s" $w $cboxCount]]
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
							
			button 	$cfgFrame.bt -image $lib_gui::iconArray(confirm)
					$cfgFrame.bt configure -command \
								[list [namespace current]::updateConfig $xPath ]
							
			lappend cboxList $cfgFrame.cb
			
				bind $cfgFrame.cb <<ComboboxSelected>> 	[list [namespace current]::check_Value %W $xPath]
				
			pack      $cfgFrame.lb	-side left  	
			pack      $cfgFrame.bt	-side right  	
			pack      $cfgFrame.cb	-side right  -fill x	
	}	

	
	#-------------------------------------------------------------------------
       #  update Config
       #
	proc registerUpdate {{entryVar ""}  {value {0}} } {
			
					# puts "\n"
					# puts "  -------------------------------------------"
					# puts "   ... entryVar $entryVar"
					# puts "   ... value    $value"
				
			if {$value == 0} {
				set textVar 	$entryVar
				# puts "    textVar 	$textVar"
				eval set value	 	[format "%s" $$textVar]
				# puts "    value 	$value"
			}
			
			if {$entryVar ne ""} {
					# reformat value
				set $entryVar [ frame_geometry_custom::set_projectValue _any_ $value format]
			}
			
 	}
	

	#-------------------------------------------------------------------------
       #  update configured frame
       #
	proc updateConfig {{xPath {}} {cfgEntry {}}} {
	
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
				
				set refValue			[ [ $::APPL_Project selectNodes /root/$xPath ]  asText ]
				set configValue($xPath) [ frame_geometry_custom::set_projectValue $xPath $configValue($xPath) format]				

					# -----------------------------
					#   check if there is a change
				if {$configValue($xPath) == $refValue} {
						# puts "    ... no update necessary!"
					return
				}
				frame_geometry_custom::set_projectValue $xPath $configValue($xPath)			
				
					# -----------------------------
					#   update Geometry
				frame_geometry_custom::updateConfig   	$varName   cv_custom_00::update	_update_ 	 
				
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
			frame_geometry_custom::set_projectValue $xPath $configValue($xPath)								
		}
		
		foreach xPath {Rendering/Fork Rendering/Brakes} {
			frame_geometry_custom::set_projectValue $xPath $configValue($xPath)								
		}
				
		set cv			[ $lib_gui::noteBook_top select ]	
		set varName		[ lib_gui::notebook_getVarName $cv ]
		if {[string range $varName 0 1] == {::}} { set varName [string range $varName 2 end] }
		
		frame_geometry_custom::updateConfig   	$varName   cv_custom_00::update	_update_ 	 
				
	}

	
	#-------------------------------------------------------------------------
       #  check Value
       #
	proc check_Value { w xPath args} {
		
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
						}
					}
		}
	}
	
}

