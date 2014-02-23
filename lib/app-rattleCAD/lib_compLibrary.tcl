 ##+##########################################################################te
 #
 # package: rattleCAD   ->  lib_comp_library.tcl
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
 #  namespace:  rattleCAD::comp_library
 # ---------------------------------------------------------------------------
 #
 #

 namespace eval rattleCAD::comp_library {

    variable    compCanvas      {}
    variable    menueFrame      {}

    variable    compList_System {}
    variable    compList_Custom {}
    variable    tree_System     {}
    variable    tree_Custom     {}
    variable    list_Selection  {}
    variable    rdials_list     {}

    variable    compFile        {}

    variable    configValue
      array set configValue     {}


    #-------------------------------------------------------------------------
       #  create report widget
       #
    proc createLibrary {w} {
        variable compCanvas
        variable menueFrame

        variable    compList_System
        variable    compList_Custom
        variable    tree_System
        variable    tree_Custom
        variable    list_Selection
        

        pack [ frame $w.f -bg yellow] -fill both -expand yes
        set menueFrame  [ frame $w.f.f_menue    -relief flat -bd 1]
        set canvasFrame [ frame $w.f.f_canvas ]
        pack     $menueFrame \
                $canvasFrame\
            -fill both -side left
        pack configure $canvasFrame -expand yes


            # -- file Listbox
        ttk::labelframe    $menueFrame.lf  -text "FileList" -width 34
            pack $menueFrame.lf -expand no -fill x
        
        
            # -- file Structure Frame
        set f_struct     [ ttk::notebook $menueFrame.lf.str ]
            pack $f_struct      -expand no -fill both
            
            
            # -- file Structure Notebook
        set nb_struct    [ ttk::notebook $f_struct.nb ]
            pack $nb_struct     -expand no -fill both
        $nb_struct add [frame $nb_struct.system]     -text "... system"
        $nb_struct add [frame $nb_struct.custom]     -text "... custom"

        
            # -- System Components Structure --------------
            #
        set f_system    [ frame     $nb_struct.system.f ]
            pack     $f_system -side top  -expand no -fill none
        set tree_System \
        [ttk::treeview $f_system.tree \
                      -columns {fullpath type size} \
                      -displaycolumns {} \
                      -yscroll "$f_system.scb_try set" \
                      -height  8]
        ttk::scrollbar $f_system.scb_try \
                      -orient vertical   \
                      -command "$f_system.tree yview"
        $tree_System heading \#0 -text "System Components"
        
        grid $tree_System $f_system.scb_try    -sticky news
        

            # -- Custom Components Structure --------------
            #
        set f_custom    [ frame     $nb_struct.custom.f ]
            pack     $f_custom -side top  -expand no -fill none
        set tree_Custom \
        [ttk::treeview $f_custom.tree \
                        -columns {fullpath type size} \
                        -displaycolumns {} \
                        -yscroll "$f_custom.scb_try set" \
                        -height  8]
        ttk::scrollbar $f_custom.scb_try \
                        -orient vertical   \
                        -command "$f_custom.tree yview"
        $tree_Custom heading \#0 -text "Custom Components"
          
        grid $tree_Custom $f_custom.scb_try    -sticky news  
           
            
            # -- Selection --------------------------
            #
        set f_select    [ frame     $f_struct.sel ]
            pack     $f_select -side top  -expand no -fill none
            
        set list_Selection \
        [ttk::treeview $f_select.list \
                    -columns {filename type size} \
                    -displaycolumns {} \
                    -yscroll "$f_select.scb_lsy set" \
                    -height  9]
        ttk::scrollbar $f_select.scb_lsy \
                    -orient vertical   \
                    -command "$f_select.list yview"
        $list_Selection heading \#0 -text "File Name"

        grid $list_Selection    $f_select.scb_lsy    -sticky news

        
            # -- Button
            # -- ButtonFrame
        frame           $menueFrame.bf -relief flat -bd 1
        ttk::labelframe $menueFrame.bf.update   -text "Update"
        ttk::labelframe $menueFrame.bf.scale    -text "Positioning"
            pack $menueFrame.bf         -side top  -fill x
            pack $menueFrame.bf.update \
                 $menueFrame.bf.scale   -expand yes  -side top  -fill x  -pady 4

            # -- Button
        button  $menueFrame.bf.update.l_clear     -text {clear List}           -width 20    -command [list [namespace current]::cleanupTree $list_Selection]
        button  $menueFrame.bf.update.l_update    -text {update List}          -width 20    -command [list [namespace current]::update_compList {} ]
        button  $menueFrame.bf.update.c_update    -text {update Canvas}        -width 20    -command [list [namespace current]::updateCanvas]
        pack    $menueFrame.bf.update.l_clear \
                $menueFrame.bf.update.l_update \
                $menueFrame.bf.update.c_update \
                -side top

            # -- Scale
        create_config_line $menueFrame.bf.scale.off_x    "Offset x"    [namespace current]::configValue(compOffset_X)  -180 0.0 180     1      [list [namespace current]::updateCanvas]
        create_config_line $menueFrame.bf.scale.off_y    "Offset y"    [namespace current]::configValue(compOffset_y)  -180 0.0 180     1      [list [namespace current]::updateCanvas]
        create_config_line $menueFrame.bf.scale.angle    "Angle"       [namespace current]::configValue(compAngle)     -180 0.0 180     1      [list [namespace current]::updateCanvas]
        pack    $menueFrame.bf.scale.off_x \
                $menueFrame.bf.scale.off_y \
                $menueFrame.bf.scale.angle \
                -side top

        button  $menueFrame.bf.scale.reset    -text {reset}            -width 20    -command [list [namespace current]::reset_Positioning ]
        pack    $menueFrame.bf.scale.reset \
                -side top


        set compCanvas  [ canvasCAD::newCanvas    cv_Component $canvasFrame.cv  "Components" 550 550 A3 1  40  -bd 2   -bg lightgray  -relief sunken ]
        set tabID       [string map {/ . } [string map {. /} $w] ]
            # puts "\n  ... register:  $tabID $compCanvas"
        rattleCAD::gui::register_external_canvasCAD $tabID $compCanvas
       
            # -- TreeView bindings       
        bind $tree_System <<TreeviewOpen>>   [list [namespace current]::::populateTree %W]
        bind $tree_System <<TreeviewSelect>> [list [namespace current]::::selectTree   %W]
        bind $tree_Custom <<TreeviewOpen>>   [list [namespace current]::::populateTree %W]
        bind $tree_Custom <<TreeviewSelect>> [list [namespace current]::::selectTree   %W]
        bind $list_Selection <<TreeviewSelect>> [list [namespace current]::::selectList   %W]        
            # -- Notebook bindings
        bind  $nb_struct <<NotebookTabChanged>>  [list [namespace current]::cleanupTree $list_Selection]
        bind  $nb_struct <<NotebookTabChanged>>  [list [namespace current]::updateCanvas]
    }

    #-------------------------------------------------------------------------
        #  populateRoot
    proc populateRoot {treeWidget title baseDir} {
          # puts "  -> $baseDir"
        set lastNode [$treeWidget insert {} end -text $title -values [list $baseDir directory]]
        populateTree $treeWidget $lastNode
        $treeWidget item $lastNode -open 1
    }



    #-------------------------------------------------------------------------
        #  populateTree
        #
        ## Code to populate a node of the tree
    proc populateTree {tree {node {}}} {
        variable list_Selection
        
          # puts "  \n -> populateTree: $node "
        if {$node == {}} {
            set node [$tree focus]
        }

        set nodeStatus [$tree set $node type]
        set nodePath   [$tree set $node fullpath]
        switch -exact $nodeStatus {
             processedDirectory {
                     fillList $list_Selection $nodePath
                     return
                 }
             directory  {
                     fillList $list_Selection $nodePath
                     $tree delete [$tree children $node]
                 }
             default {}
        }       
        
        set contentList {}
        foreach f [lsort -dictionary [glob -nocomplain -dir $nodePath -types d *]] {
            lappend contentList $f
              # puts "   -> dir  $f"
        }
        
        foreach f $contentList {
            set type [file type $f]
            if {$type eq "directory"} {
                    # -- get directory content ---
                    #     dont add directory if it is empty
                set decission no
                set fileContent 1
                set dirContent  1
                set fileContent [catch {glob -directory $f -type f *.svg}]
                set dirContent  [catch {glob -directory $f -type d *}]
                  # puts "    \$f $f"
                  # puts "        \$decission   $decission"
                if {$fileContent == 0} { set decission yes }
                if {$dirContent  == 0} { set decission yes }
                  # puts "        \$fileContent $fileContent"
                  # puts "        \$dirContent  $dirContent"
                  # puts "        \$decission   $decission"
                if {$decission eq {yes}} {
                    set id [$tree insert $node end -text [file tail $f] -values [list $f $type]]
                    ## Make it so that this node is openable
                    $tree insert $id 0 -text dummy ;# a dummy
                    $tree item $id -text [file tail $f]
                      # puts "   -> ok ok $f"
                } else {
                      # puts "   -> no no $f"
                }
            }
        }
    
        # Stop this code from rerunning on the current node
        $tree set $node type processedDirectory
    }


    #-------------------------------------------------------------------------
        #  selectTree
        #
    proc selectTree {treeWidget} {
        
        variable compFile    
        variable compList_System    
        variable list_Selection    
        
          # puts "  \n -> selectTree:"
        set node [$treeWidget focus]
        
        # -- current Node
          # puts "  -> [$tree set $node type]"
          # puts "  -> [$tree set $node fullpath]"        
        
        set dirPath  [$treeWidget set $node fullpath]
        fillList $list_Selection $dirPath
        return
    }


    #-------------------------------------------------------------------------
        #  fillList
        #
    proc fillList {listWidget path} {

        cleanupTree $listWidget
        foreach f [lsort -dictionary [glob -nocomplain -dir $path -types f *.svg]] {
            set id [$listWidget insert {} end -text [file tail $f] -values [list $f {file}]]
              # puts "   -> file $f"
        }
    }
    
    
    #-------------------------------------------------------------------------
        #  selectList
        #
    proc selectList {listWidget} {
    
        variable compFile    
        
        set node [$listWidget focus]
          # puts "  -> listWidget: [$listWidget set $node filename]"
          # puts "  -> listWidget: [$listWidget set $node type]"
        
        set compFile [$listWidget set $node filename]
        puts "   ... try to open file $compFile"
        [namespace current]::::updateCanvas
        
        if {[catch {[namespace current]::::updateCanvas} fid]} {
            puts "   ... could not open file $compFile"
        }
        puts "   ... tried to open file $compFile"
    }


    #-------------------------------------------------------------------------
       #  update Component FileList
       #
    proc update_compList {{mode {}}} {
        variable    tree_System
        variable    tree_Custom
        variable    list_Selection
        
        cleanupTree  $tree_System
        cleanupTree  $tree_Custom
        cleanupTree  $list_Selection
        populateRoot $tree_System System [file join $::APPL_Config(CONFIG_Dir) components] 
        populateRoot $tree_Custom Custom [file join $::APPL_Config(USER_Dir)   components] 
                
    }
    
    
    #-------------------------------------------------------------------------
        #  reset Positioning
        #    
    proc cleanupTree {treeWidget} {
            # puts "  ... $treeWidget "
        foreach childNode [$treeWidget children {}] {
                # puts "   .... $childNode"
            $treeWidget detach     $childNode
            $treeWidget delete     $childNode
        }
    }

    #-------------------------------------------------------------------------
       #  reset Positioning
       #
    proc reset_Positioning {} {
            variable rdials_list
            variable configValue
            set  configValue(compAngle)     0.0
            set  configValue(compOffset_X)  0.0
            set  configValue(compOffset_y)  0.0
            foreach rd $rdials_list {
                rdial::configure $rd -value 0
            }
            [namespace current]::updateCanvas
    }

    #-------------------------------------------------------------------------
       #  refit Canvas to provided widget
       #
    proc refitCanvas {} {
            variable compCanvas
            $compCanvas refitStage
    }


    #-------------------------------------------------------------------------
       #  update Canvas
       #
    proc updateCanvas {{entryVar ""} {value {0}} {drag_Event {}}} {
            variable compCanvas
            variable compFile
            variable configValue
            
            # set currentTab [$rattleCAD::gui::noteBook_top select]
            # set varName    [rattleCAD::gui::notebook_getVarName $currentTab]
            set cv         [$compCanvas getPath] 

            
            
            if {$entryVar ne ""} {
                set $entryVar $value
            }
            
            # puts "\n ... $compCanvas"
            # puts "            ... $compFile"
            # puts "            ... $currentTab"
            # puts "            ... $varName"
            puts "            ... $cv"
            
            $compCanvas clean_StageContent
            [namespace current]::create_Centerline
            if {$compFile != {}} {
                set compPosition [list $configValue(compOffset_X) [expr 1.0*$configValue(compOffset_y)]]
                set __my_Component__        [ $compCanvas readSVG $compFile $compPosition $configValue(compAngle)  __Decoration__ ]
                [namespace current]::moveto_StageCenter $__my_Component__
                
                # puts "\n -- <D> -- $compCanvas --"

                foreach cv_Item [$cv gettags  __Decoration__] {}
                foreach cv_Item [$cv find withtag __Decoration__] {
                    # puts "  -> $cv_Item"
                    set cv_Type     [$cv type $cv_Item]
                    switch -exact $cv_Type {
                        oval     -
                        polygon  { $cv itemconfigure  $cv_Item -fill $rattleCAD::view::colorSet(components) }
                        default  {}
                    }
                    
                    
                    # puts "  -> $cvItem [$cv gettags $cv_Item]"
                }

            }

    }


    #-------------------------------------------------------------------------
       #  move Item to StageCenter
       #
    proc moveto_StageCenter {item} {
            variable  compCanvas

            set stage         [ $compCanvas getNodeAttr Canvas path ]
            set stageCenter [ canvasCAD::get_StageCenter $stage ]
            set bottomLeft  [ canvasCAD::get_BottomLeft  $stage ]
            foreach {cx cy} $stageCenter break
            foreach {lx ly} $bottomLeft  break
            $stage move $item [expr $cx - $lx] [expr $cy -$ly]
    }


    #-------------------------------------------------------------------------
       #  create Centerline
       #
    proc create_Centerline {} {
            variable  compCanvas

            set stage         [ $compCanvas getNodeAttr Canvas path ]
            set stageCenter [ canvasCAD::get_StageCenter $stage ]
            set stageFormat    [ $compCanvas getFormatSize [ $compCanvas getNodeAttr Stage format ] ]
            set stageScale    [ $compCanvas getNodeAttr Canvas scale ]

            set bottomLeft  [ canvasCAD::get_BottomLeft  $stage ]

                # puts "  $stageFormat"
            set formatWidth    [lindex $stageFormat 0]
            set formatHeight    [lindex $stageFormat 1]

                # puts "  stage        $stage"
                # puts "  stageCenter  $stageCenter"
                # puts "  stageScale   $stageScale"
                # puts "  formatWidth  $formatWidth"
                # puts "  formatHeight $formatHeight"

            set cl_x0    10
            set cl_xc    [expr 0.5*$formatWidth]
            set cl_x1    [expr $formatWidth -10]
            set cl_y0    10
            set cl_yc    [expr 0.5*$formatHeight]
            set cl_y1    [expr $formatHeight -10]

            #$compCanvas create rectangle    [list 0 0 100 100]  -fill red  -tags __CenterLine__
            $compCanvas create centerline [list $cl_x0 $cl_yc $cl_x1 $cl_yc ]  -fill red  -tags __CenterLine__
            $compCanvas create centerline [list $cl_xc $cl_y0 $cl_xc $cl_y1 ]  -fill red  -tags __CenterLine__
    }

    #-------------------------------------------------------------------------
       #  create config_line
       #
    proc create_config_line {w lb_text entryVar start current end resolution command} {
            variable    rdials_list
            set         $entryVar $current
            #puts "   ... \$entryVar [list [format "$%s" $entryVar]]"

            frame   $w
            pack    $w
            label   $w.lb   -text $lb_text           -width 10  -bd 1  -anchor w
            entry   $w.cfg  -textvariable $entryVar  -width  4  -bd 1  -justify right -bg white
            frame   $w.f    -relief sunken -bd 2 -padx 3

            rdial::create   $w.f.scl \
                            -value      $current \
                            -height     10 \
                            -width      84 \
                            -orient     horizontal \
                            -callback   [list $command $entryVar]
            lappend rdials_list $w.f.scl

                bind $w.cfg <Leave>         [list $command ]
                bind $w.cfg <Return>        [list $command ]
            pack      $w.lb  $w.cfg  $w.f  $w.f.scl    -side left  -fill x
    }

}

