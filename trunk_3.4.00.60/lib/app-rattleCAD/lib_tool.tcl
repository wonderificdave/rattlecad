 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_gui.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their 
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
 # ---------------------------------------------------------------------------
 #    namespace:  rattleCAD::lib_gui
 # ---------------------------------------------------------------------------
 #
 # 
 
 
 namespace eval lib_tool {

    proc check_runTime {} {
        set nameofExecutable [info nameofexecutable]
        set executableFile [file tail $nameofExecutable]
        set executableExt  [lindex [split $executableFile .] end]
        set executableName [string map [list .$executableExt {}] $executableFile]
        
        # tk_messageBox -icon info -message "Executeable:\n  $nameofExecutable\n    $executableFile\n      $executableName\n      $executableExt"
        
        set executable_OK 1 ;# if 1 ... OK
        switch $::tcl_platform(platform) {
            windows {
                if {$executableName == {rattleCAD}} {
                    set executable_OK 0
                }
            }
        }
        return [list $executable_OK $executableFile $nameofExecutable]
    }

    
    proc toolException {command runTime} {
        tk_messageBox -icon info \
                -title   "[file tail $command]   -   tclTk-Runtime required!" \
                -message "  ... this feature is available in tclTk-Runtime only!\n\n  ... current runtime:\n         $runTime"
        return
    }

    proc start_simplifySVG {} {
        puts "\n"
        puts "    start simplify_SVG.tcl: "
        puts "  ----------------------------------------"
        set command [file join $::APPL_Config(BASE_Dir) _style/simplify_SVG.tcl]
        set testDir [file join $::APPL_Config(USER_Dir) components/test ]
        puts "      -> $command"
        puts "      -> $testDir"
        puts ""
        
        set runtime_Info [check_runTime]
        set runtime_OK       [lindex $runtime_Info 0]
        set runtime_FileName [lindex $runtime_Info 1]
        set runtime_FullName [lindex $runtime_Info 2]
        puts "      -> $runtime_OK"
        puts "      -> $runtime_FileName"
        puts "      -> $runtime_FullName"
        puts ""
                
        if {![file exists $testDir]} {
           file mkdir $testDir
        }
        cd $testDir

        if {!$runtime_OK} {
            toolException $command $runtime_FullName
            return
        }
        
        if {[catch {exec $runtime_FullName [file normalize $command] &} eID]} {
            tk_messageBox -icon error -message "  ... could not execute $command"
        }
    }    


    proc start_chainWheelSVG {} {
        puts "\n"
        puts "    start chainWheel_SVG.tcl: "
        puts "  ----------------------------------------"
        set command [file join $::APPL_Config(BASE_Dir) _style/chainWheel_SVG.tcl]
        set testDir [file join $::APPL_Config(USER_Dir) components/test ]
        puts "      -> $command"
        puts "      -> $testDir"
        puts ""
        
        set runtime_Info [check_runTime]
        set runtime_OK       [lindex $runtime_Info 0]
        set runtime_FileName [lindex $runtime_Info 1]
        set runtime_FullName [lindex $runtime_Info 2]
        puts "      -> $runtime_OK"
        puts "      -> $runtime_FileName"
        puts "      -> $runtime_FullName"
        puts ""
        
        if {![file exists $testDir]} {
           file mkdir $testDir
        }
        cd $testDir

        if {!$runtime_OK} {
            toolException $command $runtime_FullName
            return
        }
        
        if {[catch {exec $runtime_FullName [file normalize $command] &} eID]} {
            tk_messageBox -icon error -message "  ... could not execute $command"
        }
    }    

}

