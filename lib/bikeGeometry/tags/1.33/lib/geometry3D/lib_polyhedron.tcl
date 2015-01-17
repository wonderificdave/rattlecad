
# polyhedron.tcl - 
# Manfred Rosenberger


namespace eval bikeGeometry::geometry3D::polyhedron {
    variable dictPolyhedron
    variable PI
    set PI [expr {4*atan(1.0)}]
}

proc bikeGeometry::geometry3D::polyhedron::create {centerLine guide_y guide_z {segmentNumber {10}} {segmentLength {10}}} {
    variable dictPolyhedron
    set dictPpolyhedron {}
    # dict set dictPolyhedron input position      $position
    dict set dictPolyhedron input centerline    $centerLine
    dict set dictPolyhedron input guide_y       $guide_y
    dict set dictPolyhedron input guide_z       $guide_z
    dict set dictPolyhedron input segmentLength $segmentLength
    dict set dictPolyhedron input segmentNumber $segmentNumber
      #
      
      #
    dict set dictPolyhedron value centerline_prepared   [prepareCenterLine  [dict get $dictPolyhedron input centerline] \
                                                                            [dict get $dictPolyhedron input guide_y] \
                                                                            [dict get $dictPolyhedron input guide_z]]
    #dict set dictPolyhedron value centerline_prepared   [polyhedron::prepareCenterLine  [dict get $dictPolyhedron value centerline]]
      #
    dict set dictPolyhedron value guide_y               [convertProfile     [dict get $dictPolyhedron input guide_y]]
    dict set dictPolyhedron value guide_z               [convertProfile     [dict get $dictPolyhedron input guide_z]]
      #
    dict set dictPolyhedron value shape                 [extrudeShape       [dict get $dictPolyhedron value centerline_prepared] \
                                                                            [dict get $dictPolyhedron value guide_y] \
                                                                            [dict get $dictPolyhedron value guide_z] \
                                                                            [dict get $dictPolyhedron input segmentNumber]]
      #
    dict set dictPolyhedron value shapepoints           [getShapePoints     [dict get $dictPolyhedron value shape]]
    dict set dictPolyhedron value shapefaces            [getShapeFaces      [dict get $dictPolyhedron value shapepoints]\
                                                                            [dict get $dictPolyhedron input segmentNumber]]
      #
    return $dictPolyhedron
}

