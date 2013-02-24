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
		variable start_angle         20
		variable start_length        80
		variable teethCount          53
		variable crankLength        170
		variable crankArmCount       4
        variable visualization      chainwheel
		variable boltCircleDiameter 130
		variable end_length          65
		variable dim_size             5
		variable dim_dist            30
		variable dim_offset           0
		variable dim_type_select    aligned
		variable dim_font_select    vector
		variable std_fnt_scl          1
		variable font_colour		black
		variable demo_type			dimension
		variable drw_scale		      0.8
		variable cv_scale		      1
				
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
		
		
        proc draw_chainWheel {{bolts {bolts}}} {
				variable  myCanvas
				variable  teethCount
               
				set toothWith 			12.7
				set toothWithAngle 		[expr 2*$vectormath::CONST_PI/$teethCount]
				set chainWheelRadius	[expr 0.5*$toothWith/sin([expr 0.5*$toothWithAngle])]
                
                    # -----------------------------    
                    #   toothProfile
                    set pt_00 {2 5}									    ; foreach {x0 y0} $pt_00 break
                    set pt_01 [vectormath::rotateLine {0 0} 3.8 100]	; foreach {x1 y1} $pt_01 break
                    set pt_02 [vectormath::rotateLine {0 0} 3.8 125]	; foreach {x2 y2} $pt_02 break
                    set pt_03 [vectormath::rotateLine {0 0} 3.8 150]	; foreach {x3 y3} $pt_03 break
                    set pt_04 [vectormath::rotateLine {0 0} 3.8 170]	; foreach {x4 y4} $pt_04 break
                set toothProfile [list $x0 -$y0    $x1 -$y1    $x2 -$y2    $x3 -$y3    $x4 -$y4    $x4 $y4    $x3 $y3    $x2 $y2    $x1 $y1    $x0 $y0]
                
                
                    # -----------------------------    
                    #    chainwheel profile outside
                set index 0 ;# start her for symetriy purpose
				set outsideProfile {}
				while { $index < $teethCount } {
					set currentAngle [expr $index * [vectormath::grad $toothWithAngle]]
					set pos [vectormath::rotateLine {0 0} $chainWheelRadius $currentAngle ]
					if {$bolts == {bolts}} {
                        $myCanvas addtag {__ChainWheel__} withtag  [$myCanvas  create   circle  $pos -radius 3.8]
                    }
					
					set tmpList_01 {}
					foreach {x y} $toothProfile {
						set pt_xy [list $x $y]
						set pt_xy [vectormath::rotatePoint {0 0} $pt_xy $currentAngle]
						set pt_xy [vectormath::addVector $pos $pt_xy]
						set tmpList_01 [lappend tmpList_01 [canvasCAD::flatten_nestedList $pt_xy] ]
					}
					set outsideProfile [lappend teethProfile [canvasCAD::flatten_nestedList $tmpList_01]]
					incr index 
				}
                set chainWheelProfile [canvasCAD::flatten_nestedList $outsideProfile]
                set chainWheelPolygon [$myCanvas  create polygon $chainWheelProfile -fill orange -outline black]
                $myCanvas addtag {__ChainWheel__} withtag  $chainWheelPolygon			
                
 				$::f_report.text delete 1.0  end 
				$::f_report.text insert end "<polygon class=\"fil0 str0\" points=\""
				foreach {x y} $outsideProfile {
					$::f_report.text insert end "$x,$y  "
				}
				$::f_report.text insert end "\"/>"               
                
                
        }
        proc draw_crankArm {} {
				variable  myCanvas
				variable  crankLength 

                    # -----------------------------    
                    #    crank arm
                set index 0
				set crankArmProfile {{10 -19} {0 -19}}
                    # puts "\n"
                    # puts "  ----- 001 ---"
                    # puts "  $crankArmProfile"
                set point [lindex $crankArmProfile 1]
                set angle 270
                    # puts "  ----- 002 ---"  
                while {$angle > 90} {
                    incr angle -5
                    set point [vectormath::rotatePoint {0 0} $point -5]
                        # puts "         -> \$angle $angle  -- \$point $point"
                    lappend crankArmProfile $point
                }
                    # puts "  ----- 003 ---"
                lappend crankArmProfile {10 19}
                    # puts "  $crankArmProfile"
                lappend crankArmProfile [list [expr $crankLength -30] 14] [list $crankLength 14] 
                    # puts "  ----- 004 ---"
                set point [lindex $crankArmProfile end]
                set angle 90
                while {$angle > -90} {
                    incr angle -5
                    set point [vectormath::rotatePoint [list $crankLength 0] $point -5]
                        # puts "         -> \$angle $angle  -- \$point $point"
                    lappend crankArmProfile $point
                }
                lappend crankArmProfile [list [expr $crankLength -30] -14]
				set crankArmProfile [canvasCAD::flatten_nestedList $crankArmProfile]
				set crankSetPolygon [$myCanvas  create polygon $crankArmProfile -fill white -outline black]
				$myCanvas addtag {__ChainWheel__} withtag  $crankSetPolygon	
                
                set crank_pedalMount    [$myCanvas  create circle   [list $crankLength  0] -radius 6 -fill white -outline black]
                set crank_axle          [$myCanvas  create circle   [list 0  0] -radius 10 -fill white -outline black]
                $myCanvas addtag {__ChainWheel__} withtag  $crank_pedalMount	
                $myCanvas addtag {__ChainWheel__} withtag  $crank_axle	
                
        }
        
        proc update_board {{value {0}}} {
			
				variable  myCanvas
				
				variable  start_angle 
				variable  start_length
				variable  teethCount
				variable  crankLength 
                variable  crankArmCount 
                variable  boltCircleDiameter 
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
                variable  visualization
				
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
				
				set p_end   [vectormath::rotateLine  {0 0}  $end_length    $teethCount]
			 
				$myCanvas addtag {__ChainWheel__} withtag  [$myCanvas  create   circle {0 0} 	-radius 2  -outline red    	-fill white]

				$myCanvas addtag {__ChainWheel__} withtag  [$myCanvas  create   line [list  0 0  [lindex $p_end 0]  [lindex $p_end 1] ] -tags dimension  -fill blue ]
				
				
                
                switch $visualization {
                    {chainwheel} {   
                                draw_chainWheel {bolts}
                                sketchboard::moveto_StageCenter {__ChainWheel__}
                                return
                            }
                    {crankset} {   
                                draw_chainWheel {}
                                draw_crankArm
                                sketchboard::moveto_StageCenter {__ChainWheel__}
                                return
                            }
                    {default} {}
                }
                
                    # ------ create circle as chain-representation
				set toothWith 			12.7
				set toothWithAngle 		[expr 2*$vectormath::CONST_PI/$teethCount]
				set chainWheelRadius	[expr 0.5*$toothWith/sin([expr 0.5*$toothWithAngle])]
						# =0,5*H6/SIN(D13)
                    
                    # -----------------------------    
                    #   toothProfile
                    set pt_00 {2 5}									    ; foreach {x0 y0} $pt_00 break
                    set pt_01 [vectormath::rotateLine {0 0} 3.8 100]	; foreach {x1 y1} $pt_01 break
                    set pt_02 [vectormath::rotateLine {0 0} 3.8 125]	; foreach {x2 y2} $pt_02 break
                    set pt_03 [vectormath::rotateLine {0 0} 3.8 150]	; foreach {x3 y3} $pt_03 break
                    set pt_04 [vectormath::rotateLine {0 0} 3.8 170]	; foreach {x4 y4} $pt_04 break
                set toothProfile [list $x0 -$y0    $x1 -$y1    $x2 -$y2    $x3 -$y3    $x4 -$y4    $x4 $y4    $x3 $y3    $x2 $y2    $x1 $y1    $x0 $y0]

                    # -----------------------------    
                    #    connection Point: crankArm / chainWheel
                set connectionPoint [list 8 [expr 0.5*$boltCircleDiameter - 8]]   

                    # -----------------------------    
                    #    chainwheel profile outside
                set index 1 ;# start her for symetriy purpose
				set outsideProfile {}
				while { $index < $teethCount } {
					set currentAngle [expr $index * [vectormath::grad $toothWithAngle]]
					set pos [vectormath::rotateLine {0 0} $chainWheelRadius $currentAngle ]
					$myCanvas addtag {__ChainWheel__} withtag  [$myCanvas  create   circle  $pos -radius 3.8]  
					
					set tmpList_01 {}
					foreach {x y} $toothProfile {
						set pt_xy [list $x $y]
						set pt_xy [vectormath::rotatePoint {0 0} $pt_xy $currentAngle]
						set pt_xy [vectormath::addVector $pos $pt_xy]
						set tmpList_01 [lappend tmpList_01 [canvasCAD::flatten_nestedList $pt_xy] ]
					}
					set outsideProfile [lappend teethProfile [canvasCAD::flatten_nestedList $tmpList_01]]
					incr index 
				}
                                        
                    # -----------------------------    
                    #    chainwheel profile inside
                set insideRadius    [expr $chainWheelRadius -12]
                set armAngle        [expr (360/$crankArmCount)]
                set endAngle        [expr -0.5 * $armAngle]
                    #   compute inside segement
                set insideSegment   {}
                set point           $connectionPoint                                    ;   lappend insideSegment $point
                if {$insideRadius > [expr 0.5 * $boltCircleDiameter + 8]} {
                    set point       [vectormath::addVector   $point {0 8}]              ;   lappend insideSegment $point
                    set point       [vectormath::addVector   $point {1 5}]              ;   lappend insideSegment $point
                }
                    
                    # -----------------------------    
                    #    segemnt arc inside
                    set pointRadius [vectormath::length      {0 0} $point]
                    set deltaRadius [expr $insideRadius - $pointRadius]
                    set point       [vectormath::rotatePoint {0 0} $point -2]
                set point           [vectormath::unifyVector {0 0} $point  [expr [vectormath::length {0 0} $point] + 0.4*$deltaRadius]] ;   lappend insideSegment $point               
                    set point       [vectormath::rotatePoint {0 0} $point -3]
                set point           [vectormath::unifyVector {0 0} $point  [expr [vectormath::length {0 0} $point] + 0.3*$deltaRadius]] ;   lappend insideSegment $point               
                    set point       [vectormath::rotatePoint {0 0} $point -4]
                set point           [vectormath::unifyVector {0 0} $point  [expr [vectormath::length {0 0} $point] + 0.2*$deltaRadius]] ;   lappend insideSegment $point               
                    set point       [vectormath::rotatePoint {0 0} $point -5]
                set point           [vectormath::unifyVector {0 0} $point  [expr [vectormath::length {0 0} $point] + 0.1*$deltaRadius]] ;   lappend insideSegment $point               
                    set point       [vectormath::rotatePoint {0 0} $point -6]
                set point           [vectormath::unifyVector {0 0} $point  $insideRadius]   ;   lappend insideSegment $point 
                    set pointAngle  [vectormath::dirAngle    {0 0} $point]
                
                puts " \n \$pointAngle  $pointAngle"
                puts " \n \$armAngle    $armAngle  "
                puts " \n \$endAngle    $endAngle  "
                    
                set diffAngle 5
                while {$pointAngle > [expr 90 - 0.5 * $armAngle + $diffAngle]} {
                    set pointAngle  [expr $pointAngle - $diffAngle]
                    set point       [vectormath::rotatePoint {0 0} $point [expr -1.0 * $diffAngle] ] 
                    lappend insideSegment $point  
                }
                
                    # -----------------------------    
                    #    segemnt arc inside - opposite
                set mirrorSegment   {}
                set index           [llength $insideSegment]
                puts "\$index  $index"
                while {$index > 0} {
                    incr index -1
                    set point [lindex $insideSegment $index]
                    foreach {x y} $point break
                    lappend mirrorSegment [list [expr -1*$x] $y]
                }
                set insideSegment   [canvasCAD::flatten_nestedList  $mirrorSegment $insideSegment]
                   
                    # -----------------------------    
                    #    complete inside
                set index 0
                set insideProfile {}
                set boltPosition {}
                while {$index < $crankArmCount} {
                    set startAngle  [expr -90 + $armAngle * ($index)]
                    set startAngle  [expr -90 + $armAngle * (-0.5-$index)]
                    set pointList   [vectormath::rotatePointList {0 0} [canvasCAD::flatten_nestedList $insideSegment] $startAngle]
                    lappend insideProfile $pointList
                    set startAngle  [expr $armAngle * (-0.5-$index)]
                    set position    [vectormath::rotatePoint {0 0} [list [expr 0.5*$boltCircleDiameter] 0] $startAngle]
                    lappend boltPosition $position
                    incr index
                }               
                set chainWheelProfile [canvasCAD::flatten_nestedList $outsideProfile $insideProfile]
                set chainWheelPolygon [$myCanvas  create polygon $chainWheelProfile -fill orange -outline black]
                $myCanvas addtag {__ChainWheel__} withtag  $chainWheelPolygon			
                
                foreach position $boltPosition {
                    puts "  -> $position"
                    set bolt    [$myCanvas  create circle   $position -radius 5 -fill white -outline black]
                    $myCanvas addtag {__ChainWheel__} withtag  $bolt	
                }

                    # -----------------------------    
                    #    crank star
                set index 0
                set crankStar {}
                foreach {x y} $connectionPoint break;
                set armProfile [list  20 13   28 11    $y $x   $y [expr -1*$x]   28 -11   20 -13]
                    # puts "   -> \$armProfile  $armProfile"

                
                while {$index < $crankArmCount} {
                    set loopProfile [vectormath::rotatePointList {0 0} $armProfile [expr (360/$crankArmCount)*(0.5-$index)]]
                    lappend crankStar $loopProfile
                    incr index
                }
                set crankStar [canvasCAD::flatten_nestedList $crankStar]
				set crankStarPolygon [$myCanvas  create polygon $crankStar -fill gray -outline black]
				$myCanvas addtag {__ChainWheel__} withtag  $crankStarPolygon	
                		

                
                    # -----------------------------    
                    #    crank arm
                set index 0
				set crankArmProfile {{10 -19} {0 -19}}
                puts "\n"
                puts "  ----- 001 ---"
                puts "  $crankArmProfile"
                set point [lindex $crankArmProfile 1]
                set angle 270
                    # puts "  ----- 002 ---"  
                while {$angle > 90} {
                    incr angle -5
                    set point [vectormath::rotatePoint {0 0} $point -5]
                        # puts "         -> \$angle $angle  -- \$point $point"
                    lappend crankArmProfile $point
                }
                    # puts "  ----- 003 ---"
                lappend crankArmProfile {10 19}
                    # puts "  $crankArmProfile"
                lappend crankArmProfile [list [expr $crankLength -30] 14] [list $crankLength 14] 
                    # puts "  ----- 004 ---"
                set point [lindex $crankArmProfile end]
                set angle 90
                while {$angle > -90} {
                    incr angle -5
                    set point [vectormath::rotatePoint [list $crankLength 0] $point -5]
                        # puts "         -> \$angle $angle  -- \$point $point"
                    lappend crankArmProfile $point
                }
                lappend crankArmProfile [list [expr $crankLength -30] -14]
				set crankArmProfile [canvasCAD::flatten_nestedList $crankArmProfile]
				set crankSetPolygon [$myCanvas  create polygon $crankArmProfile -fill white -outline black]
				$myCanvas addtag {__ChainWheel__} withtag  $crankSetPolygon	
                
                
                
                set crank_pedalMount    [$myCanvas  create circle   [list $crankLength  0] -radius 6 -fill white -outline black]
                set crank_axle          [$myCanvas  create circle   [list 0  0] -radius 10 -fill white -outline black]
                $myCanvas addtag {__ChainWheel__} withtag  $crank_pedalMount	
                $myCanvas addtag {__ChainWheel__} withtag  $crank_axle	
                
				$::f_report.text delete 1.0  end 
				$::f_report.text insert end "<polygon class=\"fil0 str0\" points=\""
				foreach {x y} $outsideProfile {
					$::f_report.text insert end "$x,$y  "
				}
				$::f_report.text insert end "\"/>"
				sketchboard::moveto_StageCenter {__ChainWheel__}

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
		
				labelframe  $f_settings.settings  	-text settings
				labelframe  $f_settings.style   	-text style
				labelframe  $f_settings.angle   	-text angle
				labelframe  $f_settings.radius  	-text radius
				labelframe  $f_settings.length  	-text length
				labelframe  $f_settings.font    	-text font
				labelframe  $f_settings.demo    	-text demo
				labelframe  $f_settings.scale   	-text scale

				pack        $f_settings.settings	\
							$f_settings.style	    \
							$f_settings.angle		\
							$f_settings.radius		\
							$f_settings.length		\
							$f_settings.font		\
							$f_settings.demo		\
							$f_settings.scale   -fill x -side top 

				create_config_line $f_settings.settings.teeth     "teeth (count):"	sketchboard::teethCount          10  60
				create_config_line $f_settings.settings.bcd       "BCD :"	        sketchboard::boltCircleDiameter  90 150
                create_config_line $f_settings.settings.arms      "arm (count):"	sketchboard::crankArmCount        1   6
				create_config_line $f_settings.settings.length    "crank (length):"	sketchboard::crankLength        100 200
                
				
				radiobutton        $f_settings.style.chainwheel \
											-text      "chainwheel   " \
											-variable  "sketchboard::visualization" \
											-value     "chainwheel" \
											-command   "sketchboard::update_board"
				radiobutton        $f_settings.style.crankset \
											-text      "crankset   " \
											-variable  "sketchboard::visualization" \
											-value     "crankset" \
											-command   "sketchboard::update_board"
                                            
				radiobutton        $f_settings.style.crankset_detailed \
											-text      "crankset (detailed)  " \
											-variable  "sketchboard::visualization" \
											-value     "detailed" \
											-command   "sketchboard::update_board"
                                            
				radiobutton        $f_settings.length.aligned \
											-text      "aligned   " \
											-variable  "sketchboard::dim_type_select" \
											-value     "aligned" \
											-command   "sketchboard::update_board"
																						
				
				create_config_line $f_settings.scale.drw_scale	" Drawing scale "  sketchboard::drw_scale	 0.2  2  
								   $f_settings.scale.drw_scale.scl      configure   -resolution 0.1
				create_config_line $f_settings.scale.cv_scale	" Canvas scale  "  sketchboard::cv_scale	 0.2  5.0  
								   $f_settings.scale.cv_scale.scl      	configure   -resolution 0.1  -command "sketchboard::scale_board"
				button  		   $f_settings.scale.recenter   -text "recenter"   -command {sketchboard::recenter_board}
				button  		   $f_settings.scale.refit		-text "refit"      -command {sketchboard::refit_board}
				
				pack  	$f_settings.settings.teeth \
						$f_settings.settings.bcd \
						$f_settings.settings.arms \
						$f_settings.settings.length \
						$f_settings.style.chainwheel \
						$f_settings.style.crankset \
						$f_settings.style.crankset_detailed \
						$f_settings.length.aligned \
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

				text  		   	   $f_report.text -width 50
				scrollbar 		   $f_report.sby -orient vert -command "$f_report.text yview"
								   $f_report.text conf -yscrollcommand "$f_report.sby set"
	pack  $f_report  -side top 	-expand yes -fill both
				pack $f_report.sby $f_report.text -expand yes -fill both -side right		
	
	
	
	####+### E N D
  update
 
  $sketchboard::myCanvas reportXMLRoot
  
  wm minsize . [winfo width  .]   [winfo height  .]
  
  
   
 
 

 