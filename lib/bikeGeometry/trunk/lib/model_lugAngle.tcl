 ##+##########################################################################
 #
 # package: rattleCAD   ->  model_freeAngle.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2010/11/26
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
 #  namespace:  bikeGeometry::model_lugAngle
 # ---------------------------------------------------------------------------
 #
 # 

 namespace eval bikeGeometry::model_lugAngle {
        #
    namespace export update_ModelGeometry
        #
    variable radFactor                  [expr $vectormath::CONST_PI/180]
        #
    variable printDebug                 0
        #
    variable angle_HeadTube
    variable angle_SeatTube
    variable depth_BottomBracket    
                #
    variable angle_SeatTubeChainStay    $[namespace parent]::Geometry(BottomBracket_Angle_ChainStay)
    variable angle_SeatTubeDownTube     $[namespace parent]::Geometry(BottomBracket_Angle_DownTube)
    variable angle_HeadTubeDownTube     $[namespace parent]::Geometry(HeadLug_Angle_Bottom)  ;# ... refactor this to HeadLugBottom_Angle
    variable angle_HeadTubeTopTube      $[namespace parent]::Geometry(HeadLug_Angle_Top)
        # 
 }
        #
        # ---
        #    
    proc bikeGeometry::model_lugAngle::set_Angle {key value} {
            #
        variable angle_SeatTubeChainStay
        variable angle_SeatTubeDownTube 
        variable angle_HeadTubeDownTube 
            #
        init_Values    
            #
        switch -exact $key {
                ChainStaySeatTube {set angle_SeatTubeChainStay $value}
                SeatTubeDownTube  {set angle_SeatTubeDownTube  $value}
                HeadTubeDownTube  {set angle_HeadTubeDownTube  $value}
                default {
                        puts "\n              <W> bikeGeometry::model_lugAngle::set_Angle ... \$value not accepted! ... $value"
                        return {}
                    }
        }            
            #   HeadTubeTopTube   {set angle_HeadTubeTopTube   $value}
            #
        puts ""
        puts "          <i> ... \$angle_SeatTubeChainStay ... $angle_SeatTubeChainStay"
        puts "          <i> ... \$angle_SeatTubeDownTube .... $angle_SeatTubeDownTube "
        puts "          <i> ... \$angle_HeadTubeDownTube .... $angle_HeadTubeDownTube "
        puts ""
            #
        set scalarValue [bikeGeometry::model_lugAngle::get_Angle $key ]
            #
        puts "\n"
        puts "          <i> bikeGeometry::bikeGeometry::model_lugAngle::set_Angle ... $key -> $scalarValue"
        puts "\n"
            #
        update_ModelGeometry
            #
        return $scalarValue    
            #
    }
    proc bikeGeometry::model_lugAngle::get_Angle {key} {
            #
        variable angle_SeatTubeChainStay
        variable angle_SeatTubeDownTube 
        variable angle_HeadTubeDownTube 
            #
        switch -exact $key {
                SeatTubeChainStay {return $angle_SeatTubeChainStay}
                SeatTubeDownTube  {return $angle_SeatTubeDownTube}
                HeadTubeDownTube  {return $angle_HeadTubeDownTube}
                default           {return {}}
        }
    }
        #
        # --- update Model
        #
    proc bikeGeometry::model_lugAngle::update_ModelGeometry {} {
            #
        variable angle_HeadTube
        variable angle_SeatTube
        variable depth_BottomBracket
            #
        variable [namespace parent]::Geometry
            #
            #
        get_HeadTubeAngle {140 20}
            #
            # puts "          \$angle_HeadTube          $angle_HeadTube       "
            # puts "          \$angle_SeatTube          $angle_SeatTube       "
            # puts "          \$depth_BottomBracket     $depth_BottomBracket  "
            #
        set HeadTube_Angle      [expr 360 - $angle_HeadTube] 
        set SeatTube_Angle      [expr 360 - $angle_SeatTube] 
        set BottomBracket_Depth $depth_BottomBracket 
            #
            # puts "          \$HeadTube_Angle          $HeadTube_Angle       "
            # puts "          \$SeatTube_Angle          $SeatTube_Angle       "
            # puts "          \$BottomBracket_Depth     $BottomBracket_Depth  "
            #
        set Geometry(HeadTube_Angle)        $HeadTube_Angle
        set Geometry(BottomBracket_Depth)   $BottomBracket_Depth
            #
            # -- set value to parameter
        bikeGeometry::update_Geometry
            #
        bikeGeometry::IF_OutsideIn  set_Scalar    Geometry SeatTube_Angle $SeatTube_Angle    
            # 
        puts "\n"
        puts "      --------------------------------------------------------------"
        puts "          bikeGeometry::model_lugAngle::update_ModelGeometry    "
        puts "                \$angle_HeadTube          $angle_HeadTube       "
        puts "                \$angle_SeatTube          $angle_SeatTube       "
        puts "                \$depth_BottomBracket     $depth_BottomBracket  "
        puts "\n"
            #
    }
        #
        # ---
        #
    proc bikeGeometry::model_lugAngle::init_Values {} {
            #
        variable angle_SeatTubeChainStay
        variable angle_SeatTubeDownTube 
        variable angle_HeadTubeDownTube 
            #
        variable [namespace parent]::Geometry 
            #
        set angle_SeatTubeChainStay [set Geometry(BottomBracket_Angle_ChainStay)]
        set angle_SeatTubeDownTube  [set Geometry(BottomBracket_Angle_DownTube) ]
        set angle_HeadTubeDownTube  [set Geometry(HeadLug_Angle_Bottom)         ] ;# ... refactor this to HeadLugBottom_Angle
         
            #
        puts ""
        puts "          <i> ... \$angle_SeatTubeChainStay ... $angle_SeatTubeChainStay"
        puts "          <i> ... \$angle_SeatTubeDownTube .... $angle_SeatTubeDownTube "
        puts "          <i> ... \$angle_HeadTubeDownTube .... $angle_HeadTubeDownTube "
        puts ""
            #
            # -- calculation does not take care about SeatTube & DownTube Offset to BottomBracket
        bikeGeometry::set_Scalar    SeatTube OffsetBB           0    
        bikeGeometry::set_Scalar    DownTube OffsetBB           0    
            #
    }
    proc bikeGeometry::model_lugAngle::get_HeadTubeAngle {border} {
            #
        for {set l 6} {$l <= 6} {incr l} {
                set startTime [clock microseconds ]
                # set border {140 20}
                for {set i 0} {$i <= $l} {incr i} {
                    set border [[namespace current]::_iterate_HeadTubeAngle $border]
                }
                set endTime [clock microseconds ]
                foreach {a b} $border break
                set HeadTubeAngle [format {%.8f} [expr ($a + $b)/2]]
                  # puts ""
                  # puts "    ... $HeadTubeAngle ... [expr $endTime - $startTime] microseconds     .... $border"
                  # puts "    ... $l ... $HeadTubeAngle ... [expr $endTime - $startTime] microseconds     .... $border"
                return $HeadTubeAngle
        }        
    }
    proc bikeGeometry::model_lugAngle::_iterate_HeadTubeAngle {border} {
            #
            # puts "   <I> \$border ... $border"
        foreach {startAngle endAngle} $border break
            #
        if {$startAngle != $endAngle} {
            set maxLoops 20
        } else {
            set maxLoops 1
        }
            #
        set rangeAngle  [expr $endAngle - $startAngle]
        set stepAngle   [expr 1.0*$rangeAngle / $maxLoops]
            #
        set lastAngle   $startAngle  
        set chgBorder   0      
        set lastValue   0      
            #
            #
        for {set i 0} {$i <= $maxLoops} {incr i} {
            set ht_angle [expr $startAngle + $i*$stepAngle]
                #puts "           \$ht_angle .... $ht_angle"
            set value [[namespace current]::_lug_Determination $ht_angle]
                # puts "                        ... $value"
            set chgBorder [expr $value/$lastValue]
                # puts "                        ... $chgBorder"
            if {$chgBorder < 0} {
                    # puts "                        ... $lastAngle .... $lastValue"
                    # puts "                        ... $ht_angle .... $value"
                return [list $lastAngle $ht_angle]
            } else {
                set lastAngle $ht_angle
                set lastValue $value
            }
        }
            #
        return $lastAngle     
    }
    proc bikeGeometry::model_lugAngle::_lug_Determination {headTubeAngle} {
            #
        variable radFactor
        variable printDebug
            #
        variable angle_SeatTubeChainStay
        variable angle_SeatTubeDownTube 
        variable angle_HeadTubeDownTube 
        variable angle_HeadTubeTopTube 
            #
        variable angle_HeadTube         
        variable angle_SeatTube         
        variable depth_BottomBracket    
            #
        set angle_Stem              $[namespace parent]::Geometry(Stem_Angle)
            #
        set Reach                   [set [namespace parent]::Geometry(HandleBar_Distance)]
        set Stack                   [set [namespace parent]::Geometry(HandleBar_Height)  ]
        set StemLength              [set [namespace parent]::Geometry(Stem_Length)       ]
        set ChainStayOffset         [set [namespace parent]::RearDropout(OffsetCSPerp)   ]
        set ChainStayLength         [set [namespace parent]::Geometry(ChainStay_Length)  ]
            #                       
        set DropOut_OffsetCS        [set [namespace parent]::RearDropout(OffsetCS)       ]
        set DropOut_Rotate          [set [namespace parent]::RearDropout(RotationOffset) ]
        set DropOut_Orient          [set [namespace parent]::Config(RearDropoutOrient)   ]
            #                      
        set DownTubeDiameter        [set [namespace parent]::DownTube(DiameterHT)   ]
        set HeadTubeDiameter        [set [namespace parent]::HeadTube(Diameter)     ]
        set HeadTubeDownTubeOffset  [set [namespace parent]::DownTube(OffsetHT)     ]
        set HeadSetHeight           [set [namespace parent]::HeadSet(Height_Bottom) ]
        set ForkHeight              [set [namespace parent]::Geometry(Fork_Height)  ]
        set ForkRake                [set [namespace parent]::Geometry(Fork_Rake)    ]
            #
        set FrontWheelRadius        [set [namespace parent]::Geometry(FrontWheel_Radius) ]
        set RearWheelRadius         [set [namespace parent]::Geometry(RearWheel_Radius)  ]
            #
            #
        # puts "\n"
        # puts " ==- COMPILE -========================="
            #
        set angle_HeadTube   [expr 360 - $headTubeAngle]
            # -- printDebug ---------------
        if $printDebug {
            puts "\n\n"
            puts "\n -- angle_HeadTube -------------\n"
            puts "          ->  \$headTubeAngle ............. $angle_HeadTube"
            puts "          ... \$angle_SeatTubeChainStay ... $angle_SeatTubeChainStay"
            puts "          ... \$angle_SeatTubeDownTube .... $angle_SeatTubeDownTube "
            puts "          ... \$angle_HeadTubeDownTube .... $angle_HeadTubeDownTube "
        }
            #
        set angle_DownTube  [expr $angle_HeadTube - $angle_HeadTubeDownTube] 
        set StemLengthEff   [expr $StemLength * cos($radFactor * $angle_Stem)]    
            #
            # -- printDebug ---------------
        if $printDebug {
            puts "\n -- StemLengthEff --------------\n"
            puts "          ... $StemLengthEff"
        }
            #
        set res_Stem_x      [expr $Reach + $StemLengthEff*cos($radFactor * ($angle_HeadTube - 90))]   
        set res_Stem_y      [expr $Stack + $StemLengthEff*sin($radFactor * ($angle_HeadTube - 90))] 
        set Stem_Position   [list $res_Stem_x $res_Stem_y]
            #
            # -- printDebug ---------------
        if $printDebug {
            puts "\n -- Stem_Position --------------\n"
            puts "                  ... [expr $StemLengthEff*cos($radFactor * ($angle_HeadTube - 90))]"
            puts "                  ... [expr $StemLengthEff*sin($radFactor * ($angle_HeadTube - 90))]"
            puts "                  $res_Stem_x"
            puts "                  $res_Stem_y"
        }
            #
        set dir_HeadTube    [vectormath::rotateLine {0 0} 1 $angle_HeadTube]        
        set dir_DownTube    [vectormath::rotateLine {0 0} 1 $angle_DownTube]        
            #
        set det_Point       [vectormath::intersectPointVector {0 0} $dir_DownTube [list $res_Stem_x $res_Stem_y] $dir_HeadTube]  
        set detPoint_x      [lindex $det_Point 0]
        set detPoint_y      [lindex $det_Point 1]
            #
        set HeadTubeLength  [vectormath::length $Stem_Position $det_Point]
            #
            # -- printDebug ---------------
        if $printDebug {
            puts "\n -- HeadTubeLength -------------\n"
            puts "                  $detPoint_x"
            puts "                  $detPoint_y"
            puts "          ... $HeadTubeLength"
        }
        
            #
            # -- Fork, part along HeadTube ... intersection with Downtube
            # ----------------------------------------------------
            #
        set ForkHeightCompl [expr \
                                $DownTubeDiameter * 0.5 / sin($radFactor *  $angle_HeadTubeDownTube)    \
                            +   $HeadTubeDiameter * 0.5 / tan($radFactor *  $angle_HeadTubeDownTube)    \
                            +   $HeadTubeDownTubeOffset \
                            +   $HeadSetHeight          \
                            +   $ForkHeight             \
                         ]
            # -- printDebug ---------------
        if $printDebug {
            puts "\n -- ForkHeightCompl ------------\n"
            puts "                    ...   $angle_HeadTubeDownTube"
            puts "                  [expr $DownTubeDiameter * 0.5 * sin($radFactor *  $angle_HeadTubeDownTube)]"
            puts "                  [expr ($DownTubeDiameter * 0.5 * cos($radFactor *  $angle_HeadTubeDownTube)    \
                                        +   $HeadTubeDiameter * 0.5) / tan($radFactor *  $angle_HeadTubeDownTube)]"
            puts "                  $HeadTubeDownTubeOffset"
            puts "                  $HeadSetHeight         "
            puts "                  $ForkHeight            "
            puts "          ... $ForkHeightCompl"
        }
        
            #
            # -- FrontWheel
            # ----------------------------------------------------
            #
        set res_FrontWheel_x [expr \
                                $detPoint_x \
                            +   $ForkHeightCompl * cos($radFactor *  $angle_HeadTube)        \
                            +   $ForkRake        * cos($radFactor * ($angle_HeadTube - 270)) \
                        ]
        set res_FrontWheel_y [expr \
                                $detPoint_y \
                            +   $ForkHeightCompl * sin($radFactor *  $angle_HeadTube)        \
                            +   $ForkRake        * sin($radFactor * ($angle_HeadTube - 270)) \
                        ]
            # -- printDebug ---------------
        if $printDebug {
            puts "\n -- FrontWheel -----------------\n"
            puts "                  $detPoint_x"
            puts "                  [expr $ForkHeightCompl * cos($radFactor *  $angle_HeadTube)]"
            puts "                  [expr $ForkRake        * cos($radFactor * ($angle_HeadTube - 270))]"
            puts "          ... $res_FrontWheel_x"
            puts "                  $detPoint_y"
            puts "                  [expr $ForkHeightCompl * sin($radFactor *  $angle_HeadTube)]"
            puts "                  [expr $ForkRake        * sin($radFactor * ($angle_HeadTube - 270))]"
            puts "          ... $res_FrontWheel_y"
        }
            #
            # -- RearWheel
            # ----------------------------------------------------
            #
        set angle_ChainStay [expr $angle_HeadTube - $angle_HeadTubeDownTube - (180 - $angle_SeatTubeChainStay - $angle_SeatTubeDownTube)]
            #
        switch -exact  $DropOut_Orient {
                ChainStay  -
                Chainstay  { 
                        set do_angle    [expr 360 - $DropOut_Rotate]
                        set vct_xy      [ list $DropOut_OffsetCS [expr -1.0 * $ChainStayOffset]]
                        set do_angle    [expr 360 - $DropOut_Rotate]
                        set vct_CS      [vectormath::rotatePoint   {0 0}  $vct_xy  $do_angle]
                        set pt_cs       [vectormath::addVector     [list [expr -1.0 * $ChainStayLength] 0] $vct_CS]
                            # puts "\n  <I> \$pt_cs $pt_cs \n"
                        foreach {x y} $pt_cs break;
                        set angle_DropoutOffset [vectormath::dirAngle      $pt_cs  {0 0}]
                            # puts "\n  <I> \$angle_DropoutOffset $angle_DropoutOffset \n"
                        set angle_ChainStay_eff [expr $angle_ChainStay - $angle_DropoutOffset]
                            # puts "\n  <I> \$angle_ChainStay_eff $angle_ChainStay_eff \n"
                            #
                        set res_RearWheel_x [expr \
                                            +   $ChainStayLength       * cos($radFactor * $angle_ChainStay_eff)   \
                                        ]
                        set res_RearWheel_y [expr \
                                            +   $ChainStayLength       * sin($radFactor * $angle_ChainStay_eff)   \
                                        ]
                            
                    }
                horizontal { 
                            #     offset   
                            #       +-----+-------------+ radius (ChainStayLength)
                            #             |  offsetPerp
                            #             +
                            #              \
                            #               \
                            #                \  secant (angle_ChainStay)
                            #                 \
                            #                  +    
                            #      
                            # secant
                        set my_x $DropOut_OffsetCS 
                        set my_y [expr -1.0 * $ChainStayOffset]
                        puts "  -> angle_ChainStay $angle_ChainStay "
                        set my_k [expr tan($radFactor * (180 + $angle_ChainStay))]
                        set my_d [expr $my_y - $my_x * $my_k]
                        puts "   \$my_x $my_x"
                        puts "   \$my_y $my_y"
                        puts "   \$my_k $my_k"
                        puts "   \$my_d $my_d"
                            #
                        set my_a [expr 1 + pow($my_k, 2)]
                        set my_b [expr 2 * $my_k * $my_d]
                        set my_c [expr pow($my_d, 2) - pow($ChainStayLength, 2)]
                        puts "   \$my_a $my_a"
                        puts "   \$my_b $my_b"
                        puts "   \$my_c $my_c"
                        # 2015-01-17 - https://gatechgrad.wordpress.com/2011/09/25/quadratic-formula/
                        # 
                        foreach {my_x1 my_x2} [solve_quadraticFormula $my_a $my_b $my_c] {break}
                        puts "   \$my_x1 $my_x1"
                        puts "   \$my_x2 $my_x2"
                        if {$my_x1 > $my_x2} {
                                set res_RearWheel_x $my_x1
                        } else {
                                set res_RearWheel_x $my_x2
                        }
                        set res_RearWheel_y [expr $res_RearWheel_x * $my_k + $my_d]
                            #
                        set res_RearWheel_y [expr -1.0 * $res_RearWheel_y]  ;# in view of BottomBracket
                            #
                        puts "     \$res_RearWheel_x $res_RearWheel_x"
                        puts "     \$res_RearWheel_y $res_RearWheel_y"
                    }
                default    {exit}
        }
             # -- printDebug ---------------
        if $printDebug {
            puts "\n -- RearWheel -----------------\n"
            puts "                  $angle_HeadTubeDownTube °"
            puts "                  $angle_SeatTubeChainStay ° - $angle_DropoutOffset °"
            puts "                  $angle_SeatTubeDownTube °"
            puts "          ... $angle_ChainStay °"
            puts "                  [expr $ChainStayLength       * cos($radFactor * ($angle_ChainStay))]"
            puts "          ... $res_RearWheel_x"
            puts "                  [expr $ChainStayLength       * sin($radFactor * ($angle_ChainStay))]"
            puts "          ... $res_RearWheel_y"
        }
            #
            # -- set result Values
            # ----------------------------------------------------
            #
        set angle_SeatTube      [expr $angle_HeadTube  - $angle_HeadTubeDownTube + $angle_SeatTubeDownTube]
        set depth_BottomBracket $res_RearWheel_y
            #
            # -- check offset
            # ----------------------------------------------------
            #
        set vert_WheelOffset    [expr $RearWheelRadius - $FrontWheelRadius] 
        set res_WheelOffset     [expr $res_RearWheel_y - $res_FrontWheel_y]

            #
        set delta               [expr $res_WheelOffset - $vert_WheelOffset]
            #
            #
            # -- printDebug ---------------
        if $printDebug {
            puts "\n -- resultValues --------------\n"
            puts "          ->  \$angle_HeadTube ............ $angle_HeadTube ([expr 360 - $angle_HeadTube]("
            puts "          ->  \$angle_SeatTube ............ $angle_SeatTube ([expr 360 - $angle_SeatTube]("
            puts "          ->  \$depth_BottomBracket ....... $depth_BottomBracket"
            puts "          ... \$angle_SeatTubeChainStay ... $angle_SeatTubeChainStay"
            puts "          ... \$angle_SeatTubeDownTube .... $angle_SeatTubeDownTube "
            puts "          ... \$angle_HeadTubeDownTube .... $angle_HeadTubeDownTube "
            puts "\n -- delta ---------------------\n"
            puts "                  $vert_WheelOffset ($RearWheelRadius - $FrontWheelRadius)"
            puts "                  $res_WheelOffset (res_RearWheel_y - $res_FrontWheel_y)"
            puts "      ->  [format {%12.8f} $delta]"
            puts "\n\n"
        }
            #
        return $delta   
            #   
    }
    
    proc bikeGeometry::model_lugAngle::solve_quadraticFormula {a b c} {
                # https://gatechgrad.wordpress.com/2011/09/25/quadratic-formula/
                # 2015-01-17
            # puts "    -> $a $b $c"    
                #
            set fRoot1 {}    
            set fRoot2 {}    
                #
                # set value_01 [expr (-1.0 * $b)]
                # set value_02 [expr sqrt(pow($b, 2) - (4 * $a * $c))]
                # set value_03 [expr (2 * $a)]
                # 
                # puts "     \$value_01 $value_01"
                # puts "     \$value_02 $value_02"
                # puts "     \$value_03 $value_03"
                #
            set fRoot1 [expr (-1.0 * $b + sqrt(pow($b, 2) - (4 * $a * $c))) / (2 * $a)]
            set fRoot2 [expr (-1.0 * $b - sqrt(pow($b, 2) - (4 * $a * $c))) / (2 * $a)]
                #
            #puts [format "x=%.2f, x=%.2f" $fRoot1 $fRoot2]
                #
                # puts "    -> $fRoot1 $fRoot2"    
            return [list $fRoot1 $fRoot2]
    }
