##+##########################################################################
#
# package: rattleCAD    ->    lib__view_editComponent.tcl
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
#    namespace:  rattleCAD::view::svgEdit
# ---------------------------------------------------------------------------
#
# 

namespace eval rattleCAD::view::svgEdit {
        #
    variable parentWidget   {}    
    variable compList       {}
    variable compCanvas     {} 
    variable compID         {}
    variable compID_Current {}
        #
    variable updateCommand  {}
        #
    variable dict_svgEdit
    set dict_svgEdit [dict create   _template \
                                        [list \
                                                parentWidget   {} \
                                                compList       {} \
                                                compCanvas     {} \
                                                compID         {} \
                                                compID_Current {} \
                                                updateCommand  {} \
                                        ]
                                    ]
                                    
        #
    variable id_svgEdit     0
        #
}   

    #-------------------------------------------------------------------------
       #  create config Content
       #
    proc rattleCAD::view::svgEdit::create_svgEdit {w  xPath  currentValue {updateCmd {}}} {

            	# -----------------
                #			
            variable id_svgEdit
            variable dict_svgEdit
                #
            incr id_svgEdit
            set  _id    [format "%03s" $id_svgEdit]
                #
            # report_Dict
            # puts "#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#"
            # puts "======================================================="
            # appUtil::pdict $dict_svgEdit
            # puts $id_svgEdit
            # puts $id
            # puts "======================================================="
            # puts "#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#"
                #
                #
            variable compList
            variable compCanvas
            variable compID_Current
                #
            variable parentWidget
            variable updateCommand
                #
            set parentWidget $w
            set updateCommand $updateCmd
                #
                #
            set compID_Current $currentValue
                #
                #
                # -----------------
                #   add content
                # -----------------
                #   System Components Structure
            set f_select    [ frame     $w.treeFrame ]
                #
            set compList    [ ttk::treeview $f_select.tree \
                                                -show           "" \
                                                -columns        "key value keyString" \
                                                -displaycolumns "key value" \
                                                -yscroll        "$f_select.scb_try set" \
                                                -height         5]
                #
            $compList heading key    -anchor w      -text   "type"
            $compList column  key    -anchor center -width   45
            $compList heading value  -anchor w      -text   "FileName"
            $compList column  value  -anchor w      -width  160

                #
                # -----------------
            ttk::scrollbar  $f_select.scb_try \
                                  -orient vertical   \
                                  -command "$f_select.tree yview"
                #
                # -----------------
            grid $compList  $f_select.scb_try -sticky news -pady 2
                #
            grid rowconfigure    $f_select $compList -weight 1
            grid columnconfigure $f_select $compList -weight 1
                #
                # -----------------
                
                
                #####
                #
                # -----------------
            set f_canvas    [frame  $w.canvasFrame ]
                #
                #report_CanvaCAD prev_02
            if {[catch {set compCanvas  [canvasCAD::newCanvas \
                                    cv_Components_$_id \
                                    $f_canvas.cvCAD \
                                    "_editComp_"  \
                                    120 100  \
                                    passive  \
                                    1.0  0  \
                                    -bd 1  \
                                    -bg white  \
                                    -relief sunken]} fid]} \
            {
                puts "   ... could not register $compCanvas"
                puts "      <E> $fid"
            }
                # report_CanvaCAD post
                #
                # -----------------
            set key  $xPath
            set type "SELECT_File"
                #
                # -----------------
            [namespace current]::fillSelectionList $type $key
                #
                #------------------
            dict set dict_svgEdit  $_id  parentWidget    $parentWidget   
            dict set dict_svgEdit  $_id  compList        $compList   
            dict set dict_svgEdit  $_id  compCanvas      $compCanvas   
            dict set dict_svgEdit  $_id  compID_Current  $compID_Current   
            dict set dict_svgEdit  $_id  updateCommand   $updateCommand   
                #
                #
            report_Dict
                #
                #
                # -----------------
            bind $compList <<TreeviewSelect>>       [list [namespace current]::listSelection  %W $_id ]        
            bind $compList <Return>                 [list [namespace current]::commitSelected %W $_id $key]        
            bind $compList <Double-ButtonPress-1>   [list [namespace current]::commitSelected %W $_id $key]        
                #
            set cv [$compCanvas getNodeAttr Canvas path]
            bind $cv       <Double-ButtonPress-1>   [list [namespace current]::commitSelected %W $_id $key]        
                #
                # -----------------
                #
                #
            return [list $f_select $f_canvas]
                #
    }    

    #-------------------------------------------------------------------------
       #  update canvas Content
       #
    proc rattleCAD::view::svgEdit::update_svgEdit {} {
                #
            variable dict_svgEdit
                #
            puts "\n"
            puts "   -------------------------------"
            puts "    update_svgEdit"
            puts ""
                # rattleCAD::view::svgEdit::report_Dict
                # puts "\n\n"
                # report_Dict
                # report_CanvaCAD 
                #
            update
                #
            foreach key [dict keys $dict_svgEdit] {
                puts "           -> key $key"
                set compCanvas      [dict get $dict_svgEdit $key compCanvas]
                set compID_Current  [dict get $dict_svgEdit $key compID_Current]
                catch {updateCanvas $compCanvas $compID_Current}
            }
                # report_Dict
                # report_CanvaCAD    
    }

    #-------------------------------------------------------------------------
       #  cleanup Content
       #
    proc rattleCAD::view::svgEdit::cleanup_svgEdit {} {
                #
            variable dict_svgEdit
                #
            puts "\n"
            puts "   -------------------------------"
            puts "    cleanup_svgEdit"
            puts ""
                # rattleCAD::view::svgEdit::report_Dict
                # puts "\n\n"
                # report_Dict
                # report_CanvaCAD
            foreach key [dict keys $dict_svgEdit] {
                puts "           -> key $key"
                set compCanvas [dict get $dict_svgEdit $key compCanvas]
                if {[catch {$compCanvas destroy} fid]} {
                    puts "               <E> could not delete $compCanvas"
                    puts "                   ... $fid"
                } else {
                    set dict_svgEdit [dict remove $dict_svgEdit $key]
                }
            }
                # report_Dict
                # report_CanvaCAD    
    }

    #-------------------------------------------------------------------------
        #  debug procedures
        #
    proc rattleCAD::view::svgEdit::report_Dict {} {
            variable dict_svgEdit
            puts "#\n#\n#\n#\n#"
            puts "======================================================="
            appUtil::pdict $dict_svgEdit
            puts "======================================================="
            puts "#\n#\n#\n#\n#"
    }
    proc rattleCAD::view::svgEdit::report_CanvaCAD {{message {}}} {
            variable dict_svgEdit
            set dom_canvasCAD $canvasCAD::__packageRoot
            puts "==== - report_CanvaCAD - ====== - $message - ========================"
                # puts "[$dom_canvasCAD asXML]"
            foreach childNode [$dom_canvasCAD childNodes] {
                set id_Value {}
                catch {set id_Value [$childNode getAttribute "id"]}
                puts "      -> < [$childNode nodeName] $id_Value >"
                #puts "      -> < [$childNode nodeName] ... [$childNode getAttribute "id"] >"
            }
            puts "======================================================="
    }

    #-------------------------------------------------------------------------
        #  listSelection
        #
    proc rattleCAD::view::svgEdit::listSelection {w _id args} {
                #
            variable dict_svgEdit
            #variable compList    
            variable compID    
                #
            # report_Dict
                #
            puts "  --> $_id"
            puts "  --> $args"
                #
            set compList    [dict get $dict_svgEdit $_id compList]
            set compCanvas  [dict get $dict_svgEdit $_id compCanvas]
            puts " -> \$compList   $compList"
            puts " -> \$compCanvas $compCanvas"
                #
                #
            set node [$compList focus]
                #
            set compID      [$compList set $node keyString]
            set compKey     [$compList set $node key]
            set compValue   [$compList set $node value]
                #
            dict set dict_svgEdit $_id compID_Current $compID 
                #
            # puts "   ... 1 - $compID"
            # puts "   ... 2 - $compKey"
            # puts "   ... 3 - $compValue"
                #
            if {[catch {[namespace current]::updateCanvas $compCanvas $compID} fid]} {
                puts "   ... could not open file $compID"
                puts "      <E> $fid"
            }
                #
            # puts "   ... tried to open file $compID"
                #
    }

    #-------------------------------------------------------------------------
        #  updateCanvas
        #
    proc rattleCAD::view::svgEdit::updateCanvas {compCanvas compID} {
                #
            #variable compCanvas
                #
            puts ""
            puts "   -------------------------------"
            puts "    updateCanvas"
            puts "       compCanvas:       $compCanvas"
            puts "       compID:           $compID"
            puts "           $::APPL_Config(COMPONENT_Dir)"
            puts "           $::APPL_Config(USER_Dir)"

            set fileName {}
            switch -glob $compID {
                etc:*  {  set fileName  [file join $::APPL_Config(COMPONENT_Dir)            [lindex [split $compID {:}] 1] ] }
                user:* {  set fileName  [file join $::APPL_Config(USER_Dir)   components    [lindex [split $compID {:}] 1] ] }
                default {}
            }
                #
            puts "           ... $fileName"
                #
            if {$fileName != {}} {
                    #
                $compCanvas clean_StageContent
                set __my_Component__        [ $compCanvas readSVG $fileName {0 0} 0  __Decoration__ ]
                puts "  --> $__my_Component__"
                $compCanvas refitStage
                $compCanvas fit2Stage $__my_Component__
                    #
                puts "           ... canvas updated!"
            } else {
                puts "           ... empty canvas updated!"
                $compCanvas refitStage
            }
    }

    #-------------------------------------------------------------------------
        #  commitSelected
        #
    proc rattleCAD::view::svgEdit::commitSelected {w _id key args} {
                #
            variable dict_svgEdit
                #
            # variable compID
            # variable compID_Current
                #
            variable parentWidget
            variable updateCommand
                #
            puts "\n       ... rattleCAD::view::svgEdit::commitSelected"
            puts "\n             ... $w $_id $key $args"
            puts "\n"
                #
            set compID_Current  [dict get $dict_svgEdit $_id compID_Current]
                # puts " -> \$compID_Current $compID_Current"
                #
            if {$compID_Current != {}} {
                    # puts "\n         ... $compID_Current\n"
                    # puts "    ... \$key $key"
                    #
                rattleCAD::control::setValue [list $key $compID_Current]
                    #
                if {$updateCommand != {}} {
                    {*}${updateCommand}
                }
                    #
                return $compID_Current
                    #
            } else {
                    #
                puts "\n         ... $compID_Current\n"
                    #
                return $compID_Current
                    #
            }
                #
    }

    #-------------------------------------------------------------------------
        #  fillSelectionList
        #
    proc rattleCAD::view::svgEdit::fillSelectionList {type key} {
            #
        variable compList
            #
        set listBoxContent [rattleCAD::control::get_listBoxContent  $type $key]
            #
        cleanupTree $compList
            #
        foreach entry [lsort $listBoxContent] {
                # puts "         ... $entry"
            foreach {key value} [split $entry  :]  break
            set value [file tail $value]
                # set entry [format "%s:%s" $key [file normalize $entry]]
                # puts "         ... $entry ... $key ... $value"
            set entryID [$compList insert {} end -text $key -values [list $key $value $entry]]
        }
    }   

    #-------------------------------------------------------------------------
        #  reset Positioning
        #    
    proc rattleCAD::view::svgEdit::cleanupTree {treeWidget} {
            # puts "  ... $treeWidget "
        foreach childNode [$treeWidget children {}] {
                # puts "   .... $childNode"
            $treeWidget detach     $childNode
            $treeWidget delete     $childNode
        }
    }


    proc rattleCAD::view::svgEdit::listSelection_old {args} {
            #
        variable compList    
        variable compID    
            #
        set node [$compList focus]
            #
        set compID      [$compList set $node keyString]
        set compKey     [$compList set $node key]
        set compValue   [$compList set $node value]
            #
        # puts "   ... 1 - $compID"
        # puts "   ... 2 - $compKey"
        # puts "   ... 3 - $compValue"
            #
        if {[catch {[namespace current]::updateCanvas $compID} fid]} {
            puts "   ... could not open file $compID"
        }
            #
        # puts "   ... tried to open file $compID"
            #
    }