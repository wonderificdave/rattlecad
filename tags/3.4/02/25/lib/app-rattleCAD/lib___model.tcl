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

	# variable  modelDICT         {} ;# a dictionary
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
    variable geometry_IF   ::bikeGeometry::IF_Default
      
      # ----------------- #	
    namespace import ::bikeGeometry::set_newProject
    namespace import ::bikeGeometry::get_projectDOM
    namespace import ::bikeGeometry::get_projectDICT
        # expired namespace import ::bikeGeometry::get_Value 
        # expired namespace import ::bikeGeometry::get_Object
        # expired namespace import ::bikeGeometry::get_toRefactor
        #
        #
    namespace import ::bikeGeometry::import_ProjectSubset
        #
    namespace import ::bikeGeometry::get_Component
    namespace import ::bikeGeometry::get_Config
    namespace import ::bikeGeometry::get_ListValue
    namespace import ::bikeGeometry::get_Scalar
        #
    namespace import ::bikeGeometry::set_Component
    namespace import ::bikeGeometry::set_Config
    namespace import ::bikeGeometry::set_ListValue
    # namespace import ::bikeGeometry::set_Scalar        
        #
    namespace import ::bikeGeometry::get_Polygon
    namespace import ::bikeGeometry::get_Position
    namespace import ::bikeGeometry::get_Direction
    namespace import ::bikeGeometry::get_BoundingBox
    namespace import ::bikeGeometry::get_TubeMiter
    namespace import ::bikeGeometry::get_CenterLine
        #
    namespace import ::bikeGeometry::get_ComponentDir 
    namespace import ::bikeGeometry::get_ComponentDirectories
    namespace import ::bikeGeometry::get_ListBoxValues 
        #
    namespace import ::bikeGeometry::get_DebugGeometry
    namespace import ::bikeGeometry::get_ReynoldsFEAContent    
        #
    namespace import ::bikeGeometry::coords_xy_index
        #
        # expired namespace import ::bikeGeometry::set_Value
        # expired namespace import ::bikeGeometry::set_resultParameter   
        #
}
	
    
    proc rattleCAD::model::set_Scalar {object key value} {
            #
        variable  geometry_IF
        return  [$geometry_IF set_Scalar ${object} ${key} ${value}]
            #
    }
    proc rattleCAD::model::set_geometry_IF {interfaceName} {
            #
        variable  geometry_IF
            #
        set last_IF $geometry_IF
            #
        puts "\n"
        puts "    =========== rattleCAD::model::set_geometry_IF ==============-start-=="
            #
        switch -exact $interfaceName {
                {Classic}       {set geometry_IF ::bikeGeometry::IF_Classic}
                {Default}       {set geometry_IF ::bikeGeometry::IF_Default}
                {Lugs}          {set geometry_IF ::bikeGeometry::IF_LugAngles}
                {StackReach}    {set geometry_IF ::bikeGeometry::IF_StackReach}
                default         {}
        }
            #
        puts "          <I> new Interface: $geometry_IF"
        puts ""
        foreach {subcmd proc} [namespace ensemble configure $geometry_IF -map] {
                    puts [format {                   %-30s %-20s  <- %s }     $subcmd [info args $proc] $proc ]
                }
        puts ""
        puts "    =========== rattleCAD::model::set_geometry_IF ================-end-=="
        puts "\n"
            #
        if {$last_IF != $geometry_IF} {
                # puts " ... $last_IF != $geometry_IF  -> 1"
            return 1
        } else {
                # puts " ... $last_IF == $geometry_IF  -> 0"
            return 0
        }
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

	proc rattleCAD::model::newProject {projectDOM} {
		puts "\n"
		puts "   -------------------------------"
		puts "    rattleCAD::control::newProject"
		
		  #
		set_newProject $projectDOM	
		# bikeGeometry::set_newProject $projectDOM	
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
		import_ProjectSubset $nodeRoot	
		# bikeGeometry::import_ProjectSubset $nodeRoot	
		  #
		  
		  #
		[namespace current]::updateModel
		  #
    }	

	
	
	
	proc rattleCAD::model::unifyKey {key} {
        
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
        set dict_ListBoxValues [get_ListBoxValues]
        # set dict_ListBoxValues [bikeGeometry::get_ListBoxValues]
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

    proc rattleCAD::model::get_keyListBoxValues {key} {
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
    }

        # -- unused or expired ----------
        #   
    proc rattleCAD::model::getDictValue {xpath {format {value}} args} {
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

