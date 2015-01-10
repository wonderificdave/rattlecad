 ##+##########################################################################
 #
 # package: rattleCAD   ->  lib_test.tcl
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
 #  namespace:  rattleCAD::test
 # ---------------------------------------------------------------------------
 #
 #
 namespace eval rattleCAD::test {
    variable runningStatus {off}
   
    proc runDemo {{testProcedure {}}} {
        variable runningStatus on
        
        if {$testProcedure == {}} {
            set testProcedure   integrationTest_00     
        }  
        set timeStart    [clock milliseconds]
        set messageValue "... runDemo started"
          #
        
        switch -exact $testProcedure {
            integrationTest_00 {
                      # tk_messageBox -title "integration Test" -message "... start integrationTest 00"
                    [namespace current]::integrationTest_00 
                    set messageValue "... integrationTest 00"
                      # tk_messageBox -title "integration Test" -message "... integrationTest 00\n      ... done!"
                }
            integrationTest_special {
                      # tk_messageBox -title "integration Test" -message "... start integrationTest 00"
                    [namespace current]::testResultParameter
                    set messageValue "... integrationTest special"
                }
            method_rattleCAD_HandleBarandSaddle {
                    while {$runningStatus != {off}} {
                          # tk_messageBox -title "Demontsration" -message "... show rattleCAD Principle"
                        [namespace current]::method_rattleCAD_HandleBarandSaddle
                        set messageValue "... rattleCAD Method: HandleBar and Saddle!"
                          # tk_messageBox -title "Demontsration" -message "... rattleCAD Principle!"
                    }
                } 
            method_classic_SeatandTopTube {
                    while {$runningStatus != {off}} {
                          # tk_messageBox -title "Demontsration" -message "... show rattleCAD Principle"
                        [namespace current]::method_classic_SeatandTopTube
                        set messageValue "... Classic Method: Seat- and TopTube !"
                          # tk_messageBox -title "Demontsration" -message "... rattleCAD Principle!"
                    }
                } 
            loopSamples {
                    while {$runningStatus != {off}} {
                          # tk_messageBox -title "loop Samples" -message "... start loopSamples"
                        [namespace current]::loopSamples
                        set messageValue "... start loopSamples"        
                          # tk_messageBox -title "loop Samples" -message "... rattleCAD Samples!"
                    }
                }    
            demo_01 {
                    while {$runningStatus != {off}} {
                          # tk_messageBox -title "Demontsration" -message "... show rattleCAD Principle"
                        [namespace current]::demo_01
                        set messageValue "... rattleCAD Principle!"
                           # tk_messageBox -title "Demontsration" -message "... rattleCAD Principle!"
                    }
                }    
   
            default {}       
        }
        
        set timeEnd     [clock milliseconds]
        set timeUsed    [expr 0.001*($timeEnd - $timeStart)]
        tk_messageBox -title "Demonstration" -message "$messageValue\n       elapsed: $timeUsed seconds"      
    }

    proc stopDemo {{mode {init}}} {
        variable runningStatus
        
        if {$mode == {init}} {
            if {$runningStatus != {off}} {
                set runningStatus off
                puts "\n"
                puts "   ... current [namespace current]::runDemo stopped"
                puts "\n"
                return
            }
        } else {
              # -- reset demoText
            set targetCanvas [rattleCAD::view::gui::current_canvasCAD]
            createDemoText  $targetCanvas  ""
              #
            return
              #
        }
    }
    
    proc keepRunning {} {
        variable runningStatus
        puts "\n  ... keepRunning $runningStatus\n"
        if {$runningStatus == {off}} {
            puts "\n  ... stop procedure $runningStatus\n"
            return 0; # if 0 ... failed
        } else {
            puts "\n  ... keep running $runningStatus\n"
            return 1; # if 1 ... OK
        }
    }
    
     
    #-------------------------------------------------------------------------
        #  integrationTest_00
        #
    proc integrationTest_00 {args} {
          
		puts "\n\n ====== integrationComplete ================ \n\n"
		puts "    --- integrationTest_00 ---\n"
		
		set TEST_Dir         $::APPL_Config(TEST_Dir) 
		set SAMPLE_Dir       [file join ${TEST_Dir} sample]
		
		puts "        -> TEST_Dir:        $TEST_Dir"  
		puts "        -> SAMPLE_Dir:      $SAMPLE_Dir"  

		
		# -- keep on top --------------
		wm deiconify .
		
		# -- update display -----------
		rattleCAD::view::gui::notebook_refitCanvas	
  
		
		# -- integration test ---------
        puts "\n\n === open File  ===\n"  
		puts "          ... \n"
        
        set openFile         [file join  ${SAMPLE_Dir} __test_Integration_02.xml]
		puts "          ... $openFile\n"
		rattleCAD::model::file::openProject_xml   $openFile
		
		set openFile         [file join  ${SAMPLE_Dir} road_classic_1984_SuperRecord.xml]
		puts "          ... $openFile\n"
		rattleCAD::model::file::openProject_xml   $openFile
		
		
		puts "\n\n === export  pdf / html  ===\n"
		rattleCAD::view::gui::export_Project      pdf
		wm deiconify .
		update
		rattleCAD::view::gui::export_Project      html
		wm deiconify .        
		update
		
		
		puts "\n\n === export  svg / dxf /ps  ===\n"
		rattleCAD::view::gui::notebook_exportSVG  $::APPL_Config(EXPORT_Dir) no
		rattleCAD::view::gui::notebook_exportDXF  $::APPL_Config(EXPORT_Dir) no
		rattleCAD::view::gui::notebook_exportPS   $::APPL_Config(EXPORT_Dir) no
		wm deiconify .
		update
		
		
		puts "\n\n === open file  ===\n"
		puts "   -> ${SAMPLE_Dir}: ${SAMPLE_Dir}\n"
		if {[catch {glob -directory ${SAMPLE_Dir} *.xml} errMsg]} {
			foreach sampleFile [lsort [glob -directory ${SAMPLE_Dir} *.xml]] {
			   set openFile     [file join  ${SAMPLE_Dir} $thisFile]
			   puts "          ... integrationTest_00 opened"
			   puts "                 ... $openFile\n"
			   rattleCAD::model::file::openProject_xml   $openFile 
			   wm deiconify .
			   #update          
			}
		}
				
		
		puts "\n\n === open config Panel  ===\n"           
		set cfgPanel [rattleCAD::configPanel::create]
		puts "    ... $cfgPanel"
		
		
		puts "\n\n === open not existing file  ===\n"  
		set openFile     [file join  ${SAMPLE_Dir}    this_file_does_not_exist.xml]
		puts "          ... $openFile\n"
		rattleCAD::model::file::openProject_xml   $openFile   
		
				
		puts "\n\n === create Information  ===\n"      
		rattleCAD::infoPanel::create  .v_info 0
		
		puts "\n\n === create Help  ===\n"
		rattleCAD::infoPanel::create  .v_info 1
		
		puts "\n\n === create Environment  ===\n"
		rattleCAD::infoPanel::create  .v_info 2
		
		puts "\n\n === create_intro  ===\n"        
		create_intro .intro
		after  100 destroy .intro
	   
		
		puts "\n\n === open Config gPanel ===\n"        
		puts "    ... $cfgPanel"
		
		
		puts "\n\n === load template road again  ===\n"  
		puts "          ... Template  Road\n"
        rattleCAD::view::gui::load_Template  Road	

        
		puts "\n\n === demonstrate stack and reach  ===\n"  
		 # stack_and_reach
		

		puts "\n\n === load template road again  ===\n"  
		puts "          ... Template  Road\n"
        rattleCAD::view::gui::load_Template  Road	
        
        
        puts "\n\n === load template road again  ===\n"  
		puts "          ... Template  Road\n"
        rattleCAD::view::gui::load_Template  Road	
   
		
		puts "\n\n === end ===\n"       
		puts "   -> TEST_Dir: $TEST_Dir\n"   
   }   



    #-------------------------------------------------------------------------
        #  stack_and_reach
        #  
    proc method_rattleCAD_HandleBarandSaddle {} {
        set currentFile   [rattleCAD::control::getSession  projectFile]
		set SAMPLE_Dir     $::APPL_Config(SAMPLE_Dir)
                       
        puts "\n\n  ====== R A T T L E C A D    M E T H O D :   H A N D L E B A R   A N D   S A D D L E ===========\n"                         
        puts "" 
        
            #

            
        if 0 {   
                    # from seattubetoptube method
                set init_HB_Reach     [rattleCAD::model::get_Scalar     Geometry HandleBar_Distance]
                set init_HB_Stack     [rattleCAD::model::get_Scalar     Geometry HandleBar_Height]  
                set init_SD_Distance  [rattleCAD::model::get_Scalar     Geometry Saddle_Distance]   
                set init_SD_Height    [rattleCAD::model::get_Scalar     Geometry Saddle_Height]     
                set init_HT_Angle     [rattleCAD::model::get_Scalar     Geometry HeadTube_Angle]    
                set init_TT_Angle     [rattleCAD::model::get_Scalar     Geometry TopTube_Angle]     
                set init_HT_Length    [rattleCAD::model::get_Scalar     HeadTube Length]            
                set init_Stem_Length  [rattleCAD::model::get_Scalar     Geometry Stem_Length]       
                set init_Fork_Height  [rattleCAD::model::get_Scalar     Geometry Fork_Height]       
                set init_Fork_Rake    [rattleCAD::model::get_Scalar     Geometry Fork_Rake]         
                set init_ST_Length    [rattleCAD::model::get_Scalar     Geometry SeatTube_Virtual]  
                set init_TT_Length    [rattleCAD::model::get_Scalar     Geometry TopTube_Virtual]   
                set init_SD_Nose      [rattleCAD::model::get_Scalar     Geometry SaddleNose_BB_x]   
                set init_ST_Angle     [rattleCAD::model::get_Scalar     Geometry SeatTube_Angle]  
                set init_ST_Ext       [rattleCAD::model::get_Scalar     SeatTube Extension]
                set init_SS_Offset    [rattleCAD::model::get_Scalar     SeatStay OffsetTT]
                    #
                puts "         -> \$init_HB_Reach     $init_HB_Reach   "
                puts "         -> \$init_HB_Stack     $init_HB_Stack   "
                puts "         -> \$init_HT_Angle     $init_HT_Angle   "
                puts "         -> \$init_TT_Angle     $init_TT_Angle   "
                puts "         -> \$init_HT_Length    $init_HT_Length  "
                puts "         -> \$init_Stem_Length  $init_Stem_Length"
                puts "         -> \$init_Fork_Height  $init_Fork_Height"
                puts "         -> \$init_Fork_Rake    $init_Fork_Rake  "
                puts "         -> \$init_ST_Ext       $init_ST_Ext  "
                puts "         -> \$init_SS_Offset    $init_SS_Offset  "
                puts "         -> \$init_ST_Angle     $init_ST_Angle   "
                puts "         -> \$init_ST_Length    $init_ST_Length  "
                puts "         -> \$init_TT_Length    $init_TT_Length  "
                puts "         -> \$init_SD_Nose      $init_SD_Nose    "
                puts ""
                puts "        ------------------------------------------------"                                               
                puts ""
                    #
                    
                    # -- set demo
                set maxLoops          4
                set loopSteps         6
                set direction         1
                set step_Fork_Height  [expr  30.0  / $loopSteps]
                set step_Fork_Rake    [expr  20.0  / $loopSteps]
                set step_ST_Ext       [expr  25.0  / $loopSteps]
                set step_SS_Offset    [expr  25.0  / $loopSteps]
                set step_ST_Angle     [expr   3.0  / $loopSteps]
                set step_HT_Angle     [expr   4.0  / $loopSteps]    
                set step_HT_Length    [expr  30.0  / $loopSteps]
                set step_TT_Angle     [expr  15.0  / $loopSteps]
                    #
        }
            #
            #
        set maxLoops          4
        set loopSteps         6
            #
            #
        set targetTab    "cv_Custom00"
        set targetCanvas "rattleCAD::view::gui::$targetTab"
            #
        rattleCAD::view::gui::select_canvasCAD   $targetTab  
        rattleCAD::view::updateView        force
            #
        rattleCAD::view::gui::load_Template      Road
        rattleCAD::view::updateView        force
            #
            #
        set title       "rattleCAD - Method"
        createDemoText  $targetCanvas  "$title"
        after 1000
            #
            # -- Sceleton
            #
        method_rattleCAD___Saddle                   $targetCanvas $maxLoops $loopSteps
        method_rattleCAD___HandleBar                $targetCanvas $maxLoops $loopSteps
        method_rattleCAD___StemSteeringAngleFork    $targetCanvas $maxLoops $loopSteps
            #
            #
        after 1000
        set targetTab    "cv_Custom10"
        set targetCanvas "rattleCAD::view::gui::$targetTab"
            #
        rattleCAD::view::gui::select_canvasCAD   $targetTab  
        rattleCAD::view::updateView        force
            #
            # -- FrameTubes
            #
        method_rattleCAD___FrameTubes               $targetCanvas $maxLoops $loopSteps
            #
            #
        after 1000
        createDemoText $targetCanvas       {... thats it!}  
        after  500
        createDemoText $targetCanvas       {}  
        rattleCAD::view::updateView        force
            #
          
            #
        return  
            # 
       
    }

        # -- change Saddle-Position
        #
    proc method_rattleCAD___Saddle {targetCanvas maxLoops loopSteps} {
                #
            set direction         1
                #
            set title       "... Saddle"
            createDemoText  $targetCanvas  "$title"
            after 500
                #
            set stepCount      $loopSteps
                #
            set init_SD_Distance  [rattleCAD::model::get_Scalar     Geometry Saddle_Distance]   
            set init_SD_Height    [rattleCAD::model::get_Scalar     Geometry Saddle_Height]  
                #
            set demo_SD_Distance  $init_SD_Distance
            set demo_SD_Height    $init_SD_Height
                #
            set step_SD_Distance  [expr  25.0  / $loopSteps]
            set step_SD_Height    [expr  35.0  / $loopSteps]
                #
            puts "         -> \$init_SD_Distance  $init_SD_Distance / $step_SD_Distance"
            puts "         -> \$init_SD_Height    $init_SD_Height / $step_SD_Height"
                #
                # ----------------------------
                #
            set loopCount   0
            while {$loopCount < [expr $loopSteps * $maxLoops]} {            
                    # -- check \$runningStatus
                if   {![keepRunning]} {stopDemo cleanup; return}
                  #
                incr loopCount 
                if {$stepCount >= 2*$loopSteps} {
                    set stepCount 1
                    set direction [expr -1 * $direction]
                    after 50
                } else {
                    incr stepCount
                }
                    #
                set demo_SD_Distance [expr $demo_SD_Distance + $direction*$step_SD_Distance]
                set demo_SD_Height   [expr $demo_SD_Height   + $direction*$step_SD_Height  ]
                    #
                set myList {}
                lappend myList Scalar/Geometry/Saddle_Distance  $demo_SD_Distance  
                lappend myList Scalar/Geometry/Saddle_Height    $demo_SD_Height
                    #
                rattleCAD::control::setValue $myList           {update} skipHistory
                    #
            }
                #
    }
        # -- change HandleBar - Position
        #
    proc method_rattleCAD___HandleBar {targetCanvas maxLoops loopSteps} {
                #
            set direction   1
                #
            set title       "... HandleBar"
            createDemoText  $targetCanvas  "$title"
            after 500
                #
            set stepCount      $loopSteps
                #
            set init_HB_Reach       [rattleCAD::model::get_Scalar     Geometry HandleBar_Distance]
            set init_HB_Stack       [rattleCAD::model::get_Scalar     Geometry HandleBar_Height]  
            set init_Stem_Length    [rattleCAD::model::get_Scalar     Geometry Stem_Length]
                #
            set demo_HB_Reach       $init_HB_Reach   
            set demo_HB_Stack       $init_HB_Stack
            set demo_Stem_Length    $init_Stem_Length
                #
            set _headAngle          [rattleCAD::model::get_Scalar     Geometry HeadTube_Angle]
                #
            set step_HB_Reach       [expr  20.0  / $loopSteps]
            set step_HB_Stack       [expr  15.0  / $loopSteps]
                # 
            puts "         -> \$init_HB_Reach      $init_HB_Reach / $step_HB_Reach"
            puts "         -> \$init_HB_Stack      $init_HB_Stack / $step_HB_Stack"
            puts "         -> \$init_Stem_Length   $init_Stem_Length ..."
                #
                # ----------------------------
                #
            set loopCount   0
            while {$loopCount < [expr $loopSteps * $maxLoops]} {            
                    # -- check \$runningStatus
                if {![keepRunning]} {stopDemo cleanup; return}
                    #
                incr loopCount 
                if {$stepCount >= 2*$loopSteps} {
                    set stepCount 1
                    set direction [expr -1 * $direction]
                    after 50
                } else {
                    incr stepCount
                }
                    #
                set demo_HB_Stack     [expr $demo_HB_Stack    + $direction*$step_HB_Stack   ]
                set demo_HB_Reach     [expr $demo_HB_Reach    + $direction*$step_HB_Reach   ]
                    #               
                    # set step_Stem_Stack   [expr ($demo_HB_Stack - $init_HB_Stack) * cos([vectormath::rad $_headAngle])]
                    # set step_Stem_Reach   [expr ($demo_HB_Reach - $init_HB_Reach) / sin([vectormath::rad $_headAngle])]
                    #
                    # set demo_Stem_Length  [expr $init_Stem_Length + $step_Stem_Stack + $step_Stem_Reach]
                    #
                set myList {}
                lappend myList Scalar/Geometry/HandleBar_Height     $demo_HB_Stack
                lappend myList Scalar/Geometry/HandleBar_Distance   $demo_HB_Reach   
                    # lappend myList Scalar/Geometry/Stem_Length          $demo_Stem_Length
                    #
                rattleCAD::control::setValue $myList           {update} skipHistory
                    #
            }
                #
    }  
        # -- change Front Geometry
        #
    proc method_rattleCAD___StemSteeringAngleFork {targetCanvas maxLoops loopSteps} {
                #
            set direction   1
                #
            set title       "... Stem, SteeringAngle and Fork"       
            createDemoText  $targetCanvas  "$title"
            after 1000
                #

            set stepCount      $loopSteps
                #
            set init_HT_Angle       [rattleCAD::model::get_Scalar     Geometry HeadTube_Angle]    
            set init_Stem_Angle     [rattleCAD::model::get_Scalar     Geometry Stem_Angle]       
            set init_Stem_Length    [rattleCAD::model::get_Scalar     Geometry Stem_Length]       
            set init_Fork_Height    [rattleCAD::model::get_Scalar     Geometry Fork_Height]       
            set init_Fork_Rake      [rattleCAD::model::get_Scalar     Geometry Fork_Rake]         
                #
            set demo_HT_Angle       $init_HT_Angle
            set demo_Stem_Angle     $init_Stem_Angle
            set demo_Stem_Length    $init_Stem_Length
            set demo_Fork_Rake      $init_Fork_Rake  
            set demo_Fork_Height    $init_Fork_Height
                #
            set step_HT_Angle       [expr   3.0  / $loopSteps]    
            set step_Stem_Angle     [expr  12.0  / $loopSteps]    
            set step_Stem_Length    [expr  20.0  / $loopSteps]    
            set step_Fork_Height    [expr  12.0  / $loopSteps]
            set step_Fork_Rake      [expr  15.0  / $loopSteps]
                #
                # ----------------------------
                #
            puts "         -> \$init_HT_Angle     $init_HT_Angle / $step_HT_Angle   "
            puts "         -> \$init_Stem_Angle   $init_Stem_Angle / $step_Stem_Angle"
            puts "         -> \$init_Stem_Length  $init_Stem_Length / $step_Stem_Length"
                # ----------------------------
            set loopCount   0
            while {$loopCount < [expr $loopSteps * $maxLoops]} {            
                  # -- check \$runningStatus
                if {![keepRunning]} {stopDemo cleanup; return}
                  #
                incr loopCount 
                if {$stepCount >= 2*$loopSteps} {
                    set stepCount 1
                    set direction [expr -1 * $direction]
                    after 50
                } else {
                    incr stepCount
                }
                
                set demo_HT_Angle    [expr $demo_HT_Angle    + $direction*$step_HT_Angle]
                set demo_Stem_Angle  [expr $demo_Stem_Angle  - $direction*$step_Stem_Angle]
                set demo_Stem_Length [expr $demo_Stem_Length - $direction*$step_Stem_Length]
                  #
                set myList {}
                lappend myList Scalar/Geometry/HeadTube_Angle   $demo_HT_Angle
                lappend myList Scalar/Geometry/Stem_Angle       $demo_Stem_Angle
                lappend myList Scalar/Geometry/Stem_Length      $demo_Stem_Length
                    #                 
                rattleCAD::control::setValue $myList           {update} skipHistory
                    #
            }
                #
                # ----------------------------
                #
            puts "         -> \$init_Fork_Height  $init_Fork_Height / $step_Fork_Height"
            puts "         -> \$init_Fork_Rake    $init_Fork_Rake  / $step_Fork_Rake  "
                # ----------------------------
            set loopCount   0
            while {$loopCount < [expr $loopSteps * $maxLoops]} {            
                  # -- check \$runningStatus
                if {![keepRunning]} {stopDemo cleanup; return}
                  #
                incr loopCount 
                if {$stepCount >= 2*$loopSteps} {
                    set stepCount 1
                    set direction [expr -1 * $direction]
                    after 50
                } else {
                    incr stepCount
                }
                
                set demo_Fork_Rake   [expr $demo_Fork_Rake   - $direction*$step_Fork_Rake]
                set demo_Fork_Height [expr $demo_Fork_Height + $direction*$step_Fork_Height]
                  #
                set myList {}
                lappend myList Scalar/Geometry/Fork_Height      $demo_Fork_Height 
                lappend myList Scalar/Geometry/Fork_Rake        $demo_Fork_Rake
                    #                 
                rattleCAD::control::setValue $myList           {update} skipHistory
                    #
            }
                #
    }
        # -- change FrameTubes
        #
    proc method_rattleCAD___FrameTubes {targetCanvas maxLoops loopSteps} {
                #
            set direction   1
                #
            set title       "... FrameTubes"       
            createDemoText  $targetCanvas  "$title"
            after 1000
                #    
                #
            set stepCount      $loopSteps
                #
            set init_HT_Length      [rattleCAD::model::get_Scalar   HeadTube Length]            
            set init_TT_Offset      [rattleCAD::model::get_Scalar   TopTube  OffsetHT]     
            set init_DT_Offset      [rattleCAD::model::get_Scalar   DownTube OffsetHT]     
            set init_TT_Angle       [rattleCAD::model::get_Scalar   Geometry TopTube_Angle]     
            set init_ST_Ext         [rattleCAD::model::get_Scalar   SeatTube Extension]
            set init_SS_Offset      [rattleCAD::model::get_Scalar   SeatStay OffsetTT]
                #   
            set demo_TT_Offset      $init_TT_Offset
            set demo_DT_Offset      $init_DT_Offset
            set demo_HT_Length      $init_HT_Length
            set demo_TT_Angle       $init_TT_Angle
            set demo_ST_Ext         $init_ST_Ext
            set demo_SS_Offset      $init_SS_Offset
                #   
            set step_HT_Length      [expr  15.0  / $loopSteps]
            set step_ST_Ext         [expr  10.0  / $loopSteps]
            set step_SS_Offset      [expr  20.0  / $loopSteps]                    
            set step_TT_Angle       [expr   4.0  / $loopSteps]    
            set step_TT_Offset      [expr   6.0  / $loopSteps]    
            set step_DT_Offset      [expr   6.0  / $loopSteps]    
                #
                #
                # ----------------------------
                #
            puts "         -> \$init_HT_Length     $init_HT_Length / $step_HT_Length"
            puts "         -> \$init_TT_Offset     $init_TT_Offset / $step_TT_Offset"
            puts "         -> \$init_DT_Offset     $init_DT_Offset / $step_DT_Offset"
                # ----------------------------
            set loopCount   0
            while {$loopCount < [expr 2 * $loopSteps * $maxLoops]} {            
                  # -- check \$runningStatus
                if {![keepRunning]} {stopDemo cleanup; return}
                  #
                incr loopCount 
                if {$stepCount >= 2*$loopSteps} {
                    set stepCount 1
                    set direction [expr -1 * $direction]
                    after 50
                } else {
                    incr stepCount
                }
                    #
                set demo_HT_Length  [expr $demo_HT_Length - $direction*$step_HT_Length]
                set demo_TT_Offset  [expr $demo_TT_Offset - $direction*$step_TT_Offset]
                set demo_DT_Offset  [expr $demo_DT_Offset - $direction*$step_DT_Offset]
                    #
                set myList {}
                lappend myList Scalar/HeadTube/Length       $demo_HT_Length          
                lappend myList Scalar/TopTube/OffsetHT      $demo_TT_Offset          
                lappend myList Scalar/DownTube/OffsetHT     $demo_DT_Offset         
                    #
                rattleCAD::control::setValue $myList           {update} skipHistory
                    #
            }                     
                #
                #
                # ----------------------------
                #
            puts "         -> \$init_TT_Angle      $init_TT_Angle / $step_TT_Angle "
            puts "         -> \$init_ST_Ext        $init_ST_Ext / $step_ST_Ext   "
            puts "         -> \$init_SS_Offset     $init_SS_Offset / $step_SS_Offset"          
                # ----------------------------
            set loopCount   0
            while {$loopCount < [expr 2 * $loopSteps * $maxLoops]} {            
                    # -- check \$runningStatus
                if {![keepRunning]} {stopDemo cleanup; return}
                    #
                incr loopCount 
                if {$stepCount >= 2*$loopSteps} {
                    set stepCount 1
                    set direction [expr -1 * $direction]
                    after 50
                } else {
                    incr stepCount
                }
                    #
                set demo_TT_Angle   [expr $demo_TT_Angle  + $direction*$step_TT_Angle]
                set demo_ST_Ext     [expr $demo_ST_Ext    - $direction*$step_ST_Ext]
                set demo_SS_Offset  [expr $demo_SS_Offset - $direction*$step_SS_Offset]
                    #
                set myList {}
                lappend myList Scalar/Geometry/TopTube_Angle        $demo_TT_Angle      ;# Custom/TopTube/Angle            
                lappend myList Scalar/SeatTube/Extension            $demo_ST_Ext        ;# Custom/SeatTube/Extension       
                lappend myList Scalar/SeatStay/OffsetTT             $demo_SS_Offset     ;# Custom/SeatStay/OffsetTT        
                    #
                rattleCAD::control::setValue $myList           {update} skipHistory
                    #
            }
    }


    #-------------------------------------------------------------------------
        #  classic Seat- and TopTube method
        #     
    proc method_classic_SeatandTopTube {} {
    
        set currentFile   [rattleCAD::control::getSession  projectFile]
		set SAMPLE_Dir     $::APPL_Config(SAMPLE_Dir)
                       
        puts "\n\n  ======  T H E   C L AS S I C - M E T H O D:    U S I N G   C O N S T A N T   T O P - T U B E  ===========\n"                         
        puts "" 
        
            #
        set targetTab    "cv_Custom00"
        set targetCanvas "rattleCAD::view::gui::$targetTab"
            #
        rattleCAD::view::gui::select_canvasCAD   $targetTab  
        rattleCAD::view::updateView         force
            #
        rattleCAD::view::gui::load_Template Road
        rattleCAD::view::updateView         force
            #
          
            #
        set init_ST_Angle     [rattleCAD::model::get_Scalar     Geometry SeatTube_Angle]  
        set init_ST_Length    [rattleCAD::model::get_Scalar     Geometry SeatTube_Virtual]  
        set init_TT_Length    [rattleCAD::model::get_Scalar     Geometry TopTube_Virtual]   
        set init_SD_Nose      [rattleCAD::model::get_Scalar     Geometry SaddleNose_BB_x]   
            #

        puts ""
        puts "         -> \$init_ST_Angle     $init_ST_Angle   "
        puts "         -> \$init_ST_Length    $init_ST_Length  "
        puts "         -> \$init_TT_Length    $init_TT_Length  "
        puts "         -> \$init_SD_Nose      $init_SD_Nose    "
        puts ""
        puts "        ------------------------------------------------"                                               
        puts ""
            #
            
            # -- set demo
        set maxLoops          4
        set loopSteps         6
        set direction         1
        set step_ST_Angle     [expr 2.0 / $loopSteps]
            #
        
            # -- change Saddle- and HandleBarPosition
            #
        set title       "  ... the Classic-Method: "
        createDemoText  $targetCanvas  "$title"
        after 2000
        set title       "  ... keep constant Seat- and TopTube Length "
        createDemoText  $targetCanvas  "$title"
        
          
            #
        set loopCount      0
        set stepCount      $loopSteps
            #
        set demo_ST_Angle  $init_ST_Angle
            #
        while {$loopCount < [expr $loopSteps * $maxLoops]} {            
              # -- check \$runningStatus
            if {![keepRunning]} {stopDemo cleanup; return}
              #
            incr loopCount 
            if {$stepCount >= 2*$loopSteps} {
                set stepCount 1
                set direction [expr -1 * $direction]
                after 50
            } else {
                incr stepCount
            }
            
            set demo_ST_Angle [expr $demo_ST_Angle + $direction*$step_ST_Angle]
              #
            set myList {}
            lappend myList  Scalar/Geometry/SeatTube_Angle       $demo_ST_Angle 
            lappend myList  Scalar/Geometry/SeatTube_Virtual     $init_ST_Length
            lappend myList  Scalar/Geometry/TopTube_Virtual      $init_TT_Length
            lappend myList  Scalar/Geometry/SaddleNose_BB_x      $init_SD_Nose  
                #
            foreach {key value} $myList {
                puts "       ... \$keyValue: $key $value"
            }
                #
            rattleCAD::control::setValue $myList  {update}    {skipHistory}
                #
        }
            #
        createDemoText $targetCanvas       {}  
        rattleCAD::view::updateView        force    
            #
        return    
            #
    }


    #-------------------------------------------------------------------------
        #  loopSamples
        #     
    proc loopSamples {args} {
        set currentFile [rattleCAD::control::getSession  projectFile]
        set SAMPLE_Dir  $::APPL_Config(SAMPLE_Dir)

        puts "\n\n  ====== l o o p   S A M P L E   F i l e s ========\n"                         
        puts "      currentFile  ... $currentFile"
        puts "      SAMPLE_Dir  .... $SAMPLE_Dir"
        puts "" 

          # rattleCAD::model::file::saveProject_xml saveAs    
        
        set targetTab    "cv_Custom30"
        set targetCanvas "rattleCAD::view::gui::$targetTab"
          #
        rattleCAD::view::gui::select_canvasCAD   $targetTab  
        rattleCAD::view::updateView        force
          #
        createDemoText $targetCanvas       {... demo Samples}  
          #
        
          #
        foreach fileName [lsort [glob -directory [file normalize $SAMPLE_Dir] -type f *.xml]] {
              # -- check \$runningStatus
            if {![keepRunning]} {stopDemo cleanup; return}
              #
            puts "\n     open Sample File:"
            puts "          .... $fileName\n"
            rattleCAD::model::file::openProject_xml   $fileName
            after 1500
        }
          # -- open previous opened File   
        puts "\n      ... open previous opened file:"
        puts "\n            ... $currentFile"
        switch -exact $currentFile {
            {Template Road} {
                rattleCAD::view::gui::load_Template  Road
            }        
            {Template MTB} {
                rattleCAD::view::gui::load_Template  MTB
            }
            default {
                rattleCAD::model::file::openProject_xml   $currentFile    
            }
        }
        after 1500        
        createDemoText $targetCanvas       {... done}  
        after  500
        createDemoText $targetCanvas       {}  
        rattleCAD::view::updateView        force
            
          # tk_messageBox -title "loop Samples" -message "... $SAMPLE_Dir!"   
    }     


    #-------------------------------------------------------------------------
        #  demo 01
        #     
    proc demo_01 {args} {
        set currentFile [rattleCAD::control::getSession  projectFile]
        set SAMPLE_Dir     $::APPL_Config(SAMPLE_Dir)
                       
        puts "\n\n  ====== D E M O N S T R A T I O N   0 1 ===========\n"                         
        puts "      currentFile  ... $currentFile"
        puts "      SAMPLE_Dir  .... $SAMPLE_Dir"
        puts "" 
     
        
        set values [[namespace current]::demoValues 30 -3 5 2]  
        puts " ... \$values .. $values" 
        set values [[namespace current]::demoValues 30 5 -3 2]  
        puts " ... \$values .. $values" 
        
            # proc setValue {arrayName type args}
            # proc getValue {arrayName type args}
            
        # rattleCAD::view::gui::select_canvasCAD   cv_Custom00
        
        # -- update display -----------
        rattleCAD::view::gui::notebook_refitCanvas
        rattleCAD::cv_custom::updateView [rattleCAD::view::gui::current_canvasCAD]
        
        
        # -- morphing -----------------
        updateGeometryValue     Scalar/Geometry/Saddle_Distance            25  -35   5 \
                                Scalar/Geometry/HandleBar_Distance        -25   35   5 \
                                Scalar/Geometry/Saddle_Height             -35   25   5 \
                                Scalar/Geometry/HandleBar_Height          -35   25   5 
                                        
        updateGeometryValue     Scalar/Geometry/HandleBar_Distance        -10    8   3 \
                                Scalar/Geometry/HandleBar_Height           25  -15   2 

        updateGeometryValue     Scalar/Geometry/BottomBracket_Depth       -20   15   3 \
        
        updateGeometryValue     Scalar/Geometry/RearWheel_Position         25  -10   5 
        
        updateGeometryValue     Scalar/Geometry/HeadTube_Angle              -1   2    1 
        
    
        updateGeometryValue     Scalar/Geometry/RearWheel_Radius           45  -45   0 \
                                Scalar/Geometry/FrontWheel_Radius          45  -45   0 

        updateGeometryValue     Scalar/Geometry/BottomBracket_Depth       -30   25  10 \
                                Scalar/FrameTubes/HeadTube_Length         -30   25  10
                                        
        updateGeometryValue     Scalar/Geometry/TopTube_Angle               3   -4   1 
                                        

        return

    }   


    # -------------------------------------------------------------------------
        #  updateGeometryValue
        #    
    proc updateGeometryValue {args} {
        
        set _index 0
        array set myValues {}
        foreach {key left right end} $args {
              # -- check \$runningStatus
            if {![keepRunning]} {stopDemo cleanup; return}
                #                #
                # puts "   $key "    
                #
                # puts ""
            set currentValue  [lindex [array get rattleCAD::control::_currentValue $key] 1]   ;# 20141121 .. unchecked, 20141212 ... checked
                # puts "   \$currentValue $currentValue" 
                #
            set valueList [[namespace current]::demoValues $currentValue $left $right $end]
                #
            set myValues($_index) [appUtil::flatten_nestedList $key $valueList]
            incr _index
        }
        puts "   ..."
            # parray myValues
        set arraySize [array size myValues]
            # puts "    ... $arraySize"
         
         
        if {$arraySize > 0} {
            set listLength [llength $myValues(0)]
            puts "    ... $listLength"
        } else {
            return
        }
         
        set listIndex  1
        set arrayIndex 0
        while {$listIndex < $listLength} {
                #
            set paramValueList {}
            while {$arrayIndex < $arraySize} {
                set key       [lindex $myValues($arrayIndex) 0]
                set paramValue  [lindex $myValues($arrayIndex) $listIndex]
                puts "         ... $arrayIndex / $listIndex      -> $key : $paramValue"
                lappend paramValueList $key $paramValue 
                incr arrayIndex 
            }
            rattleCAD::control::setValue $paramValueList update skipHistory

            set  arrayIndex 0
            incr listIndex
        }
    }  


    # -------------------------------------------------------------------------
        #  deliver demo Values
        #
    proc demoValues {base left right end} {
        
        set precission 3
        set valueList  {}
        
        
        set currentValue    $base
        
        set step [expr 1.0*$left/$precission]
        set i 0
        while {$i < $precission} {
            set currentValue [expr $currentValue + $step]
            lappend valueList $currentValue
            incr i
        }
        set i 0
        while {$i < $precission} {
            set currentValue [expr $currentValue - $step]
            lappend valueList $currentValue
            incr i
        }
        
        
        set step [expr 1.0*$right/$precission]
        set i 0
        while {$i < $precission} {
            set currentValue [expr $currentValue + $step]
            lappend valueList $currentValue
            incr i
        }
        set i 0
        while {$i < $precission} {
            set currentValue [expr $currentValue - $step]
            lappend valueList $currentValue
            incr i
        }
        
        
        set step [expr 1.0*$end/$precission]
        set i 0
        while {$i < $precission} {
            set currentValue [expr $currentValue + $step]
            lappend valueList $currentValue
            incr i
        }       
        
        return $valueList
        
    }     

    proc createDemoText {cv_Name textText} {

            # puts ""
            # puts "   -------------------------------"
            # puts "    rattleCAD::test::createDemoText"
            # puts "       cv_Name:         $cv_Name"

            
                # --- get stageScale
            set stageCanvas [ $cv_Name    getNodeAttr  Canvas path   ]
            set canvasScale [ $cv_Name    getNodeAttr  Canvas scale  ]
            set stageFormat [ $cv_Name    getNodeAttr  Stage  format ]
            set stageWidth  [ $cv_Name    getNodeAttr  Stage  width  ]
            set stageHeight [ $cv_Name    getNodeAttr  Stage  height ]
            set stageScale  [ $cv_Name    getNodeAttr  Stage  scale  ]

            set scaleFactor        [ expr 1 / $stageScale ]
            if {[expr round($scaleFactor)] == $scaleFactor} {
                set formatScaleFactor        [ expr round($scaleFactor) ]
            } else {
                set formatScaleFactor        [ format "%.1f" $scaleFactor ]
            }

            proc scale_toStage    {ptList factor} {
                return [ vectormath::scalePointList {0 0} $ptList $factor ]
            }

                # --- outer border
            set df_Border           2
            set df_Width        [ expr $stageWidth  - 2 * $df_Border ]
            set tb_Width          170
            set tb_Height          20
            set tb_BottomLeft   [ expr $stageWidth  - $df_Border  - $tb_Width ]
            
                # --- create Text:
            set textSize            5
            set textHeight          [expr $textSize * $scaleFactor ]

            
                # --- remove existing text with tagID
                # set tagID            {___demoText___}
                # set withTagCondition [format "{__Comment__ && %s}"  $tagID]
            set removeItem [$cv_Name find withtag {__Comment__ && ___demoText___}]
                # puts "      -> $removeItem $removeItem"
            catch {$cv_Name delete $removeItem}
                #
                
                # --- return if only remove ___demoText___
            if {$textText == {}} {
                return
            }
                #
            
                # --- create Text: DIN Format
            set pos_x       [expr $df_Border + $df_Width - 2 ]
            set pos_y       [expr $df_Border + 0 ]          
                #
            set textPos     [scale_toStage [list $pos_x $pos_y]    $scaleFactor]
                # set textPos     [scale_toStage [list [expr $df_Border + $df_Width      -   2 ] [ expr $df_Border + 0 ] ]    $scaleFactor]
                # $cv_Name create circle    $textPos  -radius 50      -fill red -outline green
            set commentText [$cv_Name create text $textPos  -text $textText -size $textHeight -anchor se -tags {__Comment__}]
                # set commentText [$cv_Name create draftText $textPos  -text $textText -size $textSize -anchor se -tags {__Comment__}]
                #
            $stageCanvas addtag {___demoText___} withtag $commentText 
            $stageCanvas dtag   $commentText {__Content__}
                #
            update
                #
            return
                #            
              
              
                          # set commentText [$cv_Name create text $textPos  -text $textText -size $textHeight -anchor sw -tags {__Comment__}]
                        foreach _tag_ [$stageCanvas gettags $commentText] {
                            puts "   -> $_tag_"
                        } 
                        $stageCanvas addtag {___demoText___} withtag $commentText 
                        $stageCanvas dtag   $commentText {__Content__}
                        foreach _tag_ [$stageCanvas gettags $commentText] {
                            puts "   -> $_tag_"
                        } 
                           # exit
                        update
                        return
                        
                        
                        
                        set commentItem [ $stageCanvas find withtag {__Comment__}]
                        puts "\n\n  \$commentText $commentText $scaleFactor\n\n"
                        
                        foreach _tag_ [$stageCanvas gettags $commentItem] {
                            puts "   -> $_tag_"
                        } 
                        set _bbox_    [$stageCanvas bbox $commentItem]            
                            puts "   -> $_bbox_"
                            
                        $stageCanvas create rectangle $_bbox_ -outline red -width 5     

                        puts "\n\n  \$stageCanvas $stageCanvas \n\n"
                        puts "\n\n  \$commentItem $commentItem \n\n"
                        
                        # rattleCAD::view::updateView     force
                        
                        return
                        #exit

    }

                    # Result/Angle/HeadTube/TopTube              
                    
    proc testResultParameter {} {
            # tk_messageBox -message "testResultParameter"               
            set parameterList {                     
                    Scalar/Geometry/HeadLug_Angle_Top
                    Scalar/Geometry/SeatTube_Angle
                    Scalar/Geometry/BottomBracket_Height
                    Scalar/Geometry/FrontWheel_xy
                    Scalar/Geometry/FrontWheel_x
                    Scalar/Geometry/FrontWheel_Radius
                    Scalar/Geometry/Reach_Length
                    Scalar/Geometry/Stack_Height
                    Scalar/Geometry/SaddleNose_HB
                    Scalar/Geometry/RearWheel_x
                    Scalar/Geometry/RearWheel_Radius
                    Scalar/Geometry/SaddleNose_BB_x
                    Scalar/Geometry/Saddle_Offset_BB_ST
                    Scalar/Geometry/Saddle_HB_y
                    Scalar/Geometry/Saddle_BB
                    Scalar/Geometry/SeatTube_Virtual
                    Scalar/Geometry/TopTube_Virtual }
        
                    # Scalar/Reference/SaddleNose_HB_y
                    # Scalar/Reference/SaddleNose_HB
                    # Scalar/RearWheel/TyreShoulder
                    
                    # {Result/Angle/HeadTube/TopTube   }

            
            foreach resultKey $parameterList {
                # puts "    ... $resultKey"
                
                # puts "  ... $resultKey "
                set currentValue [lindex [array get rattleCAD::view::_updateValue $resultKey] 1]
                # puts "      ... $currentValue"
                # continue
                # _updateValue
                # set currentValue [rattleCAD::model::getValue Result/$resultKey value]
                puts "\n\n <I> -> testResultParameter \n <I>      ... $resultKey    ... $currentValue\n"
                    #
                set newValue [expr $currentValue - 2.6]
                puts " <I>      ... $resultKey    ... $newValue\n"
                rattleCAD::control::setValue [list $resultKey  $newValue]
                set newValue [expr $currentValue + 2.6]
                puts " <I>      ... $resultKey    ... $newValue\n"
                rattleCAD::control::setValue [list $resultKey  $newValue]
                    #
                puts " <I>      ... $resultKey    ... $currentValue\n"
                rattleCAD::control::setValue [list $resultKey  $currentValue]
                    #
                # tk_messageBox -message "was resultKey: $resultKey" 
            }
            
            puts "\n\n"
            puts "      #"
            puts "      # ---- testResultParameter ---- done ------"
            puts "      #"
            puts "\n\n"
    }
     

    #-------------------------------------------------------------------------
        #
        #  end  namespace eval rattleCAD_Test 
        #

 }
  