proc bikeGeometry::geometry3D::polyhedron::prepareCenterLine {centerLine guide_y guide_z {maxLength 10}} {
      #
    catch {unset centerLine_refined}
    catch {unset centerLine_prepared}
    catch {unset centerLine_x}
      #
    foreach node "$guide_y $guide_z" {
        foreach {x y} [split $node ,] break
          # puts "   $x / $y"
        lappend centerLine_x $x
    }
      # puts $centerLine_x
    set centerLine_x [lsort -unique $centerLine_x]
    
      # puts "  01 -> $centerLine"
      # puts "  -> $centerLine_x"
    # exit
    
    if {0} {
        exit
        set currentLength 0
        for {set i 0} {$i < [expr [llength $centerLine] -1]} {incr i} {
            set thisPos [split [lindex $centerLine $i]   ,]
            set nextPos [split [lindex $centerLine $i+1] ,]
            set direction [vectormath::unifyVector $thisPos $nextPos]       
            set length    [vectormath::length      $thisPos $nextPos]       
            set nextLength [expr $currentLength + $length]
              # puts "   -> $currentLength / $nextLength"
              # puts "     -> $thisPos"
              # puts "     -> $nextPos"
              # puts "       -> $direction"
              # puts "       -> $length"
              #
              # puts "  -> \$thisPos $thisPos"
            lappend thisPos 0
            lappend centerLine_refined $thisPos
              # puts "  -> \$centerLine_refined $centerLine_refined"
              #
            set guide_x {}
            foreach guideLength $centerLine_x {
                if {$guideLength > $currentLength} {
                    if {$guideLength < $nextLength} {
                          # puts "         -> $guideLength"
                        lappend guide_x $guideLength
                    }
                }
            }        
            foreach x $guide_x {
                set d_l [expr $x - $currentLength]
                set v   [vectormath::unifyVector $thisPos $nextPos $d_l]
                  # puts "        insert --> $x -> $d_l -> $v"
                set insertPos [vectormath::addVector $thisPos $v]
                foreach {x y} $insertPos break
                # 
                # lappend centerLine_refined [list $x $y]            
                #
            }        
              
              #
            set currentLength $nextLength
        }
          #
          # puts "  02 -> $centerLine"
        set endPos [split [lindex $centerLine end]   ,]
        foreach {x y} $endPos break
        lappend centerLine_refined [list $x $y]
          #
    } 
      #
    for {set i 0} {$i < [expr [llength $centerLine] -1]} {incr i} {
          # set thisPos [lindex $centerLine_refined $i] 
          # set nextPos [lindex $centerLine_refined $i+1]
        set thisPos [split [lindex $centerLine $i]   ,]
        set nextPos [split [lindex $centerLine $i+1] ,]
        set direction [vectormath::unifyVector $thisPos $nextPos]       
        set length    [vectormath::length      $thisPos $nextPos]       
          #
        foreach {x y} $thisPos break 
        lappend centerLine_prepared [list $x $y 0]
          #
        if {$length > $maxLength} {
            set numberSegments [expr round($length/$maxLength)]
            set segmentLength  [expr $length/$numberSegments]
              # puts "         -> $length"
              # puts "        ->  $numberSegments"
              # puts "         -> $segmentLength"
            for {set j 1} {$j < $numberSegments} {incr j} {
                set newPos [vectormath::addVector $thisPos [vectormath::unifyVector $thisPos $nextPos [expr $j * $segmentLength]]]
                  # puts "      $j -> $newPos"
                foreach {x y} $newPos break 
                lappend centerLine_prepared [list $x $y 0]
            }
        }
    }
      #
    set endPos [split [lindex $centerLine end] ,]
    foreach {x y} $endPos break
    lappend centerLine_prepared [list $x $y 0]
      #
    
    
      #
    # puts "  -> $centerLine_refined"      
    # puts "  -> $centerLine_prepared"      
      #  
    # exit
      #
    return $centerLine_prepared 
      #
}

