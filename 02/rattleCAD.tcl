#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"


 ##+##########################################################################
 #
 # rattleCAD.tcl
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
 

  ###########################################################################
  #
  #                 I  -  N  -  I  -  T                        -  Application
  #
  ###########################################################################

    puts "\n\n ====== I N I T ============================ \n\n"
        
        # -- ::APPL_Config(BASE_Dir)  ------
        #
    set BASE_Dir  [file normalize $::argv0]
  
        # -- redefine on Starkit  -----
        #         exception for starkit compilation
        #        .../rattleCAD.exe
        #        .../rattleCAD.exe
    set APPL_Type       [file tail $::argv0]    
    switch -glob -- $APPL_Type {
        {rattleCAD*.kit}   { }    
        {main.tcl} -    
        default           {
           set BASE_Dir  [file dirname $BASE_Dir]
        }
    }


        # -- Libraries  ---------------
        #
    lappend auto_path           [file join $BASE_Dir lib]
    lappend auto_path           [file join [file dirname $BASE_Dir] addon]

        # puts "  \$auto_path  $auto_path"
    
    
        # -- Packages  ----------------
        #
    package     require Tk                  8.6
    package     require BWidget             
    package     require tdom    
        #
    package     require appUtil             0.15
    package     require vectormath          0.7
    package     require bikeGeometry        1.45
    package     require canvasCAD           0.54
    package     require extSummary          0.4
    package     require osEnv               0.9
                
    package     require rattleCAD           3.4 

    catch {
            # tcl package containing not public extensions
        package require rattleCAD_AddOn
    }
    catch {
            # tcl package for windows only
        package require registry            1.1
    }    
    
    

    
  ###########################################################################
  #
  #                 R  -  U  -  N  -  T  -  I  -  M  -  E 
  #
  ###########################################################################

    
    if {$argc == 1} {
        init_rattleCAD $BASE_Dir [lindex $argv 0]
    } else {	    
        init_rattleCAD $BASE_Dir
    }
    
 
    puts "\n\n ====== R U N T I M E ============================ \n\n"
        
        
        # -- destroy intro - image ----
        # after  50 destroy .intro
    destroy .intro


	# -- keep on top --------------
    wm deiconify .
    
    
	# -- check commandline args --
    if {$argc > 1} {
        set i 0
        array set argValues {}
        while {$i < [llength $argv]} {
            set arg [lindex $argv $i]
            # puts "         ... [string index $arg 0]"
            if {[string index $arg 0] == {-}} {
        	set key $arg
        	set argValues($key) {}
        	incr i
            } else {
                lappend argValues($key) [lindex $argv $i]
                incr i
            }
        }
          # parray argValues
          # puts "\n ... <D>  [array names argValues {-test}]"
	    
	    
        if {[array names argValues {-file}] == {-file}} {
            puts "\n =============================================="    
            puts "      ... CommandLine Argument: -file $argValues(-file)\n"    
            set openFile [lindex $argValues(-file) 0]
            if {$openFile != {}} {
        	puts "          ... $openFile\n"
    	        lib_file::openProject_xml   $openFile
    	    }    
        }
	    
        if {[array names argValues {-test}] == {-test}} {
    	    puts "\n =============================================="    
    	    puts "      ... CommandLine Argument: -test $argValues(-test)\n"    
    	    puts "      ... run some tests\n"    
    	    set testCommands $argValues(-test)
    	    foreach command $testCommands {
    	        puts "\n         ... $command"
	        rattleCAD_Test::controlDemo $command
    	   }
        }

	    
    }
    
      # -- run a debug procedure
    # rattleCAD::debug::run_debug

    
    #osEnv::open_fileDefault "E:/manfred/Dateien/rattleCAD/html/index.html"
    #osEnv::open_fileDefault "http://rattlecad.sourceforge.net/"

