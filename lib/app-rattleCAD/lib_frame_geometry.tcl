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
		package require tdom
		
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
			variable TubeMitter		; array set TubeMitter		{}
			


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
	proc set_base_Parameters {domProject} {
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

			variable BottleCage
			variable FrameJig
			variable TubeMitter			
			
	
				#
				# --- increase global update timestamp
			set ::APPL_Update			[ clock milliseconds ]
			
	
				#
				# --- set Project attributes
			set Project(Project)		[ [ $domProject selectNodes /root/Project/Name 						]  asText ]
			set Project(modified)		[ [ $domProject selectNodes /root/Project/modified 					]  asText ]
			
				#
				# --- get BottomBracket (1)
			set BottomBracket(depth)	[ [ $domProject selectNodes /root/Custom/BottomBracket/Depth  		]  asText ]

				#
				# --- get RearWheel
			set RearWheel(RimDiameter)	[ [ $domProject selectNodes /root/Component/Wheel/Rear/RimDiameter	]  asText ]
			set RearWheel(RimHeight)	[ [ $domProject selectNodes /root/Component/Wheel/Rear/RimHeight	]  asText ]
			set RearWheel(TyreHeight)	[ [ $domProject selectNodes /root/Component/Wheel/Rear/TyreHeight	]  asText ]
			set RearWheel(Radius)		[ expr 0.5*$RearWheel(RimDiameter) + $RearWheel(TyreHeight) ]
			set RearWheel(DistanceBB)	[ [ $domProject selectNodes /root/Custom/WheelPosition/Rear			]  asText ]
			set RearWheel(Distance_X)	[ expr sqrt(pow($RearWheel(DistanceBB),2)  - pow($BottomBracket(depth),2)) ]
			set RearWheel(Position)		[ list [expr -1.0 * $RearWheel(Distance_X)] $BottomBracket(depth) ]
				# set RearWheel(Distance_X)	450
				
				#
				# --- get BottomBracket (2)
			set BottomBracket(height)	[ expr $RearWheel(Radius) - $BottomBracket(depth) ]
			set BottomBracket(Ground)	[ list 0 	[expr - $RearWheel(Radius) + $BottomBracket(depth) ] ]
		
				#
				# --- get FrontWheel 
			set FrontWheel(RimDiameter)	[ [ $domProject selectNodes /root/Component/Wheel/Front/RimDiameter	]  asText ]
			set FrontWheel(RimHeight)	[ [ $domProject selectNodes /root/Component/Wheel/Front/RimHeight	]  asText ]
			set FrontWheel(TyreHeight)	[ [ $domProject selectNodes /root/Component/Wheel/Front/TyreHeight	]  asText ]
			set FrontWheel(Radius)		[ expr 0.5*$FrontWheel(RimDiameter) + $FrontWheel(TyreHeight) ]
			set FrontWheel(DistanceBB)	[ [ $domProject selectNodes /root/Custom/WheelPosition/Front		]  asText ]
			set FrontWheel(Distance_X)	[ expr sqrt(pow($FrontWheel(DistanceBB),2) - pow(($FrontWheel(Radius) - $BottomBracket(height)),2)) ]
			set FrontWheel(Distance_Y)	[ expr $BottomBracket(depth) - $RearWheel(Radius) + $FrontWheel(Radius) ]
			set FrontWheel(Position)	[ list $FrontWheel(Distance_X) $FrontWheel(Distance_Y) ]

				#
				# --- get HandleBar - Position
			set HandleBar(Distance)		[ [ $domProject selectNodes /root/Personal/HandleBar_Distance		]  asText ]
			set HandleBar(Height)		[ [ $domProject selectNodes /root/Personal/HandleBar_Height			]  asText ]
			set HandleBar(Position)		[ list $HandleBar(Distance) $HandleBar(Height) ]
			
				#
				# --- get Fork -----------------------------
			set Fork(Height)				[ [ $domProject selectNodes /root/Component/Fork/Height					]  asText ]
			set Fork(Rake)					[ [ $domProject selectNodes /root/Component/Fork/Rake					]  asText ]
			set Fork(BladeWith)				[ [ $domProject selectNodes /root/Component/Fork/Blade/Width			]  asText ]
			set Fork(BladeDiameterDO)		[ [ $domProject selectNodes /root/Component/Fork/Blade/DiameterDO		]  asText ]
			set Fork(BladeTaperLength)		[ [ $domProject selectNodes /root/Component/Fork/Blade/TaperLength		]  asText ]
			set Fork(BladeOffset)			[ [ $domProject selectNodes /root/Component/Fork/Blade/Offset			]  asText ]
			set Fork(BladeOffsetCrown)		[ [ $domProject selectNodes /root/Component/Fork/Crown/Blade/Offset		]  asText ]
			set Fork(BladeOffsetCrownPerp)	[ [ $domProject selectNodes /root/Component/Fork/Crown/Blade/OffsetPerp	]  asText ]
			set Fork(BladeOffsetDO)			[ [ $domProject selectNodes /root/Component/Fork/DropOut/Offset			]  asText ]
			set Fork(BladeOffsetDOPerp)		[ [ $domProject selectNodes /root/Component/Fork/DropOut/OffsetPerp		]  asText ]
			set Fork(BrakeAngle)			[ [ $domProject selectNodes /root/Component/Fork/Crown/Brake/Angle		]  asText ]
			set Fork(BrakeOffset)			[ [ $domProject selectNodes /root/Component/Fork/Crown/Brake/Offset		]  asText ]
			set Fork(BrakeOffsetPerp)		[ [ $domProject selectNodes /root/Component/Fork/Crown/Brake/OffsetPerp	]  asText ]
			
				#
				# --- get Stem -----------------------------
			set Stem(Angle)				[ [ $domProject selectNodes /root/Component/Stem/Angle				]  asText ]
			set Stem(Length)			[ [ $domProject selectNodes /root/Component/Stem/Length				]  asText ]

				#
				# --- get HeadTube -------------------------
			set HeadTube(ForkRake)		$Fork(Rake)
			set HeadTube(ForkHeight)	$Fork(Height)
			set HeadTube(Diameter)		[ [ $domProject selectNodes /root/FrameTubes/HeadTube/Diameter		]  asText ]
			set HeadTube(Length)		[ [	$domProject selectNodes /root/FrameTubes/HeadTube/Length		]  asText ]

				#
				# --- get SeatTube -------------------------
			set SeatTube(Angle)			[ [ $domProject selectNodes /root/Personal/SeatTube_Angle  			]  asText ]
			set SeatTube(Length)		[ [ $domProject selectNodes /root/Personal/SeatTube_Length			]  asText ]
			set SeatTube(DiameterBB)	[ [ $domProject selectNodes /root/FrameTubes/SeatTube/DiameterBB	]  asText ]
			set SeatTube(DiameterTT)	[ [ $domProject selectNodes /root/FrameTubes/SeatTube/DiameterTT	]  asText ]
			set SeatTube(TaperLength)	[ [ $domProject selectNodes /root/FrameTubes/SeatTube/TaperLength	]  asText ]
			set SeatTube(Extension)		[ [ $domProject selectNodes /root/Custom/SeatTube/Extension			]  asText ]

				#
				# --- get DownTube -------------------------
			set DownTube(DiameterBB)	[ [ $domProject selectNodes /root/FrameTubes/DownTube/DiameterBB	]  asText ]
			set DownTube(DiameterHT)	[ [ $domProject selectNodes /root/FrameTubes/DownTube/DiameterHT	]  asText ]
			set DownTube(TaperLength)	[ [ $domProject selectNodes /root/FrameTubes/DownTube/TaperLength	]  asText ]
			set DownTube(OffsetHT)		[ [ $domProject selectNodes /root/Custom/DownTube/OffsetHT			]  asText ]
			set DownTube(OffsetBB)		[ [ $domProject selectNodes /root/Custom/DownTube/OffsetBB			]  asText ]				

				#
				# --- get TopTube --------------------------
			set TopTube(DiameterHT)		[ [ $domProject selectNodes /root/FrameTubes/TopTube/DiameterHT		]  asText ]
			set TopTube(DiameterST)		[ [ $domProject selectNodes /root/FrameTubes/TopTube/DiameterST		]  asText ]
			set TopTube(TaperLength)	[ [ $domProject selectNodes /root/FrameTubes/TopTube/TaperLength	]  asText ]
			set TopTube(PivotPosition)	[ [ $domProject selectNodes /root/Custom/TopTube/PivotPosition		]  asText ]
			set TopTube(OffsetHT)		[ [ $domProject selectNodes /root/Custom/TopTube/OffsetHT			]  asText ]
			set TopTube(Angle)			[ [ $domProject selectNodes /root/Custom/TopTube/Angle				]  asText ]
				
				#
				# --- get ChainStay ------------------------
			set ChainStay(DiameterBB)	[ [ $domProject selectNodes /root/FrameTubes/ChainStay/DiameterBB	]  asText ]
			set ChainStay(DiameterSS)	[ [ $domProject selectNodes /root/FrameTubes/ChainStay/DiameterSS	]  asText ]
			set ChainStay(TaperLength)	[ [ $domProject selectNodes /root/FrameTubes/ChainStay/TaperLength	]  asText ]
				
				#
				# --- get SeatStay -------------------------
			set SeatStay(DiameterST)	[ [ $domProject selectNodes /root/FrameTubes/SeatStay/DiameterST	]  asText ]
			set SeatStay(DiameterCS)	[ [ $domProject selectNodes /root/FrameTubes/SeatStay/DiameterCS	]  asText ]
			set SeatStay(TaperLength)	[ [ $domProject selectNodes /root/FrameTubes/SeatStay/TaperLength	]  asText ]
			set SeatStay(OffsetTT)		[ [ $domProject selectNodes /root/Custom/SeatStay/OffsetTT			]  asText ]

				#
				# --- get RearDropOut ----------------------
			set RearDrop(OffsetCS)		[ [ $domProject selectNodes /root/Component/RearDropOut/ChainStay/Offset	]  asText ]
			set RearDrop(OffsetCSPerp)	[ [ $domProject selectNodes /root/Component/RearDropOut/ChainStay/OffsetPerp ]  asText ]
			set RearDrop(OffsetSS)		[ [ $domProject selectNodes /root/Component/RearDropOut/SeatStay/Offset		]  asText ]
			set RearDrop(OffsetSSPerp)	[ [ $domProject selectNodes /root/Component/RearDropOut/SeatStay/OffsetPerp	]  asText ]
			set RearDrop(Derailleur_x)	[ [ $domProject selectNodes /root/Component/RearDropOut/Derailleur/x		]  asText ]
			set RearDrop(Derailleur_y)	[ [ $domProject selectNodes /root/Component/RearDropOut/Derailleur/y		]  asText ]
			
				#
				# --- get LegClearance - Position
			set LegClearance(Length)	[ [ $domProject selectNodes /root/Personal/InnerLeg_Length			]  asText ]
			set LegClearance(Position)	[ list $TopTube(PivotPosition) 	[expr $LegClearance(Length) - ($RearWheel(Radius) - $BottomBracket(depth)) ] ]

				#
				# --- get Saddle ---------------------------
			set Saddle(SeatPost_x)		[ [ $domProject selectNodes /root/Component/Saddle/SeatPost/x			]  asText ]
			set Saddle(SeatPost_y)		[ [ $domProject selectNodes /root/Component/Saddle/SeatPost/y			]  asText ]
			set Saddle(SeatPost_DM)		[ [ $domProject selectNodes /root/Component/Saddle/SeatPost/Diameter	]  asText ]
			set Saddle(Position)		[ vectormath::rotateLine {0 0}  $SeatTube(Length)  [ expr 180 - $SeatTube(Angle) ] ]
			set Saddle(Proposal)		[ vectormath::rotateLine {0 0}  [ expr 0.88*$LegClearance(Length) ]  [ expr 180 - $SeatTube(Angle) ] ]

				#
				# --- get HeadSet --------------------------
			set HeadSet(Diameter)		[ [ $domProject selectNodes /root/Component/HeadSet/Diameter		]  asText ]
			set HeadSet(Height_Top) 	[ [	$domProject selectNodes /root/Component/HeadSet/Height/Top		]  asText ]
			set HeadSet(Height_Bottom) 	[ [	$domProject selectNodes /root/Component/HeadSet/Height/Bottom	]  asText ]
			set HeadSet(ShimDiameter)	36
				
				#
				# --- get Front/Rear Brake PadLever --------------
			set RearBrake(LeverLength)	[ [ $domProject selectNodes /root/Component/Brake/Rear/LeverLength	]  asText ]
			set FrontBrake(LeverLength)	[ [ $domProject selectNodes /root/Component/Brake/Front/LeverLength	]  asText ]
				
				#
				# --- get BottleCage Offset ----------------------
			set BottleCage(SeatTube)		[ [ $domProject selectNodes /root/Component/BottleCage/SeatTube/OffsetBB		]  asText ]
			set BottleCage(DownTube)		[ [ $domProject selectNodes /root/Component/BottleCage/DownTube/OffsetBB		]  asText ]
			set BottleCage(DownTube_Lower)	[ [ $domProject selectNodes /root/Component/BottleCage/DownTube_Lower/OffsetBB	]  asText ]
								
				
				#
				#
				# --- set basePoints Attributes
				#
			
			lib_project::setValue /root/Result/Position/RearWheel			position	$RearWheel(Position)
			lib_project::setValue /root/Result/Position/FrontWheel			position	$FrontWheel(Position)
			lib_project::setValue /root/Result/Position/HandleBar 			position	$HandleBar(Position)
			lib_project::setValue /root/Result/Position/Saddle 				position	$Saddle(Position)
			lib_project::setValue /root/Result/Position/SaddleProposal		position	$Saddle(Proposal)
			lib_project::setValue /root/Result/Position/LegClearance		position	$TopTube(PivotPosition) 	[expr $LegClearance(Length) - ($RearWheel(Radius) - $BottomBracket(depth)) ]
			lib_project::setValue /root/Result/Position/BottomBracketGround	position	0 	[expr - $RearWheel(Radius) + $BottomBracket(depth) ] ;# Point on the Ground perp. to BB

			lib_project::setValue /root/Result/Lugs/Dropout/Front/Position	position 	$FrontWheel(Distance_X)	[expr $BottomBracket(depth) + ($FrontWheel(Radius) - $RearWheel(Radius))]
			lib_project::setValue /root/Result/Lugs/Dropout/Rear/Position	position 	[expr -1*$RearWheel(Distance_X)]	$BottomBracket(depth)
			lib_project::setValue /root/Result/Lugs/Dropout/Rear/Derailleur	position 	[ vectormath::addVector  $RearWheel(Position)  [list $RearDrop(Derailleur_x) $RearDrop(Derailleur_y)] ]

			
				#
				#
				# --- set basePoints Attributes
				#
			proc get_basePoints {} {
					variable HandleBar
					variable Saddle
					variable Steerer
					variable Stem
					variable Fork
					variable RearWheel
					variable FrontWheel
					variable BottomBracket
										
						set vect_01	 [ expr $Stem(Length) * cos($Stem(Angle) * $vectormath::CONST_PI / 180) ]
						set vect_02	 [ expr $vect_01 - $Fork(Rake) ]
						set help_03	 [ vectormath::cathetusPoint	$HandleBar(Position)	$FrontWheel(Position)	$vect_02  close ]
					set vect_HT 	 [ vectormath::parallel  		$help_03  				$FrontWheel(Position)	$Fork(Rake) ]
						set help_04  [ lindex $vect_HT 0 ]
						set help_05  [ lindex $vect_HT 1 ]
						set help_07  [ vectormath::rotatePoint		$HandleBar(Position)	$help_04	$Stem(Angle)	]			

						set Steerer(Stem)		[ vectormath::intersectPoint	$HandleBar(Position)  $help_07 $help_04 $help_05 ]
						set Steerer(Fork) 		[ vectormath::addVector			$help_05 	[ vectormath::unifyVector  $help_04  $help_05   -$Fork(Height) ] ]
					lib_project::setValue /root/Result/Tubes/Steerer/Start		position	$Steerer(Fork) 
					lib_project::setValue /root/Result/Tubes/Steerer/End		position	$Steerer(Stem)
					lib_project::setValue /root/Result/Lugs/ForkCrown/Position	position	$Steerer(Fork) 
					lib_project::setValue /root/Result/Tubes/Steerer/Direction	direction	$Steerer(Fork)	$Steerer(Stem)
				
						set help_08  [ vectormath::addVector	$BottomBracket(Ground) {200 0}] 
						
						set Steerer(Ground)		[ vectormath::intersectPoint 		$Steerer(Stem) $Steerer(Fork)  	$BottomBracket(Ground)  $help_08 ] 
						set SeatTube(Ground)	[ vectormath::intersectPoint 		$Saddle(Position) {0 0}  	$BottomBracket(Ground)  $help_08 ] 
					lib_project::setValue /root/Result/Position/SteererGround	position	$Steerer(Ground)		;# Point on the Ground in direction of Steerer
					lib_project::setValue /root/Result/Position/SeatTubeGround	position	$SeatTube(Ground)		;# Point on the Ground in direction of SeatTube
					lib_project::setValue /root/Result/Tubes/SeatTube/Direction	direction	$SeatTube(Ground)  $Saddle(Position)
						#
						# --- set summary Length of Frame, Saddle and Stem
						set summaryLength [ expr $RearWheel(Distance_X) + $FrontWheel(Distance_X)]
						set summaryHeight [ expr $BottomBracket(depth) + 40 + [lindex $Saddle(Position) 1] ]
					lib_project::setValue /root/Result/Position/SummarySize		position	$summaryLength	$summaryHeight
												
			}
			get_basePoints

			
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
					lib_project::setValue /root/Result/Tubes/ChainStay/Direction	direction	$pt_00
					
							set pt_00		[ vectormath::addVector 		$pt_00  $ChainStay(Direction)  -$RearDrop(OffsetCS) ]
							set pt_01		[ vectormath::addVector 		$pt_00  $ChainStay(Direction)  -$ChainStay(TaperLength) ]
					
							set ChainStay(RearWheel)			$pt_00
							set ChainStay(BottomBracket)		{0 0}
					lib_project::setValue /root/Result/Tubes/ChainStay/Start		position	{0 0}
					lib_project::setValue /root/Result/Tubes/ChainStay/End			position	$ChainStay(RearWheel)
				
							set vct_01 		[ vectormath::parallel 			$pt_00 $pt_01 [expr 0.5*$ChainStay(DiameterSS)] ]
							set vct_02 		[ vectormath::parallel 			$pt_01 $ChainStay(BottomBracket) [expr 0.5*$ChainStay(DiameterBB)] ]
							set vct_03 		[ vectormath::parallel 			$pt_01 $ChainStay(BottomBracket) [expr 0.5*$ChainStay(DiameterBB)] left]
							set vct_04 		[ vectormath::parallel 			$pt_00 $pt_01 [expr 0.5*$ChainStay(DiameterSS)] left]
					
							set polygon		[format "%s %s %s %s %s %s" \
													[lindex $vct_01 0] [lindex $vct_02 0] [lindex $vct_02 1] \
													[lindex $vct_03 1] [lindex $vct_03 0] [lindex $vct_04 0] ]												
					lib_project::setValue /root/Result/Tubes/ChainStay	polygon 	$polygon
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

					lib_project::setValue /root/Result/Tubes/Steerer/Direction	direction	$HeadTube(Direction)
					lib_project::setValue /root/Result/Tubes/HeadTube/Direction	direction	$HeadTube(Direction)
							
							set HeadTube(Fork)				[ vectormath::addVector 	$Steerer(Fork)	$HeadTube(Direction)	$HeadSet(Height_Bottom) ]
							set HeadTube(Stem)				[ vectormath::addVector 	$HeadTube(Fork)	$HeadTube(Direction)	$HeadTube(Length) ]
					lib_project::setValue /root/Result/Tubes/HeadTube/Start		position	$HeadTube(Fork)
					lib_project::setValue /root/Result/Tubes/HeadTube/End		position	$HeadTube(Stem)
							
							set vct_01 		[ vectormath::parallel 			$HeadTube(Fork) $HeadTube(Stem) [expr 0.5*$HeadTube(Diameter)] ]
							set vct_ht 		[ vectormath::parallel 			$HeadTube(Stem) $HeadTube(Fork) [expr 0.5*$HeadTube(Diameter)] ]
					
							set polygon 	[format "%s %s %s %s" \
													[lindex $vct_01 0] [lindex $vct_01 1] \
													[lindex $vct_ht 0] [lindex $vct_ht 1] ]
					lib_project::setValue /root/Result/Tubes/HeadTube	polygon 	$polygon
			}
			get_HeadTube
			
																
				#
				# --- set DownTube ------------------------
			proc get_DownTube {} {
					variable HeadTube 
					variable DownTube 
					variable Saddle 
					variable Steerer 
			
							set vct_ht 		[ vectormath::parallel 			$HeadTube(Stem) $HeadTube(Fork) [expr 0.5*$HeadTube(Diameter)] ]
							set pt_00		[split [ lib_project::getValue /root/Result/Tubes/HeadTube/Polygon	polygon 3 ] , ]
								# puts "   ... $pt_00  ... [ lib_project::getValue /root/Result/Tubes/HeadTube/Polygon	polygon ]"
							set pt_01		[ vectormath::addVector 		$pt_00 $HeadTube(Direction) $DownTube(OffsetHT) ]	;# bottom intersection DownTube/HeadTube
							set pt_02		[ vectormath::cathetusPoint 	{0 0}  $pt_01 [expr 0.5 * $DownTube(DiameterHT) - $DownTube(OffsetBB) ]]
							set vct_01      [ vectormath::parallel 			$pt_02 $pt_01 [expr 0.5 * $DownTube(DiameterHT)] left]	;# DownTube centerline Vector
							set DownTube(Direction)		[ vectormath::unifyVector [lindex $vct_01 0] [lindex $vct_01 1] ]
					lib_project::setValue /root/Result/Tubes/DownTube/Direction	direction	$DownTube(Direction)

							set vct_02      [ vectormath::parallel 			$pt_02 $pt_01 $DownTube(DiameterHT) left]				;# DownTube upper Vector
							set pt_04       [ vectormath::intersectPoint 	[lindex $vct_02 0] [lindex $vct_02 1] \
																			[lindex $vct_ht 0] [lindex $vct_ht 1] ] ;# top intersection DownTube/HeadTube
							
							set DownTube(BottomBracket)	[ vectormath::intersectPoint [lindex $vct_01 0] [lindex $vct_01 1]  {0 0}	$Saddle(Position) ]
							set DownTube(HeadTube)		[ vectormath::intersectPoint [lindex $vct_01 0] [lindex $vct_01 1]  $Steerer(Fork)	 $Steerer(Stem) ]			
					lib_project::setValue /root/Result/Tubes/DownTube/Start		position	$DownTube(BottomBracket)
					lib_project::setValue /root/Result/Tubes/DownTube/End		position	$DownTube(HeadTube)
							
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
							set is_dt_ht	[ tube_intersection	$DownTube(DiameterHT) $dir  $HeadTube(Diameter)  $HeadTube(Direction)  $DownTube(HeadTube) ]				

							set polygon		[ list            [lindex $vct_10 0] [lindex $vct_10 1] [lindex $vct_21 0]]
							set polygon		[ lappend polygon [lib_project::flatten_nestedList $is_dt_ht]]
							set polygon		[ lappend polygon [lindex $vct_22 0] [lindex $vct_11 1] [lindex $vct_11 0]]					
					lib_project::setValue /root/Result/Tubes/DownTube	polygon 	[lib_project::flatten_nestedList $polygon]				
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
					lib_project::setValue /root/Result/Tubes/SeatTube/Direction	direction 	$Saddle(Position) 	;# direction vector of SeatTube			
							
							set vct_ht 		[ vectormath::parallel 			$HeadTube(Stem) $HeadTube(Fork) [expr 0.5*$HeadTube(Diameter)] ]
							set pt_00		[lindex $vct_ht 0]
							set pt_01		[ vectormath::addVector 		$pt_00 $HeadTube(Direction) -$TopTube(OffsetHT) ]	;# top intersection TopTube/HeadTube
					
							set TopTube(Direction)			[ vectormath::rotatePoint {0 0} {-1 0} $TopTube(Angle) ]	;# direction vector of TopTube
					lib_project::setValue /root/Result/Tubes/TopTube/Direction	direction 	[ vectormath::rotatePoint {0 0} {-1 0} $TopTube(Angle) ]	;# direction vector of TopTube			
							
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
					lib_project::setValue /root/Result/Tubes/TopTube/Start		position 	$TopTube(SeatTube)				
					lib_project::setValue /root/Result/Tubes/TopTube/End		position 	$TopTube(HeadTube)				
					
							set is_tt_ht	[ tube_intersection	$TopTube(DiameterHT) $TopTube(Direction)  $HeadTube(Diameter)	  $HeadTube(Direction)  $TopTube(HeadTube) right]	
							set is_tt_st	[ tube_intersection	$TopTube(DiameterST) $TopTube(Direction)  $SeatTube(DiameterTT)  $SeatTube(Direction)  $TopTube(SeatTube) left ]				

							set polygon		[ lib_project::flatten_nestedList $is_tt_ht]
							set polygon		[ lappend polygon [lindex $vct_10 1] [lindex $vct_21 0]]
							set polygon		[ lappend polygon [lib_project::flatten_nestedList $is_tt_st]]
							set polygon		[ lappend polygon [lindex $vct_22 0] [lindex $vct_11 1]]												
					lib_project::setValue /root/Result/Tubes/TopTube	polygon 	[lib_project::flatten_nestedList $polygon]

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
					lib_project::setValue /root/Result/Tubes/SeatTube/Start		position 	$SeatTube(BottomBracket)			
					lib_project::setValue /root/Result/Tubes/SeatTube/End		position 	$SeatTube(TopTube)				
					
							set polygon	[format "%s %s %s %s %s %s %s %s" \
											[lindex $vct_10 0]  [lindex $vct_10 1] \
											[lindex $vct_21 0]  [lindex $vct_21 1] \
											[lindex $vct_22 1]  [lindex $vct_22 0] \
											[lindex $vct_11 1]  [lindex $vct_11 0] ]
					lib_project::setValue /root/Result/Tubes/SeatTube	polygon 	$polygon									
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
					lib_project::setValue /root/Result/Tubes/SeatStay/Direction	direction	$SeatStay(Direction)	;# direction vector of SeatStay	
					
							set pt_10		[ vectormath::addVector		$pt_01  $SeatStay(Direction)  $RearDrop(OffsetSS) ]
							set pt_11		[ vectormath::addVector		$pt_10  $SeatStay(Direction)  $SeatStay(TaperLength) ]
							set pt_12		$pt_00
							set vct_10 		[ vectormath::parallel $pt_10 $pt_11 [expr 0.5*$SeatStay(DiameterCS)] ]
							set vct_11 		[ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$SeatStay(DiameterST)] ]
							set vct_12 		[ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$SeatStay(DiameterST)] left]
							set vct_13 		[ vectormath::parallel $pt_10 $pt_11 [expr 0.5*$SeatStay(DiameterCS)] left]
					
						set SeatStay(SeatTube)		$pt_00		
						set SeatStay(RearWheel)		$pt_10
					lib_project::setValue /root/Result/Tubes/SeatStay/Start		position 	$SeatStay(RearWheel)				
					lib_project::setValue /root/Result/Tubes/SeatStay/End		position 	$SeatStay(SeatTube)				
							
							set dir 		[ vectormath::addVector {0 0} $SeatStay(Direction) -1] 
							set offset		[ expr 0.5 * ($SeatTube(DiameterTT) - $SeatStay(DiameterST)) ]
							set is_ss_st	[ tube_intersection	$SeatStay(DiameterST) $dir  $SeatTube(DiameterTT)	  $SeatTube(Direction)  $SeatStay(SeatTube)  right $offset]	
						
						set SeatStay(debug) 			$is_ss_st
							
							set polygon		[ lib_project::flatten_nestedList  $is_ss_st ]
							set polygon		[ lappend polygon 	[lindex $vct_12 0] [lindex $vct_13 0] \
																[lindex $vct_10 0] [lindex $vct_11 0] ]										
					lib_project::setValue /root/Result/Tubes/SeatStay	polygon 	[lib_project::flatten_nestedList $polygon]					
						
						#
						# --- set SeatStay / ChainStay - Intersection
							set ChainStay(SeatStay_IS)		[ vectormath::intersectPoint $SeatStay(SeatTube) $SeatStay(RearWheel) $ChainStay(BottomBracket) $ChainStay(RearWheel) ];# intersection of ChainStay and SeatStay centerlines	
					lib_project::setValue /root/Result/Tubes/ChainStay/SeatStay_IS	position	$ChainStay(SeatStay_IS) ;# Point on the Ground perp. to BB
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
								set hlp_00		{0 0}													;# point where Taper begins
								set hlp_01		[ list $Fork(BladeTaperLength)	$Fork(BladeOffset) ]	;# point where Taper ends
								set vct_taper	[ vectormath::unifyVector 	$hlp_00 $hlp_01 ]	;# direction caused by taper offset
								set hlp_02		[ vectormath::addVector 	$hlp_01 [vectormath::scalePointList {0 0} $vct_taper $Fork(BladeOffsetDO) ] ]
								set vct_dropout	[ vectormath::parallel 		$hlp_00	$hlp_02 	$Fork(BladeOffsetDOPerp) left]
								set hlp_03		[ lindex $vct_dropout 1 ]								;# location of Dropout in reference to point where Taper begins
							set offsetDO		[ expr [ lindex $hlp_03 0] - $Fork(BladeTaperLength) ]
							set offsetDO_Perp	[ lindex $hlp_03 1]
							set pt_03			[ vectormath::cathetusPoint	$pt_02  $pt_99  $offsetDO_Perp  opposite ]	;# point on direction of untapered area of ForkBlade perp through FrontWheel

							set ForkBlade(Direction)	[ vectormath::unifyVector $pt_03 $pt_02 ]
					lib_project::setValue /root/Result/Tubes/ForkBlade/Direction	direction	$ForkBlade(Direction)	;# direction vector of ForkBlade
									
							set pt_04			[ vectormath::addVector		$pt_03  [vectormath::scalePointList {0 0} $ForkBlade(Direction) $offsetDO ] ]	;# point on direction of untapered area of ForkBlade perp through Blade Tip
								set vct_offset	[ vectormath::parallel		$pt_02  $pt_04  $Fork(BladeOffset) left]	;
							set pt_10		$pt_99						;# Dropout
							set pt_11		[ lindex $vct_offset 1 ]	;# Fork Blade Tip
							set pt_12		[ vectormath::addVector		$pt_04	[vectormath::scalePointList {0 0} $ForkBlade(Direction) $Fork(BladeTaperLength) ] ] ;# point on direction of untapered area where tapering starts
																		;# Fork Blade taper start
							set pt_13		$pt_02						;# Crown Fork Blade center
					lib_project::setValue /root/Result/Tubes/ForkBlade/Start		position 	$pt_13				
					lib_project::setValue /root/Result/Tubes/ForkBlade/End			position 	$pt_11				
						
							set vct_10 		[ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$Fork(BladeDiameterDO)] ]
							set vct_11 		[ vectormath::parallel $pt_12 $pt_13 [expr 0.5*$Fork(BladeWith)] ]
							set vct_12 		[ vectormath::parallel $pt_12 $pt_13 [expr 0.5*$Fork(BladeWith)] left]
							set vct_13 		[ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$Fork(BladeDiameterDO)] left ]
					
							set polygon	[format "%s %s %s %s %s %s" \
											[lindex $vct_10 0]  [lindex $vct_11 0] [lindex $vct_11 1]  \
											[lindex $vct_12 1]  [lindex $vct_12 0] [lindex $vct_13 0] ]					
					lib_project::setValue /root/Result/Tubes/ForkBlade		polygon 	$polygon			
							
						#
						# --- set Fork Dropout --------------------
							set Fork(DropoutDirection)	[ vectormath::unifyVector $pt_12 $pt_11 ]					
					lib_project::setValue /root/Result/Lugs/Dropout/Front/Direction	direction	$Fork(DropoutDirection)				

						#
						# --- set Fork Crown ----------------------
							set Fork(CrownDirection)	$Steerer(Direction)					
					lib_project::setValue /root/Result/Lugs/ForkCrown/Direction		direction	$Fork(CrownDirection)				
			}
			get_Fork			


				#
				# --- set Steerer -------------------------
			proc get_Steerer {} {
					variable HeadTube
					variable Steerer

					lib_project::setValue /root/Result/Tubes/Steerer/End		position 	$Steerer(Stem)
							
							set vct_01 		[ vectormath::parallel 			$Steerer(Fork)  $Steerer(Stem) [expr 0.5 * ($HeadTube(Diameter)-7)] ]
							set vct_ht 		[ vectormath::parallel 			$Steerer(Stem)	$Steerer(Fork)  [expr 0.5 * ($HeadTube(Diameter)-7)] ]
							set polygon		[format "%s %s %s %s" \
													[lindex $vct_01 0] [lindex $vct_01 1] \
													[lindex $vct_ht 0] [lindex $vct_ht 1] ]					
					lib_project::setValue /root/Result/Tubes/Steerer	polygon 	$polygon
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
					lib_project::setValue /root/Result/Components/SeatPost	polygon 	[lib_project::flatten_nestedList $polygon]
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
					
					lib_project::setValue /root/Result/Components/HeadSet/Bottom	polygon 	[lib_project::flatten_nestedList $polygon]

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
													
					lib_project::setValue /root/Result/Components/HeadSet/Top	polygon 	[lib_project::flatten_nestedList $polygon]
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
					lib_project::setValue /root/Result/Components/Stem	polygon 	[lib_project::flatten_nestedList $polygon]
			}
			get_Stem

						
				#
				# --- fill Result Values ------------------
			proc fill_resultValues {domProject} {					
					variable HeadTube
					variable Steerer
					variable RearWheel
					variable FrontWheel
					variable Saddle
					
							# puts ""
							# puts "       ... fill_resultValues"
							# puts "      -------------------------------" 
							# puts "           "

						# --- HeadTube
						#
					set position	$HeadTube(Stem)

							# --- HeadTube/ReachLength
							#
						set xpath Temporary/HeadTube/ReachLength
							# puts "           ... $xpath"
							# puts "                ... [ frame_geometry::object_values		HeadTube Stem			{0 0} ]" 
						set value		[ format "%.2f" [lindex $position 0] ]	
						set node	 	[ $domProject selectNodes /root/$xpath/text() ]
							# puts "                  ... $value"
						$node nodeValue		$value

							# --- HeadTube/StackHeight
							#
						set xpath Temporary/HeadTube/StackHeight
							# puts "           ... $xpath"
							# puts "                ... [ frame_geometry::object_values		HeadTube Stem			{0 0} ]" 
						set value		[ format "%.2f" [lindex $position 1] ]	
						set node	 	[ $domProject selectNodes /root/$xpath/text() ]
							# puts "                  ... $value"
						$node nodeValue		$value

						
						# --- HeadTube/Angle
						#
					set xpath Temporary/HeadTube/Angle
						# puts "           ... $xpath"
						# puts "                   ... $frameCoords::Steerer_Stem" 
						# puts "                   ... $frameCoords::Steerer_Ground" 
					set value			[ format "%.2f" [ expr -1 * [ vectormath::dirAngle $Steerer(Stem) $Steerer(Ground) ] ] ]
						set node	 	[ $domProject selectNodes /root/$xpath/text() ]
						# puts "                  ... $value"
					$node nodeValue		$value
					
					
						# --- HeadTube/TopTubeAngle
						#
					set xpath Temporary/HeadTube/TopTubeAngle
						# puts "           ... $xpath"
						# puts "                   ... $frameCoords::Steerer_Stem" 
						# puts "                   ... $frameCoords::Steerer_Ground"
						set HeadTubeAngle 	[[ $domProject selectNodes /root/Temporary/HeadTube/Angle/text() ] asText]
						set TopTubeAngle 	[[ $domProject selectNodes /root/Custom/TopTube/Angle/text()  ] asText]
						# puts "     $HeadTubeAngle  $TopTubeAngle"
					set value			[ format "%.2f" [ expr  $HeadTubeAngle + $TopTubeAngle] ]
						set node	 	[ $domProject selectNodes /root/$xpath/text() ]
						# puts "                  ... $value"
					$node nodeValue		$value
					
					
						# --- SeatTube
						#
					set position	[ frame_geometry::object_values		SeatTube/End	position	{0 0} ]
					
							# --- SeatTube/TubeLength
							#
						set xpath Temporary/SeatTube/TubeLength
							# puts "           ... $xpath"
							# puts "                   ... [ frame_geometry::object_values		SeatTube TopTube	{0 0} ]" 
						set value		[ format "%.2f" [ expr hypot([lindex $position 0],[lindex $position 1]) ] ]
						set node	 	[ $domProject selectNodes /root/$xpath/text() ]
							# puts "                  ... $value"
						$node nodeValue		$value
						
							# --- SeatTube/TubeHeight
							#
						set xpath Temporary/SeatTube/TubeHeight
							# puts "           ... $xpath"
							# puts "                   ... [ frame_geometry::object_values		SeatTube TopTube	{0 0} ]" 
						set value		[ format "%.2f" [lindex $position 1] ]
						set node	 	[ $domProject selectNodes /root/$xpath/text() ]
							# puts "                  ... $value"
						$node nodeValue		$value

						
						# --- Saddle/Offset_BB/horizontal
						#
					set position	$Saddle(Position)					
					set xpath Temporary/Saddle/Offset_BB/horizontal
						# puts "           ... $xpath"
						# puts "                ... $frameCoords::Saddle" 
					set value		[ format "%.2f" [expr -1 * [lindex $position 0]] ]	
					set node	 	[ $domProject selectNodes /root/$xpath/text() ]
						# puts "                  ... $value"
					$node nodeValue		$value

					
						# --- WheelPosition/front/horizontal
						#
					set position	$FrontWheel(Position)					
					set xpath Temporary/WheelPosition/front/horizontal
						# puts "           ... $xpath"
						# puts "                ... $frameCoords::FrontWheel" 
					set value		[ format "%.2f" [lindex $position 0] ]	
					set node	 	[ $domProject selectNodes /root/$xpath/text() ]
						# puts "                  ... $value"
					$node nodeValue		$value

					
						# --- WheelPosition/rear/horizontal
						#
					set position	$RearWheel(Position)
					set xpath Temporary/WheelPosition/rear/horizontal
						# puts "           ... $xpath"
						# puts "                ... $frameCoords::RearWheel" 
					set value		[ format "%.2f" [expr -1 * [lindex $position 0]] ]	
					set node	 	[ $domProject selectNodes /root/$xpath/text() ]
						# puts "                  ... $value"
					$node nodeValue		$value
					
						# puts "[[ $domProject selectNodes /root/Result ] asXML]"
						# puts "[ $node asText ]"
						# puts "        ... position  $position"
						# puts "        ... value       $value"
			}
			fill_resultValues $domProject


				#
				# --- set RearBrakeMount ------------------
			proc get_RearBrakeMount {} {
					variable HeadTube
					variable RearBrake
					variable RearWheel
					variable SeatStay

							set brakeShoeDist	30
							set pt_00			$RearWheel(Position)
							set pt_01					[split [ lib_project::getValue /root/Result/Tubes/SeatStay/Polygon	polygon 8 ] , ]
							set pt_02					[split [ lib_project::getValue /root/Result/Tubes/SeatStay/Polygon	polygon 9 ] , ]
							set RimBrakeRadius	[ expr 0.5 * $RearWheel(RimDiameter) ]
							set pt_03			[ vectormath::intersectPerp	$pt_02 $pt_01 $pt_00 ]	;# point on SeatStay through RearWheel
							set vct_01			[ vectormath::parallel $pt_01 $pt_03 $brakeShoeDist ]
							set pt_04			[ lindex $vct_01 1 ]
							set dist_00			[ vectormath::length $pt_00 $pt_04 ]
							set dist_00_Ortho	[ expr sqrt(pow($RimBrakeRadius,2)  - pow($dist_00,2)) ]
							
							set RearBrake(Shoe)		[ vectormath::addVector	$pt_04 [ vectormath::unifyVector {0 0} $SeatStay(Direction) $dist_00_Ortho] ]
							set RearBrake(Help)		[ vectormath::addVector	$pt_04 [ vectormath::unifyVector {0 0} $SeatStay(Direction) [expr $RearBrake(LeverLength) + $dist_00_Ortho] ] ]
							
							set RearBrake(Mount)	[ vectormath::addVector	$pt_03 [ vectormath::unifyVector {0 0} $SeatStay(Direction) [expr $RearBrake(LeverLength) + $dist_00_Ortho] ] ]
					lib_project::setValue /root/Result/Position/BrakeMountRear	position	$RearBrake(Mount)
			}
			get_RearBrakeMount


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
					lib_project::setValue /root/Result/Tubes/SeatTube/BottleCage/Base			position	$SeatTube(BottleCage_Base) 				
					lib_project::setValue /root/Result/Tubes/SeatTube/BottleCage/Offset			position	$SeatTube(BottleCage_Offset)				
														
							set pt_00 	[ vectormath::addVector {0 0}	$DownTube(Direction) 	$BottleCage(DownTube)				]
							set vct_01	[ vectormath::parallel	{0 0}	$pt_00 					[expr -0.5 * $DownTube(DiameterBB)] ]
							set DownTube(BottleCage_Base) 			[ lindex $vct_01 1 ]
							set DownTube(BottleCage_Offset)			[ vectormath::addVector		$DownTube(BottleCage_Base)			$DownTube(Direction) 64.0 ]
					lib_project::setValue /root/Result/Tubes/DownTube/BottleCage/Base			position	$DownTube(BottleCage_Base)
					lib_project::setValue /root/Result/Tubes/DownTube/BottleCage/Offset			position	$DownTube(BottleCage_Offset)				
					
							set pt_00 	[ vectormath::addVector {0 0}	$DownTube(Direction) 	$BottleCage(DownTube_Lower)			]
							set vct_01	[ vectormath::parallel	{0 0}	$pt_00 					[expr  0.5 * $DownTube(DiameterBB)] ]
							set DownTube(BottleCage_Lower_Base) 	[ lindex $vct_01 1 ]
							set DownTube(BottleCage_Lower_Offset)	[ vectormath::addVector		$DownTube(BottleCage_Lower_Base)	$DownTube(Direction) 64.0 ]
					lib_project::setValue /root/Result/Tubes/DownTube/BottleCage_Lower/Base		position	$DownTube(BottleCage_Lower_Base)
					lib_project::setValue /root/Result/Tubes/DownTube/BottleCage_Lower/Offset	position	$DownTube(BottleCage_Lower_Offset)									
			}
			get_BottleCageMount

			
				#
				# --- set FrontBrakeMount -----------------
			proc get_FrontBrakeMount {} {
					variable Fork
					variable FrontBrake
					variable HeadTube
					variable Steerer

							set brakeShoeDist	30
							set pt_00			$Steerer(Fork)
							set pt_01			[ vectormath::addVector	$pt_00 [ vectormath::unifyVector {0 0} $HeadTube(Direction) -$Fork(BrakeOffsetPerp)] ]
							set vct_01			[ vectormath::parallel  $pt_00 $pt_01 $Fork(BrakeOffset) left]
							set pt_10			[ lindex $vct_01 1]
							set pt_11			[ vectormath::addVector	$pt_10 [ vectormath::unifyVector {0 0} $HeadTube(Direction) -$FrontBrake(LeverLength)] ] 
							set pt_12			[ vectormath::rotatePoint	$pt_10	$pt_11	$Fork(BrakeAngle) ]
							set vct_02			[ vectormath::parallel  $pt_10 $pt_12 $brakeShoeDist left]
					
							set FrontBrake(Help)	[ lindex $vct_02 0]
							set FrontBrake(Shoe)	[ lindex $vct_02 1]
							
							set FrontBrake(Mount)				$pt_10		
					lib_project::setValue /root/Result/Position/BrakeMountFront	position	$FrontBrake(Mount)
			}
			get_FrontBrakeMount


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
				# --- set TubeMitter -----------------
			proc get_TubeMitter {} {
					variable HeadTube
					variable SeatTube
					variable SeatStay
					variable TopTube
					variable DownTube
					variable TubeMitter

							set dir 		[ vectormath::scalePointList {0 0} [ frame_geometry::object_values HeadTube direction ] -1.0 ]
								# puts " .. \$dir $dir"
					set TubeMitter(TopTube_Head) 		[ tube_mitter	$TopTube(DiameterHT)  $TopTube(Direction)	$HeadTube(Diameter)		$HeadTube(Direction)	$TopTube(HeadTube)  ]	
					set TubeMitter(TopTube_Seat) 		[ tube_mitter	$TopTube(DiameterST)  $TopTube(Direction)	$SeatTube(DiameterTT)	$dir  					$TopTube(SeatTube)  ]	
					set TubeMitter(DownTube_Head) 		[ tube_mitter	$DownTube(DiameterHT) $DownTube(Direction)	$HeadTube(Diameter)		$HeadTube(Direction)	$DownTube(HeadTube) ]				
							set offset		[ expr 0.5 * ($SeatTube(DiameterTT) - $SeatStay(DiameterST)) ]
							set dir 		[ vectormath::scalePointList {0 0} [ frame_geometry::object_values SeatStay direction ] -1.0 ]
								# puts " .. \$dir $dir"
					set TubeMitter(SeatStay_01) 		[ tube_mitter	$SeatStay(DiameterST) $dir  $SeatTube(DiameterTT)	  $SeatTube(Direction)  $SeatStay(SeatTube)  right -$offset]	
					set TubeMitter(SeatStay_02) 		[ tube_mitter	$SeatStay(DiameterST) $dir  $SeatTube(DiameterTT)	  $SeatTube(Direction)  $SeatStay(SeatTube)  right +$offset]	
					set TubeMitter(Reference) 			{ -50 0  50 0  50 10  -50 10 }
					
					lib_project::setValue /root/Result/TubeMitter/TopTube_Head		polygon		[ lib_project::flatten_nestedList $TubeMitter(TopTube_Head) 	]
					lib_project::setValue /root/Result/TubeMitter/TopTube_Seat		polygon		[ lib_project::flatten_nestedList $TubeMitter(TopTube_Seat)		]
					lib_project::setValue /root/Result/TubeMitter/DownTube_Head		polygon		[ lib_project::flatten_nestedList $TubeMitter(DownTube_Head)	]
					lib_project::setValue /root/Result/TubeMitter/SeatStay_01		polygon		[ lib_project::flatten_nestedList $TubeMitter(SeatStay_01)		]
					lib_project::setValue /root/Result/TubeMitter/SeatStay_02		polygon		[ lib_project::flatten_nestedList $TubeMitter(SeatStay_02)		]
					lib_project::setValue /root/Result/TubeMitter/Reference			polygon		[ lib_project::flatten_nestedList $TubeMitter(Reference) 		]						
			}
			get_TubeMitter
			
	}


 	#-------------------------------------------------------------------------
		#  return BottomBracket coords 
	proc get_BottomBracket_Position {cv_Name bottomCanvasBorder {option {bicycle}} {stageScale {}}} {
						
			variable  RearWheel
			variable  FrontWheel
			variable  BottomBracket
			
			array set Stage {}		
		
			set FrameSize	[ split [ lib_project::getValue /root/Result/Position/SummarySize			position  ] , ]
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
				set BtmBracket_y		[ expr $cvBorder + $RearWheel(Radius) - $BottomBracket(depth) ] 
					# puts "\n -> get_BottomBracket_Position:  $cvBorder + $RearWheel(Radius) - $BottomBracket(depth) " 
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
			switch -exact $index {

				polygon	{	set returnValue	{}
							switch -exact $object {
								Stem 			-
								HeadSet/Top 	-
								HeadSet/Bottom 	-
								SeatPost 	{ 
												set branch "Components/$object/Polygon"
											}
											
								TubeMitter/TopTube_Head -
								TubeMitter/TopTube_Seat -
								TubeMitter/DownTube_Head -					
								TubeMitter/SeatStay_01	-
								TubeMitter/SeatStay_02	-
								TubeMitter/Reference {
												set branch "$object/Polygon"	; # puts " ... $branch"	
											}
											
								default 	{ 
												set branch "Tubes/$object/Polygon"		
											}
							}
								# puts "    ... $branch"
							set svgList	[ lib_project::getValue /root/Result/$branch	polygon ]
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
								BrakeMountFront -
								BrakeMountRear -
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
											set branch "Tubes/$object"	
										}
							}
							
							set pointValue	[ lib_project::getValue /root/Result/$branch	position ]	; # puts "    ... $pointValue"
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
							
							set directionValue	[ lib_project::getValue /root/Result/$branch	direction ]	; # puts "    ... $directionValue"
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
	proc set_compositeFork {domInit BB_Position} {
			
			set ForkDropout(position)	[ frame_geometry::object_values		FrontWheel		position	$BB_Position]
			set Steerer_Fork(position)	[ frame_geometry::object_values		Steerer/Start	position	$BB_Position]
			set ht_direction			[ frame_geometry::object_values		HeadTube		direction ]

			set Fork(BladeWith)				[ [ $domInit selectNodes /root/Options/Fork/Composite/Visualization/Blade/Width			]  asText ]
			set Fork(BladeDiameterDO)		[ [ $domInit selectNodes /root/Options/Fork/Composite/Visualization/Blade/DiameterDO	]  asText ]
			set Fork(BladeOffsetCrown)		[ [ $domInit selectNodes /root/Options/Fork/Composite/Visualization/Crown/Blade/Offset		]  asText ]
			set Fork(BladeOffsetCrownPerp)	[ [ $domInit selectNodes /root/Options/Fork/Composite/Visualization/Crown/Blade/OffsetPerp	]  asText ]
			set Fork(BladeOffsetDO)			[ [ $domInit selectNodes /root/Options/Fork/Composite/Visualization/DropOut/Offset		]  asText ]
			
				# puts ""
				# puts "   Fork(BladeWith)			$Fork(BladeWith)			"
				# puts "   Fork(BladeDiameterDO)		$Fork(BladeDiameterDO)		"
				# puts "   Fork(BladeOffsetCrown)		$Fork(BladeOffsetCrown)		"
				# puts "   Fork(BladeOffsetCrownPerp)	$Fork(BladeOffsetCrownPerp)	"
				# puts "   Fork(BladeOffsetDO)		$Fork(BladeOffsetDO)		"
		
			set ht_angle				[ vectormath::angle {0 1} {0 0} $ht_direction ]
				set vct_03					[list [expr -1 * $Fork(BladeOffsetCrownPerp)] $Fork(BladeOffsetCrown) ]
				set vct_04					[ vectormath::rotatePoint {0 0} $vct_03 $ht_angle ]
			set pt_02				[ vectormath::subVector $Steerer_Fork(position) $vct_04 ]
				set help_02					[ list 0 [lindex  $ForkDropout(position) 1] ]			
				set do_angle				[ expr 90 - [ vectormath::angle $pt_02 $ForkDropout(position) $help_02  ] ]			
				set vct_05					[ list $Fork(BladeOffsetDO) 0 ]
				set vct_06					[ vectormath::rotatePoint {0 0} $vct_05 [expr 90 + $do_angle] ]
			set pt_03				[ vectormath::addVector $ForkDropout(position)  $vct_06 ]
				set vct_01					[ vectormath::rotatePoint {0 0} {0 5} $do_angle ]
			set pt_01				[ vectormath::addVector $pt_02 $vct_01 ]
			
			set vct_10 		[ vectormath::parallel $pt_01 $pt_02 [expr 0.5*$Fork(BladeWith) -1] ]
			set vct_11 		[ vectormath::parallel $pt_02 $pt_03 [expr 0.5*$Fork(BladeWith)] ]
			set vct_12 		[ vectormath::parallel $pt_01 $pt_03 [expr 0.5*$Fork(BladeDiameterDO)] ]
			set vct_13 		[ vectormath::parallel $pt_03 $pt_01 [expr 0.5*$Fork(BladeDiameterDO)] ]
			set vct_14 		[ vectormath::parallel $pt_03 $pt_02 [expr 0.5*$Fork(BladeWith)] ]
			set vct_15 		[ vectormath::parallel $pt_02 $pt_01 [expr 0.5*$Fork(BladeWith) -1] ]
			
			set polygon 		[format "%s %s %s %s %s %s" \
												[lindex $vct_10 0]  [lindex $vct_11 0]  [lindex $vct_12 1]  \
												[lindex $vct_13 0]  [lindex $vct_14 1]  [lindex $vct_15 1] ]
				# set ForkBlade(polygon) 		[format "%s %s %s %s %s %s" \
													[lindex $vct_10 0]  [lindex $vct_11 0]  [lindex $vct_12 1]  \
													[lindex $vct_13 0]  [lindex $vct_14 1]  [lindex $vct_15 1] ]
													
				# return $ForkBlade(polygon)
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
		#  create TubeMitter
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
	proc tube_mitter { diameter direction diameter_isect direction_isect isectionPoint {side {right}} {offset {0}} } {	

		set intersection_angle 	[vectormath::angle $direction {0 0} $direction_isect]
		
			# puts [format " -> tube_mitter \n   %2.f %2.f" $direction_angle $intersection_angle]
		set radius 			[expr 0.5*$diameter]
		set radius_isect 	[expr 0.5*$diameter_isect]
		set angle 		-180
		set loops 		36
		set perimeter	[expr $radius * [vectormath::rad 360] ]
		set coordList 	[list [expr 0.5*$perimeter] -70]
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
 	proc createEdit { x y cv_Name updateCommand xpathList {title {Edit:}}} {
			variable _update
			variable _updateValue
			
			# --- local procedures ---
				proc change_ValueEdit {textVar direction} {
						#
						# --- update value of spinbox ---
							if {$direction eq "up"} {\
								set ::$textVar [expr {[set ::$textVar]+1.0}]\
							} else {\
								set ::$textVar [expr {[set ::$textVar]-1.0}]\
							}
				}
				
				proc create_ValueEdit {cv cv_Name cvEdit cvContentFrame index labelText textVar updateCommand xpath} {					
						#
						# --- create cvLabel, cvEntry ---
							set	cvLabel [label  $cvContentFrame.label_${index} -text "${labelText} : "]
								# set cvEntry [entry  $cvContentFrame.value_${index} -textvariable $textVar  -justify right  -relief sunken -bd 1  -width 10]
							set cvEntry [spinbox $cvContentFrame.value_${index} -textvariable $textVar -justify right -relief sunken -width 10 -bd 1]
							$cvEntry configure -command \
								"[namespace current]::change_ValueEdit $textVar %d"
							set	cvUpdate 	[button $cvContentFrame.update_${index} -image $lib_gui::iconArray(confirm)]
							$cvUpdate configure -command \
								"[namespace current]::updateConfig $cv_Name $updateCommand $xpath $cvEntry"
							if {$index == {oneLine}} {
								set	cvClose [button $cvContentFrame.close -image $lib_gui::iconArray(iconClose) -command "[namespace current]::closeEdit $cv $cvEdit"]
								grid	$cvLabel $cvEntry $cvUpdate $cvClose -sticky news
							} else {	
								grid	$cvLabel $cvEntry $cvUpdate -sticky news
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
							bind $cvLabel	<ButtonPress-1> 	[list [namespace current]::dragStart 	%X %Y]
							bind $cvLabel	<B1-Motion> 		[list [namespace current]::drag 		%X %Y $cv $cvEdit]			
							bind $cvEntry	<Return> 			[list [namespace current]::updateConfig $cv_Name $updateCommand $xpath $cvEntry]			
				}
							
				proc create_ListEdit {type cv cv_Name cvEdit cvContentFrame index labelText textVar updateCommand xpath} {					

						#
						# --- create listBox content ---
						set listBoxContent {}
						case $type {
								{fileList} {
										eval set currentFile $[namespace current]::_updateValue($xpath)
										set listBoxContent {}
											# puts "createEdit::create_ListEdit::fileList:"
											# puts "     currentFile: $currentFile"
											# puts "           xpath: $xpath"										
										set listBoxContent [lib_file::get_componentAlternatives  $xpath]
										foreach entry $listBoxContent {
											puts "         ... $entry"
										}
										
									}
								{APPL_RimList} {
										eval set currentValue $[namespace current]::_updateValue($xpath)
										set listBoxContent {}
										puts "     currentValue: $currentValue"
										set listBoxContent $::APPL_RimList
										foreach entry $listBoxContent {
											puts "         ... $entry"
										}
									}
								{APPL_ForkTypes} {
										eval set currentValue $[namespace current]::_updateValue($xpath)
										set listBoxContent {}
										puts "     currentValue: $currentValue"
										set listBoxContent $::APPL_ForkTypes
										foreach entry $listBoxContent {
											puts "         ... $entry"
										}
									}	
								{APPL_BrakeTypes} {
										eval set currentValue $[namespace current]::_updateValue($xpath)
										set listBoxContent {}
										puts "     currentValue: $currentValue"
										set listBoxContent $::APPL_BrakeTypes
										foreach entry $listBoxContent {
											puts "         ... $entry"
										}
									}
								{APPL_Binary_OnOff} {
										eval set currentValue $[namespace current]::_updateValue($xpath)
										set listBoxContent {}
										puts "     currentValue: $currentValue"
										set listBoxContent $::APPL_Binary_OnOff
										foreach entry $listBoxContent {
											puts "         ... $entry"
										}
									}
								{APPL_BottleCage} {
										eval set currentValue $[namespace current]::_updateValue($xpath)
										set listBoxContent {}
										puts "     currentValue: $currentValue"
										set listBoxContent $::APPL_BottleCage
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
													-textvariable [namespace current]::_updateValue($xpath) \
													-values $listBoxContent	\
													-width 13 \
													-height 10 \
													-justify right ]
													
									set postCommand [list set [namespace current]::oldValue [namespace current]::_updateValue($xpath)]
									$cvCBox configure -postcommand [list eval set [namespace current]::oldValue \$[namespace current]::_updateValue($xpath)]

							if {$index == {oneLine}} {
								set	cvUpdat [button $cvContentFrame.update -image $lib_gui::iconArray(confirm)]
								$cvUpdat configure -command \
									"[namespace current]::updateConfig $cv_Name $updateCommand $xpath"
									# "[namespace current]::updateConfig $cv_Name $updateCommand $xpath $cvEntry"
								set	cvClose [ button 		$cvFrame.close   -image $lib_gui::iconArray(iconClose) -command "[namespace current]::closeEdit $cv $cvEdit"]
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
							bind $cvCBox 	<<ComboboxSelected>> 		[list [namespace current]::check_Value	%W $cv_Name $updateCommand $xpath]
							bind $cvLabel	<ButtonPress-1> 			[list [namespace current]::dragStart 	%X %Y]
							bind $cvLabel	<B1-Motion> 				[list [namespace current]::drag 		%X %Y $cv $cvEdit]			
				}
				
						
			set x_offset 20
			set domDoc $::APPL_Project	
			set cv 		[ $cv_Name getNodeAttr Canvas path]
			
			if { [catch { set cvEdit [frame $cv.f_edit -bd 2 -relief raised] } errorID ] } {
					closeEdit $cv $cv.f_edit
					set cvEdit [frame $cv.f_edit -bd 2 -relief raised]
			}
			# --- create Window ---
			$cv create window [expr $x + $x_offset] $y  -window $cvEdit  -anchor w -tags $cvEdit

			# --- create WindowFrames ---
			set cvTitleFrame	[frame $cvEdit.f_title -bg gray60  ]
				# set cvTitleFrame 		 [frame $cvEdit.f_title   -bd 1 -relief flat -bg gray60]
			set cvContentFrame 		 [frame $cvEdit.f_content -bd 1 -relief sunken]
					pack $cvTitleFrame $cvContentFrame -side top
					pack configure $cvTitleFrame 	  -fill x -padx 2 -pady 2
					pack configure $cvContentFrame 	  -fill both
					
			# --- cvContentFrame ---
			if {[llength $xpathList] == 1 } {
					pack forget $cvTitleFrame
					set updateMode 	value
					set xpath [lindex $xpathList 0]
					set index oneLine
					
					switch -glob $xpath {
							{file://*} {
									set updateMode fileList
									set xpath	[string range $xpath 7 end]
										# puts "   ... \$xpath $xpath"							
									set value	[ [ $domDoc selectNodes /root/$xpath  ]	asText ]
									set _updateValue($xpath) $value
										# puts "   -> \$_updateValue($xpath): $_updateValue($xpath)"
									set labelText		[ string trim [ string map {{/} { / }} $xpath] " " ]
										#
										# --- create widgets per xpath list element ---
									create_ListEdit fileList \
												$cv $cv_Name $cvEdit $cvContentFrame \
												$index $labelText [namespace current]::_updateValue($xpath) $updateCommand $xpath								
							}
							{list://*} {
										# puts "   ... \$xpath $xpath"
									set xpath		[string range $xpath 7 end]
									set xpathList	[split $xpath {@} ]
										# puts "   ... \$xpathList $xpathList"
									set xpath		[lindex $xpathList 0]										 
									set listName	[lindex $xpathList 1]										 
									set value	[ [ $domDoc selectNodes /root/$xpath  ]	asText ]
									set _updateValue($xpath) $value
										# puts "   -> \$_updateValue($xpath): $_updateValue($xpath)"
									set labelText		[ string trim [ string map {{/} { / }} $xpath] " " ]
										#
										# --- create widgets per xpath list element ---
									puts "  ... 	 $listName \
												$cv $cv_Name $cvEdit $cvContentFrame \
												$index $labelText [namespace current]::_updateValue($xpath) $updateCommand $xpath"
									create_ListEdit $listName \
												$cv $cv_Name $cvEdit $cvContentFrame \
												$index $labelText [namespace current]::_updateValue($xpath) $updateCommand $xpath								
							}
							default {
										# puts "   ... \$xpath $xpath"
									set value	[ [ $domDoc selectNodes /root/$xpath  ]	asText ]
									set _updateValue($xpath) $value
										# puts "   -> \$_updateValue($xpath): $_updateValue($xpath)"
									set labelText		[ string trim [ string map {{/} { / }} $xpath] " " ]
										#
										# --- create widgets per xpath list element ---
									create_ValueEdit $cv $cv_Name $cvEdit $cvContentFrame \
														$index $labelText [namespace current]::_updateValue($xpath) $updateCommand $xpath
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
					foreach xpath $xpathList {						
						set index [expr $index +1]
						
						switch -glob $xpath {
							{file://*} { 
										# puts "   ... \$xpath $xpath"
									set updateMode fileList
									set xpath	[string range $xpath 7 end]
										# puts "   ... \$xpath $xpath"									
									set value	[ [ $domDoc selectNodes /root/$xpath  ]	asText ]
									set _updateValue($xpath) $value
										# puts "   -> \$_updateValue($xpath): $_updateValue($xpath)"
									set labelText		[ string trim [ string map {{/} { / }} $xpath] " " ]
										#
										# --- create widgets per xpath list element ---
									create_ListEdit fileList \
												$cv $cv_Name $cvEdit $cvContentFrame \
												$index $labelText [namespace current]::_updateValue($xpath) $updateCommand $xpath
								}
							{list://*} {
										# puts "   ... \$xpath $xpath"
									set xpath		[string range $xpath 7 end]
									set xpathList	[split $xpath {@} ]
										# puts "   ... \$xpathList $xpathList"
									set xpath		[lindex $xpathList 0]										 
									set listName	[lindex $xpathList 1]										 
									set value	[ [ $domDoc selectNodes /root/$xpath  ]	asText ]
									set _updateValue($xpath) $value
										# puts "   -> \$_updateValue($xpath): $_updateValue($xpath)"
									set labelText		[ string trim [ string map {{/} { / }} $xpath] " " ]
										#
										# --- create widgets per xpath list element ---
									create_ListEdit $listName \
												$cv $cv_Name $cvEdit $cvContentFrame \
												$index $labelText [namespace current]::_updateValue($xpath) $updateCommand $xpath								
							}
							default {
										# puts "   ... \$xpath $xpath"
									set value	[ [ $domDoc selectNodes /root/$xpath  ]	asText ]
									set _updateValue($xpath) $value
										# puts "   -> \$_updateValue($xpath): $_updateValue($xpath)"
									set labelText		[ string trim [ string map {{/} { / }} $xpath] " " ]
										#
										# --- select entries content ---
									create_ValueEdit $cv $cv_Name $cvEdit $cvContentFrame \
														$index $labelText [namespace current]::_updateValue($xpath) $updateCommand $xpath
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



	proc check_Value { w cv_Name updateCommand xPath args} {
		
			variable _updateValue
			variable oldValue
			
			switch $xPath {
					{Component/Wheel/Rear/RimDiameter} -
					{Component/Wheel/Front/RimDiameter} {
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
									
								[namespace current]::updateConfig $cv_Name $updateCommand $xPath
							}
						}
					default {
								[namespace current]::updateConfig $cv_Name $updateCommand $xPath
						}
			}
	}



 	#-------------------------------------------------------------------------
		#  sets and format Value 
	proc set_projectValue {xpath value {mode {update}}} {
	
			variable 		_updateValue
			
				# --- get current Node
			set domProject 	$::APPL_Project			
			set node 		[$domProject selectNodes /root/$xpath/text()]
			
			
			# --- handle xpath values --- 
					# puts "  ... mode: $mode"
			if {$mode == {update}} {
					# puts "  ... set_projectValue: $xpath"
				switch -glob $xpath {
					{Temporary/*} {
								# puts "\n  ... set_projectValue: ... Result/..."
							set_spec_Parameters $xpath $value
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
			
				# --- puts message
			# puts "        ... set_projectValue: $xpath  $newValue "
			
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
				$node nodeValue $newValue
			}
			
			return $newValue
	
	}
	
	
 	#-------------------------------------------------------------------------
		#  handle modification on /root/Result/... values
	# proc set_spec_Parameters {domProject cv_Name updateCommand xpath cvEntry} 
	proc set_spec_Parameters {xpath value} {

			variable 		_updateValue
			
				variable HandleBar	
				variable Saddle
				variable SeatTube
				variable FrontWheel	
				variable Fork	
				variable Stem	
			
				# --- get current Node
			set domProject 	$::APPL_Project			
			set node 		[$domProject selectNodes /root/$xpath/text()]
			
			
			puts "\n  ... set_spec_Parameters: $xpath"
			switch -glob $xpath {
			
				{Temporary/HeadTube/Angle}	{			
							puts "               ... $xpath"
							
							set HeadTube(Angle)			[set_projectValue $xpath  $value format]
							set _updateValue($xpath) 	$HeadTube(Angle)
									# puts "          \$HeadTube(Angle)  = $HeadTube(Angle)"
								
								# --- get HandleBar(position)
								# 
								# puts "   ... \$FrontWheel(Position)  $FrontWheel(Position)"
							#set Fork(Height)			[ [ $domProject selectNodes /root/Component/Fork/Height		]  asText ]
							#set Fork(Rake)				[ [ $domProject selectNodes /root/Component/Fork/Rake		]  asText ]
							#set HandleBar(Height)		[ [ $domProject selectNodes /root/Personal/HandleBar_Height	]  asText ]
							#set Stem(Angle)				[ [ $domProject selectNodes /root/Component/Stem/Angle		]  asText ]
							#set Stem(Length)			[ [ $domProject selectNodes /root/Component/Stem/Length		]  asText ]
							
								set help_03	 [ vectormath::rotateLine 	$FrontWheel(Position) [expr $Fork(Height) + 300]	[ expr 180 - $HeadTube(Angle) ] ]
							set vect_HT		 [ vectormath::parallel   	$FrontWheel(Position)	$help_03	$Fork(Rake) left ]
								set help_04	 [ lindex $vect_HT 0]
								set help_05	 [ lindex $vect_HT 1]
							
								set st_perp	 [ expr $Stem(Length) * cos($Stem(Angle) * $vectormath::CONST_PI / 180) ]						
								set st_horz  [ expr $st_perp / cos((90 - $HeadTube(Angle)) * $vectormath::CONST_PI / 180) ]
								set vect_02	 [ vectormath::parallel  $help_04   $help_05	$st_perp ]
								set vect_03	 [ vectormath::parallel  {0 0}	{800 0}	$HandleBar(Height) left]
							set HandleBar(Position)	 [ vectormath::intersectPoint  [lindex $vect_02 0] [lindex $vect_02 1]  [lindex $vect_03 0] [lindex $vect_03 1] ]
								
								# --- update value 
								# 
							set xpath 		Personal/HandleBar_Distance					
							set newValue 	[lindex $HandleBar(Position) 0] 
									# puts "          $HandleBar(position)  -> $newValue"
							set_projectValue $xpath  $newValue
		
								# --- update value 
								# 
							set xpath 		Personal/HandleBar_Height					
							set newValue 	[lindex $HandleBar(Position) 1] 
							
									# puts "            old:  $HandleBar(Height)  "
									# puts "          $HandleBar(position)  -> $newValue"
							set_projectValue $xpath  $newValue
		
						}	
				
				{Temporary/HeadTube/TopTubeAngle} {
									# puts "               ... $xpath"
							
							set HeadTopTube_Angle	[ set_projectValue $xpath  $value format]
							set _updateValue($xpath) 	$HeadTopTube_Angle
								puts "          \$HeadTopTube_Angle  = $HeadTopTube_Angle"



								# --- update value 
								# 
							set HeadTube_Angle		[ [ $domProject selectNodes /root/Temporary/HeadTube/Angle		]  asText ]
							set value				[ expr $HeadTopTube_Angle - $HeadTube_Angle]
							set xpath		Custom/TopTube/Angle
							
							set_projectValue $xpath  $value	
							
						}
				
				{Temporary/WheelPosition/front/horizontal}	{			
							puts "               ... $xpath"
							set oldValue				[ [ $domProject selectNodes $xpath  ]	asText ]
							set newValue				[set_projectValue $xpath  $value format]
							set _updateValue($xpath) 	$newValue
							set delta		[expr $newValue - $oldValue]
									# puts "          $newValue - $oldValue = $delta"
								 
								# --- get FrontWheel(Distance)
								#
							# set FrontWheel(position) 	[ point_position FrontWheel {0 0}]
								# set FrontWheel(_y) 			[ lindex $FrontWheel(Position) 1] 
								# set FrontWheel(_Distance) 	[ expr hypot($newValue,$FrontWheel(y)) ] 
								# set FrontWheel(Distance_Y) 		[ lindex $FrontWheel(Position) 1] 
							set FrontWheel(Distance_Y_tmp) 	[ expr hypot($newValue,$FrontWheel(Distance_Y)) ] 
									# puts "          hypot($newValue,$FrontWheel(y)) = $FrontWheel(Distance)"
							
								# --- update value 
								# 
							set xpath 		Custom/WheelPosition/Front					
							set_projectValue $xpath  $FrontWheel(Distance_Y_tmp)

								# --- get HandleBar(Reach)
								# 
							set xpath 					Personal/HandleBar_Distance					
							set oldValue				[ [ $domProject selectNodes $xpath  ]	asText ]
							set HandleBar(Reach_tmp)		[expr $oldValue + $delta]
									# puts "          $oldValue + $delta = $HandleBar(Reach)"
								
								# --- update value
								# 
							set_projectValue $xpath  $HandleBar(Reach_tmp)
							
						}
						
				{Temporary/Saddle/Offset_BB/horizontal}	{			
							puts "               ... $xpath"
							set oldValue				[ [ $domProject selectNodes $xpath  ]	asText ]
							set Saddle(Distance_X_tmp)				[set_projectValue $xpath  $value format]
							set _updateValue($xpath) 	$Saddle(Distance_X_tmp)
							
							# set SeatTube(Length)		[ [ $domProject selectNodes /root/Personal/SeatTube_Length  ]	asText ]
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
							
						}
						
				default {
							puts "\n"
							puts "     WARNING!"
							puts "\n"
							puts "        ... set_spec_Parameters:  "
							puts "                 $xpath"
							puts "            ... is not registered!"
							puts "\n"
							return
						}
			}		
			
	}



	
 	#-------------------------------------------------------------------------
		#  update Project 
	proc updateConfig {cv_Name updateCommand xpath {cvEntry {}}} {

			variable _updateValue
			
			set domProject $::APPL_Project
			
			# --- habdele xpath values --- 
			switch -glob $xpath {
				{_update_} {}
				default {
						puts "  ... updateConfig -> $_updateValue($xpath)"
						set_projectValue $xpath $_updateValue($xpath)				
					}			
			}
					
			#
			# --- finaly update
			frame_geometry::set_base_Parameters $domProject
			update
			$updateCommand $cv_Name
			catch {focus $cvEntry}
			catch {$cvEntry selection range 0 end}

	} 
 
 }  

