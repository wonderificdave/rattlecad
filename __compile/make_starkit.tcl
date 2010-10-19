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
set vfsDir [file join $dir_compile rattleCAD.vfs]

puts "   -> $vfsDir"
puts "   -> $dir_compile"
puts "   -> $dir_trunk"


	# -- cleanup $dir_compile
	#
puts "\n ========================\n"
puts "         cleanup complete\n"

file_delete [file join $vfsDir help.txt]
file_delete [file join $vfsDir license.txt]
file_delete [file join $vfsDir rattleCAD.tcl]

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

file_update [file join $dir_trunk help.txt]       $vfsDir
file_update [file join $dir_trunk license.txt]    $vfsDir
file_update [file join $dir_trunk rattleCAD.tcl]  $vfsDir

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
foreach file [findFiles $vfsDir .svn {d r hidden} ] {
	file_delete $file
}



	# -- test 
	#
exec tclkit-8.5.8-win32.upx.exe rattleCAD.vfs/main.tcl
     
	# -- update 
	#
file copy  -force tclkit-8.5.8-win32.upx.exe example.rt
   
	# -- compile 
	#
exec tclkit-8.5.8-win32.upx.exe sdx.kit wrap rattleCAD.exe -runtime example.rt


return