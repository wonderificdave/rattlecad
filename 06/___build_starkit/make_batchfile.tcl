#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"
	
  puts "\n"
  puts "  $argv0"
  puts " ----------------------------------------"
  puts "     ... $argv"
  puts "\n\n"
  
  
  set fileVersion [lindex $argv 0]
  set fileExt     [lindex $argv 1]
 
  
  if {$fileVersion != {}} {
            puts "       ... fileVersion:  $fileVersion" 
  } else {
            puts "\n       ... \$fileVersion not defined\n"
            exit
  }

  puts "\n"

  variable dirInit
  variable dirExport 
  
  set dirInit    [file normalize .]
  set dirBase    [file dirname $dirInit]
  set dirExport  [file join $dirBase ___build]

  puts "   -> \$dirInit  ........  $dirInit"
  puts "   -> \$dirBase  ........  $dirBase"    
  puts "   -> \$dirExport  ......  $dirExport"
  puts "\n"
  
  
  #
  # http://stackoverflow.com/questions/2818130/in-tcl-how-do-i-replace-a-line-in-a-file
  #
  # for plain text files, it's safest to move the original file to 
  # a "backup" name then rewrite it using the original fileName:
  #
  # Update: edited based on Donal's feedback
  #

  proc create_BatchFile {fileVersion fileExt} {

      global dirInit
      global dirExport
      
      set fileName  "rattleCAD.$fileExt"
      set inFile    [file join $dirInit   template_$fileName]
      set outFile   [file join $dirExport $fileName]

      set in  [open $inFile  r]
      set out [open $outFile w]
      
	  puts "  -----------------------------------------------------------"
	  puts "          \$fileName     $fileName "
      puts "             \$inFile    $inFile"
      puts "             \$outFile   $outFile"

      # line-by-line, read the original file
      switch -exact $fileName {
          rattleCAD.bat -
          rattleCAD.tcl {
                  set stringMapping [list __versionKey__ $fileVersion]   
                  while {[gets $in line] != -1} {
                        # transform $line somehow
                      set line [string map $stringMapping $line]
                      puts "          | $line"
                        # then write the transformed line
                      puts $out $line
                  }
              }
          default {
                  break
                  while {[gets $in line] != -1} {
                        # transform $line somehow
                      set line [string tolower $line]
                      puts "      | $line"
                        # then write the transformed line
                      puts $out $line
                  }    
              }
      }

      close $in
      close $out
  }

  create_BatchFile $fileVersion tcl 
  create_BatchFile $fileVersion bat
  
  # move the new data to the proper fileName
  #file link -hard $fileName $backup
  #file rename -force $temp $fileName 

