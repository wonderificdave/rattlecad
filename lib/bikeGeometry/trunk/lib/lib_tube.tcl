 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_tube.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2012/10/28
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
 #    namespace:  bikeGeometry::lib_tube
 # ---------------------------------------------------------------------------
 #
 # 
 
 
namespace eval bikeGeometry::tube {

    variable arcPrecission 5 ;# number of segments per arc
    
    
    proc init_centerLine {centerLineDef} {
        
        variable arcPrecission
        variable centerLineDirAngle;  array set centerLineDirAngle  {} 
        variable centerLineRadius;    array set centerLineRadius    {} 
        variable centerLineSegement;  array set centerLineAngle     {} 
        variable centerLineDefLength; array set centerLineDefLength {} 
        variable centerLinePosition;  array set centerLinePosition  {} 
        variable centerLineEnd
          # puts "  -> $arcPrecission"
        
          # --
          # puts "   ->[llength $centerLineDef] < 14"
        if {[llength $centerLineDef] < 14} {
            foreach {S01_length S02_length S03_length S04_length S05_length \
                     P01_angle  P02_angle  P03_angle  P04_angle \
                     S01_radius S02_radius S03_radius S04_radius \
                    } $centerLineDef break
                    set cuttingLength [expr $S01_length + $S02_length + $S03_length + $S04_length + $S05_length]
        } else {
            foreach {S01_length S02_length S03_length S04_length S05_length \
                     P01_angle  P02_angle  P03_angle  P04_angle \
                     S01_radius S02_radius S03_radius S04_radius \
                     cuttingLength\
                    } $centerLineDef break
        }
                 
              # puts "   <D> ---- \$centerLineDef ----------"
              # puts $centerLineDef
              # puts "   <D> --------------"

        set centerLineDefLength(1) $S01_length
        set centerLineDefLength(2) $S02_length
        set centerLineDefLength(3) $S03_length
        set centerLineDefLength(4) $S04_length
        set centerLineDefLength(5) $S05_length
        
        set centerLineAngle(0)     0
        set centerLineAngle(1)     $P01_angle
        set centerLineAngle(2)     $P02_angle
        set centerLineAngle(3)     $P03_angle
        set centerLineAngle(4)     $P04_angle
        set centerLineAngle(5)     0
        
        set centerLineDirection(0) 0
        set centerLineDirection(1) [expr $centerLineDirection(0) + $P01_angle]
        set centerLineDirection(2) [expr $centerLineDirection(1) + $P02_angle]
        set centerLineDirection(3) [expr $centerLineDirection(2) + $P03_angle]
        set centerLineDirection(4) [expr $centerLineDirection(3) + $P04_angle]
        set centerLineDirection(5) $centerLineDirection(4)
        
        set centerLineRadius(0)    0
        set centerLineRadius(1)    $S01_radius
        set centerLineRadius(2)    $S02_radius
        set centerLineRadius(3)    $S03_radius
        set centerLineRadius(4)    $S04_radius
        set centerLineRadius(5)    0
        
        set centerLine    [list {0 0}]
        set ctrlPoints  {}
        
          #
          # puts " -> centerLineDefLength [array size centerLineDefLength]"
          #
        set i 0
        while {$i <= [array size centerLineDefLength]-1} {
              # puts "\n"
              # puts " == <$i> ==========================="
            set lastId $i
            set nextId [expr $i+1]
            set retValue [init_centerLineNextPosition   $centerLine $ctrlPoints\
                                                    $centerLineRadius($lastId)  $centerLineAngle($lastId)  $centerLineDirection($lastId) \
                                                    $centerLineDefLength($nextId) \
                                                    $centerLineRadius($nextId)  $centerLineAngle($nextId)  $centerLineDirection($nextId)]
            set centerLine    [lindex $retValue 0]
            set ctrlPoints  [lindex $retValue 1] 
              # puts "  -> $ctrlPoints"
                #if {$i == 20} { exit }
            
            incr i
        }
          #
        set controlPoints [list {0 0}]
        set i 0
        foreach {start end} $ctrlPoints {
            lappend controlPoints $start $end
        }
          #
        set centerLineCut [cut_centerLine $centerLine $cuttingLength]
          # puts "  -> $centerLine"
          # puts "  -> $centerLineCut"
          #
        return [list $centerLine $controlPoints $centerLineCut]
          #
    }
    
