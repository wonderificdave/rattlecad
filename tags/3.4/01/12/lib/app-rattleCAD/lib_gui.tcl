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
 
 
 namespace eval rattleCAD::gui {

    variable    canvasGeometry ;   array    set canvasGeometry {}
    variable    notebookCanvas ;   array    set notebookCanvas {}
    variable    iconArray      ;   array    set iconArray      {}
    
    variable    canvasUpdate   ;   array    set canvasUpdate   {}
    variable    checkAngles    ;            set checkAngles    off
    
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
                {command "&New"             {}  "New Project File"      {Ctrl n}      -command { rattleCAD::file::newProject_xml } }
                {command "&Open"            {}  "0pen Project File"     {Ctrl o}      -command { rattleCAD::file::openProject_xml } }
                {command "&Save"            {}  "Save Project File"     {Ctrl s}      -command { rattleCAD::file::saveProject_xml } }
                {command "Save &As ..."     {}  "Save Project File As"  {CtrlAlt s}   -command { rattleCAD::file::saveProject_xml saveAs} }
                
                {separator}
                
                {command "Undo"             {}  "Undo"                  {Ctrl z}     -command { rattleCAD::update::changeList::previous} }
                {command "Redo"             {}  "Redo"                  {Ctrl y}     -command { rattleCAD::update::changeList::next} }
                
                {separator}
                
                {command "&Copy Reference"  {}  "Copy Reference"       {Ctrl r}     -command { rattleCAD::gui::notebook_switchTab  cv_Custom02} }
                
                {separator}
                
                {command "&Export PDF"      {}  "Export PDF-Report"     {Ctrl p}      -command { rattleCAD::gui::export_Project      pdf} }
                {command "&Export HTML"     {}  "Export HTML-Report"    {Ctrl t}      -command { rattleCAD::gui::export_Project      html} }
                {command "&Export SVG"      {}  "Export to SVG"         {}            -command { rattleCAD::gui::notebook_exportSVG  $APPL_Config(EXPORT_Dir) } }
                {command "&Export DXF"      {}  "Export to DXF"         {}            -command { rattleCAD::gui::notebook_exportDXF  $APPL_Config(EXPORT_Dir) } }
                {command "&Export PS"       {}  "Export to PostScript"  {}            -command { rattleCAD::gui::notebook_exportPS   $APPL_Config(EXPORT_Dir) } }
                    
                {separator}
                
                {command "Demo"             {}  "rattleCAD Demo"        {}            -command { rattleCAD::test:::controlDemo demo_01 } }
                {command "Samples"          {}  "rattleCAD Samples"     {}            -command { rattleCAD::test:::controlDemo loopSamples } }
                {command "Integration Test" {}  "Integration Test"      {CtrlAlt f}   -command { rattleCAD::test:::controlDemo integrationTest_00} }
                                                                                
                {separator}
                        
                {command "Impo&rt"          {}  "import Parameter"      {Ctrl i}      -command { rattleCAD::file::openProject_Subset_xml } }
                {command "&Rendering"       {}  "Rendering Settings"    {}            -command { rattleCAD::gui::set_RenderingSettings } }
                        
                {separator}
                        
                {command "&Config Panel"    {}  "open Config Panel"     {Ctrl m}      -command { rattleCAD::gui::open_configPanel } }
                
                {separator}
                
                {command "&SVG-Component"   {}  "open simplify_SVG"     {}            -command { rattleCAD::tool::start_simplifySVG } }
                {command "&SVG-ChainWheel"  {}  "open chainWheel_SVG"   {}            -command { rattleCAD::tool::start_chainWheelSVG } }
                                
                {separator}
                        
                {command "Intro-Image"      {}  "Show Intro Window"     {}            -command { create_intro .intro } }
                {command "&Update"          {}  "update Configuration"  {Ctrl u}      -command { rattleCAD::gui::notebook_updateCanvas force } }
                                                                                                                                                            
                {separator}
                        
                {command "E&xit"            {}  "Exit rattle_CAD"       {Ctrl x}      -command { rattleCAD::gui::exit_rattleCAD } }
            }
            "Info"   all info 0 {
                {command "&Info"            {}  "Information"           {Ctrl w}      -command { rattleCAD::version_info::create  .v_info 0} }
                {command "&Help"            {}  "Help"                  {Ctrl h}      -command { rattleCAD::version_info::create  .v_info 1} }
            }
            "rattleCAD-Project"   all info 0 {
                {command "rattleCAD WebSite"    {}  "about rattleCAD"       {}        -command { rattleCAD::file::open_URL {http://rattlecad.sourceforge.net/index.html} } }
                {command "rattleCAD Features"   {}  "rattleCAD Features"    {}        -command { rattleCAD::file::open_URL {http://rattlecad.sourceforge.net/features.html} } }
                {command "project@sourceforge"  {}  "sourceforge.net"       {}        -command { rattleCAD::file::open_URL {http://sourceforge.net/projects/rattlecad/index.html} } }
                {command "like rattleCAD"       {}  "donate"                {}        -command { rattleCAD::file::open_URL {https://sourceforge.net/project/project_donations.php?group_id=301054} } }
            }
        }
        
        return [MainFrame .mainframe  -menu $mainframe_Menue ]
    }


    #-------------------------------------------------------------------------
        #  create MainFrame with Menue  
        #
    proc create_ButtonBar {tb_frame } {    
            variable iconArray
        
            Button    $tb_frame.open      -image  $iconArray(open)          -helptext "open ..."                -command { rattleCAD::file::openProject_xml }  
            Button    $tb_frame.save      -image  $iconArray(save)          -helptext "save ..."                -command { rattleCAD::file::saveProject_xml } 
            
            Button    $tb_frame.backward  -image  $iconArray(backward)      -helptext "... backward"            -command { rattleCAD::update::changeList::previous }          
            Button    $tb_frame.forward   -image  $iconArray(forward)       -helptext "forward ..."             -command { rattleCAD::update::changeList::next }          
            
            Button    $tb_frame.render    -image  $iconArray(update)        -helptext "update Canvas..."        -command { rattleCAD::gui::notebook_updateCanvas force}  
            Button    $tb_frame.clear     -image  $iconArray(clear)         -helptext "clear Canvas..."         -command { rattleCAD::gui::notebook_cleanCanvas} 
              
            Button    $tb_frame.set_rd    -image  $iconArray(reset_r)       -helptext "a roadbike Template"     -command { rattleCAD::gui::load_Template  Road }  
            Button    $tb_frame.set_mb    -image  $iconArray(reset_o)       -helptext "a offroad Template"      -command { rattleCAD::gui::load_Template  MTB  }  
            
            Button    $tb_frame.print_htm -image  $iconArray(print_html)    -helptext "export HTML"             -command { rattleCAD::gui::export_Project      html }          
            Button    $tb_frame.print_pdf -image  $iconArray(print_pdf)     -helptext "export PDF"              -command { rattleCAD::gui::export_Project      pdf }          

            Button    $tb_frame.print_ps  -image  $iconArray(print_ps)      -helptext "print Postscript"        -command { rattleCAD::gui::notebook_exportPS   $APPL_Config(EXPORT_Dir) }          
            Button    $tb_frame.print_dxf -image  $iconArray(print_dxf)     -helptext "print DXF"               -command { rattleCAD::gui::notebook_exportDXF  $APPL_Config(EXPORT_Dir) }          
            Button    $tb_frame.print_svg -image  $iconArray(print_svg)     -helptext "print SVG"               -command { rattleCAD::gui::notebook_exportSVG  $APPL_Config(EXPORT_Dir) }          
            
            Button    $tb_frame.scale_p  -image  $iconArray(scale_p)        -helptext "scale plus"              -command { rattleCAD::gui::notebook_scaleCanvas  [expr 3.0/2] }  
            Button    $tb_frame.scale_m  -image  $iconArray(scale_m)        -helptext "scale minus"             -command { rattleCAD::gui::notebook_scaleCanvas  [expr 2.0/3] }  
            Button    $tb_frame.resize   -image  $iconArray(resize)         -helptext "resize"                  -command { rattleCAD::gui::notebook_refitCanvas }  
            
            Button    $tb_frame.cfg      -image  $iconArray(cfg_panel)      -helptext "open config Panel"       -command { rattleCAD::gui::open_configPanel } 
            Button    $tb_frame.exit     -image  $iconArray(exit)                                               -command { rattleCAD::gui::exit_rattleCAD }
              
            label   $tb_frame.sp0      -text   " "
            label   $tb_frame.sp1      -text   " "
            label   $tb_frame.sp2      -text   " "
            label   $tb_frame.sp3      -text   " "
            label   $tb_frame.sp4      -text   " "
            label   $tb_frame.sp5      -text   "      "
            label   $tb_frame.sp6      -text   " "
            label   $tb_frame.sp7      -text   " "
              
              
                # pack    $tb_frame.open     $tb_frame.save     $tb_frame.clear    $tb_frame.print    $tb_frame.sp0  \
                #        $tb_frame.set_rd   $tb_frame.set_mb   $tb_frame.sp2  \
                #        $tb_frame.render   $tb_frame.sp3  \
                #
            pack    $tb_frame.open       $tb_frame.save         $tb_frame.sp0  \
                    $tb_frame.backward   $tb_frame.forward      $tb_frame.sp1  \
                    $tb_frame.render     $tb_frame.clear        $tb_frame.sp2  \
                    $tb_frame.set_rd     $tb_frame.set_mb       $tb_frame.sp3  \
                    $tb_frame.print_htm  $tb_frame.print_pdf    $tb_frame.sp4  \
                    $tb_frame.print_ps   $tb_frame.print_dxf    $tb_frame.print_svg     $tb_frame.sp5 \
                -side left -fill y
                       
                # pack    $tb_frame.exit   $tb_frame.sp6  \
                #        $tb_frame.resize $tb_frame.scale_p $tb_frame.scale_m   \
                #
            pack    $tb_frame.exit      $tb_frame.sp6       \
                    $tb_frame.resize    $tb_frame.scale_p   $tb_frame.scale_m   \
                    $tb_frame.sp7       $tb_frame.cfg       \
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
            
                # ---     create and register any canvasCAD - canvas in rattleCAD::gui::notebookCanvas
            rattleCAD::gui::create_canvasCAD  $noteBook_top  cv_Custom02  "  Copy Reference "      A4  0.2  25  -bd 2  -bg white  -relief sunken
            rattleCAD::gui::create_canvasCAD  $noteBook_top  cv_Custom00  "  Base Concept   "      A4  0.2  25  -bd 2  -bg white  -relief sunken
            rattleCAD::gui::create_canvasCAD  $noteBook_top  cv_Custom10  "  Frame Details  "      A4  0.2  25  -bd 2  -bg white  -relief sunken
            rattleCAD::gui::create_canvasCAD  $noteBook_top  cv_Custom20  "  ChainStay Details  "  A2  1.0  25  -bd 2  -bg white  -relief sunken
            rattleCAD::gui::create_canvasCAD  $noteBook_top  cv_Custom30  "  Summary   "           A4  0.2  25  -bd 2  -bg white  -relief sunken
            rattleCAD::gui::create_canvasCAD  $noteBook_top  cv_Custom40  "  Frame Drafting  "     A4  0.2  25  -bd 2  -bg white  -relief sunken
            rattleCAD::gui::create_canvasCAD  $noteBook_top  cv_Custom50  "  Mockup  "             A4  0.2  25  -bd 2  -bg white  -relief sunken
            rattleCAD::gui::create_canvasCAD  $noteBook_top  cv_Custom60  "  Tube Miter  "         A3  1.0  25  -bd 2  -bg white  -relief sunken
            rattleCAD::gui::create_canvasCAD  $noteBook_top  cv_Custom70  "  Frame - Jig  "        A4  0.2  25  -bd 2  -bg white  -relief sunken
            
            $noteBook_top add   [frame $noteBook_top.components]     -text "... Components" 
            $noteBook_top add   [frame $noteBook_top.report]         -text "... info" 
            
            $noteBook_top hide  0 ; # hide per default: cv_Custom02  "  Copy Concept   "
            
                # ---     modify dimension precision in Frame Drafting ; updates current and default precision
            #rattleCAD::gui::cv_Custom40 setPrecision 2 force
                
                
                # ---     fill with Report Widgets
            rattleCAD::cfg_report::createReport     $noteBook_top.report
                # ---     fill with Library Widgets
            rattleCAD::comp_library::createLibrary $noteBook_top.components
            rattleCAD::comp_library::update_compList


                # ---     bind event to update Tab on selection
            bind $noteBook_top <<NotebookTabChanged>> {rattleCAD::gui::notebook_updateCanvas}

                # ---     bind event Control-Tab and Shift-Control-Tab
            ttk::notebook::enableTraversal $noteBook_top

                # ---     select and update following Tab
            # $noteBook_top select $noteBook_top.cv_Custom30
            # $noteBook_top select $noteBook_top.cv_Custom00
            # $noteBook_top select $noteBook_top.cv_Custom20
            
            $noteBook_top select $noteBook_top.cv_Custom30
            
                # ---     return
            return $noteBook_top
    }


    #-------------------------------------------------------------------------
        #  register notebookCanvas in notebook - Tabs   
        #
    proc create_canvasCAD {notebook varname title stageFormat stageScale stageBorder args} {
            # rattleCAD::gui::create_canvasCAD  $noteBook_top  cv_Custom30  "Dimension Summary"  A4  0.2 -bd 2  -bg white  -relief sunken
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
    proc exit_rattleCAD {{type {yesnocancel}} {exitMode {}}} {   
                
              set changeIndex [rattleCAD::update::changeList::get_changeIndex]
                
                puts "\n"
                puts "  ====== e x i t   r a t t l e C A D =============="
                puts ""
                puts "         ... file:       $::APPL_Config(PROJECT_File)"
                puts "           ... saved:    $::APPL_Config(PROJECT_Save)"
                puts "           ... modified: $changeIndex"
                puts "                     ... $::APPL_Config(canvasCAD_Update)"
                puts ""
                puts "        ... type:        $type"
                puts "        ... exitMode:    $exitMode"

          
              # puts "  $::APPL_Config(PROJECT_Save) < $::APPL_Config(canvasCAD_Update)"
              # if { $::APPL_Config(PROJECT_Save) < $::APPL_Config(canvasCAD_Update) } {}
            
            if { $changeIndex > 0 } {
                
                puts " ......... save File before exit"
                puts "        project save:   $::APPL_Config(PROJECT_Save)"
                puts "        project change: $::APPL_Config(canvasCAD_Update)"

                set decission [tk_messageBox  -type $type \
                                              -icon warning \
                                              -title   "exit rattleCAD" \
                                              -message "Save current Project before EXIT"]
                puts "        ... save Project: $decission\n"
                puts "\n"
                
                switch  -exact -- $decission {
                    {yes}     { 
                                # even if saved or not, because of handling of bind of <Destroy>
                                puts "        ... save current project\n"
                                rattleCAD::file::saveProject_xml }
                    {no}      {
                                # even if saved or not, because of handling of bind of <Destroy>
                                puts "        ... exit rattleCAD withoud saving current project\n"
                                set ::APPL_Config(PROJECT_Save) [clock milliseconds] 
                              }
                    {cancel}  {
                                # leef this control - go back to rattleCAD
                                puts "        ... exit rattleCAD canceled\n"
                                return
                              }
                    default   {}
                }
                
                puts "\n"
                puts "        ... check file save by date\n\n"
                puts "  ====== e x i t   r a t t l e C A D ============== END ==\n\n"
                exit
                
            } else {
            
                puts "\n"
                puts "        ... save current project not required\n\n"
                puts "  ====== e x i t   r a t t l e C A D ============== END ==\n\n"
                exit
                
            }
            
    }


    #-------------------------------------------------------------------------
        #  get current canvasCAD   
        #
    proc current_canvasCAD {} {
            variable noteBook_top        
            set current_cv [$noteBook_top select]
                # puts "        current canvasCAD: $current_cv"
            set varName "rattleCAD::gui::[lindex [split $current_cv .] end]"
                # puts "        -> $varName"
            return $varName
    }
    #-------------------------------------------------------------------------
        #  select specific canvasCAD tab   
        #
    proc select_canvasCAD {cv} {
            variable noteBook_top        
            
                # puts " ... select_canvasCAD $cv"
            
            set cvID    [format "rattleCAD::gui::%s" $cv]
            set cvPath  [$cvID getNodeAttr Canvas path]
            set noteBook   [winfo parent [winfo parent $cvPath]] 
                 puts "         $noteBook"
                 puts "            exists: [winfo exists [winfo parent $cvPath]]"
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
                cv_Custom02 -
                cv_Custom10 -
                cv_Custom20 -
                cv_Custom30 -
                cv_Custom40 -
                cv_Custom50 -
                cv_Custom60 -
                cv_Custom70 {
                        $noteBook_top select $noteBook_top.$varName
                        rattleCAD::cv_custom::update     rattleCAD::gui::$varName 
                        # rattleCAD::gui::notebook_refitCanvas
                    }
                cv_Component {
                        ::update
                        rattleCAD::gui::notebook_refitCanvas
                        rattleCAD::comp_library::updateCanvas
                    }
                __cv_Library {
                        ::update
                        rattleCAD::gui::notebook_refitCanvas
                        rattleCAD::config::updateCanvas
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
                      # puts "$index $varName -> $notebookCanvas($index) "
                    return $notebookCanvas($index)
                }
            }
    }
    #-------------------------------------------------------------------------
        #  get notebook id    
        #
     proc notebook_getTabInfo {varName} {
             variable noteBook_top       
               # puts "\n --------"
               # puts "[$noteBook_top tabs]"
             set i 0
             foreach index [$noteBook_top tabs] {
                 set tabWidget "$noteBook_top.$varName"
                 if {$index == $tabWidget} {
                     # puts "$index $varName -> $tabWidget"
                     return [list $i $index]
                 }
                 incr i
             }
             return {}
     }
    
    
    #-------------------------------------------------------------------------
       #  get notebook window    
       #
    proc notebook_getVarName {tabID} {
                # tabID:      [$noteBook_top select]
                #            .mainframe.frame.f2.nb.cv_Custom30
            variable notebookCanvas
            variable external_canvasCAD

                # -- rattleCAD::gui::notebookCanvas
            set cvID $tabID.cvCAD
            foreach varName [array names notebookCanvas] {
                    # puts "          -> $varName $notebookCanvas($varName) "
                if {$notebookCanvas($varName) == $cvID} {
                    return [namespace current]::$varName
                }
            }
                # -- rattleCAD::gui::external_canvasCAD
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
            # puts "<D>   APPL_Config(window_Size):    $::APPL_Config(window_Size)"
        set newSize [lindex [split [wm geometry .] +] 0]
        if {![string equal $newSize $::APPL_Config(window_Size)]} {
                set ::APPL_Config(window_Size) $newSize
                set ::APPL_Config(window_Update) [ clock milliseconds ]
                puts "     ... update WindowSize: $::APPL_Config(window_Update) / $::APPL_Config(window_Size)"
        }
    }


    #-------------------------------------------------------------------------
       #  update canvasCAD in current notebook-Tab  
       #
    proc notebook_updateCanvas {{mode {}}} {
            variable noteBook_top
            variable canvasUpdate
                    
            set currentTab              [$noteBook_top select]
            set varName                 [notebook_getVarName $currentTab]
            set varName                 [lindex [split $varName {::}] end]
            
            set updateDone              {no}

            
            if { [catch { set lastUpdate $canvasUpdate($varName) } msg] } {
                 set canvasUpdate($varName) [ expr $::APPL_Config(canvasCAD_Update) -1 ]
            }
            
            set timeStart     [clock milliseconds]
       
            
                # -- update stage content if parameters changed
                    # puts "\n    canvasUpdate($varName):  $canvasUpdate($varName)    vs.  $::APPL_Config(canvasCAD_Update)\n"
            puts "\n"
            puts "   -------------------------------"
			puts "    lib_gui::notebook_updateCanvas  "
            puts "       \$canvasUpdate($varName)"
			puts "          last:   $canvasUpdate($varName)  -> [clock format [expr $canvasUpdate($varName)/1000] -format {%Y.%m.%d / %H:%M:%S}]"
            puts "          new:    $::APPL_Config(canvasCAD_Update)  -> [clock format [expr $::APPL_Config(canvasCAD_Update)/1000] -format {%Y.%m.%d / %H:%M:%S}]"
            puts "       \$project::Project(modified) -> $project::Project(modified)\n"
            if { $mode == {} } {
                    if { $canvasUpdate($varName) < $::APPL_Config(canvasCAD_Update) } {
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
            if { $canvasUpdate($varName) < $::APPL_Config(window_Update) } {
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
        #  switch notebook-Tab  
        #
    proc notebook_switchTab {cvTab} {
        variable noteBook_top
          # puts ""
          # puts " ---------------"
          # puts " notebook_switchTab"
        set tabInfo [notebook_getTabInfo $cvTab]
        set tabID       [lindex $tabInfo 0]
        set tabWidget   [lindex $tabInfo 1]
        set tabState   [$noteBook_top tab  $tabID -state]
        
        if {$tabState == {hidden}} {
            $noteBook_top add    $tabWidget
            $noteBook_top select $tabID
        } else {
            $noteBook_top hide   $tabID
        }
        return
    }


    #-------------------------------------------------------------------------
       #  export canvasCAD from every notebook-Tab
       #
    proc export_Project { {type {html}}} {
            variable noteBook_top
            variable notebookCanvas     
            
                 # --- get currentTab
            set currentTab     [$noteBook_top select]
            set cv_Name        [notebook_getVarName $currentTab]           
              # set cv_ID          [lindex [string map {:: { }} $cv_Name] 1]
            set cv_ID          [lindex [string map {:: { }} $cv_Name] 2]
              # tk_messageBox -message " export_Project: $cv_Name / $cv_ID"
            puts "\n\n"
                  # puts "   export_Project::cv_Name: $cv_Name $cv_ID"
                  # tk_messageBox -message  "   notebook_exportSVG::cv_Name: $cv_Name"    
            switch -exact $type {
                html {   set exportDir  $::APPL_Config(EXPORT_HTML) }
                pdf  {   set exportDir  $::APPL_Config(EXPORT_PDF)}
                default {}
            }
                
                
                # --- export content to HTML
            puts "\n\n  ====== e x p o r t  P R O J E C T ===============\n"                         
            puts "      export project to -> $type \n"
            puts "      export_Project   $currentTab / $cv_Name / $cv_ID"
            puts "             currentTab-Parent  [winfo parent $currentTab]  "
            puts "             currentTab-Parent  [winfo name   $currentTab]  "
            puts "             canvasCAD Object   $cv_Name  "
            puts ""
            
                # --- cleanup export directory
            if { [catch {set contents [glob -directory $exportDir *]} fid] } {
                set contents {}
            }
    
                  # puts "Directory contents are:"
            puts ""
            foreach item $contents {
                puts "             ... cleanup $item"
                catch {file delete -force $item}
            }
            puts "\n"            
            
                # --- prepare export directory
            switch -exact $type {
                html {
                        set indexHTML [file join $::APPL_Config(EXPORT_HTML) index.html]
                        file copy -force [file join $::APPL_Config(CONFIG_Dir) html/index.html]     $::APPL_Config(EXPORT_HTML)
                        file copy -force [file join $::APPL_Config(CONFIG_Dir) html/style.css]      $::APPL_Config(EXPORT_HTML)
                        file copy -force [file join $::APPL_Config(CONFIG_Dir) html/rattleCAD.ico]  $::APPL_Config(EXPORT_HTML)
                              
                              # rattleCAD::file::saveProject_xml
                              # puts "    \$APPL_Config(PROJECT_File):         Template Road"
                              # puts "    \$APPL_Config(PROJECT_File):      -> $::APPL_Config(PROJECT_File)"
                              # puts "    \$APPL_Config(TemplateInit):      -> $::APPL_Config(TemplateInit)"
                              
                            # --- get project file 
                        if {[file exists $::APPL_Config(PROJECT_File)] == 1} {
                              # file exists
                            puts "             ... $::APPL_Config(PROJECT_File)"
                            set sourceFile  $::APPL_Config(PROJECT_File)
                        } else {
                              # file does not exists
                            puts "             ... $::APPL_Config(TemplateInit)"
                            set sourceFile  $::APPL_Config(TemplateInit)
                        } 

                        catch {file copy -force $sourceFile [file join $::APPL_Config(EXPORT_HTML) project.xml]}
                        
                            # --- loop through content
                              # puts "[lsort [array names notebookCanvas]]"
                        foreach cadCanv [lsort [array names notebookCanvas]] {
                              # puts "   -> $cadCanv"
                            select_canvasCAD $cadCanv
                            update
                            notebook_exportSVG $exportDir noOpen
                        }
                        select_canvasCAD $cv_ID 

                            # --- open index.html
                        puts "    ------------------------------------------------"
                        puts "      ... open $indexHTML "
                        
                        rattleCAD::file::open_localFile $indexHTML
                    }
                
                pdf {
                        foreach cadCanv [lsort [array names notebookCanvas]] {
                              # puts "   -> $cadCanv"
                            select_canvasCAD $cadCanv
                            set w            [$cadCanv getNodeAttr    Canvas    path]            
                              # puts "   ->    $w"
                            update
                            $w lower {__NB_Button__}        all
                            $w lower {__cvEdit__}           all
                            $w lower {__Select__SubMenue__} all
                            update
                            notebook_exportPS $exportDir noOpen
                            $w raise {__NB_Button__}        all
                            $w raise {__cvEdit__}           all
                            $w raise {__Select__SubMenue__} all
                            update
                        }
                        rattleCAD::file::create_summaryPDF $exportDir
                    }

                default {}
            }

        $noteBook_top select $currentTab
        
            return

    }

    #-------------------------------------------------------------------------
       #  export canvasCAD from current notebook-Tab as PostScript 
       #
    proc notebook_exportPS {printDir {postEvent {open}}} {
            variable noteBook_top

                # --- get currentTab
            set currentTab     [ $noteBook_top select ]
            set cv_Name        [ notebook_getVarName $currentTab]
            if { $cv_Name == {} } {
                    puts "   notebook_exportPS::cv_Name: $cv_Name"
                    return
            }

                # --- get stageScale
            set stageScale    [ $cv_Name  getNodeAttr  Stage    scale ]    
            set scaleFactor   [ expr round([ expr 1 / $stageScale ]) ]
                
                # --- get stageHeight
            set stageHeight   [ $cv_Name  getNodeAttr  Stage    height ]    

                # --- set timeStamp
            set timeString    [ format "timestamp: %s" [ clock format [clock seconds] -format {%Y.%m.%d %H:%M} ] ]
            set textPos       [ vectormath::scalePointList {0 0} [list 10 [expr $stageHeight - 10]] $scaleFactor ]
            set timeStamp     [ $cv_Name create draftText $textPos  -text $timeString -size 2.5 -anchor sw ]

                # --- set exportFile
            set stageTitle    [ $cv_Name  getNodeAttr  Stage  title ]
            set fileName      [ winfo name   $currentTab]___[ string map {{ } {_}} [ string trim $stageTitle ] ]
            set exportFile    [ file join $printDir ${fileName}.ps ]
            set exportFile    [ file normalize $exportFile]
                # set exportFile [ file join $printDir [winfo name   $currentTab].svg ]

                # --- export content to File
            puts "    ------------------------------------------------"
            puts "      export PS - Content to    $exportFile \n"
            puts "         notebook_exportPS      $currentTab "
            puts "             currentTab-Parent  [winfo name   $currentTab]  "
            puts "             currentTab-Parent  [winfo parent $currentTab]  "
            puts "             canvasCAD Object   [$cv_Name getNodeAttr    Canvas    path]"
            puts "                          ...   $cv_Name"
            
                # $cv_Name print $exportFile
            set exportFile [$cv_Name print $exportFile]
                
                # --- delete timeStamp
            catch [ $cv_Name delete $timeStamp ]

            if {$postEvent == {open}} {
                puts "\n"
                puts "    ------------------------------------------------"
                puts ""
                puts "      ... open $exportFile "
                
                rattleCAD::file::openFile_byExtension $exportFile 
            }
            puts "    ------------------------------------------------"
            puts "      ... open $exportFile "
                          
    }


    #-------------------------------------------------------------------------
       #  export canvasCAD from current notebook-Tab as Standard Vector Graphic
       #
    proc notebook_exportSVG {printDir {postEvent {open}}} {
            variable noteBook_top

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
            puts "         notebook_exportSVG     $currentTab "
            puts "             currentTab-Parent  [winfo name   $currentTab]  "
            puts "             currentTab-Parent  [winfo parent $currentTab]  "
            puts "             canvasCAD Object   [$cv_Name getNodeAttr    Canvas    path]"
            puts "                          ...   $cv_Name"
            
            set exportFile [$cv_Name exportSVG $exportFile]
            
            if {$postEvent == {open}} {
                puts "\n"
                puts "    ------------------------------------------------"
                puts ""
                puts "      ... open $exportFile "
                
                rattleCAD::file::open_localFile $exportFile
            }
            
                # rattleCAD::file::openFile_byExtension $exportFile
                # rattleCAD::file::openFile_byExtension $exportFile .htm
    }


    #-------------------------------------------------------------------------
       #  export canvasCAD from current notebook-Tab as SVG Graphic
       #
    proc notebook_exportDXF {printDir {postEvent {open}}} {
            variable noteBook_top

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
            puts "         notebook_exportDXF     $currentTab "
            puts "             currentTab-Parent  [winfo name   $currentTab]  "
            puts "             currentTab-Parent  [winfo parent $currentTab]  "
            puts "             canvasCAD Object   [$cv_Name getNodeAttr    Canvas    path]"
            puts "                          ...   $cv_Name"
            
            set exportFile [$cv_Name exportDXF $exportFile]
            
            if {$postEvent == {open}} {
                puts "\n"
                puts "    ------------------------------------------------"
                puts ""
                puts "      ... open $exportFile "
                
                rattleCAD::file::open_localFile $exportFile
            }            
              # rattleCAD::file::open_localFile $exportFile
              # rattleCAD::file::openFile_byExtension $exportFile .dxf
    }


    #-------------------------------------------------------------------------
       #  create a Button inside a canvas of notebookCanvas
       #
    proc notebook_createButton {nb_Canvas cv_ButtonList    {type {default}}} {
            
            puts "       notebook_createButton:  $cv_ButtonList"
            set cv_Name [lindex [split $nb_Canvas :] end]
            set cv      [rattleCAD::gui::notebook_getWidget  $cv_Name]
                # puts "  notebook_createButton $cv"
                # puts [$cv find withtag __NB_Button__]
            foreach cv_Window [$cv find withtag __NB_Button__] {
                #puts "   <D> $cv_Window"
                #set cv_Button [$cv itemcget $cv_Window -window]
                #puts "   <D> $cv_Button"
                #destroy     $cv_Window  ; # delete containing window           
                #$cv delete  $cv_Button  ; # delete button
            }
                # puts "   <D> [$cv find withtag __NB_Button__]"
            
            catch { destroy $cv.buttonFrame }
            frame   $cv.buttonFrame            
                # button  $cv.buttonFrame.bt -text test
                # pack $cv.buttonFrame.bt
            
            
            set idx 0
            foreach cv_Button $cv_ButtonList {
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
                                    catch { destroy $cv.buttonFrame.button_FormatScale }
                                    button  $cv.buttonFrame.button_FormatScale \
                                            -text $buttonText \
                                            -command [format {rattleCAD::gui::change_FormatScale %s %s %s} $cv $y_Position $type ]
                                    pack $cv.buttonFrame.button_FormatScale -fill x
                                }
                        TubingCheckAngles {
                                    # -- create a Button to execute tubing_checkAngles
                                    catch { destroy $cv.buttonFrame.button_TCA }
                                    button  $cv.buttonFrame.button_TCA \
                                            -text "check Frame Angles" \
                                            -command [format {rattleCAD::gui::tubing_checkAngles %s} $cv]                                
                                    pack $cv.buttonFrame.button_TCA         -fill x
                                }
                        ChainStayRendering {
                                    # -- create a Button to set ChainStayRendering
                                    catch { destroy $cv.buttonFrame.button_CSR }
                                    button  $cv.buttonFrame.button_CSR \
                                            -text "switch: straight/bent/off" \
                                            -command [format {rattleCAD::gui::rendering_ChainStay %s} $cv]                                
                                    pack $cv.buttonFrame.button_CSR         -fill x
                                }
                        changeFrameJigVariant {
                                    # -- create a Button to set FrameJigVersion
                                    catch { destroy $cv.buttonFrame.button_CSR }
                                    button  $cv.buttonFrame.button_CSR \
                                            -text "FrameJig" \
                                            -font $::APPL_Config(GUI_Font) \
                                            -command [format {rattleCAD::gui::change_FrameJig %s %s} $cv $y_Position ]                           
                                    pack $cv.buttonFrame.button_CSR         -fill x
                                }
                        Reference2Custom {
                                    # -- create a Button to execute geometry_reference2personal
                                    catch { destroy $cv.buttonFrame.button_R2C }
                                    button  $cv.buttonFrame.button_R2C \
                                            -text "copy settings to Base Geometry" \
                                            -command rattleCAD::gui::geometry_reference2personal                                
                                    pack $cv.buttonFrame.button_R2C         -fill x
                                }
                }
            }
            
            $cv create window 7 8 \
                -window $cv.buttonFrame \
                -anchor nw \
                -tags {__NB_Button__}
            pack append $cv.buttonFrame
            
    }            
            

    #-------------------------------------------------------------------------
       #  update Personal Geometry with parameters of Reference Geometry 
       #
    proc tubing_checkAngles {cv {type {default}}} {
        
            if {$rattleCAD::gui::checkAngles != {on}} {
                set rattleCAD::gui::checkAngles {on}
            } else {
                set rattleCAD::gui::checkAngles {off}         
            }
            rattleCAD::cv_custom::update [rattleCAD::gui::current_canvasCAD]
            return
    }


    #-------------------------------------------------------------------------
       #  create menue to change scale and size of Stage 
       #
    proc change_FormatScale {cv y {type {default}}}  {
    
            set cv_Name [lindex [split $cv .] end-1]
            
                # puts "  change_FormatScale:  cv: $cv"
                # puts "  change_FormatScale:  cv_Name: $cv_Name"
            
            set     rattleCAD::gui::stageFormat    A4
            set     rattleCAD::gui::stageScale        0.20        
            
            if {[ $cv find withtag __Select__SubMenue__ ] == {} } {
                    catch { set baseFrame [frame .f_subMenue_$cv_Name  -relief raised -border 1]
                            $cv create window 27 [expr $y+16] \
                                    -window $baseFrame \
                                    -anchor nw \
                                    -tags __Select__SubMenue__
                            frame $baseFrame.select
                            pack  $baseFrame.select
                          }
            } else {
                    $cv delete     __Select__SubMenue__
                    $cv dtag       __Select__SubMenue__
                    destroy        .f_subMenue_$cv_Name
                    #$cv.f_format destroy
                    return
            }
            
            
            set f_DIN_Format    [frame $baseFrame.select.din_Format]
                    radiobutton $f_DIN_Format.a4 -text A4 -value A4    -variable rattleCAD::gui::stageFormat  -command {puts $rattleCAD::gui::stageFormat}
                    radiobutton $f_DIN_Format.a3 -text A3 -value A3    -variable rattleCAD::gui::stageFormat  -command {puts $rattleCAD::gui::stageFormat}
                    radiobutton $f_DIN_Format.a2 -text A2 -value A2    -variable rattleCAD::gui::stageFormat  -command {puts $rattleCAD::gui::stageFormat}
                    radiobutton $f_DIN_Format.a1 -text A1 -value A1    -variable rattleCAD::gui::stageFormat  -command {puts $rattleCAD::gui::stageFormat}
                    radiobutton $f_DIN_Format.a0 -text A0 -value A0    -variable rattleCAD::gui::stageFormat  -command {puts $rattleCAD::gui::stageFormat}
                pack $f_DIN_Format.a4 \
                     $f_DIN_Format.a3 \
                     $f_DIN_Format.a2 \
                     $f_DIN_Format.a1 \
                     $f_DIN_Format.a0
            
            set f_Scale        [frame $baseFrame.select.scale]
            if {$type == {default}} {
                    radiobutton $f_Scale.s020 -text "1:5  "     -value 0.20 -anchor w     -variable rattleCAD::gui::stageScale -command {puts $rattleCAD::gui::stageScale}
                    radiobutton $f_Scale.s025 -text "1:4  "     -value 0.25 -anchor w     -variable rattleCAD::gui::stageScale -command {puts $rattleCAD::gui::stageScale}
                    radiobutton $f_Scale.s033 -text "1:3  "     -value 0.33 -anchor w     -variable rattleCAD::gui::stageScale -command {puts $rattleCAD::gui::stageScale}
                    radiobutton $f_Scale.s040 -text "1:2,5"     -value 0.40 -anchor w     -variable rattleCAD::gui::stageScale -command {puts $rattleCAD::gui::stageScale}
                    radiobutton $f_Scale.s050 -text "1:2  "     -value 0.50 -anchor w     -variable rattleCAD::gui::stageScale -command {puts $rattleCAD::gui::stageScale}
                    radiobutton $f_Scale.s100 -text "1:1  "     -value 1.00 -anchor w     -variable rattleCAD::gui::stageScale -command {puts $rattleCAD::gui::stageScale}
                pack $f_Scale.s020 \
                     $f_Scale.s025 \
                     $f_Scale.s040 \
                     $f_Scale.s050 \
                     $f_Scale.s100
            }
            
            pack $f_DIN_Format $f_Scale -side left
            
            button  $baseFrame.update \
                        -text "update" \
                        -command {rattleCAD::gui::notebook_formatCanvas  $rattleCAD::gui::stageFormat  $rattleCAD::gui::stageScale}
            pack    $baseFrame.update -expand yes -fill x            
    }


    #-------------------------------------------------------------------------
       #  create menue to change change FrameJig Version 
       #
    proc change_FrameJig {cv y}  {
            variable noteBook_top
            
            set cv_Name [lindex [split $cv .] end-1]
              # puts "   ... \$cv $cv"
              # puts "   ... \$cv_Name $cv_Name"
            
            if {[ $cv find withtag __Select__SubMenue__ ] == {} } {
                    catch { set baseFrame [frame .f_subMenue_$cv_Name  -relief raised -border 1]
                            $cv create window 27 [expr $y+16] \
                                    -window $baseFrame \
                                    -anchor nw \
                                    -tags __Select__SubMenue__
                            frame $baseFrame.select
                            pack  $baseFrame.select
                          }
            } else {
                    $cv delete     __Select__SubMenue__
                    $cv dtag       __Select__SubMenue__
                    destroy        .f_subMenue_$cv_Name
                    return
            }
            
            set f_FrameJig    [frame $baseFrame.select.jigType ]
            foreach jig $::APPL_Config(list_FrameJigTypes) {
                radiobutton     $f_FrameJig.$jig -text $jig -value $jig  -anchor w  -variable ::APPL_Config(FrameJigType)  -command {}
                pack $f_FrameJig.$jig -expand yes -fill x -side top
            }
            pack $f_FrameJig -side left
            
            button  $baseFrame.update \
                        -text "update" \
                        -command { rattleCAD::gui::updateFrameJig }

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
                ok        { frame_geometry_reference::export_parameter_2_geometry_custom  $::APPL_Config(root_ProjectDOM)
                            rattleCAD::gui::fill_canvasCAD cv_Custom00 
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
                    Fork      { set listDefinition    list://Rendering(Fork@SELECT_ForkType) }
                    ForkBlade { set listDefinition    list://Rendering(ForkBlade@SELECT_ForkBladeType) }
                    Brake     { set listDefinition    list://Rendering(Brake/Front@SELECT_BrakeType) }
                    
                    default   { set listDefinition {  list://Rendering(Fork@SELECT_ForkType)
                                                      list://Rendering(Brake/Front@SELECT_BrakeType)
                                                      list://Rendering(Brake/Rear@SELECT_BrakeType)
                                                      list://Rendering(BottleCage/SeatTube@SELECT_BottleCage)
                                                      list://Rendering(BottleCage/DownTube@SELECT_BottleCage)
                                                      list://Rendering(BottleCage/DownTube_Lower@SELECT_BottleCage) }
                              }
            } 
            rattleCAD::update::createEdit  5 100  $varName  $listDefinition  {Rendering Settings}                
            # rattleCAD::update::createEdit  5 80  $varName  rattleCAD::cv_custom::update  $listDefinition  {Rendering Settings}                
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
            set canvasUpdate($varName) [ expr $::APPL_Config(canvasCAD_Update) -1 ]
            notebook_updateCanvas force
            notebook_refitCanvas
            notebook_updateCanvas force
    }

    #-------------------------------------------------------------------------
       #  change type of Frame Jig dimensioning
       #
    proc updateFrameJig {} {
            variable noteBook_top
            
            set currentTab [$noteBook_top select]
            set varName    [notebook_getVarName $currentTab]
            set cv_Name    [notebook_getWidget  $varName]
            puts "   ... \$varName $varName"
            puts "   ... \$cv_Name $cv_Name"   

            set canvasUpdate($varName) [ expr $::APPL_Config(canvasCAD_Update) -1 ]
            rattleCAD::gui::notebook_updateCanvas force
    }
    
    #-------------------------------------------------------------------------
       #  load Template from File
       #
    proc load_Template {type} {
            variable canvasUpdate
            variable noteBook_top

            rattleCAD::file::openTemplate_xml $type
            
            switch -exact $type {
                Road { set ::APPL_Config(TemplateInit) $::APPL_Config(TemplateRoad_default) }
                MTB  { set ::APPL_Config(TemplateInit) $::APPL_Config(TemplateMTB_default) }
            }
              # puts "\n\  -> \$type:  $type"
              # puts "\n\  -> \$::APPL_Config(TemplateInit):  $::APPL_Config(TemplateInit)"
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
                                catch {rattleCAD::config::create . .cfg refresh}
                            }
                        }
                default {
                            puts "      ... open_configPanel $mode"
                            rattleCAD::config::create . .cfg
                        }
            }
    }


    proc global_kb_Binding {ab} {
            variable noteBook_top

            # puts "\n   -----> keyboard binding \n -------------"
            bind . <F1>     {rattleCAD::version_info::create  .v_info 1}
            bind . <F3>     {rattleCAD::gui::notebook_scaleCanvas  [expr 2.0/3]}
            bind . <F4>     {rattleCAD::gui::notebook_scaleCanvas  [expr 3.0/2]}
            bind . <F5>     {rattleCAD::gui::notebook_refitCanvas}
            bind . <F6>     {rattleCAD::gui::notebook_updateCanvas force}
            
            bind . <Key-Up>     {rattleCAD::gui::move_Canvas    0  50 }
            bind . <Key-Down>   {rattleCAD::gui::move_Canvas    0 -50 }
            bind . <Key-Left>   {rattleCAD::gui::move_Canvas   50   0 }
            bind . <Key-Right>  {rattleCAD::gui::move_Canvas  -50   0 }
            
            bind . <MouseWheel>         {rattleCAD::gui::bind_MouseWheel updown    %D}  ;# move up/down
            bind . <Shift-MouseWheel>   {rattleCAD::gui::bind_MouseWheel leftright %D}  ;# move left/right
            bind . <Control-MouseWheel> {rattleCAD::gui::bind_MouseWheel scale     %D}  ;# scale
            
            # bind . <Key-Tab>    {rattleCAD::gui::notebook_nextTab}
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

                # rattleCAD::update::createEdit
                #    creates window $cv.f_edit
                #    catch <MouseWheel> for $cv.f_edit
            set currentTab [$noteBook_top select]
            set varName    [notebook_getVarName $currentTab]
            
                # ----------------------------
                # exception for the report tab
                #    ... there is no canvas
                #
            switch -glob $currentTab {
                *\.report {
                        puts "  -- <E> -- $currentTab"
                        return
                    }
                default {}    
            } 
            
            
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
                            rattleCAD::gui::move_Canvas    0  [expr $scale * 40] 
                        }
                leftright {   if {$value > 0} {set scale 1.0} else {set scale -1.0}
                            rattleCAD::gui::move_Canvas    [expr $scale * 40]  0 
                        }
                scale {  if {$value > 0} {set scale 1.1} else {set scale 0.9}
                            rattleCAD::gui::notebook_scaleCanvas $scale
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

