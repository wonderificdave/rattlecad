 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_frame_geometryUpdate.tcl
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
 #    namespace:  rattleCAD::frame_geometry
 # ---------------------------------------------------------------------------
 #
 #

 
     #-------------------------------------------------------------------------
        #  store createEdit-widgets position
    variable  _drag
    array set _drag {}
 
     #-------------------------------------------------------------------------
        #  create ProjectEdit Widget
        # proc createEdit { x y cv_Name updateCommand _arrayNameList {title {Edit:}}}
    proc frame_geometry::createEdit { x y cv_Name _arrayNameList {title {Edit:}}} {
            variable _update
            variable _updateValue

                puts ""
                puts "   -------------------------------"
                puts "    createEdit"
                puts "       x / y:           $x / $y"
                puts "       cv_Name:         $cv_Name"
                puts "       title:           $title"
                if {[llength $_arrayNameList] > 1} {
                    puts "       _arrayNameList:"
                    foreach entry $_arrayNameList {
                        puts "                        $entry"
                    }
                } else {
                    puts "       _arrayNameList:  $_arrayNameList"
                }
                puts ""

            project::remove_tracing

            # --- local procedures ---
                proc bind_MouseWheel {textVar value} {
                            set currentValue [set ::$textVar]
                            set updateValue 1.0
                            if {$currentValue < 20} { set updateValue 0.1 }
                            if {$value > 0} {
                                set scale 1.0
                            } else {
                                set scale -1.0
                            }
                            set newValue [expr {$currentValue + $scale * $updateValue}]
                            set ::$textVar [format "%.3f" $newValue]
                 }

                proc get_listBoxContent {type {key {}}} {
                        set listBoxContent {}
                        switch -exact $type {
                                {SELECT_File} {             set listBoxContent [lib_file::get_componentAlternatives  $key] }
                                {SELECT_Rim} {              set listBoxContent $::APPL_Env(list_Rims) }
                                {SELECT_ForkType} {         set listBoxContent $::APPL_Env(list_ForkTypes) }
                                {SELECT_DropOutDirection} { set listBoxContent $::APPL_Env(list_DropOutDirections) }
                                {SELECT_BrakeType} {        set listBoxContent $::APPL_Env(list_BrakeTypes) }
                                {SELECT_BottleCage} {       set listBoxContent $::APPL_Env(list_BottleCage) }
                                {SELECT_Binary_OnOff} {     set listBoxContent $::APPL_Env(list_Binary_OnOff) }
                        }
                        return $listBoxContent
                } 

                proc create_ValueEdit {cv cv_Name cvEdit cvContentFrame index labelText key} {

                        eval set currentValue $[namespace current]::_updateValue($key)
                        #
                        # --- create cvLabel, cvEntry ---
                            set    cvLabel [label  $cvContentFrame.label_${index} -text "${labelText} : "]
                                # set cvEntry [entry  $cvContentFrame.value_${index} -textvariable $textVar  -justify right  -relief sunken -bd 1  -width 10]
                            set cvEntry [spinbox $cvContentFrame.value_${index} -textvariable [namespace current]::_updateValue($key) -justify right -relief sunken -width 10 -bd 1]
                            $cvEntry configure -command \
                                "[namespace current]::change_ValueEdit [namespace current]::_updateValue($key) %d"
                            if {$index == {oneLine}} {
                                set    cvClose [button $cvContentFrame.close -image $lib_gui::iconArray(iconClose) -command "[namespace current]::closeEdit $cv $cvEdit"]
                                grid    $cvLabel $cvEntry $cvClose -sticky news
                                    # grid    $cvLabel $cvEntry $cvUpdate $cvClose -sticky news
                            } else {
                                grid    $cvLabel $cvEntry -sticky news
                                    # grid    $cvLabel $cvEntry $cvUpdate -sticky news
                            }
                            grid configure $cvLabel  -padx 3 -sticky nws
                            grid configure $cvEntry  -padx 2
                        #
                        # --- select entries content ---
                            if {$index == {oneLine}} {
                                    focus $cvEntry
                                    $cvEntry selection range 0 end
                            }
                        #
                        # --- define bindings ---
                            bind $cvLabel   <ButtonPress-1>         [list [namespace current]::dragStart        %X %Y]
                            bind $cvLabel   <B1-Motion>             [list [namespace current]::drag             %X %Y $cv $cvEdit]
                            bind $cvEntry   <MouseWheel>            [list [namespace current]::bind_MouseWheel  [namespace current]::_updateValue($key)  %D]
                            bind $cvEntry   <Return>                [list [namespace current]::updateConfig     $cv_Name $key $cvEntry]
                            bind $cvEntry   <Leave>                 [list [namespace current]::updateConfig     $cv_Name $key $cvEntry]
                            bind $cvEntry   <Double-ButtonPress-1>  [list [namespace current]::updateConfig     $cv_Name $key $cvEntry]
                }

                proc change_ValueEdit {textVar direction} {
                        #
                        # --- dynamic update value ---
                            set currentValue [set ::$textVar]
                            set updateValue 1.0
                            if {$currentValue < 20} { set updateValue 0.1 }
                                # puts "\n  -> $currentValue   -> $updateValue\n"
                        #
                        # --- update value of spinbox ---
                            if {$direction eq "up"} {\
                                set newValue [expr {$currentValue + $updateValue}]\
                            } else {\
                                set newValue [expr {$currentValue - $updateValue}]\
                            }
                            set ::$textVar [format "%.3f" $newValue]
                 }

                proc create_TextEdit {cv cv_Name cvEdit cvContentFrame index labelText key} {

                        eval set currentValue $[namespace current]::_updateValue($key)
                        #
                        # --- create cvLabel, cvEntry ---
                            set    cvLabel [label  $cvContentFrame.label_${index} -text "${labelText} : "]
                            set cvEntry [entry  $cvContentFrame.value_${index} -textvariable [namespace current]::_updateValue($key)  -justify right  -relief sunken -bd 1  -width 10]
                                # set cvEntry [spinbox $cvContentFrame.value_${index} -textvariable [namespace current]::_updateValue($key) -justify right -relief sunken -width 10 -bd 1]
                                # $cvEntry configure -command \
                                    "[namespace current]::change_ValueEdit [namespace current]::_updateValue($key) %d"
                            if {$index == {oneLine}} {
                                set    cvClose [button $cvContentFrame.close -image $lib_gui::iconArray(iconClose) -command "[namespace current]::closeEdit $cv $cvEdit"]
                                grid    $cvLabel $cvEntry $cvClose -sticky news
                                    # grid  $cvLabel $cvEntry $cvUpdate $cvClose -sticky news
                            } else {
                                grid    $cvLabel $cvEntry -sticky news
                                    # grid    $cvLabel $cvEntry $cvUpdate -sticky news
                            }
                            grid configure $cvLabel  -padx 3 -sticky nws
                            grid configure $cvEntry  -padx 2
                        #
                        # --- select entries content ---
                            if {$index == {oneLine}} {
                                    focus $cvEntry
                                    $cvEntry selection range 0 end
                            }
                        #
                        # --- define bindings ---
                            bind $cvLabel   <ButtonPress-1>         [list [namespace current]::dragStart       %X %Y]
                            bind $cvLabel   <B1-Motion>             [list [namespace current]::drag            %X %Y $cv $cvEdit]
                            #bind $cvEntry  <MouseWheel>            [list [namespace current]::bind_MouseWheel  [namespace current]::_updateValue($key)  %D]
                            bind $cvEntry   <Return>                [list [namespace current]::updateConfig    $cv_Name $key $cvEntry]
                            bind $cvEntry   <Leave>                 [list [namespace current]::updateConfig    $cv_Name $key $cvEntry]
                            bind $cvEntry   <Double-ButtonPress-1>  [list [namespace current]::updateConfig    $cv_Name $key $cvEntry]
                }

                proc create_ListEdit {type cv cv_Name cvEdit cvContentFrame index labelText key} {


                        eval set currentValue $[namespace current]::_updateValue($key)
                        #
                        # --- create listBox content ---
                            switch -exact $type {
                                    {SELECT_File} { puts "     createEdit::create_ListEdit::SELECT_File:"}
                                    default       { puts "     currentValue: $currentValue" }
                            }
                            set listBoxContent [ get_listBoxContent $type $key]
                            foreach entry $listBoxContent {
                                puts "         ... $entry"
                            }
                        #
                        # --- create cvLabel, cvEntry, Select ---
                            set cvFrame        [ frame      $cvContentFrame.frame_${index} ]
                            set     cvLabel    [ label      $cvFrame.label   -text "${labelText} : "]
                            set      cvCBox    [ ttk::combobox $cvFrame.cb \
                                                    -textvariable [namespace current]::_updateValue($key) \
                                                    -values $listBoxContent    \
                                                    -width  25 \
                                                    -height 10 \
                                                    -justify right ]

                                    set postCommand [list set [namespace current]::oldValue [namespace current]::_updateValue($key)]
                                    $cvCBox configure -postcommand [list eval set [namespace current]::oldValue \$[namespace current]::_updateValue($key)]

                            if {$index == {oneLine}} {
                                    set    cvClose [ button         $cvFrame.close   -image $lib_gui::iconArray(iconClose) -command [list [namespace current]::closeEdit $cv $cvEdit]]
                                    grid    $cvLabel $cvCBox $cvClose   -sticky news
                                    grid    $cvFrame                    -sticky news    -padx 1
                            } else {
                                    grid    $cvLabel $cvCBox            -sticky news
                                    grid    configure $cvLabel          -sticky nws     -padx 2
                                    grid    columnconfigure     $cvFrame 1      -weight 1
                                    grid    $cvFrame                    -sticky news    -padx 1     -columnspan 3
                            }
                        #
                        # --- define bindings ---
                            bind $cvCBox    <<ComboboxSelected>>        [list [namespace current]::check_listBoxValue   %W $cv_Name $key]
                            bind $cvLabel   <ButtonPress-1>             [list [namespace current]::dragStart    %X %Y]
                            bind $cvLabel   <B1-Motion>                 [list [namespace current]::drag         %X %Y $cv $cvEdit]
                            #bind $cvLabel  <B1-Motion>                 [list [namespace current]::drag         %X %Y $cv __cvEdit__]
                }


            set x_offset 20
            set domProject $::APPL_Env(root_ProjectDOM)
            set cv      [ $cv_Name getNodeAttr Canvas path]
            if { [catch { set cvEdit [frame $cv.f_edit -bd 2 -relief raised] } errorID ] } {
                    closeEdit $cv $cv.f_edit
                    set cvEdit [frame $cv.f_edit -bd 2 -relief raised]
            }
            # --- create Window ---
            $cv_Name addtag __cvEdit__ withtag $cvEdit
            $cv create window [expr $x + $x_offset] $y  -window $cvEdit  -anchor w -tags $cvEdit
            $cv_Name addtag __cvEdit__ withtag $cvEdit

            # $cv create window [expr $x + $x_offset] $y  -window $cvEdit  -anchor w -tags __cvEdit__

            # --- create WindowFrames ---
            set cvTitleFrame    [frame $cvEdit.f_title -bg gray60  ]
                # set cvTitleFrame       [frame $cvEdit.f_title   -bd 1 -relief flat -bg gray60]
            set cvContentFrame       [frame $cvEdit.f_content -bd 1 -relief sunken]
                    pack $cvTitleFrame $cvContentFrame -side top
                    pack configure $cvTitleFrame      -fill x -padx 2 -pady 2
                    pack configure $cvContentFrame    -fill both

            # --- cvContentFrame ---
            if {[llength $_arrayNameList] == 1 } {
                    pack forget $cvTitleFrame
                    set updateMode  value
                    set _arrayName  [lindex $_arrayNameList 0]
                    set _array      [lindex [split $_arrayName (] 0]
                    set _name       [lindex [split $_arrayName ()] 1]
                    set xpath       [format "%s/%s" $_array $_name]
                    set index oneLine

                    switch -glob $xpath {
                            {file://*} {
                                    set updateMode SELECT_File
                                                                        set updateMode SELECT_File
                                    set _array      [string range $_array 7 end]
                                    eval set value  [format "$%s::%s(%s)" project $_array $_name]
                                    set labelText   [format "%s ( %s )" $_array [ string trim [ string map {{/} { / }} $_name] " " ] ]
                                    set key         [format "%s/%s" $_array $_name]
                                    set _updateValue($key) $value

                                        # --- create widgets per xpath list element ---
                                    create_ListEdit SELECT_File \
                                                $cv $cv_Name $cvEdit $cvContentFrame \
                                                $index $labelText $key
                                }
                            {list://*} {
                                    set _array      [string range $_array 7 end]
                                    set _nameInfo   [split $_name {@} ]
                                    set _name       [lindex $_nameInfo 0]
                                    set listName    [lindex $_nameInfo 1]
                                    
                                    eval set value  [format "$%s::%s(%s)" project $_array $_name]
                                    set labelText   [format "%s ( %s )" $_array [ string trim [ string map {{/} { / }} $_name] " " ] ]
                                    set key         [format "%s/%s" $_array $_name]
                                    set _updateValue($key) $value

                                    create_ListEdit $listName \
                                                $cv $cv_Name $cvEdit $cvContentFrame \
                                                $index $labelText $key
                                }
                            {text://*} {
                                        # puts " <D> $_array"
                                    set _array      [string range $_array 7 end]
                                        # puts " <D> $_array"
                                    eval set value  [format "$%s::%s(%s)" project $_array $_name]
                                        # puts " <D> $value"
                                    set _updateValue($xpath) $value
                                    set labelText   [format "%s ( %s )" $_array [ string trim [ string map {{/} { / }} $_name] " " ] ]
                                    set key [format "%s/%s" $_array $_name]
                                    set _updateValue($key) $value

                                        # --- create widgets per xpath list element ---
                                    create_TextEdit $cv $cv_Name $cvEdit $cvContentFrame \
                                                        $index $labelText $key
                                }
                            default {
                                    eval set value     [format "$%s::%s(%s)" project $_array $_name]
                                    set _updateValue($xpath) $value
                                    set labelText   [format "%s ( %s )" $_array [ string trim [ string map {{/} { / }} $_name] " " ] ]
                                    set key [format "%s/%s" $_array $_name]
                                    set _updateValue($key) $value

                                        # --- create widgets per xpath list element ---
                                    create_ValueEdit $cv $cv_Name $cvEdit $cvContentFrame \
                                                        $index $labelText $key
                                }

                    }
            } else {
                    #
                # --- title definition ---
                    set cvTitle            [label  $cvTitleFrame.label -text "${title}"  -bg gray60  -fg white -font "Helvetica 8 bold" -justify left]
                        pack $cvTitle -side left
                    set    cvClose            [button $cvTitleFrame.close -image $lib_gui::iconArray(iconClose) -command "[namespace current]::closeEdit $cv $cvEdit"]
                        pack $cvClose -side right -pady 2
                    #
                # --- parameter to edit ---
                    set updateMode value
                    set index 0
                    foreach _arrayName  $_arrayNameList {
                        set _array      [lindex [split $_arrayName (] 0]
                        set _name       [lindex [split $_arrayName ()] 1]
                        set xpath       [format "%s/%s" $_array $_name]
                        set index [expr $index +1]

                        switch -glob $xpath {
                            {file://*} {
                                        # puts "   ... \$xpath $xpath"
                                    set _array      [string range $_array 7 end]
                                        # puts "   ... \$xpath $xpath"
                                    eval set value  [format "$%s::%s(%s)" project $_array $_name]
                                        # replaced by 3.2.70;# set value    [ [ $domProject selectNodes /root/$xpath  ]    asText ]
                                        # set xpath    [string range $xpath 7 end]
                                        # set _updateValue($xpath) $value
                                        # puts "   -> \$_updateValue($xpath): $_updateValue($xpath)"
                                    set labelText   [format "%s ( %s )" $_array [ string trim [ string map {{/} { / }} $_name] " " ] ]
                                        # replaced by 3.2.70;# set labelText        [ string trim [ string map {{/} { / }} $xpath] " " ]
                                        #
                                    set key [format "%s/%s" $_array $_name]
                                    set _updateValue($key) $value

                                        # --- create widgets per xpath list element ---
                                    create_ListEdit SELECT_File \
                                                $cv $cv_Name $cvEdit $cvContentFrame \
                                                $index $labelText $key
                                }
                            {list://*} {
                                        # puts "   ... \$xpath $xpath"
                                    set _array      [string range $_array 7 end]
                                    set _nameInfo   [split $_name {@} ]
                                        # puts "   ... $_array $_nameInfo"
                                    set _name       [lindex $_nameInfo 0]
                                    set listName    [lindex $_nameInfo 1]

                                    eval set value  [format "$%s::%s(%s)" project $_array $_name]
                                        # replaced by 3.2.70;# set value    [ [ $domProject selectNodes /root/$xpath  ]    asText ]
                                        # set _updateValue($xpath) $value
                                        # puts "   -> \$_updateValue($xpath): $_updateValue($xpath)"
                                    set labelText   [format "%s ( %s )" $_array [ string trim [ string map {{/} { / }} $_name] " " ] ]
                                        # replaced by 3.2.70;# set labelText        [ string trim [ string map {{/} { / }} $xpath] " " ]
                                        #
                                    set key   [format "%s/%s" $_array $_name]
                                    set _updateValue($key) $value

                                        # --- create widgets per xpath list element ---
                                    create_ListEdit $listName \
                                                $cv $cv_Name $cvEdit $cvContentFrame \
                                                $index $labelText $key
                                }
                            {text://*} {
                                        # puts "   ... \$xpath $xpath"
                                    set _array      [string range $_array 7 end]
                                        # puts "  <D> ... $_array $_name"
                                    eval set value [format "$%s::%s(%s)" project $_array $_name]
                                    set _updateValue($xpath) $value
                                        # puts "   -> \$_updateValue($xpath): $_updateValue($xpath)"
                                    set labelText       [format "%s ( %s )" $_array [ string trim [ string map {{/} { / }} $_name] " " ] ]
                                        # removed by 3.2.70;# set labelText        [ string trim [ string map {{/} { / }} $xpath] " " ]
                                        #
                                    set key    [format "%s/%s" $_array $_name]
                                    set _updateValue($key) $value

                                        # --- select entries content ---
                                    create_TextEdit $cv $cv_Name $cvEdit $cvContentFrame \
                                                        $index $labelText $key
                                }
                            default {
                                        # puts "   ... \$xpath $xpath"
                                    eval set value [format "$%s::%s(%s)" project $_array $_name]
                                    set _updateValue($xpath) $value
                                        # puts "   -> \$_updateValue($xpath): $_updateValue($xpath)"
                                    set labelText       [format "%s ( %s )" $_array [ string trim [ string map {{/} { / }} $_name] " " ] ]
                                        # removed by 3.2.70;# set labelText     [ string trim [ string map {{/} { / }} $xpath] " " ]
                                        #
                                    set key    [format "%s/%s" $_array $_name]
                                    set _updateValue($key) $value

                                        # --- select entries content ---
                                    create_ValueEdit $cv $cv_Name $cvEdit $cvContentFrame \
                                                        $index $labelText $key
                                }
                        }
                    }
                    bind $cvTitleFrame     <ButtonPress-1>     [list [namespace current]::dragStart     %X %Y]
                    bind $cvTitleFrame    <B1-Motion>         [list [namespace current]::drag         %X %Y $cv $cvEdit]
                    bind $cvTitle        <ButtonPress-1>     [list [namespace current]::dragStart     %X %Y]
                    bind $cvTitle        <B1-Motion>         [list [namespace current]::drag         %X %Y $cv $cvEdit]
            }

            # --- reposition if out of canvas border ---
            set cv_width  [ winfo width  $cv ]
            set cv_height [ winfo height $cv ]
            update
            set id_bbox   [ $cv bbox $cvEdit ]
                # puts "   -> bbox $id_bbox"
            foreach {dx dy} {0 0} break
            if {[lindex $id_bbox 2] > [expr $cv_width  -4]} { set dx [expr $cv_width  - [lindex $id_bbox 2] -4] }
            if {[lindex $id_bbox 3] > [expr $cv_height -4]} { set dy [expr $cv_height - [lindex $id_bbox 3] -4] }
            $cv move $cvEdit $dx $dy
              # puts "  -> reposition $dx $dy"
    }
     #-------------------------------------------------------------------------
        #  close ProjectEdit Widget
    proc frame_geometry::closeEdit {cv cvEdit} {
            $cv delete $cvEdit
            destroy $cvEdit
            catch [ destroy .__select_box ]
    }
     #-------------------------------------------------------------------------
        #  binding: dragStart
    proc frame_geometry::dragStart {x y} {
            variable _drag
            set [namespace current]::_drag(lastx) $x
            set [namespace current]::_drag(lasty) $y
            puts "$x $y"
    }
     #-------------------------------------------------------------------------
        #  binding: drag
    proc frame_geometry::drag {x y cv id} {
            variable _drag
            set dx [expr {$x - $_drag(lastx)}]
            set dy [expr {$y - $_drag(lasty)}]
            set cv_width  [ winfo width  $cv ]
            set cv_height [ winfo height $cv ]
            set id_bbox   [ $cv bbox $id ]
            if {[lindex $id_bbox 0] < 4} {set dx  1}
            if {[lindex $id_bbox 1] < 4} {set dy  1}
            if {[lindex $id_bbox 2] > [expr $cv_width  -4]} {set dx -1}
            if {[lindex $id_bbox 3] > [expr $cv_height -4]} {set dy -1}

            $cv move $id $dx $dy
            set _drag(lastx) $x
            set _drag(lasty) $y
    }
     #-------------------------------------------------------------------------
        #  create createSelectBox

    proc frame_geometry::bind_parent_move {toplevel_widget parent} {
            if {![winfo exists $toplevel_widget]} return
            set toplevel_x    [winfo rootx $parent]
            set toplevel_y    [expr [winfo rooty $parent]+ [winfo reqheight $parent]]
            wm  geometry      $toplevel_widget +$toplevel_x+$toplevel_y
            wm  deiconify     $toplevel_widget
    }    
     #-------------------------------------------------------------------------
        #  update Project
    proc frame_geometry::updateConfig {cv_Name xpath {cvEntry {}}} {

            variable _updateValue

            set _array  [lindex [split $xpath /] 0]
            set _name   [string range $xpath [string length $_array/] end]


            # --- handele xpath values ---
            switch -glob $xpath {
                {_update_} {}
                default {
                        set oldValue [project::getValue [format "%s(%s)" $_array $_name] value]
                        if {$_updateValue($xpath) == $oldValue} {
                            return
                        }
                            # puts "003  -> update"
                            # puts "001  ->$oldValue"
                            # puts "001  ->$_updateValue($xpath)"

                        puts ""
                        puts "   -------------------------------"
                        puts "    updateConfig"
                        puts "       updateConfig:    $_updateValue($xpath)"
                        project::add_tracing
                        set_projectValue $xpath $_updateValue($xpath)
                        project::remove_tracing
                    }
            }

            #
            # --- finaly update
                # frame_geometry::set_base_Parameters ;#$domProject
            update
            catch {focus $cvEntry}
            catch {$cvEntry selection range 0 end}
    }
     #-------------------------------------------------------------------------
        #  check comments in listbox
    proc frame_geometry::check_listBoxValue { w cv_Name xPath args} {

            variable _updateValue
            variable oldValue

            puts "  .. check_listBoxValue $xPath $args"

            switch $xPath {
                    {Component/Wheel/Rear/RimDiameter} -
                    {Component/Wheel/Front/RimDiameter} {
                                # -- exception for selection of Combobox
                                    # list is splitted by: "----"
                            if {[string range $_updateValue($xPath) 0 3] == "----"} {
                                    puts "   ... reset value .. $oldValue"
                                set _updateValue($xPath) $oldValue
                            } else {
                                    # puts "   ... $_updateValue($xPath)"
                                    # puts "      >[split $_updateValue($xPath) ;]<"
                                    # puts "      >[lindex [split $_updateValue($xPath) ;] 0]<"
                                set value [string trim [lindex [split $_updateValue($xPath) ;] 0]]
                                set value [format "%.3f" $value]
                                set _updateValue($xPath) $value
                                    # puts "   ... $_updateValue($xPath)"

                                [namespace current]::updateConfig $cv_Name $xPath
                            }
                        }
                    default {
                                [namespace current]::updateConfig $cv_Name $xPath
                        }
            }
    }
     #-------------------------------------------------------------------------
        #  sets and format Value
    proc frame_geometry::set_projectValue {xpath value {mode {update}}} {

            # xpath: e.g.:Custom/BottomBracket/Depth
            variable         _updateValue

            puts ""
            puts "   -------------------------------"
            puts "    set_projectValue"
            puts "       xpath:           $xpath"
            puts "       value:           $value"
            puts "       mode:            $mode"

            set _array     [lindex [split $xpath /] 0]
            set _name     [string range $xpath [string length $_array/] end]
                # puts "     ... $_array  $_name"


            # --- handle xpath values ---
                    # puts "  ... mode: $mode"
            if {$mode == {update}} {
                    # puts "  ... set_projectValue: $xpath"
                switch -glob $_array {
                    {Result} {
                            set newValue [ string map {, .} $value]
                                # puts "\n  ... set_projectValue: ... Result/..."
                            set_resulting_Parameters $_array $_name $newValue
                            return
                        }
                    default {}
                }
            }


                # --- exceptions without any format-checks
                    # on int list values like defined
                    # puts "<D> $xpath"
            switch $xpath {
                    {Component/Wheel/Rear/RimDiameter} -
                    {Component/Wheel/Front/RimDiameter} -
                    {Lugs/RearDropOut/Direction} {
                                set newValue    $value
                                project::setValue [format "%s(%s)" $_array $_name] value $newValue
                                return $newValue
                            }

                    {Component/CrankSet/ChainRings} -
                    {Component/Wheel/Rear/FirstSprocket} {
                                set newValue [ string map {, .} $value]
                                    # puts " <D> $newValue"
                                if {$mode == {update}} {
                                    project::setValue [format "%s(%s)" $_array $_name] value $newValue
                                }
                                return $newValue
                            }                         

                    default { }
            }




                # --- set new Value
            set newValue [ string map {, .} $value]
                # --- check Value --- ";" ... like in APPL_RimList
            set newValue [lindex [split $newValue ;] 0]
                # --- check Value --- update
            if {$mode == {update}} {
                set _updateValue($xpath) $newValue
            }


                # --- update or return on errorID
            set checkValue {mathValue}
            if {[file dirname $xpath] == {Rendering}} {
                            # puts "               ... [file dirname $xpath] "
                        set checkValue {}
            }
            if {[file tail $xpath]    == {File}     } {
                            # puts "               ... [file tail    $xpath] "
                        set checkValue {}
            }

            if {[lindex [split $xpath /] 0] == {Rendering}} {
                        set checkValue {}
                        puts "   ... Rendering: $xpath "
                        puts "        ... $value [file tail $xpath]"
            }

                 puts "               ... checkValue: $checkValue "

                # --- update or return on errorID
            if {$checkValue == {mathValue} } {
                if { [catch { set newValue [expr 1.0 * $newValue] } errorID] } {
                    puts "\n$errorID\n"
                    return
                } else {
                    set newValue [format "%.3f" $newValue]
                }
            }

            if {$mode == {update}} {
                project::setValue [format "%s(%s)" $_array $_name] value $newValue
            }

            return $newValue

    }
     #-------------------------------------------------------------------------
        #  handle modification on /root/Result/... values
    proc frame_geometry::set_resulting_Parameters {_array _name value} {

            variable         _updateValue

            puts ""
            puts "   -------------------------------"
            puts "    set_resulting_Parameters"
            puts "       _array:          $_array"
            puts "       _name:           $_name"
            puts "       value:           $value"

                variable BottomBracket
                variable HandleBar
                variable Saddle
                variable SeatPost
                variable SeatTube
                variable FrontWheel
                variable Fork
                variable Stem


            set xpath "$_array/$_name"
            puts "       xpath:           $xpath"

            switch -glob $_name {

                {Length/BottomBracket/Height}    {
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            set oldValue                $project::Result(Length/BottomBracket/Height)
                            # 3.2.76 set oldValue       $project::Temporary(BottomBracket/Height)
                            set newValue                [set_projectValue $xpath  $value format]
                            set _updateValue($xpath)    $newValue
                            set delta       [expr $newValue - $oldValue]
                                    # puts "   ... oldValue:   $oldValue"
                                    # puts "   ... newValue:   $newValue"
                                    # puts "   ...... delta:   $delta"

                                # --- update value
                                #
                            set xpath                   Custom/BottomBracket/Depth
                            set oldValue                $project::Custom(BottomBracket/Depth)
                            set newValue                [ expr $oldValue - $delta ]
                            set_projectValue $xpath     $newValue
                            return
                        }

                {Angle/HeadTube/TopTube} {
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            set HeadTopTube_Angle       [ set_projectValue $xpath  $value format]
                            set _updateValue($xpath)    $HeadTopTube_Angle
                                # puts "          \$HeadTopTube_Angle  = $HeadTopTube_Angle"

                                # --- update value
                                #
                            set HeadTube_Angle          $project::Custom(HeadTube/Angle)
                            set value                    [ expr $HeadTopTube_Angle - $HeadTube_Angle]
                            set xpath                    Custom/TopTube/Angle

                            set_projectValue $xpath     $value
                            return
                        }

                {Angle/SeatTube/Direction} {
                            # puts "\n"
                            # puts "  ... Angle/SeatTube/Direction comes here: $value"
                            # puts ""
                            set oldValue        $project::Result(Angle/SeatTube/Direction)
                            set SP_Setback      [project::getValue Component(SeatPost/Setback)   value]
                            set length_Setback  [expr $SP_Setback * sin([vectormath::rad $value])]
                            set height_Setback  [expr $SP_Setback * cos([vectormath::rad $value])]
                                # puts "    -> value $value"
                                # puts "    -> oldValue $oldValue"
                                # puts "    -> SP_Setback $SP_Setback"
                                # puts "    -> length_Setback $length_Setback"
                                # puts "    -> height_Setback $height_Setback"
                            set ST_height       [expr [project::getValue Personal(Saddle_Height)   value] - [project::getValue Component(Saddle/Height)   value] + $height_Setback]
                            set length_SeatTube [expr $ST_height / tan([vectormath::rad $value])]
                                # puts "    -> ST_height $ST_height"
                                # puts "    -> length_SeatTube $length_SeatTube"

                                # --- update value
                                #
                            set value [expr $length_Setback + $length_SeatTube]
                            set xpath                   Personal/Saddle_Distance
                            set_projectValue $xpath     $value
                            return
                         }

                {Length/SeatTube/VirtualLength} {
                            # puts "  -> Length/SeatTube/VirtualLength"
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"

                                # SeatTube Offset
                                #
                            set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                            set newValue                [set_projectValue $xpath  $value format]
                            set _updateValue($xpath)    $newValue
                            set delta                   [expr $newValue - $oldValue]

                            set offsetSeatTube          [vectormath::rotateLine {0 0} $delta [expr 180 - $project::Result(Angle/SeatTube/Direction)]]
                            set offsetSeatTube_x        [lindex $offsetSeatTube 0]
                                # puts "   -> $offsetSeatTube"

                                # HeadTube Offset - horizontal
                                #
                            set deltaHeadTube           [expr [lindex $offsetSeatTube 1] / sin($project::Custom(HeadTube/Angle) * $vectormath::CONST_PI / 180) ]
                            set offsetHeadTube_x        [expr [lindex $offsetSeatTube 1] / tan($project::Custom(HeadTube/Angle) * $vectormath::CONST_PI / 180) ]

                                # HeadTube Offset - horizontal
                                #
                            project::remove_tracing ; #because of setting two parameters at once
                            set xpath                   Personal/HandleBar_Distance
                            set newValue                [expr $HandleBar(Distance)    + $offsetHeadTube_x + $offsetSeatTube_x]
                            set_projectValue $xpath     $newValue

                                # HeadTube Offset - TopTube
                                #
                            set xpath                   Custom/TopTube/OffsetHT
                            set oldValue                $project::Custom(TopTube/OffsetHT)
                            set newValue                [expr $oldValue - $deltaHeadTube ]
                            set newValue                [set_projectValue $xpath  $newValue format]
                                #
                            project::add_tracing
                            set_projectValue $xpath      $newValue
                                #
                            return
                }

                {Length/HeadTube/ReachLength} {
                            set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                            set newValue                [set_projectValue $xpath  $value format]
                            set _updateValue($xpath)    $newValue
                            set delta                   [expr $newValue - $oldValue]

                            set xpath                   Personal/HandleBar_Distance
                            set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                            set newValue                [expr $HandleBar(Distance)    + $delta]
                            set_projectValue $xpath     $newValue
                            return
                }

                {Length/HeadTube/StackHeight} {
                            set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                            set newValue                [set_projectValue $xpath  $value format]
                            set _updateValue($xpath)    $newValue
                            set delta                   [expr $newValue - $oldValue]

                            set deltaHeadTube           [expr $delta / sin($project::Custom(HeadTube/Angle) * $vectormath::CONST_PI / 180) ]
                            set offsetHeadTube_x        [expr $delta / tan($project::Custom(HeadTube/Angle) * $vectormath::CONST_PI / 180) ]

                                # puts "==================="
                                # puts "    delta             $delta"
                                # puts "    deltaHeadTube     $deltaHeadTube"
                                # puts "    offsetHeadTube_x  $offsetHeadTube_x"

                                #
                            project::remove_tracing ; #because of setting two parameters at once
                                #
                            set xpath                    Personal/HandleBar_Height
                            set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                            set newValue                [expr $HandleBar(Height)    + $delta]
                            set_projectValue $xpath      $newValue
                                #
                            project::add_tracing
                                #
                            set xpath                   FrameTubes/HeadTube/Length
                            set oldValue                $project::FrameTubes(HeadTube/Length)
                            set newValue                [expr $project::FrameTubes(HeadTube/Length) + $deltaHeadTube ]
                            set_projectValue $xpath     $newValue
                                #
                            return
                }

                {Length/TopTube/VirtualLength}            -
                {Length/FrontWheel/horizontal} {
                            # puts "  -> Length/TopTube/VirtualLength"
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                            # set oldValue              [ [ $domProject selectNodes $xpath  ]    asText ]
                            set newValue                [set_projectValue $xpath  $value format]
                            set _updateValue($xpath)    $newValue
                            set delta                   [expr $newValue - $oldValue]

                                # --- set HandleBar(Distance)
                                #
                            set newValue                [ expr $HandleBar(Distance)    + $delta ]
                            set xpath                   Personal/HandleBar_Distance
                            set_projectValue $xpath     $newValue
                            return
                        }

                {Length/RearWheel/horizontal} {
                            # puts "  -> Length/TopTube/VirtualLength"
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            #set oldValue               [project::getValue [format "%s(%s)" $_array $_name] value]
                            # set oldValue              [ [ $domProject selectNodes $xpath  ]    asText ]
                            set newValue                [set_projectValue $xpath  $value format]
                            set _updateValue($xpath)    $newValue
                            #set delta                  [expr $newValue - $oldValue]
                            set bbDepth                 $project::Custom(BottomBracket/Depth)

                                # --- set HandleBar(Distance)
                                #
                            set newValue                [ expr { sqrt( $newValue * $newValue + $bbDepth * $bbDepth ) } ]
                            set xpath                   Custom/WheelPosition/Rear
                            set_projectValue $xpath     $newValue
                            return
                        }

                {Length/FrontWheel/diagonal}    {
                                # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                                # set oldValue              [ [ $domProject selectNodes $xpath  ]    asText ]
                            set newValue                [set_projectValue $xpath  $value format]
                            set _updateValue($xpath)    $newValue
                                # puts "                 <D> ... $oldValue $newValue"

                                # --- set HandleBar(Angle)
                                #
                            set vect_01     [ expr $Stem(Length) * cos($Stem(Angle) * $vectormath::CONST_PI / 180) ]
                            set vect_02     [ expr $vect_01 - $Fork(Rake) ]

                            set FrontWheel(Distance_X_tmp)  [ expr { sqrt( $newValue * $newValue - $FrontWheel(Distance_Y) * $FrontWheel(Distance_Y) ) } ]
                            set FrontWheel(Position_tmp)    [ list $FrontWheel(Distance_X_tmp) $FrontWheel(Distance_Y)]

                            set help_03   [ vectormath::cathetusPoint    $HandleBar(Position)    $FrontWheel(Position_tmp)    $vect_02  close ]
                            set vect_HT   [ vectormath::parallel      $help_03                  $FrontWheel(Position_tmp)    $Fork(Rake) ]
                                # puts "                 <D> ... $vect_HT"

                            set help_01  [ lindex $vect_HT 0]
                            set help_02  [ lindex $vect_HT 1]
                            set help_03  [list -200 [ lindex $help_02 1] ]

                            set newValue                [ vectormath::angle    $help_01 $help_02 $help_03 ]
                            set xpath                   Custom/HeadTube/Angle
                            set_projectValue $xpath     $newValue
                            return
                        }

                {Length/Saddle/Offset_HB}    {
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            set oldValue               [ project::getValue [format "%s(%s)" $_array $_name] value ]
                            set newValue               [ set_projectValue $xpath  $value format ]
                            set _updateValue($xpath)   $newValue

                            set delta                    [ expr $oldValue - $newValue ]
                                    # puts "          $newValue - $oldValue = $delta"

                                # --- set HandleBar(Distance)
                                #
                            set newValue                [ expr $HandleBar(Height)    + $delta ]
                            set xpath                   Personal/HandleBar_Height
                            set_projectValue $xpath     $newValue
                            return
                        }

                {Length/Saddle/Offset_BB_ST}    {
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            set newValue                [ set_projectValue $xpath  $value format ]
                            set height                  [ project::getValue [format "%s(%s)" Personal Saddle_Height] value ]
                            set angle                   [ vectormath::dirAngle {0 0} [list $newValue $height] ]

                            set_resulting_Parameters Result Angle/SeatTube/Direction $angle

                                # puts "   $newValue / $height -> $angle"
                            return
                        }

                {Length/Saddle/Offset_BB_Nose}    {
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            set oldValue                [ project::getValue [format "%s(%s)" $_array $_name] value ]
                            set newValue                [ set_projectValue $xpath  $value format ]
                            set delta                   [ expr -1.0 * ($newValue - $oldValue) ]

                                # --- set HandleBar(Distance)
                                #
                            set newValue                [ expr $project::Component(Saddle/LengthNose) + $delta ]
                            set xpath                   Component/Saddle/LengthNose
                            set_projectValue $xpath     $newValue
                            return
                        }




                default {
                            puts "\n"
                            puts "     WARNING!"
                            puts "\n"
                            puts "        ... set_resulting_Parameters:  "
                            puts "                 $xpath"
                            puts "            ... is not registered!"
                            puts "\n"
                            return
                        }
            }

    }
     #-------------------------------------------------------------------------
        #  trace/update Project
    proc frame_geometry::trace_Project {varname key operation} {
            if {$key != ""} {
                    set varname ${varname}($key)
                    }
            upvar $varname var
            # value is 889 (operation w)
            # value is 889 (operation r)
            puts "trace_Prototype: (operation: $operation) $varname is $var "
    }