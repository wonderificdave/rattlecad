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
}   

    #-------------------------------------------------------------------------
       #  create config Content
       #
    proc rattleCAD::view::svgEdit::create_svgEdit {w  xPath  currentValue {updateCmd {}}} {

            	# -----------------
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
            if {$compCanvas != {}} {
                $compCanvas destroy
            }
                #
                # -----------------
            set f_canvas     [ frame     $w.canvasFrame ]
                #
            set compCanvas [canvasCAD::newCanvas \
                                    cv_Components \
                                    $f_canvas.cvCAD \
                                    "_editComp_"  \
                                    120 100  \
                                    passive  \
                                    1.0  0  \
                                    -bd 1  \
                                    -bg white  \
                                    -relief sunken]
                #
                # -----------------
            set key  $xPath
            set type "SELECT_File"
                #
                # -----------------
            [namespace current]::fillSelectionList $type $key
                #
                # -----------------
            bind $compList <<TreeviewSelect>>       [list [namespace current]::listSelection  %W]        
            bind $compList <Return>                 [list [namespace current]::commitSelected %W $key]        
            bind $compList <Double-ButtonPress-1>   [list [namespace current]::commitSelected %W $key]        
                #
            set cv [$compCanvas getNodeAttr Canvas path]
            bind $cv       <Double-ButtonPress-1>   [list [namespace current]::commitSelected %W $key]        
                #
                # -----------------
            # update
            # [namespace current]::selectCurrent
                #
                #
            return [list $f_select $f_canvas]
                #
    }

    #-------------------------------------------------------------------------
        #  listSelection
        #
    proc rattleCAD::view::svgEdit::listSelection {args} {
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

    #-------------------------------------------------------------------------
        #  updateCanvas
        #
    proc rattleCAD::view::svgEdit::updateCanvas {{compFile {}}} {
                #
            variable compCanvas
                #
            puts ""
            puts "   -------------------------------"
            puts "    updateCanvas"
            puts "       compFile:       $compFile"
            puts "           $::APPL_Config(COMPONENT_Dir)"
            puts "           $::APPL_Config(USER_Dir)"

            set fileName {}
            switch -glob $compFile {
                etc:*  {  set fileName  [file join $::APPL_Config(COMPONENT_Dir)            [lindex [split $compFile {:}] 1] ] }
                user:* {  set fileName  [file join $::APPL_Config(USER_Dir)   components    [lindex [split $compFile {:}] 1] ] }
                default {}
            }
                #
            puts "           ... $fileName"
                #
            if {$fileName != {}} {
                    #
                $compCanvas clean_StageContent
                set __my_Component__        [ $compCanvas readSVG $fileName {0 0} 0  __Decoration__ ]
                $compCanvas fit2Stage $__my_Component__
                $compCanvas refitStage
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
    proc rattleCAD::view::svgEdit::commitSelected {w key args} {
            #
        variable compID
        variable compID_Current
            #
        variable parentWidget
        variable updateCommand
            #
        puts "\n       ... rattleCAD::view::svgEdit::commitSelected"
        puts "\n             ... $w $key $args"
        puts "\n"
            #
        if {$compID != {}} {
                # puts "\n         ... $compID\n"
                # puts "    ... \$key $key"
                #
            rattleCAD::control::setValue [list $key $compID]
                #
            if {$updateCommand != {}} {
                {*}${updateCommand}
            }
                #
            return $compID
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
        #  selectCurrent
        #
    proc rattleCAD::view::svgEdit::selectCurrent {} {
            #
        variable compID_Current
        variable compList
            #
            # puts "\n   ... selectCurrent: $compID_Current\n"
            #
        foreach {key value} [split $compID_Current :] break
        set checkString [format "%s:%s" $key [file tail $value]]
        #set checkString $compID_Current
            #
        puts "\n   ... selectCurrent: $checkString\n"
            #
            #
        set children [$compList children {}]
            #
        foreach node $children {  
                puts "  ... $node"
            set compID  [$compList set $node keyString]
            set key     [$compList set $node key]
            set value   [$compList set $node value]
                # puts "           ... $compID"
                # puts "           ... $key"
                # puts "           ... $value"
            set nodeString [format "%s:%s" $key $value]
                # puts "           ... >$nodeString<"
            if {[string equal $checkString $nodeString]} {
                    #
                    # puts ""
                    # puts "           -> ... $checkString"
                    puts "           -> ... $nodeString"
                $compList selection set $node
                focus $compList
                    puts "           -> ... $compID"
                    #
                if {[catch {[namespace current]::updateCanvas $compID} fid]} {
                    puts "   ... could not open file $compID"
                }                
            } else {
                    # puts ""
                    # puts "              ... $checkString"
                    # puts "              ... $nodeString"
            }
        }
            #
        return
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

