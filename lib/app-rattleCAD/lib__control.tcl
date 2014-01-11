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
    
	
	proc updateModel {} {
		variable currentDICT
		variable currentDOM
		variable model_Update

		if {1 ==2} {
    		set r [catch {info level [expr [info level] - 1]} e]
    		if {$r} {
    			puts "Called directly by the interpreter (e.g.: .tcl on the partyline)."
    		} else {
    			puts "Called by ${e}."
    		}
		}
	
		  # update control-model
		set      currentDICT  [bikeGeometry::get_projectDICT]
		set      currentDOM   [bikeGeometry::get_projectDOM]
		  # [namespace current]::update
		  #
		appUtil::pdict $currentDICT
          #		
		
          # update timestamp
		set model_Update      [clock milliseconds]
          # set ::APPL_Config(canvasCAD_Update) [clock milliseconds]
          #
                    
          # update view
		rattleCAD::view::updateView  
          #
	}


	proc setValue {xpath value {mode {update}} {history {append}}} {
	
		variable currentDICT
		variable currentDOM
		variable model_Update
		
		set oldValue [[namespace current]::getValue $xpath]

		if {$value == $oldValue} {
			return
		}

		puts "   -------------------------------"
		puts "    rattleCAD::control::setValue"
		puts "       xpath:  $oldValue / $value"
		
		if {$mode == {update}} {
		    set newValue  [bikeGeometry::set_Value $xpath $value]
		} else {
		    set newValue  [bikeGeometry::set_Value $xpath $value $mode]
		}
		
		  # set value to model
		set value [rattleCAD::control::getValue $xpath]
		  #
		  
		  # append _editList
		if {$history == {append}} {
		    changeList::append        $xpath $oldValue $newValue
		}

		  # update View
		[namespace current]::updateModel
          #
		  
		return $value
		
	}


	proc getValue {xpath {format {value}} args} {
	       # key type args
		variable currentDICT
		set value     [appUtil::get_dictValue $currentDICT $xpath]
		switch -exact $format {
		    position  {}
		    direction {
			        set value [split [dict get $value polar] ,]
					# puts "    -> getValue -> direction"
			    }
			polygon   {}
			value     -
		    default   {}
		}
		  # puts "        rattleCAD::control::getValue $xpath $value  <- $format"
		return $value
	}

	    #-------------------------------------------------------------------------
        #  return all geometry-values to create specified tube in absolute position
    proc get_Object {object index {centerPoint {0 0}} } {
                # puts "   ... $object"
                # {lindex {-1}}

                # -- for debug purpose
            if {$object == {DEBUG_Geometry}} {
                    set returnValue    {}
                    set pointValue $index
                    foreach xy $pointValue {
                        foreach {x y} [split $xy ,] break
                        lappend returnValue $x $y  ; # puts "    ... $returnValue"
                    }
                    return [ vectormath::addVectorPointList  $centerPoint $returnValue ]
            }


                # -- default purpose
            switch -exact $index {

                polygon    {    
				            set returnValue    {}
                            switch -exact $object {
                                Stem             -
                                HeadSet/Top     -
                                HeadSet/Bottom     -
                                SeatPost     {
                                                set branch "Components/$object/Polygon"
                                            }

                                TubeMiter/TopTube_Head     -
                                TubeMiter/TopTube_Seat     -
                                TubeMiter/DownTube_Head    -
                                TubeMiter/DownTube_Seat    -
                                TubeMiter/DownTube_BB_out  -
                                TubeMiter/DownTube_BB_in   -
                                TubeMiter/SeatTube_Down    -
                                TubeMiter/SeatTube_BB_out  -
                                TubeMiter/SeatTube_BB_in   -
                                TubeMiter/SeatStay_01      -
                                TubeMiter/SeatStay_02      -
                                TubeMiter/Reference {
                                                set branch "$object/Polygon"    ; # puts " ... $branch"
                                            }

                                default     {
                                                set branch "Tubes/$object/Polygon"
                                            }
                            }
                                # puts "    ... $branch"
                            set svgList    [ project::getValue Result($branch)    polygon ]
                            foreach xy $svgList {
                                foreach {x y} [split $xy ,] break
                                lappend returnValue $x $y
                            }
                            return [ vectormath::addVectorPointList  $centerPoint  $returnValue]
                        }

                position {
                            set returnValue    {}
                            switch -glob $object {
                                BottomBracket -
                                FrontWheel -
                                RearWheel -
                                Saddle -
                                SeatPostSaddle -
                                SeatPostSeatTube -
                                SeatPostPivot -
                                SaddleProposal -
                                HandleBar -
                                LegClearance -
                                BottomBracketGround -
                                SteererGround -
                                SeatTubeGround -
                                SeatTubeVirtualTopTube -
                                SeatTubeSaddle -
                                BrakeFront -
                                BrakeRear -
                                DerailleurMountFront -
                                Reference_HB -
                                Reference_SN -
                                SummarySize {
                                              # Result/Position/Reference_HB
                                            set branch "Position/$object"
                                        }
                                
                                Lugs/Dropout/Rear/Derailleur {
                                            set branch "$object"
                                        }

                                Lugs/* {
                                            set branch "$object/Position"    ; # puts " ... $branch"
                                        }


                                default {
                                            # puts "   ... \$object $object"
                                            set branch "Tubes/$object"
                                        }
                            }

                            set pointValue    [ project::getValue Result($branch)    position ]    ; # puts "    ... $pointValue"

                            foreach xy $pointValue {
                                foreach {x y} [split $xy ,] break
                                lappend returnValue $x $y    ; # puts "    ... $returnValue"
                            }
                            return [ vectormath::addVectorPointList  $centerPoint  $returnValue]
                        }

                direction {
                            set returnValue    {}
                                # puts " ... $object"
                            switch -glob $object {
                                    Lugs/* {
                                            set branch "$object/Direction/polar"    ; # puts " ... $branch"
                                        }

                                    default {
                                            set branch "Tubes/$object/Direction/polar"
                                        }
                            }

                            set directionValue    [ project::getValue Result($branch)    direction ]    ; # puts "    ... $directionValue"
                            foreach xy $directionValue {
                                foreach {x y} [split $xy ,] break
                                lappend returnValue $x $y   ; # puts "    ... $returnValue"
                            }
                            return $returnValue
                        }

                default    {             puts "   ... object_values $object $index"
                            #eval set returnValue $[format "frameCoords::%s(%s)" $object $index]
                            #return [ coords_addVector  $returnValue  $centerPoint]
                        }
            }
    }

	proc newProject {projectDOM} {
		puts "\n"
		puts "   -------------------------------"
		puts "    rattleCAD::control::newProject"
        bikeGeometry::set_newProject $projectDOM	
		
          # reset history
		rattleCAD::control::changeList::reset
          #
				
		  # update View
		[namespace current]::updateModel
          #
		
    }
	
	proc importSubset {nodeRoot} {
			# puts "[$nodeRoot asXML]"
		puts "\n"
		puts "   -------------------------------"
		puts "    rattleCAD::control::importSubset"
        
		  #
		bikeGeometry::import_ProjectSubset $nodeRoot	
		  # project::import_ProjectSubset $nodeRoot	
		  #
		  
		  #
		[namespace current]::updateModel
		  #
    }
	
	


    #-------------------------------------------------------------------------
       #  get sizeinfo:  http://www2.tcl.tk/8423
       #
    proc bind_windowSize {} {

        set newSize [lindex [split [wm geometry .] +] 0]
		
        if {![string equal $newSize $rattleCAD::control::window_Size]} {
			set rattleCAD::control::window_Size   $newSize
			set rattleCAD::control::window_Update [clock milliseconds]
			
			puts "     ... update WindowSize: $rattleCAD::control::window_Update / rattleCAD::control::window_Size"
				
			  # update view
			# rattleCAD::cv_custom::updateView  [rattleCAD::gui::current_canvasCAD]
			  #
        }
    }	
	
	
    proc unifyKey {key} {
        
        package require appUtil 0.9
        # appUtil::get_procHierarchy
        
        set isArray [string first "(" $key 0]
        if {$isArray > 1} {
              # puts "          <D> -> got Array  $key <- ($isArray)"
            set arrayName   [lindex [split $key (]  0]
            set keyName     [lindex [split $key ()] 1]
            set xPath       [format "%s/%s" $arrayName $keyName]
              # puts "          <D> -> got Array  $arrayName $keyName"
            return [list $arrayName $keyName $xPath]
        } else {
            set values      [split $key /]
            set slashIndex  [string first {/} $key 1]
              # puts "          <D> -> got xPath  $key <- ($isArray) <- $slashIndex"
            set arrayName   [string range $key 0 $slashIndex-1]
            set keyName     [string range $key $slashIndex+1 end]       
            set xPath       [format "%s/%s" $arrayName $keyName]
              # puts "          <D> -> got xPath  $arrayName $keyName"
            return [list $arrayName $keyName $xPath]
        }
        #
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
           
		# print
		
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



