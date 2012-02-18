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
	#-------------------------------------------------------------------------
		# http://stackoverflow.com/questions/429386/tcl-recursively-search-subdirectories-to-source-all-tcl-files
		# 2010.10.15
	proc findFiles { basedir pattern types } {
					# Fix the directory name, this ensures the directory name is in the
					# native format for the platform and contains a final directory seperator
			set basedir [string trimright [file join [file normalize $basedir] { }]]
			set fileList {}
					# Look in the current directory for matching files, -type {f r}
					# means ony readable normal files are looked at, -nocomplain stops
					# an error being thrown if the returned list is empty
			foreach fileName [glob -nocomplain -type $types -path $basedir $pattern] {
				lappend fileList $fileName
			}
			
					# Now look for any sub direcories in the current directory
			foreach dirName [glob -nocomplain -type {d  r} -path $basedir *] {
						# Recusively call the routine on the sub directory and append any
						# new files to the results
				set subDirList [findFiles $dirName $pattern $types]
				if { [llength $subDirList] > 0 } {
					foreach subDirFile $subDirList {
						lappend fileList $subDirFile
					}
				}
			}
			return $fileList
	}	

if {$argc == 0} {
    puts ""
    puts "  -----------------------"
    puts "     comoile rattleCAD Starkit"
    puts ""
    puts "     usage:  tclsh $argv0  trunkDir"
    puts ""
    puts "           e.g.:     tclsh $argv0  3.2.79"
    puts "\n"
    exit
}
    
    
puts "\n ========================\n"
puts "     update starkit\n"
set dir_compile [file normalize .]
set dir_trunk   [file join [file dirname [file normalize .]] [lindex $argv 0]]
set dir_vfs 	[file join $dir_compile rattleCAD.vfs]

    puts "     "
    puts "    dir_compile $dir_compile"
    puts "    dir_trunk   $dir_trunk  "
    puts "    dir_vfs     $dir_vfs    "
    puts "\n"


if {[file exists [file join $dir_trunk tclkit.inf]]} {
		# puts " customizing strings in executable"
		set fd [open [file join $dir_trunk tclkit.inf]]
		array set strinfo [read $fd]
		close $fd
 		set dir_version [file join [file dirname [file normalize .]] ___version/$strinfo(ProductVersion).$strinfo(FileVersion)]
} else {
		set dir_version [file join [file dirname [file normalize .]] ___version/newVersion]
}

	# set dir_version [file join [file dirname [file normalize .]] ___version/newVersion]

puts "   -> $dir_compile"
puts "   -> $dir_trunk"
puts "   -> $dir_vfs"
puts "   -> $dir_version"


	# -- cleanup $dir_compile
	#
puts "\n ========================\n"
puts "         cleanup complete\n"

file_delete [file join $dir_vfs help.txt]
file_delete [file join $dir_vfs license.txt]
file_delete [file join $dir_vfs exclusion.txt]
file_delete [file join $dir_vfs main.tcl]
file_delete [file join $dir_vfs tclkit.inf] 
file_delete [file join $dir_vfs tclkit.ico] 
file_delete [file join $dir_vfs icon_16.xbm] 
file_delete [file join $dir_vfs rattleCAD.tcl]
file_delete [file join $dir_vfs simplify_SVG.tcl]
file_delete [file join $dir_vfs Tcl.svg]
file_delete [file join $dir_vfs tclTk.svg]
file_delete [file join $dir_vfs rattleCAD.svg]

file_delete [file join $dir_vfs etc]
file_delete [file join $dir_vfs image]
file_delete [file join $dir_vfs lib]

	# -- update $dir_compile
	#
puts "\n ========================\n"
puts "         update\n"

file_update [file join $dir_trunk      etc]  $dir_vfs
file_update [file join $dir_trunk    image]  $dir_vfs
file_update [file join $dir_trunk      lib]  $dir_vfs
foreach _dir [glob -directory [file join $dir_compile   _lib] *] {
	file_update $_dir [file join $dir_vfs lib]
}

