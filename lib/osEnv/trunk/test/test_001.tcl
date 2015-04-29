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
  puts "[$registryNode asXML]"




puts " -- 02 ------------------"

  puts  $::tcl_platform(platform)
  foreach mimeType {.svg .ps .html .pdf} {
      set defaultApp {}
      set defaultApp [osEnv::get_mimeType_DefaultApp $mimeType]
      puts "         ... $mimeType -> $defaultApp"
  }
  
  foreach mimeType {.svg .ps .html .pdf} {
      set defaultApp {}
      set defaultApp [osEnv::find_mimeType_Application $mimeType]
      puts "         ... $mimeType -> $defaultApp"
      osEnv::register_mimeType $mimeType $defaultApp
  }

  foreach mimeType {.svg .ps .html .pdf} {
      set defaultApp {}
      set defaultApp [osEnv::get_mimeType_DefaultApp $mimeType]
      puts "         ... $mimeType -> $defaultApp"
  }


puts " -- 03 ------------------"

  set fileName    [file join $this_Dir _rattleCAD.init ]
  set fp [open $fileName r]
  set fileData [read $fp]
  close $fp
  puts $fileData
  
  
  set doc  [dom parse  $fileData]
  set root [$doc documentElement]
  set mimeNode [$root selectNodes /root/mime]
  set execNode [$root selectNodes /root/exec]
  
  puts [$mimeNode asXML]
  puts [$execNode asXML]
        
  foreach node [$mimeNode childNodes] {
      # puts "         [$node asXML]"
      set key    [$node getAttribute name]
      set value  [[$node firstChild] nodeValue]
      puts "   -> $key  $value"
      osEnv::register_mimeType $key $value
  }  
  
  foreach node [$execNode childNodes] {
      # puts "         [$node asXML]"
      set key    [$node getAttribute name]
      set value  [[$node firstChild] nodeValue]
      puts "   -> $key  $value"
      osEnv::register_Executable $key $value
  }  
  
    puts "[$registryNode asXML]"
# parray env

    # serach for 64bit Ghostscript
  # osEnv::_init_os_executable
  puts "\n\n -----------------\n"
  
  osEnv::_add_Executable gs
  
  return
  
  
  set ghostScript [osEnv::get_Executable gs]   
  puts "    -> \$ghostScript $ghostScript"
  if {$ghostScript == {}} {
        tk_messageBox -title "PDF Export" -message "Ghostscript Error:\n     ... could not initialize ghostScript installation" -icon warning
        return
  } 