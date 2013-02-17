#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

  set Version __versionKey__
  
  variable debugWrite 
  variable fp
  
  set debugWrite {write}
  set debugWrite {}
  
  if {$debugWrite ne {}} {
        variable fp
        set outfile [file join [file dirname [file normalize $argv0]] logFile.txt]
        set fp [open $outfile w]
  }
  
  proc debugOut {message} {
        variable debugWrite
        variable fp
        puts "$message"
        if {$debugWrite ne {}} {
            puts $fp  "$message"
        }
  }
  debugOut " ... start rattleCAD $Version"
  debugOut "  script: [file normalize $argv0]"
  debugOut "  file:   [file normalize [lindex $argv 0]]"
  debugOut "     [pwd]"
        
  if {$argc == 1} {
        set projectFile [file normalize [lindex $argv 0]]
                debugOut "     [pwd]"
        cd $Version
                debugOut "     [pwd]"
                debugOut "     ./rattleCAD.tcl $projectFile"
        eval exec tclsh  ./rattleCAD.tcl $projectFile
  } else {
                debugOut "     [pwd]"
        cd $Version    
                debugOut "     [pwd]"
                debugOut "     ./rattleCAD.tcl"
        eval exec tclsh  ./rattleCAD.tcl
  }
  
  if {$debugWrite ne {}} {
        variable fp
        close $fp
  }

  exit