file_update [file join $dir_trunk help.txt]       	$dir_vfs
file_update [file join $dir_trunk license.txt]    	$dir_vfs
file_update [file join $dir_trunk exclusion.txt]  	$dir_vfs
file_update [file join $dir_trunk main.tcl]  		$dir_vfs
file_update [file join $dir_trunk tclkit.inf]  		$dir_vfs
file_update [file join $dir_trunk tclkit.ico]       $dir_vfs
file_update [file join $dir_trunk icon_16.xbm]      $dir_vfs
file_update [file join $dir_trunk rattleCAD.tcl]  	$dir_vfs
file_update [file join $dir_trunk simplify_SVG.tcl] $dir_vfs
file_update [file join $dir_trunk Tcl.svg] 			$dir_vfs
file_update [file join $dir_trunk tclTk.svg] 		$dir_vfs
file_update [file join $dir_trunk rattleCAD.svg] 	$dir_vfs

	# -- remove unused files
	#
	# -- update $dir_compile
	#
puts "\n ========================\n"
puts "         cleanup\n"
	# -- etc
foreach file [findFiles [file join $dir_vfs etc] *.cdr {f r}] {
	file_delete $file
}
foreach file [findFiles [file join $dir_vfs etc] *.jpg {f r}] {
	file_delete $file
}
foreach file [findFiles $dir_vfs .svn {d r hidden} ] {
	file_delete $file
}


	# -- test starkit 
	#
puts "\n ========================\n"
puts "         test Starkit\n"
	# -- test 
	#
exec tclkit-8.5.8-win32.upx.exe rattleCAD.vfs/main.tcl
   
	# -- update 
	#
file copy  -force tclkit-8.5.8-win32.upx.exe runtime.exe
   
	# -- compile 
	#
puts "\n ========================\n"
puts "         compile Starkit\n"
exec tclkit-8.5.8-win32.upx.exe sdx-20110317.kit wrap rattleCAD.exe -runtime runtime.exe


	# -- copy to ../___version 
	#
puts "\n ========================\n"
puts "         version Directory\n"
file_delete	$dir_version
file mkdir  $dir_version
file mkdir  [file join $dir_version lib]

file_update [file join $dir_vfs  help.txt]			$dir_version
file_update [file join $dir_vfs  license.txt]    	$dir_version
file_update [file join $dir_vfs  exclusion.txt]  	$dir_version
file_update [file join $dir_vfs  main.tcl]  		$dir_version
file_update [file join $dir_vfs  tclkit.inf]  		$dir_version
file_update [file join $dir_vfs  tclkit.ico]        $dir_version
file_update [file join $dir_vfs  icon_16.xbm]       $dir_version
file_update [file join $dir_vfs  rattleCAD.tcl]  	$dir_version
file_update [file join $dir_vfs  simplify_SVG.tcl]	$dir_version
file_update [file join $dir_vfs  Tcl.svg]			$dir_version
file_update [file join $dir_vfs  tclTk.svg]			$dir_version
file_update [file join $dir_vfs  rattleCAD.svg]  	$dir_version


file_update [file join $dir_vfs  etc      ]                          $dir_version
file_update [file join $dir_vfs  image    ]                          $dir_version
file_update [file join $dir_vfs  lib/_apputil      ]                 [file join $dir_version lib]
file_update [file join $dir_vfs  lib/_canvasCAD    ]                 [file join $dir_version lib]
file_update [file join $dir_vfs  lib/_extSummary   ]                 [file join $dir_version lib]
file_update [file join $dir_vfs  lib/app-rattleCAD ]                 [file join $dir_version lib]
file_update [file join $dir_vfs  lib/test_canvas_CAD_ChainWheel.tcl] [file join $dir_version lib]
file_update [file join $dir_vfs  lib/test_canvas_CAD_Dimension.tcl ] [file join $dir_version lib]
file_update [file join $dir_vfs  lib/test_canvas_CAD_notebook.tcl  ] [file join $dir_version lib]
file_update rattleCAD.exe                                           $dir_version


	# -- ready 
	#
puts "\n ========================\n"
puts "         ready ! \n\n\n"

return