#!/usr/bin/tclsh

proc ::tk::mac::OpenDocument {args} {
    # args will be a list of all the documents dropped on your app, 
    # or double-clicked
    #global rattleCAD
    foreach {file} $args {
		#$rattleCAD openFile $file 1
    }
}


if {[string first "-psn" [lindex $argv 0]] == 0} {
    set argv [lrange $argv 1 end]
}

cd [file join [file dirname [file dirname [file normalize [info script]]]] Scripts]
source ./rattleCAD.tcl
