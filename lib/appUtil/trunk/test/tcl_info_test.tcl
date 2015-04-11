#
# http://wiki.tcl.tk/18152
#

package require TclOO

oo::class create cache {
    filter Memoize
    method Memoize args {
        # Do not filter the core method implementations
        if {[lindex [self target] 0] eq "::oo::object"} {
            return [next {*}$args]
        }

        # Check if the value is already in the cache
        my variable ValueCache
        set key [self target],$args
        if {[info exist ValueCache($key)]} {
            return $ValueCache($key)
        }

        # Compute value, insert into cache, and return it
        return [set ValueCache($key) [next {*}$args]]
    }
    method flushCache {} {
        my variable ValueCache
        unset ValueCache
        # Skip the cacheing
        return -level 2 ""
    }
}

set demo [cache new]


#exit


oo::objectdefine $demo {
    mixin cache
    method compute {a b c} {
        after 3000 ;# Simulate deep thought
        return [expr {$a + $b * $c}]
    }
    method compute2 {a b c} {
        after 3000 ;# Simulate deep thought
        return [expr {$a * $b + $c}]
    }
}

puts [demo compute  1 2 3]      ? prints "7" after delay
puts [demo compute2 4 5 6]      ? prints "26" after delay
puts [demo compute  1 2 3]      ? prints "7" instantly
puts [demo compute2 4 5 6]      ? prints "26" instantly
puts [demo compute  4 5 6]      ? prints "34" after delay
puts [demo compute  4 5 6]      ? prints "34" instantly
puts [demo compute  1 2 3]      ? prints "7" instantly
demo flushCache
puts [demo compute  1 2 3]      ? prints "7" after delay