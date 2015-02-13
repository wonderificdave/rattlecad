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
					RELEASE_Date        {04. May. 2014}
					
					GUI_Font            {Helvetica 12}
					VECTOR_Font         {}
					Language            {english}

					USER_InitString     {_init_Template}
					WINDOW_Title        {}
					FILE_List           {}

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
					
				}   
                
				  # root_ProjectDOM     {}
				  # canvasCAD_Update    {0}
				  # window_Size         {0}
				  # window_Update       {0}

					 
    array set APPL_CompLocation {}

  
    namespace eval rattleCAD {}

 
 
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
          
              #
          rattleCAD::control::setSession  rattleCADVersion  "$strinfo(ProductVersion).$strinfo(FileVersion)"
              #
              
              
              # -- Application Directories  -----------
          set ::APPL_Config(BASE_Dir)         $baseDir
          set ::APPL_Config(ROOT_Dir)         [file dirname $baseDir]
          set ::APPL_Config(CONFIG_Dir)       [file join    $baseDir etc   ]
          set ::APPL_Config(IMAGE_Dir)        [file join    $baseDir image ]
          set ::APPL_Config(SAMPLE_Dir)       [file join    $baseDir sample]
          set ::APPL_Config(TEST_Dir)         [file join    $baseDir _test]
          set ::APPL_Config(COMPONENT_Dir)    [rattleCAD::model::get_ComponentDir]    
          set ::APPL_Config(USER_Dir)         [rattleCAD::model::file::check_user_dir rattleCAD]    
          set ::APPL_Config(EXPORT_Dir)       [rattleCAD::model::file::check_user_dir rattleCAD/export]
          set ::APPL_Config(EXPORT_HTML)      [rattleCAD::model::file::check_user_dir rattleCAD/html]
          set ::APPL_Config(EXPORT_PDF)       [rattleCAD::model::file::check_user_dir rattleCAD/pdf]
          set ::APPL_Config(EXPORT_FEA)       [rattleCAD::model::file::check_user_dir rattleCAD/analysis]
          set ::APPL_Config(EXPORT_SCAD)      [rattleCAD::model::file::check_user_dir rattleCAD/mockup3D]
          set ::APPL_Config(TEMPLATE_Dir)     [rattleCAD::model::file::check_user_dir rattleCAD/_template/rattleCAD]
                     
                     
              # -- Application - Logging  -----------
          set ::APPL_Config(LogFile)          [open [file join $::APPL_Config(USER_Dir) _logFile.txt] w]
          
                         
              # -- MainFrame - Indicator  -----------
          set ::APPL_Config(MainFrameInd_Project)  {}
          set ::APPL_Config(MainFrameInd_Status)   {}

          
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
        puts "    Tk:            [package require Tk]"
        puts "    BWidget:       [package require BWidget]"
        puts "    tdom:          [package require tdom]"
        puts "    rattleCAD:     [package require rattleCAD]"
        puts "    bikeGeometry:  [package require bikeGeometry]"
        puts "    canvasCAD:     [package require canvasCAD]"
        puts "    vectorMath:    [package require vectormath]"
        puts "    osEnv:         [package require osEnv]"
        puts "    appUtil:       [package require appUtil]"
        puts "    extSummary:    [package require extSummary]"
        catch  {
            puts "    registry:      [package require registry 1.1]"
        }
        catch  {
            puts "    registry:      [package require rattleCAD_AddOn]"
        }
        
        puts "  ----------------------------------------------"
        puts "    APPL_Config(ROOT_Dir)         $::APPL_Config(ROOT_Dir)"
        puts "    APPL_Config(BASE_Dir)         $::APPL_Config(BASE_Dir)"
        puts "    APPL_Config(CONFIG_Dir)       $::APPL_Config(CONFIG_Dir)"
        puts "    APPL_Config(IMAGE_Dir)        $::APPL_Config(IMAGE_Dir)"
        puts "    APPL_Config(USER_Dir)         $::APPL_Config(USER_Dir)"
        puts "    APPL_Config(EXPORT_Dir)       $::APPL_Config(EXPORT_Dir)"
        puts "    APPL_Config(COMPONENT_Dir)    $::APPL_Config(COMPONENT_Dir)"
        puts "    APPL_Config(EXPORT_HTML)      $::APPL_Config(EXPORT_HTML)"
        puts "    APPL_Config(EXPORT_PDF)       $::APPL_Config(EXPORT_PDF)"
        
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
        set ::APPL_Config(root_InitDOM)  [ rattleCAD::model::file::get_XMLContent     [file join $::APPL_Config(CONFIG_Dir) rattleCAD_init.xml ] ]
        puts "     ... root_InitDOM      [file join $::APPL_Config(CONFIG_Dir) rattleCAD_init.xml]"

          
            
            # -- User Components Directories  --------
            #        -> Options/ComponentLocation
        init_UserCompDirectories [$::APPL_Config(root_InitDOM) selectNode /root/Options/ComponentLocation]

        
		    # users local Samples 
		check_templateDirecty

            
            # -- initialize OS ----------
        init_OS_Settings  
          

            # -- initialize GUI ----------
        switch $::tcl_platform(platform) {
                "macintosh" { set ::APPL_Config(GUI_Font)  {Helvetica 10} }
                "windows"   { set ::APPL_Config(GUI_Font)  $::APPL_Config(GUI_Font) }
        }   
        init_GUI_Settings

        
            
            # -- load template ----------
        puts "     ... TemplateType      $::APPL_Config(TemplateType)"
        puts "     ... TemplateInit      $::APPL_Config(TemplateInit)"
            
        
        set projectDOM    [rattleCAD::model::file::get_XMLContent     $::APPL_Config(TemplateInit)]
      
	    
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
            #
            
        
        rattleCAD::view::gui::binding_copyClass      Spinbox mySpinbox
        rattleCAD::view::gui::binding_removeOnly     mySpinbox [list <Clear>]
            # rattleCAD::view::gui::binding_reportBindings Text
            # rattleCAD::view::gui::binding_reportBindings mySpinbox
        
          
            
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
            #
        set   ::APPL_Config(MainFrame)  [rattleCAD::view::gui::create_MainFrame]
              pack $::APPL_Config(MainFrame)  -fill both  -expand yes  -side top 
            
            # ---     create Indicator  -----
        $::APPL_Config(MainFrame) addindicator -textvariable "::APPL_Config(MainFrameInd_Project)"  -anchor e  -width 90
            # $::APPL_Config(MainFrame) addindicator -text "undoStack:"                                   -anchor e  -width 12
        $::APPL_Config(MainFrame) addindicator -textvariable "::APPL_Config(MainFrameInd_Status)"   -anchor e  -width 20
            [$::APPL_Config(MainFrame) getindicator 0]  configure -relief flat
            [$::APPL_Config(MainFrame) getindicator 1]  configure -relief flat
            # [$::APPL_Config(MainFrame) getindicator 2]  configure -relief flat


            # ---     get MainFrame  --------
        set    frame      [$::APPL_Config(MainFrame) getframe]


            # ---     Button-bar frame  -----
        set bb_frame [ frame $frame.f1  -relief sunken        -bd 1  ]
            pack  $bb_frame  -padx 0  -pady 3  -expand no   -fill x
        rattleCAD::view::gui::create_ButtonBar $bb_frame 

            # ---     handle existance rattleCAD Addon
        rattleCAD::view::gui::append_rattleCAD_AddOn
        
            # ---     notebook frame  -------
        set nb_frame [ frame $frame.f2  -relief sunken        -bd 1  ]
            pack  $nb_frame  -padx 0  -pady 0  -expand yes  -fill both
            
            # ---     notebook  -------------
        rattleCAD::view::gui::create_Notebook $nb_frame
            #
        
        
            # --------------------------------------------
            #    create project Object
        rattleCAD::control::newProject $projectDOM
		    # 
          
          
            # --------------------------------------------
            #    set APPL_Config(PROJECT_Name)
		rattleCAD::control::setSession  projectFile       "Template $::APPL_Config(TemplateType)"
		rattleCAD::control::setSession  projectName       "Template $::APPL_Config(TemplateType)"
		rattleCAD::control::setSession  projectSave       [clock milliseconds]
			#
          
            # --------------------------------------------
            #    check startup parameters
        if {$startupProject != {}} {
              # set startupProject  [lindex $argv 0]
            puts "\n"
            puts " ====== startup   F I L E ========================"
            puts "        ... [file normalize $startupProject]\n"
            rattleCAD::model::file::openProject_xml $startupProject    [file tail $startupProject] 
        }

          
            # --------------------------------------------
            #    finalize
        update 
        wm minsize . [winfo width  .]   [winfo height  .]
           
            # -- keyboard bindings -----------------------
        rattleCAD::view::gui::global_kb_Binding ab
        
            # -- window binding -----------------------
        bind . <Configure> [list rattleCAD::control::bind_windowSize]
		    
			# -- update currentView -----------------------
		rattleCAD::control::bind_windowSize init
		    #
		rattleCAD::control::updateControl
		    #
        
            # -- window delete binding -----------------------
        wm protocol . WM_DELETE_WINDOW {
            rattleCAD::view::gui::exit_rattleCAD yesnocancel
        }


            # -- window title ----------------------------
        update_windowTitle  
        update_MainFrameStatus
            
          
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
                if {[$child nodeType] == {ELEMENT_NODE}} {    
                    set name      [ $child getAttribute {name} ]
                    set source    [ $child getAttribute {src} ]
                        # puts "   $name  $source"
                    set rattleCAD::view::gui::iconArray($name) [ image create photo -file $APPL_Config(IMAGE_Dir)/$source ]
                }
            }
            set ::cfg_panel [image create photo -file $APPL_Config(IMAGE_Dir)/cfg_panel.gif]


                # --- fill CANVAS - Array
                #
            set node    [ $root_InitDOM selectNodes /root/lib_gui/geometry/canvas ]
            set rattleCAD::view::gui::canvasGeometry(width)     [ $node getAttribute {width} ]
            set rattleCAD::view::gui::canvasGeometry(height)    [ $node getAttribute {height} ]    
        
                
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
            
            
                # -- check user settings in $::APPL_Config(USER_Dir)/_rattleCAD_[info hostname].Xdefaults  ----
                #            
            read_userXdefaults

            
                # -- check user settings in $::APPL_Config(USER_Dir)/_rattleCAD_[info hostname].init  ----
                #
            read_userInit
                
                
                # --- get Template - File to load
                #
            set APPL_Config(TemplateInit) [rattleCAD::model::file::getTemplateFile   $APPL_Config(TemplateType)]
                
                
                # --- init ListBox Values  
                #
            rattleCAD::model::init_ListBoxValues  $root_InitDOM  
                #
                #  ... following procedures are replaced by above init_ListBoxValues
                # 

            
                # --- fill APPL_CompLocation
                #
            array unset ::APPL_CompLocation 
            set dirList [rattleCAD::model::get_ComponentDirectories]
            foreach node $dirList {
                set key     [lindex $node 0]
                set dir     [lindex $node 1]
                 # puts "  childNode ->   [$childNode nodeName]   $key  $dir "
                set ::APPL_CompLocation($key) $dir
            }
            
            if {1 == 2} {
                set node_Locations [ $root_InitDOM selectNodes /root/Options/ComponentLocation ]
                foreach childNode [ $node_Locations childNodes ] {
                    if {[$childNode nodeType] == {ELEMENT_NODE}} {
                        set key     [$childNode getAttribute key    {}]
                        set dir     [$childNode getAttribute dir    {}]
                          # puts "  childNode ->   [$childNode nodeName]   $key  $dir "
                        set ::APPL_CompLocation($key) $dir
                    }
                }
            }

    }

    
    #-------------------------------------------------------------------------
        # init OS Settings
        #  
    proc init_OS_Settings {} {
    
          osEnv::init_osEnv
          
          switch -glob $::tcl_platform(platform) {
              windows {
                      foreach mimeType {.pdf .html .svg .dxf .jpg .gif .ps} {
                          set defaultApp {}
                          set defaultApp [osEnv::find_mimeType_Application $mimeType]
                          puts "         ... $mimeType -> $defaultApp"
                          if {$defaultApp != {}} {
                              osEnv::register_mimeType $mimeType $defaultApp
                          }
                      }
                      
                      set exec_GhostScript  [osEnv::get_ghostscriptExec]
                      if {$exec_GhostScript != {}} {
                          osEnv::register_Executable gs $exec_GhostScript
                      }
                      
                   }
              unix {
                      foreach {mimeType appName} {.html firefox .svg firefox .ps evince .pdf evince .txt nedit} {
                          puts "         ... $mimeType -> $appName "
                          set defaultApp {}
                          set defaultApp [osEnv::find_OS_Application $appName]
                          puts "         ... $defaultApp"
                          puts "         ... $mimeType -> $appName -> $defaultApp"
                          if {$defaultApp != {}} {
                              osEnv::register_mimeType $mimeType $defaultApp
                          }
                      }
                      foreach appName {sh gs} {
                          set defaultApp {}
                          set defaultApp [osEnv::find_OS_Application $appName]
                          puts "         ... $appName -> $defaultApp"
                          if {$defaultApp != {}} {
                              osEnv::register_Executable $appName $defaultApp
                          }
                      }

                   }
              default {}
          }
    
    }


        
    #-------------------------------------------------------------------------
        # check user settings in $::APPL_Config(USER_Dir)/_rattleCAD_[info hostname].init
        #            
    proc read_userXdefaults {} {    
        set hostName    [info hostname]
        set fileName    [format ".rattleCAD_%s.Xdefaults" $hostName ]
        set fileName    [file join $::APPL_Config(USER_Dir) $fileName ]
        puts ""
        puts "   ... read_userXdefaults"
        puts "         ... .Xdefaults        $fileName"
        puts ""
        
        if {[file exists $fileName ]} {
            if { [catch {option readfile $fileName userDefault} fid] } {
                puts stderr "         ... <E> ... could not open .Xdefaults $fileName\n             ... $fid"
                # exit 1
            }
        } else {
			  set   timeString    [ clock format [clock seconds] -format {%Y.%m.%d %H:%M} ]
                #
              set    fp [open $fileName w]
              puts  $fp "! ... created by  rattleCAD ($::APPL_Config(RELEASE_Version).$::APPL_Config(RELEASE_Revision))"
              puts  $fp "!     ... on  $timeString"
              puts  $fp {!}
              puts  $fp {!*Menu.foreground: black}
              puts  $fp {!}
              puts  $fp {!*Menu.background: lemonChiffon2}
              puts  $fp {!*Menu.foreground: red}
              puts  $fp {!}
              puts  $fp {!}
              puts  $fp {! --- any untested examples: -----------------}
              puts  $fp {!       ... see: http://computer-programming-forum.com/57-tcl/714fcdf48fb18c6c.htm}
              puts  $fp {!}
              puts  $fp {! ----- try some attributes ------------------}
              puts  $fp {!*padX: 10}
              puts  $fp {!*padY: 10}
              puts  $fp {!*sliderLength: 20}
              puts  $fp {!*yScrollSide: left}
              puts  $fp {!*Scale.width: 8}
              puts  $fp {!*Scrollbar.width: 10}
              puts  $fp {!*tearOff: 0}
              puts  $fp {!*activeBorderWidth: 1}
              puts  $fp {! ----- font settings ------------------------}
              puts  $fp {!*font: *-helv*-bold-r-*-120-*-iso8859-1}
              puts  $fp {!*Text.font: *-cour*-medium-r-*-100-*-iso8859-1}
              puts  $fp {!*Radiobutton.font: *-helv*-bold-r-*-120-*-iso8859-1}
              puts  $fp {!*Message.font: *-helv*-bold-r-*-120-*-iso8859-1}
              puts  $fp {!*Listbox.font: *-helv*-bold-r-*-120-*-iso8859-1}
              puts  $fp {!*Label.font: *-helv*-bold-r-*-120-*-iso8859-1}
              puts  $fp {!*Entry.font: *-cour*-medium-r-*-100-*-iso8859-1}
              puts  $fp {!*Checkbutton.font: *-helv*-bold-r-*-120-*-iso8859-1}
              puts  $fp {!*Button.font: *-helv*-bold-r-*-120-*-iso8859-1}
              puts  $fp {! ----- menubar setups -----------------------}
              puts  $fp {!*Menubar.relief: raised}
              puts  $fp {!*Menubar.borderWidth: 2}
              puts  $fp {!*Menubar.Menubutton.padX: 8}
              puts  $fp {!*Menubar*font: *-helv*-bold-o-*-120-*-iso8859-1}
              puts  $fp {!}              
              puts  $fp {}
              close $fp
              puts ""
              puts "     ... .Xdefaults        $fileName"
              puts "         ------------------------"
              puts "           ... write new:"   
              puts "                           $fileName"
              puts "                   ... done"
              
              read_userXdefaults
        }
    }

       
    #-------------------------------------------------------------------------
        # check user settings in $::APPL_Config(USER_Dir)/_rattleCAD_[info hostname].init
        #            
    proc read_userInit {} {    
        set hostName    [info hostname]
        set fileName    [format ".rattleCAD_%s.init" $hostName ]
        set fileName    [file join $::APPL_Config(USER_Dir) $fileName ]
        puts ""
        puts "   ... read_userInit"
        puts "         ... user_InitDOM      $fileName"
        puts "        ->\$::APPL_Config(TemplateType) $::APPL_Config(TemplateType)"
        puts "        ->\$::APPL_Config(FrameJigType) $::APPL_Config(FrameJigType)"
        puts "        ->\$::APPL_Config(GUI_Font)     $::APPL_Config(GUI_Font)"
        puts ""
        # puts "        ->\$::APPL_Config(FrameMethod)  $::APPL_Config(FrameMethod)"
        
        if {[file exists $fileName ]} {
                set ::APPL_Config(user_InitDOM)  [ rattleCAD::model::file::get_XMLContent     $fileName ]
                    # puts "     ... user_InitDOM      $fileName"
                    # puts "[$::APPL_Config(user_InitDOM) asXML]"
                catch {set ::APPL_Config(TemplateType) [[$::APPL_Config(user_InitDOM) selectNodes /root/TemplateFile/text()] asXML]}
                catch {set ::APPL_Config(FrameJigType) [[$::APPL_Config(user_InitDOM) selectNodes /root/FrameJigType/text()] asXML]}
                catch {set ::APPL_Config(GUI_Font)     [[$::APPL_Config(user_InitDOM) selectNodes /root/GUI_Font/text()]     asXML]}
                
                # catch {set ::APPL_Config(FrameMethod)  [[$::APPL_Config(user_InitDOM) selectNodes /root/FrameMethod/text()] asXML]}
                
                
                if {$::APPL_Config(user_InitDOM) != {}} {
                    puts "        ----------------------------"
                    prettyPrint_XML $::APPL_Config(user_InitDOM)
                    puts "        ----------------------------"
                }
                puts "          ->\$::APPL_Config(TemplateType) $::APPL_Config(TemplateType)"
                puts "          ->\$::APPL_Config(FrameJigType) $::APPL_Config(FrameJigType)"
                puts "          ->\$::APPL_Config(GUI_Font)     $::APPL_Config(GUI_Font)"
                puts "        ----------------------------"
                puts ""
                puts "          mime Types:"
                puts "        ----------------------------"
                set mimeConfig [$::APPL_Config(user_InitDOM) selectNodes /root/mime]
                if {$mimeConfig != {}} {
                    foreach node   [$mimeConfig childNodes] {
                        if {[$node nodeType] == {ELEMENT_NODE}} {    
                            # puts "         [$node asXML]"
                            set key    [$node getAttribute name]
                            set value  [[$node firstChild] nodeValue]
                            puts "          -> $key  $value"
                            osEnv::register_mimeType $key $value
                        }
                    }
                }
                
                puts ""
                puts "          executables:"
                puts "        ----------------------------"
                set execConfig [$::APPL_Config(user_InitDOM) selectNodes /root/exec]
                if {$execConfig != {}} {
                    foreach node [$execConfig childNodes] {
                        if {[$node nodeType] == {ELEMENT_NODE}} { 
                            # puts "         [$node asXML]"
                            set key    [$node getAttribute name]
                            set value  [[$node firstChild] nodeValue]
                            puts "          -> $key  $value"
                            osEnv::register_Executable $key $value
                        }
                    } 
                }
              
        } else {
                set   timeString    [ clock format [clock seconds] -format {%Y.%m.%d %H:%M} ]
                    #          
                set    fp [open $fileName w]
                puts  $fp {<?xml version="1.0" encoding="UTF-8" ?>}
                puts  $fp {<root>}
                puts  $fp "    <hostname>$hostName</hostname>"
                puts  $fp "    <fileName>$fileName</fileName>"
                puts  $fp "    <fileCreated>$timeString</fileCreated>"
                puts  $fp "    <GUI_Font>$::APPL_Config(GUI_Font)</GUI_Font>"
                puts  $fp "    <mime>"
                puts  $fp "        <mime name=\".test\">_any_executable</mime>"
                puts  $fp "    </mime>"
                puts  $fp "    <exec>"
                puts  $fp "        <exec name=\"_test\">_any_executable</exec>"
                puts  $fp "    </exec>"
                puts  $fp {</root>}
                close $fp
                puts ""
                puts "     ... user_InitDOM      $fileName"
                puts "         ------------------------"
                puts "           ... write new:"   
                puts "                           $fileName"
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
    proc update_windowTitle {{filename {}}} {
      
            # appDebug  p     
        global APPL_Config
      
        if {$filename == {}} {
            set  filename [rattleCAD::control::getSession projectName]
              # set  filename $APPL_Config(PROJECT_Name)
        }
        set  APPL_Config(WINDOW_Title)  "rattleCAD  $APPL_Config(RELEASE_Version).$APPL_Config(RELEASE_Revision) - $filename"
        wm title . $APPL_Config(WINDOW_Title)
    }

    #-------------------------------------------------------------------------
       #  set Window Title
       #
    proc update_MainFrameStatus {{message {}}} {
      
            # appDebug  p     
        global APPL_Config
      
        if {$message != {}} {
            set  projectText  $message
            set  statusText   {}       
        } else {
            foreach {index size} [rattleCAD::control::changeList::get_undoStack] break
              # set  projectText  [format "%s " [file tail $APPL_Config(PROJECT_Name)]]
              # set  projectText  [format "%s (%s)" [file tail $APPL_Config(PROJECT_Name)] [rattleCAD::control::getSession dateModified]]
            set  projectText  [format "%s (%s)" [file tail [rattleCAD::control::getSession projectName]] [rattleCAD::control::getSession dateModified]]
            set  statusText   [format "UndoStack: %2s / %2s"  $index $size]
        }
          # set  statusText   [file tail $APPL_Config(PROJECT_Name)]
          # puts "   ---> \$projectText $projectText"
          # puts "   ---> \$statusText  $statusText"
        set ::APPL_Config(MainFrameInd_Project)  $projectText
        set ::APPL_Config(MainFrameInd_Status)   $statusText
        
        return
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
            append  message "\n                                     .\\3.4.00.60"
            append  message "\n                                     .\\rattleCAD.tcl"
            append  message "\n"
            append  message "\n         \[Linux\]   /opt/rattleCAD/"
            append  message "\n                                     ./3.4.00.60"
            append  message "\n                                     ./rattleCAD.tcl"
            append  message "\n"
            append  message "\n                            your rattleCAD!"

            tk_messageBox -icon info -message $message
            exit
        }           
    }


    #-------------------------------------------------------------------------
        #  check User Components Directories
        #
    proc init_UserCompDirectories {xmlNode} {
            #
        set dirList [rattleCAD::model::get_ComponentDirectories]
            #
            # puts $dirList
            #
        foreach node $dirList {
            set pathString [lindex $node 1]
                # puts "  ... $pathString"
            rattleCAD::model::file::check_user_dir rattleCAD/$pathString 
        }
        set surprDir     [rattleCAD::model::file::check_user_dir rattleCAD/components/surprise]
        set sourceDir   [file join $::APPL_Config(BASE_Dir) _style]
        catch {file copy [file join $sourceDir Tcl_logo.svg]       $surprDir}
        catch {file copy [file join $sourceDir rattleCAD_logo.svg] $surprDir}
            #
        return
            #
    }


    #-------------------------------------------------------------------------
        #  check User Components Directories
        #
    proc check_templateDirecty {} {

        puts "  ->   check_templateDirecty  "
		puts "            ... \$::APPL_Config(TEMPLATE_Dir) $::APPL_Config(TEMPLATE_Dir)"
		
		if {[catch {glob -directory $::APPL_Config(TEMPLATE_Dir) *} errMsg]} {
			foreach sampleFile [glob -directory $::APPL_Config(SAMPLE_Dir) *] {
				puts "          -> [file normalize ${sampleFile}]"
				file copy -force [file normalize ${sampleFile}] $::APPL_Config(TEMPLATE_Dir)
			}
		} else {
            puts "\n           ... not updated, because of not empty!\n" 
		}
		
		return

    }


     #-------------------------------------------------------------------------
       #  debug_out
       #   
    proc debug_out { msg {args} } {
        appDebug t $msg $args
    }    
    
    
    #-------------------------------------------------------------------------
       #   http://computer-programming-forum.com/57-tcl/aea710a848418614.htm
       #
    proc prettyPrint_XML {dom} {
      set s ""
      set str [$dom asXML]
      set sep \n
      foreach chunk [split $str $sep] {
        if {[string length $s]>0} {
          append s "$sep$chunk"
        } else {
          set s $chunk
        }
        if {[info complete $s]} {
          if {$s == {}} continue
          puts "          $s"
          set s ""
        }
      }
    }   
