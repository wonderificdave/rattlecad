 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_gui.tcl
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
 #    namespace:  rattleCAD::lib_gui
 # ---------------------------------------------------------------------------
 #
 # 
 
 
 namespace eval lib_gui {

    variable    canvasGeometry ;   array    set canvasGeometry {}
    variable    notebookCanvas ;   array    set notebookCanvas {}
    variable    iconArray      ;   array    set iconArray {}
    
    variable    canvasUpdate   ;   array    set canvasUpdate {}
    variable    checkAngles    ;            set checkAngles off
    
    variable    noteBook_top
    
    variable    stageFormat
    variable    stageScale

    variable    external_canvasCAD  ;   array    set external_canvasCAD {}
     


                            
    #-------------------------------------------------------------------------
       #  create MainFrame with Menue  
       #
    proc create_MainFrame {} {        
            
            set mainframe_Menue {
                "&File"   all file 0 {
                        {command "&New"             {}      "New Project File"       {Ctrl n}   -command { lib_file::newProject_xml }     }
                        {command "&Open"            {}      "0pen Project File"     {Ctrl o}    -command { lib_file::openProject_xml }     }
                        {command "&Save"            {}      "Save Project File"     {Ctrl s}    -command { lib_file::saveProject_xml }    }
                        {command "Save &As ..."     {}      "Save Project File As"  {Ctrl a}    -command { lib_file::saveProject_xml saveAs} }
                        {separator}
                        {command "&Rendering"       {}      "Rendering Settings"    {}          -command { lib_gui::set_RenderingSettings } }
                        {command "Impo&rt"          {}      "import Parameter"      {Ctrl i}    -command { lib_file::opemProject_Subset_xml }    }
                        {separator}
                        {command "&Config Panel"    {}      "open Config Panel"     {Ctrl m}    -command { lib_gui::open_configPanel }    }
                        {command "&Update"          {}      "update Configuration"  {Ctrl u}    -command { lib_gui::notebook_updateCanvas force } }
                        {separator}
                        {command "&Print"           {}      "Print current Graphic" {Ctrl p}    -command { lib_gui::notebook_printCanvas $APPL_Env(EXPORT_Dir) } }
                        {command "&Export SVG"      {}      "Export to SVG"         {Ctrl f}    -command { lib_gui::notebook_exportSVG   $APPL_Env(EXPORT_Dir) } }
                        {command "&Export DXF"      {}      "Export to DXF"         {Ctrl d}    -command { lib_gui::notebook_exportDXF   $APPL_Env(EXPORT_Dir) } }
                        {separator}
                        {command "Intro-Image"      {}      "Show Intro Window"     {}          -command { create_intro .intro } }
                        {separator}
                        {command "E&xit"            {}      "Exit rattle_CAD"       {Ctrl x}    -command { exit } }
                }
                "Info"   all info 0 {
                        {command "&Info"            {}      "Information"           {Ctrl w}    -command { version_info::create  .v_info 0} }
                        {command "&Help"            {}      "Help"                  {Ctrl h}    -command { version_info::create  .v_info 1} }
                }
                "rattleCAD-Project"   all info 0 {
                        {command "rattleCAD WebSite"    {}  "about rattleCAD"       {}          -command { lib_file::open_URL {http://rattlecad.sourceforge.net/index.html} } }
                        {command "project@sourceforge"  {}  "sourceforge.net"       {}          -command { lib_file::open_URL {http://sourceforge.net/projects/rattlecad/index.html} } }
                        {command "like rattleCAD"       {}  "donate"                {}          -command { lib_file::open_URL {https://sourceforge.net/project/project_donations.php?group_id=301054} } }
                }
            }
        
        return [MainFrame .mainframe  -menu $mainframe_Menue ]
    }


    #-------------------------------------------------------------------------
        #  create MainFrame with Menue  
        #
    proc create_ButtonBar {tb_frame } {    
            variable iconArray
        
            Button    $tb_frame.open      -image  $iconArray(open)          -helptext "open ..."                -command { lib_file::openProject_xml }  
            Button    $tb_frame.save      -image  $iconArray(save)          -helptext "save ..."                -command { lib_file::saveProject_xml } 
            Button    $tb_frame.print_ps  -image  $iconArray(print_ps)      -helptext "print Postscript"        -command { lib_gui::notebook_printCanvas $APPL_Env(EXPORT_Dir) }          
            Button    $tb_frame.print_dxf -image  $iconArray(print_dxf)     -helptext "print DXF"               -command { lib_gui::notebook_exportDXF   $APPL_Env(EXPORT_Dir) }          
            Button    $tb_frame.print_svg -image  $iconArray(print_svg)     -helptext "print SVG"               -command { lib_gui::notebook_exportSVG   $APPL_Env(EXPORT_Dir) }          
                                                         
            Button    $tb_frame.set_rd    -image  $iconArray(reset_r)       -helptext "a roadbike Template"     -command { lib_gui::load_Template  Road }  
            Button    $tb_frame.set_mb    -image  $iconArray(reset_o)       -helptext "a offroad Template"      -command { lib_gui::load_Template  MTB  }  
              
            Button    $tb_frame.clear     -image  $iconArray(clear)         -helptext "clear Canvas..."         -command { lib_gui::notebook_cleanCanvas} 
            Button    $tb_frame.render    -image  $iconArray(update)        -helptext "update Canvas..."        -command { lib_gui::notebook_updateCanvas force}  
              

            Button    $tb_frame.scale_p  -image  $iconArray(scale_p)        -helptext "scale plus"              -command { lib_gui::notebook_scaleCanvas  [expr 3.0/2] }  
            Button    $tb_frame.scale_m  -image  $iconArray(scale_m)        -helptext "scale minus"             -command { lib_gui::notebook_scaleCanvas  [expr 2.0/3] }  
            Button    $tb_frame.resize   -image  $iconArray(resize)         -helptext "resize"                  -command { lib_gui::notebook_refitCanvas }  
            
            Button    $tb_frame.cfg      -image  $iconArray(cfg_panel)      -helptext "open config Panel"       -command { lib_gui::open_configPanel } 
            Button    $tb_frame.exit     -image  $iconArray(exit)           -command { exit }
              
            label   $tb_frame.sp0      -text   " "
            label   $tb_frame.sp1      -text   " "
            label   $tb_frame.sp2      -text   " "
            label   $tb_frame.sp3      -text   "      "
            label   $tb_frame.sp4      -text   " "
            label   $tb_frame.sp5      -text   " "
            label   $tb_frame.sp6      -text   " "
              
              
                # pack    $tb_frame.open     $tb_frame.save     $tb_frame.clear    $tb_frame.print    $tb_frame.sp0  \
                #        $tb_frame.set_rd   $tb_frame.set_mb   $tb_frame.sp2  \
                #        $tb_frame.render   $tb_frame.sp3  \
                #
            pack    $tb_frame.open       $tb_frame.save         $tb_frame.sp0  \
                    $tb_frame.print_ps   $tb_frame.print_dxf    $tb_frame.print_svg     $tb_frame.sp1  \
                    $tb_frame.set_rd     $tb_frame.set_mb       $tb_frame.sp2  \
                    $tb_frame.clear      $tb_frame.render       $tb_frame.sp3  \
                -side left -fill y
                       
                # pack    $tb_frame.exit   $tb_frame.sp6  \
                #        $tb_frame.resize $tb_frame.scale_p $tb_frame.scale_m   \
                #
            pack    $tb_frame.exit      $tb_frame.sp5       \
                    $tb_frame.resize    $tb_frame.scale_p   $tb_frame.scale_m   \
                    $tb_frame.sp6       $tb_frame.cfg       \
                -side right 
    }


    #-------------------------------------------------------------------------
        #  register notebookCanvas in notebook - Tabs   
        #
    proc create_Notebook {frame} {
            variable canvasGeometry
            variable canvasUpdate
            variable noteBook_top
            
                # ---     initialize canvasUpdate
            set canvasUpdate(recompute)    0
            
                # ---     create ttk::notebook
            set noteBook_top     [ ttk::notebook $frame.nb -width $canvasGeometry(width)    -height $canvasGeometry(height) ]                
                pack $noteBook_top -expand yes  -fill both  
            
                # ---     create and register any canvasCAD - canvas in lib_gui::notebookCanvas
            lib_gui::create_canvasCAD  $noteBook_top  cv_Custom00  "  Base Concept   "      A4  0.2  25  -bd 2  -bg white  -relief sunken
            lib_gui::create_canvasCAD  $noteBook_top  cv_Custom01  "  Frame Details  "      A4  0.2  25  -bd 2  -bg white  -relief sunken
            lib_gui::create_canvasCAD  $noteBook_top  cv_Custom03  "  Frame Drafting  "     A4  0.2  25  -bd 2  -bg white  -relief sunken
            lib_gui::create_canvasCAD  $noteBook_top  cv_Custom02  "  Summary   "           A4  0.2  25  -bd 2  -bg white  -relief sunken
            lib_gui::create_canvasCAD  $noteBook_top  cv_Custom06  "  Mockup  "             A4  0.2  25  -bd 2  -bg white  -relief sunken
            lib_gui::create_canvasCAD  $noteBook_top  cv_Custom07  "  Rear Mockup  "        A2  1.0  25  -bd 2  -bg white  -relief sunken
            lib_gui::create_canvasCAD  $noteBook_top  cv_Custom05  "  Tube Miter  "         A4  1.0  25  -bd 2  -bg white  -relief sunken
            lib_gui::create_canvasCAD  $noteBook_top  cv_Custom04  "  Frame - Jig  "        A4  0.2  25  -bd 2  -bg white  -relief sunken
            
            $noteBook_top add [frame $noteBook_top.components]     -text "... Components" 
            $noteBook_top add [frame $noteBook_top.report]         -text "... info" 
            

                # ---     fill with Report Widgets
            lib_cfg_report::createReport     $noteBook_top.report
                # ---     fill with Library Widgets
            lib_comp_library::createLibrary $noteBook_top.components
            lib_comp_library::update_compList


                # ---     bind event to update Tab on selection
            bind $noteBook_top <<NotebookTabChanged>> {lib_gui::notebook_updateCanvas}

                # ---     bind event Control-Tab and Shift-Control-Tab
            ttk::notebook::enableTraversal $noteBook_top

                # ---     select and update following Tab
            # $noteBook_top select $noteBook_top.cv_Custom02
            # $noteBook_top select $noteBook_top.cv_Custom00
            # $noteBook_top select $noteBook_top.cv_Custom07
            
            $noteBook_top select $noteBook_top.cv_Custom02

                # ---     return
            return $noteBook_top
    }


    #-------------------------------------------------------------------------
        #  register notebookCanvas in notebook - Tabs   
        #
    proc create_canvasCAD {notebook varname title stageFormat stageScale stageBorder args} {
            # lib_gui::create_canvasCAD  $noteBook_top  cv_Custom02  "Dimension Summary"  A4  0.2 -bd 2  -bg white  -relief sunken
        variable canvasGeometry
        variable notebookCanvas
        
        set notebookCanvas($varname)   $notebook.$varname.cvCAD

            # ---     add frame containing canvasCAD
        $notebook add [ frame $notebook.$varname ] -text $title 
        
            # ---     add canvasCAD to frame and select notebook tab before to update 
            #          the tabs geometry
        $notebook select $notebook.$varname  
            # puts "  canvasCAD::newCanvas $varname  $notebookCanvas($varname) \"$title\" $canvasGeometry(width) $canvasGeometry(height)  $stageFormat $stageScale $stageBorder $args"
        eval canvasCAD::newCanvas $varname  $notebookCanvas($varname) \"$title\" $canvasGeometry(width) $canvasGeometry(height)  $stageFormat $stageScale $stageBorder $args
            # puts "canvasCAD::newCanvas $varname  $notebookCanvas($varname) \"$title\" $canvasGeometry(width) $canvasGeometry(height)  $stageFormat $stageScale $stageBorder $args"
    }

    
    
    #-------------------------------------------------------------------------
        #  get current canvasCAD   
        #
    proc current_canvasCAD {} {
            variable noteBook_top        
            set current_cv [$noteBook_top select]
                # puts "        current canvasCAD: $current_cv"
            set varName "lib_gui::[lindex [split $current_cv .] end]"
                # puts "        -> $varName"
            return $varName
    }
    #-------------------------------------------------------------------------
        #  select specific canvasCAD tab   
        #
    proc select_canvasCAD {cv} {
            variable noteBook_top        
            
            set cvID    [format "lib_gui::%s" $cv]
            set cvPath  [$cvID getNodeAttr Canvas path]
            set noteBook   [winfo parent [winfo parent $cvPath]] 
                # puts "         $noteBook"
                # puts "         [winfo exists [winfo parent $cvPath]]"
            if {[winfo exists $cvPath]} {
                $noteBook select  [winfo parent $cvPath]   
                return [$noteBook select]
            } else {
                puts ""
                puts "         ... <E> select_canvasCAD:"
                puts "               $cv / $cvID  ... does not exist\n"
                return {}
            }
    }
    #-------------------------------------------------------------------------
        #  fill canvasCAD   
        #
    proc fill_canvasCAD {{varName {}}} {
            variable noteBook_top
            
            puts "      fill_canvasCAD: $varName"
            if {$varName == {}} {
                set current_cv [$noteBook_top select]
                puts "        current canvasCAD: $current_cv"
                set varName [lindex [split $current_cv .] end]
                puts "        -> $varName"
                # return
            }
            
            switch -exact -- $varName {
                cv_Custom00 -
                cv_Custom01 -
                cv_Custom02 -
                cv_Custom03 -
                cv_Custom04 -
                cv_Custom05 -
                cv_Custom06 -
                cv_Custom07 {
                        $noteBook_top select $noteBook_top.$varName
                        cv_custom::update     lib_gui::$varName 
                        # lib_gui::notebook_refitCanvas
                    }
                cv_Component {
                        ::update
                        lib_gui::notebook_refitCanvas
                        lib_comp_library::updateCanvas
                    }
                __cv_Library {
                        ::update
                        lib_gui::notebook_refitCanvas
                        lib_config::updateCanvas
                    }
                
            }
    }

    
    #-------------------------------------------------------------------------
       #  get notebook window    
       #
    proc notebook_getWidget {varName} {
            variable notebookCanvas
            
            foreach index [array names notebookCanvas] {
                if {$index == $varName} {
                      # puts "$index $notebookCanvas($index) "
                    return $notebookCanvas($index)
                }
            }
    }

    
    #-------------------------------------------------------------------------
       #  get notebook window    
       #
    proc notebook_getVarName {tabID} {
                # tabID:      [$noteBook_top select]
                #            .mainframe.frame.f2.nb.cv_Custom02
            variable notebookCanvas
            variable external_canvasCAD

                # -- lib_gui::notebookCanvas
            set cvID $tabID.cvCAD
            foreach varName [array names notebookCanvas] {
                    # puts "          -> $varName $notebookCanvas($varName) "
                if {$notebookCanvas($varName) == $cvID} {
                    return [namespace current]::$varName
                }
            }
                # -- lib_gui::external_canvasCAD
            foreach varName [array names external_canvasCAD] {
                     puts "          -> equal?: $varName  -> $external_canvasCAD($varName) "
                     puts "                 vs. $tabID   "
                if {$varName == $tabID} {
                    return $external_canvasCAD($varName)
                }
            }
    }

    
    #-------------------------------------------------------------------------
       #  register external canvasCAD-Widgets
       #
     proc register_external_canvasCAD {tabID cvID} {
            variable external_canvasCAD
            set external_canvasCAD($tabID) $cvID    
            puts "\n            register_external_canvasCAD: $tabID $external_canvasCAD($tabID)"
            puts   "                                         [$cvID getNodeAttr Canvas path]"
     }

    
    #-------------------------------------------------------------------------
       #  scale canvasCAD in current notebook-Tab  
       #
    proc notebook_scaleCanvas {value} {
            variable noteBook_top

            set currentTab [$noteBook_top select]
            set varName    [notebook_getVarName $currentTab]
                # puts "   varName: $varName"
            if { $varName == {} } {
                    puts "   notebook_scaleCanvas::varName: $varName"
                    return
            }
            set curScale  [ eval $varName getNodeAttr Canvas scale ]
            set newScale  [ format "%.4f" [ expr $value * $curScale * 1.0 ] ]
              # puts "   $curScale"
              # tk_messageBox -message "curScale: $curScale  /  newScale  $newScale "
            $varName scaleToCenter $newScale
    }


     #-------------------------------------------------------------------------
       #  get sizeinfo:  http://www2.tcl.tk/8423
       #
    proc check_windowSize {} {
            # puts "<D>   APPL_Env(window_Size):    $::APPL_Env(window_Size)"
        set newSize [lindex [split [wm geometry .] +] 0]
        if {![string equal $newSize $::APPL_Env(window_Size)]} {
                set ::APPL_Env(window_Size) $newSize
                set ::APPL_Env(window_Update) [ clock milliseconds ]
                puts "     ... update WindowSize: $::APPL_Env(window_Update)"
        }
    }


    #-------------------------------------------------------------------------
       #  update canvasCAD in current notebook-Tab  
       #
    proc notebook_updateCanvas {{mode {}}} {
            variable noteBook_top
            variable canvasUpdate
                    
            set currentTab                 [$noteBook_top select]
            set varName                    [notebook_getVarName $currentTab]
            set varName                    [lindex [split $varName {::}] end]
            
            set updateDone              {no}

            
            if { [catch { set lastUpdate $canvasUpdate($varName) } msg] } {
                 set canvasUpdate($varName) [ expr $::APPL_Env(canvasCAD_Update) -1 ]
            }
            
            set timeStart     [clock milliseconds]
       
            
                # -- update stage content if parameters changed
                    # puts "\n    canvasUpdate($varName):  $canvasUpdate($varName)    vs.  $::APPL_Env(canvasCAD_Update)\n"
            if { $mode == {} } {
                    if { $canvasUpdate($varName) < $::APPL_Env(canvasCAD_Update) } {
                        puts "\n       ... notebook_updateCanvas ... update $varName\n"
                        fill_canvasCAD $varName
                        set updateDone  {done}
                    } else {
                        puts "\n       ... notebook_updateCanvas ... update $varName ... not required\n"
                    }
            } else {
                        puts "\n       ... notebook_updateCanvas ... update $varName ... force\n"
                        fill_canvasCAD $varName
                        set updateDone  {done}
            }
            

                # -- refit stage if window size changed
            if { $canvasUpdate($varName) < $::APPL_Env(window_Update) } {
                        puts "\n       ... notebook_updateCanvas ... refitStage ........ $varName\n"
                        update
                        catch {$varName refitStage}
                        set updateDone  {done}       
            }
            
                        
            set timeEnd     [clock milliseconds]
            set timeDiff    [expr $timeEnd - $timeStart]
            
            
            puts "\n       ... time to update:"
            puts   "           ... [format "%9.3f" $timeDiff] milliseconds"
            puts   "           ... [format "%9.3f" [expr $timeDiff / 1000.0] ] seconds"
            
            if {$updateDone == {done}} {
                set canvasUpdate($varName) [ clock milliseconds ]
            }
                        
    }

    
    #-------------------------------------------------------------------------
       #  refit notebookCanvas in current notebook-Tab  
       #
    proc notebook_refitCanvas {} {
            variable noteBook_top

            set currentTab [$noteBook_top select]
            set varName    [notebook_getVarName $currentTab]
                 puts "  notebook_refitCanvas: varName: $varName"
            if { $varName == {} } {
                    puts "     notebook_refitCanvas::varName: $varName ... undefined"
                    return
            }
              # tk_messageBox -message "currentTab: $currentTab   /  varName  $varName"
            $varName refitStage
    }


    #-------------------------------------------------------------------------
       #  clean canvasCAD in current notebook-Tab  
       #
    proc notebook_cleanCanvas {} {
            variable noteBook_top

            set currentTab [$noteBook_top select]
            set varName    [notebook_getVarName $currentTab]
            if { $varName == {} } {
                    puts "   notebook_cleanCanvas::varName: $varName"
                    return
            }
            $varName clean_StageContent
    }

    
    #-------------------------------------------------------------------------
       #  print canvasCAD from current notebook-Tab  
       #
    proc notebook_printCanvas {printDir} {
            variable noteBook_top
            
                ## -- read from domConfig
            # remove 3.2.70 ;# set domConfig $::APPL_Env(root_ProjectDOM)

                # --- get currentTab
            set currentTab     [ $noteBook_top select ]
            set cv_Name        [ notebook_getVarName $currentTab]
            if { $cv_Name == {} } {
                    puts "   notebook_printCanvas::cv_Name: $cv_Name"
                    return
            }

                # --- set printFile
            set stageTitle    [ $cv_Name  getNodeAttr  Stage  title ]
            set fileName     [winfo name   $currentTab]___[ string map {{ } {_}} [ string trim $stageTitle ]]
            set printFile    [file join $printDir $fileName]
            
                # --- get stageScale
            set stageScale     [ $cv_Name  getNodeAttr  Stage    scale ]    
            set scaleFactor    [ expr round([ expr 1 / $stageScale ]) ]

                # --- set timeStamp
            set timeString     [ format "printed: %s" [ clock format [clock seconds] -format {%Y.%m.%d %H:%M} ] ]
            set textPos        [ vectormath::scalePointList {0 0} {10 7} $scaleFactor ]
            set timeStamp    [ $cv_Name create draftText $textPos  -text $timeString -size 2.5 -anchor sw ]
                
                # --- print content to File
            puts "    ------------------------------------------------"
            puts "      print  $printFile \n"
            puts "      notebook_exportSVG   $currentTab "
            puts "             currentTabp-Parent  [winfo parent $currentTab]  "
            puts "             currentTabp-Parent  [winfo name   $currentTab]  "
            puts "             canvasCAD Object    $cv_Name  "
            
                # $cv_Name print $printFile
            set printFile [$cv_Name print $printFile]
                
                # --- delete timeStamp
            catch [ $cv_Name delete $timeStamp ]
                                
            
            puts "    ------------------------------------------------"
            puts "      ... open $printFile "
            
            lib_file::openFile_byExtension $printFile                            
    }


    #-------------------------------------------------------------------------
       #  export canvasCAD from current notebook-Tab as SVG Graphic
       #
    proc notebook_exportSVG {printDir} {
            variable noteBook_top
            
                ## -- read from domConfig
            # remove 3.2.70 ;# set domConfig $::APPL_Env(root_ProjectDOM)

                # --- get currentTab
            set currentTab     [ $noteBook_top select ]
            set cv_Name        [ notebook_getVarName $currentTab]
            if { $cv_Name == {} } {
                    puts "   notebook_exportSVG::cv_Name: $cv_Name"
                    return
            }
            
                # --- set exportFile
            set stageTitle    [ $cv_Name  getNodeAttr  Stage  title ]
            set fileName     [ winfo name   $currentTab]___[ string map {{ } {_}} [ string trim $stageTitle ] ]
            set exportFile    [ file join $printDir ${fileName}.svg ]
                # set exportFile [ file join $printDir [winfo name   $currentTab].svg ]

                # --- export content to File
            puts "    ------------------------------------------------"
            puts "      export SVG - Content to    $exportFile \n"
            puts "      notebook_exportSVG   $currentTab "
            puts "             currentTabp-Parent  [winfo parent $currentTab]  "
            puts "             currentTabp-Parent  [winfo name   $currentTab]  "
            puts "             canvasCAD Object    $cv_Name  "
            
            set exportFile [$cv_Name exportSVG $exportFile]
            
            puts "    ------------------------------------------------"
            puts "      ... open $exportFile "
            
            lib_file::open_localFile $exportFile
            
                # lib_file::openFile_byExtension $exportFile
                # lib_file::openFile_byExtension $exportFile .htm
    }


    #-------------------------------------------------------------------------
       #  export canvasCAD from current notebook-Tab as SVG Graphic
       #
    proc notebook_exportDXF {printDir} {
            variable noteBook_top
            
                ## -- read from domConfig
            # remove 3.2.70 ;# set domConfig $::APPL_Env(root_ProjectDOM)

                # --- get currentTab
            set currentTab     [ $noteBook_top select ]
            set cv_Name        [ notebook_getVarName $currentTab]
            if { $cv_Name == {} } {
                    puts "   notebook_exportDXF::cv_Name: $cv_Name"
                    return
            }
            
                # --- set exportFile
            set stageTitle    [ $cv_Name  getNodeAttr  Stage  title ]
            set fileName     [ winfo name   $currentTab]___[ string map {{ } {_}} [ string trim $stageTitle ] ]
            set exportFile    [ file join $printDir ${fileName}.dxf ]

                # --- export content to File
            puts "    ------------------------------------------------"
            puts "      export DXF - Content to    $exportFile \n"
            puts "      notebook_exportDXF   $currentTab "
            puts "             currentTabp-Parent  [winfo parent $currentTab]  "
            puts "             currentTabp-Parent  [winfo name   $currentTab]  "
            puts "             canvasCAD Object    $cv_Name  "
            
            set exportFile [$cv_Name exportDXF $exportFile]
            
            puts "    ------------------------------------------------"
            puts "      ... open $exportFile "
            
            lib_file::open_localFile $exportFile

                # lib_file::openFile_byExtension $exportFile .dxf
    }

    
    #-------------------------------------------------------------------------
       #  create a Button inside a canvas of notebookCanvas
       #
    proc notebook_createButton {nb_Canvas cv_ButtonList    {type {default}}} {
            
            puts "       notebook_createButton:  $cv_ButtonList"
            set cv_Name     [lindex [split $nb_Canvas :] end]
            set cv      [lib_gui::notebook_getWidget  $cv_Name]
            
                # puts [$cv find withtag __NB_Button__]
            foreach cv_Window [$cv find withtag __NB_Button__] {
                #puts "   <D> $cv_Window"
                #set cv_Button [$cv itemcget $cv_Window -window]
                #puts "   <D> $cv_Button"
                #destroy     $cv_Window  ; # delete containing window           
                #$cv delete  $cv_Button  ; # delete button
            }
                # puts "   <D> [$cv find withtag __NB_Button__]"
            
            set idx 0
            foreach cv_Button $cv_ButtonList {
                puts "          ... $cv_Button"
                set buttonCount [llength [$cv find withtag __NB_Button__]]
                    # puts $buttonCount
                set x_Position  7
                set y_Position  [expr 19 + $idx * 25]
                incr idx
                    
                
                switch -regexp $cv_Button {
                        changeFormatScale {
                                    if {$type != {default}} {
                                        set buttonText "Format"
                                    } else {
                                        set buttonText "Format & Scale"
                                    }
                                    # -- create a Button to change Format and Scale of Stage
                                    catch { destroy $cv.button_FormatScale }
                                    catch {    button  $cv.button_FormatScale \
                                                    -text $buttonText \
                                                    -command [format {lib_gui::change_FormatScale %s %s %s} $cv $y_Position $type ]                                
                                            $cv create window $x_Position $y_Position \
                                                    -window $cv.button_FormatScale \
                                                    -anchor w \
                                                    -tags {__Button__Format_Scale__ __NB_Button__}
                                    }
                                }
                        TubingCheckAngles {
                                    # -- create a Button to execute tubing_checkAngles
                                    catch { destroy $cv.button_TCA }
                                    catch {    button  $cv.button_TCA \
                                                    -text "check Frame Angles" \
                                                    -command [format {lib_gui::tubing_checkAngles %s} $cv]                                
                                            $cv create window $x_Position $y_Position \
                                                    -window $cv.button_TCA \
                                                    -anchor w \
                                                    -tags {__Button__TCA__ __NB_Button__}
                                    }
                                }
                        ChainStayRendering {
                                    # -- create a Button to set ChainStayRendering
                                    catch { destroy $cv.button_CSR }
                                    catch {    button  $cv.button_CSR \
                                                    -text "switch: straight/bent/off" \
                                                    -command [format {lib_gui::rendering_ChainStay %s} $cv]                                
                                            $cv create window $x_Position $y_Position \
                                                    -window $cv.button_CSR \
                                                    -anchor w \
                                                    -tags {__Button__CSR__ __NB_Button__}
                                    }
                                }
                        Reference2Custom {
                                    # -- create a Button to execute geometry_reference2personal
                                    catch { destroy $cv.button_R2C }
                                    catch {    button  $cv.button_R2C \
                                                    -text "copy settings to Base Geometry" \
                                                    -command lib_gui::geometry_reference2personal                                
                                            $cv create window $x_Position $y_Position \
                                                    -window $cv.button_R2C \
                                                    -anchor w \
                                                    -tags {__Button__R2C__ __NB_Button__}
                                    }
                                }
                }
            }
    }

    
    #-------------------------------------------------------------------------
       #  update Personal Geometry with parameters of Reference Geometry 
       #
    proc tubing_checkAngles {cv {type {default}}} {
        
            if {$lib_gui::checkAngles != {on}} {
                set lib_gui::checkAngles {on}
            } else {
                set lib_gui::checkAngles {off}         
            }
            cv_custom::update [lib_gui::current_canvasCAD]
            return
    }


    #-------------------------------------------------------------------------
       #  update Personal Geometry with parameters of Reference Geometry 
       #
    proc rendering_ChainStay {cv {type {default}}} {
        
            switch $project::Rendering(ChainStay) {
                {straight}  { project::setValue Rendering(ChainStay)        value    {off-nb} }
                {off-nb}    { project::setValue Rendering(ChainStay)        value    {s-bent} }       
                {s-bent}    { project::setValue Rendering(ChainStay)        value    {off-ns} }
                {off-ns}    { project::setValue Rendering(ChainStay)        value    {straight} }
                default     { project::setValue Rendering(ChainStay)        value    {straight} }
            }
            cv_custom::update [lib_gui::current_canvasCAD]
            return
    }


    #-------------------------------------------------------------------------
       #  create menue to change scale and size of Stage 
       #
    proc change_FormatScale {cv y {type {default}}}  {
    
            set cv_Name [lindex [split $cv .] end-1]
            
                # puts "  change_FormatScale:  cv: $cv"
                # puts "  change_FormatScale:  cv_Name: $cv_Name"
            
            set     lib_gui::stageFormat    A4
            set     lib_gui::stageScale        0.20        
            
            if {[ $cv find withtag __Select__Format_Scale__ ] == {} } {
                    catch     {    set baseFrame [frame .f_format_$cv_Name  -relief raised -border 1]
                                $cv create window 27 [expr $y+16] \
                                        -window $baseFrame \
                                        -anchor nw \
                                        -tags __Select__Format_Scale__
                                frame $baseFrame.select
                                pack  $baseFrame.select
                                        
                            }
            } else {
                    $cv delete     __Select__Format_Scale__
                    $cv dtag     __Select__Format_Scale__
                    destroy        .f_format_$cv_Name
                    #$cv.f_format destroy
                    return
            }
            
            
            set f_DIN_Format    [frame $baseFrame.select.din_Format]
                    radiobutton $f_DIN_Format.a4 -text A4 -value A4    -variable lib_gui::stageFormat  -command {puts $lib_gui::stageFormat}
                    radiobutton $f_DIN_Format.a3 -text A3 -value A3 -variable lib_gui::stageFormat  -command {puts $lib_gui::stageFormat}
                    radiobutton $f_DIN_Format.a2 -text A2 -value A2    -variable lib_gui::stageFormat  -command {puts $lib_gui::stageFormat}
                    radiobutton $f_DIN_Format.a1 -text A1 -value A1    -variable lib_gui::stageFormat  -command {puts $lib_gui::stageFormat}
                    radiobutton $f_DIN_Format.a0 -text A0 -value A0    -variable lib_gui::stageFormat  -command {puts $lib_gui::stageFormat}
                pack $f_DIN_Format.a4 \
                     $f_DIN_Format.a3 \
                     $f_DIN_Format.a2 \
                     $f_DIN_Format.a1 \
                     $f_DIN_Format.a0
            
            set f_Scale        [frame $baseFrame.select.scale]
            if {$type == {default}} {
                    radiobutton $f_Scale.s020 -text "1:5  "     -value 0.20 -anchor w     -variable lib_gui::stageScale -command {puts $lib_gui::stageScale}
                    radiobutton $f_Scale.s025 -text "1:4  "     -value 0.25 -anchor w     -variable lib_gui::stageScale -command {puts $lib_gui::stageScale}
                    radiobutton $f_Scale.s033 -text "1:3  "     -value 0.33 -anchor w     -variable lib_gui::stageScale -command {puts $lib_gui::stageScale}
                    radiobutton $f_Scale.s040 -text "1:2,5"     -value 0.40 -anchor w     -variable lib_gui::stageScale -command {puts $lib_gui::stageScale}
                    radiobutton $f_Scale.s050 -text "1:2  "     -value 0.50 -anchor w     -variable lib_gui::stageScale -command {puts $lib_gui::stageScale}
                    radiobutton $f_Scale.s100 -text "1:1  "     -value 1.00 -anchor w     -variable lib_gui::stageScale -command {puts $lib_gui::stageScale}
                pack $f_Scale.s020 \
                     $f_Scale.s025 \
                     $f_Scale.s040 \
                     $f_Scale.s050 \
                     $f_Scale.s100
            }
            pack $f_DIN_Format $f_Scale -side left
            
            button     $baseFrame.update \
                        -text "update" \
                        -command {lib_gui::notebook_formatCanvas  $lib_gui::stageFormat  $lib_gui::stageScale}
            pack $baseFrame.update -expand yes -fill x            
    }


    #-------------------------------------------------------------------------
       #  update Personal Geometry with parameters of Reference Geometry 
       #
    proc geometry_reference2personal {} {
        
            set answer    [tk_messageBox -icon question -type okcancel -title "Reference to Personal" -default cancel\
                                        -message "Do you really wants to overwrite your \"Personal\" parameter \n with \"Reference\" settings" ]
                #tk_messageBox -message "$answer"    
                
            switch $answer {
                cancel    return                
                ok        {    frame_geometry_reference::export_parameter_2_geometry_custom  $::APPL_Env(root_ProjectDOM)
                            lib_gui::fill_canvasCAD cv_Custom00 
                        }
            }
    }


    #-------------------------------------------------------------------------
       #  change Rendering Settings 
       #
    proc set_RenderingSettings  {{type {}}}  {
            variable noteBook_top

            set currentTab [$noteBook_top select]
            set varName    [notebook_getVarName $currentTab]
            set cv_Name    [notebook_getWidget  $varName]
                # puts "  notebook_refitCanvas: varName: $varName"
            if { $varName == {} } {
                    puts "     notebook_refitCanvas::varName: $varName ... undefined"
                    return
            }
            
                # puts "   ... $type"
                # puts "   ... $currentTab"
                # puts "   ... $varName"
                # puts "   ... $cv_Name"
        
            switch $type {
                    Fork    { set listDefinition list://Rendering(Fork@SELECT_ForkTypes) }
                    Brake   { set listDefinition list://Rendering(Brake/Front@SELECT_BrakeTypes) }
                    default { set listDefinition {    list://Rendering(Fork@SELECT_ForkTypes)
                                                    list://Rendering(Brake/Front@SELECT_BrakeTypes)
                                                    list://Rendering(Brake/Rear@SELECT_BrakeTypes)
                                                    list://Rendering(BottleCage/SeatTube@SELECT_BottleCage)
                                                    list://Rendering(BottleCage/DownTube@SELECT_BottleCage)
                                                    list://Rendering(BottleCage/DownTube_Lower@SELECT_BottleCage) }
                            }
            } 
            frame_geometry::createEdit  5 100  $varName  $listDefinition  {Rendering Settings}                
            # frame_geometry::createEdit  5 80  $varName  cv_custom::update  $listDefinition  {Rendering Settings}                
    }
    
    #-------------------------------------------------------------------------
       #  change canvasCAD Format and Scale
       #
    proc notebook_formatCanvas {stageFormat stageScale} {
            variable canvasUpdate
            variable noteBook_top

                # puts "\n=================="
                # puts "    stageFormat $stageFormat"
                # puts "    stageScale  $stageScale"
                # puts "=================="
                    
            set currentTab [$noteBook_top select]
            set varName    [notebook_getVarName $currentTab]

                # puts "   varName: $varName"
            if { $varName == {} } {
                    puts "   notebook_refitCanvas::varName: $varName"
                    return
            }
                            
            $varName formatCanvas $stageFormat $stageScale
            set canvasUpdate($varName) [ expr $::APPL_Env(canvasCAD_Update) -1 ]
            notebook_updateCanvas force
            notebook_refitCanvas
            notebook_updateCanvas force
    }
    
    #-------------------------------------------------------------------------
       #  load Template from File
       #
    proc load_Template {type} {
            variable canvasUpdate
            variable noteBook_top

            lib_file::openTemplate_xml $type
            return
    }

    #-------------------------------------------------------------------------
       #  load Template from File
       #
    proc open_configPanel {{mode {}}} {
            switch $mode {
                {refresh} {
                            puts "      ... open_configPanel $mode"
                            if {[winfo exists .cfg]} {
                                catch {lib_config::create . .cfg refresh}
                            }
                        }
                default {
                            puts "      ... open_configPanel $mode"
                            lib_config::create . .cfg
                        }
            }
    }


    proc global_kb_Binding {ab} {
            variable noteBook_top

            # puts "\n   -----> keyboard binding \n -------------"
            bind . <F1>     {version_info::create  .v_info 1}
            bind . <F3>     {lib_gui::notebook_scaleCanvas  [expr 2.0/3]}
            bind . <F4>     {lib_gui::notebook_scaleCanvas  [expr 3.0/2]}
            bind . <F5>     {lib_gui::notebook_refitCanvas}
            bind . <F6>     {lib_gui::notebook_updateCanvas force}
            
            bind . <Key-Up>     {lib_gui::move_Canvas    0  50 }
            bind . <Key-Down>   {lib_gui::move_Canvas    0 -50 }
            bind . <Key-Left>   {lib_gui::move_Canvas   50   0 }
            bind . <Key-Right>  {lib_gui::move_Canvas  -50   0 }
            
            bind . <MouseWheel>         {lib_gui::bind_MouseWheel updown    %D}  ;# move up/down
            bind . <Shift-MouseWheel>   {lib_gui::bind_MouseWheel leftright %D}  ;# move left/right
            bind . <Control-MouseWheel> {lib_gui::bind_MouseWheel scale     %D}  ;# scale
            
            # bind . <Key-Tab>    {lib_gui::notebook_nextTab}
            # bind . <Key-Tab>    {tk_messageBox -message "Keyboard Event: <Key-Tab>"}
            # bind . <F5>     { tk_messageBox -message "Keyboard Event: <F5>" }
    }
    #-------------------------------------------------------------------------
       #  cursor binding on canvas objects
       #
    proc object_CursorBinding {cv_Name tag {cursor {hand2}} } {
            $cv_Name bind $tag    <Enter> [list $cv_Name configure -cursor $cursor]
            $cv_Name bind $tag    <Leave> [list $cv_Name configure -cursor {}]
    }
    #-------------------------------------------------------------------------
       #  move canvas content
       #
    proc move_Canvas {x y} {
            variable canvasUpdate
            variable noteBook_top

                # puts "\n=================="
                # puts "    stageFormat $stageFormat"
                # puts "    stageScale  $stageScale"
                # puts "=================="
                    
            set currentTab [$noteBook_top select]
            set varName    [notebook_getVarName $currentTab]

            catch {$varName moveCanvas $x $y}     
    }
    #-------------------------------------------------------------------------
       #  move canvas content
       #
    proc bind_MouseWheel {type value} {
            variable canvasUpdate
            variable noteBook_top

                # frame_geometry::createEdit
                #    creates window $cv.f_edit
                #    catch <MouseWheel> for $cv.f_edit
            set currentTab [$noteBook_top select]
            set varName    [notebook_getVarName $currentTab]
            set cv         [ $varName getNodeAttr Canvas path]
            if {[llength [ $cv gettags  __cvEdit__]] > 0 } {
                # puts "\n=================="
                # puts "    bind_MouseWheel: catched"
                return
            }
            
                puts "\n=================="
                puts "    bind_MouseWheel"
                puts "       type   $type"
                puts "       value  $value"
                
            switch -exact $type {
                updown { if {$value > 0} {set scale 1.0} else {set scale -1.0}
                            lib_gui::move_Canvas    0  [expr $scale * 40] 
                        }
                leftright {   if {$value > 0} {set scale 1.0} else {set scale -1.0}
                            lib_gui::move_Canvas    [expr $scale * 40]  0 
                        }
                scale {  if {$value > 0} {set scale 1.1} else {set scale 0.9}
                            lib_gui::notebook_scaleCanvas $scale
                        }
                default  {}
            }
                
            return     
    }

     #-------------------------------------------------------------------------
       #  modify standard widget bindings
       #
       #       http://wiki.tcl.tk/2944
    proc binding_copyClass {class newClass} {
        set bindingList [bind $class]
        #puts $bindingList

        foreach binding $bindingList {
          bind $newClass $binding [bind $class $binding]
        }
    }
    proc binding_removeAllBut {class bindList} {
        foreach binding $bindList {
          array set tmprab "<${binding}> 0"
        }

        foreach binding [bind $class] {
          if {[info exists tmprab($binding)]} {
            continue
          }
          bind $class $binding {}
        }
    }
    proc binding_removeOnly {class bindList} {
        foreach binding $bindList {
          array set tmprab "<${binding}> 0"
        }

        foreach binding [bind $class] {
          if {[info exists tmprab($binding)]} {
            bind $class $binding {}
          }
          continue
          # bind $class $binding {}
        }
    }
    proc binding_reportBindings {class} {
        puts "    reportBindings: $class"
        foreach binding [bind $class] {
            puts "           $binding"
        }
    }    
}
