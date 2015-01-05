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
        #
    variable angle_SeatTubeChainStay    $[namespace parent]::Geometry(BottomBracket_Angle_ChainStay)
    variable angle_SeatTubeDownTube     $[namespace parent]::Geometry(BottomBracket_Angle_DownTube)
    variable angle_HeadTubeDownTube     $[namespace parent]::Geometry(HeadLug_Angle_Bottom)  ;# ... refactor this to HeadLugBottom_Angle
    variable angle_HeadTubeTopTube      $[namespace parent]::Geometry(HeadLug_Angle_Top)
        # 
 }
        #
        # --- update Model
        #
    proc bikeGeometry::model_lugAngle::update_ModelGeometry {} {
            #
        variable angle_HeadTube
        variable angle_SeatTube
        variable angle_HeadTubeTopTube
            #
        set angle_HeadTube          [get_HeadTubeAngle {140 20}]
            #
        update_GeometryValues       
            #
            # -- set value to parameter
        bikeGeometry::update_Geometry
            #
        bikeGeometry::set_Scalar    Geometry SeatTube_Angle     $angle_SeatTube    
            #  
        bikeGeometry::set_Scalar    Geometry HeadLug_Angle_Top  $angle_HeadTubeTopTube    
            #
    }
        #
        # ---
        #
    proc bikeGeometry::model_lugAngle::init_Angles {} {
            #
        variable angle_SeatTubeChainStay
        variable angle_SeatTubeDownTube 
        variable angle_HeadTubeDownTube 
        variable angle_HeadTubeTopTube 
            #
        variable [namespace parent]::Geometry 
            #
        set angle_SeatTubeChainStay $Geometry(BottomBracket_Angle_ChainStay)
        set angle_SeatTubeDownTube  $Geometry(BottomBracket_Angle_DownTube)
        set angle_HeadTubeDownTube  $Geometry(HeadLug_Angle_Bottom)     ;# ... refactor this to HeadLugBottom_Angle
        set angle_HeadTubeTopTube   $Geometry(HeadLug_Angle_Top)
         
            #
        puts ""
        puts "          <i> ... \$angle_SeatTubeChainStay ... $angle_SeatTubeChainStay"
        puts "          <i> ... \$angle_SeatTubeDownTube .... $angle_SeatTubeDownTube "
        puts "          <i> ... \$angle_HeadTubeDownTube .... $angle_HeadTubeDownTube "
        puts "          <i> ... \$angle_HeadTubeTopTube ..... $angle_HeadTubeTopTube "
        puts ""
            # 
    }
    proc bikeGeometry::model_lugAngle::set_Angle {key value} {
            #
        variable angle_SeatTubeChainStay
        variable angle_SeatTubeDownTube 
        variable angle_HeadTubeDownTube 
        variable angle_HeadTubeTopTube 
            #
        init_Angles    
            #
        switch -exact $key {
                ChainStaySeatTube {set angle_SeatTubeChainStay $value}
                SeatTubeDownTube  {set angle_SeatTubeDownTube  $value}
                HeadTubeDownTube  {set angle_HeadTubeDownTube  $value}
                HeadTubeTopTube   {set angle_HeadTubeTopTube   $value}
                default {
                        puts "\n              <W> bikeGeometry::model_lugAngle::set_Angle ... \$value not accepted! ... $value"
                        return {}
                    }
        }            
            #
        puts ""
        puts "          <i> ... \$angle_SeatTubeChainStay ... $angle_SeatTubeChainStay"
        puts "          <i> ... \$angle_SeatTubeDownTube .... $angle_SeatTubeDownTube "
        puts "          <i> ... \$angle_HeadTubeDownTube .... $angle_HeadTubeDownTube "
        puts "          <i> ... \$angle_HeadTubeTopTube ..... $angle_HeadTubeTopTube "
        puts ""
            #
        set scalarValue [bikeGeometry::model_lugAngle::get_Angle $key ]
        puts "              <I> bikeGeometry::bikeGeometry::model_lugAngle::set_Angle ... $key -> $scalarValue"
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
        variable angle_HeadTubeTopTube 
            #
        switch -exact $key {
                SeatTubeChainStay {return $angle_SeatTubeChainStay}
                SeatTubeDownTube  {return $angle_SeatTubeDownTube}
                HeadTubeDownTube  {return $angle_HeadTubeDownTube}
                HeadTubeTopTube   {return $angle_HeadTubeTopTube}
                default           {return {}}
        }
    }
        #
        # ---
        #
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
           # puts "   < $startAngle - $endAngle >"
           # puts "       \$rangeAngle ... $rangeAngle"
           # puts "       \$stepAngle .... $stepAngle"
            #
        # puts "   ... $startAngle °"
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
            #
        set angle_Stem              $[namespace parent]::Geometry(Stem_Angle)
        #set angle_SeatTubeChainStay $[namespace parent]::Geometry::BottomBracket_Angle_ChainStay
        #set angle_SeatTubeDownTube  $[namespace parent]::Geometry::BottomBracket_Angle_DownTube
        #set angle_HeadTubeDownTube  $[namespace parent]::Geometry::HeadLug_Angle_Bottom
            #
        set Reach                   $[namespace parent]::Geometry(HandleBar_Distance)
        set Stack                   $[namespace parent]::Geometry(HandleBar_Height)
        set StemLength              $[namespace parent]::Geometry(Stem_Length)
        set ChainStayOffset         $[namespace parent]::RearDropout(OffsetCSPerp) 
        set ChainStay               $[namespace parent]::Geometry(ChainStay_Length)
            #                       
        set DownTubeDiameter        $[namespace parent]::DownTube(DiameterHT)
        set HeadTubeDiameter        $[namespace parent]::HeadTube(Diameter)
        set HeadTubeDownTubeOffset  $[namespace parent]::DownTube(OffsetHT)
        set HeadSetHeight           $[namespace parent]::HeadSet(Height_Bottom)
        set ForkHeight              $[namespace parent]::Geometry(Fork_Height)
        set ForkRake                $[namespace parent]::Geometry(Fork_Rake)
            #                      
        set FrontWheelRadius        $[namespace parent]::Geometry(FrontWheel_Radius)
        set RearWheelRadius         $[namespace parent]::Geometry(RearWheel_Radius)
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
            puts "      ->  $headTubeAngle"
            puts "      ... $angle_HeadTube"
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
                                $DownTubeDiameter * 0.5 * sin($radFactor *  $angle_HeadTubeDownTube)    \
                            +   ($DownTubeDiameter * 0.5 * cos($radFactor *  $angle_HeadTubeDownTube)    \
                                +   $HeadTubeDiameter * 0.5) / tan($radFactor *  $angle_HeadTubeDownTube)    \
                            +   $HeadTubeDownTubeOffset \
                            +   $HeadSetHeight          \
                            +   $ForkHeight             \
                         ]
            # -- printDebug ---------------
        if $printDebug {
            puts "\n -- ForkHeightCompl ------------\n"
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
            # puts $angle_ChainStay
        set res_RearWheel_x [expr \
                            +   $ChainStayOffset * cos($radFactor * ($angle_ChainStay - 90))   \
                            +   $ChainStay       * cos($radFactor * ($angle_ChainStay))   \
                        ]
        set res_RearWheel_y [expr \
                                $ChainStayOffset * sin($radFactor * ($angle_ChainStay - 90))   \
                            +   $ChainStay       * sin($radFactor * ($angle_ChainStay))   \
                        ]
            # -- printDebug ---------------
        if $printDebug {
            puts "\n -- RearWheel -----------------\n"
            puts "                  $angle_HeadTube °"
            puts "                  $angle_HeadTubeDownTube °"
            puts "                  $angle_SeatTubeChainStay °"
            puts "                  $angle_SeatTubeDownTube °"
            puts "          ... $angle_ChainStay °"
            puts "                  [expr $ChainStayOffset * cos($radFactor * ($angle_ChainStay - 90))]"
            puts "                  [expr $ChainStay       * cos($radFactor * ($angle_ChainStay))]"
            puts "          ... $res_RearWheel_x"
            puts "                  [expr $ChainStayOffset * sin($radFactor * ($angle_ChainStay - 90))]"
            puts "                  [expr $ChainStay       * sin($radFactor * ($angle_ChainStay))]"
            puts "          ... $res_RearWheel_y"
        }
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
        #
        # ---
        #
    proc bikeGeometry::model_lugAngle::update_GeometryValues {} {
            #
        variable radFactor
            #
        variable angle_HeadTube
        variable angle_SeatTube
            #
        variable angle_SeatTubeChainStay
        variable angle_SeatTubeDownTube 
        variable angle_HeadTubeDownTube 
        variable angle_HeadTubeTopTube 
            #
        variable [namespace parent]::Geometry
        variable [namespace parent]::RearDropout
            #
            # (BottomBracket_Angle_ChainStay)
            # set angle_SeatTubeDownTube  $[namespace parent]::Geometry(BottomBracket_Angle_DownTube)
            # set angle_HeadTubeDownTube  $[namespace parent]::Geometry(HeadLug_Angle_Bottom)
            #
        set angle_SeatTube          [expr $angle_HeadTube - $angle_SeatTubeDownTube + $angle_HeadTubeDownTube]
            #
        puts "   ... \$angle_SeatTube       $angle_SeatTube" 
            #
        set angle_ChainStay [expr $angle_SeatTube - $angle_SeatTubeChainStay]
            #
        puts "   ... \$angle_ChainStay      $angle_ChainStay"
            #
        set ChainStayOffset         $RearDropout(OffsetCSPerp) 
        set ChainStay               $Geometry(ChainStay_Length)
            #
        set depth_BottomBracket     [expr $ChainStay * sin($radFactor * $angle_ChainStay) + $ChainStayOffset * cos($radFactor * $angle_ChainStay)]
            #
        puts "   ... \$depth_BottomBracket  $depth_BottomBracket" 
            #
        set Geometry(HeadTube_Angle)                $angle_HeadTube
        set Geometry(BottomBracket_Depth)           $depth_BottomBracket
            #
        set Geometry(BottomBracket_Angle_ChainStay) $angle_SeatTubeChainStay
        set Geometry(BottomBracket_Angle_DownTube)  $angle_SeatTubeDownTube      
        set Geometry(HeadLug_Angle_Bottom)          $angle_HeadTubeDownTube      
        set Geometry(HeadLug_Angle_Top)              $angle_HeadTubeTopTube       
            #
    }
    
    