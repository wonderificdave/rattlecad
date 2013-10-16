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
  lappend auto_path "$APPL_ROOT_Dir/app-rattleCAD"
  
  package require 	Tk
  package require   canvasCAD
  package require   rattleCAD

  
 	
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
    
    variable S01_length   150
    variable S02_length   160
    variable S03_length   120
    variable S04_length   100
    variable S01_angle     -9
    variable S02_angle      8
    variable S03_angle     -8
    variable S01_radius   320
    variable S02_radius   320
    variable S02_radius   310
    
    variable orient_x00    425
    variable orient_y00    -37
    variable orient_select  left
    
    
    variable  profile_x00   0
    variable  profile_y00  12.5
    variable  profile_x01 150
    variable  profile_y01  18
    variable  profile_x02 150
    variable  profile_y02  18
    variable  profile_x03  75
    variable  profile_y03  24
    
    
    variable arcPrecission   5
    #variable unbentShape
    #variable profileDef {}
    #     set profileDef {{0 7} {10 7} {190 9} {80 9} {70 12}}
    #     set profileDef {{0 9} {10 7} {190 16} {80 16} {70 24}}
    #     set profileDef {{0 7} {10 7} {190 16} {80 16} {70 24}}

    
    
				
		proc createStage {cv_path cv_width cv_height st_width st_height unit st_scale args} {
        variable myCanvas
        variable cv_scale
        set myCanvas [canvasCAD::newCanvas cv01  $cv_path 	"MyCanvas"  $cv_width $cv_height 	A3 0.5 40 $args]
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
				
				# set cv_scale [ $myCanvas refitToCanvas ]
                set cv_scale [ $myCanvas refitStage]
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


    proc draw_centerLineEdge {myCanvas} {
        $myCanvas addtag {__CenterLine__} withtag  [$myCanvas  create   circle {0 0} 	-radius 2  -outline red    	-fill white]
        set basePoints {}
        set p00 {0 0}
        set angle_00 0 
        set p01 [vectormath::addVector $p00 [vectormath::rotateLine {0 0} $sketchboard::S01_length $angle_00]]
        set angle_01 [expr $angle_00 + $sketchboard::S01_angle]
        set p02 [vectormath::addVector $p01 [vectormath::rotateLine {0 0} $sketchboard::S02_length $angle_01]]
        set angle_02 [expr $angle_01 + $sketchboard::S02_angle]
        set p03 [vectormath::addVector $p02 [vectormath::rotateLine {0 0} $sketchboard::S03_length $angle_02]]
        
        $myCanvas addtag {__CenterLine__} withtag  [$myCanvas  create   circle $p01 	  -radius 5  -outline green    	-fill white]
        $myCanvas addtag {__CenterLine__} withtag  [$myCanvas  create   circle $p02 	  -radius 5  -outline green    	-fill white]
        $myCanvas addtag {__CenterLine__} withtag  [$myCanvas  create   circle $p03 	  -radius 5  -outline green    	-fill white]

        lappend basePoints $p00
        lappend basePoints $p01
        lappend basePoints $p02
        lappend basePoints $p03

        append polyLineDef [canvasCAD::flatten_nestedList $basePoints]
          # puts "  -> $polyLineDef"
        $myCanvas addtag {__CenterLine__} withtag  {*}[$myCanvas  create   line $polyLineDef -tags dimension  -fill green ]
    }


    proc update_board {{value {0}}} {
			
				variable  myCanvas
        
        variable unbentShape
        variable profileDef
        
        variable orient_x00
        variable orient_y00
        variable orient_select
				
				variable  start_angle 
				variable  start_length
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
        
				
				#puts "\n  -> update_board:   $myCanvas"
				
				$myCanvas clean_StageContent
				set board [ $myCanvas getNodeAttr Canvas  path ]
			
				if {$font_colour == {default}} { set font_colour [ $myCanvas getNodeAttr Style  fontcolour ]}
				
				#puts "\n\n============================="
				#puts "   -> drw_scale:          $drw_scale"
				#puts "   -> font_colour:       	$font_colour"
				#puts "   -> dim_size:   		$dim_size"
				#puts "   -> dim_font_select:   	$dim_font_select"
				#puts "\n============================="
				#puts "   -> Drawing:           	[[$myCanvas getNode Stage] asXML]"
				#puts "\n============================="
				#puts "   -> Style:         		  [[$myCanvas getNode Style] asXML]"
				#puts "\n============================="
				##$myCanvas reportMyDictionary
				#puts "\n============================="
				#puts "\n\n"
        
          # -- clear text field
        $::f_report.text delete 1.0  end


				$myCanvas setNodeAttr Stage	scale 		$drw_scale
				$myCanvas setNodeAttr Style	fontstyle $dim_font_select
				$myCanvas setNodeAttr Style	fontsize 	$dim_size
				
				
				if {$demo_type != {dimension} } {
					sketchboard::demo_canvasCAD 
					return
				}
				
				# ------------------------------------
						# update $myCanvas ->
				
				set S01_length  $sketchboard::S01_length
        set S02_length  $sketchboard::S02_length
        set S04_length  $sketchboard::S03_length                         
        set S03_length  $sketchboard::S04_length                         
        set S01_angle   $sketchboard::S01_angle 
        set S02_angle   $sketchboard::S02_angle                       
        set S03_angle   $sketchboard::S03_angle                       
        set S01_radius  $sketchboard::S01_radius
				set S02_radius  $sketchboard::S02_radius
				set S03_radius  $sketchboard::S03_radius
        set centerLineDef [list $S01_length $S02_length $S03_length  $S04_length \
                                $S01_angle  $S02_angle $S03_angle \
                                $S01_radius $S02_radius $S03_radius]
                                
            # -- get smooth centerLine
        set retValues [lib_tube::init_centerLine $centerLineDef] 
        set centerLine  [lindex $retValues 0]
        set ctrLines    [lindex $retValues 1]
        
          # set centerLine            [lib_tube::init_centerLine $centerLineDef]
        set centerLine_flattened  [canvasCAD::flatten_nestedList $centerLine]
                    # -- get smooth centerLine
        
        
        
        variable  profile_x00   $sketchboard::profile_x00
        variable  profile_y00   $sketchboard::profile_y00
        variable  profile_x01   $sketchboard::profile_x01 
        variable  profile_y01   $sketchboard::profile_y01
        variable  profile_x02   $sketchboard::profile_x02 
        variable  profile_y02   $sketchboard::profile_y02
        variable  profile_x03   $sketchboard::profile_x03
        variable  profile_y03   $sketchboard::profile_y03
        set profileDef {}
          lappend profileDef [list 0            $profile_y00]
          lappend profileDef [list $profile_x01 $profile_y01]
          lappend profileDef [list $profile_x02 $profile_y02]
          lappend profileDef [list $profile_x03 $profile_y03]        
        
            # -- set profile of straight, unbent tubeprofile
        set tubeProfile [lib_tube::init_tubeProfile $profileDef]
        

        
            # -- draw centerline with radius 0
              # $myCanvas addtag {__ChainWheel__} withtag  [$myCanvas  create   circle {0 0} 	-radius 2  -outline red    	-fill white]
        # draw_centerLineEdge $myCanvas

        # puts "\n  -> centerLine: $centerLine" 
        
        
            # -- draw shape of tube
        set outLineLeft   [lib_tube::get_tubeShape    $centerLine $tubeProfile left  ]
        set outLineRight  [lib_tube::get_tubeShape    $centerLine $tubeProfile right ]
        set outLine       [canvasCAD::flatten_nestedList $outLineLeft $outLineRight]
          # puts "\n    -> \$outLineLeft   $outLineLeft"
          # puts "\n    -> \$outLineRight  $outLineRight"
          # puts "\n    -> \$outLine       $outLine "
        $myCanvas addtag {__OutLine__}     withtag  {*}[$myCanvas  create   polygon $outLine    -tags dimension  -fill lightgray ]
           
            # draw smooth centerline with bend-radius
        $myCanvas addtag {__CenterLine__}  withtag  {*}[$myCanvas  create   line    $centerLine_flattened -tags dimension  -fill blue ]
            # $myCanvas addtag {__OutLine__}     withtag  {*}[$myCanvas  create   line $outLineLeft   -tags dimension  -fill darkblue ]
            # $myCanvas addtag {__OutLine__}     withtag  {*}[$myCanvas  create   line $outLineRight  -tags dimension  -fill darkblue ]


            # draw profile of straight unbent tube
                # set profileLine [get_profile 30]
                # $myCanvas addtag {__profileLine__} withtag  {*}[$myCanvas  create   line $profileLine -tags dimension  -fill green ]
        set unbentShapeLine {}
        set x 0
        while {$x < 500} {
          set y [lib_tube::get_tubeProfileOffset $tubeProfile $x]
          # set y  [lindex $xy 1]
          set y1 [expr $y + 20]
          lappend unbentShapeLine [list $x $y1]
          incr x 10
        }        
        $myCanvas addtag {__profileLine__} withtag  {*}[$myCanvas  create   line $unbentShapeLine -tags dimension  -fill orange ]
        
        
            # -- get intersection of tube
        set length    [expr sqrt(pow($orient_x00,2) + pow($orient_y00,2))]
        set angle [vectormath::dirAngle {0 0} [list $orient_x00 $orient_y00]]
          # puts "\n  -> length: $length"
          # puts   "  -> angle:  $angle"        
        switch -exact $orient_select {
            left {
                set point_IS  [lib_tube::get_shapeInterSection $outLineLeft $length] 
                }
            center {
                set point_IS  [lib_tube::get_shapeInterSection $centerLine $length] 
                }
            right {
                set point_IS  [lib_tube::get_shapeInterSection [lreverse $outLineRight] $length] 
                }
                    
        }
        
            # -- get tube orientation
        $myCanvas  create   circle  	$point_IS   -radius 2 -tags {__CenterLine__}  -fill white -outline red  -width 2 
        set angleIS [vectormath::dirAngle {0 0} $point_IS]
        set angleRotation [expr $angle - $angleIS]
          # puts "  -> angleIS: $angleIS"
          # puts "  -> angleRotation: $angleRotation"
                

        
            # -- draw oriented tube
        set outLine [vectormath::rotatePointList {0 0} $outLine $angleRotation]
        $myCanvas addtag {__OutLine__}     withtag  {*}[$myCanvas  create   polygon $outLine    -tags dimension  -fill lightgray -outline darkblue]


            # -- draw oriented centerline
        set centerLine_flattened [vectormath::rotatePointList {0 0} $centerLine_flattened $angleRotation]
        $myCanvas addtag {__CenterLine__}  withtag  {*}[$myCanvas  create   line    $centerLine_flattened -tags dimension  -fill blue ]
        
                
            # draw orientation of bent tube
        set orient_01 [list 0 0]
        set orient_02 [list $orient_x00 0]
        set orient_03 [list $orient_x00 $orient_y00]
        set orientLine [canvasCAD::flatten_nestedList $orient_01 $orient_02 $orient_03]
          # puts $orientLine
        $myCanvas  create   circle  	$orient_03   -radius 2 -tags {__CenterLine__}  -fill white -outline blue  -width 2 
        $myCanvas addtag {__CenterLine__}  withtag  {*}[$myCanvas  create   line    $orientLine -tags dimension  -fill red ]

                
        
        # get_profile 30
        
        $myCanvas fit2Stage {__CenterLine__ __profileLine__ __OutLine__}
        return
					

				set toothProfileList {}
        foreach {x y} $toothProfileList {
					$::f_report.text insert end "$x,$y  "
				}
				#$::f_report.text insert end "\"/>"
				#sketchboard::moveto_StageCenter {__ChainWheel__}

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
	sketchboard::createStage    $f_canvas.cv   1000 810  250 250 m  0.5 -bd 2  -bg white  -relief sunken
	

	#
	### -- G U I - canvas demo
		
	set f_settings  [labelframe .f0.f_config.f_settings  -text "Test - Settings" ]
		
				labelframe  $f_settings.centerline    -text centerline
				labelframe  $f_settings.orientation   -text orientation
				labelframe  $f_settings.tubeprofile     -text tubeprofile
				labelframe  $f_settings.precission  	-text precission
				# labelframe  $f_settings.length  	-text length
				labelframe  $f_settings.font    	-text font
				labelframe  $f_settings.demo    	-text demo
				labelframe  $f_settings.scale   	-text scale

				pack  $f_settings.centerline	\
							$f_settings.orientation		\
							$f_settings.tubeprofile		\
							$f_settings.precission  \
							$f_settings.font		\
							$f_settings.demo		\
							$f_settings.scale   -fill x -side top 

				create_config_line $f_settings.centerline.s01_l  "length (01):  "  sketchboard::S01_length      5  290   ;#150
				create_config_line $f_settings.centerline.s02_l  "length (02):  "  sketchboard::S02_length     30  290  ;# 160
				create_config_line $f_settings.centerline.s03_l  "length (03):  "  sketchboard::S03_length     80  250  ;# 115
				create_config_line $f_settings.centerline.s04_l  "length (04):  "  sketchboard::S04_length     40  250  ;# 115
				
        create_config_line $f_settings.centerline.s01_a  "   angle (01):"  sketchboard::S01_angle     -30   30
        create_config_line $f_settings.centerline.s02_a  "   angle (02):"  sketchboard::S02_angle     -30   30
        create_config_line $f_settings.centerline.s03_a  "   angle (03):"  sketchboard::S03_angle     -30   30

				create_config_line $f_settings.centerline.s01_r  "  radlus (01):"  sketchboard::S01_radius     50  590   ;# 320     			
				create_config_line $f_settings.centerline.s02_r  "  radlus (02):"  sketchboard::S02_radius     30  590   ;# 320
				create_config_line $f_settings.centerline.s03_r  "  radlus (03):"  sketchboard::S03_radius     30  590   ;# 320
        
				
        create_config_line $f_settings.orientation.x_00   "        x00:  "  sketchboard::orient_x00    250  550   ;#   0
        create_config_line $f_settings.orientation.y_00   "        y00:  "  sketchboard::orient_y00   -100  100   ;#   0
				
        
        #create_config_line $f_settings.tubeprofile.x_00     "        x00:  "  sketchboard::profile_x00        0   0   ;#   0
				create_config_line $f_settings.tubeprofile.y_00     "        y00:  "  sketchboard::profile_y00       10  40   ;#  12.50
				create_config_line $f_settings.tubeprofile.x_01     "        x01:  "  sketchboard::profile_x01        5 320   ;# 150 
				create_config_line $f_settings.tubeprofile.y_01     "        y01:  "  sketchboard::profile_y01       10  40   ;#  18
				create_config_line $f_settings.tubeprofile.x_02     "        x02:  "  sketchboard::profile_x02      100 350   ;# 150
				create_config_line $f_settings.tubeprofile.y_02     "        y02:  "  sketchboard::profile_y02       15  40   ;#  18
				create_config_line $f_settings.tubeprofile.x_03     "        x03:  "  sketchboard::profile_x03       50 100   ;#  75
				create_config_line $f_settings.tubeprofile.y_03     "        y03:  "  sketchboard::profile_y03       15  40   ;#  24
				
        create_config_line $f_settings.precission.prec    " precission:  "  sketchboard::arcPrecission    1  15   ;#  24

        
				
				radiobutton        $f_settings.orientation.left    -text "left   "  -variable  "sketchboard::orient_select"  -value     "left"   -command   "sketchboard::update_board"
				radiobutton        $f_settings.orientation.center  -text "center "  -variable  "sketchboard::orient_select"  -value     "center" -command   "sketchboard::update_board"
				radiobutton        $f_settings.orientation.right   -text "right  "  -variable  "sketchboard::orient_select"  -value     "right"  -command   "sketchboard::update_board"
																						
				
				create_config_line $f_settings.scale.drw_scale	" Drawing scale "  sketchboard::drw_scale	 0.2  2  
								   $f_settings.scale.drw_scale.scl      configure   -resolution 0.1
				create_config_line $f_settings.scale.cv_scale	" Canvas scale  "  sketchboard::cv_scale	 0.2  5.0  
								   $f_settings.scale.cv_scale.scl      	configure   -resolution 0.1  -command "sketchboard::scale_board"
				button  		   $f_settings.scale.recenter   -text "recenter"   -command {sketchboard::recenter_board}
				button  		   $f_settings.scale.refit		  -text "refit"      -command {sketchboard::refit_board}
				
				pack  	\
						$f_settings.orientation.left \
						$f_settings.orientation.center \
						$f_settings.orientation.right \
            -side left
				pack  	\
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


	#
	### -- G U I - canvas report
		
	set f_report  [labelframe .f0.f_config.f_report  -text "report" ]

				text  		   	   $f_report.text -width 50 -height 7
				scrollbar 		   $f_report.sby -orient vert -command "$f_report.text yview"
								   $f_report.text conf -yscrollcommand "$f_report.sby set"
	pack $f_report  -side top 	-expand yes -fill both
	pack $f_report.sby $f_report.text -expand yes -fill both -side right		
	
	
	
	####+### E N D
  update
 
  $sketchboard::myCanvas reportXMLRoot
  
  wm minsize . [winfo width  .]   [winfo height  .]
  
  
   
 
 

 