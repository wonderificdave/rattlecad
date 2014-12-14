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

        variable  currentDICT    {} ;# a dictionary
        variable  currentDOM     {} ;# a XML-Object
        
        variable  project_Saved  {0}
        variable  project_Name   {0}
          # ----------------- #
        variable  model_Update   {0}
        variable  window_Update  {0}
        variable  window_Size    {0}
          # ----------------- #
        variable  Session              
        array set Session {
                    rattleCADVersion  {}
                    dateModified      {init}
                    projectName       {}
                    projectFile       {}
                    projectSave       {}
                }
    }
    
	proc rattleCAD::control::updateControl {} {
		
		puts "\n   -------------------------------"
        puts   "    updateControl\n"
        variable currentDICT
		variable currentDOM
		variable model_Update
			
		  # update control-model
		set      currentDICT   $rattleCAD::model::modelDICT
		set      currentDOM    $rattleCAD::model::modelDOM
		set      model_Update  $rattleCAD::model::modelUpdate 
		  #

		  # configPanel - Update 
		rattleCAD::configPanel::init_configValues
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
        puts   "    updateControl"
        puts   "   -------------------------------\n"
          #
    
		  # 
		return
	}

    proc rattleCAD::control::setValue {xpathValueList {mode {update}} {history {append}}} {

		variable  Session
        
          # -- set Value gets xpath and value as a list
          #           like { xpath1 value1  xpath2 value2  xpath3 value3 ...}
        set doUpdate 0
        foreach {xpath value} $xpathValueList {
        
                # puts "   -> xpath = value:   $xpath  $value"
                # set oldValue [[namespace current]::getValue $xpath]
            set oldValue [rattleCAD::model::get_Value $xpath value]
                
            if {$value == $oldValue} {
                continue
            }

            puts "   -------------------------------"
            puts "    rattleCAD::control::setValue"
            puts "       xpath:  $oldValue / $value"
            
            switch -glob $xpath {
                Project/* {
                        continue				
                    }
                default {}
            }
            
                # -- 1 for execute updateControl
            set doUpdate 1
                #
            
                # -- set busy cursor
            set currentTab         [$rattleCAD::view::gui::noteBook_top select]
			set cv_VarName         [rattleCAD::view::gui::notebook_getVarName $currentTab]
			catch {eval $cv_VarName       configure -cursor watch}          
                #
              
            if {$mode == {update}} {
                set newValue  [rattleCAD::model::set_Value $xpath ${value}]
                    # set newValue  [rattleCAD::model::setValue $xpath ${value}]
            } else {
                set newValue  [rattleCAD::model::set_Value $xpath ${value} $mode]
                    # set newValue  [rattleCAD::model::setValue $xpath ${value} $mode]
            }
                #
            rattleCAD::model::updateModel
                #
                # set value to local model
                # set newValue [[namespace current]::getValue $xpath]
            set newValue [rattleCAD::model::get_Value $xpath value]
                #
              
                # append _editList
            if {$history == {append}} {
                changeList::append        $xpath $oldValue ${newValue}
            }
            
              # report update xpath
            puts ""
            puts "       \$xpath:     $xpath"
            puts "       \$value:     $value"
            puts "       \$oldValue:  $oldValue"
            puts "       \$newValue:  $newValue"
            puts "     -----------------------------------"
        }
        
          # -- if update of view is not required
        if {! $doUpdate} {
            catch {eval $cv_VarName   configure -cursor arrow}
            return
        }
          #        
        
          #
		  # update View
		[namespace current]::updateControl
          #
		  
          # -- after updating Values
          # puts "   -- <D> ----------------------------"
		foreach {xpath value} $xpathValueList {
            puts "          -> $xpath -> $value"
        }
          #
          
          # -- reset cursor to arrow
        catch {eval $cv_VarName   configure -cursor arrow} 
          #
          
		puts ""
		puts "    rattleCAD::control::setValue"
		puts "   -------------------------------"
		
		return $newValue
	
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
            {SELECT_File} {             set listBoxContent [rattleCAD::model::get_ComponentList  $key] }
            {SELECT_Rim} {              set listBoxContent [rattleCAD::model::get_ListBoxValues  Rim] }
            {SELECT_ForkType} {         set listBoxContent [rattleCAD::model::get_ListBoxValues  Fork] }
            {SELECT_ForkBladeType} {    set listBoxContent [rattleCAD::model::get_ListBoxValues  ForkBlade] }
            {SELECT_DropOutDirection} { set listBoxContent [rattleCAD::model::get_ListBoxValues  DropOutDirection] }
            {SELECT_DropOutPosition} {  set listBoxContent [rattleCAD::model::get_ListBoxValues  DropOutPosition] }
            {SELECT_ChainStay} {        set listBoxContent [rattleCAD::model::get_ListBoxValues  ChainStay] }
            {SELECT_BrakeType} {        set listBoxContent [rattleCAD::model::get_ListBoxValues  Brake] }
            {SELECT_BottleCage} {       set listBoxContent [rattleCAD::model::get_ListBoxValues  BottleCage] }
            {SELECT_Binary_OnOff} {     set listBoxContent [rattleCAD::model::get_ListBoxValues  Binary_OnOff] }         
        }
        return $listBoxContent
    }    