    proc init_centerLineNextPosition {polyLine ctrlPoints lastRadius lastAngle lastDir distance nextRadius nextAngle nextDir} {
          #
        variable arcPrecission
          #
        set lastPos     [lindex $polyLine end]
          #
          # puts "\n -- <D> ---------------------------"
          # puts "   -> \$lastPos    $lastPos"
          # puts "   -> \$lastRadius $lastRadius"
          # puts "   -> \$lastAngle  $lastAngle"
          # puts "   -> \$lastDir    $lastDir"
          # puts "   -> \$distance   $distance"
          # puts "   -> \$nextRadius $nextRadius"
          # puts "   -> \$nextAngle  $nextAngle"
          # puts "   -> \$nextDir    $nextDir"

          #
        set lastSegment [expr abs($lastRadius * [vectormath::rad $lastAngle])]
        set nextSegment [expr abs($nextRadius * [vectormath::rad $nextAngle])]
          #
        set lastArc      [expr 0.5 * $lastSegment]
        set nextArc      [expr 0.5 * $nextSegment]
          #        
        
          # -- get sure to have a smooth shape
        set offset      [expr $distance - ($lastArc + $nextArc)]
        if {$offset < 0} {
            set offset 0.5
        }
          #
          
          # puts "      -> \$offset $offset"
        set arcStart    [vectormath::addVector $lastPos  [vectormath::rotateLine {0 0} ${offset}  ${lastDir}]]  
        set ctrlEnd     [vectormath::addVector $arcStart [vectormath::rotateLine {0 0} ${nextArc} ${lastDir}]] 
          #
        lappend polyLine   $arcStart
          #
              # puts "    <1>  \$lastPos                              \$arcStart"
              # puts "    <1>  {69.45050226731068 -2.385231474777072} {179.76990416419986 -15.896650836506808}"
              # puts "    <1>   $lastPos  $arcStart"
              # puts "    <1>         \$offset  ${offset}"
              # puts "    <1>         \$lastDir ${lastDir}"
              # puts "    <1>     ---------------------------"
              # puts "    <D>       distance: $distance"
              # puts "    <D>        lastArc: $lastArc"
              # puts "    <D>        nextArc: $nextArc"
              # puts "    <D>       -----------------------"
              # puts "    <D>                 [expr $distance - $lastArc - $nextArc]"
              # puts "    <D>       length: \$lastPos  <-> \$arcStart  [vectormath::length $lastPos  $arcStart]"
              # puts "    <1>     ---------------------------\n"

          #
        if {$nextAngle == 0} {   
            lappend ctrlPoints $arcStart
            lappend ctrlPoints $arcStart
              #
            return [list $polyLine $ctrlPoints]
        } else {
            if {$nextAngle < 0} {
                set arcCenter [vectormath::addVector $arcStart [vectormath::rotateLine {0 0} $nextRadius [expr -1.0 * (90 - $lastDir)]]]
            } else {  
                set arcCenter [vectormath::addVector $arcStart [vectormath::rotateLine {0 0} $nextRadius [expr (90 + $lastDir)]]]
            }
        }
        
          #
        set nrSegments  [expr abs(round($nextSegment/$arcPrecission))]
        if {$nrSegments < 1} {
              # puts "    -> nrSegments: $nrSegments"
            set nrSegments 1
        }
          #
        set deltaAngle  [expr 1.0*$nextAngle/$nrSegments]
          # puts "  ->  Segments/Angle: $nrSegments $deltaAngle"
        set arcEnd  $arcStart
        set i 0
        while {$i < $nrSegments} {
              set arcEnd  [vectormath::rotatePoint $arcCenter $arcEnd $deltaAngle]
              lappend polyLine $arcEnd
                # puts "  -> i/p_End:  $i  $p_End"
                # set pStart $p_End
              incr i
        }
        set ctrlStart [vectormath::addVector $arcEnd  [vectormath::rotateLine {0 0} ${nextArc}  [expr 180 + ${nextDir}]]] 
          #
        lappend ctrlPoints $ctrlEnd
        lappend ctrlPoints $ctrlStart
          #
        return [list $polyLine $ctrlPoints]
    }