proc bikeGeometry::geometry3D::polyhedron::extrudeShape {centerLine guideY guideZ segmentNumber} {
        #
    set nodeList_Guide $centerLine
        #
    set dict_Centerline     {}
        #
    set lengthGuide_Current 0
    set posGuide_Last       [lindex $nodeList_Guide 0]
        #
    set profileDict_xy  $guideY
    set profileDict_xz  $guideZ
      
        # -- replace first point in List by a virtual CenterPoint
        # puts "  -> \$centerLine $centerLine"
    set posStart      [lindex $centerLine 0] 
    set posStartNext  [lindex $centerLine 1] 
        #
    foreach {x_Start     y_Start     z_Start}     $posStart      break
    foreach {x_StartNext y_StartNext z_StartNext} $posStartNext  break
        #
    set x_Start_A   [expr $x_Start - 0.1*($x_StartNext - $x_Start)] 
    set y_Start_A   [expr $y_Start - 0.1*($y_StartNext - $y_Start)] 
    set z_Start_A   [expr $z_Start - 0.1*($z_StartNext - $z_Start)] 
        #
    set x_Start_B   [expr $x_Start + 0.1*($x_StartNext - $x_Start)] 
    set y_Start_B   [expr $y_Start + 0.1*($y_StartNext - $y_Start)] 
    set z_Start_B   [expr $z_Start + 0.1*($z_StartNext - $z_Start)] 
        #
    set pos_Start_A [list $x_Start_A  $y_Start_A  $z_Start_A ]
    set pos_Start_B [list $x_Start_B  $y_Start_B  $z_Start_B ]
        #
        #
    set posEnd        [lindex $centerLine end]  
    set posEndPrev    [lindex $centerLine end-1]
        #
    foreach {x_End       y_End       z_End}       $posEnd        break
    foreach {x_EndPrev   y_EndPrev   z_EndPrev}   $posEndPrev    break
        #
    set x_End_A   [expr $x_End   - 0.1*($x_EndPrev   - $x_End)] 
    set y_End_A   [expr $y_End   - 0.1*($y_EndPrev   - $y_End)] 
    set z_End_A   [expr $z_End   - 0.1*($z_EndPrev   - $z_End)] 
        #                                           
    set x_End_B   [expr $x_End   + 0.1*($x_EndPrev   - $x_End)] 
    set y_End_B   [expr $y_End   + 0.1*($y_EndPrev   - $y_End)] 
    set z_End_B   [expr $z_End   + 0.1*($z_EndPrev   - $z_End)] 
        #
    set pos_End_A [list $x_End_A    $y_End_A    $z_End_A ]
    set pos_End_B [list $x_End_B    $y_End_B    $z_End_B ]
        #
        
        

    
    
      # puts "  -> $nodeList_Guide"
    set nodeList_Guide [lreplace $nodeList_Guide  0   0    $pos_Start_A $pos_Start_B]
    set nodeList_Guide [lrange   $nodeList_Guide  0   end-1]
    lappend nodeList_Guide $pos_End_A $pos_End_B
      # puts "  -> $nodeList_Guide"
    #exit
    #set nodeList_Guide [lreplace $nodeList_Guide  end end  $center_EndNext]

    #set nodeList_Guide [linsert $nodeList_Guide  0    $center_StartPrev]
    #set nodeList_Guide [linsert $nodeList_Guide  end  $center_EndNext]

    
        #
    #set nodeList_GuideCenterPoints [lindex $nodeList_Guide 0]
    set posGuide_Last $pos_Start_A    
        #
    for {set i 1} {$i < [llength $nodeList_Guide]} {incr i 1} {
        set posGuide_Current [lindex $nodeList_Guide $i]
            # puts "  -> $posGuide_Last"
            # puts "    <I> -> \$posGuide_Last   $posGuide_Last  "
            # puts "    <I> -> \$posGuide_Current $posGuide_Current  ... [lindex $nodeList_Guide $i]"
            #
        set currentSegment [getVector $posGuide_Last $posGuide_Current]
            # puts $currentSegment
            #
        set length [dict get $currentSegment length]
        if {$length > 10} {
            set segmentLength [expr $length/10]
        
        }
            #
        set center [dict get $currentSegment center]
        lappend nodeList_GuideCenterPoints $center
            #
        set rotx   [dict get $currentSegment rotx]
        set roty   [dict get $currentSegment roty]
        set rotz   [dict get $currentSegment rotz]
            #
            # set lengthDelta      [vct::
            # set pos "[lindex $centerLine $i],0"
        set lengthGuide_Current [expr $lengthGuide_Current + $length]
            #
        set offsetX     [getOffset $profileDict_xy $lengthGuide_Current] 
        set offsetY     [getOffset $profileDict_xz $lengthGuide_Current]
            #
        set locPI       $::vectormath::CONST_PI
            #
            #
        set dict_shapePoints     {}                
            #
        set segmentAngle         [expr -360/$segmentNumber]
        for {set j 0} {$j < $segmentNumber} {incr j 1} {
            set angle  [expr $j * $segmentAngle]
            set off_x  [expr $offsetX * sin([vectormath::rad $angle])]
            set off_y  [expr $offsetY * cos([vectormath::rad $angle])]
                # puts "          -> \$rotx   [vectormath::grad $rotx]"
                # puts "          -> \$roty   [vectormath::grad $roty]"
                # puts "          -> \$rotz   [vectormath::grad $rotz]"
                #
            set shapePoint  [orientPlane [list 0 $off_x $off_y] [list $rotx $rotx $rotz] $center]
                # puts "       -> \$shapePoint   -> $shapePoint"
                #
            dict set dict_shapePoints $j $shapePoint  
                #
        }
            # 
        dict set currentSegment  shapeProfile $dict_shapePoints  
            #
        dict set dict_Centerline $i  $currentSegment 
            #
        set posGuide_Last $posGuide_Current
            #
    }
        #
    lappend nodeList_GuideCenterPoints [lindex $nodeList_Guide end]
        #
    return $dict_Centerline
        #
            
}

