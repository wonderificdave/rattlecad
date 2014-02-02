#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

  set Version __versionKey__
  
  variable outFile      [file join [file dirname [file normalize $argv0]] logFile.txt]
  variable debugWrite 
  variable fp
  
  set debugWrite {write}
  # set debugWrite {}
  
  if {$debugWrite ne {}} {
	variable outFile
	variable fp
	set fp [open $outFile w]
  }
  
  proc debugOut {message} {
	variable debugWrite
	variable fp
	puts "$message"
	if {$debugWrite ne {}} {
	    puts $fp  "$message"
	}
  }
  debugOut "\n"
  debugOut " ... start rattleCAD $Version\n"
  debugOut "     ... logging: $outFile\n"
 
  if {$argc > 0} {
		  debugOut "     [pwd]"
      # cd $Version
      # debugOut "     [pwd]"
      debugOut ""
      debugOut "     [format "./rattleCAD_%s.kit" $Version] $argv"
      eval exec tclsh  [format "./rattleCAD_%s.kit" $Version] $argv
  } else {
		  debugOut "     [pwd]"
	    # cd $Version    
		  # debugOut "     [pwd]"
		  debugOut ""
		  debugOut "     [format "./rattleCAD_%s.kit" $Version]"
	    eval exec tclsh  [format "./rattleCAD_%s.kit" $Version]
  }
  
  
  if {$debugWrite ne {}} {
	variable fp
	close $fp
  }

  exit  