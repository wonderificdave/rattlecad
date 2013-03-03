#!/bin/sh
# lib_dict.tcl \
exec tclsh "$0" ${1+"$@"}


    #-------------------------------------------------------------------------
        #
    proc appUtil::namespaceReport {{_namespace {}} {node {}}} {
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
        
        set namespaceList   [_childNamespaces $namespaceName]
        foreach _element $namespaceList {
            set _nodeName   [string map [list {::} {}] $_element]
            set _node [$domDOC createElement $_nodeName]
            $domNode appendChild $_node
                # -- loop through the next level
            _add_namespaceReport $_node $_element
        }
        
        
        set procedureList   [_childProcedures $namespaceName]
        if {$procedureList != {}} {
           set _domNode   [$domNode appendChild [$domDOC createElement {procedure}]]
           foreach _element $procedureList {
                set _nodeName   [string map [list $namespaceName {} {::} {}] $_element]
                set _node       [$domDOC createElement $_nodeName]
                $_domNode appendChild $_node
            }
        }
 
 
        set arrayList   [_childVars $namespaceName]
        if {$arrayList != {}} {
            set _domNode   [$domNode appendChild [$domDOC createElement {array}]]
            foreach _element $arrayList {
                set _nodeName   [string map [list $namespaceName {} {::} {}] $_element]
                set _node [$domDOC createElement $_nodeName]
                $_domNode appendChild $_node
                    # -- add value/key to node
                set keyValueList [_childArrayKeys $_element]
                    # puts "\n   ->  keyValueList"
                foreach {key value} $keyValueList {
                        # puts "    -> $key $value"
                    set __node [$domDOC createElement element]
                    $_node appendChild $__node
                    $__node setAttribute name $key
                    $__node appendChild [$domDOC createTextNode $value]
                }
                puts "   ->  keyValueList\n"
            }
        }
         
        
        set varList   [_childVars $namespaceName]
        if {$varList != {}} {
           set _domNode   [$domNode appendChild [$domDOC createElement {var}]]
           foreach _element $varList {
                set _nodeName   [string map [list $namespaceName {} {::} {}] $_element]
                set _node [$domDOC createElement $_nodeName]
                $_domNode appendChild $_node
                set cmdString [format "set value \$%s" $_element]
                puts "   ... $cmdString"
                if {[catch {eval $cmdString} eID]} {
                    set value "ERROR: maybe not declared correct and is an ARRAY "
                }
                $_node appendChild [$domDOC createTextNode $value]
            }
        }
        
    }

    
    

    proc appUtil::_childNamespaces {parent_namespace} {
        set namespaceList [namespace children $parent_namespace]
        foreach _namespace [lsort $namespaceList] {
            puts "         -> namespace: $_namespace"
        }
        return [lsort $namespaceList]
    }
    
    proc appUtil::_childProcedures {parent_namespace} {
        set procedureList [info procs [format "%s::*" $parent_namespace]]
        foreach _procedure [lsort $procedureList] {
            puts "         -> procedure: $_procedure"
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
            puts "         -> variable: $_variable"
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
            puts "         -> variable: $_variable"
        }

        return [lsort $arrayList]
    }
    
    proc appUtil::_childArrayKeys {arrayName} {
            # puts "        -> appUtil::_childArrayKeys $arrayName"
        set keyList     [array names $arrayName]
            # puts "           -> $keyList"
        set keyValueList {}
        foreach _key [lsort $keyList] {
                # puts "   $arrayName / $_key"
            set cmdString [format "set _keyValue \$%s(%s)" $arrayName $_key]
                # puts "   ... $cmdString"
            eval $cmdString
                # puts "         -> $_key $_keyValue"
                # puts "         -> variable: $arrayName($_key) -> $_keyValue"
            lappend keyValueList [list $_key $_keyValue]
        }
        return $keyValueList
    }
    
    
    
    
    
        
    