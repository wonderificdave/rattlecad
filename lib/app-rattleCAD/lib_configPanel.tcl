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
 #  namespace:  rattleCAD::config
 # ---------------------------------------------------------------------------
 #
 #

 namespace eval rattleCAD::config {

    variable    cfg_Position    {}

    variable    rdials_list     {}
    variable    cboxList        {}

    variable    configValue
    array set   configValue     {}

    variable    componentList   {}
    variable    compCanvas      {}
    variable    frameCanvas     {}
    
    variable    projectDOM
	
	variable Personal  ;    array set Personal {
									HandleBar_Distance   {a}
									HandleBar_Height     {b}
									Saddle_Distance      {c}
									Saddle_Height        {d}
									InnerLeg_Length      {e}
	                            }
	variable Custom    ;    array set Custom {
									WheelPosition/Rear    {a}
									BottomBracket/Depth   {b}
									TopTube/PivotPosition {c}
                                    TopTube/OffsetHT      {d}
									DownTube/OffsetHT     {e}
									SeatTube/Extension    {f}
									SeatStay/OffsetTT     {g}
									TopTube/Angle         {h}
									HeadTube/Angle        {i}
									DownTube/OffsetBB	  {j}
	                            }
	variable Component ;    array set Component {
									SeatPost/Setback      {a}
									Fork/Rake             {b}
									Fork/Height           {c}
									Stem/Angle            {d}
									Stem/Length           {e}
									Wheel/Rear/RimDiameter   {} 
									Wheel/Rear/TyreHeight    {}
									Wheel/Front/RimDiameter  {} 
									Wheel/Front/TyreHeight	 {}
									HeadSet/Height/Bottom    {}
	                            }
	variable Result    ;    array set Result {
									Length/TopTube/VirtualLength   {b}
									Length/FrontWheel/horizontal   {bb}
									Length/FrontWheel/diagonal     {b}
									Length/BottomBracket/Height    {bb}
									Length/Saddle/SeatTube_BB      {b}
									Angle/HeadTube/TopTube         {bb}
	                            }
	variable Lugs       ;    array set Lugs {
									HeadTube/TopTube/Angle/value               {a}
									HeadTube/TopTube/Angle/plus_minus          {b}
									HeadTube/DownTube/Angle/value              {c}
									HeadTube/DownTube/Angle/plus_minus         {d}
									BottomBracket/DownTube/Angle/value         {e}
									BottomBracket/DownTube/Angle/plus_minus    {f}
									BottomBracket/ChainStay/Angle/value        {g}
									BottomBracket/ChainStay/Angle/plus_minus   {h}
									RearDropOut/Angle/value                    {i}
									RearDropOut/Angle/plus_minus               {j}
									SeatTube/SeatStay/Angle/value              {k}
									SeatTube/SeatStay/Angle/plus_minus 		   {l}
	                            }
	variable FrameTubes ;    array set FrameTubes {
									HeadTube/Length                            {}
	                            } 
	

    proc init_configValues {} {
	
			variable Personal     	
			variable Custom      	
			variable Component     	
			variable Result       	
			variable Lugs         	
			variable FrameTubes 

			
			puts "\n\n configPanel - Update \n\n"
			# foreach arrayNameComplete [appUtil::_childArrays {::rattleCAD::config}] {}
			foreach arrayNameComplete [appUtil::_childArrays [namespace current]] {
				puts "    -> $arrayNameComplete"
				set arrayName [lindex [split $arrayNameComplete :] end]
				foreach key [lsort [array names $arrayNameComplete]] {
					set value [rattleCAD::control::getValue $arrayName/$key]
					puts "        -> $key   -> $value"
					
					#puts " <D>           $::rattleCAD::config::Component(Fork/Height)"
					set command [format "set %s(%s) %s" $arrayName $key $value]
					{*}$command
					
					#puts "  set value \$$arrayName($key)]
					set value [array get $arrayName $key]
					puts "    -> [lindex $value 1]"
					# eval set value [set $arrayName($key)]
					#{*}$command
					#puts " <D>           $arrayName/$key $value"
					#puts " <D>           $::rattleCAD::config::Component(Fork/Heigh)"
				}
			}	
					puts " <D>           $Component(Fork/Height)"
					puts " <D>           $::rattleCAD::config::Component(Fork/Height)"
			
			update
			# exit
	
	
	}


    #-------------------------------------------------------------------------
       #  create config widget
       #
    proc create {main w {mode {}}} {

            variable cfg_Position

                # -----------------
                # main window information
            set root_xy [split  [wm geometry $main] +]
            set root_w     [winfo width $main]
            set root_x    [lindex $root_xy 1]
            set root_y    [lindex $root_xy 2]


                # -----------------
                # check if window exists
            if {[winfo exists $w]} {
                    # restore if hidden
                    # puts "   ... $w allready exists!"
                wm geometry    $w +[expr $root_x+8+$root_w]+[expr $root_y]
                if {$mode == {refresh}} {
                    create_Content $main $w
                }
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
            wm geometry    $w +[expr $root_x+8+$root_w]+[expr $root_y]


                # -----------------
                # create content
            create_Content $main $w

                # -----------------
                #
            set cfg_Position [list $root_x $root_y $root_w [expr $root_x+8+$root_w] 0 ]

                # -----------------
                #
            bind $w        <Configure> [list [namespace current]::register_relative_position     $main $w]
            bind $main     <Configure> [list [namespace current]::reposition_to_main              $main $w]

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
            add_Basic     $nb_Config.geometry
            $nb_Config select   $nb_Config.frameDetail
            add_FrameDetails    $nb_Config.frameDetail
            $nb_Config select   $nb_Config.frameCheck
            add_FrameCheck      $nb_Config.frameCheck
            $nb_Config select   $nb_Config.bikeComp
            add_BikeComponents  $nb_Config.bikeComp
            $nb_Config select $nb_Config.geometry

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
                    create_configEdit $menueFrame.sf.lf_01      Personal(HandleBar_Distance)    0.20  orangered
                    create_configEdit $menueFrame.sf.lf_01      Personal(HandleBar_Height)      0.20  orangered
                    create_configEdit $menueFrame.sf.lf_01      Personal(Saddle_Distance)       0.20  orangered
                    create_configEdit $menueFrame.sf.lf_01      Personal(Saddle_Height)         0.02  orangered
                    create_configEdit $menueFrame.sf.lf_01      Personal(InnerLeg_Length)       0.20  darkviolet
                    create_configEdit $menueFrame.sf.lf_01      Custom(TopTube/PivotPosition)   0.20  darkviolet

                # -----------------
                #   Concept
            ttk::labelframe    $menueFrame.sf.lf_02        -text "Base Concept - Secondary Values"
                pack $menueFrame.sf.lf_02                 -side top  -fill x  -expand yes  -pady 2
                    create_configEdit $menueFrame.sf.lf_01      Component(SeatPost/Setback)     0.20  darkred
                    create_configEdit $menueFrame.sf.lf_02      Component(Fork/Rake)            0.20  darkred
                    create_configEdit $menueFrame.sf.lf_02      Component(Fork/Height)          0.20  darkred
                    create_configEdit $menueFrame.sf.lf_02      Custom(HeadTube/Angle)          0.02  darkred
                    create_configEdit $menueFrame.sf.lf_02      Component(Stem/Angle)           0.10  darkred
                    create_configEdit $menueFrame.sf.lf_02      Component(Stem/Length)          0.20  darkred
                    create_configEdit $menueFrame.sf.lf_02      Custom(WheelPosition/Rear)      0.20  darkred
                    create_configEdit $menueFrame.sf.lf_02      Custom(BottomBracket/Depth)     0.20  darkred

                # -----------------
                #   Alternatives
            ttk::labelframe    $menueFrame.sf.lf_03        -text "Base Concept - Alternative Values"
                pack $menueFrame.sf.lf_03                 -side top  -fill x  -expand yes  -pady 2
                    create_configEdit $menueFrame.sf.lf_03      Result(Length/TopTube/VirtualLength)    0.20  darkblue
                    create_configEdit $menueFrame.sf.lf_03      Result(Length/FrontWheel/horizontal)    0.20  darkblue
                    create_configEdit $menueFrame.sf.lf_03      Result(Length/FrontWheel/diagonal)      0.20  darkblue
                    create_configEdit $menueFrame.sf.lf_03      Result(Length/BottomBracket/Height)     0.20  darkblue
                    create_configEdit $menueFrame.sf.lf_03      Result(Length/Saddle/SeatTube_BB)       0.20  darkblue
                    
                # -----------------
                #   Wheels
            ttk::labelframe $menueFrame.sf.lf_04        -text "Wheels"
                pack $menueFrame.sf.lf_04               -side top  -fill x  -pady 2

                    create_config_cBox  $menueFrame.sf.lf_04    Component(Wheel/Rear/RimDiameter)     $::APPL_Config(list_Rims)
                    create_configEdit   $menueFrame.sf.lf_04    Component(Wheel/Rear/TyreHeight)     0.20
                    create_config_cBox  $menueFrame.sf.lf_04    Component(Wheel/Front/RimDiameter)  $::APPL_Config(list_Rims)
                    create_configEdit   $menueFrame.sf.lf_04    Component(Wheel/Front/TyreHeight)     0.20

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
                pack $menueFrame.sf.lf_01                  -side top  -fill x  -expand yes  -pady 2
                    create_configEdit_title $menueFrame.sf.lf_01    {HeadTube - Length}             FrameTubes(HeadTube/Length)         0.20  darkred
                    create_configEdit_title $menueFrame.sf.lf_01    {HeadTube/TopTube - Angle}      Result(Angle/HeadTube/TopTube)      0.02  darkblue
                    create_configEdit_title $menueFrame.sf.lf_01    {HeadTube/TopTube - Offset}     Custom(TopTube/OffsetHT)            0.20  darkred
                    create_configEdit_title $menueFrame.sf.lf_01    {HeadTube/DownTube - Offset}    Custom(DownTube/OffsetHT)           0.20  darkred
                    create_configEdit_title $menueFrame.sf.lf_01    {HeadSet - BottomHeight}        Component(HeadSet/Height/Bottom)    0.20  darkred
                    create_configEdit_title $menueFrame.sf.lf_01    {SeatTube - Extension}          Custom(SeatTube/Extension)          0.20  darkred
                    create_configEdit_title $menueFrame.sf.lf_01    {TopTube/SeatStay - Offset}     Custom(SeatStay/OffsetTT)           0.20  darkred
                    create_configEdit_title $menueFrame.sf.lf_01    {TopTube - Angle}               Custom(TopTube/Angle)               0.20  darkred
                    create_configEdit_title $menueFrame.sf.lf_01    {DownTube/BB - Offset}          Custom(DownTube/OffsetBB)           0.20  darkred


                # -----------------
                #   Frame Parts
            ttk::labelframe    $menueFrame.sf.lf_09        -text "Frame & Fork Parts"
                pack $menueFrame.sf.lf_09                 -side top  -fill x  -expand yes  -pady 2

                set compList {    Rendering/Fork \
                                  Lugs/RearDropOut/File \
                                  Component/Fork/Crown/File \
                                  Component/Fork/DropOut/File}
                    set i 0
                foreach xPath $compList {
                        set _array  [lindex [split $xPath /] 0]
                        set _name   [string range $xPath [string length $_array/] end]

                        incr i 1
                        # puts "       ... $xPath  $configValue($xPath)"

                        set fileFrame [frame $menueFrame.sf.lf_09.f_$i]
                        switch -exact $xPath {
                            Rendering/Fork {
                                label $fileFrame.lb -text "  Select ForkType:"
                                  # puts "\n  \$fileFrame $fileFrame  \$xPath $xPath\n"
                                  # puts "     SELECT_ForkType"
                                set listBoxContent [ rattleCAD::view::get_listBoxContent SELECT_ForkType Rendering(Fork))]
                                foreach entry $listBoxContent {
                                    puts "         ... $entry"
                                }
                            }
                            default {
                                label $fileFrame.lb -text "  [join [lrange [lrange [split $xPath /] 1 end-1] end-1 end] {-}]:"
                                set listBoxContent [rattleCAD::file::get_componentAlternatives  $xPath]
                            }
                        }
                        ttk::combobox $fileFrame.cb -textvariable [namespace current]::configValue($xPath) \
                                                    -values $listBoxContent   -width 30
                            pack $fileFrame     -fill x -expand yes  -pady 2
                            pack $fileFrame.cb  -side right
                            pack $fileFrame.lb  -side left

                        set key [format "%s(%s)" $_array $_name]
                        bind $fileFrame.cb <<ComboboxSelected>> [list [namespace current]::::ListboxEvent %W cv_frameParts [format "%s::%s(%s)" project $_array $_name] select]
                        bind $fileFrame.cb <ButtonPress>        [list [namespace current]::::ListboxEvent %W cv_frameParts [format "%s::%s(%s)" project $_array $_name] update]

                            # [ bikeGeometry::set_Value $xPathString $value format]
                            # bind $fileFrame.cb <<ComboboxSelected>> [list [namespace current]::::ListboxEvent %W cv_frameParts [format "%s::%s(%s)" project $_array $_name] select]
                            # bind $fileFrame.cb <ButtonPress>        [list [namespace current]::::ListboxEvent %W cv_frameParts [format "%s::%s(%s)" project $_array $_name] update]
                }
                

                if {$frameCanvas != {}} {
                    # puts "   ... 0 $compCanvas  exists"
                    $frameCanvas destroy
                }
                set frameCanvas [canvasCAD::newCanvas cv_FrameParts $menueFrame.sf.lf_09.cvCAD "_unused_"  280  210  passive  1.0  0  -bd 2  -bg white  -relief sunken]
                    # puts " ---- created $compCanvas"

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
                    create_configEdit_title $menueFrame.sf.lf_06  {HeadTube/TopTube}            Lugs(HeadTube/TopTube/Angle/value)              0.10    darkred
                    create_configEdit_title $menueFrame.sf.lf_06    {      Tolerance +/-}       Lugs(HeadTube/TopTube/Angle/plus_minus)         0.10
                    create_configEdit_title $menueFrame.sf.lf_06  {HeadTube/DownTube}           Lugs(HeadTube/DownTube/Angle/value)             0.10    darkred
                    create_configEdit_title $menueFrame.sf.lf_06    {      Tolerance +/-}       Lugs(HeadTube/DownTube/Angle/plus_minus)        0.10
                    create_configEdit_title $menueFrame.sf.lf_06  {BottomBracket/DownTube}      Lugs(BottomBracket/DownTube/Angle/value)        0.10    darkred
                    create_configEdit_title $menueFrame.sf.lf_06    {      Tolerance +/-}       Lugs(BottomBracket/DownTube/Angle/plus_minus)   0.10
                    create_configEdit_title $menueFrame.sf.lf_06  {BottomBracket/ChainStay}     Lugs(BottomBracket/ChainStay/Angle/value)       0.10    darkred
                    create_configEdit_title $menueFrame.sf.lf_06    {      Tolerance +/-}       Lugs(BottomBracket/ChainStay/Angle/plus_minus)  0.10
                    create_configEdit_title $menueFrame.sf.lf_06  {RearDropOut}                 Lugs(RearDropOut/Angle/value)                   0.10    darkred
                    create_configEdit_title $menueFrame.sf.lf_06    {      Tolerance +/-}       Lugs(RearDropOut/Angle/plus_minus)              0.10
                    create_configEdit_title $menueFrame.sf.lf_06  {SeatTube/SeatStay}           Lugs(SeatTube/SeatStay/Angle/value)             0.10    darkred
                    create_configEdit_title $menueFrame.sf.lf_06    {      Tolerance +/-}       Lugs(SeatTube/SeatStay/Angle/plus_minus)        0.10

                    button     $menueFrame.sf.lf_06.bt_f    -bd 4       -relief flat
                        pack $menueFrame.sf.lf_06.bt_f      -fill both  -expand yes
                    button  $menueFrame.sf.lf_06.bt_f.bt_check      -text {switch: check Frame Angles}  -width 30   -bd 1 -command [namespace current]::tubing_checkAngles
                        pack $menueFrame.sf.lf_06.bt_f.bt_check     -side right -fill both -expand yes

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

                set compList {  Component/HandleBar/File \
                                Component/Saddle/File \
                                Component/CrankSet/File \
                                Component/Brake/Front/File \
                                Component/Brake/Rear/File \
                                Component/Derailleur/Front/File \
                                Component/Derailleur/Rear/File }
                    set i 0
                foreach xPath $compList {
                        set _array  [lindex [split $xPath /] 0]
                        set _name   [string range $xPath [string length $_array/] end]

                        incr i 1
                        #puts "       ... $xPath  $configValue($xPath)"

                        set fileFrame [frame $menueFrame.sf.lf_01.f_$i]
                        label $fileFrame.lb -text "  [join [lrange [lrange [split $xPath /] 1 end-1] end-1 end] {-}]:"
                        set alternatives [rattleCAD::file::get_componentAlternatives  $xPath]

                        ttk::combobox $fileFrame.cb -textvariable [namespace current]::configValue($xPath) \
                                                    -values $alternatives   -width 30
                            pack $fileFrame     -fill x -expand yes  -pady 2
                            pack $fileFrame.cb  -side right
                            pack $fileFrame.lb  -side left

                            bind $fileFrame.cb <<ComboboxSelected>> [list [namespace current]::::ListboxEvent %W cv_Components [format "%s::%s(%s)" project $_array $_name] select]
                            bind $fileFrame.cb <ButtonPress>        [list [namespace current]::::ListboxEvent %W cv_Components [format "%s::%s(%s)" project $_array $_name] update]
                }

                if {$compCanvas != {}} {
                    # puts "   ... 0 $compCanvas  exists"
                    $compCanvas destroy
                }

                set compCanvas [canvasCAD::newCanvas cv_Components $menueFrame.sf.lf_01.cvCAD "_unused_"  280  210  passive  1.0  0  -bd 2  -bg white  -relief sunken]
                    # puts " ---- created $compCanvas"


            ttk::labelframe $menueFrame.sf.lf_02        -text "Options"
                pack $menueFrame.sf.lf_02               -side top  -fill x -pady 2

                # -----------------
                #   Rendering
                set entryList { {Fork Type}         Rendering Fork                      list_ForkTypes  \
                                {Fork Blade Type}   Rendering ForkBlade                 list_ForkBladeTypes  \
                                {Brake Type Front}  Rendering Brake/Front               list_BrakeTypes \
                                {Brake Type Rear}   Rendering Brake/Rear                list_BrakeTypes \
                                {BottleCage ST}     Rendering BottleCage/SeatTube       list_BottleCage \
                                {BottleCage DT}     Rendering BottleCage/DownTube       list_BottleCage \
                                {BottleCage DT L}   Rendering BottleCage/DownTube_Lower list_BottleCage \
                            }
                    set i 10
                foreach {label _array _name listName} $entryList {
                        set xPath [format "%s/%s" $_array $_name]

    
                        incr i 1
                        set optionFrame [frame $menueFrame.sf.lf_02.f___$i]
                        label $optionFrame.lb -text "  $label"
                        ttk::combobox $optionFrame.cb -textvariable [namespace current]::configValue($xPath) \
                                                    -values $::APPL_Config($listName)        -width 30

                        bind $optionFrame.cb <<ComboboxSelected>> [list [namespace current]::::ListboxEvent %W cv_Components [format "%s::%s(%s)" project $_array $_name] select]
                        bind $optionFrame.cb <ButtonPress>        [list [namespace current]::::ListboxEvent %W cv_Components [format "%s::%s(%s)" project $_array $_name] update]
                        
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
                # http://www.tek-tips.com/viewthread.cfm?qid=822756&page=42
                # 2010.10.15
            variable compFile
            #puts "ListboxEvent:  $w / [$w get]"
              # puts "ListboxEvent:  $targetCanvas"
            set compFile [$w get]
                puts ""
                puts "   -------------------------------"
                puts "    ListboxEvent"
                puts "       compFile:       $compFile"
                puts "       targetVar:      $targetVar"
                puts "       targetCanvas:   $targetCanvas"
                puts "       mode:           $mode"
            catch {[namespace current]::::updateCanvas $targetCanvas}
            if {$mode == {select}} {
                set key [lindex [split $targetVar ::] 2]
                rattleCAD::control::setValue $key $compFile force
            }
              # puts "    ListboxEvent ... done"
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

            switch -glob $compFile {
                etc:*  {  set compFile  [file join $::APPL_Config(CONFIG_Dir) components [lindex [split $compFile {:}] 1] ] }
                user:* {  set compFile  [file join $::APPL_Config(USER_Dir)   components [lindex [split $compFile {:}] 1] ] }
                default {}
            }
                puts "       compFile:       $compFile"

            if {$compFile != {}} {
                switch -regexp -- $targetCanvas {
                    cv_frameParts {
                                # puts "            ... $frameCanvas"
                                $frameCanvas clean_StageContent
                                set __my_Component__        [ $frameCanvas readSVG $compFile {0 0} 0  __Decoration__ ]
                                $frameCanvas fit2Stage $__my_Component__
                                $frameCanvas refitStage
                            }
                    cv_Components {
                                # puts "            ... $compCanvas"
                                $compCanvas clean_StageContent
                                set __my_Component__        [ $compCanvas readSVG $compFile {0 0} 0  __Decoration__ ]
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
            set root_w     [winfo width $main]
            set root_x    [lindex $root_xy 1]
            set root_y    [lindex $root_xy 2]

            set update no
            set update no

            if {$root_x != [lindex $cfg_Position 0]} {set update yes}
            if {$root_y != [lindex $cfg_Position 1]} {set update yes}
            if {$root_w != [lindex $cfg_Position 2]} {set update resize}

            switch $update {
                yes {
                        set dx [lindex $cfg_Position 3]
                        set dy [lindex $cfg_Position 4]
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
       #  create config_line
       #
    proc init_configValues__ {} {

            variable componentList
            variable projectDOM
            
            proc recurseInsert { node parent} {
                    # puts "    ... recurseInsert .. [$node toXPath]"
                variable componentList

                set name [$node nodeName]
                    # puts "\n    ... recurseInsert .. name: $name"
                switch $name {
                    "Project" -
                    "#text" -
                    "#comment" -
                    "cdata" {}
                    default {
                            # puts "[Tree:newItem .f.w [$node toXPath] -image idir]"
                            # puts "    ... recurseInsert .. [$node toXPath]"
                            foreach childNode [$node childNodes] {
                                set name [$childNode nodeName]
                                switch $name {
                                    "#text" {       # puts "    ... recurseInsert .. [$node toXPath]"
                                                set value       [$childNode asText]
                                                set xPath       [$node toXPath]
                                                set labelString [string map "{/} { / }" $xPath ]
                                                set xPathString [string map "{/root/} {}" $xPath ]
                                                    # puts "   ... $node "
                                                    # puts "     ... $value "
                                                    # puts "     $xPathString  $value"
                                                if {[llength $value] == 1} {
                                                    if {[llength [split $value ',']] == 1} {
                                                        set [namespace current]::configValue($xPathString) [ update_Value $xPathString $value format]
                                                            # set [namespace current]::configValue($xPathString) [ bikeGeometry::set_Value $xPathString $value format]
                                                    }
                                                }
                                                if {[file tail $xPath] == {File}} {
                                                        # puts "   [file tail $xPath]   $xPath"
                                                        # puts "        ... [llength $componentList]"
                                                    lappend componentList $xPathString
                                                        # puts "        ... [llength $componentList]"
                                                        # puts "                $componentList"
                                                }


                                            }

                                    default { recurseInsert $childNode $node }
                                }
                            }
                    }
                }
            }
			set projectDOM  $rattleCAD::control::currentDOM
            recurseInsert   $projectDOM  {/}

            return
    }


    #-------------------------------------------------------------------------
       #  binding on config_line
       #
    proc change_ValueEdit {textVar scale direction} {
            
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
    proc create_configEdit_title {w title _arrayName scale {color {}}} {
            set cDial [create_configEdit $w $_arrayName $scale $color]
            $cDial.lb   configure -text "   $title"
    }
    #-------------------------------------------------------------------------
       #  create config_line
       #
    proc create_configEdit {w _arrayName scale {color {}}} {

			variable Personal     	
			variable Custom      	
			variable Component     	
			variable Result       	
			variable Lugs         	
			variable FrameTubes 

			  # puts "  <D>  \$FrameTubes(HeadTube/Length):   $FrameTubes(HeadTube/Length)"

			variable    rdials_list
              # variable    configValue
            set _array [lindex [split $_arrayName (] 0]
            set _name  [lindex [split $_arrayName ()] 1]


            set xPath       [format "%s/%s" $_array $_name]
            # eval set configValue($xPath)    [format "$%s(%s)" $_array $_name]
			puts "   -> [format "$%s(%s)" $_array $_name]     <--- $xPath  <- $_array $_name "
              # eval set configValue($xPath)    [format "$%s::%s(%s)" project $_array $_name]
            set labelString $_name


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
			set     textvariable [format "%s::%s(%s)"  [namespace current] $_array $_name]
			
            label   $cfgFrame.sp    -text ""      \
                            -bd 1
            label   $cfgFrame.lb    -text "   $labelString "      \
                            -width 30  \
                            -bd 1  -anchor w

            entry   $cfgFrame.cfg    \
                            -textvariable $textvariable \
                            -width 10  \
                            -bd 1  -justify right -bg white
                            # e.g.: project::Result(Length/TopTube/VirtualLength)
							# -textvariable [format "project::%s(%s)"  $_array $_name]
            puts "     create_configEdit:  \$textvariable $textvariable"                  


            if {$color != {}} {
                $cfgFrame.lb  configure -fg $color
                $cfgFrame.cfg configure -fg $color
            }


            lappend rdials_list [expr [llength $rdials_list] + 1]

            bind $cfgFrame.cfg <Key>        [list [namespace current]::change_ValueEdit $textvariable $scale %K]
            bind $cfgFrame.cfg <Enter>      [list [namespace current]::enterEntry  $cfgFrame.cfg]
            bind $cfgFrame.cfg <Leave>      [list [namespace current]::leaveEntry  $cfgFrame.cfg]
            bind $cfgFrame.cfg <Return>     [list [namespace current]::leaveEntry  $cfgFrame.cfg]

            bind $cfgFrame.cfg <Double-1>   [list [namespace current]::selectEntry $cfgFrame.cfg]  ;#

            bind $cfgFrame.cfg <MouseWheel> [list [namespace current]::bind_MouseWheel $cfgFrame.cfg $scale %D]  ;# move up/down
            bind $cfgFrame.cfg <Key-Up>     [list [namespace current]::bind_MouseWheel $cfgFrame.cfg $scale  1]
            bind $cfgFrame.cfg <Key-Down>   [list [namespace current]::bind_MouseWheel $cfgFrame.cfg $scale -1]
                # bind $cfgFrame.cfg <Key-+>    [list [namespace current]::bind_MouseWheel $myEntry $scale  1]
                # bind $cfgFrame.cfg <Key-->    [list [namespace current]::bind_MouseWheel $myEntry $scale -1]


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
    proc selectEntry {entry} {
            # puts "   ... selectEntry"
			
            return
    }
    proc enterEntry {entry} {
            
			variable Personal     	
			variable Custom      	
			variable Component     	
			variable Result       	
			variable Lugs         	
			variable FrameTubes

			set entryVar [$entry cget -text]
            eval set currentValue     [expr 1.0 * \$$entryVar]
            set value [format "%.3f" $currentValue]
            # set [namespace current]::configValue(entry) $value

            return
    }
    proc leaveEntry {entry} {
    
			variable Personal     	
			variable Custom      	
			variable Component     	
			variable Result       	
			variable Lugs         	
			variable FrameTubes 
			
			set targetVar   [$entry cget -textvariable]
	    puts "   -> $targetVar"
            set _array      [lindex [split $targetVar (:] 2]
            set _name       [lindex [split $targetVar ()] 1]

            set entryVar [$entry cget -text]
            eval set newValue   \$$entryVar
            set newValue     [expr 1.0 * [string map {, .} $newValue]]

            rattleCAD::cv_custom::updateView [rattleCAD::gui::current_canvasCAD]

        puts "  <D> return"
		return
		
			# eval set oldValue    $[namespace current]::configValue(entry)
                    # puts "     \$oldValue $oldValue"
                    # puts "     \$newValue $newValue"
                    # puts "[$entry cget -text]"

            if {$newValue == $oldValue} {
                puts "\n         ... compare Value $newValue == $oldValue "
                return
            }

            puts "\n         ... compare Value $newValue <> $oldValue "
            puts "     =================="
            puts "         leaveEntry"
            puts "             entry        $entry"
            puts "             targetVar    $targetVar"

            if {$_array eq {Result}} {
                eval set $targetVar $oldValue
                bikeGeometry::set_resultParameter $_array $_name $newValue
                rattleCAD::cv_custom::updateView [rattleCAD::gui::current_canvasCAD]
                return
            }

            set key [lindex [split $targetVar :] 2]
                # puts "  <I> \$key $key"
                # puts "  <I> update_Value $key $newValue"
            update_Value $key $newValue
                # bikeGeometry::set_Value $key $newValue
                # eval set $targetVar $newValue

            rattleCAD::cv_custom::updateView [rattleCAD::gui::current_canvasCAD]

            return
     }

    proc rem_callback_cDial {{entryVar {}}  entry  {value {0}} {drag_Event {}} } {
                # puts "\n entryVar:    $entryVar"
                # puts "\n target_Var:  $target_Var"
                # puts "\n value:       $value"
                # puts "\n drag_Event:  $drag_Event"

            set value [format "%.3f" $value]
                # puts "\n value:       $value"
            if {$entryVar ne ""} {
                eval set $entryVar      $value;  # reformat value
            }
            if {$drag_Event == {release}} {
                    # -- exception for changing Result Values
                    #       e.g.: targetVar     [rattleCAD::control::getValue Result/Length/TopTube/VirtualLength]
                set targetVar   [$entry cget -textvariable]
                set _array      [lindex [split $targetVar (:] 2]
                set _name       [lindex [split $targetVar ()] 1]
                if {$_array eq {Result}} {
                    bikeGeometry::set_resultParameter $_array $_name $value
                } else {
                    eval set $targetVar     $value
                }
            }
     }


    #-------------------------------------------------------------------------
       #  create config_line
       #
    proc create_config_cBox {w _arrayName contentList} {

            variable    cboxList
            # variable    configValue
            set _array [lindex [split $_arrayName (] 0]
            set _name [lindex [split $_arrayName ()] 1]


            set xPath       [format "%s/%s" $_array $_name]
            #eval set configValue($xPath)    [format "$%s::%s(%s)" project $_array $_name]
            set labelString $_name

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
			set     textvariable [format "%s::%s(%s)"  [namespace current] $_array $_name]
			
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

                bind $cfgFrame.cb <<ComboboxSelected>>     [list [namespace current]::check_Value %W $xPath [format "%s::%s(%s)" project $_array $_name]]

            pack      $cfgFrame.lb  -side left
            pack      $cfgFrame.cb  -side right  -fill x
    }


    proc tubing_checkAngles {} {
            set rattleCAD::gui::checkAngles {on}
            rattleCAD::gui::select_canvasCAD   cv_Custom10
            rattleCAD::cv_custom::updateView   [rattleCAD::gui::current_canvasCAD]
    }


    proc check_Value { w xPath targetVar} {

            #variable configValue
            # variable oldValue
        #puts "  <D> return"
		#return
    
             switch $xPath {
                    {Component/Wheel/Rear/RimDiameter} -
                    {Component/Wheel/Front/RimDiameter} {
                            if {[string range $configValue($xPath) 0 3] == "----"} {
                                    # puts "   ... change value"
                                # set configValue($xPath) $oldValue
                            } else {
                                    # puts "   ... $configValue($xPath)"
                                    # puts "      >[split $configValue($xPath) ;]<"
                                    # puts "      >[lindex [split $configValue($xPath) ;] 0]<"
                                set value [string trim [lindex [split $configValue($xPath) ;] 0]]
                                set value [format "%.3f" $value]
                                set configValue($xPath)  $value
                                     #puts "   ... $configValue($xPath)"
                                     puts "   ... $targetVar"
                                set key [lindex [split $targetVar :] 2]
                                     puts "   ... $key"
                                rattleCAD::control::setValue $key $value
                            }
                        }
					default {
					        puts " ... check_Value: $xpath"
					    }
            }
    }
    #-------------------------------------------------------------------------
       #  update Config
       #
    proc registerUpdate__ {{entryVar ""}  {value {0}} } {

                    puts "\n"
                    puts "  -------------------------------------------"
                    puts "   ... entryVar $entryVar"
                    puts "   ... value    $value"

            if {$value == 0} {
                set textVar     $entryVar
                # puts "    textVar     $textVar"
                eval set value      [format "%s" $$textVar]
                # puts "    value   $value"
            }

            if {$entryVar ne ""} {
                  # reformat value
                set $entryVar [update_Value $key $newValue format]
                  # puts " -> $rattleCAD::control::model_Update"
            }

     }


    #-------------------------------------------------------------------------
       #  update_Rendering
       #
    proc update_Rendering {} {

        puts "  <D> return"
		return
		
		variable componentList
        variable configValue

        foreach xPath $componentList {
             update_Value $xPath $configValue($xPath)
        }

        foreach xPath { Rendering/Fork
                        Rendering/Brake/Front
                        Rendering/Brake/Rear
                        Rendering/BottleCage/SeatTube
                        Rendering/BottleCage/DownTube
                        Rendering/BottleCage/DownTube_Lower
        } {
            update_Value $xPath $configValue($xPath)
        }

        set cv          [ $rattleCAD::gui::noteBook_top select ]
        set varName     [ rattleCAD::gui::notebook_getVarName $cv ]
        if {[string range $varName 0 1] == {::}} { set varName [string range $varName 2 end] }

        bikeGeometry::updateConfig       $varName   rattleCAD::cv_custom::updateView    _update_
    }



    #-------------------------------------------------------------------------
        #  this is THE SETTER for the bikeGeometry library
        #    
    proc update_Value {key newValue {mode {update}}} {
            # puts ""
            # puts "         $rattleCAD::control::model_Update"
			
        set updatedValue [rattleCAD::control::setValue $key $newValue $mode]        
		
            # puts "         $rattleCAD::control::model_Update"
            # puts "       -----------------------------------"
            # puts "         \$key:           $key"
            # puts "         \$newValue:      $newValue"
            # puts "         \$mode:          $mode"
            # puts "         \$updateValue:   $updatedValue"
        # puts ""
        return $updatedValue
    }


}
