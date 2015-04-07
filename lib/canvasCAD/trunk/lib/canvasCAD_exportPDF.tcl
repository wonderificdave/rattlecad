
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


	proc canvasCAD::exportPDF { cv_name printFile {tagID {}} {printFormat {}} {orient {landscape}}} {
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
 		puts "         export_PDF:"
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

    proc canvasCAD::exportPDF {cv_name printFile} {
            #
            #
        # variable canvas_Name
            #
        # puts "\n\n   ... export PDF "    
        #     #
        # set exportFile [file join $::APPL_Config(EXPORT_PDF) tubeMiter_01.pdf]
        #     #
        # puts "      ... $exportFile"    
        
        pdf4tcl::new mypdf -paper a3 -margin 15mm    
        mypdf startPage    
        mypdf canvas $cv_name
        mypdf write -file $printFile
        mypdf destroy
        
        #
        # http://wiki.tcl.tk/949
        #
        #  # Example printing a canvas with pdf4info
        #  package require pdf4tcl                       ; # Get the package
        #  pdf4tcl::new mypdf -paper a4 -margin 15mm     ; # make a new pdf-object
        #  mypdf startPage                               ; # make a new page
        #  # make and fill a canvas .canv
        #  # ...
        #  mypdf canvas .canv                            ; # then put the canvas on your pdf-page
        #  mypdf write -file canvas.pdf                  ; # write to file
        #  mypdf destroy                                 ; # clean up
        #  # printing:
        #  eval exec [auto_execok start] AcroRd32.exe /p /h [list [file normalize canvas.pdf ]]        
        
        
        
        
            
    }