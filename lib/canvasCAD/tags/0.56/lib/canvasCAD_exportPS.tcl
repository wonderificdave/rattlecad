
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


	proc canvasCAD::export_PostScript { cv_name printFile {tagID {}} {printFormat {}} {orient {landscape}}} {
                #
                #
                # ... tagID ......... ID of a canvas Object, maybe be an invisible background
                # ... printFormat ... DIN-Formats: A5, A4, A3, ...
                # ... orient..... ... landscape, portrait
                #
                #
		set canvasDOMNode	[getNodeRoot [format "/root/instance\[@id='%s'\]" $cv_name] ]
			#
		set w			[ canvasCAD::getNodeAttribute  	$canvasDOMNode	Canvas	path   ]			
		set wScale		[ canvasCAD::getNodeAttribute  	$canvasDOMNode	Canvas	scale  ]			
		set stageUnit	[ canvasCAD::getNodeAttribute  	$canvasDOMNode	Stage	unit   ]
		set unitScale   [ canvasCAD::get_unitRefScale   $stageUnit ]
        set DIN_Format	[ canvasCAD::getNodeAttribute  	$canvasDOMNode	Stage	format ]			
		set FormatSize  [ $cv_name getFormatSize $DIN_Format]
            #
		puts "\n"
 		puts "         export_PostScript:"
 		puts "       ---------------------------------------------"
 		puts "               $cv_name"
 		puts "               $printFile"
 		puts "            ----------------------------------------"
		puts ""
  	    puts "               w           $w			"
 		puts "               wScale      $wScale	"
 		puts "               stageUnit   $stageUnit "
 		puts "               unitScale   $unitScale "
 		puts "               DIN_Format  $DIN_Format"
 		puts "               FormatSize  $FormatSize"
 		puts ""
            #
        set pageWidth   [lindex $FormatSize 0]
        set pageHeight  [lindex $FormatSize 1]
        set pageOrient  1 
        set pageAnchor  nw
        set pageX       0
        set pageY       0
            #
        puts "               pageWidth   $pageWidth	"
        puts "               pageHeight  $pageHeight"
        puts ""
            #
            # tk_messageBox -message " print_postscript"
        if {[catch {set coords   [$w coords __Stage__]} eID]} {
            puts ""
            puts "  ... could not get canvasObject __Stage__"
            puts ""
            return {_noFile_}
        }
            #
        set areaSize	    [get_BBoxInfo  size  $coords ]
        set areaWidth 	    [lindex $areaSize 0]
        set areaHeight 	    [lindex $areaSize 1]
        set area_x		    [lindex $coords 0]
        set area_y		    [lindex $coords 1]
            #
        puts " ----------------------"
        puts "               coords         $coords	"
        puts "               areaWidth    $areaWidth  [expr $areaWidth * $wScale]"
        puts "               areaHeight   $areaHeight  [expr $areaHeight * $wScale]"
        puts "               area_x       $area_x"
        puts "               area_y       $area_y"
        puts " ----------------------"
            #
            
            #
            # -- the exception to print an area given by tagID
            #
            #
        if {$tagID != {}} {
                #
            set bboxScale   [expr $areaWidth /$pageWidth]
                #
            if {[catch {set bbox   [$w coords $tagID]} eID]} {
                puts ""
                puts "     <E> ... could not get canvasObject: __Stage__"
                puts ""
                return {_noFile_}
            }
            if {$printFormat != {}} {
                set FormatSize  [ $cv_name getFormatSize $printFormat]
            }
                #
            puts "             tagID          $tagID"
            puts "             printFormat    $printFormat"
            puts "             orient         $orient"
            puts "               bbox           $bbox"
            puts "               bboxScale    $bboxScale"
                #
            set areaSize	    [get_BBoxInfo  size  $bbox ]
            set areaWidth 	    [lindex $areaSize 0]
            set areaHeight 	    [lindex $areaSize 1]
            set area_x		    [lindex $bbox 0]
            set area_y		    [lindex $bbox 1]
                #
            puts "               areaWidth    $areaWidth  [expr $areaWidth / $bboxScale]"
            puts "               areaHeight   $areaHeight  [expr $areaHeight / $bboxScale]"
            puts "               area_x       $area_x"
            puts "               area_y       $area_y"
                # set areaWidth 	    [expr $bboxScale * [lindex $areaSize 0]]
                # set areaHeight 	[expr $bboxScale * [lindex $areaSize 1]]
                # set area_x		    [expr $bboxScale * [lindex $bbox 0]]
                # set area_y		    [expr $bboxScale * [lindex $bbox 1]]
            set pageWidth       [expr round($areaWidth  / $bboxScale)]
            set pageHeight      [expr round($areaHeight / $bboxScale)]
                # set pageWidth       [expr $pageWidth  + $area_x / $bboxScale]
                # set pageHeight      [expr $pageHeight + $area_y / $bboxScale]
            puts "               pageWidth       $pageWidth"
            puts "               pageHeight      $pageHeight"
                #
            switch $orient {
                portrait {  set pageOrient      0 
                            set pageAnchor      sw
                            set formatWidth     [lindex $FormatSize 1]
                            set formatHeight    [lindex $FormatSize 0]
                    }
                landscape -
                default  {  set pageOrient      1 
                            set pageAnchor      nw
                            set formatWidth     [lindex $FormatSize 0]
                            set formatHeight    [lindex $FormatSize 1]
                    }
            }
                #
            set pageX           [expr round(0.5 * ($formatWidth - $pageWidth))]
            set pageY           [expr round(0.5 * ($formatHeight - $pageHeight))]
                #
            puts "               pageOrient      $pageOrient"
            puts "               pageX           $pageX"
            puts "               pageY           $pageY"
            puts "               formatWidth     $formatWidth   [expr $formatWidth * $bboxScale]"
            puts "               formatHeight    $formatHeight   [expr $formatHeight * $bboxScale]"
                #
            puts "               FormatSize      $FormatSize"
            	#

                
        }
        puts " ----------------------"
        puts ""
            #
        set w_name          [winfo name $w]
            #
        set fileExtension [file extension $printFile]
            # puts "\n\n  -> \$fileExtension $fileExtension\n\n"
        if {$fileExtension != {.ps}} {
            set printFile		$printFile.ps
        }
  			#
            # -- remove __configCorner__
        canvasCAD::configCorner::deleteCorner $w
            #
        puts ""
        puts "          printFile   $printFile"
        puts "        -------------------------------------"
        puts "               -file        $printFile "
        puts "               -x           $area_x "
        puts "               -y           $area_y "
        puts "               -width       $areaWidth "
        puts "               -height      $areaHeight "
        puts "               -rotate      $pageOrient "
        puts "               -pageanchor  $pageAnchor "
        puts "               -pagex       [format "%s.m" $pageX] "
        puts "               -pagey       [format "%s.m" $pageY] "
        puts "               -pagewidth   [format "%s.m" $pageWidth] "
        puts "               -pageheight  [format "%s.m" $pageHeight]"
        puts "               "
        puts ""
 		puts ""

            #
            # ... this is the default option
            #   ... rotate 1 ... landscape

        if {[catch {
                $w postscript	-file        $printFile \
                                -x           $area_x \
                                -y           $area_y \
                                -width       $areaWidth \
                                -height      $areaHeight \
                                -rotate      $pageOrient \
                                -pageanchor  $pageAnchor \
                                -pagex       [format "%s.m" $pageX] \
                                -pagey       [format "%s.m" $pageY] \
                                -pagewidth   [format "%s.m" $pageWidth] \
                                -pageheight  [format "%s.m" $pageHeight] } eID]} \
        {
                puts "   .. $eID"
        }
        
			#
        puts "               pageWidth       $pageWidth"
        puts "               pageHeight      $pageHeight"
        puts ""
            #
            
            # -- update __configCorner__
        canvasCAD::configCorner::updateSelf $w
            #
            
        if {$printFormat == {}} {
            set printFormat $DIN_Format
        }
        
            # -- return fileName
		if {[file exists $printFile]} {
                #
            add_psComment $printFile $printFormat $orient
			return $printFile 
                #
		} else {
                #
            puts "\n      <E>  .. no File?\n"
            return {_noFile_}
                #
		}
	}


	proc canvasCAD::start_psview {ps_file} {
     
        set postsript_ext   [file extension $ps_file]
  
        puts "\n"
        puts  "         start_psview:"
        puts  "       ---------------------------------------------"
        puts  "               tcl_version   [info tclversion]" 
        puts  "               tcl_platform  $::tcl_platform(platform)" 
        puts  "               ps_file       $ps_file" 
        puts  "               postsript_ext $postsript_ext" 

        switch $::tcl_platform(platform) {
            "windows" {
                    package require registry 1.1

                    set reg_fileext [registry keys  {HKEY_CLASSES_ROOT} $postsript_ext]
                    puts  "               reg_fileext   $reg_fileext" 
                 
                        # there the file-extension is not defined
                    if {$reg_fileext == {} } {
                        set error_message "File Type: $reg_fileext"
                        set error_message "$error_message \n  could not find a OPEN command for filetype"
                        tk_messageBox -message "$error_message"
                        puts  "  --<E>----------------------------------------------------" 
                        puts  "    <E> File Type: $reg_fileext" 
                        puts  "    <E> could not find a OPEN command for filetype" 
                        puts  "  --<E>----------------------------------------------------" 
                        return
                    }

                        # get the filetype 
                    set reg_filetype [registry get HKEY_CLASSES_ROOT\\$reg_fileext {}]
                    puts  "               reg_filetype  $reg_filetype" 
               
                        # Work out where to look for the command
                    set path HKEY_CLASSES_ROOT\\$reg_filetype\\Shell\\Open\\command
                    puts  "               path          $path" 

                        # Read the command!
                    set print_app [registry get $path {}]
                    puts  "               Filetype $postsript_ext opens with $print_app" 

                        # there is no command defined for the filetype
                    if {$print_app == {} } {
                        set error_message "File Type: $reg_fileext"
                        set error_message "$error_message \n  could not find a OPEN command for filetype"
                        tk_messageBox -message "$error_message"
                        puts  "  --<E>----------------------------------------------------" 
                        puts  "    <E> File Type: $reg_fileext" 
                        puts  "    <E> could not find a OPEN command for filetype\n" 
                        puts  "  --<E>----------------------------------------------------" 
                        return
                    }
                   
                        # Just the command!
                    set print_app [lindex [split $print_app \"] 1]
                     
                        # Run the command!
                    puts  "  $print_app  $ps_file"                    
                    exec $print_app $ps_file &
                     
                        # finish!
                    puts  "      ... done"  
                    return
                }
            default {
                    puts  "\n"  
                    puts  "  --<W>----------------------------------------------------" 
                    puts  "     sorry !"  
                    puts  "     it seems that there is currently no direct connection "
                    puts  "        to a printer for this platform yet"  
                    puts  "  --<W>----------------------------------------------------" 
                    puts  "\n"  
                }
        }
        return
	} 


    proc round {number {digits 0}} {
        if { $digits} {
            return [expr {round(pow(10,$digits)*$number)/pow(10,$digits)}]
        } else {
            return [ format "%.0f" [expr {round(pow(10,$digits)*$number)/pow(10,$digits)}]]
        }
    }


    proc canvasCAD::get_DIN_Length {length} {
            #
        variable DIN_Format
            #
        set DIN_Lengths [dict keys [dict get $DIN_Format ps]]
            # puts "                -> $DIN_Lengths"
        set lengthTop     [expr 1.01 * $length]
        set lengthBottom  [expr 0.99 * $length]
        foreach DIN_Length $DIN_Lengths {
            if {$lengthTop > $DIN_Length} {
                  # puts "         -> $lengthTop > $DIN_Length > $lengthBottom"
                if {$lengthBottom < $DIN_Length} {
                    # puts "    got it:  $length -> $DIN_Length"
                    return $DIN_Length
                } else {
                    # puts "    exception:  $length -> $DIN_Length"
                    return $length
                }
            }
        }
       return 
    }


    proc canvasCAD::get_DIN_Format {width height} {
            #
        variable DIN_Format
            #
        set DIN_Lengths [dict keys [dict get $DIN_Format ps]]
            # puts "                -> $DIN_Lengths"
        set widthTop      [expr 1.01 * $width]
        set widthBottom   [expr 0.99 * $width]
        set heightTop     [expr 1.01 * $height]
        set heightBottom  [expr 0.99 * $height]
            #
        set indexWidth    {}
        set indexHeight   {}
        set resultWidth   {}
        set resultHeight  {}
            #
        foreach DIN_Length $DIN_Lengths {
            if {$widthTop > $DIN_Length} {
                if {$widthBottom < $DIN_Length} {
                    set indexWidth [dict get $DIN_Format ps $DIN_Length]
                    break
                } else {
                    set resultWidth $width
                    break
                }
            }
        }
            #
        foreach DIN_Length $DIN_Lengths {
            if {$heightTop > $DIN_Length} {
                if {$heightBottom < $DIN_Length} {
                    set indexHeight [dict get $DIN_Format ps $DIN_Length]
                    break
                } else {
                    set resultHeight $height
                    break
                }
            }
        }
            #
        # puts "                 ... $width $height "
        # puts "                 ... $indexWidth $indexHeight "
        # puts "                 ... $resultWidth $resultHeight "
            #
        if {$indexWidth != {}} {
            if {$indexHeight != {}} {
                if {$indexWidth < $indexHeight} {
                    return [format "%s_landscape" $indexWidth]
                } else {
                    return [format "%s_portrait" $indexHeight]
                }
            } else {
                    return [format "%s_%s" $width $height]         
            }
        } else {
          return [format "%s_%s" $width $height]
        }

    }


    proc canvasCAD::init_DIN_Format {} {
            #
        variable DIN_Format
            #
        set DIN_Format \
              [dict create mm  \
                              [list \
                                  4A0   2378 \
                                  2A0   1682 \
                                  A0 	1189 \
                                  A1 	 841 \
                                  A2 	 594 \
                                  A3 	 420 \
                                  A4 	 297 \
                                  A5 	 210 \
                                  A6 	 148 \
                                  A7 	 105 \
                                  A8 	  74 \
                                  A9 	  52 \
                                  A10     37 \
                              ]     
                          ]
        set psValues {}
        foreach landscapeKey [dict keys [dict get $DIN_Format mm]] {
            set landscapeWidth    [dict get $DIN_Format mm $landscapeKey]
            set landscapeWidthPS  [round [expr 72 * 1.0 * $landscapeWidth / 25.4]]
              # puts "          ... $landscapeKey - $landscapeWidth -> $landscapeWidthPS"
            append psValues "$landscapeWidthPS $landscapeKey "
        }
        dict set DIN_Format ps $psValues
    } 


    proc canvasCAD::add_psComment {fileName dinFormat orient} {
            #
        puts "  ... \$fileName .... $fileName"
        puts "  ... \$dinFormat ... $dinFormat"
        puts "  ... \$orient ...... $orient"
            #
        set   fd [open $fileName r]
        set   lineData [split [read $fd] "\n"]
        close $fd
            #
        set   lineData [linsert $lineData 1 "%!canvasCAD: DIN $dinFormat"]    
        set   lineData [linsert $lineData 2 "%!canvasCAD: orient $orient"]    
            #
        set   fd [open $fileName "w+"]
        puts  $fd [join $lineData "\n"]
        close $fd             
            #
            #
            #
        set   fd [open $fileName "r"]
        gets $fd line(first)    
        gets $fd line(second)    
        gets $fd line(third)   
        puts " <i> $line(first)"
        puts " <i> $line(second)"
        puts " <i> $line(third)"
        close $fd             
            #
        return
            #
    }


    canvasCAD::init_DIN_Format