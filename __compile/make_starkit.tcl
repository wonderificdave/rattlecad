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


puts "\n ========================\n"
puts "     update starkit\n"
set dir_compile [file normalize .]
set dir_trunk   [file join [file dirname [file normalize .]] trunk]
set dir_version [file join [file dirname [file normalize .]] ___version/newVersion]
set vfsDir [file join $dir_compile rattleCAD.vfs]

puts "   -> $vfsDir"
puts "   -> $dir_compile"
puts "   -> $dir_trunk"
puts "   -> $dir_version"


	# -- cleanup $dir_compile
	#
puts "\n ========================\n"
puts "         cleanup complete\n"

file_delete [file join $vfsDir help.txt]
file_delete [file join $vfsDir license.txt]
file_delete [file join $vfsDir exclusion.txt]
file_delete [file join $vfsDir main.tcl]
file_delete [file join $vfsDir tclkit.inf] 
file_delete [file join $vfsDir tclkit.ico] 
file_delete [file join $vfsDir rattleCAD.tcl]
file_delete [file join $vfsDir simplify_SVG.tcl]
file_delete [file join $vfsDir Tcl.svg]
file_delete [file join $vfsDir tclTk.svg]

file_delete [file join $vfsDir etc]
file_delete [file join $vfsDir image]
file_delete [file join $vfsDir lib]

	# -- update $dir_compile
	#
puts "\n ========================\n"
puts "         update\n"

file_update [file join $dir_trunk      etc]  $vfsDir
file_update [file join $dir_trunk    image]  $vfsDir
file_update [file join $dir_trunk      lib]  $vfsDir
foreach _dir [glob -directory [file join $dir_compile   _lib] *] {
	file_update $_dir [file join $vfsDir lib]
}

file_update [file join $dir_trunk help.txt]       	$vfsDir
file_update [file join $dir_trunk license.txt]    	$vfsDir
file_update [file join $dir_trunk exclusion.txt]  	$vfsDir
file_update [file join $dir_trunk main.tcl]  		$vfsDir
file_update [file join $dir_trunk tclkit.inf]  		$vfsDir
file_update [file join $dir_trunk tclkit.ico]  		$vfsDir
file_update [file join $dir_trunk rattleCAD.tcl]  	$vfsDir
file_update [file join $dir_trunk simplify_SVG.tcl] $vfsDir
file_update [file join $dir_trunk Tcl.svg] 			$vfsDir
file_update [file join $dir_trunk tclTk.svg] 		$vfsDir

	# -- remove unused files
	#
	# -- update $dir_compile
	#
puts "\n ========================\n"
puts "         cleanup\n"
	# -- etc
foreach file [findFiles [file join $vfsDir etc] *.cdr {f r}] {
	file_delete $file
}
foreach file [findFiles [file join $vfsDir etc] *.jpg {f r}] {
	file_delete $file
}
foreach file [findFiles $vfsDir .svn {d r hidden} ] {
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

file_update [file join $vfsDir  help.txt]			$dir_version
file_update [file join $vfsDir  license.txt]    	$dir_version
file_update [file join $vfsDir  exclusion.txt]  	$dir_version
file_update [file join $vfsDir  main.tcl]  			$dir_version
file_update [file join $vfsDir  tclkit.ico]  		$dir_version
file_update [file join $vfsDir  rattleCAD.tcl]  	$dir_version
file_update [file join $vfsDir  simplify_SVG.tcl]	$dir_version
file_update [file join $vfsDir  Tcl.svg]			$dir_version
file_update [file join $vfsDir  tclTk.svg]			$dir_version

file_update [file join $vfsDir  etc      ]                          $dir_version
file_update [file join $vfsDir  image    ]                          $dir_version
file_update [file join $vfsDir  lib/_apputil      ]                 [file join $dir_version lib]
file_update [file join $vfsDir  lib/_canvasCAD    ]                 [file join $dir_version lib]
file_update [file join $vfsDir  lib/_extSummary   ]                 [file join $dir_version lib]
file_update [file join $vfsDir  lib/app-rattleCAD ]                 [file join $dir_version lib]
file_update [file join $vfsDir  lib/test_canvas_CAD_ChainWheel.tcl] [file join $dir_version lib]
file_update [file join $vfsDir  lib/test_canvas_CAD_Dimension.tcl ] [file join $dir_version lib]
file_update [file join $vfsDir  lib/test_canvas_CAD_notebook.tcl  ] [file join $dir_version lib]
file_update rattleCAD.exe                                           $dir_version


	# -- ready 
	#
puts "\n ========================\n"
puts "         ready ! \n\n\n"

return