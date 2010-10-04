# -----------------------------------------------------------------------------------
#
#: Functions : namespace      F R A M E _ G E O M E T R Y _ C U S T O M
#

 
 namespace eval frame_geometry_custom {
		package require tdom
		
			#-------------------------------------------------------------------------
				#  current Project Values
			variable BaseCenter		; array set BaseCenter		{}
			variable RearWheel		; array set RearWheel 		{}
			variable FrontWheel		; array set FrontWheel		{}
			variable BottomBracket	; array set BottomBracket	{}
			variable HandleBar		; array set HandleBar		{}
			variable LegClearance	; array set LegClearance	{}								
			
			variable Stem			; array set Stem			{}
			variable Fork			; array set Fork			{}
			variable HeadTube		; array set HeadTube		{}
			variable SeatTube		; array set SeatTube		{}
			variable DownTube		; array set DownTube		{}
			variable TopTube		; array set TopTube			{}
			variable ChainStay		; array set ChainStay		{}
			variable SeatStay		; array set SeatStay	 	{}
			
			variable Project		; array set Project	 		{}
					
				
			#-------------------------------------------------------------------------
				#  update loop and delay; store last value
			variable _update
					array set _update {}
					set _update(loops)   1 ;# loops until update target value
					set _update(delay)   5 ;# miliseconds
			variable _updateValue
					array set _updateValue {}
				
			#-------------------------------------------------------------------------
				#  store createEdit-widgets position
			variable _drag
			
			#-------------------------------------------------------------------------
				#  dataprovider of create_selectbox
			variable _listBoxValues
				
			#-------------------------------------------------------------------------
				#  store Coordinates of Points relative to BottomBracket
			namespace eval frameCoords {
					variable RearWheel
					variable FrontWheel
					variable HandleBar
					variable Saddle
					variable Steerer_Stem
					variable Steerer_Fork
					variable Size
					variable Derailleur
					
					variable ForkBlade		; array set ForkBlade		{}
					variable SeatPost		; array set SeatPost		{}
					variable HeadSet		; array set HeadSet			{}
					variable HeadTube		; array set HeadTube		{}
					variable SeatTube		; array set SeatTube		{}
					variable DownTube		; array set DownTube		{}
					variable TopTube		; array set TopTube			{}
					variable ChainStay		; array set ChainStay		{}
					variable SeatStay		; array set SeatStay	 	{} 
			}

	
 	#-------------------------------------------------------------------------
		#  base: fill current Project Values and namespace frameCoords::
	proc set_base_Parameters {domConfig} {
			variable Reference
			
			variable BottomBracket
			variable RearWheel
			variable FrontWheel
			variable HandleBar
			variable LegClearance
			
			variable Fork
			variable HeadTube
			variable SeatTube
			variable DownTube
			variable TopTube
			variable ChainStay
			variable SeatStay
			variable RearDrop
			variable Saddle
			variable HeadSet
			variable Stem
			variable RearBrake
			variable FrontBrake
			
			variable Project
			
	
				#
				# --- increase global update timestamp
			set ::APPL_Update			[ clock milliseconds ]
			
	
				#
				# --- set Project attributes
			set Project(Project)		[ [ $domConfig selectNodes /root/Project/Name 						]  asText ]
			set Project(modified)		[ [ $domConfig selectNodes /root/Project/modified 					]  asText ]
			
				#
				# --- set LegClearance
			set LegClearance(Length)	[ [ $domConfig selectNodes /root/Personal/InnerLeg_Length 			]  asText ]
			
				#
				# --- get BottomBracket (1)
			set BottomBracket(depth)	[ [ $domConfig selectNodes /root/Custom/BottomBracket/Depth  		]  asText ]

				#
				# --- get RearWheel
			set RearWheel(RimDiameter)	[ [ $domConfig selectNodes /root/Component/Wheel/Rear/RimDiameter	]  asText ]
			set RearWheel(TyreHeight)	[ [ $domConfig selectNodes /root/Component/Wheel/Rear/TyreHeight	]  asText ]
			set RearWheel(Radius)		[ expr 0.5*$RearWheel(RimDiameter) + $RearWheel(TyreHeight) ]
			set RearWheel(DistanceBB)	[ [ $domConfig selectNodes /root/Custom/WheelPosition/Rear			]  asText ]
			set RearWheel(Distance_X)	[ expr sqrt(pow($RearWheel(DistanceBB),2)  - pow($BottomBracket(depth),2)) ]
				# set RearWheel(Distance_X)	450
				
				#
				# --- get BottomBracket (2)
			set BottomBracket(height)	[ expr $RearWheel(Radius) - $BottomBracket(depth) ]
		
				#
				# --- get FrontWheel 
			set FrontWheel(RimDiameter)	[ [ $domConfig selectNodes /root/Component/Wheel/Front/RimDiameter	]  asText ]
			set FrontWheel(TyreHeight)	[ [ $domConfig selectNodes /root/Component/Wheel/Front/TyreHeight	]  asText ]
			set FrontWheel(Radius)		[ expr 0.5*$FrontWheel(RimDiameter) + $FrontWheel(TyreHeight) ]
			set FrontWheel(DistanceBB)	[ [ $domConfig selectNodes /root/Custom/WheelPosition/Front			]  asText ]
			set FrontWheel(Distance_X)	[ expr sqrt(pow($FrontWheel(DistanceBB),2) - pow(($FrontWheel(Radius) - $BottomBracket(height)),2)) ]

				#
				# --- get HandleBar - Position
			set HandleBar(Distance)		[ [ $domConfig selectNodes /root/Personal/HandleBar_Distance		]  asText ]
			set HandleBar(Height)		[ [ $domConfig selectNodes /root/Personal/HandleBar_Height			]  asText ]

				#
				# --- get LegClearance - Position
			set LegClearance(Length)	[ [ $domConfig selectNodes /root/Personal/InnerLeg_Length			]  asText ]
			
				#
				# --- get Fork -----------------------------
			set Fork(Height)				[ [ $domConfig selectNodes /root/Component/Fork/Height				]  asText ]
			set Fork(Rake)					[ [ $domConfig selectNodes /root/Component/Fork/Rake				]  asText ]
			set Fork(BladeWith)				[ [ $domConfig selectNodes /root/Component/Fork/Blade/Width			]  asText ]
			set Fork(BladeDiameterDO)		[ [ $domConfig selectNodes /root/Component/Fork/Blade/DiameterDO	]  asText ]
			set Fork(BladeTaperLength)		[ [ $domConfig selectNodes /root/Component/Fork/Blade/TaperLength	]  asText ]
			set Fork(BladeOffset)			[ [ $domConfig selectNodes /root/Component/Fork/Blade/Offset		]  asText ]
			set Fork(BladeOffsetCrown)		[ [ $domConfig selectNodes /root/Component/Fork/Crown/Blade/Offset		]  asText ]
			set Fork(BladeOffsetCrownPerp)	[ [ $domConfig selectNodes /root/Component/Fork/Crown/Blade/OffsetPerp	]  asText ]
			set Fork(BladeOffsetDO)			[ [ $domConfig selectNodes /root/Component/Fork/DropOut/Offset		]  asText ]
			set Fork(BladeOffsetDOPerp)		[ [ $domConfig selectNodes /root/Component/Fork/DropOut/OffsetPerp	]  asText ]
			set Fork(BrakeAngle)			[ [ $domConfig selectNodes /root/Component/Fork/Crown/Brake/Angle		]  asText ]
			set Fork(BrakeOffset)			[ [ $domConfig selectNodes /root/Component/Fork/Crown/Brake/Offset		]  asText ]
			set Fork(BrakeOffsetPerp)		[ [ $domConfig selectNodes /root/Component/Fork/Crown/Brake/OffsetPerp	]  asText ]
			
				#
				# --- get Stem -----------------------------
			set Stem(Angle)				[ [ $domConfig selectNodes /root/Component/Stem/Angle				]  asText ]
			set Stem(Length)			[ [ $domConfig selectNodes /root/Component/Stem/Length				]  asText ]

				#
				# --- get HeadTube -------------------------
			set HeadTube(ForkRake)		$Fork(Rake)
			set HeadTube(ForkHeight)	$Fork(Height)
			set HeadTube(Diameter)		[ [ $domConfig selectNodes /root/FrameTubes/HeadTube/Diameter		]  asText ]
			set HeadTube(Length)		[ [	$domConfig selectNodes /root/FrameTubes/HeadTube/Length			]  asText ]

				#
				# --- get SeatTube -------------------------
			set SeatTube(Angle)			[ [ $domConfig selectNodes /root/Personal/SeatTube_Angle  			]  asText ]
			set SeatTube(Length)		[ expr 0.88*$LegClearance(Length) ]
			set SeatTube(DiameterBB)	[ [ $domConfig selectNodes /root/FrameTubes/SeatTube/DiameterBB		]  asText ]
			set SeatTube(DiameterTT)	[ [ $domConfig selectNodes /root/FrameTubes/SeatTube/DiameterTT		]  asText ]
			set SeatTube(TaperLength)	[ [ $domConfig selectNodes /root/FrameTubes/SeatTube/TaperLength	]  asText ]
			set SeatTube(Extension)		[ [ $domConfig selectNodes /root/Custom/SeatTube/Extension			]  asText ]

				#
				# --- get DownTube -------------------------
			set DownTube(DiameterBB)	[ [ $domConfig selectNodes /root/FrameTubes/DownTube/DiameterBB		]  asText ]
			set DownTube(DiameterHT)	[ [ $domConfig selectNodes /root/FrameTubes/DownTube/DiameterHT		]  asText ]
			set DownTube(TaperLength)	[ [ $domConfig selectNodes /root/FrameTubes/DownTube/TaperLength	]  asText ]
			set DownTube(OffsetHT)		[ [ $domConfig selectNodes /root/Custom/DownTube/OffsetHT			]  asText ]
			set DownTube(OffsetBB)		[ [ $domConfig selectNodes /root/Custom/DownTube/OffsetBB			]  asText ]				

				#
				# --- get TopTube --------------------------
			set TopTube(DiameterHT)		[ [ $domConfig selectNodes /root/FrameTubes/TopTube/DiameterHT		]  asText ]
			set TopTube(DiameterST)		[ [ $domConfig selectNodes /root/FrameTubes/TopTube/DiameterST		]  asText ]
			set TopTube(TaperLength)	[ [ $domConfig selectNodes /root/FrameTubes/TopTube/TaperLength		]  asText ]
			set TopTube(PivotPosition)	[ [ $domConfig selectNodes /root/Custom/TopTube/PivotPosition		]  asText ]
			set TopTube(OffsetHT)		[ [ $domConfig selectNodes /root/Custom/TopTube/OffsetHT			]  asText ]
			set TopTube(Angle)			[ [ $domConfig selectNodes /root/Custom/TopTube/Angle				]  asText ]
				
				#
				# --- get ChainStay ------------------------
			set ChainStay(DiameterBB)	[ [ $domConfig selectNodes /root/FrameTubes/ChainStay/DiameterBB    ]  asText ]
			set ChainStay(DiameterSS)	[ [ $domConfig selectNodes /root/FrameTubes/ChainStay/DiameterSS    ]  asText ]
			set ChainStay(TaperLength)	[ [ $domConfig selectNodes /root/FrameTubes/ChainStay/TaperLength	]  asText ]
				
				#
				# --- get SeatStay -------------------------
			set SeatStay(DiameterST)	[ [ $domConfig selectNodes /root/FrameTubes/SeatStay/DiameterST		]  asText ]
			set SeatStay(DiameterCS)	[ [ $domConfig selectNodes /root/FrameTubes/SeatStay/DiameterCS		]  asText ]
			set SeatStay(TaperLength)	[ [ $domConfig selectNodes /root/FrameTubes/SeatStay/TaperLength	]  asText ]
			set SeatStay(OffsetTT)		[ [ $domConfig selectNodes /root/Custom/SeatStay/OffsetTT			]  asText ]

				#
				# --- get RearDropOut ----------------------
			set RearDrop(OffsetCS)		[ [ $domConfig selectNodes /root/Component/RearDropOut/ChainStay/Offset	]  asText ]
			set RearDrop(OffsetCSPerp)	[ [ $domConfig selectNodes /root/Component/RearDropOut/ChainStay/OffsetPerp ]  asText ]
			set RearDrop(OffsetSS)		[ [ $domConfig selectNodes /root/Component/RearDropOut/SeatStay/Offset		]  asText ]
			set RearDrop(OffsetSSPerp)	[ [ $domConfig selectNodes /root/Component/RearDropOut/SeatStay/OffsetPerp	]  asText ]
			set RearDrop(Derailleur_x)	[ [ $domConfig selectNodes /root/Component/RearDropOut/Derailleur/x	]  asText ]
			set RearDrop(Derailleur_y)	[ [ $domConfig selectNodes /root/Component/RearDropOut/Derailleur/y	]  asText ]

				#
				# --- get Saddle ---------------------------
			set Saddle(SeatPost_x)		[ [ $domConfig selectNodes /root/Component/Saddle/SeatPost/x		]  asText ]
			set Saddle(SeatPost_y)		[ [ $domConfig selectNodes /root/Component/Saddle/SeatPost/y		]  asText ]
			set Saddle(SeatPost_DM)		[ [ $domConfig selectNodes /root/Component/Saddle/SeatPost/Diameter	]  asText ]

				#
				# --- get HeadSet --------------------------
			set HeadSet(Diameter)		[ [ $domConfig selectNodes /root/Component/HeadSet/Diameter			]  asText ]
			set HeadSet(Height_Top) 	[ [	$domConfig selectNodes /root/Component/HeadSet/Height/Top		]  asText ]
			set HeadSet(Height_Bottom) 	[ [	$domConfig selectNodes /root/Component/HeadSet/Height/Bottom	]  asText ]
			set HeadSet(ShimDiameter)	36
				
				#
				# --- get Front/Rear Brake PadLever --------------
			set RearBrake(LeverLength)	[ [ $domConfig selectNodes /root/Component/Brake/Rear/LeverLength	]  asText ]
			set FrontBrake(LeverLength)	[ [ $domConfig selectNodes /root/Component/Brake/Front/LeverLength	]  asText ]
				
				#
				#
				# --- set basePoints Attributes
				#
			set frameCoords::RearWheel		[ list -$RearWheel(Distance_X)	$BottomBracket(depth) ]
			set frameCoords::FrontWheel		[ list $FrontWheel(Distance_X)	[expr $BottomBracket(depth) + ($FrontWheel(Radius) - $RearWheel(Radius))] ]
			set frameCoords::HandleBar 		[ list $HandleBar(Distance)  	$HandleBar(Height) ]
			set frameCoords::Saddle 		[ vectormath::rotateLine {0 0}  $SeatTube(Length)  [ expr 180 - $SeatTube(Angle) ] ]
			set frameCoords::Derailleur 	[ vectormath::addVector  $frameCoords::RearWheel  [list $RearDrop(Derailleur_x) $RearDrop(Derailleur_y)] ]
			set frameCoords::LegClearance	[ list $TopTube(PivotPosition) 	[expr $LegClearance(Length) - ($RearWheel(Radius) - $BottomBracket(depth)) ] ]
			set frameCoords::BB_Ground		[ list 0 	[expr - $RearWheel(Radius) + $BottomBracket(depth) ] ];# Point on the Ground perp. to BB
				
			
			
				#
				#
				# --- set basePoints Attributes
				#
			proc get_basePoints {} {
					variable HeadTube 
					variable Stem
					variable Fork
					variable RearWheel
					variable FrontWheel
					variable BottomBracket
					
						set vect_01	 [ expr $Stem(Length) * cos($Stem(Angle) * $vectormath::CONST_PI / 180) ]
						set vect_02	 [ expr $vect_01 - $Fork(Rake) ]
						set help_03	 [ vectormath::cathetusPoint  $frameCoords::HandleBar  $frameCoords::FrontWheel  $vect_02  close ]
					set vect_HT 	 [ vectormath::parallel  $help_03  $frameCoords::FrontWheel  $Fork(Rake) ]
						set help_04  [ lindex $vect_HT 0 ]
						set help_05  [ lindex $vect_HT 1 ]
						set help_07  [ vectormath::rotatePoint 	  $frameCoords::HandleBar  $help_04  $Stem(Angle)	]			
					set frameCoords::Steerer_Stem	[ vectormath::intersectPoint $frameCoords::HandleBar $help_07 $help_04 $help_05 ]
					set frameCoords::Steerer_Fork 	[ vectormath::addVector $help_05 [ vectormath::unifyVector  $help_04  $help_05   -$Fork(Height) ] ]	
						set help_08  [ vectormath::addVector $frameCoords::BB_Ground {200 0}] 
					set frameCoords::Steerer_Ground		[ vectormath::intersectPoint $frameCoords::Steerer_Stem $frameCoords::Steerer_Fork  $frameCoords::BB_Ground  $help_08 ] 
					set frameCoords::SeatTube_Ground	[ vectormath::intersectPoint $frameCoords::Saddle {0 0}  $frameCoords::BB_Ground  $help_08 ] 
						#
						# --- set summary Length of Frame, Saddle and Stem
						set summaryLength [ expr $RearWheel(Distance_X) + $FrontWheel(Distance_X)]
						set summaryHeight [ expr $BottomBracket(depth) + 40 + [lindex $frameCoords::Saddle 1] ]
					set frameCoords::FrameSize 	[ list $summaryLength $summaryHeight ]
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
					
							set vct_00		[ vectormath::parallel  		$frameCoords::RearWheel      {0 0}   $RearDrop(OffsetCSPerp) left]
							set pt_00		[ lindex $vct_00 0 ]			
					set frameCoords::ChainStay(direction)			[ vectormath::unifyVector {0 0} $pt_00 ]
							set pt_00		[ vectormath::addVector 		$pt_00  $frameCoords::ChainStay(direction)  -$RearDrop(OffsetCS) ]
							set pt_01		[ vectormath::addVector 		$pt_00  $frameCoords::ChainStay(direction)  -$ChainStay(TaperLength) ]
					set frameCoords::ChainStay(RearWheel)			$pt_00
					set frameCoords::ChainStay(BottomBracket)		{0 0}
							set vct_01 		[ vectormath::parallel 			$pt_00 $pt_01 [expr 0.5*$ChainStay(DiameterSS)] ]
							set vct_02 		[ vectormath::parallel 			$pt_01 $frameCoords::ChainStay(BottomBracket) [expr 0.5*$ChainStay(DiameterBB)] ]
							set vct_03 		[ vectormath::parallel 			$pt_01 $frameCoords::ChainStay(BottomBracket) [expr 0.5*$ChainStay(DiameterBB)] left]
							set vct_04 		[ vectormath::parallel 			$pt_00 $pt_01 [expr 0.5*$ChainStay(DiameterSS)] left]
					set frameCoords::ChainStay(polygon) 		[format "%s %s %s %s %s %s" \
																		[lindex $vct_01 0] [lindex $vct_02 0] [lindex $vct_02 1] \
																		[lindex $vct_03 1] [lindex $vct_03 0] [lindex $vct_04 0] ]
			}
			get_ChainStay
			
				#
				# --- set HeadTube -------------------------
			proc get_HeadTube {} {
					variable HeadTube 
					variable HeadSet
					
					set frameCoords::HeadTube(direction) 		[ vectormath::unifyVector 	$frameCoords::Steerer_Fork		$frameCoords::Steerer_Stem ]
					set frameCoords::HeadTube(Fork)				[ vectormath::addVector 	$frameCoords::Steerer_Fork		$frameCoords::HeadTube(direction)	$HeadSet(Height_Bottom) ]
					set frameCoords::HeadTube(Stem)				[ vectormath::addVector 	$frameCoords::HeadTube(Fork)	$frameCoords::HeadTube(direction)	$HeadTube(Length) ]
							set vct_01 		[ vectormath::parallel 			$frameCoords::HeadTube(Fork) $frameCoords::HeadTube(Stem) [expr 0.5*$HeadTube(Diameter)] ]
							set vct_ht 		[ vectormath::parallel 			$frameCoords::HeadTube(Stem) $frameCoords::HeadTube(Fork) [expr 0.5*$HeadTube(Diameter)] ]
					set frameCoords::HeadTube(polygon) 			[format "%s %s %s %s" \
																		[lindex $vct_01 0] [lindex $vct_01 1] \
																		[lindex $vct_ht 0] [lindex $vct_ht 1] ]
			}
			get_HeadTube
																
				#
				# --- set DownTube ------------------------
			proc get_DownTube {} {
					variable HeadTube 
					variable DownTube 
			
							set vct_ht 		[ vectormath::parallel 			$frameCoords::HeadTube(Stem) $frameCoords::HeadTube(Fork) [expr 0.5*$HeadTube(Diameter)] ]
							set pt_00		[ list [lindex $frameCoords::HeadTube(polygon) 6] [lindex $frameCoords::HeadTube(polygon) 7]]
							set pt_01		[ vectormath::addVector 		$pt_00 $frameCoords::HeadTube(direction) $DownTube(OffsetHT) ]	;# bottom intersection DownTube/HeadTube
							set pt_02		[ vectormath::cathetusPoint 	{0 0} $pt_01 [expr 0.5 * $DownTube(DiameterHT) - $DownTube(OffsetBB) ]]
							set vct_01      [ vectormath::parallel 			$pt_02 $pt_01 [expr 0.5 * $DownTube(DiameterHT)] left]	;# DownTube centerline Vector
							set vct_02      [ vectormath::parallel 			$pt_02 $pt_01 $DownTube(DiameterHT) left]				;# DownTube upper Vector
					set frameCoords::DownTube(direction)		[ vectormath::unifyVector [lindex $vct_01 0] [lindex $vct_01 1] ]
							set pt_04       [ vectormath::intersectPoint 	[lindex $vct_02 0] [lindex $vct_02 1] \
																			[lindex $vct_ht 0] [lindex $vct_ht 1] ] ;# top intersection DownTube/HeadTube
					set frameCoords::DownTube(BottomBracket)	[ vectormath::intersectPoint [lindex $vct_01 0] [lindex $vct_01 1]  {0 0}	$frameCoords::Saddle ]
					set frameCoords::DownTube(HeadTube)			[ vectormath::intersectPoint [lindex $vct_01 0] [lindex $vct_01 1]  $frameCoords::Steerer_Fork	 $frameCoords::Steerer_Stem ]			
							set length		[ vectormath::length	  		[lindex $vct_02 0] $pt_04 ]
							set pt_10		[ lindex $vct_01 0]
							set pt_11		[ vectormath::addVector			$pt_10 $frameCoords::DownTube(direction) [expr 0.5*($length - $DownTube(TaperLength) )] ]
							set pt_12		[ vectormath::addVector 		$pt_11 $frameCoords::DownTube(direction) $DownTube(TaperLength) ]
							set pt_13		[ lindex $vct_01 1]
							set vct_10		[ vectormath::parallel  		$pt_10 $pt_11 [expr 0.5*$DownTube(DiameterBB)] right ]
							set vct_11		[ vectormath::parallel  		$pt_10 $pt_11 [expr 0.5*$DownTube(DiameterBB)] left  ]
							set vct_21		[ vectormath::parallel  		$pt_12 $pt_13 [expr 0.5*$DownTube(DiameterHT)] right ]
							set vct_22		[ vectormath::parallel  		$pt_12 $pt_13 [expr 0.5*$DownTube(DiameterHT)] left  ]
							
							set dir 		[ vectormath::addVector {0 0} $frameCoords::DownTube(direction) -1] 
							set is_dt_ht	[ tube_intersection	$DownTube(DiameterHT) $dir  $HeadTube(Diameter)  $frameCoords::HeadTube(direction)  $frameCoords::DownTube(HeadTube) ]				

							set polygon		[ list            [lindex $vct_10 0] [lindex $vct_10 1] [lindex $vct_21 0]]
							set polygon		[ lappend polygon [canvasCAD::flatten_nestedList $is_dt_ht]]
							set polygon		[ lappend polygon [lindex $vct_22 0] [lindex $vct_11 1] [lindex $vct_11 0]]
					set frameCoords::DownTube(polygon)  		[canvasCAD::flatten_nestedList $polygon]						
			}
			get_DownTube
			
				#
				# --- set TopTube -------------------------
			proc get_TopTube_SeatTube {} {
					variable TopTube 
					variable HeadTube 
					variable SeatTube 
					variable DownTube 

							set vct_st		[ vectormath::parallel 			{0 0} $frameCoords::Saddle [expr 0.5*$SeatTube(DiameterTT)] ]			
					set frameCoords::SeatTube(direction)		[ vectormath::unifyVector {0 0} $frameCoords::Saddle ]
							set vct_ht 		[ vectormath::parallel 			$frameCoords::HeadTube(Stem) $frameCoords::HeadTube(Fork) [expr 0.5*$HeadTube(Diameter)] ]
							set pt_00		[lindex $vct_ht 0]
							set pt_01		[ vectormath::addVector 		$pt_00 $frameCoords::HeadTube(direction) -$TopTube(OffsetHT) ]	;# top intersection TopTube/HeadTube
					set frameCoords::TopTube(direction)			[ vectormath::rotatePoint {0 0} {-1 0} $TopTube(Angle) ]	;# direction vector of TopTube
							set pt_02		[ vectormath::intersectPoint 	$pt_01 [vectormath::addVector $pt_01  $frameCoords::TopTube(direction)]  {0 0} $frameCoords::Saddle ]	;# top intersection TopTube/HeadTube
							set vct_00      [ vectormath::parallel 			$pt_01 $pt_02 [expr 0.5 * $TopTube(DiameterHT)] left]	;# TopTube centerline Vector
							set pt_10       [ vectormath::intersectPoint 	[lindex $vct_00 0] [lindex $vct_00 1]  $frameCoords::Steerer_Fork $frameCoords::Steerer_Stem  ]
							set length		[ vectormath::length	     	$pt_10 [lindex $vct_00 1] ]
							set pt_11       [ vectormath::addVector  		$pt_10  $frameCoords::TopTube(direction)  [expr 0.5*($length - $TopTube(TaperLength)) ] ]
							set pt_12       [ vectormath::addVector  		$pt_11  $frameCoords::TopTube(direction)  $TopTube(TaperLength) ]
							set pt_13       [ vectormath::intersectPoint 	[lindex $vct_00 0] [lindex $vct_00 1]  {0 0} $frameCoords::Saddle ]
							set vct_10		[ vectormath::parallel  		$pt_10 $pt_11 [expr 0.5*$TopTube(DiameterHT)] right ]
							set vct_11		[ vectormath::parallel  		$pt_10 $pt_11 [expr 0.5*$TopTube(DiameterHT)] left  ]
							set vct_21		[ vectormath::parallel  		$pt_12 $pt_13 [expr 0.5*$TopTube(DiameterST)] right ]
							set vct_22		[ vectormath::parallel  		$pt_12 $pt_13 [expr 0.5*$TopTube(DiameterST)] left  ]
							set pt_04       [ vectormath::intersectPoint 	[lindex $vct_ht 0] [lindex $vct_ht 1]  [lindex $vct_11 0] [lindex $vct_11 1] ]
							set pt_st       [ vectormath::intersectPoint 	[lindex $vct_st 0] [lindex $vct_st 1]  [lindex $vct_21 0] [lindex $vct_21 1] ]
							set pt_22       [ vectormath::intersectPoint 	[lindex $vct_st 0] [lindex $vct_st 1]  [lindex $vct_22 0] [lindex $vct_22 1] ]		
					set frameCoords::TopTube(HeadTube)			$pt_10
					set frameCoords::TopTube(SeatTube)			[ vectormath::intersectPoint [lindex $vct_00 0] [lindex $vct_00 1] {0 0} $frameCoords::Saddle ]
					
							set is_tt_ht	[ tube_intersection	$TopTube(DiameterHT) $frameCoords::TopTube(direction)  $HeadTube(Diameter)	  $frameCoords::HeadTube(direction)  $frameCoords::TopTube(HeadTube) right]	
							set is_tt_st	[ tube_intersection	$TopTube(DiameterST) $frameCoords::TopTube(direction)  $SeatTube(DiameterTT)  $frameCoords::SeatTube(direction)  $frameCoords::TopTube(SeatTube) left ]				

							set polygon		[ canvasCAD::flatten_nestedList $is_tt_ht]
							set polygon		[ lappend polygon [lindex $vct_10 1] [lindex $vct_21 0]]
							set polygon		[ lappend polygon [canvasCAD::flatten_nestedList $is_tt_st]]
							set polygon		[ lappend polygon [lindex $vct_22 0] [lindex $vct_11 1]]							
					set frameCoords::TopTube(polygon) 			[canvasCAD::flatten_nestedList $polygon]

							set pt_00		[ vectormath::intersectPerp 	{0 0} $frameCoords::Saddle   $pt_st ] 
							set pt_01		[ vectormath::addVector			$pt_00   $frameCoords::SeatTube(direction)  $SeatTube(Extension) ]
							set length		[ vectormath::length	    	{0 0} $pt_01 ]
							set pt_10 		{0 0}
							set pt_11 		[ vectormath::addVector			$pt_10  $frameCoords::SeatTube(direction)  [expr 0.5*($length - $SeatTube(TaperLength)) ] ]
							set pt_12 		[ vectormath::addVector			$pt_11  $frameCoords::SeatTube(direction)  $SeatTube(TaperLength) ]
							set pt_13 		$pt_01
							set vct_10		[ vectormath::parallel  		$pt_10 $pt_11 [expr 0.5*$SeatTube(DiameterBB)] right ]
							set vct_11		[ vectormath::parallel  		$pt_10 $pt_11 [expr 0.5*$SeatTube(DiameterBB)] left  ]
							set vct_21		[ vectormath::parallel  		$pt_12 $pt_13 [expr 0.5*$SeatTube(DiameterTT)] right ]
							set vct_22		[ vectormath::parallel  		$pt_12 $pt_13 [expr 0.5*$SeatTube(DiameterTT)] left  ]				
					set frameCoords::SeatTube(TopTube)			$pt_01					
					set frameCoords::SeatTube(BottomBracket)	{0 0}	
					set frameCoords::SeatTube(polygon) 			[format "%s %s %s %s %s %s %s %s" \
																		[lindex $vct_10 0]  [lindex $vct_10 1] \
																		[lindex $vct_21 0]  [lindex $vct_21 1] \
																		[lindex $vct_22 1]  [lindex $vct_22 0] \
																		[lindex $vct_11 1]  [lindex $vct_11 0] ]
			}
			get_TopTube_SeatTube
			
				#
				# --- set SeatStay ------------------------
			proc get_SeatStay {} {
					variable SeatStay 
					variable SeatTube 
					variable RearDrop 

					set pt_00		[ vectormath::addVector		$frameCoords::TopTube(SeatTube)  $frameCoords::SeatTube(direction)  $SeatStay(OffsetTT) ] ; # intersection seatstay / seattube
							set pt_01		[ lindex [ vectormath::parallel  	$frameCoords::RearWheel  $pt_00   $RearDrop(OffsetSSPerp) ] 0 ]
					set frameCoords::SeatStay(direction)     [ vectormath::unifyVector $pt_01 $pt_00 ]
							set pt_10		[ vectormath::addVector		$pt_01  $frameCoords::SeatStay(direction)  $RearDrop(OffsetSS) ]
							set pt_11		[ vectormath::addVector		$pt_10  $frameCoords::SeatStay(direction)  $SeatStay(TaperLength) ]
							set pt_12		$pt_00
							set vct_10 		[ vectormath::parallel $pt_10 $pt_11 [expr 0.5*$SeatStay(DiameterCS)] ]
							set vct_11 		[ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$SeatStay(DiameterST)] ]
							set vct_12 		[ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$SeatStay(DiameterST)] left]
							set vct_13 		[ vectormath::parallel $pt_10 $pt_11 [expr 0.5*$SeatStay(DiameterCS)] left]
					set frameCoords::SeatStay(SeatTube)			$pt_00		
					set frameCoords::SeatStay(RearWheel)		$pt_10
							set dir 		[ vectormath::addVector {0 0} $frameCoords::SeatStay(direction) -1] 
							set offset		[ expr 0.5 * ($SeatTube(DiameterTT) - $SeatStay(DiameterST)) ]
							set is_ss_st	[ tube_intersection	$SeatStay(DiameterST) $dir  $SeatTube(DiameterTT)	  $frameCoords::SeatTube(direction)  $frameCoords::SeatStay(SeatTube)  right $offset]	
					set frameCoords::SeatStay(debug) 			$is_ss_st
							set polygon		[ canvasCAD::flatten_nestedList  $is_ss_st ]
							set polygon		[ lappend polygon 	[lindex $vct_12 0] [lindex $vct_13 0] \
																[lindex $vct_10 0] [lindex $vct_11 0] ]					
					set frameCoords::SeatStay(polygon) 			[canvasCAD::flatten_nestedList $polygon]
						#
						# --- set SeatStay / ChainStay - Intersection
					set frameCoords::ChainSt_SeatSt_IS		[ vectormath::intersectPoint $frameCoords::SeatStay(SeatTube) $frameCoords::SeatStay(RearWheel) $frameCoords::ChainStay(BottomBracket) $frameCoords::ChainStay(RearWheel) ];# intersection of ChainStay and SeatStay centerlines	
			}
			get_SeatStay
						
				#
				# --- set ForkBlade -----------------------
			proc get_Fork {} {
					variable Fork
					
							set pt_00		$frameCoords::Steerer_Fork
							set pt_99		$frameCoords::FrontWheel
							set pt_01		[ vectormath::addVector $pt_00 $frameCoords::HeadTube(direction) -$Fork(BladeOffsetCrown) ]
							set pt_02		[ lindex [ vectormath::parallel  $pt_00  $pt_01  $Fork(BladeOffsetCrownPerp) left ] 1] ;# centerpoint of Blade in ForkCrown
								set hlp_00		{0 0}													;# point where Taper begins
								set hlp_01		[ list $Fork(BladeTaperLength)	$Fork(BladeOffset) ]	;# point where Taper ends
								set vct_taper	[ vectormath::unifyVector 	$hlp_00 $hlp_01 ]	;# direction caused by taper offset
								set hlp_02		[ vectormath::addVector 	$hlp_01 [vectormath::scalePointList {0 0} $vct_taper $Fork(BladeOffsetDO) ] ]
								set vct_dropout	[ vectormath::parallel 		$hlp_00 	$hlp_02 	$Fork(BladeOffsetDOPerp) left]
								set hlp_03		[ lindex $vct_dropout 1 ]								;# location of Dropout in reference to point where Taper begins
							set offsetDO		[ expr [ lindex $hlp_03 0] - $Fork(BladeTaperLength) ]
							set offsetDO_Perp	[ lindex $hlp_03 1]
							set pt_03			[ vectormath::cathetusPoint	$pt_02  $pt_99  $offsetDO_Perp  opposite ]	;# point on direction of untapered area of ForkBlade perp through FrontWheel

					set frameCoords::ForkBlade(direction)	[ vectormath::unifyVector $pt_02 $pt_03 ]
							set pt_04			[ vectormath::addVector		$pt_03  [vectormath::scalePointList {0 0} $frameCoords::ForkBlade(direction) -$offsetDO ] ]	;# point on direction of untapered area of ForkBlade perp through Blade Tip
							set vct_offset		[ vectormath::parallel		$pt_02  $pt_04  $Fork(BladeOffset) left]	;
							set pt_10		$pt_99						;# Dropout
							set pt_11		[ lindex $vct_offset 1 ]	;# Fork Blade Tip
							set pt_12		[ vectormath::addVector		$pt_04	[vectormath::scalePointList {0 0} $frameCoords::ForkBlade(direction) -$Fork(BladeTaperLength) ] ] ;# point on direction of untapered area where tapering starts
																		;# Fork Blade taper start
							set pt_13		$pt_02						;# Crown Fork Blade center
						
							set vct_10 		[ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$Fork(BladeDiameterDO)] ]
							set vct_11 		[ vectormath::parallel $pt_12 $pt_13 [expr 0.5*$Fork(BladeWith)] ]
							set vct_12 		[ vectormath::parallel $pt_12 $pt_13 [expr 0.5*$Fork(BladeWith)] left]
							set vct_13 		[ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$Fork(BladeDiameterDO)] left ]
					set frameCoords::ForkBlade(polygon) 		[format "%s %s %s %s %s %s" \
																		[lindex $vct_10 0]  [lindex $vct_11 0] [lindex $vct_11 1]  \
																		[lindex $vct_12 1]  [lindex $vct_12 0] [lindex $vct_13 0] ]
							
					set frameCoords::ForkBlade(debug) 			[format "%s %s %s %s %s %s %s %s %s %s %s %s " \
																		[lindex $pt_00 0]  [lindex $pt_00 1] \
																		[lindex $pt_01 0]  [lindex $pt_01 1] \
																		[lindex $pt_13 0]  [lindex $pt_13 1] \
																		[lindex $pt_12 0]  [lindex $pt_12 1] \
																		[lindex $pt_11 0]  [lindex $pt_11 1] \
																		[lindex $pt_99 0]  [lindex $pt_99 1] \
																		]
																		
						#
						# --- set Fork Dropout --------------------
					set frameCoords::ForkDropout(direction)	[ vectormath::unifyVector $pt_12 $pt_11 ]
			}
			get_Fork

				#
				# --- set Steerer -------------------------
			proc get_Steerer {} {
					variable HeadTube

					set frameCoords::Steerer(Stem)				[ vectormath::addVector 	$frameCoords::HeadTube(Fork)	$frameCoords::HeadTube(direction)	[expr $HeadTube(Length) + 40] ]
							set vct_01 		[ vectormath::parallel 			$frameCoords::Steerer_Fork  $frameCoords::Steerer(Stem) [expr 0.5 * ($HeadTube(Diameter)-7)] ]
							set vct_ht 		[ vectormath::parallel 			$frameCoords::Steerer(Stem) $frameCoords::Steerer_Fork  [expr 0.5 * ($HeadTube(Diameter)-7)] ]
					set frameCoords::Steerer(polygon) 			[format "%s %s %s %s" \
																		[lindex $vct_01 0] [lindex $vct_01 1] \
																		[lindex $vct_ht 0] [lindex $vct_ht 1] ]
			}
			get_Steerer
			
				#					
				# --- set SeatPost ------------------------
			proc get_SeatPost {} {
					variable Saddle
					
							set pt_00		$frameCoords::Saddle
							set pt_99		{0 0}
								# puts "   \n   vectormath::addVector $pt_00 [list $Saddle(SeatPost_x) $Saddle(SeatPost_y)] \n" 
								# puts "             $pt_00"
								# puts "				[list $Saddle(SeatPost_x) $Saddle(SeatPost_y)]" 
							set pt_01		[ vectormath::addVector $pt_00 [list $Saddle(SeatPost_x) $Saddle(SeatPost_y)] ]
							set vct_01		[ vectormath::parallel  $pt_01 [ vectormath::addVector $pt_01 {100 0}] 35 ]
							set vct_05		[ vectormath::parallel  $pt_01 [ vectormath::addVector $pt_01 {100 0}] 20 ]
							set vct_06		[ vectormath::parallel  $pt_01 [ vectormath::addVector $pt_01 {100 0}] 30 ]
							set pt_02		[ vectormath::intersectPoint [lindex $vct_01 0] [lindex $vct_01 1]  {0 0} $frameCoords::Saddle ]
							
					set frameCoords::SeatPost(direction)	$frameCoords::SeatTube(direction)
							set pt_10		$pt_01
							set pt_11		$pt_02
							set pt_12		$frameCoords::TopTube(SeatTube)
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
							#set polygon		[ lappend polygon [lindex $vct_10 0]  [lindex $vct_11 0]]
					set frameCoords::SeatPost(polygon) 			[canvasCAD::flatten_nestedList $polygon]							
					set frameCoords::SeatPost(debug) 			[format "%s %s %s %s %s %s %s %s " \
																		[lindex $pt_00 0]  [lindex $pt_00 1] \
																		[lindex $pt_01 0]  [lindex $pt_01 1] \
																		[lindex $pt_02 0]  [lindex $pt_02 1] \
																		[lindex $pt_99 0]  [lindex $pt_99 1] \
																		]
			}
			get_SeatPost

				#
				# --- set HeadSet -------------------------
			proc get_HeadSet {} {
					variable HeadTube
					variable HeadSet
					
							set pt_10		$frameCoords::HeadTube(Fork)
							set pt_12		$frameCoords::Steerer_Fork
							set pt_11		[ vectormath::addVector $pt_12 $frameCoords::HeadTube(direction) [expr 0.5 * $HeadSet(Height_Bottom)]]
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
					set frameCoords::HeadSet(polygon_bt) 		[canvasCAD::flatten_nestedList $polygon]							
					set frameCoords::HeadSet(debug_bt) 			[format "%s %s %s %s %s %s" \
																		[lindex $pt_10 0]  [lindex $pt_10 1] \
																		[lindex $pt_11 0]  [lindex $pt_11 1] \
																		[lindex $pt_12 0]  [lindex $pt_12 1] \
																		]

							if {$HeadSet(Height_Top) < 2} {	set HeadSet(Height_Top) 2}
							if {$HeadSet(Height_Top) > 8} {	
									set majorDM 	$HeadSet(Diameter)
									set height_00	[expr 0.5 * $HeadSet(Height_Top)]
							} else {
									set majorDM 	$HeadTube(Diameter)
									set height_00	1
							}
							set pt_12		$frameCoords::HeadTube(Stem)
							set pt_11		[ vectormath::addVector $pt_12 $frameCoords::HeadTube(direction) $height_00]
							set pt_10		[ vectormath::addVector $pt_11 $frameCoords::HeadTube(direction) [expr $HeadSet(Height_Top) - $height_00]]
								# puts "\n\n"
								# puts "   pt_10:  $pt_10"
								# puts "   pt_11:  $pt_11"
								# puts "   pt_12:  $pt_12"
								# puts "\n\n"
					set frameCoords::HeadSet(Stem) 				$pt_10
							set vct_10		[ vectormath::parallel  $pt_10 $pt_11 [expr 0.5 * $HeadSet(ShimDiameter)] ]
							set vct_11		[ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * $majorDM ] ]
							set vct_12		[ vectormath::parallel  $pt_11 $pt_12 [expr 0.5 * $majorDM ] left]
							set vct_13		[ vectormath::parallel  $pt_10 $pt_11 [expr 0.5 * $HeadSet(ShimDiameter)] left]			
							set polygon		[list 	[lindex $vct_10 0]  [lindex $vct_11 0] \
													[lindex $vct_12 0]  [lindex $vct_11 0] \
													[lindex $vct_11 1] \
													[lindex $vct_12 1]  [lindex $vct_12 0] [lindex $vct_13 0] ]
					set frameCoords::HeadSet(polygon_tp) 			[canvasCAD::flatten_nestedList $polygon]							
			}			
			get_HeadSet
			
				#
				# --- set Stem ----------------------------
			proc get_Stem {} {
					variable HeadTube
					variable HandleBar
					variable HeadSet
					
							set pt_00		$frameCoords::HandleBar
							set pt_01		$frameCoords::Steerer_Stem
							set pt_02		$frameCoords::HeadSet(Stem)
					set frameCoords::Stem(debug) 			[format "%s %s %s %s %s %s" \
																		[lindex $pt_00 0]  [lindex $pt_00 1] \
																		[lindex $pt_01 0]  [lindex $pt_01 1] \
																		[lindex $pt_02 0]  [lindex $pt_02 1] \
																		]
					set frameCoords::Stem(direction) 			[ vectormath::unifyVector $pt_01 $pt_00 ]
							set angle							[ vectormath::angle {1 0}	{0 0}	$frameCoords::Stem(direction) ]
							set clamp_SVGPolygon 	"-18.8336,-17.9999 -15.7635,-18.3921 -13.3549,-19.887 -11.1307,-22.1168 -10.0644,-24.1389 -9.7316,-24.4732 -9.8958,-23.3099 -10.3089,-21.9026 -11.1479,-19.9125 -12.0719,-17.777 -15.3406,-11.3784 -16.1873,-10.0012 -17.4384,-9.0427 -18.8336,-8.3572 -17.4384,-9.0427 -16.1873,-10.0012 -15.3406,-11.3784 -12.0719,-17.777 -11.1479,-19.9125 -10.3089,-21.9026 -9.8958,-23.3099 -9.7316,-24.4732 -9.4316,-24.7774 -8.6838,-24.9999 -0.8,-24.9999 -0.8,-15.8802 0.8,-15.8802 0.8,-24.9998 5.6669,-24.9998 6.3699,-24.8858 6.9818,-24.5172 7.4284,-24.07 13.0499,-18.7437 13.049,-23.6727 12.6125,-24.0796 12.5936,-20.4963 12.6125,-24.0796 7.4284,-24.07 13.2207,-18.5818 15.8552,-15.7422 17.8482,-13.2995 19.8206,-9.913 20.8437,-7.292 21.5329,-4.4455 21.8005,-2.0944 21.9,0.0001 21.8005,2.0946 21.5329,4.4457 20.8437,7.2922 19.8206,9.9132 17.8482,13.2997 15.8552,15.7424 13.2207,18.582 7.4284,24.0702 12.6125,24.0798 12.5936,20.4965 12.6125,24.0798 13.049,23.6729 13.0499,18.7439 7.4284,24.0702 6.9818,24.5174 6.3699,24.886 5.6669,25 0.8,25 0.8,15.8804 4.18,15.3448 7.4163,14.0676 10.1772,12.2159 12.523,9.7973 14.299,6.9605 15.506,3.5323 15.9,0.0001 15.506,-3.5321 14.299,-6.9603 12.523,-9.7971 10.1772,-12.2157 7.4163,-14.0674 4.18,-15.3446 0.8,-15.8802 -0.8,-15.8802 -3.4694,-15.544 -6.2265,-14.634 -9.2433,-12.9378 -11.6453,-10.8246 -13.5388,-8.3403 -14.8801,-5.6139 -15.6719,-2.6977 -15.9,0.0001 -15.6719,2.6979 -14.8801,5.6141 -13.5388,8.3405 -11.6453,10.8248 -9.2433,12.938 -6.2265,14.6342 -3.4694,15.5442 -0.8,15.8804 0.8,15.8804 -0.8,15.8804 -0.8,25.0001 -8.6838,25.0001 -9.3776,24.6754 -9.7467,23.9553 -9.8958,23.3101 -10.3089,21.9028 -11.1479,19.9127 -12.0719,17.7772 -15.3406,11.3786 -16.1873,10.0014 -17.4384,9.0429 -18.8336,8.3574 -17.4384,9.0429 -16.1873,10.0014 -15.3406,11.3786 -12.0719,17.7772 -11.1479,19.9127 -10.3089,21.9028 -9.8958,23.3101 -9.7467,23.9553 -11.1307,22.117 -13.3549,19.8872 -15.7635,18.3923 -18.8336,18.0001 "
							set clamp_SVGPolygon 	"-20.2619,-17 -16.6918,-17.4561 -13.8908,-19.1945 -11.3044,-21.7874 -10.0644,-24.1389 -9.7316,-24.4732 -9.8958,-23.3099 -10.3089,-21.9026 -11.1479,-19.9125 -12.0719,-17.777 -15.3406,-11.3784 -16.1873,-10.0012 -17.4384,-9.0427 -18.8336,-8.3572 -17.4384,-9.0427 -16.1873,-10.0012 -15.3406,-11.3784 -12.0719,-17.777 -11.1479,-19.9125 -10.3089,-21.9026 -9.8958,-23.3099 -9.7316,-24.4732 -9.4316,-24.7774 -8.6838,-24.9999 -0.8,-24.9999 -0.8,-15.8802 0.8,-15.8802 0.8,-24.9998 5.6669,-24.9998 6.3699,-24.8858 6.9818,-24.5172 7.4284,-24.07 13.0499,-18.7437 13.049,-23.6727 12.6125,-24.0796 12.5936,-20.4963 12.6125,-24.0796 7.4284,-24.07 13.2207,-18.5818 15.8552,-15.7422 17.8482,-13.2995 19.8206,-9.913 20.8437,-7.292 21.5329,-4.4455 21.8005,-2.0944 21.9,0.0001 21.8005,2.0946 21.5329,4.4457 20.8437,7.2922 19.8206,9.9132 17.8482,13.2997 15.8552,15.7424 13.2207,18.582 7.4284,24.0702 12.6125,24.0798 12.5936,20.4965 12.6125,24.0798 13.049,23.6729 13.0499,18.7439 7.4284,24.0702 6.9818,24.5174 6.3699,24.886 5.6669,25 0.8,25 0.8,15.8804 4.18,15.3448 7.4163,14.0676 10.1772,12.2159 12.523,9.7973 14.299,6.9605 15.506,3.5323 15.9,0.0001 15.506,-3.5321 14.299,-6.9603 12.523,-9.7971 10.1772,-12.2157 7.4163,-14.0674 4.18,-15.3446 0.8,-15.8802 -0.8,-15.8802 -3.4694,-15.544 -6.2265,-14.634 -9.2433,-12.9378 -11.6453,-10.8246 -13.5388,-8.3403 -14.8801,-5.6139 -15.6719,-2.6977 -15.9,0.0001 -15.6719,2.6979 -14.8801,5.6141 -13.5388,8.3405 -11.6453,10.8248 -9.2433,12.938 -6.2265,14.6342 -3.4694,15.5442 -0.8,15.8804 0.8,15.8804 -0.8,15.8804 -0.8,25.0001 -8.6838,25.0001 -9.3776,24.6754 -9.7467,23.9553 -9.8958,23.3101 -10.3089,21.9028 -11.1479,19.9127 -12.0719,17.7772 -15.3406,11.3786 -16.1873,10.0014 -17.4384,9.0429 -18.8336,8.3574 -17.4384,9.0429 -16.1873,10.0014 -15.3406,11.3786 -12.0719,17.7772 -11.1479,19.9127 -10.3089,21.9028 -9.8958,23.3101 -9.7467,23.9553 -11.1307,22.117 -13.8952,19.3455 -16.8889,17.4875 -20.7048,17 "

								set polygon			[ string map {"," " "}  $clamp_SVGPolygon ]
								set polygon			[ coords_flip_y $polygon]
								#foreach {x y} $polygonSVG { set polygon [lappend polygon [expr $x + $HandleBar(Distance)] [expr -$y + $HandleBar(Height)] ]  };# the clamp					
								set polygon 		[ coords_addVector $polygon [list $HandleBar(Distance) $HandleBar(Height)] ]
								set polygon			[ vectormath::rotatePointList $frameCoords::HandleBar $polygon $angle ]
							
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
							set pt_51			[ vectormath::addVector	$pt_50	[ vectormath::unifyVector {0 0} $frameCoords::HeadTube(direction) 2] ]
							set pt_005			[ vectormath::intersectPoint [lindex $vct_000 0] [lindex $vct_000 1]  [lindex $vct_010 0] [lindex $vct_010 1] ]
							set pt_12			[ vectormath::intersectPerp	$pt_01 $pt_02 $pt_005 ]
							set pt_11			[ vectormath::addVector	$pt_12 [ vectormath::unifyVector {0 0} $frameCoords::HeadTube(direction) -2] ]
							set vct_020			[ vectormath::parallel $pt_11 $pt_51 [expr 0.5 * $stemDiameter ] ]
							set vct_021			[ vectormath::parallel $pt_11 $pt_51 [expr 0.5 * $stemDiameter ] left ]
							set vct_030			[ vectormath::parallel $frameCoords::HeadSet(Stem) $pt_51 [expr 0.5 * $HeadSet(ShimDiameter) ] ];# ShimDiameter from HeadSet definition above
							set vct_031			[ vectormath::parallel $frameCoords::HeadSet(Stem) $pt_51 [expr 0.5 * $HeadSet(ShimDiameter) ] left ]
							set vct_040			[ vectormath::parallel [lindex  $vct_021 1] [lindex  $vct_020 1] 5  left]
							
							set polygon			[ lappend polygon 	$pt_005 \
																	[lindex  $vct_020 0] [lindex  $vct_021 0] [lindex  $vct_020 0] \
																	[lindex  $vct_030 0] [lindex  $vct_031 0] [lindex  $vct_021 0] \
																	[lindex  $vct_021 1] [lindex  $vct_020 1] [lindex  $vct_021 1] \
																	[lindex  $vct_040 0] [lindex  $vct_040 1] [lindex  $vct_020 1] \
																	$pt_095 ]
					set frameCoords::Stem(polygon) 					[canvasCAD::flatten_nestedList $polygon]
			}
			get_Stem
			
				#
				# --- set RearBrakeMount ------------------
			proc get_RearBrakeMount {} {
					variable HeadTube
					variable RearBrake
					variable RearWheel

							set brakeShoeDist	30
							set pt_00			$frameCoords::RearWheel
							set pt_01					[ frame_geometry_custom::coords_get_xy $frameCoords::SeatStay(polygon) 8 ]
							set pt_02					[ frame_geometry_custom::coords_get_xy $frameCoords::SeatStay(polygon) 9 ]
							set RimBrakeRadius	[ expr 0.5 * $RearWheel(RimDiameter) ]
							set pt_03			[ vectormath::intersectPerp	$pt_02 $pt_01 $pt_00 ]	;# point on SeatStay through RearWheel
							set vct_01			[ vectormath::parallel $pt_01 $pt_03 $brakeShoeDist ]
							set pt_04			[ lindex $vct_01 1 ]
								# puts "   -> pt_04:  $pt_04   \n"
							set dist_00			[ vectormath::length $pt_00 $pt_04 ]
								# puts "   -> $$RearWheel(RimDiameter)    -> $RimBrakeRadius    -> dist_00:  $dist_00 \n"
							set dist_00_Ortho	[ expr sqrt(pow($RimBrakeRadius,2)  - pow($dist_00,2)) ]
					set frameCoords::RearBrakeShoe	[ vectormath::addVector	$pt_04 [ vectormath::unifyVector {0 0} $frameCoords::SeatStay(direction) $dist_00_Ortho] ]
					set frameCoords::RearBrakeHelp	[ vectormath::addVector	$pt_04 [ vectormath::unifyVector {0 0} $frameCoords::SeatStay(direction) [expr $RearBrake(LeverLength) + $dist_00_Ortho] ] ]
					set frameCoords::RearBrakeMount	[ vectormath::addVector	$pt_03 [ vectormath::unifyVector {0 0} $frameCoords::SeatStay(direction) [expr $RearBrake(LeverLength) + $dist_00_Ortho] ] ]
			}
			get_RearBrakeMount
			
				#
				# --- set FrontBrakeMount -----------------
			proc get_FrontBrakeMount {} {
					variable Fork
					variable FrontBrake

							set brakeShoeDist	30
							set pt_00			$frameCoords::Steerer_Fork
							set pt_01			[ vectormath::addVector	$pt_00 [ vectormath::unifyVector {0 0} $frameCoords::HeadTube(direction) -$Fork(BrakeOffsetPerp)] ]
							set vct_01			[ vectormath::parallel  $pt_00 $pt_01 $Fork(BrakeOffset) left]
							set pt_10			[ lindex $vct_01 1]
							set pt_11			[ vectormath::addVector	$pt_10 [ vectormath::unifyVector {0 0} $frameCoords::HeadTube(direction) -$FrontBrake(LeverLength)] ] 
							set pt_12			[ vectormath::rotatePoint	$pt_10	$pt_11	$Fork(BrakeAngle) ]
							set vct_02			[ vectormath::parallel  $pt_10 $pt_12 $brakeShoeDist left]
					set frameCoords::FrontBrakeMount	$pt_10		
					set frameCoords::FrontBrakeHelp		[ lindex $vct_02 0]
					set frameCoords::FrontBrakeShoe		[ lindex $vct_02 1]
			}
			get_FrontBrakeMount
			
				#
				# --- set FrameJig ------------------------
			proc get_FrameJig {} {
							set pt_00			$frameCoords::RearWheel
							set pt_01			$frameCoords::Steerer(Stem)
							set pt_02			$frameCoords::Steerer_Fork
							set pt_03			$frameCoords::Saddle
							set pt_04			{0 0}
							set pt_10			[ vectormath::intersectPerp		$pt_01 $pt_02 $pt_00 ]
							set pt_11			[ vectormath::intersectPoint	$pt_00 $pt_10 $pt_03 $pt_04 ]
					set frameCoords::FrameJig_HeadTube		$pt_10
					set frameCoords::FrameJig_SeatTube		$pt_11
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

							set dir 		[ vectormath::addVector {0 0} $frameCoords::HeadTube(direction) -1] 
					set frameCoords::TopTube_Head(mitter) 		[ tube_mitter	$TopTube(DiameterHT) $frameCoords::TopTube(direction)	$HeadTube(Diameter)		$frameCoords::HeadTube(direction)  $frameCoords::TopTube(HeadTube)  ]	
					set frameCoords::TopTube_Seat(mitter) 		[ tube_mitter	$TopTube(DiameterST) $frameCoords::TopTube(direction)	$SeatTube(DiameterTT)	$dir  							   $frameCoords::TopTube(SeatTube)  ]	
					set frameCoords::DownTube_Head(mitter) 		[ tube_mitter	$DownTube(DiameterHT) $frameCoords::DownTube(direction)	$HeadTube(Diameter)		$frameCoords::HeadTube(direction)  $frameCoords::DownTube(HeadTube) ]				
							set offset		[ expr 0.5 * ($SeatTube(DiameterTT) - $SeatStay(DiameterST)) ]
							set dir 		[ vectormath::addVector {0 0} $frameCoords::SeatStay(direction) -1] 
					set frameCoords::SeatStay_01(mitter) 		[ tube_mitter	$SeatStay(DiameterST) $dir  $SeatTube(DiameterTT)	  $frameCoords::SeatTube(direction)  $frameCoords::SeatStay(SeatTube)  right -$offset]	
					set frameCoords::SeatStay_02(mitter) 		[ tube_mitter	$SeatStay(DiameterST) $dir  $SeatTube(DiameterTT)	  $frameCoords::SeatTube(direction)  $frameCoords::SeatStay(SeatTube)  right +$offset]	
			}
			get_TubeMitter
				
				
			# puts " ... done"
		


					#$pt_12 $pt_11 $pt_51 $pt_50 $pt_095 ]
					#set polygon			[ lappend polygon $pt_005 $pt_12 $pt_11 $pt_50 $pt_095 ]
					
						# puts " \n =========\n"
						# puts " stemWidth: $stemWidth"
					#puts " angle: $frameCoords::Stem(direction)"
					
					#puts " Stem(polygon): 00  $polygon"
					#puts " Stem(polygon): 01  $polygon"
		#set HeadSet(Diameter)		[ [ $domConfig selectNodes /root/Component/HeadSet/Diameter			]  asText ]
		#set HeadSet(Height) 		[ [	$domConfig selectNodes /root/Component/HeadSet/Bottom_Heigth	]  asText ]


	}


 	#-------------------------------------------------------------------------
		#  return BottomBracket coords 
	proc get_BottomBracket_Position {cv_Name bottomCanvasBorder {option {bicycle}} {stageScale {}}} {
						
			variable  RearWheel
			variable  FrontWheel
			variable  BottomBracket
			
			array set Stage {}		
		
			set SummaryLength		[ lindex $frameCoords::FrameSize 0 ]
			if {$option == {bicycle}} {
				set SummaryLength	[ expr $SummaryLength + 2 * $RearWheel(Radius) ]
			}

				#
				# --- get canvasCAD-Stage information
			set Stage(width)		[ eval $cv_Name getNodeAttr Stage  width  ]
			set Stage(scale_curr) 	[ eval $cv_Name getNodeAttr Stage  scale ] 		
			if {$stageScale != {}} {
					set Stage(scale)		$stageScale
			} else {
					set Stage(scale)		[ expr 0.8 * $Stage(width) / $SummaryLength ]
			}
			set Stage(scale_fmt)  	[ format "%.2f" $Stage(scale) ]	
			
				#
				# --- reset canvasCAD - scale to fit the content
			$cv_Name	setNodeAttr Stage	scale 	$Stage(scale_fmt)
		
				#
				# ---  get unscaled width of Stage 		
			set Stage(unscaled)		[ expr ($Stage(width))/$Stage(scale_fmt) ]
			
				#
				# ---  get border outside content to Stage		
			set border				[ expr  0.5 *( $Stage(unscaled) - $SummaryLength ) ]
			
				#
				# ---  get left/right/bottom border outside content to Stage		
			set cvBorder			[ expr $bottomCanvasBorder/$Stage(scale_fmt) ]			
			
				#
				# ---  get baseLine Coordinates  					
			if {$option == {bicycle}} {
				set BtmBracket_x		[ expr $border + $RearWheel(Radius) + $RearWheel(Distance_X) ] 
				set BtmBracket_y		[ expr $cvBorder + $RearWheel(Radius) - $BottomBracket(depth) ] 
					# puts "\n -> get_BottomBracket_Position:  $cvBorder + $RearWheel(Radius) - $BottomBracket(depth) " 
					# puts "\n -> get_BottomBracket_Position:  $BtmBracket_x $BtmBracket_y \n" 
			} else {
				set BtmBracket_x		[ expr $border + $RearWheel(Distance_X) ] 
				set BtmBracket_y		$cvBorder
					# set BtmBracket_y		[ expr $bottomCanvasBorder + 50 ]
					# puts "\n -> get_BottomBracket_Position:  $cvBorder " 
					# puts "\n -> get_BottomBracket_Position:  $BtmBracket_x $BtmBracket_y \n" 
			}
			
			return [list $BtmBracket_x $BtmBracket_y]
	
	}

	
 	#-------------------------------------------------------------------------
		#  return all geometry-values to create specified tube in absolute position
	proc tube_values {tube index {centerPoint {0 0}}} {
			eval set value $[format "frameCoords::%s(%s)" $tube $index]
			return [ coords_addVector  $value  $centerPoint]
	}

 	#-------------------------------------------------------------------------
		#  return all point-values in absolute position
	proc point_position {point centerPoint } {
			eval set value $[format "frameCoords::%s" $point]
			return [ coords_addVector  $value  $centerPoint]
	}

 	#-------------------------------------------------------------------------
		#  return project attributes
	proc project_attribute {attribute } {
			variable Project
			return $Project($attribute)
	}

 	#-------------------------------------------------------------------------
		#  add vector to list of coordinates
 	proc coords_addVector {coordlist vector} {
			set returnList {}
			set vector_x [lindex $vector 0]
			set vector_y [lindex $vector 1]
			foreach {x y} $coordlist {
				set new_x [expr $x + $vector_x]
				set new_y [expr $y + $vector_y]
				set returnList [lappend returnList $new_x $new_y]
			}
			return $returnList
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
			set cut_perp	[expr sqrt($radius_isect*$radius_isect - $r1_y*$r1_y) ]
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
		set coordList 	[list 0.5*$perimeter -70]
		while {$angle <= 180} {
				set rad_Angle 	[vectormath::rad $angle]
				set x [expr $diameter*[vectormath::rad 180]*$angle/360 ]
			 
				set h [expr $offset + $radius*sin($rad_Angle)]
				set b [expr $diameter*0.5*cos($rad_Angle)]
			 
				set l [expr sqrt(pow($radius_isect,2) - pow($h,2))]
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
				proc change_ValueEdit {cv_Name updateCommand textVar xpath cvEntr direction} {
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
								"[namespace current]::change_ValueEdit $cv_Name $updateCommand $textVar $xpath $cvEntry %d"
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

							proc createSelectBox {parent  values  target_var  cv_Name  updateCommand  xpath  cvEntry} {
						  
									variable _listBoxValues
									# puts "   ... createSelectBox  $cv_Name $updateCommand $xpath $cvEntry"
									# updateConfig {cv_Name updateCommand xpath cvEntry}
						  
									set _listBoxValues $values
									puts " _listBoxValues $_listBoxValues"
									set toplevel_widget  .__select_box							  
									if {[winfo exists $toplevel_widget]} {
										destroy $toplevel_widget
									}
							  
									toplevel  $toplevel_widget
									frame     $toplevel_widget.f
									pack      $toplevel_widget.f							  
									listbox   $toplevel_widget.f.lbox \
												  -listvariable   [namespace current]::_listBoxValues \
												  -selectmode     single \
												  -relief         sunken \
												  -width		  35 \
												  -yscrollcommand "$toplevel_widget.f.svert  set" 							  
									scrollbar $toplevel_widget.f.svert \
												  -orient         v \
												  -command        "$toplevel_widget.f.lbox yview"
							  							  
									pack $toplevel_widget.f.lbox $toplevel_widget.f.svert -side left -fill y
							  
									bind .                        <Configure>		[list [namespace current]::::bind_parent_move  $toplevel_widget  $parent]
									bind $toplevel_widget.f.lbox <<ListboxSelect>>	[list [namespace current]::::closeSelectBox    %W  $target_var $cv_Name $updateCommand $xpath $cvEntry]

									wm  overrideredirect  $toplevel_widget  1
									bind_parent_move      $toplevel_widget  $parent  
							   }

						#
						# --- create listBox content ---
						set listBoxContent {}
						case $type {
								{fileList} {
										eval set currentFile $[namespace current]::_updateValue($xpath)
										set dir 		[file join $::APPL_Env(CONFIG_Dir)/components [file dirname $currentFile] ]
										puts "currentFile $currentFile"
										puts "dir $dir"
										set fileList	[ glob -directory $dir *.svg ]
										puts "fileList $fileList"
										foreach value $fileList {
											puts "   -> $value"
											set fileString [ string map [list $::APPL_Env(CONFIG_Dir)/components/ {} ] $value ]
											puts "    -> fileString $fileString"
											set listBoxContent [ lappend listBoxContent $fileString ]
										}
										puts "--> $listBoxContent"
									}
						}
						#
						# --- create cvLabel, cvEntry, Select ---
							set cvFrame		[ frame 		$cvContentFrame.frame_${index} ]
							set	  cvLabel	[ label  		$cvFrame.label   -text "${labelText} : "]
							set   cvEntry 	[ entry  		$cvFrame.value   -justify left -textvariable [namespace current]::_updateValue($xpath)  -disabledbackground white  -disabledforeground black  -state disabled -justify right  -relief sunken -bd 1  -width 10]
							set   cvSelect	[ ArrowButton	$cvFrame.select  -dir bottom  -height 17 -width 20  -fg SlateGray  \
															-armcommand  "[namespace current]::createSelectBox $cvEntry  [list $listBoxContent]  [namespace current]::_updateValue($xpath) $cv_Name  $updateCommand  $xpath  $cvEntry" ]
															
							if {$index == {oneLine}} {
								set	cvUpdat [button $cvContentFrame.update -image $lib_gui::iconArray(confirm)]
								$cvUpdat configure -command \
									"[namespace current]::updateConfig $cv_Name $updateCommand $xpath $cvEntry"
								set	cvClose [ button 		$cvFrame.close   -image $lib_gui::iconArray(iconClose) -command "[namespace current]::closeEdit $cv $cvEdit"]
								grid	$cvLabel $cvEntry $cvSelect $cvClose -sticky news
								grid 	$cvFrame  -sticky news -padx 1 
							} else {																
								grid	$cvLabel $cvEntry $cvSelect 		 -sticky news
								grid 	configure $cvLabel   -padx 2 -sticky nws
								grid	columnconfigure 	$cvFrame 1 	-weight 1 
								grid 	$cvFrame  -sticky news -padx 1 -columnspan 2
							}
						#
						# --- define bindings ---
							bind $cvLabel	<ButtonPress-1> 			[list [namespace current]::dragStart 	%X %Y]
							bind $cvLabel	<B1-Motion> 				[list [namespace current]::drag 		%X %Y $cv $cvEdit]			
							bind $cvEntry	<Return> 					[list [namespace current]::updateConfig $cv_Name $updateCommand $xpath $cvEntry]			
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
					
					case $xpath {
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
							default {
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
						
						case $xpath {
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
							default {
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

 	#-------------------------------------------------------------------------
		#  close ProjectEdit Widget
	proc closeEdit {cv cvEdit} {
			$cv delete $cvEdit
			destroy $cvEdit
			catch [ destroy .__select_box ]
	}

 	#-------------------------------------------------------------------------
		#  update Project 
	proc updateConfig {cv_Name updateCommand xpath cvEntry} {
			variable _update
			variable _updateValue
			
				# puts "   --updateConfig-> $_updateValue($xpath) $xpath "
				# tk_messageBox -message " .... updateConfig:\n  ${xpath}: $value"
			set domDoc $::APPL_Project
			set node 		[$domDoc selectNodes /root/$xpath/text()]
			set nodeValue 	[$node asText]
			# --- check Value ---
			puts "    -> $_updateValue($xpath)"
			set newValue [ string map {, .} $_updateValue($xpath)]
			set _updateValue($xpath) $newValue
			# --- update or return on errorID
			if {[file tail $xpath] != {File}} {

				puts "  _update(loops) $_update(loops)"
				if { [catch { expr 1.0 * $newValue } errorID] } {
					puts "\n$errorID\n"
					focus $cvEntry
					$cvEntry selection range 0 end
					return
				} else {		
						# $_update(loops) is set to {1}, so lower if {... } does never run
					if {$_update(loops) > 1} {
						set loopValue $nodeValue
						set gap [expr 1.0*($newValue - $nodeValue)/$_update(loops)]
						if {[expr abs($gap)] > 0 } {
							while {$loopValue < $newValue } {
								set loopValue [ expr $loopValue + $gap ]
									puts "      --> $loopValue"
								$node nodeValue $loopValue
								frame_geometry_custom::set_base_Parameters $domDoc
								update
								after $_update(delay)
								$updateCommand $cv_Name
							}
						} else {
							while {$loopValue > $newValue } {
								set loopValue [ expr $loopValue + $gap ]
									puts "      --> $loopValue"
								$node nodeValue $loopValue
								frame_geometry_custom::set_base_Parameters $domDoc
								update
								after $_update(delay)
								$updateCommand $cv_Name
							}
						}
					}
				}
				
			}
			#
			# --- finaly update
				# why 2010 06 20 ?
			$node nodeValue $newValue
			frame_geometry_custom::set_base_Parameters $domDoc
			$updateCommand $cv_Name
			focus $cvEntry
			$cvEntry selection range 0 end

	} 

 	#-------------------------------------------------------------------------
		#  binding: dragStart
	proc dragStart {x y} {
			variable _drag
			set _drag(lastx) $x
			set _drag(lasty) $y
			puts "$x $y"
	}

 	#-------------------------------------------------------------------------
		#  binding: drag
	proc drag {x y cv id} {
			variable _drag 
			set dx [expr {$x - $_drag(lastx)}]
			set dy [expr {$y - $_drag(lasty)}]
			set cv_width  [ winfo width  $cv ]
			set cv_height [ winfo height $cv ]
			set id_bbox   [ $cv bbox $id ]
			if {[lindex $id_bbox 0] < 4} {set dx  1}
			if {[lindex $id_bbox 1] < 4} {set dy  1}
			if {[lindex $id_bbox 2] > [expr $cv_width  -4]} {set dx -1}
			if {[lindex $id_bbox 3] > [expr $cv_height -4]} {set dy -1}
			
			$cv move $id $dx $dy
			set _drag(lastx) $x
			set _drag(lasty) $y
	} 
 
 	#-------------------------------------------------------------------------
		#  create createSelectBox 

       proc bind_parent_move {toplevel_widget parent} {
            ::Debug  p  1
            if {![winfo exists $toplevel_widget]} return
            set toplevel_x    [winfo rootx $parent]
            set toplevel_y    [expr [winfo rooty $parent]+ [winfo reqheight $parent]]
            wm  geometry      $toplevel_widget +$toplevel_x+$toplevel_y
            wm  deiconify     $toplevel_widget
       }
      
       proc closeSelectBox {source_window  target_var  cv_Name  updateCommand  xpath  cvEntry} {
            
              variable CURRENT_Config

            ::Debug  p  1

            puts "   source_window $source_window"
            puts "       index: [$source_window curselection]"
            set  widget_value     [$source_window get [$source_window curselection]]
            puts "       value: $widget_value"
            
            if {[string range $widget_value 0 3] == {----} } {
                    # tk_messageBox -message " seperator:   $widget_value"
				destroy  [winfo toplevel $source_window]
				return
            }

            if {[string is wordchar $widget_value]} {
                    # tk_messageBox -message " alpha   $widget_value"
                  #set      CURRENT_Config($target_var)     $widget_value
				set $target_var $widget_value
            } else {
                    # tk_messageBox -message " integer   $widget_value"
                  #set      target_value    [expr 1.0 * [string trim [lindex [split $widget_value {;}] 1] { }] ]
                  #set      CURRENT_Config($target_var)     $target_value
                    # control::lock_check_value  $target_var  
                  #::Debug t     "  $target_var     $target_value"
				set $target_var $widget_value
            }
            
            puts "   control::update_parameter   $target_var"
			$cvEntry configure -state normal
			#focus $cvEntry
			$cvEntry icursor  end
			[namespace current]::updateConfig $cv_Name $updateCommand $xpath $cvEntry
              # control::update_graph    
            destroy  [winfo toplevel $source_window]
       }

 
 }  

