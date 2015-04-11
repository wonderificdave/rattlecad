#
# Aspect Support Class for TclOO
#
# http://wiki.tcl.tk/20308
#

package require TclOO

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