proc bikeGeometry::geometry3D::polyhedron::extrudeShape_old {centerLine guideY guideZ segmentNumber} {
        #
    set nodeList_Guide $centerLine
        #
    set dict_Centerline     {}
        #
    set lengthGuide_Current 0
    set posGuide_Last       [lindex $nodeList_Guide 0]
        #
    set profileDict_xy  $guideY
    set profileDict_xz  $guideZ
      
        # -- replace first point in List by a virtual CenterPoint
        # puts "  -> \$centerLine $centerLine"
    set posStart      [lindex $centerLine 0] 
    set posStartNext  [lindex $centerLine 1] 
        #puts "  -> $posStart      $posStartNext"
    set segmentStart  [getVector $posStart $posStartNext]
    set center_Start  [dict get $segmentStart center]
    puts "\n  -> \$center_Start $center_Start\n"
    
    set posEnd        [lindex $centerLine end]  
    set posEndPrev    [lindex $centerLine end-1]
    set segmentEnd    [getVector $posEndPrev $posEnd ]
    set center_End    [dict get $segmentEnd center]
    puts "\n  -> \$center_End $center_End\n"
    puts "\n"
    
    
    foreach {x_Start     y_Start     z_Start}     $posStart      break
    foreach {x_StartNext y_StartNext z_StartNext} $posStartNext  break
    #foreach {x_StartNext y_StartNext z_StartNext} $center_Start  break
      #
    set x_StartPrev   [expr $x_Start - ($x_StartNext - $x_Start)] 
    set y_StartPrev   [expr $y_Start - ($y_StartNext - $y_Start)] 
    set z_StartPrev   [expr $z_Start - ($z_StartNext - $z_Start)] 
      #
    set center_StartPrev [list $x_StartPrev $y_StartPrev $z_StartPrev]       
      #
      #
    foreach {x_EndPrev   y_EndPrev   z_EndPrev}   $center_End    break
    foreach {x_End       y_End       z_End}       $posEnd        break
      #
    set x_EndNext   [expr $x_End + ($x_End - $x_EndPrev)] 
    set y_EndNext   [expr $y_End + ($y_End - $y_EndPrev)] 
    set z_EndNext   [expr $z_End + ($z_End - $z_EndPrev)] 
      #
    set center_EndNext [list $x_EndNext $y_EndNext $z_EndNext]       
      #
      #
    puts "   \$center_StartPrev  $center_StartPrev"  
    puts "   \$posStart          $posStart"  
    puts "   \$center_Start      $center_Start"  
    puts ""
    puts "   \$center_End        $center_End"  
    puts "   \$posEnd            $posEnd"  
    puts "   \$center_EndNext    $center_EndNext"  
    puts ""
    
    
    #set nodeList_Guide [lreplace $nodeList_Guide  0   0    $center_StartPrev]
    #set nodeList_Guide [lreplace $nodeList_Guide  end end  $center_EndNext]

    #set nodeList_Guide [linsert $nodeList_Guide  0    $center_StartPrev]
    #set nodeList_Guide [linsert $nodeList_Guide  end  $center_EndNext]

    
        #
    #set nodeList_GuideCenterPoints [lindex $nodeList_Guide 0]
    set posGuide_Last $center_StartPrev    
        #
    for {set i 0} {$i < [llength $nodeList_Guide]} {incr i 1} {
        set posGuide_Current [lindex $nodeList_Guide $i]
            # puts "  -> $posGuide_Last"
        puts "    <I> -> \$posGuide_Last   $posGuide_Last  "
        puts "    <I> -> \$posGuide_Current $posGuide_Current  ... [lindex $nodeList_Guide $i]"
            #
        set currentSegment [getVector $posGuide_Last $posGuide_Current]
            # puts $currentSegment
            #
        set length [dict get $currentSegment length]
        if {$length > 10} {
            set segmentLength [expr $length/10]
        
        }
            #
        set center [dict get $currentSegment center]
        lappend nodeList_GuideCenterPoints $center
            #
        set rotx   [dict get $currentSegment rotx]
        set roty   [dict get $currentSegment roty]
        set rotz   [dict get $currentSegment rotz]
            #
            # set lengthDelta      [vct::
            # set pos "[lindex $centerLine $i],0"
        set lengthGuide_Current [expr $lengthGuide_Current + $length]
            #
        set offsetX     [getOffset $profileDict_xy $lengthGuide_Current] 
        set offsetY     [getOffset $profileDict_xz $lengthGuide_Current]
            #
        set locPI       $::vectormath::CONST_PI
            #
            #
        set dict_shapePoints     {}                
            #
        set segmentAngle         [expr -360/$segmentNumber]
        for {set j 0} {$j < $segmentNumber} {incr j 1} {
            set angle  [expr $j * $segmentAngle]
            set off_x  [expr $offsetX * sin([vectormath::rad $angle])]
            set off_y  [expr $offsetY * cos([vectormath::rad $angle])]
                # puts "          -> \$rotx   [vectormath::grad $rotx]"
                # puts "          -> \$roty   [vectormath::grad $roty]"
                # puts "          -> \$rotz   [vectormath::grad $rotz]"
                #
            set shapePoint  [orientPlane [list 0 $off_x $off_y] [list $rotx $rotx $rotz] $center]
                # puts "       -> \$shapePoint   -> $shapePoint"
                #
            dict set dict_shapePoints $j $shapePoint  
                #
        }
            # 
        dict set currentSegment  shapeProfile $dict_shapePoints  
            #
        dict set dict_Centerline $i  $currentSegment 
            #
        set posGuide_Last $posGuide_Current
            #
    }
        #
    lappend nodeList_GuideCenterPoints [lindex $nodeList_Guide end]
        #
    return $dict_Centerline
        #
            
}

