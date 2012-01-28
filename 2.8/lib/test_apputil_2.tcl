  set APPL_ROOT_Dir      [file dirname [file normalize $::argv0] ]

  
  lappend auto_path "$APPL_ROOT_Dir"

  #package require Tk 
  package require AppUtil
  #package require Tclx

    # to avoid full namespace qualifying
  namespace import AppUtil::SetDebugLevel AppUtil::Debug
  
    # some things
  proc proc_debug { args } {
      Debug  p                               
      Debug  t  "1 [info level] "                   4
      Debug  t  "2 [info level [info level]] "      4
      Debug  t  "\n\nnix ztuan aussa $args"         4
  }

  proc proc_test_1 { args } {
      Debug  p  $args                                
      Debug  t  "level: [info level]"                1
      Debug  t  "proc:  [info level [info level]]"   2
      Debug  ar  ::tcl_platform                      
      proc_test_2 $args
  }

  proc proc_test_2 { args } {
      Debug  p                                 
      Debug  t  "level: [info level]"                1
      Debug  t  "proc:  [info level [info level]]"   2
      set    var1  "Value of var 1"
      set    var2  "Value of var 2"
      set    var3  "Value of var 3"
      Debug  v  var1                                 
      Debug  v  var2                                 1
      Debug  v  var3                                 3
      proc_test_3 $args
  }

  proc proc_test_3 { args } {
      Debug  p                                 
      Debug  t  "level: [info level]"                1
      Debug  t  "proc:  [info level [info level]]"   2
      proc_debug $args
  }

  set a "Value of a"
  set LVar [list 1 $a abc]

    #################################
    # Debug test begin

  #SetDebugLevel 9
  SetDebugLevel 3
  SetDebugLevel 4
  SetDebugLevel 5
  
  puts -nonewline "start\n" ; flush stdout 

 
  Debug t "$APPL_ROOT_Dir"  1
  Debug t "$APPL_ROOT_Dir"  5
  Debug t "$APPL_ROOT_Dir" 10
  

    # proc_debug "goa nix"
    # puts "\n"; flush stdout 
  
  proc_test_1 "lafamool" "weiter" "geht schua gemma"
  puts "\n"; flush stdout 
  
  
  Debug Var a 5
  Debug List LVar 
  Debug a tcl_platform
  Debug p "function / procedure"
  Debug t "Itzat samma fiati!"
  
 
  package require Tk
  AppUtil::debug_create "neues Debug Fenster"