    proc cut_centerLine {centerLine length} {
        set centerLineCut {}
          # puts "\n ------"
          # puts "   -> \$centerLine $centerLine"
          # puts "   -> \$length     $length"
          # puts " ------\n"
        set newLength     0
        set lastLength    0
        set lastXY       {0 0}
        set i 0
        foreach {xy} $centerLine {
            incr i
              # puts "     $i -> $xy"
            set offset      [vectormath::length $lastXY $xy]
              # puts "               -> $offset  <- $lastXY"
            set newLength   [expr $newLength + $offset]
            if  {$newLength > $length} {
                set deltaOffset  [expr $length - $lastLength]
                set lastPosVct   [vectormath::unifyVector $lastXY $xy $deltaOffset]
                lappend centerLineCut [vectormath::addVector $lastXY $lastPosVct]
                return  $centerLineCut
            } else {
                set lastLength  $newLength
                set lastXY      $xy
                lappend centerLineCut $xy
            }
        }
          #
        #puts "   -> [llength $centerLine]"
        #puts "   -> [llength $centerLineCut]"
          #
          
          # -- exception if length is longer than the profile
        return  $centerLineCut
    }

    proc init_tubeProfile {profileDef args} {

        variable unbentShape
        
        array unset _tubeProfileArray
        set tubeProfile [dict create]
        
        set x 0
        set y 0
        set k 0
        set i 0
        set profLength [llength $profileDef]
        while {$i < $profLength} {
            set xy [lindex $profileDef $i]
            foreach {x0 y0} $xy break
            set x   [expr $x + $x0]
            set y0  [expr 0.5 * $y0]
            
            set j [expr $i + 1]
            if {$j <= $profLength} {
              set xy [lindex $profileDef $j]
              foreach {x1 y1} $xy break
              set y1  [expr 0.5 * $y1]
              set k [expr 1.0 * ($y1 - $y0) / $x1]
            } else {
              set x1 10
              set y1 $y0
              set k  0
            }
            set _tubeProfileArray($x) [list  $y0 $k]
            incr i
        }
        set _tubeProfileArray([expr $x + 1]) [list  $y0 0]
        
        foreach index [lsort -real [array names _tubeProfileArray]] {
            dict append tubeProfile $index $_tubeProfileArray($index)
            # lappend profileIndex $index
            # puts "   -> $index"
        }
       
        return $tubeProfile       
    }