proc bikeGeometry::geometry3D::polyhedron::getShapePoints {dictShape} {
        #
    set dict_PointList {}
        #
    # appUtil::pdict $dictShape
        #       
    set i 0
    foreach key [dict keys $dictShape] {
            # puts "\n --- $key ---------------------------"
        set shapeCenter    [dict get $dictShape $key center]
        foreach {x y z} $shapeCenter break
        set returnValue    [format "%s, %s, %s" $x $y $z]
        lappend shapeCenterList $returnValue
            #
        set shapeProfile   [dict get $dictShape $key shapeProfile]
        foreach shapeKey   [dict keys  $shapeProfile] {
            set shapePoint [dict get $shapeProfile $shapeKey]
            foreach {x y z} $shapePoint break
            set returnValue  [format "%s, %s, %s" $x $y $z]    
                # puts [format "           ->  %3i  %s" $i $returnValue]
            dict set dict_PointList $i   $returnValue
            incr i
        }
    }
        #
    set shapeStart [lindex $shapeCenterList 0]
    set shapeEnd   [lindex $shapeCenterList end]
        #
    dict set dict_PointList $i   $shapeStart
        #
    incr i
        #
    foreach {x y z} $shapeEnd break
    dict set dict_PointList $i   $shapeEnd
        #
    return $dict_PointList
        #
}

