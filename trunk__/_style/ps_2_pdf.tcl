#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"


 ##+##########################################################################
 #
 # ps_2_pdf.tcl
 #
 #   rattleCAD is software of Manfred ROSENBERGER
 #       based on tclTk and BWidgets and their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2010/10/24
 #
 # The author  hereby grant permission to use,  copy, modify, distribute,
 # and  license this  software  and its  documentation  for any  purpose,
 # provided that  existing copyright notices  are retained in  all copies
 # and that  this notice  is included verbatim  in any  distributions. No
 # written agreement, license, or royalty  fee is required for any of the
 # authorized uses.  Modifications to this software may be copyrighted by
 # their authors and need not  follow the licensing terms described here,
 # provided that the new terms are clearly indicated on the first page of
 # each file where they apply.
 #
 # IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
 # FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
 # ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
 # DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
 # POSSIBILITY OF SUCH DAMAGE.
 #
 # THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
 # INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
 # MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
 # NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN "AS  IS" BASIS,
 # AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
 # MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 #
 
 # http://wiki.tcl.tk/4290  Generating PDF on Windows
 # http://wiki.tcl.tk/2375  PDF
 
  package require registry 1.1
  
  set ghostScript   "D:/Programme/gs/gs9.06/bin/gswin32c.exe"
  set ghostScript   "gswin32c.exe"
  set ps_Dir        "E:/manfred/Dateien/TMP/2013.02/rattlecad/postscript/"
  
  set appCmd {} ;# set as default

  switch $::tcl_platform(platform) {
      "windows" {
              package require registry 1.1

              set root "HKEY_LOCAL_MACHINE\\SOFTWARE\\GPL Ghostscript"

                  # Get the application key for HTML files
              set appKeys [registry keys $root]
              set appKey  [lindex [lsort -decreasing $appKeys] 0]
              
              
              puts  "               appKeys  $appKeys"
              puts  "               appKey   $appKey"

              
                  # Get the command for opening HTML files
              if { [catch {     set appPATH [registry get $root\\$appKey GS_LIB]      } errMsg] } {
                          puts  "         --<E>----------------------------------------------------"
                          puts  "           <E> ... search for: $root\\$appKey\\GS_LIB"
                          puts  "           <E> could not find ghostscript Installation"
                          puts  "         --<E>----------------------------------------------------"
                          return
              }
              puts  "               appPATH  $appPATH"
              
              puts  "               env(PATH) $::env(PATH)"
              set ::env(PATH) $appPATH\;$::env(PATH)
              puts  "               env(PATH) $::env(PATH)"
      }
  }

  
  #exit
  
  set ps_Dict   [dict create directory $ps_Dir fileFormat {}]
  
      #-------------------------------------------------------------------------
        # get_file_Info
        #
    proc get_file_Info {psFile} {
        global ps_Dict
        puts "\n ------------------------"
        puts "       ... $psFile"
        puts "       ... [file tail $psFile]"
        puts "          ... [clock format [file mtime $psFile] -format %x]"
        
            #  Slurp up the data file
            #  http://wiki.tcl.tk/367
        set fp [open $psFile r]
        set file_data [read $fp]
        close $fp
        
             # Process data file
        set data [split $file_data "\n"]
        foreach line $data {
            # do some line processing here
            # puts "   -> $line"
            set searchString {%%BoundingBox: }
            if {[string equal  -length [string length $searchString] $line $searchString] } {
                puts "   ... $searchString [string length $searchString]"
                puts "   ... $line"
                set values [split [string range  $line [string length $searchString] end] ]
                puts "      -> $values"
                foreach {y0 x0 y1 x1} $values break
                puts "        -> $x0 $y0"
                puts "        -> $x1 $y1"
                set pageWidth     [expr $x1 - $x0]
                set pageHeight    [expr $y1 - $y0]
                set formatString  [format "%s_%s" $pageWidth $pageHeight]
                        puts "        -> $pageWidth x $pageHeight"
                puts "\n"
            }
            
            if {[string equal  $line {%%EndComments}]} break
        }
        
        set keyName   [file rootname [file tail $psFile]]
        set attrList  [list x0 $x0 \
                            y0 $y0 \
                            x1 $x1 \
                            y1 $y1 \
                            pageWidth $pageWidth \
                            pageHeight $pageHeight ]
                      

        if {![dict exists $ps_Dict fileFormat $formatString]} {
            puts "   ... $formatString missing"
            dict set ps_Dict fileFormat $formatString [dict create $keyName $attrList]
        } else {
            puts "   ... $formatString exists"
            dict set ps_Dict fileFormat  $formatString $keyName $attrList
        }
                         
    }

  
      #-------------------------------------------------------------------------
        # see  http://wiki.tcl.tk/23526
        #
    proc pdict { d {i 0} {p "  "} {s " -> "} } {
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

     
    set psFiles [glob -directory $ps_Dir *.ps]
    puts "Name - date of last modification"
    foreach psFile $psFiles { 
        get_file_Info $psFile
    }
  
    pdict $ps_Dict 2 
    

    #set ps_Formats [dict keys [dict get $ps_Dict fileFormat]
    foreach fileFormat [dict keys [dict get $ps_Dict fileFormat]] {
        puts "\n"
        puts " -------------------------"
        puts "     ... $fileFormat"
        
        set fileString {}
        foreach fileKey [dict keys [dict get $ps_Dict fileFormat $fileFormat]] {
              puts "         ... $fileKey"   
              set inputFile   [file nativename [file join $ps_Dir $fileKey.ps]]
              append fileString " " \"$inputFile\"
        }
        
        foreach fileKey [dict keys [dict get $ps_Dict fileFormat $fileFormat]] {
                # puts "         ... $fileKey"
              set inputFile   [file nativename [file join $ps_Dir $fileKey.ps] ]
              set outputFile  [file nativename [file join $ps_Dir $fileKey.pdf]]
              set x0          [dict get $ps_Dict fileFormat $fileFormat $fileKey x0]
              set y0          [dict get $ps_Dict fileFormat $fileFormat $fileKey y0]
              set pageWidth   [dict get $ps_Dict fileFormat $fileFormat $fileKey pageWidth]
              set pageHeight  [dict get $ps_Dict fileFormat $fileFormat $fileKey pageHeight]
              set offSet_X    [expr int (-1 * $x0)]
              set offSet_Y    [expr int (-1 * $y0)]
              
                # puts "       ... \$inputFile  $inputFile "
                # puts "       ... \$outputFile $outputFile"
                # puts "       ... \$pageWidth  $pageWidth"
                # puts "       ... \$pageHeight $pageHeight"
                # puts "       ... \$offSet_X   $offSet_X"
                # puts "       ... \$offSet_Y   $offSet_Y"
              
              set pg_Format   [format "%sx%s"                                   [expr 10 * $pageHeight] [expr 10 * $pageWidth]]
              set pg_Offset   [format "<</PageOffset \[%i %i\]>> setpagedevice" $offSet_Y $offSet_X]
              
                #puts "\n"
                #puts "     ... $ghostScript"
                #puts "               -dNOPAUSE "
                #puts "               -sDEVICE=pdfwrite "
                #puts "               -g$pg_Format "
                #puts "               -sOutputFile=$outputFile "
                #puts "               -c $pg_Offset "
                #puts "               -dBATCH $inputFile "
                #puts "             2>[file join $ps_Dir debug.txt]"
                #puts "\n"
              
              #set ghostScript_Parameter \
                  [list -dNOPAUSE \
                        -sDEVICE=pdfwrite \
                        -g$pg_Format \
                        -sOutputFile=$outputFile \
                        -c $pg_Offset \
                        -dBATCH $inputFile ]
                        
              #exec $ghostScript \
                        {*}$ghostScript_Parameter \
                        > [file join $ps_Dir debug.txt] \
                        2>@1
              
        }
        
        set outputFile  [file nativename [file join $ps_Dir summary_$fileFormat.pdf]]
        set batchFile   [file join $ps_Dir summary_$fileFormat.bat]
        
        set fileId [open $batchFile "w"]
              puts -nonewline $fileId [file nativename $ghostScript]
              puts -nonewline $fileId " -dNOPAUSE "
              puts -nonewline $fileId " -sDEVICE=pdfwrite "
              puts -nonewline $fileId " -g$pg_Format "
              puts -nonewline $fileId " -sOutputFile=\"$outputFile\" "
              puts -nonewline $fileId " -c \"$pg_Offset\" "
              puts -nonewline $fileId " -dBATCH $fileString "
        close $fileId

        exec $batchFile
        
    }

    exit
 