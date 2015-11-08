#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"


 ##+##########################################################################
 #
 # rattleCAD.tcl
 #
 #   rattleCAD is software of Manfred ROSENBERGER
 #       based on tclTk and BWidgets and their 
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
 

  ###########################################################################
  #
  #                 I  -  N  -  I  -  T                        -  Application
  #
  ###########################################################################

    puts "\n\n ====== I N I T ============================ \n\n"
        
        # -- ::APPL_Config(BASE_Dir)  ------
        #
    set BASE_Dir  [file normalize $::argv0]
  
        # -- redefine on Starkit  -----
        #         exception for starkit compilation
        #        .../rattleCAD.exe
        #        .../rattleCAD.exe
    set APPL_Type       [file tail $::argv0]    
    switch -glob -- $APPL_Type {
        {rattleCAD*.kit}   {}    
        {test_rattleCAD*}  {set BASE_Dir [file dirname [file dirname $BASE_Dir]]}
        {main.tcl}         -   
        default            {
           set BASE_Dir  [file dirname $BASE_Dir]
        }
    }
    
    puts "   ... \$BASE_Dir $BASE_Dir"

        # -- Libraries  ---------------
        #
    lappend auto_path           [file join $BASE_Dir lib]
    lappend auto_path           [file join [file dirname $BASE_Dir] addon]

        # puts "  \$auto_path  $auto_path"
    
    
        # -- Packages  ----------------
        #
    package     require Tk                  8.6
    package     require tdom    
    package     require BWidget             
        #
    package     require appUtil             
    package     require vectormath          
    package     require bikeGeometry        
    package     require canvasCAD           
    package     require extSummary          
    package     require osEnv               
                
    package     require rattleCAD           

    catch {
            # tcl package containing not public extensions
        package require rattleCAD_AddOn
    }
    catch {
            # tcl package for windows only
        package require registry            1.1
    }    
    
    

    
  ###########################################################################
  #
  #                 R  -  U  -  N  -  T  -  I  -  M  -  E 
  #
  ###########################################################################

        #
    variable cv_Name    
        #
    init_rattleCAD $BASE_Dir                   
        #
    bikeGeometry::set_newProject $projectDOM
        # 
        #
    proc create_svgEdit {} {
            #
        puts "\n   ... here I am!  001\n"
            #
        variable cv_Name  {}  
            #
        wm geometry     . +250+200
        wm title        . "test edit-Component"
            # wm transient    $w $master  

        ttk::labelframe .lf_eC            -text "test edit-Component"
        pack .lf_eC            -side top  -fill x  -expand yes  -pady 2
            #
        set cv_Name [canvasCAD::newCanvas \
                                    cv_Base \
                                    .lf_eC.cvCAD \
                                    "_baseComp_"  \
                                    840 600  \
                                    passive  \
                                    0.5  0  \
                                    -bd 2  \
                                    -bg white  \
                                    -relief sunken] 
            #
        set rattleCAD::view::gui::noteBook_top $cv_Name
            #
            #
        #set eventRect [$cv_Name create rectangle \
                                    [list 210 50 380 180] \
                                    -width 3\
                                    -fill gray80]
            #
        #rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $eventRect      rectangeEvent
            #
        rattleCAD::configPanel::init_configValues
            #
        set Logo(fileID)            [rattleCAD::model::get_Component    Logo]
        set CrankSet(fileID)        [rattleCAD::model::get_Component    CrankSet]
        set RearDerailleur(fileID)  [rattleCAD::model::get_Component    RearDerailleur]
        set CrankSet(Length)        [rattleCAD::model::get_Scalar       CrankSet Length]
        set CrankSet(ChainRings)    [rattleCAD::model::get_ListValue    CrankSetChainRings]
        
            #
        set ::rattleCAD::view::_updateValue(Component/Logo)                 $Logo(fileID)
        set ::rattleCAD::view::_updateValue(Component/CrankSet)             $CrankSet(fileID)
        set ::rattleCAD::view::_updateValue(Component/RearDerailleur)       $RearDerailleur(fileID)
        set ::rattleCAD::view::_updateValue(Scalar/CrankSet/Length)         $CrankSet(Length)
        set ::rattleCAD::view::_updateValue(Component/CrankSet/ChainRings)  $CrankSet(ChainRings)
            #
        set ::testValue(Component/Logo)             $Logo(fileID)
        set ::testValue(Component/CrankSet)         $CrankSet(fileID)
        set ::testValue(Component/RearDerailleur)   $RearDerailleur(fileID)
            # 
        set list_ChainRings         [lsort [split [rattleCAD::model::get_ListValue CrankSetChainRings] -]]    
        set value_Pulley_x          [ rattleCAD::model::get_Scalar      RearDerailleur Pulley_x      ]   
        set value_Pulley_y          [ rattleCAD::model::get_Scalar      RearDerailleur Pulley_y      ]   
        set value_Pulley_teeth      [ rattleCAD::model::get_Scalar      RearDerailleur Pulley_teeth  ]   
            #
        set ::rattleCAD::view::_updateValue(ListValue/CrankSetChainRings)       $list_ChainRings
        set ::rattleCAD::view::_updateValue(Scalar/RearDerailleur/Pulley_x)     $value_Pulley_x
        set ::rattleCAD::view::_updateValue(Scalar/RearDerailleur/Pulley_y)     $value_Pulley_y
        set ::rattleCAD::view::_updateValue(Scalar/RearDerailleur/Pulley_teeth) $value_Pulley_y
            #
        update_canvasContent
            #
            # etc:../components/crankset/campagnolo_ultra_torque.svg
            #
        #rattleCAD::view::svgEdit::create_svgEdit . {etc:../components/derailleur/rear/campagnolo_2006_short.svg} {Component/RearDerailleur}
            #
        #puts "\n   ... here I am!  002\n"
            #
    #   rattleCAD::view::svgEdit::create_svgEdit . {etc:../components/derailleur/rear/campagnolo_2006_medium.svg} {Component/RearDerailleur}
            #
        #puts "\n   ... here I am!  003\n"
            #
        #rattleCAD::view::svgEdit::create_svgEdit . {etc:../components/crankset/campagnolo_1984_SuperRecord.sv} {Component/CrankSet}
            #
    }

    proc update_canvasContent {} {
            #
            #
        variable cv_Name
            #
        set BB_Position {800 500}  
            #
        $cv_Name clean_StageContent
            #
        #set Logo(fileID)            $::testValue(Component/Logo)
        #set CrankSet(fileID)        $::testValue(Component/CrankSet)
        #set RearDerailleur(fileID)  $::testValue(Component/RearDerailleur)
        set Logo(fileID)            [rattleCAD::model::get_Component    Logo]
        set CrankSet(fileID)        [rattleCAD::model::get_Component    CrankSet]
        set RearDerailleur(fileID)  [rattleCAD::model::get_Component    RearDerailleur]
            #
        puts "\n"
        puts "     update_canvasContent -> \$Logo(fileID) $Logo(fileID)"
        puts "     update_canvasContent -> \$CrankSet(fileID) $CrankSet(fileID)"
        puts "     update_canvasContent -> \$RearDerailleur(fileID) $RearDerailleur(fileID)"
        puts "\n"
           
            #
        set Logo(file)      [rattleCAD::rendering::checkFileString $Logo(fileID) ]
        set Logo(position)  [vectormath::addVector $BB_Position {300 200}]
            # puts "    ... -> $Logo(file)"
        set Logo(object)    [$cv_Name readSVG $Logo(file) $Logo(position)  0  __Logo__ ]
        $cv_Name addtag  __Decoration__ withtag $Logo(object)
            #
            #
        set CrankSet(file)      [rattleCAD::rendering::checkFileString $CrankSet(fileID) ]
        set CrankSet(position)  $BB_Position
            # puts "    ... -> $CrankSet(file)"
        set CrankSet(object)    [$cv_Name readSVG $CrankSet(file) $CrankSet(position)  0  __CrankSet__ ]
            #
        $cv_Name addtag  __Decoration__ withtag $CrankSet(object)
            #
            #
        set RearDerailleur(file)      [rattleCAD::rendering::checkFileString $RearDerailleur(fileID) ]
        set RearDerailleur(position)  [vectormath::addVector $BB_Position {-400 10}]
            # puts "    ... -> $RearDerailleur(file)"
        set RearDerailleur(object)    [$cv_Name readSVG $RearDerailleur(file) $RearDerailleur(position)  0  __RearDerailleur__ ]
            #
        $cv_Name addtag  __Decoration__ withtag $RearDerailleur(object)
            #
            #
            #
        rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $Logo(object)           single_LogoFile
        rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $CrankSet(object)       single_CrankSetFile
        rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $RearDerailleur(object) single_RearDerailleurFile
            #
            #
            #
        set eventRect [$cv_Name create rectangle \
                                    [list 210 50 380 180] \
                                    -width 3\
                                    -fill gray80]
            #
        rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $eventRect      group_Crankset_Parameter_16
            # group_Chain_Parameter_15    
    }

    proc update_handler {} {
        rattleCAD::view::close_allEdit
        update_canvasContent
    }

    proc rattleCAD::view::edit::myEvent {args} {
            #
        puts "\n ... rattleCAD::view::edit::::rectangeEvent\n"
            #
        puts "       ... Event fired"
        puts "       ... $args"
            #
    }

    proc rattleCAD::view::createEdit { x y cv_Name _arrayNameList {title {Edit:}}} {
            #
            # appUtil::get_procHierarchy
            #
		# variable _updateValue
            #
			# appUtil::get_procHierarchy
			# appUtil::appDebug p
			# appUtil::appDebug f
            #
		puts ""
		puts "   -------------------------------"
		puts "    createEdit"
		puts "       x / y:           $x / $y"
		puts "       cv_Name:         $cv_Name"
		puts "       title:           $title"
		if {[llength $_arrayNameList] > 1} {
			puts "       _arrayNameList:"
			foreach entry $_arrayNameList {
				puts "                        $entry"
			}
		} else {
			puts "       _arrayNameList:  $_arrayNameList"
		}
		puts ""
        
            #
            # ------ 
        set r [catch {info level [expr [info level] - 1]} e]
        if {$r} {
            puts "\n      ... createEdit called directly by the interpreter (e.g.: .tcl on the commandline).\n"
        } {
            switch -glob ${e} {
                rattleCAD::view::edit* {
                        puts "\n    <--->   ... createEdit called by ${e}.\n"
                    }
                default {
                        puts "\n    <OLD>   ... createEdit called by ${e}.\n"
                    }
            }
        }
            
            #
            # ------ 
        set cv      [$cv_Name getNodeAttr Canvas path]
            #
            # --- cvContentFrame ---
        if {[llength $_arrayNameList] == 1 } {
                set cvEdit [createEdit_SingleLine   $x $y $cv $cv_Name $_arrayNameList]
		} else {
                set cvEdit [createEdit_MultiLine    $x $y $cv $cv_Name $title $_arrayNameList]
		}
            #
            # --- reposition if out of canvas border ---
        fit_FileEditContainer $cv $cvEdit
            #
        return
            #
        
        #
        update
        
        
        
		set id_bbox   [ $cv bbox $cvEdit ]
            #
        set cv_width  [ winfo width  $cv ]
		set cv_height [ winfo height $cv ]
			# puts "   -> bbox $id_bbox"
		foreach {dx dy} {0 0} break
            #
		if {[lindex $id_bbox 2] > [expr $cv_width  -4]} { set dx [expr $cv_width  - [lindex $id_bbox 2] -4] }
		if {[lindex $id_bbox 3] > [expr $cv_height -4]} { set dy [expr $cv_height - [lindex $id_bbox 3] -4] }
            #
        $cv move $cvEdit $dx $dy
            # puts "  -> reposition $dx $dy"
    }

    proc rattleCAD::view::create_EditContainer { x y cv_Name title lineCount {editLevel {base}}} {
            #
            # appUtil::get_procHierarchy
            #
		# variable _updateValue
            #
			# appUtil::get_procHierarchy
			# appUtil::appDebug p
			# appUtil::appDebug f
            #
		puts ""
		puts "   -------------------------------"
		puts "    create_EditContainer"
		puts "       x / y:           $x / $y"
		puts "       cv_Name:         $cv_Name"
		puts "       title:           $title"
        puts "       lineCount:       $lineCount"
        
            #
        set x_offset 20
        set cv      [ $cv_Name getNodeAttr Canvas path]
            #
        set frameNameBase $cv.f_edit_base
        set frameNameExtd $cv.f_edit_extend
            #
        #catch {closeEdit $cv $frameNameBase}
        #catch {closeEdit $cv $frameNameExtd}
            # 
        switch -exact $editLevel {
            base { 
                    catch {closeEdit $cv $frameNameBase}
                    catch {closeEdit $cv $frameNameExtd}
                    set cvEdit  [frame $frameNameBase -bd 2 -relief raised] 
                }
            extend { 
                    pack forget $frameNameBase
                    catch {closeEdit $cv $frameNameExtd}
                    set cvEdit  [frame $frameNameExtd -bd 2 -relief raised] 
                }
            default {
                    puts "  ... <E> puts:  $editLevel "
                    puts "        ... not in base/extend"
                    return
                }
        }
            #
            # --- create Window ---
        $cv_Name    addtag __cvEdit__ withtag $cvEdit
        $cv         create window [expr $x + $x_offset] $y  -window $cvEdit  -anchor w -tags $cvEdit
        $cv_Name    addtag __cvEdit__ withtag $cvEdit
            #

        if {$lineCount > 1} {
                #
            set cvTitleFrame    [frame $cvEdit.f_title      -bg gray60  ]
            set cvContentFrame  [frame $cvEdit.f_content    -bd 1 -relief sunken]
                #
            pack $cvTitleFrame $cvContentFrame -side top
            pack configure $cvTitleFrame    -fill x -padx 2 -pady 2
            pack configure $cvContentFrame  -fill both
                # --- title definition ---
            set cvTitle         [label  $cvTitleFrame.label -text "${title}"  -bg gray60  -fg white -font "Helvetica 8 bold" -justify left]
            set cvClose         [button $cvTitleFrame.close -image $rattleCAD::view::gui::iconArray(iconClose) -command "[namespace current]::closeEdit $cv $cvEdit"]
                #
            pack $cvTitle -side left
            pack $cvClose -side right -pady 2
                #
            bind $cvTitleFrame  <ButtonPress-1>     [list [namespace current]::dragStart     %X %Y]
            bind $cvTitleFrame  <B1-Motion>         [list [namespace current]::drag          %X %Y $cv $cvEdit]
            bind $cvTitle       <ButtonPress-1>     [list [namespace current]::dragStart     %X %Y]
            bind $cvTitle       <B1-Motion>         [list [namespace current]::drag          %X %Y $cv $cvEdit]
                #
        } else {
                #
            set cvContentFrame  [frame  $cvEdit.f_content    -bd 1 -relief sunken]
            set cvClose         [button $cvEdit.close -image $rattleCAD::view::gui::iconArray(iconClose) -command "[namespace current]::closeEdit $cv $cvEdit"]
                #
            pack $cvContentFrame $cvClose -side left
                #
            #bind $cvContentFrame  <ButtonPress-1>     [list [namespace current]::dragStart     %X %Y]
            #bind $cvContentFrame  <B1-Motion>         [list [namespace current]::drag          %X %Y $cv $cvEdit]
                #
        } 
            #
        switch -exact $editLevel {
            extend { 
                    #update
                    focus $frameNameExtd
                    #update
                    #pack forget $frameNameBase
                    #catch {[namespace current]::closeEdit $cv $frameNameBase } 
                    # [namespace current]::closeEdit $cv $frameNameBase
                }
        }
            #
            
            #
        return [list $cvEdit $cvContentFrame]  
            #
    }

    proc rattleCAD::view::fit_FileEditContainer {cv cvEdit} {
            #
            # --- reposition if out of canvas border ---
		update
		set id_bbox   [ $cv bbox $cvEdit ]
            #
        set cv_width  [ winfo width  $cv ]
		set cv_height [ winfo height $cv ]
			# puts "   -> bbox $id_bbox"
		foreach {dx dy} {0 0} break
            #
		if {[lindex $id_bbox 2] > [expr $cv_width  -4]} { set dx [expr $cv_width  - [lindex $id_bbox 2] -4] }
		if {[lindex $id_bbox 3] > [expr $cv_height -4]} { set dy [expr $cv_height - [lindex $id_bbox 3] -4] }
            #
        $cv move $cvEdit $dx $dy
            # puts "  -> reposition $dx $dy"
            #
        return $cvEdit
            #
    }

    proc rattleCAD::view::create_FileEdit  {cv_Name cvContentFrame index key} {
            #
        puts "                  <30>    create_FileEdit     -> $key "
            #
        parray [namespace current]::_updateValue
        set currentValue [array get [namespace current]::_updateValue $key]
            #
        puts "                  <30>    init_FileEdit     -> $key <- $currentValue  "
            #
            # --- create listBox content ---
        puts "     createEdit::create_ListEdit::SELECT_File:"
        puts "     currentValue: $currentValue" 
        set listBoxContent $currentValue
          # set listBoxContent [rattleCAD::control::get_listBoxContent  $type $key]
          # set listBoxContent [ get_listBoxContent $type $key]
          # set listBoxContent [ get_listBoxContent $type $key]
          
        foreach entry $listBoxContent {
            puts "         ... $entry"
        }
            
            #
            # --- create cvLabel, cvEntry, Select ---
        set cvEntry [entry  $cvContentFrame.value_${index} \
                        -textvariable [namespace current]::_updateValue($key) \
                        -justify right \
                        -relief sunken \
                        -state disabled \
                        -bd 1  -width 25]
            #
            # --- define bindings ---
        bind $cvEntry   <Return>                [list [namespace current]::updateConfig            $cv_Name $key $cvEntry]
        bind $cvEntry   <ButtonPress-1>         [list [namespace current]::create_FileEdit_Extend  %X %Y $cv_Name $key $currentValue]
        bind $cvEntry   <Double-ButtonPress-1>  [list [namespace current]::create_FileEdit_Extend  %X %Y $cv_Name $key $currentValue]
           #
        return $cvEntry
           #    
    }

    proc rattleCAD::view::create_FileEdit_Extend  {x y cv_Name key currentValue args} {
            #
        puts " --- create_FileEdit_Extend ---"
        puts "         ... $cv_Name"
        puts "         ... $x"
        puts "         ... $y"
        puts "         ... $key"
        puts "         ... $currentValue"
        puts "         ... $args"
            #
        set stageScale  [$cv_Name getNodeAttr Stage scale]
        puts "         ... $stageScale"
            #
        set x [expr $x * $stageScale - 20]   
        set y [expr $y * $stageScale + 20]
            #
        set wList   [create_EditContainer  $x $y $cv_Name $key   2 extend ]
        set cvEdit      [lindex $wList 0]  
        set cvContainer [lindex $wList 1]  
        puts "         ... $cvEdit"
        puts "         ... $cvContainer"
        rattleCAD::view::svgEdit::create_svgEdit \
                $cvContainer  \
                $key  \
                $currentValue  \
                ::update_handler
            #
        set cv      [$cv_Name getNodeAttr Canvas path]
        fit_FileEditContainer $cv $cvEdit
            #
        
    }


    proc rattleCAD::view::createEdit_SingleLine { x y cv cv_Name _arrayNameList } {
                #
                # appUtil::get_procHierarchy
                #
            set wList   [create_EditContainer  $x $y $cv_Name {} [llength $_arrayNameList] base ]
            set cvEdit      [lindex $wList 0]  
            set cvContainer [lindex $wList 1]  
            puts "  ... $cvEdit"
            puts "  ... $cvContainer"            
                #
                #set cvContentFrame  $cvEdit
            set cvContentFrame $cvContainer
                #
            pack configure $cvContentFrame  -fill both
                #
                # --- parameter to edit ---
            set index       oneLine                    
                #
            set key  [lindex $_arrayNameList 0]
                #
            puts "              <10> createEdit_SingleLine      -> $key"
                #
                #
            set labelText   [rattleCAD::view::get_LabelText $key]
                #
            set cvLabel     [label  $cvContentFrame.label_${index} -text "${labelText} : "]
            set cvConfig    [create_Config $cv $cv_Name $cvEdit $cvContentFrame $index $key]
                #
            grid            $cvLabel    $cvConfig    -sticky news
            grid configure  $cvLabel    -padx 3 -sticky nws
            grid configure  $cvConfig   -padx 2
                #
            focus $cvConfig
            $cvConfig selection range 0 end
                #
            bind $cvLabel  <ButtonPress-1>     [list [namespace current]::dragStart     %X %Y]
            bind $cvLabel  <B1-Motion>         [list [namespace current]::drag          %X %Y $cv $cvEdit]
                #                    
            return $cvEdit
                #
    }

    proc rattleCAD::view::createEdit_MultiLine { x y cv cv_Name title _arrayNameList } {
                #
                # appUtil::get_procHierarchy
                #
            set wList   [create_EditContainer  $x $y $cv_Name $title [llength $_arrayNameList] base ]
            set cvEdit      [lindex $wList 0]  
            set cvContainer [lindex $wList 1]  
            puts "  ... $cvEdit"
            puts "  ... $cvContainer"            
                # set cvContentFrame  $cvEdit
            
                # set cvContentFrame      [frame $cvEdit.f_content    -bd 1 -relief sunken]
            set cvContentFrame $cvContainer
                #
            pack configure $cvContentFrame  -fill both
                #
                # --- parameter to edit ---
            set updateMode value
            set index 0
            foreach key  $_arrayNameList {
                set index       [expr $index +1]
                    #
                #foreach {_array _name path} [rattleCAD::model::unifyKey $key] break
                    #
                puts "              <10> createEdit_MultiLine       -> $index   $key"
                    #
                    # puts "\n  -> here I am --- $key\n"
                    #
                set labelText   [rattleCAD::view::get_LabelText $key]
                    #
                set cvLabel     [label  $cvContentFrame.label_${index} -text "${labelText} : "]
                set cvConfig    [create_Config $cv $cv_Name $cvEdit $cvContentFrame $index $key]
                    #
                grid            $cvLabel    $cvConfig   -sticky news
                grid configure  $cvLabel    -padx 3    -sticky nws
                grid configure  $cvConfig   -padx 2
            }
                #                    
            return $cvEdit                
                #
    }

    proc rattleCAD::view::updateConfig {cv_Name xpath {cvEntry {}}} {
    
            # --- handele xpath values ---
        switch -glob $xpath {
            {_update_} {}
            default {
                    puts "\n      ... rattleCAD::view::updateConfig "
                    puts "               ... $xpath"
                    puts "               ... $::rattleCAD::view::_updateValue($xpath)\n"
                        # puts "               -> $cvEntry\n"
                        # puts "               ... $_updateValue($xpath)\n"
                        #
                        # set ::rattleCAD::view::_updateValue($xpath) $cvEntry
                    set ::testValue($xpath) $::rattleCAD::view::_updateValue($xpath)
                        #
                    update_canvasContent
                        #
                        # set newValue [rattleCAD::control::setValue [list $xpath $_updateValue($xpath)]]
                        # puts "   -> \$newValue $newValue"                   
                }
        }
        
            #
            # --- finaly update
        update
        catch {$cvEntry selection range 0 end}
            #
        return
            #
    }


    proc rattleCAD::view::create_Config {cv cv_Name cvEdit cvContentFrame index key} {
        variable _updateValue
            # appUtil::get_procHierarchy
        
            # puts "\n   ---------------------------------"
            # puts "    <01>    \$key $key"
        puts "              <20>    create_Config           -> $key "
            #
        set listName "-"
        switch -glob $key {
            {list://*} {
                    set type      [string range $key 0 3] 
                    set keyValue  [string range $key 7 end]
                    foreach {_key _listName} [split $keyValue {@}] break
                    set key       [format "%s)" $_key]
                    set listName  [string range $_listName 0 end-1]                    
                 }       
            {file://*} -
            {text://*} { # file://Lugs(RearDropOut/File) -> Lugs(RearDropOut/File) 
                    set type      [string range $key 0 3] 
                    set key       [string range $key 7 end]
                }
            default    {
                    set type      {}
                }
        }
		    #
		foreach {_array _name path} [rattleCAD::model::unifyKey $key] break
		    #
		puts "              <21>    create_Config           -> $key ... $path"
            #
		    # puts "\n  -> here I am --- $key\n"
		# set xPath [format "%s"   [string map {( /  ) ""} $key]]
		# set value       [rattleCAD::model::getValue  $xPath]
		    # puts "\n  -> here I am --- $value    $xPath\n"
		    # exit
        # set _updateValue($path) $value
            #
        # puts "          <I> rattleCAD::view::create_Config ...  [array get _updateValue $path]"
            #                                                                 
        switch -exact $type {
            {file} {    set cvConfig    [ create_FileEdit   $cv_Name $cvContentFrame $index $path ] }
            {list} {    set cvConfig    [ create_ListEdit   $cv_Name $cvContentFrame $index $path $listName   ] }
            {text} {    set cvConfig    [ create_TextEdit   $cv_Name $cvContentFrame $index $path ] }
            default {   set cvConfig    [ create_ValueEdit  $cv_Name $cvContentFrame $index $path ] }
        }
            #
        return $cvConfig
            #
    }




    proc rattleCAD::view::create_ListEdit  {cv_Name cvContentFrame index key type} {
            #
        eval set currentValue $[namespace current]::_updateValue($key)
            #
        puts "                  <30>    create_ListEdit     -> $key <- $currentValue    ... $type"
            #
            # --- create listBox content ---
        switch -exact $type {
                {SELECT_File} { 
                        puts "     createEdit::create_ListEdit::SELECT_File:"
                        puts "     currentValue: $currentValue" 
                        set listBoxContent $currentValue
                          # set listBoxContent [rattleCAD::control::get_listBoxContent  $type $key]
                          # set listBoxContent [ get_listBoxContent $type $key]
                    }
                default { 
                        puts "     currentValue: $currentValue" 
                        set listBoxContent [rattleCAD::control::get_listBoxContent  $type $key]
                    }
        }
          # set listBoxContent [ get_listBoxContent $type $key]
        foreach entry $listBoxContent {
            puts "         ... $entry"
        }
            #
            # --- create cvLabel, cvEntry, Select ---
        set cvCBox [ ttk::combobox $cvContentFrame.cb_${index} \
                        -textvariable [namespace current]::_updateValue($key) \
                        -values $listBoxContent    \
                        -width  25 \
                        -height 10 \
                        -justify right ]       
            #
            # --- define postcommand
        $cvCBox configure -postcommand \
                        [list eval set [namespace current]::oldValue \$[namespace current]::_updateValue($key)]
            #
            # --- define bindings ---
        bind $cvCBox    <<ComboboxSelected>>        [list [namespace current]::check_listBoxValue   %W $cv_Name $key]
            #
        return $cvCBox
            #
    }



    
    
    
    
    
    
    
    proc rattleCAD::view::edit::single_LogoFile                         {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   file://Component(Logo)                        }
    proc rattleCAD::view::edit::single_CrankSetFile                     {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   file://Component(CrankSet)                    }
    proc rattleCAD::view::edit::single_RearDerailleurFile               {x y cv_Name}   { rattleCAD::view::createEdit  $x $y $cv_Name   file://Component(RearDerailleur)              }
        
    
    
    create_svgEdit
    
    return
 