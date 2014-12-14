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
    namespace import ::bikeGeometry::get_TubeMiter
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
    
    proc rattleCAD::model::debug_getValue {} {
 
            rattleCAD::model::getValue Component/BottleCage/DownTube/OffsetBB
            rattleCAD::model::getValue Component/BottleCage/DownTube_Lower/OffsetBB
            rattleCAD::model::getValue Component/BottleCage/SeatTube/OffsetBB
            rattleCAD::model::getValue Component/Brake/Front/File
            rattleCAD::model::getValue Component/Brake/Front/LeverLength
            rattleCAD::model::getValue Component/Brake/Front/Offset
            rattleCAD::model::getValue Component/Brake/Rear/File
            rattleCAD::model::getValue Component/Brake/Rear/LeverLength
            rattleCAD::model::getValue Component/Brake/Rear/Offset
            rattleCAD::model::getValue Component/Carrier/Front/File
            rattleCAD::model::getValue Component/Carrier/Front/x
            rattleCAD::model::getValue Component/Carrier/Front/y
            rattleCAD::model::getValue Component/Carrier/Rear/File
            rattleCAD::model::getValue Component/Carrier/Rear/x
            rattleCAD::model::getValue Component/Carrier/Rear/y
            rattleCAD::model::getValue Component/CrankSet/ArmWidth
            rattleCAD::model::getValue Component/CrankSet/ChainLine
            rattleCAD::model::getValue Component/CrankSet/ChainLineComponent/CrankSet/Q-Factor
            rattleCAD::model::getValue Component/CrankSet/ChainRings
            rattleCAD::model::getValue Component/CrankSet/File
            rattleCAD::model::getValue Component/CrankSet/Length
            rattleCAD::model::getValue Component/CrankSet/PedalEye
            rattleCAD::model::getValue Component/CrankSet/Q-Factor
            rattleCAD::model::getValue Component/Derailleur/Front/Distance
            rattleCAD::model::getValue Component/Derailleur/Front/File
            rattleCAD::model::getValue Component/Derailleur/Front/Offset
            rattleCAD::model::getValue Component/Derailleur/Rear/File
            rattleCAD::model::getValue Component/Derailleur/Rear/Pulley/teeth
            rattleCAD::model::getValue Component/Derailleur/Rear/Pulley/x
            rattleCAD::model::getValue Component/Derailleur/Rear/Pulley/y
            rattleCAD::model::getValue Component/Fender/Front/Height
            rattleCAD::model::getValue Component/Fender/Front/OffsetAngle
            rattleCAD::model::getValue Component/Fender/Front/OffsetAngleFront
            rattleCAD::model::getValue Component/Fender/Front/Radius
            rattleCAD::model::getValue Component/Fender/Rear/Height
            rattleCAD::model::getValue Component/Fender/Rear/OffsetAngle
            rattleCAD::model::getValue Component/Fender/Rear/Radius
            rattleCAD::model::getValue Component/Fork/Blade/BendRadius
            rattleCAD::model::getValue Component/Fork/Blade/DiameterDO
            rattleCAD::model::getValue Component/Fork/Blade/EndLength
            rattleCAD::model::getValue Component/Fork/Blade/TaperLength
            rattleCAD::model::getValue Component/Fork/Blade/Width
            rattleCAD::model::getValue Component/Fork/Crown/Blade/Offset
            rattleCAD::model::getValue Component/Fork/Crown/Blade/OffsetPerp
            rattleCAD::model::getValue Component/Fork/Crown/Brake/Angle
            rattleCAD::model::getValue Component/Fork/Crown/Brake/Offset
            rattleCAD::model::getValue Component/Fork/Crown/File
            rattleCAD::model::getValue Component/Fork/DropOut/File
            rattleCAD::model::getValue Component/Fork/DropOut/Offset
            rattleCAD::model::getValue Component/Fork/DropOut/OffsetPerp
            rattleCAD::model::getValue Component/Fork/Height
            rattleCAD::model::getValue Component/Fork/Rake
            rattleCAD::model::getValue Component/HandleBar/File
            rattleCAD::model::getValue Component/HandleBar/PivotAngle
            rattleCAD::model::getValue Component/HeadSet/Diameter
            rattleCAD::model::getValue Component/HeadSet/Height/Bottom
            rattleCAD::model::getValue Component/HeadSet/Height/Top
            rattleCAD::model::getValue Component/Logo/File
            rattleCAD::model::getValue Component/Saddle/File
            rattleCAD::model::getValue Component/Saddle/Height
            rattleCAD::model::getValue Component/Saddle/LengthNose
            rattleCAD::model::getValue Component/SeatPost/Diameter
            rattleCAD::model::getValue Component/SeatPost/PivotOffset
            rattleCAD::model::getValue Component/SeatPost/Setback
            rattleCAD::model::getValue Component/Stem/Angle
            rattleCAD::model::getValue Component/Stem/Length
            rattleCAD::model::getValue Component/Wheel/Front/RimDiameter
            rattleCAD::model::getValue Component/Wheel/Front/RimHeight
            rattleCAD::model::getValue Component/Wheel/Front/TyreHeight
            rattleCAD::model::getValue Component/Wheel/Rear/FirstSprocket
            rattleCAD::model::getValue Component/Wheel/Rear/HubWidth
            rattleCAD::model::getValue Component/Wheel/Rear/RimDiameter
            rattleCAD::model::getValue Component/Wheel/Rear/RimHeight
            rattleCAD::model::getValue Component/Wheel/Rear/TyreWidth
            rattleCAD::model::getValue Component/Wheel/Rear/TyreWidthRadius
            rattleCAD::model::getValue Custom/BottomBracket/Depth
            rattleCAD::model::getValue Custom/DownTube/OffsetBB
            rattleCAD::model::getValue Custom/DownTube/OffsetHT
            rattleCAD::model::getValue Custom/HeadTube/Angle
            rattleCAD::model::getValue Custom/SeatStay/OffsetTT
            rattleCAD::model::getValue Custom/SeatTube/Extension
            rattleCAD::model::getValue Custom/SeatTube/OffsetBB
            rattleCAD::model::getValue Custom/TopTube/Angle
            rattleCAD::model::getValue Custom/TopTube/OffsetHT
            rattleCAD::model::getValue Custom/TopTube/PivotPosition
            rattleCAD::model::getValue Custom/WheelPosition/Rear
            rattleCAD::model::getValue FrameTubes/ChainStay/CenterLine/angle_01
            rattleCAD::model::getValue FrameTubes/ChainStay/CenterLine/angle_02
            rattleCAD::model::getValue FrameTubes/ChainStay/CenterLine/angle_03
            rattleCAD::model::getValue FrameTubes/ChainStay/CenterLine/angle_04
            rattleCAD::model::getValue FrameTubes/ChainStay/CenterLine/length_01
            rattleCAD::model::getValue FrameTubes/ChainStay/CenterLine/length_02
            rattleCAD::model::getValue FrameTubes/ChainStay/CenterLine/length_03
            rattleCAD::model::getValue FrameTubes/ChainStay/CenterLine/length_04
            rattleCAD::model::getValue FrameTubes/ChainStay/CenterLine/radius_01
            rattleCAD::model::getValue FrameTubes/ChainStay/CenterLine/radius_02
            rattleCAD::model::getValue FrameTubes/ChainStay/CenterLine/radius_03
            rattleCAD::model::getValue FrameTubes/ChainStay/CenterLine/radius_04
            rattleCAD::model::getValue FrameTubes/ChainStay/DiameterSS
            rattleCAD::model::getValue FrameTubes/ChainStay/Height
            rattleCAD::model::getValue FrameTubes/ChainStay/HeightBB
            rattleCAD::model::getValue FrameTubes/ChainStay/Profile/completeLength
            rattleCAD::model::getValue FrameTubes/ChainStay/Profile/cuttingLength
            rattleCAD::model::getValue FrameTubes/ChainStay/Profile/length_01
            rattleCAD::model::getValue FrameTubes/ChainStay/Profile/length_02
            rattleCAD::model::getValue FrameTubes/ChainStay/Profile/length_03
            rattleCAD::model::getValue FrameTubes/ChainStay/Profile/width_00
            rattleCAD::model::getValue FrameTubes/ChainStay/Profile/width_01
            rattleCAD::model::getValue FrameTubes/ChainStay/Profile/width_02
            rattleCAD::model::getValue FrameTubes/ChainStay/Profile/width_03
            rattleCAD::model::getValue FrameTubes/ChainStay/TaperLength
            rattleCAD::model::getValue FrameTubes/DownTube/DiameterBB
            rattleCAD::model::getValue FrameTubes/DownTube/DiameterHT
            rattleCAD::model::getValue FrameTubes/DownTube/TaperLength
            rattleCAD::model::getValue FrameTubes/HeadTube/Diameter
            rattleCAD::model::getValue FrameTubes/HeadTube/Length
            rattleCAD::model::getValue FrameTubes/SeatStay/DiameterCS
            rattleCAD::model::getValue FrameTubes/SeatStay/DiameterST
            rattleCAD::model::getValue FrameTubes/SeatStay/TaperLength
            rattleCAD::model::getValue FrameTubes/SeatTube/DiameterBB
            rattleCAD::model::getValue FrameTubes/SeatTube/DiameterTT
            rattleCAD::model::getValue FrameTubes/SeatTube/TaperLength
            rattleCAD::model::getValue FrameTubes/TopTube/DiameterHT
            rattleCAD::model::getValue FrameTubes/TopTube/DiameterST
            rattleCAD::model::getValue FrameTubes/TopTube/TaperLength
            rattleCAD::model::getValue Lugs/BottomBracket/ChainStay/Angle/plus_minus
            rattleCAD::model::getValue Lugs/BottomBracket/ChainStay/Angle/value
            rattleCAD::model::getValue Lugs/BottomBracket/ChainStay/Offset_TopView
            rattleCAD::model::getValue Lugs/BottomBracket/Diameter/inside
            rattleCAD::model::getValue Lugs/BottomBracket/Diameter/outside
            rattleCAD::model::getValue Lugs/BottomBracket/DownTube/Angle/plus_minus
            rattleCAD::model::getValue Lugs/BottomBracket/DownTube/Angle/value
            rattleCAD::model::getValue Lugs/BottomBracket/Width
            rattleCAD::model::getValue Lugs/HeadTube/DownTube/Angle/plus_minus
            rattleCAD::model::getValue Lugs/HeadTube/DownTube/Angle/value
            rattleCAD::model::getValue Lugs/HeadTube/TopTube/Angle/plus_minus
            rattleCAD::model::getValue Lugs/HeadTube/TopTube/Angle/value
            rattleCAD::model::getValue Lugs/RearDropOut/Angle/plus_minus
            rattleCAD::model::getValue Lugs/RearDropOut/Angle/value
            rattleCAD::model::getValue Lugs/RearDropOut/ChainStay/Offset
            rattleCAD::model::getValue Lugs/RearDropOut/ChainStay/OffsetPerp
            rattleCAD::model::getValue Lugs/RearDropOut/ChainStay/Offset_TopView
            rattleCAD::model::getValue Lugs/RearDropOut/Derailleur/x
            rattleCAD::model::getValue Lugs/RearDropOut/Derailleur/y
            rattleCAD::model::getValue Lugs/RearDropOut/Direction
            rattleCAD::model::getValue Lugs/RearDropOut/File
            rattleCAD::model::getValue Lugs/RearDropOut/RotationOffset
            rattleCAD::model::getValue Lugs/RearDropOut/SeatStay/Offset
            rattleCAD::model::getValue Lugs/RearDropOut/SeatStay/OffsetPerp
            rattleCAD::model::getValue Lugs/SeatTube/SeatStay/Angle/plus_minus
            rattleCAD::model::getValue Lugs/SeatTube/SeatStay/Angle/value
            rattleCAD::model::getValue Lugs/SeatTube/SeatStay/MiterDiameter
            rattleCAD::model::getValue Lugs/SeatTube/TopTube/Angle/plus_minus
            rattleCAD::model::getValue Lugs/SeatTube/TopTube/Angle/value
            rattleCAD::model::getValue Personal/HandleBar_Distance
            rattleCAD::model::getValue Personal/HandleBar_Height
            rattleCAD::model::getValue Personal/InnerLeg_Length
            rattleCAD::model::getValue Personal/Saddle_Distance
            rattleCAD::model::getValue Personal/Saddle_Height
            rattleCAD::model::getValue Reference/HandleBar_Distance
            rattleCAD::model::getValue Reference/HandleBar_Height
            rattleCAD::model::getValue Reference/SaddleNose_Distance
            rattleCAD::model::getValue Reference/SaddleNose_Height
            rattleCAD::model::getValue Rendering/BottleCage/DownTube
            rattleCAD::model::getValue Rendering/BottleCage/DownTube_Lower
            rattleCAD::model::getValue Rendering/BottleCage/SeatTube
            rattleCAD::model::getValue Rendering/Brake/Front
            rattleCAD::model::getValue Rendering/Brake/Rear
            rattleCAD::model::getValue Rendering/ChainStay
            rattleCAD::model::getValue Rendering/Fender/Front
            rattleCAD::model::getValue Rendering/Fender/Rear
            rattleCAD::model::getValue Rendering/Fork
            rattleCAD::model::getValue Rendering/ForkBlade
            rattleCAD::model::getValue Rendering/ForkDropOut
            rattleCAD::model::getValue Rendering/RearDropOut
            rattleCAD::model::getValue Rendering/RearMockup/CassetteClearance
            rattleCAD::model::getValue Rendering/RearMockup/ChainWheelClearance
            rattleCAD::model::getValue Rendering/RearMockup/CrankClearance
            rattleCAD::model::getValue Rendering/RearMockup/DiscClearance
            rattleCAD::model::getValue Rendering/RearMockup/DiscDiameter
            rattleCAD::model::getValue Rendering/RearMockup/DiscOffset
            rattleCAD::model::getValue Rendering/RearMockup/DiscWidth
            rattleCAD::model::getValue Rendering/RearMockup/TyreClearance
            rattleCAD::model::getValue Rendering/Saddle/Offset_X
            rattleCAD::model::getValue Rendering/Saddle/Offset_Y
            rattleCAD::model::getValue Result/Angle/HeadTube/TopTube
            rattleCAD::model::getValue Result/Angle/SeatTube/Direction
            rattleCAD::model::getValue Result/Length/BottomBracket/Height
            rattleCAD::model::getValue Result/Length/FrontWheel/Radius
            rattleCAD::model::getValue Result/Length/FrontWheel/diagonal
            rattleCAD::model::getValue Result/Length/FrontWheel/horizontal
            rattleCAD::model::getValue Result/Length/HeadTube/ReachLength
            rattleCAD::model::getValue Result/Length/HeadTube/StackHeight
            rattleCAD::model::getValue Result/Length/Personal/SaddleNose_HB
            rattleCAD::model::getValue Result/Length/RearWheel/Radius
            rattleCAD::model::getValue Result/Length/RearWheel/TyreShoulder
            rattleCAD::model::getValue Result/Length/RearWheel/horizontal
            rattleCAD::model::getValue Result/Length/Reference/Heigth_SN_HB
            rattleCAD::model::getValue Result/Length/Reference/SaddleNose_HB
            rattleCAD::model::getValue Result/Length/Saddle/Offset_BB_Nose
            rattleCAD::model::getValue Result/Length/Saddle/Offset_BB_ST
            rattleCAD::model::getValue Result/Length/Saddle/Offset_HB
            rattleCAD::model::getValue Result/Length/Saddle/SeatTube_BB
            rattleCAD::model::getValue Result/Length/SeatTube/VirtualLength
            rattleCAD::model::getValue Result/Length/TopTube/VirtualLength    
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
	