proc bikeGeometry::geometry3D::polyhedron::getShapeFaces {dict_PointList segmentNumber} {
      #
    set dict_FaceList {}
      #
    set loopIndex      0
    set pointIndex     1
      #
    # puts "   ---next iteration ----------------------------------"
      #
    set myDict $dict_PointList
      #
      #     shapeStart, shapeEnd   -> 2
      #     without last ring      -> $segmentNumber
      # puts "    -> [dict size $dict_PointList]"
      # puts "    -> \$segmentNumber $segmentNumber"
    set shapeRange [expr [dict size $dict_PointList] - $segmentNumber - 2 -1]
      #
      # puts "\n   $shapeRange \n"   
      #
      # exit
      #
    foreach pointKey   [dict keys  $dict_PointList] {
        set value  [dict get $dict_PointList $pointKey]
          #
        if {$pointKey > $shapeRange} {
             # puts "$pointKey / $shapeRange -> continue"
           continue
             # puts " -> exit "
             # exit
        } else {
             # puts "$pointKey / $shapeRange"
        }
          # puts "            -run"        
        incr loopIndex 
          #
        # puts [format "        ->  %6i / %2i  -> %s   " $pointKey $loopIndex $value]       
          #
        if {$loopIndex == $segmentNumber} {
            set A1 $pointKey
            set A2 [expr $A1 - $segmentNumber + 1]
            set B1 [expr $A1 + $segmentNumber]
            set B2 [expr $A2 + $segmentNumber]

        } else {
            set A1 $pointKey
            set A2 [expr $pointKey +  1]
            set B1 [expr $A1 + $segmentNumber]
            set B2 [expr $A2 + $segmentNumber]
        }
          #
          #           
        incr pointIndex
        set value [format "%s, %s, %s" $A1 $B1 $A2]
          # puts "                        -> $value    <- $pointIndex   <- $pointKey" 
          # lappend polyhedron_FaceList          $value
        dict set dict_FaceList $pointIndex   $value
          #
          #
        incr pointIndex
        set value [format "%s, %s, %s" $A2 $B1 $B2]
          # puts "                        -> $value    <- $pointIndex   <- $pointKey" 
          # lappend polyhedron_FaceList          $value
        dict set dict_FaceList $pointIndex   $value
          #
          #
        if {$loopIndex == $segmentNumber} {
            # puts "   ---next iteration ----------------------------------"
            set  loopIndex 0
        }
    }
      #
      # appUtil::pdict $dict_FaceList
      # puts $pointKey
    set key_shapeStart [expr $pointKey -1]
    set key_shapeEnd   [expr $pointKey]
      #
      # puts "  .. \$segmentNumber $segmentNumber"  
      #
    for {set i 0} {$i < $segmentNumber} {incr i} {
          # puts " -> $i"
        set A $i
        set B [expr $i + 1]
        if {$B >= $segmentNumber} {set B 0}
          # puts "   -> $key_shapeStart $A $B"
        set value [format "%s, %s, %s" $key_shapeStart $A $B]
        incr pointIndex
        dict set dict_FaceList $pointIndex   $value
    }    
      #
      # 
      # puts "  .. $key_shapeEnd"
    set key_Start [expr $key_shapeStart -1]    
    set key_End   [expr $key_Start - $segmentNumber]    
      # puts "     .. $key_Start"
      # puts "     .. $key_End"
    for {set i $key_Start} {$i > $key_End} {incr i -1} {
          # puts " -> $i"
        set A $i
        set B [expr $i - 1]
        if {$B <= $key_End} {set B $key_Start}
          # puts "   -> $key_shapeEnd $A $B"
        set value [format "%s, %s, %s" $key_shapeEnd $A $B]
        incr pointIndex
        dict set dict_FaceList $pointIndex   $value
    }
      #
  
      #
    return $dict_FaceList
      #
}


proc bikeGeometry::geometry3D::polyhedron::getVector {p1 p2} {
    if {[llength $p1] != 3} {error "  <E> getVector - \$p1 is not valid: $p1"}
    if {[llength $p2] != 3} {error "  <E> getVector - \$p2 is not valid: $p2"}
      #
    # puts ""
    # puts "  ----- getVector -----------"
    # puts "          \$p1        $p1"
    # puts "          \$p2        $p2"
            #
        set lx   [expr [lindex $p2 0] - [lindex $p1 0]]
        set ly   [expr [lindex $p2 1] - [lindex $p1 1]]
        set lz   [expr [lindex $p2 2] - [lindex $p1 2]]
        set length   [expr sqrt($lx*$lx + $ly*$ly  + $lz*$lz)]
    # puts "          \$length    $length"
            #
            #
        set cx   [expr ([lindex $p2 0] + [lindex $p1 0])/2]
        set cy   [expr ([lindex $p2 1] + [lindex $p1 1])/2]
        set cz   [expr ([lindex $p2 2] + [lindex $p1 2])/2]
        set center   [list $cx $cy $cz]
    # puts "          \$center    $center"
            #
            #
        # puts "             -> $lx  $ly  $lz"
        if {$ly != 0} {
            set rotx [expr atan($lz/$ly)]
        } else {
            set rotx 0
        }
        if {$lx != 0} {
            set roty [expr atan($lz/$lx)]
        } else {
            if {$lz > 0} { 
                 set roty [expr $vectormath::CONST_PI/2]
            } else {
                 set roty [expr $vectormath::CONST_PI/-2]
            } 
            set roty 0 
        }
        if {$lx != 0} {
            set rotz [expr atan($ly/$lx)]
        } else {
            if {$ly > 0} { 
                 set rotz [expr $vectormath::CONST_PI/-2]
            } else {
                 set rotz [expr $vectormath::CONST_PI/2]
            }
            #set rotz 0
        }

    # puts "          \$rotx (\$lz/\$ly)     [vectormath::grad $rotx]"
    # puts "          \$roty (\$lz/\$lx)     [vectormath::grad $roty]"
    # puts "          \$rotz (\$ly/\$lx)     [vectormath::grad $rotz]"
            #
    # puts "  ----- getVector -----------\n"
        #
    set vectorResult {}
    dict set vectorResult   start   $p1
    dict set vectorResult   end     $p2
    dict set vectorResult   length  $length
    dict set vectorResult   center  $center
    dict set vectorResult   rotx    $rotx
    dict set vectorResult   roty    $roty
    dict set vectorResult   rotz    $rotz
        #
    return $vectorResult
}

