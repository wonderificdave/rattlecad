##+##########################################################################
#
# test_canvas_CAD.tcl
# by Manfred ROSENBERGER
#
#   (c) Manfred ROSENBERGER 2010/02/06
#
#   canvas_CAD is licensed using the GNU General Public Licence,
#        see http://www.gnu.org/copyleft/gpl.html
# 
 


  set WINDOW_Title      "cad_canvasCAD, an extension for canvas"

  
  set APPL_ROOT_Dir [file dirname [lindex $argv0]]
 
  lappend auto_path "$APPL_ROOT_Dir/_canvasCAD"
  
  package require 	Tk
  package require   canvasCAD

  
 	
  ##+######################
 
	proc create_config_line {w lb_text entry_var start end  } {		
			frame   $w
			pack    $w
	 
			global $entry_var

			label   $w.lb	-text $lb_text            -width 20  -bd 1  -anchor w 
			entry   $w.cfg	-textvariable $entry_var  -width 10  -bd 1  -justify right -bg white 
		 
			scale   $w.scl	-width        12 \
							-length       120 \
							-bd           1  \
							-sliderlength 15 \
							-showvalue    0  \
							-orient       horizontal \
							-command      "sketchboard::update_board" \
							-variable     $entry_var \
							-from         $start \
							-to           $end 
								# -resolution   $resolution

			pack      $w.lb  $w.cfg $w.scl    -side left  -fill x		    
	}
	proc create_status_line {w lb_text entry_var} {	     
			frame   $w
			pack    $w
	 
			global $entry_var

			label     $w.lb     -text $lb_text            -width 20  -bd 1  -anchor w 
			entry     $w.cfg    -textvariable $entry_var  -width 10  -bd 1  -justify right -bg white 
			pack      $w.lb  $w.cfg    -side left  -fill x		    
	}

  
