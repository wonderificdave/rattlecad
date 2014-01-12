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
          
       set TEST_Dir $::APPL_Config(TEST_Dir) 
       puts "\n\n ====== integrationComplete ================ \n\n"
       puts "   -> TEST_Dir: $TEST_Dir\n"  
       

       # -- keep on top --------------
       wm deiconify .
       
       # -- update display -----------
       rattleCAD::gui::notebook_refitCanvas
       
       # -- integration test ---------
       set openFile         [file join  $TEST_Dir sample __test_Integration_02.xml]
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
       puts "   -> TEST_Dir: $TEST_Dir\n"
       foreach thisFile { 
              focus_cayo_expert_2010__L_56.xml focus_cayo_expert_2010__M_54.xml  focus_cayo_expert_2010__XL_58.xml \
              columbus_max.xml \
              _template_3.2.78.xml _template_3.2.78_offroad.xml _template_3.3.00.xml _template_3.3.02.xml \
              _template_3.3.03.xml _template_3.3.04.xml _template_3.3.05.35.xml _template_3.3.06.xml \
              Kid20_V7.xml  ghost_powerkid_20.xml \
              __test_Integration_02.xml   
       } {       
           set openFile     [file join  $TEST_Dir sample $thisFile]
           puts "          ... integrationTest_00 opened"
           puts "                 ... $openFile\n"
           rattleCAD::file::openProject_xml   $openFile 
           wm deiconify .
           #update          
       }
       
              
       puts "\n\n === open config Panel  ===\n"           
       set cfgPanel [rattleCAD::configPanel::create]
       puts "    ... $cfgPanel"
       
       
       puts "\n\n === open not existing file  ===\n"  
       set openFile     [file join  $TEST_Dir sample _ghost_powerkid_20.xml]
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
       
       puts "\n\n === end ===\n"       
       puts "   -> TEST_Dir: $TEST_Dir\n"   
   }   


    #-------------------------------------------------------------------------
        #  loopSamples
        #     
    proc loopSamples {args} {
        set currentFile $::APPL_Config(PROJECT_File)
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
        set currentFile $::APPL_Config(PROJECT_File)
        set SAMPLE_Dir     $::APPL_Config(SAMPLE_Dir)
                       
        puts "\n\n  ====== D E M O N ST R A T I O N   0 1 ===========\n"                         
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
               
              set currentValue  [rattleCAD::control::getValue  $arrayName value]
                # set currentValue  [project::getValue $arrayName value]
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
                   rattleCAD::control::setValue $xPath $paramValue
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
     


    #-------------------------------------------------------------------------
        #
        #  end  namespace eval rattleCAD_Test 
        #

 }
  
