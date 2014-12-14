 ##+##########################################################################
 #
 # package: bikeGeometry    ->    lib_geometry.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2014/11/30
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
 #    namespace:  bikeGeometry::geometry
 # ---------------------------------------------------------------------------
 #
 #
 
    namespace eval bikeGeometry::geometry {
            #
        variable BottomBracket_Depth         66.0 
        variable ChainStay_Length           410.0
        variable Fork_Height                365.0
        variable Fork_Rake                   45.0
        variable FrontWheel_Radius          336.0
        variable HandleBar_Distance         481.0
        variable HandleBar_Height           635.0
        variable HeadTube_Angle              72.5
        variable Inseam_Distance             80.0
        variable Inseam_Length              850.0
        variable RearWheel_Radius           336.0
        variable Saddle_Distance            212.7
        variable Saddle_Height              710.0
        variable Saddle_MountHeight          40.0
        variable Saddle_MountOffset_x         0.0
        variable Saddle_NoseLength          150.0
        variable SeatPost_PivotOffset        40.0
        variable SeatPost_Setback            25.0
        variable SeatTube_OffsetBB            0.0
        variable Stem_Angle                   6.0
        variable Stem_Length                110.0
        variable TopTube_Angle                2.5
            #
        variable Angle;     array set Angle     {};
        variable Direction; array set Direction {};
        variable Length;    array set Length    {};
        variable Position;  array set Position  {};
            #
    }
        #
    proc bikeGeometry::geometry::_updateNamespace {} {
            #
        bikeGeometry::geometry::create_GeometryRear
        bikeGeometry::geometry::create_GeometryCenter
        bikeGeometry::geometry::create_GeometryFront   
            #
    }
        #
    proc bikeGeometry::geometry::report_Vars {} {
            #
        puts ""
        puts "   -- bikeGeometry::geometry::report_Vars ---"
        puts ""
            #
        foreach varName [lsort [info vars  [format "%s::*" [namespace current]]]] {
            if {[array exists $varName]} {
                continue
            } else {
                puts     "          [format    {%-50s %s}  $varName [set $varName]]"
            }
        }
            #
        foreach varName [lsort [info vars  [format "%s::*" [namespace current]]]] {
            if {[array exists $varName]} {
                puts ""
                puts     "          [format    {%-46s}  $varName] ... \[array\]"
                foreach key [lsort [array names $varName]] {
                    foreach {name value} [array get $varName $key] break
                    puts "              [format {%-25s %s} $name $value]"
                }
            }
        }
        puts ""
            #
    }
        #
    proc bikeGeometry::geometry::setValue   {key {value {}}} {
            #
        variable BottomBracket_Depth   
        variable ChainStay_Length      
        variable Fork_Height             
        variable Fork_Rake             
        variable FrontWheel_Radius     
        variable HandleBar_Distance    
        variable HandleBar_Height      
        variable HeadTube_Angle        
        variable Inseam_Distance       
        variable Inseam_Length         
        variable RearWheel_Radius      
        variable Saddle_Distance       
        variable Saddle_Height         
        variable Saddle_MountHeight
        variable Saddle_MountOffset_x  
        variable Saddle_NoseLength      
        variable SeatPost_PivotOffset  
        variable SeatPost_Setback      
        variable SeatTube_OffsetBB     
        variable Stem_Angle            
        variable Stem_Length           
            #
            # puts " <1> ... $key $value"
            #
        if {[string equal $value {}]} {
                # puts "    ... get"
            set retValue [set $key]
        } else {
                # puts "    ... set"
            set formatValue [bikeGeometry::check_mathValue $value]
            if {[string equal $formatValue {}]} {
                set retValue [set $key]
            } else {
                set retValue [set $key $formatValue]
                    #
                _update
            }
        }
        return $retValue
    }
        #
    proc bikeGeometry::geometry::setResult  {key {value {}}} {
            #
        variable Angle        
        variable Direction      
        variable Length
            #
            # puts " <1> ... $key $value"
            #
        if {[string equal $value {}]} {
            set formatValue {}
        } else {
            set formatValue [bikeGeometry::check_mathValue $value]
        }
            #
        if {[string equal $formatValue {}]} {
            switch -exact $key {
                BottomBracket_Height    { set retValue [lindex [array get Length    BottomBracket_Height]   1] }
                HeadTubeTopTube_Angle   { set retValue [lindex [array get Angle     HeadTubeTopTube]        1] }
                SeatTube_Angle          { set retValue [lindex [array get Angle     SeatTube]               1] }
            }
        } else {
            switch -exact $key {
                BottomBracket_Height    { set retValue [set__Result_BottomBracket_Height    $value] }
                HeadTubeTopTube_Angle   { set retValue [set__Result_HeadTubeTopTube_Angle   $value] }
                SeatTube_Angle          { set retValue [set__Result_SeatTube_Angle          $value] }
            }
        }
            #
        return [format "%.3f" $retValue]
    }
        #
    proc bikeGeometry::geometry::set_BottomBracket_Depth    { {value {}} }  { return [bikeGeometry::geometry::setValue  BottomBracket_Depth      $value] }
    proc bikeGeometry::geometry::set_ChainStay_Length       { {value {}} }  { return [bikeGeometry::geometry::setValue  ChainStay_Length         $value] }
    proc bikeGeometry::geometry::set_Fork_Height            { {value {}} }  { return [bikeGeometry::geometry::setValue  Fork_Height              $value] }
    proc bikeGeometry::geometry::set_Fork_Rake              { {value {}} }  { return [bikeGeometry::geometry::setValue  Fork_Rake                $value] }
    proc bikeGeometry::geometry::set_FrontWheel_Radius      { {value {}} }  { return [bikeGeometry::geometry::setValue  FrontWheel_Radius        $value] }
    proc bikeGeometry::geometry::set_HandleBar_Distance     { {value {}} }  { return [bikeGeometry::geometry::setValue  HandleBar_Distance       $value] }
    proc bikeGeometry::geometry::set_HandleBar_Height       { {value {}} }  { return [bikeGeometry::geometry::setValue  HandleBar_Height         $value] }
    proc bikeGeometry::geometry::set_HeadTube_Angle         { {value {}} }  { return [bikeGeometry::geometry::setValue  HeadTube_Angle           $value] }
    proc bikeGeometry::geometry::set_Inseam_Distance        { {value {}} }  { return [bikeGeometry::geometry::setValue  Inseam_Distance          $value] }
    proc bikeGeometry::geometry::set_Inseam_Length          { {value {}} }  { return [bikeGeometry::geometry::setValue  Inseam_Length            $value] }
    proc bikeGeometry::geometry::set_RearWheel_Radius       { {value {}} }  { return [bikeGeometry::geometry::setValue  RearWheel_Radius         $value] }
    proc bikeGeometry::geometry::set_Saddle_Distance        { {value {}} }  { return [bikeGeometry::geometry::setValue  Saddle_Distance          $value] }
    proc bikeGeometry::geometry::set_Saddle_Height          { {value {}} }  { return [bikeGeometry::geometry::setValue  Saddle_Height            $value] }
    proc bikeGeometry::geometry::set_Saddle_MountHeight     { {value {}} }  { return [bikeGeometry::geometry::setValue  Saddle_MountHeight       $value] }
    proc bikeGeometry::geometry::set_Saddle_MountOffset_x   { {value {}} }  { return [bikeGeometry::geometry::setValue  Saddle_MountOffset_x     $value] }
    proc bikeGeometry::geometry::set_Saddle_NoseLength      { {value {}} }  { return [bikeGeometry::geometry::setValue  Saddle_NoseLength        $value] }
    proc bikeGeometry::geometry::set_SeatPost_PivotOffset   { {value {}} }  { return [bikeGeometry::geometry::setValue  SeatPost_PivotOffset     $value] }
    proc bikeGeometry::geometry::set_SeatPost_Setback       { {value {}} }  { return [bikeGeometry::geometry::setValue  SeatPost_Setback         $value] }
    proc bikeGeometry::geometry::set_SeatTube_OffsetBB      { {value {}} }  { return [bikeGeometry::geometry::setValue  SeatTube_OffsetBB        $value] }
    proc bikeGeometry::geometry::set_Stem_Angle             { {value {}} }  { return [bikeGeometry::geometry::setValue  Stem_Angle               $value] }
    proc bikeGeometry::geometry::set_Stem_Length            { {value {}} }  { return [bikeGeometry::geometry::setValue  Stem_Length              $value] }
        #
    proc bikeGeometry::geometry::set_BottomBracket_Height   { {value {}} }  { return [bikeGeometry::geometry::setResult BottomBracket_Height    $value] }
    proc bikeGeometry::geometry::set_HeadTubeTopTube_Angle  { {value {}} }  { return [bikeGeometry::geometry::setResult HeadTubeTopTube_Angle   $value] }
    proc bikeGeometry::geometry::set_SeatTube_Angle         { {value {}} }  { return [bikeGeometry::geometry::setResult SeatTube_Angle          $value] }
        
        #
        # --- set basePoints Attributes
        #
    proc bikeGeometry::geometry::create_GeometryRear {} {
                #
            variable BottomBracket_Depth   
            variable ChainStay_Length      
                #
                #
            variable Length
            variable Position
                #
                #
            set Length(RearWheel_x)  [ expr sqrt(pow($ChainStay_Length,2)  - pow($BottomBracket_Depth,2)) ]
                #
            set Position(RearDropout)   [list [expr -1.0 * $Length(RearWheel_x)] $BottomBracket_Depth]
                #
            return
                #
    }   
        #
    proc bikeGeometry::geometry::create_GeometryCenter {} {
                    #
            variable BottomBracket_Depth   
            variable ChainStay_Length      
            variable RearWheel_Radius                  
            variable Inseam_Distance        
            variable Inseam_Length        
            variable Saddle_Distance       
            variable Saddle_Height         
            variable Saddle_MountHeight
            variable Saddle_MountOffset_x
            variable Saddle_NoseLength
            variable SeatPost_Setback       
            variable SeatPost_PivotOffset  
            variable SeatTube_OffsetBB
                #
                #
            variable Angle
            variable Direction
            variable Length
            variable Position
                #
                #
            set Length(BottomBracket_Height)    [ expr $RearWheel_Radius - $BottomBracket_Depth ]
            set Position(BottomBracket_Ground)  [ list 0    [expr - $RearWheel_Radius + $BottomBracket_Depth ] ]
                #
                # check-Value-procedure
            if {$Saddle_MountHeight < 0} {
                   set Saddle_MountHeight 0
            }
                #
            set Position(Saddle)            [ list [expr -1.0 * $Saddle_Distance]  $Saddle_Height ]
            set Position(Saddle_Nose)       [ vectormath::addVector  $Position(Saddle) [list [expr $Saddle_NoseLength + $Saddle_MountOffset_x] -15] ]
                #
            set Length(SeatPost_Height)     [ expr $Saddle_Height - $Saddle_MountHeight ]
            set Position(SeatPost_Saddle)   [ list [expr -1.0 * $Saddle_Distance] $Length(SeatPost_Height) ]
            set Position(SeatPost_Pivot)    [ vectormath::addVector $Position(SeatPost_Saddle)  [list 0 $SeatPost_PivotOffset] -1]
                set hlp_01                  [ vectormath:::cathetusPoint {0 0} $Position(SeatPost_Pivot) [expr $SeatPost_Setback - $SeatTube_OffsetBB] {opposite}]
                set vct_01                  [ vectormath:::parallel {0 0} $hlp_01 $SeatTube_OffsetBB]
            set Position(SeatPost_SeatTube)      [ lindex $vct_01 1]
            set Position(SeatTube_BottomBracket) [ lindex $vct_01 0]
            set Angle(SeatTube)             [ vectormath::angle         $Position(SeatPost_SeatTube)      $Position(SeatTube_BottomBracket) [list -100 [lindex $Position(SeatTube_BottomBracket) 1]]]
            set Direction(SeatTube)         [ vectormath::unifyVector   $Position(SeatTube_BottomBracket) $Position(SeatPost_SeatTube) ]
                #
                # --- get LegClearance - Position
            set Position(LegClearance)      [list $Inseam_Distance     [expr $Inseam_Length - $RearWheel_Radius - $BottomBracket_Depth]]
                # set LegClearance(Position)  [ list $TopTube(PivotPosition)  [expr $Inseam_Length) - ($RearWheel_Radius) - $BottomBracket_Depth)) ] ]
                #
                #
            set Position(Saddle_Proposal)   [ vectormath::rotateLine {0 0}  [ expr 0.88 * $Inseam_Length ]  [ expr 180 - $Angle(SeatTube) ] ]
                set hlp_02                  [ vectormath::addVector    $Position(BottomBracket_Ground) {200 0}]
            set Position(SeatTube_Ground)   [ vectormath::intersectPoint    $Position(SeatPost_SeatTube)    $Position(SeatTube_BottomBracket)      $Position(BottomBracket_Ground)  $hlp_02 ]
                #
            set Position(SeatTube_Saddle)   [ vectormath::intersectPoint    [list 0 [lindex $Position(Saddle) 1] ] [list 100 [lindex $Position(Saddle) 1]] $Position(SeatTube_BottomBracket) $Position(SeatPost_SeatTube) ]
                #
                #
            return
                #
    }    
        #
    proc bikeGeometry::geometry::create_GeometryFront {} {
                #
            variable BottomBracket_Depth
            variable Fork_Height
            variable Fork_Rake
            variable FrontWheel_Radius
            variable HandleBar_Distance
            variable HandleBar_Height
            variable HeadTube_Angle
            variable RearWheel_Radius
            variable Stem_Angle
            variable Stem_Length
            variable TopTube_Angle            
                #
                #
            variable Angle
            variable Direction
            variable Length
            variable Position
                #
                #
            set Length(FrontWheel_y)        [ expr $BottomBracket_Depth - $RearWheel_Radius + $FrontWheel_Radius ]                
                #
            set Position(HandleBar)         [ list $HandleBar_Distance $HandleBar_Height ]    
                #
            set vect_01 [ expr $Stem_Length * cos($Stem_Angle * $vectormath::CONST_PI / 180) ]
            set vect_03 [ expr $vect_01 / sin($HeadTube_Angle * $vectormath::CONST_PI / 180) ]
                #
            set Position(Steerer_Handlebar) [ list  [expr $HandleBar_Distance - $vect_03]  $HandleBar_Height ]
                #
            set help_03 [ vectormath::rotateLine       $Position(HandleBar)         100    [expr  90 - $HeadTube_Angle + $Stem_Angle]   ]
            set help_04 [ vectormath::rotateLine       $Position(Steerer_Handlebar) 100    [expr 180 - $HeadTube_Angle] ]
                #
            set Position(Steerer_Stem)      [ vectormath::intersectPoint    $Position(HandleBar)  $help_03 $Position(Steerer_Handlebar) $help_04 ]
                #
            set vect_04 [ vectormath::parallel      $Position(Steerer_Stem)      $help_04    $Fork_Rake ]
            set help_05 [ lindex $vect_04 0 ]
            set help_06 [ lindex $vect_04 1 ]
                #
            set Position(Fork_Dropout)      [ vectormath::intersectPoint    $help_05  $help_06 [list 0 $Length(FrontWheel_y)] [list 200 $Length(FrontWheel_y)] ]
            set Length(FrontWheel_x)        [ lindex $Position(Fork_Dropout) 0]
            set Length(FrontWheel_xy)       [ expr hypot($Length(FrontWheel_x),$Length(FrontWheel_y)) ]
                #
            set Position(Steerer_FrontWheel)    [ vectormath::rotateLine    $Position(Fork_Dropout)    $Fork_Rake    [expr 270 - $HeadTube_Angle] ]
            set Position(Steerer_Fork)          [ vectormath::addVector     $Position(Steerer_FrontWheel)     [ vectormath::unifyVector  $Position(Steerer_FrontWheel)  $Position(Steerer_Stem)  $Fork_Height ] ]
               #
            set help_07  [ vectormath::addVector    $Position(Fork_Dropout) [list 0 [expr -1.0 * $FrontWheel_Radius]] ]
            set help_08  [ vectormath::addVector    $help_07                {1 0}]
            #set help_08  [ vectormath::addVector    $Position(BottomBracket_Ground) {200 0}]
                #
            set Position(Steerer_Ground)    [ vectormath::intersectPoint    $Position(Steerer_Stem)     $Position(Steerer_Fork)     $help_07    $help_08 ]
                #
            set Direction(HeadTube)         [ vectormath::unifyVector   $Position(Steerer_Fork) $Position(Steerer_Stem) ]
                #
            set Angle(HeadTubeTopTube)     [ expr $HeadTube_Angle + $TopTube_Angle ]
                #
            return
                #
    }
        #
        #
    proc bikeGeometry::geometry::set__Result_BottomBracket_Height   {value} {
                #
                # Length/BottomBracket/Height
                # Geometry(BottomBracket_Height)
                #
            variable BottomBracket_Depth
                #
            variable Length
                #
            puts "    <1> set__Result_BottomBracket_Height   ... check $Length(BottomBracket_Height)  ->  $value"
                #
            set delta                   [expr $value - $Length(BottomBracket_Height)]
                #
            set BottomBracket_Depth     [expr $BottomBracket_Depth - $delta ]
                #
            _updateNamespace
                #
            puts "    <2> set__Result_BottomBracket_Height   ... check $Length(BottomBracket_Height)  ->  $value"
                #
            return $Length(BottomBracket_Height)
                #
    }
        #
    proc bikeGeometry::geometry::set__Result_HeadTubeTopTube_Angle {value} {
                #
                # Angle/HeadTube/TopTube
                # Geometry(Angle_HeadTubeTopTube)
                #
            variable TopTube_Angle
            variable HeadTube_Angle
                #
            variable Angle
                #
            puts "    <1> set__Result_HeadTubeTopTube_Angle   ... check $Angle(HeadTubeTopTube)  ->  $value"
                #
            set TopTube_Angle   [expr $value - $HeadTube_Angle]
                #
            _updateNamespace
                #
            puts "    <2> set__Result_HeadTubeTopTube_Angle   ... check $Angle(HeadTubeTopTube)  ->  $value"
                #
            return $Angle(HeadTubeTopTube)
                #
    }        
        #     
    proc bikeGeometry::geometry::set__Result_SeatTube_Angle     {value} {
                #
                # Angle/SeatTube/Direction
                # Geometry(SeatTube_Angle)
                #
            variable Saddle_Distance    
            variable Saddle_Height    
            variable Saddle_MountHeight    
            variable SeatPost_PivotOffset    
            variable SeatPost_Setback 
                #
            variable Angle
                #
            puts "    <1> set__Result_SeatTube_Angle   ... check $Angle(SeatTube)  ->  $value"
                #
            set length_Setback      [expr $SeatPost_Setback * sin([vectormath::rad $value])]
            set height_Setback      [expr $SeatPost_Setback * cos([vectormath::rad $value])]
                #
            set height_SeatTube     [expr $Saddle_Height - $Saddle_MountHeight - $SeatPost_PivotOffset + $height_Setback]
            set length_SeatTube     [expr $height_SeatTube / tan([vectormath::rad  $value])]
                #
            set Saddle_Distance     [expr $length_Setback + $length_SeatTube]
                #
                # puts " ... \$height_SeatTube  ... $height_SeatTube"    
                # puts " ... \$length_SeatTube  ... $length_SeatTube"    
                # puts " ... \$Saddle_Distance  ... $Saddle_Distance"   
                #
            _updateNamespace
                #
                # puts " ... \$Saddle_Distance  ... $Saddle_Distance"   
                #
            puts "    <2> set__Result_SeatTube_Angle   ... check $Angle(SeatTube)  ->  $value / $Angle(SeatTube)"
                #
            return $Angle(SeatTube)
                # return [format "%.8f" $Angle(SeatTube)]
                #
    }
        #
        #
    proc bikeGeometry::geometry::create_SummarySize {} {
            variable SeatPost
            variable SeatTube
            variable FrontWheel
            variable RearWheel
            variable BottomBracket
                #
            variable Geometry
            variable Result
            variable BoundingBox
                #
                # --- set summary Length of Frame, Saddle and Stem
            set summaryLength [format "%.6f" [ expr $Geometry(RearWheel_x) + $Geometry(FrontWheel_x)]]
            set summaryHeight [format "%.6f" [ expr $Geometry(BottomBracket_Depth) + 40 + [lindex $SeatPost(SeatTube) 1] ]]
                #
            set BoundingBox(SummarySize)       [list $summaryLength   $summaryHeight]
                #
            return    
                #
    }
    
    
        #
        #
        # --- set basePoints Attributes
        #
    proc bikeGeometry::geometry::create_Reference {} {
            variable FrontWheel
            variable BottomBracket
            variable Reference
                #
            # variable Result
                #
            set BB_Height    [expr  0.5 * $RearWheel(RimDiameter) +  $RearWheel(TyreHeight) -  $Geometry(BottomBracket_Depth)]
                #
            set SN_Distance  [expr -1.0 * $Reference(SaddleNose_Distance)]
            set SN_Height    [expr $Reference(SaddleNose_Height)  - $BB_Height]
                #
            set HB_Distance  [expr $Reference(HandleBar_Distance) + $SN_Distance]
            set HB_Height    [expr $Reference(HandleBar_Height)   - $BB_Height]
                #
            set Reference(HandleBar)    [list $HB_Distance $HB_Height]
            # set Result(Position/Reference_HB)          $Reference(HandleBar)
                #
            set Reference(SaddleNose)   [list $SN_Distance $SN_Height]
            # set Result(Position/Reference_SN)          $Reference(SaddleNose)
                #
    }    


        #
        # --- set RearDropout ------------
    proc bikeGeometry::geometry::create_RearDropout {} {
                #
        variable Geometry
        variable RearDropout
            #
        set RearDropout(Position)   [ list [expr -1.0 * $Geometry(RearWheel_x)] $Geometry(BottomBracket_Depth) ]
            #
        return
            #
    }


        #
        # --- set FrontWheel -----------------------
    proc bikeGeometry::geometry::create_FrontWheel {} {
            #
        variable Geometry
        variable FrontWheel
        variable RearWheel
            #
        set FrontWheel(RimDiameter)     $Geometry(FrontRim_Diameter)
        set FrontWheel(TyreHeight)      $Geometry(FrontTyre_Height)
            #
        set FrontWheel(Radius)          $Geometry(FrontWheel_Radius)
        set FrontWheel(Diameter)        [expr 2.0 * $FrontWheel(Radius)]
            #
        return    
            #
    }


        #
        # --- set RearWheel ------------------------
    proc bikeGeometry::geometry::create_RearWheel {} {
            #
        variable Geometry
        variable RearWheel
        variable RearDropout
            #
        set RearWheel(RimDiameter)  $Geometry(RearRim_Diameter)
        set RearWheel(TyreHeight)   $Geometry(RearTyre_Height)
        set RearWheel(Radius)       $Geometry(RearWheel_Radius)
        set RearWheel(Diameter)     [expr 2.0 * $RearWheel(Radius)]
            #   
        set RearWheel(Position)     $RearDropout(Position)
            #
        return    
            #
    }


        #
        # --- fill Result Values ------------------
    proc bikeGeometry::geometry::fill_resultValues {} {
                #
            variable Geometry
            variable Reference
                #
            variable BottomBracket
            variable Fork
            variable HeadTube
            variable TopTube
            variable Steerer
            variable RearWheel
            variable FrontWheel
            variable Saddle
            variable SeatTube
            variable SeatPost
            variable HandleBar
            variable SeatStay
            variable DownTube
                #
            variable Result
                #

                
                #
                # template of <Result>  .. </Result> is defined in
                # 
                #   /etc/initTemplate.xml
                # 

                # puts ""
                # puts "       ... fill_resultValues"
                # puts "      -------------------------------"
                # puts ""
                

                #
                # --- BottomBracket
                #
            # set position    $Geometry(BottomBracket_Height)
                #
                # --- BottomBracket/Height
                #
            set Geometry(BottomBracket_Height) [ format "%.3f" [lindex $Geometry(BottomBracket_Height) 0] ]
                #
                # --- HeadTube ----------------------------------------
                #
            set position    $HeadTube(Stem)
                #
                # --- HeadTube/ReachLength
                #
            set value       [lindex $position 0] 
            set Geometry(ReachLengthResult) [ format "%.3f" $value ]
                # 
                # --- HeadTube/StackHeight
                #
            set value       [lindex $position 1]
            set Geometry(StackHeightResult) [ format "%.3f" $value ]
                #
                # --- SeatTube ----------------------------------------
                #
                # set position    [ bikeGeometry::get_Object_expired     SeatTube/End    position    {0 0} ]
                # puts "  -> $position"
            set position    $SeatTube(TopTube)
                # puts "  -> $position"
                #
                # --- SeatTube/Angle ------------------------------
                #
            set angle [ vectormath::angle $SeatPost(SeatTube) $SeatTube(BottomBracket) [list -200 [lindex $SeatTube(BottomBracket) 1]] ]
            set Geometry(SeatTube_Angle) [ format "%.3f" $angle ]
                #
                # --- SeatTube/TubeLength -------------------------
                #
            set value       [ format "%.3f" [ expr hypot([lindex $position 0],[lindex $position 1]) ] ]
            set Result(Length/SeatTube/TubeLength)  $value
                #
                # --- SeatTube/TubeHeight -------------------------
                #
            set value        [ format "%.3f" [lindex $position 1] ]
            set Result(Length/SeatTube/TubeHeight)  $value
                #
                # --- VirtualTopTube ----------------------------------
                #
            set SeatTube(VirtualTopTube)    [ vectormath::intersectPoint [list -500 [lindex $HeadTube(Stem) 1]]  $HeadTube(Stem)  $SeatTube(BottomBracket) $SeatPost(SeatTube) ]
                #
                # --- TopTube/VirtualLength -----------------------
                #
            set value       [expr [lindex $HeadTube(Stem) 0] - [lindex $SeatTube(VirtualTopTube) 0] ]
            set Geometry(TopTubeVirtual)       [ format "%.3f" $value ]
                #
                # --- SeatTube/VirtualLength ----------------------
                #
            set value       [vectormath::length $SeatTube(VirtualTopTube) {0 0}]
            set Geometry(SeatTubeVirtual) [ format "%.3f" $value]
                #
                # --- Saddle ------------------------------------------
                #
            set position_Saddle      $Saddle(Position)   
            set position_SaddleNose  $Saddle(Nose)            
            set position_SeatTube    $Geometry(SeatTubeSaddle)
            set position_HandleBar   $HandleBar(Position)
            set position_BB          {0 0}
                #
                # --- Saddle/Offset_BB --------------------------------
                #
            set value        [ format "%.3f" [expr -1 * [lindex $position_Saddle 0]] ]
                # puts "                  ... $value"
            set Result(Length/Saddle/Offset_BB) $value
                #
                # --- Saddle/Offset_BB_ST -----------------------------
                #
            set value       [ format "%.3f" [expr -1 * [lindex $position_SeatTube 0]] ]
            set Geometry(Saddle_Offset_BB_ST)  $value
                # 
                # --- Saddle/Offset_HB --------------------------------
                #
            set value       [expr [lindex $position_Saddle 1] - [lindex $position_HandleBar 1]]
            set Geometry(Saddle_HB_y) [ format "%.3f" $value ]
                #
                # --- Personal/SeatTube_BB ------------------------
                #               
            set value       [ vectormath::length $position_SeatTube $position_BB]
            set Geometry(Saddle_BB) [ format "%.3f" $value ]
                #
                # --- Personal/Offset_BB_Nose -------------------------
                #
            set value       [expr -1.0 * [lindex $position_SaddleNose 0]]
            set Geometry(SaddleNose_BB_x) [ format "%.3f" $value ]
            set value       [ expr  [lindex $position_HandleBar 0] + [expr -1.0 * [lindex $position_SaddleNose 0]] ]
            set Geometry(SaddleNose_HB) [ format "%.3f" $value ]
                #
                # --- WheelPosition/front/diagonal --------------------
                #
            #set position    $FrontWheel(Position)
            #set value       [expr { hypot( [lindex $position 0], [lindex $position 1] ) }]
            #set Geometry(FrontWheel_xy)       [ format "%.3f" $value ]
            set Geometry(FrontWheel_xy)    [ format "%.3f" $Geometry(FrontWheel_xy) ]
                #
                # --- WheelPosition/front/horizontal ------------------
                #
            #set position    $FrontWheel(Position)
            #set value       [lindex $position 0]
            #set Geometry(FrontWheel_x)       [ format "%.3f" $value ]
            set Geometry(FrontWheel_x)      [ format "%.3f" $Geometry(FrontWheel_x) ]
                #
                # --- WheelPosition/rear/horizontal -------------------
                #
            #set position    $RearWheel(Position)
            #set value       [expr -1 * [lindex $position 0]]
            #set Geometry(RearWheel_x)       [ format "%.3f" $value ]
            set Geometry(RearWheel_x)       [ format "%.3f" $Geometry(RearWheel_x) ]
                #
                # --- RearWheel/Radius --------------------------------
                #
            #set Geometry(RearWheel_Radius)  [ expr 0.5 * $Geometry(RearRim_Diameter) + $Geometry(RearTyre_Height)]
            #set RearWheel(Diameter)         [ expr 2.0 * $Geometry(RearWheel_Radius)]
            set RearWheel(Diameter)         [ format "%.3f" $RearWheel(Diameter) ]
                #
                # --- RearWheel/TyreShoulder --------------------------------
                #
            set RearWheel(TyreShoulder)     [ expr $Geometry(RearWheel_Radius) - $RearWheel(TyreWidthRadius) ]
                #
                # --- FrontWheel/Radius -------------------------------
                #
            #set Geometry(FrontWheel_Radius) [ expr 0.5 * $Geometry(FrontRim_Diameter) + $Geometry(FrontTyre_Height) ]
            #set FrontWheel(Diameter)        [ expr 2.0 * $Geometry(FrontWheel_Radius)]
                #
            set BB_Position                 {0 0}
                #
            set ChainSt_SeatSt_IS           [ bikeGeometry::get_Object_expired     ChainStay/SeatStay_IS   position ]
                #  
            set Geometry(Angle_HeadTubeTopTube)           [format "%.4f" [ get_resultAngle $TopTube(HeadTube)     $Steerer(Stem)      $TopTube(SeatTube)  ]]  ; # Result(Angle/HeadTube/TopTube)
            set Result(Angle_HeadTubeDownTube)            [format "%.4f" [ get_resultAngle $DownTube(HeadTube)    $BB_Position        $Steerer(Fork)      ]]  ;# Result(Angle/HeadTube/DownTube)      
            set Result(Angle_SeatTubeTopTube)             [format "%.4f" [ get_resultAngle $TopTube(SeatTube)     $BB_Position        $TopTube(HeadTube)  ]]  ;# Result(Angle/SeatTube/TopTube)       
            set Result(Angle_SeatTubeSeatStay)            [format "%.4f" [ get_resultAngle $SeatStay(SeatTube)    $ChainSt_SeatSt_IS  $BB_Position        ]]  ;# Result(Angle/SeatTube/SeatStay)      
            set Result(Angle_BottomBracketDownTube)       [format "%.4f" [ get_resultAngle $BB_Position           $DownTube(HeadTube) $TopTube(SeatTube)  ]]  ;# Result(Angle/BottomBracket/DownTube) 
            set Result(Angle_BottomBracketChainStay)      [format "%.4f" [ get_resultAngle $BB_Position           $TopTube(SeatTube)  $ChainSt_SeatSt_IS  ]]  ;# Result(Angle/BottomBracket/ChainStay)
            set Result(Angle_SeatStayChainStay)           [format "%.4f" [ get_resultAngle $ChainSt_SeatSt_IS     $BB_Position        $SeatStay(SeatTube) ]]  ;# Result(Angle/SeatStay/ChainStay)                 
                #
                # --- Reference Position ------------------------------
                #             
            set BB_Height    [expr  0.5 * $Geometry(RearRim_Diameter) +  $Geometry(RearTyre_Height) -  $Geometry(BottomBracket_Depth)]
            set SN_Distance  [expr -1.0 * $Reference(SaddleNose_Distance)]
            set SN_Height    [expr $Reference(SaddleNose_Height)  - $BB_Height]
            set HB_Distance  [expr $Reference(HandleBar_Distance) + $SN_Distance]
            set HB_Height    [expr $Reference(HandleBar_Height)   - $BB_Height]
                #
            set Reference(HandleBar)        [list $HB_Distance $HB_Height]
            set Reference(SaddleNose)       [list $SN_Distance $SN_Height]
                #
            set Reference(HandleBar_BB)     [vectormath::length $Reference(HandleBar) {0 0}]                   ;#Result(Length/Reference/HandleBar_BB) 
            set Reference(HandleBar_FW)     [vectormath::length $Reference(HandleBar) $Fork(DropoutPosition)]   ;#Result(Length/Reference/HandleBar_FW) 
            set Reference(SaddleNose_BB)    [vectormath::length $Reference(SaddleNose) {0 0}]                  ;#Result(Length/Reference/SaddleNose_BB)
            set Reference(SaddleNose_HB)    [vectormath::length $Reference(SaddleNose) $Reference(HandleBar)]  ;#Result(Length/Reference/SaddleNose_HB)            
            set Reference(SaddleNose_HB_y)  [expr $SN_Height - $HB_Height]                                     ;#Result(Length/Reference/Heigth_SN_HB)             
                #
            return
                #
    }

