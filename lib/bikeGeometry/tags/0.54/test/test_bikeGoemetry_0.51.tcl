#!/bin/sh
# test_bikeGoemetry_1.0.tcl \
exec tclsh "$0" ${1+"$@"}



puts "\n\n ====== I N I T ============================ \n\n"

    # -- ::APPL_Config(BASE_Dir)  ------
set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
puts "   -> BASE_Dir:   $BASE_Dir\n"

    # -- Libraries  ---------------
lappend auto_path           [file join $BASE_Dir lib]
lappend auto_path           [file join $BASE_Dir ..]
            
    # puts "  \$auto_path  $auto_path"


    # -- Packages  ---------------
package require   vectormath    0.1
package require   bikeGeometry  0.51
package require   appUtil


    # -- Directories  ------------
set TEST_Dir    [file join $BASE_Dir test]
set SAMPLE_Dir  [file join $TEST_Dir sample]
puts "   -> TEST_Dir:   $TEST_Dir"
puts "   -> SAMPLE_Dir: $SAMPLE_Dir"


     # -- sampleFile  -----------
set sampleFile  [file join $SAMPLE_Dir template_road_3.4.xml]
puts "   -> sampleFile: $sampleFile"


     # -- Content  --------------
puts "\n   -> getContent: $sampleFile:"
    set fp [open $sampleFile]

    fconfigure    $fp -encoding utf-8
    set xml [read $fp]
    close         $fp

set sampleDOC   [dom parse  $xml]
set sampleDOM   [$sampleDOC documentElement]


    # puts [$sampleDOM asXML]


    # -- init bikeGeomtry  ------
#bikeGeometry::set_newProject $sampleDOM


#      <D> ---- $centerLineDef ----------
#   50.000 140.00 80.00 60.00 60.00 -7.000 5.000 -12.000 5.00 320.00 320.00 320.00 320.00
#      <D> --------------

#      <D> ---- $basePoints ----------
#   {0 0} {30.45231237766351 0.0} {35.33904432859936 -0.03731490869176923} {40.22463660480676 -0.1492509322519595} {45.10794979735015 -0.3357819651648697} {49.9878450288177 -0.5968645050026566} {54.86318421892824 -0.9324376625708055} {59.73283034995226 -1.3424231761083547} {64.59564773188514 -1.8267254295403745} {69.45050226731068 -2.385231474777072} {179.76990416419986 -15.896650836506808} {184.40065710698866 -16.36294313885827} {189.03770197148378 -16.761836925521777} {193.68005785508677 -17.09324781604323} {198.32674273172663 -17.357105705040055} {202.97677365959387 -17.553354777031416} {240.63462476759727 -18.909949237449894} {245.7810106691045 -19.21431417502879} {250.9218253685503 -19.601548068717875} {256.0557345671851 -20.071550411937892} {261.1814057585825 -20.624199215553745} {266.29750857449136 -21.259351039536796} {271.4027151301329 -21.976841030194805} {276.49570036885325 -22.776482962959562} {281.57514240604223 -23.65806929072164} {286.6397228722282 -24.62137119769926} {291.6881272552613 -25.66613865882732} {296.71904524149477 -26.792100504651444} {301.7311710558774 -27.99896449171007} {318.41009883860517 -32.12260631975187} {322.9495081144495 -33.1497697705999} {327.5033762258232 -34.110803876442674} {332.07073986501763 -35.00550534382944} {336.65063286953216 -35.833684911060175} {341.2420864264525 -36.59516738822123} {386.7126560406053 -43.79699810779669}
#      <D> ---- $controlPoints ----------
#   {0 0} {50.0 0} {50.048520144273894 -0.0029676191539942387} {189.00498137405896 -17.06467569587464} {189.022645303024 -17.066065877233385} {268.9739114645517 -19.858025613433455} {269.2162491841095 -19.892083958820116} {327.43399276066924 -34.40739769480018} {327.451355604897 -34.41093020538283} {386.7126560406053 -43.79699810779669}
#      <D> --------------

