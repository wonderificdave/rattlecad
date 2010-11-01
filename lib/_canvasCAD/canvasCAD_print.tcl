
 ##+##########################################################################
 #
 # package: canvasCAD	->	canvasCAD_print.tcl
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
 #	namespace:  canvasCAD
 # ---------------------------------------------------------------------------
 #
 #


	proc canvasCAD::printPostScript { cv_name printDir} {
			
			set canvasDOMNode	[getNodeRoot [format "/root/instance\[@id='%s'\]" $cv_name] ]
									
			set w			[ canvasCAD::getNodeAttribute  	$canvasDOMNode	Canvas	path   ]			
			set wScale		[ canvasCAD::getNodeAttribute  	$canvasDOMNode	Canvas	scale  ]			
			set Unit		[ canvasCAD::getNodeAttribute  	$canvasDOMNode	Stage	unit   ]
			set Format		[ canvasCAD::getNodeAttribute  	$canvasDOMNode	Stage	format ]			
			set FormatSize  [ $cv_name getFormatSize $Format]
			
			puts "\n"
 			puts "         printPostScript:"
 			puts "       ---------------------------------------------"
 			puts "               $cv_name"
 			puts "               $printDir"
 			puts "            ----------------------------------------"
			puts ""
  			puts "               w           $w			"
 			puts "               wScale      $wScale	"
 			puts "               Unit        $Unit		"
 			puts "               Format      $Format	"
 			puts "               FormatSize  $FormatSize"
 			puts ""
  	     
        set pageWidth   [lindex $FormatSize 0]
        set pageHeight  [lindex $FormatSize 1]
        
  			puts "               pageWidth   $pageWidth	"
 			puts "               pageHeight  $pageHeight"
 			puts ""

			# tk_messageBox -message " print_postscript"
		set printBorder	50
        set bbox		[$w bbox __Stage__]
		set stageSize	[get_BBoxInfo  size  $bbox ]
        set stageWidth	[lindex $stageSize 0]
        set stageHeight	[lindex $stageSize 1]
		set stage_x		[lindex $bbox 0]
		set stage_y		[lindex $bbox 1]
        
  			puts "               bbox         $bbox	"
  			puts "               stageWidth   $stageWidth"
  			puts "               stageHeight  $stageHeight"
  			puts "               stage_x      $stage_x"
  			puts "               stage_y      $stage_y"
  			puts "               printBorder  $printBorder"
 			puts ""

		set w_name          [winfo name $w]
		set printFile  [file join $printDir __print_$w_name.ps]
  			
 			puts "               printFile   $printFile"
 			puts ""
        
        $w postscript	-file        $printFile \
						-rotate      1         \
						-width       $stageWidth \
						-height      $stageHeight \
						-x           $stage_x \
						-y           $stage_y \
						-pageanchor  nw \
						-pagewidth   [format "%s.m" $pageWidth] \
						-pageheight  [format "%s.m" $pageHeight] 
					   
					#$w postscript  -file        $printFile \
								   -rotate      1         \
								   -width       $stageWidth \
								   -height      $stageHeight \
								   -x           $stage_x \
								   -y           $stage_y \
								   -pagewidth   [format "%s.m" [expr $pageWidth  - 2*$printBorder] ] \
								   -pageheight  [format "%s.m" [expr $pageHeight - 2*$printBorder] ] 
								   
					#$w postscript  -file        $printFile \
								   -rotate      1         \
								   -width       [ expr $stageWidth  - 2 * $printBorder ]  \
								   -height      [ expr $stageHeight - 2 * $printBorder ] \
								   -x           [ expr $stage_x + $printBorder ] \
								   -y           [ expr $stage_y + $printBorder ]
								   
								   #-x           $stage_x \
								   -y           $stage_y 
								   
					#$w postscript  -file        $printFile \
								   -rotate      1         \
								   -pagewidth   [format "%s.m" $pageWidth] \
								   -pageheight  [format "%s.m" $pageHeight] \
								   -pageanchor  nw \
								   -pagex       [format "%s.m" [expr 0 + $printBorder]] \
								   -pagey       [format "%s.m" [expr $pageHeight - $printBorder]]	\
								   -width       $stageWidth   \
								   -height      $stageHeight  \
								   -x           $stage_x \
								   -y           $stage_y 
								   
								   # -pagex       [format "%sm" $pageHeight] 
								   # -pagey       0m	

		
        start_psview  $printFile
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
					puts  "\n"  
					puts  "sorry !"  
					puts  "  it seems that there is currently no direct connection "
					puts  "      to a printer for this platform yet"  
					puts  "\n"  
				}
		}
		return
	}
  