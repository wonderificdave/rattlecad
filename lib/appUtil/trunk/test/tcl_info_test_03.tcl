#
# Aspect Support Class for TclOO
#
# http://wiki.tcl.tk/20308
#

package require TclOO

set APPL_ROOT_Dir [file dirname [file normalize [file dirname [lindex $argv0]]]]
puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"
lappend auto_path "$APPL_ROOT_Dir"

package require appUtil



oo::class create Aspect {
    superclass oo::class

    constructor {{script ""}} {
        variable AspectNameGen 1
        interp alias {} ::oo::define::aspect {} \
                {*}[namespace code {my DefineAspect}]
        set cls [next $script]
        interp alias {} ::oo::define::aspect {}
    }
    method DefineAspect args {
        set opts [dict merge {
            -name {}
            -condition 1 -before {} -after {}
            -variable ASPECT__result -trap {}
        } $args]
        if {[dict get $opts -trap] eq ""} {
            set script {
                if {[lindex [self target] 0] eq "::oo::object"} {
                    return [next {*}$args]
                }
                if {%1$s} {
                    %2$s
                    set %4$s [next {*}$args]
                    %3$s
                    return [set %4$s]
                } else {
                    return [next {*}$args]
                }
            }
        } else {
            set script {
                if {[lindex [self target] 0] eq "::oo::object"} {
                    return [next {*}$args]
                }
                if {%1$s} {
                    %2$s
                    catch {next {*}$args} %4$s %5$s
                    %3$s
                    return -options [set %5$s] [set %4$s]
                } else {
                    return [next {*}$args]
                }
            }
        }
        set script [format $script \
                [dict get $opts -condition] \
                [dict get $opts -before] \
                [dict get $opts -after] \
                [list [dict get $opts -variable]] \
                [list [dict get $opts -trap]]]
        set name [dict get $opts -name]
        if {$name eq ""} {
            variable AspectNameGen
            set name Aspect__[self]__[incr AspectNameGen]
        }
        oo::define [self] method $name args $script
        set filters [info class filters [self]]
        oo::define [self] filter [lappend filters $name]
        return $name
    }
    method attach {args} {
        foreach obj $args {
            # changed oo::define to oo::objdefine for TclOO version 0.6.1
            oo::objdefine $obj mixin [self]
        }
    }
}


# Log
#
# One of the simplest uses for aspects is adding logging:

package require log
Aspect create logger {
    aspect -before {
        log::log debug "Called [self]->[self target] $args"
    }
}

# Demonstrating it in use:
puts "  ... use"

oo::class create foo {
    method bar {a b c} {
        puts "  ... inside foo bar"
        puts "     ... [expr {$a + $b + $c}]"
    }
}
logger attach foo
foo create fooObj
fooObj bar 2 3 4                
    #   ? returns "9"
    #   ? logs "Called ::fooObj->bar 2 3 4"

Aspect create cache {
    aspect -before {
        my variable ValueCache
        set key [self target],$args
        if {[info exist ValueCache($key)]} {
            return $ValueCache($key)
        }
    } -variable result -after {
        set ValueCache($key) $result
    }
    method flushCache {} {
        my variable ValueCache
        unset ValueCache
        # Skip the caching
        return -level 2 ""
    }
}

# Then we'll demo it in service:

oo::object create demo
oo::objdefine demo {
    method compute {a b c} {
        after 3000 ;# Simulate deep thought
        return [expr {$a + $b * $c}]
    }
    method compute2 {a b c} {
        after 3000 ;# Simulate deep thought
        return [expr {$a * $b + $c}]
    }
}

cache attach demo

#puts [demo compute  1 2 3]      ;#? prints "7" after delay
#puts [demo compute2 4 5 6]      ;#? prints "26" after delay
#puts [demo compute  1 2 3]      ;#? prints "7" instantly
#puts [demo compute2 4 5 6]      ;#? prints "26" instantly
#puts [demo compute  4 5 6]      ;#? prints "34" after delay
#puts [demo compute  4 5 6]      ;#? prints "34" instantly
#puts [demo compute  1 2 3]      ;#? prints "7" instantly
#demo flushCache
#puts [demo compute  1 2 3]      ;#? prints "7" after delay

#

puts "... <?> [info object class Aspect]"
puts "... <?> [info object class foo]"
puts "... <?> [info object class demo]"



foreach childNS [namespace children [namespace current]] {
    puts "      ... $childNS"
    #recurseNS $childNS
}

# ==========================================

oo::class create foo_2 {
    constructor {args} { puts foo_2 }
}
oo::class create bar {
    constructor {args} { puts bar }
}
oo::class create foobar {
    superclass foo_2 bar
    constructor {args} { puts foobar }
}
oo::class create geek {
    constructor {args} { puts geek }
}
oo::class create mongrel {
    superclass foobar geek
        #
    variable var01
    variable var02
        #
    constructor {args} { 
        puts mongrel
        puts "[namespace current]"
    }
    method dothis_01 {} {}
    method dothis_02 {} {}
    method getNameSpace {} {
        set a 4
        return [namespace current]
    }
}

namespace eval myNS {
    variable var01
    variable var02
    variable var03
    proc proc_a {} {}
    proc proc_b {} {}
    proc proc_c {} {}
}



proc recurseNS {ns} {
    #
    puts "           ... $ns - [set ns]"
        # [info object isa class [set ns]]
    if {[info object isa object [set ns]]} {
            puts "               ... is an object" 
            reportObject  [set ns]            
        if {[info object isa class [set ns]]} {
            puts "               ... is a class" 
        }
    }
        #
    if {![catch {info vars  [format "%s::*" $ns]} eID]} {
        puts "               ... ns Vars:  [info vars  [format "%s::*" $ns]]"
    } else {
        puts "               ?... $eID"
    }
        #
    if {![catch {info procs  [format "%s::*" $ns]} eID]} {
        puts "               ... ns Procs: [info procs  [format "%s::*" $ns]]"
    } else {
        puts "               ?... $eID"
    }
        #
    foreach ns [namespace children $ns] {
        #puts "           ... $ns - [set ns]"
        recurseNS $ns
    }
}

proc reportObject {obj} {
    puts "                   -> object:    $obj"
    puts "                   -> namespace: [info object namespace $obj]"
    set classObject [info object class $obj]
    puts "                   -> className:  $classObject"
    foreach var [lsort [info class variables $classObject]] {
        puts "               ... class -> variable:    $var"
    }
    foreach var [lsort [info class methods   $classObject]] {
        puts "               ... class -> method:      $var"
    }
}

# ==========================================
set testObj_01 [mongrel new]
set testObj_02 [mongrel new]
set testObj_03 [mongrel new]
#
set redDict [dict create   obj {abj1 obj2} class {cls1 cls2 cls3} array {a1 a2} dict {d1 d2 d3 d4 d5} var {v1 v2 v3}]
#

puts "\n\n  ... start reporting\n"
foreach childNS [namespace children ::] {
    puts "\n      -> $childNS"
    recurseNS $childNS
}



appUtil::createExplorer



