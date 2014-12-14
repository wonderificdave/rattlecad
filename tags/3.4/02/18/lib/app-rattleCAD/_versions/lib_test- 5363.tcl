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
                    # [namespace current]::integrationTest_00 
                    set messageValue "... integrationTest special"
                }
            method_rattleCAD {
                    while {$runningStatus != {off}} {
                          # tk_messageBox -title "Demontsration" -message "... show rattleCAD Principle"
                        [namespace current]::method_rattleCAD
                        set messageValue "... rattleCAD Method!"
                          # tk_messageBox -title "Demontsration" -message "... rattleCAD Principle!"
                    }
                } 
            method_SeatandTopTube {
                    while {$runningStatus != {off}} {
                          # tk_messageBox -title "Demontsration" -message "... show rattleCAD Principle"
                        [namespace current]::method_SeatandTopTube
                        set messageValue "... Seat- and TopTube Method!"
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
    proc method_rattleCAD {} {
        set currentFile   [rattleCAD::control::getSession  projectFile]
		set SAMPLE_Dir     $::APPL_Config(SAMPLE_Dir)
                       
        puts "\n\n  ====== R A T T L E C A D    M E T H O D ===========\n"                         
        puts "" 
        
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
        set init_HB_Reach     [rattleCAD::model::get_Scalar     HandleBar Distance]
        set init_HB_Stack     [rattleCAD::model::get_Scalar     HandleBar Height] 
        set init_SD_Distance  [rattleCAD::model::get_Scalar     Saddle Distance] 
        set init_SD_Height    [rattleCAD::model::get_Scalar     Saddle Height] 
        set init_HT_Angle     [rattleCAD::model::get_Scalar     HeadTube Angle]
        set init_TT_Angle     [rattleCAD::model::get_Scalar     TopTube Angle]
        set init_HT_Length    [rattleCAD::model::get_Scalar     HeadTube Length]
        set init_Stem_Length  [rattleCAD::model::get_Scalar     Geometry Stem_Length]
        set init_Fork_Height  [rattleCAD::model::get_Scalar     Fork Height]
        set init_Fork_Rake    [rattleCAD::model::get_Scalar     Fork Rake]
        set init_ST_Ext       [rattleCAD::model::get_Scalar     SeatTube Extension]
        set init_SS_Offset    [rattleCAD::model::get_Scalar     SeatStay OffsetTT]
        set init_ST_Length    [rattleCAD::model::get_Scalar     Geometry SeatTubeVirtual]
        set init_TT_Length    [rattleCAD::model::get_Scalar     Geometry TopTubeVirtual]
        set init_SD_Nose      [rattleCAD::model::get_Scalar     Geometry SaddleNose_BB_X]
        set init_ST_Angle     [rattleCAD::model::get_Direction  SeatTube degree]
        set init_ST_Angle     [expr 180 - $init_ST_Angle]        
            #
        puts "         -> \$init_HB_Reach     $init_HB_Reach   "
        puts "         -> \$init_HB_Stack     $init_HB_Stack   "
        puts "         -> \$init_SD_Distance  $init_SD_Distance"
        puts "         -> \$init_SD_Height    $init_SD_Height  "
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
        set step_HB_Reach     6.0
        set step_HB_Stack     2.5
        set step_SD_Distance  5.0
        set step_SD_Height   -5.0
        set step_Stem_Length  2.5
        set step_Fork_Height  3.5
        set step_Fork_Rake    2.0
        set step_ST_Ext       2.0
        set step_SS_Offset    5.0
        set step_ST_Angle     0.35
        set step_HT_Angle     0.4        
        set step_HT_Length   -3.0    
        set step_TT_Angle     1.0
            #
        
            # -- change Saddle- and HandleBarPosition
            #
        set title       "configure Saddle position ..."
        createDemoText  $targetCanvas  "$title"
        after 1500
            #
        
            #
        set loopCount      0
        set stepCount      $loopSteps
            #
        set demo_SD_Distance  $init_SD_Distance
        set demo_SD_Height    $init_SD_Height  
            #
        while {$loopCount < [expr $loopSteps * $maxLoops]} {            
              # -- check \$runningStatus
            if {![keepRunning]} {stopDemo cleanup; return}
              #
            incr loopCount 
            if {$stepCount >= 2*$loopSteps} {
                set stepCount 1
                set direction [expr -1 * $direction]
                after 500
            } else {
                incr stepCount
            }
            
            set demo_SD_Distance [expr $demo_SD_Distance + $direction*$step_SD_Distance]
            set demo_SD_Height   [expr $demo_SD_Height   + $direction*$step_SD_Height  ]
                #
            set myList {}
            lappend myList Personal/Saddle_Distance        $demo_SD_Distance  
            lappend myList Personal/Saddle_Height          $demo_SD_Height
                #
            rattleCAD::control::setValue $myList           {update} noHistory
                # createDemoText  $targetCanvas                  "$title"
                # puts "    -> $stepCount -> $direction -> $demo_ST_Angle"
        }
            #
          
            # -- change Saddle- and HandleBarPosition
            #
        set title       "... and HandleBar ..."
        createDemoText  $targetCanvas  "$title"
        after 1000
            #
        
            #
        set loopCount      0
        set stepCount      $loopSteps
          #
        set demo_HB_Reach     $init_HB_Reach   
        set demo_HB_Stack     $init_HB_Stack
        set demo_Stem_Length  $init_Stem_Length
            #        
        while {$loopCount < [expr $loopSteps * $maxLoops]} {            
              # -- check \$runningStatus
            if {![keepRunning]} {stopDemo cleanup; return}
              #
            incr loopCount 
            if {$stepCount >= 2*$loopSteps} {
                set stepCount 1
                set direction [expr -1 * $direction]
                after 500
            } else {
                incr stepCount
            }
            
            set demo_HB_Stack    [expr $demo_HB_Stack    + $direction*$step_HB_Stack   ]
            set demo_HB_Reach    [expr $demo_HB_Reach    + $direction*$step_HB_Reach   ]
            set demo_Stem_Length [expr $demo_Stem_Length + $direction*$step_Stem_Length]
              #
            set myList {}
            lappend myList Personal/HandleBar_Distance     $demo_HB_Reach   
            lappend myList Personal/HandleBar_Height       $demo_HB_Stack
            lappend myList Component/Stem/Length           $demo_Stem_Length
              #
            rattleCAD::control::setValue $myList           {update} noHistory
              #
        }
            #
          
          
            # -- use HandleBarPosition
            #
        set title       "... configure front geometry ..."       
        createDemoText  $targetCanvas  "$title"
        after 1500
          #
                  
          #
        set loopCount      0
        set stepCount      $loopSteps
          #
        set demo_HT_Angle    $init_HT_Angle
        set demo_Stem_Length $init_Stem_Length
        set demo_Fork_Rake   $init_Fork_Rake  
          # set demo_Fork_Height $init_Fork_Height
          #
        while {$loopCount < [expr $loopSteps * $maxLoops]} {            
              # -- check \$runningStatus
            if {![keepRunning]} {stopDemo cleanup; return}
              #
            incr loopCount 
            if {$stepCount >= 2*$loopSteps} {
                set stepCount 1
                set direction [expr -1 * $direction]
                after 500
            } else {
                incr stepCount
            }
            
            set demo_HT_Angle    [expr $demo_HT_Angle    + $direction*$step_HT_Angle]
            set demo_Stem_Length [expr $demo_Stem_Length - $direction*$step_Stem_Length]
            set demo_Fork_Rake   [expr $demo_Fork_Rake   - $direction*$step_Fork_Rake]
              # set demo_Fork_Height [expr $demo_Fork_Height + $direction*$step_Fork_Height]
              #
            set myList {}
            lappend myList Custom/HeadTube/Angle           $demo_HT_Angle
            lappend myList Component/Stem/Length           $demo_Stem_Length
            lappend myList Component/Fork/Rake             $demo_Fork_Rake
              #
            rattleCAD::control::setValue $myList           {update} noHistory
              #
        }
            #

            #
        after 1000
        set targetTab    "cv_Custom10"
        set targetCanvas "rattleCAD::view::gui::$targetTab"
            #
        rattleCAD::view::gui::select_canvasCAD   $targetTab  
        rattleCAD::view::updateView        force
            #
 
            # 
        set title       "... and refine frame tubes, and angles, and ..."       
        createDemoText  $targetCanvas  "$title"
        after 1000
            #
                  
            #
        set loopCount      0
        set stepCount      $loopSteps
            #
        set demo_TT_Angle  $init_TT_Angle
        set demo_HT_Length $init_HT_Length
        set demo_ST_Ext    $init_ST_Ext
        set demo_SS_Offset $init_SS_Offset
            #
        while {$loopCount < [expr 2 * $loopSteps * $maxLoops]} {            
              # -- check \$runningStatus
            if {![keepRunning]} {stopDemo cleanup; return}
              #
            incr loopCount 
            if {$stepCount >= 2*$loopSteps} {
                set stepCount 1
                set direction [expr -1 * $direction]
                after 500
            } else {
                incr stepCount
            }
            
            set demo_TT_Angle  [expr $demo_TT_Angle  + $direction*$step_TT_Angle]
            set demo_HT_Length [expr $demo_HT_Length - $direction*$step_HT_Length]
            set demo_ST_Ext [expr $demo_ST_Ext - $direction*$step_ST_Ext]
            set demo_SS_Offset [expr $demo_SS_Offset - $direction*$step_SS_Offset]

              #
            set myList {}
            lappend myList Custom/TopTube/Angle            $demo_TT_Angle
            lappend myList FrameTubes/HeadTube/Length      $demo_HT_Length
            lappend myList Custom/SeatTube/Extension       $demo_ST_Ext
            lappend myList Custom/SeatStay/OffsetTT        $demo_SS_Offset
              #
            rattleCAD::control::setValue $myList           {update} noHistory
              #
        }
            #
          
            #
        set myList {}
        lappend myList Personal/HandleBar_Distance                   $init_HB_Reach     
        lappend myList Personal/HandleBar_Height                     $init_HB_Stack     
        lappend myList Personal/Saddle_Distance                      $init_SD_Distance  
        lappend myList Personal/Saddle_Height                        $init_SD_Height    
        lappend myList Custom/HeadTube/Angle                         $init_HT_Angle     
        lappend myList Custom/TopTube/Angle                          $init_TT_Angle     
        lappend myList FrameTubes/HeadTube/Length                    $init_HT_Length    
        lappend myList Component/Stem/Length                         $init_Stem_Length  
        lappend myList Component/Fork/Height                         $init_Fork_Height  
        lappend myList Component/Fork/Rake                           $init_Fork_Rake         
            #
        rattleCAD::control::setValue $myList           {update} noHistory
            #

          
            # -- remove demoText
        after 1000
        createDemoText $targetCanvas       {... clear?}  
        after 1000
        createDemoText $targetCanvas       {}  
        rattleCAD::view::updateView        force
            #
          
            #
        return  
            # 
          
    } 

    
    proc method_SeatandTopTube {} {
    
        set currentFile   [rattleCAD::control::getSession  projectFile]
		set SAMPLE_Dir     $::APPL_Config(SAMPLE_Dir)
                       
        puts "\n\n  ====== W H Y   N O T   T O P -  T U B E ===========\n"                         
        puts "" 
        
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
        set init_HB_Reach     [rattleCAD::model::get_Scalar     HandleBar Distance]
        set init_HB_Stack     [rattleCAD::model::get_Scalar     HandleBar Height] 
        set init_SD_Distance  [rattleCAD::model::get_Scalar     Saddle Distance] 
        set init_SD_Height    [rattleCAD::model::get_Scalar     Saddle Height] 
        set init_HT_Angle     [rattleCAD::model::get_Scalar     HeadTube Angle]
        set init_TT_Angle     [rattleCAD::model::get_Scalar     TopTube Angle]
        set init_HT_Length    [rattleCAD::model::get_Scalar     HeadTube Length]
        set init_Stem_Length  [rattleCAD::model::get_Scalar     Geometry Stem_Length]
        set init_Fork_Height  [rattleCAD::model::get_Scalar     Fork Height]
        set init_Fork_Rake    [rattleCAD::model::get_Scalar     Fork Rake]
        set init_ST_Length    [rattleCAD::model::get_Scalar     Geometry SeatTubeVirtual]
        set init_TT_Length    [rattleCAD::model::get_Scalar     Geometry TopTubeVirtual]
        set init_SD_Nose      [rattleCAD::model::get_Scalar     Geometry SaddleNose_BB_X]
        set init_ST_Angle     [rattleCAD::model::get_Direction  SeatTube degree]
        set init_ST_Angle     [expr 180 - $init_ST_Angle]
            #
        puts "         -> \$init_HB_Reach     $init_HB_Reach   "
        puts "         -> \$init_HB_Stack     $init_HB_Stack   "
        puts "         -> \$init_SD_Distance  $init_SD_Distance"
        puts "         -> \$init_SD_Height    $init_SD_Height  "
        puts "         -> \$init_HT_Angle     $init_HT_Angle   "
        puts "         -> \$init_TT_Angle     $init_TT_Angle   "
        puts "         -> \$init_HT_Length    $init_HT_Length  "
        puts "         -> \$init_Stem_Length  $init_Stem_Length"
        puts "         -> \$init_Fork_Height  $init_Fork_Height"
        puts "         -> \$init_Fork_Rake    $init_Fork_Rake  "
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
        set step_HB_Reach     6.0
        set step_HB_Stack     2.5
        set step_SD_Distance  5.0
        set step_SD_Height   -5.0
        set step_Stem_Length  2.5
        set step_Fork_Height  3.5
        set step_Fork_Rake    2.0
        set step_ST_Angle     0.35
        set step_HT_Angle     0.4        
        set step_HT_Length   -2.0    
        set step_TT_Angle     1.0
            #
        
            # -- change Saddle- and HandleBarPosition
            #
        set title       "  ... keep constant Seat- and TopTube Length "
        createDemoText  $targetCanvas  "$title"
        after 1000
        
          
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
                after 500
            } else {
                incr stepCount
            }
            
            set demo_ST_Angle [expr $demo_ST_Angle + $direction*$step_ST_Angle]
              #
            set myList {}
            lappend myList Result/Angle/SeatTube/Direction      $demo_ST_Angle
            lappend myList Result/Length/SeatTube/VirtualLength $init_ST_Length
            lappend myList Result/Length/TopTube/VirtualLength  $init_TT_Length
            lappend myList Result/Length/Saddle/Offset_BB_Nose  $init_SD_Nose
              #
            rattleCAD::control::setValue $myList           {update} noHistory
              #
        }
            #
          
            #
        set myList {}
        lappend myList Personal/HandleBar_Distance                   $init_HB_Reach     
        lappend myList Personal/HandleBar_Height                     $init_HB_Stack     
        lappend myList Personal/Saddle_Distance                      $init_SD_Distance  
        lappend myList Personal/Saddle_Height                        $init_SD_Height    
        lappend myList Custom/HeadTube/Angle                         $init_HT_Angle     
        lappend myList Custom/TopTube/Angle                          $init_TT_Angle     
        lappend myList FrameTubes/HeadTube/Length                    $init_HT_Length    
        lappend myList Component/Stem/Length                         $init_Stem_Length  
        lappend myList Component/Fork/Height                         $init_Fork_Height  
        lappend myList Component/Fork/Rake                           $init_Fork_Rake         
            #
        rattleCAD::control::setValue $myList           {update} noHistory
            #
          
            # -- remove demoText
        createDemoText $targetCanvas       {}  
        rattleCAD::view::updateView        force
            #
          
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
        updateGeometryValue     Personal(Saddle_Distance)            25  -35   5 \
                                Personal(HandleBar_Distance)        -25   35   5 \
                                Personal(Saddle_Height)             -35   25   5 \
                                Personal(HandleBar_Height)          -35   25   5 
                                        
        updateGeometryValue     Personal(HandleBar_Distance)        -10    8   3 \
                                Personal(HandleBar_Height)           25  -15   2 

        updateGeometryValue     Custom(BottomBracket/Depth          -20   15   3 \
        
        updateGeometryValue     Custom(WheelPosition/Rear)           25  -10   5 
        
        updateGeometryValue     Custom(HeadTube/Angle)               -1   2    1 
        
    
        updateGeometryValue     Component(Wheel/Rear/RimDiameter)    45  -45   0 \
                                Component(Wheel/Front/RimDiameter)   45  -45   0 

        updateGeometryValue     Custom(BottomBracket/Depth          -30   25  10 \
                                FrameTubes(HeadTube/Length)         -30   25  10
                                        
        updateGeometryValue     Custom(TopTube/Angle)                 3   -4   1 
                                        

        return

    }   


    # -------------------------------------------------------------------------
        #  updateGeometryValue
        #    
    proc updateGeometryValue {args} {
        
        set _index 0
        array set myValues {}
        foreach {arrayName left right end} $args {
              # -- check \$runningStatus
            if {![keepRunning]} {stopDemo cleanup; return}
                #
            set _array    [lindex [split $arrayName (]  0]
            set _name     [lindex [split $arrayName ()] 1]
            set xPath     [format "%s/%s" $_array $_name]
                #
            set currentValue  [lindex [array get rattleCAD::view::_updateValue $xPath] 1]   ;# 20141121 .. unchecked
                # set currentValue  [rattleCAD::view::_updateValue($xPath)]    ;# 20141121 .. unchecked
                # set currentValue  [rattleCAD::model::getValue  $xPath value]
            
                # puts "   -> $currentValue"
                # return
            set valueList [[namespace current]::demoValues $currentValue $left $right $end]
                #
            set myValues($_index) [appUtil::flatten_nestedList $xPath $valueList]
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
            set paramValueList {}
            while {$arrayIndex < $arraySize} {
                set xPath       [lindex $myValues($arrayIndex) 0]
                set paramValue  [lindex $myValues($arrayIndex) $listIndex]
                puts "         ... $arrayIndex / $listIndex      -> $xPath : $paramValue"
                lappend paramValueList $xPath $paramValue
                incr arrayIndex 
            }
            rattleCAD::control::setValue $paramValueList

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
            set df_Border           5
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
            set textPos     [scale_toStage [list [expr $df_Border + $df_Width      -   2 ] [ expr $df_Border + 0 ] ]    $scaleFactor]
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
                    Result/Angle/SeatTube/Direction            
                    Result/Length/BottomBracket/Height         
                    Result/Length/FrontWheel/Radius            
                    Result/Length/FrontWheel/diagonal          
                    Result/Length/FrontWheel/horizontal        
                    Result/Length/HeadTube/ReachLength         
                    Result/Length/HeadTube/StackHeight         
                    Result/Length/Personal/SaddleNose_HB       
                    Result/Length/RearWheel/Radius             
                    Result/Length/RearWheel/TyreShoulder       
                    Result/Length/RearWheel/horizontal         
                    Result/Length/Reference/Heigth_SN_HB       
                    Result/Length/Reference/SaddleNose_HB      
                    Result/Length/Saddle/Offset_BB_Nose        
                    Result/Length/Saddle/Offset_BB_ST          
                    Result/Length/Saddle/Offset_HB             
                    Result/Length/Saddle/SeatTube_BB           
                    Result/Length/SeatTube/VirtualLength       
                    Result/Length/TopTube/VirtualLength }
                 # {Result/Angle/HeadTube/TopTube   }
                    
            # set parameterList Length/Saddle/Offset_BB_ST
            # set parameterList Length/Saddle/SeatTube_BB
            # parray rattleCAD::view::colorSet
            # rattleCAD::view::init_configValues
            # parray rattleCAD::view::_updateValue
            # exit    
            # return
            
            
            
            
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
  
