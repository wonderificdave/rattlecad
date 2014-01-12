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

	variable  currentDICT         {} ;# a dictionary
    variable  currentDOM          {} ;# a XML-Object
    
    variable  model_Update        {0}
    variable  window_Update       {0}
    variable  window_Size         {0}
    
	
	proc updateControl {} {
		
		variable currentDICT
		variable currentDOM
		variable model_Update
			
		  # update control-model
		set      currentDICT   $rattleCAD::model::modelDICT
		set      currentDOM    $rattleCAD::model::modelDOM
		set      model_Update  $rattleCAD::model::modelUpdate 
		  #
		
		  # configPanel - Update 
		rattleCAD::view::init_viewValues $currentDICT
		  #

		  # configPanel - Update 
		rattleCAD::configPanel::init_configValues
		  # 
		
		  # update view
		rattleCAD::view::updateView  
          #
		  
		return
	}

	proc setValue {xpath value {mode {update}} {history {append}}} {

		set oldValue [[namespace current]::getValue $xpath]

		if {$value == $oldValue} {
			return
		}

		puts "   -------------------------------"
		puts "    rattleCAD::control::setValue"
		puts "       xpath:  $oldValue / $value"
		
		if {$mode == {update}} {
		    set newValue  [rattleCAD::model::setValue $xpath ${value}]
		} else {
		    set newValue  [rattleCAD::model::setValue $xpath ${value} $mode]
		}
		
		  # set value to model
		set newValue [[namespace current]::getValue $xpath]
		  #
		  
		  # append _editList
		if {$history == {append}} {
		    changeList::append        $xpath $oldValue ${newValue}
		}

		  # update View
		[namespace current]::updateControl
          #
		  
		puts ""
		puts "       \$xpath:     $xpath"
		puts "       \$value:     $value"
		puts "       \$oldValue:  $oldValue"
		puts "       \$newValue:  $newValue"
		puts "    rattleCAD::control::setValue"
		puts "   -------------------------------"
		
		return $newValue
	
	}

	proc getValue {xpath {format {value}} args} {
	       # key type args
		variable currentDICT
		
		set value     [appUtil::get_dictValue $rattleCAD::model::modelDICT $xpath]
		switch -exact $format {
		    position  {}
		    direction {
			        set value [split [dict get ${value} polar] ,]
					# puts "    -> getValue -> direction"
			    }
			polygon   {}
			value     -
		    default   {}
		}
		  # puts "        rattleCAD::control::getValue $xpath $value  <- $format"
		return ${value}
	}

	proc newProject {projectDOM} {
		
		puts "\n"
		puts "   -------------------------------"
		puts "    rattleCAD::control::newProject"
		  
		  #
		rattleCAD::model::newProject  $projectDOM	
		  #
		  
          # reset history
		[namespace current]::changeList::reset
          #
				
		  # update View
		[namespace current]::updateControl
          #
    }

	proc importSubset {nodeRoot} {
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

	proc newProject_org {projectDOM} {
		puts "\n"
		puts "   -------------------------------"
		puts "    rattleCAD::control::newProject"
        bikeGeometry::set_newProject $projectDOM	
		
          # reset history
		[namespace current]::changeList::reset
          #
				
		  # update View
		[namespace current]::updateControl
          #
    }

	proc importSubset_org {nodeRoot} {
			# puts "[$nodeRoot asXML]"
		puts "\n"
		puts "   -------------------------------"
		puts "    rattleCAD::control::importSubset"
        
		  #
		bikeGeometry::import_ProjectSubset $nodeRoot	
		  #
		  
		  #
		[namespace current]::updateControl
		  #
    }
	
	


    #-------------------------------------------------------------------------
       #  get sizeinfo:  http://www2.tcl.tk/8423
       #
    proc bind_windowSize {} {

        set newSize [lindex [split [wm geometry .] +] 0]
		
        if {![string equal $newSize $[namespace current]::window_Size]} {
			set [namespace current]::window_Size   $newSize
			set [namespace current]::window_Update [clock milliseconds]
			
			puts "     ... update WindowSize: $[namespace current]::window_Update / $[namespace current]::window_Size"
				
			  # update view
			# rattleCAD::cv_custom::updateView  [rattleCAD::gui::current_canvasCAD]
			  #
        }
    }	

}


namespace eval rattleCAD::control::changeList {
 
    variable _editList    ; array set _editList    {}
    variable _listIndex  0;
    