proc bikeGeometry::geometry3D::polyhedron::getOffset {profileDict offsetX} {

    #appUtil::pdict "$profileDict"
      #
    set y 0
      #
    foreach key [dict keys $profileDict] {
        #if {$offsetX > $key} continue
        if {$key > $offsetX} {
           # puts "    -> getOffset $y"
           # exit
           return $y
        } else {
           # puts "    -> getOffset $y"
        }               
        set dx [expr $offsetX - $key]
        set y  [dict get $profileDict $key y]
        set k  [dict get $profileDict $key k]
        set y  [expr $y + $k * $dx]
    }
    
    
    # puts "  getOffset ->     $offsetX -> $profileXY"
    #exit
    return 15
    
}

proc bikeGeometry::geometry3D::polyhedron::convertProfile {profileXY} {
      # puts "  convertProfile ->     $profileXY"
    set profileDict {}
      # puts "  - $profileDict"
    for {set i 0} {$i < [expr [llength $profileXY] -1]} {incr i} {
        set thisDict {}
        set thisNode [split [lindex $profileXY       $i   ] ,]
        set nextNode [split [lindex $profileXY [expr $i+1]] ,]
          # puts "       $thisNode"
          # puts "         $nextNode"
        foreach {this_x this_y} $thisNode break
        foreach {next_x next_y} $nextNode break
        set dx  [expr $next_x - $this_x]
        set dy  [expr $next_y - $this_y]
        set k   [expr 1.0 * $dy/$dx]
        dict set thisDict y $this_y 
        dict set thisDict k $k
        dict set profileDict $this_x $thisDict 
          # puts "--04"
          # puts $profileDict  
    }
      #
    dict set thisDict y $this_y 
    dict set thisDict k 0
    dict set profileDict 600 $thisDict
      #        
      # puts "$profileDict"
    #appUtil::pdict "$profileDict"
      #
    #exit
      #
    return $profileDict
      #
}

