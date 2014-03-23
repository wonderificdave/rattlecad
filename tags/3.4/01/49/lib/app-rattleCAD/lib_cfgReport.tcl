 ##+##########################################################################
 #
 # package: rattleCAD   ->  lib_cfg_report.tcl
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
 #  namespace:  rattleCAD::cfg_report
 # ---------------------------------------------------------------------------
 #
 #


 namespace eval rattleCAD::cfg_report {

    global      APPL_Config

    variable    treeWidget  {}
    variable    menueFrame  {}

    #-------------------------------------------------------------------------
       #  create report widget
       #
    proc createReport {w} {
        variable treeWidget
        variable menueFrame
        variable APPL_Config

            # --- ttk::style - treeview ---
            #
        ttk::style map Treeview.Row  -background [ list selected gainsboro ]


            # --- create GUI ---
            #
        pack [ frame $w.f ] -fill both -expand yes
        set menueFrame    [ frame $w.f.f_bt    -relief groove -bd 1]
        set treeFrame     [ frame $w.f.f_tree ]
        pack    $menueFrame \
                $treeFrame\
            -fill both     -side left
        pack configure $treeFrame    -expand yes

        button  $menueFrame.open    -text {Open xml-File}                   -width 30   -command { rattleCAD::model::file::get_XMLContent {}    visualize}
        button  $menueFrame.bt01    -text {canvasCAD}                       -width 30   -command { rattleCAD::cfg_report::fillTree_Variable $canvasCAD::__packageRoot    }
        button  $menueFrame.bt02    -text {rattleCAD_init.xml}              -width 30   -command { rattleCAD::cfg_report::fillTree_Variable $APPL_Config(root_InitDOM) }
        button  $menueFrame.bt03    -text {Template Road}                   -width 30   -command { rattleCAD::model::file::get_XMLContent [rattleCAD::model::file::getTemplateFile Road]     visualize}
        button  $menueFrame.bt04    -text {Template OffRoad}                -width 30   -command { rattleCAD::model::file::get_XMLContent [rattleCAD::model::file::getTemplateFile MTB ]     visualize}


        button  $menueFrame.bt05    -text {current Values}                  -width 30   -command { rattleCAD::cfg_report::fillTree_Variable $bikeGeometry::domFrame    }
        button  $menueFrame.bt06    -text {current Project}                 -width 30   -command { rattleCAD::cfg_report::fillTree_Variable {currentProject} }
        button  $menueFrame.bt07    -text {rattleCAD - Runtime}             -width 30   -command { rattleCAD::cfg_report::fillTree_Variable {runTime} }
        button  $menueFrame.bt08    -text {OS - Environment}                -width 30   -command { rattleCAD::cfg_report::fillTree_Variable {osEnv} }
        button  $menueFrame.clear   -text {clear Tree}                      -width 30   -command { rattleCAD::cfg_report::cleanupTree }
        
        pack    $menueFrame.open \
                $menueFrame.bt01 \
                $menueFrame.bt02 \
                $menueFrame.bt03 \
                $menueFrame.bt04 \
                $menueFrame.bt06 \
                $menueFrame.bt07 \
                $menueFrame.bt08 \
                $menueFrame.clear \
                -side top


            #    [rattleCAD::model::file::getTemplateFile    $::APPL_Config(TemplateType)]

        set treeWidget  [ ttk::treeview $treeFrame.tree \
                                                    -columns "attr value" \
                                                    -xscrollcommand "$treeFrame.tree_x set" \
                                                    -yscrollcommand "$treeFrame.tree_y set" ]
            $treeWidget heading "#0"   -anchor w  -text "XML" -anchor w
            $treeWidget column  "#0"   -width  200
            $treeWidget heading attr   -anchor w  -text "Attribute"
            $treeWidget column  attr   -width  100
            $treeWidget heading value  -anchor w  -text "Value"
            $treeWidget column  value  -width  900



        scrollbar     $treeFrame.tree_x     -ori hori     -command "$treeFrame.tree xview"
        scrollbar     $treeFrame.tree_y     -ori vert     -command "$treeFrame.tree yview"
            grid     $treeFrame.tree     $treeFrame.tree_y  -sticky news
            grid                         $treeFrame.tree_x  -sticky news

            grid     rowconfig        $treeFrame 0 -weight 1
            grid     columnconfig     $treeFrame 0 -weight 1
    }


    #-------------------------------------------------------------------------
       #  cleanup Tree
       #
    proc cleanupTree {} {
        variable treeWidget
            # puts "  ... $treeWidget "
        foreach childNode [$treeWidget children {} ] {
                # puts "   .... $childNode"
            $treeWidget detach     $childNode
            $treeWidget delete     $childNode
        }
    }


    #-------------------------------------------------------------------------
       #  fill Tree - Variable
       #
    proc fillTree_Variable {var} {
            #
            # -- define global parameters
            #
        switch -exact $var {
            currentProject {
                    # set var [bikeGeometry::get_projectDOM]
					set var $rattleCAD::control::currentDOM
                }
            runTime {   
                    set var [appUtil::namespaceReport ::]
                }
            osEnv {
                    set var $osEnv::registryDOM
            }
   
            default {}
        }
            
        rattleCAD::cfg_report::fillTree "$var" root
    }


    #-------------------------------------------------------------------------
       #  fill Tree - File
       #
    proc fillTree {node parent} {
        variable treeWidget
        cleanupTree
        # recurseInsert $treeWidget "$node" $parent
        recurseInsert $treeWidget "$node" {}
        # $treeWidget toggle $node
    }



    #-------------------------------------------------------------------------
       #  fill Tree - help function
       #
    proc recurseInsert {w node parent} {

            proc getAttributes node {
                    if {![catch {$node attributes} res]} {set res}
            }

            set domDepth [llength [split [$node toXPath] /]]
            set nodeName [$node nodeName]
            set done 0
            if {$nodeName eq "#text" || $nodeName eq "#cdata"} {
                set text [string map {\n " "} [$node nodeValue]]
            } else {
                set text {}
                set nodeAttr_Name {-}
                foreach att [getAttributes $node] {
                    if {$att == {name}} {
                        catch {set nodeAttr_Name [$node getAttribute name]}
                        continue
                    }
                    catch {append text " $att=\"[$node getAttribute $att]\""}
                }
                set children [$node childNodes]
                if {[llength $children]==1 && [$children nodeName] eq "#text"} {
                    append text " [$children nodeValue]"
                    set done 1
                }
            }
            $w insert $parent end -id $node -text $nodeName -tags $node -values [list "$nodeAttr_Name" "$text" ]

            case [expr $domDepth-1] {
                 0  {   set r [format %x  0];   set g [format %x  0];   set b [format %x 15]}
                 1  {   set r [format %x  3];   set g [format %x  0];   set b [format %x 12]}
                 2  {   set r [format %x  6];   set g [format %x  0];   set b [format %x  9]}
                 3  {   set r [format %x  9];   set g [format %x  0];   set b [format %x  6]}
                 4  {   set r [format %x 12];   set g [format %x  0];   set b [format %x  3]}
                 5  {   set r [format %x 15];   set g [format %x  0];   set b [format %x  0]}
                 6  {   set r [format %x 12];   set g [format %x  3];   set b [format %x  0]}
                 7  {   set r [format %x  9];   set g [format %x  6];   set b [format %x  0]}
                 8  {   set r [format %x  6];   set g [format %x  9];   set b [format %x  0]}
                 9  {   set r [format %x  3];   set g [format %x 12];   set b [format %x  0]}
                10  {   set r [format %x  0];   set g [format %x 15];   set b [format %x  0]}
                11  {   set r [format %x  0];   set g [format %x 12];   set b [format %x  3]}
                12  {   set r [format %x  0];   set g [format %x  9];   set b [format %x  6]}
                13  {   set r [format %x  0];   set g [format %x  6];   set b [format %x  9]}
                14  {   set r [format %x  0];   set g [format %x  3];   set b [format %x 12]}
                15  {   set r [format %x  0];   set g [format %x  0];   set b [format %x 15]}
                default
                    {    set r [format %x 12];    set g [format %x 12];    set b [format %x 12]}
            }
            set fill [format "#%s%s%s%s%s%s" $r $r $g $g $b $b]

            $w tag configure $node -foreground $fill
            if {$parent eq {}} {$w item $node -open 1}
            if !$done {
                foreach child [$node childNodes] {
                    recurseInsert $w $child $node
                }
            }
    }


}

