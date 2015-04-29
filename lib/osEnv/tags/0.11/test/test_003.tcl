#!/bin/sh
# test_anyNew.tcl \
exec tclsh "$0" ${1+"$@"}


set this_Dir      [file dirname [file normalize [lindex $argv0]]]
set APPL_ROOT_Dir [file dirname [file dirname $this_Dir]]
# set APPL_ROOT_Dir [file dirname [lindex $argv0]]
puts "   \$this_Dir ........ $this_Dir"
puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"
lappend auto_path "$APPL_ROOT_Dir"


package require osEnv
package require appUtil


  puts " -- 01 ------------------"

  set registryNode [osEnv::init_osEnv]
      # exit
      # puts "[$registryNode asXML]"

  
  
  puts "\n\n -----------------\n"
  
  set exec [osEnv::get_Executable gs]
  puts "   ... $exec"



  puts "\n\n -----------------\n"
 
  set exec32 [osEnv::find_ghostscriptExec 32]
  puts "   ... $exec32"
  puts "\n ---------------\n\n"
  set exec64 [osEnv::find_ghostscriptExec 64]
  puts "   ... $exec64"
  puts "\n ---------------\n\n"
  set exec64 [osEnv::find_ghostscriptExec]
  puts "   ... $exec64"
  
