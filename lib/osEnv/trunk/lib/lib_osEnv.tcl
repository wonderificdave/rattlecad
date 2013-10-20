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
  

  proc osEnv::_add_ApplMimeType {mimeType} {
      variable registryDOM
          #
      set applCmd [_get_mimeType_Application $mimeType]
          #
      if {$applCmd != {}} {  
          set domNode [$registryDOM selectNode os/mime]
              #
          set domDOC    [$domNode ownerDocument]
          set mimeNode  [$domDOC createElement mime]
              #
          $mimeNode setAttribute name $mimeType
              #
          $domNode appendChild $mimeNode
              #
          $mimeNode appendChild [$domDOC createTextNode \"$applCmd\"] 
      }   
  }

  proc osEnv::_add_Executable {execName} {
      variable registryDOM
          #
      switch -exact $execName {
          GhostScript {
              set applCmd [_get_ghostscriptExec]
          }
          default {
              set applCmd {}
          }
      }    
          #
      if {$applCmd != {}} {
          set domNode [$registryDOM selectNode os/exec]
              #       
          set domDOC    [$domNode ownerDocument]
          set execNode  [$domDOC createElement exec]
              #
          $execNode setAttribute name $execName
              #
          $domNode appendChild $execNode
              #
          $execNode appendChild [$domDOC createTextNode \"$applCmd\"] 
      }
  } 


  proc osEnv::_get_mimeType_Application {fileExtension} {
            #    http://wiki.tcl.tk/557
            # puts "\n"
            # puts  "         get_Application: $fileExtension"
            # puts  "       ---------------------------------------------"
            # puts  "               tcl_version   [info tclversion]"
            # puts  "               tcl_platform  $::tcl_platform(platform)"

          set appCmd {} ;# set as default
          switch -exact $::tcl_platform(platform) {
              "windows" {
                      set root HKEY_CLASSES_ROOT

                          # Get the application key for HTML files
                      set appKey [registry get $root\\$fileExtension ""]
                          # puts  "               appKey  $appKey"

                      set appCmd   {}
                      set fileType {}
                      catch { set appCmd   [registry get $root\\$appKey\\shell\\open\\command ""] }
                      if {$appCmd == {}} {
                          catch { set appCmd   [registry get $root\\$appKey\\shell\\open\\command ""] }
                          if {$appCmd == {}} {
                              catch { set appCmd   [registry get $root\\$appKey\\shell\\edit\\command ""] }
                          }
                      }
                        # puts "     -> \$appCmd   $appCmd"
                        # puts "     -> \$fileType $fileType"
    
                          
                          # Get the command for opening HTML files
                      if { $appCmd == {} } {
                                  puts  "         --<E>----------------------------------------------------"
                                  puts  "           <E> File Type: $fileExtension"
                                  puts  "           <E> could not find a registered COMMAND for this appKey"
                                  puts  "         --<E>----------------------------------------------------"
                                  return
                      }
                          # puts  "               appCmd  $appCmd"
                          # set appArgs           [lrange $appCmd 1 end]
                      if {[catch {set appCmd [lindex [string map {\\ \\\\} $appCmd] 0]} eID]} {
                          set appCmd {}
                      }

              }
          }
          return "$appCmd"
  }


  proc osEnv::_get_exec_inPATH {execName} {  
          # puts "   -> osEnv::_get_exec_Application $execName"
      switch -exact $::tcl_platform(platform) {
          "windows" { 
               set dirList [split $::env(PATH) \;]
          }
          default {
               set dirList [split $::env(PATH) \;]
          }
      }
      # -------------
          # puts "  -> $dirList"
      # -------------
      foreach directory $dirList {
          set executable [file join $directory $execName]
              # puts "$executable"
          if {[file executable $executable]} {
              return "$executable"
          }
      }
      return {}
  }

  
  proc osEnv::_add_nameValue {domNode nodeName nodeValue} {
  
      set domDOC    [$domNode ownerDocument]
      set nameNode  [$domDOC createElement $nodeName]
      $domNode appendChild $nameNode
      

      if {[llength $nodeValue] == 1} {
          $nameNode appendChild [$domDOC createTextNode $nodeValue] 
      } else {
          foreach arg $nodeValue {
              switch -exact $nodeName {
                  {loaded} {
                           foreach {value name} $arg break
                      }
                  default {
                           foreach {name value} $arg break
                      }
              }
                # puts "        ... $name / $value"
              set listNode  [$domDOC createElement $name]
              $nameNode appendChild $listNode
              $listNode appendChild [$domDOC createTextNode $value] 
          }
      }
  }
  