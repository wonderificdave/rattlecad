#!/bin/sh
# lib_dict.tcl \
exec tclsh "$0" ${1+"$@"}


    #-------------------------------------------------------------------------
        #
    proc appUtil::namespaceReport {{_namespace {}}} {
        set xml "<root/>"
        set domDOC  [dom parse $xml]
        set domNode [$domDOC documentElement]      
        
        if {$_namespace == {}} {
           set _namespace {::}
        }
        
        _add_namespaceReport $domNode $_namespace
                
        #puts "[$domNode asXML]"
        return $domNode
    }
    #-------------------------------------------------------------------------
        #
    proc appUtil::_add_namespaceReport {domNode namespaceName} {
        
        set domDOC [$domNode ownerDocument]
        
        set namespaceList   [namespace children $namespaceName]
            # puts "    $namespaceName  -> $namespaceList"
        foreach _element [lsort $namespaceList] {
            set childNamespace_Name [string map [list $namespaceName {}] $_element]
            set _nodeName   [string map [list {::} {}] $childNamespace_Name]
                # puts "         -> $childNamespace_Name"
            set _node [$domDOC createElement $_nodeName]
            $domNode appendChild $_node
                # -- add next Level
            _add_namespaceReport $_node $_element
        }
            # -- add content of current Level
        _add_namespaceContent $domNode $namespaceName
        
    }
    
    proc appUtil::_add_namespaceContent {domNode namespaceName} {
            
            set domDOC [$domNode ownerDocument]
            
                # -- child prodecures -------------
                #
            set procedureList   [_childProcedures $namespaceName]
            if {$procedureList != {}} {
               set _domNode   [$domNode appendChild [$domDOC createElement {____procedures}]]
               foreach _element $procedureList {
                    set _nodeName   [string map [list $namespaceName {} {::} {}] $_element]
                    set _nodeName   [check_nodeName $_nodeName]
                        # puts "   -> \$_nodeName: $_element -> $_nodeName"
                    set _node       [$domDOC createElement $_nodeName]
                    $_domNode appendChild $_node
                }
            } 
            
               
                # -- child arrays ---------------
                #
            set arrayList   [_childArrays $namespaceName]
            if {$arrayList != {}} {
                set _domNode   [$domNode appendChild [$domDOC createElement {____arrays}]]
                foreach _element $arrayList {
                    set _nodeName   [string map [list $namespaceName {} {::} {}] $_element]
                    set _nodeName   [check_nodeName $_nodeName]
                        # puts "   -> \$_nodeName: $_element -> $_nodeName"
                    set _node [$domDOC createElement $_nodeName]
                    $_domNode appendChild $_node
                        # -- array keyValues ---------------                   
                   _add_arraykeyValues $_node $_element
                }
            }

   
               # -- child vars -----------------
               #
           set varList   [_childVars $namespaceName]
           if {$varList != {}} {
               set _domNode   [$domNode appendChild [$domDOC createElement {____vars}]]
               foreach _element $varList {
                   set _nodeName   [string map [list $namespaceName {} {::} {}] $_element]
                   set _nodeName   [check_nodeName $_nodeName]
                       # puts "   -> \$_nodeName: $_element -> $_nodeName"
                   set _node [$domDOC createElement $_nodeName]
                   $_domNode appendChild $_node
                       # -- add value to node
                   _add_varValue $_node $_element
               }
           }   
    
    }
    
    proc appUtil::_add_arraykeyValues {domNode arrayName} {
            
            set domDOC [$domNode ownerDocument]
            
                # puts "      -> _add_arraykeyValues:  $domNode $arrayName"
            
            set arrayKeys [lsort [array names $arrayName]]
                # puts $arrayKeys
            foreach _key $arrayKeys {
                set _node [$domDOC createElement element]
                $domNode appendChild $_node
                $_node setAttribute name $_key
                # set value
                set cmdString [format "set _keyValue \$%s(%s)" $arrayName $_key]
                    # puts "   ... $cmdString"
                if {[catch {eval $cmdString} eID]} {
                    set _keyValue "<E> ERROR could not get Value: ... dont know why"
                    $_node appendChild [$domDOC createTextNode $_keyValue]
                } else {
                    $_node appendChild [$domDOC createTextNode $_keyValue]
                }
            }
    }
    
    proc appUtil::_add_varValue {domNode varName} {
            
            set domDOC [$domNode ownerDocument]

                # puts "      -> _add_arraykeyValues:  $domNode $varName"
            
            set cmdString [format "set _varValue \$%s" $varName]
            if {[catch {eval $cmdString} eID]} {
                # puts "     -> array / not var: $::appUtil::config_var"
                set _varValue "<E> ERROR could not get Value: seems to be an array, but is not proper set as ARRAY"
            }
            $domNode appendChild [$domDOC createTextNode $_varValue]
    }

    proc appUtil::_childNamespaces {parent_namespace} {
        set namespaceList [namespace children $parent_namespace]
        foreach _namespace [lsort $namespaceList] {
            # puts "         -> namespace: $_namespace"
        }
        return [lsort $namespaceList]
    }
    
    proc appUtil::_childProcedures {parent_namespace} {
        set procedureList [info procs [format "%s::*" $parent_namespace]]
        foreach _procedure [lsort $procedureList] {
            # puts "         -> procedure: $_procedure"
        }
        return [lsort $procedureList]
    }

    proc appUtil::_childVars {parent_namespace} {
        set _varList    [info vars  [format "%s::*" $parent_namespace]]
        set varList   {}
        foreach _variable [lsort $_varList] {
            if {[array exists $_variable] == 0} {
                lappend varList $_variable
            }
        }
        foreach _variable [lsort $varList] {
            # puts "         -> variable: $_variable"
        }
    
        return [lsort $varList]
    }
    
    proc appUtil::_childArrays {parent_namespace} {
        set _varList    [info vars  [format "%s::*" $parent_namespace]]
        set arrayList   {}
        foreach _variable [lsort $_varList] {
            if {[array exists $_variable] == 1} {
                lappend arrayList $_variable
            }
        }
        foreach _variable [lsort $arrayList] {
            # puts "         -> variable: $_variable"
        }

        return [lsort $arrayList]
    }  
    
    proc check_nodeName {_name} {
        set newName [string map {{'} {_} {.} {_}} $_name]
        if {$newName == {}} {set newName {___empty___}}
        if {$_name != $newName} {
            puts "       -> check_nodeName: $_name / $newName"
        }
        return $newName
    }
    
    
    
        
    