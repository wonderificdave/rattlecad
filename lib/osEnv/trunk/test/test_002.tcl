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

  puts "\n"
  puts [$osEnv::registryDOM asXML]
  puts "\n"
  
  puts " -- 02 -- get_mimeType_DefaultApp -------------"

  puts "              ->  $::tcl_platform(platform)"
  foreach mimeType {.svg .ps .html .pdf} {
      set defaultApp {}
      set defaultApp [osEnv::get_mimeType_DefaultApp $mimeType]
      puts "         ... $mimeType -> $defaultApp"
  }
  
  puts " -- 02 -- find_mimeType_Application -------------"

  foreach mimeType {.svg .ps .html .pdf} {
      set defaultApp {}
      set defaultApp [osEnv::find_mimeType_Application $mimeType]
        # puts "         ... $mimeType -> $defaultApp"
      osEnv::register_mimeType $mimeType $defaultApp
  }

  puts " -- 02 -- get_mimeType_DefaultApp -------------"

  foreach mimeType {.svg .ps .html .pdf} {
      set defaultApp {}
      set defaultApp [osEnv::get_mimeType_DefaultApp $mimeType]
      puts "         ... $mimeType -> $defaultApp"
  }
  
  
  
  puts "\n\n -----------------\n"
  
  osEnv::get_Executable gs