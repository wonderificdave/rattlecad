 ##+##########################################################################te
 #
 # package: rattleCAD   ->  lib_config.tcl
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
 #  namespace:  rattleCAD::configPanel
 # ---------------------------------------------------------------------------
 #
 #

 namespace eval rattleCAD::configPanel {

    variable    cfg_Position    {}

    variable    rdials_list     {}
    variable    cboxList        {}

    variable    configValue
    array set   configValue     {}

    variable    componentList   {}
    variable    compCanvas      {}
    variable    frameCanvas     {}
    
    variable    projectDOM
	
	variable _currentValue
	array set _currentValue {}
	variable _updateValue
	array set _updateValue {}
    
    
    if {1 == 2} {
        variable Personal
        array set Personal {
                    HandleBar_Distance   {a}
                    HandleBar_Height     {b}
                    InnerLeg_Length      {e}
                    Saddle_Distance      {c}
                    Saddle_Height        {d}
                }
        variable Custom 
        array set Custom {
                    BottomBracket/Depth   {b}
                    DownTube/OffsetBB	  {j}
                    DownTube/OffsetHT     {e}
                    HeadTube/Angle        {i}
                    SeatStay/OffsetTT     {g}
                    SeatTube/Extension    {f}
                    TopTube/Angle         {h}
                    TopTube/PivotPosition {c}
                    WheelPosition/Rear    {a}
                    TopTube/OffsetHT      {d}
                }
                                    
        variable Component
        array set Component {
                    Brake/Front/File         {}
                    Brake/Rear/File          {}
                    CrankSet/File            {}
                    Derailleur/Front/File    {}
                    Derailleur/Rear/File     {}
                    Carrier/Front/File       {}
                    Carrier/Rear/File        {}
                    Fork/Crown/File          {d}
                    Fork/DropOut/File        {e}
                    Fork/Height              {c}
                    Fork/Rake                {b}
                    HandleBar/File           {}
                    HeadSet/Height/Bottom    {}
                    Saddle/File              {}									
                    SeatPost/Setback         {a}
                    Stem/Angle               {f}
                    Stem/Length              {g}
                    Wheel/Front/RimDiameter  {} 
                    Wheel/Front/TyreHeight	 {}
                    Wheel/Rear/RimDiameter   {} 
                    Wheel/Rear/TyreHeight    {}
                }
                
        variable Result
        array set Result {
                    Angle/HeadTube/TopTube         {bb}
                    Length/BottomBracket/Height    {bb}
                    Length/FrontWheel/diagonal     {b}
                    Length/FrontWheel/horizontal   {bb}
                    Length/Saddle/SeatTube_BB      {b}
                    Length/TopTube/VirtualLength   {b}
                }
                
        variable Lugs
        array set Lugs {
                    BottomBracket/ChainStay/Angle/plus_minus   {h}
                    BottomBracket/ChainStay/Angle/value        {g}
                    BottomBracket/DownTube/Angle/plus_minus    {f}
                    BottomBracket/DownTube/Angle/value         {e}
                    HeadTube/DownTube/Angle/plus_minus         {d}
                    HeadTube/DownTube/Angle/value              {c}
                    HeadTube/TopTube/Angle/plus_minus          {b}
                    HeadTube/TopTube/Angle/value               {a}
                    RearDropOut/Angle/plus_minus               {k}
                    RearDropOut/Angle/value                    {j}
                    RearDropOut/File                           {i}
                    SeatTube/SeatStay/Angle/plus_minus 		   {m}
                    SeatTube/SeatStay/Angle/value              {l}
                }

        variable FrameTubes
        array set FrameTubes {
                    HeadTube/Length              {}
                }
                
        variable Rendering
        array set Rendering {
                    BottleCage/DownTube          {a}
                    BottleCage/DownTube          {b}
                    BottleCage/DownTube_Lower    {b}
                    BottleCage/SeatTube          {d}
                    BottleCage/SeatTube          {e}
                    BottleCage/SeatTube          {f}
                    Brake/Front                  {g}
                    Brake/Rear                   {h}
                    Fender/Front                 {k}
                    Fender/Rear                  {l}
                    Fork                         {m}
                    ForkBlade                    {n}
                } 
                    # Carrier/Front                {i}
                    # Carrier/Rear                 {j}
	}										
								
	
    proc init_configValues {} {
                #
            variable _currentValue
            variable _updateValue
                #
            # tk_messageBox -message "init_configValues"    
                #
                        #
            foreach key [array names rattleCAD::control::_currentValue] {
                set _currentValue($key) [lindex [array get rattleCAD::control::_currentValue $key] 1]
                set _updateValue($key)  [lindex [array get rattleCAD::control::_currentValue $key] 1]
            }
                #
            return
                #
	}
    
    
    #-------------------------------------------------------------------------
       #  create config widget
       #
       # proc create {main w {mode {}}}
    proc create {} {
            # ->
            # return
            
            variable cfg_Position

			set main . 
			set w    .cfg
			
                # -----------------
                # main window information
            set root_xy [split  [wm geometry $main] +]
            set root_w     [winfo width $main]
            set root_x    [lindex $root_xy 1]
            set root_y    [lindex $root_xy 2]
                #
            set pos_x     [expr $root_x - 20 + $root_w]
            set pos_y     [expr $root_y - 10]
            
                # -----------------
                # check if window exists
            if {[winfo exists $w]} {
                    # restore if hidden
                    # puts "   ... $w allready exists!"
                wm geometry     $w +$pos_x+$pos_y
                wm deiconify    $w
                wm deiconify    $main
                focus           $w
                return
            }


                # -----------------
                # create a toplevel window to edit the attribute values
                #
            toplevel    $w
            wm title    $w "Configuration Panel"
                # create iconBitmap  -----
            if {$::tcl_platform(platform) == {windows}} {
                wm iconbitmap $w [file join $::APPL_Config(BASE_Dir) tclkit.ico]
            } else {
                wm iconphoto  $w [image create photo .ico1 -format gif -file [file join $::APPL_Config(BASE_Dir)  icon16.gif] ]
            }
                # puts "    geometry:  [wm geometry .]"
            wm geometry    $w +$pos_x+$pos_y


                # -----------------
                # create content
            create_Content $main $w

                # -----------------
                #
            set cfg_Position [list $root_x $root_y $root_w [expr $root_x+8+$root_w] 0 ]

                # -----------------
                #
            bind $w        <Configure> [list [namespace current]::register_relative_position     $main $w]
            bind $main     <Configure> [list [namespace current]::reposition_to_main             $main $w]

                # -----------------
                #
            wm deiconify    $main

            focus           $w

            #$nb_Config select 1

    }


    #-------------------------------------------------------------------------
       #  create config Content
       #
    proc create_Content {main w} {

            variable compCanvas

                # -----------------
                #   clean berfoe create
            catch {destroy $w.f}

                # -----------------
                # reset value list
            array unset [namespace current]::configValue
                # -----------------
                #   initiate all tags and values
            init_configValues
            # init_configValues_21
                # -----------------
                #   create notebook
            pack [  frame $w.f ]
                #
            set nb_Config   [ ttk::notebook $w.f.nb ]
                pack $nb_Config     -expand no -fill both
            $nb_Config add [frame $nb_Config.geometry]      -text "Geometry"
            $nb_Config add [frame $nb_Config.frameDetail]   -text " Frame "
            $nb_Config add [frame $nb_Config.frameCheck]    -text " Check "
            $nb_Config add [frame $nb_Config.bikeComp]      -text " Mockup "

                # -----------------
                # add content
            add_Basic           $nb_Config.geometry
            $nb_Config select   $nb_Config.frameDetail
            add_FrameDetails    $nb_Config.frameDetail
            $nb_Config select   $nb_Config.frameCheck
            add_FrameCheck      $nb_Config.frameCheck
            $nb_Config select   $nb_Config.bikeComp
            add_BikeComponents  $nb_Config.bikeComp
            $nb_Config select   $nb_Config.geometry

                
				# -----------------
                #			
		    bind $nb_Config <<NotebookTabChanged>> [list [namespace current]::bind_notebookTabChanged  $nb_Config]

				
				# -----------------
                #
            wm resizable    $w  0 0
                #    wm  withdraw   $w
            # update
            # $compCanvas refitStage

            return
    }



    #-------------------------------------------------------------------------
       #  add content 01
       #
    proc add_Basic {w} {
            
				
				#
                # add content
                #
            set     menueFrame  [ frame $w.f_menue  -relief flat -bd 1]
            pack    $menueFrame \
                -fill x  -side top  -expand no


                # -----------------
                #   build frame
            frame           $menueFrame.sf -relief flat -bd 1
                pack $menueFrame.sf         -side top  -fill x  -expand yes


                # -----------------
                #   Concept - Primary
            ttk::labelframe $menueFrame.sf.lf_01        -text "Base Concept - Primary Values"
                pack $menueFrame.sf.lf_01               -side top  -fill x  -expand yes  -pady 2
                    create_configEdit $menueFrame.sf.lf_01      Scalar/Geometry/HandleBar_Distance      0.20  orangered     ;# Personal(HandleBar_Distance)    
                    create_configEdit $menueFrame.sf.lf_01      Scalar/Geometry/HandleBar_Height        0.20  orangered     ;# Personal(HandleBar_Height)      
                    create_configEdit $menueFrame.sf.lf_01      Scalar/Geometry/Saddle_Distance         0.20  orangered     ;# Personal(Saddle_Distance)       
                    create_configEdit $menueFrame.sf.lf_01      Scalar/Geometry/Saddle_Height           0.02  orangered     ;# Personal(Saddle_Height)         
                    create_configEdit $menueFrame.sf.lf_01      Scalar/Geometry/Inseam_Length           0.20  darkviolet    ;# Personal(InnerLeg_Length)       
                    create_configEdit $menueFrame.sf.lf_01      Scalar/TopTube/PivotPosition            0.20  darkviolet    ;# Custom(TopTube/PivotPosition)   

                # -----------------
                #   Concept
            ttk::labelframe    $menueFrame.sf.lf_02        -text "Base Concept - Secondary Values"
                pack $menueFrame.sf.lf_02                 -side top  -fill x  -expand yes  -pady 2
                    create_configEdit $menueFrame.sf.lf_01      Scalar/SeatPost/Setback                 0.20  darkred       ;# Component(SeatPost/Setback)     
                    create_configEdit $menueFrame.sf.lf_02      Scalar/Geometry/Fork_Rake               0.20  darkred       ;# Component(Fork/Rake)            
                    create_configEdit $menueFrame.sf.lf_02      Scalar/Geometry/Fork_Height             0.20  darkred       ;# Component(Fork/Height)          
                    create_configEdit $menueFrame.sf.lf_02      Scalar/Geometry/HeadTube_Angle          0.02  darkred       ;# Custom(HeadTube/Angle)          
                    create_configEdit $menueFrame.sf.lf_02      Scalar/Geometry/Stem_Angle              0.10  darkred       ;# Component(Stem/Angle)           
                    create_configEdit $menueFrame.sf.lf_02      Scalar/Geometry/Stem_Length             0.20  darkred       ;# Component(Stem/Length)          
                    create_configEdit $menueFrame.sf.lf_02      Scalar/Geometry/ChainStay_Length        0.20  darkred       ;# Custom(WheelPosition/Rear)      
                    create_configEdit $menueFrame.sf.lf_02      Scalar/Geometry/BottomBracket_Depth     0.20  darkred       ;# Custom(BottomBracket/Depth)     

                # -----------------
                #   Alternatives
            ttk::labelframe    $menueFrame.sf.lf_03        -text "Base Concept - Alternative Values"
                pack $menueFrame.sf.lf_03                 -side top  -fill x  -expand yes  -pady 2
                    create_configEdit $menueFrame.sf.lf_03      Scalar/Geometry/TopTube_Virtual         0.20  darkblue          ;#Result(Length/TopTube/VirtualLength)  
                    create_configEdit $menueFrame.sf.lf_03      Scalar/Geometry/FrontWheel_x            0.20  darkblue          ;#Result(Length/FrontWheel/horizontal)  
                    create_configEdit $menueFrame.sf.lf_03      Scalar/Geometry/FrontWheel_xy           0.20  darkblue          ;#Result(Length/FrontWheel/diagonal)    
                    create_configEdit $menueFrame.sf.lf_03      Scalar/Geometry/BottomBracket_Height    0.20  darkblue          ;#Result(Length/BottomBracket/Height)   
                    create_configEdit $menueFrame.sf.lf_03      Scalar/Geometry/Saddle_BB               0.20  darkblue          ;#Result(Length/Saddle/SeatTube_BB)     
                    
                # -----------------
                #   Wheels
            ttk::labelframe $menueFrame.sf.lf_04        -text "Wheels"
                pack $menueFrame.sf.lf_04               -side top  -fill x  -pady 2

                    create_config_cBox  $menueFrame.sf.lf_04    Scalar/Geometry/RearRim_Diameter        $rattleCAD::model::valueRegistry(Rim)         ;# Component(Wheel/Rear/RimDiameter) 
                    create_configEdit   $menueFrame.sf.lf_04    Scalar/Geometry/RearTyre_Height         0.20                                          ;# Component(Wheel/Rear/TyreHeight)  
                    create_config_cBox  $menueFrame.sf.lf_04    Scalar/Geometry/FrontRim_Diameter       $rattleCAD::model::valueRegistry(Rim)         ;# Component(Wheel/Front/RimDiameter)
                    create_configEdit   $menueFrame.sf.lf_04    Scalar/Geometry/FrontTyre_Height        0.20                                          ;# Component(Wheel/Front/TyreHeight) 

          
    }
    #-------------------------------------------------------------------------
       #  add content 02
       #
    proc add_FrameDetails {w} {

            variable APPL_Config
            variable componentList
            variable configValue
            variable frameCanvas
                #
                # add content
                #
            set     menueFrame    [ frame $w.f_menue    -relief flat -bd 1]
            pack     $menueFrame \
                -fill x  -side top  -expand no


                # -----------------
                #   build frame
            frame           $menueFrame.sf -relief flat -bd 1
                pack $menueFrame.sf         -side top  -fill x  -expand yes


                # -----------------
                #   Tube Details
            ttk::labelframe    $menueFrame.sf.lf_01        -text "Tube Details"
                #
            pack $menueFrame.sf.lf_01                  -side top  -fill x  -expand yes  -pady 2
                #
            create_configEdit_title $menueFrame.sf.lf_01    {HeadTube - Length}             Scalar/HeadTube/Length              0.20  darkred       ;# FrameTubes(HeadTube/Length)     
            create_configEdit_title $menueFrame.sf.lf_01    {HeadTube/TopTube - Angle}      Scalar/Geometry/HeadLugTop_Angle    0.02  darkblue      ;# Result(Angle/HeadTube/TopTube)  
            create_configEdit_title $menueFrame.sf.lf_01    {HeadTube/TopTube - Offset}     Scalar/TopTube/OffsetHT             0.20  darkred       ;# Custom(TopTube/OffsetHT)        
            create_configEdit_title $menueFrame.sf.lf_01    {HeadTube/DownTube - Offset}    Scalar/DownTube/OffsetHT            0.20  darkred       ;# Custom(DownTube/OffsetHT)       
            create_configEdit_title $menueFrame.sf.lf_01    {HeadSet - BottomHeight}        Scalar/HeadSet/Height_Bottom        0.20  darkred       ;# Component(HeadSet/Height/Bottom)
            create_configEdit_title $menueFrame.sf.lf_01    {SeatTube - Extension}          Scalar/SeatTube/Extension           0.20  darkred       ;# Custom(SeatTube/Extension)      
            create_configEdit_title $menueFrame.sf.lf_01    {TopTube/SeatStay - Offset}     Scalar/SeatStay/OffsetTT            0.20  darkred       ;# Custom(SeatStay/OffsetTT)       
            create_configEdit_title $menueFrame.sf.lf_01    {TopTube - Angle}               Scalar/Geometry/TopTube_Angle       0.20  darkred       ;# Custom(TopTube/Angle)           
            create_configEdit_title $menueFrame.sf.lf_01    {DownTube/BB - Offset}          Scalar/DownTube/OffsetBB            0.20  darkred       ;# Custom(DownTube/OffsetBB)       


                # -----------------
                #   Frame Parts
            ttk::labelframe    $menueFrame.sf.lf_09        -text "Frame & Fork Parts"
                #
                pack $menueFrame.sf.lf_09                 -side top  -fill x  -expand yes  -pady 2
                #
            set compList {  Component/RearDropout
                            Config/Fork
                            Component/ForkCrown
                            Component/ForkDropout}
                #
            set i 0
            foreach xPath $compList {
                        #
                    set xPathNodes  [lrange [split $xPath /] 1 end]
                    set labelString "          [lindex $xPathNodes 0]:  [lrange $xPathNodes 1 end]"
                        #
                    set fileFrame [frame $menueFrame.sf.lf_09.f_$i]
                        #
                    incr i 1
                    switch -exact $xPath {
                        Config/Fork {
                            label $fileFrame.lb -text $labelString
                            set listBoxContent [ rattleCAD::control::get_listBoxContent SELECT_ForkType Config(Fork))]
                            foreach entry $listBoxContent {
                                puts "         ... $entry"
                            }
                        }
                        default {
                            label $fileFrame.lb -text $labelString
                            set listBoxContent [rattleCAD::model::file::get_componentAlternatives  $xPath]
                        }
                    }
                    set textvariable [format "%s::%s(%s)"  [namespace current] _updateValue $xPath]
					set value [set $textvariable]
					puts "     -> \$textvariable $textvariable     <- $value"
					ttk::combobox $fileFrame.cb -textvariable $textvariable \
                                                -values $listBoxContent   -width 30
                        pack $fileFrame     -fill x -expand yes  -pady 2
                        pack $fileFrame.cb  -side right
                        pack $fileFrame.lb  -side left

                    bind $fileFrame.cb <<ComboboxSelected>> [list [namespace current]::::ListboxEvent %W cv_frameParts [format "%s::%s(%s)" [namespace current] _updateValue $xPath] select]
                    bind $fileFrame.cb <ButtonPress>        [list [namespace current]::::ListboxEvent %W cv_frameParts [format "%s::%s(%s)" [namespace current] _updateValue $xPath] update]
            }
                #
            if {$frameCanvas != {}} {
                $frameCanvas destroy
            }
                #
            set frameCanvas [canvasCAD::newCanvas cv_FrameParts $menueFrame.sf.lf_09.cvCAD "_unused_"  280  210  passive  1.0  0  -bd 2  -bg white  -relief sunken]
                #
            return
                #
    }
    #-------------------------------------------------------------------------
       #  add content 03
       #
    proc add_FrameCheck {w} {

            variable APPL_Config
            variable componentList
            variable configValue
            variable frameCanvas
                #
                # add content
                #
            set     menueFrame    [ frame $w.f_menue    -relief flat -bd 1]
            pack     $menueFrame \
                -fill x  -side top  -expand no


                # -----------------
                #   build frame
            frame             $menueFrame.sf -relief flat -bd 1
                pack $menueFrame.sf          -side top  -fill x  -expand yes


                # -----------------
                #   Concept - Primary
            ttk::labelframe $menueFrame.sf.lf_06        -text "Check Frame Angles"
                pack $menueFrame.sf.lf_06               -side top  -fill x  -expand yes  -pady 2
                    create_configEdit_title $menueFrame.sf.lf_06  {HeadTube/TopTube}            Scalar/Lugs/HeadLug_Top_Angle                   0.10    darkred      ;# Lugs(HeadTube/TopTube/Angle/value)            
                    create_configEdit_title $menueFrame.sf.lf_06    {      Tolerance +/-}       Scalar/Lugs/HeadLug_Top_Tolerance               0.10                 ;# Lugs(HeadTube/TopTube/Angle/plus_minus)       
                    create_configEdit_title $menueFrame.sf.lf_06  {HeadTube/DownTube}           Scalar/Lugs/HeadLug_Bottom_Angle                0.10    darkred      ;# Lugs(HeadTube/DownTube/Angle/value)           
                    create_configEdit_title $menueFrame.sf.lf_06    {      Tolerance +/-}       Scalar/Lugs/HeadLug_Bottom_Tolerance            0.10                 ;# Lugs(HeadTube/DownTube/Angle/plus_minus)      
                    create_configEdit_title $menueFrame.sf.lf_06  {BottomBracket/DownTube}      Scalar/Lugs/BottomBracket_DownTube_Angle        0.10    darkred      ;# Lugs(BottomBracket/DownTube/Angle/value)      
                    create_configEdit_title $menueFrame.sf.lf_06    {      Tolerance +/-}       Scalar/Lugs/BottomBracket_DownTube_Tolerance    0.10                 ;# Lugs(BottomBracket/DownTube/Angle/plus_minus) 
                    create_configEdit_title $menueFrame.sf.lf_06  {BottomBracket/ChainStay}     Scalar/Lugs/BottomBracket_ChainStay_Angle       0.10    darkred      ;# Lugs(BottomBracket/ChainStay/Angle/value)     
                    create_configEdit_title $menueFrame.sf.lf_06    {      Tolerance +/-}       Scalar/Lugs/BottomBracket_ChainStay_Tolerance   0.10                 ;# Lugs(BottomBracket/ChainStay/Angle/plus_minus)
                    create_configEdit_title $menueFrame.sf.lf_06  {RearDropOut}                 Scalar/Lugs/RearDropOut_Angle                   0.10    darkred      ;# Lugs(RearDropOut/Angle/value)                 
                    create_configEdit_title $menueFrame.sf.lf_06    {      Tolerance +/-}       Scalar/Lugs/RearDropOut_Tolerance               0.10                 ;# Lugs(RearDropOut/Angle/plus_minus)            
                    create_configEdit_title $menueFrame.sf.lf_06  {SeatTube/SeatStay}           Scalar/Lugs/SeatLug_SeatStay_Angle              0.10    darkred      ;# Lugs(SeatTube/SeatStay/Angle/value)           
                    create_configEdit_title $menueFrame.sf.lf_06    {      Tolerance +/-}       Scalar/Lugs/SeatLug_SeatStay_Tolerance          0.10                 ;# Lugs(SeatTube/SeatStay/Angle/plus_minus)      

                    button     $menueFrame.sf.lf_06.bt_f    -bd 4       -relief flat
                        pack $menueFrame.sf.lf_06.bt_f      -fill both  -expand yes
                    button  $menueFrame.sf.lf_06.bt_f.bt_check      -text {switch: check Frame Angles}  -width 30   -bd 1 -command [namespace current]::tubing_checkAngles
                        pack $menueFrame.sf.lf_06.bt_f.bt_check     -side right -fill both -expand yes
                        
                        

                # -----------------
                #   Rendering
            ttk::labelframe $menueFrame.sf.lf_02        -text "Check Fender"
            pack $menueFrame.sf.lf_02               -side top  -fill x  -expand yes  -pady 2
            set entryList { {Fender Front}      Config/FrontFender              Binary_OnOff  \
                            {Fender Rear}       Config/RearFender               Binary_OnOff  \
                        }
                #
            set i 10
            foreach {label xPath listName} $entryList {
                        #
                    incr i 1
                    set optionFrame [frame $menueFrame.sf.lf_02.f___$i]
                    label $optionFrame.lb -text "  $label"
                        #
					set textvariable [format "%s::%s(%s)"  [namespace current] _updateValue $xPath]
					set value [set $textvariable]
					puts "     -> \$textvariable $textvariable     <- $value"
                        #
					ttk::combobox $optionFrame.cb -textvariable $textvariable \
                         -values $rattleCAD::model::valueRegistry($listName)        -width 30
                        #
                    bind $optionFrame.cb <<ComboboxSelected>> [list [namespace current]::::ListboxEvent %W cv_Components [format "%s::%s(%s)" [namespace current] _updateValue $xPath] select]
                    bind $optionFrame.cb <ButtonPress>        [list [namespace current]::::ListboxEvent %W cv_Components [format "%s::%s(%s)" [namespace current] _updateValue $xPath] update]
                        #
                    pack $optionFrame -fill x -expand yes  -pady 2
                    pack $optionFrame.cb -side right
                    pack $optionFrame.lb -side left
            }                        
                        
                # -----------------
                #   Rendering
            ttk::labelframe $menueFrame.sf.lf_03        -text "Check DownTube Bottle"
            pack $menueFrame.sf.lf_03               -side top  -fill x  -expand yes  -pady 2
            set entryList { {BottleCage ST}     Config/BottleCage_SeatTube       BottleCage \
                            {BottleCage DT}     Config/BottleCage_DownTube       BottleCage \
                            {BottleCage DT L}   Config/BottleCage_DownTube_Lower BottleCage  \
                        }
                #
            set i 10
            foreach {label xPath listName} $entryList {
                    # set xPath [format "%s/%s" $_array $_name]

    
                    incr i 1
                    set optionFrame [frame $menueFrame.sf.lf_03.f___$i]
                    label $optionFrame.lb -text "  $label"
                        #
					set textvariable [format "%s::%s(%s)"  [namespace current] _updateValue $xPath]
					set value [set $textvariable]
					puts "     -> \$textvariable $textvariable     <- $value"
                        #
					ttk::combobox $optionFrame.cb -textvariable $textvariable \
                         -values $rattleCAD::model::valueRegistry($listName)        -width 30
                        #
                    bind $optionFrame.cb <<ComboboxSelected>> [list [namespace current]::::ListboxEvent %W cv_Components [format "%s::%s(%s)" [namespace current] _updateValue $xPath] select]
                    bind $optionFrame.cb <ButtonPress>        [list [namespace current]::::ListboxEvent %W cv_Components [format "%s::%s(%s)" [namespace current] _updateValue $xPath] update]
                        #
                    pack $optionFrame -fill x -expand yes  -pady 2
                    pack $optionFrame.cb -side right
                    pack $optionFrame.lb -side left
            }                        
                #
            return
                #
    }
    #-------------------------------------------------------------------------
       #  add content 04
       #
    proc add_BikeComponents {w} {

            variable APPL_Config
            variable componentList
            variable configValue
            variable compCanvas
                #
                # add content
                #
            set     menueFrame  [ frame $w.f_menue  -relief flat -bd 1]
            pack    $menueFrame \
                -fill both -side top -expand yes


                # -----------------
                #   build frame
            frame           $menueFrame.sf -relief flat -bd 1
            pack $menueFrame.sf         -side top  -fill x  -expand yes


                # -----------------
                #   Components
            ttk::labelframe    $menueFrame.sf.lf_01        -text "Components"
            pack $menueFrame.sf.lf_01                  -side top  -fill x  -expand yes  -pady 2

            set compList {  Component/HandleBar \
                            Component/Saddle \
                            Component/CrankSet \
                            Component/FrontBrake \
                            Component/RearBrake \
                            Component/FrontCarrier \
                            Component/RearCarrier \
                            Component/FrontDerailleur \
                            Component/RearDerailleur }
            set i 0
            foreach xPath $compList {
                        #
                    set xPathNodes  [lrange [split $xPath /] 1 end]
                    set labelString "          [lindex $xPathNodes 0]:  [lrange $xPathNodes 1 end]"
                        #
                    incr i 1
                        #puts "       ... $xPath  $configValue($xPath)"

                    set fileFrame [frame $menueFrame.sf.lf_01.f_$i]
                    label $fileFrame.lb -text $labelString
                    set alternatives [rattleCAD::model::file::get_componentAlternatives  $xPath]

                    set textvariable [format "%s::%s(%s)"  [namespace current] _updateValue $xPath]
					set value [set $textvariable]
					puts "     -> \$textvariable $textvariable     <- $value"
                        # 
                    ttk::combobox $fileFrame.cb -textvariable $textvariable \
                                               -values $alternatives   -width 30
                        #
                    pack $fileFrame     -fill x -expand yes  -pady 2
                    pack $fileFrame.cb  -side right
                    pack $fileFrame.lb  -side left
                        #
                    bind $fileFrame.cb <<ComboboxSelected>> [list [namespace current]::::ListboxEvent %W cv_Components $textvariable select]
                    bind $fileFrame.cb <ButtonPress>        [list [namespace current]::::ListboxEvent %W cv_Components $textvariable update]
            }
                #
            if {$compCanvas != {}} {
                $compCanvas destroy
            }
                #
            set compCanvas [canvasCAD::newCanvas cv_Components $menueFrame.sf.lf_01.cvCAD "_unused_"  280  210  passive  1.0  0  -bd 2  -bg white  -relief sunken]
                # puts " ---- created $compCanvas"


            ttk::labelframe $menueFrame.sf.lf_02    -text "Config"
            pack $menueFrame.sf.lf_02               -side top  -fill x -pady 2

                # -----------------
                #   Rendering
            set entryList { {Fork }             Config/Fork                      Fork  \
                            {ForkBlade}         Config/ForkBlade                 ForkBlade  \
                            {FrontBrake}        Config/FrontBrake                Brake \
                            {RearBrake}         Config/RearBrake                 Brake \
                            {BottleCage ST}     Config/BottleCage_SeatTube       BottleCage \
                            {BottleCage DT}     Config/BottleCage_DownTube       BottleCage \
                            {BottleCage DT L}   Config/BottleCage_DownTube_Lower BottleCage \
                            {FrontFender}       Config/FrontFender               Binary_OnOff  \
                            {RearFender}        Config/RearFender                Binary_OnOff  \
                        }
            set i 10
            foreach {label xPath listName} $entryList {
                        #
                    incr i 1
                    set optionFrame [frame $menueFrame.sf.lf_02.f___$i]
                    label $optionFrame.lb -text "          $label"
                        #
					set textvariable [format "%s::%s(%s)"  [namespace current] _updateValue $xPath]
					set value [set $textvariable]
					puts "     -> \$textvariable $textvariable     <- $value"
                        #
					ttk::combobox $optionFrame.cb -textvariable $textvariable \
                         -values $rattleCAD::model::valueRegistry($listName)        -width 30
                        #
                    bind $optionFrame.cb <<ComboboxSelected>> [list [namespace current]::ListboxEvent %W cv_Components [format "%s::%s(%s)" [namespace current] _updateValue $xPath] select]
                    bind $optionFrame.cb <ButtonPress>        [list [namespace current]::ListboxEvent %W cv_Components [format "%s::%s(%s)" [namespace current] _updateValue $xPath] update]
                        #
                    pack $optionFrame -fill x -expand yes  -pady 2
                    pack $optionFrame.cb -side right
                    pack $optionFrame.lb -side left
            }


            # -----------------
            #   Update Values

    }




    #-------------------------------------------------------------------------
       #  ListboxEvent Event
       #
    proc ListboxEvent {w targetCanvas targetVar mode} {
                #
            puts "        == START == rattleCAD::configPanel::ListboxEvent ==================="
                #
                # http://www.tek-tips.com/viewthread.cfm?qid=822756&page=42
                # 2010.10.15
            variable compFile
                # puts "ListboxEvent:  $w / [$w get]"
                # puts "ListboxEvent:  $targetCanvas"
            set compFile [$w get]
                #
            set key [lindex [split [lindex [split $targetVar :] end] ()] 1]
            set value [set $targetVar]
                #
                puts ""
                puts "   -------------------------------"
                puts "    ListboxEvent"
                puts "       compFile:       $compFile"
                puts "       targetVar:      $targetVar"
                puts "       key:            $key"
                puts "       value:          [set $targetVar]"
                puts "       targetCanvas:   $targetCanvas"
                puts "       mode:           $mode"
                    #
            catch {[namespace current]::updateCanvas $targetCanvas}
                #
                # return
            if {$mode == {select}} {
            
                puts "           ... \$targetVar $targetVar"
                    #
                rattleCAD::control::setValue  [list $key $value]
                rattleCAD::view::close_allEdit

            }
                # puts "    ListboxEvent ... done"
                #
            puts "        ==== END == rattleCAD::configPanel::ListboxEvent ==================="
                #
    }

    #-------------------------------------------------------------------------
       #  create config_line
       #
    proc updateCanvas {targetCanvas} {
            variable compCanvas
            variable frameCanvas
            variable compFile

                puts ""
                puts "   -------------------------------"
                puts "    updateCanvas"
                puts "       compFile:       $compFile"

            set fileName {}
			switch -glob $compFile {
                etc:*  {  set fileName  [file join $::APPL_Config(COMPONENT_Dir))           [lindex [split $compFile {:}] 1] ] }
                user:* {  set fileName  [file join $::APPL_Config(USER_Dir)   components    [lindex [split $compFile {:}] 1] ] }
                default {}
            }
                puts "\n       fileName:       $fileName\n"

            if {$fileName != {}} {
                switch -regexp -- $targetCanvas {
                    cv_frameParts {
                                # puts "            ... $frameCanvas"
                                $frameCanvas clean_StageContent
                                set __my_Component__        [ $frameCanvas readSVG $fileName {0 0} 0  __Decoration__ ]
                                $frameCanvas fit2Stage $__my_Component__
                                $frameCanvas refitStage
                            }
                    cv_Components {
                                # puts "            ... $compCanvas"
                                $compCanvas clean_StageContent
                                set __my_Component__        [ $compCanvas readSVG $fileName {0 0} 0  __Decoration__ ]
                                $compCanvas fit2Stage $__my_Component__
                                $compCanvas refitStage
                            }
                    default {
                                puts " ... do hots wos: $targetCanvas"
                            }
                }
            }
    }



    #-------------------------------------------------------------------------
       #  postion config panel to main window
       #
    proc reposition_to_main {main w} {

            variable cfg_Position

            if {![winfo exists $w]} return

            # wm deiconify   $w

            set root_xy [split  [wm geometry $main] +]
            set root_w    [winfo  width $main]
            set root_x    [lindex $root_xy 1]
            set root_y    [lindex $root_xy 2]

            set update no

            if {$root_x != [lindex $cfg_Position 0]} {set update yes}
            if {$root_y != [lindex $cfg_Position 1]} {set update yes}
            if {$root_w != [lindex $cfg_Position 2]} {set update resize}

            switch $update {
                yes {
                        set dx [lindex $cfg_Position 3]
                        set dy [lindex $cfg_Position 4]
						  # puts "   -> reposition_to_main  - $w +[expr $root_x+$dx]+[expr $root_y+$dy]"
                        catch {wm geometry    $w +[expr $root_x+$dx]+[expr $root_y+$dy]}
                    }
                resize {
                        set d_root [expr $root_w - [lindex $cfg_Position 2]]
                        set dx [ expr [lindex $cfg_Position 3] + $d_root ]
                        set dy [lindex $cfg_Position 4]
                        catch {wm geometry    $w +[expr $root_x+$dx]+[expr $root_y+$dy]}
                }
            }
    }

    #-------------------------------------------------------------------------
       #  register_relative_position
       #
    proc register_relative_position {main w} {

            variable cfg_Position

            set root_xy [split  [wm geometry $main] +]
            set root_w  [winfo width $main]
            set root_x  [lindex $root_xy 1]
            set root_y  [lindex $root_xy 2]
                # puts "    main: $main: $root_x  $root_y"

            set w_xy [split  [wm geometry $w] +]
                # puts "    w   .... $w_xy"
            set w_x [lindex $w_xy 1]
            set w_y [lindex $w_xy 2]
                # puts "    w   ..... $w: $w_x  $w_y"
            set d_x     [ expr $w_x-$root_x]
            set d_y     [ expr $w_y-$root_y]
                # puts "    w   ..... $w: $d_x  $d_y"
                # puts "    w   ..... $root_x $root_y $d_x $d_y"
            set cfg_Position [list $root_x $root_y $root_w $d_x $d_y ]
                # puts "     ... register_relative_position $cfg_Position"
    }

    #-------------------------------------------------------------------------
       #  binding on config_line
       #
    proc change_ValueEdit {textVar scale direction} {
            
			variable _currentValue
            variable _updateValue
                #
			variable Personal     	
			variable Custom      	
			variable Component     	
			variable Result       	
			variable Lugs         	
			variable FrameTubes 			
			
			#
            # --- dynamic update value ---
                puts "  <D>  \$textVar $textVar [set $textVar]"
				set currentValue [set $textVar]
                # puts "    -> $direction"
                # puts "    -> $scale"
            #
            # --- update value of spinbox ---
                switch -glob $direction {
                        "Up"        {set newValue [expr {$currentValue + $scale}]}
                        "Down"      {set newValue [expr {$currentValue - $scale}]}
                        "default"   {return}
                }
                set $textVar [format "%.3f" $newValue]
    }


    #-------------------------------------------------------------------------
       #  create config_line
       #
    proc create_config_cBox {w _arrayName contentList} {

            variable _currentValue
            variable _updateValue
                #
			variable    cboxList
                # variable    configValue
                #set _array [lindex [split $_arrayName (] 0]
                #set _name [lindex [split $_arrayName ()] 1]


                #set xPath       [format "%s/%s" $_array $_name]
                #eval set configValue($xPath)    [format "$%s::%s(%s)" project $_array $_name]
                #set labelString $_name
            
            set xPath $_arrayName
                # eval set configValue($xPath)    [format "$%s(%s)" $_array $_name]
                # puts "   -> [format "$%s(%s)" $_array $_name]     <--- $xPath  <- $_array $_name "
            puts "   -> \$xPath ... $xPath"
                # eval set configValue($xPath)    [format "$%s::%s(%s)" project $_array $_name]
                # set labelString $_name
            set xPathNodes  [lrange [split $xPath /] 1 end]
            set labelString "[lindex $xPathNodes 0]:  [lrange $xPathNodes 1 end]"

                # --------------
                    # puts "    .. check ..     $xPath    "
                    # puts "    .. check ..     [namespace current]::configValue($xPath)    "
            set cboxCount [llength $cboxList]
                    # puts "      ... \$cboxCount $cboxCount"
                    # puts "      ... $rdialCount"
                    # set       $entryVar $current
                    # puts "   ... \$entryVar [list [format "$%s" $entryVar]]"

            set cfgFrame    [frame   [format "%s.fcbx_%s" $w $cboxCount]]
            pack    $cfgFrame -fill x

            if {[string length $labelString] > 29} {
                set labelString "[string range $labelString 0 26] .."
            }
            
                #set     textvariable [format "%s(%s)"  $_array $_name]
                # set     textvariable [format "%s::%s(%s)"  [namespace current] $_array $_name]
                
            set textvariable [format "%s::%s(%s)"  [namespace current] _updateValue $xPath]
                # puts "  $textvariable"
                
            puts "     create_configEdit:  \$textvariable $textvariable"                  
            puts "     create_configEdit:  [set $textvariable]"
            
            
            label   $cfgFrame.lb    -text "   $labelString:"      \
                            -bd 1  -anchor w

            ttk::combobox $cfgFrame.cb \
                            -textvariable $textvariable \
                            -values $contentList    \
                            -width 17 \
                            -height 10 \
                            -justify right 
							
                            #-postcommand [list eval set [namespace current]::oldValue \$[namespace current]::configValue($xPath)]


            lappend cboxList $cfgFrame.cb

            bind $cfgFrame.cb <<ComboboxSelected>>     [list [namespace current]::check_Value %W $xPath]
                # bind $cfgFrame.cb <<ComboboxSelected>>     [list [namespace current]::check_Value %W $xPath [format "%s::%s(%s)" [namespace current] _updateValue $textvariable]]
                # bind $cfgFrame.cb <<ComboboxSelected>>     [list [namespace current]::check_Value %W $xPath [format "%s::%s(%s)" [namespace current] $_array $_name]]
                # bind $cfgFrame.cb <<ComboboxSelected>>     [list [namespace current]::check_Value %W $xPath [format "%s::%s(%s)" project $_array $_name]]

            pack      $cfgFrame.lb  -side left
            pack      $cfgFrame.cb  -side right  -fill x
    }


    #-------------------------------------------------------------------------
       #  create config_line
       #
    proc create_configEdit_title {w title _arrayName scale {color {}}} {
            set cDial [create_configEdit $w $_arrayName $scale $color]
            $cDial.lb   configure -text "   $title"
    }
    #-------------------------------------------------------------------------
       #  create config_line
       #
    proc create_configEdit {w _arrayName scale {color {}}} {

			variable _currentValue
            variable _updateValue
                #
			variable Personal     	
			variable Custom      	
			variable Component     	
			variable Result       	
			variable Lugs         	
			variable FrameTubes 

			  # puts "  <D>  \$FrameTubes(HeadTube/Length):   $FrameTubes(HeadTube/Length)"

			variable    rdials_list
                # variable    configValue
                #set _array [lindex [split $_arrayName (] 0]
                #set _name  [lindex [split $_arrayName ()] 1]


                # set xPath       [format "%s/%s" $_array $_name]
            
            set xPath $_arrayName
                # eval set configValue($xPath)    [format "$%s(%s)" $_array $_name]
                # puts "   -> [format "$%s(%s)" $_array $_name]     <--- $xPath  <- $_array $_name "
            puts "   -> \$xPath ... $xPath"
                # eval set configValue($xPath)    [format "$%s::%s(%s)" project $_array $_name]
                # set labelString $_name
            set xPathNodes  [lrange [split $xPath /] 1 end]
            set labelString "[lindex $xPathNodes 0]:  [lrange $xPathNodes 1 end]"


                # --------------
                    # puts "    .. check ..     $xPath    "
                    # puts "    .. check ..     [namespace current]::configValue($xPath)    "
            set rdialCount [llength $rdials_list]
                    # puts "      ... $rdialCount"
                    # set       $entryVar $current
                    # puts "   ... \$entryVar [list [format "$%s" $entryVar]]"

            set cfgFrame    [frame   [format "%s.fscl_%s" $w $rdialCount]]
            pack    $cfgFrame -fill x -expand yes

            if {[string length $labelString] > 33} {
                set labelString "[string range $labelString 0 29] .."
            }
			set textvariable [format "%s::%s(%s)"  [namespace current] _updateValue $xPath]
			# puts "  $textvariable"
            
            puts "     create_configEdit:  \$textvariable $textvariable"                  
            puts "     create_configEdit:  [set $textvariable]"
            
            label   $cfgFrame.sp    -text ""      \
                            -bd 1
            label   $cfgFrame.lb    -text "   $labelString "      \
                            -width 30  \
                            -bd 1  -anchor w

            entry   $cfgFrame.cfg    \
                            -textvariable $textvariable \
                            -width 10  \
                            -bd 1  -justify right -bg white

            

            if {$color != {}} {
                $cfgFrame.lb  configure -fg $color
                $cfgFrame.cfg configure -fg $color
            }


            lappend rdials_list [expr [llength $rdials_list] + 1]

            bind $cfgFrame.cfg <Key>        [list [namespace current]::change_ValueEdit $textvariable $scale %K]
            bind $cfgFrame.cfg <Enter>      [list [namespace current]::bind_enterEntry  $cfgFrame.cfg]
            bind $cfgFrame.cfg <Leave>      [list [namespace current]::bind_leaveEntry  $cfgFrame.cfg]
            bind $cfgFrame.cfg <Return>     [list [namespace current]::bind_leaveEntry  $cfgFrame.cfg]

            bind $cfgFrame.cfg <Double-1>   [list [namespace current]::bind_selectEntry $cfgFrame.cfg]  ;#

            bind $cfgFrame.cfg <MouseWheel> [list [namespace current]::bind_MouseWheel $cfgFrame.cfg $scale %D]  ;# move up/down
            bind $cfgFrame.cfg <Key-Up>     [list [namespace current]::bind_MouseWheel $cfgFrame.cfg $scale  1]
            bind $cfgFrame.cfg <Key-Down>   [list [namespace current]::bind_MouseWheel $cfgFrame.cfg $scale -1]


            pack      $cfgFrame.cfg  $cfgFrame.lb $cfgFrame.sp  -side right
            pack configure $cfgFrame.sp  -fill x
            pack configure $cfgFrame.cfg -padx 2
                    # pack      $cfgFrame.sp  $cfgFrame.lb  $cfgFrame.cfg  $cfgFrame.f  -side left  -fill x
                    # pack      $cfgFrame.lb  $cfgFrame.cfg  $cfgFrame.f  $cfgFrame.f.scl -side left  -fill x
                    # pack      $cfgFrame.lb  $cfgFrame.cfg  $cfgFrame.f  $cfgFrame.f.scl $cfgFrame.bt   -side left  -fill x
                    # pack      configure $cfgFrame.f  -padx 2
            return    $cfgFrame
    }
    proc bind_MouseWheel {entry scale value} {
            #variable canvasUpdate
            #variable noteBook_top

                #puts "\n=================="
                #puts "    bind_MouseWheel"
                #puts "       var    $var"
                #puts "       scale  $scale"
                #puts "       value  $value"



            set targetVar   [$entry cget -textvariable]
            eval set oldValue   \$$targetVar
                # puts "   -> $targetVar"
                # puts "   -> $oldValue"
            if {$value < 0} {set scale [expr -1.0*$scale]}
            set newValue  [expr $oldValue + $scale]
            set newValue [format "%.3f" $newValue]
                # puts "  -> newValue $newValue"
            set $targetVar $newValue
                # eval puts \"  ->    \$$targetVar\"

            return
    }
    proc bind_selectEntry {entry} {
            # puts "   ... selectEntry"
            return
    }
    proc bind_enterEntry {entry} {
            
			variable _currentValue
            variable _updateValue
                #
			variable Personal     	
			variable Custom      	
			variable Component     	
			variable Result       	
			variable Lugs         	
			variable FrameTubes

			return
			
			set entryVar [$entry cget -text]
            eval set currentValue     [expr 1.0 * \$$entryVar]
            set value [format "%.3f" $currentValue]
            # set [namespace current]::configValue(entry) $value

            return
    }
    proc bind_leaveEntry {entry} {
                #
            puts "        == START == rattleCAD::configPanel::bind_leaveEntry ================"
                #
            variable _currentValue
            variable _updateValue
                #
			variable Personal     	
			variable Custom      	
			variable Component     	
			variable Result       	
			variable Lugs         	
			variable FrameTubes 
			
			set targetVar   [$entry cget -textvariable]
            set _array      [lindex [split $targetVar (:] 2]
            set _name       [lindex [split $targetVar ()] 1]

            set entryVar [$entry cget -text]
            eval set value   \$$entryVar
            set value [expr 1.0 * [string map {, .} $value]]
			set value [format "%.3f" $value]

                #
            puts "           ... \$targetVar $targetVar"
            puts "           ... \$entryVar  $entryVar"
            puts "           ... \$value   $value"
                #
            set key [lindex [split [lindex [split $targetVar :] end] ()] 1]
            foreach {_array _name path} [rattleCAD::model::unifyKey $key] break
			    # puts "   -> \$key $key"
            puts "           ... $key"    
            puts "           ... $_array $_name $path"    
                #
			rattleCAD::control::setValue  [list $path $value]
			rattleCAD::view::close_allEdit
                #
            puts "        ==== END == rattleCAD::configPanel::bind_leaveEntry ================"
                #
    }
	proc bind_notebookTabChanged {notebook} {
        puts "   -> $notebook"
		puts "       -> [$notebook select] "
		switch -exact [$notebook select] {
		    {.cfg.f.nb.geometry}    { set target {cv_Custom00} }
			{.cfg.f.nb.frameDetail} { set target {cv_Custom10} }
			{.cfg.f.nb.frameCheck}  { set target {cv_Custom10} }
			{.cfg.f.nb.bikeComp}    { set target {cv_Custom50} }
			default {}
		}
		
		rattleCAD::view::gui::select_canvasCAD   $target
    }	

    proc tubing_checkAngles {} {
            rattleCAD::view::gui::select_canvasCAD   cv_Custom10
            rattleCAD::cv_custom::updateView   [rattleCAD::view::gui::current_canvasCAD]
            rattleCAD::view::check_TubingAngles
    }


    proc check_Value { w xPath} {
                #
            set oldValue {}
                #
            #puts "            -- rattleCAD::configPanel::check_Value -------start--"
			#puts "                    $w $xPath"
                #
            switch $xPath {
                    {Scalar/Geometry/RearRim_Diameter} {
                                # set oldValue [rattleCAD::model::get_Value RearWheel RimDiameter]
                            set oldValue [rattleCAD::model::get_Scalar Geometry RearRim_Diameter]
                        }
                    {Scalar/Geometry/FrontRim_Diameter} {
                                # set oldValue [rattleCAD::model::get_Value FrontWheel RimDiameter]
                            set oldValue [rattleCAD::model::get_Scalar Geometry FrontRim_Diameter]
                         }
                    default {}
            }
                #
            switch $xPath {
                    {Scalar/Geometry/RearRim_Diameter} -
                    {Scalar/Geometry/FrontRim_Diameter}  {
                                #
							set textvariable [$w cget -textvariable]
							set textValue    [set $textvariable]
                                #
							if {[string range $textValue 0 3] == "----"} {
                                set $textvariable $oldValue
								return
                            } else {
							    set value [string trim [lindex [split $textValue ;] 0]]
                                set value [format "%.3f" $value]
                                rattleCAD::control::setValue [list $xPath $value]
								rattleCAD::view::close_allEdit
								return
						    }
                        }
					default {
					        #puts " ... check_Value: $xPath"
					    }
            }
            
            #puts "            -- rattleCAD::configPanel::check_Value ---------end--"
			
    }
}

