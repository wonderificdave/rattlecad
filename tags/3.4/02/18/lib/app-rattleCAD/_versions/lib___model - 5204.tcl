##+##########################################################################
#
# package: rattleCAD    ->    lib__model.tcl
#
#   canvasCAD is software of Manfred ROSENBERGER
#       based on tclTk, BWidgets and tdom on their 
#       own Licenses.
# 
# Copyright (c) Manfred ROSENBERGER, 2014/01/11
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
#    namespace:  rattleCAD::model
# ---------------------------------------------------------------------------
#
# 
# --- this is the interface to the bikeGeometry - namespace
#

namespace eval rattleCAD::model {

	variable  modelDICT         {} ;# a dictionary
    variable  modelDOM          {} ;# a XML-Object
      # ----------------- #	    
    variable  modelUpdate       {0}
      # ----------------- #	
    variable  compRegistry 
    array set compRegistry       {}
      # ----------------- #	
    variable  valueRegistry 
    array set valueRegistry      {}
    
      # ----------------- #	
    namespace import ::bikeGeometry::set_newProject
    namespace import ::bikeGeometry::get_projectDOM
    namespace import ::bikeGeometry::get_projectDICT
        #
    namespace import ::bikeGeometry::import_ProjectSubset
        #
    namespace import ::bikeGeometry::get_Value 
    namespace import ::bikeGeometry::get_Scalar
    namespace import ::bikeGeometry::get_Object
    namespace import ::bikeGeometry::get_Polygon
    namespace import ::bikeGeometry::get_Position
    namespace import ::bikeGeometry::get_Direction
    namespace import ::bikeGeometry::get_Config
    namespace import ::bikeGeometry::get_Component
    namespace import ::bikeGeometry::get_BoundingBox
        #
    namespace import ::bikeGeometry::get_ComponentDir 
    namespace import ::bikeGeometry::get_ComponentDirectories
    namespace import ::bikeGeometry::get_ListBoxValues 
        #
    namespace import ::bikeGeometry::get_toRefactor
    namespace import ::bikeGeometry::set_Value
    namespace import ::bikeGeometry::set_resultParameter   
        #
}
	
    proc rattleCAD::model::updateModel {} {
		variable modelDICT
		variable modelDOM
		variable modelUpdate 

	
		  # update control-model
		set      modelDICT  [get_projectDICT]
		set      modelDOM   [get_projectDOM]
	
		
          # update timestamp
		set modelUpdate     [clock milliseconds]
          # set ::APPL_Config(canvasCAD_Update) [clock milliseconds]
          #

	}

	proc rattleCAD::model::remove_setValue_remove {xpath value {mode {update}}} {

		puts "   -------------------------------"
		puts "    rattleCAD::model::setValue"
		puts "       $xpath / $value"
		  
		if {$mode == {update}} {
		    set newValue  [[namespace current]::set_Value $xpath ${value}]
		} else {
		    set newValue  [[namespace current]::set_Value $xpath ${value} $mode]
		}
		  
		  #
		[namespace current]::updateModel
		  #
		
		  #
		return ${newValue}
		  #
	}

    proc rattleCAD::model::getValue {xpath {format {value}} args} {
	       # key type args
		variable modelDICT
        
        puts $::APPL_Config(LogFile) "$xpath <- $format $args"
		
		set value     [appUtil::get_dictValue $modelDICT $xpath]
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
		return ${value}
	} 

    proc rattleCAD::model::getObject {object index {centerPoint {0 0}} } {
        return [bikeGeometry::get_Object $object $index $centerPoint]
    }

    proc rattleCAD::model::getComponentDir {} {
        return [bikeGeometry::get_ComponentDir]
    }

    proc rattleCAD::model::getComponentDirectories {} {
        return [bikeGeometry::get_ComponentDirectories]
    }

    proc rattleCAD::model::coords_get_xy {coordlist index} {
        return [bikeGeometry::coords_get_xy $coordlist $index]
    }

	proc rattleCAD::model::newProject {projectDOM} {
		puts "\n"
		puts "   -------------------------------"
		puts "    rattleCAD::control::newProject"
		
		  #
		bikeGeometry::set_newProject $projectDOM	
		  #
		  
		  # update View
		[namespace current]::updateModel
          #
    }

	proc rattleCAD::model::importSubset {nodeRoot} {
			# puts "[$nodeRoot asXML]"
		puts "\n"
		puts "   -------------------------------"
		puts "    rattleCAD::model::importSubset"
		
		  #
		bikeGeometry::import_ProjectSubset $nodeRoot	
		  #
		  
		  #
		[namespace current]::updateModel
		  #
    }	

	
	
	
	proc rattleCAD::model::unifyKey {key} {
        
        package require appUtil 0.9
        # rattleCAD::model::unifyKey
        
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
    }



	#-------------------------------------------------------------------------
        #  return all geometry-values to create specified tube in absolute position
    proc rattleCAD::model::init_ListBoxValues {root_InitDOM} {    
            #
        variable valueRegistry
            #
        set dict_ListBoxValues [bikeGeometry::get_ListBoxValues]
            #
        #puts $dict_ListBoxValues
            #
        foreach key [dict keys $dict_ListBoxValues] {
            set keyDict             [dict get $dict_ListBoxValues $key]
            switch -exact $key {
                ComponentLocation {
                        set valueRegistry($key) $keyDict
                    }
                default {
                        set valueRegistry($key) $keyDict
                    }
            }
            
        }
            #
        # parray valueRegistry
            #
        # exit
            #
        return
            #
     }    

    
    proc rattleCAD::model::get_ListBoxValues {key} {
            #
        variable valueRegistry
            #
        set returnValue [set valueRegistry($key)]
          #
        foreach value $returnValue {
            puts "       -> get_ListBoxValues: $value"
        }
          #
        return $returnValue
          #        
    }

    proc rattleCAD::model::get_ComponentList {key} {
          #
        variable compRegistry 
          #
        puts "      ...   get_ComponentList $key"
          #
        set compList [rattleCAD::model::file::get_componentAlternatives  $key]
        return $compList
          #
          
          
          #
        foreach listEntry $compList {
              # puts "         ... $listEntry"
            foreach {domain reference} [split $listEntry :] break 
            set referenceDirName   [file dirname  $reference]
            set referenceFileName  [file tail     $reference]
              # puts "           ... $domain  $reference    -> $referenceDirName / $referenceFileName"
            set myKey       [format "%s:%s  ... %s" $domain $referenceFileName $referenceDirName]
            set compRegistry($myKey) $listEntry
            lappend refList [list $myKey  $listEntry]
            lappend myList  $myKey
        }
        set listBoxContent $myList
        foreach listEntry $refList {
            puts "         ... $listEntry"
        }
        parray compRegistry
          #        

          #
        return $myList
          #
    }	
	


