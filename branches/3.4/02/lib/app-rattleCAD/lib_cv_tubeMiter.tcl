 ##+##########################################################################
 #
 # package: rattleCAD   ->  lib_bikeRendering.tcl
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
 #  namespace:  rattleCAD::rendering
 # ---------------------------------------------------------------------------
 #
 #

 namespace eval rattleCAD::tubeMiter {        
        #
    variable tubeMiter  
    variable canvas_Name
        # variable pdfExport  
        #
 }


    proc rattleCAD::tubeMiter::create {cv_Name} {
            #
            #
        variable tubeMiter
        variable canvas_Name
            # variable pdfExport
            #
        set canvas_Name $cv_Name
            #
        set tubeMiter [rattleCAD::model::get_TubeMiterDICT]
            #
            # first row
        set width_01_01    [dict get $tubeMiter TopTube_Head    minorPerimeter]
        set width_01_02    [dict get $tubeMiter DownTube_Head   minorPerimeter]
        set width_01_03    [dict get $tubeMiter SeatStay_01     minorPerimeter]
            # second row
        set width_02_01    [dict get $tubeMiter TopTube_Seat    minorPerimeter]
        set width_02_02    [dict get $tubeMiter DownTube_Seat   minorPerimeter]
        set width_02_03    [dict get $tubeMiter SeatTube_Down   minorPerimeter]
            #
            # column 01
        if {$width_01_01 > $width_02_01} {
            set column_01 $width_01_01
        } else {
            set column_01 $width_02_01
        }
            #
            # column 02
        if {$width_01_02 > $width_02_02} {
            set column_02 $width_01_02
        } else {
            set column_02 $width_02_02
        }
            #
            #
        set gap_01 [expr (420 - 10 - ($column_01 + $column_02 + 2*$width_01_03)) / 5]
        set gap_02 [expr (420 - 10 - ($column_01 + $column_02 + $width_02_03))     / 4]
            #
        if {[expr 2*$width_01_03 + $gap_01] > $width_02_03} {
            set gapWidth $gap_01
            set column_03 [expr 2 * $width_01_03 + $gapWidth]
        } else {
            set gapWidth $gap_02
            set column_03 $width_02_03
        }
            #
        set column_max $column_01
        if {$column_02 > $column_max} {set column_max $column_02}
        if {$column_03 > $column_max} {set column_max $column_03}
            #
        set column_01_offset    [expr 0.5 * ($column_max - $column_01)]     
        set column_02_offset    [expr 0.5 * ($column_max - $column_02)]     
        set column_03_offset    [expr 0.5 * ($column_max - $column_03)]     
            #
            #
        # set summaryWidth [expr $column_01 + $column_02 + $column_03]
        # set summaryFree  [expr 420 - 10 - $summaryWidth]
        # set gapWidth     [expr $summaryFree / 5]
            #
        set pos_01_x    [expr 5 + 1*$gapWidth + 0.5*$column_01]
        set pos_02_x    [expr 5 + 2*$gapWidth + $column_01 + 0.5*$column_02]
        set pos_03_x    [expr 5 + 3*$gapWidth + $column_01 + $column_02 + 0.5*$column_03]
        set pos_03_x1   [expr $pos_03_x - 0.5*($gapWidth + $width_01_03)]
        set pos_03_x2   [expr $pos_03_x + 0.5*($gapWidth + $width_01_03)]
        # set pos_03_x1   [expr 5 + 3*$gapWidth + $column_01 + $column_02 + 0.5*$width_01_03]
        # set pos_03_x2   [expr 5 + 4*$gapWidth + $column_01 + $column_02 + 1.5*$width_01_03]
            #
            #
        set pos_01_01   [list $pos_01_x  250]
        set pos_01_02   [list $pos_02_x  250]
        set pos_01_03   [list $pos_03_x1 250]
        set pos_01_04   [list $pos_03_x2 250]
            #
        set pos_02_01   [list $pos_01_x  145]
        set pos_02_02   [list $pos_02_x  145]
        set pos_02_03   [list $pos_03_x  145]
            #
        set pos_03_01   [list $pos_01_x   40]
        set pos_03_03   [list $pos_03_x   40]
            #
            
            #
            # draw miterArea 01   
        set x1  [expr round($pos_01_x - 0.5*$column_01 - 8)]
        set y1  55
        set x2  [expr round($pos_01_x + 0.5*$column_01 + 8)]
        set y2  270
        set miterArea_01    [ list $x1 $y1 $x2 $y2 ]
        $cv_Name create rectangle   $miterArea_01   -outline {}  -fill {}  -tags __miterArea_01__    
            #
            # draw miterArea 01
        set x1  [expr round($pos_02_x - 0.5*$column_02 - 8)]
        set y1  55
        set x2  [expr round($pos_02_x + 0.5*$column_02 + 8)]
        set y2  270
        set miterArea_02    [ list $x1 $y1 $x2 $y2 ]
        $cv_Name create rectangle   $miterArea_02   -outline {}  -fill {}  -tags __miterArea_02__    
            #
            # draw miterArea 01
        set x1  [expr round($pos_03_x - 0.5*$column_03 - 8)]
        set y1  55
        set x2  [expr round($pos_03_x + 0.5*$column_03 + 8)]
        set y2  270
        set miterArea_03    [ list $x1 $y1 $x2 $y2 ]
        $cv_Name create rectangle   $miterArea_03   -outline {}  -fill {}  -tags __miterArea_03__    
            #
            #
            # draw miter: 1st row
        drawMiter $cv_Name  $pos_01_01  TopTube_Head
        drawMiter $cv_Name  $pos_01_02  DownTube_Head
        drawMiter $cv_Name  $pos_01_03  SeatStay_02
        drawMiter $cv_Name  $pos_01_04  SeatStay_01
            #
            # draw miter: 2nd row
        drawMiter $cv_Name  $pos_02_01  TopTube_Seat   rotate
        drawMiter $cv_Name  $pos_02_02  DownTube_Seat  rotate 
        drawMiter $cv_Name  $pos_02_03  SeatTube_Down  rotate
            #   
            #   
        drawMiter $cv_Name  $pos_03_03  Reference
            #
            
            #
        if 0 {
                #
            set pageHeight 297   ;# height A3, landscape
            set psFactor   [expr pow(sqrt(2), 3)]
                #
            set pdfExport   [dict create \
                                    cv_Name $cv_Name \
                                    area_01 {} \
                                    area_02 {} \
                                    area_03 {} ]
                #
            foreach {name bbox offset_x} \
                        [list   area_01 $miterArea_01 $column_01_offset\
                                area_02 $miterArea_02 $column_02_offset\
                                area_03 $miterArea_03 $column_03_offset] \
            {
                puts $bbox
                foreach {x1 y1 x2 y2} $bbox break
                dict set pdfExport  $name   area $bbox
                set x_1   [expr round($psFactor * ($pageHeight - $y2))]
                set y_1   [expr round($psFactor *  $x1)]
                set x_2   [expr round($psFactor * ($pageHeight - $y1))]
                set y_2   [expr round($psFactor *  $x2)]
                dict set pdfExport  $name   x1          $x_1
                dict set pdfExport  $name   y1          $y_1
                dict set pdfExport  $name   x2          $x_2
                dict set pdfExport  $name   y2          $y_2
                dict set pdfExport  $name   bbox       "$x_1 $y_1 $x_2 $y_2"
                dict set pdfExport  $name   offset_x    $offset_x
            }
                #
            appUtil::pdict $pdfExport
                #
        }
            #
            #
        # exportPS_Areas
            #
        # set exportFile [file join $::APPL_Config(EXPORT_PDF) try_tubeMiter_01.pdf]
        # puts "      ... $exportFile"
        # $cv_Name exportPDF $exportFile 
            #
        return
            #
        
    }


    proc rattleCAD::tubeMiter::drawMiter {cv_Name xy type {rotation {no}}} {
            #
        variable tubeMiter    
            #
            # puts "  \$type $type"    
            #
        set minorName       [dict get $tubeMiter $type minorName]
        set minorDiameter   [dict get $tubeMiter $type minorDiameter]
        set minorAngle      [dict get $tubeMiter $type minorDirection]
        set majorName       [dict get $tubeMiter $type majorName]
        set majorDiameter   [dict get $tubeMiter $type majorDiameter]
        set majorAngle      [dict get $tubeMiter $type majorDirection]
        set offset          [dict get $tubeMiter $type offset]
        set polygon         [dict get $tubeMiter $type polygon_01]
        set perimeter       [dict get $tubeMiter $type minorPerimeter]
            #
        set polygon_in  {}
        set polygon_out {}
        catch {set polygon_in  [dict get $tubeMiter $type polygon_02]}
        catch {set polygon_out [dict get $tubeMiter $type polygon_03]}
            #catch {set polygon_in  $polygon_in  0 end-2]}
            #catch {set polygon_out $polygon_out 0 end-2]}
            #puts $polygon_in
            #puts $polygon_out
            # exit    
            
        if {$rotation == {no}} {
            set Miter(polygon)      [ vectormath::addVectorPointList $xy  $polygon]
            set Miter(polygon_out)  [ vectormath::addVectorPointList $xy  $polygon_out]
            set Miter(polygon_in)   [ vectormath::addVectorPointList $xy  $polygon_in]
        } else {                        
            set       polygon       [ vectormath::rotatePointList {0 -35} $polygon     180]
            set       polygon_out   [ vectormath::rotatePointList {0 -35} $polygon_out 180]
            set       polygon_in    [ vectormath::rotatePointList {0 -35} $polygon_in  180]
            set Miter(polygon)      [ vectormath::addVectorPointList $xy  $polygon]
            set Miter(polygon_out)  [ vectormath::addVectorPointList $xy  $polygon_out]
            set Miter(polygon_in)   [ vectormath::addVectorPointList $xy  $polygon_in]
        }

                # --- mitter polygon
                #
        $cv_Name create polygon $Miter(polygon)     -fill white -outline black
        catch {$cv_Name create line    $Miter(polygon_in)  -fill black}
        catch {$cv_Name create line    $Miter(polygon_out) -fill black}
        
                
        switch $type {
            DownTube_Seat -
            SeatTube_Down {
                catch {set diameter_in  [dict get $tubeMiter $type diameter_02]}
                catch {set diameter_out [dict get $tubeMiter $type diameter_03]}
                    #
                set _addText    "($diameter_in/$diameter_out)"
                }
            default {
                set _addText    ""
                }
        }
        
        
            #   
        set Miter(header) [format "%s / %s"  $minorName $majorName]    
            #
        
            # --- polygon reference lines
            #
        switch $type {

            Reference {
                            # --- defining values
                            #
                        set Miter(text_01)     "Reference: 100.00 x 10.00 "
                        set textPos     [vectormath::addVector $xy {10 3}]
                    $cv_Name create draftText $textPos  -text $Miter(text_01) -size 2.5
                    }
            default {                   
                            # --- defining values
                            #
                        set Miter(text_01)     "diameter: $minorDiameter / $majorDiameter  $_addText"
                            #set     minorAngle          [ vectormath::angle {0 1} {0 0} $minorDirection   ]
                            #set     majorAngle          [ vectormath::angle {0 1} {0 0} $majorDirection   ]                         
                            #
                        set     angle               [ expr abs($majorAngle - $minorAngle) ]
                        if {$angle > 90} {set angle [expr 180 - $angle]}
                        set     angle [ format "%.3f" $angle ]
                        set     angleComplement     [ format "%.3f" [ expr 180 - $angle ] ]
                            #
                        set Miter(text_02)     "angle:  $angle / $angleComplement"
                        set Miter(text_03)     "offset: $offset"
                        set Miter(text_04)     "perimeter:  [ format "%.3f" $perimeter]"
                           #
                        set pt_01   [ vectormath::addVector $xy {0  5} ]
                        set pt_02   [ vectormath::addVector $xy {0 -75} ]

                        if {$rotation == {no}} {                
                                    #
                                set pt_03   [ rattleCAD::model::coords_xy_index $Miter(polygon) end ]
                                    # puts "\$Miter(polygon) $Miter(polygon)"
                                    # puts "\$pt_03 $pt_03"
                                set pt_03   [ vectormath::addVector $pt_03 { +5 20}]
                                set pt_04   [ rattleCAD::model::coords_xy_index $Miter(polygon) end-1]
                                set pt_04   [ vectormath::addVector $pt_04 { -5 20}]
                                set pt_05   [ vectormath::addVector $pt_03 {  0 50}]
                                set pt_06   [ vectormath::addVector $pt_04 {  0 50}]
                                    #
                                set pt_10   [ vectormath::addVector $xy    {  0 -50}]
                                set pt_11   [ vectormath::addVector $pt_10 {-20  10}] 
                                    #
                                set pt_12   [ vectormath::addVector $pt_10 {-23  -5}] 
                                set pt_13   [ vectormath::addVector $pt_10 {-23  -9}] 
                                set pt_14   [ vectormath::addVector $pt_10 {-23 -13}]                                                               
                                set pt_15   [ vectormath::addVector $pt_10 {-10 -19}]                                                               
                                    #
                                set pt_logo [ vectormath::addVector $pt_10 {  0   2}] 
                                set orient_Logo s
                                    #
                        } else {    
                                    #
                                set pt_03   [ rattleCAD::model::coords_xy_index $Miter(polygon) end ]
                                set pt_03   [ vectormath::addVector $pt_03 { -5 -20}]
                                set pt_04   [ rattleCAD::model::coords_xy_index $Miter(polygon) end-1]
                                set pt_04   [ vectormath::addVector $pt_04 { +5 -20}]
                                set pt_05   [ vectormath::addVector $pt_03 {  0 -50}]
                                set pt_06   [ vectormath::addVector $pt_04 {  0 -50}] 
                                    #
                                set pt_10   [ vectormath::addVector $xy    {  0 -20}]
                                set pt_11   [ vectormath::addVector $pt_10 {-20 -13}] ;# -10 + 3
                                    #                                
                                set pt_12   [ vectormath::addVector $pt_10 {-23   2}] ;#  +5 + 3
                                set pt_13   [ vectormath::addVector $pt_10 {-23   6}] ;#  +4
                                set pt_14   [ vectormath::addVector $pt_10 {-23  10}] ;#  +4
                                set pt_15   [ vectormath::addVector $pt_10 {-10  16}]
                                    #                                       
                                set pt_logo [ vectormath::addVector $pt_10 {  0  -7}] 
                                set orient_Logo s
                                    #
                        }
                    
                    $cv_Name create centerline  [ appUtil::flatten_nestedList $pt_01 $pt_02 ]  -fill red  -width 0.25
                    $cv_Name create line        [ appUtil::flatten_nestedList $pt_03 $pt_04 ]  -fill blue -width 0.25
                    $cv_Name create centerline  [ appUtil::flatten_nestedList $pt_05 $pt_06 ]  -fill red  -width 0.25
                        #
                    $cv_Name create draftText $pt_11  -text $Miter(header)  -size 3.5
                    $cv_Name create draftText $pt_12  -text $Miter(text_01) -size 2.5
                    $cv_Name create draftText $pt_13  -text $Miter(text_02) -size 2.5
                    $cv_Name create draftText $pt_14  -text $Miter(text_03) -size 2.5
                    $cv_Name create draftText $pt_15  -text $Miter(text_04) -size 2.5
                        #
                    set tagID [rattleCAD::cv_custom::createWaterMark_Logo    $cv_Name    0.2   $pt_logo  $orient_Logo]
                        #
                    set cv [$cv_Name getCanvas]
                        #
                        # puts "    ... $tagID"
                    $cv itemconfigure $tagID -width 0.3
                        #

                }
        }

    } 

    
    proc rattleCAD::tubeMiter::exportPS_Areas {} {
            #
            #
        variable canvas_Name
            # variable pdfExport  
            #
            #
        # appUtil::pdict $pdfExport
            #
        # puts "   [dict get $pdfExport area_01   bbox]"  
        # puts "   [dict get $pdfExport area_02   bbox]"  
        # puts "   [dict get $pdfExport area_03   bbox]"  
            #
            #
            # set cv_Name [dict get $pdfExport cv_Name]
        set cv_Name $canvas_Name
            #
            # puts "\n$miterArea_01\n width: [expr [lindex $miterArea_01 2] - [lindex $miterArea_01 0]]\n"
        set exportFile [file join $::APPL_Config(EXPORT_PDF) tubeMiter_01.ps]
        $cv_Name print $exportFile  __miterArea_01__  A4  portrait 
            #
            # puts "\n$miterArea_02\n width: [expr [lindex $miterArea_02 2] - [lindex $miterArea_02 0]]\n"
        set exportFile [file join $::APPL_Config(EXPORT_PDF) tubeMiter_02.ps]
        $cv_Name print $exportFile  __miterArea_02__  A4  portrait 
            #
            # puts "\n$miterArea_03\n width: [expr [lindex $miterArea_03 2] - [lindex $miterArea_03 0]]\n"
        set exportFile [file join $::APPL_Config(EXPORT_PDF) tubeMiter_03.ps]
        $cv_Name print $exportFile  __miterArea_03__  A4  portrait 
            #
        return
            #
    }




