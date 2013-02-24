# ============================================
#
#	canvasCAD_print
#
# ============================================

	proc canvasCAD::printPostScript { canvasDOMNode printDir} {
			set w			[ canvasCAD::getNodeAttribute  	$canvasDOMNode	Canvas	path  ]			
			set wScale		[ canvasCAD::getNodeAttribute  	$canvasDOMNode	Canvas	scale ]			
			set Unit		[ canvasCAD::getNodeAttribute  	$canvasDOMNode	Stage	unit  ]
        
        # ::Debug  p  1

  	     
        set page_a4_width   297
        set page_a4_height  210
        
          # tk_messageBox -message " print_postscript"
        set bbox      [$w bbox __Stage__]
			# set bbox_size [get_BBoxInfo  size  [$w bbox __Stage__] ]
		set bbox_size [get_BBoxInfo  size  $bbox ]
        set bbox_x    [lindex $bbox_size 0]
        set bbox_y    [lindex $bbox_size 1]
        set cv_size   [get_Size $w]
        
           # debug::create
        # ::Debug  t  "bbox         $bbox"       1
        # ::Debug  t  "bbox size    $bbox_size"  1
        # ::Debug  t  "bbox size x  $bbox_x"     1
        # ::Debug  t  "bbox size y  $bbox_y"     1
        # ::Debug  t  "cv   size    $cv_size"     1
        
        if {[expr $bbox_x/sqrt(2)] < $bbox_y} {
           set bbox_x [expr $bbox_y*sqrt(2)] 
        }
        
        #control::get_user_dir
        # ::Debug  t  "control::get_user_dir   $control::USER_Dir"     1

        set w_name          [winfo name $w]
        # set printfile_name	$printFile
		set printfile_name  [file join $printDir __print_$w_name.ps]
        # ::Debug  t  "printfile_name   $printfile_name"     1
        
		#$w move __Stage__ 		-3000 -3000
		#$w move __StageShadow__ -3000 -3000
		
        $w postscript  -file        $printfile_name \
                       -rotate      1         \
                       -width       $bbox_x   \
                       -height      $bbox_y   \
                       -x           [lindex $bbox 0] \
                       -y           [lindex $bbox 1] \
                       -pagewidth   [format "%sm" $page_a4_width] \
                       -pageheight  [format "%sm" $page_a4_height] \
                       -pageanchor  sw \
                       -pagex       [format "%sm" $page_a4_height] \
                       -pagey       0m	
        
		#$w move __Stage__ 		 3000  3000
		#$w move __StageShadow__  3000  3000
		
        start_psview  $printfile_name
	}
   
	proc canvasCAD::start_psview {ps_file} {
          
     
        puts  "tcl_version   [info tclversion]" 
        puts  "tcl_platform  $::tcl_platform(platform)" 
        puts  "ps_file       $ps_file" 
                           
        set postsript_ext   [file extension $ps_file]
  
        puts  "postsript_ext $postsript_ext" 

        switch $::tcl_platform(platform) {
			"windows" {
					package require registry 1.1

					set reg_fileext [registry keys  {HKEY_CLASSES_ROOT} $postsript_ext]
					puts  "reg_fileext   $reg_fileext" 
				 
						# there the file-extension is not defined
					if {$reg_fileext == {} } {
						set error_message "File Type: $reg_fileext"
						set error_message "$error_message \n  could not find a OPEN command for filetype"
						tk_messageBox -message "$error_message"
						puts  " <E> File Type: $reg_fileext" 
						puts  " <E> could not find a OPEN command for filetype" 
						return
					}

						# get the filetype 
					set reg_filetype [registry get HKEY_CLASSES_ROOT\\$reg_fileext {}]
					puts  "reg_filetype  $reg_filetype" 
			   
						# Work out where to look for the command
					set path HKEY_CLASSES_ROOT\\$reg_filetype\\Shell\\Open\\command
					puts  "path          $path" 

						# Read the command!
					set print_app [registry get $path {}]
					puts  "Filetype $postsript_ext opens with $print_app" 

						# there is no command defined for the filetype
					if {$print_app == {} } {
						set error_message "File Type: $reg_fileext"
						set error_message "$error_message \n  could not find a OPEN command for filetype"
						tk_messageBox -message "$error_message"
						puts  " <E> File Type: $reg_fileext" 
						puts  " <E> could not find a OPEN command for filetype" 
						return
					}
                   
						# Just the command!
					set print_app [lindex [split $print_app \"] 1]
                     
						# Run the command!
					puts  "$print_app  $ps_file"                    
					exec $print_app $ps_file &
                     
						# finish!
					puts  "$print_app  $ps_file done"  
					return
				}
			default {
					puts  "sorry !"  
					puts  "  it seems that there is currently no direct connection "
					puts  "      to a printer for this platform yet"  
				}
		}
		return
	}
  