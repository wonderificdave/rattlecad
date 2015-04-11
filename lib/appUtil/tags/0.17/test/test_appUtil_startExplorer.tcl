#!/bin/sh
# test_appUtil.tcl \
exec tclsh "$0" ${1+"$@"}

set APPL_ROOT_Dir [file dirname [file normalize [file dirname [lindex $argv0]]]]
puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"
lappend auto_path "$APPL_ROOT_Dir"

package require appUtil


proc proc_01 {a b c d args} {
    puts "      ... \$appUtil::DebugLevel $appUtil::DebugLevel"
    appUtil::appDebug p
    puts "   [info level] $a $b $c $d  -> $args "
    proc_02 $a $b $c
}

proc proc_02 {a b c} {
    appUtil::appDebug p
    puts "   [info level] $a $b $c"
    proc_03 $a $b $c World Live Aid
}

proc proc_03 {a b c d args} {
    appUtil::appDebug p
    puts "   [info level] $a $b $c $d  -> $args "  
    
    appUtil::get_procHierarchy
    # getCallingList
}


proc getCallingList {} {

      # thanks to: https://groups.google.com/forum/?fromgroups=#!topic/comp.lang.tcl/qDvLZfbOp_4
    if {[info level] <= 1} {
        set calledBy "global"
    } else {
        set calledBy [lindex [info level -1] 0]
    }
    set infoLevel [info level]
    puts "        ... called by: $infoLevel $calledBy" 
    
    puts "... -> [info level  2]"
    puts "... -> [info level  1]"
    puts "... -> [info level  0]"
    puts "... -> [info level -1]"
    puts "... -> [info level -2]"
                
    incr infoLevel -1
    while {$infoLevel >= 0} {
        set calledBy [info level $infoLevel]
        puts "  <appUtil> ... called by: $infoLevel $calledBy"
        incr infoLevel -1
    }
}



puts " --- 0 -------------------------------"
appUtil::SetDebugLevel 0
proc_01 We are the Champions QUEEN 


puts " --- 3 -------------------------------"
appUtil::SetDebugLevel 3
proc_01 We are the Champions QUEEN 


puts " --- 1 -------------------------------"
appUtil::SetDebugLevel 1
proc_01 We are the Champions QUEEN 


appUtil::createExplorer
