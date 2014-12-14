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
    namespace import ::bikeGeometry::get_Scalar
    namespace import ::bikeGeometry::get_Polygon
    namespace import ::bikeGeometry::get_Position
    namespace import ::bikeGeometry::get_Direction
    namespace import ::bikeGeometry::get_Config
    namespace import ::bikeGeometry::get_Component
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

    proc rattleCAD::model::debug_getValue {} {
 
            rattleCAD::model::getDictValue    Component/BottleCage/DownTube/OffsetBB
            rattleCAD::model::getDictValue    Component/BottleCage/DownTube_Lower/OffsetBB
            rattleCAD::model::getDictValue    Component/BottleCage/SeatTube/OffsetBB
            rattleCAD::model::getDictValue    Component/Brake/Front/File
            rattleCAD::model::getDictValue    Component/Brake/Front/LeverLength
            rattleCAD::model::getDictValue    Component/Brake/Front/Offset
            rattleCAD::model::getDictValue    Component/Brake/Rear/File
            rattleCAD::model::getDictValue    Component/Brake/Rear/LeverLength
            rattleCAD::model::getDictValue    Component/Brake/Rear/Offset
            rattleCAD::model::getDictValue    Component/Carrier/Front/File
            rattleCAD::model::getDictValue    Component/Carrier/Front/x
            rattleCAD::model::getDictValue    Component/Carrier/Front/y
            rattleCAD::model::getDictValue    Component/Carrier/Rear/File
            rattleCAD::model::getDictValue    Component/Carrier/Rear/x
            rattleCAD::model::getDictValue    Component/Carrier/Rear/y
            rattleCAD::model::getDictValue    Component/CrankSet/ArmWidth
            rattleCAD::model::getDictValue    Component/CrankSet/ChainLine
            rattleCAD::model::getDictValue    Component/CrankSet/ChainLineComponent/CrankSet/Q-Factor
            rattleCAD::model::getDictValue    Component/CrankSet/ChainRings
            rattleCAD::model::getDictValue    Component/CrankSet/File
            rattleCAD::model::getDictValue    Component/CrankSet/Length
            rattleCAD::model::getDictValue    Component/CrankSet/PedalEye
            rattleCAD::model::getDictValue    Component/CrankSet/Q-Factor
            rattleCAD::model::getDictValue    Component/Derailleur/Front/Distance
            rattleCAD::model::getDictValue    Component/Derailleur/Front/File
            rattleCAD::model::getDictValue    Component/Derailleur/Front/Offset
            rattleCAD::model::getDictValue    Component/Derailleur/Rear/File
            rattleCAD::model::getDictValue    Component/Derailleur/Rear/Pulley/teeth
            rattleCAD::model::getDictValue    Component/Derailleur/Rear/Pulley/x
            rattleCAD::model::getDictValue    Component/Derailleur/Rear/Pulley/y
            rattleCAD::model::getDictValue    Component/Fender/Front/Height
            rattleCAD::model::getDictValue    Component/Fender/Front/OffsetAngle
            rattleCAD::model::getDictValue    Component/Fender/Front/OffsetAngleFront
            rattleCAD::model::getDictValue    Component/Fender/Front/Radius
            rattleCAD::model::getDictValue    Component/Fender/Rear/Height
            rattleCAD::model::getDictValue    Component/Fender/Rear/OffsetAngle
            rattleCAD::model::getDictValue    Component/Fender/Rear/Radius
            rattleCAD::model::getDictValue    Component/Fork/Blade/BendRadius
            rattleCAD::model::getDictValue    Component/Fork/Blade/DiameterDO
            rattleCAD::model::getDictValue    Component/Fork/Blade/EndLength
            rattleCAD::model::getDictValue    Component/Fork/Blade/TaperLength
            rattleCAD::model::getDictValue    Component/Fork/Blade/Width
            rattleCAD::model::getDictValue    Component/Fork/Crown/Blade/Offset
            rattleCAD::model::getDictValue    Component/Fork/Crown/Blade/OffsetPerp
            rattleCAD::model::getDictValue    Component/Fork/Crown/Brake/Angle
            rattleCAD::model::getDictValue    Component/Fork/Crown/Brake/Offset
            rattleCAD::model::getDictValue    Component/Fork/Crown/File
            rattleCAD::model::getDictValue    Component/Fork/DropOut/File
            rattleCAD::model::getDictValue    Component/Fork/DropOut/Offset
            rattleCAD::model::getDictValue    Component/Fork/DropOut/OffsetPerp
            rattleCAD::model::getDictValue    Component/Fork/Height
            rattleCAD::model::getDictValue    Component/Fork/Rake
            rattleCAD::model::getDictValue    Component/HandleBar/File
            rattleCAD::model::getDictValue    Component/HandleBar/PivotAngle
            rattleCAD::model::getDictValue    Component/HeadSet/Diameter
            rattleCAD::model::getDictValue    Component/HeadSet/Height/Bottom
            rattleCAD::model::getDictValue    Component/HeadSet/Height/Top
            rattleCAD::model::getDictValue    Component/Logo/File
            rattleCAD::model::getDictValue    Component/Saddle/File
            rattleCAD::model::getDictValue    Component/Saddle/Height
            rattleCAD::model::getDictValue    Component/Saddle/LengthNose
            rattleCAD::model::getDictValue    Component/SeatPost/Diameter
            rattleCAD::model::getDictValue    Component/SeatPost/PivotOffset
            rattleCAD::model::getDictValue    Component/SeatPost/Setback
            rattleCAD::model::getDictValue    Component/Stem/Angle
            rattleCAD::model::getDictValue    Component/Stem/Length
            rattleCAD::model::getDictValue    Component/Wheel/Front/RimDiameter
            rattleCAD::model::getDictValue    Component/Wheel/Front/RimHeight
            rattleCAD::model::getDictValue    Component/Wheel/Front/TyreHeight
            rattleCAD::model::getDictValue    Component/Wheel/Rear/FirstSprocket
            rattleCAD::model::getDictValue    Component/Wheel/Rear/HubWidth
            rattleCAD::model::getDictValue    Component/Wheel/Rear/RimDiameter
            rattleCAD::model::getDictValue    Component/Wheel/Rear/RimHeight
            rattleCAD::model::getDictValue    Component/Wheel/Rear/TyreWidth
            rattleCAD::model::getDictValue    Component/Wheel/Rear/TyreWidthRadius
            rattleCAD::model::getDictValue    Custom/BottomBracket/Depth
            rattleCAD::model::getDictValue    Custom/DownTube/OffsetBB
            rattleCAD::model::getDictValue    Custom/DownTube/OffsetHT
            rattleCAD::model::getDictValue    Custom/HeadTube/Angle
            rattleCAD::model::getDictValue    Custom/SeatStay/OffsetTT
            rattleCAD::model::getDictValue    Custom/SeatTube/Extension
            rattleCAD::model::getDictValue    Custom/SeatTube/OffsetBB
            rattleCAD::model::getDictValue    Custom/TopTube/Angle
            rattleCAD::model::getDictValue    Custom/TopTube/OffsetHT
            rattleCAD::model::getDictValue    Custom/TopTube/PivotPosition
            rattleCAD::model::getDictValue    Custom/WheelPosition/Rear
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/CenterLine/angle_01
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/CenterLine/angle_02
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/CenterLine/angle_03
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/CenterLine/angle_04
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/CenterLine/length_01
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/CenterLine/length_02
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/CenterLine/length_03
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/CenterLine/length_04
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/CenterLine/radius_01
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/CenterLine/radius_02
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/CenterLine/radius_03
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/CenterLine/radius_04
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/DiameterSS
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/Height
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/HeightBB
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/Profile/completeLength
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/Profile/cuttingLength
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/Profile/length_01
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/Profile/length_02
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/Profile/length_03
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/Profile/width_00
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/Profile/width_01
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/Profile/width_02
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/Profile/width_03
            rattleCAD::model::getDictValue    FrameTubes/ChainStay/TaperLength
            rattleCAD::model::getDictValue    FrameTubes/DownTube/DiameterBB
            rattleCAD::model::getDictValue    FrameTubes/DownTube/DiameterHT
            rattleCAD::model::getDictValue    FrameTubes/DownTube/TaperLength
            rattleCAD::model::getDictValue    FrameTubes/HeadTube/Diameter
            rattleCAD::model::getDictValue    FrameTubes/HeadTube/Length
            rattleCAD::model::getDictValue    FrameTubes/SeatStay/DiameterCS
            rattleCAD::model::getDictValue    FrameTubes/SeatStay/DiameterST
            rattleCAD::model::getDictValue    FrameTubes/SeatStay/TaperLength
            rattleCAD::model::getDictValue    FrameTubes/SeatTube/DiameterBB
            rattleCAD::model::getDictValue    FrameTubes/SeatTube/DiameterTT
            rattleCAD::model::getDictValue    FrameTubes/SeatTube/TaperLength
            rattleCAD::model::getDictValue    FrameTubes/TopTube/DiameterHT
            rattleCAD::model::getDictValue    FrameTubes/TopTube/DiameterST
            rattleCAD::model::getDictValue    FrameTubes/TopTube/TaperLength
            rattleCAD::model::getDictValue    Lugs/BottomBracket/ChainStay/Angle/plus_minus
            rattleCAD::model::getDictValue    Lugs/BottomBracket/ChainStay/Angle/value
            rattleCAD::model::getDictValue    Lugs/BottomBracket/ChainStay/Offset_TopView
            rattleCAD::model::getDictValue    Lugs/BottomBracket/Diameter/inside
            rattleCAD::model::getDictValue    Lugs/BottomBracket/Diameter/outside
            rattleCAD::model::getDictValue    Lugs/BottomBracket/DownTube/Angle/plus_minus
            rattleCAD::model::getDictValue    Lugs/BottomBracket/DownTube/Angle/value
            rattleCAD::model::getDictValue    Lugs/BottomBracket/Width
            rattleCAD::model::getDictValue    Lugs/HeadTube/DownTube/Angle/plus_minus
            rattleCAD::model::getDictValue    Lugs/HeadTube/DownTube/Angle/value
            rattleCAD::model::getDictValue    Lugs/HeadTube/TopTube/Angle/plus_minus
            rattleCAD::model::getDictValue    Lugs/HeadTube/TopTube/Angle/value
            rattleCAD::model::getDictValue    Lugs/RearDropOut/Angle/plus_minus
            rattleCAD::model::getDictValue    Lugs/RearDropOut/Angle/value
            rattleCAD::model::getDictValue    Lugs/RearDropOut/ChainStay/Offset
            rattleCAD::model::getDictValue    Lugs/RearDropOut/ChainStay/OffsetPerp
            rattleCAD::model::getDictValue    Lugs/RearDropOut/ChainStay/Offset_TopView
            rattleCAD::model::getDictValue    Lugs/RearDropOut/Derailleur/x
            rattleCAD::model::getDictValue    Lugs/RearDropOut/Derailleur/y
            rattleCAD::model::getDictValue    Lugs/RearDropOut/Direction
            rattleCAD::model::getDictValue    Lugs/RearDropOut/File
            rattleCAD::model::getDictValue    Lugs/RearDropOut/RotationOffset
            rattleCAD::model::getDictValue    Lugs/RearDropOut/SeatStay/Offset
            rattleCAD::model::getDictValue    Lugs/RearDropOut/SeatStay/OffsetPerp
            rattleCAD::model::getDictValue    Lugs/SeatTube/SeatStay/Angle/plus_minus
            rattleCAD::model::getDictValue    Lugs/SeatTube/SeatStay/Angle/value
            rattleCAD::model::getDictValue    Lugs/SeatTube/SeatStay/MiterDiameter
            rattleCAD::model::getDictValue    Lugs/SeatTube/TopTube/Angle/plus_minus
            rattleCAD::model::getDictValue    Lugs/SeatTube/TopTube/Angle/value
            rattleCAD::model::getDictValue    Personal/HandleBar_Distance
            rattleCAD::model::getDictValue    Personal/HandleBar_Height
            rattleCAD::model::getDictValue    Personal/InnerLeg_Length
            rattleCAD::model::getDictValue    Personal/Saddle_Distance
            rattleCAD::model::getDictValue    Personal/Saddle_Height
            rattleCAD::model::getDictValue    Reference/HandleBar_Distance
            rattleCAD::model::getDictValue    Reference/HandleBar_Height
            rattleCAD::model::getDictValue    Reference/SaddleNose_Distance
            rattleCAD::model::getDictValue    Reference/SaddleNose_Height
            rattleCAD::model::getDictValue    Rendering/BottleCage/DownTube
            rattleCAD::model::getDictValue    Rendering/BottleCage/DownTube_Lower
            rattleCAD::model::getDictValue    Rendering/BottleCage/SeatTube
            rattleCAD::model::getDictValue    Rendering/Brake/Front
            rattleCAD::model::getDictValue    Rendering/Brake/Rear
            rattleCAD::model::getDictValue    Rendering/ChainStay
            rattleCAD::model::getDictValue    Rendering/Fender/Front
            rattleCAD::model::getDictValue    Rendering/Fender/Rear
            rattleCAD::model::getDictValue    Rendering/Fork
            rattleCAD::model::getDictValue    Rendering/ForkBlade
            rattleCAD::model::getDictValue    Rendering/ForkDropOut
            rattleCAD::model::getDictValue    Rendering/RearDropOut
            rattleCAD::model::getDictValue    Rendering/RearMockup/CassetteClearance
            rattleCAD::model::getDictValue    Rendering/RearMockup/ChainWheelClearance
            rattleCAD::model::getDictValue    Rendering/RearMockup/CrankClearance
            rattleCAD::model::getDictValue    Rendering/RearMockup/DiscClearance
            rattleCAD::model::getDictValue    Rendering/RearMockup/DiscDiameter
            rattleCAD::model::getDictValue    Rendering/RearMockup/DiscOffset
            rattleCAD::model::getDictValue    Rendering/RearMockup/DiscWidth
            rattleCAD::model::getDictValue    Rendering/RearMockup/TyreClearance
            rattleCAD::model::getDictValue    Rendering/Saddle/Offset_X
            rattleCAD::model::getDictValue    Rendering/Saddle/Offset_Y
            rattleCAD::model::getDictValue    Result/Angle/HeadTube/TopTube
            rattleCAD::model::getDictValue    Result/Angle/SeatTube/Direction
            rattleCAD::model::getDictValue    Result/Length/BottomBracket/Height
            rattleCAD::model::getDictValue    Result/Length/FrontWheel/Radius
            rattleCAD::model::getDictValue    Result/Length/FrontWheel/diagonal
            rattleCAD::model::getDictValue    Result/Length/FrontWheel/horizontal
            rattleCAD::model::getDictValue    Result/Length/HeadTube/ReachLength
            rattleCAD::model::getDictValue    Result/Length/HeadTube/StackHeight
            rattleCAD::model::getDictValue    Result/Length/Personal/SaddleNose_HB
            rattleCAD::model::getDictValue    Result/Length/RearWheel/Radius
            rattleCAD::model::getDictValue    Result/Length/RearWheel/TyreShoulder
            rattleCAD::model::getDictValue    Result/Length/RearWheel/horizontal
            rattleCAD::model::getDictValue    Result/Length/Reference/Heigth_SN_HB
            rattleCAD::model::getDictValue    Result/Length/Reference/SaddleNose_HB
            rattleCAD::model::getDictValue    Result/Length/Saddle/Offset_BB_Nose
            rattleCAD::model::getDictValue    Result/Length/Saddle/Offset_BB_ST
            rattleCAD::model::getDictValue    Result/Length/Saddle/Offset_HB
            rattleCAD::model::getDictValue    Result/Length/Saddle/SeatTube_BB
            rattleCAD::model::getDictValue    Result/Length/SeatTube/VirtualLength
            rattleCAD::model::getDictValue    Result/Length/TopTube/VirtualLength    
    } 





