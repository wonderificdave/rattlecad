#!/bin/sh
# lib_dict.tcl \
exec tclsh "$0" ${1+"$@"}


    #-------------------------------------------------------------------------
        #
    proc appUtil::get_dictValue {_dict _dictPath} {
            set value "___undefined___"
                # puts "   ->  $_dictPath"
            set dictPath [string map {"/" " "} $_dictPath]
                # puts "   ->  $dictPath"
            catch {set value [dict get $_dict {*}$dictPath]}
                # puts "   -> $value"
            return $value
    } 
 


    #-------------------------------------------------------------------------
        # see  http://wiki.tcl.tk/23526
        #
    proc appUtil::pdict { d {i 0} {p "  "} {s " -> "} } {
          set errorInfo $::errorInfo
          set errorCode $::errorCode
              set fRepExist [expr {0 < [llength\
                      [info commands tcl::unsupported::representation]]}]
          while 1 {
              if { [catch {dict keys $d}] } {
                  if {! [info exists dName] && [uplevel 1 [list info exists $d]]} {
                      set dName $d
                      unset d
                      upvar 1 $dName d
                      continue
                  }
                  return -code error  "error: pdict - argument is not a dict"
              }
              break
          }
          if {[info exists dName]} {
              puts "dict $dName"
          }
          set prefix [string repeat $p $i]
          set max 0
          foreach key [dict keys $d] {
              if { [string length $key] > $max } {
                  set max [string length $key]
              }
          }
          dict for {key val} ${d} {
              puts -nonewline "${prefix}[format "%-${max}s" $key]$s"
              if {    $fRepExist && ! [string match "value is a dict*"\
                          [tcl::unsupported::representation $val]]
                      || ! $fRepExist && [catch {dict keys $val}] } {
                  puts "'${val}'"
              } else {
                  puts ""
                  pdict $val [expr {$i+1}] $p $s
              }
          }
          set ::errorInfo $errorInfo
          set ::errorCode $errorCode
          return ""
    }
    

