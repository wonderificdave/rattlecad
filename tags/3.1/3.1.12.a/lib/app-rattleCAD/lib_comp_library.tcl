# -----------------------------------------------------------------------------------
#
#: Functions : namespace      L I B _ C O M P _ L I B R A R Y
#

 namespace eval lib_comp_library {
                            
	variable	compCanvas  {}
	variable 	menueFrame	{}
	
	variable	compList_System {}
	variable	compList_Custom {}
	
	variable 	compFile  {}
	variable 	compAngle 		0
	variable 	compOffset_X	0
	variable 	compOffset_y	0


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
		frame	$menueFrame.lf  -width 30 -relief sunken -bd 1
			pack $menueFrame.lf  -expand no -fill none
		set nb_fileList	[ ttk::notebook $menueFrame.lf.nb ]
			pack $nb_fileList  	-expand no -fill none   
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
		frame	$menueFrame.bt -relief groove -bd 1
			pack $menueFrame.bt  -expand yes -fill both

		button 	$menueFrame.bt.l_clear	-text {clear List}			-width 30	-command [list [namespace current]::update_compList {clear} ]
        button 	$menueFrame.bt.l_update	-text {update List}			-width 30	-command [list [namespace current]::update_compList {} ]
		button 	$menueFrame.bt.c_update	-text {update Canvas}		-width 30	-command [list [namespace current]::updateCanvas]
		pack 	$menueFrame.bt.l_clear \
				$menueFrame.bt.l_update \
				$menueFrame.bt.c_update \
				-side top

			# -- Scale
		ttk::labelframe	$menueFrame.bt.sc -text "Positioning" 
			pack $menueFrame.bt.sc  -expand yes -fill both
		create_config_line $menueFrame.bt.sc.off_x	"Offset x"	[namespace current]::compOffset_X  -180  180	 1	  [list [namespace current]::updateCanvas]
		create_config_line $menueFrame.bt.sc.off_y	"Offset y"	[namespace current]::compOffset_y  -180  180	 1	  [list [namespace current]::updateCanvas]
		create_config_line $menueFrame.bt.sc.angle	"Angle"	 	[namespace current]::compAngle     -180  180	 1	  [list [namespace current]::updateCanvas]
		pack 	$menueFrame.bt.sc.off_x \
		        $menueFrame.bt.sc.off_y \
				$menueFrame.bt.sc.angle \
				-side top
				
		button 	$menueFrame.bt.sc.reset	-text {reset}			-width 15	-command [list [namespace current]::reset_Positioning ] 
		pack 	$menueFrame.bt.sc.reset \
				-side top


		set compCanvas 	[ canvasCAD::newCanvas	cv_Component $canvasFrame.cv  550 550 A3 1  -bd 2   -bg lightgray  -relief sunken ]
		set tabID		[string map {/ . } [file dirname [file dirname [string map {. /} $w] ] ] ]
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
		
		puts "\n\n -> mode $mode \n"
		if {[string match $mode {clear}]} { 
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
			variable compAngle		0
			variable compOffset_X	0
			variable compOffset_y	0			
				set angle       0
				set offset_x    0
				set offset_y    0
			[namespace current]::updateCanvas
	}	
	
	#-------------------------------------------------------------------------
       #  refit Canvas to provided widget
       #
	proc refitCanvas {} {
			variable compCanvas
			$compCanvas refitToCanvas
	}

	
	#-------------------------------------------------------------------------
       #  update Canvas
       #
	proc updateCanvas {{value {0}}} {
			variable compCanvas
			variable compFile
			variable compAngle
			variable compOffset_X
			variable compOffset_y

				# puts "\n ... $compCanvas\n    ... $compFile"
			$compCanvas clean_StageContent
			[namespace current]::create_Centerline
			if {$compFile != {}} {
			    set compPosition [list $compOffset_X [expr 1.0*$compOffset_y]]
				set __my_Component__		[ $compCanvas readSVG $compFile $compPosition $compAngle  __Decoration__ ]
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

			$compCanvas create centerline [list $cl_x0 $cl_yc $cl_x1 $cl_yc ]  -fill red  -tags __CenterLine__
			$compCanvas create centerline [list $cl_xc $cl_y0 $cl_xc $cl_y1 ]  -fill red  -tags __CenterLine__
	}

	#-------------------------------------------------------------------------
       #  create config_line
       #
	proc create_config_line {w lb_text entry_var start end resolution command} {		
			frame   $w
			pack    $w
	 
			global $entry_var

			label   $w.lb	-text $lb_text            -width 10  -bd 1  -anchor w 
			entry   $w.cfg	-textvariable $entry_var  -width  4  -bd 1  -justify right -bg white 
		 
			scale   $w.scl	-width        12 \
							-length       90 \
							-bd           1  \
							-sliderlength 15 \
							-showvalue    0  \
							-orient       horizontal \
							-command      [list $command] \
							-variable     $entry_var
							
			$w.scl configure -from $start -to $end -resolution $resolution	

			#	bind $w.cfg <FocusIn> 		[list $w.cfg -textvariable {} ]
			#	bind $w.cfg <Leave> 		[list $command]

			pack      $w.lb  $w.cfg $w.scl    -side left  -fill x		    
	}	
	
}

