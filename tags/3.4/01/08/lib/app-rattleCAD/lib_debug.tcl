 ##+##########################################################################
 #
 # package: rattleCAD   ->  lib_debug.tcl
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
 #  namespace:  rattleCAD::debug
 # ---------------------------------------------------------------------------
 #
 #
 namespace eval rattleCAD::debug {
 
    variable do_debug
    
    set do_debug 1 ;# run  run_debug
    set do_debug 0 ;# pass run_debug
    
    
    proc run_debug {} {
        variable do_debug
        if {$do_debug} {      ;# 1
            puts "\n   ... \$do_debug $do_debug ... run\n"
        } else {              ;# 0
            puts "\n   ... \$do_debug $do_debug ... pass\n"
            return
        }
        
        run_debug02
        exit
    }
    
    proc run_debug01 {} {
    
            return
    }
    
    proc run_debug02 {} {
    
            return
            rattleCAD::update::append_editList Personal(HandleBar_Height)    635.0 640.0
            rattleCAD::update::append_editList Personal(HandleBar_Distance)  483.0 483.0
            rattleCAD::update::append_editList Custom(BottomBracket/Depth)    68.0  72.0
            rattleCAD::update::append_editList Component(Fork/Height)        365.0 370.0
            rattleCAD::update::append_editList Personal(Saddle_Height)       710.0 730.0
            
            # rattleCAD::update::print_editList
            
            rattleCAD::update::exec_editList_prev
            rattleCAD::update::exec_editList_prev
            
            
            # rattleCAD::update::print_editList
            
            rattleCAD::update::append_editList Personal(Saddle_Height)       710.0 720.0
            
            # rattleCAD::update::print_editList
            
            rattleCAD::update::exec_editList_prev
            rattleCAD::update::exec_editList_next
            rattleCAD::update::exec_editList_next
             
            rattleCAD::update::print_editList
            
            
            exit

    }
    
    proc run_debug03 {} {
        variable do_debug
        if {$do_debug} {
            puts "   ... \$do_debug $do_debug ... run"
            
            rattleCAD::update::append_editList Personal(HandleBar_Height)    640.0
            rattleCAD::update::append_editList Personal(HandleBar_Distance)  483.0
            rattleCAD::update::append_editList Custom(BottomBracket/Depth)    72.0
            rattleCAD::update::append_editList Component(Fork/Height)        370.0
            rattleCAD::update::append_editList Personal(Saddle_Height)       730.0
            
            rattleCAD::update::print_editList
            rattleCAD::update::reset_editList
            rattleCAD::update::print_editList
            
            rattleCAD::update::append_editList Personal(HandleBar_Height)    640.0
            rattleCAD::update::print_editList
            rattleCAD::update::append_editList Personal(HandleBar_Distance)  483.0
            rattleCAD::update::append_editList Custom(BottomBracket/Depth)    72.0
            rattleCAD::update::append_editList Component(Fork/Height)        370.0   2
            rattleCAD::update::append_editList Personal(Saddle_Height)       740.0

            rattleCAD::update::print_editList
            
            rattleCAD::update::append_editList Personal(Saddle_Height)       730.0
            rattleCAD::update::append_editList Personal(Saddle_Height)       740.0
            rattleCAD::update::append_editList Personal(Saddle_Height)       750.0

            rattleCAD::update::print_editList
            rattleCAD::update::append_editList Personal(HandleBar_Distance)  483.0   3
            rattleCAD::update::print_editList
            rattleCAD::update::exec_editList_prev
            rattleCAD::update::exec_editList_prev
            rattleCAD::update::exec_editList_prev
            rattleCAD::update::exec_editList_prev
            rattleCAD::update::exec_editList_prev
            rattleCAD::update::exec_editList_next
            rattleCAD::update::exec_editList_next
            rattleCAD::update::exec_editList_next

            
        } else {
            puts "   ... \$do_debug $do_debug ... pass"
        }
        rattleCAD::update::reset_editList
            
        #exit
    }
 

 }
  
