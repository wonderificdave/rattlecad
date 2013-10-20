#!/bin/sh
# test_anyNew.tcl \
exec tclsh "$0" ${1+"$@"}

set APPL_ROOT_Dir [file dirname [file dirname [lindex $argv0]]]
puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"
lappend auto_path "$APPL_ROOT_Dir"

package require osEnv
package require appUtil


puts " -- 01 ------------------"

set registryNode [osEnv::get_osEnv]
    # exit
puts "[$registryNode asXML]"


puts " -- 02 ------------------"
puts  $::tcl_platform(platform)

# parray env
