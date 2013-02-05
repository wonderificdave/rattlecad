 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_cv_custom.tcl
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
 #    namespace:  rattleCAD::cv_custom
 # ---------------------------------------------------------------------------
 #
 #


    proc cv_custom::createFrameJig {cv_Name  xy   stageScale  frameJigType} {
            frame_visualisation::createDecoration       $cv_Name $xy    RearWheel_Rep
            frame_visualisation::createDecoration       $cv_Name $xy    FrontWheel_Rep
                #
            frame_visualisation::createFrame_Tubes      $cv_Name $xy
                #
            frame_visualisation::createDecoration       $cv_Name $xy    DerailleurRear_ctr
                #
            createCenterline                            $cv_Name $xy
                #
            get_FrameJig                                $frameJigType
                #
            createDimension                             $cv_Name $xy    cline_brake
            
                #
              # puts " <D> ..... cv_custom::createFrameJig $frameJigType"
            switch -exact $frameJigType {
                nuremberg -
                vogeltanz {       
                        createJigDimension    $cv_Name $xy    cline_vogeltanz
                        createJigDimension    $cv_Name $xy    bg_vogeltanz 
                    }
                          
                vienna -
                selberbruzzler {  
                        createJigDimension    $cv_Name $xy    cline_rattleCAD
                        createJigDimension    $cv_Name $xy    bg_rattleCAD 
                    }
                          
                ilz -
                graz -
                rattleCAD {         
                        createJigDimension    $cv_Name $xy    cline_rattleCAD
                        createJigDimension    $cv_Name $xy    bg_rattleCAD 
                    }

                geldersheim -
                default {         
                        createJigDimension    $cv_Name $xy    cline_geldersheim
                        createJigDimension    $cv_Name $xy    bg_geldersheim 
                    }
            }
                #
            createParameterTable                        $cv_Name $stageScale
    }


    proc cv_custom::get_FrameJig {frameJigType} {
            variable FrameJig
            variable RearWheel
            variable FrontWheel
            variable Steerer
            variable SeatPost
            variable BottomBracket

                    
            switch -exact $frameJigType {        
                vienna -
                selberbruzzler {                          
                        set FrameJig(SeatTube)  [ vectormath::intersectPerp       $SeatPost(SeatTube)   $BottomBracket(Position)  $RearWheel(Position) ]
                        set FrameJig(HeadTube)  [ vectormath::intersectPoint      $RearWheel(Position)  $FrameJig(SeatTube)   $Steerer(Stem)  $Steerer(Fork) ]

                        set angle_SeatTube      [ vectormath::angle $RearWheel(Position) $FrameJig(SeatTube) $BottomBracket(Position)]                        
                        set angle_HeadTube      [ vectormath::angle $RearWheel(Position) $FrameJig(HeadTube) $Steerer(Stem)]                        
                        set FrameJig(Angles)    [list $angle_SeatTube $angle_HeadTube]
                          # puts "\n   ... selberbruzzler"
                          # puts "   ... \$FrameJig(HeadTube) $FrameJig(HeadTube)"
                          # puts "   ... \$FrameJig(SeatTube) $FrameJig(SeatTube)"
                          # puts "\n"
                    }

                nuremberg -
                vogeltanz {                          
                        set FrameJig(HeadTube)  [ vectormath::intersectPerp       $Steerer(Stem)  $Steerer(Fork)  $RearWheel(Position) ]
                        set FrameJig(SeatTube)  [ vectormath::intersectPoint      $RearWheel(Position)  $FrameJig(HeadTube)   $SeatPost(SeatTube)   $BottomBracket(Position) ]
                        
                        set help_bb             [ list [lindex $RearWheel(Position) 0] [lindex $BottomBracket(Position) 1] ]
                        set help_fk             [ vectormath::intersectPoint      $Steerer(Fork)  $Steerer(Stem)   $help_bb $BottomBracket(Position) ]

                        set hlp_01              [ vectormath::addVector $BottomBracket(Position) {-100 0} ] 
                        set angle_SeatTube      [ vectormath::angle $help_bb $BottomBracket(Position) $SeatPost(SeatTube)]                        
                        set angle_SeatChain     [ vectormath::angle $RearWheel(Position) $BottomBracket(Position) $SeatPost(SeatTube)]                        
                        set angle_HeadTube      [ vectormath::angle $BottomBracket(Position) $help_fk $Steerer(Stem)]                        
                        set FrameJig(Angles)    [list $angle_SeatTube $angle_SeatChain $angle_HeadTube]
                          # puts "\n   ... vogeltanz"
                          # puts "   ... \$FrameJig(HeadTube) $FrameJig(HeadTube)"
                          # puts "   ... \$FrameJig(SeatTube) $FrameJig(SeatTube)"
                          # puts "\n"
                    }
                    
                geldersheim {                          
                        set FrameJig(HeadTube)  [ vectormath::intersectPerp       $Steerer(Stem)  $Steerer(Fork)  $BottomBracket(Position) ]
                        set FrameJig(SeatTube)  $BottomBracket(Position)
                        
                        set help_bb             [ vectormath::intersectPerp      $FrameJig(HeadTube)    $FrameJig(SeatTube)  $RearWheel(Position) ]
                        set help_fk             $FrameJig(HeadTube) 
                        set hlp_01              [ vectormath::addVector $BottomBracket(Position) {-100 0} ] 
                     
                        set angle_SeatTube      [ vectormath::angle $SeatPost(SeatTube) $BottomBracket(Position) $help_bb]                        
                        set angle_SeatChain     [ vectormath::angle $RearWheel(Position) $BottomBracket(Position) $help_bb]                        
                        set angle_HeadTube      [ vectormath::angle $BottomBracket(Position) $help_fk $Steerer(Stem)]                        
                        set FrameJig(Angles)    [list $angle_SeatTube $angle_SeatChain $angle_HeadTube]
                          # puts "\n   ... geldersheim"
                          # puts "   ... \$FrameJig(HeadTube) $FrameJig(HeadTube)"
                          # puts "   ... \$FrameJig(SeatTube) $FrameJig(SeatTube)"
                          # puts "\n"
                    }
                    
                ilz -
                graz -
                rattleCAD -
                default {                          
                        set FrameJig(HeadTube)  [ vectormath::intersectPerp       $Steerer(Stem)  $Steerer(Fork)  $RearWheel(Position) ]
                        set FrameJig(SeatTube)  [ vectormath::intersectPoint      $RearWheel(Position)  $FrameJig(HeadTube)   $SeatPost(SeatTube)   $BottomBracket(Position) ]
                        
                        set angle_SeatTube      [ vectormath::angle $RearWheel(Position) $FrameJig(SeatTube) $BottomBracket(Position)]                        
                        set angle_HeadTube      [ vectormath::angle $RearWheel(Position) $FrameJig(HeadTube) $Steerer(Stem)]                        
                        set FrameJig(Angles)    [list $angle_SeatTube $angle_HeadTube]
                          # puts "\n   ... rattleCAD"
                          # puts "   ... \$FrameJig(HeadTube) $FrameJig(HeadTube)"
                          # puts "   ... \$FrameJig(SeatTube) $FrameJig(SeatTube)"
                          # puts "\n"
                    }
            }
   }
 
 

    proc cv_custom::createJigDimension {cv_Name BB_Position type {active {on}}} {

            variable    stageScale

            variable    Rendering

            variable    BottomBracket
            variable    DownTube
            variable    Fork
            variable    FrameJig
            variable    FrontBrake
            variable    FrontWheel
            variable    HandleBar
            variable    HeadTube
            variable    HeadSet
            variable    LegClearance
            variable    RearBrake
            variable    RearDrop
            variable    RearWheel
            variable    Saddle
            variable    SaddleNose
            variable    SeatPost
            variable    SeatStay
            variable    SeatTube
            variable    Steerer
            variable    Stem
            variable    TopTube

            variable    Position
            variable    Length
            variable    Angle
            variable    Vector


                # --- create dimension -------------------
            switch $type {
    
                cline_rattleCAD {

                                set help_fk             [ vectormath::intersectPoint    $Steerer(Fork)  $Steerer(Stem)    $FrontWheel(Position) $RearWheel(Position) ]

                            $cv_Name create circle        $HeadTube(Fork)       -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
                            $cv_Name create circle        $FrameJig(HeadTube)   -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
                            $cv_Name create circle        $FrameJig(SeatTube)   -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
                            $cv_Name create circle        $help_fk              -radius  4  -outline gray50    -width 0.35     -tags __CenterLine__
                            $cv_Name create centerline  [ project::flatten_nestedList $FrameJig(HeadTube) $RearWheel(Position)] \
                                                                                    -fill darkred   -width 0.25     -tags __CenterLine__
                            $cv_Name create centerline  [ project::flatten_nestedList $RearWheel(Position) $help_fk] \
                                                                                    -fill darkred   -width 0.25     -tags __CenterLine__
                        }
                cline_vogeltanz {
                                set help_bb             [ list [lindex $RearWheel(Position) 0] [lindex $BottomBracket(Position) 1] ]
                                set help_fk             [ vectormath::intersectPoint    $Steerer(Fork)  $Steerer(Stem)    $help_bb $BottomBracket(Position) ]
                                set help_01             [ vectormath::intersectPerp     $Steerer(Fork)  $Steerer(Stem)    $FrontWheel(Position) ]
                                
                            $cv_Name create circle        $HeadTube(Fork)       -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
                            $cv_Name create circle        $help_fk              -radius  4  -outline gray50    -width 0.35     -tags __CenterLine__
                            $cv_Name create circle        $help_bb              -radius  4  -outline gray50    -width 0.35     -tags __CenterLine__
                            $cv_Name create circle        $FrontWheel(Position) -radius  4  -outline gray50    -width 0.35     -tags __CenterLine__
                            $cv_Name create centerline  [ project::flatten_nestedList $help_bb $help_fk] \
                                                                                    -fill darkred   -width 0.25     -tags __CenterLine__
                            $cv_Name create centerline  [ project::flatten_nestedList $help_01 $help_fk] \
                                                                                    -fill gray60    -width 0.25     -tags __CenterLine__
                            
                              # $cv_Name create circle        $FrameJig(HeadTube)   -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
                              # $cv_Name create circle        $FrameJig(SeatTube)   -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
                              # $cv_Name create centerline  [ project::flatten_nestedList $FrameJig(HeadTube) $RearWheel(Position)] \
                                                                                      -fill darkred   -width 0.25     -tags __CenterLine__
                        }
                cline_geldersheim {
                              set help_bb             [ vectormath::intersectPerp      $FrameJig(HeadTube)    $FrameJig(SeatTube)  $RearWheel(Position) ]
                              set help_fk             [ vectormath::intersectPerp      $Steerer(Stem)  $Steerer(Fork)  $BottomBracket(Position) ]

                                #set help_fk             [ vectormath::intersectPoint    $Steerer(Fork)  $Steerer(Stem)    $help_bb $BottomBracket(Position) ]
                                #set help_bb             [ list [lindex $RearWheel(Position) 0] [lindex $BottomBracket(Position) 1] ]
                                #set help_01             [ vectormath::intersectPerp      $Steerer(Fork) $Steerer(Stem)    $FrontWheel(Position) ]
                                
                            $cv_Name create circle        $HeadTube(Fork)       -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
                            $cv_Name create circle        $help_fk              -radius  4  -outline gray50    -width 0.35     -tags __CenterLine__
                            $cv_Name create circle        $help_bb              -radius  4  -outline gray50    -width 0.35     -tags __CenterLine__
                            $cv_Name create circle        $FrontWheel(Position) -radius  4  -outline gray50    -width 0.35     -tags __CenterLine__
                            $cv_Name create centerline  [ project::flatten_nestedList $help_bb $help_fk] \
                                                                                    -fill darkred   -width 0.25     -tags __CenterLine__
                            $cv_Name create centerline  [ project::flatten_nestedList $help_bb $RearWheel(Position)] \
                                                                                    -fill gray60   -width 0.25     -tags __CenterLine__
                              
                              # $cv_Name create centerline  [ project::flatten_nestedList $help_01 $help_fk] \
                                                                                    -fill darkred   -width 0.25     -fill gray60 -tags __CenterLine__
                            
                              # $cv_Name create circle        $FrameJig(HeadTube)   -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
                              # $cv_Name create circle        $FrameJig(SeatTube)   -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
                              # $cv_Name create centerline  [ project::flatten_nestedList $FrameJig(HeadTube) $RearWheel(Position)] \
                                                                                      -fill darkred   -width 0.25     -tags __CenterLine__
                        }
                    # -----------------------
                bg_rattleCAD {
                              # puts "   <D>    ... createJigDimension::bg_rattleCAD ($type)"
                            
                              set help_bb           [ list [lindex $RearWheel(Position) 0] [lindex $BottomBracket(Position) 1] ]
                              set help_fk           [ vectormath::intersectPoint    $Steerer(Fork)  $Steerer(Stem)   $FrontWheel(Position) $RearWheel(Position) ]

                                # -- Dimensions ------------------------
                                #
                            set _dim_Jig_length     [ $cv_Name dimension  length  [ project::flatten_nestedList   $RearWheel(Position)    $FrameJig(HeadTube)] \
                                                                                        aligned     [expr  -170 * $stageScale]   0 \
                                                                                        darkblue ]

                            set _dim_CS_Length      [ $cv_Name dimension  length  [ project::flatten_nestedList   $RearWheel(Position)    $BottomBracket(Position)] \
                                                                                        aligned     [expr    80 * $stageScale]   0 \
                                                                                        gray30 ]
                            set _dim_CS_LengthHor   [ $cv_Name dimension  length  [ project::flatten_nestedList   $BottomBracket(Position)    $RearWheel(Position)  ] \
                                                                                        horizontal  [expr  -100 * $stageScale]   0 \
                                                                                        gray30 ]
                            set _dim_BB_Depth       [ $cv_Name dimension  length  [ project::flatten_nestedList   $RearWheel(Position)  $BottomBracket(Position) ] \
                                                                                        vertical    [expr    80 * $stageScale]   [expr  70 * $stageScale]  \
                                                                                        gray30 ]
                            set _dim_HT_Dist_x      [ $cv_Name dimension  length  [ project::flatten_nestedList   $BottomBracket(Position)    $HeadTube(Fork)] \
                                                                                        horizontal  [expr   100 * $stageScale]   0 \
                                                                                        gray30 ]
                            set _dim_HT_Dist_y      [ $cv_Name dimension  length  [ project::flatten_nestedList   $BottomBracket(Position)    $HeadTube(Fork)] \
                                                                                        vertical    [expr   300 * $stageScale]   0 \
                                                                                        gray30 ]
                            set _dim_WH_Distance    [ $cv_Name dimension  length  [ project::flatten_nestedList   $RearWheel(Position)    $help_fk] \
                                                                                        aligned     [expr   210 * $stageScale]   0 \
                                                                                        gray30 ]
                            
                            set _dim_HT_Offset      [ $cv_Name dimension  length  [ project::flatten_nestedList   $FrameJig(HeadTube)         $HeadTube(Fork)] \
                                                                                        aligned     [expr   100 * $stageScale]   [expr  -100 * $stageScale] \
                                                                                        darkred ]
                            set _dim_CS_LengthJig   [ $cv_Name dimension  length  [ project::flatten_nestedList   $RearWheel(Position)    $FrameJig(SeatTube)] \
                                                                                        aligned     [expr  -120 * $stageScale]   0 \
                                                                                        darkred ]
                            set _dim_MN_LengthJig   [ $cv_Name dimension  length  [ project::flatten_nestedList   $FrameJig(SeatTube)     $FrameJig(HeadTube)] \
                                                                                        aligned     [expr  -120 * $stageScale]   0 \
                                                                                        darkred ]
                            set _dim_BB_DepthJIg    [ $cv_Name dimension  length  [ project::flatten_nestedList   $BottomBracket(Position)    $FrameJig(SeatTube)] \
                                                                                        aligned     [expr    60 * $stageScale]   0 \
                                                                                        darkred ]
                            set _dim_ST_Angle       [ $cv_Name dimension  angle [ project::flatten_nestedList  $FrameJig(SeatTube)   $RearWheel(Position)   $BottomBracket(Position) ] \
                                                                                         90   0  \
                                                                                        darkred ]
                            set _dim_HT_Angle       [ $cv_Name dimension  angle [ project::flatten_nestedList  $FrameJig(HeadTube)   $Steerer(Stem)   $RearWheel(Position) ] \
                                                                                         90  10  \
                                                                                        darkred ]
                                # -- Fork Details ----------------------
                                #
                            set _dim_HT_Fork        [ $cv_Name dimension  length  [ project::flatten_nestedList  $FrameJig(HeadTube)    $help_fk] \
                                                                                        aligned     [expr  -100 * $stageScale]   0 \
                                                                                        darkblue ]
                            set _dim_Fork_Height    [ $cv_Name dimension  length  [ project::flatten_nestedList            $help_fk $HeadTube(Fork)  ] \
                                                                                        aligned        [expr   150 * $stageScale]   0 \
                                                                                        gray30 ]
                        }
                    # -----------------------
                bg_geldersheim {
                              # puts "   <D>    ... createJigDimension::bg_rattleCAD ($type)"
                            
                              set help_bb             [ vectormath::intersectPerp       $FrameJig(HeadTube)    $FrameJig(SeatTube)  $RearWheel(Position) ]
                              set help_fk             [ vectormath::intersectPerp       $Steerer(Stem)  $Steerer(Fork)  $BottomBracket(Position) ]

                                # -- Dimensions ------------------------
                                #
                            set _dim_Jig_length     [ $cv_Name dimension  length  [ project::flatten_nestedList   $help_bb    $help_fk] \
                                                                                        aligned     [expr  150 * $stageScale]   0 \
                                                                                        darkblue ]
                            set _dim_CS_LengthJig   [ $cv_Name dimension  length  [ project::flatten_nestedList   $help_bb    $BottomBracket(Position)] \
                                                                                        aligned     [expr  100 * $stageScale]   0 \
                                                                                        darkred ]
                            set _dim_MN_LengthJig   [ $cv_Name dimension  length  [ project::flatten_nestedList   $BottomBracket(Position)     $FrameJig(HeadTube)] \
                                                                                        aligned     [expr  100 * $stageScale]   0 \
                                                                                        darkred ]

                            set _dim_CS_Length      [ $cv_Name dimension  length  [ project::flatten_nestedList   $RearWheel(Position)    $BottomBracket(Position)] \
                                                                                        aligned     [expr -100 * $stageScale]   0 \
                                                                                        gray30 ]
                              #set _dim_CS_LengthHor   [ $cv_Name dimension  length  [ project::flatten_nestedList   $BottomBracket(Position)    $RearWheel(Position)  ] \
                                                                                          horizontal  [expr  -100 * $stageScale]   0 \
                                                                                        gray30 ]
                            set _dim_BB_Depth       [ $cv_Name dimension  length  [ project::flatten_nestedList   $RearWheel(Position)  $BottomBracket(Position) ] \
                                                                                        vertical    [expr   80 * $stageScale]   [expr  70 * $stageScale]  \
                                                                                        gray30 ]
                            set _dim_HT_Dist        [ $cv_Name dimension  length  [ project::flatten_nestedList   $HeadTube(Fork)     $BottomBracket(Position)] \
                                                                                        aligned     [expr  100 * $stageScale]   0 \
                                                                                        gray30 ]
                              # set _dim_HT_Dist_y      [ $cv_Name dimension  length  [ project::flatten_nestedList   $HeadTube(Fork)     $BottomBracket(Position)] \
                                                                                          vertical    [expr  -240 * $stageScale]   0 \
                                                                                          gray30 ]
                              # set _dim_HT_Dist_x      [ $cv_Name dimension  length  [ project::flatten_nestedList   $HeadTube(Fork)     $BottomBracket(Position)] \
                                                                                          horizontal  [expr   -80 * $stageScale]   0 \
                                                                                          gray30 ]
                              #set _dim_WH_Distance    [ $cv_Name dimension  length  [ project::flatten_nestedList   $RearWheel(Position)    $help_fk] \
                                                                                          aligned     [expr   210 * $stageScale]   0 \
                                                                                          gray30 ]
                            
                            set _dim_HT_Offset      [ $cv_Name dimension  length  [ project::flatten_nestedList   $FrameJig(HeadTube)         $HeadTube(Fork)] \
                                                                                        aligned     [expr   100 * $stageScale]   [expr   10 * $stageScale] \
                                                                                        darkred ]
                            set _dim_BB_DepthJIg    [ $cv_Name dimension  length  [ project::flatten_nestedList   $RearWheel(Position)    $help_bb] \
                                                                                        aligned     [expr   120 * $stageScale]   0 \
                                                                                        darkred ]
                            set _dim_ST_Angle       [ $cv_Name dimension  angle [ project::flatten_nestedList  $BottomBracket(Position)   $SeatPost(SeatTube)   $help_bb ] \
                                                                                         90   0  \
                                                                                        darkred ]
                            set _dim_ST_Angle_2     [ $cv_Name dimension  angle [ project::flatten_nestedList  $BottomBracket(Position)   $RearWheel(Position)   $help_bb ] \
                                                                                        150  40  \
                                                                                        darkred ]
                            set _dim_HT_Angle       [ $cv_Name dimension  angle [ project::flatten_nestedList  $FrameJig(HeadTube)   $Steerer(Stem)   $BottomBracket(Position) ] \
                                                                                         90  10  \
                                                                                        darkred ]
                                # -- Fork Details ----------------------
                                #
                            #set _dim_HT_Fork        [ $cv_Name dimension  length  [ project::flatten_nestedList  $FrameJig(HeadTube)    $help_fk] \
                                                                                        aligned     [expr  -100 * $stageScale]   0 \
                                                                                        darkblue ]
                            #set _dim_Fork_Height    [ $cv_Name dimension  length  [ project::flatten_nestedList            $help_fk $HeadTube(Fork)  ] \
                                                                                        aligned        [expr   150 * $stageScale]   0 \
                                                                                        gray30 ]
                        }
                    # -----------------------
                bg_vogeltanz {
                              # puts "   <D>    ... createJigDimension::bg_vogeltanz ($type)"

                              set help_bb           [ list [lindex $RearWheel(Position) 0] [lindex $BottomBracket(Position) 1] ]
                              set help_fk           [ vectormath::intersectPoint                $Steerer(Fork)        $Steerer(Stem)   $help_bb $BottomBracket(Position) ]
                              set help_01           [ vectormath::intersectPerp      $Steerer(Fork) $Steerer(Stem)    $FrontWheel(Position) ]
                                # -- Dimensions ------------------------
                                #
                            set _dim_ST_Angle       [ $cv_Name dimension  angle [ project::flatten_nestedList  $BottomBracket(Position) $SeatPost(SeatTube) $help_bb ] \
                                                                                         90   0  \
                                                                                        darkred ]
                            set _dim_ST_Angle2      [ $cv_Name dimension  angle [ project::flatten_nestedList  $BottomBracket(Position) $SeatPost(SeatTube) $RearWheel(Position) ] \
                                                                                        150   0  \
                                                                                        darkred ]
                            set _dim_HT_Angle       [ $cv_Name dimension  angle [ project::flatten_nestedList  $help_fk   $Steerer(Stem)   $BottomBracket(Position) ] \
                                                                                         90   0  \
                                                                                        darkred ]
                            

                            set _dim_CS_Length      [ $cv_Name dimension  length  [ project::flatten_nestedList   $RearWheel(Position)    $BottomBracket(Position)] \
                                                                                        aligned     [expr    80 * $stageScale]   0 \
                                                                                        darkred ]
                            set _dim_FK_Distance    [ $cv_Name dimension  length  [ project::flatten_nestedList   $BottomBracket(Position)    $help_fk] \
                                                                                        aligned     [expr    80 * $stageScale]   0 \
                                                                                        darkred ]
                            set _dim_HT_Offset      [ $cv_Name dimension  length  [ project::flatten_nestedList   $help_fk         $HeadTube(Fork)] \
                                                                                        aligned     [expr   140 * $stageScale]  [expr -50 * $stageScale] \
                                                                                        darkred ]
                            set _dim_WH_Distance    [ $cv_Name dimension  length  [ project::flatten_nestedList   $help_bb  $help_fk ] \
                                                                                        aligned     [expr   130 * $stageScale]   0 \
                                                                                        gray30 ]
                            set _dim_BB_Depth       [ $cv_Name dimension  length  [ project::flatten_nestedList   $RearWheel(Position)  $help_bb ] \
                                                                                        vertical    [expr    80 * $stageScale]  [expr  70 * $stageScale]  \
                                                                                        gray30 ]
                            set _dim_FK_Length     [ $cv_Name dimension  length   [ project::flatten_nestedList  $help_01   $FrontWheel(Position)   $HeadTube(Fork) ] \
                                                                                        perpendicular [expr  40 * $stageScale]  [expr  20 * $stageScale]  \
                                                                                        gray30 ]
                              
                              # set _dim_HT_Angle2       [ $cv_Name dimension  angle [ project::flatten_nestedList  $FrameJig(HeadTube)   $Steerer(Stem)   $RearWheel(Position) ] \
                                                                                           90  10  \
                                                                                          gray30 ]
                              # set _dim_Jig_length     [ $cv_Name dimension  length  [ project::flatten_nestedList   $RearWheel(Position)    $FrameJig(HeadTube)] \
                                                                                          aligned     [expr  -110 * $stageScale]   0 \
                                                                                          gray30 ]


                            return                              
 
                        }
                    # -----------------------
                default {
                        }
            }
    }


    proc cv_custom::createParameterTable {cv_Name stageScale} {
            variable FrameJig
            variable RearWheel
            variable BottomBracket
            
            set textPosition    [list [expr 5/$stageScale] [expr 5/$stageScale]]
            set lineDistance    6
                # set textOffset      [list [expr 2/$stageScale] [expr 1/$stageScale]]
                # set columnWidth_1   [list [expr 27/$stageScale] 0]
                # set columnWidth_2   [list [expr 17/$stageScale] 0]
                                            
                # puts "  -> $cv_Name"
            switch -exact $cv_Name {
                lib_gui::cv_Custom70 {    
                        #    set help_fk             [ vectormath::intersectPoint                $Steerer(Fork)        $Steerer(Stem)   $FrontWheel(Position) $RearWheel(Position) ]

                        set index 0
                        foreach angle $FrameJig(Angles) {
                        
                            #set angle_SeatTubeJig       [ vectormath::angle $RearWheel(Position) $FrameJig(SeatTube) $BottomBracket(Position)]
                                # puts "   -> $angle_SeatTubeJig"
                                # $cv_Name create circle        $RearWheel(Position)      -radius  6  -outline darkblue  -width 0.35 -tags __CenterLine__
                                # $cv_Name create circle        $FrameJig(SeatTube)       -radius 10  -outline darkblue  -width 0.35 -tags __CenterLine__
                                # $cv_Name create circle        $BottomBracket(Position)  -radius  8  -outline darkblue  -width 0.35 -tags __CenterLine__
                            #set angleText   [ format "%.2f" $angle_SeatTubeJig ]
                            #set degreeText  [ expr int(floor($angle_SeatTubeJig)) ]
                                # set angleText   [ format "%.2f" $angle ]
                            set angleText   [expr double(round(100*$angle))/100]
                                # puts "     ... $angleText / $angle"
                            set degreeText  [ expr int(floor($angleText)) ]
                            set   minute    [ expr ($angleText - $degreeText) * 60.0 ]
                            set minuteText  [ expr int(floor($minute)) ]
                                # puts "       ->  [expr $angleText - $degreeText]"
                                # puts "       ->  $minuteText"
                                # puts "   -> $degreeText° <-> $minuteText\' <-" 
                            
                            set textPosition_0  [ vectormath::addVector $textPosition     [list [expr 2/$stageScale] [expr (2 + $index * $lineDistance)/$stageScale]]  ] 
                            set textPosition_1  [ vectormath::addVector $textPosition_0   [list [expr 27/$stageScale] 0] ] 
                            set textPosition_2  [ vectormath::addVector $textPosition_1   [list [expr 17/$stageScale] 0] ] 
                            $cv_Name create draftText $textPosition_0    -text "Angle:"                     -anchor sw -size 3.5
                            $cv_Name create draftText $textPosition_1    -text "$angleText°"                -anchor se -size 3.5
                            $cv_Name create draftText $textPosition_2    -text "$degreeText°$minuteText\'"  -anchor se -size 3.5
                            
                            incr index
                        }
      
                    }
                default {return}
            }        
    }