    proc get_ForkBlade {valueDict} {

        
        # variable max_Offset

        # puts $valueDict
        
        set dropOutPos      [dict get $valueDict env    dropOutPosition]
        set forkHeight      [dict get $valueDict env    forkHeight]
        set forkRake        [dict get $valueDict env    forkRake]
        set crownOffset     [dict get $valueDict env    crownOffset]
        set crownPerp       [dict get $valueDict env    crownPerp]
        set dropOutOffset   [dict get $valueDict env    dropOutOffset]
        set dropOutPerp     [dict get $valueDict env    dropOutPerp]
        set headTube_Angle  [dict get $valueDict env    headTubeAngle]
        
        set endLength       [dict get $valueDict blade  endLength]
        set bendRadius      [dict get $valueDict blade  bendRadius]
        set bladeType       [dict get $valueDict blade  type]
        
        set profileDef      [dict get $valueDict profile]
        set max_Offset      6.0

        

        set length_bladeDO  [expr $forkHeight - $crownOffset]
        set height_bladeDO  [expr $forkRake - $crownPerp]
        
        set orient_01 [list 0 0]
        set orient_02 [list $crownOffset 0]
        set orient_03 [list $crownOffset $crownPerp]
        set orient_04 [list $forkHeight $crownPerp]
        set orient_05 [list $forkHeight $forkRake]          
        
        set p_00    [list $length_bladeDO $height_bladeDO]
        
        switch -exact $bladeType {
        
          bent {

                  # http://www.mathcentre.ac.uk/resources/workbooks/mathcentre/web-rcostheta-alphaetc.pdf
              #puts "\n"
              #puts "   --> \$height_bladeDO $height_bladeDO"
              #puts "   --> \$dropOutPerp $dropOutPerp"
              #puts "   ----> [expr $height_bladeDO + $dropOutPerp]"

              set _b    [expr -1.0*($dropOutOffset + $endLength)]
                      
              if {$height_bladeDO > $dropOutPerp} {
              
                    # puts "\n ==== upper state =========\n"  
                    
                  set _a    [expr  1.0*($bendRadius - $dropOutPerp)]
                  set _R    [expr hypot($_a,$_b)]
                  set _atan [expr atan($_b/$_a)]
                  set _quot [expr ($bendRadius - $height_bladeDO)/$_R]
                  set _acos [expr acos($_quot)]

                  set bendAngle [expr (-180/$vectormath::CONST_PI) * ($_acos + $_atan)]
                  set segLength [expr abs($bendRadius*$bendAngle)*($vectormath::CONST_PI/180)] 
                  set dirAngle  [expr -1*$bendAngle]
                  
                  set l_t01   [expr $bendRadius * sin($bendAngle*$vectormath::CONST_PI/180)]
                  
                  set p_01    [vectormath::rotateLine $p_00 $dropOutPerp    [expr 270 + $dirAngle]]
                  set p_02    [vectormath::rotateLine $p_01 $dropOutOffset  [expr 180 + $dirAngle]]
                  set p_03    [vectormath::rotateLine $p_02 $endLength      [expr 180 + $dirAngle]]
                  set p_04    [vectormath::subVector $p_03  [list           [expr -1 * $l_t01] [lindex $p_03 1]]]
                  set p_05    [vectormath::rotateLine $p_03 [expr 0.5 * $segLength] [expr 180 + $dirAngle]]
                  set p_06    $orient_03
                  set p_15    [vectormath::addVector $p_04  [list 0         $bendRadius]]
                  
              } elseif {$height_bladeDO > 0} {
              
                    # puts "\n ==== middle state =========\n" 
                  
                  set _a    [expr  1.0*($bendRadius + $dropOutPerp)]
                  set _R    [expr hypot($_a,$_b)]
                  set _atan [expr atan($_b/$_a)]
                  set _quot [expr ($bendRadius + $height_bladeDO)/$_R]
                  set _acos [expr acos($_quot)]

                  set bendAngle [expr (180/$vectormath::CONST_PI) * ($_acos + $_atan)]
                  set segLength [expr abs($bendRadius*$bendAngle)*$vectormath::CONST_PI/180] 
                  set dirAngle  [expr -1*$bendAngle]

                  set l_t01   [expr $bendRadius * sin($bendAngle*$vectormath::CONST_PI/180)]

                  set p_01    [vectormath::rotateLine $p_00 $dropOutPerp    [expr 270 + $dirAngle]]
                  set p_02    [vectormath::rotateLine $p_01 $dropOutOffset  [expr 180 + $dirAngle]]
                  set p_03    [vectormath::rotateLine $p_02 $endLength      [expr 180 + $dirAngle]]
                  set p_04    [vectormath::subVector $p_03  [list $l_t01    [lindex $p_03 1]]]
                  set p_05    [vectormath::rotateLine $p_03 [expr 0.5 * $segLength] [expr 180 + $dirAngle]]
                  set p_06    $orient_03
                  set p_15    [vectormath::addVector $p_04  [list 0         [expr 1.0 * $bendRadius]]]
                    
              } else {
              
                    # puts "\n ==== lower state =========\n"  
                  
                  set _a      [expr  1.0*($dropOutPerp + $bendRadius)]
                  set _R      [expr hypot($_a,$_b)]
                  set _atan   [expr atan($_b/$_a)]
                  set _quot   [expr ($bendRadius + $height_bladeDO)/$_R]
                  set _acos   [expr acos($_quot)]
                 
                  set bendAngle [expr (180/$vectormath::CONST_PI) * ($_acos + $_atan)]
                  set segLength [expr abs($bendRadius*$bendAngle)*$vectormath::CONST_PI/180] 
                  set dirAngle  [expr -1.0 * $bendAngle]
                  
                  set l_t01   [expr $bendRadius * sin($bendAngle*$vectormath::CONST_PI/180)]
                  
                  set p_01    [vectormath::rotateLine $p_00 $dropOutPerp    [expr 270 + $dirAngle]]
                  set p_02    [vectormath::rotateLine $p_01 $dropOutOffset  [expr 180 + $dirAngle]]
                  set p_03    [vectormath::rotateLine $p_02 $endLength      [expr 180 + $dirAngle]]
                  set p_04    [vectormath::subVector  $p_03 [list $l_t01    [lindex $p_03 1]]]
                  set p_05    [vectormath::rotateLine $p_03 [expr 0.5 * $segLength] [expr 180 + $dirAngle]]
                  set p_06    [list 0 0] 
                  set p_15    [vectormath::addVector  $p_04 [list 0         [expr -1.0 * $bendRadius]]]
                  
              }             
              
                  #puts "   -> \$_a $_a"
                  #puts "   -> \$_b $_b"
                  #puts "   -> \$_R $_R"
                  #puts "   -> \$_quot $_quot"
                  #puts "   -> \$_atan $_atan"
                  #puts "   -> \$_acos $_acos"
                  #puts "   -> \$segLength $segLength"
                  #puts "   -> \$bendAngle $bendAngle\n"
                  #puts "   -> \$dirAngle $dirAngle\n"

              set angleRotation [expr 180 + $dirAngle]  
                  #puts "   -> \$angleRotation $angleRotation\n"
              
              set S01_length  [expr $endLength + 0.5 * $segLength]
              set S02_length  [expr [lindex $p_04 0] + 0.5 * $segLength - 20] ;#[expr $length_bladeDO - $S01_length - 20]
              set S03_length  10 ;#[expr [lindex $p_04 0] - 20]                       
              set S04_length  10                         
              set S05_length  10                         
              set P01_angle   $bendAngle
              set P02_angle   0                       
              set P03_angle   0                       
              set P04_angle   0                       
              set S01_radius  $bendRadius
              set S02_radius  0
              set S03_radius  0            
              set S04_radius  0            

                # -- set centerLine of bent tube
              set centerLineDef [list $S01_length $S02_length $S03_length  $S04_length  $S05_length \
                                      $P01_angle  $P02_angle  $P03_angle   $P04_angle \
                                      $S01_radius $S02_radius $S03_radius  $S04_radius]              
              

                # -- set profile of bent tube
              set tubeProfile [bikeGeometry::tube::init_tubeProfile $profileDef]              
                  # puts "   -> \$profileDef   $profileDef"
                  # puts "   -> \$tubeProfile  $tubeProfile"
            }
            
          straight {
          
                # puts "\n ==== straight =========\n"  
                  
              set _dAngle   [expr atan(1.0*$height_bladeDO/$length_bladeDO)]
              set _hypot    [expr hypot($length_bladeDO,$height_bladeDO)]
              set _pAngle   [expr asin($dropOutPerp/$_hypot)]
              
              set length    [expr sqrt(pow($_hypot,2) - pow($dropOutPerp,2)) - $dropOutOffset]
              
              set dirAngle     [expr (180/$vectormath::CONST_PI) * ($_dAngle - $_pAngle)]

              set segLength 30
              
              set p_01    [vectormath::rotateLine $p_00 $dropOutPerp    [expr 270 + $dirAngle]]
              set p_02    [vectormath::rotateLine $p_01 $dropOutOffset  [expr 180 + $dirAngle]]
              set p_03    [vectormath::rotateLine $p_02 $endLength      [expr 180 + $dirAngle]]
              set p_04    [vectormath::rotateLine $p_03 [expr 1.00 * $segLength]  [expr 180 + $dirAngle]]
              set p_05    [vectormath::rotateLine $p_04 [expr 1.00 * $segLength]  [expr 180 + $dirAngle]]
              set p_06    [list 0 0] 
              set p_15    [vectormath::rotateLine $p_03 100  [expr 170 + $dirAngle]]

                    #puts "   --> \$_hypot $_hypot"
                    #puts "   --> \$_dAngle $_dAngle"
                    #puts "   --> \$_pAngle $_pAngle"
                    #puts "   --> \$length $length"
              
              set angleRotation [expr 180 + $dirAngle]
                    #puts "   -> \$angleRotation $angleRotation\n"
              
              set S01_length  [expr 0.20 * $length]
              set S02_length  [expr 0.20 * $length]
              set S03_length  [expr 0.20 * $length]                       
              set S04_length  [expr 0.20 * $length]                         
              set S05_length  [expr 0.20 * $length]                         
              set P01_angle   0
              set P02_angle   0                       
              set P03_angle   0                       
              set P04_angle   0                       
              set S01_radius  0
              set S02_radius  0
              set S03_radius  0
              set S04_radius  0

                # -- set centerLine of straight tube
              set centerLineDef [list $S01_length $S02_length $S03_length  $S04_length  $S05_length \
                                      $P01_angle  $P02_angle  $P03_angle   $P04_angle \
                                      $S01_radius $S02_radius $S03_radius  $S04_radius] 
                                      
              # -- set profile of straight tube       
              set tubeProfile [bikeGeometry::tube::init_tubeProfile $profileDef]                          
                  # puts "   -> \$profileDef   $profileDef"
                  # puts "   -> \$tubeProfile  $tubeProfile"
            }
            
          MAX -
          max {
                
                # puts "\n ==== MAX =========\n"  
                  
              set max_endLength   250
              set max_bendRadius  [expr 25.0]
                # puts "   -> \$max_Offset       $max_Offset"  
                # puts "   -> \$max_bendRadius   $max_bendRadius"                
                # puts "   -> \$max_endLength    $max_endLength"
              set bendAngle   [expr atan(1.0*$max_Offset/$max_endLength)]
                # puts "   -> \$bendAngle $bendAngle"  
              
              set l_bend_DO [expr hypot(($max_endLength+$dropOutOffset),$dropOutPerp)]
                # puts "   -> \$l_bend_DO $l_bend_DO"  
              set a_bend_DO [expr atan(1.0*$dropOutPerp/($max_endLength+$dropOutOffset))]
                # puts "   -> \$a_bend_DO $a_bend_DO"               
              set a_gamma   [expr $vectormath::CONST_PI-($bendAngle+$a_bend_DO)]
                # puts "   -> \$a_gamma   $a_gamma" 
              
              set l_bend_DO_x [expr $l_bend_DO * cos($bendAngle+$a_bend_DO)]
              set l_bend_DO_y [expr $l_bend_DO * sin($bendAngle+$a_bend_DO)]
                # puts "   -> \$l_bend_DO_x   $l_bend_DO_x" 
                # puts "   -> \$l_bend_DO_y   $l_bend_DO_y" 
              
              
              set l_cc      [expr hypot($length_bladeDO,$height_bladeDO)]
              set l_base    [expr sqrt(pow($l_cc,2) - pow($l_bend_DO_y,2)) - $l_bend_DO_x]
                # puts "   -> \$l_base   $l_base" 
              
              set _a_2       [expr pow($l_bend_DO,2)]
              set _b_2       [expr pow($l_base,2)]
              set _c_2       [expr pow($l_cc,2)]
              set _2ac       [expr 2*$l_bend_DO*$l_cc]
              
              set a_beta      [expr acos(($_c_2-$_b_2+$_a_2)/$_2ac)]
              set a_alpha     [expr $vectormath::CONST_PI - $a_beta - $a_gamma]
                # puts "   -> \$a_beta   $a_beta"               
                # puts "   -> \$a_alpha  $a_alpha"     

              set a_offset    [expr atan(1.0*$height_bladeDO/$length_bladeDO)]
                # puts "   -> \$a_offset   $a_offset"               
              set dirAngle    [expr $a_offset + $a_beta - $a_bend_DO]
                # puts "\n"
                # puts "   -> \$dirAngle  $dirAngle"     
              set dirAngle    [vectormath::grad $dirAngle]
                # puts "   -> \$dirAngle  $dirAngle"     
                # puts "\n"
              # puts "   -> \$max_Offset $max_Offset"  
              
                          
              set segLength [expr tan(0.5*$bendAngle)*$max_bendRadius] 
                # puts "   -> \$segLength    $segLength"               
                # puts "\n"              
                # puts "\n" 

              set p_01    [vectormath::rotateLine $p_00 $dropOutPerp    [expr 270 + $dirAngle]]
              set p_02    [vectormath::rotateLine $p_01 $dropOutOffset  [expr 180 + $dirAngle]]
              set p_03    [vectormath::rotateLine $p_02 [expr $max_endLength - 30]     [expr 180 + $dirAngle]]
              set p_04    [vectormath::rotateLine $p_02 $max_endLength  [expr 180 + $dirAngle]]
              set p_05    [vectormath::rotateLine $p_04 30 [expr 180 + $dirAngle  - $bendAngle*(180/$vectormath::CONST_PI)]]
              set p_06    [list 0 0] 
              set p_15    [vectormath::addVector $p_04  [list 0         [expr 1.0 * $max_bendRadius]]]

              set angleRotation [expr 180 + $dirAngle]  
                # puts "   -> \$angleRotation $angleRotation\n"

              set S01_length  [vectormath::length $p_02 $p_04]
              set S02_length  [expr [vectormath::length $p_04 $p_06] - 20] ;#[expr $length_bladeDO - $S01_length - 20]
              set S03_length  10                
              set S04_length  10                                          
              set S05_length  10                                          
              set P01_angle   [expr -1.0 * $bendAngle * (180/$vectormath::CONST_PI)]
              set P02_angle   0                       
              set P03_angle   0                       
              set P04_angle   0                       
              set S01_radius  $max_bendRadius
              set S02_radius  0
              set S03_radius  0  
              set S04_radius  0  
                # puts "   -> \$P01_angle $P01_angle\n"

                # -- set centerLine of straight tube
              set centerLineDef [list $S01_length $S02_length $S03_length  $S04_length  $S05_length \
                                      $P01_angle  $P02_angle  $P03_angle   $P04_angle \
                                      $S01_radius $S02_radius $S03_radius  $S04_radius] 
                                      
              # -- set profile of straight tube                
              set profileDef {}
                  lappend profileDef [list 0   14]
                  lappend profileDef [list 250 36]
                  lappend profileDef [list 250 36]
                  lappend profileDef [list 250 36]       
              set tubeProfile [bikeGeometry::tube::init_tubeProfile $profileDef]                 
                  # puts "   -> \$profileDef   $profileDef"
                  # puts "   -> \$tubeProfile  $tubeProfile"
            }
          default {}
        }
            
        foreach _p {p_00 p_01 p_02 p_03 p_04 p_05 p_06 p_15} {
          eval set xy \$$_p
            # puts "   $_p $xy"
          set xy [vectormath::addVector $xy [list $crownOffset $crownPerp]]
          set $_p ${xy}
        }
            
            
            

            # ------------------------------------
						# update $myCanvas ->
        # set dropOutPos    {0 0}
        set dropOutAngle  [expr $angleRotation - $headTube_Angle]
                                
            # -- get smooth centerLine
        set retValues [bikeGeometry::tube::init_centerLine $centerLineDef] 
        set centerLine  [lindex $retValues 0]
        set ctrLines    [lindex $retValues 1]
        
            # -- draw shape of tube
        set outLineLeft   [bikeGeometry::tube::get_tubeShape    $centerLine $tubeProfile left  ]
        set outLineRight  [bikeGeometry::tube::get_tubeShape    $centerLine $tubeProfile right ]
        set outLine       [appUtil::flatten_nestedList $outLineLeft $outLineRight]
        set angleRotation [expr $angleRotation - $headTube_Angle]
        set brakeDefLine  [lrange $outLineRight 0 1]


        set addVector [list $dropOutOffset $dropOutPerp]
        # set addVector [vectormath::addVector $dropOutPos [list $dropOutOffset $dropOutPerp]]
        #puts "  ->    \$dropOutPos $dropOutPos"     
        #puts "     ->    $dropOutOffset $dropOutPerp"     
        #puts "     ->    $addVector $addVector" 
    
            # -- get oriented tube
        set outLine [vectormath::addVectorPointList         $addVector $outLine]
        set outLine [vectormath::rotatePointList {0 0}      $outLine $angleRotation]
        set outLine [vectormath::addVectorPointList         $dropOutPos $outLine]
        
            # -- get oriented centerLine
        set centerLine [vectormath::addVectorPointList      $addVector [appUtil::flatten_nestedList $centerLine]]
        set centerLine [vectormath::rotatePointList {0 0}   $centerLine $angleRotation]
        set centerLine [vectormath::addVectorPointList      $dropOutPos $centerLine]
        
            # -- get oriented brakeDefLine
        set brakeDefLine [vectormath::addVectorPointList    $addVector [appUtil::flatten_nestedList $brakeDefLine]]
        set brakeDefLine [vectormath::rotatePointList {0 0} $brakeDefLine $angleRotation]
        set brakeDefLine [vectormath::addVectorPointList    $dropOutPos $brakeDefLine]

        return [list $outLine $centerLine $brakeDefLine $dropOutAngle]

		}


