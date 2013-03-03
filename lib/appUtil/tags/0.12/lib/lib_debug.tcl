
  variable appUtil::DebugLevel     0
  variable appUtil::widget_id      .d_e_b_u_g
  variable appUtil::debug_text     {}
  variable appUtil::font           "-*-Courier-Medium-R-Normal--*-140-*-*-*-*-*-*"
  variable appUtil::window_title   "appUtil::Debug"
         
  #-------------------------------------------------------------------------
      #  out 
      #
  proc appUtil::debug_out { str } { 
      variable DebugLevel
      if {!$DebugLevel} return
      puts -nonewline $str ; flush stdout 
      debug_print $str
  }

  
  #-------------------------------------------------------------------------
       #  SetDebugLevel 
       #
  proc appUtil::SetDebugLevel { lvl } { 
      variable DebugLevel $lvl
        set str  "\n   SetDebugLevel  $lvl \n"
        puts $str ; flush stdout 
        debug_print $str
  }

  
  #-------------------------------------------------------------------------
       #  appDebug 
       #
  proc appUtil::appDebug { mode args } {
        # debug_out "        DEBUG 0: appDebug '$mode' '$var' '$args'\n"
        # debug_out "          [info level 1]\n"
      variable DebugLevel

        # -- default debug value
      set lvl 0

        # -- type of debugging
      set lmode [string index [string tolower $mode] 0]
      
        # -- rest of args
        # -- variable to analyze
      if {[llength $args]} {
          set dvar [lindex $args 0]
      } else {      
          set dvar "no_value"
      }
        
        # -- rest of argument list
      if {[llength $args] > 1} {
          set last [lindex $args end]
          if {[string is integer $last]} { 
              set lvl $last 
              set alst [lrange $args 1 end-1]
          }
      } else {
          set alst [lrange $args 1 end]
      }
      
      
        # -- if DebugLevel is less then  
        #       depth of proc-call       -> return
      set return_proclevel  [expr [info level]-1]
      if {$return_proclevel>$DebugLevel} return
      
        # -- if DebugLevel is less then
        #       relative level of debug  -> return
      set return_dbg_level [expr $lvl + $return_proclevel]
      if {$return_dbg_level>$DebugLevel} return
            
           # debug_out     "        init appDebug:   return_proclevel  $return_proclevel \n" 
           # debug_out     "        init appDebug:   lvl  $lvl \n" 
           # debug_out     "        init appDebug:   return_dbg_level  $return_dbg_level \n" 
           # debug_out     "        init appDebug:   DebugLevel  $DebugLevel \n" 
      
        # ---------------------------------
        
        #    STILL IN PROGRESS
      
        # ---------------------------------
        
        
      if {[lsearch {v l a f} $lmode]<0} {
	  if {[llength $alst]} {
              foreach s $alst {append dvar "\n" $s}
              set dvar $alst
          } else { 
              set dvar [list $dvar]
          }
      } else {
          if {[llength $alst]} {
              foreach s $alst { lappend dvar $s }
          }
      } 


        # debug_out "XXXXX1: alst=$alst\n"
        # debug_out "XXXXX2: llength '$alst'=[llength $alst]\n"
        # debug_out "XXXXX3: lmode=$lmode, dvar='$dvar'\n"
    
      set fmt_lvl [format "%2d" $lvl]

      foreach lvar $dvar {
            # debug_out "XXXXX4: lvar=$lvar\n"
          switch -glob -- $lmode {
                       
                v { #(v)ariable ----
                       upvar $lvar loc
                       if {![info exists loc]} {
                           debug_out "    VARIA:  $fmt_lvl>  $lvar=*not set*\n" ; continue
                       }
                       debug_out     "    VARIA:  $fmt_lvl>  $lvar=|$loc|\n" 
                   }
	           
                l { #(l)ist -------- 
                       upvar $lvar lst
                         # debug_out "XXXXXX: $lvar=$lst\n"
                       if {![info exists lst]} {
                           debug_out "    VLIST:  $fmt_lvl>  $lvar=*not set*\n" ; continue
                       }
                       if {![llength $lst]} {
                           debug_out "    VLIST:  $fmt_lvl>  $lvar=*empty*\n" ; continue
                       }
                       set i -1
                       foreach lval $lst {
                           debug_out "    VLIST:  $fmt_lvl>  $lvar [incr i]=|$lval|\n"
                       }
                   }
                   
                a { #(a)rray ------- 
                       upvar $lvar arr
                       if {![info exists arr]} {
                           debug_out "    ARRAY:  $fmt_lvl>  $lvar=*not set*\n" ; continue
                       } 
                       if {![array exists arr]} {
                           debug_out "    ARRAY:  $fmt_lvl>  $lvar=*not set*\n" ; continue
                       }
                       foreach nam [lsort [array names arr]] {
                           debug_out "    ARRAY:  $fmt_lvl>  $lvar\($nam\) =|$arr($nam)|\n"
                       }
                   }
                   
                p -
                f { #(f)unction -- (p)rocedure --
                       set parent_level  [expr [info level]-1]
                       set fmt_parent_lvl [format "%2d" $parent_level]
                          
                       if {$parent_level != 0 } {
                           set proc_info [info level [expr [info level]-1] ]
                           set proc_name [lindex $proc_info 0 ]
                           if {[llength $proc_info] > 1} {
                               set proc_args [lreplace $proc_info 0 1 [lindex $proc_info 1] ]
                           } else {
                               set proc_args "<no arguments|"
                           }
                           debug_out "PROCALL: $fmt_parent_lvl $proc_name :>  $proc_args\n" ; continue
                       } else {
                           debug_out "PROCALL:  [file tail $::argv0] :>  $::argv\n" ; continue
                       }
                   }
                   
                t -
                default { #default - (t)ext -------
                       debug_out     "  DEBUG:    $fmt_lvl>  $lvar\n" ; continue
                   }
          }
      }
  }
      

  #-------------------------------------------------------------------------
       #  proc callingHierarchy
       #
