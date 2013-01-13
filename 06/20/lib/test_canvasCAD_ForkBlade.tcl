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
		variable debugMode		   off
    
    variable headTube_Angle     72
    
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
    
    variable forkHeight       365
    variable forkRake          45
    variable length_bladeDO   325
    variable height_bladeDO    45
    variable crownOffset       35
    variable crownPerp          3.5
    variable dropOutOffset     20
    variable dropOutPerp       15
    variable endLength         50
    variable bendRadius       450
    variable max_Offset         6
    variable bladeType       bent
    variable bladeType        max
    
    
    variable  profile_x00   0
    variable  profile_y00  12.5
    variable  profile_x01 250
    variable  profile_y01  28
    variable  profile_x02 150
    variable  profile_y02  28
    variable  profile_x03  75
    variable  profile_y03  28
    
    
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


    proc _getBlade {valueDict {value {0}}} {

        
        # variable max_Offset

        # puts $valueDict
        
        set forkHeight      [dict get $valueDict env    forkHeight]
        set forkRake        [dict get $valueDict env    forkRake]
        set crownOffset     [dict get $valueDict env    crownOffset]
        set crownPerp       [dict get $valueDict env    crownPerp]
        set dropOutOffset   [dict get $valueDict env    dropOutOffset]
        set dropOutPerp     [dict get $valueDict env    dropOutPerp]
        set headTube_Angle  [dict get $valueDict env    headTubeAngle]
        
        set endLength       [dict get $valueDict blade  endLength]
        set bendRadius      [dict get $valueDict blade  bendRadius]
        set bladeType       [dict get $valueDict blade  type]
        
        set profileDef      [dict get $valueDict profile]
        set max_Offset      6.0

        

        set length_bladeDO  [expr $forkHeight - $crownOffset]
        set height_bladeDO  [expr $forkRake - $crownPerp]
        
        set orient_01 [list 0 0]
        set orient_02 [list $crownOffset 0]
        set orient_03 [list $crownOffset $crownPerp]
        set orient_04 [list $forkHeight $crownPerp]
        set orient_05 [list $forkHeight $forkRake]          
        
        set p_00    [list $length_bladeDO $height_bladeDO]
        
        switch -exact $bladeType {
        
          bent {

                  # http://www.mathcentre.ac.uk/resources/workbooks/mathcentre/web-rcostheta-alphaetc.pdf
              #puts "\n"
              #puts "   --> \$height_bladeDO $height_bladeDO"
              #puts "   --> \$dropOutPerp $dropOutPerp"
              #puts "   ----> [expr $height_bladeDO + $dropOutPerp]"

              set _b    [expr -1.0*($dropOutOffset + $endLength)]
                      
              if {$height_bladeDO > $dropOutPerp} {
              
                    # puts "\n ==== upper state =========\n"  
                    
                  set _a    [expr  1.0*($bendRadius - $dropOutPerp)]
                  set _R    [expr hypot($_a,$_b)]
                  set _atan [expr atan($_b/$_a)]
                  set _quot [expr ($bendRadius - $height_bladeDO)/$_R]
                  set _acos [expr acos($_quot)]

                  set bendAngle [expr (-180/$vectormath::CONST_PI) * ($_acos + $_atan)]
                  set segLength [expr abs($bendRadius*$bendAngle)*($vectormath::CONST_PI/180)] 
                  set dirAngle  [expr -1*$bendAngle]
                  
                  set l_t01   [expr $bendRadius * sin($bendAngle*$vectormath::CONST_PI/180)]
                  
                  set p_01    [vectormath::rotateLine $p_00 $dropOutPerp    [expr 270 + $dirAngle]]
                  set p_02    [vectormath::rotateLine $p_01 $dropOutOffset  [expr 180 + $dirAngle]]
                  set p_03    [vectormath::rotateLine $p_02 $endLength      [expr 180 + $dirAngle]]
                  set p_04    [vectormath::subVector $p_03  [list           [expr -1 * $l_t01] [lindex $p_03 1]]]
                  set p_05    [vectormath::rotateLine $p_03 [expr 0.5 * $segLength] [expr 180 + $dirAngle]]
                  set p_06    $orient_03
                  set p_15    [vectormath::addVector $p_04  [list 0         $bendRadius]]
                  
              } elseif {$height_bladeDO > 0} {
              
                    # puts "\n ==== middle state =========\n" 
                  
                  set _a    [expr  1.0*($bendRadius + $dropOutPerp)]
                  set _R    [expr hypot($_a,$_b)]
                  set _atan [expr atan($_b/$_a)]
                  set _quot [expr ($bendRadius + $height_bladeDO)/$_R]
                  set _acos [expr acos($_quot)]

                  set bendAngle [expr (180/$vectormath::CONST_PI) * ($_acos + $_atan)]
                  set segLength [expr abs($bendRadius*$bendAngle)*$vectormath::CONST_PI/180] 
                  set dirAngle  [expr -1*$bendAngle]

                  set l_t01   [expr $bendRadius * sin($bendAngle*$vectormath::CONST_PI/180)]

                  set p_01    [vectormath::rotateLine $p_00 $dropOutPerp    [expr 270 + $dirAngle]]
                  set p_02    [vectormath::rotateLine $p_01 $dropOutOffset  [expr 180 + $dirAngle]]
                  set p_03    [vectormath::rotateLine $p_02 $endLength      [expr 180 + $dirAngle]]
                  set p_04    [vectormath::subVector $p_03  [list $l_t01    [lindex $p_03 1]]]
                  set p_05    [vectormath::rotateLine $p_03 [expr 0.5 * $segLength] [expr 180 + $dirAngle]]
                  set p_06    $orient_03
                  set p_15    [vectormath::addVector $p_04  [list 0         [expr 1.0 * $bendRadius]]]
                    
              } else {
              
                    # puts "\n ==== lower state =========\n"  
                  
                  set _a      [expr  1.0*($dropOutPerp + $bendRadius)]
                  set _R      [expr hypot($_a,$_b)]
                  set _atan   [expr atan($_b/$_a)]
                  set _quot   [expr ($bendRadius + $height_bladeDO)/$_R]
                  set _acos   [expr acos($_quot)]
                 
                  set bendAngle [expr (180/$vectormath::CONST_PI) * ($_acos + $_atan)]
                  set segLength [expr abs($bendRadius*$bendAngle)*$vectormath::CONST_PI/180] 
                  set dirAngle  [expr -1.0 * $bendAngle]
                  
                  set l_t01   [expr $bendRadius * sin($bendAngle*$vectormath::CONST_PI/180)]
                  
                  set p_01    [vectormath::rotateLine $p_00 $dropOutPerp    [expr 270 + $dirAngle]]
                  set p_02    [vectormath::rotateLine $p_01 $dropOutOffset  [expr 180 + $dirAngle]]
                  set p_03    [vectormath::rotateLine $p_02 $endLength      [expr 180 + $dirAngle]]
                  set p_04    [vectormath::subVector  $p_03 [list $l_t01    [lindex $p_03 1]]]
                  set p_05    [vectormath::rotateLine $p_03 [expr 0.5 * $segLength] [expr 180 + $dirAngle]]
                  set p_06    [list 0 0] 
                  set p_15    [vectormath::addVector  $p_04 [list 0         [expr -1.0 * $bendRadius]]]
                  
              }             
              
                  #puts "   -> \$_a $_a"
                  #puts "   -> \$_b $_b"
                  #puts "   -> \$_R $_R"
                  #puts "   -> \$_quot $_quot"
                  #puts "   -> \$_atan $_atan"
                  #puts "   -> \$_acos $_acos"
                  #puts "   -> \$segLength $segLength"
                  #puts "   -> \$bendAngle $bendAngle\n"
                  #puts "   -> \$dirAngle $dirAngle\n"

              set angleRotation [expr 180 + $dirAngle]  
                  #puts "   -> \$angleRotation $angleRotation\n"
              
              set S01_length  [expr $endLength + 0.5 * $segLength]
              set S02_length  [expr [lindex $p_04 0] + 0.5 * $segLength - 20] ;#[expr $length_bladeDO - $S01_length - 20]
              set S03_length  10 ;#[expr [lindex $p_04 0] - 20]                       
              set S04_length  10                         
              set S01_angle   $bendAngle
              set S02_angle   0                       
              set S03_angle   0                       
              set S01_radius  $bendRadius
              set S02_radius  0
              set S03_radius  0            

                # -- set centerLine of bent tube
              set centerLineDef [list $S01_length $S02_length $S03_length  $S04_length \
                                      $S01_angle  $S02_angle $S03_angle \
                                      $S01_radius $S02_radius $S03_radius]              
              

                # -- set profile of bent tube
              set tubeProfile [lib_tube::init_tubeProfile $profileDef]              
                  # puts "   -> \$profileDef   $profileDef"
                  # puts "   -> \$tubeProfile  $tubeProfile"
            }
            
          straight {
          
                # puts "\n ==== straight =========\n"  
                  
              set _dAngle   [expr atan(1.0*$height_bladeDO/$length_bladeDO)]
              set _hypot    [expr hypot($length_bladeDO,$height_bladeDO)]
              set _pAngle   [expr asin($dropOutPerp/$_hypot)]
              
              set length    [expr sqrt(pow($_hypot,2) - pow($dropOutPerp,2)) - $dropOutOffset]
              
              set dirAngle     [expr (180/$vectormath::CONST_PI) * ($_dAngle - $_pAngle)]

              set segLength 30
              
              set p_01    [vectormath::rotateLine $p_00 $dropOutPerp    [expr 270 + $dirAngle]]
              set p_02    [vectormath::rotateLine $p_01 $dropOutOffset  [expr 180 + $dirAngle]]
              set p_03    [vectormath::rotateLine $p_02 $endLength      [expr 180 + $dirAngle]]
              set p_04    [vectormath::rotateLine $p_03 [expr 1.00 * $segLength]  [expr 180 + $dirAngle]]
              set p_05    [vectormath::rotateLine $p_04 [expr 1.00 * $segLength]  [expr 180 + $dirAngle]]
              set p_06    [list 0 0] 
              set p_15    [vectormath::rotateLine $p_03 100  [expr 170 + $dirAngle]]

                    #puts "   --> \$_hypot $_hypot"
                    #puts "   --> \$_dAngle $_dAngle"
                    #puts "   --> \$_pAngle $_pAngle"
                    #puts "   --> \$length $length"
              
              set angleRotation [expr 180 + $dirAngle]
                    #puts "   -> \$angleRotation $angleRotation\n"
              
              set S01_length  [expr 0.25 * $length]
              set S02_length  [expr 0.25 * $length]
              set S03_length  [expr 0.25 * $length]                       
              set S04_length  [expr 0.25 * $length]                         
              set S01_angle   0
              set S02_angle   0                       
              set S03_angle   0                       
              set S01_radius  0
              set S02_radius  0
              set S03_radius  0

                # -- set centerLine of straight tube
              set centerLineDef [list $S01_length $S02_length $S03_length  $S04_length \
                                      $S01_angle  $S02_angle $S03_angle \
                                      $S01_radius $S02_radius $S03_radius]
                                      
              # -- set profile of straight tube       
              set tubeProfile [lib_tube::init_tubeProfile $profileDef]                          
                  # puts "   -> \$profileDef   $profileDef"
                  # puts "   -> \$tubeProfile  $tubeProfile"
            }
            
          max {
                
                # puts "\n ==== MAX =========\n"  
                  
              set max_endLength   250
              set max_bendRadius  [expr 25.0]
                # puts "   -> \$max_Offset       $max_Offset"  
                # puts "   -> \$max_bendRadius   $max_bendRadius"                
                # puts "   -> \$max_endLength    $max_endLength"
              set bendAngle   [expr atan(1.0*$max_Offset/$max_endLength)]
                # puts "   -> \$bendAngle $bendAngle"  
              
              set l_bend_DO [expr hypot(($max_endLength+$dropOutOffset),$dropOutPerp)]
                # puts "   -> \$l_bend_DO $l_bend_DO"  
              set a_bend_DO [expr atan(1.0*$dropOutPerp/($max_endLength+$dropOutOffset))]
                # puts "   -> \$a_bend_DO $a_bend_DO"               
              set a_gamma   [expr $vectormath::CONST_PI-($bendAngle+$a_bend_DO)]
                # puts "   -> \$a_gamma   $a_gamma" 
              
              set l_bend_DO_x [expr $l_bend_DO * cos($bendAngle+$a_bend_DO)]
              set l_bend_DO_y [expr $l_bend_DO * sin($bendAngle+$a_bend_DO)]
                # puts "   -> \$l_bend_DO_x   $l_bend_DO_x" 
                # puts "   -> \$l_bend_DO_y   $l_bend_DO_y" 
              
              
              set l_cc      [expr hypot($length_bladeDO,$height_bladeDO)]
              set l_base    [expr sqrt(pow($l_cc,2) - pow($l_bend_DO_y,2)) - $l_bend_DO_x]
                # puts "   -> \$l_base   $l_base" 
              
              set _a_2       [expr pow($l_bend_DO,2)]
              set _b_2       [expr pow($l_base,2)]
              set _c_2       [expr pow($l_cc,2)]
              set _2ac       [expr 2*$l_bend_DO*$l_cc]
              
              set a_beta      [expr acos(($_c_2-$_b_2+$_a_2)/$_2ac)]
              set a_alpha     [expr $vectormath::CONST_PI - $a_beta - $a_gamma]
                # puts "   -> \$a_beta   $a_beta"               
                # puts "   -> \$a_alpha  $a_alpha"     

              set a_offset    [expr atan(1.0*$height_bladeDO/$length_bladeDO)]
                # puts "   -> \$a_offset   $a_offset"               
              set dirAngle    [expr $a_offset + $a_beta - $a_bend_DO]
                # puts "\n"
                # puts "   -> \$dirAngle  $dirAngle"     
              set dirAngle    [vectormath::grad $dirAngle]
                # puts "   -> \$dirAngle  $dirAngle"     
                # puts "\n"
              # puts "   -> \$max_Offset $max_Offset"  
              
                          
              set segLength [expr tan(0.5*$bendAngle)*$max_bendRadius] 
                # puts "   -> \$segLength    $segLength"               
                # puts "\n"              
                # puts "\n" 

              set p_01    [vectormath::rotateLine $p_00 $dropOutPerp    [expr 270 + $dirAngle]]
              set p_02    [vectormath::rotateLine $p_01 $dropOutOffset  [expr 180 + $dirAngle]]
              set p_03    [vectormath::rotateLine $p_02 [expr $max_endLength - 30]     [expr 180 + $dirAngle]]
              set p_04    [vectormath::rotateLine $p_02 $max_endLength  [expr 180 + $dirAngle]]
              set p_05    [vectormath::rotateLine $p_04 30 [expr 180 + $dirAngle  - $bendAngle*(180/$vectormath::CONST_PI)]]
              set p_06    [list 0 0] 
              # set p_06    [vectormath::rotateLine $p_04         [expr 180 + $dirAngle  - $bendAngle*(180/$vectormath::CONST_PI)]]
              set p_15    [vectormath::addVector $p_04  [list 0         [expr 1.0 * $max_bendRadius]]]

              set angleRotation [expr 180 + $dirAngle]  
                # puts "   -> \$angleRotation $angleRotation\n"

              set S01_length  [vectormath::length $p_02 $p_04]
              set S02_length  [expr [vectormath::length $p_04 $p_06] - 20] ;#[expr $length_bladeDO - $S01_length - 20]
              set S03_length  10                
              set S04_length  10                                          
              set S01_angle   [expr -1.0 * $bendAngle * (180/$vectormath::CONST_PI)]
              set S02_angle   0                       
              set S03_angle   0                       
              set S01_radius  $max_bendRadius
              set S02_radius  0
              set S03_radius  0  
                # puts "   -> \$S01_angle $S01_angle\n"

                # -- set centerLine of straight tube
              set centerLineDef [list $S01_length $S02_length $S03_length  $S04_length \
                                      $S01_angle  $S02_angle $S03_angle \
                                      $S01_radius $S02_radius $S03_radius]
                                      
              # -- set profile of straight tube                
              set profileDef {}
                  lappend profileDef [list 0   14]
                  lappend profileDef [list 250 36]
                  lappend profileDef [list 250 36]
                  lappend profileDef [list 250 36]       
              set tubeProfile [lib_tube::init_tubeProfile $profileDef]                 
                  # puts "   -> \$profileDef   $profileDef"
                  # puts "   -> \$tubeProfile  $tubeProfile"
            }
          default {}
        }
            
        foreach _p {p_00 p_01 p_02 p_03 p_04 p_05 p_06 p_15} {
          eval set xy \$$_p
          set xy [vectormath::addVector $xy [list $crownOffset $crownPerp]]
          set $_p ${xy}
        }
            
            
            

            # ------------------------------------
						# update $myCanvas ->
        set dropOutPos    {0 0}
        set dropOutAngle  [expr $angleRotation - $headTube_Angle]
                                
            # -- get smooth centerLine
        set retValues [lib_tube::init_centerLine $centerLineDef] 
        set centerLine  [lindex $retValues 0]
        set ctrLines    [lindex $retValues 1]
        
            # -- draw shape of tube
        set outLineLeft   [lib_tube::get_tubeShape    $centerLine $tubeProfile left  ]
        set outLineRight  [lib_tube::get_tubeShape    $centerLine $tubeProfile right ]
        set outLine       [canvasCAD::flatten_nestedList $outLineLeft $outLineRight]
        set angleRotation [expr $angleRotation - $headTube_Angle]


        set addVector [list $dropOutOffset $dropOutPerp]
        
            # -- get oriented tube
        set outLine [vectormath::addVectorPointList     $addVector $outLine]
        set outLine [vectormath::rotatePointList {0 0} $outLine $angleRotation]
        
            # -- get oriented centerLine
        set centerLine [vectormath::addVectorPointList  $addVector [canvasCAD::flatten_nestedList $centerLine]]
        set centerLine [vectormath::rotatePointList {0 0} $centerLine $angleRotation]

        return [list $outLine $centerLine $dropOutPos $dropOutAngle]

		}

    proc update_board {{value {0}}} {
			
				variable  myCanvas
        
        variable unbentShape
        variable profileDef
        
        variable debugMode
        variable headTube_Angle
        
        variable forkHeight
        variable forkRake   
        variable length_bladeDO
        variable height_bladeDO
        variable crownOffset   
        variable crownPerp     
        variable dropOutOffset
        variable dropOutPerp
        variable endLength
        variable bendRadius
        variable max_Offset
        variable bladeType
				
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
        
        variable  profile_x00
        variable  profile_y00
        variable  profile_x01
        variable  profile_y01
        variable  profile_x02
        variable  profile_y02
        variable  profile_x03
        variable  profile_y03
        
        set dropOutPos  {150 60}
        
        dict create dict_ForkBlade {}
        dict append dict_ForkBlade env \
                [list dropOutPosition $dropOutPos     \
                      forkHeight      $forkHeight     \
                      forkRake        $forkRake       \
                      crownOffset     $crownOffset    \
                      crownPerp       $crownPerp      \
                      dropOutOffset   $dropOutOffset  \
                      dropOutPerp     $dropOutPerp    \
                      headTubeAngle   $headTube_Angle \
                ]
        dict append dict_ForkBlade blade \
                [list type            $bladeType   \
                      endLength       $endLength   \
                      bendRadius      $bendRadius  \
                ]
        dict append dict_ForkBlade profile \
                [list [list 0            $profile_y00] \
                      [list $profile_x01 $profile_y01] \
                      [list $profile_x02 $profile_y02] \
                      [list $profile_x03 $profile_y03] \
                ]
                
                     
          # puts $dict_ForkBlade                            
          
          # variable endLengthendLength
          # variable bendRadiusbendRadius
          # variable max_Offsetmax_Offset
          # variable bladeType     bladeType                
          # puts "\n  -> update_board:   $myCanvas"
				
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
				
        set length_bladeDO  [expr $forkHeight - $crownOffset]
        set height_bladeDO  [expr $forkRake - $crownPerp]
        
            # draw orientation of bent tube
        set orient_01 [list 0 0]
        set orient_02 [list $crownOffset 0]
        set orient_03 [list $crownOffset $crownPerp]
        set orient_04 [list $forkHeight $crownPerp]
        set orient_05 [list $forkHeight $forkRake]
        
            # ------------------------------------
						# update $myCanvas ->

        set retValue [lib_tube::get_ForkBlade $dict_ForkBlade]
        # set retValue [getBlade $dict_ForkBlade]
        
        set outLine         [lindex $retValue 0]
        set centerLine      [lindex $retValue 1]
        set brakeDefLine    [lindex $retValue 2]
        #  set dropOutPos      [lindex $retValue 3]
        set dropOutAngle    [lindex $retValue 3]
        
        puts "   \$brakeDefLine $brakeDefLine"
        
        set p_99  [vectormath::rotateLine $dropOutPos $dropOutOffset $dropOutAngle]
        set p_98  [vectormath::rotateLine $p_99       $dropOutPerp [expr  90 + $dropOutAngle]]
        set p_60  [vectormath::rotateLine $dropOutPos $forkRake    [expr 270 - $headTube_Angle]]
        set p_00  [vectormath::rotateLine $p_60       $forkHeight  [expr 180 - $headTube_Angle]]
        set p_10  [vectormath::rotateLine $p_00       $crownPerp   [expr  90 - $headTube_Angle]]
        set p_20  [vectormath::rotateLine $p_10       $crownOffset [expr   0 - $headTube_Angle]]
        
        
        $myCanvas addtag {__OutLine__}     withtag  {*}[$myCanvas  create   polygon $outLine      -tags dimension  -fill lightgray -outline darkblue]
        $myCanvas addtag {__CenterLine__}  withtag  {*}[$myCanvas  create   line    $centerLine   -tags dimension  -fill darkorange ]
        $myCanvas addtag {__CenterLine__}  withtag  {*}[$myCanvas  create   line    $brakeDefLine -tags dimension  -fill darkorange ]
        $myCanvas  create   circle  	$dropOutPos   -radius 2  -tags {__CenterLine__}  -fill white -outline blue  -width 1 
        $myCanvas  create   circle  	$p_00         -radius 2  -tags {__CenterLine__}  -fill white -outline blue  -width 1 
        
        $myCanvas  create   circle  	$p_98         -radius 1  -tags {__CenterLine__}  -fill white -outline red  -width 1 
        $myCanvas  create   circle  	$p_20         -radius 1  -tags {__CenterLine__}  -fill white -outline red  -width 1 
        
        $myCanvas  create   circle  	{0 0}         -radius 20 -tags {__CenterLine__}  -fill white -outline darkred  -width 2 
        
        set lineDef [canvasCAD::flatten_nestedList $dropOutPos $p_99 $p_98 $dropOutPos]
        $myCanvas addtag {__CenterLine__}  withtag  {*}[$myCanvas  create   line    $lineDef  -tags dimension  -fill blue ]
        
        set lineDef [canvasCAD::flatten_nestedList $dropOutPos $p_60 $p_00]
        $myCanvas addtag {__CenterLine__}  withtag  {*}[$myCanvas  create   line    $lineDef  -tags dimension  -fill darkred ]
        
        set lineDef [canvasCAD::flatten_nestedList $p_20 $p_00 $p_10 $p_20]
        $myCanvas addtag {__CenterLine__}  withtag  {*}[$myCanvas  create   line    $lineDef  -tags dimension  -fill blue ]
        
        
        set tagDimension [ $myCanvas dimension  length   [list $dropOutPos {0 0}] {vertical}    $dim_dist  $dim_offset  $font_colour ] 
              lappend __Dimension__ $tagDimension
        set tagDimension [ $myCanvas dimension  length   [list {0 0} $dropOutPos] {horizontal}  $dim_dist  $dim_offset  $font_colour ] 
              lappend __Dimension__ $tagDimension
       
        set tagDimension [ $myCanvas dimension  length   [list $p_00 $p_60]       {aligned}  $dim_dist  $dim_offset  $font_colour ] 
              lappend __Dimension__ $tagDimension
        set tagDimension [ $myCanvas dimension  length   [list $p_60 $dropOutPos] {aligned}  $dim_dist  $dim_offset  $font_colour ] 
              lappend __Dimension__ $tagDimension
       
        set tagDimension [ $myCanvas dimension  length   [list $p_10 $p_00]       {aligned}  20  $dim_offset  $font_colour ] 
              lappend __Dimension__ $tagDimension
        set tagDimension [ $myCanvas dimension  length   [list $p_20 $p_10]       {aligned}  20  $dim_offset  $font_colour ] 
              lappend __Dimension__ $tagDimension

        set tagDimension [ $myCanvas dimension  length   [list $dropOutPos $p_99] {aligned}  20  $dim_offset  $font_colour ] 
              lappend __Dimension__ $tagDimension
        set tagDimension [ $myCanvas dimension  length   [list $p_99 $p_98]       {aligned}  20  20  $font_colour ] 
              lappend __Dimension__ $tagDimension
              
        


        
        $myCanvas fit2Stage {__CenterLine__ __Dimension__ __profileLine__ __OutLine__}
        return            
                
            set tagDimension [ $myCanvas dimension  length   [list $p_03 $p_02]  {aligned}  $dim_dist  $dim_offset  $font_colour ] 
              lappend __Dimension__ $tagDimension
            set tagDimension [ $myCanvas dimension  length   [list $p_05 $p_03]  {aligned}  $dim_dist  $dim_offset  $font_colour ] 
              lappend __Dimension__ $tagDimension
            set tagDimension [ $myCanvas dimension  length   [list $p_03 $p_04]  {aligned}  $dim_dist  $dim_offset  $font_colour ] 
              lappend __Dimension__ $tagDimension


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

				pack  $f_settings.orientation		\
							$f_settings.centerline	\
							$f_settings.tubeprofile		\
							$f_settings.precission  \
							$f_settings.font		\
							$f_settings.demo		\
							$f_settings.scale   -fill x -side top 

        create_config_line $f_settings.orientation.d_00   "headTube_Angle:  "  sketchboard::headTube_Angle    60   100   ;#   0
        create_config_line $f_settings.orientation.x_00   "    forkHeight:  "  sketchboard::forkHeight        250  550   ;#   0
        create_config_line $f_settings.orientation.y_00   "      forkRake:  "  sketchboard::forkRake          -60   60   ;#   0
        create_config_line $f_settings.orientation.x_01   "   crownOffset:  "  sketchboard::crownOffset        -5   50   ;#   0
        create_config_line $f_settings.orientation.y_01   "     crownPerp:  "  sketchboard::crownPerp         -10   30   ;#   0
        create_config_line $f_settings.orientation.l_00   " dropOutOffset:  "  sketchboard::dropOutOffset       0   30   ;#   0
        create_config_line $f_settings.orientation.o_00   "   dropOutPerp:  "  sketchboard::dropOutPerp       -10   30   ;#   0
        create_config_line $f_settings.orientation.l_01   "     endLength:  "  sketchboard::endLength           0  300   ;#   0
        create_config_line $f_settings.orientation.r_00   "    bendRadius:  "  sketchboard::bendRadius          0  700   ;#   0
        
        # create_config_line $f_settings.orientation.x_00   "length_bladeDO:  "  sketchboard::length_bladeDO    250  550   ;#   0
        # create_config_line $f_settings.orientation.y_00   "height_bladeDO:  "  sketchboard::height_bladeDO    -60   60   ;#   0
        # create_config_line $f_settings.orientation.m_00   "    max_Offset:  "  sketchboard::max_Offset          0  100   ;#   0
				
				radiobutton        $f_settings.orientation.left    -text "straight   "  -variable  "sketchboard::bladeType"  -value     "straight"   -command   "sketchboard::update_board"
				radiobutton        $f_settings.orientation.center  -text "bent       "  -variable  "sketchboard::bladeType"  -value     "bent" -command   "sketchboard::update_board"
				radiobutton        $f_settings.orientation.right   -text "MAX        "  -variable  "sketchboard::bladeType"  -value     "max"  -command   "sketchboard::update_board"
				
        radiobutton        $f_settings.orientation.debug_on   -text "on         "  -variable  "sketchboard::debugMode"  -value     "on"  -command   "sketchboard::update_board"
        radiobutton        $f_settings.orientation.debug_off  -text "off        "  -variable  "sketchboard::debugMode"  -value    "off"  -command   "sketchboard::update_board"

				
        
				#create_config_line $f_settings.centerline.s01_l  "length (01):  "  sketchboard::S01_length      5  290   ;#150
				#create_config_line $f_settings.centerline.s02_l  "length (02):  "  sketchboard::S02_length     30  290  ;# 160
				#create_config_line $f_settings.centerline.s03_l  "length (03):  "  sketchboard::S03_length     80  250  ;# 115
				#create_config_line $f_settings.centerline.s04_l  "length (04):  "  sketchboard::S04_length     40  250  ;# 115
				
        #create_config_line $f_settings.centerline.s01_a  "   angle (01):"  sketchboard::S01_angle     -30   30
        #create_config_line $f_settings.centerline.s02_a  "   angle (02):"  sketchboard::S02_angle     -30   30
        #create_config_line $f_settings.centerline.s03_a  "   angle (03):"  sketchboard::S03_angle     -30   30

				#create_config_line $f_settings.centerline.s01_r  "  radlus (01):"  sketchboard::S01_radius     50  590   ;# 320     			
				#create_config_line $f_settings.centerline.s02_r  "  radlus (02):"  sketchboard::S02_radius     30  590   ;# 320
				#create_config_line $f_settings.centerline.s03_r  "  radlus (03):"  sketchboard::S03_radius     30  590   ;# 320
        
				
        #create_config_line $f_settings.tubeprofile.x_00     "        x00:  "  sketchboard::profile_x00        0   0   ;#   0
				create_config_line $f_settings.tubeprofile.y_00     "        y00:  "  sketchboard::profile_y00       10  40   ;#  12.50
				create_config_line $f_settings.tubeprofile.x_01     "        x01:  "  sketchboard::profile_x01        5 320   ;# 150 
				create_config_line $f_settings.tubeprofile.y_01     "        y01:  "  sketchboard::profile_y01       10  40   ;#  18
				create_config_line $f_settings.tubeprofile.x_02     "        x02:  "  sketchboard::profile_x02      100 350   ;# 150
				create_config_line $f_settings.tubeprofile.y_02     "        y02:  "  sketchboard::profile_y02       15  40   ;#  18
				create_config_line $f_settings.tubeprofile.x_03     "        x03:  "  sketchboard::profile_x03       50 100   ;#  75
				create_config_line $f_settings.tubeprofile.y_03     "        y03:  "  sketchboard::profile_y03       15  40   ;#  24

        create_config_line $f_settings.precission.prec    " precission:  "  sketchboard::arcPrecission    1  15   ;#  24

        
				
																						
				
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
						$f_settings.orientation.debug_on \
						$f_settings.orientation.debug_off \
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
  
  
   
 
 

 