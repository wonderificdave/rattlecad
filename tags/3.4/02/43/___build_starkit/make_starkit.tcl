#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

#glob ../trunk *
#puts "[file normalize .]"
#puts "[file dirname [file normalize .]]"


	proc file_delete {file} {
		puts "      ... delete:  $file"
		catch {file delete -force $file}
	}
	proc file_update {source target} {
		puts "      ... update:  $target [file tail $source]"
		catch {file copy -force $source $target}
	}

  proc check_trunkDir {baseDir} {
      set vfsDir [file join $baseDir rattleCAD.vfs]
        # puts "    .... $vfsDir"
      if {[file exists $vfsDir]} {
          file delete -force $vfsDir
      }
      set buildDir [glob -directory [file normalize $baseDir] -type d *]
      set buildDir [string trim $buildDir \{\} ]
        # puts "    .... ${buildDir}"
	  return ${buildDir}
  }

    
    
    puts "\n ========================\n"
    puts "     update Export, Tclkit & Starkit\n"
    puts ""
    
set dirInit    [file normalize .]
set dirBase    [file dirname $dirInit]
set dirExport  [file join $dirBase ___build]

set sdx_Kit    sdx-20110317.kit
    #
set tclkit_Bin tclkit-8.6.3-win32-ix86.exe
# set tclkit_Bin tclkit-8.6.3-win32-x86_64.exe
    #
# set tclkit_Bin tclkit-8.5.8-win32.upx.exe
# set tclkit_Bin tclkit8513.exe               ;# http://www.patthoyts.tk/tclkit/win32-ix86/8.5.13/
# set tclkit_Bin tclkit-gui-8_6_3-twapi-4_0_61-x86-max.exe



    puts "   -> \$dirInit  ........  $dirInit"
    puts "   -> \$dirBase  ........  $dirBase"    
    puts "   -> \$dirExport  ......  $dirExport"
    
set dirTrunk   [check_trunkDir $dirExport]
set dirVFS 	   [file join [file dirname $dirTrunk] rattleCAD.vfs]   
    
    puts "   -> \$dirTrunk  .......  $dirTrunk"
    puts "   -> \$dirVFS  .........  $dirVFS"
    puts "\n"


# ----------------------------------
  #    
puts "\n ========================\n"
puts "         get Version Info\n"    
  # puts "           ... [file join "$dirTrunk" tclkit.inf]\n"    
  # puts "           ... [file join "$dirTrunk" tclkit.inf]\n"    
  # puts "           ... $dirTrunk/tclkit.inf\n"    
if {[file exists [file join $dirTrunk tclkit.inf]]} {
		# puts " customizing strings in executable"
		set fd [open [file join $dirTrunk tclkit.inf]]
		array set strinfo [read $fd]
		close $fd
    set appVersion "$strinfo(ProductVersion).$strinfo(FileVersion)"
} else {
    set appVersion {_unknown_}
}

    puts "   -> \$appVersion  .....  $appVersion"

set trunkVersion  [file tail $dirTrunk]

    puts "   -> \$trunkVersion  ...  $trunkVersion"


# ----------------------------------
  #    
puts "\n ========================\n"
puts "         check Version"
if {$appVersion != $trunkVersion} {
    puts "\n           ... $appVersion != $trunkVersion"
    # throwError     ; #" ... $appVersion != $trunkVersion" 
    exit -1
    return -level 2; #" ... $appVersion != $trunkVersion" 
}


# ----------------------------------
  #
puts "\n ========================\n"
puts "         initialize Virtual File System\n"
  #
	# -- update 
	#         http://equi4.com/starkit/sdx.html
  #
source   [file join $dirInit  $sdx_Kit]
package require sdx
file copy -force [file join $dirInit rattleCAD.tcl] $dirExport
cd $dirExport

sdx::sdx qwrap  rattleCAD.tcl
sdx::sdx unwrap rattleCAD.kit

# ----------------------------------
  #
puts "\n ========================\n"
puts "         copy content to Virtual File System\n"
  #
  # file rename -force [file join $dirVFS lib] [file join $dirVFS _lib]
file delete -force [file join $dirVFS lib] 
  #
foreach fileName [glob -directory $dirTrunk -type {d f} *] {
    puts "                ... $fileName"
    file copy -force $fileName $dirVFS
}
puts ""
foreach fileName [glob -directory [file join $dirInit _lib] -type {d f} *] {
    # puts "                ... $fileName"
    # file copy -force $fileName [file join $dirVFS lib]
}


	# ----------------------------------
	#
puts "\n ========================\n"
puts "         compile Tclkit\n"
sdx::sdx wrap rattleCAD.kit
file rename rattleCAD.kit rattleCAD_${appVersion}.kit



	# ----------------------------------
	#
puts "\n ========================\n"
puts "         compile Starkit\n"
foreach fileName [glob -directory [file join $dirInit _lib] -type {d f} *] {
    puts "                ... $fileName"
    file copy -force $fileName [file join $dirVFS lib]
}
sdx::sdx wrap rattleCAD.exe -runtime [file join $dirInit $tclkit_Bin]
file rename rattleCAD.exe rattleCAD_${appVersion}.exe
	# ----------------------------------
	#
puts "\n ========================\n"
puts "         test Starkit\n"
puts "                  ... rattleCAD_${appVersion}.exe"




return $appVersion

	# ----------------------------------
	#
puts "\n ========================\n"
puts "         run starkit\n"
cd $dirExport
exec  rattleCAD_${appVersion}.kit
exec  rattleCAD_${appVersion}.exe


	# ----------------------------------
	#
puts "\n ========================\n"
puts "         supply batch-scripts\n"
file copy -force [file join $dirInit rattleCAD.tcl] $dirExport
file copy -force [file join $dirInit rattleCAD.bat] $dirExport

return $appVersion
   


