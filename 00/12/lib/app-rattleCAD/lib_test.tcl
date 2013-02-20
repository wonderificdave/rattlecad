 ##+##########################################################################
 #
 # package: rattleCAD   ->  lib_version_info.tcl
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
 #  namespace:  rattleCAD::version_info
 # ---------------------------------------------------------------------------
 #
 # 
 namespace eval rattleCAD_Test {
 
   
    proc controlDemo {{testProcedure {}}} {
        if {$testProcedure == {}} {
	   set testProcedure   integrationTest_00     
        }  
        switch -exact $testProcedure {
	    integrationTest_00    {
		     # tk_messageBox -title "integration Test" -message "... start integrationTest 00"
		   [namespace current]::integrationTest_00 
		   tk_messageBox -title "integration Test" -message "... integrationTest 00\n      ... done!"
	    }
	    loopSamples {
		     # tk_messageBox -title "loop Samples" -message "... start loopSamples"
		   [namespace current]::loopSamples
		   tk_messageBox -title "loop Samples" -message "... rattleCAD Samples!"
	    }    
	    demo_01 {
		   tk_messageBox -title "Demontsration" -message "... show rattleCAD Principle"
		   [namespace current]::demo_01
		   tk_messageBox -title "Demontsration" -message "... rattleCAD Principle!"
	    }    
	    default {}       
        }	   
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
       
	   # -- integration test -------------
       set openFile 		[file join  $TEST_Dir sample Kid20_V7.xml]
       puts "          ... $openFile\n"
       lib_file::openProject_xml   $openFile
       
       
       puts "\n\n === export  pdf / html  ===\n"
       lib_gui::export_Project      pdf
       wm deiconify .
       update
       lib_gui::export_Project      html
       wm deiconify .        
       update
	   
	   
       puts "\n\n === export  svg / dxf /ps  ===\n"
       lib_gui::notebook_exportSVG  $::APPL_Config(EXPORT_Dir) no
       lib_gui::notebook_exportDXF  $::APPL_Config(EXPORT_Dir) no
       lib_gui::notebook_exportPS   $::APPL_Config(EXPORT_Dir) no
       wm deiconify .
       update
	   
       
       puts "\n\n === open file  ===\n"
       puts "   -> TEST_Dir: $TEST_Dir\n"
       foreach thisFile { 
                      focus_cayo_expert_2010__L_56.xml focus_cayo_expert_2010__M_54.xml  focus_cayo_expert_2010__XL_58.xml \
		      columbus_max.xml \
		      _template_3.2.78.xml _template_3.2.78_offroad.xml _template_3.3.00.xml _template_3.3.02.xml \
		      _template_3.3.03.xml _template_3.3.04.xml _template_3.3.05.35.xml _template_3.3.06.xml 
		      Kid20_V7.xml  ghost_powerkid_20.xml _ghost_powerkid_20.xml   
       } {	   
	   set openFile 	[file join  $TEST_Dir sample $thisFile]
	   puts "          ... $openFile\n"
	   lib_file::openProject_xml   $openFile		   
       }
	   
		      
       puts "\n\n === open config Panel  ===\n"		   
       set cfgPanel [lib_gui::open_configPanel]
       puts "    ... $cfgPanel"
       
	   
       puts "\n\n === open not existing file  ===\n"  
       set openFile 	[file join  $TEST_Dir sample _ghost_powerkid_20.xml]
       puts "          ... $openFile\n"
       lib_file::openProject_xml   $openFile		       
	   
	   
       puts "\n\n === create Information  ===\n"	  
       version_info::create  .v_info 0
       
       puts "\n\n === create Help  ===\n"
       version_info::create  .v_info 1
       
       puts "\n\n === create Environment  ===\n"
       version_info::create  .v_info 2
       
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
	set SAMPLE_Dir 	$::APPL_Config(SAMPLE_Dir)

        puts "\n\n  ====== l o o p   S A M P L E   F i l e s ========\n"                         
        puts "      currentFile  ... $currentFile"
        puts "      SAMPLE_Dir  .... $SAMPLE_Dir"
	puts "" 

	# lib_file::saveProject_xml saveAs    
	    
        foreach fileName [lsort [glob -directory [file normalize $SAMPLE_Dir] -type f *.xml]] {
    	    puts "\n     open Sample File:"
	    puts "          .... $fileName\n"
            lib_file::openProject_xml   $fileName
	    after 100
        }
	  # -- open previous opened File   
	puts "\n      ... open previous opened file:"
	puts "\n            ... $currentFile"
	switch -exact $currentFile {
	    {Template Road} {
		lib_gui::load_Template  Road
	    }	    
	    {Template MTB} {
		lib_gui::load_Template  MTB
	    }
	    default {
    		lib_file::openProject_xml   $currentFile    
	    }
	}	
	
          # tk_messageBox -title "loop Samples" -message "... $SAMPLE_Dir!"   
    }	 
	 
	 
    #-------------------------------------------------------------------------
	#  demo 01
	#	 
    proc demo_01 {args} {
	set currentFile $::APPL_Config(PROJECT_File)
	set SAMPLE_Dir 	$::APPL_Config(SAMPLE_Dir)
                   
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
	
	# lib_gui::select_canvasCAD   cv_Custom00
	
        set cv_custom::stageRefit no
        updateGeometryValue Personal(HandleBar_Distance) -15  20   5
        updateGeometryValue Personal(HandleBar_Height)   -15  20   5
        updateGeometryValue Component(Fork/Rake)          15 -10   5
        updateGeometryValue Custom(HeadTube/Angle)        2   -1   1  

        updateGeometryValue Personal(Saddle_Distance)    -15  10   5
        updateGeometryValue Personal(Saddle_Height)      -35  25   5

        updateGeometryValue FrameTubes(HeadTube/Length)  -20  15 -15
        updateGeometryValue Custom(WheelPosition/Rear)    25 -10  10

        updateGeometryValue Custom(BottomBracket/Depth)  -10  15   5
        set cv_custom::stageRefit yes
        return

    }	 

	  # -------------------------------------------------------------------------
	  #  updateGeometryValue
	  #
    proc updateGeometryValue {arrayName left right end} {
      
        puts "   ... $arrayName"
        set _array [lindex [split $arrayName (]  0]
        set _name  [lindex [split $arrayName ()] 1]
        puts "   ... $_array $_name"
        set xPath   [format "%s/%s" $_array $_name]
        puts "   ... $xPath"
	            
        set currentValue  [project::getValue $arrayName value]
        set valueList     [[namespace current]::demoValues $currentValue $left $right $end]
          # puts " ... project::getValue Personal(HandleBar_Distance)  [project::getValue Personal(HandleBar_Distance) value]"
          # puts " ... \$currentValue $currentValue"
          # puts " ... \$valueList    $valueList"
        foreach newValue $valueList {
            frame_geometry::set_projectValue $xPath $newValue
            # lib_gui::notebook_updateCanvas 
        }
    }	  
	 
    # -------------------------------------------------------------------------
    	#  deliver demo Values
    	#
    proc demoValues {base left right end} {
    	
    	set leftValue  [ expr $base + $left]
	set rightValue [ expr $base + $right]
	set endValue   [ expr $base + $end]
	return [list [expr 0.5*($leftValue+$base)]        $leftValue \
		     [expr 0.5*($leftValue+$base)]        $base \
		     [expr 0.5*($rightValue+$base)]       $rightValue \
		     [expr 0.5*($rightValue+$endValue)]   $endValue ]
    }	 
	 


     #-------------------------------------------------------------------------
     #
     #  end  namespace eval rattleCAD_Test 
     #

 }
  
