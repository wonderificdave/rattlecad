#!/bin/sh
# fruit.tcl \
exec tclsh "$0" ${1+"$@"}

oo::class create geometry::fruit {
    method eat {} {
	puts "yummy!\n------------"
    }
}


oo::class create geometry::apple {
    superclass geometry::fruit
    constructor {} {
	my variable peeled
	set peeled 0
    }
    method peel {} {
	my variable peeled
	set peeled 1
	puts "skin now off"
    }
    method edible? {} {
	my variable peeled
	return $peeled
    }
    method eat {} {
	if {![my edible?]} {
	    my peel
	}
	next
   }
}
       
       
oo::class create geometry::banana {
    superclass geometry::fruit
    constructor {} {
	my variable peeled
	set peeled 0
    }
    method peel {} {
	my variable peeled
	set peeled 1
	puts "skin now off"
    }
    method edible? {} {
	my variable peeled
	return $peeled
    }
    method eat_ {} {
	if {![my edible?]} {
	    my peel
	}
	next
   }
}         


oo::class create geometry::citrus {
    superclass geometry::fruit
    constructor {} {
	my variable peeled
	set peeled 0
    }
    method peel {} {
	my variable peeled
	set peeled 1
	puts "citrus skin now off"
    }
    method edible? {} {
	my variable peeled
	return $peeled
    }
    method eat {} {
	if {![my edible?]} {
	    my peel
	}
	next
   }
}  