#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"


 ##+##########################################################################
 #
 # osEnv.tcl
 #
 #   osEnv is software of Manfred ROSENBERGER
 #       based on tclTk and BWidgets and their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2013/03/17
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
  
  package provide osEnv 0.2
  
  namespace eval osEnv {
      
          # --------------------------------------------
          # initial package definition
      package require tdom
      package require registry
                  
      
      # --------------------------------------------
          # Export as global command
      variable packageHomeDir [file normalize [file join [pwd] [file dirname [info script]]] ]
      

     #-------------------------------------------------------------------------
          #  definitions of template Documents
     variable registryDOM 

      
      # --------------------------------------------
          # get report Template
      set fp [open [file join $packageHomeDir .. etc initTemplate.xml] ]
      fconfigure      $fp -encoding utf-8
      set registryXML [read $fp]
      close           $fp          
      set registryDoc [dom parse $registryXML]
      set registryDOM [$registryDoc documentElement]     
       
       
      # --------------------------------------------
        # procedures
      proc init_osEnv {} {                   
          variable registryDOM
          
          _init_tcl_info
          _init_tcl_platform 
          _init_os_env 
          
          _init_os_mimeType
          
          _init_os_executable
          
          return $registryDOM               
      }
        
      
            
      
      proc get_defaultApp {fileExtension} {
          variable registryDOM
          set node [$registryDOM selectNode /root/os/mime]
          set extNode [lindex [$node find name $fileExtension] 0]
          if {$extNode != {}} {
              set defaultApp [file nativename [$extNode asText]]
              set defaultApp [string trim $defaultApp \" ]
              return $defaultApp
          } else {
              puts "      <E> no entry found for $ext"
              return {}
          }          
      }
      
      
      proc get_Executable {executable} {
          variable registryDOM
          set node [$registryDOM selectNode /root/os/exec]
          set extNode [lindex [$node find name $executable] 0]
          if {$extNode != {}} {
              set thisApp [file nativename [$extNode asText]]
              set thisApp [string trim $thisApp \" ]
              return $thisApp
          } else {
              puts "      <E> no entry found for $ext"
              return {}
          }          
      }     
      
      proc open_fileDefault {fileName {altExtension {}}} {

            set fileExtension   [file extension $fileName]

            puts "\n"
            puts  "   -------------------------------"
            puts  "    osEnv::open_fileDefault:  $fileExtension ($altExtension)"       
            puts  "        fileName        $fileName"


                            # -- handle on file extension
                #
            if {![file exists $fileName]} {
                switch -glob $fileName {
                    "http://*" {
                                if {$fileExtension == {}} {set fileExtension .html}
                                if {$altExtension  == {}} {set altExtension  .html}
                        }
                    default {
                            puts  ""
                            puts  "         --<E>----------------------------------------------------"
                            puts  "           <E> File : $fileName"
                            puts  "           <E>      ... does not exist! "
                            puts  "         --<E>----------------------------------------------------"
                            return
                        }
                }
            }
            
            if {$altExtension == {}} {
                set altExtension $fileExtension
            }

            set fileApplication     [format "\"%s\"" [osEnv::get_defaultApp $fileExtension]]
            if {$fileApplication == {}} {
                puts  ""
                puts  "         --<E>----------------------------------------------------"
                puts  "           <E> File : $fileName"
                puts  "           <E>      ... could not get any Application! "
                puts  "         --<E>----------------------------------------------------"
                return
            }
            
            switch $altExtension {
                {.htm} -
                {.html} { 
                        if {[file exists $fileName]} {
                            # ... is a local file
                            set fileName        "file:///$fileName"
                        }
                    }
                default {
                    }
            }

            puts  ""
            puts  "        fileExtension   $fileExtension"
            puts  "        fileApplication $fileApplication"


                # ---------------------
                # replace %1 by fileName
            proc os_format { cmdString substString } {
                    # puts " --------------"
                    # puts "        \$cmdString    >$cmdString<"
                    # puts "        \$pattern      >$pattern<"
                    # puts "        \$substString  >$substString<"
                    # puts " --------------"
                    # puts " [ string map [ list $pattern $substString ] $cmdString ]"
                 switch -exact $::tcl_platform(platform) {
                    "windows" { 
                        set cmdString    [ string map [ list %1 $substString ] $cmdString ]
                        return $cmdString
                    }
                    default {
                        return $cmdString
                    }
                }
            }

                # ---------------------
                # Substitute the HTML filename into the
                # command for %1
            set commandString [ os_format $fileApplication $fileName ]
            if {$commandString == $fileApplication} {
                set commandString "$fileApplication  $fileName"
            }

                # ---------------------
                # Double up the backslashes for eval (below)
            puts ""
            puts "        ... $commandString "

                # ---------------------
                # Double up the backslashes for eval (below)
            regsub -all {\\} $commandString  {\\\\} commandString

                # ---------------------
                # Invoke the command
            eval exec $commandString &

                # ---------------------
                # done ...
            puts  ""
            puts  "                    ... done"
            return
      }

     
      
      proc _init_tcl_info {} {
          variable registryDOM
              #
          set domNode [$registryDOM selectNode tcl]
              #
          puts "\n   ... init_tcl_info" 
            #
          puts "[info library]"
            #
          _add_nameValue $domNode patchlevel  [info patchlevel]
              # Returns the value of the global variable tcl_patchLevel;
          _add_nameValue $domNode hostname    [info hostname]
              # Returns the name of the computer on which this invocation is being executed.
          _add_nameValue $domNode library     [info library]
              # Returns the name of the library directory in which standard Tcl scripts are stored. 
              # This is actually the value of the tcl_library variable and may be changed by setting 
              # tcl_library. See the tclvars manual entry for more information.
          _add_nameValue $domNode loaded      [info loaded]         
              # Returns a list describing all of the packages that have been loaded into interp with the load command.   
      }

      proc _init_tcl_platform {} {
          variable registryDOM
              #
          set domNode [$registryDOM selectNode tcl/platform]
              #
          puts "\n   ... init_tcl_platform" 
		      #
		      foreach key [lsort [array names ::tcl_platform]] {
                # puts "   ... $key  $::env($key)"
              catch {_add_nameValue $domNode $key  \"$::tcl_platform($key)\"}
          }
      }

      proc _init_os_env {} {
          variable registryDOM
              #
          set domNode [$registryDOM selectNode os/env]
              #
          puts "\n   ... init_os_env" 
		      #
          foreach key [lsort [array names ::env]] {
                # puts "   ... $key  $::env($key)"
              switch -glob -- $key {
                  TCLLIBPATH {
                          puts "  -> got a PATH node: $key"
                          puts "  $::env($key)"
                          set dirList [split $::env($key) \;]
                          puts "[llength $::env($key)]"
                          catch {_add_nameValue $domNode $key  {}}
                          set parenNode [$registryDOM selectNode os/env/$key]
                          foreach dir $::env($key) {
                             catch {_add_nameValue $parenNode value  \"$dir\"}
                          }
                      }
                  *PATH* -
                  *Path* {
                          puts "  -> got a PATH node: $key"
                          puts "  $::env($key)"
                          set dirList [split $::env($key) \;]
                          puts "[llength $dirList]"
                          catch {_add_nameValue $domNode $key  {}}
                          set parenNode [$registryDOM selectNode os/env/$key]
                          foreach dir $dirList {
                             catch {_add_nameValue $parenNode value  \"$dir\"}
                          }
                      }
                  default {
                          catch {_add_nameValue $domNode $key  \"$::env($key)\"}
                      }
              }  
          }
          # puts "  [$registryDOM asXML]"
          # exit
      }
      
      proc _init_os_mimeType {} {
              #
          puts "\n   ... init_os_mimeType" 
		      #
          _add_ApplMimeType .ps
          _add_ApplMimeType .pdf
          _add_ApplMimeType .html
          _add_ApplMimeType .svg
          _add_ApplMimeType .dxf
          _add_ApplMimeType .jpg
          _add_ApplMimeType .gif
      }

      proc _init_os_executable {} {
              #
          puts "\n   ... init_os_executable" 
		      #
          _add_Executable GhostScript         ; # {GPL Ghostscript}
      }     
      
    
      
      

  }