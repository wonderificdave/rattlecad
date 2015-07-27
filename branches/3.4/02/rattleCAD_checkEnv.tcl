#!/bin/sh
# the next line restarts using wish \
exec tclsh "$0" "$@"


 ##+##########################################################################
 #
 # check_rattleCAD_Env.tcl
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

    puts "\n\n====== I N I T ============================ \n\n"
        
        # -- ::APPL_Config(BASE_Dir)  ------
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
    variable packageStatus {}
    variable osEnvSataus   {}
    
     
        # -- Libraries  ---------------
    lappend auto_path           [file join $BASE_Dir lib]
    lappend auto_path           [file dirname $BASE_Dir]

        # puts "  \$auto_path  $auto_path"
    puts " -- auto_path ----------"
    foreach dir $auto_path {
        puts "      ... $dir"
    }
    puts ""
        
    proc check___Common {} {
        puts "\n   -- common ------------"
        check_Package Tk
        check_Package BWidget
        check_Package tdom   
        # check_Package TclOO 
        
        
        check_Package  
        
        puts ""
    }
    
    proc check__Windows {} {
        puts "\n   --- windows ----------"
        check_Package registry
        check_Package log
    }
    
    proc check_Package {{packageName {}}} {
        variable packageStatus
	    #
	if {$packageName != {}} {
            if {[catch {set packageVersion   [package require $packageName]} eID]} {
                  # set packageVersion "... n/a  ->   sudo apt-get install $packageName"
                set packageVersion "n/a "
                lappend packageStatus $packageName
                  # puts "      ... check_Package: \$packageStatus $packageStatus"
            }
            puts [format "     tcl package   %-15s  %s" $packageName  $packageVersion]
        }
    }
    
    proc check_WindowsMimeTypes {} {
        foreach mimeType {.pdf .html .svg .dxf .jpg .gif .ps} {
            set defaultApp {}
            set defaultApp [osEnv::find_mimeType_Application $mimeType]
            puts [format "     OS mimeType   %-15s  %s" $mimeType  $defaultApp]
        }
        puts ""
    }
    
    proc check_unixApplications {} {
        foreach appName {firefox evince evince nedit sh gs} {
            set defaultApp {}
            set defaultApp [osEnv::find_OS_Application $appName]
            puts [format "    OS application %-15s  %s" $appName  $defaultApp]
        }
    }
    
    proc check_ghostScript {} {
        puts "\n -- ghostScript -------"
        puts "     [osEnv::get_ghostscriptExec]"
    }

    
  
    
        # -- check tcl packages
    puts "\n -- tcl-packages ------"
    puts ""
        #
    puts "     $tcl_platform(platform)"
    puts ""
        #
    switch $tcl_platform(platform) {
        windows {    
                    # -- TclTk
                check___Common
                check__Windows
            }
        unix {
                    # -- TclTk
                check___Common
            }
        default {    
                    # -- TclTk
                check___Common

            }   
    }
      
      
      
      
        # -- check status 
    if {$packageStatus != {}} {
        puts "\n\n====== E R R O R ========================== \n"
	puts "   ... missing packages \n"
	  # puts "\n\n====== S T A T U S :  E R R O R ===========\n"
	    #
	foreach packageName $packageStatus {
	      # puts "     $packageName  -> sudo apt-get install $packageName"
	    puts [format "     %-15s  -> sudo apt-get install %s"  $packageName $packageName]
	}
	puts "\n"
        exit
    }

      
   
    
        # -- check Environment
    package require   osEnv
        # package require   rattleCAD     3.4 
    
    puts "\n\n\n -- osEnv -------------"
    osEnv::init_osEnv
    puts ""
    
        #
    switch $tcl_platform(platform) {
        windows {    
                    # -- mimeTypes
                check_WindowsMimeTypes
                    # -- ghostScript
                check_ghostScript
            }
        unix {
                    # -- mimeTypes
                foreach appName {firefox evince evince nedit sh gs} {
                    set defaultApp {}
                    set defaultApp [osEnv::find_OS_Application $appName]
                    puts [format "     ... mimeType   %-15s  %s" $appName  $defaultApp]
                }
                    # -- ghostScript
                check_ghostScript
            }
        default {    
                    # -- ghostScript
                check_ghostScript
            }   
    }
 
       
        # -- check status 
    if {$packageStatus == {}} {
        puts "\n\n====== O K ================================ \n"
	puts "   ... all required packages installed!\n"
	
    
    
    } else {
        puts "\n\n====== E R R O R ========================== \n"
	puts "   ... missing packages \n"
	  # puts "\n\n====== S T A T U S :  E R R O R ===========\n"
	    #
	foreach packageName $packageStatus {
	      # puts "     $packageName  -> sudo apt-get install $packageName"
	    puts [format "     %-15s  -> sudo apt-get install %s"  $packageName $packageName]
	}
	puts "\n"
        exit
    }
 
 
    exit