set centerLineDef {50.00  140.00  80.00 60.00 60.00  -7.000  5.000 -12.000 5.00 320.00 320.00 320.00 320.00}
#set centerLineDef {50.00  140.00  80.00 60.00 60.00  -7.000  9.000 -12.000 5.00 320.00 320.00 320.00 320.00}
#set centerLineDef {150.00 200.00 200.00 60.00 60.00 -30.000 45.000 -30.000 5.00 200.00 200.00 200.00 320.00}
#set centerLineDef {250.00000000000009 42.613865471188866 10 10 10 -1.3748347805694052 0 0 0 25.0 0 0 0}
set centerLineDef {100.00 100.00 100.00 100.00 100.00  -72.0 -72.0 -72.0 -72.0 -72.0 20.0 20.0 20.0 20.0 20.0 }
set centerLineDef {100.00 100.00 100.00 100.00 100.00  -90.0 -90.0 -90.0 -90.0 60 20.0 20.0 20.0 20.0 20.0 }

puts "\n\n"
puts " ---- init  00 -----------------------"
puts $centerLineDef
puts ""

if {1 == 1} {
    set returnValue   [bikeGeometry::tube::init_centerLine $centerLineDef debug]
} else {
    set returnValue   [bikeGeometry::tube::init_centerLine $centerLineDef ]
}

set basePoints    [lindex $returnValue 0]
set controlPoints [lindex $returnValue 1]
puts "\n\n\n"
puts " ---- init 01 -----------------------"
puts $centerLineDef
puts ""
puts " ==== basePoints ============================"
puts "   compare: {0 0} {30.45231237766351 0.0} {35.33904432859936 -0.03731490869176923} {40.22463660480676 -0.1492509322519595} {45.10794979735015 -0.3357819651648697} {49.9878450288177 -0.5968645050026566} {54.86318421892824 -0.9324376625708055} {59.73283034995226 -1.3424231761083547} {64.59564773188514 -1.8267254295403745} {69.45050226731068 -2.385231474777072} {179.76990416419986 -15.896650836506808} {184.40065710698866 -16.36294313885827} {189.03770197148378 -16.761836925521777} {193.68005785508677 -17.09324781604323} {198.32674273172663 -17.357105705040055} {202.97677365959387 -17.553354777031416} {240.63462476759727 -18.909949237449894} {245.7810106691045 -19.21431417502879} {250.9218253685503 -19.601548068717875} {256.0557345671851 -20.071550411937892} {261.1814057585825 -20.624199215553745} {266.29750857449136 -21.259351039536796} {271.4027151301329 -21.976841030194805} {276.49570036885325 -22.776482962959562} {281.57514240604223 -23.65806929072164} {286.6397228722282 -24.62137119769926} {291.6881272552613 -25.66613865882732} {296.71904524149477 -26.792100504651444} {301.7311710558774 -27.99896449171007} {318.41009883860517 -32.12260631975187} {322.9495081144495 -33.1497697705999} {327.5033762258232 -34.110803876442674} {332.07073986501763 -35.00550534382944} {336.65063286953216 -35.833684911060175} {341.2420864264525 -36.59516738822123} {386.7126560406053 -43.79699810779669}"
#puts "   compare: {0 0} {30.45231237766351 0.0} {35.33904432859936 -0.03731490869176923} {40.22463660480676 -0.1492509322519595} {45.10794979735015 -0.3357819651648697} {49.9878450288177 -0.5968645050026566} {54.86318421892824 -0.9324376625708055} {59.73283034995226 -1.3424231761083547} {64.59564773188514 -1.8267254295403745} {69.45050226731068 -2.385231474777072} {  <|>  } {69.45050226731068 -2.385231474777072} {179.76990416419986 -15.896650836506808} {184.40065710698866 -16.36294313885827} {189.03770197148378 -16.761836925521777} {193.68005785508677 -17.09324781604323} {198.32674273172663 -17.357105705040055} {202.97677365959387 -17.553354777031416} {240.63462476759727 -18.909949237449894} {245.7810106691045 -19.21431417502879} {250.9218253685503 -19.601548068717875} {256.0557345671851 -20.071550411937892} {261.1814057585825 -20.624199215553745} {266.29750857449136 -21.259351039536796} {271.4027151301329 -21.976841030194805} {276.49570036885325 -22.776482962959562} {281.57514240604223 -23.65806929072164} {286.6397228722282 -24.62137119769926} {291.6881272552613 -25.66613865882732} {296.71904524149477 -26.792100504651444} {301.7311710558774 -27.99896449171007} {318.41009883860517 -32.12260631975187} {322.9495081144495 -33.1497697705999} {327.5033762258232 -34.110803876442674} {332.07073986501763 -35.00550534382944} {336.65063286953216 -35.833684911060175} {341.2420864264525 -36.59516738822123} {386.7126560406053 -43.79699810779669}"
puts " ---- finish ---------------------"
puts "   new:     $basePoints"
puts "\n"
puts " ==== controlPoints ========================="
puts "   compare: {0 0} {50.0 0} {50.048520144273894 -0.0029676191539942387} {189.00498137405896 -17.06467569587464} {189.022645303024 -17.066065877233385} {268.9739114645517 -19.858025613433455} {269.2162491841095 -19.892083958820116} {327.43399276066924 -34.40739769480018} {327.451355604897 -34.41093020538283} {386.7126560406053 -43.79699810779669}"
puts " ---- finish ---------------------"
puts "   new:     $controlPoints"
puts ""
puts " ---- done -----------------------"