proc appUtil::get_procHierarchy {} {
    set infoLevel       [info level]
    set indentString    ""
         
    incr infoLevel -1    ;# remove get_procHierarchy from stack
    if {$infoLevel > 0} {
        set calledBy [lindex [info level $infoLevel] 0]
        puts       "\n      <appUtil>  -- $calledBy ------------------------"
    }
    set parentLevel 1
    while {$parentLevel <= $infoLevel} {
            set calledBy [info level $parentLevel]
        puts [format "      <appUtil>   %s -> (%s) %s" $indentString $parentLevel $calledBy]
        incr parentLevel 1
        append indentString "  "
    }
    puts ""
}

  #-------------------------------------------------------------------------
      #  check tk loaded
      #
  proc check_loaded_Tk {} {
       foreach value [ info loaded ] {
             # appDebug t 
             # appDebug t "[lindex $value 1] " 1
             # appDebug t 
           if {[lindex $value 1] == {Tk} } { return 1 }
       }
       return 0
  }


  #-------------------------------------------------------------------------
      #  create text output
      #
  proc appUtil::debug_create {{title {}}} {
      variable DebugLevel 
      variable widget_id 
      variable debug_text
      variable font
      variable window_title
      
        # puts "[check_loaded_Tk]"; flush stdout
      if {[check_loaded_Tk] == 0} {return 0}
        # puts "weiter gehts [check_loaded_Tk]"; flush stdout
      if {[winfo exists $widget_id]} {
          return
      }
      
      package require BWidget
      
      
      
        ;# -- window title
      if { $title != {} } {
          set window_title $title
      }
      
      
        ;# -- Menu description
      set descmenu {
          "&File" all file 0 {
              {command "&Clear ..."    {} "Clear Debug-Text"         {Ctrl c} -command {appUtil::debug_clear} }
              {command "&Save As ..."  {} "Save Debug-Text to File"  {Ctrl s} -command {tk_getSaveFile -initialdir ~} }
              {separator}
              {command "Reset &Font"   {} "Save Debug-Text to File"  {Ctrl s} -command {appUtil::update_font $appUtil::font_0} }
              {separator}
              {command "E&xit"         {} "Exit Debug-Window"        {Ctrl x} -command {appUtil::debug_destroy} }
          }
      }
      
      
        ;# -- create window
      toplevel  $widget_id  -width 300  -height 250
      wm title  $widget_id  $window_title

        ;# -- MainFrame
      set mainframe  [MainFrame $widget_id.mf \
                         -menu         $descmenu \
                         -textvariable CURRENT_Command \
                         -width 300  \
                         -height 250
                     ]
      

        ;# -- toolbar 1 creation
      set tb1  [$mainframe addtoolbar]
      
        ;# -- toolbar 1 bbox_1
      set   bbox   [ButtonBox  $tb1.bbox_1  -spacing 0  -padx 1  -pady 1  -homogeneous 0 ]
           $bbox   add  -image [Bitmap::get new] \
                        -highlightthickness 0  -takefocus 0  -relief link  -borderwidth 1  -padx 1  -pady 1 \
                        -helptext "Clear ..." \
                        -command { appUtil::debug_clear }
           $bbox   add  -image [Bitmap::get save] \
                        -highlightthickness 0  -takefocus 0  -relief link  -borderwidth 1  -padx 1  -pady 1 \
                        -helptext "Save As ..." \
                        -command { tk_getSaveFile -initialdir ~ }

      pack $bbox        -side left -anchor w

      set   sep1   [Separator $tb1.sep1 -orient vertical]
      pack $sep1        -side left -fill y -padx 4 -anchor w
      
        ;# -- toolbar 1 bbox_2
      set   bbox   [ButtonBox  $tb1.bbox_2  -spacing 0  -padx 1  -pady 1  -homogeneous 0 ]
           $bbox   add  -text "Exit" \
                        -highlightthickness 0  -takefocus 0  -relief link  -borderwidth 1  -padx 1  -pady 1 \
                        -width 6 \
                        -helptext "Close Debug-Window..." \
                        -command { appUtil::debug_destroy }

      pack $bbox        -side left  -anchor w

      set   sep2   [Separator $tb1.sep2 -orient vertical]
      pack $sep2        -side left  -fill y  -padx 4  -anchor w
      
        ;# -- toolbar 1 debug-level
      set   _wdbgd [label     $tb1.debuglevel_t \
                        -text      "Debug Level: "]
      set   _wdbgl [SpinBox   $tb1.debuglevel \
                        -width        4 \
                        -range        {0 50 1} \
                        -textvariable "appUtil::DebugLevel" \
                        -modifycmd    "appUtil::SetDebugLevel \[$tb1.debuglevel getvalue\]" ]
      
      pack $_wdbgd \
           $_wdbgl      -side left  -anchor w
           
      set   sep3   [Separator $tb1.sep3 -orient vertical]
      pack $sep3        -side left  -fill y  -padx 4  -anchor w    


        ;# -- toolbar 1 font selection
      set   _wfont [SelectFont $tb1.font -type toolbar \
                        -command "appUtil::update_font \[$tb1.font cget -font\]"]
      pack $_wfont      -side left  -anchor w

           $_wfont      configure -font $appUtil::font
          

        ;# -- addinidicator
      $mainframe addindicator  -text         "appUtil::DebugLevel"
      $mainframe addindicator  -textvariable  appUtil::DebugLevel


        ;# -- text creation
      set  frame      [ $mainframe getframe] 

      pack [set sw    [ ScrolledWindow $frame.sw] ] -fill both  -expand 1 

      set debug_text  [ text $frame.sw.text -relief sunken \
                              -wrap none \
                              -background white \
                              -font -*-Courier-Medium-R-Normal--*-140-*-*-*-*-*-*
                      ]
      
      ### !!! IMPORTANT !!! DO NOT pack a ScrolledWindow child!!!     
      $sw setwidget $frame.sw.text
      
         # tk_messageBox -message "  font $font"

      pack $mainframe -fill both -expand yes


  }
  
  
  #-------------------------------------------------------------------------
      #  destroy debug window
      #
  proc appUtil::debug_destroy { } {
      variable widget_id 
      if {[check_loaded_Tk] == 0} return 
      if {[winfo exists $widget_id]} {
          catch [destroy $widget_id]
      }
  }
  
  
  #-------------------------------------------------------------------------
      #  update font
      #
  proc appUtil::update_font {font} {
      variable debug_text
      if {[check_loaded_Tk] == 0} return 
      if {[winfo exists $debug_text]} {
          $debug_text configure  -font "$font"
      }
  }
  
  
  #-------------------------------------------------------------------------
      #  print text
      #
  proc appUtil::debug_print { text } {
      variable debug_text
      if {[check_loaded_Tk] == 0} return 
      if {[winfo exists $debug_text]} {
          $debug_text  insert end "$text"
          $debug_text  yview moveto  1.0
      }
  }


  #-------------------------------------------------------------------------
      #  clear text
      #
  proc appUtil::debug_clear { } {
      variable debug_text
      if {[check_loaded_Tk] == 0} return 
      if {[winfo exists $debug_text]} {
          $debug_text  yview  moveto  0.0
          $debug_text  delete @0,0 end
      }
  }



