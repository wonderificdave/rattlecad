 ##+##########################################################################
 #
 # package: rattleCAD   ->  lib_project.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2010/11/26
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
 #  namespace:  rattleCAD::project
 # ---------------------------------------------------------------------------
 #
 # 

 namespace eval project {

        # --------------------------------------------
        # initial package definition
    package require tdom
    
    
    # --------------------------------------------
        # Export as global command
    variable packageHomeDir [file normalize [file join [pwd] [file dirname [info script]]] ]
    
    
    #-------------------------------------------------------------------------
        #  definitions of template Documents
    variable initDOM 
    variable projectDOM
    variable projectDICT
    variable resultNode
    
    
    #-------------------------------------------------------------------------
        #  fill initDOM
        #    ... these are default settings for the application
        #               
    set fp [open [file join $packageHomeDir .. etc initTemplate.xml] ]
    fconfigure      $fp -encoding utf-8
    set initXML     [read $fp]
    close           $fp          
    set initDoc     [dom parse $initXML]
    set initDOM     [$initDoc documentElement]
    
    
    #-------------------------------------------------------------------------
        #  fill projectDOM
        #    ... these is a default project
        #  
    set fp [open [file join $packageHomeDir .. etc projectTemplate.xml] ]
    fconfigure      $fp -encoding utf-8
    set projXML     [read $fp]
    close           $fp          
    set projDoc     [dom parse $projXML]
    set projectDOM  [$projDoc documentElement]
    
    
    #-------------------------------------------------------------------------
        #  get the resultNodeStructure
        #    ... and add it to projectDOM
        #               
    set resultNode [$initDOM selectNode Result]    
    
    
    #-------------------------------------------------------------------------
        #  handle update procedure
        #
    variable postUpdate [ dict create ]
    
    #-------------------------------------------------------------------------
        #  handle Project Information
        #
    variable Project;   array set Project {}
         set Project(Name)      "I am new, ..."
         set Project(modified)  [clock milliseconds]
    
 
    #-------------------------------------------------------------------------
    proc get_xPath {node} {
            variable xPath
            set xPath "[$node nodeName]"
            proc parentNode {node} {
                    variable xPath
                    #puts [$node nodeName]
                    set node [$node parent]
                    if {$node != {}} {
                            set xPath "[$node nodeName]/$xPath"
                            parentNode $node
                    }
            }
            parentNode $node
            return "/$xPath"
    }
    #-------------------------------------------------------------------------
    proc add_tracing {} {
                # puts "\n   project::add_tracing\n"
            #trace add     variable [namespace current]::Personal    write [namespace current]::trace_ProjectConfig
            #trace add     variable [namespace current]::Custom      write [namespace current]::trace_ProjectConfig
            #trace add     variable [namespace current]::Lugs        write [namespace current]::trace_ProjectConfig
            #trace add     variable [namespace current]::Component   write [namespace current]::trace_ProjectConfig
            #trace add     variable [namespace current]::FrameTubes  write [namespace current]::trace_ProjectConfig
            #trace add     variable [namespace current]::Rendering   write [namespace current]::trace_ProjectConfig
    }
    proc remove_tracing {} {
                # puts "\n   project::remove_tracing\n"
            #trace remove  variable [namespace current]::Personal    write [namespace current]::trace_ProjectConfig
            #trace remove  variable [namespace current]::Custom      write [namespace current]::trace_ProjectConfig
            #trace remove  variable [namespace current]::Lugs        write [namespace current]::trace_ProjectConfig
            #trace remove  variable [namespace current]::Component   write [namespace current]::trace_ProjectConfig
            #trace remove  variable [namespace current]::FrameTubes  write [namespace current]::trace_ProjectConfig
            #trace remove  variable [namespace current]::Rendering   write [namespace current]::trace_ProjectConfig
    }
    #-------------------------------------------------------------------------
    proc trace_ProjectConfig {varname key operation} {
            if {$key != ""} {
                set varname ${varname}($key)
            }
            upvar $varname var
              # appUtil::get_procHierarchy
            
            puts "\n\n"
            puts "   --<trace>--------------------------"
            puts "    trace_ProjectConfig"
            puts "       varname:         $varname"
            puts "       key:             $key"
            puts "       var:             $var"
            puts "       operation:       $operation"
                
            return
    }    
    #-------------------------------------------------------------------------
    proc dom_2_runTime {} {          

            variable projectDOM 
            
            puts ""
            puts "   -------------------------------"
            puts "    project::dom_2_runTime"
            puts ""
                  
               # puts [$projectDOM asXML] 
              
              # -- add a clean resultNode to the project
            update_projectResult 
            
            set resultNode [$projectDOM selectNode Result]
                # puts [$resultNode asXML] 
                # exit
            
            
            foreach branch [[$projectDOM selectNodes /root] childNodes] {
                    
                        # puts "  NodeType:  [$branch nodeType]"
                    if {[$branch nodeType] != {ELEMENT_NODE}} {
                            continue
                    }
                    set branch_Name     [$branch nodeName]
                    
                      # puts "         branch_Name:     $branch_Name"

                    set branch_xPath    [get_xPath $branch]
                    set myArray $branch_Name
                    array unset [namespace current]::$myArray
                    
                    foreach node [$branch getElementsByTagName *] {
                                # puts "\n-----\n[$node nodeName][$node nodeValue]"
                                # puts "\n-----\n[$node nodeName] [$node nodeType] -> [$node nodeValue]"
                                # puts "\n-----\n[$node nodeName] [$node nodeType]"
                                # puts "     [[$node firstChild] nodeType]  [[$node firstChild] asXML]"
                            if {[[$node firstChild] nodeType] == {TEXT_NODE}} {
                                set xPath [get_xPath $node]
                                set xPath [string range $xPath [string length $branch_xPath/] end]
                                    # puts "----- [$node nodeType]: $xPath "
                                    # puts "\n-----\n   [$node nodeType]: $xPath "
                                    # puts "          -> [[$node firstChild] nodeValue]"
                                set [format "%s::%s(%s)" [namespace current] $myArray $xPath] [[$node firstChild] nodeValue]
                            }
                    }
                        #parray $myArray
            }
            
            # add_tracing
    }
    #-------------------------------------------------------------------------
    proc runTime_2_dom {{_projectDOM {}}} {
            
            variable projectDOM 
            
                puts ""
                puts "   -------------------------------"
                puts "    project::runTime_2_dom"
                puts ""
                
            foreach branch [[$projectDOM selectNodes /root] childNodes] {
                    
                    if {[$branch nodeType] != {ELEMENT_NODE}} {
                            continue
                    }
                    
                    set branch_Name     [$branch nodeName]
                      # puts "         branch_Name:     $branch_Name"
                    set branch_xPath    [get_xPath $branch]
                    set myArray $branch_Name

                    foreach node [$branch getElementsByTagName *] {
                                # puts "\n-----\n[$node nodeName][$node nodeValue]"
                                # puts "\n-----\n[$node nodeName] [$node nodeType] -> [$node nodeValue]"
                                # puts "\n-----\n[$node nodeName] [$node nodeType]"
                                # puts "     [[$node firstChild] nodeType]  [[$node firstChild] asXML]"
                            if {[[$node firstChild] nodeType] == {TEXT_NODE}} {
                                set xPath [get_xPath $node]
                                set xPath [string range $xPath [string length $branch_xPath/] end]
                                    # puts "----- [$node nodeType]: $xPath "
                                    # puts "\n-----\n   [$node nodeType]: $xPath "
                                    # puts "          -> [[$node firstChild] nodeValue]"
                                    # puts " -> $xPath"
                                set textNode [$node firstChild]
                                    # puts "      [$textNode asXML]"
                                eval set value [format "$%s::%s(%s)" [namespace current] $myArray $xPath]
                                    # puts "      $value"
                                $textNode nodeValue $value
                            }
                    }
            }
            return $projectDOM
    }
    #-------------------------------------------------------------------------
    proc runTime_2_dict {} {
            
            variable projectDICT 
            
            set domNode [runTime_2_dom]
                
            #puts "\n\n"
            #puts "     -------------------------------"
            #puts "      projectGeometry::runTime_2_dict"
            #puts "        ... domNode:  [$domNode nodeName]" 

            foreach branch [[$domNode selectNodes /[$domNode nodeName]] childNodes] {
                    # puts " 1st level:  [$branch toXPath]"
                    # just care about nodes of type ELEMENT_NODE
                    #  or be aware of comments at this level
                if {[$branch nodeType] != {ELEMENT_NODE}} {
                    continue
                }
                    # create a new branch in dictionary projectDICT
                set branchNode [[dom parse [$branch asXML]] documentElement]
                    # fill the dictionary
                recurse_domTree $branchNode
            }
            return $projectDICT 
    }    
    #-------------------------------------------------------------------------
        # unifyKey 
        #
        #    key of format:
        #            NAME(a)
        #            NAME(a/b/c)
        #            NAME/a
        #            NAME/a/b/c
        #         
    proc unifyKey {key} {
        
        package require appUtil 0.9
        # appUtil::get_procHierarchy
        
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
        #
    }
    #-------------------------------------------------------------------------
        # setValue {key type args}
        #
        #        key of format:
        #            NAME(a)
        #            NAME(a/b/c)
        #            NAME/a
        #            NAME/a/b/c 
        #
    proc setValue {key type args} {
    
            foreach {_array _name _path} [unifyKey $key] break
                # set _array [lindex [split $arrayName (] 0]
                # set _name [lindex [split $arrayName ()] 1]
            
                # -- Exception on different types of direction definitions
            switch -exact $type {
                    direction     {    
                                    if { [file tail $_name] != {polar} } {
                                        set _name     [file join $_name polar] 
                                    }
                                }
                    polygon     {    
                                    if { [file tail $_name] != {Polygon} } {
                                        set _name     [file join $_name Polygon] 
                                    }
                                }
                    value       {}
                    default     {}
            }
                # puts "  -> exist? ... [array names [namespace current]::$_array $_name]"
            set check_name [array names [namespace current]::$_array $_name]
            if { $check_name == {} } {
                puts "\n"
                puts "         --<E>--setValue----------------------------"
                puts "             ... /$_array/$_name not found in [namespace current]::$_array"
                puts "         --<E>--setValue----------------------------"
                puts "\n"
                    # eval parray [namespace current]::$_array
                error "... /$_array/$_name not found in [namespace current]::$_array"
                return 1
            }

                # eval set value [format "$%s::%s(%s)" [namespace current] $_array $_name]
                # puts "            -> current value: $value \n"
            
            switch -exact $type {
                    value         {    
                                    eval set [format "%s::%s(%s)" [namespace current] $_array $_name] [lindex $args 0]
                                }
                    direction     {    
                                        # puts "\n   ... direction\n         ... $xPath\n  ______________________"
                                        # puts "            $args"
                                    set value     [ flatten_nestedList [ flatten_nestedList $args ]]
                                        # puts "            $value"
                                    if {[llength $value] == 2} {
                                        set p0    {0 0} 
                                        set p1    [list [lindex $value 0] [lindex $value 1] ]
                                    } else {
                                        set p0    [list [lindex $value 0] [lindex $value 1] ]
                                        set p1    [list [lindex $value 2] [lindex $value 3] ]
                                    }
                                    set value    [ vectormath::unifyVector    $p0 $p1]
                                    set value    [format "%f,%f" [lindex $value 0] [lindex $value 1]] 
                                    #puts "  -- 01 --"
                                    eval set [format "%s::%s(%s)" [namespace current] $_array $_name] $value
                                    
                                        # --- set angular Value - degree
                                    set angleDegree 0
                                    set _name     [file join [ file dirname $_name ] degree]
                                    set check_name [array names [namespace current]::$_array $_name]
                                    if { $check_name != {} } {
                                        set angleDegree    [format "%.5f" [ vectormath::dirAngle {0 0} $p1] ]
                                        #puts "  -- 02 --"
                                        eval set [format "%s::%s(%s)" [namespace current] $_array [file join [ file dirname $_name ] degree]] $angleDegree
                                    }
                                        # --- set angular Value - radiant
                                    set angleRadiant 0
                                    set _name     [file join [ file dirname $_name ] radiant]
                                    set check_name [array names [namespace current]::$_array $_name]
                                    if { $check_name != {} } {
                                            # puts "     angleDegree   $angleDegree"
                                        set angleRadiant    [format "%.6f" [ vectormath::rad $angleDegree] ]
                                            # puts "     angleRadiant  $angleRadiant"
                                        #puts "  -- 03 --"
                                        eval set [format "%s::%s(%s)" [namespace current] $_array [file join [ file dirname $_name ] radiant]] $angleRadiant
                                    }
                                }
                    position     {    
                                    set value    [ flatten_nestedList $args ]    
                                    #puts "  -- 04 --"
                                    eval set [format "%s::%s(%s)" [namespace current] $_array $_name] [format "%f,%f" [lindex $value 0] [lindex $value 1]]
                                }
                    polygon     {    
                                    set value {}
                                    foreach {x y} [flatten_nestedList $args] {
                                            # puts "             $x $y"
                                        append value [format "%f,%f " $x $y]
                                    }
                                    #puts "  -- 05 --"
                                    eval set [format "%s::%s(%s)" [namespace current] $_array $_name] \"$value\"
                                }
                    default        {    
                                    puts "         --<E>--setValue----------------------------"
                                    puts "             ... $type ... unhandled"
                                    puts "         --<E>--setValue----------------------------"
                                    puts "     ... $type ... unhandled"
                                }
            }

    }
    #-------------------------------------------------------------------------
        # getValue {key type args}
        #
        #        key of format:
        #            NAME(a)
        #            NAME(a/b/c)
        #            NAME/a
        #            NAME/a/b/c 
        #
    proc getValue {key type args} {
    
            foreach {_array _name xPath} [unifyKey $key] break
                # set _array [lindex [split $arrayName (] 0]
                # set _name  [lindex [split $arrayName ()] 1]
                # set xPath  [format "%s/%s" $_array $_name]
            
                # -- Exception on different types of direction definitions
            switch -exact $type {
                    direction     {    
                                    if { [file tail $_name] != {polar} } {
                                        set _name	[file join $_name polar] 
                                    }
                                }
                    polygon     {    
                                    if { [file tail $_name] != {Polygon} } {
                                        set _name	[file join $_name Polygon] 
                                    }
                                }
            }
                # puts "  -> exist? ... [array names [namespace current]::$_array $_name]"
            set check_name [array names [namespace current]::$_array $_name]
            if { $check_name == {} } {
                puts "\n"
                puts "         --<E>--getValue----------------------------"
                puts "             ... /$_array/$_name not found in [namespace current]::$_array"
                puts "         --<E>--getValue----------------------------"
                puts "\n"
                return
            }
            
            eval set value [format "$%s::%s(%s)" [namespace current] $_array $_name]
                # puts "            -> current value: $value \n"
                    
            switch -exact $type {
                    value         {}
                    direction	{	if {[llength $args] != 0} {
                                        if {[lindex $args 0] == {angle} } {
                                            puts "   \n .... will become continued \n"                                      
                                            set value 0.0123
                                        }
                                    }
                                }
                    position	{	if {[llength $args] != 0} {
                                        set value [lindex [split $value ,] [lindex $args 0] ]
                                    }
                                }
                    polygon		{	if {[llength $args] != 0} {
                                            # puts "      ......... $value"
                                        set value [lindex [split $value { }] [lindex $args 0] ]
                                            # puts "      ......... $value"
                                    }
                                }
            }
            # puts "    ... return new: $value"
            return $value            
    }
    #-------------------------------------------------------------------------
        #  init Fork Configuration
        #  ... 
        #
    proc add_forkSetting {_forkDOM} {
            variable initDOM
            
            puts "\n"
            puts "   -------------------------------"
            puts "    project::add_forkSetting"
            puts ""
            
            set forkNode   [$initDOM selectNode Fork]
            
            if {$_forkDOM == {}} {
                # $initDOM appendXML [$_forkDOM asXML]
                puts "        using bikeGeometry  ... default"
            } else {
                  # puts [$forkNode asXML]
                $initDOM removeChild $forkNode
                $forkNode delete
                $initDOM appendXML [$_forkDOM asXML]
                puts "        updated by value"
            }
              # puts "[[$initDOM selectNode Fork] asXML]"
    }
    #-------------------------------------------------------------------------
       #  import templates to current project
    proc import_ProjectSubset {nodeRoot} {
                # puts "[$nodeRoot asXML]"
                
                    puts "\n"
                    puts "   -------------------------------"
                    puts "    project::import_ProjectSubset"
                    
              # project::remove_tracing
            
            set setValue_Command    {}
            set setValue_Command_OK {}
                
            foreach branch  [$nodeRoot selectNodes {descendant::text()}] {
                set nodeValue   [$branch nodeValue]
                set nodePath    [$branch toXPath]
                set _array      [lindex [split $nodePath /] 2]
                
                switch -exact $_array {
                    Personal    -
                    Custom      -
                    FrameTubes  -
                    Component   -
                    Lugs        -
                    Rendering   {
                                set _name       [lrange [split $nodePath /] 3 end-1]
                                set _nameValue  [lindex $_name 0]
                                foreach value [lrange $_name 1 end] {
                                    append _nameValue "/$value"
                                }
                                
                                set setValue_Command    [format "setValue %s(%s) value $nodeValue" $_array $_nameValue]
                                #if { [catch {eval [format "setValue %s(%s) value $nodeValue" $_array $_nameValue]} fid] } 
                                if { [catch {eval $setValue_Command} fid] } {
                                    puts [format "              <fail>   setValue %s(%s) value $nodeValue" $_array $_nameValue]
                                } else {
                                    puts [format "                  ->   setValue %s(%s) value $nodeValue" $_array $_nameValue]
                                    set setValue_Command_OK $setValue_Command
                                }
                            }
                    default {}
                }

            }
            
              # project::add_tracing
            
            if {$setValue_Command_OK != {}} {
                eval $setValue_Command
            }
            # eval [format "setValue %s(%s) value $nodeValue" $_array $_nameValue]

    }
 


    
    #-------------------------------------------------------------------------
        # see  http://wiki.tcl.tk/440
        #
    proc flatten_nestedList { args } {
            if {[llength $args] == 0 } { return ""}
            set flatList {}
            foreach e [eval concat $args] {
                foreach ee $e { lappend flatList $ee }
            }
                # tk_messageBox -message "flatten_nestedList:\n    $args  -/- [llength $args] \n $flatList  -/- [llength $flatList]"
            return $flatList
    }    
    
    
    #-------------------------------------------------------------------------
        # recursion function for runTime_2_dict
    proc recurse_domTree {node} {
            variable projectDICT
            
            set xPath       [$node toXPath]
            set nodeName    [$node nodeName]
            # puts "   -> $xPath - $nodeName"

            
            set nodeType [$node nodeType]
            
              # just handle nodes of type ...
            switch -exact -- $nodeType {
              TEXT_NODE {
                    set textValue [$node asText]
                    set dictPath  [lrange [split [string trim $xPath "/"] /] 0 end-1]
                    dict set projectDICT {*}${dictPath} {}
                    set_dictValue ${dictPath} ${textValue}
                    return
                  }
              ELEMENT_NODE {
                    foreach childNode [$node childNodes] {
                        recurse_domTree $childNode
                    }
                  }
              default { return }
            }
    }
    proc set_dictValue {dictPath dictValue} {
            variable projectDICT         
            if {[dict exists $projectDICT {*}$dictPath]} {
                  # nested dict does exist
                if {[expr fmod([llength $dictValue],2)] < 1} {
                    set command [format "dict set projectDICT %s {\"%s\"}" $dictPath $dictValue]
                } else {
                    set command [format "dict set projectDICT %s {%s}" $dictPath $dictValue]
                }
                {*}$command
                return
            }
    }
    proc get_dictValue {dictPath dictKey} {
              variable projectDICT  
              set value "___undefined___"
              catch {set value [dict get $projectDICT {*}$dictPath $dictKey]}
                # puts "     ... getValue: $value  <- $dictPath / $dictKey"
              return $value
    }     
    #-------------------------------------------------------------------------
        # see  http://wiki.tcl.tk/23526
        #
    proc pdict { d {i 0} {p "  "} {s " -> "} } {
            set errorInfo $::errorInfo
            set errorCode $::errorCode
                set fRepExist [expr {0 < [llength\
                        [info commands tcl::unsupported::representation]]}]
            while 1 {
                if { [catch {dict keys $d}] } {
                    if {! [info exists dName] && [uplevel 1 [list info exists $d]]} {
                        set dName $d
                        unset d
                        upvar 1 $dName d
                        continue
                    }
                    return -code error  "error: pdict - argument is not a dict"
                }
                break
            }
            if {[info exists dName]} {
                puts "dict $dName"
            }
            set prefix [string repeat $p $i]
            set max 0
            foreach key [dict keys $d] {
                if { [string length $key] > $max } {
                    set max [string length $key]
                }
            }
            dict for {key val} ${d} {
                puts -nonewline "${prefix}[format "%-${max}s" $key]$s"
                if {    $fRepExist && ! [string match "value is a dict*"\
                            [tcl::unsupported::representation $val]]
                        || ! $fRepExist && [catch {dict keys $val}] } {
                    puts "'${val}'"
                } else {
                    puts ""
                    pdict $val [expr {$i+1}] $p $s
                }
            }
            set ::errorInfo $errorInfo
            set ::errorCode $errorCode
            return ""
    }

}
