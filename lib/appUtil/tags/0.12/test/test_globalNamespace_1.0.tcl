#!/bin/sh
# test_bikeGoemetry_1.0.tcl \
exec tclsh "$0" ${1+"$@"}

namespace eval __test_appUtil {

    puts "\n\n ====== I N I T ============================ \n\n"
    
        # -- ::APPL_Config(BASE_Dir)  ------
    set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
    puts "   -> BASE_Dir:   $BASE_Dir\n"
    
        # -- Libraries  ---------------
    lappend auto_path           [file join $BASE_Dir lib]
    lappend auto_path           [file join $BASE_Dir ..]
                
        # puts "  \$auto_path  $auto_path"
    
    
        # -- Packages  ---------------
    package require   appUtil  
    
    
        # -- Directories  ------------
    set TEST_Dir    [file join $BASE_Dir test]
    set SAMPLE_Dir  [file join $TEST_Dir sample]
    puts "   -> TEST_Dir:   $TEST_Dir"
    puts "   -> SAMPLE_Dir: $SAMPLE_Dir"
    
    
         # -- namespace for testing  ---
    namespace eval my_Namespace_00 {
        namespace eval my_Namespace_01 {
            namespace eval my_Namespace_02 {
                namespace eval my_Namespace_03 {
                    
                }
                
                proc my_Procedure_00 {} {}
                proc my_Procedure_01 {} {}
                proc my_Procedure_02 {} {}
            }
            
            proc my_Procedure_00 {} {}
            proc my_Procedure_01 {} {}   
            
            variable my_Array_01
            array set my_Array_01 {
                _00 {value_00}
                _01 {value_01}
            }
            array set APPL_Config { 
                RELEASE_Version     {3.4}
            }
            
            variable my_Var_01 {var_01}
                  
        }
        
        proc my_Procedure_00 {} {}
    }
    
    
    puts "\n ==========================================="
    puts "\n  ... namespace Report:"
    
    # puts "  -> $::appUtil::config_var"
    # exit
    
    set runtimeDOM [appUtil::namespaceReport]
    # puts [$runtimeDOM asXML]
    
    set fileName [file join $TEST_Dir runtimeDOM.xml]
    set fp      [open $fileName w]
    puts $fp [$runtimeDOM  asXML]
    close $fp
    
    puts "\n"
    puts "  ... see also logFile:"
    puts "             $fileName\n"

    puts "\n ---------------------------- finished -----\n"
 
    
}


exit







set projectFile      template_road_3.3.xml


set ::APPL_Config(CONFIG_Dir)       [file join $BASE_Dir etc] 
     
set ::APPL_Config(root_InitDOM)     [ lib_file::get_XMLContent     [file join $::APPL_Config(CONFIG_Dir) rattleCAD_init.xml ] ]
puts "     ... root_InitDOM         [file join $::APPL_Config(CONFIG_Dir) rattleCAD_init.xml]"

set ::APPL_Config(root_ProjectDOM)  [lib_file::get_XMLContent     [file join $::APPL_Config(CONFIG_Dir) $projectFile] ]
puts "     ... root_ProjectDOM      [file join $::APPL_Config(CONFIG_Dir) $projectFile]"

    # expired
    # set dictInit    [biCycle::init_Prereq  $::APPL_Config(root_InitDOM)]
    # appUtil::pdict $dictInit

bikeGeometry::set_forkConfig [$::APPL_Config(root_InitDOM) selectNode /root/Fork]

set ::APPL_Config(root_ProjectDOM) [bikeGeometry::set_newProject $::APPL_Config(root_ProjectDOM)]

# puts [$::APPL_Config(root_ProjectDOM) asXML]





puts "\n"
puts "    ... loop through files"
puts ""
puts "        ... \$TEST_Dir   $TEST_Dir"
puts "\n"

  # parray ::APPL_Config

foreach thisFile { 
       focus_cayo_expert_2010__L_56.xml focus_cayo_expert_2010__M_54.xml  focus_cayo_expert_2010__XL_58.xml \
       columbus_max.xml \
       _template_3.2.78.xml _template_3.2.78_offroad.xml _template_3.3.00.xml _template_3.3.02.xml \
       _template_3.3.03.xml _template_3.3.04.xml _template_3.3.05.35.xml _template_3.3.06.xml \
       Kid20_V7.xml  ghost_powerkid_20.xml \
       __test_Integration_02.xml   
} {       
    set fileName     [file join  $TEST_Dir sample $thisFile]
    
    puts "\n"
    puts "  ========= o p e n   F I L E ====================="
    puts ""
    puts "         ... file:       $fileName"
    puts "n"
    
    set my_projDOM    [lib_file::get_XMLContent $fileName show]
        # set rattleCAD_Version [[$::APPL_Config(root_ProjectDOM) selectNodes /root/Project/rattleCADVersion/text()] asXML]

    bikeGeometry::set_newProject $my_projDOM
    #update          
}