puts "     <D> \$p_S01_ct  30.45231237766353 -320.0"
puts "     <D> \$p_S02_a     175.14642271474696 -15.363058656143872"
puts "     <D> \$p_S02_ct  214.14461260439415 302.25170986907915"
puts "     <D> \$p_S02_b     202.97677365959387 -17.553354777031416"
puts "     <D> \$p_S03_a     235.48400340878402 -18.68853225391817"
puts "     <D> \$p_S03_ct  224.3161644639838 -338.4935969000288"
puts "     <D> \$p_S03_b     301.7311710558774 -27.99896449171007"
puts "     <D> \$p_S04_a     313.8861086474326 -31.029530806096034"
puts "     <D> \$p_S04_ct  391.30111523932635 279.46510160222283"
puts "     <D> \$p_S04_b     341.2420864264525 -36.59516738822123"








exit




    # -- get result as XML  -----
set runTime_XML [bikeGeometry::get_projectXML]
#puts [$runTime_XML asXML]    


    # -- get result as DICT  ----
set runTime_DICT [bikeGeometry::get_projectDICT]       
#appUtil::pdict $runTime_DICT


puts "\n  ... procs bikeGeometry::"
foreach _proc [info procs  bikeGeometry::*] {
       puts "       -> $_proc"
}

puts "\n  ... procs bikeGeometry::project::"
foreach _proc [info procs  bikeGeometry::project::*] {
       puts "       -> $_proc"
}

puts "\n  ... vars  bikeGeometry::project::"
foreach _var [info vars  bikeGeometry::project::*] {
       puts "       -> $_var"
}


set runtimeDOM [appUtil::namespaceReport ::]
# puts [$runtimeDOM asXML]

set fileName [file join $TEST_Dir runtimeDOM.xml]
set fp      [open $fileName w]
puts $fp [$runtimeDOM  asXML]
close $fp

puts "\n"
puts "  ... see also logFile:"
puts "             $fileName\n"

exit






set projectFile      template_road_3.3.xml


set ::APPL_Config(CONFIG_Dir)       [file join $BASE_Dir etc] 
     
set ::APPL_Config(root_InitDOM)     [ lib_file::get_XMLContent     [file join $::APPL_Config(CONFIG_Dir) rattleCAD_init.xml ] ]
puts "     ... root_InitDOM         [file join $::APPL_Config(CONFIG_Dir) rattleCAD_init.xml]"

set ::APPL_Config(root_ProjectDOM)  [lib_file::get_XMLContent     [file join $::APPL_Config(CONFIG_Dir) $projectFile] ]
puts "     ... root_ProjectDOM      [file join $::APPL_Config(CONFIG_Dir) $projectFile]"

    # expired
    # set dictInit    [bikeGeometry::init_Prereq  $::APPL_Config(root_InitDOM)]
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