    proc get_tubeProfileOffset {profile position} {
        
        variable unbentShape

        set profileIndex {}
          # puts "dict: $profile"
          # puts "keys: [dict keys $profile]"
        foreach offset [lsort -real [dict keys $profile]] {
            lappend profileIndex $offset
            # puts "   -> $offset"
        } 
          # puts "\$profileIndex  $profileIndex"

        foreach index $profileIndex { 
          if {$position >= [expr 1.0 * $index]} {
            set k {}
            set value [dict get $profile $index]
              # set value $tubeProfile($index)
            set d_profile $index
            foreach {d k}  $value break
          }
        }
        set dx [expr $position - $d_profile]
        set offset [expr $d + $dx*$k]
          # puts ">$offset"
        
        return $offset
          # return [list $position $offset]
    }


    proc get_tubeShape {centerLine tubeProfile side} {
      
        variable arcPrecission
        
        set linePosition 0
        set bentProfile {}
        
        set lineOffset  [get_tubeProfileOffset $tubeProfile $linePosition]
        if {$side == {left}} {
          lappend bentProfile [list $linePosition $lineOffset]
        } else {
          lappend bentProfile [list $linePosition [expr -1.0 * $lineOffset]]
        }
        # puts "        ---> $bentProfile"
        
        set xLast {}
        set yLast {}
        foreach p $centerLine {
          foreach {x y} $p break
          if {$xLast == {}} {
            set xLast $x
            set yLast $y
            continue
          }
              # puts "$xLast -> $x  | $yLast -> $y"
            # -- get offset / depending on segments
          set p_SegStart  [list $xLast $yLast]
          set p_SegEnd    [list $x $y]
          set angle       [vectormath::dirAngle $p_SegStart $p_SegEnd]
          set l_segment   [vectormath::length   $p_SegStart $p_SegEnd]
              #puts "\n-----------"
              #puts "     -> start:    $p_SegStart"
              #puts "     -> end:      $p_SegEnd"
              #puts "       -> angle:     $angle"
              #puts "       -> segment:   $l_segment\n"
          
          set nrSegments  [expr abs(round($l_segment/$arcPrecission))]
          if {$nrSegments < 1} {
              # puts "    -> nrSegments: $nrSegments"
            set nrSegments 1
          }
          set l_segment   [expr $l_segment/$nrSegments]
          
          if {$side == {left}} {
            set offsetAngle [expr $angle + 90]
          } else {
            set offsetAngle [expr $angle - 90]
          }
          
          set p_Start $p_SegStart
          set i 0
          while {$i < $nrSegments} {
            set linePosition  [expr $linePosition + $l_segment]
            set lineOffset    [get_tubeProfileOffset $tubeProfile $linePosition]
            set p_End         [vectormath::rotateLine $p_Start $l_segment   $angle]
            set p_Offset      [vectormath::rotateLine $p_End   $lineOffset  $offsetAngle]
              # -- add to bentProfile
            lappend bentProfile $p_Offset
                #puts "        ---> [lindex $bentProfile end]"
                #puts "         ->  + $l_segment = $linePosition / $lineOffset  |  $offsetAngle"
              # -- prepare next loop
            set p_Start $p_End
            incr i
          }
          
            # -- prepare next loop
          set xLast $x
          set yLast $y     
        }
        foreach xy $bentProfile {
          # puts "   -> $xy"
        }
        
        if {$side == {left}} {
          return $bentProfile
        } else {
          return [lreverse $bentProfile]
        }
    }


