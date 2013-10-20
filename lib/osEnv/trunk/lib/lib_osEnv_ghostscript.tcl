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
  

  proc osEnv::get_ghostscriptExec {} {
      
      switch $::tcl_platform(platform) {
          "windows" {
                      # init_ghostScript
                  set ghostScriptName   "gswin32c.exe"

                  set root_gs "HKEY_LOCAL_MACHINE\\SOFTWARE\\GPL Ghostscript"
                  if { [catch {     set appKeys [registry keys $root_gs]      } errMsg] } {
                        puts  "         --<E>----------------------------------------------------"
                        puts  "           <E> ... search for: $root_gs"
                        puts  "           <E>    ... could not get ghostscript Installation"
                        puts  "         --<E>----------------------------------------------------"
                        return {}
                  } else {
                        set appKey  [lindex [lsort -decreasing $appKeys] 0]
                          # puts  "               appKey   $appKey"
                          # puts  "               appKeys  $appKeys"
                  }
                 
                      # Get the command for opening HTML files
                  if { [catch {     set appPATH [registry get $root_gs\\$appKey GS_LIB]      } errMsg] } {
                        puts  "         --<E>----------------------------------------------------"
                        puts  "           <E> ... search for: $root_gs\\$appKey\\GS_LIB"
                        puts  "           <E>    ... could not get ghostscript Installation"
                        puts  "         --<E>----------------------------------------------------"
                        return {}
                  }

                  
                  # -------------
                  foreach directory [split $appPATH \;] {
                      set executable [file join $directory $ghostScriptName]
                        # puts "$executable"
                      if {[file executable $executable]} {
                            # puts "          ... \$ghostScriptExec $executable"
                          return "$executable"
                      }
                  }
                  return {}
              }
          default {
                  #set ghostScriptName   "gs"
                  #set executable [_get_exec_inPATH $ghostScriptName]
                  #return "$executable"
                  return {}
              }
      }
  } 
  
  
  
  
  
  
  