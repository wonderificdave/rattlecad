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
        # variable currentDICT
		variable currentDOM
		variable model_Update
			
            # configPanel - Update 
		rattleCAD::control::get_lastValues
            #
        rattleCAD::view::init_configValues		  
		rattleCAD::configPanel::init_configValues
            #
        # parray rattleCAD::view::_lastValue
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
        puts   "    updateControl"
        puts   "   -------------------------------\n"
            #
    
            # 
		return
	}

    proc rattleCAD::control::setValue {xpathValueList {mode {update}} {history {append}}} {
            #
            # -- setValue gets xpath and value as a list
            #           like { xpath1 value1  xpath2 value2  xpath3 value3 ...}
            #
		variable  Session
        variable _lastValue
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
        foreach {xpath value} $xpathValueList {
                    #
                    # puts "   -> xpath = value:   $xpath  $value"
                    # set oldValue [[namespace current]::getValue $xpath]
                    # set oldValue [bikeGeometry::get_Value_expired $xpath value]
                    # set oldValue [rattleCAD::model::get_Value_expired $xpath value]
                    # puts "  -> $oldValue  <- $xpath"
                set oldValue [lindex [array get _lastValue $xpath] 1]
                    # puts "  -> $oldValue"
                    
                puts "   -------------------------------"
                puts "    rattleCAD::control::setValue"
                puts "          ... $mode/$history"
                puts "       xpath:  $oldValue / $value"
                
                if {$value == $oldValue} { 
                    puts "         ... equal values!"
                    puts "   -------------------------------"
                    continue
                }

                    # -- Project/* does not influence the model
                switch -glob $xpath {
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
                            set newValue  [rattleCAD::model::set_Value $xpath ${value}]
                                # set newValue  [rattleCAD::model::setValue $xpath ${value}]
                        }
                    default {
                            tk_messageBox -message "rattleCAD::control::setValue $xpath ${value}   $mode  $history" 
                                # set newValue  [rattleCAD::model::set_Value $xpath ${value}]
                                # set newValue  [bikeGeometry::get_Value_expired $xpath ${value} $mode]
                                # set newValue  [rattleCAD::model::set_Value $xpath ${value} $mode]
                                # set newValue  [rattleCAD::model::setValue $xpath ${value} $mode]
                        }
                }
                    #
                    #
                if {$newValue == {}} {
                    puts "         ... value  \"$value\"  not accepted for  $xpath  ... :\("
                    set rattleCAD::view::_updateValue($xpath) $oldValue
                    catch {eval $cv_VarName   configure -cursor arrow}
                    return
                }
                    #
                    #
                # rattleCAD::model::updateModel
                    #
                    # set value to local model
                    # set newValue [[namespace current]::getValue $xpath]
                # set newValue [lindex [array get _lastValue $xpath] 1]
                    # set newValue [bikeGeometry::get_Value_expired $xpath value]
                    # set newValue [rattleCAD::model::get_Value $xpath value]
                    #
                    # append _editList
                if {$history == {append}} {
                        # ... in case of rattleCAD::model::set_Value did not accept the new Value
                    changeList::append        $xpath $oldValue ${newValue}
                }
                
                    # -- report update xpath
                puts ""
                puts "       \$xpath:     $xpath"
                puts "       \$value:     $value"
                puts "       \$oldValue:  $oldValue"
                puts "       \$newValue:  $newValue"
                puts "     -----------------------------------"
        }
            #
            # update View
		updateControl
            #
            # -- reconfigur cursor
        catch {eval $cv_VarName   configure -cursor arrow}
		  
            # -- after updating Values
            # puts "   -- <D> ----------------------------"
		foreach {xpath value} $xpathValueList {
            puts "          -> $xpath -> $value"
        }
            #
            #
		puts ""
		puts "    rattleCAD::control::setValue"
		puts "          ... $mode/$history"
        puts "   -------------------------------"
            #
		return
            # return $newValue
	
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

    proc rattleCAD::control::get_lastValues {} {
            #
        variable _lastValue
            #
        set _lastValue(Component/BottleCage/DownTube/OffsetBB)                  [rattleCAD::model::get_Scalar           BottleCage DownTube               ]
        set _lastValue(Component/BottleCage/DownTube_Lower/OffsetBB)            [rattleCAD::model::get_Scalar           BottleCage DownTube_Lower         ]
        set _lastValue(Component/BottleCage/SeatTube/OffsetBB)                  [rattleCAD::model::get_Scalar           BottleCage SeatTube               ]
        set _lastValue(Component/Brake/Front/File)                              [rattleCAD::model::get_Component        FrontBrake                        ]
        set _lastValue(Component/Brake/Front/LeverLength)                       [rattleCAD::model::get_Scalar           FrontBrake LeverLength            ]
        set _lastValue(Component/Brake/Front/Offset)                            [rattleCAD::model::get_Scalar           FrontBrake Offset                 ]
        set _lastValue(Component/Brake/Rear/File)                               [rattleCAD::model::get_Component        RearBrake                         ]
        set _lastValue(Component/Brake/Rear/LeverLength)                        [rattleCAD::model::get_Scalar           RearBrake LeverLength             ]
        set _lastValue(Component/Brake/Rear/Offset)                             [rattleCAD::model::get_Scalar           RearBrake Offset                  ]
        set _lastValue(Component/Carrier/Front/File)                            [rattleCAD::model::get_Component        FrontCarrier                      ]
        set _lastValue(Component/Carrier/Front/x)                               [rattleCAD::model::get_Scalar           FrontCarrier x                    ]
        set _lastValue(Component/Carrier/Front/y)                               [rattleCAD::model::get_Scalar           FrontCarrier y                    ]
        set _lastValue(Component/Carrier/Rear/File)                             [rattleCAD::model::get_Component        RearCarrier                       ]
        set _lastValue(Component/Carrier/Rear/x)                                [rattleCAD::model::get_Scalar           RearCarrier x                     ]
        set _lastValue(Component/Carrier/Rear/y)                                [rattleCAD::model::get_Scalar           RearCarrier y                     ]
        set _lastValue(Component/CrankSet/ArmWidth)                             [rattleCAD::model::get_Scalar           CrankSet ArmWidth                 ]
        set _lastValue(Component/CrankSet/ChainLine)                            [rattleCAD::model::get_Scalar           CrankSet ChainLine                ]
        set _lastValue(Component/CrankSet/ChainRings)                           [rattleCAD::model::get_ListValue        CrankSetChainRings                ]
        set _lastValue(Component/CrankSet/File)                                 [rattleCAD::model::get_Component        CrankSet                          ]
        set _lastValue(Component/CrankSet/Length)                               [rattleCAD::model::get_Scalar           CrankSet Length                   ]
        set _lastValue(Component/CrankSet/PedalEye)                             [rattleCAD::model::get_Scalar           CrankSet PedalEye                 ]
        set _lastValue(Component/CrankSet/Q-Factor)                             [rattleCAD::model::get_Scalar           CrankSet Q-Factor                 ]
        set _lastValue(Component/Derailleur/Front/Distance)                     [rattleCAD::model::get_Scalar           FrontDerailleur Distance          ]
        set _lastValue(Component/Derailleur/Front/File)                         [rattleCAD::model::get_Component        FrontDerailleur                   ]
        set _lastValue(Component/Derailleur/Front/Offset)                       [rattleCAD::model::get_Scalar           FrontDerailleur Offset            ]
        set _lastValue(Component/Derailleur/Rear/File)                          [rattleCAD::model::get_Component        RearDerailleur                    ]
        set _lastValue(Component/Derailleur/Rear/Pulley/teeth)                  [rattleCAD::model::get_Scalar           RearDerailleur Pulley_teeth       ]
        set _lastValue(Component/Derailleur/Rear/Pulley/x)                      [rattleCAD::model::get_Scalar           RearDerailleur Pulley_x           ]
        set _lastValue(Component/Derailleur/Rear/Pulley/y)                      [rattleCAD::model::get_Scalar           RearDerailleur Pulley_y           ]
        set _lastValue(Component/Fender/Front/Height)                           [rattleCAD::model::get_Scalar           FrontFender Height                ]
        set _lastValue(Component/Fender/Front/OffsetAngle)                      [rattleCAD::model::get_Scalar           FrontFender OffsetAngle           ]
        set _lastValue(Component/Fender/Front/OffsetAngleFront)                 [rattleCAD::model::get_Scalar           FrontFender OffsetAngleFront      ]
        set _lastValue(Component/Fender/Front/Radius)                           [rattleCAD::model::get_Scalar           FrontFender Radius                ]
        set _lastValue(Component/Fender/Rear/Height)                            [rattleCAD::model::get_Scalar           RearFender Height                 ]
        set _lastValue(Component/Fender/Rear/OffsetAngle)                       [rattleCAD::model::get_Scalar           RearFender OffsetAngle            ]
        set _lastValue(Component/Fender/Rear/Radius)                            [rattleCAD::model::get_Scalar           RearFender Radius                 ]
        set _lastValue(Component/Fork/Blade/BendRadius)                         [rattleCAD::model::get_Scalar           Fork BladeBendRadius              ]
        set _lastValue(Component/Fork/Blade/DiameterDO)                         [rattleCAD::model::get_Scalar           Fork BladeDiameterDO              ]
        set _lastValue(Component/Fork/Blade/EndLength)                          [rattleCAD::model::get_Scalar           Fork BladeEndLength               ]
        set _lastValue(Component/Fork/Blade/TaperLength)                        [rattleCAD::model::get_Scalar           Fork BladeTaperLength             ]
        set _lastValue(Component/Fork/Blade/Width)                              [rattleCAD::model::get_Scalar           Fork BladeWidth                   ]
        set _lastValue(Component/Fork/Crown/Blade/Offset)                       [rattleCAD::model::get_Scalar           Fork BladeOffsetCrown             ]
        set _lastValue(Component/Fork/Crown/Blade/OffsetPerp)                   [rattleCAD::model::get_Scalar           Fork BladeOffsetCrownPerp         ]
        set _lastValue(Component/Fork/Crown/Brake/Angle)                        [rattleCAD::model::get_Scalar           Fork BrakeAngle                   ]
        set _lastValue(Component/Fork/Crown/Brake/Offset)                       [rattleCAD::model::get_Scalar           Fork BrakeOffset                  ]
        set _lastValue(Component/Fork/Crown/File)                               [rattleCAD::model::get_Component        ForkCrown                         ]
        set _lastValue(Component/Fork/DropOut/File)                             [rattleCAD::model::get_Component        ForkDropout                       ]
        set _lastValue(Component/Fork/DropOut/Offset)                           [rattleCAD::model::get_Scalar           Fork BladeOffsetDO                ]
        set _lastValue(Component/Fork/DropOut/OffsetPerp)                       [rattleCAD::model::get_Scalar           Fork BladeOffsetDOPerp            ]
        set _lastValue(Component/Fork/Height)                                   [rattleCAD::model::get_Scalar           Fork Height                       ]
        set _lastValue(Component/Fork/Rake)                                     [rattleCAD::model::get_Scalar           Fork Rake                         ]
        set _lastValue(Component/HandleBar/File)                                [rattleCAD::model::get_Component        HandleBar                         ]
        set _lastValue(Component/HandleBar/PivotAngle)                          [rattleCAD::model::get_Scalar           HandleBar PivotAngle              ]
        set _lastValue(Component/HeadSet/Diameter)                              [rattleCAD::model::get_Scalar           HeadSet Diameter                  ]
        set _lastValue(Component/HeadSet/Height/Bottom)                         [rattleCAD::model::get_Scalar           HeadSet Height_Bottom             ]
        set _lastValue(Component/HeadSet/Height/Top)                            [rattleCAD::model::get_Scalar           HeadSet Height_Top                ]
        set _lastValue(Component/Logo/File)                                     [rattleCAD::model::get_Component        Logo                              ]
        set _lastValue(Component/Saddle/File)                                   [rattleCAD::model::get_Component        Saddle                            ]
        set _lastValue(Component/Saddle/Height)                                 [rattleCAD::model::get_Scalar           Saddle SaddleHeight               ]
        set _lastValue(Component/Saddle/LengthNose)                             [rattleCAD::model::get_Scalar           Saddle NoseLength                 ]
        set _lastValue(Component/SeatPost/Diameter)                             [rattleCAD::model::get_Scalar           SeatPost Diameter                 ]
        set _lastValue(Component/SeatPost/PivotOffset)                          [rattleCAD::model::get_Scalar           SeatPost PivotOffset              ]
        set _lastValue(Component/SeatPost/Setback)                              [rattleCAD::model::get_Scalar           SeatPost Setback                  ]
        set _lastValue(Component/Stem/Angle)                                    [rattleCAD::model::get_Scalar           Geometry Stem_Angle               ]
        set _lastValue(Component/Stem/Length)                                   [rattleCAD::model::get_Scalar           Geometry Stem_Length              ]
        set _lastValue(Component/Wheel/Front/RimDiameter)                       [rattleCAD::model::get_Scalar           FrontWheel RimDiameter            ]
        set _lastValue(Component/Wheel/Front/RimHeight)                         [rattleCAD::model::get_Scalar           FrontWheel RimHeight              ]
        set _lastValue(Component/Wheel/Front/TyreHeight)                        [rattleCAD::model::get_Scalar           FrontWheel TyreHeight             ]
        set _lastValue(Component/Wheel/Rear/FirstSprocket)                      [rattleCAD::model::get_Scalar           RearWheel FirstSprocket           ]
        set _lastValue(Component/Wheel/Rear/HubWidth)                           [rattleCAD::model::get_Scalar           RearWheel HubWidth                ]
        set _lastValue(Component/Wheel/Rear/RimDiameter)                        [rattleCAD::model::get_Scalar           RearWheel RimDiameter             ]
        set _lastValue(Component/Wheel/Rear/RimHeight)                          [rattleCAD::model::get_Scalar           RearWheel RimHeight               ]
        set _lastValue(Component/Wheel/Rear/TyreHeight)                         [rattleCAD::model::get_Scalar           RearWheel TyreHeight              ]
        set _lastValue(Component/Wheel/Rear/TyreWidth)                          [rattleCAD::model::get_Scalar           RearWheel TyreWidth               ]
        set _lastValue(Component/Wheel/Rear/TyreWidthRadius)                    [rattleCAD::model::get_Scalar           RearWheel TyreWidthRadius         ]
        set _lastValue(Custom/BottomBracket/Depth)                              [rattleCAD::model::get_Scalar           Geometry BottomBracket_Depth      ]
        set _lastValue(Custom/DownTube/OffsetBB)                                [rattleCAD::model::get_Scalar           DownTube OffsetBB                 ]
        set _lastValue(Custom/DownTube/OffsetHT)                                [rattleCAD::model::get_Scalar           DownTube OffsetHT                 ]
        set _lastValue(Custom/HeadTube/Angle)                                   [rattleCAD::model::get_Scalar           Geometry HeadTube_Angle           ]
        set _lastValue(Custom/SeatStay/OffsetTT)                                [rattleCAD::model::get_Scalar           SeatStay OffsetTT                 ]
        set _lastValue(Custom/SeatTube/Extension)                               [rattleCAD::model::get_Scalar           SeatTube Extension                ]
        set _lastValue(Custom/SeatTube/OffsetBB)                                [rattleCAD::model::get_Scalar           SeatTube OffsetBB                 ]
        set _lastValue(Custom/TopTube/Angle)                                    [rattleCAD::model::get_Scalar           Geometry TopTube_Angle            ]
        set _lastValue(Custom/TopTube/OffsetHT)                                 [rattleCAD::model::get_Scalar           TopTube OffsetHT                  ]
        set _lastValue(Custom/TopTube/PivotPosition)                            [rattleCAD::model::get_Scalar           TopTube PivotPosition             ]
        set _lastValue(Custom/WheelPosition/Rear)                               [rattleCAD::model::get_Scalar           Geometry ChainStay_Length         ]
        set _lastValue(FrameTubes/ChainStay/CenterLine/angle_01)                [rattleCAD::model::get_Scalar           ChainStay segmentAngle_01         ]
        set _lastValue(FrameTubes/ChainStay/CenterLine/angle_02)                [rattleCAD::model::get_Scalar           ChainStay segmentAngle_02         ]
        set _lastValue(FrameTubes/ChainStay/CenterLine/angle_03)                [rattleCAD::model::get_Scalar           ChainStay segmentAngle_03         ]
        set _lastValue(FrameTubes/ChainStay/CenterLine/angle_04)                [rattleCAD::model::get_Scalar           ChainStay segmentAngle_04         ]
        set _lastValue(FrameTubes/ChainStay/CenterLine/length_01)               [rattleCAD::model::get_Scalar           ChainStay segmentLength_01        ]
        set _lastValue(FrameTubes/ChainStay/CenterLine/length_02)               [rattleCAD::model::get_Scalar           ChainStay segmentLength_02        ]
        set _lastValue(FrameTubes/ChainStay/CenterLine/length_03)               [rattleCAD::model::get_Scalar           ChainStay segmentLength_03        ]
        set _lastValue(FrameTubes/ChainStay/CenterLine/length_04)               [rattleCAD::model::get_Scalar           ChainStay segmentLength_04        ]
        set _lastValue(FrameTubes/ChainStay/CenterLine/radius_01)               [rattleCAD::model::get_Scalar           ChainStay segmentRadius_01        ]
        set _lastValue(FrameTubes/ChainStay/CenterLine/radius_02)               [rattleCAD::model::get_Scalar           ChainStay segmentRadius_02        ]
        set _lastValue(FrameTubes/ChainStay/CenterLine/radius_03)               [rattleCAD::model::get_Scalar           ChainStay segmentRadius_03        ]
        set _lastValue(FrameTubes/ChainStay/CenterLine/radius_04)               [rattleCAD::model::get_Scalar           ChainStay segmentRadius_04        ]
        set _lastValue(FrameTubes/ChainStay/DiameterSS)                         [rattleCAD::model::get_Scalar           ChainStay DiameterSS              ]
        set _lastValue(FrameTubes/ChainStay/Height)                             [rattleCAD::model::get_Scalar           ChainStay Height                  ]
        set _lastValue(FrameTubes/ChainStay/HeightBB)                           [rattleCAD::model::get_Scalar           ChainStay HeigthBB                ]
        set _lastValue(FrameTubes/ChainStay/Profile/completeLength)             [rattleCAD::model::get_Scalar           ChainStay completeLength          ]
        set _lastValue(FrameTubes/ChainStay/Profile/cuttingLeft)                [rattleCAD::model::get_Scalar           ChainStay cuttingLeft             ]
        set _lastValue(FrameTubes/ChainStay/Profile/cuttingLength)              [rattleCAD::model::get_Scalar           ChainStay cuttingLength           ]
        set _lastValue(FrameTubes/ChainStay/Profile/length_01)                  [rattleCAD::model::get_Scalar           ChainStay profile_x01             ]
        set _lastValue(FrameTubes/ChainStay/Profile/length_02)                  [rattleCAD::model::get_Scalar           ChainStay profile_x02             ]
        set _lastValue(FrameTubes/ChainStay/Profile/length_03)                  [rattleCAD::model::get_Scalar           ChainStay profile_x03             ]
        set _lastValue(FrameTubes/ChainStay/Profile/width_00)                   [rattleCAD::model::get_Scalar           ChainStay profile_y00             ]
        set _lastValue(FrameTubes/ChainStay/Profile/width_01)                   [rattleCAD::model::get_Scalar           ChainStay profile_y01             ]
        set _lastValue(FrameTubes/ChainStay/Profile/width_02)                   [rattleCAD::model::get_Scalar           ChainStay profile_y02             ]
        set _lastValue(FrameTubes/ChainStay/Profile/width_03)                   [rattleCAD::model::get_Scalar           ChainStay WidthBB                 ]
        set _lastValue(FrameTubes/ChainStay/TaperLength)                        [rattleCAD::model::get_Scalar           ChainStay TaperLength             ]
        set _lastValue(FrameTubes/ChainStay/WidthBB)                            [rattleCAD::model::get_Scalar           ChainStay WidthBB                 ]
        set _lastValue(FrameTubes/DownTube/DiameterBB)                          [rattleCAD::model::get_Scalar           DownTube DiameterBB               ]
        set _lastValue(FrameTubes/DownTube/DiameterHT)                          [rattleCAD::model::get_Scalar           DownTube DiameterHT               ]
        set _lastValue(FrameTubes/DownTube/TaperLength)                         [rattleCAD::model::get_Scalar           DownTube TaperLength              ]
        set _lastValue(FrameTubes/HeadTube/Diameter)                            [rattleCAD::model::get_Scalar           HeadTube Diameter                 ]
        set _lastValue(FrameTubes/HeadTube/Length)                              [rattleCAD::model::get_Scalar           HeadTube Length                   ]
        set _lastValue(FrameTubes/SeatStay/DiameterCS)                          [rattleCAD::model::get_Scalar           SeatStay DiameterCS               ]
        set _lastValue(FrameTubes/SeatStay/DiameterST)                          [rattleCAD::model::get_Scalar           SeatStay DiameterST               ]
        set _lastValue(FrameTubes/SeatStay/TaperLength)                         [rattleCAD::model::get_Scalar           SeatStay TaperLength              ]
        set _lastValue(FrameTubes/SeatTube/DiameterBB)                          [rattleCAD::model::get_Scalar           SeatTube DiameterBB               ]
        set _lastValue(FrameTubes/SeatTube/DiameterTT)                          [rattleCAD::model::get_Scalar           SeatTube DiameterTT               ]
        set _lastValue(FrameTubes/SeatTube/TaperLength)                         [rattleCAD::model::get_Scalar           SeatTube TaperLength              ]
        set _lastValue(FrameTubes/TopTube/DiameterHT)                           [rattleCAD::model::get_Scalar           TopTube  DiameterHT               ]
        set _lastValue(FrameTubes/TopTube/DiameterST)                           [rattleCAD::model::get_Scalar           TopTube  DiameterST               ]
        set _lastValue(FrameTubes/TopTube/TaperLength)                          [rattleCAD::model::get_Scalar           TopTube  TaperLength              ]
        set _lastValue(Lugs/BottomBracket/ChainStay/Angle/plus_minus)           [rattleCAD::model::get_Scalar           Lugs BottomBracket_ChainStay_Tolerance    ]
        set _lastValue(Lugs/BottomBracket/ChainStay/Angle/value)                [rattleCAD::model::get_Scalar           Lugs BottomBracket_ChainStay_Angle        ]
        set _lastValue(Lugs/BottomBracket/ChainStay/Offset_TopView)             [rattleCAD::model::get_Scalar           BottomBracket OffsetCS_TopView            ]
        set _lastValue(Lugs/BottomBracket/Diameter/inside)                      [rattleCAD::model::get_Scalar           BottomBracket InsideDiameter              ]
        set _lastValue(Lugs/BottomBracket/Diameter/outside)                     [rattleCAD::model::get_Scalar           BottomBracket OutsideDiameter             ]
        set _lastValue(Lugs/BottomBracket/DownTube/Angle/plus_minus)            [rattleCAD::model::get_Scalar           Lugs BottomBracket_DownTube_Tolerance     ]
        set _lastValue(Lugs/BottomBracket/DownTube/Angle/value)                 [rattleCAD::model::get_Scalar           Lugs BottomBracket_DownTube_Angle         ]
        set _lastValue(Lugs/BottomBracket/Width)                                [rattleCAD::model::get_Scalar           BottomBracket Width               ]
        set _lastValue(Lugs/HeadTube/DownTube/Angle/plus_minus)                 [rattleCAD::model::get_Scalar           Lugs HeadLug_Bottom_Tolerance     ]
        set _lastValue(Lugs/HeadTube/DownTube/Angle/value)                      [rattleCAD::model::get_Scalar           Lugs HeadLug_Bottom_Angle         ]
        set _lastValue(Lugs/HeadTube/TopTube/Angle/plus_minus)                  [rattleCAD::model::get_Scalar           Lugs HeadLug_Top_Tolerance        ]
        set _lastValue(Lugs/HeadTube/TopTube/Angle/value)                       [rattleCAD::model::get_Scalar           Lugs HeadLug_Top_Angle            ]
        set _lastValue(Lugs/RearDropOut/Angle/plus_minus)                       [rattleCAD::model::get_Scalar           Lugs RearDropOut_Tolerance        ]
        set _lastValue(Lugs/RearDropOut/Angle/value)                            [rattleCAD::model::get_Scalar           Lugs RearDropOut_Angle            ]
        set _lastValue(Lugs/RearDropOut/ChainStay/Offset)                       [rattleCAD::model::get_Scalar           RearDropout OffsetCS              ]
        set _lastValue(Lugs/RearDropOut/ChainStay/OffsetPerp)                   [rattleCAD::model::get_Scalar           RearDropout OffsetCSPerp          ]
        set _lastValue(Lugs/RearDropOut/ChainStay/Offset_TopView)               [rattleCAD::model::get_Scalar           RearDropout OffsetCS_TopView      ]
        set _lastValue(Lugs/RearDropOut/Derailleur/x)                           [rattleCAD::model::get_Scalar           RearDropout Derailleur_x          ]
        set _lastValue(Lugs/RearDropOut/Derailleur/y)                           [rattleCAD::model::get_Scalar           RearDropout Derailleur_y          ]
        set _lastValue(Lugs/RearDropOut/Direction)                              [rattleCAD::model::get_Config           RearDropoutOrient                 ]
        set _lastValue(Lugs/RearDropOut/File)                                   [rattleCAD::model::get_Component        RearDropout                       ]
        set _lastValue(Lugs/RearDropOut/RotationOffset)                         [rattleCAD::model::get_Scalar           RearDropout RotationOffset        ]
        set _lastValue(Lugs/RearDropOut/SeatStay/Offset)                        [rattleCAD::model::get_Scalar           RearDropout OffsetSS              ]
        set _lastValue(Lugs/RearDropOut/SeatStay/OffsetPerp)                    [rattleCAD::model::get_Scalar           RearDropout OffsetSSPerp          ]
        set _lastValue(Lugs/SeatTube/SeatStay/Angle/plus_minus)                 [rattleCAD::model::get_Scalar           Lugs SeatLug_SeatStay_Tolerance   ]
        set _lastValue(Lugs/SeatTube/SeatStay/Angle/value)                      [rattleCAD::model::get_Scalar           Lugs SeatLug_SeatStay_Angle       ]
        set _lastValue(Lugs/SeatTube/SeatStay/MiterDiameter)                    [rattleCAD::model::get_Scalar           SeatStay SeatTubeMiterDiameter    ]
        set _lastValue(Lugs/SeatTube/TopTube/Angle/plus_minus)                  [rattleCAD::model::get_Scalar           Lugs SeatLug_TopTube_Tolerance    ]
        set _lastValue(Lugs/SeatTube/TopTube/Angle/value)                       [rattleCAD::model::get_Scalar           Lugs SeatLug_TopTube_Angle        ]
        set _lastValue(Personal/HandleBar_Distance)                             [rattleCAD::model::get_Scalar           Geometry HandleBar_Distance       ]
        set _lastValue(Personal/HandleBar_Height)                               [rattleCAD::model::get_Scalar           Geometry HandleBar_Height         ]
        set _lastValue(Personal/InnerLeg_Length)                                [rattleCAD::model::get_Scalar           Geometry Inseam_Length            ]
        set _lastValue(Personal/Saddle_Distance)                                [rattleCAD::model::get_Scalar           Geometry Saddle_Distance          ]
        set _lastValue(Personal/Saddle_Height)                                  [rattleCAD::model::get_Scalar           Saddle Height                     ]
        set _lastValue(Reference/HandleBar_Distance)                            [rattleCAD::model::get_Scalar           Reference HandleBar_Distance      ]
        set _lastValue(Reference/HandleBar_Height)                              [rattleCAD::model::get_Scalar           Reference HandleBar_Height        ]
        set _lastValue(Reference/SaddleNose_Distance)                           [rattleCAD::model::get_Scalar           Reference SaddleNose_Distance     ]
        set _lastValue(Reference/SaddleNose_Height)                             [rattleCAD::model::get_Scalar           Reference SaddleNose_Height       ]
        set _lastValue(Rendering/BottleCage/DownTube)                           [rattleCAD::model::get_Config           BottleCage_DT                     ]
        set _lastValue(Rendering/BottleCage/DownTube_Lower)                     [rattleCAD::model::get_Config           BottleCage_DT_L                   ]
        set _lastValue(Rendering/BottleCage/SeatTube)                           [rattleCAD::model::get_Config           BottleCage_ST                     ]
        set _lastValue(Rendering/Brake/Front)                                   [rattleCAD::model::get_Config           FrontBrake                        ]
        set _lastValue(Rendering/Brake/Rear)                                    [rattleCAD::model::get_Config           RearBrake                         ]
        set _lastValue(Rendering/ChainStay)                                     [rattleCAD::model::get_Config           ChainStay                         ]
        set _lastValue(Rendering/Fender/Front)                                  [rattleCAD::model::get_Config           FrontFender                       ]
        set _lastValue(Rendering/Fender/Rear)                                   [rattleCAD::model::get_Config           RearFender                        ]
        set _lastValue(Rendering/Fork)                                          [rattleCAD::model::get_Config           Fork                              ]
        set _lastValue(Rendering/ForkBlade)                                     [rattleCAD::model::get_Config           ForkBlade                         ]
        set _lastValue(Rendering/ForkDropOut)                                   [rattleCAD::model::get_Config           ForkDropout                       ]
        set _lastValue(Rendering/RearDropOut)                                   [rattleCAD::model::get_Config           RearDropout                       ]
        set _lastValue(Rendering/RearMockup/CassetteClearance)                  [rattleCAD::model::get_Scalar           RearMockup CassetteClearance      ]
        set _lastValue(Rendering/RearMockup/ChainWheelClearance)                [rattleCAD::model::get_Scalar           RearMockup ChainWheelClearance    ]
        set _lastValue(Rendering/RearMockup/CrankClearance)                     [rattleCAD::model::get_Scalar           RearMockup CrankClearance         ]
        set _lastValue(Rendering/RearMockup/DiscClearance)                      [rattleCAD::model::get_Scalar           RearMockup DiscClearance          ]
        set _lastValue(Rendering/RearMockup/DiscDiameter)                       [rattleCAD::model::get_Scalar           RearMockup DiscDiameter           ]
        set _lastValue(Rendering/RearMockup/DiscOffset)                         [rattleCAD::model::get_Scalar           RearMockup DiscOffset             ]
        set _lastValue(Rendering/RearMockup/DiscWidth)                          [rattleCAD::model::get_Scalar           RearMockup DiscWidth              ]
        set _lastValue(Rendering/RearMockup/TyreClearance)                      [rattleCAD::model::get_Scalar           RearMockup TyreClearance          ]
        set _lastValue(Rendering/Saddle/Offset_X)                               [rattleCAD::model::get_Scalar           Saddle Offset_x                   ]
        set _lastValue(Rendering/Saddle/Offset_Y)                               [rattleCAD::model::get_Scalar           Saddle Offset_y                   ]
        set _lastValue(Result/Angle/HeadTube/TopTube)                           [rattleCAD::model::get_Scalar           Result Angle_HeadTubeTopTube      ]
        set _lastValue(Result/Angle/SeatTube/Direction)                         [rattleCAD::model::get_Scalar           SeatTube Angle                    ]
        set _lastValue(Result/Length/BottomBracket/Height)                      [rattleCAD::model::get_Scalar           Geometry BottomBracket_Height     ]
        set _lastValue(Result/Length/FrontWheel/Radius)                         [rattleCAD::model::get_Scalar           Geometry FrontWheel_Radius        ]
        set _lastValue(Result/Length/FrontWheel/diagonal)                       [rattleCAD::model::get_Scalar           Geometry FrontWheel_xy            ]
        set _lastValue(Result/Length/FrontWheel/horizontal)                     [rattleCAD::model::get_Scalar           Geometry FrontWheel_x             ]
        set _lastValue(Result/Length/HeadTube/ReachLength)                      [rattleCAD::model::get_Scalar           Geometry ReachLengthResult        ]
        set _lastValue(Result/Length/HeadTube/StackHeight)                      [rattleCAD::model::get_Scalar           Geometry StackHeightResult        ]
        set _lastValue(Result/Length/Personal/SaddleNose_HB)                    [rattleCAD::model::get_Scalar           Geometry SaddleNose_HB            ]
        set _lastValue(Result/Length/RearWheel/Radius)                          [rattleCAD::model::get_Scalar           Geometry RearWheel_Radius         ]
        set _lastValue(Result/Length/RearWheel/TyreShoulder)                    [rattleCAD::model::get_Scalar           RearWheel TyreShoulder            ]
        set _lastValue(Result/Length/RearWheel/horizontal)                      [rattleCAD::model::get_Scalar           Geometry RearWheel_x              ]
        set _lastValue(Result/Length/Reference/Heigth_SN_HB)                    [rattleCAD::model::get_Scalar           Reference SaddleNose_HB_y         ]
        set _lastValue(Result/Length/Reference/SaddleNose_HB)                   [rattleCAD::model::get_Scalar           Reference SaddleNose_HB           ]
        set _lastValue(Result/Length/Saddle/Offset_BB_Nose)                     [rattleCAD::model::get_Scalar           Geometry SaddleNose_BB_x          ]
        set _lastValue(Result/Length/Saddle/Offset_BB_ST)                       [rattleCAD::model::get_Scalar           Geometry Saddle_Offset_BB_ST      ]
        set _lastValue(Result/Length/Saddle/Offset_HB)                          [rattleCAD::model::get_Scalar           Geometry Saddle_HB_y              ]
        set _lastValue(Result/Length/Saddle/SeatTube_BB)                        [rattleCAD::model::get_Scalar           Geometry Saddle_BB                ]
        set _lastValue(Result/Length/SeatTube/VirtualLength)                    [rattleCAD::model::get_Scalar           Geometry SeatTubeVirtual          ]
        set _lastValue(Result/Length/TopTube/VirtualLength)                     [rattleCAD::model::get_Scalar           Geometry TopTubeVirtual           ]            
            #
    }
    