    proc get_shapeInterSection {shape length} {
        
        set shape_llength [llength $shape]  
        set pLast {0 0}
        set precission 1
        
        set shapeIndex 0
        while {$shapeIndex < $shape_llength} {
            # -- get current point of shape
          set pIdx [lindex $shape $shapeIndex]  
          foreach {x y} $pIdx break
          set xAbs  [expr abs($x)]
          set yAbs  [expr abs($y)]
          set lpIdx    [vectormath::length {0 0} $pIdx]

            # -- get last point of shape
          if {$shapeIndex > 0} {
            set pLast [lindex $shape $shapeIndex-1]
          }

            # -- incr shapeIndex before continue
          incr shapeIndex

            # -- precheck values to optimize loop through shape
          if {$lpIdx < $length} continue
          
          set pNow  $pLast
          set dir   [vectormath::dirAngle $pLast $pIdx] 
          set lEnd  [vectormath::length {0 0} $pIdx]
          
          if {$lpIdx > $length} {
              set lNow [vectormath::length {0 0} $pLast]
              while {$lNow < $length} {
                set pNow [vectormath::rotateLine $pNow $precission $dir]
                set lNow [vectormath::length {0 0} $pNow]
              }
              return $pNow
          }
        }
        
          # -- exception: intersection is out of shape
        set pLast [lindex $shape end-1]
        set pNow  [lindex $shape end]
        set lNow  [vectormath::length {0 0} $pNow]
        set dir   [vectormath::dirAngle $pLast $pNow]

        while {$lNow < $length} {
          set pNow  [vectormath::rotateLine $pNow $precission $dir]
          set lNow  [vectormath::length {0 0} $pNow]
        }
        return $pNow
    }
 
 
 
}