    variable _undoStack  [format "undoStack: %2s / %2s"  $_listIndex [array size _editList]]
      
        #  add trace on _listIndex
    trace add variable _editList     write   trace_editList 
    trace add variable _listIndex    write   trace_editList 
    
    proc trace_editList {varname args} {        
            # puts "\n   ->    $_listIndex / [array size _editList] "
            # parray ::_editList
            # print
        ::::update_MainFrameStatus
    }    
    
    
    
     #-------------------------------------------------------------------------
        #  append undoList
    proc append {parameter oldValue newValue} {
        variable _editList
        variable _listIndex         ;# current index in _editList

          # -- clear _editList ---------------------------
          #
        puts "\n   --- append -------- $_listIndex --------------------"
        incr _listIndex
        set i    [array size _editList]; # index of the last entry in _editList
        while {$i > $_listIndex} {
            puts "       <I> $i / $_listIndex"
            unset _editList($i)
            incr i -1
        }
        
          # -- append _editList ---------------------------
          #
        puts "           entry:  [format " (%3s) ...  %40s  %-25s / %25s"  $_listIndex $parameter $oldValue $newValue]"
        set _editList($_listIndex) [list $parameter $oldValue $newValue]
          #

          #		  
		# print
		  #
		  
		  #
        return $_editList($_listIndex)
    }

    #-------------------------------------------------------------------------
        #  previous 
    proc previous {} {
        variable _editList
        variable _listIndex
        puts "\n"
        puts "   --- previous ----- $_listIndex --------------------"
        rattleCAD::view::close_allEdit
		
		# print
        
		if  {$_listIndex > 0} {
            foreach {parameter oldValue newValue} $_editList($_listIndex) break
            puts "           entry:  [format " (%3s) ...  %40s  %-25s"  $_listIndex $parameter $oldValue]"
              # set oldValue
            rattleCAD::control::setValue $parameter $oldValue {update} {skip}
              #
            incr _listIndex -1
              #
        } else {
            puts "          previous - $_listIndex - exception"
        }
        puts "   --- previous ----- $_listIndex --------------------\n"
            
    }

    #-------------------------------------------------------------------------
        #  next 
    proc next {} {
		variable _editList
		variable _listIndex
		puts "\n"
		puts "   --- next ----- $_listIndex --------------------"
		rattleCAD::view::close_allEdit
		
		# print
		
		incr _listIndex
		
		if  {$_listIndex <= [array size _editList] } {
			foreach {parameter oldValue newValue} $_editList($_listIndex) break
			puts "           entry:  [format " (%3s) ...  %40s  %-25s"  $_listIndex $parameter $newValue]"
			  # set newValue
			rattleCAD::control::setValue $parameter $newValue {update} {skip}
			  #
		} else {
			puts "          next - $_listIndex - exception"
		}
		
		if {$_listIndex > [array size _editList]} {
			set _listIndex [array size _editList]
		}
		
		puts  "   --- next ----- $_listIndex --------------------\n"

    }

    #-------------------------------------------------------------------------
        #  reset undoList
    proc reset {} {
		variable _editList
		variable _listIndex         ;# current index in _editList
		puts "\n   --- reset -----------------------------"
		#unset    _editList
		#array   set    _editList  {}

		set i [array size _editList]; # index of the last entry in _editList
		while {$i > 0} {
			unset _editList($i)
			incr i -1
		}
		set _listIndex 0
		rattleCAD::view::close_allEdit
		
		# print
    }

    #-------------------------------------------------------------------------
        #  print undoList 
    proc print {} {
		variable _editList
		variable _listIndex         ;# current index in _editList
		
		# return
		
		puts "\n     --- print ------------------------ $_listIndex ---"
		foreach entry [lsort [array names _editList]] {
			foreach {parameter oldValue newValue} $_editList($entry) break
			puts "           entry:  [format " (%3s) ...  %40s  %-25s / %25s"  $entry $parameter $oldValue $newValue]"
		}
		puts "     --- print ---------------------------\n"
        
    }
        
    #-------------------------------------------------------------------------
        #  get_undoStack
    proc get_undoStack {} {        
		variable _editList
		variable _listIndex
		  # print
		return  [list $_listIndex [array size _editList]]
    }
    
            
    #-------------------------------------------------------------------------
        #  get_undoStack
    proc get_changeIndex {} {        
		variable _listIndex
		return  $_listIndex
    }

}



