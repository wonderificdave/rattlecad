 ##+##########################################################################
 #
 # package: rattleCAD    ->    bikeGeometry.tcl
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
 #    namespace:  rattleCAD::frame_geometry_custom
 # ---------------------------------------------------------------------------
 #
 #

 package provide bikeGeometry 0.10

 namespace eval bikeGeometry {
        # package require tdom

            #-------------------------------------------------------------------------
                #  current Project Values
                # variable BaseCenter        ; array set BaseCenter        {}
            variable Project        ; array set Project         {}

            variable RearWheel      ; array set RearWheel       {}
            variable FrontWheel     ; array set FrontWheel      {}
            variable BottomBracket  ; array set BottomBracket   {}
            variable Saddle         ; array set Saddle          {}
            variable SeatPost       ; array set SeatPost        {}
            variable HandleBar      ; array set HandleBar       {}
            variable LegClearance   ; array set LegClearance    {}

            variable HeadTube       ; array set HeadTube        {}
            variable SeatTube       ; array set SeatTube        {}
            variable DownTube       ; array set DownTube        {}
            variable TopTube        ; array set TopTube         {}
            variable ChainStay      ; array set ChainStay       {}
            variable SeatStay       ; array set SeatStay        {}
            variable Steerer        ; array set Steerer         {}
            variable ForkBlade      ; array set ForkBlade       {}

            variable Fork           ; array set Fork            {}
            variable Stem           ; array set Stem            {}
            variable HeadSet        ; array set HeadSet         {}
            variable RearDrop       ; array set RearDrop        {}

            variable BottleCage     ; array set BottleCage      {}
            variable FrameJig       ; array set FrameJig        {}
            variable TubeMiter      ; array set TubeMiter       {}
            
            variable myFork         ; array set myFork          {}

            variable DEBUG_Geometry ; array set DEBUG_Geometry    {}



            #-------------------------------------------------------------------------
                #  update loop and delay; store last value
            variable _updateValue   ; array set _updateValue    {}

            #-------------------------------------------------------------------------
                #  store createEdit-widgets position
            variable _drag

            #-------------------------------------------------------------------------
                #  dataprovider of create_selectbox
            variable _listBoxValues
        

    #-------------------------------------------------------------------------
        #  base: fill current Project Values and namespace frameCoords::
    proc set_base_Parameters {{domProject {}}} {
            # variable Reference
            variable Project

            variable BottomBracket
            variable RearWheel
            variable FrontWheel
            variable HandleBar
            variable Saddle
            variable SeatPost
            variable LegClearance

            variable HeadTube
            variable SeatTube
            variable DownTube
            variable TopTube
            variable ChainStay
            variable SeatStay
            variable Steerer
            variable ForkBlade

            variable Fork
            variable HeadSet
            variable Stem
            variable RearDrop

            variable RearBrake
            variable FrontBrake
            variable FrontDerailleur

            variable BottleCage
            variable FrameJig
            variable TubeMiter

            variable DEBUG_Geometry


                #
                # --- convert domProject to runtime variables
            if {$domProject != {}} {
                    project::dom_2_runTime $domProject
                        # parray project::Project
                        # parray project::Result
                        # exit
            }

                #
                # --- increase global update timestamp
            set ::APPL_Config(canvasCAD_Update)    [ clock milliseconds ]


                #
                # --- set Project attributes
            set Project(Project)        $project::Project(Name)
            set Project(modified)       $project::Project(modified)

                #
                # --- get BottomBracket (1)
            set BottomBracket(depth)    $project::Custom(BottomBracket/Depth)
            set BottomBracket(outside)  $project::Lugs(BottomBracket/Diameter/outside)
            set BottomBracket(inside)   $project::Lugs(BottomBracket/Diameter/inside)
            set BottomBracket(width)    $project::Lugs(BottomBracket/Width)
                # check-Value-procedure
                if {[expr $BottomBracket(outside) -2.0] < $BottomBracket(inside)} {
                        set project::Lugs(BottomBracket/Diameter/inside) [expr $BottomBracket(outside) -2.0]
                        set BottomBracket(inside)   $project::Lugs(BottomBracket/Diameter/inside)
                }

                #
                # --- get RearWheel
            set RearWheel(RimDiameter)  $project::Component(Wheel/Rear/RimDiameter)
            set RearWheel(RimHeight)    $project::Component(Wheel/Rear/RimHeight)
            set RearWheel(TyreHeight)   $project::Component(Wheel/Rear/TyreHeight)
            set RearWheel(Radius)       [ expr 0.5*$RearWheel(RimDiameter) + $RearWheel(TyreHeight) ]
            set RearWheel(DistanceBB)   $project::Custom(WheelPosition/Rear)
            #set RearWheel(Distance_X)  [ expr sqrt(pow($RearWheel(DistanceBB),2)  - pow($project::Custom(BottomBracket/Depth),2)) ]
            set RearWheel(Distance_X)   [ expr sqrt(pow($RearWheel(DistanceBB),2)  - pow($project::Custom(BottomBracket/Depth),2)) ]
            set RearWheel(Position)     [ list [expr -1.0 * $RearWheel(Distance_X)] $project::Custom(BottomBracket/Depth) ]
                # set RearWheel(Distance_X) 450

                #
                # --- get BottomBracket (2)
            set BottomBracket(height)    [ expr $RearWheel(Radius) - $project::Custom(BottomBracket/Depth) ]
            set BottomBracket(Ground)    [ list 0    [expr - $RearWheel(Radius) + $project::Custom(BottomBracket/Depth) ] ]

                #
                # --- get FrontWheel
            set FrontWheel(RimDiameter) $project::Component(Wheel/Front/RimDiameter)
            set FrontWheel(RimHeight)   $project::Component(Wheel/Front/RimHeight)
            set FrontWheel(TyreHeight)  $project::Component(Wheel/Front/TyreHeight)
            set FrontWheel(Radius)      [ expr 0.5*$FrontWheel(RimDiameter) + $FrontWheel(TyreHeight) ]
            set FrontWheel(Distance_Y)  [ expr $project::Custom(BottomBracket/Depth) - $RearWheel(Radius) + $FrontWheel(Radius) ]

                #
                # --- get HandleBarMount - Position
            set HandleBar(Distance)     $project::Personal(HandleBar_Distance)
            set HandleBar(Height)       $project::Personal(HandleBar_Height)
            set HandleBar(Position)     [ list $HandleBar(Distance) $HandleBar(Height) ]


                #
                # --- get Fork -----------------------------
            set Fork(Height)                $project::Component(Fork/Height)
            set Fork(Rake)                  $project::Component(Fork/Rake)
#            set Fork(Rendering)             $project::Rendering(ForkBlade)
            set Fork(BladeWith)             $project::Component(Fork/Blade/Width)
            set Fork(BladeDiameterDO)       $project::Component(Fork/Blade/DiameterDO)
            set Fork(BladeTaperLength)      $project::Component(Fork/Blade/TaperLength)
            set Fork(BladeBendRadius)       $project::Component(Fork/Blade/BendRadius)
            set Fork(BladeEndLength)        $project::Component(Fork/Blade/EndLength)
            # set Fork(BladeOffset)           $project::Component(Fork/Blade/Offset)
            set Fork(BladeOffsetCrown)      $project::Component(Fork/Crown/Blade/Offset)
            set Fork(BladeOffsetCrownPerp)  $project::Component(Fork/Crown/Blade/OffsetPerp)
            set Fork(BladeOffsetDO)         $project::Component(Fork/DropOut/Offset)
            set Fork(BladeOffsetDOPerp)     $project::Component(Fork/DropOut/OffsetPerp)
            set Fork(BrakeAngle)            $project::Component(Fork/Crown/Brake/Angle)
            set Fork(BrakeOffset)           $project::Component(Fork/Crown/Brake/Offset)

                #
                # --- get Stem -----------------------------
            set Stem(Angle)                 $project::Component(Stem/Angle)
            set Stem(Length)                $project::Component(Stem/Length)

                #
                # --- get HeadTube -------------------------
            set HeadTube(ForkRake)          $Fork(Rake)
            set HeadTube(ForkHeight)        $Fork(Height)
            set HeadTube(Diameter)          $project::FrameTubes(HeadTube/Diameter)
            set HeadTube(Length)            $project::FrameTubes(HeadTube/Length)
            set HeadTube(Angle)             $project::Custom(HeadTube/Angle)

                #
                # --- get SeatTube -------------------------
            set SeatTube(DiameterBB)        $project::FrameTubes(SeatTube/DiameterBB)
            set SeatTube(DiameterTT)        $project::FrameTubes(SeatTube/DiameterTT)
            set SeatTube(TaperLength)       $project::FrameTubes(SeatTube/TaperLength)
            set SeatTube(Extension)         $project::Custom(SeatTube/Extension)
            set SeatTube(OffsetBB)          $project::Custom(SeatTube/OffsetBB)

                #
                # --- get DownTube -------------------------
            set DownTube(DiameterBB)        $project::FrameTubes(DownTube/DiameterBB)
            set DownTube(DiameterHT)        $project::FrameTubes(DownTube/DiameterHT)
            set DownTube(TaperLength)       $project::FrameTubes(DownTube/TaperLength)
            set DownTube(OffsetHT)          $project::Custom(DownTube/OffsetHT)
            set DownTube(OffsetBB)          $project::Custom(DownTube/OffsetBB)

                #
                # --- get TopTube --------------------------
            set TopTube(DiameterHT)         $project::FrameTubes(TopTube/DiameterHT)
            set TopTube(DiameterST)         $project::FrameTubes(TopTube/DiameterST)
            set TopTube(TaperLength)        $project::FrameTubes(TopTube/TaperLength)
            set TopTube(PivotPosition)      $project::Custom(TopTube/PivotPosition)
            set TopTube(OffsetHT)           $project::Custom(TopTube/OffsetHT)
            set TopTube(Angle)              $project::Custom(TopTube/Angle)

                #
                # --- get ChainStay ------------------------
            set ChainStay(HeigthBB)         $project::FrameTubes(ChainStay/HeightBB)
            set ChainStay(DiameterSS)       $project::FrameTubes(ChainStay/DiameterSS)
            set ChainStay(Height)           $project::FrameTubes(ChainStay/Height)
            set ChainStay(TaperLength)      $project::FrameTubes(ChainStay/TaperLength)

                #
                # --- get SeatStay -------------------------
            set SeatStay(DiameterST)        $project::FrameTubes(SeatStay/DiameterST)
            set SeatStay(DiameterCS)        $project::FrameTubes(SeatStay/DiameterCS)
            set SeatStay(TaperLength)       $project::FrameTubes(SeatStay/TaperLength)
            set SeatStay(OffsetTT)          $project::Custom(SeatStay/OffsetTT)

                #
                # --- get RearDropOut ----------------------
            set RearDrop(Direction)         $project::Lugs(RearDropOut/Direction)
            set RearDrop(RotationOffset)    $project::Lugs(RearDropOut/RotationOffset)
            set RearDrop(OffsetCS)          $project::Lugs(RearDropOut/ChainStay/Offset)
            set RearDrop(OffsetCSPerp)      $project::Lugs(RearDropOut/ChainStay/OffsetPerp)
            set RearDrop(OffsetSS)          $project::Lugs(RearDropOut/SeatStay/Offset)
            set RearDrop(OffsetSSPerp)      $project::Lugs(RearDropOut/SeatStay/OffsetPerp)
            set RearDrop(Derailleur_x)      $project::Lugs(RearDropOut/Derailleur/x)
            set RearDrop(Derailleur_y)      $project::Lugs(RearDropOut/Derailleur/y)

                #
                # --- get Saddle ---------------------------
            set Saddle(Distance)        $project::Personal(Saddle_Distance)
            set Saddle(Height)          $project::Personal(Saddle_Height)
            set Saddle(Saddle_Height)   $project::Component(Saddle/Height)
                # check-Value-procedure
                if {$Saddle(Saddle_Height) < 0} {
                       set project::Component(Saddle/Height) 0
                       set Saddle(Saddle_Height) 0
                }
            set Saddle(Position)        [ list [expr -1.0*$Saddle(Distance)]  $Saddle(Height) ]
            set Saddle(Nose)            [ vectormath::addVector  $Saddle(Position) [list $project::Component(Saddle/LengthNose) -15] ]

                #
                # --- get SaddleMount - Position
            set SeatPost(Diameter)      $project::Component(SeatPost/Diameter)
            set SeatPost(Setback)       $project::Component(SeatPost/Setback)
            set SeatPost(Height)        [ expr $Saddle(Height) - $Saddle(Saddle_Height) ]
            set SeatPost(Saddle)        [ list [expr -1.0 * $Saddle(Distance)] $SeatPost(Height) ]
                set hlp_01              [ vectormath:::cathetusPoint {0 0} $SeatPost(Saddle) [expr $SeatPost(Setback) - $SeatTube(OffsetBB)] {opposite}]
                set vct_01              [ vectormath:::parallel {0 0} $hlp_01 $SeatTube(OffsetBB)]
            set SeatPost(SeatTube)      [ lindex $vct_01 1]
            set SeatTube(BottomBracket) [ lindex $vct_01 0]
            set SeatTube(Angle)         [ vectormath::angle $SeatPost(SeatTube) $SeatTube(BottomBracket) [list -100 [lindex $SeatTube(BottomBracket) 1]]]
            set SeatTube(Direction)     [ vectormath::unifyVector $SeatTube(BottomBracket) $SeatPost(SeatTube) ]

                #
                # --- get LegClearance - Position
            set LegClearance(Length)        $project::Personal(InnerLeg_Length)
            set LegClearance(Position)      [ list $TopTube(PivotPosition)  [expr $LegClearance(Length) - ($RearWheel(Radius) - $project::Custom(BottomBracket/Depth)) ] ]

                #
                # --- get Saddle ---------------------------
            set Saddle(Proposal)            [ vectormath::rotateLine {0 0}  [ expr 0.88*$LegClearance(Length) ]  [ expr 180 - $SeatTube(Angle) ] ]

                #
                # --- get HeadSet --------------------------
            set HeadSet(Diameter)           $project::Component(HeadSet/Diameter)
            set HeadSet(Height_Top)         $project::Component(HeadSet/Height/Top)
            set HeadSet(Height_Bottom)      $project::Component(HeadSet/Height/Bottom)
            set HeadSet(ShimDiameter)       36

                #
                # --- get Front/Rear Brake PadLever --------------
            set RearBrake(LeverLength)      $project::Component(Brake/Rear/LeverLength)
            set RearBrake(Offset)           $project::Component(Brake/Rear/Offset)
            set FrontBrake(LeverLength)     $project::Component(Brake/Front/LeverLength)
            set FrontBrake(Offset)          $project::Component(Brake/Front/Offset)

                #
                # --- get BottleCage Offset ----------------------
            set BottleCage(SeatTube)        $project::Component(BottleCage/SeatTube/OffsetBB)
            set BottleCage(DownTube)        $project::Component(BottleCage/DownTube/OffsetBB)
            set BottleCage(DownTube_Lower)  $project::Component(BottleCage/DownTube_Lower/OffsetBB)

                #
                # --- get FrontDerailleur  ----------------------
            set FrontDerailleur(Distance)   $project::Component(Derailleur/Front/Distance)
            set FrontDerailleur(Offset)     $project::Component(Derailleur/Front/Offset)


                #
                # --- set DEBUG_Geometry  ----------------------
            set DEBUG_Geometry(Base)        {0 0}


                #
                #
                # --- set basePoints Attributes
                #
            project::setValue Result(Position/RearWheel)            position    $RearWheel(Position)
            project::setValue Result(Position/HandleBar)            position    $HandleBar(Position)
            project::setValue Result(Position/SeatPostSaddle)       position    $SeatPost(Saddle)
            project::setValue Result(Position/SeatPostSeatTube)     position    $SeatPost(SeatTube)
            project::setValue Result(Position/Saddle)               position    $Saddle(Position)
            project::setValue Result(Position/SaddleProposal)       position    $Saddle(Proposal)
            project::setValue Result(Position/SaddleNose)           position    $Saddle(Nose)
            project::setValue Result(Position/LegClearance)         position    $TopTube(PivotPosition)     [expr $LegClearance(Length) - ($RearWheel(Radius) - $project::Custom(BottomBracket/Depth)) ]
            project::setValue Result(Position/BottomBracketGround)  position    0     [expr - $RearWheel(Radius) + $project::Custom(BottomBracket/Depth) ] ;# Point on the Ground perp. to BB
            project::setValue Result(Position/SeatTubeSaddle)       position    [ vectormath::intersectPoint [list 0 [lindex $Saddle(Position) 1] ] [list 100 [lindex $Saddle(Position) 1]] $SeatTube(BottomBracket) $SeatPost(SeatTube) ]

            project::setValue Result(Lugs/Dropout/Rear/Position)    position     [expr -1*$RearWheel(Distance_X)]    $project::Custom(BottomBracket/Depth)
                # project::setValue Result(Lugs/Dropout/Rear/Derailleur)  position     [ vectormath::addVector  $RearWheel(Position)  [list $RearDrop(Derailleur_x) $RearDrop(Derailleur_y)] ]

                # project::setValue /root/Result/Lugs/Dropout/Front/Position    position     $FrontWheel(Distance_X)    [expr $project::Custom(BottomBracket/Depth) + ($FrontWheel(Radius) - $RearWheel(Radius))]
                # project::setValue /root/Result/Position/RearWheel         position    $RearWheel(Position)
                # project::setValue /root/Result/Position/FrontWheel    position    $FrontWheel(Position)



                #
                #
                # --- set basePoints Attributes
                #
            get_basePoints
            project::setValue Result(Position/FrontWheel)            position    $FrontWheel(Position)
            project::setValue Result(Lugs/Dropout/Front/Position)    position     $FrontWheel(Distance_X)    [expr $project::Custom(BottomBracket/Depth) + ($FrontWheel(Radius) - $RearWheel(Radius))]


            #
            # --- compute tubing geometry
            #

                #
            get_ChainStay

                #
            get_HeadTube

                #
            get_TopTube_SeatTube

                #
            get_DownTube_SeatTube

                #
            get_SeatStay

                #
            get_Fork

                #
            get_Steerer

                #
            get_SeatPost

                #
            get_HeadSet

                #
            get_Stem

                #
            fill_resultValues

                #
            get_DerailleurMountFront

                #
            get_BrakePositionRear

                #
            get_BrakePositionFront

                #
            get_BottleCageMount

                #
            get_FrameJig

                #
            get_TubeMiter
    }


    #-------------------------------------------------------------------------
        #  return all geometry-values to create specified tube in absolute position
    proc get_Object {object index {centerPoint {0 0}} } {
                # puts "   ... $object"
                # {lindex {-1}}

                # -- for debug purpose
            if {$object == {DEBUG_Geometry}} {
                    set returnValue    {}
                    set pointValue $index
                    foreach xy $pointValue {
                        foreach {x y} [split $xy ,] break
                        lappend returnValue $x $y  ; # puts "    ... $returnValue"
                    }
                    return [ vectormath::addVectorPointList  $centerPoint $returnValue ]
            }


                # -- default purpose
            switch -exact $index {

                polygon    {    set returnValue    {}
                            switch -exact $object {
                                Stem             -
                                HeadSet/Top     -
                                HeadSet/Bottom     -
                                SeatPost     {
                                                set branch "Components/$object/Polygon"
                                            }

                                TubeMiter/TopTube_Head -
                                TubeMiter/TopTube_Seat -
                                TubeMiter/DownTube_Head -
                                TubeMiter/SeatStay_01    -
                                TubeMiter/SeatStay_02    -
                                TubeMiter/Reference {
                                                set branch "$object/Polygon"    ; # puts " ... $branch"
                                            }

                                default     {
                                                set branch "Tubes/$object/Polygon"
                                            }
                            }
                                # puts "    ... $branch"
                            set svgList    [ project::getValue Result($branch)    polygon ]
                            foreach xy $svgList {
                                foreach {x y} [split $xy ,] break
                                lappend returnValue $x $y
                            }
                            return [ vectormath::addVectorPointList  $centerPoint  $returnValue]
                        }

                position {
                            set returnValue    {}
                            switch -glob $object {
                                BottomBracket -
                                FrontWheel -
                                RearWheel -
                                Saddle -
                                SeatPostSaddle -
                                SeatPostSeatTube -
                                SaddleProposal -
                                HandleBar -
                                LegClearance -
                                BottomBracketGround -
                                SteererGround -
                                SeatTubeGround -
                                SeatTubeVirtualTopTube -
                                SeatTubeSaddle -
                                BrakeFront -
                                BrakeRear -
                                DerailleurMountFront -
                                SummarySize {
                                            set branch "Position/$object"
                                        }
                                
                                Lugs/Dropout/Rear/Derailleur {
                                            set branch "$object"
                                        }

                                Lugs/* {
                                            set branch "$object/Position"    ; # puts " ... $branch"
                                        }


                                default {
                                            # puts "   ... \$object $object"
                                            set branch "Tubes/$object"
                                        }
                            }

                            set pointValue    [ project::getValue Result($branch)    position ]    ; # puts "    ... $pointValue"

                            foreach xy $pointValue {
                                foreach {x y} [split $xy ,] break
                                lappend returnValue $x $y    ; # puts "    ... $returnValue"
                            }
                            return [ vectormath::addVectorPointList  $centerPoint  $returnValue]
                        }

                direction {
                            set returnValue    {}
                                # puts " ... $object"
                            switch -glob $object {
                                    Lugs/* {
                                            set branch "$object/Direction/polar"    ; # puts " ... $branch"
                                        }

                                    default {
                                            set branch "Tubes/$object/Direction/polar"
                                        }
                            }

                            set directionValue    [ project::getValue Result($branch)    direction ]    ; # puts "    ... $directionValue"
                            foreach xy $directionValue {
                                foreach {x y} [split $xy ,] break
                                lappend returnValue $x $y   ; # puts "    ... $returnValue"
                            }
                            return $returnValue
                        }

                default    {             puts "   ... object_values $object $index"
                            #eval set returnValue $[format "frameCoords::%s(%s)" $object $index]
                            #return [ coords_addVector  $returnValue  $centerPoint]
                        }
            }
    }


    #-------------------------------------------------------------------------
        #  get Value
    proc get_Value {xpath type args} {
        return [project::getValue $xpath $type $args]
    }
    #-------------------------------------------------------------------------
        #  set Value
    proc setValue {xpath value {mode {update}}} {
        return [bikeGeometry::set_projectValue $xpath $value $mode]
    }


    #-------------------------------------------------------------------------
        #  add vector to list of coordinates
    proc coords_flip_y {coordlist} {
            set returnList {}
            foreach {x y} $coordlist {
                set new_y [expr -$y]
                set returnList [lappend returnList $x $new_y]
            }
            return $returnList
    }

    #-------------------------------------------------------------------------
        #  get xy in a flat list of coordinates, start with    0, 1, 2, 3, ...
    proc coords_get_xy {coordlist index} {
            if {$index == {end}} {
                set index_y [expr [llength $coordlist] -1]
                set index_x [expr [llength $coordlist] -2]
            } else {
                set index_x [ expr 2 * $index ]
                set index_y [ expr $index_x + 1 ]
                if {$index_y > [llength $coordlist]} { return {0 0} }
            }
            return [list [lindex $coordlist $index_x] [lindex $coordlist $index_y] ]
    }
    
    #-------------------------------------------------------------------------
        #  sets and format Value
    proc set_projectValue {xpath value {mode {update}}} {
     
         # xpath: e.g.:Custom/BottomBracket/Depth
         variable         _updateValue
     
         puts ""
         puts "   -------------------------------"
         puts "    set_projectValue"
         puts "       xpath:           $xpath"
         puts "       value:           $value"
         puts "       mode:            $mode"
     
           # set _array     [lindex [split $xpath /] 0]
           # set _name     [string range $xpath [string length $_array/] end]
         foreach {_array _name path} [project::unifyKey $xpath] break
           # puts "     ... $_array  $_name"
     
     
         # --- handle xpath values ---
             # puts "  ... mode: $mode"
         if {$mode == {update}} {
             # puts "  ... set_projectValue: $xpath"
         switch -glob $_array {
             {Result} {
                 set newValue [ string map {, .} $value]
                 # puts "\n  ... set_projectValue: ... Result/..."
                 set_resultParameter $_array $_name $newValue
                 return
             }
             default {}
         }
         }
     
     
         # --- exceptions without any format-checks
             # on int list values like defined
             # puts "<D> $xpath"
         switch $xpath {
             {Component/Wheel/Rear/RimDiameter} -
             {Component/Wheel/Front/RimDiameter} -
             {Lugs/RearDropOut/Direction} {
                 set newValue    $value
                 project::setValue [format "%s(%s)" $_array $_name] value $newValue
                 return $newValue
                 }
     
             {Component/CrankSet/ChainRings} -
             {Component/Wheel/Rear/FirstSprocket} {
                 set newValue [ string map {, .} $value]
                     # puts " <D> $newValue"
                 if {$mode == {update}} {
                     project::setValue [format "%s(%s)" $_array $_name] value $newValue
                 }
                 return $newValue
                 }                         
     
             default { }
         }
     
     
     
     
         # --- set new Value
         set newValue [ string map {, .} $value]
         # --- check Value --- ";" ... like in APPL_RimList
         set newValue [lindex [split $newValue ;] 0]
         # --- check Value --- update
         if {$mode == {update}} {
         set _updateValue($xpath) $newValue
         }
     
     
         # --- update or return on errorID
         set checkValue {mathValue}
         if {[file dirname $xpath] == {Rendering}} {
                 # puts "               ... [file dirname $xpath] "
             set checkValue {}
         }
         if {[file tail $xpath]    == {File}     } {
                 # puts "               ... [file tail    $xpath] "
             set checkValue {}
         }
     
         if {[lindex [split $xpath /] 0] == {Rendering}} {
             set checkValue {}
             puts "   ... Rendering: $xpath "
             puts "        ... $value [file tail $xpath]"
         }
     
          puts "               ... checkValue: $checkValue "
     
         # --- update or return on errorID
         if {$checkValue == {mathValue} } {
         if { [catch { set newValue [expr 1.0 * $newValue] } errorID] } {
             puts "\n$errorID\n"
             return
         } else {
             set newValue [format "%.3f" $newValue]
         }
         }
     
         if {$mode == {update}} {
         project::setValue [format "%s(%s)" $_array $_name] value $newValue
         }
     
         return $newValue
     
    }
    #-------------------------------------------------------------------------
       #  handle modification on /root/Result/... values
    proc set_resultParameter {_array _name value} {
    
        variable         _updateValue
    
        puts ""
        puts "   -------------------------------"
        puts "    set_resultParameter"
        puts "       _array:          $_array"
        puts "       _name:           $_name"
        puts "       value:           $value"
    
        variable BottomBracket
        variable HandleBar
        variable Saddle
        variable SeatPost
        variable SeatTube
        variable HeadTube
        variable FrontWheel
        variable Fork
        variable Stem
    
    
        set xpath "$_array/$_name"
        puts "       xpath:           $xpath"
    
        switch -glob $_name {
    
            {Length/BottomBracket/Height}    {
                  # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                  set oldValue                $project::Result(Length/BottomBracket/Height)
                  # 3.2.76 set oldValue       $project::Temporary(BottomBracket/Height)
                  set newValue                [set_projectValue $xpath  $value format]
                  set _updateValue($xpath)    $newValue
                  set delta       [expr $newValue - $oldValue]
                    # puts "   ... oldValue:   $oldValue"
                    # puts "   ... newValue:   $newValue"
                    # puts "   ...... delta:   $delta"
          
                # --- update value
                #
                  set xpath                   Custom/BottomBracket/Depth
                  set oldValue                $project::Custom(BottomBracket/Depth)
                  set newValue                [ expr $oldValue - $delta ]
                  set_projectValue $xpath     $newValue
                  return
              }
          
            {Angle/HeadTube/TopTube} {
                  # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                  set HeadTopTube_Angle       [ set_projectValue $xpath  $value format]
                  set _updateValue($xpath)    $HeadTopTube_Angle
                # puts "          \$HeadTopTube_Angle  = $HeadTopTube_Angle"
          
                # --- update value
                #
                  set HeadTube_Angle          $project::Custom(HeadTube/Angle)
                  set value                    [ expr $HeadTopTube_Angle - $HeadTube_Angle]
                  set xpath                    Custom/TopTube/Angle
          
                  set_projectValue $xpath     $value
                  return
              }
          
            {Angle/SeatTube/Direction} {
                  # puts "\n"
                  # puts "  ... Angle/SeatTube/Direction comes here: $value"
                  # puts ""
                  set oldValue        $project::Result(Angle/SeatTube/Direction)
                  set SP_Setback      [project::getValue Component(SeatPost/Setback)   value]
                  set length_Setback  [expr $SP_Setback * sin([vectormath::rad $value])]
                  set height_Setback  [expr $SP_Setback * cos([vectormath::rad $value])]
                # puts "    -> value $value"
                # puts "    -> oldValue $oldValue"
                # puts "    -> SP_Setback $SP_Setback"
                # puts "    -> length_Setback $length_Setback"
                # puts "    -> height_Setback $height_Setback"
                  set ST_height       [expr [project::getValue Personal(Saddle_Height)   value] - [project::getValue Component(Saddle/Height)   value] + $height_Setback]
                  set length_SeatTube [expr $ST_height / tan([vectormath::rad $value])]
                # puts "    -> ST_height $ST_height"
                # puts "    -> length_SeatTube $length_SeatTube"
          
                # --- update value
                #
                  set value [expr $length_Setback + $length_SeatTube]
                  set xpath                   Personal/Saddle_Distance
                  set_projectValue $xpath     $value
                  return
               }
          
            {Length/SeatTube/VirtualLength} {
                  # puts "  -> Length/SeatTube/VirtualLength"
                  # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
          
                # SeatTube Offset
                #
                  set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                  set newValue                [set_projectValue $xpath  $value format]
                  set _updateValue($xpath)    $newValue
                  set delta                   [expr $newValue - $oldValue]
          
                  set offsetSeatTube          [vectormath::rotateLine {0 0} $delta [expr 180 - $project::Result(Angle/SeatTube/Direction)]]
                  set offsetSeatTube_x        [lindex $offsetSeatTube 0]
                # puts "   -> $offsetSeatTube"
          
                # HeadTube Offset - horizontal
                #
                  set deltaHeadTube           [expr [lindex $offsetSeatTube 1] / sin($project::Custom(HeadTube/Angle) * $vectormath::CONST_PI / 180) ]
                  set offsetHeadTube_x        [expr [lindex $offsetSeatTube 1] / tan($project::Custom(HeadTube/Angle) * $vectormath::CONST_PI / 180) ]
          
                # HeadTube Offset - horizontal & length
                #
                  project::remove_tracing ; #because of setting more then one parameter at once
                #
                  set xpath                   Personal/HandleBar_Distance
                  set newValue                [expr $HandleBar(Distance)    + $offsetHeadTube_x + $offsetSeatTube_x]
                  set_projectValue $xpath     $newValue
                #
                  set xpath                   FrameTubes/HeadTube/Length
                  set newValue                [expr $HeadTube(Length)    + $deltaHeadTube]
                  set_projectValue $xpath     $newValue
                #
                  project::add_tracing
                  set_projectValue $xpath      $newValue
                #
                  return
            }
          
            {Length/HeadTube/ReachLength} {
                  set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                  set newValue                [set_projectValue $xpath  $value format]
                  set _updateValue($xpath)    $newValue
                  set delta                   [expr $newValue - $oldValue]
          
                  set xpath                   Personal/HandleBar_Distance
                  set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                  set newValue                [expr $HandleBar(Distance)    + $delta]
                  set_projectValue $xpath     $newValue
                  return
            }
          
            {Length/HeadTube/StackHeight} {
                  set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                  set newValue                [set_projectValue $xpath  $value format]
                  set _updateValue($xpath)    $newValue
                  set delta                   [expr $newValue - $oldValue]
          
                  set deltaHeadTube           [expr $delta / sin($project::Custom(HeadTube/Angle) * $vectormath::CONST_PI / 180) ]
                  set offsetHeadTube_x        [expr $delta / tan($project::Custom(HeadTube/Angle) * $vectormath::CONST_PI / 180) ]
          
                # puts "==================="
                # puts "    delta             $delta"
                # puts "    deltaHeadTube     $deltaHeadTube"
                # puts "    offsetHeadTube_x  $offsetHeadTube_x"
          
                #
                  project::remove_tracing ; #because of setting two parameters at once
                #
                  set xpath                    Personal/HandleBar_Height
                  set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                  set newValue                [expr $HandleBar(Height)    + $delta]
                  set_projectValue $xpath      $newValue
                #
                  project::add_tracing
                #
                  set xpath                   FrameTubes/HeadTube/Length
                  set oldValue                $project::FrameTubes(HeadTube/Length)
                  set newValue                [expr $project::FrameTubes(HeadTube/Length) + $deltaHeadTube ]
                  set_projectValue $xpath     $newValue
                #
                  return
            }
          
            {Length/TopTube/VirtualLength}            -
            {Length/FrontWheel/horizontal} {
                  # puts "  -> Length/TopTube/VirtualLength"
                  # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                  set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                  # set oldValue              [ [ $domProject selectNodes $xpath  ]    asText ]
                  set newValue                [set_projectValue $xpath  $value format]
                  set _updateValue($xpath)    $newValue
                  set delta                   [expr $newValue - $oldValue]
          
                # --- set HandleBar(Distance)
                #
                  set newValue                [ expr $HandleBar(Distance)    + $delta ]
                  set xpath                   Personal/HandleBar_Distance
                  set_projectValue $xpath     $newValue
                  return
              }
          
            {Length/RearWheel/horizontal} {
                  # puts "  -> Length/TopTube/VirtualLength"
                  # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                  #set oldValue               [project::getValue [format "%s(%s)" $_array $_name] value]
                  # set oldValue              [ [ $domProject selectNodes $xpath  ]    asText ]
                  set newValue                [set_projectValue $xpath  $value format]
                  set _updateValue($xpath)    $newValue
                  #set delta                  [expr $newValue - $oldValue]
                  set bbDepth                 $project::Custom(BottomBracket/Depth)
          
                # --- set HandleBar(Distance)
                #
                  set newValue                [ expr { sqrt( $newValue * $newValue + $bbDepth * $bbDepth ) } ]
                  set xpath                   Custom/WheelPosition/Rear
                  set_projectValue $xpath     $newValue
                  return
              }
          
            {Length/FrontWheel/diagonal}    {
                # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                  set oldValue                [project::getValue [format "%s(%s)" $_array $_name] value]
                # set oldValue              [ [ $domProject selectNodes $xpath  ]    asText ]
                  set newValue                [set_projectValue $xpath  $value format]
                  set _updateValue($xpath)    $newValue
                # puts "                 <D> ... $oldValue $newValue"
          
                # --- set HandleBar(Angle)
                #
                  set vect_01     [ expr $Stem(Length) * cos($Stem(Angle) * $vectormath::CONST_PI / 180) ]
                  set vect_02     [ expr $vect_01 - $Fork(Rake) ]
          
                  set FrontWheel(Distance_X_tmp)  [ expr { sqrt( $newValue * $newValue - $FrontWheel(Distance_Y) * $FrontWheel(Distance_Y) ) } ]
                  set FrontWheel(Position_tmp)    [ list $FrontWheel(Distance_X_tmp) $FrontWheel(Distance_Y)]
          
                  set help_03   [ vectormath::cathetusPoint    $HandleBar(Position)    $FrontWheel(Position_tmp)    $vect_02  close ]
                  set vect_HT   [ vectormath::parallel      $help_03                  $FrontWheel(Position_tmp)    $Fork(Rake) ]
                # puts "                 <D> ... $vect_HT"
          
                  set help_01  [ lindex $vect_HT 0]
                  set help_02  [ lindex $vect_HT 1]
                  set help_03  [list -200 [ lindex $help_02 1] ]
          
                  set newValue                [ vectormath::angle    $help_01 $help_02 $help_03 ]
                  set xpath                   Custom/HeadTube/Angle
                  set_projectValue $xpath     $newValue
                  return
              }
          
            {Length/Saddle/Offset_HB}    {
                  # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                  set oldValue               [ project::getValue [format "%s(%s)" $_array $_name] value ]
                  set newValue               [ set_projectValue $xpath  $value format ]
                  set _updateValue($xpath)   $newValue
          
                  set delta                    [ expr $oldValue - $newValue ]
                    # puts "          $newValue - $oldValue = $delta"
          
                # --- set HandleBar(Distance)
                #
                  set newValue                [ expr $HandleBar(Height)    + $delta ]
                  set xpath                   Personal/HandleBar_Height
                  set_projectValue $xpath     $newValue
                  return
              }
          
            {Length/Saddle/Offset_BB_ST}    {
                  # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                  set newValue                [ set_projectValue $xpath  $value format ]
                  set height                  [ project::getValue [format "%s(%s)" Personal Saddle_Height] value ]
                  set angle                   [ vectormath::dirAngle {0 0} [list $newValue $height] ]
          
                  set_resultParameter Result Angle/SeatTube/Direction $angle
          
                # puts "   $newValue / $height -> $angle"
                  return
              }
          
            {Length/Saddle/Offset_BB_Nose}    {
                  # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                  set oldValue                [ project::getValue [format "%s(%s)" $_array $_name] value ]
                  set newValue                [ set_projectValue $xpath  $value format ]
                  set delta                   [ expr -1.0 * ($newValue - $oldValue) ]
          
                # --- set HandleBar(Distance)
                #
                  set newValue                [ expr $project::Component(Saddle/LengthNose) + $delta ]
                  set xpath                   Component/Saddle/LengthNose
                  set_projectValue $xpath     $newValue
                  return
              }
          
          
          
          
            default {
                  puts "\n"
                  puts "     WARNING!"
                  puts "\n"
                  puts "        ... set_resultParameter:  "
                  puts "                 $xpath"
                  puts "            ... is not registered!"
                  puts "\n"
                  return
              }
        }
    
    }
    #-------------------------------------------------------------------------
       #  trace/update Project
    proc trace_Project {varname key operation} {
        if {$key != ""} {
    	    set varname ${varname}($key)
    	    }
        upvar $varname var
        # value is 889 (operation w)
        # value is 889 (operation r)
        puts "trace_Prototype: (operation: $operation) $varname is $var "
    }
    
    
    
    
    
    #-------------------------------------------------------------------------
        #  return project attributes
    proc project_attribute {attribute } {
            variable Project
            return $Project($attribute)
    }



 }

