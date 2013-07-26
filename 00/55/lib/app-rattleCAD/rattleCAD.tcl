 ##+##########################################################################
 #
 # package: rattleCAD    
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
 #    namespace:  rattleCAD
 # ---------------------------------------------------------------------------
 #
 # 

  package require   Tk            8.5
  package require   BWidget         
  package require   tdom
  
  package require   appUtil       0.14
  package require   bikeGeometry  0.22
  package require   canvasCAD     0.43
  package require   extSummary    0.4
  
      
  package provide   rattleCAD     3.4


                   
    # -- default Parameters  ----
    # source  [file join $APPL_Config(CONFIG_Dir) init_parameters.tcl]   
  
  ###########################################################################
  #
  #         V  -  A  -  R  -  I  -  A  -  B  -  L  -  E  -  S 
  #
  ###########################################################################
    
    array set APPL_Config { 
                        RELEASE_Version     {3.4}  
                        RELEASE_Revision    {tbd}
                        RELEASE_Date        {01. May. 2012}
                        
                        GUI_Font            {Arial 8}
                        VECTOR_Font         {}
                        Language            {english}
    
                        USER_InitString     {_init_Template}
                        WINDOW_Title        {}
                        FILE_List           {}

                        PROJECT_Name        {}
                        PROJECT_File        {}
                        PROJECT_Save        {0}
                        
                        TemplateType        {}
                        FrameJigType        {}

                        BASE_Dir            {}
                        ROOT_Dir            {}
                        CONFIG_Dir          {}
                        IMAGE_Dir           {}
                        TEST_Dir            {}
                        USER_Dir            {}
                        EXPORT_Dir          {}
                        EXPORT_PDF          {}
                        EXPORT_HTML         {}
                        
                        user_InitDOM        {}
                        root_InitDOM        {}
                        root_ProjectDOM     {}
                        
                        canvasCAD_Update    {0}
                        window_Size         {0}
                        window_Update       {0}
                        
                        list_FrameJigTypes  {}
                        list_TemplateTypes  {}
                        
                        list_ForkTypes      {}
                        list_BrakeTypes     {}
                        list_Binary_OnOff   {}
                        list_Rims           {}  
                     }   

    array set APPL_CompLocation {}

  

    
  ###########################################################################
  #
  #         F  -  U  -  N  -  C  -  T  -  I  -  O  -  N  -  S 
  #
  ###########################################################################

 
    #-------------------------------------------------------------------------
    	#  set initialze rattleCAD
    	#
    proc init_APPL_Config {baseDir} {
    
                # -- Version Info  ----------------------
            if {[file exists [file join $baseDir tclkit.inf]]} {
                # puts " customizing strings in executable"
                set fd [open [file join $baseDir tclkit.inf]]
                array set strinfo [read $fd]
                close $fd
            } else {
                set message {}
        	    append message "\n ... $::argv0"
        	    append message "\n ... $::APPL_Config(ROOT_Dir)"
        	    append message "\n ... $::APPL_Config(BASE_Dir)"
        
        	    tk_messageBox -title "tclkit.inf" -message $message
        		
        	    array set strinfo {
                      ProductVersion  {3.4.xx}
                      FileVersion     {??}
                      FileDate        {??. ???. 201?}
                }
            }
                # parray strinfo
    	    
        	    # -- Version Info  ----------------------
        	set ::APPL_Config(RELEASE_Version)  $strinfo(ProductVersion)    ;#{3.2}
        	set ::APPL_Config(RELEASE_Revision) $strinfo(FileVersion)       ;#{66}
        	set ::APPL_Config(RELEASE_Date)     $strinfo(FileDate)          ;#{18. Dec. 2011}
        	    
        	    
        	    
                    # -- Application Directories  -----------
        	set ::APPL_Config(BASE_Dir)         $baseDir
        	set ::APPL_Config(ROOT_Dir)         [file dirname $baseDir]
        	set ::APPL_Config(CONFIG_Dir)       [file join    $baseDir etc   ]
        	set ::APPL_Config(IMAGE_Dir)        [file join    $baseDir image ]
        	set ::APPL_Config(SAMPLE_Dir)       [file join    $baseDir sample]
        	set ::APPL_Config(TEST_Dir)         [file join    $baseDir _test]
        	set ::APPL_Config(USER_Dir)         [lib_file::check_user_dir rattleCAD]    
        	set ::APPL_Config(EXPORT_Dir)       [lib_file::check_user_dir rattleCAD/export]
        	set ::APPL_Config(EXPORT_HTML)      [lib_file::check_user_dir rattleCAD/html]
        	set ::APPL_Config(EXPORT_PDF)       [lib_file::check_user_dir rattleCAD/pdf]
    }
        
	
    #-------------------------------------------------------------------------
        #  set initialze rattleCAD
        #
    proc init_rattleCAD {BASE_Dir {startupProject {}}} {
	
            
		###########################################################################      
		#
		#                 B  -  A  -  S  -  E 
		#
		###########################################################################
	    
	    
    	    # -- Version Info   ----------------------	    
    	init_APPL_Config $BASE_Dir  

          
          
            # -- Version Info Summary  ---------------
        puts "  ----------------------------------------------"
        puts "  rattleCAD      $::APPL_Config(RELEASE_Version).$::APPL_Config(RELEASE_Revision)"
        puts "                             $::APPL_Config(RELEASE_Date)"
        puts "  ----------------------------------------------"
      
      
        # -- Tcl/Tk Runtime  --------------------
        puts "  Tcl/Tk:    [info patchlevel]"
        puts "  Exec:      [info nameofexecutable]"
        puts "  ----------------------------------------------"
        puts "    Tk:          [package require Tk]"
        puts "    BWidget:     [package require BWidget]"
        puts "    tdom:        [package require tdom]"
        puts "    rattleCAD:   [package require rattleCAD]"
        puts "    canvasCAD:   [package require canvasCAD]"
        puts "    extSummary:  [package require extSummary]"
        puts "  ----------------------------------------------"
        puts "    APPL_Config(ROOT_Dir)     $::APPL_Config(ROOT_Dir)"
        puts "    APPL_Config(BASE_Dir)     $::APPL_Config(BASE_Dir)"
        puts "    APPL_Config(CONFIG_Dir)   $::APPL_Config(CONFIG_Dir)"
        puts "    APPL_Config(IMAGE_Dir)    $::APPL_Config(IMAGE_Dir)"
        puts "    APPL_Config(USER_Dir)     $::APPL_Config(USER_Dir)"
        puts "    APPL_Config(EXPORT_Dir)   $::APPL_Config(EXPORT_Dir)"
        puts "    APPL_Config(EXPORT_HTML)  $::APPL_Config(EXPORT_HTML)"
        puts "    APPL_Config(EXPORT_PDF)   $::APPL_Config(EXPORT_PDF)"
        puts "  ----------------------------------------------"
        puts ""

            
            ###########################################################################
            #
            #                 C  -  H  -  E  -  C  -  K 
            #
            ###########################################################################
           
        check_BASE_Dir $::APPL_Config(BASE_Dir) $::APPL_Config(USER_Dir)
            
            
            
            ###########################################################################
            #
            #                 I  -  N  -  I  -  T                       - Configuration
            #
            ###########################################################################
          
          
            # -- init Parameters  ----
        set ::APPL_Config(root_InitDOM)  [ lib_file::get_XMLContent     [file join $::APPL_Config(CONFIG_Dir) rattleCAD_init.xml ] ]
        puts "     ... root_InitDOM      [file join $::APPL_Config(CONFIG_Dir) rattleCAD_init.xml]"
          
          
            # -- set bikeGeometry Fork Configuration      
        bikeGeometry::set_forkConfig [$::APPL_Config(root_InitDOM) selectNode /root/Fork]
  
          
            # -- initialize GUI ----------
        init_GUI_Settings
        
            
            # -- load template ----------
        puts "     ... TemplateType      $::APPL_Config(TemplateType)"
        puts "     ... TemplateInit      $::APPL_Config(TemplateInit)"
            
        
        set ::APPL_Config(root_ProjectDOM)    [lib_file::get_XMLContent     $::APPL_Config(TemplateInit)]
          
        proc __unused {} {
                # -- status messages --------
            puts "\n     APPL_Config(list_TemplateTypes)"
            foreach entry $::APPL_Config(list_TemplateTypes) {
                puts "        -> $entry"
            }
              
            puts "\n     APPL_Config(list_FrameJigTypes)"
            foreach entry $::APPL_Config(list_FrameJigTypes) {
                puts "        -> $entry"
            }
              
            puts "\n     APPL_Config(list_ForkTypes)"
            foreach entry $::APPL_Config(list_ForkTypes) {
                puts "        -> $entry"
            }
              
            puts "\n     APPL_Config(list_BrakeTypes)"
            foreach entry $::APPL_Config(list_BrakeTypes) {
                puts "        -> $entry"
            }
            
            puts "\n     APPL_Config(list_BottleCage)"
            foreach entry $::APPL_Config(list_BottleCage) {
                puts "        -> $entry"
            }
            
            puts "\n     APPL_Config(list_Rims)"
            foreach entry $::APPL_Config(list_Rims) {
                puts "        -> $entry"
            }
        }       
	    
        # puts "\n     APPL_CompLocation"
        foreach index [array names APPL_CompLocation] {
            puts [format "        -> %-42s %s" $index    $APPL_CompLocation($index)]
        } 

          
          
          
            ###########################################################################
            #
            #                 S  -  T  -  Y  -  L  -  E 
            #
            ###########################################################################
          
            # ttk::style configure TCombobox -padding 0
            # ttk::style theme use default
        ttk::style configure TCombobox -padding 0
        # -- set standard font ------------
        option add *font $::APPL_Config(GUI_Font)
        
        lib_gui::binding_copyClass      Spinbox mySpinbox
        lib_gui::binding_removeOnly     mySpinbox [list <Clear>]
            # lib_gui::binding_reportBindings Text
            # lib_gui::binding_reportBindings mySpinbox
        
          
            
            ###########################################################################
            #
            #                 M  -  A  -  I  -  N 
            #
            ###########################################################################
          
        puts "\n\n ====== M A I N ============================ \n\n"
          
          
          
          
            ###########################################################################
            #
            #                 I  -  N  -  T  -  R  -  O
            #
            ###########################################################################
          
          
        create_intro  .intro  
          
          
          
          
            ###########################################################################
            #
            #                 W  -  I  -  N  -  D  -  O  -  W
            #
            ###########################################################################
          
          
        
            # ---     create iconBitmap  -----
            # puts " \$tcl_platform(os)  $tcl_platform(os) $tcl_platform(platform)"    
        if {$::tcl_platform(platform) == {windows}} {
            wm iconbitmap . [file join $::APPL_Config(BASE_Dir) tclkit.ico]      
        } else {
            wm iconphoto  . [image create photo .ico1 -format gif -file [file join $::APPL_Config(BASE_Dir)  icon16.gif] ]
        } 
            
            
             # ---     create Mainframe  -----
        set    mainframe  [ lib_gui::create_MainFrame ]
            pack $mainframe  -fill both  -expand yes  -side top 
        set    indicator  [$mainframe addindicator -textvariable "::APPL_Config(PROJECT_Name)"  -anchor w]
            $indicator  configure -relief flat
        set frame         [$mainframe getframe]
          
          
            # ---     Button-bar frame  --------
        set bb_frame [ frame $frame.f1  -relief sunken        -bd 1  ]
            pack  $bb_frame  -padx 0  -pady 3  -expand no   -fill x
        lib_gui::create_ButtonBar $bb_frame 
          
        
            # ---     notebook frame  -------
        set nb_frame [ frame $frame.f2  -relief sunken        -bd 1  ]
            pack  $nb_frame  -padx 0  -pady 0  -expand yes  -fill both
            
            # ---     notebook  -------------
        lib_gui::create_Notebook $nb_frame
          
        
        
            # --------------------------------------------
            #    create project Object
        bikeGeometry::set_newProject $::APPL_Config(root_ProjectDOM)
          
          
            # --------------------------------------------
            #    set APPL_Config(PROJECT_Name)        
        set ::APPL_Config(PROJECT_Name)           "Template $::APPL_Config(TemplateType)"
        set ::APPL_Config(PROJECT_File)           "Template $::APPL_Config(TemplateType)"
        set ::APPL_Config(PROJECT_Save)           [clock milliseconds]
          
          
            # --------------------------------------------
            #    check startup parameters
        if {$startupProject != {}} {
              # set startupProject  [lindex $argv 0]
            puts "\n"
            puts " ====== startup   F I L E ========================"
            puts "        ... [file normalize $startupProject]\n"
            lib_file::openProject_xml $startupProject    [file tail $startupProject] 
        }
        
          
          
            # --------------------------------------------
            #    finalize
             
        update 
        wm minsize . [winfo width  .]   [winfo height  .]
           
            # -- keyboard bindings -----------------------
        lib_gui::global_kb_Binding ab
        
             # -- window binding -----------------------
        bind . <Configure> [list lib_gui::check_windowSize]
        bind . <Destroy> {
            # http://www.tek-tips.com/viewthread.cfm?qid=339303
            # Test if the toplevel (in this case ".")
            # received the event.
              # puts "         check: bind . <DESTROY> %W"
            if {[string equal %W "."]} {
               lib_gui::exit_rattleCAD yesno bind_Destroy
            }
        } 
          
          
            # -- window title ----------------------------
        set_window_title                 $::APPL_Config(PROJECT_Name)
            
            # -- open config panel -----------------------
        # lib_config::create . .cfg
        
            # -- status message -----------
          # appUtil::appDebug p
          
            # -- Version Info Summary  ---------------
        puts "\n"
        puts "  ----------------------------------------------"
        puts "  rattleCAD      $::APPL_Config(RELEASE_Version).$::APPL_Config(RELEASE_Revision)"
        puts "                             $::APPL_Config(RELEASE_Date)"
        puts "  ----------------------------------------------\n"
            
          
          
    }


    #-------------------------------------------------------------------------
       #  load settings from etc/config_initValues.xml
       #
    proc init_GUI_Settings {} {
        
            variable APPL_Config
            set root_InitDOM     $APPL_Config(root_InitDOM)
            set user_InitDOM    {}
            
            
                # --- fill ICON - Array
                #
            foreach child [ [$root_InitDOM selectNodes /root/lib_gui/images] childNodes] {            
                    # puts [ $child asXML ]
                set name    [ $child getAttribute {name} ]
                set source    [ $child getAttribute {src} ]
                    # puts "   $name  $source"
                set lib_gui::iconArray($name) [ image create photo -file $APPL_Config(IMAGE_Dir)/$source ]
            }
            set ::cfg_panel [image create photo -file $APPL_Config(IMAGE_Dir)/cfg_panel.gif]


                # --- fill CANVAS - Array
                #
            set node    [ $root_InitDOM selectNodes /root/lib_gui/geometry/canvas ]
            set lib_gui::canvasGeometry(width)     [ $node getAttribute {width} ]
            set lib_gui::canvasGeometry(height)    [ $node getAttribute {height} ]    
        
                
                # --- get TemplateFile - Names
                #
            set node    [ $root_InitDOM selectNodes /root/Template/Road ]
            set APPL_Config(TemplateRoad_default)  [file join $APPL_Config(CONFIG_Dir) [$node asText] ]
            set node    [ $root_InitDOM selectNodes /root/Template/MTB ]
            set APPL_Config(TemplateMTB_default)   [file join $APPL_Config(CONFIG_Dir) [$node asText] ]
            
            
                # --- get Template - Type to load
                #
            set node    [ $root_InitDOM selectNodes /root/Startup/TemplateFile ]
            set APPL_Config(TemplateType) [$node asText]
        
        
                # --- get FrameJig - Type to load
                #
            set node    [ $root_InitDOM selectNodes /root/Startup/FrameJigType ]
            set APPL_Config(FrameJigType) [$node asText]
            
            
                # -- check user settings in $::APPL_Config(USER_Dir)/rattleCAD_init.xml  ----
                #
            read_userInit
                
                
                # --- get Template - File to load
                #
            set APPL_Config(TemplateInit) [lib_file::getTemplateFile   $APPL_Config(TemplateType)]
                
                
                # --- fill ListBox Values   list_TemplateTypes
                #
            set APPL_Config(list_TemplateTypes) {}
            set node_TemplateTypes [ $root_InitDOM selectNodes /root/Options/TemplateType ]
            foreach childNode [ $node_TemplateTypes childNodes ] {
                if {[$childNode nodeType] == {ELEMENT_NODE}} {
                    if {[string index [$childNode nodeName] 0 ] == {_}} continue
                    lappend APPL_Config(list_TemplateTypes)  [$childNode nodeName]
                }
            }


                # --- fill ListBox Values   list_FrameJigTypes
                #
            set APPL_Config(list_FrameJigTypes) {}
            set node_FrameJigTypes [ $root_InitDOM selectNodes /root/Options/FrameJigType ]
            foreach childNode [ $node_FrameJigTypes childNodes ] {
                if {[$childNode nodeType] == {ELEMENT_NODE}} {
                    if {[string index [$childNode nodeName] 0 ] == {_}} continue
                    lappend APPL_Config(list_FrameJigTypes)  [$childNode nodeName]
                }
            }
    
    
                # --- fill ListBox Values   list_Rims
                #
            set APPL_Config(list_Rims) {}
            set node_Rims [ $root_InitDOM selectNodes /root/Options/Rim ]
            foreach childNode [ $node_Rims childNodes ] {
                if {[$childNode nodeType] == {ELEMENT_NODE}} {
                        set value_01 [$childNode getAttribute inch     {}]
                        set value_02 [$childNode getAttribute metric   {}]
                        set value_03 [$childNode getAttribute standard {}]
                        if {$value_01 == {}} {
                            set value {-----------------}
                        } else {
                            set value [format "%s ; %s %s" $value_02 $value_01 $value_03]
                        }
                    lappend APPL_Config(list_Rims)  $value
                }
            }


                # --- fill ListBox Values   list_ForkTypes
                #
            set APPL_Config(list_ForkTypes) {}
            set node_ForkTypes [ $root_InitDOM selectNodes /root/Fork ]
            foreach childNode [ $node_ForkTypes childNodes ] {
                if {[$childNode nodeType] == {ELEMENT_NODE}} {
                    if {[string index [$childNode nodeName] 0 ] == {_}} continue
                    lappend APPL_Config(list_ForkTypes)  [$childNode nodeName]
                }
            }
    
    
                # --- fill ListBox Values   list_ForkBladeTypes
                #
            set APPL_Config(list_ForkBladeTypes) {}
            set node_ForkBladeTypes [ $root_InitDOM selectNodes /root/Options/ForkBlade ]
            foreach childNode [ $node_ForkBladeTypes childNodes ] {
                if {[$childNode nodeType] == {ELEMENT_NODE}} {
                    if {[string index [$childNode nodeName] 0 ] == {_}} continue
                    lappend APPL_Config(list_ForkBladeTypes)  [$childNode nodeName]
                }
            }


                # --- fill ListBox Values   list_DropOutDirections
                #
            set APPL_Config(list_DropOutDirections) {}
            set node_DropOutDirections [ $root_InitDOM selectNodes /root/Options/DropOutDirection ]
            foreach childNode [ $node_DropOutDirections childNodes ] {
                if {[$childNode nodeType] == {ELEMENT_NODE}} {
                        # puts "  childNode ->   [$childNode nodeName]  "
                    lappend APPL_Config(list_DropOutDirections)  [$childNode nodeName]
                }
            }
    
                
                # --- fill ListBox Values   list_DropOutPositions
                #
            set APPL_Config(list_DropOutPositions) {}
            set node_DropOutPositions [ $root_InitDOM selectNodes /root/Options/DropOutPosition ]
            foreach childNode [ $node_DropOutPositions childNodes ] {
                if {[$childNode nodeType] == {ELEMENT_NODE}} {
                        # puts "  childNode ->   [$childNode nodeName]  "
                    lappend APPL_Config(list_DropOutPositions)  [$childNode nodeName]
                }
            }
    
                
                # --- fill ListBox Values   list_ChainStay
                #
            set APPL_Config(list_ChainStay) {}
            set node_BrakeTypes [ $root_InitDOM selectNodes /root/Options/ChainStay ]
            foreach childNode [ $node_BrakeTypes childNodes ] {
                if {[$childNode nodeType] == {ELEMENT_NODE}} {
                        # puts "  childNode ->   [$childNode nodeName]  "
                    lappend APPL_Config(list_ChainStay)  [$childNode nodeName]
                }
            }

            
                # --- fill ListBox Values   list_BrakeTypes
                #
            set APPL_Config(list_BrakeTypes) {}
            set node_BrakeTypes [ $root_InitDOM selectNodes /root/Options/Brake ]
            foreach childNode [ $node_BrakeTypes childNodes ] {
                if {[$childNode nodeType] == {ELEMENT_NODE}} {
                        # puts "  childNode ->   [$childNode nodeName]  "
                    lappend APPL_Config(list_BrakeTypes)  [$childNode nodeName]
                }
            }
            
                # --- fill ListBox Values   list_BottleCage
                #
            set APPL_Config(list_BottleCage) {}
            set node_BottleCage [ $root_InitDOM selectNodes /root/Options/BottleCage ]
            foreach childNode [ $node_BottleCage childNodes ] {
                if {[$childNode nodeType] == {ELEMENT_NODE}} {
                        # puts "  childNode ->   [$childNode nodeName]  "
                    lappend APPL_Config(list_BottleCage)  [$childNode nodeName]
                }
            }
            
                # --- fill ListBox Values   list_Binary_OnOff
                #
            set APPL_Config(list_Binary_OnOff) {}
            set node_Binary_OnOff [ $root_InitDOM selectNodes /root/Options/Binary_OnOff ]
            foreach childNode [ $node_Binary_OnOff childNodes ] {
                if {[$childNode nodeType] == {ELEMENT_NODE}} {
                        # puts "  childNode ->   [$childNode nodeName]  "
                    lappend APPL_Config(list_Binary_OnOff)  [$childNode nodeName]
                }
            }
        
                # --- fill ListBox Values   APPL_CompLocation
                #
            array unset ::APPL_CompLocation 
            set node_Locations [ $root_InitDOM selectNodes /root/Options/ComponentLocation ]
            foreach childNode [ $node_Locations childNodes ] {
                if {[$childNode nodeType] == {ELEMENT_NODE}} {
                        set key     [$childNode getAttribute key    {}]
                        set dir       [$childNode getAttribute dir    {}]
                    # puts "  childNode ->   [$childNode nodeName]   $xpath  $dir "
                    set ::APPL_CompLocation($key) $dir
                }
            }
            
    }

    
    #-------------------------------------------------------------------------
        # check user settings in $::APPL_Config(USER_Dir)/rattleCAD_init.xml
        #            
    proc read_userInit {} {    
        set fileName    [file join $::APPL_Config(USER_Dir) _rattleCAD.init ]
        if {[file exists $fileName ]} {
              set ::APPL_Config(user_InitDOM)  [ lib_file::get_XMLContent     $fileName ]
              puts ""
              puts "     ... user_InitDOM      $fileName"
                # puts "[$::APPL_Config(user_InitDOM) asXML]"
              catch {set ::APPL_Config(TemplateType) [[$::APPL_Config(user_InitDOM) selectNodes /root/TemplateFile/text()] asXML]}
              catch {set ::APPL_Config(FrameJigType) [[$::APPL_Config(user_InitDOM) selectNodes /root/FrameJigType/text()] asXML]}
              catch {set ::APPL_Config(GUI_Font)     [[$::APPL_Config(user_InitDOM) selectNodes /root/GUI_Font/text()]     asXML]}
              
              puts "        ->\$::APPL_Config(TemplateType) $::APPL_Config(TemplateType)"
              puts "        ->\$::APPL_Config(FrameJigType) $::APPL_Config(FrameJigType)"
              puts "        ->\$::APPL_Config(GUI_Font)     $::APPL_Config(GUI_Font)"
              puts ""
        } else {
              set    fp [open $fileName w]
              puts  $fp {<?xml version="1.0" encoding="UTF-8" ?>}
              puts  $fp {<root>}
              puts  $fp "    <GUI_Font>$::APPL_Config(GUI_Font)</GUI_Font>"
              puts  $fp {</root>}
              close $fp
              puts ""
              puts "     ... user_InitDOM      $fileName"
              puts "         ------------------------"
              puts "           ... write:"   
              puts "                       $fileName"
              puts "                   ... done"
              
              read_userInit
        }
    }    
    
    
    #-------------------------------------------------------------------------
       #  startup intro image
       #
    proc create_intro {w {type toplevel} {cv_border 0} } {

        variable APPL_Config
        
        puts "\n"
        puts "  create_intro: \$APPL_Config(IMAGE_Dir)  $APPL_Config(IMAGE_Dir)"

        
    proc intro_content {w cv_border} {
      
            global APPL_Config

            set start_image     [image create  photo  -file $APPL_Config(IMAGE_Dir)/start_image.gif ]
            set  start_image_w  [image width   $start_image]
            set  start_image_h  [image height  $start_image]
      
            puts "      create_intro: \$start_image:  $start_image  -> $start_image_w  $start_image_h \n"

            canvas $w.cv    -width  $start_image_w \
                            -height $start_image_h \
                            -bd     0 \
                            -bg     gray 
                         
            pack   $w.cv   -fill both  -expand yes -padx $cv_border -pady $cv_border 
      
            $w.cv create image  [expr 0.5*$start_image_w] \
                                [expr 0.5*$start_image_h] \
                             -image $start_image
            
            set x [expr 0.5*$start_image_w]
            set y [expr 0.5*$start_image_h]
      
             # $w.cv create text  [expr $x+ 65]  [expr $y+155]  -font "Swiss 18"  -text "Version"                  -fill white
             # $w.cv create text  [expr $x+155]  [expr $y+155]  -font "Swiss 18"  -text "$APPL_Config(RELEASE_Version)"  -fill white 
             # $w.cv create text  [expr $x+210]  [expr $y+156]  -font "Swiss 14"  -text "$APPL_Config(RELEASE_Revision)"  -fill white 
            $w.cv create text  [expr $x+155]  [expr $y+150]  -font "Swiss 12"  -text "Version: $APPL_Config(RELEASE_Version) - $APPL_Config(RELEASE_Revision)"  -fill white -justify left
            #$w.cv create text  [expr $x+150]  [expr $y+156]  -font "Swiss 14"  -text "$APPL_Config(RELEASE_Version) - $APPL_Config(RELEASE_Revision)"  -fill white 
      
                ;# --- beautify --- but i dont know the reason, why to center manually
            $w.cv move   all   1 1            
            return $w.cv
        }


        if { $type != "toplevel" } {        
            return [intro_content $w $cv_border]
        }

        toplevel $w  -bd 0

        wm withdraw           $w  
        wm overrideredirect $w 1
        
        switch $::tcl_platform(platform) {
            "windows" { wm attributes  $w -topmost 1 }
        }

        intro_content $w $cv_border
        
        BWidget::place $w 0 0 center
        wm deiconify $w
        
        bind $w  <ButtonPress> { destroy .intro }

        return
    }


    #-------------------------------------------------------------------------
       #  set Window Title
       #
    proc set_window_title { {filename {}} } {
      
            # appDebug  p     
        global APPL_Config
      
        set  prj_name  [file tail $filename]

        set  APPL_Config(WINDOW_Title)  "rattleCAD  $APPL_Config(RELEASE_Version).$APPL_Config(RELEASE_Revision) - $prj_name"
        set  APPL_Config(PROJECT_Name)  "$prj_name"
        
            # appDebug  t  "   $filename " 1      
        wm title . $APPL_Config(WINDOW_Title)
    }


    #-------------------------------------------------------------------------
       #  check BASE_Dir
       #
    proc check_BASE_Dir {BASE_Dir USER_Dir} {
        if {$BASE_Dir eq $USER_Dir} {
            set     message "Dear User!\n"
            append  message "\n  ...  since rattleCAD Version 3.2.78.03"
            append  message "\n        there is a new definition of the user-Directory."
            append  message "\n"
            append  message "\n  ... your new user-Directory is defined as:"
            append  message "\n        $USER_Dir"
            append  message "\n"
            append  message "\n  ... please install rattleCAD in an other Directory"
            append  message "\n"
            append  message "\n    e.g.:\n"
            append  message "\n         \[Windows\] C:\\Program Files\\rattleCAD\\"
            append  message "\n                                     .\\3.2.78.03"
            append  message "\n                                     .\\rattleCAD.tcl"
            append  message "\n"
            append  message "\n         \[Linux\]   /opt/rattleCAD/"
            append  message "\n                                     ./3.2.78.03"
            append  message "\n                                     ./rattleCAD.tcl"
            append  message "\n"
            append  message "\n                            your rattleCAD!"

            tk_messageBox -icon info -message $message
            exit
        }           
    }


     #-------------------------------------------------------------------------
       #  debug_out
       #   
    proc debug_out { msg {args} } {
        appDebug t $msg $args
    }    
    