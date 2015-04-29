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
  

    proc osEnv::_find_ghostscriptExec {bitVersion} {
            #
            #
            # parray ::tcl_platform   
            #
            # puts "               ->  \$::tcl_platform(machine)   $::tcl_platform(machine)       = amd64"
            # puts "               ->  \$::tcl_platform(platform)  $::tcl_platform(platform)"
            #
            # set proc_info [info level [expr [info level]-1] ]
            # set proc_name [lindex $proc_info 0 ]
            #
            # puts "   ... $proc_info"
            # puts "   ... $proc_name"
            # exit
        set bitSwitch [format "-%sbit" $bitVersion]
            # puts "    ... $bitSwitch"
            #
        set execList {}
            #
        switch $::tcl_platform(platform) {
            "windows" {
                        # init_ghostScript
                    set ghostScriptNames   {gswin32c.exe gswin64c.exe}
                        #
                    set root_gs "HKEY_LOCAL_MACHINE\\SOFTWARE\\GPL Ghostscript"
                        #
                    if { [catch {     set versionDirs [registry $bitSwitch keys $root_gs]      } errMsg] } {
                        puts  "         --<E>----------------------------------------------------"
                        puts  "           <E> ... search for: $root_gs"
                        puts  "           <E>    ... could not get ghostscript Installation"
                        puts  "         --<E>----------------------------------------------------"
                        return {}
                    } else {
                        set versionDirs [lsort -decreasing $versionDirs]
                        foreach versionDir $versionDirs {
                                #
                            # puts "               ... $bitSwitch ... $versionDir"
                                #
                                # get execPath using GS_DLL
                            if { [catch {     set gsPath [registry $bitSwitch get $root_gs\\$versionDir GS_DLL]      } errMsg] } {
                                puts  "         --<E>----------------------------------------------------"
                                puts  "           <E> ... search for: $root_gs\\$versionDir\\GS_LIB"
                                puts  "           <E>    ... could not get ghostscript Installation"
                                puts  "         --<E>----------------------------------------------------"
                                continue
                                # return {}
                            }    
                                #
                                # puts "               ... $bitSwitch ... $gsPath"
                            set gsPath [file dirname $gsPath]
                                # puts "               ... $bitSwitch ... $gsPath"
                                #
                            foreach ghostScriptName $ghostScriptNames {
                                set execFile    [file join $gsPath $ghostScriptName]
                                if {[file exists $execFile]} {
                                    if {[file executable $execFile]} {
                                            #
                                        lappend execList "$execFile"
                                            #
                                    }
                                }
                            }
                                #
                        }
                            #
                        return $execList
                            #
                    }
                }
            default {
                    #set ghostScriptName   "gs"
                    #set executable [_get_exec_inPATH $ghostScriptName]
                    #return "$executable"
                    return {}
                }
        }
    }
