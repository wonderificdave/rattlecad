
  package require starkit
  starkit::startup
  # package require app-rattle_cad

  switch -glob [file tail [file normalize $::argv0]] {
      rattleCAD*.kit {
              source [file join [file normalize $::argv0]   rattleCAD.tcl ]
            }
      rattleCAD*.exe -
      default {
              source [file join [file dirname [file normalize $::argv0] ]   rattleCAD.tcl ]
            }
  }