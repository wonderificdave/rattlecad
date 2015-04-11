#! /bin/env tclsh
# http://wiki.tcl.tk/300
#



 namespace eval appUtil::explorer {

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


        # button  $menueFrame.open    -text {Open xml-File}                   -width 30   -command { tk_messageBox -message "not implemented yet"}
        button  $menueFrame.bt07    -text {runtime}             -width 30   -command { appUtil::explorer::fillTree_Variable {runTime} }
        # button  $menueFrame.bt08    -text {OS - Environment}                -width 30   -command { appUtil::explorer::fillTree_Variable {osEnv} }
        button  $menueFrame.clear   -text {clear Tree}                      -width 30   -command { appUtil::explorer::cleanupTree }
        
        # $menueFrame.open \
        # $menueFrame.bt08 \
                
        pack    $menueFrame.bt07 \
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
            runTime {   
                    set var [appUtil::namespaceReport ::]
                    puts "   ... $var"
                    # puts [$var asXML]
                }
            osEnv {
                    # set var $osEnv::registryDOM
                    # ... somethinc good maybee ...
            }
   
            default {}
        }
            
        [namespace current]::fillTree "$var" root
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
                    switch -exact $att {
                        {attr} {
                                catch {set nodeAttr_Name [$node getAttribute attr]}
                                continue
                            }
                        {name} {
                                catch {set nodeAttr_Name [$node getAttribute name]}
                                continue
                            }
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



proc appUtil::createExplorer {} {
        #
    package require Tk
        #
        #  Create the main message window
        #
    wm minsize . 800 700
    wm maxsize . 900 1200
        #
    set f [frame .f]
    pack $f -expand true -fill both -ipadx 100 -ipady 40
    appUtil::explorer::createReport $f
        #
    appUtil::explorer::fillTree_Variable {runTime}
    
        #  Create the main menu bar with a Help-About entry
    menu .menubar
    menu .menubar.help -tearoff 0
    .menubar add cascade -label Help -menu .menubar.help -underline 0
    .menubar.help add command \
        -label {About Hello ...} \
        -accelerator F1 \
        -underline 0 \-command showAbout


        #  Configure the main window 
    wm title . {appUtil - RuntimeExplorer}
    . configure -menu .menubar -width 200 -height 150
    bind . {<Key F1>} {showAbout}
}


#  Define a procedure - an action for Help-About
proc appUtil::showAbout {} {
    tk_messageBox -message "Tcl/Tk\nHello Windows\nVersion 1.0" \
        -title {About Hello}
}