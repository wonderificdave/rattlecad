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
    }    
    
    
     #-------------------------------------------------------------------------
        #  append undoList
    proc rattleCAD::control::changeList::append {parameter oldValue newValue} {
        variable _editList
        variable _listIndex         ;# current index in _editList

          # -- clear _editList ---------------------------
          #
		puts "       == changeList::append ===== $_listIndex ==========="
        incr _listIndex
        set i    [array size _editList]; # index of the last entry in _editList
        while {$i > $_listIndex} {
            puts "           <I> $i / $_listIndex"
            unset _editList($i)
            incr i -1
        }
        
          # -- append _editList ---------------------------
          #
        puts "           ... add entry:  [format " (%3s) ...  %25s"  $_listIndex $parameter]"
        puts "                                $oldValue "
        puts "                       ... new: $newValue"
        set _editList($_listIndex) [list $parameter $oldValue $newValue]
          #
		puts "       == changeList::append ===== $_listIndex ==========="		  
		  #
        return $_editList($_listIndex)
    }

    #-------------------------------------------------------------------------
        #  previous 
    proc rattleCAD::control::changeList::previous {} {
        variable _editList
        variable _listIndex
            #
        puts "       == changeList::previous === $_listIndex ==========="
            #
        rattleCAD::view::close_allEdit
            #
		if  {$_listIndex > 0} {
            foreach {parameter oldValue newValue} $_editList($_listIndex) break
            puts "           ... use entry:  [format " (%3s) ...  %40s  %-25s"  $_listIndex $parameter $oldValue]"
              # set oldValue
            rattleCAD::control::setValue [list $parameter $oldValue] {update} {skip}
              #
            incr _listIndex -1
              #
        } else {
            puts "           <I> EXCEPTION: ... $_listIndex"
        }
            #
        puts "       == changeList::previous === $_listIndex ==========="
            #
    }

    #-------------------------------------------------------------------------
        #  next 
    proc rattleCAD::control::changeList::next {} {
		variable _editList
		variable _listIndex
            #
		puts "       == changeList::next ======= $_listIndex ==========="
            #
        rattleCAD::view::close_allEdit
            #
		incr _listIndex
            #
		if  {$_listIndex <= [array size _editList] } {
			foreach {parameter oldValue newValue} $_editList($_listIndex) break
			puts "           ... use entry:  [format " (%3s) ...  %40s  %-25s"  $_listIndex $parameter $newValue]"
			  # set newValue
			rattleCAD::control::setValue [list $parameter $newValue] {update} {skip}
			  #
		} else {
			puts "           <I> EXCEPTION: ... $_listIndex"
		}
            #
		if {$_listIndex > [array size _editList]} {
			set _listIndex [array size _editList]
		}
            #
		puts "       == changeList::next ======= $_listIndex ==========="
            #
    }

    #-------------------------------------------------------------------------
        #  reset undoList
    proc rattleCAD::control::changeList::reset {} {
		variable _editList
		variable _listIndex         ;# current index in _editList
            #
        puts "       == changeList::reset ====== $_listIndex ==========="
            #
		set i [array size _editList]; # index of the last entry in _editList
		while {$i > 0} {
			unset _editList($i)
			incr i -1
		}
		set _listIndex 0
		rattleCAD::view::close_allEdit
            #
        puts "       == changeList::reset ====== $_listIndex ==========="
            #
    }

    #-------------------------------------------------------------------------
        #  print undoList 
    proc rattleCAD::control::changeList::print {} {
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
    proc rattleCAD::control::changeList::get_undoStack {} {        
		variable _editList
		variable _listIndex
		  # print
		return  [list $_listIndex [array size _editList]]
    }
    
            
    #-------------------------------------------------------------------------
        #  get_undoStack
    proc rattleCAD::control::changeList::get_changeIndex {} {        
		variable _listIndex
		return  $_listIndex
    }