proc bikeGeometry::geometry3D::polyhedron::orientPlane {point direction {translate {0 0 0}}} {
      #
    set translate   
      #
    # puts "           -> $point"  
    # puts "           -> $direction"  
    # puts "           -> $translate"  
      #
    set pointPos(x)     [lindex $point     0]
    set pointPos(y)     [lindex $point     1]
    set pointPos(z)     [lindex $point     2]
      #
    set angleRot(x)     [lindex $direction 0]
    set angleRot(y)     [lindex $direction 1]
    set angleRot(z)     [lindex $direction 2]
      #
    set lengthTrans(x)  [lindex $translate 0]
    set lengthTrans(y)  [lindex $translate 1]
    set lengthTrans(z)  [lindex $translate 2]
      #
     
      
      
      #
      # -- rotate about X-Axis
      #
    if {$angleRot(x) != 0} {
          # puts "        -> \$angleRot(x) $angleRot(x)"
        set rotationMatrix [getRotationMatrix 1 0 0 $angleRot(x)]
        foreach {rotColumn_1 rotColumn_2 rotColumn_3}   $rotationMatrix  break

        set result(x)  [expr $pointPos(x) * [lindex $rotColumn_1 0]  + $pointPos(y) * [lindex $rotColumn_1 1] + $pointPos(z) * [lindex $rotColumn_1 2]]
        set result(y)  [expr $pointPos(x) * [lindex $rotColumn_2 0]  + $pointPos(y) * [lindex $rotColumn_2 1] + $pointPos(z) * [lindex $rotColumn_2 2]]
        set result(z)  [expr $pointPos(x) * [lindex $rotColumn_3 0]  + $pointPos(y) * [lindex $rotColumn_3 1] + $pointPos(z) * [lindex $rotColumn_3 2]]
        
        set pointPos(x) $result(x)
        set pointPos(y) $result(y)
        set pointPos(z) $result(z)
    }

      #
      # -- rotate about Y-Axis
      #
    if {$angleRot(y) != 0} {
          # puts "        -> \$angleRot(y) $angleRot(y)"
        set rotationMatrix [getRotationMatrix 0 1 0 $angleRot(y)]
        foreach {rotColumn_1 rotColumn_2 rotColumn_3}   $rotationMatrix  break

        set result(x)  [expr $pointPos(x) * [lindex $rotColumn_1 0]  + $pointPos(y) * [lindex $rotColumn_1 1] + $pointPos(z) * [lindex $rotColumn_1 2]]
        set result(y)  [expr $pointPos(x) * [lindex $rotColumn_2 0]  + $pointPos(y) * [lindex $rotColumn_2 1] + $pointPos(z) * [lindex $rotColumn_2 2]]
        set result(z)  [expr $pointPos(x) * [lindex $rotColumn_3 0]  + $pointPos(y) * [lindex $rotColumn_3 1] + $pointPos(z) * [lindex $rotColumn_3 2]]
        
        set pointPos(x) $result(x)
        set pointPos(y) $result(y)
        set pointPos(z) $result(z)
    }

      #
      # -- rotate about Z-Axis
      #
    if {$angleRot(z) != 0} {
          # puts "        -> \$angleRot(z) $angleRot(z)"
        set rotationMatrix [getRotationMatrix 0 0 1  $angleRot(z)]
        foreach {rotColumn_1 rotColumn_2 rotColumn_3}   $rotationMatrix  break
          #
        set result(x)  [expr $pointPos(x) * [lindex $rotColumn_1 0]  + $pointPos(y) * [lindex $rotColumn_1 1] + $pointPos(z) * [lindex $rotColumn_1 2]]
        set result(y)  [expr $pointPos(x) * [lindex $rotColumn_2 0]  + $pointPos(y) * [lindex $rotColumn_2 1] + $pointPos(z) * [lindex $rotColumn_2 2]]
        set result(z)  [expr $pointPos(x) * [lindex $rotColumn_3 0]  + $pointPos(y) * [lindex $rotColumn_3 1] + $pointPos(z) * [lindex $rotColumn_3 2]]
          #
        set pointPos(x) $result(x)
        set pointPos(y) $result(y)
        set pointPos(z) $result(z)
    }
    
      #
      # -- translate to position
      #
    set pointPos(x) [expr $pointPos(x) + $lengthTrans(x)]
    set pointPos(y) [expr $pointPos(y) + $lengthTrans(y)]
    set pointPos(z) [expr $pointPos(z) + $lengthTrans(z)]
      #
      
      #
    return [list $pointPos(x) $pointPos(y) $pointPos(z)]
      #
} 


proc bikeGeometry::geometry3D::polyhedron::getRotationMatrix {x y z t} {

    #set t  [vectormath::rad [expr -1.0 * $t]] ; # had to change direction of tube

    if {$x == 0 && $y == 0 && $z == 0} {
        return [list $x $y $z]
        error "Cannot rotate around zero vector"
    }
    set l [expr {sqrt($x ** 2 + $y ** 2 + $z ** 2)}]
    foreach dim {x y z} {
        set $dim [expr {[set $dim] / $l}]
    }

    set result [list]
    foreach row_expr {
        {{$x * $x + (1 - $x ** 2)      * cos($t)}
         {$x * $y * (1 - cos($t)) - $z * sin($t)}
         {$x * $z * (1 - cos($t)) + $y * sin($t)}}
        {{$y * $x * (1 - cos($t)) + $z * sin($t)}
         {$y * $y + (1 - $y ** 2)      * cos($t)}
         {$y * $z * (1 - cos($t)) - $x * sin($t)}}
        {{$z * $x * (1 - cos($t)) - $y * sin($t)}
         {$z * $y * (1 - cos($t)) + $x * sin($t)}
         {$z * $z + (1 - $z ** 2)      * cos($t)}}
    } {
        set row [list]
         # foreach cell_expr [concat $row_expr [list 0]] {}
        foreach cell_expr $row_expr {
            lappend row [expr $cell_expr]
        }
        lappend result $row
    }
    return $result
}   
    


 

    



