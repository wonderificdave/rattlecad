#!/bin/sh
# unifyKey.tcl \
exec tclsh "$0" ${1+"$@"}

set WINDOW_Title      "geometry: fruit"

  
set APPL_ROOT_Dir [file dirname [file dirname [lindex $argv0]]]
puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"
lappend auto_path "$APPL_ROOT_Dir"
lappend auto_path [file join $APPL_ROOT_Dir ..]
    
package require     bikeGeometry 0.8

foreach key [list  NAME(a/b)  NAME(a/b)  NAME(a/b/c)  NAME/a NAME/a/b/c  \
                   Lugs(RearDropOut/File)\
                   Lugs(RearDropOut/Direction@SELECT_DropOutDirection)] {
        puts ""
        puts "      -> $key"
          # set name_key [project::unifyKey $key] 
          # puts "         \$name_key  -> $name_key  "
          # continue
        foreach {arrayName keyName xPath} [project::unifyKey $key] break
        puts "            \$arrayName -> $arrayName"
        puts "            \$keyName   -> $keyName"
        puts "            \$xPath     -> $xPath"
    }