##+######################

	namespace eval sketchboard {
		
		variable myCanvas
		
			# defaults
		variable start_angle        20
		variable start_length       80
		variable end_angle         130
		variable end_length         65
		variable dim_size            5
		variable dim_dist           30
		variable dim_offset          0
		variable dim_type_select    aligned
		variable dim_font_select    vector
		variable std_fnt_scl         1
		variable font_colour		black
		variable demo_type			dimension
		variable drw_scale		     0.8
		variable cv_scale		     1
				
		proc createStage {cv_path cv_width cv_height st_width st_height unit st_scale args} {
			variable myCanvas
			variable cv_scale
			set myCanvas [canvasCAD::newCanvas cv01  $cv_path 	"MyCanvas"  $cv_width $cv_height 	A3 0.5 40 $args]
			# set myCanvas [canvasCAD::newCanvas cv01  $cv_path 	$cv_width $cv_height 	$st_width $st_height m 0.5 $args]
			set cv_scale [$myCanvas getNodeAttr Canvas scale]
			return $myCanvas
		}
		
		proc moveto_StageCenter {item} {
			variable myCanvas
			set stage 		[ $myCanvas getNodeAttr Canvas path ]
			set stageCenter [ canvasCAD::get_StageCenter $stage ]
			set bottomLeft  [ canvasCAD::get_BottomLeft  $stage ]
			foreach {cx cy} $stageCenter break
			foreach {lx ly} $bottomLeft  break
			$stage move $item [expr $cx - $lx] [expr $cy -$ly]
		}
		
		proc demo_canvasCAD {} {
						
				variable  myCanvas
				
				$myCanvas  create   line  		{0 0 20 0 20 20 0 20 0 0} 		-tags {Line_01}  -fill blue   -width 2 
				$myCanvas  create   line  		{30 30 90 30 90 90 30 90 30 30} -tags {Line_01}  -fill blue   -width 2 
				$myCanvas  create   line  		{0 0 30 30 } 		-tags {Line_01}  -fill blue   -width 2 
				
				$myCanvas  create   rectangle  	{180 120 280 180 } 	-tags {Line_01}  -fill violet   -width 2 
				$myCanvas  create   polygon  	{40 60  80 50  120 90  180 130  90 150  50 90 35 95} -tags {Line_01}  -outline red  -fill yellow -width 2 

				$myCanvas  create   oval  		{30 160 155 230 } 	-tags {Line_01}  -fill red   -width 2 		
				$myCanvas  create   circle  	{160 60}   -radius 50 -tags {Line_01}  -fill blue   -width 2 
				$myCanvas  create   arc  		{270 160}  -radius 50  -start 30  -extent 170 -tags {Line_01}  -outline gray  -width 2  -style arc
				
				$myCanvas  create   text		{140 90}  -text "text a"
				$myCanvas  create   vectortext	{120 70}  -text "vectorText ab"
				$myCanvas  create   vectortext	{100 50}  -text "vectorText abc"  -size 10
				$myCanvas  create   text		{145 95}  -text "text abcd" -size 10
		}
		
		proc recenter_board {} {
			
				variable  myCanvas
				
				variable  cv_scale 
				variable  drw_scale 
				
				puts "\n  -> recenter_board:   $myCanvas "
				
				puts "\n\n============================="
				puts "   -> cv_scale:          	$cv_scale"
				puts "   -> drw_scale:          $drw_scale"
				puts "\n============================="
				puts "\n\n"
				
				set cv_scale [ $myCanvas repositionToCanvasCenter ]
		}

		proc refit_board {} {
			
				variable  myCanvas
				
				variable  cv_scale 
				variable  drw_scale 
				
				puts "\n  -> recenter_board:   $myCanvas "
				
				puts "\n\n============================="
				puts "   -> cv_scale:          	$cv_scale"
				puts "   -> drw_scale:          $drw_scale"
				puts "\n============================="
				puts "\n\n"
				
				set cv_scale [ $myCanvas refitToCanvas ]
		}

		proc scale_board {{value {1}}} {
			
				variable  myCanvas
				
				variable  cv_scale 
				variable  drw_scale 
				
				puts "\n  -> scale_board:   $myCanvas"
				
				#$myCanvas clean_StageContent
				#set board [ $myCanvas dict_getValue Canvas  path]
			
				
				puts "\n\n============================="
				puts "   -> cv_scale:          	$cv_scale"
				puts "   -> drw_scale:          $drw_scale"
				puts "\n============================="
				puts "\n\n"
				
				$myCanvas scaleToCenter $cv_scale
		}
		
		proc update_board {{value {0}}} {
			
				variable  myCanvas
				
				variable  start_angle 
				variable  start_length
				variable  end_angle
				variable  end_length
				variable  dim_size
				variable  dim_dist
				variable  dim_offset
				variable  dim_font_select
				variable  dim_type_select
				variable  std_fnt_scl
				variable  font_colour
				variable  demo_type
				variable  drw_scale 
				
				puts "\n  -> update_board:   $myCanvas"
				
				$myCanvas clean_StageContent
				set board [ $myCanvas getNodeAttr Canvas  path ]
			
				if {$font_colour == {default}} { set font_colour [ $myCanvas getNodeAttr Style  fontcolour ]}
				
				puts "\n\n============================="
				puts "   -> drw_scale:          $drw_scale"
				puts "   -> font_colour:       	$font_colour"
				puts "   -> dim_size:   		$dim_size"
				puts "   -> dim_font_select:   	$dim_font_select"
				puts "\n============================="
				puts "   -> Drawing:           	[[$myCanvas getNode Stage] asXML]"
				puts "\n============================="
				puts "   -> Style:         		[[$myCanvas getNode Style] asXML]"
				puts "\n============================="
				#$myCanvas reportMyDictionary
				puts "\n============================="
				puts "\n\n"

				$myCanvas setNodeAttr Stage	scale 		$drw_scale
				$myCanvas setNodeAttr Style	fontstyle 	$dim_font_select
				$myCanvas setNodeAttr Style	fontsize 	$dim_size
				
				
				if {$demo_type != {dimension} } {
					sketchboard::demo_canvasCAD 
					return
				}
				
				# ------------------------------------
						# update $myCanvas ->
				
				set p_start [vectormath::rotateLine  {0 0}  $start_length  $start_angle]
				set p_end   [vectormath::rotateLine  {0 0}  $end_length    $end_angle]
			 
				$myCanvas addtag {__testDimension__} withtag  [$myCanvas  create   circle {0 0} 	-radius 2  -outline red    	-fill white]
				$myCanvas addtag {__testDimension__} withtag  [$myCanvas  create   circle {0 0} 	-radius 1  -outline blue  	-fill white]

				$myCanvas addtag {__testDimension__} withtag  [$myCanvas  create   line [list  0 0  [lindex $p_start 0]  [lindex $p_start 1] ] -tags dimension  -fill red ]
				$myCanvas addtag {__testDimension__} withtag  [$myCanvas  create   line [list  0 0  [lindex $p_end 0]  [lindex $p_end 1] ] -tags dimension  -fill blue ]
				
				switch $dim_type_select {
					angle   	{ 	
									foreach {sx sy} $p_start break
									foreach {ex ey} $p_end   break
									set tagDimension [ $myCanvas dimension  angle   [list {0 0} $p_start $p_end] $dim_dist  $dim_offset  $font_colour ] 
								}
					radius   	{ 	
									foreach {sx sy} $p_start break
									foreach {ex ey} $p_end   break
									set tagDimension [ $myCanvas dimension  radius   [list $p_start $p_end] $dim_dist  $dim_offset  $font_colour ] 							
								}
					aligned 	{ 
									foreach {sx sy} $p_start break
									foreach {ex ey} $p_end   break
									set tagDimension [ $myCanvas dimension  length   [list $p_start $p_end]  {aligned}  $dim_dist  $dim_offset  $font_colour ] 
								}
					horizontal 	{ 
									foreach {sx sy} $p_start break
									foreach {ex ey} $p_end   break
									set tagDimension [ $myCanvas dimension  length   [list $p_start $p_end]  {horizontal}  $dim_dist  $dim_offset  $font_colour ] 
								}
					vertical 	{ 
									foreach {sx sy} $p_start break
									foreach {ex ey} $p_end   break
									set tagDimension [ $myCanvas dimension  length   [list $p_start $p_end]  {vertical}  $dim_dist  $dim_offset  $font_colour ] 
								}
					perpendicular_red	{ 
									foreach {sx sy} $p_start break
									foreach {ex ey} $p_end   break
									set tagDimension [ $myCanvas dimension  length   [list {0 0} $p_start $p_end ]  {perpendicular}  $dim_dist  $dim_offset  $font_colour ] 
								}
					perpendicular_blue   { 
									foreach {sx sy} $p_end   break
									foreach {ex ey} $p_start break
									set tagDimension [ $myCanvas dimension  length   [list {0 0} $p_end $p_start ]  {perpendicular}  $dim_dist  $dim_offset  $font_colour ] 
								}
				}
				$myCanvas bind $tagDimension   <Double-ButtonPress-1>  [list sketchboard::dimensionMessage %x %y myDimension_1]
				$myCanvas addtag {__testDimension__} withtag  $tagDimension							
				
				sketchboard::moveto_StageCenter {__testDimension__}

		}
		
		proc dimensionMessage { x y id} {
			tk_messageBox -message "giveMessage: $x $y $id"
			
		}		
	}

	
	
  #
  ### -- G U I

  
	frame .f0 
	set f_canvas  [labelframe .f0.f_canvas   -text "board"  ]
	set f_config  [frame      .f0.f_config   ]

	pack  .f0      -expand yes -fill both
	pack  $f_canvas  $f_config    -side left -expand yes -fill both
	pack  configure  $f_config    -fill y
   
  
	#
	### -- G U I - canvas 
	sketchboard::createStage    $f_canvas.cv   1000 810  180 150 m  0.5 -bd 2  -bg white  -relief sunken
	

	#
	### -- G U I - canvas demo
		
	set f_settings  [labelframe .f0.f_config.f_settings  -text "Test - Settings" ]
		
				labelframe  $f_settings.settings  	-text settings
				labelframe  $f_settings.angle   	-text angle
				labelframe  $f_settings.radius  	-text radius
				labelframe  $f_settings.length  	-text length
				labelframe  $f_settings.font    	-text font
				labelframe  $f_settings.demo    	-text demo
				labelframe  $f_settings.scale   	-text scale

				pack        $f_settings.settings	\
							$f_settings.angle		\
							$f_settings.radius		\
							$f_settings.length		\
							$f_settings.font		\
							$f_settings.demo		\
							$f_settings.scale   -fill x -side top 

				create_config_line $f_settings.settings.end_angle     "end angle    (blue):"	sketchboard::end_angle     -40  400
				create_config_line $f_settings.settings.end_length    "end length   (blue):"	sketchboard::end_length	    50    90
				create_config_line $f_settings.settings.start_angle   "start angle  (red): "	sketchboard::start_angle   -20  420
				create_config_line $f_settings.settings.start_length  "start length (red): "	sketchboard::start_length   50  190
								   $f_settings.settings.start_angle.scl      configure   -resolution 0.1

				create_config_line $f_settings.settings.dim_size      "dimension size:     "	sketchboard::dim_size        0   10
				create_config_line $f_settings.settings.dim_dist      "dimension distance: "	sketchboard::dim_dist      -50  130
				create_config_line $f_settings.settings.dim_offset    "dimension offset:   "	sketchboard::dim_offset   -250  250

				
				radiobutton        $f_settings.length.aligned \
											-text      "aligned   " \
											-variable  "sketchboard::dim_type_select" \
											-value     "aligned" \
											-command   "sketchboard::update_board"
											
				radiobutton        $f_settings.length.horizontal \
											-text      "horizontal" \
											-variable  "sketchboard::dim_type_select" \
											-value     "horizontal" \
											-command   "sketchboard::update_board"
											
				radiobutton        $f_settings.length.vertical \
											-text      "vertical  " \
											-variable  "sketchboard::dim_type_select" \
											-value     "vertical" \
											-command   "sketchboard::update_board"
											
				radiobutton        $f_settings.length.perp_red \
											-text      "perp. to red line " \
											-variable  "sketchboard::dim_type_select" \
											-value     "perpendicular_red" \
											-command   "sketchboard::update_board"
											
				radiobutton        $f_settings.length.perp_blue \
											-text      "perp. to blue line  " \
											-variable  "sketchboard::dim_type_select" \
											-value     "perpendicular_blue" \
											-command   "sketchboard::update_board"
											
				
				radiobutton        $f_settings.angle.angle  \
											-text      "angle" \
											-variable  "sketchboard::dim_type_select" \
											-value     "angle" \
											-command   "sketchboard::update_board" \
											-justify   left
				  
				
				radiobutton        $f_settings.radius.radius  \
											-text      "radius" \
											-variable  "sketchboard::dim_type_select" \
											-value     "radius" \
											-command   "sketchboard::update_board" \
											-justify   left
				  
				
				radiobutton        $f_settings.font.vector  \
											-text      "vector" \
											-variable  "sketchboard::dim_font_select" \
											-value     "vector" \
											-command   "sketchboard::update_board" \
											-justify   left
				  
				radiobutton        $f_settings.font.standard  \
											-text      "standard" \
											-variable  "sketchboard::dim_font_select" \
											-value     "standard" \
											-command   "sketchboard::update_board" \
											-justify   left


				radiobutton        $f_settings.demo.dimension  \
											-text      "dimension" \
											-variable  "sketchboard::demo_type" \
											-value     "dimension" \
											-command   "sketchboard::update_board" \
											-justify   left
											
				radiobutton        $f_settings.demo.graphic  \
											-text      "graphic" \
											-variable  "sketchboard::demo_type" \
											-value     "graphic" \
											-command   "sketchboard::update_board" \
											-justify   left
											
				
				create_config_line $f_settings.scale.drw_scale	" Drawing scale "  sketchboard::drw_scale	 0.2  2  
								   $f_settings.scale.drw_scale.scl      configure   -resolution 0.1
				create_config_line $f_settings.scale.cv_scale	" Canvas scale  "  sketchboard::cv_scale	 0.2  5.0  
								   $f_settings.scale.cv_scale.scl      	configure   -resolution 0.1  -command "sketchboard::scale_board"
				button  		   $f_settings.scale.recenter   -text "recenter"   -command {sketchboard::recenter_board}
				button  		   $f_settings.scale.refit		-text "refit"      -command {sketchboard::refit_board}
								   

				# -- select font-colour ---
				#   --- handle ListboxSelect:
				#          return last not current selected value ????
				set colourList [ frame $f_settings.settings.f ]
						pack $colourList
							listbox $colourList.colourList -height 4
										#listbox .lb -selectmode multiple -height 4
							scrollbar $colourList.sb -command [list $colourList.colourList yview]
										 $colourList.colourList configure -yscrollcommand [list $colourList.sb set]
										 $colourList.colourList insert 0 red yellow green blue default
						pack 	$colourList.colourList \
								$colourList.sb -side left -expand 1 -fill both
						bind $colourList.colourList <<ListboxSelect>>  [list eval_listbox   %W ]
						
						proc eval_listbox {w} {
							# puts " -> eval_listbox [$w get active]"
							# puts " -> eval_listbox [$w curselection]"
							# puts " -> eval_listbox [$w get [$w curselection]]"
							set sketchboard::font_colour [$w get [$w curselection]]
							sketchboard::update_board
						}

						# bind $lb <<ListboxSelect>> [list ::cb_selectionChanged %W]
						#
						# proc ::cb_selectionChanged {w args} {
						#  if { [$w curselection] == "" } {
						#	 # listbox has no selected items
						#  } else {
						#	 # listbox has one or more selected items
						#  }

								   
				pack  	$f_settings.settings.end_angle \
						$f_settings.settings.end_length \
						$f_settings.settings.start_angle \
						$f_settings.settings.start_length \
						$f_settings.settings.dim_dist \
						$f_settings.settings.dim_offset \
						$colourList \
						$f_settings.length.aligned \
						$f_settings.length.horizontal \
						$f_settings.length.vertical \
						$f_settings.length.perp_red \
						$f_settings.length.perp_blue \
						$f_settings.angle.angle \
						$f_settings.radius.radius \
						$f_settings.font.vector \
						$f_settings.font.standard \
						$f_settings.demo.dimension \
						$f_settings.demo.graphic \
						$f_settings.scale.drw_scale \
						$f_settings.scale.cv_scale \
						$f_settings.scale.recenter \
						$f_settings.scale.refit \
					 -side top  -fill x
	 
	pack  $f_settings  -side top -expand yes -fill both
	 
	#
	### -- G U I - canvas print
		
	set f_print  [labelframe .f0.f_config.f_print  -text "Print" ]
		button  $f_print.bt_print   -text "print"  -command {$sketchboard::myCanvas print "E:/manfred/_devlp/_svn_sourceforge.net/canvasCAD/trunk/_print"} 
 	
	pack  $f_print  -side top 	-expand yes -fill x
		pack $f_print.bt_print 	-expand yes -fill x
	
	
	#
	### -- G U I - canvas demo
		
	set f_demo  [labelframe .f0.f_config.f_demo  -text "Demo" ]
		button  $f_demo.bt_clear   -text "clear"  -command {$sketchboard::myCanvas clean_StageContent} 
		button  $f_demo.bt_update  -text "update"   -command {sketchboard::update_board}
 	
	pack  $f_demo  -side top 	-expand yes -fill x
		pack $f_demo.bt_clear 	-expand yes -fill x
		pack $f_demo.bt_update 	-expand yes -fill x
	
	
	#
	### -- G U I - canvas status
		
	set f_status  [labelframe .f0.f_config.f_status  -text "status" ]

		create_status_line  $f_status.cv_width   "canvas width:"   canvas_width 
		create_status_line  $f_status.cv_heigth  "canvas heigth:"  canvas_heigth 
 
	
	pack  $f_status  -side top -expand yes -fill x


	####+### E N D
  update
 
  $sketchboard::myCanvas reportXMLRoot
  
  wm minsize . [winfo width  .]   [winfo height  .]
  
  
   
 
 

 