 ##+##########################################################################
 #
 # package: rattleCAD	->	lib_frame_geometry_custom.tcl
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
 #	namespace:  rattleCAD::frame_geometry_custom
 # ---------------------------------------------------------------------------
 #
 # 

 
 namespace eval frame_geometry {
        # package require tdom
        
            #-------------------------------------------------------------------------
                #  current Project Values
                # variable BaseCenter		; array set BaseCenter		{}
			variable Project		; array set Project	 		{}

			variable RearWheel		; array set RearWheel 		{}
			variable FrontWheel		; array set FrontWheel		{}
			variable BottomBracket	; array set BottomBracket	{}
			variable Saddle			; array set Saddle			{}
			variable HandleBar		; array set HandleBar		{}
			variable LegClearance	; array set LegClearance	{}								
			
			variable HeadTube		; array set HeadTube		{}
			variable SeatTube		; array set SeatTube		{}
			variable DownTube		; array set DownTube		{}
			variable TopTube		; array set TopTube			{}
			variable ChainStay		; array set ChainStay		{}
			variable SeatStay		; array set SeatStay	 	{}
			variable Steerer		; array set Steerer			{}
			variable ForkBlade		; array set ForkBlade		{}
			
			variable Fork			; array set Fork			{}
			variable Stem			; array set Stem			{}
			variable HeadSet		; array set HeadSet			{}
			variable RearDrop		; array set RearDrop		{}
			
			variable BottleCage		; array set BottleCage		{}
			variable FrameJig		; array set FrameJig		{}
			variable TubeMiter		; array set TubeMiter		{}
			
			variable DEBUG_Geometry ; array set DEBUG_Geometry	{}
			


			#-------------------------------------------------------------------------
				#  update loop and delay; store last value
			variable _updateValue	; array set _updateValue 	{}
				
			#-------------------------------------------------------------------------
				#  store createEdit-widgets position
			variable _drag
			
			#-------------------------------------------------------------------------
				#  dataprovider of create_selectbox
			variable _listBoxValues
				

		namespace import ::frame_geometry_extend::coords_addVector 	;#  add vector to list of coordinates	
		namespace import ::frame_geometry_extend::closeEdit			;#  close ProjectEdit Widget		
		namespace import ::frame_geometry_extend::dragStart			;#  binding: dragStart		
		namespace import ::frame_geometry_extend::drag					;#  binding: drag
		namespace import ::frame_geometry_extend::bind_parent_move
		namespace import ::frame_geometry_extend::coords_flip_y	
		namespace import ::frame_geometry_extend::coords_get_xy		;#  get xy in a flat list of coordinates, start with    0, 1, 2, 3, ... 

		
 	
	
	
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
			set ::APPL_Env(canvasCAD_Update)	[ clock milliseconds ]
			
	
				#
				# --- set Project attributes
			set Project(Project)		$project::Project(Name)
			set Project(modified)		$project::Project(modified)
			
				#
				# --- get BottomBracket (1)
			set BottomBracket(depth)	$project::Custom(BottomBracket/Depth)
			# --> replace $BottomBracket(depth) by $project::Custom(BottomBracket/Depth)
			# set BottomBracket(depth)		$project::Custom(BottomBracket/Depth  		]  asText ]
			# set BottomBracket(depth)		[ $project::Custom(BottomBracket/Depth) ]
			
			# set RearWheel(RimDiameter)	[ [ $project::Component(Wheel/Rear/RimDiameter	]  asText ]
			# set RearWheel(RimDiameter)	[ $project::Component(Wheel/Rear/RimDiameter)]

				#
				# --- get RearWheel
			set RearWheel(RimDiameter)	$project::Component(Wheel/Rear/RimDiameter)
			set RearWheel(RimHeight)	$project::Component(Wheel/Rear/RimHeight)
			set RearWheel(TyreHeight)	$project::Component(Wheel/Rear/TyreHeight)
			set RearWheel(Radius)		[ expr 0.5*$RearWheel(RimDiameter) + $RearWheel(TyreHeight) ]
			set RearWheel(DistanceBB)	$project::Custom(WheelPosition/Rear)
			#set RearWheel(Distance_X)	[ expr sqrt(pow($RearWheel(DistanceBB),2)  - pow($project::Custom(BottomBracket/Depth),2)) ]
			set RearWheel(Distance_X)	[ expr sqrt(pow($RearWheel(DistanceBB),2)  - pow($project::Custom(BottomBracket/Depth),2)) ]
			set RearWheel(Position)		[ list [expr -1.0 * $RearWheel(Distance_X)] $project::Custom(BottomBracket/Depth) ]
				# set RearWheel(Distance_X)	450
				
				#
				# --- get BottomBracket (2)
			set BottomBracket(height)	[ expr $RearWheel(Radius) - $project::Custom(BottomBracket/Depth) ]
			set BottomBracket(Ground)	[ list 0 	[expr - $RearWheel(Radius) + $project::Custom(BottomBracket/Depth) ] ]
		
				#
				# --- get FrontWheel 
			set FrontWheel(RimDiameter)	$project::Component(Wheel/Front/RimDiameter)
			set FrontWheel(RimHeight)	$project::Component(Wheel/Front/RimHeight)
			set FrontWheel(TyreHeight)	$project::Component(Wheel/Front/TyreHeight)
			set FrontWheel(Radius)		[ expr 0.5*$FrontWheel(RimDiameter) + $FrontWheel(TyreHeight) ]
			#set FrontWheel(DistanceBB)	[ [ $domProject selectNodes /root/Temporary/WheelPosition/front/diagonal		]  asText ]
			#set FrontWheel(Distance_X)	[ expr sqrt(pow($FrontWheel(DistanceBB),2) - pow(($FrontWheel(Radius) - $BottomBracket(height)),2)) ]
			set FrontWheel(Distance_Y)	[ expr $project::Custom(BottomBracket/Depth) - $RearWheel(Radius) + $FrontWheel(Radius) ]
			#set FrontWheel(Position)	[ list $FrontWheel(Distance_X) $FrontWheel(Distance_Y) ]

				#
				# --- get HandleBar - Position
			set HandleBar(Distance)		$project::Personal(HandleBar_Distance)
			set HandleBar(Height)		$project::Personal(HandleBar_Height)
			set HandleBar(Position)		[ list $HandleBar(Distance) $HandleBar(Height) ]
			
				#
				# --- get Fork -----------------------------
			set Fork(Height)				$project::Component(Fork/Height)
			set Fork(Rake)					$project::Component(Fork/Rake)
			set Fork(BladeWith)				$project::Component(Fork/Blade/Width)
			set Fork(BladeDiameterDO)		$project::Component(Fork/Blade/DiameterDO)
			set Fork(BladeTaperLength)		$project::Component(Fork/Blade/TaperLength)
			set Fork(BladeOffset)			$project::Component(Fork/Blade/Offset)
			set Fork(BladeOffsetCrown)		$project::Component(Fork/Crown/Blade/Offset)
			set Fork(BladeOffsetCrownPerp)	$project::Component(Fork/Crown/Blade/OffsetPerp)
			set Fork(BladeOffsetDO)			$project::Component(Fork/DropOut/Offset)
			set Fork(BladeOffsetDOPerp)		$project::Component(Fork/DropOut/OffsetPerp)
			set Fork(BrakeAngle)			$project::Component(Fork/Crown/Brake/Angle)
			set Fork(BrakeOffset)			$project::Component(Fork/Crown/Brake/Offset) 
			
				#
				# --- get Stem -----------------------------
			set Stem(Angle)					$project::Component(Stem/Angle)
			set Stem(Length)				$project::Component(Stem/Length)

				#
				# --- get HeadTube -------------------------
			set HeadTube(ForkRake)		$Fork(Rake)
			set HeadTube(ForkHeight)	$Fork(Height)
			set HeadTube(Diameter)		$project::FrameTubes(HeadTube/Diameter)
			set HeadTube(Length)		$project::FrameTubes(HeadTube/Length)
			set HeadTube(Angle)			$project::Custom(HeadTube/Angle)

				#
				# --- get SeatTube -------------------------
			set SeatTube(Angle)			$project::Personal(SeatTube_Angle)
			set SeatTube(Length)		$project::Personal(SeatTube_Length)
			set SeatTube(DiameterBB)	$project::FrameTubes(SeatTube/DiameterBB)
			set SeatTube(DiameterTT)	$project::FrameTubes(SeatTube/DiameterTT)
			set SeatTube(TaperLength)	$project::FrameTubes(SeatTube/TaperLength)
			set SeatTube(Extension)		$project::Custom(SeatTube/Extension)

				#
				# --- get DownTube -------------------------
			set DownTube(DiameterBB)	$project::FrameTubes(DownTube/DiameterBB)
			set DownTube(DiameterHT)	$project::FrameTubes(DownTube/DiameterHT)
			set DownTube(TaperLength)	$project::FrameTubes(DownTube/TaperLength)
			set DownTube(OffsetHT)		$project::Custom(DownTube/OffsetHT)
			set DownTube(OffsetBB)		$project::Custom(DownTube/OffsetBB)				

				#
				# --- get TopTube --------------------------
			set TopTube(DiameterHT)		$project::FrameTubes(TopTube/DiameterHT)
			set TopTube(DiameterST)		$project::FrameTubes(TopTube/DiameterST)
			set TopTube(TaperLength)	$project::FrameTubes(TopTube/TaperLength)
			set TopTube(PivotPosition)	$project::Custom(TopTube/PivotPosition)
			set TopTube(OffsetHT)		$project::Custom(TopTube/OffsetHT)
			set TopTube(Angle)			$project::Custom(TopTube/Angle)
				
				#
				# --- get ChainStay ------------------------
			set ChainStay(DiameterBB)	$project::FrameTubes(ChainStay/DiameterBB)
			set ChainStay(DiameterSS)	$project::FrameTubes(ChainStay/DiameterSS)
			set ChainStay(TaperLength)	$project::FrameTubes(ChainStay/TaperLength)
				
				#
				# --- get SeatStay -------------------------
			set SeatStay(DiameterST)	$project::FrameTubes(SeatStay/DiameterST)
			set SeatStay(DiameterCS)	$project::FrameTubes(SeatStay/DiameterCS)
			set SeatStay(TaperLength)	$project::FrameTubes(SeatStay/TaperLength)
			set SeatStay(OffsetTT)		$project::Custom(SeatStay/OffsetTT)

				#
				# --- get RearDropOut ----------------------
			set RearDrop(OffsetCS)		$project::Lugs(RearDropOut/ChainStay/Offset)
			set RearDrop(OffsetCSPerp)	$project::Lugs(RearDropOut/ChainStay/OffsetPerp)
			set RearDrop(OffsetSS)		$project::Lugs(RearDropOut/SeatStay/Offset)
			set RearDrop(OffsetSSPerp)	$project::Lugs(RearDropOut/SeatStay/OffsetPerp)
			set RearDrop(Derailleur_x)	$project::Lugs(RearDropOut/Derailleur/x)
			set RearDrop(Derailleur_y)	$project::Lugs(RearDropOut/Derailleur/y)
			
				#
				# --- get LegClearance - Position
			set LegClearance(Length)	$project::Personal(InnerLeg_Length)
			set LegClearance(Position)	[ list $TopTube(PivotPosition) 	[expr $LegClearance(Length) - ($RearWheel(Radius) - $project::Custom(BottomBracket/Depth)) ] ]

				#
				# --- get Saddle ---------------------------
			set Saddle(SeatPost_x)		$project::Component(Saddle/SeatPost/x)
			set Saddle(SeatPost_y)		$project::Component(Saddle/SeatPost/y)
			set Saddle(SeatPost_DM)		$project::Component(Saddle/SeatPost/Diameter)
			set Saddle(Position)		[ vectormath::rotateLine {0 0}  $SeatTube(Length)  [ expr 180 - $SeatTube(Angle) ] ]
			set Saddle(Proposal)		[ vectormath::rotateLine {0 0}  [ expr 0.88*$LegClearance(Length) ]  [ expr 180 - $SeatTube(Angle) ] ]

				#
				# --- get HeadSet --------------------------
			set HeadSet(Diameter)		$project::Component(HeadSet/Diameter)
			set HeadSet(Height_Top) 	$project::Component(HeadSet/Height/Top)
			set HeadSet(Height_Bottom) 	$project::Component(HeadSet/Height/Bottom)
			set HeadSet(ShimDiameter)	36
				
				#
				# --- get Front/Rear Brake PadLever --------------
			set RearBrake(LeverLength)	$project::Component(Brake/Rear/LeverLength)
			set RearBrake(Offset)		$project::Component(Brake/Rear/Offset)
			set FrontBrake(LeverLength)	$project::Component(Brake/Front/LeverLength)
			set FrontBrake(Offset)		$project::Component(Brake/Front/Offset)
				
				#
				# --- get BottleCage Offset ----------------------
			set BottleCage(SeatTube)		$project::Component(BottleCage/SeatTube/OffsetBB)
			set BottleCage(DownTube)		$project::Component(BottleCage/DownTube/OffsetBB)
			set BottleCage(DownTube_Lower)	$project::Component(BottleCage/DownTube_Lower/OffsetBB)
								
				#
				# --- get FrontDerailleur  ----------------------
			set FrontDerailleur(Distance)	$project::Component(Derailleur/Front/Distance)
			set FrontDerailleur(Offset)		$project::Component(Derailleur/Front/Offset)
								
								
				#
				# --- set DEBUG_Geometry  ----------------------
			set DEBUG_Geometry(Base)		{0 0}
								
				
				#
				#
				# --- set basePoints Attributes
				#
			project::setValue Result(Position/RearWheel)			position	$RearWheel(Position)
			# project::setValue /root/Result/Position/RearWheel			position	$RearWheel(Position)
				# project::setValue /root/Result/Position/FrontWheel		position	$FrontWheel(Position)
			project::setValue Result(Position/HandleBar)			position	$HandleBar(Position)
			project::setValue Result(Position/Saddle) 				position	$Saddle(Position)
			project::setValue Result(Position/SaddleProposal)		position	$Saddle(Proposal)
			project::setValue Result(Position/LegClearance)			position	$TopTube(PivotPosition) 	[expr $LegClearance(Length) - ($RearWheel(Radius) - $project::Custom(BottomBracket/Depth)) ]
			project::setValue Result(Position/BottomBracketGround)	position	0 	[expr - $RearWheel(Radius) + $project::Custom(BottomBracket/Depth) ] ;# Point on the Ground perp. to BB

			# project::setValue /root/Result/Lugs/Dropout/Front/Position	position 	$FrontWheel(Distance_X)	[expr $project::Custom(BottomBracket/Depth) + ($FrontWheel(Radius) - $RearWheel(Radius))]
			project::setValue Result(Lugs/Dropout/Rear/Position)	position 	[expr -1*$RearWheel(Distance_X)]	$project::Custom(BottomBracket/Depth)
			project::setValue Result(Lugs/Dropout/Rear/Derailleur)	position 	[ vectormath::addVector  $RearWheel(Position)  [list $RearDrop(Derailleur_x) $RearDrop(Derailleur_y)] ]

			
				#
				#
				# --- set basePoints Attributes
				#
			proc get_basePoints {} {
					variable Saddle
					variable HandleBar
					variable HeadTube
					variable Steerer
					variable Stem
					variable Fork
					variable RearWheel
					variable FrontWheel
					variable BottomBracket
										
								# puts "   .. 	\$HeadTube(Angle)	$HeadTube(Angle)"	
										
							set vect_01	 [ expr $Stem(Length) * cos($Stem(Angle) * $vectormath::CONST_PI / 180) ]
							set vect_03  [ expr $vect_01 / sin($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]

							set Steerer(Handlebar)		[ list	[expr [lindex $HandleBar(Position) 0] - $vect_03]  [lindex $HandleBar(Position) 1] ]

							set help_04	 [ vectormath::rotateLine		$Steerer(Handlebar)		100	[expr 180 - $HeadTube(Angle)]	]
							set help_03  [ vectormath::rotateLine		$HandleBar(Position)	100	[expr  90 - $HeadTube(Angle) + $Stem(Angle)]	]
							
							set Steerer(Stem)			[ vectormath::intersectPoint	$HandleBar(Position)  $help_03 $Steerer(Handlebar) $help_04 ]
						
							set vect_04	 [ vectormath::parallel  		$Steerer(Stem)  	$help_04	$Fork(Rake) ]
							set help_05  [ lindex $vect_04 0 ]
							set help_06  [ lindex $vect_04 1 ]
							
							set FrontWheel(Position)	[ vectormath::intersectPoint	$help_05  $help_06 [list 0 $FrontWheel(Distance_Y)] [list 200 $FrontWheel(Distance_Y)] ]
							set FrontWheel(Distance_X)	[ lindex $FrontWheel(Position) 0]
							set FrontWheel(DistanceBB)	[ expr hypot($FrontWheel(Distance_X),$FrontWheel(Distance_X)) ]

							set Steerer(FrontWheel) 	[ vectormath::rotateLine	$FrontWheel(Position)	$Fork(Rake)	[expr 270 - $HeadTube(Angle)] ]			
							set Steerer(Fork) 			[ vectormath::addVector			$Steerer(FrontWheel) 	[ vectormath::unifyVector  $Steerer(FrontWheel)  $Steerer(Stem)  $Fork(Height) ] ]
														
					project::setValue Result(Tubes/Steerer/Start)		position	$Steerer(Fork) 
					project::setValue Result(Tubes/Steerer/End)			position	$Steerer(Stem)
					project::setValue Result(Lugs/ForkCrown/Position)	position	$Steerer(Fork) 
					project::setValue Result(Tubes/Steerer/Direction)	direction	$Steerer(Fork)	$Steerer(Stem)
					project::setValue Result(Tubes/Steerer/Direction)	direction	$Steerer(Fork)	$Steerer(Stem)
					
						set help_08  [ vectormath::addVector	$BottomBracket(Ground) {200 0}] 
						
						set Steerer(Ground)		[ vectormath::intersectPoint 		$Steerer(Stem) $Steerer(Fork)  	$BottomBracket(Ground)  $help_08 ] 
						set SeatTube(Ground)	[ vectormath::intersectPoint 		$Saddle(Position) {0 0}  	$BottomBracket(Ground)  $help_08 ] 
					project::setValue Result(Position/SteererGround)	position	$Steerer(Ground)		;# Point on the Ground in direction of Steerer
					project::setValue Result(Position/SeatTubeGround)	position	$SeatTube(Ground)		;# Point on the Ground in direction of SeatTube
					project::setValue Result(Tubes/SeatTube/Direction)	direction	$SeatTube(Ground)  $Saddle(Position)
						
						#
						# --- set summary Length of Frame, Saddle and Stem
						set summaryLength [ expr $RearWheel(Distance_X) + $FrontWheel(Distance_X)]
						set summaryHeight [ expr $project::Custom(BottomBracket/Depth) + 40 + [lindex $Saddle(Position) 1] ]
					project::setValue Result(Position/SummarySize)		position	$summaryLength	$summaryHeight
												
			}
			get_basePoints
			project::setValue Result(Position/FrontWheel)			position	$FrontWheel(Position)
			project::setValue Result(Lugs/Dropout/Front/Position)	position 	$FrontWheel(Distance_X)	[expr $project::Custom(BottomBracket/Depth) + ($FrontWheel(Radius) - $RearWheel(Radius))]

			
			#
			# --- compute tubing geometry
			#
			
				#
				# --- set ChainStay ------------------------
			proc get_ChainStay {} {
					variable RearDrop 
					variable ChainStay 
					variable RearWheel 
					
							set vct_00		[ vectormath::parallel  		$RearWheel(Position)      {0 0}   $RearDrop(OffsetCSPerp) left]
							set pt_00		[ lindex $vct_00 0 ]			
					
							set ChainStay(Direction)			[ vectormath::unifyVector {0 0} $pt_00 ]
					project::setValue Result(Tubes/ChainStay/Direction)	direction	$pt_00
					
							set pt_00		[ vectormath::addVector 		$pt_00  $ChainStay(Direction)  -$RearDrop(OffsetCS) ]

								# -- exception if Tube is shorter than taper length
								set tube_length			[ vectormath::length {0 0} $pt_00 ]
									if { [expr $tube_length - $ChainStay(TaperLength) -10] < 0 } {
										puts "         ... exception:  ChainStay TaperLength ... $tube_length / $ChainStay(TaperLength)"
										set taper_length	[ expr $tube_length -10 ]
										puts "                         -> $taper_length"
									} else {
										set taper_length	$ChainStay(TaperLength) 
									} 								

							set pt_01		[ vectormath::addVector 		$pt_00  $ChainStay(Direction)  -$taper_length ]
					
							set ChainStay(RearWheel)			$pt_00
							set ChainStay(BottomBracket)		{0 0}
					project::setValue Result(Tubes/ChainStay/Start)		    position	{0 0}
					project::setValue Result(Tubes/ChainStay/End)			position	$ChainStay(RearWheel)
				
							set vct_01 		[ vectormath::parallel 			$pt_00 $pt_01 [expr 0.5*$ChainStay(DiameterSS)] ]
							set vct_02 		[ vectormath::parallel 			$pt_01 $ChainStay(BottomBracket) [expr 0.5*$ChainStay(DiameterBB)] ]
							set vct_03 		[ vectormath::parallel 			$pt_01 $ChainStay(BottomBracket) [expr 0.5*$ChainStay(DiameterBB)] left]
							set vct_04 		[ vectormath::parallel 			$pt_00 $pt_01 [expr 0.5*$ChainStay(DiameterSS)] left]
					
							set polygon		[format "%s %s %s %s %s %s" \
													[lindex $vct_01 0] [lindex $vct_02 0] [lindex $vct_02 1] \
													[lindex $vct_03 1] [lindex $vct_03 0] [lindex $vct_04 0] ]												
					project::setValue Result(Tubes/ChainStay)	polygon 	$polygon
			}
			get_ChainStay
			
			
				#
				# --- set HeadTube -------------------------
			proc get_HeadTube {} {
					variable HeadTube 
					variable HeadSet
					variable Steerer
					
							set HeadTube(Direction) 		[ vectormath::unifyVector 	$Steerer(Fork)		$Steerer(Stem) ]
							set Steerer(Direction) 			$HeadTube(Direction)

					project::setValue Result(Tubes/Steerer/Direction)	direction	$HeadTube(Direction)
					project::setValue Result(Tubes/HeadTube/Direction)	direction	$HeadTube(Direction)
							
							set HeadTube(Fork)				[ vectormath::addVector 	$Steerer(Fork)	$HeadTube(Direction)	$HeadSet(Height_Bottom) ]
							set HeadTube(Stem)				[ vectormath::addVector 	$HeadTube(Fork)	$HeadTube(Direction)	$HeadTube(Length) ]
					project::setValue Result(Tubes/HeadTube/Start)		position	$HeadTube(Fork)
					project::setValue Result(Tubes/HeadTube/End)		position	$HeadTube(Stem)
							
							set vct_01 		[ vectormath::parallel 			$HeadTube(Fork) $HeadTube(Stem) [expr 0.5*$HeadTube(Diameter)] ]
							set vct_ht 		[ vectormath::parallel 			$HeadTube(Stem) $HeadTube(Fork) [expr 0.5*$HeadTube(Diameter)] ]
					
							set polygon 	[format "%s %s %s %s" \
													[lindex $vct_01 0] [lindex $vct_01 1] \
													[lindex $vct_ht 0] [lindex $vct_ht 1] ]
					project::setValue Result(Tubes/HeadTube)			polygon 	$polygon
			}
			get_HeadTube
			
																
				#
				# --- set DownTube ------------------------
			proc get_DownTube {} {
					variable HeadTube 
					variable DownTube 
					variable SeatTube 
					variable Saddle 
					variable Steerer 
			
							set vct_ht 		[ vectormath::parallel 			$HeadTube(Stem) $HeadTube(Fork) [expr 0.5*$HeadTube(Diameter)] ]
							set pt_00		[split [ project::getValue 		Result(Tubes/HeadTube/Polygon)	polygon 3 ] , ]
								# puts "   ... $pt_00  ... [ project::getValue Result(Tubes/HeadTube/Polygon	polygon ]"
							set pt_01		[ vectormath::addVector 		$pt_00 $HeadTube(Direction) $DownTube(OffsetHT) ]	;# bottom intersection DownTube/HeadTube
							set pt_02		[ vectormath::cathetusPoint 	{0 0}  $pt_01 [expr 0.5 * $DownTube(DiameterHT) - $DownTube(OffsetBB) ]]
							set vct_01      [ vectormath::parallel 			$pt_02 $pt_01 [expr 0.5 * $DownTube(DiameterHT)] left]	;# DownTube centerline Vector
							set DownTube(Direction)		[ vectormath::unifyVector [lindex $vct_01 0] [lindex $vct_01 1] ]
							set SeatTube(Direction)		[ vectormath::unifyVector {0 0} $Saddle(Position) ]
					project::setValue Result(Tubes/DownTube/Direction)	direction	$DownTube(Direction)

							set vct_02      [ vectormath::parallel 			$pt_02 $pt_01 $DownTube(DiameterHT) left]				;# DownTube upper Vector
							set pt_04       [ vectormath::intersectPoint 	[lindex $vct_02 0] [lindex $vct_02 1] \
																			[lindex $vct_ht 0] [lindex $vct_ht 1] ] ;# top intersection DownTube/HeadTube
							
							set DownTube(BottomBracket)	[ vectormath::intersectPoint [lindex $vct_01 0] [lindex $vct_01 1]  {0 0}	$Saddle(Position) ]
							set DownTube(HeadTube)		[ vectormath::intersectPoint [lindex $vct_01 0] [lindex $vct_01 1]  $Steerer(Fork)	 $Steerer(Stem) ]			
					project::setValue Result(Tubes/DownTube/Start)		position	$DownTube(BottomBracket)
					project::setValue Result(Tubes/DownTube/End)		position	$DownTube(HeadTube)
							
							set length		[ vectormath::length	  		[lindex $vct_02 0] $pt_04 ]
							set pt_10		[ lindex $vct_01 0]
							set pt_11		[ vectormath::addVector			$pt_10 $DownTube(Direction) [expr 0.5*($length - $DownTube(TaperLength) )] ]
							set pt_12		[ vectormath::addVector 		$pt_11 $DownTube(Direction) $DownTube(TaperLength) ]
							set pt_13		[ lindex $vct_01 1]
							set vct_10		[ vectormath::parallel  		$pt_10 $pt_11 [expr 0.5*$DownTube(DiameterBB)] right ]
							set vct_11		[ vectormath::parallel  		$pt_10 $pt_11 [expr 0.5*$DownTube(DiameterBB)] left  ]
							set vct_21		[ vectormath::parallel  		$pt_12 $pt_13 [expr 0.5*$DownTube(DiameterHT)] right ]
							set vct_22		[ vectormath::parallel  		$pt_12 $pt_13 [expr 0.5*$DownTube(DiameterHT)] left  ]
							
							set dir 		[ vectormath::addVector {0 0} $DownTube(Direction) -1] 

							set is_dt_ht	[ tube_intersection	$DownTube(DiameterHT) $dir  $HeadTube(Diameter)     $HeadTube(Direction)  $DownTube(HeadTube) ]				
							set is_dt_st	[ tube_intersection	$DownTube(DiameterBB) $dir  $SeatTube(DiameterBB)   $SeatTube(Direction)  $DownTube(BottomBracket) left]				

							set polygon		[ list            [lindex $vct_10 1] [lindex $vct_10 1] [lindex $vct_21 0]]
							set polygon		[ lappend polygon [project::flatten_nestedList $is_dt_ht]]
							set polygon		[ lappend polygon [lindex $vct_22 0] [lindex $vct_11 1] [lindex $vct_11 1]]					
							set polygon		[ lappend polygon [project::flatten_nestedList $is_dt_st]]				
					project::setValue Result(Tubes/DownTube)			polygon 	[project::flatten_nestedList $polygon]				
			}
			get_DownTube

					
				#
				# --- set TopTube -------------------------
			proc get_TopTube_SeatTube {} {
					variable TopTube 
					variable HeadTube 
					variable SeatTube 
					variable DownTube 
					variable Saddle 
					variable Steerer 

							set vct_st		[ vectormath::parallel 			{0 0} $Saddle(Position) [expr 0.5*$SeatTube(DiameterTT)] ]			
					
							set SeatTube(Direction)		[ vectormath::unifyVector {0 0} $Saddle(Position) ]
					project::setValue Result(Tubes/SeatTube/Direction)	direction 	$Saddle(Position) 	;# direction vector of SeatTube			
							
							set vct_ht 		[ vectormath::parallel 			$HeadTube(Stem) $HeadTube(Fork) [expr 0.5*$HeadTube(Diameter)] ]
							set pt_00		[lindex $vct_ht 0]
							set pt_01		[ vectormath::addVector 		$pt_00 $HeadTube(Direction) -$TopTube(OffsetHT) ]	;# top intersection TopTube/HeadTube
					
							set TopTube(Direction)			[ vectormath::rotatePoint {0 0} {-1 0} $TopTube(Angle) ]	;# direction vector of TopTube
					project::setValue Result(Tubes/TopTube/Direction)	direction 	[ vectormath::rotatePoint {0 0} {-1 0} $TopTube(Angle) ]	;# direction vector of TopTube			
							
							set pt_02		[ vectormath::intersectPoint 	$pt_01 [vectormath::addVector $pt_01  $TopTube(Direction)]  {0 0} $Saddle(Position) ]	;# top intersection TopTube/HeadTube
							set vct_00      [ vectormath::parallel 			$pt_01 $pt_02 [expr 0.5 * $TopTube(DiameterHT)] left]	;# TopTube centerline Vector
							set pt_10       [ vectormath::intersectPoint 	[lindex $vct_00 0] [lindex $vct_00 1]  $Steerer(Fork) $Steerer(Stem)  ]
							set length		[ vectormath::length	     	$pt_10 [lindex $vct_00 1] ]
							set pt_11       [ vectormath::addVector  		$pt_10  $TopTube(Direction)  [expr 0.5*($length - $TopTube(TaperLength)) ] ]
							set pt_12       [ vectormath::addVector  		$pt_11  $TopTube(Direction)  $TopTube(TaperLength) ]
							set pt_13       [ vectormath::intersectPoint 	[lindex $vct_00 0] [lindex $vct_00 1]  {0 0} $Saddle(Position) ]
							set vct_10		[ vectormath::parallel  		$pt_10 $pt_11 [expr 0.5*$TopTube(DiameterHT)] right ]
							set vct_11		[ vectormath::parallel  		$pt_10 $pt_11 [expr 0.5*$TopTube(DiameterHT)] left  ]
							set vct_21		[ vectormath::parallel  		$pt_12 $pt_13 [expr 0.5*$TopTube(DiameterST)] right ]
							set vct_22		[ vectormath::parallel  		$pt_12 $pt_13 [expr 0.5*$TopTube(DiameterST)] left  ]
							set pt_04       [ vectormath::intersectPoint 	[lindex $vct_ht 0] [lindex $vct_ht 1]  [lindex $vct_11 0] [lindex $vct_11 1] ]
							set pt_st       [ vectormath::intersectPoint 	[lindex $vct_st 0] [lindex $vct_st 1]  [lindex $vct_21 0] [lindex $vct_21 1] ]
							set pt_22       [ vectormath::intersectPoint 	[lindex $vct_st 0] [lindex $vct_st 1]  [lindex $vct_22 0] [lindex $vct_22 1] ]		
						
						set TopTube(HeadTube)			$pt_10
						set TopTube(SeatTube)			[ vectormath::intersectPoint [lindex $vct_00 0] [lindex $vct_00 1] {0 0} $Saddle(Position) ]
					project::setValue Result(Tubes/TopTube/Start)		position 	$TopTube(SeatTube)				
					project::setValue Result(Tubes/TopTube/End)			position 	$TopTube(HeadTube)				
					
							set is_tt_ht	[ tube_intersection	$TopTube(DiameterHT) $TopTube(Direction)  $HeadTube(Diameter)	  $HeadTube(Direction)  $TopTube(HeadTube) right]	
							set is_tt_st	[ tube_intersection	$TopTube(DiameterST) $TopTube(Direction)  $SeatTube(DiameterTT)  $SeatTube(Direction)  $TopTube(SeatTube) left ]				

							set polygon		[ project::flatten_nestedList $is_tt_ht]
							set polygon		[ lappend polygon [lindex $vct_10 1] [lindex $vct_21 0]]
							set polygon		[ lappend polygon [project::flatten_nestedList $is_tt_st]]
							set polygon		[ lappend polygon [lindex $vct_22 0] [lindex $vct_11 1]]												
					project::setValue Result(Tubes/TopTube)				polygon 	[project::flatten_nestedList $polygon]

							set pt_00		[ vectormath::intersectPerp 	{0 0} $Saddle(Position)   $pt_st ] 
							set pt_01		[ vectormath::addVector			$pt_00   $SeatTube(Direction)  $SeatTube(Extension) ]
							set length		[ vectormath::length	    	{0 0} $pt_01 ]
							set pt_10 		{0 0}
							set pt_11 		[ vectormath::addVector			$pt_10  $SeatTube(Direction)  [expr 0.5*($length - $SeatTube(TaperLength)) ] ]
							set pt_12 		[ vectormath::addVector			$pt_11  $SeatTube(Direction)  $SeatTube(TaperLength) ]
							set pt_13 		$pt_01
							set vct_10		[ vectormath::parallel  		$pt_10 $pt_11 [expr 0.5*$SeatTube(DiameterBB)] right ]
							set vct_11		[ vectormath::parallel  		$pt_10 $pt_11 [expr 0.5*$SeatTube(DiameterBB)] left  ]
							set vct_21		[ vectormath::parallel  		$pt_12 $pt_13 [expr 0.5*$SeatTube(DiameterTT)] right ]
							set vct_22		[ vectormath::parallel  		$pt_12 $pt_13 [expr 0.5*$SeatTube(DiameterTT)] left  ]				
					
							set SeatTube(TopTube)		$pt_01					
							set SeatTube(BottomBracket)	{0 0}
					project::setValue Result(Tubes/SeatTube/Start)		position 	$SeatTube(BottomBracket)			
					project::setValue Result(Tubes/SeatTube/End)		position 	$SeatTube(TopTube)				
					
							set polygon	[format "%s %s %s %s %s %s %s %s" \
											[lindex $vct_10 0]  [lindex $vct_10 1] \
											[lindex $vct_21 0]  [lindex $vct_21 1] \
											[lindex $vct_22 1]  [lindex $vct_22 0] \
											[lindex $vct_11 1]  [lindex $vct_11 0] ]
					project::setValue Result(Tubes/SeatTube)			polygon 	$polygon									
			}
			get_TopTube_SeatTube
			
			
				#
				# --- set SeatStay ------------------------
			proc get_SeatStay {} {
					variable SeatStay 
					variable ChainStay 
					variable TopTube 
					variable SeatTube 
					variable RearWheel 
					variable RearDrop 

							set pt_00		[ vectormath::addVector		$TopTube(SeatTube)  $SeatTube(Direction)  $SeatStay(OffsetTT) ] ; # intersection seatstay / seattube
							set pt_01		[ lindex [ vectormath::parallel  	$RearWheel(Position)  $pt_00   $RearDrop(OffsetSSPerp) ] 0 ]
					
							set SeatStay(Direction)     [ vectormath::unifyVector $pt_01 $pt_00 ]
					project::setValue Result(Tubes/SeatStay/Direction)	direction	$SeatStay(Direction)	;# direction vector of SeatStay	
					
							set pt_10		[ vectormath::addVector		$pt_01  $SeatStay(Direction)  $RearDrop(OffsetSS) ]

								# -- exception if Tube is shorter than taper length
								set tube_length			[ vectormath::length $pt_10 $pt_00 ]
									if { [expr $tube_length - $SeatStay(TaperLength) -50] < 0 } {
										puts "         ... exception:  SeatStay  TaperLength ... $tube_length / $SeatStay(TaperLength)"
										set taper_length	[ expr $tube_length -50 ]
										puts "                         -> $taper_length"
									} else {
										set taper_length	$SeatStay(TaperLength) 
									} 								
								
							set pt_11		[ vectormath::addVector		$pt_10  $SeatStay(Direction)  $taper_length ]
							set pt_12		$pt_00
							set vct_10 		[ vectormath::parallel $pt_10 $pt_11 [expr 0.5*$SeatStay(DiameterCS)] ]
							set vct_11 		[ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$SeatStay(DiameterST)] ]
							set vct_12 		[ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$SeatStay(DiameterST)] left]
							set vct_13 		[ vectormath::parallel $pt_10 $pt_11 [expr 0.5*$SeatStay(DiameterCS)] left]
					
						set SeatStay(SeatTube)		$pt_00		
						set SeatStay(RearWheel)		$pt_10
					project::setValue Result(Tubes/SeatStay/Start)		position 	$SeatStay(RearWheel)				
					project::setValue Result(Tubes/SeatStay/End)		position 	$SeatStay(SeatTube)				
							
							set dir 		[ vectormath::addVector {0 0} $SeatStay(Direction) -1] 
							set offset		[ expr 0.5 * ($SeatTube(DiameterTT) - $SeatStay(DiameterST)) ]
							set is_ss_st	[ tube_intersection	$SeatStay(DiameterST) $dir  $SeatTube(DiameterTT)	  $SeatTube(Direction)  $SeatStay(SeatTube)  right $offset]	
						
						set SeatStay(debug) 			$is_ss_st
							
							set polygon		[ project::flatten_nestedList  $is_ss_st ]
							set polygon		[ lappend polygon 	[lindex $vct_12 0] [lindex $vct_13 0] \
																[lindex $vct_10 0] [lindex $vct_11 0] ]										
					project::setValue Result(Tubes/SeatStay)			polygon 	[project::flatten_nestedList $polygon]					
						
						#
						# --- set SeatStay / ChainStay - Intersection
							set ChainStay(SeatStay_IS)		[ vectormath::intersectPoint $SeatStay(SeatTube) $SeatStay(RearWheel) $ChainStay(BottomBracket) $ChainStay(RearWheel) ];# intersection of ChainStay and SeatStay centerlines	
					project::setValue Result(Tubes/ChainStay/SeatStay_IS)	position	$ChainStay(SeatStay_IS) ;# Point on the Ground perp. to BB
			}
			get_SeatStay


				#
				# --- set ForkBlade -----------------------
			proc get_Fork {} {
					variable Fork
					variable ForkBlade
					variable Steerer
					variable HeadTube
					variable FrontWheel
					
							set pt_00		$Steerer(Fork)
							set pt_99		$FrontWheel(Position)
							set pt_01		[ vectormath::addVector $pt_00 $HeadTube(Direction) -$Fork(BladeOffsetCrown) ]
							set pt_02		[ lindex [ vectormath::parallel  $pt_00  $pt_01  $Fork(BladeOffsetCrownPerp) left ] 1] ;# centerpoint of Blade in ForkCrown
								
								# -- exception if Blade is shorter than taper length
								set forkblade_length			[ vectormath::length $pt_02 $pt_99 ]
									if { [expr $forkblade_length - $Fork(BladeTaperLength) -50] < 0 } {
										puts "         ... exception:  Forkblade TaperLength ... $forkblade_length / $Fork(BladeTaperLength)"
										set taper_length	[ expr $forkblade_length -50 ]
										puts "                         -> $taper_length"
									} else {
										set taper_length	$Fork(BladeTaperLength) 
									} 
								
								set hlp_00		{0 0}											;# point where Taper begins
								set hlp_01		[ list $taper_length	$Fork(BladeOffset) ]	;# point where Taper ends
								set vct_taper	[ vectormath::unifyVector 	$hlp_00 $hlp_01 ]	;# direction caused by taper offset
								set hlp_02		[ vectormath::addVector 	$hlp_01 [vectormath::scalePointList {0 0} $vct_taper $Fork(BladeOffsetDO) ] ]
								set vct_dropout	[ vectormath::parallel 		$hlp_00	$hlp_02 	$Fork(BladeOffsetDOPerp) left]
								set hlp_03		[ lindex $vct_dropout 1 ]								;# location of Dropout in reference to point where Taper begins
							set offsetDO		[ expr [ lindex $hlp_03 0] - $taper_length ]
							set offsetDO_Perp	[ lindex $hlp_03 1]
							set pt_03			[ vectormath::cathetusPoint	$pt_02  $pt_99  $offsetDO_Perp  opposite ]	;# point on direction of untapered area of ForkBlade perp through FrontWheel

							set ForkBlade(Direction)	[ vectormath::unifyVector $pt_03 $pt_02 ]
					project::setValue Result(Tubes/ForkBlade/Direction)	direction	$ForkBlade(Direction)	;# direction vector of ForkBlade
									
							set pt_04			[ vectormath::addVector		$pt_03  [vectormath::scalePointList {0 0} $ForkBlade(Direction) $offsetDO ] ]	;# point on direction of untapered area of ForkBlade perp through Blade Tip
								set vct_offset	[ vectormath::parallel		$pt_02  $pt_04  $Fork(BladeOffset) left]	;
							set pt_10		$pt_99						;# Dropout
							set pt_11		[ lindex $vct_offset 1 ]	;# Fork Blade Tip
							set pt_12		[ vectormath::addVector		$pt_04	[vectormath::scalePointList {0 0} $ForkBlade(Direction) $taper_length ] ] ;# point on direction of untapered area where tapering starts
																		;# Fork Blade taper start
							set pt_13		$pt_02						;# Crown Fork Blade center
					project::setValue Result(Tubes/ForkBlade/Start)		position 	$pt_13				
					project::setValue Result(Tubes/ForkBlade/End)		position 	$pt_11


					switch -glob $project::Rendering(Fork) {
							SteelLugged {
										set vct_10 		[ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$Fork(BladeDiameterDO)] ]
										set vct_11 		[ vectormath::parallel $pt_12 $pt_13 [expr 0.5*$Fork(BladeWith)] ]
										set vct_12 		[ vectormath::parallel $pt_12 $pt_13 [expr 0.5*$Fork(BladeWith)] left]
										set vct_13 		[ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$Fork(BladeDiameterDO)] left ]
								
										#set polygon	[format "%s %s %s %s %s %s" \
														[lindex $vct_10 0]  [lindex $vct_11 0] [lindex $vct_11 1]  \
														[lindex $vct_12 1]  [lindex $vct_12 0] [lindex $vct_13 0] ]					
										set polygon	[format "%s %s %s %s %s %s" \
														[lindex $vct_11 1]  [lindex $vct_11 0] [lindex $vct_10 0]  \
														[lindex $vct_13 0]  [lindex $vct_12 0] [lindex $vct_12 1] ]					
										project::setValue Result(Tubes/ForkBlade)		polygon 	$polygon
										
										set Fork(DropoutDirection)	[ vectormath::unifyVector $pt_12 $pt_11 ]					
										project::setValue Result(Lugs/Dropout/Front/Direction)	direction	$Fork(DropoutDirection)				
									}
							Composite 	{
										project::setValue Result(Tubes/ForkBlade)		polygon		[ set_compositeFork ]
									}
							Suspension* {
										project::setValue Result(Tubes/ForkBlade)		polygon		[ set_suspensionFork ]
									}
					}
					

							
						#
						# --- set Fork Dropout --------------------

						#
						# --- set Fork Crown ----------------------
							set Fork(CrownDirection)	$Steerer(Direction)					
					project::setValue Result(Lugs/ForkCrown/Direction)		direction	$Fork(CrownDirection)				
			}
			get_Fork			


				#
				# --- set Steerer -------------------------
			proc get_Steerer {} {
					variable HeadTube
					variable Steerer

					project::setValue Result(Tubes/Steerer/End)		position 	$Steerer(Stem)
							
							set vct_01 		[ vectormath::parallel 			$Steerer(Fork)  $Steerer(Stem) [expr 0.5 * ($HeadTube(Diameter)-7)] ]
							set vct_ht 		[ vectormath::parallel 			$Steerer(Stem)	$Steerer(Fork)  [expr 0.5 * ($HeadTube(Diameter)-7)] ]
							set polygon		[format "%s %s %s %s" \
													[lindex $vct_01 0] [lindex $vct_01 1] \
													[lindex $vct_ht 0] [lindex $vct_ht 1] ]					
					project::setValue Result(Tubes/Steerer)			polygon 	$polygon
			}
			get_Steerer


				#					
				# --- set SeatPost ------------------------
			proc get_SeatPost {} {
					variable Saddle
					variable TopTube
					variable SeatTube
					
							set pt_00		$Saddle(Position)
							set pt_99		{0 0}

							set pt_01		[ vectormath::addVector $pt_00 [list $Saddle(SeatPost_x) $Saddle(SeatPost_y)] ]
							set vct_01		[ vectormath::parallel  $pt_01 [ vectormath::addVector $pt_01 {100 0}] 35 ]
							set vct_05		[ vectormath::parallel  $pt_01 [ vectormath::addVector $pt_01 {100 0}] 20 ]
							set vct_06		[ vectormath::parallel  $pt_01 [ vectormath::addVector $pt_01 {100 0}] 30 ]
							set pt_02		[ vectormath::intersectPoint [lindex $vct_01 0] [lindex $vct_01 1]  {0 0} $Saddle(Position) ]
							
							set pt_10		$pt_01
							set pt_11		$pt_02
							set pt_12		$TopTube(SeatTube)
							set vct_10		[ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * $Saddle(SeatPost_DM)] ]
							set vct_11		[ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * $Saddle(SeatPost_DM)] left]
							set vct_15		[ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * $Saddle(SeatPost_DM) -5] left]
							set pt_20		[ vectormath::intersectPoint [lindex $vct_05 0] [lindex $vct_05 1]  [lindex $vct_15 0] [lindex $vct_15 1] ]
							set pt_21		[ vectormath::addVector $pt_10 { 5 0}]
							set pt_22		[ vectormath::addVector $pt_10 {-5 0}]
							set pt_23		[ vectormath::intersectPoint [lindex $vct_06 0] [lindex $vct_06 1]  [lindex $vct_10 0] [lindex $vct_10 1] ]

							set polygon		[ list $pt_21 $pt_22 $pt_23 ]
							set polygon		[ lappend polygon [lindex $vct_10 0]  [lindex $vct_10 1]]
							set polygon		[ lappend polygon [lindex $vct_11 1]  [lindex $vct_11 0]]
							set polygon		[ lappend polygon $pt_20 ]
					project::setValue Result(Components/SeatPost)	polygon 	[project::flatten_nestedList $polygon]
			}
			get_SeatPost


				#
				# --- set HeadSet -------------------------
			proc get_HeadSet {} {
					variable HeadTube
					variable HeadSet
					variable Steerer
					
							set pt_10		$HeadTube(Fork)
							set pt_12		$Steerer(Fork)
							set pt_11		[ vectormath::addVector $pt_12 $HeadTube(Direction) [expr 0.5 * $HeadSet(Height_Bottom)]]
						if {$HeadSet(Height_Bottom) > 8} { 
							set vct_10		[ vectormath::parallel  $pt_10 $pt_11 [expr 0.5 * $HeadTube(Diameter)] ]
							set vct_11		[ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * $HeadSet(Diameter) ] ]
							set vct_12		[ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * $HeadSet(Diameter) ] left]
							set vct_13		[ vectormath::parallel  $pt_10 $pt_11 [expr 0.5 * $HeadTube(Diameter)] left]			
							set polygon		[list 	[lindex $vct_10 0]  [lindex $vct_11 0] \
													[lindex $vct_12 0]  [lindex $vct_11 0] \
													[lindex $vct_11 1] \
													[lindex $vct_12 1]  [lindex $vct_12 0] [lindex $vct_13 0] ]
						} else {
							if {$HeadSet(Height_Bottom) < 0.1} { 
								set polygon		[list 0 0 0 0]
							} else {
								set SteererDM 	28.6 ;# believe that there is no not integrated Headset with this size
								set vct_11		[ vectormath::parallel  $pt_10 $pt_12 [expr 0.5 * $SteererDM ] ]
								set vct_12		[ vectormath::parallel  $pt_10 $pt_12 [expr 0.5 * $SteererDM ] left]
								set polygon		[list 	[lindex $vct_11 0]  [lindex $vct_11 1] \
														[lindex $vct_12 1]  [lindex $vct_12 0] ]
							}
						}
					
					project::setValue Result(Components/HeadSet/Bottom)	polygon 	[project::flatten_nestedList $polygon]

							if {$HeadSet(Height_Top) < 2} {	set HeadSet(Height_Top) 2}
							if {$HeadSet(Height_Top) > 8} {	
									set majorDM 	$HeadSet(Diameter)
									set height_00	[expr 0.5 * $HeadSet(Height_Top)]
							} else {
									set majorDM 	$HeadTube(Diameter)
									set height_00	1
							}
							set pt_12		$HeadTube(Stem)
							set pt_11		[ vectormath::addVector $pt_12 $HeadTube(Direction) $height_00]
							set pt_10		[ vectormath::addVector $pt_11 $HeadTube(Direction) [expr $HeadSet(Height_Top) - $height_00]]
								# puts "\n\n"
								# puts "   pt_10:  $pt_10"
								# puts "   pt_11:  $pt_11"
								# puts "   pt_12:  $pt_12"
								# puts "\n\n"
								
					set HeadSet(Stem) 				$pt_10
							set vct_10		[ vectormath::parallel  $pt_10 $pt_11 [expr 0.5 * $HeadSet(ShimDiameter)] ]
							set vct_11		[ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * $majorDM ] ]
							set vct_12		[ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * $majorDM ] left]
							set vct_13		[ vectormath::parallel  $pt_10 $pt_11 [expr 0.5 * $HeadSet(ShimDiameter)] left]			
							set polygon		[list 	[lindex $vct_10 0]  [lindex $vct_11 0] \
													[lindex $vct_12 0]  [lindex $vct_11 0] \
													[lindex $vct_11 1] \
													[lindex $vct_12 1]  [lindex $vct_12 0] [lindex $vct_13 0] ]
													
					project::setValue Result(Components/HeadSet/Top)	polygon 	[project::flatten_nestedList $polygon]
			}			
			get_HeadSet


				#
				# --- set Stem ----------------------------
			proc get_Stem {} {
					variable HeadTube
					variable HandleBar
					variable HeadSet
					variable Steerer
					variable Stem
					
							set pt_00		$HandleBar(Position)
							set pt_01		$Steerer(Stem)
							set pt_02		$HeadSet(Stem)

                            # -- ceck coincidence
                            set checkStem           [ vectormath::checkPointCoincidence $pt_00 $pt_01]
                            if {$checkStem == 0} {
                                # puts "   ... no Stem required"
                                project::setValue Result(Components/Stem)	polygon 	{}
                                return
                            }

							set Stem(Direction) 	[ vectormath::unifyVector $pt_01 $pt_00 ]
							set angle							[ vectormath::angle {1 0}	{0 0}	$Stem(Direction) ]
							set clamp_SVGPolygon 	"-18.8336,-17.9999 -15.7635,-18.3921 -13.3549,-19.887 -11.1307,-22.1168 -10.0644,-24.1389 -9.7316,-24.4732 -9.8958,-23.3099 -10.3089,-21.9026 -11.1479,-19.9125 -12.0719,-17.777 -15.3406,-11.3784 -16.1873,-10.0012 -17.4384,-9.0427 -18.8336,-8.3572 -17.4384,-9.0427 -16.1873,-10.0012 -15.3406,-11.3784 -12.0719,-17.777 -11.1479,-19.9125 -10.3089,-21.9026 -9.8958,-23.3099 -9.7316,-24.4732 -9.4316,-24.7774 -8.6838,-24.9999 -0.8,-24.9999 -0.8,-15.8802 0.8,-15.8802 0.8,-24.9998 5.6669,-24.9998 6.3699,-24.8858 6.9818,-24.5172 7.4284,-24.07 13.0499,-18.7437 13.049,-23.6727 12.6125,-24.0796 12.5936,-20.4963 12.6125,-24.0796 7.4284,-24.07 13.2207,-18.5818 15.8552,-15.7422 17.8482,-13.2995 19.8206,-9.913 20.8437,-7.292 21.5329,-4.4455 21.8005,-2.0944 21.9,0.0001 21.8005,2.0946 21.5329,4.4457 20.8437,7.2922 19.8206,9.9132 17.8482,13.2997 15.8552,15.7424 13.2207,18.582 7.4284,24.0702 12.6125,24.0798 12.5936,20.4965 12.6125,24.0798 13.049,23.6729 13.0499,18.7439 7.4284,24.0702 6.9818,24.5174 6.3699,24.886 5.6669,25 0.8,25 0.8,15.8804 4.18,15.3448 7.4163,14.0676 10.1772,12.2159 12.523,9.7973 14.299,6.9605 15.506,3.5323 15.9,0.0001 15.506,-3.5321 14.299,-6.9603 12.523,-9.7971 10.1772,-12.2157 7.4163,-14.0674 4.18,-15.3446 0.8,-15.8802 -0.8,-15.8802 -3.4694,-15.544 -6.2265,-14.634 -9.2433,-12.9378 -11.6453,-10.8246 -13.5388,-8.3403 -14.8801,-5.6139 -15.6719,-2.6977 -15.9,0.0001 -15.6719,2.6979 -14.8801,5.6141 -13.5388,8.3405 -11.6453,10.8248 -9.2433,12.938 -6.2265,14.6342 -3.4694,15.5442 -0.8,15.8804 0.8,15.8804 -0.8,15.8804 -0.8,25.0001 -8.6838,25.0001 -9.3776,24.6754 -9.7467,23.9553 -9.8958,23.3101 -10.3089,21.9028 -11.1479,19.9127 -12.0719,17.7772 -15.3406,11.3786 -16.1873,10.0014 -17.4384,9.0429 -18.8336,8.3574 -17.4384,9.0429 -16.1873,10.0014 -15.3406,11.3786 -12.0719,17.7772 -11.1479,19.9127 -10.3089,21.9028 -9.8958,23.3101 -9.7467,23.9553 -11.1307,22.117 -13.3549,19.8872 -15.7635,18.3923 -18.8336,18.0001 "
							set clamp_SVGPolygon 	"-20.2619,-17 -16.6918,-17.4561 -13.8908,-19.1945 -11.3044,-21.7874 -10.0644,-24.1389 -9.7316,-24.4732 -9.8958,-23.3099 -10.3089,-21.9026 -11.1479,-19.9125 -12.0719,-17.777 -15.3406,-11.3784 -16.1873,-10.0012 -17.4384,-9.0427 -18.8336,-8.3572 -17.4384,-9.0427 -16.1873,-10.0012 -15.3406,-11.3784 -12.0719,-17.777 -11.1479,-19.9125 -10.3089,-21.9026 -9.8958,-23.3099 -9.7316,-24.4732 -9.4316,-24.7774 -8.6838,-24.9999 -0.8,-24.9999 -0.8,-15.8802 0.8,-15.8802 0.8,-24.9998 5.6669,-24.9998 6.3699,-24.8858 6.9818,-24.5172 7.4284,-24.07 13.0499,-18.7437 13.049,-23.6727 12.6125,-24.0796 12.5936,-20.4963 12.6125,-24.0796 7.4284,-24.07 13.2207,-18.5818 15.8552,-15.7422 17.8482,-13.2995 19.8206,-9.913 20.8437,-7.292 21.5329,-4.4455 21.8005,-2.0944 21.9,0.0001 21.8005,2.0946 21.5329,4.4457 20.8437,7.2922 19.8206,9.9132 17.8482,13.2997 15.8552,15.7424 13.2207,18.582 7.4284,24.0702 12.6125,24.0798 12.5936,20.4965 12.6125,24.0798 13.049,23.6729 13.0499,18.7439 7.4284,24.0702 6.9818,24.5174 6.3699,24.886 5.6669,25 0.8,25 0.8,15.8804 4.18,15.3448 7.4163,14.0676 10.1772,12.2159 12.523,9.7973 14.299,6.9605 15.506,3.5323 15.9,0.0001 15.506,-3.5321 14.299,-6.9603 12.523,-9.7971 10.1772,-12.2157 7.4163,-14.0674 4.18,-15.3446 0.8,-15.8802 -0.8,-15.8802 -3.4694,-15.544 -6.2265,-14.634 -9.2433,-12.9378 -11.6453,-10.8246 -13.5388,-8.3403 -14.8801,-5.6139 -15.6719,-2.6977 -15.9,0.0001 -15.6719,2.6979 -14.8801,5.6141 -13.5388,8.3405 -11.6453,10.8248 -9.2433,12.938 -6.2265,14.6342 -3.4694,15.5442 -0.8,15.8804 0.8,15.8804 -0.8,15.8804 -0.8,25.0001 -8.6838,25.0001 -9.3776,24.6754 -9.7467,23.9553 -9.8958,23.3101 -10.3089,21.9028 -11.1479,19.9127 -12.0719,17.7772 -15.3406,11.3786 -16.1873,10.0014 -17.4384,9.0429 -18.8336,8.3574 -17.4384,9.0429 -16.1873,10.0014 -15.3406,11.3786 -12.0719,17.7772 -11.1479,19.9127 -10.3089,21.9028 -9.8958,23.3101 -9.7467,23.9553 -11.1307,22.117 -13.8952,19.3455 -16.8889,17.4875 -20.7048,17 "

								set polygon			[ string map {"," " "}  $clamp_SVGPolygon ]
								set polygon			[ coords_flip_y $polygon]
								set polygon 		[ coords_addVector $polygon [list $HandleBar(Distance) $HandleBar(Height)] ]
								set polygon			[ vectormath::rotatePointList $HandleBar(Position) $polygon $angle ]
							
							set polygonLength	[ llength $polygon  ]
							set pt_099 			[ list [lindex $polygon 0] [lindex $polygon 1] ]
							set pt_000 			[ list [lindex $polygon $polygonLength-2] [lindex $polygon $polygonLength-1] ]
							set stemWidth		[ vectormath::length $pt_099 $pt_000 ]
							set stemDiameter	34
							set vct_099			[ vectormath::parallel $pt_01 $pt_00 [expr 0.5 * $stemWidth		] left]
							set vct_000			[ vectormath::parallel $pt_01 $pt_00 [expr 0.5 * $stemWidth		] ]
							set vct_010			[ vectormath::parallel $pt_02 $pt_01 [expr 0.5 * $stemDiameter	+ 4 ] ]
							set pt_095			[ vectormath::intersectPoint [lindex $vct_099 0] [lindex $vct_099 1]  [lindex $vct_010 0] [lindex $vct_010 1] ]
							set pt_50			[ vectormath::intersectPerp	$pt_01 $pt_02 $pt_095 ]
							set pt_51			[ vectormath::addVector	$pt_50	[ vectormath::unifyVector {0 0} $HeadTube(Direction) 2] ]
							set pt_005			[ vectormath::intersectPoint [lindex $vct_000 0] [lindex $vct_000 1]  [lindex $vct_010 0] [lindex $vct_010 1] ]
							set pt_12			[ vectormath::intersectPerp	$pt_01 $pt_02 $pt_005 ]
							set pt_11			[ vectormath::addVector	$pt_12 [ vectormath::unifyVector {0 0} $HeadTube(Direction) -2] ]
							set vct_020			[ vectormath::parallel $pt_11 $pt_51 [expr 0.5 * $stemDiameter ] ]
							set vct_021			[ vectormath::parallel $pt_11 $pt_51 [expr 0.5 * $stemDiameter ] left ]
							set vct_030			[ vectormath::parallel $HeadSet(Stem) $pt_51 [expr 0.5 * $HeadSet(ShimDiameter) ] ];# ShimDiameter from HeadSet definition above
							set vct_031			[ vectormath::parallel $HeadSet(Stem) $pt_51 [expr 0.5 * $HeadSet(ShimDiameter) ] left ]
							set vct_040			[ vectormath::parallel [lindex  $vct_021 1] [lindex  $vct_020 1] 5  left]
							
							set polygon			[ lappend polygon 	$pt_005 \
																	[lindex  $vct_020 0] [lindex  $vct_021 0] [lindex  $vct_020 0] \
																	[lindex  $vct_030 0] [lindex  $vct_031 0] [lindex  $vct_021 0] \
																	[lindex  $vct_021 1] [lindex  $vct_020 1] [lindex  $vct_021 1] \
																	[lindex  $vct_040 0] [lindex  $vct_040 1] [lindex  $vct_020 1] \
																	$pt_095 ]													
					project::setValue Result(Components/Stem)	polygon 	[project::flatten_nestedList $polygon]
			}
			get_Stem

						
				#
				# --- fill Result Values ------------------
			proc fill_resultValues {} {					
					variable BottomBracket
					variable HeadTube
					variable TopTube
					variable Steerer
					variable RearWheel
					variable FrontWheel
					variable Saddle
                    variable HandleBar
					
							# puts ""
							# puts "       ... fill_resultValues"
							# puts "      -------------------------------" 
							# puts "           "

							
						# --- BottomBracket
						#
					set position	$BottomBracket(height)

							# --- BottomBracket/Height
							#
						set value		[ format "%.2f" [lindex $position 0] ]	
							# puts "                  ... $value"
						project::setValue Result(Length/BottomBracket/Height) value $value


						# --- HeadTube ----------------------------------------
						#
					set position	$HeadTube(Stem)

							# --- HeadTube/ReachLength
							#
							# puts "                ... [ frame_geometry::object_values		HeadTube Stem			{0 0} ]" 
						set value		[ format "%.2f" [lindex $position 0] ]	
							# puts "                  ... $value"
						# 3.2.76 project::setValue Temporary(HeadTube/ReachLength) value $value
						project::setValue Result(Length/HeadTube/ReachLength) value $value

							# --- HeadTube/StackHeight
							#
							# puts "                ... [ frame_geometry::object_values		HeadTube Stem			{0 0} ]" 
						set value		[ format "%.2f" [lindex $position 1] ]	
							# puts "                  ... $value"
						# 3.2.76 project::setValue Temporary(HeadTube/StackHeight) value $value
						project::setValue Result(Length/HeadTube/StackHeight) value $value



						# --- SeatTube ----------------------------------------
							#
					set position	[ frame_geometry::object_values		SeatTube/End	position	{0 0} ]
					
					
                                # --- SeatTube/TubeLength -------------------------
							#
							# puts "                   ... [ frame_geometry::object_values		SeatTube TopTube	{0 0} ]" 
						set value		[ format "%.2f" [ expr hypot([lindex $position 0],[lindex $position 1]) ] ]
							# puts "                  ... $value"
						# 3.2.76    project::setValue Temporary(SeatTube/TubeLength) value $value
						project::setValue Result(Length/SeatTube/TubeLength) value $value
						
                                # --- SeatTube/TubeHeight -------------------------
							#
							# puts "                   ... [ frame_geometry::object_values		SeatTube TopTube	{0 0} ]" 
						set value		[ format "%.2f" [lindex $position 1] ]
							# puts "                  ... $value"
						# 3.2.76 project::setValue Temporary(SeatTube/TubeHeight) value $value
						project::setValue Result(Length/SeatTube/TubeHeight) value $value

						
						# --- TopTube/VirtualLength ---------------------------
						#
					set position	[ vectormath::intersectPoint [list -500 [lindex $TopTube(HeadTube) 1]]   $TopTube(HeadTube)  {0 0} $Saddle(Position) ]
						set value		[ format "%.2f" [expr [lindex $TopTube(HeadTube) 0] - [lindex $position 0] ] ]
							# puts "                  ... $value"
						project::setValue Result(Length/TopTube/VirtualLength) value $value


                        # --- Saddle/Offset_BB --------------------------------
						#
					set position	$Saddle(Position)					
						set value		[ format "%.2f" [expr -1 * [lindex $position 0]] ]	
							# puts "                  ... $value"
						project::setValue Result(Length/Saddle/Offset_BB) value $value

					
                        # --- Saddle/Offset_HB --------------------------------
						#
					set position_Saddle	    $Saddle(Position)
					set position_HandleBar	$HandleBar(Position)					
						set value		[ format "%.2f" [expr [lindex $position_Saddle 1] - [lindex $position_HandleBar 1]] ]	
							# puts "                  ... $value"
						project::setValue Result(Length/Saddle/Offset_HB) value $value

					
						# --- WheelPosition/front/diagonal --------------------
						#
					set position	$FrontWheel(Position)					
							# puts "                ... $frameCoords::FrontWheel" 						
						set value		[ format "%.2f" [expr { hypot( [lindex $position 0], [lindex $position 1] ) }] ]	
							# puts "                  ... $value"
						project::setValue Result(Length/FrontWheel/diagonal) value $value

					
						# --- WheelPosition/front/horizontal ------------------
						#
					set position	$FrontWheel(Position)					
							# puts "                ... $frameCoords::FrontWheel" 
						set value		[ format "%.2f" [lindex $position 0] ]	
							# puts "                  ... $value"
						project::setValue Result(Length/FrontWheel/horizontal) value $value

					
						# --- WheelPosition/rear/horizontal -------------------
						#
					set position	$RearWheel(Position)
							# puts "                ... $frameCoords::RearWheel" 
						set value		[ format "%.2f" [expr -1 * [lindex $position 0]] ]	
							# puts "                  ... $value"
						project::setValue Result(Length/RearWheel/horizontal) value $value
                        
                        
						# --- Result Angles  ----------------------------------
						#
                    proc get_resultAngle {position point_1 point_2 } {
                            set angle_p1    [ vectormath::dirAngle $position $point_1 ]
                            set angle_p2    [ vectormath::dirAngle $position $point_2 ]
                            set angle_ext   [expr $angle_p2 - $angle_p1]
                                # puts "     angle_p1  -> $angle_p1"
                                # puts "     angle_p2  -> $angle_p2"
                                # puts "     angle_ext -> $angle_ext"
                            if {$angle_ext < 0 } {set angle_ext [expr $angle_ext +360]}                 
                            return $angle_ext                  
			}
                    set BB_Position             {0 0}	
                    set SeatStay(SeatTube)		[ frame_geometry::object_values		SeatStay/End	       position	]
                    set TopTube(SeatTube)		[ frame_geometry::object_values		TopTube/Start	       position	]
                    set TopTube(Steerer)		[ frame_geometry::object_values		TopTube/End		       position	]
                    set Steerer(Stem)			[ frame_geometry::object_values		Steerer/End		       position	]
                    set Steerer(Fork)			[ frame_geometry::object_values  	Steerer/Start	       position	]
                    set DownTube(Steerer)		[ frame_geometry::object_values  	DownTube/End	       position	]
                    set DownTube(BBracket)		[ frame_geometry::object_values		DownTube/Start	       position ]
                    set ChainSt_SeatSt_IS		[ frame_geometry::object_values  	ChainStay/SeatStay_IS  position ]
                     
                    project::setValue Result(Angle/HeadTube/TopTube)        value    [ get_resultAngle $TopTube(Steerer)      $Steerer(Stem)      $TopTube(SeatTube)  ]
                    project::setValue Result(Angle/HeadTube/DownTube)       value    [ get_resultAngle $DownTube(Steerer)     $BB_Position        $Steerer(Fork)      ]
                    project::setValue Result(Angle/SeatTube/TopTube)        value    [ get_resultAngle $TopTube(SeatTube)     $BB_Position        $TopTube(Steerer)   ]
                    project::setValue Result(Angle/SeatTube/SeatStay)       value    [ get_resultAngle $SeatStay(SeatTube)    $ChainSt_SeatSt_IS  $BB_Position        ]
                    project::setValue Result(Angle/BottomBracket/DownTube)  value    [ get_resultAngle $BB_Position           $DownTube(Steerer)  $TopTube(SeatTube)  ]
                    project::setValue Result(Angle/BottomBracket/ChainStay) value    [ get_resultAngle $BB_Position           $TopTube(SeatTube)  $ChainSt_SeatSt_IS  ]
                    project::setValue Result(Angle/SeatStay/ChainStay)      value    [ get_resultAngle $ChainSt_SeatSt_IS     $BB_Position        $SeatStay(SeatTube) ]                        
			}
			fill_resultValues
			# fill_resultValues $domProject


				#
				# --- set FrontDerailleurMount ------------
			proc get_DerailleurMountFront {} {
					variable SeatTube
					variable FrontDerailleur

						set FrontDerailleur(Mount)	[ vectormath::rotatePoint	{0 0} [ list $FrontDerailleur(Distance) [expr -1.0*$FrontDerailleur(Offset)] ] [expr 180 - $SeatTube(Angle)] ]
					
					project::setValue Result(Position/DerailleurMountFront)	position	$FrontDerailleur(Mount)
					# puts "    ... \$FrontDerailleur(Mount) $FrontDerailleur(Mount)"
			}
			get_DerailleurMountFront
			
			
				#
				# --- set BrakePosition - Rear -------------
			proc get_BrakePositionRear {} {
					variable RearBrake
					variable RearWheel
					variable SeatStay

                    set RimBrakeRadius	[ expr 0.5 * $RearWheel(RimDiameter) ]
                    
                    set pt_00			$RearWheel(Position)
                    set pt_01           [split [ project::getValue Result(Tubes/SeatStay/Start)	position ] , ]
                    set pt_02           [split [ project::getValue Result(Tubes/SeatStay/End)	position ] , ]
                    set pt_03           [split [ project::getValue Result(Tubes/SeatStay/Polygon)	polygon 8 ] , ]
                    set pt_04           [split [ project::getValue Result(Tubes/SeatStay/Polygon)	polygon 9 ] , ]
                    set pt_05			[ vectormath::intersectPerp	$pt_04 $pt_03 $pt_00 ]	;# point on SeatStay through RearWheel
                    set vct_01			[ vectormath::parallel $pt_03 $pt_05 $RearBrake(Offset) ]
                    set pt_06			[ lindex $vct_01 1 ]
                    set dist_00			[ vectormath::length $pt_00 $pt_06 ]
                    set dist_00_Ortho	[ expr sqrt(pow($RimBrakeRadius,2)  - pow($dist_00,2)) ]
                            
                    set pt_10           [ vectormath::addVector	$pt_06 [ vectormath::unifyVector {0 0} $SeatStay(Direction) $dist_00_Ortho] ]
                    set pt_12           [ vectormath::addVector	$pt_06 [ vectormath::unifyVector {0 0} $SeatStay(Direction) [expr $RearBrake(LeverLength) + $dist_00_Ortho] ] ]				
                    set pt_13           [ vectormath::intersectPerp $pt_03 $pt_04 $pt_10 ]
                    set pt_14           [ vectormath::intersectPerp	$pt_03 $pt_04 $pt_12 ]
                        # set pt_14     [ vectormath::intersectPerp	$pt_01 $pt_02 $pt_12 ]
                                                
                    
                    set RearBrake(Shoe)         $pt_10
                    set RearBrake(Help)         $pt_12
                    set RearBrake(Definition)   $pt_13
                    set RearBrake(Mount)        $pt_14
                            
                    project::setValue Result(Position/BrakeRear)	position	$RearBrake(Shoe)
					
						variable DEBUG_Geometry
						# set DEBUG_Geometry(pt_21) "[lindex $pt_01 0],[lindex $pt_01 1]"
						# set DEBUG_Geometry(pt_22) "[lindex $pt_02 0],[lindex $pt_02 1]"
						# set DEBUG_Geometry(pt_23) "[lindex $pt_03 0],[lindex $pt_03 1]"
						set DEBUG_Geometry(pt_13) "[lindex $pt_13 0],[lindex $pt_13 1]"
						set DEBUG_Geometry(pt_14) "[lindex $pt_14 0],[lindex $pt_14 1]"
			}
			get_BrakePositionRear

			
				#
				# --- set BrakePosition - Front ------------
			proc get_BrakePositionFront {} {

					variable HeadTube
					variable Steerer
					variable FrontBrake
					variable FrontWheel
					variable Fork

                    # -- ceck Parameter
                    if {$FrontBrake(LeverLength) < 10} {
                        set FrontBrake(LeverLength) 10.0
                    }

                    set RimBrakeRadius	[ expr 0.5 * $FrontWheel(RimDiameter) ]
                    
                    set pt_00			$FrontWheel(Position)
                    set pt_01           [split [ project::getValue Result(Tubes/Steerer/Start)	position ] , ]
                    set pt_02           [split [ project::getValue Result(Tubes/Steerer/End)	position ] , ]
                    set pt_03			[split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon	1] , ]
                    set pt_04			[split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon	0] , ]
                    set pt_05			[ vectormath::intersectPerp	$pt_04 $pt_03 $pt_00 ]	;# point on Forkblade perpendicular through FrontWheel
                    set vct_01			[ vectormath::parallel $pt_03 $pt_05 $FrontBrake(Offset) left]
                    set pt_06			[ lindex $vct_01 1 ]

                    set dist_00			[ vectormath::length $pt_00 $pt_06 ]
                    set dist_00_Ortho	[ expr sqrt(pow($RimBrakeRadius,2)  - pow($dist_00,2)) ]
                    
                    set pt_10			[ vectormath::addVector	$pt_06 [ vectormath::unifyVector $pt_03 $pt_04 $dist_00_Ortho] ]			;# FrontBrake(Shoe)
                    set pt_11			[ vectormath::addVector	$pt_10 [ vectormath::unifyVector {0 0} $HeadTube(Direction) $FrontBrake(LeverLength)] ]
                    set pt_12			[ vectormath::rotatePoint	$pt_10	$pt_11	$Fork(BrakeAngle) ]                            			;# FrontBrake(Help)	
                    set pt_13           [ vectormath::intersectPerp $pt_04 $pt_03 $pt_10 ]
                    
                    set vct_02          [ vectormath::parallel $pt_01 $pt_02 $Fork(BrakeOffset)]
                    set pt_15           [ vectormath::rotatePoint	$pt_12	$pt_10	-90 ] 
                    set pt_16           [ vectormath::intersectPoint  [lindex $vct_02 0] [lindex $vct_02 1] $pt_12 $pt_15 ]
                    
                    set FrontBrake(Shoe)		$pt_10
                    set FrontBrake(Help)		$pt_12
                    set FrontBrake(Definition)	$pt_13
                    set FrontBrake(Mount)       $pt_16
 
					project::setValue Result(Position/BrakeFront)	position	$FrontBrake(Shoe)

                            # set pt_18			[split [ project::getValue Result(Tubes/ForkBlade/Start) 	position] , ]
                            # set pt_19			[split [ project::getValue Result(Tubes/ForkBlade/End)   	position] , ]
                            # set pt_05			[split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon	1] , ]
                            # set pt_06			[split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon	2] , ]
                            # set pt_11			[split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon	3] , ]
                            # set pt_12			[split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon	4] , ]
                            # set pt_13			[split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon	5] , ]
                            # set pt_14			[split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon	6] , ]
                            # set pt_15			$FrontBrake(Mount)
                            # set pt_18			[split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon	0] , ]
                            # set pt_19			[split [ project::getValue Result(Tubes/ForkBlade/Polygon)  polygon	5] , ]
                            

                            
                            variable DEBUG_Geometry
                            #set DEBUG_Geometry(pt_00) "[lindex $pt_00 0],[lindex $pt_00 1]"
                            set DEBUG_Geometry(pt_03) "[lindex $pt_03 0],[lindex $pt_03 1]"
                            set DEBUG_Geometry(pt_04) "[lindex $pt_04 0],[lindex $pt_04 1]"
                            set DEBUG_Geometry(pt_14) "[lindex $pt_15 0],[lindex $pt_15 1]"
                            
                            #set DEBUG_Geometry(pt_11) "[lindex $pt_11 0],[lindex $pt_11 1]"
                            #set DEBUG_Geometry(pt_12) "[lindex $pt_12 0],[lindex $pt_12 1]"
                            #set DEBUG_Geometry(pt_13) "[lindex $pt_13 0],[lindex $pt_13 1]"
                            #set DEBUG_Geometry(pt_14) "[lindex $pt_14 0],[lindex $pt_14 1]"
                            #set DEBUG_Geometry(pt_15) "[lindex $pt_15 0],[lindex $pt_15 1]"
                            
                            # set DEBUG_Geometry(pt_03) "[lindex $pt_03 0],[lindex $pt_03 1]"
                            # set DEBUG_Geometry(pt_04) "[lindex $pt_04 0],[lindex $pt_04 1]"
                            # set DEBUG_Geometry(pt_05) "[lindex $pt_05 0],[lindex $pt_05 1]"
                            # set DEBUG_Geometry(pt_06) "[lindex $pt_06 0],[lindex $pt_06 1]"
                            #set DEBUG_Geometry(pt_18) "[lindex $pt_18 0],[lindex $pt_18 1]"
                            #set DEBUG_Geometry(pt_19) "[lindex $pt_19 0],[lindex $pt_19 1]"

			}
			get_BrakePositionFront
			
			
				#
				# --- set BottleCageMount ------------------
			proc get_BottleCageMount {} {
					variable BottleCage
					variable SeatTube
					variable DownTube
					
                            set pt_00 	[ vectormath::addVector {0 0}	$SeatTube(Direction) 	$BottleCage(SeatTube)				]
                            set vct_01	[ vectormath::parallel	{0 0}	$pt_00 					[expr  0.5 * $SeatTube(DiameterBB)] ]
                            set SeatTube(BottleCage_Base) 			[ lindex $vct_01 1 ]
                            set SeatTube(BottleCage_Offset)			[ vectormath::addVector		$SeatTube(BottleCage_Base)			$SeatTube(Direction) 64.0 ]
					project::setValue Result(Tubes/SeatTube/BottleCage/Base)			position	$SeatTube(BottleCage_Base) 				
					project::setValue Result(Tubes/SeatTube/BottleCage/Offset)			position	$SeatTube(BottleCage_Offset)				
                                                        
                            set pt_00 	[ vectormath::addVector {0 0}	$DownTube(Direction) 	$BottleCage(DownTube)				]
                            set vct_01	[ vectormath::parallel	{0 0}	$pt_00 					[expr -0.5 * $DownTube(DiameterBB)] ]
                            set DownTube(BottleCage_Base) 			[ lindex $vct_01 1 ]
                            set DownTube(BottleCage_Offset)			[ vectormath::addVector		$DownTube(BottleCage_Base)			$DownTube(Direction) 64.0 ]
					project::setValue Result(Tubes/DownTube/BottleCage/Base)			position	$DownTube(BottleCage_Base)
					project::setValue Result(Tubes/DownTube/BottleCage/Offset)			position	$DownTube(BottleCage_Offset)				
					
                            set pt_00 	[ vectormath::addVector {0 0}	$DownTube(Direction) 	$BottleCage(DownTube_Lower)			]
                            set vct_01	[ vectormath::parallel	{0 0}	$pt_00 					[expr  0.5 * $DownTube(DiameterBB)] ]
                            set DownTube(BottleCage_Lower_Base) 	[ lindex $vct_01 1 ]
                            set DownTube(BottleCage_Lower_Offset)	[ vectormath::addVector		$DownTube(BottleCage_Lower_Base)	$DownTube(Direction) 64.0 ]
					project::setValue Result(Tubes/DownTube/BottleCage_Lower/Base)		position	$DownTube(BottleCage_Lower_Base)
					project::setValue Result(Tubes/DownTube/BottleCage_Lower/Offset)	position	$DownTube(BottleCage_Lower_Offset)									
			}
			get_BottleCageMount


				#
				# --- set FrameJig ------------------------
			proc get_FrameJig {} {
					variable FrameJig 
					variable RearWheel 
					variable Steerer 
					variable Saddle 
			
                            set pt_00			$RearWheel(Position)
                            set pt_01			$Steerer(Stem)
                            set pt_02			$Steerer(Fork)
                            set pt_03			$Saddle(Position)
                            set pt_04			{0 0}
                            set pt_10			[ vectormath::intersectPerp		$pt_01 $pt_02 $pt_00 ]
                            set pt_11			[ vectormath::intersectPoint	$pt_00 $pt_10 $pt_03 $pt_04 ]
					set FrameJig(HeadTube)	$pt_10
					set FrameJig(SeatTube)	$pt_11
			}
			get_FrameJig


				#
				# --- set TubeMiter -----------------
			proc get_TubeMiter {} {
					variable HeadTube
					variable SeatTube
					variable SeatStay
					variable TopTube
					variable DownTube
					variable TubeMiter

                            set dir 		[ vectormath::scalePointList {0 0} [ frame_geometry::object_values HeadTube direction ] -1.0 ]
                            	# puts " .. \$dir $dir"
						                                # tube_miter { diameter               direction            diameter_isect          direction_isect         isectionPoint 		{side {right}} {offset {0}}  {startAngle {0}}} 
					set TubeMiter(TopTube_Head) 		[ tube_miter	$TopTube(DiameterHT)  $TopTube(Direction)	$HeadTube(Diameter)		$HeadTube(Direction)	$TopTube(HeadTube)  ]	
					set TubeMiter(TopTube_Seat) 		[ tube_miter	$TopTube(DiameterST)  $TopTube(Direction)	$SeatTube(DiameterTT)	$dir  					$TopTube(SeatTube)  ]	
					set TubeMiter(DownTube_Head) 		[ tube_miter	$DownTube(DiameterHT) $DownTube(Direction)	$HeadTube(Diameter)		$HeadTube(Direction)	$DownTube(HeadTube) right	0	opposite]				
                            set offset		[ expr 0.5 * ($SeatTube(DiameterTT) - $SeatStay(DiameterST)) ]
                            set dir 		[ vectormath::scalePointList {0 0} [ frame_geometry::object_values SeatStay direction ] -1.0 ]
                            	# puts " .. \$dir $dir"
					set TubeMiter(SeatStay_01) 		[ tube_miter	$SeatStay(DiameterST) $dir  $SeatTube(DiameterTT)	  $SeatTube(Direction)  $SeatStay(SeatTube)  right -$offset]	
					set TubeMiter(SeatStay_02) 		[ tube_miter	$SeatStay(DiameterST) $dir  $SeatTube(DiameterTT)	  $SeatTube(Direction)  $SeatStay(SeatTube)  right +$offset]	
					set TubeMiter(Reference) 			{ -50 0  50 0  50 10  -50 10 }
					
					project::setValue Result(TubeMiter/TopTube_Head)        polygon		[ project::flatten_nestedList $TubeMiter(TopTube_Head) 	]
					project::setValue Result(TubeMiter/TopTube_Seat)        polygon		[ project::flatten_nestedList $TubeMiter(TopTube_Seat)		]
					project::setValue Result(TubeMiter/DownTube_Head)       polygon		[ project::flatten_nestedList $TubeMiter(DownTube_Head)	] ;#
					project::setValue Result(TubeMiter/SeatStay_01)         polygon		[ project::flatten_nestedList $TubeMiter(SeatStay_01)		]
					project::setValue Result(TubeMiter/SeatStay_02)         polygon		[ project::flatten_nestedList $TubeMiter(SeatStay_02)		]
					project::setValue Result(TubeMiter/Reference)           polygon		[ project::flatten_nestedList $TubeMiter(Reference) 		]	

			}
			get_TubeMiter	
	}


 	#-------------------------------------------------------------------------
		#  return BottomBracket coords 
	proc get_BottomBracket_Position {cv_Name bottomCanvasBorder {option {bicycle}} {stageScale {}}} {
						
			variable  RearWheel
			variable  FrontWheel
			variable  BottomBracket
			
			array set Stage {}		
		
			set FrameSize	[ split [ project::getValue Result(Position/SummarySize)			position  ] , ]
			set SummaryLength		[ lindex $FrameSize 0 ]
			if {$option == {bicycle}} {
				set SummaryLength	[ expr $SummaryLength + 2 * $RearWheel(Radius) ]
			}

				#
				# --- debug
				# puts "----------------------------------------"
				# puts "   get_BottomBracket_Position:"
				# puts "        \$cv_Name               $cv_Name "
				# puts "        \$bottomCanvasBorder    $bottomCanvasBorder "
				# puts "        \$option                $option"
				# puts "        \$stageScale            $stageScale"


				#
				# --- get canvasCAD-Stage information
			set Stage(width)		[ eval $cv_Name getNodeAttr Stage  width  ]
			set Stage(scale_curr) 	[ eval $cv_Name getNodeAttr Stage  scale ] 		
			if {$stageScale != {}} {
					set Stage(scale)		$stageScale
			} else {
					set Stage(scale)		[ expr 0.8 * $Stage(width) / $SummaryLength ]
			}
			set Stage(scale_fmt)  	[ format "%.4f" $Stage(scale) ]	
				# puts ""
				# puts "        \$SummaryLength         $SummaryLength"
				# puts "        \$Stage(scale_fmt)      $Stage(scale_fmt)"

			
				#
				# --- reset canvasCAD - scale to fit the content
			$cv_Name	setNodeAttr Stage	scale 	$Stage(scale_fmt)
		
				#
				# ---  get unscaled width of Stage 		
			set Stage(unscaled)		[ expr ($Stage(width))/$Stage(scale_fmt) ]
				# puts "        \$Stage(unscaled)       $Stage(unscaled)"
			
				#
				# ---  get border outside content to Stage		
			set border				[ expr  0.5 *( $Stage(unscaled) - $SummaryLength ) ]
				# puts "        \$border                $border"
			
				#
				# ---  get left/right/bottom border outside content to Stage		
			set cvBorder			[ expr $bottomCanvasBorder/$Stage(scale_fmt) ]			
				# puts "        \$cvBorder              $cvBorder"
			
				#
				# ---  get baseLine Coordinates  					
			if {$option == {bicycle}} {
				set BtmBracket_x		[ expr $border + $RearWheel(Radius) + $RearWheel(Distance_X) ] 
				set BtmBracket_y		[ expr $cvBorder + $RearWheel(Radius) - $project::Custom(BottomBracket/Depth) ] 
					# puts "\n -> get_BottomBracket_Position:  $cvBorder + $RearWheel(Radius) - $project::Custom(BottomBracket/Depth) " 
					# puts "\n -> get_BottomBracket_Position:  $BtmBracket_x $BtmBracket_y \n" 
			} else {
				# puts "        \$option                $option"
				set BtmBracket_x		[ expr $border + $RearWheel(Distance_X) ] 
				set BtmBracket_y		$cvBorder
					# set BtmBracket_y		[ expr $bottomCanvasBorder + 50 ]
					# puts "\n -> get_BottomBracket_Position:  $cvBorder " 
					# puts "\n -> get_BottomBracket_Position:  $BtmBracket_x $BtmBracket_y \n" 
			}
			
				# puts "       $BtmBracket_x $BtmBracket_y"
			return [list $BtmBracket_x $BtmBracket_y]
	}


 	#-------------------------------------------------------------------------
		#  return all geometry-values to create specified tube in absolute position
	proc object_values {object index {centerPoint {0 0}} } {
				# puts "   ... $object"
				# {lindex {-1}} 

				# -- for debug purpose
			if {$object == {DEBUG_Geometry}} {
					set returnValue	{}
					set pointValue $index
					foreach xy $pointValue {
						foreach {x y} [split $xy ,] break
						lappend returnValue $x $y	; # puts "    ... $returnValue"
					}
					return [ coords_addVector  $returnValue  $centerPoint]
			}
                            

				# -- default purpose
			switch -exact $index {

				polygon	{	set returnValue	{}
                            switch -exact $object {
                            	Stem 			-
                            	HeadSet/Top 	-
                            	HeadSet/Bottom 	-
                            	SeatPost 	{ 
                            					set branch "Components/$object/Polygon"
                            				}
                            				
                            	TubeMiter/TopTube_Head -
                            	TubeMiter/TopTube_Seat -
                            	TubeMiter/DownTube_Head -					
                            	TubeMiter/SeatStay_01	-
                            	TubeMiter/SeatStay_02	-
                            	TubeMiter/Reference {
                            					set branch "$object/Polygon"	; # puts " ... $branch"	
                            				}
                            				
                            	default 	{ 
                            					set branch "Tubes/$object/Polygon"		
                            				}
                            }
                            	# puts "    ... $branch"
                            set svgList	[ project::getValue Result($branch)	polygon ]
                            foreach xy $svgList {
                            	foreach {x y} [split $xy ,] break
                            	lappend returnValue $x $y
                            }
                            return [ coords_addVector  $returnValue  $centerPoint]
						}
						
				position {
                            set returnValue	{}
                            switch -glob $object {
                            	BottomBracket -
                            	FrontWheel -
                            	RearWheel -
                            	Saddle -
                            	SaddleProposal -
                            	HandleBar -
                            	LegClearance -
                            	BottomBracketGround -
                            	SteererGround -
                            	SeatTubeGround -
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
                            				set branch "$object/Position"	; # puts " ... $branch"                            				
                            			}
                            			
                            			
                            	default {	
                            				# puts "   ... \$object $object"
                            				set branch "Tubes/$object"	
                            			}
                            }
                            
                            set pointValue	[ project::getValue Result($branch)	position ]	; # puts "    ... $pointValue"
                            
                            foreach xy $pointValue {
                            	foreach {x y} [split $xy ,] break
                            	lappend returnValue $x $y	; # puts "    ... $returnValue"
                            }
                            return [ coords_addVector  $returnValue  $centerPoint]
						}
						
				direction {
                            set returnValue	{}
                            	# puts " ... $object"
                            switch -glob $object {
                            		Lugs/* {
                            				set branch "$object/Direction/polar"	; # puts " ... $branch"                            				
                            			}
                            			
                            		default {	
                            				set branch "Tubes/$object/Direction/polar"	
                            			}
							}
							
							set directionValue	[ project::getValue Result($branch)	direction ]	; # puts "    ... $directionValue"
							foreach xy $directionValue {
								foreach {x y} [split $xy ,] break
								lappend returnValue $x $y	; # puts "    ... $returnValue"
							}
							return $returnValue
						}
						
				default	{			 puts "   ... object_values $object $index"
							#eval set returnValue $[format "frameCoords::%s(%s)" $object $index] 
							#return [ coords_addVector  $returnValue  $centerPoint]
						}
			}
	}


 	#-------------------------------------------------------------------------
		#  return project attributes
	proc project_attribute {attribute } {
			variable Project
			return $Project($attribute)
	}	

	
	#-------------------------------------------------------------------------
		#  Fork Blade Polygon for composite Fork
	proc set_compositeFork {} {
			
			set domInit $::APPL_Env(root_InitDOM)
			set FrontWheel(position)	[ frame_geometry::object_values		FrontWheel		position	{0 0}]
			set Steerer_Fork(position)	[ frame_geometry::object_values		Steerer/Start	position	{0 0}]
			set ht_direction			[ frame_geometry::object_values		HeadTube		direction ]

			set Fork(BladeWith)				[ [ $domInit selectNodes /root/Options/Fork/Composite/Visualization/Blade/Width			]  asText ]
			set Fork(BladeDiameterDO)		[ [ $domInit selectNodes /root/Options/Fork/Composite/Visualization/Blade/DiameterDO	]  asText ]
			set Fork(BladeOffsetCrown)		[ [ $domInit selectNodes /root/Options/Fork/Composite/Visualization/Crown/Blade/Offset		]  asText ]
			set Fork(BladeOffsetCrownPerp)	[ [ $domInit selectNodes /root/Options/Fork/Composite/Visualization/Crown/Blade/OffsetPerp	]  asText ]
			set Fork(BladeOffsetDO)			[ [ $domInit selectNodes /root/Options/Fork/Composite/Visualization/DropOut/Offset		]  asText ]
			
			set ht_angle			[ vectormath::angle {0 1} {0 0} $ht_direction ]
			set pt_00				[list $Fork(BladeOffsetCrownPerp) [expr -1.0*$Fork(BladeOffsetCrown)] ]
			set pt_01				[ vectormath::addVector $pt_00 {0  -5} ]
			set pt_02				[ vectormath::addVector $pt_00 {0 -15} ]
			
			set pt_00				[ vectormath::addVector $Steerer_Fork(position) [ vectormath::rotatePoint {0 0} $pt_00 $ht_angle ]]
			set pt_01				[ vectormath::addVector $Steerer_Fork(position) [ vectormath::rotatePoint {0 0} $pt_01 $ht_angle ]]
			set pt_02				[ vectormath::addVector $Steerer_Fork(position) [ vectormath::rotatePoint {0 0} $pt_02 $ht_angle ]]
					# puts "     ... \$ht_angle  $ht_angle"
					# puts "   -> pt_00  $pt_00"
					# puts "   -> pt_01  $pt_01"
			
			set vct_10				[ vectormath::parallel $pt_00 $pt_01 [expr 0.5*$Fork(BladeWith)] left]
			set vct_19				[ vectormath::parallel $pt_00 $pt_02 [expr 0.5*$Fork(BladeWith)] ]
					# puts "   -> pt_00  $pt_00"
					# puts "   -> vct_10  $vct_10"
					# puts "   -> vct_19  $vct_19"
			
				set help_02					[ list 0 [lindex  $FrontWheel(position) 1] ]			
				set do_angle				[ expr 90 - [ vectormath::angle $pt_01 $FrontWheel(position) $help_02  ] ]			
				set vct_05					[ list $Fork(BladeOffsetDO) 0 ]
				set vct_06					[ vectormath::rotatePoint {0 0} $vct_05 [expr 90 + $do_angle] ]
			set pt_03				[ vectormath::addVector $FrontWheel(position)  $vct_06 ]
			
				set vct_11			[ vectormath::parallel $pt_01 $pt_03 [expr 0.5*$Fork(BladeDiameterDO)] left]
				set vct_18			[ vectormath::parallel $pt_01 $pt_03 [expr 0.5*$Fork(BladeDiameterDO)] ]
			
			set polygon 		[format "%s %s %s %s %s %s" \
									[lindex $vct_10 0] [lindex $vct_10 1] \
									[lindex $vct_11 1] [lindex $vct_18 1] \
									[lindex $vct_19 1] [lindex $vct_19 0] ]
									
			set do_direction	[ vectormath::unifyVector $FrontWheel(position) $pt_03 ]					
			project::setValue Result(Lugs/Dropout/Front/Direction)	direction	$do_direction				

			return $polygon
	}


	#-------------------------------------------------------------------------
		#  Fork Blade Polygon for suspension Fork
	proc set_suspensionFork {} {
			
			set domInit $::APPL_Env(root_InitDOM)
			set FrontWheel(position)	[ frame_geometry::object_values		FrontWheel		position	{0 0}]
			set Steerer_Fork(position)	[ frame_geometry::object_values		Steerer/Start	position	{0 0}]
			set ht_direction			[ frame_geometry::object_values		HeadTube		direction ]

			set Fork(LegOffsetCrown)		[ [ $domInit selectNodes /root/Options/Fork/_Suspension/Leg/Offset		]  asText ]
			set Fork(LegOffsetCrownPerp)	[ [ $domInit selectNodes /root/Options/Fork/_Suspension/Leg/OffsetPerp	]  asText ]
			set Fork(LegDiameter)			[ [ $domInit selectNodes /root/Options/Fork/_Suspension/Leg/Diameter	]  asText ]
			
			set ht_angle			[ vectormath::angle {0 1} {0 0} $ht_direction ]
			
			set pt_00				[list $Fork(LegOffsetCrownPerp) [expr -1.0*$Fork(LegOffsetCrown)] ]
			set pt_01				[ vectormath::addVector $pt_00 {0 -90} ]

			set pt_00				[ vectormath::addVector $Steerer_Fork(position) [ vectormath::rotatePoint {0 0} $pt_00 $ht_angle ]]
			set pt_01				[ vectormath::addVector $Steerer_Fork(position) [ vectormath::rotatePoint {0 0} $pt_01 $ht_angle ]]
					# puts "     ... \$ht_angle  $ht_angle"
					# puts "   -> pt_00  $pt_00"
					# puts "   -> pt_01  $pt_01"
			
			set vct_10				[ vectormath::parallel $pt_00 $pt_01 [expr 0.5*$Fork(LegDiameter)] left]
			set vct_19				[ vectormath::parallel $pt_00 $pt_01 [expr 0.5*$Fork(LegDiameter)] ]
					# puts "   -> pt_00  $pt_00"
					# puts "   -> vct_10  $vct_10"
					# puts "   -> vct_19  $vct_19"
					
			set polygon 		[format "%s %s %s %s" \
									[lindex $vct_10 0] [lindex $vct_10 1] \
									[lindex $vct_19 1] [lindex $vct_19 0] ]
									
			set do_direction	[ vectormath::unifyVector $pt_01 $pt_00 ]					
			project::setValue Result(Lugs/Dropout/Front/Direction)	direction	$do_direction				

			return $polygon
	}


	
 	#-------------------------------------------------------------------------
		#  create TubeIntersection
		#
		#         \     \ direction_isect
		#   -------\     \     \    
		#     direction   \     \
		#     - - - - - - -o- -  \
		#                   \ isectionPoint
		#   -----------\     \     \
		#   diameter    \     \     \ 
		#                \     \     \ diameter_isect
		#
	proc tube_intersection { diameter direction diameter_isect direction_isect isectionPoint {side {right}} {offset {0}} } {
		
			set direction_angle 	[vectormath::angle {0 1}	{0 0}	$direction ]
			set intersection_angle 	[vectormath::angle $direction {0 0} $direction_isect]
				# puts [format "   %2.f %2.f" $direction_angle $intersection_angle]
			set coordList {}
			set radius 			[expr 0.5*$diameter]
			set radius_isect 	[expr 0.5*$diameter_isect]
			foreach angle {90 60 30 10 0 -10 -30 -60 -90} {
				set rad_Angle 	[vectormath::rad $angle]
				set r1_x		[expr $radius*cos([vectormath::rad [expr 90+$angle]]) ]
				set r1_y 		[expr $radius*sin([expr 1.0*(90-$angle)*$vectormath::CONST_PI/180]) + $offset]
				if {[expr abs($radius_isect)] >= [expr abs($r1_y)]} {
					set cut_perp	[expr sqrt(pow($radius_isect,2) - pow($r1_y,2)) ]
				} else {
					set cut_perp 	0
				}
				set cut_angle	[expr $cut_perp / sin([vectormath::rad $intersection_angle]) ]
				set cut_angOff	[expr $r1_x / tan([vectormath::rad $intersection_angle]) ]
				set cut_eff   	[expr $cut_angle + $cut_angOff ]
				set xy	[list $r1_x $cut_eff]
				if {$side != {right}}  {set xy	[vectormath::rotatePoint {0 0} $xy  180]}
				set xy	[vectormath::rotatePoint {0 0} $xy $direction_angle]
				set xy 	[coords_addVector $xy $isectionPoint]
				set coordList [lappend coordList [lindex $xy 0] [lindex $xy 1]]
			}

			return $coordList
	}		

 	
	#-------------------------------------------------------------------------
		#  create TubeMiter
		#
		#         \     \ direction_isect
		#   -------\     \     \    
		#     direction   \     \
		#     - - - - - - -o- -  \
		#                   \ isectionPoint
		#   -----------\     \     \
		#   diameter    \     \     \ 
		#                \     \     \ diameter_isect
		#
	proc tube_miter { diameter direction diameter_isect direction_isect isectionPoint {side {right}} {offset {0}}  {opposite {no}}} {	

			set intersection_angle 	[vectormath::angle $direction {0 0} $direction_isect]

				# puts ""
				# puts "   -------------------------------"
				# puts "    tube_miter"
				# puts "       diameter:        $diameter	"			
				# puts "       direction:       $direction	"			
				# puts "       diameter:        $diameter	"			
				# puts "       diameter_isect:  $diameter_isect	"			
				# puts "       direction_isect: $direction_isect	"			
				# puts "       isectionPoint:   $isectionPoint	"			
				# puts "       side:            $side"			
				# puts "       offset:          $offset"			
				# puts "       opposite:        $opposite"	
				# puts "       -> intersection_angle   $intersection_angle"
				# puts [format " -> tube_miter \n   %2.f %2.f" $direction_angle $intersection_angle]
				
			if {$opposite != {no}	} {
				    set intersection_angle	[expr 180 - $intersection_angle]
						# puts "       -> intersection_angle $intersection_angle"
			}
				
			set radius 			[expr 0.5*$diameter]
			set radius_isect 	[expr 0.5*$diameter_isect]
			set angle 		-180
				# set angle 		[expr -180 - $startAngle]
			set loops 		36
			set perimeter	[expr $radius * [vectormath::rad 360] ]
			set coordList 	[list [expr 0.5*$perimeter] -70]
				# while {$angle <= [expr 180 - $startAngle]}
			while {$angle <= 180} {
					set rad_Angle 	[vectormath::rad $angle]
					set x [expr $diameter*[vectormath::rad 180]*$angle/360 ]
				 
					set h [expr $offset + $radius*sin($rad_Angle)]
					set b [expr $diameter*0.5*cos($rad_Angle)]
				 
					if {[expr abs($radius_isect)] >= [expr abs($h)]} {
						set l [expr sqrt(pow($radius_isect,2) - pow($h,2))]
					} else {
						set l 0
					}
					set v [expr $b/tan([vectormath::rad $intersection_angle])]
				 
						# puts [format "%.2f  -  %+.2f / %+.2f  -  %+.2f / %+.2f"   $angle  $h  $b  $l  $v ]
					set y $h
					set y [expr $l+$v]			 
					set xy [list $x $y]
					if {$side == {right}}  {set xy	[vectormath::rotatePoint {0 0} $xy  180]}
					set coordList 	[lappend coordList [lindex $xy 0] [lindex $xy 1]]
					set angle 		[expr $angle + 360 / $loops]
			}
			set coordList [ lappend coordList [expr -0.5*$perimeter] -70 ]
			return $coordList
	}		

	
 	#-------------------------------------------------------------------------
		#  create ProjectEdit Widget
		# proc createEdit { x y cv_Name updateCommand _arrayNameList {title {Edit:}}}
 	proc createEdit { x y cv_Name _arrayNameList {title {Edit:}}} {
			variable _update
			variable _updateValue
			
			# _arrayNameList:  				e.g.: {FrameTubes(HeadTube/Length) Component(HeadSet/Height/Bottom)}
			#   previous 3.2.70  xpathList: e.g.: {FrameTubes/HeadTube/Length Component/HeadSet/Height/Bottom}
			
				puts ""
				puts "   -------------------------------"
				puts "    createEdit"
				puts "       x / y:           $x / $y"
				puts "       cv_Name:         $cv_Name"
				puts "       _arrayNameList:  $_arrayNameList"
				puts "       title:           $title"
			
			project::remove_tracing
            
			# --- local procedures ---
				proc change_ValueEdit {textVar direction} {
						#
						# --- dynamic update value ---
                            set currentValue [set ::$textVar]
                            set updateValue 1.0
                            if {$currentValue < 20} { set updateValue 0.1 }
                                # puts "\n  -> $currentValue   -> $updateValue\n"
						#
                        # --- update value of spinbox ---
							if {$direction eq "up"} {\
								set newValue [expr {$currentValue + $updateValue}]\
							} else {\
								set newValue [expr {$currentValue - $updateValue}]\
							}
                            set ::$textVar [format "%.2f" $newValue] 
 				}
				
				proc bind_MouseWheel {textVar value} {
                            set currentValue [set ::$textVar]
                            set updateValue 1.0
                            if {$currentValue < 20} { set updateValue 0.1 }
                            if {$value > 0} {
                                set scale 1.0
                            } else {
                                set scale -1.0
                            }
                            set newValue [expr {$currentValue + $scale * $updateValue}]                          
                            set ::$textVar [format "%.2f" $newValue] 
 				}
				
				proc create_ValueEdit {cv cv_Name cvEdit cvContentFrame index labelText key} {					

						eval set currentValue $[namespace current]::_updateValue($key)
						#
						# --- create cvLabel, cvEntry ---
							set	cvLabel [label  $cvContentFrame.label_${index} -text "${labelText} : "]
								# set cvEntry [entry  $cvContentFrame.value_${index} -textvariable $textVar  -justify right  -relief sunken -bd 1  -width 10]
							set cvEntry [spinbox $cvContentFrame.value_${index} -textvariable [namespace current]::_updateValue($key) -justify right -relief sunken -width 10 -bd 1]
							$cvEntry configure -command \
								"[namespace current]::change_ValueEdit [namespace current]::_updateValue($key) %d"
							if {$index == {oneLine}} {
								set	cvClose [button $cvContentFrame.close -image $lib_gui::iconArray(iconClose) -command "[namespace current]::closeEdit $cv $cvEdit"]
								grid	$cvLabel $cvEntry $cvClose -sticky news
                                    # grid	$cvLabel $cvEntry $cvUpdate $cvClose -sticky news
							} else {	
								grid	$cvLabel $cvEntry -sticky news
                                    # grid	$cvLabel $cvEntry $cvUpdate -sticky news
							}
							grid configure $cvLabel  -padx 3 -sticky nws
							grid configure $cvEntry  -padx 2
						#
						# --- select entries content ---
							if {$index == {oneLine}} {
									focus $cvEntry
									$cvEntry selection range 0 end
							}
						#
						# --- define bindings ---
							bind $cvLabel	<ButtonPress-1> 	    [list [namespace current]::dragStart 	    %X %Y]
							bind $cvLabel	<B1-Motion> 		    [list [namespace current]::drag 		    %X %Y $cv $cvEdit]			
							bind $cvEntry	<MouseWheel> 			[list [namespace current]::bind_MouseWheel  [namespace current]::_updateValue($key)  %D]
							bind $cvEntry	<Return> 			    [list [namespace current]::updateConfig     $cv_Name $key $cvEntry]			
							bind $cvEntry	<Leave> 			    [list [namespace current]::updateConfig     $cv_Name $key $cvEntry]			
							bind $cvEntry	<Double-ButtonPress-1>  [list [namespace current]::updateConfig     $cv_Name $key $cvEntry]			
				}
							
				proc create_ListEdit {type cv cv_Name cvEdit cvContentFrame index labelText key} {					

						
						eval set currentValue $[namespace current]::_updateValue($key)
						#
						# --- create listBox content ---
						set listBoxContent {}
						case $type {
								{SELECT_File} {
										set listBoxContent {}
											puts "createEdit::create_ListEdit::SELECT_File:"
											# puts "     currentFile: $currentFile"
											# puts "           key: $key"										
										set listBoxContent [lib_file::get_componentAlternatives  $key]
										foreach entry $listBoxContent {
											puts "         ... $entry"
										}				
									}
								{SELECT_Rims} {
										set listBoxContent {}
										puts "     currentValue: $currentValue"
										set listBoxContent $::APPL_Env(list_Rims)
										foreach entry $listBoxContent {
											puts "         ... $entry"
										}
									}
								{SELECT_ForkTypes} {
										set listBoxContent {}
										puts "     currentValue: $currentValue"
										set listBoxContent $::APPL_Env(list_ForkTypes)
										foreach entry $listBoxContent {
											puts "         ... $entry"
										}
									}	
								{SELECT_BrakeTypes} {
										set listBoxContent {}
										puts "     currentValue: $currentValue"
										set listBoxContent $::APPL_Env(list_BrakeTypes)
										foreach entry $listBoxContent {
											puts "         ... $entry"
										}
									}
								{SELECT_BottleCage} {
										set listBoxContent {}
										puts "     currentValue: $currentValue"
										set listBoxContent $::APPL_Env(list_BottleCage)
										foreach entry $listBoxContent {
											puts "         ... $entry"
										}
									}
								{SELECT_Binary_OnOff} {
										set listBoxContent {}
										puts "     currentValue: $currentValue"
										set listBoxContent $::APPL_Env(list_Binary_OnOff)
										foreach entry $listBoxContent {
											puts "         ... $entry"
										}
									}
									
						}
						#
						# --- create cvLabel, cvEntry, Select ---
                            set cvFrame		[ frame 		$cvContentFrame.frame_${index} ]
							set	  cvLabel	[ label  		$cvFrame.label   -text "${labelText} : "]
							set	  cvCBox	[ ttk::combobox $cvFrame.cb \
													-textvariable [namespace current]::_updateValue($key) \
													-values $listBoxContent	\
													-width 13 \
													-height 10 \
													-justify right ]
													
									set postCommand [list set [namespace current]::oldValue [namespace current]::_updateValue($key)]
									$cvCBox configure -postcommand [list eval set [namespace current]::oldValue \$[namespace current]::_updateValue($key)]

							if {$index == {oneLine}} {
									set	cvClose [ button 		$cvFrame.close   -image $lib_gui::iconArray(iconClose) -command [list [namespace current]::closeEdit $cv $cvEdit]]
									grid	$cvLabel $cvCBox $cvClose 	-sticky news
									grid 	$cvFrame  					-sticky news 	-padx 1 
							} else {																
									grid	$cvLabel $cvCBox  		 	-sticky news
									grid 	configure $cvLabel   		-sticky nws		-padx 2 
									grid	columnconfigure 	$cvFrame 1 	-weight 1 
									grid 	$cvFrame  -sticky news -padx 1 -columnspan 3
							}
						#
						# --- define bindings ---
							bind $cvCBox 	<<ComboboxSelected>> 		[list [namespace current]::check_listBoxValue	%W $cv_Name $key]
							bind $cvLabel	<ButtonPress-1> 			[list [namespace current]::dragStart 	%X %Y]
							bind $cvLabel	<B1-Motion> 				[list [namespace current]::drag 		%X %Y $cv $cvEdit]			
							#bind $cvLabel	<B1-Motion> 				[list [namespace current]::drag 		%X %Y $cv __cvEdit__]			
				}
				

			
			set x_offset 20
			set domProject $::APPL_Env(root_ProjectDOM)	
			set cv 		[ $cv_Name getNodeAttr Canvas path]		
            if { [catch { set cvEdit [frame $cv.f_edit -bd 2 -relief raised] } errorID ] } {
					closeEdit $cv $cv.f_edit
					set cvEdit [frame $cv.f_edit -bd 2 -relief raised]
			}
			# --- create Window ---
            $cv_Name addtag __cvEdit__ withtag $cvEdit
			$cv create window [expr $x + $x_offset] $y  -window $cvEdit  -anchor w -tags $cvEdit
            $cv_Name addtag __cvEdit__ withtag $cvEdit
            
			# $cv create window [expr $x + $x_offset] $y  -window $cvEdit  -anchor w -tags __cvEdit__

			# --- create WindowFrames ---
			set cvTitleFrame	[frame $cvEdit.f_title -bg gray60  ]
				# set cvTitleFrame 		 [frame $cvEdit.f_title   -bd 1 -relief flat -bg gray60]
			set cvContentFrame 		 [frame $cvEdit.f_content -bd 1 -relief sunken]
					pack $cvTitleFrame $cvContentFrame -side top
					pack configure $cvTitleFrame 	  -fill x -padx 2 -pady 2
					pack configure $cvContentFrame 	  -fill both
					
			# --- cvContentFrame ---
			if {[llength $_arrayNameList] == 1 } {
					pack forget $cvTitleFrame
					set updateMode 	value
					set _arrayName 	[lindex $_arrayNameList 0]
					set _array 		[lindex [split $_arrayName (] 0]
					set _name 		[lindex [split $_arrayName ()] 1]
					set xpath 		[format "%s/%s" $_array $_name]
					set index oneLine
					
					switch -glob $xpath {
							{file://*} {
									set updateMode SELECT_File
																		set updateMode SELECT_File
									set _array		[string range $_array 7 end]
									eval set value 	[format "$%s::%s(%s)" project $_array $_name]
									set labelText	[format "%s ( %s )" $_array [ string trim [ string map {{/} { / }} $_name] " " ] ]
									set key			[format "%s/%s" $_array $_name]
									set _updateValue($key) $value
									
										# --- create widgets per xpath list element ---
									create_ListEdit SELECT_File \
												$cv $cv_Name $cvEdit $cvContentFrame \
												$index $labelText $key															
								}
							{list://*} {
									set _array		[string range $_array 7 end]
									set _nameInfo	[split $_name {@} ]
									set _name		[lindex $_nameInfo 0]										 
									set listName	[lindex $_nameInfo 1]
									
									eval set value 	[format "$%s::%s(%s)" project $_array $_name]
									set labelText	[format "%s ( %s )" $_array [ string trim [ string map {{/} { / }} $_name] " " ] ]
									set key			[format "%s/%s" $_array $_name]
									set _updateValue($key) $value
									
									create_ListEdit $listName \
												$cv $cv_Name $cvEdit $cvContentFrame \
												$index $labelText $key								
								}
							default {
									eval set value 	[format "$%s::%s(%s)" project $_array $_name]
									set _updateValue($xpath) $value
									set labelText	[format "%s ( %s )" $_array [ string trim [ string map {{/} { / }} $_name] " " ] ]
									set key	[format "%s/%s" $_array $_name]
									set _updateValue($key) $value
									
										# --- create widgets per xpath list element ---
									create_ValueEdit $cv $cv_Name $cvEdit $cvContentFrame \
														$index $labelText $key
								}
						
					}
			} else {
					#
				# --- title definition ---
					set cvTitle			[label  $cvTitleFrame.label -text "${title}"  -bg gray60  -fg white -font "Helvetica 8 bold" -justify left]
						pack $cvTitle -side left
					set	cvClose			[button $cvTitleFrame.close -image $lib_gui::iconArray(iconClose) -command "[namespace current]::closeEdit $cv $cvEdit"]
						pack $cvClose -side right -pady 2	
					#
				# --- parameter to edit ---
					set updateMode value
					set index 0				
					foreach _arrayName 	$_arrayNameList {						
						set _array 		[lindex [split $_arrayName (] 0]
						set _name 		[lindex [split $_arrayName ()] 1]
						set xpath 		[format "%s/%s" $_array $_name]
						set index [expr $index +1]
						
						switch -glob $xpath {
							{file://*} { 
										# puts "   ... \$xpath $xpath"
									set _array		[string range $_array 7 end]
										# puts "   ... \$xpath $xpath"							
									eval set value 	[format "$%s::%s(%s)" project $_array $_name]
										# replaced by 3.2.70;# set value	[ [ $domProject selectNodes /root/$xpath  ]	asText ]
										# set xpath	[string range $xpath 7 end]
										# set _updateValue($xpath) $value
										# puts "   -> \$_updateValue($xpath): $_updateValue($xpath)"
									set labelText	[format "%s ( %s )" $_array [ string trim [ string map {{/} { / }} $_name] " " ] ]
										# replaced by 3.2.70;# set labelText		[ string trim [ string map {{/} { / }} $xpath] " " ]
										#
									set key	[format "%s/%s" $_array $_name]
									set _updateValue($key) $value
									
										# --- create widgets per xpath list element ---
									create_ListEdit SELECT_File \
												$cv $cv_Name $cvEdit $cvContentFrame \
												$index $labelText $key															
								}
							{list://*} {
										# puts "   ... \$xpath $xpath"
									set _array		[string range $_array 7 end]
									set _nameInfo	[split $_name {@} ]
										 puts "   ... $_array $_nameInfo"
									set _name		[lindex $_nameInfo 0]										 
									set listName	[lindex $_nameInfo 1]										 
									eval set value 	[format "$%s::%s(%s)" project $_array $_name]
										# replaced by 3.2.70;# set value	[ [ $domProject selectNodes /root/$xpath  ]	asText ]
									    # set _updateValue($xpath) $value
										# puts "   -> \$_updateValue($xpath): $_updateValue($xpath)"
									set labelText	[format "%s ( %s )" $_array [ string trim [ string map {{/} { / }} $_name] " " ] ]
										# replaced by 3.2.70;# set labelText		[ string trim [ string map {{/} { / }} $xpath] " " ]
										#
									set key	[format "%s/%s" $_array $_name]
									set _updateValue($key) $value
									
										# --- create widgets per xpath list element ---
									create_ListEdit $listName \
												$cv $cv_Name $cvEdit $cvContentFrame \
												$index $labelText $key								
								}
							default {
										# puts "   ... \$xpath $xpath"
									eval set value [format "$%s::%s(%s)" project $_array $_name]
									set _updateValue($xpath) $value
										# puts "   -> \$_updateValue($xpath): $_updateValue($xpath)"
									set labelText		[format "%s ( %s )" $_array [ string trim [ string map {{/} { / }} $_name] " " ] ]
										# removed by 3.2.70;# set labelText		[ string trim [ string map {{/} { / }} $xpath] " " ]
										#
									set key	[format "%s/%s" $_array $_name]
									set _updateValue($key) $value
									
										# --- select entries content ---
									create_ValueEdit $cv $cv_Name $cvEdit $cvContentFrame \
														$index $labelText $key
								}
						}
					}
					bind $cvTitleFrame 	<ButtonPress-1> 	[list [namespace current]::dragStart 	%X %Y]
					bind $cvTitleFrame	<B1-Motion> 		[list [namespace current]::drag 		%X %Y $cv $cvEdit]			
					bind $cvTitle		<ButtonPress-1> 	[list [namespace current]::dragStart 	%X %Y]
					bind $cvTitle		<B1-Motion> 		[list [namespace current]::drag 		%X %Y $cv $cvEdit]			
			}

			# --- reposition if out of canvas border ---
			set cv_width  [ winfo width  $cv ]
			set cv_height [ winfo height $cv ]
			update
			set id_bbox   [ $cv bbox $cvEdit ]
				# puts "   -> bbox $id_bbox"
			foreach {dx dy} {0 0} break
			if {[lindex $id_bbox 2] > [expr $cv_width  -4]} { set dx [expr $cv_width  - [lindex $id_bbox 2] -4] }
			if {[lindex $id_bbox 3] > [expr $cv_height -4]} { set dy [expr $cv_height - [lindex $id_bbox 3] -4] }
			$cv move $cvEdit $dx $dy
			  # puts "  -> reposition $dx $dy"
	} 
 	#-------------------------------------------------------------------------
		#  update Project 
	proc updateConfig {cv_Name xpath {cvEntry {}}} {

			variable _updateValue
            
            set _array 	[lindex [split $xpath /] 0]
			set _name 	[string range $xpath [string length $_array/] end]

			
			# --- handele xpath values --- 
			switch -glob $xpath {
				{_update_} {}
				default {
						set oldValue [project::getValue [format "%s(%s)" $_array $_name] value]
                        if {$_updateValue($xpath) == $oldValue} {
                            return
                        }                        
                            # puts "003  -> update"
                            # puts "001  ->$oldValue"
                            # puts "001  ->$_updateValue($xpath)"
                            
						puts ""
						puts "   -------------------------------"
						puts "    updateConfig"
						puts "       updateConfig:    $_updateValue($xpath)"
                        project::add_tracing
                        set_projectValue $xpath $_updateValue($xpath)				
						project::remove_tracing
					}			
			}
					
			#
			# --- finaly update
                # frame_geometry::set_base_Parameters ;#$domProject
			update
			catch {focus $cvEntry}
			catch {$cvEntry selection range 0 end}
	}
 	#-------------------------------------------------------------------------
		#  check comments in listbox
	proc check_listBoxValue { w cv_Name xPath args} {
		
			variable _updateValue
			variable oldValue
			
			puts "  .. check_listBoxValue $xPath $args"
			
			switch $xPath {
					{Component/Wheel/Rear/RimDiameter} -
					{Component/Wheel/Front/RimDiameter} {
								# -- exception for selection of Combobox
									# list is splitted by: "----"
							if {[string range $_updateValue($xPath) 0 3] == "----"} {
									puts "   ... reset value .. $oldValue"
								set _updateValue($xPath) $oldValue
							} else {
									# puts "   ... $_updateValue($xPath)"
									# puts "      >[split $_updateValue($xPath) ;]<"
									# puts "      >[lindex [split $_updateValue($xPath) ;] 0]<"
								set value [string trim [lindex [split $_updateValue($xPath) ;] 0]]
								set value [format "%.2f" $value]
								set _updateValue($xPath) $value
									# puts "   ... $_updateValue($xPath)"
									
								[namespace current]::updateConfig $cv_Name $xPath
							}
						}
					default {
								[namespace current]::updateConfig $cv_Name $xPath
						}
			}
	}

 	#-------------------------------------------------------------------------
		#  sets and format Value 
	proc set_projectValue {xpath value {mode {update}}} {
			
			# xpath: e.g.:Custom/BottomBracket/Depth
			variable 		_updateValue
			
			puts ""
			puts "   -------------------------------"
			puts "    set_projectValue"
			puts "       xpath:           $xpath"
			puts "       value:           $value"
			puts "       mode:            $mode"
			
			set _array 	[lindex [split $xpath /] 0]
			set _name 	[string range $xpath [string length $_array/] end]
				# puts "     ... $_array  $_name"

			
			# --- handle xpath values --- 
					# puts "  ... mode: $mode"
			if {$mode == {update}} {
					# puts "  ... set_projectValue: $xpath"
				switch -glob $_array {
					{Result} {
								# puts "\n  ... set_projectValue: ... Result/..."
							set_temp_Parameters $_array $_name $value
							# set_spec_Parameters $xpath $value
							return
						}	
					default {}			
				}
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
					set newValue [format "%.2f" $newValue]
				}
			}
			
			if {$mode == {update}} {
				project::setValue [format "%s(%s)" $_array $_name] value $newValue
			}
			
			# puts "set_projectValue: $newValue"
			return $newValue
	
	}
	
	
 	#-------------------------------------------------------------------------
		#  handle modification on /root/Result/... values
	# proc set_spec_Parameters {domProject cv_Name updateCommand xpath cvEntry} 
	proc set_temp_Parameters {_array _name value} {

			variable 		_updateValue
			
			puts ""
			puts "   -------------------------------"
			puts "    set_temp_Parameters"
			puts "       _array:          $_array"
			puts "       _name:           $_name"
			puts "       value:           $value"
			
				variable BottomBracket	
				variable HandleBar	
				variable Saddle
				variable SeatTube
				variable FrontWheel	
				variable Fork	
				variable Stem	
			
			
			set xpath "$_array/$_name"
			puts "       xpath:           $xpath"
			
			switch -glob $_name {
			
				{Length/BottomBracket/Height}	{			
							# puts "               ... [format "%s(%s)" $_array $_name] $xpath"
							set oldValue				$project::Result(Length/BottomBracket/Height)
							# 3.2.76 set oldValue       $project::Temporary(BottomBracket/Height)
							set newValue				[set_projectValue $xpath  $value format]
							set _updateValue($xpath) 	$newValue
							set delta		[expr $newValue - $oldValue]
									# puts "   ... oldValue:   $oldValue"
									# puts "   ... newValue:   $newValue"
									# puts "   ...... delta:   $delta"
							
								# --- update value 
								# 
							set xpath 					Custom/BottomBracket/Depth
							set oldValue				$project::Custom(BottomBracket/Depth)
							set newValue				[ expr $oldValue - $delta ]
							set_projectValue $xpath  	$newValue
							return
						}	
							
				{Angle/HeadTube/TopTube} {
							# puts "               ... [format "%s(%s)" $_array $_name] $xpath"						
							set HeadTopTube_Angle		[ set_projectValue $xpath  $value format]
							set _updateValue($xpath) 	$HeadTopTube_Angle
								puts "          \$HeadTopTube_Angle  = $HeadTopTube_Angle"



								# --- update value 
								# 
							set HeadTube_Angle			$project::Custom(HeadTube/Angle)
							set value					[ expr $HeadTopTube_Angle - $HeadTube_Angle]
							set xpath					Custom/TopTube/Angle
							
							set_projectValue $xpath  	$value	
                            return
						}
				
				{Length/TopTube/VirtualLength}			-			
				{Length/FrontWheel/horizontal}	{			
							# puts "  -> Length/TopTube/VirtualLength"
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
							set oldValue				[project::getValue [format "%s(%s)" $_array $_name] value] 
							# set oldValue				[ [ $domProject selectNodes $xpath  ]	asText ]
							set newValue				[set_projectValue $xpath  $value format]
							set _updateValue($xpath) 	$newValue
							set delta					[expr $newValue - $oldValue]
								 
								# --- set HandleBar(Distance)
								#
							set newValue				[ expr $HandleBar(Distance)	+ $delta ]
							set xpath 					Personal/HandleBar_Distance
							set_projectValue $xpath  	$newValue
                            return
						}
						
				{Length/FrontWheel/diagonal}	{			
                                # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
							set oldValue				[project::getValue [format "%s(%s)" $_array $_name] value]
                                # set oldValue				[ [ $domProject selectNodes $xpath  ]	asText ]
							set newValue				[set_projectValue $xpath  $value format]
							set _updateValue($xpath) 	$newValue
                                # puts "                 <D> ... $oldValue $newValue"
							
								# --- set HandleBar(Angle)
								#
							set vect_01	 [ expr $Stem(Length) * cos($Stem(Angle) * $vectormath::CONST_PI / 180) ]
							set vect_02	 [ expr $vect_01 - $Fork(Rake) ]
							
							set FrontWheel(Distance_X_tmp)	[ expr { sqrt( $newValue * $newValue - $FrontWheel(Distance_Y) * $FrontWheel(Distance_Y) ) } ]
							set FrontWheel(Position_tmp)	[ list $FrontWheel(Distance_X_tmp) $FrontWheel(Distance_Y)]
							
							set help_03	 [ vectormath::cathetusPoint	$HandleBar(Position)	$FrontWheel(Position_tmp)	$vect_02  close ]
							set vect_HT 	 [ vectormath::parallel  	$help_03  				$FrontWheel(Position_tmp)	$Fork(Rake) ]
								# puts "                 <D> ... $vect_HT"
							
							set help_01	 [ lindex $vect_HT 0]
							set help_02	 [ lindex $vect_HT 1]
							set help_03	 [list -200 [ lindex $help_02 1] ]
							
							set newValue				[ vectormath::angle	$help_01 $help_02 $help_03 ]
							set xpath 					Custom/HeadTube/Angle
							set_projectValue $xpath  	$newValue
                            return
						}
						
				{Length/Saddle/Offset_BB}	{			
							# puts "               ... [format "%s(%s)" $_array $_name] $xpath"
							set oldValue				[project::getValue [format "%s(%s)" $_array $_name] value]
							# set oldValue				[ [ $domProject selectNodes $xpath  ]	asText ]
							set Saddle(Distance_X_tmp)				[set_projectValue $xpath  $value format]
							set _updateValue($xpath) 	$Saddle(Distance_X_tmp)
							
							# set SeatTube(Length)		$project::Personal(SeatTube_Length)
							set Saddle(Height)			[expr sqrt(pow($SeatTube(Length),2) - pow($oldValue,2)) ]
							
									# puts "          old Value:         $oldValue"
									# puts "          current Value:     $Saddle(X)"
									# puts "          SeatTube(Length):  $SeatTube(Length)"
								 
								# --- get SeatTube Length
								# 
							set  SeatTube(Length_tmp) 		[ format "%.2f" [ expr hypot($Saddle(Height), $Saddle(Distance_X_tmp)) ] ]

								# --- update value: 
								#
							set xpath 				Personal/SeatTube_Length	
							set_projectValue $xpath  $SeatTube(Length_tmp)
							

								# --- get SeatTube Angle
								# 
							set SeatTube(Angle_tmp)	[ expr atan( $Saddle(Height) / $Saddle(Distance_X_tmp) ) *180 / $vectormath::CONST_PI ]
									# puts "                 ...  $SeatTube((angle)"								
								
								# --- update value: 
								#
							set xpath 				Personal/SeatTube_Angle	
							set_projectValue $xpath  $SeatTube(Angle_tmp)
							return
						}
							
				{Length/Saddle/Offset_HB}	{			
							# puts "               ... [format "%s(%s)" $_array $_name] $xpath"
							set oldValue				[project::getValue [format "%s(%s)" $_array $_name] value]
							set newValue				[set_projectValue $xpath  $value format]
							set _updateValue($xpath) 	$newValue
							
							set delta					[expr $oldValue - $newValue]
									# puts "          $newValue - $oldValue = $delta"
								 
								# --- set HandleBar(Distance)
								#
							set newValue				[ expr $HandleBar(Height)	+ $delta ]
							set xpath 					Personal/HandleBar_Height
							set_projectValue $xpath  	$newValue
                            return
						}
						
				default {
							puts "\n"
							puts "     WARNING!"
							puts "\n"
							puts "        ... set_temp_Parameters:  "
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
 
 }  

