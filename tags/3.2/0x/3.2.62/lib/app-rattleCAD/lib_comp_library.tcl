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

 namespace eval lib_comp_library {
                            
	variable	compCanvas  {}
	variable 	menueFrame	{}
	
	variable	compList_System {}
	variable	compList_Custom {}
	variable	rdials_list	{}
	
	variable 	compFile  {}

	variable 	configValue
	  array set configValue {
	}


	#-------------------------------------------------------------------------
       #  create report widget
       #
	proc createLibrary {w} {
		variable compCanvas
		variable menueFrame

		variable	compList_System
		variable	compList_Custom
		
		
		pack [ frame $w.f -bg yellow] -fill both -expand yes
		set menueFrame	[ frame $w.f.f_menue	-relief flat -bd 1]
		set canvasFrame [ frame $w.f.f_canvas ]
		pack 	$menueFrame \
				$canvasFrame\
			-fill both -side left
		pack configure $canvasFrame -expand yes	

			# -- file Listbox
		ttk::labelframe	$menueFrame.lf  -text "FileList" -width 34 
			pack $menueFrame.lf  -expand no -fill x
		set nb_fileList	[ ttk::notebook $menueFrame.lf.nb ]
			pack $nb_fileList  	-expand no -fill both   
		$nb_fileList add [frame $nb_fileList.system] 	-text "... system" 		
		$nb_fileList add [frame $nb_fileList.custom] 	-text "... custom" 
			# -- system Content
		set f_system	[ frame 	$nb_fileList.system.f ]
			pack 	$f_system -side top  -expand no -fill none
			listbox   $f_system.lbox \
						  -listvariable   [namespace current]::compList_System \
						  -selectmode     single \
						  -relief         sunken \
						  -width		  27 \
						  -height		  15 \
						  -yscrollcommand "$f_system.scb_y  set" \
						  -xscrollcommand "$f_system.scb_x  set" 							  
			scrollbar $f_system.scb_y \
						  -orient         v \
						  -command        "$f_system.lbox yview"
			scrollbar $f_system.scb_x \
						  -orient         h \
						  -command        "$f_system.lbox xview"
											  
			grid	$f_system.lbox 	$f_system.scb_y	-sticky news
			grid					$f_system.scb_x	-sticky news

		bind $f_system.lbox <<ListboxSelect>> [list [namespace current]::::ListboxChanged %W]
		
			# -- customContent
		set f_custom	[ frame 	$nb_fileList.custom.f ]
			pack 	$f_custom -side top  -expand no -fill none
			listbox   $f_custom.lbox \
						  -listvariable   [namespace current]::compList_Custom \
						  -selectmode     single \
						  -relief         sunken \
						  -width		  27 \
						  -height		  15 \
						  -yscrollcommand "$f_custom.scb_y  set" \
						  -xscrollcommand "$f_custom.scb_x  set" 							  
			scrollbar $f_custom.scb_y \
						  -orient         v \
						  -command        "$f_custom.lbox yview"
			scrollbar $f_custom.scb_x \
						  -orient         h \
						  -command        "$f_custom.lbox xview"
											  
			grid	$f_custom.lbox 	$f_custom.scb_y	-sticky news
			grid					$f_custom.scb_x	-sticky news
			
		bind $f_custom.lbox <<ListboxSelect>> [list [namespace current]::::ListboxChanged %W]

			# -- Button
			# -- ButtonFrame
		frame	 		$menueFrame.bf -relief flat -bd 1			
		ttk::labelframe	$menueFrame.bf.update   -text "Update" 			
		ttk::labelframe	$menueFrame.bf.scale    -text "Positioning" 
			pack $menueFrame.bf  		-side top  -fill x 
			pack $menueFrame.bf.update  \
				 $menueFrame.bf.scale   -expand yes  -side top  -fill x  -pady 4

			# -- Button
		button 	$menueFrame.bf.update.l_clear	-text {clear List}			-width 20	-command [list [namespace current]::update_compList {clear} ]
        button 	$menueFrame.bf.update.l_update	-text {update List}			-width 20	-command [list [namespace current]::update_compList {} ]
		button 	$menueFrame.bf.update.c_update	-text {update Canvas}		-width 20	-command [list [namespace current]::updateCanvas]
		pack 	$menueFrame.bf.update.l_clear \
				$menueFrame.bf.update.l_update \
				$menueFrame.bf.update.c_update \
				-side top

			# -- Scale
		create_config_line $menueFrame.bf.scale.off_x	"Offset x"	[namespace current]::configValue(compOffset_X)  -180 0.0 180	 1	  [list [namespace current]::updateCanvas]
		create_config_line $menueFrame.bf.scale.off_y	"Offset y"	[namespace current]::configValue(compOffset_y)  -180 0.0 180	 1	  [list [namespace current]::updateCanvas]
		create_config_line $menueFrame.bf.scale.angle	"Angle"	 	[namespace current]::configValue(compAngle)     -180 0.0 180	 1	  [list [namespace current]::updateCanvas]
		pack 	$menueFrame.bf.scale.off_x \
		        $menueFrame.bf.scale.off_y \
				$menueFrame.bf.scale.angle \
				-side top
				
		button 	$menueFrame.bf.scale.reset	-text {reset}			-width 20	-command [list [namespace current]::reset_Positioning ] 
		pack 	$menueFrame.bf.scale.reset \
				-side top


		set compCanvas 	[ canvasCAD::newCanvas	cv_Component $canvasFrame.cv  "Components" 550 550 A3 1  40  -bd 2   -bg lightgray  -relief sunken ]
		set tabID		[string map {/ . } [string map {. /} $w] ] 
			# puts "\n  ... register:  $tabID $compCanvas"
		lib_gui::register_external_canvasCAD $tabID $compCanvas
		
	}

	
	#-------------------------------------------------------------------------
       #  ListboxChanged Event
       #
	proc ListboxChanged {w} {
				# http://www.tek-tips.com/viewthread.cfm?qid=822756&page=42
				# 2010.10.15
				# puts -nonewline "Listbox $w selection is now: "
		variable compFile

		foreach index [$w curselection] {
			set compFile [$w get $index]
			puts "  $index $compFile"
			[namespace current]::::updateCanvas
		}
	}

	
	#-------------------------------------------------------------------------
       #  update Component FileList
       #
	proc update_compList {{mode {}}} {
		variable	compList_System
		variable	compList_Custom
		
		if {[string match $mode {clear}]} { 
			puts "    ... update_compList -> mode $mode    ... clear "
			set compList_System {}
			set compList_Custom {}
		} else {
			set compList_System [lib_file::findFiles [ file join $::APPL_Env(CONFIG_Dir) components ] *.svg]
			set compList_Custom [lib_file::findFiles [ file join $::APPL_Env(USER_Dir)   components ] *.svg]		
		}
	}		

	
	#-------------------------------------------------------------------------
       #  reset Positioning
       #
	proc reset_Positioning {} {		
			variable rdials_list
			variable configValue
			set  configValue(compAngle)	    0.0
			set  configValue(compOffset_X)	0.0
			set  configValue(compOffset_y)	0.0			
			foreach rd $rdials_list {
				rdial::configure $rd -value 0
			}
			[namespace current]::updateCanvas 
	}	
	
	#-------------------------------------------------------------------------
       #  refit Canvas to provided widget
       #
	proc refitCanvas {} {
			variable compCanvas
			$compCanvas refitStage
	}

	
	#-------------------------------------------------------------------------
       #  update Canvas
       #
	proc updateCanvas {{entryVar ""} {value {0}}} {
			variable compCanvas
			variable compFile
			variable configValue

			if {$entryVar ne ""} {
				set $entryVar $value
            }
				puts "\n ... $compCanvas\n    ... $compFile"
			$compCanvas clean_StageContent
			[namespace current]::create_Centerline
			if {$compFile != {}} {
			    set compPosition [list $configValue(compOffset_X) [expr 1.0*$configValue(compOffset_y)]]
				set __my_Component__		[ $compCanvas readSVG $compFile $compPosition $configValue(compAngle)  __Decoration__ ]
				[namespace current]::moveto_StageCenter $__my_Component__
			}

	}


	#-------------------------------------------------------------------------
       #  move Item to StageCenter 
       #
	proc moveto_StageCenter {item} {
			variable  compCanvas 
			
			set stage 		[ $compCanvas getNodeAttr Canvas path ]
			set stageCenter [ canvasCAD::get_StageCenter $stage ]
			set bottomLeft  [ canvasCAD::get_BottomLeft  $stage ]
			foreach {cx cy} $stageCenter break
			foreach {lx ly} $bottomLeft  break
			$stage move $item [expr $cx - $lx] [expr $cy -$ly]
	}


	#-------------------------------------------------------------------------
       #  create Centerline
       #
	proc create_Centerline {} {
			variable  compCanvas 
			
			set stage 		[ $compCanvas getNodeAttr Canvas path ]
			set stageCenter [ canvasCAD::get_StageCenter $stage ]
			set stageFormat	[ $compCanvas getFormatSize [ $compCanvas getNodeAttr Stage format ] ]
			set stageScale	[ $compCanvas getNodeAttr Canvas scale ]

			set bottomLeft  [ canvasCAD::get_BottomLeft  $stage ]

				# puts "  $stageFormat"
			set formatWidth	[lindex $stageFormat 0]
			set formatHeight	[lindex $stageFormat 1]
			
				# puts "  stage        $stage"
				# puts "  stageCenter  $stageCenter"
				# puts "  stageScale   $stageScale"
				# puts "  formatWidth  $formatWidth"
				# puts "  formatHeight $formatHeight"
			
			set cl_x0	10
			set cl_xc	[expr 0.5*$formatWidth]
			set cl_x1	[expr $formatWidth -10]
			set cl_y0	10
			set cl_yc	[expr 0.5*$formatHeight]
			set cl_y1	[expr $formatHeight -10]

			#$compCanvas create rectangle	[list 0 0 100 100]  -fill red  -tags __CenterLine__
			$compCanvas create centerline [list $cl_x0 $cl_yc $cl_x1 $cl_yc ]  -fill red  -tags __CenterLine__
			$compCanvas create centerline [list $cl_xc $cl_y0 $cl_xc $cl_y1 ]  -fill red  -tags __CenterLine__
	}

	#-------------------------------------------------------------------------
       #  create config_line
       #
	proc create_config_line {w lb_text entryVar start current end resolution command} {		
			variable	rdials_list
			set 		$entryVar $current
			#puts "   ... \$entryVar [list [format "$%s" $entryVar]]"

			frame   $w
			pack    $w
			label   $w.lb	-text $lb_text            -width 10  -bd 1  -anchor w 
			entry   $w.cfg	-textvariable $entryVar  -width  4  -bd 1  -justify right -bg white 
			frame	$w.f	-relief sunken -bd 2 -padx 3

			rdial::create   $w.f.scl	\
							-value		$current \
							-height		10 \
							-width		84 \
							-orient		horizontal \
							-callback	[list $command $entryVar]
			lappend rdials_list $w.f.scl
			
				bind $w.cfg <Leave> 		[list $command ]
				bind $w.cfg <Return> 		[list $command ]
			pack      $w.lb  $w.cfg  $w.f  $w.f.scl    -side left  -fill x	
	}	
	
}

