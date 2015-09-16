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

 
    set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
        puts "   -> \$BASE_Dir:   $BASE_Dir\n"

        # -- Libraries  ---------------
    lappend auto_path           [file join $BASE_Dir lib]
    lappend auto_path           [file join $BASE_Dir ..]
        # puts "   -> \$auto_path:  $auto_path"

        # -- Packages  ---------------
    package require   bikeGeometry  1.59
    package require   vectormath    
    package require   appUtil

        # -- Directories  ------------
    set TEST_Dir    [file join $BASE_Dir test]
    set SAMPLE_Dir  [file join $TEST_Dir sample]
        # puts "   -> SAMPLE_Dir: $SAMPLE_Dir"


 
        # set BASE_Dir  [file normalize [file dirname [file normalize $::argv0]]] 
        # set APPL_ROOT_Dir [file dirname $BASE_Dir]
        # puts "   \$BASE_Dir ........ $BASE_Dir"
        # puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"
        # 
        # lappend auto_path "$APPL_ROOT_Dir"
        # lappend auto_path "$APPL_ROOT_Dir/../vectormath"
        # lappend auto_path "$APPL_ROOT_Dir/../app-vectormath"
        # lappend auto_path "$APPL_ROOT_Dir/../canvasCAD"
        # lappend auto_path "$APPL_ROOT_Dir/../app-canvasCAD"
        # 
    package require 	Tk
    package require   vectormath
    package require   canvasCAD
    package require   bikeGeometry
        # 
        # set w_textReport            {}

 


        # -- Directories  ------------
    set TEST_Dir    [file join $BASE_Dir test]
    set SAMPLE_Dir  [file join $TEST_Dir sample]
        # puts "   -> SAMPLE_Dir: $SAMPLE_Dir"    set sampleFile  [file join $SAMPLE_Dir ktm_ultra_force_27.xml]
        # puts "   -> sampleFile: $sampleFile"
    set sampleFile  [file join $SAMPLE_Dir ktm_ultra_force_27.xml]
    
         # -- Content  --------------
    puts "\n   -> getContent: $sampleFile:"
    set fp [open $sampleFile]
    fconfigure    $fp -encoding utf-8
    set xml [read $fp]
    close         $fp
    set sampleDOC   [dom parse  $xml]
    set sampleDOM   [$sampleDOC documentElement]
        #
    bikeGeometry::set_newProject $sampleDOM
        #
    bikeGeometry::set_to_project
        #
        #
        #


 
 	
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
                            -command      "::updateValue $entry_var" \
							-variable     $entry_var \
							-from         $start \
							-to           $end 
                                # -command      "sketchboard::update_board"
								# -resolution   $resolution
								
			pack      $w.lb  $w.cfg $w.scl    -side left  -fill x
            #bind      $w.cfg <Leave>  "sketchboard::update_board {*}$entry_var"
            #bind      $w.cfg <Return> "sketchboard::update_board {*}$entry_var"
            bind      $w.cfg <Leave>  "::updateValue $entry_var"
            bind      $w.cfg <Return> "::updateValue $entry_var"
            # trace add variable    $entry_var   write [list puts ""  -> update"]
				    
	}
	proc create_status_line {w lb_text entry_var} {	     
			frame   $w
			pack    $w
	 
			global $entry_var

			label     $w.lb     -text $lb_text            -width 20  -bd 1  -anchor w 
			entry     $w.cfg    -textvariable $entry_var  -width 10  -bd 1  -justify right -bg white 
			pack      $w.lb  $w.cfg    -side left  -fill x		    
	}
	proc updateValue {varName args} {
	    puts "   ... updateValue:  $varName $args"
	    switch -exact $varName {
            sketchboard::teethCount {
                    update 
                    # puts "   -> $varName $value"
                    set value $sketchboard::teethCount
                    set $varName $value
                    return
                }
            default {
                # puts "   default -> $varName $value"
            }
        }
	}
	proc exportSVG {} {
        variable w_textReport
	    set xmlContent [$w_textReport get 1.0  end]
	    puts "$xmlContent"
	    
        set types {
                {{SVG}       {.svg}  }
            }
        set initialFile "ChainWheel_Profile_$sketchboard::teethCount"
        set initialDir  $::env(USERPROFILE)  
        
        set fileName    [tk_getSaveFile -initialdir $initialDir -initialfile $initialFile -filetypes $types]  
        if {$fileName == {}} return
            # -- $fileName has extension xml
                # puts " [file extension $fileName] "
        if {! [string equal [file extension $fileName] {.svg}]} {
            set fileName [format "%s.%s" $fileName svg]
            puts "           ... new $fileName"
        }  
        
        # -- open File for writing
        if {[file exist $fileName]} {
            if {[file writable $fileName]} {
                set fp [open $fileName w]
                puts $fp $xmlContent
                close $fp
                puts ""
                puts "         ------------------------"
                puts "           ... write:"   
                puts "                       $fileName"
                puts "                   ... done"
            } else {
            tk_messageBox -icon error -message "File: \n   $fileName\n  ... not writeable!"
            exportSVG
            }
        } else {
                set fp [open $fileName w]
                puts $fp $xmlContent
                close $fp
                puts ""
                puts "         ------------------------"
                puts "           ... write:"  
                puts "                       $fileName "
                puts "                   ... done"
        }
                  
            
            
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
            #
        variable teethCount         53
		variable bcDiameter        110
        variable spyderArms          5
	}
	
				
    proc sketchboard::createStage {cv_path cv_width cv_height st_width st_height unit st_scale args} {
        variable myCanvas
        variable cv_scale
        set myCanvas [canvasCAD::newCanvas cv01  $cv_path 	"MyCanvas"  $cv_width $cv_height 	A3 0.5 40 $args]
        set cv_scale [$myCanvas getNodeAttr Canvas scale]
        return $myCanvas
    }
    
    proc sketchboard::update_board {{value {0}} args} {
        
            variable  myCanvas
            
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
                #
            variable  teethCount
            variable  bcDiameter
            variable  spyderArms
            
            #set value $teethCount
            puts "   -> $value "
            if {$value == {update}} {
                # --- values on bind are: sketchboard::teethCount {} write 
                set value $teethCount
                puts "   --> $value "
            }

            
            $myCanvas clean_StageContent
            set board [ $myCanvas getNodeAttr Canvas  path ]
        
            if {$font_colour == {default}} { set font_colour [ $myCanvas getNodeAttr Style  fontcolour ]}
            
            puts "\n\n============================="
            puts "   -> drw_scale:          $drw_scale"
            puts "   -> font_colour:        $font_colour"
            puts "   -> dim_size:           $dim_size"
            puts "   -> dim_font_select:    $dim_font_select"
            puts "\n============================="
            puts "   -> Drawing:            [[$myCanvas getNode Stage] asXML]"
            puts "\n============================="
            puts "   -> Style:              [[$myCanvas getNode Style] asXML]"
            puts "\n============================="
            puts "   -> teethCount:         $teethCount"
            puts "   -> bcDiameter:         $bcDiameter"
            puts "   -> spyderArms:         $spyderArms"
            puts "\n============================="
            #$myCanvas reportMyDictionary
            puts "\n============================="
            puts "\n\n"

            $myCanvas setNodeAttr Stage scale       $drw_scale
            $myCanvas setNodeAttr Style fontstyle   $dim_font_select
            $myCanvas setNodeAttr Style fontsize    $dim_size
            
            
            
            if {$demo_type != {dimension} } {
                sketchboard::demo_canvasCAD 
                return
            }
            
            # ------------------------------------
                    # update $myCanvas ->
            
            set p_end   [vectormath::rotateLine  {0 0}  $end_length    $teethCount]
         
            $myCanvas addtag {__ChainWheel__} withtag  [$myCanvas  create   circle {0 0}    -radius 2  -outline red     -fill white]

            $myCanvas addtag {__ChainWheel__} withtag  [$myCanvas  create   line [list  0 0  [lindex $p_end 0]  [lindex $p_end 1] ] -tags dimension  -fill blue ]
            
            
            
            # ------------------------------------
            #  bikeGeometry::paramComponent::_get_polygon_ChainWheel {teethCount position armCount bcDiameter visMode}
            #  bikeGeometry::get_paramComponent {type args}
            # set polygonChainWheel   [rattleCAD::model::get_paramComponent   ChainWheel $teethCount  {0 0}]
            # set polygonChainWheel   [bikeGeometry::get_paramComponent   ChainWheel $teethCount  {0 0}  4 110]
            set polygonChainWheel   [bikeGeometry::get_paramComponent   ChainWheel $teethCount  {0 0}  polyline  $spyderArms  $bcDiameter]
            set outerChainRingTags {}
                #
            set tagName myTags
            foreach {mode coords} $polygonChainWheel {
                    #
                switch -exact $mode {
                    closed {
                        set myObject   [$myCanvas create polygon     $coords  -tags {__Decoration__ __Crankset__ __ChainWheel__}      -fill white  -outline black]
                    }
                    opened {
                        set myObject   [$myCanvas create line        $coords  -tags {__Decoration__ __Crankset__ __ChainWheel__}      -fill black]
                    }
                    bcd    {}
                    default {
                        tk_messageBox -message " $mode \n $coords "
                    }
                }
                catch {$myCanvas addtag $tagName withtag $myObject}
                catch {lappend outerChainRingTags $myObject}
            }
                #
            catch {$myCanvas addtag $tagName withtag $chainWheel}
            catch {$myCanvas addtag $tagName withtag $chainWheelRing}
                #
            
            
            
            # ------ create circle as chain-representation
            set toothWith           12.7
            set toothWithAngle      [expr 2*$vectormath::CONST_PI/$teethCount]
            set chainWheelRadius    [expr 0.5*$toothWith/sin([expr 0.5*$toothWithAngle])]
                    # =0,5*H6/SIN(D13)
            set index 0
            set toothProfileList {}
            while { $index < $teethCount } {
                set currentAngle [expr $index * [vectormath::grad $toothWithAngle]]
                set pos [vectormath::rotateLine {0 0} $chainWheelRadius $currentAngle ]
                $myCanvas addtag {__ChainWheel__} withtag  [$myCanvas  create   circle  $pos -radius 3.8]  
                
                set pt_00 {2 5}                                 ; foreach {x0 y0} $pt_00 break
                set pt_01 [vectormath::rotateLine {0 0} 3.8 100]    ; foreach {x1 y1} $pt_01 break
                set pt_02 [vectormath::rotateLine {0 0} 3.8 125]    ; foreach {x2 y2} $pt_02 break
                set pt_03 [vectormath::rotateLine {0 0} 3.8 150]    ; foreach {x3 y3} $pt_03 break
                set pt_04 [vectormath::rotateLine {0 0} 3.8 170]    ; foreach {x4 y4} $pt_04 break
                set tmpList_00 [list $x0 -$y0    $x1 -$y1    $x2 -$y2    $x3 -$y3    $x4 -$y4    $x4 $y4    $x3 $y3    $x2 $y2    $x1 $y1    $x0 $y0]
                set tmpList_01 {}
                foreach {x y} $tmpList_00 {
                    set pt_xy [list $x $y]
                    set pt_xy [vectormath::rotatePoint {0 0} $pt_xy $currentAngle]
                    set pt_xy [vectormath::addVector $pos $pt_xy]
                    set tmpList_01 [lappend tmpList_01 [canvasCAD::flatten_nestedList $pt_xy] ]
                }
                set toothProfileList [lappend toothProfileList [canvasCAD::flatten_nestedList $tmpList_01]]
                set index [expr $index + 1]
            }
            set toothProfileList [canvasCAD::flatten_nestedList $toothProfileList]
            
            #set chainWheelProfile [$myCanvas  create polygon $toothProfileList -fill white -outline black]
            #$myCanvas addtag {__ChainWheel__} withtag  $chainWheelProfile           
                
            $::f_report.text delete 1.0  end 
            $::f_report.text insert end "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n"
            
            
            $::f_report.text insert end "<svg xmlns=\"http://www.w3.org/2000/svg\"\n"
            $::f_report.text insert end "width=\"500mm\" height=\"500mm\"\n" 
            $::f_report.text insert end "viewBox=\"-250 -250 500 500\"\n"
            $::f_report.text insert end "version=\"1.1\">\n"
            
            $::f_report.text insert end "<g>\n"
            $::f_report.text insert end "   <polygon points=\""
            foreach {x y} $toothProfileList {
                $::f_report.text insert end "$x,$y  "
            }
            $::f_report.text insert end "\"  />"
            $::f_report.text insert end "\n"
            $::f_report.text insert end "   <circle  cx=\"00\" cy=\"00\" r=\"4.5\" id=\"center_00\"/>\n"
            $::f_report.text insert end "</g>\n"
            $::f_report.text insert end "</svg>\n"
            sketchboard::moveto_StageCenter {__ChainWheel__}

    }
    


    


 
    proc sketchboard::moveto_StageCenter {item} {
        variable myCanvas
        set stage 		[ $myCanvas getNodeAttr Canvas path ]
        set stageCenter [ canvasCAD::get_StageCenter $stage ]
        set bottomLeft  [ canvasCAD::get_BottomLeft  $stage ]
        foreach {cx cy} $stageCenter break
        foreach {lx ly} $bottomLeft  break
        $stage move $item [expr $cx - $lx] [expr $cy -$ly]
    }
    
    proc sketchboard::demo_canvasCAD {} {
                    
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
    
    proc sketchboard::recenter_board {} {
        
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
    proc sketchboard::refit_board {} {
        
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
    proc sketchboard::scale_board {{value {1}}} {
        
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
    
    
    proc sketchboard::dimensionMessage { x y id} {
        tk_messageBox -message "giveMessage: $x $y $id"
        
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

				create_config_line $f_settings.settings.teeth     "Teeth (count):        "  sketchboard::teethCount      2  99
				create_config_line $f_settings.settings.bcd       "BoltCircle (diameter):"	sketchboard::bcDiameter     60 135
				create_config_line $f_settings.settings.arms      "SpyderArm (count):    "	sketchboard::spyderArms      1   7
				
				radiobutton        $f_settings.length.aligned \
											-text      "aligned   " \
											-variable  "sketchboard::dim_type_select" \
											-value     "aligned" \
											-command   "sketchboard::update_board"
																						
				
				#create_config_line $f_settings.scale.drw_scale	" Drawing scale "  sketchboard::drw_scale	 0.2  2  
				#				   $f_settings.scale.drw_scale.scl      configure   -resolution 0.1
				create_config_line $f_settings.scale.cv_scale	" Canvas scale  "  sketchboard::cv_scale	 0.2  5.0  
								   $f_settings.scale.cv_scale.scl      	configure   -resolution 0.1  -command "sketchboard::scale_board"
				button  		   $f_settings.scale.recenter   -text "recenter"   -command {sketchboard::recenter_board}
				button  		   $f_settings.scale.refit		-text "refit"      -command {sketchboard::refit_board}
				
				pack  	$f_settings.settings.teeth \
						$f_settings.length.aligned \
						$f_settings.scale.cv_scale \
						$f_settings.scale.recenter \
						$f_settings.scale.refit \
					 -side top  -fill x		
					 # $f_settings.scale.drw_scale \					   						   
					 
	pack  $f_settings  -side top -expand yes -fill both
	 
	#
	### -- G U I - canvas print
		
    	#set f_print  [labelframe .f0.f_config.f_print  -text "Print" ]
    	#	button  $f_print.bt_print   -text "print"  -command {$sketchboard::myCanvas print "E:/manfred/_devlp/_svn_sourceforge.net/canvasCAD/trunk/_print"} 
    	#pack  $f_print  -side top 	-expand yes -fill x
    	#	pack $f_print.bt_print 	-expand yes -fill x
	
	
	#
	### -- G U I - canvas demo
		
	set f_demo  [labelframe .f0.f_config.f_demo     -text "Demo" ]
		button  $f_demo.bt_clear   -text "clear"    -command {$sketchboard::myCanvas clean_StageContent} 
		button  $f_demo.bt_update  -text "update"   -command {sketchboard::update_board}
 	
	pack  $f_demo  -side top 	-expand yes -fill x
		pack $f_demo.bt_clear 	-expand yes -fill x
		pack $f_demo.bt_update 	-expand yes -fill x
	
	
	#
	### -- G U I - canvas status
		
    	#set f_status  [labelframe .f0.f_config.f_status  -text "status" ]
    		#create_status_line  $f_status.cv_width   "canvas width:"   canvas_width 
    		#create_status_line  $f_status.cv_heigth  "canvas heigth:"  canvas_heigth 
    	#pack  $f_status  -side top -expand yes -fill x


	#
	### -- G U I - canvas report
		
	set f_report  [labelframe .f0.f_config.f_report  -text "report" ]

				text  		   	   $f_report.text -width 50
				scrollbar 		   $f_report.sby -orient vert -command "$f_report.text yview"
								   $f_report.text conf -yscrollcommand "$f_report.sby set"
                
	pack $f_report  -side top 	-expand yes -fill both
    pack $f_report.sby $f_report.text -expand yes -fill both -side right   
    
        set w_textReport $f_report.text  
    
    set f_export  [labelframe .f0.f_config.f_export  -text "export" ]
    button             $f_export.bt_export  -text "export SVG"   -command {exportSVG}
    pack $f_export  -side top   -expand yes -fill both
    pack $f_export.bt_export -expand yes -fill both -side bottom        
    
	
	
	####+### E N D
  set sketchboard::teethCount  53
  set sketchboard::bcDiameter 115
  set sketchboard::spyderArms   4
  trace add variable    ::sketchboard::teethCount   write "sketchboard::update_board update"
  trace add variable    ::sketchboard::bcDiameter   write "sketchboard::update_board update"
  trace add variable    ::sketchboard::spyderArms   write "sketchboard::update_board update"
  
  update

 
  $sketchboard::myCanvas reportXMLRoot
  
  wm minsize . [winfo width  .]   [winfo height  .]
  
  
   
 
 

 