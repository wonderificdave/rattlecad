##+##########################################################################
#
# package: rattleCAD    ->    lib__view.tcl
#
#   canvasCAD is software of Manfred ROSENBERGER
#       based on tclTk, BWidgets and tdom on their 
#       own Licenses.
# 
# Copyright (c) Manfred ROSENBERGER, 2013/08/26
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
#    namespace:  rattleCAD::view
# ---------------------------------------------------------------------------
#
# 


namespace eval rattleCAD::view {
 
    
    #-------------------------------------------------------------------------
        #  store createEdit-widgets position
    variable _drag          ; array set _drag        {}
    variable _updateValue   ; array set _updateValue {}

	variable canvasUpdate   ; array set canvasUpdate {}  
    variable canvasRefit    ; array set canvasRefit  {}  
    variable noteBook_top
	
    variable colorSet       ; array set colorSet {
                                    frameTube      {wheat}
                                    frameTube_OL   {black}
                                    tyre           {gray98}
                                    chainStay      {burlywood}
                                    chainStay_1    {NavajoWhite3}
                                    chainStay_2    {NavajoWhite2}
                                    chainStay_CL   {saddle brown}
                                    chainStayArea  {saddle brown}
                                    components     {snow2}
                              }
    } 

    proc rattleCAD::view::updateView {{mode {}}} {
            
			variable noteBook_top
            variable canvasUpdate
            variable canvasRefit
            
			set currentTab         [$rattleCAD::view::gui::noteBook_top select]
			set cvName             [rattleCAD::view::gui::notebook_getVarName $currentTab]
			set varName            [lindex [split $cvName {::}] end]
		
            set updateDone         {no}
			set refitDone          {no}
			
                # -- register each canvas
			if { [catch { set lastUpdate $canvasUpdate($varName) } msg] } {
                set canvasUpdate($varName) [ expr $rattleCAD::control::model_Update -1 ]
				set lastUpdate             $canvasUpdate($varName)
            }
           
			if { [catch { set lastRefit $canvasRefit($varName) } msg] } {
                set canvasRefit($varName)  [ expr $rattleCAD::control::window_Update -1 ]
				set lastRefit              $canvasRefit($varName)
            }
           
            set timeStart     [clock milliseconds]
       
            
                # -- update stage content if parameters changed
            puts "\n"
            puts "   -------------------------------"
			puts "    rattleCAD::view:updateView  "
            puts "       \$canvasUpdate($varName)"
			puts "          last:   $canvasUpdate($varName)  -> [clock format [expr $canvasUpdate($varName)/1000] -format {%Y.%m.%d / %H:%M:%S}]"
            puts "          new:    $rattleCAD::control::model_Update  -> [clock format [expr $rattleCAD::control::model_Update/1000] -format {%Y.%m.%d / %H:%M:%S}]"
            puts "       \$rattleCAD::control::model_Update -> $$rattleCAD::control::model_Update\n"
            
                # -- configure cursor
            catch {eval $cvName     configure -cursor watch}          
                #
                #
            if {1 == 1} {
                if {$mode == {force}} {
                        puts "\n       ... rattleCAD::view:updateView ... update $varName ... force\n"
                        rattleCAD::view::gui::fill_canvasCAD $varName
                        set updateDone  {done}
                } else {
                    if { $lastUpdate < $rattleCAD::control::model_Update } {
                        puts "\n       ... rattleCAD::view:updateView ... update $varName\n"
                        rattleCAD::view::gui::fill_canvasCAD $varName
                        set updateDone  {done}
                    } else {
                        puts "\n       ... rattleCAD::view:updateView ... update $varName ... not required\n"
                    }
                }
                
                if {$mode == {recenter}} {
                        puts "\n       ... rattleCAD::view:updateView ... update $varName ... recenter\n"
                        rattleCAD::view::gui::fill_canvasCAD $varName recenter               
                }
            }
                #
                # -- refit stage if window size changed
            if { $lastRefit < $rattleCAD::control::window_Update } {
					puts "\n       ... rattleCAD::view:updateView ... refitStage ........ $varName\n"
					update
					# catch {$varName refitStage}
					rattleCAD::view::gui::notebook_refitCanvas
					set refitDone  {done}       
            }
                #
                # -- configure cursor
            catch {eval $cvName     configure -cursor arrow}          
                #
            set timeEnd     [clock milliseconds]
            set timeDiff    [expr $timeEnd - $timeStart]
            
            
            puts "\n       ... time to update:"
            puts   "           ... [format "%9.3f" $timeDiff] milliseconds"
            puts   "           ... [format "%9.3f" [expr $timeDiff / 1000.0] ] seconds"
            
            if {$updateDone == {done}} {
                set canvasUpdate($varName) [ clock milliseconds ]
            }
			if {$refitDone == {done}} {
                set canvasRefit($varName)  [ clock milliseconds ]
            }
			
			puts ""
			puts "         -> \$canvasUpdate($varName) $canvasUpdate($varName)"
			puts "         -> \$canvasRefit($varName)  $canvasRefit($varName)\n"
            puts "    rattleCAD::view:updateView  "
            puts "   -------------------------------"
          
    }


    proc rattleCAD::view::init_configValues {} {
            #
        variable _updateValue
            #
        foreach key [array names rattleCAD::control::_lastValue] {
            set _updateValue($key) [lindex [array get rattleCAD::control::_lastValue $key] 1]
                # puts $key
                # puts [array get rattleCAD::control::_lastValue $key]
                # puts [array get _updateValue $key]
        }
            # exit
        return
    }
    
    #-------------------------------------------------------------------------
        #  create ProjectEdit Widget
        # proc createEdit { x y cv_Name updateCommand _arrayNameList {title {Edit:}}}
    proc rattleCAD::view::createEdit { x y cv_Name _arrayNameList {title {Edit:}}} {
            #
            # appUtil::get_procHierarchy
            #
		variable _updateValue
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
            # 
        # refactoring purpose:  
        # rattleCAD::model::debug_getValue
            #
            #
            #
		set x_offset 20
		set cv      [ $cv_Name getNodeAttr Canvas path]
		if { [catch { set cvEdit [frame $cv.f_edit -bd 2 -relief raised] } errorID ] } {
				closeEdit $cv $cv.f_edit
				set cvEdit [frame $cv.f_edit -bd 2 -relief raised]
		}
            #
            # --- create Window ---
        $cv_Name    addtag __cvEdit__ withtag $cvEdit
        $cv         create window [expr $x + $x_offset] $y  -window $cvEdit  -anchor w -tags $cvEdit
        $cv_Name    addtag __cvEdit__ withtag $cvEdit
            #
            # --- cvContentFrame ---
		if {[llength $_arrayNameList] == 1 } {
                createEdit_SingleLine   $x $y $cv $cv_Name $cvEdit $_arrayNameList
		} else {
                createEdit_MultiLine    $x $y $cv $cv_Name $cvEdit $title $_arrayNameList
		}
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
    }

    proc rattleCAD::view::createEdit_SingleLine { x y cv cvName cvEdit _arrayNameList } {
                #
                # appUtil::get_procHierarchy
                #
            variable _updateValue
                #
                # --- create WindowFrames ---
            set cvContentFrame       [frame $cvEdit.f_content -bd 1 -relief sunken]
            pack $cvContentFrame            -side top
            pack configure $cvContentFrame  -fill both
                #
                # --- parameter to edit ---
            set index       oneLine                    
                #
            set key  [lindex $_arrayNameList 0]
                #
            foreach {_array _name path} [rattleCAD::model::unifyKey $key] break
                #
                # puts "       _array/_name/path -> $key -> $_array $_name $path"
                #
                # puts "\n  -> here I am --- $key\n"
            # set xPath [format "%s"   [string map {( /  ) ""} $key]]
            # set value       [rattleCAD::model::getValue  $xPath]
                # puts "\n  -> here I am --- $value    $xPath\n"
                # exit
            # set _updateValue($path) $value
                #
            set labelText   [rattleCAD::view::get_LabelText $key]
                #
            set cvLabel     [label  $cvContentFrame.label_${index} -text "${labelText} : "]
            set cvConfig    [create_Config $cv $cvName $cvEdit $cvContentFrame $index $key]
            set cvClose     [button $cvContentFrame.close -image $rattleCAD::view::gui::iconArray(iconClose) -command "[namespace current]::closeEdit $cv $cvEdit"]
                #
            grid            $cvLabel    $cvConfig   $cvClose -sticky news
            grid configure  $cvLabel    -padx 3 -sticky nws
            grid configure  $cvConfig   -padx 2
                #
            focus $cvConfig
            $cvConfig selection range 0 end
                #
            bind $cvLabel   <ButtonPress-1>     [list [namespace current]::dragStart     %X %Y]
            bind $cvLabel   <B1-Motion>         [list [namespace current]::drag          %X %Y $cv $cvEdit]
                #                    
            return
                #
    }
    proc rattleCAD::view::createEdit_MultiLine { x y cv cvName cvEdit title _arrayNameList } {
                #
                # appUtil::get_procHierarchy
                #
            variable _updateValue
                #
                # --- create WindowFrames ---
                #
            set cvTitleFrame        [frame $cvEdit.f_title      -bg gray60  ]
            set cvContentFrame      [frame $cvEdit.f_content    -bd 1 -relief sunken]
                #
            pack $cvTitleFrame $cvContentFrame -side top
            pack configure $cvTitleFrame    -fill x -padx 2 -pady 2
            pack configure $cvContentFrame  -fill both
                #
                # --- title definition ---
            set cvTitle     [label  $cvTitleFrame.label -text "${title}"  -bg gray60  -fg white -font "Helvetica 8 bold" -justify left]
            set cvClose     [button $cvTitleFrame.close -image $rattleCAD::view::gui::iconArray(iconClose) -command "[namespace current]::closeEdit $cv $cvEdit"]
                #
            pack $cvTitle -side left
            pack $cvClose -side right -pady 2                
                #
                # --- parameter to edit ---
            set updateMode value
            set index 0
            foreach key  $_arrayNameList {
                set index       [expr $index +1]
                    #
                foreach {_array _name path} [rattleCAD::model::unifyKey $key] break
                    #
                    # puts "       _array/_name/path -> $key -> $_array $_name $path"
                    #
                    # puts "\n  -> here I am --- $key\n"
                # set xPath       [format "%s"   [string map {( /  ) ""} $key]]                
                    #
                # set value       [rattleCAD::model::getValue  $xPath]
                    # puts "\n  -> here I am --- $value    $xPath\n"
                    # exit
                # set _updateValue($path) $value
                    #
                set labelText   [rattleCAD::view::get_LabelText $key]
                    #
                set cvLabel     [label  $cvContentFrame.label_${index} -text "${labelText} : "]
                set cvConfig    [create_Config $cv $cvName $cvEdit $cvContentFrame $index $key]
                    #
                grid            $cvLabel    $cvConfig   -sticky news
                grid configure  $cvLabel    -padx 3    -sticky nws
                grid configure  $cvConfig   -padx 2
            }
                #
            bind $cvTitleFrame  <ButtonPress-1>     [list [namespace current]::dragStart     %X %Y]
            bind $cvTitleFrame  <B1-Motion>         [list [namespace current]::drag          %X %Y $cv $cvEdit]
            bind $cvTitle       <ButtonPress-1>     [list [namespace current]::dragStart     %X %Y]
            bind $cvTitle       <B1-Motion>         [list [namespace current]::drag          %X %Y $cv $cvEdit]
                #                    
            return
                #
    }
    #-------------------------------------------------------------------------
        # get label of configLine
        #    
    proc rattleCAD::view::get_LabelText {key} {
            #
            # appUtil::get_procHierarchy
            #
            # puts "\n   ---------------------------------"
            # puts "    <01>    \$key $key"
        switch -glob $key {
            {list://*} {
                    set keyValue  [string range $key 7 end]
                    foreach {_key _listName} [split $keyValue {@}] break
                    set key       [format "%s)" $_key]                
                 }       
            {file://*} -
            {text://*} { # file://Lugs(RearDropOut/File) -> Lugs(RearDropOut/File) 
                    set key       [string range $key 7 end]
                }
            default    {}
        }
		    #
        set key     [string map {/File {}} $key]
            #
		foreach {_array _name path} [rattleCAD::model::unifyKey $key] break
		    #
        # set labelText [format "%s ( %s )" $_array [string trim [ string map {{/} { / }} $_name] " "] ]
        set labelText   [format "%s "   [string trim [ string map {{/} { / }} $_name] " "] ]
            #
        return $labelText
            #   
    }    

    #-------------------------------------------------------------------------
        # create different kind of config lines
        # 
    proc rattleCAD::view::create_Config {cv cv_Name cvEdit cvContentFrame index key} {
        variable _updateValue
            # appUtil::get_procHierarchy
        
            # puts "\n   ---------------------------------"
            # puts "    <01>    \$key $key"
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
		    # puts "       _array/_name/path -> $key -> $_array $_name $path"
		    #
		    # puts "\n  -> here I am --- $key\n"
		# set xPath [format "%s"   [string map {( /  ) ""} $key]]
		# set value       [rattleCAD::model::getValue  $xPath]
		    # puts "\n  -> here I am --- $value    $xPath\n"
		    # exit
        # set _updateValue($path) $value
            #
                                                                                       
        switch -exact $type {
            {file} {    set cvConfig    [ create_ListEdit   $cv_Name $cvContentFrame $index $path SELECT_File ] }
            {list} {    set cvConfig    [ create_ListEdit   $cv_Name $cvContentFrame $index $path $listName   ] }
            {text} {    set cvConfig    [ create_TextEdit   $cv_Name $cvContentFrame $index $path ] }
            default {   set cvConfig    [ create_ValueEdit  $cv_Name $cvContentFrame $index $path ] }
        }
            #
        return $cvConfig
            
    }

    proc rattleCAD::view::create_ValueEdit {cv_Name cvContentFrame index key} {
            #
            # appUtil::get_procHierarchy
            # 
		eval set currentValue $[namespace current]::_updateValue($key)
		  
            #
            # --- create cvLabel, cvEntry ---
        set cvEntry [spinbox $cvContentFrame.value_${index} \
                        -textvariable [namespace current]::_updateValue($key) \
                        -justify right \
                        -relief sunken \
                        -width 10 -bd 1]
		$cvEntry configure -command \
                        "[namespace current]::change_ValueEdit [namespace current]::_updateValue($key) %d"
            #
            # --- define bindings ---
		bind $cvEntry   <MouseWheel>            [list [namespace current]::bind_MouseWheel  [namespace current]::_updateValue($key)  %D]
		bind $cvEntry   <Return>                [list [namespace current]::updateConfig     $cv_Name $key $cvEntry]
		bind $cvEntry   <Leave>                 [list [namespace current]::updateConfig     $cv_Name $key $cvEntry]
		bind $cvEntry   <Double-ButtonPress-1>  [list [namespace current]::updateConfig     $cv_Name $key $cvEntry]
            #
        return $cvEntry
            #
    }

    proc rattleCAD::view::create_TextEdit  {cv_Name cvContentFrame index key} {
            #
        eval set currentValue $[namespace current]::_updateValue($key)
			#
            
            
            
        #parray [namespace current]::_updateValue
            #
        puts "\n"
        puts "-> create_TextEdit"
        puts "-> key -> $key"
        puts "->           $currentValue"            
            
            
            
            
            
            
            
            
            # --- create cvLabel, cvEntry ---
        set cvEntry [entry  $cvContentFrame.value_${index} \
                        -textvariable [namespace current]::_updateValue($key) \
                        -justify right \
                        -relief sunken \
                        -bd 1  -width 10]
        	#
            # --- define bindings ---
        # bind $cvEntry  <MouseWheel>           [list [namespace current]::bind_MouseWheel  [namespace current]::_updateValue($key)  %D]
        bind $cvEntry   <Return>                [list [namespace current]::updateConfig    $cv_Name $key $cvEntry]
        bind $cvEntry   <Leave>                 [list [namespace current]::updateConfig    $cv_Name $key $cvEntry]
        bind $cvEntry   <Double-ButtonPress-1>  [list [namespace current]::updateConfig    $cv_Name $key $cvEntry]
           #
        return $cvEntry
           #
    }

    proc rattleCAD::view::create_ListEdit  {cv_Name cvContentFrame index key type} {
            #
        eval set currentValue $[namespace current]::_updateValue($key)
            #
            # --- create listBox content ---
        switch -exact $type {
                {SELECT_File} { 
                        puts "     createEdit::create_ListEdit::SELECT_File:"
                        set listBoxContent [rattleCAD::control::get_listBoxContent  $type $key]
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
        $cvCBox configure -postcommand \
                        [list eval set [namespace current]::oldValue \$[namespace current]::_updateValue($key)]
            #
            # --- define bindings ---
        bind $cvCBox    <<ComboboxSelected>>        [list [namespace current]::check_listBoxValue   %W $cv_Name $key]
            #
        return $cvCBox
            #
    }

    proc rattleCAD::view::change_ValueEdit {textVar direction} {
			#
			# --- dynamic update value ---
        set currentValue [set ::$textVar]
        set updateValue 1.0
        if {$currentValue < 20} { set updateValue 0.1 }
                # puts "\n  -> $currentValue   -> $updateValue\n"
            #
            # --- update value of spinbox ---
        if {$direction eq "up"} {\
            set newValue [expr {$currentValue + $updateValue}]\
        } else {\
            set newValue [expr {$currentValue - $updateValue}]\
        }
        set ::$textVar [format "%.3f" $newValue]
    }


	#-------------------------------------------------------------------------
        #  createEdit - sub procedures 
    proc rattleCAD::view::debug_compare {a b} {
        if {$a != $b} {
            appUtil::get_procHierarchy
            tk_messageBox -messager "   ... pleas check this:\n      $a $b"
        } else {
            puts "\n ... debug_compare:"
            puts   "       $a"
            puts   "       $b\n"
        }
    }  	


	#-------------------------------------------------------------------------
        #  bind MouseWheel 
    proc rattleCAD::view::bind_MouseWheel {textVar value} {
        set currentValue [set ::$textVar]
        set updateValue 1.0
        if {$currentValue < 20} { set updateValue 0.1 }
        if {$value > 0} {
            set scale 1.0
        } else {
            set scale -1.0
        }
        set newValue [expr {$currentValue + $scale * $updateValue}]
        set ::$textVar [format "%.3f" $newValue]
    }

 
       #  createEdit - sub procedures
    #-------------------------------------------------------------------------
           
    
    
     
    #-------------------------------------------------------------------------
        #  switch check_TubingAngles
        #
    proc rattleCAD::view::check_TubingAngles {} {
        if {$rattleCAD::view::gui::checkAngles != {on}} {
            set rattleCAD::view::gui::checkAngles {on}
        } else {
            set rattleCAD::view::gui::checkAngles {off}
        }
        rattleCAD::cv_custom::updateView         [rattleCAD::view::gui::current_canvasCAD]
        return
    } 
    

    #-------------------------------------------------------------------------
        #  update Project               
    proc rattleCAD::view::updateConfig {cv_Name xpath {cvEntry {}}} {
    
        variable _updateValue

            # --- handele xpath values ---
        switch -glob $xpath {
            {_update_} {}
            default {
                    puts "\n  ... rattleCAD::view::updateConfig ... $xpath   $_updateValue($xpath)\n"
                    set newValue [rattleCAD::control::setValue [list $xpath $_updateValue($xpath)]]
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

    #-------------------------------------------------------------------------
        #  check comments in listbox   
    proc rattleCAD::view::check_listBoxValue { w cv_Name xPath args} {
    
        variable _updateValue
        variable oldValue
        
        puts "  .. check_listBoxValue $xPath $args"
        
        switch $xPath {
            {Component/Wheel/Rear/RimDiameter} -
            {Component/Wheel/Front/RimDiameter} {
                        # -- exception for selection of Combobox
                            # list is splitted by: "----"
                    if {[string range $_updateValue($xPath) 0 3] == "----"} {
                        puts "   ... reset value .. $oldValue"
                        set _updateValue($xPath) $oldValue
                    } else {
                            # puts "   ... $_updateValue($xPath)"
                            # puts "      >[split $_updateValue($xPath) ;]<"
                            # puts "      >[lindex [split $_updateValue($xPath) ;] 0]<"
                        set value [string trim [lindex [split $_updateValue($xPath) ;] 0]]
                        set value [format "%.3f" $value]
                        set _updateValue($xPath) $value
                            # puts "   ... $_updateValue($xPath)"
        
                        [namespace current]::updateConfig $cv_Name $xPath
                    }
                }
            default {
                        [namespace current]::updateConfig $cv_Name $xPath
                }
        }
    } 

    #-------------------------------------------------------------------------
        #  close ProjectEdit Widget
    proc rattleCAD::view::closeEdit {cv cvEdit} {
        $cv delete $cvEdit
        destroy $cvEdit
        catch [ destroy .__select_box ]
    }

    #-------------------------------------------------------------------------
        #  close all ProjectEdit Widgets
    proc rattleCAD::view::close_allEdit {} {
        # puts "  -- closeEdit: $cv $cvEdit"
        set cv_Name {}
        set cv_Path {}
        catch {set cv_Name [rattleCAD::view::gui::current_canvasCAD]}
          # puts "   -> $cv_Name"
        catch {set cv_Path [ $cv_Name getNodeAttr Canvas path]}
          # puts "   -> $cv_Path"
        set items {}
        catch {set items [$cv_Path find withtag __cvEdit__]}
          # puts "   -> $items"
        
        foreach cvEdit $items {
            $cv_Path delete $cvEdit
            destroy $cvEdit
            catch [ destroy .__select_box ]
        }
    }   


    #-------------------------------------------------------------------------
        #  binding: drag
    proc rattleCAD::view::drag {x y cv id} {
              # appUtil::get_procHierarchy
		variable _drag
		set dx [expr {$x - $_drag(lastx)}]
		set dy [expr {$y - $_drag(lasty)}]
		set cv_width  [ winfo width  $cv ]
		set cv_height [ winfo height $cv ]
		set id_bbox   [ $cv bbox $id ]
		if {[lindex $id_bbox 0] < 4} {set dx  1}
		if {[lindex $id_bbox 1] < 4} {set dy  1}
		if {[lindex $id_bbox 2] > [expr $cv_width  -4]} {set dx -1}
		if {[lindex $id_bbox 3] > [expr $cv_height -4]} {set dy -1}
	
		$cv move $id $dx $dy
		set _drag(lastx) $x
		set _drag(lasty) $y
    }

    #-------------------------------------------------------------------------
        #  binding: dragStart
    proc rattleCAD::view::dragStart {x y} {
              # appUtil::get_procHierarchy
		variable _drag
		set [namespace current]::_drag(lastx) $x
		set [namespace current]::_drag(lasty) $y
		puts "      ... dragStart: $x $y"
    }

    #-------------------------------------------------------------------------
        #  create createSelectBox
    proc rattleCAD::view::bind_parent_move {toplevel_widget parent} {
		  # appUtil::get_procHierarchy
		if {![winfo exists $toplevel_widget]} {return}
		set toplevel_x    [winfo rootx $parent]
		set toplevel_y    [expr [winfo rooty $parent]+ [winfo reqheight $parent]]
		wm  geometry      $toplevel_widget +$toplevel_x+$toplevel_y
		wm  deiconify     $toplevel_widget
    }
     
 
 
