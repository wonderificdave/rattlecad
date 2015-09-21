 ##+##########################################################################
 #
 # package: bikeGeometry    ->    bikeGeometry.tcl
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
 #    namespace:  bikeGeometry::paramComponent
 # ---------------------------------------------------------------------------
 #
 #

namespace eval bikeGeometry::paramComponent {

    variable anglePrecStep           2.5 ;# offset Angle of representing polygon of arc
    variable toothWith              12.7
    variable crankWidth_BB          42
    variable crankWidth_Pedal       32
    variable crankSpyderArm_Count   4
    
}    

    proc bikeGeometry::paramComponent::__updateValues {} {
            #
        variable crankWidth_BB
        variable crankWidth_Pedal
        variable crankSpyderArm_Count
            #
        set crankWidth_Pedal        [expr  2 * [set [namespace parent]::CrankSet(PedalEye)]]
        set crankWidth_BB           [expr 10 + $crankWidth_Pedal]
        set crankSpyderArm_Count    [set [namespace parent]::Config(CrankSet_SpyderArmCount)]
            #
        if {$crankSpyderArm_Count < 1} {
            set crankSpyderArm_Count 4
        }   
            #
        if {$crankSpyderArm_Count > 8} {
            set crankSpyderArm_Count 4
        }
        return  
            #
    }

    proc bikeGeometry::paramComponent::__get_BCDiameter {teethCount {option diameter}} {
                #
            __updateValues    
                #
            if     {$teethCount >= 39} {    set innerDiameter 130 } \
            elseif {$teethCount >= 34} {    set innerDiameter 110 } \
            elseif {$teethCount >= 30} {    set innerDiameter 100 } \
            elseif {$teethCount >= 25} {    set innerDiameter  74 } \
            else                       {    set innerDiameter  60 }
                #
            if {$option == {radius}} {
                return [expr 0.5 * $innerDiameter]
            } else {
                return $innerDiameter
            }
    }

    proc bikeGeometry::paramComponent::_get_ChainWheelDefinition {crankSetChainRings} {
                #
            __updateValues    
            variable ListValue    
            #
            set teethCountList  [lreverse [lsort [split $crankSetChainRings -]]]
            set chainWheelCount [llength $teethCountList]
                # 
                # puts "   ... $teethCountList  ->  $chainWheelCount"
                #
            set _chainWheelDef   {}
            set bcDiameter_Min  [__get_BCDiameter   [lindex $teethCountList 0] diameter]
                #
            if {$chainWheelCount == 1} {
                set teethCount $teethCountList
                puts $teethCount
                set _bcDiameter [__get_BCDiameter   $teethCount diameter]
                set _chainWheelDef [list $teethCount $_bcDiameter]
            } elseif {$chainWheelCount >= 2} {
                foreach teethCount [lrange $teethCountList 0 1] {
                        # puts "    ... \$teethCount $teethCount"
                    set _bcDiameter [__get_BCDiameter   $teethCount diameter]
                    if {$_bcDiameter < $bcDiameter_Min} {
                        set bcDiameter_Min $_bcDiameter
                    }
                        # puts "    ... \$teethCount     $teethCount"
                        # puts "    ... \$bcDiameter_Min $bcDiameter_Min"
                }
                foreach teethCount [lrange $teethCountList 0 1] {
                    lappend _chainWheelDef $teethCount $bcDiameter_Min
                }
                
            }
            if {$chainWheelCount == 3} {
                set teethCount [lindex $teethCountList 2]
                set bcDiameter [__get_BCDiameter   $teethCount diameter]
                lappend _chainWheelDef $teethCount $bcDiameter
            }   
                # puts "   -> $_chainWheelDef"
            set  chainWheelDef {}
            foreach {bcd teeth} [lreverse $_chainWheelDef] {
                lappend chainWheelDef $teeth $bcd
            }
                # puts "   -> $chainWheelDef"
                #
            return $chainWheelDef
                #
    }

    proc bikeGeometry::paramComponent::_get_polygon_ChainWheel {teethCount position visMode armCount bcDiameter} {
                #
                # visMode:
                #   opened ... is used in Tk::canvas to show objects behind
                #   closed ... is used to hide objects in lower layers 
                #
            variable anglePrecStep
            variable toothWith
            variable crankSpyderArm_Count
                #
            if {$teethCount < 21} {
                return {}
            }
                #
            if {$armCount == {__default__}} {
                set armCount    $crankSpyderArm_Count
            }
            set spyderArmAngle  [expr 360 / $armCount]
            __updateValues
                #
                #
                # puts " <D>... \$bcDiameter $bcDiameter"
            if {$bcDiameter == {__default__}} {
                set radiusBC    [__get_BCDiameter $teethCount]
            } else {
                set radiusBC    [expr 0.5 * $bcDiameter]
            }
                #
                # puts " ------------------------------------------"    
                # puts "          \$teethCount  $teethCount   "
                # puts "          \$position    $position     "
                # puts "          \$armCount    $armCount     "
                # puts "          \$bcDiameter  $bcDiameter   "
                # puts "          \$visMode     $visMode      "    
                # puts " ------------------------------------------"    
                #
                # -----------------------------
                #   initValues
                # set toothWith           12.7
            set toothWithAngle      [expr 2*$vectormath::CONST_PI/$teethCount]
            set chainWheelRadius    [expr 0.5*$toothWith/sin([expr 0.5*$toothWithAngle])]
            set toothBaseRadius     [expr $chainWheelRadius - 8]
            

                # -----------------------------
                #   toothProfile
                set pt_00 {2 5}                                     ; foreach {x0 y0} $pt_00 break
                set pt_01 [vectormath::rotateLine {0 0} 3.8 100]    ; foreach {x1 y1} $pt_01 break
                set pt_02 [vectormath::rotateLine {0 0} 3.8 125]    ; foreach {x2 y2} $pt_02 break
                set pt_03 [vectormath::rotateLine {0 0} 3.8 150]    ; foreach {x3 y3} $pt_03 break
                set pt_04 [vectormath::rotateLine {0 0} 3.8 170]    ; foreach {x4 y4} $pt_04 break
            set toothProfile [list $x0 -$y0    $x1 -$y1    $x2 -$y2    $x3 -$y3    $x4 -$y4    $x4 $y4    $x3 $y3    $x2 $y2    $x1 $y1    $x0 $y0]

                
                # -----------------------------
                #    chainwheel profile outside
            set index 0 ;# start her for symetriy purpose
            set outerProfile { }
            while { $index < $teethCount } {
                set currentAngle [expr $index * [vectormath::grad $toothWithAngle]]
                set pos [vectormath::rotateLine {0 0} $chainWheelRadius $currentAngle ]

                set tmpList_01 {}
                foreach {x y} $toothProfile {
                    set pt_xy [list $x $y]
                    set pt_xy [vectormath::rotatePoint {0 0} $pt_xy $currentAngle]
                    set pt_xy [vectormath::addVector $pos $pt_xy]
                    append outerProfile [appUtil::flatten_nestedList $pt_xy] " "
                }
                incr index
            }
            set outerProfile [vectormath::addVectorPointList $position $outerProfile]


                # -----------------------------
                #    tooth-base-ring
            set toothBaseProfile    { }
                #
            set currentAngle        0.0
            while {$currentAngle < 360} {
                set currentAngle [expr $currentAngle + $anglePrecStep]
                set pos [vectormath::rotateLine {0 0} $toothBaseRadius $currentAngle ]
                append toothBaseProfile $pos " "
            }
            set toothBaseProfile    [vectormath::addVectorPointList $position $toothBaseProfile] 
                #
                
                
                # -----------------------------
                #    inner profile
            set innerRadius     [expr $radiusBC -7.5]
            set ringWidth       [expr 8 - ($teethCount - 30)/20]
            if {$ringWidth < 7} {set ringWidth 7}
            set ringRadius      [expr $toothBaseRadius - $ringWidth]
                #
            
            set eyeProfile          [list -8.5 7.5]
            set spyderArmAngle      [expr 360 / $armCount]
            set radiusInnerProfile  $innerRadius
                    #
                set eyeProfile      [vectormath::addVectorPointList [list $radiusBC 0] $eyeProfile]
                    #
                set rotAngle        [expr $armCount * $spyderArmAngle]
                    # puts "   ... \$rotAngle  $rotAngle"
                set shapeProfile_left  {}
                set shapeProfile_right {}
                
                set radius01        [expr $radiusInnerProfile + 0.20 * ($ringRadius - $radiusInnerProfile)]
                set radius02        [expr $radiusInnerProfile + 0.45 * ($ringRadius - $radiusInnerProfile)]
                set radius05        [expr $radiusInnerProfile + 0.65 * ($ringRadius - $radiusInnerProfile)]
                set radius06        [expr $radiusInnerProfile + 0.80 * ($ringRadius - $radiusInnerProfile)]
                set radius08        [expr $radiusInnerProfile + 0.95 * ($ringRadius - $radiusInnerProfile)]
                    #
                    #
                set pos01           [vectormath::unifyVector    {0 0} [lrange $eyeProfile 0 1]  $radius01]
                set pos02           [vectormath::rotateLine     {0 0} $radius02                 [expr 0.14 * $spyderArmAngle]]
                set pos05           [vectormath::rotateLine     {0 0} $radius05                 [expr 0.18 * $spyderArmAngle]]
                set pos06           [vectormath::rotateLine     {0 0} $radius06                 [expr 0.23 * $spyderArmAngle]]
                set pos08           [vectormath::rotateLine     {0 0} $radius08                 [expr 0.30 * $spyderArmAngle]]
                set pos20           [vectormath::rotateLine     {0 0} $ringRadius               [expr 0.35 * $spyderArmAngle]]
                set pos21           [vectormath::rotateLine     {0 0} $ringRadius               [expr 0.50 * $spyderArmAngle]]
                    #
                    #
                set diffAngle       [expr [vectormath::dirAngle {0 0} $pos20] - [vectormath::dirAngle {0 0} $pos21]]  
                set rotAngle 0
                while {$rotAngle > $diffAngle} {
                    set pos         [vectormath::rotatePoint    {0 0} $pos21 $rotAngle]
                    append shapeProfile_left $pos " "
                    set rotAngle    [expr $rotAngle -0.5 * $anglePrecStep]
                }
                    #
                    #
                if {$teethCount > 33} {
                    append shapeProfile_left $pos20 " "
                    append shapeProfile_left $pos08 " "
                    append shapeProfile_left $pos06 " "
                    append shapeProfile_left $pos05 " "
                    append shapeProfile_left $pos02 " "
                    append shapeProfile_left $pos01 " "
                } elseif {$teethCount > 27} {
                    append shapeProfile_left $pos20 " "
                    append shapeProfile_left $pos08 " "
                    append shapeProfile_left $pos06 " "
                } else {
                    append shapeProfile_left $pos20 " "
                    append shapeProfile_left $pos08 " "
                }
                    #
                    #
                append shapeProfile_left [appUtil::flatten_nestedList $eyeProfile]
                    #
                    #
                foreach {x y} [appUtil::flatten_nestedList $shapeProfile_left] {
                    set shapeProfile_right "$x [expr -1 * $y] $shapeProfile_right"
                }
                set shapeProfile_right [lrange $shapeProfile_right 0 end-2]
                    #
                    #
                set shapeProfile "$shapeProfile_left $shapeProfile_right "
                    #
                set innerProfile   { }
                set i $armCount            
                while {$i > 0} {
                    set rotAngle    [expr ($i - 0.5) * $spyderArmAngle]
                    set myProfile   [vectormath::rotatePointList    {0 0} $shapeProfile $rotAngle]
                    append innerProfile [appUtil::flatten_nestedList $myProfile] " "
                    incr i -1
                }
                #
                #
            set innerProfile       [vectormath::addVectorPointList $position $innerProfile] 
                #
                
                
                # -----------------------------
                #    return Values    
                #       visMode: polyline ... is used in Tk::canvas to show objects behind
                #       visMode: polygon .... is used to hide objects in lower layers 
                #
                #       return: closed ...... get complete shape by polyline
                #       return: opened ...... get complete shape by polygon
                #
            #puts "<debug A - A>"
            #puts "<debug A> \${chainWheelProfile} \n ${chainWheelProfile}"
            #puts "<debug B> \${chainWheelProfile} \n [string trim ${chainWheelProfile}]"
                    #
            if {$visMode == {polyline}} {
                set chainWheelProfile   [format {%s %s %s}  $outerProfile   [lindex $outerProfile 0]    [lindex $outerProfile 1]]
                set innerRingProfile    [format {%s %s %s}  $innerProfile   [lindex $innerProfile 0]    [lindex $innerProfile 1]]      
                set chainWheelProfile   [format {%s %s}     $chainWheelProfile $innerRingProfile]
                return [list    closed ${chainWheelProfile} \
                                opened ${toothBaseProfile} ]
            } else {
                #puts "<debug> \${chainWheelProfile} ${chainWheelProfile}"
                return [list    closed ${outerProfile}  \
                                closed ${toothBaseProfile} \
                                closed ${innerProfile} ]
            }
                #
    }

    proc bikeGeometry::paramComponent::_get_polygon_CrankArm {crankLength position} {
                #
            variable anglePrecStep
            variable crankWidth_BB
            variable crankWidth_Pedal
                #
            __updateValues    
                #
                
                
                # -----------------------------
                #   initValues
            set index 0
            set crankArmProfile [list [list 10 [expr -0.5 * $crankWidth_BB]] [list 0 [expr -0.5 * $crankWidth_BB]]]
            #set incrAngle       [expr -1 * $anglePrecStep]
                # -----------------------------
            set point [lindex $crankArmProfile 1]
            set angle 270.0
                # -----------------------------
            while {$angle > 90} {
                set angle [expr $angle - $anglePrecStep]
                set point [vectormath::rotatePoint {0 0} $point [expr -1.0 * $anglePrecStep]]
                lappend crankArmProfile $point
            }
                # -----------------------------
            lappend crankArmProfile [list 10 [expr 0.5 * $crankWidth_BB]]
            lappend crankArmProfile [list [expr $crankLength -80] [expr 0.5 * $crankWidth_Pedal]] [list $crankLength [expr 0.5 * $crankWidth_Pedal]]
                # -----------------------------
            set point [lindex $crankArmProfile end]
            set angle 90.0
            while {$angle > -90} {
                set angle [expr $angle - $anglePrecStep]
                set point [vectormath::rotatePoint [list $crankLength 0] $point [expr -1.0 * $anglePrecStep]]
                    # puts "         -> \$angle $angle  -- \$point $point"
                lappend crankArmProfile $point
            }
                # -----------------------------
            lappend crankArmProfile [list [expr $crankLength -80] [expr -0.5 * $crankWidth_Pedal]]
            set crankArmProfile [appUtil::flatten_nestedList $crankArmProfile]
            set crankArmProfile [vectormath::addVectorPointList $position $crankArmProfile]
            return $crankArmProfile
    }

    proc bikeGeometry::paramComponent::_get_polygon_CrankSpyder {bcDiameter position armCount} {
                #
            variable anglePrecStep
            variable crankWidth_BB
            variable crankSpyderArm_Count
                #
            set crankSpyderArm_Count $armCount
            __updateValues    
                #
            set armCount $crankSpyderArm_Count
            set spyderArmAngle  [expr 360 / $armCount]
                #
            set radiusBC [expr 0.5 * $bcDiameter]    
                
                # -----------------------------
                #    base Values    
            set spyderEyeProfile     [list -10.5 -7.5  7.5 -7.5  7.5 7.5  -10.5 7.5]
            set radiusInnerProfile   [expr 7 + 0.5 * $crankWidth_BB]
                #        
            set spyderEyeProfile     [vectormath::addVectorPointList [list $radiusBC 0] $spyderEyeProfile]
                #
            set radius00             [vectormath::length {0 0} [lrange $spyderEyeProfile 0 1]]
                #
                
                
                # -----------------------------
                #    get Spyder    
            set spyderProfile       {}
            set i 0            
            while {$i < $armCount} {
                set rotAngle    [expr ($i + 0.5) * $spyderArmAngle]
                    #
                set myProfile   [vectormath::rotatePointList    {0 0} $spyderEyeProfile $rotAngle ]
                append spyderProfile [appUtil::flatten_nestedList $myProfile] " "
                    #
                    # puts "   \$radiusBC: $radiusBC   - $radiusInnerProfile < $radius00 "
                if {$radiusInnerProfile < $radius00} {
                    set radius01    [expr $radiusInnerProfile + 2]
                    set radius02    $radiusInnerProfile
                        #
                        # puts "   $radius00\n   $radius01\n   $radius02\n "
                        #
                    set pos01       [vectormath::rotateLine         {0 0} $radius01 [expr $rotAngle + 0.3 * $spyderArmAngle]]
                    set pos02       [vectormath::rotateLine         {0 0} $radius02 [expr $rotAngle + 0.4 * $spyderArmAngle]]
                    set pos03       [vectormath::rotateLine         {0 0} $radius02 [expr $rotAngle + 0.6 * $spyderArmAngle]]
                    set pos04       [vectormath::rotateLine         {0 0} $radius01 [expr $rotAngle + 0.7 * $spyderArmAngle]]
                        #
                    append spyderProfile [appUtil::flatten_nestedList "$pos01 $pos02 $pos03 $pos04"] " "
                }   
                 #
                incr i
            }  
                #   
            set spyderProfile       [vectormath::addVectorPointList $position $spyderProfile] 
                #
                
                # -----------------------------
                #    return Values
            return $spyderProfile
                #
             
    }

    proc bikeGeometry::paramComponent::_get_position_ChainWheelBolts {bcDiameter position armCount} {
                #
            variable anglePrecStep
            variable crankWidth_BB
            variable crankSpyderArm_Count
                #
            set crankSpyderArm_Count $armCount
            __updateValues    
                #
            set armCount $crankSpyderArm_Count
            set spyderArmAngle  [expr 360 / $armCount]
                #
            set radiusBC [expr 0.5 * $bcDiameter]    
                #
                    
                # -----------------------------
                #    get position    
            set boltPositonList       {}
            set i 0            
            while {$i < $armCount} {
                set rotAngle    [expr ($i + 0.5) * $spyderArmAngle]
                    #
                set pos     [vectormath::rotateLine    {0 0} $radiusBC $rotAngle ]
                lappend boltPositonList $pos
                incr i
            }
            set boltPositonList     [appUtil::flatten_nestedList $boltPositonList]
            set boltPositonList     [vectormath::addVectorPointList $position $boltPositonList] 
                #
                #
                
                # -----------------------------
                #    return Values
            return $boltPositonList
                #
             
    }

