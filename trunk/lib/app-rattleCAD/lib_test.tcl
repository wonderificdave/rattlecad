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
 
   
    proc controlDemo {{testProcedure {}}} {
        if {$testProcedure == {}} {
            set testProcedure   integrationTest_00     
        }  
        set timeStart    [clock milliseconds]
        
        switch -exact $testProcedure {
        integrationTest_00    {
               # tk_messageBox -title "integration Test" -message "... start integrationTest 00"
           [namespace current]::integrationTest_00 
           set messageValue "... integrationTest 00"
               # tk_messageBox -title "integration Test" -message "... integrationTest 00\n      ... done!"
        }
        loopSamples {
               # tk_messageBox -title "loop Samples" -message "... start loopSamples"
           [namespace current]::loopSamples
           set messageValue "... start loopSamples"        
               # tk_messageBox -title "loop Samples" -message "... rattleCAD Samples!"
        }    
        demo_01 {
             # tk_messageBox -title "Demontsration" -message "... show rattleCAD Principle"
           [namespace current]::demo_01
           set messageValue "... rattleCAD Principle!"
               # tk_messageBox -title "Demontsration" -message "... rattleCAD Principle!"
        }    
        StackandReach {
             # tk_messageBox -title "Demontsration" -message "... show rattleCAD Principle"
           [namespace current]::stack_and_reach
           set messageValue "... rattleCAD Stack & Reach!"
               # tk_messageBox -title "Demontsration" -message "... rattleCAD Principle!"
        }    
        default {}       
        }
        
        set timeEnd     [clock milliseconds]
        set timeUsed    [expr 0.001*($timeEnd - $timeStart)]
        tk_messageBox -title "Demontsration" -message "$messageValue\n       elapsed: $timeUsed seconds"      
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
		rattleCAD::gui::notebook_refitCanvas	
  
		
		# -- integration test ---------
		set openFile         [file join  ${SAMPLE_Dir} __test_Integration_02.xml]
		puts "          ... $openFile\n"
		rattleCAD::file::openProject_xml   $openFile
		
		set openFile         [file join  ${SAMPLE_Dir} classic_1984_SuperRecord.xml]
		puts "          ... $openFile\n"
		rattleCAD::file::openProject_xml   $openFile
		
		
		puts "\n\n === export  pdf / html  ===\n"
		rattleCAD::gui::export_Project      pdf
		wm deiconify .
		update
		rattleCAD::gui::export_Project      html
		wm deiconify .        
		update
		
		
		puts "\n\n === export  svg / dxf /ps  ===\n"
		rattleCAD::gui::notebook_exportSVG  $::APPL_Config(EXPORT_Dir) no
		rattleCAD::gui::notebook_exportDXF  $::APPL_Config(EXPORT_Dir) no
		rattleCAD::gui::notebook_exportPS   $::APPL_Config(EXPORT_Dir) no
		wm deiconify .
		update
		
		
		puts "\n\n === open file  ===\n"
		puts "   -> ${SAMPLE_Dir}: ${SAMPLE_Dir}\n"
		if {[catch {glob -directory ${SAMPLE_Dir} *.xml} errMsg]} {
			foreach sampleFile [lsort [glob -directory ${SAMPLE_Dir} *.xml]] {
			   set openFile     [file join  ${SAMPLE_Dir} $thisFile]
			   puts "          ... integrationTest_00 opened"
			   puts "                 ... $openFile\n"
			   rattleCAD::file::openProject_xml   $openFile 
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
		rattleCAD::file::openProject_xml   $openFile   
		
				
		puts "\n\n === create Information  ===\n"      
		rattleCAD::version_info::create  .v_info 0
		
		puts "\n\n === create Help  ===\n"
		rattleCAD::version_info::create  .v_info 1
		
		puts "\n\n === create Environment  ===\n"
		rattleCAD::version_info::create  .v_info 2
		
		puts "\n\n === create_intro  ===\n"        
		create_intro .intro
		after  100 destroy .intro
	   
		
		puts "\n\n === open Config gPanel ===\n"        
		puts "    ... $cfgPanel"
		
		
		puts "\n\n === load template road again  ===\n"  
		puts "          ... Template  Road\n"
        rattleCAD::gui::load_Template  Road	

        
		puts "\n\n === demonstrate stack and reach  ===\n"  
		 # stack_and_reach
		

		puts "\n\n === load template road again  ===\n"  
		puts "          ... Template  Road\n"
        rattleCAD::gui::load_Template  Road	
   
		
		puts "\n\n === end ===\n"       
		puts "   -> TEST_Dir: $TEST_Dir\n"   
   }   



    proc stack_and_reach {} {
    
        set currentFile [rattleCAD::control::getSession  projectFile]
		  # set currentFile $::APPL_Config(PROJECT_File)
        set SAMPLE_Dir     $::APPL_Config(SAMPLE_Dir)
                       
        puts "\n\n  ====== S T A C K   A N D   R E A C H ===========\n"                         
        puts "      currentFile  ... $currentFile"
        puts "      SAMPLE_Dir  .... $SAMPLE_Dir"
        puts "" 
     
        set init_HB_Stack     [rattleCAD::control::getValue  Personal/HandleBar_Height]
        set init_HB_Reach     [rattleCAD::control::getValue  Personal/HandleBar_Distance]
        set init_SD_Height    [rattleCAD::control::getValue  Personal/Saddle_Height]
        set init_SD_Distance  [rattleCAD::control::getValue  Personal/Saddle_Distance]
        set init_TT_Angle     [rattleCAD::control::getValue  Custom/TopTube/Angle]
        set init_ST_Angle     [rattleCAD::control::getValue  Result/Angle/SeatTube/Direction]
        set init_TT_Length    [rattleCAD::control::getValue  Result/Length/TopTube/VirtualLength]
        set init_SD_Nose      [rattleCAD::control::getValue  Result/Length/Saddle/Offset_BB_Nose]

        puts "         -> \$init_HB_Stack     $init_HB_Stack"
        puts "         -> \$init_HB_Reach     $init_HB_Reach"
        puts "         -> \$init_SD_Height    $init_SD_Height"
        puts "         -> \$init_SD_Distance  $init_SD_Distance"
        puts "         -> \$init_ST_Angle     $init_ST_Angle"
        puts "         -> \$init_SD_Nose      $init_SD_Nose"
        puts "         -> \$init_TT_Angle     $init_TT_Angle"
        puts "         -> \$init_TT_Length    $init_TT_Length"
        puts ""
        puts "        ------------------------------------------------"                                               
        puts ""
        
        set targetTab    "cv_Custom10"
        set targetCanvas "rattleCAD::gui::$targetTab"
        set message_1    "... demonstrate behaviour of Stack and Reach vs. Seat and TopTube Length"
          #
        rattleCAD::gui::select_canvasCAD   $targetTab  
          #
              
              #
            # createDemoText  $targetCanvas  $message_1
            # rattleCAD::view::updateView force
            # update        
            # rattleCAD::view::updateView force
            # return
              #
            # tk_messageBox -title "Demonstration"  -message $message_1 
              #
          
          # -- run demo
        set direction   counterclock
        set rangeValue  4.0
        set maxLoops    4
        set increment   0.4
        set maxBoundary [expr $init_ST_Angle + 0.5*$rangeValue]
        set minBoundary [expr $init_ST_Angle - 0.5*$rangeValue]
        
        
          # -- change SeatTubeAngle and keep TopTube-Length and SaddlePosition
          #
        set title      "keep Seat- & TopTube Length"
          #
        set    message " --- keep: ----------------------------------\n" 
        append message "          SeatTube-Length\n"
        append message "          TopTube-Length\n" 
        append message "          Saddle-Position (SaddleNose)\n"
        append message "\n" 
        append message " --- modify: --------------------------------\n" 
        append message "       -> SeatTube-Angle\n" 
          #
        # tk_messageBox -title $title  -message $message 
          #
        set loopCount      0
        set demo_ST_Angle  $init_ST_Angle
        while {$loopCount <= $maxLoops} {
              # puts "     -> run loop $loopCount <- $demo_ST_Angle"            
            if {$minBoundary > $demo_ST_Angle} {
                  # -- run out of boundary
                  # puts "     -> out of minBoundary: $minBoundary"
                set increment [expr -1.0 * $increment]
                incr loopCount
            } elseif {$demo_ST_Angle > $maxBoundary} {
                  # -- run out of boundary
                  # puts "     -> out of maxBoundary: $maxBoundary"
                set increment [expr -1.0 * $increment]
                incr loopCount
            }  else {
                  # puts "       -> increment: $minBoundary < $demo_ST_Angle < $maxBoundary > "  
                set myList {}
                lappend myList Result/Angle/SeatTube/Direction     $demo_ST_Angle
                lappend myList Result/Length/TopTube/VirtualLength $init_TT_Length
                lappend myList Result/Length/Saddle/Offset_BB_Nose $init_SD_Nose
                rattleCAD::control::setValue $myList {update} noHistory
                createDemoText  $targetCanvas  " ... $title"
            }
            set demo_ST_Angle [expr $demo_ST_Angle + $increment]

        }
        
          # -- reset SeatTube-Angle
        set myList {}
        lappend myList Personal/HandleBar_Height           $init_HB_Stack
        lappend myList Personal/HandleBar_Distance         $init_HB_Reach
        lappend myList Result/Angle/SeatTube/Direction     $init_ST_Angle
        lappend myList Result/Length/Saddle/Offset_BB_Nose $init_SD_Nose
        rattleCAD::control::setValue $myList  {update} noHistory
          #
        
          # -- change SeatTubeAngle and keep Stack & Reach and SaddlePosition
          #
        set title      "keep Stack and Reach"
          #
        set    message " --- keep: ----------------------------------\n" 
        append message "          Stack\n"
        append message "          Reach\n" 
        append message "          Saddle-Position (SaddleNose)\n"
        append message "\n" 
        append message " --- modify: --------------------------------\n" 
        append message "       -> SeatTube-Angle\n" 
          #
        # tk_messageBox -title $title  -message $message 
          #
        set loopCount      0
        set demo_ST_Angle  $init_ST_Angle
        while {$loopCount <= $maxLoops} {
              # puts "     -> run loop $loopCount <- $demo_ST_Angle"                        
            if {$minBoundary > $demo_ST_Angle} {
                  # -- run out of boundary
                  # puts "     -> out of minBoundary: $minBoundary"
                set increment [expr -1.0 * $increment]
                incr loopCount
            } elseif {$demo_ST_Angle > $maxBoundary} {
                  # -- run out of boundary
                  # puts "     -> out of maxBoundary: $maxBoundary"
                set increment [expr -1.0 * $increment]
                incr loopCount
            }  else {
                  # puts "       -> increment: $minBoundary < $demo_ST_Angle < $maxBoundary > "  
                set myList {}
                lappend myList Result/Angle/SeatTube/Direction     $demo_ST_Angle
                # lappend myList Result/Length/TopTube/VirtualLength $init_TT_Length
                lappend myList Result/Length/Saddle/Offset_BB_Nose $init_SD_Nose
                rattleCAD::control::setValue $myList {update} noHistory
                createDemoText  $targetCanvas  " ... $title"
            }
            set demo_ST_Angle [expr $demo_ST_Angle + $increment]

        }
        
          # -- reset SeatTube-Angle
        set myList {}
        lappend myList Result/Angle/SeatTube/Direction     $init_ST_Angle
        lappend myList Result/Length/Saddle/Offset_BB_Nose $init_SD_Nose
        rattleCAD::control::setValue $myList  {update} noHistory
          #
          
          # -- change TopTubeAngle and keep Stack & Reach and SaddlePosition
          #
        set title      "modify TopTube Angle"
          #
        set    message " --- keep: ----------------------------------\n" 
        append message "          Stack\n"
        append message "          Reach\n" 
        append message "          SeatTube-Angle\n"
        append message "          Saddle-Position (SaddleNose)\n"
        append message "\n" 
        append message " --- modify: --------------------------------\n" 
        append message "       -> TopTube-Angle\n" 
          #
        # tk_messageBox -title $title  -message $message 
          #
        set loopCount      0
        set demo_ST_Angle  $init_ST_Angle
        set demo_TT_Angle  $init_TT_Angle
        while {$loopCount <= $maxLoops} {
              # puts "     -> run loop $loopCount <- $demo_ST_Angle"                        
            if {$minBoundary > $demo_ST_Angle} {
                  # -- run out of boundary
                  # puts "     -> out of minBoundary: $minBoundary"
                set increment [expr -1.0 * $increment]
                incr loopCount
            } elseif {$demo_ST_Angle > $maxBoundary} {
                  # -- run out of boundary
                  # puts "     -> out of maxBoundary: $maxBoundary"
                set increment [expr -1.0 * $increment]
                incr loopCount
            }  else {
                  # puts "       -> increment: $minBoundary < $demo_ST_Angle < $maxBoundary > "  
                set myList {}
                # lappend myList Result/Angle/SeatTube/Direction     $demo_ST_Angle
                lappend myList Custom/TopTube/Angle                $demo_TT_Angle
                # lappend myList Result/Length/Saddle/Offset_BB_Nose $init_SD_Nose
                rattleCAD::control::setValue $myList {update} noHistory
                createDemoText  $targetCanvas  " ... $title"
            }
            set demo_ST_Angle [expr $demo_ST_Angle + 0.8 * $increment]
            set demo_TT_Angle [expr $demo_TT_Angle + 2.0 * $increment]
        }
        
          # -- reset SeatTube-Angle
          # rattleCAD::control::setValue [list Result/Angle/SeatTube/Direction     $init_ST_Angle]
        set myList {}
        lappend myList Result/Angle/SeatTube/Direction     $init_ST_Angle
        lappend myList Result/Length/Saddle/Offset_BB_Nose $init_SD_Nose
        lappend myList Custom/TopTube/Angle                $init_TT_Angle
          # puts "$myList"
          # return
          # puts "    -> TopTube - Angle:  $init_TT_Angle - $demo_TT_Angle"
        rattleCAD::control::setValue $myList  {update} noHistory
          #
    }


    #-------------------------------------------------------------------------
        #  loopSamples
        #     
    proc loopSamples {args} {
        set currentFile [rattleCAD::control::getSession  projectFile]
          # set currentFile $::APPL_Config(PROJECT_File)
        set SAMPLE_Dir  $::APPL_Config(SAMPLE_Dir)

        puts "\n\n  ====== l o o p   S A M P L E   F i l e s ========\n"                         
        puts "      currentFile  ... $currentFile"
        puts "      SAMPLE_Dir  .... $SAMPLE_Dir"
        puts "" 

        # rattleCAD::file::saveProject_xml saveAs    
        
        # -- update display -----------
        rattleCAD::gui::notebook_refitCanvas
        
        foreach fileName [lsort [glob -directory [file normalize $SAMPLE_Dir] -type f *.xml]] {
            puts "\n     open Sample File:"
        puts "          .... $fileName\n"
            rattleCAD::file::openProject_xml   $fileName
        after 100
        }
          # -- open previous opened File   
        puts "\n      ... open previous opened file:"
        puts "\n            ... $currentFile"
        switch -exact $currentFile {
            {Template Road} {
                rattleCAD::gui::load_Template  Road
            }        
            {Template MTB} {
                rattleCAD::gui::load_Template  MTB
            }
            default {
                rattleCAD::file::openProject_xml   $currentFile    
            }
        }    
    
          # tk_messageBox -title "loop Samples" -message "... $SAMPLE_Dir!"   
    }     
     
     
    #-------------------------------------------------------------------------
        #  demo 01
        #     
    proc demo_01 {args} {
        set currentFile [rattleCAD::control::getSession  projectFile]
		  # set currentFile $::APPL_Config(PROJECT_File)
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
            
        # rattleCAD::gui::select_canvasCAD   cv_Custom00
        
        # -- update display -----------
        rattleCAD::gui::notebook_refitCanvas
        rattleCAD::cv_custom::updateView [rattleCAD::gui::current_canvasCAD]
        
        
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
              set _array    [lindex [split $arrayName (]  0]
              set _name     [lindex [split $arrayName ()] 1]
              set xPath     [format "%s/%s" $_array $_name]
               
              set currentValue  [rattleCAD::control::getValue  $xPath value]
                # set currentValue  [project::getValue $arrayName value]
                # puts "   -> $currentValue"
                # return
              set valueList [[namespace current]::demoValues $currentValue $left $right $end]
               
              set myValues($_index) [appUtil::flatten_nestedList $xPath $valueList]
              incr _index
          }
          puts "   ..."
          parray myValues
          set arraySize [array size myValues]
          puts "    ... $arraySize"
           
           
          if {$arraySize > 0} {
              set listLength [llength $myValues(0)]
              puts "    ... $listLength"
          } else {
              return
          }
           
           set listIndex  1
           set arrayIndex 0
           while {$listIndex < $listLength} {
               while {$arrayIndex < $arraySize} {
                   set xPath       [lindex $myValues($arrayIndex) 0]
                   set paramValue  [lindex $myValues($arrayIndex) $listIndex]
                   puts "         ... $arrayIndex / $listIndex      -> $xPath : $paramValue"
                       # rattleCAD::view::set_Value $xPath $paramValue
                   rattleCAD::control::setValue [list $xPath $paramValue]
                   # bikeGeometry::set_Value $xPath $paramValue
                   incr arrayIndex 
               }
               rattleCAD::cv_custom::updateView [rattleCAD::gui::current_canvasCAD] keep
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
            set stageFormat [ $cv_Name    getNodeAttr Stage format]
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
            set textHeight            [expr $textSize * $scaleFactor ]

                # --- create Text: DIN Format
            set textPos                [scale_toStage [list [expr $df_Border + $df_Width      -   2 ] [ expr $df_Border +  3.0 ] ]    $scaleFactor]
                # $cv_Name create circle    $textPos  -radius 50 -fill red -outline green
            $cv_Name create draftText $textPos  -text $textText -size $textSize -anchor se
            return

     }



    #-------------------------------------------------------------------------
        #
        #  end  namespace eval rattleCAD_Test 
        #

 }
  
