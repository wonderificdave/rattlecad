##+##########################################################################
#
# package: rattleCAD    ->    lib__control.tcl
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
#    namespace:  rattleCAD::control
# ---------------------------------------------------------------------------
#
# 


    namespace eval rattleCAD::control {

        # variable  currentDICT    {} ;# a dictionary
        # variable  currentDOM     {} ;# a XML-Object
        
        variable  project_Saved  {0}
        variable  project_Name   {0}
          # ----------------- #
        variable  model_Update   {0}
        variable  window_Update  {0}
        variable  window_Size    {0}
          # ----------------- #
        variable _lastValue
        variable _currentValue; array set _currentValue {}
          # ----------------- #
        variable  Session              
        array set Session {
                    rattleCADVersion  {}
                    dateModified      {init}
                    projectName       {}
                    projectFile       {}
                    projectSave       {}
                }
          # ----------------- #
        variable    frame_configMode    {OutsideIn}
          # ----------------- #
    }
    
    proc rattleCAD::control::updateControl {} {
        
        puts "\n"
        puts "    =========== rattleCAD::control::updateControl ==============-start-=="
             #
        variable currentDOM
        variable model_Update
        
            # configPanel - Update 
        rattleCAD::control::get_currentValues
            #
        rattleCAD::view::init_configValues 
        rattleCAD::configPanel::init_configValues
            #
            #
        rattleCAD::model::updateModel
            # update control-model
        set      currentDICT   $rattleCAD::model::modelDICT
        set      currentDOM    $rattleCAD::model::modelDOM
        set      model_Update  $rattleCAD::model::modelUpdate 
            #
            #
            # update view
        rattleCAD::view::updateView  
            #
            #
        puts "\n"
        puts   "      rattleCAD::control::Session:"
        puts   "          [rattleCAD::control::getSession  projectFile]"
        puts   "          [rattleCAD::control::getSession  projectName]"
        puts   "          [rattleCAD::control::getSession  projectSave]"
        puts   "          [rattleCAD::control::getSession  dateModified]"
        puts   "          [rattleCAD::control::getSession  rattleCADVersion]\n"
        puts   ""
        puts "    =========== rattleCAD::control::updateControl ================-end-=="            
            # 
		return
	}

    proc rattleCAD::control::setValue {keyValueList {mode {update}} {history {append}}} {
            #
            # -- setValue gets key and value as a list
            #           like { key1 value1  key2 value2  key3 value3 ...}
            #
        puts ""
        puts "  =========== rattleCAD::control::setValue ===========================-start-=="
            #
        variable  Session
        # variable _lastValue
        variable _currentValue
            #
            #
            # -- set busy cursor
        set currentTab         [$rattleCAD::view::gui::noteBook_top select]
        set cv_VarName         [rattleCAD::view::gui::notebook_getVarName $currentTab]
        catch {eval $cv_VarName       configure -cursor watch}          
            #
            #
        set doUpdate 0
            #
        set loopCount 0
        foreach {key value} $keyValueList {
                    #
                    # puts "   -> key = value:   $key  $value"
                    #
                incr loopCount 1 
                    #
                puts ""
                puts "    =========== rattleCAD::control::setValue ===========-loop-==-start-==-${loopCount}-"
                puts ""
                puts "              \$mode/\$history .... $mode/$history\n"
                    #
                set oldValue [lindex [array get _currentValue $key] 1]
                    # puts "  -> $oldValue"
                    #
                puts "              $key: .... $oldValue / $value\n"
                    #
                
                if {$value == $oldValue} { 
                    puts "              ... equal values!"
                    puts "             -------------------------------"
                    continue
                }

                    # -- Project/* does not influence the model
                switch -glob $key {
                    Project/* {
                            continue				
                        }
                    default {}
                }
                    #
                    # -- 1 for execute updateControl
                set doUpdate 1
                    #
                    #
                switch -exact $mode {
                    {force} -
                    {update} {
                            set keyList  [split $key /]
                            set rootName [lindex $keyList 0]
                            set keyList [lrange $keyList 1 end]
                            switch -exact $rootName {
                                Config    { set newValue  [rattleCAD::model::set_Config     $keyList ${value}] }
                                Component { set newValue  [rattleCAD::model::set_Component  $keyList ${value}] }
                                ListValue { set newValue  [rattleCAD::model::set_ListValue  $keyList ${value}] }
                                Scalar    { 
                                            switch -exact [llength $keyList] {
                                                1 { set newValue  [rattleCAD::model::set_Scalar     $keyList                                                                ${value}]} 
                                                2 { set newValue  [rattleCAD::model::set_Scalar     [lindex $keyList 0] [lindex $keyList 1]                                 ${value}]} 
                                                3 { set newValue  [rattleCAD::model::set_Scalar     [lindex $keyList 0] [lindex $keyList 1] [lindex $keyList 2]  $keyList   ${value}]} 
                                            }
                                    }
                                default {
                                        tk_messageBox -message "  ... this should be OK?"
                                    }
                            }
                                # 20141206
                                # set newValue  [rattleCAD::model::set_Value $key ${value}]
                                # set newValue  [rattleCAD::model::setValue $key ${value}]
                        }
                    default {
                            tk_messageBox -message "rattleCAD::control::setValue $key ${value}   $mode  $history" 
                                # set newValue  [rattleCAD::model::set_Value $key ${value}]
                                # set newValue  [bikeGeometry::get_Value_expired $key ${value} $mode]
                                # set newValue  [rattleCAD::model::set_Value $key ${value} $mode]
                                # set newValue  [rattleCAD::model::setValue $key ${value} $mode]
                        }
                }
                    #
                    #
                if {$newValue == {}} {
                    puts "         ... value  \"$value\"  not accepted for  $key  ... :\("
                    set rattleCAD::view::_updateValue($key) $oldValue
                    catch {eval $cv_VarName   configure -cursor arrow}
                    return
                } else {
                    rattleCAD::control::get_currentValues
                }
                    #
                    #
                    # append _editList
                if {$history == {append}} {
                        # ... in case of rattleCAD::model::set_Value did not accept the new Value
                    changeList::append        $key $oldValue ${newValue}
                }
                
                    # -- report update key
                puts ""
                puts "       \$key:     $key"
                puts "       \$value:     $value"
                puts "       \$oldValue:  $oldValue"
                puts "       \$newValue:  $newValue"
                puts ""
                puts "    =========== rattleCAD::control::setValue ===========-loop-====-end-==-${loopCount}-"
                puts ""
        }
            #
            # update View
		updateControl
            #
            # -- reconfigur cursor
        catch {eval $cv_VarName   configure -cursor arrow}
		  
            # -- after updating Values
            # puts "   -- <D> ----------------------------"
		puts "\n"
        foreach {key value} $keyValueList {
            puts "          -> $key -> $value"
        }
            #
            #
		puts ""
		puts "          ... history: $history"
            # puts "          ... $mode/$history"
        puts ""
        puts "  =========== rattleCAD::control::setValue ==========================-finish-=="
        puts ""
            #
		return
            # return $newValue
	
	}

    proc rattleCAD::control::set_frameConfigMode {} {
            #
        variable frame_configMode
            #
        switch -exact $frame_configMode {
                {OutsideIn}  -
                {StackReach} -
                {Lugs}       -
                {Classic}   {
                        if {[rattleCAD::model::set_geometry_IF $frame_configMode]} {
                                # puts "   <I>  rattleCAD::control::set_frameConfigMode ... $frame_configMode"
                                # set steering parameter in rattleCAD::view::gui
                            set rattleCAD::view::gui::frame_configMethod $frame_configMode
                                # update view
                            rattleCAD::view::updateView force
                                #
                        }
                }
                default         {}            
        }            
            #
    }
    
    proc rattleCAD::control::setSession {name value} {
        variable  Session
        set Session($name) "${value}"
    }
    proc rattleCAD::control::getSession {name} {
        variable  Session
        set value [set Session($name)] 
        return ${value}
    }
	proc rattleCAD::control::newProject {projectDOM} {
		
		puts "\n"
		puts "   -------------------------------"
		puts "    rattleCAD::control::newProject"
		  
		  #
		rattleCAD::model::newProject  $projectDOM	
		  #
		  
          # reset history
		[namespace current]::changeList::reset
          #
			
          # remove position value in $rattleCAD::cv_custom::Position -> do a recenter
        rattleCAD::cv_custom::unset_Position
          #
            
		  # update View
		[namespace current]::updateControl
          #

    }

	proc rattleCAD::control::importSubset {nodeRoot} {
	      # puts "[$nodeRoot asXML]"
		puts "\n"
		puts "   -------------------------------"
		puts "    rattleCAD::control::importSubset"
		  
		  #
		rattleCAD::model::importSubset $nodeRoot	
		  #
		  
		  #
		[namespace current]::updateControl
		  #
          
    }
	


    #-------------------------------------------------------------------------
       #  get sizeinfo:  http://www2.tcl.tk/8423
       #
    proc rattleCAD::control::bind_windowSize {{mode {}}} {

        variable window_Size
		variable window_Update
		
		set newSize [lindex [split [wm geometry .] +] 0]
		
          # puts "   -> newSize:   $newSize"
		  # puts "   -> lastSize:  [set [namespace current]::window_Size]"
		
		if {$mode == {init}} {
		      # puts ""
              # puts "     ... [namespace current]::bind_windowSize: init"
              # puts ""
            update
			set window_Size   $newSize
			set window_Update [clock milliseconds]
			  # puts "     ... [namespace current]::bind_windowSize: [set window_Size]"
              # puts "     ... [namespace current]::bind_windowSize: [set window_Update]"
              # puts ""
			return
		}
		
		if {![string equal $newSize [set [namespace current]::window_Size]]} {
			  # puts ""
              # puts "     ... [namespace current]::bind_windowSize: [set window_Update]"
            set window_Size   $newSize
			set window_Update [clock milliseconds]
			
			  # tk_messageBox -message "bind_windowSize"
			  # puts "     ... [namespace current]::bind_windowSize: [set window_Size]"
              # puts "     ... [namespace current]::bind_windowSize: [set window_Update]"
              # puts ""
              #
			return
        }
    }	

    proc rattleCAD::control::get_listBoxContent {type {key {}}} {      
        set listBoxContent {}
        puts "       -> get_listBoxContent:  $type $key"
        switch -exact $type {
            {SELECT_File} {             set listBoxContent [rattleCAD::model::get_ComponentList     $key] }
            {SELECT_Rim} {              set listBoxContent [rattleCAD::model::get_keyListBoxValues  Rim] }
            {SELECT_ForkType} {         set listBoxContent [rattleCAD::model::get_keyListBoxValues  Fork] }
            {SELECT_ForkBladeType} {    set listBoxContent [rattleCAD::model::get_keyListBoxValues  ForkBlade] }
            {SELECT_DropOutDirection} { set listBoxContent [rattleCAD::model::get_keyListBoxValues  DropOutDirection] }
            {SELECT_DropOutPosition} {  set listBoxContent [rattleCAD::model::get_keyListBoxValues  DropOutPosition] }
            {SELECT_ChainStay} {        set listBoxContent [rattleCAD::model::get_keyListBoxValues  ChainStay] }
            {SELECT_BrakeType} {        set listBoxContent [rattleCAD::model::get_keyListBoxValues  Brake] }
            {SELECT_BottleCage} {       set listBoxContent [rattleCAD::model::get_keyListBoxValues  BottleCage] }
            {SELECT_Binary_OnOff} {     set listBoxContent [rattleCAD::model::get_keyListBoxValues  Binary_OnOff] }         
        }
        return $listBoxContent
    }    

    proc rattleCAD::control::get_currentValues {} {
            #
        set _editDict [rattleCAD::model::get_projectDICT]
            #
        # appUtil::pdict $_editDict
            #
        dict for {key val} ${_editDict} {
            dict_to_currentValue ${val} $key 
        }
            #
        return
            #
    }

    proc rattleCAD::control::dict_to_currentValue {dictVar dictPath} {
            #
        dict for {key val} ${dictVar} {
            set path "$dictPath/$key"
            if {[catch {[namespace current]::dict_to_currentValue  ${val} $path} eID]} {
                    # puts "       [format {%-10s ... %-40s ... %s} $rootNode $path $val]"
                array set [namespace current]::_currentValue [list $path $val]
            }
        }
            #
        return
            #
    }    
   







