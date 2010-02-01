
  package require starkit
  starkit::startup
  # package require app-rattle_cad

  source [file join [file dirname [file normalize $::argv0] ]   rattle_cad.tcl ]