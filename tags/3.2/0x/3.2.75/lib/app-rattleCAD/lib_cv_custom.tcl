 ##+##########################################################################
 #
 # package: rattleCAD	->	lib_cv_custom.tcl
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
 #	namespace:  rattleCAD::cv_custom
 # ---------------------------------------------------------------------------
 #
 # 

 namespace eval cv_custom {

            variable    bottomCanvasBorder	30
            variable    stageScale          1.0
            
            variable 	baseLine        ;  array set baseLine       {}
            
            variable    Rendering       ;  array set Rendering      {}
                    
            variable    BottomBracket   ;  array set BottomBracket  {}
            variable    DownTube        ;  array set DownTube       {}
            variable    Fork            ;  array set Fork           {}
            variable    FrameJig        ;  array set FrameJig       {}
            variable    FrontBrake      ;  array set FrontBrake     {}
            variable    FrontWheel      ;  array set FrontWheel     {}
            variable    HandleBar       ;  array set HandleBar      {}
            variable    HeadTube        ;  array set HeadTube       {}
            variable    LegClearance    ;  array set LegClearance   {}
            variable    RearBrake       ;  array set RearBrake      {}
            variable    RearDrop        ;  array set RearDrop       {}
            variable    RearWheel       ;  array set RearWheel      {}
            variable    Saddle          ;  array set Saddle         {}
            variable    SeatStay        ;  array set SeatStay       {}
            variable    SeatTube        ;  array set SeatTube       {}
            variable    Steerer         ;  array set Steerer        {}
            variable    Stem            ;  array set Stem           {}
            variable    TopTube         ;  array set TopTube        {}
            
            variable    Position        ;  array set Position       {}
            variable    Length          ;  array set Length         {}
            variable    Vector          ;  array set Vector         {}

	
	
	proc get_FormatFactor {stageFormat} {
			puts ""
			puts "   -------------------------------"
			puts "    get_FormatFactor::update"
			puts "       stageFormat:     $stageFormat"
			switch -regexp $stageFormat {
				^A[0-9] {	set factorInt	[expr 1.0 * [string index $stageFormat end] ]
							return			[expr pow(sqrt(2), $factorInt)]
						}
				default	{return 1.0}
			}
    } 	

	
	proc update_cv_Parameter {cv_Name BB_Position} {
			   
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
            variable    SeatStay        
            variable    SeatTube        
            variable    Steerer         
            variable    Stem            
            variable    TopTube         
            
            variable    Position        
            variable    Length          
            variable    Vector          
            

                # --- get stageScale
            set stageScale 	[ $cv_Name  getNodeAttr  Stage	scale ]	

            
                # --- get Rendering Style
            set Rendering(BrakeFront)       $project::Rendering(Brake/Front)		
            set Rendering(BrakeRear)        $project::Rendering(Brake/Rear)		
            set Rendering(BottleCage_ST)    $project::Rendering(BottleCage/SeatTube)		
            set Rendering(BottleCage_DT)    $project::Rendering(BottleCage/DownTube)		
            set Rendering(BottleCage_DT_L)  $project::Rendering(BottleCage/DownTube_Lower)		

            
                # --- get defining Values ----------		
            set RearWheel(RimDiameter)      $frame_geometry::RearWheel(RimDiameter)
            set RearWheel(TyreHeight)       $frame_geometry::RearWheel(TyreHeight)
            set FrontWheel(RimDiameter)     $frame_geometry::FrontWheel(RimDiameter)
            set FrontWheel(TyreHeight)      $frame_geometry::FrontWheel(TyreHeight)
            set Fork(Height)                $frame_geometry::Fork(Height)
            set Fork(Rake)                  $frame_geometry::Fork(Rake)
            set Stem(Length)                $frame_geometry::Stem(Length)
            set Stem(Angle)                 $frame_geometry::Stem(Angle)
            set BottomBracket(depth)        $frame_geometry::BottomBracket(depth)
            set RearDrop(OffsetSSPerp)      $frame_geometry::RearDrop(OffsetSSPerp)	
            set RearDrop(OffsetCSPerp)      $frame_geometry::RearDrop(OffsetCSPerp)	
            set DownTube(OffsetBB)          $frame_geometry::DownTube(OffsetBB)	

            
                # --- get defining Point coords ----------
            set BottomBracket(Position)		$BB_Position
            set RearWheel(Position)         [ frame_geometry::object_values		RearWheel			position	$BB_Position ]
            set FrontWheel(Position)        [ frame_geometry::object_values		FrontWheel			position	$BB_Position ]
            set Saddle(Position)            [ frame_geometry::object_values 	Saddle				position	$BB_Position ]
            set Saddle(Proposal)            [ frame_geometry::object_values 	SaddleProposal		position	$BB_Position ]
            set SeatStay(SeatTube)          [ frame_geometry::object_values		SeatStay/End		position	$BB_Position ]
            set TopTube(SeatTube)           [ frame_geometry::object_values		TopTube/Start		position	$BB_Position ]
            set TopTube(Steerer)            [ frame_geometry::object_values		TopTube/End			position	$BB_Position ]
            set HeadTube(Stem)              [ frame_geometry::object_values		HeadTube/End		position	$BB_Position ]
            set HeadTube(Fork)              [ frame_geometry::object_values		HeadTube/Start		position	$BB_Position ]
            set Steerer(Stem)               [ frame_geometry::object_values		Steerer/End			position	$BB_Position ]
            set Steerer(Fork)               [ frame_geometry::object_values		Steerer/Start		position	$BB_Position ]
            set DownTube(Steerer)           [ frame_geometry::object_values		DownTube/End		position 	$BB_Position ]
            set DownTube(BBracket)          [ frame_geometry::object_values		DownTube/Start		position 	$BB_Position ]
            set HandleBar(Position)         [ frame_geometry::object_values  	HandleBar 			position	$BB_Position ]
            set Position(BaseCenter)        [ frame_geometry::object_values  	BottomBracketGround	position	$BB_Position ]	
            set Steerer(Ground)             [ frame_geometry::object_values  	SteererGround		position	$BB_Position ]	
            set SeatTube(Ground)            [ frame_geometry::object_values  	SeatTubeGround		position	$BB_Position ]			
            set SeatTube(TopTube)           [ frame_geometry::object_values  	SeatTube/End		position	$BB_Position ]	
            set SeatStay(End)               [ frame_geometry::object_values 	SeatStay/End        position    $BB_Position ]
            
            set RearBrake(Mount)            [ vectormath::addVector 			$frame_geometry::RearBrake(Mount)		$BB_Position ]		
            set RearBrake(Help)             [ vectormath::addVector 			$frame_geometry::RearBrake(Help)		$BB_Position ]	
            set RearBrake(Shoe)             [ vectormath::addVector 			$frame_geometry::RearBrake(Shoe)		$BB_Position ]	
            set RearBrake(Definition)       [ vectormath::addVector 			$frame_geometry::RearBrake(Definition)	$BB_Position ]	
            set FrontBrake(Mount)           [ vectormath::addVector 			$frame_geometry::FrontBrake(Mount)		$BB_Position ]	
            set FrontBrake(Help)            [ vectormath::addVector 			$frame_geometry::FrontBrake(Help)		$BB_Position ]	
            set FrontBrake(Shoe)            [ vectormath::addVector 			$frame_geometry::FrontBrake(Shoe)		$BB_Position ]	
            set FrontBrake(Definition)      [ vectormath::addVector 			$frame_geometry::FrontBrake(Definition)	$BB_Position ]	
            
            set FrameJig(HeadTube)          [ vectormath::addVector 			$frame_geometry::FrameJig(HeadTube)		$BB_Position ]	
            set FrameJig(SeatTube)          [ vectormath::addVector 			$frame_geometry::FrameJig(SeatTube)		$BB_Position ]		
            set LegClearance(Position)      [ vectormath::addVector 			$frame_geometry::LegClearance(Position) $BB_Position ]
            set Position(IS_ChainSt_SeatSt)           [ frame_geometry::object_values  	ChainStay/SeatStay_IS		position	$BB_Position ]	
            
            set Length(CrankSet)		        $project::Component(CrankSet/Length)
            
            
                # --- help points for boot clearance -----
            set Vector(vct_90)				[ vectormath::unifyVector	$BottomBracket(Position) $FrontWheel(Position) ]
            set Vector(help_91)				[ vectormath::addVector		$BottomBracket(Position) 	[ vectormath::unifyVector {0 0} $Vector(vct_90) $Length(CrankSet) ] ]
            set Vector(help_92)				[ vectormath::addVector		$FrontWheel(Position) 	[ vectormath::unifyVector {0 0} $Vector(vct_90) [ expr - ( 0.5 * $FrontWheel(RimDiameter) + $FrontWheel(TyreHeight)) ] ] ]
            set RearWheel(Ground)	[ list [lindex $RearWheel(Position)  0] [lindex $Steerer(Ground) 1] ]
            set FrontWheel(Ground)	[ list [lindex $FrontWheel(Position) 0] [lindex $Steerer(Ground) 1] ]
            
            
                # --- geometry for tubing dimension -----   
            set HeadTube(Diameter)      $frame_geometry::HeadTube(Diameter)
            set HeadTube(polygon)       [ frame_geometry::object_values HeadTube polygon $BB_Position ]
                set pt_01				[ frame_geometry::coords_get_xy $HeadTube(polygon) 2 ]
                set pt_02				[ frame_geometry::coords_get_xy $HeadTube(polygon) 1 ]
                set pt_03				[ frame_geometry::coords_get_xy $HeadTube(polygon) 3 ]
                set pt_04				[ frame_geometry::coords_get_xy $HeadTube(polygon) 0 ]
            set HeadTube(vct_Top)       [ list $pt_01 $pt_02 ]
            set HeadTube(vct_Bottom)    [ list $pt_03 $pt_04 ] 

            set SeatTube(Diameter)      $frame_geometry::SeatTube(DiameterTT) 
            set SeatTube(polygon)       [ frame_geometry::object_values SeatTube polygon $BB_Position  ]
                set pt_01				[ frame_geometry::coords_get_xy $SeatTube(polygon) 4 ]
                set pt_02				[ frame_geometry::coords_get_xy $SeatTube(polygon) 3 ]
            set SeatTube(vct_Top)       [ list $pt_01 $pt_02 ] 
            
            set Steerer(Diameter)       30.0
                set   dir_01            [ split [ project::getValue Result(Tubes/Steerer/Direction)	direction ] ,] 
                set   dir_02            [ vectormath::VRotate $dir_01 -90 grad ]
                set   pt_01             [ vectormath::addVector		$Steerer(Fork)  $dir_02 [expr -0.5 * $Steerer(Diameter)] ]
                set   pt_02             [ vectormath::addVector		$Steerer(Fork)  $dir_02 [expr  0.5 * $Steerer(Diameter)] ]
            set Steerer(vct_Bottom)     [ list $pt_01 $pt_02 ] 
            set Steerer(Start)			[ frame_geometry::object_values 		Steerer/Start	position	$BB_Position  ]
            set Steerer(End)			[ frame_geometry::object_values 		Steerer/End		position	$BB_Position  ]
            
            set HeadSet(Diameter)       $frame_geometry::HeadSet(Diameter)
                set   pt_01             [ vectormath::addVector		$Steerer(Fork)  $dir_02 [expr -0.5 * $HeadSet(Diameter)] ]
                set   pt_02             [ vectormath::addVector		$Steerer(Fork)  $dir_02 [expr  0.5 * $HeadSet(Diameter)] ]
            set HeadSet(vct_Bottom)     [ list $pt_01 $pt_02 ] 

            set TopTube(polygon) 		[ frame_geometry::object_values TopTube  polygon $BB_Position ]
            set DownTube(polygon) 		[ frame_geometry::object_values DownTube polygon $BB_Position ]
            
                # --- help points for virtual horizontal HeadTube -----
            set TopTube(SeatVirtual)	[ vectormath::intersectPoint [list -500 [lindex $TopTube(Steerer) 1]] $TopTube(Steerer)  $BottomBracket(Position) $Saddle(Position) ]


                # --- set values -------------------------
            set RearWheel(Radius)       [ expr [lindex $RearWheel(Position)  1] - [lindex $Position(BaseCenter) 1] ]
            set FrontWheel(Radius)      [ expr [lindex $FrontWheel(Position) 1] - [lindex $Position(BaseCenter) 1] ]
            set Length(Height_HB_Seat)  [ expr [lindex $Saddle(Position) 1] - [lindex $HandleBar(Position) 1] ]
            set Length(Height_HT_Seat)  [ expr [lindex $Saddle(Position) 1] - [lindex $HeadTube(Stem) 1] ]
    } 


	proc createDimension {cv_Name BB_Position type {active {on}}} {

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
            variable    LegClearance    
            variable    RearBrake       
            variable    RearDrop        
            variable    RearWheel       
            variable    Saddle          
            variable    SeatStay        
            variable    SeatTube        
            variable    Steerer         
            variable    Stem            
            variable    TopTube         
            
            variable    Position        
            variable    Length          
            variable    Vector          
        

                # --- create dimension -------------------
            switch $type {
                point_center {
                            $cv_Name create circle 	$Position(BaseCenter)		-radius 10  -outline gray50 	-width 1.0			-tags __CenterLine__	
                        }
                point_personal {
                            $cv_Name create circle 	$BottomBracket(Position)    -radius 20  -outline darkred 	-width 1.0			-tags __CenterLine__
                            $cv_Name create circle 	$HandleBar(Position)		-radius 10  -outline darkred 	-width 1.0			-tags __CenterLine__
                            $cv_Name create circle 	$Saddle(Position)			-radius 10  -outline darkred 	-width 1.0			-tags __CenterLine__
                        }
                point_crank {
                            $cv_Name create circle 	$Vector(help_91)            -radius  4  -outline gray50 	-width 1.0			-tags __CenterLine__
                        }
                point_seat {
                            $cv_Name create circle 	$LegClearance(Position)	-radius  4  -outline darkred 	-width 1.0			-tags __CenterLine__		
                            $cv_Name create circle 	$Saddle(Proposal)		-radius  4  -outline gray 		-width 1.0			-tags __CenterLine__
                        }
                point_frame {
                            $cv_Name create circle 	$Steerer(Fork)			-radius 10  -outline gray 		-width 1.0			-tags __CenterLine__
                            $cv_Name create circle 	$HeadTube(Stem)			-radius 10  -outline gray 		-width 1.0			-tags __CenterLine__
                            $cv_Name create circle 	$TopTube(Steerer)		-radius  4  -outline gray 		-width 1.0			-tags __CenterLine__
                            $cv_Name create circle 	$TopTube(SeatVirtual)	-radius  4  -outline gray 		-width 1.0			-tags __CenterLine__
                        }
                point_frame_dimension {
                            $cv_Name create circle 	$HeadTube(Stem)			-radius  4  -outline gray 		-width 1.0			-tags __CenterLine__
                        }			
                cline_frame {
                            $cv_Name create centerline 	[ project::flatten_nestedList $TopTube(Steerer) $TopTube(SeatVirtual) ] \
                                                                                -fill gray50 		-width 0.25			-tags __CenterLine__	
                        }
                cline_angle {
                            $cv_Name create circle 	$HeadTube(Stem)			-radius  4  -outline blue 		-width 1.0			-tags __CenterLine__		
                            $cv_Name create circle 	$HandleBar(Position)	-radius  4  -outline darkblue	-width 1.0			-tags __CenterLine__		
                            $cv_Name create circle 	$Saddle(Position)		-radius  4  -outline gray50		-width 1.0			-tags __CenterLine__					
                            
                            $cv_Name create centerline 	[ project::flatten_nestedList $Steerer(Stem) $Steerer(Ground) ] \
                                                                                -fill gray50 		-width 0.25			-tags __CenterLine__	
                            $cv_Name create centerline 	[ project::flatten_nestedList $Saddle(Position) $SeatTube(Ground) ] \
                                                                                -fill gray50 		-width 0.25			-tags __CenterLine__		
                        }
                cline_brake {
                            if {$Rendering(BrakeRear) != {off}} {
                                switch $Rendering(BrakeRear) {
                                    Rim { 
                                            # $cv_Name create circle 	$RearBrake(Mount)       -radius  6  -outline gray50		-width 0.35		-tags __CenterLine__
                                        $cv_Name create circle 	$RearBrake(Shoe)    -radius  4  -outline gray50		-width 0.35		-tags __CenterLine__
                                        $cv_Name create circle 	$RearBrake(Mount)   -radius  4  -outline gray50		-width 0.35		-tags __CenterLine__                                
                                        $cv_Name create centerline 	[ project::flatten_nestedList $RearBrake(Definition) $RearBrake(Shoe) $RearBrake(Help) $RearBrake(Mount)] \
                                                                                                -fill gray50        -width 0.25     -tags __CenterLine__			
                                    }
                                }
                            }
                            if {$Rendering(BrakeFront) != {off}} {
                                switch $Rendering(BrakeFront) {
                                    Rim { 
                                            # $cv_Name create circle 	$FrontBrake(Mount)      -radius  6  -outline gray50		-width 0.35		-tags __CenterLine__	
                                        $cv_Name create circle 	$FrontBrake(Shoe)   -radius  4  -outline gray50		-width 0.35		-tags __CenterLine__
                                        $cv_Name create circle 	$FrontBrake(Mount)  -radius  4  -outline gray50		-width 0.35		-tags __CenterLine__                                
                                        $cv_Name create centerline 	[ project::flatten_nestedList $FrontBrake(Definition) $FrontBrake(Shoe) $FrontBrake(Help) $FrontBrake(Mount)] \
                                                                                                -fill gray50 		-width 0.25			-tags __CenterLine__
                                        }
                                }
                            }
                        }
                cline_framejig {
                                set help_fk			[ vectormath::intersectPoint   	$Steerer(Fork) 	$Steerer(Stem)   $FrontWheel(Position) $RearWheel(Position) ]
                        
                            $cv_Name create circle 	$FrameJig(HeadTube)	-radius  5  -outline gray50		-width 0.35		-tags __CenterLine__
                            $cv_Name create circle 	$FrameJig(SeatTube)	-radius  7  -outline gray50		-width 0.35		-tags __CenterLine__	
                            $cv_Name create centerline 	[ project::flatten_nestedList $FrameJig(HeadTube) $RearWheel(Position)] \
                                                                                -fill gray50 		-width 0.25			-tags __CenterLine__		
                            $cv_Name create centerline 	[ project::flatten_nestedList $RearWheel(Position) $help_fk] \
                                                                                -fill gray50 		-width 0.25			-tags __CenterLine__		
                        }
                        
                geometry_bg {
                            set help_01				[ list [lindex $BottomBracket(Position) 0] [lindex $LegClearance(Position) 1] ]

                            set _dim_ST_YPosition	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $BottomBracket(Position) $Saddle(Position) ] \
                                                                vertical	[expr -580 * $stageScale]  [expr -130 * $stageScale]  \
                                                                gray50 ] 
                            set _dim_SD_Height		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $Position(BaseCenter)  $Saddle(Position) ] \
                                                                vertical    [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
                                                                gray50 ] 
                            set _dim_HB_Height		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $HandleBar(Position) $Position(BaseCenter) ] \
                                                                vertical    [expr -380 * $stageScale]  [expr  230 * $stageScale]  \
                                                                gray50 ] 
                            set _dim_SD_HB_Height	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $HandleBar(Position) $Saddle(Position) ] \
                                                                vertical	[expr  380 * $stageScale]  [expr -100 * $stageScale]  \
                                                                gray50 ] 
                            set _dim_SD_HB_Length	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $Saddle(Position) $HandleBar(Position) ] \
                                                                horizontal	[expr  -150 * $stageScale]    0 \
                                                                gray50 ] 
                            

                            set _dim_CS_LengthX 	[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$RearWheel(Ground)  $Position(BaseCenter) ] \
                                                                horizontal  [expr   70 * $stageScale]   0 \
                                                                gray50 ] 
                            set _dim_Wh_Distance	[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$RearWheel(Ground)  $FrontWheel(Ground) ] \
                                                                horizontal  [expr  130 * $stageScale]	0 \
                                                                gray50 ] 
                            set _dim_FW_Lag			[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$FrontWheel(Ground)  $Steerer(Ground) ] \
                                                                horizontal  [expr   70 * $stageScale]   [expr  -70 * $stageScale] \
                                                                gray20 ] 
                                                                
                            set _dim_ST_Virtual		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $BottomBracket(Position) $TopTube(SeatVirtual) ] \
                                                                aligned     [expr   80 * $stageScale]   [expr   90 * $stageScale] \
                                                                gray50 ] 

                            set _dim_BT_Clearance	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $Vector(help_91)  $Vector(help_92) ] \
                                                                aligned		0   [expr -150 * $stageScale]  \
                                                                gray50 ] 
                                                                
                            set _dim_HT_Reach_X		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$HeadTube(Stem)	$BottomBracket(Position) ] \
                                                                horizontal  [expr   50 * $stageScale]    0 \
                                                                gray50 ] 
                            set _dim_HT_Stack_Y		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$HeadTube(Stem)	$BottomBracket(Position) ] \
                                                                vertical    [expr   80 * $stageScale]    [expr  120 * $stageScale]  \
                                                                gray50 ] 
                                                                
                }
                    # -----------------------
                geometry_fg {

                            set help_00			[ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
                            set help_01			[ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
                            set help_02			[ vectormath::addVector   $Steerer(Stem) [ vectormath::unifyVector $Steerer(Stem) $help_01 [expr  50 * $stageScale] ] ]						
                            set help_fk			[ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
                            
                                # colourtable: http://www.ironspider.ca/format_text/fontcolor.htm
                                        # set colour(primary)		red
                                        # set colour(secondary)	darkorange
                                        # set colour(third)		darkblue
                                        # set colour(result)		darkred

                            set colour(primary)		darkorange
                            set colour(secondary)	darkred
                            set colour(third)		darkmagenta
                            set colour(result)		darkblue

                                        # set colour(primary)		darkorange
                                        # set colour(primary)		darkorchid
                                        # set colour(primary)		red
                                        # set colour(primary)		blue
                                        # set colour(secondary)		darkred
                                        # set colour(secondary)		darkorange
                                        # set colour(third)			firebrick
                                        # set colour(result)		firebrick
                                        # set colour(result)		darkorange
                                        # set colour(result)		blue
                            

                                                                    

                                # --- result - level - dimensions
                                #
                            set _dim_ST_XPosition	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $Saddle(Position) $BottomBracket(Position) ] \
                                                                horizontal	[expr  -80 * $stageScale]    0 \
                                                                $colour(result) ] 
                            set _dim_FW_Distance	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $BottomBracket(Position)  $FrontWheel(Position)] \
                                                                aligned     [expr   100 * $stageScale]   [expr  -30 * $stageScale] \
                                                                $colour(result) ] 
                            set _dim_FW_DistanceX	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $Position(BaseCenter)  $FrontWheel(Position) ] \
                                                                horizontal  [expr   70 * $stageScale]   0 \
                                                                $colour(result) ] 
                            set _dim_BB_Height 		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $BottomBracket(Position)	$Position(BaseCenter)] \
                                                                vertical    [expr  150 * $stageScale]   [expr   -20 * $stageScale]  \
                                                                $colour(result) ]
                            set _dim_TT_Virtual		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $TopTube(SeatVirtual)  $TopTube(Steerer)] \
                                                                aligned     [expr    80 * $stageScale]   [expr  -80 * $stageScale] \
                                                                $colour(result) ] 
                                                                
                                                                


                                # --- third - level - dimensions
                                #
                            set _dim_LC_Position_x	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $LegClearance(Position)  $BottomBracket(Position) ] \
                                                                horizontal  [expr   80 * $stageScale]   0  \
                                                                $colour(third) ] 
                            set _dim_LC_Position_y	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $LegClearance(Position)  $Position(BaseCenter) ] \
                                                                vertical    [expr  -50 * $stageScale]   [expr   160 * $stageScale]  \
                                                                $colour(third) ] 
                            set _dim_CR_Length 		[ $cv_Name dimension  radius    [ project::flatten_nestedList  $BottomBracket(Position)  $Vector(help_91)] \
                                                                -20 		[expr  130 * $stageScale] \
                                                                $colour(third) ] 


                                # --- secondary - level - dimensions
                                #
                            set _dim_BB_Depth  		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $BottomBracket(Position)  $RearWheel(Position) ] \
                                                                vertical    [expr  -260 * $stageScale]   [expr -90 * $stageScale]  \
                                                                $colour(secondary) ] 
                            set _dim_CS_Length 		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $RearWheel(Position)  $BottomBracket(Position)] \
                                                                aligned     [expr   100 * $stageScale]   0 \
                                                                $colour(secondary) ] 
                            set _dim_HT_Angle  		[ $cv_Name dimension  angle   	[ project::flatten_nestedList  $Steerer(Ground)  $Steerer(Fork)  $Position(BaseCenter) ] \
                                                                150   0  \
                                                                $colour(secondary) ]
                            set _dim_RW_Radius 		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $RearWheel(Position)  $RearWheel(Ground) ] \
                                                                vertical    [expr   130 * $stageScale]    0 \
                                                                $colour(secondary) ] 
                            set _dim_FW_Radius 		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $FrontWheel(Position)  $FrontWheel(Ground) ] \
                                                                vertical    [expr  -150 * $stageScale]    0 \
                                                                $colour(secondary) ] 
                            set _dim_Stem_Length	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $HandleBar(Position)  $Steerer(Stem) ] \
                                                                aligned     [expr    80 * $stageScale]    0 \
                                                                $colour(secondary) ] 
                            set _dim_HT_Length 		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $Steerer(Fork)  $HeadTube(Stem) ] \
                                                                aligned		[expr   100 * $stageScale]   0 \
                                                                $colour(secondary) ] 
                            
                            if {$Stem(Angle) > 0} {
                                set _dim_Stem_Angle [ $cv_Name dimension  angle 	[ project::flatten_nestedList  $Steerer(Stem)  $help_02 $HandleBar(Position) ] \
                                                                [expr $Stem(Length) +  80]   0  \
                                                                $colour(secondary) ]
                            } else {
                                set _dim_Stem_Angle [ $cv_Name dimension  angle 	[ project::flatten_nestedList  $Steerer(Stem)  $HandleBar(Position)  $help_02 ] \
                                                                [expr $Stem(Length) +  80]   0  \
                                                                $colour(secondary) ]
                            }
                            
                            set _dim_Fork_Rake		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$Steerer(Stem)  $help_fk $FrontWheel(Position) ] \
                                                                perpendicular [expr  100 * $stageScale]    [expr  -80 * $stageScale] \
                                                                $colour(secondary) ] 																
                            if {$Fork(Rake) != 0} {
                                set _dim_Fork_Height	[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$help_fk $FrontWheel(Position) $Steerer(Fork)  ] \
                                                                perpendicular [expr  (100 - $Fork(Rake)) * $stageScale]    [expr  -10 * $stageScale] \
                                                                $colour(secondary) ] 
                            } else {
                                set _dim_Fork_Height	[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$FrontWheel(Position) $Steerer(Fork)  ] \
                                                                aligned 	  [expr  100  * $stageScale]    [expr  -10 * $stageScale] \
                                                                $colour(secondary) ] 
                            }

                            

                                # --- primary - level - dimensions
                                #
                            set _dim_HB_XPosition	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $HandleBar(Position)		$BottomBracket(Position) ] \
                                                                horizontal  [expr   (80 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                                                                $colour(primary) ] 
                            set _dim_HB_YPosition	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $HandleBar(Position)		$BottomBracket(Position) ] \
                                                                vertical    [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
                                                                $colour(primary) ] 
                            set _dim_ST_Length 		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $BottomBracket(Position) $Saddle(Position) ] \
                                                                aligned		[expr -130 * $stageScale]    [expr -170 * $stageScale]  \
                                                                $colour(primary) ] 
                            set _dim_ST_Angle  		[ $cv_Name dimension  angle   	[ project::flatten_nestedList  $SeatTube(Ground)	$Saddle(Position) $help_00 ] \
                                                                150   0  \
                                                                $colour(primary) ]
                                                                
                                                                
                            if {$active == {on}} {
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_HB_XPosition	
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_HB_YPosition	
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_ST_Length		
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_HT_Length		
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_LC_Position_x	
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_LC_Position_y	
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_ST_Angle  		
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_BB_Depth   		
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_CS_Length   	
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_HT_Angle   
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_Stem_Length   	
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_Stem_Angle   	
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_Fork_Rake   	
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_Fork_Height   	
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_RW_Radius   	
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_FW_Radius   	
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_CR_Length   	

                                    $cv_Name bind $_dim_HB_XPosition	<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Personal(HandleBar_Distance) ]
                                    $cv_Name bind $_dim_HB_YPosition	<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Personal(HandleBar_Height) ]
                                    $cv_Name bind $_dim_ST_Length		<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Personal(SeatTube_Length) ]
                                    $cv_Name bind $_dim_HT_Length		<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  {FrameTubes(HeadTube/Length) Component(HeadSet/Height/Bottom)} {Head Tube Parameter} ]
                                    $cv_Name bind $_dim_LC_Position_x	<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Custom(TopTube/PivotPosition) ]
                                    $cv_Name bind $_dim_LC_Position_y	<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Personal(InnerLeg_Length) ]
                                    $cv_Name bind $_dim_ST_Angle  		<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Personal(SeatTube_Angle) ]
                                    $cv_Name bind $_dim_BB_Depth   		<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Custom(BottomBracket/Depth) ]
                                    $cv_Name bind $_dim_CS_Length   	<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Custom(WheelPosition/Rear) ]
                                    $cv_Name bind $_dim_HT_Angle		<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Custom(HeadTube/Angle) ]
                                    $cv_Name bind $_dim_Stem_Length   	<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Component(Stem/Length) ]
                                    $cv_Name bind $_dim_Stem_Angle   	<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Component(Stem/Angle) ]		
                                    $cv_Name bind $_dim_Fork_Rake   	<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Component(Fork/Rake) ]
                                    $cv_Name bind $_dim_Fork_Height   	<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Component(Fork/Height) ]
                                    $cv_Name bind $_dim_RW_Radius   	<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  {list://Component(Wheel/Rear/RimDiameter@SELECT_Rims) Component(Wheel/Rear/TyreHeight)} {Rear Wheel Parameter} ]
                                    $cv_Name bind $_dim_FW_Radius   	<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  {list://Component(Wheel/Front/RimDiameter@SELECT_Rims) Component(Wheel/Front/TyreHeight)} {Front Wheel Parameter} ]
                                    $cv_Name bind $_dim_CR_Length   	<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Component(CrankSet/Length) ]
                                    
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_ST_XPosition   	
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_FW_Distance  	
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_FW_DistanceX   	
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_BB_Height								
                                    lib_gui::object_CursorBinding 	$cv_Name	$_dim_TT_Virtual								

                                    $cv_Name bind $_dim_ST_XPosition	<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Temporary(Saddle/Offset_BB/horizontal) ]
                                    $cv_Name bind $_dim_FW_Distance  	<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Temporary(WheelPosition/front/diagonal) ]
                                    $cv_Name bind $_dim_FW_DistanceX	<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Temporary(WheelPosition/front/horizontal) ]
                                    $cv_Name bind $_dim_BB_Height		<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Temporary(BottomBracket/Height) ]
                                    $cv_Name bind $_dim_TT_Virtual		<Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  Temporary(TopTube/VirtualLength) ]
                                        #
                                        # ... proc fill_resultValues ...
                                        # ... proc set_spec_Parameters ...
                            }
                }
                    # -----------------------
                frameTubing_bg {
                        
                            #$cv_Name create circle  [lindex $HeadTube(vct_Top) 0]	-radius 15  -outline red    -width 1		-tags __CenterLine__
                            #$cv_Name create circle  [lindex $HeadTube(vct_Top) 1] 	-radius 15  -outline blue   -width 1		-tags __CenterLine__                 
                            #$cv_Name create circle  [lindex $HeadTube(vct_Bottom) 0]	-radius 15  -outline green  -width 1		-tags __CenterLine__
                            #$cv_Name create circle  [lindex $HeadTube(vct_Bottom) 1] 	-radius 15  -outline orange -width 1		-tags __CenterLine__                 
                            
                            #$cv_Name create circle  [lindex $SeatTube(vct_Top) 0]	    -radius 15  -outline red    -width 1		-tags __CenterLine__
                            #$cv_Name create circle  [lindex $SeatTube(vct_Top) 1] 	    -radius 15  -outline blue   -width 1		-tags __CenterLine__                 
                        
                        
                        
                        
                                # -- Dimensions ------------------------
                                #
                            set _dim_ST_Length_01	[ $cv_Name dimension  length  	[ project::flatten_nestedList   $SeatTube(vct_Top) $BottomBracket(Position) ] \
                                                                perpendicular     [expr  -100 * $stageScale]	0 \
                                                                gray50 ]
                            set _dim_ST_Length_02	[ $cv_Name dimension  length  	[ project::flatten_nestedList   $BottomBracket(Position)    $TopTube(SeatTube) ] \
                                                                aligned     [expr   75 * $stageScale]	[expr  -100 * $stageScale] \
                                                                gray50 ]
                            set _dim_HT_Reach_X		[ $cv_Name dimension  length  	[ project::flatten_nestedList   $HeadTube(Stem)             $BottomBracket(Position) ] \
                                                                horizontal  [expr -110 * $stageScale]    0 \
                                                                gray50 ] 
                            set _dim_HT_Stack_Y		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$HeadTube(Stem)             $BottomBracket(Position) ] \
                                                                vertical    [expr  110 * $stageScale]    [expr  120 * $stageScale]  \
                                                                gray50 ] 
                                                                
                            set _dim_RearBrake		[ $cv_Name dimension  length  	[ project::flatten_nestedList   $RearWheel(Position)        $RearBrake(Mount) ] \
                                                                aligned     [expr  -85 * $stageScale]    0  \
                                                                gray50 ] 
                                # set _dim_RearBrake 		[ $cv_Name dimension  radius   [ project::flatten_nestedList  $RearWheel(Position)          $RearBrake(Mount)] \
                                                                    20 	[expr  30 * $stageScale] \
                                                                    gray50 ]															
                                                                
                            set _dim_Head_Down_Angle	[ $cv_Name dimension  angle  	[ project::flatten_nestedList [list $DownTube(Steerer) $DownTube(BBracket) $Steerer(Ground)] ] \
                                                                180   0 \
                                                                gray50 ]
                            set _dim_Seat_Top_Angle		[ $cv_Name dimension  angle  	[ project::flatten_nestedList [list $TopTube(SeatTube) $BottomBracket(Position) $TopTube(Steerer)] ] \
                                                                110  10 \
                                                                gray50 ]
                            set _dim_Down_Seat_Angle	[ $cv_Name dimension  angle  	[ project::flatten_nestedList [list $BottomBracket(Position) $DownTube(Steerer) $TopTube(SeatTube) ] ] \
                                                                110   0 \
                                                                gray50 ]
                            set _dim_Seat_CS_Angle		[ $cv_Name dimension  angle  	[ project::flatten_nestedList [list $BottomBracket(Position) $TopTube(SeatTube) $Position(IS_ChainSt_SeatSt)] ] \
                                                                110   0 \
                                                                gray50 ]
                                set pt_01				[ vectormath::addVector	$BottomBracket(Position) {-1 0} ]
                            set _dim_SeatTube_Angle		[ $cv_Name dimension  angle  	[ project::flatten_nestedList [list $BottomBracket(Position) $SeatTube(TopTube) $pt_01] ] \
                                                                150   0 \
                                                                gray50 ]
                                set pt_01				[ vectormath::intersectPoint	$Steerer(Stem)  $Steerer(Fork)		$FrontWheel(Position) [vectormath::addVector	$FrontWheel(Position) {-10 0}] ]
                                set pt_02				[ vectormath::addVector	$pt_01 {-1 0} ]
                            set _dim_HeadTube_Angle		[ $cv_Name dimension  angle  	[ project::flatten_nestedList [list $pt_02 $Steerer(Stem) [vectormath::addVector	$pt_02 {-10 0}]] ] \
                                                                110   0 \
                                                                gray50 ]
                        }
                    # -----------------------
                summary_bg {
                            
                            set help_01				[ list [lindex $BottomBracket(Position) 0] [lindex $LegClearance(Position) 1] ]

                            set _dim_ST_YPosition	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $BottomBracket(Position) $Saddle(Position) ] \
                                                                vertical	[expr -580 * $stageScale]  [expr -130 * $stageScale]  \
                                                                gray50 ] 
                            set _dim_SD_Height		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $Position(BaseCenter)  $Saddle(Position) ] \
                                                                vertical    [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
                                                                gray50 ] 
                            set _dim_HB_Height		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $HandleBar(Position) $Position(BaseCenter) ] \
                                                                vertical    [expr -350 * $stageScale]  [expr  230 * $stageScale]  \
                                                                gray50 ] 
                            set _dim_SD_HB_Height	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $HandleBar(Position) $Saddle(Position) ] \
                                                                vertical	[expr  350 * $stageScale]  [expr -100 * $stageScale]  \
                                                                gray50 ] 
                        }
                    # -----------------------
                summary_fg {

                            set help_00				[ vectormath::addVector $SeatTube(Ground) {-200 0} ]
                            set help_rw				[ vectormath::rotateLine $RearWheel(Position) 	$RearWheel(Radius) 	230 ]
                            set help_fw				[ vectormath::rotateLine $FrontWheel(Position) 	$FrontWheel(Radius) 	-50 ]
                            set help_fk				[ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]

                            
                            set _dim_ST_XPosition	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $Saddle(Position) $BottomBracket(Position) ] \
                                                                horizontal	[expr  -80 * $stageScale]    0 \
                                                                darkblue ] 
                            set _dim_ST_Length 		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $BottomBracket(Position) $Saddle(Position) ] \
                                                                aligned		[expr -150 * $stageScale]   [expr -210 * $stageScale]  \
                                                                darkblue ] 
                            set _dim_BB_Height 		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $BottomBracket(Position)	$Position(BaseCenter)] \
                                                                vertical    [expr  200 * $stageScale]   [expr    30 * $stageScale]  \
                                                                darkred ] 

                            set _dim_BB_Depth  		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$RearWheel(Position) $BottomBracket(Position) ] \
                                                                                    vertical    [expr 100 * $stageScale]   [expr 80 * $stageScale] \
                                                                                    gray50 ] 
                            set _dim_RW_Radius 		[ $cv_Name dimension  radius   [ project::flatten_nestedList  $RearWheel(Position)  $help_rw] \
                                                                                    0 	[expr  30 * $stageScale] \
                                                                                    gray50 ]
                            set _dim_FW_Radius 		[ $cv_Name dimension  radius   [ project::flatten_nestedList  $FrontWheel(Position) $help_fw] \
                                                                                    0 	[expr  30 * $stageScale] \
                                                                                    gray50 ]
                            set _dim_Fork_Rake		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$Steerer(Stem)  $help_fk $FrontWheel(Position) ] \
                                                                                    perpendicular [expr 30 * $stageScale]    [expr   80 * $stageScale] \
                                                                                    gray50 ] 																
                            set _dim_CS_LengthX 	[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$RearWheel(Ground)  $Position(BaseCenter) ] \
                                                                                    horizontal  [expr   70 * $stageScale]   0 \
                                                                                    gray50 ] 
                            set _dim_FW_DistanceX	[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$Position(BaseCenter)  $FrontWheel(Ground) ] \
                                                                                    horizontal  [expr   70 * $stageScale]   0 \
                                                                                    gray50 ] 
                            set _dim_Wh_Distance	[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$RearWheel(Ground)  $FrontWheel(Ground) ] \
                                                                                    horizontal  [expr  130 * $stageScale]	0 \
                                                                                    gray50 ] 
                            set _dim_FW_Lag			[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$FrontWheel(Ground)  $Steerer(Ground) ] \
                                                                                    horizontal  [expr   70 * $stageScale]   [expr  -70 * $stageScale] \
                                                                                    gray50 ] 
                            set _dim_FW_Distance	[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$BottomBracket(Position)  $FrontWheel(Position)] \
                                                                                    aligned     [expr  150 * $stageScale]   [expr  -90 * $stageScale] \
                                                                                    gray50 ] 
                            set _dim_CS_Length 		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$RearWheel(Position)  $BottomBracket(Position)] \
                                                                aligned     [expr  150 * $stageScale]   [expr   80 * $stageScale] \
                                                                gray50 ] 
                            
                            set _dim_HT_Angle  		[ $cv_Name dimension  angle   	[ project::flatten_nestedList  	$Steerer(Ground)  $Steerer(Fork)  $Position(BaseCenter) ] \
                                                                120   0  \
                                                                darkred ]
                            set _dim_ST_Angle  		[ $cv_Name dimension  angle   	[ project::flatten_nestedList  $SeatTube(Ground)	$Saddle(Position) $help_00 ] \
                                                                120   0  \
                                                                darkred ]

                            set _dim_HB_XPosition	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $HandleBar(Position)		$BottomBracket(Position) ] \
                                                                horizontal  [expr   (80 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                                                                darkred ] 
                            set _dim_HB_YPosition	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $HandleBar(Position)		$BottomBracket(Position) ] \
                                                                vertical    [expr -270 * $stageScale]    [expr  180 * $stageScale]  \
                                                                darkred ] 
                            set _dim_HT_Reach		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$HeadTube(Stem)	$BottomBracket(Position) ] \
                                                                horizontal  [expr   (20 + $Length(Height_HT_Seat)) * $stageScale ]    0 \
                                                                darkblue ] 
                            set _dim_HT_Stack		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$HeadTube(Stem)	$BottomBracket(Position) ] \
                                                                vertical    [expr -280 * $stageScale]    [expr  170 * $stageScale]  \
                                                                darkblue ] 
                            set _dim_LC_Position_x	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $LegClearance(Position)  $BottomBracket(Position) ] \
                                                                horizontal  [expr   40 * $stageScale]   0  \
                                                                darkblue ] 
                            set _dim_LC_Position_y	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $LegClearance(Position)  $Position(BaseCenter) ] \
                                                                vertical    [expr -130 * $stageScale]   [expr   250 * $stageScale]  \
                                                                darkblue ] 

                            proc dim_LegClearance {cv_Name BB_Position stageScale} {
                                        set pt_01 					[ vectormath::addVector		$frame_geometry::LegClearance(Position)		$BB_Position  ]
                                        set TopTube(polygon) 		[ frame_geometry::object_values TopTube polygon		$BB_Position  ]
                                        set pt_09					[ frame_geometry::coords_get_xy $TopTube(polygon)  9 ]
                                        set pt_10					[ frame_geometry::coords_get_xy $TopTube(polygon) 10 ]
                                        set pt_is					[ vectormath::intersectPerp $pt_09 $pt_10 $pt_01 ]
                                        set dimension 		[ $cv_Name dimension  length  	[ project::flatten_nestedList [list $pt_01 $pt_is] ] \
                                                                    aligned    [expr -60 * $stageScale]  [expr 50 * $stageScale] \
                                                                    darkred ]																				
                                    }
                            dim_LegClearance  $cv_Name $BottomBracket(Position) $stageScale

                            proc dim_RearWheel_Clearance {cv_Name BB_Position WheelRadius stageScale} {
                                        set pt_03 					[ frame_geometry::object_values 	RearWheel	position	$BB_Position  ]
                                        set SeatTube(polygon) 		[ frame_geometry::object_values 	SeatTube 	polygon	$BB_Position  ]
                                        set pt_06					[ frame_geometry::coords_get_xy $SeatTube(polygon) 6 ]
                                        set pt_07					[ frame_geometry::coords_get_xy $SeatTube(polygon) 7 ]						
                                        set pt_is					[ vectormath::intersectPerp $pt_06 $pt_07 $pt_03 ]
                                        set pt_rw					[ vectormath::addVector $pt_03 [ vectormath::unifyVector  $pt_03  $pt_is  $WheelRadius ] ]	
                                        set dimension 		[ $cv_Name dimension  length  	[ project::flatten_nestedList [list $pt_rw $pt_is] ] \
                                                                                                aligned    [expr -70 * $stageScale]  [expr 115 * $stageScale] \
                                                                                                gray50 ]																				
                                    }
                            dim_RearWheel_Clearance  $cv_Name $BottomBracket(Position) $RearWheel(Radius) $stageScale						

                        }
                    # -----------------------
                frameDrafting_bg {
                            
                            #$cv_Name create circle  [lindex $HeadTube(vct_Top) 0]	-radius 15  -outline red    -width 1		-tags __CenterLine__
                            #$cv_Name create circle  [lindex $HeadTube(vct_Top) 1] 	-radius 15  -outline blue   -width 1		-tags __CenterLine__                 
                            #$cv_Name create circle  [lindex $HeadTube(vct_Bottom) 0]	-radius 15  -outline green  -width 1		-tags __CenterLine__
                            #$cv_Name create circle  [lindex $HeadTube(vct_Bottom) 1] 	-radius 15  -outline orange -width 1		-tags __CenterLine__                 
                            
                            #$cv_Name create circle  [lindex $SeatTube(vct_Top) 0]	    -radius 15  -outline red    -width 1		-tags __CenterLine__
                            #$cv_Name create circle  [lindex $SeatTube(vct_Top) 1] 	    -radius 15  -outline blue   -width 1		-tags __CenterLine__                 
                                                                                    
                                                                
                                set help_fk				[ vectormath::addVector   	$Steerer(Fork) 	[ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
                                set help_rw_rim			[ vectormath::rotateLine 	$RearWheel(Position) 		[expr 0.5 * $RearWheel(RimDiameter) ] 70 ]
                                set help_tt_c1			[ vectormath::rotateLine 	$RearWheel(Position) 		[expr 0.5 * $RearWheel(RimDiameter) ] 70 ]
                        
                                # -- Dimensions ------------------------
                                #
                            set _dim_CS_Length 			[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$RearWheel(Position)  $BottomBracket(Position)] \
                                                                                        aligned     [expr   70 * $stageScale]   [expr   80 * $stageScale] \
                                                                                        darkblue ] 
                            set _dim_CS_LengthX 		[ $cv_Name dimension  length  	[ project::flatten_nestedList		$BottomBracket(Position)  $RearWheel(Position) ] \
                                                                                        horizontal  [expr -110 * $stageScale]   0 \
                                                                                        gray30 ] 
                            set _dim_BB_Depth 			[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$RearWheel(Position)  $BottomBracket(Position)] \
                                                                                        vertical	[expr  -160 * $stageScale]   [expr   80 * $stageScale] \
                                                                                        gray30 ] 
                            set _dim_FW_Distance		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$BottomBracket(Position)  $FrontWheel(Position)] \
                                                                                        aligned     [expr   70 * $stageScale]   [expr  -90 * $stageScale] \
                                                                                        gray30 ] 
                            set _dim_FW_DistanceX		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$BottomBracket(Position)  $FrontWheel(Position) ] \
                                                                                        horizontal  [expr  110 * $stageScale]   0 \
                                                                                        gray30 ] 
                            set _dim_Wh_Distance		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$RearWheel(Position)  $FrontWheel(Position) ] \
                                                                                        horizontal  [expr  (150 + $BottomBracket(depth)) * $stageScale]	0 \
                                                                                        gray30 ]
                            set _dim_ST_Length_01       [ $cv_Name dimension  length    [ project::flatten_nestedList   [lindex $SeatTube(vct_Top) 1]  [lindex $SeatTube(vct_Top) 0]  $BottomBracket(Position) ] \
                                                                                        perpendicular     [expr   145 * $stageScale]	0 \
                                                                                        darkblue ]
                            set _dim_ST_Length_02		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$BottomBracket(Position)  $TopTube(SeatTube) ] \
                                                                                        aligned  	[expr  -120 * $stageScale]	0 \
                                                                                        gray30 ]
                            set _dim_TT_Length			[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$TopTube(SeatTube) $TopTube(Steerer) ] \
                                                                                        aligned  	[expr  -180 * $stageScale]	0 \
                                                                                        darkblue ]
                            set _dim_DT_Length			[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$BottomBracket(Position)  $DownTube(Steerer) ] \
                                                                                        aligned  	[expr   120 * $stageScale]	0 \
                                                                                        darkblue ]
                            set _dim_SS_Length			[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$RearWheel(Position)  $SeatStay(SeatTube) ] \
                                                                                        aligned  	[expr  -160 * $stageScale]	0 \
                                                                                        darkblue ]
                            set _dim_SS_ST_Offset       [ $cv_Name dimension  length    [ project::flatten_nestedList   [lindex $SeatTube(vct_Top) 1]  [lindex $SeatTube(vct_Top) 0]  $SeatStay(SeatTube) ] \
                                                                                        perpendicular     [expr   45 * $stageScale]	[expr   65 * $stageScale] \
                                                                                        darkblue ]
                            if { $RearDrop(OffsetSSPerp) != 0 } {
                                    set _dim_SS_DO_Offset	\
                                                        [ $cv_Name dimension  length  	[ project::flatten_nestedList  	$SeatStay(SeatTube) $Position(IS_ChainSt_SeatSt) $RearWheel(Position)] \
                                                                                        perpendicular [expr -75 * $stageScale]	[expr  -35 * $stageScale] \
                                                                                        gray30 ]
                                }
                            if { $RearDrop(OffsetCSPerp) != 0 } {
                                    set _dim_CS_DO_Offset	\
                                                        [ $cv_Name dimension  length  	[ project::flatten_nestedList  	$BottomBracket(Position) $Position(IS_ChainSt_SeatSt) $RearWheel(Position)] \
                                                                                        perpendicular [expr -95 * $stageScale]	[expr   35 * $stageScale] \
                                                                                        gray30 ]
                                }
                            set _dim_TT_Offset			[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$HeadTube(vct_Top)  $TopTube(Steerer)  ] \
                                                                                        perpendicular  	[expr    (-70 + 0.5 * $HeadTube(Diameter)) * $stageScale]	[expr  -35 * $stageScale] \
                                                                                        darkblue ]
                            set _dim_DT_Offset			[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$HeadTube(vct_Bottom)  $DownTube(Steerer) ] \
                                                                                        perpendicular  	[expr    (70 - 0.5 * $HeadTube(Diameter))* $stageScale]	[expr    0 * $stageScale] \
                                                                                        darkblue ]
                                                                                        
                                # -- HT Stack & Reach ------------------
                                #
                            set _dim_HT_Reach_X		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$HeadTube(Stem)  $BottomBracket(Position) ] \
                                                                                        horizontal  [expr  -90 * $stageScale ]    0 \
                                                                                        gray50 ] 
                            set _dim_HT_Stack_Y		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$HeadTube(Stem)		$BottomBracket(Position) ] \
                                                                                        vertical    [expr  110 * $stageScale]    [expr  120 * $stageScale]  \
                                                                                        gray50 ] 

                                # -- Fork Details ----------------------
                                #
                            if {$Fork(Rake) != 0} {
                                set _dim_Fork_Rake		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$Steerer(Stem)  $help_fk $FrontWheel(Position) ] \
                                                                                        perpendicular [expr  50 * $stageScale]    [expr  -80 * $stageScale] \
                                                                                        gray30 ] 																
                            } else {
                            }
                            set _dim_Fork_Height	[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$Steerer(vct_Bottom) $FrontWheel(Position)  ] \
                                                                                        perpendicular 	[expr  (-150 + 0.5 * $Steerer(Diameter))  * $stageScale]    [expr  80 * $stageScale] \
                                                                                        gray30 ] 
                            
                            
                                # -- Steerer Details ----------------------
                                set pt_01 				[ frame_geometry::object_values 		Steerer/Start	position	$BB_Position  ]
                                set pt_02 				[ frame_geometry::object_values 		Steerer/End		position	$BB_Position  ]
                            set _dim_STR_Length			[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$Steerer(vct_Bottom)  $Steerer(End) ] \
                                                                                        perpendicular  	[expr    (190 - 0.5 * $Steerer(Diameter)) * $stageScale]	[expr   5 * $stageScale] \
                                                                                        gray30 ]


                                # -- Centerline Angles -----------------
                                #
                            set _dim_Head_Top_Angle		[ $cv_Name dimension  angle  	[ project::flatten_nestedList [list $TopTube(Steerer) $Steerer(Stem) $TopTube(SeatTube)] ] \
                                                                                        130   0 \
                                                                                        darkred ]
                            set _dim_Head_Down_Angle	[ $cv_Name dimension  angle  	[ project::flatten_nestedList [list $DownTube(Steerer) $DownTube(BBracket) $Steerer(Ground)] ] \
                                                                                        170 -10 \
                                                                                        darkred ]
                            set _dim_Seat_Top_Angle		[ $cv_Name dimension  angle  	[ project::flatten_nestedList [list $TopTube(SeatTube) $BottomBracket(Position) $TopTube(Steerer)] ] \
                                                                                        150   0 \
                                                                                        darkred ]
                            set _dim_Down_Seat_Angle	[ $cv_Name dimension  angle  	[ project::flatten_nestedList [list $BottomBracket(Position) $DownTube(Steerer) $TopTube(SeatTube) ] ] \
                                                                                         90   0 \
                                                                                        darkred ]
                            set _dim_Seat_CS_Angle		[ $cv_Name dimension  angle  	[ project::flatten_nestedList [list $BottomBracket(Position) $TopTube(SeatTube) $Position(IS_ChainSt_SeatSt)] ] \
                                                                                         90   0 \
                                                                                        darkred ]
                            set _dim_SS_CS_Angle		[ $cv_Name dimension  angle  	[ project::flatten_nestedList [list $Position(IS_ChainSt_SeatSt) $BottomBracket(Position) $SeatStay(SeatTube)] ] \
                                                                                         90   0 \
                                                                                        darkred ]
                                set pt_01				[ vectormath::addVector	$BottomBracket(Position) {-1 0} ]
                            set _dim_SeatTube_Angle		[ $cv_Name dimension  angle  	[ project::flatten_nestedList [list $BottomBracket(Position) $SeatTube(TopTube) $pt_01] ] \
                                                                                        130   0 \
                                                                                        darkred ]
                                set pt_01				[ vectormath::intersectPoint	$Steerer(Stem)  $Steerer(Fork)		$FrontWheel(Position) [vectormath::addVector	$FrontWheel(Position) {-10 0}] ]
                                set pt_02				[ vectormath::addVector	$pt_01 {-1 0} ]
                            set _dim_HeadTube_Angle		[ $cv_Name dimension  angle  	[ project::flatten_nestedList [list $pt_02 $Steerer(Stem) [vectormath::addVector	$pt_02 {-10 0}]] ] \
                                                                                         90   0 \
                                                                                        darkred ]


                                                                                        
                                # -- Rear Brake Mount ------------------
                            if {$Rendering(BrakeRear) != {off}} {
                                switch $Rendering(BrakeRear) {
                                    Rim {	
                                                set SeatStay(polygon) 		[ frame_geometry::object_values 		SeatStay polygon $BB_Position  ]
                                                set pt_01					[ frame_geometry::coords_get_xy 	$SeatStay(polygon)  8 ]
                                                set pt_02					[ frame_geometry::coords_get_xy 	$SeatStay(polygon)  9 ]
                                                set pt_03 					[ vectormath::addVector	$frame_geometry::RearBrake(Shoe)	$BB_Position  ]
                                                set pt_04 					[ vectormath::addVector	$frame_geometry::RearBrake(Help)	$BB_Position  ]
                                                set pt_10 					[ vectormath::intersectPerp 		$pt_01 $pt_02 $pt_04  ]
                                            set _dim_Brake_Offset_01	[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$pt_10 $pt_04 ] \
                                                                                                        aligned  	[expr   40 * $stageScale]	[expr  55 * $stageScale] \
                                                                                                        gray30 ]
                                            set _dim_Brake_Offset_02	[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$pt_03  $pt_04 ] \
                                                                                                        aligned  	[expr   -50 * $stageScale]	[expr   65 * $stageScale] \
                                                                                                        gray30 ]
                                            set _dim_Brake_Distance		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$RearWheel(Position)  $RearBrake(Mount) ] \
                                                                                                        aligned  	[expr  -120 * $stageScale]	0 \
                                                                                                        gray30 ]						
                                            # set _dim_RW_RimRadius 		[ $cv_Name dimension  radius	[ project::flatten_nestedList  $RearWheel(Position)	$help_rw_rim] \
                                                                                                        0	[expr   30 * $stageScale] \
                                                                                                        gray30 ] 
                                        }
                                }
                            }

                            
                            
                                # -- Bottle Cage Mount ------------------
                            if {$Rendering(BottleCage_ST) != {off}} {
                                            set st_direction			[ frame_geometry::object_values SeatTube 	direction ]
                                            set pt_01 					[ frame_geometry::object_values	SeatTube/BottleCage/Offset	position	$BB_Position]
                                            set pt_02 					[ frame_geometry::object_values	SeatTube/BottleCage/Base	position	$BB_Position]
                                            set pt_03					[ vectormath::addVector	$pt_02	$st_direction	[expr -1.0 * $frame_geometry::BottleCage(SeatTube)] ] 
                                            
                                            set dimension		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$pt_01  $pt_02 ] \
                                                                                                    aligned 	[expr  90 * $stageScale]	[expr    0 * $stageScale] \
                                                                                                    gray50 ] 																
                                            set dimension		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$pt_02  $pt_03 ] \
                                                                                                    aligned		[expr  90 * $stageScale]	[expr -115 * $stageScale] \
                                                                                                    gray50 ]										
                            }
                            
                            if {$Rendering(BottleCage_DT) != {off}} {
                                            set dt_direction			[ frame_geometry::object_values DownTube 	direction ]
                                            set pt_01 					[ frame_geometry::object_values	DownTube/BottleCage/Offset	position	$BB_Position]
                                            set pt_02 					[ frame_geometry::object_values	DownTube/BottleCage/Base	position	$BB_Position]
                                            set pt_03					[ vectormath::addVector	$pt_02	$dt_direction	[expr -1.0 * $frame_geometry::BottleCage(DownTube)] ] 

                                            if { $Rendering(BottleCage_DT_L) != {off}} { set addDist 40 } else { set addDist 0}
                                            
                                            set dimension		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$pt_01  $pt_02 ] \
                                                                                                    aligned		[expr -1.0 * (180 + $addDist) * $stageScale]	0 \
                                                                                                    gray50 ]
                                            set dimension		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$pt_02  $pt_03 ] \
                                                                                                    aligned 	[expr -1.0 * (180 + $addDist) * $stageScale]	[expr  15 * $stageScale] \
                                                                                                    darkblue ] 																
                            }
                            
                            if {$Rendering(BottleCage_DT_L) != {off}} {
                                            set dt_direction			[ frame_geometry::object_values DownTube 	direction ]
                                            set pt_01 					[ frame_geometry::object_values	DownTube/BottleCage_Lower/Offset	position	$BB_Position ]
                                            set pt_02 					[ frame_geometry::object_values	DownTube/BottleCage_Lower/Base		position	$BB_Position ]
                                            set pt_03					[ vectormath::addVector	$pt_02	$dt_direction	[expr -1.0 * $frame_geometry::BottleCage(DownTube_Lower) ] ] 

                                            set dimension		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$pt_01  $pt_02 ] \
                                                                                                    aligned		[expr -145 * $stageScale]	0 \
                                                                                                    gray50 ]
                                            set dimension		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$pt_02  $pt_03 ] \
                                                                                                    aligned 	[expr -145 * $stageScale]	[expr  15 * $stageScale] \
                                                                                                    darkblue ] 																
                            }



                                # -- Cutting Length --------------------
                                #
                                set TopTube(polygon) 	[ frame_geometry::object_values TopTube polygon $BB_Position  ]
                                set pt_01				[ frame_geometry::coords_get_xy $TopTube(polygon)  8 ]
                                set pt_02				[ frame_geometry::coords_get_xy $TopTube(polygon) 11 ]
                                set pt_03				[ frame_geometry::coords_get_xy $TopTube(polygon) 3 ]
                            set _dim_TopTube_CutLength 	[ $cv_Name dimension  length  	[ project::flatten_nestedList [list $pt_01 $pt_02] ] \
                                                                                        aligned    [expr 110 * $stageScale] [expr 10 * $stageScale] \
                                                                                        darkviolet ]
                                set DownTube(polygon) 	[ frame_geometry::object_values DownTube polygon $BB_Position  ]
                                set pt_01				[ frame_geometry::coords_get_xy $DownTube(polygon)  3 ]
                            set _dim_DownTube_CutLength [ $cv_Name dimension  length  	[ project::flatten_nestedList [list $BB_Position $pt_01] ] \
                                                                                        aligned    [expr  70 * $stageScale] [expr 10 * $stageScale] \
                                                                                        darkviolet ]

                                                                                        
                                                                                        
                                # -- Tubing Details --------------------
                                #
                                set HeadTube(polygon) 	[ frame_geometry::object_values HeadTube polygon $BB_Position  ]
                                set pt_01				[ frame_geometry::coords_get_xy $HeadTube(polygon) 0 ]
                                set pt_02				[ frame_geometry::coords_get_xy $HeadTube(polygon) 1 ]
                            set _dim_HeadTube_Length 	[ $cv_Name dimension  length  	[ project::flatten_nestedList [list $pt_01 $pt_02] ] \
                                                                                        aligned    [expr 90 * $stageScale]   0 \
                                                                                        darkblue ]																				

                                set HeadTube(polygon) 	[ frame_geometry::object_values HeadTube polygon $BB_Position  ]
                                set pt_01				[ frame_geometry::coords_get_xy $HeadTube(polygon) 2 ]
                                set TopTube(polygon) 	[ frame_geometry::object_values TopTube polygon $BB_Position  ]
                                set pt_02				[ frame_geometry::coords_get_xy $TopTube(polygon) 8 ]
                            set _dim_HeadTube_OffsetTT 	[ $cv_Name dimension  length  	[ project::flatten_nestedList [list $pt_01 $pt_02] ] \
                                                                                        aligned    [expr 50 * $stageScale] [expr 50 * $stageScale] \
                                                                                        gray30 ]

                                set HeadTube(polygon) 	[ frame_geometry::object_values HeadTube polygon $BB_Position  ]
                                set pt_01				[ frame_geometry::coords_get_xy $HeadTube(polygon) 3 ]
                                set DownTube(polygon) 	[ frame_geometry::object_values DownTube polygon $BB_Position  ]
                                set pt_02				[ frame_geometry::coords_get_xy $DownTube(polygon) 3 ]
                            set _dim_HeadTube_OffsetDT 	[ $cv_Name dimension  length  	[ project::flatten_nestedList [list $pt_01 $pt_02] ] \
                                                                                        aligned    [expr -50 * $stageScale] [expr 50 * $stageScale] \
                                                                                        gray30 ]

                                set TopTube(polygon) 	[ frame_geometry::object_values TopTube polygon $BB_Position  ]
                                set pt_01				[ frame_geometry::coords_get_xy $TopTube(polygon) 11 ]
                                set SeatTube(polygon) 	[ frame_geometry::object_values SeatTube polygon $BB_Position  ]
                                set pt_02				[ frame_geometry::coords_get_xy $SeatTube(polygon) 3 ]
                            set _dim_SeatTube_Extension [ $cv_Name dimension  length  	[ project::flatten_nestedList [list $pt_01 $pt_02] ] \
                                                                                        aligned    [expr 65 * $stageScale] [expr -50 * $stageScale] \
                                                                                        gray30 ]

                                set pt_01 				[ frame_geometry::object_values TopTube/Start	position $BB_Position  ]
                                set pt_02 				[ frame_geometry::object_values SeatStay/End	position $BB_Position  ]
                                if { [lindex $pt_02 1] < [lindex $pt_01 1] } {
                                        set dim_coords	[ project::flatten_nestedList [list $pt_01 $pt_02] ]
                                } else {
                                        set dim_coords	[ project::flatten_nestedList [list $pt_02 $pt_01] ]
                                }
                            set _dim_SeatStay_Offset 	[ $cv_Name dimension  length  	$dim_coords  \
                                                                                        aligned    [expr -60 * $stageScale]   [expr -50 * $stageScale] \
                                                                                        gray30 ]	
                                                                                        
                            if { $DownTube(OffsetBB) != 0 } {
                                    set pt_01 			[ frame_geometry::object_values	DownTube/End	position 	$BB_Position  ]
                                    set pt_02 			[ frame_geometry::object_values	DownTube/Start	position 	$BB_Position  ]
                                    set pt_03 					$BB_Position 
                                    if { [lindex $pt_02 1] >= [lindex $pt_03 1] } {
                                            set dim_distance	[expr -50 * $stageScale]
                                            set dim_offset		[expr -50 * $stageScale]
                                    } else {
                                            set dim_distance	[expr  50 * $stageScale]
                                            set dim_offset		[expr  50 * $stageScale]
                                    }
                                set _dim_DownTube_Offset 	[ $cv_Name dimension  length  	[ project::flatten_nestedList [list $pt_01 $pt_02 $pt_03] ] \
                                                                                            {perpendicular}    $dim_distance $dim_offset \
                                                                                            gray30 ]
                            }
                                                                                    
                                set pt_01 				[ frame_geometry::object_values 		TopTube/End		position 	$BB_Position  ]
                                set pt_hlp 				[ frame_geometry::object_values 		TopTube/Start	position 	$BB_Position  ]
                                set pt_cnt 				[ vectormath::center 	$pt_01  $pt_hlp]
                                set pt_02 				[ list [expr [lindex $pt_cnt 0] + 2] [lindex $pt_cnt 1]  ]
                            set _dim_TopTube_Angle 		[ $cv_Name dimension  angle  	[ project::flatten_nestedList [list $pt_cnt $pt_02 $pt_01] ] \
                                                                                        100   -30 \
                                                                                        darkred ]
                                                                                    
                                set pt_01 				[ frame_geometry::object_values 		HeadTube/Start	position	$BB_Position  ]
                                set pt_02 				[ frame_geometry::object_values 		Steerer/Start	position	$BB_Position  ]
                            set _dim_HeadSet_Bottom 	[ $cv_Name dimension  length  	[ project::flatten_nestedList $Steerer(vct_Bottom) [lindex $HeadTube(vct_Bottom) 1] ] \
                                                                                        perpendicular    [expr (150 - 0.5 * $Steerer(Diameter)) * $stageScale]   [expr -50 * $stageScale] \
                                                                                        gray30 ]	

                                set RimDiameter			$project::Component(Wheel/Rear/RimDiameter)
                                set TyreHeight			$project::Component(Wheel/Rear/TyreHeight)
                                set WheelRadius			[ expr 0.5 * $RimDiameter + $TyreHeight ]
                                set pt_03 				[ frame_geometry::object_values 	RearWheel	position	$BB_Position  ]
                                set SeatTube(polygon) 	[ frame_geometry::object_values 	SeatTube 	polygon	$BB_Position  ]
                                set pt_06				[ frame_geometry::coords_get_xy $SeatTube(polygon) 6 ]
                                set pt_07				[ frame_geometry::coords_get_xy $SeatTube(polygon) 7 ]						
                                set pt_is				[ vectormath::intersectPerp $pt_06 $pt_07 $pt_03 ]
                                set pt_rw				[ vectormath::addVector $pt_03 [ vectormath::unifyVector  $pt_03  $pt_is  $WheelRadius ] ]	
                            set _dim_RearWheel_Clear 	[ $cv_Name dimension  length  	[ project::flatten_nestedList [list $pt_rw $pt_is] ] \
                                                                                        aligned    [expr -100 * $stageScale]  [expr -80 * $stageScale] \
                                                                                        gray50 ]	
                                                                                    

                                set pt_01 				[ vectormath::addVector		$frame_geometry::LegClearance(Position)		$BB_Position  ]
                                set TopTube(polygon) 	[ frame_geometry::object_values TopTube polygon		$BB_Position  ]
                                set pt_09				[ frame_geometry::coords_get_xy $TopTube(polygon)  9 ]
                                set pt_10				[ frame_geometry::coords_get_xy $TopTube(polygon) 10 ]
                                set pt_is				[ vectormath::intersectPerp $pt_09 $pt_10 $pt_01 ]
                            set _dim_LegClearance 		[ $cv_Name dimension  length  	[ project::flatten_nestedList [list $pt_01 $pt_is] ] \
                                                                                        aligned    [expr -30 * $stageScale]  [expr 50 * $stageScale] \
                                                                                        gray50 ]																				
                        
                        
                        }
                    # -----------------------
                frameJig_bg {
                            
                                set help_fk			[ vectormath::intersectPoint   	$Steerer(Fork) 	$Steerer(Stem)   $FrontWheel(Position) $RearWheel(Position) ]
                        
                                # -- Dimensions ------------------------
                                #
                            set _dim_Jig_length		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $RearWheel(Position)  $FrameJig(HeadTube)] \
                                                                                        aligned     [expr  -110 * $stageScale]   0 \
                                                                                        darkblue ] 
                            set _dim_CS_LengthJig	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $RearWheel(Position)  $FrameJig(SeatTube)] \
                                                                                        aligned     [expr   -60 * $stageScale]   0 \
                                                                                        darkblue ] 
                            set _dim_CS_Length		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $RearWheel(Position)  $BottomBracket(Position)] \
                                                                                        aligned     [expr    80 * $stageScale]   0 \
                                                                                        gray30 ] 
                            set _dim_CS_LengthHor	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $BottomBracket(Position) $RearWheel(Position)  ] \
                                                                                        horizontal  [expr  -100 * $stageScale]   0 \
                                                                                        gray30 ] 
                            set _dim_BB_DepthJIg	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $BottomBracket(Position)  $FrameJig(SeatTube)] \
                                                                                        aligned     [expr    60 * $stageScale]   0 \
                                                                                        darkblue ] 
                            set _dim_BB_Depth  		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$BottomBracket(Position)  $RearWheel(Position) ] \
                                                                                        vertical    [expr -160 * $stageScale]   [expr -70 * $stageScale]  \
                                                                                        gray30 ] 
                            set _dim_HT_Offset 		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $FrameJig(HeadTube)	$HeadTube(Fork)] \
                                                                                        aligned     [expr   100 * $stageScale]   0 \
                                                                                        darkblue ] 
                            set _dim_HT_Dist_x 		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $BottomBracket(Position)	$HeadTube(Fork)] \
                                                                                        horizontal  [expr   100 * $stageScale]   0 \
                                                                                        gray30 ] 
                            set _dim_HT_Dist_y 		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $BottomBracket(Position)	$HeadTube(Fork)] \
                                                                                        vertical    [expr   320 * $stageScale]   0 \
                                                                                        gray30 ] 
                            set _dim_WH_Distance	[ $cv_Name dimension  length  	[ project::flatten_nestedList  $RearWheel(Position)	$help_fk] \
                                                                                        aligned     [expr   220 * $stageScale]   0 \
                                                                                        gray30 ] 
                            set _dim_ST_Angle  		[ $cv_Name dimension  angle   	[ project::flatten_nestedList  $FrameJig(SeatTube)	$FrameJig(HeadTube) $Saddle(Position) ] \
                                                                 90   0  \
                                                                darkred ]
                                # -- Fork Details ----------------------
                                #
                            set _dim_HT_Fork		[ $cv_Name dimension  length  	[ project::flatten_nestedList  $FrameJig(HeadTube)	$help_fk] \
                                                                                        aligned     [expr  -100 * $stageScale]   0 \
                                                                                        darkblue ] 
                            set _dim_Fork_Height	[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$help_fk $HeadTube(Fork)  ] \
                                                                                        aligned 	[expr   150 * $stageScale]   0 \
                                                                                        gray30 ] 
                        }
                    # -----------------------
                default {
                        }
            }
        
	} 


	proc createDimensionType {cv_Name BB_Position type {updateCommand {}}} {
			
            variable    stageScale
            
            variable    Rendering       
                    
            variable    BottomBracket   
            variable    DownTube        
            variable    Fork            
            variable    FrameJig        
            variable    FrontBrake      
            variable    FrontWheel      
            variable    HandleBar       
            variable    HeadSet        
            variable    HeadTube        
            variable    LegClearance    
            variable    RearBrake       
            variable    RearDrop        
            variable    RearWheel       
            variable    Saddle          
            variable    SeatStay        
            variable    SeatTube        
            variable    Steerer         
            variable    Stem            
            variable    TopTube         
            
            variable    Position        
            variable    Length          
            variable    Vector          
        
        		
            switch $type {
                HeadTube_Length {
                            set dimension 		[ $cv_Name dimension  length  	[ project::flatten_nestedList [lindex $HeadTube(vct_Top) 1] [lindex $HeadTube(vct_Bottom) 1] ] \
                                                                                    aligned    [expr  (-110 + 0.5 * $HeadTube(Diameter)) * $stageScale]   0 \
                                                                                    darkred ]																				
                            if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
                                                                            [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                                                    {FrameTubes(HeadTube/Length)	\
                                                                                    }	{HeadTube Length}]
                                                        lib_gui::object_CursorBinding 	$cv_Name	$dimension
                                    }
                            }
                HeadTube_OffsetTT {
                            set pt_01					[ frame_geometry::coords_get_xy $HeadTube(polygon) 2 ]
                            set pt_02					[ frame_geometry::coords_get_xy $TopTube(polygon) 8 ]
                            set dimension 		[ $cv_Name dimension  length  	[ project::flatten_nestedList [list $pt_01 $pt_02] ] \
                                                                                    aligned    [expr 70 * $stageScale] [expr 50 * $stageScale] \
                                                                                    darkred ]																				
                            if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
                                                                            [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                                                    {Custom(TopTube/OffsetHT)	\
                                                                                    }	{HeadTube TopTube Offset}]
                                                        lib_gui::object_CursorBinding 	$cv_Name	$dimension
                                    }						
                            }
                HeadTube_OffsetDT {
                            set pt_01					[ frame_geometry::coords_get_xy $HeadTube(polygon) 3 ]
                            set pt_02					[ frame_geometry::coords_get_xy $DownTube(polygon) 3 ]
                            set dimension 		[ $cv_Name dimension  length  	[ project::flatten_nestedList [list $pt_01 $pt_02] ] \
                                                                                    aligned    [expr -70 * $stageScale] [expr 50 * $stageScale] \
                                                                                    darkred ]																				
                            if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
                                                                            [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                                                        {Custom(DownTube/OffsetHT) \
                                                                                        }	{HeadTube DownTube Offset}]
                                                        lib_gui::object_CursorBinding 	$cv_Name	$dimension
                                    }						
                            }
                SeatTube_Extension {
                            set pt_01					[ frame_geometry::coords_get_xy $TopTube(polygon) 11 ]
                            set pt_02					[ frame_geometry::coords_get_xy $SeatTube(polygon) 3 ]
                            set dimension 		[ $cv_Name dimension  length  	[ project::flatten_nestedList [list $pt_01 $pt_02] ] \
                                                                                    aligned    [expr 50 * $stageScale] [expr -50 * $stageScale] \
                                                                                    darkred ]																				
                            if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
                                                                            [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                                                        {	Custom(SeatTube/Extension) \
                                                                                        }	{SeatTube Extension}]
                                                        lib_gui::object_CursorBinding 	$cv_Name	$dimension
                                    }
                            }
                SeatStay_Offset {
                            set pt_01 					$TopTube(SeatTube)
                            set pt_02 					$SeatStay(End)
                            if { [lindex $pt_02 1] < [lindex $pt_01 1] } {
                                    set dim_coords	[ project::flatten_nestedList [list $pt_01 $pt_02] ]
                            } else {
                                    set dim_coords	[ project::flatten_nestedList [list $pt_02 $pt_01] ]
                            }
                            set dimension 		[ $cv_Name dimension  length  	$dim_coords  \
                                                                                    aligned    [expr 70 * $stageScale]   [expr 50 * $stageScale] \
                                                                                    darkred ]																				
                            if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
                                                                            [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                                                        {	Custom(SeatStay/OffsetTT) \
                                                                                        }	{SeatStay Offset TopTube}]
                                                        lib_gui::object_CursorBinding 	$cv_Name	$dimension
                                    }
                            }
                DownTube_Offset {
                            set pt_01 					$DownTube(BBracket)
                            set pt_02 					$DownTube(Steerer)
                            set pt_03 					$BB_Position 
                            if { [lindex $pt_01 1] >= [lindex $pt_03 1] } {
                                    set dim_distance	[expr  70 * $stageScale]
                                    set dim_offset		[expr -50 * $stageScale]
                            } else {
                                    set dim_distance	[expr -70 * $stageScale]
                                    set dim_offset		[expr  50 * $stageScale]
                            }
                            set dimension 		[ $cv_Name dimension  length  	[ project::flatten_nestedList [list $pt_02 $pt_01 $pt_03] ] \
                                                                                    {perpendicular}    $dim_distance $dim_offset \
                                                                                    darkred ]																				
                            if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
                                                                            [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                                                        {	Custom(DownTube/OffsetBB) \
                                                                                        }	{DownTube Offset BottomBracket}]
                                                        lib_gui::object_CursorBinding 	$cv_Name	$dimension
                                    }
                            }
                TopTube_Angle {
                            set pt_01 					$TopTube(Steerer)
                            set pt_hlp 					$TopTube(SeatTube)
                            set pt_cnt 					[ vectormath::center 	$pt_01  $pt_hlp]
                            set pt_02 					[ list [expr [lindex $pt_cnt 0] + 2] [lindex $pt_cnt 1]  ]

                            if {[lindex $pt_01 1] > [lindex $pt_hlp 1]} {
                                    set dimension 		[ $cv_Name dimension  angle  	[ project::flatten_nestedList [list $pt_cnt $pt_02 $pt_01] ] \
                                                                                    100   -30 \
                                                                                    darkred ]
                            } else {
                                    set dimension 		[ $cv_Name dimension  angle  	[ project::flatten_nestedList [list $pt_cnt $pt_01 $pt_02] ] \
                                                                                    100   -30 \
                                                                                    darkred ]
                            }
                            if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
                                                                            [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                                                        {	Custom(TopTube/Angle) \
                                                                                        }	{TopTube Angle}]
                                                        lib_gui::object_CursorBinding 	$cv_Name	$dimension
                                    }
                        }
                TopHeadTube_Angle {
                            set dimension				[ $cv_Name dimension  angle  	[ project::flatten_nestedList [list $TopTube(Steerer) $Steerer(Stem) $TopTube(SeatTube)] ] \
                                                                                    150   0 \
                                                                                    darkblue ]
                            if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
                                                                            [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                                                        {	Temporary(HeadTube/TopTubeAngle) \
                                                                                        }	{HeadTube TopTube Angle}]
                                                        lib_gui::object_CursorBinding 	$cv_Name	$dimension
                                    }
                        }
                ForkHeight {
                            set dimension	[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$Steerer(vct_Bottom) $FrontWheel(Position) ] \
                                                                                    perpendicular [expr  (-110 + 0.5 * $HeadSet(Diameter)) * $stageScale]    [expr  -80 * $stageScale] \
                                                                                    darkred ] 
                            if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
                                                                            [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                                                        {	Component(Fork/Height) \
                                                                                        }	{Fork Height}]
                                                        lib_gui::object_CursorBinding 	$cv_Name	$dimension
                                    }
                        }
                HeadSet_Bottom {
                            set dimension 		[ $cv_Name dimension  length  	[ project::flatten_nestedList $HeadSet(vct_Bottom)  [lindex $HeadTube(vct_Bottom) 1]] \
                                                                                    perpendicular    [expr  (150 - 0.5 * $HeadSet(Diameter)) * $stageScale]   [expr 50 * $stageScale] \
                                                                                    darkred ]																				
                            if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
                                                                            [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                                                        {	Component(HeadSet/Height/Bottom) \
                                                                                        }	{HeadSet Bottom Height}]
                                                        lib_gui::object_CursorBinding 	$cv_Name	$dimension
                                    }
                        }
                Brake_Rear {
                            if {$Rendering(BrakeRear) != {off}} {
                                switch $Rendering(BrakeRear) {
                                    Rim { 
                                                set pt_03 					[ vectormath::addVector	$frame_geometry::RearBrake(Shoe)        $BB_Position ]
                                                set pt_04 					[ vectormath::addVector	$frame_geometry::RearBrake(Help)        $BB_Position ]
                                                set pt_05 					[ vectormath::addVector	$frame_geometry::RearBrake(Definition)  $BB_Position ]
                                                set pt_06 					[ vectormath::addVector	$frame_geometry::RearBrake(Mount)       $BB_Position ]
                                            set dimension_01	[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$pt_04  $pt_06] \
                                                                                                    aligned  	[expr   -40 * $stageScale]	[expr  40 * $stageScale] \
                                                                                                    darkred ]	;# Component(Brake/Rear/Offset)
                                            set dimension_02	[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$pt_05  $pt_06 ] \
                                                                                                    aligned  	[expr    60 * $stageScale]	[expr -50 * $stageScale] \
                                                                                                    darkred ]	;# Component(Brake/Rear/LeverLength)
                                            if {$updateCommand != {}} {	$cv_Name	bind	$dimension_01	<Double-ButtonPress-1>  \
                                                                                            [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                                                                        {	Component(Brake/Rear/Offset) \
                                                                                                        }	{Rear Brake Offset}]
                                                                        $cv_Name	bind	$dimension_02	<Double-ButtonPress-1>  \
                                                                                            [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                                                                        {	Component(Brake/Rear/LeverLength) \
                                                                                                        }	{Rear Brake LeverLength}]
                                                                        lib_gui::object_CursorBinding 	$cv_Name	$dimension_01
                                                                        lib_gui::object_CursorBinding 	$cv_Name	$dimension_02
                                                    }
                                        }
                                }
                            }
                        }
                Brake_Front {
                            if {$Rendering(BrakeFront) != {off}} {
                                switch $Rendering(BrakeFront) {
                                    Rim { 
                                                set pt_03 					[ vectormath::addVector	$frame_geometry::FrontBrake(Shoe)       $BB_Position ]
                                                set pt_04 					[ vectormath::addVector	$frame_geometry::FrontBrake(Help)       $BB_Position ]
                                                set pt_05 					[ vectormath::addVector	$frame_geometry::FrontBrake(Definition) $BB_Position ]
                                                set pt_06 					[ vectormath::addVector	$frame_geometry::FrontBrake(Mount)      $BB_Position ]
                                                
                                            set dimension_00		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	 $HeadSet(vct_Bottom) $pt_06 ] \
                                                                                                    perpendicular [expr -40 * $stageScale]  [expr   40 * $stageScale] \
                                                                                                    gray50 ] 	;# distance Brake Mount Hole                                                                                          
                                            set dimension_01		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$pt_03  $pt_05 ] \
                                                                                                    aligned  	[expr  -50 * $stageScale]	[expr  -70 * $stageScale] \
                                                                                                    darkred ]	;# Component(Brake/Rear/Offset)
                                            set dimension_02		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$pt_03  $pt_04 ] \
                                                                                                    aligned  	[expr   20 * $stageScale]	[expr   40 * $stageScale] \
                                                                                                    darkred ]	;# Component(Brake/Rear/LeverLength)
                          
                                                                                                    
                                            if {$updateCommand != {}} {	$cv_Name	bind	$dimension_01	<Double-ButtonPress-1>  \
                                                                                            [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                                                                        {	Component(Brake/Front/Offset) \
                                                                                                        }	{Front Brake Offset}]
                                                                        $cv_Name	bind	$dimension_02	<Double-ButtonPress-1>  \
                                                                                            [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                                                                        {	Component(Brake/Front/LeverLength) \
                                                                                                        }	{Front Brake LeverLength}]
                                                                        lib_gui::object_CursorBinding 	$cv_Name	$dimension_01
                                                                        lib_gui::object_CursorBinding 	$cv_Name	$dimension_02
                                                    }
                                        }
                                }
                            }
                        }
                BottleCage {
                                set dt_direction	[ frame_geometry::object_values DownTube direction ]
                                set st_direction	[ frame_geometry::object_values SeatTube direction ]
                            
                            if {$Rendering(BottleCage_ST) != {off}} {
                                            set pt_01 					[ frame_geometry::object_values	SeatTube/BottleCage/Offset	position	$BB_Position]
                                            set pt_02 					[ frame_geometry::object_values	SeatTube/BottleCage/Base	position	$BB_Position]
                                            set pt_03					[ vectormath::addVector	$pt_02	$st_direction	[expr -1.0 * $frame_geometry::BottleCage(SeatTube)] ] 
                                            
                                            set dimension		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$pt_01  $pt_02 ] \
                                                                                                    aligned 	[expr  70 * $stageScale]	[expr    0 * $stageScale] \
                                                                                                    gray50 ] 																
                                            set dimension		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$pt_02  $pt_03 ] \
                                                                                                    aligned		[expr  70 * $stageScale]	[expr  -15 * $stageScale] \
                                                                                                    darkblue ]										
                                            if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
                                                                                            [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                                                                        {	Component(BottleCage/SeatTube/OffsetBB) \
                                                                                                        }	{BottleCage SeatTube Offset}]
                                                                        lib_gui::object_CursorBinding 	$cv_Name	$dimension
                                                    }														
                            }
                            
                            if {$Rendering(BottleCage_DT) != {off}} {
                                            set pt_01 					[ frame_geometry::object_values	DownTube/BottleCage/Offset	position	$BB_Position]
                                            set pt_02 					[ frame_geometry::object_values	DownTube/BottleCage/Base	position	$BB_Position]
                                            set pt_03					[ vectormath::addVector	$pt_02	$dt_direction	[expr -1.0 * $frame_geometry::BottleCage(DownTube)] ] 

                                            if { $Rendering(BottleCage_DT_L) != {off}} { set addDist 50 } else { set addDist 0}
                                            
                                            set dimension		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$pt_01  $pt_02 ] \
                                                                                                    aligned		[expr -1.0 * (90 + $addDist) * $stageScale]	0 \
                                                                                                    gray50 ]
                                            set dimension		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$pt_02  $pt_03 ] \
                                                                                                    aligned 	[expr -1.0 * (90 + $addDist) * $stageScale]	[expr  15 * $stageScale] \
                                                                                                    darkblue ] 																
                                            if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
                                                                                            [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                                                                        {	Component(BottleCage/DownTube/OffsetBB) \
                                                                                                        }	{BottleCage DownTube Offset}]
                                                                        lib_gui::object_CursorBinding 	$cv_Name	$dimension
                                                    }														
                            }
                            if {$Rendering(BottleCage_DT_L) != {off}} {
                                            set pt_01 					[ frame_geometry::object_values	DownTube/BottleCage_Lower/Offset	position	$BB_Position ]
                                            set pt_02 					[ frame_geometry::object_values	DownTube/BottleCage_Lower/Base		position	$BB_Position ]
                                            set pt_03					[ vectormath::addVector	$pt_02	$dt_direction	[expr -1.0 * $frame_geometry::BottleCage(DownTube_Lower) ] ] 

                                            set dimension		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$pt_01  $pt_02 ] \
                                                                                                    aligned		[expr -60 * $stageScale]	0 \
                                                                                                    gray50 ]
                                            set dimension		[ $cv_Name dimension  length  	[ project::flatten_nestedList  	$pt_02  $pt_03 ] \
                                                                                                    aligned 	[expr -60 * $stageScale]	[expr  15 * $stageScale] \
                                                                                                    darkblue ] 																
                                            if {$updateCommand != {}} {	$cv_Name	bind	$dimension	<Double-ButtonPress-1>  \
                                                                                            [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                                                                        {	Component(BottleCage/DownTube_Lower/OffsetBB) \
                                                                                                        }	{BottleCage DownTube Lower Offset}]
                                                                        lib_gui::object_CursorBinding 	$cv_Name	$dimension
                                                    }														
                            }
                        }					
                RearWheel_Clearance {
                            set RimDiameter				$project::Component(Wheel/Rear/RimDiameter)
                            set TyreHeight				$project::Component(Wheel/Rear/TyreHeight)
                            set WheelRadius				[ expr 0.5 * $RimDiameter + $TyreHeight ]
                            set pt_03 					[ frame_geometry::object_values 	RearWheel	position	$BB_Position  ]
                            set pt_06					[ frame_geometry::coords_get_xy $SeatTube(polygon) 6 ]
                            set pt_07					[ frame_geometry::coords_get_xy $SeatTube(polygon) 7 ]						
                            set pt_is					[ vectormath::intersectPerp $pt_06 $pt_07 $pt_03 ]
                            set pt_rw					[ vectormath::addVector $pt_03 [ vectormath::unifyVector  $pt_03  $pt_is  $WheelRadius ] ]	
                            set dimension 		[ $cv_Name dimension  length  	[ project::flatten_nestedList [list $pt_rw $pt_is] ] \
                                                                                    aligned    [expr -70 * $stageScale]  [expr 50 * $stageScale] \
                                                                                    gray50 ]																				
                        }
                LegClearance {
                            set pt_01					[ vectormath::addVector		$frame_geometry::LegClearance(Position) 	$BB_Position ]
                            set pt_09					[ frame_geometry::coords_get_xy $TopTube(polygon)  9 ]
                            set pt_10					[ frame_geometry::coords_get_xy $TopTube(polygon) 10 ]
                            set pt_is					[ vectormath::intersectPerp $pt_09 $pt_10 $pt_01 ]
                            set dimension 		[ $cv_Name dimension  length  	[ project::flatten_nestedList [list $pt_01 $pt_is] ] \
                                                                                    aligned    [expr -30 * $stageScale]  [expr 50 * $stageScale] \
                                                                                    gray50 ]																				
                        }
                check_this {
                            set pt_01					[ frame_geometry::coords_get_xy $TopTube(polygon) 11 ]
                            set pt_01a					[ frame_geometry::coords_get_xy $TopTube(polygon) 11 ]
                            set pt_02					[ frame_geometry::coords_get_xy $SeatTube(polygon) 3 ]
                            $cv_Name create circle  $pt_01 	-radius 20  -outline red
                            $cv_Name create circle  $pt_02 	-radius 20  -outline blue
                            set dimension 		[ $cv_Name dimension  length  	[ project::flatten_nestedList [list $pt_01 $pt_02] ] \
                                                                                    aligned    [expr 50 * $stageScale]   [expr 50 * $stageScale] \
                                                                                    darkblue ]																				
                            if {$updateCommand != {}} {		
                                        $cv_Name bind 				$dimension  \
                                                <Double-ButtonPress-1>  [list frame_geometry::createEdit  %x %y  $cv_Name  \
                                                                                    {	Custom(SeatStay/OffsetTT)		\
                                                                                    }	{SeatStay OffsetTopTube}]
                                        lib_gui::object_CursorBinding 	$cv_Name	$dimension
                                    }
                        }
                default {}
            }
            
	}

	
	proc createCenterline {cv_Name BB_Position {extend_Saddle {}}} {
			
                # --- get stageScale
            set stageScale 	[ $cv_Name  getNodeAttr  Stage	scale ]	

                # --- get defining Point coords ----------
            set BottomBracket(Position)	$BB_Position	
            set FrontWheel(Position)	[ frame_geometry::object_values  	FrontWheel		position	$BB_Position ]
            set Saddle(Position)		[ frame_geometry::object_values  	Saddle			position	$BB_Position ]
            set SeatStay(SeatTube)		[ frame_geometry::object_values		SeatStay/End	position	$BB_Position ]
            set SeatTube(TopTube)		[ frame_geometry::object_values		SeatTube/End	position	$BB_Position ]	
            set SeatStay(RearWheel)		[ frame_geometry::object_values		SeatStay/Start	position	$BB_Position ]
            set TopTube(SeatTube)		[ frame_geometry::object_values		TopTube/Start	position	$BB_Position ]
            set TopTube(Steerer)		[ frame_geometry::object_values		TopTube/End		position	$BB_Position ]
            set Steerer(Stem)			[ frame_geometry::object_values		Steerer/End		position	$BB_Position ]
            set Steerer(Fork)			[ frame_geometry::object_values  	Steerer/Start	position	$BB_Position ]
            set DownTube(Steerer)		[ frame_geometry::object_values  	DownTube/End	position	$BB_Position ]
            set DownTube(BBracket)		[ frame_geometry::object_values		DownTube/Start	position 	$BB_Position ]
            set HandleBar(Position)		[ frame_geometry::object_values		HandleBar 		position	$BB_Position ]
            set Position(IS_ChainSt_SeatSt)		[ frame_geometry::object_values  	ChainStay/SeatStay_IS	position	$BB_Position ]	
            
            set help_01					[ vectormath::intersectPerp		  $Steerer(Stem) $Steerer(Fork) $FrontWheel(Position) ] 

            
            $cv_Name create centerline [ project::flatten_nestedList  $Steerer(Stem)   	$HandleBar(Position) 			] -fill gray60 -tags __CenterLine__
            $cv_Name create centerline [ project::flatten_nestedList  $Steerer(Stem)   	$help_01 			] -fill gray60 -tags __CenterLine__ 
            $cv_Name create centerline [ project::flatten_nestedList  $FrontWheel(Position)		   	$help_01 			] -fill gray60 -tags __CenterLine__ 
            $cv_Name create centerline [ project::flatten_nestedList  $DownTube(BBracket)  		$DownTube(Steerer) 	] -fill gray60 -tags __CenterLine__ 
            $cv_Name create centerline [ project::flatten_nestedList  $TopTube(SeatTube)	$TopTube(Steerer) 	] -fill gray60 -tags __CenterLine__ 
            $cv_Name create centerline [ project::flatten_nestedList  $SeatStay(SeatTube)	$Position(IS_ChainSt_SeatSt)  ] -fill gray60 -tags __CenterLine__ 
            $cv_Name create centerline [ project::flatten_nestedList  $Position(IS_ChainSt_SeatSt)	$BottomBracket(Position)		] -fill gray60 -tags __CenterLine__
            if {$extend_Saddle == {}} {
                $cv_Name create centerline [ project::flatten_nestedList  $BottomBracket(Position)	$SeatTube(TopTube)	] -fill gray60 -tags __CenterLine__ 
            } else {
                $cv_Name create centerline [ project::flatten_nestedList  $BottomBracket(Position)	$Saddle(Position)				] -fill gray60 -tags __CenterLine__ 
            }
            
                # puts "\n =================\n"
                # puts "    $SeatStay(SeatTube)	$SeatStay(RearWheel) "
                # puts "\n =================\n"				
	}

	
	proc createDraftingFrame {cv_Name DIN_Format scale projectFile date} {
    
			puts ""
			puts "   -------------------------------"
			puts "    cv_custom::createDraftingFrame"
			puts "       cv_Name:         $cv_Name"
			puts "       DIN_Format:      $DIN_Format"
			puts "       projectFile:     $projectFile"
			
                # --- get stageScale
            set stageWidth		[ $cv_Name	getNodeAttr  Stage  width  ]
            set stageHeight		[ $cv_Name	getNodeAttr  Stage  height ]
            set stageScale 		[ $cv_Name  getNodeAttr  Stage	scale  ]
            
            set scaleFactor		[ expr 1 / $stageScale ]
                if {[expr round($scaleFactor)] == $scaleFactor} {
                    set formatScaleFactor		[ expr round($scaleFactor) ]
                } else {
                    set formatScaleFactor		[ format "%.1f" $scaleFactor ]
                }

            proc scale_toStage	{ptList factor} {
                return [ vectormath::scalePointList {0 0} $ptList $factor ]
            }
            
                # --- outer border
            set df_Border		5
            set df_Width		[ expr $stageWidth  - 2 * $df_Border ]
            set df_Height		[ expr $stageHeight - 2 * $df_Border ]
            set x_00			  $df_Border
            set x_01			[ expr $df_Border + $df_Width ]
            set y_00			  $df_Border
            set y_01			[ expr $df_Border + $df_Height]
            set border_Coords	[ list 	$x_00 $y_00		$x_00 $y_01		$x_01 $y_01		$x_01 $y_00		$x_00 $y_00	]
            set border_Coords	[ scale_toStage  $border_Coords $scaleFactor ]
            $cv_Name create draftLine $border_Coords 	-fill black -width 0.7
            
                # --- title block
            set tb_Width		  170
            set tb_Height		   20
            set tb_BottomLeft	[ expr $stageWidth  - $df_Border  - $tb_Width ] 
            set x_02			[ expr $df_Border + $tb_BottomLeft ]
            set y_02			[ expr $df_Border + $tb_Height     ]
            set border_Coords	[ list 	$x_02 $y_00		$x_02 $y_02		$x_01 $y_02		$x_01 $y_00		$x_02 $y_00	]
            set border_Coords	[ scale_toStage  $border_Coords $scaleFactor ]
            $cv_Name create draftLine $border_Coords 	-fill black -width 0.7		;# title block - border 
            
            set y_03			[ expr $df_Border + 11     ]
            set line_Coords		[ list 	$x_02 $y_03		$x_01 $y_03	]
            set line_Coords		[ scale_toStage  $line_Coords $scaleFactor ]
            $cv_Name create draftLine $line_Coords 		-fill black -width 0.7		;# title block - horizontal line separator
            
            set x_03			[ expr $df_Border + $tb_BottomLeft + 18     ]
            set line_Coords		[ list 	$x_03 $y_00		$x_03 $y_02	]
            set line_Coords		[ scale_toStage  $line_Coords $scaleFactor ]
            $cv_Name create draftLine $line_Coords 		-fill black -width 0.7		;# title block - first left column separator
            
            set x_04			[ expr $df_Border + $tb_BottomLeft + 130     ]
            set y_04			[ expr $df_Border + 11     ]
            set line_Coords		[ list 	$x_04 $y_04		$x_04 $y_02	]
            set line_Coords		[ scale_toStage  $line_Coords $scaleFactor ]
            $cv_Name create draftLine $line_Coords 		-fill black -width 0.7		;# title block - second left column separator
            
                
                # --- create Text: 
            set textSize			5
            set textHeight			[expr $textSize * $scaleFactor ]
            
                # --- create Text: DIN Format
            set textPos				[scale_toStage [list [expr $df_Border + $tb_BottomLeft +  5 ] [ expr $df_Border + 13.5 ] ]	$scaleFactor]
            set textText			"$DIN_Format"
            $cv_Name create draftText $textPos  -text $textText -size $textSize
            
                # --- create Text: Software & Version
            set textPos				[scale_toStage [list [expr $df_Border + $tb_BottomLeft + 128 ] [ expr $df_Border + 13.5 ] ]	$scaleFactor]
            set textText			[format "rattleCAD  V%s.%s" $::APPL_Env(RELEASE_Version) $::APPL_Env(RELEASE_Revision)]
            $cv_Name create draftText $textPos  -text $textText -size $textSize -anchor se

                # --- create Text: Scale
            set textPos				[scale_toStage [list [expr $df_Border + $tb_BottomLeft +   5 ] [ expr $df_Border +  3.0 ] ]	$scaleFactor]
            set textText			"1:$formatScaleFactor"
            $cv_Name create draftText $textPos  -text $textText -size $textSize
            
                # --- create Text: Project-File
            set textPos				[scale_toStage [list [expr $df_Border + $df_Width      -   2 ] [ expr $df_Border +  3.0 ] ]	$scaleFactor]
            set textText			[file tail $projectFile]
            $cv_Name create draftText $textPos  -text $textText -size $textSize -anchor se
            
                # --- create Text: Date
            set textPos				[scale_toStage [list [expr $df_Border + $df_Width      -   2 ] [ expr $df_Border + 14.0 ] ]	$scaleFactor]
            set textText			$date
            $cv_Name create draftText $textPos  -text $textText -size 2.5       -anchor se
            
            
            puts "       stageWidth:      $stageWidth" 
            puts "       stageHeight:     $stageHeight" 
            puts "       stageScale:      $stageScale" 
	}
	
	proc createWaterMark {cv_Name projectFile date} {
			
                # --- get stageScale
            set stageWidth		[ $cv_Name	getNodeAttr  Stage  width  ]
            set stageHeight		[ $cv_Name	getNodeAttr  Stage  height ]
            set stageScale 		[ $cv_Name  getNodeAttr  Stage	scale  ]
            set stageFormat		[ $cv_Name  getNodeAttr  Stage  format ]
            
            set scaleFactor		[ expr 1 / $stageScale ]
                if {[expr round($scaleFactor)] == $scaleFactor} {
                    set formatScaleFactor		[ expr round($scaleFactor) ]
                } else {
                    set formatScaleFactor		[ format "%.1f" $scaleFactor ]
                }

            proc scale_toStage	{ptList factor} {
                return [ vectormath::scalePointList {0 0} $ptList $factor ]
            }
                        # --- create Text: Software & Version
                # set textPos				[scale_toStage [list [expr $df_Border + $df_Width      -   2 ] [ expr $df_Border +  3.0 ] ]	$scaleFactor]
            set textPos				[scale_toStage {7 4}	$scaleFactor]
            set textText			[format "%s  /  %s  / \[DIN %s\] /  rattleCAD  V%s.%s " $projectFile $date $stageFormat $::APPL_Env(RELEASE_Version) $::APPL_Env(RELEASE_Revision) ]
            $cv_Name create draftText $textPos  -text $textText -size 2.5 -anchor sw -fill gray20
                # $cv_Name create draftText $textPos  -text $textText -size 2.5 -anchor sw -fill gray30
                # $cv_Name create draftText $textPos  -text $textText -size 2.5 -anchor sw -fill gray80
	}
	
}
