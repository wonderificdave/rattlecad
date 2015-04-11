#!/bin/sh
# test_anyNew.tcl \
exec tclsh "$0" ${1+"$@"}

puts " -- 01 ------------------"
puts "[info frame 1]"

puts " -- 03 ------------------"
puts "[info procs *]"

puts " -- 03 ------------------"
puts "[namespace children]"

puts " -- 04 ------------------"
puts "[info procs ::tcl::*]"

    # ::tcl::CopyDirectory 
    # ::tcl::EnvTraceProc 
    # ::tcl::InitWinEnv
    
puts " -- 05 ------------------"
puts "[info functions]"   

puts " -- 06 ------------------"
puts "[info library]"    

puts " -- 07 ------------------"
puts "[info loaded]"    

puts " -- 08 ------------------"
puts "[info args ::tcl::CopyDirectory]"    



