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


#



puts "   .. [catch {info class variables ::oo::Obj15}]"
puts "   .. [catch {info object class ::oo::Obj15}]"
puts "   .. [catch {info vars  ::oo::Obj1}]"
puts "   .. [catch {info vars  ::oo::Obj2}]"
puts "   .. [catch {info vars  ::oo::Obj3}]"
puts "   .. [catch {info vars  ::oo::Obj4}]"
puts "   .. [catch {info vars  ::oo::Obj5}]"
puts "   .. [catch {info vars  ::oo::Obj6}]"
puts "   .. [catch {info vars  ::oo::Obj7}]"
puts "   .. [catch {info vars  ::oo::Obj8}]"
puts "   .. [catch {info vars  ::oo::Obj9}]"
puts "   .. [catch {info vars  ::oo::Obj10}]"


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
    constructor {args} { 
        puts mongrel
        puts "[namespace current]"
    }
    method dothis_01 {} {}
    method dothis_02 {} {}
    method getNameSpace {} {
        return [namespace current]
    }
}



proc recurseNS {ns} {
    foreach childNS [namespace children $ns] {
        puts "\n       ... childNS: $childNS"
        #puts "             ... [catch {info class  methods     $childNS}]"
        #puts "             ... [catch {info class  constructor $childNS}]"
        #puts "             ... [catch {info class  constructor $childNS}]"
        #puts "             ... [catch {info object class       $childNS}]"
        if {[info object isa object [set childNS]]} {
            puts "          ... is an object"            
            if {[info object isa class [set childNS]]} {
            puts "          ... is a class" 
            }
        }
        #
        recurseNS $childNS
    }
}




# ==========================================
set testObj [mongrel new]
#
puts "\n\n  ... start reporting\n"
foreach childNS [namespace children [namespace current]] {
    puts "      ... $childNS"
    recurseNS $childNS
}


exit

puts "[catch {info class  methods     ::oo::InfoClass}]"
puts "[catch {info class  instances   foo}]"
puts "[catch {info class  methods     ::oo::InfoClass}]"
puts "[catch {info class  methods     ::oo::InfoClass}]"
puts "[catch {info class  methods     ::oo::InfoClass}]"


puts " -- Class --"
puts "      methods:  [catch {info class  methods    mongrel}]"
puts "      methods:  [info class   methods     mongrel]"
puts " -- Object --"
puts "      methods:  [info object  methods     $testObj]"
puts "      class:    [info object  class       $testObj]"


puts " -- Object -- \$testObj $testObj "
set className [info object  class       $testObj]
puts "           $className "
puts "           [info class   methods     $className]"
puts "           [$testObj getNameSpace]"

puts "\n  --- \n"

puts "  "


puts " [info vars ::*]"

puts "\n  --- \n"
foreach varName [info vars ::*] {
    puts "    -> $varName"
    if {![catch {info object  class  $varName} eID]} {
        puts "           <I> [info class   methods     $varName]" 
    } else {
        puts "           <E> $eID\n"
    }
}

puts "\n  --- \n"
foreach varName $testObj {
    puts "    -> $varName"
    if {![catch {info object  class  $varName} eID]} {
        puts "           <I> [info object  class     $varName]" 
    } else {
        puts "           <E> $eID\n"
    }
